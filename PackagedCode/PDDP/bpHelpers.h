/*****************************************************************
 * DDP Backward Pass Helper Functions
 * (currently only supports iLQR - UDP in future release)
 *
 *  backwardPassCPU
 *    backPassThreaded
 *      linearXfrm
 *    backprop
 *    computeKTdu_dim1 OR ((invHuu_dim4 OR invHuu) AND computeKTdu)
 *    computeCTG
 *    computeFSVars
 *    computeExpRed
 *****************************************************************/

// load in the Pp matricies and compute the linear transform
template <typename T>
void linearXfrm(T *s_P, T *s_p, T *s_dx, T *d_x, T *d_xp, int ks, int ld_x, int ld_P){
    int start, delta; singleLoopVals(&start,&delta);
    // compute s_p += s_P*(x-xp)
    loadDeltaV<T,DIM_x_r>(s_dx, ld_x*(ks+1) + d_x, ld_x*(ks+1) + d_xp);
    matVMult<T,DIM_p_r,DIM_x_r,1>(s_p,s_P,DIM_P_r,s_dx);
}

// BACKPROP CTG store in s_H and s_g uses s_AB, s_AB2, s_P, s_p, b_H, b_g, b_AB, b_d, rho
template <typename T, int KNOT_POINTS, int N_BLOCKS_F>
void backprop(T *s_H, T *s_g, T *s_AB, T *s_AB2, T *s_P, T *s_p, \
              T *b_d, T rho, int iter, int ld_H, int ld_AB, int ld_P){ // 3rd row optional arguments needed on the GPU but not on the CPU
    // only double loops here so lets get the start and deltas
    int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
    // Propagate cost-to-go function through linearized dynamics for the Hessian and gradient
    // H = [A B]'*P*[A B] + H;      // g = [A B]'*[p + Pd] + g;
    // using the Tassa style regularization we end up with
    // H = [A B]'*(P + rho*diag(in xx block of comp ? 0 : 1))*[A B] + H;      // g = [A B]'*[p + (P + diag(in x block of comp ? 0 : 1))d] + g;
    // First we need to compute AB2 = AB'*(P + rho*diag(in u block));
    #pragma unroll
    for (int ky = starty; ky < DIM_ABT_c; ky += dy){
        #pragma unroll
        for (int kx = startx; kx < DIM_ABT_r; kx += dx){ // multiply column ky of P by row kx of AB' == column of AB place in (kx,ky) -> ky*DIM_ABT_r+kx of AB2
            T val = 0;
            #pragma unroll
            for (int j=0; j < DIM_P_c; j++){
                // note P = P + diag(rho) if in P*B
                val += s_AB[kx*DIM_AB_r + j] * (s_P[ky*DIM_P_r + j] + ((STATE_REG && kx >= DIM_x_r && ky == j) ? rho : static_cast<T>(0))); 
            }
            s_AB2[ky*DIM_ABT_r + kx] = val;
        }
    }
    // And we need to compute p += (P (+ diag(rho) if in P*B))*d if more than 1 shooting interval and on defect boundary
    if (M_BLOCKS_F > 1 && onDefectBoundary<KNOT_POINTS,N_BLOCKS_F>(iter)){
        #pragma unroll
        for (int ky = starty; ky < DIM_p_c; ky += dy){
            #pragma unroll
            for (int kx = startx; kx < DIM_p_r; kx += dx){ // dim_p_c == 1 so just limits to one set of threads
                T val = 0;
                #pragma unroll
                for (int j=0; j < DIM_p_r; j++){
                    val += b_d[j] * (s_P[kx + j*DIM_P_r] + ((STATE_REG && kx >= DIM_x_r && kx == j) ? rho : static_cast<T>(0))); // multiply a row of P by d
                }
                s_p[kx] += val;
            }
        }
    }
    // We can then compute and save to shared memory H += AB2*AB, g += AB'*p
    matMult<T,DIM_H_r,DIM_H_c,DIM_AB_r,1>(s_H,ld_H,s_AB2,DIM_ABT_r,s_AB,DIM_AB_r); // += s_H
    matMult<T,DIM_g_r,DIM_g_c,DIM_p_r,1>(s_g,1,s_p,1,s_AB,DIM_AB_r); // tricking it to use AB' // += s_g
}

