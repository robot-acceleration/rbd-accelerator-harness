Reg#(Bit#(32)) idx_backward_feed <- mkReg(0);
Reg#(Bit#(32)) idx_backward_stream <- mkReg(0);

Reg#(Vector#(7, Vector#(7, Bit#(32)))) dtaudq <- mkReg(unpack(0));
Reg#(Vector#(7, Vector#(7, Bit#(32)))) dtaudqd <- mkReg(unpack(0));

Reg#(Vector#(7, Vector#(7, Bit#(32)))) minv_dtaudq <- mkReg(unpack(0));
Reg#(Vector#(7, Vector#(7, Bit#(32)))) minv_dtaudqd <- mkReg(unpack(0));

Reg#(Bit#(32)) offset_out <- mkReg(0);
Ehr#(2,Bool) flip <- mkEhr(True);
Ehr#(2,Bool) mul_mat <-mkEhr(False);
Reg#(Bool) keep_backward <-mkReg(True);

// True is feed, False is stream
Ehr#(2,Bool) block_minv_phase <- mkEhr(True);

rule restart_bw (!mul_mat[0] && !keep_backward);
    keep_backward <= True;
endrule

//*******************************/
//   SCHEDULE TABLES BPROC       /
//*******************************/

Bit#(32) len_bproc_sched = 8;

Vector#(8, Bit#(4)) rnea_bproc_curr_sched = 
    vec(8,7,6,5,4,3,2,1);

Vector#(8, Bit#(4)) rnea_bproc_par_sched = 
    vec(7,6,5,4,3,2,1,0);

Vector#(8, Vector#(7, Bit#(4))) bproc_curr_sched = vec(
    vec(8,8,8,8,8,8,8),
    vec(7,7,7,7,7,7,7),
    vec(6,6,6,6,6,6,6),
    vec(5,5,5,5,5,5,5),
    vec(4,4,4,4,4,4,4),
    vec(3,3,3,3,3,3,3),
    vec(2,2,2,2,2,2,2),
    vec(1,1,1,1,1,1,1)
);
Vector#(8, Vector#(7, Bit#(4))) bproc_par_sched = vec(
    vec(7,7,7,7,7,7,7),
    vec(6,6,6,6,6,6,6),
    vec(5,5,5,5,5,5,5),
    vec(4,4,4,4,4,4,4),
    vec(3,3,3,3,3,3,3),
    vec(2,2,2,2,2,2,2),
    vec(1,1,1,1,1,1,1),
    vec(0,0,0,0,0,0,0)
);

Vector#(8, Vector#(7, Bit#(4))) bproc_derv_sched = vec(
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7)
);

// s/8/NUM_LINKS+2 because we use up to link 8 and is 1-indexed
Vector#(8,Reg#(FUpdIntermediate)) f_upd_acc <- replicateM(mkReg(unpack(0)));

// for bproc ext branching
// s/8/NUM_PES+1
Vector#(8,Reg#(DfUpdIntermediate)) df_upd_prev <- replicateM(mkReg(unpack(0)));
// s/1/NUM_BRANCHES+1
// s/8/NUM_PES+1
Vector#(8, Vector#(1,Reg#(DfUpdIntermediate))) df_upd_branch <- replicateM(replicateM(mkReg(unpack(0))));

function Bit#(4) branchTableBproc(Bit#(4) branch_link);
    case (branch_link)
        default: return 0;
    endcase
endfunction

function DfUpdIntermediate selectDfUpdBranch(Bit#(4) curr_link, Bit#(4) curr_PE);
    return df_upd_prev[curr_PE];
endfunction

//*******************************/
//******** BLOCK MINV MULTIPLICATION SCHEDULE ******/

// We represent the matmul as lh_matrix * rh_matrix = output_matrix
// in our case, lh_matrix is minv, rh_matrix is dtau{dq,dqd}
// output_matrix is minv_dtau{dq,dqd}

// We multiply lh_tile * rh_tile and increment output_tile by the
// resulting block output.

// Each PE does: matrix * col-vector = col-vector
// The lh_tile * rh_tile matmul happens column-wise, where we have each PE
// processing one column of rh_tile, and outputing one column of output_tile.
// So:
// PE1: lh_tile * rh_tile[][0] = output_tile[][0]
// PE2: lh_tile * rh_tile[][1] = output_tile[][1]
// ...
// PE7: lh_tile * rh_tile[][6] = output_tile[][6]

Bit#(1) n_tiles = 1;
// n_rows_tile = n_cols_tile = 7
Bit#(3) tile_size = 7;

// s/Bit#(3)/number of times we need to iterate over tiles
Bit#(32) len_block_minv_sched_per_matrix = 1;
// since we go both dtaudq and dtaudqd, so twice of entire schedule
// length
Bit#(32) len_block_minv_sched_total = len_block_minv_sched_per_matrix * 2;

Reg#(Bit#(32)) idx_block_minv_feed <- mkReg(0);
Reg#(Bit#(32)) idx_block_minv_stream <- mkReg(0);

// we have the same block schedule for dtaudq and dtaudqd

// {lh,rh,output}_tile_{incr}_sched just kept to easily read tile sched
Vector#(1, Vector#(7, Bit#(1))) lh_tile_sched = vec(
    vec(0,0,0,0,0,0,0)
);

Vector#(1, Vector#(7, Bit#(1))) rh_tile_sched = vec(
    vec(0,0,0,0,0,0,0)
);

// which tile on the output matrix should the result be added to
Vector#(1, Vector#(7, Bit#(1))) output_tile_incr_sched = vec(
    vec(0,0,0,0,0,0,0)
);

Vector#(1, Vector#(7, Bit#(4))) lh_tile_row_start_sched = vec(
    vec(0,0,0,0,0,0,0)
);

Vector#(1, Vector#(7, Bit#(4))) rh_tile_row_start_sched = vec(
    vec(0,0,0,0,0,0,0)
);

// which tile on the output matrix should the result be added to
Vector#(1, Vector#(7, Bit#(4))) output_tile_row_start_sched = vec(
    vec(0,0,0,0,0,0,0)
);

Vector#(1, Vector#(7, Bit#(4))) lh_tile_col_start_sched = vec(
    vec(0,0,0,0,0,0,0)
);

Vector#(1, Vector#(7, Bit#(4))) rh_tile_col_start_sched = vec(
    vec(0,0,0,0,0,0,0)
);

// which tile on the output matrix should the result be added to
Vector#(1, Vector#(7, Bit#(4))) output_tile_col_start_sched = vec(
    vec(0,0,0,0,0,0,0)
);


// s/Bit#(4)/number of cols per tile
// this serves as both the input rh_tile col schedule, and the output_tile col
// we slot the output col into.
Vector#(1, Vector#(7, Bit#(4))) rh_tile_col_sched = vec(
    vec(0,1,2,3,4,5,6)
);


//*******************************/

rule feedBproc (flip[0] && !mul_mat[0] && keep_backward && idx_backward_feed < len_bproc_sched);
    $display("=========== BPROC FEED for idx ", idx_backward_feed, " =============");

    flip[0] <= !flip[0];

    if (idx_backward_feed == len_bproc_sched-1) begin
        idx_backward_feed <= 0;
    end
    else begin
        idx_backward_feed <= idx_backward_feed + 1;
    end

    let intermediate = intermediate_values.first();
    let trigo = trigo_values.first();

    //*******************************************

    // Getting link ids for different components of the schedule
    let link_in_curr_rnea = rnea_bproc_curr_sched[idx_backward_feed];
    let link_in_par_rnea = rnea_bproc_par_sched[idx_backward_feed];
    Bit#(4) link_in_curr_PE1 = 0;
    Bit#(4) link_in_par_PE1 = 0;
    Bit#(4) link_in_derv_PE1 = 0;
    Bit#(4) link_in_curr_PE2 = 0;
    Bit#(4) link_in_par_PE2 = 0;
    Bit#(4) link_in_derv_PE2 = 0;
    Bit#(4) link_in_curr_PE3 = 0;
    Bit#(4) link_in_par_PE3 = 0;
    Bit#(4) link_in_derv_PE3 = 0;
    Bit#(4) link_in_curr_PE4 = 0;
    Bit#(4) link_in_par_PE4 = 0;
    Bit#(4) link_in_derv_PE4 = 0;
    Bit#(4) link_in_curr_PE5 = 0;
    Bit#(4) link_in_par_PE5 = 0;
    Bit#(4) link_in_derv_PE5 = 0;
    Bit#(4) link_in_curr_PE6 = 0;
    Bit#(4) link_in_par_PE6 = 0;
    Bit#(4) link_in_derv_PE6 = 0;
    Bit#(4) link_in_curr_PE7 = 0;
    Bit#(4) link_in_par_PE7 = 0;
    Bit#(4) link_in_derv_PE7 = 0;

