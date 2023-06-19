using LinearAlgebra
using FixedPointNumbers
DYNAMICS_TYPE = Fixed{Int32,5}#Float32#

###########################################################
#                        WARNING                          #
# MAKE SURE TO INCLUDE THIS FILE IN THE CPP HELPERS FILE  #
#                        WARNING                          #
###########################################################


#-------------------------------------------------------------------------------
# Helper Functions
#-------------------------------------------------------------------------------

function initConstants(CUSTOM_TYPE)
   X,Y,Z = 1,2,3 # Julia is 1-indexed
   AX,AY,AZ,LX,LY,LZ = 1,2,3,4,5,6 # Julia is 1-indexed
   g = CUSTOM_TYPE(0.0)
   return X,Y,Z,AX,AY,AZ,LX,LY,LZ,g
end
function initPlaceholdersRNEA(CUSTOM_TYPE)
   l1_v = zeros(CUSTOM_TYPE,6,1)
   l2_v = zeros(CUSTOM_TYPE,6,1)
   l3_v = zeros(CUSTOM_TYPE,6,1)
   l4_v = zeros(CUSTOM_TYPE,6,1)
   l5_v = zeros(CUSTOM_TYPE,6,1)
   l6_v = zeros(CUSTOM_TYPE,6,1)
   l7_v = zeros(CUSTOM_TYPE,6,1)
   l1_a = zeros(CUSTOM_TYPE,6,1)
   l2_a = zeros(CUSTOM_TYPE,6,1)
   l3_a = zeros(CUSTOM_TYPE,6,1)
   l4_a = zeros(CUSTOM_TYPE,6,1)
   l5_a = zeros(CUSTOM_TYPE,6,1)
   l6_a = zeros(CUSTOM_TYPE,6,1)
   l7_a = zeros(CUSTOM_TYPE,6,1)
   l1_f = zeros(CUSTOM_TYPE,6,1)
   l2_f = zeros(CUSTOM_TYPE,6,1)
   l3_f = zeros(CUSTOM_TYPE,6,1)
   l4_f = zeros(CUSTOM_TYPE,6,1)
   l5_f = zeros(CUSTOM_TYPE,6,1)
   l6_f = zeros(CUSTOM_TYPE,6,1)
   l7_f = zeros(CUSTOM_TYPE,6,1)
   fext_l1 = zeros(CUSTOM_TYPE,6,1)
   fext_l2 = zeros(CUSTOM_TYPE,6,1)
   fext_l3 = zeros(CUSTOM_TYPE,6,1)
   fext_l4 = zeros(CUSTOM_TYPE,6,1)
   fext_l5 = zeros(CUSTOM_TYPE,6,1)
   fext_l6 = zeros(CUSTOM_TYPE,6,1)
   fext_l7 = zeros(CUSTOM_TYPE,6,1)
   tau = zeros(CUSTOM_TYPE,7,1)
   return l1_v,l2_v,l3_v,l4_v,l5_v,l6_v,l7_v,l1_a,l2_a,l3_a,l4_a,l5_a,l6_a,l7_a,l1_f,l2_f,l3_f,l4_f,l5_f,l6_f,l7_f,fext_l1,fext_l2,fext_l3,fext_l4,fext_l5,fext_l6,fext_l7,tau
end
function initMotionTransforms(CUSTOM_TYPE)
   # Per-Robot Translation Constants
   # -- Joint Translation Constants
   tz_j1 = CUSTOM_TYPE(0.1574999988079071)
   tz_j2 = CUSTOM_TYPE(0.20250000059604645)
   ty_j3 = CUSTOM_TYPE(0.2045000046491623)
   tz_j3 = CUSTOM_TYPE(-9.999999960041972E-13)
   tz_j4 = CUSTOM_TYPE(0.21549999713897705)
   ty_j5 = CUSTOM_TYPE(0.18449999392032623)
   tz_j5 = CUSTOM_TYPE(-9.999999960041972E-13)
   ty_j6 = CUSTOM_TYPE(-1.9999999920083944E-12)
   tz_j6 = CUSTOM_TYPE(0.21549999713897705)
   ty_j7 = CUSTOM_TYPE(0.08100000023841858)
   # Initialize Motion Transforms, Filling in Per-Robot Constants
   # -- Link 1 <-- World 0
   t1X0 = zeros(CUSTOM_TYPE,6,6)
   t1X0[3,3] = 1.0
   t1X0[6,6] = 1.0
   # -- Link 2 <-- Link 1
   t2X1 = zeros(CUSTOM_TYPE,6,6)
   t2X1[3,2] = 1.0
   t2X1[6,1] = -tz_j2
   t2X1[6,5] = 1.0
   # -- Link 3 <-- Link 2
   t3X2 = zeros(CUSTOM_TYPE,6,6)
   t3X2[3,2] = 1.0
   t3X2[6,1] = -tz_j3
   t3X2[6,5] = 1.0
   # -- Link 4 <-- Link 3
   t4X3 = zeros(CUSTOM_TYPE,6,6)
   t4X3[3,2] = -1.0
   t4X3[6,1] =  tz_j4
   t4X3[6,5] = -1.0
   # -- Link 5 <-- Link 4
   t5X4 = zeros(CUSTOM_TYPE,6,6)
   t5X4[3,2] = 1.0
   t5X4[6,1] = -tz_j5
   t5X4[6,5] = 1.0
   # -- Link 6 <-- Link 5
   t6X5 = zeros(CUSTOM_TYPE,6,6)
   t6X5[3,2] = -1.0
   t6X5[6,1] =  tz_j6
   t6X5[6,5] = -1.0
   # -- Link 7 <-- Link 6
   t7X6 = zeros(CUSTOM_TYPE,6,6)
   t7X6[3,2] = 1.0
   t7X6[6,5] = 1.0
   return t1X0,t2X1,t3X2,t4X3,t5X4,t6X5,t7X6
end

function buildI3x3(CUSTOM_TYPE,Ixx, Iyy, Izz, Ixy, Ixz, Iyz)
   tensor = zeros(CUSTOM_TYPE,3,3)
   tensor[1,1] =  Ixx
   tensor[1,2] = -Ixy
   tensor[1,3] = -Ixz
   tensor[2,1] = -Ixy
   tensor[2,2] =  Iyy
   tensor[2,3] = -Iyz
   tensor[3,1] = -Ixz
   tensor[3,2] = -Iyz
   tensor[3,3] =  Izz
   return tensor
end

