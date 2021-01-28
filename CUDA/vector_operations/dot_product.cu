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

const int threads_per_block = 128;



// device kernal
__global__ void dotProduct(float *A, float *B, float *D, int array_size)
{
	__shared__ float cache[threads_per_block];
	int i = threadIdx.x + blockDim.x * blockIdx.x;
	int cache_index = threadIdx.x;
	float temp = 0;
	while(i < array_size) 
	{

		temp += A[i] * B[i];
		i += blockDim.x * gridDim.x;  // each iteration will move the block-grid to access other element in matrix
	}

	cache[cache_index] = temp;
	__syncthreads(); //waits for all the threads to complete

	//for reductions, threadsPerBlock must be power of 2 due to following code
	int j = blockDim.x/2;
	while(j != 0){
		if (cache_index<j)
			cache[cache_index] += cache[cache_index + j];
		__syncthreads();
		j /=2;
		
	}

	if (cache_index == 0)
		D[blockIdx.x] = cache[0];	
}



int main()
{	
	// host function definition
	float get_random();
	
	//variable definition
	float *hA, *hB, *dA, *dB;
	float size_of_array, result_host, *result_device, *partial_result_from_device;
	
	

	
	//define size of array
	printf("Enter the size of array");
	scanf("%f",&size_of_array);
	float size = sizeof(float) * size_of_array;

	int blocks_per_grid = int(size_of_array/threads_per_block + 1);
	//memory allocation in host
	hA = (float*)malloc(size);
	hB = (float*)malloc(size);
	partial_result_from_device = (float*) malloc(sizeof(float) * blocks_per_grid);
	
	//memory allocation in device
	gpuErrchk(cudaMalloc((void**)&dA,size));
	gpuErrchk(cudaMalloc((void**)&dB,size));
	gpuErrchk(cudaMalloc((void**)&result_device, blocks_per_grid * sizeof(float)));



	//array initilization 
	for(int i=0; i<size_of_array; ++i) hA[i] = get_random();
	for(int i=0; i<size_of_array; ++i) hB[i] = get_random();
	
	
	clock_t host_begin, host_end;
	//record begin of host computation
	host_begin = clock();

	//add vectors in host
	result_host = 0;
	for(int i=0; i<size_of_array; ++i) result_host += hA[i] * hB[i];

	//record end of host computation
	host_end = clock();


	
	clock_t device_begin, device_end;
	
	
	//record of device computation
	device_begin = clock();


	//copy host data to memory
	gpuErrchk(cudaMemcpy(dA, hA, size, cudaMemcpyHostToDevice));
	gpuErrchk(cudaMemcpy(dB, hB, size, cudaMemcpyHostToDevice));
	
	//record start of device computation

	// dot product in device
	dotProduct<<<blocks_per_grid, threads_per_block>>>(dA, dB, result_device, size_of_array);
	
	gpuErrchk(cudaDeviceSynchronize());



	//copy data from device to host
	gpuErrchk(cudaMemcpy(partial_result_from_device, result_device, blocks_per_grid * sizeof(float), cudaMemcpyDeviceToHost));

	float final_result = 0;
	for(int i=0; i< blocks_per_grid; i++) final_result += partial_result_from_device[i];

	//record end of device computation
	device_end = clock();
	

	double host_time, device_time;
	host_time = (double)((double)(host_end - host_begin)/(CLOCKS_PER_SEC));
	device_time = (double)((double)(device_end - device_begin)/(CLOCKS_PER_SEC));

	//print the time of host and device computation
	printf("Host computation time: %f\n",host_time);
	printf("Device computation time: %f\n",device_time);

	//display the devation of device and host result
	printf("The deviation of host and device result is %f\n",final_result - result_host);

	//free host memory
	free(hA);
	free(hB);

	//free device memory
	gpuErrchk(cudaFree(dA));
	gpuErrchk(cudaFree(dB));

	

}

//random number generator
float get_random()
{
	return rand() % 100 + 1;
}

