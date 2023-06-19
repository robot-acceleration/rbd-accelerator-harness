# dqFPij
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
# dq Forward Pass (Link i, Input j) Control Unit
#-------------------------------------------------------------------------------
function dqFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                tcurrXprev,lcurr_I,
                lcurr_qd,lcurr_v,mcross,
                dvdq_xdot_vec,dadq_xdot_vec)

   # internal wires and state
   # inputs
   s1_bool,s2_bool,s3_bool = false,false,false
   s1r1_in,s1r2_in,s1r3_in,s1r4_in,
   s2r1_in,s2r2_in,s2r3_in,s2r4_in,s2r5_in,
   s3r1_in,s3r2_in,s3r3_in,s3r4_in,s3r5_in = zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),CUSTOM_TYPE(0.0),zeros(CUSTOM_TYPE,6,1),
                                             zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),CUSTOM_TYPE(0.0),zeros(CUSTOM_TYPE,6,1),
                                             zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1)
   # outputs
   s1r1_out,s1r2_out,s1r3_out,s1r4_out,s1r5_out,
   s2r1_out,s2r2_out,s2r3_out,s2r4_out,s2r5_out,
   s3r1_out,s3r2_out,s3r3_out = zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),CUSTOM_TYPE(0.0),zeros(CUSTOM_TYPE,6,1),
                                zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),
                                zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1)
   # registers
   s1reg1,s1reg2,s1reg3,s1reg4,
   s2reg1,s2reg2,s2reg3,s2reg4,s2reg5,
   s3reg1,s3reg2,s3reg3,s3reg4,s3reg5 = zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),CUSTOM_TYPE(0.0),zeros(CUSTOM_TYPE,6,1),
                                        zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),CUSTOM_TYPE(0.0),zeros(CUSTOM_TYPE,6,1),
                                        zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1),zeros(CUSTOM_TYPE,6,1)

   #----------------------------------------------------------------------------
   # stage 1
   #----------------------------------------------------------------------------
   # set booleans
   s1_bool,s2_bool,s3_bool = true,false,false
   # load inputs to registers
   s1reg1,s1reg2,s1reg3,s1reg4 = lcurr_v,dadq_xdot_vec,lcurr_qd,dvdq_xdot_vec
   s1r1_in,s1r2_in,s1r3_in,s1r4_in = s1reg1,s1reg2,s1reg3,s1reg4
   # stage 1 computation
   s1r1_out,s1r2_out,s1r3_out,s1r4_out,s1r5_out,
   s2r1_out,s2r2_out,s2r3_out,s2r4_out,s2r5_out,
   s3r1_out,s3r2_out,s3r3_out = dqFPij_folded(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                                              tcurrXprev,lcurr_I,mcross,
                                              s1_bool,s2_bool,s3_bool,
                                              s1r1_in,s1r2_in,s1r3_in,s1r4_in,
                                              s2r1_in,s2r2_in,s2r3_in,s2r4_in,s2r5_in,
                                              s3r1_in,s3r2_in,s3r3_in,s3r4_in,s3r5_in)
   #----------------------------------------------------------------------------
   # stage 2
   #----------------------------------------------------------------------------
   # set booleans
   s1_bool,s2_bool,s3_bool = false,true,false
   # load inputs to registers
   s2reg1,s2reg2,s2reg3,s2reg4,s2reg5 = s1r1_out,s1r2_out,s1r3_out,s1r4_out,s1r5_out
   s2r1_in,s2r2_in,s2r3_in,s2r4_in,s2r5_in = s2reg1,s2reg2,s2reg3,s2reg4,s2reg5
   # stage 2 computation
   s1r1_out,s1r2_out,s1r3_out,s1r4_out,s1r5_out,
   s2r1_out,s2r2_out,s2r3_out,s2r4_out,s2r5_out,
   s3r1_out,s3r2_out,s3r3_out = dqFPij_folded(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                                              tcurrXprev,lcurr_I,mcross,
                                              s1_bool,s2_bool,s3_bool,
                                              s1r1_in,s1r2_in,s1r3_in,s1r4_in,
                                              s2r1_in,s2r2_in,s2r3_in,s2r4_in,s2r5_in,
                                              s3r1_in,s3r2_in,s3r3_in,s3r4_in,s3r5_in)
   #----------------------------------------------------------------------------
   # stage 3
   #----------------------------------------------------------------------------
   # set booleans
   s1_bool,s2_bool,s3_bool = false,false,true
   # load inputs to registers
   s3reg1,s3reg2,s3reg3,s3reg4,s3reg5 = s2r1_out,s2r2_out,s2r3_out,s2r4_out,s2r5_out
   s3r1_in,s3r2_in,s3r3_in,s3r4_in,s3r5_in = s3reg1,s3reg2,s3reg3,s3reg4,s3reg5
   # stage 3 computation
   s1r1_out,s1r2_out,s1r3_out,s1r4_out,s1r5_out,
   s2r1_out,s2r2_out,s2r3_out,s2r4_out,s2r5_out,
   s3r1_out,s3r2_out,s3r3_out = dqFPij_folded(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                                              tcurrXprev,lcurr_I,mcross,
                                              s1_bool,s2_bool,s3_bool,
                                              s1r1_in,s1r2_in,s1r3_in,s1r4_in,
                                              s2r1_in,s2r2_in,s2r3_in,s2r4_in,s2r5_in,
                                              s3r1_in,s3r2_in,s3r3_in,s3r4_in,s3r5_in)

   # assign outputs
   lcurr_dfi_dqj,lcurr_dai_dqj,lcurr_dvi_dqj = s3r1_out,s3r2_out,s3r3_out

   # outputs
   return lcurr_dvi_dqj, lcurr_dai_dqj, lcurr_dfi_dqj
