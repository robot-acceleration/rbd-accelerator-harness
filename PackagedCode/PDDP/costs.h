/*****************************************************************
 * Kuka Arm Cost Functions and Types
 *****************************************************************/

// default cost multipliers
template <typename T>
struct CostParams{
	T Q_q; T Q_qd; T QF_q; T QF_qd; T R;
	T Q_xyz; T Q_rpy; T QF_xyz; T QF_rpy;
};

template <typename T>
void loadParams(CostParams<T> *params, T Qq, T Qqd, T QFq, T QFqd, T R, T Qx = 0, T Qr = 0, T QFx = 0, T QFr = 0){
	params->Q_q = static_cast<T>(Qq);
	params->Q_qd = static_cast<T>(Qqd);
	params->QF_q = static_cast<T>(QFq);
	params->QF_qd = static_cast<T>(QFqd);
	params->R = static_cast<T>(R);
	params->Q_xyz = static_cast<T>(Qx);
	params->Q_rpy = static_cast<T>(Qr);
	params->QF_xyz = static_cast<T>(QFx);
	params->QF_rpy = static_cast<T>(QFr);
} 

// joint level costs are simple
#if !EE_COST
	// joint level cost func returns single val
	template <typename T, int KNOT_POINTS>
	T costFunc(T *xk, T *uk, T *xgk, int k, CostParams<T> *params){
		T cost = 0.0;
		if (k == KNOT_POINTS - 1){
			#pragma unroll
	    	for (int i=0; i<STATE_SIZE; i++){T delta = xk[i]-xgk[i]; cost += (T) (i < NUM_POS ? params->QF_q : params->QF_qd)*delta*delta;}
	    }
	    else{
	    	#pragma unroll
	        for (int i=0; i<STATE_SIZE; i++){T delta = xk[i]-xgk[i]; cost += (T) (i < NUM_POS ? params->Q_q : params->Q_qd)*delta*delta;}
	    	#pragma unroll
	        for (int i=0; i<CONTROL_SIZE; i++){cost += (T) params->R*uk[i]*uk[i];}
		}
		return static_cast<T>(0.5)*cost; // multiply by 1/2 all at once to save cycles
	}

	// joint level cost grad
	template <typename T, int KNOT_POINTS>
	void costGrad(T *Hk, T *gk, T *xk, T *uk, T *xgk, int k, int ld_H, CostParams<T> *params, T *JT = nullptr, int tid = -1){
		if (k == KNOT_POINTS - 1){
			#pragma unroll
	      	for (int i=0; i<STATE_SIZE; i++){
	      		#pragma unroll
	         	for (int j=0; j<STATE_SIZE; j++){
	            	Hk[i*ld_H + j] = (i != j) ? static_cast<T>(0) : (i < NUM_POS ? params->QF_q : params->QF_qd);
	         	}  
	      	}
	      	#pragma unroll
	      	for (int i=0; i<STATE_SIZE; i++){gk[i] = (i < NUM_POS ? params->QF_q : params->QF_qd)*(xk[i]-xgk[i]);}
	      	#pragma unroll
	      	for (int i=0; i<CONTROL_SIZE; i++){gk[i+STATE_SIZE] = 0;}
	   	}
	   	else{
	      	#pragma unroll
	      	for (int i=0; i<STATE_SIZE+CONTROL_SIZE; i++){
	      		#pragma unroll
	         	for (int j=0; j<STATE_SIZE+CONTROL_SIZE; j++){
	            	Hk[i*ld_H + j] = (i != j) ? static_cast<T>(0) : (i < NUM_POS ? params->Q_q : (i < STATE_SIZE ? params->Q_qd : params->R));
	         	}  
	      	}
	      	#pragma unroll
	      	for (int i=0; i<STATE_SIZE; i++){gk[i] = (i < NUM_POS ? params->Q_q : params->Q_qd)*(xk[i]-xgk[i]);}
	      	#pragma unroll
	      	for (int i=0; i<CONTROL_SIZE; i++){gk[i+STATE_SIZE] = params->R*uk[i];}
	   	}
	   	if (JT != nullptr){JT[tid] += costFunc<T,KNOT_POINTS>(xk,uk,xgk,k,params);}
	}

