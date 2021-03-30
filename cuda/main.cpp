#include "wrapVectorSum.h"
#include <iostream>
#include <chrono>
#include <cmath>
int main()  {
	int size = 1024;  //divisible by 1024 max block size start small like 512000
	double a[size], b[size], c[size]; //c[size];
	//populate a and b so adding a[i] and b[i] always = 100, easy test	
	for (int i = 0;i < size;i++) {
		a[i] = i;
		b[i] = size - i;
		c[i] = 0 ;
	}
        std::cout << "about to start clock" << std::endl;
        auto start = std::chrono::system_clock::now();
	wrapVectorSum(a,b,c,size);
        std::chrono::duration<double> duration = (std::chrono::system_clock::now() - start);
        std::cout << "Time spent in CUDA : " << duration.count() << " seconds" << std::endl;	
        double error = 0.0001,tmp; //round off, CPU/GPU math func imp is slightly different
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
