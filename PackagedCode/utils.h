#ifndef _UTILS_
#define _UTILS_

/*****************************************************************
 * CPP Utils
 * - Plant info and macro alg settings
 * - Includes
 * - Threading helpers
 * - Clock/Timing helpers
 * - Hangover from previous versions helpers
 * - Math helpers
 * - Matrix Dimmensions
 *****************************************************************/

/*****************************************************************
 * PLANT INFO AND MACRO ALG SETTINGS
 *****************************************************************/
#ifndef NUM_POS
    #define NUM_POS 7
#endif

#define STATE_SIZE (2*NUM_POS)
#define CONTROL_SIZE 7
// #define NUM_TIME_STEPS 64
#define TOTAL_TIME 0.5
#define TOTAL_TIME_ms (TOTAL_TIME*1000.0)
#define TOTAL_TIME_us (TOTAL_TIME_ms*1000.0)
#define EE_COST 1
#define EE_TYPE 1 // flange but no EE on it
// define if we are working in doubles or floats
// typedef double algType;
typedef float algType;
#define DEBUG_SWITCH 0 // 1 for on 0 for off

// parallelism options
#define M_BLOCKS_B 4//M_BLOCKS // how many time steps to do in parallel on back pass
#define M_BLOCKS_F 2//M_BLOCKS // how many multiple shooting intervals to use in the forward pass
// #define N_BLOCKS_B (NUM_TIME_STEPS/M_BLOCKS_B)
// #define N_BLOCKS_F (NUM_TIME_STEPS/M_BLOCKS_F)
#define FORCE_PARALLEL 1 // 0 for better performance 1 for identical output for comp b/t CPU and GPU

// line search and regularization
#define STATE_REG 1
#define ALPHA_BASE 0.5
#define NUM_ALPHA 16
#define RHO_INIT 12.5
#define RHO_MAX 10000000.0
#define RHO_MIN 0.01
#define RHO_FACTOR 1.25
#define EXP_RED_MIN 0.05 
#define EXP_RED_MAX 1.25
#define MAX_DEFECT_SIZE 1.0
#define MAX_ITER 100
#define MAX_SOLVER_TIME 10000.0

/*****************************************************************
 * INCLUDES
 *****************************************************************/
#include <thread>
#include <pthread.h>
#include <type_traits>
#include <stdio.h>
#include <sys/time.h>
#include <cmath>
#include <cstring>
#include <iostream>
#include <algorithm>
#include <vector>
#include <random>

/*****************************************************************
 * THREADING HELPERS
 *****************************************************************/
#define USE_HYPER_THREADING 0 // assumes pairs are 0,CPU_CORES/2, etc. test with cat /sys/devices/system/cpu/cpu0/topology/thread_siblings_list
#define FORCE_CORE_SWITCHES 0 // set to 1 to force a cycle across the cores (may improve speed b/c we know that tasks are independent and don't share cache in general)
#define CPU_CORES (std::thread::hardware_concurrency())
#if USE_HYPER_THREADING
   #define COST_THREADS (std::max(CPU_CORES,1))
   #define INTEGRATOR_THREADS (std::max(CPU_CORES,1))
   #define BP_THREADS (std::max(std::min(M_BLOCKS_B,CPU_CORES),1))
   #define FSIM_THREADS (std::max(std::min(M_BLOCKS_F,CPU_CORES),1))
   #define FSIM_ALPHA_THREADS (std::max(CPU_CORES/FSIM_THREADS,1))
#else
   #define COST_THREADS (std::max(static_cast<int>(CPU_CORES/2),1))
   #define INTEGRATOR_THREADS (std::max(static_cast<int>(CPU_CORES/2),1))
   #define BP_THREADS (std::max(std::min(M_BLOCKS_B,static_cast<int>(CPU_CORES/2)),1))
   #define FSIM_THREADS (std::max(std::min(M_BLOCKS_F,static_cast<int>(CPU_CORES/2)),1))
   #define FSIM_ALPHA_THREADS (std::max(static_cast<int>(CPU_CORES/(2*FSIM_THREADS)),1))
#endif
#define DYNAMICS_GRAD_THREADS INTEGRATOR_THREADS
#define MAX_CPU_THREADS (std::max(std::max(13,std::max((std::max(FSIM_ALPHA_THREADS,FSIM_THREADS)+1)*COST_THREADS + INTEGRATOR_THREADS + 3, FSIM_ALPHA_THREADS*FSIM_THREADS + 1)),3*NUM_ALPHA+3))