// else need to consider multiple scenarios for end effector costs
#else
	template <typename T>
	T eeCost(T *s_eePos, T *d_eeGoal, int k, T Qx, T Qr){
		T cost = 0;
	 	for (int i = 0; i < 6; i ++){
	    	T delta = s_eePos[i] - d_eeGoal[i];
	    	cost += static_cast<T>(0.5)*(i < 3 ? Qx : Qr)*delta*delta;
	 	}
	 	return cost;
	}

	template <typename T>
	T deeCost(T *s_eePos, T *s_deePos, T *d_eeGoal, int k, int r, T Qx, T Qr){
		T val = 0;	T deePos;
	 	#pragma unroll
	 	for (int i = 0; i < 6; i++){
	 		T delta = s_eePos[i]-d_eeGoal[i];		deePos = s_deePos[r*6+i];
    		val += (i < 3 ? Qx : Qr)*delta*deePos;
	 	}
	 	return val;
	}

	// eeCost Func returns single val
	template <typename T, int KNOT_POINTS>
	T costFunc(T *s_eePos, T *d_eeGoal, T *s_x, T *s_u, int k, CostParams<T> *params, T *xNom = nullptr){
		// extract the Qs we need
		T Qq, Qqd, Qx, Qr, delta; bool flag = true;
		if(k == KNOT_POINTS-1){Qq = params->QF_q; Qqd = params->QF_qd; Qx = params->QF_xyz; Qr = params->QF_rpy; flag = false;} 
		else{Qqd = params->Q_q; Qqd = params->Q_qd; Qx = params->Q_xyz; Qr = params->Q_rpy;}
		// compute the EE cost
		T cost = eeCost<T>(s_eePos,d_eeGoal,k,Qx,Qr);
		// add on the nominal state cost
		if(xNom != nullptr){
			T val = static_cast<T>(0);
			#pragma unroll
		    for (int ind = 0; ind < STATE_SIZE; ind ++){delta = s_x[ind] - xNom[ind]; val += (ind < NUM_POS ? Qq : Qqd)*delta*delta;}
      		cost += static_cast<T>(0.5)*delta;
      	}
      	else{
			T val = static_cast<T>(0);
			#pragma unroll
		    for (int ind = 0; ind < STATE_SIZE; ind ++){val += (ind < NUM_POS ? Qq : Qqd)*s_x[ind]*s_x[ind];}
      		cost += static_cast<T>(0.5)*delta;
      	}
		// add on input cost
		if (flag){
			#pragma unroll
		    for (int ind = 0; ind < NUM_POS; ind ++){cost += static_cast<T>(0.5)*params->R*s_u[ind]*s_u[ind];}
	   	}
	   	return cost;
	}

	// eeCost Grad
	template <typename T, int KNOT_POINTS>
	void costGrad(T *Hk, T*gk, T *s_eePos, T *s_deePos, T *d_eeGoal, T *s_x, T *s_u, int k, int ld_H, CostParams<T> *params, T *xNom = nullptr, T *d_JT = nullptr, int tid = -1){
		// extract the Qs we need
		T Qq, Qqd, Qx, Qr; bool flag = true; 
		if(k == KNOT_POINTS-1){Qq = params->QF_q; Qqd = params->QF_qd; Qx = params->QF_xyz; Qr = params->QF_rpy; flag = false;} 
		else{Qqd = params->Q_q; Qqd = params->Q_qd; Qx = params->Q_xyz; Qr = params->Q_rpy;}
		// then to get the gradient and Hessian we need to compute the following for the state block (and also standard control block)
		// J = \sum_i Q_i*pow(hand_delta_i,2) + other stuff
		// dJ/dx = g = \sum_i Q_i*hand_delta_i*dh_i/dx + other stuff
		#pragma unroll
		for (int r = 0; r < DIM_g_r; r++){
		  	T val = static_cast<T>(0);
	  		if (r < NUM_POS){val += deeCost<T>(s_eePos,s_deePos,d_eeGoal,k,r,Qx,Qr);}
			if (r < NUM_POS){val += (xNom == nullptr) ? Qq*s_x[r] : Qq*(s_x[r] - xNom[r]);} // nominal state target cost
			else if (r < STATE_SIZE){val += (xNom == nullptr) ? Qqd*s_x[r] : Qqd*(s_x[r] - xNom[r]);}
			else{val += flag ? params->R*s_u[r-STATE_SIZE] : static_cast<T>(0);} // control cost
		  	gk[r] = val;
		}
		// d2J/dx2 = H \approx dh_i/dx'*dh_i/dx + other stuff
		#pragma unroll
		for (int c = 0; c < DIM_H_c; c++){
		  	T *H = &Hk[c*ld_H];
		  	#pragma unroll
		  	for (int r = 0; r<DIM_H_r; r++){
		     	T val = static_cast<T>(0);
        		if (r < NUM_POS && c < NUM_POS){
	        		#pragma unroll
		           	for (int j = 0; j < 6; j++){val += s_deePos[r*6+j]*s_deePos[c*6+j]*(j < 3 ? Qx : Qr);}
	           	}
			    if (r == c){
					if (r < NUM_POS){val += Qq;} // nominal state target cost
					else if (r < STATE_SIZE){val += Qqd;}
		        	else {val += flag ? params->R : static_cast<T>(0);} // control cost
		     	}
		     	H[r] = val;
		  	}
		}
		//if cost asked for compute it
		if (d_JT != nullptr){d_JT[tid] += costFunc<T,KNOT_POINTS>(s_eePos,d_eeGoal,s_x,s_u,k,params,xNom);}
	}
	// template <typename T, int dLevel>
	// T dNominalStateCost(T *xk, int ind, int k, T Qq, T Qqd,T *xNom = nullptr){
	// 	T Q = (ind < NUM_POS) ? Qq : Qqd;
	// 	if (dLevel == 1){return (xNom == nullptr) ? Q*xk[ind] : Q*(xk[ind] - xNom[ind]);}
	// 	else if (dLevel == 2){return Q;}
	// 	else{printf("Derivative for nominal state cost not defined past dLevel = 2\n"); return 0;}
	// }
