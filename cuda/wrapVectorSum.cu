#include "wrapVectorSum.h"
#include "vectorSumCUDA.h"
#include <iostream>
void wrapVectorSum(double *a, double *b, double *c, int size) {
	double *a_device, *b_device, *c_device;
	//Allocate space on GPU for our work
	cudaError_t gpucheck;
        gpucheck = cudaMalloc(&a_device, size * sizeof(double)); 
	if (gpucheck != cudaSuccess) {
                std::cout << "Error allocating memory on GPU. No GPU?" << std::endl;
                exit(1);
        };
	cudaMalloc(&b_device, size * sizeof(double));
	cudaMalloc(&c_device, size * sizeof(double)); // size * sizeof(int));
	//Copy a and b to GPU, we don't copy c since it's the result
	cudaMemcpy(a_device, a, size * sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(b_device, b, size * sizeof(double), cudaMemcpyHostToDevice);
	//CUDA max threads per block is 1024, this is CUDA limitation!
	int maxThreadsPerBlock = 1024;
	int sqrtMaxThreads = (int) sqrt(maxThreadsPerBlock);
	int totalNumBlocks = (size / maxThreadsPerBlock); 
	//int remainder = size % maxBlockSize;
	//int sqr = (int) sqrt(totalNumBlocks);
	//dim3 numBlocks(1,1,1); //bad implementation
	dim3 numBlocks(size,size,1); //good 3D implementaiton

	//Here we get into potential block issues if you're bigger than 1024
	dim3 threadsPerBlock(sqrtMaxThreads,sqrtMaxThreads);   
	std::cout << "calling a total of " << size * size << " blocks with " << sqrtMaxThreads << " x " << sqrtMaxThreads << " threads " << std::endl;
	//Call function in CUDA, <<< >>> is how many resources you're using
	//() is parameter list
	vectorSumCUDA <<< numBlocks, threadsPerBlock >>>(a_device, b_device, c_device);
	//Copy result from GPU back to CPU
	cudaMemcpy(c, c_device , size * sizeof(double),cudaMemcpyDeviceToHost);
	//No memory leaks, all mallocs should be freed !
	cudaFree(a_device); cudaFree(b_device); cudaFree(c_device);
}

