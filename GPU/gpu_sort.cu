
#include <cuda_runtime.h>
#include <helper_cuda.h>

#include <helper_functions.h>
#include <stdlib.h>
#include <stdio.h>
#include "../configuration.h"


#include <stdio.h>

#include <stdlib.h>

#include "gpu_sort.h"


/*
 * Naive sort
 * used if the quicksort uses too many levels
 */
__device__ void naivesort(int *data, int left, int right )
{
  for(int i = left ; i <= right ; ++i)
  {
    int min = data[i];
    int imin= i;

    for(int j = i+1 ; j <= right ; ++j)
    {
      int vj = data[j];
      if(vj < min)
      {
        imin = j;
        min = vj;
      }
    }

    if(i != imin)
    {
      data[imin] = data[i];
      data[i] = min;
    }
  }
}

/*
 * The idea behind that approach is that sorting an already sorted list is really fast
 * We do not need to warn the thread that the portion is already sorted
 *
 *
 * TODO : max_levels
 */
__global__ void kernel_quicksort(int* values, int n) {
 #define MAX_LEVELS	1000

	int pivot, L, R;
	int idx =  threadIdx.x + blockIdx.x * blockDim.x;
	int start[MAX_LEVELS];
	int end[MAX_LEVELS];

	start[idx] = idx;
	end[idx] = n - 1;
	while (idx >= 0) {
		L = start[idx];
		R = end[idx];
		if (L < R) {
			pivot = values[L];
			while (L < R) {
				while (values[R] >= pivot && L < R)
					R--;
				if(L < R)
					values[L++] = values[R];
				while (values[L] < pivot && L < R)
					L++;
				if (L < R)
					values[R--] = values[L];
			}
			values[L] = pivot;

			start[idx + 1] = L + 1;
			end[idx + 1] = end[idx];
			end[idx++] = L;


			if (end[idx] - start[idx] > end[idx - 1] - start[idx - 1]) {
        	                int tmp = start[idx];
                	        start[idx] = start[idx - 1];
                        	start[idx - 1] = tmp;

        	                tmp = end[idx];
                	        end[idx] = end[idx - 1];
                        	end[idx - 1] = tmp;
	        }

		}
		else
			idx--;
	}
}

void gpu_quicksort(int * data, int n) {

	int datasize = n*sizeof(int);
	int *d_data;
	checkCudaErrors(cudaMalloc((void**)&d_data, datasize));
	checkCudaErrors(cudaMemcpy(d_data, data, datasize, cudaMemcpyHostToDevice));

	kernel_quicksort<<<1,1,128>>>(d_data,n);

	checkCudaErrors(cudaMemcpy(data, d_data, datasize, cudaMemcpyDeviceToHost));

 	checkCudaErrors(cudaFree(d_data));
}

void gpu_quicksort_benchmark(int * data, int n, int ntests) {
	printf("------------------------------------------\n");
	printf("Starting benchmark for gpu quicksort (ntests = %i, array size = %i)\n", ntests, n);
	printf("------------------------------------------\n");

	StopWatchInterface *timer = 0;
	sdkCreateTimer(&timer);
	sdkStartTimer(&timer);

	for(int i =0; i < ntests; i++)
		gpu_quicksort(data, n);

	sdkStopTimer(&timer);

	printf("------------------------------------------\n");
	printf("Sorting of array size %i done. Processing time on GPU per job: %f (ms)\n",n,sdkGetTimerValue(&timer)/ntests);
	printf("------------------------------------------\n");

	printf("\nTesting results...\n");
	for (int x = 0; x < n - 1; x++) {
		if (data[x] > data[x + 1]) {
				printf("Sorting failed.\n");
				break;
		}
		else
			if (x == n - 2)
					printf("SORTING SUCCESSFUL\n");
	}


}
