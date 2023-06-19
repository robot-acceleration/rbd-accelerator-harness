`timescale 1ns / 1ps

// dq Forward Pass for Link i Input j

//------------------------------------------------------------------------------
// dqfpijx Module
//------------------------------------------------------------------------------
module dqfpijx#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // clock
   input clk,
   // reset
   input reset,
   // state_reg
   input  [2:0]
      state_reg,
   // stage booleans
   input
      s1_bool_in,s2_bool_in,s3_bool_in,
   // link_in
   input  [2:0]
      link_in,
   // sin(q) and cos(q)
   input  signed[(WIDTH-1):0]
      sinq_val_in,cosq_val_in,
   // qd_val_in
   input  signed[(WIDTH-1):0]
      qd_val_in,
   // v_curr_vec_in, 6 values
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX,v_curr_vec_in_AY,v_curr_vec_in_AZ,v_curr_vec_in_LX,v_curr_vec_in_LY,v_curr_vec_in_LZ,
   // a_curr_vec_in, 6 values
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX,a_curr_vec_in_AY,a_curr_vec_in_AZ,a_curr_vec_in_LX,a_curr_vec_in_LY,a_curr_vec_in_LZ,
   // v_prev_vec_in, 6 values
   input  signed[(WIDTH-1):0]
      v_prev_vec_in_AX,v_prev_vec_in_AY,v_prev_vec_in_AZ,v_prev_vec_in_LX,v_prev_vec_in_LY,v_prev_vec_in_LZ,
   // a_prev_vec_in, 6 values
   input  signed[(WIDTH-1):0]
      a_prev_vec_in_AX,a_prev_vec_in_AY,a_prev_vec_in_AZ,a_prev_vec_in_LX,a_prev_vec_in_LY,a_prev_vec_in_LZ,
   // dvdq_prev_vec_in, 6 values
   input  signed[(WIDTH-1):0]
      dvdq_prev_vec_in_AX,dvdq_prev_vec_in_AY,dvdq_prev_vec_in_AZ,dvdq_prev_vec_in_LX,dvdq_prev_vec_in_LY,dvdq_prev_vec_in_LZ,
   // dadq_prev_vec_in, 6 values
   input  signed[(WIDTH-1):0]
      dadq_prev_vec_in_AX,dadq_prev_vec_in_AY,dadq_prev_vec_in_AZ,dadq_prev_vec_in_LX,dadq_prev_vec_in_LY,dadq_prev_vec_in_LZ,
   // mcross boolean
   input  mcross,
   // dvdq_curr_vec_out, 6 values
   output signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX,dvdq_curr_vec_out_AY,dvdq_curr_vec_out_AZ,dvdq_curr_vec_out_LX,dvdq_curr_vec_out_LY,dvdq_curr_vec_out_LZ,
   // dadq_curr_vec_out, 6 values
   output signed[(WIDTH-1):0]
      dadq_curr_vec_out_AX,dadq_curr_vec_out_AY,dadq_curr_vec_out_AZ,dadq_curr_vec_out_LX,dadq_curr_vec_out_LY,dadq_curr_vec_out_LZ,
   // dfdq_curr_vec_out, 6 values
   output signed[(WIDTH-1):0]
      dfdq_curr_vec_out_AX,dfdq_curr_vec_out_AY,dfdq_curr_vec_out_AZ,dfdq_curr_vec_out_LX,dfdq_curr_vec_out_LY,dfdq_curr_vec_out_LZ
   );

   //---------------------------------------------------------------------------
   // internal wires and state
   //---------------------------------------------------------------------------
   // mux
   wire signed[(WIDTH-1):0]
      dadq_prev_vec_mux_AX,dadq_prev_vec_mux_AY,dadq_prev_vec_mux_AZ,dadq_prev_vec_mux_LX,dadq_prev_vec_mux_LY,dadq_prev_vec_mux_LZ,
      dvdq_prev_vec_mux_AX,dvdq_prev_vec_mux_AY,dvdq_prev_vec_mux_AZ,dvdq_prev_vec_mux_LX,dvdq_prev_vec_mux_LY,dvdq_prev_vec_mux_LZ;
   // mcross
   wire signed[(WIDTH-1):0]
      vordv_prev_vec_mux_AX,vordv_prev_vec_mux_AY,vordv_prev_vec_mux_AZ,vordv_prev_vec_mux_LX,vordv_prev_vec_mux_LY,vordv_prev_vec_mux_LZ,
      aorda_prev_vec_mux_AX,aorda_prev_vec_mux_AY,aorda_prev_vec_mux_AZ,aorda_prev_vec_mux_LX,aorda_prev_vec_mux_LY,aorda_prev_vec_mux_LZ;

   //---------------------------------------------------------------------------
   // input muxes
   //---------------------------------------------------------------------------
   // dvdq prev
   assign dvdq_prev_vec_mux_AX = (link_in == 3'd1) ? 32'd0 : dvdq_prev_vec_in_AX;
   assign dvdq_prev_vec_mux_AY = (link_in == 3'd1) ? 32'd0 : dvdq_prev_vec_in_AY;
   assign dvdq_prev_vec_mux_AZ = (link_in == 3'd1) ? 32'd0 : dvdq_prev_vec_in_AZ;
   assign dvdq_prev_vec_mux_LX = (link_in == 3'd1) ? 32'd0 : dvdq_prev_vec_in_LX;
   assign dvdq_prev_vec_mux_LY = (link_in == 3'd1) ? 32'd0 : dvdq_prev_vec_in_LY;
   assign dvdq_prev_vec_mux_LZ = (link_in == 3'd1) ? 32'd0 : dvdq_prev_vec_in_LZ;
   // dadq prev
   assign dadq_prev_vec_mux_AX = (link_in == 3'd1) ? 32'd0 : dadq_prev_vec_in_AX;
   assign dadq_prev_vec_mux_AY = (link_in == 3'd1) ? 32'd0 : dadq_prev_vec_in_AY;
   assign dadq_prev_vec_mux_AZ = (link_in == 3'd1) ? 32'd0 : dadq_prev_vec_in_AZ;
   assign dadq_prev_vec_mux_LX = (link_in == 3'd1) ? 32'd0 : dadq_prev_vec_in_LX;
   assign dadq_prev_vec_mux_LY = (link_in == 3'd1) ? 32'd0 : dadq_prev_vec_in_LY;
   assign dadq_prev_vec_mux_LZ = (link_in == 3'd1) ? 32'd0 : dadq_prev_vec_in_LZ;

   //---------------------------------------------------------------------------
   // in --> stage 1 --> [reg] --> stage 2 --> [reg] --> stage 3 --> out
   //---------------------------------------------------------------------------
   // mcross
   assign vordv_prev_vec_mux_AX = (mcross) ? v_prev_vec_in_AX : dvdq_prev_vec_mux_AX;
   assign vordv_prev_vec_mux_AY = (mcross) ? v_prev_vec_in_AY : dvdq_prev_vec_mux_AY;
   assign vordv_prev_vec_mux_AZ = (mcross) ? v_prev_vec_in_AZ : dvdq_prev_vec_mux_AZ;
   assign vordv_prev_vec_mux_LX = (mcross) ? v_prev_vec_in_LX : dvdq_prev_vec_mux_LX;
   assign vordv_prev_vec_mux_LY = (mcross) ? v_prev_vec_in_LY : dvdq_prev_vec_mux_LY;
   assign vordv_prev_vec_mux_LZ = (mcross) ? v_prev_vec_in_LZ : dvdq_prev_vec_mux_LZ;
   assign aorda_prev_vec_mux_AX = (mcross) ? a_prev_vec_in_AX : dadq_prev_vec_mux_AX;
   assign aorda_prev_vec_mux_AY = (mcross) ? a_prev_vec_in_AY : dadq_prev_vec_mux_AY;
   assign aorda_prev_vec_mux_AZ = (mcross) ? a_prev_vec_in_AZ : dadq_prev_vec_mux_AZ;
   assign aorda_prev_vec_mux_LX = (mcross) ? a_prev_vec_in_LX : dadq_prev_vec_mux_LX;
   assign aorda_prev_vec_mux_LY = (mcross) ? a_prev_vec_in_LY : dadq_prev_vec_mux_LY;
   assign aorda_prev_vec_mux_LZ = (mcross) ? a_prev_vec_in_LZ : dadq_prev_vec_mux_LZ;

   dqfpijx_seq#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqfpijx_seq_unit(
      // clock
      .clk(clk),
      // stage booleans
      .s1_bool_in(s1_bool_in),.s2_bool_in(s2_bool_in),.s3_bool_in(s3_bool_in),
      // link_in
      .link_in(link_in),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_in),.cosq_val_in(cosq_val_in),
      // qd_val_in
      .qd_val_in(qd_val_in),
      // v_vec_in, 6 values
      .v_vec_in_AX(v_curr_vec_in_AX),.v_vec_in_AY(v_curr_vec_in_AY),.v_vec_in_AZ(v_curr_vec_in_AZ),.v_vec_in_LX(v_curr_vec_in_LX),.v_vec_in_LY(v_curr_vec_in_LY),.v_vec_in_LZ(v_curr_vec_in_LZ),
      // mcross boolean
      .mcross(mcross),
      // dv_vec_in, 6 values
      .dv_vec_in_AX(vordv_prev_vec_mux_AX),.dv_vec_in_AY(vordv_prev_vec_mux_AY),.dv_vec_in_AZ(vordv_prev_vec_mux_AZ),.dv_vec_in_LX(vordv_prev_vec_mux_LX),.dv_vec_in_LY(vordv_prev_vec_mux_LY),.dv_vec_in_LZ(vordv_prev_vec_mux_LZ),
      // da_vec_in, 6 values
      .da_vec_in_AX(aorda_prev_vec_mux_AX),.da_vec_in_AY(aorda_prev_vec_mux_AY),.da_vec_in_AZ(aorda_prev_vec_mux_AZ),.da_vec_in_LX(aorda_prev_vec_mux_LX),.da_vec_in_LY(aorda_prev_vec_mux_LY),.da_vec_in_LZ(aorda_prev_vec_mux_LZ),
      // dvdq_vec_out, 6 values
      .dvdq_vec_out_AX(dvdq_curr_vec_out_AX),.dvdq_vec_out_AY(dvdq_curr_vec_out_AY),.dvdq_vec_out_AZ(dvdq_curr_vec_out_AZ),.dvdq_vec_out_LX(dvdq_curr_vec_out_LX),.dvdq_vec_out_LY(dvdq_curr_vec_out_LY),.dvdq_vec_out_LZ(dvdq_curr_vec_out_LZ),
      // dadq_vec_out, 6 values
      .dadq_vec_out_AX(dadq_curr_vec_out_AX),.dadq_vec_out_AY(dadq_curr_vec_out_AY),.dadq_vec_out_AZ(dadq_curr_vec_out_AZ),.dadq_vec_out_LX(dadq_curr_vec_out_LX),.dadq_vec_out_LY(dadq_curr_vec_out_LY),.dadq_vec_out_LZ(dadq_curr_vec_out_LZ),
      // dfdq_vec_out, 6 values
      .dfdq_vec_out_AX(dfdq_curr_vec_out_AX),.dfdq_vec_out_AY(dfdq_curr_vec_out_AY),.dfdq_vec_out_AZ(dfdq_curr_vec_out_AZ),.dfdq_vec_out_LX(dfdq_curr_vec_out_LX),.dfdq_vec_out_LY(dfdq_curr_vec_out_LY),.dfdq_vec_out_LZ(dfdq_curr_vec_out_LZ)
      );

endmodule
