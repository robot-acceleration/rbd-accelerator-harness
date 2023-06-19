`timescale 1ns / 1ps

// Transformation Matrix Multiplication by a Vector
//
// (23 mult, 17 add)
//       0  1  2  3  4  5 vec
//      AX AY AZ LX LY LZ
// 0 AX  0  1  2
// 1 AY  3  4  5
// 2 AZ     6  7
// 3 LX  8  9 10 11 12 13
// 4 LY 14 15 16 17 18 19
// 5 LZ 20          21 22
// xvec                  xform

//------------------------------------------------------------------------------
// xdot Module
//------------------------------------------------------------------------------
module xdot#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // mcross boolean
   input  mcross,
   // xform_in, 23 values
   input  signed[(WIDTH-1):0]
      xform_in_AX_AX,xform_in_AX_AY,xform_in_AX_AZ,
      xform_in_AY_AX,xform_in_AY_AY,xform_in_AY_AZ,
                     xform_in_AZ_AY,xform_in_AZ_AZ,
      xform_in_LX_AX,xform_in_LX_AY,xform_in_LX_AZ,xform_in_LX_LX,xform_in_LX_LY,xform_in_LX_LZ,
      xform_in_LY_AX,xform_in_LY_AY,xform_in_LY_AZ,xform_in_LY_LX,xform_in_LY_LY,xform_in_LY_LZ,
      xform_in_LZ_AX,                                             xform_in_LZ_LY,xform_in_LZ_LZ,
   // vec_in, 6 values
   input  signed[(WIDTH-1):0]
      vec_in_AX,vec_in_AY,vec_in_AZ,vec_in_LX,vec_in_LY,vec_in_LZ,
   // xvec_out, 6 values
   output signed[(WIDTH-1):0]
      xvec_out_AX,xvec_out_AY,xvec_out_AZ,xvec_out_LX,xvec_out_LY,xvec_out_LZ
   );

   // internal wires and state
   // results from the multiplications
   wire signed[(WIDTH-1):0]
      xvec_AX_AX,xvec_AX_AY,xvec_AX_AZ,
      xvec_AY_AX,xvec_AY_AY,xvec_AY_AZ,
                 xvec_AZ_AY,xvec_AZ_AZ,
      xvec_LX_AX,xvec_LX_AY,xvec_LX_AZ,xvec_LX_LX,xvec_LX_LY,xvec_LX_LZ,
      xvec_LY_AX,xvec_LY_AY,xvec_LY_AZ,xvec_LY_LX,xvec_LY_LY,xvec_LY_LZ,
      xvec_LZ_AX,                                 xvec_LZ_LY,xvec_LZ_LZ;
   // results from layer 1 of additions
   wire signed[(WIDTH-1):0]
      xvec_AX_AXAY,
      xvec_AY_AXAY,
      xvec_AZ_AYAZ,
      xvec_LX_AXAY,xvec_LX_AZLX,xvec_LX_LYLZ,
      xvec_LY_AXAY,xvec_LY_AZLX,xvec_LY_LYLZ,
      xvec_LZ_AXLY;
   // results from layer 2 of additions
   wire signed[(WIDTH-1):0]
      xvec_AX_AXAYAZ,
      xvec_AY_AXAYAZ,
      xvec_LX_AXAYAZLX,
      xvec_LY_AXAYAZLX,
      xvec_LZ_AXLYLZ;
   // results from layer 3 of additions
   wire signed[(WIDTH-1):0]
      xvec_LX_AXAYAZLXLYLZ,
      xvec_LY_AXAYAZLXLYLZ;

   // multiplications (23 in ||)
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_AX_AX(.a_in(xform_in_AX_AX),.b_in(vec_in_AX),.prod_out(xvec_AX_AX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_AX_AY(.a_in(xform_in_AX_AY),.b_in(vec_in_AY),.prod_out(xvec_AX_AY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_AX_AZ(.a_in(xform_in_AX_AZ),.b_in(vec_in_AZ),.prod_out(xvec_AX_AZ));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_AY_AX(.a_in(xform_in_AY_AX),.b_in(vec_in_AX),.prod_out(xvec_AY_AX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_AY_AY(.a_in(xform_in_AY_AY),.b_in(vec_in_AY),.prod_out(xvec_AY_AY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_AY_AZ(.a_in(xform_in_AY_AZ),.b_in(vec_in_AZ),.prod_out(xvec_AY_AZ));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_AZ_AY(.a_in(xform_in_AZ_AY),.b_in(vec_in_AY),.prod_out(xvec_AZ_AY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_AZ_AZ(.a_in(xform_in_AZ_AZ),.b_in(vec_in_AZ),.prod_out(xvec_AZ_AZ));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LX_AX(.a_in(xform_in_LX_AX),.b_in(vec_in_AX),.prod_out(xvec_LX_AX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LX_AY(.a_in(xform_in_LX_AY),.b_in(vec_in_AY),.prod_out(xvec_LX_AY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LX_AZ(.a_in(xform_in_LX_AZ),.b_in(vec_in_AZ),.prod_out(xvec_LX_AZ));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LX_LX(.a_in(xform_in_LX_LX),.b_in(vec_in_LX),.prod_out(xvec_LX_LX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LX_LY(.a_in(xform_in_LX_LY),.b_in(vec_in_LY),.prod_out(xvec_LX_LY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LX_LZ(.a_in(xform_in_LX_LZ),.b_in(vec_in_LZ),.prod_out(xvec_LX_LZ));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LY_AX(.a_in(xform_in_LY_AX),.b_in(vec_in_AX),.prod_out(xvec_LY_AX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LY_AY(.a_in(xform_in_LY_AY),.b_in(vec_in_AY),.prod_out(xvec_LY_AY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LY_AZ(.a_in(xform_in_LY_AZ),.b_in(vec_in_AZ),.prod_out(xvec_LY_AZ));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LY_LX(.a_in(xform_in_LY_LX),.b_in(vec_in_LX),.prod_out(xvec_LY_LX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LY_LY(.a_in(xform_in_LY_LY),.b_in(vec_in_LY),.prod_out(xvec_LY_LY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LY_LZ(.a_in(xform_in_LY_LZ),.b_in(vec_in_LZ),.prod_out(xvec_LY_LZ));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LZ_AX(.a_in(xform_in_LZ_AX),.b_in(vec_in_AX),.prod_out(xvec_LZ_AX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LZ_LY(.a_in(xform_in_LZ_LY),.b_in(vec_in_LY),.prod_out(xvec_LZ_LY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xvec_LZ_LZ(.a_in(xform_in_LZ_LZ),.b_in(vec_in_LZ),.prod_out(xvec_LZ_LZ));

   // layer 1 of additions (10 in ||)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_AX_AXAY(.a_in(xvec_AX_AX),.b_in(xvec_AX_AY),.sum_out(xvec_AX_AXAY));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_AY_AXAY(.a_in(xvec_AY_AX),.b_in(xvec_AY_AY),.sum_out(xvec_AY_AXAY));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_AZ_AYAZ(.a_in(xvec_AZ_AY),.b_in(xvec_AZ_AZ),.sum_out(xvec_AZ_AYAZ));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_LX_AXAY(.a_in(xvec_LX_AX),.b_in(xvec_LX_AY),.sum_out(xvec_LX_AXAY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_LX_AZLX(.a_in(xvec_LX_AZ),.b_in(xvec_LX_LX),.sum_out(xvec_LX_AZLX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_LX_LYLZ(.a_in(xvec_LX_LY),.b_in(xvec_LX_LZ),.sum_out(xvec_LX_LYLZ));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_LY_AXAY(.a_in(xvec_LY_AX),.b_in(xvec_LY_AY),.sum_out(xvec_LY_AXAY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_LY_AZLX(.a_in(xvec_LY_AZ),.b_in(xvec_LY_LX),.sum_out(xvec_LY_AZLX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_LY_LYLZ(.a_in(xvec_LY_LY),.b_in(xvec_LY_LZ),.sum_out(xvec_LY_LYLZ));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_LZ_AXLY(.a_in(xvec_LZ_AX),.b_in(xvec_LZ_LY),.sum_out(xvec_LZ_AXLY));

   // layer 2 of additions (5 in ||)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_AX_AXAYAZ(.a_in(xvec_AX_AXAY),.b_in(xvec_AX_AZ),.sum_out(xvec_AX_AXAYAZ));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_AY_AXAYAZ(.a_in(xvec_AY_AXAY),.b_in(xvec_AY_AZ),.sum_out(xvec_AY_AXAYAZ));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_LX_AXAYAZLX(.a_in(xvec_LX_AXAY),.b_in(xvec_LX_AZLX),.sum_out(xvec_LX_AXAYAZLX));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_LY_AXAYAZLX(.a_in(xvec_LY_AXAY),.b_in(xvec_LY_AZLX),.sum_out(xvec_LY_AXAYAZLX));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_LZ_AXLYLZ(.a_in(xvec_LZ_AXLY),.b_in(xvec_LZ_LZ),.sum_out(xvec_LZ_AXLYLZ));

   // layer 3 of additions (2 in ||)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_LX_AXAYAZLXLYLZ(.a_in(xvec_LX_AXAYAZLX),.b_in(xvec_LX_LYLZ),.sum_out(xvec_LX_AXAYAZLXLYLZ));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xvec_LY_AXAYAZLXLYLZ(.a_in(xvec_LY_AXAYAZLX),.b_in(xvec_LY_LYLZ),.sum_out(xvec_LY_AXAYAZLXLYLZ));

   // muxes for mcross
   assign xvec_out_AX = mcross ?  xvec_AY_AXAYAZ       : xvec_AX_AXAYAZ;
   assign xvec_out_AY = mcross ? -xvec_AX_AXAYAZ       : xvec_AY_AXAYAZ;
   assign xvec_out_AZ = mcross ?  0                    : xvec_AZ_AYAZ;
   assign xvec_out_LX = mcross ?  xvec_LY_AXAYAZLXLYLZ : xvec_LX_AXAYAZLXLYLZ;
   assign xvec_out_LY = mcross ? -xvec_LX_AXAYAZLXLYLZ : xvec_LY_AXAYAZLXLYLZ;
   assign xvec_out_LZ = mcross ?  0                    : xvec_LZ_AXLYLZ;

endmodule
