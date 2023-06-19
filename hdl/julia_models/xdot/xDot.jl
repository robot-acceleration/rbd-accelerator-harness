# xDot
#
# Based on RobCoGen's Inverse Dynamics for iiwa and Carpentier et al., RSS 2018

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra

#-------------------------------------------------------------------------------
# Transformation Matrix * Vector (if mcross, then Motion Cross Matrix Column AZ)
#-------------------------------------------------------------------------------
# (23 mult, 17 add)
#    AX AY AZ LX LY LZ
# AX  *  *  *
# AY  *  *  *
# AZ     *  *
# LX  *  *  *  *  *  *
# LY  *  *  *  *  *  *
# LZ  *           *  *
function xDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
              xform,vec,mcross)
   # wires
   xvec_out = zeros(CUSTOM_TYPE,6,1)

   # multiplications (23 in ||)
   xvec_AX_AX = xform[AX,AX]*vec[AX]
   xvec_AX_AY = xform[AX,AY]*vec[AY]
   xvec_AX_AZ = xform[AX,AZ]*vec[AZ]

   xvec_AY_AX = xform[AY,AX]*vec[AX]
   xvec_AY_AY = xform[AY,AY]*vec[AY]
   xvec_AY_AZ = xform[AY,AZ]*vec[AZ]

   xvec_AZ_AY = xform[AZ,AY]*vec[AY]
   xvec_AZ_AZ = xform[AZ,AZ]*vec[AZ]

   xvec_LX_AX = xform[LX,AX]*vec[AX]
   xvec_LX_AY = xform[LX,AY]*vec[AY]
   xvec_LX_AZ = xform[LX,AZ]*vec[AZ]
   xvec_LX_LX = xform[LX,LX]*vec[LX]
   xvec_LX_LY = xform[LX,LY]*vec[LY]
   xvec_LX_LZ = xform[LX,LZ]*vec[LZ]

   xvec_LY_AX = xform[LY,AX]*vec[AX]
   xvec_LY_AY = xform[LY,AY]*vec[AY]
   xvec_LY_AZ = xform[LY,AZ]*vec[AZ]
   xvec_LY_LX = xform[LY,LX]*vec[LX]
   xvec_LY_LY = xform[LY,LY]*vec[LY]
   xvec_LY_LZ = xform[LY,LZ]*vec[LZ]

   xvec_LZ_AX = xform[LZ,AX]*vec[AX]
   xvec_LZ_LY = xform[LZ,LY]*vec[LY]
   xvec_LZ_LZ = xform[LZ,LZ]*vec[LZ]

   # layer 1 of additions (10 in ||)
   xvec_AX_AXAY = xvec_AX_AX + xvec_AX_AY

   xvec_AY_AXAY = xvec_AY_AX + xvec_AY_AY

   xvec_AZ_AYAZ = xvec_AZ_AY + xvec_AZ_AZ

   xvec_LX_AXAY = xvec_LX_AX + xvec_LX_AY
   xvec_LX_AZLX = xvec_LX_AZ + xvec_LX_LX
   xvec_LX_LYLZ = xvec_LX_LY + xvec_LX_LZ

   xvec_LY_AXAY = xvec_LY_AX + xvec_LY_AY
   xvec_LY_AZLX = xvec_LY_AZ + xvec_LY_LX
   xvec_LY_LYLZ = xvec_LY_LY + xvec_LY_LZ

   xvec_LZ_AXLY = xvec_LZ_AX + xvec_LZ_LY

   # layer 2 of additions (5 in ||)
   xvec_AX_AXAYAZ = xvec_AX_AXAY + xvec_AX_AZ

   xvec_AY_AXAYAZ = xvec_AY_AXAY + xvec_AY_AZ

   xvec_LX_AXAYAZLX = xvec_LX_AXAY + xvec_LX_AZLX

   xvec_LY_AXAYAZLX = xvec_LY_AXAY + xvec_LY_AZLX

   xvec_LZ_AXLYLZ = xvec_LZ_AXLY + xvec_LZ_LZ

   # layer 3 of additions (2 in ||)
   xvec_LX_AXAYAZLXLYLZ = xvec_LX_AXAYAZLX + xvec_LX_LYLZ

   xvec_LY_AXAYAZLXLYLZ = xvec_LY_AXAYAZLX + xvec_LY_LYLZ

   # muxes for mcross
   if mcross
      xvec_out[AX] =  xvec_AY_AXAYAZ
      xvec_out[AY] = -xvec_AX_AXAYAZ
      xvec_out[AZ] = 0.0
      xvec_out[LX] =  xvec_LY_AXAYAZLXLYLZ
      xvec_out[LY] = -xvec_LX_AXAYAZLXLYLZ
      xvec_out[LZ] = 0.0
   else
      xvec_out[AX] = xvec_AX_AXAYAZ
      xvec_out[AY] = xvec_AY_AXAYAZ
      xvec_out[AZ] = xvec_AZ_AYAZ
      xvec_out[LX] = xvec_LX_AXAYAZLXLYLZ
      xvec_out[LY] = xvec_LY_AXAYAZLXLYLZ
      xvec_out[LZ] = xvec_LZ_AXLYLZ
   end

   return xvec_out
end
