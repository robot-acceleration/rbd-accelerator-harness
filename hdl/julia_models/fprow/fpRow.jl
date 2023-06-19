# fpRow
#
# Based on RobCoGen's Inverse Dynamics for iiwa and Carpentier et al., RSS 2018

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra
include("../dqfpij/dqFPij.jl") # dqFPij
include("../dqdfpij/dqdFPij.jl") # dqdFPij

#-------------------------------------------------------------------------------
# Forward Pass Row Unit
#-------------------------------------------------------------------------------
function fpRow(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
               link,Xi_curr,qdi_curr,
               vi_curr_vec,vi_prev_vec,ai_prev_vec,
               dvidq_prev_mat,daidq_prev_mat,
               dvidqd_prev_mat,daidqd_prev_mat)

   # I parameters (for Julia model only)
   Ilist = [[0.1612 -0.0 -0.0 0.0 -0.48 -0.12; -0.0 0.1476 0.0144 0.48 0.0 -0.0; -0.0 0.0144 0.0236 0.12 0.0 0.0; 0.0 0.48 0.12 4.0 0.0 0.0; -0.48 0.0 0.0 0.0 4.0 0.0; -0.12 -0.0 0.0 0.0 0.0 4.0], [0.07098 -7.08e-5 -5.04e-5 0.0 -0.168 0.236; -7.08e-5 0.0250564 -0.009912 0.168 0.0 -0.0012; -5.04e-5 -0.009912 0.0579244 -0.236 0.0012 0.0; 0.0 0.168 -0.236 4.0 0.0 0.0; -0.168 0.0 0.0012 0.0 4.0 0.0; 0.236 -0.0012 0.0 0.0 0.0 4.0], [0.1334 -0.0 -0.0 0.0 -0.39 0.09; -0.0 0.1257 -0.0117 0.39 0.0 -0.0; -0.0 -0.0117 0.0127 -0.09 0.0 0.0; 0.0 0.39 -0.09 3.0 0.0 0.0; -0.39 0.0 0.0 0.0 3.0 0.0; 0.09 -0.0 0.0 0.0 0.0 3.0], [0.0452415 -0.0 -0.0 0.0 -0.0918 0.1809; -0.0 0.0131212 -0.0061506 0.0918 0.0 -0.0; -0.0 -0.0061506 0.0411203 -0.1809 0.0 0.0; 0.0 0.0918 -0.1809 2.7 0.0 0.0; -0.0918 0.0 0.0 0.0 2.7 0.0; 0.1809 -0.0 0.0 0.0 0.0 2.7], [0.0305689 -3.57e-6 -1.292e-5 0.0 -0.1292 0.0357; -3.57e-6 0.0278192 -0.0027132 0.1292 0.0 -0.00017; -1.292e-5 -0.0027132 0.00574972 -0.0357 0.00017 0.0; 0.0 0.1292 -0.0357 1.7 0.0 0.0; -0.1292 0.0 0.00017 0.0 1.7 0.0; 0.0357 -0.00017 0.0 0.0 0.0 1.7], [0.00500094 -0.0 -0.0 0.0 -0.00072 0.00108; -0.0 0.00360029 -4.32e-7 0.00072 0.0 -0.0; -0.0 -4.32e-7 0.00470065 -0.00108 0.0 0.0; 0.0 0.00072 -0.00108 1.8 0.0 0.0; -0.00072 0.0 0.0 0.0 1.8 0.0; 0.00108 -0.0 0.0 0.0 0.0 1.8], [0.00112 -0.0 -0.0 0.0 -0.006 0.0; -0.0 0.00112 -0.0 0.006 0.0 -0.0; -0.0 -0.0 0.001 -0.0 0.0 0.0; 0.0 0.006 -0.0 0.3 0.0 0.0; -0.006 0.0 0.0 0.0 0.3 0.0; 0.0 -0.0 0.0 0.0 0.0 0.3]]
   Ii_curr = Ilist[link]

   # internal wires and state
   dvidq_curr_mat = zeros(CUSTOM_TYPE,6,7)
   daidq_curr_mat = zeros(CUSTOM_TYPE,6,7)
   dfidq_curr_mat = zeros(CUSTOM_TYPE,6,7)
   dvidqd_curr_mat = zeros(CUSTOM_TYPE,6,7)
   daidqd_curr_mat = zeros(CUSTOM_TYPE,6,7)
   dfidqd_curr_mat = zeros(CUSTOM_TYPE,6,7)

   # booleans
   if (link == 1)
      mx1 = true
   else
      mx1 = false
   end
   if (link == 2)
      mx2 = true
   else
      mx2 = false
   end
   if (link == 3)
      mx3 = true
   else
      mx3 = false
   end
   if (link == 4)
      mx4 = true
   else
      mx4 = false
   end
   if (link == 5)
      mx5 = true
   else
      mx5 = false
   end
   if (link == 6)
      mx6 = true
   else
      mx6 = false
   end
   if (link == 7)
      mx7 = true
   else
      mx7 = false
   end

   # inputs
   if (mx2)
      dvidq2_prev_vec = vi_prev_vec
      daidq2_prev_vec = ai_prev_vec
   else
      dvidq2_prev_vec = dvidq_prev_mat[:,2]
      daidq2_prev_vec = daidq_prev_mat[:,2]
   end
   if (mx3)
      dvidq3_prev_vec = vi_prev_vec
      daidq3_prev_vec = ai_prev_vec
   else
      dvidq3_prev_vec = dvidq_prev_mat[:,3]
      daidq3_prev_vec = daidq_prev_mat[:,3]
   end
   if (mx4)
      dvidq4_prev_vec = vi_prev_vec
      daidq4_prev_vec = ai_prev_vec
   else
      dvidq4_prev_vec = dvidq_prev_mat[:,4]
      daidq4_prev_vec = daidq_prev_mat[:,4]
   end
   if (mx5)
      dvidq5_prev_vec = vi_prev_vec
      daidq5_prev_vec = ai_prev_vec
   else
      dvidq5_prev_vec = dvidq_prev_mat[:,5]
      daidq5_prev_vec = daidq_prev_mat[:,5]
   end
   if (mx6)
      dvidq6_prev_vec = vi_prev_vec
      daidq6_prev_vec = ai_prev_vec
   else
      dvidq6_prev_vec = dvidq_prev_mat[:,6]
      daidq6_prev_vec = daidq_prev_mat[:,6]
   end
   if (mx7)
      dvidq7_prev_vec = vi_prev_vec
      daidq7_prev_vec = ai_prev_vec
   else
      dvidq7_prev_vec = dvidq_prev_mat[:,7]
      daidq7_prev_vec = daidq_prev_mat[:,7]
   end
   dvidqd1_prev_vec = dvidqd_prev_mat[:,1]
   daidqd1_prev_vec = daidqd_prev_mat[:,1]
   dvidqd2_prev_vec = dvidqd_prev_mat[:,2]
   daidqd2_prev_vec = daidqd_prev_mat[:,2]
   dvidqd3_prev_vec = dvidqd_prev_mat[:,3]
   daidqd3_prev_vec = daidqd_prev_mat[:,3]
   dvidqd4_prev_vec = dvidqd_prev_mat[:,4]
   daidqd4_prev_vec = daidqd_prev_mat[:,4]
   dvidqd5_prev_vec = dvidqd_prev_mat[:,5]
   daidqd5_prev_vec = daidqd_prev_mat[:,5]
   dvidqd6_prev_vec = dvidqd_prev_mat[:,6]
   daidqd6_prev_vec = daidqd_prev_mat[:,6]
   dvidqd7_prev_vec = dvidqd_prev_mat[:,7]
   daidqd7_prev_vec = daidqd_prev_mat[:,7]

   # dID/dq
   dvidq2_curr_vec,
   daidq2_curr_vec,
   dfidq2_curr_vec = dqFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            Xi_curr,Ii_curr,
                            qdi_curr,vi_curr_vec,mx2,
                            dvidq2_prev_vec,daidq2_prev_vec)
   dvidq3_curr_vec,
   daidq3_curr_vec,
   dfidq3_curr_vec = dqFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            Xi_curr,Ii_curr,
                            qdi_curr,vi_curr_vec,mx3,
                            dvidq3_prev_vec,daidq3_prev_vec)
   dvidq4_curr_vec,
   daidq4_curr_vec,
   dfidq4_curr_vec = dqFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            Xi_curr,Ii_curr,
                            qdi_curr,vi_curr_vec,mx4,
                            dvidq4_prev_vec,daidq4_prev_vec)
   dvidq5_curr_vec,
   daidq5_curr_vec,
   dfidq5_curr_vec = dqFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            Xi_curr,Ii_curr,
                            qdi_curr,vi_curr_vec,mx5,
                            dvidq5_prev_vec,daidq5_prev_vec)
   dvidq6_curr_vec,
   daidq6_curr_vec,
   dfidq6_curr_vec = dqFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            Xi_curr,Ii_curr,
                            qdi_curr,vi_curr_vec,mx6,
                            dvidq6_prev_vec,daidq6_prev_vec)
   dvidq7_curr_vec,
   daidq7_curr_vec,
   dfidq7_curr_vec = dqFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            Xi_curr,Ii_curr,
                            qdi_curr,vi_curr_vec,mx7,
                            dvidq7_prev_vec,daidq7_prev_vec)

   # dID/dqd
   dvidqd1_curr_vec,
   daidqd1_curr_vec,
   dfidqd1_curr_vec = dqdFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            Xi_curr,Ii_curr,
                            qdi_curr,vi_curr_vec,mx1,
                            dvidqd1_prev_vec,daidqd1_prev_vec)
   dvidqd2_curr_vec,
   daidqd2_curr_vec,
   dfidqd2_curr_vec = dqdFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            Xi_curr,Ii_curr,
                            qdi_curr,vi_curr_vec,mx2,
                            dvidqd2_prev_vec,daidqd2_prev_vec)
   dvidqd3_curr_vec,
   daidqd3_curr_vec,
   dfidqd3_curr_vec = dqdFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            Xi_curr,Ii_curr,
                            qdi_curr,vi_curr_vec,mx3,
                            dvidqd3_prev_vec,daidqd3_prev_vec)
   dvidqd4_curr_vec,
   daidqd4_curr_vec,
   dfidqd4_curr_vec = dqdFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            Xi_curr,Ii_curr,
                            qdi_curr,vi_curr_vec,mx4,
                            dvidqd4_prev_vec,daidqd4_prev_vec)
   dvidqd5_curr_vec,
   daidqd5_curr_vec,
   dfidqd5_curr_vec = dqdFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            Xi_curr,Ii_curr,
                            qdi_curr,vi_curr_vec,mx5,
                            dvidqd5_prev_vec,daidqd5_prev_vec)
   dvidqd6_curr_vec,
   daidqd6_curr_vec,
   dfidqd6_curr_vec = dqdFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            Xi_curr,Ii_curr,
                            qdi_curr,vi_curr_vec,mx6,
                            dvidqd6_prev_vec,daidqd6_prev_vec)
   dvidqd7_curr_vec,
   daidqd7_curr_vec,
   dfidqd7_curr_vec = dqdFPij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            Xi_curr,Ii_curr,
                            qdi_curr,vi_curr_vec,mx7,
                            dvidqd7_prev_vec,daidqd7_prev_vec)

   # dvi/dq
   dvidq_curr_mat[:,1] = zeros(CUSTOM_TYPE,6,1)
   dvidq_curr_mat[:,2] = dvidq2_curr_vec
   dvidq_curr_mat[:,3] = dvidq3_curr_vec
   dvidq_curr_mat[:,4] = dvidq4_curr_vec
   dvidq_curr_mat[:,5] = dvidq5_curr_vec
   dvidq_curr_mat[:,6] = dvidq6_curr_vec
   dvidq_curr_mat[:,7] = dvidq7_curr_vec
   # dai/dq
   daidq_curr_mat[:,1] = zeros(CUSTOM_TYPE,6,1)
   daidq_curr_mat[:,2] = daidq2_curr_vec
   daidq_curr_mat[:,3] = daidq3_curr_vec
   daidq_curr_mat[:,4] = daidq4_curr_vec
   daidq_curr_mat[:,5] = daidq5_curr_vec
   daidq_curr_mat[:,6] = daidq6_curr_vec
   daidq_curr_mat[:,7] = daidq7_curr_vec
   # dfi/dq
   dfidq_curr_mat[:,1] = zeros(CUSTOM_TYPE,6,1)
   dfidq_curr_mat[:,2] = dfidq2_curr_vec
   dfidq_curr_mat[:,3] = dfidq3_curr_vec
   dfidq_curr_mat[:,4] = dfidq4_curr_vec
   dfidq_curr_mat[:,5] = dfidq5_curr_vec
   dfidq_curr_mat[:,6] = dfidq6_curr_vec
   dfidq_curr_mat[:,7] = dfidq7_curr_vec

   # dvi/dqd
   dvidqd_curr_mat[:,1] = dvidqd1_curr_vec
   dvidqd_curr_mat[:,2] = dvidqd2_curr_vec
   dvidqd_curr_mat[:,3] = dvidqd3_curr_vec
   dvidqd_curr_mat[:,4] = dvidqd4_curr_vec
   dvidqd_curr_mat[:,5] = dvidqd5_curr_vec
   dvidqd_curr_mat[:,6] = dvidqd6_curr_vec
   dvidqd_curr_mat[:,7] = dvidqd7_curr_vec
   # dai/dqd
   daidqd_curr_mat[:,1] = daidqd1_curr_vec
   daidqd_curr_mat[:,2] = daidqd2_curr_vec
   daidqd_curr_mat[:,3] = daidqd3_curr_vec
   daidqd_curr_mat[:,4] = daidqd4_curr_vec
   daidqd_curr_mat[:,5] = daidqd5_curr_vec
   daidqd_curr_mat[:,6] = daidqd6_curr_vec
   daidqd_curr_mat[:,7] = daidqd7_curr_vec
   # dfi/dqd
   dfidqd_curr_mat[:,1] = dfidqd1_curr_vec
   dfidqd_curr_mat[:,2] = dfidqd2_curr_vec
   dfidqd_curr_mat[:,3] = dfidqd3_curr_vec
   dfidqd_curr_mat[:,4] = dfidqd4_curr_vec
   dfidqd_curr_mat[:,5] = dfidqd5_curr_vec
   dfidqd_curr_mat[:,6] = dfidqd6_curr_vec
   dfidqd_curr_mat[:,7] = dfidqd7_curr_vec

   # outputs
   return dvidq_curr_mat, daidq_curr_mat, dfidq_curr_mat,
          dvidqd_curr_mat, daidqd_curr_mat, dfidqd_curr_mat
end
