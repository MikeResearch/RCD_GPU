pgcc_acc:
	pgc++ -std=c++11 -DACC -ta=tesla -Minfo=all offload_reduction.cpp
gcc_omp:
	g++ -DOMP -fopenmp offload_reduction.cpp
gcc_offloadomp:
	g++ -DOLOMP -fopenmp -foffload=nvptx-none -foffload=-lm offload_reduction.cpp
gcc_acc:
	g++ -DACC -fopenacc -foffload=nvptx-none -foffload=-lm offload_reduction.cpp
clean:
	rm a.out
