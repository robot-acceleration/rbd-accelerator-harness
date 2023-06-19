/*****************************************************************
 * DDP Next Iteration Setup and Init Helper Functions
 * (currently only supports iLQR - UDP in future release)
 *
 *  nextIterationSetupCPU
 *    costGradientHessianThreaded
 *	  integratorGradientThreaded
 *	  memcpyArr
 *  initAlgCPU
 *    costGradientHessianThreaded
 *	  integratorGradientThreaded
 *	  memcpyArr
 *	acceptRejectTrajCPU
 *	loadVarsCPU
 *  storeVarsCPU
 *	  defectComp
 *  allocateMemoryCPU
 *  freeMemoryCPU
 *****************************************************************/

template <typename T>
void memcpyArr(T **dsts, T *src, size_t size, int amount, int skip = -1){
	for (int i = 0; i < amount; i++){
		if (i == skip){continue;}
		std::memcpy(dsts[i], src, size);
	}
}

// x = [q;qd] so xd = [dq,qdd] thus dxd_dx,u = [0_{numpos},I_{numpos},0_{numpos};dqdd]
template <typename T>
T dqdd2dxd(T *dqdd, int r, int c){return r < NUM_POS ? static_cast<T>(r + NUM_POS == c ? 1 : 0) : dqdd[(c-1)*NUM_POS + r];}

template <typename T, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false, bool VEL_DAMPING = true>
void integratorGradientThreaded(threadDesc_t desc, T *d_x, T *d_u, T *d_qdd, T *d_Minv, T *d_AB, int ld_x, int ld_u, int ld_AB, T dt, T *I, T *Tbody){
    T s_cdq[NUM_POS*NUM_POS]; T s_cdqd[NUM_POS*NUM_POS]; T s_Minv[NUM_POS*NUM_POS]; T s_dqdd[3*NUM_POS*NUM_POS];
    T s_v[6*NUM_POS]; T s_a[6*NUM_POS]; T s_f[6*NUM_POS]; T s_T[36*NUM_POS];
    // for each rep on this thread
    for (unsigned int i=0; i<desc.reps; i++){int k = (desc.tid+i*desc.dim);
        T *xk = &d_x[k*ld_x*DIM_x_c]; T *uk = &d_u[k*ld_u*DIM_u_c]; T *qddk = &d_qdd[k*NUM_POS]; T *ABk = &d_AB[k*ld_AB*DIM_AB_c];
        T *Minvk; if(MINV_PASSED_IN){Minvk = &d_Minv[k*NUM_POS*NUM_POS];} else{Minvk = s_Minv;}
        // dqdd/dtau = Minv and  dqdd/dq(d) = -Minv*dc/dq(d) note: dM term in dq drops out if you compute c with fd qdd per carpentier
        // first compute the dynamics gradient helpers (v,a,f to prep for inverse dynamics gradient) and compute Minv and qdd if needed
        if (QDD_PASSED_IN && MINV_PASSED_IN){forwardDynamicsGradientSetupSimple<T,MPC_MODE>(s_v,s_a,s_f,s_T,Tbody,I,xk,&xk[NUM_POS],qddk);}
        else{forwardDynamicsGradientSetup<T,QDD_PASSED_IN,MPC_MODE>(s_v,s_a,s_f,Minvk,s_T,qddk,uk,&xk[NUM_POS],xk,I,Tbody);}
        // then compute the inverse dynamics gradient
        inverseDynamicsGradient<T,VEL_DAMPING>(s_cdq,s_cdqd,&xk[NUM_POS],s_v,s_a,s_f,I,s_T,k);
        // Then finish it off: dqdd/dtau = Minv, dqdd/dqd = -Minv*dc/dqd, dqdd/dq = -Minv*dc/dq
        // remember Minv is a symmetric sym UPPER matrix
        matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(s_dqdd,NUM_POS,Minvk,NUM_POS,s_cdq,NUM_POS,static_cast<T>(-1));
        matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(&s_dqdd[NUM_POS*NUM_POS],NUM_POS,Minvk,NUM_POS,s_cdqd,NUM_POS,static_cast<T>(-1));
        copyMatSym<T,NUM_POS,NUM_POS>(&s_dqdd[2*NUM_POS*NUM_POS],Minvk,NUM_POS,NUM_POS);
        // then apply the euler rule -- xkp1 = [q;qd] + dt*[qd;qdd]
        // so we then know that A = I + dt*[0,I;dqdd_dq,dqdd_dqd] and B = [0;dt*dqdd_dtau]
        #pragma unroll
        for (int ky = 0; ky < DIM_AB_c; ky++){ // pick the col dq, dqdd, du
            #pragma unroll
            for (int kx = 0; kx < DIM_AB_r; kx++){ // pick the row (q,dq)
                ABk[ky*ld_AB + kx] = static_cast<T>(ky == kx ? 1 : 0) + dt*dqdd2dxd(s_dqdd,kx,ky);
            }
        }
    }
}

