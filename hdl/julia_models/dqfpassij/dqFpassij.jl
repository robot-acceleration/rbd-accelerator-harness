# dqFpassij
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
# dq Forward Pass for Link i Input j (dvi/dqj, dai/dqj, dfi/dqj)
#-------------------------------------------------------------------------------
function dqFpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                   tcurrXprev,lcurr_I,
                   lcurr_qd,lcurr_v,mcross,
                   dvdq_xdot_vec,dadq_xdot_vec)

   # internal wires and state
   # dv/dq
   lcurr_dvi_dqj = zeros(CUSTOM_TYPE,6,1)
   # da/dq
   dai_dqj_term1 = zeros(CUSTOM_TYPE,6,1)
   dai_dqj_term2 = zeros(CUSTOM_TYPE,6,1)
   lcurr_dai_dqj = zeros(CUSTOM_TYPE,6,1)
   # df/dq
   dfi_dqj_term1 = zeros(CUSTOM_TYPE,6,1)
   dfi_dqj_term2 = zeros(CUSTOM_TYPE,6,1)
   dfi_dqj_term3 = zeros(CUSTOM_TYPE,6,1)
   lcurr_hi      = zeros(CUSTOM_TYPE,6,1)
   lcurr_dhi_dqj = zeros(CUSTOM_TYPE,6,1)
   lcurr_dfi_dqj_12 = zeros(CUSTOM_TYPE,6,1)
   lcurr_dfi_dqj = zeros(CUSTOM_TYPE,6,1)

   # dv/dq
   lcurr_dvi_dqj  = xDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                         tcurrXprev,dvdq_xdot_vec,mcross)

   # da/dq
   dai_dqj_term1 = xDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                        tcurrXprev,dadq_xdot_vec,mcross)
   dai_dqj_term2 = vjDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                         lcurr_qd,lcurr_dvi_dqj)
   # (4 add)
   lcurr_dai_dqj[AX] = dai_dqj_term1[AX] + dai_dqj_term2[AX]
   lcurr_dai_dqj[AY] = dai_dqj_term1[AY] + dai_dqj_term2[AY]
   lcurr_dai_dqj[AZ] = dai_dqj_term1[AZ]
   lcurr_dai_dqj[LX] = dai_dqj_term1[LX] + dai_dqj_term2[LX]
   lcurr_dai_dqj[LY] = dai_dqj_term1[LY] + dai_dqj_term2[LY]
   lcurr_dai_dqj[LZ] = dai_dqj_term1[LZ]

   # df/dq
   dfi_dqj_term1 = iDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                        lcurr_I,lcurr_dai_dqj)
   lcurr_hi = iDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                   lcurr_I,lcurr_v)
   dfi_dqj_term2 = fxDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                         lcurr_dvi_dqj,lcurr_hi)
   lcurr_dhi_dqj = iDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                         lcurr_I,lcurr_dvi_dqj)
   dfi_dqj_term3 = fxDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                         lcurr_v,lcurr_dhi_dqj)
   # (6 add)
   lcurr_dfi_dqj_12[AX] = dfi_dqj_term1[AX] + dfi_dqj_term2[AX]
   lcurr_dfi_dqj_12[AY] = dfi_dqj_term1[AY] + dfi_dqj_term2[AY]
   lcurr_dfi_dqj_12[AZ] = dfi_dqj_term1[AZ] + dfi_dqj_term2[AZ]
   lcurr_dfi_dqj_12[LX] = dfi_dqj_term1[LX] + dfi_dqj_term2[LX]
   lcurr_dfi_dqj_12[LY] = dfi_dqj_term1[LY] + dfi_dqj_term2[LY]
   lcurr_dfi_dqj_12[LZ] = dfi_dqj_term1[LZ] + dfi_dqj_term2[LZ]
   # (6 add)
   lcurr_dfi_dqj[AX] = lcurr_dfi_dqj_12[AX] + dfi_dqj_term3[AX]
   lcurr_dfi_dqj[AY] = lcurr_dfi_dqj_12[AY] + dfi_dqj_term3[AY]
   lcurr_dfi_dqj[AZ] = lcurr_dfi_dqj_12[AZ] + dfi_dqj_term3[AZ]
   lcurr_dfi_dqj[LX] = lcurr_dfi_dqj_12[LX] + dfi_dqj_term3[LX]
   lcurr_dfi_dqj[LY] = lcurr_dfi_dqj_12[LY] + dfi_dqj_term3[LY]
   lcurr_dfi_dqj[LZ] = lcurr_dfi_dqj_12[LZ] + dfi_dqj_term3[LZ]

   # output
   return lcurr_dvi_dqj, lcurr_dai_dqj, lcurr_dfi_dqj
end
