#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <stdbool.h>

// ============================== QUEUE ==============================

#define DECK_SIZE 52
#define CBUFF_SIZE DECK_SIZE

enum state { OK = 0, UNDERFLOW = -1, OVERFLOW = -2 };
typedef struct {
    int content[CBUFF_SIZE];
    int first, len;
} cbuff;


int cbuff_push(cbuff *buf, int element) {
    if (buf->len >= CBUFF_SIZE) return OVERFLOW;
    buf->content[(buf->first+buf->len)%CBUFF_SIZE] = element;
    (buf->len)++;
    return OK;
}

int cbuff_pop(cbuff *buf) {
    if (buf->len <= 0) return UNDERFLOW;
    (buf->len)--;
    int rv = buf->content[buf->first];
    buf->first = (buf->first+1)%CBUFF_SIZE;
    return rv;
}

static inline int cbuff_last(cbuff *buf) {
    return buf->content[(buf->first+buf->len-1)%CBUFF_SIZE];
}

static inline void cbuff_undo(cbuff *buf) {
    if (buf->len <= 0) return;
    (buf->len)--;
}

static inline int cbuff_state(cbuff *buf) {
    return buf->len;
}

void cbuff_print(cbuff *buf) {
    printf("%i", buf->content[buf->first]);
    for (int i = 1; i < buf->len; i++)
	printf(" %i", buf->content[(buf->first+i)%CBUFF_SIZE]);
    //printf("\n");
}

static inline void cbuff_t1(cbuff *from, cbuff *to) {
    cbuff_push(to, cbuff_pop(from));
}

void cbuff_transfer(cbuff *from, cbuff *to) {
    while(from->len > 0) cbuff_t1(from, to);
}

// ============================== RANDOM ==============================

int rand_from_interval(int a, int b) {
    if (a > b) return INT_MIN;
    else if (b - a > RAND_MAX) return INT_MAX;
    else if (a == b) return a;
    return (rand()%(b-a+1))+a;
}

void swap (int array[], int i, int k) {
    int tmp = array[i];
    array[i] = array[k];
    array[k] = tmp;
}

// random permutation of integers from [0, n-1]
void rand_permutation(int n, int array[]) {
    for (int i = 0; i < n; i++) array[i] = i;
    for (int i = 0; i < n-1; i++) swap(array, i, rand_from_interval(i, n-1));
}

void print_array(int n, int array[]) {
    for (int i = 0; i < n; i++) printf("%i ", array[i]);
    printf("\n");
}

// ============================== CARDS ============================== 

const char TYPES[] = {'J', 'Q', 'K', 'A'};
//const char COLORS[] = {'S', 'H', 'D', 'C'};
const char COLORS[] = {'P', 'K', 'C', 'T'};
void deck_print(cbuff *deck) {
    for (int i = 0; i < deck->len; i++) {
	int n = deck->content[(deck->first+i)%CBUFF_SIZE];
	char c = COLORS[n%4];
	n /= 4;
	if (n < 9) printf("%i", n+2);
	else printf("%c", TYPES[n-9]);
	printf("%c ", c);
    }
    printf("\n");
}

static inline int compare_cards(int a, int b) {
    a /= 4, b /= 4;
    if (a > b) return 1;
    if (a < b) return -1;
    return 0;
}

#define winner_takes(player) \
    cbuff_transfer(t1, player); \
    cbuff_transfer(t2, player)
#define comp_cards() compare_cards(cbuff_last(t1), cbuff_last(t2))
#define get2() \
    cbuff_push(t1, cbuff_pop(p1)); \
    cbuff_push(t2, cbuff_pop(p2))

#define p1empty cbuff_last(t1) == UNDERFLOW
#define p2empty cbuff_last(t2) == UNDERFLOW
#define out_of_cards p1empty || p2empty
#define get2ret() \
    get2(); \
    if (out_of_cards) { \
	if (p1empty) { \
	    cbuff_undo(t1); \
	} \
	if (p2empty) { \
	    cbuff_undo(t2); \
	} \
	return 1; \
    }

// ============================== MAIN ============================== 

int war(int limit, int *conflicts, cbuff *p1, cbuff *p2, cbuff *t1, cbuff *t2) {
    int result = 0;
    while (*conflicts < limit) {

	get2();
	if (p1empty) {
	    cbuff_transfer(t2, p2);
	    result = 3;
	    break;
	} else if (p2empty) {
	    cbuff_transfer(t1, p1);
	    result = 2;
	    break;
	}

	(*conflicts)++;
	while (comp_cards() == 0 && *conflicts < limit) {
	    //get2ret();
	    get2ret();
	    get2ret();
	    (*conflicts)++;
	}

	if (*conflicts >= limit) {
	    // TODO chujowy przypadek
	    cbuff_transfer(t1, p1);
	    cbuff_transfer(t2, p2);
	    return 0;
	}

	switch (comp_cards()) {
	    case 1: winner_takes(p1); break;
	    case -1: winner_takes(p2); break;
	    default: return 4;
	}
    }
    return 0;
}

int main() {
    cbuff player1 = {0}, player2 = {0}, table1 = {0}, table2 = {0};
    cbuff *p1 = &player1, *p2 = &player2, *t1 = &table1, *t2 = &table2;
    int cards[DECK_SIZE] = {0};
    int seed = 0, choice = 0, limit = 0, result = 0;
    int i = 0, conflicts = 0;

    scanf("%i %i %i", &seed, &choice, &limit);
    srand(seed);
    rand_permutation(DECK_SIZE, cards);
    for (; i < DECK_SIZE/2; i++) cbuff_push(p1, 1);
    for (; i < DECK_SIZE; i++) cbuff_push(p2, 2);

    if (choice) { // simplified game
	while (conflicts < limit) {
	    get2();

	    if (p1empty) {
		cbuff_transfer(t2, p2);
		result = 3;
		break;
	    } else if (p2empty) {
		cbuff_transfer(t1, p1);
		result = 2;
		break;
	    }

	    conflicts++;
	    switch (comp_cards()) {
		case 0:
		    cbuff_transfer(t1, p1);
		    cbuff_transfer(t2, p2);
		    break;
		case 1: winner_takes(p1); break;
		case -1: winner_takes(p2); break;
	    }
	}

    } else result = war(limit, &conflicts, p1, p2, t1, t2);

    printf("%i\n", result);
    switch (result) {
	case 1: cbuff_transfer(t1, p1); cbuff_transfer(t2, p2);
	case 0: printf("%i %i", p1->len, p2->len); break;
		//cbuff_print(p1); cbuff_print(p2); break;
	case 2: printf("%i", conflicts); break;
	case 3: cbuff_print(p2); break;
	default: printf("ANOMALIA!!!\n");
    }

    if (result >= 0 && result <4)
	return 0;
    return result;
}
