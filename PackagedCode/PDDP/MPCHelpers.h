template <typename T>
struct algTrace{
    std::vector<T> J;             std::vector<int> alpha;
    std::vector<double> tTime;    std::vector<double> simTime;    std::vector<double> sweepTime;
    std::vector<double> initTime; std::vector<double> bpTime;     std::vector<double> nisTime;
};

template <typename T, int KNOT_POINTS, int TRAJ_RUNNER_TIME_STEPS, bool USE_FEEDBACK_IN_TRAJ_RUNNER = true, bool PD_GAINS_ON_STATE = false>
int getHardwareControls(double *q_out, double *u_out, T *x, T *u, T *KT, double t0, double tActual, const double *qActual, const double *qdActual, int ld_x, int ld_u, int ld_KT){
    // compute index in current traj we want to use (both round down for zoh and fraction for foh)
    double dt = get_time_steps_us_d<KNOT_POINTS>(t0,tActual); int ind_rd = static_cast<int>(dt); double fraction = dt - static_cast<double>(ind_rd);
    // see if beyond bounds and fail
    if (ind_rd >= TRAJ_RUNNER_TIME_STEPS-2 || ind_rd < 0){return 1;} 
    T dx[STATE_SIZE]; T *uk = &u[ind_rd*ld_u]; // u,KT do zoh so take rd
    if(USE_FEEDBACK_IN_TRAJ_RUNNER){
        T *KTk = &KT[ind_rd*ld_KT*DIM_KT_c]; // u,KT do zoh so take rd
        T *xk_u = &x[(ind_rd+1)*ld_x];       T *xk_d = &x[ind_rd*ld_x]; // foh for xk
        // then compute the state delta (using the foh)
        for (int ind = 0; ind < STATE_SIZE; ind++){
            T val = (static_cast<T>(1.0-fraction)*xk_d[ind] + static_cast<T>(fraction)*xk_u[ind]);
            dx[ind] = static_cast<T>(ind < NUM_POS ? qActual[ind] : qdActual[ind-NUM_POS]) - val;
            if(PD_GAINS_ON_STATE && ind < NUM_POS){q_out[ind] = static_cast<double>(val);}
        }
        // and formulate the control from that delta (using the zoh u and K)
        for (int r = 0; r < CONTROL_SIZE; r++){T val = uk[r];
            #pragma unroll
            for (int c = 0; c < STATE_SIZE; c++){val -= KTk[c + r*ld_KT]*dx[c];}
            u_out[r] = static_cast<double>(val);
        }
    }
    // else just use the u directly
    else{for (int i = 0; i < CONTROL_SIZE; i++){u_out[i] = uk[i];}}

    // always return the measured state if pd gains on state are 0
    if(!PD_GAINS_ON_STATE){for (int i = 0; i < NUM_POS; i++){q_out[i] = qActual[i];}}
    return 0;
}

// float TEST_ARRAY[] = {1,2,3,4};
// shiftLeft<float>(TEST_ARRAY,2,4);
// printMat<float,1,4>(TEST_ARRAY,1);
template <typename T>
void shiftLeft(T *A, int shiftAmount, int arrLength){std::memmove(&A[0],&A[shiftAmount],(arrLength-shiftAmount)*sizeof(T));}

template <typename T>
void shiftLeftZoh(T *A, int shiftAmount, int arrLength){
	shiftLeft<T>(A,shiftAmount,arrLength); T endVal = A[arrLength-shiftAmount-1];
	for(int i = arrLength-shiftAmount; i < arrLength; i++){A[i] = endVal;}
}

// float TEST_ARRAY[] = {1,2,3,4,-1,-2,-3,-4,0,0,0,0,6,7,8,9};
// printMat<float,4,4>(TEST_ARRAY,4);
// shiftLeftZoh<float>(TEST_ARRAY,2,4,4);
// printMat<float,4,4>(TEST_ARRAY,4);
template <typename T>
void shiftLeftZoh(T *A, int shiftAmount, int arrLength, int matSize){
	shiftLeft<T>(A,shiftAmount*matSize,arrLength*matSize); T *endVals = &A[(arrLength-shiftAmount-1)*matSize];
	for(int k = arrLength-shiftAmount; k < arrLength; k++){
		for(int i = 0; i < matSize; i++){A[k*matSize + i] = endVals[i];}
	}
}

