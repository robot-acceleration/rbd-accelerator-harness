/***
export JULIA_DIR=<PATTO_JULIA_YOU_NEED_TO_INPUT_THIS_MANUALLY>
export JULIA_BINDIR=$JULIA_DIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JULIA_DIR/lib:$JULIA_DIR/lib/julia
g++ -std=c++11 -o fixedPointTests.exe fixedPointTests.cpp -lpthread -O3 -DJULIA_ENABLE_THREADING=1 -fPIC -I$JULIA_DIR/include/julia -L$JULIA_DIR/lib -ljulia
***/

#include <julia.h>
#include <type_traits>
#include "../utils.h"
#include "../dynamics/CPUHelpers.h"
#include "../PDDP/DDPWrappers.h"
#include "experimentHelpers.h"

#define TEST_ITERS 100
#define COMPILE_WITH_GPU 0
#define COMPILE_WITH_FPGA 0
#define GLOBAL_MAX_ITER 40
#define GLOBAL_KNOT_POINTS 64

JULIA_DEFINE_FAST_TLS() // only define this once, in an executable (not in a shared library) if you want fast code.

// from https://github.com/JuliaLang/julia/blob/633ad822ed68822255d61bdf575fb82329863ae1/test/embedding/embedding.c
jl_value_t *checked_eval_string(const char* code)
{
    jl_value_t *result = jl_eval_string(code);
    if (jl_exception_occurred()) {
        // none of these allocate, so a gc-root (JL_GC_PUSH) is not necessary
        jl_call2(jl_get_function(jl_base_module, "showerror"),
                 jl_stderr_obj(),
                 jl_exception_occurred());
        jl_printf(jl_stderr_stream(), "\n");
        jl_atexit_hook(1);
        exit(1);
    }
    assert(result && "Missing return value but no exception occurred!");
    return result;
}

/***********************************************************
 *                        WARNING                          *
 * Make sure all includes below are the ones neded in the  *
 * julia file for the various funciton calls               *
 ***********************************************************/

void initialize_julia(){
    jl_init();
    // Use Base.include because of https://github.com/JuliaLang/julia/issues/28825 usability bug (fixed on Julia master).
    // Use \"name.jl\" instead of name.jl (otherwise you'd be accessing the `jl` field of the `name` variable).
    checked_eval_string("Base.include(Main, \"../dynamics/juliaHelpers.jl\")");
}

void close_julia(){jl_atexit_hook(0);}

template <typename T>
void dynamicsGradJulia_middle(T *cdqk, T *cdqdk, T *xk, T *vk, T *ak, T *fk){
    // load the function
    jl_function_t *func = jl_get_function(jl_main_module, "dynamicsGradient_Middle_Wrapper");
    if (!func) {printf("[!] ERROR: Julia dynamics function not found\n"); jl_atexit_hook(1); exit(1);}

    // Allocate variables
    T sincosq[2*NUM_POS]; for(int i = 0; i < NUM_POS; i++){sincosq[i] = std::sin(xk[i]); sincosq[i+NUM_POS] = std::cos(xk[i]);}
    T vaf[18*NUM_POS]; for(int i = 0; i < 6*NUM_POS; i++){vaf[i] = vk[i]; vaf[i+6*NUM_POS] = ak[i]; vaf[i+12*NUM_POS] = fk[i];}
    jl_value_t *array_type;
    if (std::is_same<T, float>::value){array_type = jl_apply_array_type((jl_value_t*)jl_float32_type, 1);}
    else if (std::is_same<T, double>::value){array_type = jl_apply_array_type((jl_value_t*)jl_float64_type, 1);}
    else{printf("[!] ERROR: Julia dynamics only defined for FLOAT32 and FLOAT64 (double)\n"); jl_atexit_hook(1); exit(1);}
    jl_array_t *sincosq_j = jl_ptr_to_array_1d(array_type, sincosq, 2*NUM_POS, 0);
    jl_array_t *qd_j = jl_ptr_to_array_1d(array_type, &xk[NUM_POS], NUM_POS, 0);
    jl_array_t *vaf_j = jl_ptr_to_array_1d(array_type, vaf, 18*NUM_POS, 0);

    // evaluate the functions and memcpy the results to cpp
    jl_array_t *cdu_j = (jl_array_t*)jl_call3(func, (jl_value_t*)sincosq_j, (jl_value_t*)qd_j, (jl_value_t*)vaf_j);
    T temp[2*NUM_POS*NUM_POS]; memcpy(temp, (T *)jl_array_data(cdu_j), 2*NUM_POS*NUM_POS*sizeof(T));
    memcpy(cdqk, temp, NUM_POS*NUM_POS*sizeof(T)); memcpy(cdqdk, &temp[NUM_POS*NUM_POS], NUM_POS*NUM_POS*sizeof(T));
}

