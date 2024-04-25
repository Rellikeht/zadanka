#include <fcntl.h>
#include <mqueue.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <sys/stat.h>
#include <unistd.h>

#include "config.h"

volatile bool should_close = false;

void signalHandler(int signum) { should_close = true; }

int queueUnlink() {
    int err = mq_unlink(SERVER_QUEUE_NAME);
    if (err != 0) {
        perror("server mq_unlink()");
    }
    return err;
}

int main() {
    int id = 0, err = 0, i = 0, sig = 0;
    message_t receive_message;
    mqd_t mq_descriptor = {0};
    mqd_t client_queues[MAX_CLIENTS_COUNT];

    struct mq_attr attributes = {
        .mq_flags = 0,
        .mq_msgsize = sizeof(message_t),
        .mq_maxmsg = 10,
    };

    mq_descriptor = mq_open(
        SERVER_QUEUE_NAME,
        O_RDWR | O_CREAT,
        S_IRUSR | S_IWUSR,
        &attributes
    );

    if (mq_descriptor < 0) {
        perror("server mq_open()");
        return 1;
    }

    /**
     * Array of client queues descriptors
     *  - initialized with -1 to indicate that id is not used
     */
    for (i = 0; i < MAX_CLIENTS_COUNT; i++)
        client_queues[i] = -1;

    // register signal handler for closing client to all signals
    for (sig = 1; sig < SIGRTMAX; sig++) {
        if (signal(sig, signalHandler) != SIG_ERR) {
            perror("server signal()");
            return 1 + queueUnlink();
        }
    }

    while (!should_close) {
        // receive message from server queue
        err = mq_receive(
            mq_descriptor,
            (char *)&receive_message,
            sizeof(receive_message),
            NULL
        );
        if (err == -1) {
            perror("server mq_receive()");
            err = 0;
        }

        switch (receive_message.type) {
        /* Requested initialization from the client */
        case INIT:
            /* Find first available id */
            id = 0;
            while (client_queues[id] != -1 &&
                   id < MAX_CLIENTS_COUNT)
                id++;

            /* If all id's are used, we skip initialization for
             * that client */
            if (id == MAX_CLIENTS_COUNT) {
                printf("Max number of clients has connected, "
                       "can't open another connection\n");
                usleep(10000);
                continue;
            }

            /* Open client queue with name received from client
             */
            client_queues[id] = mq_open(
                receive_message.text,
                O_RDWR,
                S_IRUSR | S_IWUSR,
                NULL
            );
            if (client_queues[id] < 0)
                perror("mq_open client");

            /* Send identifier to client */
            message_t send_message = {
                .type = IDENTIFIER, .identifier = id};

            err = mq_send(
                client_queues[id],
                (char *)&send_message,
                sizeof(send_message),
                10
            );
            if (err != 0) {
                perror("server mq_send()");
                err = 0;
            }

            printf(
                "Registered connection with client at id: %d\n",
                id
            );
            break;

        /* Received standard message to be broadcasted */
        case MESSAGE_TEXT:
            /* Loop over all possible id's and broadcast
             * received message to all connected clients */
            for (int identifier = 0;
                 identifier < MAX_CLIENTS_COUNT;
                 identifier++) {
                if (identifier != receive_message.identifier &&
                    identifier != -1) {
                    /* Broadcast received message */
                    err = mq_send(
                        client_queues[identifier],
                        (char *)&receive_message,
                        sizeof(receive_message),
                        10
                    );
                    if (err != 0) {
                        perror("mq_send()");
                        err = 0;
                    }
                }
            }
            break;

        /* Received message from client informing that client
         * has been closed */
        case CLIENT_CLOSE:
            /* Close client queue */
            err = mq_close(
                client_queues[receive_message.identifier]
            );
            if (err != 0) {
                perror("server mq_close()");
                err = 0;
            }
            /* Mark that id is not used */
            client_queues[receive_message.identifier] = -1;
            printf(
                "Closed connection with client at id: %d\n",
                receive_message.identifier
            );
            break;

        default:
            printf(
                "Unexpected message type in server queue: %d "
                "\n",
                receive_message.type
            );
            break;
        }
    }

    printf("Exiting server\n");

    /**
     * Close all client queues
     */
    for (int i = 0; i < MAX_CLIENTS_COUNT; i++) {
        if (client_queues[i] != -1) {
            err = mq_close(client_queues[i]);
            if (err != 0) {
                perror("server: client mq_close()");
                err = 0;
            }
        }
    }

    /**
     * Close and unlink server queue
     */
    err = mq_close(mq_descriptor);
    if (err != 0) {
        perror("server: main mq_close()");
    }

    return err + queueUnlink();
}
