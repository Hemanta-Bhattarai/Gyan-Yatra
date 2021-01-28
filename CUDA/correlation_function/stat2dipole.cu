#include "cuda_runtime.h"
#include "device_launch_parameters.h"



#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>

using namespace std;



#define gpuErrchk(ans){gpuAssert((ans), __FILE__, __LINE__);}

inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort = true)
{
	if(code != cudaSuccess)
	{
		fprintf(stderr, "GPUassert : %s %s %d\n", cudaGetErrorString(code), file, line);
		if(abort) exit(code);
	}
}




__global__ void dipoleCorrelation(double *px, double *py, double *pz, double *corr, int N)
{

  int tau = threadIdx.x + blockDim.x * blockIdx.x;
  double local_corr = 0;
	if(tau < N)
	{

  	for(int index = 0; index  < N - tau; ++index)
  	{

    	local_corr +=   px[index] * px[index + tau]
                  	+ py[index] * py[index + tau]
                  	+ pz[index] * pz[index + tau];
		

  	}
  	local_corr = local_corr/(N-tau);
  	corr[tau] = local_corr;
	}
	__syncthreads();
}

int main()
{
  string data, line, word;
  int pos(8);
  vector< double > dipole_x, dipole_y, dipole_z;
  vector< double > t;
  const string fileName = "Platinum_nanosphere_run2.stat";
  const string fileOut = "CorrfuncCuda.wcorr";

  ifstream file;

  //open file

  file.open(fileName,ios::in);
  if(!file)
  {
    cout<<"Error in opening file"<<endl;
    return -1;

  }

  while(!file.eof())
  {
   getline(file, line);
   int i = 0;
   stringstream is(line);

   while( is >> word )
   {
     if  (word.compare("#") == 0 || word.compare("##") == 0 ) break;
     if(i == 0) t.push_back(stod(word));
     if(i == pos)
     {
       dipole_x.push_back(stod(word));
     }
     if(i == pos + 1)
     {
       dipole_y.push_back(stod(word));
     }

     if(i == pos + 2)
     {
       dipole_z.push_back(stod(word));
     }
     i++;

   }
  }
cout<<"Dipole vector list created"<<endl;
//vector<double> dipole_corr, corr_time;

// calculation of co-orelation  function
ofstream outfile;
outfile.open(fileOut);
int N = dipole_x.size();
double *xcomp_dipole = &dipole_x[0];  //convert dipole_x vector to array
double *ycomp_dipole = &dipole_y[0];
double *zcomp_dipole = &dipole_z[0];

double *xcomp_dipole_d, *ycomp_dipole_d, *zcomp_dipole_d;
double *corr_h, *corr_d;
corr_h = (double*)malloc(N*sizeof(double));

double dt = t[1]-t[0];
cout<<"Finding the correlation funciton"<<endl;

gpuErrchk(cudaMalloc((void**)&xcomp_dipole_d, N * sizeof(double)));
gpuErrchk(cudaMalloc((void**)&ycomp_dipole_d, N * sizeof(double)));
gpuErrchk(cudaMalloc((void**)&zcomp_dipole_d, N * sizeof(double)));
gpuErrchk(cudaMalloc((void**)&corr_d, N * sizeof(double)));

/*
for(int index =0; index  < N ; ++index)
{
	printf("Index: %d Px: %e, Py: %e, Pz: %e\n",index,xcomp_dipole[index],ycomp_dipole[index],zcomp_dipole[index]);
	printf("Index: %d Px: %e, Py: %e, Pz: %e\n",index,dipole_x[index],dipole_y[index],dipole_z[index]);


}

*/


gpuErrchk(cudaMemcpy(xcomp_dipole_d, xcomp_dipole, N * sizeof(double), cudaMemcpyHostToDevice));
gpuErrchk(cudaMemcpy(ycomp_dipole_d, ycomp_dipole, N * sizeof(double), cudaMemcpyHostToDevice));
gpuErrchk(cudaMemcpy(zcomp_dipole_d, zcomp_dipole, N * sizeof(double), cudaMemcpyHostToDevice));
gpuErrchk(cudaMemcpy(corr_d, corr_h, N * sizeof(double), cudaMemcpyHostToDevice));


int number_of_blocks;
number_of_blocks = ( N/1024 ) + 1;

dipoleCorrelation<<<number_of_blocks,1024>>> (xcomp_dipole_d, ycomp_dipole_d, zcomp_dipole_d, corr_d, N);
gpuErrchk(cudaDeviceSynchronize());

gpuErrchk(cudaMemcpy(corr_h, corr_d, N * sizeof(double), cudaMemcpyDeviceToHost));

outfile<<"## charge velocity autocorrelation function"<<endl;
outfile<<"# time(tau)\t wcorr"<<endl;
for(int count= 0; count < N ; ++count )
{
  outfile << t[count] << "\t" << corr_h[count]<<endl;
//	cout << t[count] << "\t" << corr_h[count]<<endl;
  //dipole_corr.push_back(local_corr/(length - tau));
  //corr_time.push_back(tau * dt);
}
outfile.close();



delete [] corr_h;
corr_h = NULL;

gpuErrchk(cudaFree(corr_d));

}
