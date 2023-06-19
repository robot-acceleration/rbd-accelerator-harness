`timescale 1ns / 1ps

// Testbench for RNEA for Link i

//------------------------------------------------------------------------------
// rneafpx Testbench
//------------------------------------------------------------------------------
module tb_rneafpx();

   parameter WIDTH = 32;
   parameter DECIMAL_BITS = 16;

   // clock
   reg  clk;
   // stage booleans
   reg
      s1_bool_in,s2_bool_in,s3_bool_in;
   // link_in
   reg  [3:0]
      link_in;
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
   // v_curr_vec_out, 6 values
   wire signed[(WIDTH-1):0]
      v_curr_vec_out_AX,v_curr_vec_out_AY,v_curr_vec_out_AZ,v_curr_vec_out_LX,v_curr_vec_out_LY,v_curr_vec_out_LZ;
   // a_curr_vec_out, 6 values
   wire signed[(WIDTH-1):0]
      a_curr_vec_out_AX,a_curr_vec_out_AY,a_curr_vec_out_AZ,a_curr_vec_out_LX,a_curr_vec_out_LY,a_curr_vec_out_LZ;
   // f_curr_vec_out, 6 values
   wire signed[(WIDTH-1):0]
      f_curr_vec_out_AX,f_curr_vec_out_AY,f_curr_vec_out_AZ,f_curr_vec_out_LX,f_curr_vec_out_LY,f_curr_vec_out_LZ;

   rneafpx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut(
      // clock
      .clk(clk),
      // stage booleans
      .s1_bool_in(s1_bool_in),.s2_bool_in(s2_bool_in),.s3_bool_in(s3_bool_in),
      // link_in
      .link_in(link_in),
      // sin(q) and cos(q)
      .sinq_curr_in(sinq_curr_in),.cosq_curr_in(cosq_curr_in),
      // qd_curr_in
      .qd_curr_in(qd_curr_in),
      // qdd_curr_in
      .qdd_curr_in(qdd_curr_in),
      // v_prev_vec_in, 6 values
      .v_prev_vec_in_AX(v_prev_vec_in_AX),.v_prev_vec_in_AY(v_prev_vec_in_AY),.v_prev_vec_in_AZ(v_prev_vec_in_AZ),.v_prev_vec_in_LX(v_prev_vec_in_LX),.v_prev_vec_in_LY(v_prev_vec_in_LY),.v_prev_vec_in_LZ(v_prev_vec_in_LZ),
      // a_prev_vec_in, 6 values
      .a_prev_vec_in_AX(a_prev_vec_in_AX),.a_prev_vec_in_AY(a_prev_vec_in_AY),.a_prev_vec_in_AZ(a_prev_vec_in_AZ),.a_prev_vec_in_LX(a_prev_vec_in_LX),.a_prev_vec_in_LY(a_prev_vec_in_LY),.a_prev_vec_in_LZ(a_prev_vec_in_LZ),
      // v_curr_vec_out, 6 values
      .v_curr_vec_out_AX(v_curr_vec_out_AX),.v_curr_vec_out_AY(v_curr_vec_out_AY),.v_curr_vec_out_AZ(v_curr_vec_out_AZ),.v_curr_vec_out_LX(v_curr_vec_out_LX),.v_curr_vec_out_LY(v_curr_vec_out_LY),.v_curr_vec_out_LZ(v_curr_vec_out_LZ),
      // a_curr_vec_out, 6 values
      .a_curr_vec_out_AX(a_curr_vec_out_AX),.a_curr_vec_out_AY(a_curr_vec_out_AY),.a_curr_vec_out_AZ(a_curr_vec_out_AZ),.a_curr_vec_out_LX(a_curr_vec_out_LX),.a_curr_vec_out_LY(a_curr_vec_out_LY),.a_curr_vec_out_LZ(a_curr_vec_out_LZ),
      // f_curr_vec_out, 6 values
      .f_curr_vec_out_AX(f_curr_vec_out_AX),.f_curr_vec_out_AY(f_curr_vec_out_AY),.f_curr_vec_out_AZ(f_curr_vec_out_AZ),.f_curr_vec_out_LX(f_curr_vec_out_LX),.f_curr_vec_out_LY(f_curr_vec_out_LY),.f_curr_vec_out_LZ(f_curr_vec_out_LZ)
      );

   initial begin
      #10;
      // initialize
      clk = 0;
      s1_bool_in = 0; s2_bool_in = 0; s3_bool_in = 0;
      link_in = 0;
      sinq_curr_in = 0; cosq_curr_in = 0;
      qd_curr_in = 0;
      qdd_curr_in = 0;
      v_prev_vec_in_AX = 0; v_prev_vec_in_AY = 0; v_prev_vec_in_AZ = 0; v_prev_vec_in_LX = 0; v_prev_vec_in_LY = 0; v_prev_vec_in_LZ = 0; 
      a_prev_vec_in_AX = 0; a_prev_vec_in_AY = 0; a_prev_vec_in_AZ = 0; a_prev_vec_in_LX = 0; a_prev_vec_in_LY = 0; a_prev_vec_in_LZ = 0; 
      #10;
      // set values
      // -----------------------------------------------------------------------
      $display ("// Link 1 Test");
      //------------------------------------------------------------------------
      // Link 1 Inputs
      link_in = 4'd1;
      sinq_curr_in = -32'd21664; cosq_curr_in = 32'd61852;
      qd_curr_in = 32'd28378;
      qdd_curr_in = 32'd343436;
      v_prev_vec_in_AX = 32'd47245; v_prev_vec_in_AY = 32'd58964; v_prev_vec_in_AZ = 32'd111335; v_prev_vec_in_LX = 32'd9451; v_prev_vec_in_LY = -32'd23416; v_prev_vec_in_LZ = 32'd35799; 
      a_prev_vec_in_AX = -32'd9836937; a_prev_vec_in_AY = 32'd909126; a_prev_vec_in_AZ = -32'd9139512; a_prev_vec_in_LX = 32'd98580; a_prev_vec_in_LY = 32'd762237; a_prev_vec_in_LZ = -32'd507129; 
      //------------------------------------------------------------------------
      // Clock and Control Inputs
      s1_bool_in = 1; s2_bool_in = 0; s3_bool_in = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      s1_bool_in = 0; s2_bool_in = 1; s3_bool_in = 0;
      clk = 1;
      #5;
      clk = 0;
      #5;
      s1_bool_in = 0; s2_bool_in = 0; s3_bool_in = 1;
      clk = 1;
      #5;
      clk = 0;
      #10;
      //------------------------------------------------------------------------
      // Compare Outputs
      $display ("//-------------------------------------------------------------------------------------------------------");
      $display ("v_curr_ref = %d,%d,%d,%d,%d,%d",32'd0, 32'd0, 32'd28378, 32'd0, 32'd0, 32'd0);
      $display ("v_curr_out = %d,%d,%d,%d,%d,%d", v_curr_vec_out_AX,v_curr_vec_out_AY,v_curr_vec_out_AZ,v_curr_vec_out_LX,v_curr_vec_out_LY,v_curr_vec_out_LZ);
      $display ("a_curr_ref = %d,%d,%d,%d,%d,%d",32'd0, 32'd0, 32'd343436, 32'd0, 32'd0, 32'd0);
      $display ("a_curr_out = %d,%d,%d,%d,%d,%d", a_curr_vec_out_AX,a_curr_vec_out_AY,a_curr_vec_out_AZ,a_curr_vec_out_LX,a_curr_vec_out_LY,a_curr_vec_out_LZ);
      $display ("f_curr_ref = %d,%d,%d,%d,%d,%d",-32'd177, 32'd4945, 32'd8105, 32'd41212, 32'd1475, 32'd0);
      $display ("f_curr_out = %d,%d,%d,%d,%d,%d", f_curr_vec_out_AX,f_curr_vec_out_AY,f_curr_vec_out_AZ,f_curr_vec_out_LX,f_curr_vec_out_LY,f_curr_vec_out_LZ);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // -----------------------------------------------------------------------
      #100;
      $stop;
   end

endmodule
