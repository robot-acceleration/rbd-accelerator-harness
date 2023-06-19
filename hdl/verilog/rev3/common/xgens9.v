`timescale 1ns / 1ps

// Transformation Matrix Generation

//------------------------------------------------------------------------------
// xgens9 Module
//------------------------------------------------------------------------------
module xgens9#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // link_in
   input  [3:0]
      link_in,
   // sin(q) and cos(q)
   input  signed[(WIDTH-1):0]
      sinq_in,cosq_in,

   // internal wires and state
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
      xform_l1_out_AX_AX,xform_l1_out_AX_AY,xform_l1_out_AX_AZ,
      xform_l1_out_AY_AX,xform_l1_out_AY_AY,xform_l1_out_AY_AZ,
                  xform_l1_out_AZ_AY,xform_l1_out_AZ_AZ,
      xform_l1_out_LX_AX,xform_l1_out_LX_AY,xform_l1_out_LX_AZ,
      xform_l1_out_LY_AX,xform_l1_out_LY_AY,xform_l1_out_LY_AZ,
      xform_l1_out_LZ_AX;

   wire signed[(WIDTH-1):0]
      xform_l2_out_AX_AX,xform_l2_out_AX_AY,xform_l2_out_AX_AZ,
      xform_l2_out_AY_AX,xform_l2_out_AY_AY,xform_l2_out_AY_AZ,
                  xform_l2_out_AZ_AY,xform_l2_out_AZ_AZ,
      xform_l2_out_LX_AX,xform_l2_out_LX_AY,xform_l2_out_LX_AZ,
      xform_l2_out_LY_AX,xform_l2_out_LY_AY,xform_l2_out_LY_AZ,
      xform_l2_out_LZ_AX;

   wire signed[(WIDTH-1):0]
      xform_l3_out_AX_AX,xform_l3_out_AX_AY,xform_l3_out_AX_AZ,
      xform_l3_out_AY_AX,xform_l3_out_AY_AY,xform_l3_out_AY_AZ,
                  xform_l3_out_AZ_AY,xform_l3_out_AZ_AZ,
      xform_l3_out_LX_AX,xform_l3_out_LX_AY,xform_l3_out_LX_AZ,
      xform_l3_out_LY_AX,xform_l3_out_LY_AY,xform_l3_out_LY_AZ,
      xform_l3_out_LZ_AX;

   wire signed[(WIDTH-1):0]
      xform_l4_out_AX_AX,xform_l4_out_AX_AY,xform_l4_out_AX_AZ,
      xform_l4_out_AY_AX,xform_l4_out_AY_AY,xform_l4_out_AY_AZ,
                  xform_l4_out_AZ_AY,xform_l4_out_AZ_AZ,
      xform_l4_out_LX_AX,xform_l4_out_LX_AY,xform_l4_out_LX_AZ,
      xform_l4_out_LY_AX,xform_l4_out_LY_AY,xform_l4_out_LY_AZ,
      xform_l4_out_LZ_AX;

   wire signed[(WIDTH-1):0]
      xform_l5_out_AX_AX,xform_l5_out_AX_AY,xform_l5_out_AX_AZ,
      xform_l5_out_AY_AX,xform_l5_out_AY_AY,xform_l5_out_AY_AZ,
                  xform_l5_out_AZ_AY,xform_l5_out_AZ_AZ,
      xform_l5_out_LX_AX,xform_l5_out_LX_AY,xform_l5_out_LX_AZ,
      xform_l5_out_LY_AX,xform_l5_out_LY_AY,xform_l5_out_LY_AZ,
      xform_l5_out_LZ_AX;

   wire signed[(WIDTH-1):0]
      xform_l6_out_AX_AX,xform_l6_out_AX_AY,xform_l6_out_AX_AZ,
      xform_l6_out_AY_AX,xform_l6_out_AY_AY,xform_l6_out_AY_AZ,
                  xform_l6_out_AZ_AY,xform_l6_out_AZ_AZ,
      xform_l6_out_LX_AX,xform_l6_out_LX_AY,xform_l6_out_LX_AZ,
      xform_l6_out_LY_AX,xform_l6_out_LY_AY,xform_l6_out_LY_AZ,
      xform_l6_out_LZ_AX;

   wire signed[(WIDTH-1):0]
      xform_l7_out_AX_AX,xform_l7_out_AX_AY,xform_l7_out_AX_AZ,
      xform_l7_out_AY_AX,xform_l7_out_AY_AY,xform_l7_out_AY_AZ,
                  xform_l7_out_AZ_AY,xform_l7_out_AZ_AZ,
      xform_l7_out_LX_AX,xform_l7_out_LX_AY,xform_l7_out_LX_AZ,
      xform_l7_out_LY_AX,xform_l7_out_LY_AY,xform_l7_out_LY_AZ,
      xform_l7_out_LZ_AX;

   wire signed[(WIDTH-1):0]
      xform_l8_out_AX_AX,xform_l8_out_AX_AY,xform_l8_out_AX_AZ,
      xform_l8_out_AY_AX,xform_l8_out_AY_AY,xform_l8_out_AY_AZ,
                  xform_l8_out_AZ_AY,xform_l8_out_AZ_AZ,
      xform_l8_out_LX_AX,xform_l8_out_LX_AY,xform_l8_out_LX_AZ,
      xform_l8_out_LY_AX,xform_l8_out_LY_AY,xform_l8_out_LY_AZ,
      xform_l8_out_LZ_AX;

   wire signed[(WIDTH-1):0]
      xform_l9_out_AX_AX,xform_l9_out_AX_AY,xform_l9_out_AX_AZ,
      xform_l9_out_AY_AX,xform_l9_out_AY_AY,xform_l9_out_AY_AZ,
                  xform_l9_out_AZ_AY,xform_l9_out_AZ_AZ,
      xform_l9_out_LX_AX,xform_l9_out_LX_AY,xform_l9_out_LX_AZ,
      xform_l9_out_LY_AX,xform_l9_out_LY_AY,xform_l9_out_LY_AZ,
      xform_l9_out_LZ_AX;


   // Link = 1
   xgen1X0#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut1X0(
      // sin(q) and cos(q)
      .sinq_in(sinq_in),.cosq_in(cosq_in),
      // xform_out, 15 values
      .xform_out_AX_AX(xform_l1_out_AX_AX),.xform_out_AX_AY(xform_l1_out_AX_AY),.xform_out_AX_AZ(xform_l1_out_AX_AZ),
      .xform_out_AY_AX(xform_l1_out_AY_AX),.xform_out_AY_AY(xform_l1_out_AY_AY),.xform_out_AY_AZ(xform_l1_out_AY_AZ),
                                        .xform_out_AZ_AY(xform_l1_out_AZ_AY),.xform_out_AZ_AZ(xform_l1_out_AZ_AZ),
      .xform_out_LX_AX(xform_l1_out_LX_AX),.xform_out_LX_AY(xform_l1_out_LX_AY),.xform_out_LX_AZ(xform_l1_out_LX_AZ),
      .xform_out_LY_AX(xform_l1_out_LY_AX),.xform_out_LY_AY(xform_l1_out_LY_AY),.xform_out_LY_AZ(xform_l1_out_LY_AZ),
      .xform_out_LZ_AX(xform_l1_out_LZ_AX)
      );
   // Link = 2
   xgen2X1#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut2X1(
      // sin(q) and cos(q)
      .sinq_in(sinq_in),.cosq_in(cosq_in),
      // xform_out, 15 values
      .xform_out_AX_AX(xform_l2_out_AX_AX),.xform_out_AX_AY(xform_l2_out_AX_AY),.xform_out_AX_AZ(xform_l2_out_AX_AZ),
      .xform_out_AY_AX(xform_l2_out_AY_AX),.xform_out_AY_AY(xform_l2_out_AY_AY),.xform_out_AY_AZ(xform_l2_out_AY_AZ),
                                        .xform_out_AZ_AY(xform_l2_out_AZ_AY),.xform_out_AZ_AZ(xform_l2_out_AZ_AZ),
      .xform_out_LX_AX(xform_l2_out_LX_AX),.xform_out_LX_AY(xform_l2_out_LX_AY),.xform_out_LX_AZ(xform_l2_out_LX_AZ),
      .xform_out_LY_AX(xform_l2_out_LY_AX),.xform_out_LY_AY(xform_l2_out_LY_AY),.xform_out_LY_AZ(xform_l2_out_LY_AZ),
      .xform_out_LZ_AX(xform_l2_out_LZ_AX)
      );
   // Link = 3
   xgen3X2#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut3X2(
      // sin(q) and cos(q)
      .sinq_in(sinq_in),.cosq_in(cosq_in),
      // xform_out, 15 values
      .xform_out_AX_AX(xform_l3_out_AX_AX),.xform_out_AX_AY(xform_l3_out_AX_AY),.xform_out_AX_AZ(xform_l3_out_AX_AZ),
      .xform_out_AY_AX(xform_l3_out_AY_AX),.xform_out_AY_AY(xform_l3_out_AY_AY),.xform_out_AY_AZ(xform_l3_out_AY_AZ),
                                        .xform_out_AZ_AY(xform_l3_out_AZ_AY),.xform_out_AZ_AZ(xform_l3_out_AZ_AZ),
      .xform_out_LX_AX(xform_l3_out_LX_AX),.xform_out_LX_AY(xform_l3_out_LX_AY),.xform_out_LX_AZ(xform_l3_out_LX_AZ),
      .xform_out_LY_AX(xform_l3_out_LY_AX),.xform_out_LY_AY(xform_l3_out_LY_AY),.xform_out_LY_AZ(xform_l3_out_LY_AZ),
      .xform_out_LZ_AX(xform_l3_out_LZ_AX)
      );
   // Link = 4
   xgen4X3#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut4X3(
      // sin(q) and cos(q)
      .sinq_in(sinq_in),.cosq_in(cosq_in),
      // xform_out, 15 values
      .xform_out_AX_AX(xform_l4_out_AX_AX),.xform_out_AX_AY(xform_l4_out_AX_AY),.xform_out_AX_AZ(xform_l4_out_AX_AZ),
      .xform_out_AY_AX(xform_l4_out_AY_AX),.xform_out_AY_AY(xform_l4_out_AY_AY),.xform_out_AY_AZ(xform_l4_out_AY_AZ),
                                        .xform_out_AZ_AY(xform_l4_out_AZ_AY),.xform_out_AZ_AZ(xform_l4_out_AZ_AZ),
      .xform_out_LX_AX(xform_l4_out_LX_AX),.xform_out_LX_AY(xform_l4_out_LX_AY),.xform_out_LX_AZ(xform_l4_out_LX_AZ),
      .xform_out_LY_AX(xform_l4_out_LY_AX),.xform_out_LY_AY(xform_l4_out_LY_AY),.xform_out_LY_AZ(xform_l4_out_LY_AZ),
      .xform_out_LZ_AX(xform_l4_out_LZ_AX)
      );
   // Link = 5
   xgen5X4#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut5X4(
      // sin(q) and cos(q)
      .sinq_in(sinq_in),.cosq_in(cosq_in),
      // xform_out, 15 values
      .xform_out_AX_AX(xform_l5_out_AX_AX),.xform_out_AX_AY(xform_l5_out_AX_AY),.xform_out_AX_AZ(xform_l5_out_AX_AZ),
      .xform_out_AY_AX(xform_l5_out_AY_AX),.xform_out_AY_AY(xform_l5_out_AY_AY),.xform_out_AY_AZ(xform_l5_out_AY_AZ),
                                        .xform_out_AZ_AY(xform_l5_out_AZ_AY),.xform_out_AZ_AZ(xform_l5_out_AZ_AZ),
      .xform_out_LX_AX(xform_l5_out_LX_AX),.xform_out_LX_AY(xform_l5_out_LX_AY),.xform_out_LX_AZ(xform_l5_out_LX_AZ),
      .xform_out_LY_AX(xform_l5_out_LY_AX),.xform_out_LY_AY(xform_l5_out_LY_AY),.xform_out_LY_AZ(xform_l5_out_LY_AZ),
      .xform_out_LZ_AX(xform_l5_out_LZ_AX)
      );
   // Link = 6
   xgen6X5#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut6X5(
      // sin(q) and cos(q)
      .sinq_in(sinq_in),.cosq_in(cosq_in),
      // xform_out, 15 values
      .xform_out_AX_AX(xform_l6_out_AX_AX),.xform_out_AX_AY(xform_l6_out_AX_AY),.xform_out_AX_AZ(xform_l6_out_AX_AZ),
      .xform_out_AY_AX(xform_l6_out_AY_AX),.xform_out_AY_AY(xform_l6_out_AY_AY),.xform_out_AY_AZ(xform_l6_out_AY_AZ),
                                        .xform_out_AZ_AY(xform_l6_out_AZ_AY),.xform_out_AZ_AZ(xform_l6_out_AZ_AZ),
      .xform_out_LX_AX(xform_l6_out_LX_AX),.xform_out_LX_AY(xform_l6_out_LX_AY),.xform_out_LX_AZ(xform_l6_out_LX_AZ),
      .xform_out_LY_AX(xform_l6_out_LY_AX),.xform_out_LY_AY(xform_l6_out_LY_AY),.xform_out_LY_AZ(xform_l6_out_LY_AZ),
      .xform_out_LZ_AX(xform_l6_out_LZ_AX)
      );
   // Link = 7
   xgen7X6#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut7X6(
      // sin(q) and cos(q)
      .sinq_in(sinq_in),.cosq_in(cosq_in),
      // xform_out, 15 values
      .xform_out_AX_AX(xform_l7_out_AX_AX),.xform_out_AX_AY(xform_l7_out_AX_AY),.xform_out_AX_AZ(xform_l7_out_AX_AZ),
      .xform_out_AY_AX(xform_l7_out_AY_AX),.xform_out_AY_AY(xform_l7_out_AY_AY),.xform_out_AY_AZ(xform_l7_out_AY_AZ),
                                        .xform_out_AZ_AY(xform_l7_out_AZ_AY),.xform_out_AZ_AZ(xform_l7_out_AZ_AZ),
      .xform_out_LX_AX(xform_l7_out_LX_AX),.xform_out_LX_AY(xform_l7_out_LX_AY),.xform_out_LX_AZ(xform_l7_out_LX_AZ),
      .xform_out_LY_AX(xform_l7_out_LY_AX),.xform_out_LY_AY(xform_l7_out_LY_AY),.xform_out_LY_AZ(xform_l7_out_LY_AZ),
      .xform_out_LZ_AX(xform_l7_out_LZ_AX)
      );
   // Link = 8
   xgen8X7#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut8X7(
      // sin(q) and cos(q)
      .sinq_in(sinq_in),.cosq_in(cosq_in),
      // xform_out, 15 values
      .xform_out_AX_AX(xform_l8_out_AX_AX),.xform_out_AX_AY(xform_l8_out_AX_AY),.xform_out_AX_AZ(xform_l8_out_AX_AZ),
      .xform_out_AY_AX(xform_l8_out_AY_AX),.xform_out_AY_AY(xform_l8_out_AY_AY),.xform_out_AY_AZ(xform_l8_out_AY_AZ),
                                        .xform_out_AZ_AY(xform_l8_out_AZ_AY),.xform_out_AZ_AZ(xform_l8_out_AZ_AZ),
      .xform_out_LX_AX(xform_l8_out_LX_AX),.xform_out_LX_AY(xform_l8_out_LX_AY),.xform_out_LX_AZ(xform_l8_out_LX_AZ),
      .xform_out_LY_AX(xform_l8_out_LY_AX),.xform_out_LY_AY(xform_l8_out_LY_AY),.xform_out_LY_AZ(xform_l8_out_LY_AZ),
      .xform_out_LZ_AX(xform_l8_out_LZ_AX)
      );
   // Link = 9
   xgen9X8#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut9X8(
      // sin(q) and cos(q)
      .sinq_in(sinq_in),.cosq_in(cosq_in),
      // xform_out, 15 values
      .xform_out_AX_AX(xform_l9_out_AX_AX),.xform_out_AX_AY(xform_l9_out_AX_AY),.xform_out_AX_AZ(xform_l9_out_AX_AZ),
      .xform_out_AY_AX(xform_l9_out_AY_AX),.xform_out_AY_AY(xform_l9_out_AY_AY),.xform_out_AY_AZ(xform_l9_out_AY_AZ),
                                        .xform_out_AZ_AY(xform_l9_out_AZ_AY),.xform_out_AZ_AZ(xform_l9_out_AZ_AZ),
      .xform_out_LX_AX(xform_l9_out_LX_AX),.xform_out_LX_AY(xform_l9_out_LX_AY),.xform_out_LX_AZ(xform_l9_out_LX_AZ),
      .xform_out_LY_AX(xform_l9_out_LY_AX),.xform_out_LY_AY(xform_l9_out_LY_AY),.xform_out_LY_AZ(xform_l9_out_LY_AZ),
      .xform_out_LZ_AX(xform_l9_out_LZ_AX)
      );

   // output muxes
// AX_AX
   assign xform_out_AX_AX = (link_in == 4'd1) ? xform_l1_out_AX_AX :
                            (link_in == 4'd2) ? xform_l2_out_AX_AX :
                            (link_in == 4'd3) ? xform_l3_out_AX_AX :
                            (link_in == 4'd4) ? xform_l4_out_AX_AX :
                            (link_in == 4'd5) ? xform_l5_out_AX_AX :
                            (link_in == 4'd6) ? xform_l6_out_AX_AX :
                            (link_in == 4'd7) ? xform_l7_out_AX_AX :
                            (link_in == 4'd8) ? xform_l8_out_AX_AX :
                            (link_in == 4'd9) ? xform_l9_out_AX_AX :
                            32'd0;
// AX_AY
   assign xform_out_AX_AY = (link_in == 4'd1) ? xform_l1_out_AX_AY :
                            (link_in == 4'd2) ? xform_l2_out_AX_AY :
                            (link_in == 4'd3) ? xform_l3_out_AX_AY :
                            (link_in == 4'd4) ? xform_l4_out_AX_AY :
                            (link_in == 4'd5) ? xform_l5_out_AX_AY :
                            (link_in == 4'd6) ? xform_l6_out_AX_AY :
                            (link_in == 4'd7) ? xform_l7_out_AX_AY :
                            (link_in == 4'd8) ? xform_l8_out_AX_AY :
                            (link_in == 4'd9) ? xform_l9_out_AX_AY :
                            32'd0;
// AX_AZ
   assign xform_out_AX_AZ = (link_in == 4'd1) ? xform_l1_out_AX_AZ :
                            (link_in == 4'd2) ? xform_l2_out_AX_AZ :
                            (link_in == 4'd3) ? xform_l3_out_AX_AZ :
                            (link_in == 4'd4) ? xform_l4_out_AX_AZ :
                            (link_in == 4'd5) ? xform_l5_out_AX_AZ :
                            (link_in == 4'd6) ? xform_l6_out_AX_AZ :
                            (link_in == 4'd7) ? xform_l7_out_AX_AZ :
                            (link_in == 4'd8) ? xform_l8_out_AX_AZ :
                            (link_in == 4'd9) ? xform_l9_out_AX_AZ :
                            32'd0;
// AY_AX
   assign xform_out_AY_AX = (link_in == 4'd1) ? xform_l1_out_AY_AX :
                            (link_in == 4'd2) ? xform_l2_out_AY_AX :
                            (link_in == 4'd3) ? xform_l3_out_AY_AX :
                            (link_in == 4'd4) ? xform_l4_out_AY_AX :
                            (link_in == 4'd5) ? xform_l5_out_AY_AX :
                            (link_in == 4'd6) ? xform_l6_out_AY_AX :
                            (link_in == 4'd7) ? xform_l7_out_AY_AX :
                            (link_in == 4'd8) ? xform_l8_out_AY_AX :
                            (link_in == 4'd9) ? xform_l9_out_AY_AX :
                            32'd0;
// AY_AY
   assign xform_out_AY_AY = (link_in == 4'd1) ? xform_l1_out_AY_AY :
                            (link_in == 4'd2) ? xform_l2_out_AY_AY :
                            (link_in == 4'd3) ? xform_l3_out_AY_AY :
                            (link_in == 4'd4) ? xform_l4_out_AY_AY :
                            (link_in == 4'd5) ? xform_l5_out_AY_AY :
                            (link_in == 4'd6) ? xform_l6_out_AY_AY :
                            (link_in == 4'd7) ? xform_l7_out_AY_AY :
                            (link_in == 4'd8) ? xform_l8_out_AY_AY :
                            (link_in == 4'd9) ? xform_l9_out_AY_AY :
                            32'd0;
// AY_AZ
   assign xform_out_AY_AZ = (link_in == 4'd1) ? xform_l1_out_AY_AZ :
                            (link_in == 4'd2) ? xform_l2_out_AY_AZ :
                            (link_in == 4'd3) ? xform_l3_out_AY_AZ :
                            (link_in == 4'd4) ? xform_l4_out_AY_AZ :
                            (link_in == 4'd5) ? xform_l5_out_AY_AZ :
                            (link_in == 4'd6) ? xform_l6_out_AY_AZ :
                            (link_in == 4'd7) ? xform_l7_out_AY_AZ :
                            (link_in == 4'd8) ? xform_l8_out_AY_AZ :
                            (link_in == 4'd9) ? xform_l9_out_AY_AZ :
                            32'd0;
// AZ_AY
   assign xform_out_AZ_AY = (link_in == 4'd1) ? xform_l1_out_AZ_AY :
                            (link_in == 4'd2) ? xform_l2_out_AZ_AY :
                            (link_in == 4'd3) ? xform_l3_out_AZ_AY :
                            (link_in == 4'd4) ? xform_l4_out_AZ_AY :
                            (link_in == 4'd5) ? xform_l5_out_AZ_AY :
                            (link_in == 4'd6) ? xform_l6_out_AZ_AY :
                            (link_in == 4'd7) ? xform_l7_out_AZ_AY :
                            (link_in == 4'd8) ? xform_l8_out_AZ_AY :
                            (link_in == 4'd9) ? xform_l9_out_AZ_AY :
                            32'd0;
// AZ_AZ
   assign xform_out_AZ_AZ = (link_in == 4'd1) ? xform_l1_out_AZ_AZ :
                            (link_in == 4'd2) ? xform_l2_out_AZ_AZ :
                            (link_in == 4'd3) ? xform_l3_out_AZ_AZ :
                            (link_in == 4'd4) ? xform_l4_out_AZ_AZ :
                            (link_in == 4'd5) ? xform_l5_out_AZ_AZ :
                            (link_in == 4'd6) ? xform_l6_out_AZ_AZ :
                            (link_in == 4'd7) ? xform_l7_out_AZ_AZ :
                            (link_in == 4'd8) ? xform_l8_out_AZ_AZ :
                            (link_in == 4'd9) ? xform_l9_out_AZ_AZ :
                            32'd0;
// LX_AX
   assign xform_out_LX_AX = (link_in == 4'd1) ? xform_l1_out_LX_AX :
                            (link_in == 4'd2) ? xform_l2_out_LX_AX :
                            (link_in == 4'd3) ? xform_l3_out_LX_AX :
                            (link_in == 4'd4) ? xform_l4_out_LX_AX :
                            (link_in == 4'd5) ? xform_l5_out_LX_AX :
                            (link_in == 4'd6) ? xform_l6_out_LX_AX :
                            (link_in == 4'd7) ? xform_l7_out_LX_AX :
                            (link_in == 4'd8) ? xform_l8_out_LX_AX :
                            (link_in == 4'd9) ? xform_l9_out_LX_AX :
                            32'd0;
// LX_AY
   assign xform_out_LX_AY = (link_in == 4'd1) ? xform_l1_out_LX_AY :
                            (link_in == 4'd2) ? xform_l2_out_LX_AY :
                            (link_in == 4'd3) ? xform_l3_out_LX_AY :
                            (link_in == 4'd4) ? xform_l4_out_LX_AY :
                            (link_in == 4'd5) ? xform_l5_out_LX_AY :
                            (link_in == 4'd6) ? xform_l6_out_LX_AY :
                            (link_in == 4'd7) ? xform_l7_out_LX_AY :
                            (link_in == 4'd8) ? xform_l8_out_LX_AY :
                            (link_in == 4'd9) ? xform_l9_out_LX_AY :
                            32'd0;
// LX_AZ
   assign xform_out_LX_AZ = (link_in == 4'd1) ? xform_l1_out_LX_AZ :
                            (link_in == 4'd2) ? xform_l2_out_LX_AZ :
                            (link_in == 4'd3) ? xform_l3_out_LX_AZ :
                            (link_in == 4'd4) ? xform_l4_out_LX_AZ :
                            (link_in == 4'd5) ? xform_l5_out_LX_AZ :
                            (link_in == 4'd6) ? xform_l6_out_LX_AZ :
                            (link_in == 4'd7) ? xform_l7_out_LX_AZ :
                            (link_in == 4'd8) ? xform_l8_out_LX_AZ :
                            (link_in == 4'd9) ? xform_l9_out_LX_AZ :
                            32'd0;
// LY_AX
   assign xform_out_LY_AX = (link_in == 4'd1) ? xform_l1_out_LY_AX :
                            (link_in == 4'd2) ? xform_l2_out_LY_AX :
                            (link_in == 4'd3) ? xform_l3_out_LY_AX :
                            (link_in == 4'd4) ? xform_l4_out_LY_AX :
                            (link_in == 4'd5) ? xform_l5_out_LY_AX :
                            (link_in == 4'd6) ? xform_l6_out_LY_AX :
                            (link_in == 4'd7) ? xform_l7_out_LY_AX :
                            (link_in == 4'd8) ? xform_l8_out_LY_AX :
                            (link_in == 4'd9) ? xform_l9_out_LY_AX :
                            32'd0;
// LY_AY
   assign xform_out_LY_AY = (link_in == 4'd1) ? xform_l1_out_LY_AY :
                            (link_in == 4'd2) ? xform_l2_out_LY_AY :
                            (link_in == 4'd3) ? xform_l3_out_LY_AY :
                            (link_in == 4'd4) ? xform_l4_out_LY_AY :
                            (link_in == 4'd5) ? xform_l5_out_LY_AY :
                            (link_in == 4'd6) ? xform_l6_out_LY_AY :
                            (link_in == 4'd7) ? xform_l7_out_LY_AY :
                            (link_in == 4'd8) ? xform_l8_out_LY_AY :
                            (link_in == 4'd9) ? xform_l9_out_LY_AY :
                            32'd0;
// LY_AZ
   assign xform_out_LY_AZ = (link_in == 4'd1) ? xform_l1_out_LY_AZ :
                            (link_in == 4'd2) ? xform_l2_out_LY_AZ :
                            (link_in == 4'd3) ? xform_l3_out_LY_AZ :
                            (link_in == 4'd4) ? xform_l4_out_LY_AZ :
                            (link_in == 4'd5) ? xform_l5_out_LY_AZ :
                            (link_in == 4'd6) ? xform_l6_out_LY_AZ :
                            (link_in == 4'd7) ? xform_l7_out_LY_AZ :
                            (link_in == 4'd8) ? xform_l8_out_LY_AZ :
                            (link_in == 4'd9) ? xform_l9_out_LY_AZ :
                            32'd0;
// LZ_AX
   assign xform_out_LZ_AX = (link_in == 4'd1) ? xform_l1_out_LZ_AX :
                            (link_in == 4'd2) ? xform_l2_out_LZ_AX :
                            (link_in == 4'd3) ? xform_l3_out_LZ_AX :
                            (link_in == 4'd4) ? xform_l4_out_LZ_AX :
                            (link_in == 4'd5) ? xform_l5_out_LZ_AX :
                            (link_in == 4'd6) ? xform_l6_out_LZ_AX :
                            (link_in == 4'd7) ? xform_l7_out_LZ_AX :
                            (link_in == 4'd8) ? xform_l8_out_LZ_AX :
                            (link_in == 4'd9) ? xform_l9_out_LZ_AX :
                            32'd0;

endmodule
