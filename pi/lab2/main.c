#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

enum state {
    OK = 0, UNDERFLOW = -1, OVERFLOW = -2
};
enum wyniki {
    N_GRA = 0, BRAK_KART = 1, A_WIN = 2, B_WIN = 3
};
enum wyniki_porownania {
    A_BIG = -5, B_BIG = -4, DRAW = -3
};
#define COLOR_NUM  4
#define CARD_NUM  52
int Talia[CARD_NUM];
int A[CARD_NUM];
int B[CARD_NUM];
int Alc = 0, Blc = 0, outA = 0, outB = 0;
int num_conflict;

int rand_from_interval(int a, int b) {
    int i = (rand() % (b - a + 1)) + a;
    return i;
}

void swap(int array[], int i, int k) {
    int tmp = array[i];
    array[i] = array[k];
    array[k] = tmp;
    return;
}


int Karty_przed_A[CARD_NUM];
int Karty_przed_B[CARD_NUM];
int outSA = 0, outSB = 0;

// raczej git
int dodaj_karte(int array[], int card, int out, int *len) {
    array[(out + (*len)) % CARD_NUM] = card;
    //printf("%dadd ",card);
    (*len)++;
    return OK;
}

int dodaj_karty(int cards_to_add[], int n_cards, int array[], int out, int *len) {
    for (int i = 0; i < n_cards; i++) {
        array[out + (*len) % CARD_NUM] = cards_to_add[i];
        (*len)++;
    }
    return OK;
}

//losowanie git
void losuj() {
    for (int i = 0; i < CARD_NUM; i++) {
        Talia[i] = i;
    }
    for (int i = 0; i < CARD_NUM - 1; i++) {
        int k = rand_from_interval(i, CARD_NUM - 1);
        swap(Talia, i, k);
    }
    for (int i = 0; i < CARD_NUM / 2; i++) {
        dodaj_karte(A, Talia[i], outA, &Alc);
    }
    for (int i = CARD_NUM / 2; i < CARD_NUM; i++) {
        dodaj_karte(B, Talia[i], outB, &Blc);
    }
}

//to tez git
void cbuff_print(int out, int len, int cbuff[]) {
    int curr = out;
    for (int i = 0; i < len; i++) {
        if (curr == CARD_NUM) {
            curr = 0;
        }
        printf("%d ", cbuff[curr]);
        curr += 1;
    }
}


void Wyniki_gry(int wynik, int n_of_conflicts) {
    printf("%d", wynik);
    switch (wynik) {
        case N_GRA:
            printf(" %d %d", Alc, Blc);
            break;
        case BRAK_KART:
            printf(" %d %d", Alc, Blc);
            break;
        case A_WIN:
            printf(" %d", n_of_conflicts);

            break;
        case B_WIN:
            printf("\n");
            cbuff_print(outB, Blc, B);
            break;
        default:
            printf("NOTHING TO DO!\n");
    }
}

int cbuff_pop(int cbuff[], int *len, int *out) {
    if (*len == 0) {
        return UNDERFLOW;
    }
    int nr = cbuff[(*out)];
    (*len)--;
    (*out)++;
    *out %= CARD_NUM;
    //printf("%dpop ",nr);
    return nr;
}

int porownaj_karty(int a, int b) {

    int val_a = a / 4;
    int val_b = b / 4;

    if (val_a == val_b) {
        return DRAW;
    } else if (val_b > val_a) {
        return B_BIG;
    } else {
        return A_BIG;
    }
}

void gra_uproszczona() {
    //printf("%d simple",1);
    int n_of_conflict = 0;
    while (n_of_conflict < num_conflict) {
        n_of_conflict += 1;
        int a = cbuff_pop(A, &Alc, &outA);
        int b = cbuff_pop(B, &Blc, &outB);
        //printf("%d %d ", a, b);
        int wynikU = porownaj_karty(a, b);
        switch (wynikU) {
            case DRAW: {
                dodaj_karte(A, a, outA, &Alc);
                dodaj_karte(B, b, outB, &Blc);
                //printf("Draw ");
            }
                break;
            case B_BIG: {
                dodaj_karte(B, b, outB, &Blc);
                dodaj_karte(B, a, outB, &Blc);
                // printf("B Win ");
                if (Alc == 0) {
                    Wyniki_gry(B_WIN, n_of_conflict);
                    return;
                }
            }
                break;
            case A_BIG: {
                dodaj_karte(A, a, outA, &Alc);
                dodaj_karte(A, b, outA, &Alc);
                //printf("A Win ");
                if (Blc == 0) {
                    Wyniki_gry(A_WIN, n_of_conflict);
                    return;
                }
            }
                break;
        }
    }

    Wyniki_gry(N_GRA, 0);

}

