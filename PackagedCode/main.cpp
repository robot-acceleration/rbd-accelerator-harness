/***
 *
g++ -std=c++11 -o main.exe main.cpp -lpthread -llcm -O3
nvcc -std=c++11 -x cu -o main.exe main.cpp -gencode arch=compute_75,code=sm_75 -lpthread -llcm -O3
//TODO: FPGA compile code
***/

#define COMPILE_WITH_GPU 0
#ifndef COMPILE_WITH_FPGA
	#define COMPILE_WITH_FPGA 0
#endif

#ifndef NUM_LINKS
    #define NUM_LINKS 7
#endif
#ifndef N_SPARSE_MINV_ENTRIES
    #define N_SPARSE_MINV_ENTRIES 49
#endif

// load in utility functions
#include "utils.h"
// then load all apropriate dynamics functions
#include "dynamics/CPUHelpers.h"
#if COMPILE_WITH_GPU
	#include "dynamics/GPUHelpers.h"
#endif
#if COMPILE_WITH_FPGA
//    #include "dmaManager.h"
//	#include "GradientPipelineIndication.h"
	#include "dynamics/FPGAHelpers.h"
#endif
#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)
#if COMPARE_PINOCCHIO
    #if !defined(URDF_FILEPATH)
        #error "URDF_FILEPATH must be defined for Pinocchio comparison"
    #else
        #define URDF_FILE TOSTRING(URDF_FILEPATH)
    #endif
    #include "dynamics/ReferenceHelper.h"
    #include <vector>
    #include <iterator>
#else
    #include "experiments/refInputsOutputs.h"
#endif
// the load the PDDP helpers
//#include "PDDP/DDPWrappers.h"
// finally load the experiments
//#include "experiments/experimentHelpers.h"
//#include "experiments/timingTests.h"
//#include "experiments/convergenceTests.h"
//#include "experiments/simFig8Tests.h"
//#include "experiments/robotFig8Tests.h"

#define TIMING_TEST_ITERS 10000
#define TIMING_TEST_ITERS_SINGLE (TIMING_TEST_ITERS*100)
#define CONVERGENCE_TEST_ITERS 100
#define GLOBAL_MAX_ITERS 40