template <typename T>
T maxElementInArr(T *A, int arrLength, int matSize){
	T *ptr = std::max_element(&A[0],&A[arrLength*matSize]);
	return *ptr;
}

template <typename T, int KNOT_POINTS, bool MPC_MODE = false>
void forwardRolloutMPC(T *x, T *u, T *qdd, T *Minv, T *KT, T *xp, T *I, T *xActual, int ld_x, int ld_u, int ld_KT, T dt){
	T s_dx[STATE_SIZE]; T s_Tb4[16*NUM_POS];
	T *xk = &x[0]; T *xkp1 = xk + ld_x; T *xpk = &xp[0];
	T *uk = &u[0]; T *qddk = &qdd[0]; T *Minvk = &Minv[0]; T *KTk = &KT[0];
	// load in the initial state
	for (int ind = 0; ind < STATE_SIZE; ind++){xk[ind] = xActual[ind];}
	// then loop forward integrating
	for(int k = 0; k < KNOT_POINTS-1; k++){
		// compute the new simple control: u = u - K(xnew-x) -- but note we have KT not K
		#pragma unroll
		for (int ind = 0; ind < STATE_SIZE; ind++){s_dx[ind] = xk[ind]-xpk[ind];}
		#pragma unroll
		for (int r = 0; r < CONTROL_SIZE; r++){
			T Kdx = 0;
			#pragma unroll
			for (int c = 0; c < STATE_SIZE; c++){Kdx += KTk[c + r*ld_KT]*s_dx[c];}
			uk[r] -= Kdx;
		}
		// integrate xkp1 = xk + dt*[qdk;qddk] by first computing the qddk
		forwardDynamics4x4<T,MPC_MODE>(qddk, uk, &xk[NUM_POS], xk, I, s_Tb4, Minvk);
        // then apply euler rule
	    for (int ind = 0; ind < NUM_POS; ind++){
	        xkp1[ind] 			= xk[ind] 			+ dt*xk[ind+NUM_POS];
	        xkp1[ind+NUM_POS] 	= xk[ind+NUM_POS] 	+ dt*qddk[ind];
	    }
		// update the offsets for the next pass
		xk = xkp1; xkp1 += ld_x; xpk += ld_x; uk += ld_u; 
		qddk += NUM_POS; Minvk += NUM_POS*NUM_POS; KTk += ld_KT*DIM_KT_c;
	}
}

