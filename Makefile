#CXX = mpicxx
# use -xmic-avx512 instead of -xHost for Intel Xeon Phi platforms

# XL
# --
#CXX = mpicxx
#OPTFLAGS = -O3 -qsmp=omp -qoffload -DOMP_TARGET_OFFLOAD -DPRINT_DIST_STATS #-DPRINT_EXTRA_NEDGES #-DUSE_MPI_RMA -DUSE_MPI_ACCUMULATE #-DUSE_32_BIT_GRAPH #-DDEBUG_PRINTF #-DUSE_MPI_RMA #-DPRINT_LCG_DOUBLE_LOHI_RANDOM_NUMBERS#-DUSE_MPI_RMA #-DPRINT_LCG_DOUBLE_RANDOM_NUMBERS #-DPRINT_RANDOM_XY_COORD

# LLVM
# ----
#CXX = clang++
#OPTFLAGS = -O3 -fopenmp -fopenmp-targets=nvptx64-nvidia-cuda --cuda-path=$(OLCF_CUDA_ROOT)  -DOMP_TARGET_OFFLOAD -DPRINT_DIST_STATS   -I$(MPI_ROOT)/include  -lmpi_ibm
#OPTFLAGS = -O3 -fopenmp -fopenmp-targets=nvptx64-nvidia-cuda --cuda-path=$(OLCF_CUDA_ROOT)  -DOMP_TARGET_OFFLOAD -DPRINT_DIST_STATS -l$(OLCF_LLVM_ROOT)/lib -I$(OLCF_LLVM_ROOT)/include

# NVHPC
# -----
CXX=nvc++ 
#OPTFLAGS =  -mp=gpu -gpu=cc70 -DOMP_TARGET_OFFLOAD -DPRINT_DIST_STATS -I$(MPI_ROOT)/include -lmpi_ibm 
# using unified memory
OPTFLAGS =  -mp=gpu -gpu=managed -DOMP_TARGET_OFFLOAD -DPRINT_DIST_STATS -I$(MPI_ROOT)/include -lmpi_ibm 

#-DUSE_MPI_SENDRECV
#-DUSE_MPI_COLLECTIVES
# use export ASAN_OPTIONS=verbosity=1 to check ASAN output
SNTFLAGS = -std=c++11 -fopenmp -fsanitize=address -O1 -fno-omit-frame-pointer
CXXFLAGS = -std=c++11 $(OPTFLAGS)
#CXXFLAGS = -std=c++11 -g $(OPTFLAGS)

OBJ = main.o
TARGET = miniVite

all: $(TARGET)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $^

$(TARGET):  $(OBJ)
	$(CXX) $^ $(OPTFLAGS) -o $@

.PHONY: clean

clean:
	rm -rf *~ $(OBJ) $(TARGET)