void gra_standardowa() {
    //printf("stand");
    int n = 0;
    int n_of_conflict = 0;
    while (n_of_conflict < num_conflict) {
        n_of_conflict += 1;
        int a = cbuff_pop(A, &Alc, &outA);
        int b = cbuff_pop(B, &Blc, &outB);
        int wynikU = porownaj_karty(a, b);
        Karty_przed_A[n] = a;
        Karty_przed_B[n] = b;
        n += 1;
        if (a == UNDERFLOW || b == UNDERFLOW) {
            for (int i = 0; i < n; i++) {
                if (Karty_przed_A[i] != UNDERFLOW) {
                    dodaj_karte(A, Karty_przed_A[i], outA, &Alc);
                }
            }
            for (int i = 0; i < n; i++) {
                if (Karty_przed_B[i] != UNDERFLOW) {
                    dodaj_karte(B, Karty_przed_B[i], outB, &Blc);
                }
            }
            Wyniki_gry(BRAK_KART, n_of_conflict);
            n = 0;
            return;
            break;
        }
        switch (wynikU) {

            case DRAW: {
                a = cbuff_pop(A, &Alc, &outA);
                b = cbuff_pop(B, &Blc, &outB);
                Karty_przed_A[n] = a;
                Karty_przed_B[n] = b;
                n += 1;
                if (a == UNDERFLOW || b == UNDERFLOW) {
                    for (int i = 0; i < n; i++) {
                        if (Karty_przed_A[i] != UNDERFLOW) {
                            dodaj_karte(A, Karty_przed_A[i], outA, &Alc);
                        }
                        if (Karty_przed_B[i] != UNDERFLOW) {
                            dodaj_karte(B, Karty_przed_B[i], outB, &Blc);
                        }
                    }
                    Wyniki_gry(BRAK_KART, n_of_conflict);
                    return;
                }
            }
                break;
            case B_BIG: {
                for (int i = 0; i < n; i++) {
                    if (Karty_przed_A[i] != UNDERFLOW) {
                        dodaj_karte(B, Karty_przed_B[i], outB, &Blc);
                    }
                }
                for (int i = 0; i < n; i++) {
                    if (Karty_przed_B[i] != UNDERFLOW) {
                        dodaj_karte(B, Karty_przed_A[i], outB, &Blc);
                    }
                }
                if (Alc == 0) {
                    Wyniki_gry(B_WIN, n_of_conflict);
                    return;
                }
                n = 0;
            }
                break;
            case A_BIG: {
                for (int i = 0; i < n; i++) {
                    if (Karty_przed_A[i] != UNDERFLOW) {
                        dodaj_karte(A, Karty_przed_A[i], outA, &Alc);
                    }
                }
                for (int i = 0; i < n; i++) {
                    if (Karty_przed_B[i] != UNDERFLOW) {
                        dodaj_karte(A, Karty_przed_B[i], outA, &Alc);
                    }
                }
                if (Blc == 0) {
                    Wyniki_gry(A_WIN, n_of_conflict);
                    return;
                }
                n = 0;
            }
                break;
        }

    }
    for (int i = 0; i < n; i++) {
        if (Karty_przed_A[i] != UNDERFLOW) {
            dodaj_karte(A, Karty_przed_A[i], outA, &Alc);
        }
        if (Karty_przed_B[i] != UNDERFLOW) {
            dodaj_karte(B, Karty_przed_B[i], outB, &Blc);
        }
    }
    Wyniki_gry(N_GRA, 0);

}

int main() {
    int seed;
    int v;

    scanf("%d %d %d", &seed, &v, &num_conflict);
    srand((unsigned) seed);
    losuj();
    //cbuff_print(outA,Alc,A);
    //cbuff_print(outB,Blc,B);
    if (v == 0) {
        gra_standardowa();
    } else {
        gra_uproszczona();
    }
    //cbuff_print(outA,Alc,A);
    //cbuff_print(outB,Blc,B);
    return 0;
}
