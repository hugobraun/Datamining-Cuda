#include "cpu_sort.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int cmpfunc(const void * a, const void * b)
{
   return ( *(int*)a - *(int*)b );
}

void cpu_sort(int * data, int n) {
	qsort(data, n, sizeof(int), cmpfunc);
}

void cpu_benchmark_sort(int * data, int n, int ntests) {
	printf("------------------------------------------\n");
	printf("Starting benchmark for cpu sort (ntests = %i, array size = %i)\n", ntests, n);
	printf("------------------------------------------\n");

	clock_t start_t, end_t, total_t;

   start_t = clock();
   for(int i =0; i < ntests; i++)
	   cpu_sort(data, n);
   end_t = clock();

   total_t = (double)(end_t - start_t) / CLOCKS_PER_SEC;
   printf("Total time taken by CPU: %f\n", total_t );
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