template <typename T, int KNOT_POINTS, bool MPC_MODE = false>
void nextIterationSetupCPU(T **xs, T *xp, T **us, T *up, T **ds, T *dp, T **qdds, T *qddp, T **Minvs, T *Minvp, T *AB, T *H, T *g, T *P, T *p, T *Pp, T *pp, \
                            T *xGoal, std::thread *threads, int *alphaIndex, int ld_x, int ld_u, int ld_d, int ld_AB, int ld_H, int ld_g, int ld_P, int ld_p, \
                           T *I, T *Tbody, T dt,
                           T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q1, T Q2, T R, T QF1, T QF2, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
                           // CostParams<T> *params, T *xNom){
	// Compute derivatives for next pass(AB,H,g) also save x, u, J, P, p into prev variables
    threadDesc_t desc;  desc.dim = INTEGRATOR_THREADS;
    for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){
        desc.tid = thread_i;    desc.reps = compute_reps(thread_i,INTEGRATOR_THREADS,(KNOT_POINTS-1));
        threads[thread_i] = std::thread(&integratorGradientThreaded<T,1,1,MPC_MODE>, desc, std::ref(xs[*alphaIndex]), std::ref(us[*alphaIndex]), std::ref(qdds[*alphaIndex]), \
                                                                                     std::ref(Minvs[*alphaIndex]), std::ref(AB), ld_x, ld_u, ld_AB, dt, std::ref(I), std::ref(Tbody));
        if(FORCE_CORE_SWITCHES){setCPUForThread(threads, thread_i);}
        // integratorGradientThreaded<T,1,1>(desc,xs[*alphaIndex],us[*alphaIndex],qdds[*alphaIndex],Minvs[*alphaIndex],AB,ld_x,ld_u,ld_AB,I,Tbody,flag);
    }
    // desc.dim = COST_THREADS;
    // for (unsigned int thread_i = 0; thread_i < COST_THREADS; thread_i++){
    //     desc.tid = thread_i;    desc.reps = compute_reps(thread_i,COST_THREADS,KNOT_POINTS);
    //     threads[INTEGRATOR_THREADS + thread_i] = std::thread(&costGradientHessianThreaded<T>, desc, std::ref(xs[*alphaIndex]), std::ref(us[*alphaIndex]), std::ref(g), std::ref(H), std::ref(xGoal), ld_x, ld_u, ld_H, ld_g, nullptr, \
    //                                                                      Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,Q1,Q2,R,QF1,QF2);
    //     if(FORCE_CORE_SWITCHES){setCPUForThread(threads,thread_i);}
    // }
    // Note in CPU MODE while we launch the expensive dynamics gradient computation in threads we compute the others locally
    //      in GPU/FPGA MODE since the dynamics gradient is offloaded we may want to thread the cost gradient
    desc.dim = 1; desc.tid = 0; desc.reps = KNOT_POINTS;
    costGradientHessianThreaded<T,KNOT_POINTS>(desc,xs[*alphaIndex],us[*alphaIndex],g,H,xGoal,ld_x,ld_u,ld_H,ld_g,Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
    // costGradientHessianThreaded<T>(desc,xs[*alphaIndex],us[*alphaIndex],g,H,xGoal,ld_x,ld_u,ld_H,ld_g,params,xNom);
    // also copy P,p into Pp,pp
    std::memcpy(Pp,P,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));            std::memcpy(pp,p,ld_p*KNOT_POINTS*sizeof(T));
    // these can finish during the backpass before the forward pass (but we sync here because fast and more straightforward)
    std::memcpy(xp,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T));          std::memcpy(up,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T));
    std::memcpy(qddp,qdds[*alphaIndex],NUM_POS*KNOT_POINTS*sizeof(T));   std::memcpy(Minvp,Minvs[*alphaIndex],NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
    // synch on threads
    // for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS + COST_THREADS; thread_i++){threads[thread_i].join();}
    for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}
 	// and copy x,u,d to all x,u,d
 	threads[0] = std::thread(&memcpyArr<T>, std::ref(xs), std::ref(xs[*alphaIndex]), ld_x*KNOT_POINTS*sizeof(T), NUM_ALPHA, *alphaIndex);
 	if(FORCE_CORE_SWITCHES){setCPUForThread(threads, 0);}
 	threads[1] = std::thread(&memcpyArr<T>, std::ref(us), std::ref(us[*alphaIndex]), ld_u*KNOT_POINTS*sizeof(T), NUM_ALPHA, *alphaIndex);
 	if(FORCE_CORE_SWITCHES){setCPUForThread(threads, 1);}
	#if M_BLOCKS_F > 1
		threads[2] = std::thread(&memcpyArr<T>, std::ref(ds), std::ref(ds[*alphaIndex]), ld_d*KNOT_POINTS*sizeof(T), NUM_ALPHA, *alphaIndex);
		if(FORCE_CORE_SWITCHES){setCPUForThread(threads, 2);}
	#endif
 	threads[0].join(); threads[1].join();
    #if M_BLOCKS_F > 1
        threads[2].join();
    #endif
}

