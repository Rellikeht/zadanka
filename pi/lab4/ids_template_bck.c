#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>

#define IN_LINE_COMMENT 1
#define IN_BLOCK_COMMENT 2
#define IN_STRING 4
#define IN_ID 8

#define MAX_ID_LEN 64
#define MAX_IDS 1024
#define MAX_LINE_LEN 1024

//#define llen(id) sizeof(id)/sizeof(char*)

int index_cmp(const void*, const void*);
int cmp(const void*, const void*);

char identifiers[MAX_IDS][MAX_ID_LEN];

const char *keywords[] = {
	"auto", "break", "case", "char",
	"const", "continue", "default", "do",
	"double", "else", "enum", "extern",
	"float", "for", "goto", "if",
	"int", "long", "register", "return",
	"short", "signed", "sizeof", "static",
	"struct", "switch", "typedef", "union",
	"unsigned", "void", "volatile", "while"
};

const char LINE_COMMENT[] = "//";

int cmp(const void* first_arg, const void* second_arg) {
	char *a = *(char**)first_arg;
	char *b = *(char**)second_arg;
	return strcmp(a, b);
}

int index_cmp(const void* first_arg, const void* second_arg) {
	int a = *(int*)first_arg;
	int b = *(int*)second_arg;
	return strcmp(identifiers[a], identifiers[b]);
}

void trim_start(char **strptr, size_t *last) {
    bool run = true;
    while (run && *last > 0) {
	//printf("%lu\n", *last);
	switch (**strptr) {
	    case ' ':
	    case '\t':
	    case '\n':
	    case '\r':
		*strptr += 1;
		*last -= 1;
		break;
	    default:
		run = false;
		break;
	}
    }
}

int find_idents() {
    int idents = 0, word_len = 0, word_pos = 0;
    size_t size = 0, last = 0;
    char word[MAX_ID_LEN*2] = {0};
    char *line = calloc(MAX_LINE_LEN, sizeof(char));
    char *ln;

    while ((last = getline(&line, &size, stdin)) != (size_t) -1) {
	line[--last] = 0;
	//if (strlen(line) == 0) continue;
	ln = line;
	trim_start(&ln, &last);

	while (strlen(ln) != 0) {
	    //printf("\"%s\"\n", ln);
	    sscanf(ln, "%s", word);
	    if (!strcmp(word, LINE_COMMENT)) break;

	    word_len = strlen(word);
	    ln += word_len+1;
	    printf("%i '%s'\n", word_len, word);
	}
    }

    free(line);
    return idents;
}

int main(void) {
	printf("%d\n", find_idents());
	return 0;
}

