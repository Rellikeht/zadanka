#include <stdio.h>
#include <math.h>

#define SIZE 40

void read_vector(double x[], int n) {
	for(int i = 0; i < n; ++i) {
		scanf("%lf", x++);
	}
}

void print_vector(double x[], int n) {
	for(int i = 0; i < n; ++i) {
		printf("%.4f ", x[i]);
	}
	printf("\n");
}

void read_mat(double A[][SIZE], int m, int n) {
	for(int i = 0; i < m; ++i) {
		for(int j = 0; j < n; ++j) {
			scanf("%lf", &A[i][j]);
		}
	}
}

void print_mat(double A[][SIZE], int m, int n) {
	for(int i = 0; i < m; ++i) {
		for(int j = 0; j < n; ++j) {
			printf("%.4f ", A[i][j]);
		}
		printf("\n");
	}
}

// 1. Calculate matrix product, AB = A X B
// A[m][p], B[p][n], AB[m][n]
void mat_product(double A[][SIZE], double B[][SIZE], double AB[][SIZE], int m, int p, int n) {
    int i, j, k;
    for (i = 0; i < m; i++){
        for (j = 0; j < n; j++){
            AB[i][j] = 0;
        }
    }
    for (i = 0; i < p; i++){
        for (j = 0; j < m; j++){
            for (k = 0; k < n; k++){
                AB[j][k] += A[j][i]*B[i][k];
            }
        }
    }
}


// 2. Matrix triangulation and determinant calculation - simplified version
// (no rows' swaps). If A[i][i] == 0, function returns NAN.
// Function may change A matrix elements.
double gauss_simplified(double A[][SIZE], int n) {
    double det = 1;
    for (int i = 0; i < n; i++){
        if (A[i][i] == 0) return NAN;
        det *= A[i][i];
        for (int j = i+1; j < n; j++){
            double mod = A[j][i]/A[i][i];
            for (int k = i; k < n; k++){
                A[j][k] -= mod*A[i][k];
            }
        }
    }
    return det;
}

void backward_substitution_index(double A[][SIZE], const int indices[], double x[], int n) {
}

// 3. Matrix triangulation, determinant calculation, and Ax = b solving - extended version
// (Swap the rows so that the row with the largest, leftmost nonzero entry is on top. While
// swapping the rows use index vector - do not copy entire rows.)
// If max A[i][i] < eps, function returns 0.
// If det != 0 && b != NULL && x != NULL then vector x should contain solution of Ax = b.

int swap_indecies(double A[][SIZE], int indecies[], const int n, const int level){
    double max = A[indecies[level]][level];
    int max_indecie = level, max_val = indecies[level];
    for (int i = level+1; i < n; i++){
        int mod1 = 1, mod2 = 1;
        if (max < 0) mod1 *= -1;
        if (A[indecies[i]][level] < 0) mod2 *= -1;
        if (max*mod1 < A[indecies[i]][level]*mod2){
            max = A[indecies[i]][level];
            max_indecie = i;
            max_val = indecies[i];
        }
    }
    indecies[max_indecie] = indecies[level];
    indecies[level] = max_val;

    return max_indecie - level;
}

void print_with_indecies (double A[][SIZE], int indecies[], int n){
    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            printf("%.4f ", A[indecies[i]][j]);
        }
        printf("\n");
    }
}

double gauss(double A[][SIZE], const double b[], double x[], const int n, const double eps) {
    double det = 1;
    int index_vector[n];
    for (int i = 0; i < n; i++){
        index_vector[i] = i;
    }
    double modifiable_b[n];
    for (int i = 0; i < n; i++){
        modifiable_b[i] = b[i];
    }

    for (int i = 0; i < n; i++){
        int exponent = swap_indecies(A, index_vector, n, i);

        double main_element = A[index_vector[i]][i];
        if (main_element < 0) main_element *= -1;
        if (main_element < eps) return 0;

        det *= pow(-1, exponent)*A[index_vector[i]][i];

        for (int j = i+1; j < n; j++){
            double mod = A[index_vector[j]][i]/A[index_vector[i]][i];
            for (int k = i; k < n; k++){
                A[index_vector[j]][k] -= mod*A[index_vector[i]][k];
            }
            modifiable_b[index_vector[j]] -= mod*modifiable_b[index_vector[i]];
        }
    }

    for (int i = n-1; i >= 0; i--){
        int j = n-1;
        while (x[j] != 0 && j > i){
            modifiable_b[index_vector[i]] -= x[j]*A[index_vector[i]][j];
            j--;
        }
        x[i] = modifiable_b[index_vector[i]]/A[index_vector[i]][i];
    }

    return det;
}