template <typename T>
void dynamicsGradJulia_1stHalf(T *cdqk, T *cdqdk, T *xk, T *qddk){
    // load the function
    jl_function_t *func = jl_get_function(jl_main_module, "dynamicsGradient_1stHalf_Wrapper");
    if (!func) {printf("[!] ERROR: Julia dynamics function not found\n"); jl_atexit_hook(1); exit(1);}

    // Allocate variables
    T sincosq[2*NUM_POS]; for(int i = 0; i < NUM_POS; i++){sincosq[i] = std::sin(xk[i]); sincosq[i+NUM_POS] = std::cos(xk[i]);}
    jl_value_t *array_type;
    if (std::is_same<T, float>::value){array_type = jl_apply_array_type((jl_value_t*)jl_float32_type, 1);}
    else if (std::is_same<T, double>::value){array_type = jl_apply_array_type((jl_value_t*)jl_float64_type, 1);}
    else{printf("[!] ERROR: Julia dynamics only defined for FLOAT32 and FLOAT64 (double)\n"); jl_atexit_hook(1); exit(1);}
    jl_array_t *sincosq_j = jl_ptr_to_array_1d(array_type, sincosq, 2*NUM_POS, 0);
    jl_array_t *qd_j = jl_ptr_to_array_1d(array_type, &xk[NUM_POS], NUM_POS, 0);
    jl_array_t *qdd_j = jl_ptr_to_array_1d(array_type, qddk, NUM_POS, 0);

    // evaluate the functions and memcpy the results to cpp
    jl_array_t *cdu_j = (jl_array_t*)jl_call3(func, (jl_value_t*)sincosq_j, (jl_value_t*)qd_j, (jl_value_t*)qdd_j);
    T temp[2*NUM_POS*NUM_POS]; memcpy(temp, (T *)jl_array_data(cdu_j), 2*NUM_POS*NUM_POS*sizeof(T));
    memcpy(cdqk, temp, NUM_POS*NUM_POS*sizeof(T)); memcpy(cdqdk, &temp[NUM_POS*NUM_POS], NUM_POS*NUM_POS*sizeof(T));
}

template <typename T>
void dynamicsGradJulia_middle2(T *cdqk, T *cdqdk, T *xk, T *vk, T *ak, T *fk){
    // load the function
    jl_function_t *func = jl_get_function(jl_main_module, "dynamicsGradient_Middle_Wrapper2");
    if (!func) {printf("[!] ERROR: Julia dynamics function not found\n"); jl_atexit_hook(1); exit(1);}

    // Allocate variables
    T vaf[18*NUM_POS]; for(int i = 0; i < 6*NUM_POS; i++){vaf[i] = vk[i]; vaf[i+6*NUM_POS] = ak[i]; vaf[i+12*NUM_POS] = fk[i];}
    jl_value_t *array_type;
    if (std::is_same<T, float>::value){array_type = jl_apply_array_type((jl_value_t*)jl_float32_type, 1);}
    else if (std::is_same<T, double>::value){array_type = jl_apply_array_type((jl_value_t*)jl_float64_type, 1);}
    else{printf("[!] ERROR: Julia dynamics only defined for FLOAT32 and FLOAT64 (double)\n"); jl_atexit_hook(1); exit(1);}
    jl_array_t *q_j = jl_ptr_to_array_1d(array_type, xk, NUM_POS, 0);
    jl_array_t *qd_j = jl_ptr_to_array_1d(array_type, &xk[NUM_POS], NUM_POS, 0);
    jl_array_t *vaf_j = jl_ptr_to_array_1d(array_type, vaf, 18*NUM_POS, 0);

    // evaluate the functions and memcpy the results to cpp
    jl_array_t *cdu_j = (jl_array_t*)jl_call3(func, (jl_value_t*)q_j, (jl_value_t*)qd_j, (jl_value_t*)vaf_j);
    T temp[2*NUM_POS*NUM_POS]; memcpy(temp, (T *)jl_array_data(cdu_j), 2*NUM_POS*NUM_POS*sizeof(T));
    memcpy(cdqk, temp, NUM_POS*NUM_POS*sizeof(T)); memcpy(cdqdk, &temp[NUM_POS*NUM_POS], NUM_POS*NUM_POS*sizeof(T));
}

