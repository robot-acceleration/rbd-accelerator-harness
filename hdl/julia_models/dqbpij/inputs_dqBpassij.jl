# inputs_dqBpassij
#
# Format the Inputs for dqbpassij.v

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra
using FixedPointNumbers
using Test
include("../../../type_generic/dynamics/helpers_iiwa.jl")
include("dqBpassij.jl") # dqBpassij

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
function dqBpassijTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,link)
   #----------------------------------------------------------------------------
   # Inputs and Expected Outputs
   #----------------------------------------------------------------------------
   # Input 5
   if (link == 7)
      # Link 7
      xform = [0.662605 0.0 0.748969 0.0 0.0 0.0; 0.748969 0.0 -0.662605 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; 0.0606665 0.0 -0.053671 0.662605 0.0 0.748969; -0.053671 0.0 -0.0606665 0.748969 0.0 -0.662605; 0.0 0.0 0.0 0.0 1.0 0.0]
      lcurr_f = [0.122748, -0.0996843, 0.0769509, -1.83586, -2.03848, -0.211055]
      lcurr_dfi_dq = [0.0019181, 0.0136536, -0.00115177, 0.534541, -0.0628049, -0.0932076]
      fcross = false
      lprev_dfi_dq = [0.0142073, -0.00373699, -0.0121177, 1.22403, -0.395695, 2.21509]
      dtaui_dqj_out = -0.00115177
      lprev_dfi_dq_out = [0.0615039, -0.00488876, -0.0446072, 1.53118, -0.488903, 2.65706]
   elseif (link == 6)
      # Link 6
      xform = [0.951994 0.0 0.306117 0.0 0.0 0.0; -0.306117 0.0 0.951994 0.0 0.0 0.0; 0.0 -1.0 0.0 0.0 0.0 0.0; -6.12234e-13 0.205155 1.90399e-12 0.951994 0.0 0.306117; -1.90399e-12 -0.0659682 -6.12234e-13 -0.306117 0.0 0.951994; 0.2155 0.0 0.0 0.0 -1.0 0.0]
      lcurr_f = [0.0383153, 0.167, 0.859512, -0.890237, -1.39686, -1.30446]
      lcurr_dfi_dq = [0.0615039, -0.00488876, -0.0446072, 1.53118, -0.488903, 2.65706]
      fcross = false
      lprev_dfi_dq = [0.167419, 0.0882908, -0.00860167, 0.353863, -1.47426, 0.108658]
      dtaui_dqj_out = -0.044607242734250006
      lprev_dfi_dq_out = [0.800063, 0.479279, 0.00557165, 1.9612, -4.13132, 0.111946]
   elseif (link == 5)
      # Link 5
      xform = [-0.668187 0.0 -0.743993 0.0 0.0 0.0; -0.743993 0.0 0.668187 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; -0.137267 6.68187e-13 0.123281 -0.668187 0.0 -0.743993; 0.123281 7.43993e-13 0.137267 -0.743993 0.0 0.668187; 1.0e-12 0.0 0.0 0.0 1.0 0.0]
      lcurr_f = [-0.376703, -0.860545, 0.287702, 0.13818, 1.44749, -1.98613]
      lcurr_dfi_dq = [0.800063, 0.479279, 0.00557165, 1.9612, -4.13132, 0.111946]
      fcross = true
      lprev_dfi_dq = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      dtaui_dqj_out = 0.00557164891288541
      lprev_dfi_dq_out = [-1.74871, 0.00557165, -1.65174, 2.62761, 0.111946, -3.05036]
   elseif (link == 4)
      # Link 4
      xform = [0.999945 0.0 -0.0104451 0.0 0.0 0.0; 0.0104451 0.0 0.999945 0.0 0.0 0.0; 0.0 -1.0 0.0 0.0 0.0 0.0; 0.0 0.215488 0.0 0.999945 0.0 -0.0104451; 0.0 0.00225091 0.0 0.0104451 0.0 0.999945; 0.2155 0.0 0.0 0.0 -1.0 0.0]
      lcurr_f = [0.925628, 0.297174, 0.0203749, -0.839812, -2.1552, -1.17263]
      lcurr_dfi_dq = [-1.74871, 0.00557165, -1.65174, 2.62761, 0.111946, -3.05036]
      fcross = false
      lprev_dfi_dq = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      dtaui_dqj_out = -1.6517363351077985
      lprev_dfi_dq_out = [-2.4059, 2.21821, 0.0238368, 2.62864, 3.05036, 0.0844942]
   elseif (link == 3)
      # Link 3
      xform = [-0.826669 0.0 -0.562689 0.0 0.0 0.0; -0.562689 0.0 0.826669 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; -0.11507 8.26669e-13 0.169054 -0.826669 0.0 -0.562689; 0.169054 5.62689e-13 0.11507 -0.562689 0.0 0.826669; 1.0e-12 0.0 0.0 0.0 1.0 0.0]
      lcurr_f = [0.380028, 0.0151653, 0.251379, 0.210761, 2.40183, -2.49168]
      lcurr_dfi_dq = [-2.4059, 2.21821, 0.0238368, 2.62864, 3.05036, 0.0844942]
      fcross = false
      lprev_dfi_dq = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      dtaui_dqj_out = 0.023836756660107396
      lprev_dfi_dq_out = [0.953924, 0.0238368, 3.98289, -3.88942, 0.0844942, 1.04253]
   elseif (link == 2)
      # Link 2
      xform = [-0.927773 0.0 0.373144 0.0 0.0 0.0; 0.373144 0.0 0.927773 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; 0.0 -0.187874 0.0 -0.927773 0.0 0.373144; 0.0 0.0755618 0.0 0.373144 0.0 0.927773; -0.2025 0.0 0.0 0.0 1.0 0.0]
      lcurr_f = [0.0930661, 0.248573, 0.209472, -1.83265, -2.57865, 1.86775]
      lcurr_dfi_dq = [0.953924, 0.0238368, 3.98289, -3.88942, 0.0844942, 1.04253]
      fcross = false
      lprev_dfi_dq = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      dtaui_dqj_out = 3.9828863833364467
      lprev_dfi_dq_out = [-1.08724, 4.71999, 0.378066, 3.64003, 1.04253, -1.37292]
   elseif (link == 1)
      # Link 1
      xform = [0.956134 0.292928 0.0 0.0 0.0 0.0; -0.292928 0.956134 0.0 0.0 0.0 0.0; 0.0 0.0 1.0 0.0 0.0 0.0; -0.0461362 0.150591 0.0 0.956134 0.292928 0.0; -0.150591 -0.0461362 0.0 -0.292928 0.956134 0.0; 0.0 0.0 0.0 0.0 0.0 1.0]
      lcurr_f = [-0.386208, 0.368599, 0.28119, 0.818636, 1.98773, -3.07625]
      lcurr_dfi_dq = [-1.08724, 4.71999, 0.378066, 3.64003, 1.04253, -1.37292]
      fcross = false
      lprev_dfi_dq = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      dtaui_dqj_out = 0.3780660669220013
      lprev_dfi_dq_out = [-2.7471, 4.69452, 0.378066, 3.17497, 2.06307, -1.37292]
   else
      # Link 1
      xform = [0.956134 0.292928 0.0 0.0 0.0 0.0; -0.292928 0.956134 0.0 0.0 0.0 0.0; 0.0 0.0 1.0 0.0 0.0 0.0; -0.0461362 0.150591 0.0 0.956134 0.292928 0.0; -0.150591 -0.0461362 0.0 -0.292928 0.956134 0.0; 0.0 0.0 0.0 0.0 0.0 1.0]
      lcurr_f = [-0.386208, 0.368599, 0.28119, 0.818636, 1.98773, -3.07625]
      lcurr_dfi_dq = [-1.08724, 4.71999, 0.378066, 3.64003, 1.04253, -1.37292]
      fcross = false
      lprev_dfi_dq = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      dtaui_dqj_out = 0.3780660669220013
      lprev_dfi_dq_out = [-2.7471, 4.69452, 0.378066, 3.17497, 2.06307, -1.37292]
   end

   #----------------------------------------------------------------------------
   # Unit Under Test
   #----------------------------------------------------------------------------
   # variables
   dtaui_dqj_test = 0.0
   dfi_dqj_test = zeros(CUSTOM_TYPE,6,1)
   # backward pass step
   dtaui_dqj_test,
   dfi_dqj_test = dqBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                            xform,lcurr_f,lcurr_dfi_dq,fcross,lprev_dfi_dq)

   #----------------------------------------------------------------------------
   # Print Outputs
   #----------------------------------------------------------------------------
   println("Input 5, Link ",link)
   println("Expected: ",dtaui_dqj_out)
   println("Got:      ",dtaui_dqj_test)

   #----------------------------------------------------------------------------
   # Test Outputs
   #----------------------------------------------------------------------------
   @test dtaui_dqj_out ≈ dtaui_dqj_test atol=1e-5
   println("Test passed!")

   #----------------------------------------------------------------------------
   # Convert Values to Fixed-Point Binary
   #----------------------------------------------------------------------------
   # xform
   for i in 1:size(xform)[1] # rows
      for j in 1:size(xform)[2] # cols
         xform[i,j] = round(xform[i,j]*(2^DECIMAL_BITS))
      end
   end
   # lcurr_f
   for i in 1:length(lcurr_f)
      lcurr_f[i] = round(lcurr_f[i]*(2^DECIMAL_BITS))
   end
   # lcurr_dfi_dq
   for i in 1:length(lcurr_dfi_dq)
      lcurr_dfi_dq[i] = round(lcurr_dfi_dq[i]*(2^DECIMAL_BITS))
   end
   # fcross
   if fcross
      fcross = 1
   else
      fcross = 0
   end
   # lprev_dfi_dq
   for i in 1:length(lprev_dfi_dq)
      lprev_dfi_dq[i] = round(lprev_dfi_dq[i]*(2^DECIMAL_BITS))
   end
   # dtaui_dqj_out
   dtaui_dqj_out = round(dtaui_dqj_out*(2^DECIMAL_BITS))
   # lprev_dfi_dq_out
   for i in 1:length(lprev_dfi_dq_out)
      lprev_dfi_dq_out[i] = round(lprev_dfi_dq_out[i]*(2^DECIMAL_BITS))
   end

   #----------------------------------------------------------------------------
   # Print Fixed-Point Binary Values for Vivado Simulation
   #----------------------------------------------------------------------------
   println("// -----------------------------------------------------------------------")
   println("// Input 5, Link ",link)
   println("// -----------------------------------------------------------------------")
   println("xform_in_AX_AX = 32'd",xform[1,1],"; xform_in_AX_AY = 32'd",xform[1,2],"; xform_in_AX_AZ = 32'd",xform[1,3],";")
   println("xform_in_AY_AX = 32'd",xform[2,1],"; xform_in_AY_AY = 32'd",xform[2,2],"; xform_in_AY_AZ = 32'd",xform[2,3],";")
   println("                                     xform_in_AZ_AY = 32'd",xform[3,2],"; xform_in_AZ_AZ = 32'd",xform[3,3],";")
   println("xform_in_LX_AX = 32'd",xform[4,1],"; xform_in_LX_AY = 32'd",xform[4,2],"; xform_in_LX_AZ = 32'd",xform[4,3],";  xform_in_LX_LX = 32'd",xform[4,4],"; xform_in_LX_LY = 32'd",xform[4,5],"; xform_in_LX_LZ = 32'd",xform[4,6],";")
   println("xform_in_LY_AX = 32'd",xform[5,1],"; xform_in_LY_AY = 32'd",xform[5,2],"; xform_in_LY_AZ = 32'd",xform[5,3],";  xform_in_LY_LX = 32'd",xform[5,4],"; xform_in_LY_LY = 32'd",xform[5,5],"; xform_in_LY_LZ = 32'd",xform[5,6],";")
   println("xform_in_LZ_AX = 32'd",xform[6,1],";                                                                                                                 xform_in_LZ_LY = 32'd",xform[6,5],"; xform_in_LZ_LZ = 32'd",xform[6,6],";")
   println("fcurr_in_AX = 32'd",lcurr_f[1],"; fcurr_in_AY = 32'd",lcurr_f[2],"; fcurr_in_AZ = 32'd",lcurr_f[3],"; fcurr_in_LX = 32'd",lcurr_f[4],"; fcurr_in_LY = 32'd",lcurr_f[5],"; fcurr_in_LZ = 32'd",lcurr_f[6],";")
   println("dfdq_curr_in_AX = 32'd",lcurr_dfi_dq[1],"; dfdq_curr_in_AY = 32'd",lcurr_dfi_dq[2],"; dfdq_curr_in_AZ = 32'd",lcurr_dfi_dq[3],"; dfdq_curr_in_LX = 32'd",lcurr_dfi_dq[4],"; dfdq_curr_in_LY = 32'd",lcurr_dfi_dq[5],"; dfdq_curr_in_LZ = 32'd",lcurr_dfi_dq[6],";")
   println("fcross = ",fcross,";")
   println("dfdq_prev_in_AX = 32'd",lprev_dfi_dq[1],"; dfdq_prev_in_AY = 32'd",lprev_dfi_dq[2],"; dfdq_prev_in_AZ = 32'd",lprev_dfi_dq[3],"; dfdq_prev_in_LX = 32'd",lprev_dfi_dq[4],"; dfdq_prev_in_LY = 32'd",lprev_dfi_dq[5],"; dfdq_prev_in_LZ = 32'd",lprev_dfi_dq[6],";")
   println("#100;")
   println("\$display (\"dtau_dq     = ",dtaui_dqj_out,"\");")
   println("\$display (\"dtau_dq_out = %d\", dtau_dq_out);")
   println("\$display (\"dfdq_prev     = ",lprev_dfi_dq_out[1],", ",lprev_dfi_dq_out[2],", ",lprev_dfi_dq_out[3],", ",lprev_dfi_dq_out[4],", ",lprev_dfi_dq_out[5],", ",lprev_dfi_dq_out[6],"\");")
   println("\$display (\"dfdq_prev_out = %d,%d,%d,%d,%d,%d\", dfdq_prev_out_AX,dfdq_prev_out_AY,dfdq_prev_out_AZ,dfdq_prev_out_LX,dfdq_prev_out_LY,dfdq_prev_out_LZ);")
   println("// -----------------------------------------------------------------------")

end

#-------------------------------------------------------------------------------
# Set Test Parameters and Run Test
#-------------------------------------------------------------------------------
println("// -----------------------------------------------------------------------")
println("// Input 5, Link 6")
println("// -----------------------------------------------------------------------")
# Input 5, Link 6
link = 6
dqBpassijTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,link)
