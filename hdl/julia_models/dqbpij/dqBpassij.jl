# dqBpassij
#
# Based on RobCoGen's Inverse Dynamics for iiwa and Carpentier et al., RSS 2018

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra
include("../xtdot/xtDot.jl") # xtdot

#-------------------------------------------------------------------------------
# dq Backward Pass for Link i Input j (dti/dqj, dfi/dqj)
#-------------------------------------------------------------------------------
function dqBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                   tcurrXprev,lcurr_f,lcurr_dfi_dq,fcross,lprev_dfi_dq)

   # internal wires and state
   xtdot_out  = zeros(CUSTOM_TYPE,6,1)
   fcross_out = zeros(CUSTOM_TYPE,6,1)
   lprev_dfi_dq_xtdot_updated  = zeros(CUSTOM_TYPE,6,1)
   lprev_dfi_dq_fcross_updated = zeros(CUSTOM_TYPE,6,1)
   lprev_dfi_dq_out = zeros(CUSTOM_TYPE,6,1)

   # get dtau/dq
   dtaui_dq_out = lcurr_dfi_dq[AZ]

   # update df/dq
   xtdot_out = xtDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                     tcurrXprev,lcurr_dfi_dq)
   lprev_dfi_dq_xtdot_updated = lprev_dfi_dq + xtdot_out

   # fcross
   ficross = zeros(CUSTOM_TYPE,6,1)
   ficross[AX] = -lcurr_f[AY]
   ficross[AY] =  lcurr_f[AX]
   ficross[AZ] = 0.0
   ficross[LX] = -lcurr_f[LY]
   ficross[LY] =  lcurr_f[LX]
   ficross[LZ] = 0.0
   fcross_out = xtDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                      tcurrXprev,ficross)
   lprev_dfi_dq_fcross_updated = lprev_dfi_dq_xtdot_updated + fcross_out

   # output mux
   if (fcross)
      lprev_dfi_dq_out = lprev_dfi_dq_fcross_updated;
   else
      lprev_dfi_dq_out = lprev_dfi_dq_xtdot_updated;
   end

   return dtaui_dq_out,lprev_dfi_dq_out
end
