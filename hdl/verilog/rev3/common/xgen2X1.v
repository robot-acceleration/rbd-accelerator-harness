`timescale 1ns / 1ps

// Transformation Matrix Generation

//------------------------------------------------------------------------------
// xgen Module for Link 1
//------------------------------------------------------------------------------
module xgen2X1#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // sin(q) and cos(q)
   input  signed[(WIDTH-1):0]
      sinq_in,cosq_in,
   // xform_out, 15 values
   output signed[(WIDTH-1):0]
      xform_out_AX_AX,xform_out_AX_AY,xform_out_AX_AZ,
      xform_out_AY_AX,xform_out_AY_AY,xform_out_AY_AZ,
                     xform_out_AZ_AY,xform_out_AZ_AZ,
      xform_out_LX_AX,xform_out_LX_AY,xform_out_LX_AZ,
      xform_out_LY_AX,xform_out_LY_AY,xform_out_LY_AZ,
      xform_out_LZ_AX                              
   );

   // internal wires and state
   wire signed[(WIDTH-1):0]
      sinq,cosq,nsinq,ncosq;
   wire signed[(WIDTH-1):0]
      xform_AX_AX,xform_AX_AY,xform_AX_AZ,
      xform_AY_AX,xform_AY_AY,xform_AY_AZ,
                 xform_AZ_AY,xform_AZ_AZ,
      xform_LX_AX,xform_LX_AY,xform_LX_AZ,
      xform_LY_AX,xform_LY_AY,xform_LY_AZ,
      xform_LZ_AX                      ;

   assign xform_AX_AY = 32'd0;
   assign xform_AY_AY = 32'd0;
   assign xform_AZ_AY = 32'd65536;
   assign xform_AZ_AZ = 32'd0;
   assign xform_LX_AX = 32'd0;
   assign xform_LX_AZ = 32'd0;
   assign xform_LY_AX = 32'd0;
   assign xform_LY_AZ = 32'd0;
   assign xform_LZ_AX = -32'd13271;

   // variables
   assign sinq  = sinq_in;
   assign nsinq = -sinq_in;
   assign cosq  = cosq_in;
   assign ncosq  = -cosq_in;
   // ---
   assign xform_AX_AX = ncosq;
   assign xform_AX_AZ = sinq;
   assign xform_AY_AX = sinq;
   assign xform_AY_AZ = cosq;

   // multiplications
   // ---
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(-32'd13271))
      cmult_xform_LX_AY(.b_in(cosq),.prod_out(xform_LX_AY));

   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(32'd13271))
      cmult_xform_LY_AY(.b_in(sinq),.prod_out(xform_LY_AY));


   // outputs
   assign xform_out_AX_AX = xform_AX_AX;
   assign xform_out_AX_AY = xform_AX_AY;
   assign xform_out_AX_AZ = xform_AX_AZ;
   assign xform_out_AY_AX = xform_AY_AX;
   assign xform_out_AY_AY = xform_AY_AY;
   assign xform_out_AY_AZ = xform_AY_AZ;
   assign xform_out_AZ_AY = xform_AZ_AY;
   assign xform_out_AZ_AZ = xform_AZ_AZ;
   assign xform_out_LX_AX = xform_LX_AX;
   assign xform_out_LX_AY = xform_LX_AY;
   assign xform_out_LX_AZ = xform_LX_AZ;
   assign xform_out_LY_AX = xform_LY_AX;
   assign xform_out_LY_AY = xform_LY_AY;
   assign xform_out_LY_AZ = xform_LY_AZ;
   assign xform_out_LZ_AX = xform_LZ_AX;

endmodule
