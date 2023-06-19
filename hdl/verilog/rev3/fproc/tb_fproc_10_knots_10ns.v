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
      dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7,
      dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7,
      dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7,
      dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7,
      dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7,
      dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7;
   // dfidqd_prev_mat_out
   wire signed[(WIDTH-1):0]
      dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7,
      dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7,
      dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7,
      dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7,
      dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7,
      dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7;

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
      .dfidq_prev_mat_out_AX_J1(dfidq_prev_mat_out_AX_J1),.dfidq_prev_mat_out_AX_J2(dfidq_prev_mat_out_AX_J2),.dfidq_prev_mat_out_AX_J3(dfidq_prev_mat_out_AX_J3),.dfidq_prev_mat_out_AX_J4(dfidq_prev_mat_out_AX_J4),.dfidq_prev_mat_out_AX_J5(dfidq_prev_mat_out_AX_J5),.dfidq_prev_mat_out_AX_J6(dfidq_prev_mat_out_AX_J6),.dfidq_prev_mat_out_AX_J7(dfidq_prev_mat_out_AX_J7),
      .dfidq_prev_mat_out_AY_J1(dfidq_prev_mat_out_AY_J1),.dfidq_prev_mat_out_AY_J2(dfidq_prev_mat_out_AY_J2),.dfidq_prev_mat_out_AY_J3(dfidq_prev_mat_out_AY_J3),.dfidq_prev_mat_out_AY_J4(dfidq_prev_mat_out_AY_J4),.dfidq_prev_mat_out_AY_J5(dfidq_prev_mat_out_AY_J5),.dfidq_prev_mat_out_AY_J6(dfidq_prev_mat_out_AY_J6),.dfidq_prev_mat_out_AY_J7(dfidq_prev_mat_out_AY_J7),
      .dfidq_prev_mat_out_AZ_J1(dfidq_prev_mat_out_AZ_J1),.dfidq_prev_mat_out_AZ_J2(dfidq_prev_mat_out_AZ_J2),.dfidq_prev_mat_out_AZ_J3(dfidq_prev_mat_out_AZ_J3),.dfidq_prev_mat_out_AZ_J4(dfidq_prev_mat_out_AZ_J4),.dfidq_prev_mat_out_AZ_J5(dfidq_prev_mat_out_AZ_J5),.dfidq_prev_mat_out_AZ_J6(dfidq_prev_mat_out_AZ_J6),.dfidq_prev_mat_out_AZ_J7(dfidq_prev_mat_out_AZ_J7),
      .dfidq_prev_mat_out_LX_J1(dfidq_prev_mat_out_LX_J1),.dfidq_prev_mat_out_LX_J2(dfidq_prev_mat_out_LX_J2),.dfidq_prev_mat_out_LX_J3(dfidq_prev_mat_out_LX_J3),.dfidq_prev_mat_out_LX_J4(dfidq_prev_mat_out_LX_J4),.dfidq_prev_mat_out_LX_J5(dfidq_prev_mat_out_LX_J5),.dfidq_prev_mat_out_LX_J6(dfidq_prev_mat_out_LX_J6),.dfidq_prev_mat_out_LX_J7(dfidq_prev_mat_out_LX_J7),
      .dfidq_prev_mat_out_LY_J1(dfidq_prev_mat_out_LY_J1),.dfidq_prev_mat_out_LY_J2(dfidq_prev_mat_out_LY_J2),.dfidq_prev_mat_out_LY_J3(dfidq_prev_mat_out_LY_J3),.dfidq_prev_mat_out_LY_J4(dfidq_prev_mat_out_LY_J4),.dfidq_prev_mat_out_LY_J5(dfidq_prev_mat_out_LY_J5),.dfidq_prev_mat_out_LY_J6(dfidq_prev_mat_out_LY_J6),.dfidq_prev_mat_out_LY_J7(dfidq_prev_mat_out_LY_J7),
      .dfidq_prev_mat_out_LZ_J1(dfidq_prev_mat_out_LZ_J1),.dfidq_prev_mat_out_LZ_J2(dfidq_prev_mat_out_LZ_J2),.dfidq_prev_mat_out_LZ_J3(dfidq_prev_mat_out_LZ_J3),.dfidq_prev_mat_out_LZ_J4(dfidq_prev_mat_out_LZ_J4),.dfidq_prev_mat_out_LZ_J5(dfidq_prev_mat_out_LZ_J5),.dfidq_prev_mat_out_LZ_J6(dfidq_prev_mat_out_LZ_J6),.dfidq_prev_mat_out_LZ_J7(dfidq_prev_mat_out_LZ_J7),
      // dfidqd_prev_mat_out
      .dfidqd_prev_mat_out_AX_J1(dfidqd_prev_mat_out_AX_J1),.dfidqd_prev_mat_out_AX_J2(dfidqd_prev_mat_out_AX_J2),.dfidqd_prev_mat_out_AX_J3(dfidqd_prev_mat_out_AX_J3),.dfidqd_prev_mat_out_AX_J4(dfidqd_prev_mat_out_AX_J4),.dfidqd_prev_mat_out_AX_J5(dfidqd_prev_mat_out_AX_J5),.dfidqd_prev_mat_out_AX_J6(dfidqd_prev_mat_out_AX_J6),.dfidqd_prev_mat_out_AX_J7(dfidqd_prev_mat_out_AX_J7),
      .dfidqd_prev_mat_out_AY_J1(dfidqd_prev_mat_out_AY_J1),.dfidqd_prev_mat_out_AY_J2(dfidqd_prev_mat_out_AY_J2),.dfidqd_prev_mat_out_AY_J3(dfidqd_prev_mat_out_AY_J3),.dfidqd_prev_mat_out_AY_J4(dfidqd_prev_mat_out_AY_J4),.dfidqd_prev_mat_out_AY_J5(dfidqd_prev_mat_out_AY_J5),.dfidqd_prev_mat_out_AY_J6(dfidqd_prev_mat_out_AY_J6),.dfidqd_prev_mat_out_AY_J7(dfidqd_prev_mat_out_AY_J7),
      .dfidqd_prev_mat_out_AZ_J1(dfidqd_prev_mat_out_AZ_J1),.dfidqd_prev_mat_out_AZ_J2(dfidqd_prev_mat_out_AZ_J2),.dfidqd_prev_mat_out_AZ_J3(dfidqd_prev_mat_out_AZ_J3),.dfidqd_prev_mat_out_AZ_J4(dfidqd_prev_mat_out_AZ_J4),.dfidqd_prev_mat_out_AZ_J5(dfidqd_prev_mat_out_AZ_J5),.dfidqd_prev_mat_out_AZ_J6(dfidqd_prev_mat_out_AZ_J6),.dfidqd_prev_mat_out_AZ_J7(dfidqd_prev_mat_out_AZ_J7),
      .dfidqd_prev_mat_out_LX_J1(dfidqd_prev_mat_out_LX_J1),.dfidqd_prev_mat_out_LX_J2(dfidqd_prev_mat_out_LX_J2),.dfidqd_prev_mat_out_LX_J3(dfidqd_prev_mat_out_LX_J3),.dfidqd_prev_mat_out_LX_J4(dfidqd_prev_mat_out_LX_J4),.dfidqd_prev_mat_out_LX_J5(dfidqd_prev_mat_out_LX_J5),.dfidqd_prev_mat_out_LX_J6(dfidqd_prev_mat_out_LX_J6),.dfidqd_prev_mat_out_LX_J7(dfidqd_prev_mat_out_LX_J7),
      .dfidqd_prev_mat_out_LY_J1(dfidqd_prev_mat_out_LY_J1),.dfidqd_prev_mat_out_LY_J2(dfidqd_prev_mat_out_LY_J2),.dfidqd_prev_mat_out_LY_J3(dfidqd_prev_mat_out_LY_J3),.dfidqd_prev_mat_out_LY_J4(dfidqd_prev_mat_out_LY_J4),.dfidqd_prev_mat_out_LY_J5(dfidqd_prev_mat_out_LY_J5),.dfidqd_prev_mat_out_LY_J6(dfidqd_prev_mat_out_LY_J6),.dfidqd_prev_mat_out_LY_J7(dfidqd_prev_mat_out_LY_J7),
      .dfidqd_prev_mat_out_LZ_J1(dfidqd_prev_mat_out_LZ_J1),.dfidqd_prev_mat_out_LZ_J2(dfidqd_prev_mat_out_LZ_J2),.dfidqd_prev_mat_out_LZ_J3(dfidqd_prev_mat_out_LZ_J3),.dfidqd_prev_mat_out_LZ_J4(dfidqd_prev_mat_out_LZ_J4),.dfidqd_prev_mat_out_LZ_J5(dfidqd_prev_mat_out_LZ_J5),.dfidqd_prev_mat_out_LZ_J6(dfidqd_prev_mat_out_LZ_J6),.dfidqd_prev_mat_out_LZ_J7(dfidqd_prev_mat_out_LZ_J7)
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
      //------------------------------------------------------------------------
      $display ("// Knot 1 Link 1 Init");
      //------------------------------------------------------------------------
      // Link 1 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd19197; cosq_curr_in = 32'd62661;
      qd_curr_in = 32'd65530;
      qdd_curr_in = 32'd43998;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd0; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd0; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd65530; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd43998; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
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
      // (Ignore Dummy Outputs)
      //------------------------------------------------------------------------
      // Link 2 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd24454; cosq_curr_in = 32'd60803;
      qd_curr_in = 32'd16493;
      qdd_curr_in = 32'd136669;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd65530; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd43998; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd24452; v_curr_vec_in_AY = 32'd60797; v_curr_vec_in_AZ = 32'd16493; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd31718; a_curr_vec_in_AY = 32'd34667; a_curr_vec_in_AZ = 32'd136669; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
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
      // Link 1 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 1 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-944, 634, 1038, 5280, 7863, 0);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -1887, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 15727, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 3 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd36876; cosq_curr_in = 32'd54177;
      qd_curr_in = 32'd64662;
      qdd_curr_in = -32'd60321;
      v_prev_vec_in_AX = 32'd24452; v_prev_vec_in_AY = 32'd60797; v_prev_vec_in_AZ = 32'd16493; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd31718; a_prev_vec_in_AY = 32'd34667; a_prev_vec_in_AZ = 32'd136669; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd29494; v_curr_vec_in_AY = -32'd125; v_curr_vec_in_AZ = 32'd125459; v_curr_vec_in_LX = -32'd26; v_curr_vec_in_LY = 32'd6032; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = -32'd103245; a_curr_vec_in_AY = 32'd124234; a_curr_vec_in_AZ = -32'd25654; a_curr_vec_in_LX = 32'd25406; a_curr_vec_in_LY = 32'd21114; a_curr_vec_in_LZ = 32'd0;
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
      // Link 2 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 2 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2226, -184, 6473, -20115, -5700, 54);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 2709, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -126, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2017, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 8454, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -17508, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 6786, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 469, 6644, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 375, -304, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2077, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 10572, -40, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -4252, -7785, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -14781, 28755, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 4 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd685; cosq_curr_in = 32'd65532;
      qd_curr_in = 32'd36422;
      qdd_curr_in = 32'd358153;
      v_prev_vec_in_AX = -32'd29494; v_prev_vec_in_AY = -32'd125; v_prev_vec_in_AZ = 32'd125459; v_prev_vec_in_LX = -32'd25; v_prev_vec_in_LY = 32'd6032; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = -32'd103246; a_prev_vec_in_AY = 32'd124234; a_prev_vec_in_AZ = -32'd25654; a_prev_vec_in_LX = 32'd25406; a_prev_vec_in_LY = 32'd21114; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd30803; v_curr_vec_in_AY = 32'd125144; v_curr_vec_in_AZ = 32'd36546; v_curr_vec_in_LX = -32'd52; v_curr_vec_in_LY = -32'd1; v_curr_vec_in_LZ = -32'd12388;
      a_curr_vec_in_AX = -32'd33423; a_curr_vec_in_AY = -32'd9612; a_curr_vec_in_AZ = 32'd233920; a_curr_vec_in_LX = 32'd52175; a_curr_vec_in_LY = 32'd574; a_curr_vec_in_LZ = -32'd43363;
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
      // Link 3 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 3 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-19396, 14507, -2367, 70323, 80557, -22634);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2621, 15599, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -10348, 21009, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1137, -2999, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -51071, 102173, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1313, -68019, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -57033, 16263, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1897, -19915, 2933, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10769, -13702, 147, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1521, 1936, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53805, -68646, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22821, 97882, -22583, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -23054, -23480, -22, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 5 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd48758; cosq_curr_in = 32'd43790;
      qd_curr_in = 32'd28646;
      qdd_curr_in = 32'd1694532;
      v_prev_vec_in_AX = -32'd30803; v_prev_vec_in_AY = 32'd125144; v_prev_vec_in_AZ = 32'd36546; v_prev_vec_in_LX = -32'd52; v_prev_vec_in_LY = -32'd1; v_prev_vec_in_LZ = -32'd12388;
      a_prev_vec_in_AX = -32'd33423; a_prev_vec_in_AY = -32'd9612; a_prev_vec_in_AZ = 32'd233919; a_prev_vec_in_LX = 32'd52175; a_prev_vec_in_LY = 32'd574; a_prev_vec_in_LZ = -32'd43363;
      v_curr_vec_in_AX = -32'd6608; v_curr_vec_in_AY = 32'd47337; v_curr_vec_in_AZ = 32'd153790; v_curr_vec_in_LX = 32'd17985; v_curr_vec_in_LY = -32'd7019; v_curr_vec_in_LZ = -32'd1;
      a_curr_vec_in_AX = -32'd131010; a_curr_vec_in_AY = 32'd184057; a_curr_vec_in_AZ = 32'd1684917; a_curr_vec_in_LX = 32'd27757; a_curr_vec_in_LY = -32'd47665; a_curr_vec_in_LZ = 32'd574;
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
      // Link 4 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 4 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-8244, 621, 6514, 21590, -11080, -133498);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 826, 8949, 1941, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2678, 4680, 1622, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 5904, -12157, -6891, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -76136, 136829, 35836, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -55811, -9425, -53266, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 3436, 89127, 1368, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1436, -9457, 1126, 9615, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2460, -3074, -13, 277, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5950, 7332, -181, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -73332, -89415, -473, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22838, -43368, -94, -13222, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10554, -135202, -9858, 45277, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 6 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd20062; cosq_curr_in = 32'd62390;
      qd_curr_in = 32'd27834;
      qdd_curr_in = 32'd6910717;
      v_prev_vec_in_AX = -32'd6608; v_prev_vec_in_AY = 32'd47337; v_prev_vec_in_AZ = 32'd153790; v_prev_vec_in_LX = 32'd17985; v_prev_vec_in_LY = -32'd7019; v_prev_vec_in_LZ = -32'd1;
      a_prev_vec_in_AX = -32'd131010; a_prev_vec_in_AY = 32'd184057; a_prev_vec_in_AZ = 32'd1684920; a_prev_vec_in_LX = 32'd27757; a_prev_vec_in_LY = -32'd47665; a_prev_vec_in_LZ = 32'd574;
      v_curr_vec_in_AX = 32'd40787; v_curr_vec_in_AY = 32'd148431; v_curr_vec_in_AZ = -32'd19503; v_curr_vec_in_LX = 32'd26833; v_curr_vec_in_LY = -32'd8629; v_curr_vec_in_LZ = 32'd5595;
      a_curr_vec_in_AX = 32'd454102; a_curr_vec_in_AY = 32'd1626813; a_curr_vec_in_AZ = 32'd6726681; a_curr_vec_in_LX = 32'd60695; a_curr_vec_in_LY = -32'd31488; a_curr_vec_in_LZ = 32'd19432;
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
      // Link 5 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 5 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-5305, 5863, 7667, 36575, 9374, -25154);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -4354, 3320, 7150, 10972, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 4610, -12747, -7214, 5786, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -1038, 2853, 1647, -564, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 48590, -137401, -65942, 23191, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 45129, -36066, -70817, -96617, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -62580, 13151, -4659, 7121, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -5945, 1309, -1513, -8879, 1237, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1314, 12420, -2697, -9465, 16, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -394, -3077, 491, 2025, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 20251, 140949, -23281, -84990, -52, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 57716, -18551, 11438, 73710, -10981, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -24770, -13522, 1380, -31010, 3378, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 7 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd49084; cosq_curr_in = -32'd43424;
      qd_curr_in = 32'd50674;
      qdd_curr_in = 32'd3416239;
      v_prev_vec_in_AX = 32'd40787; v_prev_vec_in_AY = 32'd148430; v_prev_vec_in_AZ = -32'd19503; v_prev_vec_in_LX = 32'd26833; v_prev_vec_in_LY = -32'd8629; v_prev_vec_in_LZ = 32'd5595;
      a_prev_vec_in_AX = 32'd454103; a_prev_vec_in_AY = 32'd1626815; a_prev_vec_in_AZ = 32'd6726660; a_prev_vec_in_LX = 32'd60695; a_prev_vec_in_LY = -32'd31489; a_prev_vec_in_LZ = 32'd19432;
      v_curr_vec_in_AX = 32'd12419; v_curr_vec_in_AY = 32'd43471; v_curr_vec_in_AZ = 32'd199104; v_curr_vec_in_LX = 32'd25491; v_curr_vec_in_LY = 32'd15384; v_curr_vec_in_LZ = -32'd8629;
      a_curr_vec_in_AX = 32'd5372563; a_curr_vec_in_AY = -32'd4126612; a_curr_vec_in_AZ = 32'd5043054; a_curr_vec_in_LX = -32'd266811; a_curr_vec_in_LY = -32'd419582; a_curr_vec_in_LZ = -32'd31488;
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
      // Link 6 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 6 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2203, 5901, 31413, 121437, -77713, -83897);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 284, -35, 259, 931, 8200, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -123, -73, 247, -245, -1679, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -151, 839, 24, -794, -389, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 32323, -160291, -90398, 80218, -77343, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -111482, 77173, 64413, -25932, -128801, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -49161, 46245, 109642, 145168, 1770, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 76, -2, 75, -411, 337, 906, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -36, -40, -44, 186, -85, -135, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53, -127, 123, 558, -149, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5723, 166896, -36059, -143888, 77, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -43324, -60969, 11058, -9066, -92, 42, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -94050, 24373, -36659, -120581, -164, 321, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Dummy Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 0; cosq_curr_in = 0;
      qd_curr_in = 0;
      qdd_curr_in = 0;
      v_prev_vec_in_AX = 32'd12419; v_prev_vec_in_AY = 32'd43471; v_prev_vec_in_AZ = 32'd199104; v_prev_vec_in_LX = 32'd25491; v_prev_vec_in_LY = 32'd15384; v_prev_vec_in_LZ = -32'd8629;
      a_prev_vec_in_AX = 32'd5372563; a_prev_vec_in_AY = -32'd4126612; a_prev_vec_in_AZ = 32'd5043054; a_prev_vec_in_LX = -32'd266811; a_prev_vec_in_LY = -32'd419582; a_prev_vec_in_LZ = -32'd31488;
      v_curr_vec_in_AX = 0; v_curr_vec_in_AY = 0; v_curr_vec_in_AZ = 0; v_curr_vec_in_LX = 0; v_curr_vec_in_LY = 0; v_curr_vec_in_LZ = 0;
      a_curr_vec_in_AX = 0; a_curr_vec_in_AY = 0; a_curr_vec_in_AZ = 0; a_curr_vec_in_LX = 0; a_curr_vec_in_LY = 0; a_curr_vec_in_LZ = 0;
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
      // Link 7 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 7 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",8044, -6533, 5043, -120315, -133594, -13832);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -155, 691, 463, 126, 1874, -6533);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 52, -424, 142, 895, 1840, -8044);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -3285, -13804, 6498, 35032, 34895, -133594);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 10772, -28595, -29148, -4116, -35504, 120315);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -19629, 12420, 15012, -6108, -26838, -0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -204, -355, 58, 128, 34, 184, 43);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -186, 404, -176, -786, 108, 208, -12);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10435, 23638, -7656, -37658, 3027, 6737, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 13340, 20050, 289, -5454, 998, -5960, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -8477, -12323, 1071, -549, -757, 1182, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
      //------------------------------------------------------------------------
      $display ("// Knot 2 Link 1 Init");
      //------------------------------------------------------------------------
      // Link 1 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd19197; cosq_curr_in = 32'd62661;
      qd_curr_in = 32'd65530;
      qdd_curr_in = 32'd43998;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd0; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd0; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd65530; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd43998; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
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
      // (Ignore Dummy Outputs)
      //------------------------------------------------------------------------
      // Link 2 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd24454; cosq_curr_in = 32'd60803;
      qd_curr_in = 32'd16493;
      qdd_curr_in = 32'd136669;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd65530; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd43998; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd24452; v_curr_vec_in_AY = 32'd60797; v_curr_vec_in_AZ = 32'd16493; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd31718; a_curr_vec_in_AY = 32'd34667; a_curr_vec_in_AZ = 32'd136669; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
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
      // Link 1 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 1 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-944, 634, 1038, 5280, 7863, 0);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -1887, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 15727, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 3 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd36876; cosq_curr_in = 32'd54177;
      qd_curr_in = 32'd64662;
      qdd_curr_in = -32'd60321;
      v_prev_vec_in_AX = 32'd24452; v_prev_vec_in_AY = 32'd60797; v_prev_vec_in_AZ = 32'd16493; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd31718; a_prev_vec_in_AY = 32'd34667; a_prev_vec_in_AZ = 32'd136669; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd29494; v_curr_vec_in_AY = -32'd125; v_curr_vec_in_AZ = 32'd125459; v_curr_vec_in_LX = -32'd26; v_curr_vec_in_LY = 32'd6032; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = -32'd103245; a_curr_vec_in_AY = 32'd124234; a_curr_vec_in_AZ = -32'd25654; a_curr_vec_in_LX = 32'd25406; a_curr_vec_in_LY = 32'd21114; a_curr_vec_in_LZ = 32'd0;
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
      // Link 2 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 2 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2226, -184, 6473, -20115, -5700, 54);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 2709, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -126, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2017, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 8454, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -17508, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 6786, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 469, 6644, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 375, -304, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2077, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 10572, -40, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -4252, -7785, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -14781, 28755, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 4 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd685; cosq_curr_in = 32'd65532;
      qd_curr_in = 32'd36422;
      qdd_curr_in = 32'd358153;
      v_prev_vec_in_AX = -32'd29494; v_prev_vec_in_AY = -32'd125; v_prev_vec_in_AZ = 32'd125459; v_prev_vec_in_LX = -32'd25; v_prev_vec_in_LY = 32'd6032; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = -32'd103246; a_prev_vec_in_AY = 32'd124234; a_prev_vec_in_AZ = -32'd25654; a_prev_vec_in_LX = 32'd25406; a_prev_vec_in_LY = 32'd21114; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd30803; v_curr_vec_in_AY = 32'd125144; v_curr_vec_in_AZ = 32'd36546; v_curr_vec_in_LX = -32'd52; v_curr_vec_in_LY = -32'd1; v_curr_vec_in_LZ = -32'd12388;
      a_curr_vec_in_AX = -32'd33423; a_curr_vec_in_AY = -32'd9612; a_curr_vec_in_AZ = 32'd233920; a_curr_vec_in_LX = 32'd52175; a_curr_vec_in_LY = 32'd574; a_curr_vec_in_LZ = -32'd43363;
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
      // Link 3 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 3 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-19396, 14507, -2367, 70323, 80557, -22634);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2621, 15599, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -10348, 21009, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1137, -2999, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -51071, 102173, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1313, -68019, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -57033, 16263, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1897, -19915, 2933, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10769, -13702, 147, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1521, 1936, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53805, -68646, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22821, 97882, -22583, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -23054, -23480, -22, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 5 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd48758; cosq_curr_in = 32'd43790;
      qd_curr_in = 32'd28646;
      qdd_curr_in = 32'd1694532;
      v_prev_vec_in_AX = -32'd30803; v_prev_vec_in_AY = 32'd125144; v_prev_vec_in_AZ = 32'd36546; v_prev_vec_in_LX = -32'd52; v_prev_vec_in_LY = -32'd1; v_prev_vec_in_LZ = -32'd12388;
      a_prev_vec_in_AX = -32'd33423; a_prev_vec_in_AY = -32'd9612; a_prev_vec_in_AZ = 32'd233919; a_prev_vec_in_LX = 32'd52175; a_prev_vec_in_LY = 32'd574; a_prev_vec_in_LZ = -32'd43363;
      v_curr_vec_in_AX = -32'd6608; v_curr_vec_in_AY = 32'd47337; v_curr_vec_in_AZ = 32'd153790; v_curr_vec_in_LX = 32'd17985; v_curr_vec_in_LY = -32'd7019; v_curr_vec_in_LZ = -32'd1;
      a_curr_vec_in_AX = -32'd131010; a_curr_vec_in_AY = 32'd184057; a_curr_vec_in_AZ = 32'd1684917; a_curr_vec_in_LX = 32'd27757; a_curr_vec_in_LY = -32'd47665; a_curr_vec_in_LZ = 32'd574;
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
      // Link 4 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 4 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-8244, 621, 6514, 21590, -11080, -133498);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 826, 8949, 1941, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2678, 4680, 1622, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 5904, -12157, -6891, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -76136, 136829, 35836, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -55811, -9425, -53266, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 3436, 89127, 1368, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1436, -9457, 1126, 9615, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2460, -3074, -13, 277, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5950, 7332, -181, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -73332, -89415, -473, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22838, -43368, -94, -13222, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10554, -135202, -9858, 45277, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 6 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd20062; cosq_curr_in = 32'd62390;
      qd_curr_in = 32'd27834;
      qdd_curr_in = 32'd6910717;
      v_prev_vec_in_AX = -32'd6608; v_prev_vec_in_AY = 32'd47337; v_prev_vec_in_AZ = 32'd153790; v_prev_vec_in_LX = 32'd17985; v_prev_vec_in_LY = -32'd7019; v_prev_vec_in_LZ = -32'd1;
      a_prev_vec_in_AX = -32'd131010; a_prev_vec_in_AY = 32'd184057; a_prev_vec_in_AZ = 32'd1684920; a_prev_vec_in_LX = 32'd27757; a_prev_vec_in_LY = -32'd47665; a_prev_vec_in_LZ = 32'd574;
      v_curr_vec_in_AX = 32'd40787; v_curr_vec_in_AY = 32'd148431; v_curr_vec_in_AZ = -32'd19503; v_curr_vec_in_LX = 32'd26833; v_curr_vec_in_LY = -32'd8629; v_curr_vec_in_LZ = 32'd5595;
      a_curr_vec_in_AX = 32'd454102; a_curr_vec_in_AY = 32'd1626813; a_curr_vec_in_AZ = 32'd6726681; a_curr_vec_in_LX = 32'd60695; a_curr_vec_in_LY = -32'd31488; a_curr_vec_in_LZ = 32'd19432;
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
      // Link 5 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 5 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-5305, 5863, 7667, 36575, 9374, -25154);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -4354, 3320, 7150, 10972, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 4610, -12747, -7214, 5786, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -1038, 2853, 1647, -564, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 48590, -137401, -65942, 23191, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 45129, -36066, -70817, -96617, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -62580, 13151, -4659, 7121, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -5945, 1309, -1513, -8879, 1237, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1314, 12420, -2697, -9465, 16, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -394, -3077, 491, 2025, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 20251, 140949, -23281, -84990, -52, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 57716, -18551, 11438, 73710, -10981, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -24770, -13522, 1380, -31010, 3378, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 7 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd49084; cosq_curr_in = -32'd43424;
      qd_curr_in = 32'd50674;
      qdd_curr_in = 32'd3416239;
      v_prev_vec_in_AX = 32'd40787; v_prev_vec_in_AY = 32'd148430; v_prev_vec_in_AZ = -32'd19503; v_prev_vec_in_LX = 32'd26833; v_prev_vec_in_LY = -32'd8629; v_prev_vec_in_LZ = 32'd5595;
      a_prev_vec_in_AX = 32'd454103; a_prev_vec_in_AY = 32'd1626815; a_prev_vec_in_AZ = 32'd6726660; a_prev_vec_in_LX = 32'd60695; a_prev_vec_in_LY = -32'd31489; a_prev_vec_in_LZ = 32'd19432;
      v_curr_vec_in_AX = 32'd12419; v_curr_vec_in_AY = 32'd43471; v_curr_vec_in_AZ = 32'd199104; v_curr_vec_in_LX = 32'd25491; v_curr_vec_in_LY = 32'd15384; v_curr_vec_in_LZ = -32'd8629;
      a_curr_vec_in_AX = 32'd5372563; a_curr_vec_in_AY = -32'd4126612; a_curr_vec_in_AZ = 32'd5043054; a_curr_vec_in_LX = -32'd266811; a_curr_vec_in_LY = -32'd419582; a_curr_vec_in_LZ = -32'd31488;
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
      // Link 6 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 6 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2203, 5901, 31413, 121437, -77713, -83897);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 284, -35, 259, 931, 8200, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -123, -73, 247, -245, -1679, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -151, 839, 24, -794, -389, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 32323, -160291, -90398, 80218, -77343, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -111482, 77173, 64413, -25932, -128801, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -49161, 46245, 109642, 145168, 1770, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 76, -2, 75, -411, 337, 906, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -36, -40, -44, 186, -85, -135, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53, -127, 123, 558, -149, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5723, 166896, -36059, -143888, 77, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -43324, -60969, 11058, -9066, -92, 42, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -94050, 24373, -36659, -120581, -164, 321, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Dummy Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 0; cosq_curr_in = 0;
      qd_curr_in = 0;
      qdd_curr_in = 0;
      v_prev_vec_in_AX = 32'd12419; v_prev_vec_in_AY = 32'd43471; v_prev_vec_in_AZ = 32'd199104; v_prev_vec_in_LX = 32'd25491; v_prev_vec_in_LY = 32'd15384; v_prev_vec_in_LZ = -32'd8629;
      a_prev_vec_in_AX = 32'd5372563; a_prev_vec_in_AY = -32'd4126612; a_prev_vec_in_AZ = 32'd5043054; a_prev_vec_in_LX = -32'd266811; a_prev_vec_in_LY = -32'd419582; a_prev_vec_in_LZ = -32'd31488;
      v_curr_vec_in_AX = 0; v_curr_vec_in_AY = 0; v_curr_vec_in_AZ = 0; v_curr_vec_in_LX = 0; v_curr_vec_in_LY = 0; v_curr_vec_in_LZ = 0;
      a_curr_vec_in_AX = 0; a_curr_vec_in_AY = 0; a_curr_vec_in_AZ = 0; a_curr_vec_in_LX = 0; a_curr_vec_in_LY = 0; a_curr_vec_in_LZ = 0;
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
      // Link 7 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 7 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",8044, -6533, 5043, -120315, -133594, -13832);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -155, 691, 463, 126, 1874, -6533);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 52, -424, 142, 895, 1840, -8044);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -3285, -13804, 6498, 35032, 34895, -133594);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 10772, -28595, -29148, -4116, -35504, 120315);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -19629, 12420, 15012, -6108, -26838, -0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -204, -355, 58, 128, 34, 184, 43);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -186, 404, -176, -786, 108, 208, -12);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10435, 23638, -7656, -37658, 3027, 6737, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 13340, 20050, 289, -5454, 998, -5960, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -8477, -12323, 1071, -549, -757, 1182, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
      //------------------------------------------------------------------------
      $display ("// Knot 3 Link 1 Init");
      //------------------------------------------------------------------------
      // Link 1 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd19197; cosq_curr_in = 32'd62661;
      qd_curr_in = 32'd65530;
      qdd_curr_in = 32'd43998;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd0; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd0; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd65530; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd43998; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
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
      // (Ignore Dummy Outputs)
      //------------------------------------------------------------------------
      // Link 2 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd24454; cosq_curr_in = 32'd60803;
      qd_curr_in = 32'd16493;
      qdd_curr_in = 32'd136669;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd65530; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd43998; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd24452; v_curr_vec_in_AY = 32'd60797; v_curr_vec_in_AZ = 32'd16493; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd31718; a_curr_vec_in_AY = 32'd34667; a_curr_vec_in_AZ = 32'd136669; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
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
      // Link 1 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 1 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-944, 634, 1038, 5280, 7863, 0);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -1887, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 15727, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 3 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd36876; cosq_curr_in = 32'd54177;
      qd_curr_in = 32'd64662;
      qdd_curr_in = -32'd60321;
      v_prev_vec_in_AX = 32'd24452; v_prev_vec_in_AY = 32'd60797; v_prev_vec_in_AZ = 32'd16493; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd31718; a_prev_vec_in_AY = 32'd34667; a_prev_vec_in_AZ = 32'd136669; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd29494; v_curr_vec_in_AY = -32'd125; v_curr_vec_in_AZ = 32'd125459; v_curr_vec_in_LX = -32'd26; v_curr_vec_in_LY = 32'd6032; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = -32'd103245; a_curr_vec_in_AY = 32'd124234; a_curr_vec_in_AZ = -32'd25654; a_curr_vec_in_LX = 32'd25406; a_curr_vec_in_LY = 32'd21114; a_curr_vec_in_LZ = 32'd0;
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
      // Link 2 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 2 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2226, -184, 6473, -20115, -5700, 54);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 2709, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -126, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2017, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 8454, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -17508, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 6786, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 469, 6644, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 375, -304, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2077, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 10572, -40, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -4252, -7785, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -14781, 28755, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 4 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd685; cosq_curr_in = 32'd65532;
      qd_curr_in = 32'd36422;
      qdd_curr_in = 32'd358153;
      v_prev_vec_in_AX = -32'd29494; v_prev_vec_in_AY = -32'd125; v_prev_vec_in_AZ = 32'd125459; v_prev_vec_in_LX = -32'd25; v_prev_vec_in_LY = 32'd6032; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = -32'd103246; a_prev_vec_in_AY = 32'd124234; a_prev_vec_in_AZ = -32'd25654; a_prev_vec_in_LX = 32'd25406; a_prev_vec_in_LY = 32'd21114; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd30803; v_curr_vec_in_AY = 32'd125144; v_curr_vec_in_AZ = 32'd36546; v_curr_vec_in_LX = -32'd52; v_curr_vec_in_LY = -32'd1; v_curr_vec_in_LZ = -32'd12388;
      a_curr_vec_in_AX = -32'd33423; a_curr_vec_in_AY = -32'd9612; a_curr_vec_in_AZ = 32'd233920; a_curr_vec_in_LX = 32'd52175; a_curr_vec_in_LY = 32'd574; a_curr_vec_in_LZ = -32'd43363;
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
      // Link 3 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 3 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-19396, 14507, -2367, 70323, 80557, -22634);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2621, 15599, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -10348, 21009, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1137, -2999, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -51071, 102173, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1313, -68019, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -57033, 16263, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1897, -19915, 2933, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10769, -13702, 147, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1521, 1936, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53805, -68646, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22821, 97882, -22583, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -23054, -23480, -22, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 5 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd48758; cosq_curr_in = 32'd43790;
      qd_curr_in = 32'd28646;
      qdd_curr_in = 32'd1694532;
      v_prev_vec_in_AX = -32'd30803; v_prev_vec_in_AY = 32'd125144; v_prev_vec_in_AZ = 32'd36546; v_prev_vec_in_LX = -32'd52; v_prev_vec_in_LY = -32'd1; v_prev_vec_in_LZ = -32'd12388;
      a_prev_vec_in_AX = -32'd33423; a_prev_vec_in_AY = -32'd9612; a_prev_vec_in_AZ = 32'd233919; a_prev_vec_in_LX = 32'd52175; a_prev_vec_in_LY = 32'd574; a_prev_vec_in_LZ = -32'd43363;
      v_curr_vec_in_AX = -32'd6608; v_curr_vec_in_AY = 32'd47337; v_curr_vec_in_AZ = 32'd153790; v_curr_vec_in_LX = 32'd17985; v_curr_vec_in_LY = -32'd7019; v_curr_vec_in_LZ = -32'd1;
      a_curr_vec_in_AX = -32'd131010; a_curr_vec_in_AY = 32'd184057; a_curr_vec_in_AZ = 32'd1684917; a_curr_vec_in_LX = 32'd27757; a_curr_vec_in_LY = -32'd47665; a_curr_vec_in_LZ = 32'd574;
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
      // Link 4 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 4 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-8244, 621, 6514, 21590, -11080, -133498);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 826, 8949, 1941, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2678, 4680, 1622, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 5904, -12157, -6891, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -76136, 136829, 35836, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -55811, -9425, -53266, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 3436, 89127, 1368, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1436, -9457, 1126, 9615, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2460, -3074, -13, 277, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5950, 7332, -181, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -73332, -89415, -473, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22838, -43368, -94, -13222, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10554, -135202, -9858, 45277, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 6 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd20062; cosq_curr_in = 32'd62390;
      qd_curr_in = 32'd27834;
      qdd_curr_in = 32'd6910717;
      v_prev_vec_in_AX = -32'd6608; v_prev_vec_in_AY = 32'd47337; v_prev_vec_in_AZ = 32'd153790; v_prev_vec_in_LX = 32'd17985; v_prev_vec_in_LY = -32'd7019; v_prev_vec_in_LZ = -32'd1;
      a_prev_vec_in_AX = -32'd131010; a_prev_vec_in_AY = 32'd184057; a_prev_vec_in_AZ = 32'd1684920; a_prev_vec_in_LX = 32'd27757; a_prev_vec_in_LY = -32'd47665; a_prev_vec_in_LZ = 32'd574;
      v_curr_vec_in_AX = 32'd40787; v_curr_vec_in_AY = 32'd148431; v_curr_vec_in_AZ = -32'd19503; v_curr_vec_in_LX = 32'd26833; v_curr_vec_in_LY = -32'd8629; v_curr_vec_in_LZ = 32'd5595;
      a_curr_vec_in_AX = 32'd454102; a_curr_vec_in_AY = 32'd1626813; a_curr_vec_in_AZ = 32'd6726681; a_curr_vec_in_LX = 32'd60695; a_curr_vec_in_LY = -32'd31488; a_curr_vec_in_LZ = 32'd19432;
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
      // Link 5 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 5 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-5305, 5863, 7667, 36575, 9374, -25154);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -4354, 3320, 7150, 10972, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 4610, -12747, -7214, 5786, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -1038, 2853, 1647, -564, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 48590, -137401, -65942, 23191, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 45129, -36066, -70817, -96617, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -62580, 13151, -4659, 7121, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -5945, 1309, -1513, -8879, 1237, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1314, 12420, -2697, -9465, 16, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -394, -3077, 491, 2025, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 20251, 140949, -23281, -84990, -52, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 57716, -18551, 11438, 73710, -10981, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -24770, -13522, 1380, -31010, 3378, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 7 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd49084; cosq_curr_in = -32'd43424;
      qd_curr_in = 32'd50674;
      qdd_curr_in = 32'd3416239;
      v_prev_vec_in_AX = 32'd40787; v_prev_vec_in_AY = 32'd148430; v_prev_vec_in_AZ = -32'd19503; v_prev_vec_in_LX = 32'd26833; v_prev_vec_in_LY = -32'd8629; v_prev_vec_in_LZ = 32'd5595;
      a_prev_vec_in_AX = 32'd454103; a_prev_vec_in_AY = 32'd1626815; a_prev_vec_in_AZ = 32'd6726660; a_prev_vec_in_LX = 32'd60695; a_prev_vec_in_LY = -32'd31489; a_prev_vec_in_LZ = 32'd19432;
      v_curr_vec_in_AX = 32'd12419; v_curr_vec_in_AY = 32'd43471; v_curr_vec_in_AZ = 32'd199104; v_curr_vec_in_LX = 32'd25491; v_curr_vec_in_LY = 32'd15384; v_curr_vec_in_LZ = -32'd8629;
      a_curr_vec_in_AX = 32'd5372563; a_curr_vec_in_AY = -32'd4126612; a_curr_vec_in_AZ = 32'd5043054; a_curr_vec_in_LX = -32'd266811; a_curr_vec_in_LY = -32'd419582; a_curr_vec_in_LZ = -32'd31488;
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
      // Link 6 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 6 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2203, 5901, 31413, 121437, -77713, -83897);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 284, -35, 259, 931, 8200, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -123, -73, 247, -245, -1679, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -151, 839, 24, -794, -389, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 32323, -160291, -90398, 80218, -77343, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -111482, 77173, 64413, -25932, -128801, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -49161, 46245, 109642, 145168, 1770, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 76, -2, 75, -411, 337, 906, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -36, -40, -44, 186, -85, -135, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53, -127, 123, 558, -149, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5723, 166896, -36059, -143888, 77, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -43324, -60969, 11058, -9066, -92, 42, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -94050, 24373, -36659, -120581, -164, 321, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Dummy Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 0; cosq_curr_in = 0;
      qd_curr_in = 0;
      qdd_curr_in = 0;
      v_prev_vec_in_AX = 32'd12419; v_prev_vec_in_AY = 32'd43471; v_prev_vec_in_AZ = 32'd199104; v_prev_vec_in_LX = 32'd25491; v_prev_vec_in_LY = 32'd15384; v_prev_vec_in_LZ = -32'd8629;
      a_prev_vec_in_AX = 32'd5372563; a_prev_vec_in_AY = -32'd4126612; a_prev_vec_in_AZ = 32'd5043054; a_prev_vec_in_LX = -32'd266811; a_prev_vec_in_LY = -32'd419582; a_prev_vec_in_LZ = -32'd31488;
      v_curr_vec_in_AX = 0; v_curr_vec_in_AY = 0; v_curr_vec_in_AZ = 0; v_curr_vec_in_LX = 0; v_curr_vec_in_LY = 0; v_curr_vec_in_LZ = 0;
      a_curr_vec_in_AX = 0; a_curr_vec_in_AY = 0; a_curr_vec_in_AZ = 0; a_curr_vec_in_LX = 0; a_curr_vec_in_LY = 0; a_curr_vec_in_LZ = 0;
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
      // Link 7 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 7 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",8044, -6533, 5043, -120315, -133594, -13832);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -155, 691, 463, 126, 1874, -6533);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 52, -424, 142, 895, 1840, -8044);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -3285, -13804, 6498, 35032, 34895, -133594);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 10772, -28595, -29148, -4116, -35504, 120315);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -19629, 12420, 15012, -6108, -26838, -0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -204, -355, 58, 128, 34, 184, 43);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -186, 404, -176, -786, 108, 208, -12);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10435, 23638, -7656, -37658, 3027, 6737, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 13340, 20050, 289, -5454, 998, -5960, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -8477, -12323, 1071, -549, -757, 1182, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
      //------------------------------------------------------------------------
      $display ("// Knot 4 Link 1 Init");
      //------------------------------------------------------------------------
      // Link 1 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd19197; cosq_curr_in = 32'd62661;
      qd_curr_in = 32'd65530;
      qdd_curr_in = 32'd43998;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd0; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd0; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd65530; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd43998; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
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
      // (Ignore Dummy Outputs)
      //------------------------------------------------------------------------
      // Link 2 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd24454; cosq_curr_in = 32'd60803;
      qd_curr_in = 32'd16493;
      qdd_curr_in = 32'd136669;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd65530; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd43998; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd24452; v_curr_vec_in_AY = 32'd60797; v_curr_vec_in_AZ = 32'd16493; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd31718; a_curr_vec_in_AY = 32'd34667; a_curr_vec_in_AZ = 32'd136669; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
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
      // Link 1 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 1 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-944, 634, 1038, 5280, 7863, 0);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -1887, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 15727, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 3 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd36876; cosq_curr_in = 32'd54177;
      qd_curr_in = 32'd64662;
      qdd_curr_in = -32'd60321;
      v_prev_vec_in_AX = 32'd24452; v_prev_vec_in_AY = 32'd60797; v_prev_vec_in_AZ = 32'd16493; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd31718; a_prev_vec_in_AY = 32'd34667; a_prev_vec_in_AZ = 32'd136669; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd29494; v_curr_vec_in_AY = -32'd125; v_curr_vec_in_AZ = 32'd125459; v_curr_vec_in_LX = -32'd26; v_curr_vec_in_LY = 32'd6032; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = -32'd103245; a_curr_vec_in_AY = 32'd124234; a_curr_vec_in_AZ = -32'd25654; a_curr_vec_in_LX = 32'd25406; a_curr_vec_in_LY = 32'd21114; a_curr_vec_in_LZ = 32'd0;
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
      // Link 2 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 2 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2226, -184, 6473, -20115, -5700, 54);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 2709, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -126, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2017, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 8454, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -17508, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 6786, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 469, 6644, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 375, -304, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2077, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 10572, -40, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -4252, -7785, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -14781, 28755, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 4 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd685; cosq_curr_in = 32'd65532;
      qd_curr_in = 32'd36422;
      qdd_curr_in = 32'd358153;
      v_prev_vec_in_AX = -32'd29494; v_prev_vec_in_AY = -32'd125; v_prev_vec_in_AZ = 32'd125459; v_prev_vec_in_LX = -32'd25; v_prev_vec_in_LY = 32'd6032; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = -32'd103246; a_prev_vec_in_AY = 32'd124234; a_prev_vec_in_AZ = -32'd25654; a_prev_vec_in_LX = 32'd25406; a_prev_vec_in_LY = 32'd21114; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd30803; v_curr_vec_in_AY = 32'd125144; v_curr_vec_in_AZ = 32'd36546; v_curr_vec_in_LX = -32'd52; v_curr_vec_in_LY = -32'd1; v_curr_vec_in_LZ = -32'd12388;
      a_curr_vec_in_AX = -32'd33423; a_curr_vec_in_AY = -32'd9612; a_curr_vec_in_AZ = 32'd233920; a_curr_vec_in_LX = 32'd52175; a_curr_vec_in_LY = 32'd574; a_curr_vec_in_LZ = -32'd43363;
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
      // Link 3 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 3 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-19396, 14507, -2367, 70323, 80557, -22634);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2621, 15599, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -10348, 21009, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1137, -2999, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -51071, 102173, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1313, -68019, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -57033, 16263, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1897, -19915, 2933, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10769, -13702, 147, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1521, 1936, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53805, -68646, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22821, 97882, -22583, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -23054, -23480, -22, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 5 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd48758; cosq_curr_in = 32'd43790;
      qd_curr_in = 32'd28646;
      qdd_curr_in = 32'd1694532;
      v_prev_vec_in_AX = -32'd30803; v_prev_vec_in_AY = 32'd125144; v_prev_vec_in_AZ = 32'd36546; v_prev_vec_in_LX = -32'd52; v_prev_vec_in_LY = -32'd1; v_prev_vec_in_LZ = -32'd12388;
      a_prev_vec_in_AX = -32'd33423; a_prev_vec_in_AY = -32'd9612; a_prev_vec_in_AZ = 32'd233919; a_prev_vec_in_LX = 32'd52175; a_prev_vec_in_LY = 32'd574; a_prev_vec_in_LZ = -32'd43363;
      v_curr_vec_in_AX = -32'd6608; v_curr_vec_in_AY = 32'd47337; v_curr_vec_in_AZ = 32'd153790; v_curr_vec_in_LX = 32'd17985; v_curr_vec_in_LY = -32'd7019; v_curr_vec_in_LZ = -32'd1;
      a_curr_vec_in_AX = -32'd131010; a_curr_vec_in_AY = 32'd184057; a_curr_vec_in_AZ = 32'd1684917; a_curr_vec_in_LX = 32'd27757; a_curr_vec_in_LY = -32'd47665; a_curr_vec_in_LZ = 32'd574;
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
      // Link 4 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 4 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-8244, 621, 6514, 21590, -11080, -133498);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 826, 8949, 1941, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2678, 4680, 1622, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 5904, -12157, -6891, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -76136, 136829, 35836, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -55811, -9425, -53266, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 3436, 89127, 1368, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1436, -9457, 1126, 9615, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2460, -3074, -13, 277, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5950, 7332, -181, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -73332, -89415, -473, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22838, -43368, -94, -13222, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10554, -135202, -9858, 45277, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 6 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd20062; cosq_curr_in = 32'd62390;
      qd_curr_in = 32'd27834;
      qdd_curr_in = 32'd6910717;
      v_prev_vec_in_AX = -32'd6608; v_prev_vec_in_AY = 32'd47337; v_prev_vec_in_AZ = 32'd153790; v_prev_vec_in_LX = 32'd17985; v_prev_vec_in_LY = -32'd7019; v_prev_vec_in_LZ = -32'd1;
      a_prev_vec_in_AX = -32'd131010; a_prev_vec_in_AY = 32'd184057; a_prev_vec_in_AZ = 32'd1684920; a_prev_vec_in_LX = 32'd27757; a_prev_vec_in_LY = -32'd47665; a_prev_vec_in_LZ = 32'd574;
      v_curr_vec_in_AX = 32'd40787; v_curr_vec_in_AY = 32'd148431; v_curr_vec_in_AZ = -32'd19503; v_curr_vec_in_LX = 32'd26833; v_curr_vec_in_LY = -32'd8629; v_curr_vec_in_LZ = 32'd5595;
      a_curr_vec_in_AX = 32'd454102; a_curr_vec_in_AY = 32'd1626813; a_curr_vec_in_AZ = 32'd6726681; a_curr_vec_in_LX = 32'd60695; a_curr_vec_in_LY = -32'd31488; a_curr_vec_in_LZ = 32'd19432;
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
      // Link 5 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 5 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-5305, 5863, 7667, 36575, 9374, -25154);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -4354, 3320, 7150, 10972, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 4610, -12747, -7214, 5786, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -1038, 2853, 1647, -564, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 48590, -137401, -65942, 23191, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 45129, -36066, -70817, -96617, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -62580, 13151, -4659, 7121, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -5945, 1309, -1513, -8879, 1237, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1314, 12420, -2697, -9465, 16, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -394, -3077, 491, 2025, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 20251, 140949, -23281, -84990, -52, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 57716, -18551, 11438, 73710, -10981, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -24770, -13522, 1380, -31010, 3378, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 7 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd49084; cosq_curr_in = -32'd43424;
      qd_curr_in = 32'd50674;
      qdd_curr_in = 32'd3416239;
      v_prev_vec_in_AX = 32'd40787; v_prev_vec_in_AY = 32'd148430; v_prev_vec_in_AZ = -32'd19503; v_prev_vec_in_LX = 32'd26833; v_prev_vec_in_LY = -32'd8629; v_prev_vec_in_LZ = 32'd5595;
      a_prev_vec_in_AX = 32'd454103; a_prev_vec_in_AY = 32'd1626815; a_prev_vec_in_AZ = 32'd6726660; a_prev_vec_in_LX = 32'd60695; a_prev_vec_in_LY = -32'd31489; a_prev_vec_in_LZ = 32'd19432;
      v_curr_vec_in_AX = 32'd12419; v_curr_vec_in_AY = 32'd43471; v_curr_vec_in_AZ = 32'd199104; v_curr_vec_in_LX = 32'd25491; v_curr_vec_in_LY = 32'd15384; v_curr_vec_in_LZ = -32'd8629;
      a_curr_vec_in_AX = 32'd5372563; a_curr_vec_in_AY = -32'd4126612; a_curr_vec_in_AZ = 32'd5043054; a_curr_vec_in_LX = -32'd266811; a_curr_vec_in_LY = -32'd419582; a_curr_vec_in_LZ = -32'd31488;
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
      // Link 6 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 6 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2203, 5901, 31413, 121437, -77713, -83897);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 284, -35, 259, 931, 8200, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -123, -73, 247, -245, -1679, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -151, 839, 24, -794, -389, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 32323, -160291, -90398, 80218, -77343, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -111482, 77173, 64413, -25932, -128801, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -49161, 46245, 109642, 145168, 1770, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 76, -2, 75, -411, 337, 906, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -36, -40, -44, 186, -85, -135, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53, -127, 123, 558, -149, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5723, 166896, -36059, -143888, 77, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -43324, -60969, 11058, -9066, -92, 42, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -94050, 24373, -36659, -120581, -164, 321, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Dummy Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 0; cosq_curr_in = 0;
      qd_curr_in = 0;
      qdd_curr_in = 0;
      v_prev_vec_in_AX = 32'd12419; v_prev_vec_in_AY = 32'd43471; v_prev_vec_in_AZ = 32'd199104; v_prev_vec_in_LX = 32'd25491; v_prev_vec_in_LY = 32'd15384; v_prev_vec_in_LZ = -32'd8629;
      a_prev_vec_in_AX = 32'd5372563; a_prev_vec_in_AY = -32'd4126612; a_prev_vec_in_AZ = 32'd5043054; a_prev_vec_in_LX = -32'd266811; a_prev_vec_in_LY = -32'd419582; a_prev_vec_in_LZ = -32'd31488;
      v_curr_vec_in_AX = 0; v_curr_vec_in_AY = 0; v_curr_vec_in_AZ = 0; v_curr_vec_in_LX = 0; v_curr_vec_in_LY = 0; v_curr_vec_in_LZ = 0;
      a_curr_vec_in_AX = 0; a_curr_vec_in_AY = 0; a_curr_vec_in_AZ = 0; a_curr_vec_in_LX = 0; a_curr_vec_in_LY = 0; a_curr_vec_in_LZ = 0;
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
      // Link 7 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 7 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",8044, -6533, 5043, -120315, -133594, -13832);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -155, 691, 463, 126, 1874, -6533);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 52, -424, 142, 895, 1840, -8044);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -3285, -13804, 6498, 35032, 34895, -133594);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 10772, -28595, -29148, -4116, -35504, 120315);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -19629, 12420, 15012, -6108, -26838, -0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -204, -355, 58, 128, 34, 184, 43);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -186, 404, -176, -786, 108, 208, -12);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10435, 23638, -7656, -37658, 3027, 6737, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 13340, 20050, 289, -5454, 998, -5960, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -8477, -12323, 1071, -549, -757, 1182, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
      //------------------------------------------------------------------------
      $display ("// Knot 5 Link 1 Init");
      //------------------------------------------------------------------------
      // Link 1 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd19197; cosq_curr_in = 32'd62661;
      qd_curr_in = 32'd65530;
      qdd_curr_in = 32'd43998;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd0; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd0; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd65530; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd43998; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
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
      // (Ignore Dummy Outputs)
      //------------------------------------------------------------------------
      // Link 2 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd24454; cosq_curr_in = 32'd60803;
      qd_curr_in = 32'd16493;
      qdd_curr_in = 32'd136669;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd65530; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd43998; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd24452; v_curr_vec_in_AY = 32'd60797; v_curr_vec_in_AZ = 32'd16493; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd31718; a_curr_vec_in_AY = 32'd34667; a_curr_vec_in_AZ = 32'd136669; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
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
      // Link 1 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 1 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-944, 634, 1038, 5280, 7863, 0);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -1887, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 15727, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 3 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd36876; cosq_curr_in = 32'd54177;
      qd_curr_in = 32'd64662;
      qdd_curr_in = -32'd60321;
      v_prev_vec_in_AX = 32'd24452; v_prev_vec_in_AY = 32'd60797; v_prev_vec_in_AZ = 32'd16493; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd31718; a_prev_vec_in_AY = 32'd34667; a_prev_vec_in_AZ = 32'd136669; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd29494; v_curr_vec_in_AY = -32'd125; v_curr_vec_in_AZ = 32'd125459; v_curr_vec_in_LX = -32'd26; v_curr_vec_in_LY = 32'd6032; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = -32'd103245; a_curr_vec_in_AY = 32'd124234; a_curr_vec_in_AZ = -32'd25654; a_curr_vec_in_LX = 32'd25406; a_curr_vec_in_LY = 32'd21114; a_curr_vec_in_LZ = 32'd0;
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
      // Link 2 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 2 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2226, -184, 6473, -20115, -5700, 54);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 2709, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -126, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2017, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 8454, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -17508, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 6786, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 469, 6644, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 375, -304, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2077, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 10572, -40, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -4252, -7785, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -14781, 28755, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 4 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd685; cosq_curr_in = 32'd65532;
      qd_curr_in = 32'd36422;
      qdd_curr_in = 32'd358153;
      v_prev_vec_in_AX = -32'd29494; v_prev_vec_in_AY = -32'd125; v_prev_vec_in_AZ = 32'd125459; v_prev_vec_in_LX = -32'd25; v_prev_vec_in_LY = 32'd6032; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = -32'd103246; a_prev_vec_in_AY = 32'd124234; a_prev_vec_in_AZ = -32'd25654; a_prev_vec_in_LX = 32'd25406; a_prev_vec_in_LY = 32'd21114; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd30803; v_curr_vec_in_AY = 32'd125144; v_curr_vec_in_AZ = 32'd36546; v_curr_vec_in_LX = -32'd52; v_curr_vec_in_LY = -32'd1; v_curr_vec_in_LZ = -32'd12388;
      a_curr_vec_in_AX = -32'd33423; a_curr_vec_in_AY = -32'd9612; a_curr_vec_in_AZ = 32'd233920; a_curr_vec_in_LX = 32'd52175; a_curr_vec_in_LY = 32'd574; a_curr_vec_in_LZ = -32'd43363;
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
      // Link 3 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 3 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-19396, 14507, -2367, 70323, 80557, -22634);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2621, 15599, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -10348, 21009, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1137, -2999, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -51071, 102173, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1313, -68019, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -57033, 16263, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1897, -19915, 2933, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10769, -13702, 147, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1521, 1936, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53805, -68646, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22821, 97882, -22583, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -23054, -23480, -22, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 5 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd48758; cosq_curr_in = 32'd43790;
      qd_curr_in = 32'd28646;
      qdd_curr_in = 32'd1694532;
      v_prev_vec_in_AX = -32'd30803; v_prev_vec_in_AY = 32'd125144; v_prev_vec_in_AZ = 32'd36546; v_prev_vec_in_LX = -32'd52; v_prev_vec_in_LY = -32'd1; v_prev_vec_in_LZ = -32'd12388;
      a_prev_vec_in_AX = -32'd33423; a_prev_vec_in_AY = -32'd9612; a_prev_vec_in_AZ = 32'd233919; a_prev_vec_in_LX = 32'd52175; a_prev_vec_in_LY = 32'd574; a_prev_vec_in_LZ = -32'd43363;
      v_curr_vec_in_AX = -32'd6608; v_curr_vec_in_AY = 32'd47337; v_curr_vec_in_AZ = 32'd153790; v_curr_vec_in_LX = 32'd17985; v_curr_vec_in_LY = -32'd7019; v_curr_vec_in_LZ = -32'd1;
      a_curr_vec_in_AX = -32'd131010; a_curr_vec_in_AY = 32'd184057; a_curr_vec_in_AZ = 32'd1684917; a_curr_vec_in_LX = 32'd27757; a_curr_vec_in_LY = -32'd47665; a_curr_vec_in_LZ = 32'd574;
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
      // Link 4 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 4 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-8244, 621, 6514, 21590, -11080, -133498);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 826, 8949, 1941, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2678, 4680, 1622, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 5904, -12157, -6891, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -76136, 136829, 35836, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -55811, -9425, -53266, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 3436, 89127, 1368, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1436, -9457, 1126, 9615, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2460, -3074, -13, 277, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5950, 7332, -181, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -73332, -89415, -473, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22838, -43368, -94, -13222, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10554, -135202, -9858, 45277, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 6 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd20062; cosq_curr_in = 32'd62390;
      qd_curr_in = 32'd27834;
      qdd_curr_in = 32'd6910717;
      v_prev_vec_in_AX = -32'd6608; v_prev_vec_in_AY = 32'd47337; v_prev_vec_in_AZ = 32'd153790; v_prev_vec_in_LX = 32'd17985; v_prev_vec_in_LY = -32'd7019; v_prev_vec_in_LZ = -32'd1;
      a_prev_vec_in_AX = -32'd131010; a_prev_vec_in_AY = 32'd184057; a_prev_vec_in_AZ = 32'd1684920; a_prev_vec_in_LX = 32'd27757; a_prev_vec_in_LY = -32'd47665; a_prev_vec_in_LZ = 32'd574;
      v_curr_vec_in_AX = 32'd40787; v_curr_vec_in_AY = 32'd148431; v_curr_vec_in_AZ = -32'd19503; v_curr_vec_in_LX = 32'd26833; v_curr_vec_in_LY = -32'd8629; v_curr_vec_in_LZ = 32'd5595;
      a_curr_vec_in_AX = 32'd454102; a_curr_vec_in_AY = 32'd1626813; a_curr_vec_in_AZ = 32'd6726681; a_curr_vec_in_LX = 32'd60695; a_curr_vec_in_LY = -32'd31488; a_curr_vec_in_LZ = 32'd19432;
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
      // Link 5 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 5 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-5305, 5863, 7667, 36575, 9374, -25154);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -4354, 3320, 7150, 10972, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 4610, -12747, -7214, 5786, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -1038, 2853, 1647, -564, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 48590, -137401, -65942, 23191, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 45129, -36066, -70817, -96617, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -62580, 13151, -4659, 7121, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -5945, 1309, -1513, -8879, 1237, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1314, 12420, -2697, -9465, 16, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -394, -3077, 491, 2025, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 20251, 140949, -23281, -84990, -52, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 57716, -18551, 11438, 73710, -10981, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -24770, -13522, 1380, -31010, 3378, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 7 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd49084; cosq_curr_in = -32'd43424;
      qd_curr_in = 32'd50674;
      qdd_curr_in = 32'd3416239;
      v_prev_vec_in_AX = 32'd40787; v_prev_vec_in_AY = 32'd148430; v_prev_vec_in_AZ = -32'd19503; v_prev_vec_in_LX = 32'd26833; v_prev_vec_in_LY = -32'd8629; v_prev_vec_in_LZ = 32'd5595;
      a_prev_vec_in_AX = 32'd454103; a_prev_vec_in_AY = 32'd1626815; a_prev_vec_in_AZ = 32'd6726660; a_prev_vec_in_LX = 32'd60695; a_prev_vec_in_LY = -32'd31489; a_prev_vec_in_LZ = 32'd19432;
      v_curr_vec_in_AX = 32'd12419; v_curr_vec_in_AY = 32'd43471; v_curr_vec_in_AZ = 32'd199104; v_curr_vec_in_LX = 32'd25491; v_curr_vec_in_LY = 32'd15384; v_curr_vec_in_LZ = -32'd8629;
      a_curr_vec_in_AX = 32'd5372563; a_curr_vec_in_AY = -32'd4126612; a_curr_vec_in_AZ = 32'd5043054; a_curr_vec_in_LX = -32'd266811; a_curr_vec_in_LY = -32'd419582; a_curr_vec_in_LZ = -32'd31488;
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
      // Link 6 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 6 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2203, 5901, 31413, 121437, -77713, -83897);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 284, -35, 259, 931, 8200, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -123, -73, 247, -245, -1679, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -151, 839, 24, -794, -389, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 32323, -160291, -90398, 80218, -77343, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -111482, 77173, 64413, -25932, -128801, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -49161, 46245, 109642, 145168, 1770, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 76, -2, 75, -411, 337, 906, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -36, -40, -44, 186, -85, -135, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53, -127, 123, 558, -149, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5723, 166896, -36059, -143888, 77, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -43324, -60969, 11058, -9066, -92, 42, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -94050, 24373, -36659, -120581, -164, 321, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Dummy Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 0; cosq_curr_in = 0;
      qd_curr_in = 0;
      qdd_curr_in = 0;
      v_prev_vec_in_AX = 32'd12419; v_prev_vec_in_AY = 32'd43471; v_prev_vec_in_AZ = 32'd199104; v_prev_vec_in_LX = 32'd25491; v_prev_vec_in_LY = 32'd15384; v_prev_vec_in_LZ = -32'd8629;
      a_prev_vec_in_AX = 32'd5372563; a_prev_vec_in_AY = -32'd4126612; a_prev_vec_in_AZ = 32'd5043054; a_prev_vec_in_LX = -32'd266811; a_prev_vec_in_LY = -32'd419582; a_prev_vec_in_LZ = -32'd31488;
      v_curr_vec_in_AX = 0; v_curr_vec_in_AY = 0; v_curr_vec_in_AZ = 0; v_curr_vec_in_LX = 0; v_curr_vec_in_LY = 0; v_curr_vec_in_LZ = 0;
      a_curr_vec_in_AX = 0; a_curr_vec_in_AY = 0; a_curr_vec_in_AZ = 0; a_curr_vec_in_LX = 0; a_curr_vec_in_LY = 0; a_curr_vec_in_LZ = 0;
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
      // Link 7 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 7 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",8044, -6533, 5043, -120315, -133594, -13832);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -155, 691, 463, 126, 1874, -6533);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 52, -424, 142, 895, 1840, -8044);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -3285, -13804, 6498, 35032, 34895, -133594);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 10772, -28595, -29148, -4116, -35504, 120315);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -19629, 12420, 15012, -6108, -26838, -0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -204, -355, 58, 128, 34, 184, 43);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -186, 404, -176, -786, 108, 208, -12);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10435, 23638, -7656, -37658, 3027, 6737, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 13340, 20050, 289, -5454, 998, -5960, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -8477, -12323, 1071, -549, -757, 1182, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
      //------------------------------------------------------------------------
      $display ("// Knot 6 Link 1 Init");
      //------------------------------------------------------------------------
      // Link 1 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd19197; cosq_curr_in = 32'd62661;
      qd_curr_in = 32'd65530;
      qdd_curr_in = 32'd43998;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd0; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd0; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd65530; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd43998; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
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
      // (Ignore Dummy Outputs)
      //------------------------------------------------------------------------
      // Link 2 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd24454; cosq_curr_in = 32'd60803;
      qd_curr_in = 32'd16493;
      qdd_curr_in = 32'd136669;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd65530; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd43998; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd24452; v_curr_vec_in_AY = 32'd60797; v_curr_vec_in_AZ = 32'd16493; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd31718; a_curr_vec_in_AY = 32'd34667; a_curr_vec_in_AZ = 32'd136669; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
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
      // Link 1 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 1 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-944, 634, 1038, 5280, 7863, 0);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -1887, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 15727, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 3 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd36876; cosq_curr_in = 32'd54177;
      qd_curr_in = 32'd64662;
      qdd_curr_in = -32'd60321;
      v_prev_vec_in_AX = 32'd24452; v_prev_vec_in_AY = 32'd60797; v_prev_vec_in_AZ = 32'd16493; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd31718; a_prev_vec_in_AY = 32'd34667; a_prev_vec_in_AZ = 32'd136669; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd29494; v_curr_vec_in_AY = -32'd125; v_curr_vec_in_AZ = 32'd125459; v_curr_vec_in_LX = -32'd26; v_curr_vec_in_LY = 32'd6032; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = -32'd103245; a_curr_vec_in_AY = 32'd124234; a_curr_vec_in_AZ = -32'd25654; a_curr_vec_in_LX = 32'd25406; a_curr_vec_in_LY = 32'd21114; a_curr_vec_in_LZ = 32'd0;
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
      // Link 2 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 2 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2226, -184, 6473, -20115, -5700, 54);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 2709, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -126, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2017, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 8454, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -17508, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 6786, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 469, 6644, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 375, -304, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2077, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 10572, -40, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -4252, -7785, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -14781, 28755, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 4 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd685; cosq_curr_in = 32'd65532;
      qd_curr_in = 32'd36422;
      qdd_curr_in = 32'd358153;
      v_prev_vec_in_AX = -32'd29494; v_prev_vec_in_AY = -32'd125; v_prev_vec_in_AZ = 32'd125459; v_prev_vec_in_LX = -32'd25; v_prev_vec_in_LY = 32'd6032; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = -32'd103246; a_prev_vec_in_AY = 32'd124234; a_prev_vec_in_AZ = -32'd25654; a_prev_vec_in_LX = 32'd25406; a_prev_vec_in_LY = 32'd21114; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd30803; v_curr_vec_in_AY = 32'd125144; v_curr_vec_in_AZ = 32'd36546; v_curr_vec_in_LX = -32'd52; v_curr_vec_in_LY = -32'd1; v_curr_vec_in_LZ = -32'd12388;
      a_curr_vec_in_AX = -32'd33423; a_curr_vec_in_AY = -32'd9612; a_curr_vec_in_AZ = 32'd233920; a_curr_vec_in_LX = 32'd52175; a_curr_vec_in_LY = 32'd574; a_curr_vec_in_LZ = -32'd43363;
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
      // Link 3 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 3 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-19396, 14507, -2367, 70323, 80557, -22634);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2621, 15599, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -10348, 21009, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1137, -2999, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -51071, 102173, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1313, -68019, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -57033, 16263, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1897, -19915, 2933, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10769, -13702, 147, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1521, 1936, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53805, -68646, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22821, 97882, -22583, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -23054, -23480, -22, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 5 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd48758; cosq_curr_in = 32'd43790;
      qd_curr_in = 32'd28646;
      qdd_curr_in = 32'd1694532;
      v_prev_vec_in_AX = -32'd30803; v_prev_vec_in_AY = 32'd125144; v_prev_vec_in_AZ = 32'd36546; v_prev_vec_in_LX = -32'd52; v_prev_vec_in_LY = -32'd1; v_prev_vec_in_LZ = -32'd12388;
      a_prev_vec_in_AX = -32'd33423; a_prev_vec_in_AY = -32'd9612; a_prev_vec_in_AZ = 32'd233919; a_prev_vec_in_LX = 32'd52175; a_prev_vec_in_LY = 32'd574; a_prev_vec_in_LZ = -32'd43363;
      v_curr_vec_in_AX = -32'd6608; v_curr_vec_in_AY = 32'd47337; v_curr_vec_in_AZ = 32'd153790; v_curr_vec_in_LX = 32'd17985; v_curr_vec_in_LY = -32'd7019; v_curr_vec_in_LZ = -32'd1;
      a_curr_vec_in_AX = -32'd131010; a_curr_vec_in_AY = 32'd184057; a_curr_vec_in_AZ = 32'd1684917; a_curr_vec_in_LX = 32'd27757; a_curr_vec_in_LY = -32'd47665; a_curr_vec_in_LZ = 32'd574;
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
      // Link 4 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 4 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-8244, 621, 6514, 21590, -11080, -133498);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 826, 8949, 1941, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2678, 4680, 1622, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 5904, -12157, -6891, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -76136, 136829, 35836, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -55811, -9425, -53266, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 3436, 89127, 1368, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1436, -9457, 1126, 9615, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2460, -3074, -13, 277, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5950, 7332, -181, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -73332, -89415, -473, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22838, -43368, -94, -13222, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10554, -135202, -9858, 45277, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 6 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd20062; cosq_curr_in = 32'd62390;
      qd_curr_in = 32'd27834;
      qdd_curr_in = 32'd6910717;
      v_prev_vec_in_AX = -32'd6608; v_prev_vec_in_AY = 32'd47337; v_prev_vec_in_AZ = 32'd153790; v_prev_vec_in_LX = 32'd17985; v_prev_vec_in_LY = -32'd7019; v_prev_vec_in_LZ = -32'd1;
      a_prev_vec_in_AX = -32'd131010; a_prev_vec_in_AY = 32'd184057; a_prev_vec_in_AZ = 32'd1684920; a_prev_vec_in_LX = 32'd27757; a_prev_vec_in_LY = -32'd47665; a_prev_vec_in_LZ = 32'd574;
      v_curr_vec_in_AX = 32'd40787; v_curr_vec_in_AY = 32'd148431; v_curr_vec_in_AZ = -32'd19503; v_curr_vec_in_LX = 32'd26833; v_curr_vec_in_LY = -32'd8629; v_curr_vec_in_LZ = 32'd5595;
      a_curr_vec_in_AX = 32'd454102; a_curr_vec_in_AY = 32'd1626813; a_curr_vec_in_AZ = 32'd6726681; a_curr_vec_in_LX = 32'd60695; a_curr_vec_in_LY = -32'd31488; a_curr_vec_in_LZ = 32'd19432;
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
      // Link 5 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 5 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-5305, 5863, 7667, 36575, 9374, -25154);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -4354, 3320, 7150, 10972, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 4610, -12747, -7214, 5786, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -1038, 2853, 1647, -564, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 48590, -137401, -65942, 23191, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 45129, -36066, -70817, -96617, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -62580, 13151, -4659, 7121, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -5945, 1309, -1513, -8879, 1237, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1314, 12420, -2697, -9465, 16, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -394, -3077, 491, 2025, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 20251, 140949, -23281, -84990, -52, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 57716, -18551, 11438, 73710, -10981, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -24770, -13522, 1380, -31010, 3378, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 7 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd49084; cosq_curr_in = -32'd43424;
      qd_curr_in = 32'd50674;
      qdd_curr_in = 32'd3416239;
      v_prev_vec_in_AX = 32'd40787; v_prev_vec_in_AY = 32'd148430; v_prev_vec_in_AZ = -32'd19503; v_prev_vec_in_LX = 32'd26833; v_prev_vec_in_LY = -32'd8629; v_prev_vec_in_LZ = 32'd5595;
      a_prev_vec_in_AX = 32'd454103; a_prev_vec_in_AY = 32'd1626815; a_prev_vec_in_AZ = 32'd6726660; a_prev_vec_in_LX = 32'd60695; a_prev_vec_in_LY = -32'd31489; a_prev_vec_in_LZ = 32'd19432;
      v_curr_vec_in_AX = 32'd12419; v_curr_vec_in_AY = 32'd43471; v_curr_vec_in_AZ = 32'd199104; v_curr_vec_in_LX = 32'd25491; v_curr_vec_in_LY = 32'd15384; v_curr_vec_in_LZ = -32'd8629;
      a_curr_vec_in_AX = 32'd5372563; a_curr_vec_in_AY = -32'd4126612; a_curr_vec_in_AZ = 32'd5043054; a_curr_vec_in_LX = -32'd266811; a_curr_vec_in_LY = -32'd419582; a_curr_vec_in_LZ = -32'd31488;
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
      // Link 6 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 6 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2203, 5901, 31413, 121437, -77713, -83897);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 284, -35, 259, 931, 8200, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -123, -73, 247, -245, -1679, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -151, 839, 24, -794, -389, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 32323, -160291, -90398, 80218, -77343, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -111482, 77173, 64413, -25932, -128801, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -49161, 46245, 109642, 145168, 1770, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 76, -2, 75, -411, 337, 906, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -36, -40, -44, 186, -85, -135, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53, -127, 123, 558, -149, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5723, 166896, -36059, -143888, 77, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -43324, -60969, 11058, -9066, -92, 42, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -94050, 24373, -36659, -120581, -164, 321, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Dummy Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 0; cosq_curr_in = 0;
      qd_curr_in = 0;
      qdd_curr_in = 0;
      v_prev_vec_in_AX = 32'd12419; v_prev_vec_in_AY = 32'd43471; v_prev_vec_in_AZ = 32'd199104; v_prev_vec_in_LX = 32'd25491; v_prev_vec_in_LY = 32'd15384; v_prev_vec_in_LZ = -32'd8629;
      a_prev_vec_in_AX = 32'd5372563; a_prev_vec_in_AY = -32'd4126612; a_prev_vec_in_AZ = 32'd5043054; a_prev_vec_in_LX = -32'd266811; a_prev_vec_in_LY = -32'd419582; a_prev_vec_in_LZ = -32'd31488;
      v_curr_vec_in_AX = 0; v_curr_vec_in_AY = 0; v_curr_vec_in_AZ = 0; v_curr_vec_in_LX = 0; v_curr_vec_in_LY = 0; v_curr_vec_in_LZ = 0;
      a_curr_vec_in_AX = 0; a_curr_vec_in_AY = 0; a_curr_vec_in_AZ = 0; a_curr_vec_in_LX = 0; a_curr_vec_in_LY = 0; a_curr_vec_in_LZ = 0;
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
      // Link 7 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 7 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",8044, -6533, 5043, -120315, -133594, -13832);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -155, 691, 463, 126, 1874, -6533);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 52, -424, 142, 895, 1840, -8044);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -3285, -13804, 6498, 35032, 34895, -133594);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 10772, -28595, -29148, -4116, -35504, 120315);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -19629, 12420, 15012, -6108, -26838, -0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -204, -355, 58, 128, 34, 184, 43);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -186, 404, -176, -786, 108, 208, -12);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10435, 23638, -7656, -37658, 3027, 6737, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 13340, 20050, 289, -5454, 998, -5960, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -8477, -12323, 1071, -549, -757, 1182, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
      //------------------------------------------------------------------------
      $display ("// Knot 7 Link 1 Init");
      //------------------------------------------------------------------------
      // Link 1 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd19197; cosq_curr_in = 32'd62661;
      qd_curr_in = 32'd65530;
      qdd_curr_in = 32'd43998;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd0; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd0; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd65530; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd43998; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
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
      // (Ignore Dummy Outputs)
      //------------------------------------------------------------------------
      // Link 2 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd24454; cosq_curr_in = 32'd60803;
      qd_curr_in = 32'd16493;
      qdd_curr_in = 32'd136669;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd65530; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd43998; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd24452; v_curr_vec_in_AY = 32'd60797; v_curr_vec_in_AZ = 32'd16493; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd31718; a_curr_vec_in_AY = 32'd34667; a_curr_vec_in_AZ = 32'd136669; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
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
      // Link 1 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 1 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-944, 634, 1038, 5280, 7863, 0);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -1887, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 15727, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 3 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd36876; cosq_curr_in = 32'd54177;
      qd_curr_in = 32'd64662;
      qdd_curr_in = -32'd60321;
      v_prev_vec_in_AX = 32'd24452; v_prev_vec_in_AY = 32'd60797; v_prev_vec_in_AZ = 32'd16493; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd31718; a_prev_vec_in_AY = 32'd34667; a_prev_vec_in_AZ = 32'd136669; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd29494; v_curr_vec_in_AY = -32'd125; v_curr_vec_in_AZ = 32'd125459; v_curr_vec_in_LX = -32'd26; v_curr_vec_in_LY = 32'd6032; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = -32'd103245; a_curr_vec_in_AY = 32'd124234; a_curr_vec_in_AZ = -32'd25654; a_curr_vec_in_LX = 32'd25406; a_curr_vec_in_LY = 32'd21114; a_curr_vec_in_LZ = 32'd0;
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
      // Link 2 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 2 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2226, -184, 6473, -20115, -5700, 54);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 2709, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -126, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2017, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 8454, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -17508, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 6786, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 469, 6644, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 375, -304, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2077, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 10572, -40, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -4252, -7785, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -14781, 28755, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 4 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd685; cosq_curr_in = 32'd65532;
      qd_curr_in = 32'd36422;
      qdd_curr_in = 32'd358153;
      v_prev_vec_in_AX = -32'd29494; v_prev_vec_in_AY = -32'd125; v_prev_vec_in_AZ = 32'd125459; v_prev_vec_in_LX = -32'd25; v_prev_vec_in_LY = 32'd6032; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = -32'd103246; a_prev_vec_in_AY = 32'd124234; a_prev_vec_in_AZ = -32'd25654; a_prev_vec_in_LX = 32'd25406; a_prev_vec_in_LY = 32'd21114; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd30803; v_curr_vec_in_AY = 32'd125144; v_curr_vec_in_AZ = 32'd36546; v_curr_vec_in_LX = -32'd52; v_curr_vec_in_LY = -32'd1; v_curr_vec_in_LZ = -32'd12388;
      a_curr_vec_in_AX = -32'd33423; a_curr_vec_in_AY = -32'd9612; a_curr_vec_in_AZ = 32'd233920; a_curr_vec_in_LX = 32'd52175; a_curr_vec_in_LY = 32'd574; a_curr_vec_in_LZ = -32'd43363;
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
      // Link 3 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 3 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-19396, 14507, -2367, 70323, 80557, -22634);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2621, 15599, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -10348, 21009, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1137, -2999, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -51071, 102173, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1313, -68019, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -57033, 16263, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1897, -19915, 2933, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10769, -13702, 147, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1521, 1936, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53805, -68646, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22821, 97882, -22583, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -23054, -23480, -22, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 5 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd48758; cosq_curr_in = 32'd43790;
      qd_curr_in = 32'd28646;
      qdd_curr_in = 32'd1694532;
      v_prev_vec_in_AX = -32'd30803; v_prev_vec_in_AY = 32'd125144; v_prev_vec_in_AZ = 32'd36546; v_prev_vec_in_LX = -32'd52; v_prev_vec_in_LY = -32'd1; v_prev_vec_in_LZ = -32'd12388;
      a_prev_vec_in_AX = -32'd33423; a_prev_vec_in_AY = -32'd9612; a_prev_vec_in_AZ = 32'd233919; a_prev_vec_in_LX = 32'd52175; a_prev_vec_in_LY = 32'd574; a_prev_vec_in_LZ = -32'd43363;
      v_curr_vec_in_AX = -32'd6608; v_curr_vec_in_AY = 32'd47337; v_curr_vec_in_AZ = 32'd153790; v_curr_vec_in_LX = 32'd17985; v_curr_vec_in_LY = -32'd7019; v_curr_vec_in_LZ = -32'd1;
      a_curr_vec_in_AX = -32'd131010; a_curr_vec_in_AY = 32'd184057; a_curr_vec_in_AZ = 32'd1684917; a_curr_vec_in_LX = 32'd27757; a_curr_vec_in_LY = -32'd47665; a_curr_vec_in_LZ = 32'd574;
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
      // Link 4 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 4 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-8244, 621, 6514, 21590, -11080, -133498);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 826, 8949, 1941, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2678, 4680, 1622, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 5904, -12157, -6891, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -76136, 136829, 35836, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -55811, -9425, -53266, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 3436, 89127, 1368, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1436, -9457, 1126, 9615, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2460, -3074, -13, 277, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5950, 7332, -181, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -73332, -89415, -473, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22838, -43368, -94, -13222, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10554, -135202, -9858, 45277, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 6 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd20062; cosq_curr_in = 32'd62390;
      qd_curr_in = 32'd27834;
      qdd_curr_in = 32'd6910717;
      v_prev_vec_in_AX = -32'd6608; v_prev_vec_in_AY = 32'd47337; v_prev_vec_in_AZ = 32'd153790; v_prev_vec_in_LX = 32'd17985; v_prev_vec_in_LY = -32'd7019; v_prev_vec_in_LZ = -32'd1;
      a_prev_vec_in_AX = -32'd131010; a_prev_vec_in_AY = 32'd184057; a_prev_vec_in_AZ = 32'd1684920; a_prev_vec_in_LX = 32'd27757; a_prev_vec_in_LY = -32'd47665; a_prev_vec_in_LZ = 32'd574;
      v_curr_vec_in_AX = 32'd40787; v_curr_vec_in_AY = 32'd148431; v_curr_vec_in_AZ = -32'd19503; v_curr_vec_in_LX = 32'd26833; v_curr_vec_in_LY = -32'd8629; v_curr_vec_in_LZ = 32'd5595;
      a_curr_vec_in_AX = 32'd454102; a_curr_vec_in_AY = 32'd1626813; a_curr_vec_in_AZ = 32'd6726681; a_curr_vec_in_LX = 32'd60695; a_curr_vec_in_LY = -32'd31488; a_curr_vec_in_LZ = 32'd19432;
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
      // Link 5 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 5 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-5305, 5863, 7667, 36575, 9374, -25154);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -4354, 3320, 7150, 10972, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 4610, -12747, -7214, 5786, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -1038, 2853, 1647, -564, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 48590, -137401, -65942, 23191, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 45129, -36066, -70817, -96617, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -62580, 13151, -4659, 7121, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -5945, 1309, -1513, -8879, 1237, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1314, 12420, -2697, -9465, 16, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -394, -3077, 491, 2025, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 20251, 140949, -23281, -84990, -52, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 57716, -18551, 11438, 73710, -10981, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -24770, -13522, 1380, -31010, 3378, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 7 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd49084; cosq_curr_in = -32'd43424;
      qd_curr_in = 32'd50674;
      qdd_curr_in = 32'd3416239;
      v_prev_vec_in_AX = 32'd40787; v_prev_vec_in_AY = 32'd148430; v_prev_vec_in_AZ = -32'd19503; v_prev_vec_in_LX = 32'd26833; v_prev_vec_in_LY = -32'd8629; v_prev_vec_in_LZ = 32'd5595;
      a_prev_vec_in_AX = 32'd454103; a_prev_vec_in_AY = 32'd1626815; a_prev_vec_in_AZ = 32'd6726660; a_prev_vec_in_LX = 32'd60695; a_prev_vec_in_LY = -32'd31489; a_prev_vec_in_LZ = 32'd19432;
      v_curr_vec_in_AX = 32'd12419; v_curr_vec_in_AY = 32'd43471; v_curr_vec_in_AZ = 32'd199104; v_curr_vec_in_LX = 32'd25491; v_curr_vec_in_LY = 32'd15384; v_curr_vec_in_LZ = -32'd8629;
      a_curr_vec_in_AX = 32'd5372563; a_curr_vec_in_AY = -32'd4126612; a_curr_vec_in_AZ = 32'd5043054; a_curr_vec_in_LX = -32'd266811; a_curr_vec_in_LY = -32'd419582; a_curr_vec_in_LZ = -32'd31488;
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
      // Link 6 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 6 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2203, 5901, 31413, 121437, -77713, -83897);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 284, -35, 259, 931, 8200, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -123, -73, 247, -245, -1679, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -151, 839, 24, -794, -389, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 32323, -160291, -90398, 80218, -77343, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -111482, 77173, 64413, -25932, -128801, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -49161, 46245, 109642, 145168, 1770, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 76, -2, 75, -411, 337, 906, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -36, -40, -44, 186, -85, -135, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53, -127, 123, 558, -149, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5723, 166896, -36059, -143888, 77, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -43324, -60969, 11058, -9066, -92, 42, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -94050, 24373, -36659, -120581, -164, 321, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Dummy Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 0; cosq_curr_in = 0;
      qd_curr_in = 0;
      qdd_curr_in = 0;
      v_prev_vec_in_AX = 32'd12419; v_prev_vec_in_AY = 32'd43471; v_prev_vec_in_AZ = 32'd199104; v_prev_vec_in_LX = 32'd25491; v_prev_vec_in_LY = 32'd15384; v_prev_vec_in_LZ = -32'd8629;
      a_prev_vec_in_AX = 32'd5372563; a_prev_vec_in_AY = -32'd4126612; a_prev_vec_in_AZ = 32'd5043054; a_prev_vec_in_LX = -32'd266811; a_prev_vec_in_LY = -32'd419582; a_prev_vec_in_LZ = -32'd31488;
      v_curr_vec_in_AX = 0; v_curr_vec_in_AY = 0; v_curr_vec_in_AZ = 0; v_curr_vec_in_LX = 0; v_curr_vec_in_LY = 0; v_curr_vec_in_LZ = 0;
      a_curr_vec_in_AX = 0; a_curr_vec_in_AY = 0; a_curr_vec_in_AZ = 0; a_curr_vec_in_LX = 0; a_curr_vec_in_LY = 0; a_curr_vec_in_LZ = 0;
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
      // Link 7 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 7 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",8044, -6533, 5043, -120315, -133594, -13832);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -155, 691, 463, 126, 1874, -6533);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 52, -424, 142, 895, 1840, -8044);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -3285, -13804, 6498, 35032, 34895, -133594);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 10772, -28595, -29148, -4116, -35504, 120315);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -19629, 12420, 15012, -6108, -26838, -0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -204, -355, 58, 128, 34, 184, 43);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -186, 404, -176, -786, 108, 208, -12);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10435, 23638, -7656, -37658, 3027, 6737, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 13340, 20050, 289, -5454, 998, -5960, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -8477, -12323, 1071, -549, -757, 1182, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
      //------------------------------------------------------------------------
      $display ("// Knot 8 Link 1 Init");
      //------------------------------------------------------------------------
      // Link 1 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd19197; cosq_curr_in = 32'd62661;
      qd_curr_in = 32'd65530;
      qdd_curr_in = 32'd43998;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd0; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd0; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd65530; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd43998; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
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
      // (Ignore Dummy Outputs)
      //------------------------------------------------------------------------
      // Link 2 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd24454; cosq_curr_in = 32'd60803;
      qd_curr_in = 32'd16493;
      qdd_curr_in = 32'd136669;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd65530; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd43998; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd24452; v_curr_vec_in_AY = 32'd60797; v_curr_vec_in_AZ = 32'd16493; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd31718; a_curr_vec_in_AY = 32'd34667; a_curr_vec_in_AZ = 32'd136669; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
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
      // Link 1 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 1 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-944, 634, 1038, 5280, 7863, 0);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -1887, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 15727, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 3 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd36876; cosq_curr_in = 32'd54177;
      qd_curr_in = 32'd64662;
      qdd_curr_in = -32'd60321;
      v_prev_vec_in_AX = 32'd24452; v_prev_vec_in_AY = 32'd60797; v_prev_vec_in_AZ = 32'd16493; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd31718; a_prev_vec_in_AY = 32'd34667; a_prev_vec_in_AZ = 32'd136669; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd29494; v_curr_vec_in_AY = -32'd125; v_curr_vec_in_AZ = 32'd125459; v_curr_vec_in_LX = -32'd26; v_curr_vec_in_LY = 32'd6032; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = -32'd103245; a_curr_vec_in_AY = 32'd124234; a_curr_vec_in_AZ = -32'd25654; a_curr_vec_in_LX = 32'd25406; a_curr_vec_in_LY = 32'd21114; a_curr_vec_in_LZ = 32'd0;
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
      // Link 2 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 2 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2226, -184, 6473, -20115, -5700, 54);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 2709, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -126, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2017, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 8454, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -17508, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 6786, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 469, 6644, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 375, -304, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2077, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 10572, -40, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -4252, -7785, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -14781, 28755, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 4 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd685; cosq_curr_in = 32'd65532;
      qd_curr_in = 32'd36422;
      qdd_curr_in = 32'd358153;
      v_prev_vec_in_AX = -32'd29494; v_prev_vec_in_AY = -32'd125; v_prev_vec_in_AZ = 32'd125459; v_prev_vec_in_LX = -32'd25; v_prev_vec_in_LY = 32'd6032; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = -32'd103246; a_prev_vec_in_AY = 32'd124234; a_prev_vec_in_AZ = -32'd25654; a_prev_vec_in_LX = 32'd25406; a_prev_vec_in_LY = 32'd21114; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd30803; v_curr_vec_in_AY = 32'd125144; v_curr_vec_in_AZ = 32'd36546; v_curr_vec_in_LX = -32'd52; v_curr_vec_in_LY = -32'd1; v_curr_vec_in_LZ = -32'd12388;
      a_curr_vec_in_AX = -32'd33423; a_curr_vec_in_AY = -32'd9612; a_curr_vec_in_AZ = 32'd233920; a_curr_vec_in_LX = 32'd52175; a_curr_vec_in_LY = 32'd574; a_curr_vec_in_LZ = -32'd43363;
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
      // Link 3 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 3 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-19396, 14507, -2367, 70323, 80557, -22634);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2621, 15599, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -10348, 21009, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1137, -2999, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -51071, 102173, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1313, -68019, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -57033, 16263, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1897, -19915, 2933, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10769, -13702, 147, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1521, 1936, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53805, -68646, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22821, 97882, -22583, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -23054, -23480, -22, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 5 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd48758; cosq_curr_in = 32'd43790;
      qd_curr_in = 32'd28646;
      qdd_curr_in = 32'd1694532;
      v_prev_vec_in_AX = -32'd30803; v_prev_vec_in_AY = 32'd125144; v_prev_vec_in_AZ = 32'd36546; v_prev_vec_in_LX = -32'd52; v_prev_vec_in_LY = -32'd1; v_prev_vec_in_LZ = -32'd12388;
      a_prev_vec_in_AX = -32'd33423; a_prev_vec_in_AY = -32'd9612; a_prev_vec_in_AZ = 32'd233919; a_prev_vec_in_LX = 32'd52175; a_prev_vec_in_LY = 32'd574; a_prev_vec_in_LZ = -32'd43363;
      v_curr_vec_in_AX = -32'd6608; v_curr_vec_in_AY = 32'd47337; v_curr_vec_in_AZ = 32'd153790; v_curr_vec_in_LX = 32'd17985; v_curr_vec_in_LY = -32'd7019; v_curr_vec_in_LZ = -32'd1;
      a_curr_vec_in_AX = -32'd131010; a_curr_vec_in_AY = 32'd184057; a_curr_vec_in_AZ = 32'd1684917; a_curr_vec_in_LX = 32'd27757; a_curr_vec_in_LY = -32'd47665; a_curr_vec_in_LZ = 32'd574;
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
      // Link 4 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 4 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-8244, 621, 6514, 21590, -11080, -133498);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 826, 8949, 1941, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2678, 4680, 1622, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 5904, -12157, -6891, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -76136, 136829, 35836, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -55811, -9425, -53266, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 3436, 89127, 1368, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1436, -9457, 1126, 9615, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2460, -3074, -13, 277, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5950, 7332, -181, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -73332, -89415, -473, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22838, -43368, -94, -13222, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10554, -135202, -9858, 45277, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 6 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd20062; cosq_curr_in = 32'd62390;
      qd_curr_in = 32'd27834;
      qdd_curr_in = 32'd6910717;
      v_prev_vec_in_AX = -32'd6608; v_prev_vec_in_AY = 32'd47337; v_prev_vec_in_AZ = 32'd153790; v_prev_vec_in_LX = 32'd17985; v_prev_vec_in_LY = -32'd7019; v_prev_vec_in_LZ = -32'd1;
      a_prev_vec_in_AX = -32'd131010; a_prev_vec_in_AY = 32'd184057; a_prev_vec_in_AZ = 32'd1684920; a_prev_vec_in_LX = 32'd27757; a_prev_vec_in_LY = -32'd47665; a_prev_vec_in_LZ = 32'd574;
      v_curr_vec_in_AX = 32'd40787; v_curr_vec_in_AY = 32'd148431; v_curr_vec_in_AZ = -32'd19503; v_curr_vec_in_LX = 32'd26833; v_curr_vec_in_LY = -32'd8629; v_curr_vec_in_LZ = 32'd5595;
      a_curr_vec_in_AX = 32'd454102; a_curr_vec_in_AY = 32'd1626813; a_curr_vec_in_AZ = 32'd6726681; a_curr_vec_in_LX = 32'd60695; a_curr_vec_in_LY = -32'd31488; a_curr_vec_in_LZ = 32'd19432;
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
      // Link 5 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 5 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-5305, 5863, 7667, 36575, 9374, -25154);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -4354, 3320, 7150, 10972, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 4610, -12747, -7214, 5786, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -1038, 2853, 1647, -564, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 48590, -137401, -65942, 23191, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 45129, -36066, -70817, -96617, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -62580, 13151, -4659, 7121, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -5945, 1309, -1513, -8879, 1237, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1314, 12420, -2697, -9465, 16, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -394, -3077, 491, 2025, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 20251, 140949, -23281, -84990, -52, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 57716, -18551, 11438, 73710, -10981, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -24770, -13522, 1380, -31010, 3378, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 7 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd49084; cosq_curr_in = -32'd43424;
      qd_curr_in = 32'd50674;
      qdd_curr_in = 32'd3416239;
      v_prev_vec_in_AX = 32'd40787; v_prev_vec_in_AY = 32'd148430; v_prev_vec_in_AZ = -32'd19503; v_prev_vec_in_LX = 32'd26833; v_prev_vec_in_LY = -32'd8629; v_prev_vec_in_LZ = 32'd5595;
      a_prev_vec_in_AX = 32'd454103; a_prev_vec_in_AY = 32'd1626815; a_prev_vec_in_AZ = 32'd6726660; a_prev_vec_in_LX = 32'd60695; a_prev_vec_in_LY = -32'd31489; a_prev_vec_in_LZ = 32'd19432;
      v_curr_vec_in_AX = 32'd12419; v_curr_vec_in_AY = 32'd43471; v_curr_vec_in_AZ = 32'd199104; v_curr_vec_in_LX = 32'd25491; v_curr_vec_in_LY = 32'd15384; v_curr_vec_in_LZ = -32'd8629;
      a_curr_vec_in_AX = 32'd5372563; a_curr_vec_in_AY = -32'd4126612; a_curr_vec_in_AZ = 32'd5043054; a_curr_vec_in_LX = -32'd266811; a_curr_vec_in_LY = -32'd419582; a_curr_vec_in_LZ = -32'd31488;
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
      // Link 6 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 6 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2203, 5901, 31413, 121437, -77713, -83897);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 284, -35, 259, 931, 8200, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -123, -73, 247, -245, -1679, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -151, 839, 24, -794, -389, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 32323, -160291, -90398, 80218, -77343, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -111482, 77173, 64413, -25932, -128801, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -49161, 46245, 109642, 145168, 1770, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 76, -2, 75, -411, 337, 906, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -36, -40, -44, 186, -85, -135, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53, -127, 123, 558, -149, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5723, 166896, -36059, -143888, 77, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -43324, -60969, 11058, -9066, -92, 42, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -94050, 24373, -36659, -120581, -164, 321, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Dummy Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 0; cosq_curr_in = 0;
      qd_curr_in = 0;
      qdd_curr_in = 0;
      v_prev_vec_in_AX = 32'd12419; v_prev_vec_in_AY = 32'd43471; v_prev_vec_in_AZ = 32'd199104; v_prev_vec_in_LX = 32'd25491; v_prev_vec_in_LY = 32'd15384; v_prev_vec_in_LZ = -32'd8629;
      a_prev_vec_in_AX = 32'd5372563; a_prev_vec_in_AY = -32'd4126612; a_prev_vec_in_AZ = 32'd5043054; a_prev_vec_in_LX = -32'd266811; a_prev_vec_in_LY = -32'd419582; a_prev_vec_in_LZ = -32'd31488;
      v_curr_vec_in_AX = 0; v_curr_vec_in_AY = 0; v_curr_vec_in_AZ = 0; v_curr_vec_in_LX = 0; v_curr_vec_in_LY = 0; v_curr_vec_in_LZ = 0;
      a_curr_vec_in_AX = 0; a_curr_vec_in_AY = 0; a_curr_vec_in_AZ = 0; a_curr_vec_in_LX = 0; a_curr_vec_in_LY = 0; a_curr_vec_in_LZ = 0;
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
      // Link 7 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 7 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",8044, -6533, 5043, -120315, -133594, -13832);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -155, 691, 463, 126, 1874, -6533);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 52, -424, 142, 895, 1840, -8044);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -3285, -13804, 6498, 35032, 34895, -133594);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 10772, -28595, -29148, -4116, -35504, 120315);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -19629, 12420, 15012, -6108, -26838, -0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -204, -355, 58, 128, 34, 184, 43);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -186, 404, -176, -786, 108, 208, -12);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10435, 23638, -7656, -37658, 3027, 6737, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 13340, 20050, 289, -5454, 998, -5960, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -8477, -12323, 1071, -549, -757, 1182, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
      //------------------------------------------------------------------------
      $display ("// Knot 9 Link 1 Init");
      //------------------------------------------------------------------------
      // Link 1 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd19197; cosq_curr_in = 32'd62661;
      qd_curr_in = 32'd65530;
      qdd_curr_in = 32'd43998;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd0; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd0; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd65530; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd43998; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
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
      // (Ignore Dummy Outputs)
      //------------------------------------------------------------------------
      // Link 2 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd24454; cosq_curr_in = 32'd60803;
      qd_curr_in = 32'd16493;
      qdd_curr_in = 32'd136669;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd65530; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd43998; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd24452; v_curr_vec_in_AY = 32'd60797; v_curr_vec_in_AZ = 32'd16493; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd31718; a_curr_vec_in_AY = 32'd34667; a_curr_vec_in_AZ = 32'd136669; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
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
      // Link 1 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 1 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-944, 634, 1038, 5280, 7863, 0);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -1887, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 15727, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 3 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd36876; cosq_curr_in = 32'd54177;
      qd_curr_in = 32'd64662;
      qdd_curr_in = -32'd60321;
      v_prev_vec_in_AX = 32'd24452; v_prev_vec_in_AY = 32'd60797; v_prev_vec_in_AZ = 32'd16493; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd31718; a_prev_vec_in_AY = 32'd34667; a_prev_vec_in_AZ = 32'd136669; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd29494; v_curr_vec_in_AY = -32'd125; v_curr_vec_in_AZ = 32'd125459; v_curr_vec_in_LX = -32'd26; v_curr_vec_in_LY = 32'd6032; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = -32'd103245; a_curr_vec_in_AY = 32'd124234; a_curr_vec_in_AZ = -32'd25654; a_curr_vec_in_LX = 32'd25406; a_curr_vec_in_LY = 32'd21114; a_curr_vec_in_LZ = 32'd0;
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
      // Link 2 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 2 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2226, -184, 6473, -20115, -5700, 54);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 2709, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -126, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2017, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 8454, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -17508, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 6786, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 469, 6644, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 375, -304, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2077, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 10572, -40, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -4252, -7785, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -14781, 28755, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 4 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd685; cosq_curr_in = 32'd65532;
      qd_curr_in = 32'd36422;
      qdd_curr_in = 32'd358153;
      v_prev_vec_in_AX = -32'd29494; v_prev_vec_in_AY = -32'd125; v_prev_vec_in_AZ = 32'd125459; v_prev_vec_in_LX = -32'd25; v_prev_vec_in_LY = 32'd6032; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = -32'd103246; a_prev_vec_in_AY = 32'd124234; a_prev_vec_in_AZ = -32'd25654; a_prev_vec_in_LX = 32'd25406; a_prev_vec_in_LY = 32'd21114; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd30803; v_curr_vec_in_AY = 32'd125144; v_curr_vec_in_AZ = 32'd36546; v_curr_vec_in_LX = -32'd52; v_curr_vec_in_LY = -32'd1; v_curr_vec_in_LZ = -32'd12388;
      a_curr_vec_in_AX = -32'd33423; a_curr_vec_in_AY = -32'd9612; a_curr_vec_in_AZ = 32'd233920; a_curr_vec_in_LX = 32'd52175; a_curr_vec_in_LY = 32'd574; a_curr_vec_in_LZ = -32'd43363;
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
      // Link 3 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 3 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-19396, 14507, -2367, 70323, 80557, -22634);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2621, 15599, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -10348, 21009, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1137, -2999, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -51071, 102173, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1313, -68019, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -57033, 16263, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1897, -19915, 2933, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10769, -13702, 147, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1521, 1936, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53805, -68646, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22821, 97882, -22583, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -23054, -23480, -22, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 5 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd48758; cosq_curr_in = 32'd43790;
      qd_curr_in = 32'd28646;
      qdd_curr_in = 32'd1694532;
      v_prev_vec_in_AX = -32'd30803; v_prev_vec_in_AY = 32'd125144; v_prev_vec_in_AZ = 32'd36546; v_prev_vec_in_LX = -32'd52; v_prev_vec_in_LY = -32'd1; v_prev_vec_in_LZ = -32'd12388;
      a_prev_vec_in_AX = -32'd33423; a_prev_vec_in_AY = -32'd9612; a_prev_vec_in_AZ = 32'd233919; a_prev_vec_in_LX = 32'd52175; a_prev_vec_in_LY = 32'd574; a_prev_vec_in_LZ = -32'd43363;
      v_curr_vec_in_AX = -32'd6608; v_curr_vec_in_AY = 32'd47337; v_curr_vec_in_AZ = 32'd153790; v_curr_vec_in_LX = 32'd17985; v_curr_vec_in_LY = -32'd7019; v_curr_vec_in_LZ = -32'd1;
      a_curr_vec_in_AX = -32'd131010; a_curr_vec_in_AY = 32'd184057; a_curr_vec_in_AZ = 32'd1684917; a_curr_vec_in_LX = 32'd27757; a_curr_vec_in_LY = -32'd47665; a_curr_vec_in_LZ = 32'd574;
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
      // Link 4 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 4 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-8244, 621, 6514, 21590, -11080, -133498);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 826, 8949, 1941, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2678, 4680, 1622, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 5904, -12157, -6891, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -76136, 136829, 35836, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -55811, -9425, -53266, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 3436, 89127, 1368, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1436, -9457, 1126, 9615, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2460, -3074, -13, 277, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5950, 7332, -181, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -73332, -89415, -473, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22838, -43368, -94, -13222, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10554, -135202, -9858, 45277, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 6 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd20062; cosq_curr_in = 32'd62390;
      qd_curr_in = 32'd27834;
      qdd_curr_in = 32'd6910717;
      v_prev_vec_in_AX = -32'd6608; v_prev_vec_in_AY = 32'd47337; v_prev_vec_in_AZ = 32'd153790; v_prev_vec_in_LX = 32'd17985; v_prev_vec_in_LY = -32'd7019; v_prev_vec_in_LZ = -32'd1;
      a_prev_vec_in_AX = -32'd131010; a_prev_vec_in_AY = 32'd184057; a_prev_vec_in_AZ = 32'd1684920; a_prev_vec_in_LX = 32'd27757; a_prev_vec_in_LY = -32'd47665; a_prev_vec_in_LZ = 32'd574;
      v_curr_vec_in_AX = 32'd40787; v_curr_vec_in_AY = 32'd148431; v_curr_vec_in_AZ = -32'd19503; v_curr_vec_in_LX = 32'd26833; v_curr_vec_in_LY = -32'd8629; v_curr_vec_in_LZ = 32'd5595;
      a_curr_vec_in_AX = 32'd454102; a_curr_vec_in_AY = 32'd1626813; a_curr_vec_in_AZ = 32'd6726681; a_curr_vec_in_LX = 32'd60695; a_curr_vec_in_LY = -32'd31488; a_curr_vec_in_LZ = 32'd19432;
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
      // Link 5 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 5 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-5305, 5863, 7667, 36575, 9374, -25154);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -4354, 3320, 7150, 10972, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 4610, -12747, -7214, 5786, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -1038, 2853, 1647, -564, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 48590, -137401, -65942, 23191, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 45129, -36066, -70817, -96617, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -62580, 13151, -4659, 7121, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -5945, 1309, -1513, -8879, 1237, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1314, 12420, -2697, -9465, 16, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -394, -3077, 491, 2025, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 20251, 140949, -23281, -84990, -52, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 57716, -18551, 11438, 73710, -10981, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -24770, -13522, 1380, -31010, 3378, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 7 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd49084; cosq_curr_in = -32'd43424;
      qd_curr_in = 32'd50674;
      qdd_curr_in = 32'd3416239;
      v_prev_vec_in_AX = 32'd40787; v_prev_vec_in_AY = 32'd148430; v_prev_vec_in_AZ = -32'd19503; v_prev_vec_in_LX = 32'd26833; v_prev_vec_in_LY = -32'd8629; v_prev_vec_in_LZ = 32'd5595;
      a_prev_vec_in_AX = 32'd454103; a_prev_vec_in_AY = 32'd1626815; a_prev_vec_in_AZ = 32'd6726660; a_prev_vec_in_LX = 32'd60695; a_prev_vec_in_LY = -32'd31489; a_prev_vec_in_LZ = 32'd19432;
      v_curr_vec_in_AX = 32'd12419; v_curr_vec_in_AY = 32'd43471; v_curr_vec_in_AZ = 32'd199104; v_curr_vec_in_LX = 32'd25491; v_curr_vec_in_LY = 32'd15384; v_curr_vec_in_LZ = -32'd8629;
      a_curr_vec_in_AX = 32'd5372563; a_curr_vec_in_AY = -32'd4126612; a_curr_vec_in_AZ = 32'd5043054; a_curr_vec_in_LX = -32'd266811; a_curr_vec_in_LY = -32'd419582; a_curr_vec_in_LZ = -32'd31488;
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
      // Link 6 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 6 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2203, 5901, 31413, 121437, -77713, -83897);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 284, -35, 259, 931, 8200, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -123, -73, 247, -245, -1679, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -151, 839, 24, -794, -389, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 32323, -160291, -90398, 80218, -77343, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -111482, 77173, 64413, -25932, -128801, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -49161, 46245, 109642, 145168, 1770, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 76, -2, 75, -411, 337, 906, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -36, -40, -44, 186, -85, -135, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53, -127, 123, 558, -149, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5723, 166896, -36059, -143888, 77, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -43324, -60969, 11058, -9066, -92, 42, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -94050, 24373, -36659, -120581, -164, 321, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Dummy Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 0; cosq_curr_in = 0;
      qd_curr_in = 0;
      qdd_curr_in = 0;
      v_prev_vec_in_AX = 32'd12419; v_prev_vec_in_AY = 32'd43471; v_prev_vec_in_AZ = 32'd199104; v_prev_vec_in_LX = 32'd25491; v_prev_vec_in_LY = 32'd15384; v_prev_vec_in_LZ = -32'd8629;
      a_prev_vec_in_AX = 32'd5372563; a_prev_vec_in_AY = -32'd4126612; a_prev_vec_in_AZ = 32'd5043054; a_prev_vec_in_LX = -32'd266811; a_prev_vec_in_LY = -32'd419582; a_prev_vec_in_LZ = -32'd31488;
      v_curr_vec_in_AX = 0; v_curr_vec_in_AY = 0; v_curr_vec_in_AZ = 0; v_curr_vec_in_LX = 0; v_curr_vec_in_LY = 0; v_curr_vec_in_LZ = 0;
      a_curr_vec_in_AX = 0; a_curr_vec_in_AY = 0; a_curr_vec_in_AZ = 0; a_curr_vec_in_LX = 0; a_curr_vec_in_LY = 0; a_curr_vec_in_LZ = 0;
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
      // Link 7 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 7 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",8044, -6533, 5043, -120315, -133594, -13832);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -155, 691, 463, 126, 1874, -6533);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 52, -424, 142, 895, 1840, -8044);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -3285, -13804, 6498, 35032, 34895, -133594);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 10772, -28595, -29148, -4116, -35504, 120315);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -19629, 12420, 15012, -6108, -26838, -0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -204, -355, 58, 128, 34, 184, 43);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -186, 404, -176, -786, 108, 208, -12);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10435, 23638, -7656, -37658, 3027, 6737, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 13340, 20050, 289, -5454, 998, -5960, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -8477, -12323, 1071, -549, -757, 1182, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
      //------------------------------------------------------------------------
      $display ("// Knot 10 Link 1 Init");
      //------------------------------------------------------------------------
      // Link 1 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd19197; cosq_curr_in = 32'd62661;
      qd_curr_in = 32'd65530;
      qdd_curr_in = 32'd43998;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd0; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd0; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd0; v_curr_vec_in_AY = 32'd0; v_curr_vec_in_AZ = 32'd65530; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd0; a_curr_vec_in_AY = 32'd0; a_curr_vec_in_AZ = 32'd43998; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
      //------------------------------------------------------------------------
