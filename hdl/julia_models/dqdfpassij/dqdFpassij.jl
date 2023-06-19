# dqdFpassij
#
# Based on RobCoGen's Inverse Dynamics for iiwa and Carpentier et al., RSS 2018

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra
include("../xdot/xDot.jl") # xdot
include("../idot/iDot.jl") # idot
include("../fxdot/fxDot.jl") # fxdot
include("../vjdot/vjDot.jl") # vjdot

#-------------------------------------------------------------------------------
# dqd Forward Pass for Link i Input j (dvi/dqdj, dai/dqdj, dfi/dqdj)
#-------------------------------------------------------------------------------
function dqdFpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                   tcurrXprev,lcurr_I,
                   lcurr_qd,lcurr_v,mcross,
                   dvdqd_xdot_vec,dadqd_xdot_vec)

   # internal wires and state
   # dv/dqd
   lcurr_dvi_dqdj = zeros(CUSTOM_TYPE,6,1)
   # da/dqd
   dai_dqdj_term1 = zeros(CUSTOM_TYPE,6,1)
   dai_dqdj_term2 = zeros(CUSTOM_TYPE,6,1)
   lcurr_dai_dqdj = zeros(CUSTOM_TYPE,6,1)
   # df/dqd
   dfi_dqdj_term1 = zeros(CUSTOM_TYPE,6,1)
   dfi_dqdj_term2 = zeros(CUSTOM_TYPE,6,1)
   dfi_dqdj_term3 = zeros(CUSTOM_TYPE,6,1)
   lcurr_hi      = zeros(CUSTOM_TYPE,6,1)
   lcurr_dhi_dqdj = zeros(CUSTOM_TYPE,6,1)
   lcurr_dfi_dqdj_12 = zeros(CUSTOM_TYPE,6,1)
   lcurr_dfi_dqdj = zeros(CUSTOM_TYPE,6,1)

   # dv/dqd
   lcurr_dvi_dqdj  = xDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                         tcurrXprev,dvdqd_xdot_vec,false)
   # mx1
   if mcross
      lcurr_dvi_dqdj[AZ] += 1.0;
   end

   # da/dqd
   dai_dqdj_term1 = xDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                        tcurrXprev,dadqd_xdot_vec,false)
   dai_dqdj_term2 = vjDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                         lcurr_qd,lcurr_dvi_dqdj)
   # (4 add)
   lcurr_dai_dqdj[AX] = dai_dqdj_term1[AX] + dai_dqdj_term2[AX]
   lcurr_dai_dqdj[AY] = dai_dqdj_term1[AY] + dai_dqdj_term2[AY]
   lcurr_dai_dqdj[AZ] = dai_dqdj_term1[AZ]
   lcurr_dai_dqdj[LX] = dai_dqdj_term1[LX] + dai_dqdj_term2[LX]
   lcurr_dai_dqdj[LY] = dai_dqdj_term1[LY] + dai_dqdj_term2[LY]
   lcurr_dai_dqdj[LZ] = dai_dqdj_term1[LZ]
   # mxv
   if mcross
      mxv = zeros(CUSTOM_TYPE,6,1)
      mxv[AX] =  lcurr_v[AY]
      mxv[AY] = -lcurr_v[AX]
      mxv[AZ] = 0.0
      mxv[LX] =  lcurr_v[LY]
      mxv[LY] = -lcurr_v[LX]
      mxv[LZ] = 0.0
      lcurr_dai_dqdj[AX] += mxv[AX]
      lcurr_dai_dqdj[AY] += mxv[AY]
      lcurr_dai_dqdj[AZ] += mxv[AZ]
      lcurr_dai_dqdj[LX] += mxv[LX]
      lcurr_dai_dqdj[LY] += mxv[LY]
      lcurr_dai_dqdj[LZ] += mxv[LZ]
   end

   # df/dqd
   dfi_dqdj_term1 = iDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                        lcurr_I,lcurr_dai_dqdj)
   lcurr_hi = iDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                   lcurr_I,lcurr_v)
   dfi_dqdj_term2 = fxDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                         lcurr_dvi_dqdj,lcurr_hi)
   lcurr_dhi_dqdj = iDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                         lcurr_I,lcurr_dvi_dqdj)
   dfi_dqdj_term3 = fxDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                         lcurr_v,lcurr_dhi_dqdj)
   # (6 add)
   lcurr_dfi_dqdj_12[AX] = dfi_dqdj_term1[AX] + dfi_dqdj_term2[AX]
   lcurr_dfi_dqdj_12[AY] = dfi_dqdj_term1[AY] + dfi_dqdj_term2[AY]
   lcurr_dfi_dqdj_12[AZ] = dfi_dqdj_term1[AZ] + dfi_dqdj_term2[AZ]
   lcurr_dfi_dqdj_12[LX] = dfi_dqdj_term1[LX] + dfi_dqdj_term2[LX]
   lcurr_dfi_dqdj_12[LY] = dfi_dqdj_term1[LY] + dfi_dqdj_term2[LY]
   lcurr_dfi_dqdj_12[LZ] = dfi_dqdj_term1[LZ] + dfi_dqdj_term2[LZ]
   # (6 add)
   lcurr_dfi_dqdj[AX] = lcurr_dfi_dqdj_12[AX] + dfi_dqdj_term3[AX]
   lcurr_dfi_dqdj[AY] = lcurr_dfi_dqdj_12[AY] + dfi_dqdj_term3[AY]
   lcurr_dfi_dqdj[AZ] = lcurr_dfi_dqdj_12[AZ] + dfi_dqdj_term3[AZ]
   lcurr_dfi_dqdj[LX] = lcurr_dfi_dqdj_12[LX] + dfi_dqdj_term3[LX]
   lcurr_dfi_dqdj[LY] = lcurr_dfi_dqdj_12[LY] + dfi_dqdj_term3[LY]
   lcurr_dfi_dqdj[LZ] = lcurr_dfi_dqdj_12[LZ] + dfi_dqdj_term3[LZ]

   # output
   return lcurr_dvi_dqdj, lcurr_dai_dqdj, lcurr_dfi_dqdj
end
