#include <netinet/in.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/epoll.h>
#include <sys/socket.h>
#include <unistd.h>

#include "msg_types.h"

#define UNUSED(x) (void)(x)

volatile int break_loop = FALSE;
void sigint_handler(int signum) {
    UNUSED(signum);
    break_loop = TRUE;
}

struct client_t clients[MAX_CLIENTS];

int find_free_client() {
    for (int i = 0; i < MAX_CLIENTS; i++) {
        if (clients[i].isFree == TRUE) {
            return i;
        }
    }
    return -1;
}

void list_clients() {
    for (int i = 0; i < MAX_CLIENTS; i++) {
        if (clients[i].isFree == FALSE) {
            printf(
                "Username: %s, ID: %d \n", clients[i].username, i
            );
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Wrong number of arguments provided. Exiting...\n");
        return 1;
    }

    int PORT = strtol(argv[1], NULL, 10);
    if (PORT > 0 && PORT <= 1024) {
        printf("Invalid port number provided. Exiting...\n");
        return 1;
    }

    signal(SIGINT, sigint_handler);

    for (int i = 0; i < MAX_CLIENTS; i++) {
        clients[i].isFree = TRUE;
    }

    struct epoll_event ev, events[MAX_EVENTS];
    int listen_sock, nfds, epollfd; //, conn_sock;

    listen_sock = socket(AF_INET, SOCK_DGRAM, 0);

    /* Configure it to listen on 12345 port on all available IPs */
    struct sockaddr_in server_addr = {0};
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    bind(
        listen_sock,
        (struct sockaddr *)&server_addr,
        sizeof(server_addr)
    );

    epollfd = epoll_create1(0);
    if (epollfd == -1) {
        perror("epoll_create1");
        exit(EXIT_FAILURE);
    }

    ev.events = EPOLLIN;
    ev.data.fd = listen_sock;
    if (epoll_ctl(epollfd, EPOLL_CTL_ADD, listen_sock, &ev) == -1) {
        perror("epoll_ctl: listen_sock");
        exit(EXIT_FAILURE);
    }

    printf("Successfully created server at port %d.\n", PORT);

    struct sockaddr_in client_addr;
    socklen_t addr_len = sizeof(client_addr);

    struct message_t buffer;

    while (break_loop == FALSE) {
        nfds = epoll_wait(epollfd, events, MAX_EVENTS, -1);
        if (nfds == -1) {
            perror("epoll_wait");
        }

        for (int n = 0; n < nfds; ++n) {
            if (break_loop == TRUE)
                break;
            if (events[n].data.fd == listen_sock) {
                ssize_t count = recvfrom(
                    listen_sock,
                    &buffer,
                    sizeof(buffer),
                    0,
                    (struct sockaddr *)&client_addr,
                    &addr_len
                );
                if (count == -1) {
                    perror("recvfrom");
                    exit(EXIT_FAILURE);
                } else {
                    int j = 0, k = 0;
                    switch (buffer.type) {
                    case USR:
                        j = find_free_client();
                        if (j == -1)
                            printf("Couldn't find free client "
                                   "socket.\n");
                        else {
                            clients[j].isFree = FALSE;
                            strcpy(
                                clients[j].username, buffer.message
                            );
                            clients[j].address.sin_family =
                                client_addr.sin_family;
                            clients[j].address.sin_port =
                                client_addr.sin_port;
                            clients[j].address.sin_addr.s_addr =
                                client_addr.sin_addr.s_addr;
                            strcpy(
                                buffer.message,
                                "Successfully connected to the "
                                "server.\n"
                            );
                            buffer.receiver_socket = j;
                            sendto(
                                listen_sock,
                                &buffer,
                                sizeof(buffer),
                                0,
                                (struct sockaddr *)&clients[j]
                                    .address,
                                sizeof(clients[j].address)
                            );
                            printf(
                                "User %s with ID %d successfully "
                                "connected to the server.\n",
                                clients[j].username,
                                j
                            );
                        }
                        break;
                    case LIST:
                        printf(
                            "Recieved LIST request from user %s.\n",
                            buffer.sender_name
                        );
                        list_clients();
                        buffer.type = DFL;
                        strcpy(
                            buffer.message,
                            "All users have been listed in the "
                            "server program.\n"
                        );
                        sendto(
                            listen_sock,
                            &buffer,
                            sizeof(buffer),
                            0,
                            (struct sockaddr *)&client_addr,
                            sizeof(client_addr)
                        );
                        break;
                    case TO_ALL:
                        printf(
                            "Sending message from user %s to all "
                            "users.\n",
                            buffer.sender_name
                        );
                        for (int i = 0; i < MAX_CLIENTS; i++) {
                            if (clients[i].isFree == FALSE) {
                                sendto(
                                    listen_sock,
                                    &buffer,
                                    sizeof(buffer),
                                    0,
                                    (struct sockaddr *)&clients[i]
                                        .address,
                                    sizeof(clients[i].address)
                                );
                            }
                        }
                        strcpy(
                            buffer.message,
                            "Successfully sent messages to all "
                            "users.\n"
                        );
                        buffer.type = DFL;
                        sendto(
                            listen_sock,
                            &buffer,
                            sizeof(buffer),
                            0,
                            (struct sockaddr *)&client_addr,
                            sizeof(client_addr)
                        );
                        break;
                    case TO_ONE:
                        k = buffer.receiver_socket;
                        if (k < 0 || k >= MAX_CLIENTS ||
                            clients[k].isFree == TRUE) {
                            printf("Couldn't find client socket.\n"
                            );
                            strcpy(
                                buffer.message,
                                "Couldn't find client socket."
                            );
                        } else {
                            sendto(
                                listen_sock,
                                &buffer,
                                sizeof(buffer),
                                0,
                                (struct sockaddr *)&clients[k]
                                    .address,
                                sizeof(clients[k].address)
                            );
                            strcpy(
                                buffer.message,
                                "Successfully sent message to the "
                                "user.\n"
                            );
                        }
                        buffer.type = DFL;
                        sendto(
                            listen_sock,
                            &buffer,
                            sizeof(buffer),
                            0,
                            (struct sockaddr *)&client_addr,
                            sizeof(client_addr)
                        );
                        break;
                    case STOP:
                        printf(
                            "Recieved STOP request from client "
                            "%d.\n",
                            buffer.sender_id
                        );
                        buffer.type = INTERNAL_EXIT;
                        sendto(
                            listen_sock,
                            &buffer,
                            sizeof(buffer),
                            0,
                            (struct sockaddr *)&client_addr,
                            sizeof(client_addr)
                        );
                        clients[buffer.sender_id].isFree = TRUE;
                        printf(
                            "Client %d successfully logged out.\n",
                            buffer.sender_id
                        );
                        break;
                    case ALIVE:
                        printf(
                            "Recieved ALIVE request from client "
                            "%d.\n",
                            buffer.sender_id
                        );
                        buffer.type = DFL;
                        strcpy(buffer.message, "PING\n");
                        for (int i = 0; i < MAX_CLIENTS; i++) {
                            if (clients[i].isFree == FALSE) {
                                ssize_t count_m = sendto(
                                    listen_sock,
                                    &buffer,
                                    sizeof(buffer),
                                    0,
                                    (struct sockaddr *)&clients[i]
                                        .address,
                                    sizeof(clients[i].address)
                                );
                                if (count_m < 0) {
                                    printf(
                                        "Client %d stopped "
                                        "responding and will be "
                                        "removed from clients "
                                        "list.\n",
                                        i
                                    );
                                    clients[i].isFree = TRUE;
                                }
                            }
                        }
                        strcpy(
                            buffer.message,
                            "All clients have been checked.\n"
                        );
                        sendto(
                            listen_sock,
                            &buffer,
                            sizeof(buffer),
                            0,
                            (struct sockaddr *)&client_addr,
                            sizeof(client_addr)
                        );
                        break;
                    case INTERNAL_EXIT:
                        sendto(
                            listen_sock,
                            &buffer,
                            sizeof(buffer),
                            0,
                            (struct sockaddr *)&client_addr,
                            sizeof(client_addr)
                        );
                        break;
                    default:
                        break;
                    }
                }
            }
        }
    }

    printf("Closing all clients...\n");

    struct message_t closing_message;
    closing_message.type = INTERNAL_EXIT;

    for (int i = 0; i < MAX_CLIENTS; i++) {
        if (clients[i].isFree == FALSE) {
            sendto(
                listen_sock,
                &closing_message,
                sizeof(closing_message),
                0,
                (struct sockaddr *)&clients[i].address,
                sizeof(clients[i].address)
            );
            clients[i].isFree = TRUE;
        }
    }

    printf("Exiting server program...\n");
    close(listen_sock);

    return 0;
}