typedef struct _threadDesc_t {
   unsigned int tid;
   unsigned int dim;
   unsigned int reps;
} threadDesc_t;

#define compute_reps(tid,dim,dataN) (dataN/dim + static_cast<unsigned int>(tid < dataN%dim))

void setCPUForThread(std::thread thread[], int thread_id){
	 cpu_set_t cpuset;
    CPU_ZERO(&cpuset);
    int CPU_id = (thread_id % std::thread::hardware_concurrency());
    CPU_SET(CPU_id,&cpuset);
    int rc = pthread_setaffinity_np(thread[thread_id].native_handle(),sizeof(cpu_set_t),&cpuset);
    if (rc != 0) {
      switch(rc){
      	case EINVAL: {printf("REQUESTED CPU[%d] UNAVAILABLE\n",CPU_id); break;}
      	case ESRCH: {printf("REQUESTED THREAD[%d] DOES NOT EXIST\n",thread_id); break;}
      	case EFAULT: {printf("BAD MEMORY ADDRESS FOR CPU SET\n"); break;}
      	default: {printf("UNKNOWN CPU AFFINITY ERROR -- POTENTIALLY PRIVILEDGE ISSUE\n");}
      }
    }
}
#endif


/*****************************************************************
 * CLOCK / TIMING HELPERS
 *****************************************************************/
#define get_time_us_spec(time) (static_cast<double>(time.tv_sec * 100000.0) + static_cast<double>(time.tv_nsec/1000.0))
#define get_time_us(time) (static_cast<double>(time.tv_sec * 1000000.0 + time.tv_usec))
#define get_time_ms(time) (get_time_us(time) / 1000.0)
#define time_delta_us_spec(start,end) (static_cast<double>(get_time_us_spec(end) - get_time_us_spec(start)))
#define time_delta_us(start,end) (static_cast<double>(get_time_us(end) - get_time_us(start)))
#define time_delta_ms(start,end) (time_delta_us(start,end)/1000.0)
#define time_delta_s(start,end) (time_delta_ms(start,end)/1000.0)

// #define TIME_STEP (TOTAL_TIME/(NUM_TIME_STEPS-1))
	
static double diff_in_ns(struct timespec t1, struct timespec t2)
{
  struct timespec diff;
  if (t2.tv_nsec-t1.tv_nsec < 0) {
    diff.tv_sec  = t2.tv_sec - t1.tv_sec - 1;
    diff.tv_nsec = t2.tv_nsec - t1.tv_nsec + 1000000000;
  } else {
    diff.tv_sec  = t2.tv_sec - t1.tv_sec;
    diff.tv_nsec = t2.tv_nsec - t1.tv_nsec;
  }
  return (double) (diff.tv_sec * 1000000000.0 + diff.tv_nsec);
}

template <int KNOT_POINTS>
double get_time_steps_us_d(double start, double end){double step_in_us = TOTAL_TIME_us/static_cast<double>(KNOT_POINTS-1); return (end - start)/step_in_us;}
template <int KNOT_POINTS>
int get_time_steps_us_f(double start, double end){return static_cast<int>(std::floor(get_time_steps_us_d<KNOT_POINTS>(start,end)));}
// #define get_time_steps_us_d(start,end) (static_cast<double>(end - start)/TIME_STEP_us)
// #define get_time_steps_us_f(start,end) (static_cast<int>(std::floor(get_time_steps_us_d(start,end))))

/*****************************************************************
 * HANGOVER FROM PREVIOUS VERSION HELPERS
 *****************************************************************/

#define rcJ_IndCpp(r,c,ld) ((r-1) + (c-1)*ld)
#define krcJ_IndCpp(k,r,c,ld) (rcJ_IndCpp(r,c,ld) + (k-1)*ld*ld)
#define rc_Ind(r,c,ld) (r + c*ld)
#define krc_Ind(k,r,c,ld) (rc_Ind(r,c,ld) + k*ld*ld)

void singleLoopVals(int *start, int *delta){*start = 0; *delta = 1;}
void doubleLoopVals(int *starty, int *dy, int *startx, int *dx){*starty = 0; *dy = 1; *startx = 0; *dx = 1;}

template <int KNOT_POINTS, int N_BLOCKS_F>
bool onDefectBoundary(int k){
  bool flag1 = (k+1) % N_BLOCKS_F == 0;
  bool flag2 = k < KNOT_POINTS - 1;
  return flag1 && flag2;
}
// #define onDefectBoundary(k) ((((k+1) % N_BLOCKS_F) == 0) && (k < NUM_TIME_STEPS - 1))

