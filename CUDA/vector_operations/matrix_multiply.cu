//Date 1 April 2019
//Program: To multiply two matrices

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




__global__ void matrix_multiply(int *A, int *B, int *C, int Am, int An, int Bn)
{
	int i = threadIdx.x;
	int j = threadIdx.y;

	int sum = 0;
	if(i < Am && j < Bn)
	{
		for(int k=0; k<An; ++k)
		{
			sum += A[ i * An + k] * B[k * Bn + j];
		}

		C[i * Bn + j] = sum;
	}

}

int main()
{	
	// host function definition
	int get_random();
	int get_max(int, int);	
	//variable definition
	int *hA, *hB, *hC, *hD, *dA, *dB, *dC;
	int rows_A, columns_A, rows_B, columns_B;
	
	

	
	//define size of array
	do{
		printf("The number of columns of first matrix must \n be equal to number of rows of second matrix!!!\n");
		printf("Enter the rows and columns of A\n");
		scanf("%d",&rows_A);
		scanf("%d",&columns_A);

		printf("Enter the rows and columns of B\n");
		scanf("%d",&rows_B);
		scanf("%d",&columns_B);
	}while(columns_A != rows_B);


	
	dim3 block(get_max(rows_A,rows_B), get_max(columns_A, columns_B));	
	int size = sizeof(int) * get_max(rows_A * columns_A, rows_B * columns_B);

	//memory allocation in host
	hA = (int*)malloc(size);
	hB = (int*)malloc(size);
	hC = (int*)malloc(size);
	hD = (int*)malloc(size);
	
	//memory allocation in device
	gpuErrchk(cudaMalloc((void**)&dA,size));
	gpuErrchk(cudaMalloc((void**)&dB,size));
	gpuErrchk(cudaMalloc((void**)&dC,size));


	//array initilization 
	for(int i=0; i<rows_A; ++i) 
	{
		for(int j=0; j< columns_A; ++j)
		{
			hA[i * columns_A + j] = get_random();

		}
	}
	
	for(int i=0; i<rows_B; ++i) 
	{
		for(int j=0; j< columns_B; ++j)
		{
			hB[i * columns_B + j] = get_random();

		}
	}	


	clock_t host_begin, host_end;
	//record begin of host computation
	host_begin = clock();

	//multiply matrix in host
	for(int i=0; i<rows_A; ++i) 
	{
		for(int j=0; j< columns_B; ++j)
		{
			int sum = 0;
			for(int k=0; k< columns_A; ++k) 
			{
			
				sum += hA[i * columns_A + k] * hB[k * columns_B + j];
				
			}
		
			hC[i * columns_B + j] = sum ;
			
		}
	}	


	//record end of host computation
	host_end = clock();


	
	clock_t device_begin, device_end;
	
	
	//record of device computation
	device_begin = clock();


	//copy host data to memory
	gpuErrchk(cudaMemcpy(dA, hA, size, cudaMemcpyHostToDevice));
	gpuErrchk(cudaMemcpy(dB, hB, size, cudaMemcpyHostToDevice));
	gpuErrchk(cudaMemcpy(dC, hC, size, cudaMemcpyHostToDevice));
	
	//record start of device computation

	// multiply matix in device
	matrix_multiply<<<1, block>>>(dA, dB, dC, rows_A, columns_A, columns_B );




	//copy data from device to host
	gpuErrchk(cudaMemcpy(hD, dC, size, cudaMemcpyDeviceToHost));

	//record end of device computation
	device_end = clock();

	double host_time, device_time;
	host_time = (double)((double)(host_end - host_begin)/(CLOCKS_PER_SEC));
	device_time = (double)((double)(device_end - device_begin)/(CLOCKS_PER_SEC));

	//print the time of host and device computation
	printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
	printf("\n\t\tHost computation time: %f\n",host_time);
	printf("\t\tDevice computation time: %f\n",device_time);
	printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");



	//-------------------------------------------------------------------------------
	/*
	// display element of A	
	printf("\n\n Matrix A\n\n");
	for(int i=0; i<rows_A; ++i) 
	{
		for(int j=0; j< columns_A; ++j)
		{
			printf("%d\t",hA[i * columns_A + j]);

		}
		printf("\n");
	}
	
	// display element of B	
	printf("\n\n Matrix B\n\n");
	for(int i=0; i<rows_B; ++i) 
	{
		for(int j=0; j< columns_B; ++j)
		{
			printf("%d\t",hA[i * columns_B + j]);

		}
		printf("\n");
	}
	
	// display element of AB	
	printf("\n\n Matrix AB\n\n");
	for(int i=0; i<rows_A; ++i) 
	{
		for(int j=0; j< columns_B; ++j)
		{
			printf("%d\t",hC[i * columns_B + j]);

		}
		printf("\n");
	}
	*/
	
	//display the devation of device and host result

	//--------------------------------------------------------------------------------------------




	int sum = 0;
	for(int i=0; i< rows_A; ++i) 
	{
		for(int j=0; j< columns_B; ++j)
		{
			sum += hD[i * columns_B + j] - hC[i * columns_B + j];
		}
	}
	printf("\nThe deviation of host and device result is %d\n",sum);

	
	
	//free host memory
	free(hA);
	free(hB);
	free(hC);
	free(hD);

	
	
	//free device memory
	gpuErrchk(cudaFree(dA));
	gpuErrchk(cudaFree(dB));
	gpuErrchk(cudaFree(dC));

	

}

//random number generator
int get_random()
{
	return rand() % 10 + 1;
}


int get_max(int a, int b)
{
	return a >= b ? a : b;
}
