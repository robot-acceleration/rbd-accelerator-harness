# iDot
#
# Based on RobCoGen's Inverse Dynamics for iiwa and Carpentier et al., RSS 2018

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra

#-------------------------------------------------------------------------------
# Inertia Matrix * Vector
#-------------------------------------------------------------------------------
# (24 mult, 18 add)
#    AX AY AZ LX LY LZ
# AX  *  *  *     *  *
# AY  *  *  *  *     *
# AZ  *  *  *  *  *
# LX     *  *  *
# LY  *     *     *
# LZ  *  *           *
function iDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
              imat,vec)

   # wires
   ivec_out = zeros(CUSTOM_TYPE,6,1)

   # multiplications (24 in ||)
   ivec_AX_AX = imat[AX,AX]*vec[AX]
   ivec_AX_AY = imat[AX,AY]*vec[AY]
   ivec_AX_AZ = imat[AX,AZ]*vec[AZ]
   ivec_AX_LY = imat[AX,LY]*vec[LY]
   ivec_AX_LZ = imat[AX,LZ]*vec[LZ]

   ivec_AY_AX = imat[AY,AX]*vec[AX]
   ivec_AY_AY = imat[AY,AY]*vec[AY]
   ivec_AY_AZ = imat[AY,AZ]*vec[AZ]
   ivec_AY_LX = imat[AY,LX]*vec[LX]
   ivec_AY_LZ = imat[AY,LZ]*vec[LZ]

   ivec_AZ_AX = imat[AZ,AX]*vec[AX]
   ivec_AZ_AY = imat[AZ,AY]*vec[AY]
   ivec_AZ_AZ = imat[AZ,AZ]*vec[AZ]
   ivec_AZ_LX = imat[AZ,LX]*vec[LX]
   ivec_AZ_LY = imat[AZ,LY]*vec[LY]

   ivec_LX_AY = imat[LX,AY]*vec[AY]
   ivec_LX_AZ = imat[LX,AZ]*vec[AZ]
   ivec_LX_LX = imat[LX,LX]*vec[LX]

   ivec_LY_AX = imat[LY,AX]*vec[AX]
   ivec_LY_AZ = imat[LY,AZ]*vec[AZ]
   ivec_LY_LY = imat[LY,LY]*vec[LY]

   ivec_LZ_AX = imat[LZ,AX]*vec[AX]
   ivec_LZ_AY = imat[LZ,AY]*vec[AY]
   ivec_LZ_LZ = imat[LZ,LZ]*vec[LZ]

   # layer 1 of additions (9 in ||)
   ivec_AX_AXAY = ivec_AX_AX + ivec_AX_AY
   ivec_AX_AZLY = ivec_AX_AZ + ivec_AX_LY

   ivec_AY_AXAY = ivec_AY_AX + ivec_AY_AY
   ivec_AY_AZLX = ivec_AY_AZ + ivec_AY_LX

   ivec_AZ_AXAY = ivec_AZ_AX + ivec_AZ_AY
   ivec_AZ_AZLX = ivec_AZ_AZ + ivec_AZ_LX

   ivec_LX_AYAZ = ivec_LX_AY + ivec_LX_AZ

   ivec_LY_AXAZ = ivec_LY_AX + ivec_LY_AZ

   ivec_LZ_AXAY = ivec_LZ_AX + ivec_LZ_AY

   # layer 2 of additions (6 in ||)
   ivec_AX_AXAYAZLY = ivec_AX_AXAY + ivec_AX_AZLY

   ivec_AY_AXAYAZLX = ivec_AY_AXAY + ivec_AY_AZLX

   ivec_AZ_AXAYAZLX = ivec_AZ_AXAY + ivec_AZ_AZLX

   ivec_LX_AYAZLX = ivec_LX_AYAZ + ivec_LX_LX

   ivec_LY_AXAZLY = ivec_LY_AXAZ + ivec_LY_LY

   ivec_LZ_AXAYLZ = ivec_LZ_AXAY + ivec_LZ_LZ

   # layer 3 of additions (3 in ||)
   ivec_AX_AXAYAZLYLZ = ivec_AX_AXAYAZLY + ivec_AX_LZ

   ivec_AY_AXAYAZLXLZ = ivec_AY_AXAYAZLX + ivec_AY_LZ

   ivec_AZ_AXAYAZLXLY = ivec_AZ_AXAYAZLX + ivec_AZ_LY

   # output
   ivec_out[AX] = ivec_AX_AXAYAZLYLZ
   ivec_out[AY] = ivec_AY_AXAYAZLXLZ
   ivec_out[AZ] = ivec_AZ_AXAYAZLXLY
   ivec_out[LX] = ivec_LX_AYAZLX
   ivec_out[LY] = ivec_LY_AXAZLY
   ivec_out[LZ] = ivec_LZ_AXAYLZ

   return ivec_out
end