template <typename T, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false>
void integratorGradientThreaded_start(threadDesc_t desc, T *d_x, T *d_u, T *d_qdd, T *d_Minv, T *d_v, T *d_a, T *d_f, T *d_Tfinal, \
                                      int ld_x, int ld_u, T *I, T *Tbody){
    // for each rep on this thread
    for (unsigned int i=0; i<desc.reps; i++){int k = (desc.tid+i*desc.dim);
        T *xk = &d_x[k*ld_x*DIM_x_c]; T *uk = &d_u[k*ld_u*DIM_u_c]; T *qddk = &d_qdd[k*NUM_POS]; T *Minvk = &d_Minv[k*NUM_POS*NUM_POS];
        int ind6 = k*6*NUM_POS; T *vk = &d_v[ind6]; T *ak = &d_a[ind6]; T *fk = &d_f[ind6]; T *Tfinalk = &d_Tfinal[6*ind6];
        // dqdd/dtau = Minv and  dqdd/dq(d) = -Minv*dc/dq(d) note: dM term in dq drops out if you compute c with fd qdd per carpentier
        // first compute the dynamics gradient helpers (v,a,f to prep for inverse dynamics gradient) and compute Minv and qdd if needed
        if (QDD_PASSED_IN && MINV_PASSED_IN){forwardDynamicsGradientSetupSimple<T,MPC_MODE>(vk,ak,fk,Tfinalk,Tbody,I,xk,&xk[NUM_POS],qddk);}
        else{forwardDynamicsGradientSetup<T,QDD_PASSED_IN,MPC_MODE>(vk,ak,fk,Minvk,Tfinalk,qddk,uk,&xk[NUM_POS],xk,I,Tbody);}
    }
}

template <typename T>
void integratorGradientThreaded_finish(threadDesc_t desc, T *d_Minv, T *d_cdq, T *d_cdqd, T *d_AB, int ld_AB, T dt){
    T s_dqdd[3*NUM_POS*NUM_POS];
    // for each rep on this thread
    for (unsigned int i=0; i<desc.reps; i++){int k = (desc.tid+i*desc.dim);
        int ind = k*NUM_POS*NUM_POS; T *Minvk = &d_Minv[ind]; T *cdqk = &d_cdq[ind]; T *cdqdk = &d_cdqd[ind]; T *ABk = &d_AB[k*ld_AB*DIM_AB_c];
        // Then finish it off: dqdd/dtau = Minv, dqdd/dqd = -Minv*dc/dqd, dqdd/dq = -Minv*dc/dq
        // remember Minv is a symmetric sym UPPER matrix
        matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(s_dqdd,NUM_POS,Minvk,NUM_POS,cdqk,NUM_POS,static_cast<T>(-1));
        matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(&s_dqdd[NUM_POS*NUM_POS],NUM_POS,Minvk,NUM_POS,cdqdk,NUM_POS,static_cast<T>(-1));
        copyMatSym<T,NUM_POS,NUM_POS>(&s_dqdd[2*NUM_POS*NUM_POS],Minvk,NUM_POS,NUM_POS);
        // then apply the euler rule -- xkp1 = [q;qd] + dt*[qd;qdd]
        // so we then know that A = I + dt*[0,I;dqdd_dq,dqdd_dqd] and B = [0;dt*dqdd_dtau]
        #pragma unroll
        for (int ky = 0; ky < DIM_AB_c; ky++){ // pick the col dq, dqdd, du
            #pragma unroll
            for (int kx = 0; kx < DIM_AB_r; kx++){ // pick the row (q,dq)
                ABk[ky*ld_AB + kx] = static_cast<T>(ky == kx ? 1 : 0) + dt*dqdd2dxd(s_dqdd,kx,ky);
            }
        }
    }
}

