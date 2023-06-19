# fxDot
#
# Based on RobCoGen's Inverse Dynamics for iiwa and Carpentier et al., RSS 2018

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra

#-------------------------------------------------------------------------------
# Force Cross Matrix * Vector
#-------------------------------------------------------------------------------
# (18 mult, 12 add)
function fxDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
               fxvec,dotvec)

   # wires
   fxdotvec_out = zeros(CUSTOM_TYPE,6,1)

   # multiplications (18 in ||)
   fxdotvec_AZ_AY = -fxvec[AZ]*dotvec[AY]
   fxdotvec_AY_AZ =  fxvec[AY]*dotvec[AZ]
   fxdotvec_LZ_LY = -fxvec[LZ]*dotvec[LY]
   fxdotvec_LY_LZ =  fxvec[LY]*dotvec[LZ]

   fxdotvec_AZ_AX =  fxvec[AZ]*dotvec[AX]
   fxdotvec_AX_AZ = -fxvec[AX]*dotvec[AZ]
   fxdotvec_LZ_LX =  fxvec[LZ]*dotvec[LX]
   fxdotvec_LX_LZ = -fxvec[LX]*dotvec[LZ]

   fxdotvec_AY_AX = -fxvec[AY]*dotvec[AX]
   fxdotvec_AX_AY =  fxvec[AX]*dotvec[AY]
   fxdotvec_LY_LX = -fxvec[LY]*dotvec[LX]
   fxdotvec_LX_LY =  fxvec[LX]*dotvec[LY]

   fxdotvec_AZ_LY = -fxvec[AZ]*dotvec[LY]
   fxdotvec_AY_LZ =  fxvec[AY]*dotvec[LZ]

   fxdotvec_AZ_LX =  fxvec[AZ]*dotvec[LX]
   fxdotvec_AX_LZ = -fxvec[AX]*dotvec[LZ]

   fxdotvec_AY_LX = -fxvec[AY]*dotvec[LX]
   fxdotvec_AX_LY =  fxvec[AX]*dotvec[LY]

   # layer 1 of additions (9 in ||)
   fxdotvec_AX1 = fxdotvec_AZ_AY + fxdotvec_AY_AZ
   fxdotvec_AX2 = fxdotvec_LZ_LY + fxdotvec_LY_LZ

   fxdotvec_AY1 = fxdotvec_AZ_AX + fxdotvec_AX_AZ
   fxdotvec_AY2 = fxdotvec_LZ_LX + fxdotvec_LX_LZ

   fxdotvec_AZ1 = fxdotvec_AY_AX + fxdotvec_AX_AY
   fxdotvec_AZ2 = fxdotvec_LY_LX + fxdotvec_LX_LY

   fxdotvec_LX = fxdotvec_AZ_LY + fxdotvec_AY_LZ

   fxdotvec_LY = fxdotvec_AZ_LX + fxdotvec_AX_LZ

   fxdotvec_LZ = fxdotvec_AY_LX + fxdotvec_AX_LY

   # layer 2 of additions (3 in ||)
   fxdotvec_AX = fxdotvec_AX1 + fxdotvec_AX2

   fxdotvec_AY = fxdotvec_AY1 + fxdotvec_AY2

   fxdotvec_AZ = fxdotvec_AZ1 + fxdotvec_AZ2

   # output
   fxdotvec_out[AX] = fxdotvec_AX
   fxdotvec_out[AY] = fxdotvec_AY
   fxdotvec_out[AZ] = fxdotvec_AZ
   fxdotvec_out[LX] = fxdotvec_LX
   fxdotvec_out[LY] = fxdotvec_LY
   fxdotvec_out[LZ] = fxdotvec_LZ

   return fxdotvec_out
end
