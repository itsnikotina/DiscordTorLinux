#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <dlfcn.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <ctype.h>
#include <time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <poll.h>

#define MAX_PATH_LEN 1024
#define DISCORD_UDP_HANDSHAKE_LEN 74

/* Original libc function pointers */
static ssize_t (*real_sendto)(int sockfd, const void *buf, size_t len, int flags,
                              const struct sockaddr *dest_addr, socklen_t addrlen) = NULL;
static ssize_t (*real_send)(int sockfd, const void *buf, size_t len, int flags) = NULL;
static ssize_t (*real_recv)(int sockfd, void *buf, size_t len, int flags) = NULL;

/* Proxy config */
typedef struct {
    int specified;
    int is_http;
    int is_socks5;
    char protocol[32];
    char host[256];
    int port;
    char user[128];
    char pass[128];
    char chrome_proxy_str[1024];
} proxy_config_t;

static proxy_config_t g_proxy;
static char g_packet_path[MAX_PATH_LEN] = {0};
static pthread_mutex_t g_init_mutex = PTHREAD_MUTEX_INITIALIZER;
static int g_initialized = 0;

static void trim(char *s) {
    char *p = s;
    while (isspace((unsigned char)*p)) p++;
    if (p != s) memmove(s, p, strlen(p) + 1);
    size_t len = strlen(s);
    while (len > 0 && isspace((unsigned char)s[len - 1])) {
        s[--len] = '\0';
    }
}

static void parse_proxy_string(const char *raw_proxy, proxy_config_t *cfg) {
    memset(cfg, 0, sizeof(*cfg));
    if (!raw_proxy || !*raw_proxy) return;

    char buf[512];
    snprintf(buf, sizeof(buf), "%s", raw_proxy);
    trim(buf);
    if (!*buf) return;

    char *p = buf;
    char proto[32] = "http";

    char *scheme_sep = strstr(p, "://");
    if (scheme_sep) {
        *scheme_sep = '\0';
        snprintf(proto, sizeof(proto), "%.31s", p);
        p = scheme_sep + 3;
    }

    for (int i = 0; proto[i]; i++) {
        proto[i] = tolower((unsigned char)proto[i]);
    }

    char *at = strchr(p, '@');
    char user[128] = {0};
    char pass[128] = {0};
    if (at) {
        *at = '\0';
        char *colon = strchr(p, ':');
        if (colon) {
            *colon = '\0';
            snprintf(user, sizeof(user), "%.127s", p);
            snprintf(pass, sizeof(pass), "%.127s", colon + 1);
        } else {
            snprintf(user, sizeof(user), "%.127s", p);
        }
        p = at + 1;
    }

    char host[256] = {0};
    int port = 0;
    char *colon = strrchr(p, ':');
    if (colon) {
        *colon = '\0';
        snprintf(host, sizeof(host), "%.255s", p);
        port = atoi(colon + 1);
    } else {
        snprintf(host, sizeof(host), "%.255s", p);
        port = (strcmp(proto, "socks5") == 0) ? 1080 : 80;
    }

    if (port <= 0 || !*host) return;

    cfg->specified = 1;
    snprintf(cfg->protocol, sizeof(cfg->protocol), "%s", proto);
    snprintf(cfg->host, sizeof(cfg->host), "%s", host);
    cfg->port = port;
    snprintf(cfg->user, sizeof(cfg->user), "%s", user);
    snprintf(cfg->pass, sizeof(cfg->pass), "%s", pass);

    cfg->is_http = (strcmp(proto, "http") == 0 || strcmp(proto, "https") == 0);
    cfg->is_socks5 = (strcmp(proto, "socks5") == 0);

    snprintf(cfg->chrome_proxy_str, sizeof(cfg->chrome_proxy_str), "%s://%s:%d",
             cfg->protocol, cfg->host, cfg->port);
}

