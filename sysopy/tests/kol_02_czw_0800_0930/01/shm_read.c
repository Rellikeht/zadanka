#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <unistd.h>

#define PATH        "/tmp"
#define BUFFER_SIZE 1024
#define ID          0

int main() {
    char *shmAddr;

    // przekształć ścieżkę i identyfikator na klucz komunikacji
    // międzyprocesowej (IPC) Systemu V
    key_t key = ftok(PATH, ID);

    // Utwórz segment pamięci współdzielonej
    // zwracaną wartością jest identyfikator bloku pamięci
    // współdzielonej - czyli shmid
    int shmid;
    if ((shmid = shmget(key, BUFFER_SIZE, 0666)) == -1) {
        fprintf(stderr, "... :%s\n", strerror(errno));
        exit(1);
    }

    // Mapuj segmenty pamięci współdzielonej na przestrzeń adresową
    // procesu
    shmAddr = shmat(shmid, NULL, 0);
    if (shmAddr == (char *)-1) {
        fprintf(stderr, ":%s\n", strerror(errno));
    }

    printf("%s\n", shmAddr);

    // Rozłącz
    if (shmdt(shmAddr) == -1) {
        fprintf(stderr, "shmdt error: %s\n", strerror(errno));
        exit(1);
    }

    // Usuń segment pamięci współdzielonej
    if (shmctl(shmid, IPC_RMID, NULL) == -1) {
        fprintf(stderr, "shmctl error: %s\n", strerror(errno));
        exit(1);
    }

    return 0;
}

/*
gcc -o shm_read shm_read.c
*/
