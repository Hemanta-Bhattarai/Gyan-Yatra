// Date March 28 2029
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
__global__ void vecAdd(float *A, float *B, float *C, float *D, int array_size)
{
	int i = threadIdx.x + blockDim.x * blockIdx.x;
	while(i < array_size) 
	{
		D[i] = A[i] + B[i] + C[i];
		i += blockDim.x * gridDim.x;  // each iteration will move the block-grid to access other element in matrix
	}
}



int main()
{	
	// host function definition
	float get_random();
	
	//variable definition
	float *hA, *hB, *hC, *hD, *dA, *dB, *dC;
        float *dD, *hE;
	float size_of_array;
	
	

	
	//define size of array
	printf("Enter the size of array");
	scanf("%f",&size_of_array);
	float size = sizeof(int) * size_of_array;

	//memory allocation in host
	hA = (float*)malloc(size);
	hB = (float*)malloc(size);
	hC = (float*)malloc(size);
	hD = (float*)malloc(size);
	hE = (float*)malloc(size);
	
	//memory allocation in device
	gpuErrchk(cudaMalloc((void**)&dA,size));
	gpuErrchk(cudaMalloc((void**)&dB,size));
	gpuErrchk(cudaMalloc((void**)&dC,size));
	gpuErrchk(cudaMalloc((void**)&dD,size));


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
	vecAdd<<<128,128>>>(dA, dB, dC, dD, size_of_array);
	gpuErrchk(cudaDeviceSynchronize());

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
	float sum = 0;
	for(int i=0; i< size_of_array; ++i) 
	{
		sum += hE[i] - hD[i];
	}
	printf("The deviation of host and device result is %f\n",sum);

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
float get_random()
{
	return rand() % 100 + 1;
}

