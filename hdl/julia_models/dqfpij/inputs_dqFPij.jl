# inputs_dqFPij
#
# Format the Inputs for dqfpassij.v

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra
using FixedPointNumbers
using Test
include("../../../type_generic/dynamics/helpers_iiwa.jl")
include("dqFPij.jl") # dqFPij

#-------------------------------------------------------------------------------
# Data Type
#-------------------------------------------------------------------------------
CUSTOM_TYPE = Float64 ###Fixed{Int32,24} # data type

#-------------------------------------------------------------------------------
# Set Constants
#-------------------------------------------------------------------------------
X,Y,Z,AX,AY,AZ,LX,LY,LZ,g = initConstants(CUSTOM_TYPE)

#-------------------------------------------------------------------------------
# Fixed-Point Parameters
#-------------------------------------------------------------------------------
WIDTH = 32
DECIMAL_BITS = 16

#-------------------------------------------------------------------------------
# Define Test Function
#-------------------------------------------------------------------------------
function dqFPijTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,link)
   #----------------------------------------------------------------------------
   # Inputs and Expected Outputs
   #----------------------------------------------------------------------------
   # Input = 5
   if (link == 5) # Link 5
      #link = 5
      xform = [-0.668187 0.0 -0.743993 0.0 0.0 0.0; -0.743993 0.0 0.668187 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; -0.137267 6.68187e-13 0.123281 -0.668187 0.0 -0.743993; 0.123281 7.43993e-13 0.137267 -0.743993 0.0 0.668187; 1.0e-12 0.0 0.0 0.0 1.0 0.0]
      imat = [0.0305689 -3.57e-6 -1.292e-5 0.0 -0.1292 0.0357; -3.57e-6 0.0278192 -0.0027132 0.1292 0.0 -0.00017; -1.292e-5 -0.0027132 0.00574972 -0.0357 0.00017 0.0; 0.0 0.1292 -0.0357 1.7 0.0 0.0; -0.1292 0.0 0.00017 0.0 1.7 0.0; 0.0357 -0.00017 0.0 0.0 0.0 1.7]
      qd_link = 0.437107975
      lcurr_v = [-0.100832; 0.722306; 2.34665; 0.274428; -0.107102; -8.34731e-6]
      mcross = true
      dvdq_xdot_vec = [-0.470016; 1.90955; 0.557654; -0.00079912; -8.34731e-6; -0.189019]
      dadq_xdot_vec = [-0.509994; -0.146673; 3.56933; 0.796127; 0.00876021; -0.661668]
      lcurr_dvi_dqj = [0.722306; 0.100832; 0.0; -0.107102; -0.274428; 0.0]
      lcurr_dai_dqj = [2.80848; 1.99906; 0.0; -0.727309; -0.423533; 0.0]
      lcurr_dfi_dqj = [0.167419; 0.0882908; -0.00860167; 0.353863; -1.47426; 0.108658]
   elseif (link == 6) # Link 6
      #link = 6
      xform = [0.951994 0.0 0.306117 0.0 0.0 0.0; -0.306117 0.0 0.951994 0.0 0.0 0.0; 0.0 -1.0 0.0 0.0 0.0 0.0; -6.12234e-13 0.205155 1.90399e-12 0.951994 0.0 0.306117; -1.90399e-12 -0.0659682 -6.12234e-13 -0.306117 0.0 0.951994; 0.2155 0.0 0.0 0.0 -1.0 0.0]
      imat = [0.00500094 -0.0 -0.0 0.0 -0.00072 0.00108; -0.0 0.00360029 -4.32e-7 0.00072 0.0 -0.0; -0.0 -4.32e-7 0.00470065 -0.00108 0.0 0.0; 0.0 0.00072 -0.00108 1.8 0.0 0.0; -0.00072 0.0 0.0 0.0 1.8 0.0; 0.00108 -0.0 0.0 0.0 0.0 1.8]
      qd_link = 0.42471785
      lcurr_v = [0.622359; 2.26487; -0.297588; 0.409436; -0.131664; 0.0853726]
      mcross = false
      dvdq_xdot_vec = [0.722306; 0.100832; 0.0; -0.107102; -0.274428; 0.0]
      dadq_xdot_vec = [2.80848; 1.99906; 0.0; -0.727309; -0.423533; 0.0]
      lcurr_dvi_dqj = [0.687631; -0.22111; -0.100832; -0.0812742; 0.026134; 0.430085]
      lcurr_dai_dqj = [2.57975; -1.15177; -1.99906; -0.271178; 0.125286; 1.02876]
      lcurr_dfi_dqj = [0.0142073; -0.00373699; -0.0121177; 1.22403; -0.395695; 2.21509]
      # Stage 1 inputs:
      s1r1_in = [0.622359, 2.26487, -0.297588, 0.409436, -0.131664, 0.0853726];
      s1r2_in = [2.80849; 1.99906; 0.0; -0.727307; -0.423535; 0.0];
      s1r3_in = 0.424718;
      s1r4_in = [0.722306; 0.100832; 0.0; -0.107102; -0.274429; 0.0];
      # Stage 1 outputs:
      s1r1_out = [0.622359, 2.26487, -0.297588, 0.409436, -0.131664, 0.0853726];
      s1r2_out = [0.00329938; 0.00844911; -0.00184203; 0.738937; -0.237443; 0.154343];
      s1r3_out = [2.80849; 1.99906; 0.0; -0.727307; -0.423535; 0.0];
      s1r4_out = 0.424718;
      s1r5_out = [0.687631; -0.22111; -0.100832; -0.0812743; 0.026134; 0.430085];
      # Stage 2 inputs:
      s2r1_in = [0.622359, 2.26487, -0.297588, 0.409436, -0.131664, 0.0853726];
      s2r2_in = [0.00329938; 0.00844911; -0.00184203; 0.738937; -0.237443; 0.154343];
      s2r3_in = [2.80849; 1.99906; 0.0; -0.727307; -0.423535; 0.0];
      s2r4_in = 0.424718;
      s2r5_in = [0.687631; -0.22111; -0.100832; -0.0812743; 0.026134; 0.430085];
      # Stage 2 outputs:
      s2r1_out = [0.107414; 0.331284; 0.00652602; -0.0580687; -0.180639; 0.000113078];
      s2r2_out = [0.622359, 2.26487, -0.297588, 0.409436, -0.131664, 0.0853726];
      s2r3_out = [0.00388448; -0.000854534; -0.000386105; -0.146344; 0.0465462; 0.774897];
      s2r4_out = [2.57975; -1.15177; -1.99906; -0.271175; 0.125285; 1.02876];
      s2r5_out = [0.687631; -0.22111; -0.100832; -0.0812743; 0.026134; 0.430085];
      # Stage 3 inputs:
      s3r1_in = [0.107414; 0.331284; 0.00652602; -0.0580687; -0.180639; 0.000113078];
      s3r2_in = [0.622359, 2.26487, -0.297588, 0.409436, -0.131664, 0.0853726];
      s3r3_in = [0.00388448; -0.000854534; -0.000386105; -0.146344; 0.0465462; 0.774897];
      s3r4_in = [2.57975; -1.15177; -1.99906; -0.271175; 0.125285; 1.02876];
      s3r5_in = [0.687631; -0.22111; -0.100832; -0.0812743; 0.026134; 0.430085];
      # Stage 3 outputs:
      s3r1_out = [0.0142073; -0.00373699; -0.0121177; 1.22404; -0.395697; 2.21509];
      s3r2_out = [2.57975; -1.15177; -1.99906; -0.271175; 0.125285; 1.02876];
      s3r3_out = [0.687631; -0.22111; -0.100832; -0.0812743; 0.026134; 0.430085];
   elseif (link == 7) # Link 7
      #link = 7
      xform = [0.662605 0.0 0.748969 0.0 0.0 0.0; 0.748969 0.0 -0.662605 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; 0.0606665 0.0 -0.053671 0.662605 0.0 0.748969; -0.053671 0.0 -0.0606665 0.748969 0.0 -0.662605; 0.0 0.0 0.0 0.0 1.0 0.0]
      imat = [0.00112 -0.0 -0.0 0.0 -0.006 0.0; -0.0 0.00112 -0.0 0.006 0.0 -0.0; -0.0 -0.0 0.001 -0.0 0.0 0.0; 0.0 0.006 -0.0 0.3 0.0 0.0; -0.006 0.0 0.0 0.0 0.3 0.0; 0.0 -0.0 0.0 0.0 0.0 0.3]
      qd_link = 0.773223048
      lcurr_v = [0.189494; 0.663311; 3.03809; 0.388964; 0.234737; -0.131664]
      mcross = false
      dvdq_xdot_vec = [0.687631; -0.22111; -0.100832; -0.0812742; 0.026134; 0.430085]
      dadq_xdot_vec = [2.57975; -1.15177; -1.99906; -0.271178; 0.125286; 1.02876]
      lcurr_dvi_dqj = [0.380107; 0.581826; -0.22111; 0.315396; -0.376637; 0.026134]
      lcurr_dai_dqj = [0.662005; 2.96283; -1.15177; 0.563398; -1.14582; 0.125286]
      lcurr_dfi_dqj = [0.0019181; 0.0136536; -0.00115177; 0.534541; -0.0628049; -0.0932076]
   else
      #link = 7
      xform = [0.662605 0.0 0.748969 0.0 0.0 0.0; 0.748969 0.0 -0.662605 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; 0.0606665 0.0 -0.053671 0.662605 0.0 0.748969; -0.053671 0.0 -0.0606665 0.748969 0.0 -0.662605; 0.0 0.0 0.0 0.0 1.0 0.0]
      imat = [0.00112 -0.0 -0.0 0.0 -0.006 0.0; -0.0 0.00112 -0.0 0.006 0.0 -0.0; -0.0 -0.0 0.001 -0.0 0.0 0.0; 0.0 0.006 -0.0 0.3 0.0 0.0; -0.006 0.0 0.0 0.0 0.3 0.0; 0.0 -0.0 0.0 0.0 0.0 0.3]
      qd_link = 0.773223048
      lcurr_v = [0.189494; 0.663311; 3.03809; 0.388964; 0.234737; -0.131664]
      mcross = false
      dvdq_xdot_vec = [0.687631; -0.22111; -0.100832; -0.0812742; 0.026134; 0.430085]
      dadq_xdot_vec = [2.57975; -1.15177; -1.99906; -0.271178; 0.125286; 1.02876]
      lcurr_dvi_dqj = [0.380107; 0.581826; -0.22111; 0.315396; -0.376637; 0.026134]
      lcurr_dai_dqj = [0.662005; 2.96283; -1.15177; 0.563398; -1.14582; 0.125286]
      lcurr_dfi_dqj = [0.0019181; 0.0136536; -0.00115177; 0.534541; -0.0628049; -0.0932076]
   end

   #----------------------------------------------------------------------------
   # Convert Values to Fixed-Point Binary
   #----------------------------------------------------------------------------
   # imat
   for i in 1:size(imat)[1] # rows
      for j in 1:size(imat)[2] # cols
         imat[i,j] = round(imat[i,j]*(2^DECIMAL_BITS))
      end
   end
   # xform
   for i in 1:size(xform)[1] # rows
      for j in 1:size(xform)[2] # cols
         xform[i,j] = round(xform[i,j]*(2^DECIMAL_BITS))
      end
   end
   # qd_link
   qd_link = round(qd_link*(2^DECIMAL_BITS))
   # lcurr_v
   for i in 1:length(lcurr_v)
      lcurr_v[i] = round(lcurr_v[i]*(2^DECIMAL_BITS))
   end
   # mcross
   if mcross
      mcross = 1
   else
      mcross = 0
   end
   # dvdq_xdot_vec
   for i in 1:length(dvdq_xdot_vec)
      dvdq_xdot_vec[i] = round(dvdq_xdot_vec[i]*(2^DECIMAL_BITS))
   end
   # dadq_xdot_vec
   for i in 1:length(dadq_xdot_vec)
      dadq_xdot_vec[i] = round(dadq_xdot_vec[i]*(2^DECIMAL_BITS))
   end
   # lcurr_dvi_dqj
   for i in 1:length(lcurr_dvi_dqj)
      lcurr_dvi_dqj[i] = round(lcurr_dvi_dqj[i]*(2^DECIMAL_BITS))
   end
   # lcurr_dai_dqj
   for i in 1:length(lcurr_dai_dqj)
      lcurr_dai_dqj[i] = round(lcurr_dai_dqj[i]*(2^DECIMAL_BITS))
   end
   # lcurr_dfi_dqj
   for i in 1:length(lcurr_dfi_dqj)
      lcurr_dfi_dqj[i] = round(lcurr_dfi_dqj[i]*(2^DECIMAL_BITS))
   end

   #----------------------------------------------------------------------------
   # Print Fixed-Point Binary Values for Vivado Simulation
   #----------------------------------------------------------------------------
   println("// Input = 5, Link = 6")
   
   println("// Input = 5, Link = ",link)
   println("// IMAT_IN, 24 values")
   println("parameter signed")
   println("   IMAT_IN_AX_AX = 32'd",imat[1,1],",IMAT_IN_AX_AY = 32'd",imat[1,2],",IMAT_IN_AX_AZ = 32'd",imat[1,3],",                                  IMAT_IN_AX_LY = 32'd",imat[1,5],",IMAT_IN_AX_LZ = 32'd",imat[1,6],",")
   println("   IMAT_IN_AY_AX = 32'd",imat[2,1],",IMAT_IN_AY_AY = 32'd",imat[2,2],",IMAT_IN_AY_AZ = 32'd",imat[2,3],",IMAT_IN_AY_LX = 32'd",imat[2,4],",                                  IMAT_IN_AY_LZ = 32'd",imat[2,6],",")
   println("   IMAT_IN_AZ_AX = 32'd",imat[3,1],",IMAT_IN_AZ_AY = 32'd",imat[3,2],",IMAT_IN_AZ_AZ = 32'd",imat[3,3],",IMAT_IN_AZ_LX = 32'd",imat[3,4],",IMAT_IN_AZ_LY = 32'd",imat[3,5],",")
   println("                                     IMAT_IN_LX_AY = 32'd",imat[4,2],",IMAT_IN_LX_AZ = 32'd",imat[4,3],",IMAT_IN_LX_LX = 32'd",imat[4,4],",")
   println("   IMAT_IN_LY_AX = 32'd",imat[5,1],",                                  IMAT_IN_LY_AZ = 32'd",imat[5,3],",                                  IMAT_IN_LY_LY = 32'd",imat[5,5],",")
   println("   IMAT_IN_LZ_AX = 32'd",imat[6,1],",IMAT_IN_LZ_AY = 32'd",imat[6,2],",                                                                                                      IMAT_IN_LZ_LZ = 32'd",imat[6,6],";")
   println("// -----------------------------------------------------------------------")
   println("// Input = 5, Link = ",link)
   println("xform_in_AX_AX = 32'd",xform[1,1],"; xform_in_AX_AY = 32'd",xform[1,2],"; xform_in_AX_AZ = 32'd",xform[1,3],";")
   println("xform_in_AY_AX = 32'd",xform[2,1],"; xform_in_AY_AY = 32'd",xform[2,2],"; xform_in_AY_AZ = 32'd",xform[2,3],";")
   println("                                     xform_in_AZ_AY = 32'd",xform[3,2],"; xform_in_AZ_AZ = 32'd",xform[3,3],";")
   println("xform_in_LX_AX = 32'd",xform[4,1],"; xform_in_LX_AY = 32'd",xform[4,2],"; xform_in_LX_AZ = 32'd",xform[4,3],";  xform_in_LX_LX = 32'd",xform[4,4],"; xform_in_LX_LY = 32'd",xform[4,5],"; xform_in_LX_LZ = 32'd",xform[4,6],";")
   println("xform_in_LY_AX = 32'd",xform[5,1],"; xform_in_LY_AY = 32'd",xform[5,2],"; xform_in_LY_AZ = 32'd",xform[5,3],";  xform_in_LY_LX = 32'd",xform[5,4],"; xform_in_LY_LY = 32'd",xform[5,5],"; xform_in_LY_LZ = 32'd",xform[5,6],";")
   println("xform_in_LZ_AX = 32'd",xform[6,1],";                                                                                                                 xform_in_LZ_LY = 32'd",xform[6,5],"; xform_in_LZ_LZ = 32'd",xform[6,6],";")
   println("qd_val_in = 32'd",qd_link,";")
   println("v_vec_in_AX = 32'd",lcurr_v[1],"; v_vec_in_AY = 32'd",lcurr_v[2],"; v_vec_in_AZ = 32'd",lcurr_v[3],"; v_vec_in_LX = 32'd",lcurr_v[4],"; v_vec_in_LY = 32'd",lcurr_v[5],"; v_vec_in_LZ = 32'd",lcurr_v[6],";")
   println("mcross = ",mcross,";")
   println("dv_vec_in_AX = 32'd",dvdq_xdot_vec[1],"; dv_vec_in_AY = 32'd",dvdq_xdot_vec[2],"; dv_vec_in_AZ = 32'd",dvdq_xdot_vec[3],"; dv_vec_in_LX = 32'd",dvdq_xdot_vec[4],"; dv_vec_in_LY = 32'd",dvdq_xdot_vec[5],"; dv_vec_in_LZ = 32'd",dvdq_xdot_vec[6],";")
   println("da_vec_in_AX = 32'd",dadq_xdot_vec[1],"; da_vec_in_AY = 32'd",dadq_xdot_vec[2],"; da_vec_in_AZ = 32'd",dadq_xdot_vec[3],"; da_vec_in_LX = 32'd",dadq_xdot_vec[4],"; da_vec_in_LY = 32'd",dadq_xdot_vec[5],"; da_vec_in_LZ = 32'd",dadq_xdot_vec[6],";")
   println("#100;")
   println("\$display (\"dv_dq     = ",lcurr_dvi_dqj[1],", ",lcurr_dvi_dqj[2],", ",lcurr_dvi_dqj[3],", ",lcurr_dvi_dqj[4],", ",lcurr_dvi_dqj[5],", ",lcurr_dvi_dqj[6],"\");")
   println("\$display (\"dv_dq_out = %d,%d,%d,%d,%d,%d\", dvdq_vec_out_AX,dvdq_vec_out_AY,dvdq_vec_out_AZ,dvdq_vec_out_LX,dvdq_vec_out_LY,dvdq_vec_out_LZ);")
   println("\$display (\"da_dq     = ",lcurr_dai_dqj[1],", ",lcurr_dai_dqj[2],", ",lcurr_dai_dqj[3],", ",lcurr_dai_dqj[4],", ",lcurr_dai_dqj[5],", ",lcurr_dai_dqj[6],"\");")
   println("\$display (\"da_dq_out = %d,%d,%d,%d,%d,%d\", dadq_vec_out_AX,dadq_vec_out_AY,dadq_vec_out_AZ,dadq_vec_out_LX,dadq_vec_out_LY,dadq_vec_out_LZ);")
   println("\$display (\"df_dq     = ",lcurr_dfi_dqj[1],", ",lcurr_dfi_dqj[2],", ",lcurr_dfi_dqj[3],", ",lcurr_dfi_dqj[4],", ",lcurr_dfi_dqj[5],", ",lcurr_dfi_dqj[6],"\");")
   println("\$display (\"df_dq_out = %d,%d,%d,%d,%d,%d\", dfdq_vec_out_AX,dfdq_vec_out_AY,dfdq_vec_out_AZ,dfdq_vec_out_LX,dfdq_vec_out_LY,dfdq_vec_out_LZ);")
   println("// -----------------------------------------------------------------------")

end

#-------------------------------------------------------------------------------
# Set Test Parameters and Run Test
#-------------------------------------------------------------------------------
println("// -----------------------------------------------------------------------")
println("// Input = 5, Link = 6")
println("// -----------------------------------------------------------------------")
# Input = 5, Link = 6
link = 6
dqFPijTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,link)
