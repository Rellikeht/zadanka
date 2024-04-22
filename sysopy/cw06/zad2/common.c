#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>
#include "config.h"
#include <sys/stat.h>
#include <fcntl.h>

typedef struct {
    int input, output, error;
} pipes;

pipes openPipes() {
    pipes result = {0};
    result.input = open(INPUT_PIPE, O_RDWR);

    if(result.input < 0){
        perror("input pipe opening");
        result.input = 0;
        result.error = 1;
        return result;
    }

    result.output = open(OUTPUT_PIPE, O_RDWR);
    if(result.output < 0){
        perror("output pipe opening");
        result.input = 0;
        result.output = 0;
        result.error = 1;
    }

    return result;
}

int closePipes(pipes *ps) {
    int result = 0;

    result = close(ps -> input);
    ps->input = 0;
    if(result != 0) {
        perror("input pipe closing");
        return result;
    }

    result = close(ps->output);
    ps->input = 0;
    if(result != 0) {
        perror("output pipe closing");
    }
    return result;
}