template <typename T>
void dynamicsGradJulia_1stHalf2(T *cdqk, T *cdqdk, T *xk, T *qddk){
    // load the function
    jl_function_t *func = jl_get_function(jl_main_module, "dynamicsGradient_1stHalf_Wrapper2");
    if (!func) {printf("[!] ERROR: Julia dynamics function not found\n"); jl_atexit_hook(1); exit(1);}

    // Allocate variables
    jl_value_t *array_type;
    if (std::is_same<T, float>::value){array_type = jl_apply_array_type((jl_value_t*)jl_float32_type, 1);}
    else if (std::is_same<T, double>::value){array_type = jl_apply_array_type((jl_value_t*)jl_float64_type, 1);}
    else{printf("[!] ERROR: Julia dynamics only defined for FLOAT32 and FLOAT64 (double)\n"); jl_atexit_hook(1); exit(1);}
    jl_array_t *q_j = jl_ptr_to_array_1d(array_type, xk, NUM_POS, 0);
    jl_array_t *qd_j = jl_ptr_to_array_1d(array_type, &xk[NUM_POS], NUM_POS, 0);
    jl_array_t *qdd_j = jl_ptr_to_array_1d(array_type, qddk, NUM_POS, 0);

    // evaluate the functions and memcpy the results to cpp
    jl_array_t *cdu_j = (jl_array_t*)jl_call3(func, (jl_value_t*)q_j, (jl_value_t*)qd_j, (jl_value_t*)qdd_j);
    T temp[2*NUM_POS*NUM_POS]; memcpy(temp, (T *)jl_array_data(cdu_j), 2*NUM_POS*NUM_POS*sizeof(T));
    memcpy(cdqk, temp, NUM_POS*NUM_POS*sizeof(T)); memcpy(cdqdk, &temp[NUM_POS*NUM_POS], NUM_POS*NUM_POS*sizeof(T));
}

template <typename T, int KNOT_POINTS, bool MPC_MODE = false, bool SIN_COS_IN_FIXED = false>
void nextIterationSetupJulia_split(T **xs, T *xp, T **us, T *up, T **ds, T *dp, T **qdds, T *qddp, T **Minvs, T *Minvp, T *AB, T *H, T *g, T *P, T *p, T *Pp, T *pp, \
                            	   T *xGoal, std::thread *threads, int *alphaIndex, int ld_x, int ld_u, int ld_d, int ld_AB, int ld_H, int ld_g, int ld_P, int ld_p, \
                           		   T *v, T *a, T *f, T *Tfinal, T *I, T *Tbody, T *cdq, T *cdqd, T dt,
                           		   T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q1, T Q2, T R, T QF1, T QF2, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
	// Compute derivatives for dynamics through Julia
    // first compute v,a,f in threads
	threadDesc_t desc; desc.dim = INTEGRATOR_THREADS;
	for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){
		desc.tid = thread_i;    desc.reps = compute_reps(thread_i,INTEGRATOR_THREADS,(KNOT_POINTS-1));
		threads[thread_i] = std::thread(&integratorGradientThreaded_start<T,1,1,MPC_MODE>, desc, std::ref(xs[*alphaIndex]), std::ref(us[*alphaIndex]), 
	                                                                                             std::ref(qdds[*alphaIndex]), std::ref(Minvs[*alphaIndex]), 
	                                                                                             std::ref(v), std::ref(a), std::ref(f), std::ref(Tfinal), 
	                                                                                             ld_x, ld_u, std::ref(I), std::ref(Tbody));
		if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS + thread_i);}
	}
	// sync to finish that step
	for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}
    // launch the cost gradient
    desc.dim = COST_THREADS;
    for (unsigned int thread_i = 0; thread_i < COST_THREADS; thread_i++){
        desc.tid = thread_i;    desc.reps = compute_reps(thread_i,COST_THREADS,KNOT_POINTS);
        threads[thread_i] = std::thread(&costGradientHessianThreaded<T,KNOT_POINTS>, desc, std::ref(xs[*alphaIndex]), std::ref(us[*alphaIndex]), std::ref(g), std::ref(H), std::ref(xGoal), ld_x, ld_u, ld_H, ld_g,\
                                                                         				  Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,nullptr,nullptr);
        if(FORCE_CORE_SWITCHES){setCPUForThread(threads,thread_i);}
    }
 	// and launch the copy x,u,d to all x,u,d
 	threads[COST_THREADS] = std::thread(&memcpyArr<T>, std::ref(xs), std::ref(xs[*alphaIndex]), ld_x*KNOT_POINTS*sizeof(T), NUM_ALPHA, *alphaIndex);
 	if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS);}
 	threads[COST_THREADS + 1] = std::thread(&memcpyArr<T>, std::ref(us), std::ref(us[*alphaIndex]), ld_u*KNOT_POINTS*sizeof(T), NUM_ALPHA, *alphaIndex);
 	if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS + 1);}
	#if M_BLOCKS_F > 1
		threads[COST_THREADS + 2] = std::thread(&memcpyArr<T>, std::ref(ds), std::ref(ds[*alphaIndex]), ld_d*KNOT_POINTS*sizeof(T), NUM_ALPHA, *alphaIndex);
		if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS + 2);}
	#endif
	// meanwhile on the main thread compute the middle via Julia fixed point
   	for(int k = 0; k < KNOT_POINTS-1; k++){
        if(SIN_COS_IN_FIXED){dynamicsGradJulia_middle2<T>(&cdq[k*NUM_POS*NUM_POS],&cdqd[k*NUM_POS*NUM_POS],&xs[*alphaIndex][k*ld_x],&v[k*6*NUM_POS],&a[k*6*NUM_POS],&f[k*6*NUM_POS]);}
        else{dynamicsGradJulia_middle<T>(&cdq[k*NUM_POS*NUM_POS],&cdqd[k*NUM_POS*NUM_POS],&xs[*alphaIndex][k*ld_x],&v[k*6*NUM_POS],&a[k*6*NUM_POS],&f[k*6*NUM_POS]);}
   	}
    // synch on threads
    for (unsigned int thread_i = 0; thread_i < COST_THREADS + 2; thread_i++){threads[thread_i].join();}
	#if M_BLOCKS_F > 1
        threads[COST_THREADS + 2].join();
    #endif
   	// then launch the gradient finishing step
	desc.dim = INTEGRATOR_THREADS;
	for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){
		desc.tid = thread_i;    desc.reps = compute_reps(thread_i,INTEGRATOR_THREADS,(KNOT_POINTS-1));
		threads[thread_i] = std::thread(&integratorGradientThreaded_finish<T>, desc, std::ref(Minvs[*alphaIndex]), std::ref(cdq), std::ref(cdqd), std::ref(AB), ld_AB, dt);
		if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS + thread_i);}
	}
	// meanwhile copy P,p into Pp,pp
    std::memcpy(Pp,P,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));            	 std::memcpy(pp,p,ld_p*KNOT_POINTS*sizeof(T));
    // these can finish during the backpass before the forward pass (but we sync here because fast and more straightforward)
    std::memcpy(xp,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T));          std::memcpy(up,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T));
    std::memcpy(qddp,qdds[*alphaIndex],NUM_POS*KNOT_POINTS*sizeof(T));   std::memcpy(Minvp,Minvs[*alphaIndex],NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
    // synch on threads
    for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}
}

