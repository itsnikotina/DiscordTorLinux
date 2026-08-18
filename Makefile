CC ?= gcc
CFLAGS ?= -O2 -Wall -Wextra -fPIC -fvisibility=hidden
LDFLAGS ?= -shared -ldl -lpthread

TARGET = libdrover.so
SRCS = drover.c

all: $(TARGET)

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) -fvisibility=default $(SRCS) $(LDFLAGS) -o $(TARGET)

clean:
	rm -f $(TARGET) test_udp test_proxy

.PHONY: all clean
