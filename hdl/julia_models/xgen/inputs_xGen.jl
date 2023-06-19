# tb_xGen
#
# Testbench for xGen.jl

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra
using FixedPointNumbers
using Test
include("../../../type_generic/dynamics/helpers_iiwa.jl")
include("xGen.jl") # xGen

#-------------------------------------------------------------------------------
# Data Type
#-------------------------------------------------------------------------------
CUSTOM_TYPE = Fixed{Int32,16} # data type

#-------------------------------------------------------------------------------
# Fixed-Point Parameters
#-------------------------------------------------------------------------------
WIDTH = 32
DECIMAL_BITS = 16

#-------------------------------------------------------------------------------
# Set Constants
#-------------------------------------------------------------------------------
X,Y,Z,AX,AY,AZ,LX,LY,LZ,g = initConstants(CUSTOM_TYPE)

#-------------------------------------------------------------------------------
# Set Inputs
#-------------------------------------------------------------------------------
q1   = CUSTOM_TYPE(0.297287985)
q2   = CUSTOM_TYPE(0.382395968)
q3   = CUSTOM_TYPE(-0.597634477)
q4   = CUSTOM_TYPE(-0.010445245)
q5   = CUSTOM_TYPE(-0.839026854)
q6   = CUSTOM_TYPE(0.311111338)
q7   = CUSTOM_TYPE(2.295087824)
q    = [q1, q2, q3, q4, q5, q6, q7]

