`timescale 1ns / 1ps

// Force Cross Matrix Multiplication by a Vector
//
// (18 mult, 12 add)

//------------------------------------------------------------------------------
// fxdot Module
//------------------------------------------------------------------------------
module fxdot#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // fxvec_in, 6 values
   input  signed[(WIDTH-1):0]
      fxvec_in_AX,fxvec_in_AY,fxvec_in_AZ,fxvec_in_LX,fxvec_in_LY,fxvec_in_LZ,
   // dotvec_in, 6 values
   input  signed[(WIDTH-1):0]
      dotvec_in_AX,dotvec_in_AY,dotvec_in_AZ,dotvec_in_LX,dotvec_in_LY,dotvec_in_LZ,
   // fxdotvec_out, 6 values
   output signed[(WIDTH-1):0]
      fxdotvec_out_AX,fxdotvec_out_AY,fxdotvec_out_AZ,fxdotvec_out_LX,fxdotvec_out_LY,fxdotvec_out_LZ
   );

   // internal wires and state
   // results from the multiplications
   wire signed[(WIDTH-1):0]
      fxdotvec_AZ_AY,fxdotvec_AY_AZ,fxdotvec_LZ_LY,fxdotvec_LY_LZ,
      fxdotvec_AZ_AX,fxdotvec_AX_AZ,fxdotvec_LZ_LX,fxdotvec_LX_LZ,
      fxdotvec_AY_AX,fxdotvec_AX_AY,fxdotvec_LY_LX,fxdotvec_LX_LY,
      fxdotvec_AZ_LY,fxdotvec_AY_LZ,
      fxdotvec_AZ_LX,fxdotvec_AX_LZ,
      fxdotvec_AY_LX,fxdotvec_AX_LY;
   // results from layer 1 of additions
   wire signed[(WIDTH-1):0]
      fxdotvec_AX1,fxdotvec_AX2,
      fxdotvec_AY1,fxdotvec_AY2,
      fxdotvec_AZ1,fxdotvec_AZ2,
      fxdotvec_LX,
      fxdotvec_LY,
      fxdotvec_LZ;
   // results from layer 2 of additions
   wire signed[(WIDTH-1):0]
      fxdotvec_AX,
      fxdotvec_AY,
      fxdotvec_AZ;

   // multiplications (18 in ||)
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_AZ_AY(.a_in(-fxvec_in_AZ),.b_in(dotvec_in_AY),.prod_out(fxdotvec_AZ_AY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_AY_AZ(.a_in( fxvec_in_AY),.b_in(dotvec_in_AZ),.prod_out(fxdotvec_AY_AZ));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_LZ_LY(.a_in(-fxvec_in_LZ),.b_in(dotvec_in_LY),.prod_out(fxdotvec_LZ_LY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_LY_LZ(.a_in( fxvec_in_LY),.b_in(dotvec_in_LZ),.prod_out(fxdotvec_LY_LZ));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_AZ_AX(.a_in( fxvec_in_AZ),.b_in(dotvec_in_AX),.prod_out(fxdotvec_AZ_AX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_AX_AZ(.a_in(-fxvec_in_AX),.b_in(dotvec_in_AZ),.prod_out(fxdotvec_AX_AZ));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_LZ_LX(.a_in( fxvec_in_LZ),.b_in(dotvec_in_LX),.prod_out(fxdotvec_LZ_LX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_LX_LZ(.a_in(-fxvec_in_LX),.b_in(dotvec_in_LZ),.prod_out(fxdotvec_LX_LZ));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_AY_AX(.a_in(-fxvec_in_AY),.b_in(dotvec_in_AX),.prod_out(fxdotvec_AY_AX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_AX_AY(.a_in( fxvec_in_AX),.b_in(dotvec_in_AY),.prod_out(fxdotvec_AX_AY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_LY_LX(.a_in(-fxvec_in_LY),.b_in(dotvec_in_LX),.prod_out(fxdotvec_LY_LX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_LX_LY(.a_in( fxvec_in_LX),.b_in(dotvec_in_LY),.prod_out(fxdotvec_LX_LY));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_AZ_LY(.a_in(-fxvec_in_AZ),.b_in(dotvec_in_LY),.prod_out(fxdotvec_AZ_LY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_AY_LZ(.a_in( fxvec_in_AY),.b_in(dotvec_in_LZ),.prod_out(fxdotvec_AY_LZ));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_AZ_LX(.a_in( fxvec_in_AZ),.b_in(dotvec_in_LX),.prod_out(fxdotvec_AZ_LX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_AX_LZ(.a_in(-fxvec_in_AX),.b_in(dotvec_in_LZ),.prod_out(fxdotvec_AX_LZ));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_AY_LX(.a_in(-fxvec_in_AY),.b_in(dotvec_in_LX),.prod_out(fxdotvec_AY_LX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_fxdotvec_AX_LY(.a_in( fxvec_in_AX),.b_in(dotvec_in_LY),.prod_out(fxdotvec_AX_LY));

   // layer 1 of additions (9 in ||)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fxdotvec_AX1(.a_in(fxdotvec_AZ_AY),.b_in(fxdotvec_AY_AZ),.sum_out(fxdotvec_AX1));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fxdotvec_AX2(.a_in(fxdotvec_LZ_LY),.b_in(fxdotvec_LY_LZ),.sum_out(fxdotvec_AX2));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fxdotvec_AY1(.a_in(fxdotvec_AZ_AX),.b_in(fxdotvec_AX_AZ),.sum_out(fxdotvec_AY1));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fxdotvec_AY2(.a_in(fxdotvec_LZ_LX),.b_in(fxdotvec_LX_LZ),.sum_out(fxdotvec_AY2));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fxdotvec_AZ1(.a_in(fxdotvec_AY_AX),.b_in(fxdotvec_AX_AY),.sum_out(fxdotvec_AZ1));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fxdotvec_AZ2(.a_in(fxdotvec_LY_LX),.b_in(fxdotvec_LX_LY),.sum_out(fxdotvec_AZ2));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fxdotvec_LX(.a_in(fxdotvec_AZ_LY),.b_in(fxdotvec_AY_LZ),.sum_out(fxdotvec_LX));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fxdotvec_LY(.a_in(fxdotvec_AZ_LX),.b_in(fxdotvec_AX_LZ),.sum_out(fxdotvec_LY));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fxdotvec_LZ(.a_in(fxdotvec_AY_LX),.b_in(fxdotvec_AX_LY),.sum_out(fxdotvec_LZ));

   // layer 2 of additions (3 in ||)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fxdotvec_AX(.a_in(fxdotvec_AX1),.b_in(fxdotvec_AX2),.sum_out(fxdotvec_AX));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fxdotvec_AY(.a_in(fxdotvec_AY1),.b_in(fxdotvec_AY2),.sum_out(fxdotvec_AY));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fxdotvec_AZ(.a_in(fxdotvec_AZ1),.b_in(fxdotvec_AZ2),.sum_out(fxdotvec_AZ));

   // output
   assign fxdotvec_out_AX = fxdotvec_AX;
   assign fxdotvec_out_AY = fxdotvec_AY;
   assign fxdotvec_out_AZ = fxdotvec_AZ;
   assign fxdotvec_out_LX = fxdotvec_LX;
   assign fxdotvec_out_LY = fxdotvec_LY;
   assign fxdotvec_out_LZ = fxdotvec_LZ;

endmodule
