# inputs_vjDot
#
# Format the Inputs for vjdot.v

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra
using FixedPointNumbers
using Test
include("../../../type_generic/dynamics/helpers_iiwa.jl")
include("vjDot.jl") # vjDot

#-------------------------------------------------------------------------------
# Data Type
#-------------------------------------------------------------------------------
CUSTOM_TYPE = Float64 ###Fixed{Int32,24} # data type

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
# Define Test Function
#-------------------------------------------------------------------------------
function vjDotTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,test)
   #----------------------------------------------------------------------------
   # Inputs and Expected Outputs
   #----------------------------------------------------------------------------
   if (test == 1)     # Test 1
      vjval = 0.555751087
      colvec = [-0.00190267; -1.98746e-5; -0.450045; 0.189009; 0.00197431; -0.000799164]
      vjvec = [-1.10453e-5; 0.00105741; 0.0; 0.00109723; -0.105042; 0.0]
   elseif (test == 2) # Test 2
      vjval = 0.437107975
      colvec = [0.336102; -0.299299; -1.98746e-5; -0.180919; -0.203166; 0.00197431]
      vjvec = [-0.130826; -0.146913; 0.0; -0.0888054; 0.0790812; 0.0]
   elseif (test == 3) # Test 3
      vjval = 0.773223048
      colvec = [-0.687073; 0.606431; -0.399976; 0.598861; 0.525089; -0.232591]
      vjvec = [0.468907; 0.531261; 0.0; 0.406011; -0.463053; 0.0]
   end

   #----------------------------------------------------------------------------
   # Convert Values to Fixed-Point Binary
   #----------------------------------------------------------------------------
   vjval = round(vjval*(2^DECIMAL_BITS))
   for i in 1:length(colvec)
      colvec[i] = round(colvec[i]*(2^DECIMAL_BITS))
   end
   for i in 1:length(vjvec)
      vjvec[i] = round(vjvec[i]*(2^DECIMAL_BITS))
   end

   #----------------------------------------------------------------------------
   # Print Fixed-Point Binary Values for Vivado Simulation
   #----------------------------------------------------------------------------
   println("// Test = ",test)
   println("vjval_in = 32'd",vjval,";")
   println("\$display (\"vjval_in = %d\", vjval_in);")
   println("colvec_in_AX = 32'd",colvec[1],
         "; colvec_in_AY = 32'd",colvec[2],
         "; colvec_in_AZ = 32'd",colvec[3],
         "; colvec_in_LX = 32'd",colvec[4],
         "; colvec_in_LY = 32'd",colvec[5],
         "; colvec_in_LZ = 32'd",colvec[6],";")
   println("\$display (\"colvec_in = %d,%d,%d,%d,%d,%d\", colvec_in_AX,colvec_in_AY,colvec_in_AZ,colvec_in_LX,colvec_in_LY,colvec_in_LZ);")
   println("#100;")
   println("\$display (\"vjvec     = ",vjvec[1],", ",vjvec[2],", ",vjvec[3],", ",vjvec[4],", ",vjvec[5],", ",vjvec[6],"\");")
   println("\$display (\"vjvec_out = %d,%d,%d,%d,%d,%d\", vjvec_out_AX,vjvec_out_AY,vjvec_out_AZ,vjvec_out_LX,vjvec_out_LY,vjvec_out_LZ);")
   println("// -----------------------------------------------------------------------")
end

#-------------------------------------------------------------------------------
# Set Test Parameters and Run Test
#-------------------------------------------------------------------------------
test = 1;
vjDotTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,test)
test = 2;
vjDotTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,test)
test = 3;
vjDotTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,test)
