template <typename T, int MAX_ITERS, int KNOT_POINTS, int TRAJ_RUNNER_TIME_STEPS>
class LCM_MPCLoop_Handler {
    public:
    	// variables for algorithm
    	char hardware; int dynType; bool first_pass; // algFlags
    	int iterLimit, timeLimit; // limits for solves
        lcm::LCM lcm_ptr; // ptr to LCM object for publish ability
		algTrace<algType> *atrace; double t0_plant = 0; double elapsedTime_us = 0;
	    int *err, ld_x, ld_u, ld_P, ld_p, ld_AB, ld_H, ld_g, ld_KT, ld_du, ld_d, ld_A;
	    T **xs, **us, **qdds, **ds, **JTs, **Minvs, *P, *p, *Pp, *pp, *AB, *H, *g, *KT, *du, *xp, *xp2, *up, *d, *dp, *qddp, *Minvp, *ApBK, *Bdu, *alpha, *dJexp, *xGoal, *I, *Tbody;
	    T *x0, *x_old, *u0, *u_old, *KT0, *KT_old, *xActual, *xNom; int alphaIndex[1]; double tPlant, tPlant_prev;
	    #if COMPILE_WITH_GPU
	        cudaStream_t *streams; T *d_x, *d_qdd, *d_Minv, *d_AB, *d_v, *d_a, *d_f, *d_I, *d_Tbody, *d_Tfinal, *d_cdq, *d_cdqd, *v, *a, *f, *Tfinal, *cdq, *cdqd;
	    #endif
	    #if COMPILE_WITH_FPGA && !COMPILE_WITH_GPU
	        T *v, *a, *f, *Tfinal, *cdq, *cdqd;
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
        T Q_EE1, Q_EE2, QF_EE1, QF_EE2, R_EE, Q_xdEE, QF_xdEE, Q_xEE, QF_xEE;

