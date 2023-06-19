`timescale 1ns / 1ps

// Transformation Matrix Multiplication Transpose by a Vector and Minv
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
// xtdotminv Module
//------------------------------------------------------------------------------
module xtdotminv#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // minv boolean
   input  minv,
   // xform_in, 23 values
   input  signed[(WIDTH-1):0]
      xform_in_AX_AX, xform_in_AX_AY, xform_in_AX_AZ, minvm_in_C1_R4, minvm_in_C1_R5, minvm_in_C1_R6, minvm_in_C1_R7,
      xform_in_AY_AX, xform_in_AY_AY, xform_in_AY_AZ, minvm_in_C2_R4, minvm_in_C2_R5, minvm_in_C2_R6, minvm_in_C2_R7,
      minvm_in_C3_R1, xform_in_AZ_AY, xform_in_AZ_AZ, minvm_in_C3_R4, minvm_in_C3_R5, minvm_in_C3_R6, minvm_in_C3_R7,
      xform_in_LX_AX, xform_in_LX_AY, xform_in_LX_AZ, xform_in_LX_LX, xform_in_LX_LY, xform_in_LX_LZ, minvm_in_C4_R7,
      xform_in_LY_AX, xform_in_LY_AY, xform_in_LY_AZ, xform_in_LY_LX, xform_in_LY_LY, xform_in_LY_LZ, minvm_in_C5_R7,
      xform_in_LZ_AX, minvm_in_C6_R2, minvm_in_C6_R3, minvm_in_C6_R4, xform_in_LZ_LY, xform_in_LZ_LZ, minvm_in_C6_R7,
      minvm_in_C7_R1, minvm_in_C7_R2, minvm_in_C7_R3, minvm_in_C7_R4, minvm_in_C7_R5, minvm_in_C7_R6, minvm_in_C7_R7,
   // vec_in, 6 values
   input  signed[(WIDTH-1):0]
      vec_in_AX, vec_in_AY, vec_in_AZ, vec_in_LX, vec_in_LY, vec_in_LZ, vec_in_C7,
   // xtvec_out, 6 values
   output signed[(WIDTH-1):0]
      xtvec_out_AX, xtvec_out_AY, xtvec_out_AZ, xtvec_out_LX, xtvec_out_LY, xtvec_out_LZ, xtvec_out_C7
   );

   // internal wires and state
   // results from the multiplications
   wire signed[(WIDTH-1):0]
      minvm_R1_C3, minvm_R1_C7, xtvec_AX_AX, xtvec_AX_AY, xtvec_AX_LX, xtvec_AX_LY, xtvec_AX_LZ,
      minvm_R2_C6, minvm_R2_C7, xtvec_AY_AX, xtvec_AY_AY, xtvec_AY_AZ, xtvec_AY_LX, xtvec_AY_LY,
      minvm_R3_C6, minvm_R3_C7, xtvec_AZ_AX, xtvec_AZ_AY, xtvec_AZ_AZ, xtvec_AZ_LX, xtvec_AZ_LY,
      minvm_R4_C1, minvm_R4_C2, minvm_R4_C3, minvm_R4_C6, minvm_R4_C7, xtvec_LX_LX, xtvec_LX_LY,
      minvm_R5_C1, minvm_R5_C2, minvm_R5_C3, minvm_R5_C7, xtvec_LY_LX, xtvec_LY_LY, xtvec_LY_LZ,
      minvm_R6_C1, minvm_R6_C2, minvm_R6_C3, minvm_R6_C7, xtvec_LZ_LX, xtvec_LZ_LY, xtvec_LZ_LZ,
      minvm_R7_C1, minvm_R7_C2, minvm_R7_C3, minvm_R7_C4, minvm_R7_C5, minvm_R7_C6, minvm_R7_C7;

   // results from layer 0 of xtvec additions
   wire signed[(WIDTH-1):0]
      xtvec_AX_AXAY, xtvec_AX_LXLY, xtvec_AY_AXAY,
      xtvec_AY_AZLX, xtvec_AZ_AXAY, xtvec_AZ_AZLX,
      xtvec_LX_LXLY, xtvec_LY_LXLY, xtvec_LZ_LXLY;

   // results from layer 1 of xtvec additions
   wire signed[(WIDTH-1):0]
      xtvec_AX_LZAXAY, xtvec_AY_LYAXAY, xtvec_AZ_LYAXAY,
      xtvec_LY_LZLXLY, xtvec_LZ_LZLXLY;

   // results from layer 2 of xtvec additions
   wire signed[(WIDTH-1):0]
      xtvec_AX_LXLYLZAXAY, xtvec_AY_AZLXLYAXAY, xtvec_AZ_AZLXLYAXAY;


   // results from layer 0 of minvm additions
   wire signed[(WIDTH-1):0]
      minvm_R1_C3C7, minvm_R2_C6C7, minvm_R3_C6C7,
      minvm_R4_C1C2, minvm_R4_C3C6, minvm_R5_C1C2,
      minvm_R5_C3C7, minvm_R6_C1C2, minvm_R6_C3C7,
      minvm_R7_C1C2, minvm_R7_C3C4, minvm_R7_C5C6;

   // results from layer 1 of minvm additions
   wire signed[(WIDTH-1):0]
      minvm_R4_C7C1C2, minvm_R5_C1C2C3C7, minvm_R6_C1C2C3C7,
      minvm_R7_C7C1C2, minvm_R7_C3C4C5C6;

   // results from layer 2 of minvm additions
   wire signed[(WIDTH-1):0]
      minvm_R4_C3C6C7C1C2, minvm_R7_C7C1C2C3C4C5C6;


   // multiplications (49 in ||)
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R1_C3(.a_in(minvm_in_C3_R1),.b_in(vec_in_AZ),.prod_out(minvm_R1_C3));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R1_C7(.a_in(minvm_in_C7_R1),.b_in(vec_in_C7),.prod_out(minvm_R1_C7));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AX_AX(.a_in(xform_in_AX_AX),.b_in(vec_in_AX),.prod_out(xtvec_AX_AX));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AX_AY(.a_in(xform_in_AY_AX),.b_in(vec_in_AY),.prod_out(xtvec_AX_AY));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AX_LX(.a_in(xform_in_LX_AX),.b_in(vec_in_LX),.prod_out(xtvec_AX_LX));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AX_LY(.a_in(xform_in_LY_AX),.b_in(vec_in_LY),.prod_out(xtvec_AX_LY));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AX_LZ(.a_in(xform_in_LZ_AX),.b_in(vec_in_LZ),.prod_out(xtvec_AX_LZ));

   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R2_C6(.a_in(minvm_in_C6_R2),.b_in(vec_in_LZ),.prod_out(minvm_R2_C6));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R2_C7(.a_in(minvm_in_C7_R2),.b_in(vec_in_C7),.prod_out(minvm_R2_C7));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AY_AX(.a_in(xform_in_AX_AY),.b_in(vec_in_AX),.prod_out(xtvec_AY_AX));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AY_AY(.a_in(xform_in_AY_AY),.b_in(vec_in_AY),.prod_out(xtvec_AY_AY));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AY_AZ(.a_in(xform_in_AZ_AY),.b_in(vec_in_AZ),.prod_out(xtvec_AY_AZ));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AY_LX(.a_in(xform_in_LX_AY),.b_in(vec_in_LX),.prod_out(xtvec_AY_LX));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AY_LY(.a_in(xform_in_LY_AY),.b_in(vec_in_LY),.prod_out(xtvec_AY_LY));

   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R3_C6(.a_in(minvm_in_C6_R3),.b_in(vec_in_LZ),.prod_out(minvm_R3_C6));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R3_C7(.a_in(minvm_in_C7_R3),.b_in(vec_in_C7),.prod_out(minvm_R3_C7));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AZ_AX(.a_in(xform_in_AX_AZ),.b_in(vec_in_AX),.prod_out(xtvec_AZ_AX));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AZ_AY(.a_in(xform_in_AY_AZ),.b_in(vec_in_AY),.prod_out(xtvec_AZ_AY));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AZ_AZ(.a_in(xform_in_AZ_AZ),.b_in(vec_in_AZ),.prod_out(xtvec_AZ_AZ));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AZ_LX(.a_in(xform_in_LX_AZ),.b_in(vec_in_LX),.prod_out(xtvec_AZ_LX));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_AZ_LY(.a_in(xform_in_LY_AZ),.b_in(vec_in_LY),.prod_out(xtvec_AZ_LY));

   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R4_C1(.a_in(minvm_in_C1_R4),.b_in(vec_in_AX),.prod_out(minvm_R4_C1));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R4_C2(.a_in(minvm_in_C2_R4),.b_in(vec_in_AY),.prod_out(minvm_R4_C2));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R4_C3(.a_in(minvm_in_C3_R4),.b_in(vec_in_AZ),.prod_out(minvm_R4_C3));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R4_C6(.a_in(minvm_in_C6_R4),.b_in(vec_in_LZ),.prod_out(minvm_R4_C6));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R4_C7(.a_in(minvm_in_C7_R4),.b_in(vec_in_C7),.prod_out(minvm_R4_C7));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LX_LX(.a_in(xform_in_LX_LX),.b_in(vec_in_LX),.prod_out(xtvec_LX_LX));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LX_LY(.a_in(xform_in_LY_LX),.b_in(vec_in_LY),.prod_out(xtvec_LX_LY));

   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R5_C1(.a_in(minvm_in_C1_R5),.b_in(vec_in_AX),.prod_out(minvm_R5_C1));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R5_C2(.a_in(minvm_in_C2_R5),.b_in(vec_in_AY),.prod_out(minvm_R5_C2));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R5_C3(.a_in(minvm_in_C3_R5),.b_in(vec_in_AZ),.prod_out(minvm_R5_C3));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R5_C7(.a_in(minvm_in_C7_R5),.b_in(vec_in_C7),.prod_out(minvm_R5_C7));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LY_LX(.a_in(xform_in_LX_LY),.b_in(vec_in_LX),.prod_out(xtvec_LY_LX));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LY_LY(.a_in(xform_in_LY_LY),.b_in(vec_in_LY),.prod_out(xtvec_LY_LY));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LY_LZ(.a_in(xform_in_LZ_LY),.b_in(vec_in_LZ),.prod_out(xtvec_LY_LZ));

   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R6_C1(.a_in(minvm_in_C1_R6),.b_in(vec_in_AX),.prod_out(minvm_R6_C1));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R6_C2(.a_in(minvm_in_C2_R6),.b_in(vec_in_AY),.prod_out(minvm_R6_C2));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R6_C3(.a_in(minvm_in_C3_R6),.b_in(vec_in_AZ),.prod_out(minvm_R6_C3));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R6_C7(.a_in(minvm_in_C7_R6),.b_in(vec_in_C7),.prod_out(minvm_R6_C7));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LZ_LX(.a_in(xform_in_LX_LZ),.b_in(vec_in_LX),.prod_out(xtvec_LZ_LX));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LZ_LY(.a_in(xform_in_LY_LZ),.b_in(vec_in_LY),.prod_out(xtvec_LZ_LY));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_xtvec_LZ_LZ(.a_in(xform_in_LZ_LZ),.b_in(vec_in_LZ),.prod_out(xtvec_LZ_LZ));

   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R7_C1(.a_in(minvm_in_C1_R7),.b_in(vec_in_AX),.prod_out(minvm_R7_C1));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R7_C2(.a_in(minvm_in_C2_R7),.b_in(vec_in_AY),.prod_out(minvm_R7_C2));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R7_C3(.a_in(minvm_in_C3_R7),.b_in(vec_in_AZ),.prod_out(minvm_R7_C3));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R7_C4(.a_in(minvm_in_C4_R7),.b_in(vec_in_LX),.prod_out(minvm_R7_C4));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R7_C5(.a_in(minvm_in_C5_R7),.b_in(vec_in_LY),.prod_out(minvm_R7_C5));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R7_C6(.a_in(minvm_in_C6_R7),.b_in(vec_in_LZ),.prod_out(minvm_R7_C6));
   mult#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      mult_minvm_R7_C7(.a_in(minvm_in_C7_R7),.b_in(vec_in_C7),.prod_out(minvm_R7_C7));


   // layer 0 of xtvec additions
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AX_AXAY(.a_in(xtvec_AX_AX),.b_in(xtvec_AX_AY),.sum_out(xtvec_AX_AXAY));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AX_LXLY(.a_in(xtvec_AX_LX),.b_in(xtvec_AX_LY),.sum_out(xtvec_AX_LXLY));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AY_AXAY(.a_in(xtvec_AY_AX),.b_in(xtvec_AY_AY),.sum_out(xtvec_AY_AXAY));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AY_AZLX(.a_in(xtvec_AY_AZ),.b_in(xtvec_AY_LX),.sum_out(xtvec_AY_AZLX));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AZ_AXAY(.a_in(xtvec_AZ_AX),.b_in(xtvec_AZ_AY),.sum_out(xtvec_AZ_AXAY));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AZ_AZLX(.a_in(xtvec_AZ_AZ),.b_in(xtvec_AZ_LX),.sum_out(xtvec_AZ_AZLX));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_LX_LXLY(.a_in(xtvec_LX_LX),.b_in(xtvec_LX_LY),.sum_out(xtvec_LX_LXLY));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_LY_LXLY(.a_in(xtvec_LY_LX),.b_in(xtvec_LY_LY),.sum_out(xtvec_LY_LXLY));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_LZ_LXLY(.a_in(xtvec_LZ_LX),.b_in(xtvec_LZ_LY),.sum_out(xtvec_LZ_LXLY));


   // layer 1 of xtvec additions
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AX_LZAXAY(.a_in(xtvec_AX_LZ),.b_in(xtvec_AX_AXAY),.sum_out(xtvec_AX_LZAXAY));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AY_LYAXAY(.a_in(xtvec_AY_LY),.b_in(xtvec_AY_AXAY),.sum_out(xtvec_AY_LYAXAY));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AZ_LYAXAY(.a_in(xtvec_AZ_LY),.b_in(xtvec_AZ_AXAY),.sum_out(xtvec_AZ_LYAXAY));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_LY_LZLXLY(.a_in(xtvec_LY_LZ),.b_in(xtvec_LY_LXLY),.sum_out(xtvec_LY_LZLXLY));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_LZ_LZLXLY(.a_in(xtvec_LZ_LZ),.b_in(xtvec_LZ_LXLY),.sum_out(xtvec_LZ_LZLXLY));


   // layer 2 of xtvec additions
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AX_LXLYLZAXAY(.a_in(xtvec_AX_LXLY),.b_in(xtvec_AX_LZAXAY),.sum_out(xtvec_AX_LXLYLZAXAY));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AY_AZLXLYAXAY(.a_in(xtvec_AY_AZLX),.b_in(xtvec_AY_LYAXAY),.sum_out(xtvec_AY_AZLXLYAXAY));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AZ_AZLXLYAXAY(.a_in(xtvec_AZ_AZLX),.b_in(xtvec_AZ_LYAXAY),.sum_out(xtvec_AZ_AZLXLYAXAY));



   // layer 0 of minvm additions
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R1_C3C7(.a_in(minvm_R1_C3),.b_in(minvm_R1_C7),.sum_out(minvm_R1_C3C7));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R2_C6C7(.a_in(minvm_R2_C6),.b_in(minvm_R2_C7),.sum_out(minvm_R2_C6C7));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R3_C6C7(.a_in(minvm_R3_C6),.b_in(minvm_R3_C7),.sum_out(minvm_R3_C6C7));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R4_C1C2(.a_in(minvm_R4_C1),.b_in(minvm_R4_C2),.sum_out(minvm_R4_C1C2));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R4_C3C6(.a_in(minvm_R4_C3),.b_in(minvm_R4_C6),.sum_out(minvm_R4_C3C6));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R5_C1C2(.a_in(minvm_R5_C1),.b_in(minvm_R5_C2),.sum_out(minvm_R5_C1C2));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R5_C3C7(.a_in(minvm_R5_C3),.b_in(minvm_R5_C7),.sum_out(minvm_R5_C3C7));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R6_C1C2(.a_in(minvm_R6_C1),.b_in(minvm_R6_C2),.sum_out(minvm_R6_C1C2));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R6_C3C7(.a_in(minvm_R6_C3),.b_in(minvm_R6_C7),.sum_out(minvm_R6_C3C7));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R7_C1C2(.a_in(minvm_R7_C1),.b_in(minvm_R7_C2),.sum_out(minvm_R7_C1C2));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R7_C3C4(.a_in(minvm_R7_C3),.b_in(minvm_R7_C4),.sum_out(minvm_R7_C3C4));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R7_C5C6(.a_in(minvm_R7_C5),.b_in(minvm_R7_C6),.sum_out(minvm_R7_C5C6));


   // layer 1 of minvm additions
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R4_C7C1C2(.a_in(minvm_R4_C7),.b_in(minvm_R4_C1C2),.sum_out(minvm_R4_C7C1C2));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R5_C1C2C3C7(.a_in(minvm_R5_C1C2),.b_in(minvm_R5_C3C7),.sum_out(minvm_R5_C1C2C3C7));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R6_C1C2C3C7(.a_in(minvm_R6_C1C2),.b_in(minvm_R6_C3C7),.sum_out(minvm_R6_C1C2C3C7));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R7_C7C1C2(.a_in(minvm_R7_C7),.b_in(minvm_R7_C1C2),.sum_out(minvm_R7_C7C1C2));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R7_C3C4C5C6(.a_in(minvm_R7_C3C4),.b_in(minvm_R7_C5C6),.sum_out(minvm_R7_C3C4C5C6));


   // layer 2 of minvm additions
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R4_C3C6C7C1C2(.a_in(minvm_R4_C3C6),.b_in(minvm_R4_C7C1C2),.sum_out(minvm_R4_C3C6C7C1C2));

   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_minvm_R7_C7C1C2C3C4C5C6(.a_in(minvm_R7_C7C1C2),.b_in(minvm_R7_C3C4C5C6),.sum_out(minvm_R7_C7C1C2C3C4C5C6));



   wire signed[(WIDTH-1):0]
   xtvec_AX_LXLYLZAXAYC3C7, xtvec_AY_AZLXLYAXAYC6C7, xtvec_AZ_AZLXLYAXAYC6C7, xtvec_LX_LXLYC3C6C7C1C2, xtvec_LY_LZLXLYC1C2C3C7, xtvec_LZ_LZLXLYC1C2C3C7;

   // last layer additions merging trees
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AX_LXLYLZAXAYC3C7(.a_in(xtvec_AX_LXLYLZAXAY),.b_in(minvm_R1_C3C7),.sum_out(xtvec_AX_LXLYLZAXAYC3C7));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AY_AZLXLYAXAYC6C7(.a_in(xtvec_AY_AZLXLYAXAY),.b_in(minvm_R2_C6C7),.sum_out(xtvec_AY_AZLXLYAXAYC6C7));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_AZ_AZLXLYAXAYC6C7(.a_in(xtvec_AZ_AZLXLYAXAY),.b_in(minvm_R3_C6C7),.sum_out(xtvec_AZ_AZLXLYAXAYC6C7));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_LX_LXLYC3C6C7C1C2(.a_in(xtvec_LX_LXLY),.b_in(minvm_R4_C3C6C7C1C2),.sum_out(xtvec_LX_LXLYC3C6C7C1C2));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_LY_LZLXLYC1C2C3C7(.a_in(xtvec_LY_LZLXLY),.b_in(minvm_R5_C1C2C3C7),.sum_out(xtvec_LY_LZLXLYC1C2C3C7));
   add#(.WIDTH(WIDTH), .DECIMAL_BITS(DECIMAL_BITS))
      add_xtvec_LZ_LZLXLYC1C2C3C7(.a_in(xtvec_LZ_LZLXLY),.b_in(minvm_R6_C1C2C3C7),.sum_out(xtvec_LZ_LZLXLYC1C2C3C7));

   // mux between last output of OG xtvec tree and merged tree
   assign xtvec_out_AX = (minv) ? xtvec_AX_LXLYLZAXAYC3C7 : xtvec_AX_LXLYLZAXAY;
   assign xtvec_out_AY = (minv) ? xtvec_AY_AZLXLYAXAYC6C7 : xtvec_AY_AZLXLYAXAY;
   assign xtvec_out_AZ = (minv) ? xtvec_AZ_AZLXLYAXAYC6C7 : xtvec_AZ_AZLXLYAXAY;
   assign xtvec_out_LX = (minv) ? xtvec_LX_LXLYC3C6C7C1C2 : xtvec_LX_LXLY;
   assign xtvec_out_LY = (minv) ? xtvec_LY_LZLXLYC1C2C3C7 : xtvec_LY_LZLXLY;
   assign xtvec_out_LZ = (minv) ? xtvec_LZ_LZLXLYC1C2C3C7 : xtvec_LZ_LZLXLY;
   assign xtvec_out_C7 = (minv) ? minvm_R7_C7C1C2C3C4C5C6 : 32'd0;

endmodule
