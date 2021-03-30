#include <iostream>
#include <cmath>
#include <chrono>
//compile with compiler directives
//g++ -DOMP -fopenmp offload.cpp
//g++ -DOLOMP -fopenmp -foffload=nvptx-none -foffload=-lm offload.cpp
//g++ -DACC -fopenacc -foffload=nvptx-none -foffload=-lm offload.cpp
//With cuda10.0, and nvidia_hpcsdk loaded, can compile with:
//pgc++ -std=c++11 -DACC -ta=tesla -Minfo=all offload_reduction.cpp 
//
int main()  {
	int size = 1024;
	double a[size], b[size], c[size], tmp;
	//populate a and b 	
	for (int i = 0;i < size;i++) {
		a[i] = i;
		b[i] = size - i;
		c[i] = 0;
	}
	std::cout << "about to start clock" << std::endl;
	auto start = std::chrono::system_clock::now();
	std::string which;
#ifdef OLOMP
	which = "Offloaded OpenMP";
	#pragma omp target teams distribute parallel for  map(to:a[0:size],b[0:size]) map(from:c[0:size]) reduction(+:tmp) 
#endif
#ifdef ACC
	which = "Open ACC";
	//#pragma acc data copyin(a,b,tmp) copyout(c)
	//#pragma acc parallel loop reduction(+:tmp)   
	#pragma acc parallel loop
#endif
#ifdef OMP
	which = "OpenMP on CPU";
	#pragma omp parallel for reduction(+:tmp) 
#endif
	for (int i = 0;i < size;i++) {
		tmp = 0.0f;
		for (int j = 0;j < size;j++) {
			for (int k = 0;k < size;k++) {
			    tmp += (sin(a[i]) * sin(b[j]) * pow(cos(a[j]),5)) * sin(k);
			}
		}
		c[i] = tmp;
	}
	std::chrono::duration<double> duration = (std::chrono::system_clock::now() - start);
	std::cout << "Time spent in parallel/GPU matrix manipulation: " << duration.count() << " seconds" << std::endl;
	std::cout << "truth check using single thread on CPU" << std::endl;
        double error = 0.0001; //round off, CPU/GPU math func imp is slightly different
	for (int i = 0;i < size;i++) {
		tmp = 0.0f;
                for (int j = 0;j < size;j++) {
                        for (int k = 0;k < size;k++) {
                            tmp += (sin(a[i]) * sin(b[j]) * pow(cos(a[j]),5)) * sin(k) ;
                        }
                }
                if (fabs(c[i] - tmp) > error)
                  std::cout << "ERROR AT index " << i << std::endl;
		std::cout << c[i] << " " << tmp << std::endl;
        }
}
