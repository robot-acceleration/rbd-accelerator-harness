/****************************************************************
 * CUDA Rigid Body DYNamics
 *
 * Based on the Joint Space Inversion Algorithm
 * currently special cased for 7dof Kuka Arm
 ****************************************************************/
#define GRAVITY 9.81
/*** PLANT SPECIFIC RBDYN HELPERS ***/
#define EE_ON_LINK_X 0
#define EE_ON_LINK_Y 0
#ifndef EE_TYPE
    #define EE_TYPE 1 // by default the arm has a flange and no end effector
#endif
#if EE_TYPE == 0 // no ee
    #define EE_ON_LINK_Z 0
    #define INERTIA_MODIFIER 1
    #define WEIGHT_MODIFIER 0
#elif EE_TYPE == 1 // flange only (2.5 inches)
    #define EE_ON_LINK_Z 0.0635
    #define INERTIA_MODIFIER 3
    #define WEIGHT_MODIFIER 0.03
#elif EE_TYPE == 2 // flange + peg (6 inches)
    #define EE_ON_LINK_Z 0.1524
    #define INERTIA_MODIFIER 5
    #define WEIGHT_MODIFIER 0.5
#endif

template <typename T, bool T_A = 0>
T dotProd_Tmat(T *Tmat, T *vec, int r){
   T val = static_cast<T>(0);
   if(!T_A){
      if(r < 3){
         #pragma unroll
         for (int i = 0; i < 3; i++){val += Tmat[r + 6 * i]*vec[i];}
      }
      else{
         #pragma unroll
         for (int i = 0; i < 6; i++){val += Tmat[r + 6 * i]*vec[i];}   
      }
   }
   else{
      if(r >= 3){
         #pragma unroll
         for (int i = 3; i < 6; i++){val += Tmat[r * 6 + i]*vec[i];}
      }
      else{
         #pragma unroll
         for (int i = 0; i < 6; i++){val += Tmat[r * 6 + i]*vec[i];}   
      }
   }
   return val;
}

// basic matrix vector multiply o (+)= T*v
template <typename T, bool PEQFLAG = 0, bool T_A = 0>
void matVMult_Tmat(T *out, T *Tmat, T *vec){
   // Sparsity pattern is = [data1   0    
   //                        data2   data1]
   #pragma unroll
   for (int r = 0; r < 6; r ++){
      T val = dotProd_Tmat<T,T_A>(Tmat,vec,r);
      if (PEQFLAG){out[r] += val;}
      else{out[r] = val;}
   }
}

//-------------------------------------------------------------------------------
// Helper Function to Build 6x6 Spatial Inertia Tensor
//-------------------------------------------------------------------------------
// I3x3 = [  Ixx  -Ixy  -Ixz  ]
//        [ -Ixy   Iyy  -Iyz  ]
//        [ -Ixz  -Iyz   Izz  ]
//
// I6x6 = [  I3x3   |   mcx   ]
//        [  mcxT   |   m1    ]
//
// 6x6 tensor, but only 10 independent elements
//
template <typename T, bool DRAKE_MATCH = 0>
void buildI6x6(T *currI, T Ixx, T Ixy, T Ixz, T Iyy, T Iyz, T Izz, T mass, T comx, T comy, T comz){
   // Copy elements from the 3x3 Inertia Tensor
   currI[rcJ_IndCpp(1,1,6)] =  Ixx;
   currI[rcJ_IndCpp(1,2,6)] = -Ixy;
   currI[rcJ_IndCpp(1,3,6)] = -Ixz;
   currI[rcJ_IndCpp(2,1,6)] = -Ixy;
   currI[rcJ_IndCpp(2,2,6)] =  Iyy;
   currI[rcJ_IndCpp(2,3,6)] = -Iyz;
   currI[rcJ_IndCpp(3,1,6)] = -Ixz;
   currI[rcJ_IndCpp(3,2,6)] = -Iyz;
   currI[rcJ_IndCpp(3,3,6)] =  Izz;
   // define the mx sections
   T mcz = mass*comz;
   currI[rcJ_IndCpp(2,4,6)] =  mcz;
   currI[rcJ_IndCpp(4,2,6)] =  mcz;
   currI[rcJ_IndCpp(1,5,6)] = -mcz;
   currI[rcJ_IndCpp(5,1,6)] = -mcz;
   T mcy = mass*comy;
   currI[rcJ_IndCpp(1,6,6)] =  mcy;
   currI[rcJ_IndCpp(6,1,6)] =  mcy;
   currI[rcJ_IndCpp(3,4,6)] = -mcy;
   currI[rcJ_IndCpp(4,3,6)] = -mcy;
   T mcx = mass*comx;
   currI[rcJ_IndCpp(3,5,6)] =  mcx;
   currI[rcJ_IndCpp(5,3,6)] =  mcx;
   currI[rcJ_IndCpp(2,6,6)] = -mcx;
   currI[rcJ_IndCpp(6,2,6)] = -mcx;
   currI[rcJ_IndCpp(4,4,6)] = mass;
   currI[rcJ_IndCpp(5,5,6)] = mass;
   currI[rcJ_IndCpp(6,6,6)] = mass;
   // make sure to zero out what is left
   currI[rcJ_IndCpp(1,4,6)] = 0;
   currI[rcJ_IndCpp(4,1,6)] = 0;
   currI[rcJ_IndCpp(2,5,6)] = 0;
   currI[rcJ_IndCpp(5,2,6)] = 0;
   currI[rcJ_IndCpp(3,6,6)] = 0;
   currI[rcJ_IndCpp(6,3,6)] = 0;
   currI[rcJ_IndCpp(4,5,6)] = 0;
   currI[rcJ_IndCpp(5,4,6)] = 0;
   currI[rcJ_IndCpp(4,6,6)] = 0;
   currI[rcJ_IndCpp(6,4,6)] = 0;
   currI[rcJ_IndCpp(5,6,6)] = 0;
   currI[rcJ_IndCpp(6,5,6)] = 0;
   if (DRAKE_MATCH){
      // this is in drake but not robcogen (R*I3x3*R + m*C*C')
      // but in our case we have all 0s for rpy on joint COM so it reduces to I3x3 + m*C*C'
      currI[rcJ_IndCpp(1,1,6)] = Ixx;
      currI[rcJ_IndCpp(1,2,6)] = Ixy;
      currI[rcJ_IndCpp(1,3,6)] = Ixz;
      currI[rcJ_IndCpp(2,1,6)] = Ixy;
      currI[rcJ_IndCpp(2,2,6)] = Iyy;
      currI[rcJ_IndCpp(2,3,6)] = Iyz;
      currI[rcJ_IndCpp(3,1,6)] = Ixz;
      currI[rcJ_IndCpp(3,2,6)] = Iyz;
      currI[rcJ_IndCpp(3,3,6)] = Izz;
      // T cy = cos(y); T cp = cos(p); T cr = cos(r);
      // T sy = sin(y); T sp = sin(p); T sr = sin(r);
      // T temp[9]; T R[9] = {cy*cp, cy*sp*sr-sy*cr, cy*sp*cr+sy*sr,
      //                      sy*cp, sy*sp*sr+cy*cr, sy*sp*cr-cy*sr,
      //                        -sp, cp*sr,          cp*cr};
      // matMult<T,3,3,3>(temp,3,R,3,currI,6);
      // matMult<T,3,3,3,0,0,0,1>(currI,6,temp,3,R,3);
      T mcz2 = mcz*comz; T mcy2 = mcy*comy; T mcx2 = mcx*comx;
      currI[rcJ_IndCpp(1,2,6)] += mcz2;
      currI[rcJ_IndCpp(2,1,6)] += mcz2;
      currI[rcJ_IndCpp(1,3,6)] += mcy2;
      currI[rcJ_IndCpp(3,1,6)] += mcy2;
      currI[rcJ_IndCpp(2,3,6)] += mcx2;
      currI[rcJ_IndCpp(3,2,6)] += mcx2;
   }
}

//-------------------------------------------------------------------------------
// Initialize Spatial Inertia Tensors from Constants
//-------------------------------------------------------------------------------
template <typename T>
void initInertiaTensors(T *h_I){
   // Per-Robot Inertia Constants
   T ZERO = static_cast<T>(0);
   // -- Link 1 Mass, Position, Inertia
   T comx_l1 = static_cast<T>(0);
   T comy_l1 = static_cast<T>(-0.029999999329447746);
   T comz_l1 = static_cast<T>(0.11999999731779099);
   T m_l1 = static_cast<T>(5.760000228881836);
   T ix_l1 = static_cast<T>(0.12112800031900406);
   T iy_l1 = static_cast<T>(0.11624400317668915);
   T iyz_l1 = static_cast<T>(-0.020735999569296837);
   T iz_l1 = static_cast<T>(0.017483999952673912);
   buildI6x6<T>(&h_I[0*36], ix_l1, ZERO, ZERO, iy_l1, iyz_l1, iz_l1, m_l1, comx_l1, comy_l1, comz_l1);
   // -- Link 2 Mass, Position, Inertia
   T comx_l2 = static_cast<T>(3.000000142492354E-4);
   T comy_l2 = static_cast<T>(0.05900000035762787);
   T comz_l2 = static_cast<T>(0.041999999433755875);
   T m_l2 = static_cast<T>(6.349999904632568);
   T ix_l2 = static_cast<T>(0.06380599737167358);
   T ixy_l2 = static_cast<T>(1.1200000153621659E-4);
   T ixz_l2 = static_cast<T>(7.999999797903001E-5);
   T iy_l2 = static_cast<T>(0.0416020005941391);
   T iyz_l2 = static_cast<T>(0.015735000371932983);
   T iz_l2 = static_cast<T>(0.03310500085353851);
   buildI6x6<T>(&h_I[1*36], ix_l2, ixy_l2, ixz_l2, iy_l2, iyz_l2, iz_l2, m_l2, comx_l2, comy_l2, comz_l2);
   // -- Link 3 Mass, Position, Inertia
   T comy_l3 = static_cast<T>(0.029999999329447746);
   T comz_l3 = static_cast<T>(0.12999999523162842);
   T m_l3 = static_cast<T>(3.5);
   T ix_l3 = static_cast<T>(0.08730000257492065);
   T iy_l3 = static_cast<T>(0.08295000344514847);
   T iyz_l3 = static_cast<T>(0.013650000095367432);
   T iz_l3 = static_cast<T>(0.01075000036507845);
   buildI6x6<T>(&h_I[2*36], ix_l3, ZERO, ZERO, iy_l3, iyz_l3, iz_l3, m_l3, ZERO, comy_l3, comz_l3);
   // -- Link 4 Mass, Position, Inertia
   T comy_l4 = static_cast<T>(0.06700000166893005);
   T comz_l4 = static_cast<T>(0.03400000184774399);
   T m_l4 = static_cast<T>(3.5);
   T ix_l4 = static_cast<T>(0.036757998168468475);
   T iy_l4 = static_cast<T>(0.02044600062072277);
   T iyz_l4 = static_cast<T>(0.007973000407218933);
   T iz_l4 = static_cast<T>(0.021710999310016632);
   buildI6x6<T>(&h_I[3*36], ix_l4, ZERO, ZERO, iy_l4, iyz_l4, iz_l4, m_l4, ZERO, comy_l4, comz_l4);
   // -- Link 5 Mass, Position, Inertia
   T comx_l5 = static_cast<T>(9.999999747378752E-5);
   T comy_l5 = static_cast<T>(0.020999999716877937);
   T comz_l5 = static_cast<T>(0.07599999755620956);
   T m_l5 = static_cast<T>(3.5);
   T ix_l5 = static_cast<T>(0.03175999969244003);
   T ixy_l5 = static_cast<T>(7.000000096013537E-6);
   T ixz_l5 = static_cast<T>(2.700000004551839E-5);
   T iy_l5 = static_cast<T>(0.028915999457240105);
   T iyz_l5 = static_cast<T>(0.00558600015938282);
   T iz_l5 = static_cast<T>(0.0060339998453855515);
   buildI6x6<T>(&h_I[4*36], ix_l5, ixy_l5, ixz_l5, iy_l5, iyz_l5, iz_l5, m_l5, comx_l5, comy_l5, comz_l5);
   // -- Link 6 Mass, Position, Inertia
   T comy_l6 = static_cast<T>(6.000000284984708E-4);
   T comz_l6 = static_cast<T>(3.9999998989515007E-4);
   T m_l6 = static_cast<T>(1.7999999523162842);
   T ix_l6 = static_cast<T>(0.004900999832898378);
   T iy_l6 = static_cast<T>(0.004699999932199717);
   T iyz_l6 = static_cast<T>(0);
   T iz_l6 = static_cast<T>(0.0036009999457746744);
   buildI6x6<T>(&h_I[5*36], ix_l6, ZERO, ZERO, iy_l6, iyz_l6, iz_l6, m_l6, ZERO, comy_l6, comz_l6);
   // -- Link 7 Mass, Position, Inertia
   T comz_l7 = static_cast<T>(0.019999999552965164);
   T m_l7 = static_cast<T>(1.2000000476837158);
   T ix_l7 = static_cast<T>(0.00547999981790781);
   T iy_l7 = static_cast<T>(0.00547999981790781);
   T iz_l7 = static_cast<T>(0.004999999888241291);
   buildI6x6<T>(&h_I[6*36], ix_l7, ZERO, ZERO, iy_l7, ZERO, iz_l7, m_l7, ZERO, ZERO, comz_l7);
}

template <typename T>
void initMotionTransforms(T *h_T){
   #pragma unroll
   for (int ind = 0; ind < 36*NUM_POS; ind ++){h_T[ind] = static_cast<T>(0);}
   T tz_j2 = static_cast<T>(0.20250000059604645);
   T tz_j4 = static_cast<T>(0.21549999713897705);
   T tz_j6 = static_cast<T>(0.21549999713897705);
   T *t1X0 = &h_T[0*36];   T *t2X1 = &h_T[1*36];   T *t3X2 = &h_T[2*36];
   T *t4X3 = &h_T[3*36];   T *t5X4 = &h_T[4*36];   T *t6X5 = &h_T[5*36];   T *t7X6 = &h_T[6*36];
   t1X0[rcJ_IndCpp(3,3,6)] = 1.0;
   t1X0[rcJ_IndCpp(6,6,6)] = 1.0;
   t2X1[rcJ_IndCpp(3,2,6)] = 1.0;
   t2X1[rcJ_IndCpp(6,1,6)] = -tz_j2;
   t2X1[rcJ_IndCpp(6,5,6)] = 1.0;
   t3X2[rcJ_IndCpp(3,2,6)] = 1.0;
   t3X2[rcJ_IndCpp(6,5,6)] = 1.0;
   t4X3[rcJ_IndCpp(3,2,6)] = -1.0;
   t4X3[rcJ_IndCpp(6,1,6)] =  tz_j4;
   t4X3[rcJ_IndCpp(6,5,6)] = -1.0;
   t5X4[rcJ_IndCpp(3,2,6)] = 1.0;
   t5X4[rcJ_IndCpp(6,5,6)] = 1.0;
   t6X5[rcJ_IndCpp(3,2,6)] = -1.0;
   t6X5[rcJ_IndCpp(6,1,6)] =  tz_j6;
   t6X5[rcJ_IndCpp(6,5,6)] = -1.0;
   t7X6[rcJ_IndCpp(3,2,6)] = 1.0;
   t7X6[rcJ_IndCpp(6,5,6)] = 1.0;
}