#if EE_COST
    template <typename T, int KNOT_POINTS, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false, bool VEL_DAMPING = true>
    void integratorCostEEGradientThreaded(threadDesc_t desc, T *x, T *u, T *qdd, T *Minv, T *AB, T *H, T *g, T *I, T *xGoal, \
                                          int ld_x, int ld_u, int ld_AB, int ld_H, int ld_g, T dt, \
                                          T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr, T *JT = nullptr){
                                          // CostParams<T> *params, T *xNom, T *JT = nullptr){
        if (JT != nullptr){JT[desc.tid] = 0;}
        T s_dqdd[3*NUM_POS*NUM_POS]; T s_Tb4[16*NUM_POS]; T s_Tb4dq[16*NUM_POS]; T s_T4dq[32*NUM_POS];
        T s_cdq[NUM_POS*NUM_POS]; T s_cdqd[NUM_POS*NUM_POS]; T s_Minv[NUM_POS*NUM_POS]; T s_eePos[6]; T s_deePos[6*NUM_POS];
        T s_v[6*NUM_POS]; T s_a[6*NUM_POS]; T s_f[6*NUM_POS]; T s_T[36*NUM_POS];
        // for each rep on this thread
        for (unsigned int i=0; i<desc.reps; i++){int k = (desc.tid+i*desc.dim);
            T *xk = &x[k*ld_x*DIM_x_c]; T *uk = &u[k*ld_u*DIM_u_c]; T *qddk = &qdd[k*NUM_POS]; T *ABk = &AB[k*ld_AB*DIM_AB_c];
            T *Minvk; if(MINV_PASSED_IN){Minvk = &Minv[k*NUM_POS*NUM_POS];} else{Minvk = s_Minv;} T *Hk = &H[k*ld_H*DIM_H_c]; T *gk = &g[k*ld_g];
            // dqdd/dtau = Minv and  dqdd/dq(d) = -Minv*dc/dq(d) note: dM term in dq drops out if you compute c with fd qdd per carpentier
            // first compute the dynamics gradient helpers (v,a,f to prep for inverse dynamics gradient) and compute Minv and qdd if needed
            if (QDD_PASSED_IN && MINV_PASSED_IN){forwardDynamicsGradientSetupSimple4x4<T,MPC_MODE>(s_v,s_a,s_f,s_T,s_Tb4,I,xk,&xk[NUM_POS],qddk,s_Tb4dq);}
            else{forwardDynamicsGradientSetup4x4<T,QDD_PASSED_IN,MPC_MODE>(s_v,s_a,s_f,Minvk,s_T,s_Tb4,qddk,uk,&xk[NUM_POS],xk,I);}
            // then compute the inverse dynamics gradient
            inverseDynamicsGradient<T,VEL_DAMPING>(s_cdq,s_cdqd,&xk[NUM_POS],s_v,s_a,s_f,I,s_T,k);
            // Then finish it off: dqdd/dtau = Minv, dqdd/dqd = -Minv*dc/dqd, dqdd/dq = -Minv*dc/dq
            // remember Minv is a symmetric sym UPPER matrix
            matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(s_dqdd,NUM_POS,Minvk,NUM_POS,s_cdq,NUM_POS,static_cast<T>(-1));
            matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(&s_dqdd[NUM_POS*NUM_POS],NUM_POS,Minvk,NUM_POS,s_cdqd,NUM_POS,static_cast<T>(-1));
            copyMatSym<T,NUM_POS,NUM_POS>(&s_dqdd[2*NUM_POS*NUM_POS],Minvk,NUM_POS,NUM_POS);
            // then apply the euler rule -- xkp1 = [q;qd] + dt*[qd;qdd]
            // so we then know that A = I + dt*[0,I;dqdd_dq,dqdd_dqd] and B = [0;dt*dqdd_dtau]
            #pragma unroll
            for (int ky = 0; ky < DIM_AB_c; ky++){ // pick the col dq, dqdd, du
                #pragma unroll
                for (int kx = 0; kx < DIM_AB_r; kx++){ // pick the row (q,dq)
                    ABk[ky*ld_AB + kx] = static_cast<T>(ky == kx ? 1 : 0) + dt*dqdd2dxd(s_dqdd,kx,ky);
                }
            }
            // compute end effector pos/vel and then cost grad
            recurseTransforms4x4(s_T, s_Tb4); // reuse s_T because we are done with it (now using as T4)
            computeTransforms4x4dqEE(s_T4dq,s_Tb4,s_Tb4dq,s_T,&s_T4dq[16*NUM_POS]);
            computedEEPos4x4(s_eePos,s_T,s_deePos,s_T4dq,&s_T4dq[16*NUM_POS]);
            costGrad<T,KNOT_POINTS>(Hk,gk,s_eePos,s_deePos,xGoal,xk,uk,k,ld_H,Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom,JT,desc.tid);
            // for(int i = 0; i < DIM_H_c*DIM_H_r; i++){Hk[i] = 0.0;}
            // costGrad<T,KNOT_POINTS>(Hk,gk,s_eePos,s_deePos,xGoal,xk,uk,k,ld_H,params,xNom,JT,desc.tid);
        }
    }

    template <typename T, int KNOT_POINTS, bool MPC_MODE = false>
    void nextIterationSetupCPU_EE(T **xs, T *xp, T **us, T *up, T **ds, T *dp, T **qdds, T *qddp, T **Minvs, T *Minvp, T *AB, T *H, T *g, \
                                  T *P, T *p, T *Pp, T *pp, T *I, T *xGoal, std::thread *threads, int *alphaIndex, \
                                  int ld_x, int ld_u, int ld_d, int ld_AB, int ld_H, int ld_g, int ld_P, int ld_p, T dt, \
                                  T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
                               // CostParams<T> *params, T *xNom = nullptr){
        // Compute derivatives for next pass(AB,H,g) in threads while doing this also save x, u, J, P, p into prev variables
        threadDesc_t desc;  desc.dim = INTEGRATOR_THREADS;
        for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){
            desc.tid = thread_i;    desc.reps = compute_reps(thread_i,INTEGRATOR_THREADS,(KNOT_POINTS-1));
            threads[thread_i] = std::thread(&integratorCostEEGradientThreaded<T,KNOT_POINTS,1,1,MPC_MODE>, desc, std::ref(xs[*alphaIndex]), std::ref(us[*alphaIndex]), std::ref(qdds[*alphaIndex]), \
                                                                                      std::ref(Minvs[*alphaIndex]), std::ref(AB), std::ref(H), std::ref(g), std::ref(I), std::ref(xGoal), \
                                                                                      ld_x, ld_u, ld_AB, ld_H, ld_g, dt, \
                                                                                      Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,std::ref(xNom), nullptr);
                                                                                      // std::ref(params), std::ref(xNom), nullptr);
            if(FORCE_CORE_SWITCHES){setCPUForThread(threads, thread_i);}
        }
        // copy P,p into Pp,pp
        std::memcpy(Pp,P,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));            std::memcpy(pp,p,ld_p*KNOT_POINTS*sizeof(T));
        // these can finish during the backpass before the forward pass (but we sync here because fast and more straightforward)
        std::memcpy(xp,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T));          std::memcpy(up,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T));
        std::memcpy(qddp,qdds[*alphaIndex],NUM_POS*KNOT_POINTS*sizeof(T));   std::memcpy(Minvp,Minvs[*alphaIndex],NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
        // and copy x,u,d to all x,u,d if needed
        memcpyArr<T>(xs,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
        memcpyArr<T>(us,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
        #if M_BLOCKS_F > 1
            memcpyArr<T>(ds,ds[*alphaIndex],ld_d*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
        #endif
        // synch on threads to finish (and note you need to do the last X cost)
        desc.dim = 1; desc.tid = KNOT_POINTS-1; desc.reps = 1;
        costGradientHessianThreaded<T,KNOT_POINTS>(desc,xs[*alphaIndex],us[*alphaIndex],g,H,xGoal,ld_x,ld_u,ld_H,ld_g,Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,0.0,0.0,0.0,0.0,0.0,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
        // costGradientHessianThreaded<T>(desc,xs[*alphaIndex],us[*alphaIndex],g,H,xGoal,ld_x,ld_u,ld_H,ld_g,params,xNom);
        for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}
    }

    template <typename T, int KNOT_POINTS, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false>
    void integratorCostEEGradientThreaded_start(threadDesc_t desc, T *x, T *u, T *qdd, T *Minv, T *v, T *a, T *f, T *Tfinal, T *H, T *g, T *I, T *xGoal, \
                                          int ld_x, int ld_u, int ld_H, int ld_g, \
                                          T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr, T *JT = nullptr){
        if (JT != nullptr){JT[desc.tid] = 0.0;} T s_Tb4[16*NUM_POS]; T s_Tb4dq[16*NUM_POS]; T s_T4dq[32*NUM_POS]; T s_eePos[6]; T s_deePos[6*NUM_POS]; T s_T[36*NUM_POS];
        // for each rep on this thread
        for (unsigned int i=0; i<desc.reps; i++){int k = (desc.tid+i*desc.dim);
            T *xk = &x[k*ld_x]; T *uk = &u[k*ld_u]; T *qddk = &qdd[k*NUM_POS]; T *Minvk = &Minv[k*NUM_POS*NUM_POS]; T *gk = &g[k*ld_g]; T *Hk = &H[k*ld_H*DIM_H_c];
            int ind6 = k*6*NUM_POS; T *vk = &v[ind6]; T *ak = &a[ind6]; T *fk = &f[ind6]; T *Tfinalk = &Tfinal[6*ind6];
            // dqdd/dtau = Minv and  dqdd/dq(d) = -Minv*dc/dq(d) note: dM term in dq drops out if you compute c with fd qdd per carpentier
            // first compute the dynamics gradient helpers (v,a,f to prep for inverse dynamics gradient) and compute Minv and qdd if needed
            if (QDD_PASSED_IN && MINV_PASSED_IN){forwardDynamicsGradientSetupSimple4x4<T,MPC_MODE>(vk,ak,fk,Tfinalk,s_Tb4,I,xk,&xk[NUM_POS],qddk,s_Tb4dq);}
            else{forwardDynamicsGradientSetup4x4<T,QDD_PASSED_IN,MPC_MODE>(vk,ak,fk,Minvk,Tfinalk,s_Tb4,qddk,uk,&xk[NUM_POS],xk,I);}
            // compute end effector pos/vel and then cost grad
            recurseTransforms4x4(s_T, s_Tb4); // use s_T as temp mem space
            computeTransforms4x4dqEE(s_T4dq,s_Tb4,s_Tb4dq,s_T,&s_T4dq[16*NUM_POS]);
            computedEEPos4x4(s_eePos,s_T,s_deePos,s_T4dq,&s_T4dq[16*NUM_POS]);
            costGrad<T,KNOT_POINTS>(Hk,gk,s_eePos,s_deePos,xGoal,xk,uk,k,ld_H,Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom,JT,desc.tid);
        }
    }
#endif

template <typename T, int KNOT_POINTS, bool MPC_MODE = false>
void initAlgCPU(T **xs, T *xp, T *xp2, T **us, T *up, T *AB, T *H, T *g, T *KT, T *du, T **ds, T *d, T *JT, T *Jout, T *prevJ, \
				T *alphas, int *alphaOut, T *xGoal, std::thread *threads, int forwardRolloutFlag, \
				int ld_x, int ld_u, int ld_AB, int ld_H, int ld_g, int ld_KT, int ld_du, int ld_d, T *I, T *Tbody, T dt, T tol_cost, \
                T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q1, T Q2, T R, T QF1, T QF2, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
				// CostParams<T> *params, T *xNom = nullptr){
    threadDesc_t desc; if (forwardRolloutFlag){alphaOut[0] = 0;} else{alphaOut[0] = -1;}
    desc.dim = INTEGRATOR_THREADS;
    for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){
        desc.tid = thread_i;    desc.reps = compute_reps(thread_i,INTEGRATOR_THREADS,(KNOT_POINTS-1));
        threads[thread_i] = std::thread(&integratorGradientThreaded<T,0,0,MPC_MODE>, desc, std::ref(xs[0]), std::ref(us[0]), nullptr, nullptr, std::ref(AB), ld_x, ld_u, ld_AB, dt, std::ref(I), std::ref(Tbody));
        if(FORCE_CORE_SWITCHES){setCPUForThread(threads, thread_i);}
    }
    // desc.dim = COST_THREADS;
    // for (unsigned int thread_i = 0; thread_i < COST_THREADS; thread_i++){
    //     desc.tid = thread_i;    desc.reps = compute_reps(thread_i,COST_THREADS,KNOT_POINTS);
    //     threads[INTEGRATOR_THREADS + thread_i] = std::thread(&costGradientHessianThreaded<T>, desc, std::ref(xs[0]), std::ref(us[0]), std::ref(g), std::ref(H), std::ref(xGoal), ld_x, ld_u, ld_H, ld_g, std::ref(JT),
    //                                                                      Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,Q1,Q2,R,QF1,QF2);
    //     if(FORCE_CORE_SWITCHES){setCPUForThread(threads, INTEGRATOR_THREADS + thread_i);}
    // }
    // Note in CPU MODE while we launch the expensive dynamics gradient computation in threads we compute the others locally
    //      in GPU/FPGA MODE since the dynamics gradient is offloaded we may want to thread the cost gradient
    desc.dim = 1; desc.tid = 0; desc.reps = KNOT_POINTS;
    costGradientHessianThreaded<T,KNOT_POINTS>(desc,xs[0],us[0],g,H,xGoal,ld_x,ld_u,ld_H,ld_g,Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom,JT);
    // costGradientHessianThreaded<T>(desc,xs[0],us[0],g,H,xGoal,ld_x,ld_u,ld_H,ld_g,params,xNom,JT);
    // finally copy x,u into xp,xp2,up
    std::memcpy(xp,xs[0],ld_x*KNOT_POINTS*sizeof(T)); std::memcpy(xp2,xs[0],ld_x*KNOT_POINTS*sizeof(T)); std::memcpy(up,us[0],ld_u*KNOT_POINTS*sizeof(T));
    // make sure all threads finish
    for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}
    // sum the cost and add epsilon in case the intialization results in zero update for the first pass
    *prevJ = *JT;//0; for (unsigned int thread_i = 0; thread_i < COST_THREADS; thread_i++){*prevJ += JT[thread_i];}
    Jout[0] = *prevJ;   *prevJ *= (1 + 2*tol_cost); // we are doing % change now so need to account for that
	// also copy all x,u,d to xs,us,ds
    threads[0] = std::thread(&memcpyArr<T>, std::ref(xs), std::ref(xs[0]), ld_x*KNOT_POINTS*sizeof(T), NUM_ALPHA, 0);
    if(FORCE_CORE_SWITCHES){setCPUForThread(threads, 0);}
    threads[1] = std::thread(&memcpyArr<T>, std::ref(us), std::ref(us[0]), ld_u*KNOT_POINTS*sizeof(T), NUM_ALPHA, 0);
    if(FORCE_CORE_SWITCHES){setCPUForThread(threads, 1);}
    #if M_BLOCKS_F > 1
        threads[2] = std::thread(&memcpyArr<T>, std::ref(ds), std::ref(d), ld_d*KNOT_POINTS*sizeof(T), NUM_ALPHA, -1);
        if(FORCE_CORE_SWITCHES){setCPUForThread(threads, 2);}
    #endif
    threads[0].join(); threads[1].join();
    #if M_BLOCKS_F > 1
        threads[2].join();
    #endif
}

template <typename T, int KNOT_POINTS, bool IGNORE_MAX_ROX_EXIT, bool USE_MAX_SOLVER_TIME>
int acceptRejectTrajCPU(T **xs, T *xp, T **us, T *up, T **ds, T *dp, T **qdds, T *qddp, T **Minvs, T *Minvp, T J, T *prevJ, \
						T *dJ, T *rho, T *drho, int *alphaIndex, int *alphaOut, T *Jout, \
                   		int *iter, std::thread *threads, int ld_x, int ld_u, int ld_d, int max_iter, T tol_cost, \
                        double maxTime, struct timeval start, struct timeval end){
	// if failure increase rho, reset x,u,d,qdd,Minv, and reset alpha
	if (*alphaIndex == -1){
		*drho = std::max((*drho)*static_cast<T>(RHO_FACTOR),static_cast<T>(RHO_FACTOR)); *rho = std::min((*rho)*(*drho), static_cast<T>(RHO_MAX));  
		alphaOut[*iter] = -1; Jout[*iter] = *prevJ; *alphaIndex = 0;
        std::memcpy(xs[0], xp, ld_x*KNOT_POINTS*sizeof(T)); std::memcpy(us[0], up, ld_u*KNOT_POINTS*sizeof(T));
        std::memcpy(qdds[0], qddp, NUM_POS*KNOT_POINTS*sizeof(T)); std::memcpy(Minvs[0], Minvp, NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
        if (M_BLOCKS_F > 1){std::memcpy(ds[0], dp, ld_d*KNOT_POINTS*sizeof(T));}
		// check for maxRho failure
		if (*rho == static_cast<T>(RHO_MAX) && !IGNORE_MAX_ROX_EXIT){if (DEBUG_SWITCH){printf("Exiting for maxRho\n");} return 1;}
		else if (DEBUG_SWITCH){printf("[!]Forward Pass Failed Increasing Rho\n");}
	}
	// else try to decrease rho if we can and turn dJ into a percentage and save the cost to prevJ for next time and check for cost tol or max iter exit
	else {
		*drho = std::min((*drho)/static_cast<T>(RHO_FACTOR), static_cast<T>(1.0/RHO_FACTOR)); *rho = std::max((*rho)*(*drho), static_cast<T>(RHO_MIN));
		*dJ = (*dJ)/(*prevJ); *prevJ = J; alphaOut[*iter] = *alphaIndex; Jout[*iter] = J;
		// check for convergence
		if(*dJ < tol_cost && 0){if (DEBUG_SWITCH){printf("Exiting for tolCost[%f]\n",*dJ);} return 1;}      
	}
	// check for max iters or max time
    if (USE_MAX_SOLVER_TIME){gettimeofday(&end,NULL); if(time_delta_ms(start,end) > maxTime){if (DEBUG_SWITCH){printf("Exiting for maxTime\n");} return 1;};}
	if (*iter == max_iter){if (DEBUG_SWITCH){printf("Breaking for MaxIter\n");} return 1;}
	else{*iter += 1;}
	return 0;
}

template <typename T, int KNOT_POINTS>
void loadVarsCPU(T *x, T *xp, T *x0, T *u, T *up, T *u0, T *qdd, T *P, T *Pp, T *P0, T *p, T *pp, T *p0, \
			  	 T *KT, T *KT0, T *du, T *d, T *d0, T *AB, int *err, int clearVarsFlag, int forwardRolloutFlag, \
			  	 T *alpha, T *I, T *Tbody, T *xGoal, T *JT, std::thread *threads, 
			  	 int ld_x, int ld_u, int ld_P, int ld_p, int ld_KT, int ld_du, int ld_AB, int ld_d){
	// load x and u onto the device and into xp, up (assumes passed in x0 and u0 are ld aligned)
	std::memcpy(x,x0,ld_x*KNOT_POINTS*sizeof(T)); std::memcpy(xp,x0,ld_x*KNOT_POINTS*sizeof(T));
    std::memcpy(u,u0,ld_u*KNOT_POINTS*sizeof(T)); std::memcpy(up,u0,ld_u*KNOT_POINTS*sizeof(T));
	// for K0, P0, p0, d0 either load or clear
	if (clearVarsFlag){
		std::memset(P,0,ld_P*KNOT_POINTS*DIM_P_c*sizeof(T)); std::memset(Pp,0,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));
        std::memset(p,0,ld_p*KNOT_POINTS*sizeof(T)); std::memset(pp,0,ld_p*KNOT_POINTS*sizeof(T));
        std::memset(KT,0,ld_KT*DIM_KT_c*KNOT_POINTS*sizeof(T)); std::memset(d,0,ld_d*KNOT_POINTS*sizeof(T));
	} 
	else{
        std::memcpy(P,P0,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T)); std::memcpy(Pp,P0,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));
        std::memcpy(p,p0,ld_p*KNOT_POINTS*sizeof(T)); std::memcpy(pp,p0,ld_p*KNOT_POINTS*sizeof(T));
		std::memcpy(KT,KT0,ld_KT*DIM_KT_c*KNOT_POINTS*sizeof(T)); std::memcpy(d,d0,ld_d*KNOT_POINTS*sizeof(T));
	}
	// always clear err and du
	std::memset(du,0,ld_du*KNOT_POINTS*sizeof(T));
    std::memset(err,0,BP_THREADS*sizeof(int));
	T *ABN = AB + ld_AB*DIM_AB_c*(KNOT_POINTS-2); std::memset(ABN,0,ld_AB*DIM_AB_c*sizeof(T));
}

