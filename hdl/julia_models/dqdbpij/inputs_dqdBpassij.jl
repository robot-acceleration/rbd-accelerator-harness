# inputs_dqdBpassij
#
# Format the Inputs for dqdfpassij.v

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra
using FixedPointNumbers
using Test
include("../../../type_generic/dynamics/helpers_iiwa.jl")
include("dqdBpassij.jl") # dqdBpassij

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
function dqdBpassijTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,link)
   #----------------------------------------------------------------------------
   # Inputs and Expected Outputs
   #----------------------------------------------------------------------------
   # Input 5
   if (link == 7)
      # Link 7
      xform = [0.662605 0.0 0.748969 0.0 0.0 0.0; 0.748969 0.0 -0.662605 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; 0.0606665 0.0 -0.053671 0.662605 0.0 0.748969; -0.053671 0.0 -0.0606665 0.748969 0.0 -0.662605; 0.0 0.0 0.0 0.0 1.0 0.0]
      lcurr_dfi_dqd = [0.000520647, 0.00165163, -0.000351123, 0.0461907, 0.0152324, -0.0115452]
      lprev_dfi_dqd = [0.00514722, -0.0012909, -0.00227473, 0.00117916, -0.0014017, -0.00250583]
      dtaui_dqdj_out = -0.000351123
      lprev_dfi_dqd_out = [0.00871391, -0.00164202, -0.00638236, 0.0431939, -0.0129469, 0.0219965]
   elseif (link == 6)
      # Link 6
      xform = [0.951994 0.0 0.306117 0.0 0.0 0.0; -0.306117 0.0 0.951994 0.0 0.0 0.0; 0.0 -1.0 0.0 0.0 0.0 0.0; -6.12234e-13 0.205155 1.90399e-12 0.951994 0.0 0.306117; -1.90399e-12 -0.0659682 -6.12234e-13 -0.306117 0.0 0.951994; 0.2155 0.0 0.0 0.0 -1.0 0.0]
      lcurr_dfi_dqd = [0.00871391, -0.00164202, -0.00638236, 0.0431939, -0.0129469, 0.0219965]
      lprev_dfi_dqd = [0.0188723, 0.000236705, 0.0, -0.000797862, -0.167551, 0.0515384]
      dtaui_dqdj_out = -0.006382357287507
      lprev_dfi_dqd_out = [0.0324108, 0.0163346, 0.00110428, 0.0442858, -0.189548, 0.0524354]
   elseif (link == 5)
      # Link 5
      xform = [-0.668187 0.0 -0.743993 0.0 0.0 0.0; -0.743993 0.0 0.668187 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; -0.137267 6.68187e-13 0.123281 -0.668187 0.0 -0.743993; 0.123281 7.43993e-13 0.137267 -0.743993 0.0 0.668187; 1.0e-12 0.0 0.0 0.0 1.0 0.0]
      lcurr_dfi_dqd = [0.0324108, 0.0163346, 0.00110428, 0.0442858, -0.189548, 0.0524354]
      lprev_dfi_dqd = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      dtaui_dqdj_out = 0.0011042808424745157
      lprev_dfi_dqd_out = [-0.0632559, 0.00110428, -0.0337579, 0.111431, 0.0524354, -0.159601]
   elseif (link == 4)
      # Link 4
      xform = [0.999945 0.0 -0.0104451 0.0 0.0 0.0; 0.0104451 0.0 0.999945 0.0 0.0 0.0; 0.0 -1.0 0.0 0.0 0.0 0.0; 0.0 0.215488 0.0 0.999945 0.0 -0.0104451; 0.0 0.00225091 0.0 0.0104451 0.0 0.999945; 0.2155 0.0 0.0 0.0 -1.0 0.0]
      lcurr_dfi_dqd = [-0.0632559, 0.00110428, -0.0337579, 0.111431, 0.0524354, -0.159601]
      lprev_dfi_dqd = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      dtaui_dqdj_out = -0.03375785742138673
      lprev_dfi_dqd_out = [-0.097635, 0.0578879, 0.00176493, 0.111972, 0.159601, 0.0512686]
   elseif (link == 3)
      # Link 3
      xform = [-0.826669 0.0 -0.562689 0.0 0.0 0.0; -0.562689 0.0 0.826669 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; -0.11507 8.26669e-13 0.169054 -0.826669 0.0 -0.562689; 0.169054 5.62689e-13 0.11507 -0.562689 0.0 0.826669; 1.0e-12 0.0 0.0 0.0 1.0 0.0]
      lcurr_dfi_dqd = [-0.097635, 0.0578879, 0.00176493, 0.111972, 0.159601, 0.0512686]
      lprev_dfi_dqd = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      dtaui_dqdj_out = 0.001764934096427053
      lprev_dfi_dqd_out = [0.0622355, 0.00176493, 0.140087, -0.18237, 0.0512686, 0.068932]
   elseif (link == 2)
      # Link 2
      xform = [-0.927773 0.0 0.373144 0.0 0.0 0.0; 0.373144 0.0 0.927773 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; 0.0 -0.187874 0.0 -0.927773 0.0 0.373144; 0.0 0.0755618 0.0 0.373144 0.0 0.927773; -0.2025 0.0 0.0 0.0 1.0 0.0]
      lcurr_dfi_dqd = [0.0622355, 0.00176493, 0.140087, -0.18237, 0.0512686, 0.068932]
      lprev_dfi_dqd = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      dtaui_dqdj_out = 0.14008698607368833
      lprev_dfi_dqd_out = [-0.0710406, 0.178224, 0.0248603, 0.188329, 0.068932, -0.0204847]
   elseif (link == 1)
      # Link 1
      xform = [0.956134 0.292928 0.0 0.0 0.0 0.0; -0.292928 0.956134 0.0 0.0 0.0 0.0; 0.0 0.0 1.0 0.0 0.0 0.0; -0.0461362 0.150591 0.0 0.956134 0.292928 0.0; -0.150591 -0.0461362 0.0 -0.292928 0.956134 0.0; 0.0 0.0 0.0 0.0 0.0 1.0]
      lcurr_dfi_dqd = [-0.0710406, 0.178224, 0.0248603, 0.188329, 0.068932, -0.0204847]
      lprev_dfi_dqd = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      dtaui_dqdj_out = 0.02486027773693042
      lprev_dfi_dqd_out = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
   else
      # Link 1
      xform = [0.956134 0.292928 0.0 0.0 0.0 0.0; -0.292928 0.956134 0.0 0.0 0.0 0.0; 0.0 0.0 1.0 0.0 0.0 0.0; -0.0461362 0.150591 0.0 0.956134 0.292928 0.0; -0.150591 -0.0461362 0.0 -0.292928 0.956134 0.0; 0.0 0.0 0.0 0.0 0.0 1.0]
      lcurr_dfi_dqd = [-0.0710406, 0.178224, 0.0248603, 0.188329, 0.068932, -0.0204847]
      lprev_dfi_dqd = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      dtaui_dqdj_out = 0.02486027773693042
      lprev_dfi_dqd_out = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
   end

   #----------------------------------------------------------------------------
   # Unit Under Test
   #----------------------------------------------------------------------------
   # variables
   dtaui_dqdj_test = 0.0
   dfi_dqdj_test = zeros(CUSTOM_TYPE,6,1)
   # backward pass step
   dtaui_dqdj_test,
   dfi_dqdj_test = dqdBpassij(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                              xform,lcurr_dfi_dqd,lprev_dfi_dqd)

   #----------------------------------------------------------------------------
   # Print Outputs
   #----------------------------------------------------------------------------
   println("Input 5, Link ",link)
   println("Expected: ",dtaui_dqdj_out)
   println("Got:      ",dtaui_dqdj_test)

   #----------------------------------------------------------------------------
   # Test Outputs
   #----------------------------------------------------------------------------
   @test dtaui_dqdj_out ≈ dtaui_dqdj_test atol=1e-5
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
   # lcurr_dfi_dqd
   for i in 1:length(lcurr_dfi_dqd)
      lcurr_dfi_dqd[i] = round(lcurr_dfi_dqd[i]*(2^DECIMAL_BITS))
   end
   # lprev_dfi_dqd
   for i in 1:length(lprev_dfi_dqd)
      lprev_dfi_dqd[i] = round(lprev_dfi_dqd[i]*(2^DECIMAL_BITS))
   end
   # dtaui_dqdj_out
   dtaui_dqdj_out = round(dtaui_dqdj_out*(2^DECIMAL_BITS))
   # lprev_dfi_dqd_out
   for i in 1:length(lprev_dfi_dqd_out)
      lprev_dfi_dqd_out[i] = round(lprev_dfi_dqd_out[i]*(2^DECIMAL_BITS))
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
   println("dfdqd_curr_in_AX = 32'd",lcurr_dfi_dqd[1],"; dfdqd_curr_in_AY = 32'd",lcurr_dfi_dqd[2],"; dfdqd_curr_in_AZ = 32'd",lcurr_dfi_dqd[3],"; dfdqd_curr_in_LX = 32'd",lcurr_dfi_dqd[4],"; dfdqd_curr_in_LY = 32'd",lcurr_dfi_dqd[5],"; dfdqd_curr_in_LZ = 32'd",lcurr_dfi_dqd[6],";")
   println("dfdqd_prev_in_AX = 32'd",lprev_dfi_dqd[1],"; dfdqd_prev_in_AY = 32'd",lprev_dfi_dqd[2],"; dfdqd_prev_in_AZ = 32'd",lprev_dfi_dqd[3],"; dfdqd_prev_in_LX = 32'd",lprev_dfi_dqd[4],"; dfdqd_prev_in_LY = 32'd",lprev_dfi_dqd[5],"; dfdqd_prev_in_LZ = 32'd",lprev_dfi_dqd[6],";")
   println("#100;")
   println("\$display (\"dtau_dqd     = ",dtaui_dqdj_out,"\");")
   println("\$display (\"dtau_dqd_out = %d\", dtau_dqd_out);")
   println("\$display (\"dfdqd_prev     = ",lprev_dfi_dqd_out[1],", ",lprev_dfi_dqd_out[2],", ",lprev_dfi_dqd_out[3],", ",lprev_dfi_dqd_out[4],", ",lprev_dfi_dqd_out[5],", ",lprev_dfi_dqd_out[6],"\");")
   println("\$display (\"dfdqd_prev_out = %d,%d,%d,%d,%d,%d\", dfdqd_prev_out_AX,dfdqd_prev_out_AY,dfdqd_prev_out_AZ,dfdqd_prev_out_LX,dfdqd_prev_out_LY,dfdqd_prev_out_LZ);")
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
dqdBpassijTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,link)
