#pragma once
#include <mqueue.h>
#include <semaphore.h>

#define SHARED_MEMORY_DESCRIPTOR_NAME                          \
    "printer_system_shared_memory"

#define MAX_MSG_LENGTH          10
#define MAX_PRINTERS            256
#define MAX_PRINTER_BUFFER_SIZE 256
#define MAX_USERS               10

struct printer_t {
    sem_t printer_semaphore;
    char printer_buffer[MAX_PRINTER_BUFFER_SIZE];
    int buffer_length;
    int isPrinting;
};

struct memory_map_t {
    struct printer_t printers[MAX_PRINTERS];
    int number_of_printers;
    int total_users;
    int current_users;
};