static void load_config(void) {
    const char *candidates[8];
    int cand_count = 0;

    char *env_val = getenv("DROVER_CONFIG_DIR");
    char env_dir[MAX_PATH_LEN] = {0};
    if (env_val && *env_val) {
        snprintf(env_dir, sizeof(env_dir), "%s", env_val);
        candidates[cand_count++] = env_dir;
    }

    char home_config[MAX_PATH_LEN] = {0};
    char *home = getenv("HOME");
    if (home) {
        snprintf(home_config, sizeof(home_config), "%s/.config/discord", home);
        candidates[cand_count++] = home_config;
    }

    candidates[cand_count++] = ".";

    char ini_path[MAX_PATH_LEN] = {0};
    FILE *fp = NULL;

    for (int i = 0; i < cand_count; i++) {
        snprintf(ini_path, sizeof(ini_path), "%s/drover.ini", candidates[i]);
        fp = fopen(ini_path, "r");
        if (fp) break;
    }

    if (fp) {
        char line[512];
        char proxy_str[512] = {0};
        while (fgets(line, sizeof(line), fp)) {
            trim(line);
            if (line[0] == '#' || line[0] == ';' || line[0] == '[') continue;
            char *eq = strchr(line, '=');
            if (eq) {
                *eq = '\0';
                char *key = line;
                char *val = eq + 1;
                trim(key);
                trim(val);
                if (strcasecmp(key, "proxy") == 0) {
                    snprintf(proxy_str, sizeof(proxy_str), "%s", val);
                }
            }
        }
        fclose(fp);
        parse_proxy_string(proxy_str, &g_proxy);
    }

    /* Check packet file in candidate directories */
    for (int i = 0; i < cand_count; i++) {
        char ppath[MAX_PATH_LEN];
        snprintf(ppath, sizeof(ppath), "%s/drover-packet.bin", candidates[i]);
        if (access(ppath, R_OK) == 0) {
            snprintf(g_packet_path, sizeof(g_packet_path), "%s", ppath);
            break;
        }
    }
}

static void init_drover(void) {
    pthread_mutex_lock(&g_init_mutex);
    if (g_initialized) {
        pthread_mutex_unlock(&g_init_mutex);
        return;
    }

    real_sendto = dlsym(RTLD_NEXT, "sendto");
    real_send = dlsym(RTLD_NEXT, "send");
    real_recv = dlsym(RTLD_NEXT, "recv");

    load_config();
    g_initialized = 1;
    pthread_mutex_unlock(&g_init_mutex);
}

__attribute__((constructor))
static void drover_ctor(void) {
    init_drover();
}

/* UDP Voice Bypass Helper */
static void perform_udp_manipulation(int sockfd, const struct sockaddr *dest_addr, socklen_t addrlen) {
    /* If drover-packet.bin exists, send its contents first */
    if (g_packet_path[0] != '\0') {
        int pfd = open(g_packet_path, O_RDONLY);
        if (pfd >= 0) {
            char pbuf[4096];
            ssize_t pr = read(pfd, pbuf, sizeof(pbuf));
            close(pfd);
            if (pr > 0 && real_sendto) {
                real_sendto(sockfd, pbuf, (size_t)pr, 0, dest_addr, addrlen);
            }
        }
    }

    /* Send byte 0x00 */
    uint8_t payload = 0;
    if (real_sendto) {
        real_sendto(sockfd, &payload, 1, 0, dest_addr, addrlen);
    }

    /* Send byte 0x01 */
    payload = 1;
    if (real_sendto) {
        real_sendto(sockfd, &payload, 1, 0, dest_addr, addrlen);
    }

    /* Sleep 50ms */
    usleep(50000);
}

/* Intercepted Functions */

ssize_t sendto(int sockfd, const void *buf, size_t len, int flags,
               const struct sockaddr *dest_addr, socklen_t addrlen) {
    if (!g_initialized) init_drover();

    /* Only intercept Internet UDP packets (AF_INET/AF_INET6) matching Discord Voice handshake */
    if (dest_addr && addrlen >= sizeof(struct sockaddr_in)) {
        if ((dest_addr->sa_family == AF_INET || dest_addr->sa_family == AF_INET6) &&
            (len == DISCORD_UDP_HANDSHAKE_LEN)) {
            perform_udp_manipulation(sockfd, dest_addr, addrlen);
        }
    }

    return real_sendto ? real_sendto(sockfd, buf, len, flags, dest_addr, addrlen) : -1;
}

ssize_t send(int sockfd, const void *buf, size_t len, int flags) {
    if (!g_initialized) init_drover();
    return real_send ? real_send(sockfd, buf, len, flags) : -1;
}

ssize_t recv(int sockfd, void *buf, size_t len, int flags) {
    if (!g_initialized) init_drover();
    return real_recv ? real_recv(sockfd, buf, len, flags) : -1;
}
