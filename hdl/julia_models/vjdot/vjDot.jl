# vjDot
#
# Based on RobCoGen's Inverse Dynamics for iiwa and Carpentier et al., RSS 2018

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra

#-------------------------------------------------------------------------------
# * vj term from dai/dq
#-------------------------------------------------------------------------------
# (4 mult)
function vjDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
               vjval,colvec)

   # wires
   vjvec_out = zeros(CUSTOM_TYPE,6,1)

   # multiplications (4 in ||)
   vjvec_AX =  vjval*colvec[AY]
   vjvec_AY = -vjval*colvec[AX]
   vjvec_LX =  vjval*colvec[LY]
   vjvec_LY = -vjval*colvec[LX]

   # output
   vjvec_out[AX] = vjvec_AX
   vjvec_out[AY] = vjvec_AY
   vjvec_out[AZ] = 0
   vjvec_out[LX] = vjvec_LX
   vjvec_out[LY] = vjvec_LY
   vjvec_out[LZ] = 0

   return vjvec_out
end