template <typename T>
int invHuu(T *s_H, T *s_Huu, T rho, T *s_temp = nullptr){
    // First we need to invert Huu we can do this using the adjugate formula
    // so first load into Huu for manipulations as [Huu | I] and regularize if needed
    if (!STATE_REG){loadAndRegToShared<T,DIM_Huu_r,DIM_Huu_c>(s_Huu,&s_H[OFFSET_HUU],DIM_H_r,rho);}
    else{loadMatToShared<T,DIM_Huu_r,DIM_Huu_c>(s_Huu,&s_H[OFFSET_HUU],DIM_H_r);}
    loadIdentity<T,DIM_Huu_r,DIM_Huu_c>(&s_Huu[DIM_Huu_c*DIM_Huu_r],DIM_Huu_r);
    // then invert it and check for error
    return invertMatrix<T,NUM_POS>(s_Huu,s_temp);
}

template <typename T>
void computeKTdu(T *s_K, T *s_du, T *s_H, T *s_g, T *s_Huu, int ld_KT, \
                 T *b_KT = nullptr, T *b_du = nullptr){
    // Then we can compute K = invHuu*Hux -- not sure why we need to do backwards and invert but that seems to be the only way right now
    matMult<T,DIM_K_c,DIM_K_r,DIM_Huu_r,0,1>(s_K,DIM_K_r,s_Huu,DIM_Huu_r,&s_H[OFFSET_HUX_GU],DIM_H_r);
    // We can then compute du = invHuu*gu
    matVMult<T,DIM_du_r,DIM_Huu_r>(s_du,s_Huu,DIM_Huu_r,&s_g[OFFSET_HUX_GU]);
    // #ifdef __CUDA_ARCH__
        // make sure to save to both shared (for rest of backpass) and gloabl (for forwardpass) memory
        saveMatFromSharedT<T,DIM_KT_r,DIM_KT_c>(b_KT,s_K,ld_KT);
        saveMatFromShared<T,DIM_du_r,DIM_du_c>(b_du,s_du,1);
    // #endif
}

// COMPUTE CTG store in b_Pprev, b_pprev, s_P, s_p, compute from S_H, s_g, s_K, s_du, s_AB2 
template <typename T>
void computeCTG(T *s_P, T *s_p, T *s_H, T *s_g, T *s_K, T *s_du, T *s_AB2, int iter, int ld_P){
    // we need to compute: pprev = gx + K'*Huu*du - Hxu*du - K'*gu || Pprev = Hxx + K'*Huu*K - Hxu*K  - K'*Hux;
    // first we need to compute K'*Huu - Hxu -- note s_AB2 is now unused and can be reused so we save there
    // so multiply column ky of Huu by row kx of K' = column kx of K and subtract (kx,ky) of Hxu and store in (kx,ky) of s_AB2
    int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
        #pragma unroll
        for (int ky = starty; ky < DIM_KT_c; ky += dy){
        #pragma unroll
        for (int kx = startx; kx < DIM_KT_r; kx += dx){
            T val = STATE_REG ? dotProd<T,DIM_K_r>(&s_K[kx*DIM_K_r],1,&s_H[OFFSET_HUU + ky * DIM_H_r],1) : static_cast<T>(0);
            s_AB2[kx + ky * DIM_KT_r] = val - s_H[OFFSET_HXU + kx + DIM_H_r * ky];
        }
    }
    // So now we can compute Pprev = Hxx + s_AB2*K - K'*Hux \approx Hxx - Hxu*K
    // multiply c_ky K * (r_kx s_AB2 - r_kx Hxu) - c_kx of K by c_ky of Hux subtract that from (kx,ky) of Hxx and place in (kx,ky) of Pnm1
    #pragma unroll
    for (int ky = starty; ky < DIM_P_c; ky += dy){
        #pragma unroll
        for (int kx = startx; kx < DIM_P_r; kx += dx){
            T val = 0;
            #pragma unroll
            for (int j=0; j < DIM_K_r; j++){
                val += s_AB2[kx + DIM_KT_r * j] * s_K[ky * DIM_K_r + j] - (STATE_REG ? s_K[kx * DIM_K_r + j] * s_H[OFFSET_HUX_GU + ky * DIM_H_r + j] : static_cast<T>(0));
            }
            s_P[kx+ky*ld_P] = s_H[kx+ky*DIM_H_r] + val; // else s_P is b_Pprev its all global on CPU
        }
    }
    // So now we can compute pprev = gx + s_AB2*du - K'*gu \approx gx - Hxu*du
    // so we can proceeed like above: c_ky du * (r_kx s_AB2 - r_kx Hxu) - c_kx K * c_ky gu
    #pragma unroll
    for (int ky = starty; ky < DIM_p_c; ky += dy){
        #pragma unroll
        for (int kx = startx; kx < DIM_p_r; kx += dx){ // note DIM_p_c == 1
            T val = 0;
            #pragma unroll
            for (int j=0; j < DIM_du_r; j++){
                val += s_du[j] * s_AB2[kx + DIM_KT_r * j] - (STATE_REG ? s_K[kx * DIM_K_r + j] * s_g[OFFSET_HUX_GU + j] : static_cast<T>(0));
            }
            s_p[kx] = s_g[kx] + val;
        }
    }
}

