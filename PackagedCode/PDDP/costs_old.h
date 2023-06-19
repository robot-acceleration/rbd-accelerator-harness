/*****************************************************************
 * Kuka Arm Cost Funcs
 *
 * TBD NEED TO ADD DOC HERE
 *****************************************************************/

// joint level cost func returns single val
template <typename T, int KNOT_POINTS>
T costFunc(T *xk, T *uk, T *xgk, int k, T Q1, T Q2, T R, T QF1, T QF2){
	T cost = 0.0;
	if (k == KNOT_POINTS - 1){
		#pragma unroll
    	for (int i=0; i<STATE_SIZE; i++){T delta = xk[i]-xgk[i]; cost += (T) (i < NUM_POS ? QF1 : QF2)*delta*delta;}
    }
    else{
    	#pragma unroll
        for (int i=0; i<STATE_SIZE; i++){T delta = xk[i]-xgk[i]; cost += (T) (i < NUM_POS ? Q1 : Q2)*delta*delta;}
    	#pragma unroll
        for (int i=0; i<CONTROL_SIZE; i++){cost += (T) R*uk[i]*uk[i];}
	}
	return static_cast<T>(0.5)*cost; // multiply by 1/2 all at once to save cycles
}

// joint level cost grad
template <typename T, int KNOT_POINTS>
void costGrad(T *Hk, T *gk, T *xk, T *uk, T *xgk, int k, int ld_H, T Q1, T Q2, T R, T QF1, T QF2, T *xNom = nullptr, T *JT = nullptr, int tid = -1){
	if (k == KNOT_POINTS - 1){
		#pragma unroll
      	for (int i=0; i<STATE_SIZE; i++){
      		#pragma unroll
         	for (int j=0; j<STATE_SIZE; j++){
            	Hk[i*ld_H + j] = (i != j) ? static_cast<T>(0) : (i < NUM_POS ? QF1 : QF2);
         	}  
      	}
      	#pragma unroll
      	for (int i=0; i<STATE_SIZE; i++){gk[i] = (i < NUM_POS ? QF1 : QF2)*(xk[i]-xgk[i]);}
      	#pragma unroll
      	for (int i=0; i<CONTROL_SIZE; i++){gk[i+STATE_SIZE] = 0;}
   	}
   	else{
      	#pragma unroll
      	for (int i=0; i<STATE_SIZE+CONTROL_SIZE; i++){
      		#pragma unroll
         	for (int j=0; j<STATE_SIZE+CONTROL_SIZE; j++){
            	Hk[i*ld_H + j] = (i != j) ? static_cast<T>(0) : (i < NUM_POS ? Q1 : (i < STATE_SIZE ? Q2 : R));
         	}  
      	}
      	#pragma unroll
      	for (int i=0; i<STATE_SIZE; i++){gk[i] = (i < NUM_POS ? Q1 : Q2)*(xk[i]-xgk[i]);}
      	#pragma unroll
      	for (int i=0; i<CONTROL_SIZE; i++){gk[i+STATE_SIZE] = R*uk[i];}
   	}
   	if (JT != nullptr){JT[tid] += costFunc<T,KNOT_POINTS>(xk,uk,xgk,k,Q1,Q2,R,QF1,QF2);}
}

// else need to consider multiple scenarios for end effector costs
template <typename T, int KNOT_POINTS>
T eeCost(T *s_eePos, T *d_eeGoal, int k, T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2){
	T cost = 0;
 	for (int i = 0; i < 6; i ++){
    	T delta = s_eePos[i] - d_eeGoal[i]; bool flag = k >= KNOT_POINTS-1;
    	cost += static_cast<T>(0.5)*(flag ? (i < 3 ? QF_EE1 : QF_EE2) : (i < 3 ? Q_EE1 : Q_EE2))*delta*delta;
 	}
 	return cost;
}

template <typename T, int KNOT_POINTS>
T deeCost(T *s_eePos, T *s_deePos, T *d_eeGoal, int k, int r, T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2){
	T val = 0;	T deePos; bool flag = k >= KNOT_POINTS-1;
 	#pragma unroll
 	for (int i = 0; i < 6; i++){
 		T delta = s_eePos[i]-d_eeGoal[i]; deePos = s_deePos[r*6+i];
		val += (flag ? (i < 3 ? QF_EE1 : QF_EE2) : (i < 3 ? Q_EE1 : Q_EE2))*delta*deePos;
 	}
 	return val;
}

template <typename T, int KNOT_POINTS>
T nominalStateCost(T *s_x, int ind, int k, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
	T Qq = (k == KNOT_POINTS-1 ? QF_xEE : Q_xEE); T Qqd = (k == KNOT_POINTS-1 ? QF_xdEE : Q_xdEE); T deltaq, deltaqd;
	if (xNom == nullptr){deltaq = s_x[ind];	deltaqd = s_x[ind+NUM_POS];}
	else{deltaq = s_x[ind] - xNom[ind];	deltaqd = s_x[ind + NUM_POS] - xNom[ind+NUM_POS];}
	return static_cast<T>(0.5)*(Qq*deltaq*deltaq + Qqd*deltaqd*deltaqd);
}