/*
// 4. Returns the determinant; B contains the inverse of A (if det(A) != 0)
// If max A[i][i] < eps, function returns 0.
double matrix_inv(double A[][SIZE], double B[][SIZE], int n, double eps, int index_vector[]) {
    double det = 1;
    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            B[i][j] = 0;
        }
    }
    for (int i = 0; i < n; i++){
        B[i][i] = 1;
        index_vector[i] = i;
    }
    for (int i = 0; i < n; i++){
        int exponent = swap_indecies(A, index_vector, n, i);

        double main_element = A[index_vector[i]][i];
        if (main_element < 0) main_element *= -1;
        if (main_element < eps) return 0;

        det *= pow(-1, exponent)*A[index_vector[i]][i];

        for (int j = i+1; j < n; j++){
            double mod = A[index_vector[j]][i]/A[index_vector[i]][i];
            for (int k = 0; k < n; k++){
                A[index_vector[j]][k] -= mod*A[index_vector[i]][k];
                B[index_vector[j]][k] -= mod*B[index_vector[i]][k];
            }
        }
    }

    for (int i = n-1; i >= 0; i--){
        for (int j = i-1; j >= 0; j--){
            if (A[index_vector[j]][i] != 0) {
                double mod = A[index_vector[j]][i] / A[index_vector[i]][i];
                for (int k = 0; k < n; k++) {
                    A[index_vector[j]][k] -= mod * A[index_vector[i]][k];
                    B[index_vector[j]][k] -= mod * B[index_vector[i]][k];
                }
            }
        }
        for (int k = 0; k < n; k++){
            B[index_vector[i]][k] /= A[index_vector[i]][i];
        }
    }

    return det;
}
*/

double f_abs(double a){
    if (a < 0) return -1*a;
    return a;
}

double not_normal_matrix_inv(double A[][SIZE], double B[][SIZE], int n, double eps){
    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            B[i][j] = 0;
            if (i == j) B[i][j] = 1;
        }
    }

    double det = 1;

    for (int i = 0; i < n; i++) {
        double el = A[i][i], rowA[n], rowB[n];
        for (int k = 0; k < n; k++) {
            rowA[k] = A[i][k];
            rowB[k] = B[i][k];
        }
        int ix = i;
        for (int j = i + 1; j < n; j++) {
            if (f_abs(A[j][i]) > f_abs(el)) {
                ix = j;
                el = A[j][i];
                for (int k = 0; k < n; k++) {
                    rowA[k] = A[j][k];
                    rowB[k] = B[j][k];
                }
                det *= -1;
            }
        }
        for (int j = 0; j < n; j++) {
            A[ix][j] = A[i][j];
            A[i][j] = rowA[j];

            B[ix][j] = B[i][j];
            B[i][j] = rowB[j];
        }

        double main_element = A[i][i];
        if (main_element < 0) main_element *= -1;
        if (main_element < eps) return 0;

        det *= A[i][i];

        for (int j = i+1; j < n; j++){
            double mod = A[j][i]/A[i][i];
            for (int k = 0; k < n; k++){
                A[j][k] -= mod*A[i][k];
                B[j][k] -= mod*B[i][k];
            }
        }
    }

    for (int i = n-1; i >= 0; i--) {
        double main_element = A[i][i];
        if (main_element < 0) main_element *= -1;
        if (main_element < eps) return 0;

        for (int j = i-1; j >= 0; j--){
            double mod = A[j][i]/A[i][i];
            for (int k = 0; k < n; k++){
                A[j][k] -= mod*A[i][k];
                B[j][k] -= mod*B[i][k];
            }
        }
    }

    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            B[i][j] /= A[i][i];
        }
    }

    return det;
}

double matrix_inv(double A[][SIZE], double B[][SIZE], int n, double eps) {
    double det = 1;
    int index_vector[n];
    for (int i = 0; i < n; i++) index_vector[i] = i;

    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            B[i][j] = 0;
            if (i == j) B[i][j] = 1;
        }
    }

    for (int i = 0; i < n; i++){
        int exponent = swap_indecies(A, index_vector, n, i);

        double main_element = A[index_vector[i]][i];
        if (main_element < 0) main_element *= -1;
        if (main_element < eps) return 0;

        det *= pow(-1, exponent)*A[index_vector[i]][i];

        for (int j = 1; j < n; j++){
            double mod = A[index_vector[j]][i]/A[index_vector[i]][i];
            for (int k = 0; k < n; k++){
                A[index_vector[j]][k] -= mod*A[index_vector[i]][k];
                B[index_vector[j]][k] -= mod*B[index_vector[i]][k];
            }
        }
    }

    return det;
}

int main(void) {

	double A[SIZE][SIZE], B[SIZE][SIZE], C[SIZE][SIZE];
	double b[SIZE], x[SIZE], det, eps = 1.e-13;
    int index_vector[SIZE];

	int to_do;
	int m, n, p;

	scanf ("%d", &to_do);

	switch (to_do) {
		case 1:
			scanf("%d %d %d", &m, &p, &n);
			read_mat(A, m, p);
			read_mat(B, p, n);
			mat_product(A, B, C, m, p, n);
			print_mat(C, m, n);
			break;
		case 2:
			scanf("%d", &n);
			read_mat(A, n, n);
			printf("%.4f\n", gauss_simplified(A, n));
			break;
		case 3:
			scanf("%d", &n);
			read_mat(A,n, n);
			read_vector(b, n);
			det = gauss(A, b, x, n, eps);
			printf("%.4f\n", det);
			if (det) print_vector(x, n);
			break;
		case 4:
			scanf("%d", &n);
			read_mat(A, n, n);
            //det = matrix_inv(A, B, n, eps, index_vector);
            det = not_normal_matrix_inv(A, B, n, eps);
			printf("%.4f\n", det);
			if (det) print_mat(B, n, n);
			break;
		default:
			printf("NOTHING TO DO FOR %d\n", to_do);
			break;
	}
	return 0;
}

