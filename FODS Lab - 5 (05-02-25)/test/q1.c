// Q1: Following program outputs according to following. Assume input>105. Write missing smallest.

// In missing do not use any number other than 100.

// Input	        106	    107	                108	                109
// Output	104,104,102,	102,	100,103,104,105,	100,104,104,102,

#include <stdio.h>

int p[] = {10, 7, 0, 105, 103, 11, 104, 102, 2, 1, 6, 100};
int r[] = {7, 107, 0, 108, 6, 8, 3, 106, 10, 109, 9, 4};
int q[] = {5, 101, 9, 4, 8, 3, 2, 1, 11, 5};

int main() {
    int a, b, c;
    scanf("%d", &a);

    b = q[a - 100];

    // missing smallest

    // Solution starts
    while (b != a) {
        c = b;
        while (c < 100) c = p[c];

        printf("%d,", c);

        b = r[b];
    }
    // Solution ends

    return 0;
}