template <typename T, int M, int N, bool DOUBLE_PRECISION_PRINT = 0>
void printMat(T *A, int lda, int newlnflag = 0){
   #pragma unroll
   for(int i=0; i<M; i++){
      #pragma unroll
         for(int j=0; j<N; j++){
            double val = static_cast<double>(A[i + lda*j]);
            if(DOUBLE_PRECISION_PRINT){printf("%.8f ",val);}
            else{printf("%.4f ",val);}
         }
         printf("\n");
     }
     if (newlnflag){printf("\n");}
}

template <int M, int N>
void printMatInt(int *A, int lda, int newlnflag = 0){
   #pragma unroll
   for(int i=0; i<M; i++){
      #pragma unroll
         for(int j=0; j<N; j++){printf("%d ",A[i + lda*j]);}
         printf("\n");
     }
     if (newlnflag){printf("\n");}
}

/*****************************************************************
 * MATH HELPERS
 *****************************************************************/

// load into shared mem a block of a matrix
template <typename T, int SIZE>
void copyBlockMemShared(T *s_dst, T *d_src){
   int start, delta; singleLoopVals(&start,&delta);
   #pragma unroll
      for (int ind = start; ind < SIZE; ind += delta){s_dst[ind] = d_src[ind];}
}

// copies a matrix (optionally scales by alpha)
template <typename T, int M, int N>
void copyMat(T *dst, T *src, int ld_dst, int ld_src, T alpha = 1.0){
   int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
    #pragma unroll
    for (int ky = starty; ky < N; ky += dy){
      #pragma unroll
      for (int kx = startx; kx < M; kx += dx){
         dst[kx + ld_dst*ky] = alpha*src[kx + ld_src*ky];
        }
   }
}

template <typename T, int M, int N, int LOWER = 0>
void copyMatSym(T *dst, T *src, int ld_dst, int ld_src, T alpha = 1.0){
   int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
    #pragma unroll
    for (int ky = starty; ky < N; ky += dy){
      #pragma unroll
      for (int kx = startx; kx < M; kx += dx){ T val;
         if (LOWER){int ind = kx < ky ? kx * ld_src + ky : kx + ld_src * ky; val = src[ind];}
         else{      int ind = kx > ky ? kx * ld_src + ky : kx + ld_src * ky; val = src[ind];}
         dst[kx + ld_dst*ky] = alpha*val;
        }
   }
}

// zero a piece of shared memory of size LENGTH*sizeof(T)
template <typename T, int LENGTH>
void zeroSharedMem(T *smem){
   int start, delta; singleLoopVals(&start,&delta);
   #pragma unroll
    for (int ind = start; ind < LENGTH; ind += delta){
      smem[ind] = 0;
    }
}

// loads a matrix into shared memory
// special case of copyMat, assumes shared memory is of size m*n and original matrix is on disk size ld*n
template <typename T, int M, int N>
void loadMatToShared(T *dst, T *src, int ld){
   copyMat<T,M,N>(dst, src, M, ld);
}
// save a matrix from shared mem
// special case of copyMat, assumes shared memory is of size m*n and original matrix is on disk size ld*n
template <typename T, int M, int N>
void saveMatFromShared(T *dst, T *src, int ld){
   copyMat<T,M,N>(dst, src, ld, M);
}

// save a matrix from shared mem
// special case of copyMatT, assumes shared memory is of size m*n and original matrix is on disk size ld*n -- skips the temp step
template <typename T, int M, int N>
void saveMatFromSharedT(T *dst, T *src, int ld){
   int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
   #pragma unroll
    for (int ky = starty; ky < N; ky += dy){
      #pragma unroll
      for (int kx = startx; kx < M; kx += dx){
         dst[kx + ld*ky] = src[ky + N*kx];
        }
   }
}

// loads and regularizes a matrix
template <typename T, int M, int N>
void loadAndReg(T *dst, T *src, int ld_dst, int ld_src, T reg){
   int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
    #pragma unroll
    for (int ky = starty; ky < N; ky += dy){
      #pragma unroll
      for (int kx = startx; kx < M; kx += dx){
         dst[kx + ld_dst*ky] = src[kx + ld_src*ky] + (kx == ky ? reg : static_cast<T>(0));
        }
   }
}
// loads a and regularizes a matrix into shared memory
// special case of copyMat, assumes shared memory is of size m*n and original matrix is on disk size ld*n
template <typename T, int M, int N>
void loadAndRegToShared(T *dst, T *src, int ld, T reg){
   loadAndReg<T,M,N>(dst, src, N, ld, reg);
}

