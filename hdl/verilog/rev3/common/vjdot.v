`timescale 1ns / 1ps

// * vj term
//
// (4 mult)

//------------------------------------------------------------------------------
// vjdot Module
//------------------------------------------------------------------------------
module vjdot#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // vjval_in
   input  signed[(WIDTH-1):0]
      vjval_in,
   // colvec_in, 6 values
   input  signed[(WIDTH-1):0]
      colvec_in_AX,colvec_in_AY,colvec_in_AZ,colvec_in_LX,colvec_in_LY,colvec_in_LZ,
   // vjvec_out, 6 values
   output signed[(WIDTH-1):0]
      vjvec_out_AX,vjvec_out_AY,vjvec_out_AZ,vjvec_out_LX,vjvec_out_LY,vjvec_out_LZ
   );

   // internal wires and state
   // results from the multiplications
   wire signed[(WIDTH-1):0]
      vjvec_AX,vjvec_AY,vjvec_LX,vjvec_LY;

   // multiplications (4 in ||)
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_vjvec_AX(.a_in( vjval_in),.b_in(colvec_in_AY),.prod_out(vjvec_AX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_vjvec_AY(.a_in(-vjval_in),.b_in(colvec_in_AX),.prod_out(vjvec_AY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_vjvec_LX(.a_in( vjval_in),.b_in(colvec_in_LY),.prod_out(vjvec_LX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_vjvec_LY(.a_in(-vjval_in),.b_in(colvec_in_LX),.prod_out(vjvec_LY));

   // output
   assign vjvec_out_AX = vjvec_AX;
   assign vjvec_out_AY = vjvec_AY;
   assign vjvec_out_AZ = 0;
   assign vjvec_out_LX = vjvec_LX;
   assign vjvec_out_LY = vjvec_LY;
   assign vjvec_out_LZ = 0;

endmodule
