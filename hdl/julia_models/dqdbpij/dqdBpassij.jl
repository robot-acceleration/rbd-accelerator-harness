# dqdBpassij
#
# Based on RobCoGen's Inverse Dynamics for iiwa and Carpentier et al., RSS 2018

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra
include("../xtdot/xtDot.jl") # xtdot

#-------------------------------------------------------------------------------
# dqd Backward Pass for Link i Input j (dti/dqdj, dfi/dqdj)
#-------------------------------------------------------------------------------
function dqdBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                    tcurrXprev,lcurr_dfi_dqd,lprev_dfi_dqd)

   # internal wires and state
   dtaui_dqdj_out = 0.0
   xtdot_out = zeros(CUSTOM_TYPE,6,1)
   lprev_dfi_dqd_updated = zeros(CUSTOM_TYPE,6,1)
   lprev_dfi_dqd_out = zeros(CUSTOM_TYPE,6,1)

   # get dtau/dqd
   dtaui_dqdj_out = lcurr_dfi_dqd[AZ]

   # update df/dqd
   xtdot_out = xtDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                     tcurrXprev,lcurr_dfi_dqd)
   lprev_dfi_dqd_updated = lprev_dfi_dqd + xtdot_out

   # output
   lprev_dfi_dqd_out = lprev_dfi_dqd_updated;

   return dtaui_dqdj_out,lprev_dfi_dqd_out
end