template <typename T, int KNOT_POINTS, int N_BLOCKS_F>
void storeVarsCPU(T *x, T *x0, T *u, T *u0, std::thread *threads, int ld_x, int ld_u, \
				  T *d = nullptr, T *maxd = nullptr, int ld_d = 0){
	bool defectFlag = M_BLOCKS_F > 1 && d != nullptr && maxd != nullptr && ld_d != 0;
	if (defectFlag){*maxd = defectComp<T,KNOT_POINTS,N_BLOCKS_F>(d,ld_d);}
	threads[0] = std::thread(memcpy, std::ref(x0), std::ref(x), ld_x*KNOT_POINTS*sizeof(T));
	if(FORCE_CORE_SWITCHES){setCPUForThread(threads, 0);}
	threads[1] = std::thread(memcpy, std::ref(u0), std::ref(u), ld_u*KNOT_POINTS*sizeof(T));
	if(FORCE_CORE_SWITCHES){setCPUForThread(threads, 1);}
	threads[0].join();
	threads[1].join();
}

template <typename T, int KNOT_POINTS>
void allocateMemory_CPU(T ***xs, T **xp, T **xp2, T ***us, T **up, T ***qdds, T **qddp, T ***Minvs, T **Minvp, T **xGoal, T **P, T **Pp, T **p, T **pp, 
						T **AB, T **H, T **g, T **KT, T **du, T ***ds, T **d, T **dp, T **ApBK, T **Bdu, T ***JTs, T **dJexp, T **alpha, int **err, 
						int *ld_x, int *ld_u, int *ld_P, int *ld_p, int *ld_AB, int *ld_H, int *ld_g, int *ld_KT, int *ld_du, int *ld_d, int *ld_A, 
						T **I = nullptr, T **Tbody = nullptr){
	// allocate the xs and us and ds (and JTs)
	*xs = (T **)malloc(NUM_ALPHA*sizeof(T*));
	*us = (T **)malloc(NUM_ALPHA*sizeof(T*));
    *qdds = (T **)malloc(NUM_ALPHA*sizeof(T*));
	*ds = (T **)malloc(NUM_ALPHA*sizeof(T*));
	*JTs = (T **)malloc(NUM_ALPHA*sizeof(T*));
    *Minvs = (T **)malloc(NUM_ALPHA*sizeof(T*));
    // allocate memory for x,u with pitched malloc and thus collect the lds (for now just set ld = DIM_<>_r)
    *ld_x = DIM_x_r;    *ld_u = DIM_u_r;
    *xp = (T *)malloc((*ld_x)*KNOT_POINTS*sizeof(T)); 
    *xp2 = (T *)malloc((*ld_x)*KNOT_POINTS*sizeof(T));
    *up = (T *)malloc((*ld_x)*KNOT_POINTS*sizeof(T));
    int goalSize = EE_COST ? 6 : STATE_SIZE;
    *xGoal = (T *)malloc(goalSize*sizeof(T));
    // allocate memory for vars with pitched malloc and thus collect the lds (for now just set ld = DIM_<>_r)
    *ld_AB = DIM_AB_r;  *ld_P = DIM_P_r;    *ld_p = DIM_p_r;    *ld_H = DIM_H_r;
    *ld_g = DIM_g_r;    *ld_KT = DIM_KT_r;  *ld_du = DIM_du_r;  *ld_d = DIM_d_r;    *ld_A = DIM_A_r;
    *P = (T *)malloc((*ld_P)*DIM_P_c*KNOT_POINTS*sizeof(T));
    *Pp = (T *)malloc((*ld_P)*DIM_P_c*KNOT_POINTS*sizeof(T));
    *p = (T *)malloc((*ld_p)*KNOT_POINTS*sizeof(T));
    *pp = (T *)malloc((*ld_p)*KNOT_POINTS*sizeof(T));
    *AB = (T *)malloc((*ld_AB)*DIM_AB_c*KNOT_POINTS*sizeof(T));
    *H = (T *)malloc((*ld_H)*DIM_H_c*KNOT_POINTS*sizeof(T));
    *g = (T *)malloc((*ld_g)*KNOT_POINTS*sizeof(T));
    *KT = (T *)malloc((*ld_KT)*DIM_KT_c*KNOT_POINTS*sizeof(T));
    *du = (T *)malloc((*ld_du)*KNOT_POINTS*sizeof(T));
    *d = (T *)malloc((*ld_d)*KNOT_POINTS*sizeof(T));
    *dp = (T *)malloc((*ld_d)*KNOT_POINTS*sizeof(T));
    *Bdu = (T *)malloc((*ld_d)*KNOT_POINTS*sizeof(T));  
    *ApBK = (T *)malloc((*ld_A)*DIM_A_c*KNOT_POINTS*sizeof(T));  
    *dJexp = (T *)malloc(2*M_BLOCKS_B*sizeof(T));
    // allocate and init alpha
    *alpha = (T *)malloc(NUM_ALPHA*sizeof(T));
    for (int i=0; i<NUM_ALPHA; i++){(*alpha)[i] = std::pow(ALPHA_BASE,i);}
    *err = (int *)malloc(M_BLOCKS_B*sizeof(int));
    // load in the Inertia and Tbody if requested
    if (I != nullptr){*I = (T *)malloc(36*NUM_POS*sizeof(T));   initI<T>(*I);}
    if (Tbody != nullptr){*Tbody = (T *)malloc(36*NUM_POS*sizeof(T));   initT<T>(*Tbody);}
    // then finish the allocations for the double *s
    for (int i = 0; i < NUM_ALPHA; i++){
        (*xs)[i] = (T *)malloc((*ld_x)*KNOT_POINTS*sizeof(T));
        (*us)[i] = (T *)malloc((*ld_u)*KNOT_POINTS*sizeof(T));
        (*qdds)[i] = (T *)malloc(NUM_POS*KNOT_POINTS*sizeof(T));
        (*ds)[i] = (T *)malloc((*ld_d)*KNOT_POINTS*sizeof(T));
        (*JTs)[i] = (T *)malloc(std::max(FSIM_THREADS,std::max(COST_THREADS,INTEGRATOR_THREADS))*sizeof(T));
        (*Minvs)[i] = (T *)malloc(NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
    }
    *qddp = (T *)malloc(NUM_POS*KNOT_POINTS*sizeof(T)); 
    *Minvp = (T *)malloc(NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T)); 
}

template <typename T>
void freeMemory_CPU(T **xs, T *xp, T *xp2, T **us, T *up, T **qdds, T *qddp, T **Minvs, T *Minvp, T *P, T *Pp, T *p, T *pp, T *AB, T *H, T *g, T *KT, T *du, T **ds, T *d, T *dp, T *Bdu, T *ApBK, 
                    T *dJexp, int *err, T *alpha, T **JTs, T *xGoal, T *I = nullptr, T *Tbody = nullptr){
	free(xp);   free(xp2);  free(up);   free(P);    free(Pp);   free(p);    free(pp);    free(AB);
    free(H);    free(g);    free(KT);   free(du);   free(d);    free(dp);   free(Bdu);   free(ApBK); 
    free(dJexp);    free(err);  free(alpha);    free(xGoal);    if (I != nullptr){free(I);}    if (Tbody != nullptr){free(Tbody);}
	for (int i = 0; i < NUM_ALPHA; i++){
		free(xs[i]); free(us[i]); free(qdds[i]); free(ds[i]); free(JTs[i]); free(Minvs[i]);
	}
	free(xs); free(us); free(ds);  free(qdds); free(JTs); free(Minvs); free(qddp); free(Minvp);
}