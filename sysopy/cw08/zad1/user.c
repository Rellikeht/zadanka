#include<stdio.h>
#include<stdlib.h>
#include<signal.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<unistd.h>
#include<string.h>
#include<ctype.h>
#include<fcntl.h>
#include<unistd.h>
#include<math.h>
#include<sys/msg.h>
#include<sys/ipc.h>
#include<mqueue.h>
#include<time.h>
#include <sys/mman.h>

#include "msg_types.h"


int find_free_printer(struct memory_map_t * mem_map) {
    for (int i = 0; i < mem_map->number_of_printers; i++) {
        int sem_value;
        if (sem_getvalue(&mem_map->printers[i].printer_semaphore, &sem_value) > 0) {
            return i;
        } 
    }
    return rand() % mem_map->number_of_printers;
}


int main() {
    srand(time(0));

    int isActive = 1;

    int memory_fd = shm_open(SHARED_MEMORY_DESCRIPTOR_NAME, O_RDWR | O_CREAT,  S_IRUSR | S_IWUSR);
    if (memory_fd < 0) {
        perror("Couldn't open shared memory region.");
        printf("Exiting...");
        return 2;
    }
    if (ftruncate(memory_fd, sizeof(struct memory_map_t)) < 0) {
        perror("Couldn't assign size of shared memory region.");
        printf("Exiting...");
        return 2;
     }

    struct memory_map_t* memory_map = mmap(NULL, sizeof(struct memory_map_t), PROT_READ | PROT_WRITE, MAP_SHARED, memory_fd, 0);
    if (memory_map == MAP_FAILED) {
        perror("Couldn't add shared memory to the printers process memory.");
        printf("Exiting...");
        return 2;
    }

    if (memory_map->current_users == memory_map->total_users) {
        printf("Too many users are using the printer right now. Waiting...\n");
        while(memory_map->current_users >= memory_map->total_users) {}
    }
    printf("User can start printing...\n");

    memory_map->current_users++;

    while (isActive) {

        char message[MAX_MSG_LENGTH];
        fgets(message, MAX_MSG_LENGTH, stdin);

        if (strcmp(message, "EXIT\n") == 0) {
            isActive = 0;
            memory_map->isActive = 0;
        }
        else if (strcmp(message, "CLOSE\n") == 0) {
            isActive = 0;
            memory_map->current_users--;
        }
        else {
            int ix = find_free_printer(memory_map);

            if (sem_wait(&memory_map->printers[ix].printer_semaphore) < 0) {
                perror("Encountered error with sem_wait.");
                printf("Exiting...\n");
                return -1;
            }
            
            strcpy(memory_map->printers[ix].printer_buffer, message);
            memory_map->printers[ix].buffer_length = strlen(message);
            memory_map->printers[ix].isPrinting = 1;
            sleep(rand() % 3 + 1);

            printf("Message has been printed by printer %d\n", ix);
        }

    }

    munmap(memory_map, sizeof(struct memory_map_t));

    return 0;
}