template <typename T, int KNOT_POINTS, bool DO_SHIFT_ROLLOUT = true, bool MPC_MODE = false>
void loadAndInitEE_MPC(T **xs, T **us, T **ds, T **qdds, T **Minvs, T **JTs, T *xp, T *up, T *KT, T *P, T *p, T *Pp, T *pp, T *AB, T *H, T *g, T *I,
					   T *xGoal, T *xActual, std::thread *threads, T *prevJ, T *Jout, int alphaIndex, int shiftAmount, T *x_old, T *u_old, T *KT_old, \
					   int ld_x, int ld_u, int ld_d, int ld_KT, int ld_P, int ld_p, int ld_AB, int ld_H, int ld_g, T dt, T tol_cost, \
					   T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
	if (DO_SHIFT_ROLLOUT && shiftAmount > 0){
		// Shift left x,u,KT (and save shifted x to xp for rollout)
	    shiftLeftZoh<T>(xs[alphaIndex],shiftAmount,KNOT_POINTS,ld_x); std::memcpy(xp,xs[alphaIndex],ld_x*KNOT_POINTS*sizeof(T));
	    shiftLeftZoh<T>(us[alphaIndex],shiftAmount,KNOT_POINTS-1,ld_u);
	    shiftLeftZoh<T>(KT,shiftAmount,KNOT_POINTS-1,ld_KT*DIM_KT_c);
	    for(int i = 0; i < INTEGRATOR_THREADS; i++){JTs[alphaIndex][i] = static_cast<T>(0);} *prevJ = 0;
	    // then launch the rollout in another thread and do the rest of the shift copies (P,p -> Pp, pp)
	    threads[0] = std::thread(&forwardRolloutMPC<T,KNOT_POINTS,MPC_MODE>, std::ref(xs[alphaIndex]), std::ref(us[alphaIndex]), std::ref(qdds[alphaIndex]), 
	    												std::ref(Minvs[alphaIndex]), std::ref(KT), std::ref(xp), std::ref(I), std::ref(xActual), ld_x, ld_u, ld_KT, dt);
	    if(FORCE_CORE_SWITCHES){setCPUForThread(threads, 0);}
	    shiftLeftZoh<T>(P,shiftAmount,KNOT_POINTS); std::memcpy(Pp,P,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));
	    shiftLeftZoh<T>(p,shiftAmount,KNOT_POINTS); std::memcpy(pp,p,ld_p*KNOT_POINTS*sizeof(T));
	    // join the rollout thread
	    threads[0].join();
	}
    // in either case compute derivatives for next pass(AB,H,g) in threads
    threadDesc_t desc;  desc.dim = INTEGRATOR_THREADS;
    for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){
        desc.tid = thread_i;    desc.reps = compute_reps(thread_i,INTEGRATOR_THREADS,(KNOT_POINTS-1));
        threads[thread_i] = std::thread(&integratorCostEEGradientThreaded<T,KNOT_POINTS,1,!DO_SHIFT_ROLLOUT,MPC_MODE>, desc, std::ref(xs[alphaIndex]), std::ref(us[alphaIndex]), std::ref(qdds[alphaIndex]), \
                                                                                  std::ref(Minvs[alphaIndex]), std::ref(AB), std::ref(H), std::ref(g), std::ref(I), std::ref(xGoal), \
                                                                                  ld_x, ld_u, ld_AB, ld_H, ld_g,dt,
                                                                                  Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,std::ref(xNom),std::ref(JTs[alphaIndex]));

        if(FORCE_CORE_SWITCHES){setCPUForThread(threads, thread_i);}
    }
    // while doing this copy the new x,u into all xs (and xp,up) and set ds = 0
    memcpyArr<T>(xs,xs[alphaIndex],ld_x*KNOT_POINTS*sizeof(T),NUM_ALPHA,alphaIndex);
    memcpyArr<T>(us,us[alphaIndex],ld_u*KNOT_POINTS*sizeof(T),NUM_ALPHA,alphaIndex);
    for(int i = 0; i < NUM_ALPHA; i++){memset(ds[i], 0, ld_d*KNOT_POINTS*sizeof(T));}
    std::memcpy(xp,xs[alphaIndex],ld_x*KNOT_POINTS*sizeof(T));
	std::memcpy(up,us[alphaIndex],ld_u*KNOT_POINTS*sizeof(T));
    // also copy into x,u,KT olds in case all iters fail
    std::memcpy(x_old,xs[alphaIndex],ld_x*KNOT_POINTS*sizeof(T));
	std::memcpy(u_old,us[alphaIndex],ld_u*KNOT_POINTS*sizeof(T));
	std::memcpy(KT_old,KT,ld_KT*DIM_KT_c*KNOT_POINTS*sizeof(T));
	// compute final state cost and costGrad
	T s_eePos[6]; T s_deePos[6*NUM_POS]; T s_tempMem[34*NUM_POS]; T s_dtempMem[49*NUM_POS];
  	T *xk = &xs[alphaIndex][(KNOT_POINTS-1)*ld_x]; T *uk = &us[alphaIndex][(KNOT_POINTS-1)*ld_u]; 
  	T *Hk = &H[(KNOT_POINTS-1)*ld_H*DIM_H_c]; T *gk = &g[(KNOT_POINTS-1)*ld_g];
	computedEEPos4x4_scratch<T>(s_eePos,xk,s_tempMem,s_deePos,s_dtempMem); *prevJ = static_cast<T>(0);
	costGrad<T,KNOT_POINTS>(Hk,gk,s_eePos,s_deePos,xGoal,xk,uk,(KNOT_POINTS-1),ld_H,Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom,prevJ,0);
	// finally sync threads and finsh off that cost
    for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join(); *prevJ += JTs[alphaIndex][thread_i];}
    Jout[0] = *prevJ;   *prevJ *= (1 + 2*tol_cost); // we are doing % change now so need to account for that
}

