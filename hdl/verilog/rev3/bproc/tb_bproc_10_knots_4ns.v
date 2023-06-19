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
      minv_prev_vec_in_C1,minv_prev_vec_in_C2,minv_prev_vec_in_C3,minv_prev_vec_in_C4,minv_prev_vec_in_C5,minv_prev_vec_in_C6,minv_prev_vec_in_C7;
   // dfidq_prev_mat_in
   reg  signed[(WIDTH-1):0]
      dfidq_prev_mat_in_AX_J1,dfidq_prev_mat_in_AX_J2,dfidq_prev_mat_in_AX_J3, dfidq_prev_mat_in_AX_J4,dfidq_prev_mat_in_AX_J5,dfidq_prev_mat_in_AX_J6,dfidq_prev_mat_in_AX_J7,
      dfidq_prev_mat_in_AY_J1,dfidq_prev_mat_in_AY_J2,dfidq_prev_mat_in_AY_J3, dfidq_prev_mat_in_AY_J4,dfidq_prev_mat_in_AY_J5,dfidq_prev_mat_in_AY_J6,dfidq_prev_mat_in_AY_J7,
      dfidq_prev_mat_in_AZ_J1,dfidq_prev_mat_in_AZ_J2,dfidq_prev_mat_in_AZ_J3, dfidq_prev_mat_in_AZ_J4,dfidq_prev_mat_in_AZ_J5,dfidq_prev_mat_in_AZ_J6,dfidq_prev_mat_in_AZ_J7,
      dfidq_prev_mat_in_LX_J1,dfidq_prev_mat_in_LX_J2,dfidq_prev_mat_in_LX_J3, dfidq_prev_mat_in_LX_J4,dfidq_prev_mat_in_LX_J5,dfidq_prev_mat_in_LX_J6,dfidq_prev_mat_in_LX_J7,
      dfidq_prev_mat_in_LY_J1,dfidq_prev_mat_in_LY_J2,dfidq_prev_mat_in_LY_J3, dfidq_prev_mat_in_LY_J4,dfidq_prev_mat_in_LY_J5,dfidq_prev_mat_in_LY_J6,dfidq_prev_mat_in_LY_J7,
      dfidq_prev_mat_in_LZ_J1,dfidq_prev_mat_in_LZ_J2,dfidq_prev_mat_in_LZ_J3, dfidq_prev_mat_in_LZ_J4,dfidq_prev_mat_in_LZ_J5,dfidq_prev_mat_in_LZ_J6,dfidq_prev_mat_in_LZ_J7;
   // dfidqd_prev_mat_in
   reg  signed[(WIDTH-1):0]
      dfidqd_prev_mat_in_AX_J1,dfidqd_prev_mat_in_AX_J2,dfidqd_prev_mat_in_AX_J3, dfidqd_prev_mat_in_AX_J4,dfidqd_prev_mat_in_AX_J5,dfidqd_prev_mat_in_AX_J6,dfidqd_prev_mat_in_AX_J7,
      dfidqd_prev_mat_in_AY_J1,dfidqd_prev_mat_in_AY_J2,dfidqd_prev_mat_in_AY_J3, dfidqd_prev_mat_in_AY_J4,dfidqd_prev_mat_in_AY_J5,dfidqd_prev_mat_in_AY_J6,dfidqd_prev_mat_in_AY_J7,
      dfidqd_prev_mat_in_AZ_J1,dfidqd_prev_mat_in_AZ_J2,dfidqd_prev_mat_in_AZ_J3, dfidqd_prev_mat_in_AZ_J4,dfidqd_prev_mat_in_AZ_J5,dfidqd_prev_mat_in_AZ_J6,dfidqd_prev_mat_in_AZ_J7,
      dfidqd_prev_mat_in_LX_J1,dfidqd_prev_mat_in_LX_J2,dfidqd_prev_mat_in_LX_J3, dfidqd_prev_mat_in_LX_J4,dfidqd_prev_mat_in_LX_J5,dfidqd_prev_mat_in_LX_J6,dfidqd_prev_mat_in_LX_J7,
      dfidqd_prev_mat_in_LY_J1,dfidqd_prev_mat_in_LY_J2,dfidqd_prev_mat_in_LY_J3, dfidqd_prev_mat_in_LY_J4,dfidqd_prev_mat_in_LY_J5,dfidqd_prev_mat_in_LY_J6,dfidqd_prev_mat_in_LY_J7,
      dfidqd_prev_mat_in_LZ_J1,dfidqd_prev_mat_in_LZ_J2,dfidqd_prev_mat_in_LZ_J3, dfidqd_prev_mat_in_LZ_J4,dfidqd_prev_mat_in_LZ_J5,dfidqd_prev_mat_in_LZ_J6,dfidqd_prev_mat_in_LZ_J7;
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
      minv_dtaudq_out_R1_C1,minv_dtaudq_out_R1_C2,minv_dtaudq_out_R1_C3,minv_dtaudq_out_R1_C4,minv_dtaudq_out_R1_C5,minv_dtaudq_out_R1_C6,minv_dtaudq_out_R1_C7,
      minv_dtaudq_out_R2_C1,minv_dtaudq_out_R2_C2,minv_dtaudq_out_R2_C3,minv_dtaudq_out_R2_C4,minv_dtaudq_out_R2_C5,minv_dtaudq_out_R2_C6,minv_dtaudq_out_R2_C7,
      minv_dtaudq_out_R3_C1,minv_dtaudq_out_R3_C2,minv_dtaudq_out_R3_C3,minv_dtaudq_out_R3_C4,minv_dtaudq_out_R3_C5,minv_dtaudq_out_R3_C6,minv_dtaudq_out_R3_C7,
      minv_dtaudq_out_R4_C1,minv_dtaudq_out_R4_C2,minv_dtaudq_out_R4_C3,minv_dtaudq_out_R4_C4,minv_dtaudq_out_R4_C5,minv_dtaudq_out_R4_C6,minv_dtaudq_out_R4_C7,
      minv_dtaudq_out_R5_C1,minv_dtaudq_out_R5_C2,minv_dtaudq_out_R5_C3,minv_dtaudq_out_R5_C4,minv_dtaudq_out_R5_C5,minv_dtaudq_out_R5_C6,minv_dtaudq_out_R5_C7,
      minv_dtaudq_out_R6_C1,minv_dtaudq_out_R6_C2,minv_dtaudq_out_R6_C3,minv_dtaudq_out_R6_C4,minv_dtaudq_out_R6_C5,minv_dtaudq_out_R6_C6,minv_dtaudq_out_R6_C7,
      minv_dtaudq_out_R7_C1,minv_dtaudq_out_R7_C2,minv_dtaudq_out_R7_C3,minv_dtaudq_out_R7_C4,minv_dtaudq_out_R7_C5,minv_dtaudq_out_R7_C6,minv_dtaudq_out_R7_C7;
   // minv_dtaudqd_out
   wire signed[(WIDTH-1):0]
      minv_dtaudqd_out_R1_C1,minv_dtaudqd_out_R1_C2,minv_dtaudqd_out_R1_C3,minv_dtaudqd_out_R1_C4,minv_dtaudqd_out_R1_C5,minv_dtaudqd_out_R1_C6,minv_dtaudqd_out_R1_C7,
      minv_dtaudqd_out_R2_C1,minv_dtaudqd_out_R2_C2,minv_dtaudqd_out_R2_C3,minv_dtaudqd_out_R2_C4,minv_dtaudqd_out_R2_C5,minv_dtaudqd_out_R2_C6,minv_dtaudqd_out_R2_C7,
      minv_dtaudqd_out_R3_C1,minv_dtaudqd_out_R3_C2,minv_dtaudqd_out_R3_C3,minv_dtaudqd_out_R3_C4,minv_dtaudqd_out_R3_C5,minv_dtaudqd_out_R3_C6,minv_dtaudqd_out_R3_C7,
      minv_dtaudqd_out_R4_C1,minv_dtaudqd_out_R4_C2,minv_dtaudqd_out_R4_C3,minv_dtaudqd_out_R4_C4,minv_dtaudqd_out_R4_C5,minv_dtaudqd_out_R4_C6,minv_dtaudqd_out_R4_C7,
      minv_dtaudqd_out_R5_C1,minv_dtaudqd_out_R5_C2,minv_dtaudqd_out_R5_C3,minv_dtaudqd_out_R5_C4,minv_dtaudqd_out_R5_C5,minv_dtaudqd_out_R5_C6,minv_dtaudqd_out_R5_C7,
      minv_dtaudqd_out_R6_C1,minv_dtaudqd_out_R6_C2,minv_dtaudqd_out_R6_C3,minv_dtaudqd_out_R6_C4,minv_dtaudqd_out_R6_C5,minv_dtaudqd_out_R6_C6,minv_dtaudqd_out_R6_C7,
      minv_dtaudqd_out_R7_C1,minv_dtaudqd_out_R7_C2,minv_dtaudqd_out_R7_C3,minv_dtaudqd_out_R7_C4,minv_dtaudqd_out_R7_C5,minv_dtaudqd_out_R7_C6,minv_dtaudqd_out_R7_C7;

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
      .minv_prev_vec_in_C1(minv_prev_vec_in_C1),.minv_prev_vec_in_C2(minv_prev_vec_in_C2),.minv_prev_vec_in_C3(minv_prev_vec_in_C3),.minv_prev_vec_in_C4(minv_prev_vec_in_C4),.minv_prev_vec_in_C5(minv_prev_vec_in_C5),.minv_prev_vec_in_C6(minv_prev_vec_in_C6),.minv_prev_vec_in_C7(minv_prev_vec_in_C7),
      // dfidq_prev_mat_in
      .dfidq_prev_mat_in_AX_J1(dfidq_prev_mat_in_AX_J1),.dfidq_prev_mat_in_AX_J2(dfidq_prev_mat_in_AX_J2),.dfidq_prev_mat_in_AX_J3(dfidq_prev_mat_in_AX_J3),.dfidq_prev_mat_in_AX_J4(dfidq_prev_mat_in_AX_J4),.dfidq_prev_mat_in_AX_J5(dfidq_prev_mat_in_AX_J5),.dfidq_prev_mat_in_AX_J6(dfidq_prev_mat_in_AX_J6),.dfidq_prev_mat_in_AX_J7(dfidq_prev_mat_in_AX_J7),
      .dfidq_prev_mat_in_AY_J1(dfidq_prev_mat_in_AY_J1),.dfidq_prev_mat_in_AY_J2(dfidq_prev_mat_in_AY_J2),.dfidq_prev_mat_in_AY_J3(dfidq_prev_mat_in_AY_J3),.dfidq_prev_mat_in_AY_J4(dfidq_prev_mat_in_AY_J4),.dfidq_prev_mat_in_AY_J5(dfidq_prev_mat_in_AY_J5),.dfidq_prev_mat_in_AY_J6(dfidq_prev_mat_in_AY_J6),.dfidq_prev_mat_in_AY_J7(dfidq_prev_mat_in_AY_J7),
      .dfidq_prev_mat_in_AZ_J1(dfidq_prev_mat_in_AZ_J1),.dfidq_prev_mat_in_AZ_J2(dfidq_prev_mat_in_AZ_J2),.dfidq_prev_mat_in_AZ_J3(dfidq_prev_mat_in_AZ_J3),.dfidq_prev_mat_in_AZ_J4(dfidq_prev_mat_in_AZ_J4),.dfidq_prev_mat_in_AZ_J5(dfidq_prev_mat_in_AZ_J5),.dfidq_prev_mat_in_AZ_J6(dfidq_prev_mat_in_AZ_J6),.dfidq_prev_mat_in_AZ_J7(dfidq_prev_mat_in_AZ_J7),
      .dfidq_prev_mat_in_LX_J1(dfidq_prev_mat_in_LX_J1),.dfidq_prev_mat_in_LX_J2(dfidq_prev_mat_in_LX_J2),.dfidq_prev_mat_in_LX_J3(dfidq_prev_mat_in_LX_J3),.dfidq_prev_mat_in_LX_J4(dfidq_prev_mat_in_LX_J4),.dfidq_prev_mat_in_LX_J5(dfidq_prev_mat_in_LX_J5),.dfidq_prev_mat_in_LX_J6(dfidq_prev_mat_in_LX_J6),.dfidq_prev_mat_in_LX_J7(dfidq_prev_mat_in_LX_J7),
      .dfidq_prev_mat_in_LY_J1(dfidq_prev_mat_in_LY_J1),.dfidq_prev_mat_in_LY_J2(dfidq_prev_mat_in_LY_J2),.dfidq_prev_mat_in_LY_J3(dfidq_prev_mat_in_LY_J3),.dfidq_prev_mat_in_LY_J4(dfidq_prev_mat_in_LY_J4),.dfidq_prev_mat_in_LY_J5(dfidq_prev_mat_in_LY_J5),.dfidq_prev_mat_in_LY_J6(dfidq_prev_mat_in_LY_J6),.dfidq_prev_mat_in_LY_J7(dfidq_prev_mat_in_LY_J7),
      .dfidq_prev_mat_in_LZ_J1(dfidq_prev_mat_in_LZ_J1),.dfidq_prev_mat_in_LZ_J2(dfidq_prev_mat_in_LZ_J2),.dfidq_prev_mat_in_LZ_J3(dfidq_prev_mat_in_LZ_J3),.dfidq_prev_mat_in_LZ_J4(dfidq_prev_mat_in_LZ_J4),.dfidq_prev_mat_in_LZ_J5(dfidq_prev_mat_in_LZ_J5),.dfidq_prev_mat_in_LZ_J6(dfidq_prev_mat_in_LZ_J6),.dfidq_prev_mat_in_LZ_J7(dfidq_prev_mat_in_LZ_J7),
      // dfidqd_prev_mat_in
      .dfidqd_prev_mat_in_AX_J1(dfidqd_prev_mat_in_AX_J1),.dfidqd_prev_mat_in_AX_J2(dfidqd_prev_mat_in_AX_J2),.dfidqd_prev_mat_in_AX_J3(dfidqd_prev_mat_in_AX_J3),.dfidqd_prev_mat_in_AX_J4(dfidqd_prev_mat_in_AX_J4),.dfidqd_prev_mat_in_AX_J5(dfidqd_prev_mat_in_AX_J5),.dfidqd_prev_mat_in_AX_J6(dfidqd_prev_mat_in_AX_J6),.dfidqd_prev_mat_in_AX_J7(dfidqd_prev_mat_in_AX_J7),
      .dfidqd_prev_mat_in_AY_J1(dfidqd_prev_mat_in_AY_J1),.dfidqd_prev_mat_in_AY_J2(dfidqd_prev_mat_in_AY_J2),.dfidqd_prev_mat_in_AY_J3(dfidqd_prev_mat_in_AY_J3),.dfidqd_prev_mat_in_AY_J4(dfidqd_prev_mat_in_AY_J4),.dfidqd_prev_mat_in_AY_J5(dfidqd_prev_mat_in_AY_J5),.dfidqd_prev_mat_in_AY_J6(dfidqd_prev_mat_in_AY_J6),.dfidqd_prev_mat_in_AY_J7(dfidqd_prev_mat_in_AY_J7),
      .dfidqd_prev_mat_in_AZ_J1(dfidqd_prev_mat_in_AZ_J1),.dfidqd_prev_mat_in_AZ_J2(dfidqd_prev_mat_in_AZ_J2),.dfidqd_prev_mat_in_AZ_J3(dfidqd_prev_mat_in_AZ_J3),.dfidqd_prev_mat_in_AZ_J4(dfidqd_prev_mat_in_AZ_J4),.dfidqd_prev_mat_in_AZ_J5(dfidqd_prev_mat_in_AZ_J5),.dfidqd_prev_mat_in_AZ_J6(dfidqd_prev_mat_in_AZ_J6),.dfidqd_prev_mat_in_AZ_J7(dfidqd_prev_mat_in_AZ_J7),
      .dfidqd_prev_mat_in_LX_J1(dfidqd_prev_mat_in_LX_J1),.dfidqd_prev_mat_in_LX_J2(dfidqd_prev_mat_in_LX_J2),.dfidqd_prev_mat_in_LX_J3(dfidqd_prev_mat_in_LX_J3),.dfidqd_prev_mat_in_LX_J4(dfidqd_prev_mat_in_LX_J4),.dfidqd_prev_mat_in_LX_J5(dfidqd_prev_mat_in_LX_J5),.dfidqd_prev_mat_in_LX_J6(dfidqd_prev_mat_in_LX_J6),.dfidqd_prev_mat_in_LX_J7(dfidqd_prev_mat_in_LX_J7),
      .dfidqd_prev_mat_in_LY_J1(dfidqd_prev_mat_in_LY_J1),.dfidqd_prev_mat_in_LY_J2(dfidqd_prev_mat_in_LY_J2),.dfidqd_prev_mat_in_LY_J3(dfidqd_prev_mat_in_LY_J3),.dfidqd_prev_mat_in_LY_J4(dfidqd_prev_mat_in_LY_J4),.dfidqd_prev_mat_in_LY_J5(dfidqd_prev_mat_in_LY_J5),.dfidqd_prev_mat_in_LY_J6(dfidqd_prev_mat_in_LY_J6),.dfidqd_prev_mat_in_LY_J7(dfidqd_prev_mat_in_LY_J7),
      .dfidqd_prev_mat_in_LZ_J1(dfidqd_prev_mat_in_LZ_J1),.dfidqd_prev_mat_in_LZ_J2(dfidqd_prev_mat_in_LZ_J2),.dfidqd_prev_mat_in_LZ_J3(dfidqd_prev_mat_in_LZ_J3),.dfidqd_prev_mat_in_LZ_J4(dfidqd_prev_mat_in_LZ_J4),.dfidqd_prev_mat_in_LZ_J5(dfidqd_prev_mat_in_LZ_J5),.dfidqd_prev_mat_in_LZ_J6(dfidqd_prev_mat_in_LZ_J6),.dfidqd_prev_mat_in_LZ_J7(dfidqd_prev_mat_in_LZ_J7),
      // output ready
      .output_ready(output_ready),
      // dummy output
      .dummy_output(dummy_output),
