`timescale 1ns / 1ps

// RNEA for Link i

//------------------------------------------------------------------------------
// rneafpx Module
//------------------------------------------------------------------------------
module rneafpx#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // clock
   input  clk,
   // stage booleans
   input
      s1_bool_in,s2_bool_in,s3_bool_in,
   // link_in
   input  [2:0]
      link_in,
   // sin(q) and cos(q)
   input  signed[(WIDTH-1):0]
      sinq_curr_in,cosq_curr_in,
   // qd_curr_in
   input  signed[(WIDTH-1):0]
      qd_curr_in,
   // qdd_curr_in
   input  signed[(WIDTH-1):0]
      qdd_curr_in,
   // v_prev_vec_in, 6 values
   input  signed[(WIDTH-1):0]
      v_prev_vec_in_AX,v_prev_vec_in_AY,v_prev_vec_in_AZ,v_prev_vec_in_LX,v_prev_vec_in_LY,v_prev_vec_in_LZ,
   // a_prev_vec_in, 6 values
   input  signed[(WIDTH-1):0]
      a_prev_vec_in_AX,a_prev_vec_in_AY,a_prev_vec_in_AZ,a_prev_vec_in_LX,a_prev_vec_in_LY,a_prev_vec_in_LZ,
   // v_curr_vec_out, 6 values
   output signed[(WIDTH-1):0]
      v_curr_vec_out_AX,v_curr_vec_out_AY,v_curr_vec_out_AZ,v_curr_vec_out_LX,v_curr_vec_out_LY,v_curr_vec_out_LZ,
   // a_curr_vec_out, 6 values
   output signed[(WIDTH-1):0]
      a_curr_vec_out_AX,a_curr_vec_out_AY,a_curr_vec_out_AZ,a_curr_vec_out_LX,a_curr_vec_out_LY,a_curr_vec_out_LZ,
   // f_curr_vec_out, 6 values
   output signed[(WIDTH-1):0]
      f_curr_vec_out_AX,f_curr_vec_out_AY,f_curr_vec_out_AZ,f_curr_vec_out_LX,f_curr_vec_out_LY,f_curr_vec_out_LZ
   );

   //---------------------------------------------------------------------------
   // internal wires and state
   //---------------------------------------------------------------------------
   // control inputs
   wire
      s1_bool,s2_bool,s3_bool;
   // stage 1 inputs
   wire signed[(WIDTH-1):0]
      sinq_in,cosq_in;
   wire signed[(WIDTH-1):0]
      s1r2_in_AX,s1r2_in_AY,s1r2_in_AZ,s1r2_in_LX,s1r2_in_LY,s1r2_in_LZ,
      s1r3_in,
      s1r4_in_AX,s1r4_in_AY,s1r4_in_AZ,s1r4_in_LX,s1r4_in_LY,s1r4_in_LZ,
      s1r5_in;
   // stage 2&3 xform inputs
   reg signed[(WIDTH-1):0]
      xform_in_AX_AX,xform_in_AX_AY,xform_in_AX_AZ,
      xform_in_AY_AX,xform_in_AY_AY,xform_in_AY_AZ,
                    xform_in_AZ_AY,xform_in_AZ_AZ,
      xform_in_LX_AX,xform_in_LX_AY,xform_in_LX_AZ,
      xform_in_LY_AX,xform_in_LY_AY,xform_in_LY_AZ,
      xform_in_LZ_AX                            ;
   // stage 2 inputs
   reg signed[(WIDTH-1):0]
      s2r3_in_AX,s2r3_in_AY,s2r3_in_AZ,s2r3_in_LX,s2r3_in_LY,s2r3_in_LZ,
      s2r4_in,
      s2r5_in_AX,s2r5_in_AY,s2r5_in_AZ,s2r5_in_LX,s2r5_in_LY,s2r5_in_LZ,
      s2r6_in;
   // stage 3 inputs
   reg signed[(WIDTH-1):0]
      s3r2_in_AX,s3r2_in_AY,s3r2_in_AZ,s3r2_in_LX,s3r2_in_LY,s3r2_in_LZ,
      s3r3_in_AX,s3r3_in_AY,s3r3_in_AZ,s3r3_in_LX,s3r3_in_LY,s3r3_in_LZ,
      s3r4_in_AX,s3r4_in_AY,s3r4_in_AZ,s3r4_in_LX,s3r4_in_LY,s3r4_in_LZ,
      s3r5_in_AX,s3r5_in_AY,s3r5_in_AZ,s3r5_in_LX,s3r5_in_LY,s3r5_in_LZ;
   // stage 1 outputs
   wire signed[(WIDTH-1):0]
      s1r3_out_AX,s1r3_out_AY,s1r3_out_AZ,s1r3_out_LX,s1r3_out_LY,s1r3_out_LZ,
      s1r4_out,
      s1r5_out_AX,s1r5_out_AY,s1r5_out_AZ,s1r5_out_LX,s1r5_out_LY,s1r5_out_LZ,
      s1r6_out;
   // stage 2 outputs
   wire signed[(WIDTH-1):0]
      s2r2_out_AX,s2r2_out_AY,s2r2_out_AZ,s2r2_out_LX,s2r2_out_LY,s2r2_out_LZ,
      s2r3_out_AX,s2r3_out_AY,s2r3_out_AZ,s2r3_out_LX,s2r3_out_LY,s2r3_out_LZ,
      s2r4_out_AX,s2r4_out_AY,s2r4_out_AZ,s2r4_out_LX,s2r4_out_LY,s2r4_out_LZ,
      s2r5_out_AX,s2r5_out_AY,s2r5_out_AZ,s2r5_out_LX,s2r5_out_LY,s2r5_out_LZ;
   // stage 3 outputs
   wire signed[(WIDTH-1):0]
      s3r1_out_AX,s3r1_out_AY,s3r1_out_AZ,s3r1_out_LX,s3r1_out_LY,s3r1_out_LZ,
      s3r2_out_AX,s3r2_out_AY,s3r2_out_AZ,s3r2_out_LX,s3r2_out_LY,s3r2_out_LZ,
      s3r3_out_AX,s3r3_out_AY,s3r3_out_AZ,s3r3_out_LX,s3r3_out_LY,s3r3_out_LZ;
   // xform outputs
   wire signed[(WIDTH-1):0]
      xform_out_AX_AX,xform_out_AX_AY,xform_out_AX_AZ,
      xform_out_AY_AX,xform_out_AY_AY,xform_out_AY_AZ,
                     xform_out_AZ_AY,xform_out_AZ_AZ,
      xform_out_LX_AX,xform_out_LX_AY,xform_out_LX_AZ,
      xform_out_LY_AX,xform_out_LY_AY,xform_out_LY_AZ,
      xform_out_LZ_AX                              ;
   // mcross
   wire mcross;

   //---------------------------------------------------------------------------
   // sequential
   //---------------------------------------------------------------------------
   always @ (posedge clk)
   begin
      // stage 2&3 xform inputs
      xform_in_AX_AX <= xform_out_AX_AX;
      xform_in_AX_AY <= xform_out_AX_AY;
      xform_in_AX_AZ <= xform_out_AX_AZ;
      xform_in_AY_AX <= xform_out_AY_AX;
      xform_in_AY_AY <= xform_out_AY_AY;
      xform_in_AY_AZ <= xform_out_AY_AZ;
      xform_in_AZ_AY <= xform_out_AZ_AY;
      xform_in_AZ_AZ <= xform_out_AZ_AZ;
      xform_in_LX_AX <= xform_out_LX_AX;
      xform_in_LX_AY <= xform_out_LX_AY;
      xform_in_LX_AZ <= xform_out_LX_AZ;
      xform_in_LY_AX <= xform_out_LY_AX;
      xform_in_LY_AY <= xform_out_LY_AY;
      xform_in_LY_AZ <= xform_out_LY_AZ;
      xform_in_LZ_AX <= xform_out_LZ_AX;
      // stage 2 inputs
      s2r3_in_AX <= s1r3_out_AX;
      s2r3_in_AY <= s1r3_out_AY;
      s2r3_in_AZ <= s1r3_out_AZ;
      s2r3_in_LX <= s1r3_out_LX;
      s2r3_in_LY <= s1r3_out_LY;
      s2r3_in_LZ <= s1r3_out_LZ;
      s2r4_in <= s1r4_out;
      s2r5_in_AX <= s1r5_out_AX;
      s2r5_in_AY <= s1r5_out_AY;
      s2r5_in_AZ <= s1r5_out_AZ;
      s2r5_in_LX <= s1r5_out_LX;
      s2r5_in_LY <= s1r5_out_LY;
      s2r5_in_LZ <= s1r5_out_LZ;
      s2r6_in <= s1r6_out;
      // stage 3 inputs
      s3r2_in_AX <= s2r2_out_AX;
      s3r2_in_AY <= s2r2_out_AY;
      s3r2_in_AZ <= s2r2_out_AZ;
      s3r2_in_LX <= s2r2_out_LX;
      s3r2_in_LY <= s2r2_out_LY;
      s3r2_in_LZ <= s2r2_out_LZ;
      s3r3_in_AX <= s2r3_out_AX;
      s3r3_in_AY <= s2r3_out_AY;
      s3r3_in_AZ <= s2r3_out_AZ;
      s3r3_in_LX <= s2r3_out_LX;
      s3r3_in_LY <= s2r3_out_LY;
      s3r3_in_LZ <= s2r3_out_LZ;
      s3r4_in_AX <= s2r4_out_AX;
      s3r4_in_AY <= s2r4_out_AY;
      s3r4_in_AZ <= s2r4_out_AZ;
      s3r4_in_LX <= s2r4_out_LX;
      s3r4_in_LY <= s2r4_out_LY;
      s3r4_in_LZ <= s2r4_out_LZ;
      s3r5_in_AX <= s2r5_out_AX;
      s3r5_in_AY <= s2r5_out_AY;
      s3r5_in_AZ <= s2r5_out_AZ;
      s3r5_in_LX <= s2r5_out_LX;
      s3r5_in_LY <= s2r5_out_LY;
      s3r5_in_LZ <= s2r5_out_LZ;
   end

   //---------------------------------------------------------------------------
   // combinational
   //---------------------------------------------------------------------------
   // control inputs
   assign s1_bool = s1_bool_in;
   assign s2_bool = s2_bool_in;
   assign s3_bool = s3_bool_in;
   // stage 1 inputs
   assign sinq_in = sinq_curr_in;
   assign cosq_in = cosq_curr_in;
   assign s1r2_in_AX = a_prev_vec_in_AX;
   assign s1r2_in_AY = a_prev_vec_in_AY;
   assign s1r2_in_AZ = a_prev_vec_in_AZ;
   assign s1r2_in_LX = a_prev_vec_in_LX;
   assign s1r2_in_LY = a_prev_vec_in_LY;
   assign s1r2_in_LZ = a_prev_vec_in_LZ;
   assign s1r3_in = qd_curr_in;
   assign s1r4_in_AX = v_prev_vec_in_AX;
   assign s1r4_in_AY = v_prev_vec_in_AY;
   assign s1r4_in_AZ = v_prev_vec_in_AZ;
   assign s1r4_in_LX = v_prev_vec_in_LX;
   assign s1r4_in_LY = v_prev_vec_in_LY;
   assign s1r4_in_LZ = v_prev_vec_in_LZ;
   assign s1r5_in = qdd_curr_in;
   // mcross
   assign mcross = 0;

   rneafpxfold#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      rneafpxfolded(
      // link_in
      .link_in(link_in),
      // sin(q) and cos(q)
      .sinq_in(sinq_in),.cosq_in(cosq_in),
      // xform_in
      .xform_in_AX_AX(xform_in_AX_AX),.xform_in_AX_AY(xform_in_AX_AY),.xform_in_AX_AZ(xform_in_AX_AZ),
      .xform_in_AY_AX(xform_in_AY_AX),.xform_in_AY_AY(xform_in_AY_AY),.xform_in_AY_AZ(xform_in_AY_AZ),
                                     .xform_in_AZ_AY(xform_in_AZ_AY),.xform_in_AZ_AZ(xform_in_AZ_AZ),
      .xform_in_LX_AX(xform_in_LX_AX),.xform_in_LX_AY(xform_in_LX_AY),.xform_in_LX_AZ(xform_in_LX_AZ),
      .xform_in_LY_AX(xform_in_LY_AX),.xform_in_LY_AY(xform_in_LY_AY),.xform_in_LY_AZ(xform_in_LY_AZ),
      .xform_in_LZ_AX(xform_in_LZ_AX)                                                              ,
      // mcross boolean
      .mcross(mcross),
      // stage booleans
      .s1_bool(s1_bool),.s2_bool(s2_bool),.s3_bool(s3_bool),
      // stage 1 inputs
      .s1r2_in_AX(s1r2_in_AX),.s1r2_in_AY(s1r2_in_AY),.s1r2_in_AZ(s1r2_in_AZ),.s1r2_in_LX(s1r2_in_LX),.s1r2_in_LY(s1r2_in_LY),.s1r2_in_LZ(s1r2_in_LZ),
      .s1r3_in(s1r3_in),
      .s1r4_in_AX(s1r4_in_AX),.s1r4_in_AY(s1r4_in_AY),.s1r4_in_AZ(s1r4_in_AZ),.s1r4_in_LX(s1r4_in_LX),.s1r4_in_LY(s1r4_in_LY),.s1r4_in_LZ(s1r4_in_LZ),
      .s1r5_in(s1r5_in),
      // stage 2 inputs
      .s2r3_in_AX(s2r3_in_AX),.s2r3_in_AY(s2r3_in_AY),.s2r3_in_AZ(s2r3_in_AZ),.s2r3_in_LX(s2r3_in_LX),.s2r3_in_LY(s2r3_in_LY),.s2r3_in_LZ(s2r3_in_LZ),
      .s2r4_in(s2r4_in),
      .s2r5_in_AX(s2r5_in_AX),.s2r5_in_AY(s2r5_in_AY),.s2r5_in_AZ(s2r5_in_AZ),.s2r5_in_LX(s2r5_in_LX),.s2r5_in_LY(s2r5_in_LY),.s2r5_in_LZ(s2r5_in_LZ),
      .s2r6_in(s2r6_in),
      // stage 3 inputs
      .s3r2_in_AX(s3r2_in_AX),.s3r2_in_AY(s3r2_in_AY),.s3r2_in_AZ(s3r2_in_AZ),.s3r2_in_LX(s3r2_in_LX),.s3r2_in_LY(s3r2_in_LY),.s3r2_in_LZ(s3r2_in_LZ),
      .s3r3_in_AX(s3r3_in_AX),.s3r3_in_AY(s3r3_in_AY),.s3r3_in_AZ(s3r3_in_AZ),.s3r3_in_LX(s3r3_in_LX),.s3r3_in_LY(s3r3_in_LY),.s3r3_in_LZ(s3r3_in_LZ),
      .s3r4_in_AX(s3r4_in_AX),.s3r4_in_AY(s3r4_in_AY),.s3r4_in_AZ(s3r4_in_AZ),.s3r4_in_LX(s3r4_in_LX),.s3r4_in_LY(s3r4_in_LY),.s3r4_in_LZ(s3r4_in_LZ),
      .s3r5_in_AX(s3r5_in_AX),.s3r5_in_AY(s3r5_in_AY),.s3r5_in_AZ(s3r5_in_AZ),.s3r5_in_LX(s3r5_in_LX),.s3r5_in_LY(s3r5_in_LY),.s3r5_in_LZ(s3r5_in_LZ),
      // stage 1 outputs
      .s1r3_out_AX(s1r3_out_AX),.s1r3_out_AY(s1r3_out_AY),.s1r3_out_AZ(s1r3_out_AZ),.s1r3_out_LX(s1r3_out_LX),.s1r3_out_LY(s1r3_out_LY),.s1r3_out_LZ(s1r3_out_LZ),
      .s1r4_out(s1r4_out),
      .s1r5_out_AX(s1r5_out_AX),.s1r5_out_AY(s1r5_out_AY),.s1r5_out_AZ(s1r5_out_AZ),.s1r5_out_LX(s1r5_out_LX),.s1r5_out_LY(s1r5_out_LY),.s1r5_out_LZ(s1r5_out_LZ),
      .s1r6_out(s1r6_out),
      // stage 2 outputs
      .s2r2_out_AX(s2r2_out_AX),.s2r2_out_AY(s2r2_out_AY),.s2r2_out_AZ(s2r2_out_AZ),.s2r2_out_LX(s2r2_out_LX),.s2r2_out_LY(s2r2_out_LY),.s2r2_out_LZ(s2r2_out_LZ),
      .s2r3_out_AX(s2r3_out_AX),.s2r3_out_AY(s2r3_out_AY),.s2r3_out_AZ(s2r3_out_AZ),.s2r3_out_LX(s2r3_out_LX),.s2r3_out_LY(s2r3_out_LY),.s2r3_out_LZ(s2r3_out_LZ),
      .s2r4_out_AX(s2r4_out_AX),.s2r4_out_AY(s2r4_out_AY),.s2r4_out_AZ(s2r4_out_AZ),.s2r4_out_LX(s2r4_out_LX),.s2r4_out_LY(s2r4_out_LY),.s2r4_out_LZ(s2r4_out_LZ),
      .s2r5_out_AX(s2r5_out_AX),.s2r5_out_AY(s2r5_out_AY),.s2r5_out_AZ(s2r5_out_AZ),.s2r5_out_LX(s2r5_out_LX),.s2r5_out_LY(s2r5_out_LY),.s2r5_out_LZ(s2r5_out_LZ),
      // stage 3 outputs
      .s3r1_out_AX(s3r1_out_AX),.s3r1_out_AY(s3r1_out_AY),.s3r1_out_AZ(s3r1_out_AZ),.s3r1_out_LX(s3r1_out_LX),.s3r1_out_LY(s3r1_out_LY),.s3r1_out_LZ(s3r1_out_LZ),
      .s3r2_out_AX(s3r2_out_AX),.s3r2_out_AY(s3r2_out_AY),.s3r2_out_AZ(s3r2_out_AZ),.s3r2_out_LX(s3r2_out_LX),.s3r2_out_LY(s3r2_out_LY),.s3r2_out_LZ(s3r2_out_LZ),
      .s3r3_out_AX(s3r3_out_AX),.s3r3_out_AY(s3r3_out_AY),.s3r3_out_AZ(s3r3_out_AZ),.s3r3_out_LX(s3r3_out_LX),.s3r3_out_LY(s3r3_out_LY),.s3r3_out_LZ(s3r3_out_LZ),
      // xform_out
      .xform_out_AX_AX(xform_out_AX_AX),.xform_out_AX_AY(xform_out_AX_AY),.xform_out_AX_AZ(xform_out_AX_AZ),
      .xform_out_AY_AX(xform_out_AY_AX),.xform_out_AY_AY(xform_out_AY_AY),.xform_out_AY_AZ(xform_out_AY_AZ),
                                       .xform_out_AZ_AY(xform_out_AZ_AY),.xform_out_AZ_AZ(xform_out_AZ_AZ),
      .xform_out_LX_AX(xform_out_LX_AX),.xform_out_LX_AY(xform_out_LX_AY),.xform_out_LX_AZ(xform_out_LX_AZ),
      .xform_out_LY_AX(xform_out_LY_AX),.xform_out_LY_AY(xform_out_LY_AY),.xform_out_LY_AZ(xform_out_LY_AZ),
      .xform_out_LZ_AX(xform_out_LZ_AX)                                                                  
      );

   //---------------------------------------------------------------------------
   // outputs
   //---------------------------------------------------------------------------
   // v
   assign v_curr_vec_out_AX = s3r3_out_AX;
   assign v_curr_vec_out_AY = s3r3_out_AY;
   assign v_curr_vec_out_AZ = s3r3_out_AZ;
   assign v_curr_vec_out_LX = s3r3_out_LX;
   assign v_curr_vec_out_LY = s3r3_out_LY;
   assign v_curr_vec_out_LZ = s3r3_out_LZ;
   // a
   assign a_curr_vec_out_AX = s3r2_out_AX;
   assign a_curr_vec_out_AY = s3r2_out_AY;
   assign a_curr_vec_out_AZ = s3r2_out_AZ;
   assign a_curr_vec_out_LX = s3r2_out_LX;
   assign a_curr_vec_out_LY = s3r2_out_LY;
   assign a_curr_vec_out_LZ = s3r2_out_LZ;
   // f
   assign f_curr_vec_out_AX = s3r1_out_AX;
   assign f_curr_vec_out_AY = s3r1_out_AY;
   assign f_curr_vec_out_AZ = s3r1_out_AZ;
   assign f_curr_vec_out_LX = s3r1_out_LX;
   assign f_curr_vec_out_LY = s3r1_out_LY;
   assign f_curr_vec_out_LZ = s3r1_out_LZ;

endmodule
