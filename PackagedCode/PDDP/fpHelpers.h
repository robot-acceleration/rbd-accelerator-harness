/*****************************************************************
 * DDP Forward Pass Helper Functions
 * (currently only supports iLQR - UDP in future release)
 *
 * forwardSweep
 *   forwardSweepThreaded
 * forwardSim
 *   defectComp
 *   forwardSim
 *     getFeedbackControl
 *     forwardDynamics (from dynamics)
 *     costfunc (from costs)
 *****************************************************************/

template <typename T>
void getFeedbackControl(T *u, T *x, T *xp, T *dx, T *FeedbackMatrix, int ld_fb, T *FeedforwardVector, T alpha){
	#pragma unroll
	for (int ind = 0; ind < STATE_SIZE; ind++){dx[ind] = x[ind]-xp[ind];}
	#pragma unroll
	for (int r = 0; r < CONTROL_SIZE; r++){
		// get the Kdx for this row
		T val = 0;
		#pragma unroll
		for (int c = 0; c < STATE_SIZE; c++){val += FeedbackMatrix[c + r*ld_fb]*dx[c];}
		// and then get this control with it
		u[r] -= alpha*FeedforwardVector[r] + val;
	}
}

template <typename T, int KNOT_POINTS, int N_BLOCKS_F>
T defectComp(T *d, int ld_d){
	T maxD = 0;
	#pragma unroll
	for (int i = 0; i < KNOT_POINTS; i++){
		if (onDefectBoundary<KNOT_POINTS,N_BLOCKS_F>(i)){
			T currD = 0;
			#pragma unroll
			for (int j = 0; j < DIM_d_r; j++){currD += abs(d[i*ld_d + j]);}
			if(currD > maxD){currD = maxD;}
		}
	}
	return maxD;
}

