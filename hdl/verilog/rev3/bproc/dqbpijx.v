`timescale 1ns / 1ps

// dq Backward Pass for Link i Input j

//------------------------------------------------------------------------------
// dqbpijx Module
//------------------------------------------------------------------------------
module dqbpijx#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // link_in
   input  [2:0]
      link_in,
   // sin(q) and cos(q)
   input  signed[(WIDTH-1):0]
      sinq_in,cosq_in,
   // fcurr_in, 6 values
   input  signed[(WIDTH-1):0]
      fcurr_in_AX,fcurr_in_AY,fcurr_in_AZ,fcurr_in_LX,fcurr_in_LY,fcurr_in_LZ,
   // dfdq_curr_in, 6 values
   input  signed[(WIDTH-1):0]
      dfdq_curr_in_AX,dfdq_curr_in_AY,dfdq_curr_in_AZ,dfdq_curr_in_LX,dfdq_curr_in_LY,dfdq_curr_in_LZ,
   // fcross boolean
   input  fcross,
   // dfdq_prev_in, 6 values
   input  signed[(WIDTH-1):0]
      dfdq_prev_in_AX,dfdq_prev_in_AY,dfdq_prev_in_AZ,dfdq_prev_in_LX,dfdq_prev_in_LY,dfdq_prev_in_LZ,
   // dtau_dq_out
   output signed[(WIDTH-1):0]
      dtau_dq_out,
   // dfdq_prev_out, 6 values
   output signed[(WIDTH-1):0]
      dfdq_prev_out_AX,dfdq_prev_out_AY,dfdq_prev_out_AZ,dfdq_prev_out_LX,dfdq_prev_out_LY,dfdq_prev_out_LZ
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
      ficross_AX,ficross_AY,ficross_AZ,ficross_LX,ficross_LY,ficross_LZ;
   wire signed[(WIDTH-1):0]
      fcross_out_AX,fcross_out_AY,fcross_out_AZ,fcross_out_LX,fcross_out_LY,fcross_out_LZ;
   wire signed[(WIDTH-1):0]
      lprev_dfi_dq_xtdot_updated_AX,lprev_dfi_dq_xtdot_updated_AY,lprev_dfi_dq_xtdot_updated_AZ,lprev_dfi_dq_xtdot_updated_LX,lprev_dfi_dq_xtdot_updated_LY,lprev_dfi_dq_xtdot_updated_LZ;
   wire signed[(WIDTH-1):0]
      lprev_dfi_dq_fcross_updated_AX,lprev_dfi_dq_fcross_updated_AY,lprev_dfi_dq_fcross_updated_AZ,lprev_dfi_dq_fcross_updated_LX,lprev_dfi_dq_fcross_updated_LY,lprev_dfi_dq_fcross_updated_LZ;
   wire signed[(WIDTH-1):0]
      lprev_dfi_dq_out_AX,lprev_dfi_dq_out_AY,lprev_dfi_dq_out_AZ,lprev_dfi_dq_out_LX,lprev_dfi_dq_out_LY,lprev_dfi_dq_out_LZ;

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

   // output dtau/dq
   assign dtau_dq_out = dfdq_curr_in_AZ;

   // update df/dq
   xtdot#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      xtdot_xtdot(
      // xform_in
      .xform_in_AX_AX(xform_AX_AX),.xform_in_AX_AY(xform_AX_AY),.xform_in_AX_AZ(xform_AX_AZ),                                                                                    
      .xform_in_AY_AX(xform_AY_AX),.xform_in_AY_AY(xform_AY_AY),.xform_in_AY_AZ(xform_AY_AZ),                                                                                    
                                  .xform_in_AZ_AY(xform_AZ_AY),.xform_in_AZ_AZ(xform_AZ_AZ),                                                                                    
      .xform_in_LX_AX(xform_LX_AX),.xform_in_LX_AY(xform_LX_AY),.xform_in_LX_AZ(xform_LX_AZ),.xform_in_LX_LX(xform_AX_AX),.xform_in_LX_LY(xform_AX_AY),.xform_in_LX_LZ(xform_AX_AZ),
      .xform_in_LY_AX(xform_LY_AX),.xform_in_LY_AY(xform_LY_AY),.xform_in_LY_AZ(xform_LY_AZ),.xform_in_LY_LX(xform_AY_AX),.xform_in_LY_LY(xform_AY_AY),.xform_in_LY_LZ(xform_AY_AZ),
      .xform_in_LZ_AX(xform_LZ_AX),                                                                                    .xform_in_LZ_LY(xform_AZ_AY),.xform_in_LZ_LZ(xform_AZ_AZ),
      // vec_in, 6 values
      .vec_in_AX(dfdq_curr_in_AX),.vec_in_AY(dfdq_curr_in_AY),.vec_in_AZ(dfdq_curr_in_AZ),.vec_in_LX(dfdq_curr_in_LX),.vec_in_LY(dfdq_curr_in_LY),.vec_in_LZ(dfdq_curr_in_LZ),
      // xtvec_out, 6 values
      .xtvec_out_AX(xtdot_out_AX),.xtvec_out_AY(xtdot_out_AY),.xtvec_out_AZ(xtdot_out_AZ),.xtvec_out_LX(xtdot_out_LX),.xtvec_out_LY(xtdot_out_LY),.xtvec_out_LZ(xtdot_out_LZ)
      );
   // (6 adds)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtdot_AX(.a_in(dfdq_prev_in_AX),.b_in(xtdot_out_AX),.sum_out(lprev_dfi_dq_xtdot_updated_AX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtdot_AY(.a_in(dfdq_prev_in_AY),.b_in(xtdot_out_AY),.sum_out(lprev_dfi_dq_xtdot_updated_AY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtdot_AZ(.a_in(dfdq_prev_in_AZ),.b_in(xtdot_out_AZ),.sum_out(lprev_dfi_dq_xtdot_updated_AZ));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtdot_LX(.a_in(dfdq_prev_in_LX),.b_in(xtdot_out_LX),.sum_out(lprev_dfi_dq_xtdot_updated_LX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtdot_LY(.a_in(dfdq_prev_in_LY),.b_in(xtdot_out_LY),.sum_out(lprev_dfi_dq_xtdot_updated_LY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_xtdot_LZ(.a_in(dfdq_prev_in_LZ),.b_in(xtdot_out_LZ),.sum_out(lprev_dfi_dq_xtdot_updated_LZ));

   // fcross
   assign ficross_AX = -fcurr_in_AY;
   assign ficross_AY =  fcurr_in_AX;
   assign ficross_AZ = 32'd0;
   assign ficross_LX = -fcurr_in_LY;
   assign ficross_LY =  fcurr_in_LX;
   assign ficross_LZ = 32'd0;
   xtdot#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      xtdot_fcross(
      // xform_in
      .xform_in_AX_AX(xform_AX_AX),.xform_in_AX_AY(xform_AX_AY),.xform_in_AX_AZ(xform_AX_AZ),                                                                                    
      .xform_in_AY_AX(xform_AY_AX),.xform_in_AY_AY(xform_AY_AY),.xform_in_AY_AZ(xform_AY_AZ),                                                                                    
                                  .xform_in_AZ_AY(xform_AZ_AY),.xform_in_AZ_AZ(xform_AZ_AZ),                                                                                    
      .xform_in_LX_AX(xform_LX_AX),.xform_in_LX_AY(xform_LX_AY),.xform_in_LX_AZ(xform_LX_AZ),.xform_in_LX_LX(xform_AX_AX),.xform_in_LX_LY(xform_AX_AY),.xform_in_LX_LZ(xform_AX_AZ),
      .xform_in_LY_AX(xform_LY_AX),.xform_in_LY_AY(xform_LY_AY),.xform_in_LY_AZ(xform_LY_AZ),.xform_in_LY_LX(xform_AY_AX),.xform_in_LY_LY(xform_AY_AY),.xform_in_LY_LZ(xform_AY_AZ),
      .xform_in_LZ_AX(xform_LZ_AX),                                                                                    .xform_in_LZ_LY(xform_AZ_AY),.xform_in_LZ_LZ(xform_AZ_AZ),
      // vec_in, 6 values
      .vec_in_AX(ficross_AX),.vec_in_AY(ficross_AY),.vec_in_AZ(ficross_AZ),.vec_in_LX(ficross_LX),.vec_in_LY(ficross_LY),.vec_in_LZ(ficross_LZ),
      // xtvec_out, 6 values
      .xtvec_out_AX(fcross_out_AX),.xtvec_out_AY(fcross_out_AY),.xtvec_out_AZ(fcross_out_AZ),.xtvec_out_LX(fcross_out_LX),.xtvec_out_LY(fcross_out_LY),.xtvec_out_LZ(fcross_out_LZ)
      );
   // (6 adds)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fcross_AX(.a_in(fcross_out_AX),.b_in(lprev_dfi_dq_xtdot_updated_AX),.sum_out(lprev_dfi_dq_fcross_updated_AX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fcross_AY(.a_in(fcross_out_AY),.b_in(lprev_dfi_dq_xtdot_updated_AY),.sum_out(lprev_dfi_dq_fcross_updated_AY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fcross_AZ(.a_in(fcross_out_AZ),.b_in(lprev_dfi_dq_xtdot_updated_AZ),.sum_out(lprev_dfi_dq_fcross_updated_AZ));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fcross_LX(.a_in(fcross_out_LX),.b_in(lprev_dfi_dq_xtdot_updated_LX),.sum_out(lprev_dfi_dq_fcross_updated_LX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fcross_LY(.a_in(fcross_out_LY),.b_in(lprev_dfi_dq_xtdot_updated_LY),.sum_out(lprev_dfi_dq_fcross_updated_LY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add_fcross_LZ(.a_in(fcross_out_LZ),.b_in(lprev_dfi_dq_xtdot_updated_LZ),.sum_out(lprev_dfi_dq_fcross_updated_LZ));

   // df/dq update mux
   assign dfdq_prev_out_AX = fcross ? lprev_dfi_dq_fcross_updated_AX : lprev_dfi_dq_xtdot_updated_AX;
   assign dfdq_prev_out_AY = fcross ? lprev_dfi_dq_fcross_updated_AY : lprev_dfi_dq_xtdot_updated_AY;
   assign dfdq_prev_out_AZ = fcross ? lprev_dfi_dq_fcross_updated_AZ : lprev_dfi_dq_xtdot_updated_AZ;
   assign dfdq_prev_out_LX = fcross ? lprev_dfi_dq_fcross_updated_LX : lprev_dfi_dq_xtdot_updated_LX;
   assign dfdq_prev_out_LY = fcross ? lprev_dfi_dq_fcross_updated_LY : lprev_dfi_dq_xtdot_updated_LY;
   assign dfdq_prev_out_LZ = fcross ? lprev_dfi_dq_fcross_updated_LZ : lprev_dfi_dq_xtdot_updated_LZ;

endmodule

