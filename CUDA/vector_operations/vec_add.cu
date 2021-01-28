// Date March 26 2029
//Programer: Hemanta Bhattarai
// Progarm : To add two arrays



#include<stdio.h>
#include<stdlib.h> //for random numbers

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
	int *hA, *hB, *hC, *dA, *dB, *dC;
	int size_of_array;
	
	
	//define size of array
	printf("Enter the size of array");
	scanf("%d",&size_of_array);
	
	int size = sizeof(int) * size_of_array;

	//memory allocation in host
	hA = (int*)malloc(size);
	hB = (int*)malloc(size);
	hC = (int*)malloc(size);
	
	//memory allocation in device
	cudaMalloc(&dA,size);
	cudaMalloc(&dB,size);
	cudaMalloc(&dC,size);


	//array initilization 
	for(int i=0; i<size_of_array; ++i) hA[i] = get_random();
	for(int i=0; i<size_of_array; ++i) hB[i] = get_random();

	//copy host data to memory
	cudaMemcpy(dA, hA, size, cudaMemcpyHostToDevice);
	cudaMemcpy(dB, hB, size, cudaMemcpyHostToDevice);
	cudaMemcpy(dC, hC, size, cudaMemcpyHostToDevice);
	
	// add array in device
	vecAdd<<<1,size_of_array>>>(dA,dB,dC);

	//copy data from device to host
	cudaMemcpy(hC, dC, size, cudaMemcpyDeviceToHost);

	//display the result
	for(int i=0; i< size_of_array; ++i) printf("%d + %d = %d\n", hA[i], hB[i], hC[i]);

	//free host memory
	free(hA);
	free(hB);
	free(hC);

	//free device memory
	cudaFree(dA);
	cudaFree(dB);
	cudaFree(dC);
	

}

//random number generator
int get_random()
{
	return rand() % 100 + 1;
}

