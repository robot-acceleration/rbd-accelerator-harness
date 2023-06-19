`timescale 1ns / 1ps

// Transformation Matrix Multiplication Transpose by a Vector
//
// (23 mult, 17 add)
//    AX AY AZ LX LY LZ
// AX  *  *     *  *  *
// AY  *  *  *  *  *
// AZ  *  *  *  *  *
// LX           *  *
// LY           *  *  *
// LZ           *  *  *

//------------------------------------------------------------------------------
// xtdot Module
//------------------------------------------------------------------------------
module xtdot#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
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
   // xtvec_out, 6 values
   output signed[(WIDTH-1):0]
      xtvec_out_AX,xtvec_out_AY,xtvec_out_AZ,xtvec_out_LX,xtvec_out_LY,xtvec_out_LZ
   );

   // internal wires and state
   // results from the multiplications
   wire signed[(WIDTH-1):0]
      xtvec_AX_AX,xtvec_AX_AY,            xtvec_AX_LX,xtvec_AX_LY,xtvec_AX_LZ,
      xtvec_AY_AX,xtvec_AY_AY,xtvec_AY_AZ,xtvec_AY_LX,xtvec_AY_LY,
      xtvec_AZ_AX,xtvec_AZ_AY,xtvec_AZ_AZ,xtvec_AZ_LX,xtvec_AZ_LY,
                                          xtvec_LX_LX,xtvec_LX_LY,
                                          xtvec_LY_LX,xtvec_LY_LY,xtvec_LY_LZ,
                                          xtvec_LZ_LX,xtvec_LZ_LY,xtvec_LZ_LZ;
   // results from layer 1 of additions
   wire signed[(WIDTH-1):0]
      xtvec_AX_AXAY,xtvec_AX_LXLY,
      xtvec_AY_AXAY,xtvec_AY_AZLX,
      xtvec_AZ_AXAY,xtvec_AZ_AZLX,
      xtvec_LX_LXLY,
      xtvec_LY_LXLY,
      xtvec_LZ_LXLY;
   // results from layer 2 of additions
   wire signed[(WIDTH-1):0]
      xtvec_AX_AXAYLXLY,
      xtvec_AY_AXAYAZLX,
      xtvec_AZ_AXAYAZLX,
      xtvec_LY_LXLYLZ,
      xtvec_LZ_LXLYLZ;
   // results from layer 3 of additions
   wire signed[(WIDTH-1):0]
      xtvec_AX_AXAYLXLYLZ,
      xtvec_AY_AXAYAZLXLY,
      xtvec_AZ_AXAYAZLXLY;

   // multiplications (23 in ||)
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AX_AX(.a_in(xform_in_AX_AX),.b_in(vec_in_AX),.prod_out(xtvec_AX_AX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AX_AY(.a_in(xform_in_AY_AX),.b_in(vec_in_AY),.prod_out(xtvec_AX_AY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AX_LX(.a_in(xform_in_LX_AX),.b_in(vec_in_LX),.prod_out(xtvec_AX_LX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AX_LY(.a_in(xform_in_LY_AX),.b_in(vec_in_LY),.prod_out(xtvec_AX_LY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AX_LZ(.a_in(xform_in_LZ_AX),.b_in(vec_in_LZ),.prod_out(xtvec_AX_LZ));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AY_AX(.a_in(xform_in_AX_AY),.b_in(vec_in_AX),.prod_out(xtvec_AY_AX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AY_AY(.a_in(xform_in_AY_AY),.b_in(vec_in_AY),.prod_out(xtvec_AY_AY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AY_AZ(.a_in(xform_in_AZ_AY),.b_in(vec_in_AZ),.prod_out(xtvec_AY_AZ));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AY_LX(.a_in(xform_in_LX_AY),.b_in(vec_in_LX),.prod_out(xtvec_AY_LX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AY_LY(.a_in(xform_in_LY_AY),.b_in(vec_in_LY),.prod_out(xtvec_AY_LY));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AZ_AX(.a_in(xform_in_AX_AZ),.b_in(vec_in_AX),.prod_out(xtvec_AZ_AX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AZ_AY(.a_in(xform_in_AY_AZ),.b_in(vec_in_AY),.prod_out(xtvec_AZ_AY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AZ_AZ(.a_in(xform_in_AZ_AZ),.b_in(vec_in_AZ),.prod_out(xtvec_AZ_AZ));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AZ_LX(.a_in(xform_in_LX_AZ),.b_in(vec_in_LX),.prod_out(xtvec_AZ_LX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AZ_LY(.a_in(xform_in_LY_AZ),.b_in(vec_in_LY),.prod_out(xtvec_AZ_LY));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LX_LX(.a_in(xform_in_LX_LX),.b_in(vec_in_LX),.prod_out(xtvec_LX_LX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LX_LY(.a_in(xform_in_LY_LX),.b_in(vec_in_LY),.prod_out(xtvec_LX_LY));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LY_LX(.a_in(xform_in_LX_LY),.b_in(vec_in_LX),.prod_out(xtvec_LY_LX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LY_LY(.a_in(xform_in_LY_LY),.b_in(vec_in_LY),.prod_out(xtvec_LY_LY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LY_LZ(.a_in(xform_in_LZ_LY),.b_in(vec_in_LZ),.prod_out(xtvec_LY_LZ));

   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LZ_LX(.a_in(xform_in_LX_LZ),.b_in(vec_in_LX),.prod_out(xtvec_LZ_LX));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LZ_LY(.a_in(xform_in_LY_LZ),.b_in(vec_in_LY),.prod_out(xtvec_LZ_LY));
   mult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LZ_LZ(.a_in(xform_in_LZ_LZ),.b_in(vec_in_LZ),.prod_out(xtvec_LZ_LZ));

   // layer 1 of additions (9 in ||)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AX_AXAY(.a_in(xtvec_AX_AX),.b_in(xtvec_AX_AY),.sum_out(xtvec_AX_AXAY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AX_LXLY(.a_in(xtvec_AX_LX),.b_in(xtvec_AX_LY),.sum_out(xtvec_AX_LXLY));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AY_AXAY(.a_in(xtvec_AY_AX),.b_in(xtvec_AY_AY),.sum_out(xtvec_AY_AXAY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AY_AZLX(.a_in(xtvec_AY_AZ),.b_in(xtvec_AY_LX),.sum_out(xtvec_AY_AZLX));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AZ_AXAY(.a_in(xtvec_AZ_AX),.b_in(xtvec_AZ_AY),.sum_out(xtvec_AZ_AXAY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AZ_AZLX(.a_in(xtvec_AZ_AZ),.b_in(xtvec_AZ_LX),.sum_out(xtvec_AZ_AZLX));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_LX_LXLY(.a_in(xtvec_LX_LX),.b_in(xtvec_LX_LY),.sum_out(xtvec_LX_LXLY));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_LY_LXLY(.a_in(xtvec_LY_LX),.b_in(xtvec_LY_LY),.sum_out(xtvec_LY_LXLY));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_LZ_LXLY(.a_in(xtvec_LZ_LX),.b_in(xtvec_LZ_LY),.sum_out(xtvec_LZ_LXLY));

   // layer 2 of additions (5 in ||)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AX_AXAYLXLY(.a_in(xtvec_AX_AXAY),.b_in(xtvec_AX_LXLY),.sum_out(xtvec_AX_AXAYLXLY));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AY_AXAYAZLX(.a_in(xtvec_AY_AXAY),.b_in(xtvec_AY_AZLX),.sum_out(xtvec_AY_AXAYAZLX));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AZ_AXAYAZLX(.a_in(xtvec_AZ_AXAY),.b_in(xtvec_AZ_AZLX),.sum_out(xtvec_AZ_AXAYAZLX));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_LY_LXLYLZ(.a_in(xtvec_LY_LXLY),.b_in(xtvec_LY_LZ),.sum_out(xtvec_LY_LXLYLZ));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_LZ_LXLYLZ(.a_in(xtvec_LZ_LXLY),.b_in(xtvec_LZ_LZ),.sum_out(xtvec_LZ_LXLYLZ));

   // layer 3 of additions (3 in ||)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AX_AXAYLXLYLZ(.a_in(xtvec_AX_AXAYLXLY),.b_in(xtvec_AX_LZ),.sum_out(xtvec_AX_AXAYLXLYLZ));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AY_AXAYAZLXLY(.a_in(xtvec_AY_AXAYAZLX),.b_in(xtvec_AY_LY),.sum_out(xtvec_AY_AXAYAZLXLY));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AZ_AXAYAZLXLY(.a_in(xtvec_AZ_AXAYAZLX),.b_in(xtvec_AZ_LY),.sum_out(xtvec_AZ_AXAYAZLXLY));

   // output
   assign xtvec_out_AX = xtvec_AX_AXAYLXLYLZ;
   assign xtvec_out_AY = xtvec_AY_AXAYAZLXLY;
   assign xtvec_out_AZ = xtvec_AZ_AXAYAZLXLY;
   assign xtvec_out_LX = xtvec_LX_LXLY;
   assign xtvec_out_LY = xtvec_LY_LXLYLZ;
   assign xtvec_out_LZ = xtvec_LZ_LXLYLZ;

endmodule