template <typename T, int KNOT_POINTS, int dLevel>
T dNominalStateCost(T *s_x, int ind, int k, T Q_xEE, T QF_xEE, T Q_xdEE, T QF_xdEE, T *xNom = nullptr){
	T Q = (ind < NUM_POS) ? (k == KNOT_POINTS-1 ? QF_xEE : Q_xEE) : (k == KNOT_POINTS-1 ? QF_xdEE : Q_xdEE);
	if (dLevel == 1){T x = s_x[ind]; T delta = (xNom == nullptr) ? x : x - xNom[ind]; return Q*delta;}
	else if (dLevel == 2){return Q;}
	else{printf("Derivative for nominal state cost not defined past dLevel = 2\n"); return 0;}
}

// eeCost Func returns single val
template <typename T, int KNOT_POINTS>
T costFunc(T *s_eePos, T *d_eeGoal, T *s_x, T *s_u, int k, T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr){
	T cost = 0;
	#pragma unroll
    for (int ind = 0; ind < NUM_POS; ind ++){
      	if (ind == 0){cost += eeCost<T,KNOT_POINTS>(s_eePos,d_eeGoal,k,Q_EE1,Q_EE2,QF_EE1,QF_EE2);} // compute in one thread incase smooth abs (for EEcost)
      	if (k < KNOT_POINTS-1){cost += static_cast<T>(0.5)*R_EE*s_u[ind]*s_u[ind];} // add on input cost
      	cost += nominalStateCost<T,KNOT_POINTS>(s_x,ind,k,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom); // add on the nominal state target cost
   	}
   	return cost;
}

// eeCost Grad
template <typename T, int KNOT_POINTS>
void costGrad(T *Hk, T*gk, T *s_eePos, T *s_deePos, T *d_eeGoal, T *s_x, T *s_u, int k, int ld_H, 
			  T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr, T *d_JT = nullptr, int tid = -1){
	// then to get the gradient and Hessian we need to compute the following for the state block (and also standard control block)
	// J = \sum_i Q_i*pow(hand_delta_i,2) + other stuff
	// dJ/dx = g = \sum_i Q_i*hand_delta_i*dh_i/dx + other stuff
	int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
	int start, delta; singleLoopVals(&start,&delta);
	#pragma unroll
	for (int r = start; r < DIM_g_r; r += delta){
	  	T val = static_cast<T>(0);
  		if (r < NUM_POS){val += deeCost<T,KNOT_POINTS>(s_eePos,s_deePos,d_eeGoal,k,r,Q_EE1,Q_EE2,QF_EE1,QF_EE2);}
		if (r < STATE_SIZE){val += dNominalStateCost<T,KNOT_POINTS,1>(s_x,r,k,Q_xEE,QF_xEE,Q_xdEE,QF_xdEE,xNom);} // nominal state target cost
		else{val += (k == KNOT_POINTS - 1 ? static_cast<T>(0) : R_EE)*s_u[r-STATE_SIZE];} // control cost
	  	gk[r] = val;
	}
	// d2J/dx2 = H \approx dh_i/dx'*dh_i/dx + other stuff
	#pragma unroll
	for (int c = starty; c < DIM_H_c; c += dy){
	  	T *H = &Hk[c*ld_H];
	  	#pragma unroll
	  	for (int r = startx; r<DIM_H_r; r += dx){
	     	T val = static_cast<T>(0);
    		if (r < NUM_POS && c < NUM_POS){
        		#pragma unroll
	           	for (int j = 0; j < 6; j++){
	           		T factor = (k == KNOT_POINTS - 1 ? (j < 3 ? QF_EE1 : QF_EE2) : (j < 3 ? Q_EE1 : Q_EE2));
	           		val += s_deePos[r*6+j]*s_deePos[c*6+j]*factor;
	           	}
           	}
		    if (r == c){
				if (r < STATE_SIZE){val += dNominalStateCost<T,KNOT_POINTS,2>(s_x,r,k,Q_xEE,QF_xEE,Q_xdEE,QF_xdEE,xNom);} // nominal state target cost
	        	else {val += (k== KNOT_POINTS - 1) ? static_cast<T>(0) : R_EE;} // control cost
	     	}
	     	H[r] = val;
	  	}
	}
	//if cost asked for compute it
	if (d_JT != nullptr){d_JT[tid] += costFunc<T,KNOT_POINTS>(s_eePos,d_eeGoal,s_x,s_u,k,Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom);}
}

template <typename T, int KNOT_POINTS>
void costGradientHessianThreaded(threadDesc_t desc, T *x, T *u, T *g, T *H, T *xg, int ld_x, int ld_u, int ld_H, int ld_g,
								 T Q_EE1, T Q_EE2, T QF_EE1, T QF_EE2, T R_EE, T Q1, T Q2, T R, T QF1, T QF2, T Q_xdEE, T QF_xdEE, T Q_xEE, T QF_xEE, T *xNom = nullptr, T *JT = nullptr){
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
			costGrad<T,KNOT_POINTS>(Hk,gk,s_eePos,s_deePos,xg,xk,uk,kInd,ld_H,Q_EE1,Q_EE2,QF_EE1,QF_EE2,R_EE,Q_xdEE,QF_xdEE,Q_xEE,QF_xEE,xNom,JT,desc.tid);
		#else // simple
			costGrad<T,KNOT_POINTS>(Hk,gk,xk,uk,xg,kInd,ld_H,Q1,Q2,R,QF1,QF2,xNom,JT,desc.tid);
    	#endif
	}
}