template <typename T, int KNOT_POINTS, bool MPC_MODE = false, bool SIN_COS_IN_FIXED = false>
void nextIterationSetupJulia_fused(T **xs, T *xp, T **us, T *up, T **ds, T *dp, T **qdds, T *qddp, T **Minvs, T *Minvp, T *AB, T *H, T *g, T *P, T *p, T *Pp, T *pp, \
                            	   T *xGoal, std::thread *threads, int *alphaIndex, int ld_x, int ld_u, int ld_d, int ld_AB, int ld_H, int ld_g, int ld_P, int ld_p, \
                           		   T *I, T *Tbody, T *cdq, T *cdqd, T dt,
                           		   T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q1, T Q2, T R, T QF1, T QF2, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
    // launch the cost gradient
    threadDesc_t desc; desc.dim = COST_THREADS;
    for (unsigned int thread_i = 0; thread_i < COST_THREADS; thread_i++){
        desc.tid = thread_i;    desc.reps = compute_reps(thread_i,COST_THREADS,KNOT_POINTS);
        threads[thread_i] = std::thread(&costGradientHessianThreaded<T,KNOT_POINTS>, desc, std::ref(xs[*alphaIndex]), std::ref(us[*alphaIndex]), std::ref(g), std::ref(H), std::ref(xGoal), ld_x, ld_u, ld_H, ld_g,\
                                                                         				  Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,nullptr,nullptr);
       
        if(FORCE_CORE_SWITCHES){setCPUForThread(threads,thread_i);}
    }
 	// and launch the copy x,u,d to all x,u,d
 	threads[COST_THREADS] = std::thread(&memcpyArr<T>, std::ref(xs), std::ref(xs[*alphaIndex]), ld_x*KNOT_POINTS*sizeof(T), NUM_ALPHA, *alphaIndex);
 	if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS);}
 	threads[COST_THREADS + 1] = std::thread(&memcpyArr<T>, std::ref(us), std::ref(us[*alphaIndex]), ld_u*KNOT_POINTS*sizeof(T), NUM_ALPHA, *alphaIndex);
 	if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS + 1);}
	#if M_BLOCKS_F > 1
		threads[COST_THREADS + 2] = std::thread(&memcpyArr<T>, std::ref(ds), std::ref(ds[*alphaIndex]), ld_d*KNOT_POINTS*sizeof(T), NUM_ALPHA, *alphaIndex);
		if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS + 2);}
	#endif
	// meanwhile on the main thread compute the first half of dynamics grad via Julia fixed point
   	for(int k = 0; k < KNOT_POINTS-1; k++){
   		if(SIN_COS_IN_FIXED){dynamicsGradJulia_1stHalf2<T>(&cdq[k*NUM_POS*NUM_POS],&cdqd[k*NUM_POS*NUM_POS],&xs[*alphaIndex][k*ld_x],&qdds[*alphaIndex][k*NUM_POS]);}
        else{dynamicsGradJulia_1stHalf<T>(&cdq[k*NUM_POS*NUM_POS],&cdqd[k*NUM_POS*NUM_POS],&xs[*alphaIndex][k*ld_x],&qdds[*alphaIndex][k*NUM_POS]);}
   	}
    // synch on threads
    for (unsigned int thread_i = 0; thread_i < COST_THREADS + 2; thread_i++){threads[thread_i].join();}
	#if M_BLOCKS_F > 1
        threads[COST_THREADS + 2].join();
    #endif
   	// then launch the gradient finishing step
	desc.dim = INTEGRATOR_THREADS;
	for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){
		desc.tid = thread_i;    desc.reps = compute_reps(thread_i,INTEGRATOR_THREADS,(KNOT_POINTS-1));
		threads[thread_i] = std::thread(&integratorGradientThreaded_finish<T>, desc, std::ref(Minvs[*alphaIndex]), std::ref(cdq), std::ref(cdqd), std::ref(AB), ld_AB, dt);
		if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS + thread_i);}
	}
	// meanwhile copy P,p into Pp,pp
    std::memcpy(Pp,P,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));            	 std::memcpy(pp,p,ld_p*KNOT_POINTS*sizeof(T));
    // these can finish during the backpass before the forward pass (but we sync here because fast and more straightforward)
    std::memcpy(xp,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T));          std::memcpy(up,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T));
    std::memcpy(qddp,qdds[*alphaIndex],NUM_POS*KNOT_POINTS*sizeof(T));   std::memcpy(Minvp,Minvs[*alphaIndex],NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
    // synch on threads
    for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}
}