// COMPUTE vars for Forward Sweep store in b_ApBK, b_Bdu, compute from s_AB, s_K, s_du
template <typename T>
void computeFSVars(T *b_ApBK, T *b_Bdu, T *s_AB, T *s_K, T *s_du, int ld_A){
    // ApBK (A - B*K) and Bdu (-B*du)
    // matMult<T,DIM_A_r,DIM_A_c,DIM_K_r>(b_ApBK,ld_A,&s_AB[OFFSET_B],DIM_AB_r,s_K,DIM_K_r,-1.0,s_AB,DIM_AB_r);
    // matVMult<T,DIM_d_r,DIM_du_r>(b_Bdu,&s_AB[OFFSET_B],DIM_AB_r,s_du);
    int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
    #pragma unroll
    for (int ky = starty; ky < DIM_A_c; ky += dy){
        #pragma unroll
        for (int kx = startx; kx < DIM_A_r; kx += dx){
            T val = 0;
            #pragma unroll
            for (int j=0; j<DIM_u_r; j++){
                // multiply row kx of B by column ky of K store in (kx,ky) of XM
                val += s_AB[OFFSET_B + kx + DIM_AB_r*j]*s_K[ky*DIM_K_r + j];
            }
            b_ApBK[kx + ld_A*ky] = s_AB[kx + DIM_AB_r*ky] - val; // dont forget to add (kx,ky) of A
        }
    }
    #pragma unroll
    for (int ky = starty; ky < DIM_d_c; ky += dy){
        #pragma unroll
        for (int kx = startx; kx < DIM_d_r; kx += dx){
            T val = 0;
            #pragma unroll
            for (int j=0; j<DIM_du_r; j++){
                // multiply row kx of B by column ky of du store in (kx,ky) of d
                val += s_AB[OFFSET_B + kx + DIM_AB_r*j]*s_du[j];
            }
            b_Bdu[kx] = val;
        }
    }
}

// COMPUTE expected cost reduction store in s_dJ, compute from s_H, s_g, and s_du
template <typename T>
void computeExpRed(T *s_dJ, T *s_H, T *s_g, T *s_du){
    // dJexp[2*i] = SUM du'*gu -- note both are vectors so dot product
    // dJexp[2*i+1] = SUM du'*Huu*du so first compute Huu*du so multiply column ky of du by row kx of Huu and then du'*val (dot)
    #pragma unroll
    for (int ind = 0; ind < DIM_du_r; ind++){
        s_dJ[0] += s_du[ind]*s_g[OFFSET_HUX_GU+ind];
        s_dJ[1] += s_du[ind]*dotProd<T,DIM_du_r>(&s_H[OFFSET_HUU+ind],DIM_H_r,s_du,1);
    }
}


