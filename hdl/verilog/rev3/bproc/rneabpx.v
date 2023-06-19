`timescale 1ns / 1ps

// RNEA for Link i

//------------------------------------------------------------------------------
// rneabpx Module
//------------------------------------------------------------------------------
module rneabpx#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // link_in
   input  [2:0]
      link_in,
   // sin(q) and cos(q)
   input  signed[(WIDTH-1):0]
      sinq_curr_in,cosq_curr_in,
   // f_curr_vec_in
   input  signed[(WIDTH-1):0]
      f_curr_vec_in_AX,f_curr_vec_in_AY,f_curr_vec_in_AZ,f_curr_vec_in_LX,f_curr_vec_in_LY,f_curr_vec_in_LZ,
   // f_prev_vec_in
   input  signed[(WIDTH-1):0]
      f_prev_vec_in_AX,f_prev_vec_in_AY,f_prev_vec_in_AZ,f_prev_vec_in_LX,f_prev_vec_in_LY,f_prev_vec_in_LZ,
   // tau_curr_out
   output signed[(WIDTH-1):0]
      tau_curr_out,
   // f_prev_upd_vec_out
   output signed[(WIDTH-1):0]
      f_prev_upd_vec_out_AX,f_prev_upd_vec_out_AY,f_prev_upd_vec_out_AZ,f_prev_upd_vec_out_LX,f_prev_upd_vec_out_LY,f_prev_upd_vec_out_LZ
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
      xtdot_out_AX,xtdot_out_AY,xtdot_out_AZ,xtdot_out_LX,xtdot_out_LY,xtdot_out_LZ;
   wire signed[(WIDTH-1):0]
      f_prev_updated_AX,f_prev_updated_AY,f_prev_updated_AZ,f_prev_updated_LX,f_prev_updated_LY,f_prev_updated_LZ;

   // xform generation
   xgens7#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      xgens_unit(
      // link_in
      .link_in(link_in),
      // sin(q) and cos(q)
      .sinq_in(sinq_curr_in),.cosq_in(cosq_curr_in),
      // xform_out
      .xform_out_AX_AX(xform_AX_AX),.xform_out_AX_AY(xform_AX_AY),.xform_out_AX_AZ(xform_AX_AZ),
      .xform_out_AY_AX(xform_AY_AX),.xform_out_AY_AY(xform_AY_AY),.xform_out_AY_AZ(xform_AY_AZ),
                                   .xform_out_AZ_AY(xform_AZ_AY),.xform_out_AZ_AZ(xform_AZ_AZ),
      .xform_out_LX_AX(xform_LX_AX),.xform_out_LX_AY(xform_LX_AY),.xform_out_LX_AZ(xform_LX_AZ),
      .xform_out_LY_AX(xform_LY_AX),.xform_out_LY_AY(xform_LY_AY),.xform_out_LY_AZ(xform_LY_AZ),
      .xform_out_LZ_AX(xform_LZ_AX)                                                          
      );

   // output dtau/dqd
   assign tau_curr_out = f_curr_vec_in_AZ;

   // update df/dqd
   xtdot#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      xtdot_unit(
      // xform_in
      .xform_in_AX_AX(xform_AX_AX),.xform_in_AX_AY(xform_AX_AY),.xform_in_AX_AZ(xform_AX_AZ),                                                                                    
      .xform_in_AY_AX(xform_AY_AX),.xform_in_AY_AY(xform_AY_AY),.xform_in_AY_AZ(xform_AY_AZ),                                                                                    
                                  .xform_in_AZ_AY(xform_AZ_AY),.xform_in_AZ_AZ(xform_AZ_AZ),                                                                                    
      .xform_in_LX_AX(xform_LX_AX),.xform_in_LX_AY(xform_LX_AY),.xform_in_LX_AZ(xform_LX_AZ),.xform_in_LX_LX(xform_AX_AX),.xform_in_LX_LY(xform_AX_AY),.xform_in_LX_LZ(xform_AX_AZ),
      .xform_in_LY_AX(xform_LY_AX),.xform_in_LY_AY(xform_LY_AY),.xform_in_LY_AZ(xform_LY_AZ),.xform_in_LY_LX(xform_AY_AX),.xform_in_LY_LY(xform_AY_AY),.xform_in_LY_LZ(xform_AY_AZ),
      .xform_in_LZ_AX(xform_LZ_AX),                                                                                    .xform_in_LZ_LY(xform_AZ_AY),.xform_in_LZ_LZ(xform_AZ_AZ),
      // vec_in, 6 values
      .vec_in_AX(f_curr_vec_in_AX),.vec_in_AY(f_curr_vec_in_AY),.vec_in_AZ(f_curr_vec_in_AZ),.vec_in_LX(f_curr_vec_in_LX),.vec_in_LY(f_curr_vec_in_LY),.vec_in_LZ(f_curr_vec_in_LZ),
      // xtvec_out, 6 values
      .xtvec_out_AX(xtdot_out_AX),.xtvec_out_AY(xtdot_out_AY),.xtvec_out_AZ(xtdot_out_AZ),.xtvec_out_LX(xtdot_out_LX),.xtvec_out_LY(xtdot_out_LY),.xtvec_out_LZ(xtdot_out_LZ)
      );
   // (6 adds)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_dfdqd_AX(.a_in(f_prev_vec_in_AX),.b_in(xtdot_out_AX),.sum_out(f_prev_updated_AX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_dfdqd_AY(.a_in(f_prev_vec_in_AY),.b_in(xtdot_out_AY),.sum_out(f_prev_updated_AY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_dfdqd_AZ(.a_in(f_prev_vec_in_AZ),.b_in(xtdot_out_AZ),.sum_out(f_prev_updated_AZ));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_dfdqd_LX(.a_in(f_prev_vec_in_LX),.b_in(xtdot_out_LX),.sum_out(f_prev_updated_LX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_dfdqd_LY(.a_in(f_prev_vec_in_LY),.b_in(xtdot_out_LY),.sum_out(f_prev_updated_LY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_dfdqd_LZ(.a_in(f_prev_vec_in_LZ),.b_in(xtdot_out_LZ),.sum_out(f_prev_updated_LZ));

   // output df/dqd updates
   assign f_prev_upd_vec_out_AX = f_prev_updated_AX;
   assign f_prev_upd_vec_out_AY = f_prev_updated_AY;
   assign f_prev_upd_vec_out_AZ = f_prev_updated_AZ;
   assign f_prev_upd_vec_out_LX = f_prev_updated_LX;
   assign f_prev_upd_vec_out_LY = f_prev_updated_LY;
   assign f_prev_upd_vec_out_LZ = f_prev_updated_LZ;

endmodule
