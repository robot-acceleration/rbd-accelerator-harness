`timescale 1ns / 1ps

// Inertia Matrix Multiplication by a Vector

//------------------------------------------------------------------------------
// idots7 Module
//------------------------------------------------------------------------------
module idots7#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // link_in
   input  [2:0]
      link_in,
   // vec_in, 6 values
   input  signed[(WIDTH-1):0]
      vec_in_AX,vec_in_AY,vec_in_AZ,vec_in_LX,vec_in_LY,vec_in_LZ,
   // ivec_out, 6 values
   output signed[(WIDTH-1):0]
      ivec_out_AX,ivec_out_AY,ivec_out_AZ,ivec_out_LX,ivec_out_LY,ivec_out_LZ
   );

   // parameters
   // Link 1
   parameter signed
      IMAT_L1_IN_AX_AX = 32'd10564,IMAT_L1_IN_AX_AY = 32'd0,IMAT_L1_IN_AX_AZ = 32'd0,                                  IMAT_L1_IN_AX_LY = -32'd31457,IMAT_L1_IN_AX_LZ = -32'd7864,
      IMAT_L1_IN_AY_AX = 32'd0,IMAT_L1_IN_AY_AY = 32'd9673,IMAT_L1_IN_AY_AZ = 32'd944,IMAT_L1_IN_AY_LX = 32'd31457,                                  IMAT_L1_IN_AY_LZ = 32'd0,
      IMAT_L1_IN_AZ_AX = 32'd0,IMAT_L1_IN_AZ_AY = 32'd944,IMAT_L1_IN_AZ_AZ = 32'd1547,IMAT_L1_IN_AZ_LX = 32'd7864,IMAT_L1_IN_AZ_LY = 32'd0,
                                        IMAT_L1_IN_LX_AY = 32'd31457,IMAT_L1_IN_LX_AZ = 32'd7864,IMAT_L1_IN_LX_LX = 32'd262144,
      IMAT_L1_IN_LY_AX = -32'd31457,                                  IMAT_L1_IN_LY_AZ = 32'd0,                                  IMAT_L1_IN_LY_LY = 32'd262144,
      IMAT_L1_IN_LZ_AX = -32'd7864,IMAT_L1_IN_LZ_AY = 32'd0,                                                                                                      IMAT_L1_IN_LZ_LZ = 32'd262144;
   // -----------------------------------------------------------------------
   // Link 2
   parameter signed
      IMAT_L2_IN_AX_AX = 32'd4652,IMAT_L2_IN_AX_AY = -32'd5,IMAT_L2_IN_AX_AZ = -32'd3,                                  IMAT_L2_IN_AX_LY = -32'd11010,IMAT_L2_IN_AX_LZ = 32'd15466,
      IMAT_L2_IN_AY_AX = -32'd5,IMAT_L2_IN_AY_AY = 32'd1642,IMAT_L2_IN_AY_AZ = -32'd650,IMAT_L2_IN_AY_LX = 32'd11010,                                  IMAT_L2_IN_AY_LZ = -32'd79,
      IMAT_L2_IN_AZ_AX = -32'd3,IMAT_L2_IN_AZ_AY = -32'd650,IMAT_L2_IN_AZ_AZ = 32'd3796,IMAT_L2_IN_AZ_LX = -32'd15466,IMAT_L2_IN_AZ_LY = 32'd79,
                                        IMAT_L2_IN_LX_AY = 32'd11010,IMAT_L2_IN_LX_AZ = -32'd15466,IMAT_L2_IN_LX_LX = 32'd262144,
      IMAT_L2_IN_LY_AX = -32'd11010,                                  IMAT_L2_IN_LY_AZ = 32'd79,                                  IMAT_L2_IN_LY_LY = 32'd262144,
      IMAT_L2_IN_LZ_AX = 32'd15466,IMAT_L2_IN_LZ_AY = -32'd79,                                                                                                      IMAT_L2_IN_LZ_LZ = 32'd262144;
   // -----------------------------------------------------------------------
   // Link 3
   parameter signed
      IMAT_L3_IN_AX_AX = 32'd8743,IMAT_L3_IN_AX_AY = 32'd0,IMAT_L3_IN_AX_AZ = 32'd0,                                  IMAT_L3_IN_AX_LY = -32'd25559,IMAT_L3_IN_AX_LZ = 32'd5898,
      IMAT_L3_IN_AY_AX = 32'd0,IMAT_L3_IN_AY_AY = 32'd8238,IMAT_L3_IN_AY_AZ = -32'd767,IMAT_L3_IN_AY_LX = 32'd25559,                                  IMAT_L3_IN_AY_LZ = 32'd0,
      IMAT_L3_IN_AZ_AX = 32'd0,IMAT_L3_IN_AZ_AY = -32'd767,IMAT_L3_IN_AZ_AZ = 32'd832,IMAT_L3_IN_AZ_LX = -32'd5898,IMAT_L3_IN_AZ_LY = 32'd0,
                                        IMAT_L3_IN_LX_AY = 32'd25559,IMAT_L3_IN_LX_AZ = -32'd5898,IMAT_L3_IN_LX_LX = 32'd196608,
      IMAT_L3_IN_LY_AX = -32'd25559,                                  IMAT_L3_IN_LY_AZ = 32'd0,                                  IMAT_L3_IN_LY_LY = 32'd196608,
      IMAT_L3_IN_LZ_AX = 32'd5898,IMAT_L3_IN_LZ_AY = 32'd0,                                                                                                      IMAT_L3_IN_LZ_LZ = 32'd196608;
   // -----------------------------------------------------------------------
   // Link 4
   parameter signed
      IMAT_L4_IN_AX_AX = 32'd2965,IMAT_L4_IN_AX_AY = 32'd0,IMAT_L4_IN_AX_AZ = 32'd0,                                  IMAT_L4_IN_AX_LY = -32'd6016,IMAT_L4_IN_AX_LZ = 32'd11855,
      IMAT_L4_IN_AY_AX = 32'd0,IMAT_L4_IN_AY_AY = 32'd860,IMAT_L4_IN_AY_AZ = -32'd403,IMAT_L4_IN_AY_LX = 32'd6016,                                  IMAT_L4_IN_AY_LZ = 32'd0,
      IMAT_L4_IN_AZ_AX = 32'd0,IMAT_L4_IN_AZ_AY = -32'd403,IMAT_L4_IN_AZ_AZ = 32'd2695,IMAT_L4_IN_AZ_LX = -32'd11855,IMAT_L4_IN_AZ_LY = 32'd0,
                                        IMAT_L4_IN_LX_AY = 32'd6016,IMAT_L4_IN_LX_AZ = -32'd11855,IMAT_L4_IN_LX_LX = 32'd176947,
      IMAT_L4_IN_LY_AX = -32'd6016,                                  IMAT_L4_IN_LY_AZ = 32'd0,                                  IMAT_L4_IN_LY_LY = 32'd176947,
      IMAT_L4_IN_LZ_AX = 32'd11855,IMAT_L4_IN_LZ_AY = 32'd0,                                                                                                      IMAT_L4_IN_LZ_LZ = 32'd176947;
   // -----------------------------------------------------------------------
   // Link 5
   parameter signed
      IMAT_L5_IN_AX_AX = 32'd2003,IMAT_L5_IN_AX_AY = 32'd0,IMAT_L5_IN_AX_AZ = -32'd1,                                  IMAT_L5_IN_AX_LY = -32'd8467,IMAT_L5_IN_AX_LZ = 32'd2340,
      IMAT_L5_IN_AY_AX = 32'd0,IMAT_L5_IN_AY_AY = 32'd1823,IMAT_L5_IN_AY_AZ = -32'd178,IMAT_L5_IN_AY_LX = 32'd8467,                                  IMAT_L5_IN_AY_LZ = -32'd11,
      IMAT_L5_IN_AZ_AX = -32'd1,IMAT_L5_IN_AZ_AY = -32'd178,IMAT_L5_IN_AZ_AZ = 32'd377,IMAT_L5_IN_AZ_LX = -32'd2340,IMAT_L5_IN_AZ_LY = 32'd11,
                                        IMAT_L5_IN_LX_AY = 32'd8467,IMAT_L5_IN_LX_AZ = -32'd2340,IMAT_L5_IN_LX_LX = 32'd111411,
      IMAT_L5_IN_LY_AX = -32'd8467,                                  IMAT_L5_IN_LY_AZ = 32'd11,                                  IMAT_L5_IN_LY_LY = 32'd111411,
      IMAT_L5_IN_LZ_AX = 32'd2340,IMAT_L5_IN_LZ_AY = -32'd11,                                                                                                      IMAT_L5_IN_LZ_LZ = 32'd111411;
   // -----------------------------------------------------------------------
   // Link 6
   parameter signed
      IMAT_L6_IN_AX_AX = 32'd328,IMAT_L6_IN_AX_AY = 32'd0,IMAT_L6_IN_AX_AZ = 32'd0,                                  IMAT_L6_IN_AX_LY = -32'd47,IMAT_L6_IN_AX_LZ = 32'd71,
      IMAT_L6_IN_AY_AX = 32'd0,IMAT_L6_IN_AY_AY = 32'd236,IMAT_L6_IN_AY_AZ = 32'd0,IMAT_L6_IN_AY_LX = 32'd47,                                  IMAT_L6_IN_AY_LZ = 32'd0,
      IMAT_L6_IN_AZ_AX = 32'd0,IMAT_L6_IN_AZ_AY = 32'd0,IMAT_L6_IN_AZ_AZ = 32'd308,IMAT_L6_IN_AZ_LX = -32'd71,IMAT_L6_IN_AZ_LY = 32'd0,
                                        IMAT_L6_IN_LX_AY = 32'd47,IMAT_L6_IN_LX_AZ = -32'd71,IMAT_L6_IN_LX_LX = 32'd117965,
      IMAT_L6_IN_LY_AX = -32'd47,                                  IMAT_L6_IN_LY_AZ = 32'd0,                                  IMAT_L6_IN_LY_LY = 32'd117965,
      IMAT_L6_IN_LZ_AX = 32'd71,IMAT_L6_IN_LZ_AY = 32'd0,                                                                                                      IMAT_L6_IN_LZ_LZ = 32'd117965;
   // -----------------------------------------------------------------------
   // Link 7
   parameter signed
      IMAT_L7_IN_AX_AX = 32'd73,IMAT_L7_IN_AX_AY = 32'd0,IMAT_L7_IN_AX_AZ = 32'd0,                                  IMAT_L7_IN_AX_LY = -32'd393,IMAT_L7_IN_AX_LZ = 32'd0,
      IMAT_L7_IN_AY_AX = 32'd0,IMAT_L7_IN_AY_AY = 32'd73,IMAT_L7_IN_AY_AZ = 32'd0,IMAT_L7_IN_AY_LX = 32'd393,                                  IMAT_L7_IN_AY_LZ = 32'd0,
      IMAT_L7_IN_AZ_AX = 32'd0,IMAT_L7_IN_AZ_AY = 32'd0,IMAT_L7_IN_AZ_AZ = 32'd66,IMAT_L7_IN_AZ_LX = 32'd0,IMAT_L7_IN_AZ_LY = 32'd0,
                                        IMAT_L7_IN_LX_AY = 32'd393,IMAT_L7_IN_LX_AZ = 32'd0,IMAT_L7_IN_LX_LX = 32'd19661,
      IMAT_L7_IN_LY_AX = -32'd393,                                  IMAT_L7_IN_LY_AZ = 32'd0,                                  IMAT_L7_IN_LY_LY = 32'd19661,
      IMAT_L7_IN_LZ_AX = 32'd0,IMAT_L7_IN_LZ_AY = 32'd0,                                                                                                      IMAT_L7_IN_LZ_LZ = 32'd19661;

   // internal wires and state
   // results, Link 1
   wire signed[(WIDTH-1):0]
      ivec_l1_out_AX,ivec_l1_out_AY,ivec_l1_out_AZ,ivec_l1_out_LX,ivec_l1_out_LY,ivec_l1_out_LZ;
   // results, Link 2
   wire signed[(WIDTH-1):0]
      ivec_l2_out_AX,ivec_l2_out_AY,ivec_l2_out_AZ,ivec_l2_out_LX,ivec_l2_out_LY,ivec_l2_out_LZ;
   // results, Link 3
   wire signed[(WIDTH-1):0]
      ivec_l3_out_AX,ivec_l3_out_AY,ivec_l3_out_AZ,ivec_l3_out_LX,ivec_l3_out_LY,ivec_l3_out_LZ;
   // results, Link 4
   wire signed[(WIDTH-1):0]
      ivec_l4_out_AX,ivec_l4_out_AY,ivec_l4_out_AZ,ivec_l4_out_LX,ivec_l4_out_LY,ivec_l4_out_LZ;
   // results, Link 5
   wire signed[(WIDTH-1):0]
      ivec_l5_out_AX,ivec_l5_out_AY,ivec_l5_out_AZ,ivec_l5_out_LX,ivec_l5_out_LY,ivec_l5_out_LZ;
   // results, Link 6
   wire signed[(WIDTH-1):0]
      ivec_l6_out_AX,ivec_l6_out_AY,ivec_l6_out_AZ,ivec_l6_out_LX,ivec_l6_out_LY,ivec_l6_out_LZ;
   // results, Link 7
   wire signed[(WIDTH-1):0]
      ivec_l7_out_AX,ivec_l7_out_AY,ivec_l7_out_AZ,ivec_l7_out_LX,ivec_l7_out_LY,ivec_l7_out_LZ;

   // idots
   // idot, Link 1
   idot#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),
      // IMAT_IN, 24 values
      .IMAT_IN_AX_AX(IMAT_L1_IN_AX_AX),.IMAT_IN_AX_AY(IMAT_L1_IN_AX_AY),.IMAT_IN_AX_AZ(IMAT_L1_IN_AX_AZ),                              .IMAT_IN_AX_LY(IMAT_L1_IN_AX_LY),.IMAT_IN_AX_LZ(IMAT_L1_IN_AX_LZ),
      .IMAT_IN_AY_AX(IMAT_L1_IN_AY_AX),.IMAT_IN_AY_AY(IMAT_L1_IN_AY_AY),.IMAT_IN_AY_AZ(IMAT_L1_IN_AY_AZ),.IMAT_IN_AY_LX(IMAT_L1_IN_AY_LX),                              .IMAT_IN_AY_LZ(IMAT_L1_IN_AY_LZ),
      .IMAT_IN_AZ_AX(IMAT_L1_IN_AZ_AX),.IMAT_IN_AZ_AY(IMAT_L1_IN_AZ_AY),.IMAT_IN_AZ_AZ(IMAT_L1_IN_AZ_AZ),.IMAT_IN_AZ_LX(IMAT_L1_IN_AZ_LX),.IMAT_IN_AZ_LY(IMAT_L1_IN_AZ_LY),
                                    .IMAT_IN_LX_AY(IMAT_L1_IN_LX_AY),.IMAT_IN_LX_AZ(IMAT_L1_IN_LX_AZ),.IMAT_IN_LX_LX(IMAT_L1_IN_LX_LX),
      .IMAT_IN_LY_AX(IMAT_L1_IN_LY_AX),                              .IMAT_IN_LY_AZ(IMAT_L1_IN_LY_AZ),                              .IMAT_IN_LY_LY(IMAT_L1_IN_LY_LY),
      .IMAT_IN_LZ_AX(IMAT_L1_IN_LZ_AX),.IMAT_IN_LZ_AY(IMAT_L1_IN_LZ_AY),                                                                                          .IMAT_IN_LZ_LZ(IMAT_L1_IN_LZ_LZ))
      idot1(
      // vec_in, 6 values
      .vec_in_AX(vec_in_AX),.vec_in_AY(vec_in_AY),.vec_in_AZ(vec_in_AZ),.vec_in_LX(vec_in_LX),.vec_in_LY(vec_in_LY),.vec_in_LZ(vec_in_LZ),
      // ivec_out, 6 values
      .ivec_out_AX(ivec_l1_out_AX),.ivec_out_AY(ivec_l1_out_AY),.ivec_out_AZ(ivec_l1_out_AZ),.ivec_out_LX(ivec_l1_out_LX),.ivec_out_LY(ivec_l1_out_LY),.ivec_out_LZ(ivec_l1_out_LZ)
      );
   // idot, Link 2
   idot#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),
      // IMAT_IN, 24 values
      .IMAT_IN_AX_AX(IMAT_L2_IN_AX_AX),.IMAT_IN_AX_AY(IMAT_L2_IN_AX_AY),.IMAT_IN_AX_AZ(IMAT_L2_IN_AX_AZ),                              .IMAT_IN_AX_LY(IMAT_L2_IN_AX_LY),.IMAT_IN_AX_LZ(IMAT_L2_IN_AX_LZ),
      .IMAT_IN_AY_AX(IMAT_L2_IN_AY_AX),.IMAT_IN_AY_AY(IMAT_L2_IN_AY_AY),.IMAT_IN_AY_AZ(IMAT_L2_IN_AY_AZ),.IMAT_IN_AY_LX(IMAT_L2_IN_AY_LX),                              .IMAT_IN_AY_LZ(IMAT_L2_IN_AY_LZ),
      .IMAT_IN_AZ_AX(IMAT_L2_IN_AZ_AX),.IMAT_IN_AZ_AY(IMAT_L2_IN_AZ_AY),.IMAT_IN_AZ_AZ(IMAT_L2_IN_AZ_AZ),.IMAT_IN_AZ_LX(IMAT_L2_IN_AZ_LX),.IMAT_IN_AZ_LY(IMAT_L2_IN_AZ_LY),
                                    .IMAT_IN_LX_AY(IMAT_L2_IN_LX_AY),.IMAT_IN_LX_AZ(IMAT_L2_IN_LX_AZ),.IMAT_IN_LX_LX(IMAT_L2_IN_LX_LX),
      .IMAT_IN_LY_AX(IMAT_L2_IN_LY_AX),                              .IMAT_IN_LY_AZ(IMAT_L2_IN_LY_AZ),                              .IMAT_IN_LY_LY(IMAT_L2_IN_LY_LY),
      .IMAT_IN_LZ_AX(IMAT_L2_IN_LZ_AX),.IMAT_IN_LZ_AY(IMAT_L2_IN_LZ_AY),                                                                                          .IMAT_IN_LZ_LZ(IMAT_L2_IN_LZ_LZ))
      idot2(
      // vec_in, 6 values
      .vec_in_AX(vec_in_AX),.vec_in_AY(vec_in_AY),.vec_in_AZ(vec_in_AZ),.vec_in_LX(vec_in_LX),.vec_in_LY(vec_in_LY),.vec_in_LZ(vec_in_LZ),
      // ivec_out, 6 values
      .ivec_out_AX(ivec_l2_out_AX),.ivec_out_AY(ivec_l2_out_AY),.ivec_out_AZ(ivec_l2_out_AZ),.ivec_out_LX(ivec_l2_out_LX),.ivec_out_LY(ivec_l2_out_LY),.ivec_out_LZ(ivec_l2_out_LZ)
      );
   // idot, Link 3
   idot#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),
      // IMAT_IN, 24 values
      .IMAT_IN_AX_AX(IMAT_L3_IN_AX_AX),.IMAT_IN_AX_AY(IMAT_L3_IN_AX_AY),.IMAT_IN_AX_AZ(IMAT_L3_IN_AX_AZ),                              .IMAT_IN_AX_LY(IMAT_L3_IN_AX_LY),.IMAT_IN_AX_LZ(IMAT_L3_IN_AX_LZ),
      .IMAT_IN_AY_AX(IMAT_L3_IN_AY_AX),.IMAT_IN_AY_AY(IMAT_L3_IN_AY_AY),.IMAT_IN_AY_AZ(IMAT_L3_IN_AY_AZ),.IMAT_IN_AY_LX(IMAT_L3_IN_AY_LX),                              .IMAT_IN_AY_LZ(IMAT_L3_IN_AY_LZ),
      .IMAT_IN_AZ_AX(IMAT_L3_IN_AZ_AX),.IMAT_IN_AZ_AY(IMAT_L3_IN_AZ_AY),.IMAT_IN_AZ_AZ(IMAT_L3_IN_AZ_AZ),.IMAT_IN_AZ_LX(IMAT_L3_IN_AZ_LX),.IMAT_IN_AZ_LY(IMAT_L3_IN_AZ_LY),
                                    .IMAT_IN_LX_AY(IMAT_L3_IN_LX_AY),.IMAT_IN_LX_AZ(IMAT_L3_IN_LX_AZ),.IMAT_IN_LX_LX(IMAT_L3_IN_LX_LX),
      .IMAT_IN_LY_AX(IMAT_L3_IN_LY_AX),                              .IMAT_IN_LY_AZ(IMAT_L3_IN_LY_AZ),                              .IMAT_IN_LY_LY(IMAT_L3_IN_LY_LY),
      .IMAT_IN_LZ_AX(IMAT_L3_IN_LZ_AX),.IMAT_IN_LZ_AY(IMAT_L3_IN_LZ_AY),                                                                                          .IMAT_IN_LZ_LZ(IMAT_L3_IN_LZ_LZ))
      idot3(
      // vec_in, 6 values
      .vec_in_AX(vec_in_AX),.vec_in_AY(vec_in_AY),.vec_in_AZ(vec_in_AZ),.vec_in_LX(vec_in_LX),.vec_in_LY(vec_in_LY),.vec_in_LZ(vec_in_LZ),
      // ivec_out, 6 values
      .ivec_out_AX(ivec_l3_out_AX),.ivec_out_AY(ivec_l3_out_AY),.ivec_out_AZ(ivec_l3_out_AZ),.ivec_out_LX(ivec_l3_out_LX),.ivec_out_LY(ivec_l3_out_LY),.ivec_out_LZ(ivec_l3_out_LZ)
      );
   // idot, Link 4
   idot#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),
      // IMAT_IN, 24 values
      .IMAT_IN_AX_AX(IMAT_L4_IN_AX_AX),.IMAT_IN_AX_AY(IMAT_L4_IN_AX_AY),.IMAT_IN_AX_AZ(IMAT_L4_IN_AX_AZ),                              .IMAT_IN_AX_LY(IMAT_L4_IN_AX_LY),.IMAT_IN_AX_LZ(IMAT_L4_IN_AX_LZ),
      .IMAT_IN_AY_AX(IMAT_L4_IN_AY_AX),.IMAT_IN_AY_AY(IMAT_L4_IN_AY_AY),.IMAT_IN_AY_AZ(IMAT_L4_IN_AY_AZ),.IMAT_IN_AY_LX(IMAT_L4_IN_AY_LX),                              .IMAT_IN_AY_LZ(IMAT_L4_IN_AY_LZ),
      .IMAT_IN_AZ_AX(IMAT_L4_IN_AZ_AX),.IMAT_IN_AZ_AY(IMAT_L4_IN_AZ_AY),.IMAT_IN_AZ_AZ(IMAT_L4_IN_AZ_AZ),.IMAT_IN_AZ_LX(IMAT_L4_IN_AZ_LX),.IMAT_IN_AZ_LY(IMAT_L4_IN_AZ_LY),
                                    .IMAT_IN_LX_AY(IMAT_L4_IN_LX_AY),.IMAT_IN_LX_AZ(IMAT_L4_IN_LX_AZ),.IMAT_IN_LX_LX(IMAT_L4_IN_LX_LX),
      .IMAT_IN_LY_AX(IMAT_L4_IN_LY_AX),                              .IMAT_IN_LY_AZ(IMAT_L4_IN_LY_AZ),                              .IMAT_IN_LY_LY(IMAT_L4_IN_LY_LY),
      .IMAT_IN_LZ_AX(IMAT_L4_IN_LZ_AX),.IMAT_IN_LZ_AY(IMAT_L4_IN_LZ_AY),                                                                                          .IMAT_IN_LZ_LZ(IMAT_L4_IN_LZ_LZ))
      idot4(
      // vec_in, 6 values
      .vec_in_AX(vec_in_AX),.vec_in_AY(vec_in_AY),.vec_in_AZ(vec_in_AZ),.vec_in_LX(vec_in_LX),.vec_in_LY(vec_in_LY),.vec_in_LZ(vec_in_LZ),
      // ivec_out, 6 values
      .ivec_out_AX(ivec_l4_out_AX),.ivec_out_AY(ivec_l4_out_AY),.ivec_out_AZ(ivec_l4_out_AZ),.ivec_out_LX(ivec_l4_out_LX),.ivec_out_LY(ivec_l4_out_LY),.ivec_out_LZ(ivec_l4_out_LZ)
      );
   // idot, Link 5
   idot#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),
      // IMAT_IN, 24 values
      .IMAT_IN_AX_AX(IMAT_L5_IN_AX_AX),.IMAT_IN_AX_AY(IMAT_L5_IN_AX_AY),.IMAT_IN_AX_AZ(IMAT_L5_IN_AX_AZ),                              .IMAT_IN_AX_LY(IMAT_L5_IN_AX_LY),.IMAT_IN_AX_LZ(IMAT_L5_IN_AX_LZ),
      .IMAT_IN_AY_AX(IMAT_L5_IN_AY_AX),.IMAT_IN_AY_AY(IMAT_L5_IN_AY_AY),.IMAT_IN_AY_AZ(IMAT_L5_IN_AY_AZ),.IMAT_IN_AY_LX(IMAT_L5_IN_AY_LX),                              .IMAT_IN_AY_LZ(IMAT_L5_IN_AY_LZ),
      .IMAT_IN_AZ_AX(IMAT_L5_IN_AZ_AX),.IMAT_IN_AZ_AY(IMAT_L5_IN_AZ_AY),.IMAT_IN_AZ_AZ(IMAT_L5_IN_AZ_AZ),.IMAT_IN_AZ_LX(IMAT_L5_IN_AZ_LX),.IMAT_IN_AZ_LY(IMAT_L5_IN_AZ_LY),
                                    .IMAT_IN_LX_AY(IMAT_L5_IN_LX_AY),.IMAT_IN_LX_AZ(IMAT_L5_IN_LX_AZ),.IMAT_IN_LX_LX(IMAT_L5_IN_LX_LX),
      .IMAT_IN_LY_AX(IMAT_L5_IN_LY_AX),                              .IMAT_IN_LY_AZ(IMAT_L5_IN_LY_AZ),                              .IMAT_IN_LY_LY(IMAT_L5_IN_LY_LY),
      .IMAT_IN_LZ_AX(IMAT_L5_IN_LZ_AX),.IMAT_IN_LZ_AY(IMAT_L5_IN_LZ_AY),                                                                                          .IMAT_IN_LZ_LZ(IMAT_L5_IN_LZ_LZ))
      idot5(
      // vec_in, 6 values
      .vec_in_AX(vec_in_AX),.vec_in_AY(vec_in_AY),.vec_in_AZ(vec_in_AZ),.vec_in_LX(vec_in_LX),.vec_in_LY(vec_in_LY),.vec_in_LZ(vec_in_LZ),
      // ivec_out, 6 values
      .ivec_out_AX(ivec_l5_out_AX),.ivec_out_AY(ivec_l5_out_AY),.ivec_out_AZ(ivec_l5_out_AZ),.ivec_out_LX(ivec_l5_out_LX),.ivec_out_LY(ivec_l5_out_LY),.ivec_out_LZ(ivec_l5_out_LZ)
      );
   // idot, Link 6
   idot#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),
      // IMAT_IN, 24 values
      .IMAT_IN_AX_AX(IMAT_L6_IN_AX_AX),.IMAT_IN_AX_AY(IMAT_L6_IN_AX_AY),.IMAT_IN_AX_AZ(IMAT_L6_IN_AX_AZ),                              .IMAT_IN_AX_LY(IMAT_L6_IN_AX_LY),.IMAT_IN_AX_LZ(IMAT_L6_IN_AX_LZ),
      .IMAT_IN_AY_AX(IMAT_L6_IN_AY_AX),.IMAT_IN_AY_AY(IMAT_L6_IN_AY_AY),.IMAT_IN_AY_AZ(IMAT_L6_IN_AY_AZ),.IMAT_IN_AY_LX(IMAT_L6_IN_AY_LX),                              .IMAT_IN_AY_LZ(IMAT_L6_IN_AY_LZ),
      .IMAT_IN_AZ_AX(IMAT_L6_IN_AZ_AX),.IMAT_IN_AZ_AY(IMAT_L6_IN_AZ_AY),.IMAT_IN_AZ_AZ(IMAT_L6_IN_AZ_AZ),.IMAT_IN_AZ_LX(IMAT_L6_IN_AZ_LX),.IMAT_IN_AZ_LY(IMAT_L6_IN_AZ_LY),
                                    .IMAT_IN_LX_AY(IMAT_L6_IN_LX_AY),.IMAT_IN_LX_AZ(IMAT_L6_IN_LX_AZ),.IMAT_IN_LX_LX(IMAT_L6_IN_LX_LX),
      .IMAT_IN_LY_AX(IMAT_L6_IN_LY_AX),                              .IMAT_IN_LY_AZ(IMAT_L6_IN_LY_AZ),                              .IMAT_IN_LY_LY(IMAT_L6_IN_LY_LY),
      .IMAT_IN_LZ_AX(IMAT_L6_IN_LZ_AX),.IMAT_IN_LZ_AY(IMAT_L6_IN_LZ_AY),                                                                                          .IMAT_IN_LZ_LZ(IMAT_L6_IN_LZ_LZ))
      idot6(
      // vec_in, 6 values
      .vec_in_AX(vec_in_AX),.vec_in_AY(vec_in_AY),.vec_in_AZ(vec_in_AZ),.vec_in_LX(vec_in_LX),.vec_in_LY(vec_in_LY),.vec_in_LZ(vec_in_LZ),
      // ivec_out, 6 values
      .ivec_out_AX(ivec_l6_out_AX),.ivec_out_AY(ivec_l6_out_AY),.ivec_out_AZ(ivec_l6_out_AZ),.ivec_out_LX(ivec_l6_out_LX),.ivec_out_LY(ivec_l6_out_LY),.ivec_out_LZ(ivec_l6_out_LZ)
      );
   // idot, Link 7
   idot#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS),
      // IMAT_IN, 24 values
      .IMAT_IN_AX_AX(IMAT_L7_IN_AX_AX),.IMAT_IN_AX_AY(IMAT_L7_IN_AX_AY),.IMAT_IN_AX_AZ(IMAT_L7_IN_AX_AZ),                              .IMAT_IN_AX_LY(IMAT_L7_IN_AX_LY),.IMAT_IN_AX_LZ(IMAT_L7_IN_AX_LZ),
      .IMAT_IN_AY_AX(IMAT_L7_IN_AY_AX),.IMAT_IN_AY_AY(IMAT_L7_IN_AY_AY),.IMAT_IN_AY_AZ(IMAT_L7_IN_AY_AZ),.IMAT_IN_AY_LX(IMAT_L7_IN_AY_LX),                              .IMAT_IN_AY_LZ(IMAT_L7_IN_AY_LZ),
      .IMAT_IN_AZ_AX(IMAT_L7_IN_AZ_AX),.IMAT_IN_AZ_AY(IMAT_L7_IN_AZ_AY),.IMAT_IN_AZ_AZ(IMAT_L7_IN_AZ_AZ),.IMAT_IN_AZ_LX(IMAT_L7_IN_AZ_LX),.IMAT_IN_AZ_LY(IMAT_L7_IN_AZ_LY),
                                    .IMAT_IN_LX_AY(IMAT_L7_IN_LX_AY),.IMAT_IN_LX_AZ(IMAT_L7_IN_LX_AZ),.IMAT_IN_LX_LX(IMAT_L7_IN_LX_LX),
      .IMAT_IN_LY_AX(IMAT_L7_IN_LY_AX),                              .IMAT_IN_LY_AZ(IMAT_L7_IN_LY_AZ),                              .IMAT_IN_LY_LY(IMAT_L7_IN_LY_LY),
      .IMAT_IN_LZ_AX(IMAT_L7_IN_LZ_AX),.IMAT_IN_LZ_AY(IMAT_L7_IN_LZ_AY),                                                                                          .IMAT_IN_LZ_LZ(IMAT_L7_IN_LZ_LZ))
      idot7(
      // vec_in, 6 values
      .vec_in_AX(vec_in_AX),.vec_in_AY(vec_in_AY),.vec_in_AZ(vec_in_AZ),.vec_in_LX(vec_in_LX),.vec_in_LY(vec_in_LY),.vec_in_LZ(vec_in_LZ),
      // ivec_out, 6 values
      .ivec_out_AX(ivec_l7_out_AX),.ivec_out_AY(ivec_l7_out_AY),.ivec_out_AZ(ivec_l7_out_AZ),.ivec_out_LX(ivec_l7_out_LX),.ivec_out_LY(ivec_l7_out_LY),.ivec_out_LZ(ivec_l7_out_LZ)
      );

   // output muxes
   // AX
   assign ivec_out_AX = (link_in == 3'd1) ?  ivec_l1_out_AX :
                        (link_in == 3'd2) ?  ivec_l2_out_AX :
                        (link_in == 3'd3) ?  ivec_l3_out_AX :
                        (link_in == 3'd4) ?  ivec_l4_out_AX :
                        (link_in == 3'd5) ?  ivec_l5_out_AX :
                        (link_in == 3'd6) ?  ivec_l6_out_AX :
                        (link_in == 3'd7) ?  ivec_l7_out_AX : 32'd0;
   // AY
   assign ivec_out_AY = (link_in == 3'd1) ?  ivec_l1_out_AY :
                        (link_in == 3'd2) ?  ivec_l2_out_AY :
                        (link_in == 3'd3) ?  ivec_l3_out_AY :
                        (link_in == 3'd4) ?  ivec_l4_out_AY :
                        (link_in == 3'd5) ?  ivec_l5_out_AY :
                        (link_in == 3'd6) ?  ivec_l6_out_AY :
                        (link_in == 3'd7) ?  ivec_l7_out_AY : 32'd0;
   // AZ
   assign ivec_out_AZ = (link_in == 3'd1) ?  ivec_l1_out_AZ :
                        (link_in == 3'd2) ?  ivec_l2_out_AZ :
                        (link_in == 3'd3) ?  ivec_l3_out_AZ :
                        (link_in == 3'd4) ?  ivec_l4_out_AZ :
                        (link_in == 3'd5) ?  ivec_l5_out_AZ :
                        (link_in == 3'd6) ?  ivec_l6_out_AZ :
                        (link_in == 3'd7) ?  ivec_l7_out_AZ : 32'd0;
   // LX
   assign ivec_out_LX = (link_in == 3'd1) ?  ivec_l1_out_LX :
                        (link_in == 3'd2) ?  ivec_l2_out_LX :
                        (link_in == 3'd3) ?  ivec_l3_out_LX :
                        (link_in == 3'd4) ?  ivec_l4_out_LX :
                        (link_in == 3'd5) ?  ivec_l5_out_LX :
                        (link_in == 3'd6) ?  ivec_l6_out_LX :
                        (link_in == 3'd7) ?  ivec_l7_out_LX : 32'd0;
   // LY
   assign ivec_out_LY = (link_in == 3'd1) ?  ivec_l1_out_LY :
                        (link_in == 3'd2) ?  ivec_l2_out_LY :
                        (link_in == 3'd3) ?  ivec_l3_out_LY :
                        (link_in == 3'd4) ?  ivec_l4_out_LY :
                        (link_in == 3'd5) ?  ivec_l5_out_LY :
                        (link_in == 3'd6) ?  ivec_l6_out_LY :
                        (link_in == 3'd7) ?  ivec_l7_out_LY : 32'd0;
   // LZ
   assign ivec_out_LZ = (link_in == 3'd1) ?  ivec_l1_out_LZ :
                        (link_in == 3'd2) ?  ivec_l2_out_LZ :
                        (link_in == 3'd3) ?  ivec_l3_out_LZ :
                        (link_in == 3'd4) ?  ivec_l4_out_LZ :
                        (link_in == 3'd5) ?  ivec_l5_out_LZ :
                        (link_in == 3'd6) ?  ivec_l6_out_LZ :
                        (link_in == 3'd7) ?  ivec_l7_out_LZ : 32'd0;

endmodule