`include "GradientPipelineBprocSchedUnrolling.bsv"

    // grabbing the input values are 1-indexed
    let input_curr_rnea = intermediate[link_in_curr_rnea];
    let input_par_rnea = intermediate[link_in_par_rnea];
    let input_curr_PE1 = intermediate[link_in_curr_PE1];
    let input_curr_PE2 = intermediate[link_in_curr_PE2];
    let input_curr_PE3 = intermediate[link_in_curr_PE3];
    let input_curr_PE4 = intermediate[link_in_curr_PE4];
    let input_curr_PE5 = intermediate[link_in_curr_PE5];
    let input_curr_PE6 = intermediate[link_in_curr_PE6];
    let input_curr_PE7 = intermediate[link_in_curr_PE7];

    let input_par_PE1 = intermediate[link_in_par_PE1];
    let input_par_PE2 = intermediate[link_in_par_PE2];
    let input_par_PE3 = intermediate[link_in_par_PE3];
    let input_par_PE4 = intermediate[link_in_par_PE4];
    let input_par_PE5 = intermediate[link_in_par_PE5];
    let input_par_PE6 = intermediate[link_in_par_PE6];
    let input_par_PE7 = intermediate[link_in_par_PE7];

    // external branches
    let df_upd_PE1 = selectDfUpdBranch(link_in_curr_PE1,1);
    let df_upd_PE2 = selectDfUpdBranch(link_in_curr_PE2,2);
    let df_upd_PE3 = selectDfUpdBranch(link_in_curr_PE3,3);
    let df_upd_PE4 = selectDfUpdBranch(link_in_curr_PE4,4);
    let df_upd_PE5 = selectDfUpdBranch(link_in_curr_PE5,5);
    let df_upd_PE6 = selectDfUpdBranch(link_in_curr_PE6,6);
    let df_upd_PE7 = selectDfUpdBranch(link_in_curr_PE7,7);

    //********************************************

    //-----------------------------------

    bproc.get_data();

    //------- RNEA INPUTS ---------

    bproc.link_in_rnea(link_in_curr_rnea);
    bproc.sinq_val_in_rnea(trigo[link_in_curr_rnea].sinq);
    bproc.cosq_val_in_rnea(trigo[link_in_curr_rnea].cosq);
    bproc.f_prev_vec_in_AX_rnea(intermediate[link_in_par_rnea].f[0]);
    bproc.f_prev_vec_in_AY_rnea(intermediate[link_in_par_rnea].f[1]);
    bproc.f_prev_vec_in_AZ_rnea(intermediate[link_in_par_rnea].f[2]);
    bproc.f_prev_vec_in_LX_rnea(intermediate[link_in_par_rnea].f[3]);
    bproc.f_prev_vec_in_LY_rnea(intermediate[link_in_par_rnea].f[4]);
    bproc.f_prev_vec_in_LZ_rnea(intermediate[link_in_par_rnea].f[5]);
    bproc.f_upd_curr_vec_in_AX_rnea(f_upd_acc[link_in_curr_rnea].f_upd[0]);
    bproc.f_upd_curr_vec_in_AY_rnea(f_upd_acc[link_in_curr_rnea].f_upd[1]);
    bproc.f_upd_curr_vec_in_AZ_rnea(f_upd_acc[link_in_curr_rnea].f_upd[2]);
    bproc.f_upd_curr_vec_in_LX_rnea(f_upd_acc[link_in_curr_rnea].f_upd[3]);
    bproc.f_upd_curr_vec_in_LY_rnea(f_upd_acc[link_in_curr_rnea].f_upd[4]);
    bproc.f_upd_curr_vec_in_LZ_rnea(f_upd_acc[link_in_curr_rnea].f_upd[5]);

    //-----------------------------

    //------- DQ INPUTS -----------

    bproc.link_in_dqPE1(link_in_curr_PE1);
    bproc.derv_in_dqPE1(link_in_derv_PE1);
    bproc.sinq_val_in_dqPE1(trigo[link_in_curr_PE1].sinq);
    bproc.cosq_val_in_dqPE1(trigo[link_in_curr_PE1].cosq);
    bproc.dfdq_prev_vec_in_AX_dqPE1(input_par_PE1.dfidq[0][link_in_derv_PE1-1]);
    bproc.dfdq_prev_vec_in_AY_dqPE1(input_par_PE1.dfidq[1][link_in_derv_PE1-1]);
    bproc.dfdq_prev_vec_in_AZ_dqPE1(input_par_PE1.dfidq[2][link_in_derv_PE1-1]);
    bproc.dfdq_prev_vec_in_LX_dqPE1(input_par_PE1.dfidq[3][link_in_derv_PE1-1]);
    bproc.dfdq_prev_vec_in_LY_dqPE1(input_par_PE1.dfidq[4][link_in_derv_PE1-1]);
    bproc.dfdq_prev_vec_in_LZ_dqPE1(input_par_PE1.dfidq[5][link_in_derv_PE1-1]);
    bproc.f_upd_curr_vec_in_AX_dqPE1(f_upd_acc[link_in_curr_PE1].f_upd[0]);
    bproc.f_upd_curr_vec_in_AY_dqPE1(f_upd_acc[link_in_curr_PE1].f_upd[1]);
    bproc.f_upd_curr_vec_in_AZ_dqPE1(f_upd_acc[link_in_curr_PE1].f_upd[2]);
    bproc.f_upd_curr_vec_in_LX_dqPE1(f_upd_acc[link_in_curr_PE1].f_upd[3]);
    bproc.f_upd_curr_vec_in_LY_dqPE1(f_upd_acc[link_in_curr_PE1].f_upd[4]);
    bproc.f_upd_curr_vec_in_LZ_dqPE1(f_upd_acc[link_in_curr_PE1].f_upd[5]);
    bproc.dfdq_upd_curr_vec_in_AX_dqPE1(df_upd_PE1.dfdq_upd[0]);
    bproc.dfdq_upd_curr_vec_in_AY_dqPE1(df_upd_PE1.dfdq_upd[1]);
    bproc.dfdq_upd_curr_vec_in_AZ_dqPE1(df_upd_PE1.dfdq_upd[2]);
    bproc.dfdq_upd_curr_vec_in_LX_dqPE1(df_upd_PE1.dfdq_upd[3]);
    bproc.dfdq_upd_curr_vec_in_LY_dqPE1(df_upd_PE1.dfdq_upd[4]);
    bproc.dfdq_upd_curr_vec_in_LZ_dqPE1(df_upd_PE1.dfdq_upd[5]);

    bproc.link_in_dqPE2(link_in_curr_PE2);
    bproc.derv_in_dqPE2(link_in_derv_PE2);
    bproc.sinq_val_in_dqPE2(trigo[link_in_curr_PE2].sinq);
    bproc.cosq_val_in_dqPE2(trigo[link_in_curr_PE2].cosq);
    bproc.dfdq_prev_vec_in_AX_dqPE2(input_par_PE2.dfidq[0][link_in_derv_PE2-1]);
    bproc.dfdq_prev_vec_in_AY_dqPE2(input_par_PE2.dfidq[1][link_in_derv_PE2-1]);
    bproc.dfdq_prev_vec_in_AZ_dqPE2(input_par_PE2.dfidq[2][link_in_derv_PE2-1]);
    bproc.dfdq_prev_vec_in_LX_dqPE2(input_par_PE2.dfidq[3][link_in_derv_PE2-1]);
    bproc.dfdq_prev_vec_in_LY_dqPE2(input_par_PE2.dfidq[4][link_in_derv_PE2-1]);
    bproc.dfdq_prev_vec_in_LZ_dqPE2(input_par_PE2.dfidq[5][link_in_derv_PE2-1]);
    bproc.f_upd_curr_vec_in_AX_dqPE2(f_upd_acc[link_in_curr_PE2].f_upd[0]);
    bproc.f_upd_curr_vec_in_AY_dqPE2(f_upd_acc[link_in_curr_PE2].f_upd[1]);
    bproc.f_upd_curr_vec_in_AZ_dqPE2(f_upd_acc[link_in_curr_PE2].f_upd[2]);
    bproc.f_upd_curr_vec_in_LX_dqPE2(f_upd_acc[link_in_curr_PE2].f_upd[3]);
    bproc.f_upd_curr_vec_in_LY_dqPE2(f_upd_acc[link_in_curr_PE2].f_upd[4]);
    bproc.f_upd_curr_vec_in_LZ_dqPE2(f_upd_acc[link_in_curr_PE2].f_upd[5]);
    bproc.dfdq_upd_curr_vec_in_AX_dqPE2(df_upd_PE2.dfdq_upd[0]);
    bproc.dfdq_upd_curr_vec_in_AY_dqPE2(df_upd_PE2.dfdq_upd[1]);
    bproc.dfdq_upd_curr_vec_in_AZ_dqPE2(df_upd_PE2.dfdq_upd[2]);
    bproc.dfdq_upd_curr_vec_in_LX_dqPE2(df_upd_PE2.dfdq_upd[3]);
    bproc.dfdq_upd_curr_vec_in_LY_dqPE2(df_upd_PE2.dfdq_upd[4]);
    bproc.dfdq_upd_curr_vec_in_LZ_dqPE2(df_upd_PE2.dfdq_upd[5]);

    bproc.link_in_dqPE3(link_in_curr_PE3);
    bproc.derv_in_dqPE3(link_in_derv_PE3);
    bproc.sinq_val_in_dqPE3(trigo[link_in_curr_PE3].sinq);
    bproc.cosq_val_in_dqPE3(trigo[link_in_curr_PE3].cosq);
    bproc.dfdq_prev_vec_in_AX_dqPE3(input_par_PE3.dfidq[0][link_in_derv_PE3-1]);
    bproc.dfdq_prev_vec_in_AY_dqPE3(input_par_PE3.dfidq[1][link_in_derv_PE3-1]);
    bproc.dfdq_prev_vec_in_AZ_dqPE3(input_par_PE3.dfidq[2][link_in_derv_PE3-1]);
    bproc.dfdq_prev_vec_in_LX_dqPE3(input_par_PE3.dfidq[3][link_in_derv_PE3-1]);
    bproc.dfdq_prev_vec_in_LY_dqPE3(input_par_PE3.dfidq[4][link_in_derv_PE3-1]);
    bproc.dfdq_prev_vec_in_LZ_dqPE3(input_par_PE3.dfidq[5][link_in_derv_PE3-1]);
    bproc.f_upd_curr_vec_in_AX_dqPE3(f_upd_acc[link_in_curr_PE3].f_upd[0]);
    bproc.f_upd_curr_vec_in_AY_dqPE3(f_upd_acc[link_in_curr_PE3].f_upd[1]);
    bproc.f_upd_curr_vec_in_AZ_dqPE3(f_upd_acc[link_in_curr_PE3].f_upd[2]);
    bproc.f_upd_curr_vec_in_LX_dqPE3(f_upd_acc[link_in_curr_PE3].f_upd[3]);
    bproc.f_upd_curr_vec_in_LY_dqPE3(f_upd_acc[link_in_curr_PE3].f_upd[4]);
    bproc.f_upd_curr_vec_in_LZ_dqPE3(f_upd_acc[link_in_curr_PE3].f_upd[5]);
    bproc.dfdq_upd_curr_vec_in_AX_dqPE3(df_upd_PE3.dfdq_upd[0]);
    bproc.dfdq_upd_curr_vec_in_AY_dqPE3(df_upd_PE3.dfdq_upd[1]);
    bproc.dfdq_upd_curr_vec_in_AZ_dqPE3(df_upd_PE3.dfdq_upd[2]);
    bproc.dfdq_upd_curr_vec_in_LX_dqPE3(df_upd_PE3.dfdq_upd[3]);
    bproc.dfdq_upd_curr_vec_in_LY_dqPE3(df_upd_PE3.dfdq_upd[4]);
    bproc.dfdq_upd_curr_vec_in_LZ_dqPE3(df_upd_PE3.dfdq_upd[5]);

    bproc.link_in_dqPE4(link_in_curr_PE4);
    bproc.derv_in_dqPE4(link_in_derv_PE4);
    bproc.sinq_val_in_dqPE4(trigo[link_in_curr_PE4].sinq);
    bproc.cosq_val_in_dqPE4(trigo[link_in_curr_PE4].cosq);
    bproc.dfdq_prev_vec_in_AX_dqPE4(input_par_PE4.dfidq[0][link_in_derv_PE4-1]);
    bproc.dfdq_prev_vec_in_AY_dqPE4(input_par_PE4.dfidq[1][link_in_derv_PE4-1]);
    bproc.dfdq_prev_vec_in_AZ_dqPE4(input_par_PE4.dfidq[2][link_in_derv_PE4-1]);
    bproc.dfdq_prev_vec_in_LX_dqPE4(input_par_PE4.dfidq[3][link_in_derv_PE4-1]);
    bproc.dfdq_prev_vec_in_LY_dqPE4(input_par_PE4.dfidq[4][link_in_derv_PE4-1]);
    bproc.dfdq_prev_vec_in_LZ_dqPE4(input_par_PE4.dfidq[5][link_in_derv_PE4-1]);
    bproc.f_upd_curr_vec_in_AX_dqPE4(f_upd_acc[link_in_curr_PE4].f_upd[0]);
    bproc.f_upd_curr_vec_in_AY_dqPE4(f_upd_acc[link_in_curr_PE4].f_upd[1]);
    bproc.f_upd_curr_vec_in_AZ_dqPE4(f_upd_acc[link_in_curr_PE4].f_upd[2]);
    bproc.f_upd_curr_vec_in_LX_dqPE4(f_upd_acc[link_in_curr_PE4].f_upd[3]);
    bproc.f_upd_curr_vec_in_LY_dqPE4(f_upd_acc[link_in_curr_PE4].f_upd[4]);
    bproc.f_upd_curr_vec_in_LZ_dqPE4(f_upd_acc[link_in_curr_PE4].f_upd[5]);
    bproc.dfdq_upd_curr_vec_in_AX_dqPE4(df_upd_PE4.dfdq_upd[0]);
    bproc.dfdq_upd_curr_vec_in_AY_dqPE4(df_upd_PE4.dfdq_upd[1]);
    bproc.dfdq_upd_curr_vec_in_AZ_dqPE4(df_upd_PE4.dfdq_upd[2]);
    bproc.dfdq_upd_curr_vec_in_LX_dqPE4(df_upd_PE4.dfdq_upd[3]);
    bproc.dfdq_upd_curr_vec_in_LY_dqPE4(df_upd_PE4.dfdq_upd[4]);
    bproc.dfdq_upd_curr_vec_in_LZ_dqPE4(df_upd_PE4.dfdq_upd[5]);

    bproc.link_in_dqPE5(link_in_curr_PE5);
    bproc.derv_in_dqPE5(link_in_derv_PE5);
    bproc.sinq_val_in_dqPE5(trigo[link_in_curr_PE5].sinq);
    bproc.cosq_val_in_dqPE5(trigo[link_in_curr_PE5].cosq);
    bproc.dfdq_prev_vec_in_AX_dqPE5(input_par_PE5.dfidq[0][link_in_derv_PE5-1]);
    bproc.dfdq_prev_vec_in_AY_dqPE5(input_par_PE5.dfidq[1][link_in_derv_PE5-1]);
    bproc.dfdq_prev_vec_in_AZ_dqPE5(input_par_PE5.dfidq[2][link_in_derv_PE5-1]);
    bproc.dfdq_prev_vec_in_LX_dqPE5(input_par_PE5.dfidq[3][link_in_derv_PE5-1]);
    bproc.dfdq_prev_vec_in_LY_dqPE5(input_par_PE5.dfidq[4][link_in_derv_PE5-1]);
    bproc.dfdq_prev_vec_in_LZ_dqPE5(input_par_PE5.dfidq[5][link_in_derv_PE5-1]);
    bproc.f_upd_curr_vec_in_AX_dqPE5(f_upd_acc[link_in_curr_PE5].f_upd[0]);
    bproc.f_upd_curr_vec_in_AY_dqPE5(f_upd_acc[link_in_curr_PE5].f_upd[1]);
    bproc.f_upd_curr_vec_in_AZ_dqPE5(f_upd_acc[link_in_curr_PE5].f_upd[2]);
    bproc.f_upd_curr_vec_in_LX_dqPE5(f_upd_acc[link_in_curr_PE5].f_upd[3]);
    bproc.f_upd_curr_vec_in_LY_dqPE5(f_upd_acc[link_in_curr_PE5].f_upd[4]);
    bproc.f_upd_curr_vec_in_LZ_dqPE5(f_upd_acc[link_in_curr_PE5].f_upd[5]);
    bproc.dfdq_upd_curr_vec_in_AX_dqPE5(df_upd_PE5.dfdq_upd[0]);
    bproc.dfdq_upd_curr_vec_in_AY_dqPE5(df_upd_PE5.dfdq_upd[1]);
    bproc.dfdq_upd_curr_vec_in_AZ_dqPE5(df_upd_PE5.dfdq_upd[2]);
    bproc.dfdq_upd_curr_vec_in_LX_dqPE5(df_upd_PE5.dfdq_upd[3]);
    bproc.dfdq_upd_curr_vec_in_LY_dqPE5(df_upd_PE5.dfdq_upd[4]);
    bproc.dfdq_upd_curr_vec_in_LZ_dqPE5(df_upd_PE5.dfdq_upd[5]);

    bproc.link_in_dqPE6(link_in_curr_PE6);
    bproc.derv_in_dqPE6(link_in_derv_PE6);
    bproc.sinq_val_in_dqPE6(trigo[link_in_curr_PE6].sinq);
    bproc.cosq_val_in_dqPE6(trigo[link_in_curr_PE6].cosq);
    bproc.dfdq_prev_vec_in_AX_dqPE6(input_par_PE6.dfidq[0][link_in_derv_PE6-1]);
    bproc.dfdq_prev_vec_in_AY_dqPE6(input_par_PE6.dfidq[1][link_in_derv_PE6-1]);
    bproc.dfdq_prev_vec_in_AZ_dqPE6(input_par_PE6.dfidq[2][link_in_derv_PE6-1]);
    bproc.dfdq_prev_vec_in_LX_dqPE6(input_par_PE6.dfidq[3][link_in_derv_PE6-1]);
    bproc.dfdq_prev_vec_in_LY_dqPE6(input_par_PE6.dfidq[4][link_in_derv_PE6-1]);
    bproc.dfdq_prev_vec_in_LZ_dqPE6(input_par_PE6.dfidq[5][link_in_derv_PE6-1]);
    bproc.f_upd_curr_vec_in_AX_dqPE6(f_upd_acc[link_in_curr_PE6].f_upd[0]);
    bproc.f_upd_curr_vec_in_AY_dqPE6(f_upd_acc[link_in_curr_PE6].f_upd[1]);
    bproc.f_upd_curr_vec_in_AZ_dqPE6(f_upd_acc[link_in_curr_PE6].f_upd[2]);
    bproc.f_upd_curr_vec_in_LX_dqPE6(f_upd_acc[link_in_curr_PE6].f_upd[3]);
    bproc.f_upd_curr_vec_in_LY_dqPE6(f_upd_acc[link_in_curr_PE6].f_upd[4]);
    bproc.f_upd_curr_vec_in_LZ_dqPE6(f_upd_acc[link_in_curr_PE6].f_upd[5]);
    bproc.dfdq_upd_curr_vec_in_AX_dqPE6(df_upd_PE6.dfdq_upd[0]);
    bproc.dfdq_upd_curr_vec_in_AY_dqPE6(df_upd_PE6.dfdq_upd[1]);
    bproc.dfdq_upd_curr_vec_in_AZ_dqPE6(df_upd_PE6.dfdq_upd[2]);
    bproc.dfdq_upd_curr_vec_in_LX_dqPE6(df_upd_PE6.dfdq_upd[3]);
    bproc.dfdq_upd_curr_vec_in_LY_dqPE6(df_upd_PE6.dfdq_upd[4]);
    bproc.dfdq_upd_curr_vec_in_LZ_dqPE6(df_upd_PE6.dfdq_upd[5]);

    bproc.link_in_dqPE7(link_in_curr_PE7);
    bproc.derv_in_dqPE7(link_in_derv_PE7);
    bproc.sinq_val_in_dqPE7(trigo[link_in_curr_PE7].sinq);
    bproc.cosq_val_in_dqPE7(trigo[link_in_curr_PE7].cosq);
    bproc.dfdq_prev_vec_in_AX_dqPE7(input_par_PE7.dfidq[0][link_in_derv_PE7-1]);
    bproc.dfdq_prev_vec_in_AY_dqPE7(input_par_PE7.dfidq[1][link_in_derv_PE7-1]);
    bproc.dfdq_prev_vec_in_AZ_dqPE7(input_par_PE7.dfidq[2][link_in_derv_PE7-1]);
    bproc.dfdq_prev_vec_in_LX_dqPE7(input_par_PE7.dfidq[3][link_in_derv_PE7-1]);
    bproc.dfdq_prev_vec_in_LY_dqPE7(input_par_PE7.dfidq[4][link_in_derv_PE7-1]);
    bproc.dfdq_prev_vec_in_LZ_dqPE7(input_par_PE7.dfidq[5][link_in_derv_PE7-1]);
    bproc.f_upd_curr_vec_in_AX_dqPE7(f_upd_acc[link_in_curr_PE7].f_upd[0]);
    bproc.f_upd_curr_vec_in_AY_dqPE7(f_upd_acc[link_in_curr_PE7].f_upd[1]);
    bproc.f_upd_curr_vec_in_AZ_dqPE7(f_upd_acc[link_in_curr_PE7].f_upd[2]);
    bproc.f_upd_curr_vec_in_LX_dqPE7(f_upd_acc[link_in_curr_PE7].f_upd[3]);
    bproc.f_upd_curr_vec_in_LY_dqPE7(f_upd_acc[link_in_curr_PE7].f_upd[4]);
    bproc.f_upd_curr_vec_in_LZ_dqPE7(f_upd_acc[link_in_curr_PE7].f_upd[5]);
    bproc.dfdq_upd_curr_vec_in_AX_dqPE7(df_upd_PE7.dfdq_upd[0]);
    bproc.dfdq_upd_curr_vec_in_AY_dqPE7(df_upd_PE7.dfdq_upd[1]);
    bproc.dfdq_upd_curr_vec_in_AZ_dqPE7(df_upd_PE7.dfdq_upd[2]);
    bproc.dfdq_upd_curr_vec_in_LX_dqPE7(df_upd_PE7.dfdq_upd[3]);
    bproc.dfdq_upd_curr_vec_in_LY_dqPE7(df_upd_PE7.dfdq_upd[4]);
    bproc.dfdq_upd_curr_vec_in_LZ_dqPE7(df_upd_PE7.dfdq_upd[5]);

    //-----------------------------

    //------- DQD INPUTS -----------

    bproc.link_in_dqdPE1(link_in_curr_PE1);
    bproc.derv_in_dqdPE1(link_in_derv_PE1);
    bproc.sinq_val_in_dqdPE1(trigo[link_in_curr_PE1].sinq);
    bproc.cosq_val_in_dqdPE1(trigo[link_in_curr_PE1].cosq);
    bproc.dfdqd_prev_vec_in_AX_dqdPE1(input_par_PE1.dfidqd[0][link_in_derv_PE1-1]);
    bproc.dfdqd_prev_vec_in_AY_dqdPE1(input_par_PE1.dfidqd[1][link_in_derv_PE1-1]);
    bproc.dfdqd_prev_vec_in_AZ_dqdPE1(input_par_PE1.dfidqd[2][link_in_derv_PE1-1]);
    bproc.dfdqd_prev_vec_in_LX_dqdPE1(input_par_PE1.dfidqd[3][link_in_derv_PE1-1]);
    bproc.dfdqd_prev_vec_in_LY_dqdPE1(input_par_PE1.dfidqd[4][link_in_derv_PE1-1]);
    bproc.dfdqd_prev_vec_in_LZ_dqdPE1(input_par_PE1.dfidqd[5][link_in_derv_PE1-1]);
    bproc.dfdqd_upd_curr_vec_in_AX_dqdPE1(df_upd_PE1.dfdqd_upd[0]);
    bproc.dfdqd_upd_curr_vec_in_AY_dqdPE1(df_upd_PE1.dfdqd_upd[1]);
    bproc.dfdqd_upd_curr_vec_in_AZ_dqdPE1(df_upd_PE1.dfdqd_upd[2]);
    bproc.dfdqd_upd_curr_vec_in_LX_dqdPE1(df_upd_PE1.dfdqd_upd[3]);
    bproc.dfdqd_upd_curr_vec_in_LY_dqdPE1(df_upd_PE1.dfdqd_upd[4]);
    bproc.dfdqd_upd_curr_vec_in_LZ_dqdPE1(df_upd_PE1.dfdqd_upd[5]);

    bproc.link_in_dqdPE2(link_in_curr_PE2);
    bproc.derv_in_dqdPE2(link_in_derv_PE2);
    bproc.sinq_val_in_dqdPE2(trigo[link_in_curr_PE2].sinq);
    bproc.cosq_val_in_dqdPE2(trigo[link_in_curr_PE2].cosq);
    bproc.dfdqd_prev_vec_in_AX_dqdPE2(input_par_PE2.dfidqd[0][link_in_derv_PE2-1]);
    bproc.dfdqd_prev_vec_in_AY_dqdPE2(input_par_PE2.dfidqd[1][link_in_derv_PE2-1]);
    bproc.dfdqd_prev_vec_in_AZ_dqdPE2(input_par_PE2.dfidqd[2][link_in_derv_PE2-1]);
    bproc.dfdqd_prev_vec_in_LX_dqdPE2(input_par_PE2.dfidqd[3][link_in_derv_PE2-1]);
    bproc.dfdqd_prev_vec_in_LY_dqdPE2(input_par_PE2.dfidqd[4][link_in_derv_PE2-1]);
    bproc.dfdqd_prev_vec_in_LZ_dqdPE2(input_par_PE2.dfidqd[5][link_in_derv_PE2-1]);
    bproc.dfdqd_upd_curr_vec_in_AX_dqdPE2(df_upd_PE2.dfdqd_upd[0]);
    bproc.dfdqd_upd_curr_vec_in_AY_dqdPE2(df_upd_PE2.dfdqd_upd[1]);
    bproc.dfdqd_upd_curr_vec_in_AZ_dqdPE2(df_upd_PE2.dfdqd_upd[2]);
    bproc.dfdqd_upd_curr_vec_in_LX_dqdPE2(df_upd_PE2.dfdqd_upd[3]);
    bproc.dfdqd_upd_curr_vec_in_LY_dqdPE2(df_upd_PE2.dfdqd_upd[4]);
    bproc.dfdqd_upd_curr_vec_in_LZ_dqdPE2(df_upd_PE2.dfdqd_upd[5]);

    bproc.link_in_dqdPE3(link_in_curr_PE3);
    bproc.derv_in_dqdPE3(link_in_derv_PE3);
    bproc.sinq_val_in_dqdPE3(trigo[link_in_curr_PE3].sinq);
    bproc.cosq_val_in_dqdPE3(trigo[link_in_curr_PE3].cosq);
    bproc.dfdqd_prev_vec_in_AX_dqdPE3(input_par_PE3.dfidqd[0][link_in_derv_PE3-1]);
    bproc.dfdqd_prev_vec_in_AY_dqdPE3(input_par_PE3.dfidqd[1][link_in_derv_PE3-1]);
    bproc.dfdqd_prev_vec_in_AZ_dqdPE3(input_par_PE3.dfidqd[2][link_in_derv_PE3-1]);
    bproc.dfdqd_prev_vec_in_LX_dqdPE3(input_par_PE3.dfidqd[3][link_in_derv_PE3-1]);
    bproc.dfdqd_prev_vec_in_LY_dqdPE3(input_par_PE3.dfidqd[4][link_in_derv_PE3-1]);
    bproc.dfdqd_prev_vec_in_LZ_dqdPE3(input_par_PE3.dfidqd[5][link_in_derv_PE3-1]);
    bproc.dfdqd_upd_curr_vec_in_AX_dqdPE3(df_upd_PE3.dfdqd_upd[0]);
    bproc.dfdqd_upd_curr_vec_in_AY_dqdPE3(df_upd_PE3.dfdqd_upd[1]);
    bproc.dfdqd_upd_curr_vec_in_AZ_dqdPE3(df_upd_PE3.dfdqd_upd[2]);
    bproc.dfdqd_upd_curr_vec_in_LX_dqdPE3(df_upd_PE3.dfdqd_upd[3]);
    bproc.dfdqd_upd_curr_vec_in_LY_dqdPE3(df_upd_PE3.dfdqd_upd[4]);
    bproc.dfdqd_upd_curr_vec_in_LZ_dqdPE3(df_upd_PE3.dfdqd_upd[5]);

    bproc.link_in_dqdPE4(link_in_curr_PE4);
    bproc.derv_in_dqdPE4(link_in_derv_PE4);
    bproc.sinq_val_in_dqdPE4(trigo[link_in_curr_PE4].sinq);
    bproc.cosq_val_in_dqdPE4(trigo[link_in_curr_PE4].cosq);
    bproc.dfdqd_prev_vec_in_AX_dqdPE4(input_par_PE4.dfidqd[0][link_in_derv_PE4-1]);
    bproc.dfdqd_prev_vec_in_AY_dqdPE4(input_par_PE4.dfidqd[1][link_in_derv_PE4-1]);
    bproc.dfdqd_prev_vec_in_AZ_dqdPE4(input_par_PE4.dfidqd[2][link_in_derv_PE4-1]);
    bproc.dfdqd_prev_vec_in_LX_dqdPE4(input_par_PE4.dfidqd[3][link_in_derv_PE4-1]);
    bproc.dfdqd_prev_vec_in_LY_dqdPE4(input_par_PE4.dfidqd[4][link_in_derv_PE4-1]);
    bproc.dfdqd_prev_vec_in_LZ_dqdPE4(input_par_PE4.dfidqd[5][link_in_derv_PE4-1]);
    bproc.dfdqd_upd_curr_vec_in_AX_dqdPE4(df_upd_PE4.dfdqd_upd[0]);
    bproc.dfdqd_upd_curr_vec_in_AY_dqdPE4(df_upd_PE4.dfdqd_upd[1]);
    bproc.dfdqd_upd_curr_vec_in_AZ_dqdPE4(df_upd_PE4.dfdqd_upd[2]);
    bproc.dfdqd_upd_curr_vec_in_LX_dqdPE4(df_upd_PE4.dfdqd_upd[3]);
    bproc.dfdqd_upd_curr_vec_in_LY_dqdPE4(df_upd_PE4.dfdqd_upd[4]);
    bproc.dfdqd_upd_curr_vec_in_LZ_dqdPE4(df_upd_PE4.dfdqd_upd[5]);

    bproc.link_in_dqdPE5(link_in_curr_PE5);
    bproc.derv_in_dqdPE5(link_in_derv_PE5);
    bproc.sinq_val_in_dqdPE5(trigo[link_in_curr_PE5].sinq);
    bproc.cosq_val_in_dqdPE5(trigo[link_in_curr_PE5].cosq);
    bproc.dfdqd_prev_vec_in_AX_dqdPE5(input_par_PE5.dfidqd[0][link_in_derv_PE5-1]);
    bproc.dfdqd_prev_vec_in_AY_dqdPE5(input_par_PE5.dfidqd[1][link_in_derv_PE5-1]);
    bproc.dfdqd_prev_vec_in_AZ_dqdPE5(input_par_PE5.dfidqd[2][link_in_derv_PE5-1]);
    bproc.dfdqd_prev_vec_in_LX_dqdPE5(input_par_PE5.dfidqd[3][link_in_derv_PE5-1]);
    bproc.dfdqd_prev_vec_in_LY_dqdPE5(input_par_PE5.dfidqd[4][link_in_derv_PE5-1]);
    bproc.dfdqd_prev_vec_in_LZ_dqdPE5(input_par_PE5.dfidqd[5][link_in_derv_PE5-1]);
    bproc.dfdqd_upd_curr_vec_in_AX_dqdPE5(df_upd_PE5.dfdqd_upd[0]);
    bproc.dfdqd_upd_curr_vec_in_AY_dqdPE5(df_upd_PE5.dfdqd_upd[1]);
    bproc.dfdqd_upd_curr_vec_in_AZ_dqdPE5(df_upd_PE5.dfdqd_upd[2]);
    bproc.dfdqd_upd_curr_vec_in_LX_dqdPE5(df_upd_PE5.dfdqd_upd[3]);
    bproc.dfdqd_upd_curr_vec_in_LY_dqdPE5(df_upd_PE5.dfdqd_upd[4]);
    bproc.dfdqd_upd_curr_vec_in_LZ_dqdPE5(df_upd_PE5.dfdqd_upd[5]);

    bproc.link_in_dqdPE6(link_in_curr_PE6);
    bproc.derv_in_dqdPE6(link_in_derv_PE6);
    bproc.sinq_val_in_dqdPE6(trigo[link_in_curr_PE6].sinq);
    bproc.cosq_val_in_dqdPE6(trigo[link_in_curr_PE6].cosq);
    bproc.dfdqd_prev_vec_in_AX_dqdPE6(input_par_PE6.dfidqd[0][link_in_derv_PE6-1]);
    bproc.dfdqd_prev_vec_in_AY_dqdPE6(input_par_PE6.dfidqd[1][link_in_derv_PE6-1]);
    bproc.dfdqd_prev_vec_in_AZ_dqdPE6(input_par_PE6.dfidqd[2][link_in_derv_PE6-1]);
    bproc.dfdqd_prev_vec_in_LX_dqdPE6(input_par_PE6.dfidqd[3][link_in_derv_PE6-1]);
    bproc.dfdqd_prev_vec_in_LY_dqdPE6(input_par_PE6.dfidqd[4][link_in_derv_PE6-1]);
    bproc.dfdqd_prev_vec_in_LZ_dqdPE6(input_par_PE6.dfidqd[5][link_in_derv_PE6-1]);
    bproc.dfdqd_upd_curr_vec_in_AX_dqdPE6(df_upd_PE6.dfdqd_upd[0]);
    bproc.dfdqd_upd_curr_vec_in_AY_dqdPE6(df_upd_PE6.dfdqd_upd[1]);
    bproc.dfdqd_upd_curr_vec_in_AZ_dqdPE6(df_upd_PE6.dfdqd_upd[2]);
    bproc.dfdqd_upd_curr_vec_in_LX_dqdPE6(df_upd_PE6.dfdqd_upd[3]);
    bproc.dfdqd_upd_curr_vec_in_LY_dqdPE6(df_upd_PE6.dfdqd_upd[4]);
    bproc.dfdqd_upd_curr_vec_in_LZ_dqdPE6(df_upd_PE6.dfdqd_upd[5]);

    bproc.link_in_dqdPE7(link_in_curr_PE7);
    bproc.derv_in_dqdPE7(link_in_derv_PE7);
    bproc.sinq_val_in_dqdPE7(trigo[link_in_curr_PE7].sinq);
    bproc.cosq_val_in_dqdPE7(trigo[link_in_curr_PE7].cosq);
    bproc.dfdqd_prev_vec_in_AX_dqdPE7(input_par_PE7.dfidqd[0][link_in_derv_PE7-1]);
    bproc.dfdqd_prev_vec_in_AY_dqdPE7(input_par_PE7.dfidqd[1][link_in_derv_PE7-1]);
    bproc.dfdqd_prev_vec_in_AZ_dqdPE7(input_par_PE7.dfidqd[2][link_in_derv_PE7-1]);
    bproc.dfdqd_prev_vec_in_LX_dqdPE7(input_par_PE7.dfidqd[3][link_in_derv_PE7-1]);
    bproc.dfdqd_prev_vec_in_LY_dqdPE7(input_par_PE7.dfidqd[4][link_in_derv_PE7-1]);
    bproc.dfdqd_prev_vec_in_LZ_dqdPE7(input_par_PE7.dfidqd[5][link_in_derv_PE7-1]);
    bproc.dfdqd_upd_curr_vec_in_AX_dqdPE7(df_upd_PE7.dfdqd_upd[0]);
    bproc.dfdqd_upd_curr_vec_in_AY_dqdPE7(df_upd_PE7.dfdqd_upd[1]);
    bproc.dfdqd_upd_curr_vec_in_AZ_dqdPE7(df_upd_PE7.dfdqd_upd[2]);
    bproc.dfdqd_upd_curr_vec_in_LX_dqdPE7(df_upd_PE7.dfdqd_upd[3]);
    bproc.dfdqd_upd_curr_vec_in_LY_dqdPE7(df_upd_PE7.dfdqd_upd[4]);
    bproc.dfdqd_upd_curr_vec_in_LZ_dqdPE7(df_upd_PE7.dfdqd_upd[5]);

    //-----------------------------

    $display("=========== BPROC FEED for idx ", idx_backward_feed, " END =============");

endrule

// this is because we grab matmul results when we reach the end of the schedule
rule streamBproc (!flip[1] && unpack(bproc.output_ready()) && !mul_mat[1] && keep_backward && idx_backward_stream < len_bproc_sched);

    $display("=========== BPROC STREAM for idx ", idx_backward_stream, " =============");

    if (idx_backward_stream == len_bproc_sched-1) begin
        idx_backward_stream <= 0;
    end
    else begin          
        idx_backward_stream <= idx_backward_stream + 1;
    end

    flip[1] <= !flip[1];

    //****************************************

    let link_out_curr_rnea = rnea_bproc_curr_sched[idx_backward_stream];
    let link_out_par_rnea = rnea_bproc_par_sched[idx_backward_stream];

    //*******************************************

    //********* DTAUDQ OUTPUT REDIRECTION ********/

    let dtau_curr_out_dqPE1 = bproc.dtau_curr_out_dqPE1();
    let dtau_curr_out_dqPE2 = bproc.dtau_curr_out_dqPE2();
    let dtau_curr_out_dqPE3 = bproc.dtau_curr_out_dqPE3();
    let dtau_curr_out_dqPE4 = bproc.dtau_curr_out_dqPE4();
    let dtau_curr_out_dqPE5 = bproc.dtau_curr_out_dqPE5();
    let dtau_curr_out_dqPE6 = bproc.dtau_curr_out_dqPE6();
    let dtau_curr_out_dqPE7 = bproc.dtau_curr_out_dqPE7();
    let dtau_curr_out_dqdPE1 = bproc.dtau_curr_out_dqdPE1();
    let dtau_curr_out_dqdPE2 = bproc.dtau_curr_out_dqdPE2();
    let dtau_curr_out_dqdPE3 = bproc.dtau_curr_out_dqdPE3();
    let dtau_curr_out_dqdPE4 = bproc.dtau_curr_out_dqdPE4();
    let dtau_curr_out_dqdPE5 = bproc.dtau_curr_out_dqdPE5();
    let dtau_curr_out_dqdPE6 = bproc.dtau_curr_out_dqdPE6();
    let dtau_curr_out_dqdPE7 = bproc.dtau_curr_out_dqdPE7();

    //*******************************************

    //********* RNEA OUTPUT REDIRECTION ********/

    let f_upd_prev_vec_out_AX_rnea = bproc.f_upd_prev_vec_out_AX_rnea();
    let f_upd_prev_vec_out_AY_rnea = bproc.f_upd_prev_vec_out_AY_rnea();
    let f_upd_prev_vec_out_AZ_rnea = bproc.f_upd_prev_vec_out_AZ_rnea();
    let f_upd_prev_vec_out_LX_rnea = bproc.f_upd_prev_vec_out_LX_rnea();
    let f_upd_prev_vec_out_LY_rnea = bproc.f_upd_prev_vec_out_LY_rnea();
    let f_upd_prev_vec_out_LZ_rnea = bproc.f_upd_prev_vec_out_LZ_rnea();

    //*******************************************

    //********* DQPE OUTPUT REDIRECTION ********/


    let dfdq_upd_prev_vec_out_AX_dqPE1 = bproc.dfdq_upd_prev_vec_out_AX_dqPE1();
    let dfdq_upd_prev_vec_out_AY_dqPE1 = bproc.dfdq_upd_prev_vec_out_AY_dqPE1();
    let dfdq_upd_prev_vec_out_AZ_dqPE1 = bproc.dfdq_upd_prev_vec_out_AZ_dqPE1();
    let dfdq_upd_prev_vec_out_LX_dqPE1 = bproc.dfdq_upd_prev_vec_out_LX_dqPE1();
    let dfdq_upd_prev_vec_out_LY_dqPE1 = bproc.dfdq_upd_prev_vec_out_LY_dqPE1();
    let dfdq_upd_prev_vec_out_LZ_dqPE1 = bproc.dfdq_upd_prev_vec_out_LZ_dqPE1();
    let dfdq_upd_prev_vec_out_AX_dqPE2 = bproc.dfdq_upd_prev_vec_out_AX_dqPE2();
    let dfdq_upd_prev_vec_out_AY_dqPE2 = bproc.dfdq_upd_prev_vec_out_AY_dqPE2();
    let dfdq_upd_prev_vec_out_AZ_dqPE2 = bproc.dfdq_upd_prev_vec_out_AZ_dqPE2();
    let dfdq_upd_prev_vec_out_LX_dqPE2 = bproc.dfdq_upd_prev_vec_out_LX_dqPE2();
    let dfdq_upd_prev_vec_out_LY_dqPE2 = bproc.dfdq_upd_prev_vec_out_LY_dqPE2();
    let dfdq_upd_prev_vec_out_LZ_dqPE2 = bproc.dfdq_upd_prev_vec_out_LZ_dqPE2();
    let dfdq_upd_prev_vec_out_AX_dqPE3 = bproc.dfdq_upd_prev_vec_out_AX_dqPE3();
    let dfdq_upd_prev_vec_out_AY_dqPE3 = bproc.dfdq_upd_prev_vec_out_AY_dqPE3();
    let dfdq_upd_prev_vec_out_AZ_dqPE3 = bproc.dfdq_upd_prev_vec_out_AZ_dqPE3();
    let dfdq_upd_prev_vec_out_LX_dqPE3 = bproc.dfdq_upd_prev_vec_out_LX_dqPE3();
    let dfdq_upd_prev_vec_out_LY_dqPE3 = bproc.dfdq_upd_prev_vec_out_LY_dqPE3();
    let dfdq_upd_prev_vec_out_LZ_dqPE3 = bproc.dfdq_upd_prev_vec_out_LZ_dqPE3();
    let dfdq_upd_prev_vec_out_AX_dqPE4 = bproc.dfdq_upd_prev_vec_out_AX_dqPE4();
    let dfdq_upd_prev_vec_out_AY_dqPE4 = bproc.dfdq_upd_prev_vec_out_AY_dqPE4();
    let dfdq_upd_prev_vec_out_AZ_dqPE4 = bproc.dfdq_upd_prev_vec_out_AZ_dqPE4();
    let dfdq_upd_prev_vec_out_LX_dqPE4 = bproc.dfdq_upd_prev_vec_out_LX_dqPE4();
    let dfdq_upd_prev_vec_out_LY_dqPE4 = bproc.dfdq_upd_prev_vec_out_LY_dqPE4();
    let dfdq_upd_prev_vec_out_LZ_dqPE4 = bproc.dfdq_upd_prev_vec_out_LZ_dqPE4();
    let dfdq_upd_prev_vec_out_AX_dqPE5 = bproc.dfdq_upd_prev_vec_out_AX_dqPE5();
    let dfdq_upd_prev_vec_out_AY_dqPE5 = bproc.dfdq_upd_prev_vec_out_AY_dqPE5();
    let dfdq_upd_prev_vec_out_AZ_dqPE5 = bproc.dfdq_upd_prev_vec_out_AZ_dqPE5();
    let dfdq_upd_prev_vec_out_LX_dqPE5 = bproc.dfdq_upd_prev_vec_out_LX_dqPE5();
    let dfdq_upd_prev_vec_out_LY_dqPE5 = bproc.dfdq_upd_prev_vec_out_LY_dqPE5();
    let dfdq_upd_prev_vec_out_LZ_dqPE5 = bproc.dfdq_upd_prev_vec_out_LZ_dqPE5();
    let dfdq_upd_prev_vec_out_AX_dqPE6 = bproc.dfdq_upd_prev_vec_out_AX_dqPE6();
    let dfdq_upd_prev_vec_out_AY_dqPE6 = bproc.dfdq_upd_prev_vec_out_AY_dqPE6();
    let dfdq_upd_prev_vec_out_AZ_dqPE6 = bproc.dfdq_upd_prev_vec_out_AZ_dqPE6();
    let dfdq_upd_prev_vec_out_LX_dqPE6 = bproc.dfdq_upd_prev_vec_out_LX_dqPE6();
    let dfdq_upd_prev_vec_out_LY_dqPE6 = bproc.dfdq_upd_prev_vec_out_LY_dqPE6();
    let dfdq_upd_prev_vec_out_LZ_dqPE6 = bproc.dfdq_upd_prev_vec_out_LZ_dqPE6();
    let dfdq_upd_prev_vec_out_AX_dqPE7 = bproc.dfdq_upd_prev_vec_out_AX_dqPE7();
    let dfdq_upd_prev_vec_out_AY_dqPE7 = bproc.dfdq_upd_prev_vec_out_AY_dqPE7();
    let dfdq_upd_prev_vec_out_AZ_dqPE7 = bproc.dfdq_upd_prev_vec_out_AZ_dqPE7();
    let dfdq_upd_prev_vec_out_LX_dqPE7 = bproc.dfdq_upd_prev_vec_out_LX_dqPE7();
    let dfdq_upd_prev_vec_out_LY_dqPE7 = bproc.dfdq_upd_prev_vec_out_LY_dqPE7();
    let dfdq_upd_prev_vec_out_LZ_dqPE7 = bproc.dfdq_upd_prev_vec_out_LZ_dqPE7();
    
    //*******************************************

    //********* DQDPE OUTPUT REDIRECTION ********/

    let dfdqd_upd_prev_vec_out_AX_dqdPE1 = bproc.dfdqd_upd_prev_vec_out_AX_dqdPE1();
    let dfdqd_upd_prev_vec_out_AY_dqdPE1 = bproc.dfdqd_upd_prev_vec_out_AY_dqdPE1();
    let dfdqd_upd_prev_vec_out_AZ_dqdPE1 = bproc.dfdqd_upd_prev_vec_out_AZ_dqdPE1();
    let dfdqd_upd_prev_vec_out_LX_dqdPE1 = bproc.dfdqd_upd_prev_vec_out_LX_dqdPE1();
    let dfdqd_upd_prev_vec_out_LY_dqdPE1 = bproc.dfdqd_upd_prev_vec_out_LY_dqdPE1();
    let dfdqd_upd_prev_vec_out_LZ_dqdPE1 = bproc.dfdqd_upd_prev_vec_out_LZ_dqdPE1();
    let dfdqd_upd_prev_vec_out_AX_dqdPE2 = bproc.dfdqd_upd_prev_vec_out_AX_dqdPE2();
    let dfdqd_upd_prev_vec_out_AY_dqdPE2 = bproc.dfdqd_upd_prev_vec_out_AY_dqdPE2();
    let dfdqd_upd_prev_vec_out_AZ_dqdPE2 = bproc.dfdqd_upd_prev_vec_out_AZ_dqdPE2();
    let dfdqd_upd_prev_vec_out_LX_dqdPE2 = bproc.dfdqd_upd_prev_vec_out_LX_dqdPE2();
    let dfdqd_upd_prev_vec_out_LY_dqdPE2 = bproc.dfdqd_upd_prev_vec_out_LY_dqdPE2();
    let dfdqd_upd_prev_vec_out_LZ_dqdPE2 = bproc.dfdqd_upd_prev_vec_out_LZ_dqdPE2();
    let dfdqd_upd_prev_vec_out_AX_dqdPE3 = bproc.dfdqd_upd_prev_vec_out_AX_dqdPE3();
    let dfdqd_upd_prev_vec_out_AY_dqdPE3 = bproc.dfdqd_upd_prev_vec_out_AY_dqdPE3();
    let dfdqd_upd_prev_vec_out_AZ_dqdPE3 = bproc.dfdqd_upd_prev_vec_out_AZ_dqdPE3();
    let dfdqd_upd_prev_vec_out_LX_dqdPE3 = bproc.dfdqd_upd_prev_vec_out_LX_dqdPE3();
    let dfdqd_upd_prev_vec_out_LY_dqdPE3 = bproc.dfdqd_upd_prev_vec_out_LY_dqdPE3();
    let dfdqd_upd_prev_vec_out_LZ_dqdPE3 = bproc.dfdqd_upd_prev_vec_out_LZ_dqdPE3();
    let dfdqd_upd_prev_vec_out_AX_dqdPE4 = bproc.dfdqd_upd_prev_vec_out_AX_dqdPE4();
    let dfdqd_upd_prev_vec_out_AY_dqdPE4 = bproc.dfdqd_upd_prev_vec_out_AY_dqdPE4();
    let dfdqd_upd_prev_vec_out_AZ_dqdPE4 = bproc.dfdqd_upd_prev_vec_out_AZ_dqdPE4();
    let dfdqd_upd_prev_vec_out_LX_dqdPE4 = bproc.dfdqd_upd_prev_vec_out_LX_dqdPE4();
    let dfdqd_upd_prev_vec_out_LY_dqdPE4 = bproc.dfdqd_upd_prev_vec_out_LY_dqdPE4();
    let dfdqd_upd_prev_vec_out_LZ_dqdPE4 = bproc.dfdqd_upd_prev_vec_out_LZ_dqdPE4();
    let dfdqd_upd_prev_vec_out_AX_dqdPE5 = bproc.dfdqd_upd_prev_vec_out_AX_dqdPE5();
    let dfdqd_upd_prev_vec_out_AY_dqdPE5 = bproc.dfdqd_upd_prev_vec_out_AY_dqdPE5();
    let dfdqd_upd_prev_vec_out_AZ_dqdPE5 = bproc.dfdqd_upd_prev_vec_out_AZ_dqdPE5();
    let dfdqd_upd_prev_vec_out_LX_dqdPE5 = bproc.dfdqd_upd_prev_vec_out_LX_dqdPE5();
    let dfdqd_upd_prev_vec_out_LY_dqdPE5 = bproc.dfdqd_upd_prev_vec_out_LY_dqdPE5();
    let dfdqd_upd_prev_vec_out_LZ_dqdPE5 = bproc.dfdqd_upd_prev_vec_out_LZ_dqdPE5();
    let dfdqd_upd_prev_vec_out_AX_dqdPE6 = bproc.dfdqd_upd_prev_vec_out_AX_dqdPE6();
    let dfdqd_upd_prev_vec_out_AY_dqdPE6 = bproc.dfdqd_upd_prev_vec_out_AY_dqdPE6();
    let dfdqd_upd_prev_vec_out_AZ_dqdPE6 = bproc.dfdqd_upd_prev_vec_out_AZ_dqdPE6();
    let dfdqd_upd_prev_vec_out_LX_dqdPE6 = bproc.dfdqd_upd_prev_vec_out_LX_dqdPE6();
    let dfdqd_upd_prev_vec_out_LY_dqdPE6 = bproc.dfdqd_upd_prev_vec_out_LY_dqdPE6();
    let dfdqd_upd_prev_vec_out_LZ_dqdPE6 = bproc.dfdqd_upd_prev_vec_out_LZ_dqdPE6();
    let dfdqd_upd_prev_vec_out_AX_dqdPE7 = bproc.dfdqd_upd_prev_vec_out_AX_dqdPE7();
    let dfdqd_upd_prev_vec_out_AY_dqdPE7 = bproc.dfdqd_upd_prev_vec_out_AY_dqdPE7();
    let dfdqd_upd_prev_vec_out_AZ_dqdPE7 = bproc.dfdqd_upd_prev_vec_out_AZ_dqdPE7();
    let dfdqd_upd_prev_vec_out_LX_dqdPE7 = bproc.dfdqd_upd_prev_vec_out_LX_dqdPE7();
    let dfdqd_upd_prev_vec_out_LY_dqdPE7 = bproc.dfdqd_upd_prev_vec_out_LY_dqdPE7();
    let dfdqd_upd_prev_vec_out_LZ_dqdPE7 = bproc.dfdqd_upd_prev_vec_out_LZ_dqdPE7();

//    Vector#(7, Bit#(32)) dtaudq_row = vec(dtau_curr_out_dqPE1, dtau_curr_out_dqPE2, dtau_curr_out_dqPE3, dtau_curr_out_dqPE4, dtau_curr_out_dqPE5, dtau_curr_out_dqPE6, dtau_curr_out_dqPE7);
//    Vector#(7, Bit#(32)) dtaudqd_row = vec(dtau_curr_out_dqdPE1, dtau_curr_out_dqdPE2, dtau_curr_out_dqdPE3, dtau_curr_out_dqdPE4, dtau_curr_out_dqdPE5, dtau_curr_out_dqdPE6, dtau_curr_out_dqdPE7);
//    $display("row out idx stream: ", fshow(idx_backward_stream));
//    $display("dtaudq_row: ", fshow(dtaudq_row));
//    $display("dtaudqd_row: ", fshow(dtaudqd_row));

    let new_dtaudq = dtaudq;
    let new_dtaudqd = dtaudqd;
    
`include "GradientPipelineBprocDtauUpdateUnrolling.bsv"

    dtaudq <= new_dtaudq;
    dtaudqd <= new_dtaudqd;

    //*******************************************

    Vector#(6,Bit#(32)) vec_f_upd_rnea = vec(f_upd_prev_vec_out_AX_rnea,f_upd_prev_vec_out_AY_rnea,f_upd_prev_vec_out_AZ_rnea,f_upd_prev_vec_out_LX_rnea,f_upd_prev_vec_out_LY_rnea,f_upd_prev_vec_out_LZ_rnea);

    Vector#(6,Bit#(32)) vec_dfdq_upd_PE1 = vec(dfdq_upd_prev_vec_out_AX_dqPE1,dfdq_upd_prev_vec_out_AY_dqPE1,dfdq_upd_prev_vec_out_AZ_dqPE1,dfdq_upd_prev_vec_out_LX_dqPE1,dfdq_upd_prev_vec_out_LY_dqPE1,dfdq_upd_prev_vec_out_LZ_dqPE1);
    Vector#(6,Bit#(32)) vec_dfdq_upd_PE2 = vec(dfdq_upd_prev_vec_out_AX_dqPE2,dfdq_upd_prev_vec_out_AY_dqPE2,dfdq_upd_prev_vec_out_AZ_dqPE2,dfdq_upd_prev_vec_out_LX_dqPE2,dfdq_upd_prev_vec_out_LY_dqPE2,dfdq_upd_prev_vec_out_LZ_dqPE2);
    Vector#(6,Bit#(32)) vec_dfdq_upd_PE3 = vec(dfdq_upd_prev_vec_out_AX_dqPE3,dfdq_upd_prev_vec_out_AY_dqPE3,dfdq_upd_prev_vec_out_AZ_dqPE3,dfdq_upd_prev_vec_out_LX_dqPE3,dfdq_upd_prev_vec_out_LY_dqPE3,dfdq_upd_prev_vec_out_LZ_dqPE3);
    Vector#(6,Bit#(32)) vec_dfdq_upd_PE4 = vec(dfdq_upd_prev_vec_out_AX_dqPE4,dfdq_upd_prev_vec_out_AY_dqPE4,dfdq_upd_prev_vec_out_AZ_dqPE4,dfdq_upd_prev_vec_out_LX_dqPE4,dfdq_upd_prev_vec_out_LY_dqPE4,dfdq_upd_prev_vec_out_LZ_dqPE4);
    Vector#(6,Bit#(32)) vec_dfdq_upd_PE5 = vec(dfdq_upd_prev_vec_out_AX_dqPE5,dfdq_upd_prev_vec_out_AY_dqPE5,dfdq_upd_prev_vec_out_AZ_dqPE5,dfdq_upd_prev_vec_out_LX_dqPE5,dfdq_upd_prev_vec_out_LY_dqPE5,dfdq_upd_prev_vec_out_LZ_dqPE5);
    Vector#(6,Bit#(32)) vec_dfdq_upd_PE6 = vec(dfdq_upd_prev_vec_out_AX_dqPE6,dfdq_upd_prev_vec_out_AY_dqPE6,dfdq_upd_prev_vec_out_AZ_dqPE6,dfdq_upd_prev_vec_out_LX_dqPE6,dfdq_upd_prev_vec_out_LY_dqPE6,dfdq_upd_prev_vec_out_LZ_dqPE6);
    Vector#(6,Bit#(32)) vec_dfdq_upd_PE7 = vec(dfdq_upd_prev_vec_out_AX_dqPE7,dfdq_upd_prev_vec_out_AY_dqPE7,dfdq_upd_prev_vec_out_AZ_dqPE7,dfdq_upd_prev_vec_out_LX_dqPE7,dfdq_upd_prev_vec_out_LY_dqPE7,dfdq_upd_prev_vec_out_LZ_dqPE7);

    Vector#(6,Bit#(32)) vec_dfdqd_upd_PE1 = vec(dfdqd_upd_prev_vec_out_AX_dqdPE1,dfdqd_upd_prev_vec_out_AY_dqdPE1,dfdqd_upd_prev_vec_out_AZ_dqdPE1,dfdqd_upd_prev_vec_out_LX_dqdPE1,dfdqd_upd_prev_vec_out_LY_dqdPE1,dfdqd_upd_prev_vec_out_LZ_dqdPE1);
    Vector#(6,Bit#(32)) vec_dfdqd_upd_PE2 = vec(dfdqd_upd_prev_vec_out_AX_dqdPE2,dfdqd_upd_prev_vec_out_AY_dqdPE2,dfdqd_upd_prev_vec_out_AZ_dqdPE2,dfdqd_upd_prev_vec_out_LX_dqdPE2,dfdqd_upd_prev_vec_out_LY_dqdPE2,dfdqd_upd_prev_vec_out_LZ_dqdPE2);
    Vector#(6,Bit#(32)) vec_dfdqd_upd_PE3 = vec(dfdqd_upd_prev_vec_out_AX_dqdPE3,dfdqd_upd_prev_vec_out_AY_dqdPE3,dfdqd_upd_prev_vec_out_AZ_dqdPE3,dfdqd_upd_prev_vec_out_LX_dqdPE3,dfdqd_upd_prev_vec_out_LY_dqdPE3,dfdqd_upd_prev_vec_out_LZ_dqdPE3);
    Vector#(6,Bit#(32)) vec_dfdqd_upd_PE4 = vec(dfdqd_upd_prev_vec_out_AX_dqdPE4,dfdqd_upd_prev_vec_out_AY_dqdPE4,dfdqd_upd_prev_vec_out_AZ_dqdPE4,dfdqd_upd_prev_vec_out_LX_dqdPE4,dfdqd_upd_prev_vec_out_LY_dqdPE4,dfdqd_upd_prev_vec_out_LZ_dqdPE4);
    Vector#(6,Bit#(32)) vec_dfdqd_upd_PE5 = vec(dfdqd_upd_prev_vec_out_AX_dqdPE5,dfdqd_upd_prev_vec_out_AY_dqdPE5,dfdqd_upd_prev_vec_out_AZ_dqdPE5,dfdqd_upd_prev_vec_out_LX_dqdPE5,dfdqd_upd_prev_vec_out_LY_dqdPE5,dfdqd_upd_prev_vec_out_LZ_dqdPE5);
    Vector#(6,Bit#(32)) vec_dfdqd_upd_PE6 = vec(dfdqd_upd_prev_vec_out_AX_dqdPE6,dfdqd_upd_prev_vec_out_AY_dqdPE6,dfdqd_upd_prev_vec_out_AZ_dqdPE6,dfdqd_upd_prev_vec_out_LX_dqdPE6,dfdqd_upd_prev_vec_out_LY_dqdPE6,dfdqd_upd_prev_vec_out_LZ_dqdPE6);
    Vector#(6,Bit#(32)) vec_dfdqd_upd_PE7 = vec(dfdqd_upd_prev_vec_out_AX_dqdPE7,dfdqd_upd_prev_vec_out_AY_dqdPE7,dfdqd_upd_prev_vec_out_AZ_dqdPE7,dfdqd_upd_prev_vec_out_LX_dqdPE7,dfdqd_upd_prev_vec_out_LY_dqdPE7,dfdqd_upd_prev_vec_out_LZ_dqdPE7);

    //*******************************************

    FUpdIntermediate f_upd_rnea = FUpdIntermediate {f_upd: vec_f_upd_rnea};
    FUpdIntermediate f_upd_add;
    let f_upd_reg = f_upd_acc[link_out_par_rnea];
    f_upd_add.f_upd[0] = f_upd_reg.f_upd[0] + f_upd_rnea.f_upd[0];
    f_upd_add.f_upd[1] = f_upd_reg.f_upd[1] + f_upd_rnea.f_upd[1];
    f_upd_add.f_upd[2] = f_upd_reg.f_upd[2] + f_upd_rnea.f_upd[2];
    f_upd_add.f_upd[3] = f_upd_reg.f_upd[3] + f_upd_rnea.f_upd[3];
    f_upd_add.f_upd[4] = f_upd_reg.f_upd[4] + f_upd_rnea.f_upd[4];
    f_upd_add.f_upd[5] = f_upd_reg.f_upd[5] + f_upd_rnea.f_upd[5];

    if (link_out_par_rnea != 0) begin
        //// branching case
        f_upd_acc[link_out_par_rnea] <= f_upd_rnea;
    end

    DfUpdIntermediate df_upd_PE1 = DfUpdIntermediate {dfdqd_upd: unpack(pack(vec_dfdqd_upd_PE1)), dfdq_upd: unpack(pack(vec_dfdq_upd_PE1))};
    DfUpdIntermediate df_upd_PE2 = DfUpdIntermediate {dfdqd_upd: unpack(pack(vec_dfdqd_upd_PE2)), dfdq_upd: unpack(pack(vec_dfdq_upd_PE2))};
    DfUpdIntermediate df_upd_PE3 = DfUpdIntermediate {dfdqd_upd: unpack(pack(vec_dfdqd_upd_PE3)), dfdq_upd: unpack(pack(vec_dfdq_upd_PE3))};
    DfUpdIntermediate df_upd_PE4 = DfUpdIntermediate {dfdqd_upd: unpack(pack(vec_dfdqd_upd_PE4)), dfdq_upd: unpack(pack(vec_dfdq_upd_PE4))};
    DfUpdIntermediate df_upd_PE5 = DfUpdIntermediate {dfdqd_upd: unpack(pack(vec_dfdqd_upd_PE5)), dfdq_upd: unpack(pack(vec_dfdq_upd_PE5))};
    DfUpdIntermediate df_upd_PE6 = DfUpdIntermediate {dfdqd_upd: unpack(pack(vec_dfdqd_upd_PE6)), dfdq_upd: unpack(pack(vec_dfdq_upd_PE6))};
    DfUpdIntermediate df_upd_PE7 = DfUpdIntermediate {dfdqd_upd: unpack(pack(vec_dfdqd_upd_PE7)), dfdq_upd: unpack(pack(vec_dfdq_upd_PE7))};

    for (int i=1; i<=7; i=i+1) begin
        // this is same calculation as link_out_par_PEx, just wanted to for-loopify it
        let link_out_curr_PE = bproc_curr_sched[idx_backward_stream][i-1];
        let link_out_par_PE = bproc_par_sched[idx_backward_stream][i-1];
        DfUpdIntermediate df_upd_PE;
        case(i)
            1: df_upd_PE = df_upd_PE1; 
            2: df_upd_PE = df_upd_PE2; 
            3: df_upd_PE = df_upd_PE3; 
            4: df_upd_PE = df_upd_PE4; 
            5: df_upd_PE = df_upd_PE5; 
            6: df_upd_PE = df_upd_PE6; 
            7: df_upd_PE = df_upd_PE7; 
        endcase

