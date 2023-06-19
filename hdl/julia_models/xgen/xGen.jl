# xGen
#
# Based on RobCoGen's Inverse Dynamics for iiwa and Carpentier et al., RSS 2018

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra

#-------------------------------------------------------------------------------
# Generate Transformation Matrix Coefficients from sin(q) and cos(q)
#-------------------------------------------------------------------------------
#    AX AY AZ LX LY LZ
# AX  *  *  *
# AY  *  *  *
# AZ     *  *
# LX  *  *  *  *  *  *
# LY  *  *  *  *  *  *
# LZ  *           *  *

function xGen1X0(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                 sinq,cosq)
   # set parameters
   # -- Joint Translation Constants
   tz_j = CUSTOM_TYPE(0.1574999988079071);
   # -- Link 1 <-- World 0
   xform_AZ_AZ = 1.0;
   xform_AX_AZ = 0.0;
   xform_AY_AZ = 0.0;
   xform_AZ_AY = 0.0;
   xform_LX_AZ = 0.0;
   xform_LY_AZ = 0.0;
   xform_LZ_AX = 0.0;

   # wires
   s_j = sinq;
   c_j = cosq;

   # -- Link 1 <-- World 0
   xform_AX_AX = c_j;
   xform_AX_AY = s_j;
   # ---
   xform_AY_AX = -s_j;
   xform_AY_AY = c_j;
   # ---
   xform_LX_AX = -tz_j * s_j;
   xform_LX_AY =  tz_j * c_j;
   # ---
   xform_LY_AX = -tz_j * c_j;
   xform_LY_AY = -tz_j * s_j;

   return xform_AX_AX,xform_AX_AY,xform_AX_AZ,
          xform_AY_AX,xform_AY_AY,xform_AY_AZ,
                      xform_AZ_AY,xform_AZ_AZ,
          xform_LX_AX,xform_LX_AY,xform_LX_AZ,
          xform_LY_AX,xform_LY_AY,xform_LY_AZ,
          xform_LZ_AX;
end

function xGen2X1(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                 sinq,cosq)
   # set parameters
   # -- Joint Translation Constants
   tz_j = CUSTOM_TYPE(0.20250000059604645);
   # -- Link 2 <-- Link 1
   xform_AZ_AY = 1.0;
   xform_LZ_AX = -tz_j;
   xform_AX_AY = 0.0;
   xform_AY_AY = 0.0;
   xform_AZ_AZ = 0.0;
   xform_LX_AX = 0.0;
   xform_LX_AZ = 0.0;
   xform_LY_AX = 0.0;
   xform_LY_AZ = 0.0;

   # wires
   s_j = sinq;
   c_j = cosq;

   # -- Link 2 <-- Link 1
   xform_AX_AX = -c_j;
   xform_AX_AZ = s_j;
   # ---
   xform_AY_AX = s_j;
   xform_AY_AZ = c_j;
   # ---
   xform_LX_AY = -tz_j * c_j;
   # ---
   xform_LY_AY =  tz_j * s_j;

   return xform_AX_AX,xform_AX_AY,xform_AX_AZ,
          xform_AY_AX,xform_AY_AY,xform_AY_AZ,
                      xform_AZ_AY,xform_AZ_AZ,
          xform_LX_AX,xform_LX_AY,xform_LX_AZ,
          xform_LY_AX,xform_LY_AY,xform_LY_AZ,
          xform_LZ_AX;
end

function xGen3X2(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                 sinq,cosq)
   # set parameters
   # -- Joint Translation Constants
   ty_j = CUSTOM_TYPE(0.2045000046491623);
   tz_j = CUSTOM_TYPE(-9.999999960041972E-13);
   # -- Link 3 <-- Link 2
   xform_AZ_AY = 1.0;
   xform_LZ_AX = -tz_j;
   xform_AX_AY = 0.0;
   xform_AY_AY = 0.0;
   xform_AZ_AZ = 0.0;

   # wires
   s_j = sinq;
   c_j = cosq;

   # -- Link 3 <-- Link 2
   xform_AX_AX = -c_j;
   xform_AX_AZ = s_j;
   # ---
   xform_AY_AX = s_j;
   xform_AY_AZ = c_j;
   # ---
   xform_LX_AX =  ty_j * s_j;
   xform_LX_AY = -tz_j * c_j;
   xform_LX_AZ =  ty_j * c_j;
   # ---
   xform_LY_AX =  ty_j * c_j;
   xform_LY_AY =  tz_j * s_j;
   xform_LY_AZ = -ty_j * s_j;

   return xform_AX_AX,xform_AX_AY,xform_AX_AZ,
          xform_AY_AX,xform_AY_AY,xform_AY_AZ,
                      xform_AZ_AY,xform_AZ_AZ,
          xform_LX_AX,xform_LX_AY,xform_LX_AZ,
          xform_LY_AX,xform_LY_AY,xform_LY_AZ,
          xform_LZ_AX;
end

