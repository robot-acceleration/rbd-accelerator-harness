`timescale 1ns / 1ps

// Forward Pass Row Unit with RNEA

//------------------------------------------------------------------------------
// fproc Module
//------------------------------------------------------------------------------
module fproc#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // clock
   input  clk,
   // reset
   input reset,
   // get_data
   input get_data,
   //---------------------------------------------------------------------------
   // rnea external inputs
   //---------------------------------------------------------------------------
   // rnea
   input  [2:0]
      link_in_rnea,
   input  signed[(WIDTH-1):0]
      sinq_val_in_rnea,cosq_val_in_rnea,
   input  signed[(WIDTH-1):0]
      qd_val_in_rnea,
   input  signed[(WIDTH-1):0]
      qdd_val_in_rnea,
   input  signed[(WIDTH-1):0]
      v_prev_vec_in_AX_rnea,v_prev_vec_in_AY_rnea,v_prev_vec_in_AZ_rnea,v_prev_vec_in_LX_rnea,v_prev_vec_in_LY_rnea,v_prev_vec_in_LZ_rnea,
   input  signed[(WIDTH-1):0]
      a_prev_vec_in_AX_rnea,a_prev_vec_in_AY_rnea,a_prev_vec_in_AZ_rnea,a_prev_vec_in_LX_rnea,a_prev_vec_in_LY_rnea,a_prev_vec_in_LZ_rnea,
   //---------------------------------------------------------------------------
   // dq external inputs
   //---------------------------------------------------------------------------
   // dqPE1
   input  [2:0]
      link_in_dqPE1,
   input  [2:0]
      derv_in_dqPE1,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE1,cosq_val_in_dqPE1,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqPE1,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqPE1,v_curr_vec_in_AY_dqPE1,v_curr_vec_in_AZ_dqPE1,v_curr_vec_in_LX_dqPE1,v_curr_vec_in_LY_dqPE1,v_curr_vec_in_LZ_dqPE1,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqPE1,a_curr_vec_in_AY_dqPE1,a_curr_vec_in_AZ_dqPE1,a_curr_vec_in_LX_dqPE1,a_curr_vec_in_LY_dqPE1,a_curr_vec_in_LZ_dqPE1,
   input  signed[(WIDTH-1):0]
      v_prev_vec_in_AX_dqPE1,v_prev_vec_in_AY_dqPE1,v_prev_vec_in_AZ_dqPE1,v_prev_vec_in_LX_dqPE1,v_prev_vec_in_LY_dqPE1,v_prev_vec_in_LZ_dqPE1,
   input  signed[(WIDTH-1):0]
      a_prev_vec_in_AX_dqPE1,a_prev_vec_in_AY_dqPE1,a_prev_vec_in_AZ_dqPE1,a_prev_vec_in_LX_dqPE1,a_prev_vec_in_LY_dqPE1,a_prev_vec_in_LZ_dqPE1,
   input  signed[(WIDTH-1):0]
      dvdq_prev_vec_in_AX_dqPE1,dvdq_prev_vec_in_AY_dqPE1,dvdq_prev_vec_in_AZ_dqPE1,dvdq_prev_vec_in_LX_dqPE1,dvdq_prev_vec_in_LY_dqPE1,dvdq_prev_vec_in_LZ_dqPE1,
   input  signed[(WIDTH-1):0]
      dadq_prev_vec_in_AX_dqPE1,dadq_prev_vec_in_AY_dqPE1,dadq_prev_vec_in_AZ_dqPE1,dadq_prev_vec_in_LX_dqPE1,dadq_prev_vec_in_LY_dqPE1,dadq_prev_vec_in_LZ_dqPE1,
   // dqPE2
   input  [2:0]
      link_in_dqPE2,
   input  [2:0]
      derv_in_dqPE2,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE2,cosq_val_in_dqPE2,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqPE2,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqPE2,v_curr_vec_in_AY_dqPE2,v_curr_vec_in_AZ_dqPE2,v_curr_vec_in_LX_dqPE2,v_curr_vec_in_LY_dqPE2,v_curr_vec_in_LZ_dqPE2,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqPE2,a_curr_vec_in_AY_dqPE2,a_curr_vec_in_AZ_dqPE2,a_curr_vec_in_LX_dqPE2,a_curr_vec_in_LY_dqPE2,a_curr_vec_in_LZ_dqPE2,
   input  signed[(WIDTH-1):0]
      v_prev_vec_in_AX_dqPE2,v_prev_vec_in_AY_dqPE2,v_prev_vec_in_AZ_dqPE2,v_prev_vec_in_LX_dqPE2,v_prev_vec_in_LY_dqPE2,v_prev_vec_in_LZ_dqPE2,
   input  signed[(WIDTH-1):0]
      a_prev_vec_in_AX_dqPE2,a_prev_vec_in_AY_dqPE2,a_prev_vec_in_AZ_dqPE2,a_prev_vec_in_LX_dqPE2,a_prev_vec_in_LY_dqPE2,a_prev_vec_in_LZ_dqPE2,
   input  signed[(WIDTH-1):0]
      dvdq_prev_vec_in_AX_dqPE2,dvdq_prev_vec_in_AY_dqPE2,dvdq_prev_vec_in_AZ_dqPE2,dvdq_prev_vec_in_LX_dqPE2,dvdq_prev_vec_in_LY_dqPE2,dvdq_prev_vec_in_LZ_dqPE2,
   input  signed[(WIDTH-1):0]
      dadq_prev_vec_in_AX_dqPE2,dadq_prev_vec_in_AY_dqPE2,dadq_prev_vec_in_AZ_dqPE2,dadq_prev_vec_in_LX_dqPE2,dadq_prev_vec_in_LY_dqPE2,dadq_prev_vec_in_LZ_dqPE2,
   // dqPE3
   input  [2:0]
      link_in_dqPE3,
   input  [2:0]
      derv_in_dqPE3,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE3,cosq_val_in_dqPE3,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqPE3,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqPE3,v_curr_vec_in_AY_dqPE3,v_curr_vec_in_AZ_dqPE3,v_curr_vec_in_LX_dqPE3,v_curr_vec_in_LY_dqPE3,v_curr_vec_in_LZ_dqPE3,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqPE3,a_curr_vec_in_AY_dqPE3,a_curr_vec_in_AZ_dqPE3,a_curr_vec_in_LX_dqPE3,a_curr_vec_in_LY_dqPE3,a_curr_vec_in_LZ_dqPE3,
   input  signed[(WIDTH-1):0]
      v_prev_vec_in_AX_dqPE3,v_prev_vec_in_AY_dqPE3,v_prev_vec_in_AZ_dqPE3,v_prev_vec_in_LX_dqPE3,v_prev_vec_in_LY_dqPE3,v_prev_vec_in_LZ_dqPE3,
   input  signed[(WIDTH-1):0]
      a_prev_vec_in_AX_dqPE3,a_prev_vec_in_AY_dqPE3,a_prev_vec_in_AZ_dqPE3,a_prev_vec_in_LX_dqPE3,a_prev_vec_in_LY_dqPE3,a_prev_vec_in_LZ_dqPE3,
   input  signed[(WIDTH-1):0]
      dvdq_prev_vec_in_AX_dqPE3,dvdq_prev_vec_in_AY_dqPE3,dvdq_prev_vec_in_AZ_dqPE3,dvdq_prev_vec_in_LX_dqPE3,dvdq_prev_vec_in_LY_dqPE3,dvdq_prev_vec_in_LZ_dqPE3,
   input  signed[(WIDTH-1):0]
      dadq_prev_vec_in_AX_dqPE3,dadq_prev_vec_in_AY_dqPE3,dadq_prev_vec_in_AZ_dqPE3,dadq_prev_vec_in_LX_dqPE3,dadq_prev_vec_in_LY_dqPE3,dadq_prev_vec_in_LZ_dqPE3,
   // dqPE4
   input  [2:0]
      link_in_dqPE4,
   input  [2:0]
      derv_in_dqPE4,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE4,cosq_val_in_dqPE4,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqPE4,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqPE4,v_curr_vec_in_AY_dqPE4,v_curr_vec_in_AZ_dqPE4,v_curr_vec_in_LX_dqPE4,v_curr_vec_in_LY_dqPE4,v_curr_vec_in_LZ_dqPE4,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqPE4,a_curr_vec_in_AY_dqPE4,a_curr_vec_in_AZ_dqPE4,a_curr_vec_in_LX_dqPE4,a_curr_vec_in_LY_dqPE4,a_curr_vec_in_LZ_dqPE4,
   input  signed[(WIDTH-1):0]
      v_prev_vec_in_AX_dqPE4,v_prev_vec_in_AY_dqPE4,v_prev_vec_in_AZ_dqPE4,v_prev_vec_in_LX_dqPE4,v_prev_vec_in_LY_dqPE4,v_prev_vec_in_LZ_dqPE4,
   input  signed[(WIDTH-1):0]
      a_prev_vec_in_AX_dqPE4,a_prev_vec_in_AY_dqPE4,a_prev_vec_in_AZ_dqPE4,a_prev_vec_in_LX_dqPE4,a_prev_vec_in_LY_dqPE4,a_prev_vec_in_LZ_dqPE4,
   input  signed[(WIDTH-1):0]
      dvdq_prev_vec_in_AX_dqPE4,dvdq_prev_vec_in_AY_dqPE4,dvdq_prev_vec_in_AZ_dqPE4,dvdq_prev_vec_in_LX_dqPE4,dvdq_prev_vec_in_LY_dqPE4,dvdq_prev_vec_in_LZ_dqPE4,
   input  signed[(WIDTH-1):0]
      dadq_prev_vec_in_AX_dqPE4,dadq_prev_vec_in_AY_dqPE4,dadq_prev_vec_in_AZ_dqPE4,dadq_prev_vec_in_LX_dqPE4,dadq_prev_vec_in_LY_dqPE4,dadq_prev_vec_in_LZ_dqPE4,
   // dqPE5
   input  [2:0]
      link_in_dqPE5,
   input  [2:0]
      derv_in_dqPE5,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE5,cosq_val_in_dqPE5,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqPE5,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqPE5,v_curr_vec_in_AY_dqPE5,v_curr_vec_in_AZ_dqPE5,v_curr_vec_in_LX_dqPE5,v_curr_vec_in_LY_dqPE5,v_curr_vec_in_LZ_dqPE5,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqPE5,a_curr_vec_in_AY_dqPE5,a_curr_vec_in_AZ_dqPE5,a_curr_vec_in_LX_dqPE5,a_curr_vec_in_LY_dqPE5,a_curr_vec_in_LZ_dqPE5,
   input  signed[(WIDTH-1):0]
      v_prev_vec_in_AX_dqPE5,v_prev_vec_in_AY_dqPE5,v_prev_vec_in_AZ_dqPE5,v_prev_vec_in_LX_dqPE5,v_prev_vec_in_LY_dqPE5,v_prev_vec_in_LZ_dqPE5,
   input  signed[(WIDTH-1):0]
      a_prev_vec_in_AX_dqPE5,a_prev_vec_in_AY_dqPE5,a_prev_vec_in_AZ_dqPE5,a_prev_vec_in_LX_dqPE5,a_prev_vec_in_LY_dqPE5,a_prev_vec_in_LZ_dqPE5,
   input  signed[(WIDTH-1):0]
      dvdq_prev_vec_in_AX_dqPE5,dvdq_prev_vec_in_AY_dqPE5,dvdq_prev_vec_in_AZ_dqPE5,dvdq_prev_vec_in_LX_dqPE5,dvdq_prev_vec_in_LY_dqPE5,dvdq_prev_vec_in_LZ_dqPE5,
   input  signed[(WIDTH-1):0]
      dadq_prev_vec_in_AX_dqPE5,dadq_prev_vec_in_AY_dqPE5,dadq_prev_vec_in_AZ_dqPE5,dadq_prev_vec_in_LX_dqPE5,dadq_prev_vec_in_LY_dqPE5,dadq_prev_vec_in_LZ_dqPE5,
   // dqPE6
   input  [2:0]
      link_in_dqPE6,
   input  [2:0]
      derv_in_dqPE6,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE6,cosq_val_in_dqPE6,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqPE6,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqPE6,v_curr_vec_in_AY_dqPE6,v_curr_vec_in_AZ_dqPE6,v_curr_vec_in_LX_dqPE6,v_curr_vec_in_LY_dqPE6,v_curr_vec_in_LZ_dqPE6,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqPE6,a_curr_vec_in_AY_dqPE6,a_curr_vec_in_AZ_dqPE6,a_curr_vec_in_LX_dqPE6,a_curr_vec_in_LY_dqPE6,a_curr_vec_in_LZ_dqPE6,
   input  signed[(WIDTH-1):0]
      v_prev_vec_in_AX_dqPE6,v_prev_vec_in_AY_dqPE6,v_prev_vec_in_AZ_dqPE6,v_prev_vec_in_LX_dqPE6,v_prev_vec_in_LY_dqPE6,v_prev_vec_in_LZ_dqPE6,
   input  signed[(WIDTH-1):0]
      a_prev_vec_in_AX_dqPE6,a_prev_vec_in_AY_dqPE6,a_prev_vec_in_AZ_dqPE6,a_prev_vec_in_LX_dqPE6,a_prev_vec_in_LY_dqPE6,a_prev_vec_in_LZ_dqPE6,
   input  signed[(WIDTH-1):0]
      dvdq_prev_vec_in_AX_dqPE6,dvdq_prev_vec_in_AY_dqPE6,dvdq_prev_vec_in_AZ_dqPE6,dvdq_prev_vec_in_LX_dqPE6,dvdq_prev_vec_in_LY_dqPE6,dvdq_prev_vec_in_LZ_dqPE6,
   input  signed[(WIDTH-1):0]
      dadq_prev_vec_in_AX_dqPE6,dadq_prev_vec_in_AY_dqPE6,dadq_prev_vec_in_AZ_dqPE6,dadq_prev_vec_in_LX_dqPE6,dadq_prev_vec_in_LY_dqPE6,dadq_prev_vec_in_LZ_dqPE6,
   // dqPE7
   input  [2:0]
      link_in_dqPE7,
   input  [2:0]
      derv_in_dqPE7,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE7,cosq_val_in_dqPE7,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqPE7,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqPE7,v_curr_vec_in_AY_dqPE7,v_curr_vec_in_AZ_dqPE7,v_curr_vec_in_LX_dqPE7,v_curr_vec_in_LY_dqPE7,v_curr_vec_in_LZ_dqPE7,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqPE7,a_curr_vec_in_AY_dqPE7,a_curr_vec_in_AZ_dqPE7,a_curr_vec_in_LX_dqPE7,a_curr_vec_in_LY_dqPE7,a_curr_vec_in_LZ_dqPE7,
   input  signed[(WIDTH-1):0]
      v_prev_vec_in_AX_dqPE7,v_prev_vec_in_AY_dqPE7,v_prev_vec_in_AZ_dqPE7,v_prev_vec_in_LX_dqPE7,v_prev_vec_in_LY_dqPE7,v_prev_vec_in_LZ_dqPE7,
   input  signed[(WIDTH-1):0]
      a_prev_vec_in_AX_dqPE7,a_prev_vec_in_AY_dqPE7,a_prev_vec_in_AZ_dqPE7,a_prev_vec_in_LX_dqPE7,a_prev_vec_in_LY_dqPE7,a_prev_vec_in_LZ_dqPE7,
   input  signed[(WIDTH-1):0]
      dvdq_prev_vec_in_AX_dqPE7,dvdq_prev_vec_in_AY_dqPE7,dvdq_prev_vec_in_AZ_dqPE7,dvdq_prev_vec_in_LX_dqPE7,dvdq_prev_vec_in_LY_dqPE7,dvdq_prev_vec_in_LZ_dqPE7,
   input  signed[(WIDTH-1):0]
      dadq_prev_vec_in_AX_dqPE7,dadq_prev_vec_in_AY_dqPE7,dadq_prev_vec_in_AZ_dqPE7,dadq_prev_vec_in_LX_dqPE7,dadq_prev_vec_in_LY_dqPE7,dadq_prev_vec_in_LZ_dqPE7,
   //---------------------------------------------------------------------------
   // dqd external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   input  [2:0]
      link_in_dqdPE1,
   input  [2:0]
      derv_in_dqdPE1,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE1,cosq_val_in_dqdPE1,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqdPE1,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqdPE1,v_curr_vec_in_AY_dqdPE1,v_curr_vec_in_AZ_dqdPE1,v_curr_vec_in_LX_dqdPE1,v_curr_vec_in_LY_dqdPE1,v_curr_vec_in_LZ_dqdPE1,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqdPE1,a_curr_vec_in_AY_dqdPE1,a_curr_vec_in_AZ_dqdPE1,a_curr_vec_in_LX_dqdPE1,a_curr_vec_in_LY_dqdPE1,a_curr_vec_in_LZ_dqdPE1,
   input  signed[(WIDTH-1):0]
      dvdqd_prev_vec_in_AX_dqdPE1,dvdqd_prev_vec_in_AY_dqdPE1,dvdqd_prev_vec_in_AZ_dqdPE1,dvdqd_prev_vec_in_LX_dqdPE1,dvdqd_prev_vec_in_LY_dqdPE1,dvdqd_prev_vec_in_LZ_dqdPE1,
   input  signed[(WIDTH-1):0]
      dadqd_prev_vec_in_AX_dqdPE1,dadqd_prev_vec_in_AY_dqdPE1,dadqd_prev_vec_in_AZ_dqdPE1,dadqd_prev_vec_in_LX_dqdPE1,dadqd_prev_vec_in_LY_dqdPE1,dadqd_prev_vec_in_LZ_dqdPE1,
   // dqdPE2
   input  [2:0]
      link_in_dqdPE2,
   input  [2:0]
      derv_in_dqdPE2,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE2,cosq_val_in_dqdPE2,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqdPE2,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqdPE2,v_curr_vec_in_AY_dqdPE2,v_curr_vec_in_AZ_dqdPE2,v_curr_vec_in_LX_dqdPE2,v_curr_vec_in_LY_dqdPE2,v_curr_vec_in_LZ_dqdPE2,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqdPE2,a_curr_vec_in_AY_dqdPE2,a_curr_vec_in_AZ_dqdPE2,a_curr_vec_in_LX_dqdPE2,a_curr_vec_in_LY_dqdPE2,a_curr_vec_in_LZ_dqdPE2,
   input  signed[(WIDTH-1):0]
      dvdqd_prev_vec_in_AX_dqdPE2,dvdqd_prev_vec_in_AY_dqdPE2,dvdqd_prev_vec_in_AZ_dqdPE2,dvdqd_prev_vec_in_LX_dqdPE2,dvdqd_prev_vec_in_LY_dqdPE2,dvdqd_prev_vec_in_LZ_dqdPE2,
   input  signed[(WIDTH-1):0]
      dadqd_prev_vec_in_AX_dqdPE2,dadqd_prev_vec_in_AY_dqdPE2,dadqd_prev_vec_in_AZ_dqdPE2,dadqd_prev_vec_in_LX_dqdPE2,dadqd_prev_vec_in_LY_dqdPE2,dadqd_prev_vec_in_LZ_dqdPE2,
   // dqdPE3
   input  [2:0]
      link_in_dqdPE3,
   input  [2:0]
      derv_in_dqdPE3,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE3,cosq_val_in_dqdPE3,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqdPE3,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqdPE3,v_curr_vec_in_AY_dqdPE3,v_curr_vec_in_AZ_dqdPE3,v_curr_vec_in_LX_dqdPE3,v_curr_vec_in_LY_dqdPE3,v_curr_vec_in_LZ_dqdPE3,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqdPE3,a_curr_vec_in_AY_dqdPE3,a_curr_vec_in_AZ_dqdPE3,a_curr_vec_in_LX_dqdPE3,a_curr_vec_in_LY_dqdPE3,a_curr_vec_in_LZ_dqdPE3,
   input  signed[(WIDTH-1):0]
      dvdqd_prev_vec_in_AX_dqdPE3,dvdqd_prev_vec_in_AY_dqdPE3,dvdqd_prev_vec_in_AZ_dqdPE3,dvdqd_prev_vec_in_LX_dqdPE3,dvdqd_prev_vec_in_LY_dqdPE3,dvdqd_prev_vec_in_LZ_dqdPE3,
   input  signed[(WIDTH-1):0]
      dadqd_prev_vec_in_AX_dqdPE3,dadqd_prev_vec_in_AY_dqdPE3,dadqd_prev_vec_in_AZ_dqdPE3,dadqd_prev_vec_in_LX_dqdPE3,dadqd_prev_vec_in_LY_dqdPE3,dadqd_prev_vec_in_LZ_dqdPE3,
   // dqdPE4
   input  [2:0]
      link_in_dqdPE4,
   input  [2:0]
      derv_in_dqdPE4,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE4,cosq_val_in_dqdPE4,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqdPE4,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqdPE4,v_curr_vec_in_AY_dqdPE4,v_curr_vec_in_AZ_dqdPE4,v_curr_vec_in_LX_dqdPE4,v_curr_vec_in_LY_dqdPE4,v_curr_vec_in_LZ_dqdPE4,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqdPE4,a_curr_vec_in_AY_dqdPE4,a_curr_vec_in_AZ_dqdPE4,a_curr_vec_in_LX_dqdPE4,a_curr_vec_in_LY_dqdPE4,a_curr_vec_in_LZ_dqdPE4,
   input  signed[(WIDTH-1):0]
      dvdqd_prev_vec_in_AX_dqdPE4,dvdqd_prev_vec_in_AY_dqdPE4,dvdqd_prev_vec_in_AZ_dqdPE4,dvdqd_prev_vec_in_LX_dqdPE4,dvdqd_prev_vec_in_LY_dqdPE4,dvdqd_prev_vec_in_LZ_dqdPE4,
   input  signed[(WIDTH-1):0]
      dadqd_prev_vec_in_AX_dqdPE4,dadqd_prev_vec_in_AY_dqdPE4,dadqd_prev_vec_in_AZ_dqdPE4,dadqd_prev_vec_in_LX_dqdPE4,dadqd_prev_vec_in_LY_dqdPE4,dadqd_prev_vec_in_LZ_dqdPE4,
   // dqdPE5
   input  [2:0]
      link_in_dqdPE5,
   input  [2:0]
      derv_in_dqdPE5,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE5,cosq_val_in_dqdPE5,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqdPE5,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqdPE5,v_curr_vec_in_AY_dqdPE5,v_curr_vec_in_AZ_dqdPE5,v_curr_vec_in_LX_dqdPE5,v_curr_vec_in_LY_dqdPE5,v_curr_vec_in_LZ_dqdPE5,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqdPE5,a_curr_vec_in_AY_dqdPE5,a_curr_vec_in_AZ_dqdPE5,a_curr_vec_in_LX_dqdPE5,a_curr_vec_in_LY_dqdPE5,a_curr_vec_in_LZ_dqdPE5,
   input  signed[(WIDTH-1):0]
      dvdqd_prev_vec_in_AX_dqdPE5,dvdqd_prev_vec_in_AY_dqdPE5,dvdqd_prev_vec_in_AZ_dqdPE5,dvdqd_prev_vec_in_LX_dqdPE5,dvdqd_prev_vec_in_LY_dqdPE5,dvdqd_prev_vec_in_LZ_dqdPE5,
   input  signed[(WIDTH-1):0]
      dadqd_prev_vec_in_AX_dqdPE5,dadqd_prev_vec_in_AY_dqdPE5,dadqd_prev_vec_in_AZ_dqdPE5,dadqd_prev_vec_in_LX_dqdPE5,dadqd_prev_vec_in_LY_dqdPE5,dadqd_prev_vec_in_LZ_dqdPE5,
   // dqdPE6
   input  [2:0]
      link_in_dqdPE6,
   input  [2:0]
      derv_in_dqdPE6,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE6,cosq_val_in_dqdPE6,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqdPE6,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqdPE6,v_curr_vec_in_AY_dqdPE6,v_curr_vec_in_AZ_dqdPE6,v_curr_vec_in_LX_dqdPE6,v_curr_vec_in_LY_dqdPE6,v_curr_vec_in_LZ_dqdPE6,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqdPE6,a_curr_vec_in_AY_dqdPE6,a_curr_vec_in_AZ_dqdPE6,a_curr_vec_in_LX_dqdPE6,a_curr_vec_in_LY_dqdPE6,a_curr_vec_in_LZ_dqdPE6,
   input  signed[(WIDTH-1):0]
      dvdqd_prev_vec_in_AX_dqdPE6,dvdqd_prev_vec_in_AY_dqdPE6,dvdqd_prev_vec_in_AZ_dqdPE6,dvdqd_prev_vec_in_LX_dqdPE6,dvdqd_prev_vec_in_LY_dqdPE6,dvdqd_prev_vec_in_LZ_dqdPE6,
   input  signed[(WIDTH-1):0]
      dadqd_prev_vec_in_AX_dqdPE6,dadqd_prev_vec_in_AY_dqdPE6,dadqd_prev_vec_in_AZ_dqdPE6,dadqd_prev_vec_in_LX_dqdPE6,dadqd_prev_vec_in_LY_dqdPE6,dadqd_prev_vec_in_LZ_dqdPE6,
   // dqdPE7
   input  [2:0]
      link_in_dqdPE7,
   input  [2:0]
      derv_in_dqdPE7,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE7,cosq_val_in_dqdPE7,
   input  signed[(WIDTH-1):0]
      qd_val_in_dqdPE7,
   input  signed[(WIDTH-1):0]
      v_curr_vec_in_AX_dqdPE7,v_curr_vec_in_AY_dqdPE7,v_curr_vec_in_AZ_dqdPE7,v_curr_vec_in_LX_dqdPE7,v_curr_vec_in_LY_dqdPE7,v_curr_vec_in_LZ_dqdPE7,
   input  signed[(WIDTH-1):0]
      a_curr_vec_in_AX_dqdPE7,a_curr_vec_in_AY_dqdPE7,a_curr_vec_in_AZ_dqdPE7,a_curr_vec_in_LX_dqdPE7,a_curr_vec_in_LY_dqdPE7,a_curr_vec_in_LZ_dqdPE7,
   input  signed[(WIDTH-1):0]
      dvdqd_prev_vec_in_AX_dqdPE7,dvdqd_prev_vec_in_AY_dqdPE7,dvdqd_prev_vec_in_AZ_dqdPE7,dvdqd_prev_vec_in_LX_dqdPE7,dvdqd_prev_vec_in_LY_dqdPE7,dvdqd_prev_vec_in_LZ_dqdPE7,
   input  signed[(WIDTH-1):0]
      dadqd_prev_vec_in_AX_dqdPE7,dadqd_prev_vec_in_AY_dqdPE7,dadqd_prev_vec_in_AZ_dqdPE7,dadqd_prev_vec_in_LX_dqdPE7,dadqd_prev_vec_in_LY_dqdPE7,dadqd_prev_vec_in_LZ_dqdPE7,
   //---------------------------------------------------------------------------
   // output_ready
   output output_ready,
   // dummy_output
   output dummy_output,
   //---------------------------------------------------------------------------
   // rnea external outputs
   //---------------------------------------------------------------------------
   // rnea
   output signed[(WIDTH-1):0]
      v_curr_vec_out_AX_rnea,v_curr_vec_out_AY_rnea,v_curr_vec_out_AZ_rnea,v_curr_vec_out_LX_rnea,v_curr_vec_out_LY_rnea,v_curr_vec_out_LZ_rnea,
   output  signed[(WIDTH-1):0]
      a_curr_vec_out_AX_rnea,a_curr_vec_out_AY_rnea,a_curr_vec_out_AZ_rnea,a_curr_vec_out_LX_rnea,a_curr_vec_out_LY_rnea,a_curr_vec_out_LZ_rnea,
   output signed[(WIDTH-1):0]
      f_curr_vec_out_AX_rnea,f_curr_vec_out_AY_rnea,f_curr_vec_out_AZ_rnea,f_curr_vec_out_LX_rnea,f_curr_vec_out_LY_rnea,f_curr_vec_out_LZ_rnea,
   //---------------------------------------------------------------------------
   // dq external outputs
   //---------------------------------------------------------------------------
   // dqPE1
   output signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE1,dvdq_curr_vec_out_AY_dqPE1,dvdq_curr_vec_out_AZ_dqPE1,dvdq_curr_vec_out_LX_dqPE1,dvdq_curr_vec_out_LY_dqPE1,dvdq_curr_vec_out_LZ_dqPE1,
      dadq_curr_vec_out_AX_dqPE1,dadq_curr_vec_out_AY_dqPE1,dadq_curr_vec_out_AZ_dqPE1,dadq_curr_vec_out_LX_dqPE1,dadq_curr_vec_out_LY_dqPE1,dadq_curr_vec_out_LZ_dqPE1,
      dfdq_curr_vec_out_AX_dqPE1,dfdq_curr_vec_out_AY_dqPE1,dfdq_curr_vec_out_AZ_dqPE1,dfdq_curr_vec_out_LX_dqPE1,dfdq_curr_vec_out_LY_dqPE1,dfdq_curr_vec_out_LZ_dqPE1,
   // dqPE2
   output signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE2,dvdq_curr_vec_out_AY_dqPE2,dvdq_curr_vec_out_AZ_dqPE2,dvdq_curr_vec_out_LX_dqPE2,dvdq_curr_vec_out_LY_dqPE2,dvdq_curr_vec_out_LZ_dqPE2,
      dadq_curr_vec_out_AX_dqPE2,dadq_curr_vec_out_AY_dqPE2,dadq_curr_vec_out_AZ_dqPE2,dadq_curr_vec_out_LX_dqPE2,dadq_curr_vec_out_LY_dqPE2,dadq_curr_vec_out_LZ_dqPE2,
      dfdq_curr_vec_out_AX_dqPE2,dfdq_curr_vec_out_AY_dqPE2,dfdq_curr_vec_out_AZ_dqPE2,dfdq_curr_vec_out_LX_dqPE2,dfdq_curr_vec_out_LY_dqPE2,dfdq_curr_vec_out_LZ_dqPE2,
   // dqPE3
   output signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE3,dvdq_curr_vec_out_AY_dqPE3,dvdq_curr_vec_out_AZ_dqPE3,dvdq_curr_vec_out_LX_dqPE3,dvdq_curr_vec_out_LY_dqPE3,dvdq_curr_vec_out_LZ_dqPE3,
      dadq_curr_vec_out_AX_dqPE3,dadq_curr_vec_out_AY_dqPE3,dadq_curr_vec_out_AZ_dqPE3,dadq_curr_vec_out_LX_dqPE3,dadq_curr_vec_out_LY_dqPE3,dadq_curr_vec_out_LZ_dqPE3,
      dfdq_curr_vec_out_AX_dqPE3,dfdq_curr_vec_out_AY_dqPE3,dfdq_curr_vec_out_AZ_dqPE3,dfdq_curr_vec_out_LX_dqPE3,dfdq_curr_vec_out_LY_dqPE3,dfdq_curr_vec_out_LZ_dqPE3,
   // dqPE4
   output signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE4,dvdq_curr_vec_out_AY_dqPE4,dvdq_curr_vec_out_AZ_dqPE4,dvdq_curr_vec_out_LX_dqPE4,dvdq_curr_vec_out_LY_dqPE4,dvdq_curr_vec_out_LZ_dqPE4,
      dadq_curr_vec_out_AX_dqPE4,dadq_curr_vec_out_AY_dqPE4,dadq_curr_vec_out_AZ_dqPE4,dadq_curr_vec_out_LX_dqPE4,dadq_curr_vec_out_LY_dqPE4,dadq_curr_vec_out_LZ_dqPE4,
      dfdq_curr_vec_out_AX_dqPE4,dfdq_curr_vec_out_AY_dqPE4,dfdq_curr_vec_out_AZ_dqPE4,dfdq_curr_vec_out_LX_dqPE4,dfdq_curr_vec_out_LY_dqPE4,dfdq_curr_vec_out_LZ_dqPE4,
   // dqPE5
   output signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE5,dvdq_curr_vec_out_AY_dqPE5,dvdq_curr_vec_out_AZ_dqPE5,dvdq_curr_vec_out_LX_dqPE5,dvdq_curr_vec_out_LY_dqPE5,dvdq_curr_vec_out_LZ_dqPE5,
      dadq_curr_vec_out_AX_dqPE5,dadq_curr_vec_out_AY_dqPE5,dadq_curr_vec_out_AZ_dqPE5,dadq_curr_vec_out_LX_dqPE5,dadq_curr_vec_out_LY_dqPE5,dadq_curr_vec_out_LZ_dqPE5,
      dfdq_curr_vec_out_AX_dqPE5,dfdq_curr_vec_out_AY_dqPE5,dfdq_curr_vec_out_AZ_dqPE5,dfdq_curr_vec_out_LX_dqPE5,dfdq_curr_vec_out_LY_dqPE5,dfdq_curr_vec_out_LZ_dqPE5,
   // dqPE6
   output signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE6,dvdq_curr_vec_out_AY_dqPE6,dvdq_curr_vec_out_AZ_dqPE6,dvdq_curr_vec_out_LX_dqPE6,dvdq_curr_vec_out_LY_dqPE6,dvdq_curr_vec_out_LZ_dqPE6,
      dadq_curr_vec_out_AX_dqPE6,dadq_curr_vec_out_AY_dqPE6,dadq_curr_vec_out_AZ_dqPE6,dadq_curr_vec_out_LX_dqPE6,dadq_curr_vec_out_LY_dqPE6,dadq_curr_vec_out_LZ_dqPE6,
      dfdq_curr_vec_out_AX_dqPE6,dfdq_curr_vec_out_AY_dqPE6,dfdq_curr_vec_out_AZ_dqPE6,dfdq_curr_vec_out_LX_dqPE6,dfdq_curr_vec_out_LY_dqPE6,dfdq_curr_vec_out_LZ_dqPE6,
   // dqPE7
   output signed[(WIDTH-1):0]
      dvdq_curr_vec_out_AX_dqPE7,dvdq_curr_vec_out_AY_dqPE7,dvdq_curr_vec_out_AZ_dqPE7,dvdq_curr_vec_out_LX_dqPE7,dvdq_curr_vec_out_LY_dqPE7,dvdq_curr_vec_out_LZ_dqPE7,
      dadq_curr_vec_out_AX_dqPE7,dadq_curr_vec_out_AY_dqPE7,dadq_curr_vec_out_AZ_dqPE7,dadq_curr_vec_out_LX_dqPE7,dadq_curr_vec_out_LY_dqPE7,dadq_curr_vec_out_LZ_dqPE7,
      dfdq_curr_vec_out_AX_dqPE7,dfdq_curr_vec_out_AY_dqPE7,dfdq_curr_vec_out_AZ_dqPE7,dfdq_curr_vec_out_LX_dqPE7,dfdq_curr_vec_out_LY_dqPE7,dfdq_curr_vec_out_LZ_dqPE7,
   //---------------------------------------------------------------------------
   // dqd external outputs
   //---------------------------------------------------------------------------
   // dqdPE1
   output signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE1,dvdqd_curr_vec_out_AY_dqdPE1,dvdqd_curr_vec_out_AZ_dqdPE1,dvdqd_curr_vec_out_LX_dqdPE1,dvdqd_curr_vec_out_LY_dqdPE1,dvdqd_curr_vec_out_LZ_dqdPE1,
      dadqd_curr_vec_out_AX_dqdPE1,dadqd_curr_vec_out_AY_dqdPE1,dadqd_curr_vec_out_AZ_dqdPE1,dadqd_curr_vec_out_LX_dqdPE1,dadqd_curr_vec_out_LY_dqdPE1,dadqd_curr_vec_out_LZ_dqdPE1,
      dfdqd_curr_vec_out_AX_dqdPE1,dfdqd_curr_vec_out_AY_dqdPE1,dfdqd_curr_vec_out_AZ_dqdPE1,dfdqd_curr_vec_out_LX_dqdPE1,dfdqd_curr_vec_out_LY_dqdPE1,dfdqd_curr_vec_out_LZ_dqdPE1,
   // dqdPE2
   output signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE2,dvdqd_curr_vec_out_AY_dqdPE2,dvdqd_curr_vec_out_AZ_dqdPE2,dvdqd_curr_vec_out_LX_dqdPE2,dvdqd_curr_vec_out_LY_dqdPE2,dvdqd_curr_vec_out_LZ_dqdPE2,
      dadqd_curr_vec_out_AX_dqdPE2,dadqd_curr_vec_out_AY_dqdPE2,dadqd_curr_vec_out_AZ_dqdPE2,dadqd_curr_vec_out_LX_dqdPE2,dadqd_curr_vec_out_LY_dqdPE2,dadqd_curr_vec_out_LZ_dqdPE2,
      dfdqd_curr_vec_out_AX_dqdPE2,dfdqd_curr_vec_out_AY_dqdPE2,dfdqd_curr_vec_out_AZ_dqdPE2,dfdqd_curr_vec_out_LX_dqdPE2,dfdqd_curr_vec_out_LY_dqdPE2,dfdqd_curr_vec_out_LZ_dqdPE2,
   // dqdPE3
   output signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE3,dvdqd_curr_vec_out_AY_dqdPE3,dvdqd_curr_vec_out_AZ_dqdPE3,dvdqd_curr_vec_out_LX_dqdPE3,dvdqd_curr_vec_out_LY_dqdPE3,dvdqd_curr_vec_out_LZ_dqdPE3,
      dadqd_curr_vec_out_AX_dqdPE3,dadqd_curr_vec_out_AY_dqdPE3,dadqd_curr_vec_out_AZ_dqdPE3,dadqd_curr_vec_out_LX_dqdPE3,dadqd_curr_vec_out_LY_dqdPE3,dadqd_curr_vec_out_LZ_dqdPE3,
      dfdqd_curr_vec_out_AX_dqdPE3,dfdqd_curr_vec_out_AY_dqdPE3,dfdqd_curr_vec_out_AZ_dqdPE3,dfdqd_curr_vec_out_LX_dqdPE3,dfdqd_curr_vec_out_LY_dqdPE3,dfdqd_curr_vec_out_LZ_dqdPE3,
   // dqdPE4
   output signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE4,dvdqd_curr_vec_out_AY_dqdPE4,dvdqd_curr_vec_out_AZ_dqdPE4,dvdqd_curr_vec_out_LX_dqdPE4,dvdqd_curr_vec_out_LY_dqdPE4,dvdqd_curr_vec_out_LZ_dqdPE4,
      dadqd_curr_vec_out_AX_dqdPE4,dadqd_curr_vec_out_AY_dqdPE4,dadqd_curr_vec_out_AZ_dqdPE4,dadqd_curr_vec_out_LX_dqdPE4,dadqd_curr_vec_out_LY_dqdPE4,dadqd_curr_vec_out_LZ_dqdPE4,
      dfdqd_curr_vec_out_AX_dqdPE4,dfdqd_curr_vec_out_AY_dqdPE4,dfdqd_curr_vec_out_AZ_dqdPE4,dfdqd_curr_vec_out_LX_dqdPE4,dfdqd_curr_vec_out_LY_dqdPE4,dfdqd_curr_vec_out_LZ_dqdPE4,
   // dqdPE5
   output signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE5,dvdqd_curr_vec_out_AY_dqdPE5,dvdqd_curr_vec_out_AZ_dqdPE5,dvdqd_curr_vec_out_LX_dqdPE5,dvdqd_curr_vec_out_LY_dqdPE5,dvdqd_curr_vec_out_LZ_dqdPE5,
      dadqd_curr_vec_out_AX_dqdPE5,dadqd_curr_vec_out_AY_dqdPE5,dadqd_curr_vec_out_AZ_dqdPE5,dadqd_curr_vec_out_LX_dqdPE5,dadqd_curr_vec_out_LY_dqdPE5,dadqd_curr_vec_out_LZ_dqdPE5,
      dfdqd_curr_vec_out_AX_dqdPE5,dfdqd_curr_vec_out_AY_dqdPE5,dfdqd_curr_vec_out_AZ_dqdPE5,dfdqd_curr_vec_out_LX_dqdPE5,dfdqd_curr_vec_out_LY_dqdPE5,dfdqd_curr_vec_out_LZ_dqdPE5,
   // dqdPE6
   output signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE6,dvdqd_curr_vec_out_AY_dqdPE6,dvdqd_curr_vec_out_AZ_dqdPE6,dvdqd_curr_vec_out_LX_dqdPE6,dvdqd_curr_vec_out_LY_dqdPE6,dvdqd_curr_vec_out_LZ_dqdPE6,
      dadqd_curr_vec_out_AX_dqdPE6,dadqd_curr_vec_out_AY_dqdPE6,dadqd_curr_vec_out_AZ_dqdPE6,dadqd_curr_vec_out_LX_dqdPE6,dadqd_curr_vec_out_LY_dqdPE6,dadqd_curr_vec_out_LZ_dqdPE6,
      dfdqd_curr_vec_out_AX_dqdPE6,dfdqd_curr_vec_out_AY_dqdPE6,dfdqd_curr_vec_out_AZ_dqdPE6,dfdqd_curr_vec_out_LX_dqdPE6,dfdqd_curr_vec_out_LY_dqdPE6,dfdqd_curr_vec_out_LZ_dqdPE6,
   // dqdPE7
   output signed[(WIDTH-1):0]
      dvdqd_curr_vec_out_AX_dqdPE7,dvdqd_curr_vec_out_AY_dqdPE7,dvdqd_curr_vec_out_AZ_dqdPE7,dvdqd_curr_vec_out_LX_dqdPE7,dvdqd_curr_vec_out_LY_dqdPE7,dvdqd_curr_vec_out_LZ_dqdPE7,
      dadqd_curr_vec_out_AX_dqdPE7,dadqd_curr_vec_out_AY_dqdPE7,dadqd_curr_vec_out_AZ_dqdPE7,dadqd_curr_vec_out_LX_dqdPE7,dadqd_curr_vec_out_LY_dqdPE7,dadqd_curr_vec_out_LZ_dqdPE7,
      dfdqd_curr_vec_out_AX_dqdPE7,dfdqd_curr_vec_out_AY_dqdPE7,dfdqd_curr_vec_out_AZ_dqdPE7,dfdqd_curr_vec_out_LX_dqdPE7,dfdqd_curr_vec_out_LY_dqdPE7,dfdqd_curr_vec_out_LZ_dqdPE7
   //---------------------------------------------------------------------------
   );

   //---------------------------------------------------------------------------
   // external wires and state
   //---------------------------------------------------------------------------
   // registers
   reg get_data_reg;
   reg output_ready_reg;
   reg dummy_output_reg;
   reg [2:0]
      state_reg;
   reg s1_bool_reg,s2_bool_reg,s3_bool_reg;
   //---------------------------------------------------------------------------
   // rnea external inputs
   //---------------------------------------------------------------------------
   // rnea
   reg [2:0]
      link_reg_rnea;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_rnea,cosq_val_reg_rnea,
      qd_val_reg_rnea,
      qdd_val_reg_rnea,
      v_prev_vec_reg_AX_rnea,v_prev_vec_reg_AY_rnea,v_prev_vec_reg_AZ_rnea,v_prev_vec_reg_LX_rnea,v_prev_vec_reg_LY_rnea,v_prev_vec_reg_LZ_rnea,
      a_prev_vec_reg_AX_rnea,a_prev_vec_reg_AY_rnea,a_prev_vec_reg_AZ_rnea,a_prev_vec_reg_LX_rnea,a_prev_vec_reg_LY_rnea,a_prev_vec_reg_LZ_rnea;
   //---------------------------------------------------------------------------
   // dq external inputs
   //---------------------------------------------------------------------------
   // dqPE1
   reg [2:0]
      link_reg_dqPE1;
   reg [2:0]
      derv_reg_dqPE1;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE1,cosq_val_reg_dqPE1,
      qd_val_reg_dqPE1,
      v_curr_vec_reg_AX_dqPE1,v_curr_vec_reg_AY_dqPE1,v_curr_vec_reg_AZ_dqPE1,v_curr_vec_reg_LX_dqPE1,v_curr_vec_reg_LY_dqPE1,v_curr_vec_reg_LZ_dqPE1,
      a_curr_vec_reg_AX_dqPE1,a_curr_vec_reg_AY_dqPE1,a_curr_vec_reg_AZ_dqPE1,a_curr_vec_reg_LX_dqPE1,a_curr_vec_reg_LY_dqPE1,a_curr_vec_reg_LZ_dqPE1,
      v_prev_vec_reg_AX_dqPE1,v_prev_vec_reg_AY_dqPE1,v_prev_vec_reg_AZ_dqPE1,v_prev_vec_reg_LX_dqPE1,v_prev_vec_reg_LY_dqPE1,v_prev_vec_reg_LZ_dqPE1,
      a_prev_vec_reg_AX_dqPE1,a_prev_vec_reg_AY_dqPE1,a_prev_vec_reg_AZ_dqPE1,a_prev_vec_reg_LX_dqPE1,a_prev_vec_reg_LY_dqPE1,a_prev_vec_reg_LZ_dqPE1,
      dvdq_prev_vec_reg_AX_dqPE1,dvdq_prev_vec_reg_AY_dqPE1,dvdq_prev_vec_reg_AZ_dqPE1,dvdq_prev_vec_reg_LX_dqPE1,dvdq_prev_vec_reg_LY_dqPE1,dvdq_prev_vec_reg_LZ_dqPE1,
      dadq_prev_vec_reg_AX_dqPE1,dadq_prev_vec_reg_AY_dqPE1,dadq_prev_vec_reg_AZ_dqPE1,dadq_prev_vec_reg_LX_dqPE1,dadq_prev_vec_reg_LY_dqPE1,dadq_prev_vec_reg_LZ_dqPE1;
   // dqPE2
   reg [2:0]
      link_reg_dqPE2;
   reg [2:0]
      derv_reg_dqPE2;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE2,cosq_val_reg_dqPE2,
      qd_val_reg_dqPE2,
      v_curr_vec_reg_AX_dqPE2,v_curr_vec_reg_AY_dqPE2,v_curr_vec_reg_AZ_dqPE2,v_curr_vec_reg_LX_dqPE2,v_curr_vec_reg_LY_dqPE2,v_curr_vec_reg_LZ_dqPE2,
      a_curr_vec_reg_AX_dqPE2,a_curr_vec_reg_AY_dqPE2,a_curr_vec_reg_AZ_dqPE2,a_curr_vec_reg_LX_dqPE2,a_curr_vec_reg_LY_dqPE2,a_curr_vec_reg_LZ_dqPE2,
      v_prev_vec_reg_AX_dqPE2,v_prev_vec_reg_AY_dqPE2,v_prev_vec_reg_AZ_dqPE2,v_prev_vec_reg_LX_dqPE2,v_prev_vec_reg_LY_dqPE2,v_prev_vec_reg_LZ_dqPE2,
      a_prev_vec_reg_AX_dqPE2,a_prev_vec_reg_AY_dqPE2,a_prev_vec_reg_AZ_dqPE2,a_prev_vec_reg_LX_dqPE2,a_prev_vec_reg_LY_dqPE2,a_prev_vec_reg_LZ_dqPE2,
      dvdq_prev_vec_reg_AX_dqPE2,dvdq_prev_vec_reg_AY_dqPE2,dvdq_prev_vec_reg_AZ_dqPE2,dvdq_prev_vec_reg_LX_dqPE2,dvdq_prev_vec_reg_LY_dqPE2,dvdq_prev_vec_reg_LZ_dqPE2,
      dadq_prev_vec_reg_AX_dqPE2,dadq_prev_vec_reg_AY_dqPE2,dadq_prev_vec_reg_AZ_dqPE2,dadq_prev_vec_reg_LX_dqPE2,dadq_prev_vec_reg_LY_dqPE2,dadq_prev_vec_reg_LZ_dqPE2;
   // dqPE3
   reg [2:0]
      link_reg_dqPE3;
   reg [2:0]
      derv_reg_dqPE3;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE3,cosq_val_reg_dqPE3,
      qd_val_reg_dqPE3,
      v_curr_vec_reg_AX_dqPE3,v_curr_vec_reg_AY_dqPE3,v_curr_vec_reg_AZ_dqPE3,v_curr_vec_reg_LX_dqPE3,v_curr_vec_reg_LY_dqPE3,v_curr_vec_reg_LZ_dqPE3,
      a_curr_vec_reg_AX_dqPE3,a_curr_vec_reg_AY_dqPE3,a_curr_vec_reg_AZ_dqPE3,a_curr_vec_reg_LX_dqPE3,a_curr_vec_reg_LY_dqPE3,a_curr_vec_reg_LZ_dqPE3,
      v_prev_vec_reg_AX_dqPE3,v_prev_vec_reg_AY_dqPE3,v_prev_vec_reg_AZ_dqPE3,v_prev_vec_reg_LX_dqPE3,v_prev_vec_reg_LY_dqPE3,v_prev_vec_reg_LZ_dqPE3,
      a_prev_vec_reg_AX_dqPE3,a_prev_vec_reg_AY_dqPE3,a_prev_vec_reg_AZ_dqPE3,a_prev_vec_reg_LX_dqPE3,a_prev_vec_reg_LY_dqPE3,a_prev_vec_reg_LZ_dqPE3,
      dvdq_prev_vec_reg_AX_dqPE3,dvdq_prev_vec_reg_AY_dqPE3,dvdq_prev_vec_reg_AZ_dqPE3,dvdq_prev_vec_reg_LX_dqPE3,dvdq_prev_vec_reg_LY_dqPE3,dvdq_prev_vec_reg_LZ_dqPE3,
      dadq_prev_vec_reg_AX_dqPE3,dadq_prev_vec_reg_AY_dqPE3,dadq_prev_vec_reg_AZ_dqPE3,dadq_prev_vec_reg_LX_dqPE3,dadq_prev_vec_reg_LY_dqPE3,dadq_prev_vec_reg_LZ_dqPE3;
   // dqPE4
   reg [2:0]
      link_reg_dqPE4;
   reg [2:0]
      derv_reg_dqPE4;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE4,cosq_val_reg_dqPE4,
      qd_val_reg_dqPE4,
      v_curr_vec_reg_AX_dqPE4,v_curr_vec_reg_AY_dqPE4,v_curr_vec_reg_AZ_dqPE4,v_curr_vec_reg_LX_dqPE4,v_curr_vec_reg_LY_dqPE4,v_curr_vec_reg_LZ_dqPE4,
      a_curr_vec_reg_AX_dqPE4,a_curr_vec_reg_AY_dqPE4,a_curr_vec_reg_AZ_dqPE4,a_curr_vec_reg_LX_dqPE4,a_curr_vec_reg_LY_dqPE4,a_curr_vec_reg_LZ_dqPE4,
      v_prev_vec_reg_AX_dqPE4,v_prev_vec_reg_AY_dqPE4,v_prev_vec_reg_AZ_dqPE4,v_prev_vec_reg_LX_dqPE4,v_prev_vec_reg_LY_dqPE4,v_prev_vec_reg_LZ_dqPE4,
      a_prev_vec_reg_AX_dqPE4,a_prev_vec_reg_AY_dqPE4,a_prev_vec_reg_AZ_dqPE4,a_prev_vec_reg_LX_dqPE4,a_prev_vec_reg_LY_dqPE4,a_prev_vec_reg_LZ_dqPE4,
      dvdq_prev_vec_reg_AX_dqPE4,dvdq_prev_vec_reg_AY_dqPE4,dvdq_prev_vec_reg_AZ_dqPE4,dvdq_prev_vec_reg_LX_dqPE4,dvdq_prev_vec_reg_LY_dqPE4,dvdq_prev_vec_reg_LZ_dqPE4,
      dadq_prev_vec_reg_AX_dqPE4,dadq_prev_vec_reg_AY_dqPE4,dadq_prev_vec_reg_AZ_dqPE4,dadq_prev_vec_reg_LX_dqPE4,dadq_prev_vec_reg_LY_dqPE4,dadq_prev_vec_reg_LZ_dqPE4;
   // dqPE5
   reg [2:0]
      link_reg_dqPE5;
   reg [2:0]
      derv_reg_dqPE5;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE5,cosq_val_reg_dqPE5,
      qd_val_reg_dqPE5,
      v_curr_vec_reg_AX_dqPE5,v_curr_vec_reg_AY_dqPE5,v_curr_vec_reg_AZ_dqPE5,v_curr_vec_reg_LX_dqPE5,v_curr_vec_reg_LY_dqPE5,v_curr_vec_reg_LZ_dqPE5,
      a_curr_vec_reg_AX_dqPE5,a_curr_vec_reg_AY_dqPE5,a_curr_vec_reg_AZ_dqPE5,a_curr_vec_reg_LX_dqPE5,a_curr_vec_reg_LY_dqPE5,a_curr_vec_reg_LZ_dqPE5,
      v_prev_vec_reg_AX_dqPE5,v_prev_vec_reg_AY_dqPE5,v_prev_vec_reg_AZ_dqPE5,v_prev_vec_reg_LX_dqPE5,v_prev_vec_reg_LY_dqPE5,v_prev_vec_reg_LZ_dqPE5,
      a_prev_vec_reg_AX_dqPE5,a_prev_vec_reg_AY_dqPE5,a_prev_vec_reg_AZ_dqPE5,a_prev_vec_reg_LX_dqPE5,a_prev_vec_reg_LY_dqPE5,a_prev_vec_reg_LZ_dqPE5,
      dvdq_prev_vec_reg_AX_dqPE5,dvdq_prev_vec_reg_AY_dqPE5,dvdq_prev_vec_reg_AZ_dqPE5,dvdq_prev_vec_reg_LX_dqPE5,dvdq_prev_vec_reg_LY_dqPE5,dvdq_prev_vec_reg_LZ_dqPE5,
      dadq_prev_vec_reg_AX_dqPE5,dadq_prev_vec_reg_AY_dqPE5,dadq_prev_vec_reg_AZ_dqPE5,dadq_prev_vec_reg_LX_dqPE5,dadq_prev_vec_reg_LY_dqPE5,dadq_prev_vec_reg_LZ_dqPE5;
   // dqPE6
   reg [2:0]
      link_reg_dqPE6;
   reg [2:0]
      derv_reg_dqPE6;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE6,cosq_val_reg_dqPE6,
      qd_val_reg_dqPE6,
      v_curr_vec_reg_AX_dqPE6,v_curr_vec_reg_AY_dqPE6,v_curr_vec_reg_AZ_dqPE6,v_curr_vec_reg_LX_dqPE6,v_curr_vec_reg_LY_dqPE6,v_curr_vec_reg_LZ_dqPE6,
      a_curr_vec_reg_AX_dqPE6,a_curr_vec_reg_AY_dqPE6,a_curr_vec_reg_AZ_dqPE6,a_curr_vec_reg_LX_dqPE6,a_curr_vec_reg_LY_dqPE6,a_curr_vec_reg_LZ_dqPE6,
      v_prev_vec_reg_AX_dqPE6,v_prev_vec_reg_AY_dqPE6,v_prev_vec_reg_AZ_dqPE6,v_prev_vec_reg_LX_dqPE6,v_prev_vec_reg_LY_dqPE6,v_prev_vec_reg_LZ_dqPE6,
      a_prev_vec_reg_AX_dqPE6,a_prev_vec_reg_AY_dqPE6,a_prev_vec_reg_AZ_dqPE6,a_prev_vec_reg_LX_dqPE6,a_prev_vec_reg_LY_dqPE6,a_prev_vec_reg_LZ_dqPE6,
      dvdq_prev_vec_reg_AX_dqPE6,dvdq_prev_vec_reg_AY_dqPE6,dvdq_prev_vec_reg_AZ_dqPE6,dvdq_prev_vec_reg_LX_dqPE6,dvdq_prev_vec_reg_LY_dqPE6,dvdq_prev_vec_reg_LZ_dqPE6,
      dadq_prev_vec_reg_AX_dqPE6,dadq_prev_vec_reg_AY_dqPE6,dadq_prev_vec_reg_AZ_dqPE6,dadq_prev_vec_reg_LX_dqPE6,dadq_prev_vec_reg_LY_dqPE6,dadq_prev_vec_reg_LZ_dqPE6;
   // dqPE7
   reg [2:0]
      link_reg_dqPE7;
   reg [2:0]
      derv_reg_dqPE7;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE7,cosq_val_reg_dqPE7,
      qd_val_reg_dqPE7,
      v_curr_vec_reg_AX_dqPE7,v_curr_vec_reg_AY_dqPE7,v_curr_vec_reg_AZ_dqPE7,v_curr_vec_reg_LX_dqPE7,v_curr_vec_reg_LY_dqPE7,v_curr_vec_reg_LZ_dqPE7,
      a_curr_vec_reg_AX_dqPE7,a_curr_vec_reg_AY_dqPE7,a_curr_vec_reg_AZ_dqPE7,a_curr_vec_reg_LX_dqPE7,a_curr_vec_reg_LY_dqPE7,a_curr_vec_reg_LZ_dqPE7,
      v_prev_vec_reg_AX_dqPE7,v_prev_vec_reg_AY_dqPE7,v_prev_vec_reg_AZ_dqPE7,v_prev_vec_reg_LX_dqPE7,v_prev_vec_reg_LY_dqPE7,v_prev_vec_reg_LZ_dqPE7,
      a_prev_vec_reg_AX_dqPE7,a_prev_vec_reg_AY_dqPE7,a_prev_vec_reg_AZ_dqPE7,a_prev_vec_reg_LX_dqPE7,a_prev_vec_reg_LY_dqPE7,a_prev_vec_reg_LZ_dqPE7,
      dvdq_prev_vec_reg_AX_dqPE7,dvdq_prev_vec_reg_AY_dqPE7,dvdq_prev_vec_reg_AZ_dqPE7,dvdq_prev_vec_reg_LX_dqPE7,dvdq_prev_vec_reg_LY_dqPE7,dvdq_prev_vec_reg_LZ_dqPE7,
      dadq_prev_vec_reg_AX_dqPE7,dadq_prev_vec_reg_AY_dqPE7,dadq_prev_vec_reg_AZ_dqPE7,dadq_prev_vec_reg_LX_dqPE7,dadq_prev_vec_reg_LY_dqPE7,dadq_prev_vec_reg_LZ_dqPE7;
   //---------------------------------------------------------------------------
   // dqd external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   reg [2:0]
      link_reg_dqdPE1;
   reg [2:0]
      derv_reg_dqdPE1;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE1,cosq_val_reg_dqdPE1,
      qd_val_reg_dqdPE1,
      v_curr_vec_reg_AX_dqdPE1,v_curr_vec_reg_AY_dqdPE1,v_curr_vec_reg_AZ_dqdPE1,v_curr_vec_reg_LX_dqdPE1,v_curr_vec_reg_LY_dqdPE1,v_curr_vec_reg_LZ_dqdPE1,
      a_curr_vec_reg_AX_dqdPE1,a_curr_vec_reg_AY_dqdPE1,a_curr_vec_reg_AZ_dqdPE1,a_curr_vec_reg_LX_dqdPE1,a_curr_vec_reg_LY_dqdPE1,a_curr_vec_reg_LZ_dqdPE1,
      dvdqd_prev_vec_reg_AX_dqdPE1,dvdqd_prev_vec_reg_AY_dqdPE1,dvdqd_prev_vec_reg_AZ_dqdPE1,dvdqd_prev_vec_reg_LX_dqdPE1,dvdqd_prev_vec_reg_LY_dqdPE1,dvdqd_prev_vec_reg_LZ_dqdPE1,
      dadqd_prev_vec_reg_AX_dqdPE1,dadqd_prev_vec_reg_AY_dqdPE1,dadqd_prev_vec_reg_AZ_dqdPE1,dadqd_prev_vec_reg_LX_dqdPE1,dadqd_prev_vec_reg_LY_dqdPE1,dadqd_prev_vec_reg_LZ_dqdPE1;
   // dqdPE2
   reg [2:0]
      link_reg_dqdPE2;
   reg [2:0]
      derv_reg_dqdPE2;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE2,cosq_val_reg_dqdPE2,
      qd_val_reg_dqdPE2,
      v_curr_vec_reg_AX_dqdPE2,v_curr_vec_reg_AY_dqdPE2,v_curr_vec_reg_AZ_dqdPE2,v_curr_vec_reg_LX_dqdPE2,v_curr_vec_reg_LY_dqdPE2,v_curr_vec_reg_LZ_dqdPE2,
      a_curr_vec_reg_AX_dqdPE2,a_curr_vec_reg_AY_dqdPE2,a_curr_vec_reg_AZ_dqdPE2,a_curr_vec_reg_LX_dqdPE2,a_curr_vec_reg_LY_dqdPE2,a_curr_vec_reg_LZ_dqdPE2,
      dvdqd_prev_vec_reg_AX_dqdPE2,dvdqd_prev_vec_reg_AY_dqdPE2,dvdqd_prev_vec_reg_AZ_dqdPE2,dvdqd_prev_vec_reg_LX_dqdPE2,dvdqd_prev_vec_reg_LY_dqdPE2,dvdqd_prev_vec_reg_LZ_dqdPE2,
      dadqd_prev_vec_reg_AX_dqdPE2,dadqd_prev_vec_reg_AY_dqdPE2,dadqd_prev_vec_reg_AZ_dqdPE2,dadqd_prev_vec_reg_LX_dqdPE2,dadqd_prev_vec_reg_LY_dqdPE2,dadqd_prev_vec_reg_LZ_dqdPE2;
   // dqdPE3
   reg [2:0]
      link_reg_dqdPE3;
   reg [2:0]
      derv_reg_dqdPE3;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE3,cosq_val_reg_dqdPE3,
      qd_val_reg_dqdPE3,
      v_curr_vec_reg_AX_dqdPE3,v_curr_vec_reg_AY_dqdPE3,v_curr_vec_reg_AZ_dqdPE3,v_curr_vec_reg_LX_dqdPE3,v_curr_vec_reg_LY_dqdPE3,v_curr_vec_reg_LZ_dqdPE3,
      a_curr_vec_reg_AX_dqdPE3,a_curr_vec_reg_AY_dqdPE3,a_curr_vec_reg_AZ_dqdPE3,a_curr_vec_reg_LX_dqdPE3,a_curr_vec_reg_LY_dqdPE3,a_curr_vec_reg_LZ_dqdPE3,
      dvdqd_prev_vec_reg_AX_dqdPE3,dvdqd_prev_vec_reg_AY_dqdPE3,dvdqd_prev_vec_reg_AZ_dqdPE3,dvdqd_prev_vec_reg_LX_dqdPE3,dvdqd_prev_vec_reg_LY_dqdPE3,dvdqd_prev_vec_reg_LZ_dqdPE3,
      dadqd_prev_vec_reg_AX_dqdPE3,dadqd_prev_vec_reg_AY_dqdPE3,dadqd_prev_vec_reg_AZ_dqdPE3,dadqd_prev_vec_reg_LX_dqdPE3,dadqd_prev_vec_reg_LY_dqdPE3,dadqd_prev_vec_reg_LZ_dqdPE3;
   // dqdPE4
   reg [2:0]
      link_reg_dqdPE4;
   reg [2:0]
      derv_reg_dqdPE4;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE4,cosq_val_reg_dqdPE4,
      qd_val_reg_dqdPE4,
      v_curr_vec_reg_AX_dqdPE4,v_curr_vec_reg_AY_dqdPE4,v_curr_vec_reg_AZ_dqdPE4,v_curr_vec_reg_LX_dqdPE4,v_curr_vec_reg_LY_dqdPE4,v_curr_vec_reg_LZ_dqdPE4,
      a_curr_vec_reg_AX_dqdPE4,a_curr_vec_reg_AY_dqdPE4,a_curr_vec_reg_AZ_dqdPE4,a_curr_vec_reg_LX_dqdPE4,a_curr_vec_reg_LY_dqdPE4,a_curr_vec_reg_LZ_dqdPE4,
      dvdqd_prev_vec_reg_AX_dqdPE4,dvdqd_prev_vec_reg_AY_dqdPE4,dvdqd_prev_vec_reg_AZ_dqdPE4,dvdqd_prev_vec_reg_LX_dqdPE4,dvdqd_prev_vec_reg_LY_dqdPE4,dvdqd_prev_vec_reg_LZ_dqdPE4,
      dadqd_prev_vec_reg_AX_dqdPE4,dadqd_prev_vec_reg_AY_dqdPE4,dadqd_prev_vec_reg_AZ_dqdPE4,dadqd_prev_vec_reg_LX_dqdPE4,dadqd_prev_vec_reg_LY_dqdPE4,dadqd_prev_vec_reg_LZ_dqdPE4;
   // dqdPE5
   reg [2:0]
      link_reg_dqdPE5;
   reg [2:0]
      derv_reg_dqdPE5;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE5,cosq_val_reg_dqdPE5,
      qd_val_reg_dqdPE5,
      v_curr_vec_reg_AX_dqdPE5,v_curr_vec_reg_AY_dqdPE5,v_curr_vec_reg_AZ_dqdPE5,v_curr_vec_reg_LX_dqdPE5,v_curr_vec_reg_LY_dqdPE5,v_curr_vec_reg_LZ_dqdPE5,
      a_curr_vec_reg_AX_dqdPE5,a_curr_vec_reg_AY_dqdPE5,a_curr_vec_reg_AZ_dqdPE5,a_curr_vec_reg_LX_dqdPE5,a_curr_vec_reg_LY_dqdPE5,a_curr_vec_reg_LZ_dqdPE5,
      dvdqd_prev_vec_reg_AX_dqdPE5,dvdqd_prev_vec_reg_AY_dqdPE5,dvdqd_prev_vec_reg_AZ_dqdPE5,dvdqd_prev_vec_reg_LX_dqdPE5,dvdqd_prev_vec_reg_LY_dqdPE5,dvdqd_prev_vec_reg_LZ_dqdPE5,
      dadqd_prev_vec_reg_AX_dqdPE5,dadqd_prev_vec_reg_AY_dqdPE5,dadqd_prev_vec_reg_AZ_dqdPE5,dadqd_prev_vec_reg_LX_dqdPE5,dadqd_prev_vec_reg_LY_dqdPE5,dadqd_prev_vec_reg_LZ_dqdPE5;
   // dqdPE6
   reg [2:0]
      link_reg_dqdPE6;
   reg [2:0]
      derv_reg_dqdPE6;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE6,cosq_val_reg_dqdPE6,
      qd_val_reg_dqdPE6,
      v_curr_vec_reg_AX_dqdPE6,v_curr_vec_reg_AY_dqdPE6,v_curr_vec_reg_AZ_dqdPE6,v_curr_vec_reg_LX_dqdPE6,v_curr_vec_reg_LY_dqdPE6,v_curr_vec_reg_LZ_dqdPE6,
      a_curr_vec_reg_AX_dqdPE6,a_curr_vec_reg_AY_dqdPE6,a_curr_vec_reg_AZ_dqdPE6,a_curr_vec_reg_LX_dqdPE6,a_curr_vec_reg_LY_dqdPE6,a_curr_vec_reg_LZ_dqdPE6,
      dvdqd_prev_vec_reg_AX_dqdPE6,dvdqd_prev_vec_reg_AY_dqdPE6,dvdqd_prev_vec_reg_AZ_dqdPE6,dvdqd_prev_vec_reg_LX_dqdPE6,dvdqd_prev_vec_reg_LY_dqdPE6,dvdqd_prev_vec_reg_LZ_dqdPE6,
      dadqd_prev_vec_reg_AX_dqdPE6,dadqd_prev_vec_reg_AY_dqdPE6,dadqd_prev_vec_reg_AZ_dqdPE6,dadqd_prev_vec_reg_LX_dqdPE6,dadqd_prev_vec_reg_LY_dqdPE6,dadqd_prev_vec_reg_LZ_dqdPE6;
   // dqdPE7
   reg [2:0]
      link_reg_dqdPE7;
   reg [2:0]
      derv_reg_dqdPE7;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE7,cosq_val_reg_dqdPE7,
      qd_val_reg_dqdPE7,
      v_curr_vec_reg_AX_dqdPE7,v_curr_vec_reg_AY_dqdPE7,v_curr_vec_reg_AZ_dqdPE7,v_curr_vec_reg_LX_dqdPE7,v_curr_vec_reg_LY_dqdPE7,v_curr_vec_reg_LZ_dqdPE7,
      a_curr_vec_reg_AX_dqdPE7,a_curr_vec_reg_AY_dqdPE7,a_curr_vec_reg_AZ_dqdPE7,a_curr_vec_reg_LX_dqdPE7,a_curr_vec_reg_LY_dqdPE7,a_curr_vec_reg_LZ_dqdPE7,
      dvdqd_prev_vec_reg_AX_dqdPE7,dvdqd_prev_vec_reg_AY_dqdPE7,dvdqd_prev_vec_reg_AZ_dqdPE7,dvdqd_prev_vec_reg_LX_dqdPE7,dvdqd_prev_vec_reg_LY_dqdPE7,dvdqd_prev_vec_reg_LZ_dqdPE7,
      dadqd_prev_vec_reg_AX_dqdPE7,dadqd_prev_vec_reg_AY_dqdPE7,dadqd_prev_vec_reg_AZ_dqdPE7,dadqd_prev_vec_reg_LX_dqdPE7,dadqd_prev_vec_reg_LY_dqdPE7,dadqd_prev_vec_reg_LZ_dqdPE7;
   //---------------------------------------------------------------------------
   // next
   wire get_data_next;
   wire output_ready_next;
   wire dummy_output_next;
   wire [2:0]
      state_next;
   wire s1_bool_next,s2_bool_next,s3_bool_next;
   //---------------------------------------------------------------------------
   // rnea external inputs
   //---------------------------------------------------------------------------
   // rnea
   wire [2:0]
      link_next_rnea;
   wire signed[(WIDTH-1):0]
      sinq_val_next_rnea,cosq_val_next_rnea,
      qd_val_next_rnea,
      qdd_val_next_rnea,
      v_prev_vec_next_AX_rnea,v_prev_vec_next_AY_rnea,v_prev_vec_next_AZ_rnea,v_prev_vec_next_LX_rnea,v_prev_vec_next_LY_rnea,v_prev_vec_next_LZ_rnea,
      a_prev_vec_next_AX_rnea,a_prev_vec_next_AY_rnea,a_prev_vec_next_AZ_rnea,a_prev_vec_next_LX_rnea,a_prev_vec_next_LY_rnea,a_prev_vec_next_LZ_rnea;
   //---------------------------------------------------------------------------
   // dq external inputs
   //---------------------------------------------------------------------------
   // dqPE1
   wire [2:0]
      link_next_dqPE1;
   wire [2:0]
      derv_next_dqPE1;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE1,cosq_val_next_dqPE1,
      qd_val_next_dqPE1,
      v_curr_vec_next_AX_dqPE1,v_curr_vec_next_AY_dqPE1,v_curr_vec_next_AZ_dqPE1,v_curr_vec_next_LX_dqPE1,v_curr_vec_next_LY_dqPE1,v_curr_vec_next_LZ_dqPE1,
      a_curr_vec_next_AX_dqPE1,a_curr_vec_next_AY_dqPE1,a_curr_vec_next_AZ_dqPE1,a_curr_vec_next_LX_dqPE1,a_curr_vec_next_LY_dqPE1,a_curr_vec_next_LZ_dqPE1,
      v_prev_vec_next_AX_dqPE1,v_prev_vec_next_AY_dqPE1,v_prev_vec_next_AZ_dqPE1,v_prev_vec_next_LX_dqPE1,v_prev_vec_next_LY_dqPE1,v_prev_vec_next_LZ_dqPE1,
      a_prev_vec_next_AX_dqPE1,a_prev_vec_next_AY_dqPE1,a_prev_vec_next_AZ_dqPE1,a_prev_vec_next_LX_dqPE1,a_prev_vec_next_LY_dqPE1,a_prev_vec_next_LZ_dqPE1,
      dvdq_prev_vec_next_AX_dqPE1,dvdq_prev_vec_next_AY_dqPE1,dvdq_prev_vec_next_AZ_dqPE1,dvdq_prev_vec_next_LX_dqPE1,dvdq_prev_vec_next_LY_dqPE1,dvdq_prev_vec_next_LZ_dqPE1,
      dadq_prev_vec_next_AX_dqPE1,dadq_prev_vec_next_AY_dqPE1,dadq_prev_vec_next_AZ_dqPE1,dadq_prev_vec_next_LX_dqPE1,dadq_prev_vec_next_LY_dqPE1,dadq_prev_vec_next_LZ_dqPE1;
   // dqPE2
   wire [2:0]
      link_next_dqPE2;
   wire [2:0]
      derv_next_dqPE2;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE2,cosq_val_next_dqPE2,
      qd_val_next_dqPE2,
      v_curr_vec_next_AX_dqPE2,v_curr_vec_next_AY_dqPE2,v_curr_vec_next_AZ_dqPE2,v_curr_vec_next_LX_dqPE2,v_curr_vec_next_LY_dqPE2,v_curr_vec_next_LZ_dqPE2,
      a_curr_vec_next_AX_dqPE2,a_curr_vec_next_AY_dqPE2,a_curr_vec_next_AZ_dqPE2,a_curr_vec_next_LX_dqPE2,a_curr_vec_next_LY_dqPE2,a_curr_vec_next_LZ_dqPE2,
      v_prev_vec_next_AX_dqPE2,v_prev_vec_next_AY_dqPE2,v_prev_vec_next_AZ_dqPE2,v_prev_vec_next_LX_dqPE2,v_prev_vec_next_LY_dqPE2,v_prev_vec_next_LZ_dqPE2,
      a_prev_vec_next_AX_dqPE2,a_prev_vec_next_AY_dqPE2,a_prev_vec_next_AZ_dqPE2,a_prev_vec_next_LX_dqPE2,a_prev_vec_next_LY_dqPE2,a_prev_vec_next_LZ_dqPE2,
      dvdq_prev_vec_next_AX_dqPE2,dvdq_prev_vec_next_AY_dqPE2,dvdq_prev_vec_next_AZ_dqPE2,dvdq_prev_vec_next_LX_dqPE2,dvdq_prev_vec_next_LY_dqPE2,dvdq_prev_vec_next_LZ_dqPE2,
      dadq_prev_vec_next_AX_dqPE2,dadq_prev_vec_next_AY_dqPE2,dadq_prev_vec_next_AZ_dqPE2,dadq_prev_vec_next_LX_dqPE2,dadq_prev_vec_next_LY_dqPE2,dadq_prev_vec_next_LZ_dqPE2;
   // dqPE3
   wire [2:0]
      link_next_dqPE3;
   wire [2:0]
      derv_next_dqPE3;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE3,cosq_val_next_dqPE3,
      qd_val_next_dqPE3,
      v_curr_vec_next_AX_dqPE3,v_curr_vec_next_AY_dqPE3,v_curr_vec_next_AZ_dqPE3,v_curr_vec_next_LX_dqPE3,v_curr_vec_next_LY_dqPE3,v_curr_vec_next_LZ_dqPE3,
      a_curr_vec_next_AX_dqPE3,a_curr_vec_next_AY_dqPE3,a_curr_vec_next_AZ_dqPE3,a_curr_vec_next_LX_dqPE3,a_curr_vec_next_LY_dqPE3,a_curr_vec_next_LZ_dqPE3,
      v_prev_vec_next_AX_dqPE3,v_prev_vec_next_AY_dqPE3,v_prev_vec_next_AZ_dqPE3,v_prev_vec_next_LX_dqPE3,v_prev_vec_next_LY_dqPE3,v_prev_vec_next_LZ_dqPE3,
      a_prev_vec_next_AX_dqPE3,a_prev_vec_next_AY_dqPE3,a_prev_vec_next_AZ_dqPE3,a_prev_vec_next_LX_dqPE3,a_prev_vec_next_LY_dqPE3,a_prev_vec_next_LZ_dqPE3,
      dvdq_prev_vec_next_AX_dqPE3,dvdq_prev_vec_next_AY_dqPE3,dvdq_prev_vec_next_AZ_dqPE3,dvdq_prev_vec_next_LX_dqPE3,dvdq_prev_vec_next_LY_dqPE3,dvdq_prev_vec_next_LZ_dqPE3,
      dadq_prev_vec_next_AX_dqPE3,dadq_prev_vec_next_AY_dqPE3,dadq_prev_vec_next_AZ_dqPE3,dadq_prev_vec_next_LX_dqPE3,dadq_prev_vec_next_LY_dqPE3,dadq_prev_vec_next_LZ_dqPE3;
   // dqPE4
   wire [2:0]
      link_next_dqPE4;
   wire [2:0]
      derv_next_dqPE4;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE4,cosq_val_next_dqPE4,
      qd_val_next_dqPE4,
      v_curr_vec_next_AX_dqPE4,v_curr_vec_next_AY_dqPE4,v_curr_vec_next_AZ_dqPE4,v_curr_vec_next_LX_dqPE4,v_curr_vec_next_LY_dqPE4,v_curr_vec_next_LZ_dqPE4,
      a_curr_vec_next_AX_dqPE4,a_curr_vec_next_AY_dqPE4,a_curr_vec_next_AZ_dqPE4,a_curr_vec_next_LX_dqPE4,a_curr_vec_next_LY_dqPE4,a_curr_vec_next_LZ_dqPE4,
      v_prev_vec_next_AX_dqPE4,v_prev_vec_next_AY_dqPE4,v_prev_vec_next_AZ_dqPE4,v_prev_vec_next_LX_dqPE4,v_prev_vec_next_LY_dqPE4,v_prev_vec_next_LZ_dqPE4,
      a_prev_vec_next_AX_dqPE4,a_prev_vec_next_AY_dqPE4,a_prev_vec_next_AZ_dqPE4,a_prev_vec_next_LX_dqPE4,a_prev_vec_next_LY_dqPE4,a_prev_vec_next_LZ_dqPE4,
      dvdq_prev_vec_next_AX_dqPE4,dvdq_prev_vec_next_AY_dqPE4,dvdq_prev_vec_next_AZ_dqPE4,dvdq_prev_vec_next_LX_dqPE4,dvdq_prev_vec_next_LY_dqPE4,dvdq_prev_vec_next_LZ_dqPE4,
      dadq_prev_vec_next_AX_dqPE4,dadq_prev_vec_next_AY_dqPE4,dadq_prev_vec_next_AZ_dqPE4,dadq_prev_vec_next_LX_dqPE4,dadq_prev_vec_next_LY_dqPE4,dadq_prev_vec_next_LZ_dqPE4;
   // dqPE5
   wire [2:0]
      link_next_dqPE5;
   wire [2:0]
      derv_next_dqPE5;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE5,cosq_val_next_dqPE5,
      qd_val_next_dqPE5,
      v_curr_vec_next_AX_dqPE5,v_curr_vec_next_AY_dqPE5,v_curr_vec_next_AZ_dqPE5,v_curr_vec_next_LX_dqPE5,v_curr_vec_next_LY_dqPE5,v_curr_vec_next_LZ_dqPE5,
      a_curr_vec_next_AX_dqPE5,a_curr_vec_next_AY_dqPE5,a_curr_vec_next_AZ_dqPE5,a_curr_vec_next_LX_dqPE5,a_curr_vec_next_LY_dqPE5,a_curr_vec_next_LZ_dqPE5,
      v_prev_vec_next_AX_dqPE5,v_prev_vec_next_AY_dqPE5,v_prev_vec_next_AZ_dqPE5,v_prev_vec_next_LX_dqPE5,v_prev_vec_next_LY_dqPE5,v_prev_vec_next_LZ_dqPE5,
      a_prev_vec_next_AX_dqPE5,a_prev_vec_next_AY_dqPE5,a_prev_vec_next_AZ_dqPE5,a_prev_vec_next_LX_dqPE5,a_prev_vec_next_LY_dqPE5,a_prev_vec_next_LZ_dqPE5,
      dvdq_prev_vec_next_AX_dqPE5,dvdq_prev_vec_next_AY_dqPE5,dvdq_prev_vec_next_AZ_dqPE5,dvdq_prev_vec_next_LX_dqPE5,dvdq_prev_vec_next_LY_dqPE5,dvdq_prev_vec_next_LZ_dqPE5,
      dadq_prev_vec_next_AX_dqPE5,dadq_prev_vec_next_AY_dqPE5,dadq_prev_vec_next_AZ_dqPE5,dadq_prev_vec_next_LX_dqPE5,dadq_prev_vec_next_LY_dqPE5,dadq_prev_vec_next_LZ_dqPE5;
   // dqPE6
   wire [2:0]
      link_next_dqPE6;
   wire [2:0]
      derv_next_dqPE6;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE6,cosq_val_next_dqPE6,
      qd_val_next_dqPE6,
      v_curr_vec_next_AX_dqPE6,v_curr_vec_next_AY_dqPE6,v_curr_vec_next_AZ_dqPE6,v_curr_vec_next_LX_dqPE6,v_curr_vec_next_LY_dqPE6,v_curr_vec_next_LZ_dqPE6,
      a_curr_vec_next_AX_dqPE6,a_curr_vec_next_AY_dqPE6,a_curr_vec_next_AZ_dqPE6,a_curr_vec_next_LX_dqPE6,a_curr_vec_next_LY_dqPE6,a_curr_vec_next_LZ_dqPE6,
      v_prev_vec_next_AX_dqPE6,v_prev_vec_next_AY_dqPE6,v_prev_vec_next_AZ_dqPE6,v_prev_vec_next_LX_dqPE6,v_prev_vec_next_LY_dqPE6,v_prev_vec_next_LZ_dqPE6,
      a_prev_vec_next_AX_dqPE6,a_prev_vec_next_AY_dqPE6,a_prev_vec_next_AZ_dqPE6,a_prev_vec_next_LX_dqPE6,a_prev_vec_next_LY_dqPE6,a_prev_vec_next_LZ_dqPE6,
      dvdq_prev_vec_next_AX_dqPE6,dvdq_prev_vec_next_AY_dqPE6,dvdq_prev_vec_next_AZ_dqPE6,dvdq_prev_vec_next_LX_dqPE6,dvdq_prev_vec_next_LY_dqPE6,dvdq_prev_vec_next_LZ_dqPE6,
      dadq_prev_vec_next_AX_dqPE6,dadq_prev_vec_next_AY_dqPE6,dadq_prev_vec_next_AZ_dqPE6,dadq_prev_vec_next_LX_dqPE6,dadq_prev_vec_next_LY_dqPE6,dadq_prev_vec_next_LZ_dqPE6;
   // dqPE7
   wire [2:0]
      link_next_dqPE7;
   wire [2:0]
      derv_next_dqPE7;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE7,cosq_val_next_dqPE7,
      qd_val_next_dqPE7,
      v_curr_vec_next_AX_dqPE7,v_curr_vec_next_AY_dqPE7,v_curr_vec_next_AZ_dqPE7,v_curr_vec_next_LX_dqPE7,v_curr_vec_next_LY_dqPE7,v_curr_vec_next_LZ_dqPE7,
      a_curr_vec_next_AX_dqPE7,a_curr_vec_next_AY_dqPE7,a_curr_vec_next_AZ_dqPE7,a_curr_vec_next_LX_dqPE7,a_curr_vec_next_LY_dqPE7,a_curr_vec_next_LZ_dqPE7,
      v_prev_vec_next_AX_dqPE7,v_prev_vec_next_AY_dqPE7,v_prev_vec_next_AZ_dqPE7,v_prev_vec_next_LX_dqPE7,v_prev_vec_next_LY_dqPE7,v_prev_vec_next_LZ_dqPE7,
      a_prev_vec_next_AX_dqPE7,a_prev_vec_next_AY_dqPE7,a_prev_vec_next_AZ_dqPE7,a_prev_vec_next_LX_dqPE7,a_prev_vec_next_LY_dqPE7,a_prev_vec_next_LZ_dqPE7,
      dvdq_prev_vec_next_AX_dqPE7,dvdq_prev_vec_next_AY_dqPE7,dvdq_prev_vec_next_AZ_dqPE7,dvdq_prev_vec_next_LX_dqPE7,dvdq_prev_vec_next_LY_dqPE7,dvdq_prev_vec_next_LZ_dqPE7,
      dadq_prev_vec_next_AX_dqPE7,dadq_prev_vec_next_AY_dqPE7,dadq_prev_vec_next_AZ_dqPE7,dadq_prev_vec_next_LX_dqPE7,dadq_prev_vec_next_LY_dqPE7,dadq_prev_vec_next_LZ_dqPE7;
   //---------------------------------------------------------------------------
   // dqd external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   wire [2:0]
      link_next_dqdPE1;
   wire [2:0]
      derv_next_dqdPE1;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE1,cosq_val_next_dqdPE1,
      qd_val_next_dqdPE1,
      v_curr_vec_next_AX_dqdPE1,v_curr_vec_next_AY_dqdPE1,v_curr_vec_next_AZ_dqdPE1,v_curr_vec_next_LX_dqdPE1,v_curr_vec_next_LY_dqdPE1,v_curr_vec_next_LZ_dqdPE1,
      a_curr_vec_next_AX_dqdPE1,a_curr_vec_next_AY_dqdPE1,a_curr_vec_next_AZ_dqdPE1,a_curr_vec_next_LX_dqdPE1,a_curr_vec_next_LY_dqdPE1,a_curr_vec_next_LZ_dqdPE1,
      dvdqd_prev_vec_next_AX_dqdPE1,dvdqd_prev_vec_next_AY_dqdPE1,dvdqd_prev_vec_next_AZ_dqdPE1,dvdqd_prev_vec_next_LX_dqdPE1,dvdqd_prev_vec_next_LY_dqdPE1,dvdqd_prev_vec_next_LZ_dqdPE1,
      dadqd_prev_vec_next_AX_dqdPE1,dadqd_prev_vec_next_AY_dqdPE1,dadqd_prev_vec_next_AZ_dqdPE1,dadqd_prev_vec_next_LX_dqdPE1,dadqd_prev_vec_next_LY_dqdPE1,dadqd_prev_vec_next_LZ_dqdPE1;
   // dqdPE2
   wire [2:0]
      link_next_dqdPE2;
   wire [2:0]
      derv_next_dqdPE2;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE2,cosq_val_next_dqdPE2,
      qd_val_next_dqdPE2,
      v_curr_vec_next_AX_dqdPE2,v_curr_vec_next_AY_dqdPE2,v_curr_vec_next_AZ_dqdPE2,v_curr_vec_next_LX_dqdPE2,v_curr_vec_next_LY_dqdPE2,v_curr_vec_next_LZ_dqdPE2,
      a_curr_vec_next_AX_dqdPE2,a_curr_vec_next_AY_dqdPE2,a_curr_vec_next_AZ_dqdPE2,a_curr_vec_next_LX_dqdPE2,a_curr_vec_next_LY_dqdPE2,a_curr_vec_next_LZ_dqdPE2,
      dvdqd_prev_vec_next_AX_dqdPE2,dvdqd_prev_vec_next_AY_dqdPE2,dvdqd_prev_vec_next_AZ_dqdPE2,dvdqd_prev_vec_next_LX_dqdPE2,dvdqd_prev_vec_next_LY_dqdPE2,dvdqd_prev_vec_next_LZ_dqdPE2,
      dadqd_prev_vec_next_AX_dqdPE2,dadqd_prev_vec_next_AY_dqdPE2,dadqd_prev_vec_next_AZ_dqdPE2,dadqd_prev_vec_next_LX_dqdPE2,dadqd_prev_vec_next_LY_dqdPE2,dadqd_prev_vec_next_LZ_dqdPE2;
   // dqdPE3
   wire [2:0]
      link_next_dqdPE3;
   wire [2:0]
      derv_next_dqdPE3;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE3,cosq_val_next_dqdPE3,
      qd_val_next_dqdPE3,
      v_curr_vec_next_AX_dqdPE3,v_curr_vec_next_AY_dqdPE3,v_curr_vec_next_AZ_dqdPE3,v_curr_vec_next_LX_dqdPE3,v_curr_vec_next_LY_dqdPE3,v_curr_vec_next_LZ_dqdPE3,
      a_curr_vec_next_AX_dqdPE3,a_curr_vec_next_AY_dqdPE3,a_curr_vec_next_AZ_dqdPE3,a_curr_vec_next_LX_dqdPE3,a_curr_vec_next_LY_dqdPE3,a_curr_vec_next_LZ_dqdPE3,
      dvdqd_prev_vec_next_AX_dqdPE3,dvdqd_prev_vec_next_AY_dqdPE3,dvdqd_prev_vec_next_AZ_dqdPE3,dvdqd_prev_vec_next_LX_dqdPE3,dvdqd_prev_vec_next_LY_dqdPE3,dvdqd_prev_vec_next_LZ_dqdPE3,
      dadqd_prev_vec_next_AX_dqdPE3,dadqd_prev_vec_next_AY_dqdPE3,dadqd_prev_vec_next_AZ_dqdPE3,dadqd_prev_vec_next_LX_dqdPE3,dadqd_prev_vec_next_LY_dqdPE3,dadqd_prev_vec_next_LZ_dqdPE3;
   // dqdPE4
   wire [2:0]
      link_next_dqdPE4;
   wire [2:0]
      derv_next_dqdPE4;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE4,cosq_val_next_dqdPE4,
      qd_val_next_dqdPE4,
      v_curr_vec_next_AX_dqdPE4,v_curr_vec_next_AY_dqdPE4,v_curr_vec_next_AZ_dqdPE4,v_curr_vec_next_LX_dqdPE4,v_curr_vec_next_LY_dqdPE4,v_curr_vec_next_LZ_dqdPE4,
      a_curr_vec_next_AX_dqdPE4,a_curr_vec_next_AY_dqdPE4,a_curr_vec_next_AZ_dqdPE4,a_curr_vec_next_LX_dqdPE4,a_curr_vec_next_LY_dqdPE4,a_curr_vec_next_LZ_dqdPE4,
      dvdqd_prev_vec_next_AX_dqdPE4,dvdqd_prev_vec_next_AY_dqdPE4,dvdqd_prev_vec_next_AZ_dqdPE4,dvdqd_prev_vec_next_LX_dqdPE4,dvdqd_prev_vec_next_LY_dqdPE4,dvdqd_prev_vec_next_LZ_dqdPE4,
      dadqd_prev_vec_next_AX_dqdPE4,dadqd_prev_vec_next_AY_dqdPE4,dadqd_prev_vec_next_AZ_dqdPE4,dadqd_prev_vec_next_LX_dqdPE4,dadqd_prev_vec_next_LY_dqdPE4,dadqd_prev_vec_next_LZ_dqdPE4;
   // dqdPE5
   wire [2:0]
      link_next_dqdPE5;
   wire [2:0]
      derv_next_dqdPE5;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE5,cosq_val_next_dqdPE5,
      qd_val_next_dqdPE5,
      v_curr_vec_next_AX_dqdPE5,v_curr_vec_next_AY_dqdPE5,v_curr_vec_next_AZ_dqdPE5,v_curr_vec_next_LX_dqdPE5,v_curr_vec_next_LY_dqdPE5,v_curr_vec_next_LZ_dqdPE5,
      a_curr_vec_next_AX_dqdPE5,a_curr_vec_next_AY_dqdPE5,a_curr_vec_next_AZ_dqdPE5,a_curr_vec_next_LX_dqdPE5,a_curr_vec_next_LY_dqdPE5,a_curr_vec_next_LZ_dqdPE5,
      dvdqd_prev_vec_next_AX_dqdPE5,dvdqd_prev_vec_next_AY_dqdPE5,dvdqd_prev_vec_next_AZ_dqdPE5,dvdqd_prev_vec_next_LX_dqdPE5,dvdqd_prev_vec_next_LY_dqdPE5,dvdqd_prev_vec_next_LZ_dqdPE5,
      dadqd_prev_vec_next_AX_dqdPE5,dadqd_prev_vec_next_AY_dqdPE5,dadqd_prev_vec_next_AZ_dqdPE5,dadqd_prev_vec_next_LX_dqdPE5,dadqd_prev_vec_next_LY_dqdPE5,dadqd_prev_vec_next_LZ_dqdPE5;
   // dqdPE6
   wire [2:0]
      link_next_dqdPE6;
   wire [2:0]
      derv_next_dqdPE6;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE6,cosq_val_next_dqdPE6,
      qd_val_next_dqdPE6,
      v_curr_vec_next_AX_dqdPE6,v_curr_vec_next_AY_dqdPE6,v_curr_vec_next_AZ_dqdPE6,v_curr_vec_next_LX_dqdPE6,v_curr_vec_next_LY_dqdPE6,v_curr_vec_next_LZ_dqdPE6,
      a_curr_vec_next_AX_dqdPE6,a_curr_vec_next_AY_dqdPE6,a_curr_vec_next_AZ_dqdPE6,a_curr_vec_next_LX_dqdPE6,a_curr_vec_next_LY_dqdPE6,a_curr_vec_next_LZ_dqdPE6,
      dvdqd_prev_vec_next_AX_dqdPE6,dvdqd_prev_vec_next_AY_dqdPE6,dvdqd_prev_vec_next_AZ_dqdPE6,dvdqd_prev_vec_next_LX_dqdPE6,dvdqd_prev_vec_next_LY_dqdPE6,dvdqd_prev_vec_next_LZ_dqdPE6,
      dadqd_prev_vec_next_AX_dqdPE6,dadqd_prev_vec_next_AY_dqdPE6,dadqd_prev_vec_next_AZ_dqdPE6,dadqd_prev_vec_next_LX_dqdPE6,dadqd_prev_vec_next_LY_dqdPE6,dadqd_prev_vec_next_LZ_dqdPE6;
   // dqdPE7
   wire [2:0]
      link_next_dqdPE7;
   wire [2:0]
      derv_next_dqdPE7;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE7,cosq_val_next_dqdPE7,
      qd_val_next_dqdPE7,
      v_curr_vec_next_AX_dqdPE7,v_curr_vec_next_AY_dqdPE7,v_curr_vec_next_AZ_dqdPE7,v_curr_vec_next_LX_dqdPE7,v_curr_vec_next_LY_dqdPE7,v_curr_vec_next_LZ_dqdPE7,
      a_curr_vec_next_AX_dqdPE7,a_curr_vec_next_AY_dqdPE7,a_curr_vec_next_AZ_dqdPE7,a_curr_vec_next_LX_dqdPE7,a_curr_vec_next_LY_dqdPE7,a_curr_vec_next_LZ_dqdPE7,
      dvdqd_prev_vec_next_AX_dqdPE7,dvdqd_prev_vec_next_AY_dqdPE7,dvdqd_prev_vec_next_AZ_dqdPE7,dvdqd_prev_vec_next_LX_dqdPE7,dvdqd_prev_vec_next_LY_dqdPE7,dvdqd_prev_vec_next_LZ_dqdPE7,
      dadqd_prev_vec_next_AX_dqdPE7,dadqd_prev_vec_next_AY_dqdPE7,dadqd_prev_vec_next_AZ_dqdPE7,dadqd_prev_vec_next_LX_dqdPE7,dadqd_prev_vec_next_LY_dqdPE7,dadqd_prev_vec_next_LZ_dqdPE7;
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
   // external assignments
   //---------------------------------------------------------------------------
   // inputs
   assign get_data_next = get_data;
   // output
   assign output_ready = output_ready_reg;
   assign output_ready_next = ((state_reg == 3'd0)&&(get_data == 1)) ? 0 :
                              ((state_reg == 3'd0)&&(get_data == 0)) ? 0 :
                               (state_reg == 3'd1)                   ? 0 :
                               (state_reg == 3'd2)                   ? 1 :
                              ((state_reg == 3'd3)&&(get_data == 1)) ? 0 :
                              ((state_reg == 3'd3)&&(get_data == 0)) ? 0 : output_ready_reg;
   assign dummy_output = dummy_output_reg;
   assign dummy_output_next =  (state_reg == 3'd0)                   ? 0 :
                               (state_reg == 3'd1)                   ? 0 :
                              ((state_reg == 3'd2)&&(link_reg_rnea == 3'd1)) ? 1 :
                              ((state_reg == 3'd2)&&(link_reg_rnea != 3'd1)) ? 0 :
                               (state_reg == 3'd3)                   ? 0 : dummy_output_reg;
   // state
   assign state_next     = ((state_reg == 3'd0)&&(get_data == 1)) ? 3'd1 :
                           ((state_reg == 3'd0)&&(get_data == 0)) ? 3'd0 :
                            (state_reg == 3'd1)                   ? 3'd2 :
                            (state_reg == 3'd2)                   ? 3'd3 :
                           ((state_reg == 3'd3)&&(get_data == 1)) ? 3'd1 :
                           ((state_reg == 3'd3)&&(get_data == 0)) ? 3'd0 : state_reg;
   assign s1_bool_next   = ((state_reg == 3'd0)&&(get_data == 1)) ? 1 :
                           ((state_reg == 3'd0)&&(get_data == 0)) ? s1_bool_reg :
                            (state_reg == 3'd1)                   ? 0 :
                            (state_reg == 3'd2)                   ? 0 :
                           ((state_reg == 3'd3)&&(get_data == 1)) ? 1 :
                           ((state_reg == 3'd3)&&(get_data == 0)) ? 0 : s1_bool_reg;
   assign s2_bool_next   = ((state_reg == 3'd0)&&(get_data == 1)) ? 0 :
                           ((state_reg == 3'd0)&&(get_data == 0)) ? 0 :
                            (state_reg == 3'd1)                   ? 1 :
                            (state_reg == 3'd2)                   ? 0 :
                           ((state_reg == 3'd3)&&(get_data == 1)) ? 0 :
                           ((state_reg == 3'd3)&&(get_data == 0)) ? 0 : s2_bool_reg;
   assign s3_bool_next   = ((state_reg == 3'd0)&&(get_data == 1)) ? 0 :
                           ((state_reg == 3'd0)&&(get_data == 0)) ? 0 :
                            (state_reg == 3'd1)                   ? 0 :
                            (state_reg == 3'd2)                   ? 1 :
                           ((state_reg == 3'd3)&&(get_data == 1)) ? 0 :
                           ((state_reg == 3'd3)&&(get_data == 0)) ? 0 : s3_bool_reg;
   //---------------------------------------------------------------------------
   // rnea external inputs
   //---------------------------------------------------------------------------
   // rnea
   assign link_next_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_rnea :
                           ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_rnea : link_reg_rnea;
   assign sinq_val_next_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_rnea :
                               ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_rnea : sinq_val_reg_rnea;
   assign cosq_val_next_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_rnea :
                               ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_rnea : cosq_val_reg_rnea;
   assign qd_val_next_rnea   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_rnea :
                               ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_rnea : qd_val_reg_rnea;
   assign qdd_val_next_rnea  = ((state_reg == 3'd0)&&(get_data == 1)) ? qdd_val_in_rnea :
                               ((state_reg == 3'd3)&&(get_data == 1)) ? qdd_val_in_rnea : qdd_val_reg_rnea;
   // v prev
   assign v_prev_vec_next_AX_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AX_rnea :
                                    ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AX_rnea : v_prev_vec_reg_AX_rnea;
   assign v_prev_vec_next_AY_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AY_rnea :
                                    ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AY_rnea : v_prev_vec_reg_AY_rnea;
   assign v_prev_vec_next_AZ_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AZ_rnea :
                                    ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AZ_rnea : v_prev_vec_reg_AZ_rnea;
   assign v_prev_vec_next_LX_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LX_rnea :
                                    ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LX_rnea : v_prev_vec_reg_LX_rnea;
   assign v_prev_vec_next_LY_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LY_rnea :
                                    ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LY_rnea : v_prev_vec_reg_LY_rnea;
   assign v_prev_vec_next_LZ_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LZ_rnea :
                                    ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LZ_rnea : v_prev_vec_reg_LZ_rnea;
   // a prev
   assign a_prev_vec_next_AX_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AX_rnea :
                                    ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AX_rnea : a_prev_vec_reg_AX_rnea;
   assign a_prev_vec_next_AY_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AY_rnea :
                                    ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AY_rnea : a_prev_vec_reg_AY_rnea;
   assign a_prev_vec_next_AZ_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AZ_rnea :
                                    ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AZ_rnea : a_prev_vec_reg_AZ_rnea;
   assign a_prev_vec_next_LX_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LX_rnea :
                                    ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LX_rnea : a_prev_vec_reg_LX_rnea;
   assign a_prev_vec_next_LY_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LY_rnea :
                                    ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LY_rnea : a_prev_vec_reg_LY_rnea;
   assign a_prev_vec_next_LZ_rnea = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LZ_rnea :
                                    ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LZ_rnea : a_prev_vec_reg_LZ_rnea;
   //---------------------------------------------------------------------------
   // dq external inputs
   //---------------------------------------------------------------------------
   // dqPE1
   assign link_next_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqPE1 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqPE1 : link_reg_dqPE1;
   assign derv_next_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqPE1 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqPE1 : derv_reg_dqPE1;
   assign sinq_val_next_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqPE1 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqPE1 : sinq_val_reg_dqPE1;
   assign cosq_val_next_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqPE1 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqPE1 : cosq_val_reg_dqPE1;
   assign qd_val_next_dqPE1   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqPE1 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqPE1 : qd_val_reg_dqPE1;
   // v curr
   assign v_curr_vec_next_AX_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE1 : v_curr_vec_reg_AX_dqPE1;
   assign v_curr_vec_next_AY_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE1 : v_curr_vec_reg_AY_dqPE1;
   assign v_curr_vec_next_AZ_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE1 : v_curr_vec_reg_AZ_dqPE1;
   assign v_curr_vec_next_LX_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE1 : v_curr_vec_reg_LX_dqPE1;
   assign v_curr_vec_next_LY_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE1 : v_curr_vec_reg_LY_dqPE1;
   assign v_curr_vec_next_LZ_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE1 : v_curr_vec_reg_LZ_dqPE1;
   // a curr
   assign a_curr_vec_next_AX_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE1 : a_curr_vec_reg_AX_dqPE1;
   assign a_curr_vec_next_AY_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE1 : a_curr_vec_reg_AY_dqPE1;
   assign a_curr_vec_next_AZ_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE1 : a_curr_vec_reg_AZ_dqPE1;
   assign a_curr_vec_next_LX_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE1 : a_curr_vec_reg_LX_dqPE1;
   assign a_curr_vec_next_LY_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE1 : a_curr_vec_reg_LY_dqPE1;
   assign a_curr_vec_next_LZ_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE1 : a_curr_vec_reg_LZ_dqPE1;
   // v prev
   assign v_prev_vec_next_AX_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE1 : v_prev_vec_reg_AX_dqPE1;
   assign v_prev_vec_next_AY_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE1 : v_prev_vec_reg_AY_dqPE1;
   assign v_prev_vec_next_AZ_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE1 : v_prev_vec_reg_AZ_dqPE1;
   assign v_prev_vec_next_LX_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE1 : v_prev_vec_reg_LX_dqPE1;
   assign v_prev_vec_next_LY_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE1 : v_prev_vec_reg_LY_dqPE1;
   assign v_prev_vec_next_LZ_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE1 : v_prev_vec_reg_LZ_dqPE1;
   // a prev
   assign a_prev_vec_next_AX_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE1 : a_prev_vec_reg_AX_dqPE1;
   assign a_prev_vec_next_AY_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE1 : a_prev_vec_reg_AY_dqPE1;
   assign a_prev_vec_next_AZ_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE1 : a_prev_vec_reg_AZ_dqPE1;
   assign a_prev_vec_next_LX_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE1 : a_prev_vec_reg_LX_dqPE1;
   assign a_prev_vec_next_LY_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE1 : a_prev_vec_reg_LY_dqPE1;
   assign a_prev_vec_next_LZ_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE1 : a_prev_vec_reg_LZ_dqPE1;
   // dv prev
   assign dvdq_prev_vec_next_AX_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE1 : dvdq_prev_vec_reg_AX_dqPE1;
   assign dvdq_prev_vec_next_AY_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE1 : dvdq_prev_vec_reg_AY_dqPE1;
   assign dvdq_prev_vec_next_AZ_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE1 : dvdq_prev_vec_reg_AZ_dqPE1;
   assign dvdq_prev_vec_next_LX_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE1 : dvdq_prev_vec_reg_LX_dqPE1;
   assign dvdq_prev_vec_next_LY_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE1 : dvdq_prev_vec_reg_LY_dqPE1;
   assign dvdq_prev_vec_next_LZ_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE1 : dvdq_prev_vec_reg_LZ_dqPE1;
   // da prev
   assign dadq_prev_vec_next_AX_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE1 : dadq_prev_vec_reg_AX_dqPE1;
   assign dadq_prev_vec_next_AY_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE1 : dadq_prev_vec_reg_AY_dqPE1;
   assign dadq_prev_vec_next_AZ_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE1 : dadq_prev_vec_reg_AZ_dqPE1;
   assign dadq_prev_vec_next_LX_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE1 : dadq_prev_vec_reg_LX_dqPE1;
   assign dadq_prev_vec_next_LY_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE1 : dadq_prev_vec_reg_LY_dqPE1;
   assign dadq_prev_vec_next_LZ_dqPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE1 : dadq_prev_vec_reg_LZ_dqPE1;
   // dqPE2
   assign link_next_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqPE2 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqPE2 : link_reg_dqPE2;
   assign derv_next_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqPE2 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqPE2 : derv_reg_dqPE2;
   assign sinq_val_next_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqPE2 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqPE2 : sinq_val_reg_dqPE2;
   assign cosq_val_next_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqPE2 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqPE2 : cosq_val_reg_dqPE2;
   assign qd_val_next_dqPE2   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqPE2 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqPE2 : qd_val_reg_dqPE2;
   // v curr
   assign v_curr_vec_next_AX_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE2 : v_curr_vec_reg_AX_dqPE2;
   assign v_curr_vec_next_AY_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE2 : v_curr_vec_reg_AY_dqPE2;
   assign v_curr_vec_next_AZ_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE2 : v_curr_vec_reg_AZ_dqPE2;
   assign v_curr_vec_next_LX_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE2 : v_curr_vec_reg_LX_dqPE2;
   assign v_curr_vec_next_LY_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE2 : v_curr_vec_reg_LY_dqPE2;
   assign v_curr_vec_next_LZ_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE2 : v_curr_vec_reg_LZ_dqPE2;
   // a curr
   assign a_curr_vec_next_AX_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE2 : a_curr_vec_reg_AX_dqPE2;
   assign a_curr_vec_next_AY_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE2 : a_curr_vec_reg_AY_dqPE2;
   assign a_curr_vec_next_AZ_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE2 : a_curr_vec_reg_AZ_dqPE2;
   assign a_curr_vec_next_LX_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE2 : a_curr_vec_reg_LX_dqPE2;
   assign a_curr_vec_next_LY_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE2 : a_curr_vec_reg_LY_dqPE2;
   assign a_curr_vec_next_LZ_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE2 : a_curr_vec_reg_LZ_dqPE2;
   // v prev
   assign v_prev_vec_next_AX_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE2 : v_prev_vec_reg_AX_dqPE2;
   assign v_prev_vec_next_AY_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE2 : v_prev_vec_reg_AY_dqPE2;
   assign v_prev_vec_next_AZ_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE2 : v_prev_vec_reg_AZ_dqPE2;
   assign v_prev_vec_next_LX_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE2 : v_prev_vec_reg_LX_dqPE2;
   assign v_prev_vec_next_LY_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE2 : v_prev_vec_reg_LY_dqPE2;
   assign v_prev_vec_next_LZ_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE2 : v_prev_vec_reg_LZ_dqPE2;
   // a prev
   assign a_prev_vec_next_AX_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE2 : a_prev_vec_reg_AX_dqPE2;
   assign a_prev_vec_next_AY_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE2 : a_prev_vec_reg_AY_dqPE2;
   assign a_prev_vec_next_AZ_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE2 : a_prev_vec_reg_AZ_dqPE2;
   assign a_prev_vec_next_LX_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE2 : a_prev_vec_reg_LX_dqPE2;
   assign a_prev_vec_next_LY_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE2 : a_prev_vec_reg_LY_dqPE2;
   assign a_prev_vec_next_LZ_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE2 : a_prev_vec_reg_LZ_dqPE2;
   // dv prev
   assign dvdq_prev_vec_next_AX_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE2 : dvdq_prev_vec_reg_AX_dqPE2;
   assign dvdq_prev_vec_next_AY_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE2 : dvdq_prev_vec_reg_AY_dqPE2;
   assign dvdq_prev_vec_next_AZ_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE2 : dvdq_prev_vec_reg_AZ_dqPE2;
   assign dvdq_prev_vec_next_LX_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE2 : dvdq_prev_vec_reg_LX_dqPE2;
   assign dvdq_prev_vec_next_LY_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE2 : dvdq_prev_vec_reg_LY_dqPE2;
   assign dvdq_prev_vec_next_LZ_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE2 : dvdq_prev_vec_reg_LZ_dqPE2;
   // da prev
   assign dadq_prev_vec_next_AX_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE2 : dadq_prev_vec_reg_AX_dqPE2;
   assign dadq_prev_vec_next_AY_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE2 : dadq_prev_vec_reg_AY_dqPE2;
   assign dadq_prev_vec_next_AZ_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE2 : dadq_prev_vec_reg_AZ_dqPE2;
   assign dadq_prev_vec_next_LX_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE2 : dadq_prev_vec_reg_LX_dqPE2;
   assign dadq_prev_vec_next_LY_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE2 : dadq_prev_vec_reg_LY_dqPE2;
   assign dadq_prev_vec_next_LZ_dqPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE2 : dadq_prev_vec_reg_LZ_dqPE2;
   // dqPE3
   assign link_next_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqPE3 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqPE3 : link_reg_dqPE3;
   assign derv_next_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqPE3 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqPE3 : derv_reg_dqPE3;
   assign sinq_val_next_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqPE3 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqPE3 : sinq_val_reg_dqPE3;
   assign cosq_val_next_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqPE3 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqPE3 : cosq_val_reg_dqPE3;
   assign qd_val_next_dqPE3   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqPE3 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqPE3 : qd_val_reg_dqPE3;
   // v curr
   assign v_curr_vec_next_AX_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE3 : v_curr_vec_reg_AX_dqPE3;
   assign v_curr_vec_next_AY_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE3 : v_curr_vec_reg_AY_dqPE3;
   assign v_curr_vec_next_AZ_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE3 : v_curr_vec_reg_AZ_dqPE3;
   assign v_curr_vec_next_LX_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE3 : v_curr_vec_reg_LX_dqPE3;
   assign v_curr_vec_next_LY_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE3 : v_curr_vec_reg_LY_dqPE3;
   assign v_curr_vec_next_LZ_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE3 : v_curr_vec_reg_LZ_dqPE3;
   // a curr
   assign a_curr_vec_next_AX_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE3 : a_curr_vec_reg_AX_dqPE3;
   assign a_curr_vec_next_AY_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE3 : a_curr_vec_reg_AY_dqPE3;
   assign a_curr_vec_next_AZ_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE3 : a_curr_vec_reg_AZ_dqPE3;
   assign a_curr_vec_next_LX_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE3 : a_curr_vec_reg_LX_dqPE3;
   assign a_curr_vec_next_LY_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE3 : a_curr_vec_reg_LY_dqPE3;
   assign a_curr_vec_next_LZ_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE3 : a_curr_vec_reg_LZ_dqPE3;
   // v prev
   assign v_prev_vec_next_AX_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE3 : v_prev_vec_reg_AX_dqPE3;
   assign v_prev_vec_next_AY_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE3 : v_prev_vec_reg_AY_dqPE3;
   assign v_prev_vec_next_AZ_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE3 : v_prev_vec_reg_AZ_dqPE3;
   assign v_prev_vec_next_LX_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE3 : v_prev_vec_reg_LX_dqPE3;
   assign v_prev_vec_next_LY_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE3 : v_prev_vec_reg_LY_dqPE3;
   assign v_prev_vec_next_LZ_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE3 : v_prev_vec_reg_LZ_dqPE3;
   // a prev
   assign a_prev_vec_next_AX_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE3 : a_prev_vec_reg_AX_dqPE3;
   assign a_prev_vec_next_AY_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE3 : a_prev_vec_reg_AY_dqPE3;
   assign a_prev_vec_next_AZ_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE3 : a_prev_vec_reg_AZ_dqPE3;
   assign a_prev_vec_next_LX_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE3 : a_prev_vec_reg_LX_dqPE3;
   assign a_prev_vec_next_LY_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE3 : a_prev_vec_reg_LY_dqPE3;
   assign a_prev_vec_next_LZ_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE3 : a_prev_vec_reg_LZ_dqPE3;
   // dv prev
   assign dvdq_prev_vec_next_AX_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE3 : dvdq_prev_vec_reg_AX_dqPE3;
   assign dvdq_prev_vec_next_AY_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE3 : dvdq_prev_vec_reg_AY_dqPE3;
   assign dvdq_prev_vec_next_AZ_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE3 : dvdq_prev_vec_reg_AZ_dqPE3;
   assign dvdq_prev_vec_next_LX_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE3 : dvdq_prev_vec_reg_LX_dqPE3;
   assign dvdq_prev_vec_next_LY_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE3 : dvdq_prev_vec_reg_LY_dqPE3;
   assign dvdq_prev_vec_next_LZ_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE3 : dvdq_prev_vec_reg_LZ_dqPE3;
   // da prev
   assign dadq_prev_vec_next_AX_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE3 : dadq_prev_vec_reg_AX_dqPE3;
   assign dadq_prev_vec_next_AY_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE3 : dadq_prev_vec_reg_AY_dqPE3;
   assign dadq_prev_vec_next_AZ_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE3 : dadq_prev_vec_reg_AZ_dqPE3;
   assign dadq_prev_vec_next_LX_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE3 : dadq_prev_vec_reg_LX_dqPE3;
   assign dadq_prev_vec_next_LY_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE3 : dadq_prev_vec_reg_LY_dqPE3;
   assign dadq_prev_vec_next_LZ_dqPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE3 : dadq_prev_vec_reg_LZ_dqPE3;
   // dqPE4
   assign link_next_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqPE4 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqPE4 : link_reg_dqPE4;
   assign derv_next_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqPE4 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqPE4 : derv_reg_dqPE4;
   assign sinq_val_next_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqPE4 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqPE4 : sinq_val_reg_dqPE4;
   assign cosq_val_next_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqPE4 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqPE4 : cosq_val_reg_dqPE4;
   assign qd_val_next_dqPE4   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqPE4 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqPE4 : qd_val_reg_dqPE4;
   // v curr
   assign v_curr_vec_next_AX_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE4 : v_curr_vec_reg_AX_dqPE4;
   assign v_curr_vec_next_AY_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE4 : v_curr_vec_reg_AY_dqPE4;
   assign v_curr_vec_next_AZ_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE4 : v_curr_vec_reg_AZ_dqPE4;
   assign v_curr_vec_next_LX_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE4 : v_curr_vec_reg_LX_dqPE4;
   assign v_curr_vec_next_LY_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE4 : v_curr_vec_reg_LY_dqPE4;
   assign v_curr_vec_next_LZ_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE4 : v_curr_vec_reg_LZ_dqPE4;
   // a curr
   assign a_curr_vec_next_AX_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE4 : a_curr_vec_reg_AX_dqPE4;
   assign a_curr_vec_next_AY_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE4 : a_curr_vec_reg_AY_dqPE4;
   assign a_curr_vec_next_AZ_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE4 : a_curr_vec_reg_AZ_dqPE4;
   assign a_curr_vec_next_LX_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE4 : a_curr_vec_reg_LX_dqPE4;
   assign a_curr_vec_next_LY_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE4 : a_curr_vec_reg_LY_dqPE4;
   assign a_curr_vec_next_LZ_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE4 : a_curr_vec_reg_LZ_dqPE4;
   // v prev
   assign v_prev_vec_next_AX_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE4 : v_prev_vec_reg_AX_dqPE4;
   assign v_prev_vec_next_AY_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE4 : v_prev_vec_reg_AY_dqPE4;
   assign v_prev_vec_next_AZ_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE4 : v_prev_vec_reg_AZ_dqPE4;
   assign v_prev_vec_next_LX_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE4 : v_prev_vec_reg_LX_dqPE4;
   assign v_prev_vec_next_LY_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE4 : v_prev_vec_reg_LY_dqPE4;
   assign v_prev_vec_next_LZ_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE4 : v_prev_vec_reg_LZ_dqPE4;
   // a prev
   assign a_prev_vec_next_AX_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE4 : a_prev_vec_reg_AX_dqPE4;
   assign a_prev_vec_next_AY_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE4 : a_prev_vec_reg_AY_dqPE4;
   assign a_prev_vec_next_AZ_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE4 : a_prev_vec_reg_AZ_dqPE4;
   assign a_prev_vec_next_LX_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE4 : a_prev_vec_reg_LX_dqPE4;
   assign a_prev_vec_next_LY_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE4 : a_prev_vec_reg_LY_dqPE4;
   assign a_prev_vec_next_LZ_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE4 : a_prev_vec_reg_LZ_dqPE4;
   // dv prev
   assign dvdq_prev_vec_next_AX_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE4 : dvdq_prev_vec_reg_AX_dqPE4;
   assign dvdq_prev_vec_next_AY_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE4 : dvdq_prev_vec_reg_AY_dqPE4;
   assign dvdq_prev_vec_next_AZ_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE4 : dvdq_prev_vec_reg_AZ_dqPE4;
   assign dvdq_prev_vec_next_LX_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE4 : dvdq_prev_vec_reg_LX_dqPE4;
   assign dvdq_prev_vec_next_LY_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE4 : dvdq_prev_vec_reg_LY_dqPE4;
   assign dvdq_prev_vec_next_LZ_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE4 : dvdq_prev_vec_reg_LZ_dqPE4;
   // da prev
   assign dadq_prev_vec_next_AX_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE4 : dadq_prev_vec_reg_AX_dqPE4;
   assign dadq_prev_vec_next_AY_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE4 : dadq_prev_vec_reg_AY_dqPE4;
   assign dadq_prev_vec_next_AZ_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE4 : dadq_prev_vec_reg_AZ_dqPE4;
   assign dadq_prev_vec_next_LX_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE4 : dadq_prev_vec_reg_LX_dqPE4;
   assign dadq_prev_vec_next_LY_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE4 : dadq_prev_vec_reg_LY_dqPE4;
   assign dadq_prev_vec_next_LZ_dqPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE4 : dadq_prev_vec_reg_LZ_dqPE4;
   // dqPE5
   assign link_next_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqPE5 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqPE5 : link_reg_dqPE5;
   assign derv_next_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqPE5 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqPE5 : derv_reg_dqPE5;
   assign sinq_val_next_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqPE5 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqPE5 : sinq_val_reg_dqPE5;
   assign cosq_val_next_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqPE5 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqPE5 : cosq_val_reg_dqPE5;
   assign qd_val_next_dqPE5   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqPE5 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqPE5 : qd_val_reg_dqPE5;
   // v curr
   assign v_curr_vec_next_AX_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE5 : v_curr_vec_reg_AX_dqPE5;
   assign v_curr_vec_next_AY_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE5 : v_curr_vec_reg_AY_dqPE5;
   assign v_curr_vec_next_AZ_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE5 : v_curr_vec_reg_AZ_dqPE5;
   assign v_curr_vec_next_LX_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE5 : v_curr_vec_reg_LX_dqPE5;
   assign v_curr_vec_next_LY_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE5 : v_curr_vec_reg_LY_dqPE5;
   assign v_curr_vec_next_LZ_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE5 : v_curr_vec_reg_LZ_dqPE5;
   // a curr
   assign a_curr_vec_next_AX_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE5 : a_curr_vec_reg_AX_dqPE5;
   assign a_curr_vec_next_AY_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE5 : a_curr_vec_reg_AY_dqPE5;
   assign a_curr_vec_next_AZ_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE5 : a_curr_vec_reg_AZ_dqPE5;
   assign a_curr_vec_next_LX_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE5 : a_curr_vec_reg_LX_dqPE5;
   assign a_curr_vec_next_LY_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE5 : a_curr_vec_reg_LY_dqPE5;
   assign a_curr_vec_next_LZ_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE5 : a_curr_vec_reg_LZ_dqPE5;
   // v prev
   assign v_prev_vec_next_AX_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE5 : v_prev_vec_reg_AX_dqPE5;
   assign v_prev_vec_next_AY_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE5 : v_prev_vec_reg_AY_dqPE5;
   assign v_prev_vec_next_AZ_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE5 : v_prev_vec_reg_AZ_dqPE5;
   assign v_prev_vec_next_LX_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE5 : v_prev_vec_reg_LX_dqPE5;
   assign v_prev_vec_next_LY_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE5 : v_prev_vec_reg_LY_dqPE5;
   assign v_prev_vec_next_LZ_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE5 : v_prev_vec_reg_LZ_dqPE5;
   // a prev
   assign a_prev_vec_next_AX_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE5 : a_prev_vec_reg_AX_dqPE5;
   assign a_prev_vec_next_AY_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE5 : a_prev_vec_reg_AY_dqPE5;
   assign a_prev_vec_next_AZ_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE5 : a_prev_vec_reg_AZ_dqPE5;
   assign a_prev_vec_next_LX_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE5 : a_prev_vec_reg_LX_dqPE5;
   assign a_prev_vec_next_LY_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE5 : a_prev_vec_reg_LY_dqPE5;
   assign a_prev_vec_next_LZ_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE5 : a_prev_vec_reg_LZ_dqPE5;
   // dv prev
   assign dvdq_prev_vec_next_AX_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE5 : dvdq_prev_vec_reg_AX_dqPE5;
   assign dvdq_prev_vec_next_AY_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE5 : dvdq_prev_vec_reg_AY_dqPE5;
   assign dvdq_prev_vec_next_AZ_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE5 : dvdq_prev_vec_reg_AZ_dqPE5;
   assign dvdq_prev_vec_next_LX_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE5 : dvdq_prev_vec_reg_LX_dqPE5;
   assign dvdq_prev_vec_next_LY_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE5 : dvdq_prev_vec_reg_LY_dqPE5;
   assign dvdq_prev_vec_next_LZ_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE5 : dvdq_prev_vec_reg_LZ_dqPE5;
   // da prev
   assign dadq_prev_vec_next_AX_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE5 : dadq_prev_vec_reg_AX_dqPE5;
   assign dadq_prev_vec_next_AY_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE5 : dadq_prev_vec_reg_AY_dqPE5;
   assign dadq_prev_vec_next_AZ_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE5 : dadq_prev_vec_reg_AZ_dqPE5;
   assign dadq_prev_vec_next_LX_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE5 : dadq_prev_vec_reg_LX_dqPE5;
   assign dadq_prev_vec_next_LY_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE5 : dadq_prev_vec_reg_LY_dqPE5;
   assign dadq_prev_vec_next_LZ_dqPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE5 : dadq_prev_vec_reg_LZ_dqPE5;
   // dqPE6
   assign link_next_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqPE6 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqPE6 : link_reg_dqPE6;
   assign derv_next_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqPE6 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqPE6 : derv_reg_dqPE6;
   assign sinq_val_next_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqPE6 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqPE6 : sinq_val_reg_dqPE6;
   assign cosq_val_next_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqPE6 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqPE6 : cosq_val_reg_dqPE6;
   assign qd_val_next_dqPE6   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqPE6 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqPE6 : qd_val_reg_dqPE6;
   // v curr
   assign v_curr_vec_next_AX_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE6 : v_curr_vec_reg_AX_dqPE6;
   assign v_curr_vec_next_AY_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE6 : v_curr_vec_reg_AY_dqPE6;
   assign v_curr_vec_next_AZ_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE6 : v_curr_vec_reg_AZ_dqPE6;
   assign v_curr_vec_next_LX_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE6 : v_curr_vec_reg_LX_dqPE6;
   assign v_curr_vec_next_LY_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE6 : v_curr_vec_reg_LY_dqPE6;
   assign v_curr_vec_next_LZ_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE6 : v_curr_vec_reg_LZ_dqPE6;
   // a curr
   assign a_curr_vec_next_AX_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE6 : a_curr_vec_reg_AX_dqPE6;
   assign a_curr_vec_next_AY_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE6 : a_curr_vec_reg_AY_dqPE6;
   assign a_curr_vec_next_AZ_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE6 : a_curr_vec_reg_AZ_dqPE6;
   assign a_curr_vec_next_LX_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE6 : a_curr_vec_reg_LX_dqPE6;
   assign a_curr_vec_next_LY_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE6 : a_curr_vec_reg_LY_dqPE6;
   assign a_curr_vec_next_LZ_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE6 : a_curr_vec_reg_LZ_dqPE6;
   // v prev
   assign v_prev_vec_next_AX_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE6 : v_prev_vec_reg_AX_dqPE6;
   assign v_prev_vec_next_AY_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE6 : v_prev_vec_reg_AY_dqPE6;
   assign v_prev_vec_next_AZ_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE6 : v_prev_vec_reg_AZ_dqPE6;
   assign v_prev_vec_next_LX_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE6 : v_prev_vec_reg_LX_dqPE6;
   assign v_prev_vec_next_LY_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE6 : v_prev_vec_reg_LY_dqPE6;
   assign v_prev_vec_next_LZ_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE6 : v_prev_vec_reg_LZ_dqPE6;
   // a prev
   assign a_prev_vec_next_AX_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE6 : a_prev_vec_reg_AX_dqPE6;
   assign a_prev_vec_next_AY_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE6 : a_prev_vec_reg_AY_dqPE6;
   assign a_prev_vec_next_AZ_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE6 : a_prev_vec_reg_AZ_dqPE6;
   assign a_prev_vec_next_LX_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE6 : a_prev_vec_reg_LX_dqPE6;
   assign a_prev_vec_next_LY_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE6 : a_prev_vec_reg_LY_dqPE6;
   assign a_prev_vec_next_LZ_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE6 : a_prev_vec_reg_LZ_dqPE6;
   // dv prev
   assign dvdq_prev_vec_next_AX_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE6 : dvdq_prev_vec_reg_AX_dqPE6;
   assign dvdq_prev_vec_next_AY_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE6 : dvdq_prev_vec_reg_AY_dqPE6;
   assign dvdq_prev_vec_next_AZ_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE6 : dvdq_prev_vec_reg_AZ_dqPE6;
   assign dvdq_prev_vec_next_LX_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE6 : dvdq_prev_vec_reg_LX_dqPE6;
   assign dvdq_prev_vec_next_LY_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE6 : dvdq_prev_vec_reg_LY_dqPE6;
   assign dvdq_prev_vec_next_LZ_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE6 : dvdq_prev_vec_reg_LZ_dqPE6;
   // da prev
   assign dadq_prev_vec_next_AX_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE6 : dadq_prev_vec_reg_AX_dqPE6;
   assign dadq_prev_vec_next_AY_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE6 : dadq_prev_vec_reg_AY_dqPE6;
   assign dadq_prev_vec_next_AZ_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE6 : dadq_prev_vec_reg_AZ_dqPE6;
   assign dadq_prev_vec_next_LX_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE6 : dadq_prev_vec_reg_LX_dqPE6;
   assign dadq_prev_vec_next_LY_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE6 : dadq_prev_vec_reg_LY_dqPE6;
   assign dadq_prev_vec_next_LZ_dqPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE6 : dadq_prev_vec_reg_LZ_dqPE6;
   // dqPE7
   assign link_next_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqPE7 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqPE7 : link_reg_dqPE7;
   assign derv_next_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqPE7 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqPE7 : derv_reg_dqPE7;
   assign sinq_val_next_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqPE7 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqPE7 : sinq_val_reg_dqPE7;
   assign cosq_val_next_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqPE7 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqPE7 : cosq_val_reg_dqPE7;
   assign qd_val_next_dqPE7   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqPE7 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqPE7 : qd_val_reg_dqPE7;
   // v curr
   assign v_curr_vec_next_AX_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqPE7 : v_curr_vec_reg_AX_dqPE7;
   assign v_curr_vec_next_AY_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqPE7 : v_curr_vec_reg_AY_dqPE7;
   assign v_curr_vec_next_AZ_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqPE7 : v_curr_vec_reg_AZ_dqPE7;
   assign v_curr_vec_next_LX_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqPE7 : v_curr_vec_reg_LX_dqPE7;
   assign v_curr_vec_next_LY_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqPE7 : v_curr_vec_reg_LY_dqPE7;
   assign v_curr_vec_next_LZ_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqPE7 : v_curr_vec_reg_LZ_dqPE7;
   // a curr
   assign a_curr_vec_next_AX_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqPE7 : a_curr_vec_reg_AX_dqPE7;
   assign a_curr_vec_next_AY_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqPE7 : a_curr_vec_reg_AY_dqPE7;
   assign a_curr_vec_next_AZ_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqPE7 : a_curr_vec_reg_AZ_dqPE7;
   assign a_curr_vec_next_LX_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqPE7 : a_curr_vec_reg_LX_dqPE7;
   assign a_curr_vec_next_LY_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqPE7 : a_curr_vec_reg_LY_dqPE7;
   assign a_curr_vec_next_LZ_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqPE7 : a_curr_vec_reg_LZ_dqPE7;
   // v prev
   assign v_prev_vec_next_AX_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AX_dqPE7 : v_prev_vec_reg_AX_dqPE7;
   assign v_prev_vec_next_AY_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AY_dqPE7 : v_prev_vec_reg_AY_dqPE7;
   assign v_prev_vec_next_AZ_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_AZ_dqPE7 : v_prev_vec_reg_AZ_dqPE7;
   assign v_prev_vec_next_LX_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LX_dqPE7 : v_prev_vec_reg_LX_dqPE7;
   assign v_prev_vec_next_LY_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LY_dqPE7 : v_prev_vec_reg_LY_dqPE7;
   assign v_prev_vec_next_LZ_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_prev_vec_in_LZ_dqPE7 : v_prev_vec_reg_LZ_dqPE7;
   // a prev
   assign a_prev_vec_next_AX_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AX_dqPE7 : a_prev_vec_reg_AX_dqPE7;
   assign a_prev_vec_next_AY_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AY_dqPE7 : a_prev_vec_reg_AY_dqPE7;
   assign a_prev_vec_next_AZ_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_AZ_dqPE7 : a_prev_vec_reg_AZ_dqPE7;
   assign a_prev_vec_next_LX_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LX_dqPE7 : a_prev_vec_reg_LX_dqPE7;
   assign a_prev_vec_next_LY_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LY_dqPE7 : a_prev_vec_reg_LY_dqPE7;
   assign a_prev_vec_next_LZ_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_prev_vec_in_LZ_dqPE7 : a_prev_vec_reg_LZ_dqPE7;
   // dv prev
   assign dvdq_prev_vec_next_AX_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AX_dqPE7 : dvdq_prev_vec_reg_AX_dqPE7;
   assign dvdq_prev_vec_next_AY_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AY_dqPE7 : dvdq_prev_vec_reg_AY_dqPE7;
   assign dvdq_prev_vec_next_AZ_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_AZ_dqPE7 : dvdq_prev_vec_reg_AZ_dqPE7;
   assign dvdq_prev_vec_next_LX_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LX_dqPE7 : dvdq_prev_vec_reg_LX_dqPE7;
   assign dvdq_prev_vec_next_LY_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LY_dqPE7 : dvdq_prev_vec_reg_LY_dqPE7;
   assign dvdq_prev_vec_next_LZ_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdq_prev_vec_in_LZ_dqPE7 : dvdq_prev_vec_reg_LZ_dqPE7;
   // da prev
   assign dadq_prev_vec_next_AX_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AX_dqPE7 : dadq_prev_vec_reg_AX_dqPE7;
   assign dadq_prev_vec_next_AY_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AY_dqPE7 : dadq_prev_vec_reg_AY_dqPE7;
   assign dadq_prev_vec_next_AZ_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_AZ_dqPE7 : dadq_prev_vec_reg_AZ_dqPE7;
   assign dadq_prev_vec_next_LX_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LX_dqPE7 : dadq_prev_vec_reg_LX_dqPE7;
   assign dadq_prev_vec_next_LY_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LY_dqPE7 : dadq_prev_vec_reg_LY_dqPE7;
   assign dadq_prev_vec_next_LZ_dqPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadq_prev_vec_in_LZ_dqPE7 : dadq_prev_vec_reg_LZ_dqPE7;
   //---------------------------------------------------------------------------
   // dqd external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   assign link_next_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqdPE1 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqdPE1 : link_reg_dqdPE1;
   assign derv_next_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqdPE1 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqdPE1 : derv_reg_dqdPE1;
   assign sinq_val_next_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqdPE1 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqdPE1 : sinq_val_reg_dqdPE1;
   assign cosq_val_next_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqdPE1 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqdPE1 : cosq_val_reg_dqdPE1;
   assign qd_val_next_dqdPE1   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqdPE1 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqdPE1 : qd_val_reg_dqdPE1;
   // v curr
   assign v_curr_vec_next_AX_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE1 : v_curr_vec_reg_AX_dqdPE1;
   assign v_curr_vec_next_AY_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE1 : v_curr_vec_reg_AY_dqdPE1;
   assign v_curr_vec_next_AZ_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE1 : v_curr_vec_reg_AZ_dqdPE1;
   assign v_curr_vec_next_LX_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE1 : v_curr_vec_reg_LX_dqdPE1;
   assign v_curr_vec_next_LY_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE1 : v_curr_vec_reg_LY_dqdPE1;
   assign v_curr_vec_next_LZ_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE1 : v_curr_vec_reg_LZ_dqdPE1;
   // a curr
   assign a_curr_vec_next_AX_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE1 : a_curr_vec_reg_AX_dqdPE1;
   assign a_curr_vec_next_AY_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE1 : a_curr_vec_reg_AY_dqdPE1;
   assign a_curr_vec_next_AZ_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE1 : a_curr_vec_reg_AZ_dqdPE1;
   assign a_curr_vec_next_LX_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE1 : a_curr_vec_reg_LX_dqdPE1;
   assign a_curr_vec_next_LY_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE1 : a_curr_vec_reg_LY_dqdPE1;
   assign a_curr_vec_next_LZ_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE1 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE1 : a_curr_vec_reg_LZ_dqdPE1;
   // dv prev
   assign dvdqd_prev_vec_next_AX_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE1 : dvdqd_prev_vec_reg_AX_dqdPE1;
   assign dvdqd_prev_vec_next_AY_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE1 : dvdqd_prev_vec_reg_AY_dqdPE1;
   assign dvdqd_prev_vec_next_AZ_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE1 : dvdqd_prev_vec_reg_AZ_dqdPE1;
   assign dvdqd_prev_vec_next_LX_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE1 : dvdqd_prev_vec_reg_LX_dqdPE1;
   assign dvdqd_prev_vec_next_LY_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE1 : dvdqd_prev_vec_reg_LY_dqdPE1;
   assign dvdqd_prev_vec_next_LZ_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE1 : dvdqd_prev_vec_reg_LZ_dqdPE1;
   // da prev
   assign dadqd_prev_vec_next_AX_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE1 : dadqd_prev_vec_reg_AX_dqdPE1;
   assign dadqd_prev_vec_next_AY_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE1 : dadqd_prev_vec_reg_AY_dqdPE1;
   assign dadqd_prev_vec_next_AZ_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE1 : dadqd_prev_vec_reg_AZ_dqdPE1;
   assign dadqd_prev_vec_next_LX_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE1 : dadqd_prev_vec_reg_LX_dqdPE1;
   assign dadqd_prev_vec_next_LY_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE1 : dadqd_prev_vec_reg_LY_dqdPE1;
   assign dadqd_prev_vec_next_LZ_dqdPE1 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE1 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE1 : dadqd_prev_vec_reg_LZ_dqdPE1;
   // dqdPE2
   assign link_next_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqdPE2 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqdPE2 : link_reg_dqdPE2;
   assign derv_next_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqdPE2 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqdPE2 : derv_reg_dqdPE2;
   assign sinq_val_next_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqdPE2 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqdPE2 : sinq_val_reg_dqdPE2;
   assign cosq_val_next_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqdPE2 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqdPE2 : cosq_val_reg_dqdPE2;
   assign qd_val_next_dqdPE2   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqdPE2 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqdPE2 : qd_val_reg_dqdPE2;
   // v curr
   assign v_curr_vec_next_AX_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE2 : v_curr_vec_reg_AX_dqdPE2;
   assign v_curr_vec_next_AY_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE2 : v_curr_vec_reg_AY_dqdPE2;
   assign v_curr_vec_next_AZ_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE2 : v_curr_vec_reg_AZ_dqdPE2;
   assign v_curr_vec_next_LX_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE2 : v_curr_vec_reg_LX_dqdPE2;
   assign v_curr_vec_next_LY_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE2 : v_curr_vec_reg_LY_dqdPE2;
   assign v_curr_vec_next_LZ_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE2 : v_curr_vec_reg_LZ_dqdPE2;
   // a curr
   assign a_curr_vec_next_AX_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE2 : a_curr_vec_reg_AX_dqdPE2;
   assign a_curr_vec_next_AY_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE2 : a_curr_vec_reg_AY_dqdPE2;
   assign a_curr_vec_next_AZ_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE2 : a_curr_vec_reg_AZ_dqdPE2;
   assign a_curr_vec_next_LX_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE2 : a_curr_vec_reg_LX_dqdPE2;
   assign a_curr_vec_next_LY_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE2 : a_curr_vec_reg_LY_dqdPE2;
   assign a_curr_vec_next_LZ_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE2 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE2 : a_curr_vec_reg_LZ_dqdPE2;
   // dv prev
   assign dvdqd_prev_vec_next_AX_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE2 : dvdqd_prev_vec_reg_AX_dqdPE2;
   assign dvdqd_prev_vec_next_AY_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE2 : dvdqd_prev_vec_reg_AY_dqdPE2;
   assign dvdqd_prev_vec_next_AZ_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE2 : dvdqd_prev_vec_reg_AZ_dqdPE2;
   assign dvdqd_prev_vec_next_LX_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE2 : dvdqd_prev_vec_reg_LX_dqdPE2;
   assign dvdqd_prev_vec_next_LY_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE2 : dvdqd_prev_vec_reg_LY_dqdPE2;
   assign dvdqd_prev_vec_next_LZ_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE2 : dvdqd_prev_vec_reg_LZ_dqdPE2;
   // da prev
   assign dadqd_prev_vec_next_AX_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE2 : dadqd_prev_vec_reg_AX_dqdPE2;
   assign dadqd_prev_vec_next_AY_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE2 : dadqd_prev_vec_reg_AY_dqdPE2;
   assign dadqd_prev_vec_next_AZ_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE2 : dadqd_prev_vec_reg_AZ_dqdPE2;
   assign dadqd_prev_vec_next_LX_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE2 : dadqd_prev_vec_reg_LX_dqdPE2;
   assign dadqd_prev_vec_next_LY_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE2 : dadqd_prev_vec_reg_LY_dqdPE2;
   assign dadqd_prev_vec_next_LZ_dqdPE2 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE2 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE2 : dadqd_prev_vec_reg_LZ_dqdPE2;
   // dqdPE3
   assign link_next_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqdPE3 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqdPE3 : link_reg_dqdPE3;
   assign derv_next_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqdPE3 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqdPE3 : derv_reg_dqdPE3;
   assign sinq_val_next_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqdPE3 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqdPE3 : sinq_val_reg_dqdPE3;
   assign cosq_val_next_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqdPE3 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqdPE3 : cosq_val_reg_dqdPE3;
   assign qd_val_next_dqdPE3   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqdPE3 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqdPE3 : qd_val_reg_dqdPE3;
   // v curr
   assign v_curr_vec_next_AX_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE3 : v_curr_vec_reg_AX_dqdPE3;
   assign v_curr_vec_next_AY_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE3 : v_curr_vec_reg_AY_dqdPE3;
   assign v_curr_vec_next_AZ_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE3 : v_curr_vec_reg_AZ_dqdPE3;
   assign v_curr_vec_next_LX_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE3 : v_curr_vec_reg_LX_dqdPE3;
   assign v_curr_vec_next_LY_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE3 : v_curr_vec_reg_LY_dqdPE3;
   assign v_curr_vec_next_LZ_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE3 : v_curr_vec_reg_LZ_dqdPE3;
   // a curr
   assign a_curr_vec_next_AX_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE3 : a_curr_vec_reg_AX_dqdPE3;
   assign a_curr_vec_next_AY_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE3 : a_curr_vec_reg_AY_dqdPE3;
   assign a_curr_vec_next_AZ_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE3 : a_curr_vec_reg_AZ_dqdPE3;
   assign a_curr_vec_next_LX_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE3 : a_curr_vec_reg_LX_dqdPE3;
   assign a_curr_vec_next_LY_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE3 : a_curr_vec_reg_LY_dqdPE3;
   assign a_curr_vec_next_LZ_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE3 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE3 : a_curr_vec_reg_LZ_dqdPE3;
   // dv prev
   assign dvdqd_prev_vec_next_AX_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE3 : dvdqd_prev_vec_reg_AX_dqdPE3;
   assign dvdqd_prev_vec_next_AY_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE3 : dvdqd_prev_vec_reg_AY_dqdPE3;
   assign dvdqd_prev_vec_next_AZ_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE3 : dvdqd_prev_vec_reg_AZ_dqdPE3;
   assign dvdqd_prev_vec_next_LX_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE3 : dvdqd_prev_vec_reg_LX_dqdPE3;
   assign dvdqd_prev_vec_next_LY_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE3 : dvdqd_prev_vec_reg_LY_dqdPE3;
   assign dvdqd_prev_vec_next_LZ_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE3 : dvdqd_prev_vec_reg_LZ_dqdPE3;
   // da prev
   assign dadqd_prev_vec_next_AX_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE3 : dadqd_prev_vec_reg_AX_dqdPE3;
   assign dadqd_prev_vec_next_AY_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE3 : dadqd_prev_vec_reg_AY_dqdPE3;
   assign dadqd_prev_vec_next_AZ_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE3 : dadqd_prev_vec_reg_AZ_dqdPE3;
   assign dadqd_prev_vec_next_LX_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE3 : dadqd_prev_vec_reg_LX_dqdPE3;
   assign dadqd_prev_vec_next_LY_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE3 : dadqd_prev_vec_reg_LY_dqdPE3;
   assign dadqd_prev_vec_next_LZ_dqdPE3 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE3 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE3 : dadqd_prev_vec_reg_LZ_dqdPE3;
   // dqdPE4
   assign link_next_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqdPE4 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqdPE4 : link_reg_dqdPE4;
   assign derv_next_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqdPE4 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqdPE4 : derv_reg_dqdPE4;
   assign sinq_val_next_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqdPE4 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqdPE4 : sinq_val_reg_dqdPE4;
   assign cosq_val_next_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqdPE4 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqdPE4 : cosq_val_reg_dqdPE4;
   assign qd_val_next_dqdPE4   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqdPE4 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqdPE4 : qd_val_reg_dqdPE4;
   // v curr
   assign v_curr_vec_next_AX_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE4 : v_curr_vec_reg_AX_dqdPE4;
   assign v_curr_vec_next_AY_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE4 : v_curr_vec_reg_AY_dqdPE4;
   assign v_curr_vec_next_AZ_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE4 : v_curr_vec_reg_AZ_dqdPE4;
   assign v_curr_vec_next_LX_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE4 : v_curr_vec_reg_LX_dqdPE4;
   assign v_curr_vec_next_LY_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE4 : v_curr_vec_reg_LY_dqdPE4;
   assign v_curr_vec_next_LZ_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE4 : v_curr_vec_reg_LZ_dqdPE4;
   // a curr
   assign a_curr_vec_next_AX_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE4 : a_curr_vec_reg_AX_dqdPE4;
   assign a_curr_vec_next_AY_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE4 : a_curr_vec_reg_AY_dqdPE4;
   assign a_curr_vec_next_AZ_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE4 : a_curr_vec_reg_AZ_dqdPE4;
   assign a_curr_vec_next_LX_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE4 : a_curr_vec_reg_LX_dqdPE4;
   assign a_curr_vec_next_LY_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE4 : a_curr_vec_reg_LY_dqdPE4;
   assign a_curr_vec_next_LZ_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE4 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE4 : a_curr_vec_reg_LZ_dqdPE4;
   // dv prev
   assign dvdqd_prev_vec_next_AX_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE4 : dvdqd_prev_vec_reg_AX_dqdPE4;
   assign dvdqd_prev_vec_next_AY_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE4 : dvdqd_prev_vec_reg_AY_dqdPE4;
   assign dvdqd_prev_vec_next_AZ_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE4 : dvdqd_prev_vec_reg_AZ_dqdPE4;
   assign dvdqd_prev_vec_next_LX_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE4 : dvdqd_prev_vec_reg_LX_dqdPE4;
   assign dvdqd_prev_vec_next_LY_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE4 : dvdqd_prev_vec_reg_LY_dqdPE4;
   assign dvdqd_prev_vec_next_LZ_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE4 : dvdqd_prev_vec_reg_LZ_dqdPE4;
   // da prev
   assign dadqd_prev_vec_next_AX_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE4 : dadqd_prev_vec_reg_AX_dqdPE4;
   assign dadqd_prev_vec_next_AY_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE4 : dadqd_prev_vec_reg_AY_dqdPE4;
   assign dadqd_prev_vec_next_AZ_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE4 : dadqd_prev_vec_reg_AZ_dqdPE4;
   assign dadqd_prev_vec_next_LX_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE4 : dadqd_prev_vec_reg_LX_dqdPE4;
   assign dadqd_prev_vec_next_LY_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE4 : dadqd_prev_vec_reg_LY_dqdPE4;
   assign dadqd_prev_vec_next_LZ_dqdPE4 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE4 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE4 : dadqd_prev_vec_reg_LZ_dqdPE4;
   // dqdPE5
   assign link_next_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqdPE5 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqdPE5 : link_reg_dqdPE5;
   assign derv_next_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqdPE5 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqdPE5 : derv_reg_dqdPE5;
   assign sinq_val_next_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqdPE5 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqdPE5 : sinq_val_reg_dqdPE5;
   assign cosq_val_next_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqdPE5 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqdPE5 : cosq_val_reg_dqdPE5;
   assign qd_val_next_dqdPE5   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqdPE5 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqdPE5 : qd_val_reg_dqdPE5;
   // v curr
   assign v_curr_vec_next_AX_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE5 : v_curr_vec_reg_AX_dqdPE5;
   assign v_curr_vec_next_AY_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE5 : v_curr_vec_reg_AY_dqdPE5;
   assign v_curr_vec_next_AZ_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE5 : v_curr_vec_reg_AZ_dqdPE5;
   assign v_curr_vec_next_LX_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE5 : v_curr_vec_reg_LX_dqdPE5;
   assign v_curr_vec_next_LY_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE5 : v_curr_vec_reg_LY_dqdPE5;
   assign v_curr_vec_next_LZ_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE5 : v_curr_vec_reg_LZ_dqdPE5;
   // a curr
   assign a_curr_vec_next_AX_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE5 : a_curr_vec_reg_AX_dqdPE5;
   assign a_curr_vec_next_AY_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE5 : a_curr_vec_reg_AY_dqdPE5;
   assign a_curr_vec_next_AZ_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE5 : a_curr_vec_reg_AZ_dqdPE5;
   assign a_curr_vec_next_LX_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE5 : a_curr_vec_reg_LX_dqdPE5;
   assign a_curr_vec_next_LY_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE5 : a_curr_vec_reg_LY_dqdPE5;
   assign a_curr_vec_next_LZ_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE5 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE5 : a_curr_vec_reg_LZ_dqdPE5;
   // dv prev
   assign dvdqd_prev_vec_next_AX_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE5 : dvdqd_prev_vec_reg_AX_dqdPE5;
   assign dvdqd_prev_vec_next_AY_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE5 : dvdqd_prev_vec_reg_AY_dqdPE5;
   assign dvdqd_prev_vec_next_AZ_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE5 : dvdqd_prev_vec_reg_AZ_dqdPE5;
   assign dvdqd_prev_vec_next_LX_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE5 : dvdqd_prev_vec_reg_LX_dqdPE5;
   assign dvdqd_prev_vec_next_LY_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE5 : dvdqd_prev_vec_reg_LY_dqdPE5;
   assign dvdqd_prev_vec_next_LZ_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE5 : dvdqd_prev_vec_reg_LZ_dqdPE5;
   // da prev
   assign dadqd_prev_vec_next_AX_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE5 : dadqd_prev_vec_reg_AX_dqdPE5;
   assign dadqd_prev_vec_next_AY_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE5 : dadqd_prev_vec_reg_AY_dqdPE5;
   assign dadqd_prev_vec_next_AZ_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE5 : dadqd_prev_vec_reg_AZ_dqdPE5;
   assign dadqd_prev_vec_next_LX_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE5 : dadqd_prev_vec_reg_LX_dqdPE5;
   assign dadqd_prev_vec_next_LY_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE5 : dadqd_prev_vec_reg_LY_dqdPE5;
   assign dadqd_prev_vec_next_LZ_dqdPE5 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE5 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE5 : dadqd_prev_vec_reg_LZ_dqdPE5;
   // dqdPE6
   assign link_next_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqdPE6 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqdPE6 : link_reg_dqdPE6;
   assign derv_next_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqdPE6 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqdPE6 : derv_reg_dqdPE6;
   assign sinq_val_next_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqdPE6 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqdPE6 : sinq_val_reg_dqdPE6;
   assign cosq_val_next_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqdPE6 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqdPE6 : cosq_val_reg_dqdPE6;
   assign qd_val_next_dqdPE6   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqdPE6 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqdPE6 : qd_val_reg_dqdPE6;
   // v curr
   assign v_curr_vec_next_AX_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE6 : v_curr_vec_reg_AX_dqdPE6;
   assign v_curr_vec_next_AY_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE6 : v_curr_vec_reg_AY_dqdPE6;
   assign v_curr_vec_next_AZ_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE6 : v_curr_vec_reg_AZ_dqdPE6;
   assign v_curr_vec_next_LX_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE6 : v_curr_vec_reg_LX_dqdPE6;
   assign v_curr_vec_next_LY_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE6 : v_curr_vec_reg_LY_dqdPE6;
   assign v_curr_vec_next_LZ_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE6 : v_curr_vec_reg_LZ_dqdPE6;
   // a curr
   assign a_curr_vec_next_AX_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE6 : a_curr_vec_reg_AX_dqdPE6;
   assign a_curr_vec_next_AY_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE6 : a_curr_vec_reg_AY_dqdPE6;
   assign a_curr_vec_next_AZ_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE6 : a_curr_vec_reg_AZ_dqdPE6;
   assign a_curr_vec_next_LX_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE6 : a_curr_vec_reg_LX_dqdPE6;
   assign a_curr_vec_next_LY_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE6 : a_curr_vec_reg_LY_dqdPE6;
   assign a_curr_vec_next_LZ_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE6 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE6 : a_curr_vec_reg_LZ_dqdPE6;
   // dv prev
   assign dvdqd_prev_vec_next_AX_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE6 : dvdqd_prev_vec_reg_AX_dqdPE6;
   assign dvdqd_prev_vec_next_AY_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE6 : dvdqd_prev_vec_reg_AY_dqdPE6;
   assign dvdqd_prev_vec_next_AZ_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE6 : dvdqd_prev_vec_reg_AZ_dqdPE6;
   assign dvdqd_prev_vec_next_LX_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE6 : dvdqd_prev_vec_reg_LX_dqdPE6;
   assign dvdqd_prev_vec_next_LY_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE6 : dvdqd_prev_vec_reg_LY_dqdPE6;
   assign dvdqd_prev_vec_next_LZ_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE6 : dvdqd_prev_vec_reg_LZ_dqdPE6;
   // da prev
   assign dadqd_prev_vec_next_AX_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE6 : dadqd_prev_vec_reg_AX_dqdPE6;
   assign dadqd_prev_vec_next_AY_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE6 : dadqd_prev_vec_reg_AY_dqdPE6;
   assign dadqd_prev_vec_next_AZ_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE6 : dadqd_prev_vec_reg_AZ_dqdPE6;
   assign dadqd_prev_vec_next_LX_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE6 : dadqd_prev_vec_reg_LX_dqdPE6;
   assign dadqd_prev_vec_next_LY_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE6 : dadqd_prev_vec_reg_LY_dqdPE6;
   assign dadqd_prev_vec_next_LZ_dqdPE6 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE6 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE6 : dadqd_prev_vec_reg_LZ_dqdPE6;
   // dqdPE7
   assign link_next_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? link_in_dqdPE7 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? link_in_dqdPE7 : link_reg_dqdPE7;
   assign derv_next_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? derv_in_dqdPE7 :
                            ((state_reg == 3'd3)&&(get_data == 1)) ? derv_in_dqdPE7 : derv_reg_dqdPE7;
   assign sinq_val_next_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? sinq_val_in_dqdPE7 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? sinq_val_in_dqdPE7 : sinq_val_reg_dqdPE7;
   assign cosq_val_next_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? cosq_val_in_dqdPE7 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? cosq_val_in_dqdPE7 : cosq_val_reg_dqdPE7;
   assign qd_val_next_dqdPE7   = ((state_reg == 3'd0)&&(get_data == 1)) ? qd_val_in_dqdPE7 :
                                ((state_reg == 3'd3)&&(get_data == 1)) ? qd_val_in_dqdPE7 : qd_val_reg_dqdPE7;
   // v curr
   assign v_curr_vec_next_AX_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AX_dqdPE7 : v_curr_vec_reg_AX_dqdPE7;
   assign v_curr_vec_next_AY_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AY_dqdPE7 : v_curr_vec_reg_AY_dqdPE7;
   assign v_curr_vec_next_AZ_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_AZ_dqdPE7 : v_curr_vec_reg_AZ_dqdPE7;
   assign v_curr_vec_next_LX_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LX_dqdPE7 : v_curr_vec_reg_LX_dqdPE7;
   assign v_curr_vec_next_LY_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LY_dqdPE7 : v_curr_vec_reg_LY_dqdPE7;
   assign v_curr_vec_next_LZ_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? v_curr_vec_in_LZ_dqdPE7 : v_curr_vec_reg_LZ_dqdPE7;
   // a curr
   assign a_curr_vec_next_AX_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AX_dqdPE7 : a_curr_vec_reg_AX_dqdPE7;
   assign a_curr_vec_next_AY_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AY_dqdPE7 : a_curr_vec_reg_AY_dqdPE7;
   assign a_curr_vec_next_AZ_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_AZ_dqdPE7 : a_curr_vec_reg_AZ_dqdPE7;
   assign a_curr_vec_next_LX_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LX_dqdPE7 : a_curr_vec_reg_LX_dqdPE7;
   assign a_curr_vec_next_LY_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LY_dqdPE7 : a_curr_vec_reg_LY_dqdPE7;
   assign a_curr_vec_next_LZ_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE7 :
                                     ((state_reg == 3'd3)&&(get_data == 1)) ? a_curr_vec_in_LZ_dqdPE7 : a_curr_vec_reg_LZ_dqdPE7;
   // dv prev
   assign dvdqd_prev_vec_next_AX_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AX_dqdPE7 : dvdqd_prev_vec_reg_AX_dqdPE7;
   assign dvdqd_prev_vec_next_AY_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AY_dqdPE7 : dvdqd_prev_vec_reg_AY_dqdPE7;
   assign dvdqd_prev_vec_next_AZ_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_AZ_dqdPE7 : dvdqd_prev_vec_reg_AZ_dqdPE7;
   assign dvdqd_prev_vec_next_LX_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LX_dqdPE7 : dvdqd_prev_vec_reg_LX_dqdPE7;
   assign dvdqd_prev_vec_next_LY_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LY_dqdPE7 : dvdqd_prev_vec_reg_LY_dqdPE7;
   assign dvdqd_prev_vec_next_LZ_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dvdqd_prev_vec_in_LZ_dqdPE7 : dvdqd_prev_vec_reg_LZ_dqdPE7;
   // da prev
   assign dadqd_prev_vec_next_AX_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AX_dqdPE7 : dadqd_prev_vec_reg_AX_dqdPE7;
   assign dadqd_prev_vec_next_AY_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AY_dqdPE7 : dadqd_prev_vec_reg_AY_dqdPE7;
   assign dadqd_prev_vec_next_AZ_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_AZ_dqdPE7 : dadqd_prev_vec_reg_AZ_dqdPE7;
   assign dadqd_prev_vec_next_LX_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LX_dqdPE7 : dadqd_prev_vec_reg_LX_dqdPE7;
   assign dadqd_prev_vec_next_LY_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LY_dqdPE7 : dadqd_prev_vec_reg_LY_dqdPE7;
   assign dadqd_prev_vec_next_LZ_dqdPE7 = ((state_reg == 3'd0)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE7 :
                                        ((state_reg == 3'd3)&&(get_data == 1)) ? dadqd_prev_vec_in_LZ_dqdPE7 : dadqd_prev_vec_reg_LZ_dqdPE7;
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
   // external registers
   //---------------------------------------------------------------------------
   always @ (posedge clk or posedge reset)
   begin
      if (reset)
      begin
         // inputs
         get_data_reg <= 0;
         // output
         output_ready_reg <= 0;
         dummy_output_reg <= 0;
         // state
         state_reg   <= 3'd0;
         s1_bool_reg <= 0;
         s2_bool_reg <= 0;
         s3_bool_reg <= 0;
         //---------------------------------------------------------------------
         // rnea external inputs
         //---------------------------------------------------------------------
         // rnea
         link_reg_rnea <= 3'd0;
         sinq_val_reg_rnea <= 32'd0;
         cosq_val_reg_rnea <= 32'd0;
         qd_val_reg_rnea   <= 32'd0;
         qdd_val_reg_rnea  <= 32'd0;
         // v prev
         v_prev_vec_reg_AX_rnea <= 32'd0;
         v_prev_vec_reg_AY_rnea <= 32'd0;
         v_prev_vec_reg_AZ_rnea <= 32'd0;
         v_prev_vec_reg_LX_rnea <= 32'd0;
         v_prev_vec_reg_LY_rnea <= 32'd0;
         v_prev_vec_reg_LZ_rnea <= 32'd0;
         // a prev
         a_prev_vec_reg_AX_rnea <= 32'd0;
         a_prev_vec_reg_AY_rnea <= 32'd0;
         a_prev_vec_reg_AZ_rnea <= 32'd0;
         a_prev_vec_reg_LX_rnea <= 32'd0;
         a_prev_vec_reg_LY_rnea <= 32'd0;
         a_prev_vec_reg_LZ_rnea <= 32'd0;
         //---------------------------------------------------------------------
         // dq external inputs
         //---------------------------------------------------------------------
         // dqPE1
         link_reg_dqPE1 <= 3'd0;
         derv_reg_dqPE1 <= 3'd0;
         sinq_val_reg_dqPE1 <= 32'd0;
         cosq_val_reg_dqPE1 <= 32'd0;
         qd_val_reg_dqPE1   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqPE1 <= 32'd0;
         v_curr_vec_reg_AY_dqPE1 <= 32'd0;
         v_curr_vec_reg_AZ_dqPE1 <= 32'd0;
         v_curr_vec_reg_LX_dqPE1 <= 32'd0;
         v_curr_vec_reg_LY_dqPE1 <= 32'd0;
         v_curr_vec_reg_LZ_dqPE1 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqPE1 <= 32'd0;
         a_curr_vec_reg_AY_dqPE1 <= 32'd0;
         a_curr_vec_reg_AZ_dqPE1 <= 32'd0;
         a_curr_vec_reg_LX_dqPE1 <= 32'd0;
         a_curr_vec_reg_LY_dqPE1 <= 32'd0;
         a_curr_vec_reg_LZ_dqPE1 <= 32'd0;
         // v prev
         v_prev_vec_reg_AX_dqPE1 <= 32'd0;
         v_prev_vec_reg_AY_dqPE1 <= 32'd0;
         v_prev_vec_reg_AZ_dqPE1 <= 32'd0;
         v_prev_vec_reg_LX_dqPE1 <= 32'd0;
         v_prev_vec_reg_LY_dqPE1 <= 32'd0;
         v_prev_vec_reg_LZ_dqPE1 <= 32'd0;
         // a prev
         a_prev_vec_reg_AX_dqPE1 <= 32'd0;
         a_prev_vec_reg_AY_dqPE1 <= 32'd0;
         a_prev_vec_reg_AZ_dqPE1 <= 32'd0;
         a_prev_vec_reg_LX_dqPE1 <= 32'd0;
         a_prev_vec_reg_LY_dqPE1 <= 32'd0;
         a_prev_vec_reg_LZ_dqPE1 <= 32'd0;
         // dv prev
         dvdq_prev_vec_reg_AX_dqPE1 <= 32'd0;
         dvdq_prev_vec_reg_AY_dqPE1 <= 32'd0;
         dvdq_prev_vec_reg_AZ_dqPE1 <= 32'd0;
         dvdq_prev_vec_reg_LX_dqPE1 <= 32'd0;
         dvdq_prev_vec_reg_LY_dqPE1 <= 32'd0;
         dvdq_prev_vec_reg_LZ_dqPE1 <= 32'd0;
         // da prev
         dadq_prev_vec_reg_AX_dqPE1 <= 32'd0;
         dadq_prev_vec_reg_AY_dqPE1 <= 32'd0;
         dadq_prev_vec_reg_AZ_dqPE1 <= 32'd0;
         dadq_prev_vec_reg_LX_dqPE1 <= 32'd0;
         dadq_prev_vec_reg_LY_dqPE1 <= 32'd0;
         dadq_prev_vec_reg_LZ_dqPE1 <= 32'd0;
         // dqPE2
         link_reg_dqPE2 <= 3'd0;
         derv_reg_dqPE2 <= 3'd0;
         sinq_val_reg_dqPE2 <= 32'd0;
         cosq_val_reg_dqPE2 <= 32'd0;
         qd_val_reg_dqPE2   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqPE2 <= 32'd0;
         v_curr_vec_reg_AY_dqPE2 <= 32'd0;
         v_curr_vec_reg_AZ_dqPE2 <= 32'd0;
         v_curr_vec_reg_LX_dqPE2 <= 32'd0;
         v_curr_vec_reg_LY_dqPE2 <= 32'd0;
         v_curr_vec_reg_LZ_dqPE2 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqPE2 <= 32'd0;
         a_curr_vec_reg_AY_dqPE2 <= 32'd0;
         a_curr_vec_reg_AZ_dqPE2 <= 32'd0;
         a_curr_vec_reg_LX_dqPE2 <= 32'd0;
         a_curr_vec_reg_LY_dqPE2 <= 32'd0;
         a_curr_vec_reg_LZ_dqPE2 <= 32'd0;
         // v prev
         v_prev_vec_reg_AX_dqPE2 <= 32'd0;
         v_prev_vec_reg_AY_dqPE2 <= 32'd0;
         v_prev_vec_reg_AZ_dqPE2 <= 32'd0;
         v_prev_vec_reg_LX_dqPE2 <= 32'd0;
         v_prev_vec_reg_LY_dqPE2 <= 32'd0;
         v_prev_vec_reg_LZ_dqPE2 <= 32'd0;
         // a prev
         a_prev_vec_reg_AX_dqPE2 <= 32'd0;
         a_prev_vec_reg_AY_dqPE2 <= 32'd0;
         a_prev_vec_reg_AZ_dqPE2 <= 32'd0;
         a_prev_vec_reg_LX_dqPE2 <= 32'd0;
         a_prev_vec_reg_LY_dqPE2 <= 32'd0;
         a_prev_vec_reg_LZ_dqPE2 <= 32'd0;
         // dv prev
         dvdq_prev_vec_reg_AX_dqPE2 <= 32'd0;
         dvdq_prev_vec_reg_AY_dqPE2 <= 32'd0;
         dvdq_prev_vec_reg_AZ_dqPE2 <= 32'd0;
         dvdq_prev_vec_reg_LX_dqPE2 <= 32'd0;
         dvdq_prev_vec_reg_LY_dqPE2 <= 32'd0;
         dvdq_prev_vec_reg_LZ_dqPE2 <= 32'd0;
         // da prev
         dadq_prev_vec_reg_AX_dqPE2 <= 32'd0;
         dadq_prev_vec_reg_AY_dqPE2 <= 32'd0;
         dadq_prev_vec_reg_AZ_dqPE2 <= 32'd0;
         dadq_prev_vec_reg_LX_dqPE2 <= 32'd0;
         dadq_prev_vec_reg_LY_dqPE2 <= 32'd0;
         dadq_prev_vec_reg_LZ_dqPE2 <= 32'd0;
         // dqPE3
         link_reg_dqPE3 <= 3'd0;
         derv_reg_dqPE3 <= 3'd0;
         sinq_val_reg_dqPE3 <= 32'd0;
         cosq_val_reg_dqPE3 <= 32'd0;
         qd_val_reg_dqPE3   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqPE3 <= 32'd0;
         v_curr_vec_reg_AY_dqPE3 <= 32'd0;
         v_curr_vec_reg_AZ_dqPE3 <= 32'd0;
         v_curr_vec_reg_LX_dqPE3 <= 32'd0;
         v_curr_vec_reg_LY_dqPE3 <= 32'd0;
         v_curr_vec_reg_LZ_dqPE3 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqPE3 <= 32'd0;
         a_curr_vec_reg_AY_dqPE3 <= 32'd0;
         a_curr_vec_reg_AZ_dqPE3 <= 32'd0;
         a_curr_vec_reg_LX_dqPE3 <= 32'd0;
         a_curr_vec_reg_LY_dqPE3 <= 32'd0;
         a_curr_vec_reg_LZ_dqPE3 <= 32'd0;
         // v prev
         v_prev_vec_reg_AX_dqPE3 <= 32'd0;
         v_prev_vec_reg_AY_dqPE3 <= 32'd0;
         v_prev_vec_reg_AZ_dqPE3 <= 32'd0;
         v_prev_vec_reg_LX_dqPE3 <= 32'd0;
         v_prev_vec_reg_LY_dqPE3 <= 32'd0;
         v_prev_vec_reg_LZ_dqPE3 <= 32'd0;
         // a prev
         a_prev_vec_reg_AX_dqPE3 <= 32'd0;
         a_prev_vec_reg_AY_dqPE3 <= 32'd0;
         a_prev_vec_reg_AZ_dqPE3 <= 32'd0;
         a_prev_vec_reg_LX_dqPE3 <= 32'd0;
         a_prev_vec_reg_LY_dqPE3 <= 32'd0;
         a_prev_vec_reg_LZ_dqPE3 <= 32'd0;
         // dv prev
         dvdq_prev_vec_reg_AX_dqPE3 <= 32'd0;
         dvdq_prev_vec_reg_AY_dqPE3 <= 32'd0;
         dvdq_prev_vec_reg_AZ_dqPE3 <= 32'd0;
         dvdq_prev_vec_reg_LX_dqPE3 <= 32'd0;
         dvdq_prev_vec_reg_LY_dqPE3 <= 32'd0;
         dvdq_prev_vec_reg_LZ_dqPE3 <= 32'd0;
         // da prev
         dadq_prev_vec_reg_AX_dqPE3 <= 32'd0;
         dadq_prev_vec_reg_AY_dqPE3 <= 32'd0;
         dadq_prev_vec_reg_AZ_dqPE3 <= 32'd0;
         dadq_prev_vec_reg_LX_dqPE3 <= 32'd0;
         dadq_prev_vec_reg_LY_dqPE3 <= 32'd0;
         dadq_prev_vec_reg_LZ_dqPE3 <= 32'd0;
         // dqPE4
         link_reg_dqPE4 <= 3'd0;
         derv_reg_dqPE4 <= 3'd0;
         sinq_val_reg_dqPE4 <= 32'd0;
         cosq_val_reg_dqPE4 <= 32'd0;
         qd_val_reg_dqPE4   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqPE4 <= 32'd0;
         v_curr_vec_reg_AY_dqPE4 <= 32'd0;
         v_curr_vec_reg_AZ_dqPE4 <= 32'd0;
         v_curr_vec_reg_LX_dqPE4 <= 32'd0;
         v_curr_vec_reg_LY_dqPE4 <= 32'd0;
         v_curr_vec_reg_LZ_dqPE4 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqPE4 <= 32'd0;
         a_curr_vec_reg_AY_dqPE4 <= 32'd0;
         a_curr_vec_reg_AZ_dqPE4 <= 32'd0;
         a_curr_vec_reg_LX_dqPE4 <= 32'd0;
         a_curr_vec_reg_LY_dqPE4 <= 32'd0;
         a_curr_vec_reg_LZ_dqPE4 <= 32'd0;
         // v prev
         v_prev_vec_reg_AX_dqPE4 <= 32'd0;
         v_prev_vec_reg_AY_dqPE4 <= 32'd0;
         v_prev_vec_reg_AZ_dqPE4 <= 32'd0;
         v_prev_vec_reg_LX_dqPE4 <= 32'd0;
         v_prev_vec_reg_LY_dqPE4 <= 32'd0;
         v_prev_vec_reg_LZ_dqPE4 <= 32'd0;
         // a prev
         a_prev_vec_reg_AX_dqPE4 <= 32'd0;
         a_prev_vec_reg_AY_dqPE4 <= 32'd0;
         a_prev_vec_reg_AZ_dqPE4 <= 32'd0;
         a_prev_vec_reg_LX_dqPE4 <= 32'd0;
         a_prev_vec_reg_LY_dqPE4 <= 32'd0;
         a_prev_vec_reg_LZ_dqPE4 <= 32'd0;
         // dv prev
         dvdq_prev_vec_reg_AX_dqPE4 <= 32'd0;
         dvdq_prev_vec_reg_AY_dqPE4 <= 32'd0;
         dvdq_prev_vec_reg_AZ_dqPE4 <= 32'd0;
         dvdq_prev_vec_reg_LX_dqPE4 <= 32'd0;
         dvdq_prev_vec_reg_LY_dqPE4 <= 32'd0;
         dvdq_prev_vec_reg_LZ_dqPE4 <= 32'd0;
         // da prev
         dadq_prev_vec_reg_AX_dqPE4 <= 32'd0;
         dadq_prev_vec_reg_AY_dqPE4 <= 32'd0;
         dadq_prev_vec_reg_AZ_dqPE4 <= 32'd0;
         dadq_prev_vec_reg_LX_dqPE4 <= 32'd0;
         dadq_prev_vec_reg_LY_dqPE4 <= 32'd0;
         dadq_prev_vec_reg_LZ_dqPE4 <= 32'd0;
         // dqPE5
         link_reg_dqPE5 <= 3'd0;
         derv_reg_dqPE5 <= 3'd0;
         sinq_val_reg_dqPE5 <= 32'd0;
         cosq_val_reg_dqPE5 <= 32'd0;
         qd_val_reg_dqPE5   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqPE5 <= 32'd0;
         v_curr_vec_reg_AY_dqPE5 <= 32'd0;
         v_curr_vec_reg_AZ_dqPE5 <= 32'd0;
         v_curr_vec_reg_LX_dqPE5 <= 32'd0;
         v_curr_vec_reg_LY_dqPE5 <= 32'd0;
         v_curr_vec_reg_LZ_dqPE5 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqPE5 <= 32'd0;
         a_curr_vec_reg_AY_dqPE5 <= 32'd0;
         a_curr_vec_reg_AZ_dqPE5 <= 32'd0;
         a_curr_vec_reg_LX_dqPE5 <= 32'd0;
         a_curr_vec_reg_LY_dqPE5 <= 32'd0;
         a_curr_vec_reg_LZ_dqPE5 <= 32'd0;
         // v prev
         v_prev_vec_reg_AX_dqPE5 <= 32'd0;
         v_prev_vec_reg_AY_dqPE5 <= 32'd0;
         v_prev_vec_reg_AZ_dqPE5 <= 32'd0;
         v_prev_vec_reg_LX_dqPE5 <= 32'd0;
         v_prev_vec_reg_LY_dqPE5 <= 32'd0;
         v_prev_vec_reg_LZ_dqPE5 <= 32'd0;
         // a prev
         a_prev_vec_reg_AX_dqPE5 <= 32'd0;
         a_prev_vec_reg_AY_dqPE5 <= 32'd0;
         a_prev_vec_reg_AZ_dqPE5 <= 32'd0;
         a_prev_vec_reg_LX_dqPE5 <= 32'd0;
         a_prev_vec_reg_LY_dqPE5 <= 32'd0;
         a_prev_vec_reg_LZ_dqPE5 <= 32'd0;
         // dv prev
         dvdq_prev_vec_reg_AX_dqPE5 <= 32'd0;
         dvdq_prev_vec_reg_AY_dqPE5 <= 32'd0;
         dvdq_prev_vec_reg_AZ_dqPE5 <= 32'd0;
         dvdq_prev_vec_reg_LX_dqPE5 <= 32'd0;
         dvdq_prev_vec_reg_LY_dqPE5 <= 32'd0;
         dvdq_prev_vec_reg_LZ_dqPE5 <= 32'd0;
         // da prev
         dadq_prev_vec_reg_AX_dqPE5 <= 32'd0;
         dadq_prev_vec_reg_AY_dqPE5 <= 32'd0;
         dadq_prev_vec_reg_AZ_dqPE5 <= 32'd0;
         dadq_prev_vec_reg_LX_dqPE5 <= 32'd0;
         dadq_prev_vec_reg_LY_dqPE5 <= 32'd0;
         dadq_prev_vec_reg_LZ_dqPE5 <= 32'd0;
         // dqPE6
         link_reg_dqPE6 <= 3'd0;
         derv_reg_dqPE6 <= 3'd0;
         sinq_val_reg_dqPE6 <= 32'd0;
         cosq_val_reg_dqPE6 <= 32'd0;
         qd_val_reg_dqPE6   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqPE6 <= 32'd0;
         v_curr_vec_reg_AY_dqPE6 <= 32'd0;
         v_curr_vec_reg_AZ_dqPE6 <= 32'd0;
         v_curr_vec_reg_LX_dqPE6 <= 32'd0;
         v_curr_vec_reg_LY_dqPE6 <= 32'd0;
         v_curr_vec_reg_LZ_dqPE6 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqPE6 <= 32'd0;
         a_curr_vec_reg_AY_dqPE6 <= 32'd0;
         a_curr_vec_reg_AZ_dqPE6 <= 32'd0;
         a_curr_vec_reg_LX_dqPE6 <= 32'd0;
         a_curr_vec_reg_LY_dqPE6 <= 32'd0;
         a_curr_vec_reg_LZ_dqPE6 <= 32'd0;
         // v prev
         v_prev_vec_reg_AX_dqPE6 <= 32'd0;
         v_prev_vec_reg_AY_dqPE6 <= 32'd0;
         v_prev_vec_reg_AZ_dqPE6 <= 32'd0;
         v_prev_vec_reg_LX_dqPE6 <= 32'd0;
         v_prev_vec_reg_LY_dqPE6 <= 32'd0;
         v_prev_vec_reg_LZ_dqPE6 <= 32'd0;
         // a prev
         a_prev_vec_reg_AX_dqPE6 <= 32'd0;
         a_prev_vec_reg_AY_dqPE6 <= 32'd0;
         a_prev_vec_reg_AZ_dqPE6 <= 32'd0;
         a_prev_vec_reg_LX_dqPE6 <= 32'd0;
         a_prev_vec_reg_LY_dqPE6 <= 32'd0;
         a_prev_vec_reg_LZ_dqPE6 <= 32'd0;
         // dv prev
         dvdq_prev_vec_reg_AX_dqPE6 <= 32'd0;
         dvdq_prev_vec_reg_AY_dqPE6 <= 32'd0;
         dvdq_prev_vec_reg_AZ_dqPE6 <= 32'd0;
         dvdq_prev_vec_reg_LX_dqPE6 <= 32'd0;
         dvdq_prev_vec_reg_LY_dqPE6 <= 32'd0;
         dvdq_prev_vec_reg_LZ_dqPE6 <= 32'd0;
         // da prev
         dadq_prev_vec_reg_AX_dqPE6 <= 32'd0;
         dadq_prev_vec_reg_AY_dqPE6 <= 32'd0;
         dadq_prev_vec_reg_AZ_dqPE6 <= 32'd0;
         dadq_prev_vec_reg_LX_dqPE6 <= 32'd0;
         dadq_prev_vec_reg_LY_dqPE6 <= 32'd0;
         dadq_prev_vec_reg_LZ_dqPE6 <= 32'd0;
         // dqPE7
         link_reg_dqPE7 <= 3'd0;
         derv_reg_dqPE7 <= 3'd0;
         sinq_val_reg_dqPE7 <= 32'd0;
         cosq_val_reg_dqPE7 <= 32'd0;
         qd_val_reg_dqPE7   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqPE7 <= 32'd0;
         v_curr_vec_reg_AY_dqPE7 <= 32'd0;
         v_curr_vec_reg_AZ_dqPE7 <= 32'd0;
         v_curr_vec_reg_LX_dqPE7 <= 32'd0;
         v_curr_vec_reg_LY_dqPE7 <= 32'd0;
         v_curr_vec_reg_LZ_dqPE7 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqPE7 <= 32'd0;
         a_curr_vec_reg_AY_dqPE7 <= 32'd0;
         a_curr_vec_reg_AZ_dqPE7 <= 32'd0;
         a_curr_vec_reg_LX_dqPE7 <= 32'd0;
         a_curr_vec_reg_LY_dqPE7 <= 32'd0;
         a_curr_vec_reg_LZ_dqPE7 <= 32'd0;
         // v prev
         v_prev_vec_reg_AX_dqPE7 <= 32'd0;
         v_prev_vec_reg_AY_dqPE7 <= 32'd0;
         v_prev_vec_reg_AZ_dqPE7 <= 32'd0;
         v_prev_vec_reg_LX_dqPE7 <= 32'd0;
         v_prev_vec_reg_LY_dqPE7 <= 32'd0;
         v_prev_vec_reg_LZ_dqPE7 <= 32'd0;
         // a prev
         a_prev_vec_reg_AX_dqPE7 <= 32'd0;
         a_prev_vec_reg_AY_dqPE7 <= 32'd0;
         a_prev_vec_reg_AZ_dqPE7 <= 32'd0;
         a_prev_vec_reg_LX_dqPE7 <= 32'd0;
         a_prev_vec_reg_LY_dqPE7 <= 32'd0;
         a_prev_vec_reg_LZ_dqPE7 <= 32'd0;
         // dv prev
         dvdq_prev_vec_reg_AX_dqPE7 <= 32'd0;
         dvdq_prev_vec_reg_AY_dqPE7 <= 32'd0;
         dvdq_prev_vec_reg_AZ_dqPE7 <= 32'd0;
         dvdq_prev_vec_reg_LX_dqPE7 <= 32'd0;
         dvdq_prev_vec_reg_LY_dqPE7 <= 32'd0;
         dvdq_prev_vec_reg_LZ_dqPE7 <= 32'd0;
         // da prev
         dadq_prev_vec_reg_AX_dqPE7 <= 32'd0;
         dadq_prev_vec_reg_AY_dqPE7 <= 32'd0;
         dadq_prev_vec_reg_AZ_dqPE7 <= 32'd0;
         dadq_prev_vec_reg_LX_dqPE7 <= 32'd0;
         dadq_prev_vec_reg_LY_dqPE7 <= 32'd0;
         dadq_prev_vec_reg_LZ_dqPE7 <= 32'd0;
         //---------------------------------------------------------------------
         // dqd external inputs
         //---------------------------------------------------------------------
         // dqdPE1
         link_reg_dqdPE1 <= 3'd0;
         derv_reg_dqdPE1 <= 3'd0;
         sinq_val_reg_dqdPE1 <= 32'd0;
         cosq_val_reg_dqdPE1 <= 32'd0;
         qd_val_reg_dqdPE1   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqdPE1 <= 32'd0;
         v_curr_vec_reg_AY_dqdPE1 <= 32'd0;
         v_curr_vec_reg_AZ_dqdPE1 <= 32'd0;
         v_curr_vec_reg_LX_dqdPE1 <= 32'd0;
         v_curr_vec_reg_LY_dqdPE1 <= 32'd0;
         v_curr_vec_reg_LZ_dqdPE1 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqdPE1 <= 32'd0;
         a_curr_vec_reg_AY_dqdPE1 <= 32'd0;
         a_curr_vec_reg_AZ_dqdPE1 <= 32'd0;
         a_curr_vec_reg_LX_dqdPE1 <= 32'd0;
         a_curr_vec_reg_LY_dqdPE1 <= 32'd0;
         a_curr_vec_reg_LZ_dqdPE1 <= 32'd0;
         // dv prev
         dvdqd_prev_vec_reg_AX_dqdPE1 <= 32'd0;
         dvdqd_prev_vec_reg_AY_dqdPE1 <= 32'd0;
         dvdqd_prev_vec_reg_AZ_dqdPE1 <= 32'd0;
         dvdqd_prev_vec_reg_LX_dqdPE1 <= 32'd0;
         dvdqd_prev_vec_reg_LY_dqdPE1 <= 32'd0;
         dvdqd_prev_vec_reg_LZ_dqdPE1 <= 32'd0;
         // da prev
         dadqd_prev_vec_reg_AX_dqdPE1 <= 32'd0;
         dadqd_prev_vec_reg_AY_dqdPE1 <= 32'd0;
         dadqd_prev_vec_reg_AZ_dqdPE1 <= 32'd0;
         dadqd_prev_vec_reg_LX_dqdPE1 <= 32'd0;
         dadqd_prev_vec_reg_LY_dqdPE1 <= 32'd0;
         dadqd_prev_vec_reg_LZ_dqdPE1 <= 32'd0;
         // dqdPE2
         link_reg_dqdPE2 <= 3'd0;
         derv_reg_dqdPE2 <= 3'd0;
         sinq_val_reg_dqdPE2 <= 32'd0;
         cosq_val_reg_dqdPE2 <= 32'd0;
         qd_val_reg_dqdPE2   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqdPE2 <= 32'd0;
         v_curr_vec_reg_AY_dqdPE2 <= 32'd0;
         v_curr_vec_reg_AZ_dqdPE2 <= 32'd0;
         v_curr_vec_reg_LX_dqdPE2 <= 32'd0;
         v_curr_vec_reg_LY_dqdPE2 <= 32'd0;
         v_curr_vec_reg_LZ_dqdPE2 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqdPE2 <= 32'd0;
         a_curr_vec_reg_AY_dqdPE2 <= 32'd0;
         a_curr_vec_reg_AZ_dqdPE2 <= 32'd0;
         a_curr_vec_reg_LX_dqdPE2 <= 32'd0;
         a_curr_vec_reg_LY_dqdPE2 <= 32'd0;
         a_curr_vec_reg_LZ_dqdPE2 <= 32'd0;
         // dv prev
         dvdqd_prev_vec_reg_AX_dqdPE2 <= 32'd0;
         dvdqd_prev_vec_reg_AY_dqdPE2 <= 32'd0;
         dvdqd_prev_vec_reg_AZ_dqdPE2 <= 32'd0;
         dvdqd_prev_vec_reg_LX_dqdPE2 <= 32'd0;
         dvdqd_prev_vec_reg_LY_dqdPE2 <= 32'd0;
         dvdqd_prev_vec_reg_LZ_dqdPE2 <= 32'd0;
         // da prev
         dadqd_prev_vec_reg_AX_dqdPE2 <= 32'd0;
         dadqd_prev_vec_reg_AY_dqdPE2 <= 32'd0;
         dadqd_prev_vec_reg_AZ_dqdPE2 <= 32'd0;
         dadqd_prev_vec_reg_LX_dqdPE2 <= 32'd0;
         dadqd_prev_vec_reg_LY_dqdPE2 <= 32'd0;
         dadqd_prev_vec_reg_LZ_dqdPE2 <= 32'd0;
         // dqdPE3
         link_reg_dqdPE3 <= 3'd0;
         derv_reg_dqdPE3 <= 3'd0;
         sinq_val_reg_dqdPE3 <= 32'd0;
         cosq_val_reg_dqdPE3 <= 32'd0;
         qd_val_reg_dqdPE3   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqdPE3 <= 32'd0;
         v_curr_vec_reg_AY_dqdPE3 <= 32'd0;
         v_curr_vec_reg_AZ_dqdPE3 <= 32'd0;
         v_curr_vec_reg_LX_dqdPE3 <= 32'd0;
         v_curr_vec_reg_LY_dqdPE3 <= 32'd0;
         v_curr_vec_reg_LZ_dqdPE3 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqdPE3 <= 32'd0;
         a_curr_vec_reg_AY_dqdPE3 <= 32'd0;
         a_curr_vec_reg_AZ_dqdPE3 <= 32'd0;
         a_curr_vec_reg_LX_dqdPE3 <= 32'd0;
         a_curr_vec_reg_LY_dqdPE3 <= 32'd0;
         a_curr_vec_reg_LZ_dqdPE3 <= 32'd0;
         // dv prev
         dvdqd_prev_vec_reg_AX_dqdPE3 <= 32'd0;
         dvdqd_prev_vec_reg_AY_dqdPE3 <= 32'd0;
         dvdqd_prev_vec_reg_AZ_dqdPE3 <= 32'd0;
         dvdqd_prev_vec_reg_LX_dqdPE3 <= 32'd0;
         dvdqd_prev_vec_reg_LY_dqdPE3 <= 32'd0;
         dvdqd_prev_vec_reg_LZ_dqdPE3 <= 32'd0;
         // da prev
         dadqd_prev_vec_reg_AX_dqdPE3 <= 32'd0;
         dadqd_prev_vec_reg_AY_dqdPE3 <= 32'd0;
         dadqd_prev_vec_reg_AZ_dqdPE3 <= 32'd0;
         dadqd_prev_vec_reg_LX_dqdPE3 <= 32'd0;
         dadqd_prev_vec_reg_LY_dqdPE3 <= 32'd0;
         dadqd_prev_vec_reg_LZ_dqdPE3 <= 32'd0;
         // dqdPE4
         link_reg_dqdPE4 <= 3'd0;
         derv_reg_dqdPE4 <= 3'd0;
         sinq_val_reg_dqdPE4 <= 32'd0;
         cosq_val_reg_dqdPE4 <= 32'd0;
         qd_val_reg_dqdPE4   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqdPE4 <= 32'd0;
         v_curr_vec_reg_AY_dqdPE4 <= 32'd0;
         v_curr_vec_reg_AZ_dqdPE4 <= 32'd0;
         v_curr_vec_reg_LX_dqdPE4 <= 32'd0;
         v_curr_vec_reg_LY_dqdPE4 <= 32'd0;
         v_curr_vec_reg_LZ_dqdPE4 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqdPE4 <= 32'd0;
         a_curr_vec_reg_AY_dqdPE4 <= 32'd0;
         a_curr_vec_reg_AZ_dqdPE4 <= 32'd0;
         a_curr_vec_reg_LX_dqdPE4 <= 32'd0;
         a_curr_vec_reg_LY_dqdPE4 <= 32'd0;
         a_curr_vec_reg_LZ_dqdPE4 <= 32'd0;
         // dv prev
         dvdqd_prev_vec_reg_AX_dqdPE4 <= 32'd0;
         dvdqd_prev_vec_reg_AY_dqdPE4 <= 32'd0;
         dvdqd_prev_vec_reg_AZ_dqdPE4 <= 32'd0;
         dvdqd_prev_vec_reg_LX_dqdPE4 <= 32'd0;
         dvdqd_prev_vec_reg_LY_dqdPE4 <= 32'd0;
         dvdqd_prev_vec_reg_LZ_dqdPE4 <= 32'd0;
         // da prev
         dadqd_prev_vec_reg_AX_dqdPE4 <= 32'd0;
         dadqd_prev_vec_reg_AY_dqdPE4 <= 32'd0;
         dadqd_prev_vec_reg_AZ_dqdPE4 <= 32'd0;
         dadqd_prev_vec_reg_LX_dqdPE4 <= 32'd0;
         dadqd_prev_vec_reg_LY_dqdPE4 <= 32'd0;
         dadqd_prev_vec_reg_LZ_dqdPE4 <= 32'd0;
         // dqdPE5
         link_reg_dqdPE5 <= 3'd0;
         derv_reg_dqdPE5 <= 3'd0;
         sinq_val_reg_dqdPE5 <= 32'd0;
         cosq_val_reg_dqdPE5 <= 32'd0;
         qd_val_reg_dqdPE5   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqdPE5 <= 32'd0;
         v_curr_vec_reg_AY_dqdPE5 <= 32'd0;
         v_curr_vec_reg_AZ_dqdPE5 <= 32'd0;
         v_curr_vec_reg_LX_dqdPE5 <= 32'd0;
         v_curr_vec_reg_LY_dqdPE5 <= 32'd0;
         v_curr_vec_reg_LZ_dqdPE5 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqdPE5 <= 32'd0;
         a_curr_vec_reg_AY_dqdPE5 <= 32'd0;
         a_curr_vec_reg_AZ_dqdPE5 <= 32'd0;
         a_curr_vec_reg_LX_dqdPE5 <= 32'd0;
         a_curr_vec_reg_LY_dqdPE5 <= 32'd0;
         a_curr_vec_reg_LZ_dqdPE5 <= 32'd0;
         // dv prev
         dvdqd_prev_vec_reg_AX_dqdPE5 <= 32'd0;
         dvdqd_prev_vec_reg_AY_dqdPE5 <= 32'd0;
         dvdqd_prev_vec_reg_AZ_dqdPE5 <= 32'd0;
         dvdqd_prev_vec_reg_LX_dqdPE5 <= 32'd0;
         dvdqd_prev_vec_reg_LY_dqdPE5 <= 32'd0;
         dvdqd_prev_vec_reg_LZ_dqdPE5 <= 32'd0;
         // da prev
         dadqd_prev_vec_reg_AX_dqdPE5 <= 32'd0;
         dadqd_prev_vec_reg_AY_dqdPE5 <= 32'd0;
         dadqd_prev_vec_reg_AZ_dqdPE5 <= 32'd0;
         dadqd_prev_vec_reg_LX_dqdPE5 <= 32'd0;
         dadqd_prev_vec_reg_LY_dqdPE5 <= 32'd0;
         dadqd_prev_vec_reg_LZ_dqdPE5 <= 32'd0;
         // dqdPE6
         link_reg_dqdPE6 <= 3'd0;
         derv_reg_dqdPE6 <= 3'd0;
         sinq_val_reg_dqdPE6 <= 32'd0;
         cosq_val_reg_dqdPE6 <= 32'd0;
         qd_val_reg_dqdPE6   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqdPE6 <= 32'd0;
         v_curr_vec_reg_AY_dqdPE6 <= 32'd0;
         v_curr_vec_reg_AZ_dqdPE6 <= 32'd0;
         v_curr_vec_reg_LX_dqdPE6 <= 32'd0;
         v_curr_vec_reg_LY_dqdPE6 <= 32'd0;
         v_curr_vec_reg_LZ_dqdPE6 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqdPE6 <= 32'd0;
         a_curr_vec_reg_AY_dqdPE6 <= 32'd0;
         a_curr_vec_reg_AZ_dqdPE6 <= 32'd0;
         a_curr_vec_reg_LX_dqdPE6 <= 32'd0;
         a_curr_vec_reg_LY_dqdPE6 <= 32'd0;
         a_curr_vec_reg_LZ_dqdPE6 <= 32'd0;
         // dv prev
         dvdqd_prev_vec_reg_AX_dqdPE6 <= 32'd0;
         dvdqd_prev_vec_reg_AY_dqdPE6 <= 32'd0;
         dvdqd_prev_vec_reg_AZ_dqdPE6 <= 32'd0;
         dvdqd_prev_vec_reg_LX_dqdPE6 <= 32'd0;
         dvdqd_prev_vec_reg_LY_dqdPE6 <= 32'd0;
         dvdqd_prev_vec_reg_LZ_dqdPE6 <= 32'd0;
         // da prev
         dadqd_prev_vec_reg_AX_dqdPE6 <= 32'd0;
         dadqd_prev_vec_reg_AY_dqdPE6 <= 32'd0;
         dadqd_prev_vec_reg_AZ_dqdPE6 <= 32'd0;
         dadqd_prev_vec_reg_LX_dqdPE6 <= 32'd0;
         dadqd_prev_vec_reg_LY_dqdPE6 <= 32'd0;
         dadqd_prev_vec_reg_LZ_dqdPE6 <= 32'd0;
         // dqdPE7
         link_reg_dqdPE7 <= 3'd0;
         derv_reg_dqdPE7 <= 3'd0;
         sinq_val_reg_dqdPE7 <= 32'd0;
         cosq_val_reg_dqdPE7 <= 32'd0;
         qd_val_reg_dqdPE7   <= 32'd0;
         // v curr
         v_curr_vec_reg_AX_dqdPE7 <= 32'd0;
         v_curr_vec_reg_AY_dqdPE7 <= 32'd0;
         v_curr_vec_reg_AZ_dqdPE7 <= 32'd0;
         v_curr_vec_reg_LX_dqdPE7 <= 32'd0;
         v_curr_vec_reg_LY_dqdPE7 <= 32'd0;
         v_curr_vec_reg_LZ_dqdPE7 <= 32'd0;
         // a curr
         a_curr_vec_reg_AX_dqdPE7 <= 32'd0;
         a_curr_vec_reg_AY_dqdPE7 <= 32'd0;
         a_curr_vec_reg_AZ_dqdPE7 <= 32'd0;
         a_curr_vec_reg_LX_dqdPE7 <= 32'd0;
         a_curr_vec_reg_LY_dqdPE7 <= 32'd0;
         a_curr_vec_reg_LZ_dqdPE7 <= 32'd0;
         // dv prev
         dvdqd_prev_vec_reg_AX_dqdPE7 <= 32'd0;
         dvdqd_prev_vec_reg_AY_dqdPE7 <= 32'd0;
         dvdqd_prev_vec_reg_AZ_dqdPE7 <= 32'd0;
         dvdqd_prev_vec_reg_LX_dqdPE7 <= 32'd0;
         dvdqd_prev_vec_reg_LY_dqdPE7 <= 32'd0;
         dvdqd_prev_vec_reg_LZ_dqdPE7 <= 32'd0;
         // da prev
         dadqd_prev_vec_reg_AX_dqdPE7 <= 32'd0;
         dadqd_prev_vec_reg_AY_dqdPE7 <= 32'd0;
         dadqd_prev_vec_reg_AZ_dqdPE7 <= 32'd0;
         dadqd_prev_vec_reg_LX_dqdPE7 <= 32'd0;
         dadqd_prev_vec_reg_LY_dqdPE7 <= 32'd0;
         dadqd_prev_vec_reg_LZ_dqdPE7 <= 32'd0;
         //---------------------------------------------------------------------
      end
      else
      begin
         // inputs
         get_data_reg <= get_data_next;
         // output
         output_ready_reg <= output_ready_next;
         dummy_output_reg <= dummy_output_next;
         // state
         state_reg   <= state_next;
         s1_bool_reg <= s1_bool_next;
         s2_bool_reg <= s2_bool_next;
         s3_bool_reg <= s3_bool_next;
         //---------------------------------------------------------------------
         // rnea external inputs
         //---------------------------------------------------------------------
         // rnea
         link_reg_rnea <= link_next_rnea;
         sinq_val_reg_rnea <= sinq_val_next_rnea;
         cosq_val_reg_rnea <= cosq_val_next_rnea;
         qd_val_reg_rnea   <= qd_val_next_rnea;
         qdd_val_reg_rnea  <= qdd_val_next_rnea;
         // v prev
         v_prev_vec_reg_AX_rnea <= v_prev_vec_next_AX_rnea;
         v_prev_vec_reg_AY_rnea <= v_prev_vec_next_AY_rnea;
         v_prev_vec_reg_AZ_rnea <= v_prev_vec_next_AZ_rnea;
         v_prev_vec_reg_LX_rnea <= v_prev_vec_next_LX_rnea;
         v_prev_vec_reg_LY_rnea <= v_prev_vec_next_LY_rnea;
         v_prev_vec_reg_LZ_rnea <= v_prev_vec_next_LZ_rnea;
         // a prev
         a_prev_vec_reg_AX_rnea <= a_prev_vec_next_AX_rnea;
         a_prev_vec_reg_AY_rnea <= a_prev_vec_next_AY_rnea;
         a_prev_vec_reg_AZ_rnea <= a_prev_vec_next_AZ_rnea;
         a_prev_vec_reg_LX_rnea <= a_prev_vec_next_LX_rnea;
         a_prev_vec_reg_LY_rnea <= a_prev_vec_next_LY_rnea;
         a_prev_vec_reg_LZ_rnea <= a_prev_vec_next_LZ_rnea;
         //---------------------------------------------------------------------
         // dq external inputs
         //---------------------------------------------------------------------
         // dqPE1
         link_reg_dqPE1 <= link_next_dqPE1;
         derv_reg_dqPE1 <= derv_next_dqPE1;
         sinq_val_reg_dqPE1 <= sinq_val_next_dqPE1;
         cosq_val_reg_dqPE1 <= cosq_val_next_dqPE1;
         qd_val_reg_dqPE1   <= qd_val_next_dqPE1;
         // v curr
         v_curr_vec_reg_AX_dqPE1 <= v_curr_vec_next_AX_dqPE1;
         v_curr_vec_reg_AY_dqPE1 <= v_curr_vec_next_AY_dqPE1;
         v_curr_vec_reg_AZ_dqPE1 <= v_curr_vec_next_AZ_dqPE1;
         v_curr_vec_reg_LX_dqPE1 <= v_curr_vec_next_LX_dqPE1;
         v_curr_vec_reg_LY_dqPE1 <= v_curr_vec_next_LY_dqPE1;
         v_curr_vec_reg_LZ_dqPE1 <= v_curr_vec_next_LZ_dqPE1;
         // a curr
         a_curr_vec_reg_AX_dqPE1 <= a_curr_vec_next_AX_dqPE1;
         a_curr_vec_reg_AY_dqPE1 <= a_curr_vec_next_AY_dqPE1;
         a_curr_vec_reg_AZ_dqPE1 <= a_curr_vec_next_AZ_dqPE1;
         a_curr_vec_reg_LX_dqPE1 <= a_curr_vec_next_LX_dqPE1;
         a_curr_vec_reg_LY_dqPE1 <= a_curr_vec_next_LY_dqPE1;
         a_curr_vec_reg_LZ_dqPE1 <= a_curr_vec_next_LZ_dqPE1;
         // v prev
         v_prev_vec_reg_AX_dqPE1 <= v_prev_vec_next_AX_dqPE1;
         v_prev_vec_reg_AY_dqPE1 <= v_prev_vec_next_AY_dqPE1;
         v_prev_vec_reg_AZ_dqPE1 <= v_prev_vec_next_AZ_dqPE1;
         v_prev_vec_reg_LX_dqPE1 <= v_prev_vec_next_LX_dqPE1;
         v_prev_vec_reg_LY_dqPE1 <= v_prev_vec_next_LY_dqPE1;
         v_prev_vec_reg_LZ_dqPE1 <= v_prev_vec_next_LZ_dqPE1;
         // a prev
         a_prev_vec_reg_AX_dqPE1 <= a_prev_vec_next_AX_dqPE1;
         a_prev_vec_reg_AY_dqPE1 <= a_prev_vec_next_AY_dqPE1;
         a_prev_vec_reg_AZ_dqPE1 <= a_prev_vec_next_AZ_dqPE1;
         a_prev_vec_reg_LX_dqPE1 <= a_prev_vec_next_LX_dqPE1;
         a_prev_vec_reg_LY_dqPE1 <= a_prev_vec_next_LY_dqPE1;
         a_prev_vec_reg_LZ_dqPE1 <= a_prev_vec_next_LZ_dqPE1;
         // v prev
         dvdq_prev_vec_reg_AX_dqPE1 <= dvdq_prev_vec_next_AX_dqPE1;
         dvdq_prev_vec_reg_AY_dqPE1 <= dvdq_prev_vec_next_AY_dqPE1;
         dvdq_prev_vec_reg_AZ_dqPE1 <= dvdq_prev_vec_next_AZ_dqPE1;
         dvdq_prev_vec_reg_LX_dqPE1 <= dvdq_prev_vec_next_LX_dqPE1;
         dvdq_prev_vec_reg_LY_dqPE1 <= dvdq_prev_vec_next_LY_dqPE1;
         dvdq_prev_vec_reg_LZ_dqPE1 <= dvdq_prev_vec_next_LZ_dqPE1;
         // a prev
         dadq_prev_vec_reg_AX_dqPE1 <= dadq_prev_vec_next_AX_dqPE1;
         dadq_prev_vec_reg_AY_dqPE1 <= dadq_prev_vec_next_AY_dqPE1;
         dadq_prev_vec_reg_AZ_dqPE1 <= dadq_prev_vec_next_AZ_dqPE1;
         dadq_prev_vec_reg_LX_dqPE1 <= dadq_prev_vec_next_LX_dqPE1;
         dadq_prev_vec_reg_LY_dqPE1 <= dadq_prev_vec_next_LY_dqPE1;
         dadq_prev_vec_reg_LZ_dqPE1 <= dadq_prev_vec_next_LZ_dqPE1;
         // dqPE2
         link_reg_dqPE2 <= link_next_dqPE2;
         derv_reg_dqPE2 <= derv_next_dqPE2;
         sinq_val_reg_dqPE2 <= sinq_val_next_dqPE2;
         cosq_val_reg_dqPE2 <= cosq_val_next_dqPE2;
         qd_val_reg_dqPE2   <= qd_val_next_dqPE2;
         // v curr
         v_curr_vec_reg_AX_dqPE2 <= v_curr_vec_next_AX_dqPE2;
         v_curr_vec_reg_AY_dqPE2 <= v_curr_vec_next_AY_dqPE2;
         v_curr_vec_reg_AZ_dqPE2 <= v_curr_vec_next_AZ_dqPE2;
         v_curr_vec_reg_LX_dqPE2 <= v_curr_vec_next_LX_dqPE2;
         v_curr_vec_reg_LY_dqPE2 <= v_curr_vec_next_LY_dqPE2;
         v_curr_vec_reg_LZ_dqPE2 <= v_curr_vec_next_LZ_dqPE2;
         // a curr
         a_curr_vec_reg_AX_dqPE2 <= a_curr_vec_next_AX_dqPE2;
         a_curr_vec_reg_AY_dqPE2 <= a_curr_vec_next_AY_dqPE2;
         a_curr_vec_reg_AZ_dqPE2 <= a_curr_vec_next_AZ_dqPE2;
         a_curr_vec_reg_LX_dqPE2 <= a_curr_vec_next_LX_dqPE2;
         a_curr_vec_reg_LY_dqPE2 <= a_curr_vec_next_LY_dqPE2;
         a_curr_vec_reg_LZ_dqPE2 <= a_curr_vec_next_LZ_dqPE2;
         // v prev
         v_prev_vec_reg_AX_dqPE2 <= v_prev_vec_next_AX_dqPE2;
         v_prev_vec_reg_AY_dqPE2 <= v_prev_vec_next_AY_dqPE2;
         v_prev_vec_reg_AZ_dqPE2 <= v_prev_vec_next_AZ_dqPE2;
         v_prev_vec_reg_LX_dqPE2 <= v_prev_vec_next_LX_dqPE2;
         v_prev_vec_reg_LY_dqPE2 <= v_prev_vec_next_LY_dqPE2;
         v_prev_vec_reg_LZ_dqPE2 <= v_prev_vec_next_LZ_dqPE2;
         // a prev
         a_prev_vec_reg_AX_dqPE2 <= a_prev_vec_next_AX_dqPE2;
         a_prev_vec_reg_AY_dqPE2 <= a_prev_vec_next_AY_dqPE2;
         a_prev_vec_reg_AZ_dqPE2 <= a_prev_vec_next_AZ_dqPE2;
         a_prev_vec_reg_LX_dqPE2 <= a_prev_vec_next_LX_dqPE2;
         a_prev_vec_reg_LY_dqPE2 <= a_prev_vec_next_LY_dqPE2;
         a_prev_vec_reg_LZ_dqPE2 <= a_prev_vec_next_LZ_dqPE2;
         // v prev
         dvdq_prev_vec_reg_AX_dqPE2 <= dvdq_prev_vec_next_AX_dqPE2;
         dvdq_prev_vec_reg_AY_dqPE2 <= dvdq_prev_vec_next_AY_dqPE2;
         dvdq_prev_vec_reg_AZ_dqPE2 <= dvdq_prev_vec_next_AZ_dqPE2;
         dvdq_prev_vec_reg_LX_dqPE2 <= dvdq_prev_vec_next_LX_dqPE2;
         dvdq_prev_vec_reg_LY_dqPE2 <= dvdq_prev_vec_next_LY_dqPE2;
         dvdq_prev_vec_reg_LZ_dqPE2 <= dvdq_prev_vec_next_LZ_dqPE2;
         // a prev
         dadq_prev_vec_reg_AX_dqPE2 <= dadq_prev_vec_next_AX_dqPE2;
         dadq_prev_vec_reg_AY_dqPE2 <= dadq_prev_vec_next_AY_dqPE2;
         dadq_prev_vec_reg_AZ_dqPE2 <= dadq_prev_vec_next_AZ_dqPE2;
         dadq_prev_vec_reg_LX_dqPE2 <= dadq_prev_vec_next_LX_dqPE2;
         dadq_prev_vec_reg_LY_dqPE2 <= dadq_prev_vec_next_LY_dqPE2;
         dadq_prev_vec_reg_LZ_dqPE2 <= dadq_prev_vec_next_LZ_dqPE2;
         // dqPE3
         link_reg_dqPE3 <= link_next_dqPE3;
         derv_reg_dqPE3 <= derv_next_dqPE3;
         sinq_val_reg_dqPE3 <= sinq_val_next_dqPE3;
         cosq_val_reg_dqPE3 <= cosq_val_next_dqPE3;
         qd_val_reg_dqPE3   <= qd_val_next_dqPE3;
         // v curr
         v_curr_vec_reg_AX_dqPE3 <= v_curr_vec_next_AX_dqPE3;
         v_curr_vec_reg_AY_dqPE3 <= v_curr_vec_next_AY_dqPE3;
         v_curr_vec_reg_AZ_dqPE3 <= v_curr_vec_next_AZ_dqPE3;
         v_curr_vec_reg_LX_dqPE3 <= v_curr_vec_next_LX_dqPE3;
         v_curr_vec_reg_LY_dqPE3 <= v_curr_vec_next_LY_dqPE3;
         v_curr_vec_reg_LZ_dqPE3 <= v_curr_vec_next_LZ_dqPE3;
         // a curr
         a_curr_vec_reg_AX_dqPE3 <= a_curr_vec_next_AX_dqPE3;
         a_curr_vec_reg_AY_dqPE3 <= a_curr_vec_next_AY_dqPE3;
         a_curr_vec_reg_AZ_dqPE3 <= a_curr_vec_next_AZ_dqPE3;
         a_curr_vec_reg_LX_dqPE3 <= a_curr_vec_next_LX_dqPE3;
         a_curr_vec_reg_LY_dqPE3 <= a_curr_vec_next_LY_dqPE3;
         a_curr_vec_reg_LZ_dqPE3 <= a_curr_vec_next_LZ_dqPE3;
         // v prev
         v_prev_vec_reg_AX_dqPE3 <= v_prev_vec_next_AX_dqPE3;
         v_prev_vec_reg_AY_dqPE3 <= v_prev_vec_next_AY_dqPE3;
         v_prev_vec_reg_AZ_dqPE3 <= v_prev_vec_next_AZ_dqPE3;
         v_prev_vec_reg_LX_dqPE3 <= v_prev_vec_next_LX_dqPE3;
         v_prev_vec_reg_LY_dqPE3 <= v_prev_vec_next_LY_dqPE3;
         v_prev_vec_reg_LZ_dqPE3 <= v_prev_vec_next_LZ_dqPE3;
         // a prev
         a_prev_vec_reg_AX_dqPE3 <= a_prev_vec_next_AX_dqPE3;
         a_prev_vec_reg_AY_dqPE3 <= a_prev_vec_next_AY_dqPE3;
         a_prev_vec_reg_AZ_dqPE3 <= a_prev_vec_next_AZ_dqPE3;
         a_prev_vec_reg_LX_dqPE3 <= a_prev_vec_next_LX_dqPE3;
         a_prev_vec_reg_LY_dqPE3 <= a_prev_vec_next_LY_dqPE3;
         a_prev_vec_reg_LZ_dqPE3 <= a_prev_vec_next_LZ_dqPE3;
         // v prev
         dvdq_prev_vec_reg_AX_dqPE3 <= dvdq_prev_vec_next_AX_dqPE3;
         dvdq_prev_vec_reg_AY_dqPE3 <= dvdq_prev_vec_next_AY_dqPE3;
         dvdq_prev_vec_reg_AZ_dqPE3 <= dvdq_prev_vec_next_AZ_dqPE3;
         dvdq_prev_vec_reg_LX_dqPE3 <= dvdq_prev_vec_next_LX_dqPE3;
         dvdq_prev_vec_reg_LY_dqPE3 <= dvdq_prev_vec_next_LY_dqPE3;
         dvdq_prev_vec_reg_LZ_dqPE3 <= dvdq_prev_vec_next_LZ_dqPE3;
         // a prev
         dadq_prev_vec_reg_AX_dqPE3 <= dadq_prev_vec_next_AX_dqPE3;
         dadq_prev_vec_reg_AY_dqPE3 <= dadq_prev_vec_next_AY_dqPE3;
         dadq_prev_vec_reg_AZ_dqPE3 <= dadq_prev_vec_next_AZ_dqPE3;
         dadq_prev_vec_reg_LX_dqPE3 <= dadq_prev_vec_next_LX_dqPE3;
         dadq_prev_vec_reg_LY_dqPE3 <= dadq_prev_vec_next_LY_dqPE3;
         dadq_prev_vec_reg_LZ_dqPE3 <= dadq_prev_vec_next_LZ_dqPE3;
         // dqPE4
         link_reg_dqPE4 <= link_next_dqPE4;
         derv_reg_dqPE4 <= derv_next_dqPE4;
         sinq_val_reg_dqPE4 <= sinq_val_next_dqPE4;
         cosq_val_reg_dqPE4 <= cosq_val_next_dqPE4;
         qd_val_reg_dqPE4   <= qd_val_next_dqPE4;
         // v curr
         v_curr_vec_reg_AX_dqPE4 <= v_curr_vec_next_AX_dqPE4;
         v_curr_vec_reg_AY_dqPE4 <= v_curr_vec_next_AY_dqPE4;
         v_curr_vec_reg_AZ_dqPE4 <= v_curr_vec_next_AZ_dqPE4;
         v_curr_vec_reg_LX_dqPE4 <= v_curr_vec_next_LX_dqPE4;
         v_curr_vec_reg_LY_dqPE4 <= v_curr_vec_next_LY_dqPE4;
         v_curr_vec_reg_LZ_dqPE4 <= v_curr_vec_next_LZ_dqPE4;
         // a curr
         a_curr_vec_reg_AX_dqPE4 <= a_curr_vec_next_AX_dqPE4;
         a_curr_vec_reg_AY_dqPE4 <= a_curr_vec_next_AY_dqPE4;
         a_curr_vec_reg_AZ_dqPE4 <= a_curr_vec_next_AZ_dqPE4;
         a_curr_vec_reg_LX_dqPE4 <= a_curr_vec_next_LX_dqPE4;
         a_curr_vec_reg_LY_dqPE4 <= a_curr_vec_next_LY_dqPE4;
         a_curr_vec_reg_LZ_dqPE4 <= a_curr_vec_next_LZ_dqPE4;
         // v prev
         v_prev_vec_reg_AX_dqPE4 <= v_prev_vec_next_AX_dqPE4;
         v_prev_vec_reg_AY_dqPE4 <= v_prev_vec_next_AY_dqPE4;
         v_prev_vec_reg_AZ_dqPE4 <= v_prev_vec_next_AZ_dqPE4;
         v_prev_vec_reg_LX_dqPE4 <= v_prev_vec_next_LX_dqPE4;
         v_prev_vec_reg_LY_dqPE4 <= v_prev_vec_next_LY_dqPE4;
         v_prev_vec_reg_LZ_dqPE4 <= v_prev_vec_next_LZ_dqPE4;
         // a prev
         a_prev_vec_reg_AX_dqPE4 <= a_prev_vec_next_AX_dqPE4;
         a_prev_vec_reg_AY_dqPE4 <= a_prev_vec_next_AY_dqPE4;
         a_prev_vec_reg_AZ_dqPE4 <= a_prev_vec_next_AZ_dqPE4;
         a_prev_vec_reg_LX_dqPE4 <= a_prev_vec_next_LX_dqPE4;
         a_prev_vec_reg_LY_dqPE4 <= a_prev_vec_next_LY_dqPE4;
         a_prev_vec_reg_LZ_dqPE4 <= a_prev_vec_next_LZ_dqPE4;
         // v prev
         dvdq_prev_vec_reg_AX_dqPE4 <= dvdq_prev_vec_next_AX_dqPE4;
         dvdq_prev_vec_reg_AY_dqPE4 <= dvdq_prev_vec_next_AY_dqPE4;
         dvdq_prev_vec_reg_AZ_dqPE4 <= dvdq_prev_vec_next_AZ_dqPE4;
         dvdq_prev_vec_reg_LX_dqPE4 <= dvdq_prev_vec_next_LX_dqPE4;
         dvdq_prev_vec_reg_LY_dqPE4 <= dvdq_prev_vec_next_LY_dqPE4;
         dvdq_prev_vec_reg_LZ_dqPE4 <= dvdq_prev_vec_next_LZ_dqPE4;
         // a prev
         dadq_prev_vec_reg_AX_dqPE4 <= dadq_prev_vec_next_AX_dqPE4;
         dadq_prev_vec_reg_AY_dqPE4 <= dadq_prev_vec_next_AY_dqPE4;
         dadq_prev_vec_reg_AZ_dqPE4 <= dadq_prev_vec_next_AZ_dqPE4;
         dadq_prev_vec_reg_LX_dqPE4 <= dadq_prev_vec_next_LX_dqPE4;
         dadq_prev_vec_reg_LY_dqPE4 <= dadq_prev_vec_next_LY_dqPE4;
         dadq_prev_vec_reg_LZ_dqPE4 <= dadq_prev_vec_next_LZ_dqPE4;
         // dqPE5
         link_reg_dqPE5 <= link_next_dqPE5;
         derv_reg_dqPE5 <= derv_next_dqPE5;
         sinq_val_reg_dqPE5 <= sinq_val_next_dqPE5;
         cosq_val_reg_dqPE5 <= cosq_val_next_dqPE5;
         qd_val_reg_dqPE5   <= qd_val_next_dqPE5;
         // v curr
         v_curr_vec_reg_AX_dqPE5 <= v_curr_vec_next_AX_dqPE5;
         v_curr_vec_reg_AY_dqPE5 <= v_curr_vec_next_AY_dqPE5;
         v_curr_vec_reg_AZ_dqPE5 <= v_curr_vec_next_AZ_dqPE5;
         v_curr_vec_reg_LX_dqPE5 <= v_curr_vec_next_LX_dqPE5;
         v_curr_vec_reg_LY_dqPE5 <= v_curr_vec_next_LY_dqPE5;
         v_curr_vec_reg_LZ_dqPE5 <= v_curr_vec_next_LZ_dqPE5;
         // a curr
         a_curr_vec_reg_AX_dqPE5 <= a_curr_vec_next_AX_dqPE5;
         a_curr_vec_reg_AY_dqPE5 <= a_curr_vec_next_AY_dqPE5;
         a_curr_vec_reg_AZ_dqPE5 <= a_curr_vec_next_AZ_dqPE5;
         a_curr_vec_reg_LX_dqPE5 <= a_curr_vec_next_LX_dqPE5;
         a_curr_vec_reg_LY_dqPE5 <= a_curr_vec_next_LY_dqPE5;
         a_curr_vec_reg_LZ_dqPE5 <= a_curr_vec_next_LZ_dqPE5;
         // v prev
         v_prev_vec_reg_AX_dqPE5 <= v_prev_vec_next_AX_dqPE5;
         v_prev_vec_reg_AY_dqPE5 <= v_prev_vec_next_AY_dqPE5;
         v_prev_vec_reg_AZ_dqPE5 <= v_prev_vec_next_AZ_dqPE5;
         v_prev_vec_reg_LX_dqPE5 <= v_prev_vec_next_LX_dqPE5;
         v_prev_vec_reg_LY_dqPE5 <= v_prev_vec_next_LY_dqPE5;
         v_prev_vec_reg_LZ_dqPE5 <= v_prev_vec_next_LZ_dqPE5;
         // a prev
         a_prev_vec_reg_AX_dqPE5 <= a_prev_vec_next_AX_dqPE5;
         a_prev_vec_reg_AY_dqPE5 <= a_prev_vec_next_AY_dqPE5;
         a_prev_vec_reg_AZ_dqPE5 <= a_prev_vec_next_AZ_dqPE5;
         a_prev_vec_reg_LX_dqPE5 <= a_prev_vec_next_LX_dqPE5;
         a_prev_vec_reg_LY_dqPE5 <= a_prev_vec_next_LY_dqPE5;
         a_prev_vec_reg_LZ_dqPE5 <= a_prev_vec_next_LZ_dqPE5;
         // v prev
         dvdq_prev_vec_reg_AX_dqPE5 <= dvdq_prev_vec_next_AX_dqPE5;
         dvdq_prev_vec_reg_AY_dqPE5 <= dvdq_prev_vec_next_AY_dqPE5;
         dvdq_prev_vec_reg_AZ_dqPE5 <= dvdq_prev_vec_next_AZ_dqPE5;
         dvdq_prev_vec_reg_LX_dqPE5 <= dvdq_prev_vec_next_LX_dqPE5;
         dvdq_prev_vec_reg_LY_dqPE5 <= dvdq_prev_vec_next_LY_dqPE5;
         dvdq_prev_vec_reg_LZ_dqPE5 <= dvdq_prev_vec_next_LZ_dqPE5;
         // a prev
         dadq_prev_vec_reg_AX_dqPE5 <= dadq_prev_vec_next_AX_dqPE5;
         dadq_prev_vec_reg_AY_dqPE5 <= dadq_prev_vec_next_AY_dqPE5;
         dadq_prev_vec_reg_AZ_dqPE5 <= dadq_prev_vec_next_AZ_dqPE5;
         dadq_prev_vec_reg_LX_dqPE5 <= dadq_prev_vec_next_LX_dqPE5;
         dadq_prev_vec_reg_LY_dqPE5 <= dadq_prev_vec_next_LY_dqPE5;
         dadq_prev_vec_reg_LZ_dqPE5 <= dadq_prev_vec_next_LZ_dqPE5;
         // dqPE6
         link_reg_dqPE6 <= link_next_dqPE6;
         derv_reg_dqPE6 <= derv_next_dqPE6;
         sinq_val_reg_dqPE6 <= sinq_val_next_dqPE6;
         cosq_val_reg_dqPE6 <= cosq_val_next_dqPE6;
         qd_val_reg_dqPE6   <= qd_val_next_dqPE6;
         // v curr
         v_curr_vec_reg_AX_dqPE6 <= v_curr_vec_next_AX_dqPE6;
         v_curr_vec_reg_AY_dqPE6 <= v_curr_vec_next_AY_dqPE6;
         v_curr_vec_reg_AZ_dqPE6 <= v_curr_vec_next_AZ_dqPE6;
         v_curr_vec_reg_LX_dqPE6 <= v_curr_vec_next_LX_dqPE6;
         v_curr_vec_reg_LY_dqPE6 <= v_curr_vec_next_LY_dqPE6;
         v_curr_vec_reg_LZ_dqPE6 <= v_curr_vec_next_LZ_dqPE6;
         // a curr
         a_curr_vec_reg_AX_dqPE6 <= a_curr_vec_next_AX_dqPE6;
         a_curr_vec_reg_AY_dqPE6 <= a_curr_vec_next_AY_dqPE6;
         a_curr_vec_reg_AZ_dqPE6 <= a_curr_vec_next_AZ_dqPE6;
         a_curr_vec_reg_LX_dqPE6 <= a_curr_vec_next_LX_dqPE6;
         a_curr_vec_reg_LY_dqPE6 <= a_curr_vec_next_LY_dqPE6;
         a_curr_vec_reg_LZ_dqPE6 <= a_curr_vec_next_LZ_dqPE6;
         // v prev
         v_prev_vec_reg_AX_dqPE6 <= v_prev_vec_next_AX_dqPE6;
         v_prev_vec_reg_AY_dqPE6 <= v_prev_vec_next_AY_dqPE6;
         v_prev_vec_reg_AZ_dqPE6 <= v_prev_vec_next_AZ_dqPE6;
         v_prev_vec_reg_LX_dqPE6 <= v_prev_vec_next_LX_dqPE6;
         v_prev_vec_reg_LY_dqPE6 <= v_prev_vec_next_LY_dqPE6;
         v_prev_vec_reg_LZ_dqPE6 <= v_prev_vec_next_LZ_dqPE6;
         // a prev
         a_prev_vec_reg_AX_dqPE6 <= a_prev_vec_next_AX_dqPE6;
         a_prev_vec_reg_AY_dqPE6 <= a_prev_vec_next_AY_dqPE6;
         a_prev_vec_reg_AZ_dqPE6 <= a_prev_vec_next_AZ_dqPE6;
         a_prev_vec_reg_LX_dqPE6 <= a_prev_vec_next_LX_dqPE6;
         a_prev_vec_reg_LY_dqPE6 <= a_prev_vec_next_LY_dqPE6;
         a_prev_vec_reg_LZ_dqPE6 <= a_prev_vec_next_LZ_dqPE6;
         // v prev
         dvdq_prev_vec_reg_AX_dqPE6 <= dvdq_prev_vec_next_AX_dqPE6;
         dvdq_prev_vec_reg_AY_dqPE6 <= dvdq_prev_vec_next_AY_dqPE6;
         dvdq_prev_vec_reg_AZ_dqPE6 <= dvdq_prev_vec_next_AZ_dqPE6;
         dvdq_prev_vec_reg_LX_dqPE6 <= dvdq_prev_vec_next_LX_dqPE6;
         dvdq_prev_vec_reg_LY_dqPE6 <= dvdq_prev_vec_next_LY_dqPE6;
         dvdq_prev_vec_reg_LZ_dqPE6 <= dvdq_prev_vec_next_LZ_dqPE6;
         // a prev
         dadq_prev_vec_reg_AX_dqPE6 <= dadq_prev_vec_next_AX_dqPE6;
         dadq_prev_vec_reg_AY_dqPE6 <= dadq_prev_vec_next_AY_dqPE6;
         dadq_prev_vec_reg_AZ_dqPE6 <= dadq_prev_vec_next_AZ_dqPE6;
         dadq_prev_vec_reg_LX_dqPE6 <= dadq_prev_vec_next_LX_dqPE6;
         dadq_prev_vec_reg_LY_dqPE6 <= dadq_prev_vec_next_LY_dqPE6;
         dadq_prev_vec_reg_LZ_dqPE6 <= dadq_prev_vec_next_LZ_dqPE6;
         // dqPE7
         link_reg_dqPE7 <= link_next_dqPE7;
         derv_reg_dqPE7 <= derv_next_dqPE7;
         sinq_val_reg_dqPE7 <= sinq_val_next_dqPE7;
         cosq_val_reg_dqPE7 <= cosq_val_next_dqPE7;
         qd_val_reg_dqPE7   <= qd_val_next_dqPE7;
         // v curr
         v_curr_vec_reg_AX_dqPE7 <= v_curr_vec_next_AX_dqPE7;
         v_curr_vec_reg_AY_dqPE7 <= v_curr_vec_next_AY_dqPE7;
         v_curr_vec_reg_AZ_dqPE7 <= v_curr_vec_next_AZ_dqPE7;
         v_curr_vec_reg_LX_dqPE7 <= v_curr_vec_next_LX_dqPE7;
         v_curr_vec_reg_LY_dqPE7 <= v_curr_vec_next_LY_dqPE7;
         v_curr_vec_reg_LZ_dqPE7 <= v_curr_vec_next_LZ_dqPE7;
         // a curr
         a_curr_vec_reg_AX_dqPE7 <= a_curr_vec_next_AX_dqPE7;
         a_curr_vec_reg_AY_dqPE7 <= a_curr_vec_next_AY_dqPE7;
         a_curr_vec_reg_AZ_dqPE7 <= a_curr_vec_next_AZ_dqPE7;
         a_curr_vec_reg_LX_dqPE7 <= a_curr_vec_next_LX_dqPE7;
         a_curr_vec_reg_LY_dqPE7 <= a_curr_vec_next_LY_dqPE7;
         a_curr_vec_reg_LZ_dqPE7 <= a_curr_vec_next_LZ_dqPE7;
         // v prev
         v_prev_vec_reg_AX_dqPE7 <= v_prev_vec_next_AX_dqPE7;
         v_prev_vec_reg_AY_dqPE7 <= v_prev_vec_next_AY_dqPE7;
         v_prev_vec_reg_AZ_dqPE7 <= v_prev_vec_next_AZ_dqPE7;
         v_prev_vec_reg_LX_dqPE7 <= v_prev_vec_next_LX_dqPE7;
         v_prev_vec_reg_LY_dqPE7 <= v_prev_vec_next_LY_dqPE7;
         v_prev_vec_reg_LZ_dqPE7 <= v_prev_vec_next_LZ_dqPE7;
         // a prev
         a_prev_vec_reg_AX_dqPE7 <= a_prev_vec_next_AX_dqPE7;
         a_prev_vec_reg_AY_dqPE7 <= a_prev_vec_next_AY_dqPE7;
         a_prev_vec_reg_AZ_dqPE7 <= a_prev_vec_next_AZ_dqPE7;
         a_prev_vec_reg_LX_dqPE7 <= a_prev_vec_next_LX_dqPE7;
         a_prev_vec_reg_LY_dqPE7 <= a_prev_vec_next_LY_dqPE7;
         a_prev_vec_reg_LZ_dqPE7 <= a_prev_vec_next_LZ_dqPE7;
         // v prev
         dvdq_prev_vec_reg_AX_dqPE7 <= dvdq_prev_vec_next_AX_dqPE7;
         dvdq_prev_vec_reg_AY_dqPE7 <= dvdq_prev_vec_next_AY_dqPE7;
         dvdq_prev_vec_reg_AZ_dqPE7 <= dvdq_prev_vec_next_AZ_dqPE7;
         dvdq_prev_vec_reg_LX_dqPE7 <= dvdq_prev_vec_next_LX_dqPE7;
         dvdq_prev_vec_reg_LY_dqPE7 <= dvdq_prev_vec_next_LY_dqPE7;
         dvdq_prev_vec_reg_LZ_dqPE7 <= dvdq_prev_vec_next_LZ_dqPE7;
         // a prev
         dadq_prev_vec_reg_AX_dqPE7 <= dadq_prev_vec_next_AX_dqPE7;
         dadq_prev_vec_reg_AY_dqPE7 <= dadq_prev_vec_next_AY_dqPE7;
         dadq_prev_vec_reg_AZ_dqPE7 <= dadq_prev_vec_next_AZ_dqPE7;
         dadq_prev_vec_reg_LX_dqPE7 <= dadq_prev_vec_next_LX_dqPE7;
         dadq_prev_vec_reg_LY_dqPE7 <= dadq_prev_vec_next_LY_dqPE7;
         dadq_prev_vec_reg_LZ_dqPE7 <= dadq_prev_vec_next_LZ_dqPE7;
         //---------------------------------------------------------------------
         // dqd external inputs
         //---------------------------------------------------------------------
         // dqdPE1
         link_reg_dqdPE1 <= link_next_dqdPE1;
         derv_reg_dqdPE1 <= derv_next_dqdPE1;
         sinq_val_reg_dqdPE1 <= sinq_val_next_dqdPE1;
         cosq_val_reg_dqdPE1 <= cosq_val_next_dqdPE1;
         qd_val_reg_dqdPE1   <= qd_val_next_dqdPE1;
         // v curr
         v_curr_vec_reg_AX_dqdPE1 <= v_curr_vec_next_AX_dqdPE1;
         v_curr_vec_reg_AY_dqdPE1 <= v_curr_vec_next_AY_dqdPE1;
         v_curr_vec_reg_AZ_dqdPE1 <= v_curr_vec_next_AZ_dqdPE1;
         v_curr_vec_reg_LX_dqdPE1 <= v_curr_vec_next_LX_dqdPE1;
         v_curr_vec_reg_LY_dqdPE1 <= v_curr_vec_next_LY_dqdPE1;
         v_curr_vec_reg_LZ_dqdPE1 <= v_curr_vec_next_LZ_dqdPE1;
         // a curr
         a_curr_vec_reg_AX_dqdPE1 <= a_curr_vec_next_AX_dqdPE1;
         a_curr_vec_reg_AY_dqdPE1 <= a_curr_vec_next_AY_dqdPE1;
         a_curr_vec_reg_AZ_dqdPE1 <= a_curr_vec_next_AZ_dqdPE1;
         a_curr_vec_reg_LX_dqdPE1 <= a_curr_vec_next_LX_dqdPE1;
         a_curr_vec_reg_LY_dqdPE1 <= a_curr_vec_next_LY_dqdPE1;
         a_curr_vec_reg_LZ_dqdPE1 <= a_curr_vec_next_LZ_dqdPE1;
         // v prev
         dvdqd_prev_vec_reg_AX_dqdPE1 <= dvdqd_prev_vec_next_AX_dqdPE1;
         dvdqd_prev_vec_reg_AY_dqdPE1 <= dvdqd_prev_vec_next_AY_dqdPE1;
         dvdqd_prev_vec_reg_AZ_dqdPE1 <= dvdqd_prev_vec_next_AZ_dqdPE1;
         dvdqd_prev_vec_reg_LX_dqdPE1 <= dvdqd_prev_vec_next_LX_dqdPE1;
         dvdqd_prev_vec_reg_LY_dqdPE1 <= dvdqd_prev_vec_next_LY_dqdPE1;
         dvdqd_prev_vec_reg_LZ_dqdPE1 <= dvdqd_prev_vec_next_LZ_dqdPE1;
         // a prev
         dadqd_prev_vec_reg_AX_dqdPE1 <= dadqd_prev_vec_next_AX_dqdPE1;
         dadqd_prev_vec_reg_AY_dqdPE1 <= dadqd_prev_vec_next_AY_dqdPE1;
         dadqd_prev_vec_reg_AZ_dqdPE1 <= dadqd_prev_vec_next_AZ_dqdPE1;
         dadqd_prev_vec_reg_LX_dqdPE1 <= dadqd_prev_vec_next_LX_dqdPE1;
         dadqd_prev_vec_reg_LY_dqdPE1 <= dadqd_prev_vec_next_LY_dqdPE1;
         dadqd_prev_vec_reg_LZ_dqdPE1 <= dadqd_prev_vec_next_LZ_dqdPE1;
         // dqdPE2
         link_reg_dqdPE2 <= link_next_dqdPE2;
         derv_reg_dqdPE2 <= derv_next_dqdPE2;
         sinq_val_reg_dqdPE2 <= sinq_val_next_dqdPE2;
         cosq_val_reg_dqdPE2 <= cosq_val_next_dqdPE2;
         qd_val_reg_dqdPE2   <= qd_val_next_dqdPE2;
         // v curr
         v_curr_vec_reg_AX_dqdPE2 <= v_curr_vec_next_AX_dqdPE2;
         v_curr_vec_reg_AY_dqdPE2 <= v_curr_vec_next_AY_dqdPE2;
         v_curr_vec_reg_AZ_dqdPE2 <= v_curr_vec_next_AZ_dqdPE2;
         v_curr_vec_reg_LX_dqdPE2 <= v_curr_vec_next_LX_dqdPE2;
         v_curr_vec_reg_LY_dqdPE2 <= v_curr_vec_next_LY_dqdPE2;
         v_curr_vec_reg_LZ_dqdPE2 <= v_curr_vec_next_LZ_dqdPE2;
         // a curr
         a_curr_vec_reg_AX_dqdPE2 <= a_curr_vec_next_AX_dqdPE2;
         a_curr_vec_reg_AY_dqdPE2 <= a_curr_vec_next_AY_dqdPE2;
         a_curr_vec_reg_AZ_dqdPE2 <= a_curr_vec_next_AZ_dqdPE2;
         a_curr_vec_reg_LX_dqdPE2 <= a_curr_vec_next_LX_dqdPE2;
         a_curr_vec_reg_LY_dqdPE2 <= a_curr_vec_next_LY_dqdPE2;
         a_curr_vec_reg_LZ_dqdPE2 <= a_curr_vec_next_LZ_dqdPE2;
         // v prev
         dvdqd_prev_vec_reg_AX_dqdPE2 <= dvdqd_prev_vec_next_AX_dqdPE2;
         dvdqd_prev_vec_reg_AY_dqdPE2 <= dvdqd_prev_vec_next_AY_dqdPE2;
         dvdqd_prev_vec_reg_AZ_dqdPE2 <= dvdqd_prev_vec_next_AZ_dqdPE2;
         dvdqd_prev_vec_reg_LX_dqdPE2 <= dvdqd_prev_vec_next_LX_dqdPE2;
         dvdqd_prev_vec_reg_LY_dqdPE2 <= dvdqd_prev_vec_next_LY_dqdPE2;
         dvdqd_prev_vec_reg_LZ_dqdPE2 <= dvdqd_prev_vec_next_LZ_dqdPE2;
         // a prev
         dadqd_prev_vec_reg_AX_dqdPE2 <= dadqd_prev_vec_next_AX_dqdPE2;
         dadqd_prev_vec_reg_AY_dqdPE2 <= dadqd_prev_vec_next_AY_dqdPE2;
         dadqd_prev_vec_reg_AZ_dqdPE2 <= dadqd_prev_vec_next_AZ_dqdPE2;
         dadqd_prev_vec_reg_LX_dqdPE2 <= dadqd_prev_vec_next_LX_dqdPE2;
         dadqd_prev_vec_reg_LY_dqdPE2 <= dadqd_prev_vec_next_LY_dqdPE2;
         dadqd_prev_vec_reg_LZ_dqdPE2 <= dadqd_prev_vec_next_LZ_dqdPE2;
         // dqdPE3
         link_reg_dqdPE3 <= link_next_dqdPE3;
         derv_reg_dqdPE3 <= derv_next_dqdPE3;
         sinq_val_reg_dqdPE3 <= sinq_val_next_dqdPE3;
         cosq_val_reg_dqdPE3 <= cosq_val_next_dqdPE3;
         qd_val_reg_dqdPE3   <= qd_val_next_dqdPE3;
         // v curr
         v_curr_vec_reg_AX_dqdPE3 <= v_curr_vec_next_AX_dqdPE3;
         v_curr_vec_reg_AY_dqdPE3 <= v_curr_vec_next_AY_dqdPE3;
         v_curr_vec_reg_AZ_dqdPE3 <= v_curr_vec_next_AZ_dqdPE3;
         v_curr_vec_reg_LX_dqdPE3 <= v_curr_vec_next_LX_dqdPE3;
         v_curr_vec_reg_LY_dqdPE3 <= v_curr_vec_next_LY_dqdPE3;
         v_curr_vec_reg_LZ_dqdPE3 <= v_curr_vec_next_LZ_dqdPE3;
         // a curr
         a_curr_vec_reg_AX_dqdPE3 <= a_curr_vec_next_AX_dqdPE3;
         a_curr_vec_reg_AY_dqdPE3 <= a_curr_vec_next_AY_dqdPE3;
         a_curr_vec_reg_AZ_dqdPE3 <= a_curr_vec_next_AZ_dqdPE3;
         a_curr_vec_reg_LX_dqdPE3 <= a_curr_vec_next_LX_dqdPE3;
         a_curr_vec_reg_LY_dqdPE3 <= a_curr_vec_next_LY_dqdPE3;
         a_curr_vec_reg_LZ_dqdPE3 <= a_curr_vec_next_LZ_dqdPE3;
         // v prev
         dvdqd_prev_vec_reg_AX_dqdPE3 <= dvdqd_prev_vec_next_AX_dqdPE3;
         dvdqd_prev_vec_reg_AY_dqdPE3 <= dvdqd_prev_vec_next_AY_dqdPE3;
         dvdqd_prev_vec_reg_AZ_dqdPE3 <= dvdqd_prev_vec_next_AZ_dqdPE3;
         dvdqd_prev_vec_reg_LX_dqdPE3 <= dvdqd_prev_vec_next_LX_dqdPE3;
         dvdqd_prev_vec_reg_LY_dqdPE3 <= dvdqd_prev_vec_next_LY_dqdPE3;
         dvdqd_prev_vec_reg_LZ_dqdPE3 <= dvdqd_prev_vec_next_LZ_dqdPE3;
         // a prev
         dadqd_prev_vec_reg_AX_dqdPE3 <= dadqd_prev_vec_next_AX_dqdPE3;
         dadqd_prev_vec_reg_AY_dqdPE3 <= dadqd_prev_vec_next_AY_dqdPE3;
         dadqd_prev_vec_reg_AZ_dqdPE3 <= dadqd_prev_vec_next_AZ_dqdPE3;
         dadqd_prev_vec_reg_LX_dqdPE3 <= dadqd_prev_vec_next_LX_dqdPE3;
         dadqd_prev_vec_reg_LY_dqdPE3 <= dadqd_prev_vec_next_LY_dqdPE3;
         dadqd_prev_vec_reg_LZ_dqdPE3 <= dadqd_prev_vec_next_LZ_dqdPE3;
         // dqdPE4
         link_reg_dqdPE4 <= link_next_dqdPE4;
         derv_reg_dqdPE4 <= derv_next_dqdPE4;
         sinq_val_reg_dqdPE4 <= sinq_val_next_dqdPE4;
         cosq_val_reg_dqdPE4 <= cosq_val_next_dqdPE4;
         qd_val_reg_dqdPE4   <= qd_val_next_dqdPE4;
         // v curr
         v_curr_vec_reg_AX_dqdPE4 <= v_curr_vec_next_AX_dqdPE4;
         v_curr_vec_reg_AY_dqdPE4 <= v_curr_vec_next_AY_dqdPE4;
         v_curr_vec_reg_AZ_dqdPE4 <= v_curr_vec_next_AZ_dqdPE4;
         v_curr_vec_reg_LX_dqdPE4 <= v_curr_vec_next_LX_dqdPE4;
         v_curr_vec_reg_LY_dqdPE4 <= v_curr_vec_next_LY_dqdPE4;
         v_curr_vec_reg_LZ_dqdPE4 <= v_curr_vec_next_LZ_dqdPE4;
         // a curr
         a_curr_vec_reg_AX_dqdPE4 <= a_curr_vec_next_AX_dqdPE4;
         a_curr_vec_reg_AY_dqdPE4 <= a_curr_vec_next_AY_dqdPE4;
         a_curr_vec_reg_AZ_dqdPE4 <= a_curr_vec_next_AZ_dqdPE4;
         a_curr_vec_reg_LX_dqdPE4 <= a_curr_vec_next_LX_dqdPE4;
         a_curr_vec_reg_LY_dqdPE4 <= a_curr_vec_next_LY_dqdPE4;
         a_curr_vec_reg_LZ_dqdPE4 <= a_curr_vec_next_LZ_dqdPE4;
         // v prev
         dvdqd_prev_vec_reg_AX_dqdPE4 <= dvdqd_prev_vec_next_AX_dqdPE4;
         dvdqd_prev_vec_reg_AY_dqdPE4 <= dvdqd_prev_vec_next_AY_dqdPE4;
         dvdqd_prev_vec_reg_AZ_dqdPE4 <= dvdqd_prev_vec_next_AZ_dqdPE4;
         dvdqd_prev_vec_reg_LX_dqdPE4 <= dvdqd_prev_vec_next_LX_dqdPE4;
         dvdqd_prev_vec_reg_LY_dqdPE4 <= dvdqd_prev_vec_next_LY_dqdPE4;
         dvdqd_prev_vec_reg_LZ_dqdPE4 <= dvdqd_prev_vec_next_LZ_dqdPE4;
         // a prev
         dadqd_prev_vec_reg_AX_dqdPE4 <= dadqd_prev_vec_next_AX_dqdPE4;
         dadqd_prev_vec_reg_AY_dqdPE4 <= dadqd_prev_vec_next_AY_dqdPE4;
         dadqd_prev_vec_reg_AZ_dqdPE4 <= dadqd_prev_vec_next_AZ_dqdPE4;
         dadqd_prev_vec_reg_LX_dqdPE4 <= dadqd_prev_vec_next_LX_dqdPE4;
         dadqd_prev_vec_reg_LY_dqdPE4 <= dadqd_prev_vec_next_LY_dqdPE4;
         dadqd_prev_vec_reg_LZ_dqdPE4 <= dadqd_prev_vec_next_LZ_dqdPE4;
         // dqdPE5
         link_reg_dqdPE5 <= link_next_dqdPE5;
         derv_reg_dqdPE5 <= derv_next_dqdPE5;
         sinq_val_reg_dqdPE5 <= sinq_val_next_dqdPE5;
         cosq_val_reg_dqdPE5 <= cosq_val_next_dqdPE5;
         qd_val_reg_dqdPE5   <= qd_val_next_dqdPE5;
         // v curr
         v_curr_vec_reg_AX_dqdPE5 <= v_curr_vec_next_AX_dqdPE5;
         v_curr_vec_reg_AY_dqdPE5 <= v_curr_vec_next_AY_dqdPE5;
         v_curr_vec_reg_AZ_dqdPE5 <= v_curr_vec_next_AZ_dqdPE5;
         v_curr_vec_reg_LX_dqdPE5 <= v_curr_vec_next_LX_dqdPE5;
         v_curr_vec_reg_LY_dqdPE5 <= v_curr_vec_next_LY_dqdPE5;
         v_curr_vec_reg_LZ_dqdPE5 <= v_curr_vec_next_LZ_dqdPE5;
         // a curr
         a_curr_vec_reg_AX_dqdPE5 <= a_curr_vec_next_AX_dqdPE5;
         a_curr_vec_reg_AY_dqdPE5 <= a_curr_vec_next_AY_dqdPE5;
         a_curr_vec_reg_AZ_dqdPE5 <= a_curr_vec_next_AZ_dqdPE5;
         a_curr_vec_reg_LX_dqdPE5 <= a_curr_vec_next_LX_dqdPE5;
         a_curr_vec_reg_LY_dqdPE5 <= a_curr_vec_next_LY_dqdPE5;
         a_curr_vec_reg_LZ_dqdPE5 <= a_curr_vec_next_LZ_dqdPE5;
         // v prev
         dvdqd_prev_vec_reg_AX_dqdPE5 <= dvdqd_prev_vec_next_AX_dqdPE5;
         dvdqd_prev_vec_reg_AY_dqdPE5 <= dvdqd_prev_vec_next_AY_dqdPE5;
         dvdqd_prev_vec_reg_AZ_dqdPE5 <= dvdqd_prev_vec_next_AZ_dqdPE5;
         dvdqd_prev_vec_reg_LX_dqdPE5 <= dvdqd_prev_vec_next_LX_dqdPE5;
         dvdqd_prev_vec_reg_LY_dqdPE5 <= dvdqd_prev_vec_next_LY_dqdPE5;
         dvdqd_prev_vec_reg_LZ_dqdPE5 <= dvdqd_prev_vec_next_LZ_dqdPE5;
         // a prev
         dadqd_prev_vec_reg_AX_dqdPE5 <= dadqd_prev_vec_next_AX_dqdPE5;
         dadqd_prev_vec_reg_AY_dqdPE5 <= dadqd_prev_vec_next_AY_dqdPE5;
         dadqd_prev_vec_reg_AZ_dqdPE5 <= dadqd_prev_vec_next_AZ_dqdPE5;
         dadqd_prev_vec_reg_LX_dqdPE5 <= dadqd_prev_vec_next_LX_dqdPE5;
         dadqd_prev_vec_reg_LY_dqdPE5 <= dadqd_prev_vec_next_LY_dqdPE5;
         dadqd_prev_vec_reg_LZ_dqdPE5 <= dadqd_prev_vec_next_LZ_dqdPE5;
         // dqdPE6
         link_reg_dqdPE6 <= link_next_dqdPE6;
         derv_reg_dqdPE6 <= derv_next_dqdPE6;
         sinq_val_reg_dqdPE6 <= sinq_val_next_dqdPE6;
         cosq_val_reg_dqdPE6 <= cosq_val_next_dqdPE6;
         qd_val_reg_dqdPE6   <= qd_val_next_dqdPE6;
         // v curr
         v_curr_vec_reg_AX_dqdPE6 <= v_curr_vec_next_AX_dqdPE6;
         v_curr_vec_reg_AY_dqdPE6 <= v_curr_vec_next_AY_dqdPE6;
         v_curr_vec_reg_AZ_dqdPE6 <= v_curr_vec_next_AZ_dqdPE6;
         v_curr_vec_reg_LX_dqdPE6 <= v_curr_vec_next_LX_dqdPE6;
         v_curr_vec_reg_LY_dqdPE6 <= v_curr_vec_next_LY_dqdPE6;
         v_curr_vec_reg_LZ_dqdPE6 <= v_curr_vec_next_LZ_dqdPE6;
         // a curr
         a_curr_vec_reg_AX_dqdPE6 <= a_curr_vec_next_AX_dqdPE6;
         a_curr_vec_reg_AY_dqdPE6 <= a_curr_vec_next_AY_dqdPE6;
         a_curr_vec_reg_AZ_dqdPE6 <= a_curr_vec_next_AZ_dqdPE6;
         a_curr_vec_reg_LX_dqdPE6 <= a_curr_vec_next_LX_dqdPE6;
         a_curr_vec_reg_LY_dqdPE6 <= a_curr_vec_next_LY_dqdPE6;
         a_curr_vec_reg_LZ_dqdPE6 <= a_curr_vec_next_LZ_dqdPE6;
         // v prev
         dvdqd_prev_vec_reg_AX_dqdPE6 <= dvdqd_prev_vec_next_AX_dqdPE6;
         dvdqd_prev_vec_reg_AY_dqdPE6 <= dvdqd_prev_vec_next_AY_dqdPE6;
         dvdqd_prev_vec_reg_AZ_dqdPE6 <= dvdqd_prev_vec_next_AZ_dqdPE6;
         dvdqd_prev_vec_reg_LX_dqdPE6 <= dvdqd_prev_vec_next_LX_dqdPE6;
         dvdqd_prev_vec_reg_LY_dqdPE6 <= dvdqd_prev_vec_next_LY_dqdPE6;
         dvdqd_prev_vec_reg_LZ_dqdPE6 <= dvdqd_prev_vec_next_LZ_dqdPE6;
         // a prev
         dadqd_prev_vec_reg_AX_dqdPE6 <= dadqd_prev_vec_next_AX_dqdPE6;
         dadqd_prev_vec_reg_AY_dqdPE6 <= dadqd_prev_vec_next_AY_dqdPE6;
         dadqd_prev_vec_reg_AZ_dqdPE6 <= dadqd_prev_vec_next_AZ_dqdPE6;
         dadqd_prev_vec_reg_LX_dqdPE6 <= dadqd_prev_vec_next_LX_dqdPE6;
         dadqd_prev_vec_reg_LY_dqdPE6 <= dadqd_prev_vec_next_LY_dqdPE6;
         dadqd_prev_vec_reg_LZ_dqdPE6 <= dadqd_prev_vec_next_LZ_dqdPE6;
         // dqdPE7
         link_reg_dqdPE7 <= link_next_dqdPE7;
         derv_reg_dqdPE7 <= derv_next_dqdPE7;
         sinq_val_reg_dqdPE7 <= sinq_val_next_dqdPE7;
         cosq_val_reg_dqdPE7 <= cosq_val_next_dqdPE7;
         qd_val_reg_dqdPE7   <= qd_val_next_dqdPE7;
         // v curr
         v_curr_vec_reg_AX_dqdPE7 <= v_curr_vec_next_AX_dqdPE7;
         v_curr_vec_reg_AY_dqdPE7 <= v_curr_vec_next_AY_dqdPE7;
         v_curr_vec_reg_AZ_dqdPE7 <= v_curr_vec_next_AZ_dqdPE7;
         v_curr_vec_reg_LX_dqdPE7 <= v_curr_vec_next_LX_dqdPE7;
         v_curr_vec_reg_LY_dqdPE7 <= v_curr_vec_next_LY_dqdPE7;
         v_curr_vec_reg_LZ_dqdPE7 <= v_curr_vec_next_LZ_dqdPE7;
         // a curr
         a_curr_vec_reg_AX_dqdPE7 <= a_curr_vec_next_AX_dqdPE7;
         a_curr_vec_reg_AY_dqdPE7 <= a_curr_vec_next_AY_dqdPE7;
         a_curr_vec_reg_AZ_dqdPE7 <= a_curr_vec_next_AZ_dqdPE7;
         a_curr_vec_reg_LX_dqdPE7 <= a_curr_vec_next_LX_dqdPE7;
         a_curr_vec_reg_LY_dqdPE7 <= a_curr_vec_next_LY_dqdPE7;
         a_curr_vec_reg_LZ_dqdPE7 <= a_curr_vec_next_LZ_dqdPE7;
         // v prev
         dvdqd_prev_vec_reg_AX_dqdPE7 <= dvdqd_prev_vec_next_AX_dqdPE7;
         dvdqd_prev_vec_reg_AY_dqdPE7 <= dvdqd_prev_vec_next_AY_dqdPE7;
         dvdqd_prev_vec_reg_AZ_dqdPE7 <= dvdqd_prev_vec_next_AZ_dqdPE7;
         dvdqd_prev_vec_reg_LX_dqdPE7 <= dvdqd_prev_vec_next_LX_dqdPE7;
         dvdqd_prev_vec_reg_LY_dqdPE7 <= dvdqd_prev_vec_next_LY_dqdPE7;
         dvdqd_prev_vec_reg_LZ_dqdPE7 <= dvdqd_prev_vec_next_LZ_dqdPE7;
         // a prev
         dadqd_prev_vec_reg_AX_dqdPE7 <= dadqd_prev_vec_next_AX_dqdPE7;
         dadqd_prev_vec_reg_AY_dqdPE7 <= dadqd_prev_vec_next_AY_dqdPE7;
         dadqd_prev_vec_reg_AZ_dqdPE7 <= dadqd_prev_vec_next_AZ_dqdPE7;
         dadqd_prev_vec_reg_LX_dqdPE7 <= dadqd_prev_vec_next_LX_dqdPE7;
         dadqd_prev_vec_reg_LY_dqdPE7 <= dadqd_prev_vec_next_LY_dqdPE7;
         dadqd_prev_vec_reg_LZ_dqdPE7 <= dadqd_prev_vec_next_LZ_dqdPE7;
         //---------------------------------------------------------------------
      end
   end

   //---------------------------------------------------------------------------
   // ID
   //---------------------------------------------------------------------------
   rneafpx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      rneafpi(
      // clock
      .clk(clk),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_rnea),
      // sin(q) and cos(q)
      .sinq_curr_in(sinq_val_reg_rnea),.cosq_curr_in(cosq_val_reg_rnea),
      // qd_curr_in
      .qd_curr_in(qd_val_reg_rnea),
      // qdd_curr_in
      .qdd_curr_in(qdd_val_reg_rnea),
      // v_prev_vec_in, 6 values
      .v_prev_vec_in_AX(v_prev_vec_reg_AX_rnea),.v_prev_vec_in_AY(v_prev_vec_reg_AY_rnea),.v_prev_vec_in_AZ(v_prev_vec_reg_AZ_rnea),.v_prev_vec_in_LX(v_prev_vec_reg_LX_rnea),.v_prev_vec_in_LY(v_prev_vec_reg_LY_rnea),.v_prev_vec_in_LZ(v_prev_vec_reg_LZ_rnea),
      // a_prev_vec_in, 6 values
      .a_prev_vec_in_AX(a_prev_vec_reg_AX_rnea),.a_prev_vec_in_AY(a_prev_vec_reg_AY_rnea),.a_prev_vec_in_AZ(a_prev_vec_reg_AZ_rnea),.a_prev_vec_in_LX(a_prev_vec_reg_LX_rnea),.a_prev_vec_in_LY(a_prev_vec_reg_LY_rnea),.a_prev_vec_in_LZ(a_prev_vec_reg_LZ_rnea),
      // v_curr_vec_out, 6 values
      .v_curr_vec_out_AX(v_curr_vec_out_AX_rnea),.v_curr_vec_out_AY(v_curr_vec_out_AY_rnea),.v_curr_vec_out_AZ(v_curr_vec_out_AZ_rnea),.v_curr_vec_out_LX(v_curr_vec_out_LX_rnea),.v_curr_vec_out_LY(v_curr_vec_out_LY_rnea),.v_curr_vec_out_LZ(v_curr_vec_out_LZ_rnea),
      // a_curr_vec_out, 6 values
      .a_curr_vec_out_AX(a_curr_vec_out_AX_rnea),.a_curr_vec_out_AY(a_curr_vec_out_AY_rnea),.a_curr_vec_out_AZ(a_curr_vec_out_AZ_rnea),.a_curr_vec_out_LX(a_curr_vec_out_LX_rnea),.a_curr_vec_out_LY(a_curr_vec_out_LY_rnea),.a_curr_vec_out_LZ(a_curr_vec_out_LZ_rnea),
      // f_curr_vec_out, 6 values
      .f_curr_vec_out_AX(f_curr_vec_out_AX_rnea),.f_curr_vec_out_AY(f_curr_vec_out_AY_rnea),.f_curr_vec_out_AZ(f_curr_vec_out_AZ_rnea),.f_curr_vec_out_LX(f_curr_vec_out_LX_rnea),.f_curr_vec_out_LY(f_curr_vec_out_LY_rnea),.f_curr_vec_out_LZ(f_curr_vec_out_LZ_rnea)
      );

   //---------------------------------------------------------------------------
   // dq external inputs
   //---------------------------------------------------------------------------
   // dqPE1
   wire mx_dqPE1;
   assign mx_dqPE1 = (link_reg_dqPE1 == derv_reg_dqPE1) ? 1 : 0;
   // dqPE2
   wire mx_dqPE2;
   assign mx_dqPE2 = (link_reg_dqPE2 == derv_reg_dqPE2) ? 1 : 0;
   // dqPE3
   wire mx_dqPE3;
   assign mx_dqPE3 = (link_reg_dqPE3 == derv_reg_dqPE3) ? 1 : 0;
   // dqPE4
   wire mx_dqPE4;
   assign mx_dqPE4 = (link_reg_dqPE4 == derv_reg_dqPE4) ? 1 : 0;
   // dqPE5
   wire mx_dqPE5;
   assign mx_dqPE5 = (link_reg_dqPE5 == derv_reg_dqPE5) ? 1 : 0;
   // dqPE6
   wire mx_dqPE6;
   assign mx_dqPE6 = (link_reg_dqPE6 == derv_reg_dqPE6) ? 1 : 0;
   // dqPE7
   wire mx_dqPE7;
   assign mx_dqPE7 = (link_reg_dqPE7 == derv_reg_dqPE7) ? 1 : 0;
   //---------------------------------------------------------------------------
   // dqd external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   wire mx_dqdPE1;
   assign mx_dqdPE1 = (link_reg_dqdPE1 == derv_reg_dqdPE1) ? 1 : 0;
   // dqdPE2
   wire mx_dqdPE2;
   assign mx_dqdPE2 = (link_reg_dqdPE2 == derv_reg_dqdPE2) ? 1 : 0;
   // dqdPE3
   wire mx_dqdPE3;
   assign mx_dqdPE3 = (link_reg_dqdPE3 == derv_reg_dqdPE3) ? 1 : 0;
   // dqdPE4
   wire mx_dqdPE4;
   assign mx_dqdPE4 = (link_reg_dqdPE4 == derv_reg_dqdPE4) ? 1 : 0;
   // dqdPE5
   wire mx_dqdPE5;
   assign mx_dqdPE5 = (link_reg_dqdPE5 == derv_reg_dqdPE5) ? 1 : 0;
   // dqdPE6
   wire mx_dqdPE6;
   assign mx_dqdPE6 = (link_reg_dqdPE6 == derv_reg_dqdPE6) ? 1 : 0;
   // dqdPE7
   wire mx_dqdPE7;
   assign mx_dqdPE7 = (link_reg_dqdPE7 == derv_reg_dqdPE7) ? 1 : 0;

   //---------------------------------------------------------------------------
   // dID/dq
   //---------------------------------------------------------------------------

   // dqPE1
   dqfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqfpi1(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqPE1),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqPE1),.cosq_val_in(cosq_val_reg_dqPE1),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqPE1),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqPE1),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqPE1),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqPE1),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqPE1),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqPE1),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqPE1),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqPE1),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqPE1),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqPE1),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqPE1),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqPE1),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqPE1),
      // v_vec_in, 6 values
      .v_prev_vec_in_AX(v_prev_vec_reg_AX_dqPE1),.v_prev_vec_in_AY(v_prev_vec_reg_AY_dqPE1),.v_prev_vec_in_AZ(v_prev_vec_reg_AZ_dqPE1),.v_prev_vec_in_LX(v_prev_vec_reg_LX_dqPE1),.v_prev_vec_in_LY(v_prev_vec_reg_LY_dqPE1),.v_prev_vec_in_LZ(v_prev_vec_reg_LZ_dqPE1),
      // a_vec_in, 6 values
      .a_prev_vec_in_AX(a_prev_vec_reg_AX_dqPE1),.a_prev_vec_in_AY(a_prev_vec_reg_AY_dqPE1),.a_prev_vec_in_AZ(a_prev_vec_reg_AZ_dqPE1),.a_prev_vec_in_LX(a_prev_vec_reg_LX_dqPE1),.a_prev_vec_in_LY(a_prev_vec_reg_LY_dqPE1),.a_prev_vec_in_LZ(a_prev_vec_reg_LZ_dqPE1),
      // v_vec_in, 6 values
      .dvdq_prev_vec_in_AX(dvdq_prev_vec_reg_AX_dqPE1),.dvdq_prev_vec_in_AY(dvdq_prev_vec_reg_AY_dqPE1),.dvdq_prev_vec_in_AZ(dvdq_prev_vec_reg_AZ_dqPE1),.dvdq_prev_vec_in_LX(dvdq_prev_vec_reg_LX_dqPE1),.dvdq_prev_vec_in_LY(dvdq_prev_vec_reg_LY_dqPE1),.dvdq_prev_vec_in_LZ(dvdq_prev_vec_reg_LZ_dqPE1),
      // a_vec_in, 6 values
      .dadq_prev_vec_in_AX(dadq_prev_vec_reg_AX_dqPE1),.dadq_prev_vec_in_AY(dadq_prev_vec_reg_AY_dqPE1),.dadq_prev_vec_in_AZ(dadq_prev_vec_reg_AZ_dqPE1),.dadq_prev_vec_in_LX(dadq_prev_vec_reg_LX_dqPE1),.dadq_prev_vec_in_LY(dadq_prev_vec_reg_LY_dqPE1),.dadq_prev_vec_in_LZ(dadq_prev_vec_reg_LZ_dqPE1),
      // mcross boolean
      .mcross(mx_dqPE1),
      // dvdq_vec_out, 6 values
      .dvdq_curr_vec_out_AX(dvdq_curr_vec_out_AX_dqPE1),.dvdq_curr_vec_out_AY(dvdq_curr_vec_out_AY_dqPE1),.dvdq_curr_vec_out_AZ(dvdq_curr_vec_out_AZ_dqPE1),.dvdq_curr_vec_out_LX(dvdq_curr_vec_out_LX_dqPE1),.dvdq_curr_vec_out_LY(dvdq_curr_vec_out_LY_dqPE1),.dvdq_curr_vec_out_LZ(dvdq_curr_vec_out_LZ_dqPE1),
      // dadq_vec_out, 6 values
      .dadq_curr_vec_out_AX(dadq_curr_vec_out_AX_dqPE1),.dadq_curr_vec_out_AY(dadq_curr_vec_out_AY_dqPE1),.dadq_curr_vec_out_AZ(dadq_curr_vec_out_AZ_dqPE1),.dadq_curr_vec_out_LX(dadq_curr_vec_out_LX_dqPE1),.dadq_curr_vec_out_LY(dadq_curr_vec_out_LY_dqPE1),.dadq_curr_vec_out_LZ(dadq_curr_vec_out_LZ_dqPE1),
      // dfdq_vec_out, 6 values
      .dfdq_curr_vec_out_AX(dfdq_curr_vec_out_AX_dqPE1),.dfdq_curr_vec_out_AY(dfdq_curr_vec_out_AY_dqPE1),.dfdq_curr_vec_out_AZ(dfdq_curr_vec_out_AZ_dqPE1),.dfdq_curr_vec_out_LX(dfdq_curr_vec_out_LX_dqPE1),.dfdq_curr_vec_out_LY(dfdq_curr_vec_out_LY_dqPE1),.dfdq_curr_vec_out_LZ(dfdq_curr_vec_out_LZ_dqPE1)
      );

   // dqPE2
   dqfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqfpi2(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqPE2),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqPE2),.cosq_val_in(cosq_val_reg_dqPE2),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqPE2),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqPE2),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqPE2),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqPE2),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqPE2),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqPE2),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqPE2),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqPE2),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqPE2),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqPE2),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqPE2),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqPE2),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqPE2),
      // v_vec_in, 6 values
      .v_prev_vec_in_AX(v_prev_vec_reg_AX_dqPE2),.v_prev_vec_in_AY(v_prev_vec_reg_AY_dqPE2),.v_prev_vec_in_AZ(v_prev_vec_reg_AZ_dqPE2),.v_prev_vec_in_LX(v_prev_vec_reg_LX_dqPE2),.v_prev_vec_in_LY(v_prev_vec_reg_LY_dqPE2),.v_prev_vec_in_LZ(v_prev_vec_reg_LZ_dqPE2),
      // a_vec_in, 6 values
      .a_prev_vec_in_AX(a_prev_vec_reg_AX_dqPE2),.a_prev_vec_in_AY(a_prev_vec_reg_AY_dqPE2),.a_prev_vec_in_AZ(a_prev_vec_reg_AZ_dqPE2),.a_prev_vec_in_LX(a_prev_vec_reg_LX_dqPE2),.a_prev_vec_in_LY(a_prev_vec_reg_LY_dqPE2),.a_prev_vec_in_LZ(a_prev_vec_reg_LZ_dqPE2),
      // v_vec_in, 6 values
      .dvdq_prev_vec_in_AX(dvdq_prev_vec_reg_AX_dqPE2),.dvdq_prev_vec_in_AY(dvdq_prev_vec_reg_AY_dqPE2),.dvdq_prev_vec_in_AZ(dvdq_prev_vec_reg_AZ_dqPE2),.dvdq_prev_vec_in_LX(dvdq_prev_vec_reg_LX_dqPE2),.dvdq_prev_vec_in_LY(dvdq_prev_vec_reg_LY_dqPE2),.dvdq_prev_vec_in_LZ(dvdq_prev_vec_reg_LZ_dqPE2),
      // a_vec_in, 6 values
      .dadq_prev_vec_in_AX(dadq_prev_vec_reg_AX_dqPE2),.dadq_prev_vec_in_AY(dadq_prev_vec_reg_AY_dqPE2),.dadq_prev_vec_in_AZ(dadq_prev_vec_reg_AZ_dqPE2),.dadq_prev_vec_in_LX(dadq_prev_vec_reg_LX_dqPE2),.dadq_prev_vec_in_LY(dadq_prev_vec_reg_LY_dqPE2),.dadq_prev_vec_in_LZ(dadq_prev_vec_reg_LZ_dqPE2),
      // mcross boolean
      .mcross(mx_dqPE2),
      // dvdq_vec_out, 6 values
      .dvdq_curr_vec_out_AX(dvdq_curr_vec_out_AX_dqPE2),.dvdq_curr_vec_out_AY(dvdq_curr_vec_out_AY_dqPE2),.dvdq_curr_vec_out_AZ(dvdq_curr_vec_out_AZ_dqPE2),.dvdq_curr_vec_out_LX(dvdq_curr_vec_out_LX_dqPE2),.dvdq_curr_vec_out_LY(dvdq_curr_vec_out_LY_dqPE2),.dvdq_curr_vec_out_LZ(dvdq_curr_vec_out_LZ_dqPE2),
      // dadq_vec_out, 6 values
      .dadq_curr_vec_out_AX(dadq_curr_vec_out_AX_dqPE2),.dadq_curr_vec_out_AY(dadq_curr_vec_out_AY_dqPE2),.dadq_curr_vec_out_AZ(dadq_curr_vec_out_AZ_dqPE2),.dadq_curr_vec_out_LX(dadq_curr_vec_out_LX_dqPE2),.dadq_curr_vec_out_LY(dadq_curr_vec_out_LY_dqPE2),.dadq_curr_vec_out_LZ(dadq_curr_vec_out_LZ_dqPE2),
      // dfdq_vec_out, 6 values
      .dfdq_curr_vec_out_AX(dfdq_curr_vec_out_AX_dqPE2),.dfdq_curr_vec_out_AY(dfdq_curr_vec_out_AY_dqPE2),.dfdq_curr_vec_out_AZ(dfdq_curr_vec_out_AZ_dqPE2),.dfdq_curr_vec_out_LX(dfdq_curr_vec_out_LX_dqPE2),.dfdq_curr_vec_out_LY(dfdq_curr_vec_out_LY_dqPE2),.dfdq_curr_vec_out_LZ(dfdq_curr_vec_out_LZ_dqPE2)
      );

   // dqPE3
   dqfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqfpi3(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqPE3),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqPE3),.cosq_val_in(cosq_val_reg_dqPE3),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqPE3),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqPE3),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqPE3),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqPE3),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqPE3),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqPE3),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqPE3),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqPE3),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqPE3),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqPE3),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqPE3),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqPE3),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqPE3),
      // v_vec_in, 6 values
      .v_prev_vec_in_AX(v_prev_vec_reg_AX_dqPE3),.v_prev_vec_in_AY(v_prev_vec_reg_AY_dqPE3),.v_prev_vec_in_AZ(v_prev_vec_reg_AZ_dqPE3),.v_prev_vec_in_LX(v_prev_vec_reg_LX_dqPE3),.v_prev_vec_in_LY(v_prev_vec_reg_LY_dqPE3),.v_prev_vec_in_LZ(v_prev_vec_reg_LZ_dqPE3),
      // a_vec_in, 6 values
      .a_prev_vec_in_AX(a_prev_vec_reg_AX_dqPE3),.a_prev_vec_in_AY(a_prev_vec_reg_AY_dqPE3),.a_prev_vec_in_AZ(a_prev_vec_reg_AZ_dqPE3),.a_prev_vec_in_LX(a_prev_vec_reg_LX_dqPE3),.a_prev_vec_in_LY(a_prev_vec_reg_LY_dqPE3),.a_prev_vec_in_LZ(a_prev_vec_reg_LZ_dqPE3),
      // v_vec_in, 6 values
      .dvdq_prev_vec_in_AX(dvdq_prev_vec_reg_AX_dqPE3),.dvdq_prev_vec_in_AY(dvdq_prev_vec_reg_AY_dqPE3),.dvdq_prev_vec_in_AZ(dvdq_prev_vec_reg_AZ_dqPE3),.dvdq_prev_vec_in_LX(dvdq_prev_vec_reg_LX_dqPE3),.dvdq_prev_vec_in_LY(dvdq_prev_vec_reg_LY_dqPE3),.dvdq_prev_vec_in_LZ(dvdq_prev_vec_reg_LZ_dqPE3),
      // a_vec_in, 6 values
      .dadq_prev_vec_in_AX(dadq_prev_vec_reg_AX_dqPE3),.dadq_prev_vec_in_AY(dadq_prev_vec_reg_AY_dqPE3),.dadq_prev_vec_in_AZ(dadq_prev_vec_reg_AZ_dqPE3),.dadq_prev_vec_in_LX(dadq_prev_vec_reg_LX_dqPE3),.dadq_prev_vec_in_LY(dadq_prev_vec_reg_LY_dqPE3),.dadq_prev_vec_in_LZ(dadq_prev_vec_reg_LZ_dqPE3),
      // mcross boolean
      .mcross(mx_dqPE3),
      // dvdq_vec_out, 6 values
      .dvdq_curr_vec_out_AX(dvdq_curr_vec_out_AX_dqPE3),.dvdq_curr_vec_out_AY(dvdq_curr_vec_out_AY_dqPE3),.dvdq_curr_vec_out_AZ(dvdq_curr_vec_out_AZ_dqPE3),.dvdq_curr_vec_out_LX(dvdq_curr_vec_out_LX_dqPE3),.dvdq_curr_vec_out_LY(dvdq_curr_vec_out_LY_dqPE3),.dvdq_curr_vec_out_LZ(dvdq_curr_vec_out_LZ_dqPE3),
      // dadq_vec_out, 6 values
      .dadq_curr_vec_out_AX(dadq_curr_vec_out_AX_dqPE3),.dadq_curr_vec_out_AY(dadq_curr_vec_out_AY_dqPE3),.dadq_curr_vec_out_AZ(dadq_curr_vec_out_AZ_dqPE3),.dadq_curr_vec_out_LX(dadq_curr_vec_out_LX_dqPE3),.dadq_curr_vec_out_LY(dadq_curr_vec_out_LY_dqPE3),.dadq_curr_vec_out_LZ(dadq_curr_vec_out_LZ_dqPE3),
      // dfdq_vec_out, 6 values
      .dfdq_curr_vec_out_AX(dfdq_curr_vec_out_AX_dqPE3),.dfdq_curr_vec_out_AY(dfdq_curr_vec_out_AY_dqPE3),.dfdq_curr_vec_out_AZ(dfdq_curr_vec_out_AZ_dqPE3),.dfdq_curr_vec_out_LX(dfdq_curr_vec_out_LX_dqPE3),.dfdq_curr_vec_out_LY(dfdq_curr_vec_out_LY_dqPE3),.dfdq_curr_vec_out_LZ(dfdq_curr_vec_out_LZ_dqPE3)
      );

   // dqPE4
   dqfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqfpi4(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqPE4),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqPE4),.cosq_val_in(cosq_val_reg_dqPE4),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqPE4),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqPE4),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqPE4),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqPE4),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqPE4),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqPE4),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqPE4),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqPE4),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqPE4),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqPE4),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqPE4),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqPE4),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqPE4),
      // v_vec_in, 6 values
      .v_prev_vec_in_AX(v_prev_vec_reg_AX_dqPE4),.v_prev_vec_in_AY(v_prev_vec_reg_AY_dqPE4),.v_prev_vec_in_AZ(v_prev_vec_reg_AZ_dqPE4),.v_prev_vec_in_LX(v_prev_vec_reg_LX_dqPE4),.v_prev_vec_in_LY(v_prev_vec_reg_LY_dqPE4),.v_prev_vec_in_LZ(v_prev_vec_reg_LZ_dqPE4),
      // a_vec_in, 6 values
      .a_prev_vec_in_AX(a_prev_vec_reg_AX_dqPE4),.a_prev_vec_in_AY(a_prev_vec_reg_AY_dqPE4),.a_prev_vec_in_AZ(a_prev_vec_reg_AZ_dqPE4),.a_prev_vec_in_LX(a_prev_vec_reg_LX_dqPE4),.a_prev_vec_in_LY(a_prev_vec_reg_LY_dqPE4),.a_prev_vec_in_LZ(a_prev_vec_reg_LZ_dqPE4),
      // v_vec_in, 6 values
      .dvdq_prev_vec_in_AX(dvdq_prev_vec_reg_AX_dqPE4),.dvdq_prev_vec_in_AY(dvdq_prev_vec_reg_AY_dqPE4),.dvdq_prev_vec_in_AZ(dvdq_prev_vec_reg_AZ_dqPE4),.dvdq_prev_vec_in_LX(dvdq_prev_vec_reg_LX_dqPE4),.dvdq_prev_vec_in_LY(dvdq_prev_vec_reg_LY_dqPE4),.dvdq_prev_vec_in_LZ(dvdq_prev_vec_reg_LZ_dqPE4),
      // a_vec_in, 6 values
      .dadq_prev_vec_in_AX(dadq_prev_vec_reg_AX_dqPE4),.dadq_prev_vec_in_AY(dadq_prev_vec_reg_AY_dqPE4),.dadq_prev_vec_in_AZ(dadq_prev_vec_reg_AZ_dqPE4),.dadq_prev_vec_in_LX(dadq_prev_vec_reg_LX_dqPE4),.dadq_prev_vec_in_LY(dadq_prev_vec_reg_LY_dqPE4),.dadq_prev_vec_in_LZ(dadq_prev_vec_reg_LZ_dqPE4),
      // mcross boolean
      .mcross(mx_dqPE4),
      // dvdq_vec_out, 6 values
      .dvdq_curr_vec_out_AX(dvdq_curr_vec_out_AX_dqPE4),.dvdq_curr_vec_out_AY(dvdq_curr_vec_out_AY_dqPE4),.dvdq_curr_vec_out_AZ(dvdq_curr_vec_out_AZ_dqPE4),.dvdq_curr_vec_out_LX(dvdq_curr_vec_out_LX_dqPE4),.dvdq_curr_vec_out_LY(dvdq_curr_vec_out_LY_dqPE4),.dvdq_curr_vec_out_LZ(dvdq_curr_vec_out_LZ_dqPE4),
      // dadq_vec_out, 6 values
      .dadq_curr_vec_out_AX(dadq_curr_vec_out_AX_dqPE4),.dadq_curr_vec_out_AY(dadq_curr_vec_out_AY_dqPE4),.dadq_curr_vec_out_AZ(dadq_curr_vec_out_AZ_dqPE4),.dadq_curr_vec_out_LX(dadq_curr_vec_out_LX_dqPE4),.dadq_curr_vec_out_LY(dadq_curr_vec_out_LY_dqPE4),.dadq_curr_vec_out_LZ(dadq_curr_vec_out_LZ_dqPE4),
      // dfdq_vec_out, 6 values
      .dfdq_curr_vec_out_AX(dfdq_curr_vec_out_AX_dqPE4),.dfdq_curr_vec_out_AY(dfdq_curr_vec_out_AY_dqPE4),.dfdq_curr_vec_out_AZ(dfdq_curr_vec_out_AZ_dqPE4),.dfdq_curr_vec_out_LX(dfdq_curr_vec_out_LX_dqPE4),.dfdq_curr_vec_out_LY(dfdq_curr_vec_out_LY_dqPE4),.dfdq_curr_vec_out_LZ(dfdq_curr_vec_out_LZ_dqPE4)
      );

   // dqPE5
   dqfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqfpi5(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqPE5),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqPE5),.cosq_val_in(cosq_val_reg_dqPE5),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqPE5),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqPE5),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqPE5),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqPE5),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqPE5),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqPE5),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqPE5),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqPE5),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqPE5),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqPE5),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqPE5),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqPE5),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqPE5),
      // v_vec_in, 6 values
      .v_prev_vec_in_AX(v_prev_vec_reg_AX_dqPE5),.v_prev_vec_in_AY(v_prev_vec_reg_AY_dqPE5),.v_prev_vec_in_AZ(v_prev_vec_reg_AZ_dqPE5),.v_prev_vec_in_LX(v_prev_vec_reg_LX_dqPE5),.v_prev_vec_in_LY(v_prev_vec_reg_LY_dqPE5),.v_prev_vec_in_LZ(v_prev_vec_reg_LZ_dqPE5),
      // a_vec_in, 6 values
      .a_prev_vec_in_AX(a_prev_vec_reg_AX_dqPE5),.a_prev_vec_in_AY(a_prev_vec_reg_AY_dqPE5),.a_prev_vec_in_AZ(a_prev_vec_reg_AZ_dqPE5),.a_prev_vec_in_LX(a_prev_vec_reg_LX_dqPE5),.a_prev_vec_in_LY(a_prev_vec_reg_LY_dqPE5),.a_prev_vec_in_LZ(a_prev_vec_reg_LZ_dqPE5),
      // v_vec_in, 6 values
      .dvdq_prev_vec_in_AX(dvdq_prev_vec_reg_AX_dqPE5),.dvdq_prev_vec_in_AY(dvdq_prev_vec_reg_AY_dqPE5),.dvdq_prev_vec_in_AZ(dvdq_prev_vec_reg_AZ_dqPE5),.dvdq_prev_vec_in_LX(dvdq_prev_vec_reg_LX_dqPE5),.dvdq_prev_vec_in_LY(dvdq_prev_vec_reg_LY_dqPE5),.dvdq_prev_vec_in_LZ(dvdq_prev_vec_reg_LZ_dqPE5),
      // a_vec_in, 6 values
      .dadq_prev_vec_in_AX(dadq_prev_vec_reg_AX_dqPE5),.dadq_prev_vec_in_AY(dadq_prev_vec_reg_AY_dqPE5),.dadq_prev_vec_in_AZ(dadq_prev_vec_reg_AZ_dqPE5),.dadq_prev_vec_in_LX(dadq_prev_vec_reg_LX_dqPE5),.dadq_prev_vec_in_LY(dadq_prev_vec_reg_LY_dqPE5),.dadq_prev_vec_in_LZ(dadq_prev_vec_reg_LZ_dqPE5),
      // mcross boolean
      .mcross(mx_dqPE5),
      // dvdq_vec_out, 6 values
      .dvdq_curr_vec_out_AX(dvdq_curr_vec_out_AX_dqPE5),.dvdq_curr_vec_out_AY(dvdq_curr_vec_out_AY_dqPE5),.dvdq_curr_vec_out_AZ(dvdq_curr_vec_out_AZ_dqPE5),.dvdq_curr_vec_out_LX(dvdq_curr_vec_out_LX_dqPE5),.dvdq_curr_vec_out_LY(dvdq_curr_vec_out_LY_dqPE5),.dvdq_curr_vec_out_LZ(dvdq_curr_vec_out_LZ_dqPE5),
      // dadq_vec_out, 6 values
      .dadq_curr_vec_out_AX(dadq_curr_vec_out_AX_dqPE5),.dadq_curr_vec_out_AY(dadq_curr_vec_out_AY_dqPE5),.dadq_curr_vec_out_AZ(dadq_curr_vec_out_AZ_dqPE5),.dadq_curr_vec_out_LX(dadq_curr_vec_out_LX_dqPE5),.dadq_curr_vec_out_LY(dadq_curr_vec_out_LY_dqPE5),.dadq_curr_vec_out_LZ(dadq_curr_vec_out_LZ_dqPE5),
      // dfdq_vec_out, 6 values
      .dfdq_curr_vec_out_AX(dfdq_curr_vec_out_AX_dqPE5),.dfdq_curr_vec_out_AY(dfdq_curr_vec_out_AY_dqPE5),.dfdq_curr_vec_out_AZ(dfdq_curr_vec_out_AZ_dqPE5),.dfdq_curr_vec_out_LX(dfdq_curr_vec_out_LX_dqPE5),.dfdq_curr_vec_out_LY(dfdq_curr_vec_out_LY_dqPE5),.dfdq_curr_vec_out_LZ(dfdq_curr_vec_out_LZ_dqPE5)
      );

   // dqPE6
   dqfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqfpi6(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqPE6),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqPE6),.cosq_val_in(cosq_val_reg_dqPE6),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqPE6),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqPE6),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqPE6),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqPE6),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqPE6),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqPE6),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqPE6),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqPE6),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqPE6),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqPE6),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqPE6),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqPE6),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqPE6),
      // v_vec_in, 6 values
      .v_prev_vec_in_AX(v_prev_vec_reg_AX_dqPE6),.v_prev_vec_in_AY(v_prev_vec_reg_AY_dqPE6),.v_prev_vec_in_AZ(v_prev_vec_reg_AZ_dqPE6),.v_prev_vec_in_LX(v_prev_vec_reg_LX_dqPE6),.v_prev_vec_in_LY(v_prev_vec_reg_LY_dqPE6),.v_prev_vec_in_LZ(v_prev_vec_reg_LZ_dqPE6),
      // a_vec_in, 6 values
      .a_prev_vec_in_AX(a_prev_vec_reg_AX_dqPE6),.a_prev_vec_in_AY(a_prev_vec_reg_AY_dqPE6),.a_prev_vec_in_AZ(a_prev_vec_reg_AZ_dqPE6),.a_prev_vec_in_LX(a_prev_vec_reg_LX_dqPE6),.a_prev_vec_in_LY(a_prev_vec_reg_LY_dqPE6),.a_prev_vec_in_LZ(a_prev_vec_reg_LZ_dqPE6),
      // v_vec_in, 6 values
      .dvdq_prev_vec_in_AX(dvdq_prev_vec_reg_AX_dqPE6),.dvdq_prev_vec_in_AY(dvdq_prev_vec_reg_AY_dqPE6),.dvdq_prev_vec_in_AZ(dvdq_prev_vec_reg_AZ_dqPE6),.dvdq_prev_vec_in_LX(dvdq_prev_vec_reg_LX_dqPE6),.dvdq_prev_vec_in_LY(dvdq_prev_vec_reg_LY_dqPE6),.dvdq_prev_vec_in_LZ(dvdq_prev_vec_reg_LZ_dqPE6),
      // a_vec_in, 6 values
      .dadq_prev_vec_in_AX(dadq_prev_vec_reg_AX_dqPE6),.dadq_prev_vec_in_AY(dadq_prev_vec_reg_AY_dqPE6),.dadq_prev_vec_in_AZ(dadq_prev_vec_reg_AZ_dqPE6),.dadq_prev_vec_in_LX(dadq_prev_vec_reg_LX_dqPE6),.dadq_prev_vec_in_LY(dadq_prev_vec_reg_LY_dqPE6),.dadq_prev_vec_in_LZ(dadq_prev_vec_reg_LZ_dqPE6),
      // mcross boolean
      .mcross(mx_dqPE6),
      // dvdq_vec_out, 6 values
      .dvdq_curr_vec_out_AX(dvdq_curr_vec_out_AX_dqPE6),.dvdq_curr_vec_out_AY(dvdq_curr_vec_out_AY_dqPE6),.dvdq_curr_vec_out_AZ(dvdq_curr_vec_out_AZ_dqPE6),.dvdq_curr_vec_out_LX(dvdq_curr_vec_out_LX_dqPE6),.dvdq_curr_vec_out_LY(dvdq_curr_vec_out_LY_dqPE6),.dvdq_curr_vec_out_LZ(dvdq_curr_vec_out_LZ_dqPE6),
      // dadq_vec_out, 6 values
      .dadq_curr_vec_out_AX(dadq_curr_vec_out_AX_dqPE6),.dadq_curr_vec_out_AY(dadq_curr_vec_out_AY_dqPE6),.dadq_curr_vec_out_AZ(dadq_curr_vec_out_AZ_dqPE6),.dadq_curr_vec_out_LX(dadq_curr_vec_out_LX_dqPE6),.dadq_curr_vec_out_LY(dadq_curr_vec_out_LY_dqPE6),.dadq_curr_vec_out_LZ(dadq_curr_vec_out_LZ_dqPE6),
      // dfdq_vec_out, 6 values
      .dfdq_curr_vec_out_AX(dfdq_curr_vec_out_AX_dqPE6),.dfdq_curr_vec_out_AY(dfdq_curr_vec_out_AY_dqPE6),.dfdq_curr_vec_out_AZ(dfdq_curr_vec_out_AZ_dqPE6),.dfdq_curr_vec_out_LX(dfdq_curr_vec_out_LX_dqPE6),.dfdq_curr_vec_out_LY(dfdq_curr_vec_out_LY_dqPE6),.dfdq_curr_vec_out_LZ(dfdq_curr_vec_out_LZ_dqPE6)
      );

   // dqPE7
   dqfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqfpi7(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqPE7),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqPE7),.cosq_val_in(cosq_val_reg_dqPE7),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqPE7),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqPE7),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqPE7),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqPE7),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqPE7),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqPE7),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqPE7),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqPE7),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqPE7),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqPE7),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqPE7),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqPE7),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqPE7),
      // v_vec_in, 6 values
      .v_prev_vec_in_AX(v_prev_vec_reg_AX_dqPE7),.v_prev_vec_in_AY(v_prev_vec_reg_AY_dqPE7),.v_prev_vec_in_AZ(v_prev_vec_reg_AZ_dqPE7),.v_prev_vec_in_LX(v_prev_vec_reg_LX_dqPE7),.v_prev_vec_in_LY(v_prev_vec_reg_LY_dqPE7),.v_prev_vec_in_LZ(v_prev_vec_reg_LZ_dqPE7),
      // a_vec_in, 6 values
      .a_prev_vec_in_AX(a_prev_vec_reg_AX_dqPE7),.a_prev_vec_in_AY(a_prev_vec_reg_AY_dqPE7),.a_prev_vec_in_AZ(a_prev_vec_reg_AZ_dqPE7),.a_prev_vec_in_LX(a_prev_vec_reg_LX_dqPE7),.a_prev_vec_in_LY(a_prev_vec_reg_LY_dqPE7),.a_prev_vec_in_LZ(a_prev_vec_reg_LZ_dqPE7),
      // v_vec_in, 6 values
      .dvdq_prev_vec_in_AX(dvdq_prev_vec_reg_AX_dqPE7),.dvdq_prev_vec_in_AY(dvdq_prev_vec_reg_AY_dqPE7),.dvdq_prev_vec_in_AZ(dvdq_prev_vec_reg_AZ_dqPE7),.dvdq_prev_vec_in_LX(dvdq_prev_vec_reg_LX_dqPE7),.dvdq_prev_vec_in_LY(dvdq_prev_vec_reg_LY_dqPE7),.dvdq_prev_vec_in_LZ(dvdq_prev_vec_reg_LZ_dqPE7),
      // a_vec_in, 6 values
      .dadq_prev_vec_in_AX(dadq_prev_vec_reg_AX_dqPE7),.dadq_prev_vec_in_AY(dadq_prev_vec_reg_AY_dqPE7),.dadq_prev_vec_in_AZ(dadq_prev_vec_reg_AZ_dqPE7),.dadq_prev_vec_in_LX(dadq_prev_vec_reg_LX_dqPE7),.dadq_prev_vec_in_LY(dadq_prev_vec_reg_LY_dqPE7),.dadq_prev_vec_in_LZ(dadq_prev_vec_reg_LZ_dqPE7),
      // mcross boolean
      .mcross(mx_dqPE7),
      // dvdq_vec_out, 6 values
      .dvdq_curr_vec_out_AX(dvdq_curr_vec_out_AX_dqPE7),.dvdq_curr_vec_out_AY(dvdq_curr_vec_out_AY_dqPE7),.dvdq_curr_vec_out_AZ(dvdq_curr_vec_out_AZ_dqPE7),.dvdq_curr_vec_out_LX(dvdq_curr_vec_out_LX_dqPE7),.dvdq_curr_vec_out_LY(dvdq_curr_vec_out_LY_dqPE7),.dvdq_curr_vec_out_LZ(dvdq_curr_vec_out_LZ_dqPE7),
      // dadq_vec_out, 6 values
      .dadq_curr_vec_out_AX(dadq_curr_vec_out_AX_dqPE7),.dadq_curr_vec_out_AY(dadq_curr_vec_out_AY_dqPE7),.dadq_curr_vec_out_AZ(dadq_curr_vec_out_AZ_dqPE7),.dadq_curr_vec_out_LX(dadq_curr_vec_out_LX_dqPE7),.dadq_curr_vec_out_LY(dadq_curr_vec_out_LY_dqPE7),.dadq_curr_vec_out_LZ(dadq_curr_vec_out_LZ_dqPE7),
      // dfdq_vec_out, 6 values
      .dfdq_curr_vec_out_AX(dfdq_curr_vec_out_AX_dqPE7),.dfdq_curr_vec_out_AY(dfdq_curr_vec_out_AY_dqPE7),.dfdq_curr_vec_out_AZ(dfdq_curr_vec_out_AZ_dqPE7),.dfdq_curr_vec_out_LX(dfdq_curr_vec_out_LX_dqPE7),.dfdq_curr_vec_out_LY(dfdq_curr_vec_out_LY_dqPE7),.dfdq_curr_vec_out_LZ(dfdq_curr_vec_out_LZ_dqPE7)
      );

   //---------------------------------------------------------------------------
   // dID/dqd
   //---------------------------------------------------------------------------

   // dqdPE1
   dqdfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdfpi1(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqdPE1),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqdPE1),.cosq_val_in(cosq_val_reg_dqdPE1),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqdPE1),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqdPE1),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqdPE1),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqdPE1),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqdPE1),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqdPE1),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqdPE1),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqdPE1),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqdPE1),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqdPE1),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqdPE1),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqdPE1),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqdPE1),
      // v_vec_in, 6 values
      .dvdqd_prev_vec_in_AX(dvdqd_prev_vec_reg_AX_dqdPE1),.dvdqd_prev_vec_in_AY(dvdqd_prev_vec_reg_AY_dqdPE1),.dvdqd_prev_vec_in_AZ(dvdqd_prev_vec_reg_AZ_dqdPE1),.dvdqd_prev_vec_in_LX(dvdqd_prev_vec_reg_LX_dqdPE1),.dvdqd_prev_vec_in_LY(dvdqd_prev_vec_reg_LY_dqdPE1),.dvdqd_prev_vec_in_LZ(dvdqd_prev_vec_reg_LZ_dqdPE1),
      // a_vec_in, 6 values
      .dadqd_prev_vec_in_AX(dadqd_prev_vec_reg_AX_dqdPE1),.dadqd_prev_vec_in_AY(dadqd_prev_vec_reg_AY_dqdPE1),.dadqd_prev_vec_in_AZ(dadqd_prev_vec_reg_AZ_dqdPE1),.dadqd_prev_vec_in_LX(dadqd_prev_vec_reg_LX_dqdPE1),.dadqd_prev_vec_in_LY(dadqd_prev_vec_reg_LY_dqdPE1),.dadqd_prev_vec_in_LZ(dadqd_prev_vec_reg_LZ_dqdPE1),
      // mcross boolean
      .mcross(mx_dqdPE1),
      // dvdqd_vec_out, 6 values
      .dvdqd_curr_vec_out_AX(dvdqd_curr_vec_out_AX_dqdPE1),.dvdqd_curr_vec_out_AY(dvdqd_curr_vec_out_AY_dqdPE1),.dvdqd_curr_vec_out_AZ(dvdqd_curr_vec_out_AZ_dqdPE1),.dvdqd_curr_vec_out_LX(dvdqd_curr_vec_out_LX_dqdPE1),.dvdqd_curr_vec_out_LY(dvdqd_curr_vec_out_LY_dqdPE1),.dvdqd_curr_vec_out_LZ(dvdqd_curr_vec_out_LZ_dqdPE1),
      // dadqd_vec_out, 6 values
      .dadqd_curr_vec_out_AX(dadqd_curr_vec_out_AX_dqdPE1),.dadqd_curr_vec_out_AY(dadqd_curr_vec_out_AY_dqdPE1),.dadqd_curr_vec_out_AZ(dadqd_curr_vec_out_AZ_dqdPE1),.dadqd_curr_vec_out_LX(dadqd_curr_vec_out_LX_dqdPE1),.dadqd_curr_vec_out_LY(dadqd_curr_vec_out_LY_dqdPE1),.dadqd_curr_vec_out_LZ(dadqd_curr_vec_out_LZ_dqdPE1),
      // dfdqd_vec_out, 6 values
      .dfdqd_curr_vec_out_AX(dfdqd_curr_vec_out_AX_dqdPE1),.dfdqd_curr_vec_out_AY(dfdqd_curr_vec_out_AY_dqdPE1),.dfdqd_curr_vec_out_AZ(dfdqd_curr_vec_out_AZ_dqdPE1),.dfdqd_curr_vec_out_LX(dfdqd_curr_vec_out_LX_dqdPE1),.dfdqd_curr_vec_out_LY(dfdqd_curr_vec_out_LY_dqdPE1),.dfdqd_curr_vec_out_LZ(dfdqd_curr_vec_out_LZ_dqdPE1)
      );

   // dqdPE2
   dqdfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdfpi2(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqdPE2),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqdPE2),.cosq_val_in(cosq_val_reg_dqdPE2),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqdPE2),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqdPE2),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqdPE2),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqdPE2),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqdPE2),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqdPE2),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqdPE2),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqdPE2),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqdPE2),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqdPE2),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqdPE2),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqdPE2),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqdPE2),
      // v_vec_in, 6 values
      .dvdqd_prev_vec_in_AX(dvdqd_prev_vec_reg_AX_dqdPE2),.dvdqd_prev_vec_in_AY(dvdqd_prev_vec_reg_AY_dqdPE2),.dvdqd_prev_vec_in_AZ(dvdqd_prev_vec_reg_AZ_dqdPE2),.dvdqd_prev_vec_in_LX(dvdqd_prev_vec_reg_LX_dqdPE2),.dvdqd_prev_vec_in_LY(dvdqd_prev_vec_reg_LY_dqdPE2),.dvdqd_prev_vec_in_LZ(dvdqd_prev_vec_reg_LZ_dqdPE2),
      // a_vec_in, 6 values
      .dadqd_prev_vec_in_AX(dadqd_prev_vec_reg_AX_dqdPE2),.dadqd_prev_vec_in_AY(dadqd_prev_vec_reg_AY_dqdPE2),.dadqd_prev_vec_in_AZ(dadqd_prev_vec_reg_AZ_dqdPE2),.dadqd_prev_vec_in_LX(dadqd_prev_vec_reg_LX_dqdPE2),.dadqd_prev_vec_in_LY(dadqd_prev_vec_reg_LY_dqdPE2),.dadqd_prev_vec_in_LZ(dadqd_prev_vec_reg_LZ_dqdPE2),
      // mcross boolean
      .mcross(mx_dqdPE2),
      // dvdqd_vec_out, 6 values
      .dvdqd_curr_vec_out_AX(dvdqd_curr_vec_out_AX_dqdPE2),.dvdqd_curr_vec_out_AY(dvdqd_curr_vec_out_AY_dqdPE2),.dvdqd_curr_vec_out_AZ(dvdqd_curr_vec_out_AZ_dqdPE2),.dvdqd_curr_vec_out_LX(dvdqd_curr_vec_out_LX_dqdPE2),.dvdqd_curr_vec_out_LY(dvdqd_curr_vec_out_LY_dqdPE2),.dvdqd_curr_vec_out_LZ(dvdqd_curr_vec_out_LZ_dqdPE2),
      // dadqd_vec_out, 6 values
      .dadqd_curr_vec_out_AX(dadqd_curr_vec_out_AX_dqdPE2),.dadqd_curr_vec_out_AY(dadqd_curr_vec_out_AY_dqdPE2),.dadqd_curr_vec_out_AZ(dadqd_curr_vec_out_AZ_dqdPE2),.dadqd_curr_vec_out_LX(dadqd_curr_vec_out_LX_dqdPE2),.dadqd_curr_vec_out_LY(dadqd_curr_vec_out_LY_dqdPE2),.dadqd_curr_vec_out_LZ(dadqd_curr_vec_out_LZ_dqdPE2),
      // dfdqd_vec_out, 6 values
      .dfdqd_curr_vec_out_AX(dfdqd_curr_vec_out_AX_dqdPE2),.dfdqd_curr_vec_out_AY(dfdqd_curr_vec_out_AY_dqdPE2),.dfdqd_curr_vec_out_AZ(dfdqd_curr_vec_out_AZ_dqdPE2),.dfdqd_curr_vec_out_LX(dfdqd_curr_vec_out_LX_dqdPE2),.dfdqd_curr_vec_out_LY(dfdqd_curr_vec_out_LY_dqdPE2),.dfdqd_curr_vec_out_LZ(dfdqd_curr_vec_out_LZ_dqdPE2)
      );

   // dqdPE3
   dqdfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdfpi3(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqdPE3),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqdPE3),.cosq_val_in(cosq_val_reg_dqdPE3),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqdPE3),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqdPE3),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqdPE3),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqdPE3),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqdPE3),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqdPE3),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqdPE3),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqdPE3),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqdPE3),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqdPE3),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqdPE3),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqdPE3),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqdPE3),
      // v_vec_in, 6 values
      .dvdqd_prev_vec_in_AX(dvdqd_prev_vec_reg_AX_dqdPE3),.dvdqd_prev_vec_in_AY(dvdqd_prev_vec_reg_AY_dqdPE3),.dvdqd_prev_vec_in_AZ(dvdqd_prev_vec_reg_AZ_dqdPE3),.dvdqd_prev_vec_in_LX(dvdqd_prev_vec_reg_LX_dqdPE3),.dvdqd_prev_vec_in_LY(dvdqd_prev_vec_reg_LY_dqdPE3),.dvdqd_prev_vec_in_LZ(dvdqd_prev_vec_reg_LZ_dqdPE3),
      // a_vec_in, 6 values
      .dadqd_prev_vec_in_AX(dadqd_prev_vec_reg_AX_dqdPE3),.dadqd_prev_vec_in_AY(dadqd_prev_vec_reg_AY_dqdPE3),.dadqd_prev_vec_in_AZ(dadqd_prev_vec_reg_AZ_dqdPE3),.dadqd_prev_vec_in_LX(dadqd_prev_vec_reg_LX_dqdPE3),.dadqd_prev_vec_in_LY(dadqd_prev_vec_reg_LY_dqdPE3),.dadqd_prev_vec_in_LZ(dadqd_prev_vec_reg_LZ_dqdPE3),
      // mcross boolean
      .mcross(mx_dqdPE3),
      // dvdqd_vec_out, 6 values
      .dvdqd_curr_vec_out_AX(dvdqd_curr_vec_out_AX_dqdPE3),.dvdqd_curr_vec_out_AY(dvdqd_curr_vec_out_AY_dqdPE3),.dvdqd_curr_vec_out_AZ(dvdqd_curr_vec_out_AZ_dqdPE3),.dvdqd_curr_vec_out_LX(dvdqd_curr_vec_out_LX_dqdPE3),.dvdqd_curr_vec_out_LY(dvdqd_curr_vec_out_LY_dqdPE3),.dvdqd_curr_vec_out_LZ(dvdqd_curr_vec_out_LZ_dqdPE3),
      // dadqd_vec_out, 6 values
      .dadqd_curr_vec_out_AX(dadqd_curr_vec_out_AX_dqdPE3),.dadqd_curr_vec_out_AY(dadqd_curr_vec_out_AY_dqdPE3),.dadqd_curr_vec_out_AZ(dadqd_curr_vec_out_AZ_dqdPE3),.dadqd_curr_vec_out_LX(dadqd_curr_vec_out_LX_dqdPE3),.dadqd_curr_vec_out_LY(dadqd_curr_vec_out_LY_dqdPE3),.dadqd_curr_vec_out_LZ(dadqd_curr_vec_out_LZ_dqdPE3),
      // dfdqd_vec_out, 6 values
      .dfdqd_curr_vec_out_AX(dfdqd_curr_vec_out_AX_dqdPE3),.dfdqd_curr_vec_out_AY(dfdqd_curr_vec_out_AY_dqdPE3),.dfdqd_curr_vec_out_AZ(dfdqd_curr_vec_out_AZ_dqdPE3),.dfdqd_curr_vec_out_LX(dfdqd_curr_vec_out_LX_dqdPE3),.dfdqd_curr_vec_out_LY(dfdqd_curr_vec_out_LY_dqdPE3),.dfdqd_curr_vec_out_LZ(dfdqd_curr_vec_out_LZ_dqdPE3)
      );

   // dqdPE4
   dqdfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdfpi4(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqdPE4),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqdPE4),.cosq_val_in(cosq_val_reg_dqdPE4),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqdPE4),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqdPE4),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqdPE4),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqdPE4),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqdPE4),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqdPE4),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqdPE4),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqdPE4),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqdPE4),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqdPE4),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqdPE4),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqdPE4),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqdPE4),
      // v_vec_in, 6 values
      .dvdqd_prev_vec_in_AX(dvdqd_prev_vec_reg_AX_dqdPE4),.dvdqd_prev_vec_in_AY(dvdqd_prev_vec_reg_AY_dqdPE4),.dvdqd_prev_vec_in_AZ(dvdqd_prev_vec_reg_AZ_dqdPE4),.dvdqd_prev_vec_in_LX(dvdqd_prev_vec_reg_LX_dqdPE4),.dvdqd_prev_vec_in_LY(dvdqd_prev_vec_reg_LY_dqdPE4),.dvdqd_prev_vec_in_LZ(dvdqd_prev_vec_reg_LZ_dqdPE4),
      // a_vec_in, 6 values
      .dadqd_prev_vec_in_AX(dadqd_prev_vec_reg_AX_dqdPE4),.dadqd_prev_vec_in_AY(dadqd_prev_vec_reg_AY_dqdPE4),.dadqd_prev_vec_in_AZ(dadqd_prev_vec_reg_AZ_dqdPE4),.dadqd_prev_vec_in_LX(dadqd_prev_vec_reg_LX_dqdPE4),.dadqd_prev_vec_in_LY(dadqd_prev_vec_reg_LY_dqdPE4),.dadqd_prev_vec_in_LZ(dadqd_prev_vec_reg_LZ_dqdPE4),
      // mcross boolean
      .mcross(mx_dqdPE4),
      // dvdqd_vec_out, 6 values
      .dvdqd_curr_vec_out_AX(dvdqd_curr_vec_out_AX_dqdPE4),.dvdqd_curr_vec_out_AY(dvdqd_curr_vec_out_AY_dqdPE4),.dvdqd_curr_vec_out_AZ(dvdqd_curr_vec_out_AZ_dqdPE4),.dvdqd_curr_vec_out_LX(dvdqd_curr_vec_out_LX_dqdPE4),.dvdqd_curr_vec_out_LY(dvdqd_curr_vec_out_LY_dqdPE4),.dvdqd_curr_vec_out_LZ(dvdqd_curr_vec_out_LZ_dqdPE4),
      // dadqd_vec_out, 6 values
      .dadqd_curr_vec_out_AX(dadqd_curr_vec_out_AX_dqdPE4),.dadqd_curr_vec_out_AY(dadqd_curr_vec_out_AY_dqdPE4),.dadqd_curr_vec_out_AZ(dadqd_curr_vec_out_AZ_dqdPE4),.dadqd_curr_vec_out_LX(dadqd_curr_vec_out_LX_dqdPE4),.dadqd_curr_vec_out_LY(dadqd_curr_vec_out_LY_dqdPE4),.dadqd_curr_vec_out_LZ(dadqd_curr_vec_out_LZ_dqdPE4),
      // dfdqd_vec_out, 6 values
      .dfdqd_curr_vec_out_AX(dfdqd_curr_vec_out_AX_dqdPE4),.dfdqd_curr_vec_out_AY(dfdqd_curr_vec_out_AY_dqdPE4),.dfdqd_curr_vec_out_AZ(dfdqd_curr_vec_out_AZ_dqdPE4),.dfdqd_curr_vec_out_LX(dfdqd_curr_vec_out_LX_dqdPE4),.dfdqd_curr_vec_out_LY(dfdqd_curr_vec_out_LY_dqdPE4),.dfdqd_curr_vec_out_LZ(dfdqd_curr_vec_out_LZ_dqdPE4)
      );

   // dqdPE5
   dqdfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdfpi5(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqdPE5),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqdPE5),.cosq_val_in(cosq_val_reg_dqdPE5),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqdPE5),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqdPE5),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqdPE5),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqdPE5),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqdPE5),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqdPE5),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqdPE5),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqdPE5),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqdPE5),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqdPE5),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqdPE5),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqdPE5),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqdPE5),
      // v_vec_in, 6 values
      .dvdqd_prev_vec_in_AX(dvdqd_prev_vec_reg_AX_dqdPE5),.dvdqd_prev_vec_in_AY(dvdqd_prev_vec_reg_AY_dqdPE5),.dvdqd_prev_vec_in_AZ(dvdqd_prev_vec_reg_AZ_dqdPE5),.dvdqd_prev_vec_in_LX(dvdqd_prev_vec_reg_LX_dqdPE5),.dvdqd_prev_vec_in_LY(dvdqd_prev_vec_reg_LY_dqdPE5),.dvdqd_prev_vec_in_LZ(dvdqd_prev_vec_reg_LZ_dqdPE5),
      // a_vec_in, 6 values
      .dadqd_prev_vec_in_AX(dadqd_prev_vec_reg_AX_dqdPE5),.dadqd_prev_vec_in_AY(dadqd_prev_vec_reg_AY_dqdPE5),.dadqd_prev_vec_in_AZ(dadqd_prev_vec_reg_AZ_dqdPE5),.dadqd_prev_vec_in_LX(dadqd_prev_vec_reg_LX_dqdPE5),.dadqd_prev_vec_in_LY(dadqd_prev_vec_reg_LY_dqdPE5),.dadqd_prev_vec_in_LZ(dadqd_prev_vec_reg_LZ_dqdPE5),
      // mcross boolean
      .mcross(mx_dqdPE5),
      // dvdqd_vec_out, 6 values
      .dvdqd_curr_vec_out_AX(dvdqd_curr_vec_out_AX_dqdPE5),.dvdqd_curr_vec_out_AY(dvdqd_curr_vec_out_AY_dqdPE5),.dvdqd_curr_vec_out_AZ(dvdqd_curr_vec_out_AZ_dqdPE5),.dvdqd_curr_vec_out_LX(dvdqd_curr_vec_out_LX_dqdPE5),.dvdqd_curr_vec_out_LY(dvdqd_curr_vec_out_LY_dqdPE5),.dvdqd_curr_vec_out_LZ(dvdqd_curr_vec_out_LZ_dqdPE5),
      // dadqd_vec_out, 6 values
      .dadqd_curr_vec_out_AX(dadqd_curr_vec_out_AX_dqdPE5),.dadqd_curr_vec_out_AY(dadqd_curr_vec_out_AY_dqdPE5),.dadqd_curr_vec_out_AZ(dadqd_curr_vec_out_AZ_dqdPE5),.dadqd_curr_vec_out_LX(dadqd_curr_vec_out_LX_dqdPE5),.dadqd_curr_vec_out_LY(dadqd_curr_vec_out_LY_dqdPE5),.dadqd_curr_vec_out_LZ(dadqd_curr_vec_out_LZ_dqdPE5),
      // dfdqd_vec_out, 6 values
      .dfdqd_curr_vec_out_AX(dfdqd_curr_vec_out_AX_dqdPE5),.dfdqd_curr_vec_out_AY(dfdqd_curr_vec_out_AY_dqdPE5),.dfdqd_curr_vec_out_AZ(dfdqd_curr_vec_out_AZ_dqdPE5),.dfdqd_curr_vec_out_LX(dfdqd_curr_vec_out_LX_dqdPE5),.dfdqd_curr_vec_out_LY(dfdqd_curr_vec_out_LY_dqdPE5),.dfdqd_curr_vec_out_LZ(dfdqd_curr_vec_out_LZ_dqdPE5)
      );

   // dqdPE6
   dqdfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdfpi6(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqdPE6),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqdPE6),.cosq_val_in(cosq_val_reg_dqdPE6),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqdPE6),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqdPE6),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqdPE6),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqdPE6),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqdPE6),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqdPE6),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqdPE6),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqdPE6),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqdPE6),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqdPE6),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqdPE6),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqdPE6),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqdPE6),
      // v_vec_in, 6 values
      .dvdqd_prev_vec_in_AX(dvdqd_prev_vec_reg_AX_dqdPE6),.dvdqd_prev_vec_in_AY(dvdqd_prev_vec_reg_AY_dqdPE6),.dvdqd_prev_vec_in_AZ(dvdqd_prev_vec_reg_AZ_dqdPE6),.dvdqd_prev_vec_in_LX(dvdqd_prev_vec_reg_LX_dqdPE6),.dvdqd_prev_vec_in_LY(dvdqd_prev_vec_reg_LY_dqdPE6),.dvdqd_prev_vec_in_LZ(dvdqd_prev_vec_reg_LZ_dqdPE6),
      // a_vec_in, 6 values
      .dadqd_prev_vec_in_AX(dadqd_prev_vec_reg_AX_dqdPE6),.dadqd_prev_vec_in_AY(dadqd_prev_vec_reg_AY_dqdPE6),.dadqd_prev_vec_in_AZ(dadqd_prev_vec_reg_AZ_dqdPE6),.dadqd_prev_vec_in_LX(dadqd_prev_vec_reg_LX_dqdPE6),.dadqd_prev_vec_in_LY(dadqd_prev_vec_reg_LY_dqdPE6),.dadqd_prev_vec_in_LZ(dadqd_prev_vec_reg_LZ_dqdPE6),
      // mcross boolean
      .mcross(mx_dqdPE6),
      // dvdqd_vec_out, 6 values
      .dvdqd_curr_vec_out_AX(dvdqd_curr_vec_out_AX_dqdPE6),.dvdqd_curr_vec_out_AY(dvdqd_curr_vec_out_AY_dqdPE6),.dvdqd_curr_vec_out_AZ(dvdqd_curr_vec_out_AZ_dqdPE6),.dvdqd_curr_vec_out_LX(dvdqd_curr_vec_out_LX_dqdPE6),.dvdqd_curr_vec_out_LY(dvdqd_curr_vec_out_LY_dqdPE6),.dvdqd_curr_vec_out_LZ(dvdqd_curr_vec_out_LZ_dqdPE6),
      // dadqd_vec_out, 6 values
      .dadqd_curr_vec_out_AX(dadqd_curr_vec_out_AX_dqdPE6),.dadqd_curr_vec_out_AY(dadqd_curr_vec_out_AY_dqdPE6),.dadqd_curr_vec_out_AZ(dadqd_curr_vec_out_AZ_dqdPE6),.dadqd_curr_vec_out_LX(dadqd_curr_vec_out_LX_dqdPE6),.dadqd_curr_vec_out_LY(dadqd_curr_vec_out_LY_dqdPE6),.dadqd_curr_vec_out_LZ(dadqd_curr_vec_out_LZ_dqdPE6),
      // dfdqd_vec_out, 6 values
      .dfdqd_curr_vec_out_AX(dfdqd_curr_vec_out_AX_dqdPE6),.dfdqd_curr_vec_out_AY(dfdqd_curr_vec_out_AY_dqdPE6),.dfdqd_curr_vec_out_AZ(dfdqd_curr_vec_out_AZ_dqdPE6),.dfdqd_curr_vec_out_LX(dfdqd_curr_vec_out_LX_dqdPE6),.dfdqd_curr_vec_out_LY(dfdqd_curr_vec_out_LY_dqdPE6),.dfdqd_curr_vec_out_LZ(dfdqd_curr_vec_out_LZ_dqdPE6)
      );

   // dqdPE7
   dqdfpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdfpi7(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // state_reg
      .state_reg(state_reg),
      // stage booleans
      .s1_bool_in(s1_bool_reg),.s2_bool_in(s2_bool_reg),.s3_bool_in(s3_bool_reg),
      // link_in
      .link_in(link_reg_dqdPE7),
      // sin(q) and cos(q)
      .sinq_val_in(sinq_val_reg_dqdPE7),.cosq_val_in(cosq_val_reg_dqdPE7),
      // qd_val_in
      .qd_val_in(qd_val_reg_dqdPE7),
      // v_vec_in, 6 values
      .v_curr_vec_in_AX(v_curr_vec_reg_AX_dqdPE7),.v_curr_vec_in_AY(v_curr_vec_reg_AY_dqdPE7),.v_curr_vec_in_AZ(v_curr_vec_reg_AZ_dqdPE7),.v_curr_vec_in_LX(v_curr_vec_reg_LX_dqdPE7),.v_curr_vec_in_LY(v_curr_vec_reg_LY_dqdPE7),.v_curr_vec_in_LZ(v_curr_vec_reg_LZ_dqdPE7),
      // a_vec_in, 6 values
      .a_curr_vec_in_AX(a_curr_vec_reg_AX_dqdPE7),.a_curr_vec_in_AY(a_curr_vec_reg_AY_dqdPE7),.a_curr_vec_in_AZ(a_curr_vec_reg_AZ_dqdPE7),.a_curr_vec_in_LX(a_curr_vec_reg_LX_dqdPE7),.a_curr_vec_in_LY(a_curr_vec_reg_LY_dqdPE7),.a_curr_vec_in_LZ(a_curr_vec_reg_LZ_dqdPE7),
      // v_vec_in, 6 values
      .dvdqd_prev_vec_in_AX(dvdqd_prev_vec_reg_AX_dqdPE7),.dvdqd_prev_vec_in_AY(dvdqd_prev_vec_reg_AY_dqdPE7),.dvdqd_prev_vec_in_AZ(dvdqd_prev_vec_reg_AZ_dqdPE7),.dvdqd_prev_vec_in_LX(dvdqd_prev_vec_reg_LX_dqdPE7),.dvdqd_prev_vec_in_LY(dvdqd_prev_vec_reg_LY_dqdPE7),.dvdqd_prev_vec_in_LZ(dvdqd_prev_vec_reg_LZ_dqdPE7),
      // a_vec_in, 6 values
      .dadqd_prev_vec_in_AX(dadqd_prev_vec_reg_AX_dqdPE7),.dadqd_prev_vec_in_AY(dadqd_prev_vec_reg_AY_dqdPE7),.dadqd_prev_vec_in_AZ(dadqd_prev_vec_reg_AZ_dqdPE7),.dadqd_prev_vec_in_LX(dadqd_prev_vec_reg_LX_dqdPE7),.dadqd_prev_vec_in_LY(dadqd_prev_vec_reg_LY_dqdPE7),.dadqd_prev_vec_in_LZ(dadqd_prev_vec_reg_LZ_dqdPE7),
      // mcross boolean
      .mcross(mx_dqdPE7),
      // dvdqd_vec_out, 6 values
      .dvdqd_curr_vec_out_AX(dvdqd_curr_vec_out_AX_dqdPE7),.dvdqd_curr_vec_out_AY(dvdqd_curr_vec_out_AY_dqdPE7),.dvdqd_curr_vec_out_AZ(dvdqd_curr_vec_out_AZ_dqdPE7),.dvdqd_curr_vec_out_LX(dvdqd_curr_vec_out_LX_dqdPE7),.dvdqd_curr_vec_out_LY(dvdqd_curr_vec_out_LY_dqdPE7),.dvdqd_curr_vec_out_LZ(dvdqd_curr_vec_out_LZ_dqdPE7),
      // dadqd_vec_out, 6 values
      .dadqd_curr_vec_out_AX(dadqd_curr_vec_out_AX_dqdPE7),.dadqd_curr_vec_out_AY(dadqd_curr_vec_out_AY_dqdPE7),.dadqd_curr_vec_out_AZ(dadqd_curr_vec_out_AZ_dqdPE7),.dadqd_curr_vec_out_LX(dadqd_curr_vec_out_LX_dqdPE7),.dadqd_curr_vec_out_LY(dadqd_curr_vec_out_LY_dqdPE7),.dadqd_curr_vec_out_LZ(dadqd_curr_vec_out_LZ_dqdPE7),
      // dfdqd_vec_out, 6 values
      .dfdqd_curr_vec_out_AX(dfdqd_curr_vec_out_AX_dqdPE7),.dfdqd_curr_vec_out_AY(dfdqd_curr_vec_out_AY_dqdPE7),.dfdqd_curr_vec_out_AZ(dfdqd_curr_vec_out_AZ_dqdPE7),.dfdqd_curr_vec_out_LX(dfdqd_curr_vec_out_LX_dqdPE7),.dfdqd_curr_vec_out_LY(dfdqd_curr_vec_out_LY_dqdPE7),.dfdqd_curr_vec_out_LZ(dfdqd_curr_vec_out_LZ_dqdPE7)
      );

endmodule
