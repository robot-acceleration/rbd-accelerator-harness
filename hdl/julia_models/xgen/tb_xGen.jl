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
CUSTOM_TYPE = Float64 ###Fixed{Int32,24} # data type

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
      # Unit Under Test
      xgen_out = xGen1X0(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,sinq,cosq)
   elseif (li == 2) # Link 2
      xform =
      [-0.927773 0.0 0.373144 0.0 0.0 0.0;
      0.373144 0.0 0.927773 0.0 0.0 0.0;
      0.0 1.0 0.0 0.0 0.0 0.0;
      0.0 -0.187874 0.0 -0.927773 0.0 0.373144;
      0.0 0.0755618 0.0 0.373144 0.0 0.927773;
      -0.2025 0.0 0.0 0.0 1.0 0.0]
      # Unit Under Test
      xgen_out = xGen2X1(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,sinq,cosq)
   elseif (li == 3) # Link 3
      xform =
      [-0.826669 0.0 -0.562689 0.0 0.0 0.0;
      -0.562689 0.0 0.826669 0.0 0.0 0.0;
      0.0 1.0 0.0 0.0 0.0 0.0;
      -0.11507 8.26669e-13 0.169054 -0.826669 0.0 -0.562689;
      0.169054 5.62689e-13 0.11507 -0.562689 0.0 0.826669;
      1.0e-12 0.0 0.0 0.0 1.0 0.0]
      # Unit Under Test
      xgen_out = xGen3X2(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,sinq,cosq)
   elseif (li == 4) # Link 4
      xform =
      [0.999945 0.0 -0.0104451 0.0 0.0 0.0;
      0.0104451 0.0 0.999945 0.0 0.0 0.0;
      0.0 -1.0 0.0 0.0 0.0 0.0;
      0.0 0.215488 0.0 0.999945 0.0 -0.0104451;
      0.0 0.00225091 0.0 0.0104451 0.0 0.999945;
      0.2155 0.0 0.0 0.0 -1.0 0.0]
      # Unit Under Test
      xgen_out = xGen4X3(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,sinq,cosq)
   elseif (li == 5) # Link 5
      xform =
      [-0.668187 0.0 -0.743993 0.0 0.0 0.0;
      -0.743993 0.0 0.668187 0.0 0.0 0.0;
      0.0 1.0 0.0 0.0 0.0 0.0;
      -0.137267 6.68187e-13 0.123281 -0.668187 0.0 -0.743993;
      0.123281 7.43993e-13 0.137267 -0.743993 0.0 0.668187;
      1.0e-12 0.0 0.0 0.0 1.0 0.0]
      # Unit Under Test
      xgen_out = xGen5X4(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,sinq,cosq)
   elseif (li == 6) # Link 6
      xform =
      [0.951994 0.0 0.306117 0.0 0.0 0.0;
      -0.306117 0.0 0.951994 0.0 0.0 0.0;
      0.0 -1.0 0.0 0.0 0.0 0.0;
      -6.12234e-13 0.205155 1.90399e-12 0.951994 0.0 0.306117;
      -1.90399e-12 -0.0659682 -6.12234e-13 -0.306117 0.0 0.951994;
      0.2155 0.0 0.0 0.0 -1.0 0.0]
      # Unit Under Test
      xgen_out = xGen6X5(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,sinq,cosq)
   elseif (li == 7) # Link 7
      xform =
      [0.662605 0.0 0.748969 0.0 0.0 0.0;
      0.748969 0.0 -0.662605 0.0 0.0 0.0;
      0.0 1.0 0.0 0.0 0.0 0.0;
      0.0606665 0.0 -0.053671 0.662605 0.0 0.748969;
      -0.053671 0.0 -0.0606665 0.748969 0.0 -0.662605;
      0.0 0.0 0.0 0.0 1.0 0.0]
      # Unit Under Test
      xgen_out = xGen7X6(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,sinq,cosq)
   end

   #----------------------------------------------------------------------------
   # Format Output
   #----------------------------------------------------------------------------
   xform_out = ones(CUSTOM_TYPE,6,6)
   # ---
   xform_out[AX,AX] = xgen_out[1];  xform_out[AX,AY] = xgen_out[2];  xform_out[AX,AZ] = xgen_out[3];
   xform_out[AY,AX] = xgen_out[4];  xform_out[AY,AY] = xgen_out[5];  xform_out[AY,AZ] = xgen_out[6];
   xform_out[AZ,AX] = 0.0;          xform_out[AZ,AY] = xgen_out[7];  xform_out[AZ,AZ] = xgen_out[8];
   xform_out[LX,AX] = xgen_out[9];  xform_out[LX,AY] = xgen_out[10]; xform_out[LX,AZ] = xgen_out[11];
   xform_out[LY,AX] = xgen_out[12]; xform_out[LY,AY] = xgen_out[13]; xform_out[LY,AZ] = xgen_out[14];
   xform_out[LZ,AX] = xgen_out[15]; xform_out[LZ,AY] = 0.0;          xform_out[LZ,AZ] = 0.0;
   # ---
   xform_out[AX,LX] = 0.0;          xform_out[AX,LY] = 0.0;          xform_out[AX,LZ] = 0.0;
   xform_out[AY,LX] = 0.0;          xform_out[AY,LY] = 0.0;          xform_out[AY,LZ] = 0.0;
   xform_out[AZ,LX] = 0.0;          xform_out[AZ,LY] = 0.0;          xform_out[AZ,LZ] = 0.0;
   # ---
   xform_out[LX,LX] = xgen_out[1];  xform_out[LX,LY] = xgen_out[2];  xform_out[LX,LZ] = xgen_out[3];
   xform_out[LY,LX] = xgen_out[4];  xform_out[LY,LY] = xgen_out[5];  xform_out[LY,LZ] = xgen_out[6];
   xform_out[LZ,LX] = 0.0;          xform_out[LZ,LY] = xgen_out[7];  xform_out[LZ,LZ] = xgen_out[8];

   #----------------------------------------------------------------------------
   # Print Outputs
   #----------------------------------------------------------------------------
   println("Link = ",li)
   println("Expected: ",xform)
   println("Got:      ",xform_out)

   #----------------------------------------------------------------------------
   # Test Outputs
   #----------------------------------------------------------------------------
   @test xform_out ≈ xform atol=1e-5
   println("Test passed!")
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
