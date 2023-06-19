#include <assert.h>
#include <cuda_runtime.h>
#define NUM_STREAMS 6

__device__ __forceinline__
void singleLoopVals_GPU(int *start, int *delta){*start = threadIdx.x + threadIdx.y*blockDim.x; *delta = blockDim.x*blockDim.y;}
__device__ __forceinline__
void doubleLoopVals_GPU(int *starty, int *dy, int *startx, int *dx){*starty = threadIdx.y; *dy = blockDim.y; *startx = threadIdx.x; *dx = blockDim.x;}

#include <type_traits>
template <typename T, int M, int N, bool DOUBLE_PRECISION_PRINT = 0>
__device__
void printMat_GPU(T *A, int lda, int newlnflag = 0){
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

// dot product between two vectors with values spaced s_a, s_a
template <typename T, int K>
__device__
T dotProd_GPU(T *a, int s_a, T *b, int s_b){
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
__device__
T dotProdMM_GPU(T *A, int ld_A, T *B, int ld_B, int kx, int ky){
   int ind_A = T_A ? ky * ld_A   : ky;
   int s_A   = T_A ? 1     : ld_A;
   int ind_B = T_B ? kx       : kx * ld_B;
   int s_B   = T_A ? ld_B     : 1;
   return dotProd_GPU<T,K>(&A[ind_A],s_A,&B[ind_B],s_B);
}

// for multiplying matrix row ind of A by col vector b
// s_a = ld_A and s_b = 1 and pass in &A[ind] and b
// then we get A[ind + ld_A * j] * b[j]
// if transposed then we need to get col ind of A so
// then we need &A[ind*ld_A] and s_a = 1 and s_b = 1
// then we get A[ind * ld_A + j] * b[j]
template <typename T, int K, int T_A = 0>
__device__
T dotProdMv_GPU(T *A, int ld_A, T *b, int ind){
   if(T_A){return dotProd_GPU<T,K>(&A[ind*ld_A],1,b,1);}
   else{return dotProd_GPU<T,K>(&A[ind],ld_A,b,1);}
}

// We need to multiply rc of A by b
// but values on exisit in LOWER or UPPER
// thinking in rows then j is column
// therefore in LOWER we need rc <= j
// and in UPPER we need rc >=j else flip
template <typename T, int K, int LOWER = 0>
__device__
T dotProdMvSym_GPU(T *A, int ld_A, T *b, int row){
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

// basic matrix vector multiply d (+)= alpha*A*b (+ beta*c)
template <typename T, int M, int K, int PEQFLAG = 0, int T_A = 0>
__device__
void matVMult_GPU(T *d, T *A, int ld_A, T *b, T alpha = 1.0, T *c = nullptr, T beta = 1.0){
   int start, delta; singleLoopVals_GPU(&start, &delta);
    #pragma unroll
    for (int ind = start; ind < M; ind += delta){
      T val = alpha*dotProdMv_GPU<T,K,T_A>(A, ld_A, b, ind) + (c != nullptr ? beta*c[ind] : static_cast<T>(0));
      if (PEQFLAG){d[ind] += val;}
      else{d[ind] = val;}
   }
}

// iterated matVMult for D[:,col_i] += alpha*A*B[:,col_i] (+ c) for all i in some set
// assumes D and B are pointers to col_0 and then we just need the next N cols
template <typename T, int M, int K, int PEQFLAG = 0, int T_A = 0>
__device__
void iteratedMatVMult_GPU(T *D, int ld_D, T *A, int ld_A, T *B, int ld_B, int col_N, T alpha = 1.0, T *c = nullptr, T beta = 1.0){
   int startx, dx, starty, dy; doubleLoopVals_GPU(&startx, &dx, &starty, &dy);
   for (int col = starty; col < col_N; col += dy){
      T *Dc = &D[col*ld_D]; T *Bc = &B[col*ld_B];
      #pragma unroll
         for (int row = startx; row < M; row += dx){
         T val = alpha*dotProdMv_GPU<T,K,T_A>(A, ld_A, Bc, row) + (c != nullptr ? beta*c[row] : static_cast<T>(0));
         if (PEQFLAG){Dc[row] += val;}
         else{Dc[row] = val;}
      }
   }
}

// basic matrix vector multiply D (+)= alpha*A*B (+ beta*C) but A is a symmetric matrix with only the triangle stored (default UPPER)
template <typename T, int M, int N, int K, int PEQFLAG = 0, int LOWER = 0, int T_C = 0, int T_D = 0>
__device__
void matMultSym_GPU(T *D, int ld_D, T *A, int ld_A, T *B, int ld_B, T alpha = 1.0, T *C = nullptr, int ld_C = 0, T beta = 1.0){
   int startx, dx, starty, dy; doubleLoopVals_GPU(&startx, &dx, &starty, &dy);
   #pragma unroll
   for (int ky = starty; ky < N; ky += dy){
      #pragma unroll
      for (int kx = startx; kx < M; kx += dx){
         T val = alpha*dotProdMvSym_GPU<T,K,LOWER>(A,ld_A,&B[ky*ld_B],kx);
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

template <typename T, int M, int N, int LOWER = 0>
__device__
void copyMatSym_GPU(T *dst, T *src, int ld_dst, int ld_src, T alpha = 1.0){
   int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
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


__host__ 
void gpuAssert(cudaError_t code, const char *file, const int line, bool abort=true){
   if (code != cudaSuccess){
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort){cudaDeviceReset(); exit(code);}
   }
}
#define gpuErrchk(err) {gpuAssert(err, __FILE__, __LINE__);}

__device__ __forceinline__
int __doOnce(){
	if(threadIdx.x == 0 && threadIdx.y == 0){return 1;}
	else{return 0;}

}

template <typename T, int M, int N, int K, int PEQFLAG = 0, int T_D = 0, int T_A = 0, int T_B = 0, int T_C = 0>
__device__ __forceinline__
void matMult_xthreads(int startx, int dx, T *D, int ld_D, T *A, int ld_A, T *B, int ld_B, T alpha = 1.0, T *C = nullptr, int ld_C = 0, T beta = 1.0){
	#pragma unroll
    for (int k = startx; k < M*N; k += dx){
    	int ky = k / M; int kx = k % M;
    	T val = alpha*dotProdMM_GPU<T,K,T_A,T_B>(A,ld_A,B,ld_B,kx,ky);
    	if (C != nullptr){
    		int ind_C = T_C ? ky + ld_C*kx : kx + ld_C*ky;
    		val += 	beta*C[ind_C];
    	}
    	int ind_D = T_D ? ky + ld_D*kx : kx + ld_D*ky;
    	if (PEQFLAG){D[ind_D] += val;}
		else{D[ind_D] = val;}
	}
}

template <typename T, int M, int K, int PEQFLAG = 0, int T_A = 0>
__device__ __forceinline__
void matVMult_xthreads(int startx, int dx, T *d, T *A, int ld_A, T *b, T alpha = 1.0, T *c = nullptr, T beta = 1.0){
    #pragma unroll
    for (int ind = startx; ind < M; ind += dx){
		T val = alpha*dotProdMv_GPU<T,K,T_A>(A, ld_A, b, ind) + (c != nullptr ? beta*c[ind] : static_cast<T>(0));
		if (PEQFLAG){d[ind] += val;}
		else{d[ind] = val;}
	}
}

__device__ __forceinline__
int Mx3ind_GPU(int r){return r == 0 ? 1 : (r == 1 ? 0 : (r == 3 ? 4 : 3));} // note this is src r: [v(1), -v(0), 0, v(4), -v(3), 0]^T

template <typename T>
__device__ __forceinline__
T Mx3mul_GPU(int r){return (r == 0 || r == 3) ? static_cast<T>(1) : ((r == 1 || r == 4) ? static_cast<T>(-1) : static_cast<T>(0));}

template <typename T>
__device__ 
void loadMx3_GPU(T *dst, T *src, int r, T alpha = 1){
	int Mxr = Mx3ind_GPU(r); T sgn = Mx3mul_GPU<T>(r);
	dst[r] = sgn*alpha*src[Mxr];
}

__device__
int Fxind_GPU(int r, int c){ // note this is src r
	if (c == 0){return r == 1 ? 2 : 1;}
	else if (c == 1){return r == 0 ? 2 : 0;}
	else if (c == 2){return r == 0 ? 1 : 0;}
	else if (c == 3){return r == 1 ? 5 : (r == 2 ? 4 : (r == 4 ? 2 : 1));}
	else if (c == 4){return r == 0 ? 5 : (r == 2 ? 3 : (r == 3 ? 2 : 0));}
	else {return r == 0 ? 4 : (r == 1 ? 3 : (r == 3 ? 1 : 0));}
}

template <typename T>
__device__
T Fxmul_GPU(int r, int c){
	/* 0   v(2) -v(1)    0   v(5) -v(4)
	-v(2)    0   v(0) -v(5)    0   v(3)
	v(1) -v(0)    0   v(4) -v(3)    0
	  0     0     0     0   v(2) -v(1)
	  0     0     0  -v(2)    0   v(0)
	  0     0     0   v(1) -v(0)    0 */
	int flag = 0;
	if (c == 0){if(r == 1){flag = -1;} else if (r == 2){flag = 1;}}
	else if (c == 1){if(r == 2){flag = -1;} else if (r == 0){flag = 1;}}
	else if (c == 2){if(r == 0){flag = -1;} else if (r == 1){flag = 1;}}
	else if (c == 3){if(r == 1 || r == 4){flag = -1;} else if (r == 2 || r == 5){flag = 1;}}
	else if (c == 4){if(r == 2 || r == 5){flag = -1;} else if (r == 0 || r == 3){flag = 1;}}
	else if (c == 5){if(r == 0 || r == 3){flag = -1;} else if (r == 1 || r == 4){flag = 1;}}
	return static_cast<T>(-1*flag);
}

template <typename T>
__device__
void serialFx_GPU(T *Fxmat, T *vec){
   /* 0   v(2) -v(1)    0   v(5) -v(4)
   -v(2)    0   v(0) -v(5)    0   v(3)
   v(1) -v(0)    0   v(4) -v(3)    0
     0     0     0     0   v(2) -v(1)
     0     0     0  -v(2)    0   v(0)
     0     0     0   v(1) -v(0)    0 */
   Fxmat[0] = static_cast<T>(0);
   Fxmat[1] = -vec[2];
   Fxmat[2] = -vec[1];
   Fxmat[3] = static_cast<T>(0);
   Fxmat[4] = static_cast<T>(0);
   Fxmat[5] = static_cast<T>(0);
   Fxmat[6] = vec[2];
   Fxmat[7] = static_cast<T>(0);
   Fxmat[8] = -vec[0];
   Fxmat[9] = static_cast<T>(0);
   Fxmat[10] = static_cast<T>(0);
   Fxmat[11] = static_cast<T>(0);
   Fxmat[12] = -vec[1];
   Fxmat[13] = vec[0];
   Fxmat[14] = static_cast<T>(0);
   Fxmat[15] = static_cast<T>(0);
   Fxmat[16] = static_cast<T>(0);
   Fxmat[17] = static_cast<T>(0);
   Fxmat[18] = static_cast<T>(0);
   Fxmat[19] = -vec[5];
   Fxmat[20] = vec[4];
   Fxmat[21] = static_cast<T>(0);
   Fxmat[22] = -vec[2];
   Fxmat[23] = vec[1];
   Fxmat[24] = vec[5];
   Fxmat[25] = static_cast<T>(0);
   Fxmat[26] = -vec[3];
   Fxmat[27] = vec[2];
   Fxmat[28] = static_cast<T>(0);
   Fxmat[29] = -vec[0];
   Fxmat[30] = -vec[4];
   Fxmat[31] = vec[3];
   Fxmat[32] = static_cast<T>(0);
   Fxmat[33] = -vec[1];
   Fxmat[34] = vec[0];
   Fxmat[35] = static_cast<T>(0);
}

template <typename T>
__device__
void loadFx_GPU(T *dst, T *src, int r, int c){
	int Fxr = Fxind_GPU(r,c); T sgn = Fxmul_GPU<T>(r,c);
	dst[r] = sgn*src[Fxr];
}

template <typename T>
__device__
void loadFx2_GPU(T *dst1, T *src1, T *dst2, T *src2, int r, int c){
	int Fxr = Fxind_GPU(r,c); T sgn = Fxmul_GPU<T>(r,c);
	dst1[r] = sgn*src1[Fxr]; dst2[r] = sgn*src2[Fxr];
}

template <typename T>
__device__
void updateTransforms_GPU(T *s_T, T *s_sinq, T *s_cosq){
   if(__doOnce()){
      // Per-Robot Translation Constants
      T tz_j1 = static_cast<T>(0.1574999988079071);
      T tz_j2 = static_cast<T>(0.20250000059604645);
      T ty_j3 = static_cast<T>(0.2045000046491623);
      #if USE_JULIA_URDF
         T tz_j3 = static_cast<T>(-9.999999960041972E-13);
      #endif
      T tz_j4 = static_cast<T>(0.21549999713897705);
      T ty_j5 = static_cast<T>(0.18449999392032623);
      #if USE_JULIA_URDF
         T tz_j5 = static_cast<T>(-9.999999960041972E-13);
         T ty_j6 = static_cast<T>(-1.9999999920083944E-12);
      #endif
      T tz_j6 = static_cast<T>(0.21549999713897705);
      T ty_j7 = static_cast<T>(0.08100000023841858);
      // -- Link 1 <-- World 0
      s_T[krcJ_IndCpp(1,1,1,6)] = s_cosq[0];
      s_T[krcJ_IndCpp(1,1,2,6)] = s_sinq[0];
      s_T[krcJ_IndCpp(1,2,1,6)] = -s_sinq[0];
      s_T[krcJ_IndCpp(1,2,2,6)] = s_cosq[0];
      s_T[krcJ_IndCpp(1,4,1,6)] = -tz_j1 * s_sinq[0];
      s_T[krcJ_IndCpp(1,4,2,6)] =  tz_j1 * s_cosq[0];
      s_T[krcJ_IndCpp(1,4,4,6)] = s_cosq[0];
      s_T[krcJ_IndCpp(1,4,5,6)] = s_sinq[0];
      s_T[krcJ_IndCpp(1,5,1,6)] = -tz_j1 * s_cosq[0];
      s_T[krcJ_IndCpp(1,5,2,6)] = -tz_j1 * s_sinq[0];
      s_T[krcJ_IndCpp(1,5,4,6)] = -s_sinq[0];
      s_T[krcJ_IndCpp(1,5,5,6)] = s_cosq[0];
      // -- Link 2 <-- Link 1
      s_T[krcJ_IndCpp(2,1,1,6)] = -s_cosq[1];
      s_T[krcJ_IndCpp(2,1,3,6)] = s_sinq[1];
      s_T[krcJ_IndCpp(2,2,1,6)] = s_sinq[1];;
      s_T[krcJ_IndCpp(2,2,3,6)] = s_cosq[1];
      s_T[krcJ_IndCpp(2,4,2,6)] = -tz_j2 * s_cosq[1];
      s_T[krcJ_IndCpp(2,4,4,6)] = -s_cosq[1];
      s_T[krcJ_IndCpp(2,4,6,6)] = s_sinq[1];
      s_T[krcJ_IndCpp(2,5,2,6)] =  tz_j2 * s_sinq[1];
      s_T[krcJ_IndCpp(2,5,4,6)] = s_sinq[1];
      s_T[krcJ_IndCpp(2,5,6,6)] = s_cosq[1];
      // -- Link 3 <-- Link 2
      s_T[krcJ_IndCpp(3,1,1,6)] = -s_cosq[2];
      s_T[krcJ_IndCpp(3,1,3,6)] = s_sinq[2];
      s_T[krcJ_IndCpp(3,2,1,6)] = s_sinq[2];
      s_T[krcJ_IndCpp(3,2,3,6)] = s_cosq[2];
      s_T[krcJ_IndCpp(3,4,1,6)] =  ty_j3 * s_sinq[2];
      #if USE_JULIA_URDF
         s_T[krcJ_IndCpp(3,4,2,6)] = -tz_j3 * s_cosq[2];
      #endif
      s_T[krcJ_IndCpp(3,4,3,6)] =  ty_j3 * s_cosq[2];
      s_T[krcJ_IndCpp(3,4,4,6)] = -s_cosq[2];
      s_T[krcJ_IndCpp(3,4,6,6)] = s_sinq[2];
      s_T[krcJ_IndCpp(3,5,1,6)] =  ty_j3 * s_cosq[2];
      #if USE_JULIA_URDF
         s_T[krcJ_IndCpp(3,5,2,6)] =  tz_j3 * s_sinq[2];
      #endif
      s_T[krcJ_IndCpp(3,5,3,6)] = -ty_j3 * s_sinq[2];
      s_T[krcJ_IndCpp(3,5,4,6)] = s_sinq[2];
      s_T[krcJ_IndCpp(3,5,6,6)] = s_cosq[2];
      // -- Link 4 <-- Link 3
      s_T[krcJ_IndCpp(4,1,1,6)] = s_cosq[3];
      s_T[krcJ_IndCpp(4,1,3,6)] = s_sinq[3];
      s_T[krcJ_IndCpp(4,2,1,6)] = -s_sinq[3];
      s_T[krcJ_IndCpp(4,2,3,6)] = s_cosq[3];
      s_T[krcJ_IndCpp(4,4,2,6)] =  tz_j4 * s_cosq[3];
      s_T[krcJ_IndCpp(4,4,4,6)] = s_cosq[3];
      s_T[krcJ_IndCpp(4,4,6,6)] = s_sinq[3];
      s_T[krcJ_IndCpp(4,5,2,6)] = -tz_j4 * s_sinq[3];
      s_T[krcJ_IndCpp(4,5,4,6)] = -s_sinq[3];
      s_T[krcJ_IndCpp(4,5,6,6)] = s_cosq[3];
      // -- Link 5 <-- Link 4
      s_T[krcJ_IndCpp(5,1,1,6)] = -s_cosq[4];
      s_T[krcJ_IndCpp(5,1,3,6)] = s_sinq[4];
      s_T[krcJ_IndCpp(5,2,1,6)] = s_sinq[4];
      s_T[krcJ_IndCpp(5,2,3,6)] = s_cosq[4];
      s_T[krcJ_IndCpp(5,4,1,6)] =  ty_j5 * s_sinq[4];
      #if USE_JULIA_URDF
         s_T[krcJ_IndCpp(5,4,2,6)] = -tz_j5 * s_cosq[4];
      #endif
      s_T[krcJ_IndCpp(5,4,3,6)] =  ty_j5 * s_cosq[4];
      s_T[krcJ_IndCpp(5,4,4,6)] = -s_cosq[4];
      s_T[krcJ_IndCpp(5,4,6,6)] = s_sinq[4];
      s_T[krcJ_IndCpp(5,5,1,6)] =  ty_j5 * s_cosq[4];
      #if USE_JULIA_URDF
         s_T[krcJ_IndCpp(5,5,2,6)] =  tz_j5 * s_sinq[4];
      #endif
      s_T[krcJ_IndCpp(5,5,3,6)] = -ty_j5 * s_sinq[4];
      s_T[krcJ_IndCpp(5,5,4,6)] = s_sinq[4];
      s_T[krcJ_IndCpp(5,5,6,6)] = s_cosq[4];
      // -- Link 6 <-- Link 5
      s_T[krcJ_IndCpp(6,1,1,6)] = s_cosq[5];
      s_T[krcJ_IndCpp(6,1,3,6)] = s_sinq[5];
      s_T[krcJ_IndCpp(6,2,1,6)] = -s_sinq[5];
      s_T[krcJ_IndCpp(6,2,3,6)] = s_cosq[5];
      #if USE_JULIA_URDF
         s_T[krcJ_IndCpp(6,4,1,6)] =  ty_j6 * s_sinq[5];
      #endif
      s_T[krcJ_IndCpp(6,4,2,6)] =  tz_j6 * s_cosq[5];
      #if USE_JULIA_URDF
         s_T[krcJ_IndCpp(6,4,3,6)] = -ty_j6 * s_cosq[5];
      #endif
      s_T[krcJ_IndCpp(6,4,4,6)] = s_cosq[5];
      s_T[krcJ_IndCpp(6,4,6,6)] = s_sinq[5];
      #if USE_JULIA_URDF
         s_T[krcJ_IndCpp(6,5,1,6)] =  ty_j6 * s_cosq[5];
      #endif
      s_T[krcJ_IndCpp(6,5,2,6)] = -tz_j6 * s_sinq[5];
      #if USE_JULIA_URDF
         s_T[krcJ_IndCpp(6,5,3,6)] =  ty_j6 * s_sinq[5];
      #endif
      s_T[krcJ_IndCpp(6,5,4,6)] = -s_sinq[5];
      s_T[krcJ_IndCpp(6,5,6,6)] = s_cosq[5];
      // -- Link 7 <-- Link 6
      s_T[krcJ_IndCpp(7,1,1,6)] = -s_cosq[6];
      s_T[krcJ_IndCpp(7,1,3,6)] = s_sinq[6];
      s_T[krcJ_IndCpp(7,2,1,6)] = s_sinq[6];
      s_T[krcJ_IndCpp(7,2,3,6)] = s_cosq[6];
      s_T[krcJ_IndCpp(7,4,1,6)] =  ty_j7 * s_sinq[6];
      s_T[krcJ_IndCpp(7,4,3,6)] =  ty_j7 * s_cosq[6];
      s_T[krcJ_IndCpp(7,4,4,6)] = -s_cosq[6];
      s_T[krcJ_IndCpp(7,4,6,6)] = s_sinq[6];
      s_T[krcJ_IndCpp(7,5,1,6)] =  ty_j7 * s_cosq[6];
      s_T[krcJ_IndCpp(7,5,3,6)] = -ty_j7 * s_sinq[6];
      s_T[krcJ_IndCpp(7,5,4,6)] = s_sinq[6];
      s_T[krcJ_IndCpp(7,5,6,6)] = s_cosq[6];
   }
}

template <typename T, int MAT_DIM = 16>
__device__ 
void updateT4_GPU(T *s_T, T *s_cosx, T *s_sinx){
	if(__doOnce()){
		s_T[0]           = s_cosx[0];
		s_T[1]           = s_sinx[0];
		s_T[4]           = -s_sinx[0];
		s_T[5]           = s_cosx[0];
		s_T[MAT_DIM]     = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_sinx[1] - s_cosx[1];
		s_T[MAT_DIM+1]   = static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosx[1] + static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinx[1];
		s_T[MAT_DIM+2]   = s_sinx[1];
		s_T[MAT_DIM+4]   = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_cosx[1] + s_sinx[1];
		s_T[MAT_DIM+5]   = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_cosx[1] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinx[1];
		s_T[MAT_DIM+6]   = s_cosx[1];
		s_T[2*MAT_DIM]   = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_sinx[2] - 1.0*s_cosx[2];
		s_T[2*MAT_DIM+1] = static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosx[2] + static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinx[2];
		s_T[2*MAT_DIM+2] = s_sinx[2];
		s_T[2*MAT_DIM+4] = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_cosx[2] + s_sinx[2];
		s_T[2*MAT_DIM+5] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_cosx[2] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinx[2];
		s_T[2*MAT_DIM+6] = s_cosx[2];
		s_T[3*MAT_DIM]   = s_cosx[3];
		s_T[3*MAT_DIM+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinx[3];
		s_T[3*MAT_DIM+2] = s_sinx[3];
		s_T[3*MAT_DIM+4] = -s_sinx[3];
		s_T[3*MAT_DIM+5] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosx[3];
		s_T[3*MAT_DIM+6] = s_cosx[3];
		s_T[4*MAT_DIM]   = -s_cosx[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinx[4];
		s_T[4*MAT_DIM+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinx[4];
		s_T[4*MAT_DIM+2] = s_sinx[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosx[4];
		s_T[4*MAT_DIM+4] = s_sinx[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosx[4];
		s_T[4*MAT_DIM+5] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosx[4];
		s_T[4*MAT_DIM+6] = s_cosx[4] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinx[4];
		s_T[5*MAT_DIM]   = s_cosx[5];
		s_T[5*MAT_DIM+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinx[5];
		s_T[5*MAT_DIM+2] = s_sinx[5];
		s_T[5*MAT_DIM+4] = -s_sinx[5];
		s_T[5*MAT_DIM+5] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosx[5];
		s_T[5*MAT_DIM+6] = s_cosx[5];
		s_T[6*MAT_DIM]   = -s_cosx[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinx[6];
		s_T[6*MAT_DIM+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinx[6];
		s_T[6*MAT_DIM+2] = s_sinx[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosx[6];
		s_T[6*MAT_DIM+4] = s_sinx[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosx[6];
		s_T[6*MAT_DIM+5] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosx[6];
		s_T[6*MAT_DIM+6] = s_cosx[6] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinx[6];
	}
}

template <typename T>
__device__
void updateTransforms4x4to6x6_GPU(T *s_T, T *s_Tb4, T *s_adj){
   // then convert from 4x4 to 6x6
   // if  4x4 = [R(3x3) xyz(1x3)
   //            0,0,0, 1       ]
   // the 6x6 = [R^T       0    
   //            R^T*adj   R^T]
   // so all we need to do is load R^T and compute R^T*adj
   int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
   #pragma unroll
   for (int k = starty; k < NUM_POS; k += dy){
      T *Tk = &s_T[36*k]; T *adjk = &s_adj[9*k]; T *T4k = &s_Tb4[k*16];
      #pragma unroll
      for (int ind = startx; ind < 9; ind += dx){int c = ind / 3; int r = ind % 3;
         // load in the R^T and 0
         T val = T4k[r*4+c]; Tk[c*6+r] = val; Tk[(c+3)*6+(r+3)] = val; Tk[(c+3)*6+r] = static_cast<T>(0);
         // compute R^T*adj (now c is col of adj and r is row of R^T = col of R)
         val = static_cast<T>(0);
         #pragma unroll
         for (int i = 0; i < 3; i++){val += T4k[r*4 + i] * adjk[c*3 + i];}
         Tk[c*6+r+3] = val;
      }
   }
}

template <typename T, bool MPC_MODE = false>
__device__
void FD_helpers_GPU(T *s_v, T *s_a, T *s_f, T *s_Minv, T *s_qd, T *s_qdd, T *s_I, T *s_IA, T *s_T, T *s_U, T *s_D, T *s_F, T *s_temp, T *s_fext = nullptr){
	// In GPU mode want to reduce the number of syncs so we intersperce the computations
	//----------------------------------------------------------------------------
	// RNEA Forward Pass / Minv Backward Pass
	//----------------------------------------------------------------------------
	int start, delta; singleLoopVals_GPU(&start,&delta);
	int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
	for (int k = 0; k < NUM_POS; k++){ int kMinv = NUM_POS - 1 - k;
		// first the first half of the Minv comp fully in parallel aka get Uk and Dk
		T *Uk = &s_U[6*kMinv];      T *Dk = &s_D[2*kMinv];      T *IAk = &s_IA[36*kMinv];  bool has_parent = (kMinv > 0); 
		for(int i = start; i < 6; i += delta){Uk[i] = IAk[6*2+i]; if(i == 2){Dk[0] = Uk[i]; Dk[1] = 1/Dk[0];}}
		// we need to intersperse the functions to reduce syncthreads in the GPU version
		// then the first bit of the RNEA forward pass aka get v and a
		T *lk_v = &s_v[6*k];    T *lk_a = &s_a[6*k];    T *tkXkm1 = &s_T[36*k];    T *Tk = &s_T[36*kMinv];    T *Fk = &s_F[6*NUM_POS*kMinv];
		if (k == 0){
			// l1_v = vJ, for the first kMinvnk of a fixed base robot
			// and the a is just gravity times the last col of the transform and then add qdd in 3rd entry if computing bias term for gradients
			for(int i = start; i < 6; i += delta){
				lk_v[i] = (i == 2) ? s_qd[k] : 0;
				lk_a[i] = MPC_MODE ? static_cast<T>(0) : tkXkm1[6*5+i] * GRAVITY; if(i == 2){lk_a[2] += s_qdd[k];}
			}
			// then we start computing the IA for Minv
			if (has_parent){
				for(int ky = starty; ky < 6; ky += dy){
				   	for(int kx = startx; kx < 6; kx += dx){
						T val = static_cast<T>(0);
						#pragma unroll
						for (int i = 0; i < 6; i++){val += (IAk[kx+6*i] - Uk[i]*Uk[kx]*Dk[1]) * Tk[ky*6+i];}
						s_temp[ky*6+kx] = val;
				   	}
			    }
			}
			// while we load in the update to minv
			int num_children = 6 - kMinv;
			if(__doOnce()){s_Minv[rc_Ind(kMinv,kMinv,NUM_POS)] = Dk[1];}  // (21) Minv[i,i] = Di^-1
			if (num_children > 0){ // (12) Minv[i,subtree(i)] = -Di^-T * SiT * Fi[:,subtree(i)]
				#pragma unroll
				for(int i = start; i < num_children; i += delta){
					s_Minv[rc_Ind(kMinv,(kMinv+1+i),NUM_POS)] = -Dk[1] * Fk[rc_Ind(2,(kMinv+1+i),6)];
				}
			}
			__syncthreads();
			// then we finish the IA
			if (has_parent){
			    T *IAlamk = IAk - 36;
			    for(int ky = starty; ky < 6; ky += dy){
			       	for(int kx = startx; kx < 6; kx += dx){
						T val = static_cast<T>(0);
						#pragma unroll
						for (int i = 0; i < 6; i++){val += Tk[kx*6+i] * s_temp[ky*6+i];}
						IAlamk[ky*6+kx] += val;
			       	}
			    }
			}
			// while we update the F
			#pragma unroll
			for(int c = starty; c <= num_children; c += dy){ // (14)  Fi[:,subtree(i)] = Ui * Minv[i,subtree(i)]
			    T Minvc = s_Minv[rc_Ind(kMinv,(kMinv+c),NUM_POS)]; T *Fkc = &Fk[rc_Ind(0,(kMinv+c),6)];
			    #pragma unroll
			    for(int r = startx; r < 6; r += dx){Fkc[r] += Uk[r] * Minvc;}
			}
		}
	  	else{
			T *lkm1_v = lk_v - 6;    T *lkm1_a = lk_a - 6;    int num_children = 6 - kMinv; 
			// first compute the v and add += s_qd[k] in entry [2]
			for(int r = start; r < 6; r += delta){
				T val = r == 2 ? s_qd[k] : static_cast<T>(0);
				#pragma unroll
				for (int c = 0; c < 6; c++){val += tkXkm1[6*c+r] * lkm1_v[c];}
				lk_v[r] = val; 
			}
			// then we start computing the IA for Minv
			if (has_parent){
				for(int ky = starty; ky < 6; ky += dy){
					for(int kx = startx; kx < 6; kx += dx){
						T val = static_cast<T>(0);
						#pragma unroll
						for (int i = 0; i < 6; i++){val += (IAk[kx+6*i] - Uk[i]*Uk[kx]*Dk[1]) * Tk[ky*6+i];}
						s_temp[ky*6+kx] = val;
					}
				}
			}
			// while we load in the update to minv
			if(__doOnce()){s_Minv[rc_Ind(kMinv,kMinv,NUM_POS)] = Dk[1];}  // (21) Minv[i,i] = Di^-1
			if (num_children > 0){ // (12) Minv[i,subtree(i)] = -Di^-T * SiT * Fi[:,subtree(i)]
				#pragma unroll
				for(int i = start; i < num_children; i += delta){
				   s_Minv[rc_Ind(kMinv,(kMinv+1+i),NUM_POS)] = -Dk[1] * Fk[rc_Ind(2,(kMinv+1+i),6)];
				}
			}
			__syncthreads();
			// Compute the a (Mx3(v) += that with tkXkm1 * lkm1_a) and add qdd in entry [2]
			for(int r = start; r < 6; r += delta){
				loadMx3_GPU<T>(lk_a,lk_v,r,s_qd[k]);
				T val = r == 2 ? s_qdd[k] : static_cast<T>(0);
				#pragma unroll
				for (int c = 0; c < 6; c++){val += tkXkm1[6*c+r] * lkm1_a[c];}
				lk_a[r] += val; 
			}
			// then we finish the IA
			if (has_parent){
				T *IAlamk = IAk - 36;
				for(int ky = starty; ky < 6; ky += dy){
				   for(int kx = startx; kx < 6; kx += dx){
				      T val = static_cast<T>(0);
				      #pragma unroll
				      for (int i = 0; i < 6; i++){val += Tk[kx*6+i] * s_temp[ky*6+i];}
				      IAlamk[ky*6+kx] += val;
				   }
				}
			}
			// while we update the F
			#pragma unroll
			for(int c = starty; c <= num_children; c += dy){ // (14)  Fi[:,subtree(i)] = Ui * Minv[i,subtree(i)]
				T Minvc = s_Minv[rc_Ind(kMinv,(kMinv+c),NUM_POS)]; T *Fkc = &Fk[rc_Ind(0,(kMinv+c),6)];
				#pragma unroll
				for(int r = startx; r < 6; r += dx){Fkc[r] += Uk[r] * Minvc;}
			}
		}
		__syncthreads();
		// if has parent need to transform and add Fi to Flami
		// (15)    Flami[:,subtree(i)] = Flami[:,subtree(i)] + lamiXi* * Fi[:,subtree(i)]
		if (has_parent){T *Flamk = Fk - 6*NUM_POS; iteratedMatVMult_GPU<T,6,6,1,1>(Flamk,6,Tk,6,Fk,6,7);}
		__syncthreads();
	}
	// we note that we can finally compute the lk_fs fully in parallel so we break out to specific code for this situation
	// we need to compute lk_f = vcrosIv + Ia - fext
	#pragma unroll
	for(int k = starty; k < NUM_POS; k += dy){
		T *lk_v = &s_v[6*k]; T *lk_a = &s_a[6*k]; T *lk_f = &s_f[6*k]; T *lk_fext = &s_fext[6*k]; T *lk_I = &s_I[36*k]; T *lk_temp = &s_temp[6*k];
		#pragma unroll
		for(int r = startx; r < 6; r += dx){
			// first do temp = Iv and start lk_f = Ia - fext
			T val = 0;           T val2 = 0;
			#pragma unroll
			for (int i = 0; i < 6; i++){T currI = lk_I[i*6 + r]; val += currI*lk_v[i]; val2 += currI*lk_a[i];}
			lk_temp[r] = val;   lk_f[r] = val2;  if(s_fext != nullptr){lk_f[r] -= lk_fext[r];}
		}
	}
	__syncthreads();
	// now we can finish off lk_f by += with the vcross*Temp
	#pragma unroll
	for(int k = start; k < NUM_POS; k += delta){
		T *lk_v = &s_v[6*k]; T *lk_f = &s_f[6*k]; T *lk_temp = &s_temp[6*k];
		lk_f[0] += -lk_v[2]*lk_temp[1] + lk_v[1]*lk_temp[2];
		lk_f[1] += lk_v[2]*lk_temp[0] + -lk_v[0]*lk_temp[2];
		lk_f[2] += -lk_v[1]*lk_temp[0] + lk_v[0]*lk_temp[1];
		lk_f[3] += -lk_v[2]*lk_temp[1+3] + lk_v[1]*lk_temp[2+3];
		lk_f[4] += lk_v[2]*lk_temp[0+3] + -lk_v[0]*lk_temp[2+3];
		lk_f[5] += -lk_v[1]*lk_temp[0+3] + lk_v[0]*lk_temp[1+3];
		lk_f[0] += -lk_v[2+3]*lk_temp[1+3] + lk_v[1+3]*lk_temp[2+3];
		lk_f[1] += lk_v[2+3]*lk_temp[0+3] + -lk_v[0+3]*lk_temp[2+3];
		lk_f[2] += -lk_v[1+3]*lk_temp[0+3] + lk_v[0+3]*lk_temp[1+3];
	}
	__syncthreads();

	//----------------------------------------------------------------------------
	// RNEA Backward Pass / Minv forwrd pass
	//----------------------------------------------------------------------------
	for (int k = NUM_POS - 1; k >= 0; k--){ int kMinv = NUM_POS - 1 - k;
		// first for the RNEA
		T *lk_f = &s_f[6*k];     
		if(k > 0){
			T *lkm1_f = &s_f[6*(k-1)];     T *tkXkm1 = &s_T[36*k]; 
			matVMult_GPU<T,6,6,1,1>(lkm1_f,tkXkm1,6,lk_f); // lkm1_f += tkXkm1^T * lk_f
		}
		// then for Minv
		T *Uk = &s_U[6 * kMinv];      T Dinvk = s_D[2*kMinv+1];     T *Tk = &s_T[36*kMinv];
		T *Fk_subtree = &s_F[(NUM_POS+1)*6*kMinv];    T *Flamk_subtree = &s_F[(NUM_POS+1)*6*kMinv - 6*NUM_POS];
		bool has_parent = (kMinv > 0);   int N_subtree = NUM_POS-kMinv;   T *Minv_subtree = &s_Minv[NUM_POS*kMinv + kMinv];
		if (has_parent){ // (30) Minv[i,subtree(i)] += -D^-1 * Ui^T * Tk * Flami[:,subtree(i)]
			matVMult_GPU<T,6,6,0,1>(s_temp,Tk,6,Uk); __syncthreads();
			iteratedMatVMult_GPU<T,1,6,1,1>(Minv_subtree,NUM_POS,s_temp,1,Flamk_subtree,6,N_subtree,-Dinvk);
		}
		for(int i = starty; i < N_subtree; i += dy){ // (32) Fi = Si * Minv[i,subtree(i)]
			for(int j = startx; j < 6; j += dx){
		    	Fk_subtree[6*i+j] = (j == 2) ? Minv_subtree[NUM_POS*i] : static_cast<T>(0);
			}
		}
		__syncthreads();
		if (has_parent){ // (34) Fi[:,subtree(i)] += Tk * Flami[:,subtree(i)]
			iteratedMatVMult_GPU<T,6,6,1>(Fk_subtree,6,Tk,6,Flamk_subtree,6,N_subtree); __syncthreads();
		}
	}
}

template <typename T, bool MPC_MODE = false>
__device__
void FD_helpers_GPU_vaf(T *s_v, T *s_a, T *s_f, T *s_qd, T *s_qdd, T *s_I, T *s_T, T *s_temp, T *s_fext = nullptr){
	// In GPU mode want to reduce the number of syncs so we intersperce the computations
	//----------------------------------------------------------------------------
	// RNEA Forward Pass
	//----------------------------------------------------------------------------
	int start, delta; singleLoopVals_GPU(&start,&delta);
	int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
	for (int k = 0; k < NUM_POS; k++){
		// then the first bit of the RNEA forward pass aka get v and a
		T *lk_v = &s_v[6*k]; T *lkm1_v = lk_v - 6; T *lk_a = &s_a[6*k]; T *lkm1_a = lk_a - 6; T *tkXkm1 = &s_T[36*k];
		if (k == 0){
			// l1_v = vJ, for the first kMinvnk of a fixed base robot and the a is just gravity times the last col of the transform and then add qdd in 3rd entry
			for(int i = start; i < 6; i += delta){
				lk_v[i] = (i == 2) ? s_qd[k] : static_cast<T>(0);
				lk_a[i] = MPC_MODE ? static_cast<T>(0) : tkXkm1[6*5+i] * GRAVITY; if(i == 2){lk_a[2] += s_qdd[k];}
			}
		}
	  	else{
			// first compute the v and add += s_qd[k] in entry [2]
			for(int r = start; r < 6; r += delta){
				T val = r == 2 ? s_qd[k] : static_cast<T>(0);
				#pragma unroll
				for (int c = 0; c < 6; c++){val += tkXkm1[6*c+r] * lkm1_v[c];}
				lk_v[r] = val; 
			}
			__syncthreads();
			// Compute the a (Mx3(v) += that with tkXkm1 * lkm1_a) and add qdd in entry [2]
			for(int r = start; r < 6; r += delta){
				loadMx3_GPU<T>(lk_a,lk_v,r,s_qd[k]);
				T val = r == 2 ? s_qdd[k] : static_cast<T>(0);
				#pragma unroll
				for (int c = 0; c < 6; c++){val += tkXkm1[6*c+r] * lkm1_a[c];}
				lk_a[r] += val; 
			}
		}
		__syncthreads();
	}
	// we note that we can finally compute the lk_fs fully in parallel so we break out to specific code for this situation
	// we need to compute lk_f = vcrosIv + Ia - fext
	#pragma unroll
	for(int k = starty; k < NUM_POS; k += dy){
		T *lk_v = &s_v[6*k]; T *lk_a = &s_a[6*k]; T *lk_f = &s_f[6*k]; T *lk_fext = &s_fext[6*k]; T *lk_I = &s_I[36*k]; T *lk_temp = &s_temp[6*k];
		#pragma unroll
		for(int r = startx; r < 6; r += dx){
			// first do temp = Iv and start lk_f = Ia - fext
			T val = 0;           T val2 = 0;
			#pragma unroll
			for (int i = 0; i < 6; i++){T currI = lk_I[i*6 + r]; val += currI*lk_v[i]; val2 += currI*lk_a[i];}
			lk_temp[r] = val;   lk_f[r] = val2;  if(s_fext != nullptr){lk_f[r] -= lk_fext[r];}
		}
	}
	__syncthreads();
	// now we can finish off lk_f by += with the vcross*Temp
	#pragma unroll
	for(int k = start; k < NUM_POS; k += delta){
		T *lk_v = &s_v[6*k]; T *lk_f = &s_f[6*k]; T *lk_temp = &s_temp[6*k];
		lk_f[0] += -lk_v[2]*lk_temp[1] + lk_v[1]*lk_temp[2];
		lk_f[1] += lk_v[2]*lk_temp[0] + -lk_v[0]*lk_temp[2];
		lk_f[2] += -lk_v[1]*lk_temp[0] + lk_v[0]*lk_temp[1];
		lk_f[3] += -lk_v[2]*lk_temp[1+3] + lk_v[1]*lk_temp[2+3];
		lk_f[4] += lk_v[2]*lk_temp[0+3] + -lk_v[0]*lk_temp[2+3];
		lk_f[5] += -lk_v[1]*lk_temp[0+3] + lk_v[0]*lk_temp[1+3];
		lk_f[0] += -lk_v[2+3]*lk_temp[1+3] + lk_v[1+3]*lk_temp[2+3];
		lk_f[1] += lk_v[2+3]*lk_temp[0+3] + -lk_v[0+3]*lk_temp[2+3];
		lk_f[2] += -lk_v[1+3]*lk_temp[0+3] + lk_v[0+3]*lk_temp[1+3];
	}
	__syncthreads();

	//----------------------------------------------------------------------------
	// RNEA Backward Pass
	//----------------------------------------------------------------------------
	for (int k = NUM_POS - 1; k > 0; k--){
		T *lk_f = &s_f[6*k]; T *lkm1_f = &s_f[6*(k-1)]; T *tkXkm1 = &s_T[36*k]; 
		matVMult_GPU<T,6,6,1,1>(lkm1_f,tkXkm1,6,lk_f); // lkm1_f += tkXkm1^T * lk_f
	}
}

template <typename T>
__device__
void FD_helpers_GPU_Minv(T *s_Minv, T *s_IA, T *s_T, T *s_U, T *s_D, T *s_F, T *s_temp, T *s_fext = nullptr){
	//----------------------------------------------------------------------------
	// Minv Backward Pass
	//----------------------------------------------------------------------------
	int start, delta; singleLoopVals_GPU(&start,&delta);
	int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
	for (int kMinv = NUM_POS-1; kMinv >= 0; kMinv--){bool has_parent = (kMinv > 0); int num_children = 6 - kMinv;
		T *Tk = &s_T[36*kMinv]; T *Fk = &s_F[6*NUM_POS*kMinv]; T *Uk = &s_U[6*kMinv]; T *Dk = &s_D[2*kMinv]; T *IAk = &s_IA[36*kMinv];
		// first the first half of the Minv comp fully in parallel aka get Uk and Dk
		for(int i = start; i < 6; i += delta){Uk[i] = IAk[6*2+i]; if(i == 2){Dk[0] = Uk[i]; Dk[1] = 1/Dk[0];}}
		// do the first half of the IA comp if we have a parent
		if (has_parent){
			for(int ky = starty; ky < 6; ky += dy){
			   	for(int kx = startx; kx < 6; kx += dx){
					T val = static_cast<T>(0);
					#pragma unroll
					for (int i = 0; i < 6; i++){val += (IAk[kx+6*i] - Uk[i]*Uk[kx]*Dk[1]) * Tk[ky*6+i];}
					s_temp[ky*6+kx] = val;
			   	}
		    }
		}
		// (21) Minv[i,i] = Di^-1
		if(__doOnce()){s_Minv[rc_Ind(kMinv,kMinv,NUM_POS)] = Dk[1];}
		// (12) Minv[i,subtree(i)] = -Di^-T * SiT * Fi[:,subtree(i)]
		if (num_children > 0){
			#pragma unroll
			for(int i = start; i < num_children; i += delta){
				s_Minv[rc_Ind(kMinv,(kMinv+1+i),NUM_POS)] = -Dk[1] * Fk[rc_Ind(2,(kMinv+1+i),6)];
			}
		}
		__syncthreads();
		// then we finish the IA (if applicable)
		if (has_parent){
		    T *IAlamk = IAk - 36;
		    for(int ky = starty; ky < 6; ky += dy){
		       	for(int kx = startx; kx < 6; kx += dx){
					T val = static_cast<T>(0);
					#pragma unroll
					for (int i = 0; i < 6; i++){val += Tk[kx*6+i] * s_temp[ky*6+i];}
					IAlamk[ky*6+kx] += val;
		       	}
		    }
		}
		// (14)  Fi[:,subtree(i)] = Ui * Minv[i,subtree(i)]
		#pragma unroll
		for(int c = starty; c <= num_children; c += dy){ 
		    T Minvc = s_Minv[rc_Ind(kMinv,(kMinv+c),NUM_POS)]; T *Fkc = &Fk[rc_Ind(0,(kMinv+c),6)];
		    #pragma unroll
		    for(int r = startx; r < 6; r += dx){Fkc[r] += Uk[r] * Minvc;}
		}
		__syncthreads();
		// (15) Flami[:,subtree(i)] = Flami[:,subtree(i)] + lamiXi* * Fi[:,subtree(i)]
		if (has_parent){ 
			T *Flamk = Fk - 6*NUM_POS;
			iteratedMatVMult_GPU<T,6,6,1,1>(Flamk,6,Tk,6,Fk,6,7);
			__syncthreads();
		}
	}
	//----------------------------------------------------------------------------
	// Minv forwrd pass
	//----------------------------------------------------------------------------
	for (int kMinv = 0; kMinv < NUM_POS; kMinv++){
		// then for Minv
		T *Uk = &s_U[6 * kMinv];      T Dinvk = s_D[2*kMinv+1];     T *Tk = &s_T[36*kMinv];
		T *Fk_subtree = &s_F[(NUM_POS+1)*6*kMinv];    T *Flamk_subtree = &s_F[(NUM_POS+1)*6*kMinv - 6*NUM_POS];
		bool has_parent = (kMinv > 0);   int N_subtree = NUM_POS-kMinv;   T *Minv_subtree = &s_Minv[NUM_POS*kMinv + kMinv];
		if (has_parent){ // (30) Minv[i,subtree(i)] += -D^-1 * Ui^T * Tk * Flami[:,subtree(i)]
			matVMult_GPU<T,6,6,0,1>(s_temp,Tk,6,Uk); __syncthreads();
			iteratedMatVMult_GPU<T,1,6,1,1>(Minv_subtree,NUM_POS,s_temp,1,Flamk_subtree,6,N_subtree,-Dinvk);
		}
		for(int i = starty; i < N_subtree; i += dy){ // (32) Fi = Si * Minv[i,subtree(i)]
			for(int j = startx; j < 6; j += dx){
		    	Fk_subtree[6*i+j] = (j == 2) ? Minv_subtree[NUM_POS*i] : static_cast<T>(0);
			}
		}
		__syncthreads();
		if (has_parent){ // (34) Fi[:,subtree(i)] += Tk * Flami[:,subtree(i)]
			iteratedMatVMult_GPU<T,6,6,1>(Fk_subtree,6,Tk,6,Flamk_subtree,6,N_subtree); __syncthreads();
		}
	}
}

template <typename T>
__device__ 
void computeTempVals_GPU_part1(T *s_Iv, T *s_Ta, T *s_Tv, T *s_I, T *s_T, T *s_v, T *s_a){
   // start with the matMuls: Tk*vlamk, Tk*alamk, Ik*vk
   int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
   for (int k = starty; k < NUM_POS; k += dy){
     int ind = 6*k; int indlam = ind - 6; int Mind = 36*k;
     matVMult_xthreads<T,6,6>(startx,dx,&s_Iv[ind],&s_I[Mind],6,&s_v[ind]);
     if (k > 0){
     	matVMult_xthreads<T,6,6>(startx,dx,&s_Tv[ind],&s_T[Mind],6,&s_v[indlam]);
     	matVMult_xthreads<T,6,6>(startx,dx,&s_Ta[ind],&s_T[Mind],6,&s_a[indlam]);
   	}
   }
}

template <typename T>
__device__ 
void computeTempVals_GPU_part2(T *s_Fxv, T *s_Mxv, T *s_Mxf, T *s_MxTa, T *s_vdq, T *s_Ta, T *s_Tv, T *s_v, T *s_f){
	// then sync and do all Mxs: Mx3(fk), Mx3(vk)*qd[k], Mx3(Tv), Mx3(Ta) --- note Mx3(Tv) stored in k col of dVk/dq 
	int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
	for (int k = starty; k < NUM_POS; k += dy){int ind = 6*k;
		for (int r = startx; r < 6; r += dx){
			loadMx3_GPU<T>(&s_Mxv[ind],&s_v[ind],r); loadMx3_GPU<T>(&s_Mxf[ind],&s_f[ind],r);
			if (k > 0){
				loadMx3_GPU<T>(&s_MxTa[ind],&s_Ta[ind],r); loadMx3_GPU<T>(&s_vdq[3*k*(k+1) + ind],&s_Tv[ind],r);
			}
		}
	}
	// also do FxMat(vk) -- this is probably slow
	int start, delta; singleLoopVals_GPU(&start,&delta);
	for (int k = start; k < NUM_POS; k += delta){ int indk = k*6; int indMk = indk*6;
      serialFx_GPU(&s_Fxv[indMk],&s_v[indk]);
		// for(int c = 0; c < 6; c++){ int indc = c*6;
		// 	for (int r = 0; r < 6; r++){
		// 		loadFx_GPU(&s_Fxv[indMk + indc],&s_v[indk],r,c);
		// 	}
		// }
	}
}


template <typename T>
__device__ 
void computeTempVals_GPU_part3(T *s_vdq, T *s_vdqd, T *s_TFxf, T *s_FxvI, T *s_Fxv, T *s_Mxf, T *s_T, T *s_I){
   // then sync before finishing off with Fxvk*Ik, -Tk^T*Mxfk = Tk^T*Fxfk and preload some of Vdu
	int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
	for (int k = starty; k < NUM_POS; k += dy){int ind6 = 6*k; int ind36 = 36*k; 
		matVMult_xthreads<T,6,6,0,1>(startx,dx,&s_TFxf[ind6],&s_T[ind36],6,&s_Mxf[ind6],static_cast<T>(-1));
		matMult_xthreads<T,6,6,6,0,1>(startx,dx,&s_FxvI[ind36],6,&s_Fxv[ind36],6,&s_I[ind36],6); // not really sure why but need the transpose
	}
	// also note for the forward pass we can pre-load in part of 
	// dVk/dqd [Tk[:,2] for k-1 col | [0 0 1 0 0 0]T for k col]
	// dVk/dq has the pattern [0 for 0 col | MxTv for k col] but the later was already stored
	for (int k = starty; k < NUM_POS; k += dy){int ind = 3*k*(k+1); int ind6 = 6*k;
		for (int r = startx; r < 6; r += dx){
			s_vdq[ind + r] = static_cast<T>(0);
			s_vdqd[ind + ind6 + r] = (r == 2) ? static_cast<T>(1) : static_cast<T>(0);
			if(k > 0){s_vdqd[ind + ind6 - 6 + r] = s_T[ind6*6 + 12 + r];}
		}
	}
}

template <typename T>
__device__
void compute_vdu_GPU2(T *s_vdq, T *s_vdqd, T *s_T){
   int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
   for (int k = 0; k < NUM_POS; k++){
   	// dVk/dqd has the pattern [Tk*dvlamk/dqd for 0:k-2 cols | Tk[:,2] for k-1 col | [0 0 1 0 0 0]T for k col | 0 for k+1 to NUM_POS col]
   	int indlamk = 3*k*(k-1); int indk = indlamk + 6*k; T *Tk = &s_T[36*k];
   	for (int c = starty; c < k-1; c += dy){ // only need to now load the multuplication into 0:k-2 -- starting with k = 3
      	int indc = c*6; T *vdqdlamkc = &s_vdqd[indlamk + indc];
      	for (int r = startx; r < 6; r += dx){
            T val = static_cast<T>(0); 
            #pragma unroll
            for(int i = 0; i < 6; i++){val += Tk[r + 6 * i] * vdqdlamkc[i];} 
            s_vdqd[indk + indc + r] = val;
      	}
   	}
   	// dVk/dq has the pattern [0 | Tk*dvlank/dq for 1:k-1 cols | MxMat_col3(Tk*vlamk) | 0 for k+1 to NUM_POS col]
   	for (int c = starty; c < k; c += dy){if (c == 0){continue;} // already loaded the 0 and the MxTv so only 1:k-1
      	T *vdqlamkc = &s_vdq[indlamk + c*6];
      	for (int r = startx; r < 6; r += dx){int indcr = 6*c + r;
            T val = static_cast<T>(0);
            #pragma unroll
            for(int i = 0; i < 6; i++){val += Tk[r + 6 * i] * vdqlamkc[i];} 
            s_vdq[indk + indcr] = val;
      	}
   	}
   	__syncthreads();
   }
}

template <typename T>
__device__
void compute_adu_GPU2_part1(T *s_adq, T *s_adqd, T *s_vdq, T *s_vdqd, T *s_MxTa, T *s_Mxv, T *s_qd){
	// sync then again exploiting sparsity in dv and da we continue
	// dak/du = Tk * dalamk/du + MxMatCol3_oncols(dvk/du)*qd[k] + {for q in col k: MxMatCol3(Tk*alamk)} 
	//                                                          + {for qd in col k: MxMatCol3(vk)}
	// remember we have already computed Mxv, MxTa so add that to Mx3(dvk/du)*qd[k] and store in dak/du in parallel
	int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
	for (int k = starty; k < NUM_POS; k += dy){int indk = 3*k*(k+1); int ind6 = 6*k;
      	for (int c = startx; c <= k; c += dx){int indkc = indk + 6*c;
         	#pragma unroll
         	for (int r = 0; r < 6; r++){
	            // MxMatCol3_oncols(dvk/du)*qd[k]
	            loadMx3_GPU<T>(&s_adq[indkc],&s_vdq[indkc],r,s_qd[k]); loadMx3_GPU<T>(&s_adqd[indkc],&s_vdqd[indkc],r,s_qd[k]);
	            // add the special part for q or qd if applicable
	            if(c == k){int ind6r = ind6 + r; int indkcr = indkc + r; s_adqd[indkcr] += s_Mxv[ind6r]; if(k > 0){s_adq[indkcr] += s_MxTa[ind6r];}}
         	}
      	}
	}
}

template <typename T>
__device__
void compute_adu_GPU2_part2(T *s_adq, T *s_adqd, T *s_T){
	// then do the loop to sum up the da/dus with the transform
	// int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
	int start, delta; singleLoopVals_GPU(&start,&delta);
	for (int k = 1; k < NUM_POS; k++){
		int lamkStart = 3*k*(k-1); int kStart = 3*k*(k+1); T *Tk = &s_T[36*k];
		// if(blockIdx.x == 0 && __doOnce()){printf("k[%d] for total col_lam[%d], col[%d] and Tind[%d]\n",k,indlamk,indk,36*k);}
		for (int rc = start; rc < k*6; rc += delta){
			int r = rc % 6; int cStart = rc - r; int ind = kStart + cStart + r;
			T valq = static_cast<T>(0); T valqd = static_cast<T>(0);
			#pragma unroll
			for(int i = 0; i < 6; i++){
				T Tcurr = Tk[r + 6 * i]; int lamInd = lamkStart + cStart + i;
				valq += Tcurr * s_adq[lamInd]; valqd += Tcurr * s_adqd[lamInd];
			}
			s_adq[ind] += valq; 
			s_adqd[ind] += valqd;
		}
		__syncthreads();
	}
}

template <typename T>
__device__
void compute_Fxvdu(T *s_Fxvdq, T *s_Fxvdqd, T *s_vdq, T *s_vdqd){
	// we can also precompute FxMat(dv/du) here for use later (expanding each col of dv/du into a 6x6 matrix)
	// this is probably the slowest operation because it is so irregular on the GPU
	int start, delta; singleLoopVals_GPU(&start,&delta); int cols = static_cast<int>(0.5*NUM_POS*(NUM_POS+1));
	for (int kc = start; kc < cols; kc += delta){
      int indk = 6*kc; int indMk = indk*6;
      serialFx_GPU(&s_Fxvdq[indMk],&s_vdq[indk]);
      serialFx_GPU(&s_Fxvdqd[indMk],&s_vdqd[indk]);
      // for (int c = 0; c < 6; c++){ int indc = 6*c;
      //   	for (int r = 0; r < 6; r++){
      //      	loadFx2_GPU(&s_Fxvdq[indMk + indc],&s_vdq[indk],&s_Fxvdqd[indMk + indc],&s_vdqd[indk],r,c);
      //   	}
      // }
	}
}

template <typename T>
__device__
void compute_fdu_GPU2(T *s_fdq, T *s_fdqd, T *s_adq, T *s_adqd, T *s_vdq, T *s_vdqd, T *s_Fxvdq, T *s_Fxvdqd, T *s_FxvI, T *s_Iv, T *s_I){
	// now we can compute all dfdu in parallel noting that dv and da only exist for c <=k
	// dfk/du = Ik*dak/du + FxMat(vk)*Ik*dvk/du + FxMat(dvk/du across cols)*Ik*vk
	// noting that all of them have a dv or da in each term we know that df only exists for c <=k (in the fp but all NUM_POS in bp)
	// also we already have FxvI, Iv, and Fxdv so we just need to sum the iterated MatVs: I*da + FxvI*dv + Fxdv*Iv
	int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
	for (int k = starty; k < NUM_POS; k += dy){int ind6 = 6*k; int ind36 = 6*ind6;
	  	T *Ivk = &s_Iv[ind6];
	  	for (int ind = startx; ind < (k+1)*6; ind += dx){ // make sure c <= k
			int c = ind / 6;  int r = ind % 6;  int indkc = 3*k*(k+1) + c*6;
			int indf = NUM_POS*ind6 + ind;      int indFkcr = 6*indkc + r;
			T *Fxdvdqkcr = &s_Fxvdq[indFkcr];   T *Fxdvdqdkcr = &s_Fxvdqd[indFkcr];
			T *FxvIkr = &s_FxvI[ind36 + r];     T *Ikr = &s_I[ind36 + r];
			T valq = static_cast<T>(0); T valqd = static_cast<T>(0);
			#pragma unroll
			for(int i = 0; i < 6; i++){
		        T Icurr = Ikr[6 * i]; T FxvIcurr = FxvIkr[6 * i]; T Ivkcurr = Ivk[i];
		        valq  +=  Icurr * s_adq[indkc + i] + Fxdvdqkcr[6 * i] * Ivkcurr + FxvIcurr * s_vdq[indkc + i];
		        valqd +=  Icurr * s_adqd[indkc + i] + Fxdvdqdkcr[6 * i] * Ivkcurr + FxvIcurr * s_vdqd[indkc + i];
     		}
	    	s_fdq[indf] = valq; s_fdqd[indf] = valqd;
	  	}
	}
}

template <typename T>
__device__
void compute_cdu_GPU2_part1(T *s_fdq, T *s_fdqd, T *s_TFxf, T *s_T){
	int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
	for (int k = NUM_POS - 1; k > 0; k--){int ind6 = 6*k;
   	for (int c = starty; c < NUM_POS; c += dy){
      	int indlamkc = 6*NUM_POS*(k-1) + 6*c; int indkc = indlamkc + 6*NUM_POS;
      	T *fdqkc = &s_fdq[indkc]; T *fdqdkc = &s_fdqd[indkc];
      	for (int r = startx; r < 6; r += dx){
            // dflamk/du += Tk^T*cols(df/du)
            T valq = static_cast<T>(0); T valqd = static_cast<T>(0);
         	#pragma unroll
         	for(int i = 0; i < 6; i++){
               T Tcurr = s_T[(ind6 + r) * 6 + i];  // its an ind36 but reduce mults by adding first
               valq += Tcurr * fdqkc[i]; valqd += Tcurr * fdqdkc[i];
         	}
            // if c = k += Tk^T*Fx(fk) which we already have computed so just += :)!
            if (c == k){valq += s_TFxf[ind6 + r];}
            // result += if c <= k else set because should be 0 right now anyway
            if (c < k){s_fdq[indlamkc + r] += valq; s_fdqd[indlamkc + r] += valqd;}
            else {s_fdq[indlamkc + r] = valq; s_fdqd[indlamkc + r] = valqd;}
      	}
   	}
   	__syncthreads();
	}
}

template <typename T, bool VEL_DAMPING = 1>
__device__
void compute_cdu_GPU2_part2(T *s_cdq, T *s_cdqd, T *s_fdq, T *s_fdqd){
	int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx);
	// now in full parallel load in dc/du = row 3 of df
	for (int k = starty; k < NUM_POS; k += dy){
      	for (int ind = startx; ind < NUM_POS; ind += dx){
         	int dst = NUM_POS*ind + k; int src = 6*NUM_POS*k + 6*ind + 2;
         	s_cdq[dst] = s_fdq[src]; s_cdqd[dst] = s_fdqd[src];
         	if(VEL_DAMPING && (k == ind)){s_cdqd[NUM_POS*ind + k] += 0.5;}
      	}
   	}
}

template <typename T, bool VEL_DAMPING = 1>
__device__
void inverseDynamicsGradient_GPU(T *s_cdq, T *s_cdqd, T *s_qd, T *s_v, T *s_a, T *s_f, T *s_I, T *s_T, int k){
	// note v,a,fdu (for iiwa) only exist for c < k cols so can compactly fit in (1 + 2 + ... NUM_POS)*6 space
	// this is (NUM_POS)*(NUM_POS+1)/2*6 = 3*NUM_POS*(NUM_POS+1)
	__shared__ T s_vdq[3*NUM_POS*(NUM_POS+1)];
	__shared__ T s_vdqd[3*NUM_POS*(NUM_POS+1)];
	__shared__ T s_adq[3*NUM_POS*(NUM_POS+1)];
	__shared__ T s_adqd[3*NUM_POS*(NUM_POS+1)];
	__shared__ T s_fdq[6*NUM_POS*NUM_POS];
	__shared__ T s_fdqd[6*NUM_POS*NUM_POS];
	// we also need FxMat(vdu)
	__shared__ T s_Fxvdq[18*NUM_POS*(NUM_POS+1)]; // expand vectors into mats
	__shared__ T s_Fxvdqd[18*NUM_POS*(NUM_POS+1)]; // expand vectors into mats

	//----------------------------------------------------------------------------
	// Compute helpers in parallel with few syncs
	//----------------------------------------------------------------------------
	// start by computing the temp vals (note that one can be directly parallel store in vdq and vdqd a couple things)
	__shared__ T s_temp[72*NUM_POS];
	__shared__ T s_temp2[36*NUM_POS];
	T *s_Tv = &s_temp[18];
	T *s_Ta = &s_temp[24*NUM_POS];
	T *s_Fxv = &s_temp[36*NUM_POS];
	T *s_Mxf = &s_temp2[0];
	T *s_Iv = &s_temp2[6*NUM_POS];
	T *s_Mxv = &s_temp2[12*NUM_POS];
	// T *s_MxTv = &s_temp2[18*NUM_POS]; // just storing directly into the dv/dq
	T *s_MxTa = &s_temp2[18*NUM_POS];
	T *s_TFxf = &s_temp2[24*NUM_POS];
	T *s_FxvI = &s_temp[0]; //Tv,Ta done when computing this so reuse
	// start computing all of the sub parts we can compute outside of the loops
	// Mx3(Tk*vlamk), Mx3(Tk*alamk), Mx3(vk)*qd[k], Ik*vk, FxMat(vk)*Ik, Tk^T*Fx3(fk) = -Tk^T*Mx3(fk)
	// start with the matMuls: Tk*vlamk, Tk*alamk, Ik*vk
	computeTempVals_GPU_part1(s_Iv, s_Ta, s_Tv, s_I, s_T, s_v, s_a);
	__syncthreads();
	// then sync and do all Mxs: Mx3(fk), Mx3(vk)*qd[k], Mx3(Tv), Mx3(Ta) --- note Mx3(Tv) stored in k col of dVk/dq 
	// also do FxMat(vk) -- this is probably slow
	computeTempVals_GPU_part2(s_Fxv, s_Mxv, s_Mxf, s_MxTa, s_vdq, s_Ta, s_Tv, s_v, s_f);
	__syncthreads();
	// then sync before finishing off with Fxvk*Ik, -Tk^T*Mxfk = Tk^T*Fxfk and preload some of Vdu
	computeTempVals_GPU_part3(s_vdq, s_vdqd, s_TFxf, s_FxvI, s_Fxv, s_Mxf, s_T, s_I);
	__syncthreads();
	//----------------------------------------------------------------------------
	// Forward Pass for dc/u
	// note: dq and dqd are independent and lots of sparsity
	// note2: we have s_FxvI, s_Iv, s_Mxv, s_MxTv, s_MxTa, s_TMxf to use!
	//----------------------------------------------------------------------------
	// first compute the vdu recursion
	compute_vdu_GPU2<T>(s_vdq, s_vdqd, s_T);
	__syncthreads();
	// then compute adu -- first the parallel part while saving Fxvdu for later
	compute_adu_GPU2_part1<T>(s_adq, s_adqd, s_vdq, s_vdqd, s_MxTa, s_Mxv, s_qd);
	compute_Fxvdu<T>(s_Fxvdq, s_Fxvdqd, s_vdq, s_vdqd);
	__syncthreads();
	// then finish adu with the recursion
	compute_adu_GPU2_part2<T>(s_adq, s_adqd, s_T);
	__syncthreads();
	// finally comptue all fdu in parallel
	compute_fdu_GPU2<T>(s_fdq, s_fdqd, s_adq, s_adqd, s_vdq, s_vdqd, s_Fxvdq, s_Fxvdqd, s_FxvI, s_Iv, s_I);
	__syncthreads();
	//----------------------------------------------------------------------------
	// Backward Pass for dc/u
	//----------------------------------------------------------------------------
	compute_cdu_GPU2_part1<T>(s_fdq, s_fdqd, s_TFxf, s_T);
	__syncthreads();
	compute_cdu_GPU2_part2<T,VEL_DAMPING>(s_cdq, s_cdqd, s_fdq, s_fdqd);
}

template <typename T, int KNOT_POINTS, bool VEL_DAMPING = 1>
__global__
void dynamicsGradientKernel_Middle(T *d_cdq, T *d_cdqd, T *d_v, T *d_a, T *d_f, T *d_I, T *d_T, T *d_x, int ld_x){
   int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx); int start, delta; singleLoopVals_GPU(&start,&delta);
   __shared__ T s_v[6*NUM_POS];        __shared__ T s_a[6*NUM_POS];        __shared__ T s_f[6*NUM_POS];
   __shared__ T s_I[36*NUM_POS];          __shared__ T s_T[36*NUM_POS];       __shared__ T s_qd[NUM_POS];
   __shared__ T s_cdq[NUM_POS*NUM_POS];    __shared__ T s_cdqd[NUM_POS*NUM_POS];
   // loop for all knots needed per SM (note only load I once as it is constant)
   for (int ind = start; ind < 36*NUM_POS; ind += delta){s_I[ind] = d_I[ind];} __syncthreads();
   // then grided thread the knot points
   for (int k = blockIdx.x; k < KNOT_POINTS; k += gridDim.x){
      T *vk = &d_v[k*6*NUM_POS]; T *ak = &d_a[k*6*NUM_POS]; T *fk = &d_f[k*6*NUM_POS]; T *Tk = &d_T[k*36*NUM_POS];
      T *qdk = &d_x[k*ld_x + NUM_POS]; T *cdqk = &d_cdq[k*NUM_POS*NUM_POS]; T *cdqdk = &d_cdqd[k*NUM_POS*NUM_POS];
      // load in v,a,f,T,qd for current knot
      #pragma unroll
      for (int ind = start; ind < 6*NUM_POS; ind += delta){s_v[ind] = vk[ind]; s_a[ind] = ak[ind]; s_f[ind] = fk[ind];}
      #pragma unroll
      for (int ind = start; ind < 36*NUM_POS; ind += delta){s_T[ind] = Tk[ind];}
      #pragma unroll
      for (int ind = start; ind < NUM_POS; ind += delta){s_qd[ind] = qdk[ind];}
      __syncthreads();
        // then compute the inverse dynamics gradient
        inverseDynamicsGradient_GPU<T,VEL_DAMPING>(s_cdq,s_cdqd,s_qd,s_v,s_a,s_f,s_I,s_T,k); __syncthreads();
        // Then copy to global
        #pragma unroll
      for (int ind = start; ind < NUM_POS*NUM_POS; ind += delta){cdqk[ind] = s_cdq[ind]; cdqdk[ind] = s_cdqd[ind];}
      __syncthreads();
        
   }
}

template <typename T, int KNOT_POINTS, bool MPC_MODE = false, bool VEL_DAMPING = true>
__global__
void dynamicsGradientKernel_1stHalf(T *d_cdq, T *d_cdqd, T *d_x, T *d_qdd, T *d_I, T *d_Tbody, int ld_x, T *s_fext = nullptr){
   int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx); int start, delta; singleLoopVals_GPU(&start,&delta);
   __shared__ T s_q[NUM_POS];            __shared__ T s_qd[NUM_POS];            __shared__ T s_qdd[NUM_POS];
   __shared__ T s_sinq[NUM_POS];         __shared__ T s_cosq[NUM_POS];       __shared__ T s_temp[42];
   __shared__ T s_v[6*NUM_POS];        __shared__ T s_a[6*NUM_POS];        __shared__ T s_f[6*NUM_POS];
   __shared__ T s_T[36*NUM_POS];       __shared__ T s_I[36*NUM_POS];
   __shared__ T s_cdq[NUM_POS*NUM_POS];   __shared__ T s_cdqd[NUM_POS*NUM_POS];
   // loop for all knots needed per SM
   for (int k = blockIdx.x; k < KNOT_POINTS; k += gridDim.x){T *xk = &d_x[k*ld_x]; T *qddk = &d_qdd[k*NUM_POS];
      // load in x,u,qdd,sinq,cosq,T,I and update T
      #pragma unroll
      for (int ind = start; ind < NUM_POS; ind += delta){
         s_q[ind] = xk[ind]; s_qd[ind] = xk[ind+NUM_POS]; s_qdd[ind] = qddk[ind]; s_sinq[ind] = sin(s_q[ind]); s_cosq[ind] = cos(s_q[ind]);
      }
      #pragma unroll
      for (int ind = start; ind < 36*NUM_POS; ind += delta){s_I[ind] = d_I[ind]; s_T[ind] = d_Tbody[ind];}
      __syncthreads();
      updateTransforms_GPU(s_T,s_sinq,s_cosq); __syncthreads();
      // dqdd/dtau = Minv and  dqdd/dq(d) = -Minv*dc/dq(d) note: dM term in dq drops out if you compute c with fd qdd per carpentier
      FD_helpers_GPU_vaf<T,MPC_MODE>(s_v,s_a,s_f,s_qd,s_qdd,s_I,s_T,s_temp,s_fext); __syncthreads();
      inverseDynamicsGradient_GPU<T,VEL_DAMPING>(s_cdq,s_cdqd,s_qd,s_v,s_a,s_f,s_I,s_T,k); __syncthreads();
      // copy out to RAM
      T *cdqk = &d_cdq[k*NUM_POS*NUM_POS]; T *cdqdk = &d_cdqd[k*NUM_POS*NUM_POS];
      #pragma unroll
      for (int ind = start; ind < NUM_POS*NUM_POS; ind += delta){cdqk[ind] = s_cdq[ind]; cdqdk[ind] = s_cdqd[ind];}
   }
}

template <typename T, int KNOT_POINTS, bool MPC_MODE = false, bool VEL_DAMPING = true>
__global__
void dynamicsGradientKernel_1stHalf_v2(T *d_cdq, T *d_cdqd, T *d_x, T *d_qdd, T *d_I, T *d_T4, T *d_adj, int ld_x, T *s_fext = nullptr){
   int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx); int start, delta; singleLoopVals_GPU(&start,&delta);
   __shared__ T s_q[NUM_POS];            __shared__ T s_qd[NUM_POS];            __shared__ T s_qdd[NUM_POS];
   __shared__ T s_sinq[NUM_POS];         __shared__ T s_cosq[NUM_POS];          __shared__ T s_temp[42];
   __shared__ T s_v[6*NUM_POS];          __shared__ T s_a[6*NUM_POS];           __shared__ T s_f[6*NUM_POS];
   __shared__ T s_T[36*NUM_POS];         __shared__ T s_I[36*NUM_POS];          __shared__ T s_T4[16*NUM_POS];
   __shared__ T s_cdq[NUM_POS*NUM_POS];  __shared__ T s_cdqd[NUM_POS*NUM_POS];  __shared__ T s_adj[9*NUM_POS];
   // loop for all knots needed per SM
   for (int k = blockIdx.x; k < KNOT_POINTS; k += gridDim.x){T *xk = &d_x[k*ld_x]; T *qddk = &d_qdd[k*NUM_POS];
      // load in x,u,qdd,sinq,cosq,T,I and update T
      #pragma unroll
      for (int ind = start; ind < NUM_POS; ind += delta){
         s_q[ind] = xk[ind]; s_qd[ind] = xk[ind+NUM_POS]; s_qdd[ind] = qddk[ind]; s_sinq[ind] = sin(s_q[ind]); s_cosq[ind] = cos(s_q[ind]);
      }
      __syncthreads();
      updateT4_GPU<T>(s_T4,s_cosq,s_sinq);
      #pragma unroll
      for (int ind = start; ind < 36*NUM_POS; ind += delta){s_I[ind] = d_I[ind];}
      #pragma unroll
      for (int ind = start; ind < 16*NUM_POS; ind += delta){s_T4[ind] = d_T4[ind];}
         #pragma unroll
      for (int ind = start; ind < 9*NUM_POS; ind += delta){s_adj[ind] = d_adj[ind];}
      __syncthreads();
      updateTransforms4x4to6x6_GPU<T>(s_T,s_T4,s_adj); __syncthreads();
      // dqdd/dtau = Minv and  dqdd/dq(d) = -Minv*dc/dq(d) note: dM term in dq drops out if you compute c with fd qdd per carpentier
      FD_helpers_GPU_vaf<T,MPC_MODE>(s_v,s_a,s_f,s_qd,s_qdd,s_I,s_T,s_temp,s_fext); __syncthreads();
      inverseDynamicsGradient_GPU<T,VEL_DAMPING>(s_cdq,s_cdqd,s_qd,s_v,s_a,s_f,s_I,s_T,k); __syncthreads();
      // copy out to RAM
      T *cdqk = &d_cdq[k*NUM_POS*NUM_POS]; T *cdqdk = &d_cdqd[k*NUM_POS*NUM_POS];
      #pragma unroll
      for (int ind = start; ind < NUM_POS*NUM_POS; ind += delta){cdqk[ind] = s_cdq[ind]; cdqdk[ind] = s_cdqd[ind];}
   }
}