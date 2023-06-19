template <typename T, int MAX_ITERS, int KNOT_POINTS>
int simFig8Test(char hardware, bool doFig8, int dynType = 0, int debugMode = 0){
    const char errMsg[] = "Error: Unkown code - usage is [C]PU, [G]PU, or [F]PGA with flag 1/0 for doFig8 and flag 1/0 for fused(1) vs split(0) for accelerator dynGrad\n";
    if (hardware != 'C' && hardware != 'G' && hardware != 'F'){printf("%s",errMsg); return 1;}

    // Cost params
    T Q_EE1 = 300.0; T Q_EE2 = 0.0; T R_EE = 0.005; T QF_EE1 = 300.0; T QF_EE2 = 0.0;
    T Q_xdEE = 10.0; T QF_xdEE = 10.0; T Q_xEE = 1.0; T QF_xEE = 1.0;

	// get the max iters and time per solve
	printf("What is the maximum number of iterations a solver can take? (q to exit)?\n");
	int iterLimit = getInt<'q'>(1000, 1);
	printf("What should the MPC time budget be (in ms)? (q to exit)?\n");
	int timeLimit = getInt<'q'>(1000, 1); //note in ms
	// get the total traj time
	printf("How many seconds long should one figure eight of the tracked trajectory be? (q to exit)\n");
	double totalTime_us = 1000000.0*static_cast<double>(getInt<'q'>(100, 1)); double timePrint = 0;
	// define the requirements for "conversion" to the first goal
	T eNormLim = 0.05;	 T vNormLim = 0.05;	
	// define local variables
	double goalTime = 0; int initial_convergence_flag = 0; T error = 0; int counter = 0; struct timeval start, end;
	// allocate variables
	algTrace<algType> *atrace = new algTrace<algType>; double t0_plant = 0; double elapsedTime_us = 0;
    int *err, ld_x, ld_u, ld_P, ld_p, ld_AB, ld_H, ld_g, ld_KT, ld_du, ld_d, ld_A;
    T **xs, **us, **qdds, **ds, **JTs, **Minvs, *P, *p, *Pp, *pp, *AB, *H, *g, *KT, *du, *xp, *xp2, *up, *d, *dp, *qddp, *Minvp, *ApBK, *Bdu, *alpha, *dJexp, *xGoal, *I, *Tbody;
    allocateMemory_CPU<T,KNOT_POINTS>(&xs, &xp, &xp2, &us, &up, &qdds, &qddp, &Minvs, &Minvp, &xGoal, &P, &Pp, &p, &pp, &AB, &H, &g, &KT, &du, &ds, &d, &dp, &ApBK, &Bdu, 
                                      &JTs, &dJexp, &alpha, &err, &ld_x, &ld_u, &ld_P, &ld_p, &ld_AB, &ld_H, &ld_g, &ld_KT, &ld_du, &ld_d, &ld_A, &I, &Tbody);
    #if COMPILE_WITH_GPU
        cudaStream_t *streams; T *d_x, *d_qdd, *d_Minv, *d_AB, *d_v, *d_a, *d_f, *d_I, *d_Tbody, *d_Tfinal, *d_cdq, *d_cdqd, *v, *a, *f, *Tfinal, *cdq, *cdqd;
        allocateMemory_GPU<T,KNOT_POINTS>(&d_x,&d_qdd,&d_Minv,&d_AB,&d_v,&d_a,&d_f,&d_I,&d_Tbody,&d_Tfinal,&d_cdq,&d_cdqd,&v,&a,&f,&Tfinal,&cdq,&cdqd,&streams,ld_x,ld_AB,I,Tbody);
    #endif
    #if COMPILE_WITH_FPGA && !COMPILE_WITH_GPU
        T *v, *a, *f, *Tfinal, *cdq, *cdqd;
        allocateMemory_FPGA<T,KNOT_POINTS>(&v,&a,&f,&Tfinal,&cdq,&cdqd);
    #endif
    #if COMPILE_WITH_FPGA
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
    // load initial traj and goal and run to full convergence to warm start
    T *x0 = (T *)std::malloc(ld_x*KNOT_POINTS*sizeof(T)); T *u0 = (T *)std::malloc(ld_u*KNOT_POINTS*sizeof(T)); T *KT0 = (T *)std::malloc(ld_KT*DIM_KT_c*KNOT_POINTS*sizeof(T));
    T *x_old = (T *)std::malloc(ld_x*KNOT_POINTS*sizeof(T)); T *u_old = (T *)std::malloc(ld_u*KNOT_POINTS*sizeof(T)); T *KT_old = (T *)std::malloc(ld_KT*DIM_KT_c*KNOT_POINTS*sizeof(T));
    loadXU<T,KNOT_POINTS,NUM_POS,1>(x0,u0,ld_x,ld_u,KT0,ld_KT); loadFig8Goal<T>(xGoal,goalTime,totalTime_us); 
    T *xActual = (T *)std::malloc(ld_x*sizeof(T)); loadPoint<T,NUM_POS,1>(xActual); T *xNom = (T *)std::malloc(ld_x*sizeof(T)); loadPoint<T,NUM_POS,1>(xNom);
    int alphaIndex[] = {0}; std::memcpy(xs[*alphaIndex],x0,ld_x*KNOT_POINTS*sizeof(T)); std::memcpy(us[*alphaIndex],u0,ld_u*KNOT_POINTS*sizeof(T));
    std::memcpy(xp,x0,ld_x*KNOT_POINTS*sizeof(T)); std::memcpy(up,u0,ld_u*KNOT_POINTS*sizeof(T));
    // warm start the alg
    printf("Traj Loaded Running to Convergence For Warm Start\n");
    #if COMPILE_WITH_GPU && COMPILE_WITH_FPGA
        runiLQR_MPC<T,KNOT_POINTS,false,false,true>(x0,u0,KT0,xGoal,xActual,&elapsedTime_us,&t0_plant,static_cast<double>(0),MAX_ITERS,atrace,
                                                  xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
                                                  KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
                                                  ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
                                                  v,a,f,Tfinal,cdq,cdqd,
                                                  streams,d_x,d_qdd,d_Minv,d_AB,d_v,d_a,d_f,d_I,d_Tbody,d_Tfinal,d_cdq,d_cdqd,
                                                  dataIn1,dataIn2,dataOut,fpgaIn1Pt,fpgaIn2Pt,fpgaOutPt,
                                                  Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
    #elif COMPILE_WITH_GPU
        runiLQR_MPC<T,KNOT_POINTS,false,false,true>(x0,u0,KT0,xGoal,xActual,&elapsedTime_us,&t0_plant,static_cast<double>(0),MAX_ITERS,atrace,
                                                  xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
                                                  KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
                                                  ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
                                                  v,a,f,Tfinal,cdq,cdqd,
                                                  streams,d_x,d_qdd,d_Minv,d_AB,d_v,d_a,d_f,d_I,d_Tbody,d_Tfinal,d_cdq,d_cdqd,
                                                  Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
    #elif COMPILE_WITH_FPGA
        runiLQR_MPC<T,KNOT_POINTS,false,false,true>(x0,u0,KT0,xGoal,xActual,&elapsedTime_us,&t0_plant,static_cast<double>(0),MAX_ITERS,atrace,
                                                  xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
                                                  KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
                                                  ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
                                                  v,a,f,Tfinal,cdq,cdqd,
                                                  dataIn1,dataIn2,dataOut,fpgaIn1Pt,fpgaIn2Pt,fpgaOutPt,
                                                  Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
    #else
        runiLQR_MPC<T,KNOT_POINTS,false,false,true>(x0,u0,KT0,xGoal,xActual,&elapsedTime_us,&t0_plant,static_cast<double>(0),MAX_ITERS,atrace,
                                                  xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
                                                  KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
                                                  ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
                                                  Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
    #endif
    // compute initial error
    fig8Simulate<T,KNOT_POINTS,150,true>(x0,u0,KT0,xActual,xGoal,ld_x,ld_u,ld_KT,&error,&goalTime,&timePrint,&counter,&initial_convergence_flag,
                                elapsedTime_us,totalTime_us,eNormLim,vNormLim,doFig8);
    // then start a loop of run a couple steps simulate for X steps and repeat
    printf("Starting Task\n");
    while(1){
        counter++;
        gettimeofday(&start,NULL);
        #if COMPILE_WITH_GPU && COMPILE_WITH_FPGA
            runiLQR_MPC<T,KNOT_POINTS,true,true,true>(x0,u0,KT0,xGoal,xActual,&elapsedTime_us,&t0_plant,timeLimit,iterLimit,atrace,
                                                      xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
                                                      KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
                                                      ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
                                                      v,a,f,Tfinal,cdq,cdqd,
                                                      streams,d_x,d_qdd,d_Minv,d_AB,d_v,d_a,d_f,d_I,d_Tbody,d_Tfinal,d_cdq,d_cdqd,
                                                      dataIn1,dataIn2,dataOut,fpgaIn1Pt,fpgaIn2Pt,fpgaOutPt,
                                                      Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
        #elif COMPILE_WITH_GPU
            runiLQR_MPC<T,KNOT_POINTS,true,true,true>(x0,u0,KT0,xGoal,xActual,&elapsedTime_us,&t0_plant,timeLimit,iterLimit,atrace,
                                                      xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
                                                      KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
                                                      ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
                                                      v,a,f,Tfinal,cdq,cdqd,
                                                      streams,d_x,d_qdd,d_Minv,d_AB,d_v,d_a,d_f,d_I,d_Tbody,d_Tfinal,d_cdq,d_cdqd,
                                                      Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
        #elif COMPILE_WITH_FPGA
            runiLQR_MPC<T,KNOT_POINTS,true,true,true>(x0,u0,KT0,xGoal,xActual,&elapsedTime_us,&t0_plant,timeLimit,iterLimit,atrace,
                                                      xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
                                                      KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
                                                      ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
                                                      v,a,f,Tfinal,cdq,cdqd,
                                                      dataIn1,dataIn2,dataOut,fpgaIn1Pt,fpgaIn2Pt,fpgaOutPt,
                                                      Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
        #else
            runiLQR_MPC<T,KNOT_POINTS,true,true,true>(x0,u0,KT0,xGoal,xActual,&elapsedTime_us,&t0_plant,timeLimit,iterLimit,atrace,
                                                      xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
                                                      KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
                                                      ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
                                                      Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
        #endif
        gettimeofday(&end,NULL);
        elapsedTime_us = time_delta_us(start,end);//TIME_STEP*1000000*1.01;
        if(fig8Simulate<T,KNOT_POINTS,150,true>(x0,u0,KT0,xActual,xGoal,ld_x,ld_u,ld_KT,&error,&goalTime,&timePrint,&counter,&initial_convergence_flag,
                                       elapsedTime_us,totalTime_us,eNormLim,vNormLim,doFig8)){break;}
    }
	// print results
	printf("\n\nAverage tracking error: [%f]\n",(error/counter));
    printAllTimingStats(atrace);
	// free and delete
    #if COMPILE_WITH_GPU
        freeMemory_GPU<T>(d_x,d_qdd,d_Minv,d_AB,d_v,d_a,d_f,d_I,d_Tbody,d_Tfinal,d_cdq,d_cdqd,v,a,f,Tfinal,cdq,cdqd,streams); 
    #endif
    #if COMPILE_WITH_FPGA && !COMPILE_WITH_GPU
        freeMemory_FPGA(v,a,f,Tfinal,cdq,cdqd);
    #endif
    #if COMPILE_WITH_FPGA
    #endif
    freeMemory_CPU<T>(xs,xp,xp2,us,up,qdds,qddp,Minvs,Minvp,P,Pp,p,pp,AB,H,g,KT,du,ds,d,dp,Bdu,ApBK,dJexp,err,alpha,JTs,xGoal,I,Tbody); delete atrace;
    std::free(x0); std::free(u0); std::free(KT0); std::free(x_old); std::free(u_old); std::free(KT_old); std::free(xActual); std::free(xNom);
    return 0;
}
