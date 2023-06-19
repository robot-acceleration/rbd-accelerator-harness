/***
 *  g++ standalone.cpp -fpermissive -ldl -lpthread
***/

// load in utility functions
#include "utils.h"
// then load all apropriate dynamics functions
#include "dynamics/FPGATypes.h"
#include <dlfcn.h>
#include <vector>


#define TIMING_TEST_ITERS 10000
#define TIMING_TEST_ITERS_SINGLE (TIMING_TEST_ITERS*100)
#define CONVERGENCE_TEST_ITERS 100
#define GLOBAL_MAX_ITERS 40


int main(int argc, char *argv[])
{
        void *handle;
        char *error;


	void (*connectal_setup)();
	void (*perform_points)(unsigned int points);

	// dynamic library stuff
        handle = dlopen ("/home/bthom/connectal.so", RTLD_LAZY);
        if (!handle) {
	   fputs (dlerror(), stderr);
	   exit(1);
	}

        connectal_setup = dlsym(handle, "connectal_setup");
        if ((error = dlerror()) != NULL)  {
             fputs(error, stderr);
             exit(1);
        }
        perform_points = dlsym(handle, "perform_points");
        if ((error = dlerror()) != NULL)  {
             fputs(error, stderr);
             exit(1);
        }
        printf("\n\n\n\n Setup Connectal \n\n\n\n");
        fflush(stdout);
	connectal_setup(); // Should be done only once.	


	FPGADataOut<10,7> *localdataOut10 = *((FPGADataOut<10,7>** ) dlsym(handle, "localdataOut10"));
        if ((error = dlerror()) != NULL)  {
             fputs(error, stderr);
             exit(1);
        }

        FPGADataIn<10,7> *localdataIn10 = *((FPGADataIn<10,7>** )dlsym(handle, "localdataIn10"));
        if ((error = dlerror()) != NULL)  {
             fputs(error, stderr);
             exit(1);
        }

    	fflush(stdout);
	// To use 16/23/64... points needs to define the symbols localdataIn/Out32/64/....

        // Generic testing
	const int NUM_LINKS = 7;
        const int KNOT_POINTS = 10;
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

        float xTemp[] = {0.297288, 0.382396, -0.597634, -0.0104452, -0.839027, 0.311111, 2.29509,
                         0.999905, 0.251662, 0.986666, 0.555751, 0.437108, 0.424718, 0.773223};
	float qddTemp[] = {0.671362351, 2.085405497, -0.920425575, 5.464981623, 25.85650645, 105.449175, 52.12766742};
	float vTemp[] = {0.0, 0.0, 0.999905, 0.0, 0.0, 0.0,
			 0.373109, 0.927685, 0.251662, 0.0, 0.0, 0.0,
			 -0.450045, -0.00190277, 1.91435, -0.000389117, 0.0920342, 3.73109e-13,
			 -0.470016, 1.90955, 0.557654, -0.00079912, -8.34731e-6, -0.189019,
			 -0.100832, 0.722306, 2.34665, 0.274428, -0.107102, -8.34731e-6,
			 0.622359, 2.26487, -0.297588, 0.409436, -0.131664, 0.0853726,
			 0.189494, 0.663311, 3.03809, 0.388964, 0.234737, -0.131664};
	float aTemp[] = {0.0, 0.0, 0.671362, 0.0, 0.0, 0.0,
			 0.483978, 0.528975, 2.08541, 0.0, 0.0, 0.0,
			 -1.5754, 1.89566, -0.391451, 0.387661, 0.32217, 4.83978e-13,
			 -0.509994, -0.146673, 3.56933, 0.796127, 0.00876021, -0.661668,
			 -1.99906, 2.80848, 25.7098, 0.423533, -0.727309, 0.00876021,
			 6.92905, 24.8232, 102.641, 0.926137, -0.480476, 0.296512,
			 81.9788, -62.9671, 76.9509, -4.07122, -6.40232, -0.480476};
	float fTemp[] = {-0.386208, 0.368599, 0.28119, 0.818636, 1.98773, -3.07625,
			 0.0930661, 0.248573, 0.209472, -1.83265, -2.57865, 1.86775,
			 0.380028, 0.0151653, 0.251379, 0.210761, 2.40183, -2.49168,
			 0.925628, 0.297174, 0.0203749, -0.839812, -2.1552, -1.17263,
			 -0.376703, -0.860545, 0.287702, 0.13818, 1.44749, -1.98613,
			 0.0383153, 0.167, 0.859512, -0.890237, -1.39686, -1.30446,
			 0.122748, -0.0996843, 0.0769509, -1.83586, -2.03848, -0.211055};
	// sabrina inertias, -Minv
	float minvTemp[] = {-3.3084, 0.832568, 3.24692, 2.9516, -1.01435, -0.394646, 0.321418,
			    0.832568, -0.81964, -0.649599, -1.87147, -0.293887, -1.37315, 0.35137,
			    3.24692, -0.649599, -41.9993, -3.07484, 39.287, -0.691391, 0.188062,
			    2.9516, -1.87147, -3.07484, -6.6787, -1.61578, -5.4728, 2.85474,
			    -1.01435, -0.293887, 39.287, -1.61578, -141.751, -3.12746, 98.7838,
			    -0.394646, -1.37315, -0.691391, -5.4728, -3.12746, -122.669, 4.79672,
			    0.321418, 0.35137, 0.188062, 2.85474, 98.7838, 4.79672, -1095.04};

	for (int k = 0; k < KNOT_POINTS; k++){
	  for (int i = 0; i < ld_x; i++){x[k*ld_x + i] = xTemp[i];}
	  for (int i = 0; i < NUM_LINKS; i++){qdd[k*NUM_LINKS + i] = qddTemp[i];}
	  for (int i = 0; i < 6*NUM_LINKS; i++){v[k*6*NUM_LINKS + i] = vTemp[i]; a[k*6*NUM_LINKS + i] = aTemp[i]; f[k*6*NUM_LINKS + i] = fTemp[i];}
	  for (int i = 0; i < 7*NUM_LINKS; i++){minv[k*7*NUM_LINKS + i] = minvTemp[i];}
	}

        float cdqTemp[] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
			   -1.24362, 0.582421, 1.56724, -0.192563, -0.33799, -0.977344, 0.660384,
			   3.55945, -0.344106, -3.36412, 1.15354, -0.0129418, -0.177376, -0.185702,
			   1.417, -0.72308, -37.4566, 0.764383, 34.7457, -0.0580001, -0.221741,
			   -2.72105, 0.185134, 2.96749, 4.85204, 1.28725, 8.85384, -1.59216,
			   -0.742551, -0.202056, 0.559617, -0.192991, -3.51297, -1.38046, 10.3641,
			   6.40682e-17, 3.35435e-17, -2.34715e-17, 1.45632e-16, 1.24305e-16, 3.03677e-16, -1.7413e-16};

	float cdqdTemp[] = {-0.473735, 0.815095, 0.577285, -0.101241, -0.268021, -0.653879, 0.524936, 
			    -4.13029, -0.224794, 3.87979, -0.773574, 0.578369, -1.42329, -0.128547, 
			    0.613957, 0.206468, -0.497011, 0.111485, -0.158698, -0.242926, 0.249359, 
			    2.42061, 0.832767, -2.1925, 0.319842, -0.760031, -2.66009, -0.147668, 
			    -0.0582392, -0.0237767, 0.0671238, 0.0633837, -0.11376, 0.75914, 0.424139, 
			    -0.0953933, 0.0067175, 0.103334, 0.166093, -0.642115, 0.125406, 1.18206, 
			    -0.00115371, -0.000175798, 0.000697093, -0.000716492, -0.010351, -0.0737067, 0.0102964};


	for (int k = 0; k < KNOT_POINTS; k++){
	  for (int i = 0; i < ld_x; i++){x[k*ld_x + i] = xTemp[i];}
  	  for (int i = 0; i < NUM_LINKS; i++){qdd[k*NUM_LINKS + i] = qddTemp[i];}
  	  for (int i = 0; i < 6*NUM_LINKS; i++){v[k*6*NUM_LINKS + i] = vTemp[i]; a[k*6*NUM_LINKS + i] = aTemp[i]; f[k*6*NUM_LINKS + i] = fTemp[i];}
  	  for (int i = 0; i < 7*NUM_LINKS; i++){minv[k*7*NUM_LINKS + i] = minvTemp[i];}}

        

	// Global variables localdataOutN and localdataInN with N=10,16,32,64,128,256 contains the places
	// where the data should be put/received they should have been defined using the dlsym earlier as they are defined on connectal side

	// Populate data in localdataIn10
	for (int k = 0; k < KNOT_POINTS; k++){
	  int indk = k*NUM_LINKS; float *xk = &x[k*ld_x]; float *qddk = &qdd[indk];
	  int ind7k = k*NUM_LINKS*7; float *minvk = &minv[ind7k];
	  for (int i = 0; i < NUM_LINKS; i++){
	    localdataIn10->knots[k].links[i].sinq = fake_cast(std::sin(xk[i]));
	    localdataIn10->knots[k].links[i].cosq = fake_cast(std::cos(xk[i]));
	    localdataIn10->knots[k].links[i].qd   = fake_cast(xk[NUM_LINKS+i]);
	    localdataIn10->knots[k].links[i].qdd  = fake_cast(qddk[i]);
	    float *minvki = &minvk[i*7];
	    for (int j = 0; j < 7; j++){
	      localdataIn10->knots[k].links[i].minv[j] = fake_cast(minvki[j]);
	    }

          //  printf("%d ", localdataIn10->knots[k].links[i].qd);
	  }
	}
        struct timespec start1, end1;
	double t1;
	std::vector<double> vtime = {};

	// Call the FPGA:
	for (int i= 0 ; i< 1000; i++){
	   clock_gettime(CLOCK_MONOTONIC,&start1);
           perform_points(KNOT_POINTS);
	   clock_gettime(CLOCK_MONOTONIC,&end1);
           t1 = diff_in_ns(start1,end1);
	   vtime.push_back(t1);
	}	// Only valid inputs are 10,16,32,64,128,256
	double sum = 0;

        for ( double x : vtime ) sum += x;
	sum = vtime.empty() ? 0 : sum / vtime.size();
	printf("%f average\n", sum);

	double var = 0;
	for( int n = 0; n < vtime.size(); n++ )
	{
		  var += (vtime[n] - sum) * (vtime[n] - sum);
	}
	var /= vtime.size();
	printf("%f std deviation\n", sqrt(var));
	// The function is blocking, only returns when the computation finished
	
	// Collect data out (if needed) here needed to compare against the reference input
	for (int k = 0; k < KNOT_POINTS; k++) {
	  int indk = k*NUM_POS*NUM_POS; float *cdqk = &cdq[indk]; float *cdqdk = &cdqd[indk];
	  for (int i = 0; i < NUM_LINKS; i++){
	    float *cdqki = &cdqk[i*NUM_LINKS]; float *cdqdki = &cdqdk[i*NUM_LINKS];
	    for (int j = 0; j < NUM_LINKS; j++){
	      cdqki[j] = fake_cast2(localdataOut10->knots[k].links[NUM_LINKS - (i+1)].cdq[j]);
	      cdqdki[j] = fake_cast2(localdataOut10->knots[k].links[NUM_LINKS - (i+1)].cdqd[j]);
	      unsigned int v1 = *((unsigned int *) ((void*) (&(localdataOut10->knots[k].links[i].cdq[j])))) ;
	      unsigned int v2 = *((unsigned int *) ((void*) (&(localdataOut10->knots[k].links[i].cdqd[j])))) ;
//	      printf("Final value cdq: %d %d %d %x\n", k,i,j, v1);
//	      printf("Final value cdqd:%d %d %d %x\n", k,i,j, v2);
	    }
	  }
	}

	printf("Check result\n");
	for (int k = 0; k < KNOT_POINTS; k++){
	  float *cdqk = &cdq[k*NUM_LINKS*NUM_LINKS]; float *cdqdk = &cdqd[k*NUM_LINKS*NUM_LINKS];
	  for (int i = 0; i < NUM_LINKS; i++){
	    for (int j = 0; j < NUM_LINKS; j++){
	      float deltaq = std::abs(cdqTemp[i + j*NUM_LINKS] - cdqk[i*NUM_LINKS+j]); float deltaqd = std::abs(cdqdTemp[i+j*NUM_LINKS] - cdqdk[i*NUM_LINKS + j]); int r = i; int c = j;
		printf("Error in  dq[k:%d][r,c:%d,%d] with delta[%f] for expected[%f] vs. actual[%f]\n",k,r,c,deltaq,cdqTemp[i+j*NUM_LINKS],cdqk[i*NUM_LINKS + j]);
		printf("Error in dqd[k:%d][r,c:%d,%d] with delta[%f] for expected[%f] vs. actual[%f]\n",k,r,c,deltaqd,cdqdTemp[i+j*NUM_LINKS],cdqdk[i*NUM_LINKS + j]);
			}
			}
		}

	return 0;
}

