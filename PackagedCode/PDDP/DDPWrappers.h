/*****************************************************************
 * DDP Algorithm Wrappers
 * (currently only supports iLQR)
 *****************************************************************/
#include "costs_old.h"
#include "bpHelpers.h"
#include "fpHelpers.h"
#include "nisInitHelpers.h"
#if COMPILE_WITH_GPU
	#include "nisInitHelpers_GPU.h"
#endif
#if COMPILE_WITH_FPGA
	#include "nisInitHelpers_FPGA.h"
#endif
#include "MPCHelpers.h" // MPC Wrappers and helpers (convergence wrappers below)

template <typename T, int KNOT_POINTS, int MAX_ITERS, bool IGNORE_MAX_ROX_EXIT>
void runiLQR_CPU(T *x0, T *u0, T *KT0, T *P0, T *p0, T *d0, T *xGoal, T *Jout, int *alphaOut, 
				 int forwardRolloutFlag, int clearVarsFlag, int ignoreFirstDefectFlag,
				 double *tTime, double *simTime, double *sweepTime, double *bpTime, double *nisTime, double *initTime,
				 T **xs, T *xp, T *xp2, T **us, T *up, T **qdds, T *qddp, T **Minvs, T *Minvp, T *P, T *p, T *Pp, T *pp, 
				 T *AB, T *H, T *g, T *KT, T *du, T **ds, T *d, T *dp, 
				 T *ApBK, T *Bdu, T *alphas, T **JTs, T *dJexp,  int *err,
				 int ld_x, int ld_u, int ld_P, int ld_p, int ld_AB, int ld_H, int ld_g, int ld_KT, int ld_du, int ld_d, int ld_A,
				 T *I, T *Tbody,
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
		    								    		  // params,xNom);
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
			#if EE_COST
				nextIterationSetupCPU_EE<T,KNOT_POINTS,false>(xs,xp,us,up,ds,dp,qdds,qddp,Minvs,Minvp,AB,H,g,P,p,Pp,pp,I,xGoal,threads,&alphaIndex,
														ld_x,ld_u,ld_d,ld_AB,ld_H,ld_g,ld_P,ld_p,dt,
														Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
														// params,xNom);
			#else
				nextIterationSetupCPU<T,KNOT_POINTS,false>(xs,xp,us,up,ds,dp,qdds,qddp,Minvs,Minvp,AB,H,g,P,p,Pp,pp,xGoal,threads,&alphaIndex,
													 ld_x,ld_u,ld_d,ld_AB,ld_H,ld_g,ld_P,ld_p,I,Tbody,dt,
													 Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
													 // params,xNom);
			#endif
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

#if COMPILE_WITH_GPU 
	template <typename T, int KNOT_POINTS, int MAX_ITERS, bool IGNORE_MAX_ROX_EXIT, bool USE_FUSED_DYN_GRAD = false>
	void runiLQR_GPU(T *x0, T *u0, T *KT0, T *P0, T *p0, T *d0, T *xGoal, T *Jout, int *alphaOut, 
			 		int forwardRolloutFlag, int clearVarsFlag, int ignoreFirstDefectFlag,
			 		double *tTime, double *simTime, double *sweepTime, double *bpTime, double *nisTime, double *initTime,
			 		T **xs, T *xp, T *xp2, T **us, T *up, T **qdds, T *qddp, T **Minvs, T *Minvp, T *P, T *p, T *Pp, T *pp, 
			 		T *AB, T *H, T *g, T *KT, T *du, T **ds, T *d, T *dp, 
			 		T *ApBK, T *Bdu, T *alphas, T **JTs, T *dJexp,  int *err,
			 		int ld_x, int ld_u, int ld_P, int ld_p, int ld_AB, int ld_H, int ld_g, int ld_KT, int ld_du, int ld_d, int ld_A,
			 		T *I, T *Tbody, T *v, T *a, T *f, T *Tfinal, T *cdq, T *cdqd, dim3 gridDimms, dim3 blockDimms,
			 		cudaStream_t *streams, T*d_x, T *d_qdd, T *d_Minv, T *d_AB, T *d_v, T *d_a, T *d_f, T *d_I, T *d_Tbody, T *d_Tfinal, T *d_cdq, T *d_cdqd,
			 		T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q1, T Q2, T R, T QF1, T QF2, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
						 // CostParams<T> *params, T *xNom = nullptr){

		// INITIALIZE THE ALGORITHM //
			struct timeval start, end, start2, end2; gettimeofday(&start,NULL); gettimeofday(&start2,NULL);
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
			    								    		  // params,xNom);
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
					nisTime[iter-1] = time_delta_ms(start2,end2);
					if (alphaIndex == -1){alphaIndex = 0;} break;
				}
				// if we have gotten here then prep for next pass
				if(USE_FUSED_DYN_GRAD){
					nextIterationSetupGPU_fused<T,KNOT_POINTS,1,1,false>(xs, xp, us, up, ds, dp, qdds, qddp, Minvs, Minvp, AB, H, g, P, p, Pp, pp, xGoal,
												       threads, &alphaIndex, ld_x, ld_u, ld_d, ld_AB, ld_H, ld_g, ld_P, ld_p, dt,
												   	   streams, d_x, d_qdd, d_cdq, d_cdqd, d_I, d_Tbody, cdq, cdqd, I, Tbody, gridDimms, blockDimms,
												       Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
				}
				else{
					#if EE_COST
						nextIterationSetupGPU_splitEE<T,KNOT_POINTS,1,1,false>(xs, xp, us, up, ds, dp, qdds, qddp, Minvs, Minvp, AB, H, g, P, p, Pp, pp, xGoal,
													         threads, &alphaIndex, ld_x, ld_u, ld_d, ld_AB, ld_H, ld_g, ld_P, ld_p, dt,
													         streams, d_cdq, d_cdqd, d_v, d_a, d_f, d_Tfinal, d_x, d_I, v, a, f,Tfinal, I, Tbody, cdq, cdqd,
													         gridDimms, blockDimms, Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
					#else
						nextIterationSetupGPU_split<T,KNOT_POINTS,1,1,false>(xs, xp, us, up, ds, dp, qdds, qddp, Minvs, Minvp, AB, H, g, P, p, Pp, pp, xGoal,
													       threads, &alphaIndex, ld_x, ld_u, ld_d, ld_AB, ld_H, ld_g, ld_P, ld_p, dt,
													       streams, d_cdq, d_cdqd, d_v, d_a, d_f, d_Tfinal, d_x, d_I, v, a, f,Tfinal, I, Tbody, cdq, cdqd,
													       gridDimms, blockDimms, Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
					#endif
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
#endif

#if COMPILE_WITH_FPGA
	template <typename T, int KNOT_POINTS, int MAX_ITERS, bool IGNORE_MAX_ROX_EXIT, bool USE_FUSED_DYN_GRAD = false>
	void runiLQR_FPGA(T *x0, T *u0, T *KT0, T *P0, T *p0, T *d0, T *xGoal, T *Jout, int *alphaOut, 
			 		 int forwardRolloutFlag, int clearVarsFlag, int ignoreFirstDefectFlag,
			 		 double *tTime, double *simTime, double *sweepTime, double *bpTime, double *nisTime, double *initTime,
			 		 T **xs, T *xp, T *xp2, T **us, T *up, T **qdds, T *qddp, T **Minvs, T *Minvp, T *P, T *p, T *Pp, T *pp, 
			 		 T *AB, T *H, T *g, T *KT, T *du, T **ds, T *d, T *dp, 
			 		 T *ApBK, T *Bdu, T *alphas, T **JTs, T *dJexp,  int *err,
			 		 int ld_x, int ld_u, int ld_P, int ld_p, int ld_AB, int ld_H, int ld_g, int ld_KT, int ld_du, int ld_d, int ld_A,
			 		 T *I, T *Tbody, T *v, T *a, T *f, T *Tfinal, T *cdq, T *cdqd, 
			 		 FPGADataIn_v1<KNOT_POINTS,NUM_POS> *dataIn1, FPGADataIn_v2<KNOT_POINTS,NUM_POS> *dataIn2, FPGADataOut<KNOT_POINTS,NUM_POS> *dataOut,
			 		 unsigned int fpgaIn1, unsigned int fpgaIn2, unsigned int fpgaOut,
			 		 T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q1, T Q2, T R, T QF1, T QF2, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
						 // CostParams<T> *params, T *xNom = nullptr){

		// INITIALIZE THE ALGORITHM //
			struct timeval start, end, start2, end2; gettimeofday(&start,NULL); gettimeofday(&start2,NULL);
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
			    								    		  // params,xNom);
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
					nisTime[iter-1] = time_delta_ms(start2,end2);
					if (alphaIndex == -1){alphaIndex = 0;} break;
				}
				// if we have gotten here then prep for next pass
				if(USE_FUSED_DYN_GRAD){
					nextIterationSetupFPGA_fused<T,KNOT_POINTS,1,1,false>(xs, xp, us, up, ds, dp, qdds, qddp, Minvs, Minvp, AB, H, g, P, p, Pp, pp, xGoal,
												       threads, &alphaIndex, ld_x, ld_u, ld_d, ld_AB, ld_H, ld_g, ld_P, ld_p, dt,
												   	   I, Tbody, cdq, cdqd, dataIn2, dataOut, fpgaIn2, fpgaOut,
												       Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
				}
				else{
					#if EE_COST
						nextIterationSetupFPGA_splitEE<T,KNOT_POINTS,1,1,false>(xs, xp, us, up, ds, dp, qdds, qddp, Minvs, Minvp, AB, H, g, P, p, Pp, pp, xGoal,
													         threads, &alphaIndex, ld_x, ld_u, ld_d, ld_AB, ld_H, ld_g, ld_P, ld_p, dt,
													         v, a, f, Tfinal, I, Tbody, cdq, cdqd, dataIn1, dataOut, fpgaIn1, fpgaOut,
													         Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
					#else
						nextIterationSetupFPGA_split<T,KNOT_POINTS,1,1,false>(xs, xp, us, up, ds, dp, qdds, qddp, Minvs, Minvp, AB, H, g, P, p, Pp, pp, xGoal,
													         threads, &alphaIndex, ld_x, ld_u, ld_d, ld_AB, ld_H, ld_g, ld_P, ld_p, dt,
													         v, a, f, Tfinal, I, Tbody, cdq, cdqd, dataIn1, dataOut, fpgaIn1, fpgaOut,
													         Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q1,Q2,R,QF1,QF2,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);
					#endif
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
#endif