template <typename T, int KNOT_POINTS, bool DO_SHIFT_ROLLOUT = true>
void storeVars_MPC(T **xs, T *x0, T *x_old, T **us, T *u0, T *u_old, T *KT, T *KT0, T *KT_old, int *alphaIndex, \
				   int ld_x, int ld_u, int ld_KT, double *tPlant, double *tPlant_prev, bool success){
    // prev time is current time and save out all new trajectories (if success else just shifted old ones)
    tPlant_prev = tPlant;
    if (success){
    	std::memcpy(x0,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T));
    	std::memcpy(u0,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T));
    	std::memcpy(KT0,KT,ld_KT*DIM_KT_c*KNOT_POINTS*sizeof(T));
    }
    else{
    	std::memcpy(x0,x_old,ld_x*KNOT_POINTS*sizeof(T));
    	std::memcpy(u0,u_old,ld_u*KNOT_POINTS*sizeof(T));
    	std::memcpy(KT0,KT_old,ld_KT*DIM_KT_c*KNOT_POINTS*sizeof(T));
    	if(!DO_SHIFT_ROLLOUT){ // if we are just initializing things and fail we need to also save into alpha 0
    		std::memcpy(xs[*alphaIndex],x_old,ld_x*KNOT_POINTS*sizeof(T));
	    	std::memcpy(us[*alphaIndex],u_old,ld_u*KNOT_POINTS*sizeof(T));
	    	std::memcpy(KT,KT_old,ld_KT*DIM_KT_c*KNOT_POINTS*sizeof(T));
	    	*alphaIndex = 0;
    	}
    }
}

