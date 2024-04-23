#pragma once

#define MESSAGE_BUFFER_SIZE 8192
#define SERVER_QUEUE_NAME   "/tmp/chat_server_queue"

#define CLIENT_QUEUE_NAME_SIZE 40
#define MAX_CLIENTS_COUNT      40

typedef enum { INIT, IDENTIFIER, MESSAGE_TEXT } message_type_t;

typedef struct {
    message_type_t type;

    int identifier;
    char text[MESSAGE_BUFFER_SIZE];
} message_t;
