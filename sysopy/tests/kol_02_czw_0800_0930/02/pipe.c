#include <errno.h>
#include <memory.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BUFFER_SIZE 10

int main() {
    int fd[2];
    pid_t pid;
    char sendBuffer[BUFFER_SIZE] = "welcome!";
    char receiveBuff[BUFFER_SIZE];

    // Wyzeruj bufor receiveBuff
    memset(receiveBuff, 0, BUFFER_SIZE);

    // Utwórz anonimowy potok
    if (pipe(fd) == -1) {
        fprintf(stderr, "... :%s\n", strerror(errno));
        exit(1);
    }

    // Utwórz proces potomny
    pid = fork();
    if (pid < 0) {
        fprintf(stderr, "... :%s\n", strerror(errno));
        exit(1);
    } else if (pid > 0) // proces nadrzędny
    {
        close(fd[0]);
        write(fd[1], sendBuffer, BUFFER_SIZE);
        printf("parent process %d send:%s\n", getpid(), sendBuffer);
    } else // proces potomny
    {
        close(fd[1]);
        read(fd[0], receiveBuff, BUFFER_SIZE);
        printf(
            "child process %d receive:%s\n", getpid(), receiveBuff
        );
    }
    return 0;
}

/*
gcc -o pipe pipe.c
./pipe
parent process send:welcome!
child  process receive:welcome
*/
