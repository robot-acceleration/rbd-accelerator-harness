`timescale 1ns / 1ps

// Testbench for Forward Pass Row Unit with RNEA

//------------------------------------------------------------------------------
// fproc Testbench
//------------------------------------------------------------------------------
module tb_fproc();

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
      sinq_curr_in,cosq_curr_in;
   // qd_curr_in
   reg  signed[(WIDTH-1):0]
      qd_curr_in;
   // qdd_curr_in
   reg  signed[(WIDTH-1):0]
      qdd_curr_in;
   // v_prev_vec_in, 6 values
   reg  signed[(WIDTH-1):0]
      v_prev_vec_in_AX,v_prev_vec_in_AY,v_prev_vec_in_AZ,v_prev_vec_in_LX,v_prev_vec_in_LY,v_prev_vec_in_LZ;
   // a_prev_vec_in, 6 values
   reg  signed[(WIDTH-1):0]
      a_prev_vec_in_AX,a_prev_vec_in_AY,a_prev_vec_in_AZ,a_prev_vec_in_LX,a_prev_vec_in_LY,a_prev_vec_in_LZ;
   // v_curr_vec_in
   reg  signed[(WIDTH-1):0]
      v_curr_vec_in_AX,v_curr_vec_in_AY,v_curr_vec_in_AZ,v_curr_vec_in_LX,v_curr_vec_in_LY,v_curr_vec_in_LZ;
   // a_curr_vec_in
   reg  signed[(WIDTH-1):0]
      a_curr_vec_in_AX,a_curr_vec_in_AY,a_curr_vec_in_AZ,a_curr_vec_in_LX,a_curr_vec_in_LY,a_curr_vec_in_LZ;
   // output ready
   wire output_ready;
   // dummy output
   wire dummy_output;
   // f_curr_vec_out
   wire signed[(WIDTH-1):0]
      f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ;
   // dfidq_prev_mat_out
   wire signed[(WIDTH-1):0]
      dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8,
      dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8,
      dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8,
      dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8,
      dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8,
      dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8;
   // dfidqd_prev_mat_out
   wire signed[(WIDTH-1):0]
      dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8,
      dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8,
      dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8,
      dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8,
      dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8,
      dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8;

   fproc#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // get data
      .get_data(get_data),
      // sin(q) and cos(q)
      .sinq_curr_in(sinq_curr_in),.cosq_curr_in(cosq_curr_in),
      // qd_curr_in
      .qd_curr_in(qd_curr_in),
      // qdd_curr_in
      .qdd_curr_in(qdd_curr_in),
      // output ready
      .output_ready(output_ready),
      // dummy output
      .dummy_output(dummy_output),
      // f_curr_vec_out
      .f_prev_vec_out_AX(f_prev_vec_out_AX),.f_prev_vec_out_AY(f_prev_vec_out_AY),.f_prev_vec_out_AZ(f_prev_vec_out_AZ),.f_prev_vec_out_LX(f_prev_vec_out_LX),.f_prev_vec_out_LY(f_prev_vec_out_LY),.f_prev_vec_out_LZ(f_prev_vec_out_LZ),
      // dfidq_prev_mat_out
      .dfidq_prev_mat_out_AX_J1(dfidq_prev_mat_out_AX_J1),.dfidq_prev_mat_out_AX_J2(dfidq_prev_mat_out_AX_J2),.dfidq_prev_mat_out_AX_J3(dfidq_prev_mat_out_AX_J3),.dfidq_prev_mat_out_AX_J4(dfidq_prev_mat_out_AX_J4),.dfidq_prev_mat_out_AX_J5(dfidq_prev_mat_out_AX_J5),.dfidq_prev_mat_out_AX_J6(dfidq_prev_mat_out_AX_J6),.dfidq_prev_mat_out_AX_J7(dfidq_prev_mat_out_AX_J7),.dfidq_prev_mat_out_AX_J8(dfidq_prev_mat_out_AX_J8),
      .dfidq_prev_mat_out_AY_J1(dfidq_prev_mat_out_AY_J1),.dfidq_prev_mat_out_AY_J2(dfidq_prev_mat_out_AY_J2),.dfidq_prev_mat_out_AY_J3(dfidq_prev_mat_out_AY_J3),.dfidq_prev_mat_out_AY_J4(dfidq_prev_mat_out_AY_J4),.dfidq_prev_mat_out_AY_J5(dfidq_prev_mat_out_AY_J5),.dfidq_prev_mat_out_AY_J6(dfidq_prev_mat_out_AY_J6),.dfidq_prev_mat_out_AY_J7(dfidq_prev_mat_out_AY_J7),.dfidq_prev_mat_out_AY_J8(dfidq_prev_mat_out_AY_J8),
      .dfidq_prev_mat_out_AZ_J1(dfidq_prev_mat_out_AZ_J1),.dfidq_prev_mat_out_AZ_J2(dfidq_prev_mat_out_AZ_J2),.dfidq_prev_mat_out_AZ_J3(dfidq_prev_mat_out_AZ_J3),.dfidq_prev_mat_out_AZ_J4(dfidq_prev_mat_out_AZ_J4),.dfidq_prev_mat_out_AZ_J5(dfidq_prev_mat_out_AZ_J5),.dfidq_prev_mat_out_AZ_J6(dfidq_prev_mat_out_AZ_J6),.dfidq_prev_mat_out_AZ_J7(dfidq_prev_mat_out_AZ_J7),.dfidq_prev_mat_out_AZ_J8(dfidq_prev_mat_out_AZ_J8),
      .dfidq_prev_mat_out_LX_J1(dfidq_prev_mat_out_LX_J1),.dfidq_prev_mat_out_LX_J2(dfidq_prev_mat_out_LX_J2),.dfidq_prev_mat_out_LX_J3(dfidq_prev_mat_out_LX_J3),.dfidq_prev_mat_out_LX_J4(dfidq_prev_mat_out_LX_J4),.dfidq_prev_mat_out_LX_J5(dfidq_prev_mat_out_LX_J5),.dfidq_prev_mat_out_LX_J6(dfidq_prev_mat_out_LX_J6),.dfidq_prev_mat_out_LX_J7(dfidq_prev_mat_out_LX_J7),.dfidq_prev_mat_out_LX_J8(dfidq_prev_mat_out_LX_J8),
      .dfidq_prev_mat_out_LY_J1(dfidq_prev_mat_out_LY_J1),.dfidq_prev_mat_out_LY_J2(dfidq_prev_mat_out_LY_J2),.dfidq_prev_mat_out_LY_J3(dfidq_prev_mat_out_LY_J3),.dfidq_prev_mat_out_LY_J4(dfidq_prev_mat_out_LY_J4),.dfidq_prev_mat_out_LY_J5(dfidq_prev_mat_out_LY_J5),.dfidq_prev_mat_out_LY_J6(dfidq_prev_mat_out_LY_J6),.dfidq_prev_mat_out_LY_J7(dfidq_prev_mat_out_LY_J7),.dfidq_prev_mat_out_LY_J8(dfidq_prev_mat_out_LY_J8),
      .dfidq_prev_mat_out_LZ_J1(dfidq_prev_mat_out_LZ_J1),.dfidq_prev_mat_out_LZ_J2(dfidq_prev_mat_out_LZ_J2),.dfidq_prev_mat_out_LZ_J3(dfidq_prev_mat_out_LZ_J3),.dfidq_prev_mat_out_LZ_J4(dfidq_prev_mat_out_LZ_J4),.dfidq_prev_mat_out_LZ_J5(dfidq_prev_mat_out_LZ_J5),.dfidq_prev_mat_out_LZ_J6(dfidq_prev_mat_out_LZ_J6),.dfidq_prev_mat_out_LZ_J7(dfidq_prev_mat_out_LZ_J7),.dfidq_prev_mat_out_LZ_J8(dfidq_prev_mat_out_LZ_J8),
      // dfidqd_prev_mat_out
      .dfidqd_prev_mat_out_AX_J1(dfidqd_prev_mat_out_AX_J1),.dfidqd_prev_mat_out_AX_J2(dfidqd_prev_mat_out_AX_J2),.dfidqd_prev_mat_out_AX_J3(dfidqd_prev_mat_out_AX_J3),.dfidqd_prev_mat_out_AX_J4(dfidqd_prev_mat_out_AX_J4),.dfidqd_prev_mat_out_AX_J5(dfidqd_prev_mat_out_AX_J5),.dfidqd_prev_mat_out_AX_J6(dfidqd_prev_mat_out_AX_J6),.dfidqd_prev_mat_out_AX_J7(dfidqd_prev_mat_out_AX_J7),.dfidqd_prev_mat_out_AX_J8(dfidqd_prev_mat_out_AX_J8),
      .dfidqd_prev_mat_out_AY_J1(dfidqd_prev_mat_out_AY_J1),.dfidqd_prev_mat_out_AY_J2(dfidqd_prev_mat_out_AY_J2),.dfidqd_prev_mat_out_AY_J3(dfidqd_prev_mat_out_AY_J3),.dfidqd_prev_mat_out_AY_J4(dfidqd_prev_mat_out_AY_J4),.dfidqd_prev_mat_out_AY_J5(dfidqd_prev_mat_out_AY_J5),.dfidqd_prev_mat_out_AY_J6(dfidqd_prev_mat_out_AY_J6),.dfidqd_prev_mat_out_AY_J7(dfidqd_prev_mat_out_AY_J7),.dfidqd_prev_mat_out_AY_J8(dfidqd_prev_mat_out_AY_J8),
      .dfidqd_prev_mat_out_AZ_J1(dfidqd_prev_mat_out_AZ_J1),.dfidqd_prev_mat_out_AZ_J2(dfidqd_prev_mat_out_AZ_J2),.dfidqd_prev_mat_out_AZ_J3(dfidqd_prev_mat_out_AZ_J3),.dfidqd_prev_mat_out_AZ_J4(dfidqd_prev_mat_out_AZ_J4),.dfidqd_prev_mat_out_AZ_J5(dfidqd_prev_mat_out_AZ_J5),.dfidqd_prev_mat_out_AZ_J6(dfidqd_prev_mat_out_AZ_J6),.dfidqd_prev_mat_out_AZ_J7(dfidqd_prev_mat_out_AZ_J7),.dfidqd_prev_mat_out_AZ_J8(dfidqd_prev_mat_out_AZ_J8),
      .dfidqd_prev_mat_out_LX_J1(dfidqd_prev_mat_out_LX_J1),.dfidqd_prev_mat_out_LX_J2(dfidqd_prev_mat_out_LX_J2),.dfidqd_prev_mat_out_LX_J3(dfidqd_prev_mat_out_LX_J3),.dfidqd_prev_mat_out_LX_J4(dfidqd_prev_mat_out_LX_J4),.dfidqd_prev_mat_out_LX_J5(dfidqd_prev_mat_out_LX_J5),.dfidqd_prev_mat_out_LX_J6(dfidqd_prev_mat_out_LX_J6),.dfidqd_prev_mat_out_LX_J7(dfidqd_prev_mat_out_LX_J7),.dfidqd_prev_mat_out_LX_J8(dfidqd_prev_mat_out_LX_J8),
      .dfidqd_prev_mat_out_LY_J1(dfidqd_prev_mat_out_LY_J1),.dfidqd_prev_mat_out_LY_J2(dfidqd_prev_mat_out_LY_J2),.dfidqd_prev_mat_out_LY_J3(dfidqd_prev_mat_out_LY_J3),.dfidqd_prev_mat_out_LY_J4(dfidqd_prev_mat_out_LY_J4),.dfidqd_prev_mat_out_LY_J5(dfidqd_prev_mat_out_LY_J5),.dfidqd_prev_mat_out_LY_J6(dfidqd_prev_mat_out_LY_J6),.dfidqd_prev_mat_out_LY_J7(dfidqd_prev_mat_out_LY_J7),.dfidqd_prev_mat_out_LY_J8(dfidqd_prev_mat_out_LY_J8),
      .dfidqd_prev_mat_out_LZ_J1(dfidqd_prev_mat_out_LZ_J1),.dfidqd_prev_mat_out_LZ_J2(dfidqd_prev_mat_out_LZ_J2),.dfidqd_prev_mat_out_LZ_J3(dfidqd_prev_mat_out_LZ_J3),.dfidqd_prev_mat_out_LZ_J4(dfidqd_prev_mat_out_LZ_J4),.dfidqd_prev_mat_out_LZ_J5(dfidqd_prev_mat_out_LZ_J5),.dfidqd_prev_mat_out_LZ_J6(dfidqd_prev_mat_out_LZ_J6),.dfidqd_prev_mat_out_LZ_J7(dfidqd_prev_mat_out_LZ_J7),.dfidqd_prev_mat_out_LZ_J8(dfidqd_prev_mat_out_LZ_J8)
      );

   initial begin
      #10;
      // initialize
      clk = 0;
      // inputs
      sinq_curr_in = 0; cosq_curr_in = 0;
      qd_curr_in = 0;
      qdd_curr_in = 0;
      v_prev_vec_in_AX = 0; v_prev_vec_in_AY = 0; v_prev_vec_in_AZ = 0; v_prev_vec_in_LX = 0; v_prev_vec_in_LY = 0; v_prev_vec_in_LZ = 0;
      a_prev_vec_in_AX = 0; a_prev_vec_in_AY = 0; a_prev_vec_in_AZ = 0; a_prev_vec_in_LX = 0; a_prev_vec_in_LY = 0; a_prev_vec_in_LZ = 0;
      v_curr_vec_in_AX = 0; v_curr_vec_in_AY = 0; v_curr_vec_in_AZ = 0; v_curr_vec_in_LX = 0; v_curr_vec_in_LY = 0; v_curr_vec_in_LZ = 0;
      a_curr_vec_in_AX = 0; a_curr_vec_in_AY = 0; a_curr_vec_in_AZ = 0; a_curr_vec_in_LX = 0; a_curr_vec_in_LY = 0; a_curr_vec_in_LZ = 0;
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

//--------------------- PASTE JULIA OUTPUT -------------------------------

$display ("// Link 1 Test");
//------------------------------------------------------------------------
// Link 1 Inputs
sinq_curr_in = 32'd19197; cosq_curr_in = 32'd62661;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 2 Test");
//------------------------------------------------------------------------
// Link 2 Inputs
sinq_curr_in = 32'd24454; cosq_curr_in = 32'd60803;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 3 Test");
//------------------------------------------------------------------------
// Link 3 Inputs
sinq_curr_in = 32'd36876; cosq_curr_in = 32'd54177;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 4 Test");
//------------------------------------------------------------------------
// Link 4 Inputs
sinq_curr_in = 32'd685; cosq_curr_in = 32'd65532;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 5 Test");
//------------------------------------------------------------------------
// Link 5 Inputs
sinq_curr_in = 32'd48758; cosq_curr_in = 32'd43790;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 6 Test");
//------------------------------------------------------------------------
// Link 6 Inputs
sinq_curr_in = 32'd20062; cosq_curr_in = 32'd62390;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 7 Test");
//------------------------------------------------------------------------
// Link 7 Inputs
sinq_curr_in = 32'd49084; cosq_curr_in = 32'd43424;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 8 Test");
//------------------------------------------------------------------------
// Link 8 Inputs
sinq_curr_in = 32'd49084; cosq_curr_in = 32'd43424;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");

// DEAD CYCLES

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

/// KNOT 2

$display ("// Link 1 Test");
//------------------------------------------------------------------------
// Link 1 Inputs
sinq_curr_in = 32'd19197; cosq_curr_in = 32'd62661;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 2 Test");
//------------------------------------------------------------------------
// Link 2 Inputs
sinq_curr_in = 32'd24454; cosq_curr_in = 32'd60803;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 3 Test");
//------------------------------------------------------------------------
// Link 3 Inputs
sinq_curr_in = 32'd36876; cosq_curr_in = 32'd54177;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 4 Test");
//------------------------------------------------------------------------
// Link 4 Inputs
sinq_curr_in = 32'd685; cosq_curr_in = 32'd65532;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 5 Test");
//------------------------------------------------------------------------
// Link 5 Inputs
sinq_curr_in = 32'd48758; cosq_curr_in = 32'd43790;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 6 Test");
//------------------------------------------------------------------------
// Link 6 Inputs
sinq_curr_in = 32'd20062; cosq_curr_in = 32'd62390;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 7 Test");
//------------------------------------------------------------------------
// Link 7 Inputs
sinq_curr_in = 32'd49084; cosq_curr_in = 32'd43424;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
$display ("// Link 8 Test");
//------------------------------------------------------------------------
// Link 8 Inputs
sinq_curr_in = 32'd49084; cosq_curr_in = 32'd43424;
qd_curr_in = 32'd0;
v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd0; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd0; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
//------------------------------------------------------------------------
// Clock and Control Inputs
get_data = 1;
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
// Compare Outputs
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dq
$display ("dfidq_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("                     0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,dfidq_prev_mat_out_AX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,dfidq_prev_mat_out_AY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,dfidq_prev_mat_out_AZ_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,dfidq_prev_mat_out_LX_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,dfidq_prev_mat_out_LY_J8);
$display ("                     %d,%d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7,dfidq_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");
// df/dqd
$display ("dfidqd_prev_mat_ref = 0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("                      0,0,0,0,0,0,0,0");
$display ("\n");
$display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,dfidqd_prev_mat_out_AX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,dfidqd_prev_mat_out_AY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,dfidqd_prev_mat_out_AZ_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,dfidqd_prev_mat_out_LX_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,dfidqd_prev_mat_out_LY_J8);
$display ("                      %d,%d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7,dfidqd_prev_mat_out_LZ_J8);
$display ("//-------------------------------------------------------------------------------------------------------");

//------------------------------------------------------------------------

      // Clock and Control Inputs
      get_data = 1;
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
      // Insert extra delay cycles
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
