# bpRow
#
# Based on RobCoGen's Inverse Dynamics for iiwa and Carpentier et al., RSS 2018

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra
include("../dqbpij/dqBpassij.jl") # dqBPassij
include("../dqdbpij/dqdBpassij.jl") # dqdBPassij

#-------------------------------------------------------------------------------
# Backward Pass Row Unit
#-------------------------------------------------------------------------------
function bpRow(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
               link,Xi_curr,fi_curr_vec,
               dfidq_curr_mat_in,dfidqd_curr_mat_in,
               dfidq_prev_mat_in,dfidqd_prev_mat_in)

   # internal wires and state
   dtauidq_curr_vec_out = zeros(CUSTOM_TYPE,1,7)
   dtauidqd_curr_vec_out = zeros(CUSTOM_TYPE,1,7)
   dfidq_prev_mat_out = zeros(CUSTOM_TYPE,6,7)
   dfidqd_prev_mat_out = zeros(CUSTOM_TYPE,6,7)

   # booleans
   fx1 = (link == 1) ? true : false;
   fx2 = (link == 2) ? true : false;
   fx3 = (link == 3) ? true : false;
   fx4 = (link == 4) ? true : false;
   fx5 = (link == 5) ? true : false;
   fx6 = (link == 6) ? true : false;
   fx7 = (link == 7) ? true : false;

   # inputs
   dfidq1_curr_vec = dfidq_curr_mat_in[:,1]
   dfidq2_curr_vec = dfidq_curr_mat_in[:,2]
   dfidq3_curr_vec = dfidq_curr_mat_in[:,3]
   dfidq4_curr_vec = dfidq_curr_mat_in[:,4]
   dfidq5_curr_vec = dfidq_curr_mat_in[:,5]
   dfidq6_curr_vec = dfidq_curr_mat_in[:,6]
   dfidq7_curr_vec = dfidq_curr_mat_in[:,7]
   dfidqd1_curr_vec = dfidqd_curr_mat_in[:,1]
   dfidqd2_curr_vec = dfidqd_curr_mat_in[:,2]
   dfidqd3_curr_vec = dfidqd_curr_mat_in[:,3]
   dfidqd4_curr_vec = dfidqd_curr_mat_in[:,4]
   dfidqd5_curr_vec = dfidqd_curr_mat_in[:,5]
   dfidqd6_curr_vec = dfidqd_curr_mat_in[:,6]
   dfidqd7_curr_vec = dfidqd_curr_mat_in[:,7]
   dfidq1_prev_vec = dfidq_prev_mat_in[:,1]
   dfidq2_prev_vec = dfidq_prev_mat_in[:,2]
   dfidq3_prev_vec = dfidq_prev_mat_in[:,3]
   dfidq4_prev_vec = dfidq_prev_mat_in[:,4]
   dfidq5_prev_vec = dfidq_prev_mat_in[:,5]
   dfidq6_prev_vec = dfidq_prev_mat_in[:,6]
   dfidq7_prev_vec = dfidq_prev_mat_in[:,7]
   dfidqd1_prev_vec = dfidqd_prev_mat_in[:,1]
   dfidqd2_prev_vec = dfidqd_prev_mat_in[:,2]
   dfidqd3_prev_vec = dfidqd_prev_mat_in[:,3]
   dfidqd4_prev_vec = dfidqd_prev_mat_in[:,4]
   dfidqd5_prev_vec = dfidqd_prev_mat_in[:,5]
   dfidqd6_prev_vec = dfidqd_prev_mat_in[:,6]
   dfidqd7_prev_vec = dfidqd_prev_mat_in[:,7]

   # dID/dq
   dtauidq_curr_vec_out[1,1],
   dfidq1_prev_vec = dqBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                               Xi_curr,fi_curr_vec,
                               dfidq1_curr_vec,fx1,dfidq1_prev_vec)
   dtauidq_curr_vec_out[1,2],
   dfidq2_prev_vec = dqBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                               Xi_curr,fi_curr_vec,
                               dfidq2_curr_vec,fx2,dfidq2_prev_vec)
   dtauidq_curr_vec_out[1,3],
   dfidq3_prev_vec = dqBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                               Xi_curr,fi_curr_vec,
                               dfidq3_curr_vec,fx3,dfidq3_prev_vec)
   dtauidq_curr_vec_out[1,4],
   dfidq4_prev_vec = dqBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                               Xi_curr,fi_curr_vec,
                               dfidq4_curr_vec,fx4,dfidq4_prev_vec)
   dtauidq_curr_vec_out[1,5],
   dfidq5_prev_vec = dqBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                               Xi_curr,fi_curr_vec,
                               dfidq5_curr_vec,fx5,dfidq5_prev_vec)
   dtauidq_curr_vec_out[1,6],
   dfidq6_prev_vec = dqBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                               Xi_curr,fi_curr_vec,
                               dfidq6_curr_vec,fx6,dfidq6_prev_vec)
   dtauidq_curr_vec_out[1,7],
   dfidq7_prev_vec = dqBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                               Xi_curr,fi_curr_vec,
                               dfidq7_curr_vec,fx7,dfidq7_prev_vec)

   # dID/dqd
   dtauidqd_curr_vec_out[1,1],
   dfidqd1_prev_vec = dqdBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                                 Xi_curr,dfidqd1_curr_vec,dfidqd1_prev_vec)
   dtauidqd_curr_vec_out[1,2],
   dfidqd2_prev_vec = dqdBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                                 Xi_curr,dfidqd2_curr_vec,dfidqd2_prev_vec)
   dtauidqd_curr_vec_out[1,3],
   dfidqd3_prev_vec = dqdBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                                 Xi_curr,dfidqd3_curr_vec,dfidqd3_prev_vec)
   dtauidqd_curr_vec_out[1,4],
   dfidqd4_prev_vec = dqdBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                                 Xi_curr,dfidqd4_curr_vec,dfidqd4_prev_vec)
   dtauidqd_curr_vec_out[1,5],
   dfidqd5_prev_vec = dqdBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                                 Xi_curr,dfidqd5_curr_vec,dfidqd5_prev_vec)
   dtauidqd_curr_vec_out[1,6],
   dfidqd6_prev_vec = dqdBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                                 Xi_curr,dfidqd6_curr_vec,dfidqd6_prev_vec)
   dtauidqd_curr_vec_out[1,7],
   dfidqd7_prev_vec = dqdBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                                 Xi_curr,dfidqd7_curr_vec,dfidqd7_prev_vec)

   # dfi/dq
   dfidq_prev_mat_out[:,1] = dfidq1_prev_vec
   dfidq_prev_mat_out[:,2] = dfidq2_prev_vec
   dfidq_prev_mat_out[:,3] = dfidq3_prev_vec
   dfidq_prev_mat_out[:,4] = dfidq4_prev_vec
   dfidq_prev_mat_out[:,5] = dfidq5_prev_vec
   dfidq_prev_mat_out[:,6] = dfidq6_prev_vec
   dfidq_prev_mat_out[:,7] = dfidq7_prev_vec


   # dfi/dqd
   dfidqd_prev_mat_out[:,1] = dfidqd1_prev_vec
   dfidqd_prev_mat_out[:,2] = dfidqd2_prev_vec
   dfidqd_prev_mat_out[:,3] = dfidqd3_prev_vec
   dfidqd_prev_mat_out[:,4] = dfidqd4_prev_vec
   dfidqd_prev_mat_out[:,5] = dfidqd5_prev_vec
   dfidqd_prev_mat_out[:,6] = dfidqd6_prev_vec
   dfidqd_prev_mat_out[:,7] = dfidqd7_prev_vec

   # outputs
   return dtauidq_curr_vec_out, dtauidqd_curr_vec_out,
          dfidq_prev_mat_out, dfidqd_prev_mat_out
end