end

#-------------------------------------------------------------------------------
# dq Forward Pass (Link i, Input j) Folded
#-------------------------------------------------------------------------------
function dqFPij_folded(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                       tcurrXprev,lcurr_I,mcross,
                       s1_bool,s2_bool,s3_bool,
                       s1r1_in,s1r2_in,s1r3_in,s1r4_in,
                       s2r1_in,s2r2_in,s2r3_in,s2r4_in,s2r5_in,
                       s3r1_in,s3r2_in,s3r3_in,s3r4_in,s3r5_in)

   # internal wires and state
   # fxdot
   fxdot_in_fxvec  = zeros(CUSTOM_TYPE,6,1)
   fxdot_in_dotvec = zeros(CUSTOM_TYPE,6,1)
   fxdot_out       = zeros(CUSTOM_TYPE,6,1)
   # idot
   idot_in_vec  = zeros(CUSTOM_TYPE,6,1)
   idot_out     = zeros(CUSTOM_TYPE,6,1)
   # xdot
   xdot_in_vec    = zeros(CUSTOM_TYPE,6,1)
   xdot_out       = zeros(CUSTOM_TYPE,6,1)
   # vjdot
   vjdot_out = zeros(CUSTOM_TYPE,6,1)
   # add3
   add3_temp = zeros(CUSTOM_TYPE,6,1)
   add3_out  = zeros(CUSTOM_TYPE,6,1)
   # add2
   add2_out  = zeros(CUSTOM_TYPE,6,1)

   # input muxes
   # fxdot
   if (s2_bool == true)
      fxdot_in_fxvec  = s2r5_in
      fxdot_in_dotvec = s2r2_in
   else
      fxdot_in_fxvec  = s3r2_in
      fxdot_in_dotvec = s3r3_in
   end
   # idot
   if     (s1_bool == true)
      idot_in_vec = s1r1_in
   elseif (s2_bool == true)
      idot_in_vec = s2r5_in
   else
      idot_in_vec = s3r4_in
   end
   # xdot
   if (s1_bool == true)
      xdot_in_vec = s1r4_in
   else
      xdot_in_vec = s2r3_in
   end

   # functional units
   # fxdot
   fxdot_out = fxDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                     fxdot_in_fxvec,fxdot_in_dotvec)
   # idot
   idot_out = iDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                   lcurr_I,idot_in_vec)
   # xdot
   xdot_out = xDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                   tcurrXprev,xdot_in_vec,mcross)
   # vjdot
   vjdot_out = vjDot(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                     s2r4_in,s2r5_in)
   # add3
   # (6 adds)
   add3_temp[AX] = s3r1_in[AX] + fxdot_out[AX]
   add3_temp[AY] = s3r1_in[AY] + fxdot_out[AY]
   add3_temp[AZ] = s3r1_in[AZ] + fxdot_out[AZ]
   add3_temp[LX] = s3r1_in[LX] + fxdot_out[LX]
   add3_temp[LY] = s3r1_in[LY] + fxdot_out[LY]
   add3_temp[LZ] = s3r1_in[LZ] + fxdot_out[LZ]
   # (6 adds)
   add3_out[AX] = add3_temp[AX] + idot_out[AX]
   add3_out[AY] = add3_temp[AY] + idot_out[AY]
   add3_out[AZ] = add3_temp[AZ] + idot_out[AZ]
   add3_out[LX] = add3_temp[LX] + idot_out[LX]
   add3_out[LY] = add3_temp[LY] + idot_out[LY]
   add3_out[LZ] = add3_temp[LZ] + idot_out[LZ]
   # add2
   # (4 adds)
   add2_out[AX] = xdot_out[AX] + vjdot_out[AX]
   add2_out[AY] = xdot_out[AY] + vjdot_out[AY]
   add2_out[AZ] = xdot_out[AZ]
   add2_out[LX] = xdot_out[LX] + vjdot_out[LX]
   add2_out[LY] = xdot_out[LY] + vjdot_out[LY]
   add2_out[LZ] = xdot_out[LZ]

   # output assignments
   s1r1_out = s1r1_in
   s1r2_out = idot_out
   s1r3_out = s1r2_in
   s1r4_out = s1r3_in
   s1r5_out = xdot_out
   s2r1_out = fxdot_out
   s2r2_out = s2r1_in
   s2r3_out = idot_out
   s2r4_out = add2_out
   s2r5_out = s2r5_in
   s3r1_out = add3_out
   s3r2_out = s3r4_in
   s3r3_out = s3r5_in

   # outputs
   return s1r1_out,s1r2_out,s1r3_out,s1r4_out,s1r5_out,
          s2r1_out,s2r2_out,s2r3_out,s2r4_out,s2r5_out,
          s3r1_out,s3r2_out,s3r3_out
end
