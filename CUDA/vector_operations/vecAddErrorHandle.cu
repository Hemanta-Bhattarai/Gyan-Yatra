// Date March 26 2029
//Programer: Hemanta Bhattarai
// Progarm : To add two arrays and compare computation time in host and device

#include "cuda_runtime.h"
#include "device_launch_parameters.h"


#include <stdio.h>
#include <stdlib.h> //for random numbers

#include <time.h>
#include <sys/time.h>

#define gpuErrchk(ans){ gpuAssert((ans),__FILE__, __LINE__);}


inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort = true)
{
	if(code != cudaSuccess)
	{
		fprintf(stderr, "GPUassert : %s %s %d\n", cudaGetErrorString(code), file, line);
		if(abort) exit(code);
	}
}





// device kernal
__global__ void vecAdd(int *A, int *B, int *C, int *D, int array_size)
{
	int i = threadIdx.x + blockDim.x * blockIdx.x;
	
	if(i < array_size) D[i] = A[i] + B[i] + C[i];
}



int main()
{	
	// host function definition
	int get_random();
	
	//variable definition
	int *hA, *hB, *hC, *hD, *hE, *dA, *dB, *dC, *dD;
	int size_of_array;
	
	

	
	//define size of array
	printf("Enter the size of array");
	scanf("%d",&size_of_array);
	dim3 grid(1024);
	dim3 block((size_of_array/grid.x)+1);	
	int size = sizeof(int) * size_of_array;

	//memory allocation in host
	hA = (int*)malloc(size);
	hB = (int*)malloc(size);
	hC = (int*)malloc(size);
	hD = (int*)malloc(size);
	hE = (int*)malloc(size);
	
	//memory allocation in device
	gpuErrchk(cudaMalloc(&dA,size));
	gpuErrchk(cudaMalloc(&dB,size));
	gpuErrchk(cudaMalloc(&dC,size));
	gpuErrchk(cudaMalloc(&dD,size));


	//array initilization 
	for(int i=0; i<size_of_array; ++i) hA[i] = get_random();
	for(int i=0; i<size_of_array; ++i) hB[i] = get_random();
	for(int i=0; i<size_of_array; ++i) hC[i] = get_random();
	
	
	clock_t host_begin, host_end;
	//record begin of host computation
	host_begin = clock();

	//add vectors in host
	for(int i=0; i<size_of_array; ++i) hE[i] = hA[i] + hB[i] + hC[i];

	//record end of host computation
	host_end = clock();


	
	clock_t device_begin, device_end;
	
	
	//record of device computation
	device_begin = clock();


	//copy host data to memory
	gpuErrchk(cudaMemcpy(dA, hA, size, cudaMemcpyHostToDevice));
	gpuErrchk(cudaMemcpy(dB, hB, size, cudaMemcpyHostToDevice));
	gpuErrchk(cudaMemcpy(dC, hC, size, cudaMemcpyHostToDevice));
	gpuErrchk(cudaMemcpy(dD, hD, size, cudaMemcpyHostToDevice));
	
	//record start of device computation

	// add array in device
	vecAdd<<<block,grid>>>(dA, dB, dC, dD, size_of_array);


	//record end of device computation
	device_end = clock();


	//copy data from device to host
	gpuErrchk(cudaMemcpy(hD, dD, size, cudaMemcpyDeviceToHost));

	double host_time, device_time;
	host_time = (double)((double)(host_end - host_begin)/(CLOCKS_PER_SEC));
	device_time = (double)((double)(device_end - device_begin)/(CLOCKS_PER_SEC));

	//print the time of host and device computation
	printf("Host computation time: %f\n",host_time);
	printf("Device computation time: %f\n",device_time);

	//display the devation of device and host result
	int sum = 0;
	for(int i=0; i< size_of_array; ++i) sum += hE[i] - hD[i];
	printf("The deviation of host and device result is %d\n",sum);

	//free host memory
	free(hA);
	free(hB);
	free(hC);
	free(hD);
	free(hE);

	//free device memory
	gpuErrchk(cudaFree(dA));
	gpuErrchk(cudaFree(dB));
	gpuErrchk(cudaFree(dC));
	gpuErrchk(cudaFree(dD));

	

}

//random number generator
int get_random()
{
	return rand() % 100 + 1;
}