#endif

template <typename T>
void costGradientHessianThreaded(threadDesc_t desc, T *x, T *u, T *g, T *H, T *xg, int ld_x, int ld_u, int ld_H, int ld_g, CostParams<T> *params, T *xNom = nullptr, T *JT = nullptr){
    // if JT passed in then first zero the cost
    if (JT != nullptr){JT[desc.tid] = 0.0;}
	#if EE_COST // need lots of temp mem space for the xfrm mats
		T s_eePos[6]; T s_deePos[6*NUM_POS]; T s_tempMem[34*NUM_POS]; T s_dtempMem[49*NUM_POS];
	#endif
   	// for each rep on this thread
   	for (unsigned int rep=0; rep<desc.reps; rep++){int kInd = (desc.tid+rep*desc.dim);
      	T *xk = &x[kInd*ld_x]; T *uk = &u[kInd*ld_u]; T *Hk = &H[kInd*ld_H*DIM_H_c]; T *gk = &g[kInd*ld_g];
		#if EE_COST
			// compute end effector pos/vel and then cost grad
			computedEEPos4x4_scratch<T>(s_eePos,xk,s_tempMem,s_deePos,s_dtempMem);
			// if(kInd == 17){printf("eePos and deePos\n"); printMat<T,1,6>(s_eePos,1); printMat<T,6,7>(s_deePos,6);}
			costGrad<T,NUM_TIME_STEPS>(Hk,gk,s_eePos,s_deePos,xg,xk,uk,kInd,ld_H,params,xNom,JT,desc.tid);
			// if(kInd == 17){printf("Leads to g,H\n"); printMat<T,1,DIM_g_r>(gk,1); printMat<T,DIM_H_r,DIM_H_c>(Hk,DIM_H_r);}
		#else // simple
			costGrad<T,NUM_TIME_STEPS>(Hk,gk,xk,uk,xg,kInd,ld_H,params,JT,desc.tid);
    	#endif
	}
}