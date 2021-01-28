// Date March 26 2029
//Programer: Hemanta Bhattarai
// Progarm : To add two arrays and compare computation time in host and device



#include <stdio.h>
#include <stdlib.h> //for random numbers

#include <time.h>
#include <sys/time.h>
// device kernal
__global__ void vecAdd(int *A, int *B, int *C)
{
	int i = threadIdx.x;
	C[i] = A[i] + B[i];
}



int main()
{	
	// host function definition
	int get_random();
	
	//variable definition
	int *hA, *hB, *hC, *hD, *dA, *dB, *dC;
	int size_of_array;
	
	struct timeval begin, end;

	cudaEvent_t start, stop;

	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	
	//define size of array
	printf("Enter the size of array");
	scanf("%d",&size_of_array);
	
	int size = sizeof(int) * size_of_array;

	//memory allocation in host
	hA = (int*)malloc(size);
	hB = (int*)malloc(size);
	hC = (int*)malloc(size);
	hD = (int*)malloc(size);
	
	//memory allocation in device
	cudaMalloc(&dA,size);
	cudaMalloc(&dB,size);
	cudaMalloc(&dC,size);


	//array initilization 
	for(int i=0; i<size_of_array; ++i) hA[i] = get_random();
	for(int i=0; i<size_of_array; ++i) hB[i] = get_random();
	
	//record start of host computation
	gettimeofday(&begin,NULL);

	//add vectors in host
	for(int i=0; i<size_of_array; ++i) hD[i] = hA[i] + hB[i];

	//record end of host computation
	gettimeofday(&end,NULL);

	//copy host data to memory
	cudaMemcpy(dA, hA, size, cudaMemcpyHostToDevice);
	cudaMemcpy(dB, hB, size, cudaMemcpyHostToDevice);
	cudaMemcpy(dC, hC, size, cudaMemcpyHostToDevice);
	
	//record start of device computation
	cudaEventRecord(start,0);

	// add array in device
	vecAdd<<<1,size_of_array>>>(dA,dB,dC);


	//record end of device computation
	cudaEventRecord(stop,0);

	float time_device;
	cudaEventElapsedTime(&time_device, start, stop);

	//copy data from device to host
	cudaMemcpy(hC, dC, size, cudaMemcpyDeviceToHost);

	float time_host = 1e6* (end.tv_sec - begin.tv_sec) + (end.tv_usec - begin.tv_usec);


	//print the time of host and device computation
	printf("Host computation time: %f\n",time_host);
	printf("Device computation time: %f\n",time_device);

	//display the devation of device and host result
	int sum = 0;
	for(int i=0; i< size_of_array; ++i) sum += hD[i] - hC[i];
	printf("The deviation of host and device result is %d\n",sum);

	//free host memory
	free(hA);
	free(hB);
	free(hC);
	free(hD);

	//free device memory
	cudaFree(dA);
	cudaFree(dB);
	cudaFree(dC);

	cudaEventDestroy(start);
	cudaEventDestroy(stop);
	

}

//random number generator
int get_random()
{
	return rand() % 100 + 1;
}

