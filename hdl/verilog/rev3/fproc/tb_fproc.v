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
   //---------------------------------------------------------------------------
   // rnea external inputs
   //---------------------------------------------------------------------------
   // rnea
   reg [2:0]
      link_in_rnea;
   reg signed[(WIDTH-1):0]
      sinq_val_in_rnea,cosq_val_in_rnea,
      qd_val_in_rnea,
      qdd_val_in_rnea,
      v_prev_vec_in_AX_rnea,v_prev_vec_in_AY_rnea,v_prev_vec_in_AZ_rnea,v_prev_vec_in_LX_rnea,v_prev_vec_in_LY_rnea,v_prev_vec_in_LZ_rnea,
      a_prev_vec_in_AX_rnea,a_prev_vec_in_AY_rnea,a_prev_vec_in_AZ_rnea,a_prev_vec_in_LX_rnea,a_prev_vec_in_LY_rnea,a_prev_vec_in_LZ_rnea;
   //---------------------------------------------------------------------------
   // dq external inputs
   //---------------------------------------------------------------------------
   // dqPE1
   reg [2:0]
      link_in_dqPE1;
   reg [2:0]
      derv_in_dqPE1;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE1,cosq_val_in_dqPE1,
      qd_val_in_dqPE1,
      v_curr_vec_in_AX_dqPE1,v_curr_vec_in_AY_dqPE1,v_curr_vec_in_AZ_dqPE1,v_curr_vec_in_LX_dqPE1,v_curr_vec_in_LY_dqPE1,v_curr_vec_in_LZ_dqPE1,
      a_curr_vec_in_AX_dqPE1,a_curr_vec_in_AY_dqPE1,a_curr_vec_in_AZ_dqPE1,a_curr_vec_in_LX_dqPE1,a_curr_vec_in_LY_dqPE1,a_curr_vec_in_LZ_dqPE1,
      v_prev_vec_in_AX_dqPE1,v_prev_vec_in_AY_dqPE1,v_prev_vec_in_AZ_dqPE1,v_prev_vec_in_LX_dqPE1,v_prev_vec_in_LY_dqPE1,v_prev_vec_in_LZ_dqPE1,
      a_prev_vec_in_AX_dqPE1,a_prev_vec_in_AY_dqPE1,a_prev_vec_in_AZ_dqPE1,a_prev_vec_in_LX_dqPE1,a_prev_vec_in_LY_dqPE1,a_prev_vec_in_LZ_dqPE1,
      dvdq_prev_vec_in_AX_dqPE1,dvdq_prev_vec_in_AY_dqPE1,dvdq_prev_vec_in_AZ_dqPE1,dvdq_prev_vec_in_LX_dqPE1,dvdq_prev_vec_in_LY_dqPE1,dvdq_prev_vec_in_LZ_dqPE1,
      dadq_prev_vec_in_AX_dqPE1,dadq_prev_vec_in_AY_dqPE1,dadq_prev_vec_in_AZ_dqPE1,dadq_prev_vec_in_LX_dqPE1,dadq_prev_vec_in_LY_dqPE1,dadq_prev_vec_in_LZ_dqPE1;
   // dqPE2
   reg [2:0]
      link_in_dqPE2;
   reg [2:0]
      derv_in_dqPE2;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE2,cosq_val_in_dqPE2,
      qd_val_in_dqPE2,
      v_curr_vec_in_AX_dqPE2,v_curr_vec_in_AY_dqPE2,v_curr_vec_in_AZ_dqPE2,v_curr_vec_in_LX_dqPE2,v_curr_vec_in_LY_dqPE2,v_curr_vec_in_LZ_dqPE2,
      a_curr_vec_in_AX_dqPE2,a_curr_vec_in_AY_dqPE2,a_curr_vec_in_AZ_dqPE2,a_curr_vec_in_LX_dqPE2,a_curr_vec_in_LY_dqPE2,a_curr_vec_in_LZ_dqPE2,
      v_prev_vec_in_AX_dqPE2,v_prev_vec_in_AY_dqPE2,v_prev_vec_in_AZ_dqPE2,v_prev_vec_in_LX_dqPE2,v_prev_vec_in_LY_dqPE2,v_prev_vec_in_LZ_dqPE2,
      a_prev_vec_in_AX_dqPE2,a_prev_vec_in_AY_dqPE2,a_prev_vec_in_AZ_dqPE2,a_prev_vec_in_LX_dqPE2,a_prev_vec_in_LY_dqPE2,a_prev_vec_in_LZ_dqPE2,
      dvdq_prev_vec_in_AX_dqPE2,dvdq_prev_vec_in_AY_dqPE2,dvdq_prev_vec_in_AZ_dqPE2,dvdq_prev_vec_in_LX_dqPE2,dvdq_prev_vec_in_LY_dqPE2,dvdq_prev_vec_in_LZ_dqPE2,
      dadq_prev_vec_in_AX_dqPE2,dadq_prev_vec_in_AY_dqPE2,dadq_prev_vec_in_AZ_dqPE2,dadq_prev_vec_in_LX_dqPE2,dadq_prev_vec_in_LY_dqPE2,dadq_prev_vec_in_LZ_dqPE2;
   // dqPE3
   reg [2:0]
      link_in_dqPE3;
   reg [2:0]
      derv_in_dqPE3;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE3,cosq_val_in_dqPE3,
      qd_val_in_dqPE3,
      v_curr_vec_in_AX_dqPE3,v_curr_vec_in_AY_dqPE3,v_curr_vec_in_AZ_dqPE3,v_curr_vec_in_LX_dqPE3,v_curr_vec_in_LY_dqPE3,v_curr_vec_in_LZ_dqPE3,
      a_curr_vec_in_AX_dqPE3,a_curr_vec_in_AY_dqPE3,a_curr_vec_in_AZ_dqPE3,a_curr_vec_in_LX_dqPE3,a_curr_vec_in_LY_dqPE3,a_curr_vec_in_LZ_dqPE3,
      v_prev_vec_in_AX_dqPE3,v_prev_vec_in_AY_dqPE3,v_prev_vec_in_AZ_dqPE3,v_prev_vec_in_LX_dqPE3,v_prev_vec_in_LY_dqPE3,v_prev_vec_in_LZ_dqPE3,
      a_prev_vec_in_AX_dqPE3,a_prev_vec_in_AY_dqPE3,a_prev_vec_in_AZ_dqPE3,a_prev_vec_in_LX_dqPE3,a_prev_vec_in_LY_dqPE3,a_prev_vec_in_LZ_dqPE3,
      dvdq_prev_vec_in_AX_dqPE3,dvdq_prev_vec_in_AY_dqPE3,dvdq_prev_vec_in_AZ_dqPE3,dvdq_prev_vec_in_LX_dqPE3,dvdq_prev_vec_in_LY_dqPE3,dvdq_prev_vec_in_LZ_dqPE3,
      dadq_prev_vec_in_AX_dqPE3,dadq_prev_vec_in_AY_dqPE3,dadq_prev_vec_in_AZ_dqPE3,dadq_prev_vec_in_LX_dqPE3,dadq_prev_vec_in_LY_dqPE3,dadq_prev_vec_in_LZ_dqPE3;
   // dqPE4
   reg [2:0]
      link_in_dqPE4;
   reg [2:0]
      derv_in_dqPE4;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE4,cosq_val_in_dqPE4,
      qd_val_in_dqPE4,
      v_curr_vec_in_AX_dqPE4,v_curr_vec_in_AY_dqPE4,v_curr_vec_in_AZ_dqPE4,v_curr_vec_in_LX_dqPE4,v_curr_vec_in_LY_dqPE4,v_curr_vec_in_LZ_dqPE4,
      a_curr_vec_in_AX_dqPE4,a_curr_vec_in_AY_dqPE4,a_curr_vec_in_AZ_dqPE4,a_curr_vec_in_LX_dqPE4,a_curr_vec_in_LY_dqPE4,a_curr_vec_in_LZ_dqPE4,
      v_prev_vec_in_AX_dqPE4,v_prev_vec_in_AY_dqPE4,v_prev_vec_in_AZ_dqPE4,v_prev_vec_in_LX_dqPE4,v_prev_vec_in_LY_dqPE4,v_prev_vec_in_LZ_dqPE4,
      a_prev_vec_in_AX_dqPE4,a_prev_vec_in_AY_dqPE4,a_prev_vec_in_AZ_dqPE4,a_prev_vec_in_LX_dqPE4,a_prev_vec_in_LY_dqPE4,a_prev_vec_in_LZ_dqPE4,
      dvdq_prev_vec_in_AX_dqPE4,dvdq_prev_vec_in_AY_dqPE4,dvdq_prev_vec_in_AZ_dqPE4,dvdq_prev_vec_in_LX_dqPE4,dvdq_prev_vec_in_LY_dqPE4,dvdq_prev_vec_in_LZ_dqPE4,
      dadq_prev_vec_in_AX_dqPE4,dadq_prev_vec_in_AY_dqPE4,dadq_prev_vec_in_AZ_dqPE4,dadq_prev_vec_in_LX_dqPE4,dadq_prev_vec_in_LY_dqPE4,dadq_prev_vec_in_LZ_dqPE4;
   // dqPE5
   reg [2:0]
      link_in_dqPE5;
   reg [2:0]
      derv_in_dqPE5;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE5,cosq_val_in_dqPE5,
      qd_val_in_dqPE5,
      v_curr_vec_in_AX_dqPE5,v_curr_vec_in_AY_dqPE5,v_curr_vec_in_AZ_dqPE5,v_curr_vec_in_LX_dqPE5,v_curr_vec_in_LY_dqPE5,v_curr_vec_in_LZ_dqPE5,
      a_curr_vec_in_AX_dqPE5,a_curr_vec_in_AY_dqPE5,a_curr_vec_in_AZ_dqPE5,a_curr_vec_in_LX_dqPE5,a_curr_vec_in_LY_dqPE5,a_curr_vec_in_LZ_dqPE5,
      v_prev_vec_in_AX_dqPE5,v_prev_vec_in_AY_dqPE5,v_prev_vec_in_AZ_dqPE5,v_prev_vec_in_LX_dqPE5,v_prev_vec_in_LY_dqPE5,v_prev_vec_in_LZ_dqPE5,
      a_prev_vec_in_AX_dqPE5,a_prev_vec_in_AY_dqPE5,a_prev_vec_in_AZ_dqPE5,a_prev_vec_in_LX_dqPE5,a_prev_vec_in_LY_dqPE5,a_prev_vec_in_LZ_dqPE5,
      dvdq_prev_vec_in_AX_dqPE5,dvdq_prev_vec_in_AY_dqPE5,dvdq_prev_vec_in_AZ_dqPE5,dvdq_prev_vec_in_LX_dqPE5,dvdq_prev_vec_in_LY_dqPE5,dvdq_prev_vec_in_LZ_dqPE5,
      dadq_prev_vec_in_AX_dqPE5,dadq_prev_vec_in_AY_dqPE5,dadq_prev_vec_in_AZ_dqPE5,dadq_prev_vec_in_LX_dqPE5,dadq_prev_vec_in_LY_dqPE5,dadq_prev_vec_in_LZ_dqPE5;
   // dqPE6
   reg [2:0]
      link_in_dqPE6;
   reg [2:0]
      derv_in_dqPE6;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE6,cosq_val_in_dqPE6,
      qd_val_in_dqPE6,
      v_curr_vec_in_AX_dqPE6,v_curr_vec_in_AY_dqPE6,v_curr_vec_in_AZ_dqPE6,v_curr_vec_in_LX_dqPE6,v_curr_vec_in_LY_dqPE6,v_curr_vec_in_LZ_dqPE6,
      a_curr_vec_in_AX_dqPE6,a_curr_vec_in_AY_dqPE6,a_curr_vec_in_AZ_dqPE6,a_curr_vec_in_LX_dqPE6,a_curr_vec_in_LY_dqPE6,a_curr_vec_in_LZ_dqPE6,
      v_prev_vec_in_AX_dqPE6,v_prev_vec_in_AY_dqPE6,v_prev_vec_in_AZ_dqPE6,v_prev_vec_in_LX_dqPE6,v_prev_vec_in_LY_dqPE6,v_prev_vec_in_LZ_dqPE6,
      a_prev_vec_in_AX_dqPE6,a_prev_vec_in_AY_dqPE6,a_prev_vec_in_AZ_dqPE6,a_prev_vec_in_LX_dqPE6,a_prev_vec_in_LY_dqPE6,a_prev_vec_in_LZ_dqPE6,
      dvdq_prev_vec_in_AX_dqPE6,dvdq_prev_vec_in_AY_dqPE6,dvdq_prev_vec_in_AZ_dqPE6,dvdq_prev_vec_in_LX_dqPE6,dvdq_prev_vec_in_LY_dqPE6,dvdq_prev_vec_in_LZ_dqPE6,
      dadq_prev_vec_in_AX_dqPE6,dadq_prev_vec_in_AY_dqPE6,dadq_prev_vec_in_AZ_dqPE6,dadq_prev_vec_in_LX_dqPE6,dadq_prev_vec_in_LY_dqPE6,dadq_prev_vec_in_LZ_dqPE6;
   // dqPE7
   reg [2:0]
      link_in_dqPE7;
   reg [2:0]
      derv_in_dqPE7;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE7,cosq_val_in_dqPE7,
      qd_val_in_dqPE7,
      v_curr_vec_in_AX_dqPE7,v_curr_vec_in_AY_dqPE7,v_curr_vec_in_AZ_dqPE7,v_curr_vec_in_LX_dqPE7,v_curr_vec_in_LY_dqPE7,v_curr_vec_in_LZ_dqPE7,
      a_curr_vec_in_AX_dqPE7,a_curr_vec_in_AY_dqPE7,a_curr_vec_in_AZ_dqPE7,a_curr_vec_in_LX_dqPE7,a_curr_vec_in_LY_dqPE7,a_curr_vec_in_LZ_dqPE7,
      v_prev_vec_in_AX_dqPE7,v_prev_vec_in_AY_dqPE7,v_prev_vec_in_AZ_dqPE7,v_prev_vec_in_LX_dqPE7,v_prev_vec_in_LY_dqPE7,v_prev_vec_in_LZ_dqPE7,
      a_prev_vec_in_AX_dqPE7,a_prev_vec_in_AY_dqPE7,a_prev_vec_in_AZ_dqPE7,a_prev_vec_in_LX_dqPE7,a_prev_vec_in_LY_dqPE7,a_prev_vec_in_LZ_dqPE7,
      dvdq_prev_vec_in_AX_dqPE7,dvdq_prev_vec_in_AY_dqPE7,dvdq_prev_vec_in_AZ_dqPE7,dvdq_prev_vec_in_LX_dqPE7,dvdq_prev_vec_in_LY_dqPE7,dvdq_prev_vec_in_LZ_dqPE7,
      dadq_prev_vec_in_AX_dqPE7,dadq_prev_vec_in_AY_dqPE7,dadq_prev_vec_in_AZ_dqPE7,dadq_prev_vec_in_LX_dqPE7,dadq_prev_vec_in_LY_dqPE7,dadq_prev_vec_in_LZ_dqPE7;
   //---------------------------------------------------------------------------
   // dqd external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   reg [2:0]
      link_in_dqdPE1;
   reg [2:0]
      derv_in_dqdPE1;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE1,cosq_val_in_dqdPE1,
      qd_val_in_dqdPE1,
      v_curr_vec_in_AX_dqdPE1,v_curr_vec_in_AY_dqdPE1,v_curr_vec_in_AZ_dqdPE1,v_curr_vec_in_LX_dqdPE1,v_curr_vec_in_LY_dqdPE1,v_curr_vec_in_LZ_dqdPE1,
      a_curr_vec_in_AX_dqdPE1,a_curr_vec_in_AY_dqdPE1,a_curr_vec_in_AZ_dqdPE1,a_curr_vec_in_LX_dqdPE1,a_curr_vec_in_LY_dqdPE1,a_curr_vec_in_LZ_dqdPE1,
      dvdqd_prev_vec_in_AX_dqdPE1,dvdqd_prev_vec_in_AY_dqdPE1,dvdqd_prev_vec_in_AZ_dqdPE1,dvdqd_prev_vec_in_LX_dqdPE1,dvdqd_prev_vec_in_LY_dqdPE1,dvdqd_prev_vec_in_LZ_dqdPE1,
      dadqd_prev_vec_in_AX_dqdPE1,dadqd_prev_vec_in_AY_dqdPE1,dadqd_prev_vec_in_AZ_dqdPE1,dadqd_prev_vec_in_LX_dqdPE1,dadqd_prev_vec_in_LY_dqdPE1,dadqd_prev_vec_in_LZ_dqdPE1;
   // dqdPE2
   reg [2:0]
      link_in_dqdPE2;
   reg [2:0]
      derv_in_dqdPE2;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE2,cosq_val_in_dqdPE2,
      qd_val_in_dqdPE2,
      v_curr_vec_in_AX_dqdPE2,v_curr_vec_in_AY_dqdPE2,v_curr_vec_in_AZ_dqdPE2,v_curr_vec_in_LX_dqdPE2,v_curr_vec_in_LY_dqdPE2,v_curr_vec_in_LZ_dqdPE2,
      a_curr_vec_in_AX_dqdPE2,a_curr_vec_in_AY_dqdPE2,a_curr_vec_in_AZ_dqdPE2,a_curr_vec_in_LX_dqdPE2,a_curr_vec_in_LY_dqdPE2,a_curr_vec_in_LZ_dqdPE2,
      dvdqd_prev_vec_in_AX_dqdPE2,dvdqd_prev_vec_in_AY_dqdPE2,dvdqd_prev_vec_in_AZ_dqdPE2,dvdqd_prev_vec_in_LX_dqdPE2,dvdqd_prev_vec_in_LY_dqdPE2,dvdqd_prev_vec_in_LZ_dqdPE2,
      dadqd_prev_vec_in_AX_dqdPE2,dadqd_prev_vec_in_AY_dqdPE2,dadqd_prev_vec_in_AZ_dqdPE2,dadqd_prev_vec_in_LX_dqdPE2,dadqd_prev_vec_in_LY_dqdPE2,dadqd_prev_vec_in_LZ_dqdPE2;
   // dqdPE3
   reg [2:0]
      link_in_dqdPE3;
   reg [2:0]
      derv_in_dqdPE3;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE3,cosq_val_in_dqdPE3,
      qd_val_in_dqdPE3,
      v_curr_vec_in_AX_dqdPE3,v_curr_vec_in_AY_dqdPE3,v_curr_vec_in_AZ_dqdPE3,v_curr_vec_in_LX_dqdPE3,v_curr_vec_in_LY_dqdPE3,v_curr_vec_in_LZ_dqdPE3,
      a_curr_vec_in_AX_dqdPE3,a_curr_vec_in_AY_dqdPE3,a_curr_vec_in_AZ_dqdPE3,a_curr_vec_in_LX_dqdPE3,a_curr_vec_in_LY_dqdPE3,a_curr_vec_in_LZ_dqdPE3,
      dvdqd_prev_vec_in_AX_dqdPE3,dvdqd_prev_vec_in_AY_dqdPE3,dvdqd_prev_vec_in_AZ_dqdPE3,dvdqd_prev_vec_in_LX_dqdPE3,dvdqd_prev_vec_in_LY_dqdPE3,dvdqd_prev_vec_in_LZ_dqdPE3,
      dadqd_prev_vec_in_AX_dqdPE3,dadqd_prev_vec_in_AY_dqdPE3,dadqd_prev_vec_in_AZ_dqdPE3,dadqd_prev_vec_in_LX_dqdPE3,dadqd_prev_vec_in_LY_dqdPE3,dadqd_prev_vec_in_LZ_dqdPE3;
   // dqdPE4
   reg [2:0]
      link_in_dqdPE4;
   reg [2:0]
      derv_in_dqdPE4;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE4,cosq_val_in_dqdPE4,
      qd_val_in_dqdPE4,
      v_curr_vec_in_AX_dqdPE4,v_curr_vec_in_AY_dqdPE4,v_curr_vec_in_AZ_dqdPE4,v_curr_vec_in_LX_dqdPE4,v_curr_vec_in_LY_dqdPE4,v_curr_vec_in_LZ_dqdPE4,
      a_curr_vec_in_AX_dqdPE4,a_curr_vec_in_AY_dqdPE4,a_curr_vec_in_AZ_dqdPE4,a_curr_vec_in_LX_dqdPE4,a_curr_vec_in_LY_dqdPE4,a_curr_vec_in_LZ_dqdPE4,
      dvdqd_prev_vec_in_AX_dqdPE4,dvdqd_prev_vec_in_AY_dqdPE4,dvdqd_prev_vec_in_AZ_dqdPE4,dvdqd_prev_vec_in_LX_dqdPE4,dvdqd_prev_vec_in_LY_dqdPE4,dvdqd_prev_vec_in_LZ_dqdPE4,
      dadqd_prev_vec_in_AX_dqdPE4,dadqd_prev_vec_in_AY_dqdPE4,dadqd_prev_vec_in_AZ_dqdPE4,dadqd_prev_vec_in_LX_dqdPE4,dadqd_prev_vec_in_LY_dqdPE4,dadqd_prev_vec_in_LZ_dqdPE4;
   // dqdPE5
   reg [2:0]
      link_in_dqdPE5;
   reg [2:0]
      derv_in_dqdPE5;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE5,cosq_val_in_dqdPE5,
      qd_val_in_dqdPE5,
      v_curr_vec_in_AX_dqdPE5,v_curr_vec_in_AY_dqdPE5,v_curr_vec_in_AZ_dqdPE5,v_curr_vec_in_LX_dqdPE5,v_curr_vec_in_LY_dqdPE5,v_curr_vec_in_LZ_dqdPE5,
      a_curr_vec_in_AX_dqdPE5,a_curr_vec_in_AY_dqdPE5,a_curr_vec_in_AZ_dqdPE5,a_curr_vec_in_LX_dqdPE5,a_curr_vec_in_LY_dqdPE5,a_curr_vec_in_LZ_dqdPE5,
      dvdqd_prev_vec_in_AX_dqdPE5,dvdqd_prev_vec_in_AY_dqdPE5,dvdqd_prev_vec_in_AZ_dqdPE5,dvdqd_prev_vec_in_LX_dqdPE5,dvdqd_prev_vec_in_LY_dqdPE5,dvdqd_prev_vec_in_LZ_dqdPE5,
      dadqd_prev_vec_in_AX_dqdPE5,dadqd_prev_vec_in_AY_dqdPE5,dadqd_prev_vec_in_AZ_dqdPE5,dadqd_prev_vec_in_LX_dqdPE5,dadqd_prev_vec_in_LY_dqdPE5,dadqd_prev_vec_in_LZ_dqdPE5;
   // dqdPE6
   reg [2:0]
      link_in_dqdPE6;
   reg [2:0]
      derv_in_dqdPE6;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE6,cosq_val_in_dqdPE6,
      qd_val_in_dqdPE6,
      v_curr_vec_in_AX_dqdPE6,v_curr_vec_in_AY_dqdPE6,v_curr_vec_in_AZ_dqdPE6,v_curr_vec_in_LX_dqdPE6,v_curr_vec_in_LY_dqdPE6,v_curr_vec_in_LZ_dqdPE6,
      a_curr_vec_in_AX_dqdPE6,a_curr_vec_in_AY_dqdPE6,a_curr_vec_in_AZ_dqdPE6,a_curr_vec_in_LX_dqdPE6,a_curr_vec_in_LY_dqdPE6,a_curr_vec_in_LZ_dqdPE6,
      dvdqd_prev_vec_in_AX_dqdPE6,dvdqd_prev_vec_in_AY_dqdPE6,dvdqd_prev_vec_in_AZ_dqdPE6,dvdqd_prev_vec_in_LX_dqdPE6,dvdqd_prev_vec_in_LY_dqdPE6,dvdqd_prev_vec_in_LZ_dqdPE6,
      dadqd_prev_vec_in_AX_dqdPE6,dadqd_prev_vec_in_AY_dqdPE6,dadqd_prev_vec_in_AZ_dqdPE6,dadqd_prev_vec_in_LX_dqdPE6,dadqd_prev_vec_in_LY_dqdPE6,dadqd_prev_vec_in_LZ_dqdPE6;
   // dqdPE7
   reg [2:0]
      link_in_dqdPE7;
   reg [2:0]
      derv_in_dqdPE7;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE7,cosq_val_in_dqdPE7,
      qd_val_in_dqdPE7,
      v_curr_vec_in_AX_dqdPE7,v_curr_vec_in_AY_dqdPE7,v_curr_vec_in_AZ_dqdPE7,v_curr_vec_in_LX_dqdPE7,v_curr_vec_in_LY_dqdPE7,v_curr_vec_in_LZ_dqdPE7,
      a_curr_vec_in_AX_dqdPE7,a_curr_vec_in_AY_dqdPE7,a_curr_vec_in_AZ_dqdPE7,a_curr_vec_in_LX_dqdPE7,a_curr_vec_in_LY_dqdPE7,a_curr_vec_in_LZ_dqdPE7,
      dvdqd_prev_vec_in_AX_dqdPE7,dvdqd_prev_vec_in_AY_dqdPE7,dvdqd_prev_vec_in_AZ_dqdPE7,dvdqd_prev_vec_in_LX_dqdPE7,dvdqd_prev_vec_in_LY_dqdPE7,dvdqd_prev_vec_in_LZ_dqdPE7,
      dadqd_prev_vec_in_AX_dqdPE7,dadqd_prev_vec_in_AY_dqdPE7,dadqd_prev_vec_in_AZ_dqdPE7,dadqd_prev_vec_in_LX_dqdPE7,dadqd_prev_vec_in_LY_dqdPE7,dadqd_prev_vec_in_LZ_dqdPE7;
   //---------------------------------------------------------------------------
   // output ready
   wire output_ready;
   // dummy output
   wire dummy_output;
   //---------------------------------------------------------------------------
   // rnea external outputs
   //---------------------------------------------------------------------------
   // rnea
   wire signed[(WIDTH-1):0]
      v_curr_vec_out_AX_rnea,v_curr_vec_out_AY_rnea,v_curr_vec_out_AZ_rnea,v_curr_vec_out_LX_rnea,v_curr_vec_out_LY_rnea,v_curr_vec_out_LZ_rnea,
      a_curr_vec_out_AX_rnea,a_curr_vec_out_AY_rnea,a_curr_vec_out_AZ_rnea,a_curr_vec_out_LX_rnea,a_curr_vec_out_LY_rnea,a_curr_vec_out_LZ_rnea,
      f_curr_vec_out_AX_rnea,f_curr_vec_out_AY_rnea,f_curr_vec_out_AZ_rnea,f_curr_vec_out_LX_rnea,f_curr_vec_out_LY_rnea,f_curr_vec_out_LZ_rnea;
   //---------------------------------------------------------------------------
   // dq external outputs
   //---------------------------------------------------------------------------
   // dqPE1
   wire signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE1,dvdq_curr_vec_out_AY_dqPE1,dvdq_curr_vec_out_AZ_dqPE1,dvdq_curr_vec_out_LX_dqPE1,dvdq_curr_vec_out_LY_dqPE1,dvdq_curr_vec_out_LZ_dqPE1,
      dadq_curr_vec_out_AX_dqPE1,dadq_curr_vec_out_AY_dqPE1,dadq_curr_vec_out_AZ_dqPE1,dadq_curr_vec_out_LX_dqPE1,dadq_curr_vec_out_LY_dqPE1,dadq_curr_vec_out_LZ_dqPE1,
      dfdq_curr_vec_out_AX_dqPE1,dfdq_curr_vec_out_AY_dqPE1,dfdq_curr_vec_out_AZ_dqPE1,dfdq_curr_vec_out_LX_dqPE1,dfdq_curr_vec_out_LY_dqPE1,dfdq_curr_vec_out_LZ_dqPE1;
   // dqPE2
   wire signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE2,dvdq_curr_vec_out_AY_dqPE2,dvdq_curr_vec_out_AZ_dqPE2,dvdq_curr_vec_out_LX_dqPE2,dvdq_curr_vec_out_LY_dqPE2,dvdq_curr_vec_out_LZ_dqPE2,
      dadq_curr_vec_out_AX_dqPE2,dadq_curr_vec_out_AY_dqPE2,dadq_curr_vec_out_AZ_dqPE2,dadq_curr_vec_out_LX_dqPE2,dadq_curr_vec_out_LY_dqPE2,dadq_curr_vec_out_LZ_dqPE2,
      dfdq_curr_vec_out_AX_dqPE2,dfdq_curr_vec_out_AY_dqPE2,dfdq_curr_vec_out_AZ_dqPE2,dfdq_curr_vec_out_LX_dqPE2,dfdq_curr_vec_out_LY_dqPE2,dfdq_curr_vec_out_LZ_dqPE2;
   // dqPE3
   wire signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE3,dvdq_curr_vec_out_AY_dqPE3,dvdq_curr_vec_out_AZ_dqPE3,dvdq_curr_vec_out_LX_dqPE3,dvdq_curr_vec_out_LY_dqPE3,dvdq_curr_vec_out_LZ_dqPE3,
      dadq_curr_vec_out_AX_dqPE3,dadq_curr_vec_out_AY_dqPE3,dadq_curr_vec_out_AZ_dqPE3,dadq_curr_vec_out_LX_dqPE3,dadq_curr_vec_out_LY_dqPE3,dadq_curr_vec_out_LZ_dqPE3,
      dfdq_curr_vec_out_AX_dqPE3,dfdq_curr_vec_out_AY_dqPE3,dfdq_curr_vec_out_AZ_dqPE3,dfdq_curr_vec_out_LX_dqPE3,dfdq_curr_vec_out_LY_dqPE3,dfdq_curr_vec_out_LZ_dqPE3;
   // dqPE4
   wire signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE4,dvdq_curr_vec_out_AY_dqPE4,dvdq_curr_vec_out_AZ_dqPE4,dvdq_curr_vec_out_LX_dqPE4,dvdq_curr_vec_out_LY_dqPE4,dvdq_curr_vec_out_LZ_dqPE4,
      dadq_curr_vec_out_AX_dqPE4,dadq_curr_vec_out_AY_dqPE4,dadq_curr_vec_out_AZ_dqPE4,dadq_curr_vec_out_LX_dqPE4,dadq_curr_vec_out_LY_dqPE4,dadq_curr_vec_out_LZ_dqPE4,
      dfdq_curr_vec_out_AX_dqPE4,dfdq_curr_vec_out_AY_dqPE4,dfdq_curr_vec_out_AZ_dqPE4,dfdq_curr_vec_out_LX_dqPE4,dfdq_curr_vec_out_LY_dqPE4,dfdq_curr_vec_out_LZ_dqPE4;
   // dqPE5
   wire signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE5,dvdq_curr_vec_out_AY_dqPE5,dvdq_curr_vec_out_AZ_dqPE5,dvdq_curr_vec_out_LX_dqPE5,dvdq_curr_vec_out_LY_dqPE5,dvdq_curr_vec_out_LZ_dqPE5,
      dadq_curr_vec_out_AX_dqPE5,dadq_curr_vec_out_AY_dqPE5,dadq_curr_vec_out_AZ_dqPE5,dadq_curr_vec_out_LX_dqPE5,dadq_curr_vec_out_LY_dqPE5,dadq_curr_vec_out_LZ_dqPE5,
      dfdq_curr_vec_out_AX_dqPE5,dfdq_curr_vec_out_AY_dqPE5,dfdq_curr_vec_out_AZ_dqPE5,dfdq_curr_vec_out_LX_dqPE5,dfdq_curr_vec_out_LY_dqPE5,dfdq_curr_vec_out_LZ_dqPE5;
   // dqPE6
   wire signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE6,dvdq_curr_vec_out_AY_dqPE6,dvdq_curr_vec_out_AZ_dqPE6,dvdq_curr_vec_out_LX_dqPE6,dvdq_curr_vec_out_LY_dqPE6,dvdq_curr_vec_out_LZ_dqPE6,
      dadq_curr_vec_out_AX_dqPE6,dadq_curr_vec_out_AY_dqPE6,dadq_curr_vec_out_AZ_dqPE6,dadq_curr_vec_out_LX_dqPE6,dadq_curr_vec_out_LY_dqPE6,dadq_curr_vec_out_LZ_dqPE6,
      dfdq_curr_vec_out_AX_dqPE6,dfdq_curr_vec_out_AY_dqPE6,dfdq_curr_vec_out_AZ_dqPE6,dfdq_curr_vec_out_LX_dqPE6,dfdq_curr_vec_out_LY_dqPE6,dfdq_curr_vec_out_LZ_dqPE6;
   // dqPE7
   wire signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE7,dvdq_curr_vec_out_AY_dqPE7,dvdq_curr_vec_out_AZ_dqPE7,dvdq_curr_vec_out_LX_dqPE7,dvdq_curr_vec_out_LY_dqPE7,dvdq_curr_vec_out_LZ_dqPE7,
      dadq_curr_vec_out_AX_dqPE7,dadq_curr_vec_out_AY_dqPE7,dadq_curr_vec_out_AZ_dqPE7,dadq_curr_vec_out_LX_dqPE7,dadq_curr_vec_out_LY_dqPE7,dadq_curr_vec_out_LZ_dqPE7,
      dfdq_curr_vec_out_AX_dqPE7,dfdq_curr_vec_out_AY_dqPE7,dfdq_curr_vec_out_AZ_dqPE7,dfdq_curr_vec_out_LX_dqPE7,dfdq_curr_vec_out_LY_dqPE7,dfdq_curr_vec_out_LZ_dqPE7;
   //---------------------------------------------------------------------------
   // dqd external outputs
   //---------------------------------------------------------------------------
   // dqdPE1
   wire signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE1,dvdqd_curr_vec_out_AY_dqdPE1,dvdqd_curr_vec_out_AZ_dqdPE1,dvdqd_curr_vec_out_LX_dqdPE1,dvdqd_curr_vec_out_LY_dqdPE1,dvdqd_curr_vec_out_LZ_dqdPE1,
      dadqd_curr_vec_out_AX_dqdPE1,dadqd_curr_vec_out_AY_dqdPE1,dadqd_curr_vec_out_AZ_dqdPE1,dadqd_curr_vec_out_LX_dqdPE1,dadqd_curr_vec_out_LY_dqdPE1,dadqd_curr_vec_out_LZ_dqdPE1,
      dfdqd_curr_vec_out_AX_dqdPE1,dfdqd_curr_vec_out_AY_dqdPE1,dfdqd_curr_vec_out_AZ_dqdPE1,dfdqd_curr_vec_out_LX_dqdPE1,dfdqd_curr_vec_out_LY_dqdPE1,dfdqd_curr_vec_out_LZ_dqdPE1;
   // dqdPE2
   wire signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE2,dvdqd_curr_vec_out_AY_dqdPE2,dvdqd_curr_vec_out_AZ_dqdPE2,dvdqd_curr_vec_out_LX_dqdPE2,dvdqd_curr_vec_out_LY_dqdPE2,dvdqd_curr_vec_out_LZ_dqdPE2,
      dadqd_curr_vec_out_AX_dqdPE2,dadqd_curr_vec_out_AY_dqdPE2,dadqd_curr_vec_out_AZ_dqdPE2,dadqd_curr_vec_out_LX_dqdPE2,dadqd_curr_vec_out_LY_dqdPE2,dadqd_curr_vec_out_LZ_dqdPE2,
      dfdqd_curr_vec_out_AX_dqdPE2,dfdqd_curr_vec_out_AY_dqdPE2,dfdqd_curr_vec_out_AZ_dqdPE2,dfdqd_curr_vec_out_LX_dqdPE2,dfdqd_curr_vec_out_LY_dqdPE2,dfdqd_curr_vec_out_LZ_dqdPE2;
   // dqdPE3
   wire signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE3,dvdqd_curr_vec_out_AY_dqdPE3,dvdqd_curr_vec_out_AZ_dqdPE3,dvdqd_curr_vec_out_LX_dqdPE3,dvdqd_curr_vec_out_LY_dqdPE3,dvdqd_curr_vec_out_LZ_dqdPE3,
      dadqd_curr_vec_out_AX_dqdPE3,dadqd_curr_vec_out_AY_dqdPE3,dadqd_curr_vec_out_AZ_dqdPE3,dadqd_curr_vec_out_LX_dqdPE3,dadqd_curr_vec_out_LY_dqdPE3,dadqd_curr_vec_out_LZ_dqdPE3,
      dfdqd_curr_vec_out_AX_dqdPE3,dfdqd_curr_vec_out_AY_dqdPE3,dfdqd_curr_vec_out_AZ_dqdPE3,dfdqd_curr_vec_out_LX_dqdPE3,dfdqd_curr_vec_out_LY_dqdPE3,dfdqd_curr_vec_out_LZ_dqdPE3;
   // dqdPE4
   wire signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE4,dvdqd_curr_vec_out_AY_dqdPE4,dvdqd_curr_vec_out_AZ_dqdPE4,dvdqd_curr_vec_out_LX_dqdPE4,dvdqd_curr_vec_out_LY_dqdPE4,dvdqd_curr_vec_out_LZ_dqdPE4,
      dadqd_curr_vec_out_AX_dqdPE4,dadqd_curr_vec_out_AY_dqdPE4,dadqd_curr_vec_out_AZ_dqdPE4,dadqd_curr_vec_out_LX_dqdPE4,dadqd_curr_vec_out_LY_dqdPE4,dadqd_curr_vec_out_LZ_dqdPE4,
      dfdqd_curr_vec_out_AX_dqdPE4,dfdqd_curr_vec_out_AY_dqdPE4,dfdqd_curr_vec_out_AZ_dqdPE4,dfdqd_curr_vec_out_LX_dqdPE4,dfdqd_curr_vec_out_LY_dqdPE4,dfdqd_curr_vec_out_LZ_dqdPE4;
   // dqdPE5
   wire signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE5,dvdqd_curr_vec_out_AY_dqdPE5,dvdqd_curr_vec_out_AZ_dqdPE5,dvdqd_curr_vec_out_LX_dqdPE5,dvdqd_curr_vec_out_LY_dqdPE5,dvdqd_curr_vec_out_LZ_dqdPE5,
      dadqd_curr_vec_out_AX_dqdPE5,dadqd_curr_vec_out_AY_dqdPE5,dadqd_curr_vec_out_AZ_dqdPE5,dadqd_curr_vec_out_LX_dqdPE5,dadqd_curr_vec_out_LY_dqdPE5,dadqd_curr_vec_out_LZ_dqdPE5,
      dfdqd_curr_vec_out_AX_dqdPE5,dfdqd_curr_vec_out_AY_dqdPE5,dfdqd_curr_vec_out_AZ_dqdPE5,dfdqd_curr_vec_out_LX_dqdPE5,dfdqd_curr_vec_out_LY_dqdPE5,dfdqd_curr_vec_out_LZ_dqdPE5;
   // dqdPE6
   wire signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE6,dvdqd_curr_vec_out_AY_dqdPE6,dvdqd_curr_vec_out_AZ_dqdPE6,dvdqd_curr_vec_out_LX_dqdPE6,dvdqd_curr_vec_out_LY_dqdPE6,dvdqd_curr_vec_out_LZ_dqdPE6,
      dadqd_curr_vec_out_AX_dqdPE6,dadqd_curr_vec_out_AY_dqdPE6,dadqd_curr_vec_out_AZ_dqdPE6,dadqd_curr_vec_out_LX_dqdPE6,dadqd_curr_vec_out_LY_dqdPE6,dadqd_curr_vec_out_LZ_dqdPE6,
      dfdqd_curr_vec_out_AX_dqdPE6,dfdqd_curr_vec_out_AY_dqdPE6,dfdqd_curr_vec_out_AZ_dqdPE6,dfdqd_curr_vec_out_LX_dqdPE6,dfdqd_curr_vec_out_LY_dqdPE6,dfdqd_curr_vec_out_LZ_dqdPE6;
   // dqdPE7
   wire signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE7,dvdqd_curr_vec_out_AY_dqdPE7,dvdqd_curr_vec_out_AZ_dqdPE7,dvdqd_curr_vec_out_LX_dqdPE7,dvdqd_curr_vec_out_LY_dqdPE7,dvdqd_curr_vec_out_LZ_dqdPE7,
      dadqd_curr_vec_out_AX_dqdPE7,dadqd_curr_vec_out_AY_dqdPE7,dadqd_curr_vec_out_AZ_dqdPE7,dadqd_curr_vec_out_LX_dqdPE7,dadqd_curr_vec_out_LY_dqdPE7,dadqd_curr_vec_out_LZ_dqdPE7,
      dfdqd_curr_vec_out_AX_dqdPE7,dfdqd_curr_vec_out_AY_dqdPE7,dfdqd_curr_vec_out_AZ_dqdPE7,dfdqd_curr_vec_out_LX_dqdPE7,dfdqd_curr_vec_out_LY_dqdPE7,dfdqd_curr_vec_out_LZ_dqdPE7;
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
   // External dv,da Storage
   //---------------------------------------------------------------------------
   // dqPE1
   reg signed[(WIDTH-1):0]
      dvdq_curr_vec_reg_AX_dqPE1,dvdq_curr_vec_reg_AY_dqPE1,dvdq_curr_vec_reg_AZ_dqPE1,dvdq_curr_vec_reg_LX_dqPE1,dvdq_curr_vec_reg_LY_dqPE1,dvdq_curr_vec_reg_LZ_dqPE1,
      dadq_curr_vec_reg_AX_dqPE1,dadq_curr_vec_reg_AY_dqPE1,dadq_curr_vec_reg_AZ_dqPE1,dadq_curr_vec_reg_LX_dqPE1,dadq_curr_vec_reg_LY_dqPE1,dadq_curr_vec_reg_LZ_dqPE1;
   // dqPE2
   reg signed[(WIDTH-1):0]
      dvdq_curr_vec_reg_AX_dqPE2,dvdq_curr_vec_reg_AY_dqPE2,dvdq_curr_vec_reg_AZ_dqPE2,dvdq_curr_vec_reg_LX_dqPE2,dvdq_curr_vec_reg_LY_dqPE2,dvdq_curr_vec_reg_LZ_dqPE2,
      dadq_curr_vec_reg_AX_dqPE2,dadq_curr_vec_reg_AY_dqPE2,dadq_curr_vec_reg_AZ_dqPE2,dadq_curr_vec_reg_LX_dqPE2,dadq_curr_vec_reg_LY_dqPE2,dadq_curr_vec_reg_LZ_dqPE2;
   // dqPE3
   reg signed[(WIDTH-1):0]
      dvdq_curr_vec_reg_AX_dqPE3,dvdq_curr_vec_reg_AY_dqPE3,dvdq_curr_vec_reg_AZ_dqPE3,dvdq_curr_vec_reg_LX_dqPE3,dvdq_curr_vec_reg_LY_dqPE3,dvdq_curr_vec_reg_LZ_dqPE3,
      dadq_curr_vec_reg_AX_dqPE3,dadq_curr_vec_reg_AY_dqPE3,dadq_curr_vec_reg_AZ_dqPE3,dadq_curr_vec_reg_LX_dqPE3,dadq_curr_vec_reg_LY_dqPE3,dadq_curr_vec_reg_LZ_dqPE3;
   // dqPE4
   reg signed[(WIDTH-1):0]
      dvdq_curr_vec_reg_AX_dqPE4,dvdq_curr_vec_reg_AY_dqPE4,dvdq_curr_vec_reg_AZ_dqPE4,dvdq_curr_vec_reg_LX_dqPE4,dvdq_curr_vec_reg_LY_dqPE4,dvdq_curr_vec_reg_LZ_dqPE4,
      dadq_curr_vec_reg_AX_dqPE4,dadq_curr_vec_reg_AY_dqPE4,dadq_curr_vec_reg_AZ_dqPE4,dadq_curr_vec_reg_LX_dqPE4,dadq_curr_vec_reg_LY_dqPE4,dadq_curr_vec_reg_LZ_dqPE4;
   // dqPE5
   reg signed[(WIDTH-1):0]
      dvdq_curr_vec_reg_AX_dqPE5,dvdq_curr_vec_reg_AY_dqPE5,dvdq_curr_vec_reg_AZ_dqPE5,dvdq_curr_vec_reg_LX_dqPE5,dvdq_curr_vec_reg_LY_dqPE5,dvdq_curr_vec_reg_LZ_dqPE5,
      dadq_curr_vec_reg_AX_dqPE5,dadq_curr_vec_reg_AY_dqPE5,dadq_curr_vec_reg_AZ_dqPE5,dadq_curr_vec_reg_LX_dqPE5,dadq_curr_vec_reg_LY_dqPE5,dadq_curr_vec_reg_LZ_dqPE5;
   // dqPE6
   reg signed[(WIDTH-1):0]
      dvdq_curr_vec_reg_AX_dqPE6,dvdq_curr_vec_reg_AY_dqPE6,dvdq_curr_vec_reg_AZ_dqPE6,dvdq_curr_vec_reg_LX_dqPE6,dvdq_curr_vec_reg_LY_dqPE6,dvdq_curr_vec_reg_LZ_dqPE6,
      dadq_curr_vec_reg_AX_dqPE6,dadq_curr_vec_reg_AY_dqPE6,dadq_curr_vec_reg_AZ_dqPE6,dadq_curr_vec_reg_LX_dqPE6,dadq_curr_vec_reg_LY_dqPE6,dadq_curr_vec_reg_LZ_dqPE6;
   // dqPE7
   reg signed[(WIDTH-1):0]
      dvdq_curr_vec_reg_AX_dqPE7,dvdq_curr_vec_reg_AY_dqPE7,dvdq_curr_vec_reg_AZ_dqPE7,dvdq_curr_vec_reg_LX_dqPE7,dvdq_curr_vec_reg_LY_dqPE7,dvdq_curr_vec_reg_LZ_dqPE7,
      dadq_curr_vec_reg_AX_dqPE7,dadq_curr_vec_reg_AY_dqPE7,dadq_curr_vec_reg_AZ_dqPE7,dadq_curr_vec_reg_LX_dqPE7,dadq_curr_vec_reg_LY_dqPE7,dadq_curr_vec_reg_LZ_dqPE7;
   //---------------------------------------------------------------------------
   // dqdPE1
   reg signed[(WIDTH-1):0]
      dvdqd_curr_vec_reg_AX_dqdPE1,dvdqd_curr_vec_reg_AY_dqdPE1,dvdqd_curr_vec_reg_AZ_dqdPE1,dvdqd_curr_vec_reg_LX_dqdPE1,dvdqd_curr_vec_reg_LY_dqdPE1,dvdqd_curr_vec_reg_LZ_dqdPE1,
      dadqd_curr_vec_reg_AX_dqdPE1,dadqd_curr_vec_reg_AY_dqdPE1,dadqd_curr_vec_reg_AZ_dqdPE1,dadqd_curr_vec_reg_LX_dqdPE1,dadqd_curr_vec_reg_LY_dqdPE1,dadqd_curr_vec_reg_LZ_dqdPE1;
   // dqdPE2
   reg signed[(WIDTH-1):0]
      dvdqd_curr_vec_reg_AX_dqdPE2,dvdqd_curr_vec_reg_AY_dqdPE2,dvdqd_curr_vec_reg_AZ_dqdPE2,dvdqd_curr_vec_reg_LX_dqdPE2,dvdqd_curr_vec_reg_LY_dqdPE2,dvdqd_curr_vec_reg_LZ_dqdPE2,
      dadqd_curr_vec_reg_AX_dqdPE2,dadqd_curr_vec_reg_AY_dqdPE2,dadqd_curr_vec_reg_AZ_dqdPE2,dadqd_curr_vec_reg_LX_dqdPE2,dadqd_curr_vec_reg_LY_dqdPE2,dadqd_curr_vec_reg_LZ_dqdPE2;
   // dqdPE3
   reg signed[(WIDTH-1):0]
      dvdqd_curr_vec_reg_AX_dqdPE3,dvdqd_curr_vec_reg_AY_dqdPE3,dvdqd_curr_vec_reg_AZ_dqdPE3,dvdqd_curr_vec_reg_LX_dqdPE3,dvdqd_curr_vec_reg_LY_dqdPE3,dvdqd_curr_vec_reg_LZ_dqdPE3,
      dadqd_curr_vec_reg_AX_dqdPE3,dadqd_curr_vec_reg_AY_dqdPE3,dadqd_curr_vec_reg_AZ_dqdPE3,dadqd_curr_vec_reg_LX_dqdPE3,dadqd_curr_vec_reg_LY_dqdPE3,dadqd_curr_vec_reg_LZ_dqdPE3;
   // dqdPE4
   reg signed[(WIDTH-1):0]
      dvdqd_curr_vec_reg_AX_dqdPE4,dvdqd_curr_vec_reg_AY_dqdPE4,dvdqd_curr_vec_reg_AZ_dqdPE4,dvdqd_curr_vec_reg_LX_dqdPE4,dvdqd_curr_vec_reg_LY_dqdPE4,dvdqd_curr_vec_reg_LZ_dqdPE4,
      dadqd_curr_vec_reg_AX_dqdPE4,dadqd_curr_vec_reg_AY_dqdPE4,dadqd_curr_vec_reg_AZ_dqdPE4,dadqd_curr_vec_reg_LX_dqdPE4,dadqd_curr_vec_reg_LY_dqdPE4,dadqd_curr_vec_reg_LZ_dqdPE4;
   // dqdPE5
   reg signed[(WIDTH-1):0]
      dvdqd_curr_vec_reg_AX_dqdPE5,dvdqd_curr_vec_reg_AY_dqdPE5,dvdqd_curr_vec_reg_AZ_dqdPE5,dvdqd_curr_vec_reg_LX_dqdPE5,dvdqd_curr_vec_reg_LY_dqdPE5,dvdqd_curr_vec_reg_LZ_dqdPE5,
      dadqd_curr_vec_reg_AX_dqdPE5,dadqd_curr_vec_reg_AY_dqdPE5,dadqd_curr_vec_reg_AZ_dqdPE5,dadqd_curr_vec_reg_LX_dqdPE5,dadqd_curr_vec_reg_LY_dqdPE5,dadqd_curr_vec_reg_LZ_dqdPE5;
   // dqdPE6
   reg signed[(WIDTH-1):0]
      dvdqd_curr_vec_reg_AX_dqdPE6,dvdqd_curr_vec_reg_AY_dqdPE6,dvdqd_curr_vec_reg_AZ_dqdPE6,dvdqd_curr_vec_reg_LX_dqdPE6,dvdqd_curr_vec_reg_LY_dqdPE6,dvdqd_curr_vec_reg_LZ_dqdPE6,
      dadqd_curr_vec_reg_AX_dqdPE6,dadqd_curr_vec_reg_AY_dqdPE6,dadqd_curr_vec_reg_AZ_dqdPE6,dadqd_curr_vec_reg_LX_dqdPE6,dadqd_curr_vec_reg_LY_dqdPE6,dadqd_curr_vec_reg_LZ_dqdPE6;
   // dqdPE7
   reg signed[(WIDTH-1):0]
      dvdqd_curr_vec_reg_AX_dqdPE7,dvdqd_curr_vec_reg_AY_dqdPE7,dvdqd_curr_vec_reg_AZ_dqdPE7,dvdqd_curr_vec_reg_LX_dqdPE7,dvdqd_curr_vec_reg_LY_dqdPE7,dvdqd_curr_vec_reg_LZ_dqdPE7,
      dadqd_curr_vec_reg_AX_dqdPE7,dadqd_curr_vec_reg_AY_dqdPE7,dadqd_curr_vec_reg_AZ_dqdPE7,dadqd_curr_vec_reg_LX_dqdPE7,dadqd_curr_vec_reg_LY_dqdPE7,dadqd_curr_vec_reg_LZ_dqdPE7;
   //---------------------------------------------------------------------------

   
   fproc#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // get data
      .get_data(get_data),
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      .link_in_rnea(link_in_rnea),
      .sinq_val_in_rnea(sinq_val_in_rnea),.cosq_val_in_rnea(cosq_val_in_rnea),
      .qd_val_in_rnea(qd_val_in_rnea),
      .qdd_val_in_rnea(qdd_val_in_rnea),
      .v_prev_vec_in_AX_rnea(v_prev_vec_in_AX_rnea),.v_prev_vec_in_AY_rnea(v_prev_vec_in_AY_rnea),.v_prev_vec_in_AZ_rnea(v_prev_vec_in_AZ_rnea),.v_prev_vec_in_LX_rnea(v_prev_vec_in_LX_rnea),.v_prev_vec_in_LY_rnea(v_prev_vec_in_LY_rnea),.v_prev_vec_in_LZ_rnea(v_prev_vec_in_LZ_rnea),
      .a_prev_vec_in_AX_rnea(a_prev_vec_in_AX_rnea),.a_prev_vec_in_AY_rnea(a_prev_vec_in_AY_rnea),.a_prev_vec_in_AZ_rnea(a_prev_vec_in_AZ_rnea),.a_prev_vec_in_LX_rnea(a_prev_vec_in_LX_rnea),.a_prev_vec_in_LY_rnea(a_prev_vec_in_LY_rnea),.a_prev_vec_in_LZ_rnea(a_prev_vec_in_LZ_rnea),
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      .link_in_dqPE1(link_in_dqPE1),
      .derv_in_dqPE1(derv_in_dqPE1),
      .sinq_val_in_dqPE1(sinq_val_in_dqPE1),.cosq_val_in_dqPE1(cosq_val_in_dqPE1),
      .qd_val_in_dqPE1(qd_val_in_dqPE1),
      .v_curr_vec_in_AX_dqPE1(v_curr_vec_in_AX_dqPE1),.v_curr_vec_in_AY_dqPE1(v_curr_vec_in_AY_dqPE1),.v_curr_vec_in_AZ_dqPE1(v_curr_vec_in_AZ_dqPE1),.v_curr_vec_in_LX_dqPE1(v_curr_vec_in_LX_dqPE1),.v_curr_vec_in_LY_dqPE1(v_curr_vec_in_LY_dqPE1),.v_curr_vec_in_LZ_dqPE1(v_curr_vec_in_LZ_dqPE1),
      .a_curr_vec_in_AX_dqPE1(a_curr_vec_in_AX_dqPE1),.a_curr_vec_in_AY_dqPE1(a_curr_vec_in_AY_dqPE1),.a_curr_vec_in_AZ_dqPE1(a_curr_vec_in_AZ_dqPE1),.a_curr_vec_in_LX_dqPE1(a_curr_vec_in_LX_dqPE1),.a_curr_vec_in_LY_dqPE1(a_curr_vec_in_LY_dqPE1),.a_curr_vec_in_LZ_dqPE1(a_curr_vec_in_LZ_dqPE1),
      .v_prev_vec_in_AX_dqPE1(v_prev_vec_in_AX_dqPE1),.v_prev_vec_in_AY_dqPE1(v_prev_vec_in_AY_dqPE1),.v_prev_vec_in_AZ_dqPE1(v_prev_vec_in_AZ_dqPE1),.v_prev_vec_in_LX_dqPE1(v_prev_vec_in_LX_dqPE1),.v_prev_vec_in_LY_dqPE1(v_prev_vec_in_LY_dqPE1),.v_prev_vec_in_LZ_dqPE1(v_prev_vec_in_LZ_dqPE1),
      .a_prev_vec_in_AX_dqPE1(a_prev_vec_in_AX_dqPE1),.a_prev_vec_in_AY_dqPE1(a_prev_vec_in_AY_dqPE1),.a_prev_vec_in_AZ_dqPE1(a_prev_vec_in_AZ_dqPE1),.a_prev_vec_in_LX_dqPE1(a_prev_vec_in_LX_dqPE1),.a_prev_vec_in_LY_dqPE1(a_prev_vec_in_LY_dqPE1),.a_prev_vec_in_LZ_dqPE1(a_prev_vec_in_LZ_dqPE1),
      .dvdq_prev_vec_in_AX_dqPE1(dvdq_prev_vec_in_AX_dqPE1),.dvdq_prev_vec_in_AY_dqPE1(dvdq_prev_vec_in_AY_dqPE1),.dvdq_prev_vec_in_AZ_dqPE1(dvdq_prev_vec_in_AZ_dqPE1),.dvdq_prev_vec_in_LX_dqPE1(dvdq_prev_vec_in_LX_dqPE1),.dvdq_prev_vec_in_LY_dqPE1(dvdq_prev_vec_in_LY_dqPE1),.dvdq_prev_vec_in_LZ_dqPE1(dvdq_prev_vec_in_LZ_dqPE1),
      .dadq_prev_vec_in_AX_dqPE1(dadq_prev_vec_in_AX_dqPE1),.dadq_prev_vec_in_AY_dqPE1(dadq_prev_vec_in_AY_dqPE1),.dadq_prev_vec_in_AZ_dqPE1(dadq_prev_vec_in_AZ_dqPE1),.dadq_prev_vec_in_LX_dqPE1(dadq_prev_vec_in_LX_dqPE1),.dadq_prev_vec_in_LY_dqPE1(dadq_prev_vec_in_LY_dqPE1),.dadq_prev_vec_in_LZ_dqPE1(dadq_prev_vec_in_LZ_dqPE1),
      // dqPE2
      .link_in_dqPE2(link_in_dqPE2),
      .derv_in_dqPE2(derv_in_dqPE2),
      .sinq_val_in_dqPE2(sinq_val_in_dqPE2),.cosq_val_in_dqPE2(cosq_val_in_dqPE2),
      .qd_val_in_dqPE2(qd_val_in_dqPE2),
      .v_curr_vec_in_AX_dqPE2(v_curr_vec_in_AX_dqPE2),.v_curr_vec_in_AY_dqPE2(v_curr_vec_in_AY_dqPE2),.v_curr_vec_in_AZ_dqPE2(v_curr_vec_in_AZ_dqPE2),.v_curr_vec_in_LX_dqPE2(v_curr_vec_in_LX_dqPE2),.v_curr_vec_in_LY_dqPE2(v_curr_vec_in_LY_dqPE2),.v_curr_vec_in_LZ_dqPE2(v_curr_vec_in_LZ_dqPE2),
      .a_curr_vec_in_AX_dqPE2(a_curr_vec_in_AX_dqPE2),.a_curr_vec_in_AY_dqPE2(a_curr_vec_in_AY_dqPE2),.a_curr_vec_in_AZ_dqPE2(a_curr_vec_in_AZ_dqPE2),.a_curr_vec_in_LX_dqPE2(a_curr_vec_in_LX_dqPE2),.a_curr_vec_in_LY_dqPE2(a_curr_vec_in_LY_dqPE2),.a_curr_vec_in_LZ_dqPE2(a_curr_vec_in_LZ_dqPE2),
      .v_prev_vec_in_AX_dqPE2(v_prev_vec_in_AX_dqPE2),.v_prev_vec_in_AY_dqPE2(v_prev_vec_in_AY_dqPE2),.v_prev_vec_in_AZ_dqPE2(v_prev_vec_in_AZ_dqPE2),.v_prev_vec_in_LX_dqPE2(v_prev_vec_in_LX_dqPE2),.v_prev_vec_in_LY_dqPE2(v_prev_vec_in_LY_dqPE2),.v_prev_vec_in_LZ_dqPE2(v_prev_vec_in_LZ_dqPE2),
      .a_prev_vec_in_AX_dqPE2(a_prev_vec_in_AX_dqPE2),.a_prev_vec_in_AY_dqPE2(a_prev_vec_in_AY_dqPE2),.a_prev_vec_in_AZ_dqPE2(a_prev_vec_in_AZ_dqPE2),.a_prev_vec_in_LX_dqPE2(a_prev_vec_in_LX_dqPE2),.a_prev_vec_in_LY_dqPE2(a_prev_vec_in_LY_dqPE2),.a_prev_vec_in_LZ_dqPE2(a_prev_vec_in_LZ_dqPE2),
      .dvdq_prev_vec_in_AX_dqPE2(dvdq_prev_vec_in_AX_dqPE2),.dvdq_prev_vec_in_AY_dqPE2(dvdq_prev_vec_in_AY_dqPE2),.dvdq_prev_vec_in_AZ_dqPE2(dvdq_prev_vec_in_AZ_dqPE2),.dvdq_prev_vec_in_LX_dqPE2(dvdq_prev_vec_in_LX_dqPE2),.dvdq_prev_vec_in_LY_dqPE2(dvdq_prev_vec_in_LY_dqPE2),.dvdq_prev_vec_in_LZ_dqPE2(dvdq_prev_vec_in_LZ_dqPE2),
      .dadq_prev_vec_in_AX_dqPE2(dadq_prev_vec_in_AX_dqPE2),.dadq_prev_vec_in_AY_dqPE2(dadq_prev_vec_in_AY_dqPE2),.dadq_prev_vec_in_AZ_dqPE2(dadq_prev_vec_in_AZ_dqPE2),.dadq_prev_vec_in_LX_dqPE2(dadq_prev_vec_in_LX_dqPE2),.dadq_prev_vec_in_LY_dqPE2(dadq_prev_vec_in_LY_dqPE2),.dadq_prev_vec_in_LZ_dqPE2(dadq_prev_vec_in_LZ_dqPE2),
      // dqPE3
      .link_in_dqPE3(link_in_dqPE3),
      .derv_in_dqPE3(derv_in_dqPE3),
      .sinq_val_in_dqPE3(sinq_val_in_dqPE3),.cosq_val_in_dqPE3(cosq_val_in_dqPE3),
      .qd_val_in_dqPE3(qd_val_in_dqPE3),
      .v_curr_vec_in_AX_dqPE3(v_curr_vec_in_AX_dqPE3),.v_curr_vec_in_AY_dqPE3(v_curr_vec_in_AY_dqPE3),.v_curr_vec_in_AZ_dqPE3(v_curr_vec_in_AZ_dqPE3),.v_curr_vec_in_LX_dqPE3(v_curr_vec_in_LX_dqPE3),.v_curr_vec_in_LY_dqPE3(v_curr_vec_in_LY_dqPE3),.v_curr_vec_in_LZ_dqPE3(v_curr_vec_in_LZ_dqPE3),
      .a_curr_vec_in_AX_dqPE3(a_curr_vec_in_AX_dqPE3),.a_curr_vec_in_AY_dqPE3(a_curr_vec_in_AY_dqPE3),.a_curr_vec_in_AZ_dqPE3(a_curr_vec_in_AZ_dqPE3),.a_curr_vec_in_LX_dqPE3(a_curr_vec_in_LX_dqPE3),.a_curr_vec_in_LY_dqPE3(a_curr_vec_in_LY_dqPE3),.a_curr_vec_in_LZ_dqPE3(a_curr_vec_in_LZ_dqPE3),
      .v_prev_vec_in_AX_dqPE3(v_prev_vec_in_AX_dqPE3),.v_prev_vec_in_AY_dqPE3(v_prev_vec_in_AY_dqPE3),.v_prev_vec_in_AZ_dqPE3(v_prev_vec_in_AZ_dqPE3),.v_prev_vec_in_LX_dqPE3(v_prev_vec_in_LX_dqPE3),.v_prev_vec_in_LY_dqPE3(v_prev_vec_in_LY_dqPE3),.v_prev_vec_in_LZ_dqPE3(v_prev_vec_in_LZ_dqPE3),
      .a_prev_vec_in_AX_dqPE3(a_prev_vec_in_AX_dqPE3),.a_prev_vec_in_AY_dqPE3(a_prev_vec_in_AY_dqPE3),.a_prev_vec_in_AZ_dqPE3(a_prev_vec_in_AZ_dqPE3),.a_prev_vec_in_LX_dqPE3(a_prev_vec_in_LX_dqPE3),.a_prev_vec_in_LY_dqPE3(a_prev_vec_in_LY_dqPE3),.a_prev_vec_in_LZ_dqPE3(a_prev_vec_in_LZ_dqPE3),
      .dvdq_prev_vec_in_AX_dqPE3(dvdq_prev_vec_in_AX_dqPE3),.dvdq_prev_vec_in_AY_dqPE3(dvdq_prev_vec_in_AY_dqPE3),.dvdq_prev_vec_in_AZ_dqPE3(dvdq_prev_vec_in_AZ_dqPE3),.dvdq_prev_vec_in_LX_dqPE3(dvdq_prev_vec_in_LX_dqPE3),.dvdq_prev_vec_in_LY_dqPE3(dvdq_prev_vec_in_LY_dqPE3),.dvdq_prev_vec_in_LZ_dqPE3(dvdq_prev_vec_in_LZ_dqPE3),
      .dadq_prev_vec_in_AX_dqPE3(dadq_prev_vec_in_AX_dqPE3),.dadq_prev_vec_in_AY_dqPE3(dadq_prev_vec_in_AY_dqPE3),.dadq_prev_vec_in_AZ_dqPE3(dadq_prev_vec_in_AZ_dqPE3),.dadq_prev_vec_in_LX_dqPE3(dadq_prev_vec_in_LX_dqPE3),.dadq_prev_vec_in_LY_dqPE3(dadq_prev_vec_in_LY_dqPE3),.dadq_prev_vec_in_LZ_dqPE3(dadq_prev_vec_in_LZ_dqPE3),
      // dqPE4
      .link_in_dqPE4(link_in_dqPE4),
      .derv_in_dqPE4(derv_in_dqPE4),
      .sinq_val_in_dqPE4(sinq_val_in_dqPE4),.cosq_val_in_dqPE4(cosq_val_in_dqPE4),
      .qd_val_in_dqPE4(qd_val_in_dqPE4),
      .v_curr_vec_in_AX_dqPE4(v_curr_vec_in_AX_dqPE4),.v_curr_vec_in_AY_dqPE4(v_curr_vec_in_AY_dqPE4),.v_curr_vec_in_AZ_dqPE4(v_curr_vec_in_AZ_dqPE4),.v_curr_vec_in_LX_dqPE4(v_curr_vec_in_LX_dqPE4),.v_curr_vec_in_LY_dqPE4(v_curr_vec_in_LY_dqPE4),.v_curr_vec_in_LZ_dqPE4(v_curr_vec_in_LZ_dqPE4),
      .a_curr_vec_in_AX_dqPE4(a_curr_vec_in_AX_dqPE4),.a_curr_vec_in_AY_dqPE4(a_curr_vec_in_AY_dqPE4),.a_curr_vec_in_AZ_dqPE4(a_curr_vec_in_AZ_dqPE4),.a_curr_vec_in_LX_dqPE4(a_curr_vec_in_LX_dqPE4),.a_curr_vec_in_LY_dqPE4(a_curr_vec_in_LY_dqPE4),.a_curr_vec_in_LZ_dqPE4(a_curr_vec_in_LZ_dqPE4),
      .v_prev_vec_in_AX_dqPE4(v_prev_vec_in_AX_dqPE4),.v_prev_vec_in_AY_dqPE4(v_prev_vec_in_AY_dqPE4),.v_prev_vec_in_AZ_dqPE4(v_prev_vec_in_AZ_dqPE4),.v_prev_vec_in_LX_dqPE4(v_prev_vec_in_LX_dqPE4),.v_prev_vec_in_LY_dqPE4(v_prev_vec_in_LY_dqPE4),.v_prev_vec_in_LZ_dqPE4(v_prev_vec_in_LZ_dqPE4),
      .a_prev_vec_in_AX_dqPE4(a_prev_vec_in_AX_dqPE4),.a_prev_vec_in_AY_dqPE4(a_prev_vec_in_AY_dqPE4),.a_prev_vec_in_AZ_dqPE4(a_prev_vec_in_AZ_dqPE4),.a_prev_vec_in_LX_dqPE4(a_prev_vec_in_LX_dqPE4),.a_prev_vec_in_LY_dqPE4(a_prev_vec_in_LY_dqPE4),.a_prev_vec_in_LZ_dqPE4(a_prev_vec_in_LZ_dqPE4),
      .dvdq_prev_vec_in_AX_dqPE4(dvdq_prev_vec_in_AX_dqPE4),.dvdq_prev_vec_in_AY_dqPE4(dvdq_prev_vec_in_AY_dqPE4),.dvdq_prev_vec_in_AZ_dqPE4(dvdq_prev_vec_in_AZ_dqPE4),.dvdq_prev_vec_in_LX_dqPE4(dvdq_prev_vec_in_LX_dqPE4),.dvdq_prev_vec_in_LY_dqPE4(dvdq_prev_vec_in_LY_dqPE4),.dvdq_prev_vec_in_LZ_dqPE4(dvdq_prev_vec_in_LZ_dqPE4),
      .dadq_prev_vec_in_AX_dqPE4(dadq_prev_vec_in_AX_dqPE4),.dadq_prev_vec_in_AY_dqPE4(dadq_prev_vec_in_AY_dqPE4),.dadq_prev_vec_in_AZ_dqPE4(dadq_prev_vec_in_AZ_dqPE4),.dadq_prev_vec_in_LX_dqPE4(dadq_prev_vec_in_LX_dqPE4),.dadq_prev_vec_in_LY_dqPE4(dadq_prev_vec_in_LY_dqPE4),.dadq_prev_vec_in_LZ_dqPE4(dadq_prev_vec_in_LZ_dqPE4),
      // dqPE5
      .link_in_dqPE5(link_in_dqPE5),
      .derv_in_dqPE5(derv_in_dqPE5),
      .sinq_val_in_dqPE5(sinq_val_in_dqPE5),.cosq_val_in_dqPE5(cosq_val_in_dqPE5),
      .qd_val_in_dqPE5(qd_val_in_dqPE5),
      .v_curr_vec_in_AX_dqPE5(v_curr_vec_in_AX_dqPE5),.v_curr_vec_in_AY_dqPE5(v_curr_vec_in_AY_dqPE5),.v_curr_vec_in_AZ_dqPE5(v_curr_vec_in_AZ_dqPE5),.v_curr_vec_in_LX_dqPE5(v_curr_vec_in_LX_dqPE5),.v_curr_vec_in_LY_dqPE5(v_curr_vec_in_LY_dqPE5),.v_curr_vec_in_LZ_dqPE5(v_curr_vec_in_LZ_dqPE5),
      .a_curr_vec_in_AX_dqPE5(a_curr_vec_in_AX_dqPE5),.a_curr_vec_in_AY_dqPE5(a_curr_vec_in_AY_dqPE5),.a_curr_vec_in_AZ_dqPE5(a_curr_vec_in_AZ_dqPE5),.a_curr_vec_in_LX_dqPE5(a_curr_vec_in_LX_dqPE5),.a_curr_vec_in_LY_dqPE5(a_curr_vec_in_LY_dqPE5),.a_curr_vec_in_LZ_dqPE5(a_curr_vec_in_LZ_dqPE5),
      .v_prev_vec_in_AX_dqPE5(v_prev_vec_in_AX_dqPE5),.v_prev_vec_in_AY_dqPE5(v_prev_vec_in_AY_dqPE5),.v_prev_vec_in_AZ_dqPE5(v_prev_vec_in_AZ_dqPE5),.v_prev_vec_in_LX_dqPE5(v_prev_vec_in_LX_dqPE5),.v_prev_vec_in_LY_dqPE5(v_prev_vec_in_LY_dqPE5),.v_prev_vec_in_LZ_dqPE5(v_prev_vec_in_LZ_dqPE5),
      .a_prev_vec_in_AX_dqPE5(a_prev_vec_in_AX_dqPE5),.a_prev_vec_in_AY_dqPE5(a_prev_vec_in_AY_dqPE5),.a_prev_vec_in_AZ_dqPE5(a_prev_vec_in_AZ_dqPE5),.a_prev_vec_in_LX_dqPE5(a_prev_vec_in_LX_dqPE5),.a_prev_vec_in_LY_dqPE5(a_prev_vec_in_LY_dqPE5),.a_prev_vec_in_LZ_dqPE5(a_prev_vec_in_LZ_dqPE5),
      .dvdq_prev_vec_in_AX_dqPE5(dvdq_prev_vec_in_AX_dqPE5),.dvdq_prev_vec_in_AY_dqPE5(dvdq_prev_vec_in_AY_dqPE5),.dvdq_prev_vec_in_AZ_dqPE5(dvdq_prev_vec_in_AZ_dqPE5),.dvdq_prev_vec_in_LX_dqPE5(dvdq_prev_vec_in_LX_dqPE5),.dvdq_prev_vec_in_LY_dqPE5(dvdq_prev_vec_in_LY_dqPE5),.dvdq_prev_vec_in_LZ_dqPE5(dvdq_prev_vec_in_LZ_dqPE5),
      .dadq_prev_vec_in_AX_dqPE5(dadq_prev_vec_in_AX_dqPE5),.dadq_prev_vec_in_AY_dqPE5(dadq_prev_vec_in_AY_dqPE5),.dadq_prev_vec_in_AZ_dqPE5(dadq_prev_vec_in_AZ_dqPE5),.dadq_prev_vec_in_LX_dqPE5(dadq_prev_vec_in_LX_dqPE5),.dadq_prev_vec_in_LY_dqPE5(dadq_prev_vec_in_LY_dqPE5),.dadq_prev_vec_in_LZ_dqPE5(dadq_prev_vec_in_LZ_dqPE5),
      // dqPE6
      .link_in_dqPE6(link_in_dqPE6),
      .derv_in_dqPE6(derv_in_dqPE6),
      .sinq_val_in_dqPE6(sinq_val_in_dqPE6),.cosq_val_in_dqPE6(cosq_val_in_dqPE6),
      .qd_val_in_dqPE6(qd_val_in_dqPE6),
      .v_curr_vec_in_AX_dqPE6(v_curr_vec_in_AX_dqPE6),.v_curr_vec_in_AY_dqPE6(v_curr_vec_in_AY_dqPE6),.v_curr_vec_in_AZ_dqPE6(v_curr_vec_in_AZ_dqPE6),.v_curr_vec_in_LX_dqPE6(v_curr_vec_in_LX_dqPE6),.v_curr_vec_in_LY_dqPE6(v_curr_vec_in_LY_dqPE6),.v_curr_vec_in_LZ_dqPE6(v_curr_vec_in_LZ_dqPE6),
      .a_curr_vec_in_AX_dqPE6(a_curr_vec_in_AX_dqPE6),.a_curr_vec_in_AY_dqPE6(a_curr_vec_in_AY_dqPE6),.a_curr_vec_in_AZ_dqPE6(a_curr_vec_in_AZ_dqPE6),.a_curr_vec_in_LX_dqPE6(a_curr_vec_in_LX_dqPE6),.a_curr_vec_in_LY_dqPE6(a_curr_vec_in_LY_dqPE6),.a_curr_vec_in_LZ_dqPE6(a_curr_vec_in_LZ_dqPE6),
      .v_prev_vec_in_AX_dqPE6(v_prev_vec_in_AX_dqPE6),.v_prev_vec_in_AY_dqPE6(v_prev_vec_in_AY_dqPE6),.v_prev_vec_in_AZ_dqPE6(v_prev_vec_in_AZ_dqPE6),.v_prev_vec_in_LX_dqPE6(v_prev_vec_in_LX_dqPE6),.v_prev_vec_in_LY_dqPE6(v_prev_vec_in_LY_dqPE6),.v_prev_vec_in_LZ_dqPE6(v_prev_vec_in_LZ_dqPE6),
      .a_prev_vec_in_AX_dqPE6(a_prev_vec_in_AX_dqPE6),.a_prev_vec_in_AY_dqPE6(a_prev_vec_in_AY_dqPE6),.a_prev_vec_in_AZ_dqPE6(a_prev_vec_in_AZ_dqPE6),.a_prev_vec_in_LX_dqPE6(a_prev_vec_in_LX_dqPE6),.a_prev_vec_in_LY_dqPE6(a_prev_vec_in_LY_dqPE6),.a_prev_vec_in_LZ_dqPE6(a_prev_vec_in_LZ_dqPE6),
      .dvdq_prev_vec_in_AX_dqPE6(dvdq_prev_vec_in_AX_dqPE6),.dvdq_prev_vec_in_AY_dqPE6(dvdq_prev_vec_in_AY_dqPE6),.dvdq_prev_vec_in_AZ_dqPE6(dvdq_prev_vec_in_AZ_dqPE6),.dvdq_prev_vec_in_LX_dqPE6(dvdq_prev_vec_in_LX_dqPE6),.dvdq_prev_vec_in_LY_dqPE6(dvdq_prev_vec_in_LY_dqPE6),.dvdq_prev_vec_in_LZ_dqPE6(dvdq_prev_vec_in_LZ_dqPE6),
      .dadq_prev_vec_in_AX_dqPE6(dadq_prev_vec_in_AX_dqPE6),.dadq_prev_vec_in_AY_dqPE6(dadq_prev_vec_in_AY_dqPE6),.dadq_prev_vec_in_AZ_dqPE6(dadq_prev_vec_in_AZ_dqPE6),.dadq_prev_vec_in_LX_dqPE6(dadq_prev_vec_in_LX_dqPE6),.dadq_prev_vec_in_LY_dqPE6(dadq_prev_vec_in_LY_dqPE6),.dadq_prev_vec_in_LZ_dqPE6(dadq_prev_vec_in_LZ_dqPE6),
      // dqPE7
      .link_in_dqPE7(link_in_dqPE7),
      .derv_in_dqPE7(derv_in_dqPE7),
      .sinq_val_in_dqPE7(sinq_val_in_dqPE7),.cosq_val_in_dqPE7(cosq_val_in_dqPE7),
      .qd_val_in_dqPE7(qd_val_in_dqPE7),
      .v_curr_vec_in_AX_dqPE7(v_curr_vec_in_AX_dqPE7),.v_curr_vec_in_AY_dqPE7(v_curr_vec_in_AY_dqPE7),.v_curr_vec_in_AZ_dqPE7(v_curr_vec_in_AZ_dqPE7),.v_curr_vec_in_LX_dqPE7(v_curr_vec_in_LX_dqPE7),.v_curr_vec_in_LY_dqPE7(v_curr_vec_in_LY_dqPE7),.v_curr_vec_in_LZ_dqPE7(v_curr_vec_in_LZ_dqPE7),
      .a_curr_vec_in_AX_dqPE7(a_curr_vec_in_AX_dqPE7),.a_curr_vec_in_AY_dqPE7(a_curr_vec_in_AY_dqPE7),.a_curr_vec_in_AZ_dqPE7(a_curr_vec_in_AZ_dqPE7),.a_curr_vec_in_LX_dqPE7(a_curr_vec_in_LX_dqPE7),.a_curr_vec_in_LY_dqPE7(a_curr_vec_in_LY_dqPE7),.a_curr_vec_in_LZ_dqPE7(a_curr_vec_in_LZ_dqPE7),
      .v_prev_vec_in_AX_dqPE7(v_prev_vec_in_AX_dqPE7),.v_prev_vec_in_AY_dqPE7(v_prev_vec_in_AY_dqPE7),.v_prev_vec_in_AZ_dqPE7(v_prev_vec_in_AZ_dqPE7),.v_prev_vec_in_LX_dqPE7(v_prev_vec_in_LX_dqPE7),.v_prev_vec_in_LY_dqPE7(v_prev_vec_in_LY_dqPE7),.v_prev_vec_in_LZ_dqPE7(v_prev_vec_in_LZ_dqPE7),
      .a_prev_vec_in_AX_dqPE7(a_prev_vec_in_AX_dqPE7),.a_prev_vec_in_AY_dqPE7(a_prev_vec_in_AY_dqPE7),.a_prev_vec_in_AZ_dqPE7(a_prev_vec_in_AZ_dqPE7),.a_prev_vec_in_LX_dqPE7(a_prev_vec_in_LX_dqPE7),.a_prev_vec_in_LY_dqPE7(a_prev_vec_in_LY_dqPE7),.a_prev_vec_in_LZ_dqPE7(a_prev_vec_in_LZ_dqPE7),
      .dvdq_prev_vec_in_AX_dqPE7(dvdq_prev_vec_in_AX_dqPE7),.dvdq_prev_vec_in_AY_dqPE7(dvdq_prev_vec_in_AY_dqPE7),.dvdq_prev_vec_in_AZ_dqPE7(dvdq_prev_vec_in_AZ_dqPE7),.dvdq_prev_vec_in_LX_dqPE7(dvdq_prev_vec_in_LX_dqPE7),.dvdq_prev_vec_in_LY_dqPE7(dvdq_prev_vec_in_LY_dqPE7),.dvdq_prev_vec_in_LZ_dqPE7(dvdq_prev_vec_in_LZ_dqPE7),
      .dadq_prev_vec_in_AX_dqPE7(dadq_prev_vec_in_AX_dqPE7),.dadq_prev_vec_in_AY_dqPE7(dadq_prev_vec_in_AY_dqPE7),.dadq_prev_vec_in_AZ_dqPE7(dadq_prev_vec_in_AZ_dqPE7),.dadq_prev_vec_in_LX_dqPE7(dadq_prev_vec_in_LX_dqPE7),.dadq_prev_vec_in_LY_dqPE7(dadq_prev_vec_in_LY_dqPE7),.dadq_prev_vec_in_LZ_dqPE7(dadq_prev_vec_in_LZ_dqPE7),
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      .link_in_dqdPE1(link_in_dqdPE1),
      .derv_in_dqdPE1(derv_in_dqdPE1),
      .sinq_val_in_dqdPE1(sinq_val_in_dqdPE1),.cosq_val_in_dqdPE1(cosq_val_in_dqdPE1),
      .qd_val_in_dqdPE1(qd_val_in_dqdPE1),
      .v_curr_vec_in_AX_dqdPE1(v_curr_vec_in_AX_dqdPE1),.v_curr_vec_in_AY_dqdPE1(v_curr_vec_in_AY_dqdPE1),.v_curr_vec_in_AZ_dqdPE1(v_curr_vec_in_AZ_dqdPE1),.v_curr_vec_in_LX_dqdPE1(v_curr_vec_in_LX_dqdPE1),.v_curr_vec_in_LY_dqdPE1(v_curr_vec_in_LY_dqdPE1),.v_curr_vec_in_LZ_dqdPE1(v_curr_vec_in_LZ_dqdPE1),
      .a_curr_vec_in_AX_dqdPE1(a_curr_vec_in_AX_dqdPE1),.a_curr_vec_in_AY_dqdPE1(a_curr_vec_in_AY_dqdPE1),.a_curr_vec_in_AZ_dqdPE1(a_curr_vec_in_AZ_dqdPE1),.a_curr_vec_in_LX_dqdPE1(a_curr_vec_in_LX_dqdPE1),.a_curr_vec_in_LY_dqdPE1(a_curr_vec_in_LY_dqdPE1),.a_curr_vec_in_LZ_dqdPE1(a_curr_vec_in_LZ_dqdPE1),
      .dvdqd_prev_vec_in_AX_dqdPE1(dvdqd_prev_vec_in_AX_dqdPE1),.dvdqd_prev_vec_in_AY_dqdPE1(dvdqd_prev_vec_in_AY_dqdPE1),.dvdqd_prev_vec_in_AZ_dqdPE1(dvdqd_prev_vec_in_AZ_dqdPE1),.dvdqd_prev_vec_in_LX_dqdPE1(dvdqd_prev_vec_in_LX_dqdPE1),.dvdqd_prev_vec_in_LY_dqdPE1(dvdqd_prev_vec_in_LY_dqdPE1),.dvdqd_prev_vec_in_LZ_dqdPE1(dvdqd_prev_vec_in_LZ_dqdPE1),
      .dadqd_prev_vec_in_AX_dqdPE1(dadqd_prev_vec_in_AX_dqdPE1),.dadqd_prev_vec_in_AY_dqdPE1(dadqd_prev_vec_in_AY_dqdPE1),.dadqd_prev_vec_in_AZ_dqdPE1(dadqd_prev_vec_in_AZ_dqdPE1),.dadqd_prev_vec_in_LX_dqdPE1(dadqd_prev_vec_in_LX_dqdPE1),.dadqd_prev_vec_in_LY_dqdPE1(dadqd_prev_vec_in_LY_dqdPE1),.dadqd_prev_vec_in_LZ_dqdPE1(dadqd_prev_vec_in_LZ_dqdPE1),
      // dqdPE2
      .link_in_dqdPE2(link_in_dqdPE2),
      .derv_in_dqdPE2(derv_in_dqdPE2),
      .sinq_val_in_dqdPE2(sinq_val_in_dqdPE2),.cosq_val_in_dqdPE2(cosq_val_in_dqdPE2),
      .qd_val_in_dqdPE2(qd_val_in_dqdPE2),
      .v_curr_vec_in_AX_dqdPE2(v_curr_vec_in_AX_dqdPE2),.v_curr_vec_in_AY_dqdPE2(v_curr_vec_in_AY_dqdPE2),.v_curr_vec_in_AZ_dqdPE2(v_curr_vec_in_AZ_dqdPE2),.v_curr_vec_in_LX_dqdPE2(v_curr_vec_in_LX_dqdPE2),.v_curr_vec_in_LY_dqdPE2(v_curr_vec_in_LY_dqdPE2),.v_curr_vec_in_LZ_dqdPE2(v_curr_vec_in_LZ_dqdPE2),
      .a_curr_vec_in_AX_dqdPE2(a_curr_vec_in_AX_dqdPE2),.a_curr_vec_in_AY_dqdPE2(a_curr_vec_in_AY_dqdPE2),.a_curr_vec_in_AZ_dqdPE2(a_curr_vec_in_AZ_dqdPE2),.a_curr_vec_in_LX_dqdPE2(a_curr_vec_in_LX_dqdPE2),.a_curr_vec_in_LY_dqdPE2(a_curr_vec_in_LY_dqdPE2),.a_curr_vec_in_LZ_dqdPE2(a_curr_vec_in_LZ_dqdPE2),
      .dvdqd_prev_vec_in_AX_dqdPE2(dvdqd_prev_vec_in_AX_dqdPE2),.dvdqd_prev_vec_in_AY_dqdPE2(dvdqd_prev_vec_in_AY_dqdPE2),.dvdqd_prev_vec_in_AZ_dqdPE2(dvdqd_prev_vec_in_AZ_dqdPE2),.dvdqd_prev_vec_in_LX_dqdPE2(dvdqd_prev_vec_in_LX_dqdPE2),.dvdqd_prev_vec_in_LY_dqdPE2(dvdqd_prev_vec_in_LY_dqdPE2),.dvdqd_prev_vec_in_LZ_dqdPE2(dvdqd_prev_vec_in_LZ_dqdPE2),
      .dadqd_prev_vec_in_AX_dqdPE2(dadqd_prev_vec_in_AX_dqdPE2),.dadqd_prev_vec_in_AY_dqdPE2(dadqd_prev_vec_in_AY_dqdPE2),.dadqd_prev_vec_in_AZ_dqdPE2(dadqd_prev_vec_in_AZ_dqdPE2),.dadqd_prev_vec_in_LX_dqdPE2(dadqd_prev_vec_in_LX_dqdPE2),.dadqd_prev_vec_in_LY_dqdPE2(dadqd_prev_vec_in_LY_dqdPE2),.dadqd_prev_vec_in_LZ_dqdPE2(dadqd_prev_vec_in_LZ_dqdPE2),
      // dqdPE3
      .link_in_dqdPE3(link_in_dqdPE3),
      .derv_in_dqdPE3(derv_in_dqdPE3),
      .sinq_val_in_dqdPE3(sinq_val_in_dqdPE3),.cosq_val_in_dqdPE3(cosq_val_in_dqdPE3),
      .qd_val_in_dqdPE3(qd_val_in_dqdPE3),
      .v_curr_vec_in_AX_dqdPE3(v_curr_vec_in_AX_dqdPE3),.v_curr_vec_in_AY_dqdPE3(v_curr_vec_in_AY_dqdPE3),.v_curr_vec_in_AZ_dqdPE3(v_curr_vec_in_AZ_dqdPE3),.v_curr_vec_in_LX_dqdPE3(v_curr_vec_in_LX_dqdPE3),.v_curr_vec_in_LY_dqdPE3(v_curr_vec_in_LY_dqdPE3),.v_curr_vec_in_LZ_dqdPE3(v_curr_vec_in_LZ_dqdPE3),
      .a_curr_vec_in_AX_dqdPE3(a_curr_vec_in_AX_dqdPE3),.a_curr_vec_in_AY_dqdPE3(a_curr_vec_in_AY_dqdPE3),.a_curr_vec_in_AZ_dqdPE3(a_curr_vec_in_AZ_dqdPE3),.a_curr_vec_in_LX_dqdPE3(a_curr_vec_in_LX_dqdPE3),.a_curr_vec_in_LY_dqdPE3(a_curr_vec_in_LY_dqdPE3),.a_curr_vec_in_LZ_dqdPE3(a_curr_vec_in_LZ_dqdPE3),
      .dvdqd_prev_vec_in_AX_dqdPE3(dvdqd_prev_vec_in_AX_dqdPE3),.dvdqd_prev_vec_in_AY_dqdPE3(dvdqd_prev_vec_in_AY_dqdPE3),.dvdqd_prev_vec_in_AZ_dqdPE3(dvdqd_prev_vec_in_AZ_dqdPE3),.dvdqd_prev_vec_in_LX_dqdPE3(dvdqd_prev_vec_in_LX_dqdPE3),.dvdqd_prev_vec_in_LY_dqdPE3(dvdqd_prev_vec_in_LY_dqdPE3),.dvdqd_prev_vec_in_LZ_dqdPE3(dvdqd_prev_vec_in_LZ_dqdPE3),
      .dadqd_prev_vec_in_AX_dqdPE3(dadqd_prev_vec_in_AX_dqdPE3),.dadqd_prev_vec_in_AY_dqdPE3(dadqd_prev_vec_in_AY_dqdPE3),.dadqd_prev_vec_in_AZ_dqdPE3(dadqd_prev_vec_in_AZ_dqdPE3),.dadqd_prev_vec_in_LX_dqdPE3(dadqd_prev_vec_in_LX_dqdPE3),.dadqd_prev_vec_in_LY_dqdPE3(dadqd_prev_vec_in_LY_dqdPE3),.dadqd_prev_vec_in_LZ_dqdPE3(dadqd_prev_vec_in_LZ_dqdPE3),
      // dqdPE4
      .link_in_dqdPE4(link_in_dqdPE4),
      .derv_in_dqdPE4(derv_in_dqdPE4),
      .sinq_val_in_dqdPE4(sinq_val_in_dqdPE4),.cosq_val_in_dqdPE4(cosq_val_in_dqdPE4),
      .qd_val_in_dqdPE4(qd_val_in_dqdPE4),
      .v_curr_vec_in_AX_dqdPE4(v_curr_vec_in_AX_dqdPE4),.v_curr_vec_in_AY_dqdPE4(v_curr_vec_in_AY_dqdPE4),.v_curr_vec_in_AZ_dqdPE4(v_curr_vec_in_AZ_dqdPE4),.v_curr_vec_in_LX_dqdPE4(v_curr_vec_in_LX_dqdPE4),.v_curr_vec_in_LY_dqdPE4(v_curr_vec_in_LY_dqdPE4),.v_curr_vec_in_LZ_dqdPE4(v_curr_vec_in_LZ_dqdPE4),
      .a_curr_vec_in_AX_dqdPE4(a_curr_vec_in_AX_dqdPE4),.a_curr_vec_in_AY_dqdPE4(a_curr_vec_in_AY_dqdPE4),.a_curr_vec_in_AZ_dqdPE4(a_curr_vec_in_AZ_dqdPE4),.a_curr_vec_in_LX_dqdPE4(a_curr_vec_in_LX_dqdPE4),.a_curr_vec_in_LY_dqdPE4(a_curr_vec_in_LY_dqdPE4),.a_curr_vec_in_LZ_dqdPE4(a_curr_vec_in_LZ_dqdPE4),
      .dvdqd_prev_vec_in_AX_dqdPE4(dvdqd_prev_vec_in_AX_dqdPE4),.dvdqd_prev_vec_in_AY_dqdPE4(dvdqd_prev_vec_in_AY_dqdPE4),.dvdqd_prev_vec_in_AZ_dqdPE4(dvdqd_prev_vec_in_AZ_dqdPE4),.dvdqd_prev_vec_in_LX_dqdPE4(dvdqd_prev_vec_in_LX_dqdPE4),.dvdqd_prev_vec_in_LY_dqdPE4(dvdqd_prev_vec_in_LY_dqdPE4),.dvdqd_prev_vec_in_LZ_dqdPE4(dvdqd_prev_vec_in_LZ_dqdPE4),
      .dadqd_prev_vec_in_AX_dqdPE4(dadqd_prev_vec_in_AX_dqdPE4),.dadqd_prev_vec_in_AY_dqdPE4(dadqd_prev_vec_in_AY_dqdPE4),.dadqd_prev_vec_in_AZ_dqdPE4(dadqd_prev_vec_in_AZ_dqdPE4),.dadqd_prev_vec_in_LX_dqdPE4(dadqd_prev_vec_in_LX_dqdPE4),.dadqd_prev_vec_in_LY_dqdPE4(dadqd_prev_vec_in_LY_dqdPE4),.dadqd_prev_vec_in_LZ_dqdPE4(dadqd_prev_vec_in_LZ_dqdPE4),
      // dqdPE5
      .link_in_dqdPE5(link_in_dqdPE5),
      .derv_in_dqdPE5(derv_in_dqdPE5),
      .sinq_val_in_dqdPE5(sinq_val_in_dqdPE5),.cosq_val_in_dqdPE5(cosq_val_in_dqdPE5),
      .qd_val_in_dqdPE5(qd_val_in_dqdPE5),
      .v_curr_vec_in_AX_dqdPE5(v_curr_vec_in_AX_dqdPE5),.v_curr_vec_in_AY_dqdPE5(v_curr_vec_in_AY_dqdPE5),.v_curr_vec_in_AZ_dqdPE5(v_curr_vec_in_AZ_dqdPE5),.v_curr_vec_in_LX_dqdPE5(v_curr_vec_in_LX_dqdPE5),.v_curr_vec_in_LY_dqdPE5(v_curr_vec_in_LY_dqdPE5),.v_curr_vec_in_LZ_dqdPE5(v_curr_vec_in_LZ_dqdPE5),
      .a_curr_vec_in_AX_dqdPE5(a_curr_vec_in_AX_dqdPE5),.a_curr_vec_in_AY_dqdPE5(a_curr_vec_in_AY_dqdPE5),.a_curr_vec_in_AZ_dqdPE5(a_curr_vec_in_AZ_dqdPE5),.a_curr_vec_in_LX_dqdPE5(a_curr_vec_in_LX_dqdPE5),.a_curr_vec_in_LY_dqdPE5(a_curr_vec_in_LY_dqdPE5),.a_curr_vec_in_LZ_dqdPE5(a_curr_vec_in_LZ_dqdPE5),
      .dvdqd_prev_vec_in_AX_dqdPE5(dvdqd_prev_vec_in_AX_dqdPE5),.dvdqd_prev_vec_in_AY_dqdPE5(dvdqd_prev_vec_in_AY_dqdPE5),.dvdqd_prev_vec_in_AZ_dqdPE5(dvdqd_prev_vec_in_AZ_dqdPE5),.dvdqd_prev_vec_in_LX_dqdPE5(dvdqd_prev_vec_in_LX_dqdPE5),.dvdqd_prev_vec_in_LY_dqdPE5(dvdqd_prev_vec_in_LY_dqdPE5),.dvdqd_prev_vec_in_LZ_dqdPE5(dvdqd_prev_vec_in_LZ_dqdPE5),
      .dadqd_prev_vec_in_AX_dqdPE5(dadqd_prev_vec_in_AX_dqdPE5),.dadqd_prev_vec_in_AY_dqdPE5(dadqd_prev_vec_in_AY_dqdPE5),.dadqd_prev_vec_in_AZ_dqdPE5(dadqd_prev_vec_in_AZ_dqdPE5),.dadqd_prev_vec_in_LX_dqdPE5(dadqd_prev_vec_in_LX_dqdPE5),.dadqd_prev_vec_in_LY_dqdPE5(dadqd_prev_vec_in_LY_dqdPE5),.dadqd_prev_vec_in_LZ_dqdPE5(dadqd_prev_vec_in_LZ_dqdPE5),
      // dqdPE6
      .link_in_dqdPE6(link_in_dqdPE6),
      .derv_in_dqdPE6(derv_in_dqdPE6),
      .sinq_val_in_dqdPE6(sinq_val_in_dqdPE6),.cosq_val_in_dqdPE6(cosq_val_in_dqdPE6),
      .qd_val_in_dqdPE6(qd_val_in_dqdPE6),
      .v_curr_vec_in_AX_dqdPE6(v_curr_vec_in_AX_dqdPE6),.v_curr_vec_in_AY_dqdPE6(v_curr_vec_in_AY_dqdPE6),.v_curr_vec_in_AZ_dqdPE6(v_curr_vec_in_AZ_dqdPE6),.v_curr_vec_in_LX_dqdPE6(v_curr_vec_in_LX_dqdPE6),.v_curr_vec_in_LY_dqdPE6(v_curr_vec_in_LY_dqdPE6),.v_curr_vec_in_LZ_dqdPE6(v_curr_vec_in_LZ_dqdPE6),
      .a_curr_vec_in_AX_dqdPE6(a_curr_vec_in_AX_dqdPE6),.a_curr_vec_in_AY_dqdPE6(a_curr_vec_in_AY_dqdPE6),.a_curr_vec_in_AZ_dqdPE6(a_curr_vec_in_AZ_dqdPE6),.a_curr_vec_in_LX_dqdPE6(a_curr_vec_in_LX_dqdPE6),.a_curr_vec_in_LY_dqdPE6(a_curr_vec_in_LY_dqdPE6),.a_curr_vec_in_LZ_dqdPE6(a_curr_vec_in_LZ_dqdPE6),
      .dvdqd_prev_vec_in_AX_dqdPE6(dvdqd_prev_vec_in_AX_dqdPE6),.dvdqd_prev_vec_in_AY_dqdPE6(dvdqd_prev_vec_in_AY_dqdPE6),.dvdqd_prev_vec_in_AZ_dqdPE6(dvdqd_prev_vec_in_AZ_dqdPE6),.dvdqd_prev_vec_in_LX_dqdPE6(dvdqd_prev_vec_in_LX_dqdPE6),.dvdqd_prev_vec_in_LY_dqdPE6(dvdqd_prev_vec_in_LY_dqdPE6),.dvdqd_prev_vec_in_LZ_dqdPE6(dvdqd_prev_vec_in_LZ_dqdPE6),
      .dadqd_prev_vec_in_AX_dqdPE6(dadqd_prev_vec_in_AX_dqdPE6),.dadqd_prev_vec_in_AY_dqdPE6(dadqd_prev_vec_in_AY_dqdPE6),.dadqd_prev_vec_in_AZ_dqdPE6(dadqd_prev_vec_in_AZ_dqdPE6),.dadqd_prev_vec_in_LX_dqdPE6(dadqd_prev_vec_in_LX_dqdPE6),.dadqd_prev_vec_in_LY_dqdPE6(dadqd_prev_vec_in_LY_dqdPE6),.dadqd_prev_vec_in_LZ_dqdPE6(dadqd_prev_vec_in_LZ_dqdPE6),
      // dqdPE7
      .link_in_dqdPE7(link_in_dqdPE7),
      .derv_in_dqdPE7(derv_in_dqdPE7),
      .sinq_val_in_dqdPE7(sinq_val_in_dqdPE7),.cosq_val_in_dqdPE7(cosq_val_in_dqdPE7),
      .qd_val_in_dqdPE7(qd_val_in_dqdPE7),
      .v_curr_vec_in_AX_dqdPE7(v_curr_vec_in_AX_dqdPE7),.v_curr_vec_in_AY_dqdPE7(v_curr_vec_in_AY_dqdPE7),.v_curr_vec_in_AZ_dqdPE7(v_curr_vec_in_AZ_dqdPE7),.v_curr_vec_in_LX_dqdPE7(v_curr_vec_in_LX_dqdPE7),.v_curr_vec_in_LY_dqdPE7(v_curr_vec_in_LY_dqdPE7),.v_curr_vec_in_LZ_dqdPE7(v_curr_vec_in_LZ_dqdPE7),
      .a_curr_vec_in_AX_dqdPE7(a_curr_vec_in_AX_dqdPE7),.a_curr_vec_in_AY_dqdPE7(a_curr_vec_in_AY_dqdPE7),.a_curr_vec_in_AZ_dqdPE7(a_curr_vec_in_AZ_dqdPE7),.a_curr_vec_in_LX_dqdPE7(a_curr_vec_in_LX_dqdPE7),.a_curr_vec_in_LY_dqdPE7(a_curr_vec_in_LY_dqdPE7),.a_curr_vec_in_LZ_dqdPE7(a_curr_vec_in_LZ_dqdPE7),
      .dvdqd_prev_vec_in_AX_dqdPE7(dvdqd_prev_vec_in_AX_dqdPE7),.dvdqd_prev_vec_in_AY_dqdPE7(dvdqd_prev_vec_in_AY_dqdPE7),.dvdqd_prev_vec_in_AZ_dqdPE7(dvdqd_prev_vec_in_AZ_dqdPE7),.dvdqd_prev_vec_in_LX_dqdPE7(dvdqd_prev_vec_in_LX_dqdPE7),.dvdqd_prev_vec_in_LY_dqdPE7(dvdqd_prev_vec_in_LY_dqdPE7),.dvdqd_prev_vec_in_LZ_dqdPE7(dvdqd_prev_vec_in_LZ_dqdPE7),
      .dadqd_prev_vec_in_AX_dqdPE7(dadqd_prev_vec_in_AX_dqdPE7),.dadqd_prev_vec_in_AY_dqdPE7(dadqd_prev_vec_in_AY_dqdPE7),.dadqd_prev_vec_in_AZ_dqdPE7(dadqd_prev_vec_in_AZ_dqdPE7),.dadqd_prev_vec_in_LX_dqdPE7(dadqd_prev_vec_in_LX_dqdPE7),.dadqd_prev_vec_in_LY_dqdPE7(dadqd_prev_vec_in_LY_dqdPE7),.dadqd_prev_vec_in_LZ_dqdPE7(dadqd_prev_vec_in_LZ_dqdPE7),
      //------------------------------------------------------------------------
      // output ready
      .output_ready(output_ready),
      // dummy output
      .dummy_output(dummy_output),
      //------------------------------------------------------------------------
      // dq external outputs
      //------------------------------------------------------------------------
      // rnea
      .v_curr_vec_out_AX_rnea(v_curr_vec_out_AX_rnea),.v_curr_vec_out_AY_rnea(v_curr_vec_out_AY_rnea),.v_curr_vec_out_AZ_rnea(v_curr_vec_out_AZ_rnea),.v_curr_vec_out_LX_rnea(v_curr_vec_out_LX_rnea),.v_curr_vec_out_LY_rnea(v_curr_vec_out_LY_rnea),.v_curr_vec_out_LZ_rnea(v_curr_vec_out_LZ_rnea),
      .a_curr_vec_out_AX_rnea(a_curr_vec_out_AX_rnea),.a_curr_vec_out_AY_rnea(a_curr_vec_out_AY_rnea),.a_curr_vec_out_AZ_rnea(a_curr_vec_out_AZ_rnea),.a_curr_vec_out_LX_rnea(a_curr_vec_out_LX_rnea),.a_curr_vec_out_LY_rnea(a_curr_vec_out_LY_rnea),.a_curr_vec_out_LZ_rnea(a_curr_vec_out_LZ_rnea),
      .f_curr_vec_out_AX_rnea(f_curr_vec_out_AX_rnea),.f_curr_vec_out_AY_rnea(f_curr_vec_out_AY_rnea),.f_curr_vec_out_AZ_rnea(f_curr_vec_out_AZ_rnea),.f_curr_vec_out_LX_rnea(f_curr_vec_out_LX_rnea),.f_curr_vec_out_LY_rnea(f_curr_vec_out_LY_rnea),.f_curr_vec_out_LZ_rnea(f_curr_vec_out_LZ_rnea),
      //------------------------------------------------------------------------
      // dq external outputs
      //------------------------------------------------------------------------
      // dqPE1
      .dvdq_curr_vec_out_AX_dqPE1(dvdq_curr_vec_out_AX_dqPE1),.dvdq_curr_vec_out_AY_dqPE1(dvdq_curr_vec_out_AY_dqPE1),.dvdq_curr_vec_out_AZ_dqPE1(dvdq_curr_vec_out_AZ_dqPE1),.dvdq_curr_vec_out_LX_dqPE1(dvdq_curr_vec_out_LX_dqPE1),.dvdq_curr_vec_out_LY_dqPE1(dvdq_curr_vec_out_LY_dqPE1),.dvdq_curr_vec_out_LZ_dqPE1(dvdq_curr_vec_out_LZ_dqPE1),
      .dadq_curr_vec_out_AX_dqPE1(dadq_curr_vec_out_AX_dqPE1),.dadq_curr_vec_out_AY_dqPE1(dadq_curr_vec_out_AY_dqPE1),.dadq_curr_vec_out_AZ_dqPE1(dadq_curr_vec_out_AZ_dqPE1),.dadq_curr_vec_out_LX_dqPE1(dadq_curr_vec_out_LX_dqPE1),.dadq_curr_vec_out_LY_dqPE1(dadq_curr_vec_out_LY_dqPE1),.dadq_curr_vec_out_LZ_dqPE1(dadq_curr_vec_out_LZ_dqPE1),
      .dfdq_curr_vec_out_AX_dqPE1(dfdq_curr_vec_out_AX_dqPE1),.dfdq_curr_vec_out_AY_dqPE1(dfdq_curr_vec_out_AY_dqPE1),.dfdq_curr_vec_out_AZ_dqPE1(dfdq_curr_vec_out_AZ_dqPE1),.dfdq_curr_vec_out_LX_dqPE1(dfdq_curr_vec_out_LX_dqPE1),.dfdq_curr_vec_out_LY_dqPE1(dfdq_curr_vec_out_LY_dqPE1),.dfdq_curr_vec_out_LZ_dqPE1(dfdq_curr_vec_out_LZ_dqPE1),
      // dqPE2
      .dvdq_curr_vec_out_AX_dqPE2(dvdq_curr_vec_out_AX_dqPE2),.dvdq_curr_vec_out_AY_dqPE2(dvdq_curr_vec_out_AY_dqPE2),.dvdq_curr_vec_out_AZ_dqPE2(dvdq_curr_vec_out_AZ_dqPE2),.dvdq_curr_vec_out_LX_dqPE2(dvdq_curr_vec_out_LX_dqPE2),.dvdq_curr_vec_out_LY_dqPE2(dvdq_curr_vec_out_LY_dqPE2),.dvdq_curr_vec_out_LZ_dqPE2(dvdq_curr_vec_out_LZ_dqPE2),
      .dadq_curr_vec_out_AX_dqPE2(dadq_curr_vec_out_AX_dqPE2),.dadq_curr_vec_out_AY_dqPE2(dadq_curr_vec_out_AY_dqPE2),.dadq_curr_vec_out_AZ_dqPE2(dadq_curr_vec_out_AZ_dqPE2),.dadq_curr_vec_out_LX_dqPE2(dadq_curr_vec_out_LX_dqPE2),.dadq_curr_vec_out_LY_dqPE2(dadq_curr_vec_out_LY_dqPE2),.dadq_curr_vec_out_LZ_dqPE2(dadq_curr_vec_out_LZ_dqPE2),
      .dfdq_curr_vec_out_AX_dqPE2(dfdq_curr_vec_out_AX_dqPE2),.dfdq_curr_vec_out_AY_dqPE2(dfdq_curr_vec_out_AY_dqPE2),.dfdq_curr_vec_out_AZ_dqPE2(dfdq_curr_vec_out_AZ_dqPE2),.dfdq_curr_vec_out_LX_dqPE2(dfdq_curr_vec_out_LX_dqPE2),.dfdq_curr_vec_out_LY_dqPE2(dfdq_curr_vec_out_LY_dqPE2),.dfdq_curr_vec_out_LZ_dqPE2(dfdq_curr_vec_out_LZ_dqPE2),
      // dqPE3
      .dvdq_curr_vec_out_AX_dqPE3(dvdq_curr_vec_out_AX_dqPE3),.dvdq_curr_vec_out_AY_dqPE3(dvdq_curr_vec_out_AY_dqPE3),.dvdq_curr_vec_out_AZ_dqPE3(dvdq_curr_vec_out_AZ_dqPE3),.dvdq_curr_vec_out_LX_dqPE3(dvdq_curr_vec_out_LX_dqPE3),.dvdq_curr_vec_out_LY_dqPE3(dvdq_curr_vec_out_LY_dqPE3),.dvdq_curr_vec_out_LZ_dqPE3(dvdq_curr_vec_out_LZ_dqPE3),
      .dadq_curr_vec_out_AX_dqPE3(dadq_curr_vec_out_AX_dqPE3),.dadq_curr_vec_out_AY_dqPE3(dadq_curr_vec_out_AY_dqPE3),.dadq_curr_vec_out_AZ_dqPE3(dadq_curr_vec_out_AZ_dqPE3),.dadq_curr_vec_out_LX_dqPE3(dadq_curr_vec_out_LX_dqPE3),.dadq_curr_vec_out_LY_dqPE3(dadq_curr_vec_out_LY_dqPE3),.dadq_curr_vec_out_LZ_dqPE3(dadq_curr_vec_out_LZ_dqPE3),
      .dfdq_curr_vec_out_AX_dqPE3(dfdq_curr_vec_out_AX_dqPE3),.dfdq_curr_vec_out_AY_dqPE3(dfdq_curr_vec_out_AY_dqPE3),.dfdq_curr_vec_out_AZ_dqPE3(dfdq_curr_vec_out_AZ_dqPE3),.dfdq_curr_vec_out_LX_dqPE3(dfdq_curr_vec_out_LX_dqPE3),.dfdq_curr_vec_out_LY_dqPE3(dfdq_curr_vec_out_LY_dqPE3),.dfdq_curr_vec_out_LZ_dqPE3(dfdq_curr_vec_out_LZ_dqPE3),
      // dqPE4
      .dvdq_curr_vec_out_AX_dqPE4(dvdq_curr_vec_out_AX_dqPE4),.dvdq_curr_vec_out_AY_dqPE4(dvdq_curr_vec_out_AY_dqPE4),.dvdq_curr_vec_out_AZ_dqPE4(dvdq_curr_vec_out_AZ_dqPE4),.dvdq_curr_vec_out_LX_dqPE4(dvdq_curr_vec_out_LX_dqPE4),.dvdq_curr_vec_out_LY_dqPE4(dvdq_curr_vec_out_LY_dqPE4),.dvdq_curr_vec_out_LZ_dqPE4(dvdq_curr_vec_out_LZ_dqPE4),
      .dadq_curr_vec_out_AX_dqPE4(dadq_curr_vec_out_AX_dqPE4),.dadq_curr_vec_out_AY_dqPE4(dadq_curr_vec_out_AY_dqPE4),.dadq_curr_vec_out_AZ_dqPE4(dadq_curr_vec_out_AZ_dqPE4),.dadq_curr_vec_out_LX_dqPE4(dadq_curr_vec_out_LX_dqPE4),.dadq_curr_vec_out_LY_dqPE4(dadq_curr_vec_out_LY_dqPE4),.dadq_curr_vec_out_LZ_dqPE4(dadq_curr_vec_out_LZ_dqPE4),
      .dfdq_curr_vec_out_AX_dqPE4(dfdq_curr_vec_out_AX_dqPE4),.dfdq_curr_vec_out_AY_dqPE4(dfdq_curr_vec_out_AY_dqPE4),.dfdq_curr_vec_out_AZ_dqPE4(dfdq_curr_vec_out_AZ_dqPE4),.dfdq_curr_vec_out_LX_dqPE4(dfdq_curr_vec_out_LX_dqPE4),.dfdq_curr_vec_out_LY_dqPE4(dfdq_curr_vec_out_LY_dqPE4),.dfdq_curr_vec_out_LZ_dqPE4(dfdq_curr_vec_out_LZ_dqPE4),
      // dqPE5
      .dvdq_curr_vec_out_AX_dqPE5(dvdq_curr_vec_out_AX_dqPE5),.dvdq_curr_vec_out_AY_dqPE5(dvdq_curr_vec_out_AY_dqPE5),.dvdq_curr_vec_out_AZ_dqPE5(dvdq_curr_vec_out_AZ_dqPE5),.dvdq_curr_vec_out_LX_dqPE5(dvdq_curr_vec_out_LX_dqPE5),.dvdq_curr_vec_out_LY_dqPE5(dvdq_curr_vec_out_LY_dqPE5),.dvdq_curr_vec_out_LZ_dqPE5(dvdq_curr_vec_out_LZ_dqPE5),
      .dadq_curr_vec_out_AX_dqPE5(dadq_curr_vec_out_AX_dqPE5),.dadq_curr_vec_out_AY_dqPE5(dadq_curr_vec_out_AY_dqPE5),.dadq_curr_vec_out_AZ_dqPE5(dadq_curr_vec_out_AZ_dqPE5),.dadq_curr_vec_out_LX_dqPE5(dadq_curr_vec_out_LX_dqPE5),.dadq_curr_vec_out_LY_dqPE5(dadq_curr_vec_out_LY_dqPE5),.dadq_curr_vec_out_LZ_dqPE5(dadq_curr_vec_out_LZ_dqPE5),
      .dfdq_curr_vec_out_AX_dqPE5(dfdq_curr_vec_out_AX_dqPE5),.dfdq_curr_vec_out_AY_dqPE5(dfdq_curr_vec_out_AY_dqPE5),.dfdq_curr_vec_out_AZ_dqPE5(dfdq_curr_vec_out_AZ_dqPE5),.dfdq_curr_vec_out_LX_dqPE5(dfdq_curr_vec_out_LX_dqPE5),.dfdq_curr_vec_out_LY_dqPE5(dfdq_curr_vec_out_LY_dqPE5),.dfdq_curr_vec_out_LZ_dqPE5(dfdq_curr_vec_out_LZ_dqPE5),
      // dqPE6
      .dvdq_curr_vec_out_AX_dqPE6(dvdq_curr_vec_out_AX_dqPE6),.dvdq_curr_vec_out_AY_dqPE6(dvdq_curr_vec_out_AY_dqPE6),.dvdq_curr_vec_out_AZ_dqPE6(dvdq_curr_vec_out_AZ_dqPE6),.dvdq_curr_vec_out_LX_dqPE6(dvdq_curr_vec_out_LX_dqPE6),.dvdq_curr_vec_out_LY_dqPE6(dvdq_curr_vec_out_LY_dqPE6),.dvdq_curr_vec_out_LZ_dqPE6(dvdq_curr_vec_out_LZ_dqPE6),
      .dadq_curr_vec_out_AX_dqPE6(dadq_curr_vec_out_AX_dqPE6),.dadq_curr_vec_out_AY_dqPE6(dadq_curr_vec_out_AY_dqPE6),.dadq_curr_vec_out_AZ_dqPE6(dadq_curr_vec_out_AZ_dqPE6),.dadq_curr_vec_out_LX_dqPE6(dadq_curr_vec_out_LX_dqPE6),.dadq_curr_vec_out_LY_dqPE6(dadq_curr_vec_out_LY_dqPE6),.dadq_curr_vec_out_LZ_dqPE6(dadq_curr_vec_out_LZ_dqPE6),
      .dfdq_curr_vec_out_AX_dqPE6(dfdq_curr_vec_out_AX_dqPE6),.dfdq_curr_vec_out_AY_dqPE6(dfdq_curr_vec_out_AY_dqPE6),.dfdq_curr_vec_out_AZ_dqPE6(dfdq_curr_vec_out_AZ_dqPE6),.dfdq_curr_vec_out_LX_dqPE6(dfdq_curr_vec_out_LX_dqPE6),.dfdq_curr_vec_out_LY_dqPE6(dfdq_curr_vec_out_LY_dqPE6),.dfdq_curr_vec_out_LZ_dqPE6(dfdq_curr_vec_out_LZ_dqPE6),
      // dqPE7
      .dvdq_curr_vec_out_AX_dqPE7(dvdq_curr_vec_out_AX_dqPE7),.dvdq_curr_vec_out_AY_dqPE7(dvdq_curr_vec_out_AY_dqPE7),.dvdq_curr_vec_out_AZ_dqPE7(dvdq_curr_vec_out_AZ_dqPE7),.dvdq_curr_vec_out_LX_dqPE7(dvdq_curr_vec_out_LX_dqPE7),.dvdq_curr_vec_out_LY_dqPE7(dvdq_curr_vec_out_LY_dqPE7),.dvdq_curr_vec_out_LZ_dqPE7(dvdq_curr_vec_out_LZ_dqPE7),
      .dadq_curr_vec_out_AX_dqPE7(dadq_curr_vec_out_AX_dqPE7),.dadq_curr_vec_out_AY_dqPE7(dadq_curr_vec_out_AY_dqPE7),.dadq_curr_vec_out_AZ_dqPE7(dadq_curr_vec_out_AZ_dqPE7),.dadq_curr_vec_out_LX_dqPE7(dadq_curr_vec_out_LX_dqPE7),.dadq_curr_vec_out_LY_dqPE7(dadq_curr_vec_out_LY_dqPE7),.dadq_curr_vec_out_LZ_dqPE7(dadq_curr_vec_out_LZ_dqPE7),
      .dfdq_curr_vec_out_AX_dqPE7(dfdq_curr_vec_out_AX_dqPE7),.dfdq_curr_vec_out_AY_dqPE7(dfdq_curr_vec_out_AY_dqPE7),.dfdq_curr_vec_out_AZ_dqPE7(dfdq_curr_vec_out_AZ_dqPE7),.dfdq_curr_vec_out_LX_dqPE7(dfdq_curr_vec_out_LX_dqPE7),.dfdq_curr_vec_out_LY_dqPE7(dfdq_curr_vec_out_LY_dqPE7),.dfdq_curr_vec_out_LZ_dqPE7(dfdq_curr_vec_out_LZ_dqPE7),
      //------------------------------------------------------------------------
      // dqd external outputs
      //------------------------------------------------------------------------
      // dqdPE1
      .dvdqd_curr_vec_out_AX_dqdPE1(dvdqd_curr_vec_out_AX_dqdPE1),.dvdqd_curr_vec_out_AY_dqdPE1(dvdqd_curr_vec_out_AY_dqdPE1),.dvdqd_curr_vec_out_AZ_dqdPE1(dvdqd_curr_vec_out_AZ_dqdPE1),.dvdqd_curr_vec_out_LX_dqdPE1(dvdqd_curr_vec_out_LX_dqdPE1),.dvdqd_curr_vec_out_LY_dqdPE1(dvdqd_curr_vec_out_LY_dqdPE1),.dvdqd_curr_vec_out_LZ_dqdPE1(dvdqd_curr_vec_out_LZ_dqdPE1),
      .dadqd_curr_vec_out_AX_dqdPE1(dadqd_curr_vec_out_AX_dqdPE1),.dadqd_curr_vec_out_AY_dqdPE1(dadqd_curr_vec_out_AY_dqdPE1),.dadqd_curr_vec_out_AZ_dqdPE1(dadqd_curr_vec_out_AZ_dqdPE1),.dadqd_curr_vec_out_LX_dqdPE1(dadqd_curr_vec_out_LX_dqdPE1),.dadqd_curr_vec_out_LY_dqdPE1(dadqd_curr_vec_out_LY_dqdPE1),.dadqd_curr_vec_out_LZ_dqdPE1(dadqd_curr_vec_out_LZ_dqdPE1),
      .dfdqd_curr_vec_out_AX_dqdPE1(dfdqd_curr_vec_out_AX_dqdPE1),.dfdqd_curr_vec_out_AY_dqdPE1(dfdqd_curr_vec_out_AY_dqdPE1),.dfdqd_curr_vec_out_AZ_dqdPE1(dfdqd_curr_vec_out_AZ_dqdPE1),.dfdqd_curr_vec_out_LX_dqdPE1(dfdqd_curr_vec_out_LX_dqdPE1),.dfdqd_curr_vec_out_LY_dqdPE1(dfdqd_curr_vec_out_LY_dqdPE1),.dfdqd_curr_vec_out_LZ_dqdPE1(dfdqd_curr_vec_out_LZ_dqdPE1),
      // dqdPE2
      .dvdqd_curr_vec_out_AX_dqdPE2(dvdqd_curr_vec_out_AX_dqdPE2),.dvdqd_curr_vec_out_AY_dqdPE2(dvdqd_curr_vec_out_AY_dqdPE2),.dvdqd_curr_vec_out_AZ_dqdPE2(dvdqd_curr_vec_out_AZ_dqdPE2),.dvdqd_curr_vec_out_LX_dqdPE2(dvdqd_curr_vec_out_LX_dqdPE2),.dvdqd_curr_vec_out_LY_dqdPE2(dvdqd_curr_vec_out_LY_dqdPE2),.dvdqd_curr_vec_out_LZ_dqdPE2(dvdqd_curr_vec_out_LZ_dqdPE2),
      .dadqd_curr_vec_out_AX_dqdPE2(dadqd_curr_vec_out_AX_dqdPE2),.dadqd_curr_vec_out_AY_dqdPE2(dadqd_curr_vec_out_AY_dqdPE2),.dadqd_curr_vec_out_AZ_dqdPE2(dadqd_curr_vec_out_AZ_dqdPE2),.dadqd_curr_vec_out_LX_dqdPE2(dadqd_curr_vec_out_LX_dqdPE2),.dadqd_curr_vec_out_LY_dqdPE2(dadqd_curr_vec_out_LY_dqdPE2),.dadqd_curr_vec_out_LZ_dqdPE2(dadqd_curr_vec_out_LZ_dqdPE2),
      .dfdqd_curr_vec_out_AX_dqdPE2(dfdqd_curr_vec_out_AX_dqdPE2),.dfdqd_curr_vec_out_AY_dqdPE2(dfdqd_curr_vec_out_AY_dqdPE2),.dfdqd_curr_vec_out_AZ_dqdPE2(dfdqd_curr_vec_out_AZ_dqdPE2),.dfdqd_curr_vec_out_LX_dqdPE2(dfdqd_curr_vec_out_LX_dqdPE2),.dfdqd_curr_vec_out_LY_dqdPE2(dfdqd_curr_vec_out_LY_dqdPE2),.dfdqd_curr_vec_out_LZ_dqdPE2(dfdqd_curr_vec_out_LZ_dqdPE2),
      // dqdPE3
      .dvdqd_curr_vec_out_AX_dqdPE3(dvdqd_curr_vec_out_AX_dqdPE3),.dvdqd_curr_vec_out_AY_dqdPE3(dvdqd_curr_vec_out_AY_dqdPE3),.dvdqd_curr_vec_out_AZ_dqdPE3(dvdqd_curr_vec_out_AZ_dqdPE3),.dvdqd_curr_vec_out_LX_dqdPE3(dvdqd_curr_vec_out_LX_dqdPE3),.dvdqd_curr_vec_out_LY_dqdPE3(dvdqd_curr_vec_out_LY_dqdPE3),.dvdqd_curr_vec_out_LZ_dqdPE3(dvdqd_curr_vec_out_LZ_dqdPE3),
      .dadqd_curr_vec_out_AX_dqdPE3(dadqd_curr_vec_out_AX_dqdPE3),.dadqd_curr_vec_out_AY_dqdPE3(dadqd_curr_vec_out_AY_dqdPE3),.dadqd_curr_vec_out_AZ_dqdPE3(dadqd_curr_vec_out_AZ_dqdPE3),.dadqd_curr_vec_out_LX_dqdPE3(dadqd_curr_vec_out_LX_dqdPE3),.dadqd_curr_vec_out_LY_dqdPE3(dadqd_curr_vec_out_LY_dqdPE3),.dadqd_curr_vec_out_LZ_dqdPE3(dadqd_curr_vec_out_LZ_dqdPE3),
      .dfdqd_curr_vec_out_AX_dqdPE3(dfdqd_curr_vec_out_AX_dqdPE3),.dfdqd_curr_vec_out_AY_dqdPE3(dfdqd_curr_vec_out_AY_dqdPE3),.dfdqd_curr_vec_out_AZ_dqdPE3(dfdqd_curr_vec_out_AZ_dqdPE3),.dfdqd_curr_vec_out_LX_dqdPE3(dfdqd_curr_vec_out_LX_dqdPE3),.dfdqd_curr_vec_out_LY_dqdPE3(dfdqd_curr_vec_out_LY_dqdPE3),.dfdqd_curr_vec_out_LZ_dqdPE3(dfdqd_curr_vec_out_LZ_dqdPE3),
      // dqdPE4
      .dvdqd_curr_vec_out_AX_dqdPE4(dvdqd_curr_vec_out_AX_dqdPE4),.dvdqd_curr_vec_out_AY_dqdPE4(dvdqd_curr_vec_out_AY_dqdPE4),.dvdqd_curr_vec_out_AZ_dqdPE4(dvdqd_curr_vec_out_AZ_dqdPE4),.dvdqd_curr_vec_out_LX_dqdPE4(dvdqd_curr_vec_out_LX_dqdPE4),.dvdqd_curr_vec_out_LY_dqdPE4(dvdqd_curr_vec_out_LY_dqdPE4),.dvdqd_curr_vec_out_LZ_dqdPE4(dvdqd_curr_vec_out_LZ_dqdPE4),
      .dadqd_curr_vec_out_AX_dqdPE4(dadqd_curr_vec_out_AX_dqdPE4),.dadqd_curr_vec_out_AY_dqdPE4(dadqd_curr_vec_out_AY_dqdPE4),.dadqd_curr_vec_out_AZ_dqdPE4(dadqd_curr_vec_out_AZ_dqdPE4),.dadqd_curr_vec_out_LX_dqdPE4(dadqd_curr_vec_out_LX_dqdPE4),.dadqd_curr_vec_out_LY_dqdPE4(dadqd_curr_vec_out_LY_dqdPE4),.dadqd_curr_vec_out_LZ_dqdPE4(dadqd_curr_vec_out_LZ_dqdPE4),
      .dfdqd_curr_vec_out_AX_dqdPE4(dfdqd_curr_vec_out_AX_dqdPE4),.dfdqd_curr_vec_out_AY_dqdPE4(dfdqd_curr_vec_out_AY_dqdPE4),.dfdqd_curr_vec_out_AZ_dqdPE4(dfdqd_curr_vec_out_AZ_dqdPE4),.dfdqd_curr_vec_out_LX_dqdPE4(dfdqd_curr_vec_out_LX_dqdPE4),.dfdqd_curr_vec_out_LY_dqdPE4(dfdqd_curr_vec_out_LY_dqdPE4),.dfdqd_curr_vec_out_LZ_dqdPE4(dfdqd_curr_vec_out_LZ_dqdPE4),
      // dqdPE5
      .dvdqd_curr_vec_out_AX_dqdPE5(dvdqd_curr_vec_out_AX_dqdPE5),.dvdqd_curr_vec_out_AY_dqdPE5(dvdqd_curr_vec_out_AY_dqdPE5),.dvdqd_curr_vec_out_AZ_dqdPE5(dvdqd_curr_vec_out_AZ_dqdPE5),.dvdqd_curr_vec_out_LX_dqdPE5(dvdqd_curr_vec_out_LX_dqdPE5),.dvdqd_curr_vec_out_LY_dqdPE5(dvdqd_curr_vec_out_LY_dqdPE5),.dvdqd_curr_vec_out_LZ_dqdPE5(dvdqd_curr_vec_out_LZ_dqdPE5),
      .dadqd_curr_vec_out_AX_dqdPE5(dadqd_curr_vec_out_AX_dqdPE5),.dadqd_curr_vec_out_AY_dqdPE5(dadqd_curr_vec_out_AY_dqdPE5),.dadqd_curr_vec_out_AZ_dqdPE5(dadqd_curr_vec_out_AZ_dqdPE5),.dadqd_curr_vec_out_LX_dqdPE5(dadqd_curr_vec_out_LX_dqdPE5),.dadqd_curr_vec_out_LY_dqdPE5(dadqd_curr_vec_out_LY_dqdPE5),.dadqd_curr_vec_out_LZ_dqdPE5(dadqd_curr_vec_out_LZ_dqdPE5),
      .dfdqd_curr_vec_out_AX_dqdPE5(dfdqd_curr_vec_out_AX_dqdPE5),.dfdqd_curr_vec_out_AY_dqdPE5(dfdqd_curr_vec_out_AY_dqdPE5),.dfdqd_curr_vec_out_AZ_dqdPE5(dfdqd_curr_vec_out_AZ_dqdPE5),.dfdqd_curr_vec_out_LX_dqdPE5(dfdqd_curr_vec_out_LX_dqdPE5),.dfdqd_curr_vec_out_LY_dqdPE5(dfdqd_curr_vec_out_LY_dqdPE5),.dfdqd_curr_vec_out_LZ_dqdPE5(dfdqd_curr_vec_out_LZ_dqdPE5),
      // dqdPE6
      .dvdqd_curr_vec_out_AX_dqdPE6(dvdqd_curr_vec_out_AX_dqdPE6),.dvdqd_curr_vec_out_AY_dqdPE6(dvdqd_curr_vec_out_AY_dqdPE6),.dvdqd_curr_vec_out_AZ_dqdPE6(dvdqd_curr_vec_out_AZ_dqdPE6),.dvdqd_curr_vec_out_LX_dqdPE6(dvdqd_curr_vec_out_LX_dqdPE6),.dvdqd_curr_vec_out_LY_dqdPE6(dvdqd_curr_vec_out_LY_dqdPE6),.dvdqd_curr_vec_out_LZ_dqdPE6(dvdqd_curr_vec_out_LZ_dqdPE6),
      .dadqd_curr_vec_out_AX_dqdPE6(dadqd_curr_vec_out_AX_dqdPE6),.dadqd_curr_vec_out_AY_dqdPE6(dadqd_curr_vec_out_AY_dqdPE6),.dadqd_curr_vec_out_AZ_dqdPE6(dadqd_curr_vec_out_AZ_dqdPE6),.dadqd_curr_vec_out_LX_dqdPE6(dadqd_curr_vec_out_LX_dqdPE6),.dadqd_curr_vec_out_LY_dqdPE6(dadqd_curr_vec_out_LY_dqdPE6),.dadqd_curr_vec_out_LZ_dqdPE6(dadqd_curr_vec_out_LZ_dqdPE6),
      .dfdqd_curr_vec_out_AX_dqdPE6(dfdqd_curr_vec_out_AX_dqdPE6),.dfdqd_curr_vec_out_AY_dqdPE6(dfdqd_curr_vec_out_AY_dqdPE6),.dfdqd_curr_vec_out_AZ_dqdPE6(dfdqd_curr_vec_out_AZ_dqdPE6),.dfdqd_curr_vec_out_LX_dqdPE6(dfdqd_curr_vec_out_LX_dqdPE6),.dfdqd_curr_vec_out_LY_dqdPE6(dfdqd_curr_vec_out_LY_dqdPE6),.dfdqd_curr_vec_out_LZ_dqdPE6(dfdqd_curr_vec_out_LZ_dqdPE6),
      // dqdPE7
      .dvdqd_curr_vec_out_AX_dqdPE7(dvdqd_curr_vec_out_AX_dqdPE7),.dvdqd_curr_vec_out_AY_dqdPE7(dvdqd_curr_vec_out_AY_dqdPE7),.dvdqd_curr_vec_out_AZ_dqdPE7(dvdqd_curr_vec_out_AZ_dqdPE7),.dvdqd_curr_vec_out_LX_dqdPE7(dvdqd_curr_vec_out_LX_dqdPE7),.dvdqd_curr_vec_out_LY_dqdPE7(dvdqd_curr_vec_out_LY_dqdPE7),.dvdqd_curr_vec_out_LZ_dqdPE7(dvdqd_curr_vec_out_LZ_dqdPE7),
      .dadqd_curr_vec_out_AX_dqdPE7(dadqd_curr_vec_out_AX_dqdPE7),.dadqd_curr_vec_out_AY_dqdPE7(dadqd_curr_vec_out_AY_dqdPE7),.dadqd_curr_vec_out_AZ_dqdPE7(dadqd_curr_vec_out_AZ_dqdPE7),.dadqd_curr_vec_out_LX_dqdPE7(dadqd_curr_vec_out_LX_dqdPE7),.dadqd_curr_vec_out_LY_dqdPE7(dadqd_curr_vec_out_LY_dqdPE7),.dadqd_curr_vec_out_LZ_dqdPE7(dadqd_curr_vec_out_LZ_dqdPE7),
      .dfdqd_curr_vec_out_AX_dqdPE7(dfdqd_curr_vec_out_AX_dqdPE7),.dfdqd_curr_vec_out_AY_dqdPE7(dfdqd_curr_vec_out_AY_dqdPE7),.dfdqd_curr_vec_out_AZ_dqdPE7(dfdqd_curr_vec_out_AZ_dqdPE7),.dfdqd_curr_vec_out_LX_dqdPE7(dfdqd_curr_vec_out_LX_dqdPE7),.dfdqd_curr_vec_out_LY_dqdPE7(dfdqd_curr_vec_out_LY_dqdPE7),.dfdqd_curr_vec_out_LZ_dqdPE7(dfdqd_curr_vec_out_LZ_dqdPE7)
      //------------------------------------------------------------------------
      );

   initial begin
      #10;
      // initialize
      clk = 0;
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 0;
      sinq_val_in_rnea = 0; cosq_val_in_rnea = 0;
      qd_val_in_rnea = 0;
      qdd_val_in_rnea = 0;
      v_prev_vec_in_AX_rnea = 0; v_prev_vec_in_AY_rnea = 0; v_prev_vec_in_AZ_rnea = 0; v_prev_vec_in_LX_rnea = 0; v_prev_vec_in_LY_rnea = 0; v_prev_vec_in_LZ_rnea = 0;
      a_prev_vec_in_AX_rnea = 0; a_prev_vec_in_AY_rnea = 0; a_prev_vec_in_AZ_rnea = 0; a_prev_vec_in_LX_rnea = 0; a_prev_vec_in_LY_rnea = 0; a_prev_vec_in_LZ_rnea = 0;
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 0;
      derv_in_dqPE1 = 3'd1;
      sinq_val_in_dqPE1 = 0; cosq_val_in_dqPE1 = 0;
      qd_val_in_dqPE1 = 0;
      v_curr_vec_in_AX_dqPE1 = 0; v_curr_vec_in_AY_dqPE1 = 0; v_curr_vec_in_AZ_dqPE1 = 0; v_curr_vec_in_LX_dqPE1 = 0; v_curr_vec_in_LY_dqPE1 = 0; v_curr_vec_in_LZ_dqPE1 = 0;
      a_curr_vec_in_AX_dqPE1 = 0; a_curr_vec_in_AY_dqPE1 = 0; a_curr_vec_in_AZ_dqPE1 = 0; a_curr_vec_in_LX_dqPE1 = 0; a_curr_vec_in_LY_dqPE1 = 0; a_curr_vec_in_LZ_dqPE1 = 0;
      v_prev_vec_in_AX_dqPE1 = 0; v_prev_vec_in_AY_dqPE1 = 0; v_prev_vec_in_AZ_dqPE1 = 0; v_prev_vec_in_LX_dqPE1 = 0; v_prev_vec_in_LY_dqPE1 = 0; v_prev_vec_in_LZ_dqPE1 = 0;
      a_prev_vec_in_AX_dqPE1 = 0; a_prev_vec_in_AY_dqPE1 = 0; a_prev_vec_in_AZ_dqPE1 = 0; a_prev_vec_in_LX_dqPE1 = 0; a_prev_vec_in_LY_dqPE1 = 0; a_prev_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      link_in_dqPE2 = 0;
      derv_in_dqPE2 = 3'd2;
      sinq_val_in_dqPE2 = 0; cosq_val_in_dqPE2 = 0;
      qd_val_in_dqPE2 = 0;
      v_curr_vec_in_AX_dqPE2 = 0; v_curr_vec_in_AY_dqPE2 = 0; v_curr_vec_in_AZ_dqPE2 = 0; v_curr_vec_in_LX_dqPE2 = 0; v_curr_vec_in_LY_dqPE2 = 0; v_curr_vec_in_LZ_dqPE2 = 0;
      a_curr_vec_in_AX_dqPE2 = 0; a_curr_vec_in_AY_dqPE2 = 0; a_curr_vec_in_AZ_dqPE2 = 0; a_curr_vec_in_LX_dqPE2 = 0; a_curr_vec_in_LY_dqPE2 = 0; a_curr_vec_in_LZ_dqPE2 = 0;
      v_prev_vec_in_AX_dqPE2 = 0; v_prev_vec_in_AY_dqPE2 = 0; v_prev_vec_in_AZ_dqPE2 = 0; v_prev_vec_in_LX_dqPE2 = 0; v_prev_vec_in_LY_dqPE2 = 0; v_prev_vec_in_LZ_dqPE2 = 0;
      a_prev_vec_in_AX_dqPE2 = 0; a_prev_vec_in_AY_dqPE2 = 0; a_prev_vec_in_AZ_dqPE2 = 0; a_prev_vec_in_LX_dqPE2 = 0; a_prev_vec_in_LY_dqPE2 = 0; a_prev_vec_in_LZ_dqPE2 = 0;
      // dqPE3
      link_in_dqPE3 = 0;
      derv_in_dqPE3 = 3'd3;
      sinq_val_in_dqPE3 = 0; cosq_val_in_dqPE3 = 0;
      qd_val_in_dqPE3 = 0;
      v_curr_vec_in_AX_dqPE3 = 0; v_curr_vec_in_AY_dqPE3 = 0; v_curr_vec_in_AZ_dqPE3 = 0; v_curr_vec_in_LX_dqPE3 = 0; v_curr_vec_in_LY_dqPE3 = 0; v_curr_vec_in_LZ_dqPE3 = 0;
      a_curr_vec_in_AX_dqPE3 = 0; a_curr_vec_in_AY_dqPE3 = 0; a_curr_vec_in_AZ_dqPE3 = 0; a_curr_vec_in_LX_dqPE3 = 0; a_curr_vec_in_LY_dqPE3 = 0; a_curr_vec_in_LZ_dqPE3 = 0;
      v_prev_vec_in_AX_dqPE3 = 0; v_prev_vec_in_AY_dqPE3 = 0; v_prev_vec_in_AZ_dqPE3 = 0; v_prev_vec_in_LX_dqPE3 = 0; v_prev_vec_in_LY_dqPE3 = 0; v_prev_vec_in_LZ_dqPE3 = 0;
      a_prev_vec_in_AX_dqPE3 = 0; a_prev_vec_in_AY_dqPE3 = 0; a_prev_vec_in_AZ_dqPE3 = 0; a_prev_vec_in_LX_dqPE3 = 0; a_prev_vec_in_LY_dqPE3 = 0; a_prev_vec_in_LZ_dqPE3 = 0;
      // dqPE4
      link_in_dqPE4 = 0;
      derv_in_dqPE4 = 3'd4;
      sinq_val_in_dqPE4 = 0; cosq_val_in_dqPE4 = 0;
      qd_val_in_dqPE4 = 0;
      v_curr_vec_in_AX_dqPE4 = 0; v_curr_vec_in_AY_dqPE4 = 0; v_curr_vec_in_AZ_dqPE4 = 0; v_curr_vec_in_LX_dqPE4 = 0; v_curr_vec_in_LY_dqPE4 = 0; v_curr_vec_in_LZ_dqPE4 = 0;
      a_curr_vec_in_AX_dqPE4 = 0; a_curr_vec_in_AY_dqPE4 = 0; a_curr_vec_in_AZ_dqPE4 = 0; a_curr_vec_in_LX_dqPE4 = 0; a_curr_vec_in_LY_dqPE4 = 0; a_curr_vec_in_LZ_dqPE4 = 0;
      v_prev_vec_in_AX_dqPE4 = 0; v_prev_vec_in_AY_dqPE4 = 0; v_prev_vec_in_AZ_dqPE4 = 0; v_prev_vec_in_LX_dqPE4 = 0; v_prev_vec_in_LY_dqPE4 = 0; v_prev_vec_in_LZ_dqPE4 = 0;
      a_prev_vec_in_AX_dqPE4 = 0; a_prev_vec_in_AY_dqPE4 = 0; a_prev_vec_in_AZ_dqPE4 = 0; a_prev_vec_in_LX_dqPE4 = 0; a_prev_vec_in_LY_dqPE4 = 0; a_prev_vec_in_LZ_dqPE4 = 0;
      // dqPE5
      link_in_dqPE5 = 0;
      derv_in_dqPE5 = 3'd5;
      sinq_val_in_dqPE5 = 0; cosq_val_in_dqPE5 = 0;
      qd_val_in_dqPE5 = 0;
      v_curr_vec_in_AX_dqPE5 = 0; v_curr_vec_in_AY_dqPE5 = 0; v_curr_vec_in_AZ_dqPE5 = 0; v_curr_vec_in_LX_dqPE5 = 0; v_curr_vec_in_LY_dqPE5 = 0; v_curr_vec_in_LZ_dqPE5 = 0;
      a_curr_vec_in_AX_dqPE5 = 0; a_curr_vec_in_AY_dqPE5 = 0; a_curr_vec_in_AZ_dqPE5 = 0; a_curr_vec_in_LX_dqPE5 = 0; a_curr_vec_in_LY_dqPE5 = 0; a_curr_vec_in_LZ_dqPE5 = 0;
      v_prev_vec_in_AX_dqPE5 = 0; v_prev_vec_in_AY_dqPE5 = 0; v_prev_vec_in_AZ_dqPE5 = 0; v_prev_vec_in_LX_dqPE5 = 0; v_prev_vec_in_LY_dqPE5 = 0; v_prev_vec_in_LZ_dqPE5 = 0;
      a_prev_vec_in_AX_dqPE5 = 0; a_prev_vec_in_AY_dqPE5 = 0; a_prev_vec_in_AZ_dqPE5 = 0; a_prev_vec_in_LX_dqPE5 = 0; a_prev_vec_in_LY_dqPE5 = 0; a_prev_vec_in_LZ_dqPE5 = 0;
      // dqPE6
      link_in_dqPE6 = 0;
      derv_in_dqPE6 = 3'd6;
      sinq_val_in_dqPE6 = 0; cosq_val_in_dqPE6 = 0;
      qd_val_in_dqPE6 = 0;
      v_curr_vec_in_AX_dqPE6 = 0; v_curr_vec_in_AY_dqPE6 = 0; v_curr_vec_in_AZ_dqPE6 = 0; v_curr_vec_in_LX_dqPE6 = 0; v_curr_vec_in_LY_dqPE6 = 0; v_curr_vec_in_LZ_dqPE6 = 0;
      a_curr_vec_in_AX_dqPE6 = 0; a_curr_vec_in_AY_dqPE6 = 0; a_curr_vec_in_AZ_dqPE6 = 0; a_curr_vec_in_LX_dqPE6 = 0; a_curr_vec_in_LY_dqPE6 = 0; a_curr_vec_in_LZ_dqPE6 = 0;
      v_prev_vec_in_AX_dqPE6 = 0; v_prev_vec_in_AY_dqPE6 = 0; v_prev_vec_in_AZ_dqPE6 = 0; v_prev_vec_in_LX_dqPE6 = 0; v_prev_vec_in_LY_dqPE6 = 0; v_prev_vec_in_LZ_dqPE6 = 0;
      a_prev_vec_in_AX_dqPE6 = 0; a_prev_vec_in_AY_dqPE6 = 0; a_prev_vec_in_AZ_dqPE6 = 0; a_prev_vec_in_LX_dqPE6 = 0; a_prev_vec_in_LY_dqPE6 = 0; a_prev_vec_in_LZ_dqPE6 = 0;
      // dqPE7
      link_in_dqPE7 = 0;
      derv_in_dqPE7 = 3'd7;
      sinq_val_in_dqPE7 = 0; cosq_val_in_dqPE7 = 0;
      qd_val_in_dqPE7 = 0;
      v_curr_vec_in_AX_dqPE7 = 0; v_curr_vec_in_AY_dqPE7 = 0; v_curr_vec_in_AZ_dqPE7 = 0; v_curr_vec_in_LX_dqPE7 = 0; v_curr_vec_in_LY_dqPE7 = 0; v_curr_vec_in_LZ_dqPE7 = 0;
      a_curr_vec_in_AX_dqPE7 = 0; a_curr_vec_in_AY_dqPE7 = 0; a_curr_vec_in_AZ_dqPE7 = 0; a_curr_vec_in_LX_dqPE7 = 0; a_curr_vec_in_LY_dqPE7 = 0; a_curr_vec_in_LZ_dqPE7 = 0;
      v_prev_vec_in_AX_dqPE7 = 0; v_prev_vec_in_AY_dqPE7 = 0; v_prev_vec_in_AZ_dqPE7 = 0; v_prev_vec_in_LX_dqPE7 = 0; v_prev_vec_in_LY_dqPE7 = 0; v_prev_vec_in_LZ_dqPE7 = 0;
      a_prev_vec_in_AX_dqPE7 = 0; a_prev_vec_in_AY_dqPE7 = 0; a_prev_vec_in_AZ_dqPE7 = 0; a_prev_vec_in_LX_dqPE7 = 0; a_prev_vec_in_LY_dqPE7 = 0; a_prev_vec_in_LZ_dqPE7 = 0;
      // External dv,da
      // dqPE1
      dvdq_prev_vec_in_AX_dqPE1 = 0; dvdq_prev_vec_in_AY_dqPE1 = 0; dvdq_prev_vec_in_AZ_dqPE1 = 0; dvdq_prev_vec_in_LX_dqPE1 = 0; dvdq_prev_vec_in_LY_dqPE1 = 0; dvdq_prev_vec_in_LZ_dqPE1 = 0;
      dadq_prev_vec_in_AX_dqPE1 = 0; dadq_prev_vec_in_AY_dqPE1 = 0; dadq_prev_vec_in_AZ_dqPE1 = 0; dadq_prev_vec_in_LX_dqPE1 = 0; dadq_prev_vec_in_LY_dqPE1 = 0; dadq_prev_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      dvdq_prev_vec_in_AX_dqPE2 = 0; dvdq_prev_vec_in_AY_dqPE2 = 0; dvdq_prev_vec_in_AZ_dqPE2 = 0; dvdq_prev_vec_in_LX_dqPE2 = 0; dvdq_prev_vec_in_LY_dqPE2 = 0; dvdq_prev_vec_in_LZ_dqPE2 = 0;
      dadq_prev_vec_in_AX_dqPE2 = 0; dadq_prev_vec_in_AY_dqPE2 = 0; dadq_prev_vec_in_AZ_dqPE2 = 0; dadq_prev_vec_in_LX_dqPE2 = 0; dadq_prev_vec_in_LY_dqPE2 = 0; dadq_prev_vec_in_LZ_dqPE2 = 0;
      // dqPE3
      dvdq_prev_vec_in_AX_dqPE3 = 0; dvdq_prev_vec_in_AY_dqPE3 = 0; dvdq_prev_vec_in_AZ_dqPE3 = 0; dvdq_prev_vec_in_LX_dqPE3 = 0; dvdq_prev_vec_in_LY_dqPE3 = 0; dvdq_prev_vec_in_LZ_dqPE3 = 0;
      dadq_prev_vec_in_AX_dqPE3 = 0; dadq_prev_vec_in_AY_dqPE3 = 0; dadq_prev_vec_in_AZ_dqPE3 = 0; dadq_prev_vec_in_LX_dqPE3 = 0; dadq_prev_vec_in_LY_dqPE3 = 0; dadq_prev_vec_in_LZ_dqPE3 = 0;
      // dqPE4
      dvdq_prev_vec_in_AX_dqPE4 = 0; dvdq_prev_vec_in_AY_dqPE4 = 0; dvdq_prev_vec_in_AZ_dqPE4 = 0; dvdq_prev_vec_in_LX_dqPE4 = 0; dvdq_prev_vec_in_LY_dqPE4 = 0; dvdq_prev_vec_in_LZ_dqPE4 = 0;
      dadq_prev_vec_in_AX_dqPE4 = 0; dadq_prev_vec_in_AY_dqPE4 = 0; dadq_prev_vec_in_AZ_dqPE4 = 0; dadq_prev_vec_in_LX_dqPE4 = 0; dadq_prev_vec_in_LY_dqPE4 = 0; dadq_prev_vec_in_LZ_dqPE4 = 0;
      // dqPE5
      dvdq_prev_vec_in_AX_dqPE5 = 0; dvdq_prev_vec_in_AY_dqPE5 = 0; dvdq_prev_vec_in_AZ_dqPE5 = 0; dvdq_prev_vec_in_LX_dqPE5 = 0; dvdq_prev_vec_in_LY_dqPE5 = 0; dvdq_prev_vec_in_LZ_dqPE5 = 0;
      dadq_prev_vec_in_AX_dqPE5 = 0; dadq_prev_vec_in_AY_dqPE5 = 0; dadq_prev_vec_in_AZ_dqPE5 = 0; dadq_prev_vec_in_LX_dqPE5 = 0; dadq_prev_vec_in_LY_dqPE5 = 0; dadq_prev_vec_in_LZ_dqPE5 = 0;
      // dqPE6
      dvdq_prev_vec_in_AX_dqPE6 = 0; dvdq_prev_vec_in_AY_dqPE6 = 0; dvdq_prev_vec_in_AZ_dqPE6 = 0; dvdq_prev_vec_in_LX_dqPE6 = 0; dvdq_prev_vec_in_LY_dqPE6 = 0; dvdq_prev_vec_in_LZ_dqPE6 = 0;
      dadq_prev_vec_in_AX_dqPE6 = 0; dadq_prev_vec_in_AY_dqPE6 = 0; dadq_prev_vec_in_AZ_dqPE6 = 0; dadq_prev_vec_in_LX_dqPE6 = 0; dadq_prev_vec_in_LY_dqPE6 = 0; dadq_prev_vec_in_LZ_dqPE6 = 0;
      // dqPE7
      dvdq_prev_vec_in_AX_dqPE7 = 0; dvdq_prev_vec_in_AY_dqPE7 = 0; dvdq_prev_vec_in_AZ_dqPE7 = 0; dvdq_prev_vec_in_LX_dqPE7 = 0; dvdq_prev_vec_in_LY_dqPE7 = 0; dvdq_prev_vec_in_LZ_dqPE7 = 0;
      dadq_prev_vec_in_AX_dqPE7 = 0; dadq_prev_vec_in_AY_dqPE7 = 0; dadq_prev_vec_in_AZ_dqPE7 = 0; dadq_prev_vec_in_LX_dqPE7 = 0; dadq_prev_vec_in_LY_dqPE7 = 0; dadq_prev_vec_in_LZ_dqPE7 = 0;
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 0;
      derv_in_dqdPE1 = 3'd1;
      sinq_val_in_dqdPE1 = 0; cosq_val_in_dqdPE1 = 0;
      qd_val_in_dqdPE1 = 0;
      v_curr_vec_in_AX_dqdPE1 = 0; v_curr_vec_in_AY_dqdPE1 = 0; v_curr_vec_in_AZ_dqdPE1 = 0; v_curr_vec_in_LX_dqdPE1 = 0; v_curr_vec_in_LY_dqdPE1 = 0; v_curr_vec_in_LZ_dqdPE1 = 0;
      a_curr_vec_in_AX_dqdPE1 = 0; a_curr_vec_in_AY_dqdPE1 = 0; a_curr_vec_in_AZ_dqdPE1 = 0; a_curr_vec_in_LX_dqdPE1 = 0; a_curr_vec_in_LY_dqdPE1 = 0; a_curr_vec_in_LZ_dqdPE1 = 0;
      // dqdPE2
      link_in_dqdPE2 = 0;
      derv_in_dqdPE2 = 3'd2;
      sinq_val_in_dqdPE2 = 0; cosq_val_in_dqdPE2 = 0;
      qd_val_in_dqdPE2 = 0;
      v_curr_vec_in_AX_dqdPE2 = 0; v_curr_vec_in_AY_dqdPE2 = 0; v_curr_vec_in_AZ_dqdPE2 = 0; v_curr_vec_in_LX_dqdPE2 = 0; v_curr_vec_in_LY_dqdPE2 = 0; v_curr_vec_in_LZ_dqdPE2 = 0;
      a_curr_vec_in_AX_dqdPE2 = 0; a_curr_vec_in_AY_dqdPE2 = 0; a_curr_vec_in_AZ_dqdPE2 = 0; a_curr_vec_in_LX_dqdPE2 = 0; a_curr_vec_in_LY_dqdPE2 = 0; a_curr_vec_in_LZ_dqdPE2 = 0;
      // dqdPE3
      link_in_dqdPE3 = 0;
      derv_in_dqdPE3 = 3'd3;
      sinq_val_in_dqdPE3 = 0; cosq_val_in_dqdPE3 = 0;
      qd_val_in_dqdPE3 = 0;
      v_curr_vec_in_AX_dqdPE3 = 0; v_curr_vec_in_AY_dqdPE3 = 0; v_curr_vec_in_AZ_dqdPE3 = 0; v_curr_vec_in_LX_dqdPE3 = 0; v_curr_vec_in_LY_dqdPE3 = 0; v_curr_vec_in_LZ_dqdPE3 = 0;
      a_curr_vec_in_AX_dqdPE3 = 0; a_curr_vec_in_AY_dqdPE3 = 0; a_curr_vec_in_AZ_dqdPE3 = 0; a_curr_vec_in_LX_dqdPE3 = 0; a_curr_vec_in_LY_dqdPE3 = 0; a_curr_vec_in_LZ_dqdPE3 = 0;
      // dqdPE4
      link_in_dqdPE4 = 0;
      derv_in_dqdPE4 = 3'd4;
      sinq_val_in_dqdPE4 = 0; cosq_val_in_dqdPE4 = 0;
      qd_val_in_dqdPE4 = 0;
      v_curr_vec_in_AX_dqdPE4 = 0; v_curr_vec_in_AY_dqdPE4 = 0; v_curr_vec_in_AZ_dqdPE4 = 0; v_curr_vec_in_LX_dqdPE4 = 0; v_curr_vec_in_LY_dqdPE4 = 0; v_curr_vec_in_LZ_dqdPE4 = 0;
      a_curr_vec_in_AX_dqdPE4 = 0; a_curr_vec_in_AY_dqdPE4 = 0; a_curr_vec_in_AZ_dqdPE4 = 0; a_curr_vec_in_LX_dqdPE4 = 0; a_curr_vec_in_LY_dqdPE4 = 0; a_curr_vec_in_LZ_dqdPE4 = 0;
      // dqdPE5
      link_in_dqdPE5 = 0;
      derv_in_dqdPE5 = 3'd5;
      sinq_val_in_dqdPE5 = 0; cosq_val_in_dqdPE5 = 0;
      qd_val_in_dqdPE5 = 0;
      v_curr_vec_in_AX_dqdPE5 = 0; v_curr_vec_in_AY_dqdPE5 = 0; v_curr_vec_in_AZ_dqdPE5 = 0; v_curr_vec_in_LX_dqdPE5 = 0; v_curr_vec_in_LY_dqdPE5 = 0; v_curr_vec_in_LZ_dqdPE5 = 0;
      a_curr_vec_in_AX_dqdPE5 = 0; a_curr_vec_in_AY_dqdPE5 = 0; a_curr_vec_in_AZ_dqdPE5 = 0; a_curr_vec_in_LX_dqdPE5 = 0; a_curr_vec_in_LY_dqdPE5 = 0; a_curr_vec_in_LZ_dqdPE5 = 0;
      // dqdPE6
      link_in_dqdPE6 = 0;
      derv_in_dqdPE6 = 3'd6;
      sinq_val_in_dqdPE6 = 0; cosq_val_in_dqdPE6 = 0;
      qd_val_in_dqdPE6 = 0;
      v_curr_vec_in_AX_dqdPE6 = 0; v_curr_vec_in_AY_dqdPE6 = 0; v_curr_vec_in_AZ_dqdPE6 = 0; v_curr_vec_in_LX_dqdPE6 = 0; v_curr_vec_in_LY_dqdPE6 = 0; v_curr_vec_in_LZ_dqdPE6 = 0;
      a_curr_vec_in_AX_dqdPE6 = 0; a_curr_vec_in_AY_dqdPE6 = 0; a_curr_vec_in_AZ_dqdPE6 = 0; a_curr_vec_in_LX_dqdPE6 = 0; a_curr_vec_in_LY_dqdPE6 = 0; a_curr_vec_in_LZ_dqdPE6 = 0;
      // dqdPE7
      link_in_dqdPE7 = 0;
      derv_in_dqdPE7 = 3'd7;
      sinq_val_in_dqdPE7 = 0; cosq_val_in_dqdPE7 = 0;
      qd_val_in_dqdPE7 = 0;
      v_curr_vec_in_AX_dqdPE7 = 0; v_curr_vec_in_AY_dqdPE7 = 0; v_curr_vec_in_AZ_dqdPE7 = 0; v_curr_vec_in_LX_dqdPE7 = 0; v_curr_vec_in_LY_dqdPE7 = 0; v_curr_vec_in_LZ_dqdPE7 = 0;
      a_curr_vec_in_AX_dqdPE7 = 0; a_curr_vec_in_AY_dqdPE7 = 0; a_curr_vec_in_AZ_dqdPE7 = 0; a_curr_vec_in_LX_dqdPE7 = 0; a_curr_vec_in_LY_dqdPE7 = 0; a_curr_vec_in_LZ_dqdPE7 = 0;
      // External dv,da
      // dqdPE1
      dvdqd_prev_vec_in_AX_dqdPE1 = 0; dvdqd_prev_vec_in_AY_dqdPE1 = 0; dvdqd_prev_vec_in_AZ_dqdPE1 = 0; dvdqd_prev_vec_in_LX_dqdPE1 = 0; dvdqd_prev_vec_in_LY_dqdPE1 = 0; dvdqd_prev_vec_in_LZ_dqdPE1 = 0;
      dadqd_prev_vec_in_AX_dqdPE1 = 0; dadqd_prev_vec_in_AY_dqdPE1 = 0; dadqd_prev_vec_in_AZ_dqdPE1 = 0; dadqd_prev_vec_in_LX_dqdPE1 = 0; dadqd_prev_vec_in_LY_dqdPE1 = 0; dadqd_prev_vec_in_LZ_dqdPE1 = 0;
      // dqdPE2
      dvdqd_prev_vec_in_AX_dqdPE2 = 0; dvdqd_prev_vec_in_AY_dqdPE2 = 0; dvdqd_prev_vec_in_AZ_dqdPE2 = 0; dvdqd_prev_vec_in_LX_dqdPE2 = 0; dvdqd_prev_vec_in_LY_dqdPE2 = 0; dvdqd_prev_vec_in_LZ_dqdPE2 = 0;
      dadqd_prev_vec_in_AX_dqdPE2 = 0; dadqd_prev_vec_in_AY_dqdPE2 = 0; dadqd_prev_vec_in_AZ_dqdPE2 = 0; dadqd_prev_vec_in_LX_dqdPE2 = 0; dadqd_prev_vec_in_LY_dqdPE2 = 0; dadqd_prev_vec_in_LZ_dqdPE2 = 0;
      // dqdPE3
      dvdqd_prev_vec_in_AX_dqdPE3 = 0; dvdqd_prev_vec_in_AY_dqdPE3 = 0; dvdqd_prev_vec_in_AZ_dqdPE3 = 0; dvdqd_prev_vec_in_LX_dqdPE3 = 0; dvdqd_prev_vec_in_LY_dqdPE3 = 0; dvdqd_prev_vec_in_LZ_dqdPE3 = 0;
      dadqd_prev_vec_in_AX_dqdPE3 = 0; dadqd_prev_vec_in_AY_dqdPE3 = 0; dadqd_prev_vec_in_AZ_dqdPE3 = 0; dadqd_prev_vec_in_LX_dqdPE3 = 0; dadqd_prev_vec_in_LY_dqdPE3 = 0; dadqd_prev_vec_in_LZ_dqdPE3 = 0;
      // dqdPE4
      dvdqd_prev_vec_in_AX_dqdPE4 = 0; dvdqd_prev_vec_in_AY_dqdPE4 = 0; dvdqd_prev_vec_in_AZ_dqdPE4 = 0; dvdqd_prev_vec_in_LX_dqdPE4 = 0; dvdqd_prev_vec_in_LY_dqdPE4 = 0; dvdqd_prev_vec_in_LZ_dqdPE4 = 0;
      dadqd_prev_vec_in_AX_dqdPE4 = 0; dadqd_prev_vec_in_AY_dqdPE4 = 0; dadqd_prev_vec_in_AZ_dqdPE4 = 0; dadqd_prev_vec_in_LX_dqdPE4 = 0; dadqd_prev_vec_in_LY_dqdPE4 = 0; dadqd_prev_vec_in_LZ_dqdPE4 = 0;
      // dqdPE5
      dvdqd_prev_vec_in_AX_dqdPE5 = 0; dvdqd_prev_vec_in_AY_dqdPE5 = 0; dvdqd_prev_vec_in_AZ_dqdPE5 = 0; dvdqd_prev_vec_in_LX_dqdPE5 = 0; dvdqd_prev_vec_in_LY_dqdPE5 = 0; dvdqd_prev_vec_in_LZ_dqdPE5 = 0;
      dadqd_prev_vec_in_AX_dqdPE5 = 0; dadqd_prev_vec_in_AY_dqdPE5 = 0; dadqd_prev_vec_in_AZ_dqdPE5 = 0; dadqd_prev_vec_in_LX_dqdPE5 = 0; dadqd_prev_vec_in_LY_dqdPE5 = 0; dadqd_prev_vec_in_LZ_dqdPE5 = 0;
      // dqdPE6
      dvdqd_prev_vec_in_AX_dqdPE6 = 0; dvdqd_prev_vec_in_AY_dqdPE6 = 0; dvdqd_prev_vec_in_AZ_dqdPE6 = 0; dvdqd_prev_vec_in_LX_dqdPE6 = 0; dvdqd_prev_vec_in_LY_dqdPE6 = 0; dvdqd_prev_vec_in_LZ_dqdPE6 = 0;
      dadqd_prev_vec_in_AX_dqdPE6 = 0; dadqd_prev_vec_in_AY_dqdPE6 = 0; dadqd_prev_vec_in_AZ_dqdPE6 = 0; dadqd_prev_vec_in_LX_dqdPE6 = 0; dadqd_prev_vec_in_LY_dqdPE6 = 0; dadqd_prev_vec_in_LZ_dqdPE6 = 0;
      // dqdPE7
      dvdqd_prev_vec_in_AX_dqdPE7 = 0; dvdqd_prev_vec_in_AY_dqdPE7 = 0; dvdqd_prev_vec_in_AZ_dqdPE7 = 0; dvdqd_prev_vec_in_LX_dqdPE7 = 0; dvdqd_prev_vec_in_LY_dqdPE7 = 0; dvdqd_prev_vec_in_LZ_dqdPE7 = 0;
      dadqd_prev_vec_in_AX_dqdPE7 = 0; dadqd_prev_vec_in_AY_dqdPE7 = 0; dadqd_prev_vec_in_AZ_dqdPE7 = 0; dadqd_prev_vec_in_LX_dqdPE7 = 0; dadqd_prev_vec_in_LY_dqdPE7 = 0; dadqd_prev_vec_in_LZ_dqdPE7 = 0;
      //------------------------------------------------------------------------
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
      // Link 1 Inputs
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 3'd1;
      sinq_val_in_rnea = 32'd19197; cosq_val_in_rnea = 32'd62661;
      qd_val_in_rnea = 32'd65530;
      qdd_val_in_rnea = 32'd43998;
      v_prev_vec_in_AX_rnea = 0; v_prev_vec_in_AY_rnea = 0; v_prev_vec_in_AZ_rnea = 0; v_prev_vec_in_LX_rnea = 0; v_prev_vec_in_LY_rnea = 0; v_prev_vec_in_LZ_rnea = 0;
      a_prev_vec_in_AX_rnea = 0; a_prev_vec_in_AY_rnea = 0; a_prev_vec_in_AZ_rnea = 0; a_prev_vec_in_LX_rnea = 0; a_prev_vec_in_LY_rnea = 0; a_prev_vec_in_LZ_rnea = 0;
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 0;
      derv_in_dqPE1 = 3'd1;
      sinq_val_in_dqPE1 = 0; cosq_val_in_dqPE1 = 0;
      qd_val_in_dqPE1 = 0;
      v_curr_vec_in_AX_dqPE1 = 0; v_curr_vec_in_AY_dqPE1 = 0; v_curr_vec_in_AZ_dqPE1 = 0; v_curr_vec_in_LX_dqPE1 = 0; v_curr_vec_in_LY_dqPE1 = 0; v_curr_vec_in_LZ_dqPE1 = 0;
      a_curr_vec_in_AX_dqPE1 = 0; a_curr_vec_in_AY_dqPE1 = 0; a_curr_vec_in_AZ_dqPE1 = 0; a_curr_vec_in_LX_dqPE1 = 0; a_curr_vec_in_LY_dqPE1 = 0; a_curr_vec_in_LZ_dqPE1 = 0;
      v_prev_vec_in_AX_dqPE1 = 0; v_prev_vec_in_AY_dqPE1 = 0; v_prev_vec_in_AZ_dqPE1 = 0; v_prev_vec_in_LX_dqPE1 = 0; v_prev_vec_in_LY_dqPE1 = 0; v_prev_vec_in_LZ_dqPE1 = 0;
      a_prev_vec_in_AX_dqPE1 = 0; a_prev_vec_in_AY_dqPE1 = 0; a_prev_vec_in_AZ_dqPE1 = 0; a_prev_vec_in_LX_dqPE1 = 0; a_prev_vec_in_LY_dqPE1 = 0; a_prev_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      link_in_dqPE2 = 0;
      derv_in_dqPE2 = 3'd2;
      sinq_val_in_dqPE2 = 0; cosq_val_in_dqPE2 = 0;
      qd_val_in_dqPE2 = 0;
      v_curr_vec_in_AX_dqPE2 = 0; v_curr_vec_in_AY_dqPE2 = 0; v_curr_vec_in_AZ_dqPE2 = 0; v_curr_vec_in_LX_dqPE2 = 0; v_curr_vec_in_LY_dqPE2 = 0; v_curr_vec_in_LZ_dqPE2 = 0;
      a_curr_vec_in_AX_dqPE2 = 0; a_curr_vec_in_AY_dqPE2 = 0; a_curr_vec_in_AZ_dqPE2 = 0; a_curr_vec_in_LX_dqPE2 = 0; a_curr_vec_in_LY_dqPE2 = 0; a_curr_vec_in_LZ_dqPE2 = 0;
      v_prev_vec_in_AX_dqPE2 = 0; v_prev_vec_in_AY_dqPE2 = 0; v_prev_vec_in_AZ_dqPE2 = 0; v_prev_vec_in_LX_dqPE2 = 0; v_prev_vec_in_LY_dqPE2 = 0; v_prev_vec_in_LZ_dqPE2 = 0;
      a_prev_vec_in_AX_dqPE2 = 0; a_prev_vec_in_AY_dqPE2 = 0; a_prev_vec_in_AZ_dqPE2 = 0; a_prev_vec_in_LX_dqPE2 = 0; a_prev_vec_in_LY_dqPE2 = 0; a_prev_vec_in_LZ_dqPE2 = 0;
      // dqPE3
      link_in_dqPE3 = 0;
      derv_in_dqPE3 = 3'd3;
      sinq_val_in_dqPE3 = 0; cosq_val_in_dqPE3 = 0;
      qd_val_in_dqPE3 = 0;
      v_curr_vec_in_AX_dqPE3 = 0; v_curr_vec_in_AY_dqPE3 = 0; v_curr_vec_in_AZ_dqPE3 = 0; v_curr_vec_in_LX_dqPE3 = 0; v_curr_vec_in_LY_dqPE3 = 0; v_curr_vec_in_LZ_dqPE3 = 0;
      a_curr_vec_in_AX_dqPE3 = 0; a_curr_vec_in_AY_dqPE3 = 0; a_curr_vec_in_AZ_dqPE3 = 0; a_curr_vec_in_LX_dqPE3 = 0; a_curr_vec_in_LY_dqPE3 = 0; a_curr_vec_in_LZ_dqPE3 = 0;
      v_prev_vec_in_AX_dqPE3 = 0; v_prev_vec_in_AY_dqPE3 = 0; v_prev_vec_in_AZ_dqPE3 = 0; v_prev_vec_in_LX_dqPE3 = 0; v_prev_vec_in_LY_dqPE3 = 0; v_prev_vec_in_LZ_dqPE3 = 0;
      a_prev_vec_in_AX_dqPE3 = 0; a_prev_vec_in_AY_dqPE3 = 0; a_prev_vec_in_AZ_dqPE3 = 0; a_prev_vec_in_LX_dqPE3 = 0; a_prev_vec_in_LY_dqPE3 = 0; a_prev_vec_in_LZ_dqPE3 = 0;
      // dqPE4
      link_in_dqPE4 = 0;
      derv_in_dqPE4 = 3'd4;
      sinq_val_in_dqPE4 = 0; cosq_val_in_dqPE4 = 0;
      qd_val_in_dqPE4 = 0;
      v_curr_vec_in_AX_dqPE4 = 0; v_curr_vec_in_AY_dqPE4 = 0; v_curr_vec_in_AZ_dqPE4 = 0; v_curr_vec_in_LX_dqPE4 = 0; v_curr_vec_in_LY_dqPE4 = 0; v_curr_vec_in_LZ_dqPE4 = 0;
      a_curr_vec_in_AX_dqPE4 = 0; a_curr_vec_in_AY_dqPE4 = 0; a_curr_vec_in_AZ_dqPE4 = 0; a_curr_vec_in_LX_dqPE4 = 0; a_curr_vec_in_LY_dqPE4 = 0; a_curr_vec_in_LZ_dqPE4 = 0;
      v_prev_vec_in_AX_dqPE4 = 0; v_prev_vec_in_AY_dqPE4 = 0; v_prev_vec_in_AZ_dqPE4 = 0; v_prev_vec_in_LX_dqPE4 = 0; v_prev_vec_in_LY_dqPE4 = 0; v_prev_vec_in_LZ_dqPE4 = 0;
      a_prev_vec_in_AX_dqPE4 = 0; a_prev_vec_in_AY_dqPE4 = 0; a_prev_vec_in_AZ_dqPE4 = 0; a_prev_vec_in_LX_dqPE4 = 0; a_prev_vec_in_LY_dqPE4 = 0; a_prev_vec_in_LZ_dqPE4 = 0;
      // dqPE5
      link_in_dqPE5 = 0;
      derv_in_dqPE5 = 3'd5;
      sinq_val_in_dqPE5 = 0; cosq_val_in_dqPE5 = 0;
      qd_val_in_dqPE5 = 0;
      v_curr_vec_in_AX_dqPE5 = 0; v_curr_vec_in_AY_dqPE5 = 0; v_curr_vec_in_AZ_dqPE5 = 0; v_curr_vec_in_LX_dqPE5 = 0; v_curr_vec_in_LY_dqPE5 = 0; v_curr_vec_in_LZ_dqPE5 = 0;
      a_curr_vec_in_AX_dqPE5 = 0; a_curr_vec_in_AY_dqPE5 = 0; a_curr_vec_in_AZ_dqPE5 = 0; a_curr_vec_in_LX_dqPE5 = 0; a_curr_vec_in_LY_dqPE5 = 0; a_curr_vec_in_LZ_dqPE5 = 0;
      v_prev_vec_in_AX_dqPE5 = 0; v_prev_vec_in_AY_dqPE5 = 0; v_prev_vec_in_AZ_dqPE5 = 0; v_prev_vec_in_LX_dqPE5 = 0; v_prev_vec_in_LY_dqPE5 = 0; v_prev_vec_in_LZ_dqPE5 = 0;
      a_prev_vec_in_AX_dqPE5 = 0; a_prev_vec_in_AY_dqPE5 = 0; a_prev_vec_in_AZ_dqPE5 = 0; a_prev_vec_in_LX_dqPE5 = 0; a_prev_vec_in_LY_dqPE5 = 0; a_prev_vec_in_LZ_dqPE5 = 0;
      // dqPE6
      link_in_dqPE6 = 0;
      derv_in_dqPE6 = 3'd6;
      sinq_val_in_dqPE6 = 0; cosq_val_in_dqPE6 = 0;
      qd_val_in_dqPE6 = 0;
      v_curr_vec_in_AX_dqPE6 = 0; v_curr_vec_in_AY_dqPE6 = 0; v_curr_vec_in_AZ_dqPE6 = 0; v_curr_vec_in_LX_dqPE6 = 0; v_curr_vec_in_LY_dqPE6 = 0; v_curr_vec_in_LZ_dqPE6 = 0;
      a_curr_vec_in_AX_dqPE6 = 0; a_curr_vec_in_AY_dqPE6 = 0; a_curr_vec_in_AZ_dqPE6 = 0; a_curr_vec_in_LX_dqPE6 = 0; a_curr_vec_in_LY_dqPE6 = 0; a_curr_vec_in_LZ_dqPE6 = 0;
      v_prev_vec_in_AX_dqPE6 = 0; v_prev_vec_in_AY_dqPE6 = 0; v_prev_vec_in_AZ_dqPE6 = 0; v_prev_vec_in_LX_dqPE6 = 0; v_prev_vec_in_LY_dqPE6 = 0; v_prev_vec_in_LZ_dqPE6 = 0;
      a_prev_vec_in_AX_dqPE6 = 0; a_prev_vec_in_AY_dqPE6 = 0; a_prev_vec_in_AZ_dqPE6 = 0; a_prev_vec_in_LX_dqPE6 = 0; a_prev_vec_in_LY_dqPE6 = 0; a_prev_vec_in_LZ_dqPE6 = 0;
      // dqPE7
      link_in_dqPE7 = 0;
      derv_in_dqPE7 = 3'd7;
      sinq_val_in_dqPE7 = 0; cosq_val_in_dqPE7 = 0;
      qd_val_in_dqPE7 = 0;
      v_curr_vec_in_AX_dqPE7 = 0; v_curr_vec_in_AY_dqPE7 = 0; v_curr_vec_in_AZ_dqPE7 = 0; v_curr_vec_in_LX_dqPE7 = 0; v_curr_vec_in_LY_dqPE7 = 0; v_curr_vec_in_LZ_dqPE7 = 0;
      a_curr_vec_in_AX_dqPE7 = 0; a_curr_vec_in_AY_dqPE7 = 0; a_curr_vec_in_AZ_dqPE7 = 0; a_curr_vec_in_LX_dqPE7 = 0; a_curr_vec_in_LY_dqPE7 = 0; a_curr_vec_in_LZ_dqPE7 = 0;
      v_prev_vec_in_AX_dqPE7 = 0; v_prev_vec_in_AY_dqPE7 = 0; v_prev_vec_in_AZ_dqPE7 = 0; v_prev_vec_in_LX_dqPE7 = 0; v_prev_vec_in_LY_dqPE7 = 0; v_prev_vec_in_LZ_dqPE7 = 0;
      a_prev_vec_in_AX_dqPE7 = 0; a_prev_vec_in_AY_dqPE7 = 0; a_prev_vec_in_AZ_dqPE7 = 0; a_prev_vec_in_LX_dqPE7 = 0; a_prev_vec_in_LY_dqPE7 = 0; a_prev_vec_in_LZ_dqPE7 = 0;
      // External dv,da
      // dqPE1
      dvdq_prev_vec_in_AX_dqPE1 = 0; dvdq_prev_vec_in_AY_dqPE1 = 0; dvdq_prev_vec_in_AZ_dqPE1 = 0; dvdq_prev_vec_in_LX_dqPE1 = 0; dvdq_prev_vec_in_LY_dqPE1 = 0; dvdq_prev_vec_in_LZ_dqPE1 = 0;
      dadq_prev_vec_in_AX_dqPE1 = 0; dadq_prev_vec_in_AY_dqPE1 = 0; dadq_prev_vec_in_AZ_dqPE1 = 0; dadq_prev_vec_in_LX_dqPE1 = 0; dadq_prev_vec_in_LY_dqPE1 = 0; dadq_prev_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      dvdq_prev_vec_in_AX_dqPE2 = 0; dvdq_prev_vec_in_AY_dqPE2 = 0; dvdq_prev_vec_in_AZ_dqPE2 = 0; dvdq_prev_vec_in_LX_dqPE2 = 0; dvdq_prev_vec_in_LY_dqPE2 = 0; dvdq_prev_vec_in_LZ_dqPE2 = 0;
      dadq_prev_vec_in_AX_dqPE2 = 0; dadq_prev_vec_in_AY_dqPE2 = 0; dadq_prev_vec_in_AZ_dqPE2 = 0; dadq_prev_vec_in_LX_dqPE2 = 0; dadq_prev_vec_in_LY_dqPE2 = 0; dadq_prev_vec_in_LZ_dqPE2 = 0;
      // dqPE3
      dvdq_prev_vec_in_AX_dqPE3 = 0; dvdq_prev_vec_in_AY_dqPE3 = 0; dvdq_prev_vec_in_AZ_dqPE3 = 0; dvdq_prev_vec_in_LX_dqPE3 = 0; dvdq_prev_vec_in_LY_dqPE3 = 0; dvdq_prev_vec_in_LZ_dqPE3 = 0;
      dadq_prev_vec_in_AX_dqPE3 = 0; dadq_prev_vec_in_AY_dqPE3 = 0; dadq_prev_vec_in_AZ_dqPE3 = 0; dadq_prev_vec_in_LX_dqPE3 = 0; dadq_prev_vec_in_LY_dqPE3 = 0; dadq_prev_vec_in_LZ_dqPE3 = 0;
      // dqPE4
      dvdq_prev_vec_in_AX_dqPE4 = 0; dvdq_prev_vec_in_AY_dqPE4 = 0; dvdq_prev_vec_in_AZ_dqPE4 = 0; dvdq_prev_vec_in_LX_dqPE4 = 0; dvdq_prev_vec_in_LY_dqPE4 = 0; dvdq_prev_vec_in_LZ_dqPE4 = 0;
      dadq_prev_vec_in_AX_dqPE4 = 0; dadq_prev_vec_in_AY_dqPE4 = 0; dadq_prev_vec_in_AZ_dqPE4 = 0; dadq_prev_vec_in_LX_dqPE4 = 0; dadq_prev_vec_in_LY_dqPE4 = 0; dadq_prev_vec_in_LZ_dqPE4 = 0;
      // dqPE5
      dvdq_prev_vec_in_AX_dqPE5 = 0; dvdq_prev_vec_in_AY_dqPE5 = 0; dvdq_prev_vec_in_AZ_dqPE5 = 0; dvdq_prev_vec_in_LX_dqPE5 = 0; dvdq_prev_vec_in_LY_dqPE5 = 0; dvdq_prev_vec_in_LZ_dqPE5 = 0;
      dadq_prev_vec_in_AX_dqPE5 = 0; dadq_prev_vec_in_AY_dqPE5 = 0; dadq_prev_vec_in_AZ_dqPE5 = 0; dadq_prev_vec_in_LX_dqPE5 = 0; dadq_prev_vec_in_LY_dqPE5 = 0; dadq_prev_vec_in_LZ_dqPE5 = 0;
      // dqPE6
      dvdq_prev_vec_in_AX_dqPE6 = 0; dvdq_prev_vec_in_AY_dqPE6 = 0; dvdq_prev_vec_in_AZ_dqPE6 = 0; dvdq_prev_vec_in_LX_dqPE6 = 0; dvdq_prev_vec_in_LY_dqPE6 = 0; dvdq_prev_vec_in_LZ_dqPE6 = 0;
      dadq_prev_vec_in_AX_dqPE6 = 0; dadq_prev_vec_in_AY_dqPE6 = 0; dadq_prev_vec_in_AZ_dqPE6 = 0; dadq_prev_vec_in_LX_dqPE6 = 0; dadq_prev_vec_in_LY_dqPE6 = 0; dadq_prev_vec_in_LZ_dqPE6 = 0;
      // dqPE7
      dvdq_prev_vec_in_AX_dqPE7 = 0; dvdq_prev_vec_in_AY_dqPE7 = 0; dvdq_prev_vec_in_AZ_dqPE7 = 0; dvdq_prev_vec_in_LX_dqPE7 = 0; dvdq_prev_vec_in_LY_dqPE7 = 0; dvdq_prev_vec_in_LZ_dqPE7 = 0;
      dadq_prev_vec_in_AX_dqPE7 = 0; dadq_prev_vec_in_AY_dqPE7 = 0; dadq_prev_vec_in_AZ_dqPE7 = 0; dadq_prev_vec_in_LX_dqPE7 = 0; dadq_prev_vec_in_LY_dqPE7 = 0; dadq_prev_vec_in_LZ_dqPE7 = 0;
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 0;
      derv_in_dqdPE1 = 3'd1;
      sinq_val_in_dqdPE1 = 0; cosq_val_in_dqdPE1 = 0;
      qd_val_in_dqdPE1 = 0;
      v_curr_vec_in_AX_dqdPE1 = 0; v_curr_vec_in_AY_dqdPE1 = 0; v_curr_vec_in_AZ_dqdPE1 = 0; v_curr_vec_in_LX_dqdPE1 = 0; v_curr_vec_in_LY_dqdPE1 = 0; v_curr_vec_in_LZ_dqdPE1 = 0;
      a_curr_vec_in_AX_dqdPE1 = 0; a_curr_vec_in_AY_dqdPE1 = 0; a_curr_vec_in_AZ_dqdPE1 = 0; a_curr_vec_in_LX_dqdPE1 = 0; a_curr_vec_in_LY_dqdPE1 = 0; a_curr_vec_in_LZ_dqdPE1 = 0;
      // dqdPE2
      link_in_dqdPE2 = 0;
      derv_in_dqdPE2 = 3'd2;
      sinq_val_in_dqdPE2 = 0; cosq_val_in_dqdPE2 = 0;
      qd_val_in_dqdPE2 = 0;
      v_curr_vec_in_AX_dqdPE2 = 0; v_curr_vec_in_AY_dqdPE2 = 0; v_curr_vec_in_AZ_dqdPE2 = 0; v_curr_vec_in_LX_dqdPE2 = 0; v_curr_vec_in_LY_dqdPE2 = 0; v_curr_vec_in_LZ_dqdPE2 = 0;
      a_curr_vec_in_AX_dqdPE2 = 0; a_curr_vec_in_AY_dqdPE2 = 0; a_curr_vec_in_AZ_dqdPE2 = 0; a_curr_vec_in_LX_dqdPE2 = 0; a_curr_vec_in_LY_dqdPE2 = 0; a_curr_vec_in_LZ_dqdPE2 = 0;
      // dqdPE3
      link_in_dqdPE3 = 0;
      derv_in_dqdPE3 = 3'd3;
      sinq_val_in_dqdPE3 = 0; cosq_val_in_dqdPE3 = 0;
      qd_val_in_dqdPE3 = 0;
      v_curr_vec_in_AX_dqdPE3 = 0; v_curr_vec_in_AY_dqdPE3 = 0; v_curr_vec_in_AZ_dqdPE3 = 0; v_curr_vec_in_LX_dqdPE3 = 0; v_curr_vec_in_LY_dqdPE3 = 0; v_curr_vec_in_LZ_dqdPE3 = 0;
      a_curr_vec_in_AX_dqdPE3 = 0; a_curr_vec_in_AY_dqdPE3 = 0; a_curr_vec_in_AZ_dqdPE3 = 0; a_curr_vec_in_LX_dqdPE3 = 0; a_curr_vec_in_LY_dqdPE3 = 0; a_curr_vec_in_LZ_dqdPE3 = 0;
      // dqdPE4
      link_in_dqdPE4 = 0;
      derv_in_dqdPE4 = 3'd4;
      sinq_val_in_dqdPE4 = 0; cosq_val_in_dqdPE4 = 0;
      qd_val_in_dqdPE4 = 0;
      v_curr_vec_in_AX_dqdPE4 = 0; v_curr_vec_in_AY_dqdPE4 = 0; v_curr_vec_in_AZ_dqdPE4 = 0; v_curr_vec_in_LX_dqdPE4 = 0; v_curr_vec_in_LY_dqdPE4 = 0; v_curr_vec_in_LZ_dqdPE4 = 0;
      a_curr_vec_in_AX_dqdPE4 = 0; a_curr_vec_in_AY_dqdPE4 = 0; a_curr_vec_in_AZ_dqdPE4 = 0; a_curr_vec_in_LX_dqdPE4 = 0; a_curr_vec_in_LY_dqdPE4 = 0; a_curr_vec_in_LZ_dqdPE4 = 0;
      // dqdPE5
      link_in_dqdPE5 = 0;
      derv_in_dqdPE5 = 3'd5;
      sinq_val_in_dqdPE5 = 0; cosq_val_in_dqdPE5 = 0;
      qd_val_in_dqdPE5 = 0;
      v_curr_vec_in_AX_dqdPE5 = 0; v_curr_vec_in_AY_dqdPE5 = 0; v_curr_vec_in_AZ_dqdPE5 = 0; v_curr_vec_in_LX_dqdPE5 = 0; v_curr_vec_in_LY_dqdPE5 = 0; v_curr_vec_in_LZ_dqdPE5 = 0;
      a_curr_vec_in_AX_dqdPE5 = 0; a_curr_vec_in_AY_dqdPE5 = 0; a_curr_vec_in_AZ_dqdPE5 = 0; a_curr_vec_in_LX_dqdPE5 = 0; a_curr_vec_in_LY_dqdPE5 = 0; a_curr_vec_in_LZ_dqdPE5 = 0;
      // dqdPE6
      link_in_dqdPE6 = 0;
      derv_in_dqdPE6 = 3'd6;
      sinq_val_in_dqdPE6 = 0; cosq_val_in_dqdPE6 = 0;
      qd_val_in_dqdPE6 = 0;
      v_curr_vec_in_AX_dqdPE6 = 0; v_curr_vec_in_AY_dqdPE6 = 0; v_curr_vec_in_AZ_dqdPE6 = 0; v_curr_vec_in_LX_dqdPE6 = 0; v_curr_vec_in_LY_dqdPE6 = 0; v_curr_vec_in_LZ_dqdPE6 = 0;
      a_curr_vec_in_AX_dqdPE6 = 0; a_curr_vec_in_AY_dqdPE6 = 0; a_curr_vec_in_AZ_dqdPE6 = 0; a_curr_vec_in_LX_dqdPE6 = 0; a_curr_vec_in_LY_dqdPE6 = 0; a_curr_vec_in_LZ_dqdPE6 = 0;
      // dqdPE7
      link_in_dqdPE7 = 0;
      derv_in_dqdPE7 = 3'd7;
      sinq_val_in_dqdPE7 = 0; cosq_val_in_dqdPE7 = 0;
      qd_val_in_dqdPE7 = 0;
      v_curr_vec_in_AX_dqdPE7 = 0; v_curr_vec_in_AY_dqdPE7 = 0; v_curr_vec_in_AZ_dqdPE7 = 0; v_curr_vec_in_LX_dqdPE7 = 0; v_curr_vec_in_LY_dqdPE7 = 0; v_curr_vec_in_LZ_dqdPE7 = 0;
      a_curr_vec_in_AX_dqdPE7 = 0; a_curr_vec_in_AY_dqdPE7 = 0; a_curr_vec_in_AZ_dqdPE7 = 0; a_curr_vec_in_LX_dqdPE7 = 0; a_curr_vec_in_LY_dqdPE7 = 0; a_curr_vec_in_LZ_dqdPE7 = 0;
      // External dv,da
      // dqdPE1
      dvdqd_prev_vec_in_AX_dqdPE1 = 0; dvdqd_prev_vec_in_AY_dqdPE1 = 0; dvdqd_prev_vec_in_AZ_dqdPE1 = 0; dvdqd_prev_vec_in_LX_dqdPE1 = 0; dvdqd_prev_vec_in_LY_dqdPE1 = 0; dvdqd_prev_vec_in_LZ_dqdPE1 = 0;
      dadqd_prev_vec_in_AX_dqdPE1 = 0; dadqd_prev_vec_in_AY_dqdPE1 = 0; dadqd_prev_vec_in_AZ_dqdPE1 = 0; dadqd_prev_vec_in_LX_dqdPE1 = 0; dadqd_prev_vec_in_LY_dqdPE1 = 0; dadqd_prev_vec_in_LZ_dqdPE1 = 0;
      // dqdPE2
      dvdqd_prev_vec_in_AX_dqdPE2 = 0; dvdqd_prev_vec_in_AY_dqdPE2 = 0; dvdqd_prev_vec_in_AZ_dqdPE2 = 0; dvdqd_prev_vec_in_LX_dqdPE2 = 0; dvdqd_prev_vec_in_LY_dqdPE2 = 0; dvdqd_prev_vec_in_LZ_dqdPE2 = 0;
      dadqd_prev_vec_in_AX_dqdPE2 = 0; dadqd_prev_vec_in_AY_dqdPE2 = 0; dadqd_prev_vec_in_AZ_dqdPE2 = 0; dadqd_prev_vec_in_LX_dqdPE2 = 0; dadqd_prev_vec_in_LY_dqdPE2 = 0; dadqd_prev_vec_in_LZ_dqdPE2 = 0;
      // dqdPE3
      dvdqd_prev_vec_in_AX_dqdPE3 = 0; dvdqd_prev_vec_in_AY_dqdPE3 = 0; dvdqd_prev_vec_in_AZ_dqdPE3 = 0; dvdqd_prev_vec_in_LX_dqdPE3 = 0; dvdqd_prev_vec_in_LY_dqdPE3 = 0; dvdqd_prev_vec_in_LZ_dqdPE3 = 0;
      dadqd_prev_vec_in_AX_dqdPE3 = 0; dadqd_prev_vec_in_AY_dqdPE3 = 0; dadqd_prev_vec_in_AZ_dqdPE3 = 0; dadqd_prev_vec_in_LX_dqdPE3 = 0; dadqd_prev_vec_in_LY_dqdPE3 = 0; dadqd_prev_vec_in_LZ_dqdPE3 = 0;
      // dqdPE4
      dvdqd_prev_vec_in_AX_dqdPE4 = 0; dvdqd_prev_vec_in_AY_dqdPE4 = 0; dvdqd_prev_vec_in_AZ_dqdPE4 = 0; dvdqd_prev_vec_in_LX_dqdPE4 = 0; dvdqd_prev_vec_in_LY_dqdPE4 = 0; dvdqd_prev_vec_in_LZ_dqdPE4 = 0;
      dadqd_prev_vec_in_AX_dqdPE4 = 0; dadqd_prev_vec_in_AY_dqdPE4 = 0; dadqd_prev_vec_in_AZ_dqdPE4 = 0; dadqd_prev_vec_in_LX_dqdPE4 = 0; dadqd_prev_vec_in_LY_dqdPE4 = 0; dadqd_prev_vec_in_LZ_dqdPE4 = 0;
      // dqdPE5
      dvdqd_prev_vec_in_AX_dqdPE5 = 0; dvdqd_prev_vec_in_AY_dqdPE5 = 0; dvdqd_prev_vec_in_AZ_dqdPE5 = 0; dvdqd_prev_vec_in_LX_dqdPE5 = 0; dvdqd_prev_vec_in_LY_dqdPE5 = 0; dvdqd_prev_vec_in_LZ_dqdPE5 = 0;
      dadqd_prev_vec_in_AX_dqdPE5 = 0; dadqd_prev_vec_in_AY_dqdPE5 = 0; dadqd_prev_vec_in_AZ_dqdPE5 = 0; dadqd_prev_vec_in_LX_dqdPE5 = 0; dadqd_prev_vec_in_LY_dqdPE5 = 0; dadqd_prev_vec_in_LZ_dqdPE5 = 0;
      // dqdPE6
      dvdqd_prev_vec_in_AX_dqdPE6 = 0; dvdqd_prev_vec_in_AY_dqdPE6 = 0; dvdqd_prev_vec_in_AZ_dqdPE6 = 0; dvdqd_prev_vec_in_LX_dqdPE6 = 0; dvdqd_prev_vec_in_LY_dqdPE6 = 0; dvdqd_prev_vec_in_LZ_dqdPE6 = 0;
      dadqd_prev_vec_in_AX_dqdPE6 = 0; dadqd_prev_vec_in_AY_dqdPE6 = 0; dadqd_prev_vec_in_AZ_dqdPE6 = 0; dadqd_prev_vec_in_LX_dqdPE6 = 0; dadqd_prev_vec_in_LY_dqdPE6 = 0; dadqd_prev_vec_in_LZ_dqdPE6 = 0;
      // dqdPE7
      dvdqd_prev_vec_in_AX_dqdPE7 = 0; dvdqd_prev_vec_in_AY_dqdPE7 = 0; dvdqd_prev_vec_in_AZ_dqdPE7 = 0; dvdqd_prev_vec_in_LX_dqdPE7 = 0; dvdqd_prev_vec_in_LY_dqdPE7 = 0; dvdqd_prev_vec_in_LZ_dqdPE7 = 0;
      dadqd_prev_vec_in_AX_dqdPE7 = 0; dadqd_prev_vec_in_AY_dqdPE7 = 0; dadqd_prev_vec_in_AZ_dqdPE7 = 0; dadqd_prev_vec_in_LX_dqdPE7 = 0; dadqd_prev_vec_in_LY_dqdPE7 = 0; dadqd_prev_vec_in_LZ_dqdPE7 = 0;
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
      // Link 1 Outputs (RNEA Only)
      //------------------------------------------------------------------------
      $display ("// Link 1 RNEA Only");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_curr_ref = %d,%d,%d,%d,%d,%d",-944, 634, 1038, 5280, 7863, 0);
      $display ("f_curr_out = %d,%d,%d,%d,%d,%d", f_curr_vec_out_AX_rnea,f_curr_vec_out_AY_rnea,f_curr_vec_out_AZ_rnea,f_curr_vec_out_LX_rnea,f_curr_vec_out_LY_rnea,f_curr_vec_out_LZ_rnea);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // Link 2 Inputs
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 3'd2;
      sinq_val_in_rnea = 32'd24454; cosq_val_in_rnea = 32'd60803;
      qd_val_in_rnea = 32'd16493;
      qdd_val_in_rnea = 32'd136669;
      v_prev_vec_in_AX_rnea = 32'd0; v_prev_vec_in_AY_rnea = 32'd0; v_prev_vec_in_AZ_rnea = 32'd65530; v_prev_vec_in_LX_rnea = 32'd0; v_prev_vec_in_LY_rnea = 32'd0; v_prev_vec_in_LZ_rnea = 32'd0;
      a_prev_vec_in_AX_rnea = 32'd0; a_prev_vec_in_AY_rnea = 32'd0; a_prev_vec_in_AZ_rnea = 32'd43998; a_prev_vec_in_LX_rnea = 32'd0; a_prev_vec_in_LY_rnea = 32'd0; a_prev_vec_in_LZ_rnea = 32'd0;
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 0;
      derv_in_dqPE1 = 3'd1;
      sinq_val_in_dqPE1 = 0; cosq_val_in_dqPE1 = 0;
      qd_val_in_dqPE1 = 0;
      v_curr_vec_in_AX_dqPE1 = 0; v_curr_vec_in_AY_dqPE1 = 0; v_curr_vec_in_AZ_dqPE1 = 0; v_curr_vec_in_LX_dqPE1 = 0; v_curr_vec_in_LY_dqPE1 = 0; v_curr_vec_in_LZ_dqPE1 = 0;
      a_curr_vec_in_AX_dqPE1 = 0; a_curr_vec_in_AY_dqPE1 = 0; a_curr_vec_in_AZ_dqPE1 = 0; a_curr_vec_in_LX_dqPE1 = 0; a_curr_vec_in_LY_dqPE1 = 0; a_curr_vec_in_LZ_dqPE1 = 0;
      v_prev_vec_in_AX_dqPE1 = 0; v_prev_vec_in_AY_dqPE1 = 0; v_prev_vec_in_AZ_dqPE1 = 0; v_prev_vec_in_LX_dqPE1 = 0; v_prev_vec_in_LY_dqPE1 = 0; v_prev_vec_in_LZ_dqPE1 = 0;
      a_prev_vec_in_AX_dqPE1 = 0; a_prev_vec_in_AY_dqPE1 = 0; a_prev_vec_in_AZ_dqPE1 = 0; a_prev_vec_in_LX_dqPE1 = 0; a_prev_vec_in_LY_dqPE1 = 0; a_prev_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      link_in_dqPE2 = 3'd1;
      derv_in_dqPE2 = 3'd2;
      sinq_val_in_dqPE2 = 0; cosq_val_in_dqPE2 = 0;
      qd_val_in_dqPE2 = 0;
      v_curr_vec_in_AX_dqPE2 = 0; v_curr_vec_in_AY_dqPE2 = 0; v_curr_vec_in_AZ_dqPE2 = 32'd65530; v_curr_vec_in_LX_dqPE2 = 0; v_curr_vec_in_LY_dqPE2 = 0; v_curr_vec_in_LZ_dqPE2 = 0;
      a_curr_vec_in_AX_dqPE2 = 0; a_curr_vec_in_AY_dqPE2 = 0; a_curr_vec_in_AZ_dqPE2 = 32'd43998; a_curr_vec_in_LX_dqPE2 = 0; a_curr_vec_in_LY_dqPE2 = 0; a_curr_vec_in_LZ_dqPE2 = 0;
      v_prev_vec_in_AX_dqPE2 = 0; v_prev_vec_in_AY_dqPE2 = 0; v_prev_vec_in_AZ_dqPE2 = 0; v_prev_vec_in_LX_dqPE2 = 0; v_prev_vec_in_LY_dqPE2 = 0; v_prev_vec_in_LZ_dqPE2 = 0;
      a_prev_vec_in_AX_dqPE2 = 0; a_prev_vec_in_AY_dqPE2 = 0; a_prev_vec_in_AZ_dqPE2 = 0; a_prev_vec_in_LX_dqPE2 = 0; a_prev_vec_in_LY_dqPE2 = 0; a_prev_vec_in_LZ_dqPE2 = 0;
      // dqPE3
      link_in_dqPE3 = 3'd1;
      derv_in_dqPE3 = 3'd3;
      sinq_val_in_dqPE3 = 0; cosq_val_in_dqPE3 = 0;
      qd_val_in_dqPE3 = 0;
      v_curr_vec_in_AX_dqPE3 = 0; v_curr_vec_in_AY_dqPE3 = 0; v_curr_vec_in_AZ_dqPE3 = 32'd65530; v_curr_vec_in_LX_dqPE3 = 0; v_curr_vec_in_LY_dqPE3 = 0; v_curr_vec_in_LZ_dqPE3 = 0;
      a_curr_vec_in_AX_dqPE3 = 0; a_curr_vec_in_AY_dqPE3 = 0; a_curr_vec_in_AZ_dqPE3 = 32'd43998; a_curr_vec_in_LX_dqPE3 = 0; a_curr_vec_in_LY_dqPE3 = 0; a_curr_vec_in_LZ_dqPE3 = 0;
      v_prev_vec_in_AX_dqPE3 = 0; v_prev_vec_in_AY_dqPE3 = 0; v_prev_vec_in_AZ_dqPE3 = 0; v_prev_vec_in_LX_dqPE3 = 0; v_prev_vec_in_LY_dqPE3 = 0; v_prev_vec_in_LZ_dqPE3 = 0;
      a_prev_vec_in_AX_dqPE3 = 0; a_prev_vec_in_AY_dqPE3 = 0; a_prev_vec_in_AZ_dqPE3 = 0; a_prev_vec_in_LX_dqPE3 = 0; a_prev_vec_in_LY_dqPE3 = 0; a_prev_vec_in_LZ_dqPE3 = 0;
      // dqPE4
      link_in_dqPE4 = 3'd1;
      derv_in_dqPE4 = 3'd4;
      sinq_val_in_dqPE4 = 0; cosq_val_in_dqPE4 = 0;
      qd_val_in_dqPE4 = 0;
      v_curr_vec_in_AX_dqPE4 = 0; v_curr_vec_in_AY_dqPE4 = 0; v_curr_vec_in_AZ_dqPE4 = 32'd65530; v_curr_vec_in_LX_dqPE4 = 0; v_curr_vec_in_LY_dqPE4 = 0; v_curr_vec_in_LZ_dqPE4 = 0;
      a_curr_vec_in_AX_dqPE4 = 0; a_curr_vec_in_AY_dqPE4 = 0; a_curr_vec_in_AZ_dqPE4 = 32'd43998; a_curr_vec_in_LX_dqPE4 = 0; a_curr_vec_in_LY_dqPE4 = 0; a_curr_vec_in_LZ_dqPE4 = 0;
      v_prev_vec_in_AX_dqPE4 = 0; v_prev_vec_in_AY_dqPE4 = 0; v_prev_vec_in_AZ_dqPE4 = 0; v_prev_vec_in_LX_dqPE4 = 0; v_prev_vec_in_LY_dqPE4 = 0; v_prev_vec_in_LZ_dqPE4 = 0;
      a_prev_vec_in_AX_dqPE4 = 0; a_prev_vec_in_AY_dqPE4 = 0; a_prev_vec_in_AZ_dqPE4 = 0; a_prev_vec_in_LX_dqPE4 = 0; a_prev_vec_in_LY_dqPE4 = 0; a_prev_vec_in_LZ_dqPE4 = 0;
      // dqPE5
      link_in_dqPE5 = 3'd1;
      derv_in_dqPE5 = 3'd5;
      sinq_val_in_dqPE5 = 0; cosq_val_in_dqPE5 = 0;
      qd_val_in_dqPE5 = 0;
      v_curr_vec_in_AX_dqPE5 = 0; v_curr_vec_in_AY_dqPE5 = 0; v_curr_vec_in_AZ_dqPE5 = 32'd65530; v_curr_vec_in_LX_dqPE5 = 0; v_curr_vec_in_LY_dqPE5 = 0; v_curr_vec_in_LZ_dqPE5 = 0;
      a_curr_vec_in_AX_dqPE5 = 0; a_curr_vec_in_AY_dqPE5 = 0; a_curr_vec_in_AZ_dqPE5 = 32'd43998; a_curr_vec_in_LX_dqPE5 = 0; a_curr_vec_in_LY_dqPE5 = 0; a_curr_vec_in_LZ_dqPE5 = 0;
      v_prev_vec_in_AX_dqPE5 = 0; v_prev_vec_in_AY_dqPE5 = 0; v_prev_vec_in_AZ_dqPE5 = 0; v_prev_vec_in_LX_dqPE5 = 0; v_prev_vec_in_LY_dqPE5 = 0; v_prev_vec_in_LZ_dqPE5 = 0;
      a_prev_vec_in_AX_dqPE5 = 0; a_prev_vec_in_AY_dqPE5 = 0; a_prev_vec_in_AZ_dqPE5 = 0; a_prev_vec_in_LX_dqPE5 = 0; a_prev_vec_in_LY_dqPE5 = 0; a_prev_vec_in_LZ_dqPE5 = 0;
      // dqPE6
      link_in_dqPE6 = 3'd1;
      derv_in_dqPE6 = 3'd6;
      sinq_val_in_dqPE6 = 0; cosq_val_in_dqPE6 = 0;
      qd_val_in_dqPE6 = 0;
      v_curr_vec_in_AX_dqPE6 = 0; v_curr_vec_in_AY_dqPE6 = 0; v_curr_vec_in_AZ_dqPE6 = 32'd65530; v_curr_vec_in_LX_dqPE6 = 0; v_curr_vec_in_LY_dqPE6 = 0; v_curr_vec_in_LZ_dqPE6 = 0;
      a_curr_vec_in_AX_dqPE6 = 0; a_curr_vec_in_AY_dqPE6 = 0; a_curr_vec_in_AZ_dqPE6 = 32'd43998; a_curr_vec_in_LX_dqPE6 = 0; a_curr_vec_in_LY_dqPE6 = 0; a_curr_vec_in_LZ_dqPE6 = 0;
      v_prev_vec_in_AX_dqPE6 = 0; v_prev_vec_in_AY_dqPE6 = 0; v_prev_vec_in_AZ_dqPE6 = 0; v_prev_vec_in_LX_dqPE6 = 0; v_prev_vec_in_LY_dqPE6 = 0; v_prev_vec_in_LZ_dqPE6 = 0;
      a_prev_vec_in_AX_dqPE6 = 0; a_prev_vec_in_AY_dqPE6 = 0; a_prev_vec_in_AZ_dqPE6 = 0; a_prev_vec_in_LX_dqPE6 = 0; a_prev_vec_in_LY_dqPE6 = 0; a_prev_vec_in_LZ_dqPE6 = 0;
      // dqPE7
      link_in_dqPE7 = 3'd1;
      derv_in_dqPE7 = 3'd7;
      sinq_val_in_dqPE7 = 0; cosq_val_in_dqPE7 = 0;
      qd_val_in_dqPE7 = 0;
      v_curr_vec_in_AX_dqPE7 = 0; v_curr_vec_in_AY_dqPE7 = 0; v_curr_vec_in_AZ_dqPE7 = 32'd65530; v_curr_vec_in_LX_dqPE7 = 0; v_curr_vec_in_LY_dqPE7 = 0; v_curr_vec_in_LZ_dqPE7 = 0;
      a_curr_vec_in_AX_dqPE7 = 0; a_curr_vec_in_AY_dqPE7 = 0; a_curr_vec_in_AZ_dqPE7 = 32'd43998; a_curr_vec_in_LX_dqPE7 = 0; a_curr_vec_in_LY_dqPE7 = 0; a_curr_vec_in_LZ_dqPE7 = 0;
      v_prev_vec_in_AX_dqPE7 = 0; v_prev_vec_in_AY_dqPE7 = 0; v_prev_vec_in_AZ_dqPE7 = 0; v_prev_vec_in_LX_dqPE7 = 0; v_prev_vec_in_LY_dqPE7 = 0; v_prev_vec_in_LZ_dqPE7 = 0;
      a_prev_vec_in_AX_dqPE7 = 0; a_prev_vec_in_AY_dqPE7 = 0; a_prev_vec_in_AZ_dqPE7 = 0; a_prev_vec_in_LX_dqPE7 = 0; a_prev_vec_in_LY_dqPE7 = 0; a_prev_vec_in_LZ_dqPE7 = 0;
      // External dv,da
      // dqPE1
      dvdq_prev_vec_in_AX_dqPE1 = 0; dvdq_prev_vec_in_AY_dqPE1 = 0; dvdq_prev_vec_in_AZ_dqPE1 = 0; dvdq_prev_vec_in_LX_dqPE1 = 0; dvdq_prev_vec_in_LY_dqPE1 = 0; dvdq_prev_vec_in_LZ_dqPE1 = 0;
      dadq_prev_vec_in_AX_dqPE1 = 0; dadq_prev_vec_in_AY_dqPE1 = 0; dadq_prev_vec_in_AZ_dqPE1 = 0; dadq_prev_vec_in_LX_dqPE1 = 0; dadq_prev_vec_in_LY_dqPE1 = 0; dadq_prev_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      dvdq_prev_vec_in_AX_dqPE2 = 0; dvdq_prev_vec_in_AY_dqPE2 = 0; dvdq_prev_vec_in_AZ_dqPE2 = 0; dvdq_prev_vec_in_LX_dqPE2 = 0; dvdq_prev_vec_in_LY_dqPE2 = 0; dvdq_prev_vec_in_LZ_dqPE2 = 0;
      dadq_prev_vec_in_AX_dqPE2 = 0; dadq_prev_vec_in_AY_dqPE2 = 0; dadq_prev_vec_in_AZ_dqPE2 = 0; dadq_prev_vec_in_LX_dqPE2 = 0; dadq_prev_vec_in_LY_dqPE2 = 0; dadq_prev_vec_in_LZ_dqPE2 = 0;
      // dqPE3
      dvdq_prev_vec_in_AX_dqPE3 = 0; dvdq_prev_vec_in_AY_dqPE3 = 0; dvdq_prev_vec_in_AZ_dqPE3 = 0; dvdq_prev_vec_in_LX_dqPE3 = 0; dvdq_prev_vec_in_LY_dqPE3 = 0; dvdq_prev_vec_in_LZ_dqPE3 = 0;
      dadq_prev_vec_in_AX_dqPE3 = 0; dadq_prev_vec_in_AY_dqPE3 = 0; dadq_prev_vec_in_AZ_dqPE3 = 0; dadq_prev_vec_in_LX_dqPE3 = 0; dadq_prev_vec_in_LY_dqPE3 = 0; dadq_prev_vec_in_LZ_dqPE3 = 0;
      // dqPE4
      dvdq_prev_vec_in_AX_dqPE4 = 0; dvdq_prev_vec_in_AY_dqPE4 = 0; dvdq_prev_vec_in_AZ_dqPE4 = 0; dvdq_prev_vec_in_LX_dqPE4 = 0; dvdq_prev_vec_in_LY_dqPE4 = 0; dvdq_prev_vec_in_LZ_dqPE4 = 0;
      dadq_prev_vec_in_AX_dqPE4 = 0; dadq_prev_vec_in_AY_dqPE4 = 0; dadq_prev_vec_in_AZ_dqPE4 = 0; dadq_prev_vec_in_LX_dqPE4 = 0; dadq_prev_vec_in_LY_dqPE4 = 0; dadq_prev_vec_in_LZ_dqPE4 = 0;
      // dqPE5
      dvdq_prev_vec_in_AX_dqPE5 = 0; dvdq_prev_vec_in_AY_dqPE5 = 0; dvdq_prev_vec_in_AZ_dqPE5 = 0; dvdq_prev_vec_in_LX_dqPE5 = 0; dvdq_prev_vec_in_LY_dqPE5 = 0; dvdq_prev_vec_in_LZ_dqPE5 = 0;
      dadq_prev_vec_in_AX_dqPE5 = 0; dadq_prev_vec_in_AY_dqPE5 = 0; dadq_prev_vec_in_AZ_dqPE5 = 0; dadq_prev_vec_in_LX_dqPE5 = 0; dadq_prev_vec_in_LY_dqPE5 = 0; dadq_prev_vec_in_LZ_dqPE5 = 0;
      // dqPE6
      dvdq_prev_vec_in_AX_dqPE6 = 0; dvdq_prev_vec_in_AY_dqPE6 = 0; dvdq_prev_vec_in_AZ_dqPE6 = 0; dvdq_prev_vec_in_LX_dqPE6 = 0; dvdq_prev_vec_in_LY_dqPE6 = 0; dvdq_prev_vec_in_LZ_dqPE6 = 0;
      dadq_prev_vec_in_AX_dqPE6 = 0; dadq_prev_vec_in_AY_dqPE6 = 0; dadq_prev_vec_in_AZ_dqPE6 = 0; dadq_prev_vec_in_LX_dqPE6 = 0; dadq_prev_vec_in_LY_dqPE6 = 0; dadq_prev_vec_in_LZ_dqPE6 = 0;
      // dqPE7
      dvdq_prev_vec_in_AX_dqPE7 = 0; dvdq_prev_vec_in_AY_dqPE7 = 0; dvdq_prev_vec_in_AZ_dqPE7 = 0; dvdq_prev_vec_in_LX_dqPE7 = 0; dvdq_prev_vec_in_LY_dqPE7 = 0; dvdq_prev_vec_in_LZ_dqPE7 = 0;
      dadq_prev_vec_in_AX_dqPE7 = 0; dadq_prev_vec_in_AY_dqPE7 = 0; dadq_prev_vec_in_AZ_dqPE7 = 0; dadq_prev_vec_in_LX_dqPE7 = 0; dadq_prev_vec_in_LY_dqPE7 = 0; dadq_prev_vec_in_LZ_dqPE7 = 0;
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 3'd1;
      derv_in_dqdPE1 = 3'd1;
      sinq_val_in_dqdPE1 = 0; cosq_val_in_dqdPE1 = 0;
      qd_val_in_dqdPE1 = 0;
      v_curr_vec_in_AX_dqdPE1 = 0; v_curr_vec_in_AY_dqdPE1 = 0; v_curr_vec_in_AZ_dqdPE1 = 32'd65530; v_curr_vec_in_LX_dqdPE1 = 0; v_curr_vec_in_LY_dqdPE1 = 0; v_curr_vec_in_LZ_dqdPE1 = 0;
      a_curr_vec_in_AX_dqdPE1 = 0; a_curr_vec_in_AY_dqdPE1 = 0; a_curr_vec_in_AZ_dqdPE1 = 32'd43998; a_curr_vec_in_LX_dqdPE1 = 0; a_curr_vec_in_LY_dqdPE1 = 0; a_curr_vec_in_LZ_dqdPE1 = 0;
      // dqdPE2
      link_in_dqdPE2 = 3'd1;
      derv_in_dqdPE2 = 3'd2;
      sinq_val_in_dqdPE2 = 0; cosq_val_in_dqdPE2 = 0;
      qd_val_in_dqdPE2 = 0;
      v_curr_vec_in_AX_dqdPE2 = 0; v_curr_vec_in_AY_dqdPE2 = 0; v_curr_vec_in_AZ_dqdPE2 = 32'd65530; v_curr_vec_in_LX_dqdPE2 = 0; v_curr_vec_in_LY_dqdPE2 = 0; v_curr_vec_in_LZ_dqdPE2 = 0;
      a_curr_vec_in_AX_dqdPE2 = 0; a_curr_vec_in_AY_dqdPE2 = 0; a_curr_vec_in_AZ_dqdPE2 = 32'd43998; a_curr_vec_in_LX_dqdPE2 = 0; a_curr_vec_in_LY_dqdPE2 = 0; a_curr_vec_in_LZ_dqdPE2 = 0;
      // dqdPE3
      link_in_dqdPE3 = 3'd1;
      derv_in_dqdPE3 = 3'd3;
      sinq_val_in_dqdPE3 = 0; cosq_val_in_dqdPE3 = 0;
      qd_val_in_dqdPE3 = 0;
      v_curr_vec_in_AX_dqdPE3 = 0; v_curr_vec_in_AY_dqdPE3 = 0; v_curr_vec_in_AZ_dqdPE3 = 32'd65530; v_curr_vec_in_LX_dqdPE3 = 0; v_curr_vec_in_LY_dqdPE3 = 0; v_curr_vec_in_LZ_dqdPE3 = 0;
      a_curr_vec_in_AX_dqdPE3 = 0; a_curr_vec_in_AY_dqdPE3 = 0; a_curr_vec_in_AZ_dqdPE3 = 32'd43998; a_curr_vec_in_LX_dqdPE3 = 0; a_curr_vec_in_LY_dqdPE3 = 0; a_curr_vec_in_LZ_dqdPE3 = 0;
      // dqdPE4
      link_in_dqdPE4 = 3'd1;
      derv_in_dqdPE4 = 3'd4;
      sinq_val_in_dqdPE4 = 0; cosq_val_in_dqdPE4 = 0;
      qd_val_in_dqdPE4 = 0;
      v_curr_vec_in_AX_dqdPE4 = 0; v_curr_vec_in_AY_dqdPE4 = 0; v_curr_vec_in_AZ_dqdPE4 = 32'd65530; v_curr_vec_in_LX_dqdPE4 = 0; v_curr_vec_in_LY_dqdPE4 = 0; v_curr_vec_in_LZ_dqdPE4 = 0;
      a_curr_vec_in_AX_dqdPE4 = 0; a_curr_vec_in_AY_dqdPE4 = 0; a_curr_vec_in_AZ_dqdPE4 = 32'd43998; a_curr_vec_in_LX_dqdPE4 = 0; a_curr_vec_in_LY_dqdPE4 = 0; a_curr_vec_in_LZ_dqdPE4 = 0;
      // dqdPE5
      link_in_dqdPE5 = 3'd1;
      derv_in_dqdPE5 = 3'd5;
      sinq_val_in_dqdPE5 = 0; cosq_val_in_dqdPE5 = 0;
      qd_val_in_dqdPE5 = 0;
      v_curr_vec_in_AX_dqdPE5 = 0; v_curr_vec_in_AY_dqdPE5 = 0; v_curr_vec_in_AZ_dqdPE5 = 32'd65530; v_curr_vec_in_LX_dqdPE5 = 0; v_curr_vec_in_LY_dqdPE5 = 0; v_curr_vec_in_LZ_dqdPE5 = 0;
      a_curr_vec_in_AX_dqdPE5 = 0; a_curr_vec_in_AY_dqdPE5 = 0; a_curr_vec_in_AZ_dqdPE5 = 32'd43998; a_curr_vec_in_LX_dqdPE5 = 0; a_curr_vec_in_LY_dqdPE5 = 0; a_curr_vec_in_LZ_dqdPE5 = 0;
      // dqdPE6
      link_in_dqdPE6 = 3'd1;
      derv_in_dqdPE6 = 3'd6;
      sinq_val_in_dqdPE6 = 0; cosq_val_in_dqdPE6 = 0;
      qd_val_in_dqdPE6 = 0;
      v_curr_vec_in_AX_dqdPE6 = 0; v_curr_vec_in_AY_dqdPE6 = 0; v_curr_vec_in_AZ_dqdPE6 = 32'd65530; v_curr_vec_in_LX_dqdPE6 = 0; v_curr_vec_in_LY_dqdPE6 = 0; v_curr_vec_in_LZ_dqdPE6 = 0;
      a_curr_vec_in_AX_dqdPE6 = 0; a_curr_vec_in_AY_dqdPE6 = 0; a_curr_vec_in_AZ_dqdPE6 = 32'd43998; a_curr_vec_in_LX_dqdPE6 = 0; a_curr_vec_in_LY_dqdPE6 = 0; a_curr_vec_in_LZ_dqdPE6 = 0;
      // dqdPE7
      link_in_dqdPE7 = 3'd1;
      derv_in_dqdPE7 = 3'd7;
      sinq_val_in_dqdPE7 = 0; cosq_val_in_dqdPE7 = 0;
      qd_val_in_dqdPE7 = 0;
      v_curr_vec_in_AX_dqdPE7 = 0; v_curr_vec_in_AY_dqdPE7 = 0; v_curr_vec_in_AZ_dqdPE7 = 32'd65530; v_curr_vec_in_LX_dqdPE7 = 0; v_curr_vec_in_LY_dqdPE7 = 0; v_curr_vec_in_LZ_dqdPE7 = 0;
      a_curr_vec_in_AX_dqdPE7 = 0; a_curr_vec_in_AY_dqdPE7 = 0; a_curr_vec_in_AZ_dqdPE7 = 32'd43998; a_curr_vec_in_LX_dqdPE7 = 0; a_curr_vec_in_LY_dqdPE7 = 0; a_curr_vec_in_LZ_dqdPE7 = 0;
      // External dv,da
      // dqdPE1
      dvdqd_prev_vec_in_AX_dqdPE1 = 0; dvdqd_prev_vec_in_AY_dqdPE1 = 0; dvdqd_prev_vec_in_AZ_dqdPE1 = 0; dvdqd_prev_vec_in_LX_dqdPE1 = 0; dvdqd_prev_vec_in_LY_dqdPE1 = 0; dvdqd_prev_vec_in_LZ_dqdPE1 = 0;
      dadqd_prev_vec_in_AX_dqdPE1 = 0; dadqd_prev_vec_in_AY_dqdPE1 = 0; dadqd_prev_vec_in_AZ_dqdPE1 = 0; dadqd_prev_vec_in_LX_dqdPE1 = 0; dadqd_prev_vec_in_LY_dqdPE1 = 0; dadqd_prev_vec_in_LZ_dqdPE1 = 0;
      // dqdPE2
      dvdqd_prev_vec_in_AX_dqdPE2 = 0; dvdqd_prev_vec_in_AY_dqdPE2 = 0; dvdqd_prev_vec_in_AZ_dqdPE2 = 0; dvdqd_prev_vec_in_LX_dqdPE2 = 0; dvdqd_prev_vec_in_LY_dqdPE2 = 0; dvdqd_prev_vec_in_LZ_dqdPE2 = 0;
      dadqd_prev_vec_in_AX_dqdPE2 = 0; dadqd_prev_vec_in_AY_dqdPE2 = 0; dadqd_prev_vec_in_AZ_dqdPE2 = 0; dadqd_prev_vec_in_LX_dqdPE2 = 0; dadqd_prev_vec_in_LY_dqdPE2 = 0; dadqd_prev_vec_in_LZ_dqdPE2 = 0;
      // dqdPE3
      dvdqd_prev_vec_in_AX_dqdPE3 = 0; dvdqd_prev_vec_in_AY_dqdPE3 = 0; dvdqd_prev_vec_in_AZ_dqdPE3 = 0; dvdqd_prev_vec_in_LX_dqdPE3 = 0; dvdqd_prev_vec_in_LY_dqdPE3 = 0; dvdqd_prev_vec_in_LZ_dqdPE3 = 0;
      dadqd_prev_vec_in_AX_dqdPE3 = 0; dadqd_prev_vec_in_AY_dqdPE3 = 0; dadqd_prev_vec_in_AZ_dqdPE3 = 0; dadqd_prev_vec_in_LX_dqdPE3 = 0; dadqd_prev_vec_in_LY_dqdPE3 = 0; dadqd_prev_vec_in_LZ_dqdPE3 = 0;
      // dqdPE4
      dvdqd_prev_vec_in_AX_dqdPE4 = 0; dvdqd_prev_vec_in_AY_dqdPE4 = 0; dvdqd_prev_vec_in_AZ_dqdPE4 = 0; dvdqd_prev_vec_in_LX_dqdPE4 = 0; dvdqd_prev_vec_in_LY_dqdPE4 = 0; dvdqd_prev_vec_in_LZ_dqdPE4 = 0;
      dadqd_prev_vec_in_AX_dqdPE4 = 0; dadqd_prev_vec_in_AY_dqdPE4 = 0; dadqd_prev_vec_in_AZ_dqdPE4 = 0; dadqd_prev_vec_in_LX_dqdPE4 = 0; dadqd_prev_vec_in_LY_dqdPE4 = 0; dadqd_prev_vec_in_LZ_dqdPE4 = 0;
      // dqdPE5
      dvdqd_prev_vec_in_AX_dqdPE5 = 0; dvdqd_prev_vec_in_AY_dqdPE5 = 0; dvdqd_prev_vec_in_AZ_dqdPE5 = 0; dvdqd_prev_vec_in_LX_dqdPE5 = 0; dvdqd_prev_vec_in_LY_dqdPE5 = 0; dvdqd_prev_vec_in_LZ_dqdPE5 = 0;
      dadqd_prev_vec_in_AX_dqdPE5 = 0; dadqd_prev_vec_in_AY_dqdPE5 = 0; dadqd_prev_vec_in_AZ_dqdPE5 = 0; dadqd_prev_vec_in_LX_dqdPE5 = 0; dadqd_prev_vec_in_LY_dqdPE5 = 0; dadqd_prev_vec_in_LZ_dqdPE5 = 0;
      // dqdPE6
      dvdqd_prev_vec_in_AX_dqdPE6 = 0; dvdqd_prev_vec_in_AY_dqdPE6 = 0; dvdqd_prev_vec_in_AZ_dqdPE6 = 0; dvdqd_prev_vec_in_LX_dqdPE6 = 0; dvdqd_prev_vec_in_LY_dqdPE6 = 0; dvdqd_prev_vec_in_LZ_dqdPE6 = 0;
      dadqd_prev_vec_in_AX_dqdPE6 = 0; dadqd_prev_vec_in_AY_dqdPE6 = 0; dadqd_prev_vec_in_AZ_dqdPE6 = 0; dadqd_prev_vec_in_LX_dqdPE6 = 0; dadqd_prev_vec_in_LY_dqdPE6 = 0; dadqd_prev_vec_in_LZ_dqdPE6 = 0;
      // dqdPE7
      dvdqd_prev_vec_in_AX_dqdPE7 = 0; dvdqd_prev_vec_in_AY_dqdPE7 = 0; dvdqd_prev_vec_in_AZ_dqdPE7 = 0; dvdqd_prev_vec_in_LX_dqdPE7 = 0; dvdqd_prev_vec_in_LY_dqdPE7 = 0; dvdqd_prev_vec_in_LZ_dqdPE7 = 0;
      dadqd_prev_vec_in_AX_dqdPE7 = 0; dadqd_prev_vec_in_AY_dqdPE7 = 0; dadqd_prev_vec_in_AZ_dqdPE7 = 0; dadqd_prev_vec_in_LX_dqdPE7 = 0; dadqd_prev_vec_in_LY_dqdPE7 = 0; dadqd_prev_vec_in_LZ_dqdPE7 = 0;
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
      $display ("// Link 2 RNEA");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2226, -184, 6473, -20115, -5700, 54);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_curr_vec_out_AX_rnea,f_curr_vec_out_AY_rnea,f_curr_vec_out_AZ_rnea,f_curr_vec_out_LX_rnea,f_curr_vec_out_LY_rnea,f_curr_vec_out_LZ_rnea);
      $display ("//-------------------------------------------------------------------------------------------------------");
      $display ("// Link 1 Derivatives");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AX_dqPE1,dfdq_curr_vec_out_AX_dqPE2,dfdq_curr_vec_out_AX_dqPE3,dfdq_curr_vec_out_AX_dqPE4,dfdq_curr_vec_out_AX_dqPE5,dfdq_curr_vec_out_AX_dqPE6,dfdq_curr_vec_out_AX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AY_dqPE1,dfdq_curr_vec_out_AY_dqPE2,dfdq_curr_vec_out_AY_dqPE3,dfdq_curr_vec_out_AY_dqPE4,dfdq_curr_vec_out_AY_dqPE5,dfdq_curr_vec_out_AY_dqPE6,dfdq_curr_vec_out_AY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AZ_dqPE1,dfdq_curr_vec_out_AZ_dqPE2,dfdq_curr_vec_out_AZ_dqPE3,dfdq_curr_vec_out_AZ_dqPE4,dfdq_curr_vec_out_AZ_dqPE5,dfdq_curr_vec_out_AZ_dqPE6,dfdq_curr_vec_out_AZ_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LX_dqPE1,dfdq_curr_vec_out_LX_dqPE2,dfdq_curr_vec_out_LX_dqPE3,dfdq_curr_vec_out_LX_dqPE4,dfdq_curr_vec_out_LX_dqPE5,dfdq_curr_vec_out_LX_dqPE6,dfdq_curr_vec_out_LX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LY_dqPE1,dfdq_curr_vec_out_LY_dqPE2,dfdq_curr_vec_out_LY_dqPE3,dfdq_curr_vec_out_LY_dqPE4,dfdq_curr_vec_out_LY_dqPE5,dfdq_curr_vec_out_LY_dqPE6,dfdq_curr_vec_out_LY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LZ_dqPE1,dfdq_curr_vec_out_LZ_dqPE2,dfdq_curr_vec_out_LZ_dqPE3,dfdq_curr_vec_out_LZ_dqPE4,dfdq_curr_vec_out_LZ_dqPE5,dfdq_curr_vec_out_LZ_dqPE6,dfdq_curr_vec_out_LZ_dqPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -1887, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 15727, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 0, 0, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AX_dqdPE1,dfdqd_curr_vec_out_AX_dqdPE2,dfdqd_curr_vec_out_AX_dqdPE3,dfdqd_curr_vec_out_AX_dqdPE4,dfdqd_curr_vec_out_AX_dqdPE5,dfdqd_curr_vec_out_AX_dqdPE6,dfdqd_curr_vec_out_AX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AY_dqdPE1,dfdqd_curr_vec_out_AY_dqdPE2,dfdqd_curr_vec_out_AY_dqdPE3,dfdqd_curr_vec_out_AY_dqdPE4,dfdqd_curr_vec_out_AY_dqdPE5,dfdqd_curr_vec_out_AY_dqdPE6,dfdqd_curr_vec_out_AY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AZ_dqdPE1,dfdqd_curr_vec_out_AZ_dqdPE2,dfdqd_curr_vec_out_AZ_dqdPE3,dfdqd_curr_vec_out_AZ_dqdPE4,dfdqd_curr_vec_out_AZ_dqdPE5,dfdqd_curr_vec_out_AZ_dqdPE6,dfdqd_curr_vec_out_AZ_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LX_dqdPE1,dfdqd_curr_vec_out_LX_dqdPE2,dfdqd_curr_vec_out_LX_dqdPE3,dfdqd_curr_vec_out_LX_dqdPE4,dfdqd_curr_vec_out_LX_dqdPE5,dfdqd_curr_vec_out_LX_dqdPE6,dfdqd_curr_vec_out_LX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LY_dqdPE1,dfdqd_curr_vec_out_LY_dqdPE2,dfdqd_curr_vec_out_LY_dqdPE3,dfdqd_curr_vec_out_LY_dqdPE4,dfdqd_curr_vec_out_LY_dqdPE5,dfdqd_curr_vec_out_LY_dqdPE6,dfdqd_curr_vec_out_LY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LZ_dqdPE1,dfdqd_curr_vec_out_LZ_dqdPE2,dfdqd_curr_vec_out_LZ_dqdPE3,dfdqd_curr_vec_out_LZ_dqdPE4,dfdqd_curr_vec_out_LZ_dqdPE5,dfdqd_curr_vec_out_LZ_dqdPE6,dfdqd_curr_vec_out_LZ_dqdPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External dv,da
      //------------------------------------------------------------------------
      // dqPE1
      dvdq_curr_vec_reg_AX_dqPE1 = dvdq_curr_vec_out_AX_dqPE1; dvdq_curr_vec_reg_AY_dqPE1 = dvdq_curr_vec_out_AY_dqPE1; dvdq_curr_vec_reg_AZ_dqPE1 = dvdq_curr_vec_out_AZ_dqPE1; dvdq_curr_vec_reg_LX_dqPE1 = dvdq_curr_vec_out_LX_dqPE1; dvdq_curr_vec_reg_LY_dqPE1 = dvdq_curr_vec_out_LY_dqPE1; dvdq_curr_vec_reg_LZ_dqPE1 = dvdq_curr_vec_out_LZ_dqPE1; 
      dadq_curr_vec_reg_AX_dqPE1 = dadq_curr_vec_out_AX_dqPE1; dadq_curr_vec_reg_AY_dqPE1 = dadq_curr_vec_out_AY_dqPE1; dadq_curr_vec_reg_AZ_dqPE1 = dadq_curr_vec_out_AZ_dqPE1; dadq_curr_vec_reg_LX_dqPE1 = dadq_curr_vec_out_LX_dqPE1; dadq_curr_vec_reg_LY_dqPE1 = dadq_curr_vec_out_LY_dqPE1; dadq_curr_vec_reg_LZ_dqPE1 = dadq_curr_vec_out_LZ_dqPE1; 
      // dqPE2
      dvdq_curr_vec_reg_AX_dqPE2 = dvdq_curr_vec_out_AX_dqPE2; dvdq_curr_vec_reg_AY_dqPE2 = dvdq_curr_vec_out_AY_dqPE2; dvdq_curr_vec_reg_AZ_dqPE2 = dvdq_curr_vec_out_AZ_dqPE2; dvdq_curr_vec_reg_LX_dqPE2 = dvdq_curr_vec_out_LX_dqPE2; dvdq_curr_vec_reg_LY_dqPE2 = dvdq_curr_vec_out_LY_dqPE2; dvdq_curr_vec_reg_LZ_dqPE2 = dvdq_curr_vec_out_LZ_dqPE2; 
      dadq_curr_vec_reg_AX_dqPE2 = dadq_curr_vec_out_AX_dqPE2; dadq_curr_vec_reg_AY_dqPE2 = dadq_curr_vec_out_AY_dqPE2; dadq_curr_vec_reg_AZ_dqPE2 = dadq_curr_vec_out_AZ_dqPE2; dadq_curr_vec_reg_LX_dqPE2 = dadq_curr_vec_out_LX_dqPE2; dadq_curr_vec_reg_LY_dqPE2 = dadq_curr_vec_out_LY_dqPE2; dadq_curr_vec_reg_LZ_dqPE2 = dadq_curr_vec_out_LZ_dqPE2; 
      // dqPE3
      dvdq_curr_vec_reg_AX_dqPE3 = dvdq_curr_vec_out_AX_dqPE3; dvdq_curr_vec_reg_AY_dqPE3 = dvdq_curr_vec_out_AY_dqPE3; dvdq_curr_vec_reg_AZ_dqPE3 = dvdq_curr_vec_out_AZ_dqPE3; dvdq_curr_vec_reg_LX_dqPE3 = dvdq_curr_vec_out_LX_dqPE3; dvdq_curr_vec_reg_LY_dqPE3 = dvdq_curr_vec_out_LY_dqPE3; dvdq_curr_vec_reg_LZ_dqPE3 = dvdq_curr_vec_out_LZ_dqPE3; 
      dadq_curr_vec_reg_AX_dqPE3 = dadq_curr_vec_out_AX_dqPE3; dadq_curr_vec_reg_AY_dqPE3 = dadq_curr_vec_out_AY_dqPE3; dadq_curr_vec_reg_AZ_dqPE3 = dadq_curr_vec_out_AZ_dqPE3; dadq_curr_vec_reg_LX_dqPE3 = dadq_curr_vec_out_LX_dqPE3; dadq_curr_vec_reg_LY_dqPE3 = dadq_curr_vec_out_LY_dqPE3; dadq_curr_vec_reg_LZ_dqPE3 = dadq_curr_vec_out_LZ_dqPE3; 
      // dqPE4
      dvdq_curr_vec_reg_AX_dqPE4 = dvdq_curr_vec_out_AX_dqPE4; dvdq_curr_vec_reg_AY_dqPE4 = dvdq_curr_vec_out_AY_dqPE4; dvdq_curr_vec_reg_AZ_dqPE4 = dvdq_curr_vec_out_AZ_dqPE4; dvdq_curr_vec_reg_LX_dqPE4 = dvdq_curr_vec_out_LX_dqPE4; dvdq_curr_vec_reg_LY_dqPE4 = dvdq_curr_vec_out_LY_dqPE4; dvdq_curr_vec_reg_LZ_dqPE4 = dvdq_curr_vec_out_LZ_dqPE4; 
      dadq_curr_vec_reg_AX_dqPE4 = dadq_curr_vec_out_AX_dqPE4; dadq_curr_vec_reg_AY_dqPE4 = dadq_curr_vec_out_AY_dqPE4; dadq_curr_vec_reg_AZ_dqPE4 = dadq_curr_vec_out_AZ_dqPE4; dadq_curr_vec_reg_LX_dqPE4 = dadq_curr_vec_out_LX_dqPE4; dadq_curr_vec_reg_LY_dqPE4 = dadq_curr_vec_out_LY_dqPE4; dadq_curr_vec_reg_LZ_dqPE4 = dadq_curr_vec_out_LZ_dqPE4; 
      // dqPE5
      dvdq_curr_vec_reg_AX_dqPE5 = dvdq_curr_vec_out_AX_dqPE5; dvdq_curr_vec_reg_AY_dqPE5 = dvdq_curr_vec_out_AY_dqPE5; dvdq_curr_vec_reg_AZ_dqPE5 = dvdq_curr_vec_out_AZ_dqPE5; dvdq_curr_vec_reg_LX_dqPE5 = dvdq_curr_vec_out_LX_dqPE5; dvdq_curr_vec_reg_LY_dqPE5 = dvdq_curr_vec_out_LY_dqPE5; dvdq_curr_vec_reg_LZ_dqPE5 = dvdq_curr_vec_out_LZ_dqPE5; 
      dadq_curr_vec_reg_AX_dqPE5 = dadq_curr_vec_out_AX_dqPE5; dadq_curr_vec_reg_AY_dqPE5 = dadq_curr_vec_out_AY_dqPE5; dadq_curr_vec_reg_AZ_dqPE5 = dadq_curr_vec_out_AZ_dqPE5; dadq_curr_vec_reg_LX_dqPE5 = dadq_curr_vec_out_LX_dqPE5; dadq_curr_vec_reg_LY_dqPE5 = dadq_curr_vec_out_LY_dqPE5; dadq_curr_vec_reg_LZ_dqPE5 = dadq_curr_vec_out_LZ_dqPE5; 
      // dqPE6
      dvdq_curr_vec_reg_AX_dqPE6 = dvdq_curr_vec_out_AX_dqPE6; dvdq_curr_vec_reg_AY_dqPE6 = dvdq_curr_vec_out_AY_dqPE6; dvdq_curr_vec_reg_AZ_dqPE6 = dvdq_curr_vec_out_AZ_dqPE6; dvdq_curr_vec_reg_LX_dqPE6 = dvdq_curr_vec_out_LX_dqPE6; dvdq_curr_vec_reg_LY_dqPE6 = dvdq_curr_vec_out_LY_dqPE6; dvdq_curr_vec_reg_LZ_dqPE6 = dvdq_curr_vec_out_LZ_dqPE6; 
      dadq_curr_vec_reg_AX_dqPE6 = dadq_curr_vec_out_AX_dqPE6; dadq_curr_vec_reg_AY_dqPE6 = dadq_curr_vec_out_AY_dqPE6; dadq_curr_vec_reg_AZ_dqPE6 = dadq_curr_vec_out_AZ_dqPE6; dadq_curr_vec_reg_LX_dqPE6 = dadq_curr_vec_out_LX_dqPE6; dadq_curr_vec_reg_LY_dqPE6 = dadq_curr_vec_out_LY_dqPE6; dadq_curr_vec_reg_LZ_dqPE6 = dadq_curr_vec_out_LZ_dqPE6; 
      // dqPE7
      dvdq_curr_vec_reg_AX_dqPE7 = dvdq_curr_vec_out_AX_dqPE7; dvdq_curr_vec_reg_AY_dqPE7 = dvdq_curr_vec_out_AY_dqPE7; dvdq_curr_vec_reg_AZ_dqPE7 = dvdq_curr_vec_out_AZ_dqPE7; dvdq_curr_vec_reg_LX_dqPE7 = dvdq_curr_vec_out_LX_dqPE7; dvdq_curr_vec_reg_LY_dqPE7 = dvdq_curr_vec_out_LY_dqPE7; dvdq_curr_vec_reg_LZ_dqPE7 = dvdq_curr_vec_out_LZ_dqPE7; 
      dadq_curr_vec_reg_AX_dqPE7 = dadq_curr_vec_out_AX_dqPE7; dadq_curr_vec_reg_AY_dqPE7 = dadq_curr_vec_out_AY_dqPE7; dadq_curr_vec_reg_AZ_dqPE7 = dadq_curr_vec_out_AZ_dqPE7; dadq_curr_vec_reg_LX_dqPE7 = dadq_curr_vec_out_LX_dqPE7; dadq_curr_vec_reg_LY_dqPE7 = dadq_curr_vec_out_LY_dqPE7; dadq_curr_vec_reg_LZ_dqPE7 = dadq_curr_vec_out_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqdPE1
      dvdqd_curr_vec_reg_AX_dqdPE1 = dvdqd_curr_vec_out_AX_dqdPE1; dvdqd_curr_vec_reg_AY_dqdPE1 = dvdqd_curr_vec_out_AY_dqdPE1; dvdqd_curr_vec_reg_AZ_dqdPE1 = dvdqd_curr_vec_out_AZ_dqdPE1; dvdqd_curr_vec_reg_LX_dqdPE1 = dvdqd_curr_vec_out_LX_dqdPE1; dvdqd_curr_vec_reg_LY_dqdPE1 = dvdqd_curr_vec_out_LY_dqdPE1; dvdqd_curr_vec_reg_LZ_dqdPE1 = dvdqd_curr_vec_out_LZ_dqdPE1; 
      dadqd_curr_vec_reg_AX_dqdPE1 = dadqd_curr_vec_out_AX_dqdPE1; dadqd_curr_vec_reg_AY_dqdPE1 = dadqd_curr_vec_out_AY_dqdPE1; dadqd_curr_vec_reg_AZ_dqdPE1 = dadqd_curr_vec_out_AZ_dqdPE1; dadqd_curr_vec_reg_LX_dqdPE1 = dadqd_curr_vec_out_LX_dqdPE1; dadqd_curr_vec_reg_LY_dqdPE1 = dadqd_curr_vec_out_LY_dqdPE1; dadqd_curr_vec_reg_LZ_dqdPE1 = dadqd_curr_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dvdqd_curr_vec_reg_AX_dqdPE2 = dvdqd_curr_vec_out_AX_dqdPE2; dvdqd_curr_vec_reg_AY_dqdPE2 = dvdqd_curr_vec_out_AY_dqdPE2; dvdqd_curr_vec_reg_AZ_dqdPE2 = dvdqd_curr_vec_out_AZ_dqdPE2; dvdqd_curr_vec_reg_LX_dqdPE2 = dvdqd_curr_vec_out_LX_dqdPE2; dvdqd_curr_vec_reg_LY_dqdPE2 = dvdqd_curr_vec_out_LY_dqdPE2; dvdqd_curr_vec_reg_LZ_dqdPE2 = dvdqd_curr_vec_out_LZ_dqdPE2; 
      dadqd_curr_vec_reg_AX_dqdPE2 = dadqd_curr_vec_out_AX_dqdPE2; dadqd_curr_vec_reg_AY_dqdPE2 = dadqd_curr_vec_out_AY_dqdPE2; dadqd_curr_vec_reg_AZ_dqdPE2 = dadqd_curr_vec_out_AZ_dqdPE2; dadqd_curr_vec_reg_LX_dqdPE2 = dadqd_curr_vec_out_LX_dqdPE2; dadqd_curr_vec_reg_LY_dqdPE2 = dadqd_curr_vec_out_LY_dqdPE2; dadqd_curr_vec_reg_LZ_dqdPE2 = dadqd_curr_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dvdqd_curr_vec_reg_AX_dqdPE3 = dvdqd_curr_vec_out_AX_dqdPE3; dvdqd_curr_vec_reg_AY_dqdPE3 = dvdqd_curr_vec_out_AY_dqdPE3; dvdqd_curr_vec_reg_AZ_dqdPE3 = dvdqd_curr_vec_out_AZ_dqdPE3; dvdqd_curr_vec_reg_LX_dqdPE3 = dvdqd_curr_vec_out_LX_dqdPE3; dvdqd_curr_vec_reg_LY_dqdPE3 = dvdqd_curr_vec_out_LY_dqdPE3; dvdqd_curr_vec_reg_LZ_dqdPE3 = dvdqd_curr_vec_out_LZ_dqdPE3; 
      dadqd_curr_vec_reg_AX_dqdPE3 = dadqd_curr_vec_out_AX_dqdPE3; dadqd_curr_vec_reg_AY_dqdPE3 = dadqd_curr_vec_out_AY_dqdPE3; dadqd_curr_vec_reg_AZ_dqdPE3 = dadqd_curr_vec_out_AZ_dqdPE3; dadqd_curr_vec_reg_LX_dqdPE3 = dadqd_curr_vec_out_LX_dqdPE3; dadqd_curr_vec_reg_LY_dqdPE3 = dadqd_curr_vec_out_LY_dqdPE3; dadqd_curr_vec_reg_LZ_dqdPE3 = dadqd_curr_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dvdqd_curr_vec_reg_AX_dqdPE4 = dvdqd_curr_vec_out_AX_dqdPE4; dvdqd_curr_vec_reg_AY_dqdPE4 = dvdqd_curr_vec_out_AY_dqdPE4; dvdqd_curr_vec_reg_AZ_dqdPE4 = dvdqd_curr_vec_out_AZ_dqdPE4; dvdqd_curr_vec_reg_LX_dqdPE4 = dvdqd_curr_vec_out_LX_dqdPE4; dvdqd_curr_vec_reg_LY_dqdPE4 = dvdqd_curr_vec_out_LY_dqdPE4; dvdqd_curr_vec_reg_LZ_dqdPE4 = dvdqd_curr_vec_out_LZ_dqdPE4; 
      dadqd_curr_vec_reg_AX_dqdPE4 = dadqd_curr_vec_out_AX_dqdPE4; dadqd_curr_vec_reg_AY_dqdPE4 = dadqd_curr_vec_out_AY_dqdPE4; dadqd_curr_vec_reg_AZ_dqdPE4 = dadqd_curr_vec_out_AZ_dqdPE4; dadqd_curr_vec_reg_LX_dqdPE4 = dadqd_curr_vec_out_LX_dqdPE4; dadqd_curr_vec_reg_LY_dqdPE4 = dadqd_curr_vec_out_LY_dqdPE4; dadqd_curr_vec_reg_LZ_dqdPE4 = dadqd_curr_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dvdqd_curr_vec_reg_AX_dqdPE5 = dvdqd_curr_vec_out_AX_dqdPE5; dvdqd_curr_vec_reg_AY_dqdPE5 = dvdqd_curr_vec_out_AY_dqdPE5; dvdqd_curr_vec_reg_AZ_dqdPE5 = dvdqd_curr_vec_out_AZ_dqdPE5; dvdqd_curr_vec_reg_LX_dqdPE5 = dvdqd_curr_vec_out_LX_dqdPE5; dvdqd_curr_vec_reg_LY_dqdPE5 = dvdqd_curr_vec_out_LY_dqdPE5; dvdqd_curr_vec_reg_LZ_dqdPE5 = dvdqd_curr_vec_out_LZ_dqdPE5; 
      dadqd_curr_vec_reg_AX_dqdPE5 = dadqd_curr_vec_out_AX_dqdPE5; dadqd_curr_vec_reg_AY_dqdPE5 = dadqd_curr_vec_out_AY_dqdPE5; dadqd_curr_vec_reg_AZ_dqdPE5 = dadqd_curr_vec_out_AZ_dqdPE5; dadqd_curr_vec_reg_LX_dqdPE5 = dadqd_curr_vec_out_LX_dqdPE5; dadqd_curr_vec_reg_LY_dqdPE5 = dadqd_curr_vec_out_LY_dqdPE5; dadqd_curr_vec_reg_LZ_dqdPE5 = dadqd_curr_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dvdqd_curr_vec_reg_AX_dqdPE6 = dvdqd_curr_vec_out_AX_dqdPE6; dvdqd_curr_vec_reg_AY_dqdPE6 = dvdqd_curr_vec_out_AY_dqdPE6; dvdqd_curr_vec_reg_AZ_dqdPE6 = dvdqd_curr_vec_out_AZ_dqdPE6; dvdqd_curr_vec_reg_LX_dqdPE6 = dvdqd_curr_vec_out_LX_dqdPE6; dvdqd_curr_vec_reg_LY_dqdPE6 = dvdqd_curr_vec_out_LY_dqdPE6; dvdqd_curr_vec_reg_LZ_dqdPE6 = dvdqd_curr_vec_out_LZ_dqdPE6; 
      dadqd_curr_vec_reg_AX_dqdPE6 = dadqd_curr_vec_out_AX_dqdPE6; dadqd_curr_vec_reg_AY_dqdPE6 = dadqd_curr_vec_out_AY_dqdPE6; dadqd_curr_vec_reg_AZ_dqdPE6 = dadqd_curr_vec_out_AZ_dqdPE6; dadqd_curr_vec_reg_LX_dqdPE6 = dadqd_curr_vec_out_LX_dqdPE6; dadqd_curr_vec_reg_LY_dqdPE6 = dadqd_curr_vec_out_LY_dqdPE6; dadqd_curr_vec_reg_LZ_dqdPE6 = dadqd_curr_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dvdqd_curr_vec_reg_AX_dqdPE7 = dvdqd_curr_vec_out_AX_dqdPE7; dvdqd_curr_vec_reg_AY_dqdPE7 = dvdqd_curr_vec_out_AY_dqdPE7; dvdqd_curr_vec_reg_AZ_dqdPE7 = dvdqd_curr_vec_out_AZ_dqdPE7; dvdqd_curr_vec_reg_LX_dqdPE7 = dvdqd_curr_vec_out_LX_dqdPE7; dvdqd_curr_vec_reg_LY_dqdPE7 = dvdqd_curr_vec_out_LY_dqdPE7; dvdqd_curr_vec_reg_LZ_dqdPE7 = dvdqd_curr_vec_out_LZ_dqdPE7; 
      dadqd_curr_vec_reg_AX_dqdPE7 = dadqd_curr_vec_out_AX_dqdPE7; dadqd_curr_vec_reg_AY_dqdPE7 = dadqd_curr_vec_out_AY_dqdPE7; dadqd_curr_vec_reg_AZ_dqdPE7 = dadqd_curr_vec_out_AZ_dqdPE7; dadqd_curr_vec_reg_LX_dqdPE7 = dadqd_curr_vec_out_LX_dqdPE7; dadqd_curr_vec_reg_LY_dqdPE7 = dadqd_curr_vec_out_LY_dqdPE7; dadqd_curr_vec_reg_LZ_dqdPE7 = dadqd_curr_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Link 3 Inputs
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 3'd3;
      sinq_val_in_rnea = -32'd36876; cosq_val_in_rnea = 32'd54177;
      qd_val_in_rnea = 32'd64662;
      qdd_val_in_rnea = -32'd60321;
      v_prev_vec_in_AX_rnea = 32'd24452; v_prev_vec_in_AY_rnea = 32'd60797; v_prev_vec_in_AZ_rnea = 32'd16493; v_prev_vec_in_LX_rnea = 32'd0; v_prev_vec_in_LY_rnea = 32'd0; v_prev_vec_in_LZ_rnea = 32'd0;
      a_prev_vec_in_AX_rnea = 32'd31718; a_prev_vec_in_AY_rnea = 32'd34667; a_prev_vec_in_AZ_rnea = 32'd136669; a_prev_vec_in_LX_rnea = 32'd0; a_prev_vec_in_LY_rnea = 32'd0; a_prev_vec_in_LZ_rnea = 32'd0;
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 0;
      derv_in_dqPE1 = 3'd1;
      sinq_val_in_dqPE1 = 0; cosq_val_in_dqPE1 = 0;
      qd_val_in_dqPE1 = 0;
      v_curr_vec_in_AX_dqPE1 = 0; v_curr_vec_in_AY_dqPE1 = 0; v_curr_vec_in_AZ_dqPE1 = 0; v_curr_vec_in_LX_dqPE1 = 0; v_curr_vec_in_LY_dqPE1 = 0; v_curr_vec_in_LZ_dqPE1 = 0;
      a_curr_vec_in_AX_dqPE1 = 0; a_curr_vec_in_AY_dqPE1 = 0; a_curr_vec_in_AZ_dqPE1 = 0; a_curr_vec_in_LX_dqPE1 = 0; a_curr_vec_in_LY_dqPE1 = 0; a_curr_vec_in_LZ_dqPE1 = 0;
      v_prev_vec_in_AX_dqPE1 = 0; v_prev_vec_in_AY_dqPE1 = 0; v_prev_vec_in_AZ_dqPE1 = 0; v_prev_vec_in_LX_dqPE1 = 0; v_prev_vec_in_LY_dqPE1 = 0; v_prev_vec_in_LZ_dqPE1 = 0;
      a_prev_vec_in_AX_dqPE1 = 0; a_prev_vec_in_AY_dqPE1 = 0; a_prev_vec_in_AZ_dqPE1 = 0; a_prev_vec_in_LX_dqPE1 = 0; a_prev_vec_in_LY_dqPE1 = 0; a_prev_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      link_in_dqPE2 = 3'd2;
      derv_in_dqPE2 = 3'd2;
      sinq_val_in_dqPE2 = 32'd24454; cosq_val_in_dqPE2 = 32'd60803;
      qd_val_in_dqPE2 = 32'd16493;
      v_curr_vec_in_AX_dqPE2 = 32'd24452; v_curr_vec_in_AY_dqPE2 = 32'd60797; v_curr_vec_in_AZ_dqPE2 = 32'd16493; v_curr_vec_in_LX_dqPE2 = 32'd0; v_curr_vec_in_LY_dqPE2 = 32'd0; v_curr_vec_in_LZ_dqPE2 = 32'd0;
      a_curr_vec_in_AX_dqPE2 = 32'd31718; a_curr_vec_in_AY_dqPE2 = 32'd34667; a_curr_vec_in_AZ_dqPE2 = 32'd136669; a_curr_vec_in_LX_dqPE2 = 32'd0; a_curr_vec_in_LY_dqPE2 = 32'd0; a_curr_vec_in_LZ_dqPE2 = 32'd0;
      v_prev_vec_in_AX_dqPE2 = 32'd0; v_prev_vec_in_AY_dqPE2 = 32'd0; v_prev_vec_in_AZ_dqPE2 = 32'd65530; v_prev_vec_in_LX_dqPE2 = 32'd0; v_prev_vec_in_LY_dqPE2 = 32'd0; v_prev_vec_in_LZ_dqPE2 = 32'd0;
      a_prev_vec_in_AX_dqPE2 = 32'd0; a_prev_vec_in_AY_dqPE2 = 32'd0; a_prev_vec_in_AZ_dqPE2 = 32'd43998; a_prev_vec_in_LX_dqPE2 = 32'd0; a_prev_vec_in_LY_dqPE2 = 32'd0; a_prev_vec_in_LZ_dqPE2 = 32'd0;
      // dqPE3
      link_in_dqPE3 = 3'd2;
      derv_in_dqPE3 = 3'd3;
      sinq_val_in_dqPE3 = 32'd24454; cosq_val_in_dqPE3 = 32'd60803;
      qd_val_in_dqPE3 = 32'd16493;
      v_curr_vec_in_AX_dqPE3 = 32'd24452; v_curr_vec_in_AY_dqPE3 = 32'd60797; v_curr_vec_in_AZ_dqPE3 = 32'd16493; v_curr_vec_in_LX_dqPE3 = 32'd0; v_curr_vec_in_LY_dqPE3 = 32'd0; v_curr_vec_in_LZ_dqPE3 = 32'd0;
      a_curr_vec_in_AX_dqPE3 = 32'd31718; a_curr_vec_in_AY_dqPE3 = 32'd34667; a_curr_vec_in_AZ_dqPE3 = 32'd136669; a_curr_vec_in_LX_dqPE3 = 32'd0; a_curr_vec_in_LY_dqPE3 = 32'd0; a_curr_vec_in_LZ_dqPE3 = 32'd0;
      v_prev_vec_in_AX_dqPE3 = 32'd0; v_prev_vec_in_AY_dqPE3 = 32'd0; v_prev_vec_in_AZ_dqPE3 = 32'd65530; v_prev_vec_in_LX_dqPE3 = 32'd0; v_prev_vec_in_LY_dqPE3 = 32'd0; v_prev_vec_in_LZ_dqPE3 = 32'd0;
      a_prev_vec_in_AX_dqPE3 = 32'd0; a_prev_vec_in_AY_dqPE3 = 32'd0; a_prev_vec_in_AZ_dqPE3 = 32'd43998; a_prev_vec_in_LX_dqPE3 = 32'd0; a_prev_vec_in_LY_dqPE3 = 32'd0; a_prev_vec_in_LZ_dqPE3 = 32'd0;
      // dqPE4
      link_in_dqPE4 = 3'd2;
      derv_in_dqPE4 = 3'd4;
      sinq_val_in_dqPE4 = 32'd24454; cosq_val_in_dqPE4 = 32'd60803;
      qd_val_in_dqPE4 = 32'd16493;
      v_curr_vec_in_AX_dqPE4 = 32'd24452; v_curr_vec_in_AY_dqPE4 = 32'd60797; v_curr_vec_in_AZ_dqPE4 = 32'd16493; v_curr_vec_in_LX_dqPE4 = 32'd0; v_curr_vec_in_LY_dqPE4 = 32'd0; v_curr_vec_in_LZ_dqPE4 = 32'd0;
      a_curr_vec_in_AX_dqPE4 = 32'd31718; a_curr_vec_in_AY_dqPE4 = 32'd34667; a_curr_vec_in_AZ_dqPE4 = 32'd136669; a_curr_vec_in_LX_dqPE4 = 32'd0; a_curr_vec_in_LY_dqPE4 = 32'd0; a_curr_vec_in_LZ_dqPE4 = 32'd0;
      v_prev_vec_in_AX_dqPE4 = 32'd0; v_prev_vec_in_AY_dqPE4 = 32'd0; v_prev_vec_in_AZ_dqPE4 = 32'd65530; v_prev_vec_in_LX_dqPE4 = 32'd0; v_prev_vec_in_LY_dqPE4 = 32'd0; v_prev_vec_in_LZ_dqPE4 = 32'd0;
      a_prev_vec_in_AX_dqPE4 = 32'd0; a_prev_vec_in_AY_dqPE4 = 32'd0; a_prev_vec_in_AZ_dqPE4 = 32'd43998; a_prev_vec_in_LX_dqPE4 = 32'd0; a_prev_vec_in_LY_dqPE4 = 32'd0; a_prev_vec_in_LZ_dqPE4 = 32'd0;
      // dqPE5
      link_in_dqPE5 = 3'd2;
      derv_in_dqPE5 = 3'd5;
      sinq_val_in_dqPE5 = 32'd24454; cosq_val_in_dqPE5 = 32'd60803;
      qd_val_in_dqPE5 = 32'd16493;
      v_curr_vec_in_AX_dqPE5 = 32'd24452; v_curr_vec_in_AY_dqPE5 = 32'd60797; v_curr_vec_in_AZ_dqPE5 = 32'd16493; v_curr_vec_in_LX_dqPE5 = 32'd0; v_curr_vec_in_LY_dqPE5 = 32'd0; v_curr_vec_in_LZ_dqPE5 = 32'd0;
      a_curr_vec_in_AX_dqPE5 = 32'd31718; a_curr_vec_in_AY_dqPE5 = 32'd34667; a_curr_vec_in_AZ_dqPE5 = 32'd136669; a_curr_vec_in_LX_dqPE5 = 32'd0; a_curr_vec_in_LY_dqPE5 = 32'd0; a_curr_vec_in_LZ_dqPE5 = 32'd0;
      v_prev_vec_in_AX_dqPE5 = 32'd0; v_prev_vec_in_AY_dqPE5 = 32'd0; v_prev_vec_in_AZ_dqPE5 = 32'd65530; v_prev_vec_in_LX_dqPE5 = 32'd0; v_prev_vec_in_LY_dqPE5 = 32'd0; v_prev_vec_in_LZ_dqPE5 = 32'd0;
      a_prev_vec_in_AX_dqPE5 = 32'd0; a_prev_vec_in_AY_dqPE5 = 32'd0; a_prev_vec_in_AZ_dqPE5 = 32'd43998; a_prev_vec_in_LX_dqPE5 = 32'd0; a_prev_vec_in_LY_dqPE5 = 32'd0; a_prev_vec_in_LZ_dqPE5 = 32'd0;
      // dqPE6
      link_in_dqPE6 = 3'd2;
      derv_in_dqPE6 = 3'd6;
      sinq_val_in_dqPE6 = 32'd24454; cosq_val_in_dqPE6 = 32'd60803;
      qd_val_in_dqPE6 = 32'd16493;
      v_curr_vec_in_AX_dqPE6 = 32'd24452; v_curr_vec_in_AY_dqPE6 = 32'd60797; v_curr_vec_in_AZ_dqPE6 = 32'd16493; v_curr_vec_in_LX_dqPE6 = 32'd0; v_curr_vec_in_LY_dqPE6 = 32'd0; v_curr_vec_in_LZ_dqPE6 = 32'd0;
      a_curr_vec_in_AX_dqPE6 = 32'd31718; a_curr_vec_in_AY_dqPE6 = 32'd34667; a_curr_vec_in_AZ_dqPE6 = 32'd136669; a_curr_vec_in_LX_dqPE6 = 32'd0; a_curr_vec_in_LY_dqPE6 = 32'd0; a_curr_vec_in_LZ_dqPE6 = 32'd0;
      v_prev_vec_in_AX_dqPE6 = 32'd0; v_prev_vec_in_AY_dqPE6 = 32'd0; v_prev_vec_in_AZ_dqPE6 = 32'd65530; v_prev_vec_in_LX_dqPE6 = 32'd0; v_prev_vec_in_LY_dqPE6 = 32'd0; v_prev_vec_in_LZ_dqPE6 = 32'd0;
      a_prev_vec_in_AX_dqPE6 = 32'd0; a_prev_vec_in_AY_dqPE6 = 32'd0; a_prev_vec_in_AZ_dqPE6 = 32'd43998; a_prev_vec_in_LX_dqPE6 = 32'd0; a_prev_vec_in_LY_dqPE6 = 32'd0; a_prev_vec_in_LZ_dqPE6 = 32'd0;
      // dqPE7
      link_in_dqPE7 = 3'd2;
      derv_in_dqPE7 = 3'd7;
      sinq_val_in_dqPE7 = 32'd24454; cosq_val_in_dqPE7 = 32'd60803;
      qd_val_in_dqPE7 = 32'd16493;
      v_curr_vec_in_AX_dqPE7 = 32'd24452; v_curr_vec_in_AY_dqPE7 = 32'd60797; v_curr_vec_in_AZ_dqPE7 = 32'd16493; v_curr_vec_in_LX_dqPE7 = 32'd0; v_curr_vec_in_LY_dqPE7 = 32'd0; v_curr_vec_in_LZ_dqPE7 = 32'd0;
      a_curr_vec_in_AX_dqPE7 = 32'd31718; a_curr_vec_in_AY_dqPE7 = 32'd34667; a_curr_vec_in_AZ_dqPE7 = 32'd136669; a_curr_vec_in_LX_dqPE7 = 32'd0; a_curr_vec_in_LY_dqPE7 = 32'd0; a_curr_vec_in_LZ_dqPE7 = 32'd0;
      v_prev_vec_in_AX_dqPE7 = 32'd0; v_prev_vec_in_AY_dqPE7 = 32'd0; v_prev_vec_in_AZ_dqPE7 = 32'd65530; v_prev_vec_in_LX_dqPE7 = 32'd0; v_prev_vec_in_LY_dqPE7 = 32'd0; v_prev_vec_in_LZ_dqPE7 = 32'd0;
      a_prev_vec_in_AX_dqPE7 = 32'd0; a_prev_vec_in_AY_dqPE7 = 32'd0; a_prev_vec_in_AZ_dqPE7 = 32'd43998; a_prev_vec_in_LX_dqPE7 = 32'd0; a_prev_vec_in_LY_dqPE7 = 32'd0; a_prev_vec_in_LZ_dqPE7 = 32'd0;
      // External dv,da
      // dqPE1
      dvdq_prev_vec_in_AX_dqPE1 = dvdq_curr_vec_reg_AX_dqPE1; dvdq_prev_vec_in_AY_dqPE1 = dvdq_curr_vec_reg_AY_dqPE1; dvdq_prev_vec_in_AZ_dqPE1 = dvdq_curr_vec_reg_AZ_dqPE1; dvdq_prev_vec_in_LX_dqPE1 = dvdq_curr_vec_reg_LX_dqPE1; dvdq_prev_vec_in_LY_dqPE1 = dvdq_curr_vec_reg_LY_dqPE1; dvdq_prev_vec_in_LZ_dqPE1 = dvdq_curr_vec_reg_LZ_dqPE1; 
      dadq_prev_vec_in_AX_dqPE1 = dadq_curr_vec_reg_AX_dqPE1; dadq_prev_vec_in_AY_dqPE1 = dadq_curr_vec_reg_AY_dqPE1; dadq_prev_vec_in_AZ_dqPE1 = dadq_curr_vec_reg_AZ_dqPE1; dadq_prev_vec_in_LX_dqPE1 = dadq_curr_vec_reg_LX_dqPE1; dadq_prev_vec_in_LY_dqPE1 = dadq_curr_vec_reg_LY_dqPE1; dadq_prev_vec_in_LZ_dqPE1 = dadq_curr_vec_reg_LZ_dqPE1; 
      // dqPE2
      dvdq_prev_vec_in_AX_dqPE2 = dvdq_curr_vec_reg_AX_dqPE2; dvdq_prev_vec_in_AY_dqPE2 = dvdq_curr_vec_reg_AY_dqPE2; dvdq_prev_vec_in_AZ_dqPE2 = dvdq_curr_vec_reg_AZ_dqPE2; dvdq_prev_vec_in_LX_dqPE2 = dvdq_curr_vec_reg_LX_dqPE2; dvdq_prev_vec_in_LY_dqPE2 = dvdq_curr_vec_reg_LY_dqPE2; dvdq_prev_vec_in_LZ_dqPE2 = dvdq_curr_vec_reg_LZ_dqPE2; 
      dadq_prev_vec_in_AX_dqPE2 = dadq_curr_vec_reg_AX_dqPE2; dadq_prev_vec_in_AY_dqPE2 = dadq_curr_vec_reg_AY_dqPE2; dadq_prev_vec_in_AZ_dqPE2 = dadq_curr_vec_reg_AZ_dqPE2; dadq_prev_vec_in_LX_dqPE2 = dadq_curr_vec_reg_LX_dqPE2; dadq_prev_vec_in_LY_dqPE2 = dadq_curr_vec_reg_LY_dqPE2; dadq_prev_vec_in_LZ_dqPE2 = dadq_curr_vec_reg_LZ_dqPE2; 
      // dqPE3
      dvdq_prev_vec_in_AX_dqPE3 = dvdq_curr_vec_reg_AX_dqPE3; dvdq_prev_vec_in_AY_dqPE3 = dvdq_curr_vec_reg_AY_dqPE3; dvdq_prev_vec_in_AZ_dqPE3 = dvdq_curr_vec_reg_AZ_dqPE3; dvdq_prev_vec_in_LX_dqPE3 = dvdq_curr_vec_reg_LX_dqPE3; dvdq_prev_vec_in_LY_dqPE3 = dvdq_curr_vec_reg_LY_dqPE3; dvdq_prev_vec_in_LZ_dqPE3 = dvdq_curr_vec_reg_LZ_dqPE3; 
      dadq_prev_vec_in_AX_dqPE3 = dadq_curr_vec_reg_AX_dqPE3; dadq_prev_vec_in_AY_dqPE3 = dadq_curr_vec_reg_AY_dqPE3; dadq_prev_vec_in_AZ_dqPE3 = dadq_curr_vec_reg_AZ_dqPE3; dadq_prev_vec_in_LX_dqPE3 = dadq_curr_vec_reg_LX_dqPE3; dadq_prev_vec_in_LY_dqPE3 = dadq_curr_vec_reg_LY_dqPE3; dadq_prev_vec_in_LZ_dqPE3 = dadq_curr_vec_reg_LZ_dqPE3; 
      // dqPE4
      dvdq_prev_vec_in_AX_dqPE4 = dvdq_curr_vec_reg_AX_dqPE4; dvdq_prev_vec_in_AY_dqPE4 = dvdq_curr_vec_reg_AY_dqPE4; dvdq_prev_vec_in_AZ_dqPE4 = dvdq_curr_vec_reg_AZ_dqPE4; dvdq_prev_vec_in_LX_dqPE4 = dvdq_curr_vec_reg_LX_dqPE4; dvdq_prev_vec_in_LY_dqPE4 = dvdq_curr_vec_reg_LY_dqPE4; dvdq_prev_vec_in_LZ_dqPE4 = dvdq_curr_vec_reg_LZ_dqPE4; 
      dadq_prev_vec_in_AX_dqPE4 = dadq_curr_vec_reg_AX_dqPE4; dadq_prev_vec_in_AY_dqPE4 = dadq_curr_vec_reg_AY_dqPE4; dadq_prev_vec_in_AZ_dqPE4 = dadq_curr_vec_reg_AZ_dqPE4; dadq_prev_vec_in_LX_dqPE4 = dadq_curr_vec_reg_LX_dqPE4; dadq_prev_vec_in_LY_dqPE4 = dadq_curr_vec_reg_LY_dqPE4; dadq_prev_vec_in_LZ_dqPE4 = dadq_curr_vec_reg_LZ_dqPE4; 
      // dqPE5
      dvdq_prev_vec_in_AX_dqPE5 = dvdq_curr_vec_reg_AX_dqPE5; dvdq_prev_vec_in_AY_dqPE5 = dvdq_curr_vec_reg_AY_dqPE5; dvdq_prev_vec_in_AZ_dqPE5 = dvdq_curr_vec_reg_AZ_dqPE5; dvdq_prev_vec_in_LX_dqPE5 = dvdq_curr_vec_reg_LX_dqPE5; dvdq_prev_vec_in_LY_dqPE5 = dvdq_curr_vec_reg_LY_dqPE5; dvdq_prev_vec_in_LZ_dqPE5 = dvdq_curr_vec_reg_LZ_dqPE5; 
      dadq_prev_vec_in_AX_dqPE5 = dadq_curr_vec_reg_AX_dqPE5; dadq_prev_vec_in_AY_dqPE5 = dadq_curr_vec_reg_AY_dqPE5; dadq_prev_vec_in_AZ_dqPE5 = dadq_curr_vec_reg_AZ_dqPE5; dadq_prev_vec_in_LX_dqPE5 = dadq_curr_vec_reg_LX_dqPE5; dadq_prev_vec_in_LY_dqPE5 = dadq_curr_vec_reg_LY_dqPE5; dadq_prev_vec_in_LZ_dqPE5 = dadq_curr_vec_reg_LZ_dqPE5; 
      // dqPE6
      dvdq_prev_vec_in_AX_dqPE6 = dvdq_curr_vec_reg_AX_dqPE6; dvdq_prev_vec_in_AY_dqPE6 = dvdq_curr_vec_reg_AY_dqPE6; dvdq_prev_vec_in_AZ_dqPE6 = dvdq_curr_vec_reg_AZ_dqPE6; dvdq_prev_vec_in_LX_dqPE6 = dvdq_curr_vec_reg_LX_dqPE6; dvdq_prev_vec_in_LY_dqPE6 = dvdq_curr_vec_reg_LY_dqPE6; dvdq_prev_vec_in_LZ_dqPE6 = dvdq_curr_vec_reg_LZ_dqPE6; 
      dadq_prev_vec_in_AX_dqPE6 = dadq_curr_vec_reg_AX_dqPE6; dadq_prev_vec_in_AY_dqPE6 = dadq_curr_vec_reg_AY_dqPE6; dadq_prev_vec_in_AZ_dqPE6 = dadq_curr_vec_reg_AZ_dqPE6; dadq_prev_vec_in_LX_dqPE6 = dadq_curr_vec_reg_LX_dqPE6; dadq_prev_vec_in_LY_dqPE6 = dadq_curr_vec_reg_LY_dqPE6; dadq_prev_vec_in_LZ_dqPE6 = dadq_curr_vec_reg_LZ_dqPE6; 
      // dqPE7
      dvdq_prev_vec_in_AX_dqPE7 = dvdq_curr_vec_reg_AX_dqPE7; dvdq_prev_vec_in_AY_dqPE7 = dvdq_curr_vec_reg_AY_dqPE7; dvdq_prev_vec_in_AZ_dqPE7 = dvdq_curr_vec_reg_AZ_dqPE7; dvdq_prev_vec_in_LX_dqPE7 = dvdq_curr_vec_reg_LX_dqPE7; dvdq_prev_vec_in_LY_dqPE7 = dvdq_curr_vec_reg_LY_dqPE7; dvdq_prev_vec_in_LZ_dqPE7 = dvdq_curr_vec_reg_LZ_dqPE7; 
      dadq_prev_vec_in_AX_dqPE7 = dadq_curr_vec_reg_AX_dqPE7; dadq_prev_vec_in_AY_dqPE7 = dadq_curr_vec_reg_AY_dqPE7; dadq_prev_vec_in_AZ_dqPE7 = dadq_curr_vec_reg_AZ_dqPE7; dadq_prev_vec_in_LX_dqPE7 = dadq_curr_vec_reg_LX_dqPE7; dadq_prev_vec_in_LY_dqPE7 = dadq_curr_vec_reg_LY_dqPE7; dadq_prev_vec_in_LZ_dqPE7 = dadq_curr_vec_reg_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 3'd2;
      derv_in_dqdPE1 = 3'd1;
      sinq_val_in_dqdPE1 = 32'd24454; cosq_val_in_dqdPE1 = 32'd60803;
      qd_val_in_dqdPE1 = 32'd16493;
      v_curr_vec_in_AX_dqdPE1 = 32'd24452; v_curr_vec_in_AY_dqdPE1 = 32'd60797; v_curr_vec_in_AZ_dqdPE1 = 32'd16493; v_curr_vec_in_LX_dqdPE1 = 32'd0; v_curr_vec_in_LY_dqdPE1 = 32'd0; v_curr_vec_in_LZ_dqdPE1 = 32'd0;
      a_curr_vec_in_AX_dqdPE1 = 32'd31718; a_curr_vec_in_AY_dqdPE1 = 32'd34667; a_curr_vec_in_AZ_dqdPE1 = 32'd136669; a_curr_vec_in_LX_dqdPE1 = 32'd0; a_curr_vec_in_LY_dqdPE1 = 32'd0; a_curr_vec_in_LZ_dqdPE1 = 32'd0;
      // dqdPE2
      link_in_dqdPE2 = 3'd2;
      derv_in_dqdPE2 = 3'd2;
      sinq_val_in_dqdPE2 = 32'd24454; cosq_val_in_dqdPE2 = 32'd60803;
      qd_val_in_dqdPE2 = 32'd16493;
      v_curr_vec_in_AX_dqdPE2 = 32'd24452; v_curr_vec_in_AY_dqdPE2 = 32'd60797; v_curr_vec_in_AZ_dqdPE2 = 32'd16493; v_curr_vec_in_LX_dqdPE2 = 32'd0; v_curr_vec_in_LY_dqdPE2 = 32'd0; v_curr_vec_in_LZ_dqdPE2 = 32'd0;
      a_curr_vec_in_AX_dqdPE2 = 32'd31718; a_curr_vec_in_AY_dqdPE2 = 32'd34667; a_curr_vec_in_AZ_dqdPE2 = 32'd136669; a_curr_vec_in_LX_dqdPE2 = 32'd0; a_curr_vec_in_LY_dqdPE2 = 32'd0; a_curr_vec_in_LZ_dqdPE2 = 32'd0;
      // dqdPE3
      link_in_dqdPE3 = 3'd2;
      derv_in_dqdPE3 = 3'd3;
      sinq_val_in_dqdPE3 = 32'd24454; cosq_val_in_dqdPE3 = 32'd60803;
      qd_val_in_dqdPE3 = 32'd16493;
      v_curr_vec_in_AX_dqdPE3 = 32'd24452; v_curr_vec_in_AY_dqdPE3 = 32'd60797; v_curr_vec_in_AZ_dqdPE3 = 32'd16493; v_curr_vec_in_LX_dqdPE3 = 32'd0; v_curr_vec_in_LY_dqdPE3 = 32'd0; v_curr_vec_in_LZ_dqdPE3 = 32'd0;
      a_curr_vec_in_AX_dqdPE3 = 32'd31718; a_curr_vec_in_AY_dqdPE3 = 32'd34667; a_curr_vec_in_AZ_dqdPE3 = 32'd136669; a_curr_vec_in_LX_dqdPE3 = 32'd0; a_curr_vec_in_LY_dqdPE3 = 32'd0; a_curr_vec_in_LZ_dqdPE3 = 32'd0;
      // dqdPE4
      link_in_dqdPE4 = 3'd2;
      derv_in_dqdPE4 = 3'd4;
      sinq_val_in_dqdPE4 = 32'd24454; cosq_val_in_dqdPE4 = 32'd60803;
      qd_val_in_dqdPE4 = 32'd16493;
      v_curr_vec_in_AX_dqdPE4 = 32'd24452; v_curr_vec_in_AY_dqdPE4 = 32'd60797; v_curr_vec_in_AZ_dqdPE4 = 32'd16493; v_curr_vec_in_LX_dqdPE4 = 32'd0; v_curr_vec_in_LY_dqdPE4 = 32'd0; v_curr_vec_in_LZ_dqdPE4 = 32'd0;
      a_curr_vec_in_AX_dqdPE4 = 32'd31718; a_curr_vec_in_AY_dqdPE4 = 32'd34667; a_curr_vec_in_AZ_dqdPE4 = 32'd136669; a_curr_vec_in_LX_dqdPE4 = 32'd0; a_curr_vec_in_LY_dqdPE4 = 32'd0; a_curr_vec_in_LZ_dqdPE4 = 32'd0;
      // dqdPE5
      link_in_dqdPE5 = 3'd2;
      derv_in_dqdPE5 = 3'd5;
      sinq_val_in_dqdPE5 = 32'd24454; cosq_val_in_dqdPE5 = 32'd60803;
      qd_val_in_dqdPE5 = 32'd16493;
      v_curr_vec_in_AX_dqdPE5 = 32'd24452; v_curr_vec_in_AY_dqdPE5 = 32'd60797; v_curr_vec_in_AZ_dqdPE5 = 32'd16493; v_curr_vec_in_LX_dqdPE5 = 32'd0; v_curr_vec_in_LY_dqdPE5 = 32'd0; v_curr_vec_in_LZ_dqdPE5 = 32'd0;
      a_curr_vec_in_AX_dqdPE5 = 32'd31718; a_curr_vec_in_AY_dqdPE5 = 32'd34667; a_curr_vec_in_AZ_dqdPE5 = 32'd136669; a_curr_vec_in_LX_dqdPE5 = 32'd0; a_curr_vec_in_LY_dqdPE5 = 32'd0; a_curr_vec_in_LZ_dqdPE5 = 32'd0;
      // dqdPE6
      link_in_dqdPE6 = 3'd2;
      derv_in_dqdPE6 = 3'd6;
      sinq_val_in_dqdPE6 = 32'd24454; cosq_val_in_dqdPE6 = 32'd60803;
      qd_val_in_dqdPE6 = 32'd16493;
      v_curr_vec_in_AX_dqdPE6 = 32'd24452; v_curr_vec_in_AY_dqdPE6 = 32'd60797; v_curr_vec_in_AZ_dqdPE6 = 32'd16493; v_curr_vec_in_LX_dqdPE6 = 32'd0; v_curr_vec_in_LY_dqdPE6 = 32'd0; v_curr_vec_in_LZ_dqdPE6 = 32'd0;
      a_curr_vec_in_AX_dqdPE6 = 32'd31718; a_curr_vec_in_AY_dqdPE6 = 32'd34667; a_curr_vec_in_AZ_dqdPE6 = 32'd136669; a_curr_vec_in_LX_dqdPE6 = 32'd0; a_curr_vec_in_LY_dqdPE6 = 32'd0; a_curr_vec_in_LZ_dqdPE6 = 32'd0;
      // dqdPE7
      link_in_dqdPE7 = 3'd2;
      derv_in_dqdPE7 = 3'd7;
      sinq_val_in_dqdPE7 = 32'd24454; cosq_val_in_dqdPE7 = 32'd60803;
      qd_val_in_dqdPE7 = 32'd16493;
      v_curr_vec_in_AX_dqdPE7 = 32'd24452; v_curr_vec_in_AY_dqdPE7 = 32'd60797; v_curr_vec_in_AZ_dqdPE7 = 32'd16493; v_curr_vec_in_LX_dqdPE7 = 32'd0; v_curr_vec_in_LY_dqdPE7 = 32'd0; v_curr_vec_in_LZ_dqdPE7 = 32'd0;
      a_curr_vec_in_AX_dqdPE7 = 32'd31718; a_curr_vec_in_AY_dqdPE7 = 32'd34667; a_curr_vec_in_AZ_dqdPE7 = 32'd136669; a_curr_vec_in_LX_dqdPE7 = 32'd0; a_curr_vec_in_LY_dqdPE7 = 32'd0; a_curr_vec_in_LZ_dqdPE7 = 32'd0;
      // External dv,da
      // dqdPE1
      dvdqd_prev_vec_in_AX_dqdPE1 = dvdqd_curr_vec_reg_AX_dqdPE1; dvdqd_prev_vec_in_AY_dqdPE1 = dvdqd_curr_vec_reg_AY_dqdPE1; dvdqd_prev_vec_in_AZ_dqdPE1 = dvdqd_curr_vec_reg_AZ_dqdPE1; dvdqd_prev_vec_in_LX_dqdPE1 = dvdqd_curr_vec_reg_LX_dqdPE1; dvdqd_prev_vec_in_LY_dqdPE1 = dvdqd_curr_vec_reg_LY_dqdPE1; dvdqd_prev_vec_in_LZ_dqdPE1 = dvdqd_curr_vec_reg_LZ_dqdPE1; 
      dadqd_prev_vec_in_AX_dqdPE1 = dadqd_curr_vec_reg_AX_dqdPE1; dadqd_prev_vec_in_AY_dqdPE1 = dadqd_curr_vec_reg_AY_dqdPE1; dadqd_prev_vec_in_AZ_dqdPE1 = dadqd_curr_vec_reg_AZ_dqdPE1; dadqd_prev_vec_in_LX_dqdPE1 = dadqd_curr_vec_reg_LX_dqdPE1; dadqd_prev_vec_in_LY_dqdPE1 = dadqd_curr_vec_reg_LY_dqdPE1; dadqd_prev_vec_in_LZ_dqdPE1 = dadqd_curr_vec_reg_LZ_dqdPE1; 
      // dqdPE2
      dvdqd_prev_vec_in_AX_dqdPE2 = dvdqd_curr_vec_reg_AX_dqdPE2; dvdqd_prev_vec_in_AY_dqdPE2 = dvdqd_curr_vec_reg_AY_dqdPE2; dvdqd_prev_vec_in_AZ_dqdPE2 = dvdqd_curr_vec_reg_AZ_dqdPE2; dvdqd_prev_vec_in_LX_dqdPE2 = dvdqd_curr_vec_reg_LX_dqdPE2; dvdqd_prev_vec_in_LY_dqdPE2 = dvdqd_curr_vec_reg_LY_dqdPE2; dvdqd_prev_vec_in_LZ_dqdPE2 = dvdqd_curr_vec_reg_LZ_dqdPE2; 
      dadqd_prev_vec_in_AX_dqdPE2 = dadqd_curr_vec_reg_AX_dqdPE2; dadqd_prev_vec_in_AY_dqdPE2 = dadqd_curr_vec_reg_AY_dqdPE2; dadqd_prev_vec_in_AZ_dqdPE2 = dadqd_curr_vec_reg_AZ_dqdPE2; dadqd_prev_vec_in_LX_dqdPE2 = dadqd_curr_vec_reg_LX_dqdPE2; dadqd_prev_vec_in_LY_dqdPE2 = dadqd_curr_vec_reg_LY_dqdPE2; dadqd_prev_vec_in_LZ_dqdPE2 = dadqd_curr_vec_reg_LZ_dqdPE2; 
      // dqdPE3
      dvdqd_prev_vec_in_AX_dqdPE3 = dvdqd_curr_vec_reg_AX_dqdPE3; dvdqd_prev_vec_in_AY_dqdPE3 = dvdqd_curr_vec_reg_AY_dqdPE3; dvdqd_prev_vec_in_AZ_dqdPE3 = dvdqd_curr_vec_reg_AZ_dqdPE3; dvdqd_prev_vec_in_LX_dqdPE3 = dvdqd_curr_vec_reg_LX_dqdPE3; dvdqd_prev_vec_in_LY_dqdPE3 = dvdqd_curr_vec_reg_LY_dqdPE3; dvdqd_prev_vec_in_LZ_dqdPE3 = dvdqd_curr_vec_reg_LZ_dqdPE3; 
      dadqd_prev_vec_in_AX_dqdPE3 = dadqd_curr_vec_reg_AX_dqdPE3; dadqd_prev_vec_in_AY_dqdPE3 = dadqd_curr_vec_reg_AY_dqdPE3; dadqd_prev_vec_in_AZ_dqdPE3 = dadqd_curr_vec_reg_AZ_dqdPE3; dadqd_prev_vec_in_LX_dqdPE3 = dadqd_curr_vec_reg_LX_dqdPE3; dadqd_prev_vec_in_LY_dqdPE3 = dadqd_curr_vec_reg_LY_dqdPE3; dadqd_prev_vec_in_LZ_dqdPE3 = dadqd_curr_vec_reg_LZ_dqdPE3; 
      // dqdPE4
      dvdqd_prev_vec_in_AX_dqdPE4 = dvdqd_curr_vec_reg_AX_dqdPE4; dvdqd_prev_vec_in_AY_dqdPE4 = dvdqd_curr_vec_reg_AY_dqdPE4; dvdqd_prev_vec_in_AZ_dqdPE4 = dvdqd_curr_vec_reg_AZ_dqdPE4; dvdqd_prev_vec_in_LX_dqdPE4 = dvdqd_curr_vec_reg_LX_dqdPE4; dvdqd_prev_vec_in_LY_dqdPE4 = dvdqd_curr_vec_reg_LY_dqdPE4; dvdqd_prev_vec_in_LZ_dqdPE4 = dvdqd_curr_vec_reg_LZ_dqdPE4; 
      dadqd_prev_vec_in_AX_dqdPE4 = dadqd_curr_vec_reg_AX_dqdPE4; dadqd_prev_vec_in_AY_dqdPE4 = dadqd_curr_vec_reg_AY_dqdPE4; dadqd_prev_vec_in_AZ_dqdPE4 = dadqd_curr_vec_reg_AZ_dqdPE4; dadqd_prev_vec_in_LX_dqdPE4 = dadqd_curr_vec_reg_LX_dqdPE4; dadqd_prev_vec_in_LY_dqdPE4 = dadqd_curr_vec_reg_LY_dqdPE4; dadqd_prev_vec_in_LZ_dqdPE4 = dadqd_curr_vec_reg_LZ_dqdPE4; 
      // dqdPE5
      dvdqd_prev_vec_in_AX_dqdPE5 = dvdqd_curr_vec_reg_AX_dqdPE5; dvdqd_prev_vec_in_AY_dqdPE5 = dvdqd_curr_vec_reg_AY_dqdPE5; dvdqd_prev_vec_in_AZ_dqdPE5 = dvdqd_curr_vec_reg_AZ_dqdPE5; dvdqd_prev_vec_in_LX_dqdPE5 = dvdqd_curr_vec_reg_LX_dqdPE5; dvdqd_prev_vec_in_LY_dqdPE5 = dvdqd_curr_vec_reg_LY_dqdPE5; dvdqd_prev_vec_in_LZ_dqdPE5 = dvdqd_curr_vec_reg_LZ_dqdPE5; 
      dadqd_prev_vec_in_AX_dqdPE5 = dadqd_curr_vec_reg_AX_dqdPE5; dadqd_prev_vec_in_AY_dqdPE5 = dadqd_curr_vec_reg_AY_dqdPE5; dadqd_prev_vec_in_AZ_dqdPE5 = dadqd_curr_vec_reg_AZ_dqdPE5; dadqd_prev_vec_in_LX_dqdPE5 = dadqd_curr_vec_reg_LX_dqdPE5; dadqd_prev_vec_in_LY_dqdPE5 = dadqd_curr_vec_reg_LY_dqdPE5; dadqd_prev_vec_in_LZ_dqdPE5 = dadqd_curr_vec_reg_LZ_dqdPE5; 
      // dqdPE6
      dvdqd_prev_vec_in_AX_dqdPE6 = dvdqd_curr_vec_reg_AX_dqdPE6; dvdqd_prev_vec_in_AY_dqdPE6 = dvdqd_curr_vec_reg_AY_dqdPE6; dvdqd_prev_vec_in_AZ_dqdPE6 = dvdqd_curr_vec_reg_AZ_dqdPE6; dvdqd_prev_vec_in_LX_dqdPE6 = dvdqd_curr_vec_reg_LX_dqdPE6; dvdqd_prev_vec_in_LY_dqdPE6 = dvdqd_curr_vec_reg_LY_dqdPE6; dvdqd_prev_vec_in_LZ_dqdPE6 = dvdqd_curr_vec_reg_LZ_dqdPE6; 
      dadqd_prev_vec_in_AX_dqdPE6 = dadqd_curr_vec_reg_AX_dqdPE6; dadqd_prev_vec_in_AY_dqdPE6 = dadqd_curr_vec_reg_AY_dqdPE6; dadqd_prev_vec_in_AZ_dqdPE6 = dadqd_curr_vec_reg_AZ_dqdPE6; dadqd_prev_vec_in_LX_dqdPE6 = dadqd_curr_vec_reg_LX_dqdPE6; dadqd_prev_vec_in_LY_dqdPE6 = dadqd_curr_vec_reg_LY_dqdPE6; dadqd_prev_vec_in_LZ_dqdPE6 = dadqd_curr_vec_reg_LZ_dqdPE6; 
      // dqdPE7
      dvdqd_prev_vec_in_AX_dqdPE7 = dvdqd_curr_vec_reg_AX_dqdPE7; dvdqd_prev_vec_in_AY_dqdPE7 = dvdqd_curr_vec_reg_AY_dqdPE7; dvdqd_prev_vec_in_AZ_dqdPE7 = dvdqd_curr_vec_reg_AZ_dqdPE7; dvdqd_prev_vec_in_LX_dqdPE7 = dvdqd_curr_vec_reg_LX_dqdPE7; dvdqd_prev_vec_in_LY_dqdPE7 = dvdqd_curr_vec_reg_LY_dqdPE7; dvdqd_prev_vec_in_LZ_dqdPE7 = dvdqd_curr_vec_reg_LZ_dqdPE7; 
      dadqd_prev_vec_in_AX_dqdPE7 = dadqd_curr_vec_reg_AX_dqdPE7; dadqd_prev_vec_in_AY_dqdPE7 = dadqd_curr_vec_reg_AY_dqdPE7; dadqd_prev_vec_in_AZ_dqdPE7 = dadqd_curr_vec_reg_AZ_dqdPE7; dadqd_prev_vec_in_LX_dqdPE7 = dadqd_curr_vec_reg_LX_dqdPE7; dadqd_prev_vec_in_LY_dqdPE7 = dadqd_curr_vec_reg_LY_dqdPE7; dadqd_prev_vec_in_LZ_dqdPE7 = dadqd_curr_vec_reg_LZ_dqdPE7; 
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
      $display ("// Link 3 RNEA");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-19396, 14507, -2367, 70323, 80557, -22634);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_curr_vec_out_AX_rnea,f_curr_vec_out_AY_rnea,f_curr_vec_out_AZ_rnea,f_curr_vec_out_LX_rnea,f_curr_vec_out_LY_rnea,f_curr_vec_out_LZ_rnea);
      $display ("//-------------------------------------------------------------------------------------------------------");
      $display ("// Link 2 Derivatives");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 2709, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -126, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2017, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 8454, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -17508, 0, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 6786, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AX_dqPE1,dfdq_curr_vec_out_AX_dqPE2,dfdq_curr_vec_out_AX_dqPE3,dfdq_curr_vec_out_AX_dqPE4,dfdq_curr_vec_out_AX_dqPE5,dfdq_curr_vec_out_AX_dqPE6,dfdq_curr_vec_out_AX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AY_dqPE1,dfdq_curr_vec_out_AY_dqPE2,dfdq_curr_vec_out_AY_dqPE3,dfdq_curr_vec_out_AY_dqPE4,dfdq_curr_vec_out_AY_dqPE5,dfdq_curr_vec_out_AY_dqPE6,dfdq_curr_vec_out_AY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AZ_dqPE1,dfdq_curr_vec_out_AZ_dqPE2,dfdq_curr_vec_out_AZ_dqPE3,dfdq_curr_vec_out_AZ_dqPE4,dfdq_curr_vec_out_AZ_dqPE5,dfdq_curr_vec_out_AZ_dqPE6,dfdq_curr_vec_out_AZ_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LX_dqPE1,dfdq_curr_vec_out_LX_dqPE2,dfdq_curr_vec_out_LX_dqPE3,dfdq_curr_vec_out_LX_dqPE4,dfdq_curr_vec_out_LX_dqPE5,dfdq_curr_vec_out_LX_dqPE6,dfdq_curr_vec_out_LX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LY_dqPE1,dfdq_curr_vec_out_LY_dqPE2,dfdq_curr_vec_out_LY_dqPE3,dfdq_curr_vec_out_LY_dqPE4,dfdq_curr_vec_out_LY_dqPE5,dfdq_curr_vec_out_LY_dqPE6,dfdq_curr_vec_out_LY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LZ_dqPE1,dfdq_curr_vec_out_LZ_dqPE2,dfdq_curr_vec_out_LZ_dqPE3,dfdq_curr_vec_out_LZ_dqPE4,dfdq_curr_vec_out_LZ_dqPE5,dfdq_curr_vec_out_LZ_dqPE6,dfdq_curr_vec_out_LZ_dqPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 469, 6644, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 375, -304, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2077, 0, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 10572, -40, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -4252, -7785, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -14781, 28755, 0, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AX_dqdPE1,dfdqd_curr_vec_out_AX_dqdPE2,dfdqd_curr_vec_out_AX_dqdPE3,dfdqd_curr_vec_out_AX_dqdPE4,dfdqd_curr_vec_out_AX_dqdPE5,dfdqd_curr_vec_out_AX_dqdPE6,dfdqd_curr_vec_out_AX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AY_dqdPE1,dfdqd_curr_vec_out_AY_dqdPE2,dfdqd_curr_vec_out_AY_dqdPE3,dfdqd_curr_vec_out_AY_dqdPE4,dfdqd_curr_vec_out_AY_dqdPE5,dfdqd_curr_vec_out_AY_dqdPE6,dfdqd_curr_vec_out_AY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AZ_dqdPE1,dfdqd_curr_vec_out_AZ_dqdPE2,dfdqd_curr_vec_out_AZ_dqdPE3,dfdqd_curr_vec_out_AZ_dqdPE4,dfdqd_curr_vec_out_AZ_dqdPE5,dfdqd_curr_vec_out_AZ_dqdPE6,dfdqd_curr_vec_out_AZ_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LX_dqdPE1,dfdqd_curr_vec_out_LX_dqdPE2,dfdqd_curr_vec_out_LX_dqdPE3,dfdqd_curr_vec_out_LX_dqdPE4,dfdqd_curr_vec_out_LX_dqdPE5,dfdqd_curr_vec_out_LX_dqdPE6,dfdqd_curr_vec_out_LX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LY_dqdPE1,dfdqd_curr_vec_out_LY_dqdPE2,dfdqd_curr_vec_out_LY_dqdPE3,dfdqd_curr_vec_out_LY_dqdPE4,dfdqd_curr_vec_out_LY_dqdPE5,dfdqd_curr_vec_out_LY_dqdPE6,dfdqd_curr_vec_out_LY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LZ_dqdPE1,dfdqd_curr_vec_out_LZ_dqdPE2,dfdqd_curr_vec_out_LZ_dqdPE3,dfdqd_curr_vec_out_LZ_dqdPE4,dfdqd_curr_vec_out_LZ_dqdPE5,dfdqd_curr_vec_out_LZ_dqdPE6,dfdqd_curr_vec_out_LZ_dqdPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External dv,da
      //------------------------------------------------------------------------
      // dqPE1
      dvdq_curr_vec_reg_AX_dqPE1 = dvdq_curr_vec_out_AX_dqPE1; dvdq_curr_vec_reg_AY_dqPE1 = dvdq_curr_vec_out_AY_dqPE1; dvdq_curr_vec_reg_AZ_dqPE1 = dvdq_curr_vec_out_AZ_dqPE1; dvdq_curr_vec_reg_LX_dqPE1 = dvdq_curr_vec_out_LX_dqPE1; dvdq_curr_vec_reg_LY_dqPE1 = dvdq_curr_vec_out_LY_dqPE1; dvdq_curr_vec_reg_LZ_dqPE1 = dvdq_curr_vec_out_LZ_dqPE1; 
      dadq_curr_vec_reg_AX_dqPE1 = dadq_curr_vec_out_AX_dqPE1; dadq_curr_vec_reg_AY_dqPE1 = dadq_curr_vec_out_AY_dqPE1; dadq_curr_vec_reg_AZ_dqPE1 = dadq_curr_vec_out_AZ_dqPE1; dadq_curr_vec_reg_LX_dqPE1 = dadq_curr_vec_out_LX_dqPE1; dadq_curr_vec_reg_LY_dqPE1 = dadq_curr_vec_out_LY_dqPE1; dadq_curr_vec_reg_LZ_dqPE1 = dadq_curr_vec_out_LZ_dqPE1; 
      // dqPE2
      dvdq_curr_vec_reg_AX_dqPE2 = dvdq_curr_vec_out_AX_dqPE2; dvdq_curr_vec_reg_AY_dqPE2 = dvdq_curr_vec_out_AY_dqPE2; dvdq_curr_vec_reg_AZ_dqPE2 = dvdq_curr_vec_out_AZ_dqPE2; dvdq_curr_vec_reg_LX_dqPE2 = dvdq_curr_vec_out_LX_dqPE2; dvdq_curr_vec_reg_LY_dqPE2 = dvdq_curr_vec_out_LY_dqPE2; dvdq_curr_vec_reg_LZ_dqPE2 = dvdq_curr_vec_out_LZ_dqPE2; 
      dadq_curr_vec_reg_AX_dqPE2 = dadq_curr_vec_out_AX_dqPE2; dadq_curr_vec_reg_AY_dqPE2 = dadq_curr_vec_out_AY_dqPE2; dadq_curr_vec_reg_AZ_dqPE2 = dadq_curr_vec_out_AZ_dqPE2; dadq_curr_vec_reg_LX_dqPE2 = dadq_curr_vec_out_LX_dqPE2; dadq_curr_vec_reg_LY_dqPE2 = dadq_curr_vec_out_LY_dqPE2; dadq_curr_vec_reg_LZ_dqPE2 = dadq_curr_vec_out_LZ_dqPE2; 
      // dqPE3
      dvdq_curr_vec_reg_AX_dqPE3 = dvdq_curr_vec_out_AX_dqPE3; dvdq_curr_vec_reg_AY_dqPE3 = dvdq_curr_vec_out_AY_dqPE3; dvdq_curr_vec_reg_AZ_dqPE3 = dvdq_curr_vec_out_AZ_dqPE3; dvdq_curr_vec_reg_LX_dqPE3 = dvdq_curr_vec_out_LX_dqPE3; dvdq_curr_vec_reg_LY_dqPE3 = dvdq_curr_vec_out_LY_dqPE3; dvdq_curr_vec_reg_LZ_dqPE3 = dvdq_curr_vec_out_LZ_dqPE3; 
      dadq_curr_vec_reg_AX_dqPE3 = dadq_curr_vec_out_AX_dqPE3; dadq_curr_vec_reg_AY_dqPE3 = dadq_curr_vec_out_AY_dqPE3; dadq_curr_vec_reg_AZ_dqPE3 = dadq_curr_vec_out_AZ_dqPE3; dadq_curr_vec_reg_LX_dqPE3 = dadq_curr_vec_out_LX_dqPE3; dadq_curr_vec_reg_LY_dqPE3 = dadq_curr_vec_out_LY_dqPE3; dadq_curr_vec_reg_LZ_dqPE3 = dadq_curr_vec_out_LZ_dqPE3; 
      // dqPE4
      dvdq_curr_vec_reg_AX_dqPE4 = dvdq_curr_vec_out_AX_dqPE4; dvdq_curr_vec_reg_AY_dqPE4 = dvdq_curr_vec_out_AY_dqPE4; dvdq_curr_vec_reg_AZ_dqPE4 = dvdq_curr_vec_out_AZ_dqPE4; dvdq_curr_vec_reg_LX_dqPE4 = dvdq_curr_vec_out_LX_dqPE4; dvdq_curr_vec_reg_LY_dqPE4 = dvdq_curr_vec_out_LY_dqPE4; dvdq_curr_vec_reg_LZ_dqPE4 = dvdq_curr_vec_out_LZ_dqPE4; 
      dadq_curr_vec_reg_AX_dqPE4 = dadq_curr_vec_out_AX_dqPE4; dadq_curr_vec_reg_AY_dqPE4 = dadq_curr_vec_out_AY_dqPE4; dadq_curr_vec_reg_AZ_dqPE4 = dadq_curr_vec_out_AZ_dqPE4; dadq_curr_vec_reg_LX_dqPE4 = dadq_curr_vec_out_LX_dqPE4; dadq_curr_vec_reg_LY_dqPE4 = dadq_curr_vec_out_LY_dqPE4; dadq_curr_vec_reg_LZ_dqPE4 = dadq_curr_vec_out_LZ_dqPE4; 
      // dqPE5
      dvdq_curr_vec_reg_AX_dqPE5 = dvdq_curr_vec_out_AX_dqPE5; dvdq_curr_vec_reg_AY_dqPE5 = dvdq_curr_vec_out_AY_dqPE5; dvdq_curr_vec_reg_AZ_dqPE5 = dvdq_curr_vec_out_AZ_dqPE5; dvdq_curr_vec_reg_LX_dqPE5 = dvdq_curr_vec_out_LX_dqPE5; dvdq_curr_vec_reg_LY_dqPE5 = dvdq_curr_vec_out_LY_dqPE5; dvdq_curr_vec_reg_LZ_dqPE5 = dvdq_curr_vec_out_LZ_dqPE5; 
      dadq_curr_vec_reg_AX_dqPE5 = dadq_curr_vec_out_AX_dqPE5; dadq_curr_vec_reg_AY_dqPE5 = dadq_curr_vec_out_AY_dqPE5; dadq_curr_vec_reg_AZ_dqPE5 = dadq_curr_vec_out_AZ_dqPE5; dadq_curr_vec_reg_LX_dqPE5 = dadq_curr_vec_out_LX_dqPE5; dadq_curr_vec_reg_LY_dqPE5 = dadq_curr_vec_out_LY_dqPE5; dadq_curr_vec_reg_LZ_dqPE5 = dadq_curr_vec_out_LZ_dqPE5; 
      // dqPE6
      dvdq_curr_vec_reg_AX_dqPE6 = dvdq_curr_vec_out_AX_dqPE6; dvdq_curr_vec_reg_AY_dqPE6 = dvdq_curr_vec_out_AY_dqPE6; dvdq_curr_vec_reg_AZ_dqPE6 = dvdq_curr_vec_out_AZ_dqPE6; dvdq_curr_vec_reg_LX_dqPE6 = dvdq_curr_vec_out_LX_dqPE6; dvdq_curr_vec_reg_LY_dqPE6 = dvdq_curr_vec_out_LY_dqPE6; dvdq_curr_vec_reg_LZ_dqPE6 = dvdq_curr_vec_out_LZ_dqPE6; 
      dadq_curr_vec_reg_AX_dqPE6 = dadq_curr_vec_out_AX_dqPE6; dadq_curr_vec_reg_AY_dqPE6 = dadq_curr_vec_out_AY_dqPE6; dadq_curr_vec_reg_AZ_dqPE6 = dadq_curr_vec_out_AZ_dqPE6; dadq_curr_vec_reg_LX_dqPE6 = dadq_curr_vec_out_LX_dqPE6; dadq_curr_vec_reg_LY_dqPE6 = dadq_curr_vec_out_LY_dqPE6; dadq_curr_vec_reg_LZ_dqPE6 = dadq_curr_vec_out_LZ_dqPE6; 
      // dqPE7
      dvdq_curr_vec_reg_AX_dqPE7 = dvdq_curr_vec_out_AX_dqPE7; dvdq_curr_vec_reg_AY_dqPE7 = dvdq_curr_vec_out_AY_dqPE7; dvdq_curr_vec_reg_AZ_dqPE7 = dvdq_curr_vec_out_AZ_dqPE7; dvdq_curr_vec_reg_LX_dqPE7 = dvdq_curr_vec_out_LX_dqPE7; dvdq_curr_vec_reg_LY_dqPE7 = dvdq_curr_vec_out_LY_dqPE7; dvdq_curr_vec_reg_LZ_dqPE7 = dvdq_curr_vec_out_LZ_dqPE7; 
      dadq_curr_vec_reg_AX_dqPE7 = dadq_curr_vec_out_AX_dqPE7; dadq_curr_vec_reg_AY_dqPE7 = dadq_curr_vec_out_AY_dqPE7; dadq_curr_vec_reg_AZ_dqPE7 = dadq_curr_vec_out_AZ_dqPE7; dadq_curr_vec_reg_LX_dqPE7 = dadq_curr_vec_out_LX_dqPE7; dadq_curr_vec_reg_LY_dqPE7 = dadq_curr_vec_out_LY_dqPE7; dadq_curr_vec_reg_LZ_dqPE7 = dadq_curr_vec_out_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqdPE1
      dvdqd_curr_vec_reg_AX_dqdPE1 = dvdqd_curr_vec_out_AX_dqdPE1; dvdqd_curr_vec_reg_AY_dqdPE1 = dvdqd_curr_vec_out_AY_dqdPE1; dvdqd_curr_vec_reg_AZ_dqdPE1 = dvdqd_curr_vec_out_AZ_dqdPE1; dvdqd_curr_vec_reg_LX_dqdPE1 = dvdqd_curr_vec_out_LX_dqdPE1; dvdqd_curr_vec_reg_LY_dqdPE1 = dvdqd_curr_vec_out_LY_dqdPE1; dvdqd_curr_vec_reg_LZ_dqdPE1 = dvdqd_curr_vec_out_LZ_dqdPE1; 
      dadqd_curr_vec_reg_AX_dqdPE1 = dadqd_curr_vec_out_AX_dqdPE1; dadqd_curr_vec_reg_AY_dqdPE1 = dadqd_curr_vec_out_AY_dqdPE1; dadqd_curr_vec_reg_AZ_dqdPE1 = dadqd_curr_vec_out_AZ_dqdPE1; dadqd_curr_vec_reg_LX_dqdPE1 = dadqd_curr_vec_out_LX_dqdPE1; dadqd_curr_vec_reg_LY_dqdPE1 = dadqd_curr_vec_out_LY_dqdPE1; dadqd_curr_vec_reg_LZ_dqdPE1 = dadqd_curr_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dvdqd_curr_vec_reg_AX_dqdPE2 = dvdqd_curr_vec_out_AX_dqdPE2; dvdqd_curr_vec_reg_AY_dqdPE2 = dvdqd_curr_vec_out_AY_dqdPE2; dvdqd_curr_vec_reg_AZ_dqdPE2 = dvdqd_curr_vec_out_AZ_dqdPE2; dvdqd_curr_vec_reg_LX_dqdPE2 = dvdqd_curr_vec_out_LX_dqdPE2; dvdqd_curr_vec_reg_LY_dqdPE2 = dvdqd_curr_vec_out_LY_dqdPE2; dvdqd_curr_vec_reg_LZ_dqdPE2 = dvdqd_curr_vec_out_LZ_dqdPE2; 
      dadqd_curr_vec_reg_AX_dqdPE2 = dadqd_curr_vec_out_AX_dqdPE2; dadqd_curr_vec_reg_AY_dqdPE2 = dadqd_curr_vec_out_AY_dqdPE2; dadqd_curr_vec_reg_AZ_dqdPE2 = dadqd_curr_vec_out_AZ_dqdPE2; dadqd_curr_vec_reg_LX_dqdPE2 = dadqd_curr_vec_out_LX_dqdPE2; dadqd_curr_vec_reg_LY_dqdPE2 = dadqd_curr_vec_out_LY_dqdPE2; dadqd_curr_vec_reg_LZ_dqdPE2 = dadqd_curr_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dvdqd_curr_vec_reg_AX_dqdPE3 = dvdqd_curr_vec_out_AX_dqdPE3; dvdqd_curr_vec_reg_AY_dqdPE3 = dvdqd_curr_vec_out_AY_dqdPE3; dvdqd_curr_vec_reg_AZ_dqdPE3 = dvdqd_curr_vec_out_AZ_dqdPE3; dvdqd_curr_vec_reg_LX_dqdPE3 = dvdqd_curr_vec_out_LX_dqdPE3; dvdqd_curr_vec_reg_LY_dqdPE3 = dvdqd_curr_vec_out_LY_dqdPE3; dvdqd_curr_vec_reg_LZ_dqdPE3 = dvdqd_curr_vec_out_LZ_dqdPE3; 
      dadqd_curr_vec_reg_AX_dqdPE3 = dadqd_curr_vec_out_AX_dqdPE3; dadqd_curr_vec_reg_AY_dqdPE3 = dadqd_curr_vec_out_AY_dqdPE3; dadqd_curr_vec_reg_AZ_dqdPE3 = dadqd_curr_vec_out_AZ_dqdPE3; dadqd_curr_vec_reg_LX_dqdPE3 = dadqd_curr_vec_out_LX_dqdPE3; dadqd_curr_vec_reg_LY_dqdPE3 = dadqd_curr_vec_out_LY_dqdPE3; dadqd_curr_vec_reg_LZ_dqdPE3 = dadqd_curr_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dvdqd_curr_vec_reg_AX_dqdPE4 = dvdqd_curr_vec_out_AX_dqdPE4; dvdqd_curr_vec_reg_AY_dqdPE4 = dvdqd_curr_vec_out_AY_dqdPE4; dvdqd_curr_vec_reg_AZ_dqdPE4 = dvdqd_curr_vec_out_AZ_dqdPE4; dvdqd_curr_vec_reg_LX_dqdPE4 = dvdqd_curr_vec_out_LX_dqdPE4; dvdqd_curr_vec_reg_LY_dqdPE4 = dvdqd_curr_vec_out_LY_dqdPE4; dvdqd_curr_vec_reg_LZ_dqdPE4 = dvdqd_curr_vec_out_LZ_dqdPE4; 
      dadqd_curr_vec_reg_AX_dqdPE4 = dadqd_curr_vec_out_AX_dqdPE4; dadqd_curr_vec_reg_AY_dqdPE4 = dadqd_curr_vec_out_AY_dqdPE4; dadqd_curr_vec_reg_AZ_dqdPE4 = dadqd_curr_vec_out_AZ_dqdPE4; dadqd_curr_vec_reg_LX_dqdPE4 = dadqd_curr_vec_out_LX_dqdPE4; dadqd_curr_vec_reg_LY_dqdPE4 = dadqd_curr_vec_out_LY_dqdPE4; dadqd_curr_vec_reg_LZ_dqdPE4 = dadqd_curr_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dvdqd_curr_vec_reg_AX_dqdPE5 = dvdqd_curr_vec_out_AX_dqdPE5; dvdqd_curr_vec_reg_AY_dqdPE5 = dvdqd_curr_vec_out_AY_dqdPE5; dvdqd_curr_vec_reg_AZ_dqdPE5 = dvdqd_curr_vec_out_AZ_dqdPE5; dvdqd_curr_vec_reg_LX_dqdPE5 = dvdqd_curr_vec_out_LX_dqdPE5; dvdqd_curr_vec_reg_LY_dqdPE5 = dvdqd_curr_vec_out_LY_dqdPE5; dvdqd_curr_vec_reg_LZ_dqdPE5 = dvdqd_curr_vec_out_LZ_dqdPE5; 
      dadqd_curr_vec_reg_AX_dqdPE5 = dadqd_curr_vec_out_AX_dqdPE5; dadqd_curr_vec_reg_AY_dqdPE5 = dadqd_curr_vec_out_AY_dqdPE5; dadqd_curr_vec_reg_AZ_dqdPE5 = dadqd_curr_vec_out_AZ_dqdPE5; dadqd_curr_vec_reg_LX_dqdPE5 = dadqd_curr_vec_out_LX_dqdPE5; dadqd_curr_vec_reg_LY_dqdPE5 = dadqd_curr_vec_out_LY_dqdPE5; dadqd_curr_vec_reg_LZ_dqdPE5 = dadqd_curr_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dvdqd_curr_vec_reg_AX_dqdPE6 = dvdqd_curr_vec_out_AX_dqdPE6; dvdqd_curr_vec_reg_AY_dqdPE6 = dvdqd_curr_vec_out_AY_dqdPE6; dvdqd_curr_vec_reg_AZ_dqdPE6 = dvdqd_curr_vec_out_AZ_dqdPE6; dvdqd_curr_vec_reg_LX_dqdPE6 = dvdqd_curr_vec_out_LX_dqdPE6; dvdqd_curr_vec_reg_LY_dqdPE6 = dvdqd_curr_vec_out_LY_dqdPE6; dvdqd_curr_vec_reg_LZ_dqdPE6 = dvdqd_curr_vec_out_LZ_dqdPE6; 
      dadqd_curr_vec_reg_AX_dqdPE6 = dadqd_curr_vec_out_AX_dqdPE6; dadqd_curr_vec_reg_AY_dqdPE6 = dadqd_curr_vec_out_AY_dqdPE6; dadqd_curr_vec_reg_AZ_dqdPE6 = dadqd_curr_vec_out_AZ_dqdPE6; dadqd_curr_vec_reg_LX_dqdPE6 = dadqd_curr_vec_out_LX_dqdPE6; dadqd_curr_vec_reg_LY_dqdPE6 = dadqd_curr_vec_out_LY_dqdPE6; dadqd_curr_vec_reg_LZ_dqdPE6 = dadqd_curr_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dvdqd_curr_vec_reg_AX_dqdPE7 = dvdqd_curr_vec_out_AX_dqdPE7; dvdqd_curr_vec_reg_AY_dqdPE7 = dvdqd_curr_vec_out_AY_dqdPE7; dvdqd_curr_vec_reg_AZ_dqdPE7 = dvdqd_curr_vec_out_AZ_dqdPE7; dvdqd_curr_vec_reg_LX_dqdPE7 = dvdqd_curr_vec_out_LX_dqdPE7; dvdqd_curr_vec_reg_LY_dqdPE7 = dvdqd_curr_vec_out_LY_dqdPE7; dvdqd_curr_vec_reg_LZ_dqdPE7 = dvdqd_curr_vec_out_LZ_dqdPE7; 
      dadqd_curr_vec_reg_AX_dqdPE7 = dadqd_curr_vec_out_AX_dqdPE7; dadqd_curr_vec_reg_AY_dqdPE7 = dadqd_curr_vec_out_AY_dqdPE7; dadqd_curr_vec_reg_AZ_dqdPE7 = dadqd_curr_vec_out_AZ_dqdPE7; dadqd_curr_vec_reg_LX_dqdPE7 = dadqd_curr_vec_out_LX_dqdPE7; dadqd_curr_vec_reg_LY_dqdPE7 = dadqd_curr_vec_out_LY_dqdPE7; dadqd_curr_vec_reg_LZ_dqdPE7 = dadqd_curr_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Link 4 Inputs
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 3'd4;
      sinq_val_in_rnea = -32'd685; cosq_val_in_rnea = 32'd65532;
      qd_val_in_rnea = 32'd36422;
      qdd_val_in_rnea = 32'd358153;
      v_prev_vec_in_AX_rnea = -32'd29494; v_prev_vec_in_AY_rnea = -32'd125; v_prev_vec_in_AZ_rnea = 32'd125459; v_prev_vec_in_LX_rnea = -32'd25; v_prev_vec_in_LY_rnea = 32'd6032; v_prev_vec_in_LZ_rnea = 32'd0;
      a_prev_vec_in_AX_rnea = -32'd103246; a_prev_vec_in_AY_rnea = 32'd124234; a_prev_vec_in_AZ_rnea = -32'd25654; a_prev_vec_in_LX_rnea = 32'd25406; a_prev_vec_in_LY_rnea = 32'd21114; a_prev_vec_in_LZ_rnea = 32'd0;
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 0;
      derv_in_dqPE1 = 3'd1;
      sinq_val_in_dqPE1 = 0; cosq_val_in_dqPE1 = 0;
      qd_val_in_dqPE1 = 0;
      v_curr_vec_in_AX_dqPE1 = 0; v_curr_vec_in_AY_dqPE1 = 0; v_curr_vec_in_AZ_dqPE1 = 0; v_curr_vec_in_LX_dqPE1 = 0; v_curr_vec_in_LY_dqPE1 = 0; v_curr_vec_in_LZ_dqPE1 = 0;
      a_curr_vec_in_AX_dqPE1 = 0; a_curr_vec_in_AY_dqPE1 = 0; a_curr_vec_in_AZ_dqPE1 = 0; a_curr_vec_in_LX_dqPE1 = 0; a_curr_vec_in_LY_dqPE1 = 0; a_curr_vec_in_LZ_dqPE1 = 0;
      v_prev_vec_in_AX_dqPE1 = 0; v_prev_vec_in_AY_dqPE1 = 0; v_prev_vec_in_AZ_dqPE1 = 0; v_prev_vec_in_LX_dqPE1 = 0; v_prev_vec_in_LY_dqPE1 = 0; v_prev_vec_in_LZ_dqPE1 = 0;
      a_prev_vec_in_AX_dqPE1 = 0; a_prev_vec_in_AY_dqPE1 = 0; a_prev_vec_in_AZ_dqPE1 = 0; a_prev_vec_in_LX_dqPE1 = 0; a_prev_vec_in_LY_dqPE1 = 0; a_prev_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      link_in_dqPE2 = 3'd3;
      derv_in_dqPE2 = 3'd2;
      sinq_val_in_dqPE2 = -32'd36876; cosq_val_in_dqPE2 = 32'd54177;
      qd_val_in_dqPE2 = 32'd64662;
      v_curr_vec_in_AX_dqPE2 = -32'd29494; v_curr_vec_in_AY_dqPE2 = -32'd125; v_curr_vec_in_AZ_dqPE2 = 32'd125459; v_curr_vec_in_LX_dqPE2 = -32'd26; v_curr_vec_in_LY_dqPE2 = 32'd6032; v_curr_vec_in_LZ_dqPE2 = 32'd0;
      a_curr_vec_in_AX_dqPE2 = -32'd103245; a_curr_vec_in_AY_dqPE2 = 32'd124234; a_curr_vec_in_AZ_dqPE2 = -32'd25654; a_curr_vec_in_LX_dqPE2 = 32'd25406; a_curr_vec_in_LY_dqPE2 = 32'd21114; a_curr_vec_in_LZ_dqPE2 = 32'd0;
      v_prev_vec_in_AX_dqPE2 = 32'd24452; v_prev_vec_in_AY_dqPE2 = 32'd60797; v_prev_vec_in_AZ_dqPE2 = 32'd16493; v_prev_vec_in_LX_dqPE2 = 32'd0; v_prev_vec_in_LY_dqPE2 = 32'd0; v_prev_vec_in_LZ_dqPE2 = 32'd0;
      a_prev_vec_in_AX_dqPE2 = 32'd31718; a_prev_vec_in_AY_dqPE2 = 32'd34667; a_prev_vec_in_AZ_dqPE2 = 32'd136669; a_prev_vec_in_LX_dqPE2 = 32'd0; a_prev_vec_in_LY_dqPE2 = 32'd0; a_prev_vec_in_LZ_dqPE2 = 32'd0;
      // dqPE3
      link_in_dqPE3 = 3'd3;
      derv_in_dqPE3 = 3'd3;
      sinq_val_in_dqPE3 = -32'd36876; cosq_val_in_dqPE3 = 32'd54177;
      qd_val_in_dqPE3 = 32'd64662;
      v_curr_vec_in_AX_dqPE3 = -32'd29494; v_curr_vec_in_AY_dqPE3 = -32'd125; v_curr_vec_in_AZ_dqPE3 = 32'd125459; v_curr_vec_in_LX_dqPE3 = -32'd26; v_curr_vec_in_LY_dqPE3 = 32'd6032; v_curr_vec_in_LZ_dqPE3 = 32'd0;
      a_curr_vec_in_AX_dqPE3 = -32'd103245; a_curr_vec_in_AY_dqPE3 = 32'd124234; a_curr_vec_in_AZ_dqPE3 = -32'd25654; a_curr_vec_in_LX_dqPE3 = 32'd25406; a_curr_vec_in_LY_dqPE3 = 32'd21114; a_curr_vec_in_LZ_dqPE3 = 32'd0;
      v_prev_vec_in_AX_dqPE3 = 32'd24452; v_prev_vec_in_AY_dqPE3 = 32'd60797; v_prev_vec_in_AZ_dqPE3 = 32'd16493; v_prev_vec_in_LX_dqPE3 = 32'd0; v_prev_vec_in_LY_dqPE3 = 32'd0; v_prev_vec_in_LZ_dqPE3 = 32'd0;
      a_prev_vec_in_AX_dqPE3 = 32'd31718; a_prev_vec_in_AY_dqPE3 = 32'd34667; a_prev_vec_in_AZ_dqPE3 = 32'd136669; a_prev_vec_in_LX_dqPE3 = 32'd0; a_prev_vec_in_LY_dqPE3 = 32'd0; a_prev_vec_in_LZ_dqPE3 = 32'd0;
      // dqPE4
      link_in_dqPE4 = 3'd3;
      derv_in_dqPE4 = 3'd4;
      sinq_val_in_dqPE4 = -32'd36876; cosq_val_in_dqPE4 = 32'd54177;
      qd_val_in_dqPE4 = 32'd64662;
      v_curr_vec_in_AX_dqPE4 = -32'd29494; v_curr_vec_in_AY_dqPE4 = -32'd125; v_curr_vec_in_AZ_dqPE4 = 32'd125459; v_curr_vec_in_LX_dqPE4 = -32'd26; v_curr_vec_in_LY_dqPE4 = 32'd6032; v_curr_vec_in_LZ_dqPE4 = 32'd0;
      a_curr_vec_in_AX_dqPE4 = -32'd103245; a_curr_vec_in_AY_dqPE4 = 32'd124234; a_curr_vec_in_AZ_dqPE4 = -32'd25654; a_curr_vec_in_LX_dqPE4 = 32'd25406; a_curr_vec_in_LY_dqPE4 = 32'd21114; a_curr_vec_in_LZ_dqPE4 = 32'd0;
      v_prev_vec_in_AX_dqPE4 = 32'd24452; v_prev_vec_in_AY_dqPE4 = 32'd60797; v_prev_vec_in_AZ_dqPE4 = 32'd16493; v_prev_vec_in_LX_dqPE4 = 32'd0; v_prev_vec_in_LY_dqPE4 = 32'd0; v_prev_vec_in_LZ_dqPE4 = 32'd0;
      a_prev_vec_in_AX_dqPE4 = 32'd31718; a_prev_vec_in_AY_dqPE4 = 32'd34667; a_prev_vec_in_AZ_dqPE4 = 32'd136669; a_prev_vec_in_LX_dqPE4 = 32'd0; a_prev_vec_in_LY_dqPE4 = 32'd0; a_prev_vec_in_LZ_dqPE4 = 32'd0;
      // dqPE5
      link_in_dqPE5 = 3'd3;
      derv_in_dqPE5 = 3'd5;
      sinq_val_in_dqPE5 = -32'd36876; cosq_val_in_dqPE5 = 32'd54177;
      qd_val_in_dqPE5 = 32'd64662;
      v_curr_vec_in_AX_dqPE5 = -32'd29494; v_curr_vec_in_AY_dqPE5 = -32'd125; v_curr_vec_in_AZ_dqPE5 = 32'd125459; v_curr_vec_in_LX_dqPE5 = -32'd26; v_curr_vec_in_LY_dqPE5 = 32'd6032; v_curr_vec_in_LZ_dqPE5 = 32'd0;
      a_curr_vec_in_AX_dqPE5 = -32'd103245; a_curr_vec_in_AY_dqPE5 = 32'd124234; a_curr_vec_in_AZ_dqPE5 = -32'd25654; a_curr_vec_in_LX_dqPE5 = 32'd25406; a_curr_vec_in_LY_dqPE5 = 32'd21114; a_curr_vec_in_LZ_dqPE5 = 32'd0;
      v_prev_vec_in_AX_dqPE5 = 32'd24452; v_prev_vec_in_AY_dqPE5 = 32'd60797; v_prev_vec_in_AZ_dqPE5 = 32'd16493; v_prev_vec_in_LX_dqPE5 = 32'd0; v_prev_vec_in_LY_dqPE5 = 32'd0; v_prev_vec_in_LZ_dqPE5 = 32'd0;
      a_prev_vec_in_AX_dqPE5 = 32'd31718; a_prev_vec_in_AY_dqPE5 = 32'd34667; a_prev_vec_in_AZ_dqPE5 = 32'd136669; a_prev_vec_in_LX_dqPE5 = 32'd0; a_prev_vec_in_LY_dqPE5 = 32'd0; a_prev_vec_in_LZ_dqPE5 = 32'd0;
      // dqPE6
      link_in_dqPE6 = 3'd3;
      derv_in_dqPE6 = 3'd6;
      sinq_val_in_dqPE6 = -32'd36876; cosq_val_in_dqPE6 = 32'd54177;
      qd_val_in_dqPE6 = 32'd64662;
      v_curr_vec_in_AX_dqPE6 = -32'd29494; v_curr_vec_in_AY_dqPE6 = -32'd125; v_curr_vec_in_AZ_dqPE6 = 32'd125459; v_curr_vec_in_LX_dqPE6 = -32'd26; v_curr_vec_in_LY_dqPE6 = 32'd6032; v_curr_vec_in_LZ_dqPE6 = 32'd0;
      a_curr_vec_in_AX_dqPE6 = -32'd103245; a_curr_vec_in_AY_dqPE6 = 32'd124234; a_curr_vec_in_AZ_dqPE6 = -32'd25654; a_curr_vec_in_LX_dqPE6 = 32'd25406; a_curr_vec_in_LY_dqPE6 = 32'd21114; a_curr_vec_in_LZ_dqPE6 = 32'd0;
      v_prev_vec_in_AX_dqPE6 = 32'd24452; v_prev_vec_in_AY_dqPE6 = 32'd60797; v_prev_vec_in_AZ_dqPE6 = 32'd16493; v_prev_vec_in_LX_dqPE6 = 32'd0; v_prev_vec_in_LY_dqPE6 = 32'd0; v_prev_vec_in_LZ_dqPE6 = 32'd0;
      a_prev_vec_in_AX_dqPE6 = 32'd31718; a_prev_vec_in_AY_dqPE6 = 32'd34667; a_prev_vec_in_AZ_dqPE6 = 32'd136669; a_prev_vec_in_LX_dqPE6 = 32'd0; a_prev_vec_in_LY_dqPE6 = 32'd0; a_prev_vec_in_LZ_dqPE6 = 32'd0;
      // dqPE7
      link_in_dqPE7 = 3'd3;
      derv_in_dqPE7 = 3'd7;
      sinq_val_in_dqPE7 = -32'd36876; cosq_val_in_dqPE7 = 32'd54177;
      qd_val_in_dqPE7 = 32'd64662;
      v_curr_vec_in_AX_dqPE7 = -32'd29494; v_curr_vec_in_AY_dqPE7 = -32'd125; v_curr_vec_in_AZ_dqPE7 = 32'd125459; v_curr_vec_in_LX_dqPE7 = -32'd26; v_curr_vec_in_LY_dqPE7 = 32'd6032; v_curr_vec_in_LZ_dqPE7 = 32'd0;
      a_curr_vec_in_AX_dqPE7 = -32'd103245; a_curr_vec_in_AY_dqPE7 = 32'd124234; a_curr_vec_in_AZ_dqPE7 = -32'd25654; a_curr_vec_in_LX_dqPE7 = 32'd25406; a_curr_vec_in_LY_dqPE7 = 32'd21114; a_curr_vec_in_LZ_dqPE7 = 32'd0;
      v_prev_vec_in_AX_dqPE7 = 32'd24452; v_prev_vec_in_AY_dqPE7 = 32'd60797; v_prev_vec_in_AZ_dqPE7 = 32'd16493; v_prev_vec_in_LX_dqPE7 = 32'd0; v_prev_vec_in_LY_dqPE7 = 32'd0; v_prev_vec_in_LZ_dqPE7 = 32'd0;
      a_prev_vec_in_AX_dqPE7 = 32'd31718; a_prev_vec_in_AY_dqPE7 = 32'd34667; a_prev_vec_in_AZ_dqPE7 = 32'd136669; a_prev_vec_in_LX_dqPE7 = 32'd0; a_prev_vec_in_LY_dqPE7 = 32'd0; a_prev_vec_in_LZ_dqPE7 = 32'd0;
      // External dv,da
      // dqPE1
      dvdq_prev_vec_in_AX_dqPE1 = dvdq_curr_vec_reg_AX_dqPE1; dvdq_prev_vec_in_AY_dqPE1 = dvdq_curr_vec_reg_AY_dqPE1; dvdq_prev_vec_in_AZ_dqPE1 = dvdq_curr_vec_reg_AZ_dqPE1; dvdq_prev_vec_in_LX_dqPE1 = dvdq_curr_vec_reg_LX_dqPE1; dvdq_prev_vec_in_LY_dqPE1 = dvdq_curr_vec_reg_LY_dqPE1; dvdq_prev_vec_in_LZ_dqPE1 = dvdq_curr_vec_reg_LZ_dqPE1; 
      dadq_prev_vec_in_AX_dqPE1 = dadq_curr_vec_reg_AX_dqPE1; dadq_prev_vec_in_AY_dqPE1 = dadq_curr_vec_reg_AY_dqPE1; dadq_prev_vec_in_AZ_dqPE1 = dadq_curr_vec_reg_AZ_dqPE1; dadq_prev_vec_in_LX_dqPE1 = dadq_curr_vec_reg_LX_dqPE1; dadq_prev_vec_in_LY_dqPE1 = dadq_curr_vec_reg_LY_dqPE1; dadq_prev_vec_in_LZ_dqPE1 = dadq_curr_vec_reg_LZ_dqPE1; 
      // dqPE2
      dvdq_prev_vec_in_AX_dqPE2 = dvdq_curr_vec_reg_AX_dqPE2; dvdq_prev_vec_in_AY_dqPE2 = dvdq_curr_vec_reg_AY_dqPE2; dvdq_prev_vec_in_AZ_dqPE2 = dvdq_curr_vec_reg_AZ_dqPE2; dvdq_prev_vec_in_LX_dqPE2 = dvdq_curr_vec_reg_LX_dqPE2; dvdq_prev_vec_in_LY_dqPE2 = dvdq_curr_vec_reg_LY_dqPE2; dvdq_prev_vec_in_LZ_dqPE2 = dvdq_curr_vec_reg_LZ_dqPE2; 
      dadq_prev_vec_in_AX_dqPE2 = dadq_curr_vec_reg_AX_dqPE2; dadq_prev_vec_in_AY_dqPE2 = dadq_curr_vec_reg_AY_dqPE2; dadq_prev_vec_in_AZ_dqPE2 = dadq_curr_vec_reg_AZ_dqPE2; dadq_prev_vec_in_LX_dqPE2 = dadq_curr_vec_reg_LX_dqPE2; dadq_prev_vec_in_LY_dqPE2 = dadq_curr_vec_reg_LY_dqPE2; dadq_prev_vec_in_LZ_dqPE2 = dadq_curr_vec_reg_LZ_dqPE2; 
      // dqPE3
      dvdq_prev_vec_in_AX_dqPE3 = dvdq_curr_vec_reg_AX_dqPE3; dvdq_prev_vec_in_AY_dqPE3 = dvdq_curr_vec_reg_AY_dqPE3; dvdq_prev_vec_in_AZ_dqPE3 = dvdq_curr_vec_reg_AZ_dqPE3; dvdq_prev_vec_in_LX_dqPE3 = dvdq_curr_vec_reg_LX_dqPE3; dvdq_prev_vec_in_LY_dqPE3 = dvdq_curr_vec_reg_LY_dqPE3; dvdq_prev_vec_in_LZ_dqPE3 = dvdq_curr_vec_reg_LZ_dqPE3; 
      dadq_prev_vec_in_AX_dqPE3 = dadq_curr_vec_reg_AX_dqPE3; dadq_prev_vec_in_AY_dqPE3 = dadq_curr_vec_reg_AY_dqPE3; dadq_prev_vec_in_AZ_dqPE3 = dadq_curr_vec_reg_AZ_dqPE3; dadq_prev_vec_in_LX_dqPE3 = dadq_curr_vec_reg_LX_dqPE3; dadq_prev_vec_in_LY_dqPE3 = dadq_curr_vec_reg_LY_dqPE3; dadq_prev_vec_in_LZ_dqPE3 = dadq_curr_vec_reg_LZ_dqPE3; 
      // dqPE4
      dvdq_prev_vec_in_AX_dqPE4 = dvdq_curr_vec_reg_AX_dqPE4; dvdq_prev_vec_in_AY_dqPE4 = dvdq_curr_vec_reg_AY_dqPE4; dvdq_prev_vec_in_AZ_dqPE4 = dvdq_curr_vec_reg_AZ_dqPE4; dvdq_prev_vec_in_LX_dqPE4 = dvdq_curr_vec_reg_LX_dqPE4; dvdq_prev_vec_in_LY_dqPE4 = dvdq_curr_vec_reg_LY_dqPE4; dvdq_prev_vec_in_LZ_dqPE4 = dvdq_curr_vec_reg_LZ_dqPE4; 
      dadq_prev_vec_in_AX_dqPE4 = dadq_curr_vec_reg_AX_dqPE4; dadq_prev_vec_in_AY_dqPE4 = dadq_curr_vec_reg_AY_dqPE4; dadq_prev_vec_in_AZ_dqPE4 = dadq_curr_vec_reg_AZ_dqPE4; dadq_prev_vec_in_LX_dqPE4 = dadq_curr_vec_reg_LX_dqPE4; dadq_prev_vec_in_LY_dqPE4 = dadq_curr_vec_reg_LY_dqPE4; dadq_prev_vec_in_LZ_dqPE4 = dadq_curr_vec_reg_LZ_dqPE4; 
      // dqPE5
      dvdq_prev_vec_in_AX_dqPE5 = dvdq_curr_vec_reg_AX_dqPE5; dvdq_prev_vec_in_AY_dqPE5 = dvdq_curr_vec_reg_AY_dqPE5; dvdq_prev_vec_in_AZ_dqPE5 = dvdq_curr_vec_reg_AZ_dqPE5; dvdq_prev_vec_in_LX_dqPE5 = dvdq_curr_vec_reg_LX_dqPE5; dvdq_prev_vec_in_LY_dqPE5 = dvdq_curr_vec_reg_LY_dqPE5; dvdq_prev_vec_in_LZ_dqPE5 = dvdq_curr_vec_reg_LZ_dqPE5; 
      dadq_prev_vec_in_AX_dqPE5 = dadq_curr_vec_reg_AX_dqPE5; dadq_prev_vec_in_AY_dqPE5 = dadq_curr_vec_reg_AY_dqPE5; dadq_prev_vec_in_AZ_dqPE5 = dadq_curr_vec_reg_AZ_dqPE5; dadq_prev_vec_in_LX_dqPE5 = dadq_curr_vec_reg_LX_dqPE5; dadq_prev_vec_in_LY_dqPE5 = dadq_curr_vec_reg_LY_dqPE5; dadq_prev_vec_in_LZ_dqPE5 = dadq_curr_vec_reg_LZ_dqPE5; 
      // dqPE6
      dvdq_prev_vec_in_AX_dqPE6 = dvdq_curr_vec_reg_AX_dqPE6; dvdq_prev_vec_in_AY_dqPE6 = dvdq_curr_vec_reg_AY_dqPE6; dvdq_prev_vec_in_AZ_dqPE6 = dvdq_curr_vec_reg_AZ_dqPE6; dvdq_prev_vec_in_LX_dqPE6 = dvdq_curr_vec_reg_LX_dqPE6; dvdq_prev_vec_in_LY_dqPE6 = dvdq_curr_vec_reg_LY_dqPE6; dvdq_prev_vec_in_LZ_dqPE6 = dvdq_curr_vec_reg_LZ_dqPE6; 
      dadq_prev_vec_in_AX_dqPE6 = dadq_curr_vec_reg_AX_dqPE6; dadq_prev_vec_in_AY_dqPE6 = dadq_curr_vec_reg_AY_dqPE6; dadq_prev_vec_in_AZ_dqPE6 = dadq_curr_vec_reg_AZ_dqPE6; dadq_prev_vec_in_LX_dqPE6 = dadq_curr_vec_reg_LX_dqPE6; dadq_prev_vec_in_LY_dqPE6 = dadq_curr_vec_reg_LY_dqPE6; dadq_prev_vec_in_LZ_dqPE6 = dadq_curr_vec_reg_LZ_dqPE6; 
      // dqPE7
      dvdq_prev_vec_in_AX_dqPE7 = dvdq_curr_vec_reg_AX_dqPE7; dvdq_prev_vec_in_AY_dqPE7 = dvdq_curr_vec_reg_AY_dqPE7; dvdq_prev_vec_in_AZ_dqPE7 = dvdq_curr_vec_reg_AZ_dqPE7; dvdq_prev_vec_in_LX_dqPE7 = dvdq_curr_vec_reg_LX_dqPE7; dvdq_prev_vec_in_LY_dqPE7 = dvdq_curr_vec_reg_LY_dqPE7; dvdq_prev_vec_in_LZ_dqPE7 = dvdq_curr_vec_reg_LZ_dqPE7; 
      dadq_prev_vec_in_AX_dqPE7 = dadq_curr_vec_reg_AX_dqPE7; dadq_prev_vec_in_AY_dqPE7 = dadq_curr_vec_reg_AY_dqPE7; dadq_prev_vec_in_AZ_dqPE7 = dadq_curr_vec_reg_AZ_dqPE7; dadq_prev_vec_in_LX_dqPE7 = dadq_curr_vec_reg_LX_dqPE7; dadq_prev_vec_in_LY_dqPE7 = dadq_curr_vec_reg_LY_dqPE7; dadq_prev_vec_in_LZ_dqPE7 = dadq_curr_vec_reg_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 3'd3;
      derv_in_dqdPE1 = 3'd1;
      sinq_val_in_dqdPE1 = -32'd36876; cosq_val_in_dqdPE1 = 32'd54177;
      qd_val_in_dqdPE1 = 32'd64662;
      v_curr_vec_in_AX_dqdPE1 = -32'd29494; v_curr_vec_in_AY_dqdPE1 = -32'd125; v_curr_vec_in_AZ_dqdPE1 = 32'd125459; v_curr_vec_in_LX_dqdPE1 = -32'd26; v_curr_vec_in_LY_dqdPE1 = 32'd6032; v_curr_vec_in_LZ_dqdPE1 = 32'd0;
      a_curr_vec_in_AX_dqdPE1 = -32'd103245; a_curr_vec_in_AY_dqdPE1 = 32'd124234; a_curr_vec_in_AZ_dqdPE1 = -32'd25654; a_curr_vec_in_LX_dqdPE1 = 32'd25406; a_curr_vec_in_LY_dqdPE1 = 32'd21114; a_curr_vec_in_LZ_dqdPE1 = 32'd0;
      // dqdPE2
      link_in_dqdPE2 = 3'd3;
      derv_in_dqdPE2 = 3'd2;
      sinq_val_in_dqdPE2 = -32'd36876; cosq_val_in_dqdPE2 = 32'd54177;
      qd_val_in_dqdPE2 = 32'd64662;
      v_curr_vec_in_AX_dqdPE2 = -32'd29494; v_curr_vec_in_AY_dqdPE2 = -32'd125; v_curr_vec_in_AZ_dqdPE2 = 32'd125459; v_curr_vec_in_LX_dqdPE2 = -32'd26; v_curr_vec_in_LY_dqdPE2 = 32'd6032; v_curr_vec_in_LZ_dqdPE2 = 32'd0;
      a_curr_vec_in_AX_dqdPE2 = -32'd103245; a_curr_vec_in_AY_dqdPE2 = 32'd124234; a_curr_vec_in_AZ_dqdPE2 = -32'd25654; a_curr_vec_in_LX_dqdPE2 = 32'd25406; a_curr_vec_in_LY_dqdPE2 = 32'd21114; a_curr_vec_in_LZ_dqdPE2 = 32'd0;
      // dqdPE3
      link_in_dqdPE3 = 3'd3;
      derv_in_dqdPE3 = 3'd3;
      sinq_val_in_dqdPE3 = -32'd36876; cosq_val_in_dqdPE3 = 32'd54177;
      qd_val_in_dqdPE3 = 32'd64662;
      v_curr_vec_in_AX_dqdPE3 = -32'd29494; v_curr_vec_in_AY_dqdPE3 = -32'd125; v_curr_vec_in_AZ_dqdPE3 = 32'd125459; v_curr_vec_in_LX_dqdPE3 = -32'd26; v_curr_vec_in_LY_dqdPE3 = 32'd6032; v_curr_vec_in_LZ_dqdPE3 = 32'd0;
      a_curr_vec_in_AX_dqdPE3 = -32'd103245; a_curr_vec_in_AY_dqdPE3 = 32'd124234; a_curr_vec_in_AZ_dqdPE3 = -32'd25654; a_curr_vec_in_LX_dqdPE3 = 32'd25406; a_curr_vec_in_LY_dqdPE3 = 32'd21114; a_curr_vec_in_LZ_dqdPE3 = 32'd0;
      // dqdPE4
      link_in_dqdPE4 = 3'd3;
      derv_in_dqdPE4 = 3'd4;
      sinq_val_in_dqdPE4 = -32'd36876; cosq_val_in_dqdPE4 = 32'd54177;
      qd_val_in_dqdPE4 = 32'd64662;
      v_curr_vec_in_AX_dqdPE4 = -32'd29494; v_curr_vec_in_AY_dqdPE4 = -32'd125; v_curr_vec_in_AZ_dqdPE4 = 32'd125459; v_curr_vec_in_LX_dqdPE4 = -32'd26; v_curr_vec_in_LY_dqdPE4 = 32'd6032; v_curr_vec_in_LZ_dqdPE4 = 32'd0;
      a_curr_vec_in_AX_dqdPE4 = -32'd103245; a_curr_vec_in_AY_dqdPE4 = 32'd124234; a_curr_vec_in_AZ_dqdPE4 = -32'd25654; a_curr_vec_in_LX_dqdPE4 = 32'd25406; a_curr_vec_in_LY_dqdPE4 = 32'd21114; a_curr_vec_in_LZ_dqdPE4 = 32'd0;
      // dqdPE5
      link_in_dqdPE5 = 3'd3;
      derv_in_dqdPE5 = 3'd5;
      sinq_val_in_dqdPE5 = -32'd36876; cosq_val_in_dqdPE5 = 32'd54177;
      qd_val_in_dqdPE5 = 32'd64662;
      v_curr_vec_in_AX_dqdPE5 = -32'd29494; v_curr_vec_in_AY_dqdPE5 = -32'd125; v_curr_vec_in_AZ_dqdPE5 = 32'd125459; v_curr_vec_in_LX_dqdPE5 = -32'd26; v_curr_vec_in_LY_dqdPE5 = 32'd6032; v_curr_vec_in_LZ_dqdPE5 = 32'd0;
      a_curr_vec_in_AX_dqdPE5 = -32'd103245; a_curr_vec_in_AY_dqdPE5 = 32'd124234; a_curr_vec_in_AZ_dqdPE5 = -32'd25654; a_curr_vec_in_LX_dqdPE5 = 32'd25406; a_curr_vec_in_LY_dqdPE5 = 32'd21114; a_curr_vec_in_LZ_dqdPE5 = 32'd0;
      // dqdPE6
      link_in_dqdPE6 = 3'd3;
      derv_in_dqdPE6 = 3'd6;
      sinq_val_in_dqdPE6 = -32'd36876; cosq_val_in_dqdPE6 = 32'd54177;
      qd_val_in_dqdPE6 = 32'd64662;
      v_curr_vec_in_AX_dqdPE6 = -32'd29494; v_curr_vec_in_AY_dqdPE6 = -32'd125; v_curr_vec_in_AZ_dqdPE6 = 32'd125459; v_curr_vec_in_LX_dqdPE6 = -32'd26; v_curr_vec_in_LY_dqdPE6 = 32'd6032; v_curr_vec_in_LZ_dqdPE6 = 32'd0;
      a_curr_vec_in_AX_dqdPE6 = -32'd103245; a_curr_vec_in_AY_dqdPE6 = 32'd124234; a_curr_vec_in_AZ_dqdPE6 = -32'd25654; a_curr_vec_in_LX_dqdPE6 = 32'd25406; a_curr_vec_in_LY_dqdPE6 = 32'd21114; a_curr_vec_in_LZ_dqdPE6 = 32'd0;
      // dqdPE7
      link_in_dqdPE7 = 3'd3;
      derv_in_dqdPE7 = 3'd7;
      sinq_val_in_dqdPE7 = -32'd36876; cosq_val_in_dqdPE7 = 32'd54177;
      qd_val_in_dqdPE7 = 32'd64662;
      v_curr_vec_in_AX_dqdPE7 = -32'd29494; v_curr_vec_in_AY_dqdPE7 = -32'd125; v_curr_vec_in_AZ_dqdPE7 = 32'd125459; v_curr_vec_in_LX_dqdPE7 = -32'd26; v_curr_vec_in_LY_dqdPE7 = 32'd6032; v_curr_vec_in_LZ_dqdPE7 = 32'd0;
      a_curr_vec_in_AX_dqdPE7 = -32'd103245; a_curr_vec_in_AY_dqdPE7 = 32'd124234; a_curr_vec_in_AZ_dqdPE7 = -32'd25654; a_curr_vec_in_LX_dqdPE7 = 32'd25406; a_curr_vec_in_LY_dqdPE7 = 32'd21114; a_curr_vec_in_LZ_dqdPE7 = 32'd0;
      // External dv,da
      // dqdPE1
      dvdqd_prev_vec_in_AX_dqdPE1 = dvdqd_curr_vec_reg_AX_dqdPE1; dvdqd_prev_vec_in_AY_dqdPE1 = dvdqd_curr_vec_reg_AY_dqdPE1; dvdqd_prev_vec_in_AZ_dqdPE1 = dvdqd_curr_vec_reg_AZ_dqdPE1; dvdqd_prev_vec_in_LX_dqdPE1 = dvdqd_curr_vec_reg_LX_dqdPE1; dvdqd_prev_vec_in_LY_dqdPE1 = dvdqd_curr_vec_reg_LY_dqdPE1; dvdqd_prev_vec_in_LZ_dqdPE1 = dvdqd_curr_vec_reg_LZ_dqdPE1; 
      dadqd_prev_vec_in_AX_dqdPE1 = dadqd_curr_vec_reg_AX_dqdPE1; dadqd_prev_vec_in_AY_dqdPE1 = dadqd_curr_vec_reg_AY_dqdPE1; dadqd_prev_vec_in_AZ_dqdPE1 = dadqd_curr_vec_reg_AZ_dqdPE1; dadqd_prev_vec_in_LX_dqdPE1 = dadqd_curr_vec_reg_LX_dqdPE1; dadqd_prev_vec_in_LY_dqdPE1 = dadqd_curr_vec_reg_LY_dqdPE1; dadqd_prev_vec_in_LZ_dqdPE1 = dadqd_curr_vec_reg_LZ_dqdPE1; 
      // dqdPE2
      dvdqd_prev_vec_in_AX_dqdPE2 = dvdqd_curr_vec_reg_AX_dqdPE2; dvdqd_prev_vec_in_AY_dqdPE2 = dvdqd_curr_vec_reg_AY_dqdPE2; dvdqd_prev_vec_in_AZ_dqdPE2 = dvdqd_curr_vec_reg_AZ_dqdPE2; dvdqd_prev_vec_in_LX_dqdPE2 = dvdqd_curr_vec_reg_LX_dqdPE2; dvdqd_prev_vec_in_LY_dqdPE2 = dvdqd_curr_vec_reg_LY_dqdPE2; dvdqd_prev_vec_in_LZ_dqdPE2 = dvdqd_curr_vec_reg_LZ_dqdPE2; 
      dadqd_prev_vec_in_AX_dqdPE2 = dadqd_curr_vec_reg_AX_dqdPE2; dadqd_prev_vec_in_AY_dqdPE2 = dadqd_curr_vec_reg_AY_dqdPE2; dadqd_prev_vec_in_AZ_dqdPE2 = dadqd_curr_vec_reg_AZ_dqdPE2; dadqd_prev_vec_in_LX_dqdPE2 = dadqd_curr_vec_reg_LX_dqdPE2; dadqd_prev_vec_in_LY_dqdPE2 = dadqd_curr_vec_reg_LY_dqdPE2; dadqd_prev_vec_in_LZ_dqdPE2 = dadqd_curr_vec_reg_LZ_dqdPE2; 
      // dqdPE3
      dvdqd_prev_vec_in_AX_dqdPE3 = dvdqd_curr_vec_reg_AX_dqdPE3; dvdqd_prev_vec_in_AY_dqdPE3 = dvdqd_curr_vec_reg_AY_dqdPE3; dvdqd_prev_vec_in_AZ_dqdPE3 = dvdqd_curr_vec_reg_AZ_dqdPE3; dvdqd_prev_vec_in_LX_dqdPE3 = dvdqd_curr_vec_reg_LX_dqdPE3; dvdqd_prev_vec_in_LY_dqdPE3 = dvdqd_curr_vec_reg_LY_dqdPE3; dvdqd_prev_vec_in_LZ_dqdPE3 = dvdqd_curr_vec_reg_LZ_dqdPE3; 
      dadqd_prev_vec_in_AX_dqdPE3 = dadqd_curr_vec_reg_AX_dqdPE3; dadqd_prev_vec_in_AY_dqdPE3 = dadqd_curr_vec_reg_AY_dqdPE3; dadqd_prev_vec_in_AZ_dqdPE3 = dadqd_curr_vec_reg_AZ_dqdPE3; dadqd_prev_vec_in_LX_dqdPE3 = dadqd_curr_vec_reg_LX_dqdPE3; dadqd_prev_vec_in_LY_dqdPE3 = dadqd_curr_vec_reg_LY_dqdPE3; dadqd_prev_vec_in_LZ_dqdPE3 = dadqd_curr_vec_reg_LZ_dqdPE3; 
      // dqdPE4
      dvdqd_prev_vec_in_AX_dqdPE4 = dvdqd_curr_vec_reg_AX_dqdPE4; dvdqd_prev_vec_in_AY_dqdPE4 = dvdqd_curr_vec_reg_AY_dqdPE4; dvdqd_prev_vec_in_AZ_dqdPE4 = dvdqd_curr_vec_reg_AZ_dqdPE4; dvdqd_prev_vec_in_LX_dqdPE4 = dvdqd_curr_vec_reg_LX_dqdPE4; dvdqd_prev_vec_in_LY_dqdPE4 = dvdqd_curr_vec_reg_LY_dqdPE4; dvdqd_prev_vec_in_LZ_dqdPE4 = dvdqd_curr_vec_reg_LZ_dqdPE4; 
      dadqd_prev_vec_in_AX_dqdPE4 = dadqd_curr_vec_reg_AX_dqdPE4; dadqd_prev_vec_in_AY_dqdPE4 = dadqd_curr_vec_reg_AY_dqdPE4; dadqd_prev_vec_in_AZ_dqdPE4 = dadqd_curr_vec_reg_AZ_dqdPE4; dadqd_prev_vec_in_LX_dqdPE4 = dadqd_curr_vec_reg_LX_dqdPE4; dadqd_prev_vec_in_LY_dqdPE4 = dadqd_curr_vec_reg_LY_dqdPE4; dadqd_prev_vec_in_LZ_dqdPE4 = dadqd_curr_vec_reg_LZ_dqdPE4; 
      // dqdPE5
      dvdqd_prev_vec_in_AX_dqdPE5 = dvdqd_curr_vec_reg_AX_dqdPE5; dvdqd_prev_vec_in_AY_dqdPE5 = dvdqd_curr_vec_reg_AY_dqdPE5; dvdqd_prev_vec_in_AZ_dqdPE5 = dvdqd_curr_vec_reg_AZ_dqdPE5; dvdqd_prev_vec_in_LX_dqdPE5 = dvdqd_curr_vec_reg_LX_dqdPE5; dvdqd_prev_vec_in_LY_dqdPE5 = dvdqd_curr_vec_reg_LY_dqdPE5; dvdqd_prev_vec_in_LZ_dqdPE5 = dvdqd_curr_vec_reg_LZ_dqdPE5; 
      dadqd_prev_vec_in_AX_dqdPE5 = dadqd_curr_vec_reg_AX_dqdPE5; dadqd_prev_vec_in_AY_dqdPE5 = dadqd_curr_vec_reg_AY_dqdPE5; dadqd_prev_vec_in_AZ_dqdPE5 = dadqd_curr_vec_reg_AZ_dqdPE5; dadqd_prev_vec_in_LX_dqdPE5 = dadqd_curr_vec_reg_LX_dqdPE5; dadqd_prev_vec_in_LY_dqdPE5 = dadqd_curr_vec_reg_LY_dqdPE5; dadqd_prev_vec_in_LZ_dqdPE5 = dadqd_curr_vec_reg_LZ_dqdPE5; 
      // dqdPE6
      dvdqd_prev_vec_in_AX_dqdPE6 = dvdqd_curr_vec_reg_AX_dqdPE6; dvdqd_prev_vec_in_AY_dqdPE6 = dvdqd_curr_vec_reg_AY_dqdPE6; dvdqd_prev_vec_in_AZ_dqdPE6 = dvdqd_curr_vec_reg_AZ_dqdPE6; dvdqd_prev_vec_in_LX_dqdPE6 = dvdqd_curr_vec_reg_LX_dqdPE6; dvdqd_prev_vec_in_LY_dqdPE6 = dvdqd_curr_vec_reg_LY_dqdPE6; dvdqd_prev_vec_in_LZ_dqdPE6 = dvdqd_curr_vec_reg_LZ_dqdPE6; 
      dadqd_prev_vec_in_AX_dqdPE6 = dadqd_curr_vec_reg_AX_dqdPE6; dadqd_prev_vec_in_AY_dqdPE6 = dadqd_curr_vec_reg_AY_dqdPE6; dadqd_prev_vec_in_AZ_dqdPE6 = dadqd_curr_vec_reg_AZ_dqdPE6; dadqd_prev_vec_in_LX_dqdPE6 = dadqd_curr_vec_reg_LX_dqdPE6; dadqd_prev_vec_in_LY_dqdPE6 = dadqd_curr_vec_reg_LY_dqdPE6; dadqd_prev_vec_in_LZ_dqdPE6 = dadqd_curr_vec_reg_LZ_dqdPE6; 
      // dqdPE7
      dvdqd_prev_vec_in_AX_dqdPE7 = dvdqd_curr_vec_reg_AX_dqdPE7; dvdqd_prev_vec_in_AY_dqdPE7 = dvdqd_curr_vec_reg_AY_dqdPE7; dvdqd_prev_vec_in_AZ_dqdPE7 = dvdqd_curr_vec_reg_AZ_dqdPE7; dvdqd_prev_vec_in_LX_dqdPE7 = dvdqd_curr_vec_reg_LX_dqdPE7; dvdqd_prev_vec_in_LY_dqdPE7 = dvdqd_curr_vec_reg_LY_dqdPE7; dvdqd_prev_vec_in_LZ_dqdPE7 = dvdqd_curr_vec_reg_LZ_dqdPE7; 
      dadqd_prev_vec_in_AX_dqdPE7 = dadqd_curr_vec_reg_AX_dqdPE7; dadqd_prev_vec_in_AY_dqdPE7 = dadqd_curr_vec_reg_AY_dqdPE7; dadqd_prev_vec_in_AZ_dqdPE7 = dadqd_curr_vec_reg_AZ_dqdPE7; dadqd_prev_vec_in_LX_dqdPE7 = dadqd_curr_vec_reg_LX_dqdPE7; dadqd_prev_vec_in_LY_dqdPE7 = dadqd_curr_vec_reg_LY_dqdPE7; dadqd_prev_vec_in_LZ_dqdPE7 = dadqd_curr_vec_reg_LZ_dqdPE7; 
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
      $display ("// Link 4 RNEA");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-8244, 621, 6514, 21590, -11080, -133498);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_curr_vec_out_AX_rnea,f_curr_vec_out_AY_rnea,f_curr_vec_out_AZ_rnea,f_curr_vec_out_LX_rnea,f_curr_vec_out_LY_rnea,f_curr_vec_out_LZ_rnea);
      $display ("//-------------------------------------------------------------------------------------------------------");
      $display ("// Link 3 Derivatives");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2621, 15599, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -10348, 21009, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1137, -2999, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -51071, 102173, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 1313, -68019, 0, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -57033, 16263, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AX_dqPE1,dfdq_curr_vec_out_AX_dqPE2,dfdq_curr_vec_out_AX_dqPE3,dfdq_curr_vec_out_AX_dqPE4,dfdq_curr_vec_out_AX_dqPE5,dfdq_curr_vec_out_AX_dqPE6,dfdq_curr_vec_out_AX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AY_dqPE1,dfdq_curr_vec_out_AY_dqPE2,dfdq_curr_vec_out_AY_dqPE3,dfdq_curr_vec_out_AY_dqPE4,dfdq_curr_vec_out_AY_dqPE5,dfdq_curr_vec_out_AY_dqPE6,dfdq_curr_vec_out_AY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AZ_dqPE1,dfdq_curr_vec_out_AZ_dqPE2,dfdq_curr_vec_out_AZ_dqPE3,dfdq_curr_vec_out_AZ_dqPE4,dfdq_curr_vec_out_AZ_dqPE5,dfdq_curr_vec_out_AZ_dqPE6,dfdq_curr_vec_out_AZ_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LX_dqPE1,dfdq_curr_vec_out_LX_dqPE2,dfdq_curr_vec_out_LX_dqPE3,dfdq_curr_vec_out_LX_dqPE4,dfdq_curr_vec_out_LX_dqPE5,dfdq_curr_vec_out_LX_dqPE6,dfdq_curr_vec_out_LX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LY_dqPE1,dfdq_curr_vec_out_LY_dqPE2,dfdq_curr_vec_out_LY_dqPE3,dfdq_curr_vec_out_LY_dqPE4,dfdq_curr_vec_out_LY_dqPE5,dfdq_curr_vec_out_LY_dqPE6,dfdq_curr_vec_out_LY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LZ_dqPE1,dfdq_curr_vec_out_LZ_dqPE2,dfdq_curr_vec_out_LZ_dqPE3,dfdq_curr_vec_out_LZ_dqPE4,dfdq_curr_vec_out_LZ_dqPE5,dfdq_curr_vec_out_LZ_dqPE6,dfdq_curr_vec_out_LZ_dqPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1897, -19915, 2933, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10769, -13702, 147, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1521, 1936, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53805, -68646, 0, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22821, 97882, -22583, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -23054, -23480, -22, 0, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AX_dqdPE1,dfdqd_curr_vec_out_AX_dqdPE2,dfdqd_curr_vec_out_AX_dqdPE3,dfdqd_curr_vec_out_AX_dqdPE4,dfdqd_curr_vec_out_AX_dqdPE5,dfdqd_curr_vec_out_AX_dqdPE6,dfdqd_curr_vec_out_AX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AY_dqdPE1,dfdqd_curr_vec_out_AY_dqdPE2,dfdqd_curr_vec_out_AY_dqdPE3,dfdqd_curr_vec_out_AY_dqdPE4,dfdqd_curr_vec_out_AY_dqdPE5,dfdqd_curr_vec_out_AY_dqdPE6,dfdqd_curr_vec_out_AY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AZ_dqdPE1,dfdqd_curr_vec_out_AZ_dqdPE2,dfdqd_curr_vec_out_AZ_dqdPE3,dfdqd_curr_vec_out_AZ_dqdPE4,dfdqd_curr_vec_out_AZ_dqdPE5,dfdqd_curr_vec_out_AZ_dqdPE6,dfdqd_curr_vec_out_AZ_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LX_dqdPE1,dfdqd_curr_vec_out_LX_dqdPE2,dfdqd_curr_vec_out_LX_dqdPE3,dfdqd_curr_vec_out_LX_dqdPE4,dfdqd_curr_vec_out_LX_dqdPE5,dfdqd_curr_vec_out_LX_dqdPE6,dfdqd_curr_vec_out_LX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LY_dqdPE1,dfdqd_curr_vec_out_LY_dqdPE2,dfdqd_curr_vec_out_LY_dqdPE3,dfdqd_curr_vec_out_LY_dqdPE4,dfdqd_curr_vec_out_LY_dqdPE5,dfdqd_curr_vec_out_LY_dqdPE6,dfdqd_curr_vec_out_LY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LZ_dqdPE1,dfdqd_curr_vec_out_LZ_dqdPE2,dfdqd_curr_vec_out_LZ_dqdPE3,dfdqd_curr_vec_out_LZ_dqdPE4,dfdqd_curr_vec_out_LZ_dqdPE5,dfdqd_curr_vec_out_LZ_dqdPE6,dfdqd_curr_vec_out_LZ_dqdPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External dv,da
      //------------------------------------------------------------------------
      // dqPE1
      dvdq_curr_vec_reg_AX_dqPE1 = dvdq_curr_vec_out_AX_dqPE1; dvdq_curr_vec_reg_AY_dqPE1 = dvdq_curr_vec_out_AY_dqPE1; dvdq_curr_vec_reg_AZ_dqPE1 = dvdq_curr_vec_out_AZ_dqPE1; dvdq_curr_vec_reg_LX_dqPE1 = dvdq_curr_vec_out_LX_dqPE1; dvdq_curr_vec_reg_LY_dqPE1 = dvdq_curr_vec_out_LY_dqPE1; dvdq_curr_vec_reg_LZ_dqPE1 = dvdq_curr_vec_out_LZ_dqPE1; 
      dadq_curr_vec_reg_AX_dqPE1 = dadq_curr_vec_out_AX_dqPE1; dadq_curr_vec_reg_AY_dqPE1 = dadq_curr_vec_out_AY_dqPE1; dadq_curr_vec_reg_AZ_dqPE1 = dadq_curr_vec_out_AZ_dqPE1; dadq_curr_vec_reg_LX_dqPE1 = dadq_curr_vec_out_LX_dqPE1; dadq_curr_vec_reg_LY_dqPE1 = dadq_curr_vec_out_LY_dqPE1; dadq_curr_vec_reg_LZ_dqPE1 = dadq_curr_vec_out_LZ_dqPE1; 
      // dqPE2
      dvdq_curr_vec_reg_AX_dqPE2 = dvdq_curr_vec_out_AX_dqPE2; dvdq_curr_vec_reg_AY_dqPE2 = dvdq_curr_vec_out_AY_dqPE2; dvdq_curr_vec_reg_AZ_dqPE2 = dvdq_curr_vec_out_AZ_dqPE2; dvdq_curr_vec_reg_LX_dqPE2 = dvdq_curr_vec_out_LX_dqPE2; dvdq_curr_vec_reg_LY_dqPE2 = dvdq_curr_vec_out_LY_dqPE2; dvdq_curr_vec_reg_LZ_dqPE2 = dvdq_curr_vec_out_LZ_dqPE2; 
      dadq_curr_vec_reg_AX_dqPE2 = dadq_curr_vec_out_AX_dqPE2; dadq_curr_vec_reg_AY_dqPE2 = dadq_curr_vec_out_AY_dqPE2; dadq_curr_vec_reg_AZ_dqPE2 = dadq_curr_vec_out_AZ_dqPE2; dadq_curr_vec_reg_LX_dqPE2 = dadq_curr_vec_out_LX_dqPE2; dadq_curr_vec_reg_LY_dqPE2 = dadq_curr_vec_out_LY_dqPE2; dadq_curr_vec_reg_LZ_dqPE2 = dadq_curr_vec_out_LZ_dqPE2; 
      // dqPE3
      dvdq_curr_vec_reg_AX_dqPE3 = dvdq_curr_vec_out_AX_dqPE3; dvdq_curr_vec_reg_AY_dqPE3 = dvdq_curr_vec_out_AY_dqPE3; dvdq_curr_vec_reg_AZ_dqPE3 = dvdq_curr_vec_out_AZ_dqPE3; dvdq_curr_vec_reg_LX_dqPE3 = dvdq_curr_vec_out_LX_dqPE3; dvdq_curr_vec_reg_LY_dqPE3 = dvdq_curr_vec_out_LY_dqPE3; dvdq_curr_vec_reg_LZ_dqPE3 = dvdq_curr_vec_out_LZ_dqPE3; 
      dadq_curr_vec_reg_AX_dqPE3 = dadq_curr_vec_out_AX_dqPE3; dadq_curr_vec_reg_AY_dqPE3 = dadq_curr_vec_out_AY_dqPE3; dadq_curr_vec_reg_AZ_dqPE3 = dadq_curr_vec_out_AZ_dqPE3; dadq_curr_vec_reg_LX_dqPE3 = dadq_curr_vec_out_LX_dqPE3; dadq_curr_vec_reg_LY_dqPE3 = dadq_curr_vec_out_LY_dqPE3; dadq_curr_vec_reg_LZ_dqPE3 = dadq_curr_vec_out_LZ_dqPE3; 
      // dqPE4
      dvdq_curr_vec_reg_AX_dqPE4 = dvdq_curr_vec_out_AX_dqPE4; dvdq_curr_vec_reg_AY_dqPE4 = dvdq_curr_vec_out_AY_dqPE4; dvdq_curr_vec_reg_AZ_dqPE4 = dvdq_curr_vec_out_AZ_dqPE4; dvdq_curr_vec_reg_LX_dqPE4 = dvdq_curr_vec_out_LX_dqPE4; dvdq_curr_vec_reg_LY_dqPE4 = dvdq_curr_vec_out_LY_dqPE4; dvdq_curr_vec_reg_LZ_dqPE4 = dvdq_curr_vec_out_LZ_dqPE4; 
      dadq_curr_vec_reg_AX_dqPE4 = dadq_curr_vec_out_AX_dqPE4; dadq_curr_vec_reg_AY_dqPE4 = dadq_curr_vec_out_AY_dqPE4; dadq_curr_vec_reg_AZ_dqPE4 = dadq_curr_vec_out_AZ_dqPE4; dadq_curr_vec_reg_LX_dqPE4 = dadq_curr_vec_out_LX_dqPE4; dadq_curr_vec_reg_LY_dqPE4 = dadq_curr_vec_out_LY_dqPE4; dadq_curr_vec_reg_LZ_dqPE4 = dadq_curr_vec_out_LZ_dqPE4; 
      // dqPE5
      dvdq_curr_vec_reg_AX_dqPE5 = dvdq_curr_vec_out_AX_dqPE5; dvdq_curr_vec_reg_AY_dqPE5 = dvdq_curr_vec_out_AY_dqPE5; dvdq_curr_vec_reg_AZ_dqPE5 = dvdq_curr_vec_out_AZ_dqPE5; dvdq_curr_vec_reg_LX_dqPE5 = dvdq_curr_vec_out_LX_dqPE5; dvdq_curr_vec_reg_LY_dqPE5 = dvdq_curr_vec_out_LY_dqPE5; dvdq_curr_vec_reg_LZ_dqPE5 = dvdq_curr_vec_out_LZ_dqPE5; 
      dadq_curr_vec_reg_AX_dqPE5 = dadq_curr_vec_out_AX_dqPE5; dadq_curr_vec_reg_AY_dqPE5 = dadq_curr_vec_out_AY_dqPE5; dadq_curr_vec_reg_AZ_dqPE5 = dadq_curr_vec_out_AZ_dqPE5; dadq_curr_vec_reg_LX_dqPE5 = dadq_curr_vec_out_LX_dqPE5; dadq_curr_vec_reg_LY_dqPE5 = dadq_curr_vec_out_LY_dqPE5; dadq_curr_vec_reg_LZ_dqPE5 = dadq_curr_vec_out_LZ_dqPE5; 
      // dqPE6
      dvdq_curr_vec_reg_AX_dqPE6 = dvdq_curr_vec_out_AX_dqPE6; dvdq_curr_vec_reg_AY_dqPE6 = dvdq_curr_vec_out_AY_dqPE6; dvdq_curr_vec_reg_AZ_dqPE6 = dvdq_curr_vec_out_AZ_dqPE6; dvdq_curr_vec_reg_LX_dqPE6 = dvdq_curr_vec_out_LX_dqPE6; dvdq_curr_vec_reg_LY_dqPE6 = dvdq_curr_vec_out_LY_dqPE6; dvdq_curr_vec_reg_LZ_dqPE6 = dvdq_curr_vec_out_LZ_dqPE6; 
      dadq_curr_vec_reg_AX_dqPE6 = dadq_curr_vec_out_AX_dqPE6; dadq_curr_vec_reg_AY_dqPE6 = dadq_curr_vec_out_AY_dqPE6; dadq_curr_vec_reg_AZ_dqPE6 = dadq_curr_vec_out_AZ_dqPE6; dadq_curr_vec_reg_LX_dqPE6 = dadq_curr_vec_out_LX_dqPE6; dadq_curr_vec_reg_LY_dqPE6 = dadq_curr_vec_out_LY_dqPE6; dadq_curr_vec_reg_LZ_dqPE6 = dadq_curr_vec_out_LZ_dqPE6; 
      // dqPE7
      dvdq_curr_vec_reg_AX_dqPE7 = dvdq_curr_vec_out_AX_dqPE7; dvdq_curr_vec_reg_AY_dqPE7 = dvdq_curr_vec_out_AY_dqPE7; dvdq_curr_vec_reg_AZ_dqPE7 = dvdq_curr_vec_out_AZ_dqPE7; dvdq_curr_vec_reg_LX_dqPE7 = dvdq_curr_vec_out_LX_dqPE7; dvdq_curr_vec_reg_LY_dqPE7 = dvdq_curr_vec_out_LY_dqPE7; dvdq_curr_vec_reg_LZ_dqPE7 = dvdq_curr_vec_out_LZ_dqPE7; 
      dadq_curr_vec_reg_AX_dqPE7 = dadq_curr_vec_out_AX_dqPE7; dadq_curr_vec_reg_AY_dqPE7 = dadq_curr_vec_out_AY_dqPE7; dadq_curr_vec_reg_AZ_dqPE7 = dadq_curr_vec_out_AZ_dqPE7; dadq_curr_vec_reg_LX_dqPE7 = dadq_curr_vec_out_LX_dqPE7; dadq_curr_vec_reg_LY_dqPE7 = dadq_curr_vec_out_LY_dqPE7; dadq_curr_vec_reg_LZ_dqPE7 = dadq_curr_vec_out_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqdPE1
      dvdqd_curr_vec_reg_AX_dqdPE1 = dvdqd_curr_vec_out_AX_dqdPE1; dvdqd_curr_vec_reg_AY_dqdPE1 = dvdqd_curr_vec_out_AY_dqdPE1; dvdqd_curr_vec_reg_AZ_dqdPE1 = dvdqd_curr_vec_out_AZ_dqdPE1; dvdqd_curr_vec_reg_LX_dqdPE1 = dvdqd_curr_vec_out_LX_dqdPE1; dvdqd_curr_vec_reg_LY_dqdPE1 = dvdqd_curr_vec_out_LY_dqdPE1; dvdqd_curr_vec_reg_LZ_dqdPE1 = dvdqd_curr_vec_out_LZ_dqdPE1; 
      dadqd_curr_vec_reg_AX_dqdPE1 = dadqd_curr_vec_out_AX_dqdPE1; dadqd_curr_vec_reg_AY_dqdPE1 = dadqd_curr_vec_out_AY_dqdPE1; dadqd_curr_vec_reg_AZ_dqdPE1 = dadqd_curr_vec_out_AZ_dqdPE1; dadqd_curr_vec_reg_LX_dqdPE1 = dadqd_curr_vec_out_LX_dqdPE1; dadqd_curr_vec_reg_LY_dqdPE1 = dadqd_curr_vec_out_LY_dqdPE1; dadqd_curr_vec_reg_LZ_dqdPE1 = dadqd_curr_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dvdqd_curr_vec_reg_AX_dqdPE2 = dvdqd_curr_vec_out_AX_dqdPE2; dvdqd_curr_vec_reg_AY_dqdPE2 = dvdqd_curr_vec_out_AY_dqdPE2; dvdqd_curr_vec_reg_AZ_dqdPE2 = dvdqd_curr_vec_out_AZ_dqdPE2; dvdqd_curr_vec_reg_LX_dqdPE2 = dvdqd_curr_vec_out_LX_dqdPE2; dvdqd_curr_vec_reg_LY_dqdPE2 = dvdqd_curr_vec_out_LY_dqdPE2; dvdqd_curr_vec_reg_LZ_dqdPE2 = dvdqd_curr_vec_out_LZ_dqdPE2; 
      dadqd_curr_vec_reg_AX_dqdPE2 = dadqd_curr_vec_out_AX_dqdPE2; dadqd_curr_vec_reg_AY_dqdPE2 = dadqd_curr_vec_out_AY_dqdPE2; dadqd_curr_vec_reg_AZ_dqdPE2 = dadqd_curr_vec_out_AZ_dqdPE2; dadqd_curr_vec_reg_LX_dqdPE2 = dadqd_curr_vec_out_LX_dqdPE2; dadqd_curr_vec_reg_LY_dqdPE2 = dadqd_curr_vec_out_LY_dqdPE2; dadqd_curr_vec_reg_LZ_dqdPE2 = dadqd_curr_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dvdqd_curr_vec_reg_AX_dqdPE3 = dvdqd_curr_vec_out_AX_dqdPE3; dvdqd_curr_vec_reg_AY_dqdPE3 = dvdqd_curr_vec_out_AY_dqdPE3; dvdqd_curr_vec_reg_AZ_dqdPE3 = dvdqd_curr_vec_out_AZ_dqdPE3; dvdqd_curr_vec_reg_LX_dqdPE3 = dvdqd_curr_vec_out_LX_dqdPE3; dvdqd_curr_vec_reg_LY_dqdPE3 = dvdqd_curr_vec_out_LY_dqdPE3; dvdqd_curr_vec_reg_LZ_dqdPE3 = dvdqd_curr_vec_out_LZ_dqdPE3; 
      dadqd_curr_vec_reg_AX_dqdPE3 = dadqd_curr_vec_out_AX_dqdPE3; dadqd_curr_vec_reg_AY_dqdPE3 = dadqd_curr_vec_out_AY_dqdPE3; dadqd_curr_vec_reg_AZ_dqdPE3 = dadqd_curr_vec_out_AZ_dqdPE3; dadqd_curr_vec_reg_LX_dqdPE3 = dadqd_curr_vec_out_LX_dqdPE3; dadqd_curr_vec_reg_LY_dqdPE3 = dadqd_curr_vec_out_LY_dqdPE3; dadqd_curr_vec_reg_LZ_dqdPE3 = dadqd_curr_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dvdqd_curr_vec_reg_AX_dqdPE4 = dvdqd_curr_vec_out_AX_dqdPE4; dvdqd_curr_vec_reg_AY_dqdPE4 = dvdqd_curr_vec_out_AY_dqdPE4; dvdqd_curr_vec_reg_AZ_dqdPE4 = dvdqd_curr_vec_out_AZ_dqdPE4; dvdqd_curr_vec_reg_LX_dqdPE4 = dvdqd_curr_vec_out_LX_dqdPE4; dvdqd_curr_vec_reg_LY_dqdPE4 = dvdqd_curr_vec_out_LY_dqdPE4; dvdqd_curr_vec_reg_LZ_dqdPE4 = dvdqd_curr_vec_out_LZ_dqdPE4; 
      dadqd_curr_vec_reg_AX_dqdPE4 = dadqd_curr_vec_out_AX_dqdPE4; dadqd_curr_vec_reg_AY_dqdPE4 = dadqd_curr_vec_out_AY_dqdPE4; dadqd_curr_vec_reg_AZ_dqdPE4 = dadqd_curr_vec_out_AZ_dqdPE4; dadqd_curr_vec_reg_LX_dqdPE4 = dadqd_curr_vec_out_LX_dqdPE4; dadqd_curr_vec_reg_LY_dqdPE4 = dadqd_curr_vec_out_LY_dqdPE4; dadqd_curr_vec_reg_LZ_dqdPE4 = dadqd_curr_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dvdqd_curr_vec_reg_AX_dqdPE5 = dvdqd_curr_vec_out_AX_dqdPE5; dvdqd_curr_vec_reg_AY_dqdPE5 = dvdqd_curr_vec_out_AY_dqdPE5; dvdqd_curr_vec_reg_AZ_dqdPE5 = dvdqd_curr_vec_out_AZ_dqdPE5; dvdqd_curr_vec_reg_LX_dqdPE5 = dvdqd_curr_vec_out_LX_dqdPE5; dvdqd_curr_vec_reg_LY_dqdPE5 = dvdqd_curr_vec_out_LY_dqdPE5; dvdqd_curr_vec_reg_LZ_dqdPE5 = dvdqd_curr_vec_out_LZ_dqdPE5; 
      dadqd_curr_vec_reg_AX_dqdPE5 = dadqd_curr_vec_out_AX_dqdPE5; dadqd_curr_vec_reg_AY_dqdPE5 = dadqd_curr_vec_out_AY_dqdPE5; dadqd_curr_vec_reg_AZ_dqdPE5 = dadqd_curr_vec_out_AZ_dqdPE5; dadqd_curr_vec_reg_LX_dqdPE5 = dadqd_curr_vec_out_LX_dqdPE5; dadqd_curr_vec_reg_LY_dqdPE5 = dadqd_curr_vec_out_LY_dqdPE5; dadqd_curr_vec_reg_LZ_dqdPE5 = dadqd_curr_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dvdqd_curr_vec_reg_AX_dqdPE6 = dvdqd_curr_vec_out_AX_dqdPE6; dvdqd_curr_vec_reg_AY_dqdPE6 = dvdqd_curr_vec_out_AY_dqdPE6; dvdqd_curr_vec_reg_AZ_dqdPE6 = dvdqd_curr_vec_out_AZ_dqdPE6; dvdqd_curr_vec_reg_LX_dqdPE6 = dvdqd_curr_vec_out_LX_dqdPE6; dvdqd_curr_vec_reg_LY_dqdPE6 = dvdqd_curr_vec_out_LY_dqdPE6; dvdqd_curr_vec_reg_LZ_dqdPE6 = dvdqd_curr_vec_out_LZ_dqdPE6; 
      dadqd_curr_vec_reg_AX_dqdPE6 = dadqd_curr_vec_out_AX_dqdPE6; dadqd_curr_vec_reg_AY_dqdPE6 = dadqd_curr_vec_out_AY_dqdPE6; dadqd_curr_vec_reg_AZ_dqdPE6 = dadqd_curr_vec_out_AZ_dqdPE6; dadqd_curr_vec_reg_LX_dqdPE6 = dadqd_curr_vec_out_LX_dqdPE6; dadqd_curr_vec_reg_LY_dqdPE6 = dadqd_curr_vec_out_LY_dqdPE6; dadqd_curr_vec_reg_LZ_dqdPE6 = dadqd_curr_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dvdqd_curr_vec_reg_AX_dqdPE7 = dvdqd_curr_vec_out_AX_dqdPE7; dvdqd_curr_vec_reg_AY_dqdPE7 = dvdqd_curr_vec_out_AY_dqdPE7; dvdqd_curr_vec_reg_AZ_dqdPE7 = dvdqd_curr_vec_out_AZ_dqdPE7; dvdqd_curr_vec_reg_LX_dqdPE7 = dvdqd_curr_vec_out_LX_dqdPE7; dvdqd_curr_vec_reg_LY_dqdPE7 = dvdqd_curr_vec_out_LY_dqdPE7; dvdqd_curr_vec_reg_LZ_dqdPE7 = dvdqd_curr_vec_out_LZ_dqdPE7; 
      dadqd_curr_vec_reg_AX_dqdPE7 = dadqd_curr_vec_out_AX_dqdPE7; dadqd_curr_vec_reg_AY_dqdPE7 = dadqd_curr_vec_out_AY_dqdPE7; dadqd_curr_vec_reg_AZ_dqdPE7 = dadqd_curr_vec_out_AZ_dqdPE7; dadqd_curr_vec_reg_LX_dqdPE7 = dadqd_curr_vec_out_LX_dqdPE7; dadqd_curr_vec_reg_LY_dqdPE7 = dadqd_curr_vec_out_LY_dqdPE7; dadqd_curr_vec_reg_LZ_dqdPE7 = dadqd_curr_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Link 5 Inputs
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 3'd5;
      sinq_val_in_rnea = -32'd48758; cosq_val_in_rnea = 32'd43790;
      qd_val_in_rnea = 32'd28646;
      qdd_val_in_rnea = 32'd1694532;
      v_prev_vec_in_AX_rnea = -32'd30803; v_prev_vec_in_AY_rnea = 32'd125144; v_prev_vec_in_AZ_rnea = 32'd36546; v_prev_vec_in_LX_rnea = -32'd52; v_prev_vec_in_LY_rnea = -32'd1; v_prev_vec_in_LZ_rnea = -32'd12388;
      a_prev_vec_in_AX_rnea = -32'd33423; a_prev_vec_in_AY_rnea = -32'd9612; a_prev_vec_in_AZ_rnea = 32'd233919; a_prev_vec_in_LX_rnea = 32'd52175; a_prev_vec_in_LY_rnea = 32'd574; a_prev_vec_in_LZ_rnea = -32'd43363;
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 0;
      derv_in_dqPE1 = 3'd1;
      sinq_val_in_dqPE1 = 0; cosq_val_in_dqPE1 = 0;
      qd_val_in_dqPE1 = 0;
      v_curr_vec_in_AX_dqPE1 = 0; v_curr_vec_in_AY_dqPE1 = 0; v_curr_vec_in_AZ_dqPE1 = 0; v_curr_vec_in_LX_dqPE1 = 0; v_curr_vec_in_LY_dqPE1 = 0; v_curr_vec_in_LZ_dqPE1 = 0;
      a_curr_vec_in_AX_dqPE1 = 0; a_curr_vec_in_AY_dqPE1 = 0; a_curr_vec_in_AZ_dqPE1 = 0; a_curr_vec_in_LX_dqPE1 = 0; a_curr_vec_in_LY_dqPE1 = 0; a_curr_vec_in_LZ_dqPE1 = 0;
      v_prev_vec_in_AX_dqPE1 = 0; v_prev_vec_in_AY_dqPE1 = 0; v_prev_vec_in_AZ_dqPE1 = 0; v_prev_vec_in_LX_dqPE1 = 0; v_prev_vec_in_LY_dqPE1 = 0; v_prev_vec_in_LZ_dqPE1 = 0;
      a_prev_vec_in_AX_dqPE1 = 0; a_prev_vec_in_AY_dqPE1 = 0; a_prev_vec_in_AZ_dqPE1 = 0; a_prev_vec_in_LX_dqPE1 = 0; a_prev_vec_in_LY_dqPE1 = 0; a_prev_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      link_in_dqPE2 = 3'd4;
      derv_in_dqPE2 = 3'd2;
      sinq_val_in_dqPE2 = -32'd685; cosq_val_in_dqPE2 = 32'd65532;
      qd_val_in_dqPE2 = 32'd36422;
      v_curr_vec_in_AX_dqPE2 = -32'd30803; v_curr_vec_in_AY_dqPE2 = 32'd125144; v_curr_vec_in_AZ_dqPE2 = 32'd36546; v_curr_vec_in_LX_dqPE2 = -32'd52; v_curr_vec_in_LY_dqPE2 = -32'd1; v_curr_vec_in_LZ_dqPE2 = -32'd12388;
      a_curr_vec_in_AX_dqPE2 = -32'd33423; a_curr_vec_in_AY_dqPE2 = -32'd9612; a_curr_vec_in_AZ_dqPE2 = 32'd233920; a_curr_vec_in_LX_dqPE2 = 32'd52175; a_curr_vec_in_LY_dqPE2 = 32'd574; a_curr_vec_in_LZ_dqPE2 = -32'd43363;
      v_prev_vec_in_AX_dqPE2 = -32'd29494; v_prev_vec_in_AY_dqPE2 = -32'd125; v_prev_vec_in_AZ_dqPE2 = 32'd125459; v_prev_vec_in_LX_dqPE2 = -32'd25; v_prev_vec_in_LY_dqPE2 = 32'd6032; v_prev_vec_in_LZ_dqPE2 = 32'd0;
      a_prev_vec_in_AX_dqPE2 = -32'd103246; a_prev_vec_in_AY_dqPE2 = 32'd124234; a_prev_vec_in_AZ_dqPE2 = -32'd25654; a_prev_vec_in_LX_dqPE2 = 32'd25406; a_prev_vec_in_LY_dqPE2 = 32'd21114; a_prev_vec_in_LZ_dqPE2 = 32'd0;
      // dqPE3
      link_in_dqPE3 = 3'd4;
      derv_in_dqPE3 = 3'd3;
      sinq_val_in_dqPE3 = -32'd685; cosq_val_in_dqPE3 = 32'd65532;
      qd_val_in_dqPE3 = 32'd36422;
      v_curr_vec_in_AX_dqPE3 = -32'd30803; v_curr_vec_in_AY_dqPE3 = 32'd125144; v_curr_vec_in_AZ_dqPE3 = 32'd36546; v_curr_vec_in_LX_dqPE3 = -32'd52; v_curr_vec_in_LY_dqPE3 = -32'd1; v_curr_vec_in_LZ_dqPE3 = -32'd12388;
      a_curr_vec_in_AX_dqPE3 = -32'd33423; a_curr_vec_in_AY_dqPE3 = -32'd9612; a_curr_vec_in_AZ_dqPE3 = 32'd233920; a_curr_vec_in_LX_dqPE3 = 32'd52175; a_curr_vec_in_LY_dqPE3 = 32'd574; a_curr_vec_in_LZ_dqPE3 = -32'd43363;
      v_prev_vec_in_AX_dqPE3 = -32'd29494; v_prev_vec_in_AY_dqPE3 = -32'd125; v_prev_vec_in_AZ_dqPE3 = 32'd125459; v_prev_vec_in_LX_dqPE3 = -32'd25; v_prev_vec_in_LY_dqPE3 = 32'd6032; v_prev_vec_in_LZ_dqPE3 = 32'd0;
      a_prev_vec_in_AX_dqPE3 = -32'd103246; a_prev_vec_in_AY_dqPE3 = 32'd124234; a_prev_vec_in_AZ_dqPE3 = -32'd25654; a_prev_vec_in_LX_dqPE3 = 32'd25406; a_prev_vec_in_LY_dqPE3 = 32'd21114; a_prev_vec_in_LZ_dqPE3 = 32'd0;
      // dqPE4
      link_in_dqPE4 = 3'd4;
      derv_in_dqPE4 = 3'd4;
      sinq_val_in_dqPE4 = -32'd685; cosq_val_in_dqPE4 = 32'd65532;
      qd_val_in_dqPE4 = 32'd36422;
      v_curr_vec_in_AX_dqPE4 = -32'd30803; v_curr_vec_in_AY_dqPE4 = 32'd125144; v_curr_vec_in_AZ_dqPE4 = 32'd36546; v_curr_vec_in_LX_dqPE4 = -32'd52; v_curr_vec_in_LY_dqPE4 = -32'd1; v_curr_vec_in_LZ_dqPE4 = -32'd12388;
      a_curr_vec_in_AX_dqPE4 = -32'd33423; a_curr_vec_in_AY_dqPE4 = -32'd9612; a_curr_vec_in_AZ_dqPE4 = 32'd233920; a_curr_vec_in_LX_dqPE4 = 32'd52175; a_curr_vec_in_LY_dqPE4 = 32'd574; a_curr_vec_in_LZ_dqPE4 = -32'd43363;
      v_prev_vec_in_AX_dqPE4 = -32'd29494; v_prev_vec_in_AY_dqPE4 = -32'd125; v_prev_vec_in_AZ_dqPE4 = 32'd125459; v_prev_vec_in_LX_dqPE4 = -32'd25; v_prev_vec_in_LY_dqPE4 = 32'd6032; v_prev_vec_in_LZ_dqPE4 = 32'd0;
      a_prev_vec_in_AX_dqPE4 = -32'd103246; a_prev_vec_in_AY_dqPE4 = 32'd124234; a_prev_vec_in_AZ_dqPE4 = -32'd25654; a_prev_vec_in_LX_dqPE4 = 32'd25406; a_prev_vec_in_LY_dqPE4 = 32'd21114; a_prev_vec_in_LZ_dqPE4 = 32'd0;
      // dqPE5
      link_in_dqPE5 = 3'd4;
      derv_in_dqPE5 = 3'd5;
      sinq_val_in_dqPE5 = -32'd685; cosq_val_in_dqPE5 = 32'd65532;
      qd_val_in_dqPE5 = 32'd36422;
      v_curr_vec_in_AX_dqPE5 = -32'd30803; v_curr_vec_in_AY_dqPE5 = 32'd125144; v_curr_vec_in_AZ_dqPE5 = 32'd36546; v_curr_vec_in_LX_dqPE5 = -32'd52; v_curr_vec_in_LY_dqPE5 = -32'd1; v_curr_vec_in_LZ_dqPE5 = -32'd12388;
      a_curr_vec_in_AX_dqPE5 = -32'd33423; a_curr_vec_in_AY_dqPE5 = -32'd9612; a_curr_vec_in_AZ_dqPE5 = 32'd233920; a_curr_vec_in_LX_dqPE5 = 32'd52175; a_curr_vec_in_LY_dqPE5 = 32'd574; a_curr_vec_in_LZ_dqPE5 = -32'd43363;
      v_prev_vec_in_AX_dqPE5 = -32'd29494; v_prev_vec_in_AY_dqPE5 = -32'd125; v_prev_vec_in_AZ_dqPE5 = 32'd125459; v_prev_vec_in_LX_dqPE5 = -32'd25; v_prev_vec_in_LY_dqPE5 = 32'd6032; v_prev_vec_in_LZ_dqPE5 = 32'd0;
      a_prev_vec_in_AX_dqPE5 = -32'd103246; a_prev_vec_in_AY_dqPE5 = 32'd124234; a_prev_vec_in_AZ_dqPE5 = -32'd25654; a_prev_vec_in_LX_dqPE5 = 32'd25406; a_prev_vec_in_LY_dqPE5 = 32'd21114; a_prev_vec_in_LZ_dqPE5 = 32'd0;
      // dqPE6
      link_in_dqPE6 = 3'd4;
      derv_in_dqPE6 = 3'd6;
      sinq_val_in_dqPE6 = -32'd685; cosq_val_in_dqPE6 = 32'd65532;
      qd_val_in_dqPE6 = 32'd36422;
      v_curr_vec_in_AX_dqPE6 = -32'd30803; v_curr_vec_in_AY_dqPE6 = 32'd125144; v_curr_vec_in_AZ_dqPE6 = 32'd36546; v_curr_vec_in_LX_dqPE6 = -32'd52; v_curr_vec_in_LY_dqPE6 = -32'd1; v_curr_vec_in_LZ_dqPE6 = -32'd12388;
      a_curr_vec_in_AX_dqPE6 = -32'd33423; a_curr_vec_in_AY_dqPE6 = -32'd9612; a_curr_vec_in_AZ_dqPE6 = 32'd233920; a_curr_vec_in_LX_dqPE6 = 32'd52175; a_curr_vec_in_LY_dqPE6 = 32'd574; a_curr_vec_in_LZ_dqPE6 = -32'd43363;
      v_prev_vec_in_AX_dqPE6 = -32'd29494; v_prev_vec_in_AY_dqPE6 = -32'd125; v_prev_vec_in_AZ_dqPE6 = 32'd125459; v_prev_vec_in_LX_dqPE6 = -32'd25; v_prev_vec_in_LY_dqPE6 = 32'd6032; v_prev_vec_in_LZ_dqPE6 = 32'd0;
      a_prev_vec_in_AX_dqPE6 = -32'd103246; a_prev_vec_in_AY_dqPE6 = 32'd124234; a_prev_vec_in_AZ_dqPE6 = -32'd25654; a_prev_vec_in_LX_dqPE6 = 32'd25406; a_prev_vec_in_LY_dqPE6 = 32'd21114; a_prev_vec_in_LZ_dqPE6 = 32'd0;
      // dqPE7
      link_in_dqPE7 = 3'd4;
      derv_in_dqPE7 = 3'd7;
      sinq_val_in_dqPE7 = -32'd685; cosq_val_in_dqPE7 = 32'd65532;
      qd_val_in_dqPE7 = 32'd36422;
      v_curr_vec_in_AX_dqPE7 = -32'd30803; v_curr_vec_in_AY_dqPE7 = 32'd125144; v_curr_vec_in_AZ_dqPE7 = 32'd36546; v_curr_vec_in_LX_dqPE7 = -32'd52; v_curr_vec_in_LY_dqPE7 = -32'd1; v_curr_vec_in_LZ_dqPE7 = -32'd12388;
      a_curr_vec_in_AX_dqPE7 = -32'd33423; a_curr_vec_in_AY_dqPE7 = -32'd9612; a_curr_vec_in_AZ_dqPE7 = 32'd233920; a_curr_vec_in_LX_dqPE7 = 32'd52175; a_curr_vec_in_LY_dqPE7 = 32'd574; a_curr_vec_in_LZ_dqPE7 = -32'd43363;
      v_prev_vec_in_AX_dqPE7 = -32'd29494; v_prev_vec_in_AY_dqPE7 = -32'd125; v_prev_vec_in_AZ_dqPE7 = 32'd125459; v_prev_vec_in_LX_dqPE7 = -32'd25; v_prev_vec_in_LY_dqPE7 = 32'd6032; v_prev_vec_in_LZ_dqPE7 = 32'd0;
      a_prev_vec_in_AX_dqPE7 = -32'd103246; a_prev_vec_in_AY_dqPE7 = 32'd124234; a_prev_vec_in_AZ_dqPE7 = -32'd25654; a_prev_vec_in_LX_dqPE7 = 32'd25406; a_prev_vec_in_LY_dqPE7 = 32'd21114; a_prev_vec_in_LZ_dqPE7 = 32'd0;
      // External dv,da
      // dqPE1
      dvdq_prev_vec_in_AX_dqPE1 = dvdq_curr_vec_reg_AX_dqPE1; dvdq_prev_vec_in_AY_dqPE1 = dvdq_curr_vec_reg_AY_dqPE1; dvdq_prev_vec_in_AZ_dqPE1 = dvdq_curr_vec_reg_AZ_dqPE1; dvdq_prev_vec_in_LX_dqPE1 = dvdq_curr_vec_reg_LX_dqPE1; dvdq_prev_vec_in_LY_dqPE1 = dvdq_curr_vec_reg_LY_dqPE1; dvdq_prev_vec_in_LZ_dqPE1 = dvdq_curr_vec_reg_LZ_dqPE1; 
      dadq_prev_vec_in_AX_dqPE1 = dadq_curr_vec_reg_AX_dqPE1; dadq_prev_vec_in_AY_dqPE1 = dadq_curr_vec_reg_AY_dqPE1; dadq_prev_vec_in_AZ_dqPE1 = dadq_curr_vec_reg_AZ_dqPE1; dadq_prev_vec_in_LX_dqPE1 = dadq_curr_vec_reg_LX_dqPE1; dadq_prev_vec_in_LY_dqPE1 = dadq_curr_vec_reg_LY_dqPE1; dadq_prev_vec_in_LZ_dqPE1 = dadq_curr_vec_reg_LZ_dqPE1; 
      // dqPE2
      dvdq_prev_vec_in_AX_dqPE2 = dvdq_curr_vec_reg_AX_dqPE2; dvdq_prev_vec_in_AY_dqPE2 = dvdq_curr_vec_reg_AY_dqPE2; dvdq_prev_vec_in_AZ_dqPE2 = dvdq_curr_vec_reg_AZ_dqPE2; dvdq_prev_vec_in_LX_dqPE2 = dvdq_curr_vec_reg_LX_dqPE2; dvdq_prev_vec_in_LY_dqPE2 = dvdq_curr_vec_reg_LY_dqPE2; dvdq_prev_vec_in_LZ_dqPE2 = dvdq_curr_vec_reg_LZ_dqPE2; 
      dadq_prev_vec_in_AX_dqPE2 = dadq_curr_vec_reg_AX_dqPE2; dadq_prev_vec_in_AY_dqPE2 = dadq_curr_vec_reg_AY_dqPE2; dadq_prev_vec_in_AZ_dqPE2 = dadq_curr_vec_reg_AZ_dqPE2; dadq_prev_vec_in_LX_dqPE2 = dadq_curr_vec_reg_LX_dqPE2; dadq_prev_vec_in_LY_dqPE2 = dadq_curr_vec_reg_LY_dqPE2; dadq_prev_vec_in_LZ_dqPE2 = dadq_curr_vec_reg_LZ_dqPE2; 
      // dqPE3
      dvdq_prev_vec_in_AX_dqPE3 = dvdq_curr_vec_reg_AX_dqPE3; dvdq_prev_vec_in_AY_dqPE3 = dvdq_curr_vec_reg_AY_dqPE3; dvdq_prev_vec_in_AZ_dqPE3 = dvdq_curr_vec_reg_AZ_dqPE3; dvdq_prev_vec_in_LX_dqPE3 = dvdq_curr_vec_reg_LX_dqPE3; dvdq_prev_vec_in_LY_dqPE3 = dvdq_curr_vec_reg_LY_dqPE3; dvdq_prev_vec_in_LZ_dqPE3 = dvdq_curr_vec_reg_LZ_dqPE3; 
      dadq_prev_vec_in_AX_dqPE3 = dadq_curr_vec_reg_AX_dqPE3; dadq_prev_vec_in_AY_dqPE3 = dadq_curr_vec_reg_AY_dqPE3; dadq_prev_vec_in_AZ_dqPE3 = dadq_curr_vec_reg_AZ_dqPE3; dadq_prev_vec_in_LX_dqPE3 = dadq_curr_vec_reg_LX_dqPE3; dadq_prev_vec_in_LY_dqPE3 = dadq_curr_vec_reg_LY_dqPE3; dadq_prev_vec_in_LZ_dqPE3 = dadq_curr_vec_reg_LZ_dqPE3; 
      // dqPE4
      dvdq_prev_vec_in_AX_dqPE4 = dvdq_curr_vec_reg_AX_dqPE4; dvdq_prev_vec_in_AY_dqPE4 = dvdq_curr_vec_reg_AY_dqPE4; dvdq_prev_vec_in_AZ_dqPE4 = dvdq_curr_vec_reg_AZ_dqPE4; dvdq_prev_vec_in_LX_dqPE4 = dvdq_curr_vec_reg_LX_dqPE4; dvdq_prev_vec_in_LY_dqPE4 = dvdq_curr_vec_reg_LY_dqPE4; dvdq_prev_vec_in_LZ_dqPE4 = dvdq_curr_vec_reg_LZ_dqPE4; 
      dadq_prev_vec_in_AX_dqPE4 = dadq_curr_vec_reg_AX_dqPE4; dadq_prev_vec_in_AY_dqPE4 = dadq_curr_vec_reg_AY_dqPE4; dadq_prev_vec_in_AZ_dqPE4 = dadq_curr_vec_reg_AZ_dqPE4; dadq_prev_vec_in_LX_dqPE4 = dadq_curr_vec_reg_LX_dqPE4; dadq_prev_vec_in_LY_dqPE4 = dadq_curr_vec_reg_LY_dqPE4; dadq_prev_vec_in_LZ_dqPE4 = dadq_curr_vec_reg_LZ_dqPE4; 
      // dqPE5
      dvdq_prev_vec_in_AX_dqPE5 = dvdq_curr_vec_reg_AX_dqPE5; dvdq_prev_vec_in_AY_dqPE5 = dvdq_curr_vec_reg_AY_dqPE5; dvdq_prev_vec_in_AZ_dqPE5 = dvdq_curr_vec_reg_AZ_dqPE5; dvdq_prev_vec_in_LX_dqPE5 = dvdq_curr_vec_reg_LX_dqPE5; dvdq_prev_vec_in_LY_dqPE5 = dvdq_curr_vec_reg_LY_dqPE5; dvdq_prev_vec_in_LZ_dqPE5 = dvdq_curr_vec_reg_LZ_dqPE5; 
      dadq_prev_vec_in_AX_dqPE5 = dadq_curr_vec_reg_AX_dqPE5; dadq_prev_vec_in_AY_dqPE5 = dadq_curr_vec_reg_AY_dqPE5; dadq_prev_vec_in_AZ_dqPE5 = dadq_curr_vec_reg_AZ_dqPE5; dadq_prev_vec_in_LX_dqPE5 = dadq_curr_vec_reg_LX_dqPE5; dadq_prev_vec_in_LY_dqPE5 = dadq_curr_vec_reg_LY_dqPE5; dadq_prev_vec_in_LZ_dqPE5 = dadq_curr_vec_reg_LZ_dqPE5; 
      // dqPE6
      dvdq_prev_vec_in_AX_dqPE6 = dvdq_curr_vec_reg_AX_dqPE6; dvdq_prev_vec_in_AY_dqPE6 = dvdq_curr_vec_reg_AY_dqPE6; dvdq_prev_vec_in_AZ_dqPE6 = dvdq_curr_vec_reg_AZ_dqPE6; dvdq_prev_vec_in_LX_dqPE6 = dvdq_curr_vec_reg_LX_dqPE6; dvdq_prev_vec_in_LY_dqPE6 = dvdq_curr_vec_reg_LY_dqPE6; dvdq_prev_vec_in_LZ_dqPE6 = dvdq_curr_vec_reg_LZ_dqPE6; 
      dadq_prev_vec_in_AX_dqPE6 = dadq_curr_vec_reg_AX_dqPE6; dadq_prev_vec_in_AY_dqPE6 = dadq_curr_vec_reg_AY_dqPE6; dadq_prev_vec_in_AZ_dqPE6 = dadq_curr_vec_reg_AZ_dqPE6; dadq_prev_vec_in_LX_dqPE6 = dadq_curr_vec_reg_LX_dqPE6; dadq_prev_vec_in_LY_dqPE6 = dadq_curr_vec_reg_LY_dqPE6; dadq_prev_vec_in_LZ_dqPE6 = dadq_curr_vec_reg_LZ_dqPE6; 
      // dqPE7
      dvdq_prev_vec_in_AX_dqPE7 = dvdq_curr_vec_reg_AX_dqPE7; dvdq_prev_vec_in_AY_dqPE7 = dvdq_curr_vec_reg_AY_dqPE7; dvdq_prev_vec_in_AZ_dqPE7 = dvdq_curr_vec_reg_AZ_dqPE7; dvdq_prev_vec_in_LX_dqPE7 = dvdq_curr_vec_reg_LX_dqPE7; dvdq_prev_vec_in_LY_dqPE7 = dvdq_curr_vec_reg_LY_dqPE7; dvdq_prev_vec_in_LZ_dqPE7 = dvdq_curr_vec_reg_LZ_dqPE7; 
      dadq_prev_vec_in_AX_dqPE7 = dadq_curr_vec_reg_AX_dqPE7; dadq_prev_vec_in_AY_dqPE7 = dadq_curr_vec_reg_AY_dqPE7; dadq_prev_vec_in_AZ_dqPE7 = dadq_curr_vec_reg_AZ_dqPE7; dadq_prev_vec_in_LX_dqPE7 = dadq_curr_vec_reg_LX_dqPE7; dadq_prev_vec_in_LY_dqPE7 = dadq_curr_vec_reg_LY_dqPE7; dadq_prev_vec_in_LZ_dqPE7 = dadq_curr_vec_reg_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 3'd4;
      derv_in_dqdPE1 = 3'd1;
      sinq_val_in_dqdPE1 = -32'd685; cosq_val_in_dqdPE1 = 32'd65532;
      qd_val_in_dqdPE1 = 32'd36422;
      v_curr_vec_in_AX_dqdPE1 = -32'd30803; v_curr_vec_in_AY_dqdPE1 = 32'd125144; v_curr_vec_in_AZ_dqdPE1 = 32'd36546; v_curr_vec_in_LX_dqdPE1 = -32'd52; v_curr_vec_in_LY_dqdPE1 = -32'd1; v_curr_vec_in_LZ_dqdPE1 = -32'd12388;
      a_curr_vec_in_AX_dqdPE1 = -32'd33423; a_curr_vec_in_AY_dqdPE1 = -32'd9612; a_curr_vec_in_AZ_dqdPE1 = 32'd233920; a_curr_vec_in_LX_dqdPE1 = 32'd52175; a_curr_vec_in_LY_dqdPE1 = 32'd574; a_curr_vec_in_LZ_dqdPE1 = -32'd43363;
      // dqdPE2
      link_in_dqdPE2 = 3'd4;
      derv_in_dqdPE2 = 3'd2;
      sinq_val_in_dqdPE2 = -32'd685; cosq_val_in_dqdPE2 = 32'd65532;
      qd_val_in_dqdPE2 = 32'd36422;
      v_curr_vec_in_AX_dqdPE2 = -32'd30803; v_curr_vec_in_AY_dqdPE2 = 32'd125144; v_curr_vec_in_AZ_dqdPE2 = 32'd36546; v_curr_vec_in_LX_dqdPE2 = -32'd52; v_curr_vec_in_LY_dqdPE2 = -32'd1; v_curr_vec_in_LZ_dqdPE2 = -32'd12388;
      a_curr_vec_in_AX_dqdPE2 = -32'd33423; a_curr_vec_in_AY_dqdPE2 = -32'd9612; a_curr_vec_in_AZ_dqdPE2 = 32'd233920; a_curr_vec_in_LX_dqdPE2 = 32'd52175; a_curr_vec_in_LY_dqdPE2 = 32'd574; a_curr_vec_in_LZ_dqdPE2 = -32'd43363;
      // dqdPE3
      link_in_dqdPE3 = 3'd4;
      derv_in_dqdPE3 = 3'd3;
      sinq_val_in_dqdPE3 = -32'd685; cosq_val_in_dqdPE3 = 32'd65532;
      qd_val_in_dqdPE3 = 32'd36422;
      v_curr_vec_in_AX_dqdPE3 = -32'd30803; v_curr_vec_in_AY_dqdPE3 = 32'd125144; v_curr_vec_in_AZ_dqdPE3 = 32'd36546; v_curr_vec_in_LX_dqdPE3 = -32'd52; v_curr_vec_in_LY_dqdPE3 = -32'd1; v_curr_vec_in_LZ_dqdPE3 = -32'd12388;
      a_curr_vec_in_AX_dqdPE3 = -32'd33423; a_curr_vec_in_AY_dqdPE3 = -32'd9612; a_curr_vec_in_AZ_dqdPE3 = 32'd233920; a_curr_vec_in_LX_dqdPE3 = 32'd52175; a_curr_vec_in_LY_dqdPE3 = 32'd574; a_curr_vec_in_LZ_dqdPE3 = -32'd43363;
      // dqdPE4
      link_in_dqdPE4 = 3'd4;
      derv_in_dqdPE4 = 3'd4;
      sinq_val_in_dqdPE4 = -32'd685; cosq_val_in_dqdPE4 = 32'd65532;
      qd_val_in_dqdPE4 = 32'd36422;
      v_curr_vec_in_AX_dqdPE4 = -32'd30803; v_curr_vec_in_AY_dqdPE4 = 32'd125144; v_curr_vec_in_AZ_dqdPE4 = 32'd36546; v_curr_vec_in_LX_dqdPE4 = -32'd52; v_curr_vec_in_LY_dqdPE4 = -32'd1; v_curr_vec_in_LZ_dqdPE4 = -32'd12388;
      a_curr_vec_in_AX_dqdPE4 = -32'd33423; a_curr_vec_in_AY_dqdPE4 = -32'd9612; a_curr_vec_in_AZ_dqdPE4 = 32'd233920; a_curr_vec_in_LX_dqdPE4 = 32'd52175; a_curr_vec_in_LY_dqdPE4 = 32'd574; a_curr_vec_in_LZ_dqdPE4 = -32'd43363;
      // dqdPE5
      link_in_dqdPE5 = 3'd4;
      derv_in_dqdPE5 = 3'd5;
      sinq_val_in_dqdPE5 = -32'd685; cosq_val_in_dqdPE5 = 32'd65532;
      qd_val_in_dqdPE5 = 32'd36422;
      v_curr_vec_in_AX_dqdPE5 = -32'd30803; v_curr_vec_in_AY_dqdPE5 = 32'd125144; v_curr_vec_in_AZ_dqdPE5 = 32'd36546; v_curr_vec_in_LX_dqdPE5 = -32'd52; v_curr_vec_in_LY_dqdPE5 = -32'd1; v_curr_vec_in_LZ_dqdPE5 = -32'd12388;
      a_curr_vec_in_AX_dqdPE5 = -32'd33423; a_curr_vec_in_AY_dqdPE5 = -32'd9612; a_curr_vec_in_AZ_dqdPE5 = 32'd233920; a_curr_vec_in_LX_dqdPE5 = 32'd52175; a_curr_vec_in_LY_dqdPE5 = 32'd574; a_curr_vec_in_LZ_dqdPE5 = -32'd43363;
      // dqdPE6
      link_in_dqdPE6 = 3'd4;
      derv_in_dqdPE6 = 3'd6;
      sinq_val_in_dqdPE6 = -32'd685; cosq_val_in_dqdPE6 = 32'd65532;
      qd_val_in_dqdPE6 = 32'd36422;
      v_curr_vec_in_AX_dqdPE6 = -32'd30803; v_curr_vec_in_AY_dqdPE6 = 32'd125144; v_curr_vec_in_AZ_dqdPE6 = 32'd36546; v_curr_vec_in_LX_dqdPE6 = -32'd52; v_curr_vec_in_LY_dqdPE6 = -32'd1; v_curr_vec_in_LZ_dqdPE6 = -32'd12388;
      a_curr_vec_in_AX_dqdPE6 = -32'd33423; a_curr_vec_in_AY_dqdPE6 = -32'd9612; a_curr_vec_in_AZ_dqdPE6 = 32'd233920; a_curr_vec_in_LX_dqdPE6 = 32'd52175; a_curr_vec_in_LY_dqdPE6 = 32'd574; a_curr_vec_in_LZ_dqdPE6 = -32'd43363;
      // dqdPE7
      link_in_dqdPE7 = 3'd4;
      derv_in_dqdPE7 = 3'd7;
      sinq_val_in_dqdPE7 = -32'd685; cosq_val_in_dqdPE7 = 32'd65532;
      qd_val_in_dqdPE7 = 32'd36422;
      v_curr_vec_in_AX_dqdPE7 = -32'd30803; v_curr_vec_in_AY_dqdPE7 = 32'd125144; v_curr_vec_in_AZ_dqdPE7 = 32'd36546; v_curr_vec_in_LX_dqdPE7 = -32'd52; v_curr_vec_in_LY_dqdPE7 = -32'd1; v_curr_vec_in_LZ_dqdPE7 = -32'd12388;
      a_curr_vec_in_AX_dqdPE7 = -32'd33423; a_curr_vec_in_AY_dqdPE7 = -32'd9612; a_curr_vec_in_AZ_dqdPE7 = 32'd233920; a_curr_vec_in_LX_dqdPE7 = 32'd52175; a_curr_vec_in_LY_dqdPE7 = 32'd574; a_curr_vec_in_LZ_dqdPE7 = -32'd43363;
      // External dv,da
      // dqdPE1
      dvdqd_prev_vec_in_AX_dqdPE1 = dvdqd_curr_vec_reg_AX_dqdPE1; dvdqd_prev_vec_in_AY_dqdPE1 = dvdqd_curr_vec_reg_AY_dqdPE1; dvdqd_prev_vec_in_AZ_dqdPE1 = dvdqd_curr_vec_reg_AZ_dqdPE1; dvdqd_prev_vec_in_LX_dqdPE1 = dvdqd_curr_vec_reg_LX_dqdPE1; dvdqd_prev_vec_in_LY_dqdPE1 = dvdqd_curr_vec_reg_LY_dqdPE1; dvdqd_prev_vec_in_LZ_dqdPE1 = dvdqd_curr_vec_reg_LZ_dqdPE1; 
      dadqd_prev_vec_in_AX_dqdPE1 = dadqd_curr_vec_reg_AX_dqdPE1; dadqd_prev_vec_in_AY_dqdPE1 = dadqd_curr_vec_reg_AY_dqdPE1; dadqd_prev_vec_in_AZ_dqdPE1 = dadqd_curr_vec_reg_AZ_dqdPE1; dadqd_prev_vec_in_LX_dqdPE1 = dadqd_curr_vec_reg_LX_dqdPE1; dadqd_prev_vec_in_LY_dqdPE1 = dadqd_curr_vec_reg_LY_dqdPE1; dadqd_prev_vec_in_LZ_dqdPE1 = dadqd_curr_vec_reg_LZ_dqdPE1; 
      // dqdPE2
      dvdqd_prev_vec_in_AX_dqdPE2 = dvdqd_curr_vec_reg_AX_dqdPE2; dvdqd_prev_vec_in_AY_dqdPE2 = dvdqd_curr_vec_reg_AY_dqdPE2; dvdqd_prev_vec_in_AZ_dqdPE2 = dvdqd_curr_vec_reg_AZ_dqdPE2; dvdqd_prev_vec_in_LX_dqdPE2 = dvdqd_curr_vec_reg_LX_dqdPE2; dvdqd_prev_vec_in_LY_dqdPE2 = dvdqd_curr_vec_reg_LY_dqdPE2; dvdqd_prev_vec_in_LZ_dqdPE2 = dvdqd_curr_vec_reg_LZ_dqdPE2; 
      dadqd_prev_vec_in_AX_dqdPE2 = dadqd_curr_vec_reg_AX_dqdPE2; dadqd_prev_vec_in_AY_dqdPE2 = dadqd_curr_vec_reg_AY_dqdPE2; dadqd_prev_vec_in_AZ_dqdPE2 = dadqd_curr_vec_reg_AZ_dqdPE2; dadqd_prev_vec_in_LX_dqdPE2 = dadqd_curr_vec_reg_LX_dqdPE2; dadqd_prev_vec_in_LY_dqdPE2 = dadqd_curr_vec_reg_LY_dqdPE2; dadqd_prev_vec_in_LZ_dqdPE2 = dadqd_curr_vec_reg_LZ_dqdPE2; 
      // dqdPE3
      dvdqd_prev_vec_in_AX_dqdPE3 = dvdqd_curr_vec_reg_AX_dqdPE3; dvdqd_prev_vec_in_AY_dqdPE3 = dvdqd_curr_vec_reg_AY_dqdPE3; dvdqd_prev_vec_in_AZ_dqdPE3 = dvdqd_curr_vec_reg_AZ_dqdPE3; dvdqd_prev_vec_in_LX_dqdPE3 = dvdqd_curr_vec_reg_LX_dqdPE3; dvdqd_prev_vec_in_LY_dqdPE3 = dvdqd_curr_vec_reg_LY_dqdPE3; dvdqd_prev_vec_in_LZ_dqdPE3 = dvdqd_curr_vec_reg_LZ_dqdPE3; 
      dadqd_prev_vec_in_AX_dqdPE3 = dadqd_curr_vec_reg_AX_dqdPE3; dadqd_prev_vec_in_AY_dqdPE3 = dadqd_curr_vec_reg_AY_dqdPE3; dadqd_prev_vec_in_AZ_dqdPE3 = dadqd_curr_vec_reg_AZ_dqdPE3; dadqd_prev_vec_in_LX_dqdPE3 = dadqd_curr_vec_reg_LX_dqdPE3; dadqd_prev_vec_in_LY_dqdPE3 = dadqd_curr_vec_reg_LY_dqdPE3; dadqd_prev_vec_in_LZ_dqdPE3 = dadqd_curr_vec_reg_LZ_dqdPE3; 
      // dqdPE4
      dvdqd_prev_vec_in_AX_dqdPE4 = dvdqd_curr_vec_reg_AX_dqdPE4; dvdqd_prev_vec_in_AY_dqdPE4 = dvdqd_curr_vec_reg_AY_dqdPE4; dvdqd_prev_vec_in_AZ_dqdPE4 = dvdqd_curr_vec_reg_AZ_dqdPE4; dvdqd_prev_vec_in_LX_dqdPE4 = dvdqd_curr_vec_reg_LX_dqdPE4; dvdqd_prev_vec_in_LY_dqdPE4 = dvdqd_curr_vec_reg_LY_dqdPE4; dvdqd_prev_vec_in_LZ_dqdPE4 = dvdqd_curr_vec_reg_LZ_dqdPE4; 
      dadqd_prev_vec_in_AX_dqdPE4 = dadqd_curr_vec_reg_AX_dqdPE4; dadqd_prev_vec_in_AY_dqdPE4 = dadqd_curr_vec_reg_AY_dqdPE4; dadqd_prev_vec_in_AZ_dqdPE4 = dadqd_curr_vec_reg_AZ_dqdPE4; dadqd_prev_vec_in_LX_dqdPE4 = dadqd_curr_vec_reg_LX_dqdPE4; dadqd_prev_vec_in_LY_dqdPE4 = dadqd_curr_vec_reg_LY_dqdPE4; dadqd_prev_vec_in_LZ_dqdPE4 = dadqd_curr_vec_reg_LZ_dqdPE4; 
      // dqdPE5
      dvdqd_prev_vec_in_AX_dqdPE5 = dvdqd_curr_vec_reg_AX_dqdPE5; dvdqd_prev_vec_in_AY_dqdPE5 = dvdqd_curr_vec_reg_AY_dqdPE5; dvdqd_prev_vec_in_AZ_dqdPE5 = dvdqd_curr_vec_reg_AZ_dqdPE5; dvdqd_prev_vec_in_LX_dqdPE5 = dvdqd_curr_vec_reg_LX_dqdPE5; dvdqd_prev_vec_in_LY_dqdPE5 = dvdqd_curr_vec_reg_LY_dqdPE5; dvdqd_prev_vec_in_LZ_dqdPE5 = dvdqd_curr_vec_reg_LZ_dqdPE5; 
      dadqd_prev_vec_in_AX_dqdPE5 = dadqd_curr_vec_reg_AX_dqdPE5; dadqd_prev_vec_in_AY_dqdPE5 = dadqd_curr_vec_reg_AY_dqdPE5; dadqd_prev_vec_in_AZ_dqdPE5 = dadqd_curr_vec_reg_AZ_dqdPE5; dadqd_prev_vec_in_LX_dqdPE5 = dadqd_curr_vec_reg_LX_dqdPE5; dadqd_prev_vec_in_LY_dqdPE5 = dadqd_curr_vec_reg_LY_dqdPE5; dadqd_prev_vec_in_LZ_dqdPE5 = dadqd_curr_vec_reg_LZ_dqdPE5; 
      // dqdPE6
      dvdqd_prev_vec_in_AX_dqdPE6 = dvdqd_curr_vec_reg_AX_dqdPE6; dvdqd_prev_vec_in_AY_dqdPE6 = dvdqd_curr_vec_reg_AY_dqdPE6; dvdqd_prev_vec_in_AZ_dqdPE6 = dvdqd_curr_vec_reg_AZ_dqdPE6; dvdqd_prev_vec_in_LX_dqdPE6 = dvdqd_curr_vec_reg_LX_dqdPE6; dvdqd_prev_vec_in_LY_dqdPE6 = dvdqd_curr_vec_reg_LY_dqdPE6; dvdqd_prev_vec_in_LZ_dqdPE6 = dvdqd_curr_vec_reg_LZ_dqdPE6; 
      dadqd_prev_vec_in_AX_dqdPE6 = dadqd_curr_vec_reg_AX_dqdPE6; dadqd_prev_vec_in_AY_dqdPE6 = dadqd_curr_vec_reg_AY_dqdPE6; dadqd_prev_vec_in_AZ_dqdPE6 = dadqd_curr_vec_reg_AZ_dqdPE6; dadqd_prev_vec_in_LX_dqdPE6 = dadqd_curr_vec_reg_LX_dqdPE6; dadqd_prev_vec_in_LY_dqdPE6 = dadqd_curr_vec_reg_LY_dqdPE6; dadqd_prev_vec_in_LZ_dqdPE6 = dadqd_curr_vec_reg_LZ_dqdPE6; 
      // dqdPE7
      dvdqd_prev_vec_in_AX_dqdPE7 = dvdqd_curr_vec_reg_AX_dqdPE7; dvdqd_prev_vec_in_AY_dqdPE7 = dvdqd_curr_vec_reg_AY_dqdPE7; dvdqd_prev_vec_in_AZ_dqdPE7 = dvdqd_curr_vec_reg_AZ_dqdPE7; dvdqd_prev_vec_in_LX_dqdPE7 = dvdqd_curr_vec_reg_LX_dqdPE7; dvdqd_prev_vec_in_LY_dqdPE7 = dvdqd_curr_vec_reg_LY_dqdPE7; dvdqd_prev_vec_in_LZ_dqdPE7 = dvdqd_curr_vec_reg_LZ_dqdPE7; 
      dadqd_prev_vec_in_AX_dqdPE7 = dadqd_curr_vec_reg_AX_dqdPE7; dadqd_prev_vec_in_AY_dqdPE7 = dadqd_curr_vec_reg_AY_dqdPE7; dadqd_prev_vec_in_AZ_dqdPE7 = dadqd_curr_vec_reg_AZ_dqdPE7; dadqd_prev_vec_in_LX_dqdPE7 = dadqd_curr_vec_reg_LX_dqdPE7; dadqd_prev_vec_in_LY_dqdPE7 = dadqd_curr_vec_reg_LY_dqdPE7; dadqd_prev_vec_in_LZ_dqdPE7 = dadqd_curr_vec_reg_LZ_dqdPE7; 
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
      $display ("// Link 5 RNEA");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",-5305, 5863, 7667, 36575, 9374, -25154);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_curr_vec_out_AX_rnea,f_curr_vec_out_AY_rnea,f_curr_vec_out_AZ_rnea,f_curr_vec_out_LX_rnea,f_curr_vec_out_LY_rnea,f_curr_vec_out_LZ_rnea);
      $display ("//-------------------------------------------------------------------------------------------------------");
      $display ("// Link 4 Derivatives");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 826, 8949, 1941, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -2678, 4680, 1622, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 5904, -12157, -6891, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -76136, 136829, 35836, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -55811, -9425, -53266, 0, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 3436, 89127, 1368, 0, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AX_dqPE1,dfdq_curr_vec_out_AX_dqPE2,dfdq_curr_vec_out_AX_dqPE3,dfdq_curr_vec_out_AX_dqPE4,dfdq_curr_vec_out_AX_dqPE5,dfdq_curr_vec_out_AX_dqPE6,dfdq_curr_vec_out_AX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AY_dqPE1,dfdq_curr_vec_out_AY_dqPE2,dfdq_curr_vec_out_AY_dqPE3,dfdq_curr_vec_out_AY_dqPE4,dfdq_curr_vec_out_AY_dqPE5,dfdq_curr_vec_out_AY_dqPE6,dfdq_curr_vec_out_AY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AZ_dqPE1,dfdq_curr_vec_out_AZ_dqPE2,dfdq_curr_vec_out_AZ_dqPE3,dfdq_curr_vec_out_AZ_dqPE4,dfdq_curr_vec_out_AZ_dqPE5,dfdq_curr_vec_out_AZ_dqPE6,dfdq_curr_vec_out_AZ_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LX_dqPE1,dfdq_curr_vec_out_LX_dqPE2,dfdq_curr_vec_out_LX_dqPE3,dfdq_curr_vec_out_LX_dqPE4,dfdq_curr_vec_out_LX_dqPE5,dfdq_curr_vec_out_LX_dqPE6,dfdq_curr_vec_out_LX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LY_dqPE1,dfdq_curr_vec_out_LY_dqPE2,dfdq_curr_vec_out_LY_dqPE3,dfdq_curr_vec_out_LY_dqPE4,dfdq_curr_vec_out_LY_dqPE5,dfdq_curr_vec_out_LY_dqPE6,dfdq_curr_vec_out_LY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LZ_dqPE1,dfdq_curr_vec_out_LZ_dqPE2,dfdq_curr_vec_out_LZ_dqPE3,dfdq_curr_vec_out_LZ_dqPE4,dfdq_curr_vec_out_LZ_dqPE5,dfdq_curr_vec_out_LZ_dqPE6,dfdq_curr_vec_out_LZ_dqPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 1436, -9457, 1126, 9615, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -2460, -3074, -13, 277, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5950, 7332, -181, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -73332, -89415, -473, 0, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -22838, -43368, -94, -13222, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10554, -135202, -9858, 45277, 0, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AX_dqdPE1,dfdqd_curr_vec_out_AX_dqdPE2,dfdqd_curr_vec_out_AX_dqdPE3,dfdqd_curr_vec_out_AX_dqdPE4,dfdqd_curr_vec_out_AX_dqdPE5,dfdqd_curr_vec_out_AX_dqdPE6,dfdqd_curr_vec_out_AX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AY_dqdPE1,dfdqd_curr_vec_out_AY_dqdPE2,dfdqd_curr_vec_out_AY_dqdPE3,dfdqd_curr_vec_out_AY_dqdPE4,dfdqd_curr_vec_out_AY_dqdPE5,dfdqd_curr_vec_out_AY_dqdPE6,dfdqd_curr_vec_out_AY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AZ_dqdPE1,dfdqd_curr_vec_out_AZ_dqdPE2,dfdqd_curr_vec_out_AZ_dqdPE3,dfdqd_curr_vec_out_AZ_dqdPE4,dfdqd_curr_vec_out_AZ_dqdPE5,dfdqd_curr_vec_out_AZ_dqdPE6,dfdqd_curr_vec_out_AZ_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LX_dqdPE1,dfdqd_curr_vec_out_LX_dqdPE2,dfdqd_curr_vec_out_LX_dqdPE3,dfdqd_curr_vec_out_LX_dqdPE4,dfdqd_curr_vec_out_LX_dqdPE5,dfdqd_curr_vec_out_LX_dqdPE6,dfdqd_curr_vec_out_LX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LY_dqdPE1,dfdqd_curr_vec_out_LY_dqdPE2,dfdqd_curr_vec_out_LY_dqdPE3,dfdqd_curr_vec_out_LY_dqdPE4,dfdqd_curr_vec_out_LY_dqdPE5,dfdqd_curr_vec_out_LY_dqdPE6,dfdqd_curr_vec_out_LY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LZ_dqdPE1,dfdqd_curr_vec_out_LZ_dqdPE2,dfdqd_curr_vec_out_LZ_dqdPE3,dfdqd_curr_vec_out_LZ_dqdPE4,dfdqd_curr_vec_out_LZ_dqdPE5,dfdqd_curr_vec_out_LZ_dqdPE6,dfdqd_curr_vec_out_LZ_dqdPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External dv,da
      //------------------------------------------------------------------------
      // dqPE1
      dvdq_curr_vec_reg_AX_dqPE1 = dvdq_curr_vec_out_AX_dqPE1; dvdq_curr_vec_reg_AY_dqPE1 = dvdq_curr_vec_out_AY_dqPE1; dvdq_curr_vec_reg_AZ_dqPE1 = dvdq_curr_vec_out_AZ_dqPE1; dvdq_curr_vec_reg_LX_dqPE1 = dvdq_curr_vec_out_LX_dqPE1; dvdq_curr_vec_reg_LY_dqPE1 = dvdq_curr_vec_out_LY_dqPE1; dvdq_curr_vec_reg_LZ_dqPE1 = dvdq_curr_vec_out_LZ_dqPE1; 
      dadq_curr_vec_reg_AX_dqPE1 = dadq_curr_vec_out_AX_dqPE1; dadq_curr_vec_reg_AY_dqPE1 = dadq_curr_vec_out_AY_dqPE1; dadq_curr_vec_reg_AZ_dqPE1 = dadq_curr_vec_out_AZ_dqPE1; dadq_curr_vec_reg_LX_dqPE1 = dadq_curr_vec_out_LX_dqPE1; dadq_curr_vec_reg_LY_dqPE1 = dadq_curr_vec_out_LY_dqPE1; dadq_curr_vec_reg_LZ_dqPE1 = dadq_curr_vec_out_LZ_dqPE1; 
      // dqPE2
      dvdq_curr_vec_reg_AX_dqPE2 = dvdq_curr_vec_out_AX_dqPE2; dvdq_curr_vec_reg_AY_dqPE2 = dvdq_curr_vec_out_AY_dqPE2; dvdq_curr_vec_reg_AZ_dqPE2 = dvdq_curr_vec_out_AZ_dqPE2; dvdq_curr_vec_reg_LX_dqPE2 = dvdq_curr_vec_out_LX_dqPE2; dvdq_curr_vec_reg_LY_dqPE2 = dvdq_curr_vec_out_LY_dqPE2; dvdq_curr_vec_reg_LZ_dqPE2 = dvdq_curr_vec_out_LZ_dqPE2; 
      dadq_curr_vec_reg_AX_dqPE2 = dadq_curr_vec_out_AX_dqPE2; dadq_curr_vec_reg_AY_dqPE2 = dadq_curr_vec_out_AY_dqPE2; dadq_curr_vec_reg_AZ_dqPE2 = dadq_curr_vec_out_AZ_dqPE2; dadq_curr_vec_reg_LX_dqPE2 = dadq_curr_vec_out_LX_dqPE2; dadq_curr_vec_reg_LY_dqPE2 = dadq_curr_vec_out_LY_dqPE2; dadq_curr_vec_reg_LZ_dqPE2 = dadq_curr_vec_out_LZ_dqPE2; 
      // dqPE3
      dvdq_curr_vec_reg_AX_dqPE3 = dvdq_curr_vec_out_AX_dqPE3; dvdq_curr_vec_reg_AY_dqPE3 = dvdq_curr_vec_out_AY_dqPE3; dvdq_curr_vec_reg_AZ_dqPE3 = dvdq_curr_vec_out_AZ_dqPE3; dvdq_curr_vec_reg_LX_dqPE3 = dvdq_curr_vec_out_LX_dqPE3; dvdq_curr_vec_reg_LY_dqPE3 = dvdq_curr_vec_out_LY_dqPE3; dvdq_curr_vec_reg_LZ_dqPE3 = dvdq_curr_vec_out_LZ_dqPE3; 
      dadq_curr_vec_reg_AX_dqPE3 = dadq_curr_vec_out_AX_dqPE3; dadq_curr_vec_reg_AY_dqPE3 = dadq_curr_vec_out_AY_dqPE3; dadq_curr_vec_reg_AZ_dqPE3 = dadq_curr_vec_out_AZ_dqPE3; dadq_curr_vec_reg_LX_dqPE3 = dadq_curr_vec_out_LX_dqPE3; dadq_curr_vec_reg_LY_dqPE3 = dadq_curr_vec_out_LY_dqPE3; dadq_curr_vec_reg_LZ_dqPE3 = dadq_curr_vec_out_LZ_dqPE3; 
      // dqPE4
      dvdq_curr_vec_reg_AX_dqPE4 = dvdq_curr_vec_out_AX_dqPE4; dvdq_curr_vec_reg_AY_dqPE4 = dvdq_curr_vec_out_AY_dqPE4; dvdq_curr_vec_reg_AZ_dqPE4 = dvdq_curr_vec_out_AZ_dqPE4; dvdq_curr_vec_reg_LX_dqPE4 = dvdq_curr_vec_out_LX_dqPE4; dvdq_curr_vec_reg_LY_dqPE4 = dvdq_curr_vec_out_LY_dqPE4; dvdq_curr_vec_reg_LZ_dqPE4 = dvdq_curr_vec_out_LZ_dqPE4; 
      dadq_curr_vec_reg_AX_dqPE4 = dadq_curr_vec_out_AX_dqPE4; dadq_curr_vec_reg_AY_dqPE4 = dadq_curr_vec_out_AY_dqPE4; dadq_curr_vec_reg_AZ_dqPE4 = dadq_curr_vec_out_AZ_dqPE4; dadq_curr_vec_reg_LX_dqPE4 = dadq_curr_vec_out_LX_dqPE4; dadq_curr_vec_reg_LY_dqPE4 = dadq_curr_vec_out_LY_dqPE4; dadq_curr_vec_reg_LZ_dqPE4 = dadq_curr_vec_out_LZ_dqPE4; 
      // dqPE5
      dvdq_curr_vec_reg_AX_dqPE5 = dvdq_curr_vec_out_AX_dqPE5; dvdq_curr_vec_reg_AY_dqPE5 = dvdq_curr_vec_out_AY_dqPE5; dvdq_curr_vec_reg_AZ_dqPE5 = dvdq_curr_vec_out_AZ_dqPE5; dvdq_curr_vec_reg_LX_dqPE5 = dvdq_curr_vec_out_LX_dqPE5; dvdq_curr_vec_reg_LY_dqPE5 = dvdq_curr_vec_out_LY_dqPE5; dvdq_curr_vec_reg_LZ_dqPE5 = dvdq_curr_vec_out_LZ_dqPE5; 
      dadq_curr_vec_reg_AX_dqPE5 = dadq_curr_vec_out_AX_dqPE5; dadq_curr_vec_reg_AY_dqPE5 = dadq_curr_vec_out_AY_dqPE5; dadq_curr_vec_reg_AZ_dqPE5 = dadq_curr_vec_out_AZ_dqPE5; dadq_curr_vec_reg_LX_dqPE5 = dadq_curr_vec_out_LX_dqPE5; dadq_curr_vec_reg_LY_dqPE5 = dadq_curr_vec_out_LY_dqPE5; dadq_curr_vec_reg_LZ_dqPE5 = dadq_curr_vec_out_LZ_dqPE5; 
      // dqPE6
      dvdq_curr_vec_reg_AX_dqPE6 = dvdq_curr_vec_out_AX_dqPE6; dvdq_curr_vec_reg_AY_dqPE6 = dvdq_curr_vec_out_AY_dqPE6; dvdq_curr_vec_reg_AZ_dqPE6 = dvdq_curr_vec_out_AZ_dqPE6; dvdq_curr_vec_reg_LX_dqPE6 = dvdq_curr_vec_out_LX_dqPE6; dvdq_curr_vec_reg_LY_dqPE6 = dvdq_curr_vec_out_LY_dqPE6; dvdq_curr_vec_reg_LZ_dqPE6 = dvdq_curr_vec_out_LZ_dqPE6; 
      dadq_curr_vec_reg_AX_dqPE6 = dadq_curr_vec_out_AX_dqPE6; dadq_curr_vec_reg_AY_dqPE6 = dadq_curr_vec_out_AY_dqPE6; dadq_curr_vec_reg_AZ_dqPE6 = dadq_curr_vec_out_AZ_dqPE6; dadq_curr_vec_reg_LX_dqPE6 = dadq_curr_vec_out_LX_dqPE6; dadq_curr_vec_reg_LY_dqPE6 = dadq_curr_vec_out_LY_dqPE6; dadq_curr_vec_reg_LZ_dqPE6 = dadq_curr_vec_out_LZ_dqPE6; 
      // dqPE7
      dvdq_curr_vec_reg_AX_dqPE7 = dvdq_curr_vec_out_AX_dqPE7; dvdq_curr_vec_reg_AY_dqPE7 = dvdq_curr_vec_out_AY_dqPE7; dvdq_curr_vec_reg_AZ_dqPE7 = dvdq_curr_vec_out_AZ_dqPE7; dvdq_curr_vec_reg_LX_dqPE7 = dvdq_curr_vec_out_LX_dqPE7; dvdq_curr_vec_reg_LY_dqPE7 = dvdq_curr_vec_out_LY_dqPE7; dvdq_curr_vec_reg_LZ_dqPE7 = dvdq_curr_vec_out_LZ_dqPE7; 
      dadq_curr_vec_reg_AX_dqPE7 = dadq_curr_vec_out_AX_dqPE7; dadq_curr_vec_reg_AY_dqPE7 = dadq_curr_vec_out_AY_dqPE7; dadq_curr_vec_reg_AZ_dqPE7 = dadq_curr_vec_out_AZ_dqPE7; dadq_curr_vec_reg_LX_dqPE7 = dadq_curr_vec_out_LX_dqPE7; dadq_curr_vec_reg_LY_dqPE7 = dadq_curr_vec_out_LY_dqPE7; dadq_curr_vec_reg_LZ_dqPE7 = dadq_curr_vec_out_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqdPE1
      dvdqd_curr_vec_reg_AX_dqdPE1 = dvdqd_curr_vec_out_AX_dqdPE1; dvdqd_curr_vec_reg_AY_dqdPE1 = dvdqd_curr_vec_out_AY_dqdPE1; dvdqd_curr_vec_reg_AZ_dqdPE1 = dvdqd_curr_vec_out_AZ_dqdPE1; dvdqd_curr_vec_reg_LX_dqdPE1 = dvdqd_curr_vec_out_LX_dqdPE1; dvdqd_curr_vec_reg_LY_dqdPE1 = dvdqd_curr_vec_out_LY_dqdPE1; dvdqd_curr_vec_reg_LZ_dqdPE1 = dvdqd_curr_vec_out_LZ_dqdPE1; 
      dadqd_curr_vec_reg_AX_dqdPE1 = dadqd_curr_vec_out_AX_dqdPE1; dadqd_curr_vec_reg_AY_dqdPE1 = dadqd_curr_vec_out_AY_dqdPE1; dadqd_curr_vec_reg_AZ_dqdPE1 = dadqd_curr_vec_out_AZ_dqdPE1; dadqd_curr_vec_reg_LX_dqdPE1 = dadqd_curr_vec_out_LX_dqdPE1; dadqd_curr_vec_reg_LY_dqdPE1 = dadqd_curr_vec_out_LY_dqdPE1; dadqd_curr_vec_reg_LZ_dqdPE1 = dadqd_curr_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dvdqd_curr_vec_reg_AX_dqdPE2 = dvdqd_curr_vec_out_AX_dqdPE2; dvdqd_curr_vec_reg_AY_dqdPE2 = dvdqd_curr_vec_out_AY_dqdPE2; dvdqd_curr_vec_reg_AZ_dqdPE2 = dvdqd_curr_vec_out_AZ_dqdPE2; dvdqd_curr_vec_reg_LX_dqdPE2 = dvdqd_curr_vec_out_LX_dqdPE2; dvdqd_curr_vec_reg_LY_dqdPE2 = dvdqd_curr_vec_out_LY_dqdPE2; dvdqd_curr_vec_reg_LZ_dqdPE2 = dvdqd_curr_vec_out_LZ_dqdPE2; 
      dadqd_curr_vec_reg_AX_dqdPE2 = dadqd_curr_vec_out_AX_dqdPE2; dadqd_curr_vec_reg_AY_dqdPE2 = dadqd_curr_vec_out_AY_dqdPE2; dadqd_curr_vec_reg_AZ_dqdPE2 = dadqd_curr_vec_out_AZ_dqdPE2; dadqd_curr_vec_reg_LX_dqdPE2 = dadqd_curr_vec_out_LX_dqdPE2; dadqd_curr_vec_reg_LY_dqdPE2 = dadqd_curr_vec_out_LY_dqdPE2; dadqd_curr_vec_reg_LZ_dqdPE2 = dadqd_curr_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dvdqd_curr_vec_reg_AX_dqdPE3 = dvdqd_curr_vec_out_AX_dqdPE3; dvdqd_curr_vec_reg_AY_dqdPE3 = dvdqd_curr_vec_out_AY_dqdPE3; dvdqd_curr_vec_reg_AZ_dqdPE3 = dvdqd_curr_vec_out_AZ_dqdPE3; dvdqd_curr_vec_reg_LX_dqdPE3 = dvdqd_curr_vec_out_LX_dqdPE3; dvdqd_curr_vec_reg_LY_dqdPE3 = dvdqd_curr_vec_out_LY_dqdPE3; dvdqd_curr_vec_reg_LZ_dqdPE3 = dvdqd_curr_vec_out_LZ_dqdPE3; 
      dadqd_curr_vec_reg_AX_dqdPE3 = dadqd_curr_vec_out_AX_dqdPE3; dadqd_curr_vec_reg_AY_dqdPE3 = dadqd_curr_vec_out_AY_dqdPE3; dadqd_curr_vec_reg_AZ_dqdPE3 = dadqd_curr_vec_out_AZ_dqdPE3; dadqd_curr_vec_reg_LX_dqdPE3 = dadqd_curr_vec_out_LX_dqdPE3; dadqd_curr_vec_reg_LY_dqdPE3 = dadqd_curr_vec_out_LY_dqdPE3; dadqd_curr_vec_reg_LZ_dqdPE3 = dadqd_curr_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dvdqd_curr_vec_reg_AX_dqdPE4 = dvdqd_curr_vec_out_AX_dqdPE4; dvdqd_curr_vec_reg_AY_dqdPE4 = dvdqd_curr_vec_out_AY_dqdPE4; dvdqd_curr_vec_reg_AZ_dqdPE4 = dvdqd_curr_vec_out_AZ_dqdPE4; dvdqd_curr_vec_reg_LX_dqdPE4 = dvdqd_curr_vec_out_LX_dqdPE4; dvdqd_curr_vec_reg_LY_dqdPE4 = dvdqd_curr_vec_out_LY_dqdPE4; dvdqd_curr_vec_reg_LZ_dqdPE4 = dvdqd_curr_vec_out_LZ_dqdPE4; 
      dadqd_curr_vec_reg_AX_dqdPE4 = dadqd_curr_vec_out_AX_dqdPE4; dadqd_curr_vec_reg_AY_dqdPE4 = dadqd_curr_vec_out_AY_dqdPE4; dadqd_curr_vec_reg_AZ_dqdPE4 = dadqd_curr_vec_out_AZ_dqdPE4; dadqd_curr_vec_reg_LX_dqdPE4 = dadqd_curr_vec_out_LX_dqdPE4; dadqd_curr_vec_reg_LY_dqdPE4 = dadqd_curr_vec_out_LY_dqdPE4; dadqd_curr_vec_reg_LZ_dqdPE4 = dadqd_curr_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dvdqd_curr_vec_reg_AX_dqdPE5 = dvdqd_curr_vec_out_AX_dqdPE5; dvdqd_curr_vec_reg_AY_dqdPE5 = dvdqd_curr_vec_out_AY_dqdPE5; dvdqd_curr_vec_reg_AZ_dqdPE5 = dvdqd_curr_vec_out_AZ_dqdPE5; dvdqd_curr_vec_reg_LX_dqdPE5 = dvdqd_curr_vec_out_LX_dqdPE5; dvdqd_curr_vec_reg_LY_dqdPE5 = dvdqd_curr_vec_out_LY_dqdPE5; dvdqd_curr_vec_reg_LZ_dqdPE5 = dvdqd_curr_vec_out_LZ_dqdPE5; 
      dadqd_curr_vec_reg_AX_dqdPE5 = dadqd_curr_vec_out_AX_dqdPE5; dadqd_curr_vec_reg_AY_dqdPE5 = dadqd_curr_vec_out_AY_dqdPE5; dadqd_curr_vec_reg_AZ_dqdPE5 = dadqd_curr_vec_out_AZ_dqdPE5; dadqd_curr_vec_reg_LX_dqdPE5 = dadqd_curr_vec_out_LX_dqdPE5; dadqd_curr_vec_reg_LY_dqdPE5 = dadqd_curr_vec_out_LY_dqdPE5; dadqd_curr_vec_reg_LZ_dqdPE5 = dadqd_curr_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dvdqd_curr_vec_reg_AX_dqdPE6 = dvdqd_curr_vec_out_AX_dqdPE6; dvdqd_curr_vec_reg_AY_dqdPE6 = dvdqd_curr_vec_out_AY_dqdPE6; dvdqd_curr_vec_reg_AZ_dqdPE6 = dvdqd_curr_vec_out_AZ_dqdPE6; dvdqd_curr_vec_reg_LX_dqdPE6 = dvdqd_curr_vec_out_LX_dqdPE6; dvdqd_curr_vec_reg_LY_dqdPE6 = dvdqd_curr_vec_out_LY_dqdPE6; dvdqd_curr_vec_reg_LZ_dqdPE6 = dvdqd_curr_vec_out_LZ_dqdPE6; 
      dadqd_curr_vec_reg_AX_dqdPE6 = dadqd_curr_vec_out_AX_dqdPE6; dadqd_curr_vec_reg_AY_dqdPE6 = dadqd_curr_vec_out_AY_dqdPE6; dadqd_curr_vec_reg_AZ_dqdPE6 = dadqd_curr_vec_out_AZ_dqdPE6; dadqd_curr_vec_reg_LX_dqdPE6 = dadqd_curr_vec_out_LX_dqdPE6; dadqd_curr_vec_reg_LY_dqdPE6 = dadqd_curr_vec_out_LY_dqdPE6; dadqd_curr_vec_reg_LZ_dqdPE6 = dadqd_curr_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dvdqd_curr_vec_reg_AX_dqdPE7 = dvdqd_curr_vec_out_AX_dqdPE7; dvdqd_curr_vec_reg_AY_dqdPE7 = dvdqd_curr_vec_out_AY_dqdPE7; dvdqd_curr_vec_reg_AZ_dqdPE7 = dvdqd_curr_vec_out_AZ_dqdPE7; dvdqd_curr_vec_reg_LX_dqdPE7 = dvdqd_curr_vec_out_LX_dqdPE7; dvdqd_curr_vec_reg_LY_dqdPE7 = dvdqd_curr_vec_out_LY_dqdPE7; dvdqd_curr_vec_reg_LZ_dqdPE7 = dvdqd_curr_vec_out_LZ_dqdPE7; 
      dadqd_curr_vec_reg_AX_dqdPE7 = dadqd_curr_vec_out_AX_dqdPE7; dadqd_curr_vec_reg_AY_dqdPE7 = dadqd_curr_vec_out_AY_dqdPE7; dadqd_curr_vec_reg_AZ_dqdPE7 = dadqd_curr_vec_out_AZ_dqdPE7; dadqd_curr_vec_reg_LX_dqdPE7 = dadqd_curr_vec_out_LX_dqdPE7; dadqd_curr_vec_reg_LY_dqdPE7 = dadqd_curr_vec_out_LY_dqdPE7; dadqd_curr_vec_reg_LZ_dqdPE7 = dadqd_curr_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Link 6 Inputs
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 3'd6;
      sinq_val_in_rnea = 32'd20062; cosq_val_in_rnea = 32'd62390;
      qd_val_in_rnea = 32'd27834;
      qdd_val_in_rnea = 32'd6910717;
      v_prev_vec_in_AX_rnea = -32'd6608; v_prev_vec_in_AY_rnea = 32'd47337; v_prev_vec_in_AZ_rnea = 32'd153790; v_prev_vec_in_LX_rnea = 32'd17985; v_prev_vec_in_LY_rnea = -32'd7019; v_prev_vec_in_LZ_rnea = -32'd1;
      a_prev_vec_in_AX_rnea = -32'd131010; a_prev_vec_in_AY_rnea = 32'd184057; a_prev_vec_in_AZ_rnea = 32'd1684920; a_prev_vec_in_LX_rnea = 32'd27757; a_prev_vec_in_LY_rnea = -32'd47665; a_prev_vec_in_LZ_rnea = 32'd574;
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 0;
      derv_in_dqPE1 = 3'd1;
      sinq_val_in_dqPE1 = 0; cosq_val_in_dqPE1 = 0;
      qd_val_in_dqPE1 = 0;
      v_curr_vec_in_AX_dqPE1 = 0; v_curr_vec_in_AY_dqPE1 = 0; v_curr_vec_in_AZ_dqPE1 = 0; v_curr_vec_in_LX_dqPE1 = 0; v_curr_vec_in_LY_dqPE1 = 0; v_curr_vec_in_LZ_dqPE1 = 0;
      a_curr_vec_in_AX_dqPE1 = 0; a_curr_vec_in_AY_dqPE1 = 0; a_curr_vec_in_AZ_dqPE1 = 0; a_curr_vec_in_LX_dqPE1 = 0; a_curr_vec_in_LY_dqPE1 = 0; a_curr_vec_in_LZ_dqPE1 = 0;
      v_prev_vec_in_AX_dqPE1 = 0; v_prev_vec_in_AY_dqPE1 = 0; v_prev_vec_in_AZ_dqPE1 = 0; v_prev_vec_in_LX_dqPE1 = 0; v_prev_vec_in_LY_dqPE1 = 0; v_prev_vec_in_LZ_dqPE1 = 0;
      a_prev_vec_in_AX_dqPE1 = 0; a_prev_vec_in_AY_dqPE1 = 0; a_prev_vec_in_AZ_dqPE1 = 0; a_prev_vec_in_LX_dqPE1 = 0; a_prev_vec_in_LY_dqPE1 = 0; a_prev_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      link_in_dqPE2 = 3'd5;
      derv_in_dqPE2 = 3'd2;
      sinq_val_in_dqPE2 = -32'd48758; cosq_val_in_dqPE2 = 32'd43790;
      qd_val_in_dqPE2 = 32'd28646;
      v_curr_vec_in_AX_dqPE2 = -32'd6608; v_curr_vec_in_AY_dqPE2 = 32'd47337; v_curr_vec_in_AZ_dqPE2 = 32'd153790; v_curr_vec_in_LX_dqPE2 = 32'd17985; v_curr_vec_in_LY_dqPE2 = -32'd7019; v_curr_vec_in_LZ_dqPE2 = -32'd1;
      a_curr_vec_in_AX_dqPE2 = -32'd131010; a_curr_vec_in_AY_dqPE2 = 32'd184057; a_curr_vec_in_AZ_dqPE2 = 32'd1684917; a_curr_vec_in_LX_dqPE2 = 32'd27757; a_curr_vec_in_LY_dqPE2 = -32'd47665; a_curr_vec_in_LZ_dqPE2 = 32'd574;
      v_prev_vec_in_AX_dqPE2 = -32'd30803; v_prev_vec_in_AY_dqPE2 = 32'd125144; v_prev_vec_in_AZ_dqPE2 = 32'd36546; v_prev_vec_in_LX_dqPE2 = -32'd52; v_prev_vec_in_LY_dqPE2 = -32'd1; v_prev_vec_in_LZ_dqPE2 = -32'd12388;
      a_prev_vec_in_AX_dqPE2 = -32'd33423; a_prev_vec_in_AY_dqPE2 = -32'd9612; a_prev_vec_in_AZ_dqPE2 = 32'd233919; a_prev_vec_in_LX_dqPE2 = 32'd52175; a_prev_vec_in_LY_dqPE2 = 32'd574; a_prev_vec_in_LZ_dqPE2 = -32'd43363;
      // dqPE3
      link_in_dqPE3 = 3'd5;
      derv_in_dqPE3 = 3'd3;
      sinq_val_in_dqPE3 = -32'd48758; cosq_val_in_dqPE3 = 32'd43790;
      qd_val_in_dqPE3 = 32'd28646;
      v_curr_vec_in_AX_dqPE3 = -32'd6608; v_curr_vec_in_AY_dqPE3 = 32'd47337; v_curr_vec_in_AZ_dqPE3 = 32'd153790; v_curr_vec_in_LX_dqPE3 = 32'd17985; v_curr_vec_in_LY_dqPE3 = -32'd7019; v_curr_vec_in_LZ_dqPE3 = -32'd1;
      a_curr_vec_in_AX_dqPE3 = -32'd131010; a_curr_vec_in_AY_dqPE3 = 32'd184057; a_curr_vec_in_AZ_dqPE3 = 32'd1684917; a_curr_vec_in_LX_dqPE3 = 32'd27757; a_curr_vec_in_LY_dqPE3 = -32'd47665; a_curr_vec_in_LZ_dqPE3 = 32'd574;
      v_prev_vec_in_AX_dqPE3 = -32'd30803; v_prev_vec_in_AY_dqPE3 = 32'd125144; v_prev_vec_in_AZ_dqPE3 = 32'd36546; v_prev_vec_in_LX_dqPE3 = -32'd52; v_prev_vec_in_LY_dqPE3 = -32'd1; v_prev_vec_in_LZ_dqPE3 = -32'd12388;
      a_prev_vec_in_AX_dqPE3 = -32'd33423; a_prev_vec_in_AY_dqPE3 = -32'd9612; a_prev_vec_in_AZ_dqPE3 = 32'd233919; a_prev_vec_in_LX_dqPE3 = 32'd52175; a_prev_vec_in_LY_dqPE3 = 32'd574; a_prev_vec_in_LZ_dqPE3 = -32'd43363;
      // dqPE4
      link_in_dqPE4 = 3'd5;
      derv_in_dqPE4 = 3'd4;
      sinq_val_in_dqPE4 = -32'd48758; cosq_val_in_dqPE4 = 32'd43790;
      qd_val_in_dqPE4 = 32'd28646;
      v_curr_vec_in_AX_dqPE4 = -32'd6608; v_curr_vec_in_AY_dqPE4 = 32'd47337; v_curr_vec_in_AZ_dqPE4 = 32'd153790; v_curr_vec_in_LX_dqPE4 = 32'd17985; v_curr_vec_in_LY_dqPE4 = -32'd7019; v_curr_vec_in_LZ_dqPE4 = -32'd1;
      a_curr_vec_in_AX_dqPE4 = -32'd131010; a_curr_vec_in_AY_dqPE4 = 32'd184057; a_curr_vec_in_AZ_dqPE4 = 32'd1684917; a_curr_vec_in_LX_dqPE4 = 32'd27757; a_curr_vec_in_LY_dqPE4 = -32'd47665; a_curr_vec_in_LZ_dqPE4 = 32'd574;
      v_prev_vec_in_AX_dqPE4 = -32'd30803; v_prev_vec_in_AY_dqPE4 = 32'd125144; v_prev_vec_in_AZ_dqPE4 = 32'd36546; v_prev_vec_in_LX_dqPE4 = -32'd52; v_prev_vec_in_LY_dqPE4 = -32'd1; v_prev_vec_in_LZ_dqPE4 = -32'd12388;
      a_prev_vec_in_AX_dqPE4 = -32'd33423; a_prev_vec_in_AY_dqPE4 = -32'd9612; a_prev_vec_in_AZ_dqPE4 = 32'd233919; a_prev_vec_in_LX_dqPE4 = 32'd52175; a_prev_vec_in_LY_dqPE4 = 32'd574; a_prev_vec_in_LZ_dqPE4 = -32'd43363;
      // dqPE5
      link_in_dqPE5 = 3'd5;
      derv_in_dqPE5 = 3'd5;
      sinq_val_in_dqPE5 = -32'd48758; cosq_val_in_dqPE5 = 32'd43790;
      qd_val_in_dqPE5 = 32'd28646;
      v_curr_vec_in_AX_dqPE5 = -32'd6608; v_curr_vec_in_AY_dqPE5 = 32'd47337; v_curr_vec_in_AZ_dqPE5 = 32'd153790; v_curr_vec_in_LX_dqPE5 = 32'd17985; v_curr_vec_in_LY_dqPE5 = -32'd7019; v_curr_vec_in_LZ_dqPE5 = -32'd1;
      a_curr_vec_in_AX_dqPE5 = -32'd131010; a_curr_vec_in_AY_dqPE5 = 32'd184057; a_curr_vec_in_AZ_dqPE5 = 32'd1684917; a_curr_vec_in_LX_dqPE5 = 32'd27757; a_curr_vec_in_LY_dqPE5 = -32'd47665; a_curr_vec_in_LZ_dqPE5 = 32'd574;
      v_prev_vec_in_AX_dqPE5 = -32'd30803; v_prev_vec_in_AY_dqPE5 = 32'd125144; v_prev_vec_in_AZ_dqPE5 = 32'd36546; v_prev_vec_in_LX_dqPE5 = -32'd52; v_prev_vec_in_LY_dqPE5 = -32'd1; v_prev_vec_in_LZ_dqPE5 = -32'd12388;
      a_prev_vec_in_AX_dqPE5 = -32'd33423; a_prev_vec_in_AY_dqPE5 = -32'd9612; a_prev_vec_in_AZ_dqPE5 = 32'd233919; a_prev_vec_in_LX_dqPE5 = 32'd52175; a_prev_vec_in_LY_dqPE5 = 32'd574; a_prev_vec_in_LZ_dqPE5 = -32'd43363;
      // dqPE6
      link_in_dqPE6 = 3'd5;
      derv_in_dqPE6 = 3'd6;
      sinq_val_in_dqPE6 = -32'd48758; cosq_val_in_dqPE6 = 32'd43790;
      qd_val_in_dqPE6 = 32'd28646;
      v_curr_vec_in_AX_dqPE6 = -32'd6608; v_curr_vec_in_AY_dqPE6 = 32'd47337; v_curr_vec_in_AZ_dqPE6 = 32'd153790; v_curr_vec_in_LX_dqPE6 = 32'd17985; v_curr_vec_in_LY_dqPE6 = -32'd7019; v_curr_vec_in_LZ_dqPE6 = -32'd1;
      a_curr_vec_in_AX_dqPE6 = -32'd131010; a_curr_vec_in_AY_dqPE6 = 32'd184057; a_curr_vec_in_AZ_dqPE6 = 32'd1684917; a_curr_vec_in_LX_dqPE6 = 32'd27757; a_curr_vec_in_LY_dqPE6 = -32'd47665; a_curr_vec_in_LZ_dqPE6 = 32'd574;
      v_prev_vec_in_AX_dqPE6 = -32'd30803; v_prev_vec_in_AY_dqPE6 = 32'd125144; v_prev_vec_in_AZ_dqPE6 = 32'd36546; v_prev_vec_in_LX_dqPE6 = -32'd52; v_prev_vec_in_LY_dqPE6 = -32'd1; v_prev_vec_in_LZ_dqPE6 = -32'd12388;
      a_prev_vec_in_AX_dqPE6 = -32'd33423; a_prev_vec_in_AY_dqPE6 = -32'd9612; a_prev_vec_in_AZ_dqPE6 = 32'd233919; a_prev_vec_in_LX_dqPE6 = 32'd52175; a_prev_vec_in_LY_dqPE6 = 32'd574; a_prev_vec_in_LZ_dqPE6 = -32'd43363;
      // dqPE7
      link_in_dqPE7 = 3'd5;
      derv_in_dqPE7 = 3'd7;
      sinq_val_in_dqPE7 = -32'd48758; cosq_val_in_dqPE7 = 32'd43790;
      qd_val_in_dqPE7 = 32'd28646;
      v_curr_vec_in_AX_dqPE7 = -32'd6608; v_curr_vec_in_AY_dqPE7 = 32'd47337; v_curr_vec_in_AZ_dqPE7 = 32'd153790; v_curr_vec_in_LX_dqPE7 = 32'd17985; v_curr_vec_in_LY_dqPE7 = -32'd7019; v_curr_vec_in_LZ_dqPE7 = -32'd1;
      a_curr_vec_in_AX_dqPE7 = -32'd131010; a_curr_vec_in_AY_dqPE7 = 32'd184057; a_curr_vec_in_AZ_dqPE7 = 32'd1684917; a_curr_vec_in_LX_dqPE7 = 32'd27757; a_curr_vec_in_LY_dqPE7 = -32'd47665; a_curr_vec_in_LZ_dqPE7 = 32'd574;
      v_prev_vec_in_AX_dqPE7 = -32'd30803; v_prev_vec_in_AY_dqPE7 = 32'd125144; v_prev_vec_in_AZ_dqPE7 = 32'd36546; v_prev_vec_in_LX_dqPE7 = -32'd52; v_prev_vec_in_LY_dqPE7 = -32'd1; v_prev_vec_in_LZ_dqPE7 = -32'd12388;
      a_prev_vec_in_AX_dqPE7 = -32'd33423; a_prev_vec_in_AY_dqPE7 = -32'd9612; a_prev_vec_in_AZ_dqPE7 = 32'd233919; a_prev_vec_in_LX_dqPE7 = 32'd52175; a_prev_vec_in_LY_dqPE7 = 32'd574; a_prev_vec_in_LZ_dqPE7 = -32'd43363;
      // External dv,da
      // dqPE1
      dvdq_prev_vec_in_AX_dqPE1 = dvdq_curr_vec_reg_AX_dqPE1; dvdq_prev_vec_in_AY_dqPE1 = dvdq_curr_vec_reg_AY_dqPE1; dvdq_prev_vec_in_AZ_dqPE1 = dvdq_curr_vec_reg_AZ_dqPE1; dvdq_prev_vec_in_LX_dqPE1 = dvdq_curr_vec_reg_LX_dqPE1; dvdq_prev_vec_in_LY_dqPE1 = dvdq_curr_vec_reg_LY_dqPE1; dvdq_prev_vec_in_LZ_dqPE1 = dvdq_curr_vec_reg_LZ_dqPE1; 
      dadq_prev_vec_in_AX_dqPE1 = dadq_curr_vec_reg_AX_dqPE1; dadq_prev_vec_in_AY_dqPE1 = dadq_curr_vec_reg_AY_dqPE1; dadq_prev_vec_in_AZ_dqPE1 = dadq_curr_vec_reg_AZ_dqPE1; dadq_prev_vec_in_LX_dqPE1 = dadq_curr_vec_reg_LX_dqPE1; dadq_prev_vec_in_LY_dqPE1 = dadq_curr_vec_reg_LY_dqPE1; dadq_prev_vec_in_LZ_dqPE1 = dadq_curr_vec_reg_LZ_dqPE1; 
      // dqPE2
      dvdq_prev_vec_in_AX_dqPE2 = dvdq_curr_vec_reg_AX_dqPE2; dvdq_prev_vec_in_AY_dqPE2 = dvdq_curr_vec_reg_AY_dqPE2; dvdq_prev_vec_in_AZ_dqPE2 = dvdq_curr_vec_reg_AZ_dqPE2; dvdq_prev_vec_in_LX_dqPE2 = dvdq_curr_vec_reg_LX_dqPE2; dvdq_prev_vec_in_LY_dqPE2 = dvdq_curr_vec_reg_LY_dqPE2; dvdq_prev_vec_in_LZ_dqPE2 = dvdq_curr_vec_reg_LZ_dqPE2; 
      dadq_prev_vec_in_AX_dqPE2 = dadq_curr_vec_reg_AX_dqPE2; dadq_prev_vec_in_AY_dqPE2 = dadq_curr_vec_reg_AY_dqPE2; dadq_prev_vec_in_AZ_dqPE2 = dadq_curr_vec_reg_AZ_dqPE2; dadq_prev_vec_in_LX_dqPE2 = dadq_curr_vec_reg_LX_dqPE2; dadq_prev_vec_in_LY_dqPE2 = dadq_curr_vec_reg_LY_dqPE2; dadq_prev_vec_in_LZ_dqPE2 = dadq_curr_vec_reg_LZ_dqPE2; 
      // dqPE3
      dvdq_prev_vec_in_AX_dqPE3 = dvdq_curr_vec_reg_AX_dqPE3; dvdq_prev_vec_in_AY_dqPE3 = dvdq_curr_vec_reg_AY_dqPE3; dvdq_prev_vec_in_AZ_dqPE3 = dvdq_curr_vec_reg_AZ_dqPE3; dvdq_prev_vec_in_LX_dqPE3 = dvdq_curr_vec_reg_LX_dqPE3; dvdq_prev_vec_in_LY_dqPE3 = dvdq_curr_vec_reg_LY_dqPE3; dvdq_prev_vec_in_LZ_dqPE3 = dvdq_curr_vec_reg_LZ_dqPE3; 
      dadq_prev_vec_in_AX_dqPE3 = dadq_curr_vec_reg_AX_dqPE3; dadq_prev_vec_in_AY_dqPE3 = dadq_curr_vec_reg_AY_dqPE3; dadq_prev_vec_in_AZ_dqPE3 = dadq_curr_vec_reg_AZ_dqPE3; dadq_prev_vec_in_LX_dqPE3 = dadq_curr_vec_reg_LX_dqPE3; dadq_prev_vec_in_LY_dqPE3 = dadq_curr_vec_reg_LY_dqPE3; dadq_prev_vec_in_LZ_dqPE3 = dadq_curr_vec_reg_LZ_dqPE3; 
      // dqPE4
      dvdq_prev_vec_in_AX_dqPE4 = dvdq_curr_vec_reg_AX_dqPE4; dvdq_prev_vec_in_AY_dqPE4 = dvdq_curr_vec_reg_AY_dqPE4; dvdq_prev_vec_in_AZ_dqPE4 = dvdq_curr_vec_reg_AZ_dqPE4; dvdq_prev_vec_in_LX_dqPE4 = dvdq_curr_vec_reg_LX_dqPE4; dvdq_prev_vec_in_LY_dqPE4 = dvdq_curr_vec_reg_LY_dqPE4; dvdq_prev_vec_in_LZ_dqPE4 = dvdq_curr_vec_reg_LZ_dqPE4; 
      dadq_prev_vec_in_AX_dqPE4 = dadq_curr_vec_reg_AX_dqPE4; dadq_prev_vec_in_AY_dqPE4 = dadq_curr_vec_reg_AY_dqPE4; dadq_prev_vec_in_AZ_dqPE4 = dadq_curr_vec_reg_AZ_dqPE4; dadq_prev_vec_in_LX_dqPE4 = dadq_curr_vec_reg_LX_dqPE4; dadq_prev_vec_in_LY_dqPE4 = dadq_curr_vec_reg_LY_dqPE4; dadq_prev_vec_in_LZ_dqPE4 = dadq_curr_vec_reg_LZ_dqPE4; 
      // dqPE5
      dvdq_prev_vec_in_AX_dqPE5 = dvdq_curr_vec_reg_AX_dqPE5; dvdq_prev_vec_in_AY_dqPE5 = dvdq_curr_vec_reg_AY_dqPE5; dvdq_prev_vec_in_AZ_dqPE5 = dvdq_curr_vec_reg_AZ_dqPE5; dvdq_prev_vec_in_LX_dqPE5 = dvdq_curr_vec_reg_LX_dqPE5; dvdq_prev_vec_in_LY_dqPE5 = dvdq_curr_vec_reg_LY_dqPE5; dvdq_prev_vec_in_LZ_dqPE5 = dvdq_curr_vec_reg_LZ_dqPE5; 
      dadq_prev_vec_in_AX_dqPE5 = dadq_curr_vec_reg_AX_dqPE5; dadq_prev_vec_in_AY_dqPE5 = dadq_curr_vec_reg_AY_dqPE5; dadq_prev_vec_in_AZ_dqPE5 = dadq_curr_vec_reg_AZ_dqPE5; dadq_prev_vec_in_LX_dqPE5 = dadq_curr_vec_reg_LX_dqPE5; dadq_prev_vec_in_LY_dqPE5 = dadq_curr_vec_reg_LY_dqPE5; dadq_prev_vec_in_LZ_dqPE5 = dadq_curr_vec_reg_LZ_dqPE5; 
      // dqPE6
      dvdq_prev_vec_in_AX_dqPE6 = dvdq_curr_vec_reg_AX_dqPE6; dvdq_prev_vec_in_AY_dqPE6 = dvdq_curr_vec_reg_AY_dqPE6; dvdq_prev_vec_in_AZ_dqPE6 = dvdq_curr_vec_reg_AZ_dqPE6; dvdq_prev_vec_in_LX_dqPE6 = dvdq_curr_vec_reg_LX_dqPE6; dvdq_prev_vec_in_LY_dqPE6 = dvdq_curr_vec_reg_LY_dqPE6; dvdq_prev_vec_in_LZ_dqPE6 = dvdq_curr_vec_reg_LZ_dqPE6; 
      dadq_prev_vec_in_AX_dqPE6 = dadq_curr_vec_reg_AX_dqPE6; dadq_prev_vec_in_AY_dqPE6 = dadq_curr_vec_reg_AY_dqPE6; dadq_prev_vec_in_AZ_dqPE6 = dadq_curr_vec_reg_AZ_dqPE6; dadq_prev_vec_in_LX_dqPE6 = dadq_curr_vec_reg_LX_dqPE6; dadq_prev_vec_in_LY_dqPE6 = dadq_curr_vec_reg_LY_dqPE6; dadq_prev_vec_in_LZ_dqPE6 = dadq_curr_vec_reg_LZ_dqPE6; 
      // dqPE7
      dvdq_prev_vec_in_AX_dqPE7 = dvdq_curr_vec_reg_AX_dqPE7; dvdq_prev_vec_in_AY_dqPE7 = dvdq_curr_vec_reg_AY_dqPE7; dvdq_prev_vec_in_AZ_dqPE7 = dvdq_curr_vec_reg_AZ_dqPE7; dvdq_prev_vec_in_LX_dqPE7 = dvdq_curr_vec_reg_LX_dqPE7; dvdq_prev_vec_in_LY_dqPE7 = dvdq_curr_vec_reg_LY_dqPE7; dvdq_prev_vec_in_LZ_dqPE7 = dvdq_curr_vec_reg_LZ_dqPE7; 
      dadq_prev_vec_in_AX_dqPE7 = dadq_curr_vec_reg_AX_dqPE7; dadq_prev_vec_in_AY_dqPE7 = dadq_curr_vec_reg_AY_dqPE7; dadq_prev_vec_in_AZ_dqPE7 = dadq_curr_vec_reg_AZ_dqPE7; dadq_prev_vec_in_LX_dqPE7 = dadq_curr_vec_reg_LX_dqPE7; dadq_prev_vec_in_LY_dqPE7 = dadq_curr_vec_reg_LY_dqPE7; dadq_prev_vec_in_LZ_dqPE7 = dadq_curr_vec_reg_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 3'd5;
      derv_in_dqdPE1 = 3'd1;
      sinq_val_in_dqdPE1 = -32'd48758; cosq_val_in_dqdPE1 = 32'd43790;
      qd_val_in_dqdPE1 = 32'd28646;
      v_curr_vec_in_AX_dqdPE1 = -32'd6608; v_curr_vec_in_AY_dqdPE1 = 32'd47337; v_curr_vec_in_AZ_dqdPE1 = 32'd153790; v_curr_vec_in_LX_dqdPE1 = 32'd17985; v_curr_vec_in_LY_dqdPE1 = -32'd7019; v_curr_vec_in_LZ_dqdPE1 = -32'd1;
      a_curr_vec_in_AX_dqdPE1 = -32'd131010; a_curr_vec_in_AY_dqdPE1 = 32'd184057; a_curr_vec_in_AZ_dqdPE1 = 32'd1684917; a_curr_vec_in_LX_dqdPE1 = 32'd27757; a_curr_vec_in_LY_dqdPE1 = -32'd47665; a_curr_vec_in_LZ_dqdPE1 = 32'd574;
      // dqdPE2
      link_in_dqdPE2 = 3'd5;
      derv_in_dqdPE2 = 3'd2;
      sinq_val_in_dqdPE2 = -32'd48758; cosq_val_in_dqdPE2 = 32'd43790;
      qd_val_in_dqdPE2 = 32'd28646;
      v_curr_vec_in_AX_dqdPE2 = -32'd6608; v_curr_vec_in_AY_dqdPE2 = 32'd47337; v_curr_vec_in_AZ_dqdPE2 = 32'd153790; v_curr_vec_in_LX_dqdPE2 = 32'd17985; v_curr_vec_in_LY_dqdPE2 = -32'd7019; v_curr_vec_in_LZ_dqdPE2 = -32'd1;
      a_curr_vec_in_AX_dqdPE2 = -32'd131010; a_curr_vec_in_AY_dqdPE2 = 32'd184057; a_curr_vec_in_AZ_dqdPE2 = 32'd1684917; a_curr_vec_in_LX_dqdPE2 = 32'd27757; a_curr_vec_in_LY_dqdPE2 = -32'd47665; a_curr_vec_in_LZ_dqdPE2 = 32'd574;
      // dqdPE3
      link_in_dqdPE3 = 3'd5;
      derv_in_dqdPE3 = 3'd3;
      sinq_val_in_dqdPE3 = -32'd48758; cosq_val_in_dqdPE3 = 32'd43790;
      qd_val_in_dqdPE3 = 32'd28646;
      v_curr_vec_in_AX_dqdPE3 = -32'd6608; v_curr_vec_in_AY_dqdPE3 = 32'd47337; v_curr_vec_in_AZ_dqdPE3 = 32'd153790; v_curr_vec_in_LX_dqdPE3 = 32'd17985; v_curr_vec_in_LY_dqdPE3 = -32'd7019; v_curr_vec_in_LZ_dqdPE3 = -32'd1;
      a_curr_vec_in_AX_dqdPE3 = -32'd131010; a_curr_vec_in_AY_dqdPE3 = 32'd184057; a_curr_vec_in_AZ_dqdPE3 = 32'd1684917; a_curr_vec_in_LX_dqdPE3 = 32'd27757; a_curr_vec_in_LY_dqdPE3 = -32'd47665; a_curr_vec_in_LZ_dqdPE3 = 32'd574;
      // dqdPE4
      link_in_dqdPE4 = 3'd5;
      derv_in_dqdPE4 = 3'd4;
      sinq_val_in_dqdPE4 = -32'd48758; cosq_val_in_dqdPE4 = 32'd43790;
      qd_val_in_dqdPE4 = 32'd28646;
      v_curr_vec_in_AX_dqdPE4 = -32'd6608; v_curr_vec_in_AY_dqdPE4 = 32'd47337; v_curr_vec_in_AZ_dqdPE4 = 32'd153790; v_curr_vec_in_LX_dqdPE4 = 32'd17985; v_curr_vec_in_LY_dqdPE4 = -32'd7019; v_curr_vec_in_LZ_dqdPE4 = -32'd1;
      a_curr_vec_in_AX_dqdPE4 = -32'd131010; a_curr_vec_in_AY_dqdPE4 = 32'd184057; a_curr_vec_in_AZ_dqdPE4 = 32'd1684917; a_curr_vec_in_LX_dqdPE4 = 32'd27757; a_curr_vec_in_LY_dqdPE4 = -32'd47665; a_curr_vec_in_LZ_dqdPE4 = 32'd574;
      // dqdPE5
      link_in_dqdPE5 = 3'd5;
      derv_in_dqdPE5 = 3'd5;
      sinq_val_in_dqdPE5 = -32'd48758; cosq_val_in_dqdPE5 = 32'd43790;
      qd_val_in_dqdPE5 = 32'd28646;
      v_curr_vec_in_AX_dqdPE5 = -32'd6608; v_curr_vec_in_AY_dqdPE5 = 32'd47337; v_curr_vec_in_AZ_dqdPE5 = 32'd153790; v_curr_vec_in_LX_dqdPE5 = 32'd17985; v_curr_vec_in_LY_dqdPE5 = -32'd7019; v_curr_vec_in_LZ_dqdPE5 = -32'd1;
      a_curr_vec_in_AX_dqdPE5 = -32'd131010; a_curr_vec_in_AY_dqdPE5 = 32'd184057; a_curr_vec_in_AZ_dqdPE5 = 32'd1684917; a_curr_vec_in_LX_dqdPE5 = 32'd27757; a_curr_vec_in_LY_dqdPE5 = -32'd47665; a_curr_vec_in_LZ_dqdPE5 = 32'd574;
      // dqdPE6
      link_in_dqdPE6 = 3'd5;
      derv_in_dqdPE6 = 3'd6;
      sinq_val_in_dqdPE6 = -32'd48758; cosq_val_in_dqdPE6 = 32'd43790;
      qd_val_in_dqdPE6 = 32'd28646;
      v_curr_vec_in_AX_dqdPE6 = -32'd6608; v_curr_vec_in_AY_dqdPE6 = 32'd47337; v_curr_vec_in_AZ_dqdPE6 = 32'd153790; v_curr_vec_in_LX_dqdPE6 = 32'd17985; v_curr_vec_in_LY_dqdPE6 = -32'd7019; v_curr_vec_in_LZ_dqdPE6 = -32'd1;
      a_curr_vec_in_AX_dqdPE6 = -32'd131010; a_curr_vec_in_AY_dqdPE6 = 32'd184057; a_curr_vec_in_AZ_dqdPE6 = 32'd1684917; a_curr_vec_in_LX_dqdPE6 = 32'd27757; a_curr_vec_in_LY_dqdPE6 = -32'd47665; a_curr_vec_in_LZ_dqdPE6 = 32'd574;
      // dqdPE7
      link_in_dqdPE7 = 3'd5;
      derv_in_dqdPE7 = 3'd7;
      sinq_val_in_dqdPE7 = -32'd48758; cosq_val_in_dqdPE7 = 32'd43790;
      qd_val_in_dqdPE7 = 32'd28646;
      v_curr_vec_in_AX_dqdPE7 = -32'd6608; v_curr_vec_in_AY_dqdPE7 = 32'd47337; v_curr_vec_in_AZ_dqdPE7 = 32'd153790; v_curr_vec_in_LX_dqdPE7 = 32'd17985; v_curr_vec_in_LY_dqdPE7 = -32'd7019; v_curr_vec_in_LZ_dqdPE7 = -32'd1;
      a_curr_vec_in_AX_dqdPE7 = -32'd131010; a_curr_vec_in_AY_dqdPE7 = 32'd184057; a_curr_vec_in_AZ_dqdPE7 = 32'd1684917; a_curr_vec_in_LX_dqdPE7 = 32'd27757; a_curr_vec_in_LY_dqdPE7 = -32'd47665; a_curr_vec_in_LZ_dqdPE7 = 32'd574;
      // External dv,da
      // dqdPE1
      dvdqd_prev_vec_in_AX_dqdPE1 = dvdqd_curr_vec_reg_AX_dqdPE1; dvdqd_prev_vec_in_AY_dqdPE1 = dvdqd_curr_vec_reg_AY_dqdPE1; dvdqd_prev_vec_in_AZ_dqdPE1 = dvdqd_curr_vec_reg_AZ_dqdPE1; dvdqd_prev_vec_in_LX_dqdPE1 = dvdqd_curr_vec_reg_LX_dqdPE1; dvdqd_prev_vec_in_LY_dqdPE1 = dvdqd_curr_vec_reg_LY_dqdPE1; dvdqd_prev_vec_in_LZ_dqdPE1 = dvdqd_curr_vec_reg_LZ_dqdPE1; 
      dadqd_prev_vec_in_AX_dqdPE1 = dadqd_curr_vec_reg_AX_dqdPE1; dadqd_prev_vec_in_AY_dqdPE1 = dadqd_curr_vec_reg_AY_dqdPE1; dadqd_prev_vec_in_AZ_dqdPE1 = dadqd_curr_vec_reg_AZ_dqdPE1; dadqd_prev_vec_in_LX_dqdPE1 = dadqd_curr_vec_reg_LX_dqdPE1; dadqd_prev_vec_in_LY_dqdPE1 = dadqd_curr_vec_reg_LY_dqdPE1; dadqd_prev_vec_in_LZ_dqdPE1 = dadqd_curr_vec_reg_LZ_dqdPE1; 
      // dqdPE2
      dvdqd_prev_vec_in_AX_dqdPE2 = dvdqd_curr_vec_reg_AX_dqdPE2; dvdqd_prev_vec_in_AY_dqdPE2 = dvdqd_curr_vec_reg_AY_dqdPE2; dvdqd_prev_vec_in_AZ_dqdPE2 = dvdqd_curr_vec_reg_AZ_dqdPE2; dvdqd_prev_vec_in_LX_dqdPE2 = dvdqd_curr_vec_reg_LX_dqdPE2; dvdqd_prev_vec_in_LY_dqdPE2 = dvdqd_curr_vec_reg_LY_dqdPE2; dvdqd_prev_vec_in_LZ_dqdPE2 = dvdqd_curr_vec_reg_LZ_dqdPE2; 
      dadqd_prev_vec_in_AX_dqdPE2 = dadqd_curr_vec_reg_AX_dqdPE2; dadqd_prev_vec_in_AY_dqdPE2 = dadqd_curr_vec_reg_AY_dqdPE2; dadqd_prev_vec_in_AZ_dqdPE2 = dadqd_curr_vec_reg_AZ_dqdPE2; dadqd_prev_vec_in_LX_dqdPE2 = dadqd_curr_vec_reg_LX_dqdPE2; dadqd_prev_vec_in_LY_dqdPE2 = dadqd_curr_vec_reg_LY_dqdPE2; dadqd_prev_vec_in_LZ_dqdPE2 = dadqd_curr_vec_reg_LZ_dqdPE2; 
      // dqdPE3
      dvdqd_prev_vec_in_AX_dqdPE3 = dvdqd_curr_vec_reg_AX_dqdPE3; dvdqd_prev_vec_in_AY_dqdPE3 = dvdqd_curr_vec_reg_AY_dqdPE3; dvdqd_prev_vec_in_AZ_dqdPE3 = dvdqd_curr_vec_reg_AZ_dqdPE3; dvdqd_prev_vec_in_LX_dqdPE3 = dvdqd_curr_vec_reg_LX_dqdPE3; dvdqd_prev_vec_in_LY_dqdPE3 = dvdqd_curr_vec_reg_LY_dqdPE3; dvdqd_prev_vec_in_LZ_dqdPE3 = dvdqd_curr_vec_reg_LZ_dqdPE3; 
      dadqd_prev_vec_in_AX_dqdPE3 = dadqd_curr_vec_reg_AX_dqdPE3; dadqd_prev_vec_in_AY_dqdPE3 = dadqd_curr_vec_reg_AY_dqdPE3; dadqd_prev_vec_in_AZ_dqdPE3 = dadqd_curr_vec_reg_AZ_dqdPE3; dadqd_prev_vec_in_LX_dqdPE3 = dadqd_curr_vec_reg_LX_dqdPE3; dadqd_prev_vec_in_LY_dqdPE3 = dadqd_curr_vec_reg_LY_dqdPE3; dadqd_prev_vec_in_LZ_dqdPE3 = dadqd_curr_vec_reg_LZ_dqdPE3; 
      // dqdPE4
      dvdqd_prev_vec_in_AX_dqdPE4 = dvdqd_curr_vec_reg_AX_dqdPE4; dvdqd_prev_vec_in_AY_dqdPE4 = dvdqd_curr_vec_reg_AY_dqdPE4; dvdqd_prev_vec_in_AZ_dqdPE4 = dvdqd_curr_vec_reg_AZ_dqdPE4; dvdqd_prev_vec_in_LX_dqdPE4 = dvdqd_curr_vec_reg_LX_dqdPE4; dvdqd_prev_vec_in_LY_dqdPE4 = dvdqd_curr_vec_reg_LY_dqdPE4; dvdqd_prev_vec_in_LZ_dqdPE4 = dvdqd_curr_vec_reg_LZ_dqdPE4; 
      dadqd_prev_vec_in_AX_dqdPE4 = dadqd_curr_vec_reg_AX_dqdPE4; dadqd_prev_vec_in_AY_dqdPE4 = dadqd_curr_vec_reg_AY_dqdPE4; dadqd_prev_vec_in_AZ_dqdPE4 = dadqd_curr_vec_reg_AZ_dqdPE4; dadqd_prev_vec_in_LX_dqdPE4 = dadqd_curr_vec_reg_LX_dqdPE4; dadqd_prev_vec_in_LY_dqdPE4 = dadqd_curr_vec_reg_LY_dqdPE4; dadqd_prev_vec_in_LZ_dqdPE4 = dadqd_curr_vec_reg_LZ_dqdPE4; 
      // dqdPE5
      dvdqd_prev_vec_in_AX_dqdPE5 = dvdqd_curr_vec_reg_AX_dqdPE5; dvdqd_prev_vec_in_AY_dqdPE5 = dvdqd_curr_vec_reg_AY_dqdPE5; dvdqd_prev_vec_in_AZ_dqdPE5 = dvdqd_curr_vec_reg_AZ_dqdPE5; dvdqd_prev_vec_in_LX_dqdPE5 = dvdqd_curr_vec_reg_LX_dqdPE5; dvdqd_prev_vec_in_LY_dqdPE5 = dvdqd_curr_vec_reg_LY_dqdPE5; dvdqd_prev_vec_in_LZ_dqdPE5 = dvdqd_curr_vec_reg_LZ_dqdPE5; 
      dadqd_prev_vec_in_AX_dqdPE5 = dadqd_curr_vec_reg_AX_dqdPE5; dadqd_prev_vec_in_AY_dqdPE5 = dadqd_curr_vec_reg_AY_dqdPE5; dadqd_prev_vec_in_AZ_dqdPE5 = dadqd_curr_vec_reg_AZ_dqdPE5; dadqd_prev_vec_in_LX_dqdPE5 = dadqd_curr_vec_reg_LX_dqdPE5; dadqd_prev_vec_in_LY_dqdPE5 = dadqd_curr_vec_reg_LY_dqdPE5; dadqd_prev_vec_in_LZ_dqdPE5 = dadqd_curr_vec_reg_LZ_dqdPE5; 
      // dqdPE6
      dvdqd_prev_vec_in_AX_dqdPE6 = dvdqd_curr_vec_reg_AX_dqdPE6; dvdqd_prev_vec_in_AY_dqdPE6 = dvdqd_curr_vec_reg_AY_dqdPE6; dvdqd_prev_vec_in_AZ_dqdPE6 = dvdqd_curr_vec_reg_AZ_dqdPE6; dvdqd_prev_vec_in_LX_dqdPE6 = dvdqd_curr_vec_reg_LX_dqdPE6; dvdqd_prev_vec_in_LY_dqdPE6 = dvdqd_curr_vec_reg_LY_dqdPE6; dvdqd_prev_vec_in_LZ_dqdPE6 = dvdqd_curr_vec_reg_LZ_dqdPE6; 
      dadqd_prev_vec_in_AX_dqdPE6 = dadqd_curr_vec_reg_AX_dqdPE6; dadqd_prev_vec_in_AY_dqdPE6 = dadqd_curr_vec_reg_AY_dqdPE6; dadqd_prev_vec_in_AZ_dqdPE6 = dadqd_curr_vec_reg_AZ_dqdPE6; dadqd_prev_vec_in_LX_dqdPE6 = dadqd_curr_vec_reg_LX_dqdPE6; dadqd_prev_vec_in_LY_dqdPE6 = dadqd_curr_vec_reg_LY_dqdPE6; dadqd_prev_vec_in_LZ_dqdPE6 = dadqd_curr_vec_reg_LZ_dqdPE6; 
      // dqdPE7
      dvdqd_prev_vec_in_AX_dqdPE7 = dvdqd_curr_vec_reg_AX_dqdPE7; dvdqd_prev_vec_in_AY_dqdPE7 = dvdqd_curr_vec_reg_AY_dqdPE7; dvdqd_prev_vec_in_AZ_dqdPE7 = dvdqd_curr_vec_reg_AZ_dqdPE7; dvdqd_prev_vec_in_LX_dqdPE7 = dvdqd_curr_vec_reg_LX_dqdPE7; dvdqd_prev_vec_in_LY_dqdPE7 = dvdqd_curr_vec_reg_LY_dqdPE7; dvdqd_prev_vec_in_LZ_dqdPE7 = dvdqd_curr_vec_reg_LZ_dqdPE7; 
      dadqd_prev_vec_in_AX_dqdPE7 = dadqd_curr_vec_reg_AX_dqdPE7; dadqd_prev_vec_in_AY_dqdPE7 = dadqd_curr_vec_reg_AY_dqdPE7; dadqd_prev_vec_in_AZ_dqdPE7 = dadqd_curr_vec_reg_AZ_dqdPE7; dadqd_prev_vec_in_LX_dqdPE7 = dadqd_curr_vec_reg_LX_dqdPE7; dadqd_prev_vec_in_LY_dqdPE7 = dadqd_curr_vec_reg_LY_dqdPE7; dadqd_prev_vec_in_LZ_dqdPE7 = dadqd_curr_vec_reg_LZ_dqdPE7; 
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
      $display ("// Link 6 RNEA");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",2203, 5901, 31413, 121437, -77713, -83897);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_curr_vec_out_AX_rnea,f_curr_vec_out_AY_rnea,f_curr_vec_out_AZ_rnea,f_curr_vec_out_LX_rnea,f_curr_vec_out_LY_rnea,f_curr_vec_out_LZ_rnea);
      $display ("//-------------------------------------------------------------------------------------------------------");
      $display ("// Link 5 Derivatives");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -4354, 3320, 7150, 10972, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 4610, -12747, -7214, 5786, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -1038, 2853, 1647, -564, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 48590, -137401, -65942, 23191, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 45129, -36066, -70817, -96617, 0, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -62580, 13151, -4659, 7121, 0, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AX_dqPE1,dfdq_curr_vec_out_AX_dqPE2,dfdq_curr_vec_out_AX_dqPE3,dfdq_curr_vec_out_AX_dqPE4,dfdq_curr_vec_out_AX_dqPE5,dfdq_curr_vec_out_AX_dqPE6,dfdq_curr_vec_out_AX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AY_dqPE1,dfdq_curr_vec_out_AY_dqPE2,dfdq_curr_vec_out_AY_dqPE3,dfdq_curr_vec_out_AY_dqPE4,dfdq_curr_vec_out_AY_dqPE5,dfdq_curr_vec_out_AY_dqPE6,dfdq_curr_vec_out_AY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AZ_dqPE1,dfdq_curr_vec_out_AZ_dqPE2,dfdq_curr_vec_out_AZ_dqPE3,dfdq_curr_vec_out_AZ_dqPE4,dfdq_curr_vec_out_AZ_dqPE5,dfdq_curr_vec_out_AZ_dqPE6,dfdq_curr_vec_out_AZ_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LX_dqPE1,dfdq_curr_vec_out_LX_dqPE2,dfdq_curr_vec_out_LX_dqPE3,dfdq_curr_vec_out_LX_dqPE4,dfdq_curr_vec_out_LX_dqPE5,dfdq_curr_vec_out_LX_dqPE6,dfdq_curr_vec_out_LX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LY_dqPE1,dfdq_curr_vec_out_LY_dqPE2,dfdq_curr_vec_out_LY_dqPE3,dfdq_curr_vec_out_LY_dqPE4,dfdq_curr_vec_out_LY_dqPE5,dfdq_curr_vec_out_LY_dqPE6,dfdq_curr_vec_out_LY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LZ_dqPE1,dfdq_curr_vec_out_LZ_dqPE2,dfdq_curr_vec_out_LZ_dqPE3,dfdq_curr_vec_out_LZ_dqPE4,dfdq_curr_vec_out_LZ_dqPE5,dfdq_curr_vec_out_LZ_dqPE6,dfdq_curr_vec_out_LZ_dqPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -5945, 1309, -1513, -8879, 1237, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 1314, 12420, -2697, -9465, 16, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -394, -3077, 491, 2025, 0, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 20251, 140949, -23281, -84990, -52, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 57716, -18551, 11438, 73710, -10981, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -24770, -13522, 1380, -31010, 3378, 0, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AX_dqdPE1,dfdqd_curr_vec_out_AX_dqdPE2,dfdqd_curr_vec_out_AX_dqdPE3,dfdqd_curr_vec_out_AX_dqdPE4,dfdqd_curr_vec_out_AX_dqdPE5,dfdqd_curr_vec_out_AX_dqdPE6,dfdqd_curr_vec_out_AX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AY_dqdPE1,dfdqd_curr_vec_out_AY_dqdPE2,dfdqd_curr_vec_out_AY_dqdPE3,dfdqd_curr_vec_out_AY_dqdPE4,dfdqd_curr_vec_out_AY_dqdPE5,dfdqd_curr_vec_out_AY_dqdPE6,dfdqd_curr_vec_out_AY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AZ_dqdPE1,dfdqd_curr_vec_out_AZ_dqdPE2,dfdqd_curr_vec_out_AZ_dqdPE3,dfdqd_curr_vec_out_AZ_dqdPE4,dfdqd_curr_vec_out_AZ_dqdPE5,dfdqd_curr_vec_out_AZ_dqdPE6,dfdqd_curr_vec_out_AZ_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LX_dqdPE1,dfdqd_curr_vec_out_LX_dqdPE2,dfdqd_curr_vec_out_LX_dqdPE3,dfdqd_curr_vec_out_LX_dqdPE4,dfdqd_curr_vec_out_LX_dqdPE5,dfdqd_curr_vec_out_LX_dqdPE6,dfdqd_curr_vec_out_LX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LY_dqdPE1,dfdqd_curr_vec_out_LY_dqdPE2,dfdqd_curr_vec_out_LY_dqdPE3,dfdqd_curr_vec_out_LY_dqdPE4,dfdqd_curr_vec_out_LY_dqdPE5,dfdqd_curr_vec_out_LY_dqdPE6,dfdqd_curr_vec_out_LY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LZ_dqdPE1,dfdqd_curr_vec_out_LZ_dqdPE2,dfdqd_curr_vec_out_LZ_dqdPE3,dfdqd_curr_vec_out_LZ_dqdPE4,dfdqd_curr_vec_out_LZ_dqdPE5,dfdqd_curr_vec_out_LZ_dqdPE6,dfdqd_curr_vec_out_LZ_dqdPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External dv,da
      //------------------------------------------------------------------------
      // dqPE1
      dvdq_curr_vec_reg_AX_dqPE1 = dvdq_curr_vec_out_AX_dqPE1; dvdq_curr_vec_reg_AY_dqPE1 = dvdq_curr_vec_out_AY_dqPE1; dvdq_curr_vec_reg_AZ_dqPE1 = dvdq_curr_vec_out_AZ_dqPE1; dvdq_curr_vec_reg_LX_dqPE1 = dvdq_curr_vec_out_LX_dqPE1; dvdq_curr_vec_reg_LY_dqPE1 = dvdq_curr_vec_out_LY_dqPE1; dvdq_curr_vec_reg_LZ_dqPE1 = dvdq_curr_vec_out_LZ_dqPE1; 
      dadq_curr_vec_reg_AX_dqPE1 = dadq_curr_vec_out_AX_dqPE1; dadq_curr_vec_reg_AY_dqPE1 = dadq_curr_vec_out_AY_dqPE1; dadq_curr_vec_reg_AZ_dqPE1 = dadq_curr_vec_out_AZ_dqPE1; dadq_curr_vec_reg_LX_dqPE1 = dadq_curr_vec_out_LX_dqPE1; dadq_curr_vec_reg_LY_dqPE1 = dadq_curr_vec_out_LY_dqPE1; dadq_curr_vec_reg_LZ_dqPE1 = dadq_curr_vec_out_LZ_dqPE1; 
      // dqPE2
      dvdq_curr_vec_reg_AX_dqPE2 = dvdq_curr_vec_out_AX_dqPE2; dvdq_curr_vec_reg_AY_dqPE2 = dvdq_curr_vec_out_AY_dqPE2; dvdq_curr_vec_reg_AZ_dqPE2 = dvdq_curr_vec_out_AZ_dqPE2; dvdq_curr_vec_reg_LX_dqPE2 = dvdq_curr_vec_out_LX_dqPE2; dvdq_curr_vec_reg_LY_dqPE2 = dvdq_curr_vec_out_LY_dqPE2; dvdq_curr_vec_reg_LZ_dqPE2 = dvdq_curr_vec_out_LZ_dqPE2; 
      dadq_curr_vec_reg_AX_dqPE2 = dadq_curr_vec_out_AX_dqPE2; dadq_curr_vec_reg_AY_dqPE2 = dadq_curr_vec_out_AY_dqPE2; dadq_curr_vec_reg_AZ_dqPE2 = dadq_curr_vec_out_AZ_dqPE2; dadq_curr_vec_reg_LX_dqPE2 = dadq_curr_vec_out_LX_dqPE2; dadq_curr_vec_reg_LY_dqPE2 = dadq_curr_vec_out_LY_dqPE2; dadq_curr_vec_reg_LZ_dqPE2 = dadq_curr_vec_out_LZ_dqPE2; 
      // dqPE3
      dvdq_curr_vec_reg_AX_dqPE3 = dvdq_curr_vec_out_AX_dqPE3; dvdq_curr_vec_reg_AY_dqPE3 = dvdq_curr_vec_out_AY_dqPE3; dvdq_curr_vec_reg_AZ_dqPE3 = dvdq_curr_vec_out_AZ_dqPE3; dvdq_curr_vec_reg_LX_dqPE3 = dvdq_curr_vec_out_LX_dqPE3; dvdq_curr_vec_reg_LY_dqPE3 = dvdq_curr_vec_out_LY_dqPE3; dvdq_curr_vec_reg_LZ_dqPE3 = dvdq_curr_vec_out_LZ_dqPE3; 
      dadq_curr_vec_reg_AX_dqPE3 = dadq_curr_vec_out_AX_dqPE3; dadq_curr_vec_reg_AY_dqPE3 = dadq_curr_vec_out_AY_dqPE3; dadq_curr_vec_reg_AZ_dqPE3 = dadq_curr_vec_out_AZ_dqPE3; dadq_curr_vec_reg_LX_dqPE3 = dadq_curr_vec_out_LX_dqPE3; dadq_curr_vec_reg_LY_dqPE3 = dadq_curr_vec_out_LY_dqPE3; dadq_curr_vec_reg_LZ_dqPE3 = dadq_curr_vec_out_LZ_dqPE3; 
      // dqPE4
      dvdq_curr_vec_reg_AX_dqPE4 = dvdq_curr_vec_out_AX_dqPE4; dvdq_curr_vec_reg_AY_dqPE4 = dvdq_curr_vec_out_AY_dqPE4; dvdq_curr_vec_reg_AZ_dqPE4 = dvdq_curr_vec_out_AZ_dqPE4; dvdq_curr_vec_reg_LX_dqPE4 = dvdq_curr_vec_out_LX_dqPE4; dvdq_curr_vec_reg_LY_dqPE4 = dvdq_curr_vec_out_LY_dqPE4; dvdq_curr_vec_reg_LZ_dqPE4 = dvdq_curr_vec_out_LZ_dqPE4; 
      dadq_curr_vec_reg_AX_dqPE4 = dadq_curr_vec_out_AX_dqPE4; dadq_curr_vec_reg_AY_dqPE4 = dadq_curr_vec_out_AY_dqPE4; dadq_curr_vec_reg_AZ_dqPE4 = dadq_curr_vec_out_AZ_dqPE4; dadq_curr_vec_reg_LX_dqPE4 = dadq_curr_vec_out_LX_dqPE4; dadq_curr_vec_reg_LY_dqPE4 = dadq_curr_vec_out_LY_dqPE4; dadq_curr_vec_reg_LZ_dqPE4 = dadq_curr_vec_out_LZ_dqPE4; 
      // dqPE5
      dvdq_curr_vec_reg_AX_dqPE5 = dvdq_curr_vec_out_AX_dqPE5; dvdq_curr_vec_reg_AY_dqPE5 = dvdq_curr_vec_out_AY_dqPE5; dvdq_curr_vec_reg_AZ_dqPE5 = dvdq_curr_vec_out_AZ_dqPE5; dvdq_curr_vec_reg_LX_dqPE5 = dvdq_curr_vec_out_LX_dqPE5; dvdq_curr_vec_reg_LY_dqPE5 = dvdq_curr_vec_out_LY_dqPE5; dvdq_curr_vec_reg_LZ_dqPE5 = dvdq_curr_vec_out_LZ_dqPE5; 
      dadq_curr_vec_reg_AX_dqPE5 = dadq_curr_vec_out_AX_dqPE5; dadq_curr_vec_reg_AY_dqPE5 = dadq_curr_vec_out_AY_dqPE5; dadq_curr_vec_reg_AZ_dqPE5 = dadq_curr_vec_out_AZ_dqPE5; dadq_curr_vec_reg_LX_dqPE5 = dadq_curr_vec_out_LX_dqPE5; dadq_curr_vec_reg_LY_dqPE5 = dadq_curr_vec_out_LY_dqPE5; dadq_curr_vec_reg_LZ_dqPE5 = dadq_curr_vec_out_LZ_dqPE5; 
      // dqPE6
      dvdq_curr_vec_reg_AX_dqPE6 = dvdq_curr_vec_out_AX_dqPE6; dvdq_curr_vec_reg_AY_dqPE6 = dvdq_curr_vec_out_AY_dqPE6; dvdq_curr_vec_reg_AZ_dqPE6 = dvdq_curr_vec_out_AZ_dqPE6; dvdq_curr_vec_reg_LX_dqPE6 = dvdq_curr_vec_out_LX_dqPE6; dvdq_curr_vec_reg_LY_dqPE6 = dvdq_curr_vec_out_LY_dqPE6; dvdq_curr_vec_reg_LZ_dqPE6 = dvdq_curr_vec_out_LZ_dqPE6; 
      dadq_curr_vec_reg_AX_dqPE6 = dadq_curr_vec_out_AX_dqPE6; dadq_curr_vec_reg_AY_dqPE6 = dadq_curr_vec_out_AY_dqPE6; dadq_curr_vec_reg_AZ_dqPE6 = dadq_curr_vec_out_AZ_dqPE6; dadq_curr_vec_reg_LX_dqPE6 = dadq_curr_vec_out_LX_dqPE6; dadq_curr_vec_reg_LY_dqPE6 = dadq_curr_vec_out_LY_dqPE6; dadq_curr_vec_reg_LZ_dqPE6 = dadq_curr_vec_out_LZ_dqPE6; 
      // dqPE7
      dvdq_curr_vec_reg_AX_dqPE7 = dvdq_curr_vec_out_AX_dqPE7; dvdq_curr_vec_reg_AY_dqPE7 = dvdq_curr_vec_out_AY_dqPE7; dvdq_curr_vec_reg_AZ_dqPE7 = dvdq_curr_vec_out_AZ_dqPE7; dvdq_curr_vec_reg_LX_dqPE7 = dvdq_curr_vec_out_LX_dqPE7; dvdq_curr_vec_reg_LY_dqPE7 = dvdq_curr_vec_out_LY_dqPE7; dvdq_curr_vec_reg_LZ_dqPE7 = dvdq_curr_vec_out_LZ_dqPE7; 
      dadq_curr_vec_reg_AX_dqPE7 = dadq_curr_vec_out_AX_dqPE7; dadq_curr_vec_reg_AY_dqPE7 = dadq_curr_vec_out_AY_dqPE7; dadq_curr_vec_reg_AZ_dqPE7 = dadq_curr_vec_out_AZ_dqPE7; dadq_curr_vec_reg_LX_dqPE7 = dadq_curr_vec_out_LX_dqPE7; dadq_curr_vec_reg_LY_dqPE7 = dadq_curr_vec_out_LY_dqPE7; dadq_curr_vec_reg_LZ_dqPE7 = dadq_curr_vec_out_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqdPE1
      dvdqd_curr_vec_reg_AX_dqdPE1 = dvdqd_curr_vec_out_AX_dqdPE1; dvdqd_curr_vec_reg_AY_dqdPE1 = dvdqd_curr_vec_out_AY_dqdPE1; dvdqd_curr_vec_reg_AZ_dqdPE1 = dvdqd_curr_vec_out_AZ_dqdPE1; dvdqd_curr_vec_reg_LX_dqdPE1 = dvdqd_curr_vec_out_LX_dqdPE1; dvdqd_curr_vec_reg_LY_dqdPE1 = dvdqd_curr_vec_out_LY_dqdPE1; dvdqd_curr_vec_reg_LZ_dqdPE1 = dvdqd_curr_vec_out_LZ_dqdPE1; 
      dadqd_curr_vec_reg_AX_dqdPE1 = dadqd_curr_vec_out_AX_dqdPE1; dadqd_curr_vec_reg_AY_dqdPE1 = dadqd_curr_vec_out_AY_dqdPE1; dadqd_curr_vec_reg_AZ_dqdPE1 = dadqd_curr_vec_out_AZ_dqdPE1; dadqd_curr_vec_reg_LX_dqdPE1 = dadqd_curr_vec_out_LX_dqdPE1; dadqd_curr_vec_reg_LY_dqdPE1 = dadqd_curr_vec_out_LY_dqdPE1; dadqd_curr_vec_reg_LZ_dqdPE1 = dadqd_curr_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dvdqd_curr_vec_reg_AX_dqdPE2 = dvdqd_curr_vec_out_AX_dqdPE2; dvdqd_curr_vec_reg_AY_dqdPE2 = dvdqd_curr_vec_out_AY_dqdPE2; dvdqd_curr_vec_reg_AZ_dqdPE2 = dvdqd_curr_vec_out_AZ_dqdPE2; dvdqd_curr_vec_reg_LX_dqdPE2 = dvdqd_curr_vec_out_LX_dqdPE2; dvdqd_curr_vec_reg_LY_dqdPE2 = dvdqd_curr_vec_out_LY_dqdPE2; dvdqd_curr_vec_reg_LZ_dqdPE2 = dvdqd_curr_vec_out_LZ_dqdPE2; 
      dadqd_curr_vec_reg_AX_dqdPE2 = dadqd_curr_vec_out_AX_dqdPE2; dadqd_curr_vec_reg_AY_dqdPE2 = dadqd_curr_vec_out_AY_dqdPE2; dadqd_curr_vec_reg_AZ_dqdPE2 = dadqd_curr_vec_out_AZ_dqdPE2; dadqd_curr_vec_reg_LX_dqdPE2 = dadqd_curr_vec_out_LX_dqdPE2; dadqd_curr_vec_reg_LY_dqdPE2 = dadqd_curr_vec_out_LY_dqdPE2; dadqd_curr_vec_reg_LZ_dqdPE2 = dadqd_curr_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dvdqd_curr_vec_reg_AX_dqdPE3 = dvdqd_curr_vec_out_AX_dqdPE3; dvdqd_curr_vec_reg_AY_dqdPE3 = dvdqd_curr_vec_out_AY_dqdPE3; dvdqd_curr_vec_reg_AZ_dqdPE3 = dvdqd_curr_vec_out_AZ_dqdPE3; dvdqd_curr_vec_reg_LX_dqdPE3 = dvdqd_curr_vec_out_LX_dqdPE3; dvdqd_curr_vec_reg_LY_dqdPE3 = dvdqd_curr_vec_out_LY_dqdPE3; dvdqd_curr_vec_reg_LZ_dqdPE3 = dvdqd_curr_vec_out_LZ_dqdPE3; 
      dadqd_curr_vec_reg_AX_dqdPE3 = dadqd_curr_vec_out_AX_dqdPE3; dadqd_curr_vec_reg_AY_dqdPE3 = dadqd_curr_vec_out_AY_dqdPE3; dadqd_curr_vec_reg_AZ_dqdPE3 = dadqd_curr_vec_out_AZ_dqdPE3; dadqd_curr_vec_reg_LX_dqdPE3 = dadqd_curr_vec_out_LX_dqdPE3; dadqd_curr_vec_reg_LY_dqdPE3 = dadqd_curr_vec_out_LY_dqdPE3; dadqd_curr_vec_reg_LZ_dqdPE3 = dadqd_curr_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dvdqd_curr_vec_reg_AX_dqdPE4 = dvdqd_curr_vec_out_AX_dqdPE4; dvdqd_curr_vec_reg_AY_dqdPE4 = dvdqd_curr_vec_out_AY_dqdPE4; dvdqd_curr_vec_reg_AZ_dqdPE4 = dvdqd_curr_vec_out_AZ_dqdPE4; dvdqd_curr_vec_reg_LX_dqdPE4 = dvdqd_curr_vec_out_LX_dqdPE4; dvdqd_curr_vec_reg_LY_dqdPE4 = dvdqd_curr_vec_out_LY_dqdPE4; dvdqd_curr_vec_reg_LZ_dqdPE4 = dvdqd_curr_vec_out_LZ_dqdPE4; 
      dadqd_curr_vec_reg_AX_dqdPE4 = dadqd_curr_vec_out_AX_dqdPE4; dadqd_curr_vec_reg_AY_dqdPE4 = dadqd_curr_vec_out_AY_dqdPE4; dadqd_curr_vec_reg_AZ_dqdPE4 = dadqd_curr_vec_out_AZ_dqdPE4; dadqd_curr_vec_reg_LX_dqdPE4 = dadqd_curr_vec_out_LX_dqdPE4; dadqd_curr_vec_reg_LY_dqdPE4 = dadqd_curr_vec_out_LY_dqdPE4; dadqd_curr_vec_reg_LZ_dqdPE4 = dadqd_curr_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dvdqd_curr_vec_reg_AX_dqdPE5 = dvdqd_curr_vec_out_AX_dqdPE5; dvdqd_curr_vec_reg_AY_dqdPE5 = dvdqd_curr_vec_out_AY_dqdPE5; dvdqd_curr_vec_reg_AZ_dqdPE5 = dvdqd_curr_vec_out_AZ_dqdPE5; dvdqd_curr_vec_reg_LX_dqdPE5 = dvdqd_curr_vec_out_LX_dqdPE5; dvdqd_curr_vec_reg_LY_dqdPE5 = dvdqd_curr_vec_out_LY_dqdPE5; dvdqd_curr_vec_reg_LZ_dqdPE5 = dvdqd_curr_vec_out_LZ_dqdPE5; 
      dadqd_curr_vec_reg_AX_dqdPE5 = dadqd_curr_vec_out_AX_dqdPE5; dadqd_curr_vec_reg_AY_dqdPE5 = dadqd_curr_vec_out_AY_dqdPE5; dadqd_curr_vec_reg_AZ_dqdPE5 = dadqd_curr_vec_out_AZ_dqdPE5; dadqd_curr_vec_reg_LX_dqdPE5 = dadqd_curr_vec_out_LX_dqdPE5; dadqd_curr_vec_reg_LY_dqdPE5 = dadqd_curr_vec_out_LY_dqdPE5; dadqd_curr_vec_reg_LZ_dqdPE5 = dadqd_curr_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dvdqd_curr_vec_reg_AX_dqdPE6 = dvdqd_curr_vec_out_AX_dqdPE6; dvdqd_curr_vec_reg_AY_dqdPE6 = dvdqd_curr_vec_out_AY_dqdPE6; dvdqd_curr_vec_reg_AZ_dqdPE6 = dvdqd_curr_vec_out_AZ_dqdPE6; dvdqd_curr_vec_reg_LX_dqdPE6 = dvdqd_curr_vec_out_LX_dqdPE6; dvdqd_curr_vec_reg_LY_dqdPE6 = dvdqd_curr_vec_out_LY_dqdPE6; dvdqd_curr_vec_reg_LZ_dqdPE6 = dvdqd_curr_vec_out_LZ_dqdPE6; 
      dadqd_curr_vec_reg_AX_dqdPE6 = dadqd_curr_vec_out_AX_dqdPE6; dadqd_curr_vec_reg_AY_dqdPE6 = dadqd_curr_vec_out_AY_dqdPE6; dadqd_curr_vec_reg_AZ_dqdPE6 = dadqd_curr_vec_out_AZ_dqdPE6; dadqd_curr_vec_reg_LX_dqdPE6 = dadqd_curr_vec_out_LX_dqdPE6; dadqd_curr_vec_reg_LY_dqdPE6 = dadqd_curr_vec_out_LY_dqdPE6; dadqd_curr_vec_reg_LZ_dqdPE6 = dadqd_curr_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dvdqd_curr_vec_reg_AX_dqdPE7 = dvdqd_curr_vec_out_AX_dqdPE7; dvdqd_curr_vec_reg_AY_dqdPE7 = dvdqd_curr_vec_out_AY_dqdPE7; dvdqd_curr_vec_reg_AZ_dqdPE7 = dvdqd_curr_vec_out_AZ_dqdPE7; dvdqd_curr_vec_reg_LX_dqdPE7 = dvdqd_curr_vec_out_LX_dqdPE7; dvdqd_curr_vec_reg_LY_dqdPE7 = dvdqd_curr_vec_out_LY_dqdPE7; dvdqd_curr_vec_reg_LZ_dqdPE7 = dvdqd_curr_vec_out_LZ_dqdPE7; 
      dadqd_curr_vec_reg_AX_dqdPE7 = dadqd_curr_vec_out_AX_dqdPE7; dadqd_curr_vec_reg_AY_dqdPE7 = dadqd_curr_vec_out_AY_dqdPE7; dadqd_curr_vec_reg_AZ_dqdPE7 = dadqd_curr_vec_out_AZ_dqdPE7; dadqd_curr_vec_reg_LX_dqdPE7 = dadqd_curr_vec_out_LX_dqdPE7; dadqd_curr_vec_reg_LY_dqdPE7 = dadqd_curr_vec_out_LY_dqdPE7; dadqd_curr_vec_reg_LZ_dqdPE7 = dadqd_curr_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Link 7 Inputs
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 3'd7;
      sinq_val_in_rnea = 32'd49084; cosq_val_in_rnea = -32'd43424;
      qd_val_in_rnea = 32'd50674;
      qdd_val_in_rnea = 32'd3416239;
      v_prev_vec_in_AX_rnea = 32'd40787; v_prev_vec_in_AY_rnea = 32'd148430; v_prev_vec_in_AZ_rnea = -32'd19503; v_prev_vec_in_LX_rnea = 32'd26833; v_prev_vec_in_LY_rnea = -32'd8629; v_prev_vec_in_LZ_rnea = 32'd5595;
      a_prev_vec_in_AX_rnea = 32'd454103; a_prev_vec_in_AY_rnea = 32'd1626815; a_prev_vec_in_AZ_rnea = 32'd6726660; a_prev_vec_in_LX_rnea = 32'd60695; a_prev_vec_in_LY_rnea = -32'd31489; a_prev_vec_in_LZ_rnea = 32'd19432;
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 0;
      derv_in_dqPE1 = 3'd1;
      sinq_val_in_dqPE1 = 0; cosq_val_in_dqPE1 = 0;
      qd_val_in_dqPE1 = 0;
      v_curr_vec_in_AX_dqPE1 = 0; v_curr_vec_in_AY_dqPE1 = 0; v_curr_vec_in_AZ_dqPE1 = 0; v_curr_vec_in_LX_dqPE1 = 0; v_curr_vec_in_LY_dqPE1 = 0; v_curr_vec_in_LZ_dqPE1 = 0;
      a_curr_vec_in_AX_dqPE1 = 0; a_curr_vec_in_AY_dqPE1 = 0; a_curr_vec_in_AZ_dqPE1 = 0; a_curr_vec_in_LX_dqPE1 = 0; a_curr_vec_in_LY_dqPE1 = 0; a_curr_vec_in_LZ_dqPE1 = 0;
      v_prev_vec_in_AX_dqPE1 = 0; v_prev_vec_in_AY_dqPE1 = 0; v_prev_vec_in_AZ_dqPE1 = 0; v_prev_vec_in_LX_dqPE1 = 0; v_prev_vec_in_LY_dqPE1 = 0; v_prev_vec_in_LZ_dqPE1 = 0;
      a_prev_vec_in_AX_dqPE1 = 0; a_prev_vec_in_AY_dqPE1 = 0; a_prev_vec_in_AZ_dqPE1 = 0; a_prev_vec_in_LX_dqPE1 = 0; a_prev_vec_in_LY_dqPE1 = 0; a_prev_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      link_in_dqPE2 = 3'd6;
      derv_in_dqPE2 = 3'd2;
      sinq_val_in_dqPE2 = 32'd20062; cosq_val_in_dqPE2 = 32'd62390;
      qd_val_in_dqPE2 = 32'd27834;
      v_curr_vec_in_AX_dqPE2 = 32'd40787; v_curr_vec_in_AY_dqPE2 = 32'd148431; v_curr_vec_in_AZ_dqPE2 = -32'd19503; v_curr_vec_in_LX_dqPE2 = 32'd26833; v_curr_vec_in_LY_dqPE2 = -32'd8629; v_curr_vec_in_LZ_dqPE2 = 32'd5595;
      a_curr_vec_in_AX_dqPE2 = 32'd454102; a_curr_vec_in_AY_dqPE2 = 32'd1626813; a_curr_vec_in_AZ_dqPE2 = 32'd6726681; a_curr_vec_in_LX_dqPE2 = 32'd60695; a_curr_vec_in_LY_dqPE2 = -32'd31488; a_curr_vec_in_LZ_dqPE2 = 32'd19432;
      v_prev_vec_in_AX_dqPE2 = -32'd6608; v_prev_vec_in_AY_dqPE2 = 32'd47337; v_prev_vec_in_AZ_dqPE2 = 32'd153790; v_prev_vec_in_LX_dqPE2 = 32'd17985; v_prev_vec_in_LY_dqPE2 = -32'd7019; v_prev_vec_in_LZ_dqPE2 = -32'd1;
      a_prev_vec_in_AX_dqPE2 = -32'd131010; a_prev_vec_in_AY_dqPE2 = 32'd184057; a_prev_vec_in_AZ_dqPE2 = 32'd1684920; a_prev_vec_in_LX_dqPE2 = 32'd27757; a_prev_vec_in_LY_dqPE2 = -32'd47665; a_prev_vec_in_LZ_dqPE2 = 32'd574;
      // dqPE3
      link_in_dqPE3 = 3'd6;
      derv_in_dqPE3 = 3'd3;
      sinq_val_in_dqPE3 = 32'd20062; cosq_val_in_dqPE3 = 32'd62390;
      qd_val_in_dqPE3 = 32'd27834;
      v_curr_vec_in_AX_dqPE3 = 32'd40787; v_curr_vec_in_AY_dqPE3 = 32'd148431; v_curr_vec_in_AZ_dqPE3 = -32'd19503; v_curr_vec_in_LX_dqPE3 = 32'd26833; v_curr_vec_in_LY_dqPE3 = -32'd8629; v_curr_vec_in_LZ_dqPE3 = 32'd5595;
      a_curr_vec_in_AX_dqPE3 = 32'd454102; a_curr_vec_in_AY_dqPE3 = 32'd1626813; a_curr_vec_in_AZ_dqPE3 = 32'd6726681; a_curr_vec_in_LX_dqPE3 = 32'd60695; a_curr_vec_in_LY_dqPE3 = -32'd31488; a_curr_vec_in_LZ_dqPE3 = 32'd19432;
      v_prev_vec_in_AX_dqPE3 = -32'd6608; v_prev_vec_in_AY_dqPE3 = 32'd47337; v_prev_vec_in_AZ_dqPE3 = 32'd153790; v_prev_vec_in_LX_dqPE3 = 32'd17985; v_prev_vec_in_LY_dqPE3 = -32'd7019; v_prev_vec_in_LZ_dqPE3 = -32'd1;
      a_prev_vec_in_AX_dqPE3 = -32'd131010; a_prev_vec_in_AY_dqPE3 = 32'd184057; a_prev_vec_in_AZ_dqPE3 = 32'd1684920; a_prev_vec_in_LX_dqPE3 = 32'd27757; a_prev_vec_in_LY_dqPE3 = -32'd47665; a_prev_vec_in_LZ_dqPE3 = 32'd574;
      // dqPE4
      link_in_dqPE4 = 3'd6;
      derv_in_dqPE4 = 3'd4;
      sinq_val_in_dqPE4 = 32'd20062; cosq_val_in_dqPE4 = 32'd62390;
      qd_val_in_dqPE4 = 32'd27834;
      v_curr_vec_in_AX_dqPE4 = 32'd40787; v_curr_vec_in_AY_dqPE4 = 32'd148431; v_curr_vec_in_AZ_dqPE4 = -32'd19503; v_curr_vec_in_LX_dqPE4 = 32'd26833; v_curr_vec_in_LY_dqPE4 = -32'd8629; v_curr_vec_in_LZ_dqPE4 = 32'd5595;
      a_curr_vec_in_AX_dqPE4 = 32'd454102; a_curr_vec_in_AY_dqPE4 = 32'd1626813; a_curr_vec_in_AZ_dqPE4 = 32'd6726681; a_curr_vec_in_LX_dqPE4 = 32'd60695; a_curr_vec_in_LY_dqPE4 = -32'd31488; a_curr_vec_in_LZ_dqPE4 = 32'd19432;
      v_prev_vec_in_AX_dqPE4 = -32'd6608; v_prev_vec_in_AY_dqPE4 = 32'd47337; v_prev_vec_in_AZ_dqPE4 = 32'd153790; v_prev_vec_in_LX_dqPE4 = 32'd17985; v_prev_vec_in_LY_dqPE4 = -32'd7019; v_prev_vec_in_LZ_dqPE4 = -32'd1;
      a_prev_vec_in_AX_dqPE4 = -32'd131010; a_prev_vec_in_AY_dqPE4 = 32'd184057; a_prev_vec_in_AZ_dqPE4 = 32'd1684920; a_prev_vec_in_LX_dqPE4 = 32'd27757; a_prev_vec_in_LY_dqPE4 = -32'd47665; a_prev_vec_in_LZ_dqPE4 = 32'd574;
      // dqPE5
      link_in_dqPE5 = 3'd6;
      derv_in_dqPE5 = 3'd5;
      sinq_val_in_dqPE5 = 32'd20062; cosq_val_in_dqPE5 = 32'd62390;
      qd_val_in_dqPE5 = 32'd27834;
      v_curr_vec_in_AX_dqPE5 = 32'd40787; v_curr_vec_in_AY_dqPE5 = 32'd148431; v_curr_vec_in_AZ_dqPE5 = -32'd19503; v_curr_vec_in_LX_dqPE5 = 32'd26833; v_curr_vec_in_LY_dqPE5 = -32'd8629; v_curr_vec_in_LZ_dqPE5 = 32'd5595;
      a_curr_vec_in_AX_dqPE5 = 32'd454102; a_curr_vec_in_AY_dqPE5 = 32'd1626813; a_curr_vec_in_AZ_dqPE5 = 32'd6726681; a_curr_vec_in_LX_dqPE5 = 32'd60695; a_curr_vec_in_LY_dqPE5 = -32'd31488; a_curr_vec_in_LZ_dqPE5 = 32'd19432;
      v_prev_vec_in_AX_dqPE5 = -32'd6608; v_prev_vec_in_AY_dqPE5 = 32'd47337; v_prev_vec_in_AZ_dqPE5 = 32'd153790; v_prev_vec_in_LX_dqPE5 = 32'd17985; v_prev_vec_in_LY_dqPE5 = -32'd7019; v_prev_vec_in_LZ_dqPE5 = -32'd1;
      a_prev_vec_in_AX_dqPE5 = -32'd131010; a_prev_vec_in_AY_dqPE5 = 32'd184057; a_prev_vec_in_AZ_dqPE5 = 32'd1684920; a_prev_vec_in_LX_dqPE5 = 32'd27757; a_prev_vec_in_LY_dqPE5 = -32'd47665; a_prev_vec_in_LZ_dqPE5 = 32'd574;
      // dqPE6
      link_in_dqPE6 = 3'd6;
      derv_in_dqPE6 = 3'd6;
      sinq_val_in_dqPE6 = 32'd20062; cosq_val_in_dqPE6 = 32'd62390;
      qd_val_in_dqPE6 = 32'd27834;
      v_curr_vec_in_AX_dqPE6 = 32'd40787; v_curr_vec_in_AY_dqPE6 = 32'd148431; v_curr_vec_in_AZ_dqPE6 = -32'd19503; v_curr_vec_in_LX_dqPE6 = 32'd26833; v_curr_vec_in_LY_dqPE6 = -32'd8629; v_curr_vec_in_LZ_dqPE6 = 32'd5595;
      a_curr_vec_in_AX_dqPE6 = 32'd454102; a_curr_vec_in_AY_dqPE6 = 32'd1626813; a_curr_vec_in_AZ_dqPE6 = 32'd6726681; a_curr_vec_in_LX_dqPE6 = 32'd60695; a_curr_vec_in_LY_dqPE6 = -32'd31488; a_curr_vec_in_LZ_dqPE6 = 32'd19432;
      v_prev_vec_in_AX_dqPE6 = -32'd6608; v_prev_vec_in_AY_dqPE6 = 32'd47337; v_prev_vec_in_AZ_dqPE6 = 32'd153790; v_prev_vec_in_LX_dqPE6 = 32'd17985; v_prev_vec_in_LY_dqPE6 = -32'd7019; v_prev_vec_in_LZ_dqPE6 = -32'd1;
      a_prev_vec_in_AX_dqPE6 = -32'd131010; a_prev_vec_in_AY_dqPE6 = 32'd184057; a_prev_vec_in_AZ_dqPE6 = 32'd1684920; a_prev_vec_in_LX_dqPE6 = 32'd27757; a_prev_vec_in_LY_dqPE6 = -32'd47665; a_prev_vec_in_LZ_dqPE6 = 32'd574;
      // dqPE7
      link_in_dqPE7 = 3'd6;
      derv_in_dqPE7 = 3'd7;
      sinq_val_in_dqPE7 = 32'd20062; cosq_val_in_dqPE7 = 32'd62390;
      qd_val_in_dqPE7 = 32'd27834;
      v_curr_vec_in_AX_dqPE7 = 32'd40787; v_curr_vec_in_AY_dqPE7 = 32'd148431; v_curr_vec_in_AZ_dqPE7 = -32'd19503; v_curr_vec_in_LX_dqPE7 = 32'd26833; v_curr_vec_in_LY_dqPE7 = -32'd8629; v_curr_vec_in_LZ_dqPE7 = 32'd5595;
      a_curr_vec_in_AX_dqPE7 = 32'd454102; a_curr_vec_in_AY_dqPE7 = 32'd1626813; a_curr_vec_in_AZ_dqPE7 = 32'd6726681; a_curr_vec_in_LX_dqPE7 = 32'd60695; a_curr_vec_in_LY_dqPE7 = -32'd31488; a_curr_vec_in_LZ_dqPE7 = 32'd19432;
      v_prev_vec_in_AX_dqPE7 = -32'd6608; v_prev_vec_in_AY_dqPE7 = 32'd47337; v_prev_vec_in_AZ_dqPE7 = 32'd153790; v_prev_vec_in_LX_dqPE7 = 32'd17985; v_prev_vec_in_LY_dqPE7 = -32'd7019; v_prev_vec_in_LZ_dqPE7 = -32'd1;
      a_prev_vec_in_AX_dqPE7 = -32'd131010; a_prev_vec_in_AY_dqPE7 = 32'd184057; a_prev_vec_in_AZ_dqPE7 = 32'd1684920; a_prev_vec_in_LX_dqPE7 = 32'd27757; a_prev_vec_in_LY_dqPE7 = -32'd47665; a_prev_vec_in_LZ_dqPE7 = 32'd574;
      // External dv,da
      // dqPE1
      dvdq_prev_vec_in_AX_dqPE1 = dvdq_curr_vec_reg_AX_dqPE1; dvdq_prev_vec_in_AY_dqPE1 = dvdq_curr_vec_reg_AY_dqPE1; dvdq_prev_vec_in_AZ_dqPE1 = dvdq_curr_vec_reg_AZ_dqPE1; dvdq_prev_vec_in_LX_dqPE1 = dvdq_curr_vec_reg_LX_dqPE1; dvdq_prev_vec_in_LY_dqPE1 = dvdq_curr_vec_reg_LY_dqPE1; dvdq_prev_vec_in_LZ_dqPE1 = dvdq_curr_vec_reg_LZ_dqPE1; 
      dadq_prev_vec_in_AX_dqPE1 = dadq_curr_vec_reg_AX_dqPE1; dadq_prev_vec_in_AY_dqPE1 = dadq_curr_vec_reg_AY_dqPE1; dadq_prev_vec_in_AZ_dqPE1 = dadq_curr_vec_reg_AZ_dqPE1; dadq_prev_vec_in_LX_dqPE1 = dadq_curr_vec_reg_LX_dqPE1; dadq_prev_vec_in_LY_dqPE1 = dadq_curr_vec_reg_LY_dqPE1; dadq_prev_vec_in_LZ_dqPE1 = dadq_curr_vec_reg_LZ_dqPE1; 
      // dqPE2
      dvdq_prev_vec_in_AX_dqPE2 = dvdq_curr_vec_reg_AX_dqPE2; dvdq_prev_vec_in_AY_dqPE2 = dvdq_curr_vec_reg_AY_dqPE2; dvdq_prev_vec_in_AZ_dqPE2 = dvdq_curr_vec_reg_AZ_dqPE2; dvdq_prev_vec_in_LX_dqPE2 = dvdq_curr_vec_reg_LX_dqPE2; dvdq_prev_vec_in_LY_dqPE2 = dvdq_curr_vec_reg_LY_dqPE2; dvdq_prev_vec_in_LZ_dqPE2 = dvdq_curr_vec_reg_LZ_dqPE2; 
      dadq_prev_vec_in_AX_dqPE2 = dadq_curr_vec_reg_AX_dqPE2; dadq_prev_vec_in_AY_dqPE2 = dadq_curr_vec_reg_AY_dqPE2; dadq_prev_vec_in_AZ_dqPE2 = dadq_curr_vec_reg_AZ_dqPE2; dadq_prev_vec_in_LX_dqPE2 = dadq_curr_vec_reg_LX_dqPE2; dadq_prev_vec_in_LY_dqPE2 = dadq_curr_vec_reg_LY_dqPE2; dadq_prev_vec_in_LZ_dqPE2 = dadq_curr_vec_reg_LZ_dqPE2; 
      // dqPE3
      dvdq_prev_vec_in_AX_dqPE3 = dvdq_curr_vec_reg_AX_dqPE3; dvdq_prev_vec_in_AY_dqPE3 = dvdq_curr_vec_reg_AY_dqPE3; dvdq_prev_vec_in_AZ_dqPE3 = dvdq_curr_vec_reg_AZ_dqPE3; dvdq_prev_vec_in_LX_dqPE3 = dvdq_curr_vec_reg_LX_dqPE3; dvdq_prev_vec_in_LY_dqPE3 = dvdq_curr_vec_reg_LY_dqPE3; dvdq_prev_vec_in_LZ_dqPE3 = dvdq_curr_vec_reg_LZ_dqPE3; 
      dadq_prev_vec_in_AX_dqPE3 = dadq_curr_vec_reg_AX_dqPE3; dadq_prev_vec_in_AY_dqPE3 = dadq_curr_vec_reg_AY_dqPE3; dadq_prev_vec_in_AZ_dqPE3 = dadq_curr_vec_reg_AZ_dqPE3; dadq_prev_vec_in_LX_dqPE3 = dadq_curr_vec_reg_LX_dqPE3; dadq_prev_vec_in_LY_dqPE3 = dadq_curr_vec_reg_LY_dqPE3; dadq_prev_vec_in_LZ_dqPE3 = dadq_curr_vec_reg_LZ_dqPE3; 
      // dqPE4
      dvdq_prev_vec_in_AX_dqPE4 = dvdq_curr_vec_reg_AX_dqPE4; dvdq_prev_vec_in_AY_dqPE4 = dvdq_curr_vec_reg_AY_dqPE4; dvdq_prev_vec_in_AZ_dqPE4 = dvdq_curr_vec_reg_AZ_dqPE4; dvdq_prev_vec_in_LX_dqPE4 = dvdq_curr_vec_reg_LX_dqPE4; dvdq_prev_vec_in_LY_dqPE4 = dvdq_curr_vec_reg_LY_dqPE4; dvdq_prev_vec_in_LZ_dqPE4 = dvdq_curr_vec_reg_LZ_dqPE4; 
      dadq_prev_vec_in_AX_dqPE4 = dadq_curr_vec_reg_AX_dqPE4; dadq_prev_vec_in_AY_dqPE4 = dadq_curr_vec_reg_AY_dqPE4; dadq_prev_vec_in_AZ_dqPE4 = dadq_curr_vec_reg_AZ_dqPE4; dadq_prev_vec_in_LX_dqPE4 = dadq_curr_vec_reg_LX_dqPE4; dadq_prev_vec_in_LY_dqPE4 = dadq_curr_vec_reg_LY_dqPE4; dadq_prev_vec_in_LZ_dqPE4 = dadq_curr_vec_reg_LZ_dqPE4; 
      // dqPE5
      dvdq_prev_vec_in_AX_dqPE5 = dvdq_curr_vec_reg_AX_dqPE5; dvdq_prev_vec_in_AY_dqPE5 = dvdq_curr_vec_reg_AY_dqPE5; dvdq_prev_vec_in_AZ_dqPE5 = dvdq_curr_vec_reg_AZ_dqPE5; dvdq_prev_vec_in_LX_dqPE5 = dvdq_curr_vec_reg_LX_dqPE5; dvdq_prev_vec_in_LY_dqPE5 = dvdq_curr_vec_reg_LY_dqPE5; dvdq_prev_vec_in_LZ_dqPE5 = dvdq_curr_vec_reg_LZ_dqPE5; 
      dadq_prev_vec_in_AX_dqPE5 = dadq_curr_vec_reg_AX_dqPE5; dadq_prev_vec_in_AY_dqPE5 = dadq_curr_vec_reg_AY_dqPE5; dadq_prev_vec_in_AZ_dqPE5 = dadq_curr_vec_reg_AZ_dqPE5; dadq_prev_vec_in_LX_dqPE5 = dadq_curr_vec_reg_LX_dqPE5; dadq_prev_vec_in_LY_dqPE5 = dadq_curr_vec_reg_LY_dqPE5; dadq_prev_vec_in_LZ_dqPE5 = dadq_curr_vec_reg_LZ_dqPE5; 
      // dqPE6
      dvdq_prev_vec_in_AX_dqPE6 = dvdq_curr_vec_reg_AX_dqPE6; dvdq_prev_vec_in_AY_dqPE6 = dvdq_curr_vec_reg_AY_dqPE6; dvdq_prev_vec_in_AZ_dqPE6 = dvdq_curr_vec_reg_AZ_dqPE6; dvdq_prev_vec_in_LX_dqPE6 = dvdq_curr_vec_reg_LX_dqPE6; dvdq_prev_vec_in_LY_dqPE6 = dvdq_curr_vec_reg_LY_dqPE6; dvdq_prev_vec_in_LZ_dqPE6 = dvdq_curr_vec_reg_LZ_dqPE6; 
      dadq_prev_vec_in_AX_dqPE6 = dadq_curr_vec_reg_AX_dqPE6; dadq_prev_vec_in_AY_dqPE6 = dadq_curr_vec_reg_AY_dqPE6; dadq_prev_vec_in_AZ_dqPE6 = dadq_curr_vec_reg_AZ_dqPE6; dadq_prev_vec_in_LX_dqPE6 = dadq_curr_vec_reg_LX_dqPE6; dadq_prev_vec_in_LY_dqPE6 = dadq_curr_vec_reg_LY_dqPE6; dadq_prev_vec_in_LZ_dqPE6 = dadq_curr_vec_reg_LZ_dqPE6; 
      // dqPE7
      dvdq_prev_vec_in_AX_dqPE7 = dvdq_curr_vec_reg_AX_dqPE7; dvdq_prev_vec_in_AY_dqPE7 = dvdq_curr_vec_reg_AY_dqPE7; dvdq_prev_vec_in_AZ_dqPE7 = dvdq_curr_vec_reg_AZ_dqPE7; dvdq_prev_vec_in_LX_dqPE7 = dvdq_curr_vec_reg_LX_dqPE7; dvdq_prev_vec_in_LY_dqPE7 = dvdq_curr_vec_reg_LY_dqPE7; dvdq_prev_vec_in_LZ_dqPE7 = dvdq_curr_vec_reg_LZ_dqPE7; 
      dadq_prev_vec_in_AX_dqPE7 = dadq_curr_vec_reg_AX_dqPE7; dadq_prev_vec_in_AY_dqPE7 = dadq_curr_vec_reg_AY_dqPE7; dadq_prev_vec_in_AZ_dqPE7 = dadq_curr_vec_reg_AZ_dqPE7; dadq_prev_vec_in_LX_dqPE7 = dadq_curr_vec_reg_LX_dqPE7; dadq_prev_vec_in_LY_dqPE7 = dadq_curr_vec_reg_LY_dqPE7; dadq_prev_vec_in_LZ_dqPE7 = dadq_curr_vec_reg_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 3'd6;
      derv_in_dqdPE1 = 3'd1;
      sinq_val_in_dqdPE1 = 32'd20062; cosq_val_in_dqdPE1 = 32'd62390;
      qd_val_in_dqdPE1 = 32'd27834;
      v_curr_vec_in_AX_dqdPE1 = 32'd40787; v_curr_vec_in_AY_dqdPE1 = 32'd148431; v_curr_vec_in_AZ_dqdPE1 = -32'd19503; v_curr_vec_in_LX_dqdPE1 = 32'd26833; v_curr_vec_in_LY_dqdPE1 = -32'd8629; v_curr_vec_in_LZ_dqdPE1 = 32'd5595;
      a_curr_vec_in_AX_dqdPE1 = 32'd454102; a_curr_vec_in_AY_dqdPE1 = 32'd1626813; a_curr_vec_in_AZ_dqdPE1 = 32'd6726681; a_curr_vec_in_LX_dqdPE1 = 32'd60695; a_curr_vec_in_LY_dqdPE1 = -32'd31488; a_curr_vec_in_LZ_dqdPE1 = 32'd19432;
      // dqdPE2
      link_in_dqdPE2 = 3'd6;
      derv_in_dqdPE2 = 3'd2;
      sinq_val_in_dqdPE2 = 32'd20062; cosq_val_in_dqdPE2 = 32'd62390;
      qd_val_in_dqdPE2 = 32'd27834;
      v_curr_vec_in_AX_dqdPE2 = 32'd40787; v_curr_vec_in_AY_dqdPE2 = 32'd148431; v_curr_vec_in_AZ_dqdPE2 = -32'd19503; v_curr_vec_in_LX_dqdPE2 = 32'd26833; v_curr_vec_in_LY_dqdPE2 = -32'd8629; v_curr_vec_in_LZ_dqdPE2 = 32'd5595;
      a_curr_vec_in_AX_dqdPE2 = 32'd454102; a_curr_vec_in_AY_dqdPE2 = 32'd1626813; a_curr_vec_in_AZ_dqdPE2 = 32'd6726681; a_curr_vec_in_LX_dqdPE2 = 32'd60695; a_curr_vec_in_LY_dqdPE2 = -32'd31488; a_curr_vec_in_LZ_dqdPE2 = 32'd19432;
      // dqdPE3
      link_in_dqdPE3 = 3'd6;
      derv_in_dqdPE3 = 3'd3;
      sinq_val_in_dqdPE3 = 32'd20062; cosq_val_in_dqdPE3 = 32'd62390;
      qd_val_in_dqdPE3 = 32'd27834;
      v_curr_vec_in_AX_dqdPE3 = 32'd40787; v_curr_vec_in_AY_dqdPE3 = 32'd148431; v_curr_vec_in_AZ_dqdPE3 = -32'd19503; v_curr_vec_in_LX_dqdPE3 = 32'd26833; v_curr_vec_in_LY_dqdPE3 = -32'd8629; v_curr_vec_in_LZ_dqdPE3 = 32'd5595;
      a_curr_vec_in_AX_dqdPE3 = 32'd454102; a_curr_vec_in_AY_dqdPE3 = 32'd1626813; a_curr_vec_in_AZ_dqdPE3 = 32'd6726681; a_curr_vec_in_LX_dqdPE3 = 32'd60695; a_curr_vec_in_LY_dqdPE3 = -32'd31488; a_curr_vec_in_LZ_dqdPE3 = 32'd19432;
      // dqdPE4
      link_in_dqdPE4 = 3'd6;
      derv_in_dqdPE4 = 3'd4;
      sinq_val_in_dqdPE4 = 32'd20062; cosq_val_in_dqdPE4 = 32'd62390;
      qd_val_in_dqdPE4 = 32'd27834;
      v_curr_vec_in_AX_dqdPE4 = 32'd40787; v_curr_vec_in_AY_dqdPE4 = 32'd148431; v_curr_vec_in_AZ_dqdPE4 = -32'd19503; v_curr_vec_in_LX_dqdPE4 = 32'd26833; v_curr_vec_in_LY_dqdPE4 = -32'd8629; v_curr_vec_in_LZ_dqdPE4 = 32'd5595;
      a_curr_vec_in_AX_dqdPE4 = 32'd454102; a_curr_vec_in_AY_dqdPE4 = 32'd1626813; a_curr_vec_in_AZ_dqdPE4 = 32'd6726681; a_curr_vec_in_LX_dqdPE4 = 32'd60695; a_curr_vec_in_LY_dqdPE4 = -32'd31488; a_curr_vec_in_LZ_dqdPE4 = 32'd19432;
      // dqdPE5
      link_in_dqdPE5 = 3'd6;
      derv_in_dqdPE5 = 3'd5;
      sinq_val_in_dqdPE5 = 32'd20062; cosq_val_in_dqdPE5 = 32'd62390;
      qd_val_in_dqdPE5 = 32'd27834;
      v_curr_vec_in_AX_dqdPE5 = 32'd40787; v_curr_vec_in_AY_dqdPE5 = 32'd148431; v_curr_vec_in_AZ_dqdPE5 = -32'd19503; v_curr_vec_in_LX_dqdPE5 = 32'd26833; v_curr_vec_in_LY_dqdPE5 = -32'd8629; v_curr_vec_in_LZ_dqdPE5 = 32'd5595;
      a_curr_vec_in_AX_dqdPE5 = 32'd454102; a_curr_vec_in_AY_dqdPE5 = 32'd1626813; a_curr_vec_in_AZ_dqdPE5 = 32'd6726681; a_curr_vec_in_LX_dqdPE5 = 32'd60695; a_curr_vec_in_LY_dqdPE5 = -32'd31488; a_curr_vec_in_LZ_dqdPE5 = 32'd19432;
      // dqdPE6
      link_in_dqdPE6 = 3'd6;
      derv_in_dqdPE6 = 3'd6;
      sinq_val_in_dqdPE6 = 32'd20062; cosq_val_in_dqdPE6 = 32'd62390;
      qd_val_in_dqdPE6 = 32'd27834;
      v_curr_vec_in_AX_dqdPE6 = 32'd40787; v_curr_vec_in_AY_dqdPE6 = 32'd148431; v_curr_vec_in_AZ_dqdPE6 = -32'd19503; v_curr_vec_in_LX_dqdPE6 = 32'd26833; v_curr_vec_in_LY_dqdPE6 = -32'd8629; v_curr_vec_in_LZ_dqdPE6 = 32'd5595;
      a_curr_vec_in_AX_dqdPE6 = 32'd454102; a_curr_vec_in_AY_dqdPE6 = 32'd1626813; a_curr_vec_in_AZ_dqdPE6 = 32'd6726681; a_curr_vec_in_LX_dqdPE6 = 32'd60695; a_curr_vec_in_LY_dqdPE6 = -32'd31488; a_curr_vec_in_LZ_dqdPE6 = 32'd19432;
      // dqdPE7
      link_in_dqdPE7 = 3'd6;
      derv_in_dqdPE7 = 3'd7;
      sinq_val_in_dqdPE7 = 32'd20062; cosq_val_in_dqdPE7 = 32'd62390;
      qd_val_in_dqdPE7 = 32'd27834;
      v_curr_vec_in_AX_dqdPE7 = 32'd40787; v_curr_vec_in_AY_dqdPE7 = 32'd148431; v_curr_vec_in_AZ_dqdPE7 = -32'd19503; v_curr_vec_in_LX_dqdPE7 = 32'd26833; v_curr_vec_in_LY_dqdPE7 = -32'd8629; v_curr_vec_in_LZ_dqdPE7 = 32'd5595;
      a_curr_vec_in_AX_dqdPE7 = 32'd454102; a_curr_vec_in_AY_dqdPE7 = 32'd1626813; a_curr_vec_in_AZ_dqdPE7 = 32'd6726681; a_curr_vec_in_LX_dqdPE7 = 32'd60695; a_curr_vec_in_LY_dqdPE7 = -32'd31488; a_curr_vec_in_LZ_dqdPE7 = 32'd19432;
      // External dv,da
      // dqdPE1
      dvdqd_prev_vec_in_AX_dqdPE1 = dvdqd_curr_vec_reg_AX_dqdPE1; dvdqd_prev_vec_in_AY_dqdPE1 = dvdqd_curr_vec_reg_AY_dqdPE1; dvdqd_prev_vec_in_AZ_dqdPE1 = dvdqd_curr_vec_reg_AZ_dqdPE1; dvdqd_prev_vec_in_LX_dqdPE1 = dvdqd_curr_vec_reg_LX_dqdPE1; dvdqd_prev_vec_in_LY_dqdPE1 = dvdqd_curr_vec_reg_LY_dqdPE1; dvdqd_prev_vec_in_LZ_dqdPE1 = dvdqd_curr_vec_reg_LZ_dqdPE1; 
      dadqd_prev_vec_in_AX_dqdPE1 = dadqd_curr_vec_reg_AX_dqdPE1; dadqd_prev_vec_in_AY_dqdPE1 = dadqd_curr_vec_reg_AY_dqdPE1; dadqd_prev_vec_in_AZ_dqdPE1 = dadqd_curr_vec_reg_AZ_dqdPE1; dadqd_prev_vec_in_LX_dqdPE1 = dadqd_curr_vec_reg_LX_dqdPE1; dadqd_prev_vec_in_LY_dqdPE1 = dadqd_curr_vec_reg_LY_dqdPE1; dadqd_prev_vec_in_LZ_dqdPE1 = dadqd_curr_vec_reg_LZ_dqdPE1; 
      // dqdPE2
      dvdqd_prev_vec_in_AX_dqdPE2 = dvdqd_curr_vec_reg_AX_dqdPE2; dvdqd_prev_vec_in_AY_dqdPE2 = dvdqd_curr_vec_reg_AY_dqdPE2; dvdqd_prev_vec_in_AZ_dqdPE2 = dvdqd_curr_vec_reg_AZ_dqdPE2; dvdqd_prev_vec_in_LX_dqdPE2 = dvdqd_curr_vec_reg_LX_dqdPE2; dvdqd_prev_vec_in_LY_dqdPE2 = dvdqd_curr_vec_reg_LY_dqdPE2; dvdqd_prev_vec_in_LZ_dqdPE2 = dvdqd_curr_vec_reg_LZ_dqdPE2; 
      dadqd_prev_vec_in_AX_dqdPE2 = dadqd_curr_vec_reg_AX_dqdPE2; dadqd_prev_vec_in_AY_dqdPE2 = dadqd_curr_vec_reg_AY_dqdPE2; dadqd_prev_vec_in_AZ_dqdPE2 = dadqd_curr_vec_reg_AZ_dqdPE2; dadqd_prev_vec_in_LX_dqdPE2 = dadqd_curr_vec_reg_LX_dqdPE2; dadqd_prev_vec_in_LY_dqdPE2 = dadqd_curr_vec_reg_LY_dqdPE2; dadqd_prev_vec_in_LZ_dqdPE2 = dadqd_curr_vec_reg_LZ_dqdPE2; 
      // dqdPE3
      dvdqd_prev_vec_in_AX_dqdPE3 = dvdqd_curr_vec_reg_AX_dqdPE3; dvdqd_prev_vec_in_AY_dqdPE3 = dvdqd_curr_vec_reg_AY_dqdPE3; dvdqd_prev_vec_in_AZ_dqdPE3 = dvdqd_curr_vec_reg_AZ_dqdPE3; dvdqd_prev_vec_in_LX_dqdPE3 = dvdqd_curr_vec_reg_LX_dqdPE3; dvdqd_prev_vec_in_LY_dqdPE3 = dvdqd_curr_vec_reg_LY_dqdPE3; dvdqd_prev_vec_in_LZ_dqdPE3 = dvdqd_curr_vec_reg_LZ_dqdPE3; 
      dadqd_prev_vec_in_AX_dqdPE3 = dadqd_curr_vec_reg_AX_dqdPE3; dadqd_prev_vec_in_AY_dqdPE3 = dadqd_curr_vec_reg_AY_dqdPE3; dadqd_prev_vec_in_AZ_dqdPE3 = dadqd_curr_vec_reg_AZ_dqdPE3; dadqd_prev_vec_in_LX_dqdPE3 = dadqd_curr_vec_reg_LX_dqdPE3; dadqd_prev_vec_in_LY_dqdPE3 = dadqd_curr_vec_reg_LY_dqdPE3; dadqd_prev_vec_in_LZ_dqdPE3 = dadqd_curr_vec_reg_LZ_dqdPE3; 
      // dqdPE4
      dvdqd_prev_vec_in_AX_dqdPE4 = dvdqd_curr_vec_reg_AX_dqdPE4; dvdqd_prev_vec_in_AY_dqdPE4 = dvdqd_curr_vec_reg_AY_dqdPE4; dvdqd_prev_vec_in_AZ_dqdPE4 = dvdqd_curr_vec_reg_AZ_dqdPE4; dvdqd_prev_vec_in_LX_dqdPE4 = dvdqd_curr_vec_reg_LX_dqdPE4; dvdqd_prev_vec_in_LY_dqdPE4 = dvdqd_curr_vec_reg_LY_dqdPE4; dvdqd_prev_vec_in_LZ_dqdPE4 = dvdqd_curr_vec_reg_LZ_dqdPE4; 
      dadqd_prev_vec_in_AX_dqdPE4 = dadqd_curr_vec_reg_AX_dqdPE4; dadqd_prev_vec_in_AY_dqdPE4 = dadqd_curr_vec_reg_AY_dqdPE4; dadqd_prev_vec_in_AZ_dqdPE4 = dadqd_curr_vec_reg_AZ_dqdPE4; dadqd_prev_vec_in_LX_dqdPE4 = dadqd_curr_vec_reg_LX_dqdPE4; dadqd_prev_vec_in_LY_dqdPE4 = dadqd_curr_vec_reg_LY_dqdPE4; dadqd_prev_vec_in_LZ_dqdPE4 = dadqd_curr_vec_reg_LZ_dqdPE4; 
      // dqdPE5
      dvdqd_prev_vec_in_AX_dqdPE5 = dvdqd_curr_vec_reg_AX_dqdPE5; dvdqd_prev_vec_in_AY_dqdPE5 = dvdqd_curr_vec_reg_AY_dqdPE5; dvdqd_prev_vec_in_AZ_dqdPE5 = dvdqd_curr_vec_reg_AZ_dqdPE5; dvdqd_prev_vec_in_LX_dqdPE5 = dvdqd_curr_vec_reg_LX_dqdPE5; dvdqd_prev_vec_in_LY_dqdPE5 = dvdqd_curr_vec_reg_LY_dqdPE5; dvdqd_prev_vec_in_LZ_dqdPE5 = dvdqd_curr_vec_reg_LZ_dqdPE5; 
      dadqd_prev_vec_in_AX_dqdPE5 = dadqd_curr_vec_reg_AX_dqdPE5; dadqd_prev_vec_in_AY_dqdPE5 = dadqd_curr_vec_reg_AY_dqdPE5; dadqd_prev_vec_in_AZ_dqdPE5 = dadqd_curr_vec_reg_AZ_dqdPE5; dadqd_prev_vec_in_LX_dqdPE5 = dadqd_curr_vec_reg_LX_dqdPE5; dadqd_prev_vec_in_LY_dqdPE5 = dadqd_curr_vec_reg_LY_dqdPE5; dadqd_prev_vec_in_LZ_dqdPE5 = dadqd_curr_vec_reg_LZ_dqdPE5; 
      // dqdPE6
      dvdqd_prev_vec_in_AX_dqdPE6 = dvdqd_curr_vec_reg_AX_dqdPE6; dvdqd_prev_vec_in_AY_dqdPE6 = dvdqd_curr_vec_reg_AY_dqdPE6; dvdqd_prev_vec_in_AZ_dqdPE6 = dvdqd_curr_vec_reg_AZ_dqdPE6; dvdqd_prev_vec_in_LX_dqdPE6 = dvdqd_curr_vec_reg_LX_dqdPE6; dvdqd_prev_vec_in_LY_dqdPE6 = dvdqd_curr_vec_reg_LY_dqdPE6; dvdqd_prev_vec_in_LZ_dqdPE6 = dvdqd_curr_vec_reg_LZ_dqdPE6; 
      dadqd_prev_vec_in_AX_dqdPE6 = dadqd_curr_vec_reg_AX_dqdPE6; dadqd_prev_vec_in_AY_dqdPE6 = dadqd_curr_vec_reg_AY_dqdPE6; dadqd_prev_vec_in_AZ_dqdPE6 = dadqd_curr_vec_reg_AZ_dqdPE6; dadqd_prev_vec_in_LX_dqdPE6 = dadqd_curr_vec_reg_LX_dqdPE6; dadqd_prev_vec_in_LY_dqdPE6 = dadqd_curr_vec_reg_LY_dqdPE6; dadqd_prev_vec_in_LZ_dqdPE6 = dadqd_curr_vec_reg_LZ_dqdPE6; 
      // dqdPE7
      dvdqd_prev_vec_in_AX_dqdPE7 = dvdqd_curr_vec_reg_AX_dqdPE7; dvdqd_prev_vec_in_AY_dqdPE7 = dvdqd_curr_vec_reg_AY_dqdPE7; dvdqd_prev_vec_in_AZ_dqdPE7 = dvdqd_curr_vec_reg_AZ_dqdPE7; dvdqd_prev_vec_in_LX_dqdPE7 = dvdqd_curr_vec_reg_LX_dqdPE7; dvdqd_prev_vec_in_LY_dqdPE7 = dvdqd_curr_vec_reg_LY_dqdPE7; dvdqd_prev_vec_in_LZ_dqdPE7 = dvdqd_curr_vec_reg_LZ_dqdPE7; 
      dadqd_prev_vec_in_AX_dqdPE7 = dadqd_curr_vec_reg_AX_dqdPE7; dadqd_prev_vec_in_AY_dqdPE7 = dadqd_curr_vec_reg_AY_dqdPE7; dadqd_prev_vec_in_AZ_dqdPE7 = dadqd_curr_vec_reg_AZ_dqdPE7; dadqd_prev_vec_in_LX_dqdPE7 = dadqd_curr_vec_reg_LX_dqdPE7; dadqd_prev_vec_in_LY_dqdPE7 = dadqd_curr_vec_reg_LY_dqdPE7; dadqd_prev_vec_in_LZ_dqdPE7 = dadqd_curr_vec_reg_LZ_dqdPE7; 
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
      $display ("// Link 7 RNEA");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // f
      $display ("f_prev_ref = %d,%d,%d,%d,%d,%d",8044, -6533, 5043, -120315, -133594, -13832);
      $display ("f_prev_out = %d,%d,%d,%d,%d,%d", f_curr_vec_out_AX_rnea,f_curr_vec_out_AY_rnea,f_curr_vec_out_AZ_rnea,f_curr_vec_out_LX_rnea,f_curr_vec_out_LY_rnea,f_curr_vec_out_LZ_rnea);
      $display ("//-------------------------------------------------------------------------------------------------------");
      $display ("// Link 6 Derivatives");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, 284, -35, 259, 931, 8200, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -123, -73, 247, -245, -1679, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -151, 839, 24, -794, -389, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 32323, -160291, -90398, 80218, -77343, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -111482, 77173, 64413, -25932, -128801, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -49161, 46245, 109642, 145168, 1770, 0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AX_dqPE1,dfdq_curr_vec_out_AX_dqPE2,dfdq_curr_vec_out_AX_dqPE3,dfdq_curr_vec_out_AX_dqPE4,dfdq_curr_vec_out_AX_dqPE5,dfdq_curr_vec_out_AX_dqPE6,dfdq_curr_vec_out_AX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AY_dqPE1,dfdq_curr_vec_out_AY_dqPE2,dfdq_curr_vec_out_AY_dqPE3,dfdq_curr_vec_out_AY_dqPE4,dfdq_curr_vec_out_AY_dqPE5,dfdq_curr_vec_out_AY_dqPE6,dfdq_curr_vec_out_AY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AZ_dqPE1,dfdq_curr_vec_out_AZ_dqPE2,dfdq_curr_vec_out_AZ_dqPE3,dfdq_curr_vec_out_AZ_dqPE4,dfdq_curr_vec_out_AZ_dqPE5,dfdq_curr_vec_out_AZ_dqPE6,dfdq_curr_vec_out_AZ_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LX_dqPE1,dfdq_curr_vec_out_LX_dqPE2,dfdq_curr_vec_out_LX_dqPE3,dfdq_curr_vec_out_LX_dqPE4,dfdq_curr_vec_out_LX_dqPE5,dfdq_curr_vec_out_LX_dqPE6,dfdq_curr_vec_out_LX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LY_dqPE1,dfdq_curr_vec_out_LY_dqPE2,dfdq_curr_vec_out_LY_dqPE3,dfdq_curr_vec_out_LY_dqPE4,dfdq_curr_vec_out_LY_dqPE5,dfdq_curr_vec_out_LY_dqPE6,dfdq_curr_vec_out_LY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LZ_dqPE1,dfdq_curr_vec_out_LZ_dqPE2,dfdq_curr_vec_out_LZ_dqPE3,dfdq_curr_vec_out_LZ_dqPE4,dfdq_curr_vec_out_LZ_dqPE5,dfdq_curr_vec_out_LZ_dqPE6,dfdq_curr_vec_out_LZ_dqPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 76, -2, 75, -411, 337, 906, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -36, -40, -44, 186, -85, -135, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -53, -127, 123, 558, -149, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 5723, 166896, -36059, -143888, 77, 0, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -43324, -60969, 11058, -9066, -92, 42, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -94050, 24373, -36659, -120581, -164, 321, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AX_dqdPE1,dfdqd_curr_vec_out_AX_dqdPE2,dfdqd_curr_vec_out_AX_dqdPE3,dfdqd_curr_vec_out_AX_dqdPE4,dfdqd_curr_vec_out_AX_dqdPE5,dfdqd_curr_vec_out_AX_dqdPE6,dfdqd_curr_vec_out_AX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AY_dqdPE1,dfdqd_curr_vec_out_AY_dqdPE2,dfdqd_curr_vec_out_AY_dqdPE3,dfdqd_curr_vec_out_AY_dqdPE4,dfdqd_curr_vec_out_AY_dqdPE5,dfdqd_curr_vec_out_AY_dqdPE6,dfdqd_curr_vec_out_AY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AZ_dqdPE1,dfdqd_curr_vec_out_AZ_dqdPE2,dfdqd_curr_vec_out_AZ_dqdPE3,dfdqd_curr_vec_out_AZ_dqdPE4,dfdqd_curr_vec_out_AZ_dqdPE5,dfdqd_curr_vec_out_AZ_dqdPE6,dfdqd_curr_vec_out_AZ_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LX_dqdPE1,dfdqd_curr_vec_out_LX_dqdPE2,dfdqd_curr_vec_out_LX_dqdPE3,dfdqd_curr_vec_out_LX_dqdPE4,dfdqd_curr_vec_out_LX_dqdPE5,dfdqd_curr_vec_out_LX_dqdPE6,dfdqd_curr_vec_out_LX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LY_dqdPE1,dfdqd_curr_vec_out_LY_dqdPE2,dfdqd_curr_vec_out_LY_dqdPE3,dfdqd_curr_vec_out_LY_dqdPE4,dfdqd_curr_vec_out_LY_dqdPE5,dfdqd_curr_vec_out_LY_dqdPE6,dfdqd_curr_vec_out_LY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LZ_dqdPE1,dfdqd_curr_vec_out_LZ_dqdPE2,dfdqd_curr_vec_out_LZ_dqdPE3,dfdqd_curr_vec_out_LZ_dqdPE4,dfdqd_curr_vec_out_LZ_dqdPE5,dfdqd_curr_vec_out_LZ_dqdPE6,dfdqd_curr_vec_out_LZ_dqdPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External dv,da
      //------------------------------------------------------------------------
      // dqPE1
      dvdq_curr_vec_reg_AX_dqPE1 = dvdq_curr_vec_out_AX_dqPE1; dvdq_curr_vec_reg_AY_dqPE1 = dvdq_curr_vec_out_AY_dqPE1; dvdq_curr_vec_reg_AZ_dqPE1 = dvdq_curr_vec_out_AZ_dqPE1; dvdq_curr_vec_reg_LX_dqPE1 = dvdq_curr_vec_out_LX_dqPE1; dvdq_curr_vec_reg_LY_dqPE1 = dvdq_curr_vec_out_LY_dqPE1; dvdq_curr_vec_reg_LZ_dqPE1 = dvdq_curr_vec_out_LZ_dqPE1; 
      dadq_curr_vec_reg_AX_dqPE1 = dadq_curr_vec_out_AX_dqPE1; dadq_curr_vec_reg_AY_dqPE1 = dadq_curr_vec_out_AY_dqPE1; dadq_curr_vec_reg_AZ_dqPE1 = dadq_curr_vec_out_AZ_dqPE1; dadq_curr_vec_reg_LX_dqPE1 = dadq_curr_vec_out_LX_dqPE1; dadq_curr_vec_reg_LY_dqPE1 = dadq_curr_vec_out_LY_dqPE1; dadq_curr_vec_reg_LZ_dqPE1 = dadq_curr_vec_out_LZ_dqPE1; 
      // dqPE2
      dvdq_curr_vec_reg_AX_dqPE2 = dvdq_curr_vec_out_AX_dqPE2; dvdq_curr_vec_reg_AY_dqPE2 = dvdq_curr_vec_out_AY_dqPE2; dvdq_curr_vec_reg_AZ_dqPE2 = dvdq_curr_vec_out_AZ_dqPE2; dvdq_curr_vec_reg_LX_dqPE2 = dvdq_curr_vec_out_LX_dqPE2; dvdq_curr_vec_reg_LY_dqPE2 = dvdq_curr_vec_out_LY_dqPE2; dvdq_curr_vec_reg_LZ_dqPE2 = dvdq_curr_vec_out_LZ_dqPE2; 
      dadq_curr_vec_reg_AX_dqPE2 = dadq_curr_vec_out_AX_dqPE2; dadq_curr_vec_reg_AY_dqPE2 = dadq_curr_vec_out_AY_dqPE2; dadq_curr_vec_reg_AZ_dqPE2 = dadq_curr_vec_out_AZ_dqPE2; dadq_curr_vec_reg_LX_dqPE2 = dadq_curr_vec_out_LX_dqPE2; dadq_curr_vec_reg_LY_dqPE2 = dadq_curr_vec_out_LY_dqPE2; dadq_curr_vec_reg_LZ_dqPE2 = dadq_curr_vec_out_LZ_dqPE2; 
      // dqPE3
      dvdq_curr_vec_reg_AX_dqPE3 = dvdq_curr_vec_out_AX_dqPE3; dvdq_curr_vec_reg_AY_dqPE3 = dvdq_curr_vec_out_AY_dqPE3; dvdq_curr_vec_reg_AZ_dqPE3 = dvdq_curr_vec_out_AZ_dqPE3; dvdq_curr_vec_reg_LX_dqPE3 = dvdq_curr_vec_out_LX_dqPE3; dvdq_curr_vec_reg_LY_dqPE3 = dvdq_curr_vec_out_LY_dqPE3; dvdq_curr_vec_reg_LZ_dqPE3 = dvdq_curr_vec_out_LZ_dqPE3; 
      dadq_curr_vec_reg_AX_dqPE3 = dadq_curr_vec_out_AX_dqPE3; dadq_curr_vec_reg_AY_dqPE3 = dadq_curr_vec_out_AY_dqPE3; dadq_curr_vec_reg_AZ_dqPE3 = dadq_curr_vec_out_AZ_dqPE3; dadq_curr_vec_reg_LX_dqPE3 = dadq_curr_vec_out_LX_dqPE3; dadq_curr_vec_reg_LY_dqPE3 = dadq_curr_vec_out_LY_dqPE3; dadq_curr_vec_reg_LZ_dqPE3 = dadq_curr_vec_out_LZ_dqPE3; 
      // dqPE4
      dvdq_curr_vec_reg_AX_dqPE4 = dvdq_curr_vec_out_AX_dqPE4; dvdq_curr_vec_reg_AY_dqPE4 = dvdq_curr_vec_out_AY_dqPE4; dvdq_curr_vec_reg_AZ_dqPE4 = dvdq_curr_vec_out_AZ_dqPE4; dvdq_curr_vec_reg_LX_dqPE4 = dvdq_curr_vec_out_LX_dqPE4; dvdq_curr_vec_reg_LY_dqPE4 = dvdq_curr_vec_out_LY_dqPE4; dvdq_curr_vec_reg_LZ_dqPE4 = dvdq_curr_vec_out_LZ_dqPE4; 
      dadq_curr_vec_reg_AX_dqPE4 = dadq_curr_vec_out_AX_dqPE4; dadq_curr_vec_reg_AY_dqPE4 = dadq_curr_vec_out_AY_dqPE4; dadq_curr_vec_reg_AZ_dqPE4 = dadq_curr_vec_out_AZ_dqPE4; dadq_curr_vec_reg_LX_dqPE4 = dadq_curr_vec_out_LX_dqPE4; dadq_curr_vec_reg_LY_dqPE4 = dadq_curr_vec_out_LY_dqPE4; dadq_curr_vec_reg_LZ_dqPE4 = dadq_curr_vec_out_LZ_dqPE4; 
      // dqPE5
      dvdq_curr_vec_reg_AX_dqPE5 = dvdq_curr_vec_out_AX_dqPE5; dvdq_curr_vec_reg_AY_dqPE5 = dvdq_curr_vec_out_AY_dqPE5; dvdq_curr_vec_reg_AZ_dqPE5 = dvdq_curr_vec_out_AZ_dqPE5; dvdq_curr_vec_reg_LX_dqPE5 = dvdq_curr_vec_out_LX_dqPE5; dvdq_curr_vec_reg_LY_dqPE5 = dvdq_curr_vec_out_LY_dqPE5; dvdq_curr_vec_reg_LZ_dqPE5 = dvdq_curr_vec_out_LZ_dqPE5; 
      dadq_curr_vec_reg_AX_dqPE5 = dadq_curr_vec_out_AX_dqPE5; dadq_curr_vec_reg_AY_dqPE5 = dadq_curr_vec_out_AY_dqPE5; dadq_curr_vec_reg_AZ_dqPE5 = dadq_curr_vec_out_AZ_dqPE5; dadq_curr_vec_reg_LX_dqPE5 = dadq_curr_vec_out_LX_dqPE5; dadq_curr_vec_reg_LY_dqPE5 = dadq_curr_vec_out_LY_dqPE5; dadq_curr_vec_reg_LZ_dqPE5 = dadq_curr_vec_out_LZ_dqPE5; 
      // dqPE6
      dvdq_curr_vec_reg_AX_dqPE6 = dvdq_curr_vec_out_AX_dqPE6; dvdq_curr_vec_reg_AY_dqPE6 = dvdq_curr_vec_out_AY_dqPE6; dvdq_curr_vec_reg_AZ_dqPE6 = dvdq_curr_vec_out_AZ_dqPE6; dvdq_curr_vec_reg_LX_dqPE6 = dvdq_curr_vec_out_LX_dqPE6; dvdq_curr_vec_reg_LY_dqPE6 = dvdq_curr_vec_out_LY_dqPE6; dvdq_curr_vec_reg_LZ_dqPE6 = dvdq_curr_vec_out_LZ_dqPE6; 
      dadq_curr_vec_reg_AX_dqPE6 = dadq_curr_vec_out_AX_dqPE6; dadq_curr_vec_reg_AY_dqPE6 = dadq_curr_vec_out_AY_dqPE6; dadq_curr_vec_reg_AZ_dqPE6 = dadq_curr_vec_out_AZ_dqPE6; dadq_curr_vec_reg_LX_dqPE6 = dadq_curr_vec_out_LX_dqPE6; dadq_curr_vec_reg_LY_dqPE6 = dadq_curr_vec_out_LY_dqPE6; dadq_curr_vec_reg_LZ_dqPE6 = dadq_curr_vec_out_LZ_dqPE6; 
      // dqPE7
      dvdq_curr_vec_reg_AX_dqPE7 = dvdq_curr_vec_out_AX_dqPE7; dvdq_curr_vec_reg_AY_dqPE7 = dvdq_curr_vec_out_AY_dqPE7; dvdq_curr_vec_reg_AZ_dqPE7 = dvdq_curr_vec_out_AZ_dqPE7; dvdq_curr_vec_reg_LX_dqPE7 = dvdq_curr_vec_out_LX_dqPE7; dvdq_curr_vec_reg_LY_dqPE7 = dvdq_curr_vec_out_LY_dqPE7; dvdq_curr_vec_reg_LZ_dqPE7 = dvdq_curr_vec_out_LZ_dqPE7; 
      dadq_curr_vec_reg_AX_dqPE7 = dadq_curr_vec_out_AX_dqPE7; dadq_curr_vec_reg_AY_dqPE7 = dadq_curr_vec_out_AY_dqPE7; dadq_curr_vec_reg_AZ_dqPE7 = dadq_curr_vec_out_AZ_dqPE7; dadq_curr_vec_reg_LX_dqPE7 = dadq_curr_vec_out_LX_dqPE7; dadq_curr_vec_reg_LY_dqPE7 = dadq_curr_vec_out_LY_dqPE7; dadq_curr_vec_reg_LZ_dqPE7 = dadq_curr_vec_out_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqdPE1
      dvdqd_curr_vec_reg_AX_dqdPE1 = dvdqd_curr_vec_out_AX_dqdPE1; dvdqd_curr_vec_reg_AY_dqdPE1 = dvdqd_curr_vec_out_AY_dqdPE1; dvdqd_curr_vec_reg_AZ_dqdPE1 = dvdqd_curr_vec_out_AZ_dqdPE1; dvdqd_curr_vec_reg_LX_dqdPE1 = dvdqd_curr_vec_out_LX_dqdPE1; dvdqd_curr_vec_reg_LY_dqdPE1 = dvdqd_curr_vec_out_LY_dqdPE1; dvdqd_curr_vec_reg_LZ_dqdPE1 = dvdqd_curr_vec_out_LZ_dqdPE1; 
      dadqd_curr_vec_reg_AX_dqdPE1 = dadqd_curr_vec_out_AX_dqdPE1; dadqd_curr_vec_reg_AY_dqdPE1 = dadqd_curr_vec_out_AY_dqdPE1; dadqd_curr_vec_reg_AZ_dqdPE1 = dadqd_curr_vec_out_AZ_dqdPE1; dadqd_curr_vec_reg_LX_dqdPE1 = dadqd_curr_vec_out_LX_dqdPE1; dadqd_curr_vec_reg_LY_dqdPE1 = dadqd_curr_vec_out_LY_dqdPE1; dadqd_curr_vec_reg_LZ_dqdPE1 = dadqd_curr_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dvdqd_curr_vec_reg_AX_dqdPE2 = dvdqd_curr_vec_out_AX_dqdPE2; dvdqd_curr_vec_reg_AY_dqdPE2 = dvdqd_curr_vec_out_AY_dqdPE2; dvdqd_curr_vec_reg_AZ_dqdPE2 = dvdqd_curr_vec_out_AZ_dqdPE2; dvdqd_curr_vec_reg_LX_dqdPE2 = dvdqd_curr_vec_out_LX_dqdPE2; dvdqd_curr_vec_reg_LY_dqdPE2 = dvdqd_curr_vec_out_LY_dqdPE2; dvdqd_curr_vec_reg_LZ_dqdPE2 = dvdqd_curr_vec_out_LZ_dqdPE2; 
      dadqd_curr_vec_reg_AX_dqdPE2 = dadqd_curr_vec_out_AX_dqdPE2; dadqd_curr_vec_reg_AY_dqdPE2 = dadqd_curr_vec_out_AY_dqdPE2; dadqd_curr_vec_reg_AZ_dqdPE2 = dadqd_curr_vec_out_AZ_dqdPE2; dadqd_curr_vec_reg_LX_dqdPE2 = dadqd_curr_vec_out_LX_dqdPE2; dadqd_curr_vec_reg_LY_dqdPE2 = dadqd_curr_vec_out_LY_dqdPE2; dadqd_curr_vec_reg_LZ_dqdPE2 = dadqd_curr_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dvdqd_curr_vec_reg_AX_dqdPE3 = dvdqd_curr_vec_out_AX_dqdPE3; dvdqd_curr_vec_reg_AY_dqdPE3 = dvdqd_curr_vec_out_AY_dqdPE3; dvdqd_curr_vec_reg_AZ_dqdPE3 = dvdqd_curr_vec_out_AZ_dqdPE3; dvdqd_curr_vec_reg_LX_dqdPE3 = dvdqd_curr_vec_out_LX_dqdPE3; dvdqd_curr_vec_reg_LY_dqdPE3 = dvdqd_curr_vec_out_LY_dqdPE3; dvdqd_curr_vec_reg_LZ_dqdPE3 = dvdqd_curr_vec_out_LZ_dqdPE3; 
      dadqd_curr_vec_reg_AX_dqdPE3 = dadqd_curr_vec_out_AX_dqdPE3; dadqd_curr_vec_reg_AY_dqdPE3 = dadqd_curr_vec_out_AY_dqdPE3; dadqd_curr_vec_reg_AZ_dqdPE3 = dadqd_curr_vec_out_AZ_dqdPE3; dadqd_curr_vec_reg_LX_dqdPE3 = dadqd_curr_vec_out_LX_dqdPE3; dadqd_curr_vec_reg_LY_dqdPE3 = dadqd_curr_vec_out_LY_dqdPE3; dadqd_curr_vec_reg_LZ_dqdPE3 = dadqd_curr_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dvdqd_curr_vec_reg_AX_dqdPE4 = dvdqd_curr_vec_out_AX_dqdPE4; dvdqd_curr_vec_reg_AY_dqdPE4 = dvdqd_curr_vec_out_AY_dqdPE4; dvdqd_curr_vec_reg_AZ_dqdPE4 = dvdqd_curr_vec_out_AZ_dqdPE4; dvdqd_curr_vec_reg_LX_dqdPE4 = dvdqd_curr_vec_out_LX_dqdPE4; dvdqd_curr_vec_reg_LY_dqdPE4 = dvdqd_curr_vec_out_LY_dqdPE4; dvdqd_curr_vec_reg_LZ_dqdPE4 = dvdqd_curr_vec_out_LZ_dqdPE4; 
      dadqd_curr_vec_reg_AX_dqdPE4 = dadqd_curr_vec_out_AX_dqdPE4; dadqd_curr_vec_reg_AY_dqdPE4 = dadqd_curr_vec_out_AY_dqdPE4; dadqd_curr_vec_reg_AZ_dqdPE4 = dadqd_curr_vec_out_AZ_dqdPE4; dadqd_curr_vec_reg_LX_dqdPE4 = dadqd_curr_vec_out_LX_dqdPE4; dadqd_curr_vec_reg_LY_dqdPE4 = dadqd_curr_vec_out_LY_dqdPE4; dadqd_curr_vec_reg_LZ_dqdPE4 = dadqd_curr_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dvdqd_curr_vec_reg_AX_dqdPE5 = dvdqd_curr_vec_out_AX_dqdPE5; dvdqd_curr_vec_reg_AY_dqdPE5 = dvdqd_curr_vec_out_AY_dqdPE5; dvdqd_curr_vec_reg_AZ_dqdPE5 = dvdqd_curr_vec_out_AZ_dqdPE5; dvdqd_curr_vec_reg_LX_dqdPE5 = dvdqd_curr_vec_out_LX_dqdPE5; dvdqd_curr_vec_reg_LY_dqdPE5 = dvdqd_curr_vec_out_LY_dqdPE5; dvdqd_curr_vec_reg_LZ_dqdPE5 = dvdqd_curr_vec_out_LZ_dqdPE5; 
      dadqd_curr_vec_reg_AX_dqdPE5 = dadqd_curr_vec_out_AX_dqdPE5; dadqd_curr_vec_reg_AY_dqdPE5 = dadqd_curr_vec_out_AY_dqdPE5; dadqd_curr_vec_reg_AZ_dqdPE5 = dadqd_curr_vec_out_AZ_dqdPE5; dadqd_curr_vec_reg_LX_dqdPE5 = dadqd_curr_vec_out_LX_dqdPE5; dadqd_curr_vec_reg_LY_dqdPE5 = dadqd_curr_vec_out_LY_dqdPE5; dadqd_curr_vec_reg_LZ_dqdPE5 = dadqd_curr_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dvdqd_curr_vec_reg_AX_dqdPE6 = dvdqd_curr_vec_out_AX_dqdPE6; dvdqd_curr_vec_reg_AY_dqdPE6 = dvdqd_curr_vec_out_AY_dqdPE6; dvdqd_curr_vec_reg_AZ_dqdPE6 = dvdqd_curr_vec_out_AZ_dqdPE6; dvdqd_curr_vec_reg_LX_dqdPE6 = dvdqd_curr_vec_out_LX_dqdPE6; dvdqd_curr_vec_reg_LY_dqdPE6 = dvdqd_curr_vec_out_LY_dqdPE6; dvdqd_curr_vec_reg_LZ_dqdPE6 = dvdqd_curr_vec_out_LZ_dqdPE6; 
      dadqd_curr_vec_reg_AX_dqdPE6 = dadqd_curr_vec_out_AX_dqdPE6; dadqd_curr_vec_reg_AY_dqdPE6 = dadqd_curr_vec_out_AY_dqdPE6; dadqd_curr_vec_reg_AZ_dqdPE6 = dadqd_curr_vec_out_AZ_dqdPE6; dadqd_curr_vec_reg_LX_dqdPE6 = dadqd_curr_vec_out_LX_dqdPE6; dadqd_curr_vec_reg_LY_dqdPE6 = dadqd_curr_vec_out_LY_dqdPE6; dadqd_curr_vec_reg_LZ_dqdPE6 = dadqd_curr_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dvdqd_curr_vec_reg_AX_dqdPE7 = dvdqd_curr_vec_out_AX_dqdPE7; dvdqd_curr_vec_reg_AY_dqdPE7 = dvdqd_curr_vec_out_AY_dqdPE7; dvdqd_curr_vec_reg_AZ_dqdPE7 = dvdqd_curr_vec_out_AZ_dqdPE7; dvdqd_curr_vec_reg_LX_dqdPE7 = dvdqd_curr_vec_out_LX_dqdPE7; dvdqd_curr_vec_reg_LY_dqdPE7 = dvdqd_curr_vec_out_LY_dqdPE7; dvdqd_curr_vec_reg_LZ_dqdPE7 = dvdqd_curr_vec_out_LZ_dqdPE7; 
      dadqd_curr_vec_reg_AX_dqdPE7 = dadqd_curr_vec_out_AX_dqdPE7; dadqd_curr_vec_reg_AY_dqdPE7 = dadqd_curr_vec_out_AY_dqdPE7; dadqd_curr_vec_reg_AZ_dqdPE7 = dadqd_curr_vec_out_AZ_dqdPE7; dadqd_curr_vec_reg_LX_dqdPE7 = dadqd_curr_vec_out_LX_dqdPE7; dadqd_curr_vec_reg_LY_dqdPE7 = dadqd_curr_vec_out_LY_dqdPE7; dadqd_curr_vec_reg_LZ_dqdPE7 = dadqd_curr_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Dummy Inputs
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 0;
      sinq_val_in_rnea = 0; cosq_val_in_rnea = 0;
      qd_val_in_rnea = 0;
      qdd_val_in_rnea = 0;
      v_prev_vec_in_AX_rnea = 0; v_prev_vec_in_AY_rnea = 0; v_prev_vec_in_AZ_rnea = 0; v_prev_vec_in_LX_rnea = 0; v_prev_vec_in_LY_rnea = 0; v_prev_vec_in_LZ_rnea = 0;
      a_prev_vec_in_AX_rnea = 0; a_prev_vec_in_AY_rnea = 0; a_prev_vec_in_AZ_rnea = 0; a_prev_vec_in_LX_rnea = 0; a_prev_vec_in_LY_rnea = 0; a_prev_vec_in_LZ_rnea = 0;
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 0;
      derv_in_dqPE1 = 3'd1;
      sinq_val_in_dqPE1 = 0; cosq_val_in_dqPE1 = 0;
      qd_val_in_dqPE1 = 0;
      v_curr_vec_in_AX_dqPE1 = 0; v_curr_vec_in_AY_dqPE1 = 0; v_curr_vec_in_AZ_dqPE1 = 0; v_curr_vec_in_LX_dqPE1 = 0; v_curr_vec_in_LY_dqPE1 = 0; v_curr_vec_in_LZ_dqPE1 = 0;
      a_curr_vec_in_AX_dqPE1 = 0; a_curr_vec_in_AY_dqPE1 = 0; a_curr_vec_in_AZ_dqPE1 = 0; a_curr_vec_in_LX_dqPE1 = 0; a_curr_vec_in_LY_dqPE1 = 0; a_curr_vec_in_LZ_dqPE1 = 0;
      v_prev_vec_in_AX_dqPE1 = 0; v_prev_vec_in_AY_dqPE1 = 0; v_prev_vec_in_AZ_dqPE1 = 0; v_prev_vec_in_LX_dqPE1 = 0; v_prev_vec_in_LY_dqPE1 = 0; v_prev_vec_in_LZ_dqPE1 = 0;
      a_prev_vec_in_AX_dqPE1 = 0; a_prev_vec_in_AY_dqPE1 = 0; a_prev_vec_in_AZ_dqPE1 = 0; a_prev_vec_in_LX_dqPE1 = 0; a_prev_vec_in_LY_dqPE1 = 0; a_prev_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      link_in_dqPE2 = 3'd7;
      derv_in_dqPE2 = 3'd2;
      sinq_val_in_dqPE2 = 32'd49084; cosq_val_in_dqPE2 = -32'd43424;
      qd_val_in_dqPE2 = 32'd50674;
      v_curr_vec_in_AX_dqPE2 = 32'd12419; v_curr_vec_in_AY_dqPE2 = 32'd43471; v_curr_vec_in_AZ_dqPE2 = 32'd199104; v_curr_vec_in_LX_dqPE2 = 32'd25491; v_curr_vec_in_LY_dqPE2 = 32'd15384; v_curr_vec_in_LZ_dqPE2 = -32'd8629;
      a_curr_vec_in_AX_dqPE2 = 32'd5372563; a_curr_vec_in_AY_dqPE2 = -32'd4126612; a_curr_vec_in_AZ_dqPE2 = 32'd5043054; a_curr_vec_in_LX_dqPE2 = -32'd266811; a_curr_vec_in_LY_dqPE2 = -32'd419582; a_curr_vec_in_LZ_dqPE2 = -32'd31488;
      v_prev_vec_in_AX_dqPE2 = 32'd40787; v_prev_vec_in_AY_dqPE2 = 32'd148430; v_prev_vec_in_AZ_dqPE2 = -32'd19503; v_prev_vec_in_LX_dqPE2 = 32'd26833; v_prev_vec_in_LY_dqPE2 = -32'd8629; v_prev_vec_in_LZ_dqPE2 = 32'd5595;
      a_prev_vec_in_AX_dqPE2 = 32'd454103; a_prev_vec_in_AY_dqPE2 = 32'd1626815; a_prev_vec_in_AZ_dqPE2 = 32'd6726660; a_prev_vec_in_LX_dqPE2 = 32'd60695; a_prev_vec_in_LY_dqPE2 = -32'd31489; a_prev_vec_in_LZ_dqPE2 = 32'd19432;
      // dqPE3
      link_in_dqPE3 = 3'd7;
      derv_in_dqPE3 = 3'd3;
      sinq_val_in_dqPE3 = 32'd49084; cosq_val_in_dqPE3 = -32'd43424;
      qd_val_in_dqPE3 = 32'd50674;
      v_curr_vec_in_AX_dqPE3 = 32'd12419; v_curr_vec_in_AY_dqPE3 = 32'd43471; v_curr_vec_in_AZ_dqPE3 = 32'd199104; v_curr_vec_in_LX_dqPE3 = 32'd25491; v_curr_vec_in_LY_dqPE3 = 32'd15384; v_curr_vec_in_LZ_dqPE3 = -32'd8629;
      a_curr_vec_in_AX_dqPE3 = 32'd5372563; a_curr_vec_in_AY_dqPE3 = -32'd4126612; a_curr_vec_in_AZ_dqPE3 = 32'd5043054; a_curr_vec_in_LX_dqPE3 = -32'd266811; a_curr_vec_in_LY_dqPE3 = -32'd419582; a_curr_vec_in_LZ_dqPE3 = -32'd31488;
      v_prev_vec_in_AX_dqPE3 = 32'd40787; v_prev_vec_in_AY_dqPE3 = 32'd148430; v_prev_vec_in_AZ_dqPE3 = -32'd19503; v_prev_vec_in_LX_dqPE3 = 32'd26833; v_prev_vec_in_LY_dqPE3 = -32'd8629; v_prev_vec_in_LZ_dqPE3 = 32'd5595;
      a_prev_vec_in_AX_dqPE3 = 32'd454103; a_prev_vec_in_AY_dqPE3 = 32'd1626815; a_prev_vec_in_AZ_dqPE3 = 32'd6726660; a_prev_vec_in_LX_dqPE3 = 32'd60695; a_prev_vec_in_LY_dqPE3 = -32'd31489; a_prev_vec_in_LZ_dqPE3 = 32'd19432;
      // dqPE4
      link_in_dqPE4 = 3'd7;
      derv_in_dqPE4 = 3'd4;
      sinq_val_in_dqPE4 = 32'd49084; cosq_val_in_dqPE4 = -32'd43424;
      qd_val_in_dqPE4 = 32'd50674;
      v_curr_vec_in_AX_dqPE4 = 32'd12419; v_curr_vec_in_AY_dqPE4 = 32'd43471; v_curr_vec_in_AZ_dqPE4 = 32'd199104; v_curr_vec_in_LX_dqPE4 = 32'd25491; v_curr_vec_in_LY_dqPE4 = 32'd15384; v_curr_vec_in_LZ_dqPE4 = -32'd8629;
      a_curr_vec_in_AX_dqPE4 = 32'd5372563; a_curr_vec_in_AY_dqPE4 = -32'd4126612; a_curr_vec_in_AZ_dqPE4 = 32'd5043054; a_curr_vec_in_LX_dqPE4 = -32'd266811; a_curr_vec_in_LY_dqPE4 = -32'd419582; a_curr_vec_in_LZ_dqPE4 = -32'd31488;
      v_prev_vec_in_AX_dqPE4 = 32'd40787; v_prev_vec_in_AY_dqPE4 = 32'd148430; v_prev_vec_in_AZ_dqPE4 = -32'd19503; v_prev_vec_in_LX_dqPE4 = 32'd26833; v_prev_vec_in_LY_dqPE4 = -32'd8629; v_prev_vec_in_LZ_dqPE4 = 32'd5595;
      a_prev_vec_in_AX_dqPE4 = 32'd454103; a_prev_vec_in_AY_dqPE4 = 32'd1626815; a_prev_vec_in_AZ_dqPE4 = 32'd6726660; a_prev_vec_in_LX_dqPE4 = 32'd60695; a_prev_vec_in_LY_dqPE4 = -32'd31489; a_prev_vec_in_LZ_dqPE4 = 32'd19432;
      // dqPE5
      link_in_dqPE5 = 3'd7;
      derv_in_dqPE5 = 3'd5;
      sinq_val_in_dqPE5 = 32'd49084; cosq_val_in_dqPE5 = -32'd43424;
      qd_val_in_dqPE5 = 32'd50674;
      v_curr_vec_in_AX_dqPE5 = 32'd12419; v_curr_vec_in_AY_dqPE5 = 32'd43471; v_curr_vec_in_AZ_dqPE5 = 32'd199104; v_curr_vec_in_LX_dqPE5 = 32'd25491; v_curr_vec_in_LY_dqPE5 = 32'd15384; v_curr_vec_in_LZ_dqPE5 = -32'd8629;
      a_curr_vec_in_AX_dqPE5 = 32'd5372563; a_curr_vec_in_AY_dqPE5 = -32'd4126612; a_curr_vec_in_AZ_dqPE5 = 32'd5043054; a_curr_vec_in_LX_dqPE5 = -32'd266811; a_curr_vec_in_LY_dqPE5 = -32'd419582; a_curr_vec_in_LZ_dqPE5 = -32'd31488;
      v_prev_vec_in_AX_dqPE5 = 32'd40787; v_prev_vec_in_AY_dqPE5 = 32'd148430; v_prev_vec_in_AZ_dqPE5 = -32'd19503; v_prev_vec_in_LX_dqPE5 = 32'd26833; v_prev_vec_in_LY_dqPE5 = -32'd8629; v_prev_vec_in_LZ_dqPE5 = 32'd5595;
      a_prev_vec_in_AX_dqPE5 = 32'd454103; a_prev_vec_in_AY_dqPE5 = 32'd1626815; a_prev_vec_in_AZ_dqPE5 = 32'd6726660; a_prev_vec_in_LX_dqPE5 = 32'd60695; a_prev_vec_in_LY_dqPE5 = -32'd31489; a_prev_vec_in_LZ_dqPE5 = 32'd19432;
      // dqPE6
      link_in_dqPE6 = 3'd7;
      derv_in_dqPE6 = 3'd6;
      sinq_val_in_dqPE6 = 32'd49084; cosq_val_in_dqPE6 = -32'd43424;
      qd_val_in_dqPE6 = 32'd50674;
      v_curr_vec_in_AX_dqPE6 = 32'd12419; v_curr_vec_in_AY_dqPE6 = 32'd43471; v_curr_vec_in_AZ_dqPE6 = 32'd199104; v_curr_vec_in_LX_dqPE6 = 32'd25491; v_curr_vec_in_LY_dqPE6 = 32'd15384; v_curr_vec_in_LZ_dqPE6 = -32'd8629;
      a_curr_vec_in_AX_dqPE6 = 32'd5372563; a_curr_vec_in_AY_dqPE6 = -32'd4126612; a_curr_vec_in_AZ_dqPE6 = 32'd5043054; a_curr_vec_in_LX_dqPE6 = -32'd266811; a_curr_vec_in_LY_dqPE6 = -32'd419582; a_curr_vec_in_LZ_dqPE6 = -32'd31488;
      v_prev_vec_in_AX_dqPE6 = 32'd40787; v_prev_vec_in_AY_dqPE6 = 32'd148430; v_prev_vec_in_AZ_dqPE6 = -32'd19503; v_prev_vec_in_LX_dqPE6 = 32'd26833; v_prev_vec_in_LY_dqPE6 = -32'd8629; v_prev_vec_in_LZ_dqPE6 = 32'd5595;
      a_prev_vec_in_AX_dqPE6 = 32'd454103; a_prev_vec_in_AY_dqPE6 = 32'd1626815; a_prev_vec_in_AZ_dqPE6 = 32'd6726660; a_prev_vec_in_LX_dqPE6 = 32'd60695; a_prev_vec_in_LY_dqPE6 = -32'd31489; a_prev_vec_in_LZ_dqPE6 = 32'd19432;
      // dqPE7
      link_in_dqPE7 = 3'd7;
      derv_in_dqPE7 = 3'd7;
      sinq_val_in_dqPE7 = 32'd49084; cosq_val_in_dqPE7 = -32'd43424;
      qd_val_in_dqPE7 = 32'd50674;
      v_curr_vec_in_AX_dqPE7 = 32'd12419; v_curr_vec_in_AY_dqPE7 = 32'd43471; v_curr_vec_in_AZ_dqPE7 = 32'd199104; v_curr_vec_in_LX_dqPE7 = 32'd25491; v_curr_vec_in_LY_dqPE7 = 32'd15384; v_curr_vec_in_LZ_dqPE7 = -32'd8629;
      a_curr_vec_in_AX_dqPE7 = 32'd5372563; a_curr_vec_in_AY_dqPE7 = -32'd4126612; a_curr_vec_in_AZ_dqPE7 = 32'd5043054; a_curr_vec_in_LX_dqPE7 = -32'd266811; a_curr_vec_in_LY_dqPE7 = -32'd419582; a_curr_vec_in_LZ_dqPE7 = -32'd31488;
      v_prev_vec_in_AX_dqPE7 = 32'd40787; v_prev_vec_in_AY_dqPE7 = 32'd148430; v_prev_vec_in_AZ_dqPE7 = -32'd19503; v_prev_vec_in_LX_dqPE7 = 32'd26833; v_prev_vec_in_LY_dqPE7 = -32'd8629; v_prev_vec_in_LZ_dqPE7 = 32'd5595;
      a_prev_vec_in_AX_dqPE7 = 32'd454103; a_prev_vec_in_AY_dqPE7 = 32'd1626815; a_prev_vec_in_AZ_dqPE7 = 32'd6726660; a_prev_vec_in_LX_dqPE7 = 32'd60695; a_prev_vec_in_LY_dqPE7 = -32'd31489; a_prev_vec_in_LZ_dqPE7 = 32'd19432;
      // External dv,da
      // dqPE1
      dvdq_prev_vec_in_AX_dqPE1 = dvdq_curr_vec_reg_AX_dqPE1; dvdq_prev_vec_in_AY_dqPE1 = dvdq_curr_vec_reg_AY_dqPE1; dvdq_prev_vec_in_AZ_dqPE1 = dvdq_curr_vec_reg_AZ_dqPE1; dvdq_prev_vec_in_LX_dqPE1 = dvdq_curr_vec_reg_LX_dqPE1; dvdq_prev_vec_in_LY_dqPE1 = dvdq_curr_vec_reg_LY_dqPE1; dvdq_prev_vec_in_LZ_dqPE1 = dvdq_curr_vec_reg_LZ_dqPE1; 
      dadq_prev_vec_in_AX_dqPE1 = dadq_curr_vec_reg_AX_dqPE1; dadq_prev_vec_in_AY_dqPE1 = dadq_curr_vec_reg_AY_dqPE1; dadq_prev_vec_in_AZ_dqPE1 = dadq_curr_vec_reg_AZ_dqPE1; dadq_prev_vec_in_LX_dqPE1 = dadq_curr_vec_reg_LX_dqPE1; dadq_prev_vec_in_LY_dqPE1 = dadq_curr_vec_reg_LY_dqPE1; dadq_prev_vec_in_LZ_dqPE1 = dadq_curr_vec_reg_LZ_dqPE1; 
      // dqPE2
      dvdq_prev_vec_in_AX_dqPE2 = dvdq_curr_vec_reg_AX_dqPE2; dvdq_prev_vec_in_AY_dqPE2 = dvdq_curr_vec_reg_AY_dqPE2; dvdq_prev_vec_in_AZ_dqPE2 = dvdq_curr_vec_reg_AZ_dqPE2; dvdq_prev_vec_in_LX_dqPE2 = dvdq_curr_vec_reg_LX_dqPE2; dvdq_prev_vec_in_LY_dqPE2 = dvdq_curr_vec_reg_LY_dqPE2; dvdq_prev_vec_in_LZ_dqPE2 = dvdq_curr_vec_reg_LZ_dqPE2; 
      dadq_prev_vec_in_AX_dqPE2 = dadq_curr_vec_reg_AX_dqPE2; dadq_prev_vec_in_AY_dqPE2 = dadq_curr_vec_reg_AY_dqPE2; dadq_prev_vec_in_AZ_dqPE2 = dadq_curr_vec_reg_AZ_dqPE2; dadq_prev_vec_in_LX_dqPE2 = dadq_curr_vec_reg_LX_dqPE2; dadq_prev_vec_in_LY_dqPE2 = dadq_curr_vec_reg_LY_dqPE2; dadq_prev_vec_in_LZ_dqPE2 = dadq_curr_vec_reg_LZ_dqPE2; 
      // dqPE3
      dvdq_prev_vec_in_AX_dqPE3 = dvdq_curr_vec_reg_AX_dqPE3; dvdq_prev_vec_in_AY_dqPE3 = dvdq_curr_vec_reg_AY_dqPE3; dvdq_prev_vec_in_AZ_dqPE3 = dvdq_curr_vec_reg_AZ_dqPE3; dvdq_prev_vec_in_LX_dqPE3 = dvdq_curr_vec_reg_LX_dqPE3; dvdq_prev_vec_in_LY_dqPE3 = dvdq_curr_vec_reg_LY_dqPE3; dvdq_prev_vec_in_LZ_dqPE3 = dvdq_curr_vec_reg_LZ_dqPE3; 
      dadq_prev_vec_in_AX_dqPE3 = dadq_curr_vec_reg_AX_dqPE3; dadq_prev_vec_in_AY_dqPE3 = dadq_curr_vec_reg_AY_dqPE3; dadq_prev_vec_in_AZ_dqPE3 = dadq_curr_vec_reg_AZ_dqPE3; dadq_prev_vec_in_LX_dqPE3 = dadq_curr_vec_reg_LX_dqPE3; dadq_prev_vec_in_LY_dqPE3 = dadq_curr_vec_reg_LY_dqPE3; dadq_prev_vec_in_LZ_dqPE3 = dadq_curr_vec_reg_LZ_dqPE3; 
      // dqPE4
      dvdq_prev_vec_in_AX_dqPE4 = dvdq_curr_vec_reg_AX_dqPE4; dvdq_prev_vec_in_AY_dqPE4 = dvdq_curr_vec_reg_AY_dqPE4; dvdq_prev_vec_in_AZ_dqPE4 = dvdq_curr_vec_reg_AZ_dqPE4; dvdq_prev_vec_in_LX_dqPE4 = dvdq_curr_vec_reg_LX_dqPE4; dvdq_prev_vec_in_LY_dqPE4 = dvdq_curr_vec_reg_LY_dqPE4; dvdq_prev_vec_in_LZ_dqPE4 = dvdq_curr_vec_reg_LZ_dqPE4; 
      dadq_prev_vec_in_AX_dqPE4 = dadq_curr_vec_reg_AX_dqPE4; dadq_prev_vec_in_AY_dqPE4 = dadq_curr_vec_reg_AY_dqPE4; dadq_prev_vec_in_AZ_dqPE4 = dadq_curr_vec_reg_AZ_dqPE4; dadq_prev_vec_in_LX_dqPE4 = dadq_curr_vec_reg_LX_dqPE4; dadq_prev_vec_in_LY_dqPE4 = dadq_curr_vec_reg_LY_dqPE4; dadq_prev_vec_in_LZ_dqPE4 = dadq_curr_vec_reg_LZ_dqPE4; 
      // dqPE5
      dvdq_prev_vec_in_AX_dqPE5 = dvdq_curr_vec_reg_AX_dqPE5; dvdq_prev_vec_in_AY_dqPE5 = dvdq_curr_vec_reg_AY_dqPE5; dvdq_prev_vec_in_AZ_dqPE5 = dvdq_curr_vec_reg_AZ_dqPE5; dvdq_prev_vec_in_LX_dqPE5 = dvdq_curr_vec_reg_LX_dqPE5; dvdq_prev_vec_in_LY_dqPE5 = dvdq_curr_vec_reg_LY_dqPE5; dvdq_prev_vec_in_LZ_dqPE5 = dvdq_curr_vec_reg_LZ_dqPE5; 
      dadq_prev_vec_in_AX_dqPE5 = dadq_curr_vec_reg_AX_dqPE5; dadq_prev_vec_in_AY_dqPE5 = dadq_curr_vec_reg_AY_dqPE5; dadq_prev_vec_in_AZ_dqPE5 = dadq_curr_vec_reg_AZ_dqPE5; dadq_prev_vec_in_LX_dqPE5 = dadq_curr_vec_reg_LX_dqPE5; dadq_prev_vec_in_LY_dqPE5 = dadq_curr_vec_reg_LY_dqPE5; dadq_prev_vec_in_LZ_dqPE5 = dadq_curr_vec_reg_LZ_dqPE5; 
      // dqPE6
      dvdq_prev_vec_in_AX_dqPE6 = dvdq_curr_vec_reg_AX_dqPE6; dvdq_prev_vec_in_AY_dqPE6 = dvdq_curr_vec_reg_AY_dqPE6; dvdq_prev_vec_in_AZ_dqPE6 = dvdq_curr_vec_reg_AZ_dqPE6; dvdq_prev_vec_in_LX_dqPE6 = dvdq_curr_vec_reg_LX_dqPE6; dvdq_prev_vec_in_LY_dqPE6 = dvdq_curr_vec_reg_LY_dqPE6; dvdq_prev_vec_in_LZ_dqPE6 = dvdq_curr_vec_reg_LZ_dqPE6; 
      dadq_prev_vec_in_AX_dqPE6 = dadq_curr_vec_reg_AX_dqPE6; dadq_prev_vec_in_AY_dqPE6 = dadq_curr_vec_reg_AY_dqPE6; dadq_prev_vec_in_AZ_dqPE6 = dadq_curr_vec_reg_AZ_dqPE6; dadq_prev_vec_in_LX_dqPE6 = dadq_curr_vec_reg_LX_dqPE6; dadq_prev_vec_in_LY_dqPE6 = dadq_curr_vec_reg_LY_dqPE6; dadq_prev_vec_in_LZ_dqPE6 = dadq_curr_vec_reg_LZ_dqPE6; 
      // dqPE7
      dvdq_prev_vec_in_AX_dqPE7 = dvdq_curr_vec_reg_AX_dqPE7; dvdq_prev_vec_in_AY_dqPE7 = dvdq_curr_vec_reg_AY_dqPE7; dvdq_prev_vec_in_AZ_dqPE7 = dvdq_curr_vec_reg_AZ_dqPE7; dvdq_prev_vec_in_LX_dqPE7 = dvdq_curr_vec_reg_LX_dqPE7; dvdq_prev_vec_in_LY_dqPE7 = dvdq_curr_vec_reg_LY_dqPE7; dvdq_prev_vec_in_LZ_dqPE7 = dvdq_curr_vec_reg_LZ_dqPE7; 
      dadq_prev_vec_in_AX_dqPE7 = dadq_curr_vec_reg_AX_dqPE7; dadq_prev_vec_in_AY_dqPE7 = dadq_curr_vec_reg_AY_dqPE7; dadq_prev_vec_in_AZ_dqPE7 = dadq_curr_vec_reg_AZ_dqPE7; dadq_prev_vec_in_LX_dqPE7 = dadq_curr_vec_reg_LX_dqPE7; dadq_prev_vec_in_LY_dqPE7 = dadq_curr_vec_reg_LY_dqPE7; dadq_prev_vec_in_LZ_dqPE7 = dadq_curr_vec_reg_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 3'd7;
      derv_in_dqdPE1 = 3'd1;
      sinq_val_in_dqdPE1 = 32'd49084; cosq_val_in_dqdPE1 = -32'd43424;
      qd_val_in_dqdPE1 = 32'd50674;
      v_curr_vec_in_AX_dqdPE1 = 32'd12419; v_curr_vec_in_AY_dqdPE1 = 32'd43471; v_curr_vec_in_AZ_dqdPE1 = 32'd199104; v_curr_vec_in_LX_dqdPE1 = 32'd25491; v_curr_vec_in_LY_dqdPE1 = 32'd15384; v_curr_vec_in_LZ_dqdPE1 = -32'd8629;
      a_curr_vec_in_AX_dqdPE1 = 32'd5372563; a_curr_vec_in_AY_dqdPE1 = -32'd4126612; a_curr_vec_in_AZ_dqdPE1 = 32'd5043054; a_curr_vec_in_LX_dqdPE1 = -32'd266811; a_curr_vec_in_LY_dqdPE1 = -32'd419582; a_curr_vec_in_LZ_dqdPE1 = -32'd31488;
      // dqdPE2
      link_in_dqdPE2 = 3'd7;
      derv_in_dqdPE2 = 3'd2;
      sinq_val_in_dqdPE2 = 32'd49084; cosq_val_in_dqdPE2 = -32'd43424;
      qd_val_in_dqdPE2 = 32'd50674;
      v_curr_vec_in_AX_dqdPE2 = 32'd12419; v_curr_vec_in_AY_dqdPE2 = 32'd43471; v_curr_vec_in_AZ_dqdPE2 = 32'd199104; v_curr_vec_in_LX_dqdPE2 = 32'd25491; v_curr_vec_in_LY_dqdPE2 = 32'd15384; v_curr_vec_in_LZ_dqdPE2 = -32'd8629;
      a_curr_vec_in_AX_dqdPE2 = 32'd5372563; a_curr_vec_in_AY_dqdPE2 = -32'd4126612; a_curr_vec_in_AZ_dqdPE2 = 32'd5043054; a_curr_vec_in_LX_dqdPE2 = -32'd266811; a_curr_vec_in_LY_dqdPE2 = -32'd419582; a_curr_vec_in_LZ_dqdPE2 = -32'd31488;
      // dqdPE3
      link_in_dqdPE3 = 3'd7;
      derv_in_dqdPE3 = 3'd3;
      sinq_val_in_dqdPE3 = 32'd49084; cosq_val_in_dqdPE3 = -32'd43424;
      qd_val_in_dqdPE3 = 32'd50674;
      v_curr_vec_in_AX_dqdPE3 = 32'd12419; v_curr_vec_in_AY_dqdPE3 = 32'd43471; v_curr_vec_in_AZ_dqdPE3 = 32'd199104; v_curr_vec_in_LX_dqdPE3 = 32'd25491; v_curr_vec_in_LY_dqdPE3 = 32'd15384; v_curr_vec_in_LZ_dqdPE3 = -32'd8629;
      a_curr_vec_in_AX_dqdPE3 = 32'd5372563; a_curr_vec_in_AY_dqdPE3 = -32'd4126612; a_curr_vec_in_AZ_dqdPE3 = 32'd5043054; a_curr_vec_in_LX_dqdPE3 = -32'd266811; a_curr_vec_in_LY_dqdPE3 = -32'd419582; a_curr_vec_in_LZ_dqdPE3 = -32'd31488;
      // dqdPE4
      link_in_dqdPE4 = 3'd7;
      derv_in_dqdPE4 = 3'd4;
      sinq_val_in_dqdPE4 = 32'd49084; cosq_val_in_dqdPE4 = -32'd43424;
      qd_val_in_dqdPE4 = 32'd50674;
      v_curr_vec_in_AX_dqdPE4 = 32'd12419; v_curr_vec_in_AY_dqdPE4 = 32'd43471; v_curr_vec_in_AZ_dqdPE4 = 32'd199104; v_curr_vec_in_LX_dqdPE4 = 32'd25491; v_curr_vec_in_LY_dqdPE4 = 32'd15384; v_curr_vec_in_LZ_dqdPE4 = -32'd8629;
      a_curr_vec_in_AX_dqdPE4 = 32'd5372563; a_curr_vec_in_AY_dqdPE4 = -32'd4126612; a_curr_vec_in_AZ_dqdPE4 = 32'd5043054; a_curr_vec_in_LX_dqdPE4 = -32'd266811; a_curr_vec_in_LY_dqdPE4 = -32'd419582; a_curr_vec_in_LZ_dqdPE4 = -32'd31488;
      // dqdPE5
      link_in_dqdPE5 = 3'd7;
      derv_in_dqdPE5 = 3'd5;
      sinq_val_in_dqdPE5 = 32'd49084; cosq_val_in_dqdPE5 = -32'd43424;
      qd_val_in_dqdPE5 = 32'd50674;
      v_curr_vec_in_AX_dqdPE5 = 32'd12419; v_curr_vec_in_AY_dqdPE5 = 32'd43471; v_curr_vec_in_AZ_dqdPE5 = 32'd199104; v_curr_vec_in_LX_dqdPE5 = 32'd25491; v_curr_vec_in_LY_dqdPE5 = 32'd15384; v_curr_vec_in_LZ_dqdPE5 = -32'd8629;
      a_curr_vec_in_AX_dqdPE5 = 32'd5372563; a_curr_vec_in_AY_dqdPE5 = -32'd4126612; a_curr_vec_in_AZ_dqdPE5 = 32'd5043054; a_curr_vec_in_LX_dqdPE5 = -32'd266811; a_curr_vec_in_LY_dqdPE5 = -32'd419582; a_curr_vec_in_LZ_dqdPE5 = -32'd31488;
      // dqdPE6
      link_in_dqdPE6 = 3'd7;
      derv_in_dqdPE6 = 3'd6;
      sinq_val_in_dqdPE6 = 32'd49084; cosq_val_in_dqdPE6 = -32'd43424;
      qd_val_in_dqdPE6 = 32'd50674;
      v_curr_vec_in_AX_dqdPE6 = 32'd12419; v_curr_vec_in_AY_dqdPE6 = 32'd43471; v_curr_vec_in_AZ_dqdPE6 = 32'd199104; v_curr_vec_in_LX_dqdPE6 = 32'd25491; v_curr_vec_in_LY_dqdPE6 = 32'd15384; v_curr_vec_in_LZ_dqdPE6 = -32'd8629;
      a_curr_vec_in_AX_dqdPE6 = 32'd5372563; a_curr_vec_in_AY_dqdPE6 = -32'd4126612; a_curr_vec_in_AZ_dqdPE6 = 32'd5043054; a_curr_vec_in_LX_dqdPE6 = -32'd266811; a_curr_vec_in_LY_dqdPE6 = -32'd419582; a_curr_vec_in_LZ_dqdPE6 = -32'd31488;
      // dqdPE7
      link_in_dqdPE7 = 3'd7;
      derv_in_dqdPE7 = 3'd7;
      sinq_val_in_dqdPE7 = 32'd49084; cosq_val_in_dqdPE7 = -32'd43424;
      qd_val_in_dqdPE7 = 32'd50674;
      v_curr_vec_in_AX_dqdPE7 = 32'd12419; v_curr_vec_in_AY_dqdPE7 = 32'd43471; v_curr_vec_in_AZ_dqdPE7 = 32'd199104; v_curr_vec_in_LX_dqdPE7 = 32'd25491; v_curr_vec_in_LY_dqdPE7 = 32'd15384; v_curr_vec_in_LZ_dqdPE7 = -32'd8629;
      a_curr_vec_in_AX_dqdPE7 = 32'd5372563; a_curr_vec_in_AY_dqdPE7 = -32'd4126612; a_curr_vec_in_AZ_dqdPE7 = 32'd5043054; a_curr_vec_in_LX_dqdPE7 = -32'd266811; a_curr_vec_in_LY_dqdPE7 = -32'd419582; a_curr_vec_in_LZ_dqdPE7 = -32'd31488;
      // External dv,da
      // dqdPE1
      dvdqd_prev_vec_in_AX_dqdPE1 = dvdqd_curr_vec_reg_AX_dqdPE1; dvdqd_prev_vec_in_AY_dqdPE1 = dvdqd_curr_vec_reg_AY_dqdPE1; dvdqd_prev_vec_in_AZ_dqdPE1 = dvdqd_curr_vec_reg_AZ_dqdPE1; dvdqd_prev_vec_in_LX_dqdPE1 = dvdqd_curr_vec_reg_LX_dqdPE1; dvdqd_prev_vec_in_LY_dqdPE1 = dvdqd_curr_vec_reg_LY_dqdPE1; dvdqd_prev_vec_in_LZ_dqdPE1 = dvdqd_curr_vec_reg_LZ_dqdPE1; 
      dadqd_prev_vec_in_AX_dqdPE1 = dadqd_curr_vec_reg_AX_dqdPE1; dadqd_prev_vec_in_AY_dqdPE1 = dadqd_curr_vec_reg_AY_dqdPE1; dadqd_prev_vec_in_AZ_dqdPE1 = dadqd_curr_vec_reg_AZ_dqdPE1; dadqd_prev_vec_in_LX_dqdPE1 = dadqd_curr_vec_reg_LX_dqdPE1; dadqd_prev_vec_in_LY_dqdPE1 = dadqd_curr_vec_reg_LY_dqdPE1; dadqd_prev_vec_in_LZ_dqdPE1 = dadqd_curr_vec_reg_LZ_dqdPE1; 
      // dqdPE2
      dvdqd_prev_vec_in_AX_dqdPE2 = dvdqd_curr_vec_reg_AX_dqdPE2; dvdqd_prev_vec_in_AY_dqdPE2 = dvdqd_curr_vec_reg_AY_dqdPE2; dvdqd_prev_vec_in_AZ_dqdPE2 = dvdqd_curr_vec_reg_AZ_dqdPE2; dvdqd_prev_vec_in_LX_dqdPE2 = dvdqd_curr_vec_reg_LX_dqdPE2; dvdqd_prev_vec_in_LY_dqdPE2 = dvdqd_curr_vec_reg_LY_dqdPE2; dvdqd_prev_vec_in_LZ_dqdPE2 = dvdqd_curr_vec_reg_LZ_dqdPE2; 
      dadqd_prev_vec_in_AX_dqdPE2 = dadqd_curr_vec_reg_AX_dqdPE2; dadqd_prev_vec_in_AY_dqdPE2 = dadqd_curr_vec_reg_AY_dqdPE2; dadqd_prev_vec_in_AZ_dqdPE2 = dadqd_curr_vec_reg_AZ_dqdPE2; dadqd_prev_vec_in_LX_dqdPE2 = dadqd_curr_vec_reg_LX_dqdPE2; dadqd_prev_vec_in_LY_dqdPE2 = dadqd_curr_vec_reg_LY_dqdPE2; dadqd_prev_vec_in_LZ_dqdPE2 = dadqd_curr_vec_reg_LZ_dqdPE2; 
      // dqdPE3
      dvdqd_prev_vec_in_AX_dqdPE3 = dvdqd_curr_vec_reg_AX_dqdPE3; dvdqd_prev_vec_in_AY_dqdPE3 = dvdqd_curr_vec_reg_AY_dqdPE3; dvdqd_prev_vec_in_AZ_dqdPE3 = dvdqd_curr_vec_reg_AZ_dqdPE3; dvdqd_prev_vec_in_LX_dqdPE3 = dvdqd_curr_vec_reg_LX_dqdPE3; dvdqd_prev_vec_in_LY_dqdPE3 = dvdqd_curr_vec_reg_LY_dqdPE3; dvdqd_prev_vec_in_LZ_dqdPE3 = dvdqd_curr_vec_reg_LZ_dqdPE3; 
      dadqd_prev_vec_in_AX_dqdPE3 = dadqd_curr_vec_reg_AX_dqdPE3; dadqd_prev_vec_in_AY_dqdPE3 = dadqd_curr_vec_reg_AY_dqdPE3; dadqd_prev_vec_in_AZ_dqdPE3 = dadqd_curr_vec_reg_AZ_dqdPE3; dadqd_prev_vec_in_LX_dqdPE3 = dadqd_curr_vec_reg_LX_dqdPE3; dadqd_prev_vec_in_LY_dqdPE3 = dadqd_curr_vec_reg_LY_dqdPE3; dadqd_prev_vec_in_LZ_dqdPE3 = dadqd_curr_vec_reg_LZ_dqdPE3; 
      // dqdPE4
      dvdqd_prev_vec_in_AX_dqdPE4 = dvdqd_curr_vec_reg_AX_dqdPE4; dvdqd_prev_vec_in_AY_dqdPE4 = dvdqd_curr_vec_reg_AY_dqdPE4; dvdqd_prev_vec_in_AZ_dqdPE4 = dvdqd_curr_vec_reg_AZ_dqdPE4; dvdqd_prev_vec_in_LX_dqdPE4 = dvdqd_curr_vec_reg_LX_dqdPE4; dvdqd_prev_vec_in_LY_dqdPE4 = dvdqd_curr_vec_reg_LY_dqdPE4; dvdqd_prev_vec_in_LZ_dqdPE4 = dvdqd_curr_vec_reg_LZ_dqdPE4; 
      dadqd_prev_vec_in_AX_dqdPE4 = dadqd_curr_vec_reg_AX_dqdPE4; dadqd_prev_vec_in_AY_dqdPE4 = dadqd_curr_vec_reg_AY_dqdPE4; dadqd_prev_vec_in_AZ_dqdPE4 = dadqd_curr_vec_reg_AZ_dqdPE4; dadqd_prev_vec_in_LX_dqdPE4 = dadqd_curr_vec_reg_LX_dqdPE4; dadqd_prev_vec_in_LY_dqdPE4 = dadqd_curr_vec_reg_LY_dqdPE4; dadqd_prev_vec_in_LZ_dqdPE4 = dadqd_curr_vec_reg_LZ_dqdPE4; 
      // dqdPE5
      dvdqd_prev_vec_in_AX_dqdPE5 = dvdqd_curr_vec_reg_AX_dqdPE5; dvdqd_prev_vec_in_AY_dqdPE5 = dvdqd_curr_vec_reg_AY_dqdPE5; dvdqd_prev_vec_in_AZ_dqdPE5 = dvdqd_curr_vec_reg_AZ_dqdPE5; dvdqd_prev_vec_in_LX_dqdPE5 = dvdqd_curr_vec_reg_LX_dqdPE5; dvdqd_prev_vec_in_LY_dqdPE5 = dvdqd_curr_vec_reg_LY_dqdPE5; dvdqd_prev_vec_in_LZ_dqdPE5 = dvdqd_curr_vec_reg_LZ_dqdPE5; 
      dadqd_prev_vec_in_AX_dqdPE5 = dadqd_curr_vec_reg_AX_dqdPE5; dadqd_prev_vec_in_AY_dqdPE5 = dadqd_curr_vec_reg_AY_dqdPE5; dadqd_prev_vec_in_AZ_dqdPE5 = dadqd_curr_vec_reg_AZ_dqdPE5; dadqd_prev_vec_in_LX_dqdPE5 = dadqd_curr_vec_reg_LX_dqdPE5; dadqd_prev_vec_in_LY_dqdPE5 = dadqd_curr_vec_reg_LY_dqdPE5; dadqd_prev_vec_in_LZ_dqdPE5 = dadqd_curr_vec_reg_LZ_dqdPE5; 
      // dqdPE6
      dvdqd_prev_vec_in_AX_dqdPE6 = dvdqd_curr_vec_reg_AX_dqdPE6; dvdqd_prev_vec_in_AY_dqdPE6 = dvdqd_curr_vec_reg_AY_dqdPE6; dvdqd_prev_vec_in_AZ_dqdPE6 = dvdqd_curr_vec_reg_AZ_dqdPE6; dvdqd_prev_vec_in_LX_dqdPE6 = dvdqd_curr_vec_reg_LX_dqdPE6; dvdqd_prev_vec_in_LY_dqdPE6 = dvdqd_curr_vec_reg_LY_dqdPE6; dvdqd_prev_vec_in_LZ_dqdPE6 = dvdqd_curr_vec_reg_LZ_dqdPE6; 
      dadqd_prev_vec_in_AX_dqdPE6 = dadqd_curr_vec_reg_AX_dqdPE6; dadqd_prev_vec_in_AY_dqdPE6 = dadqd_curr_vec_reg_AY_dqdPE6; dadqd_prev_vec_in_AZ_dqdPE6 = dadqd_curr_vec_reg_AZ_dqdPE6; dadqd_prev_vec_in_LX_dqdPE6 = dadqd_curr_vec_reg_LX_dqdPE6; dadqd_prev_vec_in_LY_dqdPE6 = dadqd_curr_vec_reg_LY_dqdPE6; dadqd_prev_vec_in_LZ_dqdPE6 = dadqd_curr_vec_reg_LZ_dqdPE6; 
      // dqdPE7
      dvdqd_prev_vec_in_AX_dqdPE7 = dvdqd_curr_vec_reg_AX_dqdPE7; dvdqd_prev_vec_in_AY_dqdPE7 = dvdqd_curr_vec_reg_AY_dqdPE7; dvdqd_prev_vec_in_AZ_dqdPE7 = dvdqd_curr_vec_reg_AZ_dqdPE7; dvdqd_prev_vec_in_LX_dqdPE7 = dvdqd_curr_vec_reg_LX_dqdPE7; dvdqd_prev_vec_in_LY_dqdPE7 = dvdqd_curr_vec_reg_LY_dqdPE7; dvdqd_prev_vec_in_LZ_dqdPE7 = dvdqd_curr_vec_reg_LZ_dqdPE7; 
      dadqd_prev_vec_in_AX_dqdPE7 = dadqd_curr_vec_reg_AX_dqdPE7; dadqd_prev_vec_in_AY_dqdPE7 = dadqd_curr_vec_reg_AY_dqdPE7; dadqd_prev_vec_in_AZ_dqdPE7 = dadqd_curr_vec_reg_AZ_dqdPE7; dadqd_prev_vec_in_LX_dqdPE7 = dadqd_curr_vec_reg_LX_dqdPE7; dadqd_prev_vec_in_LY_dqdPE7 = dadqd_curr_vec_reg_LY_dqdPE7; dadqd_prev_vec_in_LZ_dqdPE7 = dadqd_curr_vec_reg_LZ_dqdPE7; 
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
      $display ("// Link 7 Derivatives Only");
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dq
      $display ("dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", 0, -155, 691, 463, 126, 1874, -6533);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 52, -424, 142, 895, 1840, -8044);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -3285, -13804, 6498, 35032, 34895, -133594);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, 10772, -28595, -29148, -4116, -35504, 120315);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", 0, -19629, 12420, 15012, -6108, -26838, -0);
      $display ("\n");
      $display ("dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AX_dqPE1,dfdq_curr_vec_out_AX_dqPE2,dfdq_curr_vec_out_AX_dqPE3,dfdq_curr_vec_out_AX_dqPE4,dfdq_curr_vec_out_AX_dqPE5,dfdq_curr_vec_out_AX_dqPE6,dfdq_curr_vec_out_AX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AY_dqPE1,dfdq_curr_vec_out_AY_dqPE2,dfdq_curr_vec_out_AY_dqPE3,dfdq_curr_vec_out_AY_dqPE4,dfdq_curr_vec_out_AY_dqPE5,dfdq_curr_vec_out_AY_dqPE6,dfdq_curr_vec_out_AY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_AZ_dqPE1,dfdq_curr_vec_out_AZ_dqPE2,dfdq_curr_vec_out_AZ_dqPE3,dfdq_curr_vec_out_AZ_dqPE4,dfdq_curr_vec_out_AZ_dqPE5,dfdq_curr_vec_out_AZ_dqPE6,dfdq_curr_vec_out_AZ_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LX_dqPE1,dfdq_curr_vec_out_LX_dqPE2,dfdq_curr_vec_out_LX_dqPE3,dfdq_curr_vec_out_LX_dqPE4,dfdq_curr_vec_out_LX_dqPE5,dfdq_curr_vec_out_LX_dqPE6,dfdq_curr_vec_out_LX_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LY_dqPE1,dfdq_curr_vec_out_LY_dqPE2,dfdq_curr_vec_out_LY_dqPE3,dfdq_curr_vec_out_LY_dqPE4,dfdq_curr_vec_out_LY_dqPE5,dfdq_curr_vec_out_LY_dqPE6,dfdq_curr_vec_out_LY_dqPE7);
      $display ("                     %d,%d,%d,%d,%d,%d,%d", dfdq_curr_vec_out_LZ_dqPE1,dfdq_curr_vec_out_LZ_dqPE2,dfdq_curr_vec_out_LZ_dqPE3,dfdq_curr_vec_out_LZ_dqPE4,dfdq_curr_vec_out_LZ_dqPE5,dfdq_curr_vec_out_LZ_dqPE6,dfdq_curr_vec_out_LZ_dqPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // df/dqd
      $display ("dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d", -204, -355, 58, 128, 34, 184, 43);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -186, 404, -176, -786, 108, 208, -12);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -10435, 23638, -7656, -37658, 3027, 6737, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", 13340, 20050, 289, -5454, 998, -5960, 0);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", -8477, -12323, 1071, -549, -757, 1182, 0);
      $display ("\n");
      $display ("dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AX_dqdPE1,dfdqd_curr_vec_out_AX_dqdPE2,dfdqd_curr_vec_out_AX_dqdPE3,dfdqd_curr_vec_out_AX_dqdPE4,dfdqd_curr_vec_out_AX_dqdPE5,dfdqd_curr_vec_out_AX_dqdPE6,dfdqd_curr_vec_out_AX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AY_dqdPE1,dfdqd_curr_vec_out_AY_dqdPE2,dfdqd_curr_vec_out_AY_dqdPE3,dfdqd_curr_vec_out_AY_dqdPE4,dfdqd_curr_vec_out_AY_dqdPE5,dfdqd_curr_vec_out_AY_dqdPE6,dfdqd_curr_vec_out_AY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_AZ_dqdPE1,dfdqd_curr_vec_out_AZ_dqdPE2,dfdqd_curr_vec_out_AZ_dqdPE3,dfdqd_curr_vec_out_AZ_dqdPE4,dfdqd_curr_vec_out_AZ_dqdPE5,dfdqd_curr_vec_out_AZ_dqdPE6,dfdqd_curr_vec_out_AZ_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LX_dqdPE1,dfdqd_curr_vec_out_LX_dqdPE2,dfdqd_curr_vec_out_LX_dqdPE3,dfdqd_curr_vec_out_LX_dqdPE4,dfdqd_curr_vec_out_LX_dqdPE5,dfdqd_curr_vec_out_LX_dqdPE6,dfdqd_curr_vec_out_LX_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LY_dqdPE1,dfdqd_curr_vec_out_LY_dqdPE2,dfdqd_curr_vec_out_LY_dqdPE3,dfdqd_curr_vec_out_LY_dqdPE4,dfdqd_curr_vec_out_LY_dqdPE5,dfdqd_curr_vec_out_LY_dqdPE6,dfdqd_curr_vec_out_LY_dqdPE7);
      $display ("                      %d,%d,%d,%d,%d,%d,%d", dfdqd_curr_vec_out_LZ_dqdPE1,dfdqd_curr_vec_out_LZ_dqdPE2,dfdqd_curr_vec_out_LZ_dqdPE3,dfdqd_curr_vec_out_LZ_dqdPE4,dfdqd_curr_vec_out_LZ_dqdPE5,dfdqd_curr_vec_out_LZ_dqdPE6,dfdqd_curr_vec_out_LZ_dqdPE7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External dv,da
      //------------------------------------------------------------------------
      // dqPE1
      dvdq_curr_vec_reg_AX_dqPE1 = dvdq_curr_vec_out_AX_dqPE1; dvdq_curr_vec_reg_AY_dqPE1 = dvdq_curr_vec_out_AY_dqPE1; dvdq_curr_vec_reg_AZ_dqPE1 = dvdq_curr_vec_out_AZ_dqPE1; dvdq_curr_vec_reg_LX_dqPE1 = dvdq_curr_vec_out_LX_dqPE1; dvdq_curr_vec_reg_LY_dqPE1 = dvdq_curr_vec_out_LY_dqPE1; dvdq_curr_vec_reg_LZ_dqPE1 = dvdq_curr_vec_out_LZ_dqPE1; 
      dadq_curr_vec_reg_AX_dqPE1 = dadq_curr_vec_out_AX_dqPE1; dadq_curr_vec_reg_AY_dqPE1 = dadq_curr_vec_out_AY_dqPE1; dadq_curr_vec_reg_AZ_dqPE1 = dadq_curr_vec_out_AZ_dqPE1; dadq_curr_vec_reg_LX_dqPE1 = dadq_curr_vec_out_LX_dqPE1; dadq_curr_vec_reg_LY_dqPE1 = dadq_curr_vec_out_LY_dqPE1; dadq_curr_vec_reg_LZ_dqPE1 = dadq_curr_vec_out_LZ_dqPE1; 
      // dqPE2
      dvdq_curr_vec_reg_AX_dqPE2 = dvdq_curr_vec_out_AX_dqPE2; dvdq_curr_vec_reg_AY_dqPE2 = dvdq_curr_vec_out_AY_dqPE2; dvdq_curr_vec_reg_AZ_dqPE2 = dvdq_curr_vec_out_AZ_dqPE2; dvdq_curr_vec_reg_LX_dqPE2 = dvdq_curr_vec_out_LX_dqPE2; dvdq_curr_vec_reg_LY_dqPE2 = dvdq_curr_vec_out_LY_dqPE2; dvdq_curr_vec_reg_LZ_dqPE2 = dvdq_curr_vec_out_LZ_dqPE2; 
      dadq_curr_vec_reg_AX_dqPE2 = dadq_curr_vec_out_AX_dqPE2; dadq_curr_vec_reg_AY_dqPE2 = dadq_curr_vec_out_AY_dqPE2; dadq_curr_vec_reg_AZ_dqPE2 = dadq_curr_vec_out_AZ_dqPE2; dadq_curr_vec_reg_LX_dqPE2 = dadq_curr_vec_out_LX_dqPE2; dadq_curr_vec_reg_LY_dqPE2 = dadq_curr_vec_out_LY_dqPE2; dadq_curr_vec_reg_LZ_dqPE2 = dadq_curr_vec_out_LZ_dqPE2; 
      // dqPE3
      dvdq_curr_vec_reg_AX_dqPE3 = dvdq_curr_vec_out_AX_dqPE3; dvdq_curr_vec_reg_AY_dqPE3 = dvdq_curr_vec_out_AY_dqPE3; dvdq_curr_vec_reg_AZ_dqPE3 = dvdq_curr_vec_out_AZ_dqPE3; dvdq_curr_vec_reg_LX_dqPE3 = dvdq_curr_vec_out_LX_dqPE3; dvdq_curr_vec_reg_LY_dqPE3 = dvdq_curr_vec_out_LY_dqPE3; dvdq_curr_vec_reg_LZ_dqPE3 = dvdq_curr_vec_out_LZ_dqPE3; 
      dadq_curr_vec_reg_AX_dqPE3 = dadq_curr_vec_out_AX_dqPE3; dadq_curr_vec_reg_AY_dqPE3 = dadq_curr_vec_out_AY_dqPE3; dadq_curr_vec_reg_AZ_dqPE3 = dadq_curr_vec_out_AZ_dqPE3; dadq_curr_vec_reg_LX_dqPE3 = dadq_curr_vec_out_LX_dqPE3; dadq_curr_vec_reg_LY_dqPE3 = dadq_curr_vec_out_LY_dqPE3; dadq_curr_vec_reg_LZ_dqPE3 = dadq_curr_vec_out_LZ_dqPE3; 
      // dqPE4
      dvdq_curr_vec_reg_AX_dqPE4 = dvdq_curr_vec_out_AX_dqPE4; dvdq_curr_vec_reg_AY_dqPE4 = dvdq_curr_vec_out_AY_dqPE4; dvdq_curr_vec_reg_AZ_dqPE4 = dvdq_curr_vec_out_AZ_dqPE4; dvdq_curr_vec_reg_LX_dqPE4 = dvdq_curr_vec_out_LX_dqPE4; dvdq_curr_vec_reg_LY_dqPE4 = dvdq_curr_vec_out_LY_dqPE4; dvdq_curr_vec_reg_LZ_dqPE4 = dvdq_curr_vec_out_LZ_dqPE4; 
      dadq_curr_vec_reg_AX_dqPE4 = dadq_curr_vec_out_AX_dqPE4; dadq_curr_vec_reg_AY_dqPE4 = dadq_curr_vec_out_AY_dqPE4; dadq_curr_vec_reg_AZ_dqPE4 = dadq_curr_vec_out_AZ_dqPE4; dadq_curr_vec_reg_LX_dqPE4 = dadq_curr_vec_out_LX_dqPE4; dadq_curr_vec_reg_LY_dqPE4 = dadq_curr_vec_out_LY_dqPE4; dadq_curr_vec_reg_LZ_dqPE4 = dadq_curr_vec_out_LZ_dqPE4; 
      // dqPE5
      dvdq_curr_vec_reg_AX_dqPE5 = dvdq_curr_vec_out_AX_dqPE5; dvdq_curr_vec_reg_AY_dqPE5 = dvdq_curr_vec_out_AY_dqPE5; dvdq_curr_vec_reg_AZ_dqPE5 = dvdq_curr_vec_out_AZ_dqPE5; dvdq_curr_vec_reg_LX_dqPE5 = dvdq_curr_vec_out_LX_dqPE5; dvdq_curr_vec_reg_LY_dqPE5 = dvdq_curr_vec_out_LY_dqPE5; dvdq_curr_vec_reg_LZ_dqPE5 = dvdq_curr_vec_out_LZ_dqPE5; 
      dadq_curr_vec_reg_AX_dqPE5 = dadq_curr_vec_out_AX_dqPE5; dadq_curr_vec_reg_AY_dqPE5 = dadq_curr_vec_out_AY_dqPE5; dadq_curr_vec_reg_AZ_dqPE5 = dadq_curr_vec_out_AZ_dqPE5; dadq_curr_vec_reg_LX_dqPE5 = dadq_curr_vec_out_LX_dqPE5; dadq_curr_vec_reg_LY_dqPE5 = dadq_curr_vec_out_LY_dqPE5; dadq_curr_vec_reg_LZ_dqPE5 = dadq_curr_vec_out_LZ_dqPE5; 
      // dqPE6
      dvdq_curr_vec_reg_AX_dqPE6 = dvdq_curr_vec_out_AX_dqPE6; dvdq_curr_vec_reg_AY_dqPE6 = dvdq_curr_vec_out_AY_dqPE6; dvdq_curr_vec_reg_AZ_dqPE6 = dvdq_curr_vec_out_AZ_dqPE6; dvdq_curr_vec_reg_LX_dqPE6 = dvdq_curr_vec_out_LX_dqPE6; dvdq_curr_vec_reg_LY_dqPE6 = dvdq_curr_vec_out_LY_dqPE6; dvdq_curr_vec_reg_LZ_dqPE6 = dvdq_curr_vec_out_LZ_dqPE6; 
      dadq_curr_vec_reg_AX_dqPE6 = dadq_curr_vec_out_AX_dqPE6; dadq_curr_vec_reg_AY_dqPE6 = dadq_curr_vec_out_AY_dqPE6; dadq_curr_vec_reg_AZ_dqPE6 = dadq_curr_vec_out_AZ_dqPE6; dadq_curr_vec_reg_LX_dqPE6 = dadq_curr_vec_out_LX_dqPE6; dadq_curr_vec_reg_LY_dqPE6 = dadq_curr_vec_out_LY_dqPE6; dadq_curr_vec_reg_LZ_dqPE6 = dadq_curr_vec_out_LZ_dqPE6; 
      // dqPE7
      dvdq_curr_vec_reg_AX_dqPE7 = dvdq_curr_vec_out_AX_dqPE7; dvdq_curr_vec_reg_AY_dqPE7 = dvdq_curr_vec_out_AY_dqPE7; dvdq_curr_vec_reg_AZ_dqPE7 = dvdq_curr_vec_out_AZ_dqPE7; dvdq_curr_vec_reg_LX_dqPE7 = dvdq_curr_vec_out_LX_dqPE7; dvdq_curr_vec_reg_LY_dqPE7 = dvdq_curr_vec_out_LY_dqPE7; dvdq_curr_vec_reg_LZ_dqPE7 = dvdq_curr_vec_out_LZ_dqPE7; 
      dadq_curr_vec_reg_AX_dqPE7 = dadq_curr_vec_out_AX_dqPE7; dadq_curr_vec_reg_AY_dqPE7 = dadq_curr_vec_out_AY_dqPE7; dadq_curr_vec_reg_AZ_dqPE7 = dadq_curr_vec_out_AZ_dqPE7; dadq_curr_vec_reg_LX_dqPE7 = dadq_curr_vec_out_LX_dqPE7; dadq_curr_vec_reg_LY_dqPE7 = dadq_curr_vec_out_LY_dqPE7; dadq_curr_vec_reg_LZ_dqPE7 = dadq_curr_vec_out_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqdPE1
      dvdqd_curr_vec_reg_AX_dqdPE1 = dvdqd_curr_vec_out_AX_dqdPE1; dvdqd_curr_vec_reg_AY_dqdPE1 = dvdqd_curr_vec_out_AY_dqdPE1; dvdqd_curr_vec_reg_AZ_dqdPE1 = dvdqd_curr_vec_out_AZ_dqdPE1; dvdqd_curr_vec_reg_LX_dqdPE1 = dvdqd_curr_vec_out_LX_dqdPE1; dvdqd_curr_vec_reg_LY_dqdPE1 = dvdqd_curr_vec_out_LY_dqdPE1; dvdqd_curr_vec_reg_LZ_dqdPE1 = dvdqd_curr_vec_out_LZ_dqdPE1; 
      dadqd_curr_vec_reg_AX_dqdPE1 = dadqd_curr_vec_out_AX_dqdPE1; dadqd_curr_vec_reg_AY_dqdPE1 = dadqd_curr_vec_out_AY_dqdPE1; dadqd_curr_vec_reg_AZ_dqdPE1 = dadqd_curr_vec_out_AZ_dqdPE1; dadqd_curr_vec_reg_LX_dqdPE1 = dadqd_curr_vec_out_LX_dqdPE1; dadqd_curr_vec_reg_LY_dqdPE1 = dadqd_curr_vec_out_LY_dqdPE1; dadqd_curr_vec_reg_LZ_dqdPE1 = dadqd_curr_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dvdqd_curr_vec_reg_AX_dqdPE2 = dvdqd_curr_vec_out_AX_dqdPE2; dvdqd_curr_vec_reg_AY_dqdPE2 = dvdqd_curr_vec_out_AY_dqdPE2; dvdqd_curr_vec_reg_AZ_dqdPE2 = dvdqd_curr_vec_out_AZ_dqdPE2; dvdqd_curr_vec_reg_LX_dqdPE2 = dvdqd_curr_vec_out_LX_dqdPE2; dvdqd_curr_vec_reg_LY_dqdPE2 = dvdqd_curr_vec_out_LY_dqdPE2; dvdqd_curr_vec_reg_LZ_dqdPE2 = dvdqd_curr_vec_out_LZ_dqdPE2; 
      dadqd_curr_vec_reg_AX_dqdPE2 = dadqd_curr_vec_out_AX_dqdPE2; dadqd_curr_vec_reg_AY_dqdPE2 = dadqd_curr_vec_out_AY_dqdPE2; dadqd_curr_vec_reg_AZ_dqdPE2 = dadqd_curr_vec_out_AZ_dqdPE2; dadqd_curr_vec_reg_LX_dqdPE2 = dadqd_curr_vec_out_LX_dqdPE2; dadqd_curr_vec_reg_LY_dqdPE2 = dadqd_curr_vec_out_LY_dqdPE2; dadqd_curr_vec_reg_LZ_dqdPE2 = dadqd_curr_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dvdqd_curr_vec_reg_AX_dqdPE3 = dvdqd_curr_vec_out_AX_dqdPE3; dvdqd_curr_vec_reg_AY_dqdPE3 = dvdqd_curr_vec_out_AY_dqdPE3; dvdqd_curr_vec_reg_AZ_dqdPE3 = dvdqd_curr_vec_out_AZ_dqdPE3; dvdqd_curr_vec_reg_LX_dqdPE3 = dvdqd_curr_vec_out_LX_dqdPE3; dvdqd_curr_vec_reg_LY_dqdPE3 = dvdqd_curr_vec_out_LY_dqdPE3; dvdqd_curr_vec_reg_LZ_dqdPE3 = dvdqd_curr_vec_out_LZ_dqdPE3; 
      dadqd_curr_vec_reg_AX_dqdPE3 = dadqd_curr_vec_out_AX_dqdPE3; dadqd_curr_vec_reg_AY_dqdPE3 = dadqd_curr_vec_out_AY_dqdPE3; dadqd_curr_vec_reg_AZ_dqdPE3 = dadqd_curr_vec_out_AZ_dqdPE3; dadqd_curr_vec_reg_LX_dqdPE3 = dadqd_curr_vec_out_LX_dqdPE3; dadqd_curr_vec_reg_LY_dqdPE3 = dadqd_curr_vec_out_LY_dqdPE3; dadqd_curr_vec_reg_LZ_dqdPE3 = dadqd_curr_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dvdqd_curr_vec_reg_AX_dqdPE4 = dvdqd_curr_vec_out_AX_dqdPE4; dvdqd_curr_vec_reg_AY_dqdPE4 = dvdqd_curr_vec_out_AY_dqdPE4; dvdqd_curr_vec_reg_AZ_dqdPE4 = dvdqd_curr_vec_out_AZ_dqdPE4; dvdqd_curr_vec_reg_LX_dqdPE4 = dvdqd_curr_vec_out_LX_dqdPE4; dvdqd_curr_vec_reg_LY_dqdPE4 = dvdqd_curr_vec_out_LY_dqdPE4; dvdqd_curr_vec_reg_LZ_dqdPE4 = dvdqd_curr_vec_out_LZ_dqdPE4; 
      dadqd_curr_vec_reg_AX_dqdPE4 = dadqd_curr_vec_out_AX_dqdPE4; dadqd_curr_vec_reg_AY_dqdPE4 = dadqd_curr_vec_out_AY_dqdPE4; dadqd_curr_vec_reg_AZ_dqdPE4 = dadqd_curr_vec_out_AZ_dqdPE4; dadqd_curr_vec_reg_LX_dqdPE4 = dadqd_curr_vec_out_LX_dqdPE4; dadqd_curr_vec_reg_LY_dqdPE4 = dadqd_curr_vec_out_LY_dqdPE4; dadqd_curr_vec_reg_LZ_dqdPE4 = dadqd_curr_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dvdqd_curr_vec_reg_AX_dqdPE5 = dvdqd_curr_vec_out_AX_dqdPE5; dvdqd_curr_vec_reg_AY_dqdPE5 = dvdqd_curr_vec_out_AY_dqdPE5; dvdqd_curr_vec_reg_AZ_dqdPE5 = dvdqd_curr_vec_out_AZ_dqdPE5; dvdqd_curr_vec_reg_LX_dqdPE5 = dvdqd_curr_vec_out_LX_dqdPE5; dvdqd_curr_vec_reg_LY_dqdPE5 = dvdqd_curr_vec_out_LY_dqdPE5; dvdqd_curr_vec_reg_LZ_dqdPE5 = dvdqd_curr_vec_out_LZ_dqdPE5; 
      dadqd_curr_vec_reg_AX_dqdPE5 = dadqd_curr_vec_out_AX_dqdPE5; dadqd_curr_vec_reg_AY_dqdPE5 = dadqd_curr_vec_out_AY_dqdPE5; dadqd_curr_vec_reg_AZ_dqdPE5 = dadqd_curr_vec_out_AZ_dqdPE5; dadqd_curr_vec_reg_LX_dqdPE5 = dadqd_curr_vec_out_LX_dqdPE5; dadqd_curr_vec_reg_LY_dqdPE5 = dadqd_curr_vec_out_LY_dqdPE5; dadqd_curr_vec_reg_LZ_dqdPE5 = dadqd_curr_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dvdqd_curr_vec_reg_AX_dqdPE6 = dvdqd_curr_vec_out_AX_dqdPE6; dvdqd_curr_vec_reg_AY_dqdPE6 = dvdqd_curr_vec_out_AY_dqdPE6; dvdqd_curr_vec_reg_AZ_dqdPE6 = dvdqd_curr_vec_out_AZ_dqdPE6; dvdqd_curr_vec_reg_LX_dqdPE6 = dvdqd_curr_vec_out_LX_dqdPE6; dvdqd_curr_vec_reg_LY_dqdPE6 = dvdqd_curr_vec_out_LY_dqdPE6; dvdqd_curr_vec_reg_LZ_dqdPE6 = dvdqd_curr_vec_out_LZ_dqdPE6; 
      dadqd_curr_vec_reg_AX_dqdPE6 = dadqd_curr_vec_out_AX_dqdPE6; dadqd_curr_vec_reg_AY_dqdPE6 = dadqd_curr_vec_out_AY_dqdPE6; dadqd_curr_vec_reg_AZ_dqdPE6 = dadqd_curr_vec_out_AZ_dqdPE6; dadqd_curr_vec_reg_LX_dqdPE6 = dadqd_curr_vec_out_LX_dqdPE6; dadqd_curr_vec_reg_LY_dqdPE6 = dadqd_curr_vec_out_LY_dqdPE6; dadqd_curr_vec_reg_LZ_dqdPE6 = dadqd_curr_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dvdqd_curr_vec_reg_AX_dqdPE7 = dvdqd_curr_vec_out_AX_dqdPE7; dvdqd_curr_vec_reg_AY_dqdPE7 = dvdqd_curr_vec_out_AY_dqdPE7; dvdqd_curr_vec_reg_AZ_dqdPE7 = dvdqd_curr_vec_out_AZ_dqdPE7; dvdqd_curr_vec_reg_LX_dqdPE7 = dvdqd_curr_vec_out_LX_dqdPE7; dvdqd_curr_vec_reg_LY_dqdPE7 = dvdqd_curr_vec_out_LY_dqdPE7; dvdqd_curr_vec_reg_LZ_dqdPE7 = dvdqd_curr_vec_out_LZ_dqdPE7; 
      dadqd_curr_vec_reg_AX_dqdPE7 = dadqd_curr_vec_out_AX_dqdPE7; dadqd_curr_vec_reg_AY_dqdPE7 = dadqd_curr_vec_out_AY_dqdPE7; dadqd_curr_vec_reg_AZ_dqdPE7 = dadqd_curr_vec_out_AZ_dqdPE7; dadqd_curr_vec_reg_LX_dqdPE7 = dadqd_curr_vec_out_LX_dqdPE7; dadqd_curr_vec_reg_LY_dqdPE7 = dadqd_curr_vec_out_LY_dqdPE7; dadqd_curr_vec_reg_LZ_dqdPE7 = dadqd_curr_vec_out_LZ_dqdPE7; 
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
