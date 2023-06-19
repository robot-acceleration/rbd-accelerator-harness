`timescale 1ns / 1ps

// dqd Backward Pass for Link i Input j and Minv

//------------------------------------------------------------------------------
// dqdbpijx Module
//------------------------------------------------------------------------------
module dqdbpijx#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // link_in
   input  [2:0]
      link_in,
   // sin(q) and cos(q)
   input  signed[(WIDTH-1):0]
      sinq_in,cosq_in,
   // dfdqd_curr_in, 6 values
   input  signed[(WIDTH-1):0]
      dfdqd_curr_in_AX,dfdqd_curr_in_AY,dfdqd_curr_in_AZ,dfdqd_curr_in_LX,dfdqd_curr_in_LY,dfdqd_curr_in_LZ,
   // dfdqd_prev_in, 6 values
   input  signed[(WIDTH-1):0]
      dfdqd_prev_in_AX,dfdqd_prev_in_AY,dfdqd_prev_in_AZ,dfdqd_prev_in_LX,dfdqd_prev_in_LY,dfdqd_prev_in_LZ,
   // dtau_dqd_out
   output signed[(WIDTH-1):0]
      dtau_dqd_out,
   // dfdqd_prev_out, 6 values
   output signed[(WIDTH-1):0]
      dfdqd_prev_out_AX,dfdqd_prev_out_AY,dfdqd_prev_out_AZ,dfdqd_prev_out_LX,dfdqd_prev_out_LY,dfdqd_prev_out_LZ,
   // minv boolean
   input  minv,
   // minvm_in
   input  signed[(WIDTH-1):0]
      minvm_in_C1_R1, minvm_in_C1_R2, minvm_in_C1_R3, minvm_in_C1_R4, minvm_in_C1_R5, minvm_in_C1_R6, minvm_in_C1_R7,
      minvm_in_C2_R1, minvm_in_C2_R2, minvm_in_C2_R3, minvm_in_C2_R4, minvm_in_C2_R5, minvm_in_C2_R6, minvm_in_C2_R7,
      minvm_in_C3_R1, minvm_in_C3_R2, minvm_in_C3_R3, minvm_in_C3_R4, minvm_in_C3_R5, minvm_in_C3_R6, minvm_in_C3_R7,
      minvm_in_C4_R1, minvm_in_C4_R2, minvm_in_C4_R3, minvm_in_C4_R4, minvm_in_C4_R5, minvm_in_C4_R6, minvm_in_C4_R7,
      minvm_in_C5_R1, minvm_in_C5_R2, minvm_in_C5_R3, minvm_in_C5_R4, minvm_in_C5_R5, minvm_in_C5_R6, minvm_in_C5_R7,
      minvm_in_C6_R1, minvm_in_C6_R2, minvm_in_C6_R3, minvm_in_C6_R4, minvm_in_C6_R5, minvm_in_C6_R6, minvm_in_C6_R7,
      minvm_in_C7_R1, minvm_in_C7_R2, minvm_in_C7_R3, minvm_in_C7_R4, minvm_in_C7_R5, minvm_in_C7_R6, minvm_in_C7_R7,
   // tau_vec_in
   input  signed[(WIDTH-1):0]
       tau_vec_in_R1, tau_vec_in_R2, tau_vec_in_R3, tau_vec_in_R4, tau_vec_in_R5, tau_vec_in_R6, tau_vec_in_R7,
   // minv_vec_out
   output signed[(WIDTH-1):0]
       minv_vec_out_R1, minv_vec_out_R2, minv_vec_out_R3, minv_vec_out_R4, minv_vec_out_R5, minv_vec_out_R6, minv_vec_out_R7
   );
   // internal wires and state
   wire signed[(WIDTH-1):0]
      xform_AX_AX,xform_AX_AY,xform_AX_AZ,
      xform_AY_AX,xform_AY_AY,xform_AY_AZ,
                 xform_AZ_AY,xform_AZ_AZ,
      xform_LX_AX,xform_LX_AY,xform_LX_AZ,
      xform_LY_AX,xform_LY_AY,xform_LY_AZ,
      xform_LZ_AX                      ;
   wire signed[(WIDTH-1):0]
      lprev_dfi_dqd_updated_AX,lprev_dfi_dqd_updated_AY,lprev_dfi_dqd_updated_AZ,lprev_dfi_dqd_updated_LX,lprev_dfi_dqd_updated_LY,lprev_dfi_dqd_updated_LZ;
   wire signed[(WIDTH-1):0]
      xtdot_xform_in_AX_AX, xtdot_xform_in_AX_AY, xtdot_xform_in_AX_AZ, xtdot_minvm_in_C1_R4, xtdot_minvm_in_C1_R5, xtdot_minvm_in_C1_R6, xtdot_minvm_in_C1_R7,
      xtdot_xform_in_AY_AX, xtdot_xform_in_AY_AY, xtdot_xform_in_AY_AZ, xtdot_minvm_in_C2_R4, xtdot_minvm_in_C2_R5, xtdot_minvm_in_C2_R6, xtdot_minvm_in_C2_R7,
      xtdot_minvm_in_C3_R1, xtdot_xform_in_AZ_AY, xtdot_xform_in_AZ_AZ, xtdot_minvm_in_C3_R4, xtdot_minvm_in_C3_R5, xtdot_minvm_in_C3_R6, xtdot_minvm_in_C3_R7,
      xtdot_xform_in_LX_AX, xtdot_xform_in_LX_AY, xtdot_xform_in_LX_AZ, xtdot_xform_in_LX_LX, xtdot_xform_in_LX_LY, xtdot_xform_in_LX_LZ, xtdot_minvm_in_C4_R7,
      xtdot_xform_in_LY_AX, xtdot_xform_in_LY_AY, xtdot_xform_in_LY_AZ, xtdot_xform_in_LY_LX, xtdot_xform_in_LY_LY, xtdot_xform_in_LY_LZ, xtdot_minvm_in_C5_R7,
      xtdot_xform_in_LZ_AX, xtdot_minvm_in_C6_R2, xtdot_minvm_in_C6_R3, xtdot_minvm_in_C6_R4, xtdot_xform_in_LZ_LY, xtdot_xform_in_LZ_LZ, xtdot_minvm_in_C6_R7,
      xtdot_minvm_in_C7_R1, xtdot_minvm_in_C7_R2, xtdot_minvm_in_C7_R3, xtdot_minvm_in_C7_R4, xtdot_minvm_in_C7_R5, xtdot_minvm_in_C7_R6, xtdot_minvm_in_C7_R7;
   wire signed[(WIDTH-1):0]
      xtdot_vec_in_AX, xtdot_vec_in_AY, xtdot_vec_in_AZ, xtdot_vec_in_LX, xtdot_vec_in_LY, xtdot_vec_in_LZ, xtdot_vec_in_C7;
   wire signed[(WIDTH-1):0]
      xtdot_vec_out_AX, xtdot_vec_out_AY, xtdot_vec_out_AZ, xtdot_vec_out_LX, xtdot_vec_out_LY, xtdot_vec_out_LZ, xtdot_vec_out_C7;
   // xform generation
   xgens7#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      xgens_unit(
      // link_in
      .link_in(link_in),
      // sin(q) and cos(q)
      .sinq_in(sinq_in),.cosq_in(cosq_in),
      // xform_out
      .xform_out_AX_AX(xform_AX_AX),.xform_out_AX_AY(xform_AX_AY),.xform_out_AX_AZ(xform_AX_AZ),
      .xform_out_AY_AX(xform_AY_AX),.xform_out_AY_AY(xform_AY_AY),.xform_out_AY_AZ(xform_AY_AZ),
                                   .xform_out_AZ_AY(xform_AZ_AY),.xform_out_AZ_AZ(xform_AZ_AZ),
      .xform_out_LX_AX(xform_LX_AX),.xform_out_LX_AY(xform_LX_AY),.xform_out_LX_AZ(xform_LX_AZ),
      .xform_out_LY_AX(xform_LY_AX),.xform_out_LY_AY(xform_LY_AY),.xform_out_LY_AZ(xform_LY_AZ),
      .xform_out_LZ_AX(xform_LZ_AX)                                                          
      );

   // output dtau/dqd
   assign dtau_dqd_out = dfdqd_curr_in_AZ;
   // xtdotminv input muxes
   assign xtdot_xform_in_AX_AX = (minv) ? minvm_in_C1_R1 : xform_AX_AX;
   assign xtdot_xform_in_AX_AY = (minv) ? minvm_in_C1_R2 : xform_AX_AY;
   assign xtdot_xform_in_AX_AZ = (minv) ? minvm_in_C1_R3 : xform_AX_AZ;
   assign xtdot_minvm_in_C1_R4 = (minv) ? minvm_in_C1_R4 : 0;
   assign xtdot_minvm_in_C1_R5 = (minv) ? minvm_in_C1_R5 : 0;
   assign xtdot_minvm_in_C1_R6 = (minv) ? minvm_in_C1_R6 : 0;
   assign xtdot_minvm_in_C1_R7 = (minv) ? minvm_in_C1_R7 : 0;

   assign xtdot_xform_in_AY_AX = (minv) ? minvm_in_C2_R1 : xform_AY_AX;
   assign xtdot_xform_in_AY_AY = (minv) ? minvm_in_C2_R2 : xform_AY_AY;
   assign xtdot_xform_in_AY_AZ = (minv) ? minvm_in_C2_R3 : xform_AY_AZ;
   assign xtdot_minvm_in_C2_R4 = (minv) ? minvm_in_C2_R4 : 0;
   assign xtdot_minvm_in_C2_R5 = (minv) ? minvm_in_C2_R5 : 0;
   assign xtdot_minvm_in_C2_R6 = (minv) ? minvm_in_C2_R6 : 0;
   assign xtdot_minvm_in_C2_R7 = (minv) ? minvm_in_C2_R7 : 0;

   assign xtdot_minvm_in_C3_R1 = (minv) ? minvm_in_C3_R1 : 0;
   assign xtdot_xform_in_AZ_AY = (minv) ? minvm_in_C3_R2 : xform_AZ_AY;
   assign xtdot_xform_in_AZ_AZ = (minv) ? minvm_in_C3_R3 : xform_AZ_AZ;
   assign xtdot_minvm_in_C3_R4 = (minv) ? minvm_in_C3_R4 : 0;
   assign xtdot_minvm_in_C3_R5 = (minv) ? minvm_in_C3_R5 : 0;
   assign xtdot_minvm_in_C3_R6 = (minv) ? minvm_in_C3_R6 : 0;
   assign xtdot_minvm_in_C3_R7 = (minv) ? minvm_in_C3_R7 : 0;

   assign xtdot_xform_in_LX_AX = (minv) ? minvm_in_C4_R1 : xform_LX_AX;
   assign xtdot_xform_in_LX_AY = (minv) ? minvm_in_C4_R2 : xform_LX_AY;
   assign xtdot_xform_in_LX_AZ = (minv) ? minvm_in_C4_R3 : xform_LX_AZ;
   assign xtdot_xform_in_LX_LX = (minv) ? minvm_in_C4_R4 : xform_AX_AX;
   assign xtdot_xform_in_LX_LY = (minv) ? minvm_in_C4_R5 : xform_AX_AY;
   assign xtdot_xform_in_LX_LZ = (minv) ? minvm_in_C4_R6 : xform_AX_AZ;
   assign xtdot_minvm_in_C4_R7 = (minv) ? minvm_in_C4_R7 : 0;

   assign xtdot_xform_in_LY_AX = (minv) ? minvm_in_C5_R1 : xform_LY_AX;
   assign xtdot_xform_in_LY_AY = (minv) ? minvm_in_C5_R2 : xform_LY_AY;
   assign xtdot_xform_in_LY_AZ = (minv) ? minvm_in_C5_R3 : xform_LY_AZ;
   assign xtdot_xform_in_LY_LX = (minv) ? minvm_in_C5_R4 : xform_AY_AX;
   assign xtdot_xform_in_LY_LY = (minv) ? minvm_in_C5_R5 : xform_AY_AY;
   assign xtdot_xform_in_LY_LZ = (minv) ? minvm_in_C5_R6 : xform_AY_AZ;
   assign xtdot_minvm_in_C5_R7 = (minv) ? minvm_in_C5_R7 : 0;

   assign xtdot_xform_in_LZ_AX = (minv) ? minvm_in_C6_R1 : xform_LZ_AX;
   assign xtdot_minvm_in_C6_R2 = (minv) ? minvm_in_C6_R2 : 0;
   assign xtdot_minvm_in_C6_R3 = (minv) ? minvm_in_C6_R3 : 0;
   assign xtdot_minvm_in_C6_R4 = (minv) ? minvm_in_C6_R4 : 0;
   assign xtdot_xform_in_LZ_LY = (minv) ? minvm_in_C6_R5 : xform_AZ_AY;
   assign xtdot_xform_in_LZ_LZ = (minv) ? minvm_in_C6_R6 : xform_AZ_AZ;
   assign xtdot_minvm_in_C6_R7 = (minv) ? minvm_in_C6_R7 : 0;

   assign xtdot_minvm_in_C7_R1 = (minv) ? minvm_in_C7_R1 : 0;
   assign xtdot_minvm_in_C7_R2 = (minv) ? minvm_in_C7_R2 : 0;
   assign xtdot_minvm_in_C7_R3 = (minv) ? minvm_in_C7_R3 : 0;
   assign xtdot_minvm_in_C7_R4 = (minv) ? minvm_in_C7_R4 : 0;
   assign xtdot_minvm_in_C7_R5 = (minv) ? minvm_in_C7_R5 : 0;
   assign xtdot_minvm_in_C7_R6 = (minv) ? minvm_in_C7_R6 : 0;
   assign xtdot_minvm_in_C7_R7 = (minv) ? minvm_in_C7_R7 : 0;


   assign xtdot_vec_in_AX = (minv) ? tau_vec_in_R1 : dfdqd_curr_in_AX;
   assign xtdot_vec_in_AY = (minv) ? tau_vec_in_R2 : dfdqd_curr_in_AY;
   assign xtdot_vec_in_AZ = (minv) ? tau_vec_in_R3 : dfdqd_curr_in_AZ;
   assign xtdot_vec_in_LX = (minv) ? tau_vec_in_R4 : dfdqd_curr_in_LX;
   assign xtdot_vec_in_LY = (minv) ? tau_vec_in_R5 : dfdqd_curr_in_LY;
   assign xtdot_vec_in_LZ = (minv) ? tau_vec_in_R6 : dfdqd_curr_in_LZ;
   assign xtdot_vec_in_C7 = (minv) ? tau_vec_in_R7 : 0;

   // update df/dqd or minv matrix multiplication
   xtdotminv#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      xtdotminv_unit(
      // minv boolean
      .minv(minv),
      // xform_in, 23 values
      .xform_in_AX_AX(xtdot_xform_in_AX_AX), .xform_in_AX_AY(xtdot_xform_in_AX_AY), .xform_in_AX_AZ(xtdot_xform_in_AX_AZ), .minvm_in_C1_R4(xtdot_minvm_in_C1_R4), .minvm_in_C1_R5(xtdot_minvm_in_C1_R5), .minvm_in_C1_R6(xtdot_minvm_in_C1_R6), .minvm_in_C1_R7(xtdot_minvm_in_C1_R7),
      .xform_in_AY_AX(xtdot_xform_in_AY_AX), .xform_in_AY_AY(xtdot_xform_in_AY_AY), .xform_in_AY_AZ(xtdot_xform_in_AY_AZ), .minvm_in_C2_R4(xtdot_minvm_in_C2_R4), .minvm_in_C2_R5(xtdot_minvm_in_C2_R5), .minvm_in_C2_R6(xtdot_minvm_in_C2_R6), .minvm_in_C2_R7(xtdot_minvm_in_C2_R7),
      .minvm_in_C3_R1(xtdot_minvm_in_C3_R1), .xform_in_AZ_AY(xtdot_xform_in_AZ_AY), .xform_in_AZ_AZ(xtdot_xform_in_AZ_AZ), .minvm_in_C3_R4(xtdot_minvm_in_C3_R4), .minvm_in_C3_R5(xtdot_minvm_in_C3_R5), .minvm_in_C3_R6(xtdot_minvm_in_C3_R6), .minvm_in_C3_R7(xtdot_minvm_in_C3_R7),
      .xform_in_LX_AX(xtdot_xform_in_LX_AX), .xform_in_LX_AY(xtdot_xform_in_LX_AY), .xform_in_LX_AZ(xtdot_xform_in_LX_AZ), .xform_in_LX_LX(xtdot_xform_in_LX_LX), .xform_in_LX_LY(xtdot_xform_in_LX_LY), .xform_in_LX_LZ(xtdot_xform_in_LX_LZ), .minvm_in_C4_R7(xtdot_minvm_in_C4_R7),
      .xform_in_LY_AX(xtdot_xform_in_LY_AX), .xform_in_LY_AY(xtdot_xform_in_LY_AY), .xform_in_LY_AZ(xtdot_xform_in_LY_AZ), .xform_in_LY_LX(xtdot_xform_in_LY_LX), .xform_in_LY_LY(xtdot_xform_in_LY_LY), .xform_in_LY_LZ(xtdot_xform_in_LY_LZ), .minvm_in_C5_R7(xtdot_minvm_in_C5_R7),
      .xform_in_LZ_AX(xtdot_xform_in_LZ_AX), .minvm_in_C6_R2(xtdot_minvm_in_C6_R2), .minvm_in_C6_R3(xtdot_minvm_in_C6_R3), .minvm_in_C6_R4(xtdot_minvm_in_C6_R4), .xform_in_LZ_LY(xtdot_xform_in_LZ_LY), .xform_in_LZ_LZ(xtdot_xform_in_LZ_LZ), .minvm_in_C6_R7(xtdot_minvm_in_C6_R7),
      .minvm_in_C7_R1(xtdot_minvm_in_C7_R1), .minvm_in_C7_R2(xtdot_minvm_in_C7_R2), .minvm_in_C7_R3(xtdot_minvm_in_C7_R3), .minvm_in_C7_R4(xtdot_minvm_in_C7_R4), .minvm_in_C7_R5(xtdot_minvm_in_C7_R5), .minvm_in_C7_R6(xtdot_minvm_in_C7_R6), .minvm_in_C7_R7(xtdot_minvm_in_C7_R7),
      // vec_in, 6 values
      .vec_in_AX(xtdot_vec_in_AX), .vec_in_AY(xtdot_vec_in_AY), .vec_in_AZ(xtdot_vec_in_AZ), .vec_in_LX(xtdot_vec_in_LX), .vec_in_LY(xtdot_vec_in_LY), .vec_in_LZ(xtdot_vec_in_LZ), .vec_in_C7(xtdot_vec_in_C7),
      // xtvec_out, 6 values
      .xtvec_out_AX(xtdot_vec_out_AX), .xtvec_out_AY(xtdot_vec_out_AY), .xtvec_out_AZ(xtdot_vec_out_AZ), .xtvec_out_LX(xtdot_vec_out_LX), .xtvec_out_LY(xtdot_vec_out_LY), .xtvec_out_LZ(xtdot_vec_out_LZ), .xtvec_out_C7(xtdot_vec_out_C7)
      );
   // (6 adds)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_dfdqd_AX(.a_in(dfdqd_prev_in_AX),.b_in(xtdot_vec_out_AX),.sum_out(lprev_dfi_dqd_updated_AX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_dfdqd_AY(.a_in(dfdqd_prev_in_AY),.b_in(xtdot_vec_out_AY),.sum_out(lprev_dfi_dqd_updated_AY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_dfdqd_AZ(.a_in(dfdqd_prev_in_AZ),.b_in(xtdot_vec_out_AZ),.sum_out(lprev_dfi_dqd_updated_AZ));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_dfdqd_LX(.a_in(dfdqd_prev_in_LX),.b_in(xtdot_vec_out_LX),.sum_out(lprev_dfi_dqd_updated_LX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_dfdqd_LY(.a_in(dfdqd_prev_in_LY),.b_in(xtdot_vec_out_LY),.sum_out(lprev_dfi_dqd_updated_LY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_dfdqd_LZ(.a_in(dfdqd_prev_in_LZ),.b_in(xtdot_vec_out_LZ),.sum_out(lprev_dfi_dqd_updated_LZ));

   // output df/dqd updates
   assign dfdqd_prev_out_AX = lprev_dfi_dqd_updated_AX;
   assign dfdqd_prev_out_AY = lprev_dfi_dqd_updated_AY;
   assign dfdqd_prev_out_AZ = lprev_dfi_dqd_updated_AZ;
   assign dfdqd_prev_out_LX = lprev_dfi_dqd_updated_LX;
   assign dfdqd_prev_out_LY = lprev_dfi_dqd_updated_LY;
   assign dfdqd_prev_out_LZ = lprev_dfi_dqd_updated_LZ;
   // minv outputs
   assign minv_vec_out_R1 = xtdot_vec_out_AX;
   assign minv_vec_out_R2 = xtdot_vec_out_AY;
   assign minv_vec_out_R3 = xtdot_vec_out_AZ;
   assign minv_vec_out_R4 = xtdot_vec_out_LX;
   assign minv_vec_out_R5 = xtdot_vec_out_LY;
   assign minv_vec_out_R6 = xtdot_vec_out_LZ;
   assign minv_vec_out_R7 = xtdot_vec_out_C7;
endmodule