#-------------------------------------------------------------------------------
# Define Test Function
#-------------------------------------------------------------------------------
function xGenTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,li)
   #----------------------------------------------------------------------------
   # Inputs and Expected Outputs
   #----------------------------------------------------------------------------
   sinq = sin(q[li])
   cosq = cos(q[li])
   if (li == 1) # Link 1
      xform =
      [0.956134 0.292928 0.0 0.0 0.0 0.0;
      -0.292928 0.956134 0.0 0.0 0.0 0.0;
      0.0 0.0 1.0 0.0 0.0 0.0;
      -0.0461362 0.150591 0.0 0.956134 0.292928 0.0;
      -0.150591 -0.0461362 0.0 -0.292928 0.956134 0.0;
      0.0 0.0 0.0 0.0 0.0 1.0]
      ty_bool = false
      tz_bool = true
      tz_j = 0.1574999988079071
   elseif (li == 2) # Link 2
      xform =
      [-0.927773 0.0 0.373144 0.0 0.0 0.0;
      0.373144 0.0 0.927773 0.0 0.0 0.0;
      0.0 1.0 0.0 0.0 0.0 0.0;
      0.0 -0.187874 0.0 -0.927773 0.0 0.373144;
      0.0 0.0755618 0.0 0.373144 0.0 0.927773;
      -0.2025 0.0 0.0 0.0 1.0 0.0]
      ty_bool = false
      tz_bool = true
      tz_j = 0.20250000059604645
   elseif (li == 3) # Link 3
      xform =
      [-0.826669 0.0 -0.562689 0.0 0.0 0.0;
      -0.562689 0.0 0.826669 0.0 0.0 0.0;
      0.0 1.0 0.0 0.0 0.0 0.0;
      -0.11507 8.26669e-13 0.169054 -0.826669 0.0 -0.562689;
      0.169054 5.62689e-13 0.11507 -0.562689 0.0 0.826669;
      1.0e-12 0.0 0.0 0.0 1.0 0.0]
      ty_bool = true
      tz_bool = true
      ty_j = 0.2045000046491623
      tz_j = -9.999999960041972E-13
   elseif (li == 4) # Link 4
      xform =
      [0.999945 0.0 -0.0104451 0.0 0.0 0.0;
      0.0104451 0.0 0.999945 0.0 0.0 0.0;
      0.0 -1.0 0.0 0.0 0.0 0.0;
      0.0 0.215488 0.0 0.999945 0.0 -0.0104451;
      0.0 0.00225091 0.0 0.0104451 0.0 0.999945;
      0.2155 0.0 0.0 0.0 -1.0 0.0]
      ty_bool = false
      tz_bool = true
      tz_j = 0.21549999713897705
   elseif (li == 5) # Link 5
      xform =
      [-0.668187 0.0 -0.743993 0.0 0.0 0.0;
      -0.743993 0.0 0.668187 0.0 0.0 0.0;
      0.0 1.0 0.0 0.0 0.0 0.0;
      -0.137267 6.68187e-13 0.123281 -0.668187 0.0 -0.743993;
      0.123281 7.43993e-13 0.137267 -0.743993 0.0 0.668187;
      1.0e-12 0.0 0.0 0.0 1.0 0.0]
      ty_bool = true
      tz_bool = true
      ty_j = 0.18449999392032623
      tz_j = -9.999999960041972E-13
   elseif (li == 6) # Link 6
      xform =
      [0.951994 0.0 0.306117 0.0 0.0 0.0;
      -0.306117 0.0 0.951994 0.0 0.0 0.0;
      0.0 -1.0 0.0 0.0 0.0 0.0;
      -6.12234e-13 0.205155 1.90399e-12 0.951994 0.0 0.306117;
      -1.90399e-12 -0.0659682 -6.12234e-13 -0.306117 0.0 0.951994;
      0.2155 0.0 0.0 0.0 -1.0 0.0]
      ty_bool = true
      tz_bool = true
      ty_j = -1.9999999920083944E-12
      tz_j = 0.21549999713897705
   elseif (li == 7) # Link 7
      xform =
      [0.662605 0.0 0.748969 0.0 0.0 0.0;
      0.748969 0.0 -0.662605 0.0 0.0 0.0;
      0.0 1.0 0.0 0.0 0.0 0.0;
      0.0606665 0.0 -0.053671 0.662605 0.0 0.748969;
      -0.053671 0.0 -0.0606665 0.748969 0.0 -0.662605;
      0.0 0.0 0.0 0.0 1.0 0.0]
      ty_bool = true
      tz_bool = false
      ty_j = 0.08100000023841858
   end

   #----------------------------------------------------------------------------
   # Convert Values to Fixed-Point Binary
   #----------------------------------------------------------------------------
   sinq = round(sinq*(2^DECIMAL_BITS))
   cosq = round(cosq*(2^DECIMAL_BITS))
   if (ty_bool == true)
      nty_j = -ty_j
      ty_j  = round(ty_j*(2^DECIMAL_BITS))
      nty_j = round(nty_j*(2^DECIMAL_BITS))
   end
   if (tz_bool == true)
      ntz_j = -tz_j
      tz_j  = round(tz_j*(2^DECIMAL_BITS))
      ntz_j = round(ntz_j*(2^DECIMAL_BITS))
   end
   for i in 1:size(xform)[1] # rows
      for j in 1:size(xform)[2] # cols
         xform[i,j] = round(xform[i,j]*(2^DECIMAL_BITS))
      end
   end

   #----------------------------------------------------------------------------
   # Print Fixed-Point Binary Values for Verilog Module Constants
   #----------------------------------------------------------------------------
   # println("// parameters, link ",li)
   # if (ty_bool == true)
      # println("parameter TY  = 32'd",ty_j,";")
      # println("parameter NTY = 32'd",nty_j,";")
   # end
   # if (tz_bool == true)
      # println("parameter TZ  = 32'd",tz_j,";")
      # println("parameter NTZ = 32'd",ntz_j,";")
   # end
   # println("// -----------------------------------------------------------------------")

   #----------------------------------------------------------------------------
   # Print Fixed-Point Binary Values for Vivado Simulation
   #----------------------------------------------------------------------------
   println("\$display (\"//------------------------------------------------------------------------\");")
   println("\$display (\"// Link = ",li,"\");")
   println("\$display (\"//------------------------------------------------------------------------\");")
   println("sinq_l",li," = 32'd",sinq,";")
   println("cosq_l",li," = 32'd",cosq,";")
   println("\$display (\"sinq,cosq = %d,%d\", sinq_l",li,",cosq_l",li,");")
   println("xform_ref_AX_AX = 32'd",xform[1,1],"; xform_ref_AX_AY = 32'd",xform[1,2],"; xform_ref_AX_AZ = 32'd",xform[1,3],"; xform_ref_AX_LX = 32'd",xform[1,4],"; xform_ref_AX_LY = 32'd",xform[1,5],"; xform_ref_AX_LZ = 32'd",xform[1,6],";")
   println("xform_ref_AY_AX = 32'd",xform[2,1],"; xform_ref_AY_AY = 32'd",xform[2,2],"; xform_ref_AY_AZ = 32'd",xform[2,3],"; xform_ref_AY_LX = 32'd",xform[2,4],"; xform_ref_AY_LY = 32'd",xform[2,5],"; xform_ref_AY_LZ = 32'd",xform[2,6],";")
   println("xform_ref_AZ_AX = 32'd",xform[3,1],"; xform_ref_AZ_AY = 32'd",xform[3,2],"; xform_ref_AZ_AZ = 32'd",xform[3,3],"; xform_ref_AZ_LX = 32'd",xform[3,4],"; xform_ref_AZ_LY = 32'd",xform[3,5],"; xform_ref_AZ_LZ = 32'd",xform[3,6],";")
   println("xform_ref_LX_AX = 32'd",xform[4,1],"; xform_ref_LX_AY = 32'd",xform[4,2],"; xform_ref_LX_AZ = 32'd",xform[4,3],"; xform_ref_LX_LX = 32'd",xform[4,4],"; xform_ref_LX_LY = 32'd",xform[4,5],"; xform_ref_LX_LZ = 32'd",xform[4,6],";")
   println("xform_ref_LY_AX = 32'd",xform[5,1],"; xform_ref_LY_AY = 32'd",xform[5,2],"; xform_ref_LY_AZ = 32'd",xform[5,3],"; xform_ref_LY_LX = 32'd",xform[5,4],"; xform_ref_LY_LY = 32'd",xform[5,5],"; xform_ref_LY_LZ = 32'd",xform[5,6],";")
   println("xform_ref_LZ_AX = 32'd",xform[6,1],"; xform_ref_LZ_AY = 32'd",xform[6,2],"; xform_ref_LZ_AZ = 32'd",xform[6,3],"; xform_ref_LZ_LX = 32'd",xform[6,4],"; xform_ref_LZ_LY = 32'd",xform[6,5],"; xform_ref_LZ_LZ = 32'd",xform[6,6],";")
   println("\$display (\"xform_ref =\");")
   println("\$display (\"%d,%d,%d,%d,%d,%d\", xform_ref_AX_AX,xform_ref_AX_AY,xform_ref_AX_AZ,xform_ref_AX_LX,xform_ref_AX_LY,xform_ref_AX_LZ);")
   println("\$display (\"%d,%d,%d,%d,%d,%d\", xform_ref_AY_AX,xform_ref_AY_AY,xform_ref_AY_AZ,xform_ref_AY_LX,xform_ref_AY_LY,xform_ref_AY_LZ);")
   println("\$display (\"%d,%d,%d,%d,%d,%d\", xform_ref_AZ_AX,xform_ref_AZ_AY,xform_ref_AZ_AZ,xform_ref_AZ_LX,xform_ref_AZ_LY,xform_ref_AZ_LZ);")
   println("\$display (\"%d,%d,%d,%d,%d,%d\", xform_ref_LX_AX,xform_ref_LX_AY,xform_ref_LX_AZ,xform_ref_LX_LX,xform_ref_LX_LY,xform_ref_LX_LZ);")
   println("\$display (\"%d,%d,%d,%d,%d,%d\", xform_ref_LY_AX,xform_ref_LY_AY,xform_ref_LY_AZ,xform_ref_LY_LX,xform_ref_LY_LY,xform_ref_LY_LZ);")
   println("\$display (\"%d,%d,%d,%d,%d,%d\", xform_ref_LZ_AX,xform_ref_LZ_AY,xform_ref_LZ_AZ,xform_ref_LZ_LX,xform_ref_LZ_LY,xform_ref_LZ_LZ);")
   println("#100;")
   println("\$display (\"xform_l",li,"_out =\");")
   println("\$display (\"%d,%d,%d,\\t\\t  0,\\t\\t  0,\\t\\t  0\",      xform_l",li,"_out_AX_AX,xform_l",li,"_out_AX_AY,xform_l",li,"_out_AX_AZ);")
   println("\$display (\"%d,%d,%d,\\t\\t  0,\\t\\t  0,\\t\\t  0\",      xform_l",li,"_out_AY_AX,xform_l",li,"_out_AY_AY,xform_l",li,"_out_AY_AZ);")
   println("\$display (\"\\t\\t  0,%d,%d,\\t\\t  0,\\t\\t  0,\\t\\t  0\",                         xform_l",li,"_out_AZ_AY,xform_l",li,"_out_AZ_AZ);")
   println("\$display (\"%d,%d,%d,%d,%d,%d\",                     xform_l",li,"_out_LX_AX,xform_l",li,"_out_LX_AY,xform_l",li,"_out_LX_AZ,xform_l",li,"_out_AX_AX,xform_l",li,"_out_AX_AY,xform_l",li,"_out_AX_AZ);")
   println("\$display (\"%d,%d,%d,%d,%d,%d\",                     xform_l",li,"_out_LY_AX,xform_l",li,"_out_LY_AY,xform_l",li,"_out_LY_AZ,xform_l",li,"_out_AY_AX,xform_l",li,"_out_AY_AY,xform_l",li,"_out_AY_AZ);")
   println("\$display (\"%d,\\t\\t  0,\\t\\t  0,\\t\\t  0,%d,%d\",      xform_l",li,"_out_LZ_AX,                                                                        xform_l",li,"_out_AZ_AY,xform_l",li,"_out_AZ_AZ);")
end

#-------------------------------------------------------------------------------
# Set Test Parameters and Run Test
#-------------------------------------------------------------------------------
li = 1
xGenTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,li)
li = 2
xGenTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,li)
li = 3
xGenTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,li)
li = 4
xGenTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,li)
li = 5
xGenTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,li)
li = 6
xGenTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,li)
li = 7
xGenTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,li)
