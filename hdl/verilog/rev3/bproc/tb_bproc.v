`timescale 1ns / 1ps

// Testbench for Backward Pass Row Unit with RNEA and Minv

//------------------------------------------------------------------------------
// bproc Testbench
//------------------------------------------------------------------------------
module tb_bproc();

   parameter WIDTH = 32;
   parameter DECIMAL_BITS = 16;

   // clock
   reg  clk;
   // reset
   reg  reset;
   // get_data
   reg  get_data;
   // minv_prev_vec_in
   reg  signed[(WIDTH-1):0]
      minv_prev_vec_in_C1,minv_prev_vec_in_C2,minv_prev_vec_in_C3,minv_prev_vec_in_C4,minv_prev_vec_in_C5,minv_prev_vec_in_C6,minv_prev_vec_in_C7;
   //---------------------------------------------------------------------------
   // rnea external inputs
   //---------------------------------------------------------------------------
   // rnea
   reg [3:0]
      link_in_rnea;
   reg signed[(WIDTH-1):0]
      sinq_val_in_rnea,cosq_val_in_rnea,
      f_upd_curr_vec_in_AX_rnea,f_upd_curr_vec_in_AY_rnea,f_upd_curr_vec_in_AZ_rnea,f_upd_curr_vec_in_LX_rnea,f_upd_curr_vec_in_LY_rnea,f_upd_curr_vec_in_LZ_rnea,
      f_prev_vec_in_AX_rnea,f_prev_vec_in_AY_rnea,f_prev_vec_in_AZ_rnea,f_prev_vec_in_LX_rnea,f_prev_vec_in_LY_rnea,f_prev_vec_in_LZ_rnea;
   //---------------------------------------------------------------------------
   // dq external inputs
   //---------------------------------------------------------------------------
   // dqPE1
   reg [3:0]
      link_in_dqPE1;
   reg [3:0]
      derv_in_dqPE1;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE1,cosq_val_in_dqPE1,
      f_upd_curr_vec_in_AX_dqPE1,f_upd_curr_vec_in_AY_dqPE1,f_upd_curr_vec_in_AZ_dqPE1,f_upd_curr_vec_in_LX_dqPE1,f_upd_curr_vec_in_LY_dqPE1,f_upd_curr_vec_in_LZ_dqPE1,
      dfdq_upd_curr_vec_in_AX_dqPE1,dfdq_upd_curr_vec_in_AY_dqPE1,dfdq_upd_curr_vec_in_AZ_dqPE1,dfdq_upd_curr_vec_in_LX_dqPE1,dfdq_upd_curr_vec_in_LY_dqPE1,dfdq_upd_curr_vec_in_LZ_dqPE1;
   // dqPE2
   reg [3:0]
      link_in_dqPE2;
   reg [3:0]
      derv_in_dqPE2;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE2,cosq_val_in_dqPE2,
      f_upd_curr_vec_in_AX_dqPE2,f_upd_curr_vec_in_AY_dqPE2,f_upd_curr_vec_in_AZ_dqPE2,f_upd_curr_vec_in_LX_dqPE2,f_upd_curr_vec_in_LY_dqPE2,f_upd_curr_vec_in_LZ_dqPE2,
      dfdq_upd_curr_vec_in_AX_dqPE2,dfdq_upd_curr_vec_in_AY_dqPE2,dfdq_upd_curr_vec_in_AZ_dqPE2,dfdq_upd_curr_vec_in_LX_dqPE2,dfdq_upd_curr_vec_in_LY_dqPE2,dfdq_upd_curr_vec_in_LZ_dqPE2;
   // dqPE3
   reg [3:0]
      link_in_dqPE3;
   reg [3:0]
      derv_in_dqPE3;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE3,cosq_val_in_dqPE3,
      f_upd_curr_vec_in_AX_dqPE3,f_upd_curr_vec_in_AY_dqPE3,f_upd_curr_vec_in_AZ_dqPE3,f_upd_curr_vec_in_LX_dqPE3,f_upd_curr_vec_in_LY_dqPE3,f_upd_curr_vec_in_LZ_dqPE3,
      dfdq_upd_curr_vec_in_AX_dqPE3,dfdq_upd_curr_vec_in_AY_dqPE3,dfdq_upd_curr_vec_in_AZ_dqPE3,dfdq_upd_curr_vec_in_LX_dqPE3,dfdq_upd_curr_vec_in_LY_dqPE3,dfdq_upd_curr_vec_in_LZ_dqPE3;
   // dqPE4
   reg [3:0]
      link_in_dqPE4;
   reg [3:0]
      derv_in_dqPE4;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE4,cosq_val_in_dqPE4,
      f_upd_curr_vec_in_AX_dqPE4,f_upd_curr_vec_in_AY_dqPE4,f_upd_curr_vec_in_AZ_dqPE4,f_upd_curr_vec_in_LX_dqPE4,f_upd_curr_vec_in_LY_dqPE4,f_upd_curr_vec_in_LZ_dqPE4,
      dfdq_upd_curr_vec_in_AX_dqPE4,dfdq_upd_curr_vec_in_AY_dqPE4,dfdq_upd_curr_vec_in_AZ_dqPE4,dfdq_upd_curr_vec_in_LX_dqPE4,dfdq_upd_curr_vec_in_LY_dqPE4,dfdq_upd_curr_vec_in_LZ_dqPE4;
   // dqPE5
   reg [3:0]
      link_in_dqPE5;
   reg [3:0]
      derv_in_dqPE5;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE5,cosq_val_in_dqPE5,
      f_upd_curr_vec_in_AX_dqPE5,f_upd_curr_vec_in_AY_dqPE5,f_upd_curr_vec_in_AZ_dqPE5,f_upd_curr_vec_in_LX_dqPE5,f_upd_curr_vec_in_LY_dqPE5,f_upd_curr_vec_in_LZ_dqPE5,
      dfdq_upd_curr_vec_in_AX_dqPE5,dfdq_upd_curr_vec_in_AY_dqPE5,dfdq_upd_curr_vec_in_AZ_dqPE5,dfdq_upd_curr_vec_in_LX_dqPE5,dfdq_upd_curr_vec_in_LY_dqPE5,dfdq_upd_curr_vec_in_LZ_dqPE5;
   // dqPE6
   reg [3:0]
      link_in_dqPE6;
   reg [3:0]
      derv_in_dqPE6;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE6,cosq_val_in_dqPE6,
      f_upd_curr_vec_in_AX_dqPE6,f_upd_curr_vec_in_AY_dqPE6,f_upd_curr_vec_in_AZ_dqPE6,f_upd_curr_vec_in_LX_dqPE6,f_upd_curr_vec_in_LY_dqPE6,f_upd_curr_vec_in_LZ_dqPE6,
      dfdq_upd_curr_vec_in_AX_dqPE6,dfdq_upd_curr_vec_in_AY_dqPE6,dfdq_upd_curr_vec_in_AZ_dqPE6,dfdq_upd_curr_vec_in_LX_dqPE6,dfdq_upd_curr_vec_in_LY_dqPE6,dfdq_upd_curr_vec_in_LZ_dqPE6;
   // dqPE7
   reg [3:0]
      link_in_dqPE7;
   reg [3:0]
      derv_in_dqPE7;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqPE7,cosq_val_in_dqPE7,
      f_upd_curr_vec_in_AX_dqPE7,f_upd_curr_vec_in_AY_dqPE7,f_upd_curr_vec_in_AZ_dqPE7,f_upd_curr_vec_in_LX_dqPE7,f_upd_curr_vec_in_LY_dqPE7,f_upd_curr_vec_in_LZ_dqPE7,
      dfdq_upd_curr_vec_in_AX_dqPE7,dfdq_upd_curr_vec_in_AY_dqPE7,dfdq_upd_curr_vec_in_AZ_dqPE7,dfdq_upd_curr_vec_in_LX_dqPE7,dfdq_upd_curr_vec_in_LY_dqPE7,dfdq_upd_curr_vec_in_LZ_dqPE7;
   //---------------------------------------------------------------------------
   // dqd external inputs
   //---------------------------------------------------------------------------
   // dqdPE1
   reg [3:0]
      link_in_dqdPE1;
   reg [3:0]
      derv_in_dqdPE1;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE1,cosq_val_in_dqdPE1,
      dfdqd_upd_curr_vec_in_AX_dqdPE1,dfdqd_upd_curr_vec_in_AY_dqdPE1,dfdqd_upd_curr_vec_in_AZ_dqdPE1,dfdqd_upd_curr_vec_in_LX_dqdPE1,dfdqd_upd_curr_vec_in_LY_dqdPE1,dfdqd_upd_curr_vec_in_LZ_dqdPE1;
   // dqdPE2
   reg [3:0]
      link_in_dqdPE2;
   reg [3:0]
      derv_in_dqdPE2;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE2,cosq_val_in_dqdPE2,
      dfdqd_upd_curr_vec_in_AX_dqdPE2,dfdqd_upd_curr_vec_in_AY_dqdPE2,dfdqd_upd_curr_vec_in_AZ_dqdPE2,dfdqd_upd_curr_vec_in_LX_dqdPE2,dfdqd_upd_curr_vec_in_LY_dqdPE2,dfdqd_upd_curr_vec_in_LZ_dqdPE2;
   // dqdPE3
   reg [3:0]
      link_in_dqdPE3;
   reg [3:0]
      derv_in_dqdPE3;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE3,cosq_val_in_dqdPE3,
      dfdqd_upd_curr_vec_in_AX_dqdPE3,dfdqd_upd_curr_vec_in_AY_dqdPE3,dfdqd_upd_curr_vec_in_AZ_dqdPE3,dfdqd_upd_curr_vec_in_LX_dqdPE3,dfdqd_upd_curr_vec_in_LY_dqdPE3,dfdqd_upd_curr_vec_in_LZ_dqdPE3;
   // dqdPE4
   reg [3:0]
      link_in_dqdPE4;
   reg [3:0]
      derv_in_dqdPE4;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE4,cosq_val_in_dqdPE4,
      dfdqd_upd_curr_vec_in_AX_dqdPE4,dfdqd_upd_curr_vec_in_AY_dqdPE4,dfdqd_upd_curr_vec_in_AZ_dqdPE4,dfdqd_upd_curr_vec_in_LX_dqdPE4,dfdqd_upd_curr_vec_in_LY_dqdPE4,dfdqd_upd_curr_vec_in_LZ_dqdPE4;
   // dqdPE5
   reg [3:0]
      link_in_dqdPE5;
   reg [3:0]
      derv_in_dqdPE5;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE5,cosq_val_in_dqdPE5,
      dfdqd_upd_curr_vec_in_AX_dqdPE5,dfdqd_upd_curr_vec_in_AY_dqdPE5,dfdqd_upd_curr_vec_in_AZ_dqdPE5,dfdqd_upd_curr_vec_in_LX_dqdPE5,dfdqd_upd_curr_vec_in_LY_dqdPE5,dfdqd_upd_curr_vec_in_LZ_dqdPE5;
   // dqdPE6
   reg [3:0]
      link_in_dqdPE6;
   reg [3:0]
      derv_in_dqdPE6;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE6,cosq_val_in_dqdPE6,
      dfdqd_upd_curr_vec_in_AX_dqdPE6,dfdqd_upd_curr_vec_in_AY_dqdPE6,dfdqd_upd_curr_vec_in_AZ_dqdPE6,dfdqd_upd_curr_vec_in_LX_dqdPE6,dfdqd_upd_curr_vec_in_LY_dqdPE6,dfdqd_upd_curr_vec_in_LZ_dqdPE6;
   // dqdPE7
   reg [3:0]
      link_in_dqdPE7;
   reg [3:0]
      derv_in_dqdPE7;
   reg signed[(WIDTH-1):0]
      sinq_val_in_dqdPE7,cosq_val_in_dqdPE7,
      dfdqd_upd_curr_vec_in_AX_dqdPE7,dfdqd_upd_curr_vec_in_AY_dqdPE7,dfdqd_upd_curr_vec_in_AZ_dqdPE7,dfdqd_upd_curr_vec_in_LX_dqdPE7,dfdqd_upd_curr_vec_in_LY_dqdPE7,dfdqd_upd_curr_vec_in_LZ_dqdPE7;
   //---------------------------------------------------------------------------
   // df prev external inputs
   //---------------------------------------------------------------------------
   reg  signed[(WIDTH-1):0]
      dfdq_prev_vec_in_AX_dqPE1,dfdq_prev_vec_in_AX_dqPE2,dfdq_prev_vec_in_AX_dqPE3,dfdq_prev_vec_in_AX_dqPE4,dfdq_prev_vec_in_AX_dqPE5,dfdq_prev_vec_in_AX_dqPE6,dfdq_prev_vec_in_AX_dqPE7,
      dfdq_prev_vec_in_AY_dqPE1,dfdq_prev_vec_in_AY_dqPE2,dfdq_prev_vec_in_AY_dqPE3,dfdq_prev_vec_in_AY_dqPE4,dfdq_prev_vec_in_AY_dqPE5,dfdq_prev_vec_in_AY_dqPE6,dfdq_prev_vec_in_AY_dqPE7,
      dfdq_prev_vec_in_AZ_dqPE1,dfdq_prev_vec_in_AZ_dqPE2,dfdq_prev_vec_in_AZ_dqPE3,dfdq_prev_vec_in_AZ_dqPE4,dfdq_prev_vec_in_AZ_dqPE5,dfdq_prev_vec_in_AZ_dqPE6,dfdq_prev_vec_in_AZ_dqPE7,
      dfdq_prev_vec_in_LX_dqPE1,dfdq_prev_vec_in_LX_dqPE2,dfdq_prev_vec_in_LX_dqPE3,dfdq_prev_vec_in_LX_dqPE4,dfdq_prev_vec_in_LX_dqPE5,dfdq_prev_vec_in_LX_dqPE6,dfdq_prev_vec_in_LX_dqPE7,
      dfdq_prev_vec_in_LY_dqPE1,dfdq_prev_vec_in_LY_dqPE2,dfdq_prev_vec_in_LY_dqPE3,dfdq_prev_vec_in_LY_dqPE4,dfdq_prev_vec_in_LY_dqPE5,dfdq_prev_vec_in_LY_dqPE6,dfdq_prev_vec_in_LY_dqPE7,
      dfdq_prev_vec_in_LZ_dqPE1,dfdq_prev_vec_in_LZ_dqPE2,dfdq_prev_vec_in_LZ_dqPE3,dfdq_prev_vec_in_LZ_dqPE4,dfdq_prev_vec_in_LZ_dqPE5,dfdq_prev_vec_in_LZ_dqPE6,dfdq_prev_vec_in_LZ_dqPE7;
   reg  signed[(WIDTH-1):0]
      dfdqd_prev_vec_in_AX_dqdPE1,dfdqd_prev_vec_in_AX_dqdPE2,dfdqd_prev_vec_in_AX_dqdPE3,dfdqd_prev_vec_in_AX_dqdPE4,dfdqd_prev_vec_in_AX_dqdPE5,dfdqd_prev_vec_in_AX_dqdPE6,dfdqd_prev_vec_in_AX_dqdPE7,
      dfdqd_prev_vec_in_AY_dqdPE1,dfdqd_prev_vec_in_AY_dqdPE2,dfdqd_prev_vec_in_AY_dqdPE3,dfdqd_prev_vec_in_AY_dqdPE4,dfdqd_prev_vec_in_AY_dqdPE5,dfdqd_prev_vec_in_AY_dqdPE6,dfdqd_prev_vec_in_AY_dqdPE7,
      dfdqd_prev_vec_in_AZ_dqdPE1,dfdqd_prev_vec_in_AZ_dqdPE2,dfdqd_prev_vec_in_AZ_dqdPE3,dfdqd_prev_vec_in_AZ_dqdPE4,dfdqd_prev_vec_in_AZ_dqdPE5,dfdqd_prev_vec_in_AZ_dqdPE6,dfdqd_prev_vec_in_AZ_dqdPE7,
      dfdqd_prev_vec_in_LX_dqdPE1,dfdqd_prev_vec_in_LX_dqdPE2,dfdqd_prev_vec_in_LX_dqdPE3,dfdqd_prev_vec_in_LX_dqdPE4,dfdqd_prev_vec_in_LX_dqdPE5,dfdqd_prev_vec_in_LX_dqdPE6,dfdqd_prev_vec_in_LX_dqdPE7,
      dfdqd_prev_vec_in_LY_dqdPE1,dfdqd_prev_vec_in_LY_dqdPE2,dfdqd_prev_vec_in_LY_dqdPE3,dfdqd_prev_vec_in_LY_dqdPE4,dfdqd_prev_vec_in_LY_dqdPE5,dfdqd_prev_vec_in_LY_dqdPE6,dfdqd_prev_vec_in_LY_dqdPE7,
      dfdqd_prev_vec_in_LZ_dqdPE1,dfdqd_prev_vec_in_LZ_dqdPE2,dfdqd_prev_vec_in_LZ_dqdPE3,dfdqd_prev_vec_in_LZ_dqdPE4,dfdqd_prev_vec_in_LZ_dqdPE5,dfdqd_prev_vec_in_LZ_dqdPE6,dfdqd_prev_vec_in_LZ_dqdPE7;
   //---------------------------------------------------------------------------
   // output ready
   wire output_ready;
   // dummy output
   wire dummy_output;
//    // dtauidq_curr_vec_out
//    wire signed[(WIDTH-1):0]
//       dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7;
//    // dtauidqd_curr_vec_out
//    wire signed[(WIDTH-1):0]
//       dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7;
   // minv_dtaudq_out
   wire signed[(WIDTH-1):0]
      minv_dtaudq_out_R1_C1,minv_dtaudq_out_R1_C2,minv_dtaudq_out_R1_C3,minv_dtaudq_out_R1_C4,minv_dtaudq_out_R1_C5,minv_dtaudq_out_R1_C6,minv_dtaudq_out_R1_C7,
      minv_dtaudq_out_R2_C1,minv_dtaudq_out_R2_C2,minv_dtaudq_out_R2_C3,minv_dtaudq_out_R2_C4,minv_dtaudq_out_R2_C5,minv_dtaudq_out_R2_C6,minv_dtaudq_out_R2_C7,
      minv_dtaudq_out_R3_C1,minv_dtaudq_out_R3_C2,minv_dtaudq_out_R3_C3,minv_dtaudq_out_R3_C4,minv_dtaudq_out_R3_C5,minv_dtaudq_out_R3_C6,minv_dtaudq_out_R3_C7,
      minv_dtaudq_out_R4_C1,minv_dtaudq_out_R4_C2,minv_dtaudq_out_R4_C3,minv_dtaudq_out_R4_C4,minv_dtaudq_out_R4_C5,minv_dtaudq_out_R4_C6,minv_dtaudq_out_R4_C7,
      minv_dtaudq_out_R5_C1,minv_dtaudq_out_R5_C2,minv_dtaudq_out_R5_C3,minv_dtaudq_out_R5_C4,minv_dtaudq_out_R5_C5,minv_dtaudq_out_R5_C6,minv_dtaudq_out_R5_C7,
      minv_dtaudq_out_R6_C1,minv_dtaudq_out_R6_C2,minv_dtaudq_out_R6_C3,minv_dtaudq_out_R6_C4,minv_dtaudq_out_R6_C5,minv_dtaudq_out_R6_C6,minv_dtaudq_out_R6_C7,
      minv_dtaudq_out_R7_C1,minv_dtaudq_out_R7_C2,minv_dtaudq_out_R7_C3,minv_dtaudq_out_R7_C4,minv_dtaudq_out_R7_C5,minv_dtaudq_out_R7_C6,minv_dtaudq_out_R7_C7;
   // minv_dtaudqd_out
   wire signed[(WIDTH-1):0]
      minv_dtaudqd_out_R1_C1,minv_dtaudqd_out_R1_C2,minv_dtaudqd_out_R1_C3,minv_dtaudqd_out_R1_C4,minv_dtaudqd_out_R1_C5,minv_dtaudqd_out_R1_C6,minv_dtaudqd_out_R1_C7,
      minv_dtaudqd_out_R2_C1,minv_dtaudqd_out_R2_C2,minv_dtaudqd_out_R2_C3,minv_dtaudqd_out_R2_C4,minv_dtaudqd_out_R2_C5,minv_dtaudqd_out_R2_C6,minv_dtaudqd_out_R2_C7,
      minv_dtaudqd_out_R3_C1,minv_dtaudqd_out_R3_C2,minv_dtaudqd_out_R3_C3,minv_dtaudqd_out_R3_C4,minv_dtaudqd_out_R3_C5,minv_dtaudqd_out_R3_C6,minv_dtaudqd_out_R3_C7,
      minv_dtaudqd_out_R4_C1,minv_dtaudqd_out_R4_C2,minv_dtaudqd_out_R4_C3,minv_dtaudqd_out_R4_C4,minv_dtaudqd_out_R4_C5,minv_dtaudqd_out_R4_C6,minv_dtaudqd_out_R4_C7,
      minv_dtaudqd_out_R5_C1,minv_dtaudqd_out_R5_C2,minv_dtaudqd_out_R5_C3,minv_dtaudqd_out_R5_C4,minv_dtaudqd_out_R5_C5,minv_dtaudqd_out_R5_C6,minv_dtaudqd_out_R5_C7,
      minv_dtaudqd_out_R6_C1,minv_dtaudqd_out_R6_C2,minv_dtaudqd_out_R6_C3,minv_dtaudqd_out_R6_C4,minv_dtaudqd_out_R6_C5,minv_dtaudqd_out_R6_C6,minv_dtaudqd_out_R6_C7,
      minv_dtaudqd_out_R7_C1,minv_dtaudqd_out_R7_C2,minv_dtaudqd_out_R7_C3,minv_dtaudqd_out_R7_C4,minv_dtaudqd_out_R7_C5,minv_dtaudqd_out_R7_C6,minv_dtaudqd_out_R7_C7;
   //---------------------------------------------------------------------------
   // rnea external outputs
   //---------------------------------------------------------------------------
   // rnea
   wire signed[(WIDTH-1):0]
      tau_curr_out_rnea,
      f_upd_prev_vec_out_AX_rnea,f_upd_prev_vec_out_AY_rnea,f_upd_prev_vec_out_AZ_rnea,f_upd_prev_vec_out_LX_rnea,f_upd_prev_vec_out_LY_rnea,f_upd_prev_vec_out_LZ_rnea;
   //---------------------------------------------------------------------------
   // dq external outputs
   //---------------------------------------------------------------------------
   // dqPE1
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqPE1;
   wire signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE1,dfdq_upd_prev_vec_out_AY_dqPE1,dfdq_upd_prev_vec_out_AZ_dqPE1,dfdq_upd_prev_vec_out_LX_dqPE1,dfdq_upd_prev_vec_out_LY_dqPE1,dfdq_upd_prev_vec_out_LZ_dqPE1;
   // dqPE2
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqPE2;
   wire signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE2,dfdq_upd_prev_vec_out_AY_dqPE2,dfdq_upd_prev_vec_out_AZ_dqPE2,dfdq_upd_prev_vec_out_LX_dqPE2,dfdq_upd_prev_vec_out_LY_dqPE2,dfdq_upd_prev_vec_out_LZ_dqPE2;
   // dqPE3
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqPE3;
   wire signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE3,dfdq_upd_prev_vec_out_AY_dqPE3,dfdq_upd_prev_vec_out_AZ_dqPE3,dfdq_upd_prev_vec_out_LX_dqPE3,dfdq_upd_prev_vec_out_LY_dqPE3,dfdq_upd_prev_vec_out_LZ_dqPE3;
   // dqPE4
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqPE4;
   wire signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE4,dfdq_upd_prev_vec_out_AY_dqPE4,dfdq_upd_prev_vec_out_AZ_dqPE4,dfdq_upd_prev_vec_out_LX_dqPE4,dfdq_upd_prev_vec_out_LY_dqPE4,dfdq_upd_prev_vec_out_LZ_dqPE4;
   // dqPE5
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqPE5;
   wire signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE5,dfdq_upd_prev_vec_out_AY_dqPE5,dfdq_upd_prev_vec_out_AZ_dqPE5,dfdq_upd_prev_vec_out_LX_dqPE5,dfdq_upd_prev_vec_out_LY_dqPE5,dfdq_upd_prev_vec_out_LZ_dqPE5;
   // dqPE6
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqPE6;
   wire signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE6,dfdq_upd_prev_vec_out_AY_dqPE6,dfdq_upd_prev_vec_out_AZ_dqPE6,dfdq_upd_prev_vec_out_LX_dqPE6,dfdq_upd_prev_vec_out_LY_dqPE6,dfdq_upd_prev_vec_out_LZ_dqPE6;
   // dqPE7
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqPE7;
   wire signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_out_AX_dqPE7,dfdq_upd_prev_vec_out_AY_dqPE7,dfdq_upd_prev_vec_out_AZ_dqPE7,dfdq_upd_prev_vec_out_LX_dqPE7,dfdq_upd_prev_vec_out_LY_dqPE7,dfdq_upd_prev_vec_out_LZ_dqPE7;
   //---------------------------------------------------------------------------
   // dqd external wires
   //---------------------------------------------------------------------------
   // dqdPE1
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE1;
   wire signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE1,dfdqd_upd_prev_vec_out_AY_dqdPE1,dfdqd_upd_prev_vec_out_AZ_dqdPE1,dfdqd_upd_prev_vec_out_LX_dqdPE1,dfdqd_upd_prev_vec_out_LY_dqdPE1,dfdqd_upd_prev_vec_out_LZ_dqdPE1;
   // dqdPE2
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE2;
   wire signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE2,dfdqd_upd_prev_vec_out_AY_dqdPE2,dfdqd_upd_prev_vec_out_AZ_dqdPE2,dfdqd_upd_prev_vec_out_LX_dqdPE2,dfdqd_upd_prev_vec_out_LY_dqdPE2,dfdqd_upd_prev_vec_out_LZ_dqdPE2;
   // dqdPE3
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE3;
   wire signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE3,dfdqd_upd_prev_vec_out_AY_dqdPE3,dfdqd_upd_prev_vec_out_AZ_dqdPE3,dfdqd_upd_prev_vec_out_LX_dqdPE3,dfdqd_upd_prev_vec_out_LY_dqdPE3,dfdqd_upd_prev_vec_out_LZ_dqdPE3;
   // dqdPE4
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE4;
   wire signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE4,dfdqd_upd_prev_vec_out_AY_dqdPE4,dfdqd_upd_prev_vec_out_AZ_dqdPE4,dfdqd_upd_prev_vec_out_LX_dqdPE4,dfdqd_upd_prev_vec_out_LY_dqdPE4,dfdqd_upd_prev_vec_out_LZ_dqdPE4;
   // dqdPE5
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE5;
   wire signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE5,dfdqd_upd_prev_vec_out_AY_dqdPE5,dfdqd_upd_prev_vec_out_AZ_dqdPE5,dfdqd_upd_prev_vec_out_LX_dqdPE5,dfdqd_upd_prev_vec_out_LY_dqdPE5,dfdqd_upd_prev_vec_out_LZ_dqdPE5;
   // dqdPE6
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE6;
   wire signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE6,dfdqd_upd_prev_vec_out_AY_dqdPE6,dfdqd_upd_prev_vec_out_AZ_dqdPE6,dfdqd_upd_prev_vec_out_LX_dqdPE6,dfdqd_upd_prev_vec_out_LY_dqdPE6,dfdqd_upd_prev_vec_out_LZ_dqdPE6;
   // dqdPE7
   wire signed[(WIDTH-1):0]
      dtau_curr_out_dqdPE7;
   wire signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_out_AX_dqdPE7,dfdqd_upd_prev_vec_out_AY_dqdPE7,dfdqd_upd_prev_vec_out_AZ_dqdPE7,dfdqd_upd_prev_vec_out_LX_dqdPE7,dfdqd_upd_prev_vec_out_LY_dqdPE7,dfdqd_upd_prev_vec_out_LZ_dqdPE7;
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
   // External f updated prev Storage
   //---------------------------------------------------------------------------
   // rnea
   reg signed[(WIDTH-1):0]
      f_upd_prev_vec_reg_AX_rnea,f_upd_prev_vec_reg_AY_rnea,f_upd_prev_vec_reg_AZ_rnea,f_upd_prev_vec_reg_LX_rnea,f_upd_prev_vec_reg_LY_rnea,f_upd_prev_vec_reg_LZ_rnea;
   //---------------------------------------------------------------------------
   // External df updated prev Storage
   //---------------------------------------------------------------------------
   // dqPE1
   reg signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_reg_AX_dqPE1,dfdq_upd_prev_vec_reg_AY_dqPE1,dfdq_upd_prev_vec_reg_AZ_dqPE1,dfdq_upd_prev_vec_reg_LX_dqPE1,dfdq_upd_prev_vec_reg_LY_dqPE1,dfdq_upd_prev_vec_reg_LZ_dqPE1;
   // dqPE2
   reg signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_reg_AX_dqPE2,dfdq_upd_prev_vec_reg_AY_dqPE2,dfdq_upd_prev_vec_reg_AZ_dqPE2,dfdq_upd_prev_vec_reg_LX_dqPE2,dfdq_upd_prev_vec_reg_LY_dqPE2,dfdq_upd_prev_vec_reg_LZ_dqPE2;
   // dqPE3
   reg signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_reg_AX_dqPE3,dfdq_upd_prev_vec_reg_AY_dqPE3,dfdq_upd_prev_vec_reg_AZ_dqPE3,dfdq_upd_prev_vec_reg_LX_dqPE3,dfdq_upd_prev_vec_reg_LY_dqPE3,dfdq_upd_prev_vec_reg_LZ_dqPE3;
   // dqPE4
   reg signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_reg_AX_dqPE4,dfdq_upd_prev_vec_reg_AY_dqPE4,dfdq_upd_prev_vec_reg_AZ_dqPE4,dfdq_upd_prev_vec_reg_LX_dqPE4,dfdq_upd_prev_vec_reg_LY_dqPE4,dfdq_upd_prev_vec_reg_LZ_dqPE4;
   // dqPE5
   reg signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_reg_AX_dqPE5,dfdq_upd_prev_vec_reg_AY_dqPE5,dfdq_upd_prev_vec_reg_AZ_dqPE5,dfdq_upd_prev_vec_reg_LX_dqPE5,dfdq_upd_prev_vec_reg_LY_dqPE5,dfdq_upd_prev_vec_reg_LZ_dqPE5;
   // dqPE6
   reg signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_reg_AX_dqPE6,dfdq_upd_prev_vec_reg_AY_dqPE6,dfdq_upd_prev_vec_reg_AZ_dqPE6,dfdq_upd_prev_vec_reg_LX_dqPE6,dfdq_upd_prev_vec_reg_LY_dqPE6,dfdq_upd_prev_vec_reg_LZ_dqPE6;
   // dqPE7
   reg signed[(WIDTH-1):0]
      dfdq_upd_prev_vec_reg_AX_dqPE7,dfdq_upd_prev_vec_reg_AY_dqPE7,dfdq_upd_prev_vec_reg_AZ_dqPE7,dfdq_upd_prev_vec_reg_LX_dqPE7,dfdq_upd_prev_vec_reg_LY_dqPE7,dfdq_upd_prev_vec_reg_LZ_dqPE7;
   //---------------------------------------------------------------------------
   // dqdPE1
   reg signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_reg_AX_dqdPE1,dfdqd_upd_prev_vec_reg_AY_dqdPE1,dfdqd_upd_prev_vec_reg_AZ_dqdPE1,dfdqd_upd_prev_vec_reg_LX_dqdPE1,dfdqd_upd_prev_vec_reg_LY_dqdPE1,dfdqd_upd_prev_vec_reg_LZ_dqdPE1;
   // dqdPE2
   reg signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_reg_AX_dqdPE2,dfdqd_upd_prev_vec_reg_AY_dqdPE2,dfdqd_upd_prev_vec_reg_AZ_dqdPE2,dfdqd_upd_prev_vec_reg_LX_dqdPE2,dfdqd_upd_prev_vec_reg_LY_dqdPE2,dfdqd_upd_prev_vec_reg_LZ_dqdPE2;
   // dqdPE3
   reg signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_reg_AX_dqdPE3,dfdqd_upd_prev_vec_reg_AY_dqdPE3,dfdqd_upd_prev_vec_reg_AZ_dqdPE3,dfdqd_upd_prev_vec_reg_LX_dqdPE3,dfdqd_upd_prev_vec_reg_LY_dqdPE3,dfdqd_upd_prev_vec_reg_LZ_dqdPE3;
   // dqdPE4
   reg signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_reg_AX_dqdPE4,dfdqd_upd_prev_vec_reg_AY_dqdPE4,dfdqd_upd_prev_vec_reg_AZ_dqdPE4,dfdqd_upd_prev_vec_reg_LX_dqdPE4,dfdqd_upd_prev_vec_reg_LY_dqdPE4,dfdqd_upd_prev_vec_reg_LZ_dqdPE4;
   // dqdPE5
   reg signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_reg_AX_dqdPE5,dfdqd_upd_prev_vec_reg_AY_dqdPE5,dfdqd_upd_prev_vec_reg_AZ_dqdPE5,dfdqd_upd_prev_vec_reg_LX_dqdPE5,dfdqd_upd_prev_vec_reg_LY_dqdPE5,dfdqd_upd_prev_vec_reg_LZ_dqdPE5;
   // dqdPE6
   reg signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_reg_AX_dqdPE6,dfdqd_upd_prev_vec_reg_AY_dqdPE6,dfdqd_upd_prev_vec_reg_AZ_dqdPE6,dfdqd_upd_prev_vec_reg_LX_dqdPE6,dfdqd_upd_prev_vec_reg_LY_dqdPE6,dfdqd_upd_prev_vec_reg_LZ_dqdPE6;
   // dqdPE7
   reg signed[(WIDTH-1):0]
      dfdqd_upd_prev_vec_reg_AX_dqdPE7,dfdqd_upd_prev_vec_reg_AY_dqdPE7,dfdqd_upd_prev_vec_reg_AZ_dqdPE7,dfdqd_upd_prev_vec_reg_LX_dqdPE7,dfdqd_upd_prev_vec_reg_LY_dqdPE7,dfdqd_upd_prev_vec_reg_LZ_dqdPE7;
   //---------------------------------------------------------------------------

   bproc#(.WIDTH(WIDTH),.DECIMAL_BITS(DECIMAL_BITS))
      uut(
      // clock
      .clk(clk),
      // reset
      .reset(reset),
      // get data
      .get_data(get_data),
      // minv_prev_vec_in
      .minv_prev_vec_in_C1(minv_prev_vec_in_C1),.minv_prev_vec_in_C2(minv_prev_vec_in_C2),.minv_prev_vec_in_C3(minv_prev_vec_in_C3),.minv_prev_vec_in_C4(minv_prev_vec_in_C4),.minv_prev_vec_in_C5(minv_prev_vec_in_C5),.minv_prev_vec_in_C6(minv_prev_vec_in_C6),.minv_prev_vec_in_C7(minv_prev_vec_in_C7),
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      .link_in_rnea(link_in_rnea),
      .sinq_val_in_rnea(sinq_val_in_rnea),.cosq_val_in_rnea(cosq_val_in_rnea),
      .f_upd_curr_vec_in_AX_rnea(f_upd_curr_vec_in_AX_rnea),.f_upd_curr_vec_in_AY_rnea(f_upd_curr_vec_in_AY_rnea),.f_upd_curr_vec_in_AZ_rnea(f_upd_curr_vec_in_AZ_rnea),.f_upd_curr_vec_in_LX_rnea(f_upd_curr_vec_in_LX_rnea),.f_upd_curr_vec_in_LY_rnea(f_upd_curr_vec_in_LY_rnea),.f_upd_curr_vec_in_LZ_rnea(f_upd_curr_vec_in_LZ_rnea),
      .f_prev_vec_in_AX_rnea(f_prev_vec_in_AX_rnea),.f_prev_vec_in_AY_rnea(f_prev_vec_in_AY_rnea),.f_prev_vec_in_AZ_rnea(f_prev_vec_in_AZ_rnea),.f_prev_vec_in_LX_rnea(f_prev_vec_in_LX_rnea),.f_prev_vec_in_LY_rnea(f_prev_vec_in_LY_rnea),.f_prev_vec_in_LZ_rnea(f_prev_vec_in_LZ_rnea),
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      .link_in_dqPE1(link_in_dqPE1),
      .derv_in_dqPE1(derv_in_dqPE1),
      .sinq_val_in_dqPE1(sinq_val_in_dqPE1),.cosq_val_in_dqPE1(cosq_val_in_dqPE1),
      .f_upd_curr_vec_in_AX_dqPE1(f_upd_curr_vec_in_AX_dqPE1),.f_upd_curr_vec_in_AY_dqPE1(f_upd_curr_vec_in_AY_dqPE1),.f_upd_curr_vec_in_AZ_dqPE1(f_upd_curr_vec_in_AZ_dqPE1),.f_upd_curr_vec_in_LX_dqPE1(f_upd_curr_vec_in_LX_dqPE1),.f_upd_curr_vec_in_LY_dqPE1(f_upd_curr_vec_in_LY_dqPE1),.f_upd_curr_vec_in_LZ_dqPE1(f_upd_curr_vec_in_LZ_dqPE1),
      .dfdq_prev_vec_in_AX_dqPE1(dfdq_prev_vec_in_AX_dqPE1),.dfdq_prev_vec_in_AY_dqPE1(dfdq_prev_vec_in_AY_dqPE1),.dfdq_prev_vec_in_AZ_dqPE1(dfdq_prev_vec_in_AZ_dqPE1),.dfdq_prev_vec_in_LX_dqPE1(dfdq_prev_vec_in_LX_dqPE1),.dfdq_prev_vec_in_LY_dqPE1(dfdq_prev_vec_in_LY_dqPE1),.dfdq_prev_vec_in_LZ_dqPE1(dfdq_prev_vec_in_LZ_dqPE1),
      .dfdq_upd_curr_vec_in_AX_dqPE1(dfdq_upd_curr_vec_in_AX_dqPE1),.dfdq_upd_curr_vec_in_AY_dqPE1(dfdq_upd_curr_vec_in_AY_dqPE1),.dfdq_upd_curr_vec_in_AZ_dqPE1(dfdq_upd_curr_vec_in_AZ_dqPE1),.dfdq_upd_curr_vec_in_LX_dqPE1(dfdq_upd_curr_vec_in_LX_dqPE1),.dfdq_upd_curr_vec_in_LY_dqPE1(dfdq_upd_curr_vec_in_LY_dqPE1),.dfdq_upd_curr_vec_in_LZ_dqPE1(dfdq_upd_curr_vec_in_LZ_dqPE1),
      // dqPE2
      .link_in_dqPE2(link_in_dqPE2),
      .derv_in_dqPE2(derv_in_dqPE2),
      .sinq_val_in_dqPE2(sinq_val_in_dqPE2),.cosq_val_in_dqPE2(cosq_val_in_dqPE2),
      .f_upd_curr_vec_in_AX_dqPE2(f_upd_curr_vec_in_AX_dqPE2),.f_upd_curr_vec_in_AY_dqPE2(f_upd_curr_vec_in_AY_dqPE2),.f_upd_curr_vec_in_AZ_dqPE2(f_upd_curr_vec_in_AZ_dqPE2),.f_upd_curr_vec_in_LX_dqPE2(f_upd_curr_vec_in_LX_dqPE2),.f_upd_curr_vec_in_LY_dqPE2(f_upd_curr_vec_in_LY_dqPE2),.f_upd_curr_vec_in_LZ_dqPE2(f_upd_curr_vec_in_LZ_dqPE2),
      .dfdq_prev_vec_in_AX_dqPE2(dfdq_prev_vec_in_AX_dqPE2),.dfdq_prev_vec_in_AY_dqPE2(dfdq_prev_vec_in_AY_dqPE2),.dfdq_prev_vec_in_AZ_dqPE2(dfdq_prev_vec_in_AZ_dqPE2),.dfdq_prev_vec_in_LX_dqPE2(dfdq_prev_vec_in_LX_dqPE2),.dfdq_prev_vec_in_LY_dqPE2(dfdq_prev_vec_in_LY_dqPE2),.dfdq_prev_vec_in_LZ_dqPE2(dfdq_prev_vec_in_LZ_dqPE2),
      .dfdq_upd_curr_vec_in_AX_dqPE2(dfdq_upd_curr_vec_in_AX_dqPE2),.dfdq_upd_curr_vec_in_AY_dqPE2(dfdq_upd_curr_vec_in_AY_dqPE2),.dfdq_upd_curr_vec_in_AZ_dqPE2(dfdq_upd_curr_vec_in_AZ_dqPE2),.dfdq_upd_curr_vec_in_LX_dqPE2(dfdq_upd_curr_vec_in_LX_dqPE2),.dfdq_upd_curr_vec_in_LY_dqPE2(dfdq_upd_curr_vec_in_LY_dqPE2),.dfdq_upd_curr_vec_in_LZ_dqPE2(dfdq_upd_curr_vec_in_LZ_dqPE2),
      // dqPE3
      .link_in_dqPE3(link_in_dqPE3),
      .derv_in_dqPE3(derv_in_dqPE3),
      .sinq_val_in_dqPE3(sinq_val_in_dqPE3),.cosq_val_in_dqPE3(cosq_val_in_dqPE3),
      .f_upd_curr_vec_in_AX_dqPE3(f_upd_curr_vec_in_AX_dqPE3),.f_upd_curr_vec_in_AY_dqPE3(f_upd_curr_vec_in_AY_dqPE3),.f_upd_curr_vec_in_AZ_dqPE3(f_upd_curr_vec_in_AZ_dqPE3),.f_upd_curr_vec_in_LX_dqPE3(f_upd_curr_vec_in_LX_dqPE3),.f_upd_curr_vec_in_LY_dqPE3(f_upd_curr_vec_in_LY_dqPE3),.f_upd_curr_vec_in_LZ_dqPE3(f_upd_curr_vec_in_LZ_dqPE3),
      .dfdq_prev_vec_in_AX_dqPE3(dfdq_prev_vec_in_AX_dqPE3),.dfdq_prev_vec_in_AY_dqPE3(dfdq_prev_vec_in_AY_dqPE3),.dfdq_prev_vec_in_AZ_dqPE3(dfdq_prev_vec_in_AZ_dqPE3),.dfdq_prev_vec_in_LX_dqPE3(dfdq_prev_vec_in_LX_dqPE3),.dfdq_prev_vec_in_LY_dqPE3(dfdq_prev_vec_in_LY_dqPE3),.dfdq_prev_vec_in_LZ_dqPE3(dfdq_prev_vec_in_LZ_dqPE3),
      .dfdq_upd_curr_vec_in_AX_dqPE3(dfdq_upd_curr_vec_in_AX_dqPE3),.dfdq_upd_curr_vec_in_AY_dqPE3(dfdq_upd_curr_vec_in_AY_dqPE3),.dfdq_upd_curr_vec_in_AZ_dqPE3(dfdq_upd_curr_vec_in_AZ_dqPE3),.dfdq_upd_curr_vec_in_LX_dqPE3(dfdq_upd_curr_vec_in_LX_dqPE3),.dfdq_upd_curr_vec_in_LY_dqPE3(dfdq_upd_curr_vec_in_LY_dqPE3),.dfdq_upd_curr_vec_in_LZ_dqPE3(dfdq_upd_curr_vec_in_LZ_dqPE3),
      // dqPE4
      .link_in_dqPE4(link_in_dqPE4),
      .derv_in_dqPE4(derv_in_dqPE4),
      .sinq_val_in_dqPE4(sinq_val_in_dqPE4),.cosq_val_in_dqPE4(cosq_val_in_dqPE4),
      .f_upd_curr_vec_in_AX_dqPE4(f_upd_curr_vec_in_AX_dqPE4),.f_upd_curr_vec_in_AY_dqPE4(f_upd_curr_vec_in_AY_dqPE4),.f_upd_curr_vec_in_AZ_dqPE4(f_upd_curr_vec_in_AZ_dqPE4),.f_upd_curr_vec_in_LX_dqPE4(f_upd_curr_vec_in_LX_dqPE4),.f_upd_curr_vec_in_LY_dqPE4(f_upd_curr_vec_in_LY_dqPE4),.f_upd_curr_vec_in_LZ_dqPE4(f_upd_curr_vec_in_LZ_dqPE4),
      .dfdq_prev_vec_in_AX_dqPE4(dfdq_prev_vec_in_AX_dqPE4),.dfdq_prev_vec_in_AY_dqPE4(dfdq_prev_vec_in_AY_dqPE4),.dfdq_prev_vec_in_AZ_dqPE4(dfdq_prev_vec_in_AZ_dqPE4),.dfdq_prev_vec_in_LX_dqPE4(dfdq_prev_vec_in_LX_dqPE4),.dfdq_prev_vec_in_LY_dqPE4(dfdq_prev_vec_in_LY_dqPE4),.dfdq_prev_vec_in_LZ_dqPE4(dfdq_prev_vec_in_LZ_dqPE4),
      .dfdq_upd_curr_vec_in_AX_dqPE4(dfdq_upd_curr_vec_in_AX_dqPE4),.dfdq_upd_curr_vec_in_AY_dqPE4(dfdq_upd_curr_vec_in_AY_dqPE4),.dfdq_upd_curr_vec_in_AZ_dqPE4(dfdq_upd_curr_vec_in_AZ_dqPE4),.dfdq_upd_curr_vec_in_LX_dqPE4(dfdq_upd_curr_vec_in_LX_dqPE4),.dfdq_upd_curr_vec_in_LY_dqPE4(dfdq_upd_curr_vec_in_LY_dqPE4),.dfdq_upd_curr_vec_in_LZ_dqPE4(dfdq_upd_curr_vec_in_LZ_dqPE4),
      // dqPE5
      .link_in_dqPE5(link_in_dqPE5),
      .derv_in_dqPE5(derv_in_dqPE5),
      .sinq_val_in_dqPE5(sinq_val_in_dqPE5),.cosq_val_in_dqPE5(cosq_val_in_dqPE5),
      .f_upd_curr_vec_in_AX_dqPE5(f_upd_curr_vec_in_AX_dqPE5),.f_upd_curr_vec_in_AY_dqPE5(f_upd_curr_vec_in_AY_dqPE5),.f_upd_curr_vec_in_AZ_dqPE5(f_upd_curr_vec_in_AZ_dqPE5),.f_upd_curr_vec_in_LX_dqPE5(f_upd_curr_vec_in_LX_dqPE5),.f_upd_curr_vec_in_LY_dqPE5(f_upd_curr_vec_in_LY_dqPE5),.f_upd_curr_vec_in_LZ_dqPE5(f_upd_curr_vec_in_LZ_dqPE5),
      .dfdq_prev_vec_in_AX_dqPE5(dfdq_prev_vec_in_AX_dqPE5),.dfdq_prev_vec_in_AY_dqPE5(dfdq_prev_vec_in_AY_dqPE5),.dfdq_prev_vec_in_AZ_dqPE5(dfdq_prev_vec_in_AZ_dqPE5),.dfdq_prev_vec_in_LX_dqPE5(dfdq_prev_vec_in_LX_dqPE5),.dfdq_prev_vec_in_LY_dqPE5(dfdq_prev_vec_in_LY_dqPE5),.dfdq_prev_vec_in_LZ_dqPE5(dfdq_prev_vec_in_LZ_dqPE5),
      .dfdq_upd_curr_vec_in_AX_dqPE5(dfdq_upd_curr_vec_in_AX_dqPE5),.dfdq_upd_curr_vec_in_AY_dqPE5(dfdq_upd_curr_vec_in_AY_dqPE5),.dfdq_upd_curr_vec_in_AZ_dqPE5(dfdq_upd_curr_vec_in_AZ_dqPE5),.dfdq_upd_curr_vec_in_LX_dqPE5(dfdq_upd_curr_vec_in_LX_dqPE5),.dfdq_upd_curr_vec_in_LY_dqPE5(dfdq_upd_curr_vec_in_LY_dqPE5),.dfdq_upd_curr_vec_in_LZ_dqPE5(dfdq_upd_curr_vec_in_LZ_dqPE5),
      // dqPE6
      .link_in_dqPE6(link_in_dqPE6),
      .derv_in_dqPE6(derv_in_dqPE6),
      .sinq_val_in_dqPE6(sinq_val_in_dqPE6),.cosq_val_in_dqPE6(cosq_val_in_dqPE6),
      .f_upd_curr_vec_in_AX_dqPE6(f_upd_curr_vec_in_AX_dqPE6),.f_upd_curr_vec_in_AY_dqPE6(f_upd_curr_vec_in_AY_dqPE6),.f_upd_curr_vec_in_AZ_dqPE6(f_upd_curr_vec_in_AZ_dqPE6),.f_upd_curr_vec_in_LX_dqPE6(f_upd_curr_vec_in_LX_dqPE6),.f_upd_curr_vec_in_LY_dqPE6(f_upd_curr_vec_in_LY_dqPE6),.f_upd_curr_vec_in_LZ_dqPE6(f_upd_curr_vec_in_LZ_dqPE6),
      .dfdq_prev_vec_in_AX_dqPE6(dfdq_prev_vec_in_AX_dqPE6),.dfdq_prev_vec_in_AY_dqPE6(dfdq_prev_vec_in_AY_dqPE6),.dfdq_prev_vec_in_AZ_dqPE6(dfdq_prev_vec_in_AZ_dqPE6),.dfdq_prev_vec_in_LX_dqPE6(dfdq_prev_vec_in_LX_dqPE6),.dfdq_prev_vec_in_LY_dqPE6(dfdq_prev_vec_in_LY_dqPE6),.dfdq_prev_vec_in_LZ_dqPE6(dfdq_prev_vec_in_LZ_dqPE6),
      .dfdq_upd_curr_vec_in_AX_dqPE6(dfdq_upd_curr_vec_in_AX_dqPE6),.dfdq_upd_curr_vec_in_AY_dqPE6(dfdq_upd_curr_vec_in_AY_dqPE6),.dfdq_upd_curr_vec_in_AZ_dqPE6(dfdq_upd_curr_vec_in_AZ_dqPE6),.dfdq_upd_curr_vec_in_LX_dqPE6(dfdq_upd_curr_vec_in_LX_dqPE6),.dfdq_upd_curr_vec_in_LY_dqPE6(dfdq_upd_curr_vec_in_LY_dqPE6),.dfdq_upd_curr_vec_in_LZ_dqPE6(dfdq_upd_curr_vec_in_LZ_dqPE6),
      // dqPE7
      .link_in_dqPE7(link_in_dqPE7),
      .derv_in_dqPE7(derv_in_dqPE7),
      .sinq_val_in_dqPE7(sinq_val_in_dqPE7),.cosq_val_in_dqPE7(cosq_val_in_dqPE7),
      .f_upd_curr_vec_in_AX_dqPE7(f_upd_curr_vec_in_AX_dqPE7),.f_upd_curr_vec_in_AY_dqPE7(f_upd_curr_vec_in_AY_dqPE7),.f_upd_curr_vec_in_AZ_dqPE7(f_upd_curr_vec_in_AZ_dqPE7),.f_upd_curr_vec_in_LX_dqPE7(f_upd_curr_vec_in_LX_dqPE7),.f_upd_curr_vec_in_LY_dqPE7(f_upd_curr_vec_in_LY_dqPE7),.f_upd_curr_vec_in_LZ_dqPE7(f_upd_curr_vec_in_LZ_dqPE7),
      .dfdq_prev_vec_in_AX_dqPE7(dfdq_prev_vec_in_AX_dqPE7),.dfdq_prev_vec_in_AY_dqPE7(dfdq_prev_vec_in_AY_dqPE7),.dfdq_prev_vec_in_AZ_dqPE7(dfdq_prev_vec_in_AZ_dqPE7),.dfdq_prev_vec_in_LX_dqPE7(dfdq_prev_vec_in_LX_dqPE7),.dfdq_prev_vec_in_LY_dqPE7(dfdq_prev_vec_in_LY_dqPE7),.dfdq_prev_vec_in_LZ_dqPE7(dfdq_prev_vec_in_LZ_dqPE7),
      .dfdq_upd_curr_vec_in_AX_dqPE7(dfdq_upd_curr_vec_in_AX_dqPE7),.dfdq_upd_curr_vec_in_AY_dqPE7(dfdq_upd_curr_vec_in_AY_dqPE7),.dfdq_upd_curr_vec_in_AZ_dqPE7(dfdq_upd_curr_vec_in_AZ_dqPE7),.dfdq_upd_curr_vec_in_LX_dqPE7(dfdq_upd_curr_vec_in_LX_dqPE7),.dfdq_upd_curr_vec_in_LY_dqPE7(dfdq_upd_curr_vec_in_LY_dqPE7),.dfdq_upd_curr_vec_in_LZ_dqPE7(dfdq_upd_curr_vec_in_LZ_dqPE7),
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      .link_in_dqdPE1(link_in_dqdPE1),
      .derv_in_dqdPE1(derv_in_dqdPE1),
      .sinq_val_in_dqdPE1(sinq_val_in_dqdPE1),.cosq_val_in_dqdPE1(cosq_val_in_dqdPE1),
      .dfdqd_prev_vec_in_AX_dqdPE1(dfdqd_prev_vec_in_AX_dqdPE1),.dfdqd_prev_vec_in_AY_dqdPE1(dfdqd_prev_vec_in_AY_dqdPE1),.dfdqd_prev_vec_in_AZ_dqdPE1(dfdqd_prev_vec_in_AZ_dqdPE1),.dfdqd_prev_vec_in_LX_dqdPE1(dfdqd_prev_vec_in_LX_dqdPE1),.dfdqd_prev_vec_in_LY_dqdPE1(dfdqd_prev_vec_in_LY_dqdPE1),.dfdqd_prev_vec_in_LZ_dqdPE1(dfdqd_prev_vec_in_LZ_dqdPE1),
      .dfdqd_upd_curr_vec_in_AX_dqdPE1(dfdqd_upd_curr_vec_in_AX_dqdPE1),.dfdqd_upd_curr_vec_in_AY_dqdPE1(dfdqd_upd_curr_vec_in_AY_dqdPE1),.dfdqd_upd_curr_vec_in_AZ_dqdPE1(dfdqd_upd_curr_vec_in_AZ_dqdPE1),.dfdqd_upd_curr_vec_in_LX_dqdPE1(dfdqd_upd_curr_vec_in_LX_dqdPE1),.dfdqd_upd_curr_vec_in_LY_dqdPE1(dfdqd_upd_curr_vec_in_LY_dqdPE1),.dfdqd_upd_curr_vec_in_LZ_dqdPE1(dfdqd_upd_curr_vec_in_LZ_dqdPE1),
      // dqdPE2
      .link_in_dqdPE2(link_in_dqdPE2),
      .derv_in_dqdPE2(derv_in_dqdPE2),
      .sinq_val_in_dqdPE2(sinq_val_in_dqdPE2),.cosq_val_in_dqdPE2(cosq_val_in_dqdPE2),
      .dfdqd_prev_vec_in_AX_dqdPE2(dfdqd_prev_vec_in_AX_dqdPE2),.dfdqd_prev_vec_in_AY_dqdPE2(dfdqd_prev_vec_in_AY_dqdPE2),.dfdqd_prev_vec_in_AZ_dqdPE2(dfdqd_prev_vec_in_AZ_dqdPE2),.dfdqd_prev_vec_in_LX_dqdPE2(dfdqd_prev_vec_in_LX_dqdPE2),.dfdqd_prev_vec_in_LY_dqdPE2(dfdqd_prev_vec_in_LY_dqdPE2),.dfdqd_prev_vec_in_LZ_dqdPE2(dfdqd_prev_vec_in_LZ_dqdPE2),
      .dfdqd_upd_curr_vec_in_AX_dqdPE2(dfdqd_upd_curr_vec_in_AX_dqdPE2),.dfdqd_upd_curr_vec_in_AY_dqdPE2(dfdqd_upd_curr_vec_in_AY_dqdPE2),.dfdqd_upd_curr_vec_in_AZ_dqdPE2(dfdqd_upd_curr_vec_in_AZ_dqdPE2),.dfdqd_upd_curr_vec_in_LX_dqdPE2(dfdqd_upd_curr_vec_in_LX_dqdPE2),.dfdqd_upd_curr_vec_in_LY_dqdPE2(dfdqd_upd_curr_vec_in_LY_dqdPE2),.dfdqd_upd_curr_vec_in_LZ_dqdPE2(dfdqd_upd_curr_vec_in_LZ_dqdPE2),
      // dqdPE3
      .link_in_dqdPE3(link_in_dqdPE3),
      .derv_in_dqdPE3(derv_in_dqdPE3),
      .sinq_val_in_dqdPE3(sinq_val_in_dqdPE3),.cosq_val_in_dqdPE3(cosq_val_in_dqdPE3),
      .dfdqd_prev_vec_in_AX_dqdPE3(dfdqd_prev_vec_in_AX_dqdPE3),.dfdqd_prev_vec_in_AY_dqdPE3(dfdqd_prev_vec_in_AY_dqdPE3),.dfdqd_prev_vec_in_AZ_dqdPE3(dfdqd_prev_vec_in_AZ_dqdPE3),.dfdqd_prev_vec_in_LX_dqdPE3(dfdqd_prev_vec_in_LX_dqdPE3),.dfdqd_prev_vec_in_LY_dqdPE3(dfdqd_prev_vec_in_LY_dqdPE3),.dfdqd_prev_vec_in_LZ_dqdPE3(dfdqd_prev_vec_in_LZ_dqdPE3),
      .dfdqd_upd_curr_vec_in_AX_dqdPE3(dfdqd_upd_curr_vec_in_AX_dqdPE3),.dfdqd_upd_curr_vec_in_AY_dqdPE3(dfdqd_upd_curr_vec_in_AY_dqdPE3),.dfdqd_upd_curr_vec_in_AZ_dqdPE3(dfdqd_upd_curr_vec_in_AZ_dqdPE3),.dfdqd_upd_curr_vec_in_LX_dqdPE3(dfdqd_upd_curr_vec_in_LX_dqdPE3),.dfdqd_upd_curr_vec_in_LY_dqdPE3(dfdqd_upd_curr_vec_in_LY_dqdPE3),.dfdqd_upd_curr_vec_in_LZ_dqdPE3(dfdqd_upd_curr_vec_in_LZ_dqdPE3),
      // dqdPE4
      .link_in_dqdPE4(link_in_dqdPE4),
      .derv_in_dqdPE4(derv_in_dqdPE4),
      .sinq_val_in_dqdPE4(sinq_val_in_dqdPE4),.cosq_val_in_dqdPE4(cosq_val_in_dqdPE4),
      .dfdqd_prev_vec_in_AX_dqdPE4(dfdqd_prev_vec_in_AX_dqdPE4),.dfdqd_prev_vec_in_AY_dqdPE4(dfdqd_prev_vec_in_AY_dqdPE4),.dfdqd_prev_vec_in_AZ_dqdPE4(dfdqd_prev_vec_in_AZ_dqdPE4),.dfdqd_prev_vec_in_LX_dqdPE4(dfdqd_prev_vec_in_LX_dqdPE4),.dfdqd_prev_vec_in_LY_dqdPE4(dfdqd_prev_vec_in_LY_dqdPE4),.dfdqd_prev_vec_in_LZ_dqdPE4(dfdqd_prev_vec_in_LZ_dqdPE4),
      .dfdqd_upd_curr_vec_in_AX_dqdPE4(dfdqd_upd_curr_vec_in_AX_dqdPE4),.dfdqd_upd_curr_vec_in_AY_dqdPE4(dfdqd_upd_curr_vec_in_AY_dqdPE4),.dfdqd_upd_curr_vec_in_AZ_dqdPE4(dfdqd_upd_curr_vec_in_AZ_dqdPE4),.dfdqd_upd_curr_vec_in_LX_dqdPE4(dfdqd_upd_curr_vec_in_LX_dqdPE4),.dfdqd_upd_curr_vec_in_LY_dqdPE4(dfdqd_upd_curr_vec_in_LY_dqdPE4),.dfdqd_upd_curr_vec_in_LZ_dqdPE4(dfdqd_upd_curr_vec_in_LZ_dqdPE4),
      // dqdPE5
      .link_in_dqdPE5(link_in_dqdPE5),
      .derv_in_dqdPE5(derv_in_dqdPE5),
      .sinq_val_in_dqdPE5(sinq_val_in_dqdPE5),.cosq_val_in_dqdPE5(cosq_val_in_dqdPE5),
      .dfdqd_prev_vec_in_AX_dqdPE5(dfdqd_prev_vec_in_AX_dqdPE5),.dfdqd_prev_vec_in_AY_dqdPE5(dfdqd_prev_vec_in_AY_dqdPE5),.dfdqd_prev_vec_in_AZ_dqdPE5(dfdqd_prev_vec_in_AZ_dqdPE5),.dfdqd_prev_vec_in_LX_dqdPE5(dfdqd_prev_vec_in_LX_dqdPE5),.dfdqd_prev_vec_in_LY_dqdPE5(dfdqd_prev_vec_in_LY_dqdPE5),.dfdqd_prev_vec_in_LZ_dqdPE5(dfdqd_prev_vec_in_LZ_dqdPE5),
      .dfdqd_upd_curr_vec_in_AX_dqdPE5(dfdqd_upd_curr_vec_in_AX_dqdPE5),.dfdqd_upd_curr_vec_in_AY_dqdPE5(dfdqd_upd_curr_vec_in_AY_dqdPE5),.dfdqd_upd_curr_vec_in_AZ_dqdPE5(dfdqd_upd_curr_vec_in_AZ_dqdPE5),.dfdqd_upd_curr_vec_in_LX_dqdPE5(dfdqd_upd_curr_vec_in_LX_dqdPE5),.dfdqd_upd_curr_vec_in_LY_dqdPE5(dfdqd_upd_curr_vec_in_LY_dqdPE5),.dfdqd_upd_curr_vec_in_LZ_dqdPE5(dfdqd_upd_curr_vec_in_LZ_dqdPE5),
      // dqdPE6
      .link_in_dqdPE6(link_in_dqdPE6),
      .derv_in_dqdPE6(derv_in_dqdPE6),
      .sinq_val_in_dqdPE6(sinq_val_in_dqdPE6),.cosq_val_in_dqdPE6(cosq_val_in_dqdPE6),
      .dfdqd_prev_vec_in_AX_dqdPE6(dfdqd_prev_vec_in_AX_dqdPE6),.dfdqd_prev_vec_in_AY_dqdPE6(dfdqd_prev_vec_in_AY_dqdPE6),.dfdqd_prev_vec_in_AZ_dqdPE6(dfdqd_prev_vec_in_AZ_dqdPE6),.dfdqd_prev_vec_in_LX_dqdPE6(dfdqd_prev_vec_in_LX_dqdPE6),.dfdqd_prev_vec_in_LY_dqdPE6(dfdqd_prev_vec_in_LY_dqdPE6),.dfdqd_prev_vec_in_LZ_dqdPE6(dfdqd_prev_vec_in_LZ_dqdPE6),
      .dfdqd_upd_curr_vec_in_AX_dqdPE6(dfdqd_upd_curr_vec_in_AX_dqdPE6),.dfdqd_upd_curr_vec_in_AY_dqdPE6(dfdqd_upd_curr_vec_in_AY_dqdPE6),.dfdqd_upd_curr_vec_in_AZ_dqdPE6(dfdqd_upd_curr_vec_in_AZ_dqdPE6),.dfdqd_upd_curr_vec_in_LX_dqdPE6(dfdqd_upd_curr_vec_in_LX_dqdPE6),.dfdqd_upd_curr_vec_in_LY_dqdPE6(dfdqd_upd_curr_vec_in_LY_dqdPE6),.dfdqd_upd_curr_vec_in_LZ_dqdPE6(dfdqd_upd_curr_vec_in_LZ_dqdPE6),
      // dqdPE7
      .link_in_dqdPE7(link_in_dqdPE7),
      .derv_in_dqdPE7(derv_in_dqdPE7),
      .sinq_val_in_dqdPE7(sinq_val_in_dqdPE7),.cosq_val_in_dqdPE7(cosq_val_in_dqdPE7),
      .dfdqd_prev_vec_in_AX_dqdPE7(dfdqd_prev_vec_in_AX_dqdPE7),.dfdqd_prev_vec_in_AY_dqdPE7(dfdqd_prev_vec_in_AY_dqdPE7),.dfdqd_prev_vec_in_AZ_dqdPE7(dfdqd_prev_vec_in_AZ_dqdPE7),.dfdqd_prev_vec_in_LX_dqdPE7(dfdqd_prev_vec_in_LX_dqdPE7),.dfdqd_prev_vec_in_LY_dqdPE7(dfdqd_prev_vec_in_LY_dqdPE7),.dfdqd_prev_vec_in_LZ_dqdPE7(dfdqd_prev_vec_in_LZ_dqdPE7),
      .dfdqd_upd_curr_vec_in_AX_dqdPE7(dfdqd_upd_curr_vec_in_AX_dqdPE7),.dfdqd_upd_curr_vec_in_AY_dqdPE7(dfdqd_upd_curr_vec_in_AY_dqdPE7),.dfdqd_upd_curr_vec_in_AZ_dqdPE7(dfdqd_upd_curr_vec_in_AZ_dqdPE7),.dfdqd_upd_curr_vec_in_LX_dqdPE7(dfdqd_upd_curr_vec_in_LX_dqdPE7),.dfdqd_upd_curr_vec_in_LY_dqdPE7(dfdqd_upd_curr_vec_in_LY_dqdPE7),.dfdqd_upd_curr_vec_in_LZ_dqdPE7(dfdqd_upd_curr_vec_in_LZ_dqdPE7),
      //------------------------------------------------------------------------
      // output ready
      .output_ready(output_ready),
      // dummy output
      .dummy_output(dummy_output),
//       // dtauidq_curr_vec_out
//       .dtauidq_curr_vec_out_J1(dtauidq_curr_vec_out_J1),.dtauidq_curr_vec_out_J2(dtauidq_curr_vec_out_J2),.dtauidq_curr_vec_out_J3(dtauidq_curr_vec_out_J3),.dtauidq_curr_vec_out_J4(dtauidq_curr_vec_out_J4),.dtauidq_curr_vec_out_J5(dtauidq_curr_vec_out_J5),.dtauidq_curr_vec_out_J6(dtauidq_curr_vec_out_J6),.dtauidq_curr_vec_out_J7(dtauidq_curr_vec_out_J7),
//       // dtauidqd_curr_vec_out
//       .dtauidqd_curr_vec_out_J1(dtauidqd_curr_vec_out_J1),.dtauidqd_curr_vec_out_J2(dtauidqd_curr_vec_out_J2),.dtauidqd_curr_vec_out_J3(dtauidqd_curr_vec_out_J3),.dtauidqd_curr_vec_out_J4(dtauidqd_curr_vec_out_J4),.dtauidqd_curr_vec_out_J5(dtauidqd_curr_vec_out_J5),.dtauidqd_curr_vec_out_J6(dtauidqd_curr_vec_out_J6),.dtauidqd_curr_vec_out_J7(dtauidqd_curr_vec_out_J7),
      // minv_dtaudq_out
      .minv_dtaudq_out_R1_C1(minv_dtaudq_out_R1_C1),.minv_dtaudq_out_R1_C2(minv_dtaudq_out_R1_C2),.minv_dtaudq_out_R1_C3(minv_dtaudq_out_R1_C3),.minv_dtaudq_out_R1_C4(minv_dtaudq_out_R1_C4),.minv_dtaudq_out_R1_C5(minv_dtaudq_out_R1_C5),.minv_dtaudq_out_R1_C6(minv_dtaudq_out_R1_C6),.minv_dtaudq_out_R1_C7(minv_dtaudq_out_R1_C7),
      .minv_dtaudq_out_R2_C1(minv_dtaudq_out_R2_C1),.minv_dtaudq_out_R2_C2(minv_dtaudq_out_R2_C2),.minv_dtaudq_out_R2_C3(minv_dtaudq_out_R2_C3),.minv_dtaudq_out_R2_C4(minv_dtaudq_out_R2_C4),.minv_dtaudq_out_R2_C5(minv_dtaudq_out_R2_C5),.minv_dtaudq_out_R2_C6(minv_dtaudq_out_R2_C6),.minv_dtaudq_out_R2_C7(minv_dtaudq_out_R2_C7),
      .minv_dtaudq_out_R3_C1(minv_dtaudq_out_R3_C1),.minv_dtaudq_out_R3_C2(minv_dtaudq_out_R3_C2),.minv_dtaudq_out_R3_C3(minv_dtaudq_out_R3_C3),.minv_dtaudq_out_R3_C4(minv_dtaudq_out_R3_C4),.minv_dtaudq_out_R3_C5(minv_dtaudq_out_R3_C5),.minv_dtaudq_out_R3_C6(minv_dtaudq_out_R3_C6),.minv_dtaudq_out_R3_C7(minv_dtaudq_out_R3_C7),
      .minv_dtaudq_out_R4_C1(minv_dtaudq_out_R4_C1),.minv_dtaudq_out_R4_C2(minv_dtaudq_out_R4_C2),.minv_dtaudq_out_R4_C3(minv_dtaudq_out_R4_C3),.minv_dtaudq_out_R4_C4(minv_dtaudq_out_R4_C4),.minv_dtaudq_out_R4_C5(minv_dtaudq_out_R4_C5),.minv_dtaudq_out_R4_C6(minv_dtaudq_out_R4_C6),.minv_dtaudq_out_R4_C7(minv_dtaudq_out_R4_C7),
      .minv_dtaudq_out_R5_C1(minv_dtaudq_out_R5_C1),.minv_dtaudq_out_R5_C2(minv_dtaudq_out_R5_C2),.minv_dtaudq_out_R5_C3(minv_dtaudq_out_R5_C3),.minv_dtaudq_out_R5_C4(minv_dtaudq_out_R5_C4),.minv_dtaudq_out_R5_C5(minv_dtaudq_out_R5_C5),.minv_dtaudq_out_R5_C6(minv_dtaudq_out_R5_C6),.minv_dtaudq_out_R5_C7(minv_dtaudq_out_R5_C7),
      .minv_dtaudq_out_R6_C1(minv_dtaudq_out_R6_C1),.minv_dtaudq_out_R6_C2(minv_dtaudq_out_R6_C2),.minv_dtaudq_out_R6_C3(minv_dtaudq_out_R6_C3),.minv_dtaudq_out_R6_C4(minv_dtaudq_out_R6_C4),.minv_dtaudq_out_R6_C5(minv_dtaudq_out_R6_C5),.minv_dtaudq_out_R6_C6(minv_dtaudq_out_R6_C6),.minv_dtaudq_out_R6_C7(minv_dtaudq_out_R6_C7),
      .minv_dtaudq_out_R7_C1(minv_dtaudq_out_R7_C1),.minv_dtaudq_out_R7_C2(minv_dtaudq_out_R7_C2),.minv_dtaudq_out_R7_C3(minv_dtaudq_out_R7_C3),.minv_dtaudq_out_R7_C4(minv_dtaudq_out_R7_C4),.minv_dtaudq_out_R7_C5(minv_dtaudq_out_R7_C5),.minv_dtaudq_out_R7_C6(minv_dtaudq_out_R7_C6),.minv_dtaudq_out_R7_C7(minv_dtaudq_out_R7_C7),
      // minv_dtaudqd_out
      .minv_dtaudqd_out_R1_C1(minv_dtaudqd_out_R1_C1),.minv_dtaudqd_out_R1_C2(minv_dtaudqd_out_R1_C2),.minv_dtaudqd_out_R1_C3(minv_dtaudqd_out_R1_C3),.minv_dtaudqd_out_R1_C4(minv_dtaudqd_out_R1_C4),.minv_dtaudqd_out_R1_C5(minv_dtaudqd_out_R1_C5),.minv_dtaudqd_out_R1_C6(minv_dtaudqd_out_R1_C6),.minv_dtaudqd_out_R1_C7(minv_dtaudqd_out_R1_C7),
      .minv_dtaudqd_out_R2_C1(minv_dtaudqd_out_R2_C1),.minv_dtaudqd_out_R2_C2(minv_dtaudqd_out_R2_C2),.minv_dtaudqd_out_R2_C3(minv_dtaudqd_out_R2_C3),.minv_dtaudqd_out_R2_C4(minv_dtaudqd_out_R2_C4),.minv_dtaudqd_out_R2_C5(minv_dtaudqd_out_R2_C5),.minv_dtaudqd_out_R2_C6(minv_dtaudqd_out_R2_C6),.minv_dtaudqd_out_R2_C7(minv_dtaudqd_out_R2_C7),
      .minv_dtaudqd_out_R3_C1(minv_dtaudqd_out_R3_C1),.minv_dtaudqd_out_R3_C2(minv_dtaudqd_out_R3_C2),.minv_dtaudqd_out_R3_C3(minv_dtaudqd_out_R3_C3),.minv_dtaudqd_out_R3_C4(minv_dtaudqd_out_R3_C4),.minv_dtaudqd_out_R3_C5(minv_dtaudqd_out_R3_C5),.minv_dtaudqd_out_R3_C6(minv_dtaudqd_out_R3_C6),.minv_dtaudqd_out_R3_C7(minv_dtaudqd_out_R3_C7),
      .minv_dtaudqd_out_R4_C1(minv_dtaudqd_out_R4_C1),.minv_dtaudqd_out_R4_C2(minv_dtaudqd_out_R4_C2),.minv_dtaudqd_out_R4_C3(minv_dtaudqd_out_R4_C3),.minv_dtaudqd_out_R4_C4(minv_dtaudqd_out_R4_C4),.minv_dtaudqd_out_R4_C5(minv_dtaudqd_out_R4_C5),.minv_dtaudqd_out_R4_C6(minv_dtaudqd_out_R4_C6),.minv_dtaudqd_out_R4_C7(minv_dtaudqd_out_R4_C7),
      .minv_dtaudqd_out_R5_C1(minv_dtaudqd_out_R5_C1),.minv_dtaudqd_out_R5_C2(minv_dtaudqd_out_R5_C2),.minv_dtaudqd_out_R5_C3(minv_dtaudqd_out_R5_C3),.minv_dtaudqd_out_R5_C4(minv_dtaudqd_out_R5_C4),.minv_dtaudqd_out_R5_C5(minv_dtaudqd_out_R5_C5),.minv_dtaudqd_out_R5_C6(minv_dtaudqd_out_R5_C6),.minv_dtaudqd_out_R5_C7(minv_dtaudqd_out_R5_C7),
      .minv_dtaudqd_out_R6_C1(minv_dtaudqd_out_R6_C1),.minv_dtaudqd_out_R6_C2(minv_dtaudqd_out_R6_C2),.minv_dtaudqd_out_R6_C3(minv_dtaudqd_out_R6_C3),.minv_dtaudqd_out_R6_C4(minv_dtaudqd_out_R6_C4),.minv_dtaudqd_out_R6_C5(minv_dtaudqd_out_R6_C5),.minv_dtaudqd_out_R6_C6(minv_dtaudqd_out_R6_C6),.minv_dtaudqd_out_R6_C7(minv_dtaudqd_out_R6_C7),
      .minv_dtaudqd_out_R7_C1(minv_dtaudqd_out_R7_C1),.minv_dtaudqd_out_R7_C2(minv_dtaudqd_out_R7_C2),.minv_dtaudqd_out_R7_C3(minv_dtaudqd_out_R7_C3),.minv_dtaudqd_out_R7_C4(minv_dtaudqd_out_R7_C4),.minv_dtaudqd_out_R7_C5(minv_dtaudqd_out_R7_C5),.minv_dtaudqd_out_R7_C6(minv_dtaudqd_out_R7_C6),.minv_dtaudqd_out_R7_C7(minv_dtaudqd_out_R7_C7),
      //------------------------------------------------------------------------
      // rnea external outputs
      //------------------------------------------------------------------------
      // rnea
      .tau_curr_out_rnea(tau_curr_out_rnea),
      .f_upd_prev_vec_out_AX_rnea(f_upd_prev_vec_out_AX_rnea),.f_upd_prev_vec_out_AY_rnea(f_upd_prev_vec_out_AY_rnea),.f_upd_prev_vec_out_AZ_rnea(f_upd_prev_vec_out_AZ_rnea),.f_upd_prev_vec_out_LX_rnea(f_upd_prev_vec_out_LX_rnea),.f_upd_prev_vec_out_LY_rnea(f_upd_prev_vec_out_LY_rnea),.f_upd_prev_vec_out_LZ_rnea(f_upd_prev_vec_out_LZ_rnea),
      //------------------------------------------------------------------------
      // dq external outputs
      //------------------------------------------------------------------------
      // dqPE1
      .dtau_curr_out_dqPE1(dtau_curr_out_dqPE1),
      .dfdq_upd_prev_vec_out_AX_dqPE1(dfdq_upd_prev_vec_out_AX_dqPE1),.dfdq_upd_prev_vec_out_AY_dqPE1(dfdq_upd_prev_vec_out_AY_dqPE1),.dfdq_upd_prev_vec_out_AZ_dqPE1(dfdq_upd_prev_vec_out_AZ_dqPE1),.dfdq_upd_prev_vec_out_LX_dqPE1(dfdq_upd_prev_vec_out_LX_dqPE1),.dfdq_upd_prev_vec_out_LY_dqPE1(dfdq_upd_prev_vec_out_LY_dqPE1),.dfdq_upd_prev_vec_out_LZ_dqPE1(dfdq_upd_prev_vec_out_LZ_dqPE1),
      // dqPE2
      .dtau_curr_out_dqPE2(dtau_curr_out_dqPE2),
      .dfdq_upd_prev_vec_out_AX_dqPE2(dfdq_upd_prev_vec_out_AX_dqPE2),.dfdq_upd_prev_vec_out_AY_dqPE2(dfdq_upd_prev_vec_out_AY_dqPE2),.dfdq_upd_prev_vec_out_AZ_dqPE2(dfdq_upd_prev_vec_out_AZ_dqPE2),.dfdq_upd_prev_vec_out_LX_dqPE2(dfdq_upd_prev_vec_out_LX_dqPE2),.dfdq_upd_prev_vec_out_LY_dqPE2(dfdq_upd_prev_vec_out_LY_dqPE2),.dfdq_upd_prev_vec_out_LZ_dqPE2(dfdq_upd_prev_vec_out_LZ_dqPE2),
      // dqPE3
      .dtau_curr_out_dqPE3(dtau_curr_out_dqPE3),
      .dfdq_upd_prev_vec_out_AX_dqPE3(dfdq_upd_prev_vec_out_AX_dqPE3),.dfdq_upd_prev_vec_out_AY_dqPE3(dfdq_upd_prev_vec_out_AY_dqPE3),.dfdq_upd_prev_vec_out_AZ_dqPE3(dfdq_upd_prev_vec_out_AZ_dqPE3),.dfdq_upd_prev_vec_out_LX_dqPE3(dfdq_upd_prev_vec_out_LX_dqPE3),.dfdq_upd_prev_vec_out_LY_dqPE3(dfdq_upd_prev_vec_out_LY_dqPE3),.dfdq_upd_prev_vec_out_LZ_dqPE3(dfdq_upd_prev_vec_out_LZ_dqPE3),
      // dqPE1
      .dtau_curr_out_dqPE4(dtau_curr_out_dqPE4),
      .dfdq_upd_prev_vec_out_AX_dqPE4(dfdq_upd_prev_vec_out_AX_dqPE4),.dfdq_upd_prev_vec_out_AY_dqPE4(dfdq_upd_prev_vec_out_AY_dqPE4),.dfdq_upd_prev_vec_out_AZ_dqPE4(dfdq_upd_prev_vec_out_AZ_dqPE4),.dfdq_upd_prev_vec_out_LX_dqPE4(dfdq_upd_prev_vec_out_LX_dqPE4),.dfdq_upd_prev_vec_out_LY_dqPE4(dfdq_upd_prev_vec_out_LY_dqPE4),.dfdq_upd_prev_vec_out_LZ_dqPE4(dfdq_upd_prev_vec_out_LZ_dqPE4),
      // dqPE5
      .dtau_curr_out_dqPE5(dtau_curr_out_dqPE5),
      .dfdq_upd_prev_vec_out_AX_dqPE5(dfdq_upd_prev_vec_out_AX_dqPE5),.dfdq_upd_prev_vec_out_AY_dqPE5(dfdq_upd_prev_vec_out_AY_dqPE5),.dfdq_upd_prev_vec_out_AZ_dqPE5(dfdq_upd_prev_vec_out_AZ_dqPE5),.dfdq_upd_prev_vec_out_LX_dqPE5(dfdq_upd_prev_vec_out_LX_dqPE5),.dfdq_upd_prev_vec_out_LY_dqPE5(dfdq_upd_prev_vec_out_LY_dqPE5),.dfdq_upd_prev_vec_out_LZ_dqPE5(dfdq_upd_prev_vec_out_LZ_dqPE5),
      // dqPE6
      .dtau_curr_out_dqPE6(dtau_curr_out_dqPE6),
      .dfdq_upd_prev_vec_out_AX_dqPE6(dfdq_upd_prev_vec_out_AX_dqPE6),.dfdq_upd_prev_vec_out_AY_dqPE6(dfdq_upd_prev_vec_out_AY_dqPE6),.dfdq_upd_prev_vec_out_AZ_dqPE6(dfdq_upd_prev_vec_out_AZ_dqPE6),.dfdq_upd_prev_vec_out_LX_dqPE6(dfdq_upd_prev_vec_out_LX_dqPE6),.dfdq_upd_prev_vec_out_LY_dqPE6(dfdq_upd_prev_vec_out_LY_dqPE6),.dfdq_upd_prev_vec_out_LZ_dqPE6(dfdq_upd_prev_vec_out_LZ_dqPE6),
      // dqPE7
      .dtau_curr_out_dqPE7(dtau_curr_out_dqPE7),
      .dfdq_upd_prev_vec_out_AX_dqPE7(dfdq_upd_prev_vec_out_AX_dqPE7),.dfdq_upd_prev_vec_out_AY_dqPE7(dfdq_upd_prev_vec_out_AY_dqPE7),.dfdq_upd_prev_vec_out_AZ_dqPE7(dfdq_upd_prev_vec_out_AZ_dqPE7),.dfdq_upd_prev_vec_out_LX_dqPE7(dfdq_upd_prev_vec_out_LX_dqPE7),.dfdq_upd_prev_vec_out_LY_dqPE7(dfdq_upd_prev_vec_out_LY_dqPE7),.dfdq_upd_prev_vec_out_LZ_dqPE7(dfdq_upd_prev_vec_out_LZ_dqPE7),
      //------------------------------------------------------------------------
      // dqd external outputs
      //------------------------------------------------------------------------
      // dqdPE1
      .dtau_curr_out_dqdPE1(dtau_curr_out_dqdPE1),
      .dfdqd_upd_prev_vec_out_AX_dqdPE1(dfdqd_upd_prev_vec_out_AX_dqdPE1),.dfdqd_upd_prev_vec_out_AY_dqdPE1(dfdqd_upd_prev_vec_out_AY_dqdPE1),.dfdqd_upd_prev_vec_out_AZ_dqdPE1(dfdqd_upd_prev_vec_out_AZ_dqdPE1),.dfdqd_upd_prev_vec_out_LX_dqdPE1(dfdqd_upd_prev_vec_out_LX_dqdPE1),.dfdqd_upd_prev_vec_out_LY_dqdPE1(dfdqd_upd_prev_vec_out_LY_dqdPE1),.dfdqd_upd_prev_vec_out_LZ_dqdPE1(dfdqd_upd_prev_vec_out_LZ_dqdPE1),
      // dqdPE2
      .dtau_curr_out_dqdPE2(dtau_curr_out_dqdPE2),
      .dfdqd_upd_prev_vec_out_AX_dqdPE2(dfdqd_upd_prev_vec_out_AX_dqdPE2),.dfdqd_upd_prev_vec_out_AY_dqdPE2(dfdqd_upd_prev_vec_out_AY_dqdPE2),.dfdqd_upd_prev_vec_out_AZ_dqdPE2(dfdqd_upd_prev_vec_out_AZ_dqdPE2),.dfdqd_upd_prev_vec_out_LX_dqdPE2(dfdqd_upd_prev_vec_out_LX_dqdPE2),.dfdqd_upd_prev_vec_out_LY_dqdPE2(dfdqd_upd_prev_vec_out_LY_dqdPE2),.dfdqd_upd_prev_vec_out_LZ_dqdPE2(dfdqd_upd_prev_vec_out_LZ_dqdPE2),
      // dqdPE3
      .dtau_curr_out_dqdPE3(dtau_curr_out_dqdPE3),
      .dfdqd_upd_prev_vec_out_AX_dqdPE3(dfdqd_upd_prev_vec_out_AX_dqdPE3),.dfdqd_upd_prev_vec_out_AY_dqdPE3(dfdqd_upd_prev_vec_out_AY_dqdPE3),.dfdqd_upd_prev_vec_out_AZ_dqdPE3(dfdqd_upd_prev_vec_out_AZ_dqdPE3),.dfdqd_upd_prev_vec_out_LX_dqdPE3(dfdqd_upd_prev_vec_out_LX_dqdPE3),.dfdqd_upd_prev_vec_out_LY_dqdPE3(dfdqd_upd_prev_vec_out_LY_dqdPE3),.dfdqd_upd_prev_vec_out_LZ_dqdPE3(dfdqd_upd_prev_vec_out_LZ_dqdPE3),
      // dqdPE4
      .dtau_curr_out_dqdPE4(dtau_curr_out_dqdPE4),
      .dfdqd_upd_prev_vec_out_AX_dqdPE4(dfdqd_upd_prev_vec_out_AX_dqdPE4),.dfdqd_upd_prev_vec_out_AY_dqdPE4(dfdqd_upd_prev_vec_out_AY_dqdPE4),.dfdqd_upd_prev_vec_out_AZ_dqdPE4(dfdqd_upd_prev_vec_out_AZ_dqdPE4),.dfdqd_upd_prev_vec_out_LX_dqdPE4(dfdqd_upd_prev_vec_out_LX_dqdPE4),.dfdqd_upd_prev_vec_out_LY_dqdPE4(dfdqd_upd_prev_vec_out_LY_dqdPE4),.dfdqd_upd_prev_vec_out_LZ_dqdPE4(dfdqd_upd_prev_vec_out_LZ_dqdPE4),
      // dqdPE5
      .dtau_curr_out_dqdPE5(dtau_curr_out_dqdPE5),
      .dfdqd_upd_prev_vec_out_AX_dqdPE5(dfdqd_upd_prev_vec_out_AX_dqdPE5),.dfdqd_upd_prev_vec_out_AY_dqdPE5(dfdqd_upd_prev_vec_out_AY_dqdPE5),.dfdqd_upd_prev_vec_out_AZ_dqdPE5(dfdqd_upd_prev_vec_out_AZ_dqdPE5),.dfdqd_upd_prev_vec_out_LX_dqdPE5(dfdqd_upd_prev_vec_out_LX_dqdPE5),.dfdqd_upd_prev_vec_out_LY_dqdPE5(dfdqd_upd_prev_vec_out_LY_dqdPE5),.dfdqd_upd_prev_vec_out_LZ_dqdPE5(dfdqd_upd_prev_vec_out_LZ_dqdPE5),
      // dqdPE6
      .dtau_curr_out_dqdPE6(dtau_curr_out_dqdPE6),
      .dfdqd_upd_prev_vec_out_AX_dqdPE6(dfdqd_upd_prev_vec_out_AX_dqdPE6),.dfdqd_upd_prev_vec_out_AY_dqdPE6(dfdqd_upd_prev_vec_out_AY_dqdPE6),.dfdqd_upd_prev_vec_out_AZ_dqdPE6(dfdqd_upd_prev_vec_out_AZ_dqdPE6),.dfdqd_upd_prev_vec_out_LX_dqdPE6(dfdqd_upd_prev_vec_out_LX_dqdPE6),.dfdqd_upd_prev_vec_out_LY_dqdPE6(dfdqd_upd_prev_vec_out_LY_dqdPE6),.dfdqd_upd_prev_vec_out_LZ_dqdPE6(dfdqd_upd_prev_vec_out_LZ_dqdPE6),
      // dqdPE7
      .dtau_curr_out_dqdPE7(dtau_curr_out_dqdPE7),
      .dfdqd_upd_prev_vec_out_AX_dqdPE7(dfdqd_upd_prev_vec_out_AX_dqdPE7),.dfdqd_upd_prev_vec_out_AY_dqdPE7(dfdqd_upd_prev_vec_out_AY_dqdPE7),.dfdqd_upd_prev_vec_out_AZ_dqdPE7(dfdqd_upd_prev_vec_out_AZ_dqdPE7),.dfdqd_upd_prev_vec_out_LX_dqdPE7(dfdqd_upd_prev_vec_out_LX_dqdPE7),.dfdqd_upd_prev_vec_out_LY_dqdPE7(dfdqd_upd_prev_vec_out_LY_dqdPE7),.dfdqd_upd_prev_vec_out_LZ_dqdPE7(dfdqd_upd_prev_vec_out_LZ_dqdPE7)
      //------------------------------------------------------------------------
      );

   initial begin
      #10;
      // initialize
      clk = 0;
      // inputs
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0;
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 0;
      sinq_val_in_rnea = 0; cosq_val_in_rnea = 0;
      f_prev_vec_in_AX_rnea = 0; f_prev_vec_in_AY_rnea = 0; f_prev_vec_in_AZ_rnea = 0; f_prev_vec_in_LX_rnea = 0; f_prev_vec_in_LY_rnea = 0; f_prev_vec_in_LZ_rnea = 0;
      f_upd_curr_vec_in_AX_rnea = 0; f_upd_curr_vec_in_AY_rnea = 0; f_upd_curr_vec_in_AZ_rnea = 0; f_upd_curr_vec_in_LX_rnea = 0; f_upd_curr_vec_in_LY_rnea = 0; f_upd_curr_vec_in_LZ_rnea = 0;
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 0;
      derv_in_dqPE1 = 4'd1;
      sinq_val_in_dqPE1 = 0; cosq_val_in_dqPE1 = 0;
      f_upd_curr_vec_in_AX_dqPE1 = 0; f_upd_curr_vec_in_AY_dqPE1 = 0; f_upd_curr_vec_in_AZ_dqPE1 = 0; f_upd_curr_vec_in_LX_dqPE1 = 0; f_upd_curr_vec_in_LY_dqPE1 = 0; f_upd_curr_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      link_in_dqPE2 = 0;
      derv_in_dqPE2 = 4'd2;
      sinq_val_in_dqPE2 = 0; cosq_val_in_dqPE2 = 0;
      f_upd_curr_vec_in_AX_dqPE2 = 0; f_upd_curr_vec_in_AY_dqPE2 = 0; f_upd_curr_vec_in_AZ_dqPE2 = 0; f_upd_curr_vec_in_LX_dqPE2 = 0; f_upd_curr_vec_in_LY_dqPE2 = 0; f_upd_curr_vec_in_LZ_dqPE2 = 0;
      // dqPE3
      link_in_dqPE3 = 0;
      derv_in_dqPE3 = 4'd3;
      sinq_val_in_dqPE3 = 0; cosq_val_in_dqPE3 = 0;
      f_upd_curr_vec_in_AX_dqPE3 = 0; f_upd_curr_vec_in_AY_dqPE3 = 0; f_upd_curr_vec_in_AZ_dqPE3 = 0; f_upd_curr_vec_in_LX_dqPE3 = 0; f_upd_curr_vec_in_LY_dqPE3 = 0; f_upd_curr_vec_in_LZ_dqPE3 = 0;
      // dqPE4
      link_in_dqPE4 = 0;
      derv_in_dqPE4 = 4'd4;
      sinq_val_in_dqPE4 = 0; cosq_val_in_dqPE4 = 0;
      f_upd_curr_vec_in_AX_dqPE4 = 0; f_upd_curr_vec_in_AY_dqPE4 = 0; f_upd_curr_vec_in_AZ_dqPE4 = 0; f_upd_curr_vec_in_LX_dqPE4 = 0; f_upd_curr_vec_in_LY_dqPE4 = 0; f_upd_curr_vec_in_LZ_dqPE4 = 0;
      // dqPE5
      link_in_dqPE5 = 0;
      derv_in_dqPE5 = 4'd5;
      sinq_val_in_dqPE5 = 0; cosq_val_in_dqPE5 = 0;
      f_upd_curr_vec_in_AX_dqPE5 = 0; f_upd_curr_vec_in_AY_dqPE5 = 0; f_upd_curr_vec_in_AZ_dqPE5 = 0; f_upd_curr_vec_in_LX_dqPE5 = 0; f_upd_curr_vec_in_LY_dqPE5 = 0; f_upd_curr_vec_in_LZ_dqPE5 = 0;
      // dqPE6
      link_in_dqPE6 = 0;
      derv_in_dqPE6 = 4'd6;
      sinq_val_in_dqPE6 = 0; cosq_val_in_dqPE6 = 0;
      f_upd_curr_vec_in_AX_dqPE6 = 0; f_upd_curr_vec_in_AY_dqPE6 = 0; f_upd_curr_vec_in_AZ_dqPE6 = 0; f_upd_curr_vec_in_LX_dqPE6 = 0; f_upd_curr_vec_in_LY_dqPE6 = 0; f_upd_curr_vec_in_LZ_dqPE6 = 0;
      // dqPE7
      link_in_dqPE7 = 0;
      derv_in_dqPE7 = 4'd7;
      sinq_val_in_dqPE7 = 0; cosq_val_in_dqPE7 = 0;
      f_upd_curr_vec_in_AX_dqPE7 = 0; f_upd_curr_vec_in_AY_dqPE7 = 0; f_upd_curr_vec_in_AZ_dqPE7 = 0; f_upd_curr_vec_in_LX_dqPE7 = 0; f_upd_curr_vec_in_LY_dqPE7 = 0; f_upd_curr_vec_in_LZ_dqPE7 = 0;
      // External df updated
      // dqPE1
      dfdq_upd_curr_vec_in_AX_dqPE1 = 0; dfdq_upd_curr_vec_in_AY_dqPE1 = 0; dfdq_upd_curr_vec_in_AZ_dqPE1 = 0; dfdq_upd_curr_vec_in_LX_dqPE1 = 0; dfdq_upd_curr_vec_in_LY_dqPE1 = 0; dfdq_upd_curr_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      dfdq_upd_curr_vec_in_AX_dqPE2 = 0; dfdq_upd_curr_vec_in_AY_dqPE2 = 0; dfdq_upd_curr_vec_in_AZ_dqPE2 = 0; dfdq_upd_curr_vec_in_LX_dqPE2 = 0; dfdq_upd_curr_vec_in_LY_dqPE2 = 0; dfdq_upd_curr_vec_in_LZ_dqPE2 = 0;
      // dqPE3
      dfdq_upd_curr_vec_in_AX_dqPE3 = 0; dfdq_upd_curr_vec_in_AY_dqPE3 = 0; dfdq_upd_curr_vec_in_AZ_dqPE3 = 0; dfdq_upd_curr_vec_in_LX_dqPE3 = 0; dfdq_upd_curr_vec_in_LY_dqPE3 = 0; dfdq_upd_curr_vec_in_LZ_dqPE3 = 0;
      // dqPE4
      dfdq_upd_curr_vec_in_AX_dqPE4 = 0; dfdq_upd_curr_vec_in_AY_dqPE4 = 0; dfdq_upd_curr_vec_in_AZ_dqPE4 = 0; dfdq_upd_curr_vec_in_LX_dqPE4 = 0; dfdq_upd_curr_vec_in_LY_dqPE4 = 0; dfdq_upd_curr_vec_in_LZ_dqPE4 = 0;
      // dqPE5
      dfdq_upd_curr_vec_in_AX_dqPE5 = 0; dfdq_upd_curr_vec_in_AY_dqPE5 = 0; dfdq_upd_curr_vec_in_AZ_dqPE5 = 0; dfdq_upd_curr_vec_in_LX_dqPE5 = 0; dfdq_upd_curr_vec_in_LY_dqPE5 = 0; dfdq_upd_curr_vec_in_LZ_dqPE5 = 0;
      // dqPE6
      dfdq_upd_curr_vec_in_AX_dqPE6 = 0; dfdq_upd_curr_vec_in_AY_dqPE6 = 0; dfdq_upd_curr_vec_in_AZ_dqPE6 = 0; dfdq_upd_curr_vec_in_LX_dqPE6 = 0; dfdq_upd_curr_vec_in_LY_dqPE6 = 0; dfdq_upd_curr_vec_in_LZ_dqPE6 = 0;
      // dqPE7
      dfdq_upd_curr_vec_in_AX_dqPE7 = 0; dfdq_upd_curr_vec_in_AY_dqPE7 = 0; dfdq_upd_curr_vec_in_AZ_dqPE7 = 0; dfdq_upd_curr_vec_in_LX_dqPE7 = 0; dfdq_upd_curr_vec_in_LY_dqPE7 = 0; dfdq_upd_curr_vec_in_LZ_dqPE7 = 0;// External df updated
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 0;
      derv_in_dqdPE7 = 4'd1;
      sinq_val_in_dqdPE1 = 0; cosq_val_in_dqdPE1 = 0;
      // dqdPE2
      link_in_dqdPE2 = 0;
      derv_in_dqdPE2 = 4'd2;
      sinq_val_in_dqdPE2 = 0; cosq_val_in_dqdPE2 = 0;
      // dqdPE3
      link_in_dqdPE3 = 0;
      derv_in_dqdPE3 = 4'd3;
      sinq_val_in_dqdPE3 = 0; cosq_val_in_dqdPE3 = 0;
      // dqdPE4
      link_in_dqdPE4 = 0;
      derv_in_dqdPE4 = 4'd4;
      sinq_val_in_dqdPE4 = 0; cosq_val_in_dqdPE4 = 0;
      // dqdPE5
      link_in_dqdPE5 = 0;
      derv_in_dqdPE5 = 4'd5;
      sinq_val_in_dqdPE5 = 0; cosq_val_in_dqdPE5 = 0;
      // dqdPE6
      link_in_dqdPE6 = 0;
      derv_in_dqdPE6 = 4'd6;
      sinq_val_in_dqdPE6 = 0; cosq_val_in_dqdPE6 = 0;
      // dqdPE7
      link_in_dqdPE7 = 0;
      derv_in_dqdPE7 = 4'd7;
      sinq_val_in_dqdPE7 = 0; cosq_val_in_dqdPE7 = 0;
      // External df updated
      // dqdPE1
      dfdqd_upd_curr_vec_in_AX_dqdPE1 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE1 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE1 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE1 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE1 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE1 = 0;
      // dqdPE2
      dfdqd_upd_curr_vec_in_AX_dqdPE2 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE2 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE2 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE2 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE2 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE2 = 0;
      // dqdPE3
      dfdqd_upd_curr_vec_in_AX_dqdPE3 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE3 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE3 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE3 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE3 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE3 = 0;
      // dqdPE4
      dfdqd_upd_curr_vec_in_AX_dqdPE4 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE4 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE4 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE4 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE4 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE4 = 0;
      // dqdPE5
      dfdqd_upd_curr_vec_in_AX_dqdPE5 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE5 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE5 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE5 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE5 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE5 = 0;
      // dqdPE6
      dfdqd_upd_curr_vec_in_AX_dqdPE6 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE6 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE6 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE6 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE6 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE6 = 0;
      // dqdPE7
      dfdqd_upd_curr_vec_in_AX_dqdPE7 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE7 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE7 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE7 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE7 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE7 = 0;// External df updated
      //------------------------------------------------------------------------
      // df prev external inputs
      //------------------------------------------------------------------------
      dfdq_prev_vec_in_AX_dqPE1 = 32'd0; dfdq_prev_vec_in_AX_dqPE2 = 32'd0; dfdq_prev_vec_in_AX_dqPE3 = 32'd0; dfdq_prev_vec_in_AX_dqPE4 = 32'd0; dfdq_prev_vec_in_AX_dqPE5 = 32'd0; dfdq_prev_vec_in_AX_dqPE6 = 32'd0; dfdq_prev_vec_in_AX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AY_dqPE1 = 32'd0; dfdq_prev_vec_in_AY_dqPE2 = 32'd0; dfdq_prev_vec_in_AY_dqPE3 = 32'd0; dfdq_prev_vec_in_AY_dqPE4 = 32'd0; dfdq_prev_vec_in_AY_dqPE5 = 32'd0; dfdq_prev_vec_in_AY_dqPE6 = 32'd0; dfdq_prev_vec_in_AY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AZ_dqPE1 = 32'd0; dfdq_prev_vec_in_AZ_dqPE2 = 32'd0; dfdq_prev_vec_in_AZ_dqPE3 = 32'd0; dfdq_prev_vec_in_AZ_dqPE4 = 32'd0; dfdq_prev_vec_in_AZ_dqPE5 = 32'd0; dfdq_prev_vec_in_AZ_dqPE6 = 32'd0; dfdq_prev_vec_in_AZ_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LX_dqPE1 = 32'd0; dfdq_prev_vec_in_LX_dqPE2 = 32'd0; dfdq_prev_vec_in_LX_dqPE3 = 32'd0; dfdq_prev_vec_in_LX_dqPE4 = 32'd0; dfdq_prev_vec_in_LX_dqPE5 = 32'd0; dfdq_prev_vec_in_LX_dqPE6 = 32'd0; dfdq_prev_vec_in_LX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LY_dqPE1 = 32'd0; dfdq_prev_vec_in_LY_dqPE2 = 32'd0; dfdq_prev_vec_in_LY_dqPE3 = 32'd0; dfdq_prev_vec_in_LY_dqPE4 = 32'd0; dfdq_prev_vec_in_LY_dqPE5 = 32'd0; dfdq_prev_vec_in_LY_dqPE6 = 32'd0; dfdq_prev_vec_in_LY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LZ_dqPE1 = 32'd0; dfdq_prev_vec_in_LZ_dqPE2 = 32'd0; dfdq_prev_vec_in_LZ_dqPE3 = 32'd0; dfdq_prev_vec_in_LZ_dqPE4 = 32'd0; dfdq_prev_vec_in_LZ_dqPE5 = 32'd0; dfdq_prev_vec_in_LZ_dqPE6 = 32'd0; dfdq_prev_vec_in_LZ_dqPE7 = 32'd0;
      dfdqd_prev_vec_in_AX_dqdPE1 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE2 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE3 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AY_dqdPE1 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE2 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE3 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AZ_dqdPE1 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE2 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE3 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LX_dqdPE1 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE2 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE3 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LY_dqdPE1 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE2 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE3 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LZ_dqdPE1 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE2 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE3 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE7 = 32'd0;
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
      $display ("// Knot 1 Link 8 Init");
      //------------------------------------------------------------------------
      // Link 8 Inputs
      //------------------------------------------------------------------------
      // 7
      minv_prev_vec_in_C1 = 32'd21064; minv_prev_vec_in_C2 = 32'd23027; minv_prev_vec_in_C3 = 32'd12325; minv_prev_vec_in_C4 = 32'd187088; minv_prev_vec_in_C5 = 32'd6473895; minv_prev_vec_in_C6 = 32'd314358; minv_prev_vec_in_C7 = -32'd71764541;
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 4'd8;
      sinq_val_in_rnea = 0; cosq_val_in_rnea = 0;
      f_prev_vec_in_AX_rnea = 32'd8044; f_prev_vec_in_AY_rnea = -32'd6533; f_prev_vec_in_AZ_rnea = 32'd5043; f_prev_vec_in_LX_rnea = -32'd120315; f_prev_vec_in_LY_rnea = -32'd133594; f_prev_vec_in_LZ_rnea = -32'd13832;
      f_upd_curr_vec_in_AX_rnea = 0; f_upd_curr_vec_in_AY_rnea = 0; f_upd_curr_vec_in_AZ_rnea = 0; f_upd_curr_vec_in_LX_rnea = 0; f_upd_curr_vec_in_LY_rnea = 0; f_upd_curr_vec_in_LZ_rnea = 0;
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 4'd8;
      derv_in_dqPE1 = 4'd1;
      sinq_val_in_dqPE1 = 0; cosq_val_in_dqPE1 = 0;
      f_upd_curr_vec_in_AX_dqPE1 = 0; f_upd_curr_vec_in_AY_dqPE1 = 0; f_upd_curr_vec_in_AZ_dqPE1 = 0; f_upd_curr_vec_in_LX_dqPE1 = 0; f_upd_curr_vec_in_LY_dqPE1 = 0; f_upd_curr_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      link_in_dqPE2 = 4'd8;
      derv_in_dqPE2 = 4'd2;
      sinq_val_in_dqPE2 = 0; cosq_val_in_dqPE2 = 0;
      f_upd_curr_vec_in_AX_dqPE2 = 0; f_upd_curr_vec_in_AY_dqPE2 = 0; f_upd_curr_vec_in_AZ_dqPE2 = 0; f_upd_curr_vec_in_LX_dqPE2 = 0; f_upd_curr_vec_in_LY_dqPE2 = 0; f_upd_curr_vec_in_LZ_dqPE2 = 0;
      // dqPE3
      link_in_dqPE3 = 4'd8;
      derv_in_dqPE3 = 4'd3;
      sinq_val_in_dqPE3 = 0; cosq_val_in_dqPE3 = 0;
      f_upd_curr_vec_in_AX_dqPE3 = 0; f_upd_curr_vec_in_AY_dqPE3 = 0; f_upd_curr_vec_in_AZ_dqPE3 = 0; f_upd_curr_vec_in_LX_dqPE3 = 0; f_upd_curr_vec_in_LY_dqPE3 = 0; f_upd_curr_vec_in_LZ_dqPE3 = 0;
      // dqPE4
      link_in_dqPE4 = 4'd8;
      derv_in_dqPE4 = 4'd4;
      sinq_val_in_dqPE4 = 0; cosq_val_in_dqPE4 = 0;
      f_upd_curr_vec_in_AX_dqPE4 = 0; f_upd_curr_vec_in_AY_dqPE4 = 0; f_upd_curr_vec_in_AZ_dqPE4 = 0; f_upd_curr_vec_in_LX_dqPE4 = 0; f_upd_curr_vec_in_LY_dqPE4 = 0; f_upd_curr_vec_in_LZ_dqPE4 = 0;
      // dqPE5
      link_in_dqPE5 = 4'd8;
      derv_in_dqPE5 = 4'd5;
      sinq_val_in_dqPE5 = 0; cosq_val_in_dqPE5 = 0;
      f_upd_curr_vec_in_AX_dqPE5 = 0; f_upd_curr_vec_in_AY_dqPE5 = 0; f_upd_curr_vec_in_AZ_dqPE5 = 0; f_upd_curr_vec_in_LX_dqPE5 = 0; f_upd_curr_vec_in_LY_dqPE5 = 0; f_upd_curr_vec_in_LZ_dqPE5 = 0;
      // dqPE6
      link_in_dqPE6 = 4'd8;
      derv_in_dqPE6 = 4'd6;
      sinq_val_in_dqPE6 = 0; cosq_val_in_dqPE6 = 0;
      f_upd_curr_vec_in_AX_dqPE6 = 0; f_upd_curr_vec_in_AY_dqPE6 = 0; f_upd_curr_vec_in_AZ_dqPE6 = 0; f_upd_curr_vec_in_LX_dqPE6 = 0; f_upd_curr_vec_in_LY_dqPE6 = 0; f_upd_curr_vec_in_LZ_dqPE6 = 0;
      // dqPE7
      link_in_dqPE7 = 4'd8;
      derv_in_dqPE7 = 4'd7;
      sinq_val_in_dqPE7 = 0; cosq_val_in_dqPE7 = 0;
      f_upd_curr_vec_in_AX_dqPE7 = 0; f_upd_curr_vec_in_AY_dqPE7 = 0; f_upd_curr_vec_in_AZ_dqPE7 = 0; f_upd_curr_vec_in_LX_dqPE7 = 0; f_upd_curr_vec_in_LY_dqPE7 = 0; f_upd_curr_vec_in_LZ_dqPE7 = 0;
      // External df updated
      // dqPE1
      dfdq_upd_curr_vec_in_AX_dqPE1 = 0; dfdq_upd_curr_vec_in_AY_dqPE1 = 0; dfdq_upd_curr_vec_in_AZ_dqPE1 = 0; dfdq_upd_curr_vec_in_LX_dqPE1 = 0; dfdq_upd_curr_vec_in_LY_dqPE1 = 0; dfdq_upd_curr_vec_in_LZ_dqPE1 = 0;
      // dqPE2
      dfdq_upd_curr_vec_in_AX_dqPE2 = 0; dfdq_upd_curr_vec_in_AY_dqPE2 = 0; dfdq_upd_curr_vec_in_AZ_dqPE2 = 0; dfdq_upd_curr_vec_in_LX_dqPE2 = 0; dfdq_upd_curr_vec_in_LY_dqPE2 = 0; dfdq_upd_curr_vec_in_LZ_dqPE2 = 0;
      // dqPE3
      dfdq_upd_curr_vec_in_AX_dqPE3 = 0; dfdq_upd_curr_vec_in_AY_dqPE3 = 0; dfdq_upd_curr_vec_in_AZ_dqPE3 = 0; dfdq_upd_curr_vec_in_LX_dqPE3 = 0; dfdq_upd_curr_vec_in_LY_dqPE3 = 0; dfdq_upd_curr_vec_in_LZ_dqPE3 = 0;
      // dqPE4
      dfdq_upd_curr_vec_in_AX_dqPE4 = 0; dfdq_upd_curr_vec_in_AY_dqPE4 = 0; dfdq_upd_curr_vec_in_AZ_dqPE4 = 0; dfdq_upd_curr_vec_in_LX_dqPE4 = 0; dfdq_upd_curr_vec_in_LY_dqPE4 = 0; dfdq_upd_curr_vec_in_LZ_dqPE4 = 0;
      // dqPE5
      dfdq_upd_curr_vec_in_AX_dqPE5 = 0; dfdq_upd_curr_vec_in_AY_dqPE5 = 0; dfdq_upd_curr_vec_in_AZ_dqPE5 = 0; dfdq_upd_curr_vec_in_LX_dqPE5 = 0; dfdq_upd_curr_vec_in_LY_dqPE5 = 0; dfdq_upd_curr_vec_in_LZ_dqPE5 = 0;
      // dqPE6
      dfdq_upd_curr_vec_in_AX_dqPE6 = 0; dfdq_upd_curr_vec_in_AY_dqPE6 = 0; dfdq_upd_curr_vec_in_AZ_dqPE6 = 0; dfdq_upd_curr_vec_in_LX_dqPE6 = 0; dfdq_upd_curr_vec_in_LY_dqPE6 = 0; dfdq_upd_curr_vec_in_LZ_dqPE6 = 0;
      // dqPE7
      dfdq_upd_curr_vec_in_AX_dqPE7 = 0; dfdq_upd_curr_vec_in_AY_dqPE7 = 0; dfdq_upd_curr_vec_in_AZ_dqPE7 = 0; dfdq_upd_curr_vec_in_LX_dqPE7 = 0; dfdq_upd_curr_vec_in_LY_dqPE7 = 0; dfdq_upd_curr_vec_in_LZ_dqPE7 = 0;// External df updated
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 4'd8;
      derv_in_dqdPE7 = 4'd1;
      sinq_val_in_dqdPE1 = 0; cosq_val_in_dqdPE1 = 0;
      // dqdPE2
      link_in_dqdPE2 = 4'd8;
      derv_in_dqdPE2 = 4'd2;
      sinq_val_in_dqdPE2 = 0; cosq_val_in_dqdPE2 = 0;
      // dqdPE3
      link_in_dqdPE3 = 4'd8;
      derv_in_dqdPE3 = 4'd3;
      sinq_val_in_dqdPE3 = 0; cosq_val_in_dqdPE3 = 0;
      // dqdPE4
      link_in_dqdPE4 = 4'd8;
      derv_in_dqdPE4 = 4'd4;
      sinq_val_in_dqdPE4 = 0; cosq_val_in_dqdPE4 = 0;
      // dqdPE5
      link_in_dqdPE5 = 4'd8;
      derv_in_dqdPE5 = 4'd5;
      sinq_val_in_dqdPE5 = 0; cosq_val_in_dqdPE5 = 0;
      // dqdPE6
      link_in_dqdPE6 = 4'd8;
      derv_in_dqdPE6 = 4'd6;
      sinq_val_in_dqdPE6 = 0; cosq_val_in_dqdPE6 = 0;
      // dqdPE7
      link_in_dqdPE7 = 4'd8;
      derv_in_dqdPE7 = 4'd7;
      sinq_val_in_dqdPE7 = 0; cosq_val_in_dqdPE7 = 0;
      // External df updated
      // dqdPE1
      dfdqd_upd_curr_vec_in_AX_dqdPE1 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE1 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE1 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE1 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE1 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE1 = 0;
      // dqdPE2
      dfdqd_upd_curr_vec_in_AX_dqdPE2 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE2 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE2 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE2 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE2 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE2 = 0;
      // dqdPE3
      dfdqd_upd_curr_vec_in_AX_dqdPE3 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE3 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE3 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE3 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE3 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE3 = 0;
      // dqdPE4
      dfdqd_upd_curr_vec_in_AX_dqdPE4 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE4 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE4 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE4 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE4 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE4 = 0;
      // dqdPE5
      dfdqd_upd_curr_vec_in_AX_dqdPE5 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE5 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE5 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE5 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE5 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE5 = 0;
      // dqdPE6
      dfdqd_upd_curr_vec_in_AX_dqdPE6 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE6 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE6 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE6 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE6 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE6 = 0;
      // dqdPE7
      dfdqd_upd_curr_vec_in_AX_dqdPE7 = 0; dfdqd_upd_curr_vec_in_AY_dqdPE7 = 0; dfdqd_upd_curr_vec_in_AZ_dqdPE7 = 0; dfdqd_upd_curr_vec_in_LX_dqdPE7 = 0; dfdqd_upd_curr_vec_in_LY_dqdPE7 = 0; dfdqd_upd_curr_vec_in_LZ_dqdPE7 = 0;// External df updated
      //------------------------------------------------------------------------
      // df prev external inputs
      //------------------------------------------------------------------------
      dfdq_prev_vec_in_AX_dqPE1 = 32'd0; dfdq_prev_vec_in_AX_dqPE2 = -32'd155; dfdq_prev_vec_in_AX_dqPE3 = 32'd691; dfdq_prev_vec_in_AX_dqPE4 = 32'd463; dfdq_prev_vec_in_AX_dqPE5 = 32'd126; dfdq_prev_vec_in_AX_dqPE6 = 32'd1874; dfdq_prev_vec_in_AX_dqPE7 = -32'd6533;
      dfdq_prev_vec_in_AY_dqPE1 = 32'd0; dfdq_prev_vec_in_AY_dqPE2 = 32'd52; dfdq_prev_vec_in_AY_dqPE3 = -32'd424; dfdq_prev_vec_in_AY_dqPE4 = 32'd142; dfdq_prev_vec_in_AY_dqPE5 = 32'd895; dfdq_prev_vec_in_AY_dqPE6 = 32'd1840; dfdq_prev_vec_in_AY_dqPE7 = -32'd8044;
      dfdq_prev_vec_in_AZ_dqPE1 = 32'd0; dfdq_prev_vec_in_AZ_dqPE2 = -32'd35; dfdq_prev_vec_in_AZ_dqPE3 = -32'd3; dfdq_prev_vec_in_AZ_dqPE4 = 32'd72; dfdq_prev_vec_in_AZ_dqPE5 = -32'd75; dfdq_prev_vec_in_AZ_dqPE6 = -32'd454; dfdq_prev_vec_in_AZ_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LX_dqPE1 = 32'd0; dfdq_prev_vec_in_LX_dqPE2 = -32'd3285; dfdq_prev_vec_in_LX_dqPE3 = -32'd13804; dfdq_prev_vec_in_LX_dqPE4 = 32'd6498; dfdq_prev_vec_in_LX_dqPE5 = 32'd35032; dfdq_prev_vec_in_LX_dqPE6 = 32'd34895; dfdq_prev_vec_in_LX_dqPE7 = -32'd133594;
      dfdq_prev_vec_in_LY_dqPE1 = 32'd0; dfdq_prev_vec_in_LY_dqPE2 = 32'd10772; dfdq_prev_vec_in_LY_dqPE3 = -32'd28595; dfdq_prev_vec_in_LY_dqPE4 = -32'd29148; dfdq_prev_vec_in_LY_dqPE5 = -32'd4116; dfdq_prev_vec_in_LY_dqPE6 = -32'd35504; dfdq_prev_vec_in_LY_dqPE7 = 32'd120316;
      dfdq_prev_vec_in_LZ_dqPE1 = 32'd0; dfdq_prev_vec_in_LZ_dqPE2 = -32'd19629; dfdq_prev_vec_in_LZ_dqPE3 = 32'd12420; dfdq_prev_vec_in_LZ_dqPE4 = 32'd15012; dfdq_prev_vec_in_LZ_dqPE5 = -32'd6108; dfdq_prev_vec_in_LZ_dqPE6 = -32'd26838; dfdq_prev_vec_in_LZ_dqPE7 = -32'd0;
      dfdqd_prev_vec_in_AX_dqdPE1 = -32'd204; dfdqd_prev_vec_in_AX_dqdPE2 = -32'd355; dfdqd_prev_vec_in_AX_dqdPE3 = 32'd58; dfdqd_prev_vec_in_AX_dqdPE4 = 32'd128; dfdqd_prev_vec_in_AX_dqdPE5 = 32'd34; dfdqd_prev_vec_in_AX_dqdPE6 = 32'd184; dfdqd_prev_vec_in_AX_dqdPE7 = 32'd43;
      dfdqd_prev_vec_in_AY_dqdPE1 = -32'd186; dfdqd_prev_vec_in_AY_dqdPE2 = 32'd404; dfdqd_prev_vec_in_AY_dqdPE3 = -32'd176; dfdqd_prev_vec_in_AY_dqdPE4 = -32'd786; dfdqd_prev_vec_in_AY_dqdPE5 = 32'd108; dfdqd_prev_vec_in_AY_dqdPE6 = 32'd208; dfdqd_prev_vec_in_AY_dqdPE7 = -32'd12;
      dfdqd_prev_vec_in_AZ_dqdPE1 = -32'd9; dfdqd_prev_vec_in_AZ_dqdPE2 = -32'd29; dfdqd_prev_vec_in_AZ_dqdPE3 = -32'd8; dfdqd_prev_vec_in_AZ_dqdPE4 = 32'd69; dfdqd_prev_vec_in_AZ_dqdPE5 = -32'd23; dfdqd_prev_vec_in_AZ_dqdPE6 = -32'd41; dfdqd_prev_vec_in_AZ_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LX_dqdPE1 = -32'd10435; dfdqd_prev_vec_in_LX_dqdPE2 = 32'd23638; dfdqd_prev_vec_in_LX_dqdPE3 = -32'd7656; dfdqd_prev_vec_in_LX_dqdPE4 = -32'd37658; dfdqd_prev_vec_in_LX_dqdPE5 = 32'd3027; dfdqd_prev_vec_in_LX_dqdPE6 = 32'd6737; dfdqd_prev_vec_in_LX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LY_dqdPE1 = 32'd13340; dfdqd_prev_vec_in_LY_dqdPE2 = 32'd20050; dfdqd_prev_vec_in_LY_dqdPE3 = 32'd289; dfdqd_prev_vec_in_LY_dqdPE4 = -32'd5454; dfdqd_prev_vec_in_LY_dqdPE5 = 32'd998; dfdqd_prev_vec_in_LY_dqdPE6 = -32'd5960; dfdqd_prev_vec_in_LY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LZ_dqdPE1 = -32'd8477; dfdqd_prev_vec_in_LZ_dqdPE2 = -32'd12323; dfdqd_prev_vec_in_LZ_dqdPE3 = 32'd1071; dfdqd_prev_vec_in_LZ_dqdPE4 = -32'd549; dfdqd_prev_vec_in_LZ_dqdPE5 = -32'd757; dfdqd_prev_vec_in_LZ_dqdPE6 = 32'd1182; dfdqd_prev_vec_in_LZ_dqdPE7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
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
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 8 Outputs
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      // External f updated prev
      //------------------------------------------------------------------------
      // rnea
      f_upd_prev_vec_reg_AX_rnea = f_upd_prev_vec_out_AX_rnea; f_upd_prev_vec_reg_AY_rnea = f_upd_prev_vec_out_AY_rnea; f_upd_prev_vec_reg_AZ_rnea = f_upd_prev_vec_out_AZ_rnea; f_upd_prev_vec_reg_LX_rnea = f_upd_prev_vec_out_LX_rnea; f_upd_prev_vec_reg_LY_rnea = f_upd_prev_vec_out_LY_rnea; f_upd_prev_vec_reg_LZ_rnea = f_upd_prev_vec_out_LZ_rnea; 
      //------------------------------------------------------------------------
      // External df updated prev
      //------------------------------------------------------------------------
      // dqPE1
      dfdq_upd_prev_vec_reg_AX_dqPE1 = dfdq_upd_prev_vec_out_AX_dqPE1; dfdq_upd_prev_vec_reg_AY_dqPE1 = dfdq_upd_prev_vec_out_AY_dqPE1; dfdq_upd_prev_vec_reg_AZ_dqPE1 = dfdq_upd_prev_vec_out_AZ_dqPE1; dfdq_upd_prev_vec_reg_LX_dqPE1 = dfdq_upd_prev_vec_out_LX_dqPE1; dfdq_upd_prev_vec_reg_LY_dqPE1 = dfdq_upd_prev_vec_out_LY_dqPE1; dfdq_upd_prev_vec_reg_LZ_dqPE1 = dfdq_upd_prev_vec_out_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_prev_vec_reg_AX_dqPE2 = dfdq_upd_prev_vec_out_AX_dqPE2; dfdq_upd_prev_vec_reg_AY_dqPE2 = dfdq_upd_prev_vec_out_AY_dqPE2; dfdq_upd_prev_vec_reg_AZ_dqPE2 = dfdq_upd_prev_vec_out_AZ_dqPE2; dfdq_upd_prev_vec_reg_LX_dqPE2 = dfdq_upd_prev_vec_out_LX_dqPE2; dfdq_upd_prev_vec_reg_LY_dqPE2 = dfdq_upd_prev_vec_out_LY_dqPE2; dfdq_upd_prev_vec_reg_LZ_dqPE2 = dfdq_upd_prev_vec_out_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_prev_vec_reg_AX_dqPE3 = dfdq_upd_prev_vec_out_AX_dqPE3; dfdq_upd_prev_vec_reg_AY_dqPE3 = dfdq_upd_prev_vec_out_AY_dqPE3; dfdq_upd_prev_vec_reg_AZ_dqPE3 = dfdq_upd_prev_vec_out_AZ_dqPE3; dfdq_upd_prev_vec_reg_LX_dqPE3 = dfdq_upd_prev_vec_out_LX_dqPE3; dfdq_upd_prev_vec_reg_LY_dqPE3 = dfdq_upd_prev_vec_out_LY_dqPE3; dfdq_upd_prev_vec_reg_LZ_dqPE3 = dfdq_upd_prev_vec_out_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_prev_vec_reg_AX_dqPE4 = dfdq_upd_prev_vec_out_AX_dqPE4; dfdq_upd_prev_vec_reg_AY_dqPE4 = dfdq_upd_prev_vec_out_AY_dqPE4; dfdq_upd_prev_vec_reg_AZ_dqPE4 = dfdq_upd_prev_vec_out_AZ_dqPE4; dfdq_upd_prev_vec_reg_LX_dqPE4 = dfdq_upd_prev_vec_out_LX_dqPE4; dfdq_upd_prev_vec_reg_LY_dqPE4 = dfdq_upd_prev_vec_out_LY_dqPE4; dfdq_upd_prev_vec_reg_LZ_dqPE4 = dfdq_upd_prev_vec_out_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_prev_vec_reg_AX_dqPE5 = dfdq_upd_prev_vec_out_AX_dqPE5; dfdq_upd_prev_vec_reg_AY_dqPE5 = dfdq_upd_prev_vec_out_AY_dqPE5; dfdq_upd_prev_vec_reg_AZ_dqPE5 = dfdq_upd_prev_vec_out_AZ_dqPE5; dfdq_upd_prev_vec_reg_LX_dqPE5 = dfdq_upd_prev_vec_out_LX_dqPE5; dfdq_upd_prev_vec_reg_LY_dqPE5 = dfdq_upd_prev_vec_out_LY_dqPE5; dfdq_upd_prev_vec_reg_LZ_dqPE5 = dfdq_upd_prev_vec_out_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_prev_vec_reg_AX_dqPE6 = dfdq_upd_prev_vec_out_AX_dqPE6; dfdq_upd_prev_vec_reg_AY_dqPE6 = dfdq_upd_prev_vec_out_AY_dqPE6; dfdq_upd_prev_vec_reg_AZ_dqPE6 = dfdq_upd_prev_vec_out_AZ_dqPE6; dfdq_upd_prev_vec_reg_LX_dqPE6 = dfdq_upd_prev_vec_out_LX_dqPE6; dfdq_upd_prev_vec_reg_LY_dqPE6 = dfdq_upd_prev_vec_out_LY_dqPE6; dfdq_upd_prev_vec_reg_LZ_dqPE6 = dfdq_upd_prev_vec_out_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_prev_vec_reg_AX_dqPE7 = dfdq_upd_prev_vec_out_AX_dqPE7; dfdq_upd_prev_vec_reg_AY_dqPE7 = dfdq_upd_prev_vec_out_AY_dqPE7; dfdq_upd_prev_vec_reg_AZ_dqPE7 = dfdq_upd_prev_vec_out_AZ_dqPE7; dfdq_upd_prev_vec_reg_LX_dqPE7 = dfdq_upd_prev_vec_out_LX_dqPE7; dfdq_upd_prev_vec_reg_LY_dqPE7 = dfdq_upd_prev_vec_out_LY_dqPE7; dfdq_upd_prev_vec_reg_LZ_dqPE7 = dfdq_upd_prev_vec_out_LZ_dqPE7; 
      // dqdPE1
      dfdqd_upd_prev_vec_reg_AX_dqdPE1 = dfdqd_upd_prev_vec_out_AX_dqdPE1; dfdqd_upd_prev_vec_reg_AY_dqdPE1 = dfdqd_upd_prev_vec_out_AY_dqdPE1; dfdqd_upd_prev_vec_reg_AZ_dqdPE1 = dfdqd_upd_prev_vec_out_AZ_dqdPE1; dfdqd_upd_prev_vec_reg_LX_dqdPE1 = dfdqd_upd_prev_vec_out_LX_dqdPE1; dfdqd_upd_prev_vec_reg_LY_dqdPE1 = dfdqd_upd_prev_vec_out_LY_dqdPE1; dfdqd_upd_prev_vec_reg_LZ_dqdPE1 = dfdqd_upd_prev_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_prev_vec_reg_AX_dqdPE2 = dfdqd_upd_prev_vec_out_AX_dqdPE2; dfdqd_upd_prev_vec_reg_AY_dqdPE2 = dfdqd_upd_prev_vec_out_AY_dqdPE2; dfdqd_upd_prev_vec_reg_AZ_dqdPE2 = dfdqd_upd_prev_vec_out_AZ_dqdPE2; dfdqd_upd_prev_vec_reg_LX_dqdPE2 = dfdqd_upd_prev_vec_out_LX_dqdPE2; dfdqd_upd_prev_vec_reg_LY_dqdPE2 = dfdqd_upd_prev_vec_out_LY_dqdPE2; dfdqd_upd_prev_vec_reg_LZ_dqdPE2 = dfdqd_upd_prev_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_prev_vec_reg_AX_dqdPE3 = dfdqd_upd_prev_vec_out_AX_dqdPE3; dfdqd_upd_prev_vec_reg_AY_dqdPE3 = dfdqd_upd_prev_vec_out_AY_dqdPE3; dfdqd_upd_prev_vec_reg_AZ_dqdPE3 = dfdqd_upd_prev_vec_out_AZ_dqdPE3; dfdqd_upd_prev_vec_reg_LX_dqdPE3 = dfdqd_upd_prev_vec_out_LX_dqdPE3; dfdqd_upd_prev_vec_reg_LY_dqdPE3 = dfdqd_upd_prev_vec_out_LY_dqdPE3; dfdqd_upd_prev_vec_reg_LZ_dqdPE3 = dfdqd_upd_prev_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_prev_vec_reg_AX_dqdPE4 = dfdqd_upd_prev_vec_out_AX_dqdPE4; dfdqd_upd_prev_vec_reg_AY_dqdPE4 = dfdqd_upd_prev_vec_out_AY_dqdPE4; dfdqd_upd_prev_vec_reg_AZ_dqdPE4 = dfdqd_upd_prev_vec_out_AZ_dqdPE4; dfdqd_upd_prev_vec_reg_LX_dqdPE4 = dfdqd_upd_prev_vec_out_LX_dqdPE4; dfdqd_upd_prev_vec_reg_LY_dqdPE4 = dfdqd_upd_prev_vec_out_LY_dqdPE4; dfdqd_upd_prev_vec_reg_LZ_dqdPE4 = dfdqd_upd_prev_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_prev_vec_reg_AX_dqdPE5 = dfdqd_upd_prev_vec_out_AX_dqdPE5; dfdqd_upd_prev_vec_reg_AY_dqdPE5 = dfdqd_upd_prev_vec_out_AY_dqdPE5; dfdqd_upd_prev_vec_reg_AZ_dqdPE5 = dfdqd_upd_prev_vec_out_AZ_dqdPE5; dfdqd_upd_prev_vec_reg_LX_dqdPE5 = dfdqd_upd_prev_vec_out_LX_dqdPE5; dfdqd_upd_prev_vec_reg_LY_dqdPE5 = dfdqd_upd_prev_vec_out_LY_dqdPE5; dfdqd_upd_prev_vec_reg_LZ_dqdPE5 = dfdqd_upd_prev_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_prev_vec_reg_AX_dqdPE6 = dfdqd_upd_prev_vec_out_AX_dqdPE6; dfdqd_upd_prev_vec_reg_AY_dqdPE6 = dfdqd_upd_prev_vec_out_AY_dqdPE6; dfdqd_upd_prev_vec_reg_AZ_dqdPE6 = dfdqd_upd_prev_vec_out_AZ_dqdPE6; dfdqd_upd_prev_vec_reg_LX_dqdPE6 = dfdqd_upd_prev_vec_out_LX_dqdPE6; dfdqd_upd_prev_vec_reg_LY_dqdPE6 = dfdqd_upd_prev_vec_out_LY_dqdPE6; dfdqd_upd_prev_vec_reg_LZ_dqdPE6 = dfdqd_upd_prev_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_prev_vec_reg_AX_dqdPE7 = dfdqd_upd_prev_vec_out_AX_dqdPE7; dfdqd_upd_prev_vec_reg_AY_dqdPE7 = dfdqd_upd_prev_vec_out_AY_dqdPE7; dfdqd_upd_prev_vec_reg_AZ_dqdPE7 = dfdqd_upd_prev_vec_out_AZ_dqdPE7; dfdqd_upd_prev_vec_reg_LX_dqdPE7 = dfdqd_upd_prev_vec_out_LX_dqdPE7; dfdqd_upd_prev_vec_reg_LY_dqdPE7 = dfdqd_upd_prev_vec_out_LY_dqdPE7; dfdqd_upd_prev_vec_reg_LZ_dqdPE7 = dfdqd_upd_prev_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Link 7 Inputs
      //------------------------------------------------------------------------
      // 6
      minv_prev_vec_in_C1 = -32'd25864; minv_prev_vec_in_C2 = -32'd89991; minv_prev_vec_in_C3 = -32'd45311; minv_prev_vec_in_C4 = -32'd358665; minv_prev_vec_in_C5 = -32'd204961; minv_prev_vec_in_C6 = -32'd8039236; minv_prev_vec_in_C7 = 32'd314358;
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 4'd7;
      sinq_val_in_rnea = 32'd49084; cosq_val_in_rnea = -32'd43424;
      f_prev_vec_in_AX_rnea = 32'd2203; f_prev_vec_in_AY_rnea = 32'd5901; f_prev_vec_in_AZ_rnea = 32'd31413; f_prev_vec_in_LX_rnea = 32'd121436; f_prev_vec_in_LY_rnea = -32'd77713; f_prev_vec_in_LZ_rnea = -32'd83897;
      f_upd_curr_vec_in_AX_rnea = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_rnea = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_rnea = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_rnea = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_rnea = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_rnea = f_upd_prev_vec_reg_LZ_rnea; 
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 4'd7;
      derv_in_dqPE1 = 4'd1;
      sinq_val_in_dqPE1 = 32'd49084; cosq_val_in_dqPE1 = -32'd43424;
      f_upd_curr_vec_in_AX_dqPE1 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE1 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE1 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE1 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE1 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE1 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE2
      link_in_dqPE2 = 4'd7;
      derv_in_dqPE2 = 4'd2;
      sinq_val_in_dqPE2 = 32'd49084; cosq_val_in_dqPE2 = -32'd43424;
      f_upd_curr_vec_in_AX_dqPE2 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE2 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE2 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE2 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE2 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE2 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE3
      link_in_dqPE3 = 4'd7;
      derv_in_dqPE3 = 4'd3;
      sinq_val_in_dqPE3 = 32'd49084; cosq_val_in_dqPE3 = -32'd43424;
      f_upd_curr_vec_in_AX_dqPE3 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE3 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE3 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE3 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE3 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE3 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE4
      link_in_dqPE4 = 4'd7;
      derv_in_dqPE4 = 4'd4;
      sinq_val_in_dqPE4 = 32'd49084; cosq_val_in_dqPE4 = -32'd43424;
      f_upd_curr_vec_in_AX_dqPE4 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE4 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE4 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE4 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE4 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE4 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE5
      link_in_dqPE5 = 4'd7;
      derv_in_dqPE5 = 4'd5;
      sinq_val_in_dqPE5 = 32'd49084; cosq_val_in_dqPE5 = -32'd43424;
      f_upd_curr_vec_in_AX_dqPE5 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE5 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE5 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE5 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE5 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE5 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE6
      link_in_dqPE6 = 4'd7;
      derv_in_dqPE6 = 4'd6;
      sinq_val_in_dqPE6 = 32'd49084; cosq_val_in_dqPE6 = -32'd43424;
      f_upd_curr_vec_in_AX_dqPE6 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE6 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE6 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE6 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE6 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE6 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE7
      link_in_dqPE7 = 4'd7;
      derv_in_dqPE7 = 4'd7;
      sinq_val_in_dqPE7 = 32'd49084; cosq_val_in_dqPE7 = -32'd43424;
      f_upd_curr_vec_in_AX_dqPE7 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE7 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE7 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE7 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE7 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE7 = f_upd_prev_vec_reg_LZ_rnea; 
      // External df updated
      // dqPE1
      dfdq_upd_curr_vec_in_AX_dqPE1 = dfdq_upd_prev_vec_reg_AX_dqPE1; dfdq_upd_curr_vec_in_AY_dqPE1 = dfdq_upd_prev_vec_reg_AY_dqPE1; dfdq_upd_curr_vec_in_AZ_dqPE1 = dfdq_upd_prev_vec_reg_AZ_dqPE1; dfdq_upd_curr_vec_in_LX_dqPE1 = dfdq_upd_prev_vec_reg_LX_dqPE1; dfdq_upd_curr_vec_in_LY_dqPE1 = dfdq_upd_prev_vec_reg_LY_dqPE1; dfdq_upd_curr_vec_in_LZ_dqPE1 = dfdq_upd_prev_vec_reg_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_curr_vec_in_AX_dqPE2 = dfdq_upd_prev_vec_reg_AX_dqPE2; dfdq_upd_curr_vec_in_AY_dqPE2 = dfdq_upd_prev_vec_reg_AY_dqPE2; dfdq_upd_curr_vec_in_AZ_dqPE2 = dfdq_upd_prev_vec_reg_AZ_dqPE2; dfdq_upd_curr_vec_in_LX_dqPE2 = dfdq_upd_prev_vec_reg_LX_dqPE2; dfdq_upd_curr_vec_in_LY_dqPE2 = dfdq_upd_prev_vec_reg_LY_dqPE2; dfdq_upd_curr_vec_in_LZ_dqPE2 = dfdq_upd_prev_vec_reg_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_curr_vec_in_AX_dqPE3 = dfdq_upd_prev_vec_reg_AX_dqPE3; dfdq_upd_curr_vec_in_AY_dqPE3 = dfdq_upd_prev_vec_reg_AY_dqPE3; dfdq_upd_curr_vec_in_AZ_dqPE3 = dfdq_upd_prev_vec_reg_AZ_dqPE3; dfdq_upd_curr_vec_in_LX_dqPE3 = dfdq_upd_prev_vec_reg_LX_dqPE3; dfdq_upd_curr_vec_in_LY_dqPE3 = dfdq_upd_prev_vec_reg_LY_dqPE3; dfdq_upd_curr_vec_in_LZ_dqPE3 = dfdq_upd_prev_vec_reg_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_curr_vec_in_AX_dqPE4 = dfdq_upd_prev_vec_reg_AX_dqPE4; dfdq_upd_curr_vec_in_AY_dqPE4 = dfdq_upd_prev_vec_reg_AY_dqPE4; dfdq_upd_curr_vec_in_AZ_dqPE4 = dfdq_upd_prev_vec_reg_AZ_dqPE4; dfdq_upd_curr_vec_in_LX_dqPE4 = dfdq_upd_prev_vec_reg_LX_dqPE4; dfdq_upd_curr_vec_in_LY_dqPE4 = dfdq_upd_prev_vec_reg_LY_dqPE4; dfdq_upd_curr_vec_in_LZ_dqPE4 = dfdq_upd_prev_vec_reg_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_curr_vec_in_AX_dqPE5 = dfdq_upd_prev_vec_reg_AX_dqPE5; dfdq_upd_curr_vec_in_AY_dqPE5 = dfdq_upd_prev_vec_reg_AY_dqPE5; dfdq_upd_curr_vec_in_AZ_dqPE5 = dfdq_upd_prev_vec_reg_AZ_dqPE5; dfdq_upd_curr_vec_in_LX_dqPE5 = dfdq_upd_prev_vec_reg_LX_dqPE5; dfdq_upd_curr_vec_in_LY_dqPE5 = dfdq_upd_prev_vec_reg_LY_dqPE5; dfdq_upd_curr_vec_in_LZ_dqPE5 = dfdq_upd_prev_vec_reg_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_curr_vec_in_AX_dqPE6 = dfdq_upd_prev_vec_reg_AX_dqPE6; dfdq_upd_curr_vec_in_AY_dqPE6 = dfdq_upd_prev_vec_reg_AY_dqPE6; dfdq_upd_curr_vec_in_AZ_dqPE6 = dfdq_upd_prev_vec_reg_AZ_dqPE6; dfdq_upd_curr_vec_in_LX_dqPE6 = dfdq_upd_prev_vec_reg_LX_dqPE6; dfdq_upd_curr_vec_in_LY_dqPE6 = dfdq_upd_prev_vec_reg_LY_dqPE6; dfdq_upd_curr_vec_in_LZ_dqPE6 = dfdq_upd_prev_vec_reg_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_curr_vec_in_AX_dqPE7 = dfdq_upd_prev_vec_reg_AX_dqPE7; dfdq_upd_curr_vec_in_AY_dqPE7 = dfdq_upd_prev_vec_reg_AY_dqPE7; dfdq_upd_curr_vec_in_AZ_dqPE7 = dfdq_upd_prev_vec_reg_AZ_dqPE7; dfdq_upd_curr_vec_in_LX_dqPE7 = dfdq_upd_prev_vec_reg_LX_dqPE7; dfdq_upd_curr_vec_in_LY_dqPE7 = dfdq_upd_prev_vec_reg_LY_dqPE7; dfdq_upd_curr_vec_in_LZ_dqPE7 = dfdq_upd_prev_vec_reg_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 4'd7;
      derv_in_dqdPE7 = 4'd1;
      sinq_val_in_dqdPE1 = 32'd49084; cosq_val_in_dqdPE1 = -32'd43424;
      // dqdPE2
      link_in_dqdPE2 = 4'd7;
      derv_in_dqdPE2 = 4'd2;
      sinq_val_in_dqdPE2 = 32'd49084; cosq_val_in_dqdPE2 = -32'd43424;
      // dqdPE3
      link_in_dqdPE3 = 4'd7;
      derv_in_dqdPE3 = 4'd3;
      sinq_val_in_dqdPE3 = 32'd49084; cosq_val_in_dqdPE3 = -32'd43424;
      // dqdPE4
      link_in_dqdPE4 = 4'd7;
      derv_in_dqdPE4 = 4'd4;
      sinq_val_in_dqdPE4 = 32'd49084; cosq_val_in_dqdPE4 = -32'd43424;
      // dqdPE5
      link_in_dqdPE5 = 4'd7;
      derv_in_dqdPE5 = 4'd5;
      sinq_val_in_dqdPE5 = 32'd49084; cosq_val_in_dqdPE5 = -32'd43424;
      // dqdPE6
      link_in_dqdPE6 = 4'd7;
      derv_in_dqdPE6 = 4'd6;
      sinq_val_in_dqdPE6 = 32'd49084; cosq_val_in_dqdPE6 = -32'd43424;
      // dqdPE7
      link_in_dqdPE7 = 4'd7;
      derv_in_dqdPE7 = 4'd7;
      sinq_val_in_dqdPE7 = 32'd49084; cosq_val_in_dqdPE7 = -32'd43424;
      // External df updated
      // dqdPE1
      dfdqd_upd_curr_vec_in_AX_dqdPE1 = dfdqd_upd_prev_vec_reg_AX_dqdPE1; dfdqd_upd_curr_vec_in_AY_dqdPE1 = dfdqd_upd_prev_vec_reg_AY_dqdPE1; dfdqd_upd_curr_vec_in_AZ_dqdPE1 = dfdqd_upd_prev_vec_reg_AZ_dqdPE1; dfdqd_upd_curr_vec_in_LX_dqdPE1 = dfdqd_upd_prev_vec_reg_LX_dqdPE1; dfdqd_upd_curr_vec_in_LY_dqdPE1 = dfdqd_upd_prev_vec_reg_LY_dqdPE1; dfdqd_upd_curr_vec_in_LZ_dqdPE1 = dfdqd_upd_prev_vec_reg_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_curr_vec_in_AX_dqdPE2 = dfdqd_upd_prev_vec_reg_AX_dqdPE2; dfdqd_upd_curr_vec_in_AY_dqdPE2 = dfdqd_upd_prev_vec_reg_AY_dqdPE2; dfdqd_upd_curr_vec_in_AZ_dqdPE2 = dfdqd_upd_prev_vec_reg_AZ_dqdPE2; dfdqd_upd_curr_vec_in_LX_dqdPE2 = dfdqd_upd_prev_vec_reg_LX_dqdPE2; dfdqd_upd_curr_vec_in_LY_dqdPE2 = dfdqd_upd_prev_vec_reg_LY_dqdPE2; dfdqd_upd_curr_vec_in_LZ_dqdPE2 = dfdqd_upd_prev_vec_reg_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_curr_vec_in_AX_dqdPE3 = dfdqd_upd_prev_vec_reg_AX_dqdPE3; dfdqd_upd_curr_vec_in_AY_dqdPE3 = dfdqd_upd_prev_vec_reg_AY_dqdPE3; dfdqd_upd_curr_vec_in_AZ_dqdPE3 = dfdqd_upd_prev_vec_reg_AZ_dqdPE3; dfdqd_upd_curr_vec_in_LX_dqdPE3 = dfdqd_upd_prev_vec_reg_LX_dqdPE3; dfdqd_upd_curr_vec_in_LY_dqdPE3 = dfdqd_upd_prev_vec_reg_LY_dqdPE3; dfdqd_upd_curr_vec_in_LZ_dqdPE3 = dfdqd_upd_prev_vec_reg_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_curr_vec_in_AX_dqdPE4 = dfdqd_upd_prev_vec_reg_AX_dqdPE4; dfdqd_upd_curr_vec_in_AY_dqdPE4 = dfdqd_upd_prev_vec_reg_AY_dqdPE4; dfdqd_upd_curr_vec_in_AZ_dqdPE4 = dfdqd_upd_prev_vec_reg_AZ_dqdPE4; dfdqd_upd_curr_vec_in_LX_dqdPE4 = dfdqd_upd_prev_vec_reg_LX_dqdPE4; dfdqd_upd_curr_vec_in_LY_dqdPE4 = dfdqd_upd_prev_vec_reg_LY_dqdPE4; dfdqd_upd_curr_vec_in_LZ_dqdPE4 = dfdqd_upd_prev_vec_reg_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_curr_vec_in_AX_dqdPE5 = dfdqd_upd_prev_vec_reg_AX_dqdPE5; dfdqd_upd_curr_vec_in_AY_dqdPE5 = dfdqd_upd_prev_vec_reg_AY_dqdPE5; dfdqd_upd_curr_vec_in_AZ_dqdPE5 = dfdqd_upd_prev_vec_reg_AZ_dqdPE5; dfdqd_upd_curr_vec_in_LX_dqdPE5 = dfdqd_upd_prev_vec_reg_LX_dqdPE5; dfdqd_upd_curr_vec_in_LY_dqdPE5 = dfdqd_upd_prev_vec_reg_LY_dqdPE5; dfdqd_upd_curr_vec_in_LZ_dqdPE5 = dfdqd_upd_prev_vec_reg_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_curr_vec_in_AX_dqdPE6 = dfdqd_upd_prev_vec_reg_AX_dqdPE6; dfdqd_upd_curr_vec_in_AY_dqdPE6 = dfdqd_upd_prev_vec_reg_AY_dqdPE6; dfdqd_upd_curr_vec_in_AZ_dqdPE6 = dfdqd_upd_prev_vec_reg_AZ_dqdPE6; dfdqd_upd_curr_vec_in_LX_dqdPE6 = dfdqd_upd_prev_vec_reg_LX_dqdPE6; dfdqd_upd_curr_vec_in_LY_dqdPE6 = dfdqd_upd_prev_vec_reg_LY_dqdPE6; dfdqd_upd_curr_vec_in_LZ_dqdPE6 = dfdqd_upd_prev_vec_reg_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_curr_vec_in_AX_dqdPE7 = dfdqd_upd_prev_vec_reg_AX_dqdPE7; dfdqd_upd_curr_vec_in_AY_dqdPE7 = dfdqd_upd_prev_vec_reg_AY_dqdPE7; dfdqd_upd_curr_vec_in_AZ_dqdPE7 = dfdqd_upd_prev_vec_reg_AZ_dqdPE7; dfdqd_upd_curr_vec_in_LX_dqdPE7 = dfdqd_upd_prev_vec_reg_LX_dqdPE7; dfdqd_upd_curr_vec_in_LY_dqdPE7 = dfdqd_upd_prev_vec_reg_LY_dqdPE7; dfdqd_upd_curr_vec_in_LZ_dqdPE7 = dfdqd_upd_prev_vec_reg_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // df prev external inputs
      //------------------------------------------------------------------------
      dfdq_prev_vec_in_AX_dqPE1 = 32'd0; dfdq_prev_vec_in_AX_dqPE2 = 32'd284; dfdq_prev_vec_in_AX_dqPE3 = -32'd35; dfdq_prev_vec_in_AX_dqPE4 = 32'd259; dfdq_prev_vec_in_AX_dqPE5 = 32'd931; dfdq_prev_vec_in_AX_dqPE6 = 32'd8200; dfdq_prev_vec_in_AX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AY_dqPE1 = 32'd0; dfdq_prev_vec_in_AY_dqPE2 = -32'd123; dfdq_prev_vec_in_AY_dqPE3 = -32'd73; dfdq_prev_vec_in_AY_dqPE4 = 32'd247; dfdq_prev_vec_in_AY_dqPE5 = -32'd245; dfdq_prev_vec_in_AY_dqPE6 = -32'd1679; dfdq_prev_vec_in_AY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AZ_dqPE1 = 32'd0; dfdq_prev_vec_in_AZ_dqPE2 = -32'd151; dfdq_prev_vec_in_AZ_dqPE3 = 32'd839; dfdq_prev_vec_in_AZ_dqPE4 = 32'd23; dfdq_prev_vec_in_AZ_dqPE5 = -32'd794; dfdq_prev_vec_in_AZ_dqPE6 = -32'd389; dfdq_prev_vec_in_AZ_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LX_dqPE1 = 32'd0; dfdq_prev_vec_in_LX_dqPE2 = 32'd32323; dfdq_prev_vec_in_LX_dqPE3 = -32'd160291; dfdq_prev_vec_in_LX_dqPE4 = -32'd90398; dfdq_prev_vec_in_LX_dqPE5 = 32'd80218; dfdq_prev_vec_in_LX_dqPE6 = -32'd77343; dfdq_prev_vec_in_LX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LY_dqPE1 = 32'd0; dfdq_prev_vec_in_LY_dqPE2 = -32'd111481; dfdq_prev_vec_in_LY_dqPE3 = 32'd77173; dfdq_prev_vec_in_LY_dqPE4 = 32'd64413; dfdq_prev_vec_in_LY_dqPE5 = -32'd25932; dfdq_prev_vec_in_LY_dqPE6 = -32'd128801; dfdq_prev_vec_in_LY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LZ_dqPE1 = 32'd0; dfdq_prev_vec_in_LZ_dqPE2 = -32'd49161; dfdq_prev_vec_in_LZ_dqPE3 = 32'd46245; dfdq_prev_vec_in_LZ_dqPE4 = 32'd109642; dfdq_prev_vec_in_LZ_dqPE5 = 32'd145168; dfdq_prev_vec_in_LZ_dqPE6 = 32'd1770; dfdq_prev_vec_in_LZ_dqPE7 = 32'd0;
      dfdqd_prev_vec_in_AX_dqdPE1 = 32'd76; dfdqd_prev_vec_in_AX_dqdPE2 = -32'd2; dfdqd_prev_vec_in_AX_dqdPE3 = 32'd75; dfdqd_prev_vec_in_AX_dqdPE4 = -32'd411; dfdqd_prev_vec_in_AX_dqdPE5 = 32'd337; dfdqd_prev_vec_in_AX_dqdPE6 = 32'd906; dfdqd_prev_vec_in_AX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AY_dqdPE1 = -32'd36; dfdqd_prev_vec_in_AY_dqdPE2 = -32'd40; dfdqd_prev_vec_in_AY_dqdPE3 = -32'd44; dfdqd_prev_vec_in_AY_dqdPE4 = 32'd186; dfdqd_prev_vec_in_AY_dqdPE5 = -32'd85; dfdqd_prev_vec_in_AY_dqdPE6 = -32'd135; dfdqd_prev_vec_in_AY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AZ_dqdPE1 = -32'd53; dfdqd_prev_vec_in_AZ_dqdPE2 = -32'd127; dfdqd_prev_vec_in_AZ_dqdPE3 = 32'd123; dfdqd_prev_vec_in_AZ_dqdPE4 = 32'd558; dfdqd_prev_vec_in_AZ_dqdPE5 = -32'd149; dfdqd_prev_vec_in_AZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LX_dqdPE1 = 32'd5723; dfdqd_prev_vec_in_LX_dqdPE2 = 32'd166896; dfdqd_prev_vec_in_LX_dqdPE3 = -32'd36058; dfdqd_prev_vec_in_LX_dqdPE4 = -32'd143888; dfdqd_prev_vec_in_LX_dqdPE5 = 32'd77; dfdqd_prev_vec_in_LX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LY_dqdPE1 = -32'd43324; dfdqd_prev_vec_in_LY_dqdPE2 = -32'd60969; dfdqd_prev_vec_in_LY_dqdPE3 = 32'd11058; dfdqd_prev_vec_in_LY_dqdPE4 = -32'd9066; dfdqd_prev_vec_in_LY_dqdPE5 = -32'd92; dfdqd_prev_vec_in_LY_dqdPE6 = 32'd42; dfdqd_prev_vec_in_LY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LZ_dqdPE1 = -32'd94049; dfdqd_prev_vec_in_LZ_dqdPE2 = 32'd24373; dfdqd_prev_vec_in_LZ_dqdPE3 = -32'd36659; dfdqd_prev_vec_in_LZ_dqdPE4 = -32'd120581; dfdqd_prev_vec_in_LZ_dqdPE5 = -32'd164; dfdqd_prev_vec_in_LZ_dqdPE6 = 32'd321; dfdqd_prev_vec_in_LZ_dqdPE7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
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
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 7 Outputs
      //------------------------------------------------------------------------
      $display ("// Knot 1 Link 7 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -35, -3, 72, -75, -454, 0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -9, -29, -8, 69, -23, -41, 0);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External f updated prev
      //------------------------------------------------------------------------
      // rnea
      f_upd_prev_vec_reg_AX_rnea = f_upd_prev_vec_out_AX_rnea; f_upd_prev_vec_reg_AY_rnea = f_upd_prev_vec_out_AY_rnea; f_upd_prev_vec_reg_AZ_rnea = f_upd_prev_vec_out_AZ_rnea; f_upd_prev_vec_reg_LX_rnea = f_upd_prev_vec_out_LX_rnea; f_upd_prev_vec_reg_LY_rnea = f_upd_prev_vec_out_LY_rnea; f_upd_prev_vec_reg_LZ_rnea = f_upd_prev_vec_out_LZ_rnea; 
      //------------------------------------------------------------------------
      // External df updated prev
      //------------------------------------------------------------------------
      // dqPE1
      dfdq_upd_prev_vec_reg_AX_dqPE1 = dfdq_upd_prev_vec_out_AX_dqPE1; dfdq_upd_prev_vec_reg_AY_dqPE1 = dfdq_upd_prev_vec_out_AY_dqPE1; dfdq_upd_prev_vec_reg_AZ_dqPE1 = dfdq_upd_prev_vec_out_AZ_dqPE1; dfdq_upd_prev_vec_reg_LX_dqPE1 = dfdq_upd_prev_vec_out_LX_dqPE1; dfdq_upd_prev_vec_reg_LY_dqPE1 = dfdq_upd_prev_vec_out_LY_dqPE1; dfdq_upd_prev_vec_reg_LZ_dqPE1 = dfdq_upd_prev_vec_out_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_prev_vec_reg_AX_dqPE2 = dfdq_upd_prev_vec_out_AX_dqPE2; dfdq_upd_prev_vec_reg_AY_dqPE2 = dfdq_upd_prev_vec_out_AY_dqPE2; dfdq_upd_prev_vec_reg_AZ_dqPE2 = dfdq_upd_prev_vec_out_AZ_dqPE2; dfdq_upd_prev_vec_reg_LX_dqPE2 = dfdq_upd_prev_vec_out_LX_dqPE2; dfdq_upd_prev_vec_reg_LY_dqPE2 = dfdq_upd_prev_vec_out_LY_dqPE2; dfdq_upd_prev_vec_reg_LZ_dqPE2 = dfdq_upd_prev_vec_out_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_prev_vec_reg_AX_dqPE3 = dfdq_upd_prev_vec_out_AX_dqPE3; dfdq_upd_prev_vec_reg_AY_dqPE3 = dfdq_upd_prev_vec_out_AY_dqPE3; dfdq_upd_prev_vec_reg_AZ_dqPE3 = dfdq_upd_prev_vec_out_AZ_dqPE3; dfdq_upd_prev_vec_reg_LX_dqPE3 = dfdq_upd_prev_vec_out_LX_dqPE3; dfdq_upd_prev_vec_reg_LY_dqPE3 = dfdq_upd_prev_vec_out_LY_dqPE3; dfdq_upd_prev_vec_reg_LZ_dqPE3 = dfdq_upd_prev_vec_out_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_prev_vec_reg_AX_dqPE4 = dfdq_upd_prev_vec_out_AX_dqPE4; dfdq_upd_prev_vec_reg_AY_dqPE4 = dfdq_upd_prev_vec_out_AY_dqPE4; dfdq_upd_prev_vec_reg_AZ_dqPE4 = dfdq_upd_prev_vec_out_AZ_dqPE4; dfdq_upd_prev_vec_reg_LX_dqPE4 = dfdq_upd_prev_vec_out_LX_dqPE4; dfdq_upd_prev_vec_reg_LY_dqPE4 = dfdq_upd_prev_vec_out_LY_dqPE4; dfdq_upd_prev_vec_reg_LZ_dqPE4 = dfdq_upd_prev_vec_out_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_prev_vec_reg_AX_dqPE5 = dfdq_upd_prev_vec_out_AX_dqPE5; dfdq_upd_prev_vec_reg_AY_dqPE5 = dfdq_upd_prev_vec_out_AY_dqPE5; dfdq_upd_prev_vec_reg_AZ_dqPE5 = dfdq_upd_prev_vec_out_AZ_dqPE5; dfdq_upd_prev_vec_reg_LX_dqPE5 = dfdq_upd_prev_vec_out_LX_dqPE5; dfdq_upd_prev_vec_reg_LY_dqPE5 = dfdq_upd_prev_vec_out_LY_dqPE5; dfdq_upd_prev_vec_reg_LZ_dqPE5 = dfdq_upd_prev_vec_out_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_prev_vec_reg_AX_dqPE6 = dfdq_upd_prev_vec_out_AX_dqPE6; dfdq_upd_prev_vec_reg_AY_dqPE6 = dfdq_upd_prev_vec_out_AY_dqPE6; dfdq_upd_prev_vec_reg_AZ_dqPE6 = dfdq_upd_prev_vec_out_AZ_dqPE6; dfdq_upd_prev_vec_reg_LX_dqPE6 = dfdq_upd_prev_vec_out_LX_dqPE6; dfdq_upd_prev_vec_reg_LY_dqPE6 = dfdq_upd_prev_vec_out_LY_dqPE6; dfdq_upd_prev_vec_reg_LZ_dqPE6 = dfdq_upd_prev_vec_out_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_prev_vec_reg_AX_dqPE7 = dfdq_upd_prev_vec_out_AX_dqPE7; dfdq_upd_prev_vec_reg_AY_dqPE7 = dfdq_upd_prev_vec_out_AY_dqPE7; dfdq_upd_prev_vec_reg_AZ_dqPE7 = dfdq_upd_prev_vec_out_AZ_dqPE7; dfdq_upd_prev_vec_reg_LX_dqPE7 = dfdq_upd_prev_vec_out_LX_dqPE7; dfdq_upd_prev_vec_reg_LY_dqPE7 = dfdq_upd_prev_vec_out_LY_dqPE7; dfdq_upd_prev_vec_reg_LZ_dqPE7 = dfdq_upd_prev_vec_out_LZ_dqPE7; 
      // dqdPE1
      dfdqd_upd_prev_vec_reg_AX_dqdPE1 = dfdqd_upd_prev_vec_out_AX_dqdPE1; dfdqd_upd_prev_vec_reg_AY_dqdPE1 = dfdqd_upd_prev_vec_out_AY_dqdPE1; dfdqd_upd_prev_vec_reg_AZ_dqdPE1 = dfdqd_upd_prev_vec_out_AZ_dqdPE1; dfdqd_upd_prev_vec_reg_LX_dqdPE1 = dfdqd_upd_prev_vec_out_LX_dqdPE1; dfdqd_upd_prev_vec_reg_LY_dqdPE1 = dfdqd_upd_prev_vec_out_LY_dqdPE1; dfdqd_upd_prev_vec_reg_LZ_dqdPE1 = dfdqd_upd_prev_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_prev_vec_reg_AX_dqdPE2 = dfdqd_upd_prev_vec_out_AX_dqdPE2; dfdqd_upd_prev_vec_reg_AY_dqdPE2 = dfdqd_upd_prev_vec_out_AY_dqdPE2; dfdqd_upd_prev_vec_reg_AZ_dqdPE2 = dfdqd_upd_prev_vec_out_AZ_dqdPE2; dfdqd_upd_prev_vec_reg_LX_dqdPE2 = dfdqd_upd_prev_vec_out_LX_dqdPE2; dfdqd_upd_prev_vec_reg_LY_dqdPE2 = dfdqd_upd_prev_vec_out_LY_dqdPE2; dfdqd_upd_prev_vec_reg_LZ_dqdPE2 = dfdqd_upd_prev_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_prev_vec_reg_AX_dqdPE3 = dfdqd_upd_prev_vec_out_AX_dqdPE3; dfdqd_upd_prev_vec_reg_AY_dqdPE3 = dfdqd_upd_prev_vec_out_AY_dqdPE3; dfdqd_upd_prev_vec_reg_AZ_dqdPE3 = dfdqd_upd_prev_vec_out_AZ_dqdPE3; dfdqd_upd_prev_vec_reg_LX_dqdPE3 = dfdqd_upd_prev_vec_out_LX_dqdPE3; dfdqd_upd_prev_vec_reg_LY_dqdPE3 = dfdqd_upd_prev_vec_out_LY_dqdPE3; dfdqd_upd_prev_vec_reg_LZ_dqdPE3 = dfdqd_upd_prev_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_prev_vec_reg_AX_dqdPE4 = dfdqd_upd_prev_vec_out_AX_dqdPE4; dfdqd_upd_prev_vec_reg_AY_dqdPE4 = dfdqd_upd_prev_vec_out_AY_dqdPE4; dfdqd_upd_prev_vec_reg_AZ_dqdPE4 = dfdqd_upd_prev_vec_out_AZ_dqdPE4; dfdqd_upd_prev_vec_reg_LX_dqdPE4 = dfdqd_upd_prev_vec_out_LX_dqdPE4; dfdqd_upd_prev_vec_reg_LY_dqdPE4 = dfdqd_upd_prev_vec_out_LY_dqdPE4; dfdqd_upd_prev_vec_reg_LZ_dqdPE4 = dfdqd_upd_prev_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_prev_vec_reg_AX_dqdPE5 = dfdqd_upd_prev_vec_out_AX_dqdPE5; dfdqd_upd_prev_vec_reg_AY_dqdPE5 = dfdqd_upd_prev_vec_out_AY_dqdPE5; dfdqd_upd_prev_vec_reg_AZ_dqdPE5 = dfdqd_upd_prev_vec_out_AZ_dqdPE5; dfdqd_upd_prev_vec_reg_LX_dqdPE5 = dfdqd_upd_prev_vec_out_LX_dqdPE5; dfdqd_upd_prev_vec_reg_LY_dqdPE5 = dfdqd_upd_prev_vec_out_LY_dqdPE5; dfdqd_upd_prev_vec_reg_LZ_dqdPE5 = dfdqd_upd_prev_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_prev_vec_reg_AX_dqdPE6 = dfdqd_upd_prev_vec_out_AX_dqdPE6; dfdqd_upd_prev_vec_reg_AY_dqdPE6 = dfdqd_upd_prev_vec_out_AY_dqdPE6; dfdqd_upd_prev_vec_reg_AZ_dqdPE6 = dfdqd_upd_prev_vec_out_AZ_dqdPE6; dfdqd_upd_prev_vec_reg_LX_dqdPE6 = dfdqd_upd_prev_vec_out_LX_dqdPE6; dfdqd_upd_prev_vec_reg_LY_dqdPE6 = dfdqd_upd_prev_vec_out_LY_dqdPE6; dfdqd_upd_prev_vec_reg_LZ_dqdPE6 = dfdqd_upd_prev_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_prev_vec_reg_AX_dqdPE7 = dfdqd_upd_prev_vec_out_AX_dqdPE7; dfdqd_upd_prev_vec_reg_AY_dqdPE7 = dfdqd_upd_prev_vec_out_AY_dqdPE7; dfdqd_upd_prev_vec_reg_AZ_dqdPE7 = dfdqd_upd_prev_vec_out_AZ_dqdPE7; dfdqd_upd_prev_vec_reg_LX_dqdPE7 = dfdqd_upd_prev_vec_out_LX_dqdPE7; dfdqd_upd_prev_vec_reg_LY_dqdPE7 = dfdqd_upd_prev_vec_out_LY_dqdPE7; dfdqd_upd_prev_vec_reg_LZ_dqdPE7 = dfdqd_upd_prev_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Link 6 Inputs
      //------------------------------------------------------------------------
      // 5
      minv_prev_vec_in_C1 = -32'd66476; minv_prev_vec_in_C2 = -32'd19260; minv_prev_vec_in_C3 = 32'd2574713; minv_prev_vec_in_C4 = -32'd105892; minv_prev_vec_in_C5 = -32'd9289794; minv_prev_vec_in_C6 = -32'd204961; minv_prev_vec_in_C7 = 32'd6473895;
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 4'd6;
      sinq_val_in_rnea = 32'd20062; cosq_val_in_rnea = 32'd62390;
      f_prev_vec_in_AX_rnea = -32'd5305; f_prev_vec_in_AY_rnea = 32'd5863; f_prev_vec_in_AZ_rnea = 32'd7667; f_prev_vec_in_LX_rnea = 32'd36574; f_prev_vec_in_LY_rnea = 32'd9374; f_prev_vec_in_LZ_rnea = -32'd25154;
      f_upd_curr_vec_in_AX_rnea = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_rnea = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_rnea = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_rnea = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_rnea = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_rnea = f_upd_prev_vec_reg_LZ_rnea; 
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 4'd6;
      derv_in_dqPE1 = 4'd1;
      sinq_val_in_dqPE1 = 32'd20062; cosq_val_in_dqPE1 = 32'd62390;
      f_upd_curr_vec_in_AX_dqPE1 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE1 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE1 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE1 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE1 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE1 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE2
      link_in_dqPE2 = 4'd6;
      derv_in_dqPE2 = 4'd2;
      sinq_val_in_dqPE2 = 32'd20062; cosq_val_in_dqPE2 = 32'd62390;
      f_upd_curr_vec_in_AX_dqPE2 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE2 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE2 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE2 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE2 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE2 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE3
      link_in_dqPE3 = 4'd6;
      derv_in_dqPE3 = 4'd3;
      sinq_val_in_dqPE3 = 32'd20062; cosq_val_in_dqPE3 = 32'd62390;
      f_upd_curr_vec_in_AX_dqPE3 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE3 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE3 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE3 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE3 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE3 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE4
      link_in_dqPE4 = 4'd6;
      derv_in_dqPE4 = 4'd4;
      sinq_val_in_dqPE4 = 32'd20062; cosq_val_in_dqPE4 = 32'd62390;
      f_upd_curr_vec_in_AX_dqPE4 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE4 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE4 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE4 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE4 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE4 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE5
      link_in_dqPE5 = 4'd6;
      derv_in_dqPE5 = 4'd5;
      sinq_val_in_dqPE5 = 32'd20062; cosq_val_in_dqPE5 = 32'd62390;
      f_upd_curr_vec_in_AX_dqPE5 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE5 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE5 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE5 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE5 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE5 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE6
      link_in_dqPE6 = 4'd6;
      derv_in_dqPE6 = 4'd6;
      sinq_val_in_dqPE6 = 32'd20062; cosq_val_in_dqPE6 = 32'd62390;
      f_upd_curr_vec_in_AX_dqPE6 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE6 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE6 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE6 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE6 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE6 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE7
      link_in_dqPE7 = 4'd6;
      derv_in_dqPE7 = 4'd7;
      sinq_val_in_dqPE7 = 32'd20062; cosq_val_in_dqPE7 = 32'd62390;
      f_upd_curr_vec_in_AX_dqPE7 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE7 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE7 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE7 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE7 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE7 = f_upd_prev_vec_reg_LZ_rnea; 
      // External df updated
      // dqPE1
      dfdq_upd_curr_vec_in_AX_dqPE1 = dfdq_upd_prev_vec_reg_AX_dqPE1; dfdq_upd_curr_vec_in_AY_dqPE1 = dfdq_upd_prev_vec_reg_AY_dqPE1; dfdq_upd_curr_vec_in_AZ_dqPE1 = dfdq_upd_prev_vec_reg_AZ_dqPE1; dfdq_upd_curr_vec_in_LX_dqPE1 = dfdq_upd_prev_vec_reg_LX_dqPE1; dfdq_upd_curr_vec_in_LY_dqPE1 = dfdq_upd_prev_vec_reg_LY_dqPE1; dfdq_upd_curr_vec_in_LZ_dqPE1 = dfdq_upd_prev_vec_reg_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_curr_vec_in_AX_dqPE2 = dfdq_upd_prev_vec_reg_AX_dqPE2; dfdq_upd_curr_vec_in_AY_dqPE2 = dfdq_upd_prev_vec_reg_AY_dqPE2; dfdq_upd_curr_vec_in_AZ_dqPE2 = dfdq_upd_prev_vec_reg_AZ_dqPE2; dfdq_upd_curr_vec_in_LX_dqPE2 = dfdq_upd_prev_vec_reg_LX_dqPE2; dfdq_upd_curr_vec_in_LY_dqPE2 = dfdq_upd_prev_vec_reg_LY_dqPE2; dfdq_upd_curr_vec_in_LZ_dqPE2 = dfdq_upd_prev_vec_reg_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_curr_vec_in_AX_dqPE3 = dfdq_upd_prev_vec_reg_AX_dqPE3; dfdq_upd_curr_vec_in_AY_dqPE3 = dfdq_upd_prev_vec_reg_AY_dqPE3; dfdq_upd_curr_vec_in_AZ_dqPE3 = dfdq_upd_prev_vec_reg_AZ_dqPE3; dfdq_upd_curr_vec_in_LX_dqPE3 = dfdq_upd_prev_vec_reg_LX_dqPE3; dfdq_upd_curr_vec_in_LY_dqPE3 = dfdq_upd_prev_vec_reg_LY_dqPE3; dfdq_upd_curr_vec_in_LZ_dqPE3 = dfdq_upd_prev_vec_reg_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_curr_vec_in_AX_dqPE4 = dfdq_upd_prev_vec_reg_AX_dqPE4; dfdq_upd_curr_vec_in_AY_dqPE4 = dfdq_upd_prev_vec_reg_AY_dqPE4; dfdq_upd_curr_vec_in_AZ_dqPE4 = dfdq_upd_prev_vec_reg_AZ_dqPE4; dfdq_upd_curr_vec_in_LX_dqPE4 = dfdq_upd_prev_vec_reg_LX_dqPE4; dfdq_upd_curr_vec_in_LY_dqPE4 = dfdq_upd_prev_vec_reg_LY_dqPE4; dfdq_upd_curr_vec_in_LZ_dqPE4 = dfdq_upd_prev_vec_reg_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_curr_vec_in_AX_dqPE5 = dfdq_upd_prev_vec_reg_AX_dqPE5; dfdq_upd_curr_vec_in_AY_dqPE5 = dfdq_upd_prev_vec_reg_AY_dqPE5; dfdq_upd_curr_vec_in_AZ_dqPE5 = dfdq_upd_prev_vec_reg_AZ_dqPE5; dfdq_upd_curr_vec_in_LX_dqPE5 = dfdq_upd_prev_vec_reg_LX_dqPE5; dfdq_upd_curr_vec_in_LY_dqPE5 = dfdq_upd_prev_vec_reg_LY_dqPE5; dfdq_upd_curr_vec_in_LZ_dqPE5 = dfdq_upd_prev_vec_reg_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_curr_vec_in_AX_dqPE6 = dfdq_upd_prev_vec_reg_AX_dqPE6; dfdq_upd_curr_vec_in_AY_dqPE6 = dfdq_upd_prev_vec_reg_AY_dqPE6; dfdq_upd_curr_vec_in_AZ_dqPE6 = dfdq_upd_prev_vec_reg_AZ_dqPE6; dfdq_upd_curr_vec_in_LX_dqPE6 = dfdq_upd_prev_vec_reg_LX_dqPE6; dfdq_upd_curr_vec_in_LY_dqPE6 = dfdq_upd_prev_vec_reg_LY_dqPE6; dfdq_upd_curr_vec_in_LZ_dqPE6 = dfdq_upd_prev_vec_reg_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_curr_vec_in_AX_dqPE7 = dfdq_upd_prev_vec_reg_AX_dqPE7; dfdq_upd_curr_vec_in_AY_dqPE7 = dfdq_upd_prev_vec_reg_AY_dqPE7; dfdq_upd_curr_vec_in_AZ_dqPE7 = dfdq_upd_prev_vec_reg_AZ_dqPE7; dfdq_upd_curr_vec_in_LX_dqPE7 = dfdq_upd_prev_vec_reg_LX_dqPE7; dfdq_upd_curr_vec_in_LY_dqPE7 = dfdq_upd_prev_vec_reg_LY_dqPE7; dfdq_upd_curr_vec_in_LZ_dqPE7 = dfdq_upd_prev_vec_reg_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 4'd6;
      derv_in_dqdPE7 = 4'd1;
      sinq_val_in_dqdPE1 = 32'd20062; cosq_val_in_dqdPE1 = 32'd62390;
      // dqdPE2
      link_in_dqdPE2 = 4'd6;
      derv_in_dqdPE2 = 4'd2;
      sinq_val_in_dqdPE2 = 32'd20062; cosq_val_in_dqdPE2 = 32'd62390;
      // dqdPE3
      link_in_dqdPE3 = 4'd6;
      derv_in_dqdPE3 = 4'd3;
      sinq_val_in_dqdPE3 = 32'd20062; cosq_val_in_dqdPE3 = 32'd62390;
      // dqdPE4
      link_in_dqdPE4 = 4'd6;
      derv_in_dqdPE4 = 4'd4;
      sinq_val_in_dqdPE4 = 32'd20062; cosq_val_in_dqdPE4 = 32'd62390;
      // dqdPE5
      link_in_dqdPE5 = 4'd6;
      derv_in_dqdPE5 = 4'd5;
      sinq_val_in_dqdPE5 = 32'd20062; cosq_val_in_dqdPE5 = 32'd62390;
      // dqdPE6
      link_in_dqdPE6 = 4'd6;
      derv_in_dqdPE6 = 4'd6;
      sinq_val_in_dqdPE6 = 32'd20062; cosq_val_in_dqdPE6 = 32'd62390;
      // dqdPE7
      link_in_dqdPE7 = 4'd6;
      derv_in_dqdPE7 = 4'd7;
      sinq_val_in_dqdPE7 = 32'd20062; cosq_val_in_dqdPE7 = 32'd62390;
      // External df updated
      // dqdPE1
      dfdqd_upd_curr_vec_in_AX_dqdPE1 = dfdqd_upd_prev_vec_reg_AX_dqdPE1; dfdqd_upd_curr_vec_in_AY_dqdPE1 = dfdqd_upd_prev_vec_reg_AY_dqdPE1; dfdqd_upd_curr_vec_in_AZ_dqdPE1 = dfdqd_upd_prev_vec_reg_AZ_dqdPE1; dfdqd_upd_curr_vec_in_LX_dqdPE1 = dfdqd_upd_prev_vec_reg_LX_dqdPE1; dfdqd_upd_curr_vec_in_LY_dqdPE1 = dfdqd_upd_prev_vec_reg_LY_dqdPE1; dfdqd_upd_curr_vec_in_LZ_dqdPE1 = dfdqd_upd_prev_vec_reg_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_curr_vec_in_AX_dqdPE2 = dfdqd_upd_prev_vec_reg_AX_dqdPE2; dfdqd_upd_curr_vec_in_AY_dqdPE2 = dfdqd_upd_prev_vec_reg_AY_dqdPE2; dfdqd_upd_curr_vec_in_AZ_dqdPE2 = dfdqd_upd_prev_vec_reg_AZ_dqdPE2; dfdqd_upd_curr_vec_in_LX_dqdPE2 = dfdqd_upd_prev_vec_reg_LX_dqdPE2; dfdqd_upd_curr_vec_in_LY_dqdPE2 = dfdqd_upd_prev_vec_reg_LY_dqdPE2; dfdqd_upd_curr_vec_in_LZ_dqdPE2 = dfdqd_upd_prev_vec_reg_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_curr_vec_in_AX_dqdPE3 = dfdqd_upd_prev_vec_reg_AX_dqdPE3; dfdqd_upd_curr_vec_in_AY_dqdPE3 = dfdqd_upd_prev_vec_reg_AY_dqdPE3; dfdqd_upd_curr_vec_in_AZ_dqdPE3 = dfdqd_upd_prev_vec_reg_AZ_dqdPE3; dfdqd_upd_curr_vec_in_LX_dqdPE3 = dfdqd_upd_prev_vec_reg_LX_dqdPE3; dfdqd_upd_curr_vec_in_LY_dqdPE3 = dfdqd_upd_prev_vec_reg_LY_dqdPE3; dfdqd_upd_curr_vec_in_LZ_dqdPE3 = dfdqd_upd_prev_vec_reg_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_curr_vec_in_AX_dqdPE4 = dfdqd_upd_prev_vec_reg_AX_dqdPE4; dfdqd_upd_curr_vec_in_AY_dqdPE4 = dfdqd_upd_prev_vec_reg_AY_dqdPE4; dfdqd_upd_curr_vec_in_AZ_dqdPE4 = dfdqd_upd_prev_vec_reg_AZ_dqdPE4; dfdqd_upd_curr_vec_in_LX_dqdPE4 = dfdqd_upd_prev_vec_reg_LX_dqdPE4; dfdqd_upd_curr_vec_in_LY_dqdPE4 = dfdqd_upd_prev_vec_reg_LY_dqdPE4; dfdqd_upd_curr_vec_in_LZ_dqdPE4 = dfdqd_upd_prev_vec_reg_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_curr_vec_in_AX_dqdPE5 = dfdqd_upd_prev_vec_reg_AX_dqdPE5; dfdqd_upd_curr_vec_in_AY_dqdPE5 = dfdqd_upd_prev_vec_reg_AY_dqdPE5; dfdqd_upd_curr_vec_in_AZ_dqdPE5 = dfdqd_upd_prev_vec_reg_AZ_dqdPE5; dfdqd_upd_curr_vec_in_LX_dqdPE5 = dfdqd_upd_prev_vec_reg_LX_dqdPE5; dfdqd_upd_curr_vec_in_LY_dqdPE5 = dfdqd_upd_prev_vec_reg_LY_dqdPE5; dfdqd_upd_curr_vec_in_LZ_dqdPE5 = dfdqd_upd_prev_vec_reg_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_curr_vec_in_AX_dqdPE6 = dfdqd_upd_prev_vec_reg_AX_dqdPE6; dfdqd_upd_curr_vec_in_AY_dqdPE6 = dfdqd_upd_prev_vec_reg_AY_dqdPE6; dfdqd_upd_curr_vec_in_AZ_dqdPE6 = dfdqd_upd_prev_vec_reg_AZ_dqdPE6; dfdqd_upd_curr_vec_in_LX_dqdPE6 = dfdqd_upd_prev_vec_reg_LX_dqdPE6; dfdqd_upd_curr_vec_in_LY_dqdPE6 = dfdqd_upd_prev_vec_reg_LY_dqdPE6; dfdqd_upd_curr_vec_in_LZ_dqdPE6 = dfdqd_upd_prev_vec_reg_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_curr_vec_in_AX_dqdPE7 = dfdqd_upd_prev_vec_reg_AX_dqdPE7; dfdqd_upd_curr_vec_in_AY_dqdPE7 = dfdqd_upd_prev_vec_reg_AY_dqdPE7; dfdqd_upd_curr_vec_in_AZ_dqdPE7 = dfdqd_upd_prev_vec_reg_AZ_dqdPE7; dfdqd_upd_curr_vec_in_LX_dqdPE7 = dfdqd_upd_prev_vec_reg_LX_dqdPE7; dfdqd_upd_curr_vec_in_LY_dqdPE7 = dfdqd_upd_prev_vec_reg_LY_dqdPE7; dfdqd_upd_curr_vec_in_LZ_dqdPE7 = dfdqd_upd_prev_vec_reg_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // df prev external inputs
      //------------------------------------------------------------------------
      dfdq_prev_vec_in_AX_dqPE1 = 32'd0; dfdq_prev_vec_in_AX_dqPE2 = -32'd4354; dfdq_prev_vec_in_AX_dqPE3 = 32'd3320; dfdq_prev_vec_in_AX_dqPE4 = 32'd7150; dfdq_prev_vec_in_AX_dqPE5 = 32'd10972; dfdq_prev_vec_in_AX_dqPE6 = 32'd0; dfdq_prev_vec_in_AX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AY_dqPE1 = 32'd0; dfdq_prev_vec_in_AY_dqPE2 = 32'd4610; dfdq_prev_vec_in_AY_dqPE3 = -32'd12747; dfdq_prev_vec_in_AY_dqPE4 = -32'd7214; dfdq_prev_vec_in_AY_dqPE5 = 32'd5786; dfdq_prev_vec_in_AY_dqPE6 = 32'd0; dfdq_prev_vec_in_AY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AZ_dqPE1 = 32'd0; dfdq_prev_vec_in_AZ_dqPE2 = -32'd1038; dfdq_prev_vec_in_AZ_dqPE3 = 32'd2853; dfdq_prev_vec_in_AZ_dqPE4 = 32'd1647; dfdq_prev_vec_in_AZ_dqPE5 = -32'd564; dfdq_prev_vec_in_AZ_dqPE6 = 32'd0; dfdq_prev_vec_in_AZ_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LX_dqPE1 = 32'd0; dfdq_prev_vec_in_LX_dqPE2 = 32'd48590; dfdq_prev_vec_in_LX_dqPE3 = -32'd137401; dfdq_prev_vec_in_LX_dqPE4 = -32'd65942; dfdq_prev_vec_in_LX_dqPE5 = 32'd23191; dfdq_prev_vec_in_LX_dqPE6 = 32'd0; dfdq_prev_vec_in_LX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LY_dqPE1 = 32'd0; dfdq_prev_vec_in_LY_dqPE2 = 32'd45129; dfdq_prev_vec_in_LY_dqPE3 = -32'd36066; dfdq_prev_vec_in_LY_dqPE4 = -32'd70817; dfdq_prev_vec_in_LY_dqPE5 = -32'd96617; dfdq_prev_vec_in_LY_dqPE6 = 32'd0; dfdq_prev_vec_in_LY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LZ_dqPE1 = 32'd0; dfdq_prev_vec_in_LZ_dqPE2 = -32'd62580; dfdq_prev_vec_in_LZ_dqPE3 = 32'd13151; dfdq_prev_vec_in_LZ_dqPE4 = -32'd4659; dfdq_prev_vec_in_LZ_dqPE5 = 32'd7121; dfdq_prev_vec_in_LZ_dqPE6 = 32'd0; dfdq_prev_vec_in_LZ_dqPE7 = 32'd0;
      dfdqd_prev_vec_in_AX_dqdPE1 = -32'd5945; dfdqd_prev_vec_in_AX_dqdPE2 = 32'd1309; dfdqd_prev_vec_in_AX_dqdPE3 = -32'd1513; dfdqd_prev_vec_in_AX_dqdPE4 = -32'd8879; dfdqd_prev_vec_in_AX_dqdPE5 = 32'd1237; dfdqd_prev_vec_in_AX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AY_dqdPE1 = 32'd1314; dfdqd_prev_vec_in_AY_dqdPE2 = 32'd12420; dfdqd_prev_vec_in_AY_dqdPE3 = -32'd2697; dfdqd_prev_vec_in_AY_dqdPE4 = -32'd9465; dfdqd_prev_vec_in_AY_dqdPE5 = 32'd16; dfdqd_prev_vec_in_AY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AZ_dqdPE1 = -32'd394; dfdqd_prev_vec_in_AZ_dqdPE2 = -32'd3077; dfdqd_prev_vec_in_AZ_dqdPE3 = 32'd491; dfdqd_prev_vec_in_AZ_dqdPE4 = 32'd2025; dfdqd_prev_vec_in_AZ_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LX_dqdPE1 = 32'd20251; dfdqd_prev_vec_in_LX_dqdPE2 = 32'd140948; dfdqd_prev_vec_in_LX_dqdPE3 = -32'd23281; dfdqd_prev_vec_in_LX_dqdPE4 = -32'd84990; dfdqd_prev_vec_in_LX_dqdPE5 = -32'd52; dfdqd_prev_vec_in_LX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LY_dqdPE1 = 32'd57716; dfdqd_prev_vec_in_LY_dqdPE2 = -32'd18551; dfdqd_prev_vec_in_LY_dqdPE3 = 32'd11438; dfdqd_prev_vec_in_LY_dqdPE4 = 32'd73710; dfdqd_prev_vec_in_LY_dqdPE5 = -32'd10981; dfdqd_prev_vec_in_LY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LZ_dqdPE1 = -32'd24770; dfdqd_prev_vec_in_LZ_dqdPE2 = -32'd13522; dfdqd_prev_vec_in_LZ_dqdPE3 = 32'd1380; dfdqd_prev_vec_in_LZ_dqdPE4 = -32'd31010; dfdqd_prev_vec_in_LZ_dqdPE5 = 32'd3378; dfdqd_prev_vec_in_LZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
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
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 6 Outputs
      //------------------------------------------------------------------------
      $display ("// Knot 1 Link 6 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -779, 4114, 1696, -2923, 77, 0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -332, -3145, 676, 3527, -418, -0, 41);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External f updated prev
      //------------------------------------------------------------------------
      // rnea
      f_upd_prev_vec_reg_AX_rnea = f_upd_prev_vec_out_AX_rnea; f_upd_prev_vec_reg_AY_rnea = f_upd_prev_vec_out_AY_rnea; f_upd_prev_vec_reg_AZ_rnea = f_upd_prev_vec_out_AZ_rnea; f_upd_prev_vec_reg_LX_rnea = f_upd_prev_vec_out_LX_rnea; f_upd_prev_vec_reg_LY_rnea = f_upd_prev_vec_out_LY_rnea; f_upd_prev_vec_reg_LZ_rnea = f_upd_prev_vec_out_LZ_rnea; 
      //------------------------------------------------------------------------
      // External df updated prev
      //------------------------------------------------------------------------
      // dqPE1
      dfdq_upd_prev_vec_reg_AX_dqPE1 = dfdq_upd_prev_vec_out_AX_dqPE1; dfdq_upd_prev_vec_reg_AY_dqPE1 = dfdq_upd_prev_vec_out_AY_dqPE1; dfdq_upd_prev_vec_reg_AZ_dqPE1 = dfdq_upd_prev_vec_out_AZ_dqPE1; dfdq_upd_prev_vec_reg_LX_dqPE1 = dfdq_upd_prev_vec_out_LX_dqPE1; dfdq_upd_prev_vec_reg_LY_dqPE1 = dfdq_upd_prev_vec_out_LY_dqPE1; dfdq_upd_prev_vec_reg_LZ_dqPE1 = dfdq_upd_prev_vec_out_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_prev_vec_reg_AX_dqPE2 = dfdq_upd_prev_vec_out_AX_dqPE2; dfdq_upd_prev_vec_reg_AY_dqPE2 = dfdq_upd_prev_vec_out_AY_dqPE2; dfdq_upd_prev_vec_reg_AZ_dqPE2 = dfdq_upd_prev_vec_out_AZ_dqPE2; dfdq_upd_prev_vec_reg_LX_dqPE2 = dfdq_upd_prev_vec_out_LX_dqPE2; dfdq_upd_prev_vec_reg_LY_dqPE2 = dfdq_upd_prev_vec_out_LY_dqPE2; dfdq_upd_prev_vec_reg_LZ_dqPE2 = dfdq_upd_prev_vec_out_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_prev_vec_reg_AX_dqPE3 = dfdq_upd_prev_vec_out_AX_dqPE3; dfdq_upd_prev_vec_reg_AY_dqPE3 = dfdq_upd_prev_vec_out_AY_dqPE3; dfdq_upd_prev_vec_reg_AZ_dqPE3 = dfdq_upd_prev_vec_out_AZ_dqPE3; dfdq_upd_prev_vec_reg_LX_dqPE3 = dfdq_upd_prev_vec_out_LX_dqPE3; dfdq_upd_prev_vec_reg_LY_dqPE3 = dfdq_upd_prev_vec_out_LY_dqPE3; dfdq_upd_prev_vec_reg_LZ_dqPE3 = dfdq_upd_prev_vec_out_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_prev_vec_reg_AX_dqPE4 = dfdq_upd_prev_vec_out_AX_dqPE4; dfdq_upd_prev_vec_reg_AY_dqPE4 = dfdq_upd_prev_vec_out_AY_dqPE4; dfdq_upd_prev_vec_reg_AZ_dqPE4 = dfdq_upd_prev_vec_out_AZ_dqPE4; dfdq_upd_prev_vec_reg_LX_dqPE4 = dfdq_upd_prev_vec_out_LX_dqPE4; dfdq_upd_prev_vec_reg_LY_dqPE4 = dfdq_upd_prev_vec_out_LY_dqPE4; dfdq_upd_prev_vec_reg_LZ_dqPE4 = dfdq_upd_prev_vec_out_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_prev_vec_reg_AX_dqPE5 = dfdq_upd_prev_vec_out_AX_dqPE5; dfdq_upd_prev_vec_reg_AY_dqPE5 = dfdq_upd_prev_vec_out_AY_dqPE5; dfdq_upd_prev_vec_reg_AZ_dqPE5 = dfdq_upd_prev_vec_out_AZ_dqPE5; dfdq_upd_prev_vec_reg_LX_dqPE5 = dfdq_upd_prev_vec_out_LX_dqPE5; dfdq_upd_prev_vec_reg_LY_dqPE5 = dfdq_upd_prev_vec_out_LY_dqPE5; dfdq_upd_prev_vec_reg_LZ_dqPE5 = dfdq_upd_prev_vec_out_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_prev_vec_reg_AX_dqPE6 = dfdq_upd_prev_vec_out_AX_dqPE6; dfdq_upd_prev_vec_reg_AY_dqPE6 = dfdq_upd_prev_vec_out_AY_dqPE6; dfdq_upd_prev_vec_reg_AZ_dqPE6 = dfdq_upd_prev_vec_out_AZ_dqPE6; dfdq_upd_prev_vec_reg_LX_dqPE6 = dfdq_upd_prev_vec_out_LX_dqPE6; dfdq_upd_prev_vec_reg_LY_dqPE6 = dfdq_upd_prev_vec_out_LY_dqPE6; dfdq_upd_prev_vec_reg_LZ_dqPE6 = dfdq_upd_prev_vec_out_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_prev_vec_reg_AX_dqPE7 = dfdq_upd_prev_vec_out_AX_dqPE7; dfdq_upd_prev_vec_reg_AY_dqPE7 = dfdq_upd_prev_vec_out_AY_dqPE7; dfdq_upd_prev_vec_reg_AZ_dqPE7 = dfdq_upd_prev_vec_out_AZ_dqPE7; dfdq_upd_prev_vec_reg_LX_dqPE7 = dfdq_upd_prev_vec_out_LX_dqPE7; dfdq_upd_prev_vec_reg_LY_dqPE7 = dfdq_upd_prev_vec_out_LY_dqPE7; dfdq_upd_prev_vec_reg_LZ_dqPE7 = dfdq_upd_prev_vec_out_LZ_dqPE7; 
      // dqdPE1
      dfdqd_upd_prev_vec_reg_AX_dqdPE1 = dfdqd_upd_prev_vec_out_AX_dqdPE1; dfdqd_upd_prev_vec_reg_AY_dqdPE1 = dfdqd_upd_prev_vec_out_AY_dqdPE1; dfdqd_upd_prev_vec_reg_AZ_dqdPE1 = dfdqd_upd_prev_vec_out_AZ_dqdPE1; dfdqd_upd_prev_vec_reg_LX_dqdPE1 = dfdqd_upd_prev_vec_out_LX_dqdPE1; dfdqd_upd_prev_vec_reg_LY_dqdPE1 = dfdqd_upd_prev_vec_out_LY_dqdPE1; dfdqd_upd_prev_vec_reg_LZ_dqdPE1 = dfdqd_upd_prev_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_prev_vec_reg_AX_dqdPE2 = dfdqd_upd_prev_vec_out_AX_dqdPE2; dfdqd_upd_prev_vec_reg_AY_dqdPE2 = dfdqd_upd_prev_vec_out_AY_dqdPE2; dfdqd_upd_prev_vec_reg_AZ_dqdPE2 = dfdqd_upd_prev_vec_out_AZ_dqdPE2; dfdqd_upd_prev_vec_reg_LX_dqdPE2 = dfdqd_upd_prev_vec_out_LX_dqdPE2; dfdqd_upd_prev_vec_reg_LY_dqdPE2 = dfdqd_upd_prev_vec_out_LY_dqdPE2; dfdqd_upd_prev_vec_reg_LZ_dqdPE2 = dfdqd_upd_prev_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_prev_vec_reg_AX_dqdPE3 = dfdqd_upd_prev_vec_out_AX_dqdPE3; dfdqd_upd_prev_vec_reg_AY_dqdPE3 = dfdqd_upd_prev_vec_out_AY_dqdPE3; dfdqd_upd_prev_vec_reg_AZ_dqdPE3 = dfdqd_upd_prev_vec_out_AZ_dqdPE3; dfdqd_upd_prev_vec_reg_LX_dqdPE3 = dfdqd_upd_prev_vec_out_LX_dqdPE3; dfdqd_upd_prev_vec_reg_LY_dqdPE3 = dfdqd_upd_prev_vec_out_LY_dqdPE3; dfdqd_upd_prev_vec_reg_LZ_dqdPE3 = dfdqd_upd_prev_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_prev_vec_reg_AX_dqdPE4 = dfdqd_upd_prev_vec_out_AX_dqdPE4; dfdqd_upd_prev_vec_reg_AY_dqdPE4 = dfdqd_upd_prev_vec_out_AY_dqdPE4; dfdqd_upd_prev_vec_reg_AZ_dqdPE4 = dfdqd_upd_prev_vec_out_AZ_dqdPE4; dfdqd_upd_prev_vec_reg_LX_dqdPE4 = dfdqd_upd_prev_vec_out_LX_dqdPE4; dfdqd_upd_prev_vec_reg_LY_dqdPE4 = dfdqd_upd_prev_vec_out_LY_dqdPE4; dfdqd_upd_prev_vec_reg_LZ_dqdPE4 = dfdqd_upd_prev_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_prev_vec_reg_AX_dqdPE5 = dfdqd_upd_prev_vec_out_AX_dqdPE5; dfdqd_upd_prev_vec_reg_AY_dqdPE5 = dfdqd_upd_prev_vec_out_AY_dqdPE5; dfdqd_upd_prev_vec_reg_AZ_dqdPE5 = dfdqd_upd_prev_vec_out_AZ_dqdPE5; dfdqd_upd_prev_vec_reg_LX_dqdPE5 = dfdqd_upd_prev_vec_out_LX_dqdPE5; dfdqd_upd_prev_vec_reg_LY_dqdPE5 = dfdqd_upd_prev_vec_out_LY_dqdPE5; dfdqd_upd_prev_vec_reg_LZ_dqdPE5 = dfdqd_upd_prev_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_prev_vec_reg_AX_dqdPE6 = dfdqd_upd_prev_vec_out_AX_dqdPE6; dfdqd_upd_prev_vec_reg_AY_dqdPE6 = dfdqd_upd_prev_vec_out_AY_dqdPE6; dfdqd_upd_prev_vec_reg_AZ_dqdPE6 = dfdqd_upd_prev_vec_out_AZ_dqdPE6; dfdqd_upd_prev_vec_reg_LX_dqdPE6 = dfdqd_upd_prev_vec_out_LX_dqdPE6; dfdqd_upd_prev_vec_reg_LY_dqdPE6 = dfdqd_upd_prev_vec_out_LY_dqdPE6; dfdqd_upd_prev_vec_reg_LZ_dqdPE6 = dfdqd_upd_prev_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_prev_vec_reg_AX_dqdPE7 = dfdqd_upd_prev_vec_out_AX_dqdPE7; dfdqd_upd_prev_vec_reg_AY_dqdPE7 = dfdqd_upd_prev_vec_out_AY_dqdPE7; dfdqd_upd_prev_vec_reg_AZ_dqdPE7 = dfdqd_upd_prev_vec_out_AZ_dqdPE7; dfdqd_upd_prev_vec_reg_LX_dqdPE7 = dfdqd_upd_prev_vec_out_LX_dqdPE7; dfdqd_upd_prev_vec_reg_LY_dqdPE7 = dfdqd_upd_prev_vec_out_LY_dqdPE7; dfdqd_upd_prev_vec_reg_LZ_dqdPE7 = dfdqd_upd_prev_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Link 5 Inputs
      //------------------------------------------------------------------------
      // 4
      minv_prev_vec_in_C1 = 32'd193436; minv_prev_vec_in_C2 = -32'd122649; minv_prev_vec_in_C3 = -32'd201513; minv_prev_vec_in_C4 = -32'd437695; minv_prev_vec_in_C5 = -32'd105892; minv_prev_vec_in_C6 = -32'd358665; minv_prev_vec_in_C7 = 32'd187088;
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 4'd5;
      sinq_val_in_rnea = -32'd48758; cosq_val_in_rnea = 32'd43790;
      f_prev_vec_in_AX_rnea = -32'd8244; f_prev_vec_in_AY_rnea = 32'd621; f_prev_vec_in_AZ_rnea = 32'd6514; f_prev_vec_in_LX_rnea = 32'd21590; f_prev_vec_in_LY_rnea = -32'd11080; f_prev_vec_in_LZ_rnea = -32'd133497;
      f_upd_curr_vec_in_AX_rnea = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_rnea = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_rnea = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_rnea = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_rnea = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_rnea = f_upd_prev_vec_reg_LZ_rnea; 
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 4'd5;
      derv_in_dqPE1 = 4'd1;
      sinq_val_in_dqPE1 = -32'd48758; cosq_val_in_dqPE1 = 32'd43790;
      f_upd_curr_vec_in_AX_dqPE1 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE1 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE1 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE1 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE1 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE1 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE2
      link_in_dqPE2 = 4'd5;
      derv_in_dqPE2 = 4'd2;
      sinq_val_in_dqPE2 = -32'd48758; cosq_val_in_dqPE2 = 32'd43790;
      f_upd_curr_vec_in_AX_dqPE2 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE2 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE2 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE2 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE2 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE2 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE3
      link_in_dqPE3 = 4'd5;
      derv_in_dqPE3 = 4'd3;
      sinq_val_in_dqPE3 = -32'd48758; cosq_val_in_dqPE3 = 32'd43790;
      f_upd_curr_vec_in_AX_dqPE3 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE3 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE3 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE3 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE3 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE3 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE4
      link_in_dqPE4 = 4'd5;
      derv_in_dqPE4 = 4'd4;
      sinq_val_in_dqPE4 = -32'd48758; cosq_val_in_dqPE4 = 32'd43790;
      f_upd_curr_vec_in_AX_dqPE4 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE4 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE4 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE4 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE4 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE4 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE5
      link_in_dqPE5 = 4'd5;
      derv_in_dqPE5 = 4'd5;
      sinq_val_in_dqPE5 = -32'd48758; cosq_val_in_dqPE5 = 32'd43790;
      f_upd_curr_vec_in_AX_dqPE5 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE5 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE5 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE5 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE5 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE5 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE6
      link_in_dqPE6 = 4'd5;
      derv_in_dqPE6 = 4'd6;
      sinq_val_in_dqPE6 = -32'd48758; cosq_val_in_dqPE6 = 32'd43790;
      f_upd_curr_vec_in_AX_dqPE6 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE6 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE6 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE6 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE6 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE6 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE7
      link_in_dqPE7 = 4'd5;
      derv_in_dqPE7 = 4'd7;
      sinq_val_in_dqPE7 = -32'd48758; cosq_val_in_dqPE7 = 32'd43790;
      f_upd_curr_vec_in_AX_dqPE7 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE7 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE7 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE7 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE7 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE7 = f_upd_prev_vec_reg_LZ_rnea; 
      // External df updated
      // dqPE1
      dfdq_upd_curr_vec_in_AX_dqPE1 = dfdq_upd_prev_vec_reg_AX_dqPE1; dfdq_upd_curr_vec_in_AY_dqPE1 = dfdq_upd_prev_vec_reg_AY_dqPE1; dfdq_upd_curr_vec_in_AZ_dqPE1 = dfdq_upd_prev_vec_reg_AZ_dqPE1; dfdq_upd_curr_vec_in_LX_dqPE1 = dfdq_upd_prev_vec_reg_LX_dqPE1; dfdq_upd_curr_vec_in_LY_dqPE1 = dfdq_upd_prev_vec_reg_LY_dqPE1; dfdq_upd_curr_vec_in_LZ_dqPE1 = dfdq_upd_prev_vec_reg_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_curr_vec_in_AX_dqPE2 = dfdq_upd_prev_vec_reg_AX_dqPE2; dfdq_upd_curr_vec_in_AY_dqPE2 = dfdq_upd_prev_vec_reg_AY_dqPE2; dfdq_upd_curr_vec_in_AZ_dqPE2 = dfdq_upd_prev_vec_reg_AZ_dqPE2; dfdq_upd_curr_vec_in_LX_dqPE2 = dfdq_upd_prev_vec_reg_LX_dqPE2; dfdq_upd_curr_vec_in_LY_dqPE2 = dfdq_upd_prev_vec_reg_LY_dqPE2; dfdq_upd_curr_vec_in_LZ_dqPE2 = dfdq_upd_prev_vec_reg_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_curr_vec_in_AX_dqPE3 = dfdq_upd_prev_vec_reg_AX_dqPE3; dfdq_upd_curr_vec_in_AY_dqPE3 = dfdq_upd_prev_vec_reg_AY_dqPE3; dfdq_upd_curr_vec_in_AZ_dqPE3 = dfdq_upd_prev_vec_reg_AZ_dqPE3; dfdq_upd_curr_vec_in_LX_dqPE3 = dfdq_upd_prev_vec_reg_LX_dqPE3; dfdq_upd_curr_vec_in_LY_dqPE3 = dfdq_upd_prev_vec_reg_LY_dqPE3; dfdq_upd_curr_vec_in_LZ_dqPE3 = dfdq_upd_prev_vec_reg_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_curr_vec_in_AX_dqPE4 = dfdq_upd_prev_vec_reg_AX_dqPE4; dfdq_upd_curr_vec_in_AY_dqPE4 = dfdq_upd_prev_vec_reg_AY_dqPE4; dfdq_upd_curr_vec_in_AZ_dqPE4 = dfdq_upd_prev_vec_reg_AZ_dqPE4; dfdq_upd_curr_vec_in_LX_dqPE4 = dfdq_upd_prev_vec_reg_LX_dqPE4; dfdq_upd_curr_vec_in_LY_dqPE4 = dfdq_upd_prev_vec_reg_LY_dqPE4; dfdq_upd_curr_vec_in_LZ_dqPE4 = dfdq_upd_prev_vec_reg_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_curr_vec_in_AX_dqPE5 = dfdq_upd_prev_vec_reg_AX_dqPE5; dfdq_upd_curr_vec_in_AY_dqPE5 = dfdq_upd_prev_vec_reg_AY_dqPE5; dfdq_upd_curr_vec_in_AZ_dqPE5 = dfdq_upd_prev_vec_reg_AZ_dqPE5; dfdq_upd_curr_vec_in_LX_dqPE5 = dfdq_upd_prev_vec_reg_LX_dqPE5; dfdq_upd_curr_vec_in_LY_dqPE5 = dfdq_upd_prev_vec_reg_LY_dqPE5; dfdq_upd_curr_vec_in_LZ_dqPE5 = dfdq_upd_prev_vec_reg_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_curr_vec_in_AX_dqPE6 = dfdq_upd_prev_vec_reg_AX_dqPE6; dfdq_upd_curr_vec_in_AY_dqPE6 = dfdq_upd_prev_vec_reg_AY_dqPE6; dfdq_upd_curr_vec_in_AZ_dqPE6 = dfdq_upd_prev_vec_reg_AZ_dqPE6; dfdq_upd_curr_vec_in_LX_dqPE6 = dfdq_upd_prev_vec_reg_LX_dqPE6; dfdq_upd_curr_vec_in_LY_dqPE6 = dfdq_upd_prev_vec_reg_LY_dqPE6; dfdq_upd_curr_vec_in_LZ_dqPE6 = dfdq_upd_prev_vec_reg_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_curr_vec_in_AX_dqPE7 = dfdq_upd_prev_vec_reg_AX_dqPE7; dfdq_upd_curr_vec_in_AY_dqPE7 = dfdq_upd_prev_vec_reg_AY_dqPE7; dfdq_upd_curr_vec_in_AZ_dqPE7 = dfdq_upd_prev_vec_reg_AZ_dqPE7; dfdq_upd_curr_vec_in_LX_dqPE7 = dfdq_upd_prev_vec_reg_LX_dqPE7; dfdq_upd_curr_vec_in_LY_dqPE7 = dfdq_upd_prev_vec_reg_LY_dqPE7; dfdq_upd_curr_vec_in_LZ_dqPE7 = dfdq_upd_prev_vec_reg_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 4'd5;
      derv_in_dqdPE7 = 4'd1;
      sinq_val_in_dqdPE1 = -32'd48758; cosq_val_in_dqdPE1 = 32'd43790;
      // dqdPE2
      link_in_dqdPE2 = 4'd5;
      derv_in_dqdPE2 = 4'd2;
      sinq_val_in_dqdPE2 = -32'd48758; cosq_val_in_dqdPE2 = 32'd43790;
      // dqdPE3
      link_in_dqdPE3 = 4'd5;
      derv_in_dqdPE3 = 4'd3;
      sinq_val_in_dqdPE3 = -32'd48758; cosq_val_in_dqdPE3 = 32'd43790;
      // dqdPE4
      link_in_dqdPE4 = 4'd5;
      derv_in_dqdPE4 = 4'd4;
      sinq_val_in_dqdPE4 = -32'd48758; cosq_val_in_dqdPE4 = 32'd43790;
      // dqdPE5
      link_in_dqdPE5 = 4'd5;
      derv_in_dqdPE5 = 4'd5;
      sinq_val_in_dqdPE5 = -32'd48758; cosq_val_in_dqdPE5 = 32'd43790;
      // dqdPE6
      link_in_dqdPE6 = 4'd5;
      derv_in_dqdPE6 = 4'd6;
      sinq_val_in_dqdPE6 = -32'd48758; cosq_val_in_dqdPE6 = 32'd43790;
      // dqdPE7
      link_in_dqdPE7 = 4'd5;
      derv_in_dqdPE7 = 4'd7;
      sinq_val_in_dqdPE7 = -32'd48758; cosq_val_in_dqdPE7 = 32'd43790;
      // External df updated
      // dqdPE1
      dfdqd_upd_curr_vec_in_AX_dqdPE1 = dfdqd_upd_prev_vec_reg_AX_dqdPE1; dfdqd_upd_curr_vec_in_AY_dqdPE1 = dfdqd_upd_prev_vec_reg_AY_dqdPE1; dfdqd_upd_curr_vec_in_AZ_dqdPE1 = dfdqd_upd_prev_vec_reg_AZ_dqdPE1; dfdqd_upd_curr_vec_in_LX_dqdPE1 = dfdqd_upd_prev_vec_reg_LX_dqdPE1; dfdqd_upd_curr_vec_in_LY_dqdPE1 = dfdqd_upd_prev_vec_reg_LY_dqdPE1; dfdqd_upd_curr_vec_in_LZ_dqdPE1 = dfdqd_upd_prev_vec_reg_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_curr_vec_in_AX_dqdPE2 = dfdqd_upd_prev_vec_reg_AX_dqdPE2; dfdqd_upd_curr_vec_in_AY_dqdPE2 = dfdqd_upd_prev_vec_reg_AY_dqdPE2; dfdqd_upd_curr_vec_in_AZ_dqdPE2 = dfdqd_upd_prev_vec_reg_AZ_dqdPE2; dfdqd_upd_curr_vec_in_LX_dqdPE2 = dfdqd_upd_prev_vec_reg_LX_dqdPE2; dfdqd_upd_curr_vec_in_LY_dqdPE2 = dfdqd_upd_prev_vec_reg_LY_dqdPE2; dfdqd_upd_curr_vec_in_LZ_dqdPE2 = dfdqd_upd_prev_vec_reg_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_curr_vec_in_AX_dqdPE3 = dfdqd_upd_prev_vec_reg_AX_dqdPE3; dfdqd_upd_curr_vec_in_AY_dqdPE3 = dfdqd_upd_prev_vec_reg_AY_dqdPE3; dfdqd_upd_curr_vec_in_AZ_dqdPE3 = dfdqd_upd_prev_vec_reg_AZ_dqdPE3; dfdqd_upd_curr_vec_in_LX_dqdPE3 = dfdqd_upd_prev_vec_reg_LX_dqdPE3; dfdqd_upd_curr_vec_in_LY_dqdPE3 = dfdqd_upd_prev_vec_reg_LY_dqdPE3; dfdqd_upd_curr_vec_in_LZ_dqdPE3 = dfdqd_upd_prev_vec_reg_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_curr_vec_in_AX_dqdPE4 = dfdqd_upd_prev_vec_reg_AX_dqdPE4; dfdqd_upd_curr_vec_in_AY_dqdPE4 = dfdqd_upd_prev_vec_reg_AY_dqdPE4; dfdqd_upd_curr_vec_in_AZ_dqdPE4 = dfdqd_upd_prev_vec_reg_AZ_dqdPE4; dfdqd_upd_curr_vec_in_LX_dqdPE4 = dfdqd_upd_prev_vec_reg_LX_dqdPE4; dfdqd_upd_curr_vec_in_LY_dqdPE4 = dfdqd_upd_prev_vec_reg_LY_dqdPE4; dfdqd_upd_curr_vec_in_LZ_dqdPE4 = dfdqd_upd_prev_vec_reg_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_curr_vec_in_AX_dqdPE5 = dfdqd_upd_prev_vec_reg_AX_dqdPE5; dfdqd_upd_curr_vec_in_AY_dqdPE5 = dfdqd_upd_prev_vec_reg_AY_dqdPE5; dfdqd_upd_curr_vec_in_AZ_dqdPE5 = dfdqd_upd_prev_vec_reg_AZ_dqdPE5; dfdqd_upd_curr_vec_in_LX_dqdPE5 = dfdqd_upd_prev_vec_reg_LX_dqdPE5; dfdqd_upd_curr_vec_in_LY_dqdPE5 = dfdqd_upd_prev_vec_reg_LY_dqdPE5; dfdqd_upd_curr_vec_in_LZ_dqdPE5 = dfdqd_upd_prev_vec_reg_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_curr_vec_in_AX_dqdPE6 = dfdqd_upd_prev_vec_reg_AX_dqdPE6; dfdqd_upd_curr_vec_in_AY_dqdPE6 = dfdqd_upd_prev_vec_reg_AY_dqdPE6; dfdqd_upd_curr_vec_in_AZ_dqdPE6 = dfdqd_upd_prev_vec_reg_AZ_dqdPE6; dfdqd_upd_curr_vec_in_LX_dqdPE6 = dfdqd_upd_prev_vec_reg_LX_dqdPE6; dfdqd_upd_curr_vec_in_LY_dqdPE6 = dfdqd_upd_prev_vec_reg_LY_dqdPE6; dfdqd_upd_curr_vec_in_LZ_dqdPE6 = dfdqd_upd_prev_vec_reg_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_curr_vec_in_AX_dqdPE7 = dfdqd_upd_prev_vec_reg_AX_dqdPE7; dfdqd_upd_curr_vec_in_AY_dqdPE7 = dfdqd_upd_prev_vec_reg_AY_dqdPE7; dfdqd_upd_curr_vec_in_AZ_dqdPE7 = dfdqd_upd_prev_vec_reg_AZ_dqdPE7; dfdqd_upd_curr_vec_in_LX_dqdPE7 = dfdqd_upd_prev_vec_reg_LX_dqdPE7; dfdqd_upd_curr_vec_in_LY_dqdPE7 = dfdqd_upd_prev_vec_reg_LY_dqdPE7; dfdqd_upd_curr_vec_in_LZ_dqdPE7 = dfdqd_upd_prev_vec_reg_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // df prev external inputs
      //------------------------------------------------------------------------
      dfdq_prev_vec_in_AX_dqPE1 = 32'd0; dfdq_prev_vec_in_AX_dqPE2 = 32'd826; dfdq_prev_vec_in_AX_dqPE3 = 32'd8949; dfdq_prev_vec_in_AX_dqPE4 = 32'd1941; dfdq_prev_vec_in_AX_dqPE5 = 32'd0; dfdq_prev_vec_in_AX_dqPE6 = 32'd0; dfdq_prev_vec_in_AX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AY_dqPE1 = 32'd0; dfdq_prev_vec_in_AY_dqPE2 = -32'd2678; dfdq_prev_vec_in_AY_dqPE3 = 32'd4680; dfdq_prev_vec_in_AY_dqPE4 = 32'd1622; dfdq_prev_vec_in_AY_dqPE5 = 32'd0; dfdq_prev_vec_in_AY_dqPE6 = 32'd0; dfdq_prev_vec_in_AY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AZ_dqPE1 = 32'd0; dfdq_prev_vec_in_AZ_dqPE2 = 32'd5904; dfdq_prev_vec_in_AZ_dqPE3 = -32'd12157; dfdq_prev_vec_in_AZ_dqPE4 = -32'd6891; dfdq_prev_vec_in_AZ_dqPE5 = 32'd0; dfdq_prev_vec_in_AZ_dqPE6 = 32'd0; dfdq_prev_vec_in_AZ_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LX_dqPE1 = 32'd0; dfdq_prev_vec_in_LX_dqPE2 = -32'd76136; dfdq_prev_vec_in_LX_dqPE3 = 32'd136829; dfdq_prev_vec_in_LX_dqPE4 = 32'd35836; dfdq_prev_vec_in_LX_dqPE5 = 32'd0; dfdq_prev_vec_in_LX_dqPE6 = 32'd0; dfdq_prev_vec_in_LX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LY_dqPE1 = 32'd0; dfdq_prev_vec_in_LY_dqPE2 = -32'd55811; dfdq_prev_vec_in_LY_dqPE3 = -32'd9425; dfdq_prev_vec_in_LY_dqPE4 = -32'd53266; dfdq_prev_vec_in_LY_dqPE5 = 32'd0; dfdq_prev_vec_in_LY_dqPE6 = 32'd0; dfdq_prev_vec_in_LY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LZ_dqPE1 = 32'd0; dfdq_prev_vec_in_LZ_dqPE2 = 32'd3436; dfdq_prev_vec_in_LZ_dqPE3 = 32'd89127; dfdq_prev_vec_in_LZ_dqPE4 = 32'd1368; dfdq_prev_vec_in_LZ_dqPE5 = 32'd0; dfdq_prev_vec_in_LZ_dqPE6 = 32'd0; dfdq_prev_vec_in_LZ_dqPE7 = 32'd0;
      dfdqd_prev_vec_in_AX_dqdPE1 = 32'd1436; dfdqd_prev_vec_in_AX_dqdPE2 = -32'd9457; dfdqd_prev_vec_in_AX_dqdPE3 = 32'd1126; dfdqd_prev_vec_in_AX_dqdPE4 = 32'd9615; dfdqd_prev_vec_in_AX_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AY_dqdPE1 = -32'd2460; dfdqd_prev_vec_in_AY_dqdPE2 = -32'd3074; dfdqd_prev_vec_in_AY_dqdPE3 = -32'd13; dfdqd_prev_vec_in_AY_dqdPE4 = 32'd277; dfdqd_prev_vec_in_AY_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AZ_dqdPE1 = 32'd5950; dfdqd_prev_vec_in_AZ_dqdPE2 = 32'd7332; dfdqd_prev_vec_in_AZ_dqdPE3 = -32'd181; dfdqd_prev_vec_in_AZ_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LX_dqdPE1 = -32'd73332; dfdqd_prev_vec_in_LX_dqdPE2 = -32'd89415; dfdqd_prev_vec_in_LX_dqdPE3 = -32'd473; dfdqd_prev_vec_in_LX_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LY_dqdPE1 = -32'd22838; dfdqd_prev_vec_in_LY_dqdPE2 = -32'd43368; dfdqd_prev_vec_in_LY_dqdPE3 = -32'd94; dfdqd_prev_vec_in_LY_dqdPE4 = -32'd13222; dfdqd_prev_vec_in_LY_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LZ_dqdPE1 = -32'd10554; dfdqd_prev_vec_in_LZ_dqdPE2 = -32'd135202; dfdqd_prev_vec_in_LZ_dqdPE3 = -32'd9858; dfdqd_prev_vec_in_LZ_dqdPE4 = 32'd45277; dfdqd_prev_vec_in_LZ_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
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
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 5 Outputs
      //------------------------------------------------------------------------
      $display ("// Knot 1 Link 5 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -1359, 3026, 2756, 365, 1553, -0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -910, -3013, 289, 1378, 72, 418, 6);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External f updated prev
      //------------------------------------------------------------------------
      // rnea
      f_upd_prev_vec_reg_AX_rnea = f_upd_prev_vec_out_AX_rnea; f_upd_prev_vec_reg_AY_rnea = f_upd_prev_vec_out_AY_rnea; f_upd_prev_vec_reg_AZ_rnea = f_upd_prev_vec_out_AZ_rnea; f_upd_prev_vec_reg_LX_rnea = f_upd_prev_vec_out_LX_rnea; f_upd_prev_vec_reg_LY_rnea = f_upd_prev_vec_out_LY_rnea; f_upd_prev_vec_reg_LZ_rnea = f_upd_prev_vec_out_LZ_rnea; 
      //------------------------------------------------------------------------
      // External df updated prev
      //------------------------------------------------------------------------
      // dqPE1
      dfdq_upd_prev_vec_reg_AX_dqPE1 = dfdq_upd_prev_vec_out_AX_dqPE1; dfdq_upd_prev_vec_reg_AY_dqPE1 = dfdq_upd_prev_vec_out_AY_dqPE1; dfdq_upd_prev_vec_reg_AZ_dqPE1 = dfdq_upd_prev_vec_out_AZ_dqPE1; dfdq_upd_prev_vec_reg_LX_dqPE1 = dfdq_upd_prev_vec_out_LX_dqPE1; dfdq_upd_prev_vec_reg_LY_dqPE1 = dfdq_upd_prev_vec_out_LY_dqPE1; dfdq_upd_prev_vec_reg_LZ_dqPE1 = dfdq_upd_prev_vec_out_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_prev_vec_reg_AX_dqPE2 = dfdq_upd_prev_vec_out_AX_dqPE2; dfdq_upd_prev_vec_reg_AY_dqPE2 = dfdq_upd_prev_vec_out_AY_dqPE2; dfdq_upd_prev_vec_reg_AZ_dqPE2 = dfdq_upd_prev_vec_out_AZ_dqPE2; dfdq_upd_prev_vec_reg_LX_dqPE2 = dfdq_upd_prev_vec_out_LX_dqPE2; dfdq_upd_prev_vec_reg_LY_dqPE2 = dfdq_upd_prev_vec_out_LY_dqPE2; dfdq_upd_prev_vec_reg_LZ_dqPE2 = dfdq_upd_prev_vec_out_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_prev_vec_reg_AX_dqPE3 = dfdq_upd_prev_vec_out_AX_dqPE3; dfdq_upd_prev_vec_reg_AY_dqPE3 = dfdq_upd_prev_vec_out_AY_dqPE3; dfdq_upd_prev_vec_reg_AZ_dqPE3 = dfdq_upd_prev_vec_out_AZ_dqPE3; dfdq_upd_prev_vec_reg_LX_dqPE3 = dfdq_upd_prev_vec_out_LX_dqPE3; dfdq_upd_prev_vec_reg_LY_dqPE3 = dfdq_upd_prev_vec_out_LY_dqPE3; dfdq_upd_prev_vec_reg_LZ_dqPE3 = dfdq_upd_prev_vec_out_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_prev_vec_reg_AX_dqPE4 = dfdq_upd_prev_vec_out_AX_dqPE4; dfdq_upd_prev_vec_reg_AY_dqPE4 = dfdq_upd_prev_vec_out_AY_dqPE4; dfdq_upd_prev_vec_reg_AZ_dqPE4 = dfdq_upd_prev_vec_out_AZ_dqPE4; dfdq_upd_prev_vec_reg_LX_dqPE4 = dfdq_upd_prev_vec_out_LX_dqPE4; dfdq_upd_prev_vec_reg_LY_dqPE4 = dfdq_upd_prev_vec_out_LY_dqPE4; dfdq_upd_prev_vec_reg_LZ_dqPE4 = dfdq_upd_prev_vec_out_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_prev_vec_reg_AX_dqPE5 = dfdq_upd_prev_vec_out_AX_dqPE5; dfdq_upd_prev_vec_reg_AY_dqPE5 = dfdq_upd_prev_vec_out_AY_dqPE5; dfdq_upd_prev_vec_reg_AZ_dqPE5 = dfdq_upd_prev_vec_out_AZ_dqPE5; dfdq_upd_prev_vec_reg_LX_dqPE5 = dfdq_upd_prev_vec_out_LX_dqPE5; dfdq_upd_prev_vec_reg_LY_dqPE5 = dfdq_upd_prev_vec_out_LY_dqPE5; dfdq_upd_prev_vec_reg_LZ_dqPE5 = dfdq_upd_prev_vec_out_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_prev_vec_reg_AX_dqPE6 = dfdq_upd_prev_vec_out_AX_dqPE6; dfdq_upd_prev_vec_reg_AY_dqPE6 = dfdq_upd_prev_vec_out_AY_dqPE6; dfdq_upd_prev_vec_reg_AZ_dqPE6 = dfdq_upd_prev_vec_out_AZ_dqPE6; dfdq_upd_prev_vec_reg_LX_dqPE6 = dfdq_upd_prev_vec_out_LX_dqPE6; dfdq_upd_prev_vec_reg_LY_dqPE6 = dfdq_upd_prev_vec_out_LY_dqPE6; dfdq_upd_prev_vec_reg_LZ_dqPE6 = dfdq_upd_prev_vec_out_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_prev_vec_reg_AX_dqPE7 = dfdq_upd_prev_vec_out_AX_dqPE7; dfdq_upd_prev_vec_reg_AY_dqPE7 = dfdq_upd_prev_vec_out_AY_dqPE7; dfdq_upd_prev_vec_reg_AZ_dqPE7 = dfdq_upd_prev_vec_out_AZ_dqPE7; dfdq_upd_prev_vec_reg_LX_dqPE7 = dfdq_upd_prev_vec_out_LX_dqPE7; dfdq_upd_prev_vec_reg_LY_dqPE7 = dfdq_upd_prev_vec_out_LY_dqPE7; dfdq_upd_prev_vec_reg_LZ_dqPE7 = dfdq_upd_prev_vec_out_LZ_dqPE7; 
      // dqdPE1
      dfdqd_upd_prev_vec_reg_AX_dqdPE1 = dfdqd_upd_prev_vec_out_AX_dqdPE1; dfdqd_upd_prev_vec_reg_AY_dqdPE1 = dfdqd_upd_prev_vec_out_AY_dqdPE1; dfdqd_upd_prev_vec_reg_AZ_dqdPE1 = dfdqd_upd_prev_vec_out_AZ_dqdPE1; dfdqd_upd_prev_vec_reg_LX_dqdPE1 = dfdqd_upd_prev_vec_out_LX_dqdPE1; dfdqd_upd_prev_vec_reg_LY_dqdPE1 = dfdqd_upd_prev_vec_out_LY_dqdPE1; dfdqd_upd_prev_vec_reg_LZ_dqdPE1 = dfdqd_upd_prev_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_prev_vec_reg_AX_dqdPE2 = dfdqd_upd_prev_vec_out_AX_dqdPE2; dfdqd_upd_prev_vec_reg_AY_dqdPE2 = dfdqd_upd_prev_vec_out_AY_dqdPE2; dfdqd_upd_prev_vec_reg_AZ_dqdPE2 = dfdqd_upd_prev_vec_out_AZ_dqdPE2; dfdqd_upd_prev_vec_reg_LX_dqdPE2 = dfdqd_upd_prev_vec_out_LX_dqdPE2; dfdqd_upd_prev_vec_reg_LY_dqdPE2 = dfdqd_upd_prev_vec_out_LY_dqdPE2; dfdqd_upd_prev_vec_reg_LZ_dqdPE2 = dfdqd_upd_prev_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_prev_vec_reg_AX_dqdPE3 = dfdqd_upd_prev_vec_out_AX_dqdPE3; dfdqd_upd_prev_vec_reg_AY_dqdPE3 = dfdqd_upd_prev_vec_out_AY_dqdPE3; dfdqd_upd_prev_vec_reg_AZ_dqdPE3 = dfdqd_upd_prev_vec_out_AZ_dqdPE3; dfdqd_upd_prev_vec_reg_LX_dqdPE3 = dfdqd_upd_prev_vec_out_LX_dqdPE3; dfdqd_upd_prev_vec_reg_LY_dqdPE3 = dfdqd_upd_prev_vec_out_LY_dqdPE3; dfdqd_upd_prev_vec_reg_LZ_dqdPE3 = dfdqd_upd_prev_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_prev_vec_reg_AX_dqdPE4 = dfdqd_upd_prev_vec_out_AX_dqdPE4; dfdqd_upd_prev_vec_reg_AY_dqdPE4 = dfdqd_upd_prev_vec_out_AY_dqdPE4; dfdqd_upd_prev_vec_reg_AZ_dqdPE4 = dfdqd_upd_prev_vec_out_AZ_dqdPE4; dfdqd_upd_prev_vec_reg_LX_dqdPE4 = dfdqd_upd_prev_vec_out_LX_dqdPE4; dfdqd_upd_prev_vec_reg_LY_dqdPE4 = dfdqd_upd_prev_vec_out_LY_dqdPE4; dfdqd_upd_prev_vec_reg_LZ_dqdPE4 = dfdqd_upd_prev_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_prev_vec_reg_AX_dqdPE5 = dfdqd_upd_prev_vec_out_AX_dqdPE5; dfdqd_upd_prev_vec_reg_AY_dqdPE5 = dfdqd_upd_prev_vec_out_AY_dqdPE5; dfdqd_upd_prev_vec_reg_AZ_dqdPE5 = dfdqd_upd_prev_vec_out_AZ_dqdPE5; dfdqd_upd_prev_vec_reg_LX_dqdPE5 = dfdqd_upd_prev_vec_out_LX_dqdPE5; dfdqd_upd_prev_vec_reg_LY_dqdPE5 = dfdqd_upd_prev_vec_out_LY_dqdPE5; dfdqd_upd_prev_vec_reg_LZ_dqdPE5 = dfdqd_upd_prev_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_prev_vec_reg_AX_dqdPE6 = dfdqd_upd_prev_vec_out_AX_dqdPE6; dfdqd_upd_prev_vec_reg_AY_dqdPE6 = dfdqd_upd_prev_vec_out_AY_dqdPE6; dfdqd_upd_prev_vec_reg_AZ_dqdPE6 = dfdqd_upd_prev_vec_out_AZ_dqdPE6; dfdqd_upd_prev_vec_reg_LX_dqdPE6 = dfdqd_upd_prev_vec_out_LX_dqdPE6; dfdqd_upd_prev_vec_reg_LY_dqdPE6 = dfdqd_upd_prev_vec_out_LY_dqdPE6; dfdqd_upd_prev_vec_reg_LZ_dqdPE6 = dfdqd_upd_prev_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_prev_vec_reg_AX_dqdPE7 = dfdqd_upd_prev_vec_out_AX_dqdPE7; dfdqd_upd_prev_vec_reg_AY_dqdPE7 = dfdqd_upd_prev_vec_out_AY_dqdPE7; dfdqd_upd_prev_vec_reg_AZ_dqdPE7 = dfdqd_upd_prev_vec_out_AZ_dqdPE7; dfdqd_upd_prev_vec_reg_LX_dqdPE7 = dfdqd_upd_prev_vec_out_LX_dqdPE7; dfdqd_upd_prev_vec_reg_LY_dqdPE7 = dfdqd_upd_prev_vec_out_LY_dqdPE7; dfdqd_upd_prev_vec_reg_LZ_dqdPE7 = dfdqd_upd_prev_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Link 4 Inputs
      //------------------------------------------------------------------------
      // 3
      minv_prev_vec_in_C1 = 32'd212790; minv_prev_vec_in_C2 = -32'd42572; minv_prev_vec_in_C3 = -32'd2752466; minv_prev_vec_in_C4 = -32'd201513; minv_prev_vec_in_C5 = 32'd2574713; minv_prev_vec_in_C6 = -32'd45311; minv_prev_vec_in_C7 = 32'd12325;
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 4'd4;
      sinq_val_in_rnea = -32'd685; cosq_val_in_rnea = 32'd65532;
      f_prev_vec_in_AX_rnea = -32'd19396; f_prev_vec_in_AY_rnea = 32'd14507; f_prev_vec_in_AZ_rnea = -32'd2366; f_prev_vec_in_LX_rnea = 32'd70323; f_prev_vec_in_LY_rnea = 32'd80557; f_prev_vec_in_LZ_rnea = -32'd22634;
      f_upd_curr_vec_in_AX_rnea = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_rnea = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_rnea = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_rnea = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_rnea = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_rnea = f_upd_prev_vec_reg_LZ_rnea; 
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 4'd4;
      derv_in_dqPE1 = 4'd1;
      sinq_val_in_dqPE1 = -32'd685; cosq_val_in_dqPE1 = 32'd65532;
      f_upd_curr_vec_in_AX_dqPE1 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE1 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE1 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE1 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE1 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE1 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE2
      link_in_dqPE2 = 4'd4;
      derv_in_dqPE2 = 4'd2;
      sinq_val_in_dqPE2 = -32'd685; cosq_val_in_dqPE2 = 32'd65532;
      f_upd_curr_vec_in_AX_dqPE2 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE2 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE2 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE2 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE2 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE2 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE3
      link_in_dqPE3 = 4'd4;
      derv_in_dqPE3 = 4'd3;
      sinq_val_in_dqPE3 = -32'd685; cosq_val_in_dqPE3 = 32'd65532;
      f_upd_curr_vec_in_AX_dqPE3 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE3 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE3 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE3 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE3 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE3 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE4
      link_in_dqPE4 = 4'd4;
      derv_in_dqPE4 = 4'd4;
      sinq_val_in_dqPE4 = -32'd685; cosq_val_in_dqPE4 = 32'd65532;
      f_upd_curr_vec_in_AX_dqPE4 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE4 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE4 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE4 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE4 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE4 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE5
      link_in_dqPE5 = 4'd4;
      derv_in_dqPE5 = 4'd5;
      sinq_val_in_dqPE5 = -32'd685; cosq_val_in_dqPE5 = 32'd65532;
      f_upd_curr_vec_in_AX_dqPE5 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE5 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE5 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE5 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE5 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE5 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE6
      link_in_dqPE6 = 4'd4;
      derv_in_dqPE6 = 4'd6;
      sinq_val_in_dqPE6 = -32'd685; cosq_val_in_dqPE6 = 32'd65532;
      f_upd_curr_vec_in_AX_dqPE6 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE6 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE6 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE6 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE6 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE6 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE7
      link_in_dqPE7 = 4'd4;
      derv_in_dqPE7 = 4'd7;
      sinq_val_in_dqPE7 = -32'd685; cosq_val_in_dqPE7 = 32'd65532;
      f_upd_curr_vec_in_AX_dqPE7 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE7 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE7 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE7 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE7 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE7 = f_upd_prev_vec_reg_LZ_rnea; 
      // External df updated
      // dqPE1
      dfdq_upd_curr_vec_in_AX_dqPE1 = dfdq_upd_prev_vec_reg_AX_dqPE1; dfdq_upd_curr_vec_in_AY_dqPE1 = dfdq_upd_prev_vec_reg_AY_dqPE1; dfdq_upd_curr_vec_in_AZ_dqPE1 = dfdq_upd_prev_vec_reg_AZ_dqPE1; dfdq_upd_curr_vec_in_LX_dqPE1 = dfdq_upd_prev_vec_reg_LX_dqPE1; dfdq_upd_curr_vec_in_LY_dqPE1 = dfdq_upd_prev_vec_reg_LY_dqPE1; dfdq_upd_curr_vec_in_LZ_dqPE1 = dfdq_upd_prev_vec_reg_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_curr_vec_in_AX_dqPE2 = dfdq_upd_prev_vec_reg_AX_dqPE2; dfdq_upd_curr_vec_in_AY_dqPE2 = dfdq_upd_prev_vec_reg_AY_dqPE2; dfdq_upd_curr_vec_in_AZ_dqPE2 = dfdq_upd_prev_vec_reg_AZ_dqPE2; dfdq_upd_curr_vec_in_LX_dqPE2 = dfdq_upd_prev_vec_reg_LX_dqPE2; dfdq_upd_curr_vec_in_LY_dqPE2 = dfdq_upd_prev_vec_reg_LY_dqPE2; dfdq_upd_curr_vec_in_LZ_dqPE2 = dfdq_upd_prev_vec_reg_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_curr_vec_in_AX_dqPE3 = dfdq_upd_prev_vec_reg_AX_dqPE3; dfdq_upd_curr_vec_in_AY_dqPE3 = dfdq_upd_prev_vec_reg_AY_dqPE3; dfdq_upd_curr_vec_in_AZ_dqPE3 = dfdq_upd_prev_vec_reg_AZ_dqPE3; dfdq_upd_curr_vec_in_LX_dqPE3 = dfdq_upd_prev_vec_reg_LX_dqPE3; dfdq_upd_curr_vec_in_LY_dqPE3 = dfdq_upd_prev_vec_reg_LY_dqPE3; dfdq_upd_curr_vec_in_LZ_dqPE3 = dfdq_upd_prev_vec_reg_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_curr_vec_in_AX_dqPE4 = dfdq_upd_prev_vec_reg_AX_dqPE4; dfdq_upd_curr_vec_in_AY_dqPE4 = dfdq_upd_prev_vec_reg_AY_dqPE4; dfdq_upd_curr_vec_in_AZ_dqPE4 = dfdq_upd_prev_vec_reg_AZ_dqPE4; dfdq_upd_curr_vec_in_LX_dqPE4 = dfdq_upd_prev_vec_reg_LX_dqPE4; dfdq_upd_curr_vec_in_LY_dqPE4 = dfdq_upd_prev_vec_reg_LY_dqPE4; dfdq_upd_curr_vec_in_LZ_dqPE4 = dfdq_upd_prev_vec_reg_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_curr_vec_in_AX_dqPE5 = dfdq_upd_prev_vec_reg_AX_dqPE5; dfdq_upd_curr_vec_in_AY_dqPE5 = dfdq_upd_prev_vec_reg_AY_dqPE5; dfdq_upd_curr_vec_in_AZ_dqPE5 = dfdq_upd_prev_vec_reg_AZ_dqPE5; dfdq_upd_curr_vec_in_LX_dqPE5 = dfdq_upd_prev_vec_reg_LX_dqPE5; dfdq_upd_curr_vec_in_LY_dqPE5 = dfdq_upd_prev_vec_reg_LY_dqPE5; dfdq_upd_curr_vec_in_LZ_dqPE5 = dfdq_upd_prev_vec_reg_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_curr_vec_in_AX_dqPE6 = dfdq_upd_prev_vec_reg_AX_dqPE6; dfdq_upd_curr_vec_in_AY_dqPE6 = dfdq_upd_prev_vec_reg_AY_dqPE6; dfdq_upd_curr_vec_in_AZ_dqPE6 = dfdq_upd_prev_vec_reg_AZ_dqPE6; dfdq_upd_curr_vec_in_LX_dqPE6 = dfdq_upd_prev_vec_reg_LX_dqPE6; dfdq_upd_curr_vec_in_LY_dqPE6 = dfdq_upd_prev_vec_reg_LY_dqPE6; dfdq_upd_curr_vec_in_LZ_dqPE6 = dfdq_upd_prev_vec_reg_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_curr_vec_in_AX_dqPE7 = dfdq_upd_prev_vec_reg_AX_dqPE7; dfdq_upd_curr_vec_in_AY_dqPE7 = dfdq_upd_prev_vec_reg_AY_dqPE7; dfdq_upd_curr_vec_in_AZ_dqPE7 = dfdq_upd_prev_vec_reg_AZ_dqPE7; dfdq_upd_curr_vec_in_LX_dqPE7 = dfdq_upd_prev_vec_reg_LX_dqPE7; dfdq_upd_curr_vec_in_LY_dqPE7 = dfdq_upd_prev_vec_reg_LY_dqPE7; dfdq_upd_curr_vec_in_LZ_dqPE7 = dfdq_upd_prev_vec_reg_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 4'd4;
      derv_in_dqdPE7 = 4'd1;
      sinq_val_in_dqdPE1 = -32'd685; cosq_val_in_dqdPE1 = 32'd65532;
      // dqdPE2
      link_in_dqdPE2 = 4'd4;
      derv_in_dqdPE2 = 4'd2;
      sinq_val_in_dqdPE2 = -32'd685; cosq_val_in_dqdPE2 = 32'd65532;
      // dqdPE3
      link_in_dqdPE3 = 4'd4;
      derv_in_dqdPE3 = 4'd3;
      sinq_val_in_dqdPE3 = -32'd685; cosq_val_in_dqdPE3 = 32'd65532;
      // dqdPE4
      link_in_dqdPE4 = 4'd4;
      derv_in_dqdPE4 = 4'd4;
      sinq_val_in_dqdPE4 = -32'd685; cosq_val_in_dqdPE4 = 32'd65532;
      // dqdPE5
      link_in_dqdPE5 = 4'd4;
      derv_in_dqdPE5 = 4'd5;
      sinq_val_in_dqdPE5 = -32'd685; cosq_val_in_dqdPE5 = 32'd65532;
      // dqdPE6
      link_in_dqdPE6 = 4'd4;
      derv_in_dqdPE6 = 4'd6;
      sinq_val_in_dqdPE6 = -32'd685; cosq_val_in_dqdPE6 = 32'd65532;
      // dqdPE7
      link_in_dqdPE7 = 4'd4;
      derv_in_dqdPE7 = 4'd7;
      sinq_val_in_dqdPE7 = -32'd685; cosq_val_in_dqdPE7 = 32'd65532;
      // External df updated
      // dqdPE1
      dfdqd_upd_curr_vec_in_AX_dqdPE1 = dfdqd_upd_prev_vec_reg_AX_dqdPE1; dfdqd_upd_curr_vec_in_AY_dqdPE1 = dfdqd_upd_prev_vec_reg_AY_dqdPE1; dfdqd_upd_curr_vec_in_AZ_dqdPE1 = dfdqd_upd_prev_vec_reg_AZ_dqdPE1; dfdqd_upd_curr_vec_in_LX_dqdPE1 = dfdqd_upd_prev_vec_reg_LX_dqdPE1; dfdqd_upd_curr_vec_in_LY_dqdPE1 = dfdqd_upd_prev_vec_reg_LY_dqdPE1; dfdqd_upd_curr_vec_in_LZ_dqdPE1 = dfdqd_upd_prev_vec_reg_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_curr_vec_in_AX_dqdPE2 = dfdqd_upd_prev_vec_reg_AX_dqdPE2; dfdqd_upd_curr_vec_in_AY_dqdPE2 = dfdqd_upd_prev_vec_reg_AY_dqdPE2; dfdqd_upd_curr_vec_in_AZ_dqdPE2 = dfdqd_upd_prev_vec_reg_AZ_dqdPE2; dfdqd_upd_curr_vec_in_LX_dqdPE2 = dfdqd_upd_prev_vec_reg_LX_dqdPE2; dfdqd_upd_curr_vec_in_LY_dqdPE2 = dfdqd_upd_prev_vec_reg_LY_dqdPE2; dfdqd_upd_curr_vec_in_LZ_dqdPE2 = dfdqd_upd_prev_vec_reg_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_curr_vec_in_AX_dqdPE3 = dfdqd_upd_prev_vec_reg_AX_dqdPE3; dfdqd_upd_curr_vec_in_AY_dqdPE3 = dfdqd_upd_prev_vec_reg_AY_dqdPE3; dfdqd_upd_curr_vec_in_AZ_dqdPE3 = dfdqd_upd_prev_vec_reg_AZ_dqdPE3; dfdqd_upd_curr_vec_in_LX_dqdPE3 = dfdqd_upd_prev_vec_reg_LX_dqdPE3; dfdqd_upd_curr_vec_in_LY_dqdPE3 = dfdqd_upd_prev_vec_reg_LY_dqdPE3; dfdqd_upd_curr_vec_in_LZ_dqdPE3 = dfdqd_upd_prev_vec_reg_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_curr_vec_in_AX_dqdPE4 = dfdqd_upd_prev_vec_reg_AX_dqdPE4; dfdqd_upd_curr_vec_in_AY_dqdPE4 = dfdqd_upd_prev_vec_reg_AY_dqdPE4; dfdqd_upd_curr_vec_in_AZ_dqdPE4 = dfdqd_upd_prev_vec_reg_AZ_dqdPE4; dfdqd_upd_curr_vec_in_LX_dqdPE4 = dfdqd_upd_prev_vec_reg_LX_dqdPE4; dfdqd_upd_curr_vec_in_LY_dqdPE4 = dfdqd_upd_prev_vec_reg_LY_dqdPE4; dfdqd_upd_curr_vec_in_LZ_dqdPE4 = dfdqd_upd_prev_vec_reg_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_curr_vec_in_AX_dqdPE5 = dfdqd_upd_prev_vec_reg_AX_dqdPE5; dfdqd_upd_curr_vec_in_AY_dqdPE5 = dfdqd_upd_prev_vec_reg_AY_dqdPE5; dfdqd_upd_curr_vec_in_AZ_dqdPE5 = dfdqd_upd_prev_vec_reg_AZ_dqdPE5; dfdqd_upd_curr_vec_in_LX_dqdPE5 = dfdqd_upd_prev_vec_reg_LX_dqdPE5; dfdqd_upd_curr_vec_in_LY_dqdPE5 = dfdqd_upd_prev_vec_reg_LY_dqdPE5; dfdqd_upd_curr_vec_in_LZ_dqdPE5 = dfdqd_upd_prev_vec_reg_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_curr_vec_in_AX_dqdPE6 = dfdqd_upd_prev_vec_reg_AX_dqdPE6; dfdqd_upd_curr_vec_in_AY_dqdPE6 = dfdqd_upd_prev_vec_reg_AY_dqdPE6; dfdqd_upd_curr_vec_in_AZ_dqdPE6 = dfdqd_upd_prev_vec_reg_AZ_dqdPE6; dfdqd_upd_curr_vec_in_LX_dqdPE6 = dfdqd_upd_prev_vec_reg_LX_dqdPE6; dfdqd_upd_curr_vec_in_LY_dqdPE6 = dfdqd_upd_prev_vec_reg_LY_dqdPE6; dfdqd_upd_curr_vec_in_LZ_dqdPE6 = dfdqd_upd_prev_vec_reg_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_curr_vec_in_AX_dqdPE7 = dfdqd_upd_prev_vec_reg_AX_dqdPE7; dfdqd_upd_curr_vec_in_AY_dqdPE7 = dfdqd_upd_prev_vec_reg_AY_dqdPE7; dfdqd_upd_curr_vec_in_AZ_dqdPE7 = dfdqd_upd_prev_vec_reg_AZ_dqdPE7; dfdqd_upd_curr_vec_in_LX_dqdPE7 = dfdqd_upd_prev_vec_reg_LX_dqdPE7; dfdqd_upd_curr_vec_in_LY_dqdPE7 = dfdqd_upd_prev_vec_reg_LY_dqdPE7; dfdqd_upd_curr_vec_in_LZ_dqdPE7 = dfdqd_upd_prev_vec_reg_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // df prev external inputs
      //------------------------------------------------------------------------
      dfdq_prev_vec_in_AX_dqPE1 = 32'd0; dfdq_prev_vec_in_AX_dqPE2 = -32'd2621; dfdq_prev_vec_in_AX_dqPE3 = 32'd15599; dfdq_prev_vec_in_AX_dqPE4 = 32'd0; dfdq_prev_vec_in_AX_dqPE5 = 32'd0; dfdq_prev_vec_in_AX_dqPE6 = 32'd0; dfdq_prev_vec_in_AX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AY_dqPE1 = 32'd0; dfdq_prev_vec_in_AY_dqPE2 = -32'd10348; dfdq_prev_vec_in_AY_dqPE3 = 32'd21009; dfdq_prev_vec_in_AY_dqPE4 = 32'd0; dfdq_prev_vec_in_AY_dqPE5 = 32'd0; dfdq_prev_vec_in_AY_dqPE6 = 32'd0; dfdq_prev_vec_in_AY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AZ_dqPE1 = 32'd0; dfdq_prev_vec_in_AZ_dqPE2 = 32'd1137; dfdq_prev_vec_in_AZ_dqPE3 = -32'd2999; dfdq_prev_vec_in_AZ_dqPE4 = 32'd0; dfdq_prev_vec_in_AZ_dqPE5 = 32'd0; dfdq_prev_vec_in_AZ_dqPE6 = 32'd0; dfdq_prev_vec_in_AZ_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LX_dqPE1 = 32'd0; dfdq_prev_vec_in_LX_dqPE2 = -32'd51071; dfdq_prev_vec_in_LX_dqPE3 = 32'd102173; dfdq_prev_vec_in_LX_dqPE4 = 32'd0; dfdq_prev_vec_in_LX_dqPE5 = 32'd0; dfdq_prev_vec_in_LX_dqPE6 = 32'd0; dfdq_prev_vec_in_LX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LY_dqPE1 = 32'd0; dfdq_prev_vec_in_LY_dqPE2 = 32'd1313; dfdq_prev_vec_in_LY_dqPE3 = -32'd68019; dfdq_prev_vec_in_LY_dqPE4 = 32'd0; dfdq_prev_vec_in_LY_dqPE5 = 32'd0; dfdq_prev_vec_in_LY_dqPE6 = 32'd0; dfdq_prev_vec_in_LY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LZ_dqPE1 = 32'd0; dfdq_prev_vec_in_LZ_dqPE2 = -32'd57033; dfdq_prev_vec_in_LZ_dqPE3 = 32'd16263; dfdq_prev_vec_in_LZ_dqPE4 = 32'd0; dfdq_prev_vec_in_LZ_dqPE5 = 32'd0; dfdq_prev_vec_in_LZ_dqPE6 = 32'd0; dfdq_prev_vec_in_LZ_dqPE7 = 32'd0;
      dfdqd_prev_vec_in_AX_dqdPE1 = 32'd1897; dfdqd_prev_vec_in_AX_dqdPE2 = -32'd19915; dfdqd_prev_vec_in_AX_dqdPE3 = 32'd2933; dfdqd_prev_vec_in_AX_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AY_dqdPE1 = -32'd10769; dfdqd_prev_vec_in_AY_dqdPE2 = -32'd13702; dfdqd_prev_vec_in_AY_dqdPE3 = 32'd147; dfdqd_prev_vec_in_AY_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AZ_dqdPE1 = 32'd1521; dfdqd_prev_vec_in_AZ_dqdPE2 = 32'd1936; dfdqd_prev_vec_in_AZ_dqdPE3 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LX_dqdPE1 = -32'd53805; dfdqd_prev_vec_in_LX_dqdPE2 = -32'd68646; dfdqd_prev_vec_in_LX_dqdPE3 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LY_dqdPE1 = -32'd22821; dfdqd_prev_vec_in_LY_dqdPE2 = 32'd97882; dfdqd_prev_vec_in_LY_dqdPE3 = -32'd22583; dfdqd_prev_vec_in_LY_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LZ_dqdPE1 = -32'd23054; dfdqd_prev_vec_in_LZ_dqdPE2 = -32'd23480; dfdqd_prev_vec_in_LZ_dqdPE3 = -32'd22; dfdqd_prev_vec_in_LZ_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
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
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 4 Outputs
      //------------------------------------------------------------------------
      $display ("// Knot 1 Link 4 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, 63224, -120585, -111588, -108248, 2207, 0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 62401, 78973, -998, -329, -2212, -4266, -41);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External f updated prev
      //------------------------------------------------------------------------
      // rnea
      f_upd_prev_vec_reg_AX_rnea = f_upd_prev_vec_out_AX_rnea; f_upd_prev_vec_reg_AY_rnea = f_upd_prev_vec_out_AY_rnea; f_upd_prev_vec_reg_AZ_rnea = f_upd_prev_vec_out_AZ_rnea; f_upd_prev_vec_reg_LX_rnea = f_upd_prev_vec_out_LX_rnea; f_upd_prev_vec_reg_LY_rnea = f_upd_prev_vec_out_LY_rnea; f_upd_prev_vec_reg_LZ_rnea = f_upd_prev_vec_out_LZ_rnea; 
      //------------------------------------------------------------------------
      // External df updated prev
      //------------------------------------------------------------------------
      // dqPE1
      dfdq_upd_prev_vec_reg_AX_dqPE1 = dfdq_upd_prev_vec_out_AX_dqPE1; dfdq_upd_prev_vec_reg_AY_dqPE1 = dfdq_upd_prev_vec_out_AY_dqPE1; dfdq_upd_prev_vec_reg_AZ_dqPE1 = dfdq_upd_prev_vec_out_AZ_dqPE1; dfdq_upd_prev_vec_reg_LX_dqPE1 = dfdq_upd_prev_vec_out_LX_dqPE1; dfdq_upd_prev_vec_reg_LY_dqPE1 = dfdq_upd_prev_vec_out_LY_dqPE1; dfdq_upd_prev_vec_reg_LZ_dqPE1 = dfdq_upd_prev_vec_out_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_prev_vec_reg_AX_dqPE2 = dfdq_upd_prev_vec_out_AX_dqPE2; dfdq_upd_prev_vec_reg_AY_dqPE2 = dfdq_upd_prev_vec_out_AY_dqPE2; dfdq_upd_prev_vec_reg_AZ_dqPE2 = dfdq_upd_prev_vec_out_AZ_dqPE2; dfdq_upd_prev_vec_reg_LX_dqPE2 = dfdq_upd_prev_vec_out_LX_dqPE2; dfdq_upd_prev_vec_reg_LY_dqPE2 = dfdq_upd_prev_vec_out_LY_dqPE2; dfdq_upd_prev_vec_reg_LZ_dqPE2 = dfdq_upd_prev_vec_out_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_prev_vec_reg_AX_dqPE3 = dfdq_upd_prev_vec_out_AX_dqPE3; dfdq_upd_prev_vec_reg_AY_dqPE3 = dfdq_upd_prev_vec_out_AY_dqPE3; dfdq_upd_prev_vec_reg_AZ_dqPE3 = dfdq_upd_prev_vec_out_AZ_dqPE3; dfdq_upd_prev_vec_reg_LX_dqPE3 = dfdq_upd_prev_vec_out_LX_dqPE3; dfdq_upd_prev_vec_reg_LY_dqPE3 = dfdq_upd_prev_vec_out_LY_dqPE3; dfdq_upd_prev_vec_reg_LZ_dqPE3 = dfdq_upd_prev_vec_out_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_prev_vec_reg_AX_dqPE4 = dfdq_upd_prev_vec_out_AX_dqPE4; dfdq_upd_prev_vec_reg_AY_dqPE4 = dfdq_upd_prev_vec_out_AY_dqPE4; dfdq_upd_prev_vec_reg_AZ_dqPE4 = dfdq_upd_prev_vec_out_AZ_dqPE4; dfdq_upd_prev_vec_reg_LX_dqPE4 = dfdq_upd_prev_vec_out_LX_dqPE4; dfdq_upd_prev_vec_reg_LY_dqPE4 = dfdq_upd_prev_vec_out_LY_dqPE4; dfdq_upd_prev_vec_reg_LZ_dqPE4 = dfdq_upd_prev_vec_out_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_prev_vec_reg_AX_dqPE5 = dfdq_upd_prev_vec_out_AX_dqPE5; dfdq_upd_prev_vec_reg_AY_dqPE5 = dfdq_upd_prev_vec_out_AY_dqPE5; dfdq_upd_prev_vec_reg_AZ_dqPE5 = dfdq_upd_prev_vec_out_AZ_dqPE5; dfdq_upd_prev_vec_reg_LX_dqPE5 = dfdq_upd_prev_vec_out_LX_dqPE5; dfdq_upd_prev_vec_reg_LY_dqPE5 = dfdq_upd_prev_vec_out_LY_dqPE5; dfdq_upd_prev_vec_reg_LZ_dqPE5 = dfdq_upd_prev_vec_out_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_prev_vec_reg_AX_dqPE6 = dfdq_upd_prev_vec_out_AX_dqPE6; dfdq_upd_prev_vec_reg_AY_dqPE6 = dfdq_upd_prev_vec_out_AY_dqPE6; dfdq_upd_prev_vec_reg_AZ_dqPE6 = dfdq_upd_prev_vec_out_AZ_dqPE6; dfdq_upd_prev_vec_reg_LX_dqPE6 = dfdq_upd_prev_vec_out_LX_dqPE6; dfdq_upd_prev_vec_reg_LY_dqPE6 = dfdq_upd_prev_vec_out_LY_dqPE6; dfdq_upd_prev_vec_reg_LZ_dqPE6 = dfdq_upd_prev_vec_out_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_prev_vec_reg_AX_dqPE7 = dfdq_upd_prev_vec_out_AX_dqPE7; dfdq_upd_prev_vec_reg_AY_dqPE7 = dfdq_upd_prev_vec_out_AY_dqPE7; dfdq_upd_prev_vec_reg_AZ_dqPE7 = dfdq_upd_prev_vec_out_AZ_dqPE7; dfdq_upd_prev_vec_reg_LX_dqPE7 = dfdq_upd_prev_vec_out_LX_dqPE7; dfdq_upd_prev_vec_reg_LY_dqPE7 = dfdq_upd_prev_vec_out_LY_dqPE7; dfdq_upd_prev_vec_reg_LZ_dqPE7 = dfdq_upd_prev_vec_out_LZ_dqPE7; 
      // dqdPE1
      dfdqd_upd_prev_vec_reg_AX_dqdPE1 = dfdqd_upd_prev_vec_out_AX_dqdPE1; dfdqd_upd_prev_vec_reg_AY_dqdPE1 = dfdqd_upd_prev_vec_out_AY_dqdPE1; dfdqd_upd_prev_vec_reg_AZ_dqdPE1 = dfdqd_upd_prev_vec_out_AZ_dqdPE1; dfdqd_upd_prev_vec_reg_LX_dqdPE1 = dfdqd_upd_prev_vec_out_LX_dqdPE1; dfdqd_upd_prev_vec_reg_LY_dqdPE1 = dfdqd_upd_prev_vec_out_LY_dqdPE1; dfdqd_upd_prev_vec_reg_LZ_dqdPE1 = dfdqd_upd_prev_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_prev_vec_reg_AX_dqdPE2 = dfdqd_upd_prev_vec_out_AX_dqdPE2; dfdqd_upd_prev_vec_reg_AY_dqdPE2 = dfdqd_upd_prev_vec_out_AY_dqdPE2; dfdqd_upd_prev_vec_reg_AZ_dqdPE2 = dfdqd_upd_prev_vec_out_AZ_dqdPE2; dfdqd_upd_prev_vec_reg_LX_dqdPE2 = dfdqd_upd_prev_vec_out_LX_dqdPE2; dfdqd_upd_prev_vec_reg_LY_dqdPE2 = dfdqd_upd_prev_vec_out_LY_dqdPE2; dfdqd_upd_prev_vec_reg_LZ_dqdPE2 = dfdqd_upd_prev_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_prev_vec_reg_AX_dqdPE3 = dfdqd_upd_prev_vec_out_AX_dqdPE3; dfdqd_upd_prev_vec_reg_AY_dqdPE3 = dfdqd_upd_prev_vec_out_AY_dqdPE3; dfdqd_upd_prev_vec_reg_AZ_dqdPE3 = dfdqd_upd_prev_vec_out_AZ_dqdPE3; dfdqd_upd_prev_vec_reg_LX_dqdPE3 = dfdqd_upd_prev_vec_out_LX_dqdPE3; dfdqd_upd_prev_vec_reg_LY_dqdPE3 = dfdqd_upd_prev_vec_out_LY_dqdPE3; dfdqd_upd_prev_vec_reg_LZ_dqdPE3 = dfdqd_upd_prev_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_prev_vec_reg_AX_dqdPE4 = dfdqd_upd_prev_vec_out_AX_dqdPE4; dfdqd_upd_prev_vec_reg_AY_dqdPE4 = dfdqd_upd_prev_vec_out_AY_dqdPE4; dfdqd_upd_prev_vec_reg_AZ_dqdPE4 = dfdqd_upd_prev_vec_out_AZ_dqdPE4; dfdqd_upd_prev_vec_reg_LX_dqdPE4 = dfdqd_upd_prev_vec_out_LX_dqdPE4; dfdqd_upd_prev_vec_reg_LY_dqdPE4 = dfdqd_upd_prev_vec_out_LY_dqdPE4; dfdqd_upd_prev_vec_reg_LZ_dqdPE4 = dfdqd_upd_prev_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_prev_vec_reg_AX_dqdPE5 = dfdqd_upd_prev_vec_out_AX_dqdPE5; dfdqd_upd_prev_vec_reg_AY_dqdPE5 = dfdqd_upd_prev_vec_out_AY_dqdPE5; dfdqd_upd_prev_vec_reg_AZ_dqdPE5 = dfdqd_upd_prev_vec_out_AZ_dqdPE5; dfdqd_upd_prev_vec_reg_LX_dqdPE5 = dfdqd_upd_prev_vec_out_LX_dqdPE5; dfdqd_upd_prev_vec_reg_LY_dqdPE5 = dfdqd_upd_prev_vec_out_LY_dqdPE5; dfdqd_upd_prev_vec_reg_LZ_dqdPE5 = dfdqd_upd_prev_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_prev_vec_reg_AX_dqdPE6 = dfdqd_upd_prev_vec_out_AX_dqdPE6; dfdqd_upd_prev_vec_reg_AY_dqdPE6 = dfdqd_upd_prev_vec_out_AY_dqdPE6; dfdqd_upd_prev_vec_reg_AZ_dqdPE6 = dfdqd_upd_prev_vec_out_AZ_dqdPE6; dfdqd_upd_prev_vec_reg_LX_dqdPE6 = dfdqd_upd_prev_vec_out_LX_dqdPE6; dfdqd_upd_prev_vec_reg_LY_dqdPE6 = dfdqd_upd_prev_vec_out_LY_dqdPE6; dfdqd_upd_prev_vec_reg_LZ_dqdPE6 = dfdqd_upd_prev_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_prev_vec_reg_AX_dqdPE7 = dfdqd_upd_prev_vec_out_AX_dqdPE7; dfdqd_upd_prev_vec_reg_AY_dqdPE7 = dfdqd_upd_prev_vec_out_AY_dqdPE7; dfdqd_upd_prev_vec_reg_AZ_dqdPE7 = dfdqd_upd_prev_vec_out_AZ_dqdPE7; dfdqd_upd_prev_vec_reg_LX_dqdPE7 = dfdqd_upd_prev_vec_out_LX_dqdPE7; dfdqd_upd_prev_vec_reg_LY_dqdPE7 = dfdqd_upd_prev_vec_out_LY_dqdPE7; dfdqd_upd_prev_vec_reg_LZ_dqdPE7 = dfdqd_upd_prev_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Link 3 Inputs
      //------------------------------------------------------------------------
      // 2
      minv_prev_vec_in_C1 = 32'd54563; minv_prev_vec_in_C2 = -32'd53716; minv_prev_vec_in_C3 = -32'd42572; minv_prev_vec_in_C4 = -32'd122649; minv_prev_vec_in_C5 = -32'd19260; minv_prev_vec_in_C6 = -32'd89991; minv_prev_vec_in_C7 = 32'd23027;
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 4'd3;
      sinq_val_in_rnea = -32'd36876; cosq_val_in_rnea = 32'd54177;
      f_prev_vec_in_AX_rnea = 32'd2226; f_prev_vec_in_AY_rnea = -32'd184; f_prev_vec_in_AZ_rnea = 32'd6473; f_prev_vec_in_LX_rnea = -32'd20115; f_prev_vec_in_LY_rnea = -32'd5700; f_prev_vec_in_LZ_rnea = 32'd54;
      f_upd_curr_vec_in_AX_rnea = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_rnea = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_rnea = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_rnea = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_rnea = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_rnea = f_upd_prev_vec_reg_LZ_rnea; 
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 4'd3;
      derv_in_dqPE1 = 4'd1;
      sinq_val_in_dqPE1 = -32'd36876; cosq_val_in_dqPE1 = 32'd54177;
      f_upd_curr_vec_in_AX_dqPE1 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE1 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE1 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE1 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE1 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE1 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE2
      link_in_dqPE2 = 4'd3;
      derv_in_dqPE2 = 4'd2;
      sinq_val_in_dqPE2 = -32'd36876; cosq_val_in_dqPE2 = 32'd54177;
      f_upd_curr_vec_in_AX_dqPE2 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE2 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE2 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE2 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE2 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE2 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE3
      link_in_dqPE3 = 4'd3;
      derv_in_dqPE3 = 4'd3;
      sinq_val_in_dqPE3 = -32'd36876; cosq_val_in_dqPE3 = 32'd54177;
      f_upd_curr_vec_in_AX_dqPE3 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE3 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE3 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE3 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE3 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE3 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE4
      link_in_dqPE4 = 4'd3;
      derv_in_dqPE4 = 4'd4;
      sinq_val_in_dqPE4 = -32'd36876; cosq_val_in_dqPE4 = 32'd54177;
      f_upd_curr_vec_in_AX_dqPE4 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE4 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE4 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE4 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE4 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE4 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE5
      link_in_dqPE5 = 4'd3;
      derv_in_dqPE5 = 4'd5;
      sinq_val_in_dqPE5 = -32'd36876; cosq_val_in_dqPE5 = 32'd54177;
      f_upd_curr_vec_in_AX_dqPE5 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE5 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE5 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE5 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE5 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE5 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE6
      link_in_dqPE6 = 4'd3;
      derv_in_dqPE6 = 4'd6;
      sinq_val_in_dqPE6 = -32'd36876; cosq_val_in_dqPE6 = 32'd54177;
      f_upd_curr_vec_in_AX_dqPE6 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE6 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE6 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE6 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE6 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE6 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE7
      link_in_dqPE7 = 4'd3;
      derv_in_dqPE7 = 4'd7;
      sinq_val_in_dqPE7 = -32'd36876; cosq_val_in_dqPE7 = 32'd54177;
      f_upd_curr_vec_in_AX_dqPE7 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE7 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE7 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE7 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE7 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE7 = f_upd_prev_vec_reg_LZ_rnea; 
      // External df updated
      // dqPE1
      dfdq_upd_curr_vec_in_AX_dqPE1 = dfdq_upd_prev_vec_reg_AX_dqPE1; dfdq_upd_curr_vec_in_AY_dqPE1 = dfdq_upd_prev_vec_reg_AY_dqPE1; dfdq_upd_curr_vec_in_AZ_dqPE1 = dfdq_upd_prev_vec_reg_AZ_dqPE1; dfdq_upd_curr_vec_in_LX_dqPE1 = dfdq_upd_prev_vec_reg_LX_dqPE1; dfdq_upd_curr_vec_in_LY_dqPE1 = dfdq_upd_prev_vec_reg_LY_dqPE1; dfdq_upd_curr_vec_in_LZ_dqPE1 = dfdq_upd_prev_vec_reg_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_curr_vec_in_AX_dqPE2 = dfdq_upd_prev_vec_reg_AX_dqPE2; dfdq_upd_curr_vec_in_AY_dqPE2 = dfdq_upd_prev_vec_reg_AY_dqPE2; dfdq_upd_curr_vec_in_AZ_dqPE2 = dfdq_upd_prev_vec_reg_AZ_dqPE2; dfdq_upd_curr_vec_in_LX_dqPE2 = dfdq_upd_prev_vec_reg_LX_dqPE2; dfdq_upd_curr_vec_in_LY_dqPE2 = dfdq_upd_prev_vec_reg_LY_dqPE2; dfdq_upd_curr_vec_in_LZ_dqPE2 = dfdq_upd_prev_vec_reg_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_curr_vec_in_AX_dqPE3 = dfdq_upd_prev_vec_reg_AX_dqPE3; dfdq_upd_curr_vec_in_AY_dqPE3 = dfdq_upd_prev_vec_reg_AY_dqPE3; dfdq_upd_curr_vec_in_AZ_dqPE3 = dfdq_upd_prev_vec_reg_AZ_dqPE3; dfdq_upd_curr_vec_in_LX_dqPE3 = dfdq_upd_prev_vec_reg_LX_dqPE3; dfdq_upd_curr_vec_in_LY_dqPE3 = dfdq_upd_prev_vec_reg_LY_dqPE3; dfdq_upd_curr_vec_in_LZ_dqPE3 = dfdq_upd_prev_vec_reg_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_curr_vec_in_AX_dqPE4 = dfdq_upd_prev_vec_reg_AX_dqPE4; dfdq_upd_curr_vec_in_AY_dqPE4 = dfdq_upd_prev_vec_reg_AY_dqPE4; dfdq_upd_curr_vec_in_AZ_dqPE4 = dfdq_upd_prev_vec_reg_AZ_dqPE4; dfdq_upd_curr_vec_in_LX_dqPE4 = dfdq_upd_prev_vec_reg_LX_dqPE4; dfdq_upd_curr_vec_in_LY_dqPE4 = dfdq_upd_prev_vec_reg_LY_dqPE4; dfdq_upd_curr_vec_in_LZ_dqPE4 = dfdq_upd_prev_vec_reg_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_curr_vec_in_AX_dqPE5 = dfdq_upd_prev_vec_reg_AX_dqPE5; dfdq_upd_curr_vec_in_AY_dqPE5 = dfdq_upd_prev_vec_reg_AY_dqPE5; dfdq_upd_curr_vec_in_AZ_dqPE5 = dfdq_upd_prev_vec_reg_AZ_dqPE5; dfdq_upd_curr_vec_in_LX_dqPE5 = dfdq_upd_prev_vec_reg_LX_dqPE5; dfdq_upd_curr_vec_in_LY_dqPE5 = dfdq_upd_prev_vec_reg_LY_dqPE5; dfdq_upd_curr_vec_in_LZ_dqPE5 = dfdq_upd_prev_vec_reg_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_curr_vec_in_AX_dqPE6 = dfdq_upd_prev_vec_reg_AX_dqPE6; dfdq_upd_curr_vec_in_AY_dqPE6 = dfdq_upd_prev_vec_reg_AY_dqPE6; dfdq_upd_curr_vec_in_AZ_dqPE6 = dfdq_upd_prev_vec_reg_AZ_dqPE6; dfdq_upd_curr_vec_in_LX_dqPE6 = dfdq_upd_prev_vec_reg_LX_dqPE6; dfdq_upd_curr_vec_in_LY_dqPE6 = dfdq_upd_prev_vec_reg_LY_dqPE6; dfdq_upd_curr_vec_in_LZ_dqPE6 = dfdq_upd_prev_vec_reg_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_curr_vec_in_AX_dqPE7 = dfdq_upd_prev_vec_reg_AX_dqPE7; dfdq_upd_curr_vec_in_AY_dqPE7 = dfdq_upd_prev_vec_reg_AY_dqPE7; dfdq_upd_curr_vec_in_AZ_dqPE7 = dfdq_upd_prev_vec_reg_AZ_dqPE7; dfdq_upd_curr_vec_in_LX_dqPE7 = dfdq_upd_prev_vec_reg_LX_dqPE7; dfdq_upd_curr_vec_in_LY_dqPE7 = dfdq_upd_prev_vec_reg_LY_dqPE7; dfdq_upd_curr_vec_in_LZ_dqPE7 = dfdq_upd_prev_vec_reg_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 4'd3;
      derv_in_dqdPE7 = 4'd1;
      sinq_val_in_dqdPE1 = -32'd36876; cosq_val_in_dqdPE1 = 32'd54177;
      // dqdPE2
      link_in_dqdPE2 = 4'd3;
      derv_in_dqdPE2 = 4'd2;
      sinq_val_in_dqdPE2 = -32'd36876; cosq_val_in_dqdPE2 = 32'd54177;
      // dqdPE3
      link_in_dqdPE3 = 4'd3;
      derv_in_dqdPE3 = 4'd3;
      sinq_val_in_dqdPE3 = -32'd36876; cosq_val_in_dqdPE3 = 32'd54177;
      // dqdPE4
      link_in_dqdPE4 = 4'd3;
      derv_in_dqdPE4 = 4'd4;
      sinq_val_in_dqdPE4 = -32'd36876; cosq_val_in_dqdPE4 = 32'd54177;
      // dqdPE5
      link_in_dqdPE5 = 4'd3;
      derv_in_dqdPE5 = 4'd5;
      sinq_val_in_dqdPE5 = -32'd36876; cosq_val_in_dqdPE5 = 32'd54177;
      // dqdPE6
      link_in_dqdPE6 = 4'd3;
      derv_in_dqdPE6 = 4'd6;
      sinq_val_in_dqdPE6 = -32'd36876; cosq_val_in_dqdPE6 = 32'd54177;
      // dqdPE7
      link_in_dqdPE7 = 4'd3;
      derv_in_dqdPE7 = 4'd7;
      sinq_val_in_dqdPE7 = -32'd36876; cosq_val_in_dqdPE7 = 32'd54177;
      // External df updated
      // dqdPE1
      dfdqd_upd_curr_vec_in_AX_dqdPE1 = dfdqd_upd_prev_vec_reg_AX_dqdPE1; dfdqd_upd_curr_vec_in_AY_dqdPE1 = dfdqd_upd_prev_vec_reg_AY_dqdPE1; dfdqd_upd_curr_vec_in_AZ_dqdPE1 = dfdqd_upd_prev_vec_reg_AZ_dqdPE1; dfdqd_upd_curr_vec_in_LX_dqdPE1 = dfdqd_upd_prev_vec_reg_LX_dqdPE1; dfdqd_upd_curr_vec_in_LY_dqdPE1 = dfdqd_upd_prev_vec_reg_LY_dqdPE1; dfdqd_upd_curr_vec_in_LZ_dqdPE1 = dfdqd_upd_prev_vec_reg_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_curr_vec_in_AX_dqdPE2 = dfdqd_upd_prev_vec_reg_AX_dqdPE2; dfdqd_upd_curr_vec_in_AY_dqdPE2 = dfdqd_upd_prev_vec_reg_AY_dqdPE2; dfdqd_upd_curr_vec_in_AZ_dqdPE2 = dfdqd_upd_prev_vec_reg_AZ_dqdPE2; dfdqd_upd_curr_vec_in_LX_dqdPE2 = dfdqd_upd_prev_vec_reg_LX_dqdPE2; dfdqd_upd_curr_vec_in_LY_dqdPE2 = dfdqd_upd_prev_vec_reg_LY_dqdPE2; dfdqd_upd_curr_vec_in_LZ_dqdPE2 = dfdqd_upd_prev_vec_reg_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_curr_vec_in_AX_dqdPE3 = dfdqd_upd_prev_vec_reg_AX_dqdPE3; dfdqd_upd_curr_vec_in_AY_dqdPE3 = dfdqd_upd_prev_vec_reg_AY_dqdPE3; dfdqd_upd_curr_vec_in_AZ_dqdPE3 = dfdqd_upd_prev_vec_reg_AZ_dqdPE3; dfdqd_upd_curr_vec_in_LX_dqdPE3 = dfdqd_upd_prev_vec_reg_LX_dqdPE3; dfdqd_upd_curr_vec_in_LY_dqdPE3 = dfdqd_upd_prev_vec_reg_LY_dqdPE3; dfdqd_upd_curr_vec_in_LZ_dqdPE3 = dfdqd_upd_prev_vec_reg_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_curr_vec_in_AX_dqdPE4 = dfdqd_upd_prev_vec_reg_AX_dqdPE4; dfdqd_upd_curr_vec_in_AY_dqdPE4 = dfdqd_upd_prev_vec_reg_AY_dqdPE4; dfdqd_upd_curr_vec_in_AZ_dqdPE4 = dfdqd_upd_prev_vec_reg_AZ_dqdPE4; dfdqd_upd_curr_vec_in_LX_dqdPE4 = dfdqd_upd_prev_vec_reg_LX_dqdPE4; dfdqd_upd_curr_vec_in_LY_dqdPE4 = dfdqd_upd_prev_vec_reg_LY_dqdPE4; dfdqd_upd_curr_vec_in_LZ_dqdPE4 = dfdqd_upd_prev_vec_reg_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_curr_vec_in_AX_dqdPE5 = dfdqd_upd_prev_vec_reg_AX_dqdPE5; dfdqd_upd_curr_vec_in_AY_dqdPE5 = dfdqd_upd_prev_vec_reg_AY_dqdPE5; dfdqd_upd_curr_vec_in_AZ_dqdPE5 = dfdqd_upd_prev_vec_reg_AZ_dqdPE5; dfdqd_upd_curr_vec_in_LX_dqdPE5 = dfdqd_upd_prev_vec_reg_LX_dqdPE5; dfdqd_upd_curr_vec_in_LY_dqdPE5 = dfdqd_upd_prev_vec_reg_LY_dqdPE5; dfdqd_upd_curr_vec_in_LZ_dqdPE5 = dfdqd_upd_prev_vec_reg_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_curr_vec_in_AX_dqdPE6 = dfdqd_upd_prev_vec_reg_AX_dqdPE6; dfdqd_upd_curr_vec_in_AY_dqdPE6 = dfdqd_upd_prev_vec_reg_AY_dqdPE6; dfdqd_upd_curr_vec_in_AZ_dqdPE6 = dfdqd_upd_prev_vec_reg_AZ_dqdPE6; dfdqd_upd_curr_vec_in_LX_dqdPE6 = dfdqd_upd_prev_vec_reg_LX_dqdPE6; dfdqd_upd_curr_vec_in_LY_dqdPE6 = dfdqd_upd_prev_vec_reg_LY_dqdPE6; dfdqd_upd_curr_vec_in_LZ_dqdPE6 = dfdqd_upd_prev_vec_reg_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_curr_vec_in_AX_dqdPE7 = dfdqd_upd_prev_vec_reg_AX_dqdPE7; dfdqd_upd_curr_vec_in_AY_dqdPE7 = dfdqd_upd_prev_vec_reg_AY_dqdPE7; dfdqd_upd_curr_vec_in_AZ_dqdPE7 = dfdqd_upd_prev_vec_reg_AZ_dqdPE7; dfdqd_upd_curr_vec_in_LX_dqdPE7 = dfdqd_upd_prev_vec_reg_LX_dqdPE7; dfdqd_upd_curr_vec_in_LY_dqdPE7 = dfdqd_upd_prev_vec_reg_LY_dqdPE7; dfdqd_upd_curr_vec_in_LZ_dqdPE7 = dfdqd_upd_prev_vec_reg_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // df prev external inputs
      //------------------------------------------------------------------------
      dfdq_prev_vec_in_AX_dqPE1 = 32'd0; dfdq_prev_vec_in_AX_dqPE2 = 32'd2709; dfdq_prev_vec_in_AX_dqPE3 = 32'd0; dfdq_prev_vec_in_AX_dqPE4 = 32'd0; dfdq_prev_vec_in_AX_dqPE5 = 32'd0; dfdq_prev_vec_in_AX_dqPE6 = 32'd0; dfdq_prev_vec_in_AX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AY_dqPE1 = 32'd0; dfdq_prev_vec_in_AY_dqPE2 = -32'd126; dfdq_prev_vec_in_AY_dqPE3 = 32'd0; dfdq_prev_vec_in_AY_dqPE4 = 32'd0; dfdq_prev_vec_in_AY_dqPE5 = 32'd0; dfdq_prev_vec_in_AY_dqPE6 = 32'd0; dfdq_prev_vec_in_AY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AZ_dqPE1 = 32'd0; dfdq_prev_vec_in_AZ_dqPE2 = -32'd2017; dfdq_prev_vec_in_AZ_dqPE3 = 32'd0; dfdq_prev_vec_in_AZ_dqPE4 = 32'd0; dfdq_prev_vec_in_AZ_dqPE5 = 32'd0; dfdq_prev_vec_in_AZ_dqPE6 = 32'd0; dfdq_prev_vec_in_AZ_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LX_dqPE1 = 32'd0; dfdq_prev_vec_in_LX_dqPE2 = 32'd8454; dfdq_prev_vec_in_LX_dqPE3 = 32'd0; dfdq_prev_vec_in_LX_dqPE4 = 32'd0; dfdq_prev_vec_in_LX_dqPE5 = 32'd0; dfdq_prev_vec_in_LX_dqPE6 = 32'd0; dfdq_prev_vec_in_LX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LY_dqPE1 = 32'd0; dfdq_prev_vec_in_LY_dqPE2 = -32'd17508; dfdq_prev_vec_in_LY_dqPE3 = 32'd0; dfdq_prev_vec_in_LY_dqPE4 = 32'd0; dfdq_prev_vec_in_LY_dqPE5 = 32'd0; dfdq_prev_vec_in_LY_dqPE6 = 32'd0; dfdq_prev_vec_in_LY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LZ_dqPE1 = 32'd0; dfdq_prev_vec_in_LZ_dqPE2 = 32'd6786; dfdq_prev_vec_in_LZ_dqPE3 = 32'd0; dfdq_prev_vec_in_LZ_dqPE4 = 32'd0; dfdq_prev_vec_in_LZ_dqPE5 = 32'd0; dfdq_prev_vec_in_LZ_dqPE6 = 32'd0; dfdq_prev_vec_in_LZ_dqPE7 = 32'd0;
      dfdqd_prev_vec_in_AX_dqdPE1 = 32'd469; dfdqd_prev_vec_in_AX_dqdPE2 = 32'd6644; dfdqd_prev_vec_in_AX_dqdPE3 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AY_dqdPE1 = 32'd375; dfdqd_prev_vec_in_AY_dqdPE2 = -32'd304; dfdqd_prev_vec_in_AY_dqdPE3 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AZ_dqdPE1 = -32'd2077; dfdqd_prev_vec_in_AZ_dqdPE2 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE3 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LX_dqdPE1 = 32'd10572; dfdqd_prev_vec_in_LX_dqdPE2 = -32'd40; dfdqd_prev_vec_in_LX_dqdPE3 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LY_dqdPE1 = -32'd4252; dfdqd_prev_vec_in_LY_dqdPE2 = -32'd7785; dfdqd_prev_vec_in_LY_dqdPE3 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LZ_dqdPE1 = -32'd14781; dfdqd_prev_vec_in_LZ_dqdPE2 = 32'd28755; dfdqd_prev_vec_in_LZ_dqdPE3 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
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
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 3 Outputs
      //------------------------------------------------------------------------
      $display ("// Knot 1 Link 3 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -2815, 3863, 65192, 1562, 1956, -0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -2181, -2958, -75, 248, 116, 456, 6);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External f updated prev
      //------------------------------------------------------------------------
      // rnea
      f_upd_prev_vec_reg_AX_rnea = f_upd_prev_vec_out_AX_rnea; f_upd_prev_vec_reg_AY_rnea = f_upd_prev_vec_out_AY_rnea; f_upd_prev_vec_reg_AZ_rnea = f_upd_prev_vec_out_AZ_rnea; f_upd_prev_vec_reg_LX_rnea = f_upd_prev_vec_out_LX_rnea; f_upd_prev_vec_reg_LY_rnea = f_upd_prev_vec_out_LY_rnea; f_upd_prev_vec_reg_LZ_rnea = f_upd_prev_vec_out_LZ_rnea; 
      //------------------------------------------------------------------------
      // External df updated prev
      //------------------------------------------------------------------------
      // dqPE1
      dfdq_upd_prev_vec_reg_AX_dqPE1 = dfdq_upd_prev_vec_out_AX_dqPE1; dfdq_upd_prev_vec_reg_AY_dqPE1 = dfdq_upd_prev_vec_out_AY_dqPE1; dfdq_upd_prev_vec_reg_AZ_dqPE1 = dfdq_upd_prev_vec_out_AZ_dqPE1; dfdq_upd_prev_vec_reg_LX_dqPE1 = dfdq_upd_prev_vec_out_LX_dqPE1; dfdq_upd_prev_vec_reg_LY_dqPE1 = dfdq_upd_prev_vec_out_LY_dqPE1; dfdq_upd_prev_vec_reg_LZ_dqPE1 = dfdq_upd_prev_vec_out_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_prev_vec_reg_AX_dqPE2 = dfdq_upd_prev_vec_out_AX_dqPE2; dfdq_upd_prev_vec_reg_AY_dqPE2 = dfdq_upd_prev_vec_out_AY_dqPE2; dfdq_upd_prev_vec_reg_AZ_dqPE2 = dfdq_upd_prev_vec_out_AZ_dqPE2; dfdq_upd_prev_vec_reg_LX_dqPE2 = dfdq_upd_prev_vec_out_LX_dqPE2; dfdq_upd_prev_vec_reg_LY_dqPE2 = dfdq_upd_prev_vec_out_LY_dqPE2; dfdq_upd_prev_vec_reg_LZ_dqPE2 = dfdq_upd_prev_vec_out_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_prev_vec_reg_AX_dqPE3 = dfdq_upd_prev_vec_out_AX_dqPE3; dfdq_upd_prev_vec_reg_AY_dqPE3 = dfdq_upd_prev_vec_out_AY_dqPE3; dfdq_upd_prev_vec_reg_AZ_dqPE3 = dfdq_upd_prev_vec_out_AZ_dqPE3; dfdq_upd_prev_vec_reg_LX_dqPE3 = dfdq_upd_prev_vec_out_LX_dqPE3; dfdq_upd_prev_vec_reg_LY_dqPE3 = dfdq_upd_prev_vec_out_LY_dqPE3; dfdq_upd_prev_vec_reg_LZ_dqPE3 = dfdq_upd_prev_vec_out_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_prev_vec_reg_AX_dqPE4 = dfdq_upd_prev_vec_out_AX_dqPE4; dfdq_upd_prev_vec_reg_AY_dqPE4 = dfdq_upd_prev_vec_out_AY_dqPE4; dfdq_upd_prev_vec_reg_AZ_dqPE4 = dfdq_upd_prev_vec_out_AZ_dqPE4; dfdq_upd_prev_vec_reg_LX_dqPE4 = dfdq_upd_prev_vec_out_LX_dqPE4; dfdq_upd_prev_vec_reg_LY_dqPE4 = dfdq_upd_prev_vec_out_LY_dqPE4; dfdq_upd_prev_vec_reg_LZ_dqPE4 = dfdq_upd_prev_vec_out_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_prev_vec_reg_AX_dqPE5 = dfdq_upd_prev_vec_out_AX_dqPE5; dfdq_upd_prev_vec_reg_AY_dqPE5 = dfdq_upd_prev_vec_out_AY_dqPE5; dfdq_upd_prev_vec_reg_AZ_dqPE5 = dfdq_upd_prev_vec_out_AZ_dqPE5; dfdq_upd_prev_vec_reg_LX_dqPE5 = dfdq_upd_prev_vec_out_LX_dqPE5; dfdq_upd_prev_vec_reg_LY_dqPE5 = dfdq_upd_prev_vec_out_LY_dqPE5; dfdq_upd_prev_vec_reg_LZ_dqPE5 = dfdq_upd_prev_vec_out_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_prev_vec_reg_AX_dqPE6 = dfdq_upd_prev_vec_out_AX_dqPE6; dfdq_upd_prev_vec_reg_AY_dqPE6 = dfdq_upd_prev_vec_out_AY_dqPE6; dfdq_upd_prev_vec_reg_AZ_dqPE6 = dfdq_upd_prev_vec_out_AZ_dqPE6; dfdq_upd_prev_vec_reg_LX_dqPE6 = dfdq_upd_prev_vec_out_LX_dqPE6; dfdq_upd_prev_vec_reg_LY_dqPE6 = dfdq_upd_prev_vec_out_LY_dqPE6; dfdq_upd_prev_vec_reg_LZ_dqPE6 = dfdq_upd_prev_vec_out_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_prev_vec_reg_AX_dqPE7 = dfdq_upd_prev_vec_out_AX_dqPE7; dfdq_upd_prev_vec_reg_AY_dqPE7 = dfdq_upd_prev_vec_out_AY_dqPE7; dfdq_upd_prev_vec_reg_AZ_dqPE7 = dfdq_upd_prev_vec_out_AZ_dqPE7; dfdq_upd_prev_vec_reg_LX_dqPE7 = dfdq_upd_prev_vec_out_LX_dqPE7; dfdq_upd_prev_vec_reg_LY_dqPE7 = dfdq_upd_prev_vec_out_LY_dqPE7; dfdq_upd_prev_vec_reg_LZ_dqPE7 = dfdq_upd_prev_vec_out_LZ_dqPE7; 
      // dqdPE1
      dfdqd_upd_prev_vec_reg_AX_dqdPE1 = dfdqd_upd_prev_vec_out_AX_dqdPE1; dfdqd_upd_prev_vec_reg_AY_dqdPE1 = dfdqd_upd_prev_vec_out_AY_dqdPE1; dfdqd_upd_prev_vec_reg_AZ_dqdPE1 = dfdqd_upd_prev_vec_out_AZ_dqdPE1; dfdqd_upd_prev_vec_reg_LX_dqdPE1 = dfdqd_upd_prev_vec_out_LX_dqdPE1; dfdqd_upd_prev_vec_reg_LY_dqdPE1 = dfdqd_upd_prev_vec_out_LY_dqdPE1; dfdqd_upd_prev_vec_reg_LZ_dqdPE1 = dfdqd_upd_prev_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_prev_vec_reg_AX_dqdPE2 = dfdqd_upd_prev_vec_out_AX_dqdPE2; dfdqd_upd_prev_vec_reg_AY_dqdPE2 = dfdqd_upd_prev_vec_out_AY_dqdPE2; dfdqd_upd_prev_vec_reg_AZ_dqdPE2 = dfdqd_upd_prev_vec_out_AZ_dqdPE2; dfdqd_upd_prev_vec_reg_LX_dqdPE2 = dfdqd_upd_prev_vec_out_LX_dqdPE2; dfdqd_upd_prev_vec_reg_LY_dqdPE2 = dfdqd_upd_prev_vec_out_LY_dqdPE2; dfdqd_upd_prev_vec_reg_LZ_dqdPE2 = dfdqd_upd_prev_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_prev_vec_reg_AX_dqdPE3 = dfdqd_upd_prev_vec_out_AX_dqdPE3; dfdqd_upd_prev_vec_reg_AY_dqdPE3 = dfdqd_upd_prev_vec_out_AY_dqdPE3; dfdqd_upd_prev_vec_reg_AZ_dqdPE3 = dfdqd_upd_prev_vec_out_AZ_dqdPE3; dfdqd_upd_prev_vec_reg_LX_dqdPE3 = dfdqd_upd_prev_vec_out_LX_dqdPE3; dfdqd_upd_prev_vec_reg_LY_dqdPE3 = dfdqd_upd_prev_vec_out_LY_dqdPE3; dfdqd_upd_prev_vec_reg_LZ_dqdPE3 = dfdqd_upd_prev_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_prev_vec_reg_AX_dqdPE4 = dfdqd_upd_prev_vec_out_AX_dqdPE4; dfdqd_upd_prev_vec_reg_AY_dqdPE4 = dfdqd_upd_prev_vec_out_AY_dqdPE4; dfdqd_upd_prev_vec_reg_AZ_dqdPE4 = dfdqd_upd_prev_vec_out_AZ_dqdPE4; dfdqd_upd_prev_vec_reg_LX_dqdPE4 = dfdqd_upd_prev_vec_out_LX_dqdPE4; dfdqd_upd_prev_vec_reg_LY_dqdPE4 = dfdqd_upd_prev_vec_out_LY_dqdPE4; dfdqd_upd_prev_vec_reg_LZ_dqdPE4 = dfdqd_upd_prev_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_prev_vec_reg_AX_dqdPE5 = dfdqd_upd_prev_vec_out_AX_dqdPE5; dfdqd_upd_prev_vec_reg_AY_dqdPE5 = dfdqd_upd_prev_vec_out_AY_dqdPE5; dfdqd_upd_prev_vec_reg_AZ_dqdPE5 = dfdqd_upd_prev_vec_out_AZ_dqdPE5; dfdqd_upd_prev_vec_reg_LX_dqdPE5 = dfdqd_upd_prev_vec_out_LX_dqdPE5; dfdqd_upd_prev_vec_reg_LY_dqdPE5 = dfdqd_upd_prev_vec_out_LY_dqdPE5; dfdqd_upd_prev_vec_reg_LZ_dqdPE5 = dfdqd_upd_prev_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_prev_vec_reg_AX_dqdPE6 = dfdqd_upd_prev_vec_out_AX_dqdPE6; dfdqd_upd_prev_vec_reg_AY_dqdPE6 = dfdqd_upd_prev_vec_out_AY_dqdPE6; dfdqd_upd_prev_vec_reg_AZ_dqdPE6 = dfdqd_upd_prev_vec_out_AZ_dqdPE6; dfdqd_upd_prev_vec_reg_LX_dqdPE6 = dfdqd_upd_prev_vec_out_LX_dqdPE6; dfdqd_upd_prev_vec_reg_LY_dqdPE6 = dfdqd_upd_prev_vec_out_LY_dqdPE6; dfdqd_upd_prev_vec_reg_LZ_dqdPE6 = dfdqd_upd_prev_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_prev_vec_reg_AX_dqdPE7 = dfdqd_upd_prev_vec_out_AX_dqdPE7; dfdqd_upd_prev_vec_reg_AY_dqdPE7 = dfdqd_upd_prev_vec_out_AY_dqdPE7; dfdqd_upd_prev_vec_reg_AZ_dqdPE7 = dfdqd_upd_prev_vec_out_AZ_dqdPE7; dfdqd_upd_prev_vec_reg_LX_dqdPE7 = dfdqd_upd_prev_vec_out_LX_dqdPE7; dfdqd_upd_prev_vec_reg_LY_dqdPE7 = dfdqd_upd_prev_vec_out_LY_dqdPE7; dfdqd_upd_prev_vec_reg_LZ_dqdPE7 = dfdqd_upd_prev_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Link 2 Inputs
      //------------------------------------------------------------------------
      // 1
      minv_prev_vec_in_C1 = -32'd216819; minv_prev_vec_in_C2 = 32'd54563; minv_prev_vec_in_C3 = 32'd212790; minv_prev_vec_in_C4 = 32'd193436; minv_prev_vec_in_C5 = -32'd66476; minv_prev_vec_in_C6 = -32'd25864; minv_prev_vec_in_C7 = 32'd21064;
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 4'd2;
      sinq_val_in_rnea = 32'd24454; cosq_val_in_rnea = 32'd60803;
      f_prev_vec_in_AX_rnea = -32'd944; f_prev_vec_in_AY_rnea = 32'd634; f_prev_vec_in_AZ_rnea = 32'd1038; f_prev_vec_in_LX_rnea = 32'd5280; f_prev_vec_in_LY_rnea = 32'd7863; f_prev_vec_in_LZ_rnea = 32'd0;
      f_upd_curr_vec_in_AX_rnea = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_rnea = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_rnea = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_rnea = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_rnea = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_rnea = f_upd_prev_vec_reg_LZ_rnea; 
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 4'd2;
      derv_in_dqPE1 = 4'd1;
      sinq_val_in_dqPE1 = 32'd24454; cosq_val_in_dqPE1 = 32'd60803;
      f_upd_curr_vec_in_AX_dqPE1 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE1 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE1 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE1 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE1 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE1 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE2
      link_in_dqPE2 = 4'd2;
      derv_in_dqPE2 = 4'd2;
      sinq_val_in_dqPE2 = 32'd24454; cosq_val_in_dqPE2 = 32'd60803;
      f_upd_curr_vec_in_AX_dqPE2 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE2 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE2 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE2 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE2 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE2 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE3
      link_in_dqPE3 = 4'd2;
      derv_in_dqPE3 = 4'd3;
      sinq_val_in_dqPE3 = 32'd24454; cosq_val_in_dqPE3 = 32'd60803;
      f_upd_curr_vec_in_AX_dqPE3 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE3 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE3 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE3 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE3 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE3 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE4
      link_in_dqPE4 = 4'd2;
      derv_in_dqPE4 = 4'd4;
      sinq_val_in_dqPE4 = 32'd24454; cosq_val_in_dqPE4 = 32'd60803;
      f_upd_curr_vec_in_AX_dqPE4 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE4 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE4 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE4 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE4 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE4 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE5
      link_in_dqPE5 = 4'd2;
      derv_in_dqPE5 = 4'd5;
      sinq_val_in_dqPE5 = 32'd24454; cosq_val_in_dqPE5 = 32'd60803;
      f_upd_curr_vec_in_AX_dqPE5 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE5 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE5 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE5 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE5 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE5 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE6
      link_in_dqPE6 = 4'd2;
      derv_in_dqPE6 = 4'd6;
      sinq_val_in_dqPE6 = 32'd24454; cosq_val_in_dqPE6 = 32'd60803;
      f_upd_curr_vec_in_AX_dqPE6 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE6 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE6 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE6 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE6 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE6 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE7
      link_in_dqPE7 = 4'd2;
      derv_in_dqPE7 = 4'd7;
      sinq_val_in_dqPE7 = 32'd24454; cosq_val_in_dqPE7 = 32'd60803;
      f_upd_curr_vec_in_AX_dqPE7 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE7 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE7 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE7 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE7 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE7 = f_upd_prev_vec_reg_LZ_rnea; 
      // External df updated
      // dqPE1
      dfdq_upd_curr_vec_in_AX_dqPE1 = dfdq_upd_prev_vec_reg_AX_dqPE1; dfdq_upd_curr_vec_in_AY_dqPE1 = dfdq_upd_prev_vec_reg_AY_dqPE1; dfdq_upd_curr_vec_in_AZ_dqPE1 = dfdq_upd_prev_vec_reg_AZ_dqPE1; dfdq_upd_curr_vec_in_LX_dqPE1 = dfdq_upd_prev_vec_reg_LX_dqPE1; dfdq_upd_curr_vec_in_LY_dqPE1 = dfdq_upd_prev_vec_reg_LY_dqPE1; dfdq_upd_curr_vec_in_LZ_dqPE1 = dfdq_upd_prev_vec_reg_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_curr_vec_in_AX_dqPE2 = dfdq_upd_prev_vec_reg_AX_dqPE2; dfdq_upd_curr_vec_in_AY_dqPE2 = dfdq_upd_prev_vec_reg_AY_dqPE2; dfdq_upd_curr_vec_in_AZ_dqPE2 = dfdq_upd_prev_vec_reg_AZ_dqPE2; dfdq_upd_curr_vec_in_LX_dqPE2 = dfdq_upd_prev_vec_reg_LX_dqPE2; dfdq_upd_curr_vec_in_LY_dqPE2 = dfdq_upd_prev_vec_reg_LY_dqPE2; dfdq_upd_curr_vec_in_LZ_dqPE2 = dfdq_upd_prev_vec_reg_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_curr_vec_in_AX_dqPE3 = dfdq_upd_prev_vec_reg_AX_dqPE3; dfdq_upd_curr_vec_in_AY_dqPE3 = dfdq_upd_prev_vec_reg_AY_dqPE3; dfdq_upd_curr_vec_in_AZ_dqPE3 = dfdq_upd_prev_vec_reg_AZ_dqPE3; dfdq_upd_curr_vec_in_LX_dqPE3 = dfdq_upd_prev_vec_reg_LX_dqPE3; dfdq_upd_curr_vec_in_LY_dqPE3 = dfdq_upd_prev_vec_reg_LY_dqPE3; dfdq_upd_curr_vec_in_LZ_dqPE3 = dfdq_upd_prev_vec_reg_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_curr_vec_in_AX_dqPE4 = dfdq_upd_prev_vec_reg_AX_dqPE4; dfdq_upd_curr_vec_in_AY_dqPE4 = dfdq_upd_prev_vec_reg_AY_dqPE4; dfdq_upd_curr_vec_in_AZ_dqPE4 = dfdq_upd_prev_vec_reg_AZ_dqPE4; dfdq_upd_curr_vec_in_LX_dqPE4 = dfdq_upd_prev_vec_reg_LX_dqPE4; dfdq_upd_curr_vec_in_LY_dqPE4 = dfdq_upd_prev_vec_reg_LY_dqPE4; dfdq_upd_curr_vec_in_LZ_dqPE4 = dfdq_upd_prev_vec_reg_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_curr_vec_in_AX_dqPE5 = dfdq_upd_prev_vec_reg_AX_dqPE5; dfdq_upd_curr_vec_in_AY_dqPE5 = dfdq_upd_prev_vec_reg_AY_dqPE5; dfdq_upd_curr_vec_in_AZ_dqPE5 = dfdq_upd_prev_vec_reg_AZ_dqPE5; dfdq_upd_curr_vec_in_LX_dqPE5 = dfdq_upd_prev_vec_reg_LX_dqPE5; dfdq_upd_curr_vec_in_LY_dqPE5 = dfdq_upd_prev_vec_reg_LY_dqPE5; dfdq_upd_curr_vec_in_LZ_dqPE5 = dfdq_upd_prev_vec_reg_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_curr_vec_in_AX_dqPE6 = dfdq_upd_prev_vec_reg_AX_dqPE6; dfdq_upd_curr_vec_in_AY_dqPE6 = dfdq_upd_prev_vec_reg_AY_dqPE6; dfdq_upd_curr_vec_in_AZ_dqPE6 = dfdq_upd_prev_vec_reg_AZ_dqPE6; dfdq_upd_curr_vec_in_LX_dqPE6 = dfdq_upd_prev_vec_reg_LX_dqPE6; dfdq_upd_curr_vec_in_LY_dqPE6 = dfdq_upd_prev_vec_reg_LY_dqPE6; dfdq_upd_curr_vec_in_LZ_dqPE6 = dfdq_upd_prev_vec_reg_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_curr_vec_in_AX_dqPE7 = dfdq_upd_prev_vec_reg_AX_dqPE7; dfdq_upd_curr_vec_in_AY_dqPE7 = dfdq_upd_prev_vec_reg_AY_dqPE7; dfdq_upd_curr_vec_in_AZ_dqPE7 = dfdq_upd_prev_vec_reg_AZ_dqPE7; dfdq_upd_curr_vec_in_LX_dqPE7 = dfdq_upd_prev_vec_reg_LX_dqPE7; dfdq_upd_curr_vec_in_LY_dqPE7 = dfdq_upd_prev_vec_reg_LY_dqPE7; dfdq_upd_curr_vec_in_LZ_dqPE7 = dfdq_upd_prev_vec_reg_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 4'd2;
      derv_in_dqdPE7 = 4'd1;
      sinq_val_in_dqdPE1 = 32'd24454; cosq_val_in_dqdPE1 = 32'd60803;
      // dqdPE2
      link_in_dqdPE2 = 4'd2;
      derv_in_dqdPE2 = 4'd2;
      sinq_val_in_dqdPE2 = 32'd24454; cosq_val_in_dqdPE2 = 32'd60803;
      // dqdPE3
      link_in_dqdPE3 = 4'd2;
      derv_in_dqdPE3 = 4'd3;
      sinq_val_in_dqdPE3 = 32'd24454; cosq_val_in_dqdPE3 = 32'd60803;
      // dqdPE4
      link_in_dqdPE4 = 4'd2;
      derv_in_dqdPE4 = 4'd4;
      sinq_val_in_dqdPE4 = 32'd24454; cosq_val_in_dqdPE4 = 32'd60803;
      // dqdPE5
      link_in_dqdPE5 = 4'd2;
      derv_in_dqdPE5 = 4'd5;
      sinq_val_in_dqdPE5 = 32'd24454; cosq_val_in_dqdPE5 = 32'd60803;
      // dqdPE6
      link_in_dqdPE6 = 4'd2;
      derv_in_dqdPE6 = 4'd6;
      sinq_val_in_dqdPE6 = 32'd24454; cosq_val_in_dqdPE6 = 32'd60803;
      // dqdPE7
      link_in_dqdPE7 = 4'd2;
      derv_in_dqdPE7 = 4'd7;
      sinq_val_in_dqdPE7 = 32'd24454; cosq_val_in_dqdPE7 = 32'd60803;
      // External df updated
      // dqdPE1
      dfdqd_upd_curr_vec_in_AX_dqdPE1 = dfdqd_upd_prev_vec_reg_AX_dqdPE1; dfdqd_upd_curr_vec_in_AY_dqdPE1 = dfdqd_upd_prev_vec_reg_AY_dqdPE1; dfdqd_upd_curr_vec_in_AZ_dqdPE1 = dfdqd_upd_prev_vec_reg_AZ_dqdPE1; dfdqd_upd_curr_vec_in_LX_dqdPE1 = dfdqd_upd_prev_vec_reg_LX_dqdPE1; dfdqd_upd_curr_vec_in_LY_dqdPE1 = dfdqd_upd_prev_vec_reg_LY_dqdPE1; dfdqd_upd_curr_vec_in_LZ_dqdPE1 = dfdqd_upd_prev_vec_reg_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_curr_vec_in_AX_dqdPE2 = dfdqd_upd_prev_vec_reg_AX_dqdPE2; dfdqd_upd_curr_vec_in_AY_dqdPE2 = dfdqd_upd_prev_vec_reg_AY_dqdPE2; dfdqd_upd_curr_vec_in_AZ_dqdPE2 = dfdqd_upd_prev_vec_reg_AZ_dqdPE2; dfdqd_upd_curr_vec_in_LX_dqdPE2 = dfdqd_upd_prev_vec_reg_LX_dqdPE2; dfdqd_upd_curr_vec_in_LY_dqdPE2 = dfdqd_upd_prev_vec_reg_LY_dqdPE2; dfdqd_upd_curr_vec_in_LZ_dqdPE2 = dfdqd_upd_prev_vec_reg_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_curr_vec_in_AX_dqdPE3 = dfdqd_upd_prev_vec_reg_AX_dqdPE3; dfdqd_upd_curr_vec_in_AY_dqdPE3 = dfdqd_upd_prev_vec_reg_AY_dqdPE3; dfdqd_upd_curr_vec_in_AZ_dqdPE3 = dfdqd_upd_prev_vec_reg_AZ_dqdPE3; dfdqd_upd_curr_vec_in_LX_dqdPE3 = dfdqd_upd_prev_vec_reg_LX_dqdPE3; dfdqd_upd_curr_vec_in_LY_dqdPE3 = dfdqd_upd_prev_vec_reg_LY_dqdPE3; dfdqd_upd_curr_vec_in_LZ_dqdPE3 = dfdqd_upd_prev_vec_reg_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_curr_vec_in_AX_dqdPE4 = dfdqd_upd_prev_vec_reg_AX_dqdPE4; dfdqd_upd_curr_vec_in_AY_dqdPE4 = dfdqd_upd_prev_vec_reg_AY_dqdPE4; dfdqd_upd_curr_vec_in_AZ_dqdPE4 = dfdqd_upd_prev_vec_reg_AZ_dqdPE4; dfdqd_upd_curr_vec_in_LX_dqdPE4 = dfdqd_upd_prev_vec_reg_LX_dqdPE4; dfdqd_upd_curr_vec_in_LY_dqdPE4 = dfdqd_upd_prev_vec_reg_LY_dqdPE4; dfdqd_upd_curr_vec_in_LZ_dqdPE4 = dfdqd_upd_prev_vec_reg_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_curr_vec_in_AX_dqdPE5 = dfdqd_upd_prev_vec_reg_AX_dqdPE5; dfdqd_upd_curr_vec_in_AY_dqdPE5 = dfdqd_upd_prev_vec_reg_AY_dqdPE5; dfdqd_upd_curr_vec_in_AZ_dqdPE5 = dfdqd_upd_prev_vec_reg_AZ_dqdPE5; dfdqd_upd_curr_vec_in_LX_dqdPE5 = dfdqd_upd_prev_vec_reg_LX_dqdPE5; dfdqd_upd_curr_vec_in_LY_dqdPE5 = dfdqd_upd_prev_vec_reg_LY_dqdPE5; dfdqd_upd_curr_vec_in_LZ_dqdPE5 = dfdqd_upd_prev_vec_reg_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_curr_vec_in_AX_dqdPE6 = dfdqd_upd_prev_vec_reg_AX_dqdPE6; dfdqd_upd_curr_vec_in_AY_dqdPE6 = dfdqd_upd_prev_vec_reg_AY_dqdPE6; dfdqd_upd_curr_vec_in_AZ_dqdPE6 = dfdqd_upd_prev_vec_reg_AZ_dqdPE6; dfdqd_upd_curr_vec_in_LX_dqdPE6 = dfdqd_upd_prev_vec_reg_LX_dqdPE6; dfdqd_upd_curr_vec_in_LY_dqdPE6 = dfdqd_upd_prev_vec_reg_LY_dqdPE6; dfdqd_upd_curr_vec_in_LZ_dqdPE6 = dfdqd_upd_prev_vec_reg_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_curr_vec_in_AX_dqdPE7 = dfdqd_upd_prev_vec_reg_AX_dqdPE7; dfdqd_upd_curr_vec_in_AY_dqdPE7 = dfdqd_upd_prev_vec_reg_AY_dqdPE7; dfdqd_upd_curr_vec_in_AZ_dqdPE7 = dfdqd_upd_prev_vec_reg_AZ_dqdPE7; dfdqd_upd_curr_vec_in_LX_dqdPE7 = dfdqd_upd_prev_vec_reg_LX_dqdPE7; dfdqd_upd_curr_vec_in_LY_dqdPE7 = dfdqd_upd_prev_vec_reg_LY_dqdPE7; dfdqd_upd_curr_vec_in_LZ_dqdPE7 = dfdqd_upd_prev_vec_reg_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // df prev external inputs
      //------------------------------------------------------------------------
      dfdq_prev_vec_in_AX_dqPE1 = 32'd0; dfdq_prev_vec_in_AX_dqPE2 = 32'd0; dfdq_prev_vec_in_AX_dqPE3 = 32'd0; dfdq_prev_vec_in_AX_dqPE4 = 32'd0; dfdq_prev_vec_in_AX_dqPE5 = 32'd0; dfdq_prev_vec_in_AX_dqPE6 = 32'd0; dfdq_prev_vec_in_AX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AY_dqPE1 = 32'd0; dfdq_prev_vec_in_AY_dqPE2 = 32'd0; dfdq_prev_vec_in_AY_dqPE3 = 32'd0; dfdq_prev_vec_in_AY_dqPE4 = 32'd0; dfdq_prev_vec_in_AY_dqPE5 = 32'd0; dfdq_prev_vec_in_AY_dqPE6 = 32'd0; dfdq_prev_vec_in_AY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AZ_dqPE1 = 32'd0; dfdq_prev_vec_in_AZ_dqPE2 = 32'd0; dfdq_prev_vec_in_AZ_dqPE3 = 32'd0; dfdq_prev_vec_in_AZ_dqPE4 = 32'd0; dfdq_prev_vec_in_AZ_dqPE5 = 32'd0; dfdq_prev_vec_in_AZ_dqPE6 = 32'd0; dfdq_prev_vec_in_AZ_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LX_dqPE1 = 32'd0; dfdq_prev_vec_in_LX_dqPE2 = 32'd0; dfdq_prev_vec_in_LX_dqPE3 = 32'd0; dfdq_prev_vec_in_LX_dqPE4 = 32'd0; dfdq_prev_vec_in_LX_dqPE5 = 32'd0; dfdq_prev_vec_in_LX_dqPE6 = 32'd0; dfdq_prev_vec_in_LX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LY_dqPE1 = 32'd0; dfdq_prev_vec_in_LY_dqPE2 = 32'd0; dfdq_prev_vec_in_LY_dqPE3 = 32'd0; dfdq_prev_vec_in_LY_dqPE4 = 32'd0; dfdq_prev_vec_in_LY_dqPE5 = 32'd0; dfdq_prev_vec_in_LY_dqPE6 = 32'd0; dfdq_prev_vec_in_LY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LZ_dqPE1 = 32'd0; dfdq_prev_vec_in_LZ_dqPE2 = 32'd0; dfdq_prev_vec_in_LZ_dqPE3 = 32'd0; dfdq_prev_vec_in_LZ_dqPE4 = 32'd0; dfdq_prev_vec_in_LZ_dqPE5 = 32'd0; dfdq_prev_vec_in_LZ_dqPE6 = 32'd0; dfdq_prev_vec_in_LZ_dqPE7 = 32'd0;
      dfdqd_prev_vec_in_AX_dqdPE1 = -32'd1887; dfdqd_prev_vec_in_AX_dqdPE2 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE3 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AY_dqdPE1 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE2 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE3 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AZ_dqdPE1 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE2 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE3 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LX_dqdPE1 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE2 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE3 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LY_dqdPE1 = 32'd15727; dfdqd_prev_vec_in_LY_dqdPE2 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE3 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LZ_dqdPE1 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE2 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE3 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
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
      get_data = 1;
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 2 Outputs
      //------------------------------------------------------------------------
      $display ("// Knot 1 Link 2 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, -143598, 152229, 257173, 261022, 36327, -1);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", -189170, -832, -38846, -163910, 9181, 9470, 24);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External f updated prev
      //------------------------------------------------------------------------
      // rnea
      f_upd_prev_vec_reg_AX_rnea = f_upd_prev_vec_out_AX_rnea; f_upd_prev_vec_reg_AY_rnea = f_upd_prev_vec_out_AY_rnea; f_upd_prev_vec_reg_AZ_rnea = f_upd_prev_vec_out_AZ_rnea; f_upd_prev_vec_reg_LX_rnea = f_upd_prev_vec_out_LX_rnea; f_upd_prev_vec_reg_LY_rnea = f_upd_prev_vec_out_LY_rnea; f_upd_prev_vec_reg_LZ_rnea = f_upd_prev_vec_out_LZ_rnea; 
      //------------------------------------------------------------------------
      // External df updated prev
      //------------------------------------------------------------------------
      // dqPE1
      dfdq_upd_prev_vec_reg_AX_dqPE1 = dfdq_upd_prev_vec_out_AX_dqPE1; dfdq_upd_prev_vec_reg_AY_dqPE1 = dfdq_upd_prev_vec_out_AY_dqPE1; dfdq_upd_prev_vec_reg_AZ_dqPE1 = dfdq_upd_prev_vec_out_AZ_dqPE1; dfdq_upd_prev_vec_reg_LX_dqPE1 = dfdq_upd_prev_vec_out_LX_dqPE1; dfdq_upd_prev_vec_reg_LY_dqPE1 = dfdq_upd_prev_vec_out_LY_dqPE1; dfdq_upd_prev_vec_reg_LZ_dqPE1 = dfdq_upd_prev_vec_out_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_prev_vec_reg_AX_dqPE2 = dfdq_upd_prev_vec_out_AX_dqPE2; dfdq_upd_prev_vec_reg_AY_dqPE2 = dfdq_upd_prev_vec_out_AY_dqPE2; dfdq_upd_prev_vec_reg_AZ_dqPE2 = dfdq_upd_prev_vec_out_AZ_dqPE2; dfdq_upd_prev_vec_reg_LX_dqPE2 = dfdq_upd_prev_vec_out_LX_dqPE2; dfdq_upd_prev_vec_reg_LY_dqPE2 = dfdq_upd_prev_vec_out_LY_dqPE2; dfdq_upd_prev_vec_reg_LZ_dqPE2 = dfdq_upd_prev_vec_out_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_prev_vec_reg_AX_dqPE3 = dfdq_upd_prev_vec_out_AX_dqPE3; dfdq_upd_prev_vec_reg_AY_dqPE3 = dfdq_upd_prev_vec_out_AY_dqPE3; dfdq_upd_prev_vec_reg_AZ_dqPE3 = dfdq_upd_prev_vec_out_AZ_dqPE3; dfdq_upd_prev_vec_reg_LX_dqPE3 = dfdq_upd_prev_vec_out_LX_dqPE3; dfdq_upd_prev_vec_reg_LY_dqPE3 = dfdq_upd_prev_vec_out_LY_dqPE3; dfdq_upd_prev_vec_reg_LZ_dqPE3 = dfdq_upd_prev_vec_out_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_prev_vec_reg_AX_dqPE4 = dfdq_upd_prev_vec_out_AX_dqPE4; dfdq_upd_prev_vec_reg_AY_dqPE4 = dfdq_upd_prev_vec_out_AY_dqPE4; dfdq_upd_prev_vec_reg_AZ_dqPE4 = dfdq_upd_prev_vec_out_AZ_dqPE4; dfdq_upd_prev_vec_reg_LX_dqPE4 = dfdq_upd_prev_vec_out_LX_dqPE4; dfdq_upd_prev_vec_reg_LY_dqPE4 = dfdq_upd_prev_vec_out_LY_dqPE4; dfdq_upd_prev_vec_reg_LZ_dqPE4 = dfdq_upd_prev_vec_out_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_prev_vec_reg_AX_dqPE5 = dfdq_upd_prev_vec_out_AX_dqPE5; dfdq_upd_prev_vec_reg_AY_dqPE5 = dfdq_upd_prev_vec_out_AY_dqPE5; dfdq_upd_prev_vec_reg_AZ_dqPE5 = dfdq_upd_prev_vec_out_AZ_dqPE5; dfdq_upd_prev_vec_reg_LX_dqPE5 = dfdq_upd_prev_vec_out_LX_dqPE5; dfdq_upd_prev_vec_reg_LY_dqPE5 = dfdq_upd_prev_vec_out_LY_dqPE5; dfdq_upd_prev_vec_reg_LZ_dqPE5 = dfdq_upd_prev_vec_out_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_prev_vec_reg_AX_dqPE6 = dfdq_upd_prev_vec_out_AX_dqPE6; dfdq_upd_prev_vec_reg_AY_dqPE6 = dfdq_upd_prev_vec_out_AY_dqPE6; dfdq_upd_prev_vec_reg_AZ_dqPE6 = dfdq_upd_prev_vec_out_AZ_dqPE6; dfdq_upd_prev_vec_reg_LX_dqPE6 = dfdq_upd_prev_vec_out_LX_dqPE6; dfdq_upd_prev_vec_reg_LY_dqPE6 = dfdq_upd_prev_vec_out_LY_dqPE6; dfdq_upd_prev_vec_reg_LZ_dqPE6 = dfdq_upd_prev_vec_out_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_prev_vec_reg_AX_dqPE7 = dfdq_upd_prev_vec_out_AX_dqPE7; dfdq_upd_prev_vec_reg_AY_dqPE7 = dfdq_upd_prev_vec_out_AY_dqPE7; dfdq_upd_prev_vec_reg_AZ_dqPE7 = dfdq_upd_prev_vec_out_AZ_dqPE7; dfdq_upd_prev_vec_reg_LX_dqPE7 = dfdq_upd_prev_vec_out_LX_dqPE7; dfdq_upd_prev_vec_reg_LY_dqPE7 = dfdq_upd_prev_vec_out_LY_dqPE7; dfdq_upd_prev_vec_reg_LZ_dqPE7 = dfdq_upd_prev_vec_out_LZ_dqPE7; 
      // dqdPE1
      dfdqd_upd_prev_vec_reg_AX_dqdPE1 = dfdqd_upd_prev_vec_out_AX_dqdPE1; dfdqd_upd_prev_vec_reg_AY_dqdPE1 = dfdqd_upd_prev_vec_out_AY_dqdPE1; dfdqd_upd_prev_vec_reg_AZ_dqdPE1 = dfdqd_upd_prev_vec_out_AZ_dqdPE1; dfdqd_upd_prev_vec_reg_LX_dqdPE1 = dfdqd_upd_prev_vec_out_LX_dqdPE1; dfdqd_upd_prev_vec_reg_LY_dqdPE1 = dfdqd_upd_prev_vec_out_LY_dqdPE1; dfdqd_upd_prev_vec_reg_LZ_dqdPE1 = dfdqd_upd_prev_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_prev_vec_reg_AX_dqdPE2 = dfdqd_upd_prev_vec_out_AX_dqdPE2; dfdqd_upd_prev_vec_reg_AY_dqdPE2 = dfdqd_upd_prev_vec_out_AY_dqdPE2; dfdqd_upd_prev_vec_reg_AZ_dqdPE2 = dfdqd_upd_prev_vec_out_AZ_dqdPE2; dfdqd_upd_prev_vec_reg_LX_dqdPE2 = dfdqd_upd_prev_vec_out_LX_dqdPE2; dfdqd_upd_prev_vec_reg_LY_dqdPE2 = dfdqd_upd_prev_vec_out_LY_dqdPE2; dfdqd_upd_prev_vec_reg_LZ_dqdPE2 = dfdqd_upd_prev_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_prev_vec_reg_AX_dqdPE3 = dfdqd_upd_prev_vec_out_AX_dqdPE3; dfdqd_upd_prev_vec_reg_AY_dqdPE3 = dfdqd_upd_prev_vec_out_AY_dqdPE3; dfdqd_upd_prev_vec_reg_AZ_dqdPE3 = dfdqd_upd_prev_vec_out_AZ_dqdPE3; dfdqd_upd_prev_vec_reg_LX_dqdPE3 = dfdqd_upd_prev_vec_out_LX_dqdPE3; dfdqd_upd_prev_vec_reg_LY_dqdPE3 = dfdqd_upd_prev_vec_out_LY_dqdPE3; dfdqd_upd_prev_vec_reg_LZ_dqdPE3 = dfdqd_upd_prev_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_prev_vec_reg_AX_dqdPE4 = dfdqd_upd_prev_vec_out_AX_dqdPE4; dfdqd_upd_prev_vec_reg_AY_dqdPE4 = dfdqd_upd_prev_vec_out_AY_dqdPE4; dfdqd_upd_prev_vec_reg_AZ_dqdPE4 = dfdqd_upd_prev_vec_out_AZ_dqdPE4; dfdqd_upd_prev_vec_reg_LX_dqdPE4 = dfdqd_upd_prev_vec_out_LX_dqdPE4; dfdqd_upd_prev_vec_reg_LY_dqdPE4 = dfdqd_upd_prev_vec_out_LY_dqdPE4; dfdqd_upd_prev_vec_reg_LZ_dqdPE4 = dfdqd_upd_prev_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_prev_vec_reg_AX_dqdPE5 = dfdqd_upd_prev_vec_out_AX_dqdPE5; dfdqd_upd_prev_vec_reg_AY_dqdPE5 = dfdqd_upd_prev_vec_out_AY_dqdPE5; dfdqd_upd_prev_vec_reg_AZ_dqdPE5 = dfdqd_upd_prev_vec_out_AZ_dqdPE5; dfdqd_upd_prev_vec_reg_LX_dqdPE5 = dfdqd_upd_prev_vec_out_LX_dqdPE5; dfdqd_upd_prev_vec_reg_LY_dqdPE5 = dfdqd_upd_prev_vec_out_LY_dqdPE5; dfdqd_upd_prev_vec_reg_LZ_dqdPE5 = dfdqd_upd_prev_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_prev_vec_reg_AX_dqdPE6 = dfdqd_upd_prev_vec_out_AX_dqdPE6; dfdqd_upd_prev_vec_reg_AY_dqdPE6 = dfdqd_upd_prev_vec_out_AY_dqdPE6; dfdqd_upd_prev_vec_reg_AZ_dqdPE6 = dfdqd_upd_prev_vec_out_AZ_dqdPE6; dfdqd_upd_prev_vec_reg_LX_dqdPE6 = dfdqd_upd_prev_vec_out_LX_dqdPE6; dfdqd_upd_prev_vec_reg_LY_dqdPE6 = dfdqd_upd_prev_vec_out_LY_dqdPE6; dfdqd_upd_prev_vec_reg_LZ_dqdPE6 = dfdqd_upd_prev_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_prev_vec_reg_AX_dqdPE7 = dfdqd_upd_prev_vec_out_AX_dqdPE7; dfdqd_upd_prev_vec_reg_AY_dqdPE7 = dfdqd_upd_prev_vec_out_AY_dqdPE7; dfdqd_upd_prev_vec_reg_AZ_dqdPE7 = dfdqd_upd_prev_vec_out_AZ_dqdPE7; dfdqd_upd_prev_vec_reg_LX_dqdPE7 = dfdqd_upd_prev_vec_out_LX_dqdPE7; dfdqd_upd_prev_vec_reg_LY_dqdPE7 = dfdqd_upd_prev_vec_out_LY_dqdPE7; dfdqd_upd_prev_vec_reg_LZ_dqdPE7 = dfdqd_upd_prev_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Link 1 Inputs
      //------------------------------------------------------------------------
      // 0
      minv_prev_vec_in_C1 = 32'd0; minv_prev_vec_in_C2 = 32'd0; minv_prev_vec_in_C3 = 32'd0; minv_prev_vec_in_C4 = 32'd0; minv_prev_vec_in_C5 = 32'd0; minv_prev_vec_in_C6 = 32'd0; minv_prev_vec_in_C7 = 32'd0;
      //------------------------------------------------------------------------
      // rnea external inputs
      //------------------------------------------------------------------------
      // rnea
      link_in_rnea = 4'd1;
      sinq_val_in_rnea = 32'd19197; cosq_val_in_rnea = 32'd62661;
      f_prev_vec_in_AX_rnea = 32'd0; f_prev_vec_in_AY_rnea = 32'd0; f_prev_vec_in_AZ_rnea = 32'd0; f_prev_vec_in_LX_rnea = 32'd0; f_prev_vec_in_LY_rnea = 32'd0; f_prev_vec_in_LZ_rnea = 32'd0;
      f_upd_curr_vec_in_AX_rnea = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_rnea = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_rnea = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_rnea = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_rnea = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_rnea = f_upd_prev_vec_reg_LZ_rnea; 
      //------------------------------------------------------------------------
      // dq external inputs
      //------------------------------------------------------------------------
      // dqPE1
      link_in_dqPE1 = 4'd1;
      derv_in_dqPE1 = 4'd1;
      sinq_val_in_dqPE1 = 32'd19197; cosq_val_in_dqPE1 = 32'd62661;
      f_upd_curr_vec_in_AX_dqPE1 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE1 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE1 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE1 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE1 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE1 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE2
      link_in_dqPE2 = 4'd1;
      derv_in_dqPE2 = 4'd2;
      sinq_val_in_dqPE2 = 32'd19197; cosq_val_in_dqPE2 = 32'd62661;
      f_upd_curr_vec_in_AX_dqPE2 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE2 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE2 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE2 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE2 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE2 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE3
      link_in_dqPE3 = 4'd1;
      derv_in_dqPE3 = 4'd3;
      sinq_val_in_dqPE3 = 32'd19197; cosq_val_in_dqPE3 = 32'd62661;
      f_upd_curr_vec_in_AX_dqPE3 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE3 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE3 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE3 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE3 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE3 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE4
      link_in_dqPE4 = 4'd1;
      derv_in_dqPE4 = 4'd4;
      sinq_val_in_dqPE4 = 32'd19197; cosq_val_in_dqPE4 = 32'd62661;
      f_upd_curr_vec_in_AX_dqPE4 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE4 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE4 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE4 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE4 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE4 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE5
      link_in_dqPE5 = 4'd1;
      derv_in_dqPE5 = 4'd5;
      sinq_val_in_dqPE5 = 32'd19197; cosq_val_in_dqPE5 = 32'd62661;
      f_upd_curr_vec_in_AX_dqPE5 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE5 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE5 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE5 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE5 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE5 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE6
      link_in_dqPE6 = 4'd1;
      derv_in_dqPE6 = 4'd6;
      sinq_val_in_dqPE6 = 32'd19197; cosq_val_in_dqPE6 = 32'd62661;
      f_upd_curr_vec_in_AX_dqPE6 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE6 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE6 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE6 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE6 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE6 = f_upd_prev_vec_reg_LZ_rnea; 
      // dqPE7
      link_in_dqPE7 = 4'd1;
      derv_in_dqPE7 = 4'd7;
      sinq_val_in_dqPE7 = 32'd19197; cosq_val_in_dqPE7 = 32'd62661;
      f_upd_curr_vec_in_AX_dqPE7 = f_upd_prev_vec_reg_AX_rnea; f_upd_curr_vec_in_AY_dqPE7 = f_upd_prev_vec_reg_AY_rnea; f_upd_curr_vec_in_AZ_dqPE7 = f_upd_prev_vec_reg_AZ_rnea; f_upd_curr_vec_in_LX_dqPE7 = f_upd_prev_vec_reg_LX_rnea; f_upd_curr_vec_in_LY_dqPE7 = f_upd_prev_vec_reg_LY_rnea; f_upd_curr_vec_in_LZ_dqPE7 = f_upd_prev_vec_reg_LZ_rnea; 
      // External df updated
      // dqPE1
      dfdq_upd_curr_vec_in_AX_dqPE1 = dfdq_upd_prev_vec_reg_AX_dqPE1; dfdq_upd_curr_vec_in_AY_dqPE1 = dfdq_upd_prev_vec_reg_AY_dqPE1; dfdq_upd_curr_vec_in_AZ_dqPE1 = dfdq_upd_prev_vec_reg_AZ_dqPE1; dfdq_upd_curr_vec_in_LX_dqPE1 = dfdq_upd_prev_vec_reg_LX_dqPE1; dfdq_upd_curr_vec_in_LY_dqPE1 = dfdq_upd_prev_vec_reg_LY_dqPE1; dfdq_upd_curr_vec_in_LZ_dqPE1 = dfdq_upd_prev_vec_reg_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_curr_vec_in_AX_dqPE2 = dfdq_upd_prev_vec_reg_AX_dqPE2; dfdq_upd_curr_vec_in_AY_dqPE2 = dfdq_upd_prev_vec_reg_AY_dqPE2; dfdq_upd_curr_vec_in_AZ_dqPE2 = dfdq_upd_prev_vec_reg_AZ_dqPE2; dfdq_upd_curr_vec_in_LX_dqPE2 = dfdq_upd_prev_vec_reg_LX_dqPE2; dfdq_upd_curr_vec_in_LY_dqPE2 = dfdq_upd_prev_vec_reg_LY_dqPE2; dfdq_upd_curr_vec_in_LZ_dqPE2 = dfdq_upd_prev_vec_reg_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_curr_vec_in_AX_dqPE3 = dfdq_upd_prev_vec_reg_AX_dqPE3; dfdq_upd_curr_vec_in_AY_dqPE3 = dfdq_upd_prev_vec_reg_AY_dqPE3; dfdq_upd_curr_vec_in_AZ_dqPE3 = dfdq_upd_prev_vec_reg_AZ_dqPE3; dfdq_upd_curr_vec_in_LX_dqPE3 = dfdq_upd_prev_vec_reg_LX_dqPE3; dfdq_upd_curr_vec_in_LY_dqPE3 = dfdq_upd_prev_vec_reg_LY_dqPE3; dfdq_upd_curr_vec_in_LZ_dqPE3 = dfdq_upd_prev_vec_reg_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_curr_vec_in_AX_dqPE4 = dfdq_upd_prev_vec_reg_AX_dqPE4; dfdq_upd_curr_vec_in_AY_dqPE4 = dfdq_upd_prev_vec_reg_AY_dqPE4; dfdq_upd_curr_vec_in_AZ_dqPE4 = dfdq_upd_prev_vec_reg_AZ_dqPE4; dfdq_upd_curr_vec_in_LX_dqPE4 = dfdq_upd_prev_vec_reg_LX_dqPE4; dfdq_upd_curr_vec_in_LY_dqPE4 = dfdq_upd_prev_vec_reg_LY_dqPE4; dfdq_upd_curr_vec_in_LZ_dqPE4 = dfdq_upd_prev_vec_reg_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_curr_vec_in_AX_dqPE5 = dfdq_upd_prev_vec_reg_AX_dqPE5; dfdq_upd_curr_vec_in_AY_dqPE5 = dfdq_upd_prev_vec_reg_AY_dqPE5; dfdq_upd_curr_vec_in_AZ_dqPE5 = dfdq_upd_prev_vec_reg_AZ_dqPE5; dfdq_upd_curr_vec_in_LX_dqPE5 = dfdq_upd_prev_vec_reg_LX_dqPE5; dfdq_upd_curr_vec_in_LY_dqPE5 = dfdq_upd_prev_vec_reg_LY_dqPE5; dfdq_upd_curr_vec_in_LZ_dqPE5 = dfdq_upd_prev_vec_reg_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_curr_vec_in_AX_dqPE6 = dfdq_upd_prev_vec_reg_AX_dqPE6; dfdq_upd_curr_vec_in_AY_dqPE6 = dfdq_upd_prev_vec_reg_AY_dqPE6; dfdq_upd_curr_vec_in_AZ_dqPE6 = dfdq_upd_prev_vec_reg_AZ_dqPE6; dfdq_upd_curr_vec_in_LX_dqPE6 = dfdq_upd_prev_vec_reg_LX_dqPE6; dfdq_upd_curr_vec_in_LY_dqPE6 = dfdq_upd_prev_vec_reg_LY_dqPE6; dfdq_upd_curr_vec_in_LZ_dqPE6 = dfdq_upd_prev_vec_reg_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_curr_vec_in_AX_dqPE7 = dfdq_upd_prev_vec_reg_AX_dqPE7; dfdq_upd_curr_vec_in_AY_dqPE7 = dfdq_upd_prev_vec_reg_AY_dqPE7; dfdq_upd_curr_vec_in_AZ_dqPE7 = dfdq_upd_prev_vec_reg_AZ_dqPE7; dfdq_upd_curr_vec_in_LX_dqPE7 = dfdq_upd_prev_vec_reg_LX_dqPE7; dfdq_upd_curr_vec_in_LY_dqPE7 = dfdq_upd_prev_vec_reg_LY_dqPE7; dfdq_upd_curr_vec_in_LZ_dqPE7 = dfdq_upd_prev_vec_reg_LZ_dqPE7; 
      //------------------------------------------------------------------------
      // dqd external inputs
      //------------------------------------------------------------------------
      // dqdPE1
      link_in_dqdPE1 = 4'd1;
      derv_in_dqdPE7 = 4'd1;
      sinq_val_in_dqdPE1 = 32'd19197; cosq_val_in_dqdPE1 = 32'd62661;
      // dqdPE2
      link_in_dqdPE2 = 4'd1;
      derv_in_dqdPE2 = 4'd2;
      sinq_val_in_dqdPE2 = 32'd19197; cosq_val_in_dqdPE2 = 32'd62661;
      // dqdPE3
      link_in_dqdPE3 = 4'd1;
      derv_in_dqdPE3 = 4'd3;
      sinq_val_in_dqdPE3 = 32'd19197; cosq_val_in_dqdPE3 = 32'd62661;
      // dqdPE4
      link_in_dqdPE4 = 4'd1;
      derv_in_dqdPE4 = 4'd4;
      sinq_val_in_dqdPE4 = 32'd19197; cosq_val_in_dqdPE4 = 32'd62661;
      // dqdPE5
      link_in_dqdPE5 = 4'd1;
      derv_in_dqdPE5 = 4'd5;
      sinq_val_in_dqdPE5 = 32'd19197; cosq_val_in_dqdPE5 = 32'd62661;
      // dqdPE6
      link_in_dqdPE6 = 4'd1;
      derv_in_dqdPE6 = 4'd6;
      sinq_val_in_dqdPE6 = 32'd19197; cosq_val_in_dqdPE6 = 32'd62661;
      // dqdPE7
      link_in_dqdPE7 = 4'd1;
      derv_in_dqdPE7 = 4'd7;
      sinq_val_in_dqdPE7 = 32'd19197; cosq_val_in_dqdPE7 = 32'd62661;
      // External df updated
      // dqdPE1
      dfdqd_upd_curr_vec_in_AX_dqdPE1 = dfdqd_upd_prev_vec_reg_AX_dqdPE1; dfdqd_upd_curr_vec_in_AY_dqdPE1 = dfdqd_upd_prev_vec_reg_AY_dqdPE1; dfdqd_upd_curr_vec_in_AZ_dqdPE1 = dfdqd_upd_prev_vec_reg_AZ_dqdPE1; dfdqd_upd_curr_vec_in_LX_dqdPE1 = dfdqd_upd_prev_vec_reg_LX_dqdPE1; dfdqd_upd_curr_vec_in_LY_dqdPE1 = dfdqd_upd_prev_vec_reg_LY_dqdPE1; dfdqd_upd_curr_vec_in_LZ_dqdPE1 = dfdqd_upd_prev_vec_reg_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_curr_vec_in_AX_dqdPE2 = dfdqd_upd_prev_vec_reg_AX_dqdPE2; dfdqd_upd_curr_vec_in_AY_dqdPE2 = dfdqd_upd_prev_vec_reg_AY_dqdPE2; dfdqd_upd_curr_vec_in_AZ_dqdPE2 = dfdqd_upd_prev_vec_reg_AZ_dqdPE2; dfdqd_upd_curr_vec_in_LX_dqdPE2 = dfdqd_upd_prev_vec_reg_LX_dqdPE2; dfdqd_upd_curr_vec_in_LY_dqdPE2 = dfdqd_upd_prev_vec_reg_LY_dqdPE2; dfdqd_upd_curr_vec_in_LZ_dqdPE2 = dfdqd_upd_prev_vec_reg_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_curr_vec_in_AX_dqdPE3 = dfdqd_upd_prev_vec_reg_AX_dqdPE3; dfdqd_upd_curr_vec_in_AY_dqdPE3 = dfdqd_upd_prev_vec_reg_AY_dqdPE3; dfdqd_upd_curr_vec_in_AZ_dqdPE3 = dfdqd_upd_prev_vec_reg_AZ_dqdPE3; dfdqd_upd_curr_vec_in_LX_dqdPE3 = dfdqd_upd_prev_vec_reg_LX_dqdPE3; dfdqd_upd_curr_vec_in_LY_dqdPE3 = dfdqd_upd_prev_vec_reg_LY_dqdPE3; dfdqd_upd_curr_vec_in_LZ_dqdPE3 = dfdqd_upd_prev_vec_reg_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_curr_vec_in_AX_dqdPE4 = dfdqd_upd_prev_vec_reg_AX_dqdPE4; dfdqd_upd_curr_vec_in_AY_dqdPE4 = dfdqd_upd_prev_vec_reg_AY_dqdPE4; dfdqd_upd_curr_vec_in_AZ_dqdPE4 = dfdqd_upd_prev_vec_reg_AZ_dqdPE4; dfdqd_upd_curr_vec_in_LX_dqdPE4 = dfdqd_upd_prev_vec_reg_LX_dqdPE4; dfdqd_upd_curr_vec_in_LY_dqdPE4 = dfdqd_upd_prev_vec_reg_LY_dqdPE4; dfdqd_upd_curr_vec_in_LZ_dqdPE4 = dfdqd_upd_prev_vec_reg_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_curr_vec_in_AX_dqdPE5 = dfdqd_upd_prev_vec_reg_AX_dqdPE5; dfdqd_upd_curr_vec_in_AY_dqdPE5 = dfdqd_upd_prev_vec_reg_AY_dqdPE5; dfdqd_upd_curr_vec_in_AZ_dqdPE5 = dfdqd_upd_prev_vec_reg_AZ_dqdPE5; dfdqd_upd_curr_vec_in_LX_dqdPE5 = dfdqd_upd_prev_vec_reg_LX_dqdPE5; dfdqd_upd_curr_vec_in_LY_dqdPE5 = dfdqd_upd_prev_vec_reg_LY_dqdPE5; dfdqd_upd_curr_vec_in_LZ_dqdPE5 = dfdqd_upd_prev_vec_reg_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_curr_vec_in_AX_dqdPE6 = dfdqd_upd_prev_vec_reg_AX_dqdPE6; dfdqd_upd_curr_vec_in_AY_dqdPE6 = dfdqd_upd_prev_vec_reg_AY_dqdPE6; dfdqd_upd_curr_vec_in_AZ_dqdPE6 = dfdqd_upd_prev_vec_reg_AZ_dqdPE6; dfdqd_upd_curr_vec_in_LX_dqdPE6 = dfdqd_upd_prev_vec_reg_LX_dqdPE6; dfdqd_upd_curr_vec_in_LY_dqdPE6 = dfdqd_upd_prev_vec_reg_LY_dqdPE6; dfdqd_upd_curr_vec_in_LZ_dqdPE6 = dfdqd_upd_prev_vec_reg_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_curr_vec_in_AX_dqdPE7 = dfdqd_upd_prev_vec_reg_AX_dqdPE7; dfdqd_upd_curr_vec_in_AY_dqdPE7 = dfdqd_upd_prev_vec_reg_AY_dqdPE7; dfdqd_upd_curr_vec_in_AZ_dqdPE7 = dfdqd_upd_prev_vec_reg_AZ_dqdPE7; dfdqd_upd_curr_vec_in_LX_dqdPE7 = dfdqd_upd_prev_vec_reg_LX_dqdPE7; dfdqd_upd_curr_vec_in_LY_dqdPE7 = dfdqd_upd_prev_vec_reg_LY_dqdPE7; dfdqd_upd_curr_vec_in_LZ_dqdPE7 = dfdqd_upd_prev_vec_reg_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // df prev external inputs
      //------------------------------------------------------------------------
      dfdq_prev_vec_in_AX_dqPE1 = 32'd0; dfdq_prev_vec_in_AX_dqPE2 = 32'd0; dfdq_prev_vec_in_AX_dqPE3 = 32'd0; dfdq_prev_vec_in_AX_dqPE4 = 32'd0; dfdq_prev_vec_in_AX_dqPE5 = 32'd0; dfdq_prev_vec_in_AX_dqPE6 = 32'd0; dfdq_prev_vec_in_AX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AY_dqPE1 = 32'd0; dfdq_prev_vec_in_AY_dqPE2 = 32'd0; dfdq_prev_vec_in_AY_dqPE3 = 32'd0; dfdq_prev_vec_in_AY_dqPE4 = 32'd0; dfdq_prev_vec_in_AY_dqPE5 = 32'd0; dfdq_prev_vec_in_AY_dqPE6 = 32'd0; dfdq_prev_vec_in_AY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_AZ_dqPE1 = 32'd0; dfdq_prev_vec_in_AZ_dqPE2 = 32'd0; dfdq_prev_vec_in_AZ_dqPE3 = 32'd0; dfdq_prev_vec_in_AZ_dqPE4 = 32'd0; dfdq_prev_vec_in_AZ_dqPE5 = 32'd0; dfdq_prev_vec_in_AZ_dqPE6 = 32'd0; dfdq_prev_vec_in_AZ_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LX_dqPE1 = 32'd0; dfdq_prev_vec_in_LX_dqPE2 = 32'd0; dfdq_prev_vec_in_LX_dqPE3 = 32'd0; dfdq_prev_vec_in_LX_dqPE4 = 32'd0; dfdq_prev_vec_in_LX_dqPE5 = 32'd0; dfdq_prev_vec_in_LX_dqPE6 = 32'd0; dfdq_prev_vec_in_LX_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LY_dqPE1 = 32'd0; dfdq_prev_vec_in_LY_dqPE2 = 32'd0; dfdq_prev_vec_in_LY_dqPE3 = 32'd0; dfdq_prev_vec_in_LY_dqPE4 = 32'd0; dfdq_prev_vec_in_LY_dqPE5 = 32'd0; dfdq_prev_vec_in_LY_dqPE6 = 32'd0; dfdq_prev_vec_in_LY_dqPE7 = 32'd0;
      dfdq_prev_vec_in_LZ_dqPE1 = 32'd0; dfdq_prev_vec_in_LZ_dqPE2 = 32'd0; dfdq_prev_vec_in_LZ_dqPE3 = 32'd0; dfdq_prev_vec_in_LZ_dqPE4 = 32'd0; dfdq_prev_vec_in_LZ_dqPE5 = 32'd0; dfdq_prev_vec_in_LZ_dqPE6 = 32'd0; dfdq_prev_vec_in_LZ_dqPE7 = 32'd0;
      dfdqd_prev_vec_in_AX_dqdPE1 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE2 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE3 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AY_dqdPE1 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE2 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE3 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_AZ_dqdPE1 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE2 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE3 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE4 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE5 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_AZ_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LX_dqdPE1 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE2 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE3 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LX_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LY_dqdPE1 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE2 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE3 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LY_dqdPE7 = 32'd0;
      dfdqd_prev_vec_in_LZ_dqdPE1 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE2 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE3 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE4 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE5 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE6 = 32'd0; dfdqd_prev_vec_in_LZ_dqdPE7 = 32'd0;
      //------------------------------------------------------------------------
      // Clock and Control Inputs
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
      get_data = 1; // Hold for 3 cycles for Link 1 Outputs
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1; // 2
      clk = 1;
      #5;
      clk = 0;
      #5;
      get_data = 1; // 1
      clk = 1;
      #5;
      clk = 0;
      #5;
      //------------------------------------------------------------------------
      // Link 1 Outputs
      //------------------------------------------------------------------------
      $display ("// Knot 1 Link 1 Test");
      $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dq
//       $display ("dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 0, 42647, -137408, 36, 24777, 27210, -0);
//       $display ("\n");
//       $display ("dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
//       // dtau/dqd
//       $display ("dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d", 15627, 150456, -23071, -90085, 1629, 782, -9);
//       $display ("\n");
//       $display ("dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);
//       $display ("//-------------------------------------------------------------------------------------------------------");
      // Minv*dtau/dq
      $display ("minv_dtaudq_ref = ");
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,-81502,233272,92865,-178327,-48664,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,38170,-22551,-47388,12133,-13242,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,102711,-220471,-2454756,194477,36675,-0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,-12620,75598,50095,317983,-12648,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,-22151,-848,2277094,84361,-230226,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,-64051,-11625,-3801,580245,-90470,0);
      $display ("%d,%d,%d,%d,%d,%d,%d", 0,43279,-12170,-14532,-104344,679222,-0);
      $display ("minv_dtaudq_out = ");
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R1_C1,minv_dtaudq_out_R1_C2,minv_dtaudq_out_R1_C3,minv_dtaudq_out_R1_C4,minv_dtaudq_out_R1_C5,minv_dtaudq_out_R1_C6,minv_dtaudq_out_R1_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R2_C1,minv_dtaudq_out_R2_C2,minv_dtaudq_out_R2_C3,minv_dtaudq_out_R2_C4,minv_dtaudq_out_R2_C5,minv_dtaudq_out_R2_C6,minv_dtaudq_out_R2_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R3_C1,minv_dtaudq_out_R3_C2,minv_dtaudq_out_R3_C3,minv_dtaudq_out_R3_C4,minv_dtaudq_out_R3_C5,minv_dtaudq_out_R3_C6,minv_dtaudq_out_R3_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R4_C1,minv_dtaudq_out_R4_C2,minv_dtaudq_out_R4_C3,minv_dtaudq_out_R4_C4,minv_dtaudq_out_R4_C5,minv_dtaudq_out_R4_C6,minv_dtaudq_out_R4_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R5_C1,minv_dtaudq_out_R5_C2,minv_dtaudq_out_R5_C3,minv_dtaudq_out_R5_C4,minv_dtaudq_out_R5_C5,minv_dtaudq_out_R5_C6,minv_dtaudq_out_R5_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R6_C1,minv_dtaudq_out_R6_C2,minv_dtaudq_out_R6_C3,minv_dtaudq_out_R6_C4,minv_dtaudq_out_R6_C5,minv_dtaudq_out_R6_C6,minv_dtaudq_out_R6_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudq_out_R7_C1,minv_dtaudq_out_R7_C2,minv_dtaudq_out_R7_C3,minv_dtaudq_out_R7_C4,minv_dtaudq_out_R7_C5,minv_dtaudq_out_R7_C6,minv_dtaudq_out_R7_C7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      // Minv*dtau/dqd
      $display ("minv_dtaudqd_ref = ");
      $display ("%d,%d,%d,%d,%d,%d,%d", -31047,-270683,40236,158637,-3817,-6252,-76);
      $display ("%d,%d,%d,%d,%d,%d,%d", 53418,-14732,13531,54576,-1558,440,-12);
      $display ("%d,%d,%d,%d,%d,%d,%d", 37833,254266,-32572,-143688,4399,6772,46);
      $display ("%d,%d,%d,%d,%d,%d,%d", -6635,-50697,7306,20961,4154,10885,-47);
      $display ("%d,%d,%d,%d,%d,%d,%d", -17565,37904,-10400,-49809,-7455,-42082,-678);
      $display ("%d,%d,%d,%d,%d,%d,%d", -42853,-93277,-15920,-174332,49751,8219,-4830);
      $display ("%d,%d,%d,%d,%d,%d,%d", 34402,-8424,16342,-9678,27796,77467,675);
      $display ("minv_dtaudqd_out = ");
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R1_C1,minv_dtaudqd_out_R1_C2,minv_dtaudqd_out_R1_C3,minv_dtaudqd_out_R1_C4,minv_dtaudqd_out_R1_C5,minv_dtaudqd_out_R1_C6,minv_dtaudqd_out_R1_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R2_C1,minv_dtaudqd_out_R2_C2,minv_dtaudqd_out_R2_C3,minv_dtaudqd_out_R2_C4,minv_dtaudqd_out_R2_C5,minv_dtaudqd_out_R2_C6,minv_dtaudqd_out_R2_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R3_C1,minv_dtaudqd_out_R3_C2,minv_dtaudqd_out_R3_C3,minv_dtaudqd_out_R3_C4,minv_dtaudqd_out_R3_C5,minv_dtaudqd_out_R3_C6,minv_dtaudqd_out_R3_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R4_C1,minv_dtaudqd_out_R4_C2,minv_dtaudqd_out_R4_C3,minv_dtaudqd_out_R4_C4,minv_dtaudqd_out_R4_C5,minv_dtaudqd_out_R4_C6,minv_dtaudqd_out_R4_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R5_C1,minv_dtaudqd_out_R5_C2,minv_dtaudqd_out_R5_C3,minv_dtaudqd_out_R5_C4,minv_dtaudqd_out_R5_C5,minv_dtaudqd_out_R5_C6,minv_dtaudqd_out_R5_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R6_C1,minv_dtaudqd_out_R6_C2,minv_dtaudqd_out_R6_C3,minv_dtaudqd_out_R6_C4,minv_dtaudqd_out_R6_C5,minv_dtaudqd_out_R6_C6,minv_dtaudqd_out_R6_C7);
      $display ("%d,%d,%d,%d,%d,%d,%d", minv_dtaudqd_out_R7_C1,minv_dtaudqd_out_R7_C2,minv_dtaudqd_out_R7_C3,minv_dtaudqd_out_R7_C4,minv_dtaudqd_out_R7_C5,minv_dtaudqd_out_R7_C6,minv_dtaudqd_out_R7_C7);
      $display ("//-------------------------------------------------------------------------------------------------------");
      //------------------------------------------------------------------------
      // External f updated prev
      //------------------------------------------------------------------------
      // rnea
      f_upd_prev_vec_reg_AX_rnea = f_upd_prev_vec_out_AX_rnea; f_upd_prev_vec_reg_AY_rnea = f_upd_prev_vec_out_AY_rnea; f_upd_prev_vec_reg_AZ_rnea = f_upd_prev_vec_out_AZ_rnea; f_upd_prev_vec_reg_LX_rnea = f_upd_prev_vec_out_LX_rnea; f_upd_prev_vec_reg_LY_rnea = f_upd_prev_vec_out_LY_rnea; f_upd_prev_vec_reg_LZ_rnea = f_upd_prev_vec_out_LZ_rnea; 
      //------------------------------------------------------------------------
      // External df updated prev
      //------------------------------------------------------------------------
      // dqPE1
      dfdq_upd_prev_vec_reg_AX_dqPE1 = dfdq_upd_prev_vec_out_AX_dqPE1; dfdq_upd_prev_vec_reg_AY_dqPE1 = dfdq_upd_prev_vec_out_AY_dqPE1; dfdq_upd_prev_vec_reg_AZ_dqPE1 = dfdq_upd_prev_vec_out_AZ_dqPE1; dfdq_upd_prev_vec_reg_LX_dqPE1 = dfdq_upd_prev_vec_out_LX_dqPE1; dfdq_upd_prev_vec_reg_LY_dqPE1 = dfdq_upd_prev_vec_out_LY_dqPE1; dfdq_upd_prev_vec_reg_LZ_dqPE1 = dfdq_upd_prev_vec_out_LZ_dqPE1; 
      // dqPE2
      dfdq_upd_prev_vec_reg_AX_dqPE2 = dfdq_upd_prev_vec_out_AX_dqPE2; dfdq_upd_prev_vec_reg_AY_dqPE2 = dfdq_upd_prev_vec_out_AY_dqPE2; dfdq_upd_prev_vec_reg_AZ_dqPE2 = dfdq_upd_prev_vec_out_AZ_dqPE2; dfdq_upd_prev_vec_reg_LX_dqPE2 = dfdq_upd_prev_vec_out_LX_dqPE2; dfdq_upd_prev_vec_reg_LY_dqPE2 = dfdq_upd_prev_vec_out_LY_dqPE2; dfdq_upd_prev_vec_reg_LZ_dqPE2 = dfdq_upd_prev_vec_out_LZ_dqPE2; 
      // dqPE3
      dfdq_upd_prev_vec_reg_AX_dqPE3 = dfdq_upd_prev_vec_out_AX_dqPE3; dfdq_upd_prev_vec_reg_AY_dqPE3 = dfdq_upd_prev_vec_out_AY_dqPE3; dfdq_upd_prev_vec_reg_AZ_dqPE3 = dfdq_upd_prev_vec_out_AZ_dqPE3; dfdq_upd_prev_vec_reg_LX_dqPE3 = dfdq_upd_prev_vec_out_LX_dqPE3; dfdq_upd_prev_vec_reg_LY_dqPE3 = dfdq_upd_prev_vec_out_LY_dqPE3; dfdq_upd_prev_vec_reg_LZ_dqPE3 = dfdq_upd_prev_vec_out_LZ_dqPE3; 
      // dqPE4
      dfdq_upd_prev_vec_reg_AX_dqPE4 = dfdq_upd_prev_vec_out_AX_dqPE4; dfdq_upd_prev_vec_reg_AY_dqPE4 = dfdq_upd_prev_vec_out_AY_dqPE4; dfdq_upd_prev_vec_reg_AZ_dqPE4 = dfdq_upd_prev_vec_out_AZ_dqPE4; dfdq_upd_prev_vec_reg_LX_dqPE4 = dfdq_upd_prev_vec_out_LX_dqPE4; dfdq_upd_prev_vec_reg_LY_dqPE4 = dfdq_upd_prev_vec_out_LY_dqPE4; dfdq_upd_prev_vec_reg_LZ_dqPE4 = dfdq_upd_prev_vec_out_LZ_dqPE4; 
      // dqPE5
      dfdq_upd_prev_vec_reg_AX_dqPE5 = dfdq_upd_prev_vec_out_AX_dqPE5; dfdq_upd_prev_vec_reg_AY_dqPE5 = dfdq_upd_prev_vec_out_AY_dqPE5; dfdq_upd_prev_vec_reg_AZ_dqPE5 = dfdq_upd_prev_vec_out_AZ_dqPE5; dfdq_upd_prev_vec_reg_LX_dqPE5 = dfdq_upd_prev_vec_out_LX_dqPE5; dfdq_upd_prev_vec_reg_LY_dqPE5 = dfdq_upd_prev_vec_out_LY_dqPE5; dfdq_upd_prev_vec_reg_LZ_dqPE5 = dfdq_upd_prev_vec_out_LZ_dqPE5; 
      // dqPE6
      dfdq_upd_prev_vec_reg_AX_dqPE6 = dfdq_upd_prev_vec_out_AX_dqPE6; dfdq_upd_prev_vec_reg_AY_dqPE6 = dfdq_upd_prev_vec_out_AY_dqPE6; dfdq_upd_prev_vec_reg_AZ_dqPE6 = dfdq_upd_prev_vec_out_AZ_dqPE6; dfdq_upd_prev_vec_reg_LX_dqPE6 = dfdq_upd_prev_vec_out_LX_dqPE6; dfdq_upd_prev_vec_reg_LY_dqPE6 = dfdq_upd_prev_vec_out_LY_dqPE6; dfdq_upd_prev_vec_reg_LZ_dqPE6 = dfdq_upd_prev_vec_out_LZ_dqPE6; 
      // dqPE7
      dfdq_upd_prev_vec_reg_AX_dqPE7 = dfdq_upd_prev_vec_out_AX_dqPE7; dfdq_upd_prev_vec_reg_AY_dqPE7 = dfdq_upd_prev_vec_out_AY_dqPE7; dfdq_upd_prev_vec_reg_AZ_dqPE7 = dfdq_upd_prev_vec_out_AZ_dqPE7; dfdq_upd_prev_vec_reg_LX_dqPE7 = dfdq_upd_prev_vec_out_LX_dqPE7; dfdq_upd_prev_vec_reg_LY_dqPE7 = dfdq_upd_prev_vec_out_LY_dqPE7; dfdq_upd_prev_vec_reg_LZ_dqPE7 = dfdq_upd_prev_vec_out_LZ_dqPE7; 
      // dqdPE1
      dfdqd_upd_prev_vec_reg_AX_dqdPE1 = dfdqd_upd_prev_vec_out_AX_dqdPE1; dfdqd_upd_prev_vec_reg_AY_dqdPE1 = dfdqd_upd_prev_vec_out_AY_dqdPE1; dfdqd_upd_prev_vec_reg_AZ_dqdPE1 = dfdqd_upd_prev_vec_out_AZ_dqdPE1; dfdqd_upd_prev_vec_reg_LX_dqdPE1 = dfdqd_upd_prev_vec_out_LX_dqdPE1; dfdqd_upd_prev_vec_reg_LY_dqdPE1 = dfdqd_upd_prev_vec_out_LY_dqdPE1; dfdqd_upd_prev_vec_reg_LZ_dqdPE1 = dfdqd_upd_prev_vec_out_LZ_dqdPE1; 
      // dqdPE2
      dfdqd_upd_prev_vec_reg_AX_dqdPE2 = dfdqd_upd_prev_vec_out_AX_dqdPE2; dfdqd_upd_prev_vec_reg_AY_dqdPE2 = dfdqd_upd_prev_vec_out_AY_dqdPE2; dfdqd_upd_prev_vec_reg_AZ_dqdPE2 = dfdqd_upd_prev_vec_out_AZ_dqdPE2; dfdqd_upd_prev_vec_reg_LX_dqdPE2 = dfdqd_upd_prev_vec_out_LX_dqdPE2; dfdqd_upd_prev_vec_reg_LY_dqdPE2 = dfdqd_upd_prev_vec_out_LY_dqdPE2; dfdqd_upd_prev_vec_reg_LZ_dqdPE2 = dfdqd_upd_prev_vec_out_LZ_dqdPE2; 
      // dqdPE3
      dfdqd_upd_prev_vec_reg_AX_dqdPE3 = dfdqd_upd_prev_vec_out_AX_dqdPE3; dfdqd_upd_prev_vec_reg_AY_dqdPE3 = dfdqd_upd_prev_vec_out_AY_dqdPE3; dfdqd_upd_prev_vec_reg_AZ_dqdPE3 = dfdqd_upd_prev_vec_out_AZ_dqdPE3; dfdqd_upd_prev_vec_reg_LX_dqdPE3 = dfdqd_upd_prev_vec_out_LX_dqdPE3; dfdqd_upd_prev_vec_reg_LY_dqdPE3 = dfdqd_upd_prev_vec_out_LY_dqdPE3; dfdqd_upd_prev_vec_reg_LZ_dqdPE3 = dfdqd_upd_prev_vec_out_LZ_dqdPE3; 
      // dqdPE4
      dfdqd_upd_prev_vec_reg_AX_dqdPE4 = dfdqd_upd_prev_vec_out_AX_dqdPE4; dfdqd_upd_prev_vec_reg_AY_dqdPE4 = dfdqd_upd_prev_vec_out_AY_dqdPE4; dfdqd_upd_prev_vec_reg_AZ_dqdPE4 = dfdqd_upd_prev_vec_out_AZ_dqdPE4; dfdqd_upd_prev_vec_reg_LX_dqdPE4 = dfdqd_upd_prev_vec_out_LX_dqdPE4; dfdqd_upd_prev_vec_reg_LY_dqdPE4 = dfdqd_upd_prev_vec_out_LY_dqdPE4; dfdqd_upd_prev_vec_reg_LZ_dqdPE4 = dfdqd_upd_prev_vec_out_LZ_dqdPE4; 
      // dqdPE5
      dfdqd_upd_prev_vec_reg_AX_dqdPE5 = dfdqd_upd_prev_vec_out_AX_dqdPE5; dfdqd_upd_prev_vec_reg_AY_dqdPE5 = dfdqd_upd_prev_vec_out_AY_dqdPE5; dfdqd_upd_prev_vec_reg_AZ_dqdPE5 = dfdqd_upd_prev_vec_out_AZ_dqdPE5; dfdqd_upd_prev_vec_reg_LX_dqdPE5 = dfdqd_upd_prev_vec_out_LX_dqdPE5; dfdqd_upd_prev_vec_reg_LY_dqdPE5 = dfdqd_upd_prev_vec_out_LY_dqdPE5; dfdqd_upd_prev_vec_reg_LZ_dqdPE5 = dfdqd_upd_prev_vec_out_LZ_dqdPE5; 
      // dqdPE6
      dfdqd_upd_prev_vec_reg_AX_dqdPE6 = dfdqd_upd_prev_vec_out_AX_dqdPE6; dfdqd_upd_prev_vec_reg_AY_dqdPE6 = dfdqd_upd_prev_vec_out_AY_dqdPE6; dfdqd_upd_prev_vec_reg_AZ_dqdPE6 = dfdqd_upd_prev_vec_out_AZ_dqdPE6; dfdqd_upd_prev_vec_reg_LX_dqdPE6 = dfdqd_upd_prev_vec_out_LX_dqdPE6; dfdqd_upd_prev_vec_reg_LY_dqdPE6 = dfdqd_upd_prev_vec_out_LY_dqdPE6; dfdqd_upd_prev_vec_reg_LZ_dqdPE6 = dfdqd_upd_prev_vec_out_LZ_dqdPE6; 
      // dqdPE7
      dfdqd_upd_prev_vec_reg_AX_dqdPE7 = dfdqd_upd_prev_vec_out_AX_dqdPE7; dfdqd_upd_prev_vec_reg_AY_dqdPE7 = dfdqd_upd_prev_vec_out_AY_dqdPE7; dfdqd_upd_prev_vec_reg_AZ_dqdPE7 = dfdqd_upd_prev_vec_out_AZ_dqdPE7; dfdqd_upd_prev_vec_reg_LX_dqdPE7 = dfdqd_upd_prev_vec_out_LX_dqdPE7; dfdqd_upd_prev_vec_reg_LY_dqdPE7 = dfdqd_upd_prev_vec_out_LY_dqdPE7; dfdqd_upd_prev_vec_reg_LZ_dqdPE7 = dfdqd_upd_prev_vec_out_LZ_dqdPE7; 
      //------------------------------------------------------------------------
      // Extra Clock Cycles
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
