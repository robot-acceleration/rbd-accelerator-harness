template <typename T, int KNOT_POINTS, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false>
void nextIterationSetupGPU_split(T **xs, T *xp, T **us, T *up, T **ds, T *dp, T **qdds, T *qddp, T **Minvs, T *Minvp, T *AB, T *H, T *g, T *P, T *p, T *Pp, T *pp, \
                              T *xGoal, std::thread *threads, int *alphaIndex, int ld_x, int ld_u, int ld_d, int ld_AB, int ld_H, int ld_g, int ld_P, int ld_p, T dt, \
                              cudaStream_t *streams, T *d_cdq, T *d_cdqd, T *d_v, T *d_a, T *d_f, T *d_Tfinal, T *d_x, T *d_I, \
                              T *v, T *a, T *f, T *Tfinal, T *I, T *Tbody, T *cdq, T *cdqd, dim3 gridDimms, dim3 blockDimms, \
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
   gpuErrchk(cudaMemcpyAsync(d_x, xs[*alphaIndex], ld_x*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[4])); // start this one as it doesn't rely on above comp
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}

   // then copy vars to GPU and launch the accelerated integrator gradient comps while computing other derivatives and copying variables
   // copy v,a,f,Tfinal to GPU (note I already moved because constant)
   gpuErrchk(cudaMemcpyAsync(d_v, v, 6*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[0]));
   gpuErrchk(cudaMemcpyAsync(d_a, a, 6*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[1]));
   gpuErrchk(cudaMemcpyAsync(d_f, f, 6*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[2]));
   gpuErrchk(cudaMemcpyAsync(d_Tfinal, Tfinal, 36*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[3]));
   gpuErrchk(cudaDeviceSynchronize());

   // then compute grad on GPU
   dynamicsGradientKernel_Middle<T,KNOT_POINTS-1,1><<<gridDimms,blockDimms,0,streams[0]>>>(d_cdq,d_cdqd,d_v,d_a,d_f,d_I,d_Tfinal,d_x,ld_x);

   // launch the other CPU activites while this happens
   desc.dim = COST_THREADS;
   for (unsigned int thread_i = 0; thread_i < COST_THREADS; thread_i++){
      desc.tid = thread_i;    desc.reps = compute_reps(thread_i,COST_THREADS,KNOT_POINTS);
      threads[thread_i] = std::thread(&costGradientHessianThreaded<T,KNOT_POINTS>, desc, std::ref(xs[*alphaIndex]), std::ref(us[*alphaIndex]), std::ref(g), std::ref(H), std::ref(xGoal), 
                                                                       ld_x, ld_u, ld_H, ld_g, Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom,nullptr);
      if(FORCE_CORE_SWITCHES){setCPUForThread(threads,thread_i);}
   }
    // synch on threads and accelerator
    for (unsigned int thread_i = 0; thread_i < COST_THREADS; thread_i++){threads[thread_i].join();} gpuErrchk(cudaDeviceSynchronize());

   // copy memory back while doing CPU copies
   gpuErrchk(cudaMemcpyAsync(cdq, d_cdq, NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[0]));
   gpuErrchk(cudaMemcpyAsync(cdqd, d_cdqd, NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[1]));
   // also copy P,p into Pp,pp
   std::memcpy(Pp,P,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));                std::memcpy(pp,p,ld_p*KNOT_POINTS*sizeof(T));
   // these can finish during the backpass before the forward pass (but we sync here because fast and more straightforward)
   std::memcpy(xp,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T));          std::memcpy(up,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T));
   std::memcpy(qddp,qdds[*alphaIndex],NUM_POS*KNOT_POINTS*sizeof(T));   std::memcpy(Minvp,Minvs[*alphaIndex],NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
   // sync on all active things
   gpuErrchk(cudaDeviceSynchronize());

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

template <typename T, int KNOT_POINTS, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false, bool VEL_DAMPING = true>
void nextIterationSetupGPU_fused(T **xs, T *xp, T **us, T *up, T **ds, T *dp, T **qdds, T *qddp, T **Minvs, T *Minvp, T *AB, T *H, T *g, T *P, T *p, T *Pp, T *pp, \
                              T *xGoal, std::thread *threads, int *alphaIndex, int ld_x, int ld_u, int ld_d, int ld_AB, int ld_H, int ld_g, int ld_P, int ld_p, T dt, \
                              cudaStream_t *streams, T *d_x, T *d_qdd, T *d_cdq, T *d_cdqd, T *d_I, T *d_Tbody, T *cdq, T *cdqd, T *I, T *Tbody, dim3 gridDimms, dim3 blockDimms, \
                              T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q1, T Q2, T R, T QF1, T QF2, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
   // Compute derivatives for next pass(AB,H,g) also save x, u, J, P, p into prev variables
   // launch the integrator on the accelerator and the rest on the CPU (start by moving x,u,qdd,Minv over note I/T already over there b/c constant)
   gpuErrchk(cudaMemcpyAsync(d_x, xs[*alphaIndex], ld_x*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[0]));
   gpuErrchk(cudaMemcpyAsync(d_qdd, qdds[*alphaIndex], NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[2]));
   gpuErrchk(cudaDeviceSynchronize()); 

   // then compute grad on GPU
   dynamicsGradientKernel_1stHalf<T,KNOT_POINTS-1,MPC_MODE,VEL_DAMPING><<<gridDimms,blockDimms,0,streams[0]>>>(d_cdq,d_cdqd,d_x,d_qdd,d_I,d_Tbody,ld_x);

   // launch the other CPU activites while this happens
   threadDesc_t desc;  desc.dim = COST_THREADS;
   for (unsigned int thread_i = 0; thread_i < COST_THREADS; thread_i++){
      desc.tid = thread_i;    desc.reps = compute_reps(thread_i,COST_THREADS,KNOT_POINTS);
      threads[thread_i] = std::thread(&costGradientHessianThreaded<T,KNOT_POINTS>, desc, std::ref(xs[*alphaIndex]), std::ref(us[*alphaIndex]), std::ref(g), std::ref(H), std::ref(xGoal), 
                                                                       ld_x, ld_u, ld_H, ld_g, Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom,nullptr);
      if(FORCE_CORE_SWITCHES){setCPUForThread(threads,thread_i);}
   }
   // synch on threads and accelerator
   for (unsigned int thread_i = 0; thread_i < COST_THREADS; thread_i++){threads[thread_i].join();} gpuErrchk(cudaDeviceSynchronize());

   // cppy memory back while doing CPU copies
   gpuErrchk(cudaMemcpyAsync(cdq, d_cdq, NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[0]));
   gpuErrchk(cudaMemcpyAsync(cdqd, d_cdqd, NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[1]));
   // also copy P,p into Pp,pp
   std::memcpy(Pp,P,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));                std::memcpy(pp,p,ld_p*KNOT_POINTS*sizeof(T));
   // these can finish during the backpass before the forward pass (but we sync here because fast and more straightforward)
   std::memcpy(xp,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T));          std::memcpy(up,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T));
   std::memcpy(qddp,qdds[*alphaIndex],NUM_POS*KNOT_POINTS*sizeof(T));   std::memcpy(Minvp,Minvs[*alphaIndex],NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
   // sync on all active things
   gpuErrchk(cudaDeviceSynchronize());

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
   void nextIterationSetupGPU_splitEE(T **xs, T *xp, T **us, T *up, T **ds, T *dp, T **qdds, T *qddp, T **Minvs, T *Minvp, T *AB, T *H, T *g, T *P, T *p, T *Pp, T *pp, \
                              T *xGoal, std::thread *threads, int *alphaIndex, int ld_x, int ld_u, int ld_d, int ld_AB, int ld_H, int ld_g, int ld_P, int ld_p, T dt, \
                              cudaStream_t *streams, T *d_cdq, T *d_cdqd, T *d_v, T *d_a, T *d_f, T *d_Tfinal, T *d_x, T *d_I, \
                              T *v, T *a, T *f, T *Tfinal, T *I, T *Tbody, T *cdq, T *cdqd, dim3 gridDimms, dim3 blockDimms, \
                              T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
   // Compute derivatives for next pass(AB,H,g) also save x, u, J, P, p into prev variables
   // first compute v,a,f and cost in threads
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
   gpuErrchk(cudaMemcpyAsync(d_x, xs[*alphaIndex], ld_x*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[4])); // start this one as it doesn't rely on above comp
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}

   // then copy vars to GPU and launch the accelerated integrator gradient comps while computing other derivatives and copying variables
   // copy v,a,f,Tfinal to GPU (note I already moved because constant)
   gpuErrchk(cudaMemcpyAsync(d_v, v, 6*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[0]));
   gpuErrchk(cudaMemcpyAsync(d_a, a, 6*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[1]));
   gpuErrchk(cudaMemcpyAsync(d_f, f, 6*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[2]));
   gpuErrchk(cudaMemcpyAsync(d_Tfinal, Tfinal, 36*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[3]));
   gpuErrchk(cudaDeviceSynchronize());

   // then compute grad on GPU
   dynamicsGradientKernel_Middle<T,KNOT_POINTS-1,1><<<gridDimms,blockDimms,0,streams[0]>>>(d_cdq,d_cdqd,d_v,d_a,d_f,d_I,d_Tfinal,d_x,ld_x);

   // since cost is done start doing local memory copies on the CPU while this happens
   // copy x,u,d to all x,u,d on the main thread
   memcpyArr<T>(xs,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
   memcpyArr<T>(us,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
   #if M_BLOCKS_F > 1
      memcpyArr<T>(ds,ds[*alphaIndex],ld_d*KNOT_POINTS*sizeof(T),NUM_ALPHA,*alphaIndex);
   #endif
   // and note you need to do the last X cost
   desc.dim = 1; desc.tid = KNOT_POINTS-1; desc.reps = 1;
   costGradientHessianThreaded<T,KNOT_POINTS>(desc,xs[*alphaIndex],us[*alphaIndex],g,H,xGoal,ld_x,ld_u,ld_H,ld_g,Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,0.0,0.0,0.0,0.0,0.0,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
   gpuErrchk(cudaDeviceSynchronize());

   // copy memory back while doing more CPU copies
   gpuErrchk(cudaMemcpyAsync(cdq, d_cdq, NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[0]));
   gpuErrchk(cudaMemcpyAsync(cdqd, d_cdqd, NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[1]));
   // copy P,p into Pp,pp
   std::memcpy(Pp,P,ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));                std::memcpy(pp,p,ld_p*KNOT_POINTS*sizeof(T));
   // these can finish during the backpass before the forward pass (but we sync here because fast and more straightforward)
   std::memcpy(xp,xs[*alphaIndex],ld_x*KNOT_POINTS*sizeof(T));          std::memcpy(up,us[*alphaIndex],ld_u*KNOT_POINTS*sizeof(T));
   std::memcpy(qddp,qdds[*alphaIndex],NUM_POS*KNOT_POINTS*sizeof(T));   std::memcpy(Minvp,Minvs[*alphaIndex],NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
   gpuErrchk(cudaDeviceSynchronize());

   // then finish the integrator gradient in threads
   desc.dim = INTEGRATOR_THREADS;
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){
      desc.tid = thread_i;    desc.reps = compute_reps(thread_i,INTEGRATOR_THREADS,(KNOT_POINTS-1));
      threads[thread_i] = std::thread(&integratorGradientThreaded_finish<T>, desc, std::ref(Minvs[*alphaIndex]), std::ref(cdq), std::ref(cdqd), std::ref(AB), ld_AB, dt);
      if(FORCE_CORE_SWITCHES){setCPUForThread(threads, COST_THREADS + thread_i);}
   }
   for (unsigned int thread_i = 0; thread_i < INTEGRATOR_THREADS; thread_i++){threads[thread_i].join();}
}
#endif

template <typename T, int KNOT_POINTS>
void allocateMemory_GPU(T **d_x, T **d_qdd, T **d_Minv, T **d_AB, T **d_v, T **d_a, T **d_f, T **d_I, T **d_Tbody, T **d_Tfinal, T **d_cdq, T **d_cdqd, 
               T **v, T **a, T **f, T **Tfinal, T **cdq, T **cdqd, cudaStream_t **streams, int ld_x, int ld_AB, T *I, T *Tbody){
   gpuErrchk(cudaMalloc((void**)d_x, ld_x*KNOT_POINTS*sizeof(T)));
   gpuErrchk(cudaMalloc((void**)d_qdd, NUM_POS*KNOT_POINTS*sizeof(T)));
   gpuErrchk(cudaMalloc((void**)d_Minv, NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T)));
   gpuErrchk(cudaMalloc((void**)d_AB, ld_AB*DIM_AB_c*KNOT_POINTS*sizeof(T)));
   gpuErrchk(cudaMalloc((void**)d_v, 6*NUM_POS*KNOT_POINTS*sizeof(T)));
   gpuErrchk(cudaMalloc((void**)d_a, 6*NUM_POS*KNOT_POINTS*sizeof(T)));
   gpuErrchk(cudaMalloc((void**)d_f, 6*NUM_POS*KNOT_POINTS*sizeof(T)));
   gpuErrchk(cudaMalloc((void**)d_I, 36*NUM_POS*sizeof(T))); gpuErrchk(cudaMemcpy(*d_I, I, 36*NUM_POS*sizeof(T), cudaMemcpyHostToDevice));
   gpuErrchk(cudaMalloc((void**)d_Tbody, 36*NUM_POS*sizeof(T))); gpuErrchk(cudaMemcpy(*d_Tbody, Tbody, 36*NUM_POS*sizeof(T), cudaMemcpyHostToDevice));
   gpuErrchk(cudaMalloc((void**)d_Tfinal, 36*NUM_POS*KNOT_POINTS*sizeof(T)));
   gpuErrchk(cudaMalloc((void**)d_cdq, NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T)));
   gpuErrchk(cudaMalloc((void**)d_cdqd, NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T)));
   int priority, minPriority, maxPriority;
   gpuErrchk(cudaDeviceGetStreamPriorityRange(&minPriority, &maxPriority));
   *streams = (cudaStream_t *)malloc(NUM_STREAMS*sizeof(cudaStream_t));
   for(int i=0; i<NUM_STREAMS; i++){
      priority = min(minPriority+i,maxPriority);
      gpuErrchk(cudaStreamCreateWithPriority(&((*streams)[i]),cudaStreamNonBlocking,priority));
   }
   *v = (T *)malloc(6*NUM_POS*KNOT_POINTS*sizeof(T));
   *a = (T *)malloc(6*NUM_POS*KNOT_POINTS*sizeof(T));
   *f = (T *)malloc(6*NUM_POS*KNOT_POINTS*sizeof(T));
   *Tfinal = (T *)malloc(36*NUM_POS*KNOT_POINTS*sizeof(T));
   *cdq = (T *)malloc(NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
   *cdqd = (T *)malloc(NUM_POS*NUM_POS*KNOT_POINTS*sizeof(T));
}

template <typename T>
void freeMemory_GPU(T *d_x, T *d_qdd, T *d_Minv, T *d_AB, T *d_v, T *d_a, T *d_f, T *d_I, T *d_Tbody, T *d_Tfinal, T *d_cdq, T *d_cdqd, 
               T *v, T *a, T *f, T *Tfinal, T *cdq, T *cdqd, cudaStream_t *streams){
   gpuErrchk(cudaFree(d_x)); gpuErrchk(cudaFree(d_qdd)); gpuErrchk(cudaFree(d_Minv)); gpuErrchk(cudaFree(d_AB));
   gpuErrchk(cudaFree(d_v)); gpuErrchk(cudaFree(d_a)); gpuErrchk(cudaFree(d_f)); gpuErrchk(cudaFree(d_I));
   gpuErrchk(cudaFree(d_Tbody)); gpuErrchk(cudaFree(d_Tfinal)); gpuErrchk(cudaFree(d_cdq));gpuErrchk(cudaFree(d_cdqd));
   for(int i=0; i<NUM_STREAMS; i++){gpuErrchk(cudaStreamDestroy(streams[i]));} free(streams);
   free(v); free(a); free(f); free(Tfinal); free(cdq); free(cdqd); 
}