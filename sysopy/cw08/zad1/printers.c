#include <fcntl.h>
#include <mqueue.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/mman.h>
#include <sys/msg.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#include "msg_types.h"

int main(int argc, char *argv[]) {
    int M = 0, N = 0, memory_fd = 0;
    struct memory_map_t *memory_map = {0};

    if (argc != 3) {
        fprintf(
            stderr,
            "Invalid number of arguments "
            "provided.\nExiting...\n"
        );
        return 2;
    }

    M = atoi(argv[1]);
    N = atoi(argv[2]);
    if (M <= 0 || N <= 0) {
        fprintf(
            stderr,
            "Invalid argument value provided.\nExiting...\n"
        );
        return 2;
    }

    if (N > MAX_USERS) {
        fprintf(
            stderr,
            "Too many users specified, maximum number of users "
            "is %d\n",
            MAX_USERS
        );
        return -1;
    }

    if (M > MAX_PRINTERS) {
        fprintf(
            stderr,
            "Too many printers specified, maximum number of "
            "printers is %d\n",
            MAX_PRINTERS
        );
        return -1;
    }

    memory_fd = shm_open(
        SHARED_MEMORY_DESCRIPTOR_NAME,
        O_RDWR | O_CREAT,
        S_IRUSR | S_IWUSR
    );
    if (memory_fd < 0) {
        perror("Couldn't open shared memory region.");
        fprintf(stderr, "Exiting...");
        return 2;
    }
    if (ftruncate(memory_fd, sizeof(struct memory_map_t)) < 0) {
        perror("Couldn't assign size of shared memory region.");
        fprintf(stderr, "Exiting...");
        return 2;
    }

    memory_map = mmap(
        NULL,
        sizeof(struct memory_map_t),
        PROT_READ | PROT_WRITE,
        MAP_SHARED,
        memory_fd,
        0
    );
    if (memory_map == MAP_FAILED) {
        perror("Couldn't add shared memory to the printers "
               "process memory.");
        fprintf(stderr, "Exiting...");
        return 2;
    }

    memset(memory_map, 0, sizeof(struct memory_map_t));

    memory_map->number_of_printers = M;
    memory_map->total_users = N;
    memory_map->current_users = 0;
    memory_map->isActive = 1;

    for (int i = 0; i < memory_map->number_of_printers; i++) {
        sem_init(
            &memory_map->printers[i].printer_semaphore, 1, 1
        );
    }

    printf("The printers are starting...\n");

    while (memory_map->isActive) {
        for (int i = 0; i < memory_map->number_of_printers;
             i++) {
            if (memory_map->printers[i].isPrinting) {
                printf("Printer %d: ", i);
                for (int j = 0;
                     j < memory_map->printers[i].buffer_length;
                     j++) {
                    printf(
                        "%c",
                        memory_map->printers[i]
                            .printer_buffer[j]
                    );
                }
                memory_map->printers[i].isPrinting = 0;
                sem_post(
                    &memory_map->printers[i].printer_semaphore
                );
            }
        }
        sleep(1);
    }

    for (int i = 0; i < memory_map->number_of_printers; i++) {
        sem_destroy(&memory_map->printers[i].printer_semaphore);
    }

    munmap(memory_map, sizeof(struct memory_map_t));

    return 0;
}
