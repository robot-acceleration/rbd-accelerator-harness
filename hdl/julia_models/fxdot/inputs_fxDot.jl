# inputs_fxDot
#
# Format the Inputs for fxdot.v

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra
using FixedPointNumbers
using Test
include("../../../type_generic/dynamics/helpers_iiwa.jl")
include("fxDot.jl") # fxDot

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
function fxDotTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,test)
   #----------------------------------------------------------------------------
   # Inputs and Expected Outputs
   #----------------------------------------------------------------------------
   if (test == 1)     # Test 1
      fxvec = [-0.470016; 1.90955; 0.557654; -0.00079912; -8.34731e-6; -0.189019]
      dotvec = [0.0863174; 0.00616641; -0.00288937; 0.0431249; -0.173139; 0.345437]
      fxdotvec = [-0.0416855; 0.0389018; -0.167587; 0.756179; 0.18641; -0.000971081]
   elseif (test == 2) # Test 2
      fxvec = [0.12143; 0.916421; -0.381099; 0.555199; -0.0745189; -0.00228996]
      dotvec = [0.010722; 0.0491835; 0.00171885; 0.476074; -0.168647; -0.00373669]
      fxdotvec = [0.0202112; -0.00331046; -0.0620097; -0.0676955; -0.180978; -0.456763]
   elseif (test == 3) # Test 3
      fxvec = [-0.100832; 0.722306; 2.34665; 0.274428; -0.107102; -8.34731e-6]
      dotvec = [0.0132597; 0.0982598; -0.0245125; 1.07585; -0.142436; 0.000286329]
      fxdotvec = [-0.248319; 0.0285568; 0.0566515; 0.334454; 2.52467; -0.762728]
   end

   #----------------------------------------------------------------------------
   # Convert Values to Fixed-Point Binary
   #----------------------------------------------------------------------------
   for i in 1:length(fxvec)
      fxvec[i] = round(fxvec[i]*(2^DECIMAL_BITS))
   end
   for i in 1:length(dotvec)
      dotvec[i] = round(dotvec[i]*(2^DECIMAL_BITS))
   end
   for i in 1:length(fxdotvec)
      fxdotvec[i] = round(fxdotvec[i]*(2^DECIMAL_BITS))
   end

   #----------------------------------------------------------------------------
   # Print Fixed-Point Binary Values for Vivado Simulation
   #----------------------------------------------------------------------------
   println("// Test = ",test)
   println("fxvec_in_AX = 32'd",fxvec[1],
         "; fxvec_in_AY = 32'd",fxvec[2],
         "; fxvec_in_AZ = 32'd",fxvec[3],
         "; fxvec_in_LX = 32'd",fxvec[4],
         "; fxvec_in_LY = 32'd",fxvec[5],
         "; fxvec_in_LZ = 32'd",fxvec[6],";")
   println("\$display (\"fxvec_in = %d,%d,%d,%d,%d,%d\", fxvec_in_AX,fxvec_in_AY,fxvec_in_AZ,fxvec_in_LX,fxvec_in_LY,fxvec_in_LZ);")
   println("dotvec_in_AX = 32'd",dotvec[1],
         "; dotvec_in_AY = 32'd",dotvec[2],
         "; dotvec_in_AZ = 32'd",dotvec[3],
         "; dotvec_in_LX = 32'd",dotvec[4],
         "; dotvec_in_LY = 32'd",dotvec[5],
         "; dotvec_in_LZ = 32'd",dotvec[6],";")
   println("\$display (\"dotvec_in = %d,%d,%d,%d,%d,%d\", dotvec_in_AX,dotvec_in_AY,dotvec_in_AZ,dotvec_in_LX,dotvec_in_LY,dotvec_in_LZ);")
   println("#100;")
   println("\$display (\"fxdotvec     = ",fxdotvec[1],", ",fxdotvec[2],", ",fxdotvec[3],", ",fxdotvec[4],", ",fxdotvec[5],", ",fxdotvec[6],"\");")
   println("\$display (\"fxdotvec_out = %d,%d,%d,%d,%d,%d\", fxdotvec_out_AX,fxdotvec_out_AY,fxdotvec_out_AZ,fxdotvec_out_LX,fxdotvec_out_LY,fxdotvec_out_LZ);")
   println("// -----------------------------------------------------------------------")
end

#-------------------------------------------------------------------------------
# Set Test Parameters and Run Test
#-------------------------------------------------------------------------------
println("// -----------------------------------------------------------------------")
test = 1;
fxDotTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,test)
test = 2;
fxDotTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,test)
test = 3;
fxDotTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,test)
