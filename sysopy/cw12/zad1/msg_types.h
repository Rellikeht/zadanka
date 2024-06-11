#pragma once

#include "netinet/in.h"

#define MAX_CLIENTS       10
#define MAX_EVENTS        10
#define MAX_STRING_LENGTH 1024

enum msg_type {
    DFL,
    LIST,
    TO_ALL,
    TO_ONE,
    STOP,
    ALIVE,
    USR,
    INTERNAL_EXIT
};

struct message_t {
    enum msg_type type;
    char sender_name[MAX_STRING_LENGTH];
    int sender_id;
    int receiver_socket;
    time_t sending_time;
    char message[MAX_STRING_LENGTH];
};

struct client_t {
    int isFree;
    struct sockaddr_in address;
    char username[MAX_STRING_LENGTH];
};
