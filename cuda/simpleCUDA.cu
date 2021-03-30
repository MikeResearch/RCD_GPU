#include <cuda.h>
#include <iostream>

__global__ void simplestDeviceFunction(int *dev) {
	//threadIdx.x is the ID of the thread in x direction, can have 3D
	int tid = threadIdx.x;
	//tid in this program will be anywhere from 0 to size - 1, all executing at once
	dev[tid] = tid;
}
int main() {
	int size = 64;
	int a[size];
	//dim3 - special CUDA type to declare how many blocks and threads you want
        dim3 numBlocks(1,1,1); //BLOCKS, not threads
        dim3 threadsPerBlock(size,1);    //How many threads are in each block
	int *a_device;
	//Memory management, have to declare space on device
	cudaError_t gpucheck;
	gpucheck = cudaMalloc(&a_device, size * sizeof(int));
	if (gpucheck != cudaSuccess) {
		std::cout << "Error allocating memory on GPU. No GPU?" << std::endl;
		exit(1);
	}
	//Call CUDA function on graphics card - function name, resources,parameters
	simplestDeviceFunction<<< numBlocks, threadsPerBlock >>>(a_device);
	//After work is done, copy result from GPU back to CPU
	cudaMemcpy(a, a_device, size*sizeof(int), cudaMemcpyDeviceToHost);
	//What is in a?
	for (int i = 0;i < size;i++)
		std::cout << a[i] << std::endl;
}
