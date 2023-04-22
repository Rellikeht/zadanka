#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdbool.h>

// consider chars from [FIRST_CHAR, LAST_CHAR)
#define FIRST_CHAR 33
#define LAST_CHAR 127
#define MAX_CHARS (LAST_CHAR - FIRST_CHAR)
#define MAX_BIGRAMS ((LAST_CHAR - FIRST_CHAR) * (LAST_CHAR - FIRST_CHAR))

#define NEWLINE '\n'
#define IN_WORD 1

#define IN_LINE_COMMENT 1
#define IN_BLOCK_COMMENT 2

int count[MAX_BIGRAMS] = { 0 };

// count lines, words & chars in a given text file
void wc(int *nl, int *nw, int *nc) {
    *nl = 0; *nw = 0, *nc = 0;
    int newlines = 0, words = 0, chars = 0;
    int ch, ch_prev;
    while ((ch = getchar()) != EOF){
        if (ch == 10){
            newlines++;
        }
        if ((ch == 10 || ch == 9 || ch == 32) && (ch_prev != 10 && ch_prev != 9 && ch_prev != 32)){
            words++;
        }
        chars++;
        ch_prev = ch;
    }
    if (newlines == 0) words++;

    *nl = newlines++;
    *nw = words++;
    *nc = chars;
}

static inline void fill_with_zeros(int tab[], int n){
    for (int i = 0; i < n; i++) tab[i] = 0;
}

void char_count(int char_no, int *n_char, int *cnt) {
    int n = LAST_CHAR - FIRST_CHAR;
    int chars[n];
    fill_with_zeros(chars, n);
    int ch;
    while ((ch = getchar()) != EOF){
        if (ch < LAST_CHAR && ch >= FIRST_CHAR){
            chars[ch - FIRST_CHAR]++;
        }
    }
    int chars_ix[n];
    for (int i = 0; i < n; i++){
        chars_ix[i] = i;
    }

    for (int i = 0; i < n; i++){
        int j = i;
        while (j > 0 && chars[j] > chars[j-1]){
            int t1, t2;

            t1 = chars[j];
            chars[j] = chars[j-1];
            chars[j-1] = t1;

            t2 = chars_ix[j];
            chars_ix[j] = chars_ix[j-1];
            chars_ix[j-1] = t2;

            j--;
        }
    }

    *n_char = chars_ix[char_no-1] + FIRST_CHAR;
    *cnt = chars[char_no-1];

}

int bcomp(const void *a, const void *b) {
    int *bg1 = (int *) a, *bg2 = (int *) b;
    return bg2[2] - bg1[2];
}

void bigram_count(int bigram_no, int bigram[]) {
    int bigrams[MAX_BIGRAMS][3] = {0};
    int ch, ch_prev = getchar(), ind;

    while ((ch = getchar()) != EOF){
        if (ch < LAST_CHAR && ch >= FIRST_CHAR &&
		ch_prev < LAST_CHAR && ch_prev >= FIRST_CHAR){
	    ind = (ch_prev - FIRST_CHAR)*MAX_CHARS + ch - FIRST_CHAR;
            bigrams[ind][0] = ch_prev;
            bigrams[ind][1] = ch;
            bigrams[ind][2] += 1;
        }
        ch_prev = ch;
    }

    qsort(bigrams, MAX_BIGRAMS, sizeof(bigrams[0]), bcomp);
    bigram[0] = bigrams[bigram_no-1][0];
    bigram[1] = bigrams[bigram_no-1][1];
    bigram[2] = bigrams[bigram_no-1][2];
}

void find_comments(int *linec, int *blockc) {
    int com_cont = 0, block_count = 0;
    int ch;
    bool inside_coment = false;

    while ((ch = getchar()) != EOF){
	if (inside_coment) {
	    if (ch == '*') {
		ch = getchar();
		if (ch == '/') {
		    inside_coment = false;
		}
	    }

	} else if (ch == '/'){
	    ch = getchar();
	    if (ch == '/') {
		com_cont += 1;
		while ((ch = getchar()) != EOF && ch != '\n') {}
	    } else if (ch == '*') {
		inside_coment = true;
		block_count += 1;
	    }
	}
    }

    *linec = com_cont;
    *blockc = block_count;
}

#define MAX_LINE 128

int read_int() {
	char line[MAX_LINE];
	fgets(line, MAX_LINE, stdin); // to get the whole line
	return (int)strtol(line, NULL, 10);
}

int main(void) {
	int to_do;
	int nl, nw, nc, char_no, n_char, cnt;
	int line_comment_counter, block_comment_counter;
	int bigram[3];

	to_do = read_int();
	switch (to_do) {
		case 1: // wc()
			wc (&nl, &nw, &nc);
			printf("%d %d %d\n", nl, nw, nc);
			break;
		case 2: // char_count()
			char_no = read_int();
			char_count(char_no, &n_char, &cnt);
			printf("%c %d\n", n_char, cnt);
			break;
		case 3: // bigram_count()
			char_no = read_int();
			bigram_count(char_no, bigram);
			printf("%c%c %d\n", bigram[0], bigram[1], bigram[2]);
			break;
		case 4:
			find_comments(&line_comment_counter, &block_comment_counter);
			printf("%d %d\n", block_comment_counter, line_comment_counter);
			break;
		default:
			printf("NOTHING TO DO FOR %d\n", to_do);
			break;
	}
	return 0;
}

