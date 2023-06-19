`timescale 1ns / 1ps

// Inertia Matrix Multiplication by a Vector
//
// (24 mult, 18 add)
//       0  1  2  3  4  5 vec
//      AX AY AZ LX LY LZ
// 0 AX  0  1  2     3  4
// 1 AY  5  6  7  8     9
// 2 AZ 10 11 12 13 14
// 3 LX    15 16 17
// 4 LY 18    19    20
// 5 LZ 21 22          23
// ivec                  imat

//------------------------------------------------------------------------------
// idot Module
//------------------------------------------------------------------------------
module idot#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16,
   // IMAT_IN, 24 values
   parameter signed
      IMAT_IN_AX_AX = 0,IMAT_IN_AX_AY = 0,IMAT_IN_AX_AZ = 0,                  IMAT_IN_AX_LY = 0,IMAT_IN_AX_LZ = 0,
      IMAT_IN_AY_AX = 0,IMAT_IN_AY_AY = 0,IMAT_IN_AY_AZ = 0,IMAT_IN_AY_LX = 0,                  IMAT_IN_AY_LZ = 0,
      IMAT_IN_AZ_AX = 0,IMAT_IN_AZ_AY = 0,IMAT_IN_AZ_AZ = 0,IMAT_IN_AZ_LX = 0,IMAT_IN_AZ_LY = 0,
                        IMAT_IN_LX_AY = 0,IMAT_IN_LX_AZ = 0,IMAT_IN_LX_LX = 0,
      IMAT_IN_LY_AX = 0,                  IMAT_IN_LY_AZ = 0,                  IMAT_IN_LY_LY = 0,
      IMAT_IN_LZ_AX = 0,IMAT_IN_LZ_AY = 0,                                                      IMAT_IN_LZ_LZ = 0)(
   // vec_in, 6 values
   input  signed[(WIDTH-1):0]
      vec_in_AX,vec_in_AY,vec_in_AZ,vec_in_LX,vec_in_LY,vec_in_LZ,
   // ivec_out, 6 values
   output signed[(WIDTH-1):0]
      ivec_out_AX,ivec_out_AY,ivec_out_AZ,ivec_out_LX,ivec_out_LY,ivec_out_LZ
   );

   // internal wires and state
   // results from the multiplications
   wire signed[(WIDTH-1):0]
      ivec_AX_AX,ivec_AX_AY,ivec_AX_AZ,           ivec_AX_LY,ivec_AX_LZ,
      ivec_AY_AX,ivec_AY_AY,ivec_AY_AZ,ivec_AY_LX,           ivec_AY_LZ,
      ivec_AZ_AX,ivec_AZ_AY,ivec_AZ_AZ,ivec_AZ_LX,ivec_AZ_LY,
                 ivec_LX_AY,ivec_LX_AZ,ivec_LX_LX,
      ivec_LY_AX,           ivec_LY_AZ,           ivec_LY_LY,
      ivec_LZ_AX,ivec_LZ_AY,                                 ivec_LZ_LZ;
   // results from layer 1 of additions
   wire signed[(WIDTH-1):0]
      ivec_AX_AXAY,ivec_AX_AZLY,
      ivec_AY_AXAY,ivec_AY_AZLX,
      ivec_AZ_AXAY,ivec_AZ_AZLX,
      ivec_LX_AYAZ,
      ivec_LY_AXAZ,
      ivec_LZ_AXAY;
   // results from layer 2 of additions
   wire signed[(WIDTH-1):0]
      ivec_AX_AXAYAZLY,
      ivec_AY_AXAYAZLX,
      ivec_AZ_AXAYAZLX,
      ivec_LX_AYAZLX,
      ivec_LY_AXAZLY,
      ivec_LZ_AXAYLZ;
   // results from layer 3 of additions
   wire signed[(WIDTH-1):0]
      ivec_AX_AXAYAZLYLZ,
      ivec_AY_AXAYAZLXLZ,
      ivec_AZ_AXAYAZLXLY;

   // multiplications (24 in ||)
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AX_AX))
      cmult_ivec_AX_AX(.b_in(vec_in_AX),.prod_out(ivec_AX_AX));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AX_AY))
      cmult_ivec_AX_AY(.b_in(vec_in_AY),.prod_out(ivec_AX_AY));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AX_AZ))
      cmult_ivec_AX_AZ(.b_in(vec_in_AZ),.prod_out(ivec_AX_AZ));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AX_LY))
      cmult_ivec_AX_LY(.b_in(vec_in_LY),.prod_out(ivec_AX_LY));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AX_LZ))
      cmult_ivec_AX_LZ(.b_in(vec_in_LZ),.prod_out(ivec_AX_LZ));

   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AY_AX))
      cmult_ivec_AY_AX(.b_in(vec_in_AX),.prod_out(ivec_AY_AX));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AY_AY))
      cmult_ivec_AY_AY(.b_in(vec_in_AY),.prod_out(ivec_AY_AY));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AY_AZ))
      cmult_ivec_AY_AZ(.b_in(vec_in_AZ),.prod_out(ivec_AY_AZ));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AY_LX))
      cmult_ivec_AY_LX(.b_in(vec_in_LX),.prod_out(ivec_AY_LX));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AY_LZ))
      cmult_ivec_AY_LZ(.b_in(vec_in_LZ),.prod_out(ivec_AY_LZ));

   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AZ_AX))
      cmult_ivec_AZ_AX(.b_in(vec_in_AX),.prod_out(ivec_AZ_AX));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AZ_AY))
      cmult_ivec_AZ_AY(.b_in(vec_in_AY),.prod_out(ivec_AZ_AY));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AZ_AZ))
      cmult_ivec_AZ_AZ(.b_in(vec_in_AZ),.prod_out(ivec_AZ_AZ));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AZ_LX))
      cmult_ivec_AZ_LX(.b_in(vec_in_LX),.prod_out(ivec_AZ_LX));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_AZ_LY))
      cmult_ivec_AZ_LY(.b_in(vec_in_LY),.prod_out(ivec_AZ_LY));

   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_LX_AY))
      cmult_ivec_LX_AY(.b_in(vec_in_AY),.prod_out(ivec_LX_AY));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_LX_AZ))
      cmult_ivec_LX_AZ(.b_in(vec_in_AZ),.prod_out(ivec_LX_AZ));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_LX_LX))
      cmult_ivec_LX_LX(.b_in(vec_in_LX),.prod_out(ivec_LX_LX));

   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_LY_AX))
      cmult_ivec_LY_AX(.b_in(vec_in_AX),.prod_out(ivec_LY_AX));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_LY_AZ))
      cmult_ivec_LY_AZ(.b_in(vec_in_AZ),.prod_out(ivec_LY_AZ));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_LY_LY))
      cmult_ivec_LY_LY(.b_in(vec_in_LY),.prod_out(ivec_LY_LY));

   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_LZ_AX))
      cmult_ivec_LZ_AX(.b_in(vec_in_AX),.prod_out(ivec_LZ_AX));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_LZ_AY))
      cmult_ivec_LZ_AY(.b_in(vec_in_AY),.prod_out(ivec_LZ_AY));
   cmult#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),.C_IN(IMAT_IN_LZ_LZ))
      cmult_ivec_LZ_LZ(.b_in(vec_in_LZ),.prod_out(ivec_LZ_LZ));

   // layer 1 of additions (9 in ||)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_AX_AXAY(.a_in(ivec_AX_AX),.b_in(ivec_AX_AY),.sum_out(ivec_AX_AXAY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_AX_AZLY(.a_in(ivec_AX_AZ),.b_in(ivec_AX_LY),.sum_out(ivec_AX_AZLY));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_AY_AXAY(.a_in(ivec_AY_AX),.b_in(ivec_AY_AY),.sum_out(ivec_AY_AXAY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_AY_AZLX(.a_in(ivec_AY_AZ),.b_in(ivec_AY_LX),.sum_out(ivec_AY_AZLX));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_AZ_AXAY(.a_in(ivec_AZ_AX),.b_in(ivec_AZ_AY),.sum_out(ivec_AZ_AXAY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_AZ_AZLX(.a_in(ivec_AZ_AZ),.b_in(ivec_AZ_LX),.sum_out(ivec_AZ_AZLX));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_LX_AYAZ(.a_in(ivec_LX_AY),.b_in(ivec_LX_AZ),.sum_out(ivec_LX_AYAZ));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_LY_AXAZ(.a_in(ivec_LY_AX),.b_in(ivec_LY_AZ),.sum_out(ivec_LY_AXAZ));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_LZ_AXAY(.a_in(ivec_LZ_AX),.b_in(ivec_LZ_AY),.sum_out(ivec_LZ_AXAY));

   // layer 2 of additions (6 in ||)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_AX_AXAYAZLY(.a_in(ivec_AX_AXAY),.b_in(ivec_AX_AZLY),.sum_out(ivec_AX_AXAYAZLY));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_AY_AXAYAZLX(.a_in(ivec_AY_AXAY),.b_in(ivec_AY_AZLX),.sum_out(ivec_AY_AXAYAZLX));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_AZ_AXAYAZLX(.a_in(ivec_AZ_AXAY),.b_in(ivec_AZ_AZLX),.sum_out(ivec_AZ_AXAYAZLX));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_LX_AYAZLX(.a_in(ivec_LX_AYAZ),.b_in(ivec_LX_LX),.sum_out(ivec_LX_AYAZLX));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_LY_AXAZLY(.a_in(ivec_LY_AXAZ),.b_in(ivec_LY_LY),.sum_out(ivec_LY_AXAZLY));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_LZ_AXAYLZ(.a_in(ivec_LZ_AXAY),.b_in(ivec_LZ_LZ),.sum_out(ivec_LZ_AXAYLZ));

   // layer 3 of additions (3 in ||)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_AX_AXAYAZLYLZ(.a_in(ivec_AX_AXAYAZLY),.b_in(ivec_AX_LZ),.sum_out(ivec_AX_AXAYAZLYLZ));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_AY_AXAYAZLXLZ(.a_in(ivec_AY_AXAYAZLX),.b_in(ivec_AY_LZ),.sum_out(ivec_AY_AXAYAZLXLZ));

   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_ivec_AZ_AXAYAZLXLY(.a_in(ivec_AZ_AXAYAZLX),.b_in(ivec_AZ_LY),.sum_out(ivec_AZ_AXAYAZLXLY));

   // output
   assign ivec_out_AX = ivec_AX_AXAYAZLYLZ;
   assign ivec_out_AY = ivec_AY_AXAYAZLXLZ;
   assign ivec_out_AZ = ivec_AZ_AXAYAZLXLY;
   assign ivec_out_LX = ivec_LX_AYAZLX;
   assign ivec_out_LY = ivec_LY_AXAZLY;
   assign ivec_out_LZ = ivec_LZ_AXAYLZ;

endmodule
