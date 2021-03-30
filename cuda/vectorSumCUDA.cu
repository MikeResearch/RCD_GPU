#include "vectorSumCUDA.h"
#include <stdlib.h>
#include <stdio.h>
#include <cmath>
__global__ void vectorSumCUDA(double *aDev, double *bDev, double *cDev) {
	//Have to think in 3D, this CUDA function will do a triple nested loop with
	//reduction. NOTE no for statements anywhere!
	const int atid = blockIdx.x ; //number from 0-1024, similar to i loop
	const int btid = blockIdx.y ; //number from 0-1024, similar to j loop
	//The tid below is a local thread in the block, each block has 1024 threads
	//so this will range from 0-1024
	const int tid = (threadIdx.x * blockDim.x) + threadIdx.y;
	//atomicAdd is CUDA's add function to take care of race conditions
	atomicAdd(&cDev[tid],  (sinf(aDev[atid]) * sinf(bDev[btid]) * pow(cosf(aDev[btid]),5)) * sinf(tid));
	//Bad CUDA implementation below, this would work if called on one block but would
	//be very slow
	/*for (int i = 0;i < 1024;i++) {
		for (int j = 0;j < 1024;j++)
			atomicAdd(&cDev[tid], (sinf(aDev[i]) * sinf(bDev[j]) * pow(cosf(aDev[j]),5)) * sinf(tid));
	}*/

}