`include "GradientPipelineBprocDfUpdFlush.bsv"

        let df_upd_reg = df_upd_branch[i][branchTableBproc(link_out_par_PE)];
        DfUpdIntermediate df_upd_acc;
        df_upd_acc.dfdq_upd[0] = df_upd_reg.dfdq_upd[0] + df_upd_PE.dfdq_upd[0];
        df_upd_acc.dfdq_upd[1] = df_upd_reg.dfdq_upd[1] + df_upd_PE.dfdq_upd[1];
        df_upd_acc.dfdq_upd[2] = df_upd_reg.dfdq_upd[2] + df_upd_PE.dfdq_upd[2];
        df_upd_acc.dfdq_upd[3] = df_upd_reg.dfdq_upd[3] + df_upd_PE.dfdq_upd[3];
        df_upd_acc.dfdq_upd[4] = df_upd_reg.dfdq_upd[4] + df_upd_PE.dfdq_upd[4];
        df_upd_acc.dfdq_upd[5] = df_upd_reg.dfdq_upd[5] + df_upd_PE.dfdq_upd[5];
        df_upd_acc.dfdqd_upd[0] = df_upd_reg.dfdqd_upd[0] + df_upd_PE.dfdqd_upd[0];
        df_upd_acc.dfdqd_upd[1] = df_upd_reg.dfdqd_upd[1] + df_upd_PE.dfdqd_upd[1];
        df_upd_acc.dfdqd_upd[2] = df_upd_reg.dfdqd_upd[2] + df_upd_PE.dfdqd_upd[2];
        df_upd_acc.dfdqd_upd[3] = df_upd_reg.dfdqd_upd[3] + df_upd_PE.dfdqd_upd[3];
        df_upd_acc.dfdqd_upd[4] = df_upd_reg.dfdqd_upd[4] + df_upd_PE.dfdqd_upd[4];
        df_upd_acc.dfdqd_upd[5] = df_upd_reg.dfdqd_upd[5] + df_upd_PE.dfdqd_upd[5];

        $display("df_upd_prev PE", fshow(i), " dfdqd_upd: ", fshow(df_upd_PE.dfdqd_upd));
        //// branching case
    end

    if (idx_backward_stream == len_bproc_sched-1) begin
        let minv = minv_queue.first();

        $display("feeding first minv tile from streamBproc");
        mul_mat[1] <= !mul_mat[1];
        keep_backward <= False;
        block_minv_phase[0] <= !block_minv_phase[0];
        idx_block_minv_feed <= idx_block_minv_feed + 1;

        // PRINT MINV
        $display("MINV INPUT:");
        for (int i=0; i<7; i=i+1) begin
            $display(fshow(minv[i]));
        end
        // PRINT DTAUDQ
        $display("DTAUDQ INPUT:");
        for (int i=0; i<7; i=i+1) begin
            $display(fshow(new_dtaudq[i]));
        end
        // PRINT DTAUDQD
        $display("DTAUDQD INPUT:");
        for (int i=0; i<7; i=i+1) begin
            $display(fshow(new_dtaudqd[i]));
        end

        bproc.get_data_minv();


`include "GradientPipelineBprocMatmulFirstInputUnrolling.bsv"
    end

    $display("=========== BPROC STREAM for idx ", idx_backward_stream, " END =============");

