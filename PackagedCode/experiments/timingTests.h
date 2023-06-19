template <typename T, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = false>
void compute_qddMinv(T *Minv, T *qdd, T *x, T *u, T *I, T *Tbody, int ld_x, int ld_u){
	for (int k = 0; k < KNOT_POINTS; k++){forwardDynamics<T,MPC_MODE>(&qdd[k*NUM_LINKS], &u[k*ld_u], &x[k*ld_x + NUM_LINKS], &x[k*ld_x], I, Tbody, &Minv[k*NUM_LINKS*NUM_LINKS]);}
}

template <typename T, int KNOT_POINTS, bool MPC_MODE = false>
void computeGradientThreaded_Start(T *x, T *u, T *qdd, T *v, T *a, T *f, T *I, T *Tbody, T *Tfinal, int ld_x, int ld_u, std::thread *threads){
    threadDesc_t desc;  desc.dim = DYNAMICS_GRAD_THREADS;
    for (unsigned int thread_i = 0; thread_i < DYNAMICS_GRAD_THREADS; thread_i++){
        desc.tid = thread_i;    desc.reps = compute_reps(thread_i,DYNAMICS_GRAD_THREADS,KNOT_POINTS);
        threads[thread_i] = std::thread(&dynamicsGradientThreaded_Start<T,1,MPC_MODE>, desc, std::ref(x), std::ref(u), std::ref(qdd), std::ref(v), std::ref(a), std::ref(f), 
        																		ld_x, ld_u, std::ref(I), std::ref(Tbody), std::ref(Tfinal));
        if(FORCE_CORE_SWITCHES){setCPUForThread(threads, DYNAMICS_GRAD_THREADS + thread_i);}
    }
    for (unsigned int thread_i = 0; thread_i < DYNAMICS_GRAD_THREADS; thread_i++){threads[thread_i].join();}
}

template <typename T, int KNOT_POINTS>
void computeGradientThreaded_Middle(T *cdq, T *cdqd, T *x, T *v, T *a, T *f, T *Tfinal, T *I, int ld_x, std::thread *threads){
    threadDesc_t desc;  desc.dim = DYNAMICS_GRAD_THREADS;
    for (unsigned int thread_i = 0; thread_i < DYNAMICS_GRAD_THREADS; thread_i++){
        desc.tid = thread_i;    desc.reps = compute_reps(thread_i,DYNAMICS_GRAD_THREADS,KNOT_POINTS);
	        threads[thread_i] = std::thread(&dynamicsGradientThreaded_Middle<T>, desc, std::ref(cdq), std::ref(cdqd), std::ref(x), std::ref(v), std::ref(a), std::ref(f), 
	        																     std::ref(Tfinal), std::ref(I), ld_x);
	        if(FORCE_CORE_SWITCHES){setCPUForThread(threads, DYNAMICS_GRAD_THREADS + thread_i);}
    }
	for (unsigned int thread_i = 0; thread_i < DYNAMICS_GRAD_THREADS; thread_i++){threads[thread_i].join();}
}

template <typename T, int KNOT_POINTS>
void computeGradientThreaded_Finish(T *cdq, T *cdqd, T *Minv, T *dqdd, std::thread *threads){
    threadDesc_t desc;  desc.dim = DYNAMICS_GRAD_THREADS;
    for (unsigned int thread_i = 0; thread_i < DYNAMICS_GRAD_THREADS; thread_i++){
        desc.tid = thread_i;    desc.reps = compute_reps(thread_i,DYNAMICS_GRAD_THREADS,KNOT_POINTS);
	        threads[thread_i] = std::thread(&dynamicsGradientThreaded_Finish<T>, desc, std::ref(cdq), std::ref(cdqd), std::ref(Minv), std::ref(dqdd));
	        if(FORCE_CORE_SWITCHES){setCPUForThread(threads, DYNAMICS_GRAD_THREADS + thread_i);}
    }
	for (unsigned int thread_i = 0; thread_i < DYNAMICS_GRAD_THREADS; thread_i++){threads[thread_i].join();}
}

template <typename T, int KNOT_POINTS, bool MPC_MODE = false>
void dynamicsGradientThreaded_split(T *x, T *u, T *qdd, T *Minv, T *dqdd, T *I, T *Tbody, T *v, T *a, T *f, T *Tfinal, T *cdq, T *cdqd, \
							       int ld_x, int ld_u, std::thread *threads, std::vector<double> *test_times, std::vector<double> *test_times1,
							       std::vector<double> *test_times2, std::vector<double> *test_times3){
	struct timeval start, start1, start2, start3, end, end1, end2, end3; gettimeofday(&start,NULL); gettimeofday(&start1,NULL);
	computeGradientThreaded_Start<T,KNOT_POINTS,MPC_MODE>(x,u,qdd,v,a,f,I,Tbody,Tfinal,ld_x,ld_u,threads);
    gettimeofday(&end1,NULL);

	gettimeofday(&start2,NULL);
	computeGradientThreaded_Middle<T,KNOT_POINTS>(cdq,cdqd,x,v,a,f,Tfinal,I,ld_x,threads);
	gettimeofday(&end2,NULL);
	
	gettimeofday(&start3,NULL);
	computeGradientThreaded_Finish<T,KNOT_POINTS>(cdq,cdqd,Minv,dqdd,threads);
    gettimeofday(&end3,NULL); gettimeofday(&end,NULL);
    
    test_times->push_back(time_delta_us(start,end));
    test_times1->push_back(time_delta_us(start1,end1));
    test_times2->push_back(time_delta_us(start2,end2));
    test_times3->push_back(time_delta_us(start3,end3));
}

template <typename T, int KNOT_POINTS, bool MPC_MODE = false>
void computeGradientThreaded_old(T *x, T *u, T *qdd, T *Minv, T *dqdd, int ld_x, int ld_u, T *I, T *Tbody, 
	                          bool MinvGoodFlag, std::thread *threads, std::vector<double> *test_times){
	struct timeval start, end; gettimeofday(&start,NULL);
	threadDesc_t desc;  desc.dim = DYNAMICS_GRAD_THREADS;
	for (unsigned int thread_i = 0; thread_i < DYNAMICS_GRAD_THREADS; thread_i++){
    	desc.tid = thread_i;    desc.reps = compute_reps(thread_i,DYNAMICS_GRAD_THREADS,KNOT_POINTS);
	        threads[thread_i] = std::thread(&dynamicsGradientThreaded_old<T,1,1,MPC_MODE>, desc, std::ref(x), std::ref(u), std::ref(qdd), \
	                                                                                  std::ref(Minv), std::ref(dqdd), ld_x, ld_u, \
	                                                                                  std::ref(I), std::ref(Tbody), MinvGoodFlag);
        if(FORCE_CORE_SWITCHES){setCPUForThread(threads, thread_i);}
    }
    for (unsigned int thread_i = 0; thread_i < DYNAMICS_GRAD_THREADS; thread_i++){threads[thread_i].join();}
	gettimeofday(&end,NULL); test_times->push_back(time_delta_us(start,end));
}

template <typename T, int KNOT_POINTS, bool MPC_MODE = false>
void computeGradientThreaded(T *x, T *u, T *qdd, T *Minv, T *dqdd, int ld_x, int ld_u, T *I, T *Tbody, 
	                          bool MinvGoodFlag, std::thread *threads, std::vector<double> *test_times){
	struct timeval start, end; gettimeofday(&start,NULL);
	threadDesc_t desc;  desc.dim = DYNAMICS_GRAD_THREADS;
	for (unsigned int thread_i = 0; thread_i < DYNAMICS_GRAD_THREADS; thread_i++){
    	desc.tid = thread_i;    desc.reps = compute_reps(thread_i,DYNAMICS_GRAD_THREADS,KNOT_POINTS);
	        threads[thread_i] = std::thread(&dynamicsGradientThreaded<T,1,1,MPC_MODE>, desc, std::ref(x), std::ref(u), std::ref(qdd), \
	                                                                                  std::ref(Minv), std::ref(dqdd), ld_x, ld_u, \
	                                                                                  std::ref(I), std::ref(Tbody), MinvGoodFlag);
        if(FORCE_CORE_SWITCHES){setCPUForThread(threads, thread_i);}
    }
    for (unsigned int thread_i = 0; thread_i < DYNAMICS_GRAD_THREADS; thread_i++){threads[thread_i].join();}
	gettimeofday(&end,NULL); test_times->push_back(time_delta_us(start,end));
}

template <typename T, int SINGLE_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false, bool VEL_DAMPING = true>
void CPU_singleCall(T *d_x, T *d_u, T *d_qdd, T *d_Minv, T *d_dqdd, int ld_x, int ld_u, T *I, T *Tbody, bool MinvGoodFlag){
	T s_cdq[NUM_LINKS*NUM_LINKS]; T s_cdqd[NUM_LINKS*NUM_LINKS]; T s_v[6*NUM_LINKS]; T s_a[6*NUM_LINKS]; T s_f[6*NUM_LINKS]; T s_T[36*NUM_LINKS]; 
	struct timeval start, end; gettimeofday(&start,NULL);
	for(int iter = 0; iter < SINGLE_CALL_ITERS; iter++){
		int k = iter % KNOT_POINTS; T *xk = &d_x[k*ld_x]; T *uk = &d_u[k*ld_u]; T *qddk = &d_qdd[k*NUM_LINKS]; T *Minvk = &d_Minv[k*NUM_LINKS*NUM_LINKS];
		if (QDD_PASSED_IN && MINV_PASSED_IN && MinvGoodFlag){forwardDynamicsGradientSetupSimple_old<T,MPC_MODE>(s_v,s_a,s_f,s_T,Tbody,I,xk,&xk[NUM_LINKS],qddk);}
		else{forwardDynamicsGradientSetup_old<T,QDD_PASSED_IN,MPC_MODE>(s_v,s_a,s_f,Minvk,s_T,qddk,uk,&xk[NUM_LINKS],xk,I,Tbody);}
	}
	gettimeofday(&end,NULL); printf("     vaf: %fus\n",time_delta_us(start,end)/static_cast<T>(SINGLE_CALL_ITERS)); gettimeofday(&start,NULL);
	for(int iter = 0; iter < SINGLE_CALL_ITERS; iter++){
		int k = iter % KNOT_POINTS; T *xk = &d_x[k*ld_x]; T *uk = &d_u[k*ld_u]; T *qddk = &d_qdd[k*NUM_LINKS]; T *Minvk = &d_Minv[k*NUM_LINKS*NUM_LINKS];
		if (QDD_PASSED_IN && MINV_PASSED_IN && MinvGoodFlag){forwardDynamicsGradientSetupSimple<T,MPC_MODE>(s_v,s_a,s_f,s_T,Tbody,I,xk,&xk[NUM_LINKS],qddk);}
		else{forwardDynamicsGradientSetup<T,QDD_PASSED_IN,MPC_MODE>(s_v,s_a,s_f,Minvk,s_T,qddk,uk,&xk[NUM_LINKS],xk,I,Tbody);}
	}
	gettimeofday(&end,NULL); printf("     vaf with TmatMult: %fus\n",time_delta_us(start,end)/static_cast<T>(SINGLE_CALL_ITERS)); gettimeofday(&start,NULL);
	for(int iter = 0; iter < SINGLE_CALL_ITERS; iter++){
		int k = iter % KNOT_POINTS; T *xk = &d_x[k*ld_x];
		inverseDynamicsGradient_old<T,VEL_DAMPING>(s_cdq,s_cdqd,&xk[NUM_LINKS],s_v,s_a,s_f,I,s_T);
	}
	gettimeofday(&end,NULL); printf("   dc/du: %fus\n",time_delta_us(start,end)/static_cast<T>(SINGLE_CALL_ITERS)); gettimeofday(&start,NULL);
	for(int iter = 0; iter < SINGLE_CALL_ITERS; iter++){
		int k = iter % KNOT_POINTS; T *xk = &d_x[k*ld_x];
		inverseDynamicsGradient<T,VEL_DAMPING>(s_cdq,s_cdqd,&xk[NUM_LINKS],s_v,s_a,s_f,I,s_T);
	}
	gettimeofday(&end,NULL); printf("   dc/du with TmatMult: %fus\n",time_delta_us(start,end)/static_cast<T>(SINGLE_CALL_ITERS)); gettimeofday(&start,NULL);
	for(int iter = 0; iter < SINGLE_CALL_ITERS; iter++){
		int k = iter % KNOT_POINTS; T *Minvk = &d_Minv[k*NUM_LINKS*NUM_LINKS]; T *dqddk = &d_dqdd[k*2*NUM_LINKS*NUM_LINKS];
		matMultSym<T,NUM_LINKS,NUM_LINKS,NUM_LINKS>(dqddk,NUM_LINKS,Minvk,NUM_LINKS,s_cdq,NUM_LINKS,static_cast<T>(-1));
		matMultSym<T,NUM_LINKS,NUM_LINKS,NUM_LINKS>(&dqddk[NUM_LINKS*NUM_LINKS],NUM_LINKS,Minvk,NUM_LINKS,s_cdqd,NUM_LINKS,static_cast<T>(-1));
	}
	gettimeofday(&end,NULL); printf("    rest: %fus\n",time_delta_us(start,end)/static_cast<T>(SINGLE_CALL_ITERS));
}

