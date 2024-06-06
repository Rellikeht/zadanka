#include "command_utils.h"
#include <stdio.h>
#include <string.h>

char *get_command(const char *input) {
    static char result[256];
    int i = 0;

    while (input[i] != ' ' && input[i] != '\0') {
        result[i] = input[i];
        i++;
    }
    result[i] = '\0';

    return result;
}

char *get_string_after_command(const char *input) {
    const char *spacePos = strchr(input, ' ');

    if (spacePos == NULL) {
        return "";
    }
    spacePos++;

    char *end = strchr(spacePos, '\n');
    if (end != NULL) {
        *end = '\0';
    }
    return (char *)spacePos;
}

char *get_param_after_command(const char *input) {
    static char result[256];
    int start = -1, end = -1;
    int i = 0;

    while (input[i] != '\0') {
        if (input[i] == ' ') {
            if (start == -1) {
                start = i;
            } else if (end == -1) {
                end = i;
                break;
            }
        }
        i++;
    }

    if (start == -1 || end == -1) {
        return "";
    }

    int j;
    for (j = start + 1; j < end; j++) {
        result[j - start - 1] = input[j];
    }
    result[j - start - 1] = '\0';

    return result;
}

char *get_string_after_param(const char *input) {
    const char *spacePos = strchr(input, ' ');
    if (spacePos == NULL) {
        return "";
    }
    spacePos = strchr(spacePos + 1, ' ');
    if (spacePos == NULL) {
        return "";
    }
    spacePos++;
    char *end = strchr(spacePos, '\n');
    if (end != NULL) {
        *end = '\0';
    }
    return (char *)spacePos;
}