endrule

rule feedBlockMinv (mul_mat[0] && block_minv_phase[0] && (idx_block_minv_feed < len_block_minv_sched_total-1 || (idx_block_minv_feed == len_block_minv_sched_total-1 && out_data.notFull())));
    $display("ENTERING FEED BLOCK MINV");

    let minv = minv_queue.first();
    block_minv_phase[0] <= !block_minv_phase[0];

    if (idx_block_minv_feed == len_block_minv_sched_total-1) begin
        $display("Fed last minv tile");
        idx_block_minv_feed <= 0;
    end
    else begin
        idx_block_minv_feed <= idx_block_minv_feed + 1;
    end

    Bit#(32) idx_block_minv_feed_dtau;

    Vector#(7, Vector#(7, Bit#(32))) dtau_mat_curr;

    if (idx_block_minv_feed < len_block_minv_sched_per_matrix) begin
        // DTAUDQ
        idx_block_minv_feed_dtau = idx_block_minv_feed;
        dtau_mat_curr = dtaudq;
    end
    else begin
        // DTAUDQD
        idx_block_minv_feed_dtau = idx_block_minv_feed - len_block_minv_sched_per_matrix;
        dtau_mat_curr = dtaudqd;
    end

    $display("MINV BLOCK IN");
//    for (Bit#(4) i=0; i<7; i=i+1) begin
//        $display(fshow(minv[lh_tile_row_start+i][rh_tile_col_start+0]), " ", fshow(minv[lh_tile_row_start+i][rh_tile_col_start+1]), " ", fshow(minv[lh_tile_row_start+i][rh_tile_col_start+2]), " ", fshow(minv[lh_tile_row_start+i][rh_tile_col_start+3]), " ", fshow(minv[lh_tile_row_start+i][rh_tile_col_start+4]), " ", fshow(minv[lh_tile_row_start+i][rh_tile_col_start+5]), " ", fshow(minv[lh_tile_row_start+i][rh_tile_col_start+6]));
//    end

    // MINV INPUT
    bproc.get_data_minv();

