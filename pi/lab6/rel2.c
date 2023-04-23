#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_REL_SIZE 100
#define MAX_RANGE 100

typedef struct {
	int first;
	int second;
} pair;

// Add pair to existing relation if not already there
int add_relation (pair*, int, pair);

// Case 1:

int get_domain(pair *rel, int n, int domain[MAX_REL_SIZE]){
    int cnt = 0;
    for (int i = 0; i < n; i++){
        bool should_add = true;
        for (int j = 0; j < cnt; j++){
            if (domain[j] == rel[i].first){
                should_add = false;
            }
        }
        if (should_add){
            domain[cnt] = rel[i].first;
            cnt ++;
        }

        should_add = true;
        for (int j = 0; j < cnt; j++){
            if (domain[j] == rel[i].second){
                should_add = false;
            }
        }
        if (should_add){
            domain[cnt] = rel[i].second;
            cnt ++;
        }
    }


    bool s = true;
    while (s){
        s = false;
        for (int i = 1; i < cnt; i++){
            if (domain[i] < domain[i-1]){
                int temp = domain[i];
                domain[i] = domain[i-1];
                domain[i-1] = temp;
                s = true;
            }
        }
    }


    return cnt;
}
// The relation R is reflexive if xRx for every x in X
int is_reflexive(pair *rel, int n){
    int domain[MAX_REL_SIZE];
    int n_domain = get_domain(rel, n, domain);
    for (int i = 0; i < n_domain; i++){
        bool is_ref = false;
        for (int j = 0; j < n; j++){
            if (domain[i] == rel[j].first){
                if (domain[i] == rel[j].second){
                    is_ref = true;
                }
            }
        }
        if (!is_ref){
            return 0;
        }
    }
    return 1;
}

// The relation R on the set X is called irreflexive
// if xRx is false for every x in X
int is_irreflexive(pair *rel, int n){
    for (int i = 0; i < n; i++){
        if (rel[i].first == rel[i].second){
            return 0;
        }
    }
    return 1;
}

// A binary relation R over a set X is symmetric if:
// for all x, y in X xRy <=> yRx
int is_symmetric(pair *rel, int n){
    for (int i = 0; i < n; i++){
        bool is_sym = false;
        for (int j = 0; j < n; j++){
            if (rel[j].first == rel[i].second && rel[j].second == rel[i].first){
                is_sym = true;
            }
        }
        if (!is_sym){
            return 0;
        }
    }
    return 1;
}

// A binary relation R over a set X is antisymmetric if:
// for all x,y in X if xRy and yRx then x=y
int is_antisymmetric(pair *rel, int n){
    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            if (rel[j].first == rel[i].second && rel[j].second == rel[i].first){
                if (rel[i].first != rel[i].second){
                    return 0;
                }
            }
        }
    }
    return 1;
}

// A binary relation R over a set X is asymmetric if:
// for all x,y in X if at least one of xRy and yRx is false
int is_asymmetric(pair *rel, int n){
    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            if (rel[j].first == rel[i].second && rel[j].second == rel[i].first){
                return 0;
            }
        }
    }
    return 1;
}

// A homogeneous relation R on the set X is a transitive relation if:
// for all x, y, z in X, if xRy and yRz, then xRz
int is_transitive(pair *rel, int n){
    for (int i = 0; i < n; i++){
        for (int j = 0; j < n; j++){
            if (rel[j].first == rel[i].second && rel[j].second == rel[i].first){
                bool is_tra = false;
                for (int k = 0; k < n; k++){
                    if (rel[k].first == rel[i].first && rel[k].second == rel[j].second){
                        is_tra = true;
                    }
                }
                if (!is_tra){
                    return 0;
                }
            }
        }
    }
    return 1;
}

// Case 2:

// A partial order relation is a homogeneous relation that is
// reflexive, transitive, and antisymmetric
int is_partial_order(pair *rel, int n){
    if (is_reflexive(rel, n) && is_transitive(rel, n) && is_antisymmetric(rel, n)){
        return 1;
    }
    return 0;
}

int is_connected(pair *rel, int n, int domain[MAX_REL_SIZE]){
    for (int i = 0; i < n; i ++){
        for (int j = i; j < n; j++){
            bool is_total = false;
            for (int k = 0; k < n; k++){
                if ((rel[k].first == domain[i] && rel[k].second == domain[j]) || (rel[k].first == domain[j] && rel[k].second == domain[i])){
                    is_total = true;
                }
            }
            if (!is_total){
                return 0;
            }
        }
    }
    return 1;
}
// A total order relation is a partial order relation that is connected
int is_total_order(pair *rel, int n, int domain[MAX_REL_SIZE]){
    if (!is_partial_order(rel, n)){
        return 0;
    }
    return is_connected(rel, n, domain);
}

