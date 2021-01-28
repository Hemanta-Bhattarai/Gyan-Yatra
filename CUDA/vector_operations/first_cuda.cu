#include<stdio.h>


__global__ void print()
{
	int i = threadIdx.x;
	printf("%d\n",i);
}

int main()
{
	print<<<1,4>>>();
	cudaDeviceSynchronize();

	cudaDeviceReset();
	return 0;
	
}