template <typename T, int KNOT_POINTS, int N_BLOCKS_F, bool MPC_MODE = false>
void forwardSim(threadDesc_t desc, T *x, T *u, T *qdd, T *Minv, T *KT, T *du, T *d, T alpha, T *xp, \
				int ld_x, int ld_u, int ld_KT, int ld_du, int ld_d, \
				T *I, T *Tbody, T *xGoal, T *JT, T dt,
				T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q1, T Q2, T R, T QF1, T QF2, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
				// CostParams<T> *params, T *xNom = nullptr){
	T s_dx[STATE_SIZE]; JT[desc.tid]= static_cast<T>(0);
	#if EE_COST
		T s_Tb4[16*NUM_POS]; T s_T4[16*NUM_POS]; T s_eePos[6];
	#endif
	// loop forward and coT mpute new states and controls
	for (unsigned int i=0; i<desc.reps; i++){int bInd = (desc.tid+i*desc.dim);
		int kStart = bInd * N_BLOCKS_F; int reps = bInd == M_BLOCKS_F - 1 ? N_BLOCKS_F - 1: N_BLOCKS_F;
		T *xk = &x[kStart*ld_x]; T *xkp1 = xk + ld_x; T *uk = &u[kStart*ld_u]; T *xpk = &xp[kStart*ld_x];
		T *qddk = &qdd[kStart*NUM_POS]; T *Minvk = &Minv[kStart*NUM_POS*NUM_POS];
		T *KTk = &KT[kStart*ld_KT*DIM_KT_c]; T *duk = &du[kStart*ld_du];
		T *dk = &d[((bInd+1)*N_BLOCKS_F-1)*ld_d]; // will only be used once on boundary so lock in
		for(int rep = 0; rep < reps; rep++){ int k = kStart + rep;
			// compute the new control: u = u - alpha*du - K(xnew-x) -- but note we have KT not K
			getFeedbackControl<T>(uk,xk,xpk,s_dx,KTk,ld_KT,duk,alpha);
	        // first compute qdd
	        #if EE_COST
				forwardDynamics4x4<T,MPC_MODE>(qddk, uk, &xk[NUM_POS], xk, I, s_Tb4, Minvk);
	        #else
        		forwardDynamics<T,MPC_MODE>(qddk, uk, &xk[NUM_POS], xk, I, Tbody, Minvk);
        	#endif
	        // then apply euler rule to xkp1 or dk
	        if (rep < N_BLOCKS_F - 1){
	    	    for (int ind = 0; ind < NUM_POS; ind++){
			        xkp1[ind] 			= xk[ind] 			+ dt*xk[ind+NUM_POS];
			        xkp1[ind+NUM_POS] 	= xk[ind+NUM_POS] 	+ dt*qddk[ind];
			    }
	        }
	        #if M_BLOCKS_F > 1
	        	else if (bInd < M_BLOCKS_F - 1){
		            // note that if at final state of non-last block then this is for defect comp (last block will never get here)
		    	    for (int ind = 0; ind < NUM_POS; ind++){
				        dk[ind] 		= xk[ind] 		  + dt*xk[ind+NUM_POS] - xkp1[ind];
				        dk[ind+NUM_POS] = xk[ind+NUM_POS] + dt*qddk[ind]       - xkp1[ind+NUM_POS];
				    }
				}
	        #endif
			// then compute the cost for this step
			#if EE_COST
				recurseTransforms4x4(s_T4,s_Tb4); computedEEPos4x4(s_eePos,s_T4);
				JT[desc.tid] += costFunc<T,KNOT_POINTS>(s_eePos,xGoal,xk,uk,k,Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
		  		// JT[desc.tid] += costFunc<T,KNOT_POINTS>(s_eePos,xGoal,xk,uk,k,params,xNom);
			#else
				JT[desc.tid] += costFunc<T,KNOT_POINTS>(xk,uk,xGoal,k,Q1,Q2,R,QF1,QF2);
				// JT[desc.tid] += costFunc<T,KNOT_POINTS>(xk,uk,xGoal,k,params);
			#endif
			// update the offsets for the next pass
			xk = xkp1; xkp1 += ld_x; uk += ld_u; xpk += ld_x; qddk += NUM_POS; KTk += ld_KT*DIM_KT_c; duk += ld_du; Minvk += NUM_POS*NUM_POS;
		}
		// if just computed the final state compute the final cost
		if (bInd == M_BLOCKS_F - 1){
			#if EE_COST
				T s_eePos[6]; T s_tempMem[34*NUM_POS]; computedEEPos4x4_scratch(s_eePos,&x[(KNOT_POINTS-1)*ld_x],s_tempMem);
		  		JT[desc.tid] += costFunc<T,KNOT_POINTS>(s_eePos,xGoal,&x[(KNOT_POINTS-1)*ld_x],(T *)nullptr,KNOT_POINTS-1,Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
		  		// JT[desc.tid] += costFunc<T,KNOT_POINTS>(s_eePos,xGoal,&x[(KNOT_POINTS-1)*ld_x],(T *)nullptr,KNOT_POINTS-1,params,xNom);
			#else
				JT[desc.tid] += costFunc<T,KNOT_POINTS>(&x[(KNOT_POINTS-1)*ld_x],(T *)nullptr,xGoal,KNOT_POINTS-1,Q1,Q2,R,QF1,QF2);
				// JT[desc.tid] += costFunc<T,KNOT_POINTS>(&x[(KNOT_POINTS-1)*ld_x],(T *)nullptr,xGoal,KNOT_POINTS-1,params);
			#endif
		}
	}
}

// xs, us, ds as ** and JT longer (alpha*max(cost,fsim)threads in size) also pass in all alphas and startAlpha
template <typename T, int KNOT_POINTS, int N_BLOCKS_F, bool MPC_MODE = false>
int forwardSimCPU(T **xs, T *xp, T *xp2, T **us, T *up, T **qdds, T **Minvs, T *KT, T *du, T **ds, T *dp, T *dJexp, T **JTs, T *alphas, int startAlpha, \
				   T *xGoal, T *J, T *dJ, T *z, T prevJ, int *ignore_defect, T *maxd, std::thread *threads, \
				   int ld_x, int ld_u, int ld_KT, int ld_du, int ld_d, T *I, T *Tbody, T dt,
				   T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q1, T Q2, T R, T QF1, T QF2, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
				   // int ld_x, int ld_u, int ld_KT, int ld_du, int ld_d, T *I, T *Tbody, CostParams<T> *params, T *xNom = nullptr){
	// ACTUAL FORWARD SIM //
	*J = 0; 	T Js[FSIM_ALPHA_THREADS];		for(unsigned int i = 0; i < FSIM_ALPHA_THREADS; i++){Js[i] = 0;}
	threadDesc_t desc; 		desc.dim = FSIM_THREADS;	unsigned int threads_launched = 0;
	for (unsigned int alpha_i = 0; alpha_i < FSIM_ALPHA_THREADS; alpha_i++){
		unsigned int alphaInd = startAlpha + alpha_i; 	if(alphaInd >= NUM_ALPHA){break;}
		for (unsigned int thread_i = 0; thread_i < FSIM_THREADS; thread_i++){
	        desc.tid = thread_i;   desc.reps = compute_reps(thread_i,FSIM_THREADS,M_BLOCKS_F);
	    	threads[alpha_i*FSIM_THREADS+thread_i] = std::thread(&forwardSim<T,KNOT_POINTS,N_BLOCKS_F,MPC_MODE>, desc, std::ref(xs[alphaInd]), std::ref(us[alphaInd]), std::ref(qdds[alphaInd]), 
	    													std::ref(Minvs[alphaInd]), std::ref(KT), std::ref(du), std::ref(ds[alphaInd]), alphas[alphaInd], std::ref(xp), 
	    													ld_x, ld_u, ld_KT, ld_du, ld_d, std::ref(I), std::ref(Tbody), std::ref(xGoal), std::ref(JTs[alphaInd]), dt,
	    													Q_EE1, Q_EE2, QF_EE1, QF_EE2, R_EE, Q1, Q2, R, QF1, QF2, Q_xdEE, QF_xdEE, Q_xEE, QF_xEE, std::ref(xNom)); 
	    													// std::ref(params), std::ref(xNom));
	        if(FORCE_CORE_SWITCHES){setCPUForThread(threads, alpha_i*FSIM_THREADS+thread_i);}	threads_launched++;
	    }
	}
    // while we are doing these (very expensive) operation save xp into xp2 which we'll need for the backward pass linear transform
    // and sum expCost -- note: only do this the first time -- then join forward sim threads
    if (startAlpha == 0){std::memcpy(xp2,xp,ld_x*KNOT_POINTS*sizeof(T)); for (unsigned int i=1; i<BP_THREADS; i++){dJexp[0] += dJexp[2*i]; dJexp[1] += dJexp[2*i+1];}}
	for (unsigned int thread_i = 0; thread_i < threads_launched; thread_i++){threads[thread_i].join();}
	// ACTUAL FORWARD SIM //

	// LINE SEARCH //
    // then sum the cost (computed in the FSIM)
	for (unsigned int alpha_i = 0; alpha_i < FSIM_ALPHA_THREADS; alpha_i++){
		unsigned int alphaInd = startAlpha + alpha_i;	if(alphaInd >= NUM_ALPHA){break;}	T *JT = JTs[alphaInd];
		for (unsigned int thread_i = 0; thread_i < FSIM_THREADS; thread_i++){Js[alpha_i] += JT[thread_i];}
	}
	// test if J satisfies line search criteria
	T cdJ = -1; T cz = 0; T cd = 0; int alphaIndex = -1; bool JFlag, zFlag, dFlag;
	for (unsigned int alpha_i = 0; alpha_i < FSIM_ALPHA_THREADS; alpha_i++){
		unsigned int alphaInd = startAlpha + alpha_i;	if(alphaInd >= NUM_ALPHA){break;}	T alpha = alphas[alphaInd];					
		T cJ = Js[alpha_i];		cdJ = prevJ - cJ;									JFlag = cdJ >= static_cast<T>(0) && cdJ > *dJ;
		cz = cdJ / (alpha*dJexp[0] + static_cast<T>(0.5)*alpha*alpha*dJexp[1]); 	zFlag = static_cast<T>(EXP_RED_MIN) < cz && cz < static_cast<T>(EXP_RED_MAX);
	    if (M_BLOCKS_F > 1){cd = defectComp<T,KNOT_POINTS,N_BLOCKS_F>(ds[alphaInd],ld_d); dFlag = cd < static_cast<T>(MAX_DEFECT_SIZE);} else{dFlag = 1;}
	    // printf("Alpha[%f] -> J[%f]dJ[%f] -> z[%f], d[%f] so flags are J[%d]z[%d]d[%d]\n",alpha,cJ,cdJ,cz,cd,JFlag,zFlag,dFlag);
	    if(JFlag && zFlag && dFlag){
			if (*ignore_defect && cd < static_cast<T>(MAX_DEFECT_SIZE)){*ignore_defect = 0;} // update the ignore defect
			alphaIndex = alphaInd; *dJ = cdJ; *z = cz; *J = Js[alpha_i]; *maxd = cd; // update current best index, dJ, z, J, maxd
			break; // on CPU pick first alpha strategy   
	    }
	}
    // else failed
    return alphaIndex; //-1 on failure
    // LINE SEARCH //
}

// loop forward and compute new states and controls with the sweep (using the AB linearization)
template <typename T, int KNOT_POINTS, int N_BLOCKS_F>
void forwardSweepThreaded(threadDesc_t desc, T **xs, T *ApBK, T *Bdu, T **ds, T *xp, T *alphas, int ld_x, int ld_d, int ld_A){
	T s_dx[DIM_x_r];
	for (unsigned int i=0; i<desc.reps; i++){int a = desc.tid + i*desc.dim;
		T *xk = xs[a]; T *xkp1 = xk + ld_x; T *xpk = xp; T alpha = alphas[a];
		T *Ak = ApBK; T *Bk = Bdu; T *dk = ds[a];
	   	for(int k=0; k<KNOT_POINTS-1; k++){bool dFlag = onDefectBoundary<KNOT_POINTS,N_BLOCKS_F>(k);
			// compute the new state: xkp1 = xkp1 + (A - B*K)(xnew-x) - alpha*B*du + d
			// we can do these in a series of parallel computations on seperate threads
			// stage 1: ApBK = A - BK, Bdu = B*du computed in backward pass
			// stage 1: compute dx = x - xp
			#pragma unroll
			for (int ind = 0; ind < STATE_SIZE; ind++){s_dx[ind] = xk[ind]-xpk[ind];}

			// stage 2: finish the comp
			#pragma unroll
			for (int kx = 0; kx < DIM_x_r; kx++){
				T val = 0;
				// multiply row kx of ApBK by xp
				#pragma unroll
				for (int i=0; i<DIM_x_r; i++){val += Ak[kx + DIM_A_r*i]*s_dx[i];}
				// and subtract alpha*Bdu from the previos value and save to global memory
				// also if on defect boundary add d
				if (dFlag){val += dk[kx];}
				xkp1[kx] += -alpha*Bk[kx] + val;
			}

			// then update the offsets for the next pass
			xk = xkp1; xpk += ld_x; xkp1 += ld_x; dk += ld_d; Bk += ld_d; Ak += ld_A*DIM_A_c;
	   	}
	}
}
template <typename T, int KNOT_POINTS, int N_BLOCKS_F>
void forwardSweep(T **xs, T *ApBK, T *Bdu, T **ds, T *xp, T *alphas, int alphaStart, std::thread *threads, int ld_x, int ld_d, int ld_A){
	T **xstart = &xs[alphaStart];	T **dstart = &ds[alphaStart];	T *astart = &alphas[alphaStart];
	threadDesc_t desc; 	desc.dim = FSIM_ALPHA_THREADS;	desc.reps = 1;
	for (unsigned int thread_i = 0; thread_i < FSIM_ALPHA_THREADS; thread_i++){
		desc.tid = thread_i;
		threads[thread_i] = std::thread(&forwardSweepThreaded<T,KNOT_POINTS,N_BLOCKS_F>,desc,std::ref(xstart),std::ref(ApBK),std::ref(Bdu),std::ref(dstart),
																							 std::ref(xp),std::ref(astart),ld_x,ld_d,ld_A);
		if(FORCE_CORE_SWITCHES){setCPUForThread(threads, thread_i);}
	}
	for (unsigned int thread_i = 0; thread_i < FSIM_ALPHA_THREADS; thread_i++){threads[thread_i].join();}
}