template<typename T, int SINGLE_CALL_ITERS, int PARALLEL_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = false>
void testCPUTiming(){
	printf("Allocating and setting up...\n");
	printf("-----------------\n");
	// allocate variables
	std::thread threads[DYNAMICS_GRAD_THREADS];
	bool MinvGoodFlag = true; int ld_x = 2*NUM_LINKS; int ld_u = NUM_LINKS;
	T *x = (T *)malloc(ld_x*KNOT_POINTS*sizeof(T));
	T *u = (T *)malloc(ld_u*KNOT_POINTS*sizeof(T));
	T *qdd = (T *)malloc(NUM_LINKS*KNOT_POINTS*sizeof(T));
	T *Minv = (T *)malloc(NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T));
	T *dqdd = (T *)malloc(2*NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T));
	T *I = (T *)malloc(36*NUM_LINKS*sizeof(T));
	T *Tbody = (T *)malloc(36*NUM_LINKS*sizeof(T));
	T *v = (T *)malloc(6*NUM_LINKS*KNOT_POINTS*sizeof(T));
	T *a = (T *)malloc(6*NUM_LINKS*KNOT_POINTS*sizeof(T));
	T *f = (T *)malloc(6*NUM_LINKS*KNOT_POINTS*sizeof(T));
	T *Tfinal = (T *)malloc(36*NUM_LINKS*KNOT_POINTS*sizeof(T));
	T *cdq = (T *)malloc(NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T));
	T *cdqd = (T *)malloc(NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T));
	std::vector<double> test_times, test_times1, test_times2, test_times3, test_times4, test_times5;
	
	// compute all initial values (get KNOT_POINTS random states, inputs -> qdd, MINV)
	loadXU<T,KNOT_POINTS,NUM_LINKS,0>(x,u,ld_x,ld_u); initI<T>(I); initT<T>(Tbody);
	compute_qddMinv<T,KNOT_POINTS,NUM_LINKS,MPC_MODE>(Minv,qdd,x,u,I,Tbody,ld_x,ld_u);
	printf("Setup Complte -- starting tests...\n");
	printf("-----------------\n");

	// then run the tests
	printf("CPU Single Call:\n");
	CPU_singleCall<T,SINGLE_CALL_ITERS,KNOT_POINTS,NUM_LINKS,1,1,MPC_MODE>(x,u,qdd,Minv,dqdd,ld_x,ld_u,I,Tbody,MinvGoodFlag);
	printf("-----------------\n");

	printf("CPU-Threaded: vaf -Sync-> dc/du -Sync-> rest\n");
	for(int iter = 0; iter < PARALLEL_CALL_ITERS; iter++){
 		dynamicsGradientThreaded_split<T,KNOT_POINTS,MPC_MODE>(x,u,qdd,Minv,dqdd,I,Tbody,v,a,f,Tfinal,cdq,cdqd,ld_x,ld_u,threads,&test_times,&test_times1,&test_times2,&test_times3);
	}
	printStats("CPU-Split", test_times, "vaf  ", test_times1, "dc/du", test_times2, "Rest ", test_times3);

	printf("CPU-Threaded: fused all in one\n");
	for(int iter = 0; iter < PARALLEL_CALL_ITERS; iter++){
 		computeGradientThreaded_old<T,KNOT_POINTS,MPC_MODE>(x,u,qdd,Minv,dqdd,ld_x,ld_u,I,Tbody,MinvGoodFlag,threads,&test_times4);
	}
	printStats("CPU-Fused", test_times4);


	printf("CPU-Threaded w/ TmatMult: fused all in one\n");
	for(int iter = 0; iter < PARALLEL_CALL_ITERS; iter++){
 		computeGradientThreaded<T,KNOT_POINTS,MPC_MODE>(x,u,qdd,Minv,dqdd,ld_x,ld_u,I,Tbody,MinvGoodFlag,threads,&test_times5);
	}
	printStats("CPU-Fused w/ TmatMult", test_times5);
	printf("Tests Complte -- cleaning up\n");
	printf("-----------------\n");
	free(x); free(u); free(qdd); free(Minv); free(dqdd); free(I); free(Tbody);
	free(v); free(a); free(f); free(Tfinal); free(cdq); free(cdqd);
}