int main(int argc, char *argv[])
{
        const int KNOT_POINTS = 128;
		int ld_x = 2*NUM_LINKS; int ld_u = NUM_LINKS;
		float *x = (float *)malloc(ld_x*KNOT_POINTS*sizeof(float));
        memset(x,0, ld_x*KNOT_POINTS*sizeof(float));
		float *u = (float *)malloc(ld_u*KNOT_POINTS*sizeof(float));
        memset(u,0, ld_u*KNOT_POINTS*sizeof(float));
		float *qdd = (float *)malloc(NUM_LINKS*KNOT_POINTS*sizeof(float));
        memset(qdd,0, NUM_LINKS*KNOT_POINTS*sizeof(float));
		float *minv = (float *)malloc(NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(float));
        memset(minv,0, NUM_LINKS*KNOT_POINTS*sizeof(float));
		float *dqdd = (float *)malloc(2*NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(float));
        memset(dqdd,0, 2*NUM_LINKS*KNOT_POINTS*sizeof(float));
		float *I = (float *)malloc(36*NUM_LINKS*sizeof(float));
        memset(I,0, 36*NUM_LINKS*sizeof(float));
		float *Tbody = (float *)malloc(36*NUM_LINKS*sizeof(float));
        memset(Tbody,0, 36*NUM_LINKS*sizeof(float));
		float *v = (float *)malloc(6*NUM_LINKS*KNOT_POINTS*sizeof(float));
        memset(v,0, 6*NUM_LINKS*KNOT_POINTS*sizeof(float));
		float *a = (float *)malloc(6*NUM_LINKS*KNOT_POINTS*sizeof(float));
        memset(a,0, 6*NUM_LINKS*KNOT_POINTS*sizeof(float));
		float *f = (float *)malloc(6*NUM_LINKS*KNOT_POINTS*sizeof(float));
        memset(f,0, 6*NUM_LINKS*KNOT_POINTS*sizeof(float));
		float *Tfinal = (float *)malloc(36*NUM_LINKS*KNOT_POINTS*sizeof(float));
        memset(Tfinal,0, 36*NUM_LINKS*KNOT_POINTS*sizeof(float));
		float *cdq = (float *)malloc(NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(float));
        memset(cdq,0, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(float));
		float *cdqd = (float *)malloc(NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(float));
        memset(cdqd,0, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(float));


    float * xTemp, * qddTemp, * minvTemp;

#ifndef COMPARE_PINOCCHIO
    xTemp    = (float *)malloc(ld_x*sizeof(float));
    qddTemp  = (float *)malloc(NUM_LINKS*sizeof(float));
    minvTemp = (float *)malloc(NUM_LINKS*NUM_LINKS*sizeof(float));
    if (NUM_LINKS == 7) {
        // use actual values for the iiwa
        memcpy(xTemp, xTemp7, sizeof(xTemp7));
        memcpy(qddTemp, qddTemp7, sizeof(qddTemp7));
        memcpy(minvTemp, minvTemp7, sizeof(minvTemp7));
    }
    else if (NUM_LINKS == 8) {
        // use actual values for the iiwa
        memcpy(xTemp, xTemp8, sizeof(xTemp8));
        memcpy(qddTemp, qddTemp8, sizeof(qddTemp8));
        memcpy(minvTemp, minvTemp8, sizeof(minvTemp8));
    }
    else if (NUM_LINKS == 9) {
        // use actual values for the iiwa
        memcpy(xTemp, xTemp9, sizeof(xTemp9));
        memcpy(qddTemp, qddTemp9, sizeof(qddTemp9));
        memcpy(minvTemp, minvTemp9, sizeof(minvTemp9));
    }
    else {
        fillRandom<float>(xTemp,    ld_x, 0, 1, 1);
        fillRandom<float>(qddTemp,  NUM_LINKS, 0, 1, 1);
        fillRandom<float>(minvTemp, NUM_LINKS*NUM_LINKS, 0, 1, 1);
    }
#else
    ReferenceHelper ref(URDF_FILE);
    xTemp = ref.get_x_ref();
    qddTemp = ref.get_qdd_ref();
    minvTemp = ref.get_minv_ref();
#endif

	for (int k = 0; k < KNOT_POINTS; k++){
	  for (int i = 0; i < ld_x; i++){x[k*ld_x + i] = xTemp[i];}
	  for (int i = 0; i < NUM_LINKS; i++){qdd[k*NUM_LINKS + i] = qddTemp[i];}
	  for (int i = 0; i < NUM_LINKS*NUM_LINKS; i++){minv[k*NUM_LINKS*NUM_LINKS + i] = minvTemp[i];}
	}

    float * cdqTemp, * cdqdTemp;

#ifndef COMPARE_PINOCCHIO
    cdqTemp  = (float *)malloc(NUM_LINKS*NUM_LINKS*sizeof(float));
    cdqdTemp = (float *)malloc(NUM_LINKS*NUM_LINKS*sizeof(float));
    if (NUM_LINKS == 7) {
        // use actual values for the iiwa
        memcpy(cdqTemp, cdqTemp7, sizeof(cdqTemp7));
        memcpy(cdqdTemp, cdqdTemp7, sizeof(cdqdTemp7));
    }
    else if (NUM_LINKS == 8) {
        // use actual values for the iiwa
        memcpy(cdqTemp, cdqTemp8, sizeof(cdqTemp8));
        memcpy(cdqdTemp, cdqdTemp8, sizeof(cdqdTemp8));
    }
    else if (NUM_LINKS == 9) {
        // use actual values for the iiwa
        memcpy(cdqTemp, cdqTemp9, sizeof(cdqTemp9));
        memcpy(cdqdTemp, cdqdTemp9, sizeof(cdqdTemp9));
    }
    else {
        fillRandom<float>(cdqTemp, NUM_LINKS*NUM_LINKS, -5, 5, 1);
        fillRandom<float>(cdqdTemp, NUM_LINKS*NUM_LINKS, -5, 5, 1);
    }
#else
    cdqTemp = ref.get_cdq_ref();
    cdqdTemp = ref.get_cdqd_ref();
#endif

	for (int k = 0; k < KNOT_POINTS; k++){
	  for (int i = 0; i < ld_x; i++){x[k*ld_x + i] = xTemp[i];}
  	  for (int i = 0; i < NUM_LINKS; i++){qdd[k*NUM_LINKS + i] = qddTemp[i];}
  	  for (int i = 0; i < NUM_LINKS*NUM_LINKS; i++){minv[k*NUM_LINKS*NUM_LINKS + i] = minvTemp[i];}}

        printf("\n\n\n\n Setup Connectal \n\n\n\n");
	connectal_setup(); // Should be done only once.	


	// Global variables localdataOutN and localdataInN with N=10,16,32,64,128,256 contains the places
	// where the data should be put/received:

#ifndef HOST_FPCONV
	// Populate data in
	for (int k = 0; k < KNOT_POINTS; k++){
	  int indk = k*NUM_LINKS; float *xk = &x[k*ld_x]; float *qddk = &qdd[indk];
	  int ind7k = k*NUM_LINKS*NUM_LINKS; float *minvk = &minv[ind7k];
	  for (int i = 0; i < NUM_LINKS; i++){
	    localdataIn128->knots[k].links[i].sinq = fake_cast(std::sin(xk[i]));
	    localdataIn128->knots[k].links[i].cosq = fake_cast(std::cos(xk[i]));
	    localdataIn128->knots[k].links[i].qd   = fake_cast(xk[NUM_LINKS+i]);
	    localdataIn128->knots[k].links[i].qdd  = fake_cast(qddk[i]);
	    float *minvki = &minvk[i*NUM_LINKS];
	    for (int j = 0; j < NUM_LINKS; j++){
	      localdataIn128->knots[k].links[i].minv[j] = fake_cast(minvki[j]);
	    }

            printf("%d ", localdataIn128->knots[k].links[i].qd);
	  }
	}

        perform_points(KNOT_POINTS); // Only valid inputs are 10,16,32,64,128,256

	// Collect data out
	for (int k = 0; k < KNOT_POINTS; k++) {
	  int indk = k*NUM_POS*NUM_POS; float *cdqk = &cdq[indk]; float *cdqdk = &cdqd[indk];
	  for (int i = 0; i < NUM_LINKS; i++){
	    float *cdqki = &cdqk[i*NUM_LINKS]; float *cdqdki = &cdqdk[i*NUM_LINKS];
	    for (int j = 0; j < NUM_LINKS; j++){
	      cdqki[j] = fake_cast2(localdataOut128->knots[k].links[NUM_LINKS - (i+1)].cdq[j]);
	      cdqdki[j] = fake_cast2(localdataOut128->knots[k].links[NUM_LINKS - (i+1)].cdqd[j]);
	      unsigned int v1 = *((unsigned int *) ((void*) (&(localdataOut128->knots[k].links[i].cdq[j])))) ;
	      unsigned int v2 = *((unsigned int *) ((void*) (&(localdataOut128->knots[k].links[i].cdqd[j])))) ;
	      printf("Final value cdq: %d %d %d %x\n", k,i,j, v1);
	      printf("Final value cdqd:%d %d %d %x\n", k,i,j, v2);
	    }
	  }
	}
#else
	// Populate data in
	for (int k = 0; k < KNOT_POINTS; k++){
	  int indk = k*NUM_LINKS; float *xk = &x[k*ld_x]; float *qddk = &qdd[indk];
	  int ind7k = k*NUM_LINKS*NUM_LINKS; float *minvk = &minv[ind7k];
	  for (int i = 0; i < NUM_LINKS; i++){
	    localdataIn128->knots[k].links[i].sinq = convertToFixed<float>(std::sin(xk[i]));
	    localdataIn128->knots[k].links[i].cosq = convertToFixed<float>(std::cos(xk[i]));
	    localdataIn128->knots[k].links[i].qd   = convertToFixed<float>(xk[NUM_LINKS+i]);
	    localdataIn128->knots[k].links[i].qdd  = convertToFixed<float>(qddk[i]);
	    float *minvki = &minvk[i*NUM_LINKS];
	    //for (int j = 0; j < NUM_LINKS; j++){
	    //  localdataIn128->knots[k].minv[i*NUM_LINKS+j] = convertToFixed<float>(minvki[j]);
	    //}

            printf("%d ", localdataIn128->knots[k].links[i].qd);
	  }

      int sparse_idx = 0;
      for (int r = 0; r < NUM_LINKS; r++) {
        for (int c = 0; c < NUM_LINKS; c++) {
          if (minvTemp[r*NUM_LINKS+c] != 0) {
            printf("%f ", minvk[r*NUM_LINKS+c]);
            localdataIn128->knots[k].minv[sparse_idx] = convertToFixed<float>(minvk[r*NUM_LINKS + c]);
            sparse_idx++;
          }
        }
      }
	}


        perform_points(KNOT_POINTS); // Only valid inputs are 10,16,32,64,128,256

	// Collect data out
	for (int k = 0; k < KNOT_POINTS; k++) {
	  int indk = k*NUM_POS*NUM_POS; float *cdqk = &cdq[indk]; float *cdqdk = &cdqd[indk];
      int sparse_idx = 0;
      for (int r = 0; r < NUM_LINKS; r++) {
        for (int c = 0; c < NUM_LINKS; c++) {
          if (minvTemp[r*NUM_LINKS+c] != 0) {
            int dense_minv_loc = r*NUM_LINKS + c;
	        cdqk[dense_minv_loc] = convertFromFixed<float>(localdataOut128->knots[k].cdq[sparse_idx]);
	        cdqdk[dense_minv_loc] = convertFromFixed<float>(localdataOut128->knots[k].cdqd[sparse_idx]);
            sparse_idx++;
          }
        }
      }
    }

	//for (int k = 0; k < KNOT_POINTS; k++) {
	//  int indk = k*NUM_POS*NUM_POS; float *cdqk = &cdq[indk]; float *cdqdk = &cdqd[indk];
	  //for (int i = 0; i < NUM_LINKS; i++){
	  //  float *cdqki = &cdqk[i*NUM_LINKS]; float *cdqdki = &cdqdk[i*NUM_LINKS];
	  //  for (int j = 0; j < NUM_LINKS; j++){
	  //    cdqki[j] = convertFromFixed<float>(localdataOut128->knots[k].cdq[i*NUM_LINKS+j]);
	  //    cdqdki[j] = convertFromFixed<float>(localdataOut128->knots[k].cdqd[i*NUM_LINKS+j]);
	  //    unsigned int v1 = *((unsigned int *) ((void*) (&(localdataOut128->knots[k].cdq[i*NUM_LINKS+j])))) ;
	  //    unsigned int v2 = *((unsigned int *) ((void*) (&(localdataOut128->knots[k].cdqd[i*NUM_LINKS+j])))) ;
	  //    printf("Final value cdq: %d %d %d %x\n", k,i,j, v1);
	  //    printf("Final value cdqd:%d %d %d %x\n", k,i,j, v2);
	  //    //printf("Array value cdq: %d %d %d %x\n", k,i,j, convertToFixed<float>(cdqki[j]));
	  //    //printf("Array value cdqd:%d %d %d %x\n", k,i,j, convertToFixed<float>(cdqdki[j]));
      //    //printf("-------\n");
	  //  }
	  //}
	//}
#endif

	printf("Check result\n");
    if (!(NUM_LINKS == 7 || NUM_LINKS == 8 || NUM_LINKS == 9)) {
        printf("Since NUM_LINKS != 7/8/9, these results are garbage because everything is filled with random values\n");
    }

	for (int k = 0; k < KNOT_POINTS; k++){
	  float *cdqk = &cdq[k*NUM_LINKS*NUM_LINKS]; float *cdqdk = &cdqd[k*NUM_LINKS*NUM_LINKS];
	  for (int i = 0; i < NUM_LINKS; i++){
	    for (int j = 0; j < NUM_LINKS; j++){
	      float deltaq = std::abs(cdqTemp[i + j*NUM_LINKS] - cdqk[i*NUM_LINKS+j]); float deltaqd = std::abs(cdqdTemp[i+j*NUM_LINKS] - cdqdk[i*NUM_LINKS + j]); int r = i; int c = j;
	      /*				char* valprod = (char*) &cdqk[i*NUM_LINKS + j];
						char* valexpected = (char*) &cdqTemp[i+j*NUM_LINKS];
				int prod = *(int*) valprod;	
				int expected = *(int*) valexpected;	

				char* qvalprod = (char*) &cdqdk[i*NUM_LINKS + j];
				char* qvalexpected = (char*) &cdqdTemp[i+j*NUM_LINKS];
				int qprod = *(int*) qvalprod;	
				int qexpected = *(int*) qvalexpected;	
printf("expected[%x] vs. actual[%x]\n",expected, prod);
printf("expected[%x] vs. actual[%x]\n",qexpected, qprod); */
printf("Error in  dq[k:%d][r,c:%d,%d] with delta[%f] for expected[%f] vs. actual[%f]\n",k,r,c,deltaq,cdqTemp[i+j*NUM_LINKS],cdqk[i*NUM_LINKS + j]);
printf("Error in dqd[k:%d][r,c:%d,%d] with delta[%f] for expected[%f] vs. actual[%f]\n",k,r,c,deltaqd,cdqdTemp[i+j*NUM_LINKS],cdqdk[i*NUM_LINKS + j]);
//				if (deltaq > 0.0004){ printf("Error in  dq[k:%d][r,c:%d,%d] with delta[%f] for expected[%f] vs. actual[%f]\n",k,r,c,deltaq,cdqTemp[i+j*NUM_LINKS],cdqk[i*NUM_LINKS + j]);}
//				if (deltaqd > 0.0004){printf("Error in dqd[k:%d][r,c:%d,%d] with delta[%f] for expected[%f] vs. actual[%f]\n",k,r,c,deltaqd,cdqdTemp[i+j*NUM_LINKS],cdqdk[i*NUM_LINKS + j]);}
			}
			}
		}

	return 0;
}

