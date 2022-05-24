#include <stdio.h>

__global__ void saxpy(int n, float a, float * x, float * y)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if(i < n)
        y[i] = a * x[i] + y[i];
}

void print(float * a, int n)
{
    for(int i = 0; i < n; ++i)
        printf("%f ", a[i]);
    printf("\n");
}

int main()
{
    float * h_x, * h_y;
    int n;
    float x[] = {1, 1, 1};
    float y[] = {1, 1, 1};
    n = sizeof(x) / sizeof(*x);
    h_x = (float *)malloc(sizeof(x));
    h_y = (float *)malloc(sizeof(y));
    memcpy(h_x, x, sizeof(x));
    memcpy(h_y, y, sizeof(y));
    float * d_x, * d_y;
    int th_per_blk = 256,
    blk_per_grid = (n + th_per_blk - 1) / th_per_blk;
    cudaMalloc(&d_x, n * sizeof(float));
    cudaMalloc(&d_y, n * sizeof(float));
    cudaMemcpy(d_x, h_x, n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_y, h_y, n * sizeof(float), cudaMemcpyHostToDevice);
    saxpy<<<blk_per_grid, th_per_blk>>>(n, 2.0, d_x, d_y);
    cudaMemcpy(h_y, d_y, n * sizeof(float), cudaMemcpyDeviceToHost);
    print(h_y, n);
}
