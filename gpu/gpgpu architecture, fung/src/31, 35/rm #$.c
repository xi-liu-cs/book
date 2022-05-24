#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define file FILE 

int main(int argc, char ** argv)
{
    file * stream;
    char * line = 0;
    size_t len = 0;
    ssize_t nread;

    if (argc != 2) 
    {
        fprintf(stderr, "usage: %s <file>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    stream = fopen(argv[1], "r");
    if (!stream) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    char * new_file_name = malloc(strlen(argv[1]) + 2);
    strcpy(new_file_name, "_");
    strcat(new_file_name, argv[1]);
    file * new_file = fopen(new_file_name, "w+");

    while ((nread = getline(&line, &len, stream)) != -1)
    {
        fwrite(line + 3, nread - 3, 1, new_file);
    }

    free(line);
    fclose(stream);
    exit(EXIT_SUCCESS);
}