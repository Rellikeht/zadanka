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

char identifiers[MAX_IDS][MAX_ID_LEN] = {0};

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

const size_t kw_amount = sizeof(keywords)/sizeof(keywords[0]);
const char LINE_COMMENT[] = "//";
const char COMMENT_START[] = "/*";
const char COMMENT_END[] = "*/";

int find_idents() {
    int idents = 0, llen = 0, wlen = 0, i = 0;
    size_t size = 0, last = 0;
    char wbuf[MAX_LINE_LEN] = {0};
    char *line = calloc(MAX_LINE_LEN, sizeof(char)), *ln = line;
    bool inside_comment = false, inside_string = false,
	 ident = false, end = false, cont = true, normal_div = true;

    while ((last = getline(&line, &size, stdin)) != (size_t) -1) {
	line[--last] = 0;
	llen = strlen(line);

	if (llen == 0) // || line[0] == '#') // && line[1] == 'i')
	    continue;

	end = false;
	wlen = 0;

	for (i = 0; i < llen; i++) {

	    if (inside_comment) {
		if (line[i] == '*' && line[i+1] == '/') inside_comment = false;
		continue;
	    }

	    if (inside_string) {
		if (line[i] == '\\') i += 1;
		else if (line[i] == '"') inside_string = false;
		continue;
	    }

	    switch (line[i]) {

		case '#':
		    if (line[i+1] == 'd') for (; line[i] != ' '; i++) {}
		    else end = true;
		    break;

		case '\"':
		    inside_string = true;
		    break;

		case '\'':
		    i += 2;
		    if (line[i] != '\'') i++;
		    break;

		case '/':
		    normal_div = true;
		    switch (line[i+1]) {
			case '/':
			    end = true;
			    normal_div = false;
			    break;
			case '*':
			    inside_comment = true;
			    normal_div = false;
			    break;
		    }

		    if (!normal_div) break;

		case '!':
		case '|':
		case '<':
		case '>':
		case '&':
		case ':':
		case ',':
		case '.':

		case '\t':
		case '[':
		case ']':
		case '(':
		case ')':
		case '{':
		case '}':
		case ';':

		case '=':
		case '+':
		case '-':
		case '*':
		case '%':
		case '^':

		case ' ':
		    wbuf[wlen] = 0;
		    cont = true;

		    if (wlen > 0) {
			if (wbuf[0] >= '0' && wbuf[0] <= '9') cont = false;

			if (cont) {
			    for (int j = 0; j < kw_amount; j++) {
				if (!strcmp(keywords[j], wbuf)) {
				    cont = false;
				    break;
				}
			    }
			}

			if (cont) {
			    for (int j = 0; j < idents; j++) {
				if (!strcmp(identifiers[j], wbuf)) {
				    cont = false;
				    break;
				}
			    }

			    if (cont) {
				//printf("' %s ' %i TOKEN\n", wbuf, wlen);
				strcpy(identifiers[idents++], wbuf);
			    }
			}
		    }
		    wlen = 0;
		    break;

		default:
		    wbuf[wlen++] = line[i];
		    break;
	    }

	    if (end) break;
	}
    }

    free(ln);
    return idents;
}

int main(void) {
    printf("%d\n", find_idents());
    return 0;
}