#if COMPILE_WITH_GPU
	template <typename T, int SINGLE_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = false, bool VEL_DAMPING = true>
	__global__
	void dynamicsGradientKernel_1stHalf_single(T *d_cdq, T *d_cdqd, T *d_x, T *d_qdd, T *d_I, T *d_Tbody, int ld_x, double clockRateKhz, T *s_fext = nullptr){
		int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx); int start, delta; singleLoopVals_GPU(&start,&delta);
	    __shared__ T s_q[NUM_LINKS];				__shared__ T s_qd[NUM_LINKS];				__shared__ T s_qdd[NUM_LINKS];
	    __shared__ T s_sinq[NUM_LINKS];			__shared__ T s_cosq[NUM_LINKS];			__shared__ T s_temp[42];
		__shared__ T s_v[6*NUM_LINKS];			__shared__ T s_a[6*NUM_LINKS]; 			__shared__ T s_f[6*NUM_LINKS];
		__shared__ T s_T[36*NUM_LINKS];			__shared__ T s_I[36*NUM_LINKS];			__shared__ T total_t1;
		__shared__ T s_cdq[NUM_LINKS*NUM_LINKS];	__shared__ T s_cdqd[NUM_LINKS*NUM_LINKS];	__shared__ T total_t2;
	    long long int startt, endt; double t1 = 0; double t2 = 0;
		for (int rep = 0; rep < SINGLE_CALL_ITERS; rep++){
	    	startt = clock64();
			int k = rep % KNOT_POINTS; T *xk = &d_x[k*ld_x]; T *qddk = &d_qdd[k*NUM_LINKS];
			// load in x,u,qdd,sinq,cosq,T,I and update T
			#pragma unroll
			for (int ind = start; ind < NUM_LINKS; ind += delta){
				s_q[ind] = xk[ind]; s_qd[ind] = xk[ind+NUM_LINKS]; s_qdd[ind] = qddk[ind]; s_sinq[ind] = sin(s_q[ind]); s_cosq[ind] = cos(s_q[ind]);
			}
			#pragma unroll
			for (int ind = start; ind < 36*NUM_LINKS; ind += delta){s_I[ind] = d_I[ind]; s_T[ind] = d_Tbody[ind];}
			__syncthreads();
			updateTransforms_GPU(s_T,s_sinq,s_cosq); __syncthreads();
	        // dqdd/dtau = Minv and  dqdd/dq(d) = -Minv*dc/dq(d) note: dM term in dq drops out if you compute c with fd qdd per carpentier
	        FD_helpers_GPU_vaf<T,MPC_MODE>(s_v,s_a,s_f,s_qd,s_qdd,s_I,s_T,s_temp,s_fext); __syncthreads();
	        endt = clock64(); t1 += endt - startt; startt = clock64();
	        // compute dc/dq(d) from vaf
	        inverseDynamicsGradient_GPU<T,VEL_DAMPING>(s_cdq,s_cdqd,s_qd,s_v,s_a,s_f,s_I,s_T,k); __syncthreads();
	        // copy out to RAM
	        T *cdqk = &d_cdq[k*NUM_LINKS*NUM_LINKS]; T *cdqdk = &d_cdqd[k*NUM_LINKS*NUM_LINKS];
	        #pragma unroll
			for (int ind = start; ind < NUM_LINKS*NUM_LINKS; ind += delta){cdqk[ind] = s_cdq[ind]; cdqdk[ind] = s_cdqd[ind];}
			__syncthreads();
			endt = clock64(); t2 += endt - startt;
	    }
	    // sum it up into a total counter across all threads
	    atomicAdd(&total_t1,t1); atomicAdd(&total_t2,t2); __syncthreads();
	    if(__doOnce()){
	    	// divide by number of threads and tests and clockrate and printout
	    	total_t1 /= static_cast<T>(SINGLE_CALL_ITERS); total_t2 /= static_cast<T>(SINGLE_CALL_ITERS);
	    	total_t1 /= blockDim.x*blockDim.y*clockRateKhz/1000; total_t2 /= blockDim.x*blockDim.y*clockRateKhz/1000;
	    	printf("vaf[%f] and dc/du[%f] with clock rate of [%f]\n",total_t1,total_t2,clockRateKhz);
	    }
	}

	template <typename T, int SINGLE_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = false, bool VEL_DAMPING = true>
	__global__
	void dynamicsGradientKernel_1stHalf_single_4x4(T *d_cdq, T *d_cdqd, T *d_x, T *d_qdd, T *d_I, T *d_T4, T *d_adj, int ld_x, double clockRateKhz, T *s_fext = nullptr){
		int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx); int start, delta; singleLoopVals_GPU(&start,&delta);
		__shared__ T s_q[NUM_POS];            __shared__ T s_qd[NUM_POS];            __shared__ T s_qdd[NUM_POS];
		__shared__ T s_sinq[NUM_POS];         __shared__ T s_cosq[NUM_POS];          __shared__ T s_temp[42];
		__shared__ T s_v[6*NUM_POS];          __shared__ T s_a[6*NUM_POS];           __shared__ T s_f[6*NUM_POS];
		__shared__ T s_T[36*NUM_POS];         __shared__ T s_I[36*NUM_POS];          __shared__ T s_T4[16*NUM_POS];
		__shared__ T s_cdq[NUM_POS*NUM_POS];  __shared__ T s_cdqd[NUM_POS*NUM_POS];  __shared__ T s_adj[9*NUM_POS];
		__shared__ T total_t1; 				  __shared__ T total_t2;
	    long long int startt, endt; double t1 = 0; double t2 = 0;
		for (int rep = 0; rep < SINGLE_CALL_ITERS; rep++){
	    	startt = clock64();
			int k = rep % KNOT_POINTS; T *xk = &d_x[k*ld_x]; T *qddk = &d_qdd[k*NUM_LINKS];
			// load in x,u,qdd,sinq,cosq,T,I and update T
			#pragma unroll
			for (int ind = start; ind < NUM_LINKS; ind += delta){
				s_q[ind] = xk[ind]; s_qd[ind] = xk[ind+NUM_LINKS]; s_qdd[ind] = qddk[ind]; s_sinq[ind] = sin(s_q[ind]); s_cosq[ind] = cos(s_q[ind]);
			}
			__syncthreads();
			updateT4_GPU<T>(s_T4,s_cosq,s_sinq);
			#pragma unroll
			for (int ind = start; ind < 36*NUM_LINKS; ind += delta){s_I[ind] = d_I[ind];}
			#pragma unroll
			for (int ind = start; ind < 16*NUM_POS; ind += delta){s_T4[ind] = d_T4[ind];}
			#pragma unroll
			for (int ind = start; ind < 9*NUM_POS; ind += delta){s_adj[ind] = d_adj[ind];}
			__syncthreads();
      		updateTransforms4x4to6x6_GPU<T>(s_T,s_T4,s_adj); __syncthreads();
	        // dqdd/dtau = Minv and  dqdd/dq(d) = -Minv*dc/dq(d) note: dM term in dq drops out if you compute c with fd qdd per carpentier
	        FD_helpers_GPU_vaf<T,MPC_MODE>(s_v,s_a,s_f,s_qd,s_qdd,s_I,s_T,s_temp,s_fext); __syncthreads();
	        endt = clock64(); t1 += endt - startt; startt = clock64();
	        // compute dc/dq(d) from vaf
	        inverseDynamicsGradient_GPU<T,VEL_DAMPING>(s_cdq,s_cdqd,s_qd,s_v,s_a,s_f,s_I,s_T,k); __syncthreads();
	        // copy out to RAM
	        T *cdqk = &d_cdq[k*NUM_LINKS*NUM_LINKS]; T *cdqdk = &d_cdqd[k*NUM_LINKS*NUM_LINKS];
	        #pragma unroll
			for (int ind = start; ind < NUM_LINKS*NUM_LINKS; ind += delta){cdqk[ind] = s_cdq[ind]; cdqdk[ind] = s_cdqd[ind];}
			__syncthreads();
			endt = clock64(); t2 += endt - startt;
	    }
	    // sum it up into a total counter across all threads
	    atomicAdd(&total_t1,t1); atomicAdd(&total_t2,t2); __syncthreads();
	    if(__doOnce()){
	    	// divide by number of threads and tests and clockrate and printout
	    	total_t1 /= static_cast<T>(SINGLE_CALL_ITERS); total_t2 /= static_cast<T>(SINGLE_CALL_ITERS);
	    	total_t1 /= blockDim.x*blockDim.y*clockRateKhz/1000; total_t2 /= blockDim.x*blockDim.y*clockRateKhz/1000;
	    	printf("vaf-4x4[%f] and dc/du[%f] with clock rate of [%f]\n",total_t1,total_t2,clockRateKhz);
	    }
	}

	template <typename T, int SINGLE_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false, bool VEL_DAMPING = 1>
	void GPU_singleCall(T *x, T *qdd, T *d_x, T *d_qdd, T *cdq, T *cdqd, T *d_cdq, T *d_cdqd, int ld_x, T *d_I, T *d_Tbody, T *d_T4, T *d_adj, cudaStream_t *streams){
		gpuErrchk(cudaDeviceSynchronize());
		gpuErrchk(cudaMemcpyAsync(d_x, x, ld_x*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[0]));
		gpuErrchk(cudaMemcpyAsync(d_qdd, qdd, NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[1]));
		gpuErrchk(cudaDeviceSynchronize());

		// compute grad on GPU -- printing times
		dim3 dynDimms(NUM_LINKS,NUM_LINKS); dim3 intDimms(1,1);
		cudaDeviceProp prop; cudaGetDeviceProperties(&prop, 0); double clockRateKhz = static_cast<double>(prop.clockRate);
		dynamicsGradientKernel_1stHalf_single<T,SINGLE_CALL_ITERS,KNOT_POINTS,NUM_LINKS,MPC_MODE><<<intDimms,dynDimms>>>(d_cdq,d_cdqd,d_x,d_qdd,d_I,d_Tbody,ld_x,clockRateKhz);
		gpuErrchk(cudaDeviceSynchronize());

		dynamicsGradientKernel_1stHalf_single_4x4<T,SINGLE_CALL_ITERS,KNOT_POINTS,NUM_LINKS,MPC_MODE><<<intDimms,dynDimms>>>(d_cdq,d_cdqd,d_x,d_qdd,d_I,d_T4,d_adj,ld_x,clockRateKhz);
		gpuErrchk(cudaDeviceSynchronize());

		gpuErrchk(cudaMemcpyAsync(cdq, d_cdq, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[0]));
		gpuErrchk(cudaMemcpyAsync(cdqd, d_cdqd, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[1]));
		gpuErrchk(cudaDeviceSynchronize()); 
	}

	template <typename T, int SINGLE_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = true, bool VEL_DAMPING = false>
	__global__
	void dynamicsGradientKernel_1stHalf_single_v2(T *d_cdq, T *d_cdqd, T *d_x, T *d_qdd, T *d_I, T *d_Tbody, int ld_x, T *s_fext = nullptr){
		int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx); int start, delta; singleLoopVals_GPU(&start,&delta);
	    __shared__ T s_q[NUM_LINKS];				__shared__ T s_qd[NUM_LINKS];				__shared__ T s_qdd[NUM_LINKS];
	    __shared__ T s_sinq[NUM_LINKS];			__shared__ T s_cosq[NUM_LINKS];			__shared__ T s_temp[42];
		__shared__ T s_v[6*NUM_LINKS];			__shared__ T s_a[6*NUM_LINKS]; 			__shared__ T s_f[6*NUM_LINKS];
		__shared__ T s_T[36*NUM_LINKS];			__shared__ T s_I[36*NUM_LINKS];
		__shared__ T s_cdq[NUM_LINKS*NUM_LINKS];	__shared__ T s_cdqd[NUM_LINKS*NUM_LINKS];
		for (int rep = 0; rep < SINGLE_CALL_ITERS; rep++){
			int k = rep % KNOT_POINTS; T *xk = &d_x[k*ld_x]; T *qddk = &d_qdd[k*NUM_LINKS];
			// load in x,u,qdd,sinq,cosq,T,I and update T
			#pragma unroll
			for (int ind = start; ind < NUM_LINKS; ind += delta){
				s_q[ind] = xk[ind]; s_qd[ind] = xk[ind+NUM_LINKS]; s_qdd[ind] = qddk[ind]; s_sinq[ind] = sin(s_q[ind]); s_cosq[ind] = cos(s_q[ind]);
			}
			#pragma unroll
			for (int ind = start; ind < 36*NUM_LINKS; ind += delta){s_I[ind] = d_I[ind]; s_T[ind] = d_Tbody[ind];}
			__syncthreads();
			updateTransforms_GPU(s_T,s_sinq,s_cosq); __syncthreads();
	        // dqdd/dtau = Minv and  dqdd/dq(d) = -Minv*dc/dq(d) note: dM term in dq drops out if you compute c with fd qdd per carpentier
	        FD_helpers_GPU_vaf<T,MPC_MODE>(s_v,s_a,s_f,s_qd,s_qdd,s_I,s_T,s_temp,s_fext); __syncthreads();
	        // compute dc/dq(d) from vaf
	        inverseDynamicsGradient_GPU<T,VEL_DAMPING>(s_cdq,s_cdqd,s_qd,s_v,s_a,s_f,s_I,s_T,k); __syncthreads();
	        // copy out to RAM
	        T *cdqk = &d_cdq[k*NUM_LINKS*NUM_LINKS]; T *cdqdk = &d_cdqd[k*NUM_LINKS*NUM_LINKS];
	        #pragma unroll
			for (int ind = start; ind < NUM_LINKS*NUM_LINKS; ind += delta){cdqk[ind] = s_cdq[ind]; cdqdk[ind] = s_cdqd[ind];}
			__syncthreads();
	    }
	}

	template <typename T, int SINGLE_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = true, bool VEL_DAMPING = false>
	__global__
	void dynamicsGradientKernel_1stHalf_single_v2_4x4(T *d_cdq, T *d_cdqd, T *d_x, T *d_qdd, T *d_I, T *d_T4, T *d_adj, int ld_x, T *s_fext = nullptr){
		int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx); int start, delta; singleLoopVals_GPU(&start,&delta);
		__shared__ T s_q[NUM_POS];            __shared__ T s_qd[NUM_POS];            __shared__ T s_qdd[NUM_POS];
		__shared__ T s_sinq[NUM_POS];         __shared__ T s_cosq[NUM_POS];          __shared__ T s_temp[42];
		__shared__ T s_v[6*NUM_POS];          __shared__ T s_a[6*NUM_POS];           __shared__ T s_f[6*NUM_POS];
		__shared__ T s_T[36*NUM_POS];         __shared__ T s_I[36*NUM_POS];          __shared__ T s_T4[16*NUM_POS];
		__shared__ T s_cdq[NUM_POS*NUM_POS];  __shared__ T s_cdqd[NUM_POS*NUM_POS];  __shared__ T s_adj[9*NUM_POS];
		for (int rep = 0; rep < SINGLE_CALL_ITERS; rep++){
			int k = rep % KNOT_POINTS; T *xk = &d_x[k*ld_x]; T *qddk = &d_qdd[k*NUM_LINKS];
			// load in x,u,qdd,sinq,cosq,T,I and update T
			#pragma unroll
			for (int ind = start; ind < NUM_LINKS; ind += delta){
				s_q[ind] = xk[ind]; s_qd[ind] = xk[ind+NUM_LINKS]; s_qdd[ind] = qddk[ind]; s_sinq[ind] = sin(s_q[ind]); s_cosq[ind] = cos(s_q[ind]);
			}
			__syncthreads();
			updateT4_GPU<T>(s_T4,s_cosq,s_sinq);
			#pragma unroll
			for (int ind = start; ind < 36*NUM_LINKS; ind += delta){s_I[ind] = d_I[ind];}
			#pragma unroll
			for (int ind = start; ind < 16*NUM_POS; ind += delta){s_T4[ind] = d_T4[ind];}
			#pragma unroll
			for (int ind = start; ind < 9*NUM_POS; ind += delta){s_adj[ind] = d_adj[ind];}
			__syncthreads();
      		updateTransforms4x4to6x6_GPU<T>(s_T,s_T4,s_adj); __syncthreads();
	        // dqdd/dtau = Minv and  dqdd/dq(d) = -Minv*dc/dq(d) note: dM term in dq drops out if you compute c with fd qdd per carpentier
	        FD_helpers_GPU_vaf<T,MPC_MODE>(s_v,s_a,s_f,s_qd,s_qdd,s_I,s_T,s_temp,s_fext); __syncthreads();
	        // compute dc/dq(d) from vaf
	        inverseDynamicsGradient_GPU<T,VEL_DAMPING>(s_cdq,s_cdqd,s_qd,s_v,s_a,s_f,s_I,s_T,k); __syncthreads();
	        // copy out to RAM
	        T *cdqk = &d_cdq[k*NUM_LINKS*NUM_LINKS]; T *cdqdk = &d_cdqd[k*NUM_LINKS*NUM_LINKS];
	        #pragma unroll
			for (int ind = start; ind < NUM_LINKS*NUM_LINKS; ind += delta){cdqk[ind] = s_cdq[ind]; cdqdk[ind] = s_cdqd[ind];}
			__syncthreads();
	    }
	}

	template <typename T, int SINGLE_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = false, bool VEL_DAMPING = true>
	__global__
	void dynamicsGradientKernel_vaf_single_v2(T *d_cdq, T *d_cdqd, T *d_x, T *d_qdd, T *d_I, T *d_Tbody, int ld_x, T *s_fext = nullptr){
		int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx); int start, delta; singleLoopVals_GPU(&start,&delta);
	    __shared__ T s_q[NUM_LINKS];				__shared__ T s_qd[NUM_LINKS];				__shared__ T s_qdd[NUM_LINKS];
	    __shared__ T s_sinq[NUM_LINKS];			__shared__ T s_cosq[NUM_LINKS];			__shared__ T s_temp[42];
		__shared__ T s_v[6*NUM_LINKS];			__shared__ T s_a[6*NUM_LINKS]; 			__shared__ T s_f[6*NUM_LINKS];
		__shared__ T s_T[36*NUM_LINKS];			__shared__ T s_I[36*NUM_LINKS];
		for (int rep = 0; rep < SINGLE_CALL_ITERS; rep++){
			int k = rep % KNOT_POINTS; T *xk = &d_x[k*ld_x]; T *qddk = &d_qdd[k*NUM_LINKS];
			// load in x,u,qdd,sinq,cosq,T,I and update T
			#pragma unroll
			for (int ind = start; ind < NUM_LINKS; ind += delta){
				s_q[ind] = xk[ind]; s_qd[ind] = xk[ind+NUM_LINKS]; s_qdd[ind] = qddk[ind]; s_sinq[ind] = sin(s_q[ind]); s_cosq[ind] = cos(s_q[ind]);
			}
			#pragma unroll
			for (int ind = start; ind < 36*NUM_LINKS; ind += delta){s_I[ind] = d_I[ind]; s_T[ind] = d_Tbody[ind];}
			__syncthreads();
			updateTransforms_GPU(s_T,s_sinq,s_cosq); __syncthreads();
	        // dqdd/dtau = Minv and  dqdd/dq(d) = -Minv*dc/dq(d) note: dM term in dq drops out if you compute c with fd qdd per carpentier
	        FD_helpers_GPU_vaf<T,MPC_MODE>(s_v,s_a,s_f,s_qd,s_qdd,s_I,s_T,s_temp,s_fext); __syncthreads();
			__syncthreads();
	    }
	}

	template <typename T, int SINGLE_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS, bool VEL_DAMPING = true>
	__global__
	void dynamicsGradientKernel_dcdu_single_v2(T *d_cdq, T *d_cdqd, T *d_v, T *d_a, T *d_f, T *d_I, T *d_Tfinal, T *d_x, int ld_x, T *s_fext = nullptr){
		int starty, dy, startx, dx; doubleLoopVals_GPU(&starty,&dy,&startx,&dx); int start, delta; singleLoopVals_GPU(&start,&delta);
		__shared__ T s_v[6*NUM_POS];       		__shared__ T s_a[6*NUM_POS];        __shared__ T s_f[6*NUM_POS];
		__shared__ T s_I[36*NUM_POS];          	__shared__ T s_T[36*NUM_POS];       __shared__ T s_qd[NUM_POS];
		__shared__ T s_cdq[NUM_POS*NUM_POS];    __shared__ T s_cdqd[NUM_POS*NUM_POS];
		// loop for all knots needed per SM (note only load I once as it is constant)
   		for (int ind = start; ind < 36*NUM_POS; ind += delta){s_I[ind] = d_I[ind];} __syncthreads();
		for (int rep = 0; rep < SINGLE_CALL_ITERS; rep++){
			int k = rep % KNOT_POINTS;
			T *vk = &d_v[k*6*NUM_POS]; T *ak = &d_a[k*6*NUM_POS]; T *fk = &d_f[k*6*NUM_POS]; T *Tk = &d_Tfinal[k*36*NUM_POS];
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

	template <typename T, int SINGLE_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false, bool VEL_DAMPING = 1>
	void GPU_singleCall_v2(T *x, T *u, T *qdd, T *v, T *a, T *f, T *Tfinal, T *d_x, T *d_qdd, T *d_v, T *d_a, T *d_f, T *d_Tfinal, T *cdq, T *cdqd, T *d_cdq, T *d_cdqd, 
						   int ld_x, int ld_u, T *I, T *Tbody, T *d_I, T *d_Tbody, T *d_T4, T *d_adj, std::thread *threads, cudaStream_t *streams){
		struct timeval start, end;
		gpuErrchk(cudaDeviceSynchronize());
		gpuErrchk(cudaMemcpyAsync(d_x, x, ld_x*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[0]));
		gpuErrchk(cudaMemcpyAsync(d_qdd, qdd, NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[1]));
		gpuErrchk(cudaDeviceSynchronize());

		// compute grad on GPU -- printing times
		dim3 dynDimms(NUM_LINKS,NUM_LINKS); dim3 intDimms(1,1);
		gettimeofday(&start,NULL);
		dynamicsGradientKernel_1stHalf_single_v2<T,SINGLE_CALL_ITERS,KNOT_POINTS,NUM_LINKS,MPC_MODE><<<intDimms,dynDimms>>>(d_cdq,d_cdqd,d_x,d_qdd,d_I,d_Tbody,ld_x);
		gpuErrchk(cudaDeviceSynchronize());
		gettimeofday(&end,NULL); printf("vaf+dc/du w/ launch [%f]\n",time_delta_us(start,end)/static_cast<double>(SINGLE_CALL_ITERS));

		gettimeofday(&start,NULL);
		dynamicsGradientKernel_1stHalf_single_v2_4x4<T,SINGLE_CALL_ITERS,KNOT_POINTS,NUM_LINKS,MPC_MODE><<<intDimms,dynDimms>>>(d_cdq,d_cdqd,d_x,d_qdd,d_I,d_T4,d_adj,ld_x);
		gpuErrchk(cudaDeviceSynchronize());
		gettimeofday(&end,NULL); printf("vaf+dc/du w/ launch (4x4) [%f]\n",time_delta_us(start,end)/static_cast<double>(SINGLE_CALL_ITERS));

		gettimeofday(&start,NULL);
		dynamicsGradientKernel_vaf_single_v2<T,SINGLE_CALL_ITERS,KNOT_POINTS,NUM_LINKS,MPC_MODE><<<intDimms,dynDimms>>>(d_cdq,d_cdqd,d_x,d_qdd,d_I,d_Tbody,ld_x);
		gpuErrchk(cudaDeviceSynchronize());
		gettimeofday(&end,NULL); printf("vaf only w/ launch [%f]\n",time_delta_us(start,end)/static_cast<double>(SINGLE_CALL_ITERS));

		// compute and send vars to GPU
		computeGradientThreaded_Start<T,KNOT_POINTS,MPC_MODE>(x,u,qdd,v,a,f,I,Tbody,Tfinal,ld_x,ld_u,threads);
		gpuErrchk(cudaMemcpyAsync(d_v, v, 6*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[0]));
		gpuErrchk(cudaMemcpyAsync(d_a, a, 6*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[1]));
		gpuErrchk(cudaMemcpyAsync(d_f, f, 6*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[2]));
		gpuErrchk(cudaMemcpyAsync(d_Tfinal, Tfinal, 36*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[3]));
		gpuErrchk(cudaDeviceSynchronize());
		// then compute on GPU
		gettimeofday(&start,NULL);
		dynamicsGradientKernel_dcdu_single_v2<T,SINGLE_CALL_ITERS,KNOT_POINTS,NUM_LINKS,MPC_MODE><<<intDimms,dynDimms>>>(d_cdq,d_cdqd,d_v,d_a,d_f,d_I,d_Tfinal,d_x,ld_x);
		gpuErrchk(cudaDeviceSynchronize());
		gettimeofday(&end,NULL); printf("dc/du only w/ launch [%f]\n",time_delta_us(start,end)/static_cast<double>(SINGLE_CALL_ITERS));

		gpuErrchk(cudaMemcpyAsync(cdq, d_cdq, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[0]));
		gpuErrchk(cudaMemcpyAsync(cdqd, d_cdqd, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[1]));
		gpuErrchk(cudaDeviceSynchronize()); 
	}

	template <typename T, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = false>
	void dynamicsGradient_GPU_middle_timing(T *x, T *u, T *qdd, T *Minv, T *dqdd, T *I, T *Tbody, T *v, T *a, T *f, T *Tfinal, T *cdq, T *cdqd, \
								       		int ld_x, int ld_u, std::thread *threads, cudaStream_t *streams, \
								       		T *d_x, T *d_v, T *d_a, T *d_f, T *d_I, T *d_Tfinal, T *d_cdq, T *d_cdqd,
								       		std::vector<double> *test_times, std::vector<double> *test_times1, std::vector<double> *test_times2,
											std::vector<double> *test_times3, std::vector<double> *test_times4, std::vector<double> *test_times5){
		struct timeval start, start1, start2, start3, start4, start5, end, end1, end2, end3, end4, end5;
		gpuErrchk(cudaDeviceSynchronize());
		gettimeofday(&start,NULL); gettimeofday(&start1,NULL);
		computeGradientThreaded_Start<T,KNOT_POINTS,MPC_MODE>(x,u,qdd,v,a,f,I,Tbody,Tfinal,ld_x,ld_u,threads);
	    gettimeofday(&end1,NULL);

	    // then copy vars to GPU
	    gettimeofday(&start2,NULL);
		gpuErrchk(cudaMemcpyAsync(d_v, v, 6*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[0]));
		gpuErrchk(cudaMemcpyAsync(d_a, a, 6*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[1]));
		gpuErrchk(cudaMemcpyAsync(d_f, f, 6*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[2]));
		gpuErrchk(cudaMemcpyAsync(d_Tfinal, Tfinal, 36*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[3]));
		gpuErrchk(cudaDeviceSynchronize()); gettimeofday(&end2,NULL);

		// compute grad on GPU
		gettimeofday(&start3,NULL);
		dim3 dynDimms(NUM_LINKS,NUM_LINKS); dim3 intDimms(KNOT_POINTS,1);
		dynamicsGradientKernel_Middle<T,KNOT_POINTS,1><<<intDimms,dynDimms,0,streams[0]>>>(d_cdq,d_cdqd,d_v,d_a,d_f,d_I,d_Tfinal,d_x,ld_x);
		gpuErrchk(cudaDeviceSynchronize()); gettimeofday(&end3,NULL);
		
		// copy back
	    gettimeofday(&start4,NULL);
		gpuErrchk(cudaMemcpyAsync(cdq, d_cdq, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[0]));
		gpuErrchk(cudaMemcpyAsync(cdqd, d_cdqd, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[1]));
		gpuErrchk(cudaDeviceSynchronize()); gettimeofday(&end4,NULL);

		// finish in threads
		gettimeofday(&start5,NULL);
		computeGradientThreaded_Finish<T,KNOT_POINTS>(cdq,cdqd,Minv,dqdd,threads);
	    gettimeofday(&end5,NULL); gettimeofday(&end,NULL); 
	    
		// and save the time
		test_times->push_back(time_delta_us(start,end));
		test_times1->push_back(time_delta_us(start1,end1));
		test_times2->push_back(time_delta_us(start2,end2));
		test_times3->push_back(time_delta_us(start3,end3));
		test_times4->push_back(time_delta_us(start4,end4));
		test_times5->push_back(time_delta_us(start5,end5));
	}

	template <typename T, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = false, bool VEL_DAMPING = true>
	void dynamicsGradient_GPU_1stHalf_timing(T *x, T *qdd, T *Minv, T *dqdd, T *cdq, T *cdqd, T *I, T *Tbody, int ld_x, std::thread *threads, \
											 cudaStream_t *streams, T *d_x, T *d_qdd, T *d_cdq, T *d_cdqd, T *d_I, T *d_Tbody,
											 std::vector<double> *test_times, std::vector<double> *test_times1, std::vector<double> *test_times2,
											 std::vector<double> *test_times3, std::vector<double> *test_times4){
		// copy vars to GPU
	    struct timeval start, start1, start2, start3, start4, end, end1, end2, end3, end4;
	    gpuErrchk(cudaDeviceSynchronize());
	    gettimeofday(&start,NULL); gettimeofday(&start1,NULL);
		gpuErrchk(cudaMemcpyAsync(d_x, x, ld_x*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[0]));
		gpuErrchk(cudaMemcpyAsync(d_qdd, qdd, NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[1]));
		gpuErrchk(cudaDeviceSynchronize()); gettimeofday(&end1,NULL);

		// compute vaf and grad GPU
		gettimeofday(&start2,NULL);
		dim3 dynDimms(NUM_LINKS,NUM_LINKS); dim3 intDimms(KNOT_POINTS,1);
		dynamicsGradientKernel_1stHalf<T,KNOT_POINTS,MPC_MODE,VEL_DAMPING><<<intDimms,dynDimms,0,streams[0]>>>(d_cdq,d_cdqd,d_x,d_qdd,d_I,d_Tbody,ld_x);
		gpuErrchk(cudaDeviceSynchronize()); gettimeofday(&end2,NULL);
		
		// copy back
	    gettimeofday(&start3,NULL);
		gpuErrchk(cudaMemcpyAsync(cdq, d_cdq, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[0]));
		gpuErrchk(cudaMemcpyAsync(cdqd, d_cdqd, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[1]));
		gpuErrchk(cudaDeviceSynchronize()); gettimeofday(&end3,NULL);

		// finish in threads
		gettimeofday(&start4,NULL);
		computeGradientThreaded_Finish<T,KNOT_POINTS>(cdq,cdqd,Minv,dqdd,threads);
	    gettimeofday(&end4,NULL); gettimeofday(&end,NULL);

		// and save the time
		test_times->push_back(time_delta_us(start,end));
		test_times1->push_back(time_delta_us(start1,end1));
		test_times2->push_back(time_delta_us(start2,end2));
		test_times3->push_back(time_delta_us(start3,end3));
		test_times4->push_back(time_delta_us(start4,end4));
	}

	template <typename T, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = false, bool VEL_DAMPING = true>
	void dynamicsGradient_GPU_1stHalf_timing_4x4(T *x, T *qdd, T *Minv, T *dqdd, T *cdq, T *cdqd, T *I, T *Tbody, int ld_x, std::thread *threads, \
											 cudaStream_t *streams, T *d_x, T *d_qdd, T *d_cdq, T *d_cdqd, T *d_I, T *d_T4, T *d_adj,
											 std::vector<double> *test_times, std::vector<double> *test_times1, std::vector<double> *test_times2,
											 std::vector<double> *test_times3, std::vector<double> *test_times4){
		// copy vars to GPU
	    struct timeval start, start1, start2, start3, start4, end, end1, end2, end3, end4;
	    gettimeofday(&start,NULL); gettimeofday(&start1,NULL);
		gpuErrchk(cudaMemcpyAsync(d_x, x, ld_x*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[0]));
		gpuErrchk(cudaMemcpyAsync(d_qdd, qdd, NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyHostToDevice, streams[1]));
		gpuErrchk(cudaDeviceSynchronize()); gettimeofday(&end1,NULL);

		// compute vaf and grad GPU
		gettimeofday(&start2,NULL);
		dim3 dynDimms(NUM_LINKS,NUM_LINKS); dim3 intDimms(KNOT_POINTS,1);
		dynamicsGradientKernel_1stHalf_v2<T,KNOT_POINTS,MPC_MODE,VEL_DAMPING><<<intDimms,dynDimms,0,streams[0]>>>(d_cdq,d_cdqd,d_x,d_qdd,d_I,d_T4,d_adj,ld_x);
		gpuErrchk(cudaDeviceSynchronize()); gettimeofday(&end2,NULL);
		
		// copy back
	    gettimeofday(&start3,NULL);
		gpuErrchk(cudaMemcpyAsync(cdq, d_cdq, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[0]));
		gpuErrchk(cudaMemcpyAsync(cdqd, d_cdqd, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T), cudaMemcpyDeviceToHost, streams[1]));
		gpuErrchk(cudaDeviceSynchronize()); gettimeofday(&end3,NULL);

		// finish in threads
		gettimeofday(&start4,NULL);
		computeGradientThreaded_Finish<T,KNOT_POINTS>(cdq,cdqd,Minv,dqdd,threads);
	    gettimeofday(&end4,NULL); gettimeofday(&end,NULL);

		// and save the time
		test_times->push_back(time_delta_us(start,end));
		test_times1->push_back(time_delta_us(start1,end1));
		test_times2->push_back(time_delta_us(start2,end2));
		test_times3->push_back(time_delta_us(start3,end3));
		test_times4->push_back(time_delta_us(start4,end4));
	}

	template<typename T, int SINGLE_CALL_ITERS, int PARALLEL_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = false>
	void testGPUTiming(){
		printf("Allocating and setting up...\n");
		printf("-----------------\n");
		// allocate variables
		std::thread threads[DYNAMICS_GRAD_THREADS];
		int ld_x = 2*NUM_LINKS; int ld_u = NUM_LINKS;
		T *x = (T *)malloc(ld_x*KNOT_POINTS*sizeof(T));
		T *u = (T *)malloc(ld_u*KNOT_POINTS*sizeof(T));
		T *qdd = (T *)malloc(NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *Minv = (T *)malloc(NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *dqdd = (T *)malloc(2*NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *I = (T *)malloc(36*NUM_LINKS*sizeof(T));
		T *Tbody = (T *)malloc(36*NUM_LINKS*sizeof(T));
		T *v = (T *)malloc(6*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *a = (T *)malloc(6*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *f = (T *)malloc(6*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *Tfinal = (T *)malloc(36*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *cdq = (T *)malloc(NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *cdqd = (T *)malloc(NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *d_x; gpuErrchk(cudaMalloc((void**)&d_x, ld_x*KNOT_POINTS*sizeof(T)));
		T *d_qdd; gpuErrchk(cudaMalloc((void**)&d_qdd, NUM_LINKS*KNOT_POINTS*sizeof(T)));
		T *d_v; gpuErrchk(cudaMalloc((void**)&d_v, 6*NUM_LINKS*KNOT_POINTS*sizeof(T)));
		T *d_a; gpuErrchk(cudaMalloc((void**)&d_a, 6*NUM_LINKS*KNOT_POINTS*sizeof(T)));
		T *d_f; gpuErrchk(cudaMalloc((void**)&d_f, 6*NUM_LINKS*KNOT_POINTS*sizeof(T)));
		T *d_I; gpuErrchk(cudaMalloc((void**)&d_I, 36*NUM_LINKS*sizeof(T)));
		T *d_Tbody; gpuErrchk(cudaMalloc((void**)&d_Tbody, 36*KNOT_POINTS*sizeof(T)));
		T *d_Tfinal; gpuErrchk(cudaMalloc((void**)&d_Tfinal, 36*NUM_LINKS*KNOT_POINTS*sizeof(T)));
		T *d_cdq; gpuErrchk(cudaMalloc((void**)&d_cdq, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T)));
		T *d_cdqd; gpuErrchk(cudaMalloc((void**)&d_cdqd, NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T)));
		int priority, minPriority, maxPriority;
		gpuErrchk(cudaDeviceGetStreamPriorityRange(&minPriority, &maxPriority));
		cudaStream_t *streams = (cudaStream_t *)malloc(NUM_STREAMS*sizeof(cudaStream_t));
		for(int i=0; i<NUM_STREAMS; i++){
			priority = std::min(minPriority+i,maxPriority);
			gpuErrchk(cudaStreamCreateWithPriority(&streams[i],cudaStreamNonBlocking,priority));
		}
		T *T4 = (T *)malloc(16*NUM_LINKS*sizeof(T));
		T *adj = (T *)malloc(9*NUM_LINKS*sizeof(T));
		T *d_T4; gpuErrchk(cudaMalloc((void**)&d_T4, 16*NUM_LINKS*sizeof(T)));
		T *d_adj; gpuErrchk(cudaMalloc((void**)&d_adj, 9*NUM_LINKS*sizeof(T)));
		std::vector<double> test_times, test_times1, test_times2, test_times3, test_times4, test_times5, test_times6, test_times7, test_times8, 
							test_times9, test_times10, test_times11, test_times12, test_times13, test_times14, test_times15;

		// compute all initial values (get KNOT_POINTS random states, inputs -> qdd, MINV)
		loadXU<T,KNOT_POINTS,NUM_LINKS,0>(x,u,ld_x,ld_u); initI<T>(I); initT<T>(Tbody); initMotionTransforms4x4<T>(T4); initAdjoints4x4<T>(adj);
		gpuErrchk(cudaMemcpyAsync(d_I,I,36*NUM_LINKS,cudaMemcpyHostToDevice));
		gpuErrchk(cudaMemcpyAsync(d_Tbody,Tbody,36*NUM_LINKS,cudaMemcpyHostToDevice));
		gpuErrchk(cudaMemcpyAsync(d_T4,T4,16*NUM_LINKS,cudaMemcpyHostToDevice));
		gpuErrchk(cudaMemcpyAsync(d_adj,adj,9*NUM_LINKS,cudaMemcpyHostToDevice));
		compute_qddMinv<T,KNOT_POINTS,NUM_LINKS,MPC_MODE>(Minv,qdd,x,u,I,Tbody,ld_x,ld_u);
		printf("Setup Complte -- starting tests...\n");
		printf("-----------------\n");

		printf("GPU Single Call:\n");
		GPU_singleCall<T,SINGLE_CALL_ITERS,KNOT_POINTS,NUM_LINKS,1,1,MPC_MODE>(x,qdd,d_x,d_qdd,cdq,cdqd,d_cdq,d_cdqd,ld_x,d_I,d_Tbody,d_T4,d_adj,streams);
		printf("-----------------\n");

		printf("GPU Single Callv2:\n");
		GPU_singleCall_v2<T,SINGLE_CALL_ITERS,KNOT_POINTS,NUM_LINKS,1,1,MPC_MODE>(x,u,qdd,v,a,f,Tfinal,d_x,d_qdd,d_v,d_a,d_f,d_Tfinal,cdq,cdqd,d_cdq,d_cdqd,ld_x,ld_u,I,Tbody,d_I,d_Tbody,d_T4,d_adj,threads,streams);
		printf("-----------------\n");

		// then run the tests
		printf("GPU-Split: vaf -Sync-> I/O -Sync-> dc/du -Sync-> I/O -Sync-> rest\n");
		for(int iter = 0; iter < PARALLEL_CALL_ITERS; iter++){
			dynamicsGradient_GPU_middle_timing<T,KNOT_POINTS,NUM_LINKS,MPC_MODE>(x,u,qdd,Minv,dqdd,I,Tbody,v,a,f,Tfinal,cdq,cdqd,ld_x,ld_u,threads,
										  	   							streams,d_x,d_v,d_a,d_f,d_I,d_Tfinal,d_cdq,d_cdqd,
										  	   							&test_times,&test_times1,&test_times2,&test_times3,&test_times4,&test_times5);
		}
		printStats("GPU-Split", test_times, "vaf  ", test_times1, "I/O  ", test_times2, "dc/du", test_times3, "I/O  ", test_times4, "Rest ", test_times5);

		printf("GPU-Fused: I/O -Sync-> vaf+dc/du -Sync-> I/O -Sync-> rest\n");
		for(int iter = 0; iter < PARALLEL_CALL_ITERS; iter++){
			dynamicsGradient_GPU_1stHalf_timing<T,KNOT_POINTS,NUM_LINKS,MPC_MODE>(x,qdd,Minv,dqdd,cdq,cdqd,I,Tbody,ld_x,threads,streams,
										   								 d_x,d_qdd,d_cdq,d_cdqd,d_I,d_Tbody,
										   								 &test_times6,&test_times7,&test_times8,&test_times9,&test_times10);
		}
		printStats("GPU-Fused", test_times6, "I/O      ", test_times7, "vaf+dc/du", test_times8, "I/O      ", test_times9, "Rest     ", test_times10);

		printf("GPU-Fused (4x4): I/O -Sync-> vaf+dc/du -Sync-> I/O -Sync-> rest\n");
		for(int iter = 0; iter < PARALLEL_CALL_ITERS; iter++){
			dynamicsGradient_GPU_1stHalf_timing_4x4<T,KNOT_POINTS,NUM_LINKS>(x,qdd,Minv,dqdd,cdq,cdqd,I,Tbody,ld_x,threads,streams,
										   								 d_x,d_qdd,d_cdq,d_cdqd,d_I,d_T4,d_adj,
										   								 &test_times11,&test_times12,&test_times13,&test_times14,&test_times15);
		}
		printStats("GPU-Fused", test_times11, "I/O      ", test_times12, "vaf+dc/du", test_times13, "I/O      ", test_times14, "Rest     ", test_times15);

		printf("Test Complte -- cleaning up\n");
		printf("-----------------\n");
		free(x); free(u); free(qdd); free(Minv); free(dqdd); free(I); free(Tbody);
		free(v); free(a); free(f); free(Tfinal); free(cdq); free(cdqd);
		gpuErrchk(cudaFree(d_x)); gpuErrchk(cudaFree(d_qdd)); gpuErrchk(cudaFree(d_v)); gpuErrchk(cudaFree(d_a)); gpuErrchk(cudaFree(d_f));
		gpuErrchk(cudaFree(d_I)); gpuErrchk(cudaFree(d_Tbody)); gpuErrchk(cudaFree(d_Tfinal)); gpuErrchk(cudaFree(d_cdq)); gpuErrchk(cudaFree(d_cdqd));
		for(int i=0; i<NUM_STREAMS; i++){gpuErrchk(cudaStreamDestroy(streams[i]));}		free(streams);
	}
#endif

#if COMPILE_WITH_FPGA

	// template <typename T, int SINGLE_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS>
	// void FPGA_singleCall(T *x, T *u, T *qdd, T *v, T *a, T *f, T *I, T *Tbody, T *Tfinal, int ld_x, int ld_u, std::threads *threads,
	// 					FPGADataIn_v1<KNOT_POINTS,NUM_LINKS> *dataIn1, FPGADataIn_v2<KNOT_POINTS,NUM_LINKS> *dataIn2, FPGADataOut<KNOT_POINTS,NUM_LINKS> *dataOut, \
	// 					unsigned int fpgaIn1, unsigned int fpgaIn2, unsigned int fpgaOut){
	// 	// for the middle one we need to pre-compute all vaf
	// 	computeGradientThreaded_Start<T,KNOT_POINTS>(x,u,qdd,v,a,f,I,Tbody,Tfinal,ld_x,ld_u,threads);

	// 	// then run the FPGA split single wrapper
	// 	struct timeval start, end; gettimeofday(&start,NULL);
	// 	for(int iter = 0; iter < SINGLE_CALL_ITERS; iter++){
	// 		int k = iter % KNOT_POINTS; T *vk = &v[k*6*NUM_POS]; T *ak = &a[k*6*NUM_POS]; T *fk = &f[k*6*NUM_POS]; T *xk = &x[k*ld_x]; T *cdqk = &cdq[k*NUM_LINKS]; T *cdqdk = &cdqd[k*NUM_LINKS];
	// 		connectallWrapper_1<T,1,NUM_LINKS>(vk,ak,fk,xk,cdqk,cdqdk,ld_x,dataIn,dataOut,fpgaIn,fpgaOut);
	// 	}
	// 	gettimeofday(&end,NULL); printf("    dc/du: %fus\n",time_delta_us(start,end)/static_cast<T>(SINGLE_CALL_ITERS)); gettimeofday(&start,NULL);

	// 	// then run the FPGA fused single wrapper
	// 	gettimeofday(&start,NULL);
	// 	for(int iter = 0; iter < SINGLE_CALL_ITERS; iter++){
	// 		int k = iter % KNOT_POINTS; T *xk = &x[k*ld_x]; T *qddk = &qdd[k*NUM_LINKS]; T *cdqk = &cdq[k*NUM_LINKS]; T *cdqdk = &cdqd[k*NUM_LINKS];
	// 		connectallWrapper_2<T,1,NUM_LINKS>(xk,qddk,cdqk,cdqdk,ld_x,dataIn,dataOut,fpgaIn,fpgaOut);
	// 	}
	// 	gettimeofday(&end,NULL); printf("vaf+dc/du: %fus\n",time_delta_us(start,end)/static_cast<T>(SINGLE_CALL_ITERS)); gettimeofday(&start,NULL);
	// }

	template <typename T, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = false>
	void dynamicsGradient_FPGA_middle_timing(T *x, T *u, T *qdd, T *Minv, T *dqdd, T *I, T *Tbody, T *v, T *a, T *f, T *Tfinal, T *cdq, T *cdqd, \
								       		int ld_x, int ld_u, std::thread *threads, \
                                            FPGADataIn_v1<KNOT_POINTS,NUM_LINKS> *dataIn, FPGADataOut<KNOT_POINTS,NUM_LINKS> *dataOut, \
                                            unsigned int fpgaIn, unsigned int fpgaOut,
                                            std::vector<double> *test_times, std::vector<double> *test_times1, std::vector<double> *test_times2,
                                            std::vector<double> *test_times3, std::vector<double> *test_times4, std::vector<double> *test_times5){
		struct timeval start, start1, start5, end, end1, end5;
		gettimeofday(&start,NULL); gettimeofday(&start1,NULL);
		computeGradientThreaded_Start<T,KNOT_POINTS,MPC_MODE>(x,u,qdd,v,a,f,I,Tbody,Tfinal,ld_x,ld_u,threads);
	    gettimeofday(&end1,NULL);

	    // then copy vars to FPGA and compute grad and copy back
	    double t2, t3, t4;
		connectallWrapper_1<T,KNOT_POINTS,NUM_LINKS,true>(v,a,f,x,cdq,cdqd,ld_x,dataIn,dataOut,fpgaIn,fpgaOut,&t2,&t3,&t4);

		// finish in threads
		gettimeofday(&start5,NULL);
		computeGradientThreaded_Finish<T,KNOT_POINTS>(cdq,cdqd,Minv,dqdd,threads);
	    gettimeofday(&end5,NULL); gettimeofday(&end,NULL); 
	    
		// and save the time
		test_times->push_back(time_delta_us(start,end));
		test_times1->push_back(time_delta_us(start1,end1));
		test_times2->push_back(t2);
		test_times3->push_back(t3);
		test_times4->push_back(t4);
		test_times5->push_back(time_delta_us(start5,end5));
	}

	template <typename T, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = false>
	void dynamicsGradient_FPGA_1stHalf_timing(T *x, T *qdd, T *Minv, T *dqdd, T *cdq, T *cdqd, int ld_x, std::thread *threads, 
											  FPGADataIn_v2<KNOT_POINTS,NUM_LINKS> *dataIn, FPGADataOut<KNOT_POINTS,NUM_LINKS> *dataOut, \
                                              unsigned int fpgaIn, unsigned int fpgaOut,
                                              std::vector<double> *test_times, std::vector<double> *test_times1, std::vector<double> *test_times2,
                                              std::vector<double> *test_times3, std::vector<double> *test_times4){
		// copy vars to GPU
	    struct timeval start, start4, end, end4; gettimeofday(&start,NULL);

		// copy vars to FPGA and compute grad and copy back
		double t1, t2, t3;
		connectallWrapper_2<T,KNOT_POINTS,NUM_LINKS,true>(x,qdd,cdq,cdqd,ld_x,dataIn,dataOut,fpgaIn,fpgaOut,&t1,&t2,&t3);
		
		// finish in threads
		gettimeofday(&start4,NULL);
		computeGradientThreaded_Finish<T,KNOT_POINTS>(cdq,cdqd,Minv,dqdd,threads);
	    gettimeofday(&end4,NULL); gettimeofday(&end,NULL);

		// and save the time
		test_times->push_back(time_delta_us(start,end));
		test_times1->push_back(t1);
		test_times2->push_back(t2);
		test_times3->push_back(t3);
		test_times4->push_back(time_delta_us(start4,end4));
	}

	template<typename T, int SINGLE_CALL_ITERS, int PARALLEL_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS, bool MPC_MODE = false>
	void testFPGATiming(){
		printf("Allocating and setting up...\n");
		printf("-----------------\n");
		// allocate variables
		std::thread threads[DYNAMICS_GRAD_THREADS];
		int ld_x = 2*NUM_LINKS; int ld_u = NUM_LINKS;
		T *x = (T *)malloc(ld_x*KNOT_POINTS*sizeof(T));
		T *u = (T *)malloc(ld_u*KNOT_POINTS*sizeof(T));
		T *qdd = (T *)malloc(NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *Minv = (T *)malloc(NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *dqdd = (T *)malloc(2*NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *I = (T *)malloc(36*NUM_LINKS*sizeof(T));
		T *Tbody = (T *)malloc(36*NUM_LINKS*sizeof(T));
		T *v = (T *)malloc(6*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *a = (T *)malloc(6*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *f = (T *)malloc(6*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *Tfinal = (T *)malloc(36*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *cdq = (T *)malloc(NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T));
		T *cdqd = (T *)malloc(NUM_LINKS*NUM_LINKS*KNOT_POINTS*sizeof(T));

		GradientProxy *fpga = new GradientProxy(IfcNames_GradientS2H);
		DmaManager *dma = platformInit();
		size_t dataIn1_size = sizeof(FPGADataIn_v1<KNOT_POINTS,NUM_LINKS>);
		size_t dataIn2_size = sizeof(FPGADataIn_v2<KNOT_POINTS,NUM_LINKS>);
		size_t dataOut_size = sizeof(FPGADataOut<KNOT_POINTS,NUM_LINKS>);
		int dataIn1_desc = portalAlloc(dataIn1_size,0);
		int dataIn2_desc = portalAlloc(dataIn2_size,0);
		int dataOut_desc = portalAlloc(dataOut_size,0);
		FPGADataIn_v1<KNOT_POINTS,NUM_LINKS> *dataIn_1 = (FPGADataIn_v1<KNOT_POINTS,NUM_LINKS>*) portalMmap(dataIn1_desc,dataIn1_size);
		FPGADataIn_v2<KNOT_POINTS,NUM_LINKS> *dataIn_2 = (FPGADataIn_v2<KNOT_POINTS,NUM_LINKS>*) portalMmap(dataIn2_desc,dataIn2_size);
		FPGADataOut<KNOT_POINTS,NUM_LINKS> *dataOut = (FPGADataOut<KNOT_POINTS,NUM_LINKS>*) portalMmap(dataOut_desc,dataOut_size);
		unsigned int fpgaIn1Pt = dma->reference(dataIn1_desc);
		unsigned int fpgaIn2Pt = dma->reference(dataIn2_desc);
		unsigned int fpgaOutPt = dma->reference(dataOut_desc);
		// FPGADataIn_v1<KNOT_POINTS,NUM_LINKS> dataIn_1_; FPGADataIn_v1<KNOT_POINTS,NUM_LINKS> *dataIn_1 = &dataIn_1_;
		// FPGADataIn_v2<KNOT_POINTS,NUM_LINKS> dataIn_2_; FPGADataIn_v2<KNOT_POINTS,NUM_LINKS> *dataIn_2 = &dataIn_2_;
		// FPGADataOut<KNOT_POINTS,NUM_LINKS> dataOut_; FPGADataOut<KNOT_POINTS,NUM_LINKS> *dataOut = &dataOut_;
		// unsigned int fpgaIn1Pt, fpgaIn2Pt, fpgaOutPt;

		std::vector<double> test_times, test_times1, test_times2, test_times3, test_times4, test_times5, test_times6, test_times7, test_times8, test_times9, test_times10;

		// compute all initial values (get KNOT_POINTS random states, inputs -> qdd, MINV)
		loadXU<T,KNOT_POINTS,NUM_LINKS,0>(x,u,ld_x,ld_u); initI<T>(I); initT<T>(Tbody);
		compute_qddMinv<T,KNOT_POINTS,NUM_LINKS,MPC_MODE>(Minv,qdd,x,u,I,Tbody,ld_x,ld_u);
		printf("Setup Complte -- starting tests...\n");
		printf("-----------------\n");

		// then run the tests
		// printf("FPGA Single Call:\n");
		// FPGA_singleCall<T,SINGLE_CALL_ITERS,KNOT_POINTS,NUM_LINK>(x,u,qdd,v,a,f,I,Tbody,Tfinal,ld_x,ld_u,threads,dataIn1,dataIn2,dataOut,fpgaIn1,fpgaIn2,fpgaOut);
		// printf("-----------------\n");

		printf("FPGA-Split: vaf -Sync-> I/O -Sync-> dc/du -Sync-> I/O -Sync-> rest\n");
		for(int iter = 0; iter < PARALLEL_CALL_ITERS; iter++){
			dynamicsGradient_FPGA_middle_timing<T,KNOT_POINTS,NUM_LINKS,MPC_MODE>(x,u,qdd,Minv,dqdd,I,Tbody,v,a,f,Tfinal,cdq,cdqd,ld_x,ld_u,threads,dataIn_1,dataOut,fpgaIn1Pt,fpgaOutPt,
																		 &test_times,&test_times1,&test_times2,&test_times3,&test_times4,&test_times5);
		}
		printStats("FPGA-Split", test_times, "vaf     ", test_times1, "FixedConv", test_times2, "dc/du   ", test_times3, "FixedConv", test_times4, "Rest     ", test_times5);

		printf("FPGA-Fused: I/O -Sync-> vaf+dc/du -Sync-> I/O -Sync-> rest\n");
		for(int iter = 0; iter < PARALLEL_CALL_ITERS; iter++){
			dynamicsGradient_FPGA_1stHalf_timing<T,KNOT_POINTS,NUM_LINKS,MPC_MODE>(x,qdd,Minv,dqdd,cdq,cdqd,ld_x,threads,dataIn_2,dataOut,fpgaIn2Pt,fpgaOutPt,
																		  &test_times6,&test_times7,&test_times8,&test_times9,&test_times10);
		}
		printStats("FPGA-Fused", test_times6, "FixedConv", test_times7, "vaf+dc/du", test_times8, "FixedConv", test_times9, "Rest     ", test_times10);

		printf("Test Complte -- cleaning up\n");
		printf("-----------------\n");
		free(x); free(u); free(qdd); free(Minv); free(dqdd); free(I); free(Tbody);
		free(v); free(a); free(f); free(Tfinal); free(cdq); free(cdqd);
		// FREE THE FPGA THINGS HERE
		// THIS NEEDS TO BE UPDATED
	}
#endif

template <typename T, int SINGLE_CALL_ITERS, int PARALLEL_CALL_ITERS, int KNOT_POINTS, int NUM_LINKS>
int runTimingTest(char hardware){
	char errMsg[]  = "Error:  Unkown code - usage is [C]PU, [G]PU or [F]PGA -- check compile flags if you want GPU or FPGA and they aren't working!\n";
	if (hardware == 'C'){testCPUTiming<T,SINGLE_CALL_ITERS,PARALLEL_CALL_ITERS,KNOT_POINTS,NUM_LINKS,true>(); return 0;}
	#if COMPILE_WITH_GPU
		else if (hardware == 'G'){testGPUTiming<T,SINGLE_CALL_ITERS,PARALLEL_CALL_ITERS,KNOT_POINTS,NUM_LINKS,true>(); return 0;}
	#endif
	#if COMPILE_WITH_FPGA
		else if (hardware == 'F'){testFPGATiming<T,SINGLE_CALL_ITERS,PARALLEL_CALL_ITERS,KNOT_POINTS,NUM_LINKS,true>(); return 0;}
	#endif
	printf("%s",errMsg); return 1;
}

template <typename T>
int debugDumpFPGA(void){
	printf("-----------------\n");
	printf("Allocating and setting up...\n");
	// allocate variables
	std::thread threads[DYNAMICS_GRAD_THREADS];
	int ld_x = 2*NUM_POS; int ld_u = NUM_POS;
	T x[] = {-1.57080,0.78540,0.52465,-0.52465,0.39270,0.52465,1.57080,0.00930,0.01104,0.01055,0.01071,0.00955,0.01086,0.00993,-1.57072,0.78549,0.52473,-0.52456,0.39277,0.52473,1.57087,-0.01399,-0.43794,0.57467,-0.55808,0.18472,0.54574,0.00082,-1.57083,0.78201,0.52929,-0.52899,0.39424,0.52906,1.57088,0.16063,-0.68510,0.66138,-0.57023,0.19075,0.55359,0.00075,-1.56956,0.77657,0.53454,-0.53352,0.39575,0.53346,1.57089,0.31309,-0.88465,0.71359,-0.53970,0.19410,0.55414,0.00067,-1.56707,0.76955,0.54020,-0.53780,0.39729,0.53785,1.57089,0.43702,-1.05395,0.75556,-0.50868,0.19676,0.55394,0.00060,-1.56360,0.76119,0.54620,-0.54184,0.39886,0.54225,1.57090,0.53754,-1.19800,0.79018,-0.48029,0.19887,0.55350,0.00053,-1.55934,0.75168,0.55247,-0.54565,0.40043,0.54664,1.57090,0.61925,-1.32044,0.81885,-0.45484,0.20053,0.55294,0.00047,-1.55442,0.74120,0.55897,-0.54926,0.40203,0.55103,1.57090,0.68578,-1.42435,0.84262,-0.43227,0.20184,0.55231,0.00041,-1.54898,0.72989,0.56566,-0.55269,0.40363,0.55542,1.57091,0.74000,-1.51238,0.86233,-0.41242,0.20286,0.55166,0.00036,-1.54311,0.71789,0.57250,-0.55596,0.40524,0.55979,1.57091,0.78420,-1.58680,0.87864,-0.39508,0.20365,0.55101,0.00031,-1.53688,0.70530,0.57947,-0.55910,0.40685,0.56417,1.57091,0.82022,-1.64956,0.89213,-0.38001,0.20425,0.55037,0.00028,-1.53037,0.69221,0.58655,-0.56211,0.40848,0.56853,1.57092,0.84954,-1.70234,0.90323,-0.36699,0.20470,0.54975,0.00024,-1.52363,0.67870,0.59372,-0.56503,0.41010,0.57290,1.57092,0.87338,-1.74656,0.91234,-0.35578,0.20501,0.54915,0.00021,-1.51670,0.66483,0.60096,-0.56785,0.41173,0.57726,1.57092,0.89272,-1.78348,0.91977,-0.34616,0.20522,0.54859,0.00019,-1.50962,0.65068,0.60826,-0.57060,0.41336,0.58161,1.57092,0.90836,-1.81413,0.92577,-0.33794,0.20533,0.54805,0.00016,-1.50241,0.63628,0.61561,-0.57328,0.41499,0.58596,1.57092,0.92097,-1.83943,0.93059,-0.33095,0.20538,0.54753,0.00014,-1.49510,0.62168,0.62300,-0.57591,0.41662,0.59031,1.57092,0.93110,-1.86015,0.93437,-0.32502,0.20537,0.54705,0.00013,-1.48771,0.60692,0.63041,-0.57848,0.41825,0.59465,1.57092,0.93915,-1.87693,0.93757,-0.32004,0.20510,0.54622,0.00011,-1.48025,0.59202,0.63785,-0.58102,0.41987,0.59898,1.57092,0.94559,-1.89040,0.93975,-0.31586,0.20502,0.54585,0.00012,-1.47275,0.57702,0.64531,-0.58353,0.42150,0.60331,1.57093,0.95063,-1.90100,0.94138,-0.31237,0.20487,0.54544,0.00011,-1.46520,0.56193,0.65278,-0.58601,0.42313,0.60764,1.57093,0.95455,-1.90917,0.94251,-0.30948,0.20469,0.54504,0.00010,-1.45763,0.54678,0.66026,-0.58847,0.42475,0.61197,1.57093,0.95754,-1.91525,0.94320,-0.30711,0.20449,0.54466,0.00009,-1.45003,0.53158,0.66775,-0.59090,0.42637,0.61629,1.57093,0.95979,-1.91956,0.94354,-0.30519,0.20427,0.54429,0.00009,-1.44241,0.51635,0.67524,-0.59333,0.42800,0.62061,1.57093,0.96143,-1.92234,0.94357,-0.30366,0.20404,0.54394,0.00008,-1.43478,0.50109,0.68273,-0.59574,0.42961,0.62493,1.57093,0.96257,-1.92381,0.94334,-0.30247,0.20379,0.54360,0.00008,-1.42714,0.48582,0.69021,-0.59814,0.43123,0.62924,1.57093,0.96331,-1.92416,0.94290,-0.30157,0.20353,0.54327,0.00007,-1.41950,0.47055,0.69770,-0.60053,0.43285,0.63355,1.57093,0.96372,-1.92355,0.94227,-0.30093,0.20327,0.54296,0.00007,-1.41185,0.45528,0.70517,-0.60292,0.43446,0.63786,1.57093,0.96386,-1.92209,0.94150,-0.30052,0.20300,0.54265,0.00007,-1.40420,0.44003,0.71265,-0.60530,0.43607,0.64217,1.57093,0.96378,-1.91990,0.94059,-0.30031,0.20272,0.54236,0.00007,-1.39655,0.42479,0.72011,-0.60769,0.43768,0.64647,1.57093,0.96353,-1.91706,0.93957,-0.30028,0.20245,0.54207,0.00006,-1.38890,0.40958,0.72757,-0.61007,0.43929,0.65078,1.57093,0.96313,-1.91362,0.93846,-0.30042,0.20217,0.54180,0.00006,-1.38126,0.39439,0.73502,-0.61245,0.44089,0.65508,1.57093,0.96260,-1.90963,0.93726,-0.30071,0.20189,0.54153,0.00006,-1.37362,0.37923,0.74245,-0.61484,0.44249,0.65937,1.57093,0.96198,-1.90513,0.93595,-0.30114,0.20162,0.54127,0.00006,-1.36598,0.36411,0.74988,-0.61723,0.44409,0.66367,1.57093,0.96123,-1.90012,0.93471,-0.30178,0.20125,0.54082,0.00006,-1.35835,0.34903,0.75730,-0.61963,0.44569,0.66796,1.57093,0.96043,-1.89460,0.93325,-0.30253,0.20100,0.54062,0.00008,-1.35073,0.33400,0.76471,-0.62203,0.44729,0.67225,1.57094,0.95953,-1.88854,0.93175,-0.30341,0.20072,0.54039,0.00008,-1.34312,0.31901,0.77210,-0.62444,0.44888,0.67654,1.57094,0.95853,-1.88190,0.93016,-0.30444,0.20044,0.54016,0.00008,-1.33551,0.30407,0.77949,-0.62685,0.45047,0.68083,1.57094,0.95743,-1.87463,0.92849,-0.30564,0.20016,0.53993,0.00008,-1.32791,0.28919,0.78685,-0.62928,0.45206,0.68511,1.57094,0.95622,-1.86664,0.92671,-0.30703,0.19989,0.53972,0.00009,-1.32032,0.27438,0.79421,-0.63171,0.45365,0.68940,1.57094,0.95488,-1.85785,0.92480,-0.30864,0.19961,0.53951,0.00009,-1.31274,0.25963,0.80155,-0.63416,0.45523,0.69368,1.57094,0.95338,-1.84810,0.92275,-0.31048,0.19932,0.53930,0.00010,-1.30518,0.24497,0.80887,-0.63663,0.45681,0.69796,1.57094,0.95170,-1.83725,0.92053,-0.31261,0.19903,0.53911,0.00011,-1.29762,0.23039,0.81618,-0.63911,0.45839,0.70224,1.57094,0.94980,-1.82511,0.91811,-0.31507,0.19874,0.53891,0.00011,-1.29009,0.21590,0.82346,-0.64161,0.45997,0.70652,1.57094,0.94763,-1.81144,0.91543,-0.31790,0.19843,0.53872,0.00012,-1.28256,0.20152,0.83073,-0.64413,0.46154,0.71079,1.57094,0.94514,-1.79597,0.91245,-0.32117,0.19811,0.53854,0.00014,-1.27506,0.18727,0.83797,-0.64668,0.46312,0.71507,1.57094,0.94226,-1.77835,0.90911,-0.32497,0.19777,0.53836,0.00015,-1.26759,0.17316,0.84519,-0.64926,0.46469,0.71934,1.57094,0.93892,-1.75821,0.90533,-0.32938,0.19741,0.53819,0.00017,-1.26013,0.15920,0.85237,-0.65187,0.46625,0.72361,1.57095,0.93500,-1.73506,0.90102,-0.33451,0.19702,0.53801,0.00019,-1.25271,0.14543,0.85952,-0.65453,0.46782,0.72788,1.57095,0.93039,-1.70835,0.89608,-0.34049,0.19660,0.53784,0.00021,-1.24533,0.13187,0.86663,-0.65723,0.46938,0.73215,1.57095,0.92495,-1.67742,0.89038,-0.34749,0.19610,0.53760,0.00024,-1.23799,0.11856,0.87370,-0.65999,0.47093,0.73641,1.57095,0.91850,-1.64149,0.88373,-0.35565,0.19558,0.53746,0.00028,-1.23070,0.10553,0.88071,-0.66281,0.47248,0.74068,1.57095,0.91084,-1.59963,0.87597,-0.36518,0.19498,0.53728,0.00031,-1.22347,0.09284,0.88767,-0.66571,0.47403,0.74494,1.57096,0.90169,-1.55075,0.86686,-0.37632,0.19430,0.53709,0.00036,-1.21631,0.08053,0.89455,-0.66870,0.47557,0.74921,1.57096,0.89074,-1.49355,0.85611,-0.38936,0.19351,0.53690,0.00042,-1.20924,0.06868,0.90134,-0.67179,0.47711,0.75347,1.57096,0.87759,-1.42649,0.84336,-0.40458,0.19258,0.53669,0.00048,-1.20228,0.05736,0.90803,-0.67500,0.47864,0.75773,1.57097,0.86170,-1.34777,0.82813,-0.42226,0.19149,0.53644,0.00056,-1.19544,0.04666,0.91461,-0.67835,0.48016,0.76198,1.57097,0.84228,-1.25525,0.80976,-0.44254,0.19017,0.53614,0.00065,-1.18876,0.03670,0.92103,-0.68186,0.48167,0.76624,1.57098,0.81812,-1.14642,0.78721,-0.46520,0.18855,0.53570,0.00075,-1.18226,0.02760,0.92728,-0.68555,0.48316,0.77049,1.57098,0.78706,-1.01834,0.75869,-0.48895,0.18645,0.53495,0.00086,-1.17602,0.01952,0.93330,-0.68943,0.48464,0.77474,1.57099,0.74487,-0.86766,0.72073,-0.50979,0.18354,0.53351,0.00097,-1.17010,0.01263,0.93902,-0.69348,0.48610,0.77897,1.57100,0.68245,-0.69067,0.66593,-0.51696,0.17906,0.53039,0.00105,-1.16469,0.00715,0.94431,-0.69758,0.48752,0.78318,1.57100,0.57890,-0.48387,0.57742,-0.48320,0.17118,0.52320,0.00100,-1.16009,0.00331,0.94889,-0.70142,0.48888,0.78733,1.57101,0.38242,-0.24709,0.41288,-0.34351,0.15583,0.50632,0.00054,-1.15706,0.00135,0.95217,-0.70414,0.49012,0.79135,1.57102,0.00274,-0.01035,0.00265,0.00162,0.00019,0.00005,-0.00001};
	T u[] = {109.60908,-250.57814,48.74772,42.01667,3.47176,2.49360,0.18329,91.43369,-219.20758,38.34109,52.81795,2.13802,-0.61166,-0.06990,73.43999,-196.25818,32.57337,49.96484,1.73732,-0.81149,-0.07225,58.67346,-176.76675,27.89993,46.35165,1.43344,-0.81582,-0.06529,46.66745,-159.95947,24.01419,42.98605,1.18775,-0.78886,-0.05824,36.88142,-145.43648,20.76446,39.94852,0.98702,-0.75024,-0.05171,28.88370,-132.87135,18.03598,37.23851,0.82191,-0.70693,-0.04578,22.33442,-121.98422,15.73774,34.83894,0.68530,-0.66295,-0.04049,16.96388,-112.53456,13.79655,32.72599,0.57174,-0.62070,-0.03579,12.55660,-104.31591,12.15298,30.87298,0.47695,-0.58155,-0.03165,8.93856,-97.15073,10.75817,29.25277,0.39755,-0.54622,-0.02803,5.96918,-90.88692,9.57187,27.83904,0.33084,-0.51496,-0.02487,3.53383,-85.39381,8.56063,26.60718,0.27465,-0.48778,-0.02212,1.53902,-80.55918,7.69654,25.53450,0.22721,-0.46449,-0.01973,-0.09211,-76.28701,6.95618,24.60067,0.18705,-0.44486,-0.01767,-1.42251,-72.49472,6.31969,23.78738,0.15294,-0.42856,-0.01588,-2.49529,-69.10532,5.77476,23.07509,0.12434,-0.41569,-0.01436,-3.37380,-66.07239,5.29683,22.45559,0.09924,-0.40443,-0.01299,-4.08125,-63.33471,4.88305,21.91519,0.07805,-0.39634,-0.01185,-4.64667,-60.84825,4.52077,21.44136,0.05981,-0.39028,-0.01086,-5.09452,-58.57475,4.20158,21.02417,0.04402,-0.38601,-0.01001,-5.44477,-56.48097,3.91828,20.65549,0.03027,-0.38332,-0.00927,-5.71405,-54.53819,3.66468,20.32804,0.01821,-0.38200,-0.00864,-5.91605,-52.72176,3.43550,20.03554,0.00752,-0.38186,-0.00810,-6.06214,-51.01019,3.22618,19.77232,-0.00205,-0.38273,-0.00763,-6.16179,-49.38475,3.03284,19.53357,-0.01074,-0.38447,-0.00721,-6.22285,-47.82893,2.85205,19.31485,-0.01874,-0.38694,-0.00686,-6.25193,-46.32820,2.68088,19.11239,-0.02622,-0.39003,-0.00654,-6.25453,-44.86942,2.51671,18.92263,-0.03335,-0.39363,-0.00625,-6.23533,-43.44075,2.35720,18.74238,-0.04025,-0.39765,-0.00599,-6.19851,-42.03122,2.20017,18.56883,-0.04706,-0.40202,-0.00575,-6.14729,-40.63033,2.04353,18.39904,-0.05393,-0.40666,-0.00552,-6.07994,-39.22643,1.88812,18.22653,-0.06071,-0.41154,-0.00529,-6.01231,-37.81343,1.72540,18.05790,-0.06811,-0.41633,-0.00502,-5.93871,-36.37862,1.55863,17.88529,-0.07575,-0.42163,-0.00477,-5.86209,-34.91181,1.38456,17.70524,-0.08393,-0.42690,-0.00449,-5.78546,-33.40155,1.20122,17.51535,-0.09276,-0.43219,-0.00418,-5.71184,-31.83550,1.00624,17.31272,-0.10238,-0.43751,-0.00381,-5.64452,-30.19983,0.79694,17.09406,-0.11297,-0.44283,-0.00339,-5.58710,-28.47904,0.57028,16.85569,-0.12473,-0.44816,-0.00290,-5.54363,-26.65538,0.32281,16.59343,-0.13790,-0.45351,-0.00231,-5.51869,-24.70854,0.05051,16.30253,-0.15274,-0.45887,-0.00161,-5.51761,-22.61487,-0.25131,15.97757,-0.16958,-0.46427,-0.00077,-5.54669,-20.34678,-0.58821,15.61225,-0.18878,-0.46976,0.00023,-5.61325,-17.87212,-0.96667,15.19925,-0.21078,-0.47537,0.00142,-5.72586,-15.15317,-1.39436,14.73001,-0.23611,-0.48115,0.00285,-5.89506,-12.14550,-1.88055,14.19470,-0.26541,-0.48721,0.00455,-6.13275,-8.79690,-2.43594,13.58124,-0.29938,-0.49361,0.00659,-6.45318,-5.04553,-3.07323,12.87505,-0.33895,-0.50052,0.00902,-6.87719,-0.81928,-3.80988,12.06470,-0.38521,-0.50808,0.01195,-7.42289,3.96796,-4.66280,11.12751,-0.43942,-0.51660,0.01541,-8.11640,9.41734,-5.65487,10.04210,-0.50312,-0.52615,0.01955,-8.98906,15.64853,-6.81359,8.78395,-0.57821,-0.53714,0.02448,-10.07992,22.80280,-8.17320,7.32578,-0.66712,-0.55016,0.03035,-11.43886,31.04718,-9.77743,5.63989,-0.77301,-0.56622,0.03729,-13.13325,40.57883,-11.68539,3.70447,-0.90039,-0.58740,0.04546,-15.26105,51.63004,-13.98339,1.52086,-1.05624,-0.61830,0.05494,-17.98102,64.47339,-16.81259,-0.84351,-1.25287,-0.66962,0.06560,-21.58140,79.42648,-20.43298,-3.14717,-1.51446,-0.76703,0.07678,-26.64299,96.85059,-25.37687,-4.70860,-1.89305,-0.97259,0.08639,-34.44118,117.13088,-32.82843,-3.75557,-2.50906,-1.43693,0.08871,-48.00017,140.55443,-45.60922,4.10258,-3.66373,-2.52031,0.06836,-75.13497,166.53362,-71.37228,28.93045,-6.47330,-6.02510,-0.06988,0,0,0,0,0,0,0};
	T *qdd = (T *)malloc(NUM_POS*64*sizeof(T));
	T *Minv = (T *)malloc(NUM_POS*NUM_POS*64*sizeof(T));
	T *I = (T *)malloc(36*NUM_POS*sizeof(T));
	T *Tbody = (T *)malloc(36*NUM_POS*sizeof(T));
	T *v = (T *)malloc(6*NUM_POS*64*sizeof(T));
	T *a = (T *)malloc(6*NUM_POS*64*sizeof(T));
	T *f = (T *)malloc(6*NUM_POS*64*sizeof(T));
	T *Tfinal = (T *)malloc(36*NUM_POS*64*sizeof(T));
	T *cdq = (T *)malloc(NUM_POS*NUM_POS*64*sizeof(T));
	T *cdqd = (T *)malloc(NUM_POS*NUM_POS*64*sizeof(T));

	#if COMPILE_WITH_FPGA
		GradientProxy *fpga = new GradientProxy(IfcNames_GradientS2H);
		DmaManager *dma = platformInit();
		size_t dataIn1_size = sizeof(FPGADataIn_v1<64,NUM_POS>);
		size_t dataIn2_size = sizeof(FPGADataIn_v2<64,NUM_POS>);
		size_t dataOut_size = sizeof(FPGADataOut<64,NUM_POS>);
		int dataIn1_desc = portalAlloc(dataIn1_size,0);
		int dataIn2_desc = portalAlloc(dataIn2_size,0);
		int dataOut_desc = portalAlloc(dataOut_size,0);
		FPGADataIn_v1<64,NUM_POS> *dataIn_1 = (FPGADataIn_v1<64,NUM_POS>*) portalMmap(dataIn1_desc,dataIn1_size);
		FPGADataIn_v2<64,NUM_POS> *dataIn_2 = (FPGADataIn_v2<64,NUM_POS>*) portalMmap(dataIn2_desc,dataIn2_size);
		FPGADataOut<64,NUM_POS> *dataOut = (FPGADataOut<64,NUM_POS>*) portalMmap(dataOut_desc,dataOut_size);
		unsigned int fpgaIn1Pt = dma->reference(dataIn1_desc);
		unsigned int fpgaIn2Pt = dma->reference(dataIn2_desc);
		unsigned int fpgaOutPt = dma->reference(dataOut_desc);
		// FPGADataIn_v1<64,NUM_POS> dataIn_1_; FPGADataIn_v1<64,NUM_POS> *dataIn_1 = &dataIn_1_;
		// FPGADataIn_v2<64,NUM_POS> dataIn_2_; FPGADataIn_v2<64,NUM_POS> *dataIn_2 = &dataIn_2_;
		// FPGADataOut<64,NUM_POS> dataOut_; FPGADataOut<64,NUM_POS> *dataOut = &dataOut_;
		// unsigned int fpgaIn1Pt, fpgaIn2Pt, fpgaOutPt;
	#else
		printf("You must compile with the FPGA flag turned on for this to work correctly -- printing CPU results only!\n");
	#endif

	// compute all initial values
	initI<T>(I); initT<T>(Tbody); compute_qddMinv<T,64,NUM_POS,1>(Minv,qdd,x,u,I,Tbody,ld_x,ld_u);
	for(int i = 0; i < NUM_POS*NUM_POS*64; i++){cdq[i] = static_cast<T>(0); cdqd[i] = static_cast<T>(0);}
	printf("-----------------\n\n");

	printf("-----------------\n");
	printf("CPU values\n");
	for (int i = 0; i < NUM_POS; i++){printf("I[link=%d]\n",i); printMat<T,6,6>(&I[36*i],6);}
	computeGradientThreaded_Start<T,64,1>(x,u,qdd,v,a,f,I,Tbody,Tfinal,ld_x,ld_u,threads);
	for (int k=0; k<64; k++){
		T *xk = &x[k*ld_x]; T *qdk = &xk[NUM_POS]; T *qddk = &qdd[NUM_POS*k]; 
		T *vk = &v[k*6*NUM_POS]; T *ak = &a[k*6*NUM_POS]; T *fk = &f[k*6*NUM_POS];
		T *Tk = &Tfinal[k*36*NUM_POS];
		printf("q[knot=%d]\n",k); printMat<T,1,NUM_POS>(xk,1);
		printf("qd[knot=%d]\n",k); printMat<T,1,NUM_POS>(qdk,1);
		printf("qdd[knot=%d]\n",k); printMat<T,1,NUM_POS>(qddk,1);
		printf("v[knot=%d]\n",k); printMat<T,6,NUM_POS>(vk,6);
		printf("a[knot=%d]\n",k); printMat<T,6,NUM_POS>(ak,6);
		printf("f[knot=%d]\n",k); printMat<T,6,NUM_POS>(fk,6);
		for (int i = 0; i < NUM_POS; i++){printf("X[knot=%d,link=%d]\n",k,i); printMat<T,6,6>(&Tk[i*36],6);}
		T s_vdq[3*NUM_POS*(NUM_POS+1)];  T s_vdqd[3*NUM_POS*(NUM_POS+1)];
		T s_adq[3*NUM_POS*(NUM_POS+1)];  T s_adqd[3*NUM_POS*(NUM_POS+1)];
		T s_fdq[6*NUM_POS*NUM_POS];      T s_fdqd[6*NUM_POS*NUM_POS];
		T s_cdq[NUM_POS*NUM_POS];      	 T s_cdqd[NUM_POS*NUM_POS];
		compute_vafdu(s_fdq,s_fdqd,s_adq,s_adqd,s_vdq,s_vdqd,fk,ak,vk,qdk,Tk,I);
		// printf("vdq[knot=%d]\n",k); printMat<T,6,3*NUM_POS*(NUM_POS+1)>(s_vdq,6);
		// printf("vdqd[knot=%d]\n",k); printMat<T,6,3*NUM_POS*(NUM_POS+1)>(s_vdqd,6);
		// printf("adq[knot=%d]\n",k); printMat<T,6,3*NUM_POS*(NUM_POS+1)>(s_adq,6);
		// printf("adqd[knot=%d]\n",k); printMat<T,6,3*NUM_POS*(NUM_POS+1)>(s_adqd,6);
		// printf("after forward pass f has garbage values in many columns ignore those except cols 1 -> 7,8 -> 13,14,15 -> etc.\n");
		// printf("fdq[knot=%d]\n",k); printMat<T,6,6*NUM_POS*NUM_POS>(s_fdq,6);
		// printf("fdqd[knot=%d]\n",k); printMat<T,6,6*NUM_POS*NUM_POS>(s_fdqd,6);
		compute_cdu<T,1>(s_cdq,s_cdqd,s_fdq,s_fdqd,Tk,fk);
		// printf("after backward pass f should be all good\n");
		// printf("fdq[knot=%d]\n",k); printMat<T,6,6*NUM_POS*NUM_POS>(s_fdq,6);
		// printf("fdqd[knot=%d]\n",k); printMat<T,6,6*NUM_POS*NUM_POS>(s_fdqd,6);
		printf("cdq[knot=%d]\n",k); printMat<T,NUM_POS,NUM_POS>(s_cdq,NUM_POS);
		printf("cdqd[knot=%d]\n",k); printMat<T,NUM_POS,NUM_POS>(s_cdqd,NUM_POS);
   	}
   	printf("-----------------\n\n");

   	#if COMPILE_WITH_FPGA
		printf("-----------------\n");
		printf("FPGA SPLIT values\n");
		computeGradientThreaded_Start<T,64,1>(x,u,qdd,v,a,f,I,Tbody,Tfinal,ld_x,ld_u,threads);
		for(int i = 0; i < NUM_POS*NUM_POS*64; i++){cdq[i] = static_cast<T>(0); cdqd[i] = static_cast<T>(0);}
		connectallWrapper_1<T,64,NUM_POS>(v,a,f,x,cdq,cdqd,ld_x,dataIn,dataOut,fpgaIn,fpgaOut);
		for (int k=0; k<64; k++){
			T *xk = &x[k*ld_x]; T *qdk = &xk[NUM_POS];
			T *vk = &v[k*6*NUM_POS]; T *ak = &a[k*6*NUM_POS]; T *fk = &f[k*6*NUM_POS];
			T *Tk = &Tfinal[k*36*NUM_POS];
			printf("q[knot=%d]\n",k); printMat<T,1,NUM_POS>(xk,1);
			printf("qd[knot=%d]\n",k); printMat<T,1,NUM_POS>(qdk,1);
			printf("v[knot=%d]\n",k); printMat<T,6,NUM_POS>(vk,6);
			printf("a[knot=%d]\n",k); printMat<T,6,NUM_POS>(ak,6);
			printf("f[knot=%d]\n",k); printMat<T,6,NUM_POS>(fk,6);
			printf("cdq[knot=%d]\n",k); printMat<T,NUM_POS,NUM_POS>(s_cdq,NUM_POS);
			printf("cdqd[knot=%d]\n",k); printMat<T,NUM_POS,NUM_POS>(s_cdqd,NUM_POS6);
	   	}
	   	printf("-----------------\n\n");
   	
		printf("-----------------\n");
		printf("FPGA FUSED values\n");
		for(int i = 0; i < NUM_POS*NUM_POS*64; i++){cdq[i] = static_cast<T>(0); cdqd[i] = static_cast<T>(0);}
		connectallWrapper_2<T,64,NUM_POS>(x,qdd,cdq,cdqd,ld_x,dataIn,dataOut,fpgaIn,fpgaOut);
		for (int k=0; k<64; k++){
			T *xk = &x[k*ld_x]; T *qdk = &xk[NUM_POS]; T *qddk = &qdd[NUM_POS*k]; 
			printf("q[knot=%d]\n",k); printMat<T,1,NUM_POS>(xk,1);
			printf("qd[knot=%d]\n",k); printMat<T,1,NUM_POS>(qdk,1);
			printf("qdd[knot=%d]\n",k); printMat<T,1,NUM_POS>(qddk,1);
			printf("cdq[knot=%d]\n",k); printMat<T,NUM_POS,NUM_POS>(s_cdq,NUM_POS);
			printf("cdqd[knot=%d]\n",k); printMat<T,NUM_POS,NUM_POS>(s_cdqd,NUM_POS6);
	   	}
	   	printf("-----------------\n\n");
   	#endif
	

	printf("-----------------\n");
	printf("Test Complte -- cleaning up\n");
	free(qdd); free(Minv); free(I); free(Tbody); free(v); free(a); free(f); free(Tfinal); free(cdq); free(cdqd);
	printf("-----------------\n");
}