template <typename T, int KNOT_POINTS, int MAX_ITERS, bool IGNORE_MAX_ROX_EXIT>
void runiLQR_Julia(T *x0, T *u0, T *KT0, T *P0, T *p0, T *d0, T *xGoal, T *Jout, int *alphaOut, 
				 int forwardRolloutFlag, int clearVarsFlag, int ignoreFirstDefectFlag,
				 double *tTime, double *simTime, double *sweepTime, double *bpTime, double *nisTime, double *initTime,
				 T **xs, T *xp, T *xp2, T **us, T *up, T **qdds, T *qddp, T **Minvs, T *Minvp, T *P, T *p, T *Pp, T *pp, 
				 T *AB, T *H, T *g, T *KT, T *du, T **ds, T *d, T *dp, 
				 T *ApBK, T *Bdu, T *alphas, T **JTs, T *dJexp,  int *err,
				 int ld_x, int ld_u, int ld_P, int ld_p, int ld_AB, int ld_H, int ld_g, int ld_KT, int ld_du, int ld_d, int ld_A,
				 T *v, T *a, T *f, T *Tfinal, T *cdq, T *cdqd, T *I, T *Tbody, bool USE_FUSED_DYN, bool SIN_COS_IN_FIXED,
				 T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q1, T Q2, T R, T QF1, T QF2, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
				 // CostParams<T> *params, T *xNom = nullptr){
	// INITIALIZE THE ALGORITHM //
		struct timeval start, end, start2, end2; gettimeofday(&start,NULL);	gettimeofday(&start2,NULL);
		T prevJ, dJ, J, z, maxd = 0; int iter = 1; T dt = static_cast<T>(TOTAL_TIME/(KNOT_POINTS-1));
		T rho = RHO_INIT; T drho = 1.0; int alphaIndex = 0; T tol_cost = 0;
		const int N_BLOCKS_B = KNOT_POINTS/M_BLOCKS_B; const int N_BLOCKS_F = KNOT_POINTS/M_BLOCKS_F;

		// define array for general threads
		std::thread threads[MAX_CPU_THREADS];
		// load in vars and init the alg
		loadVarsCPU<T,KNOT_POINTS>(xs[0],xp,x0,us[0],up,u0,qdds[0],P,Pp,P0,p,pp,p0,KT,KT0,du,d,d0,AB,err,clearVarsFlag,forwardRolloutFlag,
					   alphas,I,Tbody,xGoal,JTs[0],threads,ld_x,ld_u,ld_P,ld_p,ld_KT,ld_du,ld_d,ld_AB);
		initAlgCPU<T,KNOT_POINTS,false>(xs,xp,xp2,us,up,AB,H,g,KT,du,ds,d,JTs[0],Jout,&prevJ,alphas,alphaOut,xGoal,threads,
					  forwardRolloutFlag,ld_x,ld_u,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,I,Tbody,dt,tol_cost,
					  Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
					  // params,xNom);
		gettimeofday(&end2,NULL);
		*initTime = time_delta_ms(start2,end2);
	// INITIALIZE THE ALGORITHM //

	// debug print -- so ready to start
	if (DEBUG_SWITCH){
		printf("Iter[0] Xf[%.4f, %.4f] Cost[%.4f] AlphaIndex[%d] Rho[%f]\n",
					xs[alphaIndex][ld_x*(KNOT_POINTS-1)],xs[alphaIndex][ld_x*(KNOT_POINTS-1)+1],prevJ,alphaIndex,rho);
	}
	while(1){

		// BACKWARD PASS //
			gettimeofday(&start2,NULL);
			backwardPassCPU<T,KNOT_POINTS,N_BLOCKS_B,N_BLOCKS_F,IGNORE_MAX_ROX_EXIT>(AB,P,p,Pp,pp,H,g,KT,du,ds[alphaIndex],dp,ApBK,Bdu,xs[alphaIndex],xp2,
																dJexp,err,&rho,&drho,threads,ld_AB,ld_P,ld_p,ld_H,ld_g,ld_KT,ld_du,ld_A,ld_d,ld_x);
			gettimeofday(&end2,NULL);
			bpTime[iter-1] = time_delta_ms(start2,end2);
		// BACKWARD PASS //

		// FORWARD PASS //
			dJ = -1.0;	alphaIndex = 0;	sweepTime[iter-1] = 0.0;	simTime[iter-1] = 0.0;
			while(1){
				// FORWARD SWEEP //
					gettimeofday(&start2,NULL);
					// Do the forward sweep if applicable
					if (M_BLOCKS_F > 1){forwardSweep<T,KNOT_POINTS,N_BLOCKS_F>(xs, ApBK, Bdu, ds, xp, alphas, alphaIndex, threads, ld_x, ld_d, ld_A);}
					gettimeofday(&end2,NULL);
					sweepTime[iter-1] += time_delta_ms(start2,end2);
				// FORWARD SWEEP //

				// FORWARD SIM //
					gettimeofday(&start2,NULL);
					int alphaIndexOut = forwardSimCPU<T,KNOT_POINTS,N_BLOCKS_F,false>(xs,xp,xp2,us,up,qdds,Minvs,KT,du,ds,dp,dJexp,JTs,alphas,alphaIndex,xGoal,
		    								              &J,&dJ,&z,prevJ,&ignoreFirstDefectFlag,&maxd,threads,
		    								    		  ld_x,ld_u,ld_KT,ld_du,ld_d,I,Tbody,dt,
		    								    		  Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
					gettimeofday(&end2,NULL);	
					simTime[iter-1] += time_delta_ms(start2,end2);
					if(alphaIndexOut == -1){ // failed
						if (alphaIndex < NUM_ALPHA - FSIM_ALPHA_THREADS){alphaIndex += FSIM_ALPHA_THREADS; continue;} // keep searching
						else{alphaIndex = -1; break;} // note failure
					} 
					else{alphaIndex = alphaIndexOut; break;} // save success
				// FORWARD SIM //
			}
		// FORWARD PASS //

		// NEXT ITERATION SETUP //
			gettimeofday(&start2,NULL);    
			// process accept or reject of traj and test for exit
			if (acceptRejectTrajCPU<T,KNOT_POINTS,IGNORE_MAX_ROX_EXIT,false>(xs,xp,us,up,ds,dp,qdds,qddp,Minvs,Minvp,J,&prevJ,&dJ,&rho,&drho,&alphaIndex,
														 alphaOut,Jout,&iter,threads,ld_x,ld_u,ld_d,MAX_ITERS,tol_cost,0.0,start,end)){
				gettimeofday(&end2,NULL);
				nisTime[iter-1] = time_delta_ms(start2,end2); break;
			}
			// if we have gotten here then prep for next pass
			if(USE_FUSED_DYN){
                if(SIN_COS_IN_FIXED){
                    nextIterationSetupJulia_fused<T,KNOT_POINTS,false,true>(xs,xp,us,up,ds,dp,qdds,qddp,Minvs,Minvp,AB,H,g,P,p,Pp,pp,xGoal,threads,&alphaIndex,
                                         ld_x,ld_u,ld_d,ld_AB,ld_H,ld_g,ld_P,ld_p,I,Tbody,cdq,cdqd,dt,
                                         Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
                }
                else{
                    nextIterationSetupJulia_fused<T,KNOT_POINTS,false,false>(xs,xp,us,up,ds,dp,qdds,qddp,Minvs,Minvp,AB,H,g,P,p,Pp,pp,xGoal,threads,&alphaIndex,
                                         ld_x,ld_u,ld_d,ld_AB,ld_H,ld_g,ld_P,ld_p,I,Tbody,cdq,cdqd,dt,
                                         Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
                }
			}
			else{
                if(SIN_COS_IN_FIXED){
    				nextIterationSetupJulia_split<T,KNOT_POINTS,false,true>(xs,xp,us,up,ds,dp,qdds,qddp,Minvs,Minvp,AB,H,g,P,p,Pp,pp,xGoal,threads,&alphaIndex,
    												 		 ld_x,ld_u,ld_d,ld_AB,ld_H,ld_g,ld_P,ld_p,v,a,f,Tfinal,I,Tbody,cdq,cdqd,dt,
    												 		 Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
                }
                else{
                    nextIterationSetupJulia_split<T,KNOT_POINTS,false,false>(xs,xp,us,up,ds,dp,qdds,qddp,Minvs,Minvp,AB,H,g,P,p,Pp,pp,xGoal,threads,&alphaIndex,
                                                             ld_x,ld_u,ld_d,ld_AB,ld_H,ld_g,ld_P,ld_p,v,a,f,Tfinal,I,Tbody,cdq,cdqd,dt,
                                                             Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
                }

			}
			gettimeofday(&end2,NULL);
			nisTime[iter-2] = time_delta_ms(start2,end2);
		// NEXT ITERATION SETUP //

		if (DEBUG_SWITCH){
			printf("Iter[%d] Xf[%.4f, %.4f] Cost[%.4f] AlphaIndex[%d] rho[%f] dJ[%f] z[%f] max_d[%f]\n",
						iter-1,xs[alphaIndex][DIM_x_c*ld_x*(KNOT_POINTS-1)],xs[alphaIndex][DIM_x_c*ld_x*(KNOT_POINTS-1)+1],prevJ,alphaIndex,rho,dJ,z,maxd);
		}
	}

	// EXIT Handling
		if (DEBUG_SWITCH){
			printf("Exit with Iter[%d] Xf[%.4f, %.4f] Cost[%.4f] AlphaIndex[%d] rho[%f] dJ[%f] z[%f] max_d[%f]\n",
						iter,xs[alphaIndex][DIM_x_c*ld_x*(KNOT_POINTS-1)],xs[alphaIndex][DIM_x_c*ld_x*(KNOT_POINTS-1)+1],prevJ,alphaIndex,rho,dJ,z,maxd);
		}
		// Bring back the final state and control (and compute final d if needed)
		gettimeofday(&start2,NULL);
		storeVarsCPU<T,KNOT_POINTS,N_BLOCKS_F>(xs[alphaIndex],x0,us[alphaIndex],u0,threads,ld_x,ld_u,ds[alphaIndex],&maxd,ld_d);
		gettimeofday(&end2,NULL);
		gettimeofday(&end,NULL);
		*initTime += time_delta_ms(start2,end2);
		*tTime = time_delta_ms(start,end);

		printf("CPU Parallel blocks:[%d] t:[%f] with FP[%f], FS[%f], BP[%f], NIU[%f] Xf:[%.4f, %.4f] iters:[%d] cost:[%f] max_d[%f]\n",
					M_BLOCKS_B,*tTime,*simTime,*sweepTime,*bpTime,*nisTime,x0[ld_x*(KNOT_POINTS-1)],x0[ld_x*(KNOT_POINTS-1)+1],iter,prevJ,maxd);
		if (DEBUG_SWITCH){printf("\n");}
	// EXIT Handling
}

template <typename T, int KNOT_POINTS>
void allocateMemory_FPGA(T **v, T **a, T **f, T **Tfinal, T **cdq, T **cdqd){
   *v = (T *)malloc(6*NUM_POS*KNOT_POINTS*sizeof(T));
   *a = (T *)malloc(6*NUM_POS*KNOT_POINTS*sizeof(T));
   *f = (T *)malloc(6*NUM_POS*KNOT_POINTS*sizeof(T));
   *Tfinal = (T *)malloc(36*NUM_POS*KNOT_POINTS*sizeof(T));
   *cdq = (T *)malloc(NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
   *cdqd = (T *)malloc(NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
}

template <typename T>
void freeMemory_FPGA(T *v, T *a, T *f, T *Tfinal, T *cdq, T *cdqd){
   free(v); free(a); free(f); free(Tfinal); free(cdq); free(cdqd); 
}

template <typename T, int KNOT_POINTS, int MAX_ITERS, bool SIN_COS_IN_FIXED = false>
void runTests(void){
	// Cost params
	T Q1 = 0.01; T Q2 = 0.001; T R  = 0.0001; T QF1 = 1000.0; T QF2 = 1000.0;
	T Q_EE1 = 0.1; T Q_EE2 = 0.0; T R_EE = 0.00001; T QF_EE1 = 1000.0; T QF_EE2 = 0.0;
	T Q_xdEE = 0.1; T QF_xdEE = 100.0; T Q_xEE = 0.0; T QF_xEE = 0.0;

	// alg vars
	int ld_x, ld_u, ld_P, ld_p, ld_AB, ld_H, ld_g, ld_KT, ld_du, ld_d, ld_A; int *err;
	T *alpha, *P, *p, *Pp, *pp, *AB, *H, *g, *KT, *du, *xp, *xp2, *up, *qddp, *Minvp;
	T *d, *dp, *ApBK, *Bdu, *dJexp, *xGoal, *I, *Tbody;
	T **xs, **us, **qdds, **ds, **JTs, **Minvs;
	T *v, *a, *f, *Tfinal, *cdq, *cdqd;
	allocateMemory_CPU<T,KNOT_POINTS>(&xs, &xp, &xp2, &us, &up, &qdds, &qddp, &Minvs, &Minvp, &xGoal, &P, &Pp, &p, &pp, &AB, &H, &g, &KT, &du, &ds, &d, &dp, &ApBK, &Bdu, 
						   &JTs, &dJexp, &alpha, &err, &ld_x, &ld_u, &ld_P, &ld_p, &ld_AB, &ld_H, &ld_g, &ld_KT, &ld_du, &ld_d, &ld_A, &I, &Tbody);
	allocateMemory_FPGA<T,KNOT_POINTS>(&v,&a,&f,&Tfinal,&cdq,&cdqd);
    T *x0 = (T *)malloc(ld_x*KNOT_POINTS*sizeof(T));
    T *u0 = (T *)malloc(ld_u*KNOT_POINTS*sizeof(T));

    // data vars
    double *tTime = (double *)malloc(TEST_ITERS*sizeof(double)); double *initTime = (double *)malloc(TEST_ITERS*sizeof(double)); 
    size_t timeSize = TEST_ITERS*MAX_ITERS*sizeof(double); double *fsimTime = (double *)malloc(timeSize); double *fsweepTime = (double *)malloc(timeSize);
    double *bpTime = (double *)malloc(timeSize); double *nisTime = (double *)malloc(timeSize); 
    int traceSize = TEST_ITERS*(MAX_ITERS+1); T *Jout = (T *)malloc(traceSize*sizeof(T)); int *alphaOut = (int *)malloc(traceSize*sizeof(int));

    // run the tests
	printf("Would you like to test with Split[1] or Fused[2] dynamicsGradient\n");
	int test = getInt<'q'>(2, 1); if(test == -1){return;} bool dynFlag = false; if(test == 2){dynFlag = true;}
    printf("Would you like to compute sin/cos on the CPU [1] or FPGA [2]\n");
    int test2 = getInt<'q'>(2, 1); if(test2 == -1){return;} bool sinCosFlag = false; if(test2 == 2){sinCosFlag = true;}
    for (int i=0; i < TEST_ITERS; i++){
		loadXU<T,KNOT_POINTS,NUM_POS,false>(x0,u0,ld_x,ld_u);
		loadSingleGoal<T,EE_COST>(xGoal);
      	printf("<<<TESTING CPU-Julia-Split %d/%d>>>\n",i+1,TEST_ITERS);
	    runiLQR_Julia<T,KNOT_POINTS,MAX_ITERS,1>(x0, u0, nullptr, nullptr, nullptr, nullptr, xGoal, &Jout[i*(MAX_ITERS+1)], &alphaOut[i*(MAX_ITERS+1)], 0, 1, 1,
    											&tTime[i], &fsimTime[i*MAX_ITERS], &fsweepTime[i*MAX_ITERS], &bpTime[i*MAX_ITERS], &nisTime[i*MAX_ITERS], &initTime[i], 
												xs, xp, xp2, us, up, qdds, qddp, Minvs, Minvp, P, p, Pp, pp, AB, H, g, KT, du, ds, d, dp, ApBK, Bdu, alpha, JTs, dJexp, err,
												ld_x, ld_u, ld_P, ld_p, ld_AB, ld_H, ld_g, ld_KT, ld_du, ld_d, ld_A, v, a, f, Tfinal, cdq, cdqd, I, Tbody, dynFlag, sinCosFlag,
												Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE);
  	}
  	// free alg vars (but not x0,u0)
  	freeMemory_FPGA(v,a,f,Tfinal,cdq,cdqd);
	freeMemory_CPU<T>(xs, xp, xp2, us, up, qdds, qddp, Minvs, Minvp, P, Pp, p, pp, AB, H, g, KT, du, ds, d, dp, Bdu, ApBK, dJexp, err, alpha, JTs, xGoal, I, Tbody);
	
	// print final state and stats
	printf("Final state:\n");	for (int i = 0; i < STATE_SIZE; i++){printf("%15.5f ",x0[(KNOT_POINTS-2)*ld_x + i]);}	printf("\n");			
   	printJAlphaStats<T,TEST_ITERS,MAX_ITERS>(Jout,alphaOut);
   	printAllTimingStats<TEST_ITERS,MAX_ITERS>(tTime,initTime,fsimTime,fsweepTime,bpTime,nisTime);

   	// free data vars (and x0,u0)
	free(x0); free(u0); free(Jout); free(alphaOut); free(tTime); free(initTime); free(fsimTime); free(fsweepTime); free(bpTime); free(nisTime);
}

int main(int argc, char *argv[])
{
	srand(time(NULL));
	initialize_julia();
	runTests<algType,GLOBAL_KNOT_POINTS,GLOBAL_MAX_ITER>();
	close_julia();
	return 0;
}