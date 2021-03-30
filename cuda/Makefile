CC=g++
CFLAGSCUDA=-c -Wall -std=c++11
LFLAGSCUDA=-lcudart
NVCC=nvcc
NVCC_FLAGS=-c -arch=sm_70

all:
	$(NVCC) $(NVCC_FLAGS) vectorSumCUDA.cu
	$(NVCC) $(NVCC_FLAGS) wrapVectorSum.cu
	$(CC) $(CFLAGSCUDA) main.cpp
	$(CC) $(LFLAGSCUDA) vectorSumCUDA.o wrapVectorSum.o main.o -o vecSumExe 
	
clean:
	rm *.o vecSumExe a.out

