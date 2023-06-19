`timescale 1ns / 1ps

// Testbench for Backward Pass Row Unit with RNEA and Minv

//------------------------------------------------------------------------------
// bproc Testbench
//------------------------------------------------------------------------------
module tb_bproc();

   parameter WIDTH = 32;
   parameter DECIMAL_BITS = 16;

   // clock
   reg  clk;
   // reset
   reg  reset;
   // get_data
   reg  get_data;
   // sin(q) and cos(q)
   reg  signed[(WIDTH-1):0]
      sinq_prev_in,cosq_prev_in;
   // f_prev_vec_in
   reg  signed[(WIDTH-1):0]
      f_prev_vec_in_AX,f_prev_vec_in_AY,f_prev_vec_in_AZ,f_prev_vec_in_LX,f_prev_vec_in_LY,f_prev_vec_in_LZ;
   // minv_prev_vec_in
   reg  signed[(WIDTH-1):0]
      minv_prev_vec_in_C1,minv_prev_vec_in_C2,minv_prev_vec_in_C3,minv_prev_vec_in_C4,minv_prev_vec_in_C5,minv_prev_vec_in_C6,minv_prev_vec_in_C7, minv_prev_vec_in_C8;
   // dfidq_prev_mat_in
   reg  signed[(WIDTH-1):0]
      dfidq_prev_mat_in_AX_J1,dfidq_prev_mat_in_AX_J2,dfidq_prev_mat_in_AX_J3, dfidq_prev_mat_in_AX_J4,dfidq_prev_mat_in_AX_J5,dfidq_prev_mat_in_AX_J6,dfidq_prev_mat_in_AX_J7,dfidq_prev_mat_in_AX_J8,
      dfidq_prev_mat_in_AY_J1,dfidq_prev_mat_in_AY_J2,dfidq_prev_mat_in_AY_J3, dfidq_prev_mat_in_AY_J4,dfidq_prev_mat_in_AY_J5,dfidq_prev_mat_in_AY_J6,dfidq_prev_mat_in_AY_J7,dfidq_prev_mat_in_AY_J8,
      dfidq_prev_mat_in_AZ_J1,dfidq_prev_mat_in_AZ_J2,dfidq_prev_mat_in_AZ_J3, dfidq_prev_mat_in_AZ_J4,dfidq_prev_mat_in_AZ_J5,dfidq_prev_mat_in_AZ_J6,dfidq_prev_mat_in_AZ_J7,dfidq_prev_mat_in_AZ_J8,
      dfidq_prev_mat_in_LX_J1,dfidq_prev_mat_in_LX_J2,dfidq_prev_mat_in_LX_J3, dfidq_prev_mat_in_LX_J4,dfidq_prev_mat_in_LX_J5,dfidq_prev_mat_in_LX_J6,dfidq_prev_mat_in_LX_J7,dfidq_prev_mat_in_LX_J8,
      dfidq_prev_mat_in_LY_J1,dfidq_prev_mat_in_LY_J2,dfidq_prev_mat_in_LY_J3, dfidq_prev_mat_in_LY_J4,dfidq_prev_mat_in_LY_J5,dfidq_prev_mat_in_LY_J6,dfidq_prev_mat_in_LY_J7,dfidq_prev_mat_in_LY_J8,
      dfidq_prev_mat_in_LZ_J1,dfidq_prev_mat_in_LZ_J2,dfidq_prev_mat_in_LZ_J3, dfidq_prev_mat_in_LZ_J4,dfidq_prev_mat_in_LZ_J5,dfidq_prev_mat_in_LZ_J6,dfidq_prev_mat_in_LZ_J7,dfidq_prev_mat_in_LZ_J8;
   // dfidqd_prev_mat_in
   reg  signed[(WIDTH-1):0]
      dfidqd_prev_mat_in_AX_J1,dfidqd_prev_mat_in_AX_J2,dfidqd_prev_mat_in_AX_J3, dfidqd_prev_mat_in_AX_J4,dfidqd_prev_mat_in_AX_J5,dfidqd_prev_mat_in_AX_J6,dfidqd_prev_mat_in_AX_J7,dfidqd_prev_mat_in_AX_J8,
      dfidqd_prev_mat_in_AY_J1,dfidqd_prev_mat_in_AY_J2,dfidqd_prev_mat_in_AY_J3, dfidqd_prev_mat_in_AY_J4,dfidqd_prev_mat_in_AY_J5,dfidqd_prev_mat_in_AY_J6,dfidqd_prev_mat_in_AY_J7,dfidqd_prev_mat_in_AY_J8,
      dfidqd_prev_mat_in_AZ_J1,dfidqd_prev_mat_in_AZ_J2,dfidqd_prev_mat_in_AZ_J3, dfidqd_prev_mat_in_AZ_J4,dfidqd_prev_mat_in_AZ_J5,dfidqd_prev_mat_in_AZ_J6,dfidqd_prev_mat_in_AZ_J7,dfidqd_prev_mat_in_AZ_J8,
      dfidqd_prev_mat_in_LX_J1,dfidqd_prev_mat_in_LX_J2,dfidqd_prev_mat_in_LX_J3, dfidqd_prev_mat_in_LX_J4,dfidqd_prev_mat_in_LX_J5,dfidqd_prev_mat_in_LX_J6,dfidqd_prev_mat_in_LX_J7,dfidqd_prev_mat_in_LX_J8,
      dfidqd_prev_mat_in_LY_J1,dfidqd_prev_mat_in_LY_J2,dfidqd_prev_mat_in_LY_J3, dfidqd_prev_mat_in_LY_J4,dfidqd_prev_mat_in_LY_J5,dfidqd_prev_mat_in_LY_J6,dfidqd_prev_mat_in_LY_J7,dfidqd_prev_mat_in_LY_J8,
      dfidqd_prev_mat_in_LZ_J1,dfidqd_prev_mat_in_LZ_J2,dfidqd_prev_mat_in_LZ_J3, dfidqd_prev_mat_in_LZ_J4,dfidqd_prev_mat_in_LZ_J5,dfidqd_prev_mat_in_LZ_J6,dfidqd_prev_mat_in_LZ_J7,dfidqd_prev_mat_in_LZ_J8;
   // output ready
   wire output_ready;
   // dummy output
   wire dummy_output;
//    // dtauidq_curr_vec_out
//    wire signed[(WIDTH-1):0]
//       dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7;
//    // dtauidqd_curr_vec_out
//    wire signed[(WIDTH-1):0]
//       dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7;
   // minv_dtaudq_out
   wire signed[(WIDTH-1):0]
      minv_dtaudq_out_R1_C1,minv_dtaudq_out_R1_C2,minv_dtaudq_out_R1_C3,minv_dtaudq_out_R1_C4,minv_dtaudq_out_R1_C5,minv_dtaudq_out_R1_C6,minv_dtaudq_out_R1_C7,minv_dtaudq_out_R1_C8,
      minv_dtaudq_out_R2_C1,minv_dtaudq_out_R2_C2,minv_dtaudq_out_R2_C3,minv_dtaudq_out_R2_C4,minv_dtaudq_out_R2_C5,minv_dtaudq_out_R2_C6,minv_dtaudq_out_R2_C7,minv_dtaudq_out_R2_C8,
      minv_dtaudq_out_R3_C1,minv_dtaudq_out_R3_C2,minv_dtaudq_out_R3_C3,minv_dtaudq_out_R3_C4,minv_dtaudq_out_R3_C5,minv_dtaudq_out_R3_C6,minv_dtaudq_out_R3_C7,minv_dtaudq_out_R3_C8,
      minv_dtaudq_out_R4_C1,minv_dtaudq_out_R4_C2,minv_dtaudq_out_R4_C3,minv_dtaudq_out_R4_C4,minv_dtaudq_out_R4_C5,minv_dtaudq_out_R4_C6,minv_dtaudq_out_R4_C7,minv_dtaudq_out_R4_C8,
      minv_dtaudq_out_R5_C1,minv_dtaudq_out_R5_C2,minv_dtaudq_out_R5_C3,minv_dtaudq_out_R5_C4,minv_dtaudq_out_R5_C5,minv_dtaudq_out_R5_C6,minv_dtaudq_out_R5_C7,minv_dtaudq_out_R5_C8,
      minv_dtaudq_out_R6_C1,minv_dtaudq_out_R6_C2,minv_dtaudq_out_R6_C3,minv_dtaudq_out_R6_C4,minv_dtaudq_out_R6_C5,minv_dtaudq_out_R6_C6,minv_dtaudq_out_R6_C7,minv_dtaudq_out_R6_C8,
      minv_dtaudq_out_R7_C1,minv_dtaudq_out_R7_C2,minv_dtaudq_out_R7_C3,minv_dtaudq_out_R7_C4,minv_dtaudq_out_R7_C5,minv_dtaudq_out_R7_C6,minv_dtaudq_out_R7_C7,minv_dtaudq_out_R7_C8,
      minv_dtaudq_out_R8_C1,minv_dtaudq_out_R8_C2,minv_dtaudq_out_R8_C3,minv_dtaudq_out_R8_C4,minv_dtaudq_out_R8_C5,minv_dtaudq_out_R8_C6,minv_dtaudq_out_R8_C7,minv_dtaudq_out_R8_C8;
   // minv_dtaudqd_out
   wire signed[(WIDTH-1):0]
      minv_dtaudqd_out_R1_C1,minv_dtaudqd_out_R1_C2,minv_dtaudqd_out_R1_C3,minv_dtaudqd_out_R1_C4,minv_dtaudqd_out_R1_C5,minv_dtaudqd_out_R1_C6,minv_dtaudqd_out_R1_C7,minv_dtaudqd_out_R1_C8,
      minv_dtaudqd_out_R2_C1,minv_dtaudqd_out_R2_C2,minv_dtaudqd_out_R2_C3,minv_dtaudqd_out_R2_C4,minv_dtaudqd_out_R2_C5,minv_dtaudqd_out_R2_C6,minv_dtaudqd_out_R2_C7,minv_dtaudqd_out_R2_C8,
      minv_dtaudqd_out_R3_C1,minv_dtaudqd_out_R3_C2,minv_dtaudqd_out_R3_C3,minv_dtaudqd_out_R3_C4,minv_dtaudqd_out_R3_C5,minv_dtaudqd_out_R3_C6,minv_dtaudqd_out_R3_C7,minv_dtaudqd_out_R3_C8,
      minv_dtaudqd_out_R4_C1,minv_dtaudqd_out_R4_C2,minv_dtaudqd_out_R4_C3,minv_dtaudqd_out_R4_C4,minv_dtaudqd_out_R4_C5,minv_dtaudqd_out_R4_C6,minv_dtaudqd_out_R4_C7,minv_dtaudqd_out_R4_C8,
      minv_dtaudqd_out_R5_C1,minv_dtaudqd_out_R5_C2,minv_dtaudqd_out_R5_C3,minv_dtaudqd_out_R5_C4,minv_dtaudqd_out_R5_C5,minv_dtaudqd_out_R5_C6,minv_dtaudqd_out_R5_C7,minv_dtaudqd_out_R5_C8,
      minv_dtaudqd_out_R6_C1,minv_dtaudqd_out_R6_C2,minv_dtaudqd_out_R6_C3,minv_dtaudqd_out_R6_C4,minv_dtaudqd_out_R6_C5,minv_dtaudqd_out_R6_C6,minv_dtaudqd_out_R6_C7,minv_dtaudqd_out_R6_C8,
      minv_dtaudqd_out_R7_C1,minv_dtaudqd_out_R7_C2,minv_dtaudqd_out_R7_C3,minv_dtaudqd_out_R7_C4,minv_dtaudqd_out_R7_C5,minv_dtaudqd_out_R7_C6,minv_dtaudqd_out_R7_C7,minv_dtaudqd_out_R7_C8,
      minv_dtaudqd_out_R8_C1,minv_dtaudqd_out_R8_C2,minv_dtaudqd_out_R8_C3,minv_dtaudqd_out_R8_C4,minv_dtaudqd_out_R8_C5,minv_dtaudqd_out_R8_C6,minv_dtaudqd_out_R8_C7,minv_dtaudqd_out_R8_C8;

   bproc#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // get data
      .get_data(get_data),
      // sin(q) and cos(q)
      .sinq_prev_in(sinq_prev_in),.cosq_prev_in(cosq_prev_in),
      // f_prev_vec_in
      .f_prev_vec_in_AX(f_prev_vec_in_AX),.f_prev_vec_in_AY(f_prev_vec_in_AY),.f_prev_vec_in_AZ(f_prev_vec_in_AZ),.f_prev_vec_in_LX(f_prev_vec_in_LX),.f_prev_vec_in_LY(f_prev_vec_in_LY),.f_prev_vec_in_LZ(f_prev_vec_in_LZ),
      // minv_prev_vec_in
      .minv_prev_vec_in_C1(minv_prev_vec_in_C1),.minv_prev_vec_in_C2(minv_prev_vec_in_C2),.minv_prev_vec_in_C3(minv_prev_vec_in_C3),.minv_prev_vec_in_C4(minv_prev_vec_in_C4),.minv_prev_vec_in_C5(minv_prev_vec_in_C5),.minv_prev_vec_in_C6(minv_prev_vec_in_C6),.minv_prev_vec_in_C7(minv_prev_vec_in_C7),.minv_prev_vec_in_C8(minv_prev_vec_in_C8),
      // dfidq_prev_mat_in
      .dfidq_prev_mat_in_AX_J1(dfidq_prev_mat_in_AX_J1),.dfidq_prev_mat_in_AX_J2(dfidq_prev_mat_in_AX_J2),.dfidq_prev_mat_in_AX_J3(dfidq_prev_mat_in_AX_J3),.dfidq_prev_mat_in_AX_J4(dfidq_prev_mat_in_AX_J4),.dfidq_prev_mat_in_AX_J5(dfidq_prev_mat_in_AX_J5),.dfidq_prev_mat_in_AX_J6(dfidq_prev_mat_in_AX_J6),.dfidq_prev_mat_in_AX_J7(dfidq_prev_mat_in_AX_J7),.dfidq_prev_mat_in_AX_J8(dfidq_prev_mat_in_AX_J8),
      .dfidq_prev_mat_in_AY_J1(dfidq_prev_mat_in_AY_J1),.dfidq_prev_mat_in_AY_J2(dfidq_prev_mat_in_AY_J2),.dfidq_prev_mat_in_AY_J3(dfidq_prev_mat_in_AY_J3),.dfidq_prev_mat_in_AY_J4(dfidq_prev_mat_in_AY_J4),.dfidq_prev_mat_in_AY_J5(dfidq_prev_mat_in_AY_J5),.dfidq_prev_mat_in_AY_J6(dfidq_prev_mat_in_AY_J6),.dfidq_prev_mat_in_AY_J7(dfidq_prev_mat_in_AY_J7),.dfidq_prev_mat_in_AY_J8(dfidq_prev_mat_in_AY_J8),
      .dfidq_prev_mat_in_AZ_J1(dfidq_prev_mat_in_AZ_J1),.dfidq_prev_mat_in_AZ_J2(dfidq_prev_mat_in_AZ_J2),.dfidq_prev_mat_in_AZ_J3(dfidq_prev_mat_in_AZ_J3),.dfidq_prev_mat_in_AZ_J4(dfidq_prev_mat_in_AZ_J4),.dfidq_prev_mat_in_AZ_J5(dfidq_prev_mat_in_AZ_J5),.dfidq_prev_mat_in_AZ_J6(dfidq_prev_mat_in_AZ_J6),.dfidq_prev_mat_in_AZ_J7(dfidq_prev_mat_in_AZ_J7),.dfidq_prev_mat_in_AZ_J8(dfidq_prev_mat_in_AZ_J8),
      .dfidq_prev_mat_in_LX_J1(dfidq_prev_mat_in_LX_J1),.dfidq_prev_mat_in_LX_J2(dfidq_prev_mat_in_LX_J2),.dfidq_prev_mat_in_LX_J3(dfidq_prev_mat_in_LX_J3),.dfidq_prev_mat_in_LX_J4(dfidq_prev_mat_in_LX_J4),.dfidq_prev_mat_in_LX_J5(dfidq_prev_mat_in_LX_J5),.dfidq_prev_mat_in_LX_J6(dfidq_prev_mat_in_LX_J6),.dfidq_prev_mat_in_LX_J7(dfidq_prev_mat_in_LX_J7),.dfidq_prev_mat_in_LX_J8(dfidq_prev_mat_in_LX_J8),
      .dfidq_prev_mat_in_LY_J1(dfidq_prev_mat_in_LY_J1),.dfidq_prev_mat_in_LY_J2(dfidq_prev_mat_in_LY_J2),.dfidq_prev_mat_in_LY_J3(dfidq_prev_mat_in_LY_J3),.dfidq_prev_mat_in_LY_J4(dfidq_prev_mat_in_LY_J4),.dfidq_prev_mat_in_LY_J5(dfidq_prev_mat_in_LY_J5),.dfidq_prev_mat_in_LY_J6(dfidq_prev_mat_in_LY_J6),.dfidq_prev_mat_in_LY_J7(dfidq_prev_mat_in_LY_J7),.dfidq_prev_mat_in_LY_J8(dfidq_prev_mat_in_LY_J8),
      .dfidq_prev_mat_in_LZ_J1(dfidq_prev_mat_in_LZ_J1),.dfidq_prev_mat_in_LZ_J2(dfidq_prev_mat_in_LZ_J2),.dfidq_prev_mat_in_LZ_J3(dfidq_prev_mat_in_LZ_J3),.dfidq_prev_mat_in_LZ_J4(dfidq_prev_mat_in_LZ_J4),.dfidq_prev_mat_in_LZ_J5(dfidq_prev_mat_in_LZ_J5),.dfidq_prev_mat_in_LZ_J6(dfidq_prev_mat_in_LZ_J6),.dfidq_prev_mat_in_LZ_J7(dfidq_prev_mat_in_LZ_J7),.dfidq_prev_mat_in_LZ_J8(dfidq_prev_mat_in_LZ_J8),
      // dfidqd_prev_mat_in
      .dfidqd_prev_mat_in_AX_J1(dfidqd_prev_mat_in_AX_J1),.dfidqd_prev_mat_in_AX_J2(dfidqd_prev_mat_in_AX_J2),.dfidqd_prev_mat_in_AX_J3(dfidqd_prev_mat_in_AX_J3),.dfidqd_prev_mat_in_AX_J4(dfidqd_prev_mat_in_AX_J4),.dfidqd_prev_mat_in_AX_J5(dfidqd_prev_mat_in_AX_J5),.dfidqd_prev_mat_in_AX_J6(dfidqd_prev_mat_in_AX_J6),.dfidqd_prev_mat_in_AX_J7(dfidqd_prev_mat_in_AX_J7),.dfidqd_prev_mat_in_AX_J8(dfidqd_prev_mat_in_AX_J8),
      .dfidqd_prev_mat_in_AY_J1(dfidqd_prev_mat_in_AY_J1),.dfidqd_prev_mat_in_AY_J2(dfidqd_prev_mat_in_AY_J2),.dfidqd_prev_mat_in_AY_J3(dfidqd_prev_mat_in_AY_J3),.dfidqd_prev_mat_in_AY_J4(dfidqd_prev_mat_in_AY_J4),.dfidqd_prev_mat_in_AY_J5(dfidqd_prev_mat_in_AY_J5),.dfidqd_prev_mat_in_AY_J6(dfidqd_prev_mat_in_AY_J6),.dfidqd_prev_mat_in_AY_J7(dfidqd_prev_mat_in_AY_J7),.dfidqd_prev_mat_in_AY_J8(dfidqd_prev_mat_in_AY_J8),
      .dfidqd_prev_mat_in_AZ_J1(dfidqd_prev_mat_in_AZ_J1),.dfidqd_prev_mat_in_AZ_J2(dfidqd_prev_mat_in_AZ_J2),.dfidqd_prev_mat_in_AZ_J3(dfidqd_prev_mat_in_AZ_J3),.dfidqd_prev_mat_in_AZ_J4(dfidqd_prev_mat_in_AZ_J4),.dfidqd_prev_mat_in_AZ_J5(dfidqd_prev_mat_in_AZ_J5),.dfidqd_prev_mat_in_AZ_J6(dfidqd_prev_mat_in_AZ_J6),.dfidqd_prev_mat_in_AZ_J7(dfidqd_prev_mat_in_AZ_J7),.dfidqd_prev_mat_in_AZ_J8(dfidqd_prev_mat_in_AZ_J8),
      .dfidqd_prev_mat_in_LX_J1(dfidqd_prev_mat_in_LX_J1),.dfidqd_prev_mat_in_LX_J2(dfidqd_prev_mat_in_LX_J2),.dfidqd_prev_mat_in_LX_J3(dfidqd_prev_mat_in_LX_J3),.dfidqd_prev_mat_in_LX_J4(dfidqd_prev_mat_in_LX_J4),.dfidqd_prev_mat_in_LX_J5(dfidqd_prev_mat_in_LX_J5),.dfidqd_prev_mat_in_LX_J6(dfidqd_prev_mat_in_LX_J6),.dfidqd_prev_mat_in_LX_J7(dfidqd_prev_mat_in_LX_J7),.dfidqd_prev_mat_in_LX_J8(dfidqd_prev_mat_in_LX_J8),
      .dfidqd_prev_mat_in_LY_J1(dfidqd_prev_mat_in_LY_J1),.dfidqd_prev_mat_in_LY_J2(dfidqd_prev_mat_in_LY_J2),.dfidqd_prev_mat_in_LY_J3(dfidqd_prev_mat_in_LY_J3),.dfidqd_prev_mat_in_LY_J4(dfidqd_prev_mat_in_LY_J4),.dfidqd_prev_mat_in_LY_J5(dfidqd_prev_mat_in_LY_J5),.dfidqd_prev_mat_in_LY_J6(dfidqd_prev_mat_in_LY_J6),.dfidqd_prev_mat_in_LY_J7(dfidqd_prev_mat_in_LY_J7),.dfidqd_prev_mat_in_LY_J8(dfidqd_prev_mat_in_LY_J8),
      .dfidqd_prev_mat_in_LZ_J1(dfidqd_prev_mat_in_LZ_J1),.dfidqd_prev_mat_in_LZ_J2(dfidqd_prev_mat_in_LZ_J2),.dfidqd_prev_mat_in_LZ_J3(dfidqd_prev_mat_in_LZ_J3),.dfidqd_prev_mat_in_LZ_J4(dfidqd_prev_mat_in_LZ_J4),.dfidqd_prev_mat_in_LZ_J5(dfidqd_prev_mat_in_LZ_J5),.dfidqd_prev_mat_in_LZ_J6(dfidqd_prev_mat_in_LZ_J6),.dfidqd_prev_mat_in_LZ_J7(dfidqd_prev_mat_in_LZ_J7),.dfidqd_prev_mat_in_LZ_J8(dfidqd_prev_mat_in_LZ_J8),
      // output ready
      .output_ready(output_ready),
      // dummy output
      .dummy_output(dummy_output),
//       // dtauidq_curr_vec_out
//       .dtauidq_curr_vec_out_J1(dtauidq_curr_vec_out_J1),.dtauidq_curr_vec_out_J2(dtauidq_curr_vec_out_J2),.dtauidq_curr_vec_out_J3(dtauidq_curr_vec_out_J3),.dtauidq_curr_vec_out_J4(dtauidq_curr_vec_out_J4),.dtauidq_curr_vec_out_J5(dtauidq_curr_vec_out_J5),.dtauidq_curr_vec_out_J6(dtauidq_curr_vec_out_J6),.dtauidq_curr_vec_out_J7(dtauidq_curr_vec_out_J7),
//       // dtauidqd_curr_vec_out
//       .dtauidqd_curr_vec_out_J1(dtauidqd_curr_vec_out_J1),.dtauidqd_curr_vec_out_J2(dtauidqd_curr_vec_out_J2),.dtauidqd_curr_vec_out_J3(dtauidqd_curr_vec_out_J3),.dtauidqd_curr_vec_out_J4(dtauidqd_curr_vec_out_J4),.dtauidqd_curr_vec_out_J5(dtauidqd_curr_vec_out_J5),.dtauidqd_curr_vec_out_J6(dtauidqd_curr_vec_out_J6),.dtauidqd_curr_vec_out_J7(dtauidqd_curr_vec_out_J7),
      // minv_dtaudq_out
      .minv_dtaudq_out_R1_C1(minv_dtaudq_out_R1_C1),.minv_dtaudq_out_R1_C2(minv_dtaudq_out_R1_C2),.minv_dtaudq_out_R1_C3(minv_dtaudq_out_R1_C3),.minv_dtaudq_out_R1_C4(minv_dtaudq_out_R1_C4),.minv_dtaudq_out_R1_C5(minv_dtaudq_out_R1_C5),.minv_dtaudq_out_R1_C6(minv_dtaudq_out_R1_C6),.minv_dtaudq_out_R1_C7(minv_dtaudq_out_R1_C7),.minv_dtaudq_out_R1_C8(minv_dtaudq_out_R1_C8),
      .minv_dtaudq_out_R2_C1(minv_dtaudq_out_R2_C1),.minv_dtaudq_out_R2_C2(minv_dtaudq_out_R2_C2),.minv_dtaudq_out_R2_C3(minv_dtaudq_out_R2_C3),.minv_dtaudq_out_R2_C4(minv_dtaudq_out_R2_C4),.minv_dtaudq_out_R2_C5(minv_dtaudq_out_R2_C5),.minv_dtaudq_out_R2_C6(minv_dtaudq_out_R2_C6),.minv_dtaudq_out_R2_C7(minv_dtaudq_out_R2_C7),.minv_dtaudq_out_R2_C8(minv_dtaudq_out_R2_C8),
      .minv_dtaudq_out_R3_C1(minv_dtaudq_out_R3_C1),.minv_dtaudq_out_R3_C2(minv_dtaudq_out_R3_C2),.minv_dtaudq_out_R3_C3(minv_dtaudq_out_R3_C3),.minv_dtaudq_out_R3_C4(minv_dtaudq_out_R3_C4),.minv_dtaudq_out_R3_C5(minv_dtaudq_out_R3_C5),.minv_dtaudq_out_R3_C6(minv_dtaudq_out_R3_C6),.minv_dtaudq_out_R3_C7(minv_dtaudq_out_R3_C7),.minv_dtaudq_out_R3_C8(minv_dtaudq_out_R3_C8),
      .minv_dtaudq_out_R4_C1(minv_dtaudq_out_R4_C1),.minv_dtaudq_out_R4_C2(minv_dtaudq_out_R4_C2),.minv_dtaudq_out_R4_C3(minv_dtaudq_out_R4_C3),.minv_dtaudq_out_R4_C4(minv_dtaudq_out_R4_C4),.minv_dtaudq_out_R4_C5(minv_dtaudq_out_R4_C5),.minv_dtaudq_out_R4_C6(minv_dtaudq_out_R4_C6),.minv_dtaudq_out_R4_C7(minv_dtaudq_out_R4_C7),.minv_dtaudq_out_R4_C8(minv_dtaudq_out_R4_C8),
      .minv_dtaudq_out_R5_C1(minv_dtaudq_out_R5_C1),.minv_dtaudq_out_R5_C2(minv_dtaudq_out_R5_C2),.minv_dtaudq_out_R5_C3(minv_dtaudq_out_R5_C3),.minv_dtaudq_out_R5_C4(minv_dtaudq_out_R5_C4),.minv_dtaudq_out_R5_C5(minv_dtaudq_out_R5_C5),.minv_dtaudq_out_R5_C6(minv_dtaudq_out_R5_C6),.minv_dtaudq_out_R5_C7(minv_dtaudq_out_R5_C7),.minv_dtaudq_out_R5_C8(minv_dtaudq_out_R5_C8),
      .minv_dtaudq_out_R6_C1(minv_dtaudq_out_R6_C1),.minv_dtaudq_out_R6_C2(minv_dtaudq_out_R6_C2),.minv_dtaudq_out_R6_C3(minv_dtaudq_out_R6_C3),.minv_dtaudq_out_R6_C4(minv_dtaudq_out_R6_C4),.minv_dtaudq_out_R6_C5(minv_dtaudq_out_R6_C5),.minv_dtaudq_out_R6_C6(minv_dtaudq_out_R6_C6),.minv_dtaudq_out_R6_C7(minv_dtaudq_out_R6_C7),.minv_dtaudq_out_R6_C8(minv_dtaudq_out_R6_C8),
      .minv_dtaudq_out_R7_C1(minv_dtaudq_out_R7_C1),.minv_dtaudq_out_R7_C2(minv_dtaudq_out_R7_C2),.minv_dtaudq_out_R7_C3(minv_dtaudq_out_R7_C3),.minv_dtaudq_out_R7_C4(minv_dtaudq_out_R7_C4),.minv_dtaudq_out_R7_C5(minv_dtaudq_out_R7_C5),.minv_dtaudq_out_R7_C6(minv_dtaudq_out_R7_C6),.minv_dtaudq_out_R7_C7(minv_dtaudq_out_R7_C7),.minv_dtaudq_out_R7_C8(minv_dtaudq_out_R7_C8),
      .minv_dtaudq_out_R8_C1(minv_dtaudq_out_R8_C1),.minv_dtaudq_out_R8_C2(minv_dtaudq_out_R8_C2),.minv_dtaudq_out_R8_C3(minv_dtaudq_out_R8_C3),.minv_dtaudq_out_R8_C4(minv_dtaudq_out_R8_C4),.minv_dtaudq_out_R8_C5(minv_dtaudq_out_R8_C5),.minv_dtaudq_out_R8_C6(minv_dtaudq_out_R8_C6),.minv_dtaudq_out_R8_C7(minv_dtaudq_out_R8_C7),.minv_dtaudq_out_R8_C8(minv_dtaudq_out_R8_C8),
      // minv_dtaudqd_out
      .minv_dtaudqd_out_R1_C1(minv_dtaudqd_out_R1_C1),.minv_dtaudqd_out_R1_C2(minv_dtaudqd_out_R1_C2),.minv_dtaudqd_out_R1_C3(minv_dtaudqd_out_R1_C3),.minv_dtaudqd_out_R1_C4(minv_dtaudqd_out_R1_C4),.minv_dtaudqd_out_R1_C5(minv_dtaudqd_out_R1_C5),.minv_dtaudqd_out_R1_C6(minv_dtaudqd_out_R1_C6),.minv_dtaudqd_out_R1_C7(minv_dtaudqd_out_R1_C7),.minv_dtaudqd_out_R1_C8(minv_dtaudqd_out_R1_C8),
      .minv_dtaudqd_out_R2_C1(minv_dtaudqd_out_R2_C1),.minv_dtaudqd_out_R2_C2(minv_dtaudqd_out_R2_C2),.minv_dtaudqd_out_R2_C3(minv_dtaudqd_out_R2_C3),.minv_dtaudqd_out_R2_C4(minv_dtaudqd_out_R2_C4),.minv_dtaudqd_out_R2_C5(minv_dtaudqd_out_R2_C5),.minv_dtaudqd_out_R2_C6(minv_dtaudqd_out_R2_C6),.minv_dtaudqd_out_R2_C7(minv_dtaudqd_out_R2_C7),.minv_dtaudqd_out_R2_C8(minv_dtaudqd_out_R2_C8),
      .minv_dtaudqd_out_R3_C1(minv_dtaudqd_out_R3_C1),.minv_dtaudqd_out_R3_C2(minv_dtaudqd_out_R3_C2),.minv_dtaudqd_out_R3_C3(minv_dtaudqd_out_R3_C3),.minv_dtaudqd_out_R3_C4(minv_dtaudqd_out_R3_C4),.minv_dtaudqd_out_R3_C5(minv_dtaudqd_out_R3_C5),.minv_dtaudqd_out_R3_C6(minv_dtaudqd_out_R3_C6),.minv_dtaudqd_out_R3_C7(minv_dtaudqd_out_R3_C7),.minv_dtaudqd_out_R3_C8(minv_dtaudqd_out_R3_C8),
      .minv_dtaudqd_out_R4_C1(minv_dtaudqd_out_R4_C1),.minv_dtaudqd_out_R4_C2(minv_dtaudqd_out_R4_C2),.minv_dtaudqd_out_R4_C3(minv_dtaudqd_out_R4_C3),.minv_dtaudqd_out_R4_C4(minv_dtaudqd_out_R4_C4),.minv_dtaudqd_out_R4_C5(minv_dtaudqd_out_R4_C5),.minv_dtaudqd_out_R4_C6(minv_dtaudqd_out_R4_C6),.minv_dtaudqd_out_R4_C7(minv_dtaudqd_out_R4_C7),.minv_dtaudqd_out_R4_C8(minv_dtaudqd_out_R4_C8),
      .minv_dtaudqd_out_R5_C1(minv_dtaudqd_out_R5_C1),.minv_dtaudqd_out_R5_C2(minv_dtaudqd_out_R5_C2),.minv_dtaudqd_out_R5_C3(minv_dtaudqd_out_R5_C3),.minv_dtaudqd_out_R5_C4(minv_dtaudqd_out_R5_C4),.minv_dtaudqd_out_R5_C5(minv_dtaudqd_out_R5_C5),.minv_dtaudqd_out_R5_C6(minv_dtaudqd_out_R5_C6),.minv_dtaudqd_out_R5_C7(minv_dtaudqd_out_R5_C7),.minv_dtaudqd_out_R5_C8(minv_dtaudqd_out_R5_C8),
      .minv_dtaudqd_out_R6_C1(minv_dtaudqd_out_R6_C1),.minv_dtaudqd_out_R6_C2(minv_dtaudqd_out_R6_C2),.minv_dtaudqd_out_R6_C3(minv_dtaudqd_out_R6_C3),.minv_dtaudqd_out_R6_C4(minv_dtaudqd_out_R6_C4),.minv_dtaudqd_out_R6_C5(minv_dtaudqd_out_R6_C5),.minv_dtaudqd_out_R6_C6(minv_dtaudqd_out_R6_C6),.minv_dtaudqd_out_R6_C7(minv_dtaudqd_out_R6_C7),.minv_dtaudqd_out_R6_C8(minv_dtaudqd_out_R6_C8),
      .minv_dtaudqd_out_R7_C1(minv_dtaudqd_out_R7_C1),.minv_dtaudqd_out_R7_C2(minv_dtaudqd_out_R7_C2),.minv_dtaudqd_out_R7_C3(minv_dtaudqd_out_R7_C3),.minv_dtaudqd_out_R7_C4(minv_dtaudqd_out_R7_C4),.minv_dtaudqd_out_R7_C5(minv_dtaudqd_out_R7_C5),.minv_dtaudqd_out_R7_C6(minv_dtaudqd_out_R7_C6),.minv_dtaudqd_out_R7_C7(minv_dtaudqd_out_R7_C7),.minv_dtaudqd_out_R7_C8(minv_dtaudqd_out_R7_C8),
      .minv_dtaudqd_out_R8_C1(minv_dtaudqd_out_R8_C1),.minv_dtaudqd_out_R8_C2(minv_dtaudqd_out_R8_C2),.minv_dtaudqd_out_R8_C3(minv_dtaudqd_out_R8_C3),.minv_dtaudqd_out_R8_C4(minv_dtaudqd_out_R8_C4),.minv_dtaudqd_out_R8_C5(minv_dtaudqd_out_R8_C5),.minv_dtaudqd_out_R8_C6(minv_dtaudqd_out_R8_C6),.minv_dtaudqd_out_R8_C7(minv_dtaudqd_out_R8_C7),.minv_dtaudqd_out_R8_C8(minv_dtaudqd_out_R8_C8)
      );

   initial begin
      #10;
      // initialize
      clk = 0;
      // inputs
      sinq_prev_in = 0; cosq_prev_in = 0;
      f_prev_vec_in_AX = 32'd0; f_prev_vec_in_AY = 32'd0; f_prev_vec_in_AZ = 32'd0; f_prev_vec_in_LX = 32'd0; f_prev_vec_in_LY = 32'd0; f_prev_vec_in_LZ = 32'd0;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      // control
      get_data = 0;
      //------------------------------------------------------------------------
      // reset
      reset = 1;
      #10;
      reset = 0;
      #5
      // start
      clk = 1;
      #5;
      clk = 0;
      #5;
      // set values
      //------------------------------------------------------------------------
      $display ("// Knot 1 Link 8 Init");
      //------------------------------------------------------------------------
      // Link 8 Inputs
      // 8
      sinq_prev_in = 32'd49084; cosq_prev_in = -32'd43424;
      f_prev_vec_in_AX = 32'd8044; f_prev_vec_in_AY = -32'd6533; f_prev_vec_in_AZ = 32'd5043; f_prev_vec_in_LX = -32'd120315; f_prev_vec_in_LY = -32'd133594; f_prev_vec_in_LZ = -32'd13832;
      // 8
      // minv_prev_vec_in_C1 = 0.321418; minv_prev_vec_in_C2 = 0.35137; minv_prev_vec_in_C3 = 0.188062; minv_prev_vec_in_C4 = 2.85474; minv_prev_vec_in_C5 = 98.7838; minv_prev_vec_in_C6 = 4.79672; minv_prev_vec_in_C7 = -1095.04;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Ignore Outputs
      //------------------------------------------------------------------------
      // Link 7 Inputs
      // 7
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      //7 
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Ignore Outputs
      //------------------------------------------------------------------------
      // Link 7 Inputs
      // 6
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      // 6
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 7 Outputs
      $display ("// Knot 1 Link 7 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 6 Inputs
      // 5
      sinq_prev_in = -32'd48758; cosq_prev_in = 32'd43790;
      f_prev_vec_in_AX = -32'd5305; f_prev_vec_in_AY = 32'd5863; f_prev_vec_in_AZ = 32'd7667; f_prev_vec_in_LX = 32'd36574; f_prev_vec_in_LY = 32'd9374; f_prev_vec_in_LZ = -32'd25154;
      // 5
      // minv_prev_vec_in_C1 = -1.01435; minv_prev_vec_in_C2 = -0.293887; minv_prev_vec_in_C3 = 39.287; minv_prev_vec_in_C4 = -1.61578; minv_prev_vec_in_C5 = -141.751; minv_prev_vec_in_C6 = -3.12746; minv_prev_vec_in_C7 = 98.7838;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 6 Outputs
      $display ("// Knot 1 Link 6 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -779, 4114, 1696, -2923, 77, 0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -332, -3145, 676, 3527, -418, -0, 41);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 5 Inputs
      // 4
      sinq_prev_in = -32'd685; cosq_prev_in = 32'd65532;
      f_prev_vec_in_AX = -32'd8244; f_prev_vec_in_AY = 32'd621; f_prev_vec_in_AZ = 32'd6514; f_prev_vec_in_LX = 32'd21590; f_prev_vec_in_LY = -32'd11080; f_prev_vec_in_LZ = -32'd133497;
      // 4
      // minv_prev_vec_in_C1 = 2.9516; minv_prev_vec_in_C2 = -1.87147; minv_prev_vec_in_C3 = -3.07484; minv_prev_vec_in_C4 = -6.6787; minv_prev_vec_in_C5 = -1.61578; minv_prev_vec_in_C6 = -5.4728; minv_prev_vec_in_C7 = 2.85474;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 5 Outputs
      $display ("// Knot 1 Link 5 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -1359, 3026, 2756, 365, 1553, -0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -910, -3013, 289, 1378, 72, 418, 6);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 4 Inputs
      // 3
      sinq_prev_in = -32'd36876; cosq_prev_in = 32'd54177;
      f_prev_vec_in_AX = -32'd19396; f_prev_vec_in_AY = 32'd14507; f_prev_vec_in_AZ = -32'd2366; f_prev_vec_in_LX = 32'd70323; f_prev_vec_in_LY = 32'd80557; f_prev_vec_in_LZ = -32'd22634;
      // 3
      // minv_prev_vec_in_C1 = 3.24692; minv_prev_vec_in_C2 = -0.649599; minv_prev_vec_in_C3 = -41.9993; minv_prev_vec_in_C4 = -3.07484; minv_prev_vec_in_C5 = 39.287; minv_prev_vec_in_C6 = -0.691391; minv_prev_vec_in_C7 = 0.188062;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 4 Outputs
      $display ("// Knot 1 Link 4 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, 63224, -120585, -111588, -108248, 2207, 0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 62401, 78973, -998, -329, -2212, -4266, -41);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 3 Inputs
      // 2
      sinq_prev_in = 32'd24454; cosq_prev_in = 32'd60803;
      f_prev_vec_in_AX = 32'd2226; f_prev_vec_in_AY = -32'd184; f_prev_vec_in_AZ = 32'd6473; f_prev_vec_in_LX = -32'd20115; f_prev_vec_in_LY = -32'd5700; f_prev_vec_in_LZ = 32'd54;
      // 2
      // minv_prev_vec_in_C1 = 0.832568; minv_prev_vec_in_C2 = -0.81964; minv_prev_vec_in_C3 = -0.649599; minv_prev_vec_in_C4 = -1.87147; minv_prev_vec_in_C5 = -0.293887; minv_prev_vec_in_C6 = -1.37315; minv_prev_vec_in_C7 = 0.35137;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 3 Outputs
      $display ("// Knot 1 Link 3 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2815, 3863, 65192, 1562, 1956, -0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -2181, -2958, -75, 248, 116, 456, 6);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 2 Inputs
      // 1
      sinq_prev_in = 32'd19197; cosq_prev_in = 32'd62661;
      f_prev_vec_in_AX = -32'd944; f_prev_vec_in_AY = 32'd634; f_prev_vec_in_AZ = 32'd1038; f_prev_vec_in_LX = 32'd5280; f_prev_vec_in_LY = 32'd7863; f_prev_vec_in_LZ = 32'd0;
      // 1
      // minv_prev_vec_in_C1 = -3.3084; minv_prev_vec_in_C2 = 0.832568; minv_prev_vec_in_C3 = 3.24692; minv_prev_vec_in_C4 = 2.9516; minv_prev_vec_in_C5 = -1.01435; minv_prev_vec_in_C6 = -0.394646; minv_prev_vec_in_C7 = 0.321418;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 2 Outputs
      $display ("// Knot 1 Link 2 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -143598, 152229, 257173, 261022, 36327, -1);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -189170, -832, -38846, -163910, 9181, 9470, 24);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 1 Inputs
      // 0
      sinq_prev_in = 0; cosq_prev_in = 0;
      f_prev_vec_in_AX = 32'd0; f_prev_vec_in_AY = 32'd0; f_prev_vec_in_AZ = 32'd0; f_prev_vec_in_LX = 32'd0; f_prev_vec_in_LY = 32'd0; f_prev_vec_in_LZ = 32'd0;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1; // Hold for 3 cycles for Link 1 Outputs
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1; // 2
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1; // 1
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 1 Outputs
      $display ("// Knot 1 Link 1 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, 42647, -137408, 36, 24777, 27210, -0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 15627, 150456, -23071, -90085, 1629, 782, -9);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      // Minv*dtau/dq
      $display ("minv_dtaudq_ref = ");
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,-81502,233272,92865,-178327,-48664,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,38170,-22551,-47388,12133,-13242,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,102711,-220471,-2454756,194477,36675,-0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,-12620,75598,50095,317983,-12648,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,-22151,-848,2277094,84361,-230226,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,-64051,-11625,-3801,580245,-90470,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,43279,-12170,-14532,-104344,679222,-0);
      $display ("minv_dtaudq_out = ");
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R1_C1,minv_dtaudq_out_R1_C2,minv_dtaudq_out_R1_C3,minv_dtaudq_out_R1_C4,minv_dtaudq_out_R1_C5,minv_dtaudq_out_R1_C6,minv_dtaudq_out_R1_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R2_C1,minv_dtaudq_out_R2_C2,minv_dtaudq_out_R2_C3,minv_dtaudq_out_R2_C4,minv_dtaudq_out_R2_C5,minv_dtaudq_out_R2_C6,minv_dtaudq_out_R2_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R3_C1,minv_dtaudq_out_R3_C2,minv_dtaudq_out_R3_C3,minv_dtaudq_out_R3_C4,minv_dtaudq_out_R3_C5,minv_dtaudq_out_R3_C6,minv_dtaudq_out_R3_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R4_C1,minv_dtaudq_out_R4_C2,minv_dtaudq_out_R4_C3,minv_dtaudq_out_R4_C4,minv_dtaudq_out_R4_C5,minv_dtaudq_out_R4_C6,minv_dtaudq_out_R4_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R5_C1,minv_dtaudq_out_R5_C2,minv_dtaudq_out_R5_C3,minv_dtaudq_out_R5_C4,minv_dtaudq_out_R5_C5,minv_dtaudq_out_R5_C6,minv_dtaudq_out_R5_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R6_C1,minv_dtaudq_out_R6_C2,minv_dtaudq_out_R6_C3,minv_dtaudq_out_R6_C4,minv_dtaudq_out_R6_C5,minv_dtaudq_out_R6_C6,minv_dtaudq_out_R6_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R7_C1,minv_dtaudq_out_R7_C2,minv_dtaudq_out_R7_C3,minv_dtaudq_out_R7_C4,minv_dtaudq_out_R7_C5,minv_dtaudq_out_R7_C6,minv_dtaudq_out_R7_C7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // Minv*dtau/dqd
      $display ("minv_dtaudqd_ref = ");
      $display ("%d,%d,%d,%d,%d,%d,%d", -31047,-270683,40236,158637,-3817,-6252,-76);
      $display ("%d,%d,%d,%d,%d,%d,%d", 53418,-14732,13531,54576,-1558,440,-12);
      $display ("%d,%d,%d,%d,%d,%d,%d", 37833,254266,-32572,-143688,4399,6772,46);
      $display ("%d,%d,%d,%d,%d,%d,%d", -6635,-50697,7306,20961,4154,10885,-47);
      $display ("%d,%d,%d,%d,%d,%d,%d", -17565,37904,-10400,-49809,-7455,-42082,-678);
      $display ("%d,%d,%d,%d,%d,%d,%d", -42853,-93277,-15920,-174332,49751,8219,-4830);
      $display ("%d,%d,%d,%d,%d,%d,%d", 34402,-8424,16342,-9678,27796,77467,675);
      $display ("minv_dtaudqd_out = ");
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R1_C1,minv_dtaudqd_out_R1_C2,minv_dtaudqd_out_R1_C3,minv_dtaudqd_out_R1_C4,minv_dtaudqd_out_R1_C5,minv_dtaudqd_out_R1_C6,minv_dtaudqd_out_R1_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R2_C1,minv_dtaudqd_out_R2_C2,minv_dtaudqd_out_R2_C3,minv_dtaudqd_out_R2_C4,minv_dtaudqd_out_R2_C5,minv_dtaudqd_out_R2_C6,minv_dtaudqd_out_R2_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R3_C1,minv_dtaudqd_out_R3_C2,minv_dtaudqd_out_R3_C3,minv_dtaudqd_out_R3_C4,minv_dtaudqd_out_R3_C5,minv_dtaudqd_out_R3_C6,minv_dtaudqd_out_R3_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R4_C1,minv_dtaudqd_out_R4_C2,minv_dtaudqd_out_R4_C3,minv_dtaudqd_out_R4_C4,minv_dtaudqd_out_R4_C5,minv_dtaudqd_out_R4_C6,minv_dtaudqd_out_R4_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R5_C1,minv_dtaudqd_out_R5_C2,minv_dtaudqd_out_R5_C3,minv_dtaudqd_out_R5_C4,minv_dtaudqd_out_R5_C5,minv_dtaudqd_out_R5_C6,minv_dtaudqd_out_R5_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R6_C1,minv_dtaudqd_out_R6_C2,minv_dtaudqd_out_R6_C3,minv_dtaudqd_out_R6_C4,minv_dtaudqd_out_R6_C5,minv_dtaudqd_out_R6_C6,minv_dtaudqd_out_R6_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R7_C1,minv_dtaudqd_out_R7_C2,minv_dtaudqd_out_R7_C3,minv_dtaudqd_out_R7_C4,minv_dtaudqd_out_R7_C5,minv_dtaudqd_out_R7_C6,minv_dtaudqd_out_R7_C7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
//       // Extra Clock Cycles
//       get_data = 0;
//       clk = 1;
//       #5;
//       clk = 0;
//       #5;
//       get_data = 0;
//       clk = 1;
//       #5;
//       clk = 0;
//       #5;
//       get_data = 0;
//       clk = 1;
//       #5;
//       clk = 0;
//       #5;
      //------------------------------------------------------------------------
      // set values
      //------------------------------------------------------------------------
      $display ("// Knot 2 Link 8 Init");
      //------------------------------------------------------------------------
      // Link 8 Inputs
      // 7
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      //7 
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Ignore Outputs
      //------------------------------------------------------------------------
      // Link 7 Inputs
      // 6
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      // 6
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 7 Outputs
      $display ("// Knot 1 Link 7 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 6 Inputs
      // 5
      sinq_prev_in = -32'd48758; cosq_prev_in = 32'd43790;
      f_prev_vec_in_AX = -32'd5305; f_prev_vec_in_AY = 32'd5863; f_prev_vec_in_AZ = 32'd7667; f_prev_vec_in_LX = 32'd36574; f_prev_vec_in_LY = 32'd9374; f_prev_vec_in_LZ = -32'd25154;
      // 5
      // minv_prev_vec_in_C1 = -1.01435; minv_prev_vec_in_C2 = -0.293887; minv_prev_vec_in_C3 = 39.287; minv_prev_vec_in_C4 = -1.61578; minv_prev_vec_in_C5 = -141.751; minv_prev_vec_in_C6 = -3.12746; minv_prev_vec_in_C7 = 98.7838;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 6 Outputs
      $display ("// Knot 1 Link 6 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -779, 4114, 1696, -2923, 77, 0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -332, -3145, 676, 3527, -418, -0, 41);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 5 Inputs
      // 4
      sinq_prev_in = -32'd685; cosq_prev_in = 32'd65532;
      f_prev_vec_in_AX = -32'd8244; f_prev_vec_in_AY = 32'd621; f_prev_vec_in_AZ = 32'd6514; f_prev_vec_in_LX = 32'd21590; f_prev_vec_in_LY = -32'd11080; f_prev_vec_in_LZ = -32'd133497;
      // 4
      // minv_prev_vec_in_C1 = 2.9516; minv_prev_vec_in_C2 = -1.87147; minv_prev_vec_in_C3 = -3.07484; minv_prev_vec_in_C4 = -6.6787; minv_prev_vec_in_C5 = -1.61578; minv_prev_vec_in_C6 = -5.4728; minv_prev_vec_in_C7 = 2.85474;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 5 Outputs
      $display ("// Knot 1 Link 5 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -1359, 3026, 2756, 365, 1553, -0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -910, -3013, 289, 1378, 72, 418, 6);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 4 Inputs
      // 3
      sinq_prev_in = -32'd36876; cosq_prev_in = 32'd54177;
      f_prev_vec_in_AX = -32'd19396; f_prev_vec_in_AY = 32'd14507; f_prev_vec_in_AZ = -32'd2366; f_prev_vec_in_LX = 32'd70323; f_prev_vec_in_LY = 32'd80557; f_prev_vec_in_LZ = -32'd22634;
      // 3
      // minv_prev_vec_in_C1 = 3.24692; minv_prev_vec_in_C2 = -0.649599; minv_prev_vec_in_C3 = -41.9993; minv_prev_vec_in_C4 = -3.07484; minv_prev_vec_in_C5 = 39.287; minv_prev_vec_in_C6 = -0.691391; minv_prev_vec_in_C7 = 0.188062;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 4 Outputs
      $display ("// Knot 1 Link 4 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, 63224, -120585, -111588, -108248, 2207, 0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 62401, 78973, -998, -329, -2212, -4266, -41);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 3 Inputs
      // 2
      sinq_prev_in = 32'd24454; cosq_prev_in = 32'd60803;
      f_prev_vec_in_AX = 32'd2226; f_prev_vec_in_AY = -32'd184; f_prev_vec_in_AZ = 32'd6473; f_prev_vec_in_LX = -32'd20115; f_prev_vec_in_LY = -32'd5700; f_prev_vec_in_LZ = 32'd54;
      // 2
      // minv_prev_vec_in_C1 = 0.832568; minv_prev_vec_in_C2 = -0.81964; minv_prev_vec_in_C3 = -0.649599; minv_prev_vec_in_C4 = -1.87147; minv_prev_vec_in_C5 = -0.293887; minv_prev_vec_in_C6 = -1.37315; minv_prev_vec_in_C7 = 0.35137;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 3 Outputs
      $display ("// Knot 1 Link 3 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2815, 3863, 65192, 1562, 1956, -0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -2181, -2958, -75, 248, 116, 456, 6);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 2 Inputs
      // 1
      sinq_prev_in = 32'd19197; cosq_prev_in = 32'd62661;
      f_prev_vec_in_AX = -32'd944; f_prev_vec_in_AY = 32'd634; f_prev_vec_in_AZ = 32'd1038; f_prev_vec_in_LX = 32'd5280; f_prev_vec_in_LY = 32'd7863; f_prev_vec_in_LZ = 32'd0;
      // 1
      // minv_prev_vec_in_C1 = -3.3084; minv_prev_vec_in_C2 = 0.832568; minv_prev_vec_in_C3 = 3.24692; minv_prev_vec_in_C4 = 2.9516; minv_prev_vec_in_C5 = -1.01435; minv_prev_vec_in_C6 = -0.394646; minv_prev_vec_in_C7 = 0.321418;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 2 Outputs
      $display ("// Knot 1 Link 2 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -143598, 152229, 257173, 261022, 36327, -1);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -189170, -832, -38846, -163910, 9181, 9470, 24);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 1 Inputs
      // 0
      sinq_prev_in = 0; cosq_prev_in = 0;
      f_prev_vec_in_AX = 32'd0; f_prev_vec_in_AY = 32'd0; f_prev_vec_in_AZ = 32'd0; f_prev_vec_in_LX = 32'd0; f_prev_vec_in_LY = 32'd0; f_prev_vec_in_LZ = 32'd0;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0; minv_prev_vec_in_C8 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0; dfidq_prev_mat_in_AX_J8 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0; dfidq_prev_mat_in_AY_J8 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0; dfidq_prev_mat_in_AZ_J8 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0; dfidq_prev_mat_in_LX_J8 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0; dfidq_prev_mat_in_LY_J8 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0; dfidq_prev_mat_in_LZ_J8 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0; dfidqd_prev_mat_in_AX_J8 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0; dfidqd_prev_mat_in_AY_J8 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0; dfidqd_prev_mat_in_AZ_J8 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0; dfidqd_prev_mat_in_LX_J8 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0; dfidqd_prev_mat_in_LY_J8 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0; dfidqd_prev_mat_in_LZ_J8 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1; // Hold for 3 cycles for Link 1 Outputs
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1; // 2
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1; // 1
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 1 Outputs
      $display ("// Knot 2 Link 1 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, 42647, -137408, 36, 24777, 27210, -0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 15627, 150456, -23071, -90085, 1629, 782, -9);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      // Minv*dtau/dq
      $display ("minv_dtaudq_ref = ");
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,-81502,233272,92865,-178327,-48664,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,38170,-22551,-47388,12133,-13242,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,102711,-220471,-2454756,194477,36675,-0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,-12620,75598,50095,317983,-12648,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,-22151,-848,2277094,84361,-230226,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,-64051,-11625,-3801,580245,-90470,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,43279,-12170,-14532,-104344,679222,-0);
      $display ("minv_dtaudq_out = ");
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R1_C1,minv_dtaudq_out_R1_C2,minv_dtaudq_out_R1_C3,minv_dtaudq_out_R1_C4,minv_dtaudq_out_R1_C5,minv_dtaudq_out_R1_C6,minv_dtaudq_out_R1_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R2_C1,minv_dtaudq_out_R2_C2,minv_dtaudq_out_R2_C3,minv_dtaudq_out_R2_C4,minv_dtaudq_out_R2_C5,minv_dtaudq_out_R2_C6,minv_dtaudq_out_R2_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R3_C1,minv_dtaudq_out_R3_C2,minv_dtaudq_out_R3_C3,minv_dtaudq_out_R3_C4,minv_dtaudq_out_R3_C5,minv_dtaudq_out_R3_C6,minv_dtaudq_out_R3_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R4_C1,minv_dtaudq_out_R4_C2,minv_dtaudq_out_R4_C3,minv_dtaudq_out_R4_C4,minv_dtaudq_out_R4_C5,minv_dtaudq_out_R4_C6,minv_dtaudq_out_R4_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R5_C1,minv_dtaudq_out_R5_C2,minv_dtaudq_out_R5_C3,minv_dtaudq_out_R5_C4,minv_dtaudq_out_R5_C5,minv_dtaudq_out_R5_C6,minv_dtaudq_out_R5_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R6_C1,minv_dtaudq_out_R6_C2,minv_dtaudq_out_R6_C3,minv_dtaudq_out_R6_C4,minv_dtaudq_out_R6_C5,minv_dtaudq_out_R6_C6,minv_dtaudq_out_R6_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R7_C1,minv_dtaudq_out_R7_C2,minv_dtaudq_out_R7_C3,minv_dtaudq_out_R7_C4,minv_dtaudq_out_R7_C5,minv_dtaudq_out_R7_C6,minv_dtaudq_out_R7_C7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // Minv*dtau/dqd
      $display ("minv_dtaudqd_ref = ");
      $display ("%d,%d,%d,%d,%d,%d,%d", -31047,-270683,40236,158637,-3817,-6252,-76);
      $display ("%d,%d,%d,%d,%d,%d,%d", 53418,-14732,13531,54576,-1558,440,-12);
      $display ("%d,%d,%d,%d,%d,%d,%d", 37833,254266,-32572,-143688,4399,6772,46);
      $display ("%d,%d,%d,%d,%d,%d,%d", -6635,-50697,7306,20961,4154,10885,-47);
      $display ("%d,%d,%d,%d,%d,%d,%d", -17565,37904,-10400,-49809,-7455,-42082,-678);
      $display ("%d,%d,%d,%d,%d,%d,%d", -42853,-93277,-15920,-174332,49751,8219,-4830);
      $display ("%d,%d,%d,%d,%d,%d,%d", 34402,-8424,16342,-9678,27796,77467,675);
      $display ("minv_dtaudqd_out = ");
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R1_C1,minv_dtaudqd_out_R1_C2,minv_dtaudqd_out_R1_C3,minv_dtaudqd_out_R1_C4,minv_dtaudqd_out_R1_C5,minv_dtaudqd_out_R1_C6,minv_dtaudqd_out_R1_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R2_C1,minv_dtaudqd_out_R2_C2,minv_dtaudqd_out_R2_C3,minv_dtaudqd_out_R2_C4,minv_dtaudqd_out_R2_C5,minv_dtaudqd_out_R2_C6,minv_dtaudqd_out_R2_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R3_C1,minv_dtaudqd_out_R3_C2,minv_dtaudqd_out_R3_C3,minv_dtaudqd_out_R3_C4,minv_dtaudqd_out_R3_C5,minv_dtaudqd_out_R3_C6,minv_dtaudqd_out_R3_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R4_C1,minv_dtaudqd_out_R4_C2,minv_dtaudqd_out_R4_C3,minv_dtaudqd_out_R4_C4,minv_dtaudqd_out_R4_C5,minv_dtaudqd_out_R4_C6,minv_dtaudqd_out_R4_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R5_C1,minv_dtaudqd_out_R5_C2,minv_dtaudqd_out_R5_C3,minv_dtaudqd_out_R5_C4,minv_dtaudqd_out_R5_C5,minv_dtaudqd_out_R5_C6,minv_dtaudqd_out_R5_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R6_C1,minv_dtaudqd_out_R6_C2,minv_dtaudqd_out_R6_C3,minv_dtaudqd_out_R6_C4,minv_dtaudqd_out_R6_C5,minv_dtaudqd_out_R6_C6,minv_dtaudqd_out_R6_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R7_C1,minv_dtaudqd_out_R7_C2,minv_dtaudqd_out_R7_C3,minv_dtaudqd_out_R7_C4,minv_dtaudqd_out_R7_C5,minv_dtaudqd_out_R7_C6,minv_dtaudqd_out_R7_C7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Extra Clock Cycles
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      #1000;
      $stop;
   end

endmodule
