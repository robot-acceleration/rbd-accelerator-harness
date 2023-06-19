`timescale 1ns / 1ps

// dqd Forward Pass for Link i Input j

//------------------------------------------------------------------------------
// dqdfpijx Module
//------------------------------------------------------------------------------
module dqdfpijx#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
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
   // dvdqd_prev_vec_in, 6 values
   input  signed[(WIDTH-1):0]
      dvdqd_prev_vec_in_AX,dvdqd_prev_vec_in_AY,dvdqd_prev_vec_in_AZ,dvdqd_prev_vec_in_LX,dvdqd_prev_vec_in_LY,dvdqd_prev_vec_in_LZ,
   // dadqd_prev_vec_in, 6 values
   input  signed[(WIDTH-1):0]
      dadqd_prev_vec_in_AX,dadqd_prev_vec_in_AY,dadqd_prev_vec_in_AZ,dadqd_prev_vec_in_LX,dadqd_prev_vec_in_LY,dadqd_prev_vec_in_LZ,
   // mcross boolean
   input  mcross,
   // dvdqd_curr_vec_out, 6 values
   output signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX,dvdqd_curr_vec_out_AY,dvdqd_curr_vec_out_AZ,dvdqd_curr_vec_out_LX,dvdqd_curr_vec_out_LY,dvdqd_curr_vec_out_LZ,
   // dadqd_curr_vec_out, 6 values
   output signed[(WIDTH-1):0]
      dadqd_curr_vec_out_AX,dadqd_curr_vec_out_AY,dadqd_curr_vec_out_AZ,dadqd_curr_vec_out_LX,dadqd_curr_vec_out_LY,dadqd_curr_vec_out_LZ,
   // dfdqd_curr_vec_out, 6 values
   output signed[(WIDTH-1):0]
      dfdqd_curr_vec_out_AX,dfdqd_curr_vec_out_AY,dfdqd_curr_vec_out_AZ,dfdqd_curr_vec_out_LX,dfdqd_curr_vec_out_LY,dfdqd_curr_vec_out_LZ
   );

   //---------------------------------------------------------------------------
   // internal wires and state
   //---------------------------------------------------------------------------
   // mux
   wire signed[(WIDTH-1):0]
      dadqd_prev_vec_mux_AX,dadqd_prev_vec_mux_AY,dadqd_prev_vec_mux_AZ,dadqd_prev_vec_mux_LX,dadqd_prev_vec_mux_LY,dadqd_prev_vec_mux_LZ,
      dvdqd_prev_vec_mux_AX,dvdqd_prev_vec_mux_AY,dvdqd_prev_vec_mux_AZ,dvdqd_prev_vec_mux_LX,dvdqd_prev_vec_mux_LY,dvdqd_prev_vec_mux_LZ;

   //---------------------------------------------------------------------------
   // input muxes
   //---------------------------------------------------------------------------
   // dvdqd prev
   assign dvdqd_prev_vec_mux_AX = (link_in == 3'd1) ? 32'd0 : dvdqd_prev_vec_in_AX;
   assign dvdqd_prev_vec_mux_AY = (link_in == 3'd1) ? 32'd0 : dvdqd_prev_vec_in_AY;
   assign dvdqd_prev_vec_mux_AZ = (link_in == 3'd1) ? 32'd0 : dvdqd_prev_vec_in_AZ;
   assign dvdqd_prev_vec_mux_LX = (link_in == 3'd1) ? 32'd0 : dvdqd_prev_vec_in_LX;
   assign dvdqd_prev_vec_mux_LY = (link_in == 3'd1) ? 32'd0 : dvdqd_prev_vec_in_LY;
   assign dvdqd_prev_vec_mux_LZ = (link_in == 3'd1) ? 32'd0 : dvdqd_prev_vec_in_LZ;
   // dadqd prev
   assign dadqd_prev_vec_mux_AX = (link_in == 3'd1) ? 32'd0 : dadqd_prev_vec_in_AX;
   assign dadqd_prev_vec_mux_AY = (link_in == 3'd1) ? 32'd0 : dadqd_prev_vec_in_AY;
   assign dadqd_prev_vec_mux_AZ = (link_in == 3'd1) ? 32'd0 : dadqd_prev_vec_in_AZ;
   assign dadqd_prev_vec_mux_LX = (link_in == 3'd1) ? 32'd0 : dadqd_prev_vec_in_LX;
   assign dadqd_prev_vec_mux_LY = (link_in == 3'd1) ? 32'd0 : dadqd_prev_vec_in_LY;
   assign dadqd_prev_vec_mux_LZ = (link_in == 3'd1) ? 32'd0 : dadqd_prev_vec_in_LZ;

   //---------------------------------------------------------------------------
   // in --> stage 1 --> [reg] --> stage 2 --> [reg] --> stage 3 --> out
   //---------------------------------------------------------------------------
   dqdfpijx_seq#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdfpijx_seq_unit(
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
      .dv_vec_in_AX(dvdqd_prev_vec_mux_AX),.dv_vec_in_AY(dvdqd_prev_vec_mux_AY),.dv_vec_in_AZ(dvdqd_prev_vec_mux_AZ),.dv_vec_in_LX(dvdqd_prev_vec_mux_LX),.dv_vec_in_LY(dvdqd_prev_vec_mux_LY),.dv_vec_in_LZ(dvdqd_prev_vec_mux_LZ),
      // da_vec_in, 6 values
      .da_vec_in_AX(dadqd_prev_vec_mux_AX),.da_vec_in_AY(dadqd_prev_vec_mux_AY),.da_vec_in_AZ(dadqd_prev_vec_mux_AZ),.da_vec_in_LX(dadqd_prev_vec_mux_LX),.da_vec_in_LY(dadqd_prev_vec_mux_LY),.da_vec_in_LZ(dadqd_prev_vec_mux_LZ),
      // dvdqd_vec_out, 6 values
      .dvdqd_vec_out_AX(dvdqd_curr_vec_out_AX),.dvdqd_vec_out_AY(dvdqd_curr_vec_out_AY),.dvdqd_vec_out_AZ(dvdqd_curr_vec_out_AZ),.dvdqd_vec_out_LX(dvdqd_curr_vec_out_LX),.dvdqd_vec_out_LY(dvdqd_curr_vec_out_LY),.dvdqd_vec_out_LZ(dvdqd_curr_vec_out_LZ),
      // dadqd_vec_out, 6 values
      .dadqd_vec_out_AX(dadqd_curr_vec_out_AX),.dadqd_vec_out_AY(dadqd_curr_vec_out_AY),.dadqd_vec_out_AZ(dadqd_curr_vec_out_AZ),.dadqd_vec_out_LX(dadqd_curr_vec_out_LX),.dadqd_vec_out_LY(dadqd_curr_vec_out_LY),.dadqd_vec_out_LZ(dadqd_curr_vec_out_LZ),
      // dfdqd_vec_out, 6 values
      .dfdqd_vec_out_AX(dfdqd_curr_vec_out_AX),.dfdqd_vec_out_AY(dfdqd_curr_vec_out_AY),.dfdqd_vec_out_AZ(dfdqd_curr_vec_out_AZ),.dfdqd_vec_out_LX(dfdqd_curr_vec_out_LX),.dfdqd_vec_out_LY(dfdqd_curr_vec_out_LY),.dfdqd_vec_out_LZ(dfdqd_curr_vec_out_LZ)
      );

endmodule
