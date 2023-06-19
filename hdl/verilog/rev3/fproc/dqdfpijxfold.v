`timescale 1ns / 1ps

// dqd Forward Pass for Link i Input j
//
// (174 mult, 124 add)

//------------------------------------------------------------------------------
// dqdfpijxfold Module
//------------------------------------------------------------------------------
module dqdfpijxfold#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // link_in
   input  [2:0]
      link_in,
   // sin(q) and cos(q)
   input  signed[(WIDTH-1):0]
      sinq_in,cosq_in,
   // xform_in
   input  signed[(WIDTH-1):0]
      xform_in_AX_AX,xform_in_AX_AY,xform_in_AX_AZ,
      xform_in_AY_AX,xform_in_AY_AY,xform_in_AY_AZ,
                    xform_in_AZ_AY,xform_in_AZ_AZ,
      xform_in_LX_AX,xform_in_LX_AY,xform_in_LX_AZ,
      xform_in_LY_AX,xform_in_LY_AY,xform_in_LY_AZ,
      xform_in_LZ_AX                            ,
   // mcross boolean
   input  mcross,
   // stage booleans
   input  s1_bool,s2_bool,s3_bool,
   // stage 1 inputs
   input  signed[(WIDTH-1):0]
      s1r1_in_AX,s1r1_in_AY,s1r1_in_AZ,s1r1_in_LX,s1r1_in_LY,s1r1_in_LZ,
      s1r2_in_AX,s1r2_in_AY,s1r2_in_AZ,s1r2_in_LX,s1r2_in_LY,s1r2_in_LZ,
      s1r3_in,
      s1r4_in_AX,s1r4_in_AY,s1r4_in_AZ,s1r4_in_LX,s1r4_in_LY,s1r4_in_LZ,
   // stage 2 inputs
   input  signed[(WIDTH-1):0]
      s2r1_in_AX,s2r1_in_AY,s2r1_in_AZ,s2r1_in_LX,s2r1_in_LY,s2r1_in_LZ,
      s2r2_in_AX,s2r2_in_AY,s2r2_in_AZ,s2r2_in_LX,s2r2_in_LY,s2r2_in_LZ,
      s2r3_in_AX,s2r3_in_AY,s2r3_in_AZ,s2r3_in_LX,s2r3_in_LY,s2r3_in_LZ,
      s2r4_in,
      s2r5_in_AX,s2r5_in_AY,s2r5_in_AZ,s2r5_in_LX,s2r5_in_LY,s2r5_in_LZ,
   // stage 3 inputs
   input  signed[(WIDTH-1):0]
      s3r1_in_AX,s3r1_in_AY,s3r1_in_AZ,s3r1_in_LX,s3r1_in_LY,s3r1_in_LZ,
      s3r2_in_AX,s3r2_in_AY,s3r2_in_AZ,s3r2_in_LX,s3r2_in_LY,s3r2_in_LZ,
      s3r3_in_AX,s3r3_in_AY,s3r3_in_AZ,s3r3_in_LX,s3r3_in_LY,s3r3_in_LZ,
      s3r4_in_AX,s3r4_in_AY,s3r4_in_AZ,s3r4_in_LX,s3r4_in_LY,s3r4_in_LZ,
      s3r5_in_AX,s3r5_in_AY,s3r5_in_AZ,s3r5_in_LX,s3r5_in_LY,s3r5_in_LZ,
   // stage 1 outputs
   output signed[(WIDTH-1):0]
      s1r1_out_AX,s1r1_out_AY,s1r1_out_AZ,s1r1_out_LX,s1r1_out_LY,s1r1_out_LZ,
      s1r2_out_AX,s1r2_out_AY,s1r2_out_AZ,s1r2_out_LX,s1r2_out_LY,s1r2_out_LZ,
      s1r3_out_AX,s1r3_out_AY,s1r3_out_AZ,s1r3_out_LX,s1r3_out_LY,s1r3_out_LZ,
      s1r4_out,
      s1r5_out_AX,s1r5_out_AY,s1r5_out_AZ,s1r5_out_LX,s1r5_out_LY,s1r5_out_LZ,
   // stage 2 outputs
   output signed[(WIDTH-1):0]
      s2r1_out_AX,s2r1_out_AY,s2r1_out_AZ,s2r1_out_LX,s2r1_out_LY,s2r1_out_LZ,
      s2r2_out_AX,s2r2_out_AY,s2r2_out_AZ,s2r2_out_LX,s2r2_out_LY,s2r2_out_LZ,
      s2r3_out_AX,s2r3_out_AY,s2r3_out_AZ,s2r3_out_LX,s2r3_out_LY,s2r3_out_LZ,
      s2r4_out_AX,s2r4_out_AY,s2r4_out_AZ,s2r4_out_LX,s2r4_out_LY,s2r4_out_LZ,
      s2r5_out_AX,s2r5_out_AY,s2r5_out_AZ,s2r5_out_LX,s2r5_out_LY,s2r5_out_LZ,
   // stage 3 outputs
   output signed[(WIDTH-1):0]
      s3r1_out_AX,s3r1_out_AY,s3r1_out_AZ,s3r1_out_LX,s3r1_out_LY,s3r1_out_LZ,
      s3r2_out_AX,s3r2_out_AY,s3r2_out_AZ,s3r2_out_LX,s3r2_out_LY,s3r2_out_LZ,
      s3r3_out_AX,s3r3_out_AY,s3r3_out_AZ,s3r3_out_LX,s3r3_out_LY,s3r3_out_LZ,
   // xform_out
   output signed[(WIDTH-1):0]
      xform_out_AX_AX,xform_out_AX_AY,xform_out_AX_AZ,
      xform_out_AY_AX,xform_out_AY_AY,xform_out_AY_AZ,
                     xform_out_AZ_AY,xform_out_AZ_AZ,
      xform_out_LX_AX,xform_out_LX_AY,xform_out_LX_AZ,
      xform_out_LY_AX,xform_out_LY_AY,xform_out_LY_AZ,
      xform_out_LZ_AX                              
   );

   // internal wires and state
   // xform
   wire signed[(WIDTH-1):0]
      xgens_out_AX_AX,xgens_out_AX_AY,xgens_out_AX_AZ,
      xgens_out_AY_AX,xgens_out_AY_AY,xgens_out_AY_AZ,
                     xgens_out_AZ_AY,xgens_out_AZ_AZ,
      xgens_out_LX_AX,xgens_out_LX_AY,xgens_out_LX_AZ,
      xgens_out_LY_AX,xgens_out_LY_AY,xgens_out_LY_AZ,
      xgens_out_LZ_AX                              ;
   wire signed[(WIDTH-1):0]
      xform_AX_AX,xform_AX_AY,xform_AX_AZ,
      xform_AY_AX,xform_AY_AY,xform_AY_AZ,
                 xform_AZ_AY,xform_AZ_AZ,
      xform_LX_AX,xform_LX_AY,xform_LX_AZ,
      xform_LY_AX,xform_LY_AY,xform_LY_AZ,
      xform_LZ_AX                      ;
   // fxdot
   wire signed[(WIDTH-1):0]
      fxdot_in_fxvec_AX,fxdot_in_fxvec_AY,fxdot_in_fxvec_AZ,fxdot_in_fxvec_LX,fxdot_in_fxvec_LY,fxdot_in_fxvec_LZ;
   wire signed[(WIDTH-1):0]
      fxdot_in_dotvec_AX,fxdot_in_dotvec_AY,fxdot_in_dotvec_AZ,fxdot_in_dotvec_LX,fxdot_in_dotvec_LY,fxdot_in_dotvec_LZ;
   wire signed[(WIDTH-1):0]
      fxdot_out_AX,fxdot_out_AY,fxdot_out_AZ,fxdot_out_LX,fxdot_out_LY,fxdot_out_LZ;
   // idot
   wire signed[(WIDTH-1):0]
      idot_in_vec_AX,idot_in_vec_AY,idot_in_vec_AZ,idot_in_vec_LX,idot_in_vec_LY,idot_in_vec_LZ;
   wire signed[(WIDTH-1):0]
      idot_out_AX,idot_out_AY,idot_out_AZ,idot_out_LX,idot_out_LY,idot_out_LZ;
   // xdot
   wire signed[(WIDTH-1):0]
      xdot_in_vec_AX,xdot_in_vec_AY,xdot_in_vec_AZ,xdot_in_vec_LX,xdot_in_vec_LY,xdot_in_vec_LZ;
   wire signed[(WIDTH-1):0]
      xdot_out_AX,xdot_out_AY,xdot_out_AZ,xdot_out_LX,xdot_out_LY,xdot_out_LZ;
   // vjdot
   wire signed[(WIDTH-1):0]
      vjdot_out_AX,vjdot_out_AY,vjdot_out_AZ,vjdot_out_LX,vjdot_out_LY,vjdot_out_LZ;
   // add3
   wire signed[(WIDTH-1):0]
      add3_temp_AX,add3_temp_AY,add3_temp_AZ,add3_temp_LX,add3_temp_LY,add3_temp_LZ;
   wire signed[(WIDTH-1):0]
      add3_out_AX,add3_out_AY,add3_out_AZ,add3_out_LX,add3_out_LY,add3_out_LZ;
   // add2
   wire signed[(WIDTH-1):0]
      add2_out_AX,add2_out_AY,add2_out_AZ,add2_out_LX,add2_out_LY,add2_out_LZ;
   // mx1
   wire signed[(WIDTH-1):0]
      mx1_out_AX,mx1_out_AY,mx1_out_AZ,mx1_out_LX,mx1_out_LY,mx1_out_LZ;
   // mxv
   wire signed[(WIDTH-1):0]
      mxv_out_AX,mxv_out_AY,mxv_out_AZ,mxv_out_LX,mxv_out_LY,mxv_out_LZ;

   // xform generation
   xgens7#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      xgens_unit(
      // link_in
      .link_in(link_in),
      // sin(q) and cos(q)
      .sinq_in(sinq_in),.cosq_in(cosq_in),
      // xform_out, 15 values
      .xform_out_AX_AX(xgens_out_AX_AX),.xform_out_AX_AY(xgens_out_AX_AY),.xform_out_AX_AZ(xgens_out_AX_AZ),
      .xform_out_AY_AX(xgens_out_AY_AX),.xform_out_AY_AY(xgens_out_AY_AY),.xform_out_AY_AZ(xgens_out_AY_AZ),
                                       .xform_out_AZ_AY(xgens_out_AZ_AY),.xform_out_AZ_AZ(xgens_out_AZ_AZ),
      .xform_out_LX_AX(xgens_out_LX_AX),.xform_out_LX_AY(xgens_out_LX_AY),.xform_out_LX_AZ(xgens_out_LX_AZ),
      .xform_out_LY_AX(xgens_out_LY_AX),.xform_out_LY_AY(xgens_out_LY_AY),.xform_out_LY_AZ(xgens_out_LY_AZ),
      .xform_out_LZ_AX(xgens_out_LZ_AX)                                                                  
      );

   // input muxes
   // xform
   assign xform_AX_AX  = s1_bool ? xgens_out_AX_AX : xform_in_AX_AX;
   assign xform_AX_AY  = s1_bool ? xgens_out_AX_AY : xform_in_AX_AY;
   assign xform_AX_AZ  = s1_bool ? xgens_out_AX_AZ : xform_in_AX_AZ;
   assign xform_AY_AX  = s1_bool ? xgens_out_AY_AX : xform_in_AY_AX;
   assign xform_AY_AY  = s1_bool ? xgens_out_AY_AY : xform_in_AY_AY;
   assign xform_AY_AZ  = s1_bool ? xgens_out_AY_AZ : xform_in_AY_AZ;
   assign xform_AZ_AY  = s1_bool ? xgens_out_AZ_AY : xform_in_AZ_AY;
   assign xform_AZ_AZ  = s1_bool ? xgens_out_AZ_AZ : xform_in_AZ_AZ;
   assign xform_LX_AX  = s1_bool ? xgens_out_LX_AX : xform_in_LX_AX;
   assign xform_LX_AY  = s1_bool ? xgens_out_LX_AY : xform_in_LX_AY;
   assign xform_LX_AZ  = s1_bool ? xgens_out_LX_AZ : xform_in_LX_AZ;
   assign xform_LY_AX  = s1_bool ? xgens_out_LY_AX : xform_in_LY_AX;
   assign xform_LY_AY  = s1_bool ? xgens_out_LY_AY : xform_in_LY_AY;
   assign xform_LY_AZ  = s1_bool ? xgens_out_LY_AZ : xform_in_LY_AZ;
   assign xform_LZ_AX  = s1_bool ? xgens_out_LZ_AX : xform_in_LZ_AX;
   // fxdot
   assign fxdot_in_fxvec_AX  = s2_bool ? s2r5_in_AX : s3r2_in_AX;
   assign fxdot_in_fxvec_AY  = s2_bool ? s2r5_in_AY : s3r2_in_AY;
   assign fxdot_in_fxvec_AZ  = s2_bool ? s2r5_in_AZ : s3r2_in_AZ;
   assign fxdot_in_fxvec_LX  = s2_bool ? s2r5_in_LX : s3r2_in_LX;
   assign fxdot_in_fxvec_LY  = s2_bool ? s2r5_in_LY : s3r2_in_LY;
   assign fxdot_in_fxvec_LZ  = s2_bool ? s2r5_in_LZ : s3r2_in_LZ;
   assign fxdot_in_dotvec_AX = s2_bool ? s2r2_in_AX : s3r3_in_AX;
   assign fxdot_in_dotvec_AY = s2_bool ? s2r2_in_AY : s3r3_in_AY;
   assign fxdot_in_dotvec_AZ = s2_bool ? s2r2_in_AZ : s3r3_in_AZ;
   assign fxdot_in_dotvec_LX = s2_bool ? s2r2_in_LX : s3r3_in_LX;
   assign fxdot_in_dotvec_LY = s2_bool ? s2r2_in_LY : s3r3_in_LY;
   assign fxdot_in_dotvec_LZ = s2_bool ? s2r2_in_LZ : s3r3_in_LZ;
   // idot
   assign idot_in_vec_AX = s1_bool ? s1r1_in_AX :
                           s2_bool ? s2r5_in_AX : s3r4_in_AX;
   assign idot_in_vec_AY = s1_bool ? s1r1_in_AY :
                           s2_bool ? s2r5_in_AY : s3r4_in_AY;
   assign idot_in_vec_AZ = s1_bool ? s1r1_in_AZ :
                           s2_bool ? s2r5_in_AZ : s3r4_in_AZ;
   assign idot_in_vec_LX = s1_bool ? s1r1_in_LX :
                           s2_bool ? s2r5_in_LX : s3r4_in_LX;
   assign idot_in_vec_LY = s1_bool ? s1r1_in_LY :
                           s2_bool ? s2r5_in_LY : s3r4_in_LY;
   assign idot_in_vec_LZ = s1_bool ? s1r1_in_LZ :
                           s2_bool ? s2r5_in_LZ : s3r4_in_LZ;
   // xdot
   assign xdot_in_vec_AX  = s1_bool ? s1r4_in_AX : s2r3_in_AX;
   assign xdot_in_vec_AY  = s1_bool ? s1r4_in_AY : s2r3_in_AY;
   assign xdot_in_vec_AZ  = s1_bool ? s1r4_in_AZ : s2r3_in_AZ;
   assign xdot_in_vec_LX  = s1_bool ? s1r4_in_LX : s2r3_in_LX;
   assign xdot_in_vec_LY  = s1_bool ? s1r4_in_LY : s2r3_in_LY;
   assign xdot_in_vec_LZ  = s1_bool ? s1r4_in_LZ : s2r3_in_LZ;

   // functional units
   // fxdot
   fxdot#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      fxdot_unit(
      // fxvec_in, 6 values
      .fxvec_in_AX(fxdot_in_fxvec_AX),.fxvec_in_AY(fxdot_in_fxvec_AY),.fxvec_in_AZ(fxdot_in_fxvec_AZ),.fxvec_in_LX(fxdot_in_fxvec_LX),.fxvec_in_LY(fxdot_in_fxvec_LY),.fxvec_in_LZ(fxdot_in_fxvec_LZ),
      // dotvec_in, 6 values
      .dotvec_in_AX(fxdot_in_dotvec_AX),.dotvec_in_AY(fxdot_in_dotvec_AY),.dotvec_in_AZ(fxdot_in_dotvec_AZ),.dotvec_in_LX(fxdot_in_dotvec_LX),.dotvec_in_LY(fxdot_in_dotvec_LY),.dotvec_in_LZ(fxdot_in_dotvec_LZ),
      // fxdotvec_out, 6 values
      .fxdotvec_out_AX(fxdot_out_AX),.fxdotvec_out_AY(fxdot_out_AY),.fxdotvec_out_AZ(fxdot_out_AZ),.fxdotvec_out_LX(fxdot_out_LX),.fxdotvec_out_LY(fxdot_out_LY),.fxdotvec_out_LZ(fxdot_out_LZ)
      );
   // idots
   idots7#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      idots_unit(
      // link_in
      .link_in(link_in),
      // vec_in, 6 values
      .vec_in_AX(idot_in_vec_AX),.vec_in_AY(idot_in_vec_AY),.vec_in_AZ(idot_in_vec_AZ),.vec_in_LX(idot_in_vec_LX),.vec_in_LY(idot_in_vec_LY),.vec_in_LZ(idot_in_vec_LZ),
      // ivec_out, 6 values
      .ivec_out_AX(idot_out_AX),.ivec_out_AY(idot_out_AY),.ivec_out_AZ(idot_out_AZ),.ivec_out_LX(idot_out_LX),.ivec_out_LY(idot_out_LY),.ivec_out_LZ(idot_out_LZ)
      );
   // xdot
   xdot#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      xdot_unit(
      // mcross boolean
      .mcross(1'b0),
      // xform_in, 23 values
      .xform_in_AX_AX(xform_AX_AX),.xform_in_AX_AY(xform_AX_AY),.xform_in_AX_AZ(xform_AX_AZ),                                                                                    
      .xform_in_AY_AX(xform_AY_AX),.xform_in_AY_AY(xform_AY_AY),.xform_in_AY_AZ(xform_AY_AZ),                                                                                    
                                  .xform_in_AZ_AY(xform_AZ_AY),.xform_in_AZ_AZ(xform_AZ_AZ),                                                                                    
      .xform_in_LX_AX(xform_LX_AX),.xform_in_LX_AY(xform_LX_AY),.xform_in_LX_AZ(xform_LX_AZ),.xform_in_LX_LX(xform_AX_AX),.xform_in_LX_LY(xform_AX_AY),.xform_in_LX_LZ(xform_AX_AZ),
      .xform_in_LY_AX(xform_LY_AX),.xform_in_LY_AY(xform_LY_AY),.xform_in_LY_AZ(xform_LY_AZ),.xform_in_LY_LX(xform_AY_AX),.xform_in_LY_LY(xform_AY_AY),.xform_in_LY_LZ(xform_AY_AZ),
      .xform_in_LZ_AX(xform_LZ_AX),                                                                                    .xform_in_LZ_LY(xform_AZ_AY),.xform_in_LZ_LZ(xform_AZ_AZ),
      // vec_in, 6 values
      .vec_in_AX(xdot_in_vec_AX),.vec_in_AY(xdot_in_vec_AY),.vec_in_AZ(xdot_in_vec_AZ),.vec_in_LX(xdot_in_vec_LX),.vec_in_LY(xdot_in_vec_LY),.vec_in_LZ(xdot_in_vec_LZ),
      // xvec_out, 6 values
      .xvec_out_AX(xdot_out_AX),.xvec_out_AY(xdot_out_AY),.xvec_out_AZ(xdot_out_AZ),.xvec_out_LX(xdot_out_LX),.xvec_out_LY(xdot_out_LY),.xvec_out_LZ(xdot_out_LZ)
      );
   // vjdot
   vjdot#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      vjdot_dadqd(
      // vjval_in
      .vjval_in(s2r4_in),
      // colvec_in, 6 values
      .colvec_in_AX(s2r5_in_AX),.colvec_in_AY(s2r5_in_AY),.colvec_in_AZ(s2r5_in_AZ),.colvec_in_LX(s2r5_in_LX),.colvec_in_LY(s2r5_in_LY),.colvec_in_LZ(s2r5_in_LZ),
      // vjvec_out, 6 values
      .vjvec_out_AX(vjdot_out_AX),.vjvec_out_AY(vjdot_out_AY),.vjvec_out_AZ(vjdot_out_AZ),.vjvec_out_LX(vjdot_out_LX),.vjvec_out_LY(vjdot_out_LY),.vjvec_out_LZ(vjdot_out_LZ)
      );
   // add3
   // (6 add)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add3_unit1_AX(.a_in(s3r1_in_AX),.b_in(fxdot_out_AX),.sum_out(add3_temp_AX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add3_unit1_AY(.a_in(s3r1_in_AY),.b_in(fxdot_out_AY),.sum_out(add3_temp_AY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add3_unit1_AZ(.a_in(s3r1_in_AZ),.b_in(fxdot_out_AZ),.sum_out(add3_temp_AZ));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add3_unit1_LX(.a_in(s3r1_in_LX),.b_in(fxdot_out_LX),.sum_out(add3_temp_LX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add3_unit1_LY(.a_in(s3r1_in_LY),.b_in(fxdot_out_LY),.sum_out(add3_temp_LY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add3_unit1_LZ(.a_in(s3r1_in_LZ),.b_in(fxdot_out_LZ),.sum_out(add3_temp_LZ));
   // (6 add)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add3_unit2_AX(.a_in(add3_temp_AX),.b_in(idot_out_AX),.sum_out(add3_out_AX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add3_unit2_AY(.a_in(add3_temp_AY),.b_in(idot_out_AY),.sum_out(add3_out_AY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add3_unit2_AZ(.a_in(add3_temp_AZ),.b_in(idot_out_AZ),.sum_out(add3_out_AZ));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add3_unit2_LX(.a_in(add3_temp_LX),.b_in(idot_out_LX),.sum_out(add3_out_LX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add3_unit2_LY(.a_in(add3_temp_LY),.b_in(idot_out_LY),.sum_out(add3_out_LY));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add3_unit2_LZ(.a_in(add3_temp_LZ),.b_in(idot_out_LZ),.sum_out(add3_out_LZ));
   // add2
   // (4 adds)
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add2_unit_AX(.a_in(xdot_out_AX),.b_in(vjdot_out_AX),.sum_out(add2_out_AX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add2_unit_AY(.a_in(xdot_out_AY),.b_in(vjdot_out_AY),.sum_out(add2_out_AY));
   assign add2_out_AZ = xdot_out_AZ;
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add2_unit_LX(.a_in(xdot_out_LX),.b_in(vjdot_out_LX),.sum_out(add2_out_LX));
   add#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      add2_unit_LY(.a_in(xdot_out_LY),.b_in(vjdot_out_LY),.sum_out(add2_out_LY));
   assign add2_out_LZ = xdot_out_LZ;
   // mx1
   // (1 add)
   assign mx1_out_AX = xdot_out_AX;
   assign mx1_out_AY = xdot_out_AY;
   assign mx1_out_AZ = mcross ? xdot_out_AZ + 32'd65536 : xdot_out_AZ;
   assign mx1_out_LX = xdot_out_LX;
   assign mx1_out_LY = xdot_out_LY;
   assign mx1_out_LZ = xdot_out_LZ;
   // mxv
   // (4 adds)
   assign mxv_out_AX = mcross ? add2_out_AX +  s2r1_in_AY : add2_out_AX;
   assign mxv_out_AY = mcross ? add2_out_AY + -s2r1_in_AX : add2_out_AY;
   assign mxv_out_AZ = add2_out_AZ;
   assign mxv_out_LX = mcross ? add2_out_LX +  s2r1_in_LY : add2_out_LX;
   assign mxv_out_LY = mcross ? add2_out_LY + -s2r1_in_LX : add2_out_LY;
   assign mxv_out_LZ = add2_out_LZ;

   // outputs
   assign xform_out_AX_AX = xform_AX_AX;
   assign xform_out_AX_AY = xform_AX_AY;
   assign xform_out_AX_AZ = xform_AX_AZ;
   assign xform_out_AY_AX = xform_AY_AX;
   assign xform_out_AY_AY = xform_AY_AY;
   assign xform_out_AY_AZ = xform_AY_AZ;
   assign xform_out_AZ_AY = xform_AZ_AY;
   assign xform_out_AZ_AZ = xform_AZ_AZ;
   assign xform_out_LX_AX = xform_LX_AX;
   assign xform_out_LX_AY = xform_LX_AY;
   assign xform_out_LX_AZ = xform_LX_AZ;
   assign xform_out_LY_AX = xform_LY_AX;
   assign xform_out_LY_AY = xform_LY_AY;
   assign xform_out_LY_AZ = xform_LY_AZ;
   assign xform_out_LZ_AX = xform_LZ_AX;
   // stage 1
   // s1r1_out = s1r1_in
   assign s1r1_out_AX = s1r1_in_AX;
   assign s1r1_out_AY = s1r1_in_AY;
   assign s1r1_out_AZ = s1r1_in_AZ;
   assign s1r1_out_LX = s1r1_in_LX;
   assign s1r1_out_LY = s1r1_in_LY;
   assign s1r1_out_LZ = s1r1_in_LZ;
   // s1r2_out = idot_out
   assign s1r2_out_AX = idot_out_AX;
   assign s1r2_out_AY = idot_out_AY;
   assign s1r2_out_AZ = idot_out_AZ;
   assign s1r2_out_LX = idot_out_LX;
   assign s1r2_out_LY = idot_out_LY;
   assign s1r2_out_LZ = idot_out_LZ;
   // s1r3_out = s1r2_in
   assign s1r3_out_AX = s1r2_in_AX;
   assign s1r3_out_AY = s1r2_in_AY;
   assign s1r3_out_AZ = s1r2_in_AZ;
   assign s1r3_out_LX = s1r2_in_LX;
   assign s1r3_out_LY = s1r2_in_LY;
   assign s1r3_out_LZ = s1r2_in_LZ;
   // s1r4_out = s1r3_in
   assign s1r4_out = s1r3_in;
   // s1r5_out = xdot_out
   assign s1r5_out_AX = mx1_out_AX;
   assign s1r5_out_AY = mx1_out_AY;
   assign s1r5_out_AZ = mx1_out_AZ;
   assign s1r5_out_LX = mx1_out_LX;
   assign s1r5_out_LY = mx1_out_LY;
   assign s1r5_out_LZ = mx1_out_LZ;
   // stage 2
   // s2r1_out = fxdot_out
   assign s2r1_out_AX = fxdot_out_AX;
   assign s2r1_out_AY = fxdot_out_AY;
   assign s2r1_out_AZ = fxdot_out_AZ;
   assign s2r1_out_LX = fxdot_out_LX;
   assign s2r1_out_LY = fxdot_out_LY;
   assign s2r1_out_LZ = fxdot_out_LZ;
   // s2r2_out = s2r1_in
   assign s2r2_out_AX = s2r1_in_AX;
   assign s2r2_out_AY = s2r1_in_AY;
   assign s2r2_out_AZ = s2r1_in_AZ;
   assign s2r2_out_LX = s2r1_in_LX;
   assign s2r2_out_LY = s2r1_in_LY;
   assign s2r2_out_LZ = s2r1_in_LZ;
   // s2r3_out = idot_out
   assign s2r3_out_AX = idot_out_AX;
   assign s2r3_out_AY = idot_out_AY;
   assign s2r3_out_AZ = idot_out_AZ;
   assign s2r3_out_LX = idot_out_LX;
   assign s2r3_out_LY = idot_out_LY;
   assign s2r3_out_LZ = idot_out_LZ;
   // s2r4_out = add2_out
   assign s2r4_out_AX = mxv_out_AX;
   assign s2r4_out_AY = mxv_out_AY;
   assign s2r4_out_AZ = mxv_out_AZ;
   assign s2r4_out_LX = mxv_out_LX;
   assign s2r4_out_LY = mxv_out_LY;
   assign s2r4_out_LZ = mxv_out_LZ;
   // s2r5_out = s2r5_in
   assign s2r5_out_AX = s2r5_in_AX;
   assign s2r5_out_AY = s2r5_in_AY;
   assign s2r5_out_AZ = s2r5_in_AZ;
   assign s2r5_out_LX = s2r5_in_LX;
   assign s2r5_out_LY = s2r5_in_LY;
   assign s2r5_out_LZ = s2r5_in_LZ;
   // stage 3
   // s3r1_out = add3_out
   assign s3r1_out_AX = add3_out_AX;
   assign s3r1_out_AY = add3_out_AY;
   assign s3r1_out_AZ = add3_out_AZ;
   assign s3r1_out_LX = add3_out_LX;
   assign s3r1_out_LY = add3_out_LY;
   assign s3r1_out_LZ = add3_out_LZ;
   // s3r2_out = s3r4_in
   assign s3r2_out_AX = s3r4_in_AX;
   assign s3r2_out_AY = s3r4_in_AY;
   assign s3r2_out_AZ = s3r4_in_AZ;
   assign s3r2_out_LX = s3r4_in_LX;
   assign s3r2_out_LY = s3r4_in_LY;
   assign s3r2_out_LZ = s3r4_in_LZ;
   // s3r3_out = s3r5_in
   assign s3r3_out_AX = s3r5_in_AX;
   assign s3r3_out_AY = s3r5_in_AY;
   assign s3r3_out_AZ = s3r5_in_AZ;
   assign s3r3_out_LX = s3r5_in_LX;
   assign s3r3_out_LY = s3r5_in_LY;
   assign s3r3_out_LZ = s3r5_in_LZ;

endmodule
