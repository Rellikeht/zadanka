#include "bibl1.h"
#include <stdio.h>
#include <stdlib.h>

/*napisz biblioteke ladowana dynamicznie przez program zawierajaca funkcje:

1) zliczajaca sume n elementow tablicy tab:
int sumuj(int *tab, int n);

2) liczaca srednia n elementow tablicy tab
double srednia(int *tab, int n);

*/

extern int sumuj(int *tab, int n) {
  int suma = 0;
  for (int i = 0; i < n; i++) {
    suma += tab[i];
  }
  return suma;
}

extern double srednia(int *tab, int n) { return sumuj(tab, n) / n; }
