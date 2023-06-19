# xtDot
#
# Based on RobCoGen's Inverse Dynamics for iiwa and Carpentier et al., RSS 2018

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra

#-------------------------------------------------------------------------------
# Transformation Matrix^T * Vector (if fcross, then Force Cross Matrix Column AZ)
#-------------------------------------------------------------------------------
# (23 mult, 17 add)
#    AX AY AZ LX LY LZ
# AX  *  *     *  *  *
# AY  *  *  *  *  *
# AZ  *  *  *  *  *
# LX           *  *
# LY           *  *  *
# LZ           *  *  *
function xtDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
               xform,vec)
   # wires
   xTvec_out = zeros(CUSTOM_TYPE,6,1)

   # multiplications (23 in ||)
   xTvec_AX_AX = xform[AX,AX]*vec[AX]
   xTvec_AX_AY = xform[AY,AX]*vec[AY]
   xTvec_AX_LX = xform[LX,AX]*vec[LX]
   xTvec_AX_LY = xform[LY,AX]*vec[LY]
   xTvec_AX_LZ = xform[LZ,AX]*vec[LZ]

   xTvec_AY_AX = xform[AX,AY]*vec[AX]
   xTvec_AY_AY = xform[AY,AY]*vec[AY]
   xTvec_AY_AZ = xform[AZ,AY]*vec[AZ]
   xTvec_AY_LX = xform[LX,AY]*vec[LX]
   xTvec_AY_LY = xform[LY,AY]*vec[LY]

   xTvec_AZ_AX = xform[AX,AZ]*vec[AX]
   xTvec_AZ_AY = xform[AY,AZ]*vec[AY]
   xTvec_AZ_AZ = xform[AZ,AZ]*vec[AZ]
   xTvec_AZ_LX = xform[LX,AZ]*vec[LX]
   xTvec_AZ_LY = xform[LY,AZ]*vec[LY]

   xTvec_LX_LX = xform[LX,LX]*vec[LX]
   xTvec_LX_LY = xform[LY,LX]*vec[LY]

   xTvec_LY_LX = xform[LX,LY]*vec[LX]
   xTvec_LY_LY = xform[LY,LY]*vec[LY]
   xTvec_LY_LZ = xform[LZ,LY]*vec[LZ]

   xTvec_LZ_LX = xform[LX,LZ]*vec[LX]
   xTvec_LZ_LY = xform[LY,LZ]*vec[LY]
   xTvec_LZ_LZ = xform[LZ,LZ]*vec[LZ]

   # layer 1 of additions (9 in ||)
   xTvec_AX_AXAY = xTvec_AX_AX + xTvec_AX_AY
   xTvec_AX_LXLY = xTvec_AX_LX + xTvec_AX_LY

   xTvec_AY_AXAY = xTvec_AY_AX + xTvec_AY_AY
   xTvec_AY_AZLX = xTvec_AY_AZ + xTvec_AY_LX

   xTvec_AZ_AXAY = xTvec_AZ_AX + xTvec_AZ_AY
   xTvec_AZ_AZLX = xTvec_AZ_AZ + xTvec_AZ_LX

   xTvec_LX_LXLY = xTvec_LX_LX + xTvec_LX_LY

   xTvec_LY_LXLY = xTvec_LY_LX + xTvec_LY_LY

   xTvec_LZ_LXLY = xTvec_LZ_LX + xTvec_LZ_LY

   # layer 2 of additions (5 in ||)
   xTvec_AX_AXAYLXLY = xTvec_AX_AXAY + xTvec_AX_LXLY

   xTvec_AY_AXAYAZLX = xTvec_AY_AXAY + xTvec_AY_AZLX

   xTvec_AZ_AXAYAZLX = xTvec_AZ_AXAY + xTvec_AZ_AZLX

   xTvec_LY_LXLYLZ = xTvec_LY_LXLY + xTvec_LY_LZ

   xTvec_LZ_LXLYLZ = xTvec_LZ_LXLY + xTvec_LZ_LZ

   # layer 3 of additions (3 in ||)
   xTvec_AX_AXAYLXLYLZ = xTvec_AX_AXAYLXLY + xTvec_AX_LZ

   xTvec_AY_AXAYAZLXLY = xTvec_AY_AXAYAZLX + xTvec_AY_LY

   xTvec_AZ_AXAYAZLXLY = xTvec_AZ_AXAYAZLX + xTvec_AZ_LY

   # output
   xTvec_out[AX] = xTvec_AX_AXAYLXLYLZ
   xTvec_out[AY] = xTvec_AY_AXAYAZLXLY
   xTvec_out[AZ] = xTvec_AZ_AXAYAZLXLY
   xTvec_out[LX] = xTvec_LX_LXLY
   xTvec_out[LY] = xTvec_LY_LXLYLZ
   xTvec_out[LZ] = xTvec_LZ_LXLYLZ

   return xTvec_out
end