        // constructor allocator loader initer
        LCM_MPCLoop_Handler(char hw, int dT, int iL, int tL) : hardware(hw), dynType(dT), iterLimit(iL), timeLimit(tL) {
        	if(!lcm_ptr.good()){printf("LCM Failed to Init in Traj Runner\n");} first_pass = true;
        	// allocate all memory
        	atrace = new algTrace<algType>;
        	allocateMemory_CPU<T,KNOT_POINTS>(&xs, &xp, &xp2, &us, &up, &qdds, &qddp, &Minvs, &Minvp, &xGoal, &P, &Pp, &p, &pp, &AB, &H, &g, &KT, &du, &ds, &d, &dp, &ApBK, &Bdu, 
                                      &JTs, &dJexp, &alpha, &err, &ld_x, &ld_u, &ld_P, &ld_p, &ld_AB, &ld_H, &ld_g, &ld_KT, &ld_du, &ld_d, &ld_A, &I, &Tbody);
        	x0 = (T *)std::malloc(ld_x*KNOT_POINTS*sizeof(T)); 		u0 = (T *)std::malloc(ld_u*KNOT_POINTS*sizeof(T));		KT0 = (T *)std::malloc(ld_KT*DIM_KT_c*KNOT_POINTS*sizeof(T));
    		x_old = (T *)std::malloc(ld_x*KNOT_POINTS*sizeof(T)); 	u_old = (T *)std::malloc(ld_u*KNOT_POINTS*sizeof(T));	KT_old = (T *)std::malloc(ld_KT*DIM_KT_c*KNOT_POINTS*sizeof(T));
    		xActual = (T *)std::malloc(ld_x*sizeof(T));				xNom = (T *)std::malloc(ld_x*sizeof(T));
        	#if COMPILE_WITH_GPU
		        allocateMemory_GPU<T,KNOT_POINTS>(&d_x,&d_qdd,&d_Minv,&d_AB,&d_v,&d_a,&d_f,&d_I,&d_Tbody,&d_Tfinal,&d_cdq,&d_cdqd,&v,&a,&f,&Tfinal,&cdq,&cdqd,&streams,ld_x,ld_AB,I,Tbody);
		    #endif
		    #if COMPILE_WITH_FPGA && !COMPILE_WITH_GPU
		        allocateMemory_FPGA<T,KNOT_POINTS>(&v,&a,&f,&Tfinal,&cdq,&cdqd);
		    #endif
		    // load initial values
		    loadInitialFig8GoalNomActual<T>(xGoal,xNom,xActual); *alphaIndex = 0;
		    loadXU<T,KNOT_POINTS,NUM_POS,1>(x0,u0,ld_x,ld_u,KT0,ld_KT);
		    std::memcpy(xs[*alphaIndex],x0,ld_x*KNOT_POINTS*sizeof(T)); std::memcpy(us[*alphaIndex],u0,ld_u*KNOT_POINTS*sizeof(T));
    		std::memcpy(xp,x0,ld_x*KNOT_POINTS*sizeof(T)); std::memcpy(up,u0,ld_u*KNOT_POINTS*sizeof(T));
    		// default cost terms for the start of the goal to move the arm from the initial point to the start of the fig 8
	        Q_EE1 = 50; Q_EE2 = 0; QF_EE1 = 100.0; QF_EE2 = 0;
	        R_EE = 0.001; // make 0.001 for the move to inital goal and then to 0.0005 for motion
	        Q_xdEE = 10; QF_xdEE = 10; Q_xEE = 0; QF_xEE = 0;
	        tPlant = 0; tPlant_prev = 0;
    		// run to convergence to warm-start
		    #if COMPILE_WITH_GPU && COMPILE_WITH_FPGA
		        runiLQR_MPC<T,KNOT_POINTS,false,false,false>(x0,u0,KT0,xGoal,xActual,&tPlant,&tPlant_prev,static_cast<double>(0),MAX_ITERS,atrace,
		                                                  xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
		                                                  KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
		                                                  ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
		                                                  v,a,f,Tfinal,cdq,cdqd,
		                                                  streams,d_x,d_qdd,d_Minv,d_AB,d_v,d_a,d_f,d_I,d_Tbody,d_Tfinal,d_cdq,d_cdqd,
		                                                  dataIn1,dataIn2,dataOut,fpgaIn1Pt,fpgaIn2Pt,fpgaOutPt,
		                                                  Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
		    #elif COMPILE_WITH_GPU
		        runiLQR_MPC<T,KNOT_POINTS,false,false,false>(x0,u0,KT0,xGoal,xActual,&tPlant,&tPlant_prev,static_cast<double>(0),MAX_ITERS,atrace,
		                                                  xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
		                                                  KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
		                                                  ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
		                                                  v,a,f,Tfinal,cdq,cdqd,
		                                                  streams,d_x,d_qdd,d_Minv,d_AB,d_v,d_a,d_f,d_I,d_Tbody,d_Tfinal,d_cdq,d_cdqd,
		                                                  Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
		    #elif COMPILE_WITH_FPGA
		        runiLQR_MPC<T,KNOT_POINTS,false,false,false>(x0,u0,KT0,xGoal,xActual,&tPlant,&tPlant_prev,static_cast<double>(0),MAX_ITERS,atrace,
		                                                  xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
		                                                  KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
		                                                  ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
		                                                  v,a,f,Tfinal,cdq,cdqd,
		                                                  dataIn1,dataIn2,dataOut,fpgaIn1Pt,fpgaIn2Pt,fpgaOutPt,
		                                                  Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
		    #else
		        runiLQR_MPC<T,KNOT_POINTS,false,false,false>(x0,u0,KT0,xGoal,xActual,&tPlant,&tPlant_prev,static_cast<double>(0),MAX_ITERS,atrace,
		                                                  xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
		                                                  KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
		                                                  ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
		                                                  Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
		    #endif
		    printf("Allocation and Warm-Start Complete\n");
    	}
    	// free vars in destructor
        ~LCM_MPCLoop_Handler(){
        	// printAllTimingStats(atrace);
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
        }

        // lcm callback function for new arm goal (eePos)
        void handleGoalEE(const lcm::ReceiveBuffer *rbuf, const std::string &chan, const drake::lcmt_target_twist *msg){
            std::memcpy(xGoal,msg->position,3*sizeof(T));     std::memcpy(&xGoal[3],msg->velocity,3*sizeof(T));
        }

        // lcm callback function for new cost function parameters
        void handleCostParams(const lcm::ReceiveBuffer *rbuf, const std::string &chan, const drake::lcmt_cost_params *msg){
            Q_EE1 = msg->q_ee1;     Q_EE2 = msg->q_ee2;     QF_EE1 = msg->qf_ee1;   QF_EE2 = msg->qf_ee2; 
            Q_xdEE = msg->q_xdee;   QF_xdEE = msg->qf_xdee; Q_xEE = msg->q_xee;     QF_xEE = msg->qf_xee;   R_EE = msg->r_ee;
        }
    
        // lcm callback function for new arm status
        void handleStatus(const lcm::ReceiveBuffer *rbuf, const std::string &chan, const drake::lcmt_iiwa_status *msg){
            tPlant = static_cast<double>(msg->utime);
            // if first keep inital traj (so set xActual to x and tprev to t)
            if (first_pass){ 
                #pragma unroll
                for (int i=0; i<STATE_SIZE; i++){xActual[i] = x0[i];} tPlant_prev = tPlant; first_pass = false;
            }
            // else update xActual
            else{
                #pragma unroll
                for (int i=0; i<NUM_POS; i++){xActual[i]         = (T)(msg->joint_position_measured)[i]; 
                                              xActual[i+NUM_POS] = (T)(msg->joint_velocity_estimated)[i];}
            }
            // run control loop
            #if COMPILE_WITH_GPU && COMPILE_WITH_FPGA
	            runiLQR_MPC<T,KNOT_POINTS,true,false,false>(x0,u0,KT0,xGoal,xActual,&tPlant,&tPlant_prev,timeLimit,iterLimit,atrace,
	                                                      xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
	                                                      KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
	                                                      ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
	                                                      v,a,f,Tfinal,cdq,cdqd,
	                                                      streams,d_x,d_qdd,d_Minv,d_AB,d_v,d_a,d_f,d_I,d_Tbody,d_Tfinal,d_cdq,d_cdqd,
	                                                      dataIn1,dataIn2,dataOut,fpgaIn1Pt,fpgaIn2Pt,fpgaOutPt,
	                                                      Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
	        #elif COMPILE_WITH_GPU
	            runiLQR_MPC<T,KNOT_POINTS,true,false,false>(x0,u0,KT0,xGoal,xActual,&tPlant,&tPlant_prev,timeLimit,iterLimit,atrace,
	                                                      xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
	                                                      KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
	                                                      ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
	                                                      v,a,f,Tfinal,cdq,cdqd,
	                                                      streams,d_x,d_qdd,d_Minv,d_AB,d_v,d_a,d_f,d_I,d_Tbody,d_Tfinal,d_cdq,d_cdqd,
	                                                      Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
	        #elif COMPILE_WITH_FPGA
	            runiLQR_MPC<T,KNOT_POINTS,true,false,false>(x0,u0,KT0,xGoal,xActual,&tPlant,&tPlant_prev,timeLimit,iterLimit,atrace,
	                                                      xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
	                                                      KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
	                                                      ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
	                                                      v,a,f,Tfinal,cdq,cdqd,
	                                                      dataIn1,dataIn2,dataOut,fpgaIn1Pt,fpgaIn2Pt,fpgaOutPt,
	                                                      Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
	        #else
	            runiLQR_MPC<T,KNOT_POINTS,true,false,false>(x0,u0,KT0,xGoal,xActual,&tPlant,&tPlant_prev,timeLimit,iterLimit,atrace,
	                                                      xs,xp,xp2,x_old,us,up,u_old,qdds,qddp,Minvs,Minvp,P,p,Pp,pp,AB,H,g,
	                                                      KT,KT_old,du,ds,d,dp,ApBK,Bdu,alpha,alphaIndex,I,Tbody,JTs,dJexp,err,
	                                                      ld_x,ld_u,ld_P,ld_p,ld_AB,ld_H,ld_g,ld_KT,ld_du,ld_d,ld_A,hardware,dynType,
	                                                      Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
	        #endif
            // publish to trajRunner
            if (std::is_same<T, float>::value){
                drake::lcmt_trajectory_f dataOut;		dataOut.utime = tPlant;		int stepsSize = TRAJ_RUNNER_TIME_STEPS*sizeof(float);
                int uSize = ld_u*stepsSize;				dataOut.u_size = uSize;		dataOut.u.resize(dataOut.u_size);       std::memcpy(&(dataOut.u[0]),u0,uSize);
                int xSize = ld_x*stepsSize;				dataOut.x_size = xSize;     dataOut.x.resize(dataOut.x_size);       std::memcpy(&(dataOut.x[0]),x0,xSize);
                int KTSize = ld_KT*DIM_KT_c*stepsSize;	dataOut.KT_size = KTSize;   dataOut.KT.resize(dataOut.KT_size);     std::memcpy(&(dataOut.KT[0]),KT0,KTSize);
                lcm_ptr.publish(ARM_TRAJ_CHANNEL,&dataOut);
            }
            else if (std::is_same<T, double>::value){
                drake::lcmt_trajectory_d dataOut;		dataOut.utime = tPlant;    	int stepsSize = TRAJ_RUNNER_TIME_STEPS*sizeof(double);   
                int uSize = ld_u*stepsSize;				dataOut.u_size = uSize;     dataOut.u.resize(dataOut.u_size);       std::memcpy(&(dataOut.u[0]),u0,uSize);
                int xSize = ld_x*stepsSize;				dataOut.x_size = xSize;     dataOut.x.resize(dataOut.x_size);       std::memcpy(&(dataOut.x[0]),x0,xSize);
                int KTSize = ld_KT*DIM_KT_c*stepsSize;	dataOut.KT_size = KTSize;   dataOut.KT.resize(dataOut.KT_size);     std::memcpy(&(dataOut.KT[0]),KT0,KTSize);
                lcm_ptr.publish(ARM_TRAJ_CHANNEL,&dataOut);
            }
            else{printf("MPC Loop Handler only defined for float and double\n");}
            // update the time val for later
            tPlant_prev = tPlant;
        }      
};

template <typename T, int MAX_ITERS, int KNOT_POINTS, int TRAJ_RUNNER_TIME_STEPS>
void runMPCHandler(LCM_MPCLoop_Handler<T,MAX_ITERS,KNOT_POINTS,TRAJ_RUNNER_TIME_STEPS> *handler){
    lcm::LCM lcm_ptr; if(!lcm_ptr.good()){printf("LCM Failed to init in MPC handler runner\n");}
    lcm::Subscription *sub = lcm_ptr.subscribe(ARM_STATUS, &LCM_MPCLoop_Handler<T,MAX_ITERS,KNOT_POINTS,TRAJ_RUNNER_TIME_STEPS>::handleStatus, handler);
    lcm::Subscription *sub2 = lcm_ptr.subscribe(ARM_GOAL_CHANNEL, &LCM_MPCLoop_Handler<T,MAX_ITERS,KNOT_POINTS,TRAJ_RUNNER_TIME_STEPS>::handleGoalEE, handler);
    lcm::Subscription *sub3 = lcm_ptr.subscribe(COST_PARAMS_CHANNEL, &LCM_MPCLoop_Handler<T,MAX_ITERS,KNOT_POINTS,TRAJ_RUNNER_TIME_STEPS>::handleCostParams, handler);
    sub->setQueueCapacity(1); sub2->setQueueCapacity(1); sub3->setQueueCapacity(1);
    while(0 == lcm_ptr.handle());
    // while(1){lcm_ptr.handle();usleep(1000);}
}

template <typename T, int MAX_ITERS, int KNOT_POINTS, int TRAJ_RUNNER_TIME_STEPS>
int robotFig8Tests(char hardware, int dynType = 0){
	// launch the simulator
    // printf("Make sure the simulator or kuka hardware is launched and conencted over LCM!!!\n");
	printf("What should the MPC control loop iteration limit be? (q to exit)?\n");
	int itersToDo = getInt<'q'>(1000, 1); if(itersToDo == -1){return 0;}
	// printf("What should the MPC control loop time limit be (in ms)? (q to exit)?\n");
	int timeLimit = 10000; //getInt<'q'>(1000, 1); if(timeLimit == -1){return 0;} //note in us
	// then create the handler
	LCM_MPCLoop_Handler<T,MAX_ITERS,KNOT_POINTS,TRAJ_RUNNER_TIME_STEPS> *handler = new LCM_MPCLoop_Handler<T,MAX_ITERS,KNOT_POINTS,TRAJ_RUNNER_TIME_STEPS>(hardware,dynType,itersToDo,timeLimit);
	// and launch the simulator on enter
	printf("Press enter to launch the MPC control loop\n");
    keyboardHold();
 	runMPCHandler<T,MAX_ITERS,KNOT_POINTS,TRAJ_RUNNER_TIME_STEPS>(handler);
 	delete handler;
    return 0;
}