function buildI6x6(CUSTOM_TYPE, mass, com, I3x3, X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   tensor = zeros(CUSTOM_TYPE,6,6)
   # Copy elements from the 3x3 Inertia Tensor
   for row = 1:3
      for col = 1:3
         i_val = I3x3[row,col]
         tensor[row,col] = i_val
      end
   end
   #data(AX,LY) = data(LY,AX) = - ( data(AY,LX) = data(LX,AY) = mass*com(Z) );
   mcz = mass*com[Z]
   tensor[AY,LX] =  mcz
   tensor[LX,AY] =  mcz
   tensor[AX,LY] = -mcz
   tensor[LY,AX] = -mcz
   #data(AZ,LX) = data(LX,AZ) = - ( data(AX,LZ) = data(LZ,AX) = mass*com(Y) );
   mcy = mass*com[Y]
   tensor[AX,LZ] =  mcy
   tensor[LZ,AX] =  mcy
   tensor[AZ,LX] = -mcy
   tensor[LX,AZ] = -mcy
   #data(AY,LZ) = data(LZ,AY) = - ( data(AZ,LY) = data(LY,AZ) = mass*com(X) );
   mcx = mass*com[X]
   tensor[AZ,LY] =  mcx
   tensor[LY,AZ] =  mcx
   tensor[AY,LZ] = -mcx
   tensor[LZ,AY] = -mcx
   #data(LX,LX) = data(LY,LY) = data(LZ,LZ) = mass;
   tensor[LX,LX] = mass
   tensor[LY,LY] = mass
   tensor[LZ,LZ] = mass
   return tensor
end

#-------------------------------------------------------------------------------
# Initialize Spatial Inertia Tensors from Constants
#-------------------------------------------------------------------------------
function initInertiaTensors(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   # Per-Robot Inertia Constants
   # -- Link 1 Mass, Position, Inertia
   m_l1 = CUSTOM_TYPE(5.760000228881836)
   comy_l1 = CUSTOM_TYPE(-0.029999999329447746)
   comz_l1 = CUSTOM_TYPE(0.11999999731779099)
   ix_l1 = CUSTOM_TYPE(0.12112800031900406)
   iy_l1 = CUSTOM_TYPE(0.11624400317668915)
   iyz_l1 = CUSTOM_TYPE(-0.020735999569296837)
   iz_l1 = CUSTOM_TYPE(0.017483999952673912)
   # -- Link 2 Mass, Position, Inertia
   m_l2 = CUSTOM_TYPE(6.349999904632568)
   comx_l2 = CUSTOM_TYPE(3.000000142492354E-4)
   comy_l2 = CUSTOM_TYPE(0.05900000035762787)
   comz_l2 = CUSTOM_TYPE(0.041999999433755875)
   ix_l2 = CUSTOM_TYPE(0.06380599737167358)
   ixy_l2 = CUSTOM_TYPE(1.1200000153621659E-4)
   ixz_l2 = CUSTOM_TYPE(7.999999797903001E-5)
   iy_l2 = CUSTOM_TYPE(0.0416020005941391)
   iyz_l2 = CUSTOM_TYPE(0.015735000371932983)
   iz_l2 = CUSTOM_TYPE(0.03310500085353851)
   # -- Link 3 Mass, Position, Inertia
   m_l3 = CUSTOM_TYPE(3.5)
   comy_l3 = CUSTOM_TYPE(0.029999999329447746)
   comz_l3 = CUSTOM_TYPE(0.12999999523162842)
   ix_l3 = CUSTOM_TYPE(0.08730000257492065)
   iy_l3 = CUSTOM_TYPE(0.08295000344514847)
   iyz_l3 = CUSTOM_TYPE(0.013650000095367432)
   iz_l3 = CUSTOM_TYPE(0.01075000036507845)
   # -- Link 4 Mass, Position, Inertia
   m_l4 = CUSTOM_TYPE(3.5)
   comy_l4 = CUSTOM_TYPE(0.06700000166893005)
   comz_l4 = CUSTOM_TYPE(0.03400000184774399)
   ix_l4 = CUSTOM_TYPE(0.036757998168468475)
   iy_l4 = CUSTOM_TYPE(0.02044600062072277)
   iyz_l4 = CUSTOM_TYPE(0.007973000407218933)
   iz_l4 = CUSTOM_TYPE(0.021710999310016632)
   # -- Link 5 Mass, Position, Inertia
   m_l5 = CUSTOM_TYPE(3.5)
   comx_l5 = CUSTOM_TYPE(9.999999747378752E-5)
   comy_l5 = CUSTOM_TYPE(0.020999999716877937)
   comz_l5 = CUSTOM_TYPE(0.07599999755620956)
   ix_l5 = CUSTOM_TYPE(0.03175999969244003)
   ixy_l5 = CUSTOM_TYPE(7.000000096013537E-6)
   ixz_l5 = CUSTOM_TYPE(2.700000004551839E-5)
   iy_l5 = CUSTOM_TYPE(0.028915999457240105)
   iyz_l5 = CUSTOM_TYPE(0.00558600015938282)
   iz_l5 = CUSTOM_TYPE(0.0060339998453855515)
   # -- Link 6 Mass, Position, Inertia
   m_l6 = CUSTOM_TYPE(1.7999999523162842)
   comy_l6 = CUSTOM_TYPE(6.000000284984708E-4)
   comz_l6 = CUSTOM_TYPE(3.9999998989515007E-4)
   ix_l6 = CUSTOM_TYPE(0.004900999832898378)
   iy_l6 = CUSTOM_TYPE(0.004699999932199717)
   iyz_l6 = CUSTOM_TYPE(0)
   iz_l6 = CUSTOM_TYPE(0.0036009999457746744)
   # -- Link 7 Mass, Position, Inertia
   m_l7 = CUSTOM_TYPE(1.2000000476837158)
   comz_l7 = CUSTOM_TYPE(0.019999999552965164)
   ix_l7 = CUSTOM_TYPE(0.00547999981790781)
   iy_l7 = CUSTOM_TYPE(0.00547999981790781)
   iz_l7 = CUSTOM_TYPE(0.004999999888241291)
   # Initialize Spatial Inertia Tensors from Constants, Ii
   # -- Link 1
   l1_com = [0.0,comy_l1,comz_l1]
   l1_I3x3 = buildI3x3(CUSTOM_TYPE,ix_l1,iy_l1,iz_l1,0.0,0.0,iyz_l1)
   l1_I = buildI6x6(CUSTOM_TYPE,m_l1, l1_com, l1_I3x3, X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   # -- Link 2
   l2_com = [comx_l2,comy_l2,comz_l2]
   l2_I3x3 = buildI3x3(CUSTOM_TYPE,ix_l2,iy_l2,iz_l2,ixy_l2,ixz_l2,iyz_l2)
   l2_I = buildI6x6(CUSTOM_TYPE,m_l2, l2_com, l2_I3x3, X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   # -- Link 3
   l3_com = [0.0,comy_l3,comz_l3]
   l3_I3x3 = buildI3x3(CUSTOM_TYPE,ix_l3,iy_l3,iz_l3,0.0,0.0,iyz_l3)
   l3_I = buildI6x6(CUSTOM_TYPE,m_l3, l3_com, l3_I3x3, X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   # -- Link 4
   l4_com = [0.0,comy_l4,comz_l4]
   l4_I3x3 = buildI3x3(CUSTOM_TYPE,ix_l4,iy_l4,iz_l4,0.0,0.0,iyz_l4)
   l4_I = buildI6x6(CUSTOM_TYPE,m_l4, l4_com, l4_I3x3, X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   # -- Link 5
   l5_com = [comx_l5,comy_l5,comz_l5]
   l5_I3x3 = buildI3x3(CUSTOM_TYPE,ix_l5,iy_l5,iz_l5,ixy_l5,ixz_l5,iyz_l5)
   l5_I = buildI6x6(CUSTOM_TYPE,m_l5, l5_com, l5_I3x3, X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   # -- Link 6
   l6_com = [0.0,comy_l6,comz_l6]
   l6_I3x3 = buildI3x3(CUSTOM_TYPE,ix_l6,iy_l6,iz_l6,0.0,0.0,iyz_l6)
   l6_I = buildI6x6(CUSTOM_TYPE,m_l6, l6_com, l6_I3x3, X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   # -- Link 7
   l7_com = [0.0,0.0,comz_l7]
   l7_I3x3 = buildI3x3(CUSTOM_TYPE,ix_l7,iy_l7,iz_l7,0.0,0.0,0.0)
   l7_I = buildI6x6(CUSTOM_TYPE,m_l7, l7_com, l7_I3x3, X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   return l1_I,l2_I,l3_I,l4_I,l5_I,l6_I,l7_I
end

function updateTransforms_For_Wrapper(CUSTOM_TYPE,sinq,cosq,t1X0,t2X1,t3X2,t4X3,t5X4,t6X5,t7X6)
   # Per-Robot Translation Constants
   # -- Joint Translation Constants
   tz_j1 = CUSTOM_TYPE(0.1574999988079071)
   tz_j2 = CUSTOM_TYPE(0.20250000059604645)
   ty_j3 = CUSTOM_TYPE(0.2045000046491623)
   tz_j3 = CUSTOM_TYPE(-9.999999960041972E-13)
   tz_j4 = CUSTOM_TYPE(0.21549999713897705)
   ty_j5 = CUSTOM_TYPE(0.18449999392032623)
   tz_j5 = CUSTOM_TYPE(-9.999999960041972E-13)
   ty_j6 = CUSTOM_TYPE(-1.9999999920083944E-12)
   tz_j6 = CUSTOM_TYPE(0.21549999713897705)
   ty_j7 = CUSTOM_TYPE(0.08100000023841858)
   # -- Link 1 <-- World 0
   s_j1 = sinq[1]
   c_j1 = cosq[1]
   t1X0[1,1] = c_j1
   t1X0[1,2] = s_j1
   t1X0[2,1] = -s_j1
   t1X0[2,2] = c_j1
   t1X0[4,1] = -tz_j1 * s_j1
   t1X0[4,2] =  tz_j1 * c_j1
   t1X0[4,4] = c_j1
   t1X0[4,5] = s_j1
   t1X0[5,1] = -tz_j1 * c_j1
   t1X0[5,2] = -tz_j1 * s_j1
   t1X0[5,4] = -s_j1
   t1X0[5,5] = c_j1
   # -- Link 2 <-- Link 1
   s_j2 = sinq[2]
   c_j2 = cosq[2]
   t2X1[1,1] = -c_j2
   t2X1[1,3] = s_j2
   t2X1[2,1] = s_j2
   t2X1[2,3] = c_j2
   t2X1[4,2] = -tz_j2 * c_j2
   t2X1[4,4] = -c_j2
   t2X1[4,6] = s_j2
   t2X1[5,2] =  tz_j2 * s_j2
   t2X1[5,4] = s_j2
   t2X1[5,6] = c_j2
   # -- Link 3 <-- Link 2
   s_j3 = sinq[3]
   c_j3 = cosq[3]
   t3X2[1,1] = -c_j3
   t3X2[1,3] = s_j3
   t3X2[2,1] = s_j3
   t3X2[2,3] = c_j3
   t3X2[4,1] =  ty_j3 * s_j3
   t3X2[4,2] = -tz_j3 * c_j3
   t3X2[4,3] =  ty_j3 * c_j3
   t3X2[4,4] = -c_j3
   t3X2[4,6] = s_j3
   t3X2[5,1] =  ty_j3 * c_j3
   t3X2[5,2] =  tz_j3 * s_j3
   t3X2[5,3] = -ty_j3 * s_j3
   t3X2[5,4] = s_j3
   t3X2[5,6] = c_j3
   # -- Link 4 <-- Link 3
   s_j4 = sinq[4]
   c_j4 = cosq[4]
   t4X3[1,1] = c_j4
   t4X3[1,3] = s_j4
   t4X3[2,1] = -s_j4
   t4X3[2,3] = c_j4
   t4X3[4,2] =  tz_j4 * c_j4
   t4X3[4,4] = c_j4
   t4X3[4,6] = s_j4
   t4X3[5,2] = -tz_j4 * s_j4
   t4X3[5,4] = -s_j4
   t4X3[5,6] = c_j4
   # -- Link 5 <-- Link 4
   s_j5 = sinq[5]
   c_j5 = cosq[5]
   t5X4[1,1] = -c_j5
   t5X4[1,3] = s_j5
   t5X4[2,1] = s_j5
   t5X4[2,3] = c_j5
   t5X4[4,1] =  ty_j5 * s_j5
   t5X4[4,2] = -tz_j5 * c_j5
   t5X4[4,3] =  ty_j5 * c_j5
   t5X4[4,4] = -c_j5
   t5X4[4,6] = s_j5
   t5X4[5,1] =  ty_j5 * c_j5
   t5X4[5,2] =  tz_j5 * s_j5
   t5X4[5,3] = -ty_j5 * s_j5
   t5X4[5,4] = s_j5
   t5X4[5,6] = c_j5
   # -- Link 6 <-- Link 5
   s_j6 = sinq[6]
   c_j6 = cosq[6]
   t6X5[1,1] = c_j6
   t6X5[1,3] = s_j6
   t6X5[2,1] = -s_j6
   t6X5[2,3] = c_j6
   t6X5[4,1] =  ty_j6 * s_j6
   t6X5[4,2] =  tz_j6 * c_j6
   t6X5[4,3] = -ty_j6 * c_j6
   t6X5[4,4] = c_j6
   t6X5[4,6] = s_j6
   t6X5[5,1] =  ty_j6 * c_j6
   t6X5[5,2] = -tz_j6 * s_j6
   t6X5[5,3] =  ty_j6 * s_j6
   t6X5[5,4] = -s_j6
   t6X5[5,6] = c_j6
   # -- Link 7 <-- Link 6
   s_j7 = sinq[7]
   c_j7 = cosq[7]
   t7X6[1,1] = -c_j7
   t7X6[1,3] = s_j7
   t7X6[2,1] = s_j7
   t7X6[2,3] = c_j7
   t7X6[4,1] =  ty_j7 * s_j7
   t7X6[4,3] =  ty_j7 * c_j7
   t7X6[4,4] = -c_j7
   t7X6[4,6] = s_j7
   t7X6[5,1] =  ty_j7 * c_j7
   t7X6[5,3] = -ty_j7 * s_j7
   t7X6[5,4] = s_j7
   t7X6[5,6] = c_j7
   return t1X0,t2X1,t3X2,t4X3,t5X4,t6X5,t7X6
end

function vxIv(CUSTOM_TYPE,v,I,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   # Pre-compute some recurring quantities
   wx2 = v[AX]*v[AX]
   wy2 = v[AY]*v[AY]
   wz2 = v[AZ]*v[AZ]

   v_AXAY = v[AX]*v[AY]
   v_AXAZ = v[AX]*v[AZ]
   v_AXLY = v[AX]*v[LY]
   v_AXLZ = v[AX]*v[LZ]

   v_AYAZ = v[AY]*v[AZ]
   v_AYLX = v[AY]*v[LX]
   v_AYLZ = v[AY]*v[LZ]

   v_AZLX = v[AZ]*v[LX]
   v_AZLY = v[AZ]*v[LY]

   m = I[LX,LX] # the mass

   # Copy some of the coefficients for more efficient access
   # 'aa' stands for angular-angular, a 3x3 sub-block of the spatial inertia
   Iaa = zeros(CUSTOM_TYPE,3,3)
   Iaa[1,1] = I[AX,AX]
   Iaa[1,2] = I[AX,AY]
   Iaa[1,3] = I[AX,AZ]
   Iaa[2,1] = I[AX,AY]
   Iaa[2,2] = I[AY,AY]
   Iaa[2,3] = I[AY,AZ]
   Iaa[3,1] = I[AX,AZ]
   Iaa[3,2] = I[AY,AZ]
   Iaa[3,3] = I[AZ,AZ]

   cmX = I[AZ, LY]
   cmY = I[AX, LZ]
   cmZ = I[AY, LX]

   ret = zeros(CUSTOM_TYPE,6,1)
   ret[AX] = cmZ * (v_AXLZ - v_AZLX) +
         cmY * (v_AXLY - v_AYLX) +
         v_AYAZ * (Iaa[Z,Z] - Iaa[Y,Y]) -
         v_AXAZ*Iaa[X,Y] - (wz2 - wy2)*Iaa[Y,Z] + v_AXAY*Iaa[X,Z]

   ret[AY] = cmZ * (v_AYLZ - v_AZLY) -
         cmX * (v_AXLY - v_AYLX) -
         v_AXAZ * (Iaa[Z,Z] - Iaa[X,X]) +
         v_AYAZ*Iaa[X,Y]  - v_AXAY*Iaa[Y,Z] + (wz2 - wx2)*Iaa[X,Z]

   ret[AZ] = cmX * (v_AZLX - v_AXLZ) -
         cmY * (v_AYLZ - v_AZLY) +
         v_AXAY * (Iaa[Y,Y] - Iaa[X,X]) +
         v_AXAZ*Iaa[Y,Z] - Iaa[X,Z]*v_AYAZ  - (wy2 - wx2)*Iaa[X,Y]

   ret[LX] =   m * (v_AYLZ - v_AZLY) - cmX * (wz2 + wy2) + v_AXAZ*cmZ + v_AXAY*cmY
   ret[LY] = - m * (v_AXLZ - v_AZLX) - cmY * (wz2 + wx2) + v_AXAY*cmX + v_AYAZ*cmZ
   ret[LZ] =   m * (v_AXLY - v_AYLX) - cmZ * (wy2 + wx2) + v_AXAZ*cmX + v_AYAZ*cmY
   return ret
end

function motionCrossProductMx(CUSTOM_TYPE,v,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   vx = zeros(CUSTOM_TYPE,6,6)
   # [optimization] only using entries in the AZ column
   ###vx[LZ,LY] =  v[AX]
   ###vx[AZ,AY] =  v[AX]
   ###vx[LY,LZ] = -v[AX]
   vx[AY,AZ] = -v[AX]
   
   ###vx[LX,LZ] =  v[AY]
   vx[AX,AZ] =  v[AY]
   ###vx[LZ,LX] = -v[AY]
   ###vx[AZ,AX] = -v[AY]
   
   ###vx[LY,LX] =  v[AZ]
   ###vx[AY,AX] =  v[AZ]
   ###vx[LX,LY] = -v[AZ]
   ###vx[AX,AY] = -v[AZ]

   ###vx[LZ,AY] =  v[LX]
   vx[LY,AZ] = -v[LX]

   vx[LX,AZ] =  v[LY]
   ###vx[LZ,AX] = -v[LY]

   ###vx[LY,AX] =  v[LZ]
   ###vx[LX,AY] = -v[LZ]

   return vx
end

function forceCrossProductMx(CUSTOM_TYPE,v,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   vx = zeros(CUSTOM_TYPE,6,6)

   vx[AY,AZ] = -v[AX]
   vx[LY,LZ] = -v[AX]
   vx[AZ,AY] =  v[AX]
   vx[LZ,LY] =  v[AX]

   vx[AZ,AX] = -v[AY]
   vx[LZ,LX] = -v[AY]
   vx[AX,AZ] =  v[AY]
   vx[LX,LZ] =  v[AY]

   vx[AX,AY] = -v[AZ]
   vx[LX,LY] = -v[AZ]
   vx[AY,AX] =  v[AZ]
   vx[LY,LX] =  v[AZ]

   vx[AY,LZ] = -v[LX]
   vx[AZ,LY] =  v[LX]

   vx[AZ,LX] = -v[LY]
   vx[AX,LZ] =  v[LY]

   vx[AX,LY] = -v[LZ]
   vx[AY,LX] =  v[LZ]

   return vx
end

#-------------------------------------------------------------------------------
# RNEA
#-------------------------------------------------------------------------------

function rnea_For_Wrapper(CUSTOM_TYPE,sinq,cosq,qd,qdd)
   #----------------------------------------------------------------------------
   # Per-Robot Initialization
   #----------------------------------------------------------------------------
   X,Y,Z,AX,AY,AZ,LX,LY,LZ,g = initConstants(CUSTOM_TYPE)
   l1_v,l2_v,l3_v,l4_v,l5_v,l6_v,l7_v,l1_a,l2_a,l3_a,l4_a,l5_a,l6_a,l7_a,l1_f,l2_f,l3_f,l4_f,l5_f,l6_f,l7_f,fext_l1,fext_l2,fext_l3,fext_l4,fext_l5,fext_l6,fext_l7,tau = initPlaceholdersRNEA(CUSTOM_TYPE)
   t1X0,t2X1,t3X2,t4X3,t5X4,t6X5,t7X6 = initMotionTransforms(CUSTOM_TYPE)
   l1_I,l2_I,l3_I,l4_I,l5_I,l6_I,l7_I = initInertiaTensors(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ)

   #----------------------------------------------------------------------------
   # Update Transforms
   #----------------------------------------------------------------------------
   t1X0,t2X1,t3X2,t4X3,t5X4,t6X5,t7X6 = updateTransforms_For_Wrapper(CUSTOM_TYPE,sinq,cosq,t1X0,t2X1,t3X2,t4X3,t5X4,t6X5,t7X6)

   #----------------------------------------------------------------------------
   # RNEA Forward Pass
   #----------------------------------------------------------------------------
   # First pass, link 'lbr_iiwa_link_1'
   l1_a = t1X0[:,[LZ]] * g;
   l1_a[AZ] += qdd[1];
   l1_v[AZ] = qd[1];   # l1_v = vJ, for the first link of a fixed base robot

   l1_f = l1_I * l1_a + vxIv(CUSTOM_TYPE,l1_v,l1_I,X,Y,Z,AX,AY,AZ,LX,LY,LZ) - fext_l1;

   # First pass, link 'l2'
   l2_v = (t2X1 * l1_v);
   l2_v[AZ] += qd[2];

   vcross = motionCrossProductMx(CUSTOM_TYPE,l2_v,X,Y,Z,AX,AY,AZ,LX,LY,LZ);

   l2_a = t2X1 * l1_a + vcross[:,[AZ]] * qd[2];
   l2_a[AZ] += qdd[2];

   l2_f = l2_I * l2_a + vxIv(CUSTOM_TYPE,l2_v,l2_I,X,Y,Z,AX,AY,AZ,LX,LY,LZ) - fext_l2;

   # First pass, link 'l3'
   l3_v = (t3X2 * l2_v);
   l3_v[AZ] += qd[3];

   vcross = motionCrossProductMx(CUSTOM_TYPE,l3_v,X,Y,Z,AX,AY,AZ,LX,LY,LZ);

   l3_a = t3X2 * l2_a + vcross[:,[AZ]] * qd[3];
   l3_a[AZ] += qdd[3];

   l3_f = l3_I * l3_a + vxIv(CUSTOM_TYPE,l3_v, l3_I,X,Y,Z,AX,AY,AZ,LX,LY,LZ) - fext_l3;

   # First pass, link 'l4'
   l4_v = (t4X3 * l3_v);
   l4_v[AZ] += qd[4];

   vcross = motionCrossProductMx(CUSTOM_TYPE,l4_v,X,Y,Z,AX,AY,AZ,LX,LY,LZ);

   l4_a = t4X3 * l3_a + vcross[:,[AZ]] * qd[4];
   l4_a[AZ] += qdd[4];

   l4_f = l4_I * l4_a + vxIv(CUSTOM_TYPE,l4_v,l4_I,X,Y,Z,AX,AY,AZ,LX,LY,LZ) - fext_l4;

   # First pass, link 'l5'
   l5_v = (t5X4 * l4_v);
   l5_v[AZ] += qd[5];

   vcross = motionCrossProductMx(CUSTOM_TYPE,l5_v,X,Y,Z,AX,AY,AZ,LX,LY,LZ);

   l5_a = t5X4 * l4_a + vcross[:,[AZ]] * qd[5];
   l5_a[AZ] += qdd[5];

   l5_f = l5_I * l5_a + vxIv(CUSTOM_TYPE,l5_v,l5_I,X,Y,Z,AX,AY,AZ,LX,LY,LZ) - fext_l5;

   # First pass, link 'l6'
   l6_v = (t6X5 * l5_v);
   l6_v[AZ] += qd[6];

   vcross = motionCrossProductMx(CUSTOM_TYPE,l6_v,X,Y,Z,AX,AY,AZ,LX,LY,LZ);

   l6_a = t6X5 * l5_a + vcross[:,[AZ]] * qd[6];
   l6_a[AZ] += qdd[6];

   l6_f = l6_I * l6_a + vxIv(CUSTOM_TYPE,l6_v,l6_I,X,Y,Z,AX,AY,AZ,LX,LY,LZ) - fext_l6;

   # First pass, link 'l7'
   l7_v = (t7X6 * l6_v);
   l7_v[AZ] += qd[7];

   vcross = motionCrossProductMx(CUSTOM_TYPE,l7_v,X,Y,Z,AX,AY,AZ,LX,LY,LZ);

   l7_a = t7X6 * l6_a + vcross[:,[AZ]] * qd[7];
   l7_a[AZ] += qdd[7];

   l7_f = l7_I * l7_a + vxIv(CUSTOM_TYPE,l7_v,l7_I,X,Y,Z,AX,AY,AZ,LX,LY,LZ) - fext_l7;

   #----------------------------------------------------------------------------
   # RNEA Backward Pass
   #----------------------------------------------------------------------------
   # Link 'l7'
   l6_f += transpose(t7X6) * l7_f;
   # Link 'l6'
   l5_f += transpose(t6X5) * l6_f;
   # Link 'l5'
   l4_f += transpose(t5X4) * l5_f;
   # Link 'l4'
   l3_f += transpose(t4X3) * l4_f;
   # Link 'l3'
   l2_f += transpose(t3X2) * l3_f;
   # Link 'l2'
   l1_f += transpose(t2X1) * l2_f;

   v = zeros(CUSTOM_TYPE,42)
   a = zeros(CUSTOM_TYPE,42)
   f = zeros(CUSTOM_TYPE,42)
   v[1+6*0 : 6*1] .= vec(l1_v)
   v[1+6*1 : 6*2] .= vec(l2_v)
   v[1+6*2 : 6*3] .= vec(l3_v)
   v[1+6*3 : 6*4] .= vec(l4_v)
   v[1+6*4 : 6*5] .= vec(l5_v)
   v[1+6*5 : 6*6] .= vec(l6_v)
   v[1+6*6 : 6*7] .= vec(l7_v)
   a[1+6*0 : 6*1] .= vec(l1_a)
   a[1+6*1 : 6*2] .= vec(l2_a)
   a[1+6*2 : 6*3] .= vec(l3_a)
   a[1+6*3 : 6*4] .= vec(l4_a)
   a[1+6*4 : 6*5] .= vec(l5_a)
   a[1+6*5 : 6*6] .= vec(l6_a)
   a[1+6*6 : 6*7] .= vec(l7_a)
   f[1+6*0 : 6*1] .= vec(l1_f)
   f[1+6*1 : 6*2] .= vec(l2_f)
   f[1+6*2 : 6*3] .= vec(l3_f)
   f[1+6*3 : 6*4] .= vec(l4_f)
   f[1+6*4 : 6*5] .= vec(l5_f)
   f[1+6*5 : 6*6] .= vec(l6_f)
   f[1+6*6 : 6*7] .= vec(l7_f)
   return v,a,f
end

#-------------------------------------------------------------------------------
# RNEA Gradient
#-------------------------------------------------------------------------------

function fwdPassPerLink(CUSTOM_TYPE, li, qd, tcurrXprev, lprev_v, lprev_a, lcurr_I, lcurr_v,
                        lprev_dvi_dq, lprev_dvi_dqd, lprev_dai_dq, lprev_dai_dqd, S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)

   # 1: [dXji_du, dSi_du, dvji_du, dcji_du] = jcalc(jtype(i), qi, qdi)
   #----- u = q
   lcurr_dvji_dq = zeros(CUSTOM_TYPE,6,7) # Since dSi_dq is zero for most common joint types
   #----- u = qd
   lcurr_dvji_dqd = zeros(CUSTOM_TYPE,6,7)
   lcurr_dvji_dqd[:,li] += S_rev # if u == qi, Si

   # 2: diXlami_du = dXj_du * Xt(i), but we won't explicitly compute this term

   # 3: dvi_du = (diXlami_du * vlami) + (iXlami * dvlami_du) + dvj_du
   #----- u = q
   dvi_dq_term1 = zeros(CUSTOM_TYPE,6,7)               # if u != qi, diXlami_du is zero
   iXlami_vlami = (tcurrXprev * lprev_v)
   iXlami_vlami_mcross = motionCrossProductMx(CUSTOM_TYPE,iXlami_vlami,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   # Column-wise operation of the spatial vector on the motion set Si
   iXlami_vlami_mcross_Si = iXlami_vlami_mcross * S_rev
   dvi_dq_term1[:,li] += iXlami_vlami_mcross_Si # else for qi, (iXlami * vlami) x Si
   dvi_dq_term2 = (tcurrXprev * lprev_dvi_dq)   # for all q,  (iXlami * dvlami_dq)
   lcurr_dvi_dq = dvi_dq_term1 + dvi_dq_term2 + lcurr_dvji_dq
   #----- u = qd
   dvi_dqd_term1 = zeros(CUSTOM_TYPE,6,7)              # if u != qi, diXlami_du is zero
   dvi_dqd_term2 = (tcurrXprev * lprev_dvi_dqd) # for all qd, (iXlami * dvlami_dqd)
   lcurr_dvi_dqd = dvi_dqd_term1 + dvi_dqd_term2 + lcurr_dvji_dqd

   # 4: dhi_du = Ii * dvi_du
   #----- u = q
   lcurr_dhi_dq  = lcurr_I * lcurr_dvi_dq
   #----- u = qd
   lcurr_dhi_dqd = lcurr_I * lcurr_dvi_dqd

   # 5: dai_du = (diXlami_du * alami) + (iXlami * dalami_du) + (dSi_du * qdd) +
   #             (dcj_du) + (dvi_du x vj) + (vi x dvj_du)
   lcurr_vji = S_rev*qd[li]
   #----- u = q
   dai_dq_term1 = zeros(CUSTOM_TYPE,6,7)               # if u != qi, diXlami_du is zero
   iXlami_alami = (tcurrXprev * lprev_a)
   iXlami_alami_mcross = motionCrossProductMx(CUSTOM_TYPE,iXlami_alami,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   # Column-wise operation of the spatial vector on the motion set Si
   iXlami_alami_mcross_Si = iXlami_alami_mcross * S_rev
   dai_dq_term1[:,li] += iXlami_alami_mcross_Si # else for qi, (iXlami * alami) x Si
   dai_dq_term2 = (tcurrXprev * lprev_dai_dq)   # for all q,  (iXlami * dalami_dq)
   dai_dq_term3 = zeros(CUSTOM_TYPE,6,7)  # dSi_dq is zero for most common joint types
   dai_dq_term4 = zeros(CUSTOM_TYPE,6,7)  # zero for most common joint types
   dai_dq_term5 = zeros(CUSTOM_TYPE,6,7)
   for ui in 1:7 # for all inputs
      dvi_dqi = lcurr_dvi_dq[:,ui]
      dvi_dqi_mcross = motionCrossProductMx(CUSTOM_TYPE,dvi_dqi,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
      dvi_dqi_mcross_vji = (dvi_dqi_mcross * lcurr_vji)
      dai_dq_term5[:,ui] += dvi_dqi_mcross_vji
   end
   dai_dq_term6 = zeros(CUSTOM_TYPE,6,7)  # zero for most common joint types
   lcurr_dai_dq  = dai_dq_term1 + dai_dq_term2 + dai_dq_term3 +
                dai_dq_term4 + dai_dq_term5 + dai_dq_term6
   #----- u = qd
   dai_dqd_term1 = zeros(CUSTOM_TYPE,6,7)            # if u != qi, diXlami_du is zero
   dai_dqd_term2 = (tcurrXprev * lprev_dai_dqd) # for all qd, (iXlami * dalami_dqd)
   dai_dqd_term3 = zeros(CUSTOM_TYPE,6,7) # dSi_dq = 0 for most common joint types
   dai_dqd_term4 = zeros(CUSTOM_TYPE,6,7) # zero for most common joint types
   dai_dqd_term5 = zeros(CUSTOM_TYPE,6,7)
   for ui in 1:7 # for all inputs
      dvi_dqdi = lcurr_dvi_dqd[:,ui]
      dvi_dqdi_mcross = motionCrossProductMx(CUSTOM_TYPE,dvi_dqdi,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
      dvi_dqdi_mcross_vji = (dvi_dqdi_mcross * lcurr_vji)
      dai_dqd_term5[:,ui] += dvi_dqdi_mcross_vji
   end
   dai_dqd_term6 = zeros(CUSTOM_TYPE,6,7)
   lcurr_v_mcross = motionCrossProductMx(CUSTOM_TYPE,lcurr_v,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   lcurr_v_mcross_Si = (lcurr_v_mcross * S_rev)
   dai_dqd_term6[:,li] += lcurr_v_mcross_Si # if u == qdi, (vi x Si), else zero
   lcurr_dai_dqd = dai_dqd_term1 + dai_dqd_term2 + dai_dqd_term3 +
                dai_dqd_term4 + dai_dqd_term5 + dai_dqd_term6

   # 6: dfi_du = (Ii * dai_du) + (dvi_du x* hi) + (vi x* dhi_du)
   lcurr_hi = (lcurr_I * lcurr_v)  # hi is (Ii * vi)
   vi_fcross = forceCrossProductMx(CUSTOM_TYPE,lcurr_v,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   #----- u = q
   dfi_dq_term1 = lcurr_I * lcurr_dai_dq
   dfi_dq_term2 = zeros(CUSTOM_TYPE,6,7)
   for ui in 1:7 # for all inputs
      dvi_dqi = lcurr_dvi_dq[:,ui]
      dvi_dqi_fcross = forceCrossProductMx(CUSTOM_TYPE,dvi_dqi,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
      # Operator m x* hi is linear operator with spatial skew matrix representation
      dvi_dqi_fcross_hi = dvi_dqi_fcross * lcurr_hi
      dfi_dq_term2[:,ui] += dvi_dqi_fcross_hi
   end
   dfi_dq_term3 = vi_fcross * lcurr_dhi_dq
   lcurr_dfi_dq  = dfi_dq_term1 + dfi_dq_term2 + dfi_dq_term3
   #----- u = qd
   dfi_dqd_term1 = lcurr_I * lcurr_dai_dqd
   dfi_dqd_term2 = zeros(CUSTOM_TYPE,6,7)
   for ui in 1:7 # for all inputs
      dvi_dqdi = lcurr_dvi_dqd[:,ui]
      dvi_dqdi_fcross = forceCrossProductMx(CUSTOM_TYPE,dvi_dqdi,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
      # Operator m x* hi is linear operator with spatial skew matrix representation
      dvi_dqdi_fcross_hi = dvi_dqdi_fcross * lcurr_hi
      dfi_dqd_term2[:,ui] += dvi_dqdi_fcross_hi
   end
   dfi_dqd_term3 = vi_fcross * lcurr_dhi_dqd
   lcurr_dfi_dqd = dfi_dqd_term1 + dfi_dqd_term2 + dfi_dqd_term3
   
   return lcurr_dvi_dq, lcurr_dvi_dqd, lcurr_dai_dq, lcurr_dai_dqd, lcurr_dfi_dq, lcurr_dfi_dqd
end

function bwdPassPerLink(CUSTOM_TYPE, li, tcurrXprev, lcurr_f, lcurr_dfi_dq, lcurr_dfi_dqd,
                        lprev_dfi_dq_update, lprev_dfi_dqd_update, S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   # 1: dtaui_du = (dSiT_du * fi) + (SiT * dfi_du)
   SiT = transpose(S_rev)
   #----- u = q
   dtaui_dq_term1 = zeros(CUSTOM_TYPE,1,7)  # for most common joint types
   dtaui_dq_term2 = zeros(CUSTOM_TYPE,1,7)
   for ui in 1:7 # for all inputs
      SiT_dfi_dqi = (SiT * lcurr_dfi_dq[:,ui])
      dtaui_dq_term2[1,ui] += SiT_dfi_dqi[1]
   end
   lcurr_dtaui_dq = dtaui_dq_term1 + dtaui_dq_term2
   #----- u = qd
   dtaui_dqd_term1 = zeros(CUSTOM_TYPE,1,7) # since dSiT_dqd is zero
   dtaui_dqd_term2 = zeros(CUSTOM_TYPE,1,7)
   for ui in 1:7 # for all inputs
      SiT_dfi_dqdi = (SiT * lcurr_dfi_dqd[:,ui])
      dtaui_dqd_term2[1,ui] += SiT_dfi_dqdi[1]
   end
   lcurr_dtaui_dqd = dtaui_dqd_term1 + dtaui_dqd_term2

   # 3: dflami_du = dflami_du + (dlamiXi*_du * fi) + (lamiXi* * dfi_du)
   Si_fcross = forceCrossProductMx(CUSTOM_TYPE,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   Si_fcross_fi = (Si_fcross * lcurr_f) # (Si x* fi)
   lamiXistar = transpose(tcurrXprev)
   #----- u = q
   dflami_dq_term2 = zeros(CUSTOM_TYPE,6,7)
   dflami_dq_term2[:,li] += lamiXistar * Si_fcross_fi # if u == qi, lamiXi* * (Si x* fi)
   dflami_dq_term3 = lamiXistar * lcurr_dfi_dq
   lprev_dfi_dq_update = dflami_dq_term2 + dflami_dq_term3
   #----- u = qd
   dflami_dqd_term2 = zeros(CUSTOM_TYPE,6,7)
   dflami_dqd_term3 = lamiXistar * lcurr_dfi_dqd
   lprev_dfi_dqd_update = dflami_dqd_term2 + dflami_dqd_term3
   
   return lcurr_dtaui_dq, lcurr_dtaui_dqd, lprev_dfi_dq_update, lprev_dfi_dqd_update
end

function gradMiddle_For_Wrapper(CUSTOM_TYPE,sinq,cosq,qd,v,a,f)
    #----------------------------------------------------------------------------
    # Per-Robot Initialization
    #----------------------------------------------------------------------------
    X,Y,Z,AX,AY,AZ,LX,LY,LZ,g = initConstants(CUSTOM_TYPE)
    l1_v,l2_v,l3_v,l4_v,l5_v,l6_v,l7_v,l1_a,l2_a,l3_a,l4_a,l5_a,l6_a,l7_a,l1_f,l2_f,l3_f,l4_f,l5_f,l6_f,l7_f,fext_l1,fext_l2,fext_l3,fext_l4,fext_l5,fext_l6,fext_l7,tau = initPlaceholdersRNEA(CUSTOM_TYPE)
    t1X0,t2X1,t3X2,t4X3,t5X4,t6X5,t7X6 = initMotionTransforms(CUSTOM_TYPE)
    l1_I,l2_I,l3_I,l4_I,l5_I,l6_I,l7_I = initInertiaTensors(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
    S_rev = zeros(CUSTOM_TYPE,6,1)
    S_rev[AZ] = 1.0

    #----------------------------------------------------------------------------
    # Update Transforms and load vaf
    #----------------------------------------------------------------------------
    t1X0,t2X1,t3X2,t4X3,t5X4,t6X5,t7X6 = updateTransforms_For_Wrapper(CUSTOM_TYPE,sinq,cosq,t1X0,t2X1,t3X2,t4X3,t5X4,t6X5,t7X6)
    l1_v .= v[1+6*0 : 6*1]
    l2_v .= v[1+6*1 : 6*2]
    l3_v .= v[1+6*2 : 6*3]
    l4_v .= v[1+6*3 : 6*4]
    l5_v .= v[1+6*4 : 6*5]
    l6_v .= v[1+6*5 : 6*6]
    l7_v .= v[1+6*6 : 6*7]
    l1_a .= a[1+6*0 : 6*1]
    l2_a .= a[1+6*1 : 6*2]
    l3_a .= a[1+6*2 : 6*3]
    l4_a .= a[1+6*3 : 6*4]
    l5_a .= a[1+6*4 : 6*5]
    l6_a .= a[1+6*5 : 6*6]
    l7_a .= a[1+6*6 : 6*7]
    l1_f .= f[1+6*0 : 6*1]
    l2_f .= f[1+6*1 : 6*2]
    l3_f .= f[1+6*2 : 6*3]
    l4_f .= f[1+6*3 : 6*4]
    l5_f .= f[1+6*4 : 6*5]
    l6_f .= f[1+6*5 : 6*6]
    l7_f .= f[1+6*6 : 6*7]
    
    #==============================================================================#
    # FORWARD PASS
    #==============================================================================#

    #-------------------------------------------------------------------------------
    # World 0
    #-------------------------------------------------------------------------------
    l0_v = zeros(CUSTOM_TYPE,6,1)
    l0_a = zeros(CUSTOM_TYPE,6,1)
    l0_dvi_dq  = zeros(CUSTOM_TYPE,6,7)
    l0_dvi_dqd = zeros(CUSTOM_TYPE,6,7)
    l0_dai_dq  = zeros(CUSTOM_TYPE,6,7)
    l0_dai_dqd = zeros(CUSTOM_TYPE,6,7)

    #-------------------------------------------------------------------------------
    # -- World 0 --> Link 1
    #-------------------------------------------------------------------------------
    l1_dvi_dq  = zeros(CUSTOM_TYPE,6,7)
    l1_dvi_dqd = zeros(CUSTOM_TYPE,6,7)
    l1_dai_dq  = zeros(CUSTOM_TYPE,6,7)
    l1_dai_dqd = zeros(CUSTOM_TYPE,6,7)
    l1_dfi_dq  = zeros(CUSTOM_TYPE,6,7)
    l1_dfi_dqd = zeros(CUSTOM_TYPE,6,7)

    l1_dvi_dq, l1_dvi_dqd, 
    l1_dai_dq, l1_dai_dqd, 
    l1_dfi_dq, l1_dfi_dqd = fwdPassPerLink(CUSTOM_TYPE, 1, qd, t1X0, l0_v, l0_a, l1_I, l1_v,
                                           l0_dvi_dq, l0_dvi_dqd, l0_dai_dq, l0_dai_dqd,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)

    #-------------------------------------------------------------------------------
    # -- Link 1 --> Link 2
    #-------------------------------------------------------------------------------
    l2_dvi_dq  = zeros(CUSTOM_TYPE,6,7)
    l2_dvi_dqd = zeros(CUSTOM_TYPE,6,7)
    l2_dai_dq  = zeros(CUSTOM_TYPE,6,7)
    l2_dai_dqd = zeros(CUSTOM_TYPE,6,7)
    l2_dfi_dq  = zeros(CUSTOM_TYPE,6,7)
    l2_dfi_dqd = zeros(CUSTOM_TYPE,6,7)

    l2_dvi_dq, l2_dvi_dqd, 
    l2_dai_dq, l2_dai_dqd, 
    l2_dfi_dq, l2_dfi_dqd = fwdPassPerLink(CUSTOM_TYPE, 2, qd, t2X1, l1_v, l1_a, l2_I, l2_v,
                                           l1_dvi_dq, l1_dvi_dqd, l1_dai_dq, l1_dai_dqd,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)

    #-------------------------------------------------------------------------------
    # -- Link 2 --> Link 3
    #-------------------------------------------------------------------------------
    l3_dvi_dq  = zeros(CUSTOM_TYPE,6,7)
    l3_dvi_dqd = zeros(CUSTOM_TYPE,6,7)
    l3_dai_dq  = zeros(CUSTOM_TYPE,6,7)
    l3_dai_dqd = zeros(CUSTOM_TYPE,6,7)
    l3_dfi_dq  = zeros(CUSTOM_TYPE,6,7)
    l3_dfi_dqd = zeros(CUSTOM_TYPE,6,7)

    l3_dvi_dq, l3_dvi_dqd, 
    l3_dai_dq, l3_dai_dqd, 
    l3_dfi_dq, l3_dfi_dqd = fwdPassPerLink(CUSTOM_TYPE, 3, qd, t3X2, l2_v, l2_a, l3_I, l3_v,
                                           l2_dvi_dq, l2_dvi_dqd, l2_dai_dq, l2_dai_dqd,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)

    #-------------------------------------------------------------------------------
    # -- Link 3 --> Link 4
    #-------------------------------------------------------------------------------
    l4_dvi_dq  = zeros(CUSTOM_TYPE,6,7)
    l4_dvi_dqd = zeros(CUSTOM_TYPE,6,7)
    l4_dai_dq  = zeros(CUSTOM_TYPE,6,7)
    l4_dai_dqd = zeros(CUSTOM_TYPE,6,7)
    l4_dfi_dq  = zeros(CUSTOM_TYPE,6,7)
    l4_dfi_dqd = zeros(CUSTOM_TYPE,6,7)

    l4_dvi_dq, l4_dvi_dqd, 
    l4_dai_dq, l4_dai_dqd, 
    l4_dfi_dq, l4_dfi_dqd = fwdPassPerLink(CUSTOM_TYPE, 4, qd, t4X3, l3_v, l3_a, l4_I, l4_v,
                                           l3_dvi_dq, l3_dvi_dqd, l3_dai_dq, l3_dai_dqd,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)

    #-------------------------------------------------------------------------------
    # -- Link 4 --> Link 5
    #-------------------------------------------------------------------------------
    l5_dvi_dq  = zeros(CUSTOM_TYPE,6,7)
    l5_dvi_dqd = zeros(CUSTOM_TYPE,6,7)
    l5_dai_dq  = zeros(CUSTOM_TYPE,6,7)
    l5_dai_dqd = zeros(CUSTOM_TYPE,6,7)
    l5_dfi_dq  = zeros(CUSTOM_TYPE,6,7)
    l5_dfi_dqd = zeros(CUSTOM_TYPE,6,7)

    l5_dvi_dq, l5_dvi_dqd, 
    l5_dai_dq, l5_dai_dqd, 
    l5_dfi_dq, l5_dfi_dqd = fwdPassPerLink(CUSTOM_TYPE, 5, qd, t5X4, l4_v, l4_a, l5_I, l5_v,
                                           l4_dvi_dq, l4_dvi_dqd, l4_dai_dq, l4_dai_dqd,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)

    #-------------------------------------------------------------------------------
    # -- Link 5 --> Link 6
    #-------------------------------------------------------------------------------
    l6_dvi_dq  = zeros(CUSTOM_TYPE,6,7)
    l6_dvi_dqd = zeros(CUSTOM_TYPE,6,7)
    l6_dai_dq  = zeros(CUSTOM_TYPE,6,7)
    l6_dai_dqd = zeros(CUSTOM_TYPE,6,7)
    l6_dfi_dq  = zeros(CUSTOM_TYPE,6,7)
    l6_dfi_dqd = zeros(CUSTOM_TYPE,6,7)

    l6_dvi_dq, l6_dvi_dqd, 
    l6_dai_dq, l6_dai_dqd, 
    l6_dfi_dq, l6_dfi_dqd = fwdPassPerLink(CUSTOM_TYPE, 6, qd, t6X5, l5_v, l5_a, l6_I, l6_v,
                                           l5_dvi_dq, l5_dvi_dqd, l5_dai_dq, l5_dai_dqd,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)

    #-------------------------------------------------------------------------------
    # -- Link 6 --> Link 7
    #-------------------------------------------------------------------------------
    l7_dvi_dq  = zeros(CUSTOM_TYPE,6,7)
    l7_dvi_dqd = zeros(CUSTOM_TYPE,6,7)
    l7_dai_dq  = zeros(CUSTOM_TYPE,6,7)
    l7_dai_dqd = zeros(CUSTOM_TYPE,6,7)
    l7_dfi_dq  = zeros(CUSTOM_TYPE,6,7)
    l7_dfi_dqd = zeros(CUSTOM_TYPE,6,7)

    l7_dvi_dq, l7_dvi_dqd, 
    l7_dai_dq, l7_dai_dqd, 
    l7_dfi_dq, l7_dfi_dqd = fwdPassPerLink(CUSTOM_TYPE, 7, qd, t7X6, l6_v, l6_a, l7_I, l7_v,
                                           l6_dvi_dq, l6_dvi_dqd, l6_dai_dq, l6_dai_dqd,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)

    #==============================================================================#
    # BACKWARD PASS
    #==============================================================================#

    #-------------------------------------------------------------------------------
    # -- Link 6 <-- Link 7
    #-------------------------------------------------------------------------------
    l7_dtaui_dq  = zeros(CUSTOM_TYPE,1,7)
    l7_dtaui_dqd = zeros(CUSTOM_TYPE,1,7)
    l6_dfi_dq_update  = zeros(CUSTOM_TYPE,6,7)
    l6_dfi_dqd_update = zeros(CUSTOM_TYPE,6,7)

    l7_dtaui_dq, l7_dtaui_dqd,
    l6_dfi_dq_update, l6_dfi_dqd_update = bwdPassPerLink(CUSTOM_TYPE, 7, t7X6, l7_f, l7_dfi_dq, l7_dfi_dqd,
                                                         l6_dfi_dq_update, l6_dfi_dqd_update,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
    l6_dfi_dq  += l6_dfi_dq_update
    l6_dfi_dqd += l6_dfi_dqd_update

    #-------------------------------------------------------------------------------
    # -- Link 5 <-- Link 6
    #-------------------------------------------------------------------------------
    l6_dtaui_dq  = zeros(CUSTOM_TYPE,1,7)
    l6_dtaui_dqd = zeros(CUSTOM_TYPE,1,7)
    l5_dfi_dq_update  = zeros(CUSTOM_TYPE,6,7)
    l5_dfi_dqd_update = zeros(CUSTOM_TYPE,6,7)

    l6_dtaui_dq, l6_dtaui_dqd,
    l5_dfi_dq_update, l5_dfi_dqd_update = bwdPassPerLink(CUSTOM_TYPE, 6, t6X5, l6_f, l6_dfi_dq, l6_dfi_dqd,
                                                         l5_dfi_dq_update, l5_dfi_dqd_update,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
    l5_dfi_dq  += l5_dfi_dq_update
    l5_dfi_dqd += l5_dfi_dqd_update

    #-------------------------------------------------------------------------------
    # -- Link 4 <-- Link 5
    #-------------------------------------------------------------------------------
    l5_dtaui_dq  = zeros(CUSTOM_TYPE,1,7)
    l5_dtaui_dqd = zeros(CUSTOM_TYPE,1,7)
    l4_dfi_dq_update  = zeros(CUSTOM_TYPE,6,7)
    l4_dfi_dqd_update = zeros(CUSTOM_TYPE,6,7)

    l5_dtaui_dq, l5_dtaui_dqd,
    l4_dfi_dq_update, l4_dfi_dqd_update = bwdPassPerLink(CUSTOM_TYPE, 5, t5X4, l5_f, l5_dfi_dq, l5_dfi_dqd,
                                                         l4_dfi_dq_update, l4_dfi_dqd_update,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
    l4_dfi_dq  += l4_dfi_dq_update
    l4_dfi_dqd += l4_dfi_dqd_update

    #-------------------------------------------------------------------------------
    # -- Link 3 <-- Link 4
    #-------------------------------------------------------------------------------
    l4_dtaui_dq  = zeros(CUSTOM_TYPE,1,7)
    l4_dtaui_dqd = zeros(CUSTOM_TYPE,1,7)
    l3_dfi_dq_update  = zeros(CUSTOM_TYPE,6,7)
    l3_dfi_dqd_update = zeros(CUSTOM_TYPE,6,7)

    l4_dtaui_dq, l4_dtaui_dqd,
    l3_dfi_dq_update, l3_dfi_dqd_update = bwdPassPerLink(CUSTOM_TYPE, 4, t4X3, l4_f, l4_dfi_dq, l4_dfi_dqd,
                                                         l3_dfi_dq_update, l3_dfi_dqd_update,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
    l3_dfi_dq  += l3_dfi_dq_update
    l3_dfi_dqd += l3_dfi_dqd_update

    #-------------------------------------------------------------------------------
    # -- Link 2 <-- Link 3
    #-------------------------------------------------------------------------------
    l3_dtaui_dq  = zeros(CUSTOM_TYPE,1,7)
    l3_dtaui_dqd = zeros(CUSTOM_TYPE,1,7)
    l2_dfi_dq_update  = zeros(CUSTOM_TYPE,6,7)
    l2_dfi_dqd_update = zeros(CUSTOM_TYPE,6,7)

    l3_dtaui_dq, l3_dtaui_dqd,
    l2_dfi_dq_update, l2_dfi_dqd_update = bwdPassPerLink(CUSTOM_TYPE, 3, t3X2, l3_f, l3_dfi_dq, l3_dfi_dqd,
                                                         l2_dfi_dq_update, l2_dfi_dqd_update,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
    l2_dfi_dq  += l2_dfi_dq_update
    l2_dfi_dqd += l2_dfi_dqd_update

    #-------------------------------------------------------------------------------
    # -- Link 1 <-- Link 2
    #-------------------------------------------------------------------------------
    l2_dtaui_dq  = zeros(CUSTOM_TYPE,1,7)
    l2_dtaui_dqd = zeros(CUSTOM_TYPE,1,7)
    l1_dfi_dq_update  = zeros(CUSTOM_TYPE,6,7)
    l1_dfi_dqd_update = zeros(CUSTOM_TYPE,6,7)

    l2_dtaui_dq, l2_dtaui_dqd,
    l1_dfi_dq_update, l1_dfi_dqd_update = bwdPassPerLink(CUSTOM_TYPE, 2, t2X1, l2_f, l2_dfi_dq, l2_dfi_dqd,
                                                         l1_dfi_dq_update, l1_dfi_dqd_update,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
    l1_dfi_dq  += l1_dfi_dq_update
    l1_dfi_dqd += l1_dfi_dqd_update

    #-------------------------------------------------------------------------------
    # -- World 0 <-- Link 1
    #-------------------------------------------------------------------------------
    l1_dtaui_dq  = zeros(CUSTOM_TYPE,1,7)
    l1_dtaui_dqd = zeros(CUSTOM_TYPE,1,7)
    l0_dfi_dq_update  = zeros(CUSTOM_TYPE,6,7)
    l0_dfi_dqd_update = zeros(CUSTOM_TYPE,6,7)

    l1_dtaui_dq, l1_dtaui_dqd,
    l0_dfi_dq_update, l0_dfi_dqd_update = bwdPassPerLink(CUSTOM_TYPE, 1, t1X0, l1_f, l1_dfi_dq, l1_dfi_dqd,
                                                         l0_dfi_dq_update, l0_dfi_dqd_update,S_rev,X,Y,Z,AX,AY,AZ,LX,LY,LZ)

    
    #-------------------------------------------------------------------------------
    # Package and Return
    #-------------------------------------------------------------------------------
    dIDdu = zeros(CUSTOM_TYPE,7,14)
    dIDdu[1,1:7] = l1_dtaui_dq
    dIDdu[2,1:7] = l2_dtaui_dq
    dIDdu[3,1:7] = l3_dtaui_dq
    dIDdu[4,1:7] = l4_dtaui_dq
    dIDdu[5,1:7] = l5_dtaui_dq
    dIDdu[6,1:7] = l6_dtaui_dq
    dIDdu[7,1:7] = l7_dtaui_dq
    dIDdu[1,8:14] = l1_dtaui_dqd
    dIDdu[2,8:14] = l2_dtaui_dqd
    dIDdu[3,8:14] = l3_dtaui_dqd
    dIDdu[4,8:14] = l4_dtaui_dqd
    dIDdu[5,8:14] = l5_dtaui_dqd
    dIDdu[6,8:14] = l6_dtaui_dqd
    dIDdu[7,8:14] = l7_dtaui_dqd
    dIDdu[1:7,8:14] += 0.5*Matrix(I, 7, 7)

    return vec(dIDdu)
end

#-------------------------------------------------------------------------------
# Final Wrappers
#-------------------------------------------------------------------------------

function safeConvert(CONVERT_TYPE, val_in)
    try
        val_out = convert(CONVERT_TYPE, val_in)
        return val_out
    catch e
        println("Cannot represent a number in the desired type\n---------\n")
        display(val_in)
        println("\n---------\n")
        val_out = val_in % CONVERT_TYPE
        return val_out
    end
end

function dynamicsGradient_Middle_Wrapper(sincosq, qd, vaf)
    # split split x to q, qd
    nq = length(qd)
    sinq = sincosq[1 : nq]
    cosq = sincosq[nq + 1 : 2*nq]
    v = vaf[1 : 6*nq]
    a = vaf[6*nq + 1 : 12*nq]
    f = vaf[12*nq + 1 : 18*nq]
    try
        # convert to correct types
       _sinq = safeConvert(Array{DYNAMICS_TYPE,1},sinq)
       _cosq = safeConvert(Array{DYNAMICS_TYPE,1},cosq)
       _qd = safeConvert(Array{DYNAMICS_TYPE,1},qd)
       _v = safeConvert(Array{DYNAMICS_TYPE,1},v)
       _a = safeConvert(Array{DYNAMICS_TYPE,1},a)
       _f = safeConvert(Array{DYNAMICS_TYPE,1},f)
       # then compute
       _cdu = gradMiddle_For_Wrapper(DYNAMICS_TYPE, _sinq, _cosq, _qd, _v, _a, _f)
       # convert back
       cdu = convert(typeof(qd),_cdu)
       return cdu
    catch e
        println("caught an error")
        # println(e)
    end
end

function dynamicsGradient_1stHalf_Wrapper(sincosq, qd, qdd)
    # split split x to q, qd
    nq = length(qd)
    sinq = sincosq[1 : nq]
    cosq = sincosq[nq + 1 : 2*nq]
    try
        # convert to correct types
        _sinq = safeConvert(Array{DYNAMICS_TYPE,1},sinq)
        _cosq = safeConvert(Array{DYNAMICS_TYPE,1},cosq)
        _qd = safeConvert(Array{DYNAMICS_TYPE,1},qd)
        _qdd = safeConvert(Array{DYNAMICS_TYPE,1},qdd)
        # then compute
        _v, _a, _f = rnea_For_Wrapper(DYNAMICS_TYPE,sinq,cosq,qd,qdd)
        _cdu = gradMiddle_For_Wrapper(DYNAMICS_TYPE, _sinq, _cosq, _qd, _v, _a, _f)
        # convert back
        cdu = convert(typeof(qd),_cdu)
        return cdu
    catch e
        println("caught an error")
    end
end

function dynamicsGradient_Middle_Wrapper2(q, qd, vaf)
    # split split x to q, qd
    nq = length(qd)
    v = vaf[1 : 6*nq]
    a = vaf[6*nq + 1 : 12*nq]
    f = vaf[12*nq + 1 : 18*nq]
    try
        # convert to correct types
       _q = safeConvert(Array{DYNAMICS_TYPE,1},q)
       _sinq = sin.(q)
       _cosq = cos.(q)
       _qd = safeConvert(Array{DYNAMICS_TYPE,1},qd)
       _v = safeConvert(Array{DYNAMICS_TYPE,1},v)
       _a = safeConvert(Array{DYNAMICS_TYPE,1},a)
       _f = safeConvert(Array{DYNAMICS_TYPE,1},f)
       # then compute
       _cdu = gradMiddle_For_Wrapper(DYNAMICS_TYPE, _sinq, _cosq, _qd, _v, _a, _f)
       # convert back
       cdu = convert(typeof(qd),_cdu)
       return cdu
    catch e
        println("caught an error")
    end
end

function dynamicsGradient_1stHalf_Wrapper2(q, qd, qdd)
    # split split x to q, qd
    nq = length(qd)
    try
        # convert to correct types
        _q = safeConvert(Array{DYNAMICS_TYPE,1},q)
        _sinq = sin.(q)
        _cosq = cos.(q)
        _qd = safeConvert(Array{DYNAMICS_TYPE,1},qd)
        _qdd = safeConvert(Array{DYNAMICS_TYPE,1},qdd)
        # then compute
        _v, _a, _f = rnea_For_Wrapper(DYNAMICS_TYPE,sinq,cosq,qd,qdd)
        _cdu = gradMiddle_For_Wrapper(DYNAMICS_TYPE, _sinq, _cosq, _qd, _v, _a, _f)
        # convert back
        cdu = convert(typeof(qd),_cdu)
        return cdu
    catch e
        println("caught an error")
    end
end

#-------------------------------------------------------------------------------
# Test
#-------------------------------------------------------------------------------
function main()
   CUSTOM_TYPE = Float64 ###Fixed{Int32,24} # data type
   # Get New Inputs
   q1   = CUSTOM_TYPE(0.297287985) 
   q2   = CUSTOM_TYPE(0.382395968)
   q3   = CUSTOM_TYPE(-0.597634477)
   q4   = CUSTOM_TYPE(-0.010445245)
   q5   = CUSTOM_TYPE(-0.839026854)
   q6   = CUSTOM_TYPE(0.311111338)
   q7   = CUSTOM_TYPE(2.295087824)
   q    = [q1, q2, q3, q4, q5, q6, q7]
   qd1  = CUSTOM_TYPE(0.999904659) 
   qd2  = CUSTOM_TYPE(0.251662183)
   qd3  = CUSTOM_TYPE(0.986666367)
   qd4  = CUSTOM_TYPE(0.555751087)
   qd5  = CUSTOM_TYPE(0.437107975)
   qd6  = CUSTOM_TYPE(0.42471785)
   qd7  = CUSTOM_TYPE(0.773223048)
   qd   = [qd1, qd2, qd3, qd4, qd5, qd6, qd7]
   qdd1 = CUSTOM_TYPE(0.671362351)
   qdd2 = CUSTOM_TYPE(2.085405497)
   qdd3 = CUSTOM_TYPE(-0.920425575) 
   qdd4 = CUSTOM_TYPE(5.464981623)
   qdd5 = CUSTOM_TYPE(25.85650645)
   qdd6 = CUSTOM_TYPE(105.449175)
   qdd7 = CUSTOM_TYPE(52.12766742)
   qdd  = [qdd1, qdd2, qdd3, qdd4, qdd5, qdd6, qdd7]
   sinq = zeros(CUSTOM_TYPE,7)
   cosq = zeros(CUSTOM_TYPE,7)
   for i in 1:7
      sinq[i] = sin(q[i])
      cosq[i] = cos(q[i])
   end
   v, a, f = rnea_For_Wrapper(CUSTOM_TYPE,sinq,cosq,qd,qdd)
   dIDdu = gradMiddle_For_Wrapper(CUSTOM_TYPE,sinq,cosq,qd,v,a,f)
   println("dID/dq\n",dIDdu[1,1:7])
   println(dIDdu[2,1:7])
   println(dIDdu[3,1:7])
   println(dIDdu[4,1:7])
   println(dIDdu[5,1:7])
   println(dIDdu[6,1:7])
   println(dIDdu[7,1:7])
   println("dID/dqd\n",dIDdu[1,8:14])
   println(dIDdu[2,8:14])
   println(dIDdu[3,8:14])
   println(dIDdu[4,8:14])
   println(dIDdu[5,8:14])
   println(dIDdu[6,8:14])
   println(dIDdu[7,8:14])
end

# main() # comment out when importing into things