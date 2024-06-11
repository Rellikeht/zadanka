#include <netinet/in.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#include "msg_types.h"

#define UNUSED(x) (void)(x)

int client_sock, in_server_sock;
struct sockaddr_in server_addr = {0};
struct message_t in_message, out_message;

char *username;

volatile int break_loop_sender = FALSE, break_loop_receiver = FALSE;
void sigint_handler(int signum) {
    UNUSED(signum);
    break_loop_sender = TRUE;
}

void *sender_handler(void *args) {
    UNUSED(args);

    strcpy(out_message.sender_name, username);
    out_message.sender_id = in_server_sock;
    char cmd[MAX_STRING_LENGTH];
    while (break_loop_sender == FALSE) {
        fgets(cmd, MAX_STRING_LENGTH, stdin);

        if (strcmp(cmd, "LIST\n") == 0) {
            out_message.type = LIST;
            sendto(
                client_sock,
                &out_message,
                sizeof(out_message),
                0,
                (struct sockaddr *)&server_addr,
                sizeof(server_addr)
            );
        } else if (strcmp(cmd, "2ALL\n") == 0) {
            out_message.type = TO_ALL;
            printf("What's the message you would like to send?\n");
            fgets(out_message.message, MAX_STRING_LENGTH, stdin);
            out_message.message[strlen(out_message.message) - 1] =
                '\0';
            out_message.sending_time = time(NULL);
            sendto(
                client_sock,
                &out_message,
                sizeof(out_message),
                0,
                (struct sockaddr *)&server_addr,
                sizeof(server_addr)
            );
        } else if (strcmp(cmd, "2ONE\n") == 0) {
            out_message.type = TO_ONE;
            printf("Please provide an ID of the other client and "
                   "the message you would like to send.\n");
            scanf("%d\n", &out_message.receiver_socket);
            fgets(out_message.message, MAX_STRING_LENGTH, stdin);
            out_message.message[strlen(out_message.message) - 1] =
                '\0';
            out_message.sending_time = time(NULL);
            sendto(
                client_sock,
                &out_message,
                sizeof(out_message),
                0,
                (struct sockaddr *)&server_addr,
                sizeof(server_addr)
            );
        } else if (strcmp(cmd, "STOP\n") == 0) {
            out_message.type = STOP;
            sendto(
                client_sock,
                &out_message,
                sizeof(out_message),
                0,
                (struct sockaddr *)&server_addr,
                sizeof(server_addr)
            );
        } else if (strcmp(cmd, "ALIVE\n") == 0) {
            out_message.type = ALIVE;
            sendto(
                client_sock,
                &out_message,
                sizeof(out_message),
                0,
                (struct sockaddr *)&server_addr,
                sizeof(server_addr)
            );
        } else if (break_loop_sender == TRUE) {
            out_message.type = INTERNAL_EXIT;
            sendto(
                client_sock,
                &out_message,
                sizeof(out_message),
                0,
                (struct sockaddr *)&server_addr,
                sizeof(server_addr)
            );
            break;
        } else
            printf("The command you provided is not supported. "
                   "Please try again.\n");
    }
    printf("Exiting writing mode...\n");
    return (void *)0;
}

void receiver_handler(void *args) {
    UNUSED(args);

    while (break_loop_receiver == FALSE) {
        ssize_t count = recvfrom(
            client_sock, &in_message, sizeof(in_message), 0, NULL, 0
        );
        if (count > 0) {
            switch (in_message.type) {
            case DFL:
                printf(
                    "Server response: %.*s",
                    (int)count,
                    in_message.message
                );
                break;
            case INTERNAL_EXIT:
                break_loop_receiver = TRUE;
                break_loop_sender = TRUE;
                break;
            default:
                struct tm tm = *localtime(&in_message.sending_time);
                printf(
                    "Received a message from user %d at "
                    "%d-%02d-%02d %02d:%02d:%02d\n",
                    in_message.sender_id,
                    tm.tm_year + 1900,
                    tm.tm_mon + 1,
                    tm.tm_mday,
                    tm.tm_hour,
                    tm.tm_min,
                    tm.tm_sec
                );
                printf("Message: %s\n", in_message.message);
                break;
            }
        }
        if (count == 0) {
            printf("Server stopped responding.\n");
            break_loop_sender = TRUE;
            break;
        }
    }
    printf("Exiting listening process...\n");
    return (void *)0;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Wrong number of arguments provided. Exiting...\n");
        return 1;
    }

    int PORT = strtol(argv[2], NULL, 10);
    if (PORT > 0 && PORT <= 1024) {
        printf("Invalid port number provided. Exiting...\n");
        return 1;
    }

    username = argv[1];

    signal(SIGINT, sigint_handler);

    client_sock = socket(AF_INET, SOCK_DGRAM, 0);

    /* Configure the server details */
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);

    struct message_t init_message;
    init_message.type = USR;
    strcpy(init_message.message, username);

    sendto(
        client_sock,
        &init_message,
        sizeof(init_message),
        0,
        (struct sockaddr *)&server_addr,
        sizeof(server_addr)
    );

    recvfrom(
        client_sock, &init_message, sizeof(init_message), 0, NULL, 0
    );
    printf("%s", init_message.message);
    in_server_sock = init_message.receiver_socket;

    pthread_t sender, receiver;
    pthread_create(&sender, NULL, sender_handler, NULL);
    pthread_create(&receiver, NULL, receiver_handler, NULL);

    pthread_join(sender, NULL);
    pthread_join(receiver, NULL);

    printf("Exiting program...\n");
    close(client_sock);

    return 0;
}
