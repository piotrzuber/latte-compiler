#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* concat(char* s1, char* s2) {
    size_t len1 = strlen(s1);
    size_t len2 = strlen(s2);

    char* ret = malloc(len1 + len2 + 1);
    memcpy(ret, s1, len1);
    memcpy(ret + len1, s2, len2);
    ret[len1 + len2] = 0;

    return ret;
}

void error() {
    printf("runtime error\n");
    exit(1);
}

void printInt(int num) {
    printf("%d\n", num);
}

void printString(char* str) {
    printf("%s\n", str);
}

int readInt() {
    int num;
    scanf("%d\n", &num);
    return num;
}

char* readString() {
    char* lineptr = NULL;
    size_t len;
    getline(&lineptr, &len, stdin);
    len = strlen(lineptr);
    lineptr[len - 1] = 0;
    return lineptr;
}