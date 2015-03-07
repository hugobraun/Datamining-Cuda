#include <cuda_runtime.h>
#include <helper_cuda.h>

#include <helper_functions.h>
#include <stdlib.h>
#include <stdio.h>
#include "../configuration.h"
#include "gpu_knn.h"

const int blocksize = 16;
__global__ void gpu_distance(int* data, float* distance, int* point, int n, int dim) {
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	
	if (i >= n)
		return;

	float d = 0;

        for(int j = 0; j<dim; j++)
                d += abs(data[i*dim + j] - point[j]);

	distance[i] = d;	
}

int gpu_knn(int * cdata_c, int * data_c, int * point_c, int nclass) {
	
	int datasize = N*DIM*sizeof(int);
	int nblock = N / blocksize, nthread = blocksize;
	
	float *distance = new float[N]; 

	int *d_data;
	int *d_point;	
	float *d_distance;

	checkCudaErrors(cudaMalloc((void**)&d_data, datasize));	
	checkCudaErrors(cudaMalloc((void**)&d_distance, N*sizeof(float)));
	checkCudaErrors(cudaMalloc((void**)&d_point, DIM*sizeof(int)));

	checkCudaErrors(cudaMemcpy(d_data, data_c, datasize, cudaMemcpyHostToDevice));
	checkCudaErrors(cudaMemcpy(d_point, point_c, DIM*sizeof(int), cudaMemcpyHostToDevice));

	gpu_distance<<<nblock,nthread>>>(d_data,d_distance,d_point,N,DIM);

	checkCudaErrors(cudaMemcpy(distance, d_distance, N*sizeof(float), cudaMemcpyDeviceToHost));

	checkCudaErrors(cudaFree(d_distance)); 
 	checkCudaErrors(cudaFree(d_data)); 
 	checkCudaErrors(cudaFree(d_point)); 
	
 	printf("Memory 6 \n");
	return -1;
}