// loads the identiy matrix into a variable
template <typename T, int M, int N>
void loadIdentity(T *A, int ld_A){
   int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
   #pragma unroll
   for (int ky = starty; ky < N; ky += dy){
      #pragma unroll
      for (int kx = startx; kx < M; kx += dx){
         A[ky*ld_A + kx] = static_cast<T>(kx == ky ? 1 : 0);
      }
   }
}

// add two vectors c (+)= alpha*(a + b)
template <typename T, int M, int PEQFLAG = 0>
void vecAdd(T *c, T *a, T *b, T alpha = 1.0){
   int start, delta; singleLoopVals(&start,&delta);
   #pragma unroll
    for (int ind = start; ind < M; ind += delta){
      T val = alpha*(a[ind] + b[ind]);
      if (PEQFLAG){c[ind] += val;}
      else{c[ind] = val;}
   }
}

// add two vectors b += alpha*a
template <typename T, int M>
void vecAdd(T *b, T *a, T alpha = 1.0){
   int start, delta; singleLoopVals(&start,&delta);
   #pragma unroll
    for (int ind = start; ind < M; ind += delta){
      b[ind] += alpha*a[ind];
   }
}

template <typename T, int M>
void loadDeltaV(T *dst, T *src1, T *src2){
   int start, delta; singleLoopVals(&start,&delta);
    #pragma unroll
    for (int ind = start; ind < M; ind += delta){
      dst[ind] = src1[ind] - src2[ind];
   }
}

// dot product between two vectors with values spaced s_a, s_a
template <typename T, int K>
T dotProd(T *a, int s_a, T *b, int s_b){
   T val = 0;
   #pragma unroll
   for (int j=0; j < K; j++){val += a[s_a * j] * b[s_b * j];}
   return val;
}

// for multiplying matrix row ky of A by col kx of B
// s_a = ld_A and s_b = 1 and pass in &A[ky] and &B[kx*ld_B]
// then we get A[ky + ld_A * j] * B[kx * ld_B + j]
// to transpose B pass in $B[kx] and s_b = ld_B
// to transpose A pass in $A[ky*ld_A] and s_a = 1
template <typename T, int K, int T_A = 0, int T_B = 0>
T dotProdMM(T *A, int ld_A, T *B, int ld_B, int kx, int ky){
   int ind_A = T_A ? ky * ld_A   : ky;
   int s_A   = T_A ? 1     : ld_A;
   int ind_B = T_B ? kx       : kx * ld_B;
   int s_B   = T_A ? ld_B     : 1;
   return dotProd<T,K>(&A[ind_A],s_A,&B[ind_B],s_B);
}

// for multiplying matrix row ind of A by col vector b
// s_a = ld_A and s_b = 1 and pass in &A[ind] and b
// then we get A[ind + ld_A * j] * b[j]
// if transposed then we need to get col ind of A so
// then we need &A[ind*ld_A] and s_a = 1 and s_b = 1
// then we get A[ind * ld_A + j] * b[j]
template <typename T, int K, int T_A = 0>
T dotProdMv(T *A, int ld_A, T *b, int ind){
   if(T_A){return dotProd<T,K>(&A[ind*ld_A],1,b,1);}
   else{return dotProd<T,K>(&A[ind],ld_A,b,1);}
}

// We need to multiply rc of A by b
// but values on exisit in LOWER or UPPER
// thinking in rows then j is column
// therefore in LOWER we need rc <= j
// and in UPPER we need rc >=j else flip
template <typename T, int K, int LOWER = 0>
T dotProdMvSym(T *A, int ld_A, T *b, int row){
   T val = 0;
   #pragma unroll
   for (int j=0; j < K; j++){
      if (LOWER){
         int ind = row < j ? row * ld_A + j : row + ld_A * j;
         val += A[ind] * b[j];
      }
      else{
         int ind = row > j ? row * ld_A + j : row + ld_A * j;
         val += A[ind] * b[j];
      }
   }
   return val;
}