//       // dtauidq_curr_vec_out
//       .dtauidq_curr_vec_out_J1(dtauidq_curr_vec_out_J1),.dtauidq_curr_vec_out_J2(dtauidq_curr_vec_out_J2),.dtauidq_curr_vec_out_J3(dtauidq_curr_vec_out_J3),.dtauidq_curr_vec_out_J4(dtauidq_curr_vec_out_J4),.dtauidq_curr_vec_out_J5(dtauidq_curr_vec_out_J5),.dtauidq_curr_vec_out_J6(dtauidq_curr_vec_out_J6),.dtauidq_curr_vec_out_J7(dtauidq_curr_vec_out_J7),
//       // dtauidqd_curr_vec_out
//       .dtauidqd_curr_vec_out_J1(dtauidqd_curr_vec_out_J1),.dtauidqd_curr_vec_out_J2(dtauidqd_curr_vec_out_J2),.dtauidqd_curr_vec_out_J3(dtauidqd_curr_vec_out_J3),.dtauidqd_curr_vec_out_J4(dtauidqd_curr_vec_out_J4),.dtauidqd_curr_vec_out_J5(dtauidqd_curr_vec_out_J5),.dtauidqd_curr_vec_out_J6(dtauidqd_curr_vec_out_J6),.dtauidqd_curr_vec_out_J7(dtauidqd_curr_vec_out_J7),
      // minv_dtaudq_out
      .minv_dtaudq_out_R1_C1(minv_dtaudq_out_R1_C1),.minv_dtaudq_out_R1_C2(minv_dtaudq_out_R1_C2),.minv_dtaudq_out_R1_C3(minv_dtaudq_out_R1_C3),.minv_dtaudq_out_R1_C4(minv_dtaudq_out_R1_C4),.minv_dtaudq_out_R1_C5(minv_dtaudq_out_R1_C5),.minv_dtaudq_out_R1_C6(minv_dtaudq_out_R1_C6),.minv_dtaudq_out_R1_C7(minv_dtaudq_out_R1_C7),
      .minv_dtaudq_out_R2_C1(minv_dtaudq_out_R2_C1),.minv_dtaudq_out_R2_C2(minv_dtaudq_out_R2_C2),.minv_dtaudq_out_R2_C3(minv_dtaudq_out_R2_C3),.minv_dtaudq_out_R2_C4(minv_dtaudq_out_R2_C4),.minv_dtaudq_out_R2_C5(minv_dtaudq_out_R2_C5),.minv_dtaudq_out_R2_C6(minv_dtaudq_out_R2_C6),.minv_dtaudq_out_R2_C7(minv_dtaudq_out_R2_C7),
      .minv_dtaudq_out_R3_C1(minv_dtaudq_out_R3_C1),.minv_dtaudq_out_R3_C2(minv_dtaudq_out_R3_C2),.minv_dtaudq_out_R3_C3(minv_dtaudq_out_R3_C3),.minv_dtaudq_out_R3_C4(minv_dtaudq_out_R3_C4),.minv_dtaudq_out_R3_C5(minv_dtaudq_out_R3_C5),.minv_dtaudq_out_R3_C6(minv_dtaudq_out_R3_C6),.minv_dtaudq_out_R3_C7(minv_dtaudq_out_R3_C7),
      .minv_dtaudq_out_R4_C1(minv_dtaudq_out_R4_C1),.minv_dtaudq_out_R4_C2(minv_dtaudq_out_R4_C2),.minv_dtaudq_out_R4_C3(minv_dtaudq_out_R4_C3),.minv_dtaudq_out_R4_C4(minv_dtaudq_out_R4_C4),.minv_dtaudq_out_R4_C5(minv_dtaudq_out_R4_C5),.minv_dtaudq_out_R4_C6(minv_dtaudq_out_R4_C6),.minv_dtaudq_out_R4_C7(minv_dtaudq_out_R4_C7),
      .minv_dtaudq_out_R5_C1(minv_dtaudq_out_R5_C1),.minv_dtaudq_out_R5_C2(minv_dtaudq_out_R5_C2),.minv_dtaudq_out_R5_C3(minv_dtaudq_out_R5_C3),.minv_dtaudq_out_R5_C4(minv_dtaudq_out_R5_C4),.minv_dtaudq_out_R5_C5(minv_dtaudq_out_R5_C5),.minv_dtaudq_out_R5_C6(minv_dtaudq_out_R5_C6),.minv_dtaudq_out_R5_C7(minv_dtaudq_out_R5_C7),
      .minv_dtaudq_out_R6_C1(minv_dtaudq_out_R6_C1),.minv_dtaudq_out_R6_C2(minv_dtaudq_out_R6_C2),.minv_dtaudq_out_R6_C3(minv_dtaudq_out_R6_C3),.minv_dtaudq_out_R6_C4(minv_dtaudq_out_R6_C4),.minv_dtaudq_out_R6_C5(minv_dtaudq_out_R6_C5),.minv_dtaudq_out_R6_C6(minv_dtaudq_out_R6_C6),.minv_dtaudq_out_R6_C7(minv_dtaudq_out_R6_C7),
      .minv_dtaudq_out_R7_C1(minv_dtaudq_out_R7_C1),.minv_dtaudq_out_R7_C2(minv_dtaudq_out_R7_C2),.minv_dtaudq_out_R7_C3(minv_dtaudq_out_R7_C3),.minv_dtaudq_out_R7_C4(minv_dtaudq_out_R7_C4),.minv_dtaudq_out_R7_C5(minv_dtaudq_out_R7_C5),.minv_dtaudq_out_R7_C6(minv_dtaudq_out_R7_C6),.minv_dtaudq_out_R7_C7(minv_dtaudq_out_R7_C7),
      // minv_dtaudqd_out
      .minv_dtaudqd_out_R1_C1(minv_dtaudqd_out_R1_C1),.minv_dtaudqd_out_R1_C2(minv_dtaudqd_out_R1_C2),.minv_dtaudqd_out_R1_C3(minv_dtaudqd_out_R1_C3),.minv_dtaudqd_out_R1_C4(minv_dtaudqd_out_R1_C4),.minv_dtaudqd_out_R1_C5(minv_dtaudqd_out_R1_C5),.minv_dtaudqd_out_R1_C6(minv_dtaudqd_out_R1_C6),.minv_dtaudqd_out_R1_C7(minv_dtaudqd_out_R1_C7),
      .minv_dtaudqd_out_R2_C1(minv_dtaudqd_out_R2_C1),.minv_dtaudqd_out_R2_C2(minv_dtaudqd_out_R2_C2),.minv_dtaudqd_out_R2_C3(minv_dtaudqd_out_R2_C3),.minv_dtaudqd_out_R2_C4(minv_dtaudqd_out_R2_C4),.minv_dtaudqd_out_R2_C5(minv_dtaudqd_out_R2_C5),.minv_dtaudqd_out_R2_C6(minv_dtaudqd_out_R2_C6),.minv_dtaudqd_out_R2_C7(minv_dtaudqd_out_R2_C7),
      .minv_dtaudqd_out_R3_C1(minv_dtaudqd_out_R3_C1),.minv_dtaudqd_out_R3_C2(minv_dtaudqd_out_R3_C2),.minv_dtaudqd_out_R3_C3(minv_dtaudqd_out_R3_C3),.minv_dtaudqd_out_R3_C4(minv_dtaudqd_out_R3_C4),.minv_dtaudqd_out_R3_C5(minv_dtaudqd_out_R3_C5),.minv_dtaudqd_out_R3_C6(minv_dtaudqd_out_R3_C6),.minv_dtaudqd_out_R3_C7(minv_dtaudqd_out_R3_C7),
      .minv_dtaudqd_out_R4_C1(minv_dtaudqd_out_R4_C1),.minv_dtaudqd_out_R4_C2(minv_dtaudqd_out_R4_C2),.minv_dtaudqd_out_R4_C3(minv_dtaudqd_out_R4_C3),.minv_dtaudqd_out_R4_C4(minv_dtaudqd_out_R4_C4),.minv_dtaudqd_out_R4_C5(minv_dtaudqd_out_R4_C5),.minv_dtaudqd_out_R4_C6(minv_dtaudqd_out_R4_C6),.minv_dtaudqd_out_R4_C7(minv_dtaudqd_out_R4_C7),
      .minv_dtaudqd_out_R5_C1(minv_dtaudqd_out_R5_C1),.minv_dtaudqd_out_R5_C2(minv_dtaudqd_out_R5_C2),.minv_dtaudqd_out_R5_C3(minv_dtaudqd_out_R5_C3),.minv_dtaudqd_out_R5_C4(minv_dtaudqd_out_R5_C4),.minv_dtaudqd_out_R5_C5(minv_dtaudqd_out_R5_C5),.minv_dtaudqd_out_R5_C6(minv_dtaudqd_out_R5_C6),.minv_dtaudqd_out_R5_C7(minv_dtaudqd_out_R5_C7),
      .minv_dtaudqd_out_R6_C1(minv_dtaudqd_out_R6_C1),.minv_dtaudqd_out_R6_C2(minv_dtaudqd_out_R6_C2),.minv_dtaudqd_out_R6_C3(minv_dtaudqd_out_R6_C3),.minv_dtaudqd_out_R6_C4(minv_dtaudqd_out_R6_C4),.minv_dtaudqd_out_R6_C5(minv_dtaudqd_out_R6_C5),.minv_dtaudqd_out_R6_C6(minv_dtaudqd_out_R6_C6),.minv_dtaudqd_out_R6_C7(minv_dtaudqd_out_R6_C7),
      .minv_dtaudqd_out_R7_C1(minv_dtaudqd_out_R7_C1),.minv_dtaudqd_out_R7_C2(minv_dtaudqd_out_R7_C2),.minv_dtaudqd_out_R7_C3(minv_dtaudqd_out_R7_C3),.minv_dtaudqd_out_R7_C4(minv_dtaudqd_out_R7_C4),.minv_dtaudqd_out_R7_C5(minv_dtaudqd_out_R7_C5),.minv_dtaudqd_out_R7_C6(minv_dtaudqd_out_R7_C6),.minv_dtaudqd_out_R7_C7(minv_dtaudqd_out_R7_C7)
      );

   initial begin
      #10;
      // initialize
      clk = 0;
      // inputs
      sinq_prev_in = 0; cosq_prev_in = 0;
      f_prev_vec_in_AX = 32'd0; f_prev_vec_in_AY = 32'd0; f_prev_vec_in_AZ = 32'd0; f_prev_vec_in_LX = 32'd0; f_prev_vec_in_LY = 32'd0; f_prev_vec_in_LZ = 32'd0;
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0;
      // df/dq prev in
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      // df/dqd prev in
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      // control
      get_data = 0;
      //------------------------------------------------------------------------
      // reset
      reset = 1;
      #10;
      reset = 0;
      #2
      // start
      clk = 1;
      #2;
      clk = 0;
      #2;
      // set values
      //------------------------------------------------------------------------
      $display ("// Knot 1 Link 8 Init");
      //------------------------------------------------------------------------
      // Link 8 Inputs
      // 7
      sinq_prev_in = 32'd49084; cosq_prev_in = -32'd43424;
      f_prev_vec_in_AX = 32'd8044; f_prev_vec_in_AY = -32'd6533; f_prev_vec_in_AZ = 32'd5043; f_prev_vec_in_LX = -32'd120315; f_prev_vec_in_LY = -32'd133594; f_prev_vec_in_LZ = -32'd13832;
      // 7
      // minv_prev_vec_in_C1 = 0.321418; minv_prev_vec_in_C2 = 0.35137; minv_prev_vec_in_C3 = 0.188062; minv_prev_vec_in_C4 = 2.85474; minv_prev_vec_in_C5 = 98.7838; minv_prev_vec_in_C6 = 4.79672; minv_prev_vec_in_C7 = -1095.04;
      minv_prev_vec_in_C1 = 32'd21064; minv_prev_vec_in_C2 = 32'd23027; minv_prev_vec_in_C3 = 32'd12325; minv_prev_vec_in_C4 = 32'd187088; minv_prev_vec_in_C5 = 32'd6473895; minv_prev_vec_in_C6 = 32'd314358; minv_prev_vec_in_C7 = -32'd71764541;
      // 7
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd155; dfidq_prev_mat_in_AX_J3 = 32'd691;  dfidq_prev_mat_in_AX_J4 = 32'd463; dfidq_prev_mat_in_AX_J5 = 32'd126; dfidq_prev_mat_in_AX_J6 = 32'd1874; dfidq_prev_mat_in_AX_J7 = -32'd6533;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd52; dfidq_prev_mat_in_AY_J3 = -32'd424;  dfidq_prev_mat_in_AY_J4 = 32'd142; dfidq_prev_mat_in_AY_J5 = 32'd895; dfidq_prev_mat_in_AY_J6 = 32'd1840; dfidq_prev_mat_in_AY_J7 = -32'd8044;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd35; dfidq_prev_mat_in_AZ_J3 = -32'd3;  dfidq_prev_mat_in_AZ_J4 = 32'd72; dfidq_prev_mat_in_AZ_J5 = -32'd75; dfidq_prev_mat_in_AZ_J6 = -32'd454; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd3285; dfidq_prev_mat_in_LX_J3 = -32'd13804;  dfidq_prev_mat_in_LX_J4 = 32'd6498; dfidq_prev_mat_in_LX_J5 = 32'd35032; dfidq_prev_mat_in_LX_J6 = 32'd34895; dfidq_prev_mat_in_LX_J7 = -32'd133594;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd10772; dfidq_prev_mat_in_LY_J3 = -32'd28595;  dfidq_prev_mat_in_LY_J4 = -32'd29148; dfidq_prev_mat_in_LY_J5 = -32'd4116; dfidq_prev_mat_in_LY_J6 = -32'd35504; dfidq_prev_mat_in_LY_J7 = 32'd120316;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd19629; dfidq_prev_mat_in_LZ_J3 = 32'd12420;  dfidq_prev_mat_in_LZ_J4 = 32'd15012; dfidq_prev_mat_in_LZ_J5 = -32'd6108; dfidq_prev_mat_in_LZ_J6 = -32'd26838; dfidq_prev_mat_in_LZ_J7 = -32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd204; dfidqd_prev_mat_in_AX_J2 = -32'd355; dfidqd_prev_mat_in_AX_J3 = 32'd58;  dfidqd_prev_mat_in_AX_J4 = 32'd128; dfidqd_prev_mat_in_AX_J5 = 32'd34; dfidqd_prev_mat_in_AX_J6 = 32'd184; dfidqd_prev_mat_in_AX_J7 = 32'd43;
      dfidqd_prev_mat_in_AY_J1 = -32'd186; dfidqd_prev_mat_in_AY_J2 = 32'd404; dfidqd_prev_mat_in_AY_J3 = -32'd176;  dfidqd_prev_mat_in_AY_J4 = -32'd786; dfidqd_prev_mat_in_AY_J5 = 32'd108; dfidqd_prev_mat_in_AY_J6 = 32'd208; dfidqd_prev_mat_in_AY_J7 = -32'd12;
      dfidqd_prev_mat_in_AZ_J1 = -32'd9; dfidqd_prev_mat_in_AZ_J2 = -32'd29; dfidqd_prev_mat_in_AZ_J3 = -32'd8;  dfidqd_prev_mat_in_AZ_J4 = 32'd69; dfidqd_prev_mat_in_AZ_J5 = -32'd23; dfidqd_prev_mat_in_AZ_J6 = -32'd41; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd10435; dfidqd_prev_mat_in_LX_J2 = 32'd23638; dfidqd_prev_mat_in_LX_J3 = -32'd7656;  dfidqd_prev_mat_in_LX_J4 = -32'd37658; dfidqd_prev_mat_in_LX_J5 = 32'd3027; dfidqd_prev_mat_in_LX_J6 = 32'd6737; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd13340; dfidqd_prev_mat_in_LY_J2 = 32'd20050; dfidqd_prev_mat_in_LY_J3 = 32'd289;  dfidqd_prev_mat_in_LY_J4 = -32'd5454; dfidqd_prev_mat_in_LY_J5 = 32'd998; dfidqd_prev_mat_in_LY_J6 = -32'd5960; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd8477; dfidqd_prev_mat_in_LZ_J2 = -32'd12323; dfidqd_prev_mat_in_LZ_J3 = 32'd1071;  dfidqd_prev_mat_in_LZ_J4 = -32'd549; dfidqd_prev_mat_in_LZ_J5 = -32'd757; dfidqd_prev_mat_in_LZ_J6 = 32'd1182; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Ignore Outputs
      //------------------------------------------------------------------------
      // Link 7 Inputs
      // 6
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      // 6
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = -32'd25864; minv_prev_vec_in_C2 = -32'd89991; minv_prev_vec_in_C3 = -32'd45311; minv_prev_vec_in_C4 = -32'd358665; minv_prev_vec_in_C5 = -32'd204961; minv_prev_vec_in_C6 = -32'd8039236; minv_prev_vec_in_C7 = 32'd314358;
      // 6
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd284; dfidq_prev_mat_in_AX_J3 = -32'd35;  dfidq_prev_mat_in_AX_J4 = 32'd259; dfidq_prev_mat_in_AX_J5 = 32'd931; dfidq_prev_mat_in_AX_J6 = 32'd8200; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd123; dfidq_prev_mat_in_AY_J3 = -32'd73;  dfidq_prev_mat_in_AY_J4 = 32'd247; dfidq_prev_mat_in_AY_J5 = -32'd245; dfidq_prev_mat_in_AY_J6 = -32'd1679; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd151; dfidq_prev_mat_in_AZ_J3 = 32'd839;  dfidq_prev_mat_in_AZ_J4 = 32'd23; dfidq_prev_mat_in_AZ_J5 = -32'd794; dfidq_prev_mat_in_AZ_J6 = -32'd389; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd32323; dfidq_prev_mat_in_LX_J3 = -32'd160291;  dfidq_prev_mat_in_LX_J4 = -32'd90398; dfidq_prev_mat_in_LX_J5 = 32'd80218; dfidq_prev_mat_in_LX_J6 = -32'd77343; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd111481; dfidq_prev_mat_in_LY_J3 = 32'd77173;  dfidq_prev_mat_in_LY_J4 = 32'd64413; dfidq_prev_mat_in_LY_J5 = -32'd25932; dfidq_prev_mat_in_LY_J6 = -32'd128801; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd49161; dfidq_prev_mat_in_LZ_J3 = 32'd46245;  dfidq_prev_mat_in_LZ_J4 = 32'd109642; dfidq_prev_mat_in_LZ_J5 = 32'd145168; dfidq_prev_mat_in_LZ_J6 = 32'd1770; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd76; dfidqd_prev_mat_in_AX_J2 = -32'd2; dfidqd_prev_mat_in_AX_J3 = 32'd75;  dfidqd_prev_mat_in_AX_J4 = -32'd411; dfidqd_prev_mat_in_AX_J5 = 32'd337; dfidqd_prev_mat_in_AX_J6 = 32'd906; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd36; dfidqd_prev_mat_in_AY_J2 = -32'd40; dfidqd_prev_mat_in_AY_J3 = -32'd44;  dfidqd_prev_mat_in_AY_J4 = 32'd186; dfidqd_prev_mat_in_AY_J5 = -32'd85; dfidqd_prev_mat_in_AY_J6 = -32'd135; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd53; dfidqd_prev_mat_in_AZ_J2 = -32'd127; dfidqd_prev_mat_in_AZ_J3 = 32'd123;  dfidqd_prev_mat_in_AZ_J4 = 32'd558; dfidqd_prev_mat_in_AZ_J5 = -32'd149; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd5723; dfidqd_prev_mat_in_LX_J2 = 32'd166896; dfidqd_prev_mat_in_LX_J3 = -32'd36058;  dfidqd_prev_mat_in_LX_J4 = -32'd143888; dfidqd_prev_mat_in_LX_J5 = 32'd77; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd43324; dfidqd_prev_mat_in_LY_J2 = -32'd60969; dfidqd_prev_mat_in_LY_J3 = 32'd11058;  dfidqd_prev_mat_in_LY_J4 = -32'd9066; dfidqd_prev_mat_in_LY_J5 = -32'd92; dfidqd_prev_mat_in_LY_J6 = 32'd42; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd94049; dfidqd_prev_mat_in_LZ_J2 = 32'd24373; dfidqd_prev_mat_in_LZ_J3 = -32'd36659;  dfidqd_prev_mat_in_LZ_J4 = -32'd120581; dfidqd_prev_mat_in_LZ_J5 = -32'd164; dfidqd_prev_mat_in_LZ_J6 = 32'd321; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 7 Outputs
      $display ("// Link 7 Test");
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
      minv_prev_vec_in_C1 = -32'd66476; minv_prev_vec_in_C2 = -32'd19260; minv_prev_vec_in_C3 = 32'd2574713; minv_prev_vec_in_C4 = -32'd105892; minv_prev_vec_in_C5 = -32'd9289794; minv_prev_vec_in_C6 = -32'd204961; minv_prev_vec_in_C7 = 32'd6473895;
      // 5
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd4354; dfidq_prev_mat_in_AX_J3 = 32'd3320;  dfidq_prev_mat_in_AX_J4 = 32'd7150; dfidq_prev_mat_in_AX_J5 = 32'd10972; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd4610; dfidq_prev_mat_in_AY_J3 = -32'd12747;  dfidq_prev_mat_in_AY_J4 = -32'd7214; dfidq_prev_mat_in_AY_J5 = 32'd5786; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd1038; dfidq_prev_mat_in_AZ_J3 = 32'd2853;  dfidq_prev_mat_in_AZ_J4 = 32'd1647; dfidq_prev_mat_in_AZ_J5 = -32'd564; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd48590; dfidq_prev_mat_in_LX_J3 = -32'd137401;  dfidq_prev_mat_in_LX_J4 = -32'd65942; dfidq_prev_mat_in_LX_J5 = 32'd23191; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd45129; dfidq_prev_mat_in_LY_J3 = -32'd36066;  dfidq_prev_mat_in_LY_J4 = -32'd70817; dfidq_prev_mat_in_LY_J5 = -32'd96617; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd62580; dfidq_prev_mat_in_LZ_J3 = 32'd13151;  dfidq_prev_mat_in_LZ_J4 = -32'd4659; dfidq_prev_mat_in_LZ_J5 = 32'd7121; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd5945; dfidqd_prev_mat_in_AX_J2 = 32'd1309; dfidqd_prev_mat_in_AX_J3 = -32'd1513;  dfidqd_prev_mat_in_AX_J4 = -32'd8879; dfidqd_prev_mat_in_AX_J5 = 32'd1237; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd1314; dfidqd_prev_mat_in_AY_J2 = 32'd12420; dfidqd_prev_mat_in_AY_J3 = -32'd2697;  dfidqd_prev_mat_in_AY_J4 = -32'd9465; dfidqd_prev_mat_in_AY_J5 = 32'd16; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd394; dfidqd_prev_mat_in_AZ_J2 = -32'd3077; dfidqd_prev_mat_in_AZ_J3 = 32'd491;  dfidqd_prev_mat_in_AZ_J4 = 32'd2025; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd20251; dfidqd_prev_mat_in_LX_J2 = 32'd140948; dfidqd_prev_mat_in_LX_J3 = -32'd23281;  dfidqd_prev_mat_in_LX_J4 = -32'd84990; dfidqd_prev_mat_in_LX_J5 = -32'd52; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd57716; dfidqd_prev_mat_in_LY_J2 = -32'd18551; dfidqd_prev_mat_in_LY_J3 = 32'd11438;  dfidqd_prev_mat_in_LY_J4 = 32'd73710; dfidqd_prev_mat_in_LY_J5 = -32'd10981; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd24770; dfidqd_prev_mat_in_LZ_J2 = -32'd13522; dfidqd_prev_mat_in_LZ_J3 = 32'd1380;  dfidqd_prev_mat_in_LZ_J4 = -32'd31010; dfidqd_prev_mat_in_LZ_J5 = 32'd3378; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 6 Outputs
      $display ("// Link 6 Test");
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
      minv_prev_vec_in_C1 = 32'd193436; minv_prev_vec_in_C2 = -32'd122649; minv_prev_vec_in_C3 = -32'd201513; minv_prev_vec_in_C4 = -32'd437695; minv_prev_vec_in_C5 = -32'd105892; minv_prev_vec_in_C6 = -32'd358665; minv_prev_vec_in_C7 = 32'd187088;
      // 4
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd826; dfidq_prev_mat_in_AX_J3 = 32'd8949;  dfidq_prev_mat_in_AX_J4 = 32'd1941; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd2678; dfidq_prev_mat_in_AY_J3 = 32'd4680;  dfidq_prev_mat_in_AY_J4 = 32'd1622; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd5904; dfidq_prev_mat_in_AZ_J3 = -32'd12157;  dfidq_prev_mat_in_AZ_J4 = -32'd6891; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd76136; dfidq_prev_mat_in_LX_J3 = 32'd136829;  dfidq_prev_mat_in_LX_J4 = 32'd35836; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd55811; dfidq_prev_mat_in_LY_J3 = -32'd9425;  dfidq_prev_mat_in_LY_J4 = -32'd53266; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd3436; dfidq_prev_mat_in_LZ_J3 = 32'd89127;  dfidq_prev_mat_in_LZ_J4 = 32'd1368; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1436; dfidqd_prev_mat_in_AX_J2 = -32'd9457; dfidqd_prev_mat_in_AX_J3 = 32'd1126;  dfidqd_prev_mat_in_AX_J4 = 32'd9615; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd2460; dfidqd_prev_mat_in_AY_J2 = -32'd3074; dfidqd_prev_mat_in_AY_J3 = -32'd13;  dfidqd_prev_mat_in_AY_J4 = 32'd277; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd5950; dfidqd_prev_mat_in_AZ_J2 = 32'd7332; dfidqd_prev_mat_in_AZ_J3 = -32'd181;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd73332; dfidqd_prev_mat_in_LX_J2 = -32'd89415; dfidqd_prev_mat_in_LX_J3 = -32'd473;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22838; dfidqd_prev_mat_in_LY_J2 = -32'd43368; dfidqd_prev_mat_in_LY_J3 = -32'd94;  dfidqd_prev_mat_in_LY_J4 = -32'd13222; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd10554; dfidqd_prev_mat_in_LZ_J2 = -32'd135202; dfidqd_prev_mat_in_LZ_J3 = -32'd9858;  dfidqd_prev_mat_in_LZ_J4 = 32'd45277; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 5 Outputs
      $display ("// Link 5 Test");
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
      minv_prev_vec_in_C1 = 32'd212790; minv_prev_vec_in_C2 = -32'd42572; minv_prev_vec_in_C3 = -32'd2752466; minv_prev_vec_in_C4 = -32'd201513; minv_prev_vec_in_C5 = 32'd2574713; minv_prev_vec_in_C6 = -32'd45311; minv_prev_vec_in_C7 = 32'd12325;
      // 3
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd2621; dfidq_prev_mat_in_AX_J3 = 32'd15599;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd10348; dfidq_prev_mat_in_AY_J3 = 32'd21009;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd1137; dfidq_prev_mat_in_AZ_J3 = -32'd2999;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd51071; dfidq_prev_mat_in_LX_J3 = 32'd102173;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd1313; dfidq_prev_mat_in_LY_J3 = -32'd68019;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd57033; dfidq_prev_mat_in_LZ_J3 = 32'd16263;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1897; dfidqd_prev_mat_in_AX_J2 = -32'd19915; dfidqd_prev_mat_in_AX_J3 = 32'd2933;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd10769; dfidqd_prev_mat_in_AY_J2 = -32'd13702; dfidqd_prev_mat_in_AY_J3 = 32'd147;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd1521; dfidqd_prev_mat_in_AZ_J2 = 32'd1936; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd53805; dfidqd_prev_mat_in_LX_J2 = -32'd68646; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22821; dfidqd_prev_mat_in_LY_J2 = 32'd97882; dfidqd_prev_mat_in_LY_J3 = -32'd22583;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd23054; dfidqd_prev_mat_in_LZ_J2 = -32'd23480; dfidqd_prev_mat_in_LZ_J3 = -32'd22;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 4 Outputs
      $display ("// Link 4 Test");
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
      minv_prev_vec_in_C1 = 32'd54563; minv_prev_vec_in_C2 = -32'd53716; minv_prev_vec_in_C3 = -32'd42572; minv_prev_vec_in_C4 = -32'd122649; minv_prev_vec_in_C5 = -32'd19260; minv_prev_vec_in_C6 = -32'd89991; minv_prev_vec_in_C7 = 32'd23027;
      // 2
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd2709; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd126; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd2017; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd8454; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd17508; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd6786; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd469; dfidqd_prev_mat_in_AX_J2 = 32'd6644; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd375; dfidqd_prev_mat_in_AY_J2 = -32'd304; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd2077; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd10572; dfidqd_prev_mat_in_LX_J2 = -32'd40; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd4252; dfidqd_prev_mat_in_LY_J2 = -32'd7785; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd14781; dfidqd_prev_mat_in_LZ_J2 = 32'd28755; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 3 Outputs
      $display ("// Link 3 Test");
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
      minv_prev_vec_in_C1 = -32'd216819; minv_prev_vec_in_C2 = 32'd54563; minv_prev_vec_in_C3 = 32'd212790; minv_prev_vec_in_C4 = 32'd193436; minv_prev_vec_in_C5 = -32'd66476; minv_prev_vec_in_C6 = -32'd25864; minv_prev_vec_in_C7 = 32'd21064;
      // 1
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd1887; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd15727; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 2 Outputs
      $display ("// Link 2 Test");
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
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0;
      // 0
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // Hold for 3 cycles for Link 1 Outputs
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 2
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 1
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 1 Outputs
      $display ("// Link 1 Test");
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
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
      //------------------------------------------------------------------------
      // set values
      //------------------------------------------------------------------------
      $display ("// Knot 2 Link 8 Init");
      //------------------------------------------------------------------------
      // Link 8 Inputs
      // 7
      sinq_prev_in = 32'd49084; cosq_prev_in = -32'd43424;
      f_prev_vec_in_AX = 32'd8044; f_prev_vec_in_AY = -32'd6533; f_prev_vec_in_AZ = 32'd5043; f_prev_vec_in_LX = -32'd120315; f_prev_vec_in_LY = -32'd133594; f_prev_vec_in_LZ = -32'd13832;
      // 7
      // minv_prev_vec_in_C1 = 0.321418; minv_prev_vec_in_C2 = 0.35137; minv_prev_vec_in_C3 = 0.188062; minv_prev_vec_in_C4 = 2.85474; minv_prev_vec_in_C5 = 98.7838; minv_prev_vec_in_C6 = 4.79672; minv_prev_vec_in_C7 = -1095.04;
      minv_prev_vec_in_C1 = 32'd21064; minv_prev_vec_in_C2 = 32'd23027; minv_prev_vec_in_C3 = 32'd12325; minv_prev_vec_in_C4 = 32'd187088; minv_prev_vec_in_C5 = 32'd6473895; minv_prev_vec_in_C6 = 32'd314358; minv_prev_vec_in_C7 = -32'd71764541;
      // 7
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd155; dfidq_prev_mat_in_AX_J3 = 32'd691;  dfidq_prev_mat_in_AX_J4 = 32'd463; dfidq_prev_mat_in_AX_J5 = 32'd126; dfidq_prev_mat_in_AX_J6 = 32'd1874; dfidq_prev_mat_in_AX_J7 = -32'd6533;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd52; dfidq_prev_mat_in_AY_J3 = -32'd424;  dfidq_prev_mat_in_AY_J4 = 32'd142; dfidq_prev_mat_in_AY_J5 = 32'd895; dfidq_prev_mat_in_AY_J6 = 32'd1840; dfidq_prev_mat_in_AY_J7 = -32'd8044;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd35; dfidq_prev_mat_in_AZ_J3 = -32'd3;  dfidq_prev_mat_in_AZ_J4 = 32'd72; dfidq_prev_mat_in_AZ_J5 = -32'd75; dfidq_prev_mat_in_AZ_J6 = -32'd454; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd3285; dfidq_prev_mat_in_LX_J3 = -32'd13804;  dfidq_prev_mat_in_LX_J4 = 32'd6498; dfidq_prev_mat_in_LX_J5 = 32'd35032; dfidq_prev_mat_in_LX_J6 = 32'd34895; dfidq_prev_mat_in_LX_J7 = -32'd133594;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd10772; dfidq_prev_mat_in_LY_J3 = -32'd28595;  dfidq_prev_mat_in_LY_J4 = -32'd29148; dfidq_prev_mat_in_LY_J5 = -32'd4116; dfidq_prev_mat_in_LY_J6 = -32'd35504; dfidq_prev_mat_in_LY_J7 = 32'd120316;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd19629; dfidq_prev_mat_in_LZ_J3 = 32'd12420;  dfidq_prev_mat_in_LZ_J4 = 32'd15012; dfidq_prev_mat_in_LZ_J5 = -32'd6108; dfidq_prev_mat_in_LZ_J6 = -32'd26838; dfidq_prev_mat_in_LZ_J7 = -32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd204; dfidqd_prev_mat_in_AX_J2 = -32'd355; dfidqd_prev_mat_in_AX_J3 = 32'd58;  dfidqd_prev_mat_in_AX_J4 = 32'd128; dfidqd_prev_mat_in_AX_J5 = 32'd34; dfidqd_prev_mat_in_AX_J6 = 32'd184; dfidqd_prev_mat_in_AX_J7 = 32'd43;
      dfidqd_prev_mat_in_AY_J1 = -32'd186; dfidqd_prev_mat_in_AY_J2 = 32'd404; dfidqd_prev_mat_in_AY_J3 = -32'd176;  dfidqd_prev_mat_in_AY_J4 = -32'd786; dfidqd_prev_mat_in_AY_J5 = 32'd108; dfidqd_prev_mat_in_AY_J6 = 32'd208; dfidqd_prev_mat_in_AY_J7 = -32'd12;
      dfidqd_prev_mat_in_AZ_J1 = -32'd9; dfidqd_prev_mat_in_AZ_J2 = -32'd29; dfidqd_prev_mat_in_AZ_J3 = -32'd8;  dfidqd_prev_mat_in_AZ_J4 = 32'd69; dfidqd_prev_mat_in_AZ_J5 = -32'd23; dfidqd_prev_mat_in_AZ_J6 = -32'd41; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd10435; dfidqd_prev_mat_in_LX_J2 = 32'd23638; dfidqd_prev_mat_in_LX_J3 = -32'd7656;  dfidqd_prev_mat_in_LX_J4 = -32'd37658; dfidqd_prev_mat_in_LX_J5 = 32'd3027; dfidqd_prev_mat_in_LX_J6 = 32'd6737; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd13340; dfidqd_prev_mat_in_LY_J2 = 32'd20050; dfidqd_prev_mat_in_LY_J3 = 32'd289;  dfidqd_prev_mat_in_LY_J4 = -32'd5454; dfidqd_prev_mat_in_LY_J5 = 32'd998; dfidqd_prev_mat_in_LY_J6 = -32'd5960; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd8477; dfidqd_prev_mat_in_LZ_J2 = -32'd12323; dfidqd_prev_mat_in_LZ_J3 = 32'd1071;  dfidqd_prev_mat_in_LZ_J4 = -32'd549; dfidqd_prev_mat_in_LZ_J5 = -32'd757; dfidqd_prev_mat_in_LZ_J6 = 32'd1182; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Ignore Outputs
      //------------------------------------------------------------------------
      // Link 7 Inputs
      // 6
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      // 6
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = -32'd25864; minv_prev_vec_in_C2 = -32'd89991; minv_prev_vec_in_C3 = -32'd45311; minv_prev_vec_in_C4 = -32'd358665; minv_prev_vec_in_C5 = -32'd204961; minv_prev_vec_in_C6 = -32'd8039236; minv_prev_vec_in_C7 = 32'd314358;
      // 6
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd284; dfidq_prev_mat_in_AX_J3 = -32'd35;  dfidq_prev_mat_in_AX_J4 = 32'd259; dfidq_prev_mat_in_AX_J5 = 32'd931; dfidq_prev_mat_in_AX_J6 = 32'd8200; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd123; dfidq_prev_mat_in_AY_J3 = -32'd73;  dfidq_prev_mat_in_AY_J4 = 32'd247; dfidq_prev_mat_in_AY_J5 = -32'd245; dfidq_prev_mat_in_AY_J6 = -32'd1679; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd151; dfidq_prev_mat_in_AZ_J3 = 32'd839;  dfidq_prev_mat_in_AZ_J4 = 32'd23; dfidq_prev_mat_in_AZ_J5 = -32'd794; dfidq_prev_mat_in_AZ_J6 = -32'd389; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd32323; dfidq_prev_mat_in_LX_J3 = -32'd160291;  dfidq_prev_mat_in_LX_J4 = -32'd90398; dfidq_prev_mat_in_LX_J5 = 32'd80218; dfidq_prev_mat_in_LX_J6 = -32'd77343; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd111481; dfidq_prev_mat_in_LY_J3 = 32'd77173;  dfidq_prev_mat_in_LY_J4 = 32'd64413; dfidq_prev_mat_in_LY_J5 = -32'd25932; dfidq_prev_mat_in_LY_J6 = -32'd128801; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd49161; dfidq_prev_mat_in_LZ_J3 = 32'd46245;  dfidq_prev_mat_in_LZ_J4 = 32'd109642; dfidq_prev_mat_in_LZ_J5 = 32'd145168; dfidq_prev_mat_in_LZ_J6 = 32'd1770; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd76; dfidqd_prev_mat_in_AX_J2 = -32'd2; dfidqd_prev_mat_in_AX_J3 = 32'd75;  dfidqd_prev_mat_in_AX_J4 = -32'd411; dfidqd_prev_mat_in_AX_J5 = 32'd337; dfidqd_prev_mat_in_AX_J6 = 32'd906; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd36; dfidqd_prev_mat_in_AY_J2 = -32'd40; dfidqd_prev_mat_in_AY_J3 = -32'd44;  dfidqd_prev_mat_in_AY_J4 = 32'd186; dfidqd_prev_mat_in_AY_J5 = -32'd85; dfidqd_prev_mat_in_AY_J6 = -32'd135; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd53; dfidqd_prev_mat_in_AZ_J2 = -32'd127; dfidqd_prev_mat_in_AZ_J3 = 32'd123;  dfidqd_prev_mat_in_AZ_J4 = 32'd558; dfidqd_prev_mat_in_AZ_J5 = -32'd149; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd5723; dfidqd_prev_mat_in_LX_J2 = 32'd166896; dfidqd_prev_mat_in_LX_J3 = -32'd36058;  dfidqd_prev_mat_in_LX_J4 = -32'd143888; dfidqd_prev_mat_in_LX_J5 = 32'd77; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd43324; dfidqd_prev_mat_in_LY_J2 = -32'd60969; dfidqd_prev_mat_in_LY_J3 = 32'd11058;  dfidqd_prev_mat_in_LY_J4 = -32'd9066; dfidqd_prev_mat_in_LY_J5 = -32'd92; dfidqd_prev_mat_in_LY_J6 = 32'd42; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd94049; dfidqd_prev_mat_in_LZ_J2 = 32'd24373; dfidqd_prev_mat_in_LZ_J3 = -32'd36659;  dfidqd_prev_mat_in_LZ_J4 = -32'd120581; dfidqd_prev_mat_in_LZ_J5 = -32'd164; dfidqd_prev_mat_in_LZ_J6 = 32'd321; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 7 Outputs
      $display ("// Link 7 Test");
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
      minv_prev_vec_in_C1 = -32'd66476; minv_prev_vec_in_C2 = -32'd19260; minv_prev_vec_in_C3 = 32'd2574713; minv_prev_vec_in_C4 = -32'd105892; minv_prev_vec_in_C5 = -32'd9289794; minv_prev_vec_in_C6 = -32'd204961; minv_prev_vec_in_C7 = 32'd6473895;
      // 5
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd4354; dfidq_prev_mat_in_AX_J3 = 32'd3320;  dfidq_prev_mat_in_AX_J4 = 32'd7150; dfidq_prev_mat_in_AX_J5 = 32'd10972; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd4610; dfidq_prev_mat_in_AY_J3 = -32'd12747;  dfidq_prev_mat_in_AY_J4 = -32'd7214; dfidq_prev_mat_in_AY_J5 = 32'd5786; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd1038; dfidq_prev_mat_in_AZ_J3 = 32'd2853;  dfidq_prev_mat_in_AZ_J4 = 32'd1647; dfidq_prev_mat_in_AZ_J5 = -32'd564; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd48590; dfidq_prev_mat_in_LX_J3 = -32'd137401;  dfidq_prev_mat_in_LX_J4 = -32'd65942; dfidq_prev_mat_in_LX_J5 = 32'd23191; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd45129; dfidq_prev_mat_in_LY_J3 = -32'd36066;  dfidq_prev_mat_in_LY_J4 = -32'd70817; dfidq_prev_mat_in_LY_J5 = -32'd96617; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd62580; dfidq_prev_mat_in_LZ_J3 = 32'd13151;  dfidq_prev_mat_in_LZ_J4 = -32'd4659; dfidq_prev_mat_in_LZ_J5 = 32'd7121; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd5945; dfidqd_prev_mat_in_AX_J2 = 32'd1309; dfidqd_prev_mat_in_AX_J3 = -32'd1513;  dfidqd_prev_mat_in_AX_J4 = -32'd8879; dfidqd_prev_mat_in_AX_J5 = 32'd1237; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd1314; dfidqd_prev_mat_in_AY_J2 = 32'd12420; dfidqd_prev_mat_in_AY_J3 = -32'd2697;  dfidqd_prev_mat_in_AY_J4 = -32'd9465; dfidqd_prev_mat_in_AY_J5 = 32'd16; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd394; dfidqd_prev_mat_in_AZ_J2 = -32'd3077; dfidqd_prev_mat_in_AZ_J3 = 32'd491;  dfidqd_prev_mat_in_AZ_J4 = 32'd2025; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd20251; dfidqd_prev_mat_in_LX_J2 = 32'd140948; dfidqd_prev_mat_in_LX_J3 = -32'd23281;  dfidqd_prev_mat_in_LX_J4 = -32'd84990; dfidqd_prev_mat_in_LX_J5 = -32'd52; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd57716; dfidqd_prev_mat_in_LY_J2 = -32'd18551; dfidqd_prev_mat_in_LY_J3 = 32'd11438;  dfidqd_prev_mat_in_LY_J4 = 32'd73710; dfidqd_prev_mat_in_LY_J5 = -32'd10981; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd24770; dfidqd_prev_mat_in_LZ_J2 = -32'd13522; dfidqd_prev_mat_in_LZ_J3 = 32'd1380;  dfidqd_prev_mat_in_LZ_J4 = -32'd31010; dfidqd_prev_mat_in_LZ_J5 = 32'd3378; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 6 Outputs
      $display ("// Link 6 Test");
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
      minv_prev_vec_in_C1 = 32'd193436; minv_prev_vec_in_C2 = -32'd122649; minv_prev_vec_in_C3 = -32'd201513; minv_prev_vec_in_C4 = -32'd437695; minv_prev_vec_in_C5 = -32'd105892; minv_prev_vec_in_C6 = -32'd358665; minv_prev_vec_in_C7 = 32'd187088;
      // 4
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd826; dfidq_prev_mat_in_AX_J3 = 32'd8949;  dfidq_prev_mat_in_AX_J4 = 32'd1941; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd2678; dfidq_prev_mat_in_AY_J3 = 32'd4680;  dfidq_prev_mat_in_AY_J4 = 32'd1622; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd5904; dfidq_prev_mat_in_AZ_J3 = -32'd12157;  dfidq_prev_mat_in_AZ_J4 = -32'd6891; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd76136; dfidq_prev_mat_in_LX_J3 = 32'd136829;  dfidq_prev_mat_in_LX_J4 = 32'd35836; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd55811; dfidq_prev_mat_in_LY_J3 = -32'd9425;  dfidq_prev_mat_in_LY_J4 = -32'd53266; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd3436; dfidq_prev_mat_in_LZ_J3 = 32'd89127;  dfidq_prev_mat_in_LZ_J4 = 32'd1368; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1436; dfidqd_prev_mat_in_AX_J2 = -32'd9457; dfidqd_prev_mat_in_AX_J3 = 32'd1126;  dfidqd_prev_mat_in_AX_J4 = 32'd9615; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd2460; dfidqd_prev_mat_in_AY_J2 = -32'd3074; dfidqd_prev_mat_in_AY_J3 = -32'd13;  dfidqd_prev_mat_in_AY_J4 = 32'd277; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd5950; dfidqd_prev_mat_in_AZ_J2 = 32'd7332; dfidqd_prev_mat_in_AZ_J3 = -32'd181;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd73332; dfidqd_prev_mat_in_LX_J2 = -32'd89415; dfidqd_prev_mat_in_LX_J3 = -32'd473;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22838; dfidqd_prev_mat_in_LY_J2 = -32'd43368; dfidqd_prev_mat_in_LY_J3 = -32'd94;  dfidqd_prev_mat_in_LY_J4 = -32'd13222; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd10554; dfidqd_prev_mat_in_LZ_J2 = -32'd135202; dfidqd_prev_mat_in_LZ_J3 = -32'd9858;  dfidqd_prev_mat_in_LZ_J4 = 32'd45277; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 5 Outputs
      $display ("// Link 5 Test");
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
      minv_prev_vec_in_C1 = 32'd212790; minv_prev_vec_in_C2 = -32'd42572; minv_prev_vec_in_C3 = -32'd2752466; minv_prev_vec_in_C4 = -32'd201513; minv_prev_vec_in_C5 = 32'd2574713; minv_prev_vec_in_C6 = -32'd45311; minv_prev_vec_in_C7 = 32'd12325;
      // 3
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd2621; dfidq_prev_mat_in_AX_J3 = 32'd15599;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd10348; dfidq_prev_mat_in_AY_J3 = 32'd21009;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd1137; dfidq_prev_mat_in_AZ_J3 = -32'd2999;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd51071; dfidq_prev_mat_in_LX_J3 = 32'd102173;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd1313; dfidq_prev_mat_in_LY_J3 = -32'd68019;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd57033; dfidq_prev_mat_in_LZ_J3 = 32'd16263;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1897; dfidqd_prev_mat_in_AX_J2 = -32'd19915; dfidqd_prev_mat_in_AX_J3 = 32'd2933;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd10769; dfidqd_prev_mat_in_AY_J2 = -32'd13702; dfidqd_prev_mat_in_AY_J3 = 32'd147;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd1521; dfidqd_prev_mat_in_AZ_J2 = 32'd1936; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd53805; dfidqd_prev_mat_in_LX_J2 = -32'd68646; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22821; dfidqd_prev_mat_in_LY_J2 = 32'd97882; dfidqd_prev_mat_in_LY_J3 = -32'd22583;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd23054; dfidqd_prev_mat_in_LZ_J2 = -32'd23480; dfidqd_prev_mat_in_LZ_J3 = -32'd22;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 4 Outputs
      $display ("// Link 4 Test");
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
      minv_prev_vec_in_C1 = 32'd54563; minv_prev_vec_in_C2 = -32'd53716; minv_prev_vec_in_C3 = -32'd42572; minv_prev_vec_in_C4 = -32'd122649; minv_prev_vec_in_C5 = -32'd19260; minv_prev_vec_in_C6 = -32'd89991; minv_prev_vec_in_C7 = 32'd23027;
      // 2
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd2709; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd126; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd2017; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd8454; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd17508; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd6786; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd469; dfidqd_prev_mat_in_AX_J2 = 32'd6644; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd375; dfidqd_prev_mat_in_AY_J2 = -32'd304; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd2077; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd10572; dfidqd_prev_mat_in_LX_J2 = -32'd40; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd4252; dfidqd_prev_mat_in_LY_J2 = -32'd7785; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd14781; dfidqd_prev_mat_in_LZ_J2 = 32'd28755; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 3 Outputs
      $display ("// Link 3 Test");
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
      minv_prev_vec_in_C1 = -32'd216819; minv_prev_vec_in_C2 = 32'd54563; minv_prev_vec_in_C3 = 32'd212790; minv_prev_vec_in_C4 = 32'd193436; minv_prev_vec_in_C5 = -32'd66476; minv_prev_vec_in_C6 = -32'd25864; minv_prev_vec_in_C7 = 32'd21064;
      // 1
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd1887; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd15727; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 2 Outputs
      $display ("// Link 2 Test");
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
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0;
      // 0
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // Hold for 3 cycles for Link 1 Outputs
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 2
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 1
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 1 Outputs
      $display ("// Link 1 Test");
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
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
      //------------------------------------------------------------------------
      // set values
      //------------------------------------------------------------------------
      $display ("// Knot 3 Link 8 Init");
      //------------------------------------------------------------------------
      // Link 8 Inputs
      // 7
      sinq_prev_in = 32'd49084; cosq_prev_in = -32'd43424;
      f_prev_vec_in_AX = 32'd8044; f_prev_vec_in_AY = -32'd6533; f_prev_vec_in_AZ = 32'd5043; f_prev_vec_in_LX = -32'd120315; f_prev_vec_in_LY = -32'd133594; f_prev_vec_in_LZ = -32'd13832;
      // 7
      // minv_prev_vec_in_C1 = 0.321418; minv_prev_vec_in_C2 = 0.35137; minv_prev_vec_in_C3 = 0.188062; minv_prev_vec_in_C4 = 2.85474; minv_prev_vec_in_C5 = 98.7838; minv_prev_vec_in_C6 = 4.79672; minv_prev_vec_in_C7 = -1095.04;
      minv_prev_vec_in_C1 = 32'd21064; minv_prev_vec_in_C2 = 32'd23027; minv_prev_vec_in_C3 = 32'd12325; minv_prev_vec_in_C4 = 32'd187088; minv_prev_vec_in_C5 = 32'd6473895; minv_prev_vec_in_C6 = 32'd314358; minv_prev_vec_in_C7 = -32'd71764541;
      // 7
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd155; dfidq_prev_mat_in_AX_J3 = 32'd691;  dfidq_prev_mat_in_AX_J4 = 32'd463; dfidq_prev_mat_in_AX_J5 = 32'd126; dfidq_prev_mat_in_AX_J6 = 32'd1874; dfidq_prev_mat_in_AX_J7 = -32'd6533;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd52; dfidq_prev_mat_in_AY_J3 = -32'd424;  dfidq_prev_mat_in_AY_J4 = 32'd142; dfidq_prev_mat_in_AY_J5 = 32'd895; dfidq_prev_mat_in_AY_J6 = 32'd1840; dfidq_prev_mat_in_AY_J7 = -32'd8044;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd35; dfidq_prev_mat_in_AZ_J3 = -32'd3;  dfidq_prev_mat_in_AZ_J4 = 32'd72; dfidq_prev_mat_in_AZ_J5 = -32'd75; dfidq_prev_mat_in_AZ_J6 = -32'd454; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd3285; dfidq_prev_mat_in_LX_J3 = -32'd13804;  dfidq_prev_mat_in_LX_J4 = 32'd6498; dfidq_prev_mat_in_LX_J5 = 32'd35032; dfidq_prev_mat_in_LX_J6 = 32'd34895; dfidq_prev_mat_in_LX_J7 = -32'd133594;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd10772; dfidq_prev_mat_in_LY_J3 = -32'd28595;  dfidq_prev_mat_in_LY_J4 = -32'd29148; dfidq_prev_mat_in_LY_J5 = -32'd4116; dfidq_prev_mat_in_LY_J6 = -32'd35504; dfidq_prev_mat_in_LY_J7 = 32'd120316;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd19629; dfidq_prev_mat_in_LZ_J3 = 32'd12420;  dfidq_prev_mat_in_LZ_J4 = 32'd15012; dfidq_prev_mat_in_LZ_J5 = -32'd6108; dfidq_prev_mat_in_LZ_J6 = -32'd26838; dfidq_prev_mat_in_LZ_J7 = -32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd204; dfidqd_prev_mat_in_AX_J2 = -32'd355; dfidqd_prev_mat_in_AX_J3 = 32'd58;  dfidqd_prev_mat_in_AX_J4 = 32'd128; dfidqd_prev_mat_in_AX_J5 = 32'd34; dfidqd_prev_mat_in_AX_J6 = 32'd184; dfidqd_prev_mat_in_AX_J7 = 32'd43;
      dfidqd_prev_mat_in_AY_J1 = -32'd186; dfidqd_prev_mat_in_AY_J2 = 32'd404; dfidqd_prev_mat_in_AY_J3 = -32'd176;  dfidqd_prev_mat_in_AY_J4 = -32'd786; dfidqd_prev_mat_in_AY_J5 = 32'd108; dfidqd_prev_mat_in_AY_J6 = 32'd208; dfidqd_prev_mat_in_AY_J7 = -32'd12;
      dfidqd_prev_mat_in_AZ_J1 = -32'd9; dfidqd_prev_mat_in_AZ_J2 = -32'd29; dfidqd_prev_mat_in_AZ_J3 = -32'd8;  dfidqd_prev_mat_in_AZ_J4 = 32'd69; dfidqd_prev_mat_in_AZ_J5 = -32'd23; dfidqd_prev_mat_in_AZ_J6 = -32'd41; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd10435; dfidqd_prev_mat_in_LX_J2 = 32'd23638; dfidqd_prev_mat_in_LX_J3 = -32'd7656;  dfidqd_prev_mat_in_LX_J4 = -32'd37658; dfidqd_prev_mat_in_LX_J5 = 32'd3027; dfidqd_prev_mat_in_LX_J6 = 32'd6737; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd13340; dfidqd_prev_mat_in_LY_J2 = 32'd20050; dfidqd_prev_mat_in_LY_J3 = 32'd289;  dfidqd_prev_mat_in_LY_J4 = -32'd5454; dfidqd_prev_mat_in_LY_J5 = 32'd998; dfidqd_prev_mat_in_LY_J6 = -32'd5960; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd8477; dfidqd_prev_mat_in_LZ_J2 = -32'd12323; dfidqd_prev_mat_in_LZ_J3 = 32'd1071;  dfidqd_prev_mat_in_LZ_J4 = -32'd549; dfidqd_prev_mat_in_LZ_J5 = -32'd757; dfidqd_prev_mat_in_LZ_J6 = 32'd1182; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Ignore Outputs
      //------------------------------------------------------------------------
      // Link 7 Inputs
      // 6
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      // 6
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = -32'd25864; minv_prev_vec_in_C2 = -32'd89991; minv_prev_vec_in_C3 = -32'd45311; minv_prev_vec_in_C4 = -32'd358665; minv_prev_vec_in_C5 = -32'd204961; minv_prev_vec_in_C6 = -32'd8039236; minv_prev_vec_in_C7 = 32'd314358;
      // 6
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd284; dfidq_prev_mat_in_AX_J3 = -32'd35;  dfidq_prev_mat_in_AX_J4 = 32'd259; dfidq_prev_mat_in_AX_J5 = 32'd931; dfidq_prev_mat_in_AX_J6 = 32'd8200; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd123; dfidq_prev_mat_in_AY_J3 = -32'd73;  dfidq_prev_mat_in_AY_J4 = 32'd247; dfidq_prev_mat_in_AY_J5 = -32'd245; dfidq_prev_mat_in_AY_J6 = -32'd1679; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd151; dfidq_prev_mat_in_AZ_J3 = 32'd839;  dfidq_prev_mat_in_AZ_J4 = 32'd23; dfidq_prev_mat_in_AZ_J5 = -32'd794; dfidq_prev_mat_in_AZ_J6 = -32'd389; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd32323; dfidq_prev_mat_in_LX_J3 = -32'd160291;  dfidq_prev_mat_in_LX_J4 = -32'd90398; dfidq_prev_mat_in_LX_J5 = 32'd80218; dfidq_prev_mat_in_LX_J6 = -32'd77343; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd111481; dfidq_prev_mat_in_LY_J3 = 32'd77173;  dfidq_prev_mat_in_LY_J4 = 32'd64413; dfidq_prev_mat_in_LY_J5 = -32'd25932; dfidq_prev_mat_in_LY_J6 = -32'd128801; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd49161; dfidq_prev_mat_in_LZ_J3 = 32'd46245;  dfidq_prev_mat_in_LZ_J4 = 32'd109642; dfidq_prev_mat_in_LZ_J5 = 32'd145168; dfidq_prev_mat_in_LZ_J6 = 32'd1770; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd76; dfidqd_prev_mat_in_AX_J2 = -32'd2; dfidqd_prev_mat_in_AX_J3 = 32'd75;  dfidqd_prev_mat_in_AX_J4 = -32'd411; dfidqd_prev_mat_in_AX_J5 = 32'd337; dfidqd_prev_mat_in_AX_J6 = 32'd906; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd36; dfidqd_prev_mat_in_AY_J2 = -32'd40; dfidqd_prev_mat_in_AY_J3 = -32'd44;  dfidqd_prev_mat_in_AY_J4 = 32'd186; dfidqd_prev_mat_in_AY_J5 = -32'd85; dfidqd_prev_mat_in_AY_J6 = -32'd135; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd53; dfidqd_prev_mat_in_AZ_J2 = -32'd127; dfidqd_prev_mat_in_AZ_J3 = 32'd123;  dfidqd_prev_mat_in_AZ_J4 = 32'd558; dfidqd_prev_mat_in_AZ_J5 = -32'd149; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd5723; dfidqd_prev_mat_in_LX_J2 = 32'd166896; dfidqd_prev_mat_in_LX_J3 = -32'd36058;  dfidqd_prev_mat_in_LX_J4 = -32'd143888; dfidqd_prev_mat_in_LX_J5 = 32'd77; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd43324; dfidqd_prev_mat_in_LY_J2 = -32'd60969; dfidqd_prev_mat_in_LY_J3 = 32'd11058;  dfidqd_prev_mat_in_LY_J4 = -32'd9066; dfidqd_prev_mat_in_LY_J5 = -32'd92; dfidqd_prev_mat_in_LY_J6 = 32'd42; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd94049; dfidqd_prev_mat_in_LZ_J2 = 32'd24373; dfidqd_prev_mat_in_LZ_J3 = -32'd36659;  dfidqd_prev_mat_in_LZ_J4 = -32'd120581; dfidqd_prev_mat_in_LZ_J5 = -32'd164; dfidqd_prev_mat_in_LZ_J6 = 32'd321; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 7 Outputs
      $display ("// Link 7 Test");
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
      minv_prev_vec_in_C1 = -32'd66476; minv_prev_vec_in_C2 = -32'd19260; minv_prev_vec_in_C3 = 32'd2574713; minv_prev_vec_in_C4 = -32'd105892; minv_prev_vec_in_C5 = -32'd9289794; minv_prev_vec_in_C6 = -32'd204961; minv_prev_vec_in_C7 = 32'd6473895;
      // 5
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd4354; dfidq_prev_mat_in_AX_J3 = 32'd3320;  dfidq_prev_mat_in_AX_J4 = 32'd7150; dfidq_prev_mat_in_AX_J5 = 32'd10972; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd4610; dfidq_prev_mat_in_AY_J3 = -32'd12747;  dfidq_prev_mat_in_AY_J4 = -32'd7214; dfidq_prev_mat_in_AY_J5 = 32'd5786; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd1038; dfidq_prev_mat_in_AZ_J3 = 32'd2853;  dfidq_prev_mat_in_AZ_J4 = 32'd1647; dfidq_prev_mat_in_AZ_J5 = -32'd564; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd48590; dfidq_prev_mat_in_LX_J3 = -32'd137401;  dfidq_prev_mat_in_LX_J4 = -32'd65942; dfidq_prev_mat_in_LX_J5 = 32'd23191; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd45129; dfidq_prev_mat_in_LY_J3 = -32'd36066;  dfidq_prev_mat_in_LY_J4 = -32'd70817; dfidq_prev_mat_in_LY_J5 = -32'd96617; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd62580; dfidq_prev_mat_in_LZ_J3 = 32'd13151;  dfidq_prev_mat_in_LZ_J4 = -32'd4659; dfidq_prev_mat_in_LZ_J5 = 32'd7121; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd5945; dfidqd_prev_mat_in_AX_J2 = 32'd1309; dfidqd_prev_mat_in_AX_J3 = -32'd1513;  dfidqd_prev_mat_in_AX_J4 = -32'd8879; dfidqd_prev_mat_in_AX_J5 = 32'd1237; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd1314; dfidqd_prev_mat_in_AY_J2 = 32'd12420; dfidqd_prev_mat_in_AY_J3 = -32'd2697;  dfidqd_prev_mat_in_AY_J4 = -32'd9465; dfidqd_prev_mat_in_AY_J5 = 32'd16; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd394; dfidqd_prev_mat_in_AZ_J2 = -32'd3077; dfidqd_prev_mat_in_AZ_J3 = 32'd491;  dfidqd_prev_mat_in_AZ_J4 = 32'd2025; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd20251; dfidqd_prev_mat_in_LX_J2 = 32'd140948; dfidqd_prev_mat_in_LX_J3 = -32'd23281;  dfidqd_prev_mat_in_LX_J4 = -32'd84990; dfidqd_prev_mat_in_LX_J5 = -32'd52; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd57716; dfidqd_prev_mat_in_LY_J2 = -32'd18551; dfidqd_prev_mat_in_LY_J3 = 32'd11438;  dfidqd_prev_mat_in_LY_J4 = 32'd73710; dfidqd_prev_mat_in_LY_J5 = -32'd10981; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd24770; dfidqd_prev_mat_in_LZ_J2 = -32'd13522; dfidqd_prev_mat_in_LZ_J3 = 32'd1380;  dfidqd_prev_mat_in_LZ_J4 = -32'd31010; dfidqd_prev_mat_in_LZ_J5 = 32'd3378; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 6 Outputs
      $display ("// Link 6 Test");
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
      minv_prev_vec_in_C1 = 32'd193436; minv_prev_vec_in_C2 = -32'd122649; minv_prev_vec_in_C3 = -32'd201513; minv_prev_vec_in_C4 = -32'd437695; minv_prev_vec_in_C5 = -32'd105892; minv_prev_vec_in_C6 = -32'd358665; minv_prev_vec_in_C7 = 32'd187088;
      // 4
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd826; dfidq_prev_mat_in_AX_J3 = 32'd8949;  dfidq_prev_mat_in_AX_J4 = 32'd1941; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd2678; dfidq_prev_mat_in_AY_J3 = 32'd4680;  dfidq_prev_mat_in_AY_J4 = 32'd1622; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd5904; dfidq_prev_mat_in_AZ_J3 = -32'd12157;  dfidq_prev_mat_in_AZ_J4 = -32'd6891; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd76136; dfidq_prev_mat_in_LX_J3 = 32'd136829;  dfidq_prev_mat_in_LX_J4 = 32'd35836; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd55811; dfidq_prev_mat_in_LY_J3 = -32'd9425;  dfidq_prev_mat_in_LY_J4 = -32'd53266; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd3436; dfidq_prev_mat_in_LZ_J3 = 32'd89127;  dfidq_prev_mat_in_LZ_J4 = 32'd1368; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1436; dfidqd_prev_mat_in_AX_J2 = -32'd9457; dfidqd_prev_mat_in_AX_J3 = 32'd1126;  dfidqd_prev_mat_in_AX_J4 = 32'd9615; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd2460; dfidqd_prev_mat_in_AY_J2 = -32'd3074; dfidqd_prev_mat_in_AY_J3 = -32'd13;  dfidqd_prev_mat_in_AY_J4 = 32'd277; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd5950; dfidqd_prev_mat_in_AZ_J2 = 32'd7332; dfidqd_prev_mat_in_AZ_J3 = -32'd181;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd73332; dfidqd_prev_mat_in_LX_J2 = -32'd89415; dfidqd_prev_mat_in_LX_J3 = -32'd473;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22838; dfidqd_prev_mat_in_LY_J2 = -32'd43368; dfidqd_prev_mat_in_LY_J3 = -32'd94;  dfidqd_prev_mat_in_LY_J4 = -32'd13222; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd10554; dfidqd_prev_mat_in_LZ_J2 = -32'd135202; dfidqd_prev_mat_in_LZ_J3 = -32'd9858;  dfidqd_prev_mat_in_LZ_J4 = 32'd45277; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 5 Outputs
      $display ("// Link 5 Test");
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
      minv_prev_vec_in_C1 = 32'd212790; minv_prev_vec_in_C2 = -32'd42572; minv_prev_vec_in_C3 = -32'd2752466; minv_prev_vec_in_C4 = -32'd201513; minv_prev_vec_in_C5 = 32'd2574713; minv_prev_vec_in_C6 = -32'd45311; minv_prev_vec_in_C7 = 32'd12325;
      // 3
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd2621; dfidq_prev_mat_in_AX_J3 = 32'd15599;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd10348; dfidq_prev_mat_in_AY_J3 = 32'd21009;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd1137; dfidq_prev_mat_in_AZ_J3 = -32'd2999;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd51071; dfidq_prev_mat_in_LX_J3 = 32'd102173;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd1313; dfidq_prev_mat_in_LY_J3 = -32'd68019;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd57033; dfidq_prev_mat_in_LZ_J3 = 32'd16263;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1897; dfidqd_prev_mat_in_AX_J2 = -32'd19915; dfidqd_prev_mat_in_AX_J3 = 32'd2933;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd10769; dfidqd_prev_mat_in_AY_J2 = -32'd13702; dfidqd_prev_mat_in_AY_J3 = 32'd147;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd1521; dfidqd_prev_mat_in_AZ_J2 = 32'd1936; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd53805; dfidqd_prev_mat_in_LX_J2 = -32'd68646; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22821; dfidqd_prev_mat_in_LY_J2 = 32'd97882; dfidqd_prev_mat_in_LY_J3 = -32'd22583;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd23054; dfidqd_prev_mat_in_LZ_J2 = -32'd23480; dfidqd_prev_mat_in_LZ_J3 = -32'd22;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 4 Outputs
      $display ("// Link 4 Test");
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
      minv_prev_vec_in_C1 = 32'd54563; minv_prev_vec_in_C2 = -32'd53716; minv_prev_vec_in_C3 = -32'd42572; minv_prev_vec_in_C4 = -32'd122649; minv_prev_vec_in_C5 = -32'd19260; minv_prev_vec_in_C6 = -32'd89991; minv_prev_vec_in_C7 = 32'd23027;
      // 2
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd2709; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd126; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd2017; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd8454; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd17508; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd6786; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd469; dfidqd_prev_mat_in_AX_J2 = 32'd6644; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd375; dfidqd_prev_mat_in_AY_J2 = -32'd304; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd2077; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd10572; dfidqd_prev_mat_in_LX_J2 = -32'd40; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd4252; dfidqd_prev_mat_in_LY_J2 = -32'd7785; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd14781; dfidqd_prev_mat_in_LZ_J2 = 32'd28755; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 3 Outputs
      $display ("// Link 3 Test");
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
      minv_prev_vec_in_C1 = -32'd216819; minv_prev_vec_in_C2 = 32'd54563; minv_prev_vec_in_C3 = 32'd212790; minv_prev_vec_in_C4 = 32'd193436; minv_prev_vec_in_C5 = -32'd66476; minv_prev_vec_in_C6 = -32'd25864; minv_prev_vec_in_C7 = 32'd21064;
      // 1
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd1887; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd15727; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 2 Outputs
      $display ("// Link 2 Test");
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
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0;
      // 0
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // Hold for 3 cycles for Link 1 Outputs
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 2
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 1
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 1 Outputs
      $display ("// Link 1 Test");
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
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
      //------------------------------------------------------------------------
      // set values
      //------------------------------------------------------------------------
      $display ("// Knot 4 Link 8 Init");
      //------------------------------------------------------------------------
      // Link 8 Inputs
      // 7
      sinq_prev_in = 32'd49084; cosq_prev_in = -32'd43424;
      f_prev_vec_in_AX = 32'd8044; f_prev_vec_in_AY = -32'd6533; f_prev_vec_in_AZ = 32'd5043; f_prev_vec_in_LX = -32'd120315; f_prev_vec_in_LY = -32'd133594; f_prev_vec_in_LZ = -32'd13832;
      // 7
      // minv_prev_vec_in_C1 = 0.321418; minv_prev_vec_in_C2 = 0.35137; minv_prev_vec_in_C3 = 0.188062; minv_prev_vec_in_C4 = 2.85474; minv_prev_vec_in_C5 = 98.7838; minv_prev_vec_in_C6 = 4.79672; minv_prev_vec_in_C7 = -1095.04;
      minv_prev_vec_in_C1 = 32'd21064; minv_prev_vec_in_C2 = 32'd23027; minv_prev_vec_in_C3 = 32'd12325; minv_prev_vec_in_C4 = 32'd187088; minv_prev_vec_in_C5 = 32'd6473895; minv_prev_vec_in_C6 = 32'd314358; minv_prev_vec_in_C7 = -32'd71764541;
      // 7
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd155; dfidq_prev_mat_in_AX_J3 = 32'd691;  dfidq_prev_mat_in_AX_J4 = 32'd463; dfidq_prev_mat_in_AX_J5 = 32'd126; dfidq_prev_mat_in_AX_J6 = 32'd1874; dfidq_prev_mat_in_AX_J7 = -32'd6533;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd52; dfidq_prev_mat_in_AY_J3 = -32'd424;  dfidq_prev_mat_in_AY_J4 = 32'd142; dfidq_prev_mat_in_AY_J5 = 32'd895; dfidq_prev_mat_in_AY_J6 = 32'd1840; dfidq_prev_mat_in_AY_J7 = -32'd8044;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd35; dfidq_prev_mat_in_AZ_J3 = -32'd3;  dfidq_prev_mat_in_AZ_J4 = 32'd72; dfidq_prev_mat_in_AZ_J5 = -32'd75; dfidq_prev_mat_in_AZ_J6 = -32'd454; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd3285; dfidq_prev_mat_in_LX_J3 = -32'd13804;  dfidq_prev_mat_in_LX_J4 = 32'd6498; dfidq_prev_mat_in_LX_J5 = 32'd35032; dfidq_prev_mat_in_LX_J6 = 32'd34895; dfidq_prev_mat_in_LX_J7 = -32'd133594;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd10772; dfidq_prev_mat_in_LY_J3 = -32'd28595;  dfidq_prev_mat_in_LY_J4 = -32'd29148; dfidq_prev_mat_in_LY_J5 = -32'd4116; dfidq_prev_mat_in_LY_J6 = -32'd35504; dfidq_prev_mat_in_LY_J7 = 32'd120316;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd19629; dfidq_prev_mat_in_LZ_J3 = 32'd12420;  dfidq_prev_mat_in_LZ_J4 = 32'd15012; dfidq_prev_mat_in_LZ_J5 = -32'd6108; dfidq_prev_mat_in_LZ_J6 = -32'd26838; dfidq_prev_mat_in_LZ_J7 = -32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd204; dfidqd_prev_mat_in_AX_J2 = -32'd355; dfidqd_prev_mat_in_AX_J3 = 32'd58;  dfidqd_prev_mat_in_AX_J4 = 32'd128; dfidqd_prev_mat_in_AX_J5 = 32'd34; dfidqd_prev_mat_in_AX_J6 = 32'd184; dfidqd_prev_mat_in_AX_J7 = 32'd43;
      dfidqd_prev_mat_in_AY_J1 = -32'd186; dfidqd_prev_mat_in_AY_J2 = 32'd404; dfidqd_prev_mat_in_AY_J3 = -32'd176;  dfidqd_prev_mat_in_AY_J4 = -32'd786; dfidqd_prev_mat_in_AY_J5 = 32'd108; dfidqd_prev_mat_in_AY_J6 = 32'd208; dfidqd_prev_mat_in_AY_J7 = -32'd12;
      dfidqd_prev_mat_in_AZ_J1 = -32'd9; dfidqd_prev_mat_in_AZ_J2 = -32'd29; dfidqd_prev_mat_in_AZ_J3 = -32'd8;  dfidqd_prev_mat_in_AZ_J4 = 32'd69; dfidqd_prev_mat_in_AZ_J5 = -32'd23; dfidqd_prev_mat_in_AZ_J6 = -32'd41; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd10435; dfidqd_prev_mat_in_LX_J2 = 32'd23638; dfidqd_prev_mat_in_LX_J3 = -32'd7656;  dfidqd_prev_mat_in_LX_J4 = -32'd37658; dfidqd_prev_mat_in_LX_J5 = 32'd3027; dfidqd_prev_mat_in_LX_J6 = 32'd6737; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd13340; dfidqd_prev_mat_in_LY_J2 = 32'd20050; dfidqd_prev_mat_in_LY_J3 = 32'd289;  dfidqd_prev_mat_in_LY_J4 = -32'd5454; dfidqd_prev_mat_in_LY_J5 = 32'd998; dfidqd_prev_mat_in_LY_J6 = -32'd5960; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd8477; dfidqd_prev_mat_in_LZ_J2 = -32'd12323; dfidqd_prev_mat_in_LZ_J3 = 32'd1071;  dfidqd_prev_mat_in_LZ_J4 = -32'd549; dfidqd_prev_mat_in_LZ_J5 = -32'd757; dfidqd_prev_mat_in_LZ_J6 = 32'd1182; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Ignore Outputs
      //------------------------------------------------------------------------
      // Link 7 Inputs
      // 6
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      // 6
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = -32'd25864; minv_prev_vec_in_C2 = -32'd89991; minv_prev_vec_in_C3 = -32'd45311; minv_prev_vec_in_C4 = -32'd358665; minv_prev_vec_in_C5 = -32'd204961; minv_prev_vec_in_C6 = -32'd8039236; minv_prev_vec_in_C7 = 32'd314358;
      // 6
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd284; dfidq_prev_mat_in_AX_J3 = -32'd35;  dfidq_prev_mat_in_AX_J4 = 32'd259; dfidq_prev_mat_in_AX_J5 = 32'd931; dfidq_prev_mat_in_AX_J6 = 32'd8200; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd123; dfidq_prev_mat_in_AY_J3 = -32'd73;  dfidq_prev_mat_in_AY_J4 = 32'd247; dfidq_prev_mat_in_AY_J5 = -32'd245; dfidq_prev_mat_in_AY_J6 = -32'd1679; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd151; dfidq_prev_mat_in_AZ_J3 = 32'd839;  dfidq_prev_mat_in_AZ_J4 = 32'd23; dfidq_prev_mat_in_AZ_J5 = -32'd794; dfidq_prev_mat_in_AZ_J6 = -32'd389; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd32323; dfidq_prev_mat_in_LX_J3 = -32'd160291;  dfidq_prev_mat_in_LX_J4 = -32'd90398; dfidq_prev_mat_in_LX_J5 = 32'd80218; dfidq_prev_mat_in_LX_J6 = -32'd77343; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd111481; dfidq_prev_mat_in_LY_J3 = 32'd77173;  dfidq_prev_mat_in_LY_J4 = 32'd64413; dfidq_prev_mat_in_LY_J5 = -32'd25932; dfidq_prev_mat_in_LY_J6 = -32'd128801; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd49161; dfidq_prev_mat_in_LZ_J3 = 32'd46245;  dfidq_prev_mat_in_LZ_J4 = 32'd109642; dfidq_prev_mat_in_LZ_J5 = 32'd145168; dfidq_prev_mat_in_LZ_J6 = 32'd1770; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd76; dfidqd_prev_mat_in_AX_J2 = -32'd2; dfidqd_prev_mat_in_AX_J3 = 32'd75;  dfidqd_prev_mat_in_AX_J4 = -32'd411; dfidqd_prev_mat_in_AX_J5 = 32'd337; dfidqd_prev_mat_in_AX_J6 = 32'd906; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd36; dfidqd_prev_mat_in_AY_J2 = -32'd40; dfidqd_prev_mat_in_AY_J3 = -32'd44;  dfidqd_prev_mat_in_AY_J4 = 32'd186; dfidqd_prev_mat_in_AY_J5 = -32'd85; dfidqd_prev_mat_in_AY_J6 = -32'd135; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd53; dfidqd_prev_mat_in_AZ_J2 = -32'd127; dfidqd_prev_mat_in_AZ_J3 = 32'd123;  dfidqd_prev_mat_in_AZ_J4 = 32'd558; dfidqd_prev_mat_in_AZ_J5 = -32'd149; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd5723; dfidqd_prev_mat_in_LX_J2 = 32'd166896; dfidqd_prev_mat_in_LX_J3 = -32'd36058;  dfidqd_prev_mat_in_LX_J4 = -32'd143888; dfidqd_prev_mat_in_LX_J5 = 32'd77; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd43324; dfidqd_prev_mat_in_LY_J2 = -32'd60969; dfidqd_prev_mat_in_LY_J3 = 32'd11058;  dfidqd_prev_mat_in_LY_J4 = -32'd9066; dfidqd_prev_mat_in_LY_J5 = -32'd92; dfidqd_prev_mat_in_LY_J6 = 32'd42; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd94049; dfidqd_prev_mat_in_LZ_J2 = 32'd24373; dfidqd_prev_mat_in_LZ_J3 = -32'd36659;  dfidqd_prev_mat_in_LZ_J4 = -32'd120581; dfidqd_prev_mat_in_LZ_J5 = -32'd164; dfidqd_prev_mat_in_LZ_J6 = 32'd321; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 7 Outputs
      $display ("// Link 7 Test");
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
      minv_prev_vec_in_C1 = -32'd66476; minv_prev_vec_in_C2 = -32'd19260; minv_prev_vec_in_C3 = 32'd2574713; minv_prev_vec_in_C4 = -32'd105892; minv_prev_vec_in_C5 = -32'd9289794; minv_prev_vec_in_C6 = -32'd204961; minv_prev_vec_in_C7 = 32'd6473895;
      // 5
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd4354; dfidq_prev_mat_in_AX_J3 = 32'd3320;  dfidq_prev_mat_in_AX_J4 = 32'd7150; dfidq_prev_mat_in_AX_J5 = 32'd10972; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd4610; dfidq_prev_mat_in_AY_J3 = -32'd12747;  dfidq_prev_mat_in_AY_J4 = -32'd7214; dfidq_prev_mat_in_AY_J5 = 32'd5786; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd1038; dfidq_prev_mat_in_AZ_J3 = 32'd2853;  dfidq_prev_mat_in_AZ_J4 = 32'd1647; dfidq_prev_mat_in_AZ_J5 = -32'd564; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd48590; dfidq_prev_mat_in_LX_J3 = -32'd137401;  dfidq_prev_mat_in_LX_J4 = -32'd65942; dfidq_prev_mat_in_LX_J5 = 32'd23191; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd45129; dfidq_prev_mat_in_LY_J3 = -32'd36066;  dfidq_prev_mat_in_LY_J4 = -32'd70817; dfidq_prev_mat_in_LY_J5 = -32'd96617; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd62580; dfidq_prev_mat_in_LZ_J3 = 32'd13151;  dfidq_prev_mat_in_LZ_J4 = -32'd4659; dfidq_prev_mat_in_LZ_J5 = 32'd7121; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd5945; dfidqd_prev_mat_in_AX_J2 = 32'd1309; dfidqd_prev_mat_in_AX_J3 = -32'd1513;  dfidqd_prev_mat_in_AX_J4 = -32'd8879; dfidqd_prev_mat_in_AX_J5 = 32'd1237; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd1314; dfidqd_prev_mat_in_AY_J2 = 32'd12420; dfidqd_prev_mat_in_AY_J3 = -32'd2697;  dfidqd_prev_mat_in_AY_J4 = -32'd9465; dfidqd_prev_mat_in_AY_J5 = 32'd16; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd394; dfidqd_prev_mat_in_AZ_J2 = -32'd3077; dfidqd_prev_mat_in_AZ_J3 = 32'd491;  dfidqd_prev_mat_in_AZ_J4 = 32'd2025; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd20251; dfidqd_prev_mat_in_LX_J2 = 32'd140948; dfidqd_prev_mat_in_LX_J3 = -32'd23281;  dfidqd_prev_mat_in_LX_J4 = -32'd84990; dfidqd_prev_mat_in_LX_J5 = -32'd52; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd57716; dfidqd_prev_mat_in_LY_J2 = -32'd18551; dfidqd_prev_mat_in_LY_J3 = 32'd11438;  dfidqd_prev_mat_in_LY_J4 = 32'd73710; dfidqd_prev_mat_in_LY_J5 = -32'd10981; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd24770; dfidqd_prev_mat_in_LZ_J2 = -32'd13522; dfidqd_prev_mat_in_LZ_J3 = 32'd1380;  dfidqd_prev_mat_in_LZ_J4 = -32'd31010; dfidqd_prev_mat_in_LZ_J5 = 32'd3378; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 6 Outputs
      $display ("// Link 6 Test");
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
      minv_prev_vec_in_C1 = 32'd193436; minv_prev_vec_in_C2 = -32'd122649; minv_prev_vec_in_C3 = -32'd201513; minv_prev_vec_in_C4 = -32'd437695; minv_prev_vec_in_C5 = -32'd105892; minv_prev_vec_in_C6 = -32'd358665; minv_prev_vec_in_C7 = 32'd187088;
      // 4
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd826; dfidq_prev_mat_in_AX_J3 = 32'd8949;  dfidq_prev_mat_in_AX_J4 = 32'd1941; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd2678; dfidq_prev_mat_in_AY_J3 = 32'd4680;  dfidq_prev_mat_in_AY_J4 = 32'd1622; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd5904; dfidq_prev_mat_in_AZ_J3 = -32'd12157;  dfidq_prev_mat_in_AZ_J4 = -32'd6891; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd76136; dfidq_prev_mat_in_LX_J3 = 32'd136829;  dfidq_prev_mat_in_LX_J4 = 32'd35836; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd55811; dfidq_prev_mat_in_LY_J3 = -32'd9425;  dfidq_prev_mat_in_LY_J4 = -32'd53266; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd3436; dfidq_prev_mat_in_LZ_J3 = 32'd89127;  dfidq_prev_mat_in_LZ_J4 = 32'd1368; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1436; dfidqd_prev_mat_in_AX_J2 = -32'd9457; dfidqd_prev_mat_in_AX_J3 = 32'd1126;  dfidqd_prev_mat_in_AX_J4 = 32'd9615; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd2460; dfidqd_prev_mat_in_AY_J2 = -32'd3074; dfidqd_prev_mat_in_AY_J3 = -32'd13;  dfidqd_prev_mat_in_AY_J4 = 32'd277; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd5950; dfidqd_prev_mat_in_AZ_J2 = 32'd7332; dfidqd_prev_mat_in_AZ_J3 = -32'd181;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd73332; dfidqd_prev_mat_in_LX_J2 = -32'd89415; dfidqd_prev_mat_in_LX_J3 = -32'd473;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22838; dfidqd_prev_mat_in_LY_J2 = -32'd43368; dfidqd_prev_mat_in_LY_J3 = -32'd94;  dfidqd_prev_mat_in_LY_J4 = -32'd13222; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd10554; dfidqd_prev_mat_in_LZ_J2 = -32'd135202; dfidqd_prev_mat_in_LZ_J3 = -32'd9858;  dfidqd_prev_mat_in_LZ_J4 = 32'd45277; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 5 Outputs
      $display ("// Link 5 Test");
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
      minv_prev_vec_in_C1 = 32'd212790; minv_prev_vec_in_C2 = -32'd42572; minv_prev_vec_in_C3 = -32'd2752466; minv_prev_vec_in_C4 = -32'd201513; minv_prev_vec_in_C5 = 32'd2574713; minv_prev_vec_in_C6 = -32'd45311; minv_prev_vec_in_C7 = 32'd12325;
      // 3
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd2621; dfidq_prev_mat_in_AX_J3 = 32'd15599;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd10348; dfidq_prev_mat_in_AY_J3 = 32'd21009;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd1137; dfidq_prev_mat_in_AZ_J3 = -32'd2999;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd51071; dfidq_prev_mat_in_LX_J3 = 32'd102173;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd1313; dfidq_prev_mat_in_LY_J3 = -32'd68019;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd57033; dfidq_prev_mat_in_LZ_J3 = 32'd16263;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1897; dfidqd_prev_mat_in_AX_J2 = -32'd19915; dfidqd_prev_mat_in_AX_J3 = 32'd2933;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd10769; dfidqd_prev_mat_in_AY_J2 = -32'd13702; dfidqd_prev_mat_in_AY_J3 = 32'd147;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd1521; dfidqd_prev_mat_in_AZ_J2 = 32'd1936; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd53805; dfidqd_prev_mat_in_LX_J2 = -32'd68646; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22821; dfidqd_prev_mat_in_LY_J2 = 32'd97882; dfidqd_prev_mat_in_LY_J3 = -32'd22583;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd23054; dfidqd_prev_mat_in_LZ_J2 = -32'd23480; dfidqd_prev_mat_in_LZ_J3 = -32'd22;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 4 Outputs
      $display ("// Link 4 Test");
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
      minv_prev_vec_in_C1 = 32'd54563; minv_prev_vec_in_C2 = -32'd53716; minv_prev_vec_in_C3 = -32'd42572; minv_prev_vec_in_C4 = -32'd122649; minv_prev_vec_in_C5 = -32'd19260; minv_prev_vec_in_C6 = -32'd89991; minv_prev_vec_in_C7 = 32'd23027;
      // 2
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd2709; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd126; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd2017; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd8454; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd17508; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd6786; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd469; dfidqd_prev_mat_in_AX_J2 = 32'd6644; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd375; dfidqd_prev_mat_in_AY_J2 = -32'd304; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd2077; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd10572; dfidqd_prev_mat_in_LX_J2 = -32'd40; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd4252; dfidqd_prev_mat_in_LY_J2 = -32'd7785; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd14781; dfidqd_prev_mat_in_LZ_J2 = 32'd28755; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 3 Outputs
      $display ("// Link 3 Test");
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
      minv_prev_vec_in_C1 = -32'd216819; minv_prev_vec_in_C2 = 32'd54563; minv_prev_vec_in_C3 = 32'd212790; minv_prev_vec_in_C4 = 32'd193436; minv_prev_vec_in_C5 = -32'd66476; minv_prev_vec_in_C6 = -32'd25864; minv_prev_vec_in_C7 = 32'd21064;
      // 1
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd1887; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd15727; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 2 Outputs
      $display ("// Link 2 Test");
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
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0;
      // 0
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // Hold for 3 cycles for Link 1 Outputs
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 2
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 1
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 1 Outputs
      $display ("// Link 1 Test");
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
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
      //------------------------------------------------------------------------
      // set values
      //------------------------------------------------------------------------
      $display ("// Knot 5 Link 8 Init");
      //------------------------------------------------------------------------
      // Link 8 Inputs
      // 7
      sinq_prev_in = 32'd49084; cosq_prev_in = -32'd43424;
      f_prev_vec_in_AX = 32'd8044; f_prev_vec_in_AY = -32'd6533; f_prev_vec_in_AZ = 32'd5043; f_prev_vec_in_LX = -32'd120315; f_prev_vec_in_LY = -32'd133594; f_prev_vec_in_LZ = -32'd13832;
      // 7
      // minv_prev_vec_in_C1 = 0.321418; minv_prev_vec_in_C2 = 0.35137; minv_prev_vec_in_C3 = 0.188062; minv_prev_vec_in_C4 = 2.85474; minv_prev_vec_in_C5 = 98.7838; minv_prev_vec_in_C6 = 4.79672; minv_prev_vec_in_C7 = -1095.04;
      minv_prev_vec_in_C1 = 32'd21064; minv_prev_vec_in_C2 = 32'd23027; minv_prev_vec_in_C3 = 32'd12325; minv_prev_vec_in_C4 = 32'd187088; minv_prev_vec_in_C5 = 32'd6473895; minv_prev_vec_in_C6 = 32'd314358; minv_prev_vec_in_C7 = -32'd71764541;
      // 7
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd155; dfidq_prev_mat_in_AX_J3 = 32'd691;  dfidq_prev_mat_in_AX_J4 = 32'd463; dfidq_prev_mat_in_AX_J5 = 32'd126; dfidq_prev_mat_in_AX_J6 = 32'd1874; dfidq_prev_mat_in_AX_J7 = -32'd6533;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd52; dfidq_prev_mat_in_AY_J3 = -32'd424;  dfidq_prev_mat_in_AY_J4 = 32'd142; dfidq_prev_mat_in_AY_J5 = 32'd895; dfidq_prev_mat_in_AY_J6 = 32'd1840; dfidq_prev_mat_in_AY_J7 = -32'd8044;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd35; dfidq_prev_mat_in_AZ_J3 = -32'd3;  dfidq_prev_mat_in_AZ_J4 = 32'd72; dfidq_prev_mat_in_AZ_J5 = -32'd75; dfidq_prev_mat_in_AZ_J6 = -32'd454; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd3285; dfidq_prev_mat_in_LX_J3 = -32'd13804;  dfidq_prev_mat_in_LX_J4 = 32'd6498; dfidq_prev_mat_in_LX_J5 = 32'd35032; dfidq_prev_mat_in_LX_J6 = 32'd34895; dfidq_prev_mat_in_LX_J7 = -32'd133594;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd10772; dfidq_prev_mat_in_LY_J3 = -32'd28595;  dfidq_prev_mat_in_LY_J4 = -32'd29148; dfidq_prev_mat_in_LY_J5 = -32'd4116; dfidq_prev_mat_in_LY_J6 = -32'd35504; dfidq_prev_mat_in_LY_J7 = 32'd120316;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd19629; dfidq_prev_mat_in_LZ_J3 = 32'd12420;  dfidq_prev_mat_in_LZ_J4 = 32'd15012; dfidq_prev_mat_in_LZ_J5 = -32'd6108; dfidq_prev_mat_in_LZ_J6 = -32'd26838; dfidq_prev_mat_in_LZ_J7 = -32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd204; dfidqd_prev_mat_in_AX_J2 = -32'd355; dfidqd_prev_mat_in_AX_J3 = 32'd58;  dfidqd_prev_mat_in_AX_J4 = 32'd128; dfidqd_prev_mat_in_AX_J5 = 32'd34; dfidqd_prev_mat_in_AX_J6 = 32'd184; dfidqd_prev_mat_in_AX_J7 = 32'd43;
      dfidqd_prev_mat_in_AY_J1 = -32'd186; dfidqd_prev_mat_in_AY_J2 = 32'd404; dfidqd_prev_mat_in_AY_J3 = -32'd176;  dfidqd_prev_mat_in_AY_J4 = -32'd786; dfidqd_prev_mat_in_AY_J5 = 32'd108; dfidqd_prev_mat_in_AY_J6 = 32'd208; dfidqd_prev_mat_in_AY_J7 = -32'd12;
      dfidqd_prev_mat_in_AZ_J1 = -32'd9; dfidqd_prev_mat_in_AZ_J2 = -32'd29; dfidqd_prev_mat_in_AZ_J3 = -32'd8;  dfidqd_prev_mat_in_AZ_J4 = 32'd69; dfidqd_prev_mat_in_AZ_J5 = -32'd23; dfidqd_prev_mat_in_AZ_J6 = -32'd41; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd10435; dfidqd_prev_mat_in_LX_J2 = 32'd23638; dfidqd_prev_mat_in_LX_J3 = -32'd7656;  dfidqd_prev_mat_in_LX_J4 = -32'd37658; dfidqd_prev_mat_in_LX_J5 = 32'd3027; dfidqd_prev_mat_in_LX_J6 = 32'd6737; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd13340; dfidqd_prev_mat_in_LY_J2 = 32'd20050; dfidqd_prev_mat_in_LY_J3 = 32'd289;  dfidqd_prev_mat_in_LY_J4 = -32'd5454; dfidqd_prev_mat_in_LY_J5 = 32'd998; dfidqd_prev_mat_in_LY_J6 = -32'd5960; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd8477; dfidqd_prev_mat_in_LZ_J2 = -32'd12323; dfidqd_prev_mat_in_LZ_J3 = 32'd1071;  dfidqd_prev_mat_in_LZ_J4 = -32'd549; dfidqd_prev_mat_in_LZ_J5 = -32'd757; dfidqd_prev_mat_in_LZ_J6 = 32'd1182; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Ignore Outputs
      //------------------------------------------------------------------------
      // Link 7 Inputs
      // 6
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      // 6
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = -32'd25864; minv_prev_vec_in_C2 = -32'd89991; minv_prev_vec_in_C3 = -32'd45311; minv_prev_vec_in_C4 = -32'd358665; minv_prev_vec_in_C5 = -32'd204961; minv_prev_vec_in_C6 = -32'd8039236; minv_prev_vec_in_C7 = 32'd314358;
      // 6
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd284; dfidq_prev_mat_in_AX_J3 = -32'd35;  dfidq_prev_mat_in_AX_J4 = 32'd259; dfidq_prev_mat_in_AX_J5 = 32'd931; dfidq_prev_mat_in_AX_J6 = 32'd8200; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd123; dfidq_prev_mat_in_AY_J3 = -32'd73;  dfidq_prev_mat_in_AY_J4 = 32'd247; dfidq_prev_mat_in_AY_J5 = -32'd245; dfidq_prev_mat_in_AY_J6 = -32'd1679; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd151; dfidq_prev_mat_in_AZ_J3 = 32'd839;  dfidq_prev_mat_in_AZ_J4 = 32'd23; dfidq_prev_mat_in_AZ_J5 = -32'd794; dfidq_prev_mat_in_AZ_J6 = -32'd389; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd32323; dfidq_prev_mat_in_LX_J3 = -32'd160291;  dfidq_prev_mat_in_LX_J4 = -32'd90398; dfidq_prev_mat_in_LX_J5 = 32'd80218; dfidq_prev_mat_in_LX_J6 = -32'd77343; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd111481; dfidq_prev_mat_in_LY_J3 = 32'd77173;  dfidq_prev_mat_in_LY_J4 = 32'd64413; dfidq_prev_mat_in_LY_J5 = -32'd25932; dfidq_prev_mat_in_LY_J6 = -32'd128801; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd49161; dfidq_prev_mat_in_LZ_J3 = 32'd46245;  dfidq_prev_mat_in_LZ_J4 = 32'd109642; dfidq_prev_mat_in_LZ_J5 = 32'd145168; dfidq_prev_mat_in_LZ_J6 = 32'd1770; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd76; dfidqd_prev_mat_in_AX_J2 = -32'd2; dfidqd_prev_mat_in_AX_J3 = 32'd75;  dfidqd_prev_mat_in_AX_J4 = -32'd411; dfidqd_prev_mat_in_AX_J5 = 32'd337; dfidqd_prev_mat_in_AX_J6 = 32'd906; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd36; dfidqd_prev_mat_in_AY_J2 = -32'd40; dfidqd_prev_mat_in_AY_J3 = -32'd44;  dfidqd_prev_mat_in_AY_J4 = 32'd186; dfidqd_prev_mat_in_AY_J5 = -32'd85; dfidqd_prev_mat_in_AY_J6 = -32'd135; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd53; dfidqd_prev_mat_in_AZ_J2 = -32'd127; dfidqd_prev_mat_in_AZ_J3 = 32'd123;  dfidqd_prev_mat_in_AZ_J4 = 32'd558; dfidqd_prev_mat_in_AZ_J5 = -32'd149; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd5723; dfidqd_prev_mat_in_LX_J2 = 32'd166896; dfidqd_prev_mat_in_LX_J3 = -32'd36058;  dfidqd_prev_mat_in_LX_J4 = -32'd143888; dfidqd_prev_mat_in_LX_J5 = 32'd77; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd43324; dfidqd_prev_mat_in_LY_J2 = -32'd60969; dfidqd_prev_mat_in_LY_J3 = 32'd11058;  dfidqd_prev_mat_in_LY_J4 = -32'd9066; dfidqd_prev_mat_in_LY_J5 = -32'd92; dfidqd_prev_mat_in_LY_J6 = 32'd42; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd94049; dfidqd_prev_mat_in_LZ_J2 = 32'd24373; dfidqd_prev_mat_in_LZ_J3 = -32'd36659;  dfidqd_prev_mat_in_LZ_J4 = -32'd120581; dfidqd_prev_mat_in_LZ_J5 = -32'd164; dfidqd_prev_mat_in_LZ_J6 = 32'd321; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 7 Outputs
      $display ("// Link 7 Test");
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
      minv_prev_vec_in_C1 = -32'd66476; minv_prev_vec_in_C2 = -32'd19260; minv_prev_vec_in_C3 = 32'd2574713; minv_prev_vec_in_C4 = -32'd105892; minv_prev_vec_in_C5 = -32'd9289794; minv_prev_vec_in_C6 = -32'd204961; minv_prev_vec_in_C7 = 32'd6473895;
      // 5
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd4354; dfidq_prev_mat_in_AX_J3 = 32'd3320;  dfidq_prev_mat_in_AX_J4 = 32'd7150; dfidq_prev_mat_in_AX_J5 = 32'd10972; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd4610; dfidq_prev_mat_in_AY_J3 = -32'd12747;  dfidq_prev_mat_in_AY_J4 = -32'd7214; dfidq_prev_mat_in_AY_J5 = 32'd5786; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd1038; dfidq_prev_mat_in_AZ_J3 = 32'd2853;  dfidq_prev_mat_in_AZ_J4 = 32'd1647; dfidq_prev_mat_in_AZ_J5 = -32'd564; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd48590; dfidq_prev_mat_in_LX_J3 = -32'd137401;  dfidq_prev_mat_in_LX_J4 = -32'd65942; dfidq_prev_mat_in_LX_J5 = 32'd23191; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd45129; dfidq_prev_mat_in_LY_J3 = -32'd36066;  dfidq_prev_mat_in_LY_J4 = -32'd70817; dfidq_prev_mat_in_LY_J5 = -32'd96617; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd62580; dfidq_prev_mat_in_LZ_J3 = 32'd13151;  dfidq_prev_mat_in_LZ_J4 = -32'd4659; dfidq_prev_mat_in_LZ_J5 = 32'd7121; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd5945; dfidqd_prev_mat_in_AX_J2 = 32'd1309; dfidqd_prev_mat_in_AX_J3 = -32'd1513;  dfidqd_prev_mat_in_AX_J4 = -32'd8879; dfidqd_prev_mat_in_AX_J5 = 32'd1237; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd1314; dfidqd_prev_mat_in_AY_J2 = 32'd12420; dfidqd_prev_mat_in_AY_J3 = -32'd2697;  dfidqd_prev_mat_in_AY_J4 = -32'd9465; dfidqd_prev_mat_in_AY_J5 = 32'd16; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd394; dfidqd_prev_mat_in_AZ_J2 = -32'd3077; dfidqd_prev_mat_in_AZ_J3 = 32'd491;  dfidqd_prev_mat_in_AZ_J4 = 32'd2025; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd20251; dfidqd_prev_mat_in_LX_J2 = 32'd140948; dfidqd_prev_mat_in_LX_J3 = -32'd23281;  dfidqd_prev_mat_in_LX_J4 = -32'd84990; dfidqd_prev_mat_in_LX_J5 = -32'd52; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd57716; dfidqd_prev_mat_in_LY_J2 = -32'd18551; dfidqd_prev_mat_in_LY_J3 = 32'd11438;  dfidqd_prev_mat_in_LY_J4 = 32'd73710; dfidqd_prev_mat_in_LY_J5 = -32'd10981; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd24770; dfidqd_prev_mat_in_LZ_J2 = -32'd13522; dfidqd_prev_mat_in_LZ_J3 = 32'd1380;  dfidqd_prev_mat_in_LZ_J4 = -32'd31010; dfidqd_prev_mat_in_LZ_J5 = 32'd3378; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 6 Outputs
      $display ("// Link 6 Test");
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
      minv_prev_vec_in_C1 = 32'd193436; minv_prev_vec_in_C2 = -32'd122649; minv_prev_vec_in_C3 = -32'd201513; minv_prev_vec_in_C4 = -32'd437695; minv_prev_vec_in_C5 = -32'd105892; minv_prev_vec_in_C6 = -32'd358665; minv_prev_vec_in_C7 = 32'd187088;
      // 4
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd826; dfidq_prev_mat_in_AX_J3 = 32'd8949;  dfidq_prev_mat_in_AX_J4 = 32'd1941; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd2678; dfidq_prev_mat_in_AY_J3 = 32'd4680;  dfidq_prev_mat_in_AY_J4 = 32'd1622; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd5904; dfidq_prev_mat_in_AZ_J3 = -32'd12157;  dfidq_prev_mat_in_AZ_J4 = -32'd6891; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd76136; dfidq_prev_mat_in_LX_J3 = 32'd136829;  dfidq_prev_mat_in_LX_J4 = 32'd35836; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd55811; dfidq_prev_mat_in_LY_J3 = -32'd9425;  dfidq_prev_mat_in_LY_J4 = -32'd53266; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd3436; dfidq_prev_mat_in_LZ_J3 = 32'd89127;  dfidq_prev_mat_in_LZ_J4 = 32'd1368; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1436; dfidqd_prev_mat_in_AX_J2 = -32'd9457; dfidqd_prev_mat_in_AX_J3 = 32'd1126;  dfidqd_prev_mat_in_AX_J4 = 32'd9615; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd2460; dfidqd_prev_mat_in_AY_J2 = -32'd3074; dfidqd_prev_mat_in_AY_J3 = -32'd13;  dfidqd_prev_mat_in_AY_J4 = 32'd277; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd5950; dfidqd_prev_mat_in_AZ_J2 = 32'd7332; dfidqd_prev_mat_in_AZ_J3 = -32'd181;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd73332; dfidqd_prev_mat_in_LX_J2 = -32'd89415; dfidqd_prev_mat_in_LX_J3 = -32'd473;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22838; dfidqd_prev_mat_in_LY_J2 = -32'd43368; dfidqd_prev_mat_in_LY_J3 = -32'd94;  dfidqd_prev_mat_in_LY_J4 = -32'd13222; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd10554; dfidqd_prev_mat_in_LZ_J2 = -32'd135202; dfidqd_prev_mat_in_LZ_J3 = -32'd9858;  dfidqd_prev_mat_in_LZ_J4 = 32'd45277; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 5 Outputs
      $display ("// Link 5 Test");
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
      minv_prev_vec_in_C1 = 32'd212790; minv_prev_vec_in_C2 = -32'd42572; minv_prev_vec_in_C3 = -32'd2752466; minv_prev_vec_in_C4 = -32'd201513; minv_prev_vec_in_C5 = 32'd2574713; minv_prev_vec_in_C6 = -32'd45311; minv_prev_vec_in_C7 = 32'd12325;
      // 3
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd2621; dfidq_prev_mat_in_AX_J3 = 32'd15599;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd10348; dfidq_prev_mat_in_AY_J3 = 32'd21009;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd1137; dfidq_prev_mat_in_AZ_J3 = -32'd2999;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd51071; dfidq_prev_mat_in_LX_J3 = 32'd102173;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd1313; dfidq_prev_mat_in_LY_J3 = -32'd68019;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd57033; dfidq_prev_mat_in_LZ_J3 = 32'd16263;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1897; dfidqd_prev_mat_in_AX_J2 = -32'd19915; dfidqd_prev_mat_in_AX_J3 = 32'd2933;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd10769; dfidqd_prev_mat_in_AY_J2 = -32'd13702; dfidqd_prev_mat_in_AY_J3 = 32'd147;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd1521; dfidqd_prev_mat_in_AZ_J2 = 32'd1936; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd53805; dfidqd_prev_mat_in_LX_J2 = -32'd68646; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22821; dfidqd_prev_mat_in_LY_J2 = 32'd97882; dfidqd_prev_mat_in_LY_J3 = -32'd22583;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd23054; dfidqd_prev_mat_in_LZ_J2 = -32'd23480; dfidqd_prev_mat_in_LZ_J3 = -32'd22;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 4 Outputs
      $display ("// Link 4 Test");
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
      minv_prev_vec_in_C1 = 32'd54563; minv_prev_vec_in_C2 = -32'd53716; minv_prev_vec_in_C3 = -32'd42572; minv_prev_vec_in_C4 = -32'd122649; minv_prev_vec_in_C5 = -32'd19260; minv_prev_vec_in_C6 = -32'd89991; minv_prev_vec_in_C7 = 32'd23027;
      // 2
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd2709; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd126; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd2017; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd8454; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd17508; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd6786; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd469; dfidqd_prev_mat_in_AX_J2 = 32'd6644; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd375; dfidqd_prev_mat_in_AY_J2 = -32'd304; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd2077; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd10572; dfidqd_prev_mat_in_LX_J2 = -32'd40; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd4252; dfidqd_prev_mat_in_LY_J2 = -32'd7785; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd14781; dfidqd_prev_mat_in_LZ_J2 = 32'd28755; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 3 Outputs
      $display ("// Link 3 Test");
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
      minv_prev_vec_in_C1 = -32'd216819; minv_prev_vec_in_C2 = 32'd54563; minv_prev_vec_in_C3 = 32'd212790; minv_prev_vec_in_C4 = 32'd193436; minv_prev_vec_in_C5 = -32'd66476; minv_prev_vec_in_C6 = -32'd25864; minv_prev_vec_in_C7 = 32'd21064;
      // 1
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd1887; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd15727; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 2 Outputs
      $display ("// Link 2 Test");
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
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0;
      // 0
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // Hold for 3 cycles for Link 1 Outputs
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 2
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 1
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 1 Outputs
      $display ("// Link 1 Test");
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
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
      //------------------------------------------------------------------------
      // set values
      //------------------------------------------------------------------------
      $display ("// Knot 6 Link 8 Init");
      //------------------------------------------------------------------------
      // Link 8 Inputs
      // 7
      sinq_prev_in = 32'd49084; cosq_prev_in = -32'd43424;
      f_prev_vec_in_AX = 32'd8044; f_prev_vec_in_AY = -32'd6533; f_prev_vec_in_AZ = 32'd5043; f_prev_vec_in_LX = -32'd120315; f_prev_vec_in_LY = -32'd133594; f_prev_vec_in_LZ = -32'd13832;
      // 7
      // minv_prev_vec_in_C1 = 0.321418; minv_prev_vec_in_C2 = 0.35137; minv_prev_vec_in_C3 = 0.188062; minv_prev_vec_in_C4 = 2.85474; minv_prev_vec_in_C5 = 98.7838; minv_prev_vec_in_C6 = 4.79672; minv_prev_vec_in_C7 = -1095.04;
      minv_prev_vec_in_C1 = 32'd21064; minv_prev_vec_in_C2 = 32'd23027; minv_prev_vec_in_C3 = 32'd12325; minv_prev_vec_in_C4 = 32'd187088; minv_prev_vec_in_C5 = 32'd6473895; minv_prev_vec_in_C6 = 32'd314358; minv_prev_vec_in_C7 = -32'd71764541;
      // 7
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd155; dfidq_prev_mat_in_AX_J3 = 32'd691;  dfidq_prev_mat_in_AX_J4 = 32'd463; dfidq_prev_mat_in_AX_J5 = 32'd126; dfidq_prev_mat_in_AX_J6 = 32'd1874; dfidq_prev_mat_in_AX_J7 = -32'd6533;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd52; dfidq_prev_mat_in_AY_J3 = -32'd424;  dfidq_prev_mat_in_AY_J4 = 32'd142; dfidq_prev_mat_in_AY_J5 = 32'd895; dfidq_prev_mat_in_AY_J6 = 32'd1840; dfidq_prev_mat_in_AY_J7 = -32'd8044;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd35; dfidq_prev_mat_in_AZ_J3 = -32'd3;  dfidq_prev_mat_in_AZ_J4 = 32'd72; dfidq_prev_mat_in_AZ_J5 = -32'd75; dfidq_prev_mat_in_AZ_J6 = -32'd454; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd3285; dfidq_prev_mat_in_LX_J3 = -32'd13804;  dfidq_prev_mat_in_LX_J4 = 32'd6498; dfidq_prev_mat_in_LX_J5 = 32'd35032; dfidq_prev_mat_in_LX_J6 = 32'd34895; dfidq_prev_mat_in_LX_J7 = -32'd133594;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd10772; dfidq_prev_mat_in_LY_J3 = -32'd28595;  dfidq_prev_mat_in_LY_J4 = -32'd29148; dfidq_prev_mat_in_LY_J5 = -32'd4116; dfidq_prev_mat_in_LY_J6 = -32'd35504; dfidq_prev_mat_in_LY_J7 = 32'd120316;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd19629; dfidq_prev_mat_in_LZ_J3 = 32'd12420;  dfidq_prev_mat_in_LZ_J4 = 32'd15012; dfidq_prev_mat_in_LZ_J5 = -32'd6108; dfidq_prev_mat_in_LZ_J6 = -32'd26838; dfidq_prev_mat_in_LZ_J7 = -32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd204; dfidqd_prev_mat_in_AX_J2 = -32'd355; dfidqd_prev_mat_in_AX_J3 = 32'd58;  dfidqd_prev_mat_in_AX_J4 = 32'd128; dfidqd_prev_mat_in_AX_J5 = 32'd34; dfidqd_prev_mat_in_AX_J6 = 32'd184; dfidqd_prev_mat_in_AX_J7 = 32'd43;
      dfidqd_prev_mat_in_AY_J1 = -32'd186; dfidqd_prev_mat_in_AY_J2 = 32'd404; dfidqd_prev_mat_in_AY_J3 = -32'd176;  dfidqd_prev_mat_in_AY_J4 = -32'd786; dfidqd_prev_mat_in_AY_J5 = 32'd108; dfidqd_prev_mat_in_AY_J6 = 32'd208; dfidqd_prev_mat_in_AY_J7 = -32'd12;
      dfidqd_prev_mat_in_AZ_J1 = -32'd9; dfidqd_prev_mat_in_AZ_J2 = -32'd29; dfidqd_prev_mat_in_AZ_J3 = -32'd8;  dfidqd_prev_mat_in_AZ_J4 = 32'd69; dfidqd_prev_mat_in_AZ_J5 = -32'd23; dfidqd_prev_mat_in_AZ_J6 = -32'd41; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd10435; dfidqd_prev_mat_in_LX_J2 = 32'd23638; dfidqd_prev_mat_in_LX_J3 = -32'd7656;  dfidqd_prev_mat_in_LX_J4 = -32'd37658; dfidqd_prev_mat_in_LX_J5 = 32'd3027; dfidqd_prev_mat_in_LX_J6 = 32'd6737; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd13340; dfidqd_prev_mat_in_LY_J2 = 32'd20050; dfidqd_prev_mat_in_LY_J3 = 32'd289;  dfidqd_prev_mat_in_LY_J4 = -32'd5454; dfidqd_prev_mat_in_LY_J5 = 32'd998; dfidqd_prev_mat_in_LY_J6 = -32'd5960; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd8477; dfidqd_prev_mat_in_LZ_J2 = -32'd12323; dfidqd_prev_mat_in_LZ_J3 = 32'd1071;  dfidqd_prev_mat_in_LZ_J4 = -32'd549; dfidqd_prev_mat_in_LZ_J5 = -32'd757; dfidqd_prev_mat_in_LZ_J6 = 32'd1182; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Ignore Outputs
      //------------------------------------------------------------------------
      // Link 7 Inputs
      // 6
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      // 6
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = -32'd25864; minv_prev_vec_in_C2 = -32'd89991; minv_prev_vec_in_C3 = -32'd45311; minv_prev_vec_in_C4 = -32'd358665; minv_prev_vec_in_C5 = -32'd204961; minv_prev_vec_in_C6 = -32'd8039236; minv_prev_vec_in_C7 = 32'd314358;
      // 6
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd284; dfidq_prev_mat_in_AX_J3 = -32'd35;  dfidq_prev_mat_in_AX_J4 = 32'd259; dfidq_prev_mat_in_AX_J5 = 32'd931; dfidq_prev_mat_in_AX_J6 = 32'd8200; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd123; dfidq_prev_mat_in_AY_J3 = -32'd73;  dfidq_prev_mat_in_AY_J4 = 32'd247; dfidq_prev_mat_in_AY_J5 = -32'd245; dfidq_prev_mat_in_AY_J6 = -32'd1679; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd151; dfidq_prev_mat_in_AZ_J3 = 32'd839;  dfidq_prev_mat_in_AZ_J4 = 32'd23; dfidq_prev_mat_in_AZ_J5 = -32'd794; dfidq_prev_mat_in_AZ_J6 = -32'd389; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd32323; dfidq_prev_mat_in_LX_J3 = -32'd160291;  dfidq_prev_mat_in_LX_J4 = -32'd90398; dfidq_prev_mat_in_LX_J5 = 32'd80218; dfidq_prev_mat_in_LX_J6 = -32'd77343; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd111481; dfidq_prev_mat_in_LY_J3 = 32'd77173;  dfidq_prev_mat_in_LY_J4 = 32'd64413; dfidq_prev_mat_in_LY_J5 = -32'd25932; dfidq_prev_mat_in_LY_J6 = -32'd128801; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd49161; dfidq_prev_mat_in_LZ_J3 = 32'd46245;  dfidq_prev_mat_in_LZ_J4 = 32'd109642; dfidq_prev_mat_in_LZ_J5 = 32'd145168; dfidq_prev_mat_in_LZ_J6 = 32'd1770; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd76; dfidqd_prev_mat_in_AX_J2 = -32'd2; dfidqd_prev_mat_in_AX_J3 = 32'd75;  dfidqd_prev_mat_in_AX_J4 = -32'd411; dfidqd_prev_mat_in_AX_J5 = 32'd337; dfidqd_prev_mat_in_AX_J6 = 32'd906; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd36; dfidqd_prev_mat_in_AY_J2 = -32'd40; dfidqd_prev_mat_in_AY_J3 = -32'd44;  dfidqd_prev_mat_in_AY_J4 = 32'd186; dfidqd_prev_mat_in_AY_J5 = -32'd85; dfidqd_prev_mat_in_AY_J6 = -32'd135; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd53; dfidqd_prev_mat_in_AZ_J2 = -32'd127; dfidqd_prev_mat_in_AZ_J3 = 32'd123;  dfidqd_prev_mat_in_AZ_J4 = 32'd558; dfidqd_prev_mat_in_AZ_J5 = -32'd149; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd5723; dfidqd_prev_mat_in_LX_J2 = 32'd166896; dfidqd_prev_mat_in_LX_J3 = -32'd36058;  dfidqd_prev_mat_in_LX_J4 = -32'd143888; dfidqd_prev_mat_in_LX_J5 = 32'd77; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd43324; dfidqd_prev_mat_in_LY_J2 = -32'd60969; dfidqd_prev_mat_in_LY_J3 = 32'd11058;  dfidqd_prev_mat_in_LY_J4 = -32'd9066; dfidqd_prev_mat_in_LY_J5 = -32'd92; dfidqd_prev_mat_in_LY_J6 = 32'd42; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd94049; dfidqd_prev_mat_in_LZ_J2 = 32'd24373; dfidqd_prev_mat_in_LZ_J3 = -32'd36659;  dfidqd_prev_mat_in_LZ_J4 = -32'd120581; dfidqd_prev_mat_in_LZ_J5 = -32'd164; dfidqd_prev_mat_in_LZ_J6 = 32'd321; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 7 Outputs
      $display ("// Link 7 Test");
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
      minv_prev_vec_in_C1 = -32'd66476; minv_prev_vec_in_C2 = -32'd19260; minv_prev_vec_in_C3 = 32'd2574713; minv_prev_vec_in_C4 = -32'd105892; minv_prev_vec_in_C5 = -32'd9289794; minv_prev_vec_in_C6 = -32'd204961; minv_prev_vec_in_C7 = 32'd6473895;
      // 5
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd4354; dfidq_prev_mat_in_AX_J3 = 32'd3320;  dfidq_prev_mat_in_AX_J4 = 32'd7150; dfidq_prev_mat_in_AX_J5 = 32'd10972; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd4610; dfidq_prev_mat_in_AY_J3 = -32'd12747;  dfidq_prev_mat_in_AY_J4 = -32'd7214; dfidq_prev_mat_in_AY_J5 = 32'd5786; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd1038; dfidq_prev_mat_in_AZ_J3 = 32'd2853;  dfidq_prev_mat_in_AZ_J4 = 32'd1647; dfidq_prev_mat_in_AZ_J5 = -32'd564; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd48590; dfidq_prev_mat_in_LX_J3 = -32'd137401;  dfidq_prev_mat_in_LX_J4 = -32'd65942; dfidq_prev_mat_in_LX_J5 = 32'd23191; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd45129; dfidq_prev_mat_in_LY_J3 = -32'd36066;  dfidq_prev_mat_in_LY_J4 = -32'd70817; dfidq_prev_mat_in_LY_J5 = -32'd96617; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd62580; dfidq_prev_mat_in_LZ_J3 = 32'd13151;  dfidq_prev_mat_in_LZ_J4 = -32'd4659; dfidq_prev_mat_in_LZ_J5 = 32'd7121; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd5945; dfidqd_prev_mat_in_AX_J2 = 32'd1309; dfidqd_prev_mat_in_AX_J3 = -32'd1513;  dfidqd_prev_mat_in_AX_J4 = -32'd8879; dfidqd_prev_mat_in_AX_J5 = 32'd1237; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd1314; dfidqd_prev_mat_in_AY_J2 = 32'd12420; dfidqd_prev_mat_in_AY_J3 = -32'd2697;  dfidqd_prev_mat_in_AY_J4 = -32'd9465; dfidqd_prev_mat_in_AY_J5 = 32'd16; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd394; dfidqd_prev_mat_in_AZ_J2 = -32'd3077; dfidqd_prev_mat_in_AZ_J3 = 32'd491;  dfidqd_prev_mat_in_AZ_J4 = 32'd2025; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd20251; dfidqd_prev_mat_in_LX_J2 = 32'd140948; dfidqd_prev_mat_in_LX_J3 = -32'd23281;  dfidqd_prev_mat_in_LX_J4 = -32'd84990; dfidqd_prev_mat_in_LX_J5 = -32'd52; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd57716; dfidqd_prev_mat_in_LY_J2 = -32'd18551; dfidqd_prev_mat_in_LY_J3 = 32'd11438;  dfidqd_prev_mat_in_LY_J4 = 32'd73710; dfidqd_prev_mat_in_LY_J5 = -32'd10981; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd24770; dfidqd_prev_mat_in_LZ_J2 = -32'd13522; dfidqd_prev_mat_in_LZ_J3 = 32'd1380;  dfidqd_prev_mat_in_LZ_J4 = -32'd31010; dfidqd_prev_mat_in_LZ_J5 = 32'd3378; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 6 Outputs
      $display ("// Link 6 Test");
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
      minv_prev_vec_in_C1 = 32'd193436; minv_prev_vec_in_C2 = -32'd122649; minv_prev_vec_in_C3 = -32'd201513; minv_prev_vec_in_C4 = -32'd437695; minv_prev_vec_in_C5 = -32'd105892; minv_prev_vec_in_C6 = -32'd358665; minv_prev_vec_in_C7 = 32'd187088;
      // 4
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd826; dfidq_prev_mat_in_AX_J3 = 32'd8949;  dfidq_prev_mat_in_AX_J4 = 32'd1941; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd2678; dfidq_prev_mat_in_AY_J3 = 32'd4680;  dfidq_prev_mat_in_AY_J4 = 32'd1622; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd5904; dfidq_prev_mat_in_AZ_J3 = -32'd12157;  dfidq_prev_mat_in_AZ_J4 = -32'd6891; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd76136; dfidq_prev_mat_in_LX_J3 = 32'd136829;  dfidq_prev_mat_in_LX_J4 = 32'd35836; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd55811; dfidq_prev_mat_in_LY_J3 = -32'd9425;  dfidq_prev_mat_in_LY_J4 = -32'd53266; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd3436; dfidq_prev_mat_in_LZ_J3 = 32'd89127;  dfidq_prev_mat_in_LZ_J4 = 32'd1368; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1436; dfidqd_prev_mat_in_AX_J2 = -32'd9457; dfidqd_prev_mat_in_AX_J3 = 32'd1126;  dfidqd_prev_mat_in_AX_J4 = 32'd9615; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd2460; dfidqd_prev_mat_in_AY_J2 = -32'd3074; dfidqd_prev_mat_in_AY_J3 = -32'd13;  dfidqd_prev_mat_in_AY_J4 = 32'd277; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd5950; dfidqd_prev_mat_in_AZ_J2 = 32'd7332; dfidqd_prev_mat_in_AZ_J3 = -32'd181;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd73332; dfidqd_prev_mat_in_LX_J2 = -32'd89415; dfidqd_prev_mat_in_LX_J3 = -32'd473;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22838; dfidqd_prev_mat_in_LY_J2 = -32'd43368; dfidqd_prev_mat_in_LY_J3 = -32'd94;  dfidqd_prev_mat_in_LY_J4 = -32'd13222; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd10554; dfidqd_prev_mat_in_LZ_J2 = -32'd135202; dfidqd_prev_mat_in_LZ_J3 = -32'd9858;  dfidqd_prev_mat_in_LZ_J4 = 32'd45277; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 5 Outputs
      $display ("// Link 5 Test");
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
      minv_prev_vec_in_C1 = 32'd212790; minv_prev_vec_in_C2 = -32'd42572; minv_prev_vec_in_C3 = -32'd2752466; minv_prev_vec_in_C4 = -32'd201513; minv_prev_vec_in_C5 = 32'd2574713; minv_prev_vec_in_C6 = -32'd45311; minv_prev_vec_in_C7 = 32'd12325;
      // 3
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd2621; dfidq_prev_mat_in_AX_J3 = 32'd15599;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd10348; dfidq_prev_mat_in_AY_J3 = 32'd21009;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd1137; dfidq_prev_mat_in_AZ_J3 = -32'd2999;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd51071; dfidq_prev_mat_in_LX_J3 = 32'd102173;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd1313; dfidq_prev_mat_in_LY_J3 = -32'd68019;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd57033; dfidq_prev_mat_in_LZ_J3 = 32'd16263;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1897; dfidqd_prev_mat_in_AX_J2 = -32'd19915; dfidqd_prev_mat_in_AX_J3 = 32'd2933;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd10769; dfidqd_prev_mat_in_AY_J2 = -32'd13702; dfidqd_prev_mat_in_AY_J3 = 32'd147;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd1521; dfidqd_prev_mat_in_AZ_J2 = 32'd1936; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd53805; dfidqd_prev_mat_in_LX_J2 = -32'd68646; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22821; dfidqd_prev_mat_in_LY_J2 = 32'd97882; dfidqd_prev_mat_in_LY_J3 = -32'd22583;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd23054; dfidqd_prev_mat_in_LZ_J2 = -32'd23480; dfidqd_prev_mat_in_LZ_J3 = -32'd22;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 4 Outputs
      $display ("// Link 4 Test");
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
      minv_prev_vec_in_C1 = 32'd54563; minv_prev_vec_in_C2 = -32'd53716; minv_prev_vec_in_C3 = -32'd42572; minv_prev_vec_in_C4 = -32'd122649; minv_prev_vec_in_C5 = -32'd19260; minv_prev_vec_in_C6 = -32'd89991; minv_prev_vec_in_C7 = 32'd23027;
      // 2
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd2709; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd126; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd2017; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd8454; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd17508; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd6786; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd469; dfidqd_prev_mat_in_AX_J2 = 32'd6644; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd375; dfidqd_prev_mat_in_AY_J2 = -32'd304; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd2077; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd10572; dfidqd_prev_mat_in_LX_J2 = -32'd40; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd4252; dfidqd_prev_mat_in_LY_J2 = -32'd7785; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd14781; dfidqd_prev_mat_in_LZ_J2 = 32'd28755; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 3 Outputs
      $display ("// Link 3 Test");
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
      minv_prev_vec_in_C1 = -32'd216819; minv_prev_vec_in_C2 = 32'd54563; minv_prev_vec_in_C3 = 32'd212790; minv_prev_vec_in_C4 = 32'd193436; minv_prev_vec_in_C5 = -32'd66476; minv_prev_vec_in_C6 = -32'd25864; minv_prev_vec_in_C7 = 32'd21064;
      // 1
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd1887; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd15727; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 2 Outputs
      $display ("// Link 2 Test");
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
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0;
      // 0
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // Hold for 3 cycles for Link 1 Outputs
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 2
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 1
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 1 Outputs
      $display ("// Link 1 Test");
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
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
      //------------------------------------------------------------------------
      // set values
      //------------------------------------------------------------------------
      $display ("// Knot 7 Link 8 Init");
      //------------------------------------------------------------------------
      // Link 8 Inputs
      // 7
      sinq_prev_in = 32'd49084; cosq_prev_in = -32'd43424;
      f_prev_vec_in_AX = 32'd8044; f_prev_vec_in_AY = -32'd6533; f_prev_vec_in_AZ = 32'd5043; f_prev_vec_in_LX = -32'd120315; f_prev_vec_in_LY = -32'd133594; f_prev_vec_in_LZ = -32'd13832;
      // 7
      // minv_prev_vec_in_C1 = 0.321418; minv_prev_vec_in_C2 = 0.35137; minv_prev_vec_in_C3 = 0.188062; minv_prev_vec_in_C4 = 2.85474; minv_prev_vec_in_C5 = 98.7838; minv_prev_vec_in_C6 = 4.79672; minv_prev_vec_in_C7 = -1095.04;
      minv_prev_vec_in_C1 = 32'd21064; minv_prev_vec_in_C2 = 32'd23027; minv_prev_vec_in_C3 = 32'd12325; minv_prev_vec_in_C4 = 32'd187088; minv_prev_vec_in_C5 = 32'd6473895; minv_prev_vec_in_C6 = 32'd314358; minv_prev_vec_in_C7 = -32'd71764541;
      // 7
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd155; dfidq_prev_mat_in_AX_J3 = 32'd691;  dfidq_prev_mat_in_AX_J4 = 32'd463; dfidq_prev_mat_in_AX_J5 = 32'd126; dfidq_prev_mat_in_AX_J6 = 32'd1874; dfidq_prev_mat_in_AX_J7 = -32'd6533;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd52; dfidq_prev_mat_in_AY_J3 = -32'd424;  dfidq_prev_mat_in_AY_J4 = 32'd142; dfidq_prev_mat_in_AY_J5 = 32'd895; dfidq_prev_mat_in_AY_J6 = 32'd1840; dfidq_prev_mat_in_AY_J7 = -32'd8044;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd35; dfidq_prev_mat_in_AZ_J3 = -32'd3;  dfidq_prev_mat_in_AZ_J4 = 32'd72; dfidq_prev_mat_in_AZ_J5 = -32'd75; dfidq_prev_mat_in_AZ_J6 = -32'd454; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd3285; dfidq_prev_mat_in_LX_J3 = -32'd13804;  dfidq_prev_mat_in_LX_J4 = 32'd6498; dfidq_prev_mat_in_LX_J5 = 32'd35032; dfidq_prev_mat_in_LX_J6 = 32'd34895; dfidq_prev_mat_in_LX_J7 = -32'd133594;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd10772; dfidq_prev_mat_in_LY_J3 = -32'd28595;  dfidq_prev_mat_in_LY_J4 = -32'd29148; dfidq_prev_mat_in_LY_J5 = -32'd4116; dfidq_prev_mat_in_LY_J6 = -32'd35504; dfidq_prev_mat_in_LY_J7 = 32'd120316;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd19629; dfidq_prev_mat_in_LZ_J3 = 32'd12420;  dfidq_prev_mat_in_LZ_J4 = 32'd15012; dfidq_prev_mat_in_LZ_J5 = -32'd6108; dfidq_prev_mat_in_LZ_J6 = -32'd26838; dfidq_prev_mat_in_LZ_J7 = -32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd204; dfidqd_prev_mat_in_AX_J2 = -32'd355; dfidqd_prev_mat_in_AX_J3 = 32'd58;  dfidqd_prev_mat_in_AX_J4 = 32'd128; dfidqd_prev_mat_in_AX_J5 = 32'd34; dfidqd_prev_mat_in_AX_J6 = 32'd184; dfidqd_prev_mat_in_AX_J7 = 32'd43;
      dfidqd_prev_mat_in_AY_J1 = -32'd186; dfidqd_prev_mat_in_AY_J2 = 32'd404; dfidqd_prev_mat_in_AY_J3 = -32'd176;  dfidqd_prev_mat_in_AY_J4 = -32'd786; dfidqd_prev_mat_in_AY_J5 = 32'd108; dfidqd_prev_mat_in_AY_J6 = 32'd208; dfidqd_prev_mat_in_AY_J7 = -32'd12;
      dfidqd_prev_mat_in_AZ_J1 = -32'd9; dfidqd_prev_mat_in_AZ_J2 = -32'd29; dfidqd_prev_mat_in_AZ_J3 = -32'd8;  dfidqd_prev_mat_in_AZ_J4 = 32'd69; dfidqd_prev_mat_in_AZ_J5 = -32'd23; dfidqd_prev_mat_in_AZ_J6 = -32'd41; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd10435; dfidqd_prev_mat_in_LX_J2 = 32'd23638; dfidqd_prev_mat_in_LX_J3 = -32'd7656;  dfidqd_prev_mat_in_LX_J4 = -32'd37658; dfidqd_prev_mat_in_LX_J5 = 32'd3027; dfidqd_prev_mat_in_LX_J6 = 32'd6737; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd13340; dfidqd_prev_mat_in_LY_J2 = 32'd20050; dfidqd_prev_mat_in_LY_J3 = 32'd289;  dfidqd_prev_mat_in_LY_J4 = -32'd5454; dfidqd_prev_mat_in_LY_J5 = 32'd998; dfidqd_prev_mat_in_LY_J6 = -32'd5960; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd8477; dfidqd_prev_mat_in_LZ_J2 = -32'd12323; dfidqd_prev_mat_in_LZ_J3 = 32'd1071;  dfidqd_prev_mat_in_LZ_J4 = -32'd549; dfidqd_prev_mat_in_LZ_J5 = -32'd757; dfidqd_prev_mat_in_LZ_J6 = 32'd1182; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Ignore Outputs
      //------------------------------------------------------------------------
      // Link 7 Inputs
      // 6
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      // 6
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = -32'd25864; minv_prev_vec_in_C2 = -32'd89991; minv_prev_vec_in_C3 = -32'd45311; minv_prev_vec_in_C4 = -32'd358665; minv_prev_vec_in_C5 = -32'd204961; minv_prev_vec_in_C6 = -32'd8039236; minv_prev_vec_in_C7 = 32'd314358;
      // 6
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd284; dfidq_prev_mat_in_AX_J3 = -32'd35;  dfidq_prev_mat_in_AX_J4 = 32'd259; dfidq_prev_mat_in_AX_J5 = 32'd931; dfidq_prev_mat_in_AX_J6 = 32'd8200; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd123; dfidq_prev_mat_in_AY_J3 = -32'd73;  dfidq_prev_mat_in_AY_J4 = 32'd247; dfidq_prev_mat_in_AY_J5 = -32'd245; dfidq_prev_mat_in_AY_J6 = -32'd1679; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd151; dfidq_prev_mat_in_AZ_J3 = 32'd839;  dfidq_prev_mat_in_AZ_J4 = 32'd23; dfidq_prev_mat_in_AZ_J5 = -32'd794; dfidq_prev_mat_in_AZ_J6 = -32'd389; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd32323; dfidq_prev_mat_in_LX_J3 = -32'd160291;  dfidq_prev_mat_in_LX_J4 = -32'd90398; dfidq_prev_mat_in_LX_J5 = 32'd80218; dfidq_prev_mat_in_LX_J6 = -32'd77343; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd111481; dfidq_prev_mat_in_LY_J3 = 32'd77173;  dfidq_prev_mat_in_LY_J4 = 32'd64413; dfidq_prev_mat_in_LY_J5 = -32'd25932; dfidq_prev_mat_in_LY_J6 = -32'd128801; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd49161; dfidq_prev_mat_in_LZ_J3 = 32'd46245;  dfidq_prev_mat_in_LZ_J4 = 32'd109642; dfidq_prev_mat_in_LZ_J5 = 32'd145168; dfidq_prev_mat_in_LZ_J6 = 32'd1770; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd76; dfidqd_prev_mat_in_AX_J2 = -32'd2; dfidqd_prev_mat_in_AX_J3 = 32'd75;  dfidqd_prev_mat_in_AX_J4 = -32'd411; dfidqd_prev_mat_in_AX_J5 = 32'd337; dfidqd_prev_mat_in_AX_J6 = 32'd906; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd36; dfidqd_prev_mat_in_AY_J2 = -32'd40; dfidqd_prev_mat_in_AY_J3 = -32'd44;  dfidqd_prev_mat_in_AY_J4 = 32'd186; dfidqd_prev_mat_in_AY_J5 = -32'd85; dfidqd_prev_mat_in_AY_J6 = -32'd135; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd53; dfidqd_prev_mat_in_AZ_J2 = -32'd127; dfidqd_prev_mat_in_AZ_J3 = 32'd123;  dfidqd_prev_mat_in_AZ_J4 = 32'd558; dfidqd_prev_mat_in_AZ_J5 = -32'd149; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd5723; dfidqd_prev_mat_in_LX_J2 = 32'd166896; dfidqd_prev_mat_in_LX_J3 = -32'd36058;  dfidqd_prev_mat_in_LX_J4 = -32'd143888; dfidqd_prev_mat_in_LX_J5 = 32'd77; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd43324; dfidqd_prev_mat_in_LY_J2 = -32'd60969; dfidqd_prev_mat_in_LY_J3 = 32'd11058;  dfidqd_prev_mat_in_LY_J4 = -32'd9066; dfidqd_prev_mat_in_LY_J5 = -32'd92; dfidqd_prev_mat_in_LY_J6 = 32'd42; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd94049; dfidqd_prev_mat_in_LZ_J2 = 32'd24373; dfidqd_prev_mat_in_LZ_J3 = -32'd36659;  dfidqd_prev_mat_in_LZ_J4 = -32'd120581; dfidqd_prev_mat_in_LZ_J5 = -32'd164; dfidqd_prev_mat_in_LZ_J6 = 32'd321; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 7 Outputs
      $display ("// Link 7 Test");
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
      minv_prev_vec_in_C1 = -32'd66476; minv_prev_vec_in_C2 = -32'd19260; minv_prev_vec_in_C3 = 32'd2574713; minv_prev_vec_in_C4 = -32'd105892; minv_prev_vec_in_C5 = -32'd9289794; minv_prev_vec_in_C6 = -32'd204961; minv_prev_vec_in_C7 = 32'd6473895;
      // 5
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd4354; dfidq_prev_mat_in_AX_J3 = 32'd3320;  dfidq_prev_mat_in_AX_J4 = 32'd7150; dfidq_prev_mat_in_AX_J5 = 32'd10972; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd4610; dfidq_prev_mat_in_AY_J3 = -32'd12747;  dfidq_prev_mat_in_AY_J4 = -32'd7214; dfidq_prev_mat_in_AY_J5 = 32'd5786; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd1038; dfidq_prev_mat_in_AZ_J3 = 32'd2853;  dfidq_prev_mat_in_AZ_J4 = 32'd1647; dfidq_prev_mat_in_AZ_J5 = -32'd564; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd48590; dfidq_prev_mat_in_LX_J3 = -32'd137401;  dfidq_prev_mat_in_LX_J4 = -32'd65942; dfidq_prev_mat_in_LX_J5 = 32'd23191; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd45129; dfidq_prev_mat_in_LY_J3 = -32'd36066;  dfidq_prev_mat_in_LY_J4 = -32'd70817; dfidq_prev_mat_in_LY_J5 = -32'd96617; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd62580; dfidq_prev_mat_in_LZ_J3 = 32'd13151;  dfidq_prev_mat_in_LZ_J4 = -32'd4659; dfidq_prev_mat_in_LZ_J5 = 32'd7121; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd5945; dfidqd_prev_mat_in_AX_J2 = 32'd1309; dfidqd_prev_mat_in_AX_J3 = -32'd1513;  dfidqd_prev_mat_in_AX_J4 = -32'd8879; dfidqd_prev_mat_in_AX_J5 = 32'd1237; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd1314; dfidqd_prev_mat_in_AY_J2 = 32'd12420; dfidqd_prev_mat_in_AY_J3 = -32'd2697;  dfidqd_prev_mat_in_AY_J4 = -32'd9465; dfidqd_prev_mat_in_AY_J5 = 32'd16; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd394; dfidqd_prev_mat_in_AZ_J2 = -32'd3077; dfidqd_prev_mat_in_AZ_J3 = 32'd491;  dfidqd_prev_mat_in_AZ_J4 = 32'd2025; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd20251; dfidqd_prev_mat_in_LX_J2 = 32'd140948; dfidqd_prev_mat_in_LX_J3 = -32'd23281;  dfidqd_prev_mat_in_LX_J4 = -32'd84990; dfidqd_prev_mat_in_LX_J5 = -32'd52; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd57716; dfidqd_prev_mat_in_LY_J2 = -32'd18551; dfidqd_prev_mat_in_LY_J3 = 32'd11438;  dfidqd_prev_mat_in_LY_J4 = 32'd73710; dfidqd_prev_mat_in_LY_J5 = -32'd10981; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd24770; dfidqd_prev_mat_in_LZ_J2 = -32'd13522; dfidqd_prev_mat_in_LZ_J3 = 32'd1380;  dfidqd_prev_mat_in_LZ_J4 = -32'd31010; dfidqd_prev_mat_in_LZ_J5 = 32'd3378; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 6 Outputs
      $display ("// Link 6 Test");
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
      minv_prev_vec_in_C1 = 32'd193436; minv_prev_vec_in_C2 = -32'd122649; minv_prev_vec_in_C3 = -32'd201513; minv_prev_vec_in_C4 = -32'd437695; minv_prev_vec_in_C5 = -32'd105892; minv_prev_vec_in_C6 = -32'd358665; minv_prev_vec_in_C7 = 32'd187088;
      // 4
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd826; dfidq_prev_mat_in_AX_J3 = 32'd8949;  dfidq_prev_mat_in_AX_J4 = 32'd1941; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd2678; dfidq_prev_mat_in_AY_J3 = 32'd4680;  dfidq_prev_mat_in_AY_J4 = 32'd1622; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd5904; dfidq_prev_mat_in_AZ_J3 = -32'd12157;  dfidq_prev_mat_in_AZ_J4 = -32'd6891; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd76136; dfidq_prev_mat_in_LX_J3 = 32'd136829;  dfidq_prev_mat_in_LX_J4 = 32'd35836; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd55811; dfidq_prev_mat_in_LY_J3 = -32'd9425;  dfidq_prev_mat_in_LY_J4 = -32'd53266; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd3436; dfidq_prev_mat_in_LZ_J3 = 32'd89127;  dfidq_prev_mat_in_LZ_J4 = 32'd1368; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1436; dfidqd_prev_mat_in_AX_J2 = -32'd9457; dfidqd_prev_mat_in_AX_J3 = 32'd1126;  dfidqd_prev_mat_in_AX_J4 = 32'd9615; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd2460; dfidqd_prev_mat_in_AY_J2 = -32'd3074; dfidqd_prev_mat_in_AY_J3 = -32'd13;  dfidqd_prev_mat_in_AY_J4 = 32'd277; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd5950; dfidqd_prev_mat_in_AZ_J2 = 32'd7332; dfidqd_prev_mat_in_AZ_J3 = -32'd181;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd73332; dfidqd_prev_mat_in_LX_J2 = -32'd89415; dfidqd_prev_mat_in_LX_J3 = -32'd473;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22838; dfidqd_prev_mat_in_LY_J2 = -32'd43368; dfidqd_prev_mat_in_LY_J3 = -32'd94;  dfidqd_prev_mat_in_LY_J4 = -32'd13222; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd10554; dfidqd_prev_mat_in_LZ_J2 = -32'd135202; dfidqd_prev_mat_in_LZ_J3 = -32'd9858;  dfidqd_prev_mat_in_LZ_J4 = 32'd45277; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 5 Outputs
      $display ("// Link 5 Test");
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
      minv_prev_vec_in_C1 = 32'd212790; minv_prev_vec_in_C2 = -32'd42572; minv_prev_vec_in_C3 = -32'd2752466; minv_prev_vec_in_C4 = -32'd201513; minv_prev_vec_in_C5 = 32'd2574713; minv_prev_vec_in_C6 = -32'd45311; minv_prev_vec_in_C7 = 32'd12325;
      // 3
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd2621; dfidq_prev_mat_in_AX_J3 = 32'd15599;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd10348; dfidq_prev_mat_in_AY_J3 = 32'd21009;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd1137; dfidq_prev_mat_in_AZ_J3 = -32'd2999;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd51071; dfidq_prev_mat_in_LX_J3 = 32'd102173;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd1313; dfidq_prev_mat_in_LY_J3 = -32'd68019;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd57033; dfidq_prev_mat_in_LZ_J3 = 32'd16263;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1897; dfidqd_prev_mat_in_AX_J2 = -32'd19915; dfidqd_prev_mat_in_AX_J3 = 32'd2933;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd10769; dfidqd_prev_mat_in_AY_J2 = -32'd13702; dfidqd_prev_mat_in_AY_J3 = 32'd147;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd1521; dfidqd_prev_mat_in_AZ_J2 = 32'd1936; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd53805; dfidqd_prev_mat_in_LX_J2 = -32'd68646; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22821; dfidqd_prev_mat_in_LY_J2 = 32'd97882; dfidqd_prev_mat_in_LY_J3 = -32'd22583;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd23054; dfidqd_prev_mat_in_LZ_J2 = -32'd23480; dfidqd_prev_mat_in_LZ_J3 = -32'd22;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 4 Outputs
      $display ("// Link 4 Test");
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
      minv_prev_vec_in_C1 = 32'd54563; minv_prev_vec_in_C2 = -32'd53716; minv_prev_vec_in_C3 = -32'd42572; minv_prev_vec_in_C4 = -32'd122649; minv_prev_vec_in_C5 = -32'd19260; minv_prev_vec_in_C6 = -32'd89991; minv_prev_vec_in_C7 = 32'd23027;
      // 2
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd2709; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd126; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd2017; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd8454; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd17508; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd6786; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd469; dfidqd_prev_mat_in_AX_J2 = 32'd6644; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd375; dfidqd_prev_mat_in_AY_J2 = -32'd304; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd2077; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd10572; dfidqd_prev_mat_in_LX_J2 = -32'd40; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd4252; dfidqd_prev_mat_in_LY_J2 = -32'd7785; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd14781; dfidqd_prev_mat_in_LZ_J2 = 32'd28755; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 3 Outputs
      $display ("// Link 3 Test");
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
      minv_prev_vec_in_C1 = -32'd216819; minv_prev_vec_in_C2 = 32'd54563; minv_prev_vec_in_C3 = 32'd212790; minv_prev_vec_in_C4 = 32'd193436; minv_prev_vec_in_C5 = -32'd66476; minv_prev_vec_in_C6 = -32'd25864; minv_prev_vec_in_C7 = 32'd21064;
      // 1
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd1887; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd15727; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 2 Outputs
      $display ("// Link 2 Test");
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
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0;
      // 0
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // Hold for 3 cycles for Link 1 Outputs
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 2
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 1
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 1 Outputs
      $display ("// Link 1 Test");
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
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
      //------------------------------------------------------------------------
      // set values
      //------------------------------------------------------------------------
      $display ("// Knot 8 Link 8 Init");
      //------------------------------------------------------------------------
      // Link 8 Inputs
      // 7
      sinq_prev_in = 32'd49084; cosq_prev_in = -32'd43424;
      f_prev_vec_in_AX = 32'd8044; f_prev_vec_in_AY = -32'd6533; f_prev_vec_in_AZ = 32'd5043; f_prev_vec_in_LX = -32'd120315; f_prev_vec_in_LY = -32'd133594; f_prev_vec_in_LZ = -32'd13832;
      // 7
      // minv_prev_vec_in_C1 = 0.321418; minv_prev_vec_in_C2 = 0.35137; minv_prev_vec_in_C3 = 0.188062; minv_prev_vec_in_C4 = 2.85474; minv_prev_vec_in_C5 = 98.7838; minv_prev_vec_in_C6 = 4.79672; minv_prev_vec_in_C7 = -1095.04;
      minv_prev_vec_in_C1 = 32'd21064; minv_prev_vec_in_C2 = 32'd23027; minv_prev_vec_in_C3 = 32'd12325; minv_prev_vec_in_C4 = 32'd187088; minv_prev_vec_in_C5 = 32'd6473895; minv_prev_vec_in_C6 = 32'd314358; minv_prev_vec_in_C7 = -32'd71764541;
      // 7
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd155; dfidq_prev_mat_in_AX_J3 = 32'd691;  dfidq_prev_mat_in_AX_J4 = 32'd463; dfidq_prev_mat_in_AX_J5 = 32'd126; dfidq_prev_mat_in_AX_J6 = 32'd1874; dfidq_prev_mat_in_AX_J7 = -32'd6533;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd52; dfidq_prev_mat_in_AY_J3 = -32'd424;  dfidq_prev_mat_in_AY_J4 = 32'd142; dfidq_prev_mat_in_AY_J5 = 32'd895; dfidq_prev_mat_in_AY_J6 = 32'd1840; dfidq_prev_mat_in_AY_J7 = -32'd8044;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd35; dfidq_prev_mat_in_AZ_J3 = -32'd3;  dfidq_prev_mat_in_AZ_J4 = 32'd72; dfidq_prev_mat_in_AZ_J5 = -32'd75; dfidq_prev_mat_in_AZ_J6 = -32'd454; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd3285; dfidq_prev_mat_in_LX_J3 = -32'd13804;  dfidq_prev_mat_in_LX_J4 = 32'd6498; dfidq_prev_mat_in_LX_J5 = 32'd35032; dfidq_prev_mat_in_LX_J6 = 32'd34895; dfidq_prev_mat_in_LX_J7 = -32'd133594;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd10772; dfidq_prev_mat_in_LY_J3 = -32'd28595;  dfidq_prev_mat_in_LY_J4 = -32'd29148; dfidq_prev_mat_in_LY_J5 = -32'd4116; dfidq_prev_mat_in_LY_J6 = -32'd35504; dfidq_prev_mat_in_LY_J7 = 32'd120316;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd19629; dfidq_prev_mat_in_LZ_J3 = 32'd12420;  dfidq_prev_mat_in_LZ_J4 = 32'd15012; dfidq_prev_mat_in_LZ_J5 = -32'd6108; dfidq_prev_mat_in_LZ_J6 = -32'd26838; dfidq_prev_mat_in_LZ_J7 = -32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd204; dfidqd_prev_mat_in_AX_J2 = -32'd355; dfidqd_prev_mat_in_AX_J3 = 32'd58;  dfidqd_prev_mat_in_AX_J4 = 32'd128; dfidqd_prev_mat_in_AX_J5 = 32'd34; dfidqd_prev_mat_in_AX_J6 = 32'd184; dfidqd_prev_mat_in_AX_J7 = 32'd43;
      dfidqd_prev_mat_in_AY_J1 = -32'd186; dfidqd_prev_mat_in_AY_J2 = 32'd404; dfidqd_prev_mat_in_AY_J3 = -32'd176;  dfidqd_prev_mat_in_AY_J4 = -32'd786; dfidqd_prev_mat_in_AY_J5 = 32'd108; dfidqd_prev_mat_in_AY_J6 = 32'd208; dfidqd_prev_mat_in_AY_J7 = -32'd12;
      dfidqd_prev_mat_in_AZ_J1 = -32'd9; dfidqd_prev_mat_in_AZ_J2 = -32'd29; dfidqd_prev_mat_in_AZ_J3 = -32'd8;  dfidqd_prev_mat_in_AZ_J4 = 32'd69; dfidqd_prev_mat_in_AZ_J5 = -32'd23; dfidqd_prev_mat_in_AZ_J6 = -32'd41; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd10435; dfidqd_prev_mat_in_LX_J2 = 32'd23638; dfidqd_prev_mat_in_LX_J3 = -32'd7656;  dfidqd_prev_mat_in_LX_J4 = -32'd37658; dfidqd_prev_mat_in_LX_J5 = 32'd3027; dfidqd_prev_mat_in_LX_J6 = 32'd6737; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd13340; dfidqd_prev_mat_in_LY_J2 = 32'd20050; dfidqd_prev_mat_in_LY_J3 = 32'd289;  dfidqd_prev_mat_in_LY_J4 = -32'd5454; dfidqd_prev_mat_in_LY_J5 = 32'd998; dfidqd_prev_mat_in_LY_J6 = -32'd5960; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd8477; dfidqd_prev_mat_in_LZ_J2 = -32'd12323; dfidqd_prev_mat_in_LZ_J3 = 32'd1071;  dfidqd_prev_mat_in_LZ_J4 = -32'd549; dfidqd_prev_mat_in_LZ_J5 = -32'd757; dfidqd_prev_mat_in_LZ_J6 = 32'd1182; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Ignore Outputs
      //------------------------------------------------------------------------
      // Link 7 Inputs
      // 6
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      // 6
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = -32'd25864; minv_prev_vec_in_C2 = -32'd89991; minv_prev_vec_in_C3 = -32'd45311; minv_prev_vec_in_C4 = -32'd358665; minv_prev_vec_in_C5 = -32'd204961; minv_prev_vec_in_C6 = -32'd8039236; minv_prev_vec_in_C7 = 32'd314358;
      // 6
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd284; dfidq_prev_mat_in_AX_J3 = -32'd35;  dfidq_prev_mat_in_AX_J4 = 32'd259; dfidq_prev_mat_in_AX_J5 = 32'd931; dfidq_prev_mat_in_AX_J6 = 32'd8200; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd123; dfidq_prev_mat_in_AY_J3 = -32'd73;  dfidq_prev_mat_in_AY_J4 = 32'd247; dfidq_prev_mat_in_AY_J5 = -32'd245; dfidq_prev_mat_in_AY_J6 = -32'd1679; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd151; dfidq_prev_mat_in_AZ_J3 = 32'd839;  dfidq_prev_mat_in_AZ_J4 = 32'd23; dfidq_prev_mat_in_AZ_J5 = -32'd794; dfidq_prev_mat_in_AZ_J6 = -32'd389; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd32323; dfidq_prev_mat_in_LX_J3 = -32'd160291;  dfidq_prev_mat_in_LX_J4 = -32'd90398; dfidq_prev_mat_in_LX_J5 = 32'd80218; dfidq_prev_mat_in_LX_J6 = -32'd77343; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd111481; dfidq_prev_mat_in_LY_J3 = 32'd77173;  dfidq_prev_mat_in_LY_J4 = 32'd64413; dfidq_prev_mat_in_LY_J5 = -32'd25932; dfidq_prev_mat_in_LY_J6 = -32'd128801; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd49161; dfidq_prev_mat_in_LZ_J3 = 32'd46245;  dfidq_prev_mat_in_LZ_J4 = 32'd109642; dfidq_prev_mat_in_LZ_J5 = 32'd145168; dfidq_prev_mat_in_LZ_J6 = 32'd1770; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd76; dfidqd_prev_mat_in_AX_J2 = -32'd2; dfidqd_prev_mat_in_AX_J3 = 32'd75;  dfidqd_prev_mat_in_AX_J4 = -32'd411; dfidqd_prev_mat_in_AX_J5 = 32'd337; dfidqd_prev_mat_in_AX_J6 = 32'd906; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd36; dfidqd_prev_mat_in_AY_J2 = -32'd40; dfidqd_prev_mat_in_AY_J3 = -32'd44;  dfidqd_prev_mat_in_AY_J4 = 32'd186; dfidqd_prev_mat_in_AY_J5 = -32'd85; dfidqd_prev_mat_in_AY_J6 = -32'd135; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd53; dfidqd_prev_mat_in_AZ_J2 = -32'd127; dfidqd_prev_mat_in_AZ_J3 = 32'd123;  dfidqd_prev_mat_in_AZ_J4 = 32'd558; dfidqd_prev_mat_in_AZ_J5 = -32'd149; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd5723; dfidqd_prev_mat_in_LX_J2 = 32'd166896; dfidqd_prev_mat_in_LX_J3 = -32'd36058;  dfidqd_prev_mat_in_LX_J4 = -32'd143888; dfidqd_prev_mat_in_LX_J5 = 32'd77; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd43324; dfidqd_prev_mat_in_LY_J2 = -32'd60969; dfidqd_prev_mat_in_LY_J3 = 32'd11058;  dfidqd_prev_mat_in_LY_J4 = -32'd9066; dfidqd_prev_mat_in_LY_J5 = -32'd92; dfidqd_prev_mat_in_LY_J6 = 32'd42; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd94049; dfidqd_prev_mat_in_LZ_J2 = 32'd24373; dfidqd_prev_mat_in_LZ_J3 = -32'd36659;  dfidqd_prev_mat_in_LZ_J4 = -32'd120581; dfidqd_prev_mat_in_LZ_J5 = -32'd164; dfidqd_prev_mat_in_LZ_J6 = 32'd321; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 7 Outputs
      $display ("// Link 7 Test");
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
      minv_prev_vec_in_C1 = -32'd66476; minv_prev_vec_in_C2 = -32'd19260; minv_prev_vec_in_C3 = 32'd2574713; minv_prev_vec_in_C4 = -32'd105892; minv_prev_vec_in_C5 = -32'd9289794; minv_prev_vec_in_C6 = -32'd204961; minv_prev_vec_in_C7 = 32'd6473895;
      // 5
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd4354; dfidq_prev_mat_in_AX_J3 = 32'd3320;  dfidq_prev_mat_in_AX_J4 = 32'd7150; dfidq_prev_mat_in_AX_J5 = 32'd10972; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd4610; dfidq_prev_mat_in_AY_J3 = -32'd12747;  dfidq_prev_mat_in_AY_J4 = -32'd7214; dfidq_prev_mat_in_AY_J5 = 32'd5786; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd1038; dfidq_prev_mat_in_AZ_J3 = 32'd2853;  dfidq_prev_mat_in_AZ_J4 = 32'd1647; dfidq_prev_mat_in_AZ_J5 = -32'd564; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd48590; dfidq_prev_mat_in_LX_J3 = -32'd137401;  dfidq_prev_mat_in_LX_J4 = -32'd65942; dfidq_prev_mat_in_LX_J5 = 32'd23191; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd45129; dfidq_prev_mat_in_LY_J3 = -32'd36066;  dfidq_prev_mat_in_LY_J4 = -32'd70817; dfidq_prev_mat_in_LY_J5 = -32'd96617; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd62580; dfidq_prev_mat_in_LZ_J3 = 32'd13151;  dfidq_prev_mat_in_LZ_J4 = -32'd4659; dfidq_prev_mat_in_LZ_J5 = 32'd7121; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd5945; dfidqd_prev_mat_in_AX_J2 = 32'd1309; dfidqd_prev_mat_in_AX_J3 = -32'd1513;  dfidqd_prev_mat_in_AX_J4 = -32'd8879; dfidqd_prev_mat_in_AX_J5 = 32'd1237; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd1314; dfidqd_prev_mat_in_AY_J2 = 32'd12420; dfidqd_prev_mat_in_AY_J3 = -32'd2697;  dfidqd_prev_mat_in_AY_J4 = -32'd9465; dfidqd_prev_mat_in_AY_J5 = 32'd16; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd394; dfidqd_prev_mat_in_AZ_J2 = -32'd3077; dfidqd_prev_mat_in_AZ_J3 = 32'd491;  dfidqd_prev_mat_in_AZ_J4 = 32'd2025; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd20251; dfidqd_prev_mat_in_LX_J2 = 32'd140948; dfidqd_prev_mat_in_LX_J3 = -32'd23281;  dfidqd_prev_mat_in_LX_J4 = -32'd84990; dfidqd_prev_mat_in_LX_J5 = -32'd52; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd57716; dfidqd_prev_mat_in_LY_J2 = -32'd18551; dfidqd_prev_mat_in_LY_J3 = 32'd11438;  dfidqd_prev_mat_in_LY_J4 = 32'd73710; dfidqd_prev_mat_in_LY_J5 = -32'd10981; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd24770; dfidqd_prev_mat_in_LZ_J2 = -32'd13522; dfidqd_prev_mat_in_LZ_J3 = 32'd1380;  dfidqd_prev_mat_in_LZ_J4 = -32'd31010; dfidqd_prev_mat_in_LZ_J5 = 32'd3378; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 6 Outputs
      $display ("// Link 6 Test");
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
      minv_prev_vec_in_C1 = 32'd193436; minv_prev_vec_in_C2 = -32'd122649; minv_prev_vec_in_C3 = -32'd201513; minv_prev_vec_in_C4 = -32'd437695; minv_prev_vec_in_C5 = -32'd105892; minv_prev_vec_in_C6 = -32'd358665; minv_prev_vec_in_C7 = 32'd187088;
      // 4
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd826; dfidq_prev_mat_in_AX_J3 = 32'd8949;  dfidq_prev_mat_in_AX_J4 = 32'd1941; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd2678; dfidq_prev_mat_in_AY_J3 = 32'd4680;  dfidq_prev_mat_in_AY_J4 = 32'd1622; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd5904; dfidq_prev_mat_in_AZ_J3 = -32'd12157;  dfidq_prev_mat_in_AZ_J4 = -32'd6891; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd76136; dfidq_prev_mat_in_LX_J3 = 32'd136829;  dfidq_prev_mat_in_LX_J4 = 32'd35836; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd55811; dfidq_prev_mat_in_LY_J3 = -32'd9425;  dfidq_prev_mat_in_LY_J4 = -32'd53266; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd3436; dfidq_prev_mat_in_LZ_J3 = 32'd89127;  dfidq_prev_mat_in_LZ_J4 = 32'd1368; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1436; dfidqd_prev_mat_in_AX_J2 = -32'd9457; dfidqd_prev_mat_in_AX_J3 = 32'd1126;  dfidqd_prev_mat_in_AX_J4 = 32'd9615; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd2460; dfidqd_prev_mat_in_AY_J2 = -32'd3074; dfidqd_prev_mat_in_AY_J3 = -32'd13;  dfidqd_prev_mat_in_AY_J4 = 32'd277; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd5950; dfidqd_prev_mat_in_AZ_J2 = 32'd7332; dfidqd_prev_mat_in_AZ_J3 = -32'd181;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd73332; dfidqd_prev_mat_in_LX_J2 = -32'd89415; dfidqd_prev_mat_in_LX_J3 = -32'd473;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22838; dfidqd_prev_mat_in_LY_J2 = -32'd43368; dfidqd_prev_mat_in_LY_J3 = -32'd94;  dfidqd_prev_mat_in_LY_J4 = -32'd13222; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd10554; dfidqd_prev_mat_in_LZ_J2 = -32'd135202; dfidqd_prev_mat_in_LZ_J3 = -32'd9858;  dfidqd_prev_mat_in_LZ_J4 = 32'd45277; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 5 Outputs
      $display ("// Link 5 Test");
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
      minv_prev_vec_in_C1 = 32'd212790; minv_prev_vec_in_C2 = -32'd42572; minv_prev_vec_in_C3 = -32'd2752466; minv_prev_vec_in_C4 = -32'd201513; minv_prev_vec_in_C5 = 32'd2574713; minv_prev_vec_in_C6 = -32'd45311; minv_prev_vec_in_C7 = 32'd12325;
      // 3
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd2621; dfidq_prev_mat_in_AX_J3 = 32'd15599;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd10348; dfidq_prev_mat_in_AY_J3 = 32'd21009;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd1137; dfidq_prev_mat_in_AZ_J3 = -32'd2999;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd51071; dfidq_prev_mat_in_LX_J3 = 32'd102173;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd1313; dfidq_prev_mat_in_LY_J3 = -32'd68019;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd57033; dfidq_prev_mat_in_LZ_J3 = 32'd16263;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1897; dfidqd_prev_mat_in_AX_J2 = -32'd19915; dfidqd_prev_mat_in_AX_J3 = 32'd2933;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd10769; dfidqd_prev_mat_in_AY_J2 = -32'd13702; dfidqd_prev_mat_in_AY_J3 = 32'd147;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd1521; dfidqd_prev_mat_in_AZ_J2 = 32'd1936; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd53805; dfidqd_prev_mat_in_LX_J2 = -32'd68646; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22821; dfidqd_prev_mat_in_LY_J2 = 32'd97882; dfidqd_prev_mat_in_LY_J3 = -32'd22583;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd23054; dfidqd_prev_mat_in_LZ_J2 = -32'd23480; dfidqd_prev_mat_in_LZ_J3 = -32'd22;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 4 Outputs
      $display ("// Link 4 Test");
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
      minv_prev_vec_in_C1 = 32'd54563; minv_prev_vec_in_C2 = -32'd53716; minv_prev_vec_in_C3 = -32'd42572; minv_prev_vec_in_C4 = -32'd122649; minv_prev_vec_in_C5 = -32'd19260; minv_prev_vec_in_C6 = -32'd89991; minv_prev_vec_in_C7 = 32'd23027;
      // 2
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd2709; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd126; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd2017; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd8454; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd17508; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd6786; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd469; dfidqd_prev_mat_in_AX_J2 = 32'd6644; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd375; dfidqd_prev_mat_in_AY_J2 = -32'd304; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd2077; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd10572; dfidqd_prev_mat_in_LX_J2 = -32'd40; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd4252; dfidqd_prev_mat_in_LY_J2 = -32'd7785; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd14781; dfidqd_prev_mat_in_LZ_J2 = 32'd28755; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 3 Outputs
      $display ("// Link 3 Test");
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
      minv_prev_vec_in_C1 = -32'd216819; minv_prev_vec_in_C2 = 32'd54563; minv_prev_vec_in_C3 = 32'd212790; minv_prev_vec_in_C4 = 32'd193436; minv_prev_vec_in_C5 = -32'd66476; minv_prev_vec_in_C6 = -32'd25864; minv_prev_vec_in_C7 = 32'd21064;
      // 1
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd1887; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd15727; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 2 Outputs
      $display ("// Link 2 Test");
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
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0;
      // 0
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // Hold for 3 cycles for Link 1 Outputs
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 2
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 1
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 1 Outputs
      $display ("// Link 1 Test");
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
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
      //------------------------------------------------------------------------
      // set values
      //------------------------------------------------------------------------
      $display ("// Knot 9 Link 8 Init");
      //------------------------------------------------------------------------
      // Link 8 Inputs
      // 7
      sinq_prev_in = 32'd49084; cosq_prev_in = -32'd43424;
      f_prev_vec_in_AX = 32'd8044; f_prev_vec_in_AY = -32'd6533; f_prev_vec_in_AZ = 32'd5043; f_prev_vec_in_LX = -32'd120315; f_prev_vec_in_LY = -32'd133594; f_prev_vec_in_LZ = -32'd13832;
      // 7
      // minv_prev_vec_in_C1 = 0.321418; minv_prev_vec_in_C2 = 0.35137; minv_prev_vec_in_C3 = 0.188062; minv_prev_vec_in_C4 = 2.85474; minv_prev_vec_in_C5 = 98.7838; minv_prev_vec_in_C6 = 4.79672; minv_prev_vec_in_C7 = -1095.04;
      minv_prev_vec_in_C1 = 32'd21064; minv_prev_vec_in_C2 = 32'd23027; minv_prev_vec_in_C3 = 32'd12325; minv_prev_vec_in_C4 = 32'd187088; minv_prev_vec_in_C5 = 32'd6473895; minv_prev_vec_in_C6 = 32'd314358; minv_prev_vec_in_C7 = -32'd71764541;
      // 7
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd155; dfidq_prev_mat_in_AX_J3 = 32'd691;  dfidq_prev_mat_in_AX_J4 = 32'd463; dfidq_prev_mat_in_AX_J5 = 32'd126; dfidq_prev_mat_in_AX_J6 = 32'd1874; dfidq_prev_mat_in_AX_J7 = -32'd6533;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd52; dfidq_prev_mat_in_AY_J3 = -32'd424;  dfidq_prev_mat_in_AY_J4 = 32'd142; dfidq_prev_mat_in_AY_J5 = 32'd895; dfidq_prev_mat_in_AY_J6 = 32'd1840; dfidq_prev_mat_in_AY_J7 = -32'd8044;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd35; dfidq_prev_mat_in_AZ_J3 = -32'd3;  dfidq_prev_mat_in_AZ_J4 = 32'd72; dfidq_prev_mat_in_AZ_J5 = -32'd75; dfidq_prev_mat_in_AZ_J6 = -32'd454; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd3285; dfidq_prev_mat_in_LX_J3 = -32'd13804;  dfidq_prev_mat_in_LX_J4 = 32'd6498; dfidq_prev_mat_in_LX_J5 = 32'd35032; dfidq_prev_mat_in_LX_J6 = 32'd34895; dfidq_prev_mat_in_LX_J7 = -32'd133594;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd10772; dfidq_prev_mat_in_LY_J3 = -32'd28595;  dfidq_prev_mat_in_LY_J4 = -32'd29148; dfidq_prev_mat_in_LY_J5 = -32'd4116; dfidq_prev_mat_in_LY_J6 = -32'd35504; dfidq_prev_mat_in_LY_J7 = 32'd120316;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd19629; dfidq_prev_mat_in_LZ_J3 = 32'd12420;  dfidq_prev_mat_in_LZ_J4 = 32'd15012; dfidq_prev_mat_in_LZ_J5 = -32'd6108; dfidq_prev_mat_in_LZ_J6 = -32'd26838; dfidq_prev_mat_in_LZ_J7 = -32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd204; dfidqd_prev_mat_in_AX_J2 = -32'd355; dfidqd_prev_mat_in_AX_J3 = 32'd58;  dfidqd_prev_mat_in_AX_J4 = 32'd128; dfidqd_prev_mat_in_AX_J5 = 32'd34; dfidqd_prev_mat_in_AX_J6 = 32'd184; dfidqd_prev_mat_in_AX_J7 = 32'd43;
      dfidqd_prev_mat_in_AY_J1 = -32'd186; dfidqd_prev_mat_in_AY_J2 = 32'd404; dfidqd_prev_mat_in_AY_J3 = -32'd176;  dfidqd_prev_mat_in_AY_J4 = -32'd786; dfidqd_prev_mat_in_AY_J5 = 32'd108; dfidqd_prev_mat_in_AY_J6 = 32'd208; dfidqd_prev_mat_in_AY_J7 = -32'd12;
      dfidqd_prev_mat_in_AZ_J1 = -32'd9; dfidqd_prev_mat_in_AZ_J2 = -32'd29; dfidqd_prev_mat_in_AZ_J3 = -32'd8;  dfidqd_prev_mat_in_AZ_J4 = 32'd69; dfidqd_prev_mat_in_AZ_J5 = -32'd23; dfidqd_prev_mat_in_AZ_J6 = -32'd41; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd10435; dfidqd_prev_mat_in_LX_J2 = 32'd23638; dfidqd_prev_mat_in_LX_J3 = -32'd7656;  dfidqd_prev_mat_in_LX_J4 = -32'd37658; dfidqd_prev_mat_in_LX_J5 = 32'd3027; dfidqd_prev_mat_in_LX_J6 = 32'd6737; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd13340; dfidqd_prev_mat_in_LY_J2 = 32'd20050; dfidqd_prev_mat_in_LY_J3 = 32'd289;  dfidqd_prev_mat_in_LY_J4 = -32'd5454; dfidqd_prev_mat_in_LY_J5 = 32'd998; dfidqd_prev_mat_in_LY_J6 = -32'd5960; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd8477; dfidqd_prev_mat_in_LZ_J2 = -32'd12323; dfidqd_prev_mat_in_LZ_J3 = 32'd1071;  dfidqd_prev_mat_in_LZ_J4 = -32'd549; dfidqd_prev_mat_in_LZ_J5 = -32'd757; dfidqd_prev_mat_in_LZ_J6 = 32'd1182; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Ignore Outputs
      //------------------------------------------------------------------------
      // Link 7 Inputs
      // 6
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      // 6
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = -32'd25864; minv_prev_vec_in_C2 = -32'd89991; minv_prev_vec_in_C3 = -32'd45311; minv_prev_vec_in_C4 = -32'd358665; minv_prev_vec_in_C5 = -32'd204961; minv_prev_vec_in_C6 = -32'd8039236; minv_prev_vec_in_C7 = 32'd314358;
      // 6
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd284; dfidq_prev_mat_in_AX_J3 = -32'd35;  dfidq_prev_mat_in_AX_J4 = 32'd259; dfidq_prev_mat_in_AX_J5 = 32'd931; dfidq_prev_mat_in_AX_J6 = 32'd8200; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd123; dfidq_prev_mat_in_AY_J3 = -32'd73;  dfidq_prev_mat_in_AY_J4 = 32'd247; dfidq_prev_mat_in_AY_J5 = -32'd245; dfidq_prev_mat_in_AY_J6 = -32'd1679; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd151; dfidq_prev_mat_in_AZ_J3 = 32'd839;  dfidq_prev_mat_in_AZ_J4 = 32'd23; dfidq_prev_mat_in_AZ_J5 = -32'd794; dfidq_prev_mat_in_AZ_J6 = -32'd389; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd32323; dfidq_prev_mat_in_LX_J3 = -32'd160291;  dfidq_prev_mat_in_LX_J4 = -32'd90398; dfidq_prev_mat_in_LX_J5 = 32'd80218; dfidq_prev_mat_in_LX_J6 = -32'd77343; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd111481; dfidq_prev_mat_in_LY_J3 = 32'd77173;  dfidq_prev_mat_in_LY_J4 = 32'd64413; dfidq_prev_mat_in_LY_J5 = -32'd25932; dfidq_prev_mat_in_LY_J6 = -32'd128801; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd49161; dfidq_prev_mat_in_LZ_J3 = 32'd46245;  dfidq_prev_mat_in_LZ_J4 = 32'd109642; dfidq_prev_mat_in_LZ_J5 = 32'd145168; dfidq_prev_mat_in_LZ_J6 = 32'd1770; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd76; dfidqd_prev_mat_in_AX_J2 = -32'd2; dfidqd_prev_mat_in_AX_J3 = 32'd75;  dfidqd_prev_mat_in_AX_J4 = -32'd411; dfidqd_prev_mat_in_AX_J5 = 32'd337; dfidqd_prev_mat_in_AX_J6 = 32'd906; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd36; dfidqd_prev_mat_in_AY_J2 = -32'd40; dfidqd_prev_mat_in_AY_J3 = -32'd44;  dfidqd_prev_mat_in_AY_J4 = 32'd186; dfidqd_prev_mat_in_AY_J5 = -32'd85; dfidqd_prev_mat_in_AY_J6 = -32'd135; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd53; dfidqd_prev_mat_in_AZ_J2 = -32'd127; dfidqd_prev_mat_in_AZ_J3 = 32'd123;  dfidqd_prev_mat_in_AZ_J4 = 32'd558; dfidqd_prev_mat_in_AZ_J5 = -32'd149; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd5723; dfidqd_prev_mat_in_LX_J2 = 32'd166896; dfidqd_prev_mat_in_LX_J3 = -32'd36058;  dfidqd_prev_mat_in_LX_J4 = -32'd143888; dfidqd_prev_mat_in_LX_J5 = 32'd77; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd43324; dfidqd_prev_mat_in_LY_J2 = -32'd60969; dfidqd_prev_mat_in_LY_J3 = 32'd11058;  dfidqd_prev_mat_in_LY_J4 = -32'd9066; dfidqd_prev_mat_in_LY_J5 = -32'd92; dfidqd_prev_mat_in_LY_J6 = 32'd42; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd94049; dfidqd_prev_mat_in_LZ_J2 = 32'd24373; dfidqd_prev_mat_in_LZ_J3 = -32'd36659;  dfidqd_prev_mat_in_LZ_J4 = -32'd120581; dfidqd_prev_mat_in_LZ_J5 = -32'd164; dfidqd_prev_mat_in_LZ_J6 = 32'd321; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 7 Outputs
      $display ("// Link 7 Test");
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
      minv_prev_vec_in_C1 = -32'd66476; minv_prev_vec_in_C2 = -32'd19260; minv_prev_vec_in_C3 = 32'd2574713; minv_prev_vec_in_C4 = -32'd105892; minv_prev_vec_in_C5 = -32'd9289794; minv_prev_vec_in_C6 = -32'd204961; minv_prev_vec_in_C7 = 32'd6473895;
      // 5
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd4354; dfidq_prev_mat_in_AX_J3 = 32'd3320;  dfidq_prev_mat_in_AX_J4 = 32'd7150; dfidq_prev_mat_in_AX_J5 = 32'd10972; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd4610; dfidq_prev_mat_in_AY_J3 = -32'd12747;  dfidq_prev_mat_in_AY_J4 = -32'd7214; dfidq_prev_mat_in_AY_J5 = 32'd5786; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd1038; dfidq_prev_mat_in_AZ_J3 = 32'd2853;  dfidq_prev_mat_in_AZ_J4 = 32'd1647; dfidq_prev_mat_in_AZ_J5 = -32'd564; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd48590; dfidq_prev_mat_in_LX_J3 = -32'd137401;  dfidq_prev_mat_in_LX_J4 = -32'd65942; dfidq_prev_mat_in_LX_J5 = 32'd23191; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd45129; dfidq_prev_mat_in_LY_J3 = -32'd36066;  dfidq_prev_mat_in_LY_J4 = -32'd70817; dfidq_prev_mat_in_LY_J5 = -32'd96617; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd62580; dfidq_prev_mat_in_LZ_J3 = 32'd13151;  dfidq_prev_mat_in_LZ_J4 = -32'd4659; dfidq_prev_mat_in_LZ_J5 = 32'd7121; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd5945; dfidqd_prev_mat_in_AX_J2 = 32'd1309; dfidqd_prev_mat_in_AX_J3 = -32'd1513;  dfidqd_prev_mat_in_AX_J4 = -32'd8879; dfidqd_prev_mat_in_AX_J5 = 32'd1237; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd1314; dfidqd_prev_mat_in_AY_J2 = 32'd12420; dfidqd_prev_mat_in_AY_J3 = -32'd2697;  dfidqd_prev_mat_in_AY_J4 = -32'd9465; dfidqd_prev_mat_in_AY_J5 = 32'd16; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd394; dfidqd_prev_mat_in_AZ_J2 = -32'd3077; dfidqd_prev_mat_in_AZ_J3 = 32'd491;  dfidqd_prev_mat_in_AZ_J4 = 32'd2025; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd20251; dfidqd_prev_mat_in_LX_J2 = 32'd140948; dfidqd_prev_mat_in_LX_J3 = -32'd23281;  dfidqd_prev_mat_in_LX_J4 = -32'd84990; dfidqd_prev_mat_in_LX_J5 = -32'd52; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd57716; dfidqd_prev_mat_in_LY_J2 = -32'd18551; dfidqd_prev_mat_in_LY_J3 = 32'd11438;  dfidqd_prev_mat_in_LY_J4 = 32'd73710; dfidqd_prev_mat_in_LY_J5 = -32'd10981; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd24770; dfidqd_prev_mat_in_LZ_J2 = -32'd13522; dfidqd_prev_mat_in_LZ_J3 = 32'd1380;  dfidqd_prev_mat_in_LZ_J4 = -32'd31010; dfidqd_prev_mat_in_LZ_J5 = 32'd3378; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 6 Outputs
      $display ("// Link 6 Test");
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
      minv_prev_vec_in_C1 = 32'd193436; minv_prev_vec_in_C2 = -32'd122649; minv_prev_vec_in_C3 = -32'd201513; minv_prev_vec_in_C4 = -32'd437695; minv_prev_vec_in_C5 = -32'd105892; minv_prev_vec_in_C6 = -32'd358665; minv_prev_vec_in_C7 = 32'd187088;
      // 4
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd826; dfidq_prev_mat_in_AX_J3 = 32'd8949;  dfidq_prev_mat_in_AX_J4 = 32'd1941; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd2678; dfidq_prev_mat_in_AY_J3 = 32'd4680;  dfidq_prev_mat_in_AY_J4 = 32'd1622; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd5904; dfidq_prev_mat_in_AZ_J3 = -32'd12157;  dfidq_prev_mat_in_AZ_J4 = -32'd6891; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd76136; dfidq_prev_mat_in_LX_J3 = 32'd136829;  dfidq_prev_mat_in_LX_J4 = 32'd35836; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd55811; dfidq_prev_mat_in_LY_J3 = -32'd9425;  dfidq_prev_mat_in_LY_J4 = -32'd53266; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd3436; dfidq_prev_mat_in_LZ_J3 = 32'd89127;  dfidq_prev_mat_in_LZ_J4 = 32'd1368; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1436; dfidqd_prev_mat_in_AX_J2 = -32'd9457; dfidqd_prev_mat_in_AX_J3 = 32'd1126;  dfidqd_prev_mat_in_AX_J4 = 32'd9615; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd2460; dfidqd_prev_mat_in_AY_J2 = -32'd3074; dfidqd_prev_mat_in_AY_J3 = -32'd13;  dfidqd_prev_mat_in_AY_J4 = 32'd277; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd5950; dfidqd_prev_mat_in_AZ_J2 = 32'd7332; dfidqd_prev_mat_in_AZ_J3 = -32'd181;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd73332; dfidqd_prev_mat_in_LX_J2 = -32'd89415; dfidqd_prev_mat_in_LX_J3 = -32'd473;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22838; dfidqd_prev_mat_in_LY_J2 = -32'd43368; dfidqd_prev_mat_in_LY_J3 = -32'd94;  dfidqd_prev_mat_in_LY_J4 = -32'd13222; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd10554; dfidqd_prev_mat_in_LZ_J2 = -32'd135202; dfidqd_prev_mat_in_LZ_J3 = -32'd9858;  dfidqd_prev_mat_in_LZ_J4 = 32'd45277; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 5 Outputs
      $display ("// Link 5 Test");
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
      minv_prev_vec_in_C1 = 32'd212790; minv_prev_vec_in_C2 = -32'd42572; minv_prev_vec_in_C3 = -32'd2752466; minv_prev_vec_in_C4 = -32'd201513; minv_prev_vec_in_C5 = 32'd2574713; minv_prev_vec_in_C6 = -32'd45311; minv_prev_vec_in_C7 = 32'd12325;
      // 3
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd2621; dfidq_prev_mat_in_AX_J3 = 32'd15599;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd10348; dfidq_prev_mat_in_AY_J3 = 32'd21009;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd1137; dfidq_prev_mat_in_AZ_J3 = -32'd2999;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd51071; dfidq_prev_mat_in_LX_J3 = 32'd102173;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd1313; dfidq_prev_mat_in_LY_J3 = -32'd68019;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd57033; dfidq_prev_mat_in_LZ_J3 = 32'd16263;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1897; dfidqd_prev_mat_in_AX_J2 = -32'd19915; dfidqd_prev_mat_in_AX_J3 = 32'd2933;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd10769; dfidqd_prev_mat_in_AY_J2 = -32'd13702; dfidqd_prev_mat_in_AY_J3 = 32'd147;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd1521; dfidqd_prev_mat_in_AZ_J2 = 32'd1936; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd53805; dfidqd_prev_mat_in_LX_J2 = -32'd68646; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22821; dfidqd_prev_mat_in_LY_J2 = 32'd97882; dfidqd_prev_mat_in_LY_J3 = -32'd22583;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd23054; dfidqd_prev_mat_in_LZ_J2 = -32'd23480; dfidqd_prev_mat_in_LZ_J3 = -32'd22;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 4 Outputs
      $display ("// Link 4 Test");
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
      minv_prev_vec_in_C1 = 32'd54563; minv_prev_vec_in_C2 = -32'd53716; minv_prev_vec_in_C3 = -32'd42572; minv_prev_vec_in_C4 = -32'd122649; minv_prev_vec_in_C5 = -32'd19260; minv_prev_vec_in_C6 = -32'd89991; minv_prev_vec_in_C7 = 32'd23027;
      // 2
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd2709; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd126; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd2017; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd8454; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd17508; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd6786; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd469; dfidqd_prev_mat_in_AX_J2 = 32'd6644; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd375; dfidqd_prev_mat_in_AY_J2 = -32'd304; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd2077; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd10572; dfidqd_prev_mat_in_LX_J2 = -32'd40; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd4252; dfidqd_prev_mat_in_LY_J2 = -32'd7785; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd14781; dfidqd_prev_mat_in_LZ_J2 = 32'd28755; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 3 Outputs
      $display ("// Link 3 Test");
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
      minv_prev_vec_in_C1 = -32'd216819; minv_prev_vec_in_C2 = 32'd54563; minv_prev_vec_in_C3 = 32'd212790; minv_prev_vec_in_C4 = 32'd193436; minv_prev_vec_in_C5 = -32'd66476; minv_prev_vec_in_C6 = -32'd25864; minv_prev_vec_in_C7 = 32'd21064;
      // 1
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd1887; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd15727; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 2 Outputs
      $display ("// Link 2 Test");
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
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0;
      // 0
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // Hold for 3 cycles for Link 1 Outputs
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 2
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 1
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 1 Outputs
      $display ("// Link 1 Test");
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
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
//       get_data = 0;
//       clk = 1;
//       #2;
//       clk = 0;
//       #2;
      //------------------------------------------------------------------------
      // set values
      //------------------------------------------------------------------------
      $display ("// Knot 10 Link 8 Init");
      //------------------------------------------------------------------------
      // Link 8 Inputs
      // 7
      sinq_prev_in = 32'd49084; cosq_prev_in = -32'd43424;
      f_prev_vec_in_AX = 32'd8044; f_prev_vec_in_AY = -32'd6533; f_prev_vec_in_AZ = 32'd5043; f_prev_vec_in_LX = -32'd120315; f_prev_vec_in_LY = -32'd133594; f_prev_vec_in_LZ = -32'd13832;
      // 7
      // minv_prev_vec_in_C1 = 0.321418; minv_prev_vec_in_C2 = 0.35137; minv_prev_vec_in_C3 = 0.188062; minv_prev_vec_in_C4 = 2.85474; minv_prev_vec_in_C5 = 98.7838; minv_prev_vec_in_C6 = 4.79672; minv_prev_vec_in_C7 = -1095.04;
      minv_prev_vec_in_C1 = 32'd21064; minv_prev_vec_in_C2 = 32'd23027; minv_prev_vec_in_C3 = 32'd12325; minv_prev_vec_in_C4 = 32'd187088; minv_prev_vec_in_C5 = 32'd6473895; minv_prev_vec_in_C6 = 32'd314358; minv_prev_vec_in_C7 = -32'd71764541;
      // 7
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd155; dfidq_prev_mat_in_AX_J3 = 32'd691;  dfidq_prev_mat_in_AX_J4 = 32'd463; dfidq_prev_mat_in_AX_J5 = 32'd126; dfidq_prev_mat_in_AX_J6 = 32'd1874; dfidq_prev_mat_in_AX_J7 = -32'd6533;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd52; dfidq_prev_mat_in_AY_J3 = -32'd424;  dfidq_prev_mat_in_AY_J4 = 32'd142; dfidq_prev_mat_in_AY_J5 = 32'd895; dfidq_prev_mat_in_AY_J6 = 32'd1840; dfidq_prev_mat_in_AY_J7 = -32'd8044;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd35; dfidq_prev_mat_in_AZ_J3 = -32'd3;  dfidq_prev_mat_in_AZ_J4 = 32'd72; dfidq_prev_mat_in_AZ_J5 = -32'd75; dfidq_prev_mat_in_AZ_J6 = -32'd454; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd3285; dfidq_prev_mat_in_LX_J3 = -32'd13804;  dfidq_prev_mat_in_LX_J4 = 32'd6498; dfidq_prev_mat_in_LX_J5 = 32'd35032; dfidq_prev_mat_in_LX_J6 = 32'd34895; dfidq_prev_mat_in_LX_J7 = -32'd133594;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd10772; dfidq_prev_mat_in_LY_J3 = -32'd28595;  dfidq_prev_mat_in_LY_J4 = -32'd29148; dfidq_prev_mat_in_LY_J5 = -32'd4116; dfidq_prev_mat_in_LY_J6 = -32'd35504; dfidq_prev_mat_in_LY_J7 = 32'd120316;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd19629; dfidq_prev_mat_in_LZ_J3 = 32'd12420;  dfidq_prev_mat_in_LZ_J4 = 32'd15012; dfidq_prev_mat_in_LZ_J5 = -32'd6108; dfidq_prev_mat_in_LZ_J6 = -32'd26838; dfidq_prev_mat_in_LZ_J7 = -32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd204; dfidqd_prev_mat_in_AX_J2 = -32'd355; dfidqd_prev_mat_in_AX_J3 = 32'd58;  dfidqd_prev_mat_in_AX_J4 = 32'd128; dfidqd_prev_mat_in_AX_J5 = 32'd34; dfidqd_prev_mat_in_AX_J6 = 32'd184; dfidqd_prev_mat_in_AX_J7 = 32'd43;
      dfidqd_prev_mat_in_AY_J1 = -32'd186; dfidqd_prev_mat_in_AY_J2 = 32'd404; dfidqd_prev_mat_in_AY_J3 = -32'd176;  dfidqd_prev_mat_in_AY_J4 = -32'd786; dfidqd_prev_mat_in_AY_J5 = 32'd108; dfidqd_prev_mat_in_AY_J6 = 32'd208; dfidqd_prev_mat_in_AY_J7 = -32'd12;
      dfidqd_prev_mat_in_AZ_J1 = -32'd9; dfidqd_prev_mat_in_AZ_J2 = -32'd29; dfidqd_prev_mat_in_AZ_J3 = -32'd8;  dfidqd_prev_mat_in_AZ_J4 = 32'd69; dfidqd_prev_mat_in_AZ_J5 = -32'd23; dfidqd_prev_mat_in_AZ_J6 = -32'd41; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd10435; dfidqd_prev_mat_in_LX_J2 = 32'd23638; dfidqd_prev_mat_in_LX_J3 = -32'd7656;  dfidqd_prev_mat_in_LX_J4 = -32'd37658; dfidqd_prev_mat_in_LX_J5 = 32'd3027; dfidqd_prev_mat_in_LX_J6 = 32'd6737; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd13340; dfidqd_prev_mat_in_LY_J2 = 32'd20050; dfidqd_prev_mat_in_LY_J3 = 32'd289;  dfidqd_prev_mat_in_LY_J4 = -32'd5454; dfidqd_prev_mat_in_LY_J5 = 32'd998; dfidqd_prev_mat_in_LY_J6 = -32'd5960; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd8477; dfidqd_prev_mat_in_LZ_J2 = -32'd12323; dfidqd_prev_mat_in_LZ_J3 = 32'd1071;  dfidqd_prev_mat_in_LZ_J4 = -32'd549; dfidqd_prev_mat_in_LZ_J5 = -32'd757; dfidqd_prev_mat_in_LZ_J6 = 32'd1182; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Ignore Outputs
      //------------------------------------------------------------------------
      // Link 7 Inputs
      // 6
      sinq_prev_in = 32'd20062; cosq_prev_in = 32'd62390;
      f_prev_vec_in_AX = 32'd2203; f_prev_vec_in_AY = 32'd5901; f_prev_vec_in_AZ = 32'd31413; f_prev_vec_in_LX = 32'd121436; f_prev_vec_in_LY = -32'd77713; f_prev_vec_in_LZ = -32'd83897;
      // 6
      // minv_prev_vec_in_C1 = -0.394646; minv_prev_vec_in_C2 = -1.37315; minv_prev_vec_in_C3 = -0.691391; minv_prev_vec_in_C4 = -5.4728; minv_prev_vec_in_C5 = -3.12746; minv_prev_vec_in_C6 = -122.669; minv_prev_vec_in_C7 = 4.79672;
      minv_prev_vec_in_C1 = -32'd25864; minv_prev_vec_in_C2 = -32'd89991; minv_prev_vec_in_C3 = -32'd45311; minv_prev_vec_in_C4 = -32'd358665; minv_prev_vec_in_C5 = -32'd204961; minv_prev_vec_in_C6 = -32'd8039236; minv_prev_vec_in_C7 = 32'd314358;
      // 6
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd284; dfidq_prev_mat_in_AX_J3 = -32'd35;  dfidq_prev_mat_in_AX_J4 = 32'd259; dfidq_prev_mat_in_AX_J5 = 32'd931; dfidq_prev_mat_in_AX_J6 = 32'd8200; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd123; dfidq_prev_mat_in_AY_J3 = -32'd73;  dfidq_prev_mat_in_AY_J4 = 32'd247; dfidq_prev_mat_in_AY_J5 = -32'd245; dfidq_prev_mat_in_AY_J6 = -32'd1679; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd151; dfidq_prev_mat_in_AZ_J3 = 32'd839;  dfidq_prev_mat_in_AZ_J4 = 32'd23; dfidq_prev_mat_in_AZ_J5 = -32'd794; dfidq_prev_mat_in_AZ_J6 = -32'd389; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd32323; dfidq_prev_mat_in_LX_J3 = -32'd160291;  dfidq_prev_mat_in_LX_J4 = -32'd90398; dfidq_prev_mat_in_LX_J5 = 32'd80218; dfidq_prev_mat_in_LX_J6 = -32'd77343; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd111481; dfidq_prev_mat_in_LY_J3 = 32'd77173;  dfidq_prev_mat_in_LY_J4 = 32'd64413; dfidq_prev_mat_in_LY_J5 = -32'd25932; dfidq_prev_mat_in_LY_J6 = -32'd128801; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd49161; dfidq_prev_mat_in_LZ_J3 = 32'd46245;  dfidq_prev_mat_in_LZ_J4 = 32'd109642; dfidq_prev_mat_in_LZ_J5 = 32'd145168; dfidq_prev_mat_in_LZ_J6 = 32'd1770; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd76; dfidqd_prev_mat_in_AX_J2 = -32'd2; dfidqd_prev_mat_in_AX_J3 = 32'd75;  dfidqd_prev_mat_in_AX_J4 = -32'd411; dfidqd_prev_mat_in_AX_J5 = 32'd337; dfidqd_prev_mat_in_AX_J6 = 32'd906; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd36; dfidqd_prev_mat_in_AY_J2 = -32'd40; dfidqd_prev_mat_in_AY_J3 = -32'd44;  dfidqd_prev_mat_in_AY_J4 = 32'd186; dfidqd_prev_mat_in_AY_J5 = -32'd85; dfidqd_prev_mat_in_AY_J6 = -32'd135; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd53; dfidqd_prev_mat_in_AZ_J2 = -32'd127; dfidqd_prev_mat_in_AZ_J3 = 32'd123;  dfidqd_prev_mat_in_AZ_J4 = 32'd558; dfidqd_prev_mat_in_AZ_J5 = -32'd149; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd5723; dfidqd_prev_mat_in_LX_J2 = 32'd166896; dfidqd_prev_mat_in_LX_J3 = -32'd36058;  dfidqd_prev_mat_in_LX_J4 = -32'd143888; dfidqd_prev_mat_in_LX_J5 = 32'd77; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd43324; dfidqd_prev_mat_in_LY_J2 = -32'd60969; dfidqd_prev_mat_in_LY_J3 = 32'd11058;  dfidqd_prev_mat_in_LY_J4 = -32'd9066; dfidqd_prev_mat_in_LY_J5 = -32'd92; dfidqd_prev_mat_in_LY_J6 = 32'd42; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd94049; dfidqd_prev_mat_in_LZ_J2 = 32'd24373; dfidqd_prev_mat_in_LZ_J3 = -32'd36659;  dfidqd_prev_mat_in_LZ_J4 = -32'd120581; dfidqd_prev_mat_in_LZ_J5 = -32'd164; dfidqd_prev_mat_in_LZ_J6 = 32'd321; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 7 Outputs
      $display ("// Link 7 Test");
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
      minv_prev_vec_in_C1 = -32'd66476; minv_prev_vec_in_C2 = -32'd19260; minv_prev_vec_in_C3 = 32'd2574713; minv_prev_vec_in_C4 = -32'd105892; minv_prev_vec_in_C5 = -32'd9289794; minv_prev_vec_in_C6 = -32'd204961; minv_prev_vec_in_C7 = 32'd6473895;
      // 5
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd4354; dfidq_prev_mat_in_AX_J3 = 32'd3320;  dfidq_prev_mat_in_AX_J4 = 32'd7150; dfidq_prev_mat_in_AX_J5 = 32'd10972; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd4610; dfidq_prev_mat_in_AY_J3 = -32'd12747;  dfidq_prev_mat_in_AY_J4 = -32'd7214; dfidq_prev_mat_in_AY_J5 = 32'd5786; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd1038; dfidq_prev_mat_in_AZ_J3 = 32'd2853;  dfidq_prev_mat_in_AZ_J4 = 32'd1647; dfidq_prev_mat_in_AZ_J5 = -32'd564; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd48590; dfidq_prev_mat_in_LX_J3 = -32'd137401;  dfidq_prev_mat_in_LX_J4 = -32'd65942; dfidq_prev_mat_in_LX_J5 = 32'd23191; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd45129; dfidq_prev_mat_in_LY_J3 = -32'd36066;  dfidq_prev_mat_in_LY_J4 = -32'd70817; dfidq_prev_mat_in_LY_J5 = -32'd96617; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd62580; dfidq_prev_mat_in_LZ_J3 = 32'd13151;  dfidq_prev_mat_in_LZ_J4 = -32'd4659; dfidq_prev_mat_in_LZ_J5 = 32'd7121; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd5945; dfidqd_prev_mat_in_AX_J2 = 32'd1309; dfidqd_prev_mat_in_AX_J3 = -32'd1513;  dfidqd_prev_mat_in_AX_J4 = -32'd8879; dfidqd_prev_mat_in_AX_J5 = 32'd1237; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd1314; dfidqd_prev_mat_in_AY_J2 = 32'd12420; dfidqd_prev_mat_in_AY_J3 = -32'd2697;  dfidqd_prev_mat_in_AY_J4 = -32'd9465; dfidqd_prev_mat_in_AY_J5 = 32'd16; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd394; dfidqd_prev_mat_in_AZ_J2 = -32'd3077; dfidqd_prev_mat_in_AZ_J3 = 32'd491;  dfidqd_prev_mat_in_AZ_J4 = 32'd2025; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd20251; dfidqd_prev_mat_in_LX_J2 = 32'd140948; dfidqd_prev_mat_in_LX_J3 = -32'd23281;  dfidqd_prev_mat_in_LX_J4 = -32'd84990; dfidqd_prev_mat_in_LX_J5 = -32'd52; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd57716; dfidqd_prev_mat_in_LY_J2 = -32'd18551; dfidqd_prev_mat_in_LY_J3 = 32'd11438;  dfidqd_prev_mat_in_LY_J4 = 32'd73710; dfidqd_prev_mat_in_LY_J5 = -32'd10981; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd24770; dfidqd_prev_mat_in_LZ_J2 = -32'd13522; dfidqd_prev_mat_in_LZ_J3 = 32'd1380;  dfidqd_prev_mat_in_LZ_J4 = -32'd31010; dfidqd_prev_mat_in_LZ_J5 = 32'd3378; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 6 Outputs
      $display ("// Link 6 Test");
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
      minv_prev_vec_in_C1 = 32'd193436; minv_prev_vec_in_C2 = -32'd122649; minv_prev_vec_in_C3 = -32'd201513; minv_prev_vec_in_C4 = -32'd437695; minv_prev_vec_in_C5 = -32'd105892; minv_prev_vec_in_C6 = -32'd358665; minv_prev_vec_in_C7 = 32'd187088;
      // 4
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd826; dfidq_prev_mat_in_AX_J3 = 32'd8949;  dfidq_prev_mat_in_AX_J4 = 32'd1941; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd2678; dfidq_prev_mat_in_AY_J3 = 32'd4680;  dfidq_prev_mat_in_AY_J4 = 32'd1622; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd5904; dfidq_prev_mat_in_AZ_J3 = -32'd12157;  dfidq_prev_mat_in_AZ_J4 = -32'd6891; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd76136; dfidq_prev_mat_in_LX_J3 = 32'd136829;  dfidq_prev_mat_in_LX_J4 = 32'd35836; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd55811; dfidq_prev_mat_in_LY_J3 = -32'd9425;  dfidq_prev_mat_in_LY_J4 = -32'd53266; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd3436; dfidq_prev_mat_in_LZ_J3 = 32'd89127;  dfidq_prev_mat_in_LZ_J4 = 32'd1368; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1436; dfidqd_prev_mat_in_AX_J2 = -32'd9457; dfidqd_prev_mat_in_AX_J3 = 32'd1126;  dfidqd_prev_mat_in_AX_J4 = 32'd9615; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd2460; dfidqd_prev_mat_in_AY_J2 = -32'd3074; dfidqd_prev_mat_in_AY_J3 = -32'd13;  dfidqd_prev_mat_in_AY_J4 = 32'd277; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd5950; dfidqd_prev_mat_in_AZ_J2 = 32'd7332; dfidqd_prev_mat_in_AZ_J3 = -32'd181;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd73332; dfidqd_prev_mat_in_LX_J2 = -32'd89415; dfidqd_prev_mat_in_LX_J3 = -32'd473;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22838; dfidqd_prev_mat_in_LY_J2 = -32'd43368; dfidqd_prev_mat_in_LY_J3 = -32'd94;  dfidqd_prev_mat_in_LY_J4 = -32'd13222; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd10554; dfidqd_prev_mat_in_LZ_J2 = -32'd135202; dfidqd_prev_mat_in_LZ_J3 = -32'd9858;  dfidqd_prev_mat_in_LZ_J4 = 32'd45277; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 5 Outputs
      $display ("// Link 5 Test");
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
      minv_prev_vec_in_C1 = 32'd212790; minv_prev_vec_in_C2 = -32'd42572; minv_prev_vec_in_C3 = -32'd2752466; minv_prev_vec_in_C4 = -32'd201513; minv_prev_vec_in_C5 = 32'd2574713; minv_prev_vec_in_C6 = -32'd45311; minv_prev_vec_in_C7 = 32'd12325;
      // 3
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = -32'd2621; dfidq_prev_mat_in_AX_J3 = 32'd15599;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd10348; dfidq_prev_mat_in_AY_J3 = 32'd21009;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd1137; dfidq_prev_mat_in_AZ_J3 = -32'd2999;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = -32'd51071; dfidq_prev_mat_in_LX_J3 = 32'd102173;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd1313; dfidq_prev_mat_in_LY_J3 = -32'd68019;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = -32'd57033; dfidq_prev_mat_in_LZ_J3 = 32'd16263;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd1897; dfidqd_prev_mat_in_AX_J2 = -32'd19915; dfidqd_prev_mat_in_AX_J3 = 32'd2933;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = -32'd10769; dfidqd_prev_mat_in_AY_J2 = -32'd13702; dfidqd_prev_mat_in_AY_J3 = 32'd147;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd1521; dfidqd_prev_mat_in_AZ_J2 = 32'd1936; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = -32'd53805; dfidqd_prev_mat_in_LX_J2 = -32'd68646; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd22821; dfidqd_prev_mat_in_LY_J2 = 32'd97882; dfidqd_prev_mat_in_LY_J3 = -32'd22583;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd23054; dfidqd_prev_mat_in_LZ_J2 = -32'd23480; dfidqd_prev_mat_in_LZ_J3 = -32'd22;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 4 Outputs
      $display ("// Link 4 Test");
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
      minv_prev_vec_in_C1 = 32'd54563; minv_prev_vec_in_C2 = -32'd53716; minv_prev_vec_in_C3 = -32'd42572; minv_prev_vec_in_C4 = -32'd122649; minv_prev_vec_in_C5 = -32'd19260; minv_prev_vec_in_C6 = -32'd89991; minv_prev_vec_in_C7 = 32'd23027;
      // 2
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd2709; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = -32'd126; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = -32'd2017; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd8454; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = -32'd17508; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd6786; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd469; dfidqd_prev_mat_in_AX_J2 = 32'd6644; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd375; dfidqd_prev_mat_in_AY_J2 = -32'd304; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = -32'd2077; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd10572; dfidqd_prev_mat_in_LX_J2 = -32'd40; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = -32'd4252; dfidqd_prev_mat_in_LY_J2 = -32'd7785; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = -32'd14781; dfidqd_prev_mat_in_LZ_J2 = 32'd28755; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 3 Outputs
      $display ("// Link 3 Test");
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
      minv_prev_vec_in_C1 = -32'd216819; minv_prev_vec_in_C2 = 32'd54563; minv_prev_vec_in_C3 = 32'd212790; minv_prev_vec_in_C4 = 32'd193436; minv_prev_vec_in_C5 = -32'd66476; minv_prev_vec_in_C6 = -32'd25864; minv_prev_vec_in_C7 = 32'd21064;
      // 1
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = -32'd1887; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd15727; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 2 Outputs
      $display ("// Link 2 Test");
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
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0;
      // 0
      dfidq_prev_mat_in_AX_J1 = 32'd0; dfidq_prev_mat_in_AX_J2 = 32'd0; dfidq_prev_mat_in_AX_J3 = 32'd0;  dfidq_prev_mat_in_AX_J4 = 32'd0; dfidq_prev_mat_in_AX_J5 = 32'd0; dfidq_prev_mat_in_AX_J6 = 32'd0; dfidq_prev_mat_in_AX_J7 = 32'd0;
      dfidq_prev_mat_in_AY_J1 = 32'd0; dfidq_prev_mat_in_AY_J2 = 32'd0; dfidq_prev_mat_in_AY_J3 = 32'd0;  dfidq_prev_mat_in_AY_J4 = 32'd0; dfidq_prev_mat_in_AY_J5 = 32'd0; dfidq_prev_mat_in_AY_J6 = 32'd0; dfidq_prev_mat_in_AY_J7 = 32'd0;
      dfidq_prev_mat_in_AZ_J1 = 32'd0; dfidq_prev_mat_in_AZ_J2 = 32'd0; dfidq_prev_mat_in_AZ_J3 = 32'd0;  dfidq_prev_mat_in_AZ_J4 = 32'd0; dfidq_prev_mat_in_AZ_J5 = 32'd0; dfidq_prev_mat_in_AZ_J6 = 32'd0; dfidq_prev_mat_in_AZ_J7 = 32'd0;
      dfidq_prev_mat_in_LX_J1 = 32'd0; dfidq_prev_mat_in_LX_J2 = 32'd0; dfidq_prev_mat_in_LX_J3 = 32'd0;  dfidq_prev_mat_in_LX_J4 = 32'd0; dfidq_prev_mat_in_LX_J5 = 32'd0; dfidq_prev_mat_in_LX_J6 = 32'd0; dfidq_prev_mat_in_LX_J7 = 32'd0;
      dfidq_prev_mat_in_LY_J1 = 32'd0; dfidq_prev_mat_in_LY_J2 = 32'd0; dfidq_prev_mat_in_LY_J3 = 32'd0;  dfidq_prev_mat_in_LY_J4 = 32'd0; dfidq_prev_mat_in_LY_J5 = 32'd0; dfidq_prev_mat_in_LY_J6 = 32'd0; dfidq_prev_mat_in_LY_J7 = 32'd0;
      dfidq_prev_mat_in_LZ_J1 = 32'd0; dfidq_prev_mat_in_LZ_J2 = 32'd0; dfidq_prev_mat_in_LZ_J3 = 32'd0;  dfidq_prev_mat_in_LZ_J4 = 32'd0; dfidq_prev_mat_in_LZ_J5 = 32'd0; dfidq_prev_mat_in_LZ_J6 = 32'd0; dfidq_prev_mat_in_LZ_J7 = 32'd0;
      dfidqd_prev_mat_in_AX_J1 = 32'd0; dfidqd_prev_mat_in_AX_J2 = 32'd0; dfidqd_prev_mat_in_AX_J3 = 32'd0;  dfidqd_prev_mat_in_AX_J4 = 32'd0; dfidqd_prev_mat_in_AX_J5 = 32'd0; dfidqd_prev_mat_in_AX_J6 = 32'd0; dfidqd_prev_mat_in_AX_J7 = 32'd0;
      dfidqd_prev_mat_in_AY_J1 = 32'd0; dfidqd_prev_mat_in_AY_J2 = 32'd0; dfidqd_prev_mat_in_AY_J3 = 32'd0;  dfidqd_prev_mat_in_AY_J4 = 32'd0; dfidqd_prev_mat_in_AY_J5 = 32'd0; dfidqd_prev_mat_in_AY_J6 = 32'd0; dfidqd_prev_mat_in_AY_J7 = 32'd0;
      dfidqd_prev_mat_in_AZ_J1 = 32'd0; dfidqd_prev_mat_in_AZ_J2 = 32'd0; dfidqd_prev_mat_in_AZ_J3 = 32'd0;  dfidqd_prev_mat_in_AZ_J4 = 32'd0; dfidqd_prev_mat_in_AZ_J5 = 32'd0; dfidqd_prev_mat_in_AZ_J6 = 32'd0; dfidqd_prev_mat_in_AZ_J7 = 32'd0;
      dfidqd_prev_mat_in_LX_J1 = 32'd0; dfidqd_prev_mat_in_LX_J2 = 32'd0; dfidqd_prev_mat_in_LX_J3 = 32'd0;  dfidqd_prev_mat_in_LX_J4 = 32'd0; dfidqd_prev_mat_in_LX_J5 = 32'd0; dfidqd_prev_mat_in_LX_J6 = 32'd0; dfidqd_prev_mat_in_LX_J7 = 32'd0;
      dfidqd_prev_mat_in_LY_J1 = 32'd0; dfidqd_prev_mat_in_LY_J2 = 32'd0; dfidqd_prev_mat_in_LY_J3 = 32'd0;  dfidqd_prev_mat_in_LY_J4 = 32'd0; dfidqd_prev_mat_in_LY_J5 = 32'd0; dfidqd_prev_mat_in_LY_J6 = 32'd0; dfidqd_prev_mat_in_LY_J7 = 32'd0;
      dfidqd_prev_mat_in_LZ_J1 = 32'd0; dfidqd_prev_mat_in_LZ_J2 = 32'd0; dfidqd_prev_mat_in_LZ_J3 = 32'd0;  dfidqd_prev_mat_in_LZ_J4 = 32'd0; dfidqd_prev_mat_in_LZ_J5 = 32'd0; dfidqd_prev_mat_in_LZ_J6 = 32'd0; dfidqd_prev_mat_in_LZ_J7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // Hold for 3 cycles for Link 1 Outputs
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 2
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 1; // 1
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      // Link 1 Outputs
      $display ("// Link 1 Test");
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
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      get_data = 0;
      clk = 1;
      #2;
      clk = 0;
      #2;
      //------------------------------------------------------------------------
      #1000;
      $stop;
   end

endmodule