`include "GradientPipelineBprocMatmulInputUnrolling.bsv"

endrule

rule streamBlockMinv (mul_mat[1] && unpack(bproc.output_ready_minv()) && !block_minv_phase[1] && idx_block_minv_stream < len_block_minv_sched_total);
    $display("ENTERING STREAM BLOCK MINV");

    block_minv_phase[1] <= !block_minv_phase[1];

    if (idx_block_minv_stream == len_block_minv_sched_total-1) begin
        intermediate_values.deq(); //finished processing that block
        trigo_values.deq(); //finished processing that block
        minv_queue.deq(); //finished processing that block

        $display("completed entire matmul");
        mul_mat[1] <= !mul_mat[1];
        idx_block_minv_stream <= 0;

        //// branching case

        df_upd_prev[1] <= DfUpdIntermediate {dfdqd_upd: unpack(0), dfdq_upd: unpack(0)};
        df_upd_prev[2] <= DfUpdIntermediate {dfdqd_upd: unpack(0), dfdq_upd: unpack(0)};
        df_upd_prev[3] <= DfUpdIntermediate {dfdqd_upd: unpack(0), dfdq_upd: unpack(0)};
        df_upd_prev[4] <= DfUpdIntermediate {dfdqd_upd: unpack(0), dfdq_upd: unpack(0)};
        df_upd_prev[5] <= DfUpdIntermediate {dfdqd_upd: unpack(0), dfdq_upd: unpack(0)};
        df_upd_prev[6] <= DfUpdIntermediate {dfdqd_upd: unpack(0), dfdq_upd: unpack(0)};
        df_upd_prev[7] <= DfUpdIntermediate {dfdqd_upd: unpack(0), dfdq_upd: unpack(0)};

        f_upd_acc[0] <= FUpdIntermediate {f_upd: unpack(0)};
        f_upd_acc[1] <= FUpdIntermediate {f_upd: unpack(0)};
        f_upd_acc[2] <= FUpdIntermediate {f_upd: unpack(0)};
        f_upd_acc[3] <= FUpdIntermediate {f_upd: unpack(0)};
        f_upd_acc[4] <= FUpdIntermediate {f_upd: unpack(0)};
        f_upd_acc[5] <= FUpdIntermediate {f_upd: unpack(0)};
        f_upd_acc[6] <= FUpdIntermediate {f_upd: unpack(0)};
        f_upd_acc[7] <= FUpdIntermediate {f_upd: unpack(0)};
    end
    else begin
        idx_block_minv_stream <= idx_block_minv_stream + 1;
    end

    Vector#(7, Vector#(7, Bit#(32))) new_minv_dtau;

    Bit#(32) idx_block_minv_stream_dtau;
    if (idx_block_minv_stream < len_block_minv_sched_per_matrix) begin
        idx_block_minv_stream_dtau = idx_block_minv_stream;
        new_minv_dtau = minv_dtaudq;
    end
    else begin
        idx_block_minv_stream_dtau = idx_block_minv_stream - len_block_minv_sched_per_matrix;
        new_minv_dtau = minv_dtaudqd;
    end

    let minv_vec_out_R1_dqdPE1 = bproc.minv_vec_out_R1_dqdPE1();
    let minv_vec_out_R2_dqdPE1 = bproc.minv_vec_out_R2_dqdPE1();
    let minv_vec_out_R3_dqdPE1 = bproc.minv_vec_out_R3_dqdPE1();
    let minv_vec_out_R4_dqdPE1 = bproc.minv_vec_out_R4_dqdPE1();
    let minv_vec_out_R5_dqdPE1 = bproc.minv_vec_out_R5_dqdPE1();
    let minv_vec_out_R6_dqdPE1 = bproc.minv_vec_out_R6_dqdPE1();
    let minv_vec_out_R7_dqdPE1 = bproc.minv_vec_out_R7_dqdPE1();

    let minv_vec_out_R1_dqdPE2 = bproc.minv_vec_out_R1_dqdPE2();
    let minv_vec_out_R2_dqdPE2 = bproc.minv_vec_out_R2_dqdPE2();
    let minv_vec_out_R3_dqdPE2 = bproc.minv_vec_out_R3_dqdPE2();
    let minv_vec_out_R4_dqdPE2 = bproc.minv_vec_out_R4_dqdPE2();
    let minv_vec_out_R5_dqdPE2 = bproc.minv_vec_out_R5_dqdPE2();
    let minv_vec_out_R6_dqdPE2 = bproc.minv_vec_out_R6_dqdPE2();
    let minv_vec_out_R7_dqdPE2 = bproc.minv_vec_out_R7_dqdPE2();

    let minv_vec_out_R1_dqdPE3 = bproc.minv_vec_out_R1_dqdPE3();
    let minv_vec_out_R2_dqdPE3 = bproc.minv_vec_out_R2_dqdPE3();
    let minv_vec_out_R3_dqdPE3 = bproc.minv_vec_out_R3_dqdPE3();
    let minv_vec_out_R4_dqdPE3 = bproc.minv_vec_out_R4_dqdPE3();
    let minv_vec_out_R5_dqdPE3 = bproc.minv_vec_out_R5_dqdPE3();
    let minv_vec_out_R6_dqdPE3 = bproc.minv_vec_out_R6_dqdPE3();
    let minv_vec_out_R7_dqdPE3 = bproc.minv_vec_out_R7_dqdPE3();

    let minv_vec_out_R1_dqdPE4 = bproc.minv_vec_out_R1_dqdPE4();
    let minv_vec_out_R2_dqdPE4 = bproc.minv_vec_out_R2_dqdPE4();
    let minv_vec_out_R3_dqdPE4 = bproc.minv_vec_out_R3_dqdPE4();
    let minv_vec_out_R4_dqdPE4 = bproc.minv_vec_out_R4_dqdPE4();
    let minv_vec_out_R5_dqdPE4 = bproc.minv_vec_out_R5_dqdPE4();
    let minv_vec_out_R6_dqdPE4 = bproc.minv_vec_out_R6_dqdPE4();
    let minv_vec_out_R7_dqdPE4 = bproc.minv_vec_out_R7_dqdPE4();

    let minv_vec_out_R1_dqdPE5 = bproc.minv_vec_out_R1_dqdPE5();
    let minv_vec_out_R2_dqdPE5 = bproc.minv_vec_out_R2_dqdPE5();
    let minv_vec_out_R3_dqdPE5 = bproc.minv_vec_out_R3_dqdPE5();
    let minv_vec_out_R4_dqdPE5 = bproc.minv_vec_out_R4_dqdPE5();
    let minv_vec_out_R5_dqdPE5 = bproc.minv_vec_out_R5_dqdPE5();
    let minv_vec_out_R6_dqdPE5 = bproc.minv_vec_out_R6_dqdPE5();
    let minv_vec_out_R7_dqdPE5 = bproc.minv_vec_out_R7_dqdPE5();

    let minv_vec_out_R1_dqdPE6 = bproc.minv_vec_out_R1_dqdPE6();
    let minv_vec_out_R2_dqdPE6 = bproc.minv_vec_out_R2_dqdPE6();
    let minv_vec_out_R3_dqdPE6 = bproc.minv_vec_out_R3_dqdPE6();
    let minv_vec_out_R4_dqdPE6 = bproc.minv_vec_out_R4_dqdPE6();
    let minv_vec_out_R5_dqdPE6 = bproc.minv_vec_out_R5_dqdPE6();
    let minv_vec_out_R6_dqdPE6 = bproc.minv_vec_out_R6_dqdPE6();
    let minv_vec_out_R7_dqdPE6 = bproc.minv_vec_out_R7_dqdPE6();

    let minv_vec_out_R1_dqdPE7 = bproc.minv_vec_out_R1_dqdPE7();
    let minv_vec_out_R2_dqdPE7 = bproc.minv_vec_out_R2_dqdPE7();
    let minv_vec_out_R3_dqdPE7 = bproc.minv_vec_out_R3_dqdPE7();
    let minv_vec_out_R4_dqdPE7 = bproc.minv_vec_out_R4_dqdPE7();
    let minv_vec_out_R5_dqdPE7 = bproc.minv_vec_out_R5_dqdPE7();
    let minv_vec_out_R6_dqdPE7 = bproc.minv_vec_out_R6_dqdPE7();
    let minv_vec_out_R7_dqdPE7 = bproc.minv_vec_out_R7_dqdPE7();

//    $display("MINV VEC OUT BLOCK");
//    $display(fshow(minv_vec_out_R1_dqdPE1), " ", fshow(minv_vec_out_R1_dqdPE2), " ", fshow(minv_vec_out_R1_dqdPE3), " ", fshow(minv_vec_out_R1_dqdPE4), " ", fshow(minv_vec_out_R1_dqdPE5), " ", fshow(minv_vec_out_R1_dqdPE6), " ", fshow(minv_vec_out_R1_dqdPE7));
//    $display(fshow(minv_vec_out_R2_dqdPE1), " ", fshow(minv_vec_out_R2_dqdPE2), " ", fshow(minv_vec_out_R2_dqdPE3), " ", fshow(minv_vec_out_R2_dqdPE4), " ", fshow(minv_vec_out_R2_dqdPE5), " ", fshow(minv_vec_out_R2_dqdPE6), " ", fshow(minv_vec_out_R2_dqdPE7));
//    $display(fshow(minv_vec_out_R3_dqdPE1), " ", fshow(minv_vec_out_R3_dqdPE2), " ", fshow(minv_vec_out_R3_dqdPE3), " ", fshow(minv_vec_out_R3_dqdPE4), " ", fshow(minv_vec_out_R3_dqdPE5), " ", fshow(minv_vec_out_R3_dqdPE6), " ", fshow(minv_vec_out_R3_dqdPE7));
//    $display(fshow(minv_vec_out_R4_dqdPE1), " ", fshow(minv_vec_out_R4_dqdPE2), " ", fshow(minv_vec_out_R4_dqdPE3), " ", fshow(minv_vec_out_R4_dqdPE4), " ", fshow(minv_vec_out_R4_dqdPE5), " ", fshow(minv_vec_out_R4_dqdPE6), " ", fshow(minv_vec_out_R4_dqdPE7));
//    $display(fshow(minv_vec_out_R5_dqdPE1), " ", fshow(minv_vec_out_R5_dqdPE2), " ", fshow(minv_vec_out_R5_dqdPE3), " ", fshow(minv_vec_out_R5_dqdPE4), " ", fshow(minv_vec_out_R5_dqdPE5), " ", fshow(minv_vec_out_R5_dqdPE6), " ", fshow(minv_vec_out_R5_dqdPE7));
//    $display(fshow(minv_vec_out_R6_dqdPE1), " ", fshow(minv_vec_out_R6_dqdPE2), " ", fshow(minv_vec_out_R6_dqdPE3), " ", fshow(minv_vec_out_R6_dqdPE4), " ", fshow(minv_vec_out_R6_dqdPE5), " ", fshow(minv_vec_out_R6_dqdPE6), " ", fshow(minv_vec_out_R6_dqdPE7));
//    $display(fshow(minv_vec_out_R7_dqdPE1), " ", fshow(minv_vec_out_R7_dqdPE2), " ", fshow(minv_vec_out_R7_dqdPE3), " ", fshow(minv_vec_out_R7_dqdPE4), " ", fshow(minv_vec_out_R7_dqdPE5), " ", fshow(minv_vec_out_R7_dqdPE6), " ", fshow(minv_vec_out_R7_dqdPE7));

`include "GradientPipelineBprocMatmulOutputUnrolling.bsv"

    if (idx_block_minv_stream == len_block_minv_sched_total-1) begin
        let new_minv_dtaudq = minv_dtaudq;
        let new_minv_dtaudqd = new_minv_dtau;

        // flush minv_dtaudq matrices for next knot point
        minv_dtaudq <= unpack(0);
        minv_dtaudqd <= unpack(0);

        // PRINT MINV_DTAUDQ
        $display("MINV_DTAUDQ OUTPUT:");
        for (int i=0; i<7; i=i+1) begin
            $display(fshow(new_minv_dtaudq[i]));
        end
        // PRINT MINV_DTAUDQD
        $display("MINV_DTAUDQD OUTPUT:");
        for (int i=0; i<7; i=i+1) begin
            $display(fshow(new_minv_dtaudqd[i]));
        end

        Vector#(98, Bit#(32)) result_vec;

`include "GradientPipelineDenseToSparseMinvOutput.bsv"

        count_interm[0] <= count_interm[0] - 1;
        out_data.enq(pack(result_vec));

        $display("========== MATMUL RESULTS END ==========");
    end
    else begin
        if (idx_block_minv_stream < len_block_minv_sched_per_matrix) begin
            minv_dtaudq <= new_minv_dtau;
        end
        else begin
            minv_dtaudqd <= new_minv_dtau;
        end
    end

endrule