template <typename T, int KNOT_POINTS, int N_BLOCKS_B, int N_BLOCKS_F>
void backwardPassThreaded(threadDesc_t desc, T *AB, T *P, T *p, T *Pp, T *pp, T *H, T *g, T *KT, T *du, T *d, T *ApBK, T *Bdu, T *x, T *xp, T *dJexp,\
                      int *err, int ld_AB, int ld_P, int ld_p, int ld_H, int ld_g, int ld_KT, int ld_du, int ld_A, int ld_d, int ld_x, T rho){
    T *b_AB, *b_P, *b_p, *b_H, *b_g, *b_KT, *b_du, *b_d, *b_Pprev, *b_pprev, *b_ApBK, *b_Bdu;
    T s_AB2[DIM_AB_r*DIM_AB_c];     T s_K[DIM_K_r*DIM_K_c];             T s_du[DIM_du_r*DIM_du_c];
    T s_dx[STATE_SIZE];             T s_Huu[2*DIM_Huu_r*DIM_Huu_c];     T s_temp[DIM_Huu_r + DIM_Huu_c + 1];
    int i, ks, iterCount, LIN_XFRM_FLAG;
    // zero the expected cost reduction
    dJexp[2*desc.tid] = 0;  dJexp[2*desc.tid+1] = 0;
    for (unsigned int i2=0; i2<desc.reps; i2++){
        i = (desc.tid+i2*desc.dim);     LIN_XFRM_FLAG = 1;    ks = (N_BLOCKS_B*(i+1)-1);
        b_Pprev = DIM_P_c*ld_P*(ks-1) + P;      b_pprev = ld_p*(ks-1) + p;
        b_H = DIM_H_c*ld_H*ks + H;              b_g = ld_g*ks + g;
        // be careful that if you are the final block you need to simply copy your Hxx cost -> P and gx -> p back one timestep
        if (ks == KNOT_POINTS - 1){
          copyMat<T,DIM_P_r,DIM_P_c>(b_Pprev, b_H, ld_P, ld_H);     copyMat<T,DIM_p_r,DIM_p_c>(b_pprev, b_g, ld_p, ld_g);
          // then update pointers
          b_P = b_Pprev;        b_p = b_pprev;      b_Pprev -= DIM_P_c*ld_P;    b_pprev -= ld_p;        ks--;
          b_H -= DIM_H_c*ld_H;  b_g -= ld_g;        LIN_XFRM_FLAG = 0;          iterCount = N_BLOCKS_B - 2;
        }
        // else read first from pp to ensure no weird asynchronous stuff (hard to compare) -- and apply linxfrm if asked
        else{iterCount = N_BLOCKS_B - 1;    b_P = DIM_P_c*ld_P*ks + (FORCE_PARALLEL ? Pp : P);  b_p = ld_p*ks + (FORCE_PARALLEL ? pp : p);}
        // in either case load the rest of the vars
        b_AB = DIM_AB_c*ld_AB*ks + AB;      b_KT = DIM_KT_c*ld_KT*ks + KT;      b_du = ld_du*ks + du;
        b_d = ld_d*ks + d;                  b_Bdu = ld_d*ks + Bdu;              b_ApBK = DIM_A_c*ld_A*ks + ApBK;
        // compute linear transform if needed
        if (LIN_XFRM_FLAG){linearXfrm<T>(b_P,b_p,s_dx,x,xp,ks,ld_x,ld_P);}
        // then loop back by block
        for (int iter = iterCount; iter >= 0; iter--){
            // BACKPROP CTG store in s_H and s_g uses s_AB2, s_p, b_H, b_g, b_AB, b_P, b_p, rho
            backprop<T,KNOT_POINTS,N_BLOCKS_F>(b_H, b_g, b_AB, s_AB2, b_P, b_p, b_d, rho, iter, ld_H, ld_AB, ld_P);
            // COMPUTE KT and du
            // then we need to compute the inverse of Huu and compute KT and du 
            if (invHuu<T>(b_H,s_Huu,rho,s_temp)){err[desc.tid] = 1; return;} // error so return else continue
            computeKTdu<T>(s_K,s_du,b_H,b_g,&s_Huu[DIM_Huu_r*DIM_Huu_c],ld_KT,b_KT,b_du);
            // COMPUTE CTG
            if (iter != 0 || i != 0){computeCTG<T>(b_Pprev,b_pprev,b_H,b_g,s_K,s_du,s_AB2,iter,ld_P);}
            // COMPUTE vars for Forward Sweep (ApBK and Bdu)
            if (M_BLOCKS_F > 1){computeFSVars<T>(b_ApBK,b_Bdu,b_AB,s_K,s_du,ld_A);}
            // COMPUTE expected cost reduction
            computeExpRed<T>(&dJexp[2*desc.tid],b_H,b_g,s_du);
            // Then update the pointers for the next pass
            // We propagate back Pkp1 for each ABk so we store such that we can immediately do the next pass of math so
            // Store each Pkp1 in each Pk and just leaving Pn as zeros (as the H which is computed at the next pass)
            b_P = b_Pprev;              b_p = b_pprev;              b_AB -= DIM_AB_c*ld_AB;
            b_H -= DIM_H_c*ld_H;        b_g -= ld_g;                b_KT -= DIM_KT_c*ld_KT;
            b_du -= ld_du;              b_d -= ld_d;                b_Bdu -= ld_d;
            b_ApBK -= DIM_A_c*ld_A;     b_Pprev -= DIM_P_c*ld_P;    b_pprev -= ld_p;
        }
        // note successs
        err[desc.tid] = 0;
    }
}