#if COMPILE_WITH_GPU && COMPILE_WITH_FPGA
	template <typename T, int KNOT_POINTS, bool DO_SHIFT_ROLLOUT = true, bool USE_MAX_SOLVER_TIME = false, bool USE_ALG_TRACE = true, bool IGNORE_MAX_ROX_EXIT = false>
	void runiLQR_MPC(T *x0, T *u0, T *KT0, T *xGoal, T *xActual, double *tPlant, double *tPlant_prev, double maxTime, int maxIter, algTrace<T> *atrace, \
					 T **xs, T *xp, T *xp2, T *x_old, T **us, T *up, T *u_old, T **qdds, T *qddp, T **Minvs, T *Minvp, T *P, T *p, T *Pp, T *pp, T *AB, T *H, T *g, \
					 T *KT, T *KT_old, T *du, T **ds, T *d, T *dp, T *ApBK, T *Bdu, T *alphas, int *alphaIndex, T *I, T *Tbody, T **JTs, T *dJexp,  int *err, \
					 int ld_x, int ld_u, int ld_P, int ld_p, int ld_AB, int ld_H, int ld_g, int ld_KT, int ld_du, int ld_d, int ld_A, char hardware, int dynType, \
					 T *v, T *a, T *f, T *Tfinal, T *cdq, T *cdqd, \
					 cudaStream_t *streams, T*d_x, T *d_qdd, T *d_Minv, T *d_AB, T *d_v, T *d_a, T *d_f, T *d_I, T *d_Tbody, T *d_Tfinal, T *d_cdq, T *d_cdqd,
					 FPGADataIn_v1<KNOT_POINTS,NUM_POS> *dataIn1, FPGADataIn_v2<KNOT_POINTS,NUM_POS> *dataIn2, FPGADataOut<KNOT_POINTS,NUM_POS> *dataOut, 
					 unsigned int fpgaIn1, unsigned int fpgaIn2, unsigned int fpgaOut,
					 T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
#elif COMPILE_WITH_GPU
	template <typename T, int KNOT_POINTS, bool DO_SHIFT_ROLLOUT = true, bool USE_MAX_SOLVER_TIME = false, bool USE_ALG_TRACE = true, bool IGNORE_MAX_ROX_EXIT = false>
	void runiLQR_MPC(T *x0, T *u0, T *KT0, T *xGoal, T *xActual, double *tPlant, double *tPlant_prev, double maxTime, int maxIter, algTrace<T> *atrace, \
					 T **xs, T *xp, T *xp2, T *x_old, T **us, T *up, T *u_old, T **qdds, T *qddp, T **Minvs, T *Minvp, T *P, T *p, T *Pp, T *pp, T *AB, T *H, T *g, \
					 T *KT, T *KT_old, T *du, T **ds, T *d, T *dp, T *ApBK, T *Bdu, T *alphas, int *alphaIndex, T *I, T *Tbody, T **JTs, T *dJexp,  int *err, \
					 int ld_x, int ld_u, int ld_P, int ld_p, int ld_AB, int ld_H, int ld_g, int ld_KT, int ld_du, int ld_d, int ld_A, char hardware, int dynType, \
					 T *v, T *a, T *f, T *Tfinal, T *cdq, T *cdqd, \
					 cudaStream_t *streams, T*d_x, T *d_qdd, T *d_Minv, T *d_AB, T *d_v, T *d_a, T *d_f, T *d_I, T *d_Tbody, T *d_Tfinal, T *d_cdq, T *d_cdqd,
					 T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
#elif COMPILE_WITH_FPGA
	template <typename T, int KNOT_POINTS, bool DO_SHIFT_ROLLOUT = true, bool USE_MAX_SOLVER_TIME = false, bool USE_ALG_TRACE = true, bool IGNORE_MAX_ROX_EXIT = false>
	void runiLQR_MPC(T *x0, T *u0, T *KT0, T *xGoal, T *xActual, double *tPlant, double *tPlant_prev, double maxTime, int maxIter, algTrace<T> *atrace, \
					 T **xs, T *xp, T *xp2, T *x_old, T **us, T *up, T *u_old, T **qdds, T *qddp, T **Minvs, T *Minvp, T *P, T *p, T *Pp, T *pp, T *AB, T *H, T *g, \
					 T *KT, T *KT_old, T *du, T **ds, T *d, T *dp, T *ApBK, T *Bdu, T *alphas, int *alphaIndex, T *I, T *Tbody, T **JTs, T *dJexp,  int *err, \
					 int ld_x, int ld_u, int ld_P, int ld_p, int ld_AB, int ld_H, int ld_g, int ld_KT, int ld_du, int ld_d, int ld_A, char hardware, int dynType, \
					 T *v, T *a, T *f, T *Tfinal, T *cdq, T *cdqd, \
					 FPGADataIn_v1<KNOT_POINTS,NUM_POS> *dataIn1, FPGADataIn_v2<KNOT_POINTS,NUM_POS> *dataIn2, FPGADataOut<KNOT_POINTS,NUM_POS> *dataOut, 
					 unsigned int fpgaIn1, unsigned int fpgaIn2, unsigned int fpgaOut,
					 T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
#else
	template <typename T, int KNOT_POINTS, bool DO_SHIFT_ROLLOUT = true, bool USE_MAX_SOLVER_TIME = false, bool USE_ALG_TRACE = true, bool IGNORE_MAX_ROX_EXIT = false>
	void runiLQR_MPC(T *x0, T *u0, T *KT0, T *xGoal, T *xActual, double *tPlant, double *tPlant_prev, double maxTime, int maxIter, algTrace<T> *atrace, \
					 T **xs, T *xp, T *xp2, T *x_old, T **us, T *up, T *u_old, T **qdds, T *qddp, T **Minvs, T *Minvp, T *P, T *p, T *Pp, T *pp, T *AB, T *H, T *g, \
					 T *KT, T *KT_old, T *du, T **ds, T *d, T *dp, T *ApBK, T *Bdu, T *alphas, int *alphaIndex, T *I, T *Tbody, T **JTs, T *dJexp,  int *err, \
					 int ld_x, int ld_u, int ld_P, int ld_p, int ld_AB, int ld_H, int ld_g, int ld_KT, int ld_du, int ld_d, int ld_A, char hardware, int dynType, \
					 T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
#endif
	// INITIALIZE THE ALGORITHM //
		struct timeval start, end, start2, end2; if(USE_ALG_TRACE){gettimeofday(&start,NULL); gettimeofday(&start2,NULL);}
		T prevJ, dJ, J, z, maxd = 0; int iter = 1; int ignoreFirstDefectFlag = 1; bool success = false;
		T rho = RHO_INIT; T drho = 1.0; int shiftAmount = get_time_steps_us_f<KNOT_POINTS>(*tPlant_prev,*tPlant);
		T Jout[MAX_ITER+1]; int alphaOut[MAX_ITER+1]; T dt = static_cast<T>(TOTAL_TIME/(KNOT_POINTS-1)); T tol_cost = 0.00001;
		const int N_BLOCKS_B = KNOT_POINTS/M_BLOCKS_B; const int N_BLOCKS_F = KNOT_POINTS/M_BLOCKS_F;
		#if COMPILE_WITH_GPU
			dim3 blockDimms(NUM_POS,NUM_POS); dim3 gridDimms(KNOT_POINTS-1,1);
		#endif
		// define array for general threads
		std::thread threads[MAX_CPU_THREADS];
		// load in vars and init the alg
		loadAndInitEE_MPC<T,KNOT_POINTS,DO_SHIFT_ROLLOUT,true>(xs,us,ds,qdds,Minvs,JTs,xp,up,KT,P,p,Pp,pp,AB,H,g,I,xGoal,xActual,threads,&prevJ,Jout,
				  		     *alphaIndex,shiftAmount,x_old,u_old,KT_old,ld_x,ld_u,ld_d,ld_KT,ld_P,ld_p,ld_AB,ld_H,ld_g,dt,tol_cost,
				  		     Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
		if(USE_ALG_TRACE){gettimeofday(&end2,NULL); (atrace->initTime).push_back(time_delta_ms(start2,end2));}
	// INITIALIZE THE ALGORITHM //

	// debug print -- so ready to start
	if (DEBUG_SWITCH){
		printf("Iter[0] Xf[%.4f, %.4f] Cost[%.4f] AlphaIndex[%d] Rho[%f]\n",
					xs[*alphaIndex][ld_x*(KNOT_POINTS-1)],xs[*alphaIndex][ld_x*(KNOT_POINTS-1)+1],prevJ,*alphaIndex,rho);
	}
	while(1){
		// BACKWARD PASS //
			// if(USE_MAX_SOLVER_TIME){gettimeofday(&end,NULL); if(time_delta_ms(start,end) > maxTime){if (DEBUG_SWITCH){printf("Exiting for maxTime\n");} break;};}
			if(USE_ALG_TRACE){gettimeofday(&start2,NULL);}
			backwardPassCPU<T,KNOT_POINTS,N_BLOCKS_B,N_BLOCKS_F,IGNORE_MAX_ROX_EXIT>(AB,P,p,Pp,pp,H,g,KT,du,ds[*alphaIndex],dp,ApBK,Bdu,xs[*alphaIndex],xp2,
																	dJexp,err,&rho,&drho,threads,ld_AB,ld_P,ld_p,ld_H,ld_g,ld_KT,ld_du,ld_A,ld_d,ld_x);
			if(USE_ALG_TRACE){gettimeofday(&end2,NULL); (atrace->bpTime).push_back(time_delta_ms(start2,end2));}
		// BACKWARD PASS //

		// FORWARD PASS //
			// if(USE_MAX_SOLVER_TIME){gettimeofday(&end,NULL); if(time_delta_ms(start,end) > maxTime){if (DEBUG_SWITCH){printf("Exiting for maxTime\n");} break;};}
			dJ = -1.0; *alphaIndex = 0; (atrace->sweepTime).push_back(0); (atrace->simTime).push_back(0);
			while(1){
				// FORWARD SWEEP //
					if(USE_ALG_TRACE){gettimeofday(&start2,NULL);}
					// Do the forward sweep if applicable
					if (M_BLOCKS_F > 1){forwardSweep<T,KNOT_POINTS,N_BLOCKS_F>(xs, ApBK, Bdu, ds, xp, alphas, *alphaIndex, threads, ld_x, ld_d, ld_A);}
                    if(USE_ALG_TRACE){gettimeofday(&end2,NULL); (atrace->sweepTime).back() += time_delta_ms(start2,end2);}
				// FORWARD SWEEP //

				// FORWARD SIM //
					if(USE_ALG_TRACE){gettimeofday(&start2,NULL);}
					int alphaIndexOut = forwardSimCPU<T,KNOT_POINTS,N_BLOCKS_F,true>(xs,xp,xp2,us,up,qdds,Minvs,KT,du,ds,dp,dJexp,JTs,alphas,*alphaIndex,xGoal,
		    								             &J,&dJ,&z,prevJ,&ignoreFirstDefectFlag,&maxd,threads,
		    								    		 ld_x,ld_u,ld_KT,ld_du,ld_d,I,Tbody,dt,
		    								    		 Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,0.0,0.0,0.0,0.0,0.0,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
					if(USE_ALG_TRACE){gettimeofday(&end2,NULL); (atrace->simTime).back() += time_delta_ms(start2,end2);}
					if(alphaIndexOut == -1){ // failed
						if (*alphaIndex < NUM_ALPHA - FSIM_ALPHA_THREADS){*alphaIndex += FSIM_ALPHA_THREADS; continue;} // keep searching
						else{*alphaIndex = -1; break;} // note failure
					} 
					else{*alphaIndex = alphaIndexOut; break;} // save success
				// FORWARD SIM //
			}
		// FORWARD PASS //

		// NEXT ITERATION SETUP //
			if(USE_ALG_TRACE){gettimeofday(&start2,NULL);}
			// process accept or reject of traj and test for exit
			if (acceptRejectTrajCPU<T,KNOT_POINTS,IGNORE_MAX_ROX_EXIT,USE_MAX_SOLVER_TIME>(xs,xp,us,up,ds,dp,qdds,qddp,Minvs,Minvp,J,&prevJ,&dJ,&rho,&drho,alphaIndex,
																	   alphaOut,Jout,&iter,threads,ld_x,ld_u,ld_d,maxIter,tol_cost,maxTime,start,end)){
				if(USE_ALG_TRACE){gettimeofday(&end2,NULL); (atrace->nisTime).push_back(time_delta_ms(start2,end2));} break;
			}
			// if we have gotten here then prep for next pass and note that at least one step has succeeded
			success = true;
			if (hardware == 'C'){ // STANDARD CPU GRADIENT
				nextIterationSetupCPU_EE<T,KNOT_POINTS,true>(xs,xp,us,up,ds,dp,qdds,qddp,Minvs,Minvp,AB,H,g,P,p,Pp,pp,I,xGoal,threads,alphaIndex,
														ld_x,ld_u,ld_d,ld_AB,ld_H,ld_g,ld_P,ld_p,dt,
							 							Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
			}
			#if COMPILE_WITH_GPU
				else if (hardware == 'G' && dynType == 0){ // GPU SPLIT GRADIENT
					nextIterationSetupGPU_splitEE<T,KNOT_POINTS,1,1,true>(xs, xp, us, up, ds, dp, qdds, qddp, Minvs, Minvp, AB, H, g, P, p, Pp, pp, xGoal,
												         threads, alphaIndex, ld_x, ld_u, ld_d, ld_AB, ld_H, ld_g, ld_P, ld_p, dt,
												         streams, d_cdq, d_cdqd, d_v, d_a, d_f, d_Tfinal, d_x, d_I, v, a, f,Tfinal, I, Tbody, cdq, cdqd,
												         gridDimms, blockDimms, Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
				}
				else if (hardware == 'G' && dynType == 1){ // GPU FUSED GRADIENT
					nextIterationSetupGPU_fused<T,KNOT_POINTS,1,1,true>(xs, xp, us, up, ds, dp, qdds, qddp, Minvs, Minvp, AB, H, g, P, p, Pp, pp, xGoal,
														       threads, alphaIndex, ld_x, ld_u, ld_d, ld_AB, ld_H, ld_g, ld_P, ld_p, dt,
														   	   streams, d_x, d_qdd, d_cdq, d_cdqd, d_I, d_Tbody, cdq, cdqd, I, Tbody, gridDimms, blockDimms,
														       Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,0.0,0.0,0.0,0.0,0.0,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);

				}
			#endif
			#if COMPILE_WITH_FPGA
				else if (hardware == 'F' && dynType == 0){ // FPGA SPLIT GRADIENT
					nextIterationSetupFPGA_splitEE<T,KNOT_POINTS,1,1,true>(xs, xp, us, up, ds, dp, qdds, qddp, Minvs, Minvp, AB, H, g, P, p, Pp, pp, xGoal,
												         threads, alphaIndex, ld_x, ld_u, ld_d, ld_AB, ld_H, ld_g, ld_P, ld_p, dt,
												         v, a, f, Tfinal, I, Tbody, cdq, cdqd, dataIn1, dataOut, fpgaIn1, fpgaOut,
												         Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
				}
				else if (hardware == 'F' && dynType == 1){ // FPGA FUSED GRADIENT
					nextIterationSetupFPGA_fused<T,KNOT_POINTS,1,1,true>(xs, xp, us, up, ds, dp, qdds, qddp, Minvs, Minvp, AB, H, g, P, p, Pp, pp, xGoal,
											       threads, alphaIndex, ld_x, ld_u, ld_d, ld_AB, ld_H, ld_g, ld_P, ld_p, dt,
											   	   I, Tbody, cdq, cdqd, dataIn2, dataOut, fpgaIn2, fpgaOut,
											       Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,0.0,0.0,0.0,0.0,0.0,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
				}
			#endif
			else{printf("The chosen dynamics type was not compiled. Please check compile flags!\n");}
			if(USE_ALG_TRACE){gettimeofday(&end2,NULL);(atrace->nisTime).push_back(time_delta_ms(start2,end2));}
		// NEXT ITERATION SETUP //

		if (DEBUG_SWITCH){
			printf("Iter[%d] Xf[%.4f, %.4f] Cost[%.4f] AlphaIndex[%d] rho[%f] dJ[%f] z[%f] max_d[%f]\n",
						iter-1,xs[*alphaIndex][DIM_x_c*ld_x*(KNOT_POINTS-1)],xs[*alphaIndex][DIM_x_c*ld_x*(KNOT_POINTS-1)+1],prevJ,*alphaIndex,rho,dJ,z,maxd);
		}
	}

	// EXIT Handling
		if (DEBUG_SWITCH){
			printf("Exit with Iter[%d] Xf[%.4f, %.4f] Cost[%.4f] AlphaIndex[%d] rho[%f] dJ[%f] z[%f] max_d[%f]\n",
						iter,xs[*alphaIndex][DIM_x_c*ld_x*(KNOT_POINTS-1)],xs[*alphaIndex][DIM_x_c*ld_x*(KNOT_POINTS-1)+1],prevJ,*alphaIndex,rho,dJ,z,maxd);
		}
		// Bring back the final state and control (and compute final d if needed)
		if(USE_ALG_TRACE){gettimeofday(&start2,NULL);}
		storeVars_MPC<T,KNOT_POINTS,DO_SHIFT_ROLLOUT>(xs,x0,x_old,us,u0,u_old,KT,KT0,KT_old,alphaIndex,ld_x,ld_u,ld_KT,tPlant,tPlant_prev,success);
		if(USE_ALG_TRACE){
            for (int i=0; i <= iter; i++){(atrace->alpha).push_back(alphaOut[i]);   (atrace->J).push_back(Jout[i]);}
            gettimeofday(&end2,NULL); (atrace->initTime).back() += time_delta_ms(start2,end2);
        	gettimeofday(&end,NULL); (atrace->tTime).push_back(time_delta_ms(start,end));
        }
	// EXIT Handling
}