function xGen4X3(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                 sinq,cosq)
   # set parameters
   # -- Joint Translation Constants
   tz_j = CUSTOM_TYPE(0.21549999713897705);
   # -- Link 4 <-- Link 3
   xform_AZ_AY = -1.0;
   xform_LZ_AX =  tz_j;
   xform_AX_AY = 0.0;
   xform_AY_AY = 0.0;
   xform_AZ_AZ = 0.0;
   xform_LX_AX = 0.0;
   xform_LX_AZ = 0.0;
   xform_LY_AX = 0.0;
   xform_LY_AZ = 0.0;

   # wires
   s_j = sinq;
   c_j = cosq;

   # -- Link 4 <-- Link 3
   xform_AX_AX = c_j;
   xform_AX_AZ = s_j;
   # ---
   xform_AY_AX = -s_j;
   xform_AY_AZ = c_j;
   # ---
   xform_LX_AY =  tz_j * c_j;
   # ---
   xform_LY_AY = -tz_j * s_j;

   return xform_AX_AX,xform_AX_AY,xform_AX_AZ,
          xform_AY_AX,xform_AY_AY,xform_AY_AZ,
                      xform_AZ_AY,xform_AZ_AZ,
          xform_LX_AX,xform_LX_AY,xform_LX_AZ,
          xform_LY_AX,xform_LY_AY,xform_LY_AZ,
          xform_LZ_AX;
end

function xGen5X4(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                 sinq,cosq)
   # set parameters
   # -- Joint Translation Constants
   ty_j = CUSTOM_TYPE(0.18449999392032623);
   tz_j = CUSTOM_TYPE(-9.999999960041972E-13);
   # -- Link 5 <-- Link 4
   xform_AZ_AY = 1.0;
   xform_LZ_AX = -tz_j;
   xform_AX_AY = 0.0;
   xform_AY_AY = 0.0;
   xform_AZ_AZ = 0.0;

   # wires
   s_j = sinq;
   c_j = cosq;

   # -- Link 5 <-- Link 4
   xform_AX_AX = -c_j;
   xform_AX_AZ = s_j;
   # ---
   xform_AY_AX = s_j;
   xform_AY_AZ = c_j;
   # ---
   xform_LX_AX =  ty_j * s_j;
   xform_LX_AY = -tz_j * c_j;
   xform_LX_AZ =  ty_j * c_j;
   # ---
   xform_LY_AX =  ty_j * c_j;
   xform_LY_AY =  tz_j * s_j;
   xform_LY_AZ = -ty_j * s_j;

   return xform_AX_AX,xform_AX_AY,xform_AX_AZ,
          xform_AY_AX,xform_AY_AY,xform_AY_AZ,
                      xform_AZ_AY,xform_AZ_AZ,
          xform_LX_AX,xform_LX_AY,xform_LX_AZ,
          xform_LY_AX,xform_LY_AY,xform_LY_AZ,
          xform_LZ_AX;
end

function xGen6X5(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                 sinq,cosq)
   # set parameters
   # -- Joint Translation Constants
   ty_j = CUSTOM_TYPE(-1.9999999920083944E-12);
   tz_j = CUSTOM_TYPE(0.21549999713897705);
   # -- Link 6 <-- Link 5
   xform_AZ_AY = -1.0;
   xform_LZ_AX =  tz_j;
   xform_AX_AY = 0.0;
   xform_AY_AY = 0.0;
   xform_AZ_AZ = 0.0;

   # wires
   s_j = sinq;
   c_j = cosq;

   # -- Link 6 <-- Link 5
   xform_AX_AX = c_j;
   xform_AX_AZ = s_j;
   # ---
   xform_AY_AX = -s_j;
   xform_AY_AZ = c_j;
   # ---
   xform_LX_AX =  ty_j * s_j;
   xform_LX_AY =  tz_j * c_j;
   xform_LX_AZ = -ty_j * c_j;
   # ---
   xform_LY_AX =  ty_j * c_j;
   xform_LY_AY = -tz_j * s_j;
   xform_LY_AZ =  ty_j * s_j;

   return xform_AX_AX,xform_AX_AY,xform_AX_AZ,
          xform_AY_AX,xform_AY_AY,xform_AY_AZ,
                      xform_AZ_AY,xform_AZ_AZ,
          xform_LX_AX,xform_LX_AY,xform_LX_AZ,
          xform_LY_AX,xform_LY_AY,xform_LY_AZ,
          xform_LZ_AX;
end

function xGen7X6(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                 sinq,cosq)
   # set parameters
   # -- Joint Translation Constants
   ty_j = CUSTOM_TYPE(0.08100000023841858)
   # -- Link 7 <-- Link 6
   xform_AZ_AY = 1.0
   xform_AX_AY = 0.0;
   xform_AY_AY = 0.0;
   xform_AZ_AZ = 0.0;
   xform_LX_AY = 0.0;
   xform_LY_AY = 0.0;
   xform_LZ_AX = 0.0;

   # wires
   s_j = sinq;
   c_j = cosq;

   # -- Link 7 <-- Link 6
   xform_AX_AX = -c_j;
   xform_AX_AZ = s_j;
   # ---
   xform_AY_AX = s_j;
   xform_AY_AZ = c_j;
   # ---
   xform_LX_AX =  ty_j * s_j;
   xform_LX_AZ =  ty_j * c_j;
   # ---
   xform_LY_AX =  ty_j * c_j;
   xform_LY_AZ = -ty_j * s_j;

   return xform_AX_AX,xform_AX_AY,xform_AX_AZ,
          xform_AY_AX,xform_AY_AY,xform_AY_AZ,
                      xform_AZ_AY,xform_AZ_AZ,
          xform_LX_AX,xform_LX_AY,xform_LX_AZ,
          xform_LY_AX,xform_LY_AY,xform_LY_AZ,
          xform_LZ_AX;
end