// // //       // Insert extra delay cycles
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
// // //       get_data = 0;
// // //       clk = 1;
// // //       #5;
// // //       clk = 0;
// // //       #5;
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
      // (Ignore Dummy Outputs)
      //------------------------------------------------------------------------
      // Link 2 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd24454; cosq_curr_in = 32'd60803;
      qd_curr_in = 32'd16493;
      qdd_curr_in = 32'd136669;
      v_prev_vec_in_AX = 32'd0; v_prev_vec_in_AY = 32'd0; v_prev_vec_in_AZ = 32'd65530; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd0; a_prev_vec_in_AY = 32'd0; a_prev_vec_in_AZ = 32'd43998; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = 32'd24452; v_curr_vec_in_AY = 32'd60797; v_curr_vec_in_AZ = 32'd16493; v_curr_vec_in_LX = 32'd0; v_curr_vec_in_LY = 32'd0; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = 32'd31718; a_curr_vec_in_AY = 32'd34667; a_curr_vec_in_AZ = 32'd136669; a_curr_vec_in_LX = 32'd0; a_curr_vec_in_LY = 32'd0; a_curr_vec_in_LZ = 32'd0;
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
      // Link 1 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 1 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-944, 634, 1038, 5280, 7863, 0);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -1887, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 15727, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 3 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd36876; cosq_curr_in = 32'd54177;
      qd_curr_in = 32'd64662;
      qdd_curr_in = -32'd60321;
      v_prev_vec_in_AX = 32'd24452; v_prev_vec_in_AY = 32'd60797; v_prev_vec_in_AZ = 32'd16493; v_prev_vec_in_LX = 32'd0; v_prev_vec_in_LY = 32'd0; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = 32'd31718; a_prev_vec_in_AY = 32'd34667; a_prev_vec_in_AZ = 32'd136669; a_prev_vec_in_LX = 32'd0; a_prev_vec_in_LY = 32'd0; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd29494; v_curr_vec_in_AY = -32'd125; v_curr_vec_in_AZ = 32'd125459; v_curr_vec_in_LX = -32'd26; v_curr_vec_in_LY = 32'd6032; v_curr_vec_in_LZ = 32'd0;
      a_curr_vec_in_AX = -32'd103245; a_curr_vec_in_AY = 32'd124234; a_curr_vec_in_AZ = -32'd25654; a_curr_vec_in_LX = 32'd25406; a_curr_vec_in_LY = 32'd21114; a_curr_vec_in_LZ = 32'd0;
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
      // Link 2 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 2 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2226, -184, 6473, -20115, -5700, 54);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 2709, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -126, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2017, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 8454, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -17508, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 6786, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 469, 6644, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 375, -304, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2077, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 10572, -40, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -4252, -7785, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -14781, 28755, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 4 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd685; cosq_curr_in = 32'd65532;
      qd_curr_in = 32'd36422;
      qdd_curr_in = 32'd358153;
      v_prev_vec_in_AX = -32'd29494; v_prev_vec_in_AY = -32'd125; v_prev_vec_in_AZ = 32'd125459; v_prev_vec_in_LX = -32'd25; v_prev_vec_in_LY = 32'd6032; v_prev_vec_in_LZ = 32'd0;
      a_prev_vec_in_AX = -32'd103246; a_prev_vec_in_AY = 32'd124234; a_prev_vec_in_AZ = -32'd25654; a_prev_vec_in_LX = 32'd25406; a_prev_vec_in_LY = 32'd21114; a_prev_vec_in_LZ = 32'd0;
      v_curr_vec_in_AX = -32'd30803; v_curr_vec_in_AY = 32'd125144; v_curr_vec_in_AZ = 32'd36546; v_curr_vec_in_LX = -32'd52; v_curr_vec_in_LY = -32'd1; v_curr_vec_in_LZ = -32'd12388;
      a_curr_vec_in_AX = -32'd33423; a_curr_vec_in_AY = -32'd9612; a_curr_vec_in_AZ = 32'd233920; a_curr_vec_in_LX = 32'd52175; a_curr_vec_in_LY = 32'd574; a_curr_vec_in_LZ = -32'd43363;
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
      // Link 3 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 3 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-19396, 14507, -2367, 70323, 80557, -22634);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2621, 15599, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -10348, 21009, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1137, -2999, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -51071, 102173, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1313, -68019, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -57033, 16263, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1897, -19915, 2933, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10769, -13702, 147, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1521, 1936, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53805, -68646, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22821, 97882, -22583, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -23054, -23480, -22, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 5 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = -32'd48758; cosq_curr_in = 32'd43790;
      qd_curr_in = 32'd28646;
      qdd_curr_in = 32'd1694532;
      v_prev_vec_in_AX = -32'd30803; v_prev_vec_in_AY = 32'd125144; v_prev_vec_in_AZ = 32'd36546; v_prev_vec_in_LX = -32'd52; v_prev_vec_in_LY = -32'd1; v_prev_vec_in_LZ = -32'd12388;
      a_prev_vec_in_AX = -32'd33423; a_prev_vec_in_AY = -32'd9612; a_prev_vec_in_AZ = 32'd233919; a_prev_vec_in_LX = 32'd52175; a_prev_vec_in_LY = 32'd574; a_prev_vec_in_LZ = -32'd43363;
      v_curr_vec_in_AX = -32'd6608; v_curr_vec_in_AY = 32'd47337; v_curr_vec_in_AZ = 32'd153790; v_curr_vec_in_LX = 32'd17985; v_curr_vec_in_LY = -32'd7019; v_curr_vec_in_LZ = -32'd1;
      a_curr_vec_in_AX = -32'd131010; a_curr_vec_in_AY = 32'd184057; a_curr_vec_in_AZ = 32'd1684917; a_curr_vec_in_LX = 32'd27757; a_curr_vec_in_LY = -32'd47665; a_curr_vec_in_LZ = 32'd574;
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
      // Link 4 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 4 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-8244, 621, 6514, 21590, -11080, -133498);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 826, 8949, 1941, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2678, 4680, 1622, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 5904, -12157, -6891, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -76136, 136829, 35836, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -55811, -9425, -53266, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 3436, 89127, 1368, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1436, -9457, 1126, 9615, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2460, -3074, -13, 277, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5950, 7332, -181, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -73332, -89415, -473, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22838, -43368, -94, -13222, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10554, -135202, -9858, 45277, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 6 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd20062; cosq_curr_in = 32'd62390;
      qd_curr_in = 32'd27834;
      qdd_curr_in = 32'd6910717;
      v_prev_vec_in_AX = -32'd6608; v_prev_vec_in_AY = 32'd47337; v_prev_vec_in_AZ = 32'd153790; v_prev_vec_in_LX = 32'd17985; v_prev_vec_in_LY = -32'd7019; v_prev_vec_in_LZ = -32'd1;
      a_prev_vec_in_AX = -32'd131010; a_prev_vec_in_AY = 32'd184057; a_prev_vec_in_AZ = 32'd1684920; a_prev_vec_in_LX = 32'd27757; a_prev_vec_in_LY = -32'd47665; a_prev_vec_in_LZ = 32'd574;
      v_curr_vec_in_AX = 32'd40787; v_curr_vec_in_AY = 32'd148431; v_curr_vec_in_AZ = -32'd19503; v_curr_vec_in_LX = 32'd26833; v_curr_vec_in_LY = -32'd8629; v_curr_vec_in_LZ = 32'd5595;
      a_curr_vec_in_AX = 32'd454102; a_curr_vec_in_AY = 32'd1626813; a_curr_vec_in_AZ = 32'd6726681; a_curr_vec_in_LX = 32'd60695; a_curr_vec_in_LY = -32'd31488; a_curr_vec_in_LZ = 32'd19432;
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
      // Link 5 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 5 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-5305, 5863, 7667, 36575, 9374, -25154);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -4354, 3320, 7150, 10972, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 4610, -12747, -7214, 5786, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -1038, 2853, 1647, -564, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 48590, -137401, -65942, 23191, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 45129, -36066, -70817, -96617, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -62580, 13151, -4659, 7121, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -5945, 1309, -1513, -8879, 1237, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1314, 12420, -2697, -9465, 16, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -394, -3077, 491, 2025, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 20251, 140949, -23281, -84990, -52, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 57716, -18551, 11438, 73710, -10981, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -24770, -13522, 1380, -31010, 3378, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 7 Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 32'd49084; cosq_curr_in = -32'd43424;
      qd_curr_in = 32'd50674;
      qdd_curr_in = 32'd3416239;
      v_prev_vec_in_AX = 32'd40787; v_prev_vec_in_AY = 32'd148430; v_prev_vec_in_AZ = -32'd19503; v_prev_vec_in_LX = 32'd26833; v_prev_vec_in_LY = -32'd8629; v_prev_vec_in_LZ = 32'd5595;
      a_prev_vec_in_AX = 32'd454103; a_prev_vec_in_AY = 32'd1626815; a_prev_vec_in_AZ = 32'd6726660; a_prev_vec_in_LX = 32'd60695; a_prev_vec_in_LY = -32'd31489; a_prev_vec_in_LZ = 32'd19432;
      v_curr_vec_in_AX = 32'd12419; v_curr_vec_in_AY = 32'd43471; v_curr_vec_in_AZ = 32'd199104; v_curr_vec_in_LX = 32'd25491; v_curr_vec_in_LY = 32'd15384; v_curr_vec_in_LZ = -32'd8629;
      a_curr_vec_in_AX = 32'd5372563; a_curr_vec_in_AY = -32'd4126612; a_curr_vec_in_AZ = 32'd5043054; a_curr_vec_in_LX = -32'd266811; a_curr_vec_in_LY = -32'd419582; a_curr_vec_in_LZ = -32'd31488;
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
      // Link 6 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 6 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2203, 5901, 31413, 121437, -77713, -83897);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 284, -35, 259, 931, 8200, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -123, -73, 247, -245, -1679, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -151, 839, 24, -794, -389, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 32323, -160291, -90398, 80218, -77343, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -111482, 77173, 64413, -25932, -128801, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -49161, 46245, 109642, 145168, 1770, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 76, -2, 75, -411, 337, 906, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -36, -40, -44, 186, -85, -135, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53, -127, 123, 558, -149, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5723, 166896, -36059, -143888, 77, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -43324, -60969, 11058, -9066, -92, 42, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -94050, 24373, -36659, -120581, -164, 321, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Dummy Inputs
      //------------------------------------------------------------------------
      sinq_curr_in = 0; cosq_curr_in = 0;
      qd_curr_in = 0;
      qdd_curr_in = 0;
      v_prev_vec_in_AX = 32'd12419; v_prev_vec_in_AY = 32'd43471; v_prev_vec_in_AZ = 32'd199104; v_prev_vec_in_LX = 32'd25491; v_prev_vec_in_LY = 32'd15384; v_prev_vec_in_LZ = -32'd8629;
      a_prev_vec_in_AX = 32'd5372563; a_prev_vec_in_AY = -32'd4126612; a_prev_vec_in_AZ = 32'd5043054; a_prev_vec_in_LX = -32'd266811; a_prev_vec_in_LY = -32'd419582; a_prev_vec_in_LZ = -32'd31488;
      v_curr_vec_in_AX = 0; v_curr_vec_in_AY = 0; v_curr_vec_in_AZ = 0; v_curr_vec_in_LX = 0; v_curr_vec_in_LY = 0; v_curr_vec_in_LZ = 0;
      a_curr_vec_in_AX = 0; a_curr_vec_in_AY = 0; a_curr_vec_in_AZ = 0; a_curr_vec_in_LX = 0; a_curr_vec_in_LY = 0; a_curr_vec_in_LZ = 0;
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
      // Link 7 Outputs
      //------------------------------------------------------------------------
      $display ("// Link 7 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",8044, -6533, 5043, -120315, -133594, -13832);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_prev_vec_out_AX,f_prev_vec_out_AY,f_prev_vec_out_AZ,f_prev_vec_out_LX,f_prev_vec_out_LY,f_prev_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -155, 691, 463, 126, 1874, -6533);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 52, -424, 142, 895, 1840, -8044);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -3285, -13804, 6498, 35032, 34895, -133594);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 10772, -28595, -29148, -4116, -35504, 120315);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -19629, 12420, 15012, -6108, -26838, -0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -204, -355, 58, 128, 34, 184, 43);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -186, 404, -176, -786, 108, 208, -12);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10435, 23638, -7656, -37658, 3027, 6737, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 13340, 20050, 289, -5454, 998, -5960, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -8477, -12323, 1071, -549, -757, 1182, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      #1000;
      $stop;
   end

endmodule