// Relation R is connected if for each x, y in X:
// xRy or yRx (or both)

int find_max_elements(pair *rel, int n, int max_elements[]){
    int domain[MAX_REL_SIZE];
    int n_domain = get_domain(rel, n, domain);
    int cnt = 0;
    for (int i = 0; i < n_domain; i++){
        bool possible_max_el = false;
        for (int j = 0; j < n; j++){
            if (rel[j].second == domain[i]){
                possible_max_el = true;
            }
        }
        if (!possible_max_el){
            break;
        }

        for (int j = 0; j < n; j++){
            if (rel[j].first == domain[i]){
                if (rel[j].second != domain[i]){
                    possible_max_el = false;
                }
            }
        }

        if (possible_max_el){
            max_elements[cnt] = domain[i];
            cnt ++;
        }
    }
    return cnt;
}

int find_min_elements(pair *rel, int n, int min_elements[]){
    int domain[MAX_REL_SIZE];
    int n_domain = get_domain(rel, n, domain);
    int cnt = 0;
    for (int i = 0; i < n_domain; i++){
        bool possible_min_el = false;
        for (int j = 0; j < n; j++){
            if (rel[j].first == domain[i]){
                possible_min_el = true;
            }
        }
        if (!possible_min_el){
            break;
        }

        for (int j = 0; j < n; j++){
            if (rel[j].second == domain[i]){
                if (rel[j].first != domain[i]){
                    possible_min_el = false;
                }
            }
        }

        if (possible_min_el){
            min_elements[cnt] = domain[i];
            cnt ++;
        }
    }
    return cnt;
}


// Case 3:

int composition (pair *rel_1, int n_1, pair *rel_2, int n_2, pair comp_rel[]){
    int cnt = 0;
    for (int i = 0; i < n_1; i++){
        for (int j = 0; j < n_2; j++){
            if (rel_2[j].first == rel_1[i].second){
                pair new_pair;
                new_pair.first = rel_1[i].first;
                new_pair.second = rel_2[j].second;
                if (add_relation(comp_rel, cnt, new_pair)){
                    cnt ++;
                }
            }
        }
    }
    return cnt;
}

// Comparator for pair
int cmp_pair (const void *a, const void *b) {
}

int insert_int (int *tab, int n, int new_element) {
}

// Add pair to existing relation if not already there
int add_relation (pair tab[], int n, pair new_pair) {
    bool should_add = true;
    for (int i = 0; i < n; i++){
        if (tab[i].first == new_pair.first && tab[i].second == new_pair.second){
            should_add = false;
        }
    }
    if (should_add){
        tab[n].first = new_pair.first;
        tab[n].second = new_pair.second;
        return true;
    }
    return false;
}

// Read number of pairs, n, and then n pairs of ints
int read_relation(pair *relation) {
    int n = 0;
    scanf("%d", &n);
    for (int i = 0; i < n; i++){
        scanf("%d %d", &(relation + i)->first, &(relation + i)->second);
    }
    return n;
    }

void print_int_array(int *array, int n) {
    printf("%d\n", n);
    for (int i = 0; i < n; i++){
        printf("%d ", *(array + i));
    }
    printf("\n");
}

int main(void) {
	int to_do;
	pair relation[MAX_REL_SIZE];
	pair relation_2[MAX_REL_SIZE];
	pair comp_relation[MAX_REL_SIZE];
	int domain[MAX_REL_SIZE];
	int max_elements[MAX_REL_SIZE];
	int min_elements[MAX_REL_SIZE];

	scanf("%d",&to_do);
	int size = read_relation(relation);
	int ordered, size_2, n_domain;

	switch (to_do) {
		case 1:
			printf("%d ", is_reflexive(relation, size));
			printf("%d ", is_irreflexive(relation, size));
			printf("%d ", is_symmetric(relation, size));
			printf("%d ", is_antisymmetric(relation, size));
			printf("%d ", is_asymmetric(relation, size));
			printf("%d\n", is_transitive(relation, size));
			break;
		case 2:
			ordered = is_partial_order(relation, size);
			n_domain = get_domain(relation, size, domain);
			printf("%d %d\n", ordered, is_total_order(relation, size, domain));
			print_int_array(domain, n_domain);
			if (!ordered) break;
			int no_max_elements = find_max_elements(relation, size, max_elements);
			int no_min_elements = find_min_elements(relation, size, min_elements);
			print_int_array(max_elements, no_max_elements);
			print_int_array(min_elements, no_min_elements);
			break;
		case 3:
			size_2 = read_relation(relation_2);
			printf("%d\n", composition(relation, size, relation_2, size_2, comp_relation));
			break;
		default:
			printf("NOTHING TO DO FOR %d\n", to_do);
			break;
	}
	return 0;
}
