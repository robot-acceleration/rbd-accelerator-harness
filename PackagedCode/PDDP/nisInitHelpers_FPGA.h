template <typename T, int KNOT_POINTS, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false>
void nextIterationSetupFPGA_split(T **xs, T *xp, T **us, T *up, T **ds, T *dp, T **qdds, T *qddp, T **Minvs, T *Minvp, T *AB, T *H, T *g, T *P, T *p, T *Pp, T *pp, \
                              T *xGoal, std::thread *threads, int *alphaIndex, int ld_x, int ld_u, int ld_d, int ld_AB, int ld_H, int ld_g, int ld_P, int ld_p, T dt, \
                              T *v, T *a, T *f, T *Tfinal, T *I, T *Tbody, T *cdq, T *cdqd,
                              FPGADataIn_v1<KNOT_POINTS,NUM_POS> *dataIn, FPGADataOut<KNOT_POINTS,NUM_POS> *dataOut, unsigned int fpgaIn, unsigned int fpgaOut, \
                              T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q1, T Q2, T R, T QF1, T QF2, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
   // Compute derivatives for next pass(AB,H,g) also save x, u, J, P, p into prev variables
   // first compute v,a,f in threads
   threadDesc_t desc;  desc.dim = INTEGRATOR_THREADS;
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){
      desc.tid = thread_i;    desc.reps = compute_reps(thread_i,INTEGRATOR_THREADS,(KNOT_POINTS-1));
      threads[thread_i] = std::thread(&integratorGradientThreaded_start<T,QDD_PASSED_IN,MINV_PASSED_IN,MPC_MODE>, desc, std::ref(xs[*alphaIndex]), std::ref(us[*alphaIndex]), 
                                                                                                         std::ref(qdds[*alphaIndex]), std::ref(Minvs[*alphaIndex]), 
                                                                                                         std::ref(v), std::ref(a), std::ref(f), std::ref(Tfinal), 
                                                                                                         ld_x, ld_u, std::ref(I), std::ref(Tbody));
      if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS + thread_i);}
   }
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}

   // run the accelerator to get the gradients
   connectallWrapper_1<T,KNOT_POINTS,NUM_POS>(v,a,f,xs[*alphaIndex],cdq,cdqd,ld_x,dataIn,dataOut,fpgaIn,fpgaOut);

   // then launch the other CPU activites
   desc.dim = COST_THREADS;
   for (unsigned int thread_i = 0; thread_i < COST_THREADS; thread_i++){
      desc.tid = thread_i;    desc.reps = compute_reps(thread_i,COST_THREADS,KNOT_POINTS);
      threads[thread_i] = std::thread(&costGradientHessianThreaded<T,KNOT_POINTS>, desc, std::ref(xs[*alphaIndex]), std::ref(us[*alphaIndex]), std::ref(g), std::ref(H), std::ref(xGoal), 
                                                                       ld_x, ld_u, ld_H, ld_g, Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom,nullptr);
      if(FORCE_CORE_SWITCHES){setCPUForThread(threads,thread_i);}
   }
   // also copy P,p into Pp,pp
   std::memcpy(Pp,P,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));                std::memcpy(pp,p,ld_p*KNOT_POINTS*sizeof(T));
   // these can finish during the backpass before the forward pass (but we sync here because fast and more straightforward)
   std::memcpy(xp,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T));          std::memcpy(up,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T));
   std::memcpy(qddp,qdds[*alphaIndex],NUM_POS*KNOT_POINTS*sizeof(T));   std::memcpy(Minvp,Minvs[*alphaIndex],NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
   // sync on all active things
   for (unsigned int thread_i = 0; thread_i < COST_THREADS; thread_i++){threads[thread_i].join();}

   // then finish the integrator gradient in threads
   desc.dim = INTEGRATOR_THREADS;
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){
      desc.tid = thread_i;    desc.reps = compute_reps(thread_i,INTEGRATOR_THREADS,(KNOT_POINTS-1));
      threads[thread_i] = std::thread(&integratorGradientThreaded_finish<T>, desc, std::ref(Minvs[*alphaIndex]), std::ref(cdq), std::ref(cdqd), std::ref(AB), ld_AB, dt);
      if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS + thread_i);}
   }
   // and copy x,u,d to all x,u,d on the main thread
   memcpyArr<T>(xs,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
   memcpyArr<T>(us,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
   #if M_BLOCKS_F > 1
      memcpyArr<T>(ds,ds[*alphaIndex],ld_d*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
   #endif
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}
}

template <typename T, int KNOT_POINTS, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false>
void nextIterationSetupFPGA_fused(T **xs, T *xp, T **us, T *up, T **ds, T *dp, T **qdds, T *qddp, T **Minvs, T *Minvp, T *AB, T *H, T *g, T *P, T *p, T *Pp, T *pp, \
                              T *xGoal, std::thread *threads, int *alphaIndex, int ld_x, int ld_u, int ld_d, int ld_AB, int ld_H, int ld_g, int ld_P, int ld_p, T dt, \
                              T *I, T *Tbody, T *cdq, T *cdqd, FPGADataIn_v2<KNOT_POINTS,NUM_POS> *dataIn, FPGADataOut<KNOT_POINTS,NUM_POS> *dataOut, unsigned int fpgaIn, unsigned int fpgaOut, \
                              T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q1, T Q2, T R, T QF1, T QF2, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
   
   // run the accelerator to get the gradients
   connectallWrapper_2<T,KNOT_POINTS,NUM_POS>(xs[*alphaIndex],qdds[*alphaIndex],cdq,cdqd,ld_x,dataIn,dataOut,fpgaIn,fpgaOut);

   // launch the other CPU activites
   threadDesc_t desc;  desc.dim = COST_THREADS;
   for (unsigned int thread_i = 0; thread_i < COST_THREADS; thread_i++){
      desc.tid = thread_i;    desc.reps = compute_reps(thread_i,COST_THREADS,KNOT_POINTS);
      threads[thread_i] = std::thread(&costGradientHessianThreaded<T,KNOT_POINTS>, desc, std::ref(xs[*alphaIndex]), std::ref(us[*alphaIndex]), std::ref(g), std::ref(H), std::ref(xGoal), 
                                                                       ld_x, ld_u, ld_H, ld_g, Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom,nullptr);
      if(FORCE_CORE_SWITCHES){setCPUForThread(threads,thread_i);}
   }
   // also copy P,p into Pp,pp
   std::memcpy(Pp,P,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));                std::memcpy(pp,p,ld_p*KNOT_POINTS*sizeof(T));
   // these can finish during the backpass before the forward pass (but we sync here because fast and more straightforward)
   std::memcpy(xp,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T));          std::memcpy(up,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T));
   std::memcpy(qddp,qdds[*alphaIndex],NUM_POS*KNOT_POINTS*sizeof(T));   std::memcpy(Minvp,Minvs[*alphaIndex],NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
   // sync on all active things
   for (unsigned int thread_i = 0; thread_i < COST_THREADS; thread_i++){threads[thread_i].join();}

   // then finish the integrator gradient in threads
   desc.dim = INTEGRATOR_THREADS;
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){
      desc.tid = thread_i;    desc.reps = compute_reps(thread_i,INTEGRATOR_THREADS,(KNOT_POINTS-1));
      threads[thread_i] = std::thread(&integratorGradientThreaded_finish<T>, desc, std::ref(Minvs[*alphaIndex]), std::ref(cdq), std::ref(cdqd), std::ref(AB), ld_AB, dt);
      if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS + thread_i);}
   }
   // and copy x,u,d to all x,u,d on the main thread
   memcpyArr<T>(xs,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
   memcpyArr<T>(us,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
   #if M_BLOCKS_F > 1
      memcpyArr<T>(ds,ds[*alphaIndex],ld_d*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
   #endif
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}
}

#if EE_COST
   template <typename T, int KNOT_POINTS, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false>
   void nextIterationSetupFPGA_splitEE(T **xs, T *xp, T **us, T *up, T **ds, T *dp, T **qdds, T *qddp, T **Minvs, T *Minvp, T *AB, T *H, T *g, T *P, T *p, T *Pp, T *pp, \
                              T *xGoal, std::thread *threads, int *alphaIndex, int ld_x, int ld_u, int ld_d, int ld_AB, int ld_H, int ld_g, int ld_P, int ld_p, T dt, \
                              T *v, T *a, T *f, T *Tfinal, T *I, T *Tbody, T *cdq, T *cdqd, \
                              FPGADataIn_v1<KNOT_POINTS,NUM_POS> *dataIn, FPGADataOut<KNOT_POINTS,NUM_POS> *dataOut, unsigned int fpgaIn, unsigned int fpgaOut, \
                              T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
   // Compute derivatives for next pass(AB,H,g) also save x, u, J, P, p into prev variables
   // first compute v,a,f and cost in threads with the cost
   threadDesc_t desc;  desc.dim = INTEGRATOR_THREADS;
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){
      desc.tid = thread_i;    desc.reps = compute_reps(thread_i,INTEGRATOR_THREADS,(KNOT_POINTS-1));
      threads[thread_i] = std::thread(&integratorCostEEGradientThreaded_start<T,KNOT_POINTS,QDD_PASSED_IN,MINV_PASSED_IN,MPC_MODE>, desc, std::ref(xs[*alphaIndex]), std::ref(us[*alphaIndex]), 
                                                                                                               std::ref(qdds[*alphaIndex]), std::ref(Minvs[*alphaIndex]), 
                                                                                                               std::ref(v), std::ref(a), std::ref(f), std::ref(Tfinal),
                                                                                                               std::ref(H), std::ref(g), std::ref(I), std::ref(xGoal),
                                                                                                               ld_x, ld_u, ld_H, ld_g,
                                                                                                               Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom,nullptr);
      if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS + thread_i);}
   }
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}

   // run the accelerator to get the gradients
   connectallWrapper_1<T,KNOT_POINTS,NUM_POS>(v,a,f,xs[*alphaIndex],cdq,cdqd,ld_x,dataIn,dataOut,fpgaIn,fpgaOut);

   // then finish the integrator gradient in threads
   desc.dim = INTEGRATOR_THREADS;
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){
      desc.tid = thread_i;    desc.reps = compute_reps(thread_i,INTEGRATOR_THREADS,(KNOT_POINTS-1));
      threads[thread_i] = std::thread(&integratorGradientThreaded_finish<T>, desc, std::ref(Minvs[*alphaIndex]), std::ref(cdq), std::ref(cdqd), std::ref(AB), ld_AB, dt);
      if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS + thread_i);}
   }
   // while doing a bunch of copies and cleanup on the main thread
   // copy x,u,d to all x,u,d
   memcpyArr<T>(xs,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
   memcpyArr<T>(us,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
   #if M_BLOCKS_F > 1
      memcpyArr<T>(ds,ds[*alphaIndex],ld_d*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
   #endif
   // copy P,p into Pp,pp
   std::memcpy(Pp,P,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));                std::memcpy(pp,p,ld_p*KNOT_POINTS*sizeof(T));
   // these can finish during the backpass before the forward pass (but we sync here because fast and more straightforward)
   std::memcpy(xp,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T));          std::memcpy(up,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T));
   std::memcpy(qddp,qdds[*alphaIndex],NUM_POS*KNOT_POINTS*sizeof(T));   std::memcpy(Minvp,Minvs[*alphaIndex],NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
   // and note you need to do the last X cost
   desc.dim = 1; desc.tid = KNOT_POINTS-1; desc.reps = 1;
   costGradientHessianThreaded<T,KNOT_POINTS>(desc,xs[*alphaIndex],us[*alphaIndex],g,H,xGoal,ld_x,ld_u,ld_H,ld_g,Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,0.0,0.0,0.0,0.0,0.0,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}
}
#endif

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