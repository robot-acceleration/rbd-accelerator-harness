template <typename T, int TEST_ITERS, int MAX_ITERS, int KNOT_POINTS, bool IGNORE_MAX_ROX_EXIT = true>
int convergenceTest(char test, int USE_FUSED_DYN_GRAD){
	char errMsg[]  = "Error: Unkown code - usage is [C]PU, [G]PU, or [F]PGA (with 0 for split and 1 for fused - e.g., G0)\n If a valid code isn't working check your compile flags.";

	// Cost params
	T Q1 = 0.01; T Q2 = 0.001; T R  = 0.0001; T QF1 = 1000.0; T QF2 = 1000.0;
	T Q_EE1 = 0.1; T Q_EE2 = 0.0; T R_EE = 0.00001; T QF_EE1 = 1000.0; T QF_EE2 = 0.0;
	T Q_xdEE = 0.1; T QF_xdEE = 100.0; T Q_xEE = 0.0; T QF_xEE = 0.0;

	// CPU VARS	
	// first integer constants for the leading dimmensions of allocaitons
	int ld_x, ld_u, ld_P, ld_p, ld_AB, ld_H, ld_g, ld_KT, ld_du, ld_d, ld_A;
	// algorithm hyper parameters
	T *alpha;
	// then variables defined by blocks for backward pass
	T *P, *p, *Pp, *pp, *AB, *H, *g, *KT, *du;
	// variables for forward pass
	T *xp, *xp2, *up, *qddp, *Minvp; //x,u removed b/c parallel now
	// variables for forward sweep
	T *d, *dp, *ApBK, *Bdu;
	// for checking inversion errors
	int *err;
	// for expected cost reduction
	T *dJexp;
	// goal point
  	T *xGoal;
    // Inertias and Tbodybase
    T *I, *Tbody;
    // parallel alphas
    T **xs, **us, **qdds, **ds, **JTs, **Minvs;

	// Allocate space and initialize the variables
	allocateMemory_CPU<T,KNOT_POINTS>(&xs, &xp, &xp2, &us, &up, &qdds, &qddp, &Minvs, &Minvp, &xGoal, &P, &Pp, &p, &pp, &AB, &H, &g, &KT, &du, &ds, &d, &dp, &ApBK, &Bdu, 
						   &JTs, &dJexp, &alpha, &err, &ld_x, &ld_u, &ld_P, &ld_p, &ld_AB, &ld_H, &ld_g, &ld_KT, &ld_du, &ld_d, &ld_A, &I, &Tbody);

    T *x0 = (T *)malloc(ld_x*KNOT_POINTS*sizeof(T));
    T *u0 = (T *)malloc(ld_u*KNOT_POINTS*sizeof(T));

    #if COMPILE_WITH_GPU
    	// CPU counterparts for accelerators
    	T *v, *a, *f, *Tfinal, *cdq, *cdqd;
	    // GPU vars
		cudaStream_t *streams; T *d_x, *d_qdd, *d_Minv, *d_AB, *d_v, *d_a, *d_f, *d_I, *d_Tbody, *d_Tfinal, *d_cdq, *d_cdqd;
		// dims for kernels
		dim3 gridDimms(KNOT_POINTS-1,1); dim3 blockDimms(NUM_POS,NUM_POS);
		// allocate
		allocateMemory_GPU<T,KNOT_POINTS>(&d_x,&d_qdd,&d_Minv,&d_AB,&d_v,&d_a,&d_f,&d_I,&d_Tbody,&d_Tfinal,&d_cdq,&d_cdqd,&v,&a,&f,&Tfinal,&cdq,&cdqd,&streams,ld_x,ld_AB,I,Tbody);
	#endif
	#if COMPILE_WITH_FPGA && !COMPILE_WITH_GPU
		// allocate CPU counterparts for accelerators
    	T *v, *a, *f, *Tfinal, *cdq, *cdqd;
		allocateMemory_FPGA<T,KNOT_POINTS>(&v,&a,&f,&Tfinal,&cdq,&cdqd);
	#endif
	#if COMPILE_WITH_FPGA
		// FPGA data structures
		#define NUM_LINKS NUM_POS
        GradientProxy *fpga = new GradientProxy(IfcNames_GradientS2H);
        DmaManager *dma = platformInit();
        size_t dataIn1_size = sizeof(FPGADataIn_v1<KNOT_POINTS,NUM_LINKS>);
        size_t dataIn2_size = sizeof(FPGADataIn_v2<KNOT_POINTS,NUM_LINKS>);
        size_t dataOut_size = sizeof(FPGADataOut<KNOT_POINTS,NUM_LINKS>);
        int dataIn1_desc = portalAlloc(dataIn1_size,0);
        int dataIn2_desc = portalAlloc(dataIn2_size,0);
        int dataOut_desc = portalAlloc(dataOut_size,0);
        FPGADataIn_v1<KNOT_POINTS,NUM_LINKS> *dataIn1 = (FPGADataIn_v1<KNOT_POINTS,NUM_LINKS>*) portalMmap(dataIn1_desc,dataIn1_size);
        FPGADataIn_v2<KNOT_POINTS,NUM_LINKS> *dataIn2 = (FPGADataIn_v2<KNOT_POINTS,NUM_LINKS>*) portalMmap(dataIn2_desc,dataIn2_size);
        FPGADataOut<KNOT_POINTS,NUM_LINKS> *dataOut = (FPGADataOut<KNOT_POINTS,NUM_LINKS>*) portalMmap(dataOut_desc,dataOut_size);
        unsigned int fpgaIn1Pt = dma->reference(dataIn1_desc);
        unsigned int fpgaIn2Pt = dma->reference(dataIn2_desc);
        unsigned int fpgaOutPt = dma->reference(dataOut_desc);
		// FPGADataIn_v1<KNOT_POINTS,NUM_LINKS> dataIn_1_; FPGADataIn_v1<KNOT_POINTS,NUM_LINKS> *dataIn1 = &dataIn_1_;
		// FPGADataIn_v2<KNOT_POINTS,NUM_LINKS> dataIn_2_; FPGADataIn_v2<KNOT_POINTS,NUM_LINKS> *dataIn2 = &dataIn_2_;
		// FPGADataOut<KNOT_POINTS,NUM_LINKS> dataOut_; FPGADataOut<KNOT_POINTS,NUM_LINKS> *dataOut = &dataOut_;
		// unsigned int fpgaIn1Pt, fpgaIn2Pt, fpgaOutPt;
	#endif

    // #if EE_COST
    // 	CostParams<T> params; loadParams(&params, _Q_xEE, _Q_xdEE , _QF_xEE, _QF_xdEE, _R_EE, _Q_EE1, _Q_EE2, _QF_EE1, _QF_EE2);
    // #else
    // 	CostParams<T> params; loadParams(&params, _Q1, _Q2, _QF1, _QF2, _R);
    // #endif

    double *tTime = (double *)malloc(TEST_ITERS*sizeof(double)); double *initTime = (double *)malloc(TEST_ITERS*sizeof(double)); 
    size_t timeSize = TEST_ITERS*MAX_ITERS*sizeof(double); double *fsimTime = (double *)malloc(timeSize); double *fsweepTime = (double *)malloc(timeSize);
    double *bpTime = (double *)malloc(timeSize); double *nisTime = (double *)malloc(timeSize); 
    int traceSize = TEST_ITERS*(MAX_ITERS+1); T *Jout = (T *)malloc(traceSize*sizeof(T)); int *alphaOut = (int *)malloc(traceSize*sizeof(int));

	bool BAD_CODE = false;
    for (int i=0; i < TEST_ITERS; i++){
      	loadXU<T,KNOT_POINTS,NUM_POS,false>(x0,u0,ld_x,ld_u);
      	loadSingleGoal<T,EE_COST>(xGoal);
      	if (test == 'C'){
	      	printf("<<<TESTING CPU-P %d/%d>>>\n",i+1,TEST_ITERS);
	      	runiLQR_CPU<T,KNOT_POINTS,MAX_ITERS,IGNORE_MAX_ROX_EXIT>(x0, u0, nullptr, nullptr, nullptr, nullptr, xGoal, &Jout[i*(MAX_ITERS+1)], &alphaOut[i*(MAX_ITERS+1)], 0, 1, 1,
						   &tTime[i], &fsimTime[i*MAX_ITERS], &fsweepTime[i*MAX_ITERS], &bpTime[i*MAX_ITERS], &nisTime[i*MAX_ITERS], &initTime[i], 
						   xs, xp, xp2, us, up, qdds, qddp, Minvs, Minvp, P, p, Pp, pp, AB, H, g, KT, du, ds, d, dp, ApBK, Bdu, alpha, JTs, dJexp, err,
						   ld_x, ld_u, ld_P, ld_p, ld_AB, ld_H, ld_g, ld_KT, ld_du, ld_d, ld_A, I, Tbody, 
						   Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE);
	      				   // &params);	
      	}
      	#if COMPILE_WITH_GPU
	      	else if (test == 'G'){
		      	if (USE_FUSED_DYN_GRAD){
	      			printf("<<<TESTING GPU-Fused %d/%d>>>\n",i+1,TEST_ITERS);
			      	runiLQR_GPU<T,KNOT_POINTS,MAX_ITERS,IGNORE_MAX_ROX_EXIT,1>(x0, u0, nullptr, nullptr, nullptr, nullptr, xGoal, &Jout[i*(MAX_ITER+1)], &alphaOut[i*(MAX_ITER+1)], 0, 1, 1,
								    &tTime[i], &fsimTime[i*MAX_ITER], &fsweepTime[i*MAX_ITER], &bpTime[i*MAX_ITER], &nisTime[i*MAX_ITER], &initTime[i], 
								    xs, xp, xp2, us, up, qdds, qddp, Minvs, Minvp, P, p, Pp, pp, AB, H, g, KT, du, ds, d, dp, ApBK, Bdu, alpha, JTs, dJexp, err,
								    ld_x, ld_u, ld_P, ld_p, ld_AB, ld_H, ld_g, ld_KT, ld_du, ld_d, ld_A, 
								    I, Tbody, v, a, f, Tfinal, cdq, cdqd, gridDimms, blockDimms, 
								    streams, d_x, d_qdd, d_Minv, d_AB, d_v, d_a, d_f, d_I, d_Tbody, d_Tfinal, d_cdq, d_cdqd,  
								    Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE);
		      	}
		      	else{
		      		printf("<<<TESTING GPU-Split %d/%d>>>\n",i+1,TEST_ITERS);
		      		runiLQR_GPU<T,KNOT_POINTS,MAX_ITERS,IGNORE_MAX_ROX_EXIT,0>(x0, u0, nullptr, nullptr, nullptr, nullptr, xGoal, &Jout[i*(MAX_ITER+1)], &alphaOut[i*(MAX_ITER+1)], 0, 1, 1,
								    &tTime[i], &fsimTime[i*MAX_ITER], &fsweepTime[i*MAX_ITER], &bpTime[i*MAX_ITER], &nisTime[i*MAX_ITER], &initTime[i], 
								    xs, xp, xp2, us, up, qdds, qddp, Minvs, Minvp, P, p, Pp, pp, AB, H, g, KT, du, ds, d, dp, ApBK, Bdu, alpha, JTs, dJexp, err,
								    ld_x, ld_u, ld_P, ld_p, ld_AB, ld_H, ld_g, ld_KT, ld_du, ld_d, ld_A, 
								    I, Tbody, v, a, f, Tfinal, cdq, cdqd, gridDimms, blockDimms, 
								    streams, d_x, d_qdd, d_Minv, d_AB, d_v, d_a, d_f, d_I, d_Tbody, d_Tfinal, d_cdq, d_cdqd,  
								    Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE);
		      	}
	      	}
	    #endif
	    #if COMPILE_WITH_FPGA
	      	else if (test == 'F'){
		      	if (USE_FUSED_DYN_GRAD){
		      		printf("<<<TESTING FPGA-Fused %d/%d>>>\n",i+1,TEST_ITERS);
			      	runiLQR_FPGA<T,KNOT_POINTS,MAX_ITERS,IGNORE_MAX_ROX_EXIT,1>(x0, u0, nullptr, nullptr, nullptr, nullptr, xGoal, &Jout[i*(MAX_ITER+1)], &alphaOut[i*(MAX_ITER+1)], 0, 1, 1,
								    &tTime[i], &fsimTime[i*MAX_ITER], &fsweepTime[i*MAX_ITER], &bpTime[i*MAX_ITER], &nisTime[i*MAX_ITER], &initTime[i], 
								    xs, xp, xp2, us, up, qdds, qddp, Minvs, Minvp, P, p, Pp, pp, AB, H, g, KT, du, ds, d, dp, ApBK, Bdu, alpha, JTs, dJexp, err,
								    ld_x, ld_u, ld_P, ld_p, ld_AB, ld_H, ld_g, ld_KT, ld_du, ld_d, ld_A, 
								    I, Tbody, v, a, f, Tfinal, cdq, cdqd, dataIn1, dataIn2, dataOut, fpgaIn1Pt, fpgaIn2Pt, fpgaOutPt,
								    Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE);
		      	}
		      	else{
		      		printf("<<<TESTING FPGA-Split %d/%d>>>\n",i+1,TEST_ITERS);
		      		runiLQR_FPGA<T,KNOT_POINTS,MAX_ITERS,IGNORE_MAX_ROX_EXIT,0>(x0, u0, nullptr, nullptr, nullptr, nullptr, xGoal, &Jout[i*(MAX_ITER+1)], &alphaOut[i*(MAX_ITER+1)], 0, 1, 1,
								    &tTime[i], &fsimTime[i*MAX_ITER], &fsweepTime[i*MAX_ITER], &bpTime[i*MAX_ITER], &nisTime[i*MAX_ITER], &initTime[i], 
								    xs, xp, xp2, us, up, qdds, qddp, Minvs, Minvp, P, p, Pp, pp, AB, H, g, KT, du, ds, d, dp, ApBK, Bdu, alpha, JTs, dJexp, err,
								    ld_x, ld_u, ld_P, ld_p, ld_AB, ld_H, ld_g, ld_KT, ld_du, ld_d, ld_A, 
								    I, Tbody, v, a, f, Tfinal, cdq, cdqd, dataIn1, dataIn2, dataOut, fpgaIn1Pt, fpgaIn2Pt, fpgaOutPt,
								    Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE);
		      	}
	      	}
	    #endif
	    else{BAD_CODE = true; break;}
	}
	// free those vars
	#if COMPILE_WITH_GPU
		freeMemory_GPU(d_x,d_qdd,d_Minv,d_AB,d_v,d_a,d_f,d_I,d_Tbody,d_Tfinal,d_cdq,d_cdqd,v,a,f,Tfinal,cdq,cdqd,streams);
	#endif
	#if COMPILE_WITH_FPGA && !COMPILE_WITH_GPU
		freeMemory_FPGA(v,a,f,Tfinal,cdq,cdqd);
	#endif
	freeMemory_CPU<T>(xs, xp, xp2, us, up, qdds, qddp, Minvs, Minvp, P, Pp, p, pp, AB, H, g, KT, du, ds, d, dp, Bdu, ApBK, dJexp, err, alpha, JTs, xGoal, I, Tbody);

	if (BAD_CODE){printf("%s",errMsg); free(x0); free(u0); return 1;}
	else{
		// print final state
		printf("Final state:\n");	for (int i = 0; i < STATE_SIZE; i++){printf("%15.5f ",x0[(KNOT_POINTS-2)*ld_x + i]);}	printf("\n");
		// printf("Final control:\n");    for (int i = 0; i < CONTROL_SIZE; i++){printf("%15.5f ",u0[(KNOT_POINTS-2)*ld_u + i]);}	printf("\n");
		
		// print all requested statistics
	   	printJAlphaStats<T,TEST_ITERS,MAX_ITERS>(Jout,alphaOut);
	   	printAllTimingStats<TEST_ITERS,MAX_ITERS>(tTime,initTime,fsimTime,fsweepTime,bpTime,nisTime);

		free(x0); free(u0); free(Jout); free(alphaOut); free(tTime); free(initTime); free(fsimTime); free(fsweepTime); free(bpTime); free(nisTime);
	    return 0;
	}
}