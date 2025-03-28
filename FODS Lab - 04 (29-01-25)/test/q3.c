// Question 3: Write output of following

#include <stdio.h>

int p[100];
int q[30];

void h(int y) {
    int i;
    i = q[y - 100];

    while (i < 100) {
        printf("%d,", i);
        i = p[i];
    }
}

void k(int y, int z) {
    p[y] = q[z - 100];
    q[z - 100] = y;
}

void main() {
    int i;

    for (i = 0; i < 9; i++)
        q[i] = 100 + i;

    k(17, 103);
    k(23, 107);
    k(34, 103);
    k(47, 103);
    k(91, 103);
    h(103);

    printf("pqr");
    k(27, 107);
    k(34, 107);
    k(12, 107);
    h(103);

    return;
}

// Solution: 91,47,34,17,pqr91,47,34,27,23,