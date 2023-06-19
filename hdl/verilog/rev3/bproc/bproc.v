`timescale 1ns / 1ps

// Backward Pass Row Unit with RNEA and Block Minv

//------------------------------------------------------------------------------
// bproc Module
//------------------------------------------------------------------------------
module bproc#(parameter WIDTH = 32,parameter DECIMAL_BITS = 16)(
   // clock
   input  clk,
   // reset
   input reset,
   // get_data
   input get_data,
   // get_data_minv
   input get_data_minv,
   //---------------------------------------------------------------------------
   // rnea external inputs
   //---------------------------------------------------------------------------
   // rnea
   input  [3:0]
      link_in_rnea,
   input  signed[(WIDTH-1):0]
      sinq_val_in_rnea,cosq_val_in_rnea,
   input  signed[(WIDTH-1):0]
      f_upd_curr_vec_in_AX_rnea,f_upd_curr_vec_in_AY_rnea,f_upd_curr_vec_in_AZ_rnea,f_upd_curr_vec_in_LX_rnea,f_upd_curr_vec_in_LY_rnea,f_upd_curr_vec_in_LZ_rnea,
   input  signed[(WIDTH-1):0]
      f_prev_vec_in_AX_rnea,f_prev_vec_in_AY_rnea,f_prev_vec_in_AZ_rnea,f_prev_vec_in_LX_rnea,f_prev_vec_in_LY_rnea,f_prev_vec_in_LZ_rnea,
   //---------------------------------------------------------------------------
   // dq external inputs
   //---------------------------------------------------------------------------
   // dqPE1
   input  [3:0]
      link_in_dqPE1,
   input  [3:0]
      derv_in_dqPE1,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE1,cosq_val_in_dqPE1,
   input  signed[(WIDTH-1):0]
      f_upd_curr_vec_in_AX_dqPE1,f_upd_curr_vec_in_AY_dqPE1,f_upd_curr_vec_in_AZ_dqPE1,f_upd_curr_vec_in_LX_dqPE1,f_upd_curr_vec_in_LY_dqPE1,f_upd_curr_vec_in_LZ_dqPE1,
   input  signed[(WIDTH-1):0]
      dfdq_prev_vec_in_AX_dqPE1,dfdq_prev_vec_in_AY_dqPE1,dfdq_prev_vec_in_AZ_dqPE1,dfdq_prev_vec_in_LX_dqPE1,dfdq_prev_vec_in_LY_dqPE1,dfdq_prev_vec_in_LZ_dqPE1,
   input  signed[(WIDTH-1):0]
      dfdq_upd_curr_vec_in_AX_dqPE1,dfdq_upd_curr_vec_in_AY_dqPE1,dfdq_upd_curr_vec_in_AZ_dqPE1,dfdq_upd_curr_vec_in_LX_dqPE1,dfdq_upd_curr_vec_in_LY_dqPE1,dfdq_upd_curr_vec_in_LZ_dqPE1,
   // dqPE2
   input  [3:0]
      link_in_dqPE2,
   input  [3:0]
      derv_in_dqPE2,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE2,cosq_val_in_dqPE2,
   input  signed[(WIDTH-1):0]
      f_upd_curr_vec_in_AX_dqPE2,f_upd_curr_vec_in_AY_dqPE2,f_upd_curr_vec_in_AZ_dqPE2,f_upd_curr_vec_in_LX_dqPE2,f_upd_curr_vec_in_LY_dqPE2,f_upd_curr_vec_in_LZ_dqPE2,
   input  signed[(WIDTH-1):0]
      dfdq_prev_vec_in_AX_dqPE2,dfdq_prev_vec_in_AY_dqPE2,dfdq_prev_vec_in_AZ_dqPE2,dfdq_prev_vec_in_LX_dqPE2,dfdq_prev_vec_in_LY_dqPE2,dfdq_prev_vec_in_LZ_dqPE2,
   input  signed[(WIDTH-1):0]
      dfdq_upd_curr_vec_in_AX_dqPE2,dfdq_upd_curr_vec_in_AY_dqPE2,dfdq_upd_curr_vec_in_AZ_dqPE2,dfdq_upd_curr_vec_in_LX_dqPE2,dfdq_upd_curr_vec_in_LY_dqPE2,dfdq_upd_curr_vec_in_LZ_dqPE2,
   // dqPE3
   input  [3:0]
      link_in_dqPE3,
   input  [3:0]
      derv_in_dqPE3,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE3,cosq_val_in_dqPE3,
   input  signed[(WIDTH-1):0]
      f_upd_curr_vec_in_AX_dqPE3,f_upd_curr_vec_in_AY_dqPE3,f_upd_curr_vec_in_AZ_dqPE3,f_upd_curr_vec_in_LX_dqPE3,f_upd_curr_vec_in_LY_dqPE3,f_upd_curr_vec_in_LZ_dqPE3,
   input  signed[(WIDTH-1):0]
      dfdq_prev_vec_in_AX_dqPE3,dfdq_prev_vec_in_AY_dqPE3,dfdq_prev_vec_in_AZ_dqPE3,dfdq_prev_vec_in_LX_dqPE3,dfdq_prev_vec_in_LY_dqPE3,dfdq_prev_vec_in_LZ_dqPE3,
   input  signed[(WIDTH-1):0]
      dfdq_upd_curr_vec_in_AX_dqPE3,dfdq_upd_curr_vec_in_AY_dqPE3,dfdq_upd_curr_vec_in_AZ_dqPE3,dfdq_upd_curr_vec_in_LX_dqPE3,dfdq_upd_curr_vec_in_LY_dqPE3,dfdq_upd_curr_vec_in_LZ_dqPE3,
   // dqPE4
   input  [3:0]
      link_in_dqPE4,
   input  [3:0]
      derv_in_dqPE4,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE4,cosq_val_in_dqPE4,
   input  signed[(WIDTH-1):0]
      f_upd_curr_vec_in_AX_dqPE4,f_upd_curr_vec_in_AY_dqPE4,f_upd_curr_vec_in_AZ_dqPE4,f_upd_curr_vec_in_LX_dqPE4,f_upd_curr_vec_in_LY_dqPE4,f_upd_curr_vec_in_LZ_dqPE4,
   input  signed[(WIDTH-1):0]
      dfdq_prev_vec_in_AX_dqPE4,dfdq_prev_vec_in_AY_dqPE4,dfdq_prev_vec_in_AZ_dqPE4,dfdq_prev_vec_in_LX_dqPE4,dfdq_prev_vec_in_LY_dqPE4,dfdq_prev_vec_in_LZ_dqPE4,
   input  signed[(WIDTH-1):0]
      dfdq_upd_curr_vec_in_AX_dqPE4,dfdq_upd_curr_vec_in_AY_dqPE4,dfdq_upd_curr_vec_in_AZ_dqPE4,dfdq_upd_curr_vec_in_LX_dqPE4,dfdq_upd_curr_vec_in_LY_dqPE4,dfdq_upd_curr_vec_in_LZ_dqPE4,
   // dqPE5
   input  [3:0]
      link_in_dqPE5,
   input  [3:0]
      derv_in_dqPE5,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE5,cosq_val_in_dqPE5,
   input  signed[(WIDTH-1):0]
      f_upd_curr_vec_in_AX_dqPE5,f_upd_curr_vec_in_AY_dqPE5,f_upd_curr_vec_in_AZ_dqPE5,f_upd_curr_vec_in_LX_dqPE5,f_upd_curr_vec_in_LY_dqPE5,f_upd_curr_vec_in_LZ_dqPE5,
   input  signed[(WIDTH-1):0]
      dfdq_prev_vec_in_AX_dqPE5,dfdq_prev_vec_in_AY_dqPE5,dfdq_prev_vec_in_AZ_dqPE5,dfdq_prev_vec_in_LX_dqPE5,dfdq_prev_vec_in_LY_dqPE5,dfdq_prev_vec_in_LZ_dqPE5,
   input  signed[(WIDTH-1):0]
      dfdq_upd_curr_vec_in_AX_dqPE5,dfdq_upd_curr_vec_in_AY_dqPE5,dfdq_upd_curr_vec_in_AZ_dqPE5,dfdq_upd_curr_vec_in_LX_dqPE5,dfdq_upd_curr_vec_in_LY_dqPE5,dfdq_upd_curr_vec_in_LZ_dqPE5,
   // dqPE6
   input  [3:0]
      link_in_dqPE6,
   input  [3:0]
      derv_in_dqPE6,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE6,cosq_val_in_dqPE6,
   input  signed[(WIDTH-1):0]
      f_upd_curr_vec_in_AX_dqPE6,f_upd_curr_vec_in_AY_dqPE6,f_upd_curr_vec_in_AZ_dqPE6,f_upd_curr_vec_in_LX_dqPE6,f_upd_curr_vec_in_LY_dqPE6,f_upd_curr_vec_in_LZ_dqPE6,
   input  signed[(WIDTH-1):0]
      dfdq_prev_vec_in_AX_dqPE6,dfdq_prev_vec_in_AY_dqPE6,dfdq_prev_vec_in_AZ_dqPE6,dfdq_prev_vec_in_LX_dqPE6,dfdq_prev_vec_in_LY_dqPE6,dfdq_prev_vec_in_LZ_dqPE6,
   input  signed[(WIDTH-1):0]
      dfdq_upd_curr_vec_in_AX_dqPE6,dfdq_upd_curr_vec_in_AY_dqPE6,dfdq_upd_curr_vec_in_AZ_dqPE6,dfdq_upd_curr_vec_in_LX_dqPE6,dfdq_upd_curr_vec_in_LY_dqPE6,dfdq_upd_curr_vec_in_LZ_dqPE6,
   // dqPE7
   input  [3:0]
      link_in_dqPE7,
   input  [3:0]
      derv_in_dqPE7,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqPE7,cosq_val_in_dqPE7,
   input  signed[(WIDTH-1):0]
      f_upd_curr_vec_in_AX_dqPE7,f_upd_curr_vec_in_AY_dqPE7,f_upd_curr_vec_in_AZ_dqPE7,f_upd_curr_vec_in_LX_dqPE7,f_upd_curr_vec_in_LY_dqPE7,f_upd_curr_vec_in_LZ_dqPE7,
   input  signed[(WIDTH-1):0]
      dfdq_prev_vec_in_AX_dqPE7,dfdq_prev_vec_in_AY_dqPE7,dfdq_prev_vec_in_AZ_dqPE7,dfdq_prev_vec_in_LX_dqPE7,dfdq_prev_vec_in_LY_dqPE7,dfdq_prev_vec_in_LZ_dqPE7,
   input  signed[(WIDTH-1):0]
      dfdq_upd_curr_vec_in_AX_dqPE7,dfdq_upd_curr_vec_in_AY_dqPE7,dfdq_upd_curr_vec_in_AZ_dqPE7,dfdq_upd_curr_vec_in_LX_dqPE7,dfdq_upd_curr_vec_in_LY_dqPE7,dfdq_upd_curr_vec_in_LZ_dqPE7,
   //---------------------------------------------------------------------------
   // dqd external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   input  [3:0]
      link_in_dqdPE1,
   input  [3:0]
      derv_in_dqdPE1,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE1,cosq_val_in_dqdPE1,
   input  signed[(WIDTH-1):0]
      dfdqd_prev_vec_in_AX_dqdPE1,dfdqd_prev_vec_in_AY_dqdPE1,dfdqd_prev_vec_in_AZ_dqdPE1,dfdqd_prev_vec_in_LX_dqdPE1,dfdqd_prev_vec_in_LY_dqdPE1,dfdqd_prev_vec_in_LZ_dqdPE1,
   input  signed[(WIDTH-1):0]
      dfdqd_upd_curr_vec_in_AX_dqdPE1,dfdqd_upd_curr_vec_in_AY_dqdPE1,dfdqd_upd_curr_vec_in_AZ_dqdPE1,dfdqd_upd_curr_vec_in_LX_dqdPE1,dfdqd_upd_curr_vec_in_LY_dqdPE1,dfdqd_upd_curr_vec_in_LZ_dqdPE1,
   // dqdPE2
   input  [3:0]
      link_in_dqdPE2,
   input  [3:0]
      derv_in_dqdPE2,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE2,cosq_val_in_dqdPE2,
   input  signed[(WIDTH-1):0]
      dfdqd_prev_vec_in_AX_dqdPE2,dfdqd_prev_vec_in_AY_dqdPE2,dfdqd_prev_vec_in_AZ_dqdPE2,dfdqd_prev_vec_in_LX_dqdPE2,dfdqd_prev_vec_in_LY_dqdPE2,dfdqd_prev_vec_in_LZ_dqdPE2,
   input  signed[(WIDTH-1):0]
      dfdqd_upd_curr_vec_in_AX_dqdPE2,dfdqd_upd_curr_vec_in_AY_dqdPE2,dfdqd_upd_curr_vec_in_AZ_dqdPE2,dfdqd_upd_curr_vec_in_LX_dqdPE2,dfdqd_upd_curr_vec_in_LY_dqdPE2,dfdqd_upd_curr_vec_in_LZ_dqdPE2,
   // dqdPE3
   input  [3:0]
      link_in_dqdPE3,
   input  [3:0]
      derv_in_dqdPE3,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE3,cosq_val_in_dqdPE3,
   input  signed[(WIDTH-1):0]
      dfdqd_prev_vec_in_AX_dqdPE3,dfdqd_prev_vec_in_AY_dqdPE3,dfdqd_prev_vec_in_AZ_dqdPE3,dfdqd_prev_vec_in_LX_dqdPE3,dfdqd_prev_vec_in_LY_dqdPE3,dfdqd_prev_vec_in_LZ_dqdPE3,
   input  signed[(WIDTH-1):0]
      dfdqd_upd_curr_vec_in_AX_dqdPE3,dfdqd_upd_curr_vec_in_AY_dqdPE3,dfdqd_upd_curr_vec_in_AZ_dqdPE3,dfdqd_upd_curr_vec_in_LX_dqdPE3,dfdqd_upd_curr_vec_in_LY_dqdPE3,dfdqd_upd_curr_vec_in_LZ_dqdPE3,
   // dqdPE4
   input  [3:0]
      link_in_dqdPE4,
   input  [3:0]
      derv_in_dqdPE4,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE4,cosq_val_in_dqdPE4,
   input  signed[(WIDTH-1):0]
      dfdqd_prev_vec_in_AX_dqdPE4,dfdqd_prev_vec_in_AY_dqdPE4,dfdqd_prev_vec_in_AZ_dqdPE4,dfdqd_prev_vec_in_LX_dqdPE4,dfdqd_prev_vec_in_LY_dqdPE4,dfdqd_prev_vec_in_LZ_dqdPE4,
   input  signed[(WIDTH-1):0]
      dfdqd_upd_curr_vec_in_AX_dqdPE4,dfdqd_upd_curr_vec_in_AY_dqdPE4,dfdqd_upd_curr_vec_in_AZ_dqdPE4,dfdqd_upd_curr_vec_in_LX_dqdPE4,dfdqd_upd_curr_vec_in_LY_dqdPE4,dfdqd_upd_curr_vec_in_LZ_dqdPE4,
   // dqdPE5
   input  [3:0]
      link_in_dqdPE5,
   input  [3:0]
      derv_in_dqdPE5,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE5,cosq_val_in_dqdPE5,
   input  signed[(WIDTH-1):0]
      dfdqd_prev_vec_in_AX_dqdPE5,dfdqd_prev_vec_in_AY_dqdPE5,dfdqd_prev_vec_in_AZ_dqdPE5,dfdqd_prev_vec_in_LX_dqdPE5,dfdqd_prev_vec_in_LY_dqdPE5,dfdqd_prev_vec_in_LZ_dqdPE5,
   input  signed[(WIDTH-1):0]
      dfdqd_upd_curr_vec_in_AX_dqdPE5,dfdqd_upd_curr_vec_in_AY_dqdPE5,dfdqd_upd_curr_vec_in_AZ_dqdPE5,dfdqd_upd_curr_vec_in_LX_dqdPE5,dfdqd_upd_curr_vec_in_LY_dqdPE5,dfdqd_upd_curr_vec_in_LZ_dqdPE5,
   // dqdPE6
   input  [3:0]
      link_in_dqdPE6,
   input  [3:0]
      derv_in_dqdPE6,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE6,cosq_val_in_dqdPE6,
   input  signed[(WIDTH-1):0]
      dfdqd_prev_vec_in_AX_dqdPE6,dfdqd_prev_vec_in_AY_dqdPE6,dfdqd_prev_vec_in_AZ_dqdPE6,dfdqd_prev_vec_in_LX_dqdPE6,dfdqd_prev_vec_in_LY_dqdPE6,dfdqd_prev_vec_in_LZ_dqdPE6,
   input  signed[(WIDTH-1):0]
      dfdqd_upd_curr_vec_in_AX_dqdPE6,dfdqd_upd_curr_vec_in_AY_dqdPE6,dfdqd_upd_curr_vec_in_AZ_dqdPE6,dfdqd_upd_curr_vec_in_LX_dqdPE6,dfdqd_upd_curr_vec_in_LY_dqdPE6,dfdqd_upd_curr_vec_in_LZ_dqdPE6,
   // dqdPE7
   input  [3:0]
      link_in_dqdPE7,
   input  [3:0]
      derv_in_dqdPE7,
   input  signed[(WIDTH-1):0]
      sinq_val_in_dqdPE7,cosq_val_in_dqdPE7,
   input  signed[(WIDTH-1):0]
      dfdqd_prev_vec_in_AX_dqdPE7,dfdqd_prev_vec_in_AY_dqdPE7,dfdqd_prev_vec_in_AZ_dqdPE7,dfdqd_prev_vec_in_LX_dqdPE7,dfdqd_prev_vec_in_LY_dqdPE7,dfdqd_prev_vec_in_LZ_dqdPE7,
   input  signed[(WIDTH-1):0]
      dfdqd_upd_curr_vec_in_AX_dqdPE7,dfdqd_upd_curr_vec_in_AY_dqdPE7,dfdqd_upd_curr_vec_in_AZ_dqdPE7,dfdqd_upd_curr_vec_in_LX_dqdPE7,dfdqd_upd_curr_vec_in_LY_dqdPE7,dfdqd_upd_curr_vec_in_LZ_dqdPE7,
   //---------------------------------------------------------------------------
   // minv external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   input  signed[(WIDTH-1):0]
      minv_block_in_R1_C1_dqdPE1,minv_block_in_R2_C1_dqdPE1,minv_block_in_R3_C1_dqdPE1,minv_block_in_R4_C1_dqdPE1,minv_block_in_R5_C1_dqdPE1,minv_block_in_R6_C1_dqdPE1,minv_block_in_R7_C1_dqdPE1,
      minv_block_in_R1_C2_dqdPE1,minv_block_in_R2_C2_dqdPE1,minv_block_in_R3_C2_dqdPE1,minv_block_in_R4_C2_dqdPE1,minv_block_in_R5_C2_dqdPE1,minv_block_in_R6_C2_dqdPE1,minv_block_in_R7_C2_dqdPE1,
      minv_block_in_R1_C3_dqdPE1,minv_block_in_R2_C3_dqdPE1,minv_block_in_R3_C3_dqdPE1,minv_block_in_R4_C3_dqdPE1,minv_block_in_R5_C3_dqdPE1,minv_block_in_R6_C3_dqdPE1,minv_block_in_R7_C3_dqdPE1,
      minv_block_in_R1_C4_dqdPE1,minv_block_in_R2_C4_dqdPE1,minv_block_in_R3_C4_dqdPE1,minv_block_in_R4_C4_dqdPE1,minv_block_in_R5_C4_dqdPE1,minv_block_in_R6_C4_dqdPE1,minv_block_in_R7_C4_dqdPE1,
      minv_block_in_R1_C5_dqdPE1,minv_block_in_R2_C5_dqdPE1,minv_block_in_R3_C5_dqdPE1,minv_block_in_R4_C5_dqdPE1,minv_block_in_R5_C5_dqdPE1,minv_block_in_R6_C5_dqdPE1,minv_block_in_R7_C5_dqdPE1,
      minv_block_in_R1_C6_dqdPE1,minv_block_in_R2_C6_dqdPE1,minv_block_in_R3_C6_dqdPE1,minv_block_in_R4_C6_dqdPE1,minv_block_in_R5_C6_dqdPE1,minv_block_in_R6_C6_dqdPE1,minv_block_in_R7_C6_dqdPE1,
      minv_block_in_R1_C7_dqdPE1,minv_block_in_R2_C7_dqdPE1,minv_block_in_R3_C7_dqdPE1,minv_block_in_R4_C7_dqdPE1,minv_block_in_R5_C7_dqdPE1,minv_block_in_R6_C7_dqdPE1,minv_block_in_R7_C7_dqdPE1,
   input  signed[(WIDTH-1):0]
      dtau_vec_in_R1_dqdPE1,dtau_vec_in_R2_dqdPE1,dtau_vec_in_R3_dqdPE1,dtau_vec_in_R4_dqdPE1,dtau_vec_in_R5_dqdPE1,dtau_vec_in_R6_dqdPE1,dtau_vec_in_R7_dqdPE1,
   // dqdPE2
   input  signed[(WIDTH-1):0]
      minv_block_in_R1_C1_dqdPE2,minv_block_in_R2_C1_dqdPE2,minv_block_in_R3_C1_dqdPE2,minv_block_in_R4_C1_dqdPE2,minv_block_in_R5_C1_dqdPE2,minv_block_in_R6_C1_dqdPE2,minv_block_in_R7_C1_dqdPE2,
      minv_block_in_R1_C2_dqdPE2,minv_block_in_R2_C2_dqdPE2,minv_block_in_R3_C2_dqdPE2,minv_block_in_R4_C2_dqdPE2,minv_block_in_R5_C2_dqdPE2,minv_block_in_R6_C2_dqdPE2,minv_block_in_R7_C2_dqdPE2,
      minv_block_in_R1_C3_dqdPE2,minv_block_in_R2_C3_dqdPE2,minv_block_in_R3_C3_dqdPE2,minv_block_in_R4_C3_dqdPE2,minv_block_in_R5_C3_dqdPE2,minv_block_in_R6_C3_dqdPE2,minv_block_in_R7_C3_dqdPE2,
      minv_block_in_R1_C4_dqdPE2,minv_block_in_R2_C4_dqdPE2,minv_block_in_R3_C4_dqdPE2,minv_block_in_R4_C4_dqdPE2,minv_block_in_R5_C4_dqdPE2,minv_block_in_R6_C4_dqdPE2,minv_block_in_R7_C4_dqdPE2,
      minv_block_in_R1_C5_dqdPE2,minv_block_in_R2_C5_dqdPE2,minv_block_in_R3_C5_dqdPE2,minv_block_in_R4_C5_dqdPE2,minv_block_in_R5_C5_dqdPE2,minv_block_in_R6_C5_dqdPE2,minv_block_in_R7_C5_dqdPE2,
      minv_block_in_R1_C6_dqdPE2,minv_block_in_R2_C6_dqdPE2,minv_block_in_R3_C6_dqdPE2,minv_block_in_R4_C6_dqdPE2,minv_block_in_R5_C6_dqdPE2,minv_block_in_R6_C6_dqdPE2,minv_block_in_R7_C6_dqdPE2,
      minv_block_in_R1_C7_dqdPE2,minv_block_in_R2_C7_dqdPE2,minv_block_in_R3_C7_dqdPE2,minv_block_in_R4_C7_dqdPE2,minv_block_in_R5_C7_dqdPE2,minv_block_in_R6_C7_dqdPE2,minv_block_in_R7_C7_dqdPE2,
   input  signed[(WIDTH-1):0]
      dtau_vec_in_R1_dqdPE2,dtau_vec_in_R2_dqdPE2,dtau_vec_in_R3_dqdPE2,dtau_vec_in_R4_dqdPE2,dtau_vec_in_R5_dqdPE2,dtau_vec_in_R6_dqdPE2,dtau_vec_in_R7_dqdPE2,
   // dqdPE3
   input  signed[(WIDTH-1):0]
      minv_block_in_R1_C1_dqdPE3,minv_block_in_R2_C1_dqdPE3,minv_block_in_R3_C1_dqdPE3,minv_block_in_R4_C1_dqdPE3,minv_block_in_R5_C1_dqdPE3,minv_block_in_R6_C1_dqdPE3,minv_block_in_R7_C1_dqdPE3,
      minv_block_in_R1_C2_dqdPE3,minv_block_in_R2_C2_dqdPE3,minv_block_in_R3_C2_dqdPE3,minv_block_in_R4_C2_dqdPE3,minv_block_in_R5_C2_dqdPE3,minv_block_in_R6_C2_dqdPE3,minv_block_in_R7_C2_dqdPE3,
      minv_block_in_R1_C3_dqdPE3,minv_block_in_R2_C3_dqdPE3,minv_block_in_R3_C3_dqdPE3,minv_block_in_R4_C3_dqdPE3,minv_block_in_R5_C3_dqdPE3,minv_block_in_R6_C3_dqdPE3,minv_block_in_R7_C3_dqdPE3,
      minv_block_in_R1_C4_dqdPE3,minv_block_in_R2_C4_dqdPE3,minv_block_in_R3_C4_dqdPE3,minv_block_in_R4_C4_dqdPE3,minv_block_in_R5_C4_dqdPE3,minv_block_in_R6_C4_dqdPE3,minv_block_in_R7_C4_dqdPE3,
      minv_block_in_R1_C5_dqdPE3,minv_block_in_R2_C5_dqdPE3,minv_block_in_R3_C5_dqdPE3,minv_block_in_R4_C5_dqdPE3,minv_block_in_R5_C5_dqdPE3,minv_block_in_R6_C5_dqdPE3,minv_block_in_R7_C5_dqdPE3,
      minv_block_in_R1_C6_dqdPE3,minv_block_in_R2_C6_dqdPE3,minv_block_in_R3_C6_dqdPE3,minv_block_in_R4_C6_dqdPE3,minv_block_in_R5_C6_dqdPE3,minv_block_in_R6_C6_dqdPE3,minv_block_in_R7_C6_dqdPE3,
      minv_block_in_R1_C7_dqdPE3,minv_block_in_R2_C7_dqdPE3,minv_block_in_R3_C7_dqdPE3,minv_block_in_R4_C7_dqdPE3,minv_block_in_R5_C7_dqdPE3,minv_block_in_R6_C7_dqdPE3,minv_block_in_R7_C7_dqdPE3,
   input  signed[(WIDTH-1):0]
      dtau_vec_in_R1_dqdPE3,dtau_vec_in_R2_dqdPE3,dtau_vec_in_R3_dqdPE3,dtau_vec_in_R4_dqdPE3,dtau_vec_in_R5_dqdPE3,dtau_vec_in_R6_dqdPE3,dtau_vec_in_R7_dqdPE3,
   // dqdPE4
   input  signed[(WIDTH-1):0]
      minv_block_in_R1_C1_dqdPE4,minv_block_in_R2_C1_dqdPE4,minv_block_in_R3_C1_dqdPE4,minv_block_in_R4_C1_dqdPE4,minv_block_in_R5_C1_dqdPE4,minv_block_in_R6_C1_dqdPE4,minv_block_in_R7_C1_dqdPE4,
      minv_block_in_R1_C2_dqdPE4,minv_block_in_R2_C2_dqdPE4,minv_block_in_R3_C2_dqdPE4,minv_block_in_R4_C2_dqdPE4,minv_block_in_R5_C2_dqdPE4,minv_block_in_R6_C2_dqdPE4,minv_block_in_R7_C2_dqdPE4,
      minv_block_in_R1_C3_dqdPE4,minv_block_in_R2_C3_dqdPE4,minv_block_in_R3_C3_dqdPE4,minv_block_in_R4_C3_dqdPE4,minv_block_in_R5_C3_dqdPE4,minv_block_in_R6_C3_dqdPE4,minv_block_in_R7_C3_dqdPE4,
      minv_block_in_R1_C4_dqdPE4,minv_block_in_R2_C4_dqdPE4,minv_block_in_R3_C4_dqdPE4,minv_block_in_R4_C4_dqdPE4,minv_block_in_R5_C4_dqdPE4,minv_block_in_R6_C4_dqdPE4,minv_block_in_R7_C4_dqdPE4,
      minv_block_in_R1_C5_dqdPE4,minv_block_in_R2_C5_dqdPE4,minv_block_in_R3_C5_dqdPE4,minv_block_in_R4_C5_dqdPE4,minv_block_in_R5_C5_dqdPE4,minv_block_in_R6_C5_dqdPE4,minv_block_in_R7_C5_dqdPE4,
      minv_block_in_R1_C6_dqdPE4,minv_block_in_R2_C6_dqdPE4,minv_block_in_R3_C6_dqdPE4,minv_block_in_R4_C6_dqdPE4,minv_block_in_R5_C6_dqdPE4,minv_block_in_R6_C6_dqdPE4,minv_block_in_R7_C6_dqdPE4,
      minv_block_in_R1_C7_dqdPE4,minv_block_in_R2_C7_dqdPE4,minv_block_in_R3_C7_dqdPE4,minv_block_in_R4_C7_dqdPE4,minv_block_in_R5_C7_dqdPE4,minv_block_in_R6_C7_dqdPE4,minv_block_in_R7_C7_dqdPE4,
   input  signed[(WIDTH-1):0]
      dtau_vec_in_R1_dqdPE4,dtau_vec_in_R2_dqdPE4,dtau_vec_in_R3_dqdPE4,dtau_vec_in_R4_dqdPE4,dtau_vec_in_R5_dqdPE4,dtau_vec_in_R6_dqdPE4,dtau_vec_in_R7_dqdPE4,
   // dqdPE5
   input  signed[(WIDTH-1):0]
      minv_block_in_R1_C1_dqdPE5,minv_block_in_R2_C1_dqdPE5,minv_block_in_R3_C1_dqdPE5,minv_block_in_R4_C1_dqdPE5,minv_block_in_R5_C1_dqdPE5,minv_block_in_R6_C1_dqdPE5,minv_block_in_R7_C1_dqdPE5,
      minv_block_in_R1_C2_dqdPE5,minv_block_in_R2_C2_dqdPE5,minv_block_in_R3_C2_dqdPE5,minv_block_in_R4_C2_dqdPE5,minv_block_in_R5_C2_dqdPE5,minv_block_in_R6_C2_dqdPE5,minv_block_in_R7_C2_dqdPE5,
      minv_block_in_R1_C3_dqdPE5,minv_block_in_R2_C3_dqdPE5,minv_block_in_R3_C3_dqdPE5,minv_block_in_R4_C3_dqdPE5,minv_block_in_R5_C3_dqdPE5,minv_block_in_R6_C3_dqdPE5,minv_block_in_R7_C3_dqdPE5,
      minv_block_in_R1_C4_dqdPE5,minv_block_in_R2_C4_dqdPE5,minv_block_in_R3_C4_dqdPE5,minv_block_in_R4_C4_dqdPE5,minv_block_in_R5_C4_dqdPE5,minv_block_in_R6_C4_dqdPE5,minv_block_in_R7_C4_dqdPE5,
      minv_block_in_R1_C5_dqdPE5,minv_block_in_R2_C5_dqdPE5,minv_block_in_R3_C5_dqdPE5,minv_block_in_R4_C5_dqdPE5,minv_block_in_R5_C5_dqdPE5,minv_block_in_R6_C5_dqdPE5,minv_block_in_R7_C5_dqdPE5,
      minv_block_in_R1_C6_dqdPE5,minv_block_in_R2_C6_dqdPE5,minv_block_in_R3_C6_dqdPE5,minv_block_in_R4_C6_dqdPE5,minv_block_in_R5_C6_dqdPE5,minv_block_in_R6_C6_dqdPE5,minv_block_in_R7_C6_dqdPE5,
      minv_block_in_R1_C7_dqdPE5,minv_block_in_R2_C7_dqdPE5,minv_block_in_R3_C7_dqdPE5,minv_block_in_R4_C7_dqdPE5,minv_block_in_R5_C7_dqdPE5,minv_block_in_R6_C7_dqdPE5,minv_block_in_R7_C7_dqdPE5,
   input  signed[(WIDTH-1):0]
      dtau_vec_in_R1_dqdPE5,dtau_vec_in_R2_dqdPE5,dtau_vec_in_R3_dqdPE5,dtau_vec_in_R4_dqdPE5,dtau_vec_in_R5_dqdPE5,dtau_vec_in_R6_dqdPE5,dtau_vec_in_R7_dqdPE5,
   // dqdPE6
   input  signed[(WIDTH-1):0]
      minv_block_in_R1_C1_dqdPE6,minv_block_in_R2_C1_dqdPE6,minv_block_in_R3_C1_dqdPE6,minv_block_in_R4_C1_dqdPE6,minv_block_in_R5_C1_dqdPE6,minv_block_in_R6_C1_dqdPE6,minv_block_in_R7_C1_dqdPE6,
      minv_block_in_R1_C2_dqdPE6,minv_block_in_R2_C2_dqdPE6,minv_block_in_R3_C2_dqdPE6,minv_block_in_R4_C2_dqdPE6,minv_block_in_R5_C2_dqdPE6,minv_block_in_R6_C2_dqdPE6,minv_block_in_R7_C2_dqdPE6,
      minv_block_in_R1_C3_dqdPE6,minv_block_in_R2_C3_dqdPE6,minv_block_in_R3_C3_dqdPE6,minv_block_in_R4_C3_dqdPE6,minv_block_in_R5_C3_dqdPE6,minv_block_in_R6_C3_dqdPE6,minv_block_in_R7_C3_dqdPE6,
      minv_block_in_R1_C4_dqdPE6,minv_block_in_R2_C4_dqdPE6,minv_block_in_R3_C4_dqdPE6,minv_block_in_R4_C4_dqdPE6,minv_block_in_R5_C4_dqdPE6,minv_block_in_R6_C4_dqdPE6,minv_block_in_R7_C4_dqdPE6,
      minv_block_in_R1_C5_dqdPE6,minv_block_in_R2_C5_dqdPE6,minv_block_in_R3_C5_dqdPE6,minv_block_in_R4_C5_dqdPE6,minv_block_in_R5_C5_dqdPE6,minv_block_in_R6_C5_dqdPE6,minv_block_in_R7_C5_dqdPE6,
      minv_block_in_R1_C6_dqdPE6,minv_block_in_R2_C6_dqdPE6,minv_block_in_R3_C6_dqdPE6,minv_block_in_R4_C6_dqdPE6,minv_block_in_R5_C6_dqdPE6,minv_block_in_R6_C6_dqdPE6,minv_block_in_R7_C6_dqdPE6,
      minv_block_in_R1_C7_dqdPE6,minv_block_in_R2_C7_dqdPE6,minv_block_in_R3_C7_dqdPE6,minv_block_in_R4_C7_dqdPE6,minv_block_in_R5_C7_dqdPE6,minv_block_in_R6_C7_dqdPE6,minv_block_in_R7_C7_dqdPE6,
   input  signed[(WIDTH-1):0]
      dtau_vec_in_R1_dqdPE6,dtau_vec_in_R2_dqdPE6,dtau_vec_in_R3_dqdPE6,dtau_vec_in_R4_dqdPE6,dtau_vec_in_R5_dqdPE6,dtau_vec_in_R6_dqdPE6,dtau_vec_in_R7_dqdPE6,
   // dqdPE7
   input  signed[(WIDTH-1):0]
      minv_block_in_R1_C1_dqdPE7,minv_block_in_R2_C1_dqdPE7,minv_block_in_R3_C1_dqdPE7,minv_block_in_R4_C1_dqdPE7,minv_block_in_R5_C1_dqdPE7,minv_block_in_R6_C1_dqdPE7,minv_block_in_R7_C1_dqdPE7,
      minv_block_in_R1_C2_dqdPE7,minv_block_in_R2_C2_dqdPE7,minv_block_in_R3_C2_dqdPE7,minv_block_in_R4_C2_dqdPE7,minv_block_in_R5_C2_dqdPE7,minv_block_in_R6_C2_dqdPE7,minv_block_in_R7_C2_dqdPE7,
      minv_block_in_R1_C3_dqdPE7,minv_block_in_R2_C3_dqdPE7,minv_block_in_R3_C3_dqdPE7,minv_block_in_R4_C3_dqdPE7,minv_block_in_R5_C3_dqdPE7,minv_block_in_R6_C3_dqdPE7,minv_block_in_R7_C3_dqdPE7,
      minv_block_in_R1_C4_dqdPE7,minv_block_in_R2_C4_dqdPE7,minv_block_in_R3_C4_dqdPE7,minv_block_in_R4_C4_dqdPE7,minv_block_in_R5_C4_dqdPE7,minv_block_in_R6_C4_dqdPE7,minv_block_in_R7_C4_dqdPE7,
      minv_block_in_R1_C5_dqdPE7,minv_block_in_R2_C5_dqdPE7,minv_block_in_R3_C5_dqdPE7,minv_block_in_R4_C5_dqdPE7,minv_block_in_R5_C5_dqdPE7,minv_block_in_R6_C5_dqdPE7,minv_block_in_R7_C5_dqdPE7,
      minv_block_in_R1_C6_dqdPE7,minv_block_in_R2_C6_dqdPE7,minv_block_in_R3_C6_dqdPE7,minv_block_in_R4_C6_dqdPE7,minv_block_in_R5_C6_dqdPE7,minv_block_in_R6_C6_dqdPE7,minv_block_in_R7_C6_dqdPE7,
      minv_block_in_R1_C7_dqdPE7,minv_block_in_R2_C7_dqdPE7,minv_block_in_R3_C7_dqdPE7,minv_block_in_R4_C7_dqdPE7,minv_block_in_R5_C7_dqdPE7,minv_block_in_R6_C7_dqdPE7,minv_block_in_R7_C7_dqdPE7,
   input  signed[(WIDTH-1):0]
      dtau_vec_in_R1_dqdPE7,dtau_vec_in_R2_dqdPE7,dtau_vec_in_R3_dqdPE7,dtau_vec_in_R4_dqdPE7,dtau_vec_in_R5_dqdPE7,dtau_vec_in_R6_dqdPE7,dtau_vec_in_R7_dqdPE7,
   //---------------------------------------------------------------------------
   // output_ready
   output output_ready,
   // output_ready_minv
   output output_ready_minv,
   //---------------------------------------------------------------------------
   // rnea external outputs
   //---------------------------------------------------------------------------
   // rnea
   output signed[(WIDTH-1):0]
      tau_curr_out_rnea,
   output signed[(WIDTH-1):0]
      f_upd_prev_vec_out_AX_rnea,f_upd_prev_vec_out_AY_rnea,f_upd_prev_vec_out_AZ_rnea,f_upd_prev_vec_out_LX_rnea,f_upd_prev_vec_out_LY_rnea,f_upd_prev_vec_out_LZ_rnea,
   //---------------------------------------------------------------------------
   // dq external outputs
   //---------------------------------------------------------------------------
   // dqPE1
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqPE1,
   output signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE1,dfdq_upd_prev_vec_out_AY_dqPE1,dfdq_upd_prev_vec_out_AZ_dqPE1,dfdq_upd_prev_vec_out_LX_dqPE1,dfdq_upd_prev_vec_out_LY_dqPE1,dfdq_upd_prev_vec_out_LZ_dqPE1,
   // dqPE2
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqPE2,
   output signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE2,dfdq_upd_prev_vec_out_AY_dqPE2,dfdq_upd_prev_vec_out_AZ_dqPE2,dfdq_upd_prev_vec_out_LX_dqPE2,dfdq_upd_prev_vec_out_LY_dqPE2,dfdq_upd_prev_vec_out_LZ_dqPE2,
   // dqPE3
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqPE3,
   output signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE3,dfdq_upd_prev_vec_out_AY_dqPE3,dfdq_upd_prev_vec_out_AZ_dqPE3,dfdq_upd_prev_vec_out_LX_dqPE3,dfdq_upd_prev_vec_out_LY_dqPE3,dfdq_upd_prev_vec_out_LZ_dqPE3,
   // dqPE4
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqPE4,
   output signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE4,dfdq_upd_prev_vec_out_AY_dqPE4,dfdq_upd_prev_vec_out_AZ_dqPE4,dfdq_upd_prev_vec_out_LX_dqPE4,dfdq_upd_prev_vec_out_LY_dqPE4,dfdq_upd_prev_vec_out_LZ_dqPE4,
   // dqPE5
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqPE5,
   output signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE5,dfdq_upd_prev_vec_out_AY_dqPE5,dfdq_upd_prev_vec_out_AZ_dqPE5,dfdq_upd_prev_vec_out_LX_dqPE5,dfdq_upd_prev_vec_out_LY_dqPE5,dfdq_upd_prev_vec_out_LZ_dqPE5,
   // dqPE6
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqPE6,
   output signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE6,dfdq_upd_prev_vec_out_AY_dqPE6,dfdq_upd_prev_vec_out_AZ_dqPE6,dfdq_upd_prev_vec_out_LX_dqPE6,dfdq_upd_prev_vec_out_LY_dqPE6,dfdq_upd_prev_vec_out_LZ_dqPE6,
   // dqPE7
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqPE7,
   output signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE7,dfdq_upd_prev_vec_out_AY_dqPE7,dfdq_upd_prev_vec_out_AZ_dqPE7,dfdq_upd_prev_vec_out_LX_dqPE7,dfdq_upd_prev_vec_out_LY_dqPE7,dfdq_upd_prev_vec_out_LZ_dqPE7,
   //---------------------------------------------------------------------------
   // dqd external outputs
   //---------------------------------------------------------------------------
   // dqdPE1
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE1,
   output signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE1,dfdqd_upd_prev_vec_out_AY_dqdPE1,dfdqd_upd_prev_vec_out_AZ_dqdPE1,dfdqd_upd_prev_vec_out_LX_dqdPE1,dfdqd_upd_prev_vec_out_LY_dqdPE1,dfdqd_upd_prev_vec_out_LZ_dqdPE1,
   // dqdPE2
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE2,
   output signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE2,dfdqd_upd_prev_vec_out_AY_dqdPE2,dfdqd_upd_prev_vec_out_AZ_dqdPE2,dfdqd_upd_prev_vec_out_LX_dqdPE2,dfdqd_upd_prev_vec_out_LY_dqdPE2,dfdqd_upd_prev_vec_out_LZ_dqdPE2,
   // dqdPE3
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE3,
   output signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE3,dfdqd_upd_prev_vec_out_AY_dqdPE3,dfdqd_upd_prev_vec_out_AZ_dqdPE3,dfdqd_upd_prev_vec_out_LX_dqdPE3,dfdqd_upd_prev_vec_out_LY_dqdPE3,dfdqd_upd_prev_vec_out_LZ_dqdPE3,
   // dqdPE4
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE4,
   output signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE4,dfdqd_upd_prev_vec_out_AY_dqdPE4,dfdqd_upd_prev_vec_out_AZ_dqdPE4,dfdqd_upd_prev_vec_out_LX_dqdPE4,dfdqd_upd_prev_vec_out_LY_dqdPE4,dfdqd_upd_prev_vec_out_LZ_dqdPE4,
   // dqdPE5
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE5,
   output signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE5,dfdqd_upd_prev_vec_out_AY_dqdPE5,dfdqd_upd_prev_vec_out_AZ_dqdPE5,dfdqd_upd_prev_vec_out_LX_dqdPE5,dfdqd_upd_prev_vec_out_LY_dqdPE5,dfdqd_upd_prev_vec_out_LZ_dqdPE5,
   // dqdPE6
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE6,
   output signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE6,dfdqd_upd_prev_vec_out_AY_dqdPE6,dfdqd_upd_prev_vec_out_AZ_dqdPE6,dfdqd_upd_prev_vec_out_LX_dqdPE6,dfdqd_upd_prev_vec_out_LY_dqdPE6,dfdqd_upd_prev_vec_out_LZ_dqdPE6,
   // dqdPE7
   output signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE7,
   output signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE7,dfdqd_upd_prev_vec_out_AY_dqdPE7,dfdqd_upd_prev_vec_out_AZ_dqdPE7,dfdqd_upd_prev_vec_out_LX_dqdPE7,dfdqd_upd_prev_vec_out_LY_dqdPE7,dfdqd_upd_prev_vec_out_LZ_dqdPE7,
   //---------------------------------------------------------------------------
   // minv external outputs
   //---------------------------------------------------------------------------
   // dqdPE1
   output signed[(WIDTH-1):0]
      minv_vec_out_R1_dqdPE1,minv_vec_out_R2_dqdPE1,minv_vec_out_R3_dqdPE1,minv_vec_out_R4_dqdPE1,minv_vec_out_R5_dqdPE1,minv_vec_out_R6_dqdPE1,minv_vec_out_R7_dqdPE1,
   // dqdPE2
   output signed[(WIDTH-1):0]
      minv_vec_out_R1_dqdPE2,minv_vec_out_R2_dqdPE2,minv_vec_out_R3_dqdPE2,minv_vec_out_R4_dqdPE2,minv_vec_out_R5_dqdPE2,minv_vec_out_R6_dqdPE2,minv_vec_out_R7_dqdPE2,
   // dqdPE3
   output signed[(WIDTH-1):0]
      minv_vec_out_R1_dqdPE3,minv_vec_out_R2_dqdPE3,minv_vec_out_R3_dqdPE3,minv_vec_out_R4_dqdPE3,minv_vec_out_R5_dqdPE3,minv_vec_out_R6_dqdPE3,minv_vec_out_R7_dqdPE3,
   // dqdPE4
   output signed[(WIDTH-1):0]
      minv_vec_out_R1_dqdPE4,minv_vec_out_R2_dqdPE4,minv_vec_out_R3_dqdPE4,minv_vec_out_R4_dqdPE4,minv_vec_out_R5_dqdPE4,minv_vec_out_R6_dqdPE4,minv_vec_out_R7_dqdPE4,
   // dqdPE5
   output signed[(WIDTH-1):0]
      minv_vec_out_R1_dqdPE5,minv_vec_out_R2_dqdPE5,minv_vec_out_R3_dqdPE5,minv_vec_out_R4_dqdPE5,minv_vec_out_R5_dqdPE5,minv_vec_out_R6_dqdPE5,minv_vec_out_R7_dqdPE5,
   // dqdPE6
   output signed[(WIDTH-1):0]
      minv_vec_out_R1_dqdPE6,minv_vec_out_R2_dqdPE6,minv_vec_out_R3_dqdPE6,minv_vec_out_R4_dqdPE6,minv_vec_out_R5_dqdPE6,minv_vec_out_R6_dqdPE6,minv_vec_out_R7_dqdPE6,
   // dqdPE7
   output signed[(WIDTH-1):0]
      minv_vec_out_R1_dqdPE7,minv_vec_out_R2_dqdPE7,minv_vec_out_R3_dqdPE7,minv_vec_out_R4_dqdPE7,minv_vec_out_R5_dqdPE7,minv_vec_out_R6_dqdPE7,minv_vec_out_R7_dqdPE7
   //---------------------------------------------------------------------------
   );

   //---------------------------------------------------------------------------
   // external wires and state
   //---------------------------------------------------------------------------
   // registers
   reg get_data_reg;
   reg get_data_minv_reg;
   reg output_ready_reg;
   reg output_ready_minv_reg;
   reg minv_bool_reg;
   reg [2:0]
      state_reg;
   reg [2:0]
      state_minv_reg;
   //---------------------------------------------------------------------------
   // rnea external inputs
   //---------------------------------------------------------------------------
   // rnea
   reg [3:0]
      link_reg_rnea;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_rnea,cosq_val_reg_rnea,
      f_upd_curr_vec_reg_AX_rnea,f_upd_curr_vec_reg_AY_rnea,f_upd_curr_vec_reg_AZ_rnea,f_upd_curr_vec_reg_LX_rnea,f_upd_curr_vec_reg_LY_rnea,f_upd_curr_vec_reg_LZ_rnea,
      f_prev_vec_reg_AX_rnea,f_prev_vec_reg_AY_rnea,f_prev_vec_reg_AZ_rnea,f_prev_vec_reg_LX_rnea,f_prev_vec_reg_LY_rnea,f_prev_vec_reg_LZ_rnea;
   //---------------------------------------------------------------------------
   // dq external inputs
   //---------------------------------------------------------------------------
   // dqPE1
   reg [3:0]
      link_reg_dqPE1;
   reg [3:0]
      derv_reg_dqPE1;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE1,cosq_val_reg_dqPE1,
      f_upd_curr_vec_reg_AX_dqPE1,f_upd_curr_vec_reg_AY_dqPE1,f_upd_curr_vec_reg_AZ_dqPE1,f_upd_curr_vec_reg_LX_dqPE1,f_upd_curr_vec_reg_LY_dqPE1,f_upd_curr_vec_reg_LZ_dqPE1,
      dfdq_prev_vec_reg_AX_dqPE1,dfdq_prev_vec_reg_AY_dqPE1,dfdq_prev_vec_reg_AZ_dqPE1,dfdq_prev_vec_reg_LX_dqPE1,dfdq_prev_vec_reg_LY_dqPE1,dfdq_prev_vec_reg_LZ_dqPE1,
      dfdq_upd_curr_vec_reg_AX_dqPE1,dfdq_upd_curr_vec_reg_AY_dqPE1,dfdq_upd_curr_vec_reg_AZ_dqPE1,dfdq_upd_curr_vec_reg_LX_dqPE1,dfdq_upd_curr_vec_reg_LY_dqPE1,dfdq_upd_curr_vec_reg_LZ_dqPE1;
   // dqPE2
   reg [3:0]
      link_reg_dqPE2;
   reg [3:0]
      derv_reg_dqPE2;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE2,cosq_val_reg_dqPE2,
      f_upd_curr_vec_reg_AX_dqPE2,f_upd_curr_vec_reg_AY_dqPE2,f_upd_curr_vec_reg_AZ_dqPE2,f_upd_curr_vec_reg_LX_dqPE2,f_upd_curr_vec_reg_LY_dqPE2,f_upd_curr_vec_reg_LZ_dqPE2,
      dfdq_prev_vec_reg_AX_dqPE2,dfdq_prev_vec_reg_AY_dqPE2,dfdq_prev_vec_reg_AZ_dqPE2,dfdq_prev_vec_reg_LX_dqPE2,dfdq_prev_vec_reg_LY_dqPE2,dfdq_prev_vec_reg_LZ_dqPE2,
      dfdq_upd_curr_vec_reg_AX_dqPE2,dfdq_upd_curr_vec_reg_AY_dqPE2,dfdq_upd_curr_vec_reg_AZ_dqPE2,dfdq_upd_curr_vec_reg_LX_dqPE2,dfdq_upd_curr_vec_reg_LY_dqPE2,dfdq_upd_curr_vec_reg_LZ_dqPE2;
   // dqPE3
   reg [3:0]
      link_reg_dqPE3;
   reg [3:0]
      derv_reg_dqPE3;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE3,cosq_val_reg_dqPE3,
      f_upd_curr_vec_reg_AX_dqPE3,f_upd_curr_vec_reg_AY_dqPE3,f_upd_curr_vec_reg_AZ_dqPE3,f_upd_curr_vec_reg_LX_dqPE3,f_upd_curr_vec_reg_LY_dqPE3,f_upd_curr_vec_reg_LZ_dqPE3,
      dfdq_prev_vec_reg_AX_dqPE3,dfdq_prev_vec_reg_AY_dqPE3,dfdq_prev_vec_reg_AZ_dqPE3,dfdq_prev_vec_reg_LX_dqPE3,dfdq_prev_vec_reg_LY_dqPE3,dfdq_prev_vec_reg_LZ_dqPE3,
      dfdq_upd_curr_vec_reg_AX_dqPE3,dfdq_upd_curr_vec_reg_AY_dqPE3,dfdq_upd_curr_vec_reg_AZ_dqPE3,dfdq_upd_curr_vec_reg_LX_dqPE3,dfdq_upd_curr_vec_reg_LY_dqPE3,dfdq_upd_curr_vec_reg_LZ_dqPE3;
   // dqPE4
   reg [3:0]
      link_reg_dqPE4;
   reg [3:0]
      derv_reg_dqPE4;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE4,cosq_val_reg_dqPE4,
      f_upd_curr_vec_reg_AX_dqPE4,f_upd_curr_vec_reg_AY_dqPE4,f_upd_curr_vec_reg_AZ_dqPE4,f_upd_curr_vec_reg_LX_dqPE4,f_upd_curr_vec_reg_LY_dqPE4,f_upd_curr_vec_reg_LZ_dqPE4,
      dfdq_prev_vec_reg_AX_dqPE4,dfdq_prev_vec_reg_AY_dqPE4,dfdq_prev_vec_reg_AZ_dqPE4,dfdq_prev_vec_reg_LX_dqPE4,dfdq_prev_vec_reg_LY_dqPE4,dfdq_prev_vec_reg_LZ_dqPE4,
      dfdq_upd_curr_vec_reg_AX_dqPE4,dfdq_upd_curr_vec_reg_AY_dqPE4,dfdq_upd_curr_vec_reg_AZ_dqPE4,dfdq_upd_curr_vec_reg_LX_dqPE4,dfdq_upd_curr_vec_reg_LY_dqPE4,dfdq_upd_curr_vec_reg_LZ_dqPE4;
   // dqPE5
   reg [3:0]
      link_reg_dqPE5;
   reg [3:0]
      derv_reg_dqPE5;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE5,cosq_val_reg_dqPE5,
      f_upd_curr_vec_reg_AX_dqPE5,f_upd_curr_vec_reg_AY_dqPE5,f_upd_curr_vec_reg_AZ_dqPE5,f_upd_curr_vec_reg_LX_dqPE5,f_upd_curr_vec_reg_LY_dqPE5,f_upd_curr_vec_reg_LZ_dqPE5,
      dfdq_prev_vec_reg_AX_dqPE5,dfdq_prev_vec_reg_AY_dqPE5,dfdq_prev_vec_reg_AZ_dqPE5,dfdq_prev_vec_reg_LX_dqPE5,dfdq_prev_vec_reg_LY_dqPE5,dfdq_prev_vec_reg_LZ_dqPE5,
      dfdq_upd_curr_vec_reg_AX_dqPE5,dfdq_upd_curr_vec_reg_AY_dqPE5,dfdq_upd_curr_vec_reg_AZ_dqPE5,dfdq_upd_curr_vec_reg_LX_dqPE5,dfdq_upd_curr_vec_reg_LY_dqPE5,dfdq_upd_curr_vec_reg_LZ_dqPE5;
   // dqPE6
   reg [3:0]
      link_reg_dqPE6;
   reg [3:0]
      derv_reg_dqPE6;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE6,cosq_val_reg_dqPE6,
      f_upd_curr_vec_reg_AX_dqPE6,f_upd_curr_vec_reg_AY_dqPE6,f_upd_curr_vec_reg_AZ_dqPE6,f_upd_curr_vec_reg_LX_dqPE6,f_upd_curr_vec_reg_LY_dqPE6,f_upd_curr_vec_reg_LZ_dqPE6,
      dfdq_prev_vec_reg_AX_dqPE6,dfdq_prev_vec_reg_AY_dqPE6,dfdq_prev_vec_reg_AZ_dqPE6,dfdq_prev_vec_reg_LX_dqPE6,dfdq_prev_vec_reg_LY_dqPE6,dfdq_prev_vec_reg_LZ_dqPE6,
      dfdq_upd_curr_vec_reg_AX_dqPE6,dfdq_upd_curr_vec_reg_AY_dqPE6,dfdq_upd_curr_vec_reg_AZ_dqPE6,dfdq_upd_curr_vec_reg_LX_dqPE6,dfdq_upd_curr_vec_reg_LY_dqPE6,dfdq_upd_curr_vec_reg_LZ_dqPE6;
   // dqPE7
   reg [3:0]
      link_reg_dqPE7;
   reg [3:0]
      derv_reg_dqPE7;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqPE7,cosq_val_reg_dqPE7,
      f_upd_curr_vec_reg_AX_dqPE7,f_upd_curr_vec_reg_AY_dqPE7,f_upd_curr_vec_reg_AZ_dqPE7,f_upd_curr_vec_reg_LX_dqPE7,f_upd_curr_vec_reg_LY_dqPE7,f_upd_curr_vec_reg_LZ_dqPE7,
      dfdq_prev_vec_reg_AX_dqPE7,dfdq_prev_vec_reg_AY_dqPE7,dfdq_prev_vec_reg_AZ_dqPE7,dfdq_prev_vec_reg_LX_dqPE7,dfdq_prev_vec_reg_LY_dqPE7,dfdq_prev_vec_reg_LZ_dqPE7,
      dfdq_upd_curr_vec_reg_AX_dqPE7,dfdq_upd_curr_vec_reg_AY_dqPE7,dfdq_upd_curr_vec_reg_AZ_dqPE7,dfdq_upd_curr_vec_reg_LX_dqPE7,dfdq_upd_curr_vec_reg_LY_dqPE7,dfdq_upd_curr_vec_reg_LZ_dqPE7;
   //---------------------------------------------------------------------------
   // dqd external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   reg [3:0]
      link_reg_dqdPE1;
   reg [3:0]
      derv_reg_dqdPE1;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE1,cosq_val_reg_dqdPE1,
      dfdqd_prev_vec_reg_AX_dqdPE1,dfdqd_prev_vec_reg_AY_dqdPE1,dfdqd_prev_vec_reg_AZ_dqdPE1,dfdqd_prev_vec_reg_LX_dqdPE1,dfdqd_prev_vec_reg_LY_dqdPE1,dfdqd_prev_vec_reg_LZ_dqdPE1,
      dfdqd_upd_curr_vec_reg_AX_dqdPE1,dfdqd_upd_curr_vec_reg_AY_dqdPE1,dfdqd_upd_curr_vec_reg_AZ_dqdPE1,dfdqd_upd_curr_vec_reg_LX_dqdPE1,dfdqd_upd_curr_vec_reg_LY_dqdPE1,dfdqd_upd_curr_vec_reg_LZ_dqdPE1;
   // dqdPE2
   reg [3:0]
      link_reg_dqdPE2;
   reg [3:0]
      derv_reg_dqdPE2;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE2,cosq_val_reg_dqdPE2,
      dfdqd_prev_vec_reg_AX_dqdPE2,dfdqd_prev_vec_reg_AY_dqdPE2,dfdqd_prev_vec_reg_AZ_dqdPE2,dfdqd_prev_vec_reg_LX_dqdPE2,dfdqd_prev_vec_reg_LY_dqdPE2,dfdqd_prev_vec_reg_LZ_dqdPE2,
      dfdqd_upd_curr_vec_reg_AX_dqdPE2,dfdqd_upd_curr_vec_reg_AY_dqdPE2,dfdqd_upd_curr_vec_reg_AZ_dqdPE2,dfdqd_upd_curr_vec_reg_LX_dqdPE2,dfdqd_upd_curr_vec_reg_LY_dqdPE2,dfdqd_upd_curr_vec_reg_LZ_dqdPE2;
   // dqdPE3
   reg [3:0]
      link_reg_dqdPE3;
   reg [3:0]
      derv_reg_dqdPE3;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE3,cosq_val_reg_dqdPE3,
      dfdqd_prev_vec_reg_AX_dqdPE3,dfdqd_prev_vec_reg_AY_dqdPE3,dfdqd_prev_vec_reg_AZ_dqdPE3,dfdqd_prev_vec_reg_LX_dqdPE3,dfdqd_prev_vec_reg_LY_dqdPE3,dfdqd_prev_vec_reg_LZ_dqdPE3,
      dfdqd_upd_curr_vec_reg_AX_dqdPE3,dfdqd_upd_curr_vec_reg_AY_dqdPE3,dfdqd_upd_curr_vec_reg_AZ_dqdPE3,dfdqd_upd_curr_vec_reg_LX_dqdPE3,dfdqd_upd_curr_vec_reg_LY_dqdPE3,dfdqd_upd_curr_vec_reg_LZ_dqdPE3;
   // dqdPE4
   reg [3:0]
      link_reg_dqdPE4;
   reg [3:0]
      derv_reg_dqdPE4;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE4,cosq_val_reg_dqdPE4,
      dfdqd_prev_vec_reg_AX_dqdPE4,dfdqd_prev_vec_reg_AY_dqdPE4,dfdqd_prev_vec_reg_AZ_dqdPE4,dfdqd_prev_vec_reg_LX_dqdPE4,dfdqd_prev_vec_reg_LY_dqdPE4,dfdqd_prev_vec_reg_LZ_dqdPE4,
      dfdqd_upd_curr_vec_reg_AX_dqdPE4,dfdqd_upd_curr_vec_reg_AY_dqdPE4,dfdqd_upd_curr_vec_reg_AZ_dqdPE4,dfdqd_upd_curr_vec_reg_LX_dqdPE4,dfdqd_upd_curr_vec_reg_LY_dqdPE4,dfdqd_upd_curr_vec_reg_LZ_dqdPE4;
   // dqdPE5
   reg [3:0]
      link_reg_dqdPE5;
   reg [3:0]
      derv_reg_dqdPE5;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE5,cosq_val_reg_dqdPE5,
      dfdqd_prev_vec_reg_AX_dqdPE5,dfdqd_prev_vec_reg_AY_dqdPE5,dfdqd_prev_vec_reg_AZ_dqdPE5,dfdqd_prev_vec_reg_LX_dqdPE5,dfdqd_prev_vec_reg_LY_dqdPE5,dfdqd_prev_vec_reg_LZ_dqdPE5,
      dfdqd_upd_curr_vec_reg_AX_dqdPE5,dfdqd_upd_curr_vec_reg_AY_dqdPE5,dfdqd_upd_curr_vec_reg_AZ_dqdPE5,dfdqd_upd_curr_vec_reg_LX_dqdPE5,dfdqd_upd_curr_vec_reg_LY_dqdPE5,dfdqd_upd_curr_vec_reg_LZ_dqdPE5;
   // dqdPE6
   reg [3:0]
      link_reg_dqdPE6;
   reg [3:0]
      derv_reg_dqdPE6;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE6,cosq_val_reg_dqdPE6,
      dfdqd_prev_vec_reg_AX_dqdPE6,dfdqd_prev_vec_reg_AY_dqdPE6,dfdqd_prev_vec_reg_AZ_dqdPE6,dfdqd_prev_vec_reg_LX_dqdPE6,dfdqd_prev_vec_reg_LY_dqdPE6,dfdqd_prev_vec_reg_LZ_dqdPE6,
      dfdqd_upd_curr_vec_reg_AX_dqdPE6,dfdqd_upd_curr_vec_reg_AY_dqdPE6,dfdqd_upd_curr_vec_reg_AZ_dqdPE6,dfdqd_upd_curr_vec_reg_LX_dqdPE6,dfdqd_upd_curr_vec_reg_LY_dqdPE6,dfdqd_upd_curr_vec_reg_LZ_dqdPE6;
   // dqdPE7
   reg [3:0]
      link_reg_dqdPE7;
   reg [3:0]
      derv_reg_dqdPE7;
   reg signed[(WIDTH-1):0]
      sinq_val_reg_dqdPE7,cosq_val_reg_dqdPE7,
      dfdqd_prev_vec_reg_AX_dqdPE7,dfdqd_prev_vec_reg_AY_dqdPE7,dfdqd_prev_vec_reg_AZ_dqdPE7,dfdqd_prev_vec_reg_LX_dqdPE7,dfdqd_prev_vec_reg_LY_dqdPE7,dfdqd_prev_vec_reg_LZ_dqdPE7,
      dfdqd_upd_curr_vec_reg_AX_dqdPE7,dfdqd_upd_curr_vec_reg_AY_dqdPE7,dfdqd_upd_curr_vec_reg_AZ_dqdPE7,dfdqd_upd_curr_vec_reg_LX_dqdPE7,dfdqd_upd_curr_vec_reg_LY_dqdPE7,dfdqd_upd_curr_vec_reg_LZ_dqdPE7;
   //---------------------------------------------------------------------------
   // minv external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   reg signed[(WIDTH-1):0]
      minv_block_reg_R1_C1_dqdPE1,minv_block_reg_R2_C1_dqdPE1,minv_block_reg_R3_C1_dqdPE1,minv_block_reg_R4_C1_dqdPE1,minv_block_reg_R5_C1_dqdPE1,minv_block_reg_R6_C1_dqdPE1,minv_block_reg_R7_C1_dqdPE1,
      minv_block_reg_R1_C2_dqdPE1,minv_block_reg_R2_C2_dqdPE1,minv_block_reg_R3_C2_dqdPE1,minv_block_reg_R4_C2_dqdPE1,minv_block_reg_R5_C2_dqdPE1,minv_block_reg_R6_C2_dqdPE1,minv_block_reg_R7_C2_dqdPE1,
      minv_block_reg_R1_C3_dqdPE1,minv_block_reg_R2_C3_dqdPE1,minv_block_reg_R3_C3_dqdPE1,minv_block_reg_R4_C3_dqdPE1,minv_block_reg_R5_C3_dqdPE1,minv_block_reg_R6_C3_dqdPE1,minv_block_reg_R7_C3_dqdPE1,
      minv_block_reg_R1_C4_dqdPE1,minv_block_reg_R2_C4_dqdPE1,minv_block_reg_R3_C4_dqdPE1,minv_block_reg_R4_C4_dqdPE1,minv_block_reg_R5_C4_dqdPE1,minv_block_reg_R6_C4_dqdPE1,minv_block_reg_R7_C4_dqdPE1,
      minv_block_reg_R1_C5_dqdPE1,minv_block_reg_R2_C5_dqdPE1,minv_block_reg_R3_C5_dqdPE1,minv_block_reg_R4_C5_dqdPE1,minv_block_reg_R5_C5_dqdPE1,minv_block_reg_R6_C5_dqdPE1,minv_block_reg_R7_C5_dqdPE1,
      minv_block_reg_R1_C6_dqdPE1,minv_block_reg_R2_C6_dqdPE1,minv_block_reg_R3_C6_dqdPE1,minv_block_reg_R4_C6_dqdPE1,minv_block_reg_R5_C6_dqdPE1,minv_block_reg_R6_C6_dqdPE1,minv_block_reg_R7_C6_dqdPE1,
      minv_block_reg_R1_C7_dqdPE1,minv_block_reg_R2_C7_dqdPE1,minv_block_reg_R3_C7_dqdPE1,minv_block_reg_R4_C7_dqdPE1,minv_block_reg_R5_C7_dqdPE1,minv_block_reg_R6_C7_dqdPE1,minv_block_reg_R7_C7_dqdPE1;
   reg signed[(WIDTH-1):0]
      dtau_vec_reg_R1_dqdPE1,dtau_vec_reg_R2_dqdPE1,dtau_vec_reg_R3_dqdPE1,dtau_vec_reg_R4_dqdPE1,dtau_vec_reg_R5_dqdPE1,dtau_vec_reg_R6_dqdPE1,dtau_vec_reg_R7_dqdPE1;
   // dqdPE2
   reg signed[(WIDTH-1):0]
      minv_block_reg_R1_C1_dqdPE2,minv_block_reg_R2_C1_dqdPE2,minv_block_reg_R3_C1_dqdPE2,minv_block_reg_R4_C1_dqdPE2,minv_block_reg_R5_C1_dqdPE2,minv_block_reg_R6_C1_dqdPE2,minv_block_reg_R7_C1_dqdPE2,
      minv_block_reg_R1_C2_dqdPE2,minv_block_reg_R2_C2_dqdPE2,minv_block_reg_R3_C2_dqdPE2,minv_block_reg_R4_C2_dqdPE2,minv_block_reg_R5_C2_dqdPE2,minv_block_reg_R6_C2_dqdPE2,minv_block_reg_R7_C2_dqdPE2,
      minv_block_reg_R1_C3_dqdPE2,minv_block_reg_R2_C3_dqdPE2,minv_block_reg_R3_C3_dqdPE2,minv_block_reg_R4_C3_dqdPE2,minv_block_reg_R5_C3_dqdPE2,minv_block_reg_R6_C3_dqdPE2,minv_block_reg_R7_C3_dqdPE2,
      minv_block_reg_R1_C4_dqdPE2,minv_block_reg_R2_C4_dqdPE2,minv_block_reg_R3_C4_dqdPE2,minv_block_reg_R4_C4_dqdPE2,minv_block_reg_R5_C4_dqdPE2,minv_block_reg_R6_C4_dqdPE2,minv_block_reg_R7_C4_dqdPE2,
      minv_block_reg_R1_C5_dqdPE2,minv_block_reg_R2_C5_dqdPE2,minv_block_reg_R3_C5_dqdPE2,minv_block_reg_R4_C5_dqdPE2,minv_block_reg_R5_C5_dqdPE2,minv_block_reg_R6_C5_dqdPE2,minv_block_reg_R7_C5_dqdPE2,
      minv_block_reg_R1_C6_dqdPE2,minv_block_reg_R2_C6_dqdPE2,minv_block_reg_R3_C6_dqdPE2,minv_block_reg_R4_C6_dqdPE2,minv_block_reg_R5_C6_dqdPE2,minv_block_reg_R6_C6_dqdPE2,minv_block_reg_R7_C6_dqdPE2,
      minv_block_reg_R1_C7_dqdPE2,minv_block_reg_R2_C7_dqdPE2,minv_block_reg_R3_C7_dqdPE2,minv_block_reg_R4_C7_dqdPE2,minv_block_reg_R5_C7_dqdPE2,minv_block_reg_R6_C7_dqdPE2,minv_block_reg_R7_C7_dqdPE2;
   reg signed[(WIDTH-1):0]
      dtau_vec_reg_R1_dqdPE2,dtau_vec_reg_R2_dqdPE2,dtau_vec_reg_R3_dqdPE2,dtau_vec_reg_R4_dqdPE2,dtau_vec_reg_R5_dqdPE2,dtau_vec_reg_R6_dqdPE2,dtau_vec_reg_R7_dqdPE2;
   // dqdPE3
   reg signed[(WIDTH-1):0]
      minv_block_reg_R1_C1_dqdPE3,minv_block_reg_R2_C1_dqdPE3,minv_block_reg_R3_C1_dqdPE3,minv_block_reg_R4_C1_dqdPE3,minv_block_reg_R5_C1_dqdPE3,minv_block_reg_R6_C1_dqdPE3,minv_block_reg_R7_C1_dqdPE3,
      minv_block_reg_R1_C2_dqdPE3,minv_block_reg_R2_C2_dqdPE3,minv_block_reg_R3_C2_dqdPE3,minv_block_reg_R4_C2_dqdPE3,minv_block_reg_R5_C2_dqdPE3,minv_block_reg_R6_C2_dqdPE3,minv_block_reg_R7_C2_dqdPE3,
      minv_block_reg_R1_C3_dqdPE3,minv_block_reg_R2_C3_dqdPE3,minv_block_reg_R3_C3_dqdPE3,minv_block_reg_R4_C3_dqdPE3,minv_block_reg_R5_C3_dqdPE3,minv_block_reg_R6_C3_dqdPE3,minv_block_reg_R7_C3_dqdPE3,
      minv_block_reg_R1_C4_dqdPE3,minv_block_reg_R2_C4_dqdPE3,minv_block_reg_R3_C4_dqdPE3,minv_block_reg_R4_C4_dqdPE3,minv_block_reg_R5_C4_dqdPE3,minv_block_reg_R6_C4_dqdPE3,minv_block_reg_R7_C4_dqdPE3,
      minv_block_reg_R1_C5_dqdPE3,minv_block_reg_R2_C5_dqdPE3,minv_block_reg_R3_C5_dqdPE3,minv_block_reg_R4_C5_dqdPE3,minv_block_reg_R5_C5_dqdPE3,minv_block_reg_R6_C5_dqdPE3,minv_block_reg_R7_C5_dqdPE3,
      minv_block_reg_R1_C6_dqdPE3,minv_block_reg_R2_C6_dqdPE3,minv_block_reg_R3_C6_dqdPE3,minv_block_reg_R4_C6_dqdPE3,minv_block_reg_R5_C6_dqdPE3,minv_block_reg_R6_C6_dqdPE3,minv_block_reg_R7_C6_dqdPE3,
      minv_block_reg_R1_C7_dqdPE3,minv_block_reg_R2_C7_dqdPE3,minv_block_reg_R3_C7_dqdPE3,minv_block_reg_R4_C7_dqdPE3,minv_block_reg_R5_C7_dqdPE3,minv_block_reg_R6_C7_dqdPE3,minv_block_reg_R7_C7_dqdPE3;
   reg signed[(WIDTH-1):0]
      dtau_vec_reg_R1_dqdPE3,dtau_vec_reg_R2_dqdPE3,dtau_vec_reg_R3_dqdPE3,dtau_vec_reg_R4_dqdPE3,dtau_vec_reg_R5_dqdPE3,dtau_vec_reg_R6_dqdPE3,dtau_vec_reg_R7_dqdPE3;
   // dqdPE4
   reg signed[(WIDTH-1):0]
      minv_block_reg_R1_C1_dqdPE4,minv_block_reg_R2_C1_dqdPE4,minv_block_reg_R3_C1_dqdPE4,minv_block_reg_R4_C1_dqdPE4,minv_block_reg_R5_C1_dqdPE4,minv_block_reg_R6_C1_dqdPE4,minv_block_reg_R7_C1_dqdPE4,
      minv_block_reg_R1_C2_dqdPE4,minv_block_reg_R2_C2_dqdPE4,minv_block_reg_R3_C2_dqdPE4,minv_block_reg_R4_C2_dqdPE4,minv_block_reg_R5_C2_dqdPE4,minv_block_reg_R6_C2_dqdPE4,minv_block_reg_R7_C2_dqdPE4,
      minv_block_reg_R1_C3_dqdPE4,minv_block_reg_R2_C3_dqdPE4,minv_block_reg_R3_C3_dqdPE4,minv_block_reg_R4_C3_dqdPE4,minv_block_reg_R5_C3_dqdPE4,minv_block_reg_R6_C3_dqdPE4,minv_block_reg_R7_C3_dqdPE4,
      minv_block_reg_R1_C4_dqdPE4,minv_block_reg_R2_C4_dqdPE4,minv_block_reg_R3_C4_dqdPE4,minv_block_reg_R4_C4_dqdPE4,minv_block_reg_R5_C4_dqdPE4,minv_block_reg_R6_C4_dqdPE4,minv_block_reg_R7_C4_dqdPE4,
      minv_block_reg_R1_C5_dqdPE4,minv_block_reg_R2_C5_dqdPE4,minv_block_reg_R3_C5_dqdPE4,minv_block_reg_R4_C5_dqdPE4,minv_block_reg_R5_C5_dqdPE4,minv_block_reg_R6_C5_dqdPE4,minv_block_reg_R7_C5_dqdPE4,
      minv_block_reg_R1_C6_dqdPE4,minv_block_reg_R2_C6_dqdPE4,minv_block_reg_R3_C6_dqdPE4,minv_block_reg_R4_C6_dqdPE4,minv_block_reg_R5_C6_dqdPE4,minv_block_reg_R6_C6_dqdPE4,minv_block_reg_R7_C6_dqdPE4,
      minv_block_reg_R1_C7_dqdPE4,minv_block_reg_R2_C7_dqdPE4,minv_block_reg_R3_C7_dqdPE4,minv_block_reg_R4_C7_dqdPE4,minv_block_reg_R5_C7_dqdPE4,minv_block_reg_R6_C7_dqdPE4,minv_block_reg_R7_C7_dqdPE4;
   reg signed[(WIDTH-1):0]
      dtau_vec_reg_R1_dqdPE4,dtau_vec_reg_R2_dqdPE4,dtau_vec_reg_R3_dqdPE4,dtau_vec_reg_R4_dqdPE4,dtau_vec_reg_R5_dqdPE4,dtau_vec_reg_R6_dqdPE4,dtau_vec_reg_R7_dqdPE4;
   // dqdPE5
   reg signed[(WIDTH-1):0]
      minv_block_reg_R1_C1_dqdPE5,minv_block_reg_R2_C1_dqdPE5,minv_block_reg_R3_C1_dqdPE5,minv_block_reg_R4_C1_dqdPE5,minv_block_reg_R5_C1_dqdPE5,minv_block_reg_R6_C1_dqdPE5,minv_block_reg_R7_C1_dqdPE5,
      minv_block_reg_R1_C2_dqdPE5,minv_block_reg_R2_C2_dqdPE5,minv_block_reg_R3_C2_dqdPE5,minv_block_reg_R4_C2_dqdPE5,minv_block_reg_R5_C2_dqdPE5,minv_block_reg_R6_C2_dqdPE5,minv_block_reg_R7_C2_dqdPE5,
      minv_block_reg_R1_C3_dqdPE5,minv_block_reg_R2_C3_dqdPE5,minv_block_reg_R3_C3_dqdPE5,minv_block_reg_R4_C3_dqdPE5,minv_block_reg_R5_C3_dqdPE5,minv_block_reg_R6_C3_dqdPE5,minv_block_reg_R7_C3_dqdPE5,
      minv_block_reg_R1_C4_dqdPE5,minv_block_reg_R2_C4_dqdPE5,minv_block_reg_R3_C4_dqdPE5,minv_block_reg_R4_C4_dqdPE5,minv_block_reg_R5_C4_dqdPE5,minv_block_reg_R6_C4_dqdPE5,minv_block_reg_R7_C4_dqdPE5,
      minv_block_reg_R1_C5_dqdPE5,minv_block_reg_R2_C5_dqdPE5,minv_block_reg_R3_C5_dqdPE5,minv_block_reg_R4_C5_dqdPE5,minv_block_reg_R5_C5_dqdPE5,minv_block_reg_R6_C5_dqdPE5,minv_block_reg_R7_C5_dqdPE5,
      minv_block_reg_R1_C6_dqdPE5,minv_block_reg_R2_C6_dqdPE5,minv_block_reg_R3_C6_dqdPE5,minv_block_reg_R4_C6_dqdPE5,minv_block_reg_R5_C6_dqdPE5,minv_block_reg_R6_C6_dqdPE5,minv_block_reg_R7_C6_dqdPE5,
      minv_block_reg_R1_C7_dqdPE5,minv_block_reg_R2_C7_dqdPE5,minv_block_reg_R3_C7_dqdPE5,minv_block_reg_R4_C7_dqdPE5,minv_block_reg_R5_C7_dqdPE5,minv_block_reg_R6_C7_dqdPE5,minv_block_reg_R7_C7_dqdPE5;
   reg signed[(WIDTH-1):0]
      dtau_vec_reg_R1_dqdPE5,dtau_vec_reg_R2_dqdPE5,dtau_vec_reg_R3_dqdPE5,dtau_vec_reg_R4_dqdPE5,dtau_vec_reg_R5_dqdPE5,dtau_vec_reg_R6_dqdPE5,dtau_vec_reg_R7_dqdPE5;
   // dqdPE6
   reg signed[(WIDTH-1):0]
      minv_block_reg_R1_C1_dqdPE6,minv_block_reg_R2_C1_dqdPE6,minv_block_reg_R3_C1_dqdPE6,minv_block_reg_R4_C1_dqdPE6,minv_block_reg_R5_C1_dqdPE6,minv_block_reg_R6_C1_dqdPE6,minv_block_reg_R7_C1_dqdPE6,
      minv_block_reg_R1_C2_dqdPE6,minv_block_reg_R2_C2_dqdPE6,minv_block_reg_R3_C2_dqdPE6,minv_block_reg_R4_C2_dqdPE6,minv_block_reg_R5_C2_dqdPE6,minv_block_reg_R6_C2_dqdPE6,minv_block_reg_R7_C2_dqdPE6,
      minv_block_reg_R1_C3_dqdPE6,minv_block_reg_R2_C3_dqdPE6,minv_block_reg_R3_C3_dqdPE6,minv_block_reg_R4_C3_dqdPE6,minv_block_reg_R5_C3_dqdPE6,minv_block_reg_R6_C3_dqdPE6,minv_block_reg_R7_C3_dqdPE6,
      minv_block_reg_R1_C4_dqdPE6,minv_block_reg_R2_C4_dqdPE6,minv_block_reg_R3_C4_dqdPE6,minv_block_reg_R4_C4_dqdPE6,minv_block_reg_R5_C4_dqdPE6,minv_block_reg_R6_C4_dqdPE6,minv_block_reg_R7_C4_dqdPE6,
      minv_block_reg_R1_C5_dqdPE6,minv_block_reg_R2_C5_dqdPE6,minv_block_reg_R3_C5_dqdPE6,minv_block_reg_R4_C5_dqdPE6,minv_block_reg_R5_C5_dqdPE6,minv_block_reg_R6_C5_dqdPE6,minv_block_reg_R7_C5_dqdPE6,
      minv_block_reg_R1_C6_dqdPE6,minv_block_reg_R2_C6_dqdPE6,minv_block_reg_R3_C6_dqdPE6,minv_block_reg_R4_C6_dqdPE6,minv_block_reg_R5_C6_dqdPE6,minv_block_reg_R6_C6_dqdPE6,minv_block_reg_R7_C6_dqdPE6,
      minv_block_reg_R1_C7_dqdPE6,minv_block_reg_R2_C7_dqdPE6,minv_block_reg_R3_C7_dqdPE6,minv_block_reg_R4_C7_dqdPE6,minv_block_reg_R5_C7_dqdPE6,minv_block_reg_R6_C7_dqdPE6,minv_block_reg_R7_C7_dqdPE6;
   reg signed[(WIDTH-1):0]
      dtau_vec_reg_R1_dqdPE6,dtau_vec_reg_R2_dqdPE6,dtau_vec_reg_R3_dqdPE6,dtau_vec_reg_R4_dqdPE6,dtau_vec_reg_R5_dqdPE6,dtau_vec_reg_R6_dqdPE6,dtau_vec_reg_R7_dqdPE6;
   // dqdPE7
   reg signed[(WIDTH-1):0]
      minv_block_reg_R1_C1_dqdPE7,minv_block_reg_R2_C1_dqdPE7,minv_block_reg_R3_C1_dqdPE7,minv_block_reg_R4_C1_dqdPE7,minv_block_reg_R5_C1_dqdPE7,minv_block_reg_R6_C1_dqdPE7,minv_block_reg_R7_C1_dqdPE7,
      minv_block_reg_R1_C2_dqdPE7,minv_block_reg_R2_C2_dqdPE7,minv_block_reg_R3_C2_dqdPE7,minv_block_reg_R4_C2_dqdPE7,minv_block_reg_R5_C2_dqdPE7,minv_block_reg_R6_C2_dqdPE7,minv_block_reg_R7_C2_dqdPE7,
      minv_block_reg_R1_C3_dqdPE7,minv_block_reg_R2_C3_dqdPE7,minv_block_reg_R3_C3_dqdPE7,minv_block_reg_R4_C3_dqdPE7,minv_block_reg_R5_C3_dqdPE7,minv_block_reg_R6_C3_dqdPE7,minv_block_reg_R7_C3_dqdPE7,
      minv_block_reg_R1_C4_dqdPE7,minv_block_reg_R2_C4_dqdPE7,minv_block_reg_R3_C4_dqdPE7,minv_block_reg_R4_C4_dqdPE7,minv_block_reg_R5_C4_dqdPE7,minv_block_reg_R6_C4_dqdPE7,minv_block_reg_R7_C4_dqdPE7,
      minv_block_reg_R1_C5_dqdPE7,minv_block_reg_R2_C5_dqdPE7,minv_block_reg_R3_C5_dqdPE7,minv_block_reg_R4_C5_dqdPE7,minv_block_reg_R5_C5_dqdPE7,minv_block_reg_R6_C5_dqdPE7,minv_block_reg_R7_C5_dqdPE7,
      minv_block_reg_R1_C6_dqdPE7,minv_block_reg_R2_C6_dqdPE7,minv_block_reg_R3_C6_dqdPE7,minv_block_reg_R4_C6_dqdPE7,minv_block_reg_R5_C6_dqdPE7,minv_block_reg_R6_C6_dqdPE7,minv_block_reg_R7_C6_dqdPE7,
      minv_block_reg_R1_C7_dqdPE7,minv_block_reg_R2_C7_dqdPE7,minv_block_reg_R3_C7_dqdPE7,minv_block_reg_R4_C7_dqdPE7,minv_block_reg_R5_C7_dqdPE7,minv_block_reg_R6_C7_dqdPE7,minv_block_reg_R7_C7_dqdPE7;
   reg signed[(WIDTH-1):0]
      dtau_vec_reg_R1_dqdPE7,dtau_vec_reg_R2_dqdPE7,dtau_vec_reg_R3_dqdPE7,dtau_vec_reg_R4_dqdPE7,dtau_vec_reg_R5_dqdPE7,dtau_vec_reg_R6_dqdPE7,dtau_vec_reg_R7_dqdPE7;
   //---------------------------------------------------------------------------
   // next
   wire get_data_next;
   wire get_data_minv_next;
   wire output_ready_next;
   wire output_ready_minv_next;
   wire minv_bool_next;
   wire [2:0]
      state_next;
   wire [2:0]
      state_minv_next;
   //---------------------------------------------------------------------------
   // rnea external inputs
   //---------------------------------------------------------------------------
   // rnea
   wire [3:0]
      link_next_rnea;
   wire signed[(WIDTH-1):0]
      sinq_val_next_rnea,cosq_val_next_rnea,
      f_upd_curr_vec_next_AX_rnea,f_upd_curr_vec_next_AY_rnea,f_upd_curr_vec_next_AZ_rnea,f_upd_curr_vec_next_LX_rnea,f_upd_curr_vec_next_LY_rnea,f_upd_curr_vec_next_LZ_rnea,
      f_prev_vec_next_AX_rnea,f_prev_vec_next_AY_rnea,f_prev_vec_next_AZ_rnea,f_prev_vec_next_LX_rnea,f_prev_vec_next_LY_rnea,f_prev_vec_next_LZ_rnea;
   //---------------------------------------------------------------------------
   // dq external inputs
   //---------------------------------------------------------------------------
   // dqPE1
   wire [3:0]
      link_next_dqPE1;
   wire [3:0]
      derv_next_dqPE1;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE1,cosq_val_next_dqPE1,
      f_upd_curr_vec_next_AX_dqPE1,f_upd_curr_vec_next_AY_dqPE1,f_upd_curr_vec_next_AZ_dqPE1,f_upd_curr_vec_next_LX_dqPE1,f_upd_curr_vec_next_LY_dqPE1,f_upd_curr_vec_next_LZ_dqPE1,
      dfdq_prev_vec_next_AX_dqPE1,dfdq_prev_vec_next_AY_dqPE1,dfdq_prev_vec_next_AZ_dqPE1,dfdq_prev_vec_next_LX_dqPE1,dfdq_prev_vec_next_LY_dqPE1,dfdq_prev_vec_next_LZ_dqPE1,
      dfdq_upd_curr_vec_next_AX_dqPE1,dfdq_upd_curr_vec_next_AY_dqPE1,dfdq_upd_curr_vec_next_AZ_dqPE1,dfdq_upd_curr_vec_next_LX_dqPE1,dfdq_upd_curr_vec_next_LY_dqPE1,dfdq_upd_curr_vec_next_LZ_dqPE1;
   // dqPE2
   wire [3:0]
      link_next_dqPE2;
   wire [3:0]
      derv_next_dqPE2;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE2,cosq_val_next_dqPE2,
      f_upd_curr_vec_next_AX_dqPE2,f_upd_curr_vec_next_AY_dqPE2,f_upd_curr_vec_next_AZ_dqPE2,f_upd_curr_vec_next_LX_dqPE2,f_upd_curr_vec_next_LY_dqPE2,f_upd_curr_vec_next_LZ_dqPE2,
      dfdq_prev_vec_next_AX_dqPE2,dfdq_prev_vec_next_AY_dqPE2,dfdq_prev_vec_next_AZ_dqPE2,dfdq_prev_vec_next_LX_dqPE2,dfdq_prev_vec_next_LY_dqPE2,dfdq_prev_vec_next_LZ_dqPE2,
      dfdq_upd_curr_vec_next_AX_dqPE2,dfdq_upd_curr_vec_next_AY_dqPE2,dfdq_upd_curr_vec_next_AZ_dqPE2,dfdq_upd_curr_vec_next_LX_dqPE2,dfdq_upd_curr_vec_next_LY_dqPE2,dfdq_upd_curr_vec_next_LZ_dqPE2;
   // dqPE3
   wire [3:0]
      link_next_dqPE3;
   wire [3:0]
      derv_next_dqPE3;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE3,cosq_val_next_dqPE3,
      f_upd_curr_vec_next_AX_dqPE3,f_upd_curr_vec_next_AY_dqPE3,f_upd_curr_vec_next_AZ_dqPE3,f_upd_curr_vec_next_LX_dqPE3,f_upd_curr_vec_next_LY_dqPE3,f_upd_curr_vec_next_LZ_dqPE3,
      dfdq_prev_vec_next_AX_dqPE3,dfdq_prev_vec_next_AY_dqPE3,dfdq_prev_vec_next_AZ_dqPE3,dfdq_prev_vec_next_LX_dqPE3,dfdq_prev_vec_next_LY_dqPE3,dfdq_prev_vec_next_LZ_dqPE3,
      dfdq_upd_curr_vec_next_AX_dqPE3,dfdq_upd_curr_vec_next_AY_dqPE3,dfdq_upd_curr_vec_next_AZ_dqPE3,dfdq_upd_curr_vec_next_LX_dqPE3,dfdq_upd_curr_vec_next_LY_dqPE3,dfdq_upd_curr_vec_next_LZ_dqPE3;
   // dqPE4
   wire [3:0]
      link_next_dqPE4;
   wire [3:0]
      derv_next_dqPE4;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE4,cosq_val_next_dqPE4,
      f_upd_curr_vec_next_AX_dqPE4,f_upd_curr_vec_next_AY_dqPE4,f_upd_curr_vec_next_AZ_dqPE4,f_upd_curr_vec_next_LX_dqPE4,f_upd_curr_vec_next_LY_dqPE4,f_upd_curr_vec_next_LZ_dqPE4,
      dfdq_prev_vec_next_AX_dqPE4,dfdq_prev_vec_next_AY_dqPE4,dfdq_prev_vec_next_AZ_dqPE4,dfdq_prev_vec_next_LX_dqPE4,dfdq_prev_vec_next_LY_dqPE4,dfdq_prev_vec_next_LZ_dqPE4,
      dfdq_upd_curr_vec_next_AX_dqPE4,dfdq_upd_curr_vec_next_AY_dqPE4,dfdq_upd_curr_vec_next_AZ_dqPE4,dfdq_upd_curr_vec_next_LX_dqPE4,dfdq_upd_curr_vec_next_LY_dqPE4,dfdq_upd_curr_vec_next_LZ_dqPE4;
   // dqPE5
   wire [3:0]
      link_next_dqPE5;
   wire [3:0]
      derv_next_dqPE5;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE5,cosq_val_next_dqPE5,
      f_upd_curr_vec_next_AX_dqPE5,f_upd_curr_vec_next_AY_dqPE5,f_upd_curr_vec_next_AZ_dqPE5,f_upd_curr_vec_next_LX_dqPE5,f_upd_curr_vec_next_LY_dqPE5,f_upd_curr_vec_next_LZ_dqPE5,
      dfdq_prev_vec_next_AX_dqPE5,dfdq_prev_vec_next_AY_dqPE5,dfdq_prev_vec_next_AZ_dqPE5,dfdq_prev_vec_next_LX_dqPE5,dfdq_prev_vec_next_LY_dqPE5,dfdq_prev_vec_next_LZ_dqPE5,
      dfdq_upd_curr_vec_next_AX_dqPE5,dfdq_upd_curr_vec_next_AY_dqPE5,dfdq_upd_curr_vec_next_AZ_dqPE5,dfdq_upd_curr_vec_next_LX_dqPE5,dfdq_upd_curr_vec_next_LY_dqPE5,dfdq_upd_curr_vec_next_LZ_dqPE5;
   // dqPE6
   wire [3:0]
      link_next_dqPE6;
   wire [3:0]
      derv_next_dqPE6;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE6,cosq_val_next_dqPE6,
      f_upd_curr_vec_next_AX_dqPE6,f_upd_curr_vec_next_AY_dqPE6,f_upd_curr_vec_next_AZ_dqPE6,f_upd_curr_vec_next_LX_dqPE6,f_upd_curr_vec_next_LY_dqPE6,f_upd_curr_vec_next_LZ_dqPE6,
      dfdq_prev_vec_next_AX_dqPE6,dfdq_prev_vec_next_AY_dqPE6,dfdq_prev_vec_next_AZ_dqPE6,dfdq_prev_vec_next_LX_dqPE6,dfdq_prev_vec_next_LY_dqPE6,dfdq_prev_vec_next_LZ_dqPE6,
      dfdq_upd_curr_vec_next_AX_dqPE6,dfdq_upd_curr_vec_next_AY_dqPE6,dfdq_upd_curr_vec_next_AZ_dqPE6,dfdq_upd_curr_vec_next_LX_dqPE6,dfdq_upd_curr_vec_next_LY_dqPE6,dfdq_upd_curr_vec_next_LZ_dqPE6;
   // dqPE7
   wire [3:0]
      link_next_dqPE7;
   wire [3:0]
      derv_next_dqPE7;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqPE7,cosq_val_next_dqPE7,
      f_upd_curr_vec_next_AX_dqPE7,f_upd_curr_vec_next_AY_dqPE7,f_upd_curr_vec_next_AZ_dqPE7,f_upd_curr_vec_next_LX_dqPE7,f_upd_curr_vec_next_LY_dqPE7,f_upd_curr_vec_next_LZ_dqPE7,
      dfdq_prev_vec_next_AX_dqPE7,dfdq_prev_vec_next_AY_dqPE7,dfdq_prev_vec_next_AZ_dqPE7,dfdq_prev_vec_next_LX_dqPE7,dfdq_prev_vec_next_LY_dqPE7,dfdq_prev_vec_next_LZ_dqPE7,
      dfdq_upd_curr_vec_next_AX_dqPE7,dfdq_upd_curr_vec_next_AY_dqPE7,dfdq_upd_curr_vec_next_AZ_dqPE7,dfdq_upd_curr_vec_next_LX_dqPE7,dfdq_upd_curr_vec_next_LY_dqPE7,dfdq_upd_curr_vec_next_LZ_dqPE7;
   //---------------------------------------------------------------------------
   // dqd external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   wire [3:0]
      link_next_dqdPE1;
   wire [3:0]
      derv_next_dqdPE1;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE1,cosq_val_next_dqdPE1,
      dfdqd_prev_vec_next_AX_dqdPE1,dfdqd_prev_vec_next_AY_dqdPE1,dfdqd_prev_vec_next_AZ_dqdPE1,dfdqd_prev_vec_next_LX_dqdPE1,dfdqd_prev_vec_next_LY_dqdPE1,dfdqd_prev_vec_next_LZ_dqdPE1,
      dfdqd_upd_curr_vec_next_AX_dqdPE1,dfdqd_upd_curr_vec_next_AY_dqdPE1,dfdqd_upd_curr_vec_next_AZ_dqdPE1,dfdqd_upd_curr_vec_next_LX_dqdPE1,dfdqd_upd_curr_vec_next_LY_dqdPE1,dfdqd_upd_curr_vec_next_LZ_dqdPE1;
   // dqdPE2
   wire [3:0]
      link_next_dqdPE2;
   wire [3:0]
      derv_next_dqdPE2;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE2,cosq_val_next_dqdPE2,
      dfdqd_prev_vec_next_AX_dqdPE2,dfdqd_prev_vec_next_AY_dqdPE2,dfdqd_prev_vec_next_AZ_dqdPE2,dfdqd_prev_vec_next_LX_dqdPE2,dfdqd_prev_vec_next_LY_dqdPE2,dfdqd_prev_vec_next_LZ_dqdPE2,
      dfdqd_upd_curr_vec_next_AX_dqdPE2,dfdqd_upd_curr_vec_next_AY_dqdPE2,dfdqd_upd_curr_vec_next_AZ_dqdPE2,dfdqd_upd_curr_vec_next_LX_dqdPE2,dfdqd_upd_curr_vec_next_LY_dqdPE2,dfdqd_upd_curr_vec_next_LZ_dqdPE2;
   // dqdPE3
   wire [3:0]
      link_next_dqdPE3;
   wire [3:0]
      derv_next_dqdPE3;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE3,cosq_val_next_dqdPE3,
      dfdqd_prev_vec_next_AX_dqdPE3,dfdqd_prev_vec_next_AY_dqdPE3,dfdqd_prev_vec_next_AZ_dqdPE3,dfdqd_prev_vec_next_LX_dqdPE3,dfdqd_prev_vec_next_LY_dqdPE3,dfdqd_prev_vec_next_LZ_dqdPE3,
      dfdqd_upd_curr_vec_next_AX_dqdPE3,dfdqd_upd_curr_vec_next_AY_dqdPE3,dfdqd_upd_curr_vec_next_AZ_dqdPE3,dfdqd_upd_curr_vec_next_LX_dqdPE3,dfdqd_upd_curr_vec_next_LY_dqdPE3,dfdqd_upd_curr_vec_next_LZ_dqdPE3;
   // dqdPE4
   wire [3:0]
      link_next_dqdPE4;
   wire [3:0]
      derv_next_dqdPE4;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE4,cosq_val_next_dqdPE4,
      dfdqd_prev_vec_next_AX_dqdPE4,dfdqd_prev_vec_next_AY_dqdPE4,dfdqd_prev_vec_next_AZ_dqdPE4,dfdqd_prev_vec_next_LX_dqdPE4,dfdqd_prev_vec_next_LY_dqdPE4,dfdqd_prev_vec_next_LZ_dqdPE4,
      dfdqd_upd_curr_vec_next_AX_dqdPE4,dfdqd_upd_curr_vec_next_AY_dqdPE4,dfdqd_upd_curr_vec_next_AZ_dqdPE4,dfdqd_upd_curr_vec_next_LX_dqdPE4,dfdqd_upd_curr_vec_next_LY_dqdPE4,dfdqd_upd_curr_vec_next_LZ_dqdPE4;
   // dqdPE5
   wire [3:0]
      link_next_dqdPE5;
   wire [3:0]
      derv_next_dqdPE5;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE5,cosq_val_next_dqdPE5,
      dfdqd_prev_vec_next_AX_dqdPE5,dfdqd_prev_vec_next_AY_dqdPE5,dfdqd_prev_vec_next_AZ_dqdPE5,dfdqd_prev_vec_next_LX_dqdPE5,dfdqd_prev_vec_next_LY_dqdPE5,dfdqd_prev_vec_next_LZ_dqdPE5,
      dfdqd_upd_curr_vec_next_AX_dqdPE5,dfdqd_upd_curr_vec_next_AY_dqdPE5,dfdqd_upd_curr_vec_next_AZ_dqdPE5,dfdqd_upd_curr_vec_next_LX_dqdPE5,dfdqd_upd_curr_vec_next_LY_dqdPE5,dfdqd_upd_curr_vec_next_LZ_dqdPE5;
   // dqdPE6
   wire [3:0]
      link_next_dqdPE6;
   wire [3:0]
      derv_next_dqdPE6;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE6,cosq_val_next_dqdPE6,
      dfdqd_prev_vec_next_AX_dqdPE6,dfdqd_prev_vec_next_AY_dqdPE6,dfdqd_prev_vec_next_AZ_dqdPE6,dfdqd_prev_vec_next_LX_dqdPE6,dfdqd_prev_vec_next_LY_dqdPE6,dfdqd_prev_vec_next_LZ_dqdPE6,
      dfdqd_upd_curr_vec_next_AX_dqdPE6,dfdqd_upd_curr_vec_next_AY_dqdPE6,dfdqd_upd_curr_vec_next_AZ_dqdPE6,dfdqd_upd_curr_vec_next_LX_dqdPE6,dfdqd_upd_curr_vec_next_LY_dqdPE6,dfdqd_upd_curr_vec_next_LZ_dqdPE6;
   // dqdPE7
   wire [3:0]
      link_next_dqdPE7;
   wire [3:0]
      derv_next_dqdPE7;
   wire signed[(WIDTH-1):0]
      sinq_val_next_dqdPE7,cosq_val_next_dqdPE7,
      dfdqd_prev_vec_next_AX_dqdPE7,dfdqd_prev_vec_next_AY_dqdPE7,dfdqd_prev_vec_next_AZ_dqdPE7,dfdqd_prev_vec_next_LX_dqdPE7,dfdqd_prev_vec_next_LY_dqdPE7,dfdqd_prev_vec_next_LZ_dqdPE7,
      dfdqd_upd_curr_vec_next_AX_dqdPE7,dfdqd_upd_curr_vec_next_AY_dqdPE7,dfdqd_upd_curr_vec_next_AZ_dqdPE7,dfdqd_upd_curr_vec_next_LX_dqdPE7,dfdqd_upd_curr_vec_next_LY_dqdPE7,dfdqd_upd_curr_vec_next_LZ_dqdPE7;
   //---------------------------------------------------------------------------
   // minv external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   wire signed[(WIDTH-1):0]
      minv_block_next_R1_C1_dqdPE1,minv_block_next_R2_C1_dqdPE1,minv_block_next_R3_C1_dqdPE1,minv_block_next_R4_C1_dqdPE1,minv_block_next_R5_C1_dqdPE1,minv_block_next_R6_C1_dqdPE1,minv_block_next_R7_C1_dqdPE1,
      minv_block_next_R1_C2_dqdPE1,minv_block_next_R2_C2_dqdPE1,minv_block_next_R3_C2_dqdPE1,minv_block_next_R4_C2_dqdPE1,minv_block_next_R5_C2_dqdPE1,minv_block_next_R6_C2_dqdPE1,minv_block_next_R7_C2_dqdPE1,
      minv_block_next_R1_C3_dqdPE1,minv_block_next_R2_C3_dqdPE1,minv_block_next_R3_C3_dqdPE1,minv_block_next_R4_C3_dqdPE1,minv_block_next_R5_C3_dqdPE1,minv_block_next_R6_C3_dqdPE1,minv_block_next_R7_C3_dqdPE1,
      minv_block_next_R1_C4_dqdPE1,minv_block_next_R2_C4_dqdPE1,minv_block_next_R3_C4_dqdPE1,minv_block_next_R4_C4_dqdPE1,minv_block_next_R5_C4_dqdPE1,minv_block_next_R6_C4_dqdPE1,minv_block_next_R7_C4_dqdPE1,
      minv_block_next_R1_C5_dqdPE1,minv_block_next_R2_C5_dqdPE1,minv_block_next_R3_C5_dqdPE1,minv_block_next_R4_C5_dqdPE1,minv_block_next_R5_C5_dqdPE1,minv_block_next_R6_C5_dqdPE1,minv_block_next_R7_C5_dqdPE1,
      minv_block_next_R1_C6_dqdPE1,minv_block_next_R2_C6_dqdPE1,minv_block_next_R3_C6_dqdPE1,minv_block_next_R4_C6_dqdPE1,minv_block_next_R5_C6_dqdPE1,minv_block_next_R6_C6_dqdPE1,minv_block_next_R7_C6_dqdPE1,
      minv_block_next_R1_C7_dqdPE1,minv_block_next_R2_C7_dqdPE1,minv_block_next_R3_C7_dqdPE1,minv_block_next_R4_C7_dqdPE1,minv_block_next_R5_C7_dqdPE1,minv_block_next_R6_C7_dqdPE1,minv_block_next_R7_C7_dqdPE1;
   wire signed[(WIDTH-1):0]
      dtau_vec_next_R1_dqdPE1,dtau_vec_next_R2_dqdPE1,dtau_vec_next_R3_dqdPE1,dtau_vec_next_R4_dqdPE1,dtau_vec_next_R5_dqdPE1,dtau_vec_next_R6_dqdPE1,dtau_vec_next_R7_dqdPE1;
   // dqdPE2
   wire signed[(WIDTH-1):0]
      minv_block_next_R1_C1_dqdPE2,minv_block_next_R2_C1_dqdPE2,minv_block_next_R3_C1_dqdPE2,minv_block_next_R4_C1_dqdPE2,minv_block_next_R5_C1_dqdPE2,minv_block_next_R6_C1_dqdPE2,minv_block_next_R7_C1_dqdPE2,
      minv_block_next_R1_C2_dqdPE2,minv_block_next_R2_C2_dqdPE2,minv_block_next_R3_C2_dqdPE2,minv_block_next_R4_C2_dqdPE2,minv_block_next_R5_C2_dqdPE2,minv_block_next_R6_C2_dqdPE2,minv_block_next_R7_C2_dqdPE2,
      minv_block_next_R1_C3_dqdPE2,minv_block_next_R2_C3_dqdPE2,minv_block_next_R3_C3_dqdPE2,minv_block_next_R4_C3_dqdPE2,minv_block_next_R5_C3_dqdPE2,minv_block_next_R6_C3_dqdPE2,minv_block_next_R7_C3_dqdPE2,
      minv_block_next_R1_C4_dqdPE2,minv_block_next_R2_C4_dqdPE2,minv_block_next_R3_C4_dqdPE2,minv_block_next_R4_C4_dqdPE2,minv_block_next_R5_C4_dqdPE2,minv_block_next_R6_C4_dqdPE2,minv_block_next_R7_C4_dqdPE2,
      minv_block_next_R1_C5_dqdPE2,minv_block_next_R2_C5_dqdPE2,minv_block_next_R3_C5_dqdPE2,minv_block_next_R4_C5_dqdPE2,minv_block_next_R5_C5_dqdPE2,minv_block_next_R6_C5_dqdPE2,minv_block_next_R7_C5_dqdPE2,
      minv_block_next_R1_C6_dqdPE2,minv_block_next_R2_C6_dqdPE2,minv_block_next_R3_C6_dqdPE2,minv_block_next_R4_C6_dqdPE2,minv_block_next_R5_C6_dqdPE2,minv_block_next_R6_C6_dqdPE2,minv_block_next_R7_C6_dqdPE2,
      minv_block_next_R1_C7_dqdPE2,minv_block_next_R2_C7_dqdPE2,minv_block_next_R3_C7_dqdPE2,minv_block_next_R4_C7_dqdPE2,minv_block_next_R5_C7_dqdPE2,minv_block_next_R6_C7_dqdPE2,minv_block_next_R7_C7_dqdPE2;
   wire signed[(WIDTH-1):0]
      dtau_vec_next_R1_dqdPE2,dtau_vec_next_R2_dqdPE2,dtau_vec_next_R3_dqdPE2,dtau_vec_next_R4_dqdPE2,dtau_vec_next_R5_dqdPE2,dtau_vec_next_R6_dqdPE2,dtau_vec_next_R7_dqdPE2;
   // dqdPE3
   wire signed[(WIDTH-1):0]
      minv_block_next_R1_C1_dqdPE3,minv_block_next_R2_C1_dqdPE3,minv_block_next_R3_C1_dqdPE3,minv_block_next_R4_C1_dqdPE3,minv_block_next_R5_C1_dqdPE3,minv_block_next_R6_C1_dqdPE3,minv_block_next_R7_C1_dqdPE3,
      minv_block_next_R1_C2_dqdPE3,minv_block_next_R2_C2_dqdPE3,minv_block_next_R3_C2_dqdPE3,minv_block_next_R4_C2_dqdPE3,minv_block_next_R5_C2_dqdPE3,minv_block_next_R6_C2_dqdPE3,minv_block_next_R7_C2_dqdPE3,
      minv_block_next_R1_C3_dqdPE3,minv_block_next_R2_C3_dqdPE3,minv_block_next_R3_C3_dqdPE3,minv_block_next_R4_C3_dqdPE3,minv_block_next_R5_C3_dqdPE3,minv_block_next_R6_C3_dqdPE3,minv_block_next_R7_C3_dqdPE3,
      minv_block_next_R1_C4_dqdPE3,minv_block_next_R2_C4_dqdPE3,minv_block_next_R3_C4_dqdPE3,minv_block_next_R4_C4_dqdPE3,minv_block_next_R5_C4_dqdPE3,minv_block_next_R6_C4_dqdPE3,minv_block_next_R7_C4_dqdPE3,
      minv_block_next_R1_C5_dqdPE3,minv_block_next_R2_C5_dqdPE3,minv_block_next_R3_C5_dqdPE3,minv_block_next_R4_C5_dqdPE3,minv_block_next_R5_C5_dqdPE3,minv_block_next_R6_C5_dqdPE3,minv_block_next_R7_C5_dqdPE3,
      minv_block_next_R1_C6_dqdPE3,minv_block_next_R2_C6_dqdPE3,minv_block_next_R3_C6_dqdPE3,minv_block_next_R4_C6_dqdPE3,minv_block_next_R5_C6_dqdPE3,minv_block_next_R6_C6_dqdPE3,minv_block_next_R7_C6_dqdPE3,
      minv_block_next_R1_C7_dqdPE3,minv_block_next_R2_C7_dqdPE3,minv_block_next_R3_C7_dqdPE3,minv_block_next_R4_C7_dqdPE3,minv_block_next_R5_C7_dqdPE3,minv_block_next_R6_C7_dqdPE3,minv_block_next_R7_C7_dqdPE3;
   wire signed[(WIDTH-1):0]
      dtau_vec_next_R1_dqdPE3,dtau_vec_next_R2_dqdPE3,dtau_vec_next_R3_dqdPE3,dtau_vec_next_R4_dqdPE3,dtau_vec_next_R5_dqdPE3,dtau_vec_next_R6_dqdPE3,dtau_vec_next_R7_dqdPE3;
   // dqdPE4
   wire signed[(WIDTH-1):0]
      minv_block_next_R1_C1_dqdPE4,minv_block_next_R2_C1_dqdPE4,minv_block_next_R3_C1_dqdPE4,minv_block_next_R4_C1_dqdPE4,minv_block_next_R5_C1_dqdPE4,minv_block_next_R6_C1_dqdPE4,minv_block_next_R7_C1_dqdPE4,
      minv_block_next_R1_C2_dqdPE4,minv_block_next_R2_C2_dqdPE4,minv_block_next_R3_C2_dqdPE4,minv_block_next_R4_C2_dqdPE4,minv_block_next_R5_C2_dqdPE4,minv_block_next_R6_C2_dqdPE4,minv_block_next_R7_C2_dqdPE4,
      minv_block_next_R1_C3_dqdPE4,minv_block_next_R2_C3_dqdPE4,minv_block_next_R3_C3_dqdPE4,minv_block_next_R4_C3_dqdPE4,minv_block_next_R5_C3_dqdPE4,minv_block_next_R6_C3_dqdPE4,minv_block_next_R7_C3_dqdPE4,
      minv_block_next_R1_C4_dqdPE4,minv_block_next_R2_C4_dqdPE4,minv_block_next_R3_C4_dqdPE4,minv_block_next_R4_C4_dqdPE4,minv_block_next_R5_C4_dqdPE4,minv_block_next_R6_C4_dqdPE4,minv_block_next_R7_C4_dqdPE4,
      minv_block_next_R1_C5_dqdPE4,minv_block_next_R2_C5_dqdPE4,minv_block_next_R3_C5_dqdPE4,minv_block_next_R4_C5_dqdPE4,minv_block_next_R5_C5_dqdPE4,minv_block_next_R6_C5_dqdPE4,minv_block_next_R7_C5_dqdPE4,
      minv_block_next_R1_C6_dqdPE4,minv_block_next_R2_C6_dqdPE4,minv_block_next_R3_C6_dqdPE4,minv_block_next_R4_C6_dqdPE4,minv_block_next_R5_C6_dqdPE4,minv_block_next_R6_C6_dqdPE4,minv_block_next_R7_C6_dqdPE4,
      minv_block_next_R1_C7_dqdPE4,minv_block_next_R2_C7_dqdPE4,minv_block_next_R3_C7_dqdPE4,minv_block_next_R4_C7_dqdPE4,minv_block_next_R5_C7_dqdPE4,minv_block_next_R6_C7_dqdPE4,minv_block_next_R7_C7_dqdPE4;
   wire signed[(WIDTH-1):0]
      dtau_vec_next_R1_dqdPE4,dtau_vec_next_R2_dqdPE4,dtau_vec_next_R3_dqdPE4,dtau_vec_next_R4_dqdPE4,dtau_vec_next_R5_dqdPE4,dtau_vec_next_R6_dqdPE4,dtau_vec_next_R7_dqdPE4;
   // dqdPE5
   wire signed[(WIDTH-1):0]
      minv_block_next_R1_C1_dqdPE5,minv_block_next_R2_C1_dqdPE5,minv_block_next_R3_C1_dqdPE5,minv_block_next_R4_C1_dqdPE5,minv_block_next_R5_C1_dqdPE5,minv_block_next_R6_C1_dqdPE5,minv_block_next_R7_C1_dqdPE5,
      minv_block_next_R1_C2_dqdPE5,minv_block_next_R2_C2_dqdPE5,minv_block_next_R3_C2_dqdPE5,minv_block_next_R4_C2_dqdPE5,minv_block_next_R5_C2_dqdPE5,minv_block_next_R6_C2_dqdPE5,minv_block_next_R7_C2_dqdPE5,
      minv_block_next_R1_C3_dqdPE5,minv_block_next_R2_C3_dqdPE5,minv_block_next_R3_C3_dqdPE5,minv_block_next_R4_C3_dqdPE5,minv_block_next_R5_C3_dqdPE5,minv_block_next_R6_C3_dqdPE5,minv_block_next_R7_C3_dqdPE5,
      minv_block_next_R1_C4_dqdPE5,minv_block_next_R2_C4_dqdPE5,minv_block_next_R3_C4_dqdPE5,minv_block_next_R4_C4_dqdPE5,minv_block_next_R5_C4_dqdPE5,minv_block_next_R6_C4_dqdPE5,minv_block_next_R7_C4_dqdPE5,
      minv_block_next_R1_C5_dqdPE5,minv_block_next_R2_C5_dqdPE5,minv_block_next_R3_C5_dqdPE5,minv_block_next_R4_C5_dqdPE5,minv_block_next_R5_C5_dqdPE5,minv_block_next_R6_C5_dqdPE5,minv_block_next_R7_C5_dqdPE5,
      minv_block_next_R1_C6_dqdPE5,minv_block_next_R2_C6_dqdPE5,minv_block_next_R3_C6_dqdPE5,minv_block_next_R4_C6_dqdPE5,minv_block_next_R5_C6_dqdPE5,minv_block_next_R6_C6_dqdPE5,minv_block_next_R7_C6_dqdPE5,
      minv_block_next_R1_C7_dqdPE5,minv_block_next_R2_C7_dqdPE5,minv_block_next_R3_C7_dqdPE5,minv_block_next_R4_C7_dqdPE5,minv_block_next_R5_C7_dqdPE5,minv_block_next_R6_C7_dqdPE5,minv_block_next_R7_C7_dqdPE5;
   wire signed[(WIDTH-1):0]
      dtau_vec_next_R1_dqdPE5,dtau_vec_next_R2_dqdPE5,dtau_vec_next_R3_dqdPE5,dtau_vec_next_R4_dqdPE5,dtau_vec_next_R5_dqdPE5,dtau_vec_next_R6_dqdPE5,dtau_vec_next_R7_dqdPE5;
   // dqdPE6
   wire signed[(WIDTH-1):0]
      minv_block_next_R1_C1_dqdPE6,minv_block_next_R2_C1_dqdPE6,minv_block_next_R3_C1_dqdPE6,minv_block_next_R4_C1_dqdPE6,minv_block_next_R5_C1_dqdPE6,minv_block_next_R6_C1_dqdPE6,minv_block_next_R7_C1_dqdPE6,
      minv_block_next_R1_C2_dqdPE6,minv_block_next_R2_C2_dqdPE6,minv_block_next_R3_C2_dqdPE6,minv_block_next_R4_C2_dqdPE6,minv_block_next_R5_C2_dqdPE6,minv_block_next_R6_C2_dqdPE6,minv_block_next_R7_C2_dqdPE6,
      minv_block_next_R1_C3_dqdPE6,minv_block_next_R2_C3_dqdPE6,minv_block_next_R3_C3_dqdPE6,minv_block_next_R4_C3_dqdPE6,minv_block_next_R5_C3_dqdPE6,minv_block_next_R6_C3_dqdPE6,minv_block_next_R7_C3_dqdPE6,
      minv_block_next_R1_C4_dqdPE6,minv_block_next_R2_C4_dqdPE6,minv_block_next_R3_C4_dqdPE6,minv_block_next_R4_C4_dqdPE6,minv_block_next_R5_C4_dqdPE6,minv_block_next_R6_C4_dqdPE6,minv_block_next_R7_C4_dqdPE6,
      minv_block_next_R1_C5_dqdPE6,minv_block_next_R2_C5_dqdPE6,minv_block_next_R3_C5_dqdPE6,minv_block_next_R4_C5_dqdPE6,minv_block_next_R5_C5_dqdPE6,minv_block_next_R6_C5_dqdPE6,minv_block_next_R7_C5_dqdPE6,
      minv_block_next_R1_C6_dqdPE6,minv_block_next_R2_C6_dqdPE6,minv_block_next_R3_C6_dqdPE6,minv_block_next_R4_C6_dqdPE6,minv_block_next_R5_C6_dqdPE6,minv_block_next_R6_C6_dqdPE6,minv_block_next_R7_C6_dqdPE6,
      minv_block_next_R1_C7_dqdPE6,minv_block_next_R2_C7_dqdPE6,minv_block_next_R3_C7_dqdPE6,minv_block_next_R4_C7_dqdPE6,minv_block_next_R5_C7_dqdPE6,minv_block_next_R6_C7_dqdPE6,minv_block_next_R7_C7_dqdPE6;
   wire signed[(WIDTH-1):0]
      dtau_vec_next_R1_dqdPE6,dtau_vec_next_R2_dqdPE6,dtau_vec_next_R3_dqdPE6,dtau_vec_next_R4_dqdPE6,dtau_vec_next_R5_dqdPE6,dtau_vec_next_R6_dqdPE6,dtau_vec_next_R7_dqdPE6;
   // dqdPE7
   wire signed[(WIDTH-1):0]
      minv_block_next_R1_C1_dqdPE7,minv_block_next_R2_C1_dqdPE7,minv_block_next_R3_C1_dqdPE7,minv_block_next_R4_C1_dqdPE7,minv_block_next_R5_C1_dqdPE7,minv_block_next_R6_C1_dqdPE7,minv_block_next_R7_C1_dqdPE7,
      minv_block_next_R1_C2_dqdPE7,minv_block_next_R2_C2_dqdPE7,minv_block_next_R3_C2_dqdPE7,minv_block_next_R4_C2_dqdPE7,minv_block_next_R5_C2_dqdPE7,minv_block_next_R6_C2_dqdPE7,minv_block_next_R7_C2_dqdPE7,
      minv_block_next_R1_C3_dqdPE7,minv_block_next_R2_C3_dqdPE7,minv_block_next_R3_C3_dqdPE7,minv_block_next_R4_C3_dqdPE7,minv_block_next_R5_C3_dqdPE7,minv_block_next_R6_C3_dqdPE7,minv_block_next_R7_C3_dqdPE7,
      minv_block_next_R1_C4_dqdPE7,minv_block_next_R2_C4_dqdPE7,minv_block_next_R3_C4_dqdPE7,minv_block_next_R4_C4_dqdPE7,minv_block_next_R5_C4_dqdPE7,minv_block_next_R6_C4_dqdPE7,minv_block_next_R7_C4_dqdPE7,
      minv_block_next_R1_C5_dqdPE7,minv_block_next_R2_C5_dqdPE7,minv_block_next_R3_C5_dqdPE7,minv_block_next_R4_C5_dqdPE7,minv_block_next_R5_C5_dqdPE7,minv_block_next_R6_C5_dqdPE7,minv_block_next_R7_C5_dqdPE7,
      minv_block_next_R1_C6_dqdPE7,minv_block_next_R2_C6_dqdPE7,minv_block_next_R3_C6_dqdPE7,minv_block_next_R4_C6_dqdPE7,minv_block_next_R5_C6_dqdPE7,minv_block_next_R6_C6_dqdPE7,minv_block_next_R7_C6_dqdPE7,
      minv_block_next_R1_C7_dqdPE7,minv_block_next_R2_C7_dqdPE7,minv_block_next_R3_C7_dqdPE7,minv_block_next_R4_C7_dqdPE7,minv_block_next_R5_C7_dqdPE7,minv_block_next_R6_C7_dqdPE7,minv_block_next_R7_C7_dqdPE7;
   wire signed[(WIDTH-1):0]
      dtau_vec_next_R1_dqdPE7,dtau_vec_next_R2_dqdPE7,dtau_vec_next_R3_dqdPE7,dtau_vec_next_R4_dqdPE7,dtau_vec_next_R5_dqdPE7,dtau_vec_next_R6_dqdPE7,dtau_vec_next_R7_dqdPE7;
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
   // external assignments
   //---------------------------------------------------------------------------
   // inputs
   assign get_data_next = get_data;
   assign get_data_minv_next = get_data_minv;
   // output
   assign output_ready = output_ready_reg;
   assign output_ready_minv = output_ready_minv_reg;
   assign output_ready_next = ((state_reg == 3'd0)&&(get_data == 1)) ? 1 :
                              ((state_reg == 3'd0)&&(get_data == 0)) ? 0 :
                              ((state_reg == 3'd1)&&(get_data == 1)) ? 1 :
                              ((state_reg == 3'd1)&&(get_data == 0)) ? 0 : output_ready_reg;
   assign output_ready_minv_next = ((state_minv_reg == 3'd0)&&(get_data_minv == 1)) ? 1 :
                                   ((state_minv_reg == 3'd0)&&(get_data_minv == 0)) ? 0 :
                                   ((state_minv_reg == 3'd1)&&(get_data_minv == 1)) ? 1 :
                                   ((state_minv_reg == 3'd1)&&(get_data_minv == 0)) ? 0 : output_ready_minv_reg;
   // minv
   assign minv_bool_next = ((state_minv_reg == 3'd0)&&(get_data_minv == 1)) ? 1 :
                           ((state_minv_reg == 3'd0)&&(get_data_minv == 0)) ? 0 :
                           ((state_minv_reg == 3'd1)&&(get_data_minv == 1)) ? 1 :
                           ((state_minv_reg == 3'd1)&&(get_data_minv == 0)) ? 0 : 0;
   // state
   assign state_next     = ((state_reg == 3'd0)&&(get_data == 1)&&(get_data_minv == 0)) ? 3'd1 :
                           ((state_reg == 3'd0)&&(get_data == 1)&&(get_data_minv == 1)) ? 3'd0 :
                           ((state_reg == 3'd0)&&(get_data == 0)&&(get_data_minv == 0)) ? 3'd0 :
                           ((state_reg == 3'd0)&&(get_data == 0)&&(get_data_minv == 1)) ? 3'd0 :
                           ((state_reg == 3'd1)&&(get_data == 1)&&(get_data_minv == 0)) ? 3'd1 :
                           ((state_reg == 3'd1)&&(get_data == 1)&&(get_data_minv == 1)) ? 3'd0 :
                           ((state_reg == 3'd1)&&(get_data == 0)&&(get_data_minv == 0)) ? 3'd0 :
                           ((state_reg == 3'd1)&&(get_data == 0)&&(get_data_minv == 1)) ? 3'd0 : state_reg;
   assign state_minv_next = ((state_minv_reg == 3'd0)&&(get_data_minv == 1)) ? 3'd1 :
                            ((state_minv_reg == 3'd0)&&(get_data_minv == 0)) ? 3'd0 :
                            ((state_minv_reg == 3'd1)&&(get_data_minv == 1)) ? 3'd1 :
                            ((state_minv_reg == 3'd1)&&(get_data_minv == 0)) ? 3'd0 : state_minv_reg;
   //---------------------------------------------------------------------------
   // rnea external inputs
   //---------------------------------------------------------------------------
   // rnea
   assign link_next_rnea = (get_data == 1) ? link_in_rnea :
                           (get_data == 1) ? link_in_rnea : link_reg_rnea;
   assign sinq_val_next_rnea = (get_data == 1) ? sinq_val_in_rnea :
                               (get_data == 1) ? sinq_val_in_rnea : sinq_val_reg_rnea;
   assign cosq_val_next_rnea = (get_data == 1) ? cosq_val_in_rnea :
                               (get_data == 1) ? cosq_val_in_rnea : cosq_val_reg_rnea;
   // f updated curr
   assign f_upd_curr_vec_next_AX_rnea = (get_data == 1) ? f_upd_curr_vec_in_AX_rnea :
                                        (get_data == 1) ? f_upd_curr_vec_in_AX_rnea : f_upd_curr_vec_reg_AX_rnea;
   assign f_upd_curr_vec_next_AY_rnea = (get_data == 1) ? f_upd_curr_vec_in_AY_rnea :
                                        (get_data == 1) ? f_upd_curr_vec_in_AY_rnea : f_upd_curr_vec_reg_AY_rnea;
   assign f_upd_curr_vec_next_AZ_rnea = (get_data == 1) ? f_upd_curr_vec_in_AZ_rnea :
                                        (get_data == 1) ? f_upd_curr_vec_in_AZ_rnea : f_upd_curr_vec_reg_AZ_rnea;
   assign f_upd_curr_vec_next_LX_rnea = (get_data == 1) ? f_upd_curr_vec_in_LX_rnea :
                                        (get_data == 1) ? f_upd_curr_vec_in_LX_rnea : f_upd_curr_vec_reg_LX_rnea;
   assign f_upd_curr_vec_next_LY_rnea = (get_data == 1) ? f_upd_curr_vec_in_LY_rnea :
                                        (get_data == 1) ? f_upd_curr_vec_in_LY_rnea : f_upd_curr_vec_reg_LY_rnea;
   assign f_upd_curr_vec_next_LZ_rnea = (get_data == 1) ? f_upd_curr_vec_in_LZ_rnea :
                                        (get_data == 1) ? f_upd_curr_vec_in_LZ_rnea : f_upd_curr_vec_reg_LZ_rnea;
   // f prev
   assign f_prev_vec_next_AX_rnea = (get_data == 1) ? f_prev_vec_in_AX_rnea :
                                    (get_data == 1) ? f_prev_vec_in_AX_rnea : f_prev_vec_reg_AX_rnea;
   assign f_prev_vec_next_AY_rnea = (get_data == 1) ? f_prev_vec_in_AY_rnea :
                                    (get_data == 1) ? f_prev_vec_in_AY_rnea : f_prev_vec_reg_AY_rnea;
   assign f_prev_vec_next_AZ_rnea = (get_data == 1) ? f_prev_vec_in_AZ_rnea :
                                    (get_data == 1) ? f_prev_vec_in_AZ_rnea : f_prev_vec_reg_AZ_rnea;
   assign f_prev_vec_next_LX_rnea = (get_data == 1) ? f_prev_vec_in_LX_rnea :
                                    (get_data == 1) ? f_prev_vec_in_LX_rnea : f_prev_vec_reg_LX_rnea;
   assign f_prev_vec_next_LY_rnea = (get_data == 1) ? f_prev_vec_in_LY_rnea :
                                    (get_data == 1) ? f_prev_vec_in_LY_rnea : f_prev_vec_reg_LY_rnea;
   assign f_prev_vec_next_LZ_rnea = (get_data == 1) ? f_prev_vec_in_LZ_rnea :
                                    (get_data == 1) ? f_prev_vec_in_LZ_rnea : f_prev_vec_reg_LZ_rnea;
   //---------------------------------------------------------------------------
   // dq external inputs
   //---------------------------------------------------------------------------
   // dqPE1
   assign link_next_dqPE1 = (get_data == 1) ? link_in_dqPE1 :
                            (get_data == 1) ? link_in_dqPE1 : link_reg_dqPE1;
   assign derv_next_dqPE1 = (get_data == 1) ? derv_in_dqPE1 :
                            (get_data == 1) ? derv_in_dqPE1 : derv_reg_dqPE1;
   assign sinq_val_next_dqPE1 = (get_data == 1) ? sinq_val_in_dqPE1 :
                                (get_data == 1) ? sinq_val_in_dqPE1 : sinq_val_reg_dqPE1;
   assign cosq_val_next_dqPE1 = (get_data == 1) ? cosq_val_in_dqPE1 :
                                (get_data == 1) ? cosq_val_in_dqPE1 : cosq_val_reg_dqPE1;
   // f updated curr
   assign f_upd_curr_vec_next_AX_dqPE1 = (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE1 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE1 : f_upd_curr_vec_reg_AX_dqPE1;
   assign f_upd_curr_vec_next_AY_dqPE1 = (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE1 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE1 : f_upd_curr_vec_reg_AY_dqPE1;
   assign f_upd_curr_vec_next_AZ_dqPE1 = (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE1 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE1 : f_upd_curr_vec_reg_AZ_dqPE1;
   assign f_upd_curr_vec_next_LX_dqPE1 = (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE1 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE1 : f_upd_curr_vec_reg_LX_dqPE1;
   assign f_upd_curr_vec_next_LY_dqPE1 = (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE1 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE1 : f_upd_curr_vec_reg_LY_dqPE1;
   assign f_upd_curr_vec_next_LZ_dqPE1 = (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE1 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE1 : f_upd_curr_vec_reg_LZ_dqPE1;
   // df prev
   assign dfdq_prev_vec_next_AX_dqPE1 = (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE1 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE1 : dfdq_prev_vec_reg_AX_dqPE1;
   assign dfdq_prev_vec_next_AY_dqPE1 = (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE1 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE1 : dfdq_prev_vec_reg_AY_dqPE1;
   assign dfdq_prev_vec_next_AZ_dqPE1 = (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE1 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE1 : dfdq_prev_vec_reg_AZ_dqPE1;
   assign dfdq_prev_vec_next_LX_dqPE1 = (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE1 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE1 : dfdq_prev_vec_reg_LX_dqPE1;
   assign dfdq_prev_vec_next_LY_dqPE1 = (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE1 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE1 : dfdq_prev_vec_reg_LY_dqPE1;
   assign dfdq_prev_vec_next_LZ_dqPE1 = (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE1 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE1 : dfdq_prev_vec_reg_LZ_dqPE1;
   // f updated curr
   assign dfdq_upd_curr_vec_next_AX_dqPE1 = (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE1 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE1 : dfdq_upd_curr_vec_reg_AX_dqPE1;
   assign dfdq_upd_curr_vec_next_AY_dqPE1 = (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE1 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE1 : dfdq_upd_curr_vec_reg_AY_dqPE1;
   assign dfdq_upd_curr_vec_next_AZ_dqPE1 = (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE1 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE1 : dfdq_upd_curr_vec_reg_AZ_dqPE1;
   assign dfdq_upd_curr_vec_next_LX_dqPE1 = (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE1 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE1 : dfdq_upd_curr_vec_reg_LX_dqPE1;
   assign dfdq_upd_curr_vec_next_LY_dqPE1 = (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE1 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE1 : dfdq_upd_curr_vec_reg_LY_dqPE1;
   assign dfdq_upd_curr_vec_next_LZ_dqPE1 = (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE1 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE1 : dfdq_upd_curr_vec_reg_LZ_dqPE1;
   // dqPE2
   assign link_next_dqPE2 = (get_data == 1) ? link_in_dqPE2 :
                            (get_data == 1) ? link_in_dqPE2 : link_reg_dqPE2;
   assign derv_next_dqPE2 = (get_data == 1) ? derv_in_dqPE2 :
                            (get_data == 1) ? derv_in_dqPE2 : derv_reg_dqPE2;
   assign sinq_val_next_dqPE2 = (get_data == 1) ? sinq_val_in_dqPE2 :
                                (get_data == 1) ? sinq_val_in_dqPE2 : sinq_val_reg_dqPE2;
   assign cosq_val_next_dqPE2 = (get_data == 1) ? cosq_val_in_dqPE2 :
                                (get_data == 1) ? cosq_val_in_dqPE2 : cosq_val_reg_dqPE2;
   // f updated curr
   assign f_upd_curr_vec_next_AX_dqPE2 = (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE2 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE2 : f_upd_curr_vec_reg_AX_dqPE2;
   assign f_upd_curr_vec_next_AY_dqPE2 = (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE2 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE2 : f_upd_curr_vec_reg_AY_dqPE2;
   assign f_upd_curr_vec_next_AZ_dqPE2 = (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE2 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE2 : f_upd_curr_vec_reg_AZ_dqPE2;
   assign f_upd_curr_vec_next_LX_dqPE2 = (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE2 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE2 : f_upd_curr_vec_reg_LX_dqPE2;
   assign f_upd_curr_vec_next_LY_dqPE2 = (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE2 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE2 : f_upd_curr_vec_reg_LY_dqPE2;
   assign f_upd_curr_vec_next_LZ_dqPE2 = (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE2 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE2 : f_upd_curr_vec_reg_LZ_dqPE2;
   // df prev
   assign dfdq_prev_vec_next_AX_dqPE2 = (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE2 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE2 : dfdq_prev_vec_reg_AX_dqPE2;
   assign dfdq_prev_vec_next_AY_dqPE2 = (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE2 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE2 : dfdq_prev_vec_reg_AY_dqPE2;
   assign dfdq_prev_vec_next_AZ_dqPE2 = (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE2 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE2 : dfdq_prev_vec_reg_AZ_dqPE2;
   assign dfdq_prev_vec_next_LX_dqPE2 = (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE2 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE2 : dfdq_prev_vec_reg_LX_dqPE2;
   assign dfdq_prev_vec_next_LY_dqPE2 = (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE2 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE2 : dfdq_prev_vec_reg_LY_dqPE2;
   assign dfdq_prev_vec_next_LZ_dqPE2 = (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE2 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE2 : dfdq_prev_vec_reg_LZ_dqPE2;
   // f updated curr
   assign dfdq_upd_curr_vec_next_AX_dqPE2 = (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE2 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE2 : dfdq_upd_curr_vec_reg_AX_dqPE2;
   assign dfdq_upd_curr_vec_next_AY_dqPE2 = (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE2 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE2 : dfdq_upd_curr_vec_reg_AY_dqPE2;
   assign dfdq_upd_curr_vec_next_AZ_dqPE2 = (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE2 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE2 : dfdq_upd_curr_vec_reg_AZ_dqPE2;
   assign dfdq_upd_curr_vec_next_LX_dqPE2 = (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE2 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE2 : dfdq_upd_curr_vec_reg_LX_dqPE2;
   assign dfdq_upd_curr_vec_next_LY_dqPE2 = (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE2 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE2 : dfdq_upd_curr_vec_reg_LY_dqPE2;
   assign dfdq_upd_curr_vec_next_LZ_dqPE2 = (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE2 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE2 : dfdq_upd_curr_vec_reg_LZ_dqPE2;
   // dqPE3
   assign link_next_dqPE3 = (get_data == 1) ? link_in_dqPE3 :
                            (get_data == 1) ? link_in_dqPE3 : link_reg_dqPE3;
   assign derv_next_dqPE3 = (get_data == 1) ? derv_in_dqPE3 :
                            (get_data == 1) ? derv_in_dqPE3 : derv_reg_dqPE3;
   assign sinq_val_next_dqPE3 = (get_data == 1) ? sinq_val_in_dqPE3 :
                                (get_data == 1) ? sinq_val_in_dqPE3 : sinq_val_reg_dqPE3;
   assign cosq_val_next_dqPE3 = (get_data == 1) ? cosq_val_in_dqPE3 :
                                (get_data == 1) ? cosq_val_in_dqPE3 : cosq_val_reg_dqPE3;
   // f updated curr
   assign f_upd_curr_vec_next_AX_dqPE3 = (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE3 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE3 : f_upd_curr_vec_reg_AX_dqPE3;
   assign f_upd_curr_vec_next_AY_dqPE3 = (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE3 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE3 : f_upd_curr_vec_reg_AY_dqPE3;
   assign f_upd_curr_vec_next_AZ_dqPE3 = (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE3 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE3 : f_upd_curr_vec_reg_AZ_dqPE3;
   assign f_upd_curr_vec_next_LX_dqPE3 = (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE3 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE3 : f_upd_curr_vec_reg_LX_dqPE3;
   assign f_upd_curr_vec_next_LY_dqPE3 = (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE3 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE3 : f_upd_curr_vec_reg_LY_dqPE3;
   assign f_upd_curr_vec_next_LZ_dqPE3 = (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE3 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE3 : f_upd_curr_vec_reg_LZ_dqPE3;
   // df prev
   assign dfdq_prev_vec_next_AX_dqPE3 = (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE3 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE3 : dfdq_prev_vec_reg_AX_dqPE3;
   assign dfdq_prev_vec_next_AY_dqPE3 = (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE3 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE3 : dfdq_prev_vec_reg_AY_dqPE3;
   assign dfdq_prev_vec_next_AZ_dqPE3 = (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE3 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE3 : dfdq_prev_vec_reg_AZ_dqPE3;
   assign dfdq_prev_vec_next_LX_dqPE3 = (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE3 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE3 : dfdq_prev_vec_reg_LX_dqPE3;
   assign dfdq_prev_vec_next_LY_dqPE3 = (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE3 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE3 : dfdq_prev_vec_reg_LY_dqPE3;
   assign dfdq_prev_vec_next_LZ_dqPE3 = (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE3 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE3 : dfdq_prev_vec_reg_LZ_dqPE3;
   // f updated curr
   assign dfdq_upd_curr_vec_next_AX_dqPE3 = (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE3 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE3 : dfdq_upd_curr_vec_reg_AX_dqPE3;
   assign dfdq_upd_curr_vec_next_AY_dqPE3 = (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE3 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE3 : dfdq_upd_curr_vec_reg_AY_dqPE3;
   assign dfdq_upd_curr_vec_next_AZ_dqPE3 = (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE3 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE3 : dfdq_upd_curr_vec_reg_AZ_dqPE3;
   assign dfdq_upd_curr_vec_next_LX_dqPE3 = (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE3 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE3 : dfdq_upd_curr_vec_reg_LX_dqPE3;
   assign dfdq_upd_curr_vec_next_LY_dqPE3 = (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE3 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE3 : dfdq_upd_curr_vec_reg_LY_dqPE3;
   assign dfdq_upd_curr_vec_next_LZ_dqPE3 = (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE3 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE3 : dfdq_upd_curr_vec_reg_LZ_dqPE3;
   // dqPE4
   assign link_next_dqPE4 = (get_data == 1) ? link_in_dqPE4 :
                            (get_data == 1) ? link_in_dqPE4 : link_reg_dqPE4;
   assign derv_next_dqPE4 = (get_data == 1) ? derv_in_dqPE4 :
                            (get_data == 1) ? derv_in_dqPE4 : derv_reg_dqPE4;
   assign sinq_val_next_dqPE4 = (get_data == 1) ? sinq_val_in_dqPE4 :
                                (get_data == 1) ? sinq_val_in_dqPE4 : sinq_val_reg_dqPE4;
   assign cosq_val_next_dqPE4 = (get_data == 1) ? cosq_val_in_dqPE4 :
                                (get_data == 1) ? cosq_val_in_dqPE4 : cosq_val_reg_dqPE4;
   // f updated curr
   assign f_upd_curr_vec_next_AX_dqPE4 = (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE4 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE4 : f_upd_curr_vec_reg_AX_dqPE4;
   assign f_upd_curr_vec_next_AY_dqPE4 = (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE4 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE4 : f_upd_curr_vec_reg_AY_dqPE4;
   assign f_upd_curr_vec_next_AZ_dqPE4 = (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE4 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE4 : f_upd_curr_vec_reg_AZ_dqPE4;
   assign f_upd_curr_vec_next_LX_dqPE4 = (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE4 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE4 : f_upd_curr_vec_reg_LX_dqPE4;
   assign f_upd_curr_vec_next_LY_dqPE4 = (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE4 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE4 : f_upd_curr_vec_reg_LY_dqPE4;
   assign f_upd_curr_vec_next_LZ_dqPE4 = (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE4 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE4 : f_upd_curr_vec_reg_LZ_dqPE4;
   // df prev
   assign dfdq_prev_vec_next_AX_dqPE4 = (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE4 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE4 : dfdq_prev_vec_reg_AX_dqPE4;
   assign dfdq_prev_vec_next_AY_dqPE4 = (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE4 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE4 : dfdq_prev_vec_reg_AY_dqPE4;
   assign dfdq_prev_vec_next_AZ_dqPE4 = (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE4 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE4 : dfdq_prev_vec_reg_AZ_dqPE4;
   assign dfdq_prev_vec_next_LX_dqPE4 = (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE4 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE4 : dfdq_prev_vec_reg_LX_dqPE4;
   assign dfdq_prev_vec_next_LY_dqPE4 = (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE4 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE4 : dfdq_prev_vec_reg_LY_dqPE4;
   assign dfdq_prev_vec_next_LZ_dqPE4 = (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE4 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE4 : dfdq_prev_vec_reg_LZ_dqPE4;
   // f updated curr
   assign dfdq_upd_curr_vec_next_AX_dqPE4 = (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE4 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE4 : dfdq_upd_curr_vec_reg_AX_dqPE4;
   assign dfdq_upd_curr_vec_next_AY_dqPE4 = (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE4 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE4 : dfdq_upd_curr_vec_reg_AY_dqPE4;
   assign dfdq_upd_curr_vec_next_AZ_dqPE4 = (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE4 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE4 : dfdq_upd_curr_vec_reg_AZ_dqPE4;
   assign dfdq_upd_curr_vec_next_LX_dqPE4 = (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE4 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE4 : dfdq_upd_curr_vec_reg_LX_dqPE4;
   assign dfdq_upd_curr_vec_next_LY_dqPE4 = (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE4 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE4 : dfdq_upd_curr_vec_reg_LY_dqPE4;
   assign dfdq_upd_curr_vec_next_LZ_dqPE4 = (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE4 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE4 : dfdq_upd_curr_vec_reg_LZ_dqPE4;
   // dqPE5
   assign link_next_dqPE5 = (get_data == 1) ? link_in_dqPE5 :
                            (get_data == 1) ? link_in_dqPE5 : link_reg_dqPE5;
   assign derv_next_dqPE5 = (get_data == 1) ? derv_in_dqPE5 :
                            (get_data == 1) ? derv_in_dqPE5 : derv_reg_dqPE5;
   assign sinq_val_next_dqPE5 = (get_data == 1) ? sinq_val_in_dqPE5 :
                                (get_data == 1) ? sinq_val_in_dqPE5 : sinq_val_reg_dqPE5;
   assign cosq_val_next_dqPE5 = (get_data == 1) ? cosq_val_in_dqPE5 :
                                (get_data == 1) ? cosq_val_in_dqPE5 : cosq_val_reg_dqPE5;
   // f updated curr
   assign f_upd_curr_vec_next_AX_dqPE5 = (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE5 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE5 : f_upd_curr_vec_reg_AX_dqPE5;
   assign f_upd_curr_vec_next_AY_dqPE5 = (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE5 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE5 : f_upd_curr_vec_reg_AY_dqPE5;
   assign f_upd_curr_vec_next_AZ_dqPE5 = (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE5 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE5 : f_upd_curr_vec_reg_AZ_dqPE5;
   assign f_upd_curr_vec_next_LX_dqPE5 = (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE5 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE5 : f_upd_curr_vec_reg_LX_dqPE5;
   assign f_upd_curr_vec_next_LY_dqPE5 = (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE5 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE5 : f_upd_curr_vec_reg_LY_dqPE5;
   assign f_upd_curr_vec_next_LZ_dqPE5 = (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE5 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE5 : f_upd_curr_vec_reg_LZ_dqPE5;
   // df prev
   assign dfdq_prev_vec_next_AX_dqPE5 = (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE5 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE5 : dfdq_prev_vec_reg_AX_dqPE5;
   assign dfdq_prev_vec_next_AY_dqPE5 = (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE5 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE5 : dfdq_prev_vec_reg_AY_dqPE5;
   assign dfdq_prev_vec_next_AZ_dqPE5 = (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE5 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE5 : dfdq_prev_vec_reg_AZ_dqPE5;
   assign dfdq_prev_vec_next_LX_dqPE5 = (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE5 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE5 : dfdq_prev_vec_reg_LX_dqPE5;
   assign dfdq_prev_vec_next_LY_dqPE5 = (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE5 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE5 : dfdq_prev_vec_reg_LY_dqPE5;
   assign dfdq_prev_vec_next_LZ_dqPE5 = (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE5 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE5 : dfdq_prev_vec_reg_LZ_dqPE5;
   // f updated curr
   assign dfdq_upd_curr_vec_next_AX_dqPE5 = (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE5 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE5 : dfdq_upd_curr_vec_reg_AX_dqPE5;
   assign dfdq_upd_curr_vec_next_AY_dqPE5 = (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE5 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE5 : dfdq_upd_curr_vec_reg_AY_dqPE5;
   assign dfdq_upd_curr_vec_next_AZ_dqPE5 = (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE5 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE5 : dfdq_upd_curr_vec_reg_AZ_dqPE5;
   assign dfdq_upd_curr_vec_next_LX_dqPE5 = (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE5 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE5 : dfdq_upd_curr_vec_reg_LX_dqPE5;
   assign dfdq_upd_curr_vec_next_LY_dqPE5 = (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE5 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE5 : dfdq_upd_curr_vec_reg_LY_dqPE5;
   assign dfdq_upd_curr_vec_next_LZ_dqPE5 = (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE5 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE5 : dfdq_upd_curr_vec_reg_LZ_dqPE5;
   // dqPE6
   assign link_next_dqPE6 = (get_data == 1) ? link_in_dqPE6 :
                            (get_data == 1) ? link_in_dqPE6 : link_reg_dqPE6;
   assign derv_next_dqPE6 = (get_data == 1) ? derv_in_dqPE6 :
                            (get_data == 1) ? derv_in_dqPE6 : derv_reg_dqPE6;
   assign sinq_val_next_dqPE6 = (get_data == 1) ? sinq_val_in_dqPE6 :
                                (get_data == 1) ? sinq_val_in_dqPE6 : sinq_val_reg_dqPE6;
   assign cosq_val_next_dqPE6 = (get_data == 1) ? cosq_val_in_dqPE6 :
                                (get_data == 1) ? cosq_val_in_dqPE6 : cosq_val_reg_dqPE6;
   // f updated curr
   assign f_upd_curr_vec_next_AX_dqPE6 = (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE6 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE6 : f_upd_curr_vec_reg_AX_dqPE6;
   assign f_upd_curr_vec_next_AY_dqPE6 = (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE6 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE6 : f_upd_curr_vec_reg_AY_dqPE6;
   assign f_upd_curr_vec_next_AZ_dqPE6 = (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE6 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE6 : f_upd_curr_vec_reg_AZ_dqPE6;
   assign f_upd_curr_vec_next_LX_dqPE6 = (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE6 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE6 : f_upd_curr_vec_reg_LX_dqPE6;
   assign f_upd_curr_vec_next_LY_dqPE6 = (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE6 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE6 : f_upd_curr_vec_reg_LY_dqPE6;
   assign f_upd_curr_vec_next_LZ_dqPE6 = (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE6 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE6 : f_upd_curr_vec_reg_LZ_dqPE6;
   // df prev
   assign dfdq_prev_vec_next_AX_dqPE6 = (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE6 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE6 : dfdq_prev_vec_reg_AX_dqPE6;
   assign dfdq_prev_vec_next_AY_dqPE6 = (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE6 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE6 : dfdq_prev_vec_reg_AY_dqPE6;
   assign dfdq_prev_vec_next_AZ_dqPE6 = (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE6 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE6 : dfdq_prev_vec_reg_AZ_dqPE6;
   assign dfdq_prev_vec_next_LX_dqPE6 = (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE6 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE6 : dfdq_prev_vec_reg_LX_dqPE6;
   assign dfdq_prev_vec_next_LY_dqPE6 = (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE6 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE6 : dfdq_prev_vec_reg_LY_dqPE6;
   assign dfdq_prev_vec_next_LZ_dqPE6 = (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE6 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE6 : dfdq_prev_vec_reg_LZ_dqPE6;
   // f updated curr
   assign dfdq_upd_curr_vec_next_AX_dqPE6 = (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE6 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE6 : dfdq_upd_curr_vec_reg_AX_dqPE6;
   assign dfdq_upd_curr_vec_next_AY_dqPE6 = (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE6 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE6 : dfdq_upd_curr_vec_reg_AY_dqPE6;
   assign dfdq_upd_curr_vec_next_AZ_dqPE6 = (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE6 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE6 : dfdq_upd_curr_vec_reg_AZ_dqPE6;
   assign dfdq_upd_curr_vec_next_LX_dqPE6 = (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE6 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE6 : dfdq_upd_curr_vec_reg_LX_dqPE6;
   assign dfdq_upd_curr_vec_next_LY_dqPE6 = (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE6 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE6 : dfdq_upd_curr_vec_reg_LY_dqPE6;
   assign dfdq_upd_curr_vec_next_LZ_dqPE6 = (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE6 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE6 : dfdq_upd_curr_vec_reg_LZ_dqPE6;
   // dqPE7
   assign link_next_dqPE7 = (get_data == 1) ? link_in_dqPE7 :
                            (get_data == 1) ? link_in_dqPE7 : link_reg_dqPE7;
   assign derv_next_dqPE7 = (get_data == 1) ? derv_in_dqPE7 :
                            (get_data == 1) ? derv_in_dqPE7 : derv_reg_dqPE7;
   assign sinq_val_next_dqPE7 = (get_data == 1) ? sinq_val_in_dqPE7 :
                                (get_data == 1) ? sinq_val_in_dqPE7 : sinq_val_reg_dqPE7;
   assign cosq_val_next_dqPE7 = (get_data == 1) ? cosq_val_in_dqPE7 :
                                (get_data == 1) ? cosq_val_in_dqPE7 : cosq_val_reg_dqPE7;
   // f updated curr
   assign f_upd_curr_vec_next_AX_dqPE7 = (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE7 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AX_dqPE7 : f_upd_curr_vec_reg_AX_dqPE7;
   assign f_upd_curr_vec_next_AY_dqPE7 = (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE7 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AY_dqPE7 : f_upd_curr_vec_reg_AY_dqPE7;
   assign f_upd_curr_vec_next_AZ_dqPE7 = (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE7 :
                                         (get_data == 1) ? f_upd_curr_vec_in_AZ_dqPE7 : f_upd_curr_vec_reg_AZ_dqPE7;
   assign f_upd_curr_vec_next_LX_dqPE7 = (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE7 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LX_dqPE7 : f_upd_curr_vec_reg_LX_dqPE7;
   assign f_upd_curr_vec_next_LY_dqPE7 = (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE7 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LY_dqPE7 : f_upd_curr_vec_reg_LY_dqPE7;
   assign f_upd_curr_vec_next_LZ_dqPE7 = (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE7 :
                                         (get_data == 1) ? f_upd_curr_vec_in_LZ_dqPE7 : f_upd_curr_vec_reg_LZ_dqPE7;
   // df prev
   assign dfdq_prev_vec_next_AX_dqPE7 = (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE7 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AX_dqPE7 : dfdq_prev_vec_reg_AX_dqPE7;
   assign dfdq_prev_vec_next_AY_dqPE7 = (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE7 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AY_dqPE7 : dfdq_prev_vec_reg_AY_dqPE7;
   assign dfdq_prev_vec_next_AZ_dqPE7 = (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE7 :
                                        (get_data == 1) ? dfdq_prev_vec_in_AZ_dqPE7 : dfdq_prev_vec_reg_AZ_dqPE7;
   assign dfdq_prev_vec_next_LX_dqPE7 = (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE7 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LX_dqPE7 : dfdq_prev_vec_reg_LX_dqPE7;
   assign dfdq_prev_vec_next_LY_dqPE7 = (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE7 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LY_dqPE7 : dfdq_prev_vec_reg_LY_dqPE7;
   assign dfdq_prev_vec_next_LZ_dqPE7 = (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE7 :
                                        (get_data == 1) ? dfdq_prev_vec_in_LZ_dqPE7 : dfdq_prev_vec_reg_LZ_dqPE7;
   // f updated curr
   assign dfdq_upd_curr_vec_next_AX_dqPE7 = (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE7 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AX_dqPE7 : dfdq_upd_curr_vec_reg_AX_dqPE7;
   assign dfdq_upd_curr_vec_next_AY_dqPE7 = (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE7 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AY_dqPE7 : dfdq_upd_curr_vec_reg_AY_dqPE7;
   assign dfdq_upd_curr_vec_next_AZ_dqPE7 = (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE7 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_AZ_dqPE7 : dfdq_upd_curr_vec_reg_AZ_dqPE7;
   assign dfdq_upd_curr_vec_next_LX_dqPE7 = (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE7 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LX_dqPE7 : dfdq_upd_curr_vec_reg_LX_dqPE7;
   assign dfdq_upd_curr_vec_next_LY_dqPE7 = (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE7 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LY_dqPE7 : dfdq_upd_curr_vec_reg_LY_dqPE7;
   assign dfdq_upd_curr_vec_next_LZ_dqPE7 = (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE7 :
                                            (get_data == 1) ? dfdq_upd_curr_vec_in_LZ_dqPE7 : dfdq_upd_curr_vec_reg_LZ_dqPE7;
   //---------------------------------------------------------------------------
   // dqd external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   assign link_next_dqdPE1 = (get_data == 1) ? link_in_dqdPE1 :
                             (get_data == 1) ? link_in_dqdPE1 : link_reg_dqdPE1;
   assign derv_next_dqdPE1 = (get_data == 1) ? derv_in_dqdPE1 :
                             (get_data == 1) ? derv_in_dqdPE1 : derv_reg_dqdPE1;
   assign sinq_val_next_dqdPE1 = (get_data == 1) ? sinq_val_in_dqdPE1 :
                                 (get_data == 1) ? sinq_val_in_dqdPE1 : sinq_val_reg_dqdPE1;
   assign cosq_val_next_dqdPE1 = (get_data == 1) ? cosq_val_in_dqdPE1 :
                                 (get_data == 1) ? cosq_val_in_dqdPE1 : cosq_val_reg_dqdPE1;
   // df prev
   assign dfdqd_prev_vec_next_AX_dqdPE1 = (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE1 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE1 : dfdqd_prev_vec_reg_AX_dqdPE1;
   assign dfdqd_prev_vec_next_AY_dqdPE1 = (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE1 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE1 : dfdqd_prev_vec_reg_AY_dqdPE1;
   assign dfdqd_prev_vec_next_AZ_dqdPE1 = (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE1 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE1 : dfdqd_prev_vec_reg_AZ_dqdPE1;
   assign dfdqd_prev_vec_next_LX_dqdPE1 = (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE1 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE1 : dfdqd_prev_vec_reg_LX_dqdPE1;
   assign dfdqd_prev_vec_next_LY_dqdPE1 = (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE1 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE1 : dfdqd_prev_vec_reg_LY_dqdPE1;
   assign dfdqd_prev_vec_next_LZ_dqdPE1 = (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE1 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE1 : dfdqd_prev_vec_reg_LZ_dqdPE1;
   // f updated curr
   assign dfdqd_upd_curr_vec_next_AX_dqdPE1 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE1 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE1 : dfdqd_upd_curr_vec_reg_AX_dqdPE1;
   assign dfdqd_upd_curr_vec_next_AY_dqdPE1 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE1 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE1 : dfdqd_upd_curr_vec_reg_AY_dqdPE1;
   assign dfdqd_upd_curr_vec_next_AZ_dqdPE1 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE1 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE1 : dfdqd_upd_curr_vec_reg_AZ_dqdPE1;
   assign dfdqd_upd_curr_vec_next_LX_dqdPE1 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE1 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE1 : dfdqd_upd_curr_vec_reg_LX_dqdPE1;
   assign dfdqd_upd_curr_vec_next_LY_dqdPE1 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE1 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE1 : dfdqd_upd_curr_vec_reg_LY_dqdPE1;
   assign dfdqd_upd_curr_vec_next_LZ_dqdPE1 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE1 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE1 : dfdqd_upd_curr_vec_reg_LZ_dqdPE1;
   // dqdPE2
   assign link_next_dqdPE2 = (get_data == 1) ? link_in_dqdPE2 :
                             (get_data == 1) ? link_in_dqdPE2 : link_reg_dqdPE2;
   assign derv_next_dqdPE2 = (get_data == 1) ? derv_in_dqdPE2 :
                             (get_data == 1) ? derv_in_dqdPE2 : derv_reg_dqdPE2;
   assign sinq_val_next_dqdPE2 = (get_data == 1) ? sinq_val_in_dqdPE2 :
                                 (get_data == 1) ? sinq_val_in_dqdPE2 : sinq_val_reg_dqdPE2;
   assign cosq_val_next_dqdPE2 = (get_data == 1) ? cosq_val_in_dqdPE2 :
                                 (get_data == 1) ? cosq_val_in_dqdPE2 : cosq_val_reg_dqdPE2;
   // df prev
   assign dfdqd_prev_vec_next_AX_dqdPE2 = (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE2 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE2 : dfdqd_prev_vec_reg_AX_dqdPE2;
   assign dfdqd_prev_vec_next_AY_dqdPE2 = (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE2 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE2 : dfdqd_prev_vec_reg_AY_dqdPE2;
   assign dfdqd_prev_vec_next_AZ_dqdPE2 = (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE2 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE2 : dfdqd_prev_vec_reg_AZ_dqdPE2;
   assign dfdqd_prev_vec_next_LX_dqdPE2 = (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE2 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE2 : dfdqd_prev_vec_reg_LX_dqdPE2;
   assign dfdqd_prev_vec_next_LY_dqdPE2 = (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE2 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE2 : dfdqd_prev_vec_reg_LY_dqdPE2;
   assign dfdqd_prev_vec_next_LZ_dqdPE2 = (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE2 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE2 : dfdqd_prev_vec_reg_LZ_dqdPE2;
   // f updated curr
   assign dfdqd_upd_curr_vec_next_AX_dqdPE2 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE2 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE2 : dfdqd_upd_curr_vec_reg_AX_dqdPE2;
   assign dfdqd_upd_curr_vec_next_AY_dqdPE2 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE2 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE2 : dfdqd_upd_curr_vec_reg_AY_dqdPE2;
   assign dfdqd_upd_curr_vec_next_AZ_dqdPE2 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE2 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE2 : dfdqd_upd_curr_vec_reg_AZ_dqdPE2;
   assign dfdqd_upd_curr_vec_next_LX_dqdPE2 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE2 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE2 : dfdqd_upd_curr_vec_reg_LX_dqdPE2;
   assign dfdqd_upd_curr_vec_next_LY_dqdPE2 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE2 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE2 : dfdqd_upd_curr_vec_reg_LY_dqdPE2;
   assign dfdqd_upd_curr_vec_next_LZ_dqdPE2 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE2 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE2 : dfdqd_upd_curr_vec_reg_LZ_dqdPE2;
   // dqdPE3
   assign link_next_dqdPE3 = (get_data == 1) ? link_in_dqdPE3 :
                             (get_data == 1) ? link_in_dqdPE3 : link_reg_dqdPE3;
   assign derv_next_dqdPE3 = (get_data == 1) ? derv_in_dqdPE3 :
                             (get_data == 1) ? derv_in_dqdPE3 : derv_reg_dqdPE3;
   assign sinq_val_next_dqdPE3 = (get_data == 1) ? sinq_val_in_dqdPE3 :
                                 (get_data == 1) ? sinq_val_in_dqdPE3 : sinq_val_reg_dqdPE3;
   assign cosq_val_next_dqdPE3 = (get_data == 1) ? cosq_val_in_dqdPE3 :
                                 (get_data == 1) ? cosq_val_in_dqdPE3 : cosq_val_reg_dqdPE3;
   // df prev
   assign dfdqd_prev_vec_next_AX_dqdPE3 = (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE3 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE3 : dfdqd_prev_vec_reg_AX_dqdPE3;
   assign dfdqd_prev_vec_next_AY_dqdPE3 = (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE3 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE3 : dfdqd_prev_vec_reg_AY_dqdPE3;
   assign dfdqd_prev_vec_next_AZ_dqdPE3 = (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE3 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE3 : dfdqd_prev_vec_reg_AZ_dqdPE3;
   assign dfdqd_prev_vec_next_LX_dqdPE3 = (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE3 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE3 : dfdqd_prev_vec_reg_LX_dqdPE3;
   assign dfdqd_prev_vec_next_LY_dqdPE3 = (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE3 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE3 : dfdqd_prev_vec_reg_LY_dqdPE3;
   assign dfdqd_prev_vec_next_LZ_dqdPE3 = (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE3 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE3 : dfdqd_prev_vec_reg_LZ_dqdPE3;
   // f updated curr
   assign dfdqd_upd_curr_vec_next_AX_dqdPE3 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE3 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE3 : dfdqd_upd_curr_vec_reg_AX_dqdPE3;
   assign dfdqd_upd_curr_vec_next_AY_dqdPE3 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE3 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE3 : dfdqd_upd_curr_vec_reg_AY_dqdPE3;
   assign dfdqd_upd_curr_vec_next_AZ_dqdPE3 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE3 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE3 : dfdqd_upd_curr_vec_reg_AZ_dqdPE3;
   assign dfdqd_upd_curr_vec_next_LX_dqdPE3 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE3 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE3 : dfdqd_upd_curr_vec_reg_LX_dqdPE3;
   assign dfdqd_upd_curr_vec_next_LY_dqdPE3 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE3 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE3 : dfdqd_upd_curr_vec_reg_LY_dqdPE3;
   assign dfdqd_upd_curr_vec_next_LZ_dqdPE3 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE3 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE3 : dfdqd_upd_curr_vec_reg_LZ_dqdPE3;
   // dqdPE4
   assign link_next_dqdPE4 = (get_data == 1) ? link_in_dqdPE4 :
                             (get_data == 1) ? link_in_dqdPE4 : link_reg_dqdPE4;
   assign derv_next_dqdPE4 = (get_data == 1) ? derv_in_dqdPE4 :
                             (get_data == 1) ? derv_in_dqdPE4 : derv_reg_dqdPE4;
   assign sinq_val_next_dqdPE4 = (get_data == 1) ? sinq_val_in_dqdPE4 :
                                 (get_data == 1) ? sinq_val_in_dqdPE4 : sinq_val_reg_dqdPE4;
   assign cosq_val_next_dqdPE4 = (get_data == 1) ? cosq_val_in_dqdPE4 :
                                 (get_data == 1) ? cosq_val_in_dqdPE4 : cosq_val_reg_dqdPE4;
   // df prev
   assign dfdqd_prev_vec_next_AX_dqdPE4 = (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE4 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE4 : dfdqd_prev_vec_reg_AX_dqdPE4;
   assign dfdqd_prev_vec_next_AY_dqdPE4 = (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE4 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE4 : dfdqd_prev_vec_reg_AY_dqdPE4;
   assign dfdqd_prev_vec_next_AZ_dqdPE4 = (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE4 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE4 : dfdqd_prev_vec_reg_AZ_dqdPE4;
   assign dfdqd_prev_vec_next_LX_dqdPE4 = (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE4 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE4 : dfdqd_prev_vec_reg_LX_dqdPE4;
   assign dfdqd_prev_vec_next_LY_dqdPE4 = (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE4 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE4 : dfdqd_prev_vec_reg_LY_dqdPE4;
   assign dfdqd_prev_vec_next_LZ_dqdPE4 = (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE4 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE4 : dfdqd_prev_vec_reg_LZ_dqdPE4;
   // f updated curr
   assign dfdqd_upd_curr_vec_next_AX_dqdPE4 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE4 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE4 : dfdqd_upd_curr_vec_reg_AX_dqdPE4;
   assign dfdqd_upd_curr_vec_next_AY_dqdPE4 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE4 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE4 : dfdqd_upd_curr_vec_reg_AY_dqdPE4;
   assign dfdqd_upd_curr_vec_next_AZ_dqdPE4 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE4 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE4 : dfdqd_upd_curr_vec_reg_AZ_dqdPE4;
   assign dfdqd_upd_curr_vec_next_LX_dqdPE4 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE4 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE4 : dfdqd_upd_curr_vec_reg_LX_dqdPE4;
   assign dfdqd_upd_curr_vec_next_LY_dqdPE4 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE4 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE4 : dfdqd_upd_curr_vec_reg_LY_dqdPE4;
   assign dfdqd_upd_curr_vec_next_LZ_dqdPE4 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE4 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE4 : dfdqd_upd_curr_vec_reg_LZ_dqdPE4;
   // dqdPE5
   assign link_next_dqdPE5 = (get_data == 1) ? link_in_dqdPE5 :
                             (get_data == 1) ? link_in_dqdPE5 : link_reg_dqdPE5;
   assign derv_next_dqdPE5 = (get_data == 1) ? derv_in_dqdPE5 :
                             (get_data == 1) ? derv_in_dqdPE5 : derv_reg_dqdPE5;
   assign sinq_val_next_dqdPE5 = (get_data == 1) ? sinq_val_in_dqdPE5 :
                                 (get_data == 1) ? sinq_val_in_dqdPE5 : sinq_val_reg_dqdPE5;
   assign cosq_val_next_dqdPE5 = (get_data == 1) ? cosq_val_in_dqdPE5 :
                                 (get_data == 1) ? cosq_val_in_dqdPE5 : cosq_val_reg_dqdPE5;
   // df prev
   assign dfdqd_prev_vec_next_AX_dqdPE5 = (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE5 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE5 : dfdqd_prev_vec_reg_AX_dqdPE5;
   assign dfdqd_prev_vec_next_AY_dqdPE5 = (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE5 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE5 : dfdqd_prev_vec_reg_AY_dqdPE5;
   assign dfdqd_prev_vec_next_AZ_dqdPE5 = (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE5 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE5 : dfdqd_prev_vec_reg_AZ_dqdPE5;
   assign dfdqd_prev_vec_next_LX_dqdPE5 = (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE5 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE5 : dfdqd_prev_vec_reg_LX_dqdPE5;
   assign dfdqd_prev_vec_next_LY_dqdPE5 = (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE5 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE5 : dfdqd_prev_vec_reg_LY_dqdPE5;
   assign dfdqd_prev_vec_next_LZ_dqdPE5 = (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE5 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE5 : dfdqd_prev_vec_reg_LZ_dqdPE5;
   // f updated curr
   assign dfdqd_upd_curr_vec_next_AX_dqdPE5 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE5 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE5 : dfdqd_upd_curr_vec_reg_AX_dqdPE5;
   assign dfdqd_upd_curr_vec_next_AY_dqdPE5 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE5 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE5 : dfdqd_upd_curr_vec_reg_AY_dqdPE5;
   assign dfdqd_upd_curr_vec_next_AZ_dqdPE5 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE5 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE5 : dfdqd_upd_curr_vec_reg_AZ_dqdPE5;
   assign dfdqd_upd_curr_vec_next_LX_dqdPE5 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE5 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE5 : dfdqd_upd_curr_vec_reg_LX_dqdPE5;
   assign dfdqd_upd_curr_vec_next_LY_dqdPE5 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE5 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE5 : dfdqd_upd_curr_vec_reg_LY_dqdPE5;
   assign dfdqd_upd_curr_vec_next_LZ_dqdPE5 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE5 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE5 : dfdqd_upd_curr_vec_reg_LZ_dqdPE5;
   // dqdPE6
   assign link_next_dqdPE6 = (get_data == 1) ? link_in_dqdPE6 :
                             (get_data == 1) ? link_in_dqdPE6 : link_reg_dqdPE6;
   assign derv_next_dqdPE6 = (get_data == 1) ? derv_in_dqdPE6 :
                             (get_data == 1) ? derv_in_dqdPE6 : derv_reg_dqdPE6;
   assign sinq_val_next_dqdPE6 = (get_data == 1) ? sinq_val_in_dqdPE6 :
                                 (get_data == 1) ? sinq_val_in_dqdPE6 : sinq_val_reg_dqdPE6;
   assign cosq_val_next_dqdPE6 = (get_data == 1) ? cosq_val_in_dqdPE6 :
                                 (get_data == 1) ? cosq_val_in_dqdPE6 : cosq_val_reg_dqdPE6;
   // df prev
   assign dfdqd_prev_vec_next_AX_dqdPE6 = (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE6 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE6 : dfdqd_prev_vec_reg_AX_dqdPE6;
   assign dfdqd_prev_vec_next_AY_dqdPE6 = (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE6 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE6 : dfdqd_prev_vec_reg_AY_dqdPE6;
   assign dfdqd_prev_vec_next_AZ_dqdPE6 = (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE6 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE6 : dfdqd_prev_vec_reg_AZ_dqdPE6;
   assign dfdqd_prev_vec_next_LX_dqdPE6 = (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE6 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE6 : dfdqd_prev_vec_reg_LX_dqdPE6;
   assign dfdqd_prev_vec_next_LY_dqdPE6 = (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE6 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE6 : dfdqd_prev_vec_reg_LY_dqdPE6;
   assign dfdqd_prev_vec_next_LZ_dqdPE6 = (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE6 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE6 : dfdqd_prev_vec_reg_LZ_dqdPE6;
   // f updated curr
   assign dfdqd_upd_curr_vec_next_AX_dqdPE6 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE6 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE6 : dfdqd_upd_curr_vec_reg_AX_dqdPE6;
   assign dfdqd_upd_curr_vec_next_AY_dqdPE6 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE6 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE6 : dfdqd_upd_curr_vec_reg_AY_dqdPE6;
   assign dfdqd_upd_curr_vec_next_AZ_dqdPE6 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE6 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE6 : dfdqd_upd_curr_vec_reg_AZ_dqdPE6;
   assign dfdqd_upd_curr_vec_next_LX_dqdPE6 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE6 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE6 : dfdqd_upd_curr_vec_reg_LX_dqdPE6;
   assign dfdqd_upd_curr_vec_next_LY_dqdPE6 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE6 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE6 : dfdqd_upd_curr_vec_reg_LY_dqdPE6;
   assign dfdqd_upd_curr_vec_next_LZ_dqdPE6 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE6 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE6 : dfdqd_upd_curr_vec_reg_LZ_dqdPE6;
   // dqdPE7
   assign link_next_dqdPE7 = (get_data == 1) ? link_in_dqdPE7 :
                             (get_data == 1) ? link_in_dqdPE7 : link_reg_dqdPE7;
   assign derv_next_dqdPE7 = (get_data == 1) ? derv_in_dqdPE7 :
                             (get_data == 1) ? derv_in_dqdPE7 : derv_reg_dqdPE7;
   assign sinq_val_next_dqdPE7 = (get_data == 1) ? sinq_val_in_dqdPE7 :
                                 (get_data == 1) ? sinq_val_in_dqdPE7 : sinq_val_reg_dqdPE7;
   assign cosq_val_next_dqdPE7 = (get_data == 1) ? cosq_val_in_dqdPE7 :
                                 (get_data == 1) ? cosq_val_in_dqdPE7 : cosq_val_reg_dqdPE7;
   // df prev
   assign dfdqd_prev_vec_next_AX_dqdPE7 = (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE7 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AX_dqdPE7 : dfdqd_prev_vec_reg_AX_dqdPE7;
   assign dfdqd_prev_vec_next_AY_dqdPE7 = (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE7 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AY_dqdPE7 : dfdqd_prev_vec_reg_AY_dqdPE7;
   assign dfdqd_prev_vec_next_AZ_dqdPE7 = (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE7 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_AZ_dqdPE7 : dfdqd_prev_vec_reg_AZ_dqdPE7;
   assign dfdqd_prev_vec_next_LX_dqdPE7 = (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE7 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LX_dqdPE7 : dfdqd_prev_vec_reg_LX_dqdPE7;
   assign dfdqd_prev_vec_next_LY_dqdPE7 = (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE7 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LY_dqdPE7 : dfdqd_prev_vec_reg_LY_dqdPE7;
   assign dfdqd_prev_vec_next_LZ_dqdPE7 = (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE7 :
                                          (get_data == 1) ? dfdqd_prev_vec_in_LZ_dqdPE7 : dfdqd_prev_vec_reg_LZ_dqdPE7;
   // f updated curr
   assign dfdqd_upd_curr_vec_next_AX_dqdPE7 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE7 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AX_dqdPE7 : dfdqd_upd_curr_vec_reg_AX_dqdPE7;
   assign dfdqd_upd_curr_vec_next_AY_dqdPE7 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE7 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AY_dqdPE7 : dfdqd_upd_curr_vec_reg_AY_dqdPE7;
   assign dfdqd_upd_curr_vec_next_AZ_dqdPE7 = (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE7 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_AZ_dqdPE7 : dfdqd_upd_curr_vec_reg_AZ_dqdPE7;
   assign dfdqd_upd_curr_vec_next_LX_dqdPE7 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE7 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LX_dqdPE7 : dfdqd_upd_curr_vec_reg_LX_dqdPE7;
   assign dfdqd_upd_curr_vec_next_LY_dqdPE7 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE7 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LY_dqdPE7 : dfdqd_upd_curr_vec_reg_LY_dqdPE7;
   assign dfdqd_upd_curr_vec_next_LZ_dqdPE7 = (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE7 :
                                              (get_data == 1) ? dfdqd_upd_curr_vec_in_LZ_dqdPE7 : dfdqd_upd_curr_vec_reg_LZ_dqdPE7;
   //---------------------------------------------------------------------------
   // minv external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   assign minv_block_next_R7_C1_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R7_C1_dqdPE1 : minv_block_reg_R7_C1_dqdPE1;
   assign minv_block_next_R7_C2_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R7_C2_dqdPE1 : minv_block_reg_R7_C2_dqdPE1;
   assign minv_block_next_R7_C3_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R7_C3_dqdPE1 : minv_block_reg_R7_C3_dqdPE1;
   assign minv_block_next_R7_C4_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R7_C4_dqdPE1 : minv_block_reg_R7_C4_dqdPE1;
   assign minv_block_next_R7_C5_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R7_C5_dqdPE1 : minv_block_reg_R7_C5_dqdPE1;
   assign minv_block_next_R7_C6_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R7_C6_dqdPE1 : minv_block_reg_R7_C6_dqdPE1;
   assign minv_block_next_R7_C7_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R7_C7_dqdPE1 : minv_block_reg_R7_C7_dqdPE1;
   assign minv_block_next_R6_C1_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R6_C1_dqdPE1 : minv_block_reg_R6_C1_dqdPE1;
   assign minv_block_next_R6_C2_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R6_C2_dqdPE1 : minv_block_reg_R6_C2_dqdPE1;
   assign minv_block_next_R6_C3_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R6_C3_dqdPE1 : minv_block_reg_R6_C3_dqdPE1;
   assign minv_block_next_R6_C4_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R6_C4_dqdPE1 : minv_block_reg_R6_C4_dqdPE1;
   assign minv_block_next_R6_C5_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R6_C5_dqdPE1 : minv_block_reg_R6_C5_dqdPE1;
   assign minv_block_next_R6_C6_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R6_C6_dqdPE1 : minv_block_reg_R6_C6_dqdPE1;
   assign minv_block_next_R6_C7_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R6_C7_dqdPE1 : minv_block_reg_R6_C7_dqdPE1;
   assign minv_block_next_R5_C1_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R5_C1_dqdPE1 : minv_block_reg_R5_C1_dqdPE1;
   assign minv_block_next_R5_C2_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R5_C2_dqdPE1 : minv_block_reg_R5_C2_dqdPE1;
   assign minv_block_next_R5_C3_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R5_C3_dqdPE1 : minv_block_reg_R5_C3_dqdPE1;
   assign minv_block_next_R5_C4_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R5_C4_dqdPE1 : minv_block_reg_R5_C4_dqdPE1;
   assign minv_block_next_R5_C5_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R5_C5_dqdPE1 : minv_block_reg_R5_C5_dqdPE1;
   assign minv_block_next_R5_C6_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R5_C6_dqdPE1 : minv_block_reg_R5_C6_dqdPE1;
   assign minv_block_next_R5_C7_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R5_C7_dqdPE1 : minv_block_reg_R5_C7_dqdPE1;
   assign minv_block_next_R4_C1_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R4_C1_dqdPE1 : minv_block_reg_R4_C1_dqdPE1;
   assign minv_block_next_R4_C2_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R4_C2_dqdPE1 : minv_block_reg_R4_C2_dqdPE1;
   assign minv_block_next_R4_C3_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R4_C3_dqdPE1 : minv_block_reg_R4_C3_dqdPE1;
   assign minv_block_next_R4_C4_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R4_C4_dqdPE1 : minv_block_reg_R4_C4_dqdPE1;
   assign minv_block_next_R4_C5_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R4_C5_dqdPE1 : minv_block_reg_R4_C5_dqdPE1;
   assign minv_block_next_R4_C6_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R4_C6_dqdPE1 : minv_block_reg_R4_C6_dqdPE1;
   assign minv_block_next_R4_C7_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R4_C7_dqdPE1 : minv_block_reg_R4_C7_dqdPE1;
   assign minv_block_next_R3_C1_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R3_C1_dqdPE1 : minv_block_reg_R3_C1_dqdPE1;
   assign minv_block_next_R3_C2_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R3_C2_dqdPE1 : minv_block_reg_R3_C2_dqdPE1;
   assign minv_block_next_R3_C3_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R3_C3_dqdPE1 : minv_block_reg_R3_C3_dqdPE1;
   assign minv_block_next_R3_C4_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R3_C4_dqdPE1 : minv_block_reg_R3_C4_dqdPE1;
   assign minv_block_next_R3_C5_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R3_C5_dqdPE1 : minv_block_reg_R3_C5_dqdPE1;
   assign minv_block_next_R3_C6_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R3_C6_dqdPE1 : minv_block_reg_R3_C6_dqdPE1;
   assign minv_block_next_R3_C7_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R3_C7_dqdPE1 : minv_block_reg_R3_C7_dqdPE1;
   assign minv_block_next_R2_C1_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R2_C1_dqdPE1 : minv_block_reg_R2_C1_dqdPE1;
   assign minv_block_next_R2_C2_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R2_C2_dqdPE1 : minv_block_reg_R2_C2_dqdPE1;
   assign minv_block_next_R2_C3_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R2_C3_dqdPE1 : minv_block_reg_R2_C3_dqdPE1;
   assign minv_block_next_R2_C4_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R2_C4_dqdPE1 : minv_block_reg_R2_C4_dqdPE1;
   assign minv_block_next_R2_C5_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R2_C5_dqdPE1 : minv_block_reg_R2_C5_dqdPE1;
   assign minv_block_next_R2_C6_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R2_C6_dqdPE1 : minv_block_reg_R2_C6_dqdPE1;
   assign minv_block_next_R2_C7_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R2_C7_dqdPE1 : minv_block_reg_R2_C7_dqdPE1;
   assign minv_block_next_R1_C1_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R1_C1_dqdPE1 : minv_block_reg_R1_C1_dqdPE1;
   assign minv_block_next_R1_C2_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R1_C2_dqdPE1 : minv_block_reg_R1_C2_dqdPE1;
   assign minv_block_next_R1_C3_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R1_C3_dqdPE1 : minv_block_reg_R1_C3_dqdPE1;
   assign minv_block_next_R1_C4_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R1_C4_dqdPE1 : minv_block_reg_R1_C4_dqdPE1;
   assign minv_block_next_R1_C5_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R1_C5_dqdPE1 : minv_block_reg_R1_C5_dqdPE1;
   assign minv_block_next_R1_C6_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R1_C6_dqdPE1 : minv_block_reg_R1_C6_dqdPE1;
   assign minv_block_next_R1_C7_dqdPE1 = (get_data_minv == 1) ? minv_block_in_R1_C7_dqdPE1 : minv_block_reg_R1_C7_dqdPE1;
   assign dtau_vec_next_R1_dqdPE1 = (get_data_minv == 1) ? dtau_vec_in_R1_dqdPE1 : dtau_vec_reg_R1_dqdPE1;
   assign dtau_vec_next_R2_dqdPE1 = (get_data_minv == 1) ? dtau_vec_in_R2_dqdPE1 : dtau_vec_reg_R2_dqdPE1;
   assign dtau_vec_next_R3_dqdPE1 = (get_data_minv == 1) ? dtau_vec_in_R3_dqdPE1 : dtau_vec_reg_R3_dqdPE1;
   assign dtau_vec_next_R4_dqdPE1 = (get_data_minv == 1) ? dtau_vec_in_R4_dqdPE1 : dtau_vec_reg_R4_dqdPE1;
   assign dtau_vec_next_R5_dqdPE1 = (get_data_minv == 1) ? dtau_vec_in_R5_dqdPE1 : dtau_vec_reg_R5_dqdPE1;
   assign dtau_vec_next_R6_dqdPE1 = (get_data_minv == 1) ? dtau_vec_in_R6_dqdPE1 : dtau_vec_reg_R6_dqdPE1;
   assign dtau_vec_next_R7_dqdPE1 = (get_data_minv == 1) ? dtau_vec_in_R7_dqdPE1 : dtau_vec_reg_R7_dqdPE1;
   // dqdPE2
   assign minv_block_next_R7_C1_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R7_C1_dqdPE2 : minv_block_reg_R7_C1_dqdPE2;
   assign minv_block_next_R7_C2_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R7_C2_dqdPE2 : minv_block_reg_R7_C2_dqdPE2;
   assign minv_block_next_R7_C3_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R7_C3_dqdPE2 : minv_block_reg_R7_C3_dqdPE2;
   assign minv_block_next_R7_C4_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R7_C4_dqdPE2 : minv_block_reg_R7_C4_dqdPE2;
   assign minv_block_next_R7_C5_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R7_C5_dqdPE2 : minv_block_reg_R7_C5_dqdPE2;
   assign minv_block_next_R7_C6_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R7_C6_dqdPE2 : minv_block_reg_R7_C6_dqdPE2;
   assign minv_block_next_R7_C7_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R7_C7_dqdPE2 : minv_block_reg_R7_C7_dqdPE2;
   assign minv_block_next_R6_C1_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R6_C1_dqdPE2 : minv_block_reg_R6_C1_dqdPE2;
   assign minv_block_next_R6_C2_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R6_C2_dqdPE2 : minv_block_reg_R6_C2_dqdPE2;
   assign minv_block_next_R6_C3_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R6_C3_dqdPE2 : minv_block_reg_R6_C3_dqdPE2;
   assign minv_block_next_R6_C4_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R6_C4_dqdPE2 : minv_block_reg_R6_C4_dqdPE2;
   assign minv_block_next_R6_C5_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R6_C5_dqdPE2 : minv_block_reg_R6_C5_dqdPE2;
   assign minv_block_next_R6_C6_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R6_C6_dqdPE2 : minv_block_reg_R6_C6_dqdPE2;
   assign minv_block_next_R6_C7_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R6_C7_dqdPE2 : minv_block_reg_R6_C7_dqdPE2;
   assign minv_block_next_R5_C1_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R5_C1_dqdPE2 : minv_block_reg_R5_C1_dqdPE2;
   assign minv_block_next_R5_C2_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R5_C2_dqdPE2 : minv_block_reg_R5_C2_dqdPE2;
   assign minv_block_next_R5_C3_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R5_C3_dqdPE2 : minv_block_reg_R5_C3_dqdPE2;
   assign minv_block_next_R5_C4_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R5_C4_dqdPE2 : minv_block_reg_R5_C4_dqdPE2;
   assign minv_block_next_R5_C5_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R5_C5_dqdPE2 : minv_block_reg_R5_C5_dqdPE2;
   assign minv_block_next_R5_C6_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R5_C6_dqdPE2 : minv_block_reg_R5_C6_dqdPE2;
   assign minv_block_next_R5_C7_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R5_C7_dqdPE2 : minv_block_reg_R5_C7_dqdPE2;
   assign minv_block_next_R4_C1_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R4_C1_dqdPE2 : minv_block_reg_R4_C1_dqdPE2;
   assign minv_block_next_R4_C2_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R4_C2_dqdPE2 : minv_block_reg_R4_C2_dqdPE2;
   assign minv_block_next_R4_C3_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R4_C3_dqdPE2 : minv_block_reg_R4_C3_dqdPE2;
   assign minv_block_next_R4_C4_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R4_C4_dqdPE2 : minv_block_reg_R4_C4_dqdPE2;
   assign minv_block_next_R4_C5_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R4_C5_dqdPE2 : minv_block_reg_R4_C5_dqdPE2;
   assign minv_block_next_R4_C6_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R4_C6_dqdPE2 : minv_block_reg_R4_C6_dqdPE2;
   assign minv_block_next_R4_C7_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R4_C7_dqdPE2 : minv_block_reg_R4_C7_dqdPE2;
   assign minv_block_next_R3_C1_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R3_C1_dqdPE2 : minv_block_reg_R3_C1_dqdPE2;
   assign minv_block_next_R3_C2_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R3_C2_dqdPE2 : minv_block_reg_R3_C2_dqdPE2;
   assign minv_block_next_R3_C3_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R3_C3_dqdPE2 : minv_block_reg_R3_C3_dqdPE2;
   assign minv_block_next_R3_C4_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R3_C4_dqdPE2 : minv_block_reg_R3_C4_dqdPE2;
   assign minv_block_next_R3_C5_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R3_C5_dqdPE2 : minv_block_reg_R3_C5_dqdPE2;
   assign minv_block_next_R3_C6_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R3_C6_dqdPE2 : minv_block_reg_R3_C6_dqdPE2;
   assign minv_block_next_R3_C7_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R3_C7_dqdPE2 : minv_block_reg_R3_C7_dqdPE2;
   assign minv_block_next_R2_C1_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R2_C1_dqdPE2 : minv_block_reg_R2_C1_dqdPE2;
   assign minv_block_next_R2_C2_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R2_C2_dqdPE2 : minv_block_reg_R2_C2_dqdPE2;
   assign minv_block_next_R2_C3_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R2_C3_dqdPE2 : minv_block_reg_R2_C3_dqdPE2;
   assign minv_block_next_R2_C4_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R2_C4_dqdPE2 : minv_block_reg_R2_C4_dqdPE2;
   assign minv_block_next_R2_C5_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R2_C5_dqdPE2 : minv_block_reg_R2_C5_dqdPE2;
   assign minv_block_next_R2_C6_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R2_C6_dqdPE2 : minv_block_reg_R2_C6_dqdPE2;
   assign minv_block_next_R2_C7_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R2_C7_dqdPE2 : minv_block_reg_R2_C7_dqdPE2;
   assign minv_block_next_R1_C1_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R1_C1_dqdPE2 : minv_block_reg_R1_C1_dqdPE2;
   assign minv_block_next_R1_C2_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R1_C2_dqdPE2 : minv_block_reg_R1_C2_dqdPE2;
   assign minv_block_next_R1_C3_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R1_C3_dqdPE2 : minv_block_reg_R1_C3_dqdPE2;
   assign minv_block_next_R1_C4_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R1_C4_dqdPE2 : minv_block_reg_R1_C4_dqdPE2;
   assign minv_block_next_R1_C5_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R1_C5_dqdPE2 : minv_block_reg_R1_C5_dqdPE2;
   assign minv_block_next_R1_C6_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R1_C6_dqdPE2 : minv_block_reg_R1_C6_dqdPE2;
   assign minv_block_next_R1_C7_dqdPE2 = (get_data_minv == 1) ? minv_block_in_R1_C7_dqdPE2 : minv_block_reg_R1_C7_dqdPE2;
   assign dtau_vec_next_R1_dqdPE2 = (get_data_minv == 1) ? dtau_vec_in_R1_dqdPE2 : dtau_vec_reg_R1_dqdPE2;
   assign dtau_vec_next_R2_dqdPE2 = (get_data_minv == 1) ? dtau_vec_in_R2_dqdPE2 : dtau_vec_reg_R2_dqdPE2;
   assign dtau_vec_next_R3_dqdPE2 = (get_data_minv == 1) ? dtau_vec_in_R3_dqdPE2 : dtau_vec_reg_R3_dqdPE2;
   assign dtau_vec_next_R4_dqdPE2 = (get_data_minv == 1) ? dtau_vec_in_R4_dqdPE2 : dtau_vec_reg_R4_dqdPE2;
   assign dtau_vec_next_R5_dqdPE2 = (get_data_minv == 1) ? dtau_vec_in_R5_dqdPE2 : dtau_vec_reg_R5_dqdPE2;
   assign dtau_vec_next_R6_dqdPE2 = (get_data_minv == 1) ? dtau_vec_in_R6_dqdPE2 : dtau_vec_reg_R6_dqdPE2;
   assign dtau_vec_next_R7_dqdPE2 = (get_data_minv == 1) ? dtau_vec_in_R7_dqdPE2 : dtau_vec_reg_R7_dqdPE2;
   // dqdPE3
   assign minv_block_next_R7_C1_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R7_C1_dqdPE3 : minv_block_reg_R7_C1_dqdPE3;
   assign minv_block_next_R7_C2_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R7_C2_dqdPE3 : minv_block_reg_R7_C2_dqdPE3;
   assign minv_block_next_R7_C3_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R7_C3_dqdPE3 : minv_block_reg_R7_C3_dqdPE3;
   assign minv_block_next_R7_C4_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R7_C4_dqdPE3 : minv_block_reg_R7_C4_dqdPE3;
   assign minv_block_next_R7_C5_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R7_C5_dqdPE3 : minv_block_reg_R7_C5_dqdPE3;
   assign minv_block_next_R7_C6_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R7_C6_dqdPE3 : minv_block_reg_R7_C6_dqdPE3;
   assign minv_block_next_R7_C7_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R7_C7_dqdPE3 : minv_block_reg_R7_C7_dqdPE3;
   assign minv_block_next_R6_C1_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R6_C1_dqdPE3 : minv_block_reg_R6_C1_dqdPE3;
   assign minv_block_next_R6_C2_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R6_C2_dqdPE3 : minv_block_reg_R6_C2_dqdPE3;
   assign minv_block_next_R6_C3_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R6_C3_dqdPE3 : minv_block_reg_R6_C3_dqdPE3;
   assign minv_block_next_R6_C4_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R6_C4_dqdPE3 : minv_block_reg_R6_C4_dqdPE3;
   assign minv_block_next_R6_C5_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R6_C5_dqdPE3 : minv_block_reg_R6_C5_dqdPE3;
   assign minv_block_next_R6_C6_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R6_C6_dqdPE3 : minv_block_reg_R6_C6_dqdPE3;
   assign minv_block_next_R6_C7_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R6_C7_dqdPE3 : minv_block_reg_R6_C7_dqdPE3;
   assign minv_block_next_R5_C1_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R5_C1_dqdPE3 : minv_block_reg_R5_C1_dqdPE3;
   assign minv_block_next_R5_C2_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R5_C2_dqdPE3 : minv_block_reg_R5_C2_dqdPE3;
   assign minv_block_next_R5_C3_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R5_C3_dqdPE3 : minv_block_reg_R5_C3_dqdPE3;
   assign minv_block_next_R5_C4_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R5_C4_dqdPE3 : minv_block_reg_R5_C4_dqdPE3;
   assign minv_block_next_R5_C5_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R5_C5_dqdPE3 : minv_block_reg_R5_C5_dqdPE3;
   assign minv_block_next_R5_C6_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R5_C6_dqdPE3 : minv_block_reg_R5_C6_dqdPE3;
   assign minv_block_next_R5_C7_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R5_C7_dqdPE3 : minv_block_reg_R5_C7_dqdPE3;
   assign minv_block_next_R4_C1_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R4_C1_dqdPE3 : minv_block_reg_R4_C1_dqdPE3;
   assign minv_block_next_R4_C2_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R4_C2_dqdPE3 : minv_block_reg_R4_C2_dqdPE3;
   assign minv_block_next_R4_C3_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R4_C3_dqdPE3 : minv_block_reg_R4_C3_dqdPE3;
   assign minv_block_next_R4_C4_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R4_C4_dqdPE3 : minv_block_reg_R4_C4_dqdPE3;
   assign minv_block_next_R4_C5_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R4_C5_dqdPE3 : minv_block_reg_R4_C5_dqdPE3;
   assign minv_block_next_R4_C6_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R4_C6_dqdPE3 : minv_block_reg_R4_C6_dqdPE3;
   assign minv_block_next_R4_C7_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R4_C7_dqdPE3 : minv_block_reg_R4_C7_dqdPE3;
   assign minv_block_next_R3_C1_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R3_C1_dqdPE3 : minv_block_reg_R3_C1_dqdPE3;
   assign minv_block_next_R3_C2_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R3_C2_dqdPE3 : minv_block_reg_R3_C2_dqdPE3;
   assign minv_block_next_R3_C3_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R3_C3_dqdPE3 : minv_block_reg_R3_C3_dqdPE3;
   assign minv_block_next_R3_C4_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R3_C4_dqdPE3 : minv_block_reg_R3_C4_dqdPE3;
   assign minv_block_next_R3_C5_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R3_C5_dqdPE3 : minv_block_reg_R3_C5_dqdPE3;
   assign minv_block_next_R3_C6_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R3_C6_dqdPE3 : minv_block_reg_R3_C6_dqdPE3;
   assign minv_block_next_R3_C7_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R3_C7_dqdPE3 : minv_block_reg_R3_C7_dqdPE3;
   assign minv_block_next_R2_C1_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R2_C1_dqdPE3 : minv_block_reg_R2_C1_dqdPE3;
   assign minv_block_next_R2_C2_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R2_C2_dqdPE3 : minv_block_reg_R2_C2_dqdPE3;
   assign minv_block_next_R2_C3_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R2_C3_dqdPE3 : minv_block_reg_R2_C3_dqdPE3;
   assign minv_block_next_R2_C4_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R2_C4_dqdPE3 : minv_block_reg_R2_C4_dqdPE3;
   assign minv_block_next_R2_C5_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R2_C5_dqdPE3 : minv_block_reg_R2_C5_dqdPE3;
   assign minv_block_next_R2_C6_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R2_C6_dqdPE3 : minv_block_reg_R2_C6_dqdPE3;
   assign minv_block_next_R2_C7_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R2_C7_dqdPE3 : minv_block_reg_R2_C7_dqdPE3;
   assign minv_block_next_R1_C1_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R1_C1_dqdPE3 : minv_block_reg_R1_C1_dqdPE3;
   assign minv_block_next_R1_C2_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R1_C2_dqdPE3 : minv_block_reg_R1_C2_dqdPE3;
   assign minv_block_next_R1_C3_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R1_C3_dqdPE3 : minv_block_reg_R1_C3_dqdPE3;
   assign minv_block_next_R1_C4_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R1_C4_dqdPE3 : minv_block_reg_R1_C4_dqdPE3;
   assign minv_block_next_R1_C5_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R1_C5_dqdPE3 : minv_block_reg_R1_C5_dqdPE3;
   assign minv_block_next_R1_C6_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R1_C6_dqdPE3 : minv_block_reg_R1_C6_dqdPE3;
   assign minv_block_next_R1_C7_dqdPE3 = (get_data_minv == 1) ? minv_block_in_R1_C7_dqdPE3 : minv_block_reg_R1_C7_dqdPE3;
   assign dtau_vec_next_R1_dqdPE3 = (get_data_minv == 1) ? dtau_vec_in_R1_dqdPE3 : dtau_vec_reg_R1_dqdPE3;
   assign dtau_vec_next_R2_dqdPE3 = (get_data_minv == 1) ? dtau_vec_in_R2_dqdPE3 : dtau_vec_reg_R2_dqdPE3;
   assign dtau_vec_next_R3_dqdPE3 = (get_data_minv == 1) ? dtau_vec_in_R3_dqdPE3 : dtau_vec_reg_R3_dqdPE3;
   assign dtau_vec_next_R4_dqdPE3 = (get_data_minv == 1) ? dtau_vec_in_R4_dqdPE3 : dtau_vec_reg_R4_dqdPE3;
   assign dtau_vec_next_R5_dqdPE3 = (get_data_minv == 1) ? dtau_vec_in_R5_dqdPE3 : dtau_vec_reg_R5_dqdPE3;
   assign dtau_vec_next_R6_dqdPE3 = (get_data_minv == 1) ? dtau_vec_in_R6_dqdPE3 : dtau_vec_reg_R6_dqdPE3;
   assign dtau_vec_next_R7_dqdPE3 = (get_data_minv == 1) ? dtau_vec_in_R7_dqdPE3 : dtau_vec_reg_R7_dqdPE3;
   // dqdPE4
   assign minv_block_next_R7_C1_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R7_C1_dqdPE4 : minv_block_reg_R7_C1_dqdPE4;
   assign minv_block_next_R7_C2_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R7_C2_dqdPE4 : minv_block_reg_R7_C2_dqdPE4;
   assign minv_block_next_R7_C3_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R7_C3_dqdPE4 : minv_block_reg_R7_C3_dqdPE4;
   assign minv_block_next_R7_C4_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R7_C4_dqdPE4 : minv_block_reg_R7_C4_dqdPE4;
   assign minv_block_next_R7_C5_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R7_C5_dqdPE4 : minv_block_reg_R7_C5_dqdPE4;
   assign minv_block_next_R7_C6_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R7_C6_dqdPE4 : minv_block_reg_R7_C6_dqdPE4;
   assign minv_block_next_R7_C7_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R7_C7_dqdPE4 : minv_block_reg_R7_C7_dqdPE4;
   assign minv_block_next_R6_C1_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R6_C1_dqdPE4 : minv_block_reg_R6_C1_dqdPE4;
   assign minv_block_next_R6_C2_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R6_C2_dqdPE4 : minv_block_reg_R6_C2_dqdPE4;
   assign minv_block_next_R6_C3_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R6_C3_dqdPE4 : minv_block_reg_R6_C3_dqdPE4;
   assign minv_block_next_R6_C4_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R6_C4_dqdPE4 : minv_block_reg_R6_C4_dqdPE4;
   assign minv_block_next_R6_C5_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R6_C5_dqdPE4 : minv_block_reg_R6_C5_dqdPE4;
   assign minv_block_next_R6_C6_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R6_C6_dqdPE4 : minv_block_reg_R6_C6_dqdPE4;
   assign minv_block_next_R6_C7_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R6_C7_dqdPE4 : minv_block_reg_R6_C7_dqdPE4;
   assign minv_block_next_R5_C1_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R5_C1_dqdPE4 : minv_block_reg_R5_C1_dqdPE4;
   assign minv_block_next_R5_C2_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R5_C2_dqdPE4 : minv_block_reg_R5_C2_dqdPE4;
   assign minv_block_next_R5_C3_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R5_C3_dqdPE4 : minv_block_reg_R5_C3_dqdPE4;
   assign minv_block_next_R5_C4_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R5_C4_dqdPE4 : minv_block_reg_R5_C4_dqdPE4;
   assign minv_block_next_R5_C5_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R5_C5_dqdPE4 : minv_block_reg_R5_C5_dqdPE4;
   assign minv_block_next_R5_C6_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R5_C6_dqdPE4 : minv_block_reg_R5_C6_dqdPE4;
   assign minv_block_next_R5_C7_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R5_C7_dqdPE4 : minv_block_reg_R5_C7_dqdPE4;
   assign minv_block_next_R4_C1_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R4_C1_dqdPE4 : minv_block_reg_R4_C1_dqdPE4;
   assign minv_block_next_R4_C2_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R4_C2_dqdPE4 : minv_block_reg_R4_C2_dqdPE4;
   assign minv_block_next_R4_C3_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R4_C3_dqdPE4 : minv_block_reg_R4_C3_dqdPE4;
   assign minv_block_next_R4_C4_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R4_C4_dqdPE4 : minv_block_reg_R4_C4_dqdPE4;
   assign minv_block_next_R4_C5_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R4_C5_dqdPE4 : minv_block_reg_R4_C5_dqdPE4;
   assign minv_block_next_R4_C6_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R4_C6_dqdPE4 : minv_block_reg_R4_C6_dqdPE4;
   assign minv_block_next_R4_C7_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R4_C7_dqdPE4 : minv_block_reg_R4_C7_dqdPE4;
   assign minv_block_next_R3_C1_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R3_C1_dqdPE4 : minv_block_reg_R3_C1_dqdPE4;
   assign minv_block_next_R3_C2_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R3_C2_dqdPE4 : minv_block_reg_R3_C2_dqdPE4;
   assign minv_block_next_R3_C3_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R3_C3_dqdPE4 : minv_block_reg_R3_C3_dqdPE4;
   assign minv_block_next_R3_C4_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R3_C4_dqdPE4 : minv_block_reg_R3_C4_dqdPE4;
   assign minv_block_next_R3_C5_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R3_C5_dqdPE4 : minv_block_reg_R3_C5_dqdPE4;
   assign minv_block_next_R3_C6_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R3_C6_dqdPE4 : minv_block_reg_R3_C6_dqdPE4;
   assign minv_block_next_R3_C7_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R3_C7_dqdPE4 : minv_block_reg_R3_C7_dqdPE4;
   assign minv_block_next_R2_C1_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R2_C1_dqdPE4 : minv_block_reg_R2_C1_dqdPE4;
   assign minv_block_next_R2_C2_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R2_C2_dqdPE4 : minv_block_reg_R2_C2_dqdPE4;
   assign minv_block_next_R2_C3_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R2_C3_dqdPE4 : minv_block_reg_R2_C3_dqdPE4;
   assign minv_block_next_R2_C4_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R2_C4_dqdPE4 : minv_block_reg_R2_C4_dqdPE4;
   assign minv_block_next_R2_C5_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R2_C5_dqdPE4 : minv_block_reg_R2_C5_dqdPE4;
   assign minv_block_next_R2_C6_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R2_C6_dqdPE4 : minv_block_reg_R2_C6_dqdPE4;
   assign minv_block_next_R2_C7_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R2_C7_dqdPE4 : minv_block_reg_R2_C7_dqdPE4;
   assign minv_block_next_R1_C1_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R1_C1_dqdPE4 : minv_block_reg_R1_C1_dqdPE4;
   assign minv_block_next_R1_C2_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R1_C2_dqdPE4 : minv_block_reg_R1_C2_dqdPE4;
   assign minv_block_next_R1_C3_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R1_C3_dqdPE4 : minv_block_reg_R1_C3_dqdPE4;
   assign minv_block_next_R1_C4_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R1_C4_dqdPE4 : minv_block_reg_R1_C4_dqdPE4;
   assign minv_block_next_R1_C5_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R1_C5_dqdPE4 : minv_block_reg_R1_C5_dqdPE4;
   assign minv_block_next_R1_C6_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R1_C6_dqdPE4 : minv_block_reg_R1_C6_dqdPE4;
   assign minv_block_next_R1_C7_dqdPE4 = (get_data_minv == 1) ? minv_block_in_R1_C7_dqdPE4 : minv_block_reg_R1_C7_dqdPE4;
   assign dtau_vec_next_R1_dqdPE4 = (get_data_minv == 1) ? dtau_vec_in_R1_dqdPE4 : dtau_vec_reg_R1_dqdPE4;
   assign dtau_vec_next_R2_dqdPE4 = (get_data_minv == 1) ? dtau_vec_in_R2_dqdPE4 : dtau_vec_reg_R2_dqdPE4;
   assign dtau_vec_next_R3_dqdPE4 = (get_data_minv == 1) ? dtau_vec_in_R3_dqdPE4 : dtau_vec_reg_R3_dqdPE4;
   assign dtau_vec_next_R4_dqdPE4 = (get_data_minv == 1) ? dtau_vec_in_R4_dqdPE4 : dtau_vec_reg_R4_dqdPE4;
   assign dtau_vec_next_R5_dqdPE4 = (get_data_minv == 1) ? dtau_vec_in_R5_dqdPE4 : dtau_vec_reg_R5_dqdPE4;
   assign dtau_vec_next_R6_dqdPE4 = (get_data_minv == 1) ? dtau_vec_in_R6_dqdPE4 : dtau_vec_reg_R6_dqdPE4;
   assign dtau_vec_next_R7_dqdPE4 = (get_data_minv == 1) ? dtau_vec_in_R7_dqdPE4 : dtau_vec_reg_R7_dqdPE4;
   // dqdPE5
   assign minv_block_next_R7_C1_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R7_C1_dqdPE5 : minv_block_reg_R7_C1_dqdPE5;
   assign minv_block_next_R7_C2_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R7_C2_dqdPE5 : minv_block_reg_R7_C2_dqdPE5;
   assign minv_block_next_R7_C3_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R7_C3_dqdPE5 : minv_block_reg_R7_C3_dqdPE5;
   assign minv_block_next_R7_C4_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R7_C4_dqdPE5 : minv_block_reg_R7_C4_dqdPE5;
   assign minv_block_next_R7_C5_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R7_C5_dqdPE5 : minv_block_reg_R7_C5_dqdPE5;
   assign minv_block_next_R7_C6_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R7_C6_dqdPE5 : minv_block_reg_R7_C6_dqdPE5;
   assign minv_block_next_R7_C7_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R7_C7_dqdPE5 : minv_block_reg_R7_C7_dqdPE5;
   assign minv_block_next_R6_C1_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R6_C1_dqdPE5 : minv_block_reg_R6_C1_dqdPE5;
   assign minv_block_next_R6_C2_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R6_C2_dqdPE5 : minv_block_reg_R6_C2_dqdPE5;
   assign minv_block_next_R6_C3_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R6_C3_dqdPE5 : minv_block_reg_R6_C3_dqdPE5;
   assign minv_block_next_R6_C4_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R6_C4_dqdPE5 : minv_block_reg_R6_C4_dqdPE5;
   assign minv_block_next_R6_C5_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R6_C5_dqdPE5 : minv_block_reg_R6_C5_dqdPE5;
   assign minv_block_next_R6_C6_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R6_C6_dqdPE5 : minv_block_reg_R6_C6_dqdPE5;
   assign minv_block_next_R6_C7_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R6_C7_dqdPE5 : minv_block_reg_R6_C7_dqdPE5;
   assign minv_block_next_R5_C1_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R5_C1_dqdPE5 : minv_block_reg_R5_C1_dqdPE5;
   assign minv_block_next_R5_C2_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R5_C2_dqdPE5 : minv_block_reg_R5_C2_dqdPE5;
   assign minv_block_next_R5_C3_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R5_C3_dqdPE5 : minv_block_reg_R5_C3_dqdPE5;
   assign minv_block_next_R5_C4_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R5_C4_dqdPE5 : minv_block_reg_R5_C4_dqdPE5;
   assign minv_block_next_R5_C5_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R5_C5_dqdPE5 : minv_block_reg_R5_C5_dqdPE5;
   assign minv_block_next_R5_C6_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R5_C6_dqdPE5 : minv_block_reg_R5_C6_dqdPE5;
   assign minv_block_next_R5_C7_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R5_C7_dqdPE5 : minv_block_reg_R5_C7_dqdPE5;
   assign minv_block_next_R4_C1_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R4_C1_dqdPE5 : minv_block_reg_R4_C1_dqdPE5;
   assign minv_block_next_R4_C2_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R4_C2_dqdPE5 : minv_block_reg_R4_C2_dqdPE5;
   assign minv_block_next_R4_C3_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R4_C3_dqdPE5 : minv_block_reg_R4_C3_dqdPE5;
   assign minv_block_next_R4_C4_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R4_C4_dqdPE5 : minv_block_reg_R4_C4_dqdPE5;
   assign minv_block_next_R4_C5_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R4_C5_dqdPE5 : minv_block_reg_R4_C5_dqdPE5;
   assign minv_block_next_R4_C6_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R4_C6_dqdPE5 : minv_block_reg_R4_C6_dqdPE5;
   assign minv_block_next_R4_C7_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R4_C7_dqdPE5 : minv_block_reg_R4_C7_dqdPE5;
   assign minv_block_next_R3_C1_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R3_C1_dqdPE5 : minv_block_reg_R3_C1_dqdPE5;
   assign minv_block_next_R3_C2_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R3_C2_dqdPE5 : minv_block_reg_R3_C2_dqdPE5;
   assign minv_block_next_R3_C3_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R3_C3_dqdPE5 : minv_block_reg_R3_C3_dqdPE5;
   assign minv_block_next_R3_C4_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R3_C4_dqdPE5 : minv_block_reg_R3_C4_dqdPE5;
   assign minv_block_next_R3_C5_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R3_C5_dqdPE5 : minv_block_reg_R3_C5_dqdPE5;
   assign minv_block_next_R3_C6_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R3_C6_dqdPE5 : minv_block_reg_R3_C6_dqdPE5;
   assign minv_block_next_R3_C7_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R3_C7_dqdPE5 : minv_block_reg_R3_C7_dqdPE5;
   assign minv_block_next_R2_C1_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R2_C1_dqdPE5 : minv_block_reg_R2_C1_dqdPE5;
   assign minv_block_next_R2_C2_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R2_C2_dqdPE5 : minv_block_reg_R2_C2_dqdPE5;
   assign minv_block_next_R2_C3_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R2_C3_dqdPE5 : minv_block_reg_R2_C3_dqdPE5;
   assign minv_block_next_R2_C4_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R2_C4_dqdPE5 : minv_block_reg_R2_C4_dqdPE5;
   assign minv_block_next_R2_C5_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R2_C5_dqdPE5 : minv_block_reg_R2_C5_dqdPE5;
   assign minv_block_next_R2_C6_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R2_C6_dqdPE5 : minv_block_reg_R2_C6_dqdPE5;
   assign minv_block_next_R2_C7_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R2_C7_dqdPE5 : minv_block_reg_R2_C7_dqdPE5;
   assign minv_block_next_R1_C1_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R1_C1_dqdPE5 : minv_block_reg_R1_C1_dqdPE5;
   assign minv_block_next_R1_C2_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R1_C2_dqdPE5 : minv_block_reg_R1_C2_dqdPE5;
   assign minv_block_next_R1_C3_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R1_C3_dqdPE5 : minv_block_reg_R1_C3_dqdPE5;
   assign minv_block_next_R1_C4_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R1_C4_dqdPE5 : minv_block_reg_R1_C4_dqdPE5;
   assign minv_block_next_R1_C5_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R1_C5_dqdPE5 : minv_block_reg_R1_C5_dqdPE5;
   assign minv_block_next_R1_C6_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R1_C6_dqdPE5 : minv_block_reg_R1_C6_dqdPE5;
   assign minv_block_next_R1_C7_dqdPE5 = (get_data_minv == 1) ? minv_block_in_R1_C7_dqdPE5 : minv_block_reg_R1_C7_dqdPE5;
   assign dtau_vec_next_R1_dqdPE5 = (get_data_minv == 1) ? dtau_vec_in_R1_dqdPE5 : dtau_vec_reg_R1_dqdPE5;
   assign dtau_vec_next_R2_dqdPE5 = (get_data_minv == 1) ? dtau_vec_in_R2_dqdPE5 : dtau_vec_reg_R2_dqdPE5;
   assign dtau_vec_next_R3_dqdPE5 = (get_data_minv == 1) ? dtau_vec_in_R3_dqdPE5 : dtau_vec_reg_R3_dqdPE5;
   assign dtau_vec_next_R4_dqdPE5 = (get_data_minv == 1) ? dtau_vec_in_R4_dqdPE5 : dtau_vec_reg_R4_dqdPE5;
   assign dtau_vec_next_R5_dqdPE5 = (get_data_minv == 1) ? dtau_vec_in_R5_dqdPE5 : dtau_vec_reg_R5_dqdPE5;
   assign dtau_vec_next_R6_dqdPE5 = (get_data_minv == 1) ? dtau_vec_in_R6_dqdPE5 : dtau_vec_reg_R6_dqdPE5;
   assign dtau_vec_next_R7_dqdPE5 = (get_data_minv == 1) ? dtau_vec_in_R7_dqdPE5 : dtau_vec_reg_R7_dqdPE5;
   // dqdPE6
   assign minv_block_next_R7_C1_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R7_C1_dqdPE6 : minv_block_reg_R7_C1_dqdPE6;
   assign minv_block_next_R7_C2_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R7_C2_dqdPE6 : minv_block_reg_R7_C2_dqdPE6;
   assign minv_block_next_R7_C3_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R7_C3_dqdPE6 : minv_block_reg_R7_C3_dqdPE6;
   assign minv_block_next_R7_C4_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R7_C4_dqdPE6 : minv_block_reg_R7_C4_dqdPE6;
   assign minv_block_next_R7_C5_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R7_C5_dqdPE6 : minv_block_reg_R7_C5_dqdPE6;
   assign minv_block_next_R7_C6_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R7_C6_dqdPE6 : minv_block_reg_R7_C6_dqdPE6;
   assign minv_block_next_R7_C7_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R7_C7_dqdPE6 : minv_block_reg_R7_C7_dqdPE6;
   assign minv_block_next_R6_C1_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R6_C1_dqdPE6 : minv_block_reg_R6_C1_dqdPE6;
   assign minv_block_next_R6_C2_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R6_C2_dqdPE6 : minv_block_reg_R6_C2_dqdPE6;
   assign minv_block_next_R6_C3_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R6_C3_dqdPE6 : minv_block_reg_R6_C3_dqdPE6;
   assign minv_block_next_R6_C4_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R6_C4_dqdPE6 : minv_block_reg_R6_C4_dqdPE6;
   assign minv_block_next_R6_C5_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R6_C5_dqdPE6 : minv_block_reg_R6_C5_dqdPE6;
   assign minv_block_next_R6_C6_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R6_C6_dqdPE6 : minv_block_reg_R6_C6_dqdPE6;
   assign minv_block_next_R6_C7_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R6_C7_dqdPE6 : minv_block_reg_R6_C7_dqdPE6;
   assign minv_block_next_R5_C1_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R5_C1_dqdPE6 : minv_block_reg_R5_C1_dqdPE6;
   assign minv_block_next_R5_C2_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R5_C2_dqdPE6 : minv_block_reg_R5_C2_dqdPE6;
   assign minv_block_next_R5_C3_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R5_C3_dqdPE6 : minv_block_reg_R5_C3_dqdPE6;
   assign minv_block_next_R5_C4_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R5_C4_dqdPE6 : minv_block_reg_R5_C4_dqdPE6;
   assign minv_block_next_R5_C5_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R5_C5_dqdPE6 : minv_block_reg_R5_C5_dqdPE6;
   assign minv_block_next_R5_C6_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R5_C6_dqdPE6 : minv_block_reg_R5_C6_dqdPE6;
   assign minv_block_next_R5_C7_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R5_C7_dqdPE6 : minv_block_reg_R5_C7_dqdPE6;
   assign minv_block_next_R4_C1_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R4_C1_dqdPE6 : minv_block_reg_R4_C1_dqdPE6;
   assign minv_block_next_R4_C2_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R4_C2_dqdPE6 : minv_block_reg_R4_C2_dqdPE6;
   assign minv_block_next_R4_C3_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R4_C3_dqdPE6 : minv_block_reg_R4_C3_dqdPE6;
   assign minv_block_next_R4_C4_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R4_C4_dqdPE6 : minv_block_reg_R4_C4_dqdPE6;
   assign minv_block_next_R4_C5_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R4_C5_dqdPE6 : minv_block_reg_R4_C5_dqdPE6;
   assign minv_block_next_R4_C6_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R4_C6_dqdPE6 : minv_block_reg_R4_C6_dqdPE6;
   assign minv_block_next_R4_C7_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R4_C7_dqdPE6 : minv_block_reg_R4_C7_dqdPE6;
   assign minv_block_next_R3_C1_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R3_C1_dqdPE6 : minv_block_reg_R3_C1_dqdPE6;
   assign minv_block_next_R3_C2_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R3_C2_dqdPE6 : minv_block_reg_R3_C2_dqdPE6;
   assign minv_block_next_R3_C3_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R3_C3_dqdPE6 : minv_block_reg_R3_C3_dqdPE6;
   assign minv_block_next_R3_C4_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R3_C4_dqdPE6 : minv_block_reg_R3_C4_dqdPE6;
   assign minv_block_next_R3_C5_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R3_C5_dqdPE6 : minv_block_reg_R3_C5_dqdPE6;
   assign minv_block_next_R3_C6_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R3_C6_dqdPE6 : minv_block_reg_R3_C6_dqdPE6;
   assign minv_block_next_R3_C7_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R3_C7_dqdPE6 : minv_block_reg_R3_C7_dqdPE6;
   assign minv_block_next_R2_C1_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R2_C1_dqdPE6 : minv_block_reg_R2_C1_dqdPE6;
   assign minv_block_next_R2_C2_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R2_C2_dqdPE6 : minv_block_reg_R2_C2_dqdPE6;
   assign minv_block_next_R2_C3_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R2_C3_dqdPE6 : minv_block_reg_R2_C3_dqdPE6;
   assign minv_block_next_R2_C4_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R2_C4_dqdPE6 : minv_block_reg_R2_C4_dqdPE6;
   assign minv_block_next_R2_C5_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R2_C5_dqdPE6 : minv_block_reg_R2_C5_dqdPE6;
   assign minv_block_next_R2_C6_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R2_C6_dqdPE6 : minv_block_reg_R2_C6_dqdPE6;
   assign minv_block_next_R2_C7_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R2_C7_dqdPE6 : minv_block_reg_R2_C7_dqdPE6;
   assign minv_block_next_R1_C1_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R1_C1_dqdPE6 : minv_block_reg_R1_C1_dqdPE6;
   assign minv_block_next_R1_C2_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R1_C2_dqdPE6 : minv_block_reg_R1_C2_dqdPE6;
   assign minv_block_next_R1_C3_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R1_C3_dqdPE6 : minv_block_reg_R1_C3_dqdPE6;
   assign minv_block_next_R1_C4_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R1_C4_dqdPE6 : minv_block_reg_R1_C4_dqdPE6;
   assign minv_block_next_R1_C5_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R1_C5_dqdPE6 : minv_block_reg_R1_C5_dqdPE6;
   assign minv_block_next_R1_C6_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R1_C6_dqdPE6 : minv_block_reg_R1_C6_dqdPE6;
   assign minv_block_next_R1_C7_dqdPE6 = (get_data_minv == 1) ? minv_block_in_R1_C7_dqdPE6 : minv_block_reg_R1_C7_dqdPE6;
   assign dtau_vec_next_R1_dqdPE6 = (get_data_minv == 1) ? dtau_vec_in_R1_dqdPE6 : dtau_vec_reg_R1_dqdPE6;
   assign dtau_vec_next_R2_dqdPE6 = (get_data_minv == 1) ? dtau_vec_in_R2_dqdPE6 : dtau_vec_reg_R2_dqdPE6;
   assign dtau_vec_next_R3_dqdPE6 = (get_data_minv == 1) ? dtau_vec_in_R3_dqdPE6 : dtau_vec_reg_R3_dqdPE6;
   assign dtau_vec_next_R4_dqdPE6 = (get_data_minv == 1) ? dtau_vec_in_R4_dqdPE6 : dtau_vec_reg_R4_dqdPE6;
   assign dtau_vec_next_R5_dqdPE6 = (get_data_minv == 1) ? dtau_vec_in_R5_dqdPE6 : dtau_vec_reg_R5_dqdPE6;
   assign dtau_vec_next_R6_dqdPE6 = (get_data_minv == 1) ? dtau_vec_in_R6_dqdPE6 : dtau_vec_reg_R6_dqdPE6;
   assign dtau_vec_next_R7_dqdPE6 = (get_data_minv == 1) ? dtau_vec_in_R7_dqdPE6 : dtau_vec_reg_R7_dqdPE6;
   // dqdPE7
   assign minv_block_next_R7_C1_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R7_C1_dqdPE7 : minv_block_reg_R7_C1_dqdPE7;
   assign minv_block_next_R7_C2_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R7_C2_dqdPE7 : minv_block_reg_R7_C2_dqdPE7;
   assign minv_block_next_R7_C3_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R7_C3_dqdPE7 : minv_block_reg_R7_C3_dqdPE7;
   assign minv_block_next_R7_C4_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R7_C4_dqdPE7 : minv_block_reg_R7_C4_dqdPE7;
   assign minv_block_next_R7_C5_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R7_C5_dqdPE7 : minv_block_reg_R7_C5_dqdPE7;
   assign minv_block_next_R7_C6_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R7_C6_dqdPE7 : minv_block_reg_R7_C6_dqdPE7;
   assign minv_block_next_R7_C7_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R7_C7_dqdPE7 : minv_block_reg_R7_C7_dqdPE7;
   assign minv_block_next_R6_C1_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R6_C1_dqdPE7 : minv_block_reg_R6_C1_dqdPE7;
   assign minv_block_next_R6_C2_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R6_C2_dqdPE7 : minv_block_reg_R6_C2_dqdPE7;
   assign minv_block_next_R6_C3_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R6_C3_dqdPE7 : minv_block_reg_R6_C3_dqdPE7;
   assign minv_block_next_R6_C4_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R6_C4_dqdPE7 : minv_block_reg_R6_C4_dqdPE7;
   assign minv_block_next_R6_C5_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R6_C5_dqdPE7 : minv_block_reg_R6_C5_dqdPE7;
   assign minv_block_next_R6_C6_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R6_C6_dqdPE7 : minv_block_reg_R6_C6_dqdPE7;
   assign minv_block_next_R6_C7_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R6_C7_dqdPE7 : minv_block_reg_R6_C7_dqdPE7;
   assign minv_block_next_R5_C1_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R5_C1_dqdPE7 : minv_block_reg_R5_C1_dqdPE7;
   assign minv_block_next_R5_C2_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R5_C2_dqdPE7 : minv_block_reg_R5_C2_dqdPE7;
   assign minv_block_next_R5_C3_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R5_C3_dqdPE7 : minv_block_reg_R5_C3_dqdPE7;
   assign minv_block_next_R5_C4_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R5_C4_dqdPE7 : minv_block_reg_R5_C4_dqdPE7;
   assign minv_block_next_R5_C5_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R5_C5_dqdPE7 : minv_block_reg_R5_C5_dqdPE7;
   assign minv_block_next_R5_C6_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R5_C6_dqdPE7 : minv_block_reg_R5_C6_dqdPE7;
   assign minv_block_next_R5_C7_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R5_C7_dqdPE7 : minv_block_reg_R5_C7_dqdPE7;
   assign minv_block_next_R4_C1_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R4_C1_dqdPE7 : minv_block_reg_R4_C1_dqdPE7;
   assign minv_block_next_R4_C2_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R4_C2_dqdPE7 : minv_block_reg_R4_C2_dqdPE7;
   assign minv_block_next_R4_C3_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R4_C3_dqdPE7 : minv_block_reg_R4_C3_dqdPE7;
   assign minv_block_next_R4_C4_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R4_C4_dqdPE7 : minv_block_reg_R4_C4_dqdPE7;
   assign minv_block_next_R4_C5_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R4_C5_dqdPE7 : minv_block_reg_R4_C5_dqdPE7;
   assign minv_block_next_R4_C6_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R4_C6_dqdPE7 : minv_block_reg_R4_C6_dqdPE7;
   assign minv_block_next_R4_C7_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R4_C7_dqdPE7 : minv_block_reg_R4_C7_dqdPE7;
   assign minv_block_next_R3_C1_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R3_C1_dqdPE7 : minv_block_reg_R3_C1_dqdPE7;
   assign minv_block_next_R3_C2_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R3_C2_dqdPE7 : minv_block_reg_R3_C2_dqdPE7;
   assign minv_block_next_R3_C3_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R3_C3_dqdPE7 : minv_block_reg_R3_C3_dqdPE7;
   assign minv_block_next_R3_C4_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R3_C4_dqdPE7 : minv_block_reg_R3_C4_dqdPE7;
   assign minv_block_next_R3_C5_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R3_C5_dqdPE7 : minv_block_reg_R3_C5_dqdPE7;
   assign minv_block_next_R3_C6_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R3_C6_dqdPE7 : minv_block_reg_R3_C6_dqdPE7;
   assign minv_block_next_R3_C7_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R3_C7_dqdPE7 : minv_block_reg_R3_C7_dqdPE7;
   assign minv_block_next_R2_C1_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R2_C1_dqdPE7 : minv_block_reg_R2_C1_dqdPE7;
   assign minv_block_next_R2_C2_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R2_C2_dqdPE7 : minv_block_reg_R2_C2_dqdPE7;
   assign minv_block_next_R2_C3_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R2_C3_dqdPE7 : minv_block_reg_R2_C3_dqdPE7;
   assign minv_block_next_R2_C4_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R2_C4_dqdPE7 : minv_block_reg_R2_C4_dqdPE7;
   assign minv_block_next_R2_C5_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R2_C5_dqdPE7 : minv_block_reg_R2_C5_dqdPE7;
   assign minv_block_next_R2_C6_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R2_C6_dqdPE7 : minv_block_reg_R2_C6_dqdPE7;
   assign minv_block_next_R2_C7_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R2_C7_dqdPE7 : minv_block_reg_R2_C7_dqdPE7;
   assign minv_block_next_R1_C1_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R1_C1_dqdPE7 : minv_block_reg_R1_C1_dqdPE7;
   assign minv_block_next_R1_C2_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R1_C2_dqdPE7 : minv_block_reg_R1_C2_dqdPE7;
   assign minv_block_next_R1_C3_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R1_C3_dqdPE7 : minv_block_reg_R1_C3_dqdPE7;
   assign minv_block_next_R1_C4_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R1_C4_dqdPE7 : minv_block_reg_R1_C4_dqdPE7;
   assign minv_block_next_R1_C5_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R1_C5_dqdPE7 : minv_block_reg_R1_C5_dqdPE7;
   assign minv_block_next_R1_C6_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R1_C6_dqdPE7 : minv_block_reg_R1_C6_dqdPE7;
   assign minv_block_next_R1_C7_dqdPE7 = (get_data_minv == 1) ? minv_block_in_R1_C7_dqdPE7 : minv_block_reg_R1_C7_dqdPE7;
   assign dtau_vec_next_R1_dqdPE7 = (get_data_minv == 1) ? dtau_vec_in_R1_dqdPE7 : dtau_vec_reg_R1_dqdPE7;
   assign dtau_vec_next_R2_dqdPE7 = (get_data_minv == 1) ? dtau_vec_in_R2_dqdPE7 : dtau_vec_reg_R2_dqdPE7;
   assign dtau_vec_next_R3_dqdPE7 = (get_data_minv == 1) ? dtau_vec_in_R3_dqdPE7 : dtau_vec_reg_R3_dqdPE7;
   assign dtau_vec_next_R4_dqdPE7 = (get_data_minv == 1) ? dtau_vec_in_R4_dqdPE7 : dtau_vec_reg_R4_dqdPE7;
   assign dtau_vec_next_R5_dqdPE7 = (get_data_minv == 1) ? dtau_vec_in_R5_dqdPE7 : dtau_vec_reg_R5_dqdPE7;
   assign dtau_vec_next_R6_dqdPE7 = (get_data_minv == 1) ? dtau_vec_in_R6_dqdPE7 : dtau_vec_reg_R6_dqdPE7;
   assign dtau_vec_next_R7_dqdPE7 = (get_data_minv == 1) ? dtau_vec_in_R7_dqdPE7 : dtau_vec_reg_R7_dqdPE7;
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
         get_data_minv_reg <= 0;
         // output
         output_ready_reg <= 0;
         output_ready_minv_reg <= 0;
         // minv
         minv_bool_reg <= 0;
         // state
         state_reg      <= 3'd0;
         state_minv_reg <= 3'd0;
         //---------------------------------------------------------------------
         // rnea external inputs
         //---------------------------------------------------------------------
         // rnea
         link_reg_rnea <= 4'd9;
         sinq_val_reg_rnea <= 32'd0;
         cosq_val_reg_rnea <= 32'd0;
         // f updated curr
         f_upd_curr_vec_reg_AX_rnea <= 32'd0;
         f_upd_curr_vec_reg_AY_rnea <= 32'd0;
         f_upd_curr_vec_reg_AZ_rnea <= 32'd0;
         f_upd_curr_vec_reg_LX_rnea <= 32'd0;
         f_upd_curr_vec_reg_LY_rnea <= 32'd0;
         f_upd_curr_vec_reg_LZ_rnea <= 32'd0;
         // f prev
         f_prev_vec_reg_AX_rnea <= 32'd0;
         f_prev_vec_reg_AY_rnea <= 32'd0;
         f_prev_vec_reg_AZ_rnea <= 32'd0;
         f_prev_vec_reg_LX_rnea <= 32'd0;
         f_prev_vec_reg_LY_rnea <= 32'd0;
         f_prev_vec_reg_LZ_rnea <= 32'd0;
         //---------------------------------------------------------------------
         // dq external inputs
         //---------------------------------------------------------------------
         // dqPE1
         link_reg_dqPE1 <= 4'd9;
         derv_reg_dqPE1 <= 4'd0;
         sinq_val_reg_dqPE1 <= 32'd0;
         cosq_val_reg_dqPE1 <= 32'd0;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE1 <= 32'd0;
         f_upd_curr_vec_reg_AY_dqPE1 <= 32'd0;
         f_upd_curr_vec_reg_AZ_dqPE1 <= 32'd0;
         f_upd_curr_vec_reg_LX_dqPE1 <= 32'd0;
         f_upd_curr_vec_reg_LY_dqPE1 <= 32'd0;
         f_upd_curr_vec_reg_LZ_dqPE1 <= 32'd0;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE1 <= 32'd0;
         dfdq_prev_vec_reg_AY_dqPE1 <= 32'd0;
         dfdq_prev_vec_reg_AZ_dqPE1 <= 32'd0;
         dfdq_prev_vec_reg_LX_dqPE1 <= 32'd0;
         dfdq_prev_vec_reg_LY_dqPE1 <= 32'd0;
         dfdq_prev_vec_reg_LZ_dqPE1 <= 32'd0;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE1 <= 32'd0;
         dfdq_upd_curr_vec_reg_AY_dqPE1 <= 32'd0;
         dfdq_upd_curr_vec_reg_AZ_dqPE1 <= 32'd0;
         dfdq_upd_curr_vec_reg_LX_dqPE1 <= 32'd0;
         dfdq_upd_curr_vec_reg_LY_dqPE1 <= 32'd0;
         dfdq_upd_curr_vec_reg_LZ_dqPE1 <= 32'd0;
         // dqPE2
         link_reg_dqPE2 <= 4'd9;
         derv_reg_dqPE2 <= 4'd0;
         sinq_val_reg_dqPE2 <= 32'd0;
         cosq_val_reg_dqPE2 <= 32'd0;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE2 <= 32'd0;
         f_upd_curr_vec_reg_AY_dqPE2 <= 32'd0;
         f_upd_curr_vec_reg_AZ_dqPE2 <= 32'd0;
         f_upd_curr_vec_reg_LX_dqPE2 <= 32'd0;
         f_upd_curr_vec_reg_LY_dqPE2 <= 32'd0;
         f_upd_curr_vec_reg_LZ_dqPE2 <= 32'd0;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE2 <= 32'd0;
         dfdq_prev_vec_reg_AY_dqPE2 <= 32'd0;
         dfdq_prev_vec_reg_AZ_dqPE2 <= 32'd0;
         dfdq_prev_vec_reg_LX_dqPE2 <= 32'd0;
         dfdq_prev_vec_reg_LY_dqPE2 <= 32'd0;
         dfdq_prev_vec_reg_LZ_dqPE2 <= 32'd0;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE2 <= 32'd0;
         dfdq_upd_curr_vec_reg_AY_dqPE2 <= 32'd0;
         dfdq_upd_curr_vec_reg_AZ_dqPE2 <= 32'd0;
         dfdq_upd_curr_vec_reg_LX_dqPE2 <= 32'd0;
         dfdq_upd_curr_vec_reg_LY_dqPE2 <= 32'd0;
         dfdq_upd_curr_vec_reg_LZ_dqPE2 <= 32'd0;
         // dqPE3
         link_reg_dqPE3 <= 4'd9;
         derv_reg_dqPE3 <= 4'd0;
         sinq_val_reg_dqPE3 <= 32'd0;
         cosq_val_reg_dqPE3 <= 32'd0;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE3 <= 32'd0;
         f_upd_curr_vec_reg_AY_dqPE3 <= 32'd0;
         f_upd_curr_vec_reg_AZ_dqPE3 <= 32'd0;
         f_upd_curr_vec_reg_LX_dqPE3 <= 32'd0;
         f_upd_curr_vec_reg_LY_dqPE3 <= 32'd0;
         f_upd_curr_vec_reg_LZ_dqPE3 <= 32'd0;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE3 <= 32'd0;
         dfdq_prev_vec_reg_AY_dqPE3 <= 32'd0;
         dfdq_prev_vec_reg_AZ_dqPE3 <= 32'd0;
         dfdq_prev_vec_reg_LX_dqPE3 <= 32'd0;
         dfdq_prev_vec_reg_LY_dqPE3 <= 32'd0;
         dfdq_prev_vec_reg_LZ_dqPE3 <= 32'd0;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE3 <= 32'd0;
         dfdq_upd_curr_vec_reg_AY_dqPE3 <= 32'd0;
         dfdq_upd_curr_vec_reg_AZ_dqPE3 <= 32'd0;
         dfdq_upd_curr_vec_reg_LX_dqPE3 <= 32'd0;
         dfdq_upd_curr_vec_reg_LY_dqPE3 <= 32'd0;
         dfdq_upd_curr_vec_reg_LZ_dqPE3 <= 32'd0;
         // dqPE4
         link_reg_dqPE4 <= 4'd9;
         derv_reg_dqPE4 <= 4'd0;
         sinq_val_reg_dqPE4 <= 32'd0;
         cosq_val_reg_dqPE4 <= 32'd0;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE4 <= 32'd0;
         f_upd_curr_vec_reg_AY_dqPE4 <= 32'd0;
         f_upd_curr_vec_reg_AZ_dqPE4 <= 32'd0;
         f_upd_curr_vec_reg_LX_dqPE4 <= 32'd0;
         f_upd_curr_vec_reg_LY_dqPE4 <= 32'd0;
         f_upd_curr_vec_reg_LZ_dqPE4 <= 32'd0;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE4 <= 32'd0;
         dfdq_prev_vec_reg_AY_dqPE4 <= 32'd0;
         dfdq_prev_vec_reg_AZ_dqPE4 <= 32'd0;
         dfdq_prev_vec_reg_LX_dqPE4 <= 32'd0;
         dfdq_prev_vec_reg_LY_dqPE4 <= 32'd0;
         dfdq_prev_vec_reg_LZ_dqPE4 <= 32'd0;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE4 <= 32'd0;
         dfdq_upd_curr_vec_reg_AY_dqPE4 <= 32'd0;
         dfdq_upd_curr_vec_reg_AZ_dqPE4 <= 32'd0;
         dfdq_upd_curr_vec_reg_LX_dqPE4 <= 32'd0;
         dfdq_upd_curr_vec_reg_LY_dqPE4 <= 32'd0;
         dfdq_upd_curr_vec_reg_LZ_dqPE4 <= 32'd0;
         // dqPE5
         link_reg_dqPE5 <= 4'd9;
         derv_reg_dqPE5 <= 4'd0;
         sinq_val_reg_dqPE5 <= 32'd0;
         cosq_val_reg_dqPE5 <= 32'd0;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE5 <= 32'd0;
         f_upd_curr_vec_reg_AY_dqPE5 <= 32'd0;
         f_upd_curr_vec_reg_AZ_dqPE5 <= 32'd0;
         f_upd_curr_vec_reg_LX_dqPE5 <= 32'd0;
         f_upd_curr_vec_reg_LY_dqPE5 <= 32'd0;
         f_upd_curr_vec_reg_LZ_dqPE5 <= 32'd0;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE5 <= 32'd0;
         dfdq_prev_vec_reg_AY_dqPE5 <= 32'd0;
         dfdq_prev_vec_reg_AZ_dqPE5 <= 32'd0;
         dfdq_prev_vec_reg_LX_dqPE5 <= 32'd0;
         dfdq_prev_vec_reg_LY_dqPE5 <= 32'd0;
         dfdq_prev_vec_reg_LZ_dqPE5 <= 32'd0;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE5 <= 32'd0;
         dfdq_upd_curr_vec_reg_AY_dqPE5 <= 32'd0;
         dfdq_upd_curr_vec_reg_AZ_dqPE5 <= 32'd0;
         dfdq_upd_curr_vec_reg_LX_dqPE5 <= 32'd0;
         dfdq_upd_curr_vec_reg_LY_dqPE5 <= 32'd0;
         dfdq_upd_curr_vec_reg_LZ_dqPE5 <= 32'd0;
         // dqPE6
         link_reg_dqPE6 <= 4'd9;
         derv_reg_dqPE6 <= 4'd0;
         sinq_val_reg_dqPE6 <= 32'd0;
         cosq_val_reg_dqPE6 <= 32'd0;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE6 <= 32'd0;
         f_upd_curr_vec_reg_AY_dqPE6 <= 32'd0;
         f_upd_curr_vec_reg_AZ_dqPE6 <= 32'd0;
         f_upd_curr_vec_reg_LX_dqPE6 <= 32'd0;
         f_upd_curr_vec_reg_LY_dqPE6 <= 32'd0;
         f_upd_curr_vec_reg_LZ_dqPE6 <= 32'd0;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE6 <= 32'd0;
         dfdq_prev_vec_reg_AY_dqPE6 <= 32'd0;
         dfdq_prev_vec_reg_AZ_dqPE6 <= 32'd0;
         dfdq_prev_vec_reg_LX_dqPE6 <= 32'd0;
         dfdq_prev_vec_reg_LY_dqPE6 <= 32'd0;
         dfdq_prev_vec_reg_LZ_dqPE6 <= 32'd0;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE6 <= 32'd0;
         dfdq_upd_curr_vec_reg_AY_dqPE6 <= 32'd0;
         dfdq_upd_curr_vec_reg_AZ_dqPE6 <= 32'd0;
         dfdq_upd_curr_vec_reg_LX_dqPE6 <= 32'd0;
         dfdq_upd_curr_vec_reg_LY_dqPE6 <= 32'd0;
         dfdq_upd_curr_vec_reg_LZ_dqPE6 <= 32'd0;
         // dqPE7
         link_reg_dqPE7 <= 4'd9;
         derv_reg_dqPE7 <= 4'd0;
         sinq_val_reg_dqPE7 <= 32'd0;
         cosq_val_reg_dqPE7 <= 32'd0;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE7 <= 32'd0;
         f_upd_curr_vec_reg_AY_dqPE7 <= 32'd0;
         f_upd_curr_vec_reg_AZ_dqPE7 <= 32'd0;
         f_upd_curr_vec_reg_LX_dqPE7 <= 32'd0;
         f_upd_curr_vec_reg_LY_dqPE7 <= 32'd0;
         f_upd_curr_vec_reg_LZ_dqPE7 <= 32'd0;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE7 <= 32'd0;
         dfdq_prev_vec_reg_AY_dqPE7 <= 32'd0;
         dfdq_prev_vec_reg_AZ_dqPE7 <= 32'd0;
         dfdq_prev_vec_reg_LX_dqPE7 <= 32'd0;
         dfdq_prev_vec_reg_LY_dqPE7 <= 32'd0;
         dfdq_prev_vec_reg_LZ_dqPE7 <= 32'd0;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE7 <= 32'd0;
         dfdq_upd_curr_vec_reg_AY_dqPE7 <= 32'd0;
         dfdq_upd_curr_vec_reg_AZ_dqPE7 <= 32'd0;
         dfdq_upd_curr_vec_reg_LX_dqPE7 <= 32'd0;
         dfdq_upd_curr_vec_reg_LY_dqPE7 <= 32'd0;
         dfdq_upd_curr_vec_reg_LZ_dqPE7 <= 32'd0;
         //---------------------------------------------------------------------
         // dqd external inputs
         //---------------------------------------------------------------------
         // dqdPE1
         link_reg_dqdPE1 <= 4'd9;
         derv_reg_dqdPE1 <= 4'd0;
         sinq_val_reg_dqdPE1 <= 32'd0;
         cosq_val_reg_dqdPE1 <= 32'd0;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE1 <= 32'd0;
         dfdqd_prev_vec_reg_AY_dqdPE1 <= 32'd0;
         dfdqd_prev_vec_reg_AZ_dqdPE1 <= 32'd0;
         dfdqd_prev_vec_reg_LX_dqdPE1 <= 32'd0;
         dfdqd_prev_vec_reg_LY_dqdPE1 <= 32'd0;
         dfdqd_prev_vec_reg_LZ_dqdPE1 <= 32'd0;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE1 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AY_dqdPE1 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE1 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LX_dqdPE1 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LY_dqdPE1 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE1 <= 32'd0;
         // dqdPE2
         link_reg_dqdPE2 <= 4'd9;
         derv_reg_dqdPE2 <= 4'd0;
         sinq_val_reg_dqdPE2 <= 32'd0;
         cosq_val_reg_dqdPE2 <= 32'd0;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE2 <= 32'd0;
         dfdqd_prev_vec_reg_AY_dqdPE2 <= 32'd0;
         dfdqd_prev_vec_reg_AZ_dqdPE2 <= 32'd0;
         dfdqd_prev_vec_reg_LX_dqdPE2 <= 32'd0;
         dfdqd_prev_vec_reg_LY_dqdPE2 <= 32'd0;
         dfdqd_prev_vec_reg_LZ_dqdPE2 <= 32'd0;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE2 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AY_dqdPE2 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE2 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LX_dqdPE2 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LY_dqdPE2 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE2 <= 32'd0;
         // dqdPE3
         link_reg_dqdPE3 <= 4'd9;
         derv_reg_dqdPE3 <= 4'd0;
         sinq_val_reg_dqdPE3 <= 32'd0;
         cosq_val_reg_dqdPE3 <= 32'd0;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE3 <= 32'd0;
         dfdqd_prev_vec_reg_AY_dqdPE3 <= 32'd0;
         dfdqd_prev_vec_reg_AZ_dqdPE3 <= 32'd0;
         dfdqd_prev_vec_reg_LX_dqdPE3 <= 32'd0;
         dfdqd_prev_vec_reg_LY_dqdPE3 <= 32'd0;
         dfdqd_prev_vec_reg_LZ_dqdPE3 <= 32'd0;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE3 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AY_dqdPE3 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE3 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LX_dqdPE3 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LY_dqdPE3 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE3 <= 32'd0;
         // dqdPE4
         link_reg_dqdPE4 <= 4'd9;
         derv_reg_dqdPE4 <= 4'd0;
         sinq_val_reg_dqdPE4 <= 32'd0;
         cosq_val_reg_dqdPE4 <= 32'd0;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE4 <= 32'd0;
         dfdqd_prev_vec_reg_AY_dqdPE4 <= 32'd0;
         dfdqd_prev_vec_reg_AZ_dqdPE4 <= 32'd0;
         dfdqd_prev_vec_reg_LX_dqdPE4 <= 32'd0;
         dfdqd_prev_vec_reg_LY_dqdPE4 <= 32'd0;
         dfdqd_prev_vec_reg_LZ_dqdPE4 <= 32'd0;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE4 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AY_dqdPE4 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE4 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LX_dqdPE4 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LY_dqdPE4 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE4 <= 32'd0;
         // dqdPE5
         link_reg_dqdPE5 <= 4'd9;
         derv_reg_dqdPE5 <= 4'd0;
         sinq_val_reg_dqdPE5 <= 32'd0;
         cosq_val_reg_dqdPE5 <= 32'd0;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE5 <= 32'd0;
         dfdqd_prev_vec_reg_AY_dqdPE5 <= 32'd0;
         dfdqd_prev_vec_reg_AZ_dqdPE5 <= 32'd0;
         dfdqd_prev_vec_reg_LX_dqdPE5 <= 32'd0;
         dfdqd_prev_vec_reg_LY_dqdPE5 <= 32'd0;
         dfdqd_prev_vec_reg_LZ_dqdPE5 <= 32'd0;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE5 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AY_dqdPE5 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE5 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LX_dqdPE5 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LY_dqdPE5 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE5 <= 32'd0;
         // dqdPE6
         link_reg_dqdPE6 <= 4'd9;
         derv_reg_dqdPE6 <= 4'd0;
         sinq_val_reg_dqdPE6 <= 32'd0;
         cosq_val_reg_dqdPE6 <= 32'd0;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE6 <= 32'd0;
         dfdqd_prev_vec_reg_AY_dqdPE6 <= 32'd0;
         dfdqd_prev_vec_reg_AZ_dqdPE6 <= 32'd0;
         dfdqd_prev_vec_reg_LX_dqdPE6 <= 32'd0;
         dfdqd_prev_vec_reg_LY_dqdPE6 <= 32'd0;
         dfdqd_prev_vec_reg_LZ_dqdPE6 <= 32'd0;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE6 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AY_dqdPE6 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE6 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LX_dqdPE6 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LY_dqdPE6 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE6 <= 32'd0;
         // dqdPE7
         link_reg_dqdPE7 <= 4'd9;
         derv_reg_dqdPE7 <= 4'd0;
         sinq_val_reg_dqdPE7 <= 32'd0;
         cosq_val_reg_dqdPE7 <= 32'd0;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE7 <= 32'd0;
         dfdqd_prev_vec_reg_AY_dqdPE7 <= 32'd0;
         dfdqd_prev_vec_reg_AZ_dqdPE7 <= 32'd0;
         dfdqd_prev_vec_reg_LX_dqdPE7 <= 32'd0;
         dfdqd_prev_vec_reg_LY_dqdPE7 <= 32'd0;
         dfdqd_prev_vec_reg_LZ_dqdPE7 <= 32'd0;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE7 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AY_dqdPE7 <= 32'd0;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE7 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LX_dqdPE7 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LY_dqdPE7 <= 32'd0;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE7 <= 32'd0;
         //---------------------------------------------------------------------
         // minv external inputs
         //---------------------------------------------------------------------
         // dqdPE1
         minv_block_reg_R1_C1_dqdPE1 <= 32'd0;
         minv_block_reg_R1_C2_dqdPE1 <= 32'd0;
         minv_block_reg_R1_C3_dqdPE1 <= 32'd0;
         minv_block_reg_R1_C4_dqdPE1 <= 32'd0;
         minv_block_reg_R1_C5_dqdPE1 <= 32'd0;
         minv_block_reg_R1_C6_dqdPE1 <= 32'd0;
         minv_block_reg_R1_C7_dqdPE1 <= 32'd0;
         minv_block_reg_R2_C1_dqdPE1 <= 32'd0;
         minv_block_reg_R2_C2_dqdPE1 <= 32'd0;
         minv_block_reg_R2_C3_dqdPE1 <= 32'd0;
         minv_block_reg_R2_C4_dqdPE1 <= 32'd0;
         minv_block_reg_R2_C5_dqdPE1 <= 32'd0;
         minv_block_reg_R2_C6_dqdPE1 <= 32'd0;
         minv_block_reg_R2_C7_dqdPE1 <= 32'd0;
         minv_block_reg_R3_C1_dqdPE1 <= 32'd0;
         minv_block_reg_R3_C2_dqdPE1 <= 32'd0;
         minv_block_reg_R3_C3_dqdPE1 <= 32'd0;
         minv_block_reg_R3_C4_dqdPE1 <= 32'd0;
         minv_block_reg_R3_C5_dqdPE1 <= 32'd0;
         minv_block_reg_R3_C6_dqdPE1 <= 32'd0;
         minv_block_reg_R3_C7_dqdPE1 <= 32'd0;
         minv_block_reg_R4_C1_dqdPE1 <= 32'd0;
         minv_block_reg_R4_C2_dqdPE1 <= 32'd0;
         minv_block_reg_R4_C3_dqdPE1 <= 32'd0;
         minv_block_reg_R4_C4_dqdPE1 <= 32'd0;
         minv_block_reg_R4_C5_dqdPE1 <= 32'd0;
         minv_block_reg_R4_C6_dqdPE1 <= 32'd0;
         minv_block_reg_R4_C7_dqdPE1 <= 32'd0;
         minv_block_reg_R5_C1_dqdPE1 <= 32'd0;
         minv_block_reg_R5_C2_dqdPE1 <= 32'd0;
         minv_block_reg_R5_C3_dqdPE1 <= 32'd0;
         minv_block_reg_R5_C4_dqdPE1 <= 32'd0;
         minv_block_reg_R5_C5_dqdPE1 <= 32'd0;
         minv_block_reg_R5_C6_dqdPE1 <= 32'd0;
         minv_block_reg_R5_C7_dqdPE1 <= 32'd0;
         minv_block_reg_R6_C1_dqdPE1 <= 32'd0;
         minv_block_reg_R6_C2_dqdPE1 <= 32'd0;
         minv_block_reg_R6_C3_dqdPE1 <= 32'd0;
         minv_block_reg_R6_C4_dqdPE1 <= 32'd0;
         minv_block_reg_R6_C5_dqdPE1 <= 32'd0;
         minv_block_reg_R6_C6_dqdPE1 <= 32'd0;
         minv_block_reg_R6_C7_dqdPE1 <= 32'd0;
         minv_block_reg_R7_C1_dqdPE1 <= 32'd0;
         minv_block_reg_R7_C2_dqdPE1 <= 32'd0;
         minv_block_reg_R7_C3_dqdPE1 <= 32'd0;
         minv_block_reg_R7_C4_dqdPE1 <= 32'd0;
         minv_block_reg_R7_C5_dqdPE1 <= 32'd0;
         minv_block_reg_R7_C6_dqdPE1 <= 32'd0;
         minv_block_reg_R7_C7_dqdPE1 <= 32'd0;
         dtau_vec_reg_R1_dqdPE1 <= 32'd0;
         dtau_vec_reg_R2_dqdPE1 <= 32'd0;
         dtau_vec_reg_R3_dqdPE1 <= 32'd0;
         dtau_vec_reg_R4_dqdPE1 <= 32'd0;
         dtau_vec_reg_R5_dqdPE1 <= 32'd0;
         dtau_vec_reg_R6_dqdPE1 <= 32'd0;
         dtau_vec_reg_R7_dqdPE1 <= 32'd0;
         // dqdPE2
         minv_block_reg_R1_C1_dqdPE2 <= 32'd0;
         minv_block_reg_R1_C2_dqdPE2 <= 32'd0;
         minv_block_reg_R1_C3_dqdPE2 <= 32'd0;
         minv_block_reg_R1_C4_dqdPE2 <= 32'd0;
         minv_block_reg_R1_C5_dqdPE2 <= 32'd0;
         minv_block_reg_R1_C6_dqdPE2 <= 32'd0;
         minv_block_reg_R1_C7_dqdPE2 <= 32'd0;
         minv_block_reg_R2_C1_dqdPE2 <= 32'd0;
         minv_block_reg_R2_C2_dqdPE2 <= 32'd0;
         minv_block_reg_R2_C3_dqdPE2 <= 32'd0;
         minv_block_reg_R2_C4_dqdPE2 <= 32'd0;
         minv_block_reg_R2_C5_dqdPE2 <= 32'd0;
         minv_block_reg_R2_C6_dqdPE2 <= 32'd0;
         minv_block_reg_R2_C7_dqdPE2 <= 32'd0;
         minv_block_reg_R3_C1_dqdPE2 <= 32'd0;
         minv_block_reg_R3_C2_dqdPE2 <= 32'd0;
         minv_block_reg_R3_C3_dqdPE2 <= 32'd0;
         minv_block_reg_R3_C4_dqdPE2 <= 32'd0;
         minv_block_reg_R3_C5_dqdPE2 <= 32'd0;
         minv_block_reg_R3_C6_dqdPE2 <= 32'd0;
         minv_block_reg_R3_C7_dqdPE2 <= 32'd0;
         minv_block_reg_R4_C1_dqdPE2 <= 32'd0;
         minv_block_reg_R4_C2_dqdPE2 <= 32'd0;
         minv_block_reg_R4_C3_dqdPE2 <= 32'd0;
         minv_block_reg_R4_C4_dqdPE2 <= 32'd0;
         minv_block_reg_R4_C5_dqdPE2 <= 32'd0;
         minv_block_reg_R4_C6_dqdPE2 <= 32'd0;
         minv_block_reg_R4_C7_dqdPE2 <= 32'd0;
         minv_block_reg_R5_C1_dqdPE2 <= 32'd0;
         minv_block_reg_R5_C2_dqdPE2 <= 32'd0;
         minv_block_reg_R5_C3_dqdPE2 <= 32'd0;
         minv_block_reg_R5_C4_dqdPE2 <= 32'd0;
         minv_block_reg_R5_C5_dqdPE2 <= 32'd0;
         minv_block_reg_R5_C6_dqdPE2 <= 32'd0;
         minv_block_reg_R5_C7_dqdPE2 <= 32'd0;
         minv_block_reg_R6_C1_dqdPE2 <= 32'd0;
         minv_block_reg_R6_C2_dqdPE2 <= 32'd0;
         minv_block_reg_R6_C3_dqdPE2 <= 32'd0;
         minv_block_reg_R6_C4_dqdPE2 <= 32'd0;
         minv_block_reg_R6_C5_dqdPE2 <= 32'd0;
         minv_block_reg_R6_C6_dqdPE2 <= 32'd0;
         minv_block_reg_R6_C7_dqdPE2 <= 32'd0;
         minv_block_reg_R7_C1_dqdPE2 <= 32'd0;
         minv_block_reg_R7_C2_dqdPE2 <= 32'd0;
         minv_block_reg_R7_C3_dqdPE2 <= 32'd0;
         minv_block_reg_R7_C4_dqdPE2 <= 32'd0;
         minv_block_reg_R7_C5_dqdPE2 <= 32'd0;
         minv_block_reg_R7_C6_dqdPE2 <= 32'd0;
         minv_block_reg_R7_C7_dqdPE2 <= 32'd0;
         dtau_vec_reg_R1_dqdPE2 <= 32'd0;
         dtau_vec_reg_R2_dqdPE2 <= 32'd0;
         dtau_vec_reg_R3_dqdPE2 <= 32'd0;
         dtau_vec_reg_R4_dqdPE2 <= 32'd0;
         dtau_vec_reg_R5_dqdPE2 <= 32'd0;
         dtau_vec_reg_R6_dqdPE2 <= 32'd0;
         dtau_vec_reg_R7_dqdPE2 <= 32'd0;
         // dqdPE3
         minv_block_reg_R1_C1_dqdPE3 <= 32'd0;
         minv_block_reg_R1_C2_dqdPE3 <= 32'd0;
         minv_block_reg_R1_C3_dqdPE3 <= 32'd0;
         minv_block_reg_R1_C4_dqdPE3 <= 32'd0;
         minv_block_reg_R1_C5_dqdPE3 <= 32'd0;
         minv_block_reg_R1_C6_dqdPE3 <= 32'd0;
         minv_block_reg_R1_C7_dqdPE3 <= 32'd0;
         minv_block_reg_R2_C1_dqdPE3 <= 32'd0;
         minv_block_reg_R2_C2_dqdPE3 <= 32'd0;
         minv_block_reg_R2_C3_dqdPE3 <= 32'd0;
         minv_block_reg_R2_C4_dqdPE3 <= 32'd0;
         minv_block_reg_R2_C5_dqdPE3 <= 32'd0;
         minv_block_reg_R2_C6_dqdPE3 <= 32'd0;
         minv_block_reg_R2_C7_dqdPE3 <= 32'd0;
         minv_block_reg_R3_C1_dqdPE3 <= 32'd0;
         minv_block_reg_R3_C2_dqdPE3 <= 32'd0;
         minv_block_reg_R3_C3_dqdPE3 <= 32'd0;
         minv_block_reg_R3_C4_dqdPE3 <= 32'd0;
         minv_block_reg_R3_C5_dqdPE3 <= 32'd0;
         minv_block_reg_R3_C6_dqdPE3 <= 32'd0;
         minv_block_reg_R3_C7_dqdPE3 <= 32'd0;
         minv_block_reg_R4_C1_dqdPE3 <= 32'd0;
         minv_block_reg_R4_C2_dqdPE3 <= 32'd0;
         minv_block_reg_R4_C3_dqdPE3 <= 32'd0;
         minv_block_reg_R4_C4_dqdPE3 <= 32'd0;
         minv_block_reg_R4_C5_dqdPE3 <= 32'd0;
         minv_block_reg_R4_C6_dqdPE3 <= 32'd0;
         minv_block_reg_R4_C7_dqdPE3 <= 32'd0;
         minv_block_reg_R5_C1_dqdPE3 <= 32'd0;
         minv_block_reg_R5_C2_dqdPE3 <= 32'd0;
         minv_block_reg_R5_C3_dqdPE3 <= 32'd0;
         minv_block_reg_R5_C4_dqdPE3 <= 32'd0;
         minv_block_reg_R5_C5_dqdPE3 <= 32'd0;
         minv_block_reg_R5_C6_dqdPE3 <= 32'd0;
         minv_block_reg_R5_C7_dqdPE3 <= 32'd0;
         minv_block_reg_R6_C1_dqdPE3 <= 32'd0;
         minv_block_reg_R6_C2_dqdPE3 <= 32'd0;
         minv_block_reg_R6_C3_dqdPE3 <= 32'd0;
         minv_block_reg_R6_C4_dqdPE3 <= 32'd0;
         minv_block_reg_R6_C5_dqdPE3 <= 32'd0;
         minv_block_reg_R6_C6_dqdPE3 <= 32'd0;
         minv_block_reg_R6_C7_dqdPE3 <= 32'd0;
         minv_block_reg_R7_C1_dqdPE3 <= 32'd0;
         minv_block_reg_R7_C2_dqdPE3 <= 32'd0;
         minv_block_reg_R7_C3_dqdPE3 <= 32'd0;
         minv_block_reg_R7_C4_dqdPE3 <= 32'd0;
         minv_block_reg_R7_C5_dqdPE3 <= 32'd0;
         minv_block_reg_R7_C6_dqdPE3 <= 32'd0;
         minv_block_reg_R7_C7_dqdPE3 <= 32'd0;
         dtau_vec_reg_R1_dqdPE3 <= 32'd0;
         dtau_vec_reg_R2_dqdPE3 <= 32'd0;
         dtau_vec_reg_R3_dqdPE3 <= 32'd0;
         dtau_vec_reg_R4_dqdPE3 <= 32'd0;
         dtau_vec_reg_R5_dqdPE3 <= 32'd0;
         dtau_vec_reg_R6_dqdPE3 <= 32'd0;
         dtau_vec_reg_R7_dqdPE3 <= 32'd0;
         // dqdPE4
         minv_block_reg_R1_C1_dqdPE4 <= 32'd0;
         minv_block_reg_R1_C2_dqdPE4 <= 32'd0;
         minv_block_reg_R1_C3_dqdPE4 <= 32'd0;
         minv_block_reg_R1_C4_dqdPE4 <= 32'd0;
         minv_block_reg_R1_C5_dqdPE4 <= 32'd0;
         minv_block_reg_R1_C6_dqdPE4 <= 32'd0;
         minv_block_reg_R1_C7_dqdPE4 <= 32'd0;
         minv_block_reg_R2_C1_dqdPE4 <= 32'd0;
         minv_block_reg_R2_C2_dqdPE4 <= 32'd0;
         minv_block_reg_R2_C3_dqdPE4 <= 32'd0;
         minv_block_reg_R2_C4_dqdPE4 <= 32'd0;
         minv_block_reg_R2_C5_dqdPE4 <= 32'd0;
         minv_block_reg_R2_C6_dqdPE4 <= 32'd0;
         minv_block_reg_R2_C7_dqdPE4 <= 32'd0;
         minv_block_reg_R3_C1_dqdPE4 <= 32'd0;
         minv_block_reg_R3_C2_dqdPE4 <= 32'd0;
         minv_block_reg_R3_C3_dqdPE4 <= 32'd0;
         minv_block_reg_R3_C4_dqdPE4 <= 32'd0;
         minv_block_reg_R3_C5_dqdPE4 <= 32'd0;
         minv_block_reg_R3_C6_dqdPE4 <= 32'd0;
         minv_block_reg_R3_C7_dqdPE4 <= 32'd0;
         minv_block_reg_R4_C1_dqdPE4 <= 32'd0;
         minv_block_reg_R4_C2_dqdPE4 <= 32'd0;
         minv_block_reg_R4_C3_dqdPE4 <= 32'd0;
         minv_block_reg_R4_C4_dqdPE4 <= 32'd0;
         minv_block_reg_R4_C5_dqdPE4 <= 32'd0;
         minv_block_reg_R4_C6_dqdPE4 <= 32'd0;
         minv_block_reg_R4_C7_dqdPE4 <= 32'd0;
         minv_block_reg_R5_C1_dqdPE4 <= 32'd0;
         minv_block_reg_R5_C2_dqdPE4 <= 32'd0;
         minv_block_reg_R5_C3_dqdPE4 <= 32'd0;
         minv_block_reg_R5_C4_dqdPE4 <= 32'd0;
         minv_block_reg_R5_C5_dqdPE4 <= 32'd0;
         minv_block_reg_R5_C6_dqdPE4 <= 32'd0;
         minv_block_reg_R5_C7_dqdPE4 <= 32'd0;
         minv_block_reg_R6_C1_dqdPE4 <= 32'd0;
         minv_block_reg_R6_C2_dqdPE4 <= 32'd0;
         minv_block_reg_R6_C3_dqdPE4 <= 32'd0;
         minv_block_reg_R6_C4_dqdPE4 <= 32'd0;
         minv_block_reg_R6_C5_dqdPE4 <= 32'd0;
         minv_block_reg_R6_C6_dqdPE4 <= 32'd0;
         minv_block_reg_R6_C7_dqdPE4 <= 32'd0;
         minv_block_reg_R7_C1_dqdPE4 <= 32'd0;
         minv_block_reg_R7_C2_dqdPE4 <= 32'd0;
         minv_block_reg_R7_C3_dqdPE4 <= 32'd0;
         minv_block_reg_R7_C4_dqdPE4 <= 32'd0;
         minv_block_reg_R7_C5_dqdPE4 <= 32'd0;
         minv_block_reg_R7_C6_dqdPE4 <= 32'd0;
         minv_block_reg_R7_C7_dqdPE4 <= 32'd0;
         dtau_vec_reg_R1_dqdPE4 <= 32'd0;
         dtau_vec_reg_R2_dqdPE4 <= 32'd0;
         dtau_vec_reg_R3_dqdPE4 <= 32'd0;
         dtau_vec_reg_R4_dqdPE4 <= 32'd0;
         dtau_vec_reg_R5_dqdPE4 <= 32'd0;
         dtau_vec_reg_R6_dqdPE4 <= 32'd0;
         dtau_vec_reg_R7_dqdPE4 <= 32'd0;
         // dqdPE5
         minv_block_reg_R1_C1_dqdPE5 <= 32'd0;
         minv_block_reg_R1_C2_dqdPE5 <= 32'd0;
         minv_block_reg_R1_C3_dqdPE5 <= 32'd0;
         minv_block_reg_R1_C4_dqdPE5 <= 32'd0;
         minv_block_reg_R1_C5_dqdPE5 <= 32'd0;
         minv_block_reg_R1_C6_dqdPE5 <= 32'd0;
         minv_block_reg_R1_C7_dqdPE5 <= 32'd0;
         minv_block_reg_R2_C1_dqdPE5 <= 32'd0;
         minv_block_reg_R2_C2_dqdPE5 <= 32'd0;
         minv_block_reg_R2_C3_dqdPE5 <= 32'd0;
         minv_block_reg_R2_C4_dqdPE5 <= 32'd0;
         minv_block_reg_R2_C5_dqdPE5 <= 32'd0;
         minv_block_reg_R2_C6_dqdPE5 <= 32'd0;
         minv_block_reg_R2_C7_dqdPE5 <= 32'd0;
         minv_block_reg_R3_C1_dqdPE5 <= 32'd0;
         minv_block_reg_R3_C2_dqdPE5 <= 32'd0;
         minv_block_reg_R3_C3_dqdPE5 <= 32'd0;
         minv_block_reg_R3_C4_dqdPE5 <= 32'd0;
         minv_block_reg_R3_C5_dqdPE5 <= 32'd0;
         minv_block_reg_R3_C6_dqdPE5 <= 32'd0;
         minv_block_reg_R3_C7_dqdPE5 <= 32'd0;
         minv_block_reg_R4_C1_dqdPE5 <= 32'd0;
         minv_block_reg_R4_C2_dqdPE5 <= 32'd0;
         minv_block_reg_R4_C3_dqdPE5 <= 32'd0;
         minv_block_reg_R4_C4_dqdPE5 <= 32'd0;
         minv_block_reg_R4_C5_dqdPE5 <= 32'd0;
         minv_block_reg_R4_C6_dqdPE5 <= 32'd0;
         minv_block_reg_R4_C7_dqdPE5 <= 32'd0;
         minv_block_reg_R5_C1_dqdPE5 <= 32'd0;
         minv_block_reg_R5_C2_dqdPE5 <= 32'd0;
         minv_block_reg_R5_C3_dqdPE5 <= 32'd0;
         minv_block_reg_R5_C4_dqdPE5 <= 32'd0;
         minv_block_reg_R5_C5_dqdPE5 <= 32'd0;
         minv_block_reg_R5_C6_dqdPE5 <= 32'd0;
         minv_block_reg_R5_C7_dqdPE5 <= 32'd0;
         minv_block_reg_R6_C1_dqdPE5 <= 32'd0;
         minv_block_reg_R6_C2_dqdPE5 <= 32'd0;
         minv_block_reg_R6_C3_dqdPE5 <= 32'd0;
         minv_block_reg_R6_C4_dqdPE5 <= 32'd0;
         minv_block_reg_R6_C5_dqdPE5 <= 32'd0;
         minv_block_reg_R6_C6_dqdPE5 <= 32'd0;
         minv_block_reg_R6_C7_dqdPE5 <= 32'd0;
         minv_block_reg_R7_C1_dqdPE5 <= 32'd0;
         minv_block_reg_R7_C2_dqdPE5 <= 32'd0;
         minv_block_reg_R7_C3_dqdPE5 <= 32'd0;
         minv_block_reg_R7_C4_dqdPE5 <= 32'd0;
         minv_block_reg_R7_C5_dqdPE5 <= 32'd0;
         minv_block_reg_R7_C6_dqdPE5 <= 32'd0;
         minv_block_reg_R7_C7_dqdPE5 <= 32'd0;
         dtau_vec_reg_R1_dqdPE5 <= 32'd0;
         dtau_vec_reg_R2_dqdPE5 <= 32'd0;
         dtau_vec_reg_R3_dqdPE5 <= 32'd0;
         dtau_vec_reg_R4_dqdPE5 <= 32'd0;
         dtau_vec_reg_R5_dqdPE5 <= 32'd0;
         dtau_vec_reg_R6_dqdPE5 <= 32'd0;
         dtau_vec_reg_R7_dqdPE5 <= 32'd0;
         // dqdPE6
         minv_block_reg_R1_C1_dqdPE6 <= 32'd0;
         minv_block_reg_R1_C2_dqdPE6 <= 32'd0;
         minv_block_reg_R1_C3_dqdPE6 <= 32'd0;
         minv_block_reg_R1_C4_dqdPE6 <= 32'd0;
         minv_block_reg_R1_C5_dqdPE6 <= 32'd0;
         minv_block_reg_R1_C6_dqdPE6 <= 32'd0;
         minv_block_reg_R1_C7_dqdPE6 <= 32'd0;
         minv_block_reg_R2_C1_dqdPE6 <= 32'd0;
         minv_block_reg_R2_C2_dqdPE6 <= 32'd0;
         minv_block_reg_R2_C3_dqdPE6 <= 32'd0;
         minv_block_reg_R2_C4_dqdPE6 <= 32'd0;
         minv_block_reg_R2_C5_dqdPE6 <= 32'd0;
         minv_block_reg_R2_C6_dqdPE6 <= 32'd0;
         minv_block_reg_R2_C7_dqdPE6 <= 32'd0;
         minv_block_reg_R3_C1_dqdPE6 <= 32'd0;
         minv_block_reg_R3_C2_dqdPE6 <= 32'd0;
         minv_block_reg_R3_C3_dqdPE6 <= 32'd0;
         minv_block_reg_R3_C4_dqdPE6 <= 32'd0;
         minv_block_reg_R3_C5_dqdPE6 <= 32'd0;
         minv_block_reg_R3_C6_dqdPE6 <= 32'd0;
         minv_block_reg_R3_C7_dqdPE6 <= 32'd0;
         minv_block_reg_R4_C1_dqdPE6 <= 32'd0;
         minv_block_reg_R4_C2_dqdPE6 <= 32'd0;
         minv_block_reg_R4_C3_dqdPE6 <= 32'd0;
         minv_block_reg_R4_C4_dqdPE6 <= 32'd0;
         minv_block_reg_R4_C5_dqdPE6 <= 32'd0;
         minv_block_reg_R4_C6_dqdPE6 <= 32'd0;
         minv_block_reg_R4_C7_dqdPE6 <= 32'd0;
         minv_block_reg_R5_C1_dqdPE6 <= 32'd0;
         minv_block_reg_R5_C2_dqdPE6 <= 32'd0;
         minv_block_reg_R5_C3_dqdPE6 <= 32'd0;
         minv_block_reg_R5_C4_dqdPE6 <= 32'd0;
         minv_block_reg_R5_C5_dqdPE6 <= 32'd0;
         minv_block_reg_R5_C6_dqdPE6 <= 32'd0;
         minv_block_reg_R5_C7_dqdPE6 <= 32'd0;
         minv_block_reg_R6_C1_dqdPE6 <= 32'd0;
         minv_block_reg_R6_C2_dqdPE6 <= 32'd0;
         minv_block_reg_R6_C3_dqdPE6 <= 32'd0;
         minv_block_reg_R6_C4_dqdPE6 <= 32'd0;
         minv_block_reg_R6_C5_dqdPE6 <= 32'd0;
         minv_block_reg_R6_C6_dqdPE6 <= 32'd0;
         minv_block_reg_R6_C7_dqdPE6 <= 32'd0;
         minv_block_reg_R7_C1_dqdPE6 <= 32'd0;
         minv_block_reg_R7_C2_dqdPE6 <= 32'd0;
         minv_block_reg_R7_C3_dqdPE6 <= 32'd0;
         minv_block_reg_R7_C4_dqdPE6 <= 32'd0;
         minv_block_reg_R7_C5_dqdPE6 <= 32'd0;
         minv_block_reg_R7_C6_dqdPE6 <= 32'd0;
         minv_block_reg_R7_C7_dqdPE6 <= 32'd0;
         dtau_vec_reg_R1_dqdPE6 <= 32'd0;
         dtau_vec_reg_R2_dqdPE6 <= 32'd0;
         dtau_vec_reg_R3_dqdPE6 <= 32'd0;
         dtau_vec_reg_R4_dqdPE6 <= 32'd0;
         dtau_vec_reg_R5_dqdPE6 <= 32'd0;
         dtau_vec_reg_R6_dqdPE6 <= 32'd0;
         dtau_vec_reg_R7_dqdPE6 <= 32'd0;
         // dqdPE7
         minv_block_reg_R1_C1_dqdPE7 <= 32'd0;
         minv_block_reg_R1_C2_dqdPE7 <= 32'd0;
         minv_block_reg_R1_C3_dqdPE7 <= 32'd0;
         minv_block_reg_R1_C4_dqdPE7 <= 32'd0;
         minv_block_reg_R1_C5_dqdPE7 <= 32'd0;
         minv_block_reg_R1_C6_dqdPE7 <= 32'd0;
         minv_block_reg_R1_C7_dqdPE7 <= 32'd0;
         minv_block_reg_R2_C1_dqdPE7 <= 32'd0;
         minv_block_reg_R2_C2_dqdPE7 <= 32'd0;
         minv_block_reg_R2_C3_dqdPE7 <= 32'd0;
         minv_block_reg_R2_C4_dqdPE7 <= 32'd0;
         minv_block_reg_R2_C5_dqdPE7 <= 32'd0;
         minv_block_reg_R2_C6_dqdPE7 <= 32'd0;
         minv_block_reg_R2_C7_dqdPE7 <= 32'd0;
         minv_block_reg_R3_C1_dqdPE7 <= 32'd0;
         minv_block_reg_R3_C2_dqdPE7 <= 32'd0;
         minv_block_reg_R3_C3_dqdPE7 <= 32'd0;
         minv_block_reg_R3_C4_dqdPE7 <= 32'd0;
         minv_block_reg_R3_C5_dqdPE7 <= 32'd0;
         minv_block_reg_R3_C6_dqdPE7 <= 32'd0;
         minv_block_reg_R3_C7_dqdPE7 <= 32'd0;
         minv_block_reg_R4_C1_dqdPE7 <= 32'd0;
         minv_block_reg_R4_C2_dqdPE7 <= 32'd0;
         minv_block_reg_R4_C3_dqdPE7 <= 32'd0;
         minv_block_reg_R4_C4_dqdPE7 <= 32'd0;
         minv_block_reg_R4_C5_dqdPE7 <= 32'd0;
         minv_block_reg_R4_C6_dqdPE7 <= 32'd0;
         minv_block_reg_R4_C7_dqdPE7 <= 32'd0;
         minv_block_reg_R5_C1_dqdPE7 <= 32'd0;
         minv_block_reg_R5_C2_dqdPE7 <= 32'd0;
         minv_block_reg_R5_C3_dqdPE7 <= 32'd0;
         minv_block_reg_R5_C4_dqdPE7 <= 32'd0;
         minv_block_reg_R5_C5_dqdPE7 <= 32'd0;
         minv_block_reg_R5_C6_dqdPE7 <= 32'd0;
         minv_block_reg_R5_C7_dqdPE7 <= 32'd0;
         minv_block_reg_R6_C1_dqdPE7 <= 32'd0;
         minv_block_reg_R6_C2_dqdPE7 <= 32'd0;
         minv_block_reg_R6_C3_dqdPE7 <= 32'd0;
         minv_block_reg_R6_C4_dqdPE7 <= 32'd0;
         minv_block_reg_R6_C5_dqdPE7 <= 32'd0;
         minv_block_reg_R6_C6_dqdPE7 <= 32'd0;
         minv_block_reg_R6_C7_dqdPE7 <= 32'd0;
         minv_block_reg_R7_C1_dqdPE7 <= 32'd0;
         minv_block_reg_R7_C2_dqdPE7 <= 32'd0;
         minv_block_reg_R7_C3_dqdPE7 <= 32'd0;
         minv_block_reg_R7_C4_dqdPE7 <= 32'd0;
         minv_block_reg_R7_C5_dqdPE7 <= 32'd0;
         minv_block_reg_R7_C6_dqdPE7 <= 32'd0;
         minv_block_reg_R7_C7_dqdPE7 <= 32'd0;
         dtau_vec_reg_R1_dqdPE7 <= 32'd0;
         dtau_vec_reg_R2_dqdPE7 <= 32'd0;
         dtau_vec_reg_R3_dqdPE7 <= 32'd0;
         dtau_vec_reg_R4_dqdPE7 <= 32'd0;
         dtau_vec_reg_R5_dqdPE7 <= 32'd0;
         dtau_vec_reg_R6_dqdPE7 <= 32'd0;
         dtau_vec_reg_R7_dqdPE7 <= 32'd0;
         //---------------------------------------------------------------------
      end
      else
      begin
         // inputs
         get_data_reg <= get_data_next;
         get_data_minv_reg <= get_data_minv_next;
         // output
         output_ready_reg <= output_ready_next;
         output_ready_minv_reg <= output_ready_minv_next;
         // minv
         minv_bool_reg <= minv_bool_next;
         // state
         state_reg      <= state_next;
         state_minv_reg <= state_minv_next;
         //---------------------------------------------------------------------
         // rnea external inputs
         //---------------------------------------------------------------------
         // rnea
         link_reg_rnea <= link_next_rnea;
         sinq_val_reg_rnea <= sinq_val_next_rnea;
         cosq_val_reg_rnea <= cosq_val_next_rnea;
         // f updated curr
         f_upd_curr_vec_reg_AX_rnea <= f_upd_curr_vec_next_AX_rnea;
         f_upd_curr_vec_reg_AY_rnea <= f_upd_curr_vec_next_AY_rnea;
         f_upd_curr_vec_reg_AZ_rnea <= f_upd_curr_vec_next_AZ_rnea;
         f_upd_curr_vec_reg_LX_rnea <= f_upd_curr_vec_next_LX_rnea;
         f_upd_curr_vec_reg_LY_rnea <= f_upd_curr_vec_next_LY_rnea;
         f_upd_curr_vec_reg_LZ_rnea <= f_upd_curr_vec_next_LZ_rnea;
         // f prev
         f_prev_vec_reg_AX_rnea <= f_prev_vec_next_AX_rnea;
         f_prev_vec_reg_AY_rnea <= f_prev_vec_next_AY_rnea;
         f_prev_vec_reg_AZ_rnea <= f_prev_vec_next_AZ_rnea;
         f_prev_vec_reg_LX_rnea <= f_prev_vec_next_LX_rnea;
         f_prev_vec_reg_LY_rnea <= f_prev_vec_next_LY_rnea;
         f_prev_vec_reg_LZ_rnea <= f_prev_vec_next_LZ_rnea;
         //---------------------------------------------------------------------
         // dq external inputs
         //---------------------------------------------------------------------
         // dqPE1
         link_reg_dqPE1 <= link_next_dqPE1;
         derv_reg_dqPE1 <= derv_next_dqPE1;
         sinq_val_reg_dqPE1 <= sinq_val_next_dqPE1;
         cosq_val_reg_dqPE1 <= cosq_val_next_dqPE1;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE1 <= f_upd_curr_vec_next_AX_dqPE1;
         f_upd_curr_vec_reg_AY_dqPE1 <= f_upd_curr_vec_next_AY_dqPE1;
         f_upd_curr_vec_reg_AZ_dqPE1 <= f_upd_curr_vec_next_AZ_dqPE1;
         f_upd_curr_vec_reg_LX_dqPE1 <= f_upd_curr_vec_next_LX_dqPE1;
         f_upd_curr_vec_reg_LY_dqPE1 <= f_upd_curr_vec_next_LY_dqPE1;
         f_upd_curr_vec_reg_LZ_dqPE1 <= f_upd_curr_vec_next_LZ_dqPE1;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE1 <= dfdq_prev_vec_next_AX_dqPE1;
         dfdq_prev_vec_reg_AY_dqPE1 <= dfdq_prev_vec_next_AY_dqPE1;
         dfdq_prev_vec_reg_AZ_dqPE1 <= dfdq_prev_vec_next_AZ_dqPE1;
         dfdq_prev_vec_reg_LX_dqPE1 <= dfdq_prev_vec_next_LX_dqPE1;
         dfdq_prev_vec_reg_LY_dqPE1 <= dfdq_prev_vec_next_LY_dqPE1;
         dfdq_prev_vec_reg_LZ_dqPE1 <= dfdq_prev_vec_next_LZ_dqPE1;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE1 <= dfdq_upd_curr_vec_next_AX_dqPE1;
         dfdq_upd_curr_vec_reg_AY_dqPE1 <= dfdq_upd_curr_vec_next_AY_dqPE1;
         dfdq_upd_curr_vec_reg_AZ_dqPE1 <= dfdq_upd_curr_vec_next_AZ_dqPE1;
         dfdq_upd_curr_vec_reg_LX_dqPE1 <= dfdq_upd_curr_vec_next_LX_dqPE1;
         dfdq_upd_curr_vec_reg_LY_dqPE1 <= dfdq_upd_curr_vec_next_LY_dqPE1;
         dfdq_upd_curr_vec_reg_LZ_dqPE1 <= dfdq_upd_curr_vec_next_LZ_dqPE1;
         // dqPE2
         link_reg_dqPE2 <= link_next_dqPE2;
         derv_reg_dqPE2 <= derv_next_dqPE2;
         sinq_val_reg_dqPE2 <= sinq_val_next_dqPE2;
         cosq_val_reg_dqPE2 <= cosq_val_next_dqPE2;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE2 <= f_upd_curr_vec_next_AX_dqPE2;
         f_upd_curr_vec_reg_AY_dqPE2 <= f_upd_curr_vec_next_AY_dqPE2;
         f_upd_curr_vec_reg_AZ_dqPE2 <= f_upd_curr_vec_next_AZ_dqPE2;
         f_upd_curr_vec_reg_LX_dqPE2 <= f_upd_curr_vec_next_LX_dqPE2;
         f_upd_curr_vec_reg_LY_dqPE2 <= f_upd_curr_vec_next_LY_dqPE2;
         f_upd_curr_vec_reg_LZ_dqPE2 <= f_upd_curr_vec_next_LZ_dqPE2;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE2 <= dfdq_prev_vec_next_AX_dqPE2;
         dfdq_prev_vec_reg_AY_dqPE2 <= dfdq_prev_vec_next_AY_dqPE2;
         dfdq_prev_vec_reg_AZ_dqPE2 <= dfdq_prev_vec_next_AZ_dqPE2;
         dfdq_prev_vec_reg_LX_dqPE2 <= dfdq_prev_vec_next_LX_dqPE2;
         dfdq_prev_vec_reg_LY_dqPE2 <= dfdq_prev_vec_next_LY_dqPE2;
         dfdq_prev_vec_reg_LZ_dqPE2 <= dfdq_prev_vec_next_LZ_dqPE2;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE2 <= dfdq_upd_curr_vec_next_AX_dqPE2;
         dfdq_upd_curr_vec_reg_AY_dqPE2 <= dfdq_upd_curr_vec_next_AY_dqPE2;
         dfdq_upd_curr_vec_reg_AZ_dqPE2 <= dfdq_upd_curr_vec_next_AZ_dqPE2;
         dfdq_upd_curr_vec_reg_LX_dqPE2 <= dfdq_upd_curr_vec_next_LX_dqPE2;
         dfdq_upd_curr_vec_reg_LY_dqPE2 <= dfdq_upd_curr_vec_next_LY_dqPE2;
         dfdq_upd_curr_vec_reg_LZ_dqPE2 <= dfdq_upd_curr_vec_next_LZ_dqPE2;
         // dqPE3
         link_reg_dqPE3 <= link_next_dqPE3;
         derv_reg_dqPE3 <= derv_next_dqPE3;
         sinq_val_reg_dqPE3 <= sinq_val_next_dqPE3;
         cosq_val_reg_dqPE3 <= cosq_val_next_dqPE3;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE3 <= f_upd_curr_vec_next_AX_dqPE3;
         f_upd_curr_vec_reg_AY_dqPE3 <= f_upd_curr_vec_next_AY_dqPE3;
         f_upd_curr_vec_reg_AZ_dqPE3 <= f_upd_curr_vec_next_AZ_dqPE3;
         f_upd_curr_vec_reg_LX_dqPE3 <= f_upd_curr_vec_next_LX_dqPE3;
         f_upd_curr_vec_reg_LY_dqPE3 <= f_upd_curr_vec_next_LY_dqPE3;
         f_upd_curr_vec_reg_LZ_dqPE3 <= f_upd_curr_vec_next_LZ_dqPE3;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE3 <= dfdq_prev_vec_next_AX_dqPE3;
         dfdq_prev_vec_reg_AY_dqPE3 <= dfdq_prev_vec_next_AY_dqPE3;
         dfdq_prev_vec_reg_AZ_dqPE3 <= dfdq_prev_vec_next_AZ_dqPE3;
         dfdq_prev_vec_reg_LX_dqPE3 <= dfdq_prev_vec_next_LX_dqPE3;
         dfdq_prev_vec_reg_LY_dqPE3 <= dfdq_prev_vec_next_LY_dqPE3;
         dfdq_prev_vec_reg_LZ_dqPE3 <= dfdq_prev_vec_next_LZ_dqPE3;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE3 <= dfdq_upd_curr_vec_next_AX_dqPE3;
         dfdq_upd_curr_vec_reg_AY_dqPE3 <= dfdq_upd_curr_vec_next_AY_dqPE3;
         dfdq_upd_curr_vec_reg_AZ_dqPE3 <= dfdq_upd_curr_vec_next_AZ_dqPE3;
         dfdq_upd_curr_vec_reg_LX_dqPE3 <= dfdq_upd_curr_vec_next_LX_dqPE3;
         dfdq_upd_curr_vec_reg_LY_dqPE3 <= dfdq_upd_curr_vec_next_LY_dqPE3;
         dfdq_upd_curr_vec_reg_LZ_dqPE3 <= dfdq_upd_curr_vec_next_LZ_dqPE3;
         // dqPE4
         link_reg_dqPE4 <= link_next_dqPE4;
         derv_reg_dqPE4 <= derv_next_dqPE4;
         sinq_val_reg_dqPE4 <= sinq_val_next_dqPE4;
         cosq_val_reg_dqPE4 <= cosq_val_next_dqPE4;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE4 <= f_upd_curr_vec_next_AX_dqPE4;
         f_upd_curr_vec_reg_AY_dqPE4 <= f_upd_curr_vec_next_AY_dqPE4;
         f_upd_curr_vec_reg_AZ_dqPE4 <= f_upd_curr_vec_next_AZ_dqPE4;
         f_upd_curr_vec_reg_LX_dqPE4 <= f_upd_curr_vec_next_LX_dqPE4;
         f_upd_curr_vec_reg_LY_dqPE4 <= f_upd_curr_vec_next_LY_dqPE4;
         f_upd_curr_vec_reg_LZ_dqPE4 <= f_upd_curr_vec_next_LZ_dqPE4;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE4 <= dfdq_prev_vec_next_AX_dqPE4;
         dfdq_prev_vec_reg_AY_dqPE4 <= dfdq_prev_vec_next_AY_dqPE4;
         dfdq_prev_vec_reg_AZ_dqPE4 <= dfdq_prev_vec_next_AZ_dqPE4;
         dfdq_prev_vec_reg_LX_dqPE4 <= dfdq_prev_vec_next_LX_dqPE4;
         dfdq_prev_vec_reg_LY_dqPE4 <= dfdq_prev_vec_next_LY_dqPE4;
         dfdq_prev_vec_reg_LZ_dqPE4 <= dfdq_prev_vec_next_LZ_dqPE4;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE4 <= dfdq_upd_curr_vec_next_AX_dqPE4;
         dfdq_upd_curr_vec_reg_AY_dqPE4 <= dfdq_upd_curr_vec_next_AY_dqPE4;
         dfdq_upd_curr_vec_reg_AZ_dqPE4 <= dfdq_upd_curr_vec_next_AZ_dqPE4;
         dfdq_upd_curr_vec_reg_LX_dqPE4 <= dfdq_upd_curr_vec_next_LX_dqPE4;
         dfdq_upd_curr_vec_reg_LY_dqPE4 <= dfdq_upd_curr_vec_next_LY_dqPE4;
         dfdq_upd_curr_vec_reg_LZ_dqPE4 <= dfdq_upd_curr_vec_next_LZ_dqPE4;
         // dqPE5
         link_reg_dqPE5 <= link_next_dqPE5;
         derv_reg_dqPE5 <= derv_next_dqPE5;
         sinq_val_reg_dqPE5 <= sinq_val_next_dqPE5;
         cosq_val_reg_dqPE5 <= cosq_val_next_dqPE5;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE5 <= f_upd_curr_vec_next_AX_dqPE5;
         f_upd_curr_vec_reg_AY_dqPE5 <= f_upd_curr_vec_next_AY_dqPE5;
         f_upd_curr_vec_reg_AZ_dqPE5 <= f_upd_curr_vec_next_AZ_dqPE5;
         f_upd_curr_vec_reg_LX_dqPE5 <= f_upd_curr_vec_next_LX_dqPE5;
         f_upd_curr_vec_reg_LY_dqPE5 <= f_upd_curr_vec_next_LY_dqPE5;
         f_upd_curr_vec_reg_LZ_dqPE5 <= f_upd_curr_vec_next_LZ_dqPE5;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE5 <= dfdq_prev_vec_next_AX_dqPE5;
         dfdq_prev_vec_reg_AY_dqPE5 <= dfdq_prev_vec_next_AY_dqPE5;
         dfdq_prev_vec_reg_AZ_dqPE5 <= dfdq_prev_vec_next_AZ_dqPE5;
         dfdq_prev_vec_reg_LX_dqPE5 <= dfdq_prev_vec_next_LX_dqPE5;
         dfdq_prev_vec_reg_LY_dqPE5 <= dfdq_prev_vec_next_LY_dqPE5;
         dfdq_prev_vec_reg_LZ_dqPE5 <= dfdq_prev_vec_next_LZ_dqPE5;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE5 <= dfdq_upd_curr_vec_next_AX_dqPE5;
         dfdq_upd_curr_vec_reg_AY_dqPE5 <= dfdq_upd_curr_vec_next_AY_dqPE5;
         dfdq_upd_curr_vec_reg_AZ_dqPE5 <= dfdq_upd_curr_vec_next_AZ_dqPE5;
         dfdq_upd_curr_vec_reg_LX_dqPE5 <= dfdq_upd_curr_vec_next_LX_dqPE5;
         dfdq_upd_curr_vec_reg_LY_dqPE5 <= dfdq_upd_curr_vec_next_LY_dqPE5;
         dfdq_upd_curr_vec_reg_LZ_dqPE5 <= dfdq_upd_curr_vec_next_LZ_dqPE5;
         // dqPE6
         link_reg_dqPE6 <= link_next_dqPE6;
         derv_reg_dqPE6 <= derv_next_dqPE6;
         sinq_val_reg_dqPE6 <= sinq_val_next_dqPE6;
         cosq_val_reg_dqPE6 <= cosq_val_next_dqPE6;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE6 <= f_upd_curr_vec_next_AX_dqPE6;
         f_upd_curr_vec_reg_AY_dqPE6 <= f_upd_curr_vec_next_AY_dqPE6;
         f_upd_curr_vec_reg_AZ_dqPE6 <= f_upd_curr_vec_next_AZ_dqPE6;
         f_upd_curr_vec_reg_LX_dqPE6 <= f_upd_curr_vec_next_LX_dqPE6;
         f_upd_curr_vec_reg_LY_dqPE6 <= f_upd_curr_vec_next_LY_dqPE6;
         f_upd_curr_vec_reg_LZ_dqPE6 <= f_upd_curr_vec_next_LZ_dqPE6;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE6 <= dfdq_prev_vec_next_AX_dqPE6;
         dfdq_prev_vec_reg_AY_dqPE6 <= dfdq_prev_vec_next_AY_dqPE6;
         dfdq_prev_vec_reg_AZ_dqPE6 <= dfdq_prev_vec_next_AZ_dqPE6;
         dfdq_prev_vec_reg_LX_dqPE6 <= dfdq_prev_vec_next_LX_dqPE6;
         dfdq_prev_vec_reg_LY_dqPE6 <= dfdq_prev_vec_next_LY_dqPE6;
         dfdq_prev_vec_reg_LZ_dqPE6 <= dfdq_prev_vec_next_LZ_dqPE6;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE6 <= dfdq_upd_curr_vec_next_AX_dqPE6;
         dfdq_upd_curr_vec_reg_AY_dqPE6 <= dfdq_upd_curr_vec_next_AY_dqPE6;
         dfdq_upd_curr_vec_reg_AZ_dqPE6 <= dfdq_upd_curr_vec_next_AZ_dqPE6;
         dfdq_upd_curr_vec_reg_LX_dqPE6 <= dfdq_upd_curr_vec_next_LX_dqPE6;
         dfdq_upd_curr_vec_reg_LY_dqPE6 <= dfdq_upd_curr_vec_next_LY_dqPE6;
         dfdq_upd_curr_vec_reg_LZ_dqPE6 <= dfdq_upd_curr_vec_next_LZ_dqPE6;
         // dqPE7
         link_reg_dqPE7 <= link_next_dqPE7;
         derv_reg_dqPE7 <= derv_next_dqPE7;
         sinq_val_reg_dqPE7 <= sinq_val_next_dqPE7;
         cosq_val_reg_dqPE7 <= cosq_val_next_dqPE7;
         // f updated curr
         f_upd_curr_vec_reg_AX_dqPE7 <= f_upd_curr_vec_next_AX_dqPE7;
         f_upd_curr_vec_reg_AY_dqPE7 <= f_upd_curr_vec_next_AY_dqPE7;
         f_upd_curr_vec_reg_AZ_dqPE7 <= f_upd_curr_vec_next_AZ_dqPE7;
         f_upd_curr_vec_reg_LX_dqPE7 <= f_upd_curr_vec_next_LX_dqPE7;
         f_upd_curr_vec_reg_LY_dqPE7 <= f_upd_curr_vec_next_LY_dqPE7;
         f_upd_curr_vec_reg_LZ_dqPE7 <= f_upd_curr_vec_next_LZ_dqPE7;
         // df prev
         dfdq_prev_vec_reg_AX_dqPE7 <= dfdq_prev_vec_next_AX_dqPE7;
         dfdq_prev_vec_reg_AY_dqPE7 <= dfdq_prev_vec_next_AY_dqPE7;
         dfdq_prev_vec_reg_AZ_dqPE7 <= dfdq_prev_vec_next_AZ_dqPE7;
         dfdq_prev_vec_reg_LX_dqPE7 <= dfdq_prev_vec_next_LX_dqPE7;
         dfdq_prev_vec_reg_LY_dqPE7 <= dfdq_prev_vec_next_LY_dqPE7;
         dfdq_prev_vec_reg_LZ_dqPE7 <= dfdq_prev_vec_next_LZ_dqPE7;
         // f updated curr
         dfdq_upd_curr_vec_reg_AX_dqPE7 <= dfdq_upd_curr_vec_next_AX_dqPE7;
         dfdq_upd_curr_vec_reg_AY_dqPE7 <= dfdq_upd_curr_vec_next_AY_dqPE7;
         dfdq_upd_curr_vec_reg_AZ_dqPE7 <= dfdq_upd_curr_vec_next_AZ_dqPE7;
         dfdq_upd_curr_vec_reg_LX_dqPE7 <= dfdq_upd_curr_vec_next_LX_dqPE7;
         dfdq_upd_curr_vec_reg_LY_dqPE7 <= dfdq_upd_curr_vec_next_LY_dqPE7;
         dfdq_upd_curr_vec_reg_LZ_dqPE7 <= dfdq_upd_curr_vec_next_LZ_dqPE7;
         //---------------------------------------------------------------------
         // dqd external inputs
         //---------------------------------------------------------------------
         // dqdPE1
         link_reg_dqdPE1 <= link_next_dqdPE1;
         derv_reg_dqdPE1 <= derv_next_dqdPE1;
         sinq_val_reg_dqdPE1 <= sinq_val_next_dqdPE1;
         cosq_val_reg_dqdPE1 <= cosq_val_next_dqdPE1;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE1 <= dfdqd_prev_vec_next_AX_dqdPE1;
         dfdqd_prev_vec_reg_AY_dqdPE1 <= dfdqd_prev_vec_next_AY_dqdPE1;
         dfdqd_prev_vec_reg_AZ_dqdPE1 <= dfdqd_prev_vec_next_AZ_dqdPE1;
         dfdqd_prev_vec_reg_LX_dqdPE1 <= dfdqd_prev_vec_next_LX_dqdPE1;
         dfdqd_prev_vec_reg_LY_dqdPE1 <= dfdqd_prev_vec_next_LY_dqdPE1;
         dfdqd_prev_vec_reg_LZ_dqdPE1 <= dfdqd_prev_vec_next_LZ_dqdPE1;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE1 <= dfdqd_upd_curr_vec_next_AX_dqdPE1;
         dfdqd_upd_curr_vec_reg_AY_dqdPE1 <= dfdqd_upd_curr_vec_next_AY_dqdPE1;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE1 <= dfdqd_upd_curr_vec_next_AZ_dqdPE1;
         dfdqd_upd_curr_vec_reg_LX_dqdPE1 <= dfdqd_upd_curr_vec_next_LX_dqdPE1;
         dfdqd_upd_curr_vec_reg_LY_dqdPE1 <= dfdqd_upd_curr_vec_next_LY_dqdPE1;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE1 <= dfdqd_upd_curr_vec_next_LZ_dqdPE1;
         // dqdPE2
         link_reg_dqdPE2 <= link_next_dqdPE2;
         derv_reg_dqdPE2 <= derv_next_dqdPE2;
         sinq_val_reg_dqdPE2 <= sinq_val_next_dqdPE2;
         cosq_val_reg_dqdPE2 <= cosq_val_next_dqdPE2;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE2 <= dfdqd_prev_vec_next_AX_dqdPE2;
         dfdqd_prev_vec_reg_AY_dqdPE2 <= dfdqd_prev_vec_next_AY_dqdPE2;
         dfdqd_prev_vec_reg_AZ_dqdPE2 <= dfdqd_prev_vec_next_AZ_dqdPE2;
         dfdqd_prev_vec_reg_LX_dqdPE2 <= dfdqd_prev_vec_next_LX_dqdPE2;
         dfdqd_prev_vec_reg_LY_dqdPE2 <= dfdqd_prev_vec_next_LY_dqdPE2;
         dfdqd_prev_vec_reg_LZ_dqdPE2 <= dfdqd_prev_vec_next_LZ_dqdPE2;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE2 <= dfdqd_upd_curr_vec_next_AX_dqdPE2;
         dfdqd_upd_curr_vec_reg_AY_dqdPE2 <= dfdqd_upd_curr_vec_next_AY_dqdPE2;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE2 <= dfdqd_upd_curr_vec_next_AZ_dqdPE2;
         dfdqd_upd_curr_vec_reg_LX_dqdPE2 <= dfdqd_upd_curr_vec_next_LX_dqdPE2;
         dfdqd_upd_curr_vec_reg_LY_dqdPE2 <= dfdqd_upd_curr_vec_next_LY_dqdPE2;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE2 <= dfdqd_upd_curr_vec_next_LZ_dqdPE2;
         // dqdPE3
         link_reg_dqdPE3 <= link_next_dqdPE3;
         derv_reg_dqdPE3 <= derv_next_dqdPE3;
         sinq_val_reg_dqdPE3 <= sinq_val_next_dqdPE3;
         cosq_val_reg_dqdPE3 <= cosq_val_next_dqdPE3;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE3 <= dfdqd_prev_vec_next_AX_dqdPE3;
         dfdqd_prev_vec_reg_AY_dqdPE3 <= dfdqd_prev_vec_next_AY_dqdPE3;
         dfdqd_prev_vec_reg_AZ_dqdPE3 <= dfdqd_prev_vec_next_AZ_dqdPE3;
         dfdqd_prev_vec_reg_LX_dqdPE3 <= dfdqd_prev_vec_next_LX_dqdPE3;
         dfdqd_prev_vec_reg_LY_dqdPE3 <= dfdqd_prev_vec_next_LY_dqdPE3;
         dfdqd_prev_vec_reg_LZ_dqdPE3 <= dfdqd_prev_vec_next_LZ_dqdPE3;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE3 <= dfdqd_upd_curr_vec_next_AX_dqdPE3;
         dfdqd_upd_curr_vec_reg_AY_dqdPE3 <= dfdqd_upd_curr_vec_next_AY_dqdPE3;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE3 <= dfdqd_upd_curr_vec_next_AZ_dqdPE3;
         dfdqd_upd_curr_vec_reg_LX_dqdPE3 <= dfdqd_upd_curr_vec_next_LX_dqdPE3;
         dfdqd_upd_curr_vec_reg_LY_dqdPE3 <= dfdqd_upd_curr_vec_next_LY_dqdPE3;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE3 <= dfdqd_upd_curr_vec_next_LZ_dqdPE3;
         // dqdPE4
         link_reg_dqdPE4 <= link_next_dqdPE4;
         derv_reg_dqdPE4 <= derv_next_dqdPE4;
         sinq_val_reg_dqdPE4 <= sinq_val_next_dqdPE4;
         cosq_val_reg_dqdPE4 <= cosq_val_next_dqdPE4;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE4 <= dfdqd_prev_vec_next_AX_dqdPE4;
         dfdqd_prev_vec_reg_AY_dqdPE4 <= dfdqd_prev_vec_next_AY_dqdPE4;
         dfdqd_prev_vec_reg_AZ_dqdPE4 <= dfdqd_prev_vec_next_AZ_dqdPE4;
         dfdqd_prev_vec_reg_LX_dqdPE4 <= dfdqd_prev_vec_next_LX_dqdPE4;
         dfdqd_prev_vec_reg_LY_dqdPE4 <= dfdqd_prev_vec_next_LY_dqdPE4;
         dfdqd_prev_vec_reg_LZ_dqdPE4 <= dfdqd_prev_vec_next_LZ_dqdPE4;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE4 <= dfdqd_upd_curr_vec_next_AX_dqdPE4;
         dfdqd_upd_curr_vec_reg_AY_dqdPE4 <= dfdqd_upd_curr_vec_next_AY_dqdPE4;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE4 <= dfdqd_upd_curr_vec_next_AZ_dqdPE4;
         dfdqd_upd_curr_vec_reg_LX_dqdPE4 <= dfdqd_upd_curr_vec_next_LX_dqdPE4;
         dfdqd_upd_curr_vec_reg_LY_dqdPE4 <= dfdqd_upd_curr_vec_next_LY_dqdPE4;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE4 <= dfdqd_upd_curr_vec_next_LZ_dqdPE4;
         // dqdPE5
         link_reg_dqdPE5 <= link_next_dqdPE5;
         derv_reg_dqdPE5 <= derv_next_dqdPE5;
         sinq_val_reg_dqdPE5 <= sinq_val_next_dqdPE5;
         cosq_val_reg_dqdPE5 <= cosq_val_next_dqdPE5;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE5 <= dfdqd_prev_vec_next_AX_dqdPE5;
         dfdqd_prev_vec_reg_AY_dqdPE5 <= dfdqd_prev_vec_next_AY_dqdPE5;
         dfdqd_prev_vec_reg_AZ_dqdPE5 <= dfdqd_prev_vec_next_AZ_dqdPE5;
         dfdqd_prev_vec_reg_LX_dqdPE5 <= dfdqd_prev_vec_next_LX_dqdPE5;
         dfdqd_prev_vec_reg_LY_dqdPE5 <= dfdqd_prev_vec_next_LY_dqdPE5;
         dfdqd_prev_vec_reg_LZ_dqdPE5 <= dfdqd_prev_vec_next_LZ_dqdPE5;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE5 <= dfdqd_upd_curr_vec_next_AX_dqdPE5;
         dfdqd_upd_curr_vec_reg_AY_dqdPE5 <= dfdqd_upd_curr_vec_next_AY_dqdPE5;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE5 <= dfdqd_upd_curr_vec_next_AZ_dqdPE5;
         dfdqd_upd_curr_vec_reg_LX_dqdPE5 <= dfdqd_upd_curr_vec_next_LX_dqdPE5;
         dfdqd_upd_curr_vec_reg_LY_dqdPE5 <= dfdqd_upd_curr_vec_next_LY_dqdPE5;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE5 <= dfdqd_upd_curr_vec_next_LZ_dqdPE5;
         // dqdPE6
         link_reg_dqdPE6 <= link_next_dqdPE6;
         derv_reg_dqdPE6 <= derv_next_dqdPE6;
         sinq_val_reg_dqdPE6 <= sinq_val_next_dqdPE6;
         cosq_val_reg_dqdPE6 <= cosq_val_next_dqdPE6;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE6 <= dfdqd_prev_vec_next_AX_dqdPE6;
         dfdqd_prev_vec_reg_AY_dqdPE6 <= dfdqd_prev_vec_next_AY_dqdPE6;
         dfdqd_prev_vec_reg_AZ_dqdPE6 <= dfdqd_prev_vec_next_AZ_dqdPE6;
         dfdqd_prev_vec_reg_LX_dqdPE6 <= dfdqd_prev_vec_next_LX_dqdPE6;
         dfdqd_prev_vec_reg_LY_dqdPE6 <= dfdqd_prev_vec_next_LY_dqdPE6;
         dfdqd_prev_vec_reg_LZ_dqdPE6 <= dfdqd_prev_vec_next_LZ_dqdPE6;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE6 <= dfdqd_upd_curr_vec_next_AX_dqdPE6;
         dfdqd_upd_curr_vec_reg_AY_dqdPE6 <= dfdqd_upd_curr_vec_next_AY_dqdPE6;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE6 <= dfdqd_upd_curr_vec_next_AZ_dqdPE6;
         dfdqd_upd_curr_vec_reg_LX_dqdPE6 <= dfdqd_upd_curr_vec_next_LX_dqdPE6;
         dfdqd_upd_curr_vec_reg_LY_dqdPE6 <= dfdqd_upd_curr_vec_next_LY_dqdPE6;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE6 <= dfdqd_upd_curr_vec_next_LZ_dqdPE6;
         // dqdPE7
         link_reg_dqdPE7 <= link_next_dqdPE7;
         derv_reg_dqdPE7 <= derv_next_dqdPE7;
         sinq_val_reg_dqdPE7 <= sinq_val_next_dqdPE7;
         cosq_val_reg_dqdPE7 <= cosq_val_next_dqdPE7;
         // df prev
         dfdqd_prev_vec_reg_AX_dqdPE7 <= dfdqd_prev_vec_next_AX_dqdPE7;
         dfdqd_prev_vec_reg_AY_dqdPE7 <= dfdqd_prev_vec_next_AY_dqdPE7;
         dfdqd_prev_vec_reg_AZ_dqdPE7 <= dfdqd_prev_vec_next_AZ_dqdPE7;
         dfdqd_prev_vec_reg_LX_dqdPE7 <= dfdqd_prev_vec_next_LX_dqdPE7;
         dfdqd_prev_vec_reg_LY_dqdPE7 <= dfdqd_prev_vec_next_LY_dqdPE7;
         dfdqd_prev_vec_reg_LZ_dqdPE7 <= dfdqd_prev_vec_next_LZ_dqdPE7;
         // f updated curr
         dfdqd_upd_curr_vec_reg_AX_dqdPE7 <= dfdqd_upd_curr_vec_next_AX_dqdPE7;
         dfdqd_upd_curr_vec_reg_AY_dqdPE7 <= dfdqd_upd_curr_vec_next_AY_dqdPE7;
         dfdqd_upd_curr_vec_reg_AZ_dqdPE7 <= dfdqd_upd_curr_vec_next_AZ_dqdPE7;
         dfdqd_upd_curr_vec_reg_LX_dqdPE7 <= dfdqd_upd_curr_vec_next_LX_dqdPE7;
         dfdqd_upd_curr_vec_reg_LY_dqdPE7 <= dfdqd_upd_curr_vec_next_LY_dqdPE7;
         dfdqd_upd_curr_vec_reg_LZ_dqdPE7 <= dfdqd_upd_curr_vec_next_LZ_dqdPE7;
         //---------------------------------------------------------------------
         // minv external inputs
         //---------------------------------------------------------------------
         // dqdPE1
         minv_block_reg_R1_C1_dqdPE1 <= minv_block_next_R1_C1_dqdPE1;
         minv_block_reg_R1_C2_dqdPE1 <= minv_block_next_R1_C2_dqdPE1;
         minv_block_reg_R1_C3_dqdPE1 <= minv_block_next_R1_C3_dqdPE1;
         minv_block_reg_R1_C4_dqdPE1 <= minv_block_next_R1_C4_dqdPE1;
         minv_block_reg_R1_C5_dqdPE1 <= minv_block_next_R1_C5_dqdPE1;
         minv_block_reg_R1_C6_dqdPE1 <= minv_block_next_R1_C6_dqdPE1;
         minv_block_reg_R1_C7_dqdPE1 <= minv_block_next_R1_C7_dqdPE1;
         minv_block_reg_R2_C1_dqdPE1 <= minv_block_next_R2_C1_dqdPE1;
         minv_block_reg_R2_C2_dqdPE1 <= minv_block_next_R2_C2_dqdPE1;
         minv_block_reg_R2_C3_dqdPE1 <= minv_block_next_R2_C3_dqdPE1;
         minv_block_reg_R2_C4_dqdPE1 <= minv_block_next_R2_C4_dqdPE1;
         minv_block_reg_R2_C5_dqdPE1 <= minv_block_next_R2_C5_dqdPE1;
         minv_block_reg_R2_C6_dqdPE1 <= minv_block_next_R2_C6_dqdPE1;
         minv_block_reg_R2_C7_dqdPE1 <= minv_block_next_R2_C7_dqdPE1;
         minv_block_reg_R3_C1_dqdPE1 <= minv_block_next_R3_C1_dqdPE1;
         minv_block_reg_R3_C2_dqdPE1 <= minv_block_next_R3_C2_dqdPE1;
         minv_block_reg_R3_C3_dqdPE1 <= minv_block_next_R3_C3_dqdPE1;
         minv_block_reg_R3_C4_dqdPE1 <= minv_block_next_R3_C4_dqdPE1;
         minv_block_reg_R3_C5_dqdPE1 <= minv_block_next_R3_C5_dqdPE1;
         minv_block_reg_R3_C6_dqdPE1 <= minv_block_next_R3_C6_dqdPE1;
         minv_block_reg_R3_C7_dqdPE1 <= minv_block_next_R3_C7_dqdPE1;
         minv_block_reg_R4_C1_dqdPE1 <= minv_block_next_R4_C1_dqdPE1;
         minv_block_reg_R4_C2_dqdPE1 <= minv_block_next_R4_C2_dqdPE1;
         minv_block_reg_R4_C3_dqdPE1 <= minv_block_next_R4_C3_dqdPE1;
         minv_block_reg_R4_C4_dqdPE1 <= minv_block_next_R4_C4_dqdPE1;
         minv_block_reg_R4_C5_dqdPE1 <= minv_block_next_R4_C5_dqdPE1;
         minv_block_reg_R4_C6_dqdPE1 <= minv_block_next_R4_C6_dqdPE1;
         minv_block_reg_R4_C7_dqdPE1 <= minv_block_next_R4_C7_dqdPE1;
         minv_block_reg_R5_C1_dqdPE1 <= minv_block_next_R5_C1_dqdPE1;
         minv_block_reg_R5_C2_dqdPE1 <= minv_block_next_R5_C2_dqdPE1;
         minv_block_reg_R5_C3_dqdPE1 <= minv_block_next_R5_C3_dqdPE1;
         minv_block_reg_R5_C4_dqdPE1 <= minv_block_next_R5_C4_dqdPE1;
         minv_block_reg_R5_C5_dqdPE1 <= minv_block_next_R5_C5_dqdPE1;
         minv_block_reg_R5_C6_dqdPE1 <= minv_block_next_R5_C6_dqdPE1;
         minv_block_reg_R5_C7_dqdPE1 <= minv_block_next_R5_C7_dqdPE1;
         minv_block_reg_R6_C1_dqdPE1 <= minv_block_next_R6_C1_dqdPE1;
         minv_block_reg_R6_C2_dqdPE1 <= minv_block_next_R6_C2_dqdPE1;
         minv_block_reg_R6_C3_dqdPE1 <= minv_block_next_R6_C3_dqdPE1;
         minv_block_reg_R6_C4_dqdPE1 <= minv_block_next_R6_C4_dqdPE1;
         minv_block_reg_R6_C5_dqdPE1 <= minv_block_next_R6_C5_dqdPE1;
         minv_block_reg_R6_C6_dqdPE1 <= minv_block_next_R6_C6_dqdPE1;
         minv_block_reg_R6_C7_dqdPE1 <= minv_block_next_R6_C7_dqdPE1;
         minv_block_reg_R7_C1_dqdPE1 <= minv_block_next_R7_C1_dqdPE1;
         minv_block_reg_R7_C2_dqdPE1 <= minv_block_next_R7_C2_dqdPE1;
         minv_block_reg_R7_C3_dqdPE1 <= minv_block_next_R7_C3_dqdPE1;
         minv_block_reg_R7_C4_dqdPE1 <= minv_block_next_R7_C4_dqdPE1;
         minv_block_reg_R7_C5_dqdPE1 <= minv_block_next_R7_C5_dqdPE1;
         minv_block_reg_R7_C6_dqdPE1 <= minv_block_next_R7_C6_dqdPE1;
         minv_block_reg_R7_C7_dqdPE1 <= minv_block_next_R7_C7_dqdPE1;
         dtau_vec_reg_R1_dqdPE1 <= dtau_vec_next_R1_dqdPE1;
         dtau_vec_reg_R2_dqdPE1 <= dtau_vec_next_R2_dqdPE1;
         dtau_vec_reg_R3_dqdPE1 <= dtau_vec_next_R3_dqdPE1;
         dtau_vec_reg_R4_dqdPE1 <= dtau_vec_next_R4_dqdPE1;
         dtau_vec_reg_R5_dqdPE1 <= dtau_vec_next_R5_dqdPE1;
         dtau_vec_reg_R6_dqdPE1 <= dtau_vec_next_R6_dqdPE1;
         dtau_vec_reg_R7_dqdPE1 <= dtau_vec_next_R7_dqdPE1;
         // dqdPE2
         minv_block_reg_R1_C1_dqdPE2 <= minv_block_next_R1_C1_dqdPE2;
         minv_block_reg_R1_C2_dqdPE2 <= minv_block_next_R1_C2_dqdPE2;
         minv_block_reg_R1_C3_dqdPE2 <= minv_block_next_R1_C3_dqdPE2;
         minv_block_reg_R1_C4_dqdPE2 <= minv_block_next_R1_C4_dqdPE2;
         minv_block_reg_R1_C5_dqdPE2 <= minv_block_next_R1_C5_dqdPE2;
         minv_block_reg_R1_C6_dqdPE2 <= minv_block_next_R1_C6_dqdPE2;
         minv_block_reg_R1_C7_dqdPE2 <= minv_block_next_R1_C7_dqdPE2;
         minv_block_reg_R2_C1_dqdPE2 <= minv_block_next_R2_C1_dqdPE2;
         minv_block_reg_R2_C2_dqdPE2 <= minv_block_next_R2_C2_dqdPE2;
         minv_block_reg_R2_C3_dqdPE2 <= minv_block_next_R2_C3_dqdPE2;
         minv_block_reg_R2_C4_dqdPE2 <= minv_block_next_R2_C4_dqdPE2;
         minv_block_reg_R2_C5_dqdPE2 <= minv_block_next_R2_C5_dqdPE2;
         minv_block_reg_R2_C6_dqdPE2 <= minv_block_next_R2_C6_dqdPE2;
         minv_block_reg_R2_C7_dqdPE2 <= minv_block_next_R2_C7_dqdPE2;
         minv_block_reg_R3_C1_dqdPE2 <= minv_block_next_R3_C1_dqdPE2;
         minv_block_reg_R3_C2_dqdPE2 <= minv_block_next_R3_C2_dqdPE2;
         minv_block_reg_R3_C3_dqdPE2 <= minv_block_next_R3_C3_dqdPE2;
         minv_block_reg_R3_C4_dqdPE2 <= minv_block_next_R3_C4_dqdPE2;
         minv_block_reg_R3_C5_dqdPE2 <= minv_block_next_R3_C5_dqdPE2;
         minv_block_reg_R3_C6_dqdPE2 <= minv_block_next_R3_C6_dqdPE2;
         minv_block_reg_R3_C7_dqdPE2 <= minv_block_next_R3_C7_dqdPE2;
         minv_block_reg_R4_C1_dqdPE2 <= minv_block_next_R4_C1_dqdPE2;
         minv_block_reg_R4_C2_dqdPE2 <= minv_block_next_R4_C2_dqdPE2;
         minv_block_reg_R4_C3_dqdPE2 <= minv_block_next_R4_C3_dqdPE2;
         minv_block_reg_R4_C4_dqdPE2 <= minv_block_next_R4_C4_dqdPE2;
         minv_block_reg_R4_C5_dqdPE2 <= minv_block_next_R4_C5_dqdPE2;
         minv_block_reg_R4_C6_dqdPE2 <= minv_block_next_R4_C6_dqdPE2;
         minv_block_reg_R4_C7_dqdPE2 <= minv_block_next_R4_C7_dqdPE2;
         minv_block_reg_R5_C1_dqdPE2 <= minv_block_next_R5_C1_dqdPE2;
         minv_block_reg_R5_C2_dqdPE2 <= minv_block_next_R5_C2_dqdPE2;
         minv_block_reg_R5_C3_dqdPE2 <= minv_block_next_R5_C3_dqdPE2;
         minv_block_reg_R5_C4_dqdPE2 <= minv_block_next_R5_C4_dqdPE2;
         minv_block_reg_R5_C5_dqdPE2 <= minv_block_next_R5_C5_dqdPE2;
         minv_block_reg_R5_C6_dqdPE2 <= minv_block_next_R5_C6_dqdPE2;
         minv_block_reg_R5_C7_dqdPE2 <= minv_block_next_R5_C7_dqdPE2;
         minv_block_reg_R6_C1_dqdPE2 <= minv_block_next_R6_C1_dqdPE2;
         minv_block_reg_R6_C2_dqdPE2 <= minv_block_next_R6_C2_dqdPE2;
         minv_block_reg_R6_C3_dqdPE2 <= minv_block_next_R6_C3_dqdPE2;
         minv_block_reg_R6_C4_dqdPE2 <= minv_block_next_R6_C4_dqdPE2;
         minv_block_reg_R6_C5_dqdPE2 <= minv_block_next_R6_C5_dqdPE2;
         minv_block_reg_R6_C6_dqdPE2 <= minv_block_next_R6_C6_dqdPE2;
         minv_block_reg_R6_C7_dqdPE2 <= minv_block_next_R6_C7_dqdPE2;
         minv_block_reg_R7_C1_dqdPE2 <= minv_block_next_R7_C1_dqdPE2;
         minv_block_reg_R7_C2_dqdPE2 <= minv_block_next_R7_C2_dqdPE2;
         minv_block_reg_R7_C3_dqdPE2 <= minv_block_next_R7_C3_dqdPE2;
         minv_block_reg_R7_C4_dqdPE2 <= minv_block_next_R7_C4_dqdPE2;
         minv_block_reg_R7_C5_dqdPE2 <= minv_block_next_R7_C5_dqdPE2;
         minv_block_reg_R7_C6_dqdPE2 <= minv_block_next_R7_C6_dqdPE2;
         minv_block_reg_R7_C7_dqdPE2 <= minv_block_next_R7_C7_dqdPE2;
         dtau_vec_reg_R1_dqdPE2 <= dtau_vec_next_R1_dqdPE2;
         dtau_vec_reg_R2_dqdPE2 <= dtau_vec_next_R2_dqdPE2;
         dtau_vec_reg_R3_dqdPE2 <= dtau_vec_next_R3_dqdPE2;
         dtau_vec_reg_R4_dqdPE2 <= dtau_vec_next_R4_dqdPE2;
         dtau_vec_reg_R5_dqdPE2 <= dtau_vec_next_R5_dqdPE2;
         dtau_vec_reg_R6_dqdPE2 <= dtau_vec_next_R6_dqdPE2;
         dtau_vec_reg_R7_dqdPE2 <= dtau_vec_next_R7_dqdPE2;
         // dqdPE3
         minv_block_reg_R1_C1_dqdPE3 <= minv_block_next_R1_C1_dqdPE3;
         minv_block_reg_R1_C2_dqdPE3 <= minv_block_next_R1_C2_dqdPE3;
         minv_block_reg_R1_C3_dqdPE3 <= minv_block_next_R1_C3_dqdPE3;
         minv_block_reg_R1_C4_dqdPE3 <= minv_block_next_R1_C4_dqdPE3;
         minv_block_reg_R1_C5_dqdPE3 <= minv_block_next_R1_C5_dqdPE3;
         minv_block_reg_R1_C6_dqdPE3 <= minv_block_next_R1_C6_dqdPE3;
         minv_block_reg_R1_C7_dqdPE3 <= minv_block_next_R1_C7_dqdPE3;
         minv_block_reg_R2_C1_dqdPE3 <= minv_block_next_R2_C1_dqdPE3;
         minv_block_reg_R2_C2_dqdPE3 <= minv_block_next_R2_C2_dqdPE3;
         minv_block_reg_R2_C3_dqdPE3 <= minv_block_next_R2_C3_dqdPE3;
         minv_block_reg_R2_C4_dqdPE3 <= minv_block_next_R2_C4_dqdPE3;
         minv_block_reg_R2_C5_dqdPE3 <= minv_block_next_R2_C5_dqdPE3;
         minv_block_reg_R2_C6_dqdPE3 <= minv_block_next_R2_C6_dqdPE3;
         minv_block_reg_R2_C7_dqdPE3 <= minv_block_next_R2_C7_dqdPE3;
         minv_block_reg_R3_C1_dqdPE3 <= minv_block_next_R3_C1_dqdPE3;
         minv_block_reg_R3_C2_dqdPE3 <= minv_block_next_R3_C2_dqdPE3;
         minv_block_reg_R3_C3_dqdPE3 <= minv_block_next_R3_C3_dqdPE3;
         minv_block_reg_R3_C4_dqdPE3 <= minv_block_next_R3_C4_dqdPE3;
         minv_block_reg_R3_C5_dqdPE3 <= minv_block_next_R3_C5_dqdPE3;
         minv_block_reg_R3_C6_dqdPE3 <= minv_block_next_R3_C6_dqdPE3;
         minv_block_reg_R3_C7_dqdPE3 <= minv_block_next_R3_C7_dqdPE3;
         minv_block_reg_R4_C1_dqdPE3 <= minv_block_next_R4_C1_dqdPE3;
         minv_block_reg_R4_C2_dqdPE3 <= minv_block_next_R4_C2_dqdPE3;
         minv_block_reg_R4_C3_dqdPE3 <= minv_block_next_R4_C3_dqdPE3;
         minv_block_reg_R4_C4_dqdPE3 <= minv_block_next_R4_C4_dqdPE3;
         minv_block_reg_R4_C5_dqdPE3 <= minv_block_next_R4_C5_dqdPE3;
         minv_block_reg_R4_C6_dqdPE3 <= minv_block_next_R4_C6_dqdPE3;
         minv_block_reg_R4_C7_dqdPE3 <= minv_block_next_R4_C7_dqdPE3;
         minv_block_reg_R5_C1_dqdPE3 <= minv_block_next_R5_C1_dqdPE3;
         minv_block_reg_R5_C2_dqdPE3 <= minv_block_next_R5_C2_dqdPE3;
         minv_block_reg_R5_C3_dqdPE3 <= minv_block_next_R5_C3_dqdPE3;
         minv_block_reg_R5_C4_dqdPE3 <= minv_block_next_R5_C4_dqdPE3;
         minv_block_reg_R5_C5_dqdPE3 <= minv_block_next_R5_C5_dqdPE3;
         minv_block_reg_R5_C6_dqdPE3 <= minv_block_next_R5_C6_dqdPE3;
         minv_block_reg_R5_C7_dqdPE3 <= minv_block_next_R5_C7_dqdPE3;
         minv_block_reg_R6_C1_dqdPE3 <= minv_block_next_R6_C1_dqdPE3;
         minv_block_reg_R6_C2_dqdPE3 <= minv_block_next_R6_C2_dqdPE3;
         minv_block_reg_R6_C3_dqdPE3 <= minv_block_next_R6_C3_dqdPE3;
         minv_block_reg_R6_C4_dqdPE3 <= minv_block_next_R6_C4_dqdPE3;
         minv_block_reg_R6_C5_dqdPE3 <= minv_block_next_R6_C5_dqdPE3;
         minv_block_reg_R6_C6_dqdPE3 <= minv_block_next_R6_C6_dqdPE3;
         minv_block_reg_R6_C7_dqdPE3 <= minv_block_next_R6_C7_dqdPE3;
         minv_block_reg_R7_C1_dqdPE3 <= minv_block_next_R7_C1_dqdPE3;
         minv_block_reg_R7_C2_dqdPE3 <= minv_block_next_R7_C2_dqdPE3;
         minv_block_reg_R7_C3_dqdPE3 <= minv_block_next_R7_C3_dqdPE3;
         minv_block_reg_R7_C4_dqdPE3 <= minv_block_next_R7_C4_dqdPE3;
         minv_block_reg_R7_C5_dqdPE3 <= minv_block_next_R7_C5_dqdPE3;
         minv_block_reg_R7_C6_dqdPE3 <= minv_block_next_R7_C6_dqdPE3;
         minv_block_reg_R7_C7_dqdPE3 <= minv_block_next_R7_C7_dqdPE3;
         dtau_vec_reg_R1_dqdPE3 <= dtau_vec_next_R1_dqdPE3;
         dtau_vec_reg_R2_dqdPE3 <= dtau_vec_next_R2_dqdPE3;
         dtau_vec_reg_R3_dqdPE3 <= dtau_vec_next_R3_dqdPE3;
         dtau_vec_reg_R4_dqdPE3 <= dtau_vec_next_R4_dqdPE3;
         dtau_vec_reg_R5_dqdPE3 <= dtau_vec_next_R5_dqdPE3;
         dtau_vec_reg_R6_dqdPE3 <= dtau_vec_next_R6_dqdPE3;
         dtau_vec_reg_R7_dqdPE3 <= dtau_vec_next_R7_dqdPE3;
         // dqdPE4
         minv_block_reg_R1_C1_dqdPE4 <= minv_block_next_R1_C1_dqdPE4;
         minv_block_reg_R1_C2_dqdPE4 <= minv_block_next_R1_C2_dqdPE4;
         minv_block_reg_R1_C3_dqdPE4 <= minv_block_next_R1_C3_dqdPE4;
         minv_block_reg_R1_C4_dqdPE4 <= minv_block_next_R1_C4_dqdPE4;
         minv_block_reg_R1_C5_dqdPE4 <= minv_block_next_R1_C5_dqdPE4;
         minv_block_reg_R1_C6_dqdPE4 <= minv_block_next_R1_C6_dqdPE4;
         minv_block_reg_R1_C7_dqdPE4 <= minv_block_next_R1_C7_dqdPE4;
         minv_block_reg_R2_C1_dqdPE4 <= minv_block_next_R2_C1_dqdPE4;
         minv_block_reg_R2_C2_dqdPE4 <= minv_block_next_R2_C2_dqdPE4;
         minv_block_reg_R2_C3_dqdPE4 <= minv_block_next_R2_C3_dqdPE4;
         minv_block_reg_R2_C4_dqdPE4 <= minv_block_next_R2_C4_dqdPE4;
         minv_block_reg_R2_C5_dqdPE4 <= minv_block_next_R2_C5_dqdPE4;
         minv_block_reg_R2_C6_dqdPE4 <= minv_block_next_R2_C6_dqdPE4;
         minv_block_reg_R2_C7_dqdPE4 <= minv_block_next_R2_C7_dqdPE4;
         minv_block_reg_R3_C1_dqdPE4 <= minv_block_next_R3_C1_dqdPE4;
         minv_block_reg_R3_C2_dqdPE4 <= minv_block_next_R3_C2_dqdPE4;
         minv_block_reg_R3_C3_dqdPE4 <= minv_block_next_R3_C3_dqdPE4;
         minv_block_reg_R3_C4_dqdPE4 <= minv_block_next_R3_C4_dqdPE4;
         minv_block_reg_R3_C5_dqdPE4 <= minv_block_next_R3_C5_dqdPE4;
         minv_block_reg_R3_C6_dqdPE4 <= minv_block_next_R3_C6_dqdPE4;
         minv_block_reg_R3_C7_dqdPE4 <= minv_block_next_R3_C7_dqdPE4;
         minv_block_reg_R4_C1_dqdPE4 <= minv_block_next_R4_C1_dqdPE4;
         minv_block_reg_R4_C2_dqdPE4 <= minv_block_next_R4_C2_dqdPE4;
         minv_block_reg_R4_C3_dqdPE4 <= minv_block_next_R4_C3_dqdPE4;
         minv_block_reg_R4_C4_dqdPE4 <= minv_block_next_R4_C4_dqdPE4;
         minv_block_reg_R4_C5_dqdPE4 <= minv_block_next_R4_C5_dqdPE4;
         minv_block_reg_R4_C6_dqdPE4 <= minv_block_next_R4_C6_dqdPE4;
         minv_block_reg_R4_C7_dqdPE4 <= minv_block_next_R4_C7_dqdPE4;
         minv_block_reg_R5_C1_dqdPE4 <= minv_block_next_R5_C1_dqdPE4;
         minv_block_reg_R5_C2_dqdPE4 <= minv_block_next_R5_C2_dqdPE4;
         minv_block_reg_R5_C3_dqdPE4 <= minv_block_next_R5_C3_dqdPE4;
         minv_block_reg_R5_C4_dqdPE4 <= minv_block_next_R5_C4_dqdPE4;
         minv_block_reg_R5_C5_dqdPE4 <= minv_block_next_R5_C5_dqdPE4;
         minv_block_reg_R5_C6_dqdPE4 <= minv_block_next_R5_C6_dqdPE4;
         minv_block_reg_R5_C7_dqdPE4 <= minv_block_next_R5_C7_dqdPE4;
         minv_block_reg_R6_C1_dqdPE4 <= minv_block_next_R6_C1_dqdPE4;
         minv_block_reg_R6_C2_dqdPE4 <= minv_block_next_R6_C2_dqdPE4;
         minv_block_reg_R6_C3_dqdPE4 <= minv_block_next_R6_C3_dqdPE4;
         minv_block_reg_R6_C4_dqdPE4 <= minv_block_next_R6_C4_dqdPE4;
         minv_block_reg_R6_C5_dqdPE4 <= minv_block_next_R6_C5_dqdPE4;
         minv_block_reg_R6_C6_dqdPE4 <= minv_block_next_R6_C6_dqdPE4;
         minv_block_reg_R6_C7_dqdPE4 <= minv_block_next_R6_C7_dqdPE4;
         minv_block_reg_R7_C1_dqdPE4 <= minv_block_next_R7_C1_dqdPE4;
         minv_block_reg_R7_C2_dqdPE4 <= minv_block_next_R7_C2_dqdPE4;
         minv_block_reg_R7_C3_dqdPE4 <= minv_block_next_R7_C3_dqdPE4;
         minv_block_reg_R7_C4_dqdPE4 <= minv_block_next_R7_C4_dqdPE4;
         minv_block_reg_R7_C5_dqdPE4 <= minv_block_next_R7_C5_dqdPE4;
         minv_block_reg_R7_C6_dqdPE4 <= minv_block_next_R7_C6_dqdPE4;
         minv_block_reg_R7_C7_dqdPE4 <= minv_block_next_R7_C7_dqdPE4;
         dtau_vec_reg_R1_dqdPE4 <= dtau_vec_next_R1_dqdPE4;
         dtau_vec_reg_R2_dqdPE4 <= dtau_vec_next_R2_dqdPE4;
         dtau_vec_reg_R3_dqdPE4 <= dtau_vec_next_R3_dqdPE4;
         dtau_vec_reg_R4_dqdPE4 <= dtau_vec_next_R4_dqdPE4;
         dtau_vec_reg_R5_dqdPE4 <= dtau_vec_next_R5_dqdPE4;
         dtau_vec_reg_R6_dqdPE4 <= dtau_vec_next_R6_dqdPE4;
         dtau_vec_reg_R7_dqdPE4 <= dtau_vec_next_R7_dqdPE4;
         // dqdPE5
         minv_block_reg_R1_C1_dqdPE5 <= minv_block_next_R1_C1_dqdPE5;
         minv_block_reg_R1_C2_dqdPE5 <= minv_block_next_R1_C2_dqdPE5;
         minv_block_reg_R1_C3_dqdPE5 <= minv_block_next_R1_C3_dqdPE5;
         minv_block_reg_R1_C4_dqdPE5 <= minv_block_next_R1_C4_dqdPE5;
         minv_block_reg_R1_C5_dqdPE5 <= minv_block_next_R1_C5_dqdPE5;
         minv_block_reg_R1_C6_dqdPE5 <= minv_block_next_R1_C6_dqdPE5;
         minv_block_reg_R1_C7_dqdPE5 <= minv_block_next_R1_C7_dqdPE5;
         minv_block_reg_R2_C1_dqdPE5 <= minv_block_next_R2_C1_dqdPE5;
         minv_block_reg_R2_C2_dqdPE5 <= minv_block_next_R2_C2_dqdPE5;
         minv_block_reg_R2_C3_dqdPE5 <= minv_block_next_R2_C3_dqdPE5;
         minv_block_reg_R2_C4_dqdPE5 <= minv_block_next_R2_C4_dqdPE5;
         minv_block_reg_R2_C5_dqdPE5 <= minv_block_next_R2_C5_dqdPE5;
         minv_block_reg_R2_C6_dqdPE5 <= minv_block_next_R2_C6_dqdPE5;
         minv_block_reg_R2_C7_dqdPE5 <= minv_block_next_R2_C7_dqdPE5;
         minv_block_reg_R3_C1_dqdPE5 <= minv_block_next_R3_C1_dqdPE5;
         minv_block_reg_R3_C2_dqdPE5 <= minv_block_next_R3_C2_dqdPE5;
         minv_block_reg_R3_C3_dqdPE5 <= minv_block_next_R3_C3_dqdPE5;
         minv_block_reg_R3_C4_dqdPE5 <= minv_block_next_R3_C4_dqdPE5;
         minv_block_reg_R3_C5_dqdPE5 <= minv_block_next_R3_C5_dqdPE5;
         minv_block_reg_R3_C6_dqdPE5 <= minv_block_next_R3_C6_dqdPE5;
         minv_block_reg_R3_C7_dqdPE5 <= minv_block_next_R3_C7_dqdPE5;
         minv_block_reg_R4_C1_dqdPE5 <= minv_block_next_R4_C1_dqdPE5;
         minv_block_reg_R4_C2_dqdPE5 <= minv_block_next_R4_C2_dqdPE5;
         minv_block_reg_R4_C3_dqdPE5 <= minv_block_next_R4_C3_dqdPE5;
         minv_block_reg_R4_C4_dqdPE5 <= minv_block_next_R4_C4_dqdPE5;
         minv_block_reg_R4_C5_dqdPE5 <= minv_block_next_R4_C5_dqdPE5;
         minv_block_reg_R4_C6_dqdPE5 <= minv_block_next_R4_C6_dqdPE5;
         minv_block_reg_R4_C7_dqdPE5 <= minv_block_next_R4_C7_dqdPE5;
         minv_block_reg_R5_C1_dqdPE5 <= minv_block_next_R5_C1_dqdPE5;
         minv_block_reg_R5_C2_dqdPE5 <= minv_block_next_R5_C2_dqdPE5;
         minv_block_reg_R5_C3_dqdPE5 <= minv_block_next_R5_C3_dqdPE5;
         minv_block_reg_R5_C4_dqdPE5 <= minv_block_next_R5_C4_dqdPE5;
         minv_block_reg_R5_C5_dqdPE5 <= minv_block_next_R5_C5_dqdPE5;
         minv_block_reg_R5_C6_dqdPE5 <= minv_block_next_R5_C6_dqdPE5;
         minv_block_reg_R5_C7_dqdPE5 <= minv_block_next_R5_C7_dqdPE5;
         minv_block_reg_R6_C1_dqdPE5 <= minv_block_next_R6_C1_dqdPE5;
         minv_block_reg_R6_C2_dqdPE5 <= minv_block_next_R6_C2_dqdPE5;
         minv_block_reg_R6_C3_dqdPE5 <= minv_block_next_R6_C3_dqdPE5;
         minv_block_reg_R6_C4_dqdPE5 <= minv_block_next_R6_C4_dqdPE5;
         minv_block_reg_R6_C5_dqdPE5 <= minv_block_next_R6_C5_dqdPE5;
         minv_block_reg_R6_C6_dqdPE5 <= minv_block_next_R6_C6_dqdPE5;
         minv_block_reg_R6_C7_dqdPE5 <= minv_block_next_R6_C7_dqdPE5;
         minv_block_reg_R7_C1_dqdPE5 <= minv_block_next_R7_C1_dqdPE5;
         minv_block_reg_R7_C2_dqdPE5 <= minv_block_next_R7_C2_dqdPE5;
         minv_block_reg_R7_C3_dqdPE5 <= minv_block_next_R7_C3_dqdPE5;
         minv_block_reg_R7_C4_dqdPE5 <= minv_block_next_R7_C4_dqdPE5;
         minv_block_reg_R7_C5_dqdPE5 <= minv_block_next_R7_C5_dqdPE5;
         minv_block_reg_R7_C6_dqdPE5 <= minv_block_next_R7_C6_dqdPE5;
         minv_block_reg_R7_C7_dqdPE5 <= minv_block_next_R7_C7_dqdPE5;
         dtau_vec_reg_R1_dqdPE5 <= dtau_vec_next_R1_dqdPE5;
         dtau_vec_reg_R2_dqdPE5 <= dtau_vec_next_R2_dqdPE5;
         dtau_vec_reg_R3_dqdPE5 <= dtau_vec_next_R3_dqdPE5;
         dtau_vec_reg_R4_dqdPE5 <= dtau_vec_next_R4_dqdPE5;
         dtau_vec_reg_R5_dqdPE5 <= dtau_vec_next_R5_dqdPE5;
         dtau_vec_reg_R6_dqdPE5 <= dtau_vec_next_R6_dqdPE5;
         dtau_vec_reg_R7_dqdPE5 <= dtau_vec_next_R7_dqdPE5;
         // dqdPE6
         minv_block_reg_R1_C1_dqdPE6 <= minv_block_next_R1_C1_dqdPE6;
         minv_block_reg_R1_C2_dqdPE6 <= minv_block_next_R1_C2_dqdPE6;
         minv_block_reg_R1_C3_dqdPE6 <= minv_block_next_R1_C3_dqdPE6;
         minv_block_reg_R1_C4_dqdPE6 <= minv_block_next_R1_C4_dqdPE6;
         minv_block_reg_R1_C5_dqdPE6 <= minv_block_next_R1_C5_dqdPE6;
         minv_block_reg_R1_C6_dqdPE6 <= minv_block_next_R1_C6_dqdPE6;
         minv_block_reg_R1_C7_dqdPE6 <= minv_block_next_R1_C7_dqdPE6;
         minv_block_reg_R2_C1_dqdPE6 <= minv_block_next_R2_C1_dqdPE6;
         minv_block_reg_R2_C2_dqdPE6 <= minv_block_next_R2_C2_dqdPE6;
         minv_block_reg_R2_C3_dqdPE6 <= minv_block_next_R2_C3_dqdPE6;
         minv_block_reg_R2_C4_dqdPE6 <= minv_block_next_R2_C4_dqdPE6;
         minv_block_reg_R2_C5_dqdPE6 <= minv_block_next_R2_C5_dqdPE6;
         minv_block_reg_R2_C6_dqdPE6 <= minv_block_next_R2_C6_dqdPE6;
         minv_block_reg_R2_C7_dqdPE6 <= minv_block_next_R2_C7_dqdPE6;
         minv_block_reg_R3_C1_dqdPE6 <= minv_block_next_R3_C1_dqdPE6;
         minv_block_reg_R3_C2_dqdPE6 <= minv_block_next_R3_C2_dqdPE6;
         minv_block_reg_R3_C3_dqdPE6 <= minv_block_next_R3_C3_dqdPE6;
         minv_block_reg_R3_C4_dqdPE6 <= minv_block_next_R3_C4_dqdPE6;
         minv_block_reg_R3_C5_dqdPE6 <= minv_block_next_R3_C5_dqdPE6;
         minv_block_reg_R3_C6_dqdPE6 <= minv_block_next_R3_C6_dqdPE6;
         minv_block_reg_R3_C7_dqdPE6 <= minv_block_next_R3_C7_dqdPE6;
         minv_block_reg_R4_C1_dqdPE6 <= minv_block_next_R4_C1_dqdPE6;
         minv_block_reg_R4_C2_dqdPE6 <= minv_block_next_R4_C2_dqdPE6;
         minv_block_reg_R4_C3_dqdPE6 <= minv_block_next_R4_C3_dqdPE6;
         minv_block_reg_R4_C4_dqdPE6 <= minv_block_next_R4_C4_dqdPE6;
         minv_block_reg_R4_C5_dqdPE6 <= minv_block_next_R4_C5_dqdPE6;
         minv_block_reg_R4_C6_dqdPE6 <= minv_block_next_R4_C6_dqdPE6;
         minv_block_reg_R4_C7_dqdPE6 <= minv_block_next_R4_C7_dqdPE6;
         minv_block_reg_R5_C1_dqdPE6 <= minv_block_next_R5_C1_dqdPE6;
         minv_block_reg_R5_C2_dqdPE6 <= minv_block_next_R5_C2_dqdPE6;
         minv_block_reg_R5_C3_dqdPE6 <= minv_block_next_R5_C3_dqdPE6;
         minv_block_reg_R5_C4_dqdPE6 <= minv_block_next_R5_C4_dqdPE6;
         minv_block_reg_R5_C5_dqdPE6 <= minv_block_next_R5_C5_dqdPE6;
         minv_block_reg_R5_C6_dqdPE6 <= minv_block_next_R5_C6_dqdPE6;
         minv_block_reg_R5_C7_dqdPE6 <= minv_block_next_R5_C7_dqdPE6;
         minv_block_reg_R6_C1_dqdPE6 <= minv_block_next_R6_C1_dqdPE6;
         minv_block_reg_R6_C2_dqdPE6 <= minv_block_next_R6_C2_dqdPE6;
         minv_block_reg_R6_C3_dqdPE6 <= minv_block_next_R6_C3_dqdPE6;
         minv_block_reg_R6_C4_dqdPE6 <= minv_block_next_R6_C4_dqdPE6;
         minv_block_reg_R6_C5_dqdPE6 <= minv_block_next_R6_C5_dqdPE6;
         minv_block_reg_R6_C6_dqdPE6 <= minv_block_next_R6_C6_dqdPE6;
         minv_block_reg_R6_C7_dqdPE6 <= minv_block_next_R6_C7_dqdPE6;
         minv_block_reg_R7_C1_dqdPE6 <= minv_block_next_R7_C1_dqdPE6;
         minv_block_reg_R7_C2_dqdPE6 <= minv_block_next_R7_C2_dqdPE6;
         minv_block_reg_R7_C3_dqdPE6 <= minv_block_next_R7_C3_dqdPE6;
         minv_block_reg_R7_C4_dqdPE6 <= minv_block_next_R7_C4_dqdPE6;
         minv_block_reg_R7_C5_dqdPE6 <= minv_block_next_R7_C5_dqdPE6;
         minv_block_reg_R7_C6_dqdPE6 <= minv_block_next_R7_C6_dqdPE6;
         minv_block_reg_R7_C7_dqdPE6 <= minv_block_next_R7_C7_dqdPE6;
         dtau_vec_reg_R1_dqdPE6 <= dtau_vec_next_R1_dqdPE6;
         dtau_vec_reg_R2_dqdPE6 <= dtau_vec_next_R2_dqdPE6;
         dtau_vec_reg_R3_dqdPE6 <= dtau_vec_next_R3_dqdPE6;
         dtau_vec_reg_R4_dqdPE6 <= dtau_vec_next_R4_dqdPE6;
         dtau_vec_reg_R5_dqdPE6 <= dtau_vec_next_R5_dqdPE6;
         dtau_vec_reg_R6_dqdPE6 <= dtau_vec_next_R6_dqdPE6;
         dtau_vec_reg_R7_dqdPE6 <= dtau_vec_next_R7_dqdPE6;
         // dqdPE7
         minv_block_reg_R1_C1_dqdPE7 <= minv_block_next_R1_C1_dqdPE7;
         minv_block_reg_R1_C2_dqdPE7 <= minv_block_next_R1_C2_dqdPE7;
         minv_block_reg_R1_C3_dqdPE7 <= minv_block_next_R1_C3_dqdPE7;
         minv_block_reg_R1_C4_dqdPE7 <= minv_block_next_R1_C4_dqdPE7;
         minv_block_reg_R1_C5_dqdPE7 <= minv_block_next_R1_C5_dqdPE7;
         minv_block_reg_R1_C6_dqdPE7 <= minv_block_next_R1_C6_dqdPE7;
         minv_block_reg_R1_C7_dqdPE7 <= minv_block_next_R1_C7_dqdPE7;
         minv_block_reg_R2_C1_dqdPE7 <= minv_block_next_R2_C1_dqdPE7;
         minv_block_reg_R2_C2_dqdPE7 <= minv_block_next_R2_C2_dqdPE7;
         minv_block_reg_R2_C3_dqdPE7 <= minv_block_next_R2_C3_dqdPE7;
         minv_block_reg_R2_C4_dqdPE7 <= minv_block_next_R2_C4_dqdPE7;
         minv_block_reg_R2_C5_dqdPE7 <= minv_block_next_R2_C5_dqdPE7;
         minv_block_reg_R2_C6_dqdPE7 <= minv_block_next_R2_C6_dqdPE7;
         minv_block_reg_R2_C7_dqdPE7 <= minv_block_next_R2_C7_dqdPE7;
         minv_block_reg_R3_C1_dqdPE7 <= minv_block_next_R3_C1_dqdPE7;
         minv_block_reg_R3_C2_dqdPE7 <= minv_block_next_R3_C2_dqdPE7;
         minv_block_reg_R3_C3_dqdPE7 <= minv_block_next_R3_C3_dqdPE7;
         minv_block_reg_R3_C4_dqdPE7 <= minv_block_next_R3_C4_dqdPE7;
         minv_block_reg_R3_C5_dqdPE7 <= minv_block_next_R3_C5_dqdPE7;
         minv_block_reg_R3_C6_dqdPE7 <= minv_block_next_R3_C6_dqdPE7;
         minv_block_reg_R3_C7_dqdPE7 <= minv_block_next_R3_C7_dqdPE7;
         minv_block_reg_R4_C1_dqdPE7 <= minv_block_next_R4_C1_dqdPE7;
         minv_block_reg_R4_C2_dqdPE7 <= minv_block_next_R4_C2_dqdPE7;
         minv_block_reg_R4_C3_dqdPE7 <= minv_block_next_R4_C3_dqdPE7;
         minv_block_reg_R4_C4_dqdPE7 <= minv_block_next_R4_C4_dqdPE7;
         minv_block_reg_R4_C5_dqdPE7 <= minv_block_next_R4_C5_dqdPE7;
         minv_block_reg_R4_C6_dqdPE7 <= minv_block_next_R4_C6_dqdPE7;
         minv_block_reg_R4_C7_dqdPE7 <= minv_block_next_R4_C7_dqdPE7;
         minv_block_reg_R5_C1_dqdPE7 <= minv_block_next_R5_C1_dqdPE7;
         minv_block_reg_R5_C2_dqdPE7 <= minv_block_next_R5_C2_dqdPE7;
         minv_block_reg_R5_C3_dqdPE7 <= minv_block_next_R5_C3_dqdPE7;
         minv_block_reg_R5_C4_dqdPE7 <= minv_block_next_R5_C4_dqdPE7;
         minv_block_reg_R5_C5_dqdPE7 <= minv_block_next_R5_C5_dqdPE7;
         minv_block_reg_R5_C6_dqdPE7 <= minv_block_next_R5_C6_dqdPE7;
         minv_block_reg_R5_C7_dqdPE7 <= minv_block_next_R5_C7_dqdPE7;
         minv_block_reg_R6_C1_dqdPE7 <= minv_block_next_R6_C1_dqdPE7;
         minv_block_reg_R6_C2_dqdPE7 <= minv_block_next_R6_C2_dqdPE7;
         minv_block_reg_R6_C3_dqdPE7 <= minv_block_next_R6_C3_dqdPE7;
         minv_block_reg_R6_C4_dqdPE7 <= minv_block_next_R6_C4_dqdPE7;
         minv_block_reg_R6_C5_dqdPE7 <= minv_block_next_R6_C5_dqdPE7;
         minv_block_reg_R6_C6_dqdPE7 <= minv_block_next_R6_C6_dqdPE7;
         minv_block_reg_R6_C7_dqdPE7 <= minv_block_next_R6_C7_dqdPE7;
         minv_block_reg_R7_C1_dqdPE7 <= minv_block_next_R7_C1_dqdPE7;
         minv_block_reg_R7_C2_dqdPE7 <= minv_block_next_R7_C2_dqdPE7;
         minv_block_reg_R7_C3_dqdPE7 <= minv_block_next_R7_C3_dqdPE7;
         minv_block_reg_R7_C4_dqdPE7 <= minv_block_next_R7_C4_dqdPE7;
         minv_block_reg_R7_C5_dqdPE7 <= minv_block_next_R7_C5_dqdPE7;
         minv_block_reg_R7_C6_dqdPE7 <= minv_block_next_R7_C6_dqdPE7;
         minv_block_reg_R7_C7_dqdPE7 <= minv_block_next_R7_C7_dqdPE7;
         dtau_vec_reg_R1_dqdPE7 <= dtau_vec_next_R1_dqdPE7;
         dtau_vec_reg_R2_dqdPE7 <= dtau_vec_next_R2_dqdPE7;
         dtau_vec_reg_R3_dqdPE7 <= dtau_vec_next_R3_dqdPE7;
         dtau_vec_reg_R4_dqdPE7 <= dtau_vec_next_R4_dqdPE7;
         dtau_vec_reg_R5_dqdPE7 <= dtau_vec_next_R5_dqdPE7;
         dtau_vec_reg_R6_dqdPE7 <= dtau_vec_next_R6_dqdPE7;
         dtau_vec_reg_R7_dqdPE7 <= dtau_vec_next_R7_dqdPE7;
         //---------------------------------------------------------------------
      end
   end

   //---------------------------------------------------------------------------
   // ID
   //---------------------------------------------------------------------------
   rneabpx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut(
      // link_in
      .link_in(link_reg_rnea),
      // sin(q) and cos(q)
      .sinq_curr_in(sinq_val_reg_rnea),.cosq_curr_in(cosq_val_reg_rnea),
      // f_curr_vec_in
      .f_curr_vec_in_AX(f_upd_curr_vec_reg_AX_rnea),.f_curr_vec_in_AY(f_upd_curr_vec_reg_AY_rnea),.f_curr_vec_in_AZ(f_upd_curr_vec_reg_AZ_rnea),.f_curr_vec_in_LX(f_upd_curr_vec_reg_LX_rnea),.f_curr_vec_in_LY(f_upd_curr_vec_reg_LY_rnea),.f_curr_vec_in_LZ(f_upd_curr_vec_reg_LZ_rnea),
      // f_prev_vec_in
      .f_prev_vec_in_AX(f_prev_vec_reg_AX_rnea),.f_prev_vec_in_AY(f_prev_vec_reg_AY_rnea),.f_prev_vec_in_AZ(f_prev_vec_reg_AZ_rnea),.f_prev_vec_in_LX(f_prev_vec_reg_LX_rnea),.f_prev_vec_in_LY(f_prev_vec_reg_LY_rnea),.f_prev_vec_in_LZ(f_prev_vec_reg_LZ_rnea),
      // tau_curr_out
      .tau_curr_out(tau_curr_out_rnea),
      // f_prev_upd_vec_out
      .f_prev_upd_vec_out_AX(f_upd_prev_vec_out_AX_rnea),.f_prev_upd_vec_out_AY(f_upd_prev_vec_out_AY_rnea),.f_prev_upd_vec_out_AZ(f_upd_prev_vec_out_AZ_rnea),.f_prev_upd_vec_out_LX(f_upd_prev_vec_out_LX_rnea),.f_prev_upd_vec_out_LY(f_upd_prev_vec_out_LY_rnea),.f_prev_upd_vec_out_LZ(f_upd_prev_vec_out_LZ_rnea)
      );

   //---------------------------------------------------------------------------
   // dq external inputs
   //---------------------------------------------------------------------------
   // dqPE1
   wire fx_dqPE1;
   assign fx_dqPE1 = (link_reg_dqPE1 == derv_reg_dqPE1) ? 1 : 0;
   // dqPE2
   wire fx_dqPE2;
   assign fx_dqPE2 = (link_reg_dqPE2 == derv_reg_dqPE2) ? 1 : 0;
   // dqPE3
   wire fx_dqPE3;
   assign fx_dqPE3 = (link_reg_dqPE3 == derv_reg_dqPE3) ? 1 : 0;
   // dqPE4
   wire fx_dqPE4;
   assign fx_dqPE4 = (link_reg_dqPE4 == derv_reg_dqPE4) ? 1 : 0;
   // dqPE5
   wire fx_dqPE5;
   assign fx_dqPE5 = (link_reg_dqPE5 == derv_reg_dqPE5) ? 1 : 0;
   // dqPE6
   wire fx_dqPE6;
   assign fx_dqPE6 = (link_reg_dqPE6 == derv_reg_dqPE6) ? 1 : 0;
   // dqPE7
   wire fx_dqPE7;
   assign fx_dqPE7 = (link_reg_dqPE7 == derv_reg_dqPE7) ? 1 : 0;
   //---------------------------------------------------------------------------
   // dqd external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   wire fx_dqdPE1;
   assign fx_dqdPE1 = (link_reg_dqdPE1 == derv_reg_dqdPE1) ? 1 : 0;
   // dqdPE2
   wire fx_dqdPE2;
   assign fx_dqdPE2 = (link_reg_dqdPE2 == derv_reg_dqdPE2) ? 1 : 0;
   // dqdPE3
   wire fx_dqdPE3;
   assign fx_dqdPE3 = (link_reg_dqdPE3 == derv_reg_dqdPE3) ? 1 : 0;
   // dqdPE4
   wire fx_dqdPE4;
   assign fx_dqdPE4 = (link_reg_dqdPE4 == derv_reg_dqdPE4) ? 1 : 0;
   // dqdPE5
   wire fx_dqdPE5;
   assign fx_dqdPE5 = (link_reg_dqdPE5 == derv_reg_dqdPE5) ? 1 : 0;
   // dqdPE6
   wire fx_dqdPE6;
   assign fx_dqdPE6 = (link_reg_dqdPE6 == derv_reg_dqdPE6) ? 1 : 0;
   // dqdPE7
   wire fx_dqdPE7;
   assign fx_dqdPE7 = (link_reg_dqdPE7 == derv_reg_dqdPE7) ? 1 : 0;

   //---------------------------------------------------------------------------
   // dID/dq
   //---------------------------------------------------------------------------

   // dqPE1
   dqbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqbpi1(
      // link_in
      .link_in(link_reg_dqPE1),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqPE1),.cosq_in(cosq_val_reg_dqPE1),
      // fcurr_in, 6 values
      .fcurr_in_AX(f_upd_curr_vec_reg_AX_dqPE1),.fcurr_in_AY(f_upd_curr_vec_reg_AY_dqPE1),.fcurr_in_AZ(f_upd_curr_vec_reg_AZ_dqPE1),.fcurr_in_LX(f_upd_curr_vec_reg_LX_dqPE1),.fcurr_in_LY(f_upd_curr_vec_reg_LY_dqPE1),.fcurr_in_LZ(f_upd_curr_vec_reg_LZ_dqPE1),
      // dfdq_curr_in, 6 values
      .dfdq_curr_in_AX(dfdq_upd_curr_vec_reg_AX_dqPE1),.dfdq_curr_in_AY(dfdq_upd_curr_vec_reg_AY_dqPE1),.dfdq_curr_in_AZ(dfdq_upd_curr_vec_reg_AZ_dqPE1),.dfdq_curr_in_LX(dfdq_upd_curr_vec_reg_LX_dqPE1),.dfdq_curr_in_LY(dfdq_upd_curr_vec_reg_LY_dqPE1),.dfdq_curr_in_LZ(dfdq_upd_curr_vec_reg_LZ_dqPE1),
      // fcross boolean
      .fcross(fx_dqPE1),
      // dfdq_prev_in, 6 values
      .dfdq_prev_in_AX(dfdq_prev_vec_reg_AX_dqPE1),.dfdq_prev_in_AY(dfdq_prev_vec_reg_AY_dqPE1),.dfdq_prev_in_AZ(dfdq_prev_vec_reg_AZ_dqPE1),.dfdq_prev_in_LX(dfdq_prev_vec_reg_LX_dqPE1),.dfdq_prev_in_LY(dfdq_prev_vec_reg_LY_dqPE1),.dfdq_prev_in_LZ(dfdq_prev_vec_reg_LZ_dqPE1),
      // dtau_dq_out
      .dtau_dq_out(dtau_curr_out_dqPE1),
      // dfdq_prev_out, 6 values
      .dfdq_prev_out_AX(dfdq_upd_prev_vec_out_AX_dqPE1),.dfdq_prev_out_AY(dfdq_upd_prev_vec_out_AY_dqPE1),.dfdq_prev_out_AZ(dfdq_upd_prev_vec_out_AZ_dqPE1),.dfdq_prev_out_LX(dfdq_upd_prev_vec_out_LX_dqPE1),.dfdq_prev_out_LY(dfdq_upd_prev_vec_out_LY_dqPE1),.dfdq_prev_out_LZ(dfdq_upd_prev_vec_out_LZ_dqPE1)
      );

   // dqPE2
   dqbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqbpi2(
      // link_in
      .link_in(link_reg_dqPE2),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqPE2),.cosq_in(cosq_val_reg_dqPE2),
      // fcurr_in, 6 values
      .fcurr_in_AX(f_upd_curr_vec_reg_AX_dqPE2),.fcurr_in_AY(f_upd_curr_vec_reg_AY_dqPE2),.fcurr_in_AZ(f_upd_curr_vec_reg_AZ_dqPE2),.fcurr_in_LX(f_upd_curr_vec_reg_LX_dqPE2),.fcurr_in_LY(f_upd_curr_vec_reg_LY_dqPE2),.fcurr_in_LZ(f_upd_curr_vec_reg_LZ_dqPE2),
      // dfdq_curr_in, 6 values
      .dfdq_curr_in_AX(dfdq_upd_curr_vec_reg_AX_dqPE2),.dfdq_curr_in_AY(dfdq_upd_curr_vec_reg_AY_dqPE2),.dfdq_curr_in_AZ(dfdq_upd_curr_vec_reg_AZ_dqPE2),.dfdq_curr_in_LX(dfdq_upd_curr_vec_reg_LX_dqPE2),.dfdq_curr_in_LY(dfdq_upd_curr_vec_reg_LY_dqPE2),.dfdq_curr_in_LZ(dfdq_upd_curr_vec_reg_LZ_dqPE2),
      // fcross boolean
      .fcross(fx_dqPE2),
      // dfdq_prev_in, 6 values
      .dfdq_prev_in_AX(dfdq_prev_vec_reg_AX_dqPE2),.dfdq_prev_in_AY(dfdq_prev_vec_reg_AY_dqPE2),.dfdq_prev_in_AZ(dfdq_prev_vec_reg_AZ_dqPE2),.dfdq_prev_in_LX(dfdq_prev_vec_reg_LX_dqPE2),.dfdq_prev_in_LY(dfdq_prev_vec_reg_LY_dqPE2),.dfdq_prev_in_LZ(dfdq_prev_vec_reg_LZ_dqPE2),
      // dtau_dq_out
      .dtau_dq_out(dtau_curr_out_dqPE2),
      // dfdq_prev_out, 6 values
      .dfdq_prev_out_AX(dfdq_upd_prev_vec_out_AX_dqPE2),.dfdq_prev_out_AY(dfdq_upd_prev_vec_out_AY_dqPE2),.dfdq_prev_out_AZ(dfdq_upd_prev_vec_out_AZ_dqPE2),.dfdq_prev_out_LX(dfdq_upd_prev_vec_out_LX_dqPE2),.dfdq_prev_out_LY(dfdq_upd_prev_vec_out_LY_dqPE2),.dfdq_prev_out_LZ(dfdq_upd_prev_vec_out_LZ_dqPE2)
      );

   // dqPE3
   dqbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqbpi3(
      // link_in
      .link_in(link_reg_dqPE3),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqPE3),.cosq_in(cosq_val_reg_dqPE3),
      // fcurr_in, 6 values
      .fcurr_in_AX(f_upd_curr_vec_reg_AX_dqPE3),.fcurr_in_AY(f_upd_curr_vec_reg_AY_dqPE3),.fcurr_in_AZ(f_upd_curr_vec_reg_AZ_dqPE3),.fcurr_in_LX(f_upd_curr_vec_reg_LX_dqPE3),.fcurr_in_LY(f_upd_curr_vec_reg_LY_dqPE3),.fcurr_in_LZ(f_upd_curr_vec_reg_LZ_dqPE3),
      // dfdq_curr_in, 6 values
      .dfdq_curr_in_AX(dfdq_upd_curr_vec_reg_AX_dqPE3),.dfdq_curr_in_AY(dfdq_upd_curr_vec_reg_AY_dqPE3),.dfdq_curr_in_AZ(dfdq_upd_curr_vec_reg_AZ_dqPE3),.dfdq_curr_in_LX(dfdq_upd_curr_vec_reg_LX_dqPE3),.dfdq_curr_in_LY(dfdq_upd_curr_vec_reg_LY_dqPE3),.dfdq_curr_in_LZ(dfdq_upd_curr_vec_reg_LZ_dqPE3),
      // fcross boolean
      .fcross(fx_dqPE3),
      // dfdq_prev_in, 6 values
      .dfdq_prev_in_AX(dfdq_prev_vec_reg_AX_dqPE3),.dfdq_prev_in_AY(dfdq_prev_vec_reg_AY_dqPE3),.dfdq_prev_in_AZ(dfdq_prev_vec_reg_AZ_dqPE3),.dfdq_prev_in_LX(dfdq_prev_vec_reg_LX_dqPE3),.dfdq_prev_in_LY(dfdq_prev_vec_reg_LY_dqPE3),.dfdq_prev_in_LZ(dfdq_prev_vec_reg_LZ_dqPE3),
      // dtau_dq_out
      .dtau_dq_out(dtau_curr_out_dqPE3),
      // dfdq_prev_out, 6 values
      .dfdq_prev_out_AX(dfdq_upd_prev_vec_out_AX_dqPE3),.dfdq_prev_out_AY(dfdq_upd_prev_vec_out_AY_dqPE3),.dfdq_prev_out_AZ(dfdq_upd_prev_vec_out_AZ_dqPE3),.dfdq_prev_out_LX(dfdq_upd_prev_vec_out_LX_dqPE3),.dfdq_prev_out_LY(dfdq_upd_prev_vec_out_LY_dqPE3),.dfdq_prev_out_LZ(dfdq_upd_prev_vec_out_LZ_dqPE3)
      );

   // dqPE4
   dqbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqbpi4(
      // link_in
      .link_in(link_reg_dqPE4),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqPE4),.cosq_in(cosq_val_reg_dqPE4),
      // fcurr_in, 6 values
      .fcurr_in_AX(f_upd_curr_vec_reg_AX_dqPE4),.fcurr_in_AY(f_upd_curr_vec_reg_AY_dqPE4),.fcurr_in_AZ(f_upd_curr_vec_reg_AZ_dqPE4),.fcurr_in_LX(f_upd_curr_vec_reg_LX_dqPE4),.fcurr_in_LY(f_upd_curr_vec_reg_LY_dqPE4),.fcurr_in_LZ(f_upd_curr_vec_reg_LZ_dqPE4),
      // dfdq_curr_in, 6 values
      .dfdq_curr_in_AX(dfdq_upd_curr_vec_reg_AX_dqPE4),.dfdq_curr_in_AY(dfdq_upd_curr_vec_reg_AY_dqPE4),.dfdq_curr_in_AZ(dfdq_upd_curr_vec_reg_AZ_dqPE4),.dfdq_curr_in_LX(dfdq_upd_curr_vec_reg_LX_dqPE4),.dfdq_curr_in_LY(dfdq_upd_curr_vec_reg_LY_dqPE4),.dfdq_curr_in_LZ(dfdq_upd_curr_vec_reg_LZ_dqPE4),
      // fcross boolean
      .fcross(fx_dqPE4),
      // dfdq_prev_in, 6 values
      .dfdq_prev_in_AX(dfdq_prev_vec_reg_AX_dqPE4),.dfdq_prev_in_AY(dfdq_prev_vec_reg_AY_dqPE4),.dfdq_prev_in_AZ(dfdq_prev_vec_reg_AZ_dqPE4),.dfdq_prev_in_LX(dfdq_prev_vec_reg_LX_dqPE4),.dfdq_prev_in_LY(dfdq_prev_vec_reg_LY_dqPE4),.dfdq_prev_in_LZ(dfdq_prev_vec_reg_LZ_dqPE4),
      // dtau_dq_out
      .dtau_dq_out(dtau_curr_out_dqPE4),
      // dfdq_prev_out, 6 values
      .dfdq_prev_out_AX(dfdq_upd_prev_vec_out_AX_dqPE4),.dfdq_prev_out_AY(dfdq_upd_prev_vec_out_AY_dqPE4),.dfdq_prev_out_AZ(dfdq_upd_prev_vec_out_AZ_dqPE4),.dfdq_prev_out_LX(dfdq_upd_prev_vec_out_LX_dqPE4),.dfdq_prev_out_LY(dfdq_upd_prev_vec_out_LY_dqPE4),.dfdq_prev_out_LZ(dfdq_upd_prev_vec_out_LZ_dqPE4)
      );

   // dqPE5
   dqbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqbpi5(
      // link_in
      .link_in(link_reg_dqPE5),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqPE5),.cosq_in(cosq_val_reg_dqPE5),
      // fcurr_in, 6 values
      .fcurr_in_AX(f_upd_curr_vec_reg_AX_dqPE5),.fcurr_in_AY(f_upd_curr_vec_reg_AY_dqPE5),.fcurr_in_AZ(f_upd_curr_vec_reg_AZ_dqPE5),.fcurr_in_LX(f_upd_curr_vec_reg_LX_dqPE5),.fcurr_in_LY(f_upd_curr_vec_reg_LY_dqPE5),.fcurr_in_LZ(f_upd_curr_vec_reg_LZ_dqPE5),
      // dfdq_curr_in, 6 values
      .dfdq_curr_in_AX(dfdq_upd_curr_vec_reg_AX_dqPE5),.dfdq_curr_in_AY(dfdq_upd_curr_vec_reg_AY_dqPE5),.dfdq_curr_in_AZ(dfdq_upd_curr_vec_reg_AZ_dqPE5),.dfdq_curr_in_LX(dfdq_upd_curr_vec_reg_LX_dqPE5),.dfdq_curr_in_LY(dfdq_upd_curr_vec_reg_LY_dqPE5),.dfdq_curr_in_LZ(dfdq_upd_curr_vec_reg_LZ_dqPE5),
      // fcross boolean
      .fcross(fx_dqPE5),
      // dfdq_prev_in, 6 values
      .dfdq_prev_in_AX(dfdq_prev_vec_reg_AX_dqPE5),.dfdq_prev_in_AY(dfdq_prev_vec_reg_AY_dqPE5),.dfdq_prev_in_AZ(dfdq_prev_vec_reg_AZ_dqPE5),.dfdq_prev_in_LX(dfdq_prev_vec_reg_LX_dqPE5),.dfdq_prev_in_LY(dfdq_prev_vec_reg_LY_dqPE5),.dfdq_prev_in_LZ(dfdq_prev_vec_reg_LZ_dqPE5),
      // dtau_dq_out
      .dtau_dq_out(dtau_curr_out_dqPE5),
      // dfdq_prev_out, 6 values
      .dfdq_prev_out_AX(dfdq_upd_prev_vec_out_AX_dqPE5),.dfdq_prev_out_AY(dfdq_upd_prev_vec_out_AY_dqPE5),.dfdq_prev_out_AZ(dfdq_upd_prev_vec_out_AZ_dqPE5),.dfdq_prev_out_LX(dfdq_upd_prev_vec_out_LX_dqPE5),.dfdq_prev_out_LY(dfdq_upd_prev_vec_out_LY_dqPE5),.dfdq_prev_out_LZ(dfdq_upd_prev_vec_out_LZ_dqPE5)
      );

   // dqPE6
   dqbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqbpi6(
      // link_in
      .link_in(link_reg_dqPE6),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqPE6),.cosq_in(cosq_val_reg_dqPE6),
      // fcurr_in, 6 values
      .fcurr_in_AX(f_upd_curr_vec_reg_AX_dqPE6),.fcurr_in_AY(f_upd_curr_vec_reg_AY_dqPE6),.fcurr_in_AZ(f_upd_curr_vec_reg_AZ_dqPE6),.fcurr_in_LX(f_upd_curr_vec_reg_LX_dqPE6),.fcurr_in_LY(f_upd_curr_vec_reg_LY_dqPE6),.fcurr_in_LZ(f_upd_curr_vec_reg_LZ_dqPE6),
      // dfdq_curr_in, 6 values
      .dfdq_curr_in_AX(dfdq_upd_curr_vec_reg_AX_dqPE6),.dfdq_curr_in_AY(dfdq_upd_curr_vec_reg_AY_dqPE6),.dfdq_curr_in_AZ(dfdq_upd_curr_vec_reg_AZ_dqPE6),.dfdq_curr_in_LX(dfdq_upd_curr_vec_reg_LX_dqPE6),.dfdq_curr_in_LY(dfdq_upd_curr_vec_reg_LY_dqPE6),.dfdq_curr_in_LZ(dfdq_upd_curr_vec_reg_LZ_dqPE6),
      // fcross boolean
      .fcross(fx_dqPE6),
      // dfdq_prev_in, 6 values
      .dfdq_prev_in_AX(dfdq_prev_vec_reg_AX_dqPE6),.dfdq_prev_in_AY(dfdq_prev_vec_reg_AY_dqPE6),.dfdq_prev_in_AZ(dfdq_prev_vec_reg_AZ_dqPE6),.dfdq_prev_in_LX(dfdq_prev_vec_reg_LX_dqPE6),.dfdq_prev_in_LY(dfdq_prev_vec_reg_LY_dqPE6),.dfdq_prev_in_LZ(dfdq_prev_vec_reg_LZ_dqPE6),
      // dtau_dq_out
      .dtau_dq_out(dtau_curr_out_dqPE6),
      // dfdq_prev_out, 6 values
      .dfdq_prev_out_AX(dfdq_upd_prev_vec_out_AX_dqPE6),.dfdq_prev_out_AY(dfdq_upd_prev_vec_out_AY_dqPE6),.dfdq_prev_out_AZ(dfdq_upd_prev_vec_out_AZ_dqPE6),.dfdq_prev_out_LX(dfdq_upd_prev_vec_out_LX_dqPE6),.dfdq_prev_out_LY(dfdq_upd_prev_vec_out_LY_dqPE6),.dfdq_prev_out_LZ(dfdq_upd_prev_vec_out_LZ_dqPE6)
      );

   // dqPE7
   dqbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqbpi7(
      // link_in
      .link_in(link_reg_dqPE7),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqPE7),.cosq_in(cosq_val_reg_dqPE7),
      // fcurr_in, 6 values
      .fcurr_in_AX(f_upd_curr_vec_reg_AX_dqPE7),.fcurr_in_AY(f_upd_curr_vec_reg_AY_dqPE7),.fcurr_in_AZ(f_upd_curr_vec_reg_AZ_dqPE7),.fcurr_in_LX(f_upd_curr_vec_reg_LX_dqPE7),.fcurr_in_LY(f_upd_curr_vec_reg_LY_dqPE7),.fcurr_in_LZ(f_upd_curr_vec_reg_LZ_dqPE7),
      // dfdq_curr_in, 6 values
      .dfdq_curr_in_AX(dfdq_upd_curr_vec_reg_AX_dqPE7),.dfdq_curr_in_AY(dfdq_upd_curr_vec_reg_AY_dqPE7),.dfdq_curr_in_AZ(dfdq_upd_curr_vec_reg_AZ_dqPE7),.dfdq_curr_in_LX(dfdq_upd_curr_vec_reg_LX_dqPE7),.dfdq_curr_in_LY(dfdq_upd_curr_vec_reg_LY_dqPE7),.dfdq_curr_in_LZ(dfdq_upd_curr_vec_reg_LZ_dqPE7),
      // fcross boolean
      .fcross(fx_dqPE7),
      // dfdq_prev_in, 6 values
      .dfdq_prev_in_AX(dfdq_prev_vec_reg_AX_dqPE7),.dfdq_prev_in_AY(dfdq_prev_vec_reg_AY_dqPE7),.dfdq_prev_in_AZ(dfdq_prev_vec_reg_AZ_dqPE7),.dfdq_prev_in_LX(dfdq_prev_vec_reg_LX_dqPE7),.dfdq_prev_in_LY(dfdq_prev_vec_reg_LY_dqPE7),.dfdq_prev_in_LZ(dfdq_prev_vec_reg_LZ_dqPE7),
      // dtau_dq_out
      .dtau_dq_out(dtau_curr_out_dqPE7),
      // dfdq_prev_out, 6 values
      .dfdq_prev_out_AX(dfdq_upd_prev_vec_out_AX_dqPE7),.dfdq_prev_out_AY(dfdq_upd_prev_vec_out_AY_dqPE7),.dfdq_prev_out_AZ(dfdq_upd_prev_vec_out_AZ_dqPE7),.dfdq_prev_out_LX(dfdq_upd_prev_vec_out_LX_dqPE7),.dfdq_prev_out_LY(dfdq_upd_prev_vec_out_LY_dqPE7),.dfdq_prev_out_LZ(dfdq_upd_prev_vec_out_LZ_dqPE7)
      );

   //---------------------------------------------------------------------------
   // dID/dqd
   //---------------------------------------------------------------------------

   // dqdPE1
   dqdbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdbpi1(
      // link_in
      .link_in(link_reg_dqdPE1),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqdPE1),.cosq_in(cosq_val_reg_dqdPE1),
      // dfdqd_curr_in, 6 values
      .dfdqd_curr_in_AX(dfdqd_upd_curr_vec_reg_AX_dqdPE1),.dfdqd_curr_in_AY(dfdqd_upd_curr_vec_reg_AY_dqdPE1),.dfdqd_curr_in_AZ(dfdqd_upd_curr_vec_reg_AZ_dqdPE1),.dfdqd_curr_in_LX(dfdqd_upd_curr_vec_reg_LX_dqdPE1),.dfdqd_curr_in_LY(dfdqd_upd_curr_vec_reg_LY_dqdPE1),.dfdqd_curr_in_LZ(dfdqd_upd_curr_vec_reg_LZ_dqdPE1),
      // dfdqd_prev_in, 6 values
      .dfdqd_prev_in_AX(dfdqd_prev_vec_reg_AX_dqdPE1),.dfdqd_prev_in_AY(dfdqd_prev_vec_reg_AY_dqdPE1),.dfdqd_prev_in_AZ(dfdqd_prev_vec_reg_AZ_dqdPE1),.dfdqd_prev_in_LX(dfdqd_prev_vec_reg_LX_dqdPE1),.dfdqd_prev_in_LY(dfdqd_prev_vec_reg_LY_dqdPE1),.dfdqd_prev_in_LZ(dfdqd_prev_vec_reg_LZ_dqdPE1),
      // dtau_dqd_out
      .dtau_dqd_out(dtau_curr_out_dqdPE1),
      // dfdqd_prev_out, 6 values
      .dfdqd_prev_out_AX(dfdqd_upd_prev_vec_out_AX_dqdPE1),.dfdqd_prev_out_AY(dfdqd_upd_prev_vec_out_AY_dqdPE1),.dfdqd_prev_out_AZ(dfdqd_upd_prev_vec_out_AZ_dqdPE1),.dfdqd_prev_out_LX(dfdqd_upd_prev_vec_out_LX_dqdPE1),.dfdqd_prev_out_LY(dfdqd_upd_prev_vec_out_LY_dqdPE1),.dfdqd_prev_out_LZ(dfdqd_upd_prev_vec_out_LZ_dqdPE1),
      // minv boolean
      .minv(minv_bool_reg),
      // minvm_in
      .minvm_in_C1_R1(minv_block_reg_R1_C1_dqdPE1),.minvm_in_C1_R2(minv_block_reg_R2_C1_dqdPE1),.minvm_in_C1_R3(minv_block_reg_R3_C1_dqdPE1),.minvm_in_C1_R4(minv_block_reg_R4_C1_dqdPE1),.minvm_in_C1_R5(minv_block_reg_R5_C1_dqdPE1),.minvm_in_C1_R6(minv_block_reg_R6_C1_dqdPE1),.minvm_in_C1_R7(minv_block_reg_R7_C1_dqdPE1),
      .minvm_in_C2_R1(minv_block_reg_R1_C2_dqdPE1),.minvm_in_C2_R2(minv_block_reg_R2_C2_dqdPE1),.minvm_in_C2_R3(minv_block_reg_R3_C2_dqdPE1),.minvm_in_C2_R4(minv_block_reg_R4_C2_dqdPE1),.minvm_in_C2_R5(minv_block_reg_R5_C2_dqdPE1),.minvm_in_C2_R6(minv_block_reg_R6_C2_dqdPE1),.minvm_in_C2_R7(minv_block_reg_R7_C2_dqdPE1),
      .minvm_in_C3_R1(minv_block_reg_R1_C3_dqdPE1),.minvm_in_C3_R2(minv_block_reg_R2_C3_dqdPE1),.minvm_in_C3_R3(minv_block_reg_R3_C3_dqdPE1),.minvm_in_C3_R4(minv_block_reg_R4_C3_dqdPE1),.minvm_in_C3_R5(minv_block_reg_R5_C3_dqdPE1),.minvm_in_C3_R6(minv_block_reg_R6_C3_dqdPE1),.minvm_in_C3_R7(minv_block_reg_R7_C3_dqdPE1),
      .minvm_in_C4_R1(minv_block_reg_R1_C4_dqdPE1),.minvm_in_C4_R2(minv_block_reg_R2_C4_dqdPE1),.minvm_in_C4_R3(minv_block_reg_R3_C4_dqdPE1),.minvm_in_C4_R4(minv_block_reg_R4_C4_dqdPE1),.minvm_in_C4_R5(minv_block_reg_R5_C4_dqdPE1),.minvm_in_C4_R6(minv_block_reg_R6_C4_dqdPE1),.minvm_in_C4_R7(minv_block_reg_R7_C4_dqdPE1),
      .minvm_in_C5_R1(minv_block_reg_R1_C5_dqdPE1),.minvm_in_C5_R2(minv_block_reg_R2_C5_dqdPE1),.minvm_in_C5_R3(minv_block_reg_R3_C5_dqdPE1),.minvm_in_C5_R4(minv_block_reg_R4_C5_dqdPE1),.minvm_in_C5_R5(minv_block_reg_R5_C5_dqdPE1),.minvm_in_C5_R6(minv_block_reg_R6_C5_dqdPE1),.minvm_in_C5_R7(minv_block_reg_R7_C5_dqdPE1),
      .minvm_in_C6_R1(minv_block_reg_R1_C6_dqdPE1),.minvm_in_C6_R2(minv_block_reg_R2_C6_dqdPE1),.minvm_in_C6_R3(minv_block_reg_R3_C6_dqdPE1),.minvm_in_C6_R4(minv_block_reg_R4_C6_dqdPE1),.minvm_in_C6_R5(minv_block_reg_R5_C6_dqdPE1),.minvm_in_C6_R6(minv_block_reg_R6_C6_dqdPE1),.minvm_in_C6_R7(minv_block_reg_R7_C6_dqdPE1),
      .minvm_in_C7_R1(minv_block_reg_R1_C7_dqdPE1),.minvm_in_C7_R2(minv_block_reg_R2_C7_dqdPE1),.minvm_in_C7_R3(minv_block_reg_R3_C7_dqdPE1),.minvm_in_C7_R4(minv_block_reg_R4_C7_dqdPE1),.minvm_in_C7_R5(minv_block_reg_R5_C7_dqdPE1),.minvm_in_C7_R6(minv_block_reg_R6_C7_dqdPE1),.minvm_in_C7_R7(minv_block_reg_R7_C7_dqdPE1),
      // tau_vec_in
      .tau_vec_in_R1(dtau_vec_reg_R1_dqdPE1),.tau_vec_in_R2(dtau_vec_reg_R2_dqdPE1),.tau_vec_in_R3(dtau_vec_reg_R3_dqdPE1),.tau_vec_in_R4(dtau_vec_reg_R4_dqdPE1),.tau_vec_in_R5(dtau_vec_reg_R5_dqdPE1),.tau_vec_in_R6(dtau_vec_reg_R6_dqdPE1),.tau_vec_in_R7(dtau_vec_reg_R7_dqdPE1),
      // minv_vec_out
      .minv_vec_out_R1(minv_vec_out_R1_dqdPE1),.minv_vec_out_R2(minv_vec_out_R2_dqdPE1),.minv_vec_out_R3(minv_vec_out_R3_dqdPE1),.minv_vec_out_R4(minv_vec_out_R4_dqdPE1),.minv_vec_out_R5(minv_vec_out_R5_dqdPE1),.minv_vec_out_R6(minv_vec_out_R6_dqdPE1),.minv_vec_out_R7(minv_vec_out_R7_dqdPE1)
      );

   // dqdPE2
   dqdbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdbpi2(
      // link_in
      .link_in(link_reg_dqdPE2),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqdPE2),.cosq_in(cosq_val_reg_dqdPE2),
      // dfdqd_curr_in, 6 values
      .dfdqd_curr_in_AX(dfdqd_upd_curr_vec_reg_AX_dqdPE2),.dfdqd_curr_in_AY(dfdqd_upd_curr_vec_reg_AY_dqdPE2),.dfdqd_curr_in_AZ(dfdqd_upd_curr_vec_reg_AZ_dqdPE2),.dfdqd_curr_in_LX(dfdqd_upd_curr_vec_reg_LX_dqdPE2),.dfdqd_curr_in_LY(dfdqd_upd_curr_vec_reg_LY_dqdPE2),.dfdqd_curr_in_LZ(dfdqd_upd_curr_vec_reg_LZ_dqdPE2),
      // dfdqd_prev_in, 6 values
      .dfdqd_prev_in_AX(dfdqd_prev_vec_reg_AX_dqdPE2),.dfdqd_prev_in_AY(dfdqd_prev_vec_reg_AY_dqdPE2),.dfdqd_prev_in_AZ(dfdqd_prev_vec_reg_AZ_dqdPE2),.dfdqd_prev_in_LX(dfdqd_prev_vec_reg_LX_dqdPE2),.dfdqd_prev_in_LY(dfdqd_prev_vec_reg_LY_dqdPE2),.dfdqd_prev_in_LZ(dfdqd_prev_vec_reg_LZ_dqdPE2),
      // dtau_dqd_out
      .dtau_dqd_out(dtau_curr_out_dqdPE2),
      // dfdqd_prev_out, 6 values
      .dfdqd_prev_out_AX(dfdqd_upd_prev_vec_out_AX_dqdPE2),.dfdqd_prev_out_AY(dfdqd_upd_prev_vec_out_AY_dqdPE2),.dfdqd_prev_out_AZ(dfdqd_upd_prev_vec_out_AZ_dqdPE2),.dfdqd_prev_out_LX(dfdqd_upd_prev_vec_out_LX_dqdPE2),.dfdqd_prev_out_LY(dfdqd_upd_prev_vec_out_LY_dqdPE2),.dfdqd_prev_out_LZ(dfdqd_upd_prev_vec_out_LZ_dqdPE2),
      // minv boolean
      .minv(minv_bool_reg),
      // minvm_in
      .minvm_in_C1_R1(minv_block_reg_R1_C1_dqdPE2),.minvm_in_C1_R2(minv_block_reg_R2_C1_dqdPE2),.minvm_in_C1_R3(minv_block_reg_R3_C1_dqdPE2),.minvm_in_C1_R4(minv_block_reg_R4_C1_dqdPE2),.minvm_in_C1_R5(minv_block_reg_R5_C1_dqdPE2),.minvm_in_C1_R6(minv_block_reg_R6_C1_dqdPE2),.minvm_in_C1_R7(minv_block_reg_R7_C1_dqdPE2),
      .minvm_in_C2_R1(minv_block_reg_R1_C2_dqdPE2),.minvm_in_C2_R2(minv_block_reg_R2_C2_dqdPE2),.minvm_in_C2_R3(minv_block_reg_R3_C2_dqdPE2),.minvm_in_C2_R4(minv_block_reg_R4_C2_dqdPE2),.minvm_in_C2_R5(minv_block_reg_R5_C2_dqdPE2),.minvm_in_C2_R6(minv_block_reg_R6_C2_dqdPE2),.minvm_in_C2_R7(minv_block_reg_R7_C2_dqdPE2),
      .minvm_in_C3_R1(minv_block_reg_R1_C3_dqdPE2),.minvm_in_C3_R2(minv_block_reg_R2_C3_dqdPE2),.minvm_in_C3_R3(minv_block_reg_R3_C3_dqdPE2),.minvm_in_C3_R4(minv_block_reg_R4_C3_dqdPE2),.minvm_in_C3_R5(minv_block_reg_R5_C3_dqdPE2),.minvm_in_C3_R6(minv_block_reg_R6_C3_dqdPE2),.minvm_in_C3_R7(minv_block_reg_R7_C3_dqdPE2),
      .minvm_in_C4_R1(minv_block_reg_R1_C4_dqdPE2),.minvm_in_C4_R2(minv_block_reg_R2_C4_dqdPE2),.minvm_in_C4_R3(minv_block_reg_R3_C4_dqdPE2),.minvm_in_C4_R4(minv_block_reg_R4_C4_dqdPE2),.minvm_in_C4_R5(minv_block_reg_R5_C4_dqdPE2),.minvm_in_C4_R6(minv_block_reg_R6_C4_dqdPE2),.minvm_in_C4_R7(minv_block_reg_R7_C4_dqdPE2),
      .minvm_in_C5_R1(minv_block_reg_R1_C5_dqdPE2),.minvm_in_C5_R2(minv_block_reg_R2_C5_dqdPE2),.minvm_in_C5_R3(minv_block_reg_R3_C5_dqdPE2),.minvm_in_C5_R4(minv_block_reg_R4_C5_dqdPE2),.minvm_in_C5_R5(minv_block_reg_R5_C5_dqdPE2),.minvm_in_C5_R6(minv_block_reg_R6_C5_dqdPE2),.minvm_in_C5_R7(minv_block_reg_R7_C5_dqdPE2),
      .minvm_in_C6_R1(minv_block_reg_R1_C6_dqdPE2),.minvm_in_C6_R2(minv_block_reg_R2_C6_dqdPE2),.minvm_in_C6_R3(minv_block_reg_R3_C6_dqdPE2),.minvm_in_C6_R4(minv_block_reg_R4_C6_dqdPE2),.minvm_in_C6_R5(minv_block_reg_R5_C6_dqdPE2),.minvm_in_C6_R6(minv_block_reg_R6_C6_dqdPE2),.minvm_in_C6_R7(minv_block_reg_R7_C6_dqdPE2),
      .minvm_in_C7_R1(minv_block_reg_R1_C7_dqdPE2),.minvm_in_C7_R2(minv_block_reg_R2_C7_dqdPE2),.minvm_in_C7_R3(minv_block_reg_R3_C7_dqdPE2),.minvm_in_C7_R4(minv_block_reg_R4_C7_dqdPE2),.minvm_in_C7_R5(minv_block_reg_R5_C7_dqdPE2),.minvm_in_C7_R6(minv_block_reg_R6_C7_dqdPE2),.minvm_in_C7_R7(minv_block_reg_R7_C7_dqdPE2),
      // tau_vec_in
      .tau_vec_in_R1(dtau_vec_reg_R1_dqdPE2),.tau_vec_in_R2(dtau_vec_reg_R2_dqdPE2),.tau_vec_in_R3(dtau_vec_reg_R3_dqdPE2),.tau_vec_in_R4(dtau_vec_reg_R4_dqdPE2),.tau_vec_in_R5(dtau_vec_reg_R5_dqdPE2),.tau_vec_in_R6(dtau_vec_reg_R6_dqdPE2),.tau_vec_in_R7(dtau_vec_reg_R7_dqdPE2),
      // minv_vec_out
      .minv_vec_out_R1(minv_vec_out_R1_dqdPE2),.minv_vec_out_R2(minv_vec_out_R2_dqdPE2),.minv_vec_out_R3(minv_vec_out_R3_dqdPE2),.minv_vec_out_R4(minv_vec_out_R4_dqdPE2),.minv_vec_out_R5(minv_vec_out_R5_dqdPE2),.minv_vec_out_R6(minv_vec_out_R6_dqdPE2),.minv_vec_out_R7(minv_vec_out_R7_dqdPE2)
      );

   // dqdPE3
   dqdbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdbpi3(
      // link_in
      .link_in(link_reg_dqdPE3),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqdPE3),.cosq_in(cosq_val_reg_dqdPE3),
      // dfdqd_curr_in, 6 values
      .dfdqd_curr_in_AX(dfdqd_upd_curr_vec_reg_AX_dqdPE3),.dfdqd_curr_in_AY(dfdqd_upd_curr_vec_reg_AY_dqdPE3),.dfdqd_curr_in_AZ(dfdqd_upd_curr_vec_reg_AZ_dqdPE3),.dfdqd_curr_in_LX(dfdqd_upd_curr_vec_reg_LX_dqdPE3),.dfdqd_curr_in_LY(dfdqd_upd_curr_vec_reg_LY_dqdPE3),.dfdqd_curr_in_LZ(dfdqd_upd_curr_vec_reg_LZ_dqdPE3),
      // dfdqd_prev_in, 6 values
      .dfdqd_prev_in_AX(dfdqd_prev_vec_reg_AX_dqdPE3),.dfdqd_prev_in_AY(dfdqd_prev_vec_reg_AY_dqdPE3),.dfdqd_prev_in_AZ(dfdqd_prev_vec_reg_AZ_dqdPE3),.dfdqd_prev_in_LX(dfdqd_prev_vec_reg_LX_dqdPE3),.dfdqd_prev_in_LY(dfdqd_prev_vec_reg_LY_dqdPE3),.dfdqd_prev_in_LZ(dfdqd_prev_vec_reg_LZ_dqdPE3),
      // dtau_dqd_out
      .dtau_dqd_out(dtau_curr_out_dqdPE3),
      // dfdqd_prev_out, 6 values
      .dfdqd_prev_out_AX(dfdqd_upd_prev_vec_out_AX_dqdPE3),.dfdqd_prev_out_AY(dfdqd_upd_prev_vec_out_AY_dqdPE3),.dfdqd_prev_out_AZ(dfdqd_upd_prev_vec_out_AZ_dqdPE3),.dfdqd_prev_out_LX(dfdqd_upd_prev_vec_out_LX_dqdPE3),.dfdqd_prev_out_LY(dfdqd_upd_prev_vec_out_LY_dqdPE3),.dfdqd_prev_out_LZ(dfdqd_upd_prev_vec_out_LZ_dqdPE3),
      // minv boolean
      .minv(minv_bool_reg),
      // minvm_in
      .minvm_in_C1_R1(minv_block_reg_R1_C1_dqdPE3),.minvm_in_C1_R2(minv_block_reg_R2_C1_dqdPE3),.minvm_in_C1_R3(minv_block_reg_R3_C1_dqdPE3),.minvm_in_C1_R4(minv_block_reg_R4_C1_dqdPE3),.minvm_in_C1_R5(minv_block_reg_R5_C1_dqdPE3),.minvm_in_C1_R6(minv_block_reg_R6_C1_dqdPE3),.minvm_in_C1_R7(minv_block_reg_R7_C1_dqdPE3),
      .minvm_in_C2_R1(minv_block_reg_R1_C2_dqdPE3),.minvm_in_C2_R2(minv_block_reg_R2_C2_dqdPE3),.minvm_in_C2_R3(minv_block_reg_R3_C2_dqdPE3),.minvm_in_C2_R4(minv_block_reg_R4_C2_dqdPE3),.minvm_in_C2_R5(minv_block_reg_R5_C2_dqdPE3),.minvm_in_C2_R6(minv_block_reg_R6_C2_dqdPE3),.minvm_in_C2_R7(minv_block_reg_R7_C2_dqdPE3),
      .minvm_in_C3_R1(minv_block_reg_R1_C3_dqdPE3),.minvm_in_C3_R2(minv_block_reg_R2_C3_dqdPE3),.minvm_in_C3_R3(minv_block_reg_R3_C3_dqdPE3),.minvm_in_C3_R4(minv_block_reg_R4_C3_dqdPE3),.minvm_in_C3_R5(minv_block_reg_R5_C3_dqdPE3),.minvm_in_C3_R6(minv_block_reg_R6_C3_dqdPE3),.minvm_in_C3_R7(minv_block_reg_R7_C3_dqdPE3),
      .minvm_in_C4_R1(minv_block_reg_R1_C4_dqdPE3),.minvm_in_C4_R2(minv_block_reg_R2_C4_dqdPE3),.minvm_in_C4_R3(minv_block_reg_R3_C4_dqdPE3),.minvm_in_C4_R4(minv_block_reg_R4_C4_dqdPE3),.minvm_in_C4_R5(minv_block_reg_R5_C4_dqdPE3),.minvm_in_C4_R6(minv_block_reg_R6_C4_dqdPE3),.minvm_in_C4_R7(minv_block_reg_R7_C4_dqdPE3),
      .minvm_in_C5_R1(minv_block_reg_R1_C5_dqdPE3),.minvm_in_C5_R2(minv_block_reg_R2_C5_dqdPE3),.minvm_in_C5_R3(minv_block_reg_R3_C5_dqdPE3),.minvm_in_C5_R4(minv_block_reg_R4_C5_dqdPE3),.minvm_in_C5_R5(minv_block_reg_R5_C5_dqdPE3),.minvm_in_C5_R6(minv_block_reg_R6_C5_dqdPE3),.minvm_in_C5_R7(minv_block_reg_R7_C5_dqdPE3),
      .minvm_in_C6_R1(minv_block_reg_R1_C6_dqdPE3),.minvm_in_C6_R2(minv_block_reg_R2_C6_dqdPE3),.minvm_in_C6_R3(minv_block_reg_R3_C6_dqdPE3),.minvm_in_C6_R4(minv_block_reg_R4_C6_dqdPE3),.minvm_in_C6_R5(minv_block_reg_R5_C6_dqdPE3),.minvm_in_C6_R6(minv_block_reg_R6_C6_dqdPE3),.minvm_in_C6_R7(minv_block_reg_R7_C6_dqdPE3),
      .minvm_in_C7_R1(minv_block_reg_R1_C7_dqdPE3),.minvm_in_C7_R2(minv_block_reg_R2_C7_dqdPE3),.minvm_in_C7_R3(minv_block_reg_R3_C7_dqdPE3),.minvm_in_C7_R4(minv_block_reg_R4_C7_dqdPE3),.minvm_in_C7_R5(minv_block_reg_R5_C7_dqdPE3),.minvm_in_C7_R6(minv_block_reg_R6_C7_dqdPE3),.minvm_in_C7_R7(minv_block_reg_R7_C7_dqdPE3),
      // tau_vec_in
      .tau_vec_in_R1(dtau_vec_reg_R1_dqdPE3),.tau_vec_in_R2(dtau_vec_reg_R2_dqdPE3),.tau_vec_in_R3(dtau_vec_reg_R3_dqdPE3),.tau_vec_in_R4(dtau_vec_reg_R4_dqdPE3),.tau_vec_in_R5(dtau_vec_reg_R5_dqdPE3),.tau_vec_in_R6(dtau_vec_reg_R6_dqdPE3),.tau_vec_in_R7(dtau_vec_reg_R7_dqdPE3),
      // minv_vec_out
      .minv_vec_out_R1(minv_vec_out_R1_dqdPE3),.minv_vec_out_R2(minv_vec_out_R2_dqdPE3),.minv_vec_out_R3(minv_vec_out_R3_dqdPE3),.minv_vec_out_R4(minv_vec_out_R4_dqdPE3),.minv_vec_out_R5(minv_vec_out_R5_dqdPE3),.minv_vec_out_R6(minv_vec_out_R6_dqdPE3),.minv_vec_out_R7(minv_vec_out_R7_dqdPE3)
      );

   // dqdPE4
   dqdbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdbpi4(
      // link_in
      .link_in(link_reg_dqdPE4),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqdPE4),.cosq_in(cosq_val_reg_dqdPE4),
      // dfdqd_curr_in, 6 values
      .dfdqd_curr_in_AX(dfdqd_upd_curr_vec_reg_AX_dqdPE4),.dfdqd_curr_in_AY(dfdqd_upd_curr_vec_reg_AY_dqdPE4),.dfdqd_curr_in_AZ(dfdqd_upd_curr_vec_reg_AZ_dqdPE4),.dfdqd_curr_in_LX(dfdqd_upd_curr_vec_reg_LX_dqdPE4),.dfdqd_curr_in_LY(dfdqd_upd_curr_vec_reg_LY_dqdPE4),.dfdqd_curr_in_LZ(dfdqd_upd_curr_vec_reg_LZ_dqdPE4),
      // dfdqd_prev_in, 6 values
      .dfdqd_prev_in_AX(dfdqd_prev_vec_reg_AX_dqdPE4),.dfdqd_prev_in_AY(dfdqd_prev_vec_reg_AY_dqdPE4),.dfdqd_prev_in_AZ(dfdqd_prev_vec_reg_AZ_dqdPE4),.dfdqd_prev_in_LX(dfdqd_prev_vec_reg_LX_dqdPE4),.dfdqd_prev_in_LY(dfdqd_prev_vec_reg_LY_dqdPE4),.dfdqd_prev_in_LZ(dfdqd_prev_vec_reg_LZ_dqdPE4),
      // dtau_dqd_out
      .dtau_dqd_out(dtau_curr_out_dqdPE4),
      // dfdqd_prev_out, 6 values
      .dfdqd_prev_out_AX(dfdqd_upd_prev_vec_out_AX_dqdPE4),.dfdqd_prev_out_AY(dfdqd_upd_prev_vec_out_AY_dqdPE4),.dfdqd_prev_out_AZ(dfdqd_upd_prev_vec_out_AZ_dqdPE4),.dfdqd_prev_out_LX(dfdqd_upd_prev_vec_out_LX_dqdPE4),.dfdqd_prev_out_LY(dfdqd_upd_prev_vec_out_LY_dqdPE4),.dfdqd_prev_out_LZ(dfdqd_upd_prev_vec_out_LZ_dqdPE4),
      // minv boolean
      .minv(minv_bool_reg),
      // minvm_in
      .minvm_in_C1_R1(minv_block_reg_R1_C1_dqdPE4),.minvm_in_C1_R2(minv_block_reg_R2_C1_dqdPE4),.minvm_in_C1_R3(minv_block_reg_R3_C1_dqdPE4),.minvm_in_C1_R4(minv_block_reg_R4_C1_dqdPE4),.minvm_in_C1_R5(minv_block_reg_R5_C1_dqdPE4),.minvm_in_C1_R6(minv_block_reg_R6_C1_dqdPE4),.minvm_in_C1_R7(minv_block_reg_R7_C1_dqdPE4),
      .minvm_in_C2_R1(minv_block_reg_R1_C2_dqdPE4),.minvm_in_C2_R2(minv_block_reg_R2_C2_dqdPE4),.minvm_in_C2_R3(minv_block_reg_R3_C2_dqdPE4),.minvm_in_C2_R4(minv_block_reg_R4_C2_dqdPE4),.minvm_in_C2_R5(minv_block_reg_R5_C2_dqdPE4),.minvm_in_C2_R6(minv_block_reg_R6_C2_dqdPE4),.minvm_in_C2_R7(minv_block_reg_R7_C2_dqdPE4),
      .minvm_in_C3_R1(minv_block_reg_R1_C3_dqdPE4),.minvm_in_C3_R2(minv_block_reg_R2_C3_dqdPE4),.minvm_in_C3_R3(minv_block_reg_R3_C3_dqdPE4),.minvm_in_C3_R4(minv_block_reg_R4_C3_dqdPE4),.minvm_in_C3_R5(minv_block_reg_R5_C3_dqdPE4),.minvm_in_C3_R6(minv_block_reg_R6_C3_dqdPE4),.minvm_in_C3_R7(minv_block_reg_R7_C3_dqdPE4),
      .minvm_in_C4_R1(minv_block_reg_R1_C4_dqdPE4),.minvm_in_C4_R2(minv_block_reg_R2_C4_dqdPE4),.minvm_in_C4_R3(minv_block_reg_R3_C4_dqdPE4),.minvm_in_C4_R4(minv_block_reg_R4_C4_dqdPE4),.minvm_in_C4_R5(minv_block_reg_R5_C4_dqdPE4),.minvm_in_C4_R6(minv_block_reg_R6_C4_dqdPE4),.minvm_in_C4_R7(minv_block_reg_R7_C4_dqdPE4),
      .minvm_in_C5_R1(minv_block_reg_R1_C5_dqdPE4),.minvm_in_C5_R2(minv_block_reg_R2_C5_dqdPE4),.minvm_in_C5_R3(minv_block_reg_R3_C5_dqdPE4),.minvm_in_C5_R4(minv_block_reg_R4_C5_dqdPE4),.minvm_in_C5_R5(minv_block_reg_R5_C5_dqdPE4),.minvm_in_C5_R6(minv_block_reg_R6_C5_dqdPE4),.minvm_in_C5_R7(minv_block_reg_R7_C5_dqdPE4),
      .minvm_in_C6_R1(minv_block_reg_R1_C6_dqdPE4),.minvm_in_C6_R2(minv_block_reg_R2_C6_dqdPE4),.minvm_in_C6_R3(minv_block_reg_R3_C6_dqdPE4),.minvm_in_C6_R4(minv_block_reg_R4_C6_dqdPE4),.minvm_in_C6_R5(minv_block_reg_R5_C6_dqdPE4),.minvm_in_C6_R6(minv_block_reg_R6_C6_dqdPE4),.minvm_in_C6_R7(minv_block_reg_R7_C6_dqdPE4),
      .minvm_in_C7_R1(minv_block_reg_R1_C7_dqdPE4),.minvm_in_C7_R2(minv_block_reg_R2_C7_dqdPE4),.minvm_in_C7_R3(minv_block_reg_R3_C7_dqdPE4),.minvm_in_C7_R4(minv_block_reg_R4_C7_dqdPE4),.minvm_in_C7_R5(minv_block_reg_R5_C7_dqdPE4),.minvm_in_C7_R6(minv_block_reg_R6_C7_dqdPE4),.minvm_in_C7_R7(minv_block_reg_R7_C7_dqdPE4),
      // tau_vec_in
      .tau_vec_in_R1(dtau_vec_reg_R1_dqdPE4),.tau_vec_in_R2(dtau_vec_reg_R2_dqdPE4),.tau_vec_in_R3(dtau_vec_reg_R3_dqdPE4),.tau_vec_in_R4(dtau_vec_reg_R4_dqdPE4),.tau_vec_in_R5(dtau_vec_reg_R5_dqdPE4),.tau_vec_in_R6(dtau_vec_reg_R6_dqdPE4),.tau_vec_in_R7(dtau_vec_reg_R7_dqdPE4),
      // minv_vec_out
      .minv_vec_out_R1(minv_vec_out_R1_dqdPE4),.minv_vec_out_R2(minv_vec_out_R2_dqdPE4),.minv_vec_out_R3(minv_vec_out_R3_dqdPE4),.minv_vec_out_R4(minv_vec_out_R4_dqdPE4),.minv_vec_out_R5(minv_vec_out_R5_dqdPE4),.minv_vec_out_R6(minv_vec_out_R6_dqdPE4),.minv_vec_out_R7(minv_vec_out_R7_dqdPE4)
      );

   // dqdPE5
   dqdbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdbpi5(
      // link_in
      .link_in(link_reg_dqdPE5),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqdPE5),.cosq_in(cosq_val_reg_dqdPE5),
      // dfdqd_curr_in, 6 values
      .dfdqd_curr_in_AX(dfdqd_upd_curr_vec_reg_AX_dqdPE5),.dfdqd_curr_in_AY(dfdqd_upd_curr_vec_reg_AY_dqdPE5),.dfdqd_curr_in_AZ(dfdqd_upd_curr_vec_reg_AZ_dqdPE5),.dfdqd_curr_in_LX(dfdqd_upd_curr_vec_reg_LX_dqdPE5),.dfdqd_curr_in_LY(dfdqd_upd_curr_vec_reg_LY_dqdPE5),.dfdqd_curr_in_LZ(dfdqd_upd_curr_vec_reg_LZ_dqdPE5),
      // dfdqd_prev_in, 6 values
      .dfdqd_prev_in_AX(dfdqd_prev_vec_reg_AX_dqdPE5),.dfdqd_prev_in_AY(dfdqd_prev_vec_reg_AY_dqdPE5),.dfdqd_prev_in_AZ(dfdqd_prev_vec_reg_AZ_dqdPE5),.dfdqd_prev_in_LX(dfdqd_prev_vec_reg_LX_dqdPE5),.dfdqd_prev_in_LY(dfdqd_prev_vec_reg_LY_dqdPE5),.dfdqd_prev_in_LZ(dfdqd_prev_vec_reg_LZ_dqdPE5),
      // dtau_dqd_out
      .dtau_dqd_out(dtau_curr_out_dqdPE5),
      // dfdqd_prev_out, 6 values
      .dfdqd_prev_out_AX(dfdqd_upd_prev_vec_out_AX_dqdPE5),.dfdqd_prev_out_AY(dfdqd_upd_prev_vec_out_AY_dqdPE5),.dfdqd_prev_out_AZ(dfdqd_upd_prev_vec_out_AZ_dqdPE5),.dfdqd_prev_out_LX(dfdqd_upd_prev_vec_out_LX_dqdPE5),.dfdqd_prev_out_LY(dfdqd_upd_prev_vec_out_LY_dqdPE5),.dfdqd_prev_out_LZ(dfdqd_upd_prev_vec_out_LZ_dqdPE5),
      // minv boolean
      .minv(minv_bool_reg),
      // minvm_in
      .minvm_in_C1_R1(minv_block_reg_R1_C1_dqdPE5),.minvm_in_C1_R2(minv_block_reg_R2_C1_dqdPE5),.minvm_in_C1_R3(minv_block_reg_R3_C1_dqdPE5),.minvm_in_C1_R4(minv_block_reg_R4_C1_dqdPE5),.minvm_in_C1_R5(minv_block_reg_R5_C1_dqdPE5),.minvm_in_C1_R6(minv_block_reg_R6_C1_dqdPE5),.minvm_in_C1_R7(minv_block_reg_R7_C1_dqdPE5),
      .minvm_in_C2_R1(minv_block_reg_R1_C2_dqdPE5),.minvm_in_C2_R2(minv_block_reg_R2_C2_dqdPE5),.minvm_in_C2_R3(minv_block_reg_R3_C2_dqdPE5),.minvm_in_C2_R4(minv_block_reg_R4_C2_dqdPE5),.minvm_in_C2_R5(minv_block_reg_R5_C2_dqdPE5),.minvm_in_C2_R6(minv_block_reg_R6_C2_dqdPE5),.minvm_in_C2_R7(minv_block_reg_R7_C2_dqdPE5),
      .minvm_in_C3_R1(minv_block_reg_R1_C3_dqdPE5),.minvm_in_C3_R2(minv_block_reg_R2_C3_dqdPE5),.minvm_in_C3_R3(minv_block_reg_R3_C3_dqdPE5),.minvm_in_C3_R4(minv_block_reg_R4_C3_dqdPE5),.minvm_in_C3_R5(minv_block_reg_R5_C3_dqdPE5),.minvm_in_C3_R6(minv_block_reg_R6_C3_dqdPE5),.minvm_in_C3_R7(minv_block_reg_R7_C3_dqdPE5),
      .minvm_in_C4_R1(minv_block_reg_R1_C4_dqdPE5),.minvm_in_C4_R2(minv_block_reg_R2_C4_dqdPE5),.minvm_in_C4_R3(minv_block_reg_R3_C4_dqdPE5),.minvm_in_C4_R4(minv_block_reg_R4_C4_dqdPE5),.minvm_in_C4_R5(minv_block_reg_R5_C4_dqdPE5),.minvm_in_C4_R6(minv_block_reg_R6_C4_dqdPE5),.minvm_in_C4_R7(minv_block_reg_R7_C4_dqdPE5),
      .minvm_in_C5_R1(minv_block_reg_R1_C5_dqdPE5),.minvm_in_C5_R2(minv_block_reg_R2_C5_dqdPE5),.minvm_in_C5_R3(minv_block_reg_R3_C5_dqdPE5),.minvm_in_C5_R4(minv_block_reg_R4_C5_dqdPE5),.minvm_in_C5_R5(minv_block_reg_R5_C5_dqdPE5),.minvm_in_C5_R6(minv_block_reg_R6_C5_dqdPE5),.minvm_in_C5_R7(minv_block_reg_R7_C5_dqdPE5),
      .minvm_in_C6_R1(minv_block_reg_R1_C6_dqdPE5),.minvm_in_C6_R2(minv_block_reg_R2_C6_dqdPE5),.minvm_in_C6_R3(minv_block_reg_R3_C6_dqdPE5),.minvm_in_C6_R4(minv_block_reg_R4_C6_dqdPE5),.minvm_in_C6_R5(minv_block_reg_R5_C6_dqdPE5),.minvm_in_C6_R6(minv_block_reg_R6_C6_dqdPE5),.minvm_in_C6_R7(minv_block_reg_R7_C6_dqdPE5),
      .minvm_in_C7_R1(minv_block_reg_R1_C7_dqdPE5),.minvm_in_C7_R2(minv_block_reg_R2_C7_dqdPE5),.minvm_in_C7_R3(minv_block_reg_R3_C7_dqdPE5),.minvm_in_C7_R4(minv_block_reg_R4_C7_dqdPE5),.minvm_in_C7_R5(minv_block_reg_R5_C7_dqdPE5),.minvm_in_C7_R6(minv_block_reg_R6_C7_dqdPE5),.minvm_in_C7_R7(minv_block_reg_R7_C7_dqdPE5),
      // tau_vec_in
      .tau_vec_in_R1(dtau_vec_reg_R1_dqdPE5),.tau_vec_in_R2(dtau_vec_reg_R2_dqdPE5),.tau_vec_in_R3(dtau_vec_reg_R3_dqdPE5),.tau_vec_in_R4(dtau_vec_reg_R4_dqdPE5),.tau_vec_in_R5(dtau_vec_reg_R5_dqdPE5),.tau_vec_in_R6(dtau_vec_reg_R6_dqdPE5),.tau_vec_in_R7(dtau_vec_reg_R7_dqdPE5),
      // minv_vec_out
      .minv_vec_out_R1(minv_vec_out_R1_dqdPE5),.minv_vec_out_R2(minv_vec_out_R2_dqdPE5),.minv_vec_out_R3(minv_vec_out_R3_dqdPE5),.minv_vec_out_R4(minv_vec_out_R4_dqdPE5),.minv_vec_out_R5(minv_vec_out_R5_dqdPE5),.minv_vec_out_R6(minv_vec_out_R6_dqdPE5),.minv_vec_out_R7(minv_vec_out_R7_dqdPE5)
      );

   // dqdPE6
   dqdbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdbpi6(
      // link_in
      .link_in(link_reg_dqdPE6),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqdPE6),.cosq_in(cosq_val_reg_dqdPE6),
      // dfdqd_curr_in, 6 values
      .dfdqd_curr_in_AX(dfdqd_upd_curr_vec_reg_AX_dqdPE6),.dfdqd_curr_in_AY(dfdqd_upd_curr_vec_reg_AY_dqdPE6),.dfdqd_curr_in_AZ(dfdqd_upd_curr_vec_reg_AZ_dqdPE6),.dfdqd_curr_in_LX(dfdqd_upd_curr_vec_reg_LX_dqdPE6),.dfdqd_curr_in_LY(dfdqd_upd_curr_vec_reg_LY_dqdPE6),.dfdqd_curr_in_LZ(dfdqd_upd_curr_vec_reg_LZ_dqdPE6),
      // dfdqd_prev_in, 6 values
      .dfdqd_prev_in_AX(dfdqd_prev_vec_reg_AX_dqdPE6),.dfdqd_prev_in_AY(dfdqd_prev_vec_reg_AY_dqdPE6),.dfdqd_prev_in_AZ(dfdqd_prev_vec_reg_AZ_dqdPE6),.dfdqd_prev_in_LX(dfdqd_prev_vec_reg_LX_dqdPE6),.dfdqd_prev_in_LY(dfdqd_prev_vec_reg_LY_dqdPE6),.dfdqd_prev_in_LZ(dfdqd_prev_vec_reg_LZ_dqdPE6),
      // dtau_dqd_out
      .dtau_dqd_out(dtau_curr_out_dqdPE6),
      // dfdqd_prev_out, 6 values
      .dfdqd_prev_out_AX(dfdqd_upd_prev_vec_out_AX_dqdPE6),.dfdqd_prev_out_AY(dfdqd_upd_prev_vec_out_AY_dqdPE6),.dfdqd_prev_out_AZ(dfdqd_upd_prev_vec_out_AZ_dqdPE6),.dfdqd_prev_out_LX(dfdqd_upd_prev_vec_out_LX_dqdPE6),.dfdqd_prev_out_LY(dfdqd_upd_prev_vec_out_LY_dqdPE6),.dfdqd_prev_out_LZ(dfdqd_upd_prev_vec_out_LZ_dqdPE6),
      // minv boolean
      .minv(minv_bool_reg),
      // minvm_in
      .minvm_in_C1_R1(minv_block_reg_R1_C1_dqdPE6),.minvm_in_C1_R2(minv_block_reg_R2_C1_dqdPE6),.minvm_in_C1_R3(minv_block_reg_R3_C1_dqdPE6),.minvm_in_C1_R4(minv_block_reg_R4_C1_dqdPE6),.minvm_in_C1_R5(minv_block_reg_R5_C1_dqdPE6),.minvm_in_C1_R6(minv_block_reg_R6_C1_dqdPE6),.minvm_in_C1_R7(minv_block_reg_R7_C1_dqdPE6),
      .minvm_in_C2_R1(minv_block_reg_R1_C2_dqdPE6),.minvm_in_C2_R2(minv_block_reg_R2_C2_dqdPE6),.minvm_in_C2_R3(minv_block_reg_R3_C2_dqdPE6),.minvm_in_C2_R4(minv_block_reg_R4_C2_dqdPE6),.minvm_in_C2_R5(minv_block_reg_R5_C2_dqdPE6),.minvm_in_C2_R6(minv_block_reg_R6_C2_dqdPE6),.minvm_in_C2_R7(minv_block_reg_R7_C2_dqdPE6),
      .minvm_in_C3_R1(minv_block_reg_R1_C3_dqdPE6),.minvm_in_C3_R2(minv_block_reg_R2_C3_dqdPE6),.minvm_in_C3_R3(minv_block_reg_R3_C3_dqdPE6),.minvm_in_C3_R4(minv_block_reg_R4_C3_dqdPE6),.minvm_in_C3_R5(minv_block_reg_R5_C3_dqdPE6),.minvm_in_C3_R6(minv_block_reg_R6_C3_dqdPE6),.minvm_in_C3_R7(minv_block_reg_R7_C3_dqdPE6),
      .minvm_in_C4_R1(minv_block_reg_R1_C4_dqdPE6),.minvm_in_C4_R2(minv_block_reg_R2_C4_dqdPE6),.minvm_in_C4_R3(minv_block_reg_R3_C4_dqdPE6),.minvm_in_C4_R4(minv_block_reg_R4_C4_dqdPE6),.minvm_in_C4_R5(minv_block_reg_R5_C4_dqdPE6),.minvm_in_C4_R6(minv_block_reg_R6_C4_dqdPE6),.minvm_in_C4_R7(minv_block_reg_R7_C4_dqdPE6),
      .minvm_in_C5_R1(minv_block_reg_R1_C5_dqdPE6),.minvm_in_C5_R2(minv_block_reg_R2_C5_dqdPE6),.minvm_in_C5_R3(minv_block_reg_R3_C5_dqdPE6),.minvm_in_C5_R4(minv_block_reg_R4_C5_dqdPE6),.minvm_in_C5_R5(minv_block_reg_R5_C5_dqdPE6),.minvm_in_C5_R6(minv_block_reg_R6_C5_dqdPE6),.minvm_in_C5_R7(minv_block_reg_R7_C5_dqdPE6),
      .minvm_in_C6_R1(minv_block_reg_R1_C6_dqdPE6),.minvm_in_C6_R2(minv_block_reg_R2_C6_dqdPE6),.minvm_in_C6_R3(minv_block_reg_R3_C6_dqdPE6),.minvm_in_C6_R4(minv_block_reg_R4_C6_dqdPE6),.minvm_in_C6_R5(minv_block_reg_R5_C6_dqdPE6),.minvm_in_C6_R6(minv_block_reg_R6_C6_dqdPE6),.minvm_in_C6_R7(minv_block_reg_R7_C6_dqdPE6),
      .minvm_in_C7_R1(minv_block_reg_R1_C7_dqdPE6),.minvm_in_C7_R2(minv_block_reg_R2_C7_dqdPE6),.minvm_in_C7_R3(minv_block_reg_R3_C7_dqdPE6),.minvm_in_C7_R4(minv_block_reg_R4_C7_dqdPE6),.minvm_in_C7_R5(minv_block_reg_R5_C7_dqdPE6),.minvm_in_C7_R6(minv_block_reg_R6_C7_dqdPE6),.minvm_in_C7_R7(minv_block_reg_R7_C7_dqdPE6),
      // tau_vec_in
      .tau_vec_in_R1(dtau_vec_reg_R1_dqdPE6),.tau_vec_in_R2(dtau_vec_reg_R2_dqdPE6),.tau_vec_in_R3(dtau_vec_reg_R3_dqdPE6),.tau_vec_in_R4(dtau_vec_reg_R4_dqdPE6),.tau_vec_in_R5(dtau_vec_reg_R5_dqdPE6),.tau_vec_in_R6(dtau_vec_reg_R6_dqdPE6),.tau_vec_in_R7(dtau_vec_reg_R7_dqdPE6),
      // minv_vec_out
      .minv_vec_out_R1(minv_vec_out_R1_dqdPE6),.minv_vec_out_R2(minv_vec_out_R2_dqdPE6),.minv_vec_out_R3(minv_vec_out_R3_dqdPE6),.minv_vec_out_R4(minv_vec_out_R4_dqdPE6),.minv_vec_out_R5(minv_vec_out_R5_dqdPE6),.minv_vec_out_R6(minv_vec_out_R6_dqdPE6),.minv_vec_out_R7(minv_vec_out_R7_dqdPE6)
      );

   // dqdPE7
   dqdbpijx#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      dqdbpi7(
      // link_in
      .link_in(link_reg_dqdPE7),
      // sin(q) and cos(q)
      .sinq_in(sinq_val_reg_dqdPE7),.cosq_in(cosq_val_reg_dqdPE7),
      // dfdqd_curr_in, 6 values
      .dfdqd_curr_in_AX(dfdqd_upd_curr_vec_reg_AX_dqdPE7),.dfdqd_curr_in_AY(dfdqd_upd_curr_vec_reg_AY_dqdPE7),.dfdqd_curr_in_AZ(dfdqd_upd_curr_vec_reg_AZ_dqdPE7),.dfdqd_curr_in_LX(dfdqd_upd_curr_vec_reg_LX_dqdPE7),.dfdqd_curr_in_LY(dfdqd_upd_curr_vec_reg_LY_dqdPE7),.dfdqd_curr_in_LZ(dfdqd_upd_curr_vec_reg_LZ_dqdPE7),
      // dfdqd_prev_in, 6 values
      .dfdqd_prev_in_AX(dfdqd_prev_vec_reg_AX_dqdPE7),.dfdqd_prev_in_AY(dfdqd_prev_vec_reg_AY_dqdPE7),.dfdqd_prev_in_AZ(dfdqd_prev_vec_reg_AZ_dqdPE7),.dfdqd_prev_in_LX(dfdqd_prev_vec_reg_LX_dqdPE7),.dfdqd_prev_in_LY(dfdqd_prev_vec_reg_LY_dqdPE7),.dfdqd_prev_in_LZ(dfdqd_prev_vec_reg_LZ_dqdPE7),
      // dtau_dqd_out
      .dtau_dqd_out(dtau_curr_out_dqdPE7),
      // dfdqd_prev_out, 6 values
      .dfdqd_prev_out_AX(dfdqd_upd_prev_vec_out_AX_dqdPE7),.dfdqd_prev_out_AY(dfdqd_upd_prev_vec_out_AY_dqdPE7),.dfdqd_prev_out_AZ(dfdqd_upd_prev_vec_out_AZ_dqdPE7),.dfdqd_prev_out_LX(dfdqd_upd_prev_vec_out_LX_dqdPE7),.dfdqd_prev_out_LY(dfdqd_upd_prev_vec_out_LY_dqdPE7),.dfdqd_prev_out_LZ(dfdqd_upd_prev_vec_out_LZ_dqdPE7),
      // minv boolean
      .minv(minv_bool_reg),
      // minvm_in
      .minvm_in_C1_R1(minv_block_reg_R1_C1_dqdPE7),.minvm_in_C1_R2(minv_block_reg_R2_C1_dqdPE7),.minvm_in_C1_R3(minv_block_reg_R3_C1_dqdPE7),.minvm_in_C1_R4(minv_block_reg_R4_C1_dqdPE7),.minvm_in_C1_R5(minv_block_reg_R5_C1_dqdPE7),.minvm_in_C1_R6(minv_block_reg_R6_C1_dqdPE7),.minvm_in_C1_R7(minv_block_reg_R7_C1_dqdPE7),
      .minvm_in_C2_R1(minv_block_reg_R1_C2_dqdPE7),.minvm_in_C2_R2(minv_block_reg_R2_C2_dqdPE7),.minvm_in_C2_R3(minv_block_reg_R3_C2_dqdPE7),.minvm_in_C2_R4(minv_block_reg_R4_C2_dqdPE7),.minvm_in_C2_R5(minv_block_reg_R5_C2_dqdPE7),.minvm_in_C2_R6(minv_block_reg_R6_C2_dqdPE7),.minvm_in_C2_R7(minv_block_reg_R7_C2_dqdPE7),
      .minvm_in_C3_R1(minv_block_reg_R1_C3_dqdPE7),.minvm_in_C3_R2(minv_block_reg_R2_C3_dqdPE7),.minvm_in_C3_R3(minv_block_reg_R3_C3_dqdPE7),.minvm_in_C3_R4(minv_block_reg_R4_C3_dqdPE7),.minvm_in_C3_R5(minv_block_reg_R5_C3_dqdPE7),.minvm_in_C3_R6(minv_block_reg_R6_C3_dqdPE7),.minvm_in_C3_R7(minv_block_reg_R7_C3_dqdPE7),
      .minvm_in_C4_R1(minv_block_reg_R1_C4_dqdPE7),.minvm_in_C4_R2(minv_block_reg_R2_C4_dqdPE7),.minvm_in_C4_R3(minv_block_reg_R3_C4_dqdPE7),.minvm_in_C4_R4(minv_block_reg_R4_C4_dqdPE7),.minvm_in_C4_R5(minv_block_reg_R5_C4_dqdPE7),.minvm_in_C4_R6(minv_block_reg_R6_C4_dqdPE7),.minvm_in_C4_R7(minv_block_reg_R7_C4_dqdPE7),
      .minvm_in_C5_R1(minv_block_reg_R1_C5_dqdPE7),.minvm_in_C5_R2(minv_block_reg_R2_C5_dqdPE7),.minvm_in_C5_R3(minv_block_reg_R3_C5_dqdPE7),.minvm_in_C5_R4(minv_block_reg_R4_C5_dqdPE7),.minvm_in_C5_R5(minv_block_reg_R5_C5_dqdPE7),.minvm_in_C5_R6(minv_block_reg_R6_C5_dqdPE7),.minvm_in_C5_R7(minv_block_reg_R7_C5_dqdPE7),
      .minvm_in_C6_R1(minv_block_reg_R1_C6_dqdPE7),.minvm_in_C6_R2(minv_block_reg_R2_C6_dqdPE7),.minvm_in_C6_R3(minv_block_reg_R3_C6_dqdPE7),.minvm_in_C6_R4(minv_block_reg_R4_C6_dqdPE7),.minvm_in_C6_R5(minv_block_reg_R5_C6_dqdPE7),.minvm_in_C6_R6(minv_block_reg_R6_C6_dqdPE7),.minvm_in_C6_R7(minv_block_reg_R7_C6_dqdPE7),
      .minvm_in_C7_R1(minv_block_reg_R1_C7_dqdPE7),.minvm_in_C7_R2(minv_block_reg_R2_C7_dqdPE7),.minvm_in_C7_R3(minv_block_reg_R3_C7_dqdPE7),.minvm_in_C7_R4(minv_block_reg_R4_C7_dqdPE7),.minvm_in_C7_R5(minv_block_reg_R5_C7_dqdPE7),.minvm_in_C7_R6(minv_block_reg_R6_C7_dqdPE7),.minvm_in_C7_R7(minv_block_reg_R7_C7_dqdPE7),
      // tau_vec_in
      .tau_vec_in_R1(dtau_vec_reg_R1_dqdPE7),.tau_vec_in_R2(dtau_vec_reg_R2_dqdPE7),.tau_vec_in_R3(dtau_vec_reg_R3_dqdPE7),.tau_vec_in_R4(dtau_vec_reg_R4_dqdPE7),.tau_vec_in_R5(dtau_vec_reg_R5_dqdPE7),.tau_vec_in_R6(dtau_vec_reg_R6_dqdPE7),.tau_vec_in_R7(dtau_vec_reg_R7_dqdPE7),
      // minv_vec_out
      .minv_vec_out_R1(minv_vec_out_R1_dqdPE7),.minv_vec_out_R2(minv_vec_out_R2_dqdPE7),.minv_vec_out_R3(minv_vec_out_R3_dqdPE7),.minv_vec_out_R4(minv_vec_out_R4_dqdPE7),.minv_vec_out_R5(minv_vec_out_R5_dqdPE7),.minv_vec_out_R6(minv_vec_out_R6_dqdPE7),.minv_vec_out_R7(minv_vec_out_R7_dqdPE7)
      );

endmodule