// basic matrix multiply D (+)= alpha*A*B (+ beta*C) with option to produce transposed output
template <typename T, int M, int N, int K, int PEQFLAG = 0, int T_D = 0, int T_A = 0, int T_B = 0, int T_C = 0>
void matMult(T *D, int ld_D, T *A, int ld_A, T *B, int ld_B, T alpha = 1.0, T *C = nullptr, int ld_C = 0, T beta = 1.0){
   int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
   #pragma unroll
    for (int ky = starty; ky < N; ky += dy){
      #pragma unroll
      for (int kx = startx; kx < M; kx += dx){
         T val = alpha*dotProdMM<T,K,T_A,T_B>(A,ld_A,B,ld_B,kx,ky);
         if (C != nullptr){
            int ind_C = T_C ? ky + ld_C*kx : kx + ld_C*ky;
            val +=   beta*C[ind_C];
         }
         int ind_D = T_D ? ky + ld_D*kx : kx + ld_D*ky;
         if (PEQFLAG){D[ind_D] += val;}
         else{D[ind_D] = val;}
        }
   }
}

// basic matrix vector multiply d (+)= alpha*A*b (+ beta*c)
template <typename T, int M, int K, int PEQFLAG = 0, int T_A = 0>
void matVMult(T *d, T *A, int ld_A, T *b, T alpha = 1.0, T *c = nullptr, T beta = 1.0){
   int start, delta; singleLoopVals(&start, &delta);
    #pragma unroll
    for (int ind = start; ind < M; ind += delta){
      T val = alpha*dotProdMv<T,K,T_A>(A, ld_A, b, ind) + (c != nullptr ? beta*c[ind] : static_cast<T>(0));
      if (PEQFLAG){d[ind] += val;}
      else{d[ind] = val;}
   }
}

// iterated matVMult for D[:,col_i] += alpha*A*B[:,col_i] (+ c) for all i in some set
// assumes D and B are pointers to col_0 and then we just need the next N cols
template <typename T, int M, int K, int PEQFLAG = 0, int T_A = 0>
void iteratedMatVMult(T *D, int ld_D, T *A, int ld_A, T *B, int ld_B, int col_N, T alpha = 1.0, T *c = nullptr, T beta = 1.0){
   int startx, dx, starty, dy; doubleLoopVals(&startx, &dx, &starty, &dy);
   for (int col = starty; col < col_N; col += dy){
      T *Dc = &D[col*ld_D]; T *Bc = &B[col*ld_B];
      #pragma unroll
         for (int row = startx; row < M; row += dx){
         T val = alpha*dotProdMv<T,K,T_A>(A, ld_A, Bc, row) + (c != nullptr ? beta*c[row] : static_cast<T>(0));
         if (PEQFLAG){Dc[row] += val;}
         else{Dc[row] = val;}
      }
   }
}

// basic matrix vector multiply D (+)= alpha*A*B (+ beta*C) but A is a symmetric matrix with only the triangle stored (default UPPER)
template <typename T, int M, int N, int K, int PEQFLAG = 0, int LOWER = 0, int T_C = 0, int T_D = 0>
void matMultSym(T *D, int ld_D, T *A, int ld_A, T *B, int ld_B, T alpha = 1.0, T *C = nullptr, int ld_C = 0, T beta = 1.0){
   int startx, dx, starty, dy; doubleLoopVals(&startx, &dx, &starty, &dy);
    #pragma unroll
   for (int ky = starty; ky < N; ky += dy){
      #pragma unroll
      for (int kx = startx; kx < M; kx += dx){
         T val = alpha*dotProdMvSym<T,K,LOWER>(A,ld_A,&B[ky*ld_B],kx);
         if (C != nullptr){
            int ind_C = T_C ? ky + ld_C*kx : kx + ld_C*ky;
            val +=   beta*C[ind_C];
         }
         int ind_D = T_D ? ky + ld_D*kx : kx + ld_D*ky;
         if (PEQFLAG){D[ind_D] += val;}
         else{D[ind_D] = val;}
      }
   }
}

// basic matrix vector multiply d (+)= alpha*A*b (+ c) but A is a symmetric matrix with only the triangle stored (default UPPER)
template <typename T, int M, int K, int PEQFLAG = 0, int LOWER = 0>
void matVMultSym(T *d, T *A, int ld_A, T *b, T alpha = 1.0, T *c = nullptr, T beta = 1.0){
   int start, delta; singleLoopVals(&start, &delta);
    #pragma unroll
    for (int ind = start; ind < M; ind += delta){
      T val = alpha*dotProdMvSym<T,K,LOWER>(A, ld_A, b, ind) + (c != nullptr ? beta*c[ind] : static_cast<T>(0));
      if (PEQFLAG){d[ind] += val;}
      else{d[ind] = val;}
   }
}

