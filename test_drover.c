#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <pthread.h>
#include <assert.h>
#include <time.h>

#define UDP_TEST_PORT 19532

static int g_udp_packets_received = 0;
static size_t g_udp_packet_lens[10];
static uint8_t g_udp_packet_data[10][2048];

static void *udp_receiver_thread(void *arg) {
    (void)arg;
    int sfd = socket(AF_INET, SOCK_DGRAM, 0);
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(UDP_TEST_PORT);
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

    int opt = 1;
    setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    if (bind(sfd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        perror("bind udp receiver");
        close(sfd);
        return NULL;
    }

    struct timeval tv = { .tv_sec = 2, .tv_usec = 0 };
    setsockopt(sfd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));

    while (g_udp_packets_received < 10) {
        uint8_t buf[2048];
        ssize_t n = recvfrom(sfd, buf, sizeof(buf), 0, NULL, NULL);
        if (n <= 0) break;
        int idx = g_udp_packets_received++;
        g_udp_packet_lens[idx] = n;
        memcpy(g_udp_packet_data[idx], buf, n);
    }
    close(sfd);
    return NULL;
}

static void test_udp_bypass(void) {
    printf("[*] Testing UDP voice manipulation...\n");
    pthread_t th;
    pthread_create(&th, NULL, udp_receiver_thread, NULL);
    usleep(100000); // Give receiver time to bind

    int client_sock = socket(AF_INET, SOCK_DGRAM, 0);
    struct sockaddr_in dest;
    memset(&dest, 0, sizeof(dest));
    dest.sin_family = AF_INET;
    dest.sin_port = htons(UDP_TEST_PORT);
    dest.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

    uint8_t handshake_74[74];
    memset(handshake_74, 0xAB, sizeof(handshake_74));

    struct timespec t0, t1;
    clock_gettime(CLOCK_MONOTONIC, &t0);

    ssize_t sent = sendto(client_sock, handshake_74, sizeof(handshake_74), 0,
                          (struct sockaddr *)&dest, sizeof(dest));
    clock_gettime(CLOCK_MONOTONIC, &t1);

    long elapsed_ms = (t1.tv_sec - t0.tv_sec) * 1000 + (t1.tv_nsec - t0.tv_nsec) / 1000000;
    printf("[*] sendto elapsed time: %ld ms\n", elapsed_ms);
    assert(sent == sizeof(handshake_74));
    assert(elapsed_ms >= 45); // At least ~50ms sleep was triggered

    pthread_join(th, NULL);
    close(client_sock);

    printf("[*] Packets received by listener: %d\n", g_udp_packets_received);
    for (int i = 0; i < g_udp_packets_received; i++) {
        printf("    Packet %d: %zu bytes (first byte: 0x%02X)\n",
               i, g_udp_packet_lens[i], g_udp_packet_data[i][0]);
    }

    assert(g_udp_packets_received == 4);
    assert(g_udp_packet_lens[0] == 1200);
    assert(g_udp_packet_lens[1] == 1 && g_udp_packet_data[1][0] == 0x00);
    assert(g_udp_packet_lens[2] == 1 && g_udp_packet_data[2][0] == 0x01);
    assert(g_udp_packet_lens[3] == 74 && g_udp_packet_data[3][0] == 0xAB);

    printf("[+] UDP voice bypass test PASSED!\n");
}

int main(void) {
    test_udp_bypass();
    printf("\n>>> ALL TESTS PASSED SUCCESSFULLY! <<<\n");
    return 0;
}
