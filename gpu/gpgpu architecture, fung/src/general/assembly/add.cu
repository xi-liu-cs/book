#include <stdio.h>

__global__ void add(int i)
{/* add.type d, a, b; d = a + b */
    int j;
    asm("add.s32 %0, %0, 1;\n" /* \n is used to separate instructions */
        "add.s32 %0, %0, 1;\n" /* ++i */
     : "=r"(i) : "r"(i));
    asm("mov.s32 %0, 0;\n" : "=r"(j)); /* j = 0 */
    printf("i = %d, j = %d\n", i, j);
}

int main()
{
    add<<<1, 1>>>(0);
    cudaDeviceSynchronize();
}