// full backward pass returns 0 on success and 1 on maxRho error
template <typename T, int KNOT_POINTS, int N_BLOCKS_B, int N_BLOCKS_F, bool IGNORE_MAX_ROX_EXIT>
int backwardPassCPU(T *AB, T *P, T *p, T *Pp, T *pp, T *H, T *g, T *KT, T *du, T *d, T *dp,
                    T *ApBK, T *Bdu, T *x, T *xp, T *dJexp, int *err, T *rho, T *drho, 
                    std::thread *threads, int ld_AB, int ld_P, int ld_p, int ld_H, int ld_g, 
                    int ld_KT, int ld_du, int ld_A, int ld_d, int ld_x){
    while(1){
        int fail = 0;
        // compute the back pass threaded
        threadDesc_t desc;    desc.dim = BP_THREADS;
        for (unsigned int thread_i = 0; thread_i < BP_THREADS; thread_i++){
            desc.tid = thread_i;   desc.reps = compute_reps(thread_i,BP_THREADS,M_BLOCKS_B);
            threads[thread_i] = std::thread(&backwardPassThreaded<T,KNOT_POINTS,N_BLOCKS_B,N_BLOCKS_F>, desc, std::ref(AB), std::ref(P), std::ref(p), std::ref(Pp), std::ref(pp), 
                                                                  std::ref(H), std::ref(g), std::ref(KT), std::ref(du), std::ref(d), std::ref(ApBK), std::ref(Bdu), 
                                                                  std::ref(x), std::ref(xp), std::ref(dJexp), std::ref(err), ld_AB, ld_P, ld_p, ld_H, 
                                                                  ld_g, ld_KT, ld_du, ld_A, ld_d, ld_x, *rho);
            if(FORCE_CORE_SWITCHES){setCPUForThread(threads, thread_i);}
        }
        // while this runs save d -> dp if M_BLOCKS_F > 1
        if (M_BLOCKS_F > 1){
            threads[BP_THREADS] = std::thread(memcpy, std::ref(dp), std::ref(d), ld_d*KNOT_POINTS*sizeof(T));
            if(FORCE_CORE_SWITCHES){setCPUForThread(threads, BP_THREADS);}
        }
        for (unsigned int thread_i = 0; thread_i < BP_THREADS; thread_i++){threads[thread_i].join(); fail |= err[thread_i];}
        if (M_BLOCKS_F > 1){threads[BP_THREADS].join();}
        // if an error then reset and increase rho
        if (fail){
            *drho = std::max((*drho)*static_cast<T>(RHO_FACTOR),static_cast<T>(RHO_FACTOR));
            *rho = std::min((*rho)*(*drho), static_cast<T>(RHO_MAX));
            for(int i = 0; i < BP_THREADS; i++){err[i] = 0;}
            if (*rho == static_cast<T>(RHO_MAX) && !IGNORE_MAX_ROX_EXIT){return 1;}
            else { // try to do the factorization again with a larger rho
                if (DEBUG_SWITCH){printf("[!]Inversion Failed Increasing Rho\n");}
                // need to reset the d_P, d_p
                threads[0] = std::thread(memcpy, std::ref(P), std::ref(Pp), ld_P*DIM_P_c*KNOT_POINTS*sizeof(T));
                if(FORCE_CORE_SWITCHES){setCPUForThread(threads, 0);}
                threads[1] = std::thread(memcpy, std::ref(p), std::ref(pp), ld_p*KNOT_POINTS*sizeof(T));
                if(FORCE_CORE_SWITCHES){setCPUForThread(threads, 1);}
                threads[0].join();
                threads[1].join();
                continue;
            }
        }
        // was a success so break
        else{break;}
    }
    return 0;
}