// invert a [DIMxDIM|I] square matrix with I already loaded assumes threads >= DIM+1 x DIM
template <typename T, int DIM>
int invertMatrix(T *A, T *s_mem = NULL){
   if (s_mem == NULL){T temp[2*DIM+1]; s_mem = temp;} // make sure to get some local mem if not passed in
   T *C = s_mem; T *sRow = &s_mem[DIM];
   int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
   #pragma unroll
   for (int piv_col = 0; piv_col < DIM; piv_col++){
      T inv_pivot = static_cast<T>(1)/A[piv_col + piv_col*DIM];
      // load in values
      #pragma unroll
      for (int kr = starty; kr < DIM; kr += dy){C[kr] = A[kr + piv_col*DIM];}
      #pragma unroll
      for (int kc = startx; kc < DIM + 1; kc += dx){sRow[kc] = A[piv_col + (piv_col + kc)*DIM];}
      // compute
      #pragma unroll
      for (int kr = starty; kr < DIM; kr += dy){
            #pragma unroll
            for (int kc = startx; kc < DIM + 1; kc += dx){
               if (kr == piv_col){A[kr + (kc+piv_col)*DIM] *= inv_pivot;}
               else {A[kr + (kc+piv_col)*DIM] -= C[kr]*inv_pivot*sRow[kc];}
            }
      }
   }
   return 0;
}

template <typename T>
int fillRandom(T * A, int num_elements, T start, T end, uint32_t seed=0) {
    std::random_device rd;
    uint32_t final_seed;
    if (seed == 0) {
        final_seed = rd();
    }
    else {
        final_seed = seed;
    }

    std::mt19937 gen(final_seed);
    std::uniform_real_distribution<> dis(start, end);

    for (int i = 0; i < num_elements; i++) {
        A[i] = dis(gen);
    }

    return 0;
}

/*****************************************************************
 * MAXTRIC DIMMENSIONS
 *****************************************************************/
#define DIM_x_r STATE_SIZE
#define DIM_x_c 1
#define DIM_u_r CONTROL_SIZE
#define DIM_u_c 1
#define DIM_d_r STATE_SIZE
#define DIM_d_c 1
#define DIM_AB_r STATE_SIZE
#define DIM_AB_c (STATE_SIZE + CONTROL_SIZE)
#define DIM_ABT_r (STATE_SIZE + CONTROL_SIZE)
#define DIM_ABT_c STATE_SIZE
#define DIM_A_r STATE_SIZE
#define DIM_A_c STATE_SIZE
#define DIM_B_r STATE_SIZE
#define DIM_B_c CONTROL_SIZE
#define DIM_H_r (STATE_SIZE + CONTROL_SIZE)
#define DIM_H_c (STATE_SIZE + CONTROL_SIZE)
#define DIM_Hxx_r STATE_SIZE
#define DIM_Hxx_c STATE_SIZE
#define DIM_Hux_r CONTROL_SIZE
#define DIM_Hux_c STATE_SIZE
#define DIM_Hxu_r STATE_SIZE
#define DIM_Hxu_c CONTROL_SIZE
#define DIM_Huu_r CONTROL_SIZE
#define DIM_Huu_c CONTROL_SIZE
#define DIM_g_r (STATE_SIZE + CONTROL_SIZE)
#define DIM_g_c 1
#define DIM_gx_r STATE_SIZE
#define DIM_gx_c 1
#define DIM_gu_r CONTROL_SIZE
#define DIM_gu_c 1
#define DIM_P_r STATE_SIZE
#define DIM_P_c STATE_SIZE
#define DIM_p_r STATE_SIZE
#define DIM_p_c 1
#define DIM_K_r CONTROL_SIZE
#define DIM_K_c STATE_SIZE
#define DIM_KT_r DIM_K_c
#define DIM_KT_c DIM_K_r
#define DIM_du_r CONTROL_SIZE
#define DIM_du_c 1
#define OFFSET_HXU (DIM_x_r*(DIM_x_r+DIM_u_r))
#define OFFSET_HUU (OFFSET_HXU + DIM_x_r)
#define OFFSET_HUX_GU DIM_x_r
#define OFFSET_B (DIM_AB_r*DIM_x_r)