//-------------------------------------------------------------------------------
// Function to Update Transforms with Per-Input Variables
//-------------------------------------------------------------------------------
//
// Xjoint
//  Xji   = jcalc(jstatic_cast<T>(i),qi)
//           rotation  translation
//  Xji   = [E      0][1         0]
//          [0      E][-rx       1] where "rx" is a cross product operator
// Xtree
//  Xt(i) = from robot topology
//
// Full Transform
//  tbXa  = Xjb Xt(b)
//
template <typename T>
void updateTransforms(T *s_T, T *d_T, T *s_q, T *s_sinq, T *s_cosq){
   // compute sin/cos in parallel as well as loading in Tbase
   int start, delta; singleLoopVals(&start,&delta);
   #pragma unroll
   for (int ind = start; ind < NUM_POS; ind += delta){s_sinq[ind] = sin(s_q[ind]); s_cosq[ind] = cos(s_q[ind]);}
   // make a copy because multiple threads share the same d_T
   #pragma unroll
   for (int ind = start; ind < 36*NUM_POS; ind += delta){s_T[ind] = d_T[ind];}
   // Per-Robot Translation Constants
   T tz_j1 = static_cast<T>(0.1574999988079071);
   T tz_j2 = static_cast<T>(0.20250000059604645);
   T ty_j3 = static_cast<T>(0.2045000046491623);
   T tz_j4 = static_cast<T>(0.21549999713897705);
   T ty_j5 = static_cast<T>(0.18449999392032623);
   T tz_j6 = static_cast<T>(0.21549999713897705);
   T ty_j7 = static_cast<T>(0.08100000023841858);
   // -- Link 1 <-- World 0
   s_T[krcJ_IndCpp(1,1,1,6)] = s_cosq[0];
   s_T[krcJ_IndCpp(1,1,2,6)] = s_sinq[0];
   s_T[krcJ_IndCpp(1,2,1,6)] = -s_sinq[0];
   s_T[krcJ_IndCpp(1,2,2,6)] = s_cosq[0];
   s_T[krcJ_IndCpp(1,4,1,6)] = -tz_j1 * s_sinq[0];
   s_T[krcJ_IndCpp(1,4,2,6)] =  tz_j1 * s_cosq[0];
   s_T[krcJ_IndCpp(1,4,4,6)] = s_cosq[0];
   s_T[krcJ_IndCpp(1,4,5,6)] = s_sinq[0];
   s_T[krcJ_IndCpp(1,5,1,6)] = -tz_j1 * s_cosq[0];
   s_T[krcJ_IndCpp(1,5,2,6)] = -tz_j1 * s_sinq[0];
   s_T[krcJ_IndCpp(1,5,4,6)] = -s_sinq[0];
   s_T[krcJ_IndCpp(1,5,5,6)] = s_cosq[0];
   // -- Link 2 <-- Link 1
   s_T[krcJ_IndCpp(2,1,1,6)] = -s_cosq[1];
   s_T[krcJ_IndCpp(2,1,3,6)] = s_sinq[1];
   s_T[krcJ_IndCpp(2,2,1,6)] = s_sinq[1];;
   s_T[krcJ_IndCpp(2,2,3,6)] = s_cosq[1];
   s_T[krcJ_IndCpp(2,4,2,6)] = -tz_j2 * s_cosq[1];
   s_T[krcJ_IndCpp(2,4,4,6)] = -s_cosq[1];
   s_T[krcJ_IndCpp(2,4,6,6)] = s_sinq[1];
   s_T[krcJ_IndCpp(2,5,2,6)] =  tz_j2 * s_sinq[1];
   s_T[krcJ_IndCpp(2,5,4,6)] = s_sinq[1];
   s_T[krcJ_IndCpp(2,5,6,6)] = s_cosq[1];
   // -- Link 3 <-- Link 2
   s_T[krcJ_IndCpp(3,1,1,6)] = -s_cosq[2];
   s_T[krcJ_IndCpp(3,1,3,6)] = s_sinq[2];
   s_T[krcJ_IndCpp(3,2,1,6)] = s_sinq[2];
   s_T[krcJ_IndCpp(3,2,3,6)] = s_cosq[2];
   s_T[krcJ_IndCpp(3,4,1,6)] =  ty_j3 * s_sinq[2];
   s_T[krcJ_IndCpp(3,4,3,6)] =  ty_j3 * s_cosq[2];
   s_T[krcJ_IndCpp(3,4,4,6)] = -s_cosq[2];
   s_T[krcJ_IndCpp(3,4,6,6)] = s_sinq[2];
   s_T[krcJ_IndCpp(3,5,1,6)] =  ty_j3 * s_cosq[2];
   s_T[krcJ_IndCpp(3,5,3,6)] = -ty_j3 * s_sinq[2];
   s_T[krcJ_IndCpp(3,5,4,6)] = s_sinq[2];
   s_T[krcJ_IndCpp(3,5,6,6)] = s_cosq[2];
   // -- Link 4 <-- Link 3
   s_T[krcJ_IndCpp(4,1,1,6)] = s_cosq[3];
   s_T[krcJ_IndCpp(4,1,3,6)] = s_sinq[3];
   s_T[krcJ_IndCpp(4,2,1,6)] = -s_sinq[3];
   s_T[krcJ_IndCpp(4,2,3,6)] = s_cosq[3];
   s_T[krcJ_IndCpp(4,4,2,6)] =  tz_j4 * s_cosq[3];
   s_T[krcJ_IndCpp(4,4,4,6)] = s_cosq[3];
   s_T[krcJ_IndCpp(4,4,6,6)] = s_sinq[3];
   s_T[krcJ_IndCpp(4,5,2,6)] = -tz_j4 * s_sinq[3];
   s_T[krcJ_IndCpp(4,5,4,6)] = -s_sinq[3];
   s_T[krcJ_IndCpp(4,5,6,6)] = s_cosq[3];
   // -- Link 5 <-- Link 4
   s_T[krcJ_IndCpp(5,1,1,6)] = -s_cosq[4];
   s_T[krcJ_IndCpp(5,1,3,6)] = s_sinq[4];
   s_T[krcJ_IndCpp(5,2,1,6)] = s_sinq[4];
   s_T[krcJ_IndCpp(5,2,3,6)] = s_cosq[4];
   s_T[krcJ_IndCpp(5,4,1,6)] =  ty_j5 * s_sinq[4];
   s_T[krcJ_IndCpp(5,4,3,6)] =  ty_j5 * s_cosq[4];
   s_T[krcJ_IndCpp(5,4,4,6)] = -s_cosq[4];
   s_T[krcJ_IndCpp(5,4,6,6)] = s_sinq[4];
   s_T[krcJ_IndCpp(5,5,1,6)] =  ty_j5 * s_cosq[4];
   s_T[krcJ_IndCpp(5,5,3,6)] = -ty_j5 * s_sinq[4];
   s_T[krcJ_IndCpp(5,5,4,6)] = s_sinq[4];
   s_T[krcJ_IndCpp(5,5,6,6)] = s_cosq[4];
   // -- Link 6 <-- Link 5
   s_T[krcJ_IndCpp(6,1,1,6)] = s_cosq[5];
   s_T[krcJ_IndCpp(6,1,3,6)] = s_sinq[5];
   s_T[krcJ_IndCpp(6,2,1,6)] = -s_sinq[5];
   s_T[krcJ_IndCpp(6,2,3,6)] = s_cosq[5];
   s_T[krcJ_IndCpp(6,4,2,6)] =  tz_j6 * s_cosq[5];
   s_T[krcJ_IndCpp(6,4,4,6)] = s_cosq[5];
   s_T[krcJ_IndCpp(6,4,6,6)] = s_sinq[5];
   s_T[krcJ_IndCpp(6,5,2,6)] = -tz_j6 * s_sinq[5];
   s_T[krcJ_IndCpp(6,5,4,6)] = -s_sinq[5];
   s_T[krcJ_IndCpp(6,5,6,6)] = s_cosq[5];
   // -- Link 7 <-- Link 6
   s_T[krcJ_IndCpp(7,1,1,6)] = -s_cosq[6];
   s_T[krcJ_IndCpp(7,1,3,6)] = s_sinq[6];
   s_T[krcJ_IndCpp(7,2,1,6)] = s_sinq[6];
   s_T[krcJ_IndCpp(7,2,3,6)] = s_cosq[6];
   s_T[krcJ_IndCpp(7,4,1,6)] =  ty_j7 * s_sinq[6];
   s_T[krcJ_IndCpp(7,4,3,6)] =  ty_j7 * s_cosq[6];
   s_T[krcJ_IndCpp(7,4,4,6)] = -s_cosq[6];
   s_T[krcJ_IndCpp(7,4,6,6)] = s_sinq[6];
   s_T[krcJ_IndCpp(7,5,1,6)] =  ty_j7 * s_cosq[6];
   s_T[krcJ_IndCpp(7,5,3,6)] = -ty_j7 * s_sinq[6];
   s_T[krcJ_IndCpp(7,5,4,6)] = s_sinq[6];
   s_T[krcJ_IndCpp(7,5,6,6)] = s_cosq[6];
}
template <typename T>
void buildTransforms(T *s_T, T *s_sinq, T *s_cosq){
   // Per-Robot Translation Constants
   T tz_j1 = static_cast<T>(0.1574999988079071);
   T tz_j2 = static_cast<T>(0.20250000059604645);
   T ty_j3 = static_cast<T>(0.2045000046491623);
   T tz_j4 = static_cast<T>(0.21549999713897705);
   T ty_j5 = static_cast<T>(0.18449999392032623);
   T tz_j6 = static_cast<T>(0.21549999713897705);
   T ty_j7 = static_cast<T>(0.08100000023841858);
   // -- Link 1 <-- World 0
   s_T[krcJ_IndCpp(1,1,1,6)] = s_cosq[0];
   s_T[krcJ_IndCpp(1,1,2,6)] = s_sinq[0];
   s_T[krcJ_IndCpp(1,1,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,1,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,1,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,1,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,2,1,6)] = -s_sinq[0];
   s_T[krcJ_IndCpp(1,2,2,6)] = s_cosq[0];
   s_T[krcJ_IndCpp(1,2,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,2,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,2,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,2,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,3,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,3,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,3,3,6)] = static_cast<T>(1.0);
   s_T[krcJ_IndCpp(1,3,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,3,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,3,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,4,1,6)] = -tz_j1 * s_sinq[0];
   s_T[krcJ_IndCpp(1,4,2,6)] =  tz_j1 * s_cosq[0];
   s_T[krcJ_IndCpp(1,4,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,4,4,6)] = s_cosq[0];
   s_T[krcJ_IndCpp(1,4,5,6)] = s_sinq[0];
   s_T[krcJ_IndCpp(1,4,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,5,1,6)] = -tz_j1 * s_cosq[0];
   s_T[krcJ_IndCpp(1,5,2,6)] = -tz_j1 * s_sinq[0];
   s_T[krcJ_IndCpp(1,5,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,5,4,6)] = -s_sinq[0];
   s_T[krcJ_IndCpp(1,5,5,6)] = s_cosq[0];
   s_T[krcJ_IndCpp(1,5,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,6,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,6,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,6,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,6,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,6,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(1,6,6,6)] = static_cast<T>(1.0);
   // -- Link 2 <-- Link 1
   s_T[krcJ_IndCpp(2,1,1,6)] = -s_cosq[1];
   s_T[krcJ_IndCpp(2,1,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,1,3,6)] = s_sinq[1];
   s_T[krcJ_IndCpp(2,1,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,1,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,1,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,2,1,6)] = s_sinq[1];;
   s_T[krcJ_IndCpp(2,2,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,2,3,6)] = s_cosq[1];
   s_T[krcJ_IndCpp(2,2,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,2,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,2,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,3,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,3,2,6)] = static_cast<T>(1.0);
   s_T[krcJ_IndCpp(2,3,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,3,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,3,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,3,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,4,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,4,2,6)] = -tz_j2 * s_cosq[1];
   s_T[krcJ_IndCpp(2,4,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,4,4,6)] = -s_cosq[1];
   s_T[krcJ_IndCpp(2,4,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,4,6,6)] = s_sinq[1];
   s_T[krcJ_IndCpp(2,5,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,5,2,6)] =  tz_j2 * s_sinq[1];
   s_T[krcJ_IndCpp(2,5,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,5,4,6)] = s_sinq[1];
   s_T[krcJ_IndCpp(2,5,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,5,6,6)] = s_cosq[1];
   s_T[krcJ_IndCpp(2,6,1,6)] = -tz_j2;
   s_T[krcJ_IndCpp(2,6,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,6,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,6,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(2,6,5,6)] = static_cast<T>(1.0);
   s_T[krcJ_IndCpp(2,6,6,6)] = static_cast<T>(0);
   // -- Link 3 <-- Link 2
   s_T[krcJ_IndCpp(3,1,1,6)] = -s_cosq[2];
   s_T[krcJ_IndCpp(3,1,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,1,3,6)] = s_sinq[2];
   s_T[krcJ_IndCpp(3,1,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,1,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,1,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,2,1,6)] = s_sinq[2];
   s_T[krcJ_IndCpp(3,2,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,2,3,6)] = s_cosq[2];
   s_T[krcJ_IndCpp(3,2,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,2,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,2,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,3,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,3,2,6)] = static_cast<T>(1.0);
   s_T[krcJ_IndCpp(3,3,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,3,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,3,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,3,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,4,1,6)] =  ty_j3 * s_sinq[2];
   s_T[krcJ_IndCpp(3,4,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,4,3,6)] =  ty_j3 * s_cosq[2];
   s_T[krcJ_IndCpp(3,4,4,6)] = -s_cosq[2];
   s_T[krcJ_IndCpp(3,4,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,4,6,6)] = s_sinq[2];
   s_T[krcJ_IndCpp(3,5,1,6)] =  ty_j3 * s_cosq[2];
   s_T[krcJ_IndCpp(3,5,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,5,3,6)] = -ty_j3 * s_sinq[2];
   s_T[krcJ_IndCpp(3,5,4,6)] = s_sinq[2];
   s_T[krcJ_IndCpp(3,5,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,5,6,6)] = s_cosq[2];
   s_T[krcJ_IndCpp(3,6,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,6,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,6,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,6,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(3,6,5,6)] = static_cast<T>(1.0);
   s_T[krcJ_IndCpp(3,6,6,6)] = static_cast<T>(0);
   // -- Link 4 <-- Link 3
   s_T[krcJ_IndCpp(4,1,1,6)] = s_cosq[3];
   s_T[krcJ_IndCpp(4,1,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,1,3,6)] = s_sinq[3];
   s_T[krcJ_IndCpp(4,1,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,1,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,1,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,2,1,6)] = -s_sinq[3];
   s_T[krcJ_IndCpp(4,2,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,2,3,6)] = s_cosq[3];
   s_T[krcJ_IndCpp(4,2,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,2,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,2,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,3,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,3,2,6)] = static_cast<T>(-1.0);
   s_T[krcJ_IndCpp(4,3,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,3,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,3,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,3,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,4,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,4,2,6)] =  tz_j4 * s_cosq[3];
   s_T[krcJ_IndCpp(4,4,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,4,4,6)] = s_cosq[3];
   s_T[krcJ_IndCpp(4,4,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,4,6,6)] = s_sinq[3];
   s_T[krcJ_IndCpp(4,5,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,5,2,6)] = -tz_j4 * s_sinq[3];
   s_T[krcJ_IndCpp(4,5,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,5,4,6)] = -s_sinq[3];
   s_T[krcJ_IndCpp(4,5,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,5,6,6)] = s_cosq[3];
   s_T[krcJ_IndCpp(4,6,1,6)] =  tz_j4;
   s_T[krcJ_IndCpp(4,6,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,6,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,6,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(4,6,5,6)] = static_cast<T>(-1.0);
   s_T[krcJ_IndCpp(4,6,6,6)] = static_cast<T>(0);
   // -- Link 5 <-- Link 4
   s_T[krcJ_IndCpp(5,1,1,6)] = -s_cosq[4];
   s_T[krcJ_IndCpp(5,1,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,1,3,6)] = s_sinq[4];
   s_T[krcJ_IndCpp(5,1,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,1,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,1,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,2,1,6)] = s_sinq[4];
   s_T[krcJ_IndCpp(5,2,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,2,3,6)] = s_cosq[4];
   s_T[krcJ_IndCpp(5,2,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,2,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,2,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,3,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,3,2,6)] = static_cast<T>(1.0);
   s_T[krcJ_IndCpp(5,3,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,3,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,3,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,3,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,4,1,6)] =  ty_j5 * s_sinq[4];
   s_T[krcJ_IndCpp(5,4,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,4,3,6)] =  ty_j5 * s_cosq[4];
   s_T[krcJ_IndCpp(5,4,4,6)] = -s_cosq[4];
   s_T[krcJ_IndCpp(5,4,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,4,6,6)] = s_sinq[4];
   s_T[krcJ_IndCpp(5,5,1,6)] =  ty_j5 * s_cosq[4];
   s_T[krcJ_IndCpp(5,5,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,5,3,6)] = -ty_j5 * s_sinq[4];
   s_T[krcJ_IndCpp(5,5,4,6)] = s_sinq[4];
   s_T[krcJ_IndCpp(5,5,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,5,6,6)] = s_cosq[4];
   s_T[krcJ_IndCpp(5,6,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,6,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,6,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,6,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(5,6,5,6)] = static_cast<T>(1.0);
   s_T[krcJ_IndCpp(5,6,6,6)] = static_cast<T>(0);
   // -- Link 6 <-- Link 5
   s_T[krcJ_IndCpp(6,1,1,6)] = s_cosq[5];
   s_T[krcJ_IndCpp(6,1,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,1,3,6)] = s_sinq[5];
   s_T[krcJ_IndCpp(6,1,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,1,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,1,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,2,1,6)] = -s_sinq[5];
   s_T[krcJ_IndCpp(6,2,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,2,3,6)] = s_cosq[5];
   s_T[krcJ_IndCpp(6,2,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,2,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,2,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,3,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,3,2,6)] = static_cast<T>(-1.0);
   s_T[krcJ_IndCpp(6,3,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,3,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,3,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,3,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,4,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,4,2,6)] =  tz_j6 * s_cosq[5];
   s_T[krcJ_IndCpp(6,4,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,4,4,6)] = s_cosq[5];
   s_T[krcJ_IndCpp(6,4,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,4,6,6)] = s_sinq[5];
   s_T[krcJ_IndCpp(6,5,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,5,2,6)] = -tz_j6 * s_sinq[5];
   s_T[krcJ_IndCpp(6,5,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,5,4,6)] = -s_sinq[5];
   s_T[krcJ_IndCpp(6,5,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,5,6,6)] = s_cosq[5];
   s_T[krcJ_IndCpp(6,6,1,6)] =  tz_j6;
   s_T[krcJ_IndCpp(6,6,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,6,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,6,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(6,6,5,6)] = static_cast<T>(-1.0);
   s_T[krcJ_IndCpp(6,6,6,6)] = static_cast<T>(0);
   // -- Link 7 <-- Link 6
   s_T[krcJ_IndCpp(7,1,1,6)] = -s_cosq[6];
   s_T[krcJ_IndCpp(7,1,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,1,3,6)] = s_sinq[6];
   s_T[krcJ_IndCpp(7,1,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,1,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,1,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,2,1,6)] = s_sinq[6];
   s_T[krcJ_IndCpp(7,2,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,2,3,6)] = s_cosq[6];
   s_T[krcJ_IndCpp(7,2,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,2,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,2,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,3,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,3,2,6)] = static_cast<T>(1.0);
   s_T[krcJ_IndCpp(7,3,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,3,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,3,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,3,6,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,4,1,6)] =  ty_j7 * s_sinq[6];
   s_T[krcJ_IndCpp(7,4,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,4,3,6)] =  ty_j7 * s_cosq[6];
   s_T[krcJ_IndCpp(7,4,4,6)] = -s_cosq[6];
   s_T[krcJ_IndCpp(7,4,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,4,6,6)] = s_sinq[6];
   s_T[krcJ_IndCpp(7,5,1,6)] =  ty_j7 * s_cosq[6];
   s_T[krcJ_IndCpp(7,5,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,5,3,6)] = -ty_j7 * s_sinq[6];
   s_T[krcJ_IndCpp(7,5,4,6)] = s_sinq[6];
   s_T[krcJ_IndCpp(7,5,5,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,5,6,6)] = s_cosq[6];
   s_T[krcJ_IndCpp(7,6,1,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,6,2,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,6,3,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,6,4,6)] = static_cast<T>(0);
   s_T[krcJ_IndCpp(7,6,5,6)] = static_cast<T>(1.0);
   s_T[krcJ_IndCpp(7,6,6,6)] = static_cast<T>(0);
}

//-------------------------------------------------------------------------------
// Helper Function to Init and Update 4x4 Transforms
//-------------------------------------------------------------------------------
template <typename T>
void initMotionTransforms4x4(T *s_T){
   #pragma unroll
   for (int i = 0; i < 16*NUM_POS; i++){s_T[i] = static_cast<T>(0);}
   s_T[10] = static_cast<T>(1.0);
   s_T[14] = static_cast<T>(0.1575);
   s_T[15] = static_cast<T>(1.0);
   s_T[24] = static_cast<T>(0.00000000000000012246467991473532071737640294584);
   s_T[25] = static_cast<T>(1.0);
   s_T[26] = static_cast<T>(-0.0000000000000003828568698926949434848128216851);
   s_T[30] = static_cast<T>(0.2025);
   s_T[31] = static_cast<T>(1.0);
   s_T[40] = static_cast<T>(0.00000000000000012246467991473532071737640294584);
   s_T[41] = static_cast<T>(1.0);
   s_T[42] = static_cast<T>(-0.0000000000000003828568698926949434848128216851);
   s_T[45] = static_cast<T>(0.2045);
   s_T[47] = static_cast<T>(1.0);
   s_T[57] = static_cast<T>(-1.0);
   s_T[58] = static_cast<T>(-0.0000000000000003828568698926949434848128216851);
   s_T[62] = static_cast<T>(0.2155);
   s_T[63] = static_cast<T>(1.0);
   s_T[72] = static_cast<T>(-0.000000000000000000000000000000046886444024566354179237414162174);
   s_T[73] = static_cast<T>(1.0);
   s_T[74] = static_cast<T>(0.0000000000000003828568698926949434848128216851);
   s_T[77] = static_cast<T>(0.1845);
   s_T[79] = static_cast<T>(1.0);
   s_T[89] = static_cast<T>(-1.0);
   s_T[90] = static_cast<T>(-0.0000000000000003828568698926949434848128216851);
   s_T[94] = static_cast<T>(0.2155);
   s_T[95] = static_cast<T>(1.0);
   s_T[104] = static_cast<T>(-0.000000000000000000000000000000046886444024566354179237414162174);
   s_T[105] = static_cast<T>(1.0);
   s_T[106] = static_cast<T>(0.0000000000000003828568698926949434848128216851);
   s_T[109] = static_cast<T>(0.081);
   s_T[111] = static_cast<T>(1.0);
}
template <typename T, int ld = 16>
void updateTransforms4x4(T *s_T4, T *d_Tb, T *s_q, T *s_sinq, T *s_cosq, T *s_Tb = nullptr){
   // compute sin/cos in parallel as well as loading in Tbase
   int start, delta; singleLoopVals(&start,&delta);
   int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
   #pragma unroll
   for (int ind = start; ind < NUM_POS; ind += delta){s_sinq[ind] = sin(s_q[ind]); s_cosq[ind] = cos(s_q[ind]);}
   // if on cpu s_T = d_T else need to copy into shared mem
   if(s_Tb != nullptr){
      #pragma unroll
      for (int ind = start; ind < 16*NUM_POS; ind += delta){s_Tb[ind] = d_Tb[ind];}
   }
   else{s_Tb = d_Tb;}
   s_Tb[0] = s_cosq[0];
   s_Tb[1] = s_sinq[0];
   s_Tb[4] = -s_sinq[0];
   s_Tb[5] = s_cosq[0];
   s_Tb[ld] = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_sinq[1] - s_cosq[1];
   s_Tb[ld+1] = static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[1] + static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[1];
   s_Tb[ld+2] = s_sinq[1];
   s_Tb[ld+4] = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_cosq[1] + s_sinq[1];
   s_Tb[ld+5] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_cosq[1] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[1];
   s_Tb[ld+6] = s_cosq[1];
   s_Tb[2*ld]   = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_sinq[2] - 1.0*s_cosq[2];
   s_Tb[2*ld+1] = static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[2] + static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[2];
   s_Tb[2*ld+2] = s_sinq[2];
   s_Tb[2*ld+4] = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_cosq[2] + s_sinq[2];
   s_Tb[2*ld+5] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_cosq[2] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[2];
   s_Tb[2*ld+6] = s_cosq[2];
   s_Tb[3*ld]   = s_cosq[3];
   s_Tb[3*ld+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinq[3];
   s_Tb[3*ld+2] = s_sinq[3];
   s_Tb[3*ld+4] = -s_sinq[3];
   s_Tb[3*ld+5] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[3];
   s_Tb[3*ld+6] = s_cosq[3];
   s_Tb[4*ld]   = -s_cosq[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[4];
   s_Tb[4*ld+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinq[4];
   s_Tb[4*ld+2] = s_sinq[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[4];
   s_Tb[4*ld+4] = s_sinq[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[4];
   s_Tb[4*ld+5] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[4];
   s_Tb[4*ld+6] = s_cosq[4] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[4];
   s_Tb[5*ld]   = s_cosq[5];
   s_Tb[5*ld+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinq[5];
   s_Tb[5*ld+2] = s_sinq[5];
   s_Tb[5*ld+4] = -s_sinq[5];
   s_Tb[5*ld+5] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[5];
   s_Tb[5*ld+6] = s_cosq[5];
   s_Tb[6*ld]   = -s_cosq[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[6];
   s_Tb[6*ld+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinq[6];
   s_Tb[6*ld+2] = s_sinq[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[6];
   s_Tb[6*ld+4] = s_sinq[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[6];
   s_Tb[6*ld+5] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[6];
   s_Tb[6*ld+6] = s_cosq[6] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[6];
   // do the recursion Tk = Tkmi * Tbk
   T *Tb = s_Tb; T *Ti = s_T4; T *Tim1 = s_T4;
   #pragma unroll
   for (int body = 0; body < NUM_POS; body++){
      if (body == 0){copyBlockMemShared<T,16>(Ti,Tb);}
      else{matMult<T,4,4,4,0,1>(Ti,4,Tim1,4,Tb,4);}
      Tim1 = Ti; Ti += 16; Tb += 16;
   }
}
template <typename T, int MAT_DIM = 16>
void buildTransforms4x4(T *s_Tb4, T *s_sinq, T *s_cosq){
   // simply load in the full 4x4 transforms with the sins and cos at once
   // this should be fast on the CPU
   s_Tb4[0]            = s_cosq[0];
   s_Tb4[1]            = s_sinq[0];
   s_Tb4[2]            = static_cast<T>(0);
   s_Tb4[3]            = static_cast<T>(0);
   s_Tb4[4]            = -s_sinq[0];
   s_Tb4[5]            = s_cosq[0];
   s_Tb4[6]            = static_cast<T>(0);
   s_Tb4[7]            = static_cast<T>(0);
   s_Tb4[8]            = static_cast<T>(0);
   s_Tb4[9]            = static_cast<T>(0);
   s_Tb4[10]           = static_cast<T>(1.0);
   s_Tb4[11]           = static_cast<T>(0);
   s_Tb4[12]           = static_cast<T>(0);
   s_Tb4[13]           = static_cast<T>(0);
   s_Tb4[14]           = static_cast<T>(0.1575);
   s_Tb4[15]           = static_cast<T>(1.0);
   s_Tb4[MAT_DIM]      = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_sinq[1] - s_cosq[1];
   s_Tb4[MAT_DIM+1]    = static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[1] + static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[1];
   s_Tb4[MAT_DIM+2]    = s_sinq[1];
   s_Tb4[MAT_DIM+3]    = static_cast<T>(0);
   s_Tb4[MAT_DIM+4]    = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_cosq[1] + s_sinq[1];
   s_Tb4[MAT_DIM+5]    = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_cosq[1] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[1];
   s_Tb4[MAT_DIM+6]    = s_cosq[1];
   s_Tb4[MAT_DIM+7]    = static_cast<T>(0);
   s_Tb4[MAT_DIM+8]    = static_cast<T>(0.00000000000000012246467991473532071737640294584);
   s_Tb4[MAT_DIM+9]    = static_cast<T>(1.0);
   s_Tb4[MAT_DIM+10]   = static_cast<T>(-0.0000000000000003828568698926949434848128216851);
   s_Tb4[MAT_DIM+11]   = static_cast<T>(0);
   s_Tb4[MAT_DIM+12]   = static_cast<T>(0);
   s_Tb4[MAT_DIM+13]   = static_cast<T>(0);
   s_Tb4[MAT_DIM+14]   = static_cast<T>(0.2025);
   s_Tb4[MAT_DIM+15]   = static_cast<T>(1.0);
   s_Tb4[2*MAT_DIM]    = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_sinq[2] - 1.0*s_cosq[2];
   s_Tb4[2*MAT_DIM+1]  = static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[2] + static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[2];
   s_Tb4[2*MAT_DIM+2]  = s_sinq[2];
   s_Tb4[2*MAT_DIM+3]  = static_cast<T>(0);
   s_Tb4[2*MAT_DIM+4]  = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_cosq[2] + s_sinq[2];
   s_Tb4[2*MAT_DIM+5]  = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_cosq[2] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[2];
   s_Tb4[2*MAT_DIM+6]  = s_cosq[2];
   s_Tb4[2*MAT_DIM+7]  = static_cast<T>(0);
   s_Tb4[2*MAT_DIM+8]  = static_cast<T>(0.00000000000000012246467991473532071737640294584);
   s_Tb4[2*MAT_DIM+9]  = static_cast<T>(1.0);
   s_Tb4[2*MAT_DIM+10] = static_cast<T>(-0.0000000000000003828568698926949434848128216851);
   s_Tb4[2*MAT_DIM+11] = static_cast<T>(0);
   s_Tb4[2*MAT_DIM+12] = static_cast<T>(0);
   s_Tb4[2*MAT_DIM+13] = static_cast<T>(0.2045);
   s_Tb4[2*MAT_DIM+14] = static_cast<T>(0);
   s_Tb4[2*MAT_DIM+15] = static_cast<T>(1.0);
   s_Tb4[3*MAT_DIM]    = s_cosq[3];
   s_Tb4[3*MAT_DIM+1]  = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinq[3];
   s_Tb4[3*MAT_DIM+2]  = s_sinq[3];
   s_Tb4[3*MAT_DIM+3]  = static_cast<T>(0);
   s_Tb4[3*MAT_DIM+4]  = -s_sinq[3];
   s_Tb4[3*MAT_DIM+5]  = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[3];
   s_Tb4[3*MAT_DIM+6]  = s_cosq[3];
   s_Tb4[3*MAT_DIM+7]  = static_cast<T>(0);
   s_Tb4[3*MAT_DIM+8]  = static_cast<T>(0);
   s_Tb4[3*MAT_DIM+9]  = static_cast<T>(-1.0);
   s_Tb4[3*MAT_DIM+10] = static_cast<T>(-0.0000000000000003828568698926949434848128216851);
   s_Tb4[3*MAT_DIM+11] = static_cast<T>(0);
   s_Tb4[3*MAT_DIM+12] = static_cast<T>(0);
   s_Tb4[3*MAT_DIM+13] = static_cast<T>(0);
   s_Tb4[3*MAT_DIM+14] = static_cast<T>(0.2155);
   s_Tb4[3*MAT_DIM+15] = static_cast<T>(1.0);
   s_Tb4[4*MAT_DIM]    = -s_cosq[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[4];
   s_Tb4[4*MAT_DIM+1]  = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinq[4];
   s_Tb4[4*MAT_DIM+2]  = s_sinq[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[4];
   s_Tb4[4*MAT_DIM+3]  = static_cast<T>(0);
   s_Tb4[4*MAT_DIM+4]  = s_sinq[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[4];
   s_Tb4[4*MAT_DIM+5]  = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[4];
   s_Tb4[4*MAT_DIM+6]  = s_cosq[4] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[4];
   s_Tb4[4*MAT_DIM+7]  = static_cast<T>(0);
   s_Tb4[4*MAT_DIM+8]  = static_cast<T>(-0.000000000000000000000000000000046886444024566354179237414162174);
   s_Tb4[4*MAT_DIM+9]  = static_cast<T>(1.0);
   s_Tb4[4*MAT_DIM+10] = static_cast<T>(0.0000000000000003828568698926949434848128216851);
   s_Tb4[4*MAT_DIM+11] = static_cast<T>(0);
   s_Tb4[4*MAT_DIM+12] = static_cast<T>(0);
   s_Tb4[4*MAT_DIM+13] = static_cast<T>(0.1845);
   s_Tb4[4*MAT_DIM+14] = static_cast<T>(0);
   s_Tb4[4*MAT_DIM+15] = static_cast<T>(1.0);
   s_Tb4[5*MAT_DIM]    = s_cosq[5];
   s_Tb4[5*MAT_DIM+1]  = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinq[5];
   s_Tb4[5*MAT_DIM+2]  = s_sinq[5];
   s_Tb4[5*MAT_DIM+3]  = static_cast<T>(0);
   s_Tb4[5*MAT_DIM+4]  = -s_sinq[5];
   s_Tb4[5*MAT_DIM+5]  = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[5];
   s_Tb4[5*MAT_DIM+6]  = s_cosq[5];
   s_Tb4[5*MAT_DIM+7]  = static_cast<T>(0);
   s_Tb4[5*MAT_DIM+8]  = static_cast<T>(0);
   s_Tb4[5*MAT_DIM+9]  = static_cast<T>(-1.0);
   s_Tb4[5*MAT_DIM+10] = static_cast<T>(-0.0000000000000003828568698926949434848128216851);
   s_Tb4[5*MAT_DIM+11] = static_cast<T>(0);
   s_Tb4[5*MAT_DIM+12] = static_cast<T>(0);
   s_Tb4[5*MAT_DIM+13] = static_cast<T>(0);
   s_Tb4[5*MAT_DIM+14] = static_cast<T>(0.2155);
   s_Tb4[5*MAT_DIM+15] = static_cast<T>(1.0);
   s_Tb4[6*MAT_DIM]    = -s_cosq[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[6];
   s_Tb4[6*MAT_DIM+1]  = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinq[6];
   s_Tb4[6*MAT_DIM+2]  = s_sinq[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[6];
   s_Tb4[6*MAT_DIM+3]  = static_cast<T>(0);
   s_Tb4[6*MAT_DIM+4]  = s_sinq[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[6];
   s_Tb4[6*MAT_DIM+5]  = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[6];
   s_Tb4[6*MAT_DIM+6]  = s_cosq[6] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[6];
   s_Tb4[6*MAT_DIM+7]  = static_cast<T>(0);
   s_Tb4[6*MAT_DIM+8]  = static_cast<T>(-0.000000000000000000000000000000046886444024566354179237414162174);
   s_Tb4[6*MAT_DIM+9]  = static_cast<T>(1.0);
   s_Tb4[6*MAT_DIM+10] = static_cast<T>(0.0000000000000003828568698926949434848128216851);
   s_Tb4[6*MAT_DIM+11] = static_cast<T>(0);
   s_Tb4[6*MAT_DIM+12] = static_cast<T>(0);
   s_Tb4[6*MAT_DIM+13] = static_cast<T>(0.081);
   s_Tb4[6*MAT_DIM+14] = static_cast<T>(0);
   s_Tb4[6*MAT_DIM+15] = static_cast<T>(1.0);
}
template <typename T, int MAT_DIM = 16>
void recurseTransforms4x4(T *s_T4, T *s_Tb4){
   // do the recursion Tk = Tkmi * Tbk
   T *Tb = s_Tb4; T *Ti = s_T4; T *Tim1 = s_T4;
   #pragma unroll
   for (int body = 0; body < NUM_POS; body++){
      if (body == 0){copyBlockMemShared<T,16>(Ti,Tb);}
      else{matMult<T,4,4,4,0,1>(Ti,4,Tim1,4,Tb,4);}
      Tim1 = Ti; Ti += MAT_DIM; Tb += MAT_DIM;
   }
}
template <typename T>
void loadAdjoint_xyz(T *dst, int ld, T x, T y, T z){
   dst[0] = static_cast<T>(0);   dst[ld] = z;                        dst[2*ld] = -y;
   dst[1] = -z;                  dst[ld + 1] = static_cast<T>(0);    dst[2*ld + 1] = x;
   dst[2] = y;                   dst[ld + 2] = -x;                   dst[2*ld + 2] = static_cast<T>(0);
}
template <typename T, int MAT_DIM = 9>
void initAdjoints4x4(T *s_adj){
   loadAdjoint_xyz<T>(s_adj,            3,static_cast<T>(0),static_cast<T>(0),static_cast<T>(0.1575));
   loadAdjoint_xyz<T>(&s_adj[MAT_DIM],  3,static_cast<T>(0),static_cast<T>(0),static_cast<T>(0.2025));
   loadAdjoint_xyz<T>(&s_adj[2*MAT_DIM],3,static_cast<T>(0),static_cast<T>(0.2045),static_cast<T>(0));
   loadAdjoint_xyz<T>(&s_adj[3*MAT_DIM],3,static_cast<T>(0),static_cast<T>(0),static_cast<T>(0.2155));
   loadAdjoint_xyz<T>(&s_adj[4*MAT_DIM],3,static_cast<T>(0),static_cast<T>(0.1845),static_cast<T>(0));
   loadAdjoint_xyz<T>(&s_adj[5*MAT_DIM],3,static_cast<T>(0),static_cast<T>(0),static_cast<T>(0.2155));
   loadAdjoint_xyz<T>(&s_adj[6*MAT_DIM],3,static_cast<T>(0),static_cast<T>(0.081),static_cast<T>(0));
}
template <typename T>
void updateTransforms4x4to6x6(T *s_T, T *s_Tb4, T *s_adj){
   // then convert from 4x4 to 6x6
   // if  4x4 = [R(3x3) xyz(1x3)
   //            0,0,0, 1       ]
   // the 6x6 = [R^T       0    
   //            R^T*adj   R^T]
   // so all we need to do is load R^T and compute R^T*adj
   #pragma unroll
   for (int k = 0; k < NUM_POS; k++){
      T *Tk = &s_T[36*k]; T *adjk = &s_adj[9*k]; T *T4k = &s_Tb4[k*16];
      #pragma unroll
      for (int ind = 0; ind < 9; ind++){int c = ind / 3; int r = ind % 3;
         // load in the R^T and 0
         T val = T4k[r*4+c]; Tk[c*6+r] = val; Tk[(c+3)*6+(r+3)] = val; Tk[(c+3)*6+r] = static_cast<T>(0);
         // compute R^T*adj (now c is col of adj and r is row of R^T = col of R)
         val = static_cast<T>(0);
         #pragma unroll
         for (int i = 0; i < 3; i++){val += T4k[r*4 + i] * adjk[c*3 + i];}
         Tk[c*6+r+3] = val;
      }
   }
}
template <typename T>
void updateTransforms4x4to6x6_v2(T *s_T, T *s_Tb4){
   // then convert from 4x4 to 6x6
   // if  4x4 = [R(3x3) xyz(1x3)
   //            0,0,0, 1       ]
   // the 6x6 = [R^T       0    
   //            R^T*adj   R^T]
   for (int k = 0; k < NUM_POS; k ++){
      // get the pointers and adj values
      T *Tk = &s_T[36*k]; T *T4k = &s_Tb4[k*16];
      T adjVal = k == 0 ? static_cast<T>(0.1575) : (k == 1 ? static_cast<T>(0.2025) : (k == 2 ? static_cast<T>(0.2045) : 
                (k == 3 || k == 5 ? static_cast<T>(0.2155) : (k == 4 ? static_cast<T>(0.1845) : static_cast<T>(0.081)))));
      // so all we need to do is load R^T, 0 and compute R^T*adj (and adj is hard coded!) in each quadrant
      for (int c = 0; c < 3; c++){
         for (int r = 0; r <3; r++){
            // load in the R^T and 0
            T val = T4k[r*4+c]; Tk[c*6+r] = val; Tk[(c+3)*6+(r+3)] = val; Tk[(c+3)*6+r] = static_cast<T>(0);
            // compute R^T*adj (now c is col of adj and r is row of R^T = col of R)
            // k = 0,1,3,5 only the z is not zero adj cols are [0;-z;0], [z;0;0], [0;0;0] else only the y is not zero adj cols are [0;0;y], [0;0;0], [-y;0;0]
            if(k == 0 || k == 1 || k == 3 || k == 5){Tk[c*6+r+3] = c == 0 ? T4k[r*4 + 1] * -adjVal : (c == 1 ? T4k[r*4] * adjVal : static_cast<T>(0));}
            else{Tk[c*6+r+3] = c == 0 ? T4k[r*4 + 2] * adjVal : (c == 1 ? static_cast<T>(0) : T4k[r*4] * -adjVal);}
         }
      }
   }
}
template <typename T, int ld = 16>
void initdTransforms4x4(T *s_Tbdx, T *s_sinq, T *s_cosq){
   #pragma unroll
   for (int i = 0; i < 16*NUM_POS; i++){s_Tbdx[i] = static_cast<T>(0);}
   s_Tbdx[0]      = -s_sinq[0];
   s_Tbdx[1]      = s_cosq[0];
   s_Tbdx[4]      = -s_cosq[0];
   s_Tbdx[5]      = -s_sinq[0];
   s_Tbdx[ld]     = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_cosq[1] + s_sinq[1];
   s_Tbdx[ld+1]   = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_cosq[1] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[1];
   s_Tbdx[ld+2]   = s_cosq[1];
   s_Tbdx[ld+4]   = s_cosq[1] - static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_sinq[1];
   s_Tbdx[ld+5]   = static_cast<T>(-0.00000000000000012246467991473532071737640294584)*s_cosq[1] - static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[1];
   s_Tbdx[ld+6]   = -s_sinq[1];
   s_Tbdx[2*ld]   = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_cosq[2] + s_sinq[2];
   s_Tbdx[2*ld+1] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_cosq[2] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[2];
   s_Tbdx[2*ld+2] = s_cosq[2];
   s_Tbdx[2*ld+4] = s_cosq[2] - static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_sinq[2];
   s_Tbdx[2*ld+5] = static_cast<T>(-0.00000000000000012246467991473532071737640294584)*s_cosq[2] - static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[2];
   s_Tbdx[2*ld+6] = -s_sinq[2];
   s_Tbdx[3*ld]   = -s_sinq[3];
   s_Tbdx[3*ld+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[3];
   s_Tbdx[3*ld+2] = s_cosq[3];
   s_Tbdx[3*ld+4] = -s_cosq[3];
   s_Tbdx[3*ld+5] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[3];
   s_Tbdx[3*ld+6] = -s_sinq[3];
   s_Tbdx[4*ld]   = s_sinq[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[4];
   s_Tbdx[4*ld+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[4];
   s_Tbdx[4*ld+2] = s_cosq[4] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[4];
   s_Tbdx[4*ld+4] = s_cosq[4] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[4];
   s_Tbdx[4*ld+5] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[4];
   s_Tbdx[4*ld+6] = static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[4] - s_sinq[4];
   s_Tbdx[5*ld]   = -s_sinq[5];
   s_Tbdx[5*ld+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[5];
   s_Tbdx[5*ld+2] = s_cosq[5];
   s_Tbdx[5*ld+4] = -s_cosq[5];
   s_Tbdx[5*ld+5] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[5];
   s_Tbdx[5*ld+6] = -s_sinq[5];
   s_Tbdx[6*ld]   = s_sinq[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[6];
   s_Tbdx[6*ld+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[6];
   s_Tbdx[6*ld+2] = s_cosq[6] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[6];
   s_Tbdx[6*ld+4] = s_cosq[6] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[6];
   s_Tbdx[6*ld+5] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[6];
   s_Tbdx[6*ld+6] = static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[6] - s_sinq[6];
}
template <typename T>
void computedTransforms4x4(T *s_dT, T *s_Tb, T *s_dTb, T *s_T,  T *s_dTp){
   int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
   int start, delta; singleLoopVals(&start,&delta);
   #pragma unroll
   for (int bodyi = 0; bodyi < NUM_POS; bodyi++){
      // compute world dTs (dT[i,j] = dT[i-1,j]*Tbody[i] + (i == j ? T[i-1]*dTbody[i] : 0))
      int iind = bodyi*16;
      T *Tim1 = &s_T[iind - 16]; T *Tbi = &s_Tb[iind]; T *dTbi = &s_dTb[iind];
      #pragma unroll
      for (int bodyj = starty; bodyj < NUM_POS; bodyj += dy){
         T *dTij = &s_dT[16*bodyj]; T *dTim1 = &s_dTp[16*bodyj];
         #pragma unroll
         for (int ind = startx; ind < 16; ind += dx){
            int ky = ind / 4; int kx = ind % 4; T val = 0;
            if (bodyi == 0){val += bodyi == bodyj ? dTbi[ind] : static_cast<T>(0);}
            else{
               #pragma unroll
               for (int i = 0; i < 4; i++){
                  int rind = kx + 4 * i; int cind = ky * 4 + i;
                  val += dTim1[rind]*Tbi[cind] + (bodyi == bodyj ? Tim1[rind]*dTbi[cind] : static_cast<T>(0));
               }
            }
            dTij[ind] = val;
         }
      }
      #pragma unroll
      for (int ind = start; ind < 16*NUM_POS; ind += delta){s_dTp[ind] = s_dT[ind];}
   }
}
template <typename T>
void computedEEPos4x4(T *s_eePos, T *s_T, T *s_deePos = nullptr, T *s_Tdx = nullptr, T *s_temp = nullptr){
   int start, delta; singleLoopVals(&start,&delta);
   T *Tee = &s_T[(NUM_POS-1)*16];
   // get hand pos and factors for multiplication in one thread
   s_eePos[0] = Tee[0]*static_cast<T>(EE_ON_LINK_X) + Tee[4]*static_cast<T>(EE_ON_LINK_Y) + Tee[8]*static_cast<T>(EE_ON_LINK_Z)  + Tee[12];
   s_eePos[1] = Tee[1]*static_cast<T>(EE_ON_LINK_X) + Tee[5]*static_cast<T>(EE_ON_LINK_Y) + Tee[9]*static_cast<T>(EE_ON_LINK_Z)  + Tee[13];
   s_eePos[2] = Tee[2]*static_cast<T>(EE_ON_LINK_X) + Tee[6]*static_cast<T>(EE_ON_LINK_Y) + Tee[10]*static_cast<T>(EE_ON_LINK_Z) + Tee[14];
   s_eePos[3] = (T) atan2(Tee[6],Tee[10]);
   s_eePos[4] = (T) atan2(-Tee[2],sqrt(Tee[6]*Tee[6]+Tee[10]*Tee[10]));
   s_eePos[5] = (T) atan2(Tee[1],Tee[0]);
   // if computing derivatives first compute factors in temp memory
   bool dFlag = (s_deePos != nullptr) && (s_Tdx != nullptr) && (s_temp != nullptr);
   if (dFlag){
      T factor3 = Tee[6]*Tee[6] + Tee[10]*Tee[10];
      T factor4 = static_cast<T>(1)/(Tee[2]*Tee[2] + factor3);
      T factor5 = static_cast<T>(1)/(Tee[1]*Tee[1] + Tee[0]*Tee[0]);
      T sqrtfactor3 = (T) sqrt(factor3);
      s_temp[0] = -Tee[6]/factor3;
      s_temp[1] = Tee[10]/factor3;
      s_temp[2] = Tee[2]*Tee[6]*factor4/sqrtfactor3;
      s_temp[3] = Tee[2]*Tee[10]*factor4/sqrtfactor3;
      s_temp[4] = -sqrtfactor3*factor4;
      s_temp[5] = -Tee[1]*factor5;
      s_temp[6] = Tee[0]*factor5;
      // then compute all dk in parallel (note dqd is 0 so only dq needed)
      #pragma unroll
      for (int k = start; k < NUM_POS; k += delta){
         T *dT = &s_Tdx[16*k]; // looped variant only saves final dT[i]/dx but thats all we need (which is why that is ok)
         s_deePos[k*6]     = dT[0]*static_cast<T>(EE_ON_LINK_X) + dT[4]*static_cast<T>(EE_ON_LINK_Y) + dT[8]*static_cast<T>(EE_ON_LINK_Z)  + dT[12];
         s_deePos[k*6 + 1] = dT[1]*static_cast<T>(EE_ON_LINK_X) + dT[5]*static_cast<T>(EE_ON_LINK_Y) + dT[9]*static_cast<T>(EE_ON_LINK_Z)  + dT[13];
         s_deePos[k*6 + 2] = dT[2]*static_cast<T>(EE_ON_LINK_X) + dT[6]*static_cast<T>(EE_ON_LINK_Y) + dT[10]*static_cast<T>(EE_ON_LINK_Z) + dT[14];
         s_deePos[k*6 + 3] = s_temp[0]*dT[10] + s_temp[1]*dT[6];
         s_deePos[k*6 + 4] = s_temp[2]*dT[6]  + s_temp[3]*dT[10] + s_temp[4]*dT[2];
         s_deePos[k*6 + 5] = s_temp[5]*dT[0]  + s_temp[6]*dT[1];
      }
   }
}
template <typename T, int MAT_DIM = 16>
void buildTransforms4x4dq(T *s_T4bdq, T *s_sinq, T *s_cosq){
   s_T4bdq[0]      = -s_sinq[0];
   s_T4bdq[1]      = s_cosq[0];
   s_T4bdq[2]      = static_cast<T>(0);
   s_T4bdq[3]      = static_cast<T>(0);
   s_T4bdq[4]      = -s_cosq[0];
   s_T4bdq[5]      = -s_sinq[0];
   s_T4bdq[6]      = static_cast<T>(0);
   s_T4bdq[7]      = static_cast<T>(0);
   // 8-15 are zeros so we can skip those columns always
   s_T4bdq[MAT_DIM]     = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_cosq[1] + s_sinq[1];
   s_T4bdq[MAT_DIM+1]   = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_cosq[1] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[1];
   s_T4bdq[MAT_DIM+2]   = s_cosq[1];
   s_T4bdq[MAT_DIM+3]   = static_cast<T>(0);
   s_T4bdq[MAT_DIM+4]   = s_cosq[1] - static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_sinq[1];
   s_T4bdq[MAT_DIM+5]   = static_cast<T>(-0.00000000000000012246467991473532071737640294584)*s_cosq[1] - static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[1];
   s_T4bdq[MAT_DIM+6]   = -s_sinq[1];
   s_T4bdq[MAT_DIM+7]   = static_cast<T>(0);
   // 8-15 are zeros so we can skip those columns always
   s_T4bdq[2*MAT_DIM]   = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_cosq[2] + s_sinq[2];
   s_T4bdq[2*MAT_DIM+1] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_cosq[2] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[2];
   s_T4bdq[2*MAT_DIM+2] = s_cosq[2];
   s_T4bdq[2*MAT_DIM+3] = static_cast<T>(0);
   s_T4bdq[2*MAT_DIM+4] = s_cosq[2] - static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_sinq[2];
   s_T4bdq[2*MAT_DIM+5] = static_cast<T>(-0.00000000000000012246467991473532071737640294584)*s_cosq[2] - static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[2];
   s_T4bdq[2*MAT_DIM+6] = -s_sinq[2];
   s_T4bdq[2*MAT_DIM+7] = static_cast<T>(0);
   // 8-15 are zeros so we can skip those columns always
   s_T4bdq[3*MAT_DIM]   = -s_sinq[3];
   s_T4bdq[3*MAT_DIM+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[3];
   s_T4bdq[3*MAT_DIM+2] = s_cosq[3];
   s_T4bdq[3*MAT_DIM+3] = static_cast<T>(0);
   s_T4bdq[3*MAT_DIM+4] = -s_cosq[3];
   s_T4bdq[3*MAT_DIM+5] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[3];
   s_T4bdq[3*MAT_DIM+6] = -s_sinq[3];
   s_T4bdq[3*MAT_DIM+7] = static_cast<T>(0);
   // 8-15 are zeros so we can skip those columns always
   s_T4bdq[4*MAT_DIM]   = s_sinq[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[4];
   s_T4bdq[4*MAT_DIM+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[4];
   s_T4bdq[4*MAT_DIM+2] = s_cosq[4] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[4];
   s_T4bdq[4*MAT_DIM+3] = static_cast<T>(0);
   s_T4bdq[4*MAT_DIM+4] = s_cosq[4] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[4];
   s_T4bdq[4*MAT_DIM+5] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[4];
   s_T4bdq[4*MAT_DIM+6] = static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[4] - s_sinq[4];
   s_T4bdq[4*MAT_DIM+7] = static_cast<T>(0);
   // 8-15 are zeros so we can skip those columns always
   s_T4bdq[5*MAT_DIM]   = -s_sinq[5];
   s_T4bdq[5*MAT_DIM+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[5];
   s_T4bdq[5*MAT_DIM+2] = s_cosq[5];
   s_T4bdq[5*MAT_DIM+3] = static_cast<T>(0);
   s_T4bdq[5*MAT_DIM+4] = -s_cosq[5];
   s_T4bdq[5*MAT_DIM+5] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[5];
   s_T4bdq[5*MAT_DIM+6] = -s_sinq[5];
   s_T4bdq[5*MAT_DIM+7] = static_cast<T>(0);
   // 8-15 are zeros so we can skip those columns always
   s_T4bdq[6*MAT_DIM]   = s_sinq[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[6];
   s_T4bdq[6*MAT_DIM+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[6];
   s_T4bdq[6*MAT_DIM+2] = s_cosq[6] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[6];
   s_T4bdq[6*MAT_DIM+3] = static_cast<T>(0);
   s_T4bdq[6*MAT_DIM+4] = s_cosq[6] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[6];
   s_T4bdq[6*MAT_DIM+5] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[6];
   s_T4bdq[6*MAT_DIM+6] = static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[6] - s_sinq[6];
   s_T4bdq[6*MAT_DIM+7] = static_cast<T>(0);
   // 8-15 are zeros so we can skip those columns always
}
template <typename T>
void computeTransforms4x4dqEE(T *s_dT, T *s_Tb, T *s_dTb, T *s_T,  T *s_dTp){
   int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
   #pragma unroll
   for (int bodyi = 0; bodyi < NUM_POS; bodyi++){
      // compute dTs (dT[i,j] = dT[i-1,j]*Tbody[i] + (i == j ? T[i-1]*dTbody[i] : 0))
      int iind = bodyi*16;
      T *Tim1 = &s_T[iind - 16]; T *Tbi = &s_Tb[iind]; T *dTbi = &s_dTb[iind];
      #pragma unroll
      for (int bodyj = starty; bodyj < NUM_POS; bodyj += dy){
         T *dTij = &s_dT[16*bodyj]; T *dTim1 = &s_dTp[16*bodyj];
         #pragma unroll
         for (int ind = startx; ind < 16; ind += dx){ // note only 1st two columns are ever non-zero for dTb
            int ky = ind / 4; int kx = ind % 4; T val = 0;
            if (bodyi == 0){val += bodyi == bodyj && ky < 2 ? dTbi[ind] : static_cast<T>(0);}
            else{
               #pragma unroll
               for (int i = 0; i < 4; i++){
                  int rind = kx + 4 * i; int cind = ky * 4 + i;
                  val += dTim1[rind]*Tbi[cind] + (bodyi == bodyj && ky < 2 ? Tim1[rind]*dTbi[cind] : static_cast<T>(0));
               }
            }
            dTij[ind] = val;
         }
      }
      // copy non-zeros to dTp for next loop
      #pragma unroll
      for (int ind = 0; ind < 16*NUM_POS; ind++){s_dTp[ind] = s_dT[ind];}
   }
}
// tempMem is 34*NUM_POS
// dtempMem is 49*NUM_POS
template <typename T>
void computedEEPos4x4_scratch(T *s_eePos, T *s_q, T *s_tempMem, T *s_deePos = nullptr, T *s_dtempMem = nullptr){
   int offset = 16*NUM_POS; T *s_Tb = s_tempMem; T *s_T = s_Tb + offset; T *s_sinq = s_T + offset; T *s_cosq = s_sinq + NUM_POS;
   #pragma unroll
   for (int ind = 0; ind < NUM_POS; ind++){s_sinq[ind] = std::sin(s_q[ind]); s_cosq[ind] = std::cos(s_q[ind]);}
   buildTransforms4x4(s_Tb,s_sinq,s_cosq);
   recurseTransforms4x4(s_T, s_Tb);
   if (s_deePos != nullptr && s_dtempMem != nullptr){ // compute derivatives too!
      T *s_Tbdx = s_dtempMem;    T *s_Tdx = s_Tbdx + offset;    T *s_Tdxp = s_Tdx + offset;      T *s_temp = s_Tdxp + offset;
      buildTransforms4x4dq(s_Tbdx,s_sinq,s_cosq);
      computeTransforms4x4dqEE(s_Tdx,s_Tb,s_Tbdx,s_T,s_Tdxp);
      computedEEPos4x4(s_eePos,s_T,s_deePos,s_Tdx,s_temp);
   }
   else{computedEEPos4x4(s_eePos,s_T);} // just compute eePos
}
template <typename T, int ld = 16>
void updateTransforms4x4to6x6(T *s_T, T *s_T4, T *s_Tb, T *d_Tb, T *s_q, T *s_sinq, T *s_cosq, T *s_temp){
   // compute sin/cos in parallel as well as loading in Tbase
   int start, delta; singleLoopVals(&start,&delta);
   int starty, dy, startx, dx; doubleLoopVals(&starty,&dy,&startx,&dx);
   #pragma unroll
   for (int ind = start; ind < NUM_POS; ind += delta){s_sinq[ind] = sin(s_q[ind]); s_cosq[ind] = cos(s_q[ind]);}
   s_Tb[0] = s_cosq[0];
   s_Tb[1] = s_sinq[0];
   s_Tb[4] = -s_sinq[0];
   s_Tb[5] = s_cosq[0];
   s_Tb[ld] = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_sinq[1] - s_cosq[1];
   s_Tb[ld+1] = static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[1] + static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[1];
   s_Tb[ld+2] = s_sinq[1];
   s_Tb[ld+4] = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_cosq[1] + s_sinq[1];
   s_Tb[ld+5] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_cosq[1] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[1];
   s_Tb[ld+6] = s_cosq[1];
   s_Tb[2*ld]   = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_sinq[2] - 1.0*s_cosq[2];
   s_Tb[2*ld+1] = static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[2] + static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_sinq[2];
   s_Tb[2*ld+2] = s_sinq[2];
   s_Tb[2*ld+4] = static_cast<T>(0.000000000000000000000000000000046886444024566354179237414162174)*s_cosq[2] + s_sinq[2];
   s_Tb[2*ld+5] = static_cast<T>(0.0000000000000003828568698926949434848128216851)*s_cosq[2] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[2];
   s_Tb[2*ld+6] = s_cosq[2];
   s_Tb[3*ld]   = s_cosq[3];
   s_Tb[3*ld+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinq[3];
   s_Tb[3*ld+2] = s_sinq[3];
   s_Tb[3*ld+4] = -s_sinq[3];
   s_Tb[3*ld+5] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[3];
   s_Tb[3*ld+6] = s_cosq[3];
   s_Tb[4*ld]   = -s_cosq[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[4];
   s_Tb[4*ld+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinq[4];
   s_Tb[4*ld+2] = s_sinq[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[4];
   s_Tb[4*ld+4] = s_sinq[4] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[4];
   s_Tb[4*ld+5] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[4];
   s_Tb[4*ld+6] = s_cosq[4] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[4];
   s_Tb[5*ld]   = s_cosq[5];
   s_Tb[5*ld+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinq[5];
   s_Tb[5*ld+2] = s_sinq[5];
   s_Tb[5*ld+4] = -s_sinq[5];
   s_Tb[5*ld+5] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[5];
   s_Tb[5*ld+6] = s_cosq[5];
   s_Tb[6*ld]   = -s_cosq[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[6];
   s_Tb[6*ld+1] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_sinq[6];
   s_Tb[6*ld+2] = s_sinq[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[6];
   s_Tb[6*ld+4] = s_sinq[6] - static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_cosq[6];
   s_Tb[6*ld+5] = static_cast<T>(-0.0000000000000003828568698926949434848128216851)*s_cosq[6];
   s_Tb[6*ld+6] = s_cosq[6] + static_cast<T>(0.00000000000000012246467991473532071737640294584)*s_sinq[6];
   // then convert from 4x4 to 6x6
   // 4x4 = [R^T|xyz;0,0,0,1]
   // 6x6 = [R|0;0|R]*[I|0;stuff|I] where stuff is [0, Z,-Y;
   //                                              -Z, 0, X;
   //                                               Y,-X, 0]  note the stuff is an adjoint of (x,y,z)
   // compute and load adjoints in parallel
   #pragma unroll
   for (int k = start; k < NUM_POS; k += delta){
      int stuffBase = 36*k;  int t4_base = 16*k + 12;
      loadAdjoint_xyz<T>(&s_Tb[stuffBase+3],6,s_T4[t4_base],s_T4[t4_base+1],s_T4[t4_base+2]);
   }
   // and the other things
   #pragma unroll
   for (int k = starty; k < NUM_POS; k += dy){
      T *Tbbase = &s_Tb[36*k]; T *tempbase = &s_temp[36*k]; T *T4k = &s_T4[k*16];
      // identity mats, zeros, and Rs
      #pragma unroll
      for (int rc = startx; rc < 9; rc += dx){
         int c = rc / 3; int r = rc % 3; int offset = c*6+r;
         T Ival = (r == c) ? static_cast<T>(1) : static_cast<T>(0);
         Tbbase[offset] = Ival; Tbbase[offset + 21] = Ival; Tbbase[offset + 18] = static_cast<T>(0);
         tempbase[offset + 3] = static_cast<T>(0); tempbase[offset + 18] = static_cast<T>(0);
         T Rval = T4k[r*4+c]; tempbase[offset] = Rval; tempbase[offset + 21] = Rval;
      }
   }
   // then matmult into final Ts
   for(int k = 0; k < NUM_POS; k++){
      T *Tk = &s_T[k*36]; T *Tbk = &s_Tb[k*36]; T *tempk = &s_temp[k*36]; matMult<T,6,6,6>(Tk,6,tempk,6,Tbk,6);
   }
}

//-------------------------------------------------------------------------------
// Helper Function to Calculate Spatial Cross Product Matrix for Motion Vectors
//-------------------------------------------------------------------------------
//
// In:  v the spatial velocity voidining the cross product
// Out: vx the 6x6 matrix whose coefficients will be set; must be
//      initialized with zeros (that is, this void does not assign the
//      zero elements of the cross product matrix).
//
// -- RobCoGen
//
template <typename T>
void motionCrossProductMxCol3(T *s_vx, T *s_v){
   s_vx[0] = s_v[1];
   s_vx[1] = -s_v[0];
   s_vx[2] = 0;
   s_vx[3] = s_v[4];
   s_vx[4] = -s_v[3];
   s_vx[5] = 0;
}
template <typename T, bool ADD = 1>
void motionCrossProductMxCol3(T *s_vx, T *s_v, T qd_k){
   s_vx[0] = s_v[1]*qd_k;
   s_vx[1] = -s_v[0]*qd_k;
   s_vx[2] = 0;
   s_vx[3] = s_v[4]*qd_k;
   s_vx[4] = -s_v[3]*qd_k;
   s_vx[5] = 0;
   // finish off the lk_v from earlier
   if (ADD){s_v[2] += qd_k;}
}

template <typename T>
T MxMatCol3(int r, T *v, T *M){
   if (r == 2 || r == 5){return static_cast<T>(0);}
   else{
      int rcomp = r == 0 ? 1 : (r == 1 ? 0 : (r == 3 ? 4 : 3)); 
      T sgn = (r == 0 || r == 3) ? static_cast<T>(1) : static_cast<T>(-1);
      T val = 0;
      #pragma unroll
      for(int i = 0; i < 6; i++){val += M[rcomp + 6 * i] * v[i];} 
      return (val * sgn);
   }
}
template <typename T>
T MxMatCol3(int r, T *v){
   if (r == 2 || r == 5){return static_cast<T>(0);}
   else{
      int rcomp = r == 0 ? 1 : (r == 1 ? 0 : (r == 3 ? 4 : 3)); 
      T sgn = (r == 0 || r == 3) ? static_cast<T>(1) : static_cast<T>(-1);
      return (v[rcomp] * sgn);
   }
}

template <typename T, bool PEQFLAG = 0>
void MxMatCol3(T *out, T *vec){
   if (PEQFLAG){
      out[0] += vec[1];
      out[1] += -vec[0];
      out[3] += vec[4];
      out[4] += -vec[3];
   }
   else{
      out[0] = vec[1];
      out[1] = -vec[0];
      out[2] = 0;
      out[3] = vec[4];
      out[4] = -vec[3];
      out[5] = 0;
   }
}

template <typename T, bool PEQFLAG = 0>
void MxMatCol3(T *out, T *vec, T alpha){
   if (PEQFLAG){
      out[0] += vec[1]*alpha;
      out[1] += -vec[0]*alpha;
      out[3] += vec[4]*alpha;
      out[4] += -vec[3]*alpha;
   }
   else{
      out[0] = vec[1]*alpha;
      out[1] = -vec[0]*alpha;
      out[2] = 0;
      out[3] = vec[4]*alpha;
      out[4] = -vec[3]*alpha;
      out[5] = 0;
   }
}

template <typename T, bool PEQFLAG = 0, bool T_FLAG = 0>
void MxMatCol3_Tmat(T *out, T *Tmat, T *vec){
   if (PEQFLAG){
      out[0] += dotProd_Tmat<T,T_FLAG>(Tmat,vec,1);
      out[1] += -dotProd_Tmat<T,T_FLAG>(Tmat,vec,0);
      out[3] += dotProd_Tmat<T,T_FLAG>(Tmat,vec,4);
      out[4] += -dotProd_Tmat<T,T_FLAG>(Tmat,vec,3);
   }
   else{
      out[0] = dotProd_Tmat<T,T_FLAG>(Tmat,vec,1);
      out[1] = -dotProd_Tmat<T,T_FLAG>(Tmat,vec,0);
      out[2] = static_cast<T>(0);
      out[3] = dotProd_Tmat<T,T_FLAG>(Tmat,vec,4);
      out[4] = -dotProd_Tmat<T,T_FLAG>(Tmat,vec,3);
      out[5] = static_cast<T>(0);
   }
}                   
//---------------------------------------------------------------------
// Helper Function to Perform vxIv Matrix Product
//-------------------------------------------------------------------------------
//
// This is a "manual" implementation of the matrix product, as the obvious
// implementation (plain matrix-matrix-vector multiplication) would not
// exploit the (known) sparsity pattern and the fact that the first and last
// term ( v cross* and v) have the same coefficients.
//
// -- RobCoGen
//
// on GPU need the temp of size 18 for dumb and 36+6 for smart GPU version
template <typename T>
void vxIv(T *s_ret, T *s_v, T *s_I){
   // first do temp = I*v
   T s_temp[6]; matVMult<T,6,6,0>(s_temp,s_I,6,s_v); 
   // then do crf(v)*temp -- note from testing this is faster then constructing the full crf matrix
   s_ret[0] = -s_v[2]*s_temp[1] + s_v[1]*s_temp[2];
   s_ret[1] = s_v[2]*s_temp[0] + -s_v[0]*s_temp[2];
   s_ret[2] = -s_v[1]*s_temp[0] + s_v[0]*s_temp[1];
   s_ret[3] = -s_v[2]*s_temp[1+3] + s_v[1]*s_temp[2+3];
   s_ret[4] = s_v[2]*s_temp[0+3] + -s_v[0]*s_temp[2+3];
   s_ret[5] = -s_v[1]*s_temp[0+3] + s_v[0]*s_temp[1+3];
   s_ret[0] += -s_v[2+3]*s_temp[1+3] + s_v[1+3]*s_temp[2+3];
   s_ret[1] += s_v[2+3]*s_temp[0+3] + -s_v[0+3]*s_temp[2+3];
   s_ret[2] += -s_v[1+3]*s_temp[0+3] + s_v[0+3]*s_temp[1+3];
}


//-------------------------------------------------------------------------------
// Helper Function to Transform a Symmetric Matrix A with the Rotation Matrix E
//-------------------------------------------------------------------------------
//
// Performs the transformation of a symmetric 3x3 matrix A, with the rotation
// matrix E
//    B = E * A * E^T
//
// These calculations are documented in the appendix of Roy's book
//
// -- RobCoGen
//

template <typename T>
void rot_symmetric_EAET(T *B, T *E, T *A){
   T LXX = A[rcJ_IndCpp(1,1,3)] - A[rcJ_IndCpp(3,3,3)];
   T LXY = A[rcJ_IndCpp(1,2,3)]; // same as LYX
   T LYY = A[rcJ_IndCpp(2,2,3)] - A[rcJ_IndCpp(3,3,3)];
   T LZX = 2*A[rcJ_IndCpp(1,3,3)];
   T LZY = 2*A[rcJ_IndCpp(2,3,3)];

   T yXX = E[rcJ_IndCpp(2,1,3)]*LXX + E[rcJ_IndCpp(2,2,3)]*LXY + E[rcJ_IndCpp(2,3,3)]*LZX;
   T yXY = E[rcJ_IndCpp(2,1,3)]*LXY + E[rcJ_IndCpp(2,2,3)]*LYY + E[rcJ_IndCpp(2,3,3)]*LZY;
   T yYX = E[rcJ_IndCpp(3,1,3)]*LXX + E[rcJ_IndCpp(3,2,3)]*LXY + E[rcJ_IndCpp(3,3,3)]*LZX;
   T yYY = E[rcJ_IndCpp(3,1,3)]*LXY + E[rcJ_IndCpp(3,2,3)]*LYY + E[rcJ_IndCpp(3,3,3)]*LZY;

   T v1 = -A[rcJ_IndCpp(2,3,3)];
   T v2 =  A[rcJ_IndCpp(1,3,3)];
   T EvX = E[rcJ_IndCpp(1,1,3)]*v1 + E[rcJ_IndCpp(1,2,3)]*v2;
   T EvY = E[rcJ_IndCpp(2,1,3)]*v1 + E[rcJ_IndCpp(2,2,3)]*v2;
   T EvZ = E[rcJ_IndCpp(3,1,3)]*v1 + E[rcJ_IndCpp(3,2,3)]*v2;

   B[rcJ_IndCpp(1,2,3)] = yXX * E[rcJ_IndCpp(1,1,3)] + yXY * E[rcJ_IndCpp(1,2,3)] + EvZ;
   B[rcJ_IndCpp(1,3,3)] = yYX * E[rcJ_IndCpp(1,1,3)] + yYY * E[rcJ_IndCpp(1,2,3)] - EvY;
   B[rcJ_IndCpp(2,3,3)] = yYX * E[rcJ_IndCpp(2,1,3)] + yYY * E[rcJ_IndCpp(2,2,3)] + EvX;

   T zYY = yXX * E[rcJ_IndCpp(2,1,3)] + yXY * E[rcJ_IndCpp(2,2,3)];
   T zZZ = yYX * E[rcJ_IndCpp(3,1,3)] + yYY * E[rcJ_IndCpp(3,2,3)];
   B[rcJ_IndCpp(1,1,3)] = LXX + LYY - zYY - zZZ + A[rcJ_IndCpp(3,3,3)];
   B[rcJ_IndCpp(2,2,3)] = zYY + A[rcJ_IndCpp(3,3,3)];
   B[rcJ_IndCpp(3,3,3)] = zZZ + A[rcJ_IndCpp(3,3,3)];
   
   // zero out the rest
   B[rcJ_IndCpp(2,1,3)] = static_cast<T>(0);
   B[rcJ_IndCpp(3,1,3)] = static_cast<T>(0);
   B[rcJ_IndCpp(3,2,3)] = static_cast<T>(0);
}

//-------------------------------------------------------------------------------
// Helper Function to Transform a Matrix A with the Rotation Matrix E
//-------------------------------------------------------------------------------
//
// Performs the transformation of a 3x3 matrix A, with the rotation
// matrix E
//    B = E * A * E^T
//
// -- RobCoGen
//
template <typename T>
void rot_EAET(T *B, T *E, T *A){
   T v_4X = A[rcJ_IndCpp(1,1,3)] - A[rcJ_IndCpp(3,3,3)];
   T v_4Y = A[rcJ_IndCpp(1,2,3)];
   T v_5X = A[rcJ_IndCpp(2,1,3)];
   T v_5Y = A[rcJ_IndCpp(2,2,3)] - A[rcJ_IndCpp(3,3,3)];
   T v_6X = A[rcJ_IndCpp(3,1,3)] + A[rcJ_IndCpp(1,3,3)];
   T v_6Y = A[rcJ_IndCpp(3,2,3)] + A[rcJ_IndCpp(2,3,3)];

   T v1 = -A[rcJ_IndCpp(2,3,3)];
   T v2 =  A[rcJ_IndCpp(1,3,3)];
   T EvX = E[rcJ_IndCpp(1,1,3)]*v1 + E[rcJ_IndCpp(1,2,3)]*v2;
   T EvY = E[rcJ_IndCpp(2,1,3)]*v1 + E[rcJ_IndCpp(2,2,3)]*v2;
   T EvZ = E[rcJ_IndCpp(3,1,3)]*v1 + E[rcJ_IndCpp(3,2,3)]*v2;

   T yXX = E[rcJ_IndCpp(1,1,3)]*v_4X + E[rcJ_IndCpp(1,2,3)]*v_5X + E[rcJ_IndCpp(1,3,3)]*v_6X;
   T yXY = E[rcJ_IndCpp(1,1,3)]*v_4Y + E[rcJ_IndCpp(1,2,3)]*v_5Y + E[rcJ_IndCpp(1,3,3)]*v_6Y;
   T yYX = E[rcJ_IndCpp(2,1,3)]*v_4X + E[rcJ_IndCpp(2,2,3)]*v_5X + E[rcJ_IndCpp(2,3,3)]*v_6X;
   T yYY = E[rcJ_IndCpp(2,1,3)]*v_4Y + E[rcJ_IndCpp(2,2,3)]*v_5Y + E[rcJ_IndCpp(2,3,3)]*v_6Y;
   T yZX = E[rcJ_IndCpp(3,1,3)]*v_4X + E[rcJ_IndCpp(3,2,3)]*v_5X + E[rcJ_IndCpp(3,3,3)]*v_6X;
   T yZY = E[rcJ_IndCpp(3,1,3)]*v_4Y + E[rcJ_IndCpp(3,2,3)]*v_5Y + E[rcJ_IndCpp(3,3,3)]*v_6Y;

   B[rcJ_IndCpp(1,1,3)] = yXX*E[rcJ_IndCpp(1,1,3)] + yXY*E[rcJ_IndCpp(1,2,3)] + A[rcJ_IndCpp(3,3,3)];
   B[rcJ_IndCpp(2,2,3)] = yYX*E[rcJ_IndCpp(2,1,3)] + yYY*E[rcJ_IndCpp(2,2,3)] + A[rcJ_IndCpp(3,3,3)];
   B[rcJ_IndCpp(3,3,3)] = yZX*E[rcJ_IndCpp(3,1,3)] + yZY*E[rcJ_IndCpp(3,2,3)] + A[rcJ_IndCpp(3,3,3)];

   B[rcJ_IndCpp(1,2,3)] = yXX*E[rcJ_IndCpp(2,1,3)] + yXY*E[rcJ_IndCpp(2,2,3)] - EvZ;
   B[rcJ_IndCpp(2,1,3)] = yYX*E[rcJ_IndCpp(1,1,3)] + yYY*E[rcJ_IndCpp(1,2,3)] + EvZ;
   B[rcJ_IndCpp(1,3,3)] = yXX*E[rcJ_IndCpp(3,1,3)] + yXY*E[rcJ_IndCpp(3,2,3)] + EvY;
   B[rcJ_IndCpp(3,1,3)] = yZX*E[rcJ_IndCpp(1,1,3)] + yZY*E[rcJ_IndCpp(1,2,3)] - EvY;
   B[rcJ_IndCpp(2,3,3)] = yYX*E[rcJ_IndCpp(3,1,3)] + yYY*E[rcJ_IndCpp(3,2,3)] - EvX;
   B[rcJ_IndCpp(3,2,3)] = yZX*E[rcJ_IndCpp(2,1,3)] + yZY*E[rcJ_IndCpp(2,2,3)] + EvX;
}

//-------------------------------------------------------------------------------
// Helper Function to Compute Articulated Inertia for Revolute Joint
//-------------------------------------------------------------------------------
//
// These voids calculate the spatial articulated inertia of a subtree, in
// the special case of a mass-less handle (see chapter 7 of the RBDA
// book, s7.2.2, equation 7.23)
//
// Two specialized voids are available for the two cases of revolute and
// prismatic joint (which connects the subtree with the mass-less handle), since
// the inertia exhibits two different sparsity patterns.
//
// In:  IA the regular articulated inertia of some subtree
// In:  U the U term for the current joint (cfr. eq. 7.43 of RBDA)
// In:  D the D term for the current joint (cfr. eq. 7.44 of RBDA)
// Out: Ia the articulated inertia for the same subtree, but
//      propagated across the current joint. The matrix is assumed to be
//      already initialized with zeros, at least in the row and column which
//      is known to be zero. In other words, those elements are not computed
//      nor assigned in this void.
//      Note that the constness of the argument is
//      casted away (trick required with Eigen), as this is an output
//      argument.
//
// -- RobCoGen
//
template <typename T>
void compute_Ia_revolute(T *s_Ia, T *s_I, T *s_U, T Dinv){
   // for(int i = 0; i < 36; i++){s_Ia[i] = 0;}
   T s_UD[6];
   #pragma unroll
   for(int i = 0; i < 6; i++){s_UD[i] = s_U[i]*Dinv;}

   s_Ia[rcJ_IndCpp(1,1,6)] = s_I[rcJ_IndCpp(1,1,6)] - s_U[0]*s_UD[0];
   s_Ia[rcJ_IndCpp(1,2,6)] = s_I[rcJ_IndCpp(1,2,6)] - s_U[0]*s_UD[1];
   // s_Ia[rcJ_IndCpp(2,1,6)] = s_I[rcJ_IndCpp(1,2,6)] - s_U[0]*s_UD[1];
   //s_Ia[rcJ_IndCpp(1,3,6)] = s_Ia[rcJ_IndCpp(3,1,6)] = 0 // assumed to be set already
   s_Ia[rcJ_IndCpp(1,3,6)] = static_cast<T>(0);
   s_Ia[rcJ_IndCpp(1,4,6)] = s_I[rcJ_IndCpp(1,4,6)] - s_U[0]*s_UD[3];
   // s_Ia[rcJ_IndCpp(4,1,6)] = s_I[rcJ_IndCpp(1,4,6)] - s_U[0]*s_UD[3];
   s_Ia[rcJ_IndCpp(1,5,6)] = s_I[rcJ_IndCpp(1,5,6)] - s_U[0]*s_UD[4];
   // s_Ia[rcJ_IndCpp(5,1,6)] = s_I[rcJ_IndCpp(1,5,6)] - s_U[0]*s_UD[4];
   s_Ia[rcJ_IndCpp(1,6,6)] = s_I[rcJ_IndCpp(1,6,6)] - s_U[0]*s_UD[5];
   // s_Ia[rcJ_IndCpp(6,1,6)] = s_I[rcJ_IndCpp(1,6,6)] - s_U[0]*s_UD[5];

   s_Ia[rcJ_IndCpp(2,2,6)] = s_I[rcJ_IndCpp(2,2,6)] - s_U[1]*s_UD[1];
   s_Ia[rcJ_IndCpp(2,3,6)] = static_cast<T>(0);
   //s_Ia[rcJ_IndCpp(2,3,6)] = s_Ia[rcJ_IndCpp(3,2,6)] = 0 // assumed to be set already
   s_Ia[rcJ_IndCpp(2,4,6)] = s_I[rcJ_IndCpp(2,4,6)] - s_U[1]*s_UD[3];
   // s_Ia[rcJ_IndCpp(4,2,6)] = s_I[rcJ_IndCpp(2,4,6)] - s_U[1]*s_UD[3];
   s_Ia[rcJ_IndCpp(2,5,6)] = s_I[rcJ_IndCpp(2,5,6)] - s_U[1]*s_UD[4];
   // s_Ia[rcJ_IndCpp(5,2,6)] = s_I[rcJ_IndCpp(2,5,6)] - s_U[1]*s_UD[4];
   s_Ia[rcJ_IndCpp(2,6,6)] = s_I[rcJ_IndCpp(2,6,6)] - s_U[1]*s_UD[5];
   // s_Ia[rcJ_IndCpp(6,2,6)] = s_I[rcJ_IndCpp(2,6,6)] - s_U[1]*s_UD[5];

   // The whole row 3 is assumed to be already set to zero
   s_Ia[rcJ_IndCpp(3,3,6)] = static_cast<T>(0);
   s_Ia[rcJ_IndCpp(3,4,6)] = static_cast<T>(0);
   s_Ia[rcJ_IndCpp(3,5,6)] = static_cast<T>(0);
   s_Ia[rcJ_IndCpp(3,6,6)] = static_cast<T>(0);

   s_Ia[rcJ_IndCpp(4,4,6)] = s_I[rcJ_IndCpp(4,4,6)] - s_U[3]*s_UD[3];
   s_Ia[rcJ_IndCpp(4,5,6)] = s_I[rcJ_IndCpp(4,5,6)] - s_U[3]*s_UD[4];
   // s_Ia[rcJ_IndCpp(5,4,6)] = s_I[rcJ_IndCpp(4,5,6)] - s_U[3]*s_UD[4];
   s_Ia[rcJ_IndCpp(4,6,6)] = s_I[rcJ_IndCpp(4,6,6)] - s_U[3]*s_UD[5];
   // s_Ia[rcJ_IndCpp(6,4,6)] = s_I[rcJ_IndCpp(4,6,6)] - s_U[3]*s_UD[5];

   s_Ia[rcJ_IndCpp(5,5,6)] = s_I[rcJ_IndCpp(5,5,6)] - s_U[4]*s_UD[4];
   s_Ia[rcJ_IndCpp(5,6,6)] = s_I[rcJ_IndCpp(5,6,6)] - s_U[4]*s_UD[5];
   // s_Ia[rcJ_IndCpp(6,5,6)] = s_I[rcJ_IndCpp(5,6,6)] - s_U[4]*s_UD[5];

   s_Ia[rcJ_IndCpp(6,6,6)] = s_I[rcJ_IndCpp(6,6,6)] - s_U[5]*s_UD[5];

   // we now have an upper triangular matrix and need to copy over
   // but actually we only use this in the bleow fun so we can skip this
   // #pragma unroll
   // for (int c = 0; c < 6; c++){
   //    #pragma unroll
   //    for (int r = c+1; r < 6; r ++){s_Ia[rc_Ind(r,c,6)] = s_Ia[rc_Ind(c,r,6)];}
   // }
}

//-------------------------------------------------------------------------------
// Helper Function for Coordinate Transform of Articulated Inertia for Revolute Joint
//-------------------------------------------------------------------------------

//
// These voids perform the coordinate transform of a spatial articulated
// inertia, in the special case of a mass-less handle (see chapter 7 of the RBDA
// book, s7.2.2, equation 7.23)
//
// Two specialized voids are available for the two cases of revolute and
// prismatic joint (which connects the subtree with the mass-less handle), since
// the inertia exhibits two different sparsity patterns.
//
// In:  Ia_A the articulated inertia in A coordinates
// In:  XM a spatial coordinate transform for motion vectors, in the form A_XM_B
//      (that is, mapping forces from A to B coordinates)
// Out: Ia_B the same articulated inertia, but expressed in B
//      coordinates. Note that the constness is casted away (trick required
//      with Eigen)
//
// -- RobCoGen
//
template <typename T>
void ctransform_Ia_revolute(T *Ilam, T *Ia, T *XM, T *temp = nullptr){
   // Get the coefficients of the 3x3 rotation matrix B_E_A
   // It is the transpose of the angular-angular block of the spatial transform
   T E[9];
   E[rcJ_IndCpp(1,1,3)] = XM[rcJ_IndCpp(1,1,6)];
   E[rcJ_IndCpp(1,2,3)] = XM[rcJ_IndCpp(2,1,6)];
   E[rcJ_IndCpp(1,3,3)] = XM[rcJ_IndCpp(3,1,6)];
   E[rcJ_IndCpp(2,1,3)] = XM[rcJ_IndCpp(1,2,6)];
   E[rcJ_IndCpp(2,2,3)] = XM[rcJ_IndCpp(2,2,6)];
   E[rcJ_IndCpp(2,3,3)] = XM[rcJ_IndCpp(3,2,6)];
   E[rcJ_IndCpp(3,1,3)] = XM[rcJ_IndCpp(1,3,6)];
   E[rcJ_IndCpp(3,2,3)] = XM[rcJ_IndCpp(2,3,6)];
   E[rcJ_IndCpp(3,3,3)] = XM[rcJ_IndCpp(3,3,6)];
   // Recover the translation vector.
   // The relative position 'r' of the origin of frame B wrt A (in A coordinates).
   // The vector is basically "reconstructed" from the matrix XF, which has
   // this form:
   //    | E   -E rx |
   //    | 0    E    |
   // where 'rx' is the cross product matrix. The strategy is to compute
   // E^T (-E rx) = -rx  , and then get the coordinates of 'r' from 'rx'.
   // This code is a manual implementation of the E transpose multiplication,
   // limited to the elements of interest.
   // Note that this is necessary because, currently, spatial transforms do
   // not carry explicitly the information about the translation vector.
   T rx = XM[rcJ_IndCpp(2,1,6)] * XM[rcJ_IndCpp(6,1,6)] + 
         XM[rcJ_IndCpp(2,2,6)] * XM[rcJ_IndCpp(6,2,6)] + 
         XM[rcJ_IndCpp(2,3,6)] * XM[rcJ_IndCpp(6,3,6)];
   T ry = XM[rcJ_IndCpp(3,1,6)] * XM[rcJ_IndCpp(4,1,6)] + 
         XM[rcJ_IndCpp(3,2,6)] * XM[rcJ_IndCpp(4,2,6)] + 
         XM[rcJ_IndCpp(3,3,6)] * XM[rcJ_IndCpp(4,3,6)];
   T rz = XM[rcJ_IndCpp(1,1,6)] * XM[rcJ_IndCpp(5,1,6)] + 
         XM[rcJ_IndCpp(1,2,6)] * XM[rcJ_IndCpp(5,2,6)] + 
         XM[rcJ_IndCpp(1,3,6)] * XM[rcJ_IndCpp(5,3,6)];
   
   // Angular-angular 3x3 sub-block:
   // compute  I + (Crx + Crx^T)  :
   // Remember that, for a revolute joint, the structure of the matrix is as
   //  follows (note the zeros):
   //    [ia1,  ia2,  0, ia4,  ia5,  ia6 ]
   //    [ia2,  ia7,  0, ia8,  ia9,  ia10]
   //    [0  ,    0,  0,   0,    0,    0 ]
   //    [ia4,  ia8,  0, ia11, ia12, ia13]
   //    [ia5,  ia9,  0, ia12, ia14, ia15]
   //    [ia6, ia10,  0, ia13, ia15, ia16]
   // copying the coefficients results in slightly fewer invocations of the
   //  operator(int,int), in the rest of the void
   T C[9];
   C[rcJ_IndCpp(1,1,3)] = Ia[rcJ_IndCpp(1,4,6)];
   C[rcJ_IndCpp(1,2,3)] = Ia[rcJ_IndCpp(1,5,6)];
   C[rcJ_IndCpp(1,3,3)] = Ia[rcJ_IndCpp(1,6,6)];
   C[rcJ_IndCpp(2,1,3)] = Ia[rcJ_IndCpp(2,4,6)];
   C[rcJ_IndCpp(2,2,3)] = Ia[rcJ_IndCpp(2,5,6)];
   C[rcJ_IndCpp(2,3,3)] = Ia[rcJ_IndCpp(2,6,6)];
   C[rcJ_IndCpp(3,1,3)] = static_cast<T>(0);
   C[rcJ_IndCpp(3,2,3)] = static_cast<T>(0);
   C[rcJ_IndCpp(3,3,3)] = static_cast<T>(0);

   T aux1[9];
   aux1[rcJ_IndCpp(1,1,3)] = Ia[rcJ_IndCpp(1,1,6)] + static_cast<T>(2)*C[rcJ_IndCpp(1,2,3)]*rz - 2*C[rcJ_IndCpp(1,3,3)]*ry;
   aux1[rcJ_IndCpp(2,2,3)] = Ia[rcJ_IndCpp(2,2,6)] + static_cast<T>(2)*C[rcJ_IndCpp(2,3,3)]*rx - 2*C[rcJ_IndCpp(2,1,3)]*rz;
   aux1[rcJ_IndCpp(1,2,3)] = Ia[rcJ_IndCpp(1,2,6)] + C[rcJ_IndCpp(2,2,3)]*rz - C[rcJ_IndCpp(1,1,3)]*rz - C[rcJ_IndCpp(2,3,3)]*ry + C[rcJ_IndCpp(1,3,3)]*rx;
   aux1[rcJ_IndCpp(1,3,3)] = C[rcJ_IndCpp(1,1,3)]*ry - C[rcJ_IndCpp(1,2,3)]*rx;
   aux1[rcJ_IndCpp(2,3,3)] = C[rcJ_IndCpp(2,1,3)]*ry - C[rcJ_IndCpp(2,2,3)]*rx;
   aux1[rcJ_IndCpp(2,1,3)] = static_cast<T>(0);
   aux1[rcJ_IndCpp(3,1,3)] = static_cast<T>(0);
   aux1[rcJ_IndCpp(3,2,3)] = static_cast<T>(0);
   aux1[rcJ_IndCpp(3,3,3)] = static_cast<T>(0);
   
   // compute (- rx M)  (note the minus)
   T M[9];
   M[rcJ_IndCpp(1,1,3)] = Ia[rcJ_IndCpp(4,4,6)];
   M[rcJ_IndCpp(1,2,3)] = Ia[rcJ_IndCpp(4,5,6)];
   M[rcJ_IndCpp(1,3,3)] = Ia[rcJ_IndCpp(4,6,6)];
   M[rcJ_IndCpp(2,1,3)] = Ia[rcJ_IndCpp(4,5,6)];
   M[rcJ_IndCpp(2,2,3)] = Ia[rcJ_IndCpp(5,5,6)];
   M[rcJ_IndCpp(2,3,3)] = Ia[rcJ_IndCpp(5,6,6)];
   M[rcJ_IndCpp(3,1,3)] = Ia[rcJ_IndCpp(4,6,6)];
   M[rcJ_IndCpp(3,2,3)] = Ia[rcJ_IndCpp(5,6,6)];
   M[rcJ_IndCpp(3,3,3)] = Ia[rcJ_IndCpp(6,6,6)];

   T rxM[9];
   rxM[rcJ_IndCpp(1,1,3)] = rz*M[rcJ_IndCpp(1,2,3)] - ry*M[rcJ_IndCpp(1,3,3)];
   rxM[rcJ_IndCpp(2,2,3)] = rx*M[rcJ_IndCpp(2,3,3)] - rz*M[rcJ_IndCpp(1,2,3)];
   rxM[rcJ_IndCpp(3,3,3)] = ry*M[rcJ_IndCpp(1,3,3)] - rx*M[rcJ_IndCpp(2,3,3)];
   rxM[rcJ_IndCpp(1,2,3)] = rz*M[rcJ_IndCpp(2,2,3)] - ry*M[rcJ_IndCpp(2,3,3)];
   rxM[rcJ_IndCpp(2,1,3)] = rx*M[rcJ_IndCpp(1,3,3)] - rz*M[rcJ_IndCpp(1,1,3)];
   rxM[rcJ_IndCpp(1,3,3)] = rz*M[rcJ_IndCpp(2,3,3)] - ry*M[rcJ_IndCpp(3,3,3)];
   rxM[rcJ_IndCpp(3,1,3)] = ry*M[rcJ_IndCpp(1,1,3)] - rx*M[rcJ_IndCpp(1,2,3)];
   rxM[rcJ_IndCpp(2,3,3)] = rx*M[rcJ_IndCpp(3,3,3)] - rz*M[rcJ_IndCpp(1,3,3)];
   rxM[rcJ_IndCpp(3,2,3)] = ry*M[rcJ_IndCpp(1,2,3)] - rx*M[rcJ_IndCpp(2,2,3)];

   // compute  (I + (Crx + Crx^T))  -  (rxM) rx
   aux1[rcJ_IndCpp(1,1,3)] += rxM[rcJ_IndCpp(1,2,3)]*rz - rxM[rcJ_IndCpp(1,3,3)]*ry;
   aux1[rcJ_IndCpp(2,2,3)] += rxM[rcJ_IndCpp(2,3,3)]*rx - rxM[rcJ_IndCpp(2,1,3)]*rz;
   aux1[rcJ_IndCpp(3,3,3)] += rxM[rcJ_IndCpp(3,1,3)]*ry - rxM[rcJ_IndCpp(3,2,3)]*rx;
   aux1[rcJ_IndCpp(1,2,3)] += rxM[rcJ_IndCpp(1,3,3)]*rx - rxM[rcJ_IndCpp(1,1,3)]*rz;
   aux1[rcJ_IndCpp(1,3,3)] += rxM[rcJ_IndCpp(1,1,3)]*ry - rxM[rcJ_IndCpp(1,2,3)]*rx;
   aux1[rcJ_IndCpp(2,3,3)] += rxM[rcJ_IndCpp(2,1,3)]*ry - rxM[rcJ_IndCpp(2,2,3)]*rx;

   // compute  E ( .. ) E^T
   T aux2[9];
   rot_symmetric_EAET(aux2,E,aux1);
   
   // Copy the result, angular-angular block of the output
   Ilam[rcJ_IndCpp(1,1,6)] += aux2[rcJ_IndCpp(1,1,3)];
   Ilam[rcJ_IndCpp(2,2,6)] += aux2[rcJ_IndCpp(2,2,3)];
   Ilam[rcJ_IndCpp(3,3,6)] += aux2[rcJ_IndCpp(3,3,3)];
   Ilam[rcJ_IndCpp(1,2,6)] += aux2[rcJ_IndCpp(1,2,3)];
   Ilam[rcJ_IndCpp(2,1,6)] += aux2[rcJ_IndCpp(1,2,3)];
   Ilam[rcJ_IndCpp(1,3,6)] += aux2[rcJ_IndCpp(1,3,3)];
   Ilam[rcJ_IndCpp(3,1,6)] += aux2[rcJ_IndCpp(1,3,3)];
   Ilam[rcJ_IndCpp(2,3,6)] += aux2[rcJ_IndCpp(2,3,3)];
   Ilam[rcJ_IndCpp(3,2,6)] += aux2[rcJ_IndCpp(2,3,3)];

   // Angular-linear block (and linear-angular block)
   // Calculate E ( C -rxM ) E^T
   //  - note that 'rxM' already contains the coefficients of  (- rx * M)
   //  - for a revolute joint, the last line of C is zero
   rxM[rcJ_IndCpp(1,1,3)] += C[rcJ_IndCpp(1,1,3)];
   rxM[rcJ_IndCpp(1,2,3)] += C[rcJ_IndCpp(1,2,3)];
   rxM[rcJ_IndCpp(1,3,3)] += C[rcJ_IndCpp(1,3,3)];
   rxM[rcJ_IndCpp(2,1,3)] += C[rcJ_IndCpp(2,1,3)];
   rxM[rcJ_IndCpp(2,2,3)] += C[rcJ_IndCpp(2,2,3)];
   rxM[rcJ_IndCpp(2,3,3)] += C[rcJ_IndCpp(2,3,3)];

   T aux3[9];
   rot_EAET(aux3,E,rxM);

   // copy the result, also to the symmetric 3x3 block
   Ilam[rcJ_IndCpp(1,4,6)] += aux3[rcJ_IndCpp(1,1,3)];
   Ilam[rcJ_IndCpp(1,5,6)] += aux3[rcJ_IndCpp(1,2,3)];
   Ilam[rcJ_IndCpp(1,6,6)] += aux3[rcJ_IndCpp(1,3,3)];
   Ilam[rcJ_IndCpp(2,4,6)] += aux3[rcJ_IndCpp(2,1,3)];
   Ilam[rcJ_IndCpp(2,5,6)] += aux3[rcJ_IndCpp(2,2,3)];
   Ilam[rcJ_IndCpp(2,6,6)] += aux3[rcJ_IndCpp(2,3,3)];
   Ilam[rcJ_IndCpp(3,4,6)] += aux3[rcJ_IndCpp(3,1,3)];
   Ilam[rcJ_IndCpp(3,5,6)] += aux3[rcJ_IndCpp(3,2,3)];
   Ilam[rcJ_IndCpp(3,6,6)] += aux3[rcJ_IndCpp(3,3,3)];

   Ilam[rcJ_IndCpp(4,1,6)] += aux3[rcJ_IndCpp(1,1,3)];
   Ilam[rcJ_IndCpp(5,1,6)] += aux3[rcJ_IndCpp(1,2,3)];
   Ilam[rcJ_IndCpp(6,1,6)] += aux3[rcJ_IndCpp(1,3,3)];
   Ilam[rcJ_IndCpp(4,2,6)] += aux3[rcJ_IndCpp(2,1,3)];
   Ilam[rcJ_IndCpp(5,2,6)] += aux3[rcJ_IndCpp(2,2,3)];
   Ilam[rcJ_IndCpp(6,2,6)] += aux3[rcJ_IndCpp(2,3,3)];
   Ilam[rcJ_IndCpp(4,3,6)] += aux3[rcJ_IndCpp(3,1,3)];
   Ilam[rcJ_IndCpp(5,3,6)] += aux3[rcJ_IndCpp(3,2,3)];
   Ilam[rcJ_IndCpp(6,3,6)] += aux3[rcJ_IndCpp(3,3,3)];

   // Linear-linear block
   rot_symmetric_EAET(aux1,E,M);

   Ilam[rcJ_IndCpp(4,4,6)] += aux1[rcJ_IndCpp(1,1,3)];
   Ilam[rcJ_IndCpp(5,5,6)] += aux1[rcJ_IndCpp(2,2,3)];
   Ilam[rcJ_IndCpp(6,6,6)] += aux1[rcJ_IndCpp(3,3,3)];
   
   Ilam[rcJ_IndCpp(4,5,6)] += aux1[rcJ_IndCpp(1,2,3)];
   Ilam[rcJ_IndCpp(4,6,6)] += aux1[rcJ_IndCpp(1,3,3)];
   Ilam[rcJ_IndCpp(5,6,6)] += aux1[rcJ_IndCpp(2,3,3)];

   Ilam[rcJ_IndCpp(5,4,6)] += aux1[rcJ_IndCpp(1,2,3)];
   Ilam[rcJ_IndCpp(6,4,6)] += aux1[rcJ_IndCpp(1,3,3)];
   Ilam[rcJ_IndCpp(6,5,6)] += aux1[rcJ_IndCpp(2,3,3)];
}

template <typename T>
void initI(T *s_I){initInertiaTensors(s_I);}

template <typename T>
void initT(T *s_T){initMotionTransforms(s_T);}

//----------------------------------------------------------------------------
// RNEA Helpers
//----------------------------------------------------------------------------
template <typename T, bool MPC_MODE = false>
void RNEA_fp_old(T *s_v, T *s_a, T *s_f, T *s_I, T *s_T, T *s_qd, T *s_temp, T *s_qdd = nullptr, T *s_fext = nullptr){
   for (int k = 0; k < NUM_POS; k++){
      T *lk_v = &s_v[6*k];    T *lk_a = &s_a[6*k];    T *tkXkm1 = &s_T[36*k];
      if (k == 0){
         // l1_v = vJ, for the first link of a fixed base robot
         for(int i = 0; i < 6; i++){lk_v[i] = (i == 2) ? s_qd[k] : 0;}            
         // and the a is just gravity times the last col of the transform and then add qdd in 3rd entry
         for(int i = 0; i < 6; i++){
               lk_a[i] = MPC_MODE ? static_cast<T>(0) : tkXkm1[6*5+i] * GRAVITY; // MPC with arm has gravity comp so need to pretend gravity is 0
               if(i == 2 && s_qdd != nullptr){lk_a[i] += s_qdd[k];}
         } 
      }
      else{
         T *lkm1_v = &s_v[6*(k-1)];    T *lkm1_a = &s_a[6*(k-1)];
         // first compute the v
         matVMult<T,6,6,0>(lk_v,tkXkm1,6,lkm1_v);
         // then the a
         motionCrossProductMxCol3<T>(lk_a,lk_v,s_qd[k]); // motion cross product 3rd col of lk_v mulitplied by qd[1] and add in qd into 2
         matVMult<T,6,6,1>(lk_a,tkXkm1,6,lkm1_a); // so now we += that with tkXkm1 * lkm1_a
         if(s_qdd != nullptr){lk_a[2] += s_qdd[k];}
      }

      // then the f
      T *lk_f = &s_f[6*k];    T *lk_I = &s_I[36*k];
      vxIv<T>(lk_f,lk_v,lk_I); // compute the vxIv of lk_v and lk_I and store in lk_f
      matVMult<T,6,6,1>(lk_f,lk_I,6,lk_a); // then += that with lk_I * lk_a
      if(s_fext != nullptr){
         T *fext_lk = &s_fext[6*k];
         vecAdd<T,6>(lk_f,fext_lk,static_cast<T>(-1)); // then subtract the external force
      }
   }
}

template <typename T>
void RNEA_bp_old(T *s_tau, T *s_f, T *s_T){
   for (int k = NUM_POS - 1; k >= 0; k--){
      T *lk_f = &s_f[6*k];     if(s_tau != nullptr){s_tau[k] = lk_f[2];}
      if(k > 0){
         T *lkm1_f = &s_f[6*(k-1)];     T *tkXkm1 = &s_T[36*k];
         matVMult<T,6,6,1,1>(lkm1_f,tkXkm1,6,lk_f); // lkm1_f += tkXkm1^T * lk_f
      }
   }
}

template <typename T, bool MPC_MODE = false>
void RNEA_fp(T *s_v, T *s_a, T *s_f, T *s_I, T *s_T, T *s_qd, T *s_temp, T *s_qdd = nullptr, T *s_fext = nullptr){
   for (int k = 0; k < NUM_POS; k++){
      T *lk_v = &s_v[6*k];    T *lk_a = &s_a[6*k];    T *tkXkm1 = &s_T[36*k];
      if (k == 0){
         // l1_v = vJ, for the first link of a fixed base robot
         for(int i = 0; i < 6; i++){lk_v[i] = (i == 2) ? s_qd[k] : 0;}            
         // and the a is just gravity times the last col of the transform and then add qdd in 3rd entry
         for(int i = 0; i < 6; i++){
               lk_a[i] = MPC_MODE ? static_cast<T>(0) : tkXkm1[6*5+i] * GRAVITY; // MPC with arm has gravity comp so need to pretend gravity is 0
               if(i == 2 && s_qdd != nullptr){lk_a[i] += s_qdd[k];}
         } 
      }
      else{
         T *lkm1_v = &s_v[6*(k-1)];    T *lkm1_a = &s_a[6*(k-1)];
         // first compute the v
         matVMult_Tmat<T,0,0>(lk_v,tkXkm1,lkm1_v);
         // then the a
         motionCrossProductMxCol3<T>(lk_a,lk_v,s_qd[k]); // motion cross product 3rd col of lk_v mulitplied by qd[1] and add in qd into 2
         matVMult_Tmat<T,1,0>(lk_a,tkXkm1,lkm1_a); // so now we += that with tkXkm1 * lkm1_a
         if(s_qdd != nullptr){lk_a[2] += s_qdd[k];}
      }

      // then the f
      T *lk_f = &s_f[6*k];    T *lk_I = &s_I[36*k];
      vxIv<T>(lk_f,lk_v,lk_I); // compute the vxIv of lk_v and lk_I and store in lk_f
      matVMult<T,6,6,1>(lk_f,lk_I,6,lk_a); // then += that with lk_I * lk_a
      if(s_fext != nullptr){
         T *fext_lk = &s_fext[6*k];
         vecAdd<T,6>(lk_f,fext_lk,static_cast<T>(-1)); // then subtract the external force
      }
   }
}

template <typename T>
void RNEA_bp(T *s_tau, T *s_f, T *s_T){
   for (int k = NUM_POS - 1; k >= 0; k--){
      T *lk_f = &s_f[6*k];     if(s_tau != nullptr){s_tau[k] = lk_f[2];}
      if(k > 0){
         T *lkm1_f = &s_f[6*(k-1)];     T *tkXkm1 = &s_T[36*k];
         matVMult_Tmat<T,1,1>(lkm1_f,tkXkm1,lk_f); // lkm1_f += tkXkm1^T * lk_f
      }
   }
}

//-------------------------------------------------------------------------------
// M inverse helpers
//-------------------------------------------------------------------------------
template <typename T>
void bwdPassMinvFUpdate(T *s_Minv, T *Fi, T *Flami, T *iXlami, T *Ui, T Dinvi, int li){
   bool has_parent = li > 0; int num_children = 6 - li; 
   // (21) Minv[i,i] = Di^-1
   s_Minv[rc_Ind(li,li,NUM_POS)] = Dinvi;
   // (12) Minv[i,subtree(i)] = -Di^-T * SiT * Fi[:,subtree(i)]
   if (num_children > 0){
      #pragma unroll
      for(int i = 0; i < num_children; i++){
         s_Minv[rc_Ind(li,(li+1+i),NUM_POS)] = -Dinvi * Fi[rc_Ind(2,(li+1+i),6)];
      }
   }
   // (14)    Fi[:,subtree(i)] = Ui * Minv[i,subtree(i)]
   // (15)    Flami[:,subtree(i)] = Flami[:,subtree(i)] + lamiXi* * Fi[:,subtree(i)]
   // or we do the following if there is no children then c = 0
   // (19)    Flami[:,i] += lamiXi* * Ui * Minv[i,i]
   #pragma unroll
   for(int c = 0; c <= num_children; c++){
      T Minvc = s_Minv[rc_Ind(li,(li+c),NUM_POS)]; T *Fic = &Fi[rc_Ind(0,(li+c),6)];
      #pragma unroll
      for(int r = 0; r < 6; r++){Fic[r] += Ui[r] * Minvc;}
   }
   // if has parent need to transform and add Fi to Flami
   if (has_parent){iteratedMatVMult<T,6,6,1,1>(Flami,6,iXlami,6,Fi,6,7);}
}

template <typename T>
void bwdPassIUpdate(T *Ilam, T *I, T *Ia, T *X, T *U, T Dinv, int li, T *s_temp = nullptr){
   bool has_parent = li > 0;
   if (has_parent){
      compute_Ia_revolute(Ia, I, U, Dinv); // same as: Ia_r = AI_l7 - U_l7/D_l7 * U_l7.transpose()
      ctransform_Ia_revolute(Ilam, Ia, X);
   }
}

template <typename T>
void Minv_bp(T *s_Minv, T *s_F, T *s_I, T *s_T, T *s_U, T *s_D, T *s_Ia, T *s_temp = nullptr){
   for (int k = NUM_POS - 1; k>=0; k--){
      T *Uk = &s_U[k*6];            T *Dk = &s_D[2*k];               T *Tk = &s_T[36*k];
      T *Ik = &s_I[36*k];           T *Ilamk = &s_I[36*(k-1)];
      T *Fk = &s_F[6*NUM_POS*k];    T *Flamk = &s_F[6*NUM_POS*(k-1)];
      // get Uk and Dk
      #pragma unroll
      for(int i = 0; i < 6; i ++){Uk[i] = Ik[6*2+i]; if(i == 2){Dk[0] = Uk[i]; Dk[1] = 1/Dk[0];}}
      // update Minv and F
      bwdPassMinvFUpdate(s_Minv,Fk,Flamk,Tk,Uk,Dk[1],k);
      // update Ilamk -- note: this is an independent operation from the F and Minv updates
      bwdPassIUpdate(Ilamk,Ik,s_Ia,Tk,Uk,Dk[1],k,s_temp);
   }
}

// need T s_temp[6]
template <typename T>
void fwdPassUpdate(T *s_Minv, T *s_Fi, T *s_Flami, T *iXlami, T *Ui, T Dinvi, T *s_temp, int li){
   // we have all rotational joints so Si = [0,0,1,0,0,0]
   bool has_parent = (li > 0);         T *Minv_subtree = &s_Minv[NUM_POS*li + li]; 
   T *Fi_subtree = &s_Fi[6*li];        T *Flami_subtree = &s_Flami[6*li];              int N_subtree = NUM_POS-li;
   if (has_parent){
      // (30) Minv[i,subtree(i)] += -D^-1 * Ui^T * iXlami * Flami[:,subtree(i)]
      // Ui^T * iXlami = (iXlami^T * Ui)^T
      matVMult<T,6,6,0,1>(s_temp,iXlami,6,Ui);
      // again we employ the transpose trick where subtree(i) is li to 6 (base 0) so 7-li rows
      // and we only compute one row of length 7-li and stride with 1
      iteratedMatVMult<T,1,6,1,1>(Minv_subtree,NUM_POS,s_temp,1,Flami_subtree,6,N_subtree,-Dinvi);
   }
   // (32) Fi = Si * Minv[i,subtree(i)]
   // we have all rotational joints so Si = [0,0,1,0,0,0]
   for(int i = 0; i < N_subtree; i++){
      for(int j = 0; j < 6; j++){
         Fi_subtree[6*i+j] = (j == 2) ? Minv_subtree[NUM_POS*i] : static_cast<T>(0);
      }
   }
   // (34) Fi[:,subtree(i)] += iXlami * Flami[:,subtree(i)]
   if (has_parent){iteratedMatVMult<T,6,6,1>(Fi_subtree,6,iXlami,6,Flami_subtree,6,N_subtree);}
}
template <typename T>
void Minv_fp(T *s_Minv, T *s_F, T *s_T, T *s_U, T *s_D, T *s_temp){
   for (int k = 0; k < NUM_POS; k++){
      T *Uk = &s_U[k*6];            T *Dk = &s_D[2*k];               T *Tk = &s_T[36*k];
      T *Fk = &s_F[6*NUM_POS*k];    T *Flamk = &s_F[6*NUM_POS*(k-1)];
      fwdPassUpdate(s_Minv,Fk,Flamk,Tk,Uk,Dk[1],s_temp,k);
   }
}

//-------------------------------------------------------------------------------
// FD Helpers and Compute
//-------------------------------------------------------------------------------

template <typename T, bool MPC_MODE = false, bool VEL_DAMPING = true>
void FD_helpersCPU(T *s_Minv, T *s_F, T *s_bias, T *s_tau, T *s_v, T *s_a, T *s_f, T *s_qd, T *s_I, T *s_IA, T *s_Ia, T *s_T, T *s_U, T *s_D, T *s_temp, T *s_fext = nullptr, T *s_qdd = nullptr){
   // in CPU mode the number of syncs doesn't matter as it will all be done serially anyway so we
   // can just re-use the functions from RNEA and Minv
   Minv_bp<T>(s_Minv,s_F,s_IA,s_T,s_U,s_D,s_Ia,s_temp);
   Minv_fp<T>(s_Minv,s_F,s_T,s_U,s_D,s_temp);
   RNEA_fp<T,MPC_MODE>(s_v, s_a, s_f, s_I, s_T, s_qd, s_temp, s_qdd, s_fext); // we leave room to use in gradient with a qdd passed in to compute grad bias
   RNEA_bp<T>(s_temp,s_f,s_T);
   // c now in temp so compute bias term (tau-c)
   #pragma unroll
   for (int k = 0; k < NUM_POS; k++){
      if(VEL_DAMPING){s_bias[k] = s_tau[k] - (s_temp[k] + 0.5*s_qd[k]);}
      else{s_bias[k] = s_tau[k] - s_temp[k];}
   }
}

template <typename T, bool MPC_MODE = false, bool VEL_DAMPING = true>
void forwardDynamics(T *s_qdd, T *s_tau, T *s_qd, T *s_q, T *d_I, T *d_T, T *d_Minv, T *s_fext = nullptr){
   T s_v[6*NUM_POS];
   T s_a[6*NUM_POS];
   T s_f[6*NUM_POS];
   T s_F[6*NUM_POS*NUM_POS];
   T s_U[6*NUM_POS];
   T s_D[2*NUM_POS]; // also store 1/Di
   T s_IA[36*NUM_POS];
   T s_T[36*NUM_POS];
   T s_sinq[NUM_POS];
   T s_cosq[NUM_POS];
   T s_Ia[36];
   T s_temp[42];
   T s_bias[NUM_POS];
   // build transforms for this configuration
   #pragma unroll
   for (int ind = 0; ind < NUM_POS; ind++){s_sinq[ind] = std::sin(s_q[ind]); s_cosq[ind] = std::cos(s_q[ind]);}
   buildTransforms(s_T,s_sinq,s_cosq);
   // and clear things for Minv and F in either case
   zeroSharedMem<T,NUM_POS*NUM_POS>(d_Minv);
   zeroSharedMem<T,6*NUM_POS*NUM_POS>(s_F);
   // and copy from d_I to s_IA as we will modify it and don't want to change d_I because we will be actively using it
   copyMat<T,36,NUM_POS>(s_IA,d_I,36,36);
   // then compute Minv and bias
   FD_helpersCPU<T,MPC_MODE,VEL_DAMPING>(d_Minv,s_F,s_bias,s_tau,s_v,s_a,s_f,s_qd,d_I,s_IA,s_Ia,s_T,s_U,s_D,s_temp,s_fext);
   // now we have an upper trainagular matrix in Minv (because symmetric) and the bias term
   // we now need to computer qdd = Minv*bias
   matVMultSym<T,NUM_POS,NUM_POS>(s_qdd,d_Minv,NUM_POS,s_bias);
}

template <typename T, bool MPC_MODE = false, bool VEL_DAMPING = true>
void forwardDynamics4x4(T *s_qdd, T *s_tau, T *s_qd, T *s_q, T *d_I, T *s_Tb4, T *d_Minv, T *s_fext = nullptr){
   T s_v[6*NUM_POS];
   T s_a[6*NUM_POS];
   T s_f[6*NUM_POS];
   T s_F[6*NUM_POS*NUM_POS];
   T s_U[6*NUM_POS];
   T s_D[2*NUM_POS]; // also store 1/Di
   T s_IA[36*NUM_POS];
   T s_T[36*NUM_POS];
   T s_sinq[NUM_POS];
   T s_cosq[NUM_POS];
   T s_Ia[36];
   T s_temp[42];
   T s_bias[NUM_POS];
   // update transforms for this configuration by constructing 4x4s we need for later and then using 6x6s here
   #pragma unroll
   for (int ind = 0; ind < NUM_POS; ind++){s_sinq[ind] = std::sin(s_q[ind]); s_cosq[ind] = std::cos(s_q[ind]);}
   buildTransforms4x4(s_Tb4,s_sinq,s_cosq);
   updateTransforms4x4to6x6_v2(s_T,s_Tb4);
   // and clear things for Minv and F in either case
   zeroSharedMem<T,NUM_POS*NUM_POS>(d_Minv);
   zeroSharedMem<T,6*NUM_POS*NUM_POS>(s_F);
   // and copy from d_I to s_IA as we will modify it and don't want to change d_I because we will be actively using it
   copyMat<T,36,NUM_POS>(s_IA,d_I,36,36);
   // then compute Minv and bias
   FD_helpersCPU<T,MPC_MODE,VEL_DAMPING>(d_Minv,s_F,s_bias,s_tau,s_v,s_a,s_f,s_qd,d_I,s_IA,s_Ia,s_T,s_U,s_D,s_temp,s_fext);
   // now we have an upper trainagular matrix in Minv (because symmetric) and the bias term
   // we now need to computer qdd = Minv*bias
   matVMultSym<T,NUM_POS,NUM_POS>(s_qdd,d_Minv,NUM_POS,s_bias);
}

//-------------------------------------------------------------------------------
// FD Gradient Helpers and Compute
//-------------------------------------------------------------------------------

template <typename T>
void computeFxMatTimesVector(T *dstVec, T *srcFxVec, T *srcVec){
   // dstVec = Fx(srxFxVec)*srcVec
   /* 0  -v(2)  v(1)    0  -v(5)  v(4)
    v(2)    0  -v(0)  v(5)    0  -v(3)
   -v(1)  v(0)    0  -v(4)  v(3)    0
     0     0      0     0  -v(2)  v(1)
     0     0      0   v(2)    0  -v(0)
     0     0      0  -v(1)  v(0)    0 */
   dstVec[0] = -srcFxVec[2] * srcVec[1] + srcFxVec[1] * srcVec[2] - srcFxVec[5] * srcVec[4] + srcFxVec[4] * srcVec[5];
   dstVec[1] =  srcFxVec[2] * srcVec[0] - srcFxVec[0] * srcVec[2] + srcFxVec[5] * srcVec[3] - srcFxVec[3] * srcVec[5];
   dstVec[2] = -srcFxVec[1] * srcVec[0] + srcFxVec[0] * srcVec[1] - srcFxVec[4] * srcVec[3] + srcFxVec[3] * srcVec[4];
   dstVec[3] =                                                     -srcFxVec[2] * srcVec[4] + srcFxVec[1] * srcVec[5];
   dstVec[4] =                                                      srcFxVec[2] * srcVec[3] - srcFxVec[0] * srcVec[5];
   dstVec[5] =                                                     -srcFxVec[1] * srcVec[3] + srcFxVec[0] * srcVec[4];
}

template <typename T>
void compute_vafdu_old(T *s_fdq, T *s_fdqd, T *s_adq, T *s_adqd, T *s_vdq, T *s_vdqd, T *s_f, T *s_a, T *s_v, T *s_qd, T *s_T, T *s_I){
   // taking advantage of sparsity allows us to not try to multiply cols we know are zeros
   // (note that dq and dqd are independent so can walk the tree simulatenously)
   for (int k = 0; k < NUM_POS; k++){
      // dVk/dq has the pattern [0 | Tk*dvlank/dq for 1:k-1 cols | MxMat_col3(Tk*vlamk) | 0 for k+1 to NUM_POS col]
      // dak/du = Tk * dalamk/du + MxMatCol3_oncols(dvk/du)*qd[k] + {for q in col k: MxMatCol3(Tk*alamk)}
      // dVk/dqd has the pattern [Tk*dvlamk/dqd for 0:k-2 cols | Tk[:,2] for k-1 col | [0 0 1 0 0 0]T for k col | 0 for k+1 to NUM_POS col]
      // dak/du = Tk * dalamk/du + MxMatCol3_oncols(dvk/du)*qd[k] + {for qd in col k: MxMatCol3(vk)}
      // dfk/du = Ik*dak/du + FxMat(vk)*Ik*dvk/du + FxMat(dvk/du across cols)*Ik*vk
      T *vk = &s_v[6*k]; T *vlamk = &s_v[6*(k-1)]; T *alamk = &s_a[6*(k-1)]; T *Tk = &s_T[36*k]; T *Ik = &s_I[36*k];
      // note that we need just one FxvIk and Ivk so lets compute those outside of the column loop
      T Ivk[] = {0,0,0,0,0,0}; for (int r = 0; r < 6; r++){for(int i = 0; i < 6; i++){Ivk[r] += Ik[r + 6 * i] * vk[i];}}
      T FxvIk[36]; for (int c = 0; c < 6; c++){computeFxMatTimesVector<T>(&FxvIk[c*6],vk,&Ik[c*6]);}
      for (int c = 0; c <= k; c++){
         T *vdqkc = &s_vdq[3*k*(k+1) + 6*c];       T *adqkc = &s_adq[3*k*(k+1) + 6*c];
         T *vdqlamkc = &s_vdq[3*k*(k-1) + 6*c];    T *adqlamkc = &s_adq[3*k*(k-1) + 6*c];
         T *vdqdkc = &s_vdqd[3*k*(k+1) + 6*c];     T *adqdkc = &s_adqd[3*k*(k+1) + 6*c];
         T *vdqdlamkc = &s_vdqd[3*k*(k-1) + 6*c];  T *adqdlamkc = &s_adqd[3*k*(k-1) + 6*c];
         T *fdqkc = &s_fdq[6*NUM_POS*k + 6*c];     T *fdqdkc = &s_fdqd[6*NUM_POS*k + 6*c];
         for (int r = 0; r < 6; r++){
            T valvq = static_cast<T>(0); T valvqd = static_cast<T>(0); T valaq = static_cast<T>(0); T valaqd = static_cast<T>(0);
            if (c < k){ //dlam only exists for c < k
               #pragma unroll
               for(int i = 0; i < 6; i++){T Tcurr = Tk[r + 6 * i]; valvq += Tcurr * vdqlamkc[i]; valaq += Tcurr * adqlamkc[i]; valaqd += Tk[r + 6 * i] * adqdlamkc[i]; if(c != k-1){valvqd += Tcurr * vdqdlamkc[i];}} 
               if (c == k-1){valvqd += Tk[2*6+r];} // since the multiplication is by [0 0 1 0 0 0] just take the 3rd column
            }
            else if (c == k){
               if(k > 0){valvq += MxMatCol3<T>(r,vlamk,Tk); valaq += MxMatCol3<T>(r,alamk,Tk);}
               if (r == 2){valvqd = static_cast<T>(1);} valaqd += MxMatCol3<T>(r,vk);
            }
            vdqkc[r] = valvq; vdqdkc[r] = valvqd; adqkc[r] = valaq; adqdkc[r] = valaqd;
         }
         // we need to wait for all of v to finish before starting f and finishing a
         computeFxMatTimesVector<T>(fdqkc,vdqkc,Ivk); computeFxMatTimesVector<T>(fdqdkc,vdqdkc,Ivk);
         for (int r = 0; r < 6; r++){
            T valfq = static_cast<T>(0); T valfqd = static_cast<T>(0);
            #pragma unroll
            for(int i = 0; i < 6; i++){T FxvIkcurr = FxvIk[r + 6 * i]; valfq += FxvIkcurr * vdqkc[i]; valfqd += FxvIkcurr * vdqdkc[i];}
               fdqkc[r] += valfq; fdqdkc[r] += valfqd;
         }
         for (int r = 0; r < 6; r++){adqkc[r] += MxMatCol3<T>(r,vdqkc) * s_qd[k]; adqdkc[r] += MxMatCol3<T>(r,vdqdkc) * s_qd[k];}
         // then we can finish f using a
         for (int r = 0; r < 6; r++){
            T valfq = static_cast<T>(0); T valfqd = static_cast<T>(0);
            #pragma unroll
            for(int i = 0; i < 6; i++){T Icurr = Ik[r + 6 * i]; valfq += Icurr * adqkc[i]; valfqd += Icurr * adqdkc[i];}
            fdqkc[r] += valfq; fdqdkc[r] += valfqd;
         }
      }
   }  
}

template <typename T, bool VEL_DAMPING = 1>
void compute_cdu_old(T *s_cdq, T *s_cdqd, T *s_fdq, T *s_fdqd, T *s_T, T *s_f){
   // taking advantage of sparsity allows us to not try to multiply cols we know are zeros
   // (note that dq and dqd are independent so can walk the tree simulatenously)
   for (int k = NUM_POS - 1; k >= 0; k--){
      T *Tk = &s_T[36*k]; T *fk = &s_f[6*k];
      for (int c = 0; c < NUM_POS; c++){
         T *fdqkc = &s_fdq[6*NUM_POS*k + 6*c];        T *fdqdkc = &s_fdqd[6*NUM_POS*k + 6*c];
         T *fdqlamkc = &s_fdq[6*NUM_POS*(k-1) + 6*c]; T *fdqdlamkc = &s_fdqd[6*NUM_POS*(k-1) + 6*c];
         for (int r = 0; r < 6; r++){
            // dc/du = row 3 of df so extract that and then updatre prev f (if not k == 0)
            if (r == 2){
               s_cdq[NUM_POS*c + k] = fdqkc[r]; s_cdqd[NUM_POS*c + k] = fdqdkc[r];
               if(VEL_DAMPING && (c == k)){s_cdqd[NUM_POS*c + k] += 0.5;}
            }
            if (k > 0){
               // dflamk/du += Tk^T*cols(df/du)
               T valq = static_cast<T>(0); T valqd = static_cast<T>(0); T *Tkc = &Tk[r * 6]; // we are using Tk^T so need column r
               #pragma unroll
               for(int i = 0; i < 6; i++){T Tcurr = Tkc[i]; valq += Tcurr * fdqkc[i]; valqd += Tcurr * fdqdkc[i];}
               // if c = k += Tk^T*Fx3(fk)
               if (c == k){valq += -fk[1]*Tkc[0] + fk[0]*Tkc[1] - fk[4]*Tkc[3] + fk[3]*Tkc[4];}
               // += if c <= k else set because currently unfilled
               if (c < k){fdqlamkc[r] += valq; fdqdlamkc[r] += valqd;}
               else {fdqlamkc[r] = valq; fdqdlamkc[r] = valqd;}
            }
         }
      }  
   }
}


template <typename T, bool VEL_DAMPING = 1>
void inverseDynamicsGradient_old(T *s_cdq, T *s_cdqd, T *s_qd, T *s_v, T *s_a, T *s_f, T *s_I, T *s_T, int k = 0){
   T s_vdq[3*NUM_POS*(NUM_POS+1)];  T s_vdqd[3*NUM_POS*(NUM_POS+1)];
   T s_adq[3*NUM_POS*(NUM_POS+1)];  T s_adqd[3*NUM_POS*(NUM_POS+1)];
   T s_fdq[6*NUM_POS*NUM_POS];      T s_fdqd[6*NUM_POS*NUM_POS];
   compute_vafdu_old(s_fdq,s_fdqd,s_adq,s_adqd,s_vdq,s_vdqd,s_f,s_a,s_v,s_qd,s_T,s_I);
   compute_cdu_old<T,VEL_DAMPING>(s_cdq,s_cdqd,s_fdq,s_fdqd,s_T,s_f);
}

template <typename T>
void setToS(T *v){v[0] = static_cast<T>(0); v[1] = static_cast<T>(0); v[2] = static_cast<T>(1); v[3] = static_cast<T>(0); v[4] = static_cast<T>(0); v[5] = static_cast<T>(0);}

template <typename T>
void compute_vafdu(T *s_fdq, T *s_fdqd, T *s_adq, T *s_adqd, T *s_vdq, T *s_vdqd, T *s_f, T *s_a, T *s_v, T *s_qd, T *s_T, T *s_I){
   // compute_vafdu(s_fdq,s_fdqd,s_adq,s_adqd,s_vdq,s_vdqd,s_f,s_a,s_v,s_qd,s_T,s_I);
   // taking advantage of sparsity allows us to not try to multiply cols we know are zeros
   // (note that dq and dqd are independent so can walk the tree simulatenously)
   for (int k = 0; k < NUM_POS; k++){
      T *vk = &s_v[6*k]; T *vlamk = &s_v[6*(k-1)]; T *alamk = &s_a[6*(k-1)]; T *Tk = &s_T[36*k]; T *Ik = &s_I[36*k];
      // note that we need just one FxvIk and Ivk so lets compute those outside of the column loop
      T Ivk[6]; matVMult<T,6,6>(Ivk,Ik,6,vk); T FxvIk[36]; for (int c = 0; c < 6; c++){computeFxMatTimesVector<T>(&FxvIk[c*6],vk,&Ik[c*6]);}
      for (int c = 0; c <= k; c++){int indkc = 3*k*(k+1) + 6*c; int indlamkc = indkc - 6*k; int indkc6 = 6*NUM_POS*k + 6*c;
         // for dq all of the first col is 0 identically so this skips k == 0 so lam always exists
         if (c > 0){
            // dVk/dq has the pattern [0 | Tk*dvlamk/dq for 1:k-1 cols | MxMat_col3(Tk*vlamk) | 0 for k+1 to NUM_POS col]
            if (c < k){matVMult_Tmat<T,0,0>(&s_vdq[indkc],Tk,&s_vdq[indlamkc]);}
            else {MxMatCol3_Tmat<T>(&s_vdq[indkc],Tk,vlamk);}
            // dak/dq = Tk * dalamk/du + MxMatCol3_oncols(dvk/du)*qd[k] + {for q in col k: MxMatCol3(Tk*alamk)}
            MxMatCol3(&s_adq[indkc],&s_vdq[indkc],s_qd[k]);
            if (c < k){matVMult_Tmat<T,1,0>(&s_adq[indkc],Tk,&s_adq[indlamkc]);}
            else if(c == k){MxMatCol3_Tmat<T,1>(&s_adq[indkc],Tk,alamk);}
            // dfk/dq = Ik*dak/dq + FxMat(vk)*Ik*dvk/dq + FxMat(dvk/dq across cols)*Ik*vk
            computeFxMatTimesVector<T>(&s_fdq[indkc6],&s_vdq[indkc],Ivk);
            matVMult<T,6,6,1>(&s_fdq[indkc6],Ik,6,&s_adq[indkc]);
            matVMult<T,6,6,1>(&s_fdq[indkc6],FxvIk,6,&s_vdq[indkc]);

         }
         // but load the 0 into f for the backward pass
         else{
            #pragma unroll
            for(int i = 0; i < 6; i++){s_fdq[indkc6 + i] = static_cast<T>(0);}

         }
         // then dqd where the first col has values
         // dVk/dqd has the pattern [Tk*dvlamk/dqd for 0:k-2 cols | Tk[:,2] for k-1 col | [0 0 1 0 0 0]T for k col | 0 for k+1 to NUM_POS col]
         if (c < k-1){matVMult_Tmat<T,0,0>(&s_vdqd[indkc],Tk,&s_vdqd[indlamkc]);}
         else if (c == k-1){std::memcpy(&s_vdqd[indkc],&Tk[12],6*sizeof(T));}
         else{setToS<T>(&s_vdqd[indkc]);}
         // dak/dqd = Tk * dalamk/du + MxMatCol3_oncols(dvk/du)*qd[k] + {for qd in col k: MxMatCol3(vk)}
         MxMatCol3<T>(&s_adqd[indkc],&s_vdqd[indkc],s_qd[k]);
         if (c < k){matVMult_Tmat<T,1,0>(&s_adqd[indkc],Tk,&s_adqd[indlamkc]);}
         else if(c == k){MxMatCol3<T,1>(&s_adqd[indkc],vk);}
         // dfk/dqd = Ik*dak/dqd + FxMat(vk)*Ik*dvk/dqd + FxMat(dvk/dqd across cols)*Ik*vk
         computeFxMatTimesVector<T>(&s_fdqd[indkc6],&s_vdqd[indkc],Ivk);
         matVMult<T,6,6,1>(&s_fdqd[indkc6],Ik,6,&s_adqd[indkc]);
         matVMult<T,6,6,1>(&s_fdqd[indkc6],FxvIk,6,&s_vdqd[indkc]);
      }
   }
}

template <typename T, bool VEL_DAMPING = 1>
void compute_cdu(T *s_cdq, T *s_cdqd, T *s_fdq, T *s_fdqd, T *s_T, T *s_f){
   // taking advantage of sparsity allows us to not try to multiply cols we know are zeros
   // (note that dq and dqd are independent so can walk the tree simulatenously)
   for (int k = NUM_POS - 1; k >= 0; k--){
      T *Tk = &s_T[36*k]; T *fk = &s_f[6*k];
      for (int c = 0; c < NUM_POS; c++){int indkc = 6*NUM_POS*k + 6*c; int indlamkc = indkc - 6*NUM_POS;
         // dc/du = row 3 of df so extract that
         s_cdq[NUM_POS*c + k] = s_fdq[indkc + 2]; s_cdqd[NUM_POS*c + k] = s_fdqd[indkc + 2];
         if(VEL_DAMPING && (c == k)){s_cdqd[NUM_POS*c + k] += 0.5;}
         // then updatre prev f (if not k == 0)
         if (k > 0){
            // dflamk/du += Tk^T*cols(df/du) -- note if c >= k need to set = because not set yet
            if (c < k){
               matVMult_Tmat<T,1,1>(&s_fdq[indlamkc],Tk,&s_fdq[indkc]);
               matVMult_Tmat<T,1,1>(&s_fdqd[indlamkc],Tk,&s_fdqd[indkc]);
            }
            else{
               matVMult_Tmat<T,0,1>(&s_fdq[indlamkc],Tk,&s_fdq[indkc]);
               matVMult_Tmat<T,0,1>(&s_fdqd[indlamkc],Tk,&s_fdqd[indkc]);   
               // finally if c = k for f/dq += Tk^T*Fx3(fk)
               if (c == k){
                  #pragma unroll
                  for(int r = 0; r < 6; r++){
                     T *Tkc = &Tk[r * 6]; s_fdq[indlamkc + r] += -fk[1]*Tkc[0] + fk[0]*Tkc[1] - fk[4]*Tkc[3] + fk[3]*Tkc[4];
                  }
               }
            }
         }
      }  
   }
}

template <typename T, bool VEL_DAMPING = 1>
void inverseDynamicsGradient(T *s_cdq, T *s_cdqd, T *s_qd, T *s_v, T *s_a, T *s_f, T *s_I, T *s_T, int k = 0){
   T s_vdq[3*NUM_POS*(NUM_POS+1)];  T s_vdqd[3*NUM_POS*(NUM_POS+1)];
   T s_adq[3*NUM_POS*(NUM_POS+1)];  T s_adqd[3*NUM_POS*(NUM_POS+1)];
   T s_fdq[6*NUM_POS*NUM_POS];      T s_fdqd[6*NUM_POS*NUM_POS];
   compute_vafdu(s_fdq,s_fdqd,s_adq,s_adqd,s_vdq,s_vdqd,s_f,s_a,s_v,s_qd,s_T,s_I);
   compute_cdu<T,VEL_DAMPING>(s_cdq,s_cdqd,s_fdq,s_fdqd,s_T,s_f);
}

template <typename T, bool MPC_MODE = false>
void forwardDynamicsGradientSetupSimple_old(T *s_v, T *s_a, T *s_f, T *s_T, T *d_T, T *d_I, T *s_q, T *s_qd, T *s_qdd, T *s_fext = nullptr){
   T s_sinq[NUM_POS];
   T s_cosq[NUM_POS];
   T s_temp[42];
   // update transforms for this configuration (and load into shared if needed)
   updateTransforms<T>(s_T,d_T,s_q,s_sinq,s_cosq);
   // compute bias term to get v,a,f
   RNEA_fp_old<T,MPC_MODE>(s_v, s_a, s_f, d_I, s_T, s_qd, s_temp, s_qdd, s_fext);
   RNEA_bp_old<T>(nullptr,s_f,s_T);
}

template <typename T, bool QDD_PASSED_IN = 0, bool MPC_MODE = false>
void forwardDynamicsGradientSetup_old(T *s_v, T *s_a, T *s_f, T *s_Minv, T *s_T, T *s_qdd_in, T *s_tau, T *s_qd, T *s_q, T *d_I, T *d_T, T *s_fext = nullptr){
   T s_F[6*NUM_POS*NUM_POS];
   T s_U[6*NUM_POS];
   T s_D[2*NUM_POS]; // also store 1/Di
   T s_IA[36*NUM_POS];
   T s_Ia[36];
   T s_bias[NUM_POS];
   T s_sinq[NUM_POS];
   T s_cosq[NUM_POS];
   T s_temp[42];
   T s_qdd_here[NUM_POS];
   // update transforms for this configuration (and load into shared if needed)
   updateTransforms<T>(s_T,d_T,s_q,s_sinq,s_cosq);
   // and clear things for Minv and F in either case
   zeroSharedMem<T,NUM_POS*NUM_POS>(s_Minv);
   zeroSharedMem<T,6*NUM_POS*NUM_POS>(s_F);
   // and copy from d_I to s_IA as we will modify it and don't want to change d_I because we will be using it actively
   copyMat<T,36,NUM_POS>(s_IA,d_I,36,36);
   // compute Minv and bias (make sure to pass in qdd (or not))
   FD_helpersCPU<T>(s_Minv,s_F,s_bias,s_tau,s_v,s_a,s_f,s_qd,d_I,s_IA,s_Ia,s_T,s_U,s_D,s_temp,s_fext,(QDD_PASSED_IN ? s_qdd_in : nullptr));
   // if qdd not passed in then need to compute qdd and then recompute bias
   if(!QDD_PASSED_IN){
      matVMultSym<T,NUM_POS,NUM_POS>(s_qdd_here,s_Minv,NUM_POS,s_bias);
      copyMat<T,36,NUM_POS>(s_IA,d_I,36,36);
      // now we have qdd and Minv won't change just need to recompute all the bias term things
      RNEA_fp_old<T,MPC_MODE>(s_v, s_a, s_f, d_I, s_T, s_qd, s_temp, s_qdd_here, s_fext);
      RNEA_bp_old<T>(nullptr,s_f,s_T);
   }
}

template <typename T, bool MPC_MODE = false>
void forwardDynamicsGradientSetupSimple(T *s_v, T *s_a, T *s_f, T *s_T, T *d_T, T *d_I, T *s_q, T *s_qd, T *s_qdd, T *s_fext = nullptr){
   T s_sinq[NUM_POS];
   T s_cosq[NUM_POS];
   T s_temp[42];
   // update transforms for this configuration (and load into shared if needed)
   updateTransforms<T>(s_T,d_T,s_q,s_sinq,s_cosq);
   // compute bias term to get v,a,f
   RNEA_fp<T,MPC_MODE>(s_v, s_a, s_f, d_I, s_T, s_qd, s_temp, s_qdd, s_fext);
   RNEA_bp<T>(nullptr,s_f,s_T);
}

template <typename T, bool QDD_PASSED_IN = 0, bool MPC_MODE = false>
void forwardDynamicsGradientSetup(T *s_v, T *s_a, T *s_f, T *s_Minv, T *s_T, T *s_qdd_in, T *s_tau, T *s_qd, T *s_q, T *d_I, T *d_T, T *s_fext = nullptr){
   T s_F[6*NUM_POS*NUM_POS];
   T s_U[6*NUM_POS];
   T s_D[2*NUM_POS]; // also store 1/Di
   T s_IA[36*NUM_POS];
   T s_Ia[36];
   T s_bias[NUM_POS];
   T s_sinq[NUM_POS];
   T s_cosq[NUM_POS];
   T s_temp[42];
   T s_qdd_here[NUM_POS];
   // update transforms for this configuration (and load into shared if needed)
   updateTransforms<T>(s_T,d_T,s_q,s_sinq,s_cosq);
   // and clear things for Minv and F in either case
   zeroSharedMem<T,NUM_POS*NUM_POS>(s_Minv);
   zeroSharedMem<T,6*NUM_POS*NUM_POS>(s_F);
   // and copy from d_I to s_IA as we will modify it and don't want to change d_I because we will be using it actively
   copyMat<T,36,NUM_POS>(s_IA,d_I,36,36);
   // compute Minv and bias (make sure to pass in qdd (or not))
   FD_helpersCPU<T>(s_Minv,s_F,s_bias,s_tau,s_v,s_a,s_f,s_qd,d_I,s_IA,s_Ia,s_T,s_U,s_D,s_temp,s_fext,(QDD_PASSED_IN ? s_qdd_in : nullptr));
   // if qdd not passed in then need to compute qdd and then recompute bias
   if(!QDD_PASSED_IN){
      matVMultSym<T,NUM_POS,NUM_POS>(s_qdd_here,s_Minv,NUM_POS,s_bias);
      copyMat<T,36,NUM_POS>(s_IA,d_I,36,36);
      // now we have qdd and Minv won't change just need to recompute all the bias term things
      RNEA_fp<T,MPC_MODE>(s_v, s_a, s_f, d_I, s_T, s_qd, s_temp, s_qdd_here, s_fext);
      RNEA_bp<T>(nullptr,s_f,s_T);
   }
}

template <typename T, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false, bool VEL_DAMPING = true>
void forwardDynamicsGradient(T *s_dqdd, T *xk, T *uk, T *qddk, T *Minvk, T *I, T *Tbody, int MinvGoodFlag = 0, \
                           double *t1 = nullptr, double *t2 = nullptr, double *t3 = nullptr, T *s_fext = nullptr){
   T s_cdq[NUM_POS*NUM_POS]; T s_cdqd[NUM_POS*NUM_POS]; T s_v[6*NUM_POS]; T s_a[6*NUM_POS]; T s_f[6*NUM_POS]; T s_T[36*NUM_POS];
   // dqdd/dtau = Minv and  dqdd/dq(d) = -Minv*dc/dq(d) note: dM term in dq drops out if you compute c with fd qdd per carpentier
   // first compute the dynamics gradient helpers (v,a,f to prep for inverse dynamics gradient) and compute Minv and qdd if needed
   if (QDD_PASSED_IN && MINV_PASSED_IN && MinvGoodFlag){forwardDynamicsGradientSetupSimple<T,MPC_MODE>(s_v,s_a,s_f,s_T,Tbody,I,xk,&xk[NUM_POS],qddk);}
   else{forwardDynamicsGradientSetup<T,QDD_PASSED_IN,MPC_MODE>(s_v,s_a,s_f,Minvk,s_T,qddk,uk,&xk[NUM_POS],xk,I,Tbody);}
   inverseDynamicsGradient<T,VEL_DAMPING>(s_cdq,s_cdqd,&xk[NUM_POS],s_v,s_a,s_f,I,s_T);
   // Then finish it off: dqdd/dtau = Minv, dqdd/dqd = -Minv*dc/dqd, dqdd/dq = -Minv*dc/dq --- remember Minv is a symmetric sym UPPER matrix
   matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(s_dqdd,NUM_POS,Minvk,NUM_POS,s_cdq,NUM_POS,static_cast<T>(-1));
   matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(&s_dqdd[NUM_POS*NUM_POS],NUM_POS,Minvk,NUM_POS,s_cdqd,NUM_POS,static_cast<T>(-1));
}

template <typename T, bool MPC_MODE = false>
void forwardDynamicsGradientSetupSimple4x4(T *s_v, T *s_a, T *s_f, T *s_T, T *s_Tb4, T *d_I, T *s_q, T *s_qd, T *s_qdd, T *s_Tb4dq = nullptr, T *s_fext = nullptr){
   T s_sinq[NUM_POS];
   T s_cosq[NUM_POS];
   T s_temp[42];
   // update transforms for this configuration
   #pragma unroll
   for (int ind = 0; ind < NUM_POS; ind++){s_sinq[ind] = std::sin(s_q[ind]); s_cosq[ind] = std::cos(s_q[ind]);}
   buildTransforms4x4(s_Tb4,s_sinq,s_cosq); if (s_Tb4dq != nullptr){buildTransforms4x4dq(s_Tb4dq,s_sinq,s_cosq);}
   updateTransforms4x4to6x6_v2(s_T,s_Tb4);
   // compute bias term to get v,a,f
   RNEA_fp<T,MPC_MODE>(s_v, s_a, s_f, d_I, s_T, s_qd, s_temp, s_qdd, s_fext);
   RNEA_bp<T>(nullptr,s_f,s_T);
}

template <typename T, bool QDD_PASSED_IN = 0, bool MPC_MODE = false>
void forwardDynamicsGradientSetup4x4(T *s_v, T *s_a, T *s_f, T *s_Minv, T *s_T, T *s_Tb4, T *s_qdd_in, T *s_tau, T *s_qd, T *s_q, T *d_I, T *s_fext = nullptr){
   T s_F[6*NUM_POS*NUM_POS];
   T s_U[6*NUM_POS];
   T s_D[2*NUM_POS]; // also store 1/Di
   T s_IA[36*NUM_POS];
   T s_Ia[36];
   T s_bias[NUM_POS];
   T s_sinq[NUM_POS];
   T s_cosq[NUM_POS];
   T s_temp[42];
   T s_qdd_here[NUM_POS];
   // update transforms for this configuration
   #pragma unroll
   for (int ind = 0; ind < NUM_POS; ind++){s_sinq[ind] = std::sin(s_q[ind]); s_cosq[ind] = std::cos(s_q[ind]);}
   buildTransforms4x4(s_Tb4,s_sinq,s_cosq);
   updateTransforms4x4to6x6_v2(s_T,s_Tb4);
   // and clear things for Minv and F in either case
   zeroSharedMem<T,NUM_POS*NUM_POS>(s_Minv);
   zeroSharedMem<T,6*NUM_POS*NUM_POS>(s_F);
   // and copy from d_I to s_IA as we will modify it and don't want to change d_I because we will be using it actively
   copyMat<T,36,NUM_POS>(s_IA,d_I,36,36);
   // compute Minv and bias (make sure to pass in qdd (or not))
   FD_helpersCPU<T>(s_Minv,s_F,s_bias,s_tau,s_v,s_a,s_f,s_qd,d_I,s_IA,s_Ia,s_T,s_U,s_D,s_temp,s_fext,(QDD_PASSED_IN ? s_qdd_in : nullptr));
   // if qdd not passed in then need to compute qdd and then recompute bias
   if(!QDD_PASSED_IN){
      matVMultSym<T,NUM_POS,NUM_POS>(s_qdd_here,s_Minv,NUM_POS,s_bias);
      copyMat<T,36,NUM_POS>(s_IA,d_I,36,36);
      // now we have qdd and Minv won't change just need to recompute all the bias term things
      RNEA_fp<T,MPC_MODE>(s_v, s_a, s_f, d_I, s_T, s_qd, s_temp, s_qdd_here, s_fext);
      RNEA_bp<T>(nullptr,s_f,s_T);
   }
}

template <typename T, bool QDD_PASSED_IN = 0, bool MPC_MODE = false>
void dynamicsGradientThreaded_Start(threadDesc_t desc, T *d_x, T *d_u, T *d_qdd, T *d_v, T *d_a, T *d_f, int ld_x, int ld_u, T *I, T *Tbody, T *Tfinal){
    // for each rep on this thread
    for (unsigned int i=0; i<desc.reps; i++){int k = (desc.tid+i*desc.dim);
        // get correct pointers
        T *qk = &d_x[k*ld_x]; T *qdk = qk + NUM_POS; T *qddk = &d_qdd[k*NUM_POS];
        int ind6 = k*6*NUM_POS; T *vk = &d_v[ind6]; T *ak = &d_a[ind6]; T *fk = &d_f[ind6]; T *Tfinalk = &Tfinal[6*ind6];
        // load in qdd or get temp of zeros
        T s_qdd[NUM_POS]; if (QDD_PASSED_IN){std::memcpy(s_qdd,qddk,NUM_POS*sizeof(T));} else{for(int i = 0; i < NUM_POS; i++){s_qdd[i] = static_cast<T>(0);}}
        // compute v,a,f,T
        forwardDynamicsGradientSetupSimple<T,MPC_MODE>(vk,ak,fk,Tfinalk,Tbody,I,qk,qdk,s_qdd);
    }
}

template <typename T>
void dynamicsGradientThreaded_Middle(threadDesc_t desc, T *d_cdq, T *d_cdqd, T *d_x, T *d_v, T *d_a, T *d_f, T *d_Tfinal, T *d_I, int ld_x){
   for (unsigned int i=0; i<desc.reps; i++){int k = (desc.tid+i*desc.dim);
      T *cdqk = &d_cdq[k*NUM_POS*NUM_POS]; T *cdqdk = &d_cdqd[k*NUM_POS*NUM_POS]; T *xk = &d_x[k*ld_x]; 
      T *vk = &d_v[k*6*NUM_POS]; T *ak = &d_a[k*6*NUM_POS]; T *fk = &d_f[k*6*NUM_POS]; T *Tk = &d_Tfinal[k*36*NUM_POS];
      inverseDynamicsGradient<T>(cdqk,cdqdk,&xk[NUM_POS],vk,ak,fk,d_I,Tk);
   }
}

template <typename T>
void dynamicsGradientThreaded_Finish(threadDesc_t desc, T *d_cdq, T *d_cdqd, T *d_Minv, T *d_dqdd){
    // for each rep on this thread
    for (unsigned int i=0; i<desc.reps; i++){int k = (desc.tid+i*desc.dim);
        T *Minvk = &d_Minv[k*NUM_POS*NUM_POS]; T *dqddk = &d_dqdd[k*2*NUM_POS*NUM_POS]; T *cdqk = &d_cdq[k*NUM_POS*NUM_POS]; T *cdqdk = &d_cdqd[k*NUM_POS*NUM_POS];
        matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(dqddk,NUM_POS,Minvk,NUM_POS,cdqk,NUM_POS,static_cast<T>(-1));
        matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(&dqddk[NUM_POS*NUM_POS],NUM_POS,Minvk,NUM_POS,cdqdk,NUM_POS,static_cast<T>(-1));
    }
}

template <typename T, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false, bool VEL_DAMPING = true>
void dynamicsGradientThreaded_old(threadDesc_t desc, T *d_x, T *d_u, T *d_qdd, T *d_Minv, T *d_dqdd, int ld_x, int ld_u, T *I, T *Tbody, bool MinvGoodFlag){
   T s_cdq[NUM_POS*NUM_POS]; T s_cdqd[NUM_POS*NUM_POS]; T s_v[6*NUM_POS]; T s_a[6*NUM_POS]; T s_f[6*NUM_POS]; T s_T[36*NUM_POS]; 
   for (unsigned int i=0; i<desc.reps; i++){int k = (desc.tid+i*desc.dim);
      T *xk = &d_x[k*ld_x]; T *uk = &d_u[k*ld_u]; T *qddk = &d_qdd[k*NUM_POS]; T *Minvk = &d_Minv[k*NUM_POS*NUM_POS]; T *dqddk = &d_dqdd[k*2*NUM_POS*NUM_POS];
      if (QDD_PASSED_IN && MINV_PASSED_IN && MinvGoodFlag){forwardDynamicsGradientSetupSimple_old<T,MPC_MODE>(s_v,s_a,s_f,s_T,Tbody,I,xk,&xk[NUM_POS],qddk);}
      else{forwardDynamicsGradientSetup_old<T,QDD_PASSED_IN,MPC_MODE>(s_v,s_a,s_f,Minvk,s_T,qddk,uk,&xk[NUM_POS],xk,I,Tbody);}
      inverseDynamicsGradient_old<T,VEL_DAMPING>(s_cdq,s_cdqd,&xk[NUM_POS],s_v,s_a,s_f,I,s_T);
      // Then finish it off: dqdd/dtau = Minv, dqdd/dqd = -Minv*dc/dqd, dqdd/dq = -Minv*dc/dq --- remember Minv is a symmetric sym UPPER matrix
      matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(dqddk,NUM_POS,Minvk,NUM_POS,s_cdq,NUM_POS,static_cast<T>(-1));
      matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(&dqddk[NUM_POS*NUM_POS],NUM_POS,Minvk,NUM_POS,s_cdqd,NUM_POS,static_cast<T>(-1));
   }
}

template <typename T, bool QDD_PASSED_IN = 0, bool MINV_PASSED_IN = 0, bool MPC_MODE = false, bool VEL_DAMPING = true>
void dynamicsGradientThreaded(threadDesc_t desc, T *d_x, T *d_u, T *d_qdd, T *d_Minv, T *d_dqdd, int ld_x, int ld_u, T *I, T *Tbody, bool MinvGoodFlag){
   T s_cdq[NUM_POS*NUM_POS]; T s_cdqd[NUM_POS*NUM_POS]; T s_v[6*NUM_POS]; T s_a[6*NUM_POS]; T s_f[6*NUM_POS]; T s_T[36*NUM_POS]; 
   for (unsigned int i=0; i<desc.reps; i++){int k = (desc.tid+i*desc.dim);
      T *xk = &d_x[k*ld_x]; T *uk = &d_u[k*ld_u]; T *qddk = &d_qdd[k*NUM_POS]; T *Minvk = &d_Minv[k*NUM_POS*NUM_POS]; T *dqddk = &d_dqdd[k*2*NUM_POS*NUM_POS];
      if (QDD_PASSED_IN && MINV_PASSED_IN && MinvGoodFlag){forwardDynamicsGradientSetupSimple<T,MPC_MODE>(s_v,s_a,s_f,s_T,Tbody,I,xk,&xk[NUM_POS],qddk);}
      else{forwardDynamicsGradientSetup<T,QDD_PASSED_IN,MPC_MODE>(s_v,s_a,s_f,Minvk,s_T,qddk,uk,&xk[NUM_POS],xk,I,Tbody);}
      inverseDynamicsGradient<T,VEL_DAMPING>(s_cdq,s_cdqd,&xk[NUM_POS],s_v,s_a,s_f,I,s_T);
      // Then finish it off: dqdd/dtau = Minv, dqdd/dqd = -Minv*dc/dqd, dqdd/dq = -Minv*dc/dq --- remember Minv is a symmetric sym UPPER matrix
      matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(dqddk,NUM_POS,Minvk,NUM_POS,s_cdq,NUM_POS,static_cast<T>(-1));
      matMultSym<T,NUM_POS,NUM_POS,NUM_POS>(&dqddk[NUM_POS*NUM_POS],NUM_POS,Minvk,NUM_POS,s_cdqd,NUM_POS,static_cast<T>(-1));
   }
}