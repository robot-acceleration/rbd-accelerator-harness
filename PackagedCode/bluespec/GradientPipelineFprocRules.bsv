// parameterize by len link sched
Reg#(Bit#(32)) idx_forward_feed <- mkReg(0);
Reg#(Bit#(32)) idx_forward_stream <- mkReg(0);

Reg#(Bool) keepgoing <- mkReg(True);
Ehr#(2,Bit#(8)) count_interm <- mkEhr(0);

//*******************************/
//   SCHEDULE TABLES FPROC       /
//*******************************/

Bit#(32) len_fproc_sched = 8;

Vector#(8, Bit#(3)) rnea_fproc_curr_sched = 
    vec(1,2,3,4,5,6,7,0);

Vector#(8, Bit#(3)) rnea_fproc_par_sched = 
    vec(0,1,2,3,4,5,6,0);

Vector#(8, Vector#(7, Bit#(3))) fproc_curr_sched = vec(
    vec(0,0,0,0,0,0,0),
    vec(1,0,0,0,0,0,0),
    vec(2,2,0,0,0,0,0),
    vec(3,3,3,0,0,0,0),
    vec(4,4,4,4,0,0,0),
    vec(5,5,5,5,5,0,0),
    vec(6,6,6,6,6,6,0),
    vec(7,7,7,7,7,7,7)
);
Vector#(8, Vector#(7, Bit#(3))) fproc_par_sched = vec(
    vec(0,0,0,0,0,0,0),
    vec(0,0,0,0,0,0,0),
    vec(1,1,0,0,0,0,0),
    vec(2,2,2,0,0,0,0),
    vec(3,3,3,3,0,0,0),
    vec(4,4,4,4,4,0,0),
    vec(5,5,5,5,5,5,0),
    vec(6,6,6,6,6,6,6)
);

Vector#(8, Vector#(7, Bit#(3))) fproc_derv_sched = vec(
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7),
    vec(1,2,3,4,5,6,7)
);

// for fproc ext branching
// both 1-indexed
// s/8/NUM_PES+1
Vector#(8,Reg#(DvDaIntermediate)) dvda_prev <- replicateM(mkReg(unpack(0)));
// s/1/NUM_BRANCHES+1
// s/8/NUM_PES+1
Vector#(8,Vector#(1,Reg#(DvDaIntermediate))) dvda_branch <- replicateM(replicateM(mkReg(unpack(0))));

// returns the index of dvda_branch/upd_branch where the dvda/upd for that link was stored
// for later use
function Bit#(3) branchTableFproc(Bit#(3) branch_link);
    case (branch_link)
        default: return 0;
    endcase
endfunction

function DvDaIntermediate selectDvDaBranch(Bit#(3) curr_link, Bit#(3) par_link, Bit#(3) curr_PE);
    if (par_link != curr_link-1) begin
        return dvda_branch[curr_PE][branchTableFproc(par_link)];
    end
    else begin
        return dvda_prev[curr_PE];
    end
endfunction

//*******************************/

// There cannot be backpressure.
rule feedFproc( !phase[1] && ((idx_forward_feed < len_fproc_sched-1) || (idx_forward_feed == len_fproc_sched-1 && keepgoing)));
    $display("=========== FPROC FEED for idx ", idx_forward_feed, " =============");

    phase[1] <= !phase[1];
    let complete_input = inputs.first();
    $display("Feed forward at idx: ", idx_forward_feed);
    //$display("Feed forward data: ", fshow(complete_input[idx_forward_feed]));
    $display("tic feed: %d", cyc_count);

    // Getting link ids for different components of the schedule
    let link_in_curr_rnea = rnea_fproc_curr_sched[idx_forward_feed];
    let link_in_par_rnea = rnea_fproc_par_sched[idx_forward_feed];
    Bit#(3) link_in_curr_PE1 = 0;
    Bit#(3) link_in_curr_PE2 = 0;
    Bit#(3) link_in_curr_PE3 = 0;
    Bit#(3) link_in_curr_PE4 = 0;
    Bit#(3) link_in_curr_PE5 = 0;
    Bit#(3) link_in_curr_PE6 = 0;
    Bit#(3) link_in_curr_PE7 = 0;
    Bit#(3) link_in_par_PE1 = 0;
    Bit#(3) link_in_par_PE2 = 0;
    Bit#(3) link_in_par_PE3 = 0;
    Bit#(3) link_in_par_PE4 = 0;
    Bit#(3) link_in_par_PE5 = 0;
    Bit#(3) link_in_par_PE6 = 0;
    Bit#(3) link_in_par_PE7 = 0;
    Bit#(3) link_in_derv_PE1 = 0;
    Bit#(3) link_in_derv_PE2 = 0;
    Bit#(3) link_in_derv_PE3 = 0;
    Bit#(3) link_in_derv_PE4 = 0;
    Bit#(3) link_in_derv_PE5 = 0;
    Bit#(3) link_in_derv_PE6 = 0;
    Bit#(3) link_in_derv_PE7 = 0;

`include "GradientPipelineFprocSchedUnrolling.bsv"
    
    // grabbing the input values are 1-indexed
    let input_curr_rnea = complete_input[link_in_curr_rnea];
    let input_par_rnea = complete_input[link_in_par_rnea];
    let input_curr_PE1 = complete_input[link_in_curr_PE1];
    let input_curr_PE2 = complete_input[link_in_curr_PE2];
    let input_curr_PE3 = complete_input[link_in_curr_PE3];
    let input_curr_PE4 = complete_input[link_in_curr_PE4];
    let input_curr_PE5 = complete_input[link_in_curr_PE5];
    let input_curr_PE6 = complete_input[link_in_curr_PE6];
    let input_curr_PE7 = complete_input[link_in_curr_PE7];

    // external branches
    let dvda_PE1 = selectDvDaBranch(link_in_curr_PE1,link_in_par_PE1,1);
    let dvda_PE2 = selectDvDaBranch(link_in_curr_PE2,link_in_par_PE2,2);
    let dvda_PE3 = selectDvDaBranch(link_in_curr_PE3,link_in_par_PE3,3);
    let dvda_PE4 = selectDvDaBranch(link_in_curr_PE4,link_in_par_PE4,4);
    let dvda_PE5 = selectDvDaBranch(link_in_curr_PE5,link_in_par_PE5,5);
    let dvda_PE6 = selectDvDaBranch(link_in_curr_PE6,link_in_par_PE6,6);
    let dvda_PE7 = selectDvDaBranch(link_in_curr_PE7,link_in_par_PE7,7);


    //-----------------------------------

    fproc.get_data();

    //------- RNEA INPUTS ---------

    fproc.link_in_rnea(link_in_curr_rnea);
    fproc.sinq_val_in_rnea(input_curr_rnea.sinq);
    fproc.cosq_val_in_rnea(input_curr_rnea.cosq);
    fproc.qd_val_in_rnea(input_curr_rnea.qd);
    fproc.qdd_val_in_rnea(input_curr_rnea.qdd);
    fproc.v_prev_vec_in_AX_rnea(rnea_acc[link_in_par_rnea].v[0]);
    fproc.v_prev_vec_in_AY_rnea(rnea_acc[link_in_par_rnea].v[1]);
    fproc.v_prev_vec_in_AZ_rnea(rnea_acc[link_in_par_rnea].v[2]);
    fproc.v_prev_vec_in_LX_rnea(rnea_acc[link_in_par_rnea].v[3]);
    fproc.v_prev_vec_in_LY_rnea(rnea_acc[link_in_par_rnea].v[4]);
    fproc.v_prev_vec_in_LZ_rnea(rnea_acc[link_in_par_rnea].v[5]);
    fproc.a_prev_vec_in_AX_rnea(rnea_acc[link_in_par_rnea].a[0]);
    fproc.a_prev_vec_in_AY_rnea(rnea_acc[link_in_par_rnea].a[1]);
    fproc.a_prev_vec_in_AZ_rnea(rnea_acc[link_in_par_rnea].a[2]);
    fproc.a_prev_vec_in_LX_rnea(rnea_acc[link_in_par_rnea].a[3]);
    fproc.a_prev_vec_in_LY_rnea(rnea_acc[link_in_par_rnea].a[4]);
    fproc.a_prev_vec_in_LZ_rnea(rnea_acc[link_in_par_rnea].a[5]);

    //-----------------------------

    //------- DQ INPUTS -----------

    fproc.link_in_dqPE1(link_in_curr_PE1);
    fproc.derv_in_dqPE1(link_in_derv_PE1);
    fproc.sinq_val_in_dqPE1(input_curr_PE1.sinq);
    fproc.cosq_val_in_dqPE1(input_curr_PE1.cosq);
    fproc.qd_val_in_dqPE1(input_curr_PE1.qd);
    fproc.v_curr_vec_in_AX_dqPE1(rnea_acc[link_in_curr_PE1].v[0]);
    fproc.v_curr_vec_in_AY_dqPE1(rnea_acc[link_in_curr_PE1].v[1]);
    fproc.v_curr_vec_in_AZ_dqPE1(rnea_acc[link_in_curr_PE1].v[2]);
    fproc.v_curr_vec_in_LX_dqPE1(rnea_acc[link_in_curr_PE1].v[3]);
    fproc.v_curr_vec_in_LY_dqPE1(rnea_acc[link_in_curr_PE1].v[4]);
    fproc.v_curr_vec_in_LZ_dqPE1(rnea_acc[link_in_curr_PE1].v[5]);
    fproc.a_curr_vec_in_AX_dqPE1(rnea_acc[link_in_curr_PE1].a[0]);
    fproc.a_curr_vec_in_AY_dqPE1(rnea_acc[link_in_curr_PE1].a[1]);
    fproc.a_curr_vec_in_AZ_dqPE1(rnea_acc[link_in_curr_PE1].a[2]);
    fproc.a_curr_vec_in_LX_dqPE1(rnea_acc[link_in_curr_PE1].a[3]);
    fproc.a_curr_vec_in_LY_dqPE1(rnea_acc[link_in_curr_PE1].a[4]);
    fproc.a_curr_vec_in_LZ_dqPE1(rnea_acc[link_in_curr_PE1].a[5]);
    fproc.v_prev_vec_in_AX_dqPE1(rnea_acc[link_in_par_PE1].v[0]);
    fproc.v_prev_vec_in_AY_dqPE1(rnea_acc[link_in_par_PE1].v[1]);
    fproc.v_prev_vec_in_AZ_dqPE1(rnea_acc[link_in_par_PE1].v[2]);
    fproc.v_prev_vec_in_LX_dqPE1(rnea_acc[link_in_par_PE1].v[3]);
    fproc.v_prev_vec_in_LY_dqPE1(rnea_acc[link_in_par_PE1].v[4]);
    fproc.v_prev_vec_in_LZ_dqPE1(rnea_acc[link_in_par_PE1].v[5]);
    fproc.a_prev_vec_in_AX_dqPE1(rnea_acc[link_in_par_PE1].a[0]);
    fproc.a_prev_vec_in_AY_dqPE1(rnea_acc[link_in_par_PE1].a[1]);
    fproc.a_prev_vec_in_AZ_dqPE1(rnea_acc[link_in_par_PE1].a[2]);
    fproc.a_prev_vec_in_LX_dqPE1(rnea_acc[link_in_par_PE1].a[3]);
    fproc.a_prev_vec_in_LY_dqPE1(rnea_acc[link_in_par_PE1].a[4]);
    fproc.a_prev_vec_in_LZ_dqPE1(rnea_acc[link_in_par_PE1].a[5]);
    fproc.dvdq_prev_vec_in_AX_dqPE1(dvda_PE1.dvdq[0]);
    fproc.dvdq_prev_vec_in_AY_dqPE1(dvda_PE1.dvdq[1]);
    fproc.dvdq_prev_vec_in_AZ_dqPE1(dvda_PE1.dvdq[2]);
    fproc.dvdq_prev_vec_in_LX_dqPE1(dvda_PE1.dvdq[3]);
    fproc.dvdq_prev_vec_in_LY_dqPE1(dvda_PE1.dvdq[4]);
    fproc.dvdq_prev_vec_in_LZ_dqPE1(dvda_PE1.dvdq[5]);
    fproc.dadq_prev_vec_in_AX_dqPE1(dvda_PE1.dadq[0]);
    fproc.dadq_prev_vec_in_AY_dqPE1(dvda_PE1.dadq[1]);
    fproc.dadq_prev_vec_in_AZ_dqPE1(dvda_PE1.dadq[2]);
    fproc.dadq_prev_vec_in_LX_dqPE1(dvda_PE1.dadq[3]);
    fproc.dadq_prev_vec_in_LY_dqPE1(dvda_PE1.dadq[4]);
    fproc.dadq_prev_vec_in_LZ_dqPE1(dvda_PE1.dadq[5]);

    fproc.link_in_dqPE2(link_in_curr_PE2);
    fproc.derv_in_dqPE2(link_in_derv_PE2);
    fproc.sinq_val_in_dqPE2(input_curr_PE2.sinq);
    fproc.cosq_val_in_dqPE2(input_curr_PE2.cosq);
    fproc.qd_val_in_dqPE2(input_curr_PE2.qd);
    fproc.v_curr_vec_in_AX_dqPE2(rnea_acc[link_in_curr_PE2].v[0]);
    fproc.v_curr_vec_in_AY_dqPE2(rnea_acc[link_in_curr_PE2].v[1]);
    fproc.v_curr_vec_in_AZ_dqPE2(rnea_acc[link_in_curr_PE2].v[2]);
    fproc.v_curr_vec_in_LX_dqPE2(rnea_acc[link_in_curr_PE2].v[3]);
    fproc.v_curr_vec_in_LY_dqPE2(rnea_acc[link_in_curr_PE2].v[4]);
    fproc.v_curr_vec_in_LZ_dqPE2(rnea_acc[link_in_curr_PE2].v[5]);
    fproc.a_curr_vec_in_AX_dqPE2(rnea_acc[link_in_curr_PE2].a[0]);
    fproc.a_curr_vec_in_AY_dqPE2(rnea_acc[link_in_curr_PE2].a[1]);
    fproc.a_curr_vec_in_AZ_dqPE2(rnea_acc[link_in_curr_PE2].a[2]);
    fproc.a_curr_vec_in_LX_dqPE2(rnea_acc[link_in_curr_PE2].a[3]);
    fproc.a_curr_vec_in_LY_dqPE2(rnea_acc[link_in_curr_PE2].a[4]);
    fproc.a_curr_vec_in_LZ_dqPE2(rnea_acc[link_in_curr_PE2].a[5]);
    fproc.v_prev_vec_in_AX_dqPE2(rnea_acc[link_in_par_PE2].v[0]);
    fproc.v_prev_vec_in_AY_dqPE2(rnea_acc[link_in_par_PE2].v[1]);
    fproc.v_prev_vec_in_AZ_dqPE2(rnea_acc[link_in_par_PE2].v[2]);
    fproc.v_prev_vec_in_LX_dqPE2(rnea_acc[link_in_par_PE2].v[3]);
    fproc.v_prev_vec_in_LY_dqPE2(rnea_acc[link_in_par_PE2].v[4]);
    fproc.v_prev_vec_in_LZ_dqPE2(rnea_acc[link_in_par_PE2].v[5]);
    fproc.a_prev_vec_in_AX_dqPE2(rnea_acc[link_in_par_PE2].a[0]);
    fproc.a_prev_vec_in_AY_dqPE2(rnea_acc[link_in_par_PE2].a[1]);
    fproc.a_prev_vec_in_AZ_dqPE2(rnea_acc[link_in_par_PE2].a[2]);
    fproc.a_prev_vec_in_LX_dqPE2(rnea_acc[link_in_par_PE2].a[3]);
    fproc.a_prev_vec_in_LY_dqPE2(rnea_acc[link_in_par_PE2].a[4]);
    fproc.a_prev_vec_in_LZ_dqPE2(rnea_acc[link_in_par_PE2].a[5]);
    fproc.dvdq_prev_vec_in_AX_dqPE2(dvda_PE2.dvdq[0]);
    fproc.dvdq_prev_vec_in_AY_dqPE2(dvda_PE2.dvdq[1]);
    fproc.dvdq_prev_vec_in_AZ_dqPE2(dvda_PE2.dvdq[2]);
    fproc.dvdq_prev_vec_in_LX_dqPE2(dvda_PE2.dvdq[3]);
    fproc.dvdq_prev_vec_in_LY_dqPE2(dvda_PE2.dvdq[4]);
    fproc.dvdq_prev_vec_in_LZ_dqPE2(dvda_PE2.dvdq[5]);
    fproc.dadq_prev_vec_in_AX_dqPE2(dvda_PE2.dadq[0]);
    fproc.dadq_prev_vec_in_AY_dqPE2(dvda_PE2.dadq[1]);
    fproc.dadq_prev_vec_in_AZ_dqPE2(dvda_PE2.dadq[2]);
    fproc.dadq_prev_vec_in_LX_dqPE2(dvda_PE2.dadq[3]);
    fproc.dadq_prev_vec_in_LY_dqPE2(dvda_PE2.dadq[4]);
    fproc.dadq_prev_vec_in_LZ_dqPE2(dvda_PE2.dadq[5]);

    fproc.link_in_dqPE3(link_in_curr_PE3);
    fproc.derv_in_dqPE3(link_in_derv_PE3);
    fproc.sinq_val_in_dqPE3(input_curr_PE3.sinq);
    fproc.cosq_val_in_dqPE3(input_curr_PE3.cosq);
    fproc.qd_val_in_dqPE3(input_curr_PE3.qd);
    fproc.v_curr_vec_in_AX_dqPE3(rnea_acc[link_in_curr_PE3].v[0]);
    fproc.v_curr_vec_in_AY_dqPE3(rnea_acc[link_in_curr_PE3].v[1]);
    fproc.v_curr_vec_in_AZ_dqPE3(rnea_acc[link_in_curr_PE3].v[2]);
    fproc.v_curr_vec_in_LX_dqPE3(rnea_acc[link_in_curr_PE3].v[3]);
    fproc.v_curr_vec_in_LY_dqPE3(rnea_acc[link_in_curr_PE3].v[4]);
    fproc.v_curr_vec_in_LZ_dqPE3(rnea_acc[link_in_curr_PE3].v[5]);
    fproc.a_curr_vec_in_AX_dqPE3(rnea_acc[link_in_curr_PE3].a[0]);
    fproc.a_curr_vec_in_AY_dqPE3(rnea_acc[link_in_curr_PE3].a[1]);
    fproc.a_curr_vec_in_AZ_dqPE3(rnea_acc[link_in_curr_PE3].a[2]);
    fproc.a_curr_vec_in_LX_dqPE3(rnea_acc[link_in_curr_PE3].a[3]);
    fproc.a_curr_vec_in_LY_dqPE3(rnea_acc[link_in_curr_PE3].a[4]);
    fproc.a_curr_vec_in_LZ_dqPE3(rnea_acc[link_in_curr_PE3].a[5]);
    fproc.v_prev_vec_in_AX_dqPE3(rnea_acc[link_in_par_PE3].v[0]);
    fproc.v_prev_vec_in_AY_dqPE3(rnea_acc[link_in_par_PE3].v[1]);
    fproc.v_prev_vec_in_AZ_dqPE3(rnea_acc[link_in_par_PE3].v[2]);
    fproc.v_prev_vec_in_LX_dqPE3(rnea_acc[link_in_par_PE3].v[3]);
    fproc.v_prev_vec_in_LY_dqPE3(rnea_acc[link_in_par_PE3].v[4]);
    fproc.v_prev_vec_in_LZ_dqPE3(rnea_acc[link_in_par_PE3].v[5]);
    fproc.a_prev_vec_in_AX_dqPE3(rnea_acc[link_in_par_PE3].a[0]);
    fproc.a_prev_vec_in_AY_dqPE3(rnea_acc[link_in_par_PE3].a[1]);
    fproc.a_prev_vec_in_AZ_dqPE3(rnea_acc[link_in_par_PE3].a[2]);
    fproc.a_prev_vec_in_LX_dqPE3(rnea_acc[link_in_par_PE3].a[3]);
    fproc.a_prev_vec_in_LY_dqPE3(rnea_acc[link_in_par_PE3].a[4]);
    fproc.a_prev_vec_in_LZ_dqPE3(rnea_acc[link_in_par_PE3].a[5]);
    fproc.dvdq_prev_vec_in_AX_dqPE3(dvda_PE3.dvdq[0]);
    fproc.dvdq_prev_vec_in_AY_dqPE3(dvda_PE3.dvdq[1]);
    fproc.dvdq_prev_vec_in_AZ_dqPE3(dvda_PE3.dvdq[2]);
    fproc.dvdq_prev_vec_in_LX_dqPE3(dvda_PE3.dvdq[3]);
    fproc.dvdq_prev_vec_in_LY_dqPE3(dvda_PE3.dvdq[4]);
    fproc.dvdq_prev_vec_in_LZ_dqPE3(dvda_PE3.dvdq[5]);
    fproc.dadq_prev_vec_in_AX_dqPE3(dvda_PE3.dadq[0]);
    fproc.dadq_prev_vec_in_AY_dqPE3(dvda_PE3.dadq[1]);
    fproc.dadq_prev_vec_in_AZ_dqPE3(dvda_PE3.dadq[2]);
    fproc.dadq_prev_vec_in_LX_dqPE3(dvda_PE3.dadq[3]);
    fproc.dadq_prev_vec_in_LY_dqPE3(dvda_PE3.dadq[4]);
    fproc.dadq_prev_vec_in_LZ_dqPE3(dvda_PE3.dadq[5]);

    fproc.link_in_dqPE4(link_in_curr_PE4);
    fproc.derv_in_dqPE4(link_in_derv_PE4);
    fproc.sinq_val_in_dqPE4(input_curr_PE4.sinq);
    fproc.cosq_val_in_dqPE4(input_curr_PE4.cosq);
    fproc.qd_val_in_dqPE4(input_curr_PE4.qd);
    fproc.v_curr_vec_in_AX_dqPE4(rnea_acc[link_in_curr_PE4].v[0]);
    fproc.v_curr_vec_in_AY_dqPE4(rnea_acc[link_in_curr_PE4].v[1]);
    fproc.v_curr_vec_in_AZ_dqPE4(rnea_acc[link_in_curr_PE4].v[2]);
    fproc.v_curr_vec_in_LX_dqPE4(rnea_acc[link_in_curr_PE4].v[3]);
    fproc.v_curr_vec_in_LY_dqPE4(rnea_acc[link_in_curr_PE4].v[4]);
    fproc.v_curr_vec_in_LZ_dqPE4(rnea_acc[link_in_curr_PE4].v[5]);
    fproc.a_curr_vec_in_AX_dqPE4(rnea_acc[link_in_curr_PE4].a[0]);
    fproc.a_curr_vec_in_AY_dqPE4(rnea_acc[link_in_curr_PE4].a[1]);
    fproc.a_curr_vec_in_AZ_dqPE4(rnea_acc[link_in_curr_PE4].a[2]);
    fproc.a_curr_vec_in_LX_dqPE4(rnea_acc[link_in_curr_PE4].a[3]);
    fproc.a_curr_vec_in_LY_dqPE4(rnea_acc[link_in_curr_PE4].a[4]);
    fproc.a_curr_vec_in_LZ_dqPE4(rnea_acc[link_in_curr_PE4].a[5]);
    fproc.v_prev_vec_in_AX_dqPE4(rnea_acc[link_in_par_PE4].v[0]);
    fproc.v_prev_vec_in_AY_dqPE4(rnea_acc[link_in_par_PE4].v[1]);
    fproc.v_prev_vec_in_AZ_dqPE4(rnea_acc[link_in_par_PE4].v[2]);
    fproc.v_prev_vec_in_LX_dqPE4(rnea_acc[link_in_par_PE4].v[3]);
    fproc.v_prev_vec_in_LY_dqPE4(rnea_acc[link_in_par_PE4].v[4]);
    fproc.v_prev_vec_in_LZ_dqPE4(rnea_acc[link_in_par_PE4].v[5]);
    fproc.a_prev_vec_in_AX_dqPE4(rnea_acc[link_in_par_PE4].a[0]);
    fproc.a_prev_vec_in_AY_dqPE4(rnea_acc[link_in_par_PE4].a[1]);
    fproc.a_prev_vec_in_AZ_dqPE4(rnea_acc[link_in_par_PE4].a[2]);
    fproc.a_prev_vec_in_LX_dqPE4(rnea_acc[link_in_par_PE4].a[3]);
    fproc.a_prev_vec_in_LY_dqPE4(rnea_acc[link_in_par_PE4].a[4]);
    fproc.a_prev_vec_in_LZ_dqPE4(rnea_acc[link_in_par_PE4].a[5]);
    fproc.dvdq_prev_vec_in_AX_dqPE4(dvda_PE4.dvdq[0]);
    fproc.dvdq_prev_vec_in_AY_dqPE4(dvda_PE4.dvdq[1]);
    fproc.dvdq_prev_vec_in_AZ_dqPE4(dvda_PE4.dvdq[2]);
    fproc.dvdq_prev_vec_in_LX_dqPE4(dvda_PE4.dvdq[3]);
    fproc.dvdq_prev_vec_in_LY_dqPE4(dvda_PE4.dvdq[4]);
    fproc.dvdq_prev_vec_in_LZ_dqPE4(dvda_PE4.dvdq[5]);
    fproc.dadq_prev_vec_in_AX_dqPE4(dvda_PE4.dadq[0]);
    fproc.dadq_prev_vec_in_AY_dqPE4(dvda_PE4.dadq[1]);
    fproc.dadq_prev_vec_in_AZ_dqPE4(dvda_PE4.dadq[2]);
    fproc.dadq_prev_vec_in_LX_dqPE4(dvda_PE4.dadq[3]);
    fproc.dadq_prev_vec_in_LY_dqPE4(dvda_PE4.dadq[4]);
    fproc.dadq_prev_vec_in_LZ_dqPE4(dvda_PE4.dadq[5]);

    fproc.link_in_dqPE5(link_in_curr_PE5);
    fproc.derv_in_dqPE5(link_in_derv_PE5);
    fproc.sinq_val_in_dqPE5(input_curr_PE5.sinq);
    fproc.cosq_val_in_dqPE5(input_curr_PE5.cosq);
    fproc.qd_val_in_dqPE5(input_curr_PE5.qd);
    fproc.v_curr_vec_in_AX_dqPE5(rnea_acc[link_in_curr_PE5].v[0]);
    fproc.v_curr_vec_in_AY_dqPE5(rnea_acc[link_in_curr_PE5].v[1]);
    fproc.v_curr_vec_in_AZ_dqPE5(rnea_acc[link_in_curr_PE5].v[2]);
    fproc.v_curr_vec_in_LX_dqPE5(rnea_acc[link_in_curr_PE5].v[3]);
    fproc.v_curr_vec_in_LY_dqPE5(rnea_acc[link_in_curr_PE5].v[4]);
    fproc.v_curr_vec_in_LZ_dqPE5(rnea_acc[link_in_curr_PE5].v[5]);
    fproc.a_curr_vec_in_AX_dqPE5(rnea_acc[link_in_curr_PE5].a[0]);
    fproc.a_curr_vec_in_AY_dqPE5(rnea_acc[link_in_curr_PE5].a[1]);
    fproc.a_curr_vec_in_AZ_dqPE5(rnea_acc[link_in_curr_PE5].a[2]);
    fproc.a_curr_vec_in_LX_dqPE5(rnea_acc[link_in_curr_PE5].a[3]);
    fproc.a_curr_vec_in_LY_dqPE5(rnea_acc[link_in_curr_PE5].a[4]);
    fproc.a_curr_vec_in_LZ_dqPE5(rnea_acc[link_in_curr_PE5].a[5]);
    fproc.v_prev_vec_in_AX_dqPE5(rnea_acc[link_in_par_PE5].v[0]);
    fproc.v_prev_vec_in_AY_dqPE5(rnea_acc[link_in_par_PE5].v[1]);
    fproc.v_prev_vec_in_AZ_dqPE5(rnea_acc[link_in_par_PE5].v[2]);
    fproc.v_prev_vec_in_LX_dqPE5(rnea_acc[link_in_par_PE5].v[3]);
    fproc.v_prev_vec_in_LY_dqPE5(rnea_acc[link_in_par_PE5].v[4]);
    fproc.v_prev_vec_in_LZ_dqPE5(rnea_acc[link_in_par_PE5].v[5]);
    fproc.a_prev_vec_in_AX_dqPE5(rnea_acc[link_in_par_PE5].a[0]);
    fproc.a_prev_vec_in_AY_dqPE5(rnea_acc[link_in_par_PE5].a[1]);
    fproc.a_prev_vec_in_AZ_dqPE5(rnea_acc[link_in_par_PE5].a[2]);
    fproc.a_prev_vec_in_LX_dqPE5(rnea_acc[link_in_par_PE5].a[3]);
    fproc.a_prev_vec_in_LY_dqPE5(rnea_acc[link_in_par_PE5].a[4]);
    fproc.a_prev_vec_in_LZ_dqPE5(rnea_acc[link_in_par_PE5].a[5]);
    fproc.dvdq_prev_vec_in_AX_dqPE5(dvda_PE5.dvdq[0]);
    fproc.dvdq_prev_vec_in_AY_dqPE5(dvda_PE5.dvdq[1]);
    fproc.dvdq_prev_vec_in_AZ_dqPE5(dvda_PE5.dvdq[2]);
    fproc.dvdq_prev_vec_in_LX_dqPE5(dvda_PE5.dvdq[3]);
    fproc.dvdq_prev_vec_in_LY_dqPE5(dvda_PE5.dvdq[4]);
    fproc.dvdq_prev_vec_in_LZ_dqPE5(dvda_PE5.dvdq[5]);
    fproc.dadq_prev_vec_in_AX_dqPE5(dvda_PE5.dadq[0]);
    fproc.dadq_prev_vec_in_AY_dqPE5(dvda_PE5.dadq[1]);
    fproc.dadq_prev_vec_in_AZ_dqPE5(dvda_PE5.dadq[2]);
    fproc.dadq_prev_vec_in_LX_dqPE5(dvda_PE5.dadq[3]);
    fproc.dadq_prev_vec_in_LY_dqPE5(dvda_PE5.dadq[4]);
    fproc.dadq_prev_vec_in_LZ_dqPE5(dvda_PE5.dadq[5]);

    fproc.link_in_dqPE6(link_in_curr_PE6);
    fproc.derv_in_dqPE6(link_in_derv_PE6);
    fproc.sinq_val_in_dqPE6(input_curr_PE6.sinq);
    fproc.cosq_val_in_dqPE6(input_curr_PE6.cosq);
    fproc.qd_val_in_dqPE6(input_curr_PE6.qd);
    fproc.v_curr_vec_in_AX_dqPE6(rnea_acc[link_in_curr_PE6].v[0]);
    fproc.v_curr_vec_in_AY_dqPE6(rnea_acc[link_in_curr_PE6].v[1]);
    fproc.v_curr_vec_in_AZ_dqPE6(rnea_acc[link_in_curr_PE6].v[2]);
    fproc.v_curr_vec_in_LX_dqPE6(rnea_acc[link_in_curr_PE6].v[3]);
    fproc.v_curr_vec_in_LY_dqPE6(rnea_acc[link_in_curr_PE6].v[4]);
    fproc.v_curr_vec_in_LZ_dqPE6(rnea_acc[link_in_curr_PE6].v[5]);
    fproc.a_curr_vec_in_AX_dqPE6(rnea_acc[link_in_curr_PE6].a[0]);
    fproc.a_curr_vec_in_AY_dqPE6(rnea_acc[link_in_curr_PE6].a[1]);
    fproc.a_curr_vec_in_AZ_dqPE6(rnea_acc[link_in_curr_PE6].a[2]);
    fproc.a_curr_vec_in_LX_dqPE6(rnea_acc[link_in_curr_PE6].a[3]);
    fproc.a_curr_vec_in_LY_dqPE6(rnea_acc[link_in_curr_PE6].a[4]);
    fproc.a_curr_vec_in_LZ_dqPE6(rnea_acc[link_in_curr_PE6].a[5]);
    fproc.v_prev_vec_in_AX_dqPE6(rnea_acc[link_in_par_PE6].v[0]);
    fproc.v_prev_vec_in_AY_dqPE6(rnea_acc[link_in_par_PE6].v[1]);
    fproc.v_prev_vec_in_AZ_dqPE6(rnea_acc[link_in_par_PE6].v[2]);
    fproc.v_prev_vec_in_LX_dqPE6(rnea_acc[link_in_par_PE6].v[3]);
    fproc.v_prev_vec_in_LY_dqPE6(rnea_acc[link_in_par_PE6].v[4]);
    fproc.v_prev_vec_in_LZ_dqPE6(rnea_acc[link_in_par_PE6].v[5]);
    fproc.a_prev_vec_in_AX_dqPE6(rnea_acc[link_in_par_PE6].a[0]);
    fproc.a_prev_vec_in_AY_dqPE6(rnea_acc[link_in_par_PE6].a[1]);
    fproc.a_prev_vec_in_AZ_dqPE6(rnea_acc[link_in_par_PE6].a[2]);
    fproc.a_prev_vec_in_LX_dqPE6(rnea_acc[link_in_par_PE6].a[3]);
    fproc.a_prev_vec_in_LY_dqPE6(rnea_acc[link_in_par_PE6].a[4]);
    fproc.a_prev_vec_in_LZ_dqPE6(rnea_acc[link_in_par_PE6].a[5]);
    fproc.dvdq_prev_vec_in_AX_dqPE6(dvda_PE6.dvdq[0]);
    fproc.dvdq_prev_vec_in_AY_dqPE6(dvda_PE6.dvdq[1]);
    fproc.dvdq_prev_vec_in_AZ_dqPE6(dvda_PE6.dvdq[2]);
    fproc.dvdq_prev_vec_in_LX_dqPE6(dvda_PE6.dvdq[3]);
    fproc.dvdq_prev_vec_in_LY_dqPE6(dvda_PE6.dvdq[4]);
    fproc.dvdq_prev_vec_in_LZ_dqPE6(dvda_PE6.dvdq[5]);
    fproc.dadq_prev_vec_in_AX_dqPE6(dvda_PE6.dadq[0]);
    fproc.dadq_prev_vec_in_AY_dqPE6(dvda_PE6.dadq[1]);
    fproc.dadq_prev_vec_in_AZ_dqPE6(dvda_PE6.dadq[2]);
    fproc.dadq_prev_vec_in_LX_dqPE6(dvda_PE6.dadq[3]);
    fproc.dadq_prev_vec_in_LY_dqPE6(dvda_PE6.dadq[4]);
    fproc.dadq_prev_vec_in_LZ_dqPE6(dvda_PE6.dadq[5]);

    fproc.link_in_dqPE7(link_in_curr_PE7);
    fproc.derv_in_dqPE7(link_in_derv_PE7);
    fproc.sinq_val_in_dqPE7(input_curr_PE7.sinq);
    fproc.cosq_val_in_dqPE7(input_curr_PE7.cosq);
    fproc.qd_val_in_dqPE7(input_curr_PE7.qd);
    fproc.v_curr_vec_in_AX_dqPE7(rnea_acc[link_in_curr_PE7].v[0]);
    fproc.v_curr_vec_in_AY_dqPE7(rnea_acc[link_in_curr_PE7].v[1]);
    fproc.v_curr_vec_in_AZ_dqPE7(rnea_acc[link_in_curr_PE7].v[2]);
    fproc.v_curr_vec_in_LX_dqPE7(rnea_acc[link_in_curr_PE7].v[3]);
    fproc.v_curr_vec_in_LY_dqPE7(rnea_acc[link_in_curr_PE7].v[4]);
    fproc.v_curr_vec_in_LZ_dqPE7(rnea_acc[link_in_curr_PE7].v[5]);
    fproc.a_curr_vec_in_AX_dqPE7(rnea_acc[link_in_curr_PE7].a[0]);
    fproc.a_curr_vec_in_AY_dqPE7(rnea_acc[link_in_curr_PE7].a[1]);
    fproc.a_curr_vec_in_AZ_dqPE7(rnea_acc[link_in_curr_PE7].a[2]);
    fproc.a_curr_vec_in_LX_dqPE7(rnea_acc[link_in_curr_PE7].a[3]);
    fproc.a_curr_vec_in_LY_dqPE7(rnea_acc[link_in_curr_PE7].a[4]);
    fproc.a_curr_vec_in_LZ_dqPE7(rnea_acc[link_in_curr_PE7].a[5]);
    fproc.v_prev_vec_in_AX_dqPE7(rnea_acc[link_in_par_PE7].v[0]);
    fproc.v_prev_vec_in_AY_dqPE7(rnea_acc[link_in_par_PE7].v[1]);
    fproc.v_prev_vec_in_AZ_dqPE7(rnea_acc[link_in_par_PE7].v[2]);
    fproc.v_prev_vec_in_LX_dqPE7(rnea_acc[link_in_par_PE7].v[3]);
    fproc.v_prev_vec_in_LY_dqPE7(rnea_acc[link_in_par_PE7].v[4]);
    fproc.v_prev_vec_in_LZ_dqPE7(rnea_acc[link_in_par_PE7].v[5]);
    fproc.a_prev_vec_in_AX_dqPE7(rnea_acc[link_in_par_PE7].a[0]);
    fproc.a_prev_vec_in_AY_dqPE7(rnea_acc[link_in_par_PE7].a[1]);
    fproc.a_prev_vec_in_AZ_dqPE7(rnea_acc[link_in_par_PE7].a[2]);
    fproc.a_prev_vec_in_LX_dqPE7(rnea_acc[link_in_par_PE7].a[3]);
    fproc.a_prev_vec_in_LY_dqPE7(rnea_acc[link_in_par_PE7].a[4]);
    fproc.a_prev_vec_in_LZ_dqPE7(rnea_acc[link_in_par_PE7].a[5]);
    fproc.dvdq_prev_vec_in_AX_dqPE7(dvda_PE7.dvdq[0]);
    fproc.dvdq_prev_vec_in_AY_dqPE7(dvda_PE7.dvdq[1]);
    fproc.dvdq_prev_vec_in_AZ_dqPE7(dvda_PE7.dvdq[2]);
    fproc.dvdq_prev_vec_in_LX_dqPE7(dvda_PE7.dvdq[3]);
    fproc.dvdq_prev_vec_in_LY_dqPE7(dvda_PE7.dvdq[4]);
    fproc.dvdq_prev_vec_in_LZ_dqPE7(dvda_PE7.dvdq[5]);
    fproc.dadq_prev_vec_in_AX_dqPE7(dvda_PE7.dadq[0]);
    fproc.dadq_prev_vec_in_AY_dqPE7(dvda_PE7.dadq[1]);
    fproc.dadq_prev_vec_in_AZ_dqPE7(dvda_PE7.dadq[2]);
    fproc.dadq_prev_vec_in_LX_dqPE7(dvda_PE7.dadq[3]);
    fproc.dadq_prev_vec_in_LY_dqPE7(dvda_PE7.dadq[4]);
    fproc.dadq_prev_vec_in_LZ_dqPE7(dvda_PE7.dadq[5]);


    //-----------------------------

    //------- DQD INPUTS ----------

    fproc.link_in_dqdPE1(link_in_curr_PE1);
    fproc.derv_in_dqdPE1(link_in_derv_PE1);
    fproc.sinq_val_in_dqdPE1(input_curr_PE1.sinq);
    fproc.cosq_val_in_dqdPE1(input_curr_PE1.cosq);
    fproc.qd_val_in_dqdPE1(input_curr_PE1.qd);
    fproc.v_curr_vec_in_AX_dqdPE1(rnea_acc[link_in_curr_PE1].v[0]);
    fproc.v_curr_vec_in_AY_dqdPE1(rnea_acc[link_in_curr_PE1].v[1]);
    fproc.v_curr_vec_in_AZ_dqdPE1(rnea_acc[link_in_curr_PE1].v[2]);
    fproc.v_curr_vec_in_LX_dqdPE1(rnea_acc[link_in_curr_PE1].v[3]);
    fproc.v_curr_vec_in_LY_dqdPE1(rnea_acc[link_in_curr_PE1].v[4]);
    fproc.v_curr_vec_in_LZ_dqdPE1(rnea_acc[link_in_curr_PE1].v[5]);
    fproc.a_curr_vec_in_AX_dqdPE1(rnea_acc[link_in_curr_PE1].a[0]);
    fproc.a_curr_vec_in_AY_dqdPE1(rnea_acc[link_in_curr_PE1].a[1]);
    fproc.a_curr_vec_in_AZ_dqdPE1(rnea_acc[link_in_curr_PE1].a[2]);
    fproc.a_curr_vec_in_LX_dqdPE1(rnea_acc[link_in_curr_PE1].a[3]);
    fproc.a_curr_vec_in_LY_dqdPE1(rnea_acc[link_in_curr_PE1].a[4]);
    fproc.a_curr_vec_in_LZ_dqdPE1(rnea_acc[link_in_curr_PE1].a[5]);
    fproc.dvdqd_prev_vec_in_AX_dqdPE1(dvda_PE1.dvdqd[0]);
    fproc.dvdqd_prev_vec_in_AY_dqdPE1(dvda_PE1.dvdqd[1]);
    fproc.dvdqd_prev_vec_in_AZ_dqdPE1(dvda_PE1.dvdqd[2]);
    fproc.dvdqd_prev_vec_in_LX_dqdPE1(dvda_PE1.dvdqd[3]);
    fproc.dvdqd_prev_vec_in_LY_dqdPE1(dvda_PE1.dvdqd[4]);
    fproc.dvdqd_prev_vec_in_LZ_dqdPE1(dvda_PE1.dvdqd[5]);
    fproc.dadqd_prev_vec_in_AX_dqdPE1(dvda_PE1.dadqd[0]);
    fproc.dadqd_prev_vec_in_AY_dqdPE1(dvda_PE1.dadqd[1]);
    fproc.dadqd_prev_vec_in_AZ_dqdPE1(dvda_PE1.dadqd[2]);
    fproc.dadqd_prev_vec_in_LX_dqdPE1(dvda_PE1.dadqd[3]);
    fproc.dadqd_prev_vec_in_LY_dqdPE1(dvda_PE1.dadqd[4]);
    fproc.dadqd_prev_vec_in_LZ_dqdPE1(dvda_PE1.dadqd[5]);

    fproc.link_in_dqdPE2(link_in_curr_PE2);
    fproc.derv_in_dqdPE2(link_in_derv_PE2);
    fproc.sinq_val_in_dqdPE2(input_curr_PE2.sinq);
    fproc.cosq_val_in_dqdPE2(input_curr_PE2.cosq);
    fproc.qd_val_in_dqdPE2(input_curr_PE2.qd);
    fproc.v_curr_vec_in_AX_dqdPE2(rnea_acc[link_in_curr_PE2].v[0]);
    fproc.v_curr_vec_in_AY_dqdPE2(rnea_acc[link_in_curr_PE2].v[1]);
    fproc.v_curr_vec_in_AZ_dqdPE2(rnea_acc[link_in_curr_PE2].v[2]);
    fproc.v_curr_vec_in_LX_dqdPE2(rnea_acc[link_in_curr_PE2].v[3]);
    fproc.v_curr_vec_in_LY_dqdPE2(rnea_acc[link_in_curr_PE2].v[4]);
    fproc.v_curr_vec_in_LZ_dqdPE2(rnea_acc[link_in_curr_PE2].v[5]);
    fproc.a_curr_vec_in_AX_dqdPE2(rnea_acc[link_in_curr_PE2].a[0]);
    fproc.a_curr_vec_in_AY_dqdPE2(rnea_acc[link_in_curr_PE2].a[1]);
    fproc.a_curr_vec_in_AZ_dqdPE2(rnea_acc[link_in_curr_PE2].a[2]);
    fproc.a_curr_vec_in_LX_dqdPE2(rnea_acc[link_in_curr_PE2].a[3]);
    fproc.a_curr_vec_in_LY_dqdPE2(rnea_acc[link_in_curr_PE2].a[4]);
    fproc.a_curr_vec_in_LZ_dqdPE2(rnea_acc[link_in_curr_PE2].a[5]);
    fproc.dvdqd_prev_vec_in_AX_dqdPE2(dvda_PE2.dvdqd[0]);
    fproc.dvdqd_prev_vec_in_AY_dqdPE2(dvda_PE2.dvdqd[1]);
    fproc.dvdqd_prev_vec_in_AZ_dqdPE2(dvda_PE2.dvdqd[2]);
    fproc.dvdqd_prev_vec_in_LX_dqdPE2(dvda_PE2.dvdqd[3]);
    fproc.dvdqd_prev_vec_in_LY_dqdPE2(dvda_PE2.dvdqd[4]);
    fproc.dvdqd_prev_vec_in_LZ_dqdPE2(dvda_PE2.dvdqd[5]);
    fproc.dadqd_prev_vec_in_AX_dqdPE2(dvda_PE2.dadqd[0]);
    fproc.dadqd_prev_vec_in_AY_dqdPE2(dvda_PE2.dadqd[1]);
    fproc.dadqd_prev_vec_in_AZ_dqdPE2(dvda_PE2.dadqd[2]);
    fproc.dadqd_prev_vec_in_LX_dqdPE2(dvda_PE2.dadqd[3]);
    fproc.dadqd_prev_vec_in_LY_dqdPE2(dvda_PE2.dadqd[4]);
    fproc.dadqd_prev_vec_in_LZ_dqdPE2(dvda_PE2.dadqd[5]);

    fproc.link_in_dqdPE3(link_in_curr_PE3);
    fproc.derv_in_dqdPE3(link_in_derv_PE3);
    fproc.sinq_val_in_dqdPE3(input_curr_PE3.sinq);
    fproc.cosq_val_in_dqdPE3(input_curr_PE3.cosq);
    fproc.qd_val_in_dqdPE3(input_curr_PE3.qd);
    fproc.v_curr_vec_in_AX_dqdPE3(rnea_acc[link_in_curr_PE3].v[0]);
    fproc.v_curr_vec_in_AY_dqdPE3(rnea_acc[link_in_curr_PE3].v[1]);
    fproc.v_curr_vec_in_AZ_dqdPE3(rnea_acc[link_in_curr_PE3].v[2]);
    fproc.v_curr_vec_in_LX_dqdPE3(rnea_acc[link_in_curr_PE3].v[3]);
    fproc.v_curr_vec_in_LY_dqdPE3(rnea_acc[link_in_curr_PE3].v[4]);
    fproc.v_curr_vec_in_LZ_dqdPE3(rnea_acc[link_in_curr_PE3].v[5]);
    fproc.a_curr_vec_in_AX_dqdPE3(rnea_acc[link_in_curr_PE3].a[0]);
    fproc.a_curr_vec_in_AY_dqdPE3(rnea_acc[link_in_curr_PE3].a[1]);
    fproc.a_curr_vec_in_AZ_dqdPE3(rnea_acc[link_in_curr_PE3].a[2]);
    fproc.a_curr_vec_in_LX_dqdPE3(rnea_acc[link_in_curr_PE3].a[3]);
    fproc.a_curr_vec_in_LY_dqdPE3(rnea_acc[link_in_curr_PE3].a[4]);
    fproc.a_curr_vec_in_LZ_dqdPE3(rnea_acc[link_in_curr_PE3].a[5]);
    fproc.dvdqd_prev_vec_in_AX_dqdPE3(dvda_PE3.dvdqd[0]);
    fproc.dvdqd_prev_vec_in_AY_dqdPE3(dvda_PE3.dvdqd[1]);
    fproc.dvdqd_prev_vec_in_AZ_dqdPE3(dvda_PE3.dvdqd[2]);
    fproc.dvdqd_prev_vec_in_LX_dqdPE3(dvda_PE3.dvdqd[3]);
    fproc.dvdqd_prev_vec_in_LY_dqdPE3(dvda_PE3.dvdqd[4]);
    fproc.dvdqd_prev_vec_in_LZ_dqdPE3(dvda_PE3.dvdqd[5]);
    fproc.dadqd_prev_vec_in_AX_dqdPE3(dvda_PE3.dadqd[0]);
    fproc.dadqd_prev_vec_in_AY_dqdPE3(dvda_PE3.dadqd[1]);
    fproc.dadqd_prev_vec_in_AZ_dqdPE3(dvda_PE3.dadqd[2]);
    fproc.dadqd_prev_vec_in_LX_dqdPE3(dvda_PE3.dadqd[3]);
    fproc.dadqd_prev_vec_in_LY_dqdPE3(dvda_PE3.dadqd[4]);
    fproc.dadqd_prev_vec_in_LZ_dqdPE3(dvda_PE3.dadqd[5]);

    fproc.link_in_dqdPE4(link_in_curr_PE4);
    fproc.derv_in_dqdPE4(link_in_derv_PE4);
    fproc.sinq_val_in_dqdPE4(input_curr_PE4.sinq);
    fproc.cosq_val_in_dqdPE4(input_curr_PE4.cosq);
    fproc.qd_val_in_dqdPE4(input_curr_PE4.qd);
    fproc.v_curr_vec_in_AX_dqdPE4(rnea_acc[link_in_curr_PE4].v[0]);
    fproc.v_curr_vec_in_AY_dqdPE4(rnea_acc[link_in_curr_PE4].v[1]);
    fproc.v_curr_vec_in_AZ_dqdPE4(rnea_acc[link_in_curr_PE4].v[2]);
    fproc.v_curr_vec_in_LX_dqdPE4(rnea_acc[link_in_curr_PE4].v[3]);
    fproc.v_curr_vec_in_LY_dqdPE4(rnea_acc[link_in_curr_PE4].v[4]);
    fproc.v_curr_vec_in_LZ_dqdPE4(rnea_acc[link_in_curr_PE4].v[5]);
    fproc.a_curr_vec_in_AX_dqdPE4(rnea_acc[link_in_curr_PE4].a[0]);
    fproc.a_curr_vec_in_AY_dqdPE4(rnea_acc[link_in_curr_PE4].a[1]);
    fproc.a_curr_vec_in_AZ_dqdPE4(rnea_acc[link_in_curr_PE4].a[2]);
    fproc.a_curr_vec_in_LX_dqdPE4(rnea_acc[link_in_curr_PE4].a[3]);
    fproc.a_curr_vec_in_LY_dqdPE4(rnea_acc[link_in_curr_PE4].a[4]);
    fproc.a_curr_vec_in_LZ_dqdPE4(rnea_acc[link_in_curr_PE4].a[5]);
    fproc.dvdqd_prev_vec_in_AX_dqdPE4(dvda_PE4.dvdqd[0]);
    fproc.dvdqd_prev_vec_in_AY_dqdPE4(dvda_PE4.dvdqd[1]);
    fproc.dvdqd_prev_vec_in_AZ_dqdPE4(dvda_PE4.dvdqd[2]);
    fproc.dvdqd_prev_vec_in_LX_dqdPE4(dvda_PE4.dvdqd[3]);
    fproc.dvdqd_prev_vec_in_LY_dqdPE4(dvda_PE4.dvdqd[4]);
    fproc.dvdqd_prev_vec_in_LZ_dqdPE4(dvda_PE4.dvdqd[5]);
    fproc.dadqd_prev_vec_in_AX_dqdPE4(dvda_PE4.dadqd[0]);
    fproc.dadqd_prev_vec_in_AY_dqdPE4(dvda_PE4.dadqd[1]);
    fproc.dadqd_prev_vec_in_AZ_dqdPE4(dvda_PE4.dadqd[2]);
    fproc.dadqd_prev_vec_in_LX_dqdPE4(dvda_PE4.dadqd[3]);
    fproc.dadqd_prev_vec_in_LY_dqdPE4(dvda_PE4.dadqd[4]);
    fproc.dadqd_prev_vec_in_LZ_dqdPE4(dvda_PE4.dadqd[5]);

    fproc.link_in_dqdPE5(link_in_curr_PE5);
    fproc.derv_in_dqdPE5(link_in_derv_PE5);
    fproc.sinq_val_in_dqdPE5(input_curr_PE5.sinq);
    fproc.cosq_val_in_dqdPE5(input_curr_PE5.cosq);
    fproc.qd_val_in_dqdPE5(input_curr_PE5.qd);
    fproc.v_curr_vec_in_AX_dqdPE5(rnea_acc[link_in_curr_PE5].v[0]);
    fproc.v_curr_vec_in_AY_dqdPE5(rnea_acc[link_in_curr_PE5].v[1]);
    fproc.v_curr_vec_in_AZ_dqdPE5(rnea_acc[link_in_curr_PE5].v[2]);
    fproc.v_curr_vec_in_LX_dqdPE5(rnea_acc[link_in_curr_PE5].v[3]);
    fproc.v_curr_vec_in_LY_dqdPE5(rnea_acc[link_in_curr_PE5].v[4]);
    fproc.v_curr_vec_in_LZ_dqdPE5(rnea_acc[link_in_curr_PE5].v[5]);
    fproc.a_curr_vec_in_AX_dqdPE5(rnea_acc[link_in_curr_PE5].a[0]);
    fproc.a_curr_vec_in_AY_dqdPE5(rnea_acc[link_in_curr_PE5].a[1]);
    fproc.a_curr_vec_in_AZ_dqdPE5(rnea_acc[link_in_curr_PE5].a[2]);
    fproc.a_curr_vec_in_LX_dqdPE5(rnea_acc[link_in_curr_PE5].a[3]);
    fproc.a_curr_vec_in_LY_dqdPE5(rnea_acc[link_in_curr_PE5].a[4]);
    fproc.a_curr_vec_in_LZ_dqdPE5(rnea_acc[link_in_curr_PE5].a[5]);
    fproc.dvdqd_prev_vec_in_AX_dqdPE5(dvda_PE5.dvdqd[0]);
    fproc.dvdqd_prev_vec_in_AY_dqdPE5(dvda_PE5.dvdqd[1]);
    fproc.dvdqd_prev_vec_in_AZ_dqdPE5(dvda_PE5.dvdqd[2]);
    fproc.dvdqd_prev_vec_in_LX_dqdPE5(dvda_PE5.dvdqd[3]);
    fproc.dvdqd_prev_vec_in_LY_dqdPE5(dvda_PE5.dvdqd[4]);
    fproc.dvdqd_prev_vec_in_LZ_dqdPE5(dvda_PE5.dvdqd[5]);
    fproc.dadqd_prev_vec_in_AX_dqdPE5(dvda_PE5.dadqd[0]);
    fproc.dadqd_prev_vec_in_AY_dqdPE5(dvda_PE5.dadqd[1]);
    fproc.dadqd_prev_vec_in_AZ_dqdPE5(dvda_PE5.dadqd[2]);
    fproc.dadqd_prev_vec_in_LX_dqdPE5(dvda_PE5.dadqd[3]);
    fproc.dadqd_prev_vec_in_LY_dqdPE5(dvda_PE5.dadqd[4]);
    fproc.dadqd_prev_vec_in_LZ_dqdPE5(dvda_PE5.dadqd[5]);

    fproc.link_in_dqdPE6(link_in_curr_PE6);
    fproc.derv_in_dqdPE6(link_in_derv_PE6);
    fproc.sinq_val_in_dqdPE6(input_curr_PE6.sinq);
    fproc.cosq_val_in_dqdPE6(input_curr_PE6.cosq);
    fproc.qd_val_in_dqdPE6(input_curr_PE6.qd);
    fproc.v_curr_vec_in_AX_dqdPE6(rnea_acc[link_in_curr_PE6].v[0]);
    fproc.v_curr_vec_in_AY_dqdPE6(rnea_acc[link_in_curr_PE6].v[1]);
    fproc.v_curr_vec_in_AZ_dqdPE6(rnea_acc[link_in_curr_PE6].v[2]);
    fproc.v_curr_vec_in_LX_dqdPE6(rnea_acc[link_in_curr_PE6].v[3]);
    fproc.v_curr_vec_in_LY_dqdPE6(rnea_acc[link_in_curr_PE6].v[4]);
    fproc.v_curr_vec_in_LZ_dqdPE6(rnea_acc[link_in_curr_PE6].v[5]);
    fproc.a_curr_vec_in_AX_dqdPE6(rnea_acc[link_in_curr_PE6].a[0]);
    fproc.a_curr_vec_in_AY_dqdPE6(rnea_acc[link_in_curr_PE6].a[1]);
    fproc.a_curr_vec_in_AZ_dqdPE6(rnea_acc[link_in_curr_PE6].a[2]);
    fproc.a_curr_vec_in_LX_dqdPE6(rnea_acc[link_in_curr_PE6].a[3]);
    fproc.a_curr_vec_in_LY_dqdPE6(rnea_acc[link_in_curr_PE6].a[4]);
    fproc.a_curr_vec_in_LZ_dqdPE6(rnea_acc[link_in_curr_PE6].a[5]);
    fproc.dvdqd_prev_vec_in_AX_dqdPE6(dvda_PE6.dvdqd[0]);
    fproc.dvdqd_prev_vec_in_AY_dqdPE6(dvda_PE6.dvdqd[1]);
    fproc.dvdqd_prev_vec_in_AZ_dqdPE6(dvda_PE6.dvdqd[2]);
    fproc.dvdqd_prev_vec_in_LX_dqdPE6(dvda_PE6.dvdqd[3]);
    fproc.dvdqd_prev_vec_in_LY_dqdPE6(dvda_PE6.dvdqd[4]);
    fproc.dvdqd_prev_vec_in_LZ_dqdPE6(dvda_PE6.dvdqd[5]);
    fproc.dadqd_prev_vec_in_AX_dqdPE6(dvda_PE6.dadqd[0]);
    fproc.dadqd_prev_vec_in_AY_dqdPE6(dvda_PE6.dadqd[1]);
    fproc.dadqd_prev_vec_in_AZ_dqdPE6(dvda_PE6.dadqd[2]);
    fproc.dadqd_prev_vec_in_LX_dqdPE6(dvda_PE6.dadqd[3]);
    fproc.dadqd_prev_vec_in_LY_dqdPE6(dvda_PE6.dadqd[4]);
    fproc.dadqd_prev_vec_in_LZ_dqdPE6(dvda_PE6.dadqd[5]);

    fproc.link_in_dqdPE7(link_in_curr_PE7);
    fproc.derv_in_dqdPE7(link_in_derv_PE7);
    fproc.sinq_val_in_dqdPE7(input_curr_PE7.sinq);
    fproc.cosq_val_in_dqdPE7(input_curr_PE7.cosq);
    fproc.qd_val_in_dqdPE7(input_curr_PE7.qd);
    fproc.v_curr_vec_in_AX_dqdPE7(rnea_acc[link_in_curr_PE7].v[0]);
    fproc.v_curr_vec_in_AY_dqdPE7(rnea_acc[link_in_curr_PE7].v[1]);
    fproc.v_curr_vec_in_AZ_dqdPE7(rnea_acc[link_in_curr_PE7].v[2]);
    fproc.v_curr_vec_in_LX_dqdPE7(rnea_acc[link_in_curr_PE7].v[3]);
    fproc.v_curr_vec_in_LY_dqdPE7(rnea_acc[link_in_curr_PE7].v[4]);
    fproc.v_curr_vec_in_LZ_dqdPE7(rnea_acc[link_in_curr_PE7].v[5]);
    fproc.a_curr_vec_in_AX_dqdPE7(rnea_acc[link_in_curr_PE7].a[0]);
    fproc.a_curr_vec_in_AY_dqdPE7(rnea_acc[link_in_curr_PE7].a[1]);
    fproc.a_curr_vec_in_AZ_dqdPE7(rnea_acc[link_in_curr_PE7].a[2]);
    fproc.a_curr_vec_in_LX_dqdPE7(rnea_acc[link_in_curr_PE7].a[3]);
    fproc.a_curr_vec_in_LY_dqdPE7(rnea_acc[link_in_curr_PE7].a[4]);
    fproc.a_curr_vec_in_LZ_dqdPE7(rnea_acc[link_in_curr_PE7].a[5]);
    fproc.dvdqd_prev_vec_in_AX_dqdPE7(dvda_PE7.dvdqd[0]);
    fproc.dvdqd_prev_vec_in_AY_dqdPE7(dvda_PE7.dvdqd[1]);
    fproc.dvdqd_prev_vec_in_AZ_dqdPE7(dvda_PE7.dvdqd[2]);
    fproc.dvdqd_prev_vec_in_LX_dqdPE7(dvda_PE7.dvdqd[3]);
    fproc.dvdqd_prev_vec_in_LY_dqdPE7(dvda_PE7.dvdqd[4]);
    fproc.dvdqd_prev_vec_in_LZ_dqdPE7(dvda_PE7.dvdqd[5]);
    fproc.dadqd_prev_vec_in_AX_dqdPE7(dvda_PE7.dadqd[0]);
    fproc.dadqd_prev_vec_in_AY_dqdPE7(dvda_PE7.dadqd[1]);
    fproc.dadqd_prev_vec_in_AZ_dqdPE7(dvda_PE7.dadqd[2]);
    fproc.dadqd_prev_vec_in_LX_dqdPE7(dvda_PE7.dadqd[3]);
    fproc.dadqd_prev_vec_in_LY_dqdPE7(dvda_PE7.dadqd[4]);
    fproc.dadqd_prev_vec_in_LZ_dqdPE7(dvda_PE7.dadqd[5]);


    //-----------------------------

    // trigo_acc is 1-indexed
    trigo_acc[link_in_curr_rnea] <= Trigo{
                    sinq: input_curr_rnea.sinq,
                    cosq: input_curr_rnea.cosq
    };

    //-----------------------------

    if (idx_forward_feed == len_fproc_sched-1) begin
        idx_forward_feed <= 0;
        keepgoing <= False;
        inputs.deq();
        count_interm[1] <= count_interm[1] + 1;
        Vector#(9, Trigo) embed; // 1-indexed + we need zeros as input for 8th link
        // s/7/num_links
        embed[0] = unpack(0);
        for (int i = 1; i <= 7; i = i + 1) begin
            embed[i] = trigo_acc[i]; // trigo_acc is 1-indexed
        end
        embed[8] = unpack(0);
        trigo_values.enq(embed);

    end
    else begin
        idx_forward_feed <= idx_forward_feed + 1;
    end

    $display("=========== FPROC FEED for idx ", idx_forward_feed, " END =============");

endrule

rule restartPipe (!keepgoing && count_interm[1] < 3);
    keepgoing <= True;
endrule

// s/8/len_sched
rule streamFproc( phase[0] && unpack(fproc.output_ready()) && idx_forward_stream < len_fproc_sched);
    $display("=========== FPROC STREAM for idx ", idx_forward_stream, " =============");

    phase[0] <= !phase[0];
    $display("tic stream: %d", cyc_count);

    //******** RNEA OUTPUT REDIRECTION *******/

    let link_out_curr_rnea = rnea_fproc_curr_sched[idx_forward_stream];
    //$display("curr link outs: rnea, PE1, PE2...PE7: ", link_out_curr_rnea, link_out_curr_PE1,link_out_curr_PE2,link_out_curr_PE3,link_out_curr_PE4,link_out_curr_PE5,link_out_curr_PE6,link_out_curr_PE7);

    let v_curr_vec_out_AX_rnea = fproc.v_curr_vec_out_AX_rnea();
    let v_curr_vec_out_AY_rnea = fproc.v_curr_vec_out_AY_rnea();
    let v_curr_vec_out_AZ_rnea = fproc.v_curr_vec_out_AZ_rnea();
    let v_curr_vec_out_LX_rnea = fproc.v_curr_vec_out_LX_rnea();
    let v_curr_vec_out_LY_rnea = fproc.v_curr_vec_out_LY_rnea();
    let v_curr_vec_out_LZ_rnea = fproc.v_curr_vec_out_LZ_rnea();
    let a_curr_vec_out_AX_rnea = fproc.a_curr_vec_out_AX_rnea();
    let a_curr_vec_out_AY_rnea = fproc.a_curr_vec_out_AY_rnea();
    let a_curr_vec_out_AZ_rnea = fproc.a_curr_vec_out_AZ_rnea();
    let a_curr_vec_out_LX_rnea = fproc.a_curr_vec_out_LX_rnea();
    let a_curr_vec_out_LY_rnea = fproc.a_curr_vec_out_LY_rnea();
    let a_curr_vec_out_LZ_rnea = fproc.a_curr_vec_out_LZ_rnea();
    let f_curr_vec_out_AX_rnea = fproc.f_curr_vec_out_AX_rnea();
    let f_curr_vec_out_AY_rnea = fproc.f_curr_vec_out_AY_rnea();
    let f_curr_vec_out_AZ_rnea = fproc.f_curr_vec_out_AZ_rnea();
    let f_curr_vec_out_LX_rnea = fproc.f_curr_vec_out_LX_rnea();
    let f_curr_vec_out_LY_rnea = fproc.f_curr_vec_out_LY_rnea();
    let f_curr_vec_out_LZ_rnea = fproc.f_curr_vec_out_LZ_rnea();

    //***************************************/

    //********* DQPE OUTPUT REDIRECTION ********/
    
    let dfdq_curr_vec_out_AX_dqPE1 = fproc.dfdq_curr_vec_out_AX_dqPE1();
    let dfdq_curr_vec_out_AY_dqPE1 = fproc.dfdq_curr_vec_out_AY_dqPE1();
    let dfdq_curr_vec_out_AZ_dqPE1 = fproc.dfdq_curr_vec_out_AZ_dqPE1();
    let dfdq_curr_vec_out_LX_dqPE1 = fproc.dfdq_curr_vec_out_LX_dqPE1();
    let dfdq_curr_vec_out_LY_dqPE1 = fproc.dfdq_curr_vec_out_LY_dqPE1();
    let dfdq_curr_vec_out_LZ_dqPE1 = fproc.dfdq_curr_vec_out_LZ_dqPE1();
    let dfdq_curr_vec_out_AX_dqPE2 = fproc.dfdq_curr_vec_out_AX_dqPE2();
    let dfdq_curr_vec_out_AY_dqPE2 = fproc.dfdq_curr_vec_out_AY_dqPE2();
    let dfdq_curr_vec_out_AZ_dqPE2 = fproc.dfdq_curr_vec_out_AZ_dqPE2();
    let dfdq_curr_vec_out_LX_dqPE2 = fproc.dfdq_curr_vec_out_LX_dqPE2();
    let dfdq_curr_vec_out_LY_dqPE2 = fproc.dfdq_curr_vec_out_LY_dqPE2();
    let dfdq_curr_vec_out_LZ_dqPE2 = fproc.dfdq_curr_vec_out_LZ_dqPE2();
    let dfdq_curr_vec_out_AX_dqPE3 = fproc.dfdq_curr_vec_out_AX_dqPE3();
    let dfdq_curr_vec_out_AY_dqPE3 = fproc.dfdq_curr_vec_out_AY_dqPE3();
    let dfdq_curr_vec_out_AZ_dqPE3 = fproc.dfdq_curr_vec_out_AZ_dqPE3();
    let dfdq_curr_vec_out_LX_dqPE3 = fproc.dfdq_curr_vec_out_LX_dqPE3();
    let dfdq_curr_vec_out_LY_dqPE3 = fproc.dfdq_curr_vec_out_LY_dqPE3();
    let dfdq_curr_vec_out_LZ_dqPE3 = fproc.dfdq_curr_vec_out_LZ_dqPE3();
    let dfdq_curr_vec_out_AX_dqPE4 = fproc.dfdq_curr_vec_out_AX_dqPE4();
    let dfdq_curr_vec_out_AY_dqPE4 = fproc.dfdq_curr_vec_out_AY_dqPE4();
    let dfdq_curr_vec_out_AZ_dqPE4 = fproc.dfdq_curr_vec_out_AZ_dqPE4();
    let dfdq_curr_vec_out_LX_dqPE4 = fproc.dfdq_curr_vec_out_LX_dqPE4();
    let dfdq_curr_vec_out_LY_dqPE4 = fproc.dfdq_curr_vec_out_LY_dqPE4();
    let dfdq_curr_vec_out_LZ_dqPE4 = fproc.dfdq_curr_vec_out_LZ_dqPE4();
    let dfdq_curr_vec_out_AX_dqPE5 = fproc.dfdq_curr_vec_out_AX_dqPE5();
    let dfdq_curr_vec_out_AY_dqPE5 = fproc.dfdq_curr_vec_out_AY_dqPE5();
    let dfdq_curr_vec_out_AZ_dqPE5 = fproc.dfdq_curr_vec_out_AZ_dqPE5();
    let dfdq_curr_vec_out_LX_dqPE5 = fproc.dfdq_curr_vec_out_LX_dqPE5();
    let dfdq_curr_vec_out_LY_dqPE5 = fproc.dfdq_curr_vec_out_LY_dqPE5();
    let dfdq_curr_vec_out_LZ_dqPE5 = fproc.dfdq_curr_vec_out_LZ_dqPE5();
    let dfdq_curr_vec_out_AX_dqPE6 = fproc.dfdq_curr_vec_out_AX_dqPE6();
    let dfdq_curr_vec_out_AY_dqPE6 = fproc.dfdq_curr_vec_out_AY_dqPE6();
    let dfdq_curr_vec_out_AZ_dqPE6 = fproc.dfdq_curr_vec_out_AZ_dqPE6();
    let dfdq_curr_vec_out_LX_dqPE6 = fproc.dfdq_curr_vec_out_LX_dqPE6();
    let dfdq_curr_vec_out_LY_dqPE6 = fproc.dfdq_curr_vec_out_LY_dqPE6();
    let dfdq_curr_vec_out_LZ_dqPE6 = fproc.dfdq_curr_vec_out_LZ_dqPE6();
    let dfdq_curr_vec_out_AX_dqPE7 = fproc.dfdq_curr_vec_out_AX_dqPE7();
    let dfdq_curr_vec_out_AY_dqPE7 = fproc.dfdq_curr_vec_out_AY_dqPE7();
    let dfdq_curr_vec_out_AZ_dqPE7 = fproc.dfdq_curr_vec_out_AZ_dqPE7();
    let dfdq_curr_vec_out_LX_dqPE7 = fproc.dfdq_curr_vec_out_LX_dqPE7();
    let dfdq_curr_vec_out_LY_dqPE7 = fproc.dfdq_curr_vec_out_LY_dqPE7();
    let dfdq_curr_vec_out_LZ_dqPE7 = fproc.dfdq_curr_vec_out_LZ_dqPE7();

    let dvdq_curr_vec_out_AX_dqPE1 = fproc.dvdq_curr_vec_out_AX_dqPE1();
    let dvdq_curr_vec_out_AY_dqPE1 = fproc.dvdq_curr_vec_out_AY_dqPE1();
    let dvdq_curr_vec_out_AZ_dqPE1 = fproc.dvdq_curr_vec_out_AZ_dqPE1();
    let dvdq_curr_vec_out_LX_dqPE1 = fproc.dvdq_curr_vec_out_LX_dqPE1();
    let dvdq_curr_vec_out_LY_dqPE1 = fproc.dvdq_curr_vec_out_LY_dqPE1();
    let dvdq_curr_vec_out_LZ_dqPE1 = fproc.dvdq_curr_vec_out_LZ_dqPE1();
    let dvdq_curr_vec_out_AX_dqPE2 = fproc.dvdq_curr_vec_out_AX_dqPE2();
    let dvdq_curr_vec_out_AY_dqPE2 = fproc.dvdq_curr_vec_out_AY_dqPE2();
    let dvdq_curr_vec_out_AZ_dqPE2 = fproc.dvdq_curr_vec_out_AZ_dqPE2();
    let dvdq_curr_vec_out_LX_dqPE2 = fproc.dvdq_curr_vec_out_LX_dqPE2();
    let dvdq_curr_vec_out_LY_dqPE2 = fproc.dvdq_curr_vec_out_LY_dqPE2();
    let dvdq_curr_vec_out_LZ_dqPE2 = fproc.dvdq_curr_vec_out_LZ_dqPE2();
    let dvdq_curr_vec_out_AX_dqPE3 = fproc.dvdq_curr_vec_out_AX_dqPE3();
    let dvdq_curr_vec_out_AY_dqPE3 = fproc.dvdq_curr_vec_out_AY_dqPE3();
    let dvdq_curr_vec_out_AZ_dqPE3 = fproc.dvdq_curr_vec_out_AZ_dqPE3();
    let dvdq_curr_vec_out_LX_dqPE3 = fproc.dvdq_curr_vec_out_LX_dqPE3();
    let dvdq_curr_vec_out_LY_dqPE3 = fproc.dvdq_curr_vec_out_LY_dqPE3();
    let dvdq_curr_vec_out_LZ_dqPE3 = fproc.dvdq_curr_vec_out_LZ_dqPE3();
    let dvdq_curr_vec_out_AX_dqPE4 = fproc.dvdq_curr_vec_out_AX_dqPE4();
    let dvdq_curr_vec_out_AY_dqPE4 = fproc.dvdq_curr_vec_out_AY_dqPE4();
    let dvdq_curr_vec_out_AZ_dqPE4 = fproc.dvdq_curr_vec_out_AZ_dqPE4();
    let dvdq_curr_vec_out_LX_dqPE4 = fproc.dvdq_curr_vec_out_LX_dqPE4();
    let dvdq_curr_vec_out_LY_dqPE4 = fproc.dvdq_curr_vec_out_LY_dqPE4();
    let dvdq_curr_vec_out_LZ_dqPE4 = fproc.dvdq_curr_vec_out_LZ_dqPE4();
    let dvdq_curr_vec_out_AX_dqPE5 = fproc.dvdq_curr_vec_out_AX_dqPE5();
    let dvdq_curr_vec_out_AY_dqPE5 = fproc.dvdq_curr_vec_out_AY_dqPE5();
    let dvdq_curr_vec_out_AZ_dqPE5 = fproc.dvdq_curr_vec_out_AZ_dqPE5();
    let dvdq_curr_vec_out_LX_dqPE5 = fproc.dvdq_curr_vec_out_LX_dqPE5();
    let dvdq_curr_vec_out_LY_dqPE5 = fproc.dvdq_curr_vec_out_LY_dqPE5();
    let dvdq_curr_vec_out_LZ_dqPE5 = fproc.dvdq_curr_vec_out_LZ_dqPE5();
    let dvdq_curr_vec_out_AX_dqPE6 = fproc.dvdq_curr_vec_out_AX_dqPE6();
    let dvdq_curr_vec_out_AY_dqPE6 = fproc.dvdq_curr_vec_out_AY_dqPE6();
    let dvdq_curr_vec_out_AZ_dqPE6 = fproc.dvdq_curr_vec_out_AZ_dqPE6();
    let dvdq_curr_vec_out_LX_dqPE6 = fproc.dvdq_curr_vec_out_LX_dqPE6();
    let dvdq_curr_vec_out_LY_dqPE6 = fproc.dvdq_curr_vec_out_LY_dqPE6();
    let dvdq_curr_vec_out_LZ_dqPE6 = fproc.dvdq_curr_vec_out_LZ_dqPE6();
    let dvdq_curr_vec_out_AX_dqPE7 = fproc.dvdq_curr_vec_out_AX_dqPE7();
    let dvdq_curr_vec_out_AY_dqPE7 = fproc.dvdq_curr_vec_out_AY_dqPE7();
    let dvdq_curr_vec_out_AZ_dqPE7 = fproc.dvdq_curr_vec_out_AZ_dqPE7();
    let dvdq_curr_vec_out_LX_dqPE7 = fproc.dvdq_curr_vec_out_LX_dqPE7();
    let dvdq_curr_vec_out_LY_dqPE7 = fproc.dvdq_curr_vec_out_LY_dqPE7();
    let dvdq_curr_vec_out_LZ_dqPE7 = fproc.dvdq_curr_vec_out_LZ_dqPE7();

    let dadq_curr_vec_out_AX_dqPE1 = fproc.dadq_curr_vec_out_AX_dqPE1();
    let dadq_curr_vec_out_AY_dqPE1 = fproc.dadq_curr_vec_out_AY_dqPE1();
    let dadq_curr_vec_out_AZ_dqPE1 = fproc.dadq_curr_vec_out_AZ_dqPE1();
    let dadq_curr_vec_out_LX_dqPE1 = fproc.dadq_curr_vec_out_LX_dqPE1();
    let dadq_curr_vec_out_LY_dqPE1 = fproc.dadq_curr_vec_out_LY_dqPE1();
    let dadq_curr_vec_out_LZ_dqPE1 = fproc.dadq_curr_vec_out_LZ_dqPE1();
    let dadq_curr_vec_out_AX_dqPE2 = fproc.dadq_curr_vec_out_AX_dqPE2();
    let dadq_curr_vec_out_AY_dqPE2 = fproc.dadq_curr_vec_out_AY_dqPE2();
    let dadq_curr_vec_out_AZ_dqPE2 = fproc.dadq_curr_vec_out_AZ_dqPE2();
    let dadq_curr_vec_out_LX_dqPE2 = fproc.dadq_curr_vec_out_LX_dqPE2();
    let dadq_curr_vec_out_LY_dqPE2 = fproc.dadq_curr_vec_out_LY_dqPE2();
    let dadq_curr_vec_out_LZ_dqPE2 = fproc.dadq_curr_vec_out_LZ_dqPE2();
    let dadq_curr_vec_out_AX_dqPE3 = fproc.dadq_curr_vec_out_AX_dqPE3();
    let dadq_curr_vec_out_AY_dqPE3 = fproc.dadq_curr_vec_out_AY_dqPE3();
    let dadq_curr_vec_out_AZ_dqPE3 = fproc.dadq_curr_vec_out_AZ_dqPE3();
    let dadq_curr_vec_out_LX_dqPE3 = fproc.dadq_curr_vec_out_LX_dqPE3();
    let dadq_curr_vec_out_LY_dqPE3 = fproc.dadq_curr_vec_out_LY_dqPE3();
    let dadq_curr_vec_out_LZ_dqPE3 = fproc.dadq_curr_vec_out_LZ_dqPE3();
    let dadq_curr_vec_out_AX_dqPE4 = fproc.dadq_curr_vec_out_AX_dqPE4();
    let dadq_curr_vec_out_AY_dqPE4 = fproc.dadq_curr_vec_out_AY_dqPE4();
    let dadq_curr_vec_out_AZ_dqPE4 = fproc.dadq_curr_vec_out_AZ_dqPE4();
    let dadq_curr_vec_out_LX_dqPE4 = fproc.dadq_curr_vec_out_LX_dqPE4();
    let dadq_curr_vec_out_LY_dqPE4 = fproc.dadq_curr_vec_out_LY_dqPE4();
    let dadq_curr_vec_out_LZ_dqPE4 = fproc.dadq_curr_vec_out_LZ_dqPE4();
    let dadq_curr_vec_out_AX_dqPE5 = fproc.dadq_curr_vec_out_AX_dqPE5();
    let dadq_curr_vec_out_AY_dqPE5 = fproc.dadq_curr_vec_out_AY_dqPE5();
    let dadq_curr_vec_out_AZ_dqPE5 = fproc.dadq_curr_vec_out_AZ_dqPE5();
    let dadq_curr_vec_out_LX_dqPE5 = fproc.dadq_curr_vec_out_LX_dqPE5();
    let dadq_curr_vec_out_LY_dqPE5 = fproc.dadq_curr_vec_out_LY_dqPE5();
    let dadq_curr_vec_out_LZ_dqPE5 = fproc.dadq_curr_vec_out_LZ_dqPE5();
    let dadq_curr_vec_out_AX_dqPE6 = fproc.dadq_curr_vec_out_AX_dqPE6();
    let dadq_curr_vec_out_AY_dqPE6 = fproc.dadq_curr_vec_out_AY_dqPE6();
    let dadq_curr_vec_out_AZ_dqPE6 = fproc.dadq_curr_vec_out_AZ_dqPE6();
    let dadq_curr_vec_out_LX_dqPE6 = fproc.dadq_curr_vec_out_LX_dqPE6();
    let dadq_curr_vec_out_LY_dqPE6 = fproc.dadq_curr_vec_out_LY_dqPE6();
    let dadq_curr_vec_out_LZ_dqPE6 = fproc.dadq_curr_vec_out_LZ_dqPE6();
    let dadq_curr_vec_out_AX_dqPE7 = fproc.dadq_curr_vec_out_AX_dqPE7();
    let dadq_curr_vec_out_AY_dqPE7 = fproc.dadq_curr_vec_out_AY_dqPE7();
    let dadq_curr_vec_out_AZ_dqPE7 = fproc.dadq_curr_vec_out_AZ_dqPE7();
    let dadq_curr_vec_out_LX_dqPE7 = fproc.dadq_curr_vec_out_LX_dqPE7();
    let dadq_curr_vec_out_LY_dqPE7 = fproc.dadq_curr_vec_out_LY_dqPE7();
    let dadq_curr_vec_out_LZ_dqPE7 = fproc.dadq_curr_vec_out_LZ_dqPE7();


    //***************************************/

    //********* DQDPE OUTPUT REDIRECTION ********/

    let dfdqd_curr_vec_out_AX_dqdPE1 = fproc.dfdqd_curr_vec_out_AX_dqdPE1();
    let dfdqd_curr_vec_out_AY_dqdPE1 = fproc.dfdqd_curr_vec_out_AY_dqdPE1();
    let dfdqd_curr_vec_out_AZ_dqdPE1 = fproc.dfdqd_curr_vec_out_AZ_dqdPE1();
    let dfdqd_curr_vec_out_LX_dqdPE1 = fproc.dfdqd_curr_vec_out_LX_dqdPE1();
    let dfdqd_curr_vec_out_LY_dqdPE1 = fproc.dfdqd_curr_vec_out_LY_dqdPE1();
    let dfdqd_curr_vec_out_LZ_dqdPE1 = fproc.dfdqd_curr_vec_out_LZ_dqdPE1();
    let dfdqd_curr_vec_out_AX_dqdPE2 = fproc.dfdqd_curr_vec_out_AX_dqdPE2();
    let dfdqd_curr_vec_out_AY_dqdPE2 = fproc.dfdqd_curr_vec_out_AY_dqdPE2();
    let dfdqd_curr_vec_out_AZ_dqdPE2 = fproc.dfdqd_curr_vec_out_AZ_dqdPE2();
    let dfdqd_curr_vec_out_LX_dqdPE2 = fproc.dfdqd_curr_vec_out_LX_dqdPE2();
    let dfdqd_curr_vec_out_LY_dqdPE2 = fproc.dfdqd_curr_vec_out_LY_dqdPE2();
    let dfdqd_curr_vec_out_LZ_dqdPE2 = fproc.dfdqd_curr_vec_out_LZ_dqdPE2();
    let dfdqd_curr_vec_out_AX_dqdPE3 = fproc.dfdqd_curr_vec_out_AX_dqdPE3();
    let dfdqd_curr_vec_out_AY_dqdPE3 = fproc.dfdqd_curr_vec_out_AY_dqdPE3();
    let dfdqd_curr_vec_out_AZ_dqdPE3 = fproc.dfdqd_curr_vec_out_AZ_dqdPE3();
    let dfdqd_curr_vec_out_LX_dqdPE3 = fproc.dfdqd_curr_vec_out_LX_dqdPE3();
    let dfdqd_curr_vec_out_LY_dqdPE3 = fproc.dfdqd_curr_vec_out_LY_dqdPE3();
    let dfdqd_curr_vec_out_LZ_dqdPE3 = fproc.dfdqd_curr_vec_out_LZ_dqdPE3();
    let dfdqd_curr_vec_out_AX_dqdPE4 = fproc.dfdqd_curr_vec_out_AX_dqdPE4();
    let dfdqd_curr_vec_out_AY_dqdPE4 = fproc.dfdqd_curr_vec_out_AY_dqdPE4();
    let dfdqd_curr_vec_out_AZ_dqdPE4 = fproc.dfdqd_curr_vec_out_AZ_dqdPE4();
    let dfdqd_curr_vec_out_LX_dqdPE4 = fproc.dfdqd_curr_vec_out_LX_dqdPE4();
    let dfdqd_curr_vec_out_LY_dqdPE4 = fproc.dfdqd_curr_vec_out_LY_dqdPE4();
    let dfdqd_curr_vec_out_LZ_dqdPE4 = fproc.dfdqd_curr_vec_out_LZ_dqdPE4();
    let dfdqd_curr_vec_out_AX_dqdPE5 = fproc.dfdqd_curr_vec_out_AX_dqdPE5();
    let dfdqd_curr_vec_out_AY_dqdPE5 = fproc.dfdqd_curr_vec_out_AY_dqdPE5();
    let dfdqd_curr_vec_out_AZ_dqdPE5 = fproc.dfdqd_curr_vec_out_AZ_dqdPE5();
    let dfdqd_curr_vec_out_LX_dqdPE5 = fproc.dfdqd_curr_vec_out_LX_dqdPE5();
    let dfdqd_curr_vec_out_LY_dqdPE5 = fproc.dfdqd_curr_vec_out_LY_dqdPE5();
    let dfdqd_curr_vec_out_LZ_dqdPE5 = fproc.dfdqd_curr_vec_out_LZ_dqdPE5();
    let dfdqd_curr_vec_out_AX_dqdPE6 = fproc.dfdqd_curr_vec_out_AX_dqdPE6();
    let dfdqd_curr_vec_out_AY_dqdPE6 = fproc.dfdqd_curr_vec_out_AY_dqdPE6();
    let dfdqd_curr_vec_out_AZ_dqdPE6 = fproc.dfdqd_curr_vec_out_AZ_dqdPE6();
    let dfdqd_curr_vec_out_LX_dqdPE6 = fproc.dfdqd_curr_vec_out_LX_dqdPE6();
    let dfdqd_curr_vec_out_LY_dqdPE6 = fproc.dfdqd_curr_vec_out_LY_dqdPE6();
    let dfdqd_curr_vec_out_LZ_dqdPE6 = fproc.dfdqd_curr_vec_out_LZ_dqdPE6();
    let dfdqd_curr_vec_out_AX_dqdPE7 = fproc.dfdqd_curr_vec_out_AX_dqdPE7();
    let dfdqd_curr_vec_out_AY_dqdPE7 = fproc.dfdqd_curr_vec_out_AY_dqdPE7();
    let dfdqd_curr_vec_out_AZ_dqdPE7 = fproc.dfdqd_curr_vec_out_AZ_dqdPE7();
    let dfdqd_curr_vec_out_LX_dqdPE7 = fproc.dfdqd_curr_vec_out_LX_dqdPE7();
    let dfdqd_curr_vec_out_LY_dqdPE7 = fproc.dfdqd_curr_vec_out_LY_dqdPE7();
    let dfdqd_curr_vec_out_LZ_dqdPE7 = fproc.dfdqd_curr_vec_out_LZ_dqdPE7();

    let dvdqd_curr_vec_out_AX_dqdPE1 = fproc.dvdqd_curr_vec_out_AX_dqdPE1();
    let dvdqd_curr_vec_out_AY_dqdPE1 = fproc.dvdqd_curr_vec_out_AY_dqdPE1();
    let dvdqd_curr_vec_out_AZ_dqdPE1 = fproc.dvdqd_curr_vec_out_AZ_dqdPE1();
    let dvdqd_curr_vec_out_LX_dqdPE1 = fproc.dvdqd_curr_vec_out_LX_dqdPE1();
    let dvdqd_curr_vec_out_LY_dqdPE1 = fproc.dvdqd_curr_vec_out_LY_dqdPE1();
    let dvdqd_curr_vec_out_LZ_dqdPE1 = fproc.dvdqd_curr_vec_out_LZ_dqdPE1();
    let dvdqd_curr_vec_out_AX_dqdPE2 = fproc.dvdqd_curr_vec_out_AX_dqdPE2();
    let dvdqd_curr_vec_out_AY_dqdPE2 = fproc.dvdqd_curr_vec_out_AY_dqdPE2();
    let dvdqd_curr_vec_out_AZ_dqdPE2 = fproc.dvdqd_curr_vec_out_AZ_dqdPE2();
    let dvdqd_curr_vec_out_LX_dqdPE2 = fproc.dvdqd_curr_vec_out_LX_dqdPE2();
    let dvdqd_curr_vec_out_LY_dqdPE2 = fproc.dvdqd_curr_vec_out_LY_dqdPE2();
    let dvdqd_curr_vec_out_LZ_dqdPE2 = fproc.dvdqd_curr_vec_out_LZ_dqdPE2();
    let dvdqd_curr_vec_out_AX_dqdPE3 = fproc.dvdqd_curr_vec_out_AX_dqdPE3();
    let dvdqd_curr_vec_out_AY_dqdPE3 = fproc.dvdqd_curr_vec_out_AY_dqdPE3();
    let dvdqd_curr_vec_out_AZ_dqdPE3 = fproc.dvdqd_curr_vec_out_AZ_dqdPE3();
    let dvdqd_curr_vec_out_LX_dqdPE3 = fproc.dvdqd_curr_vec_out_LX_dqdPE3();
    let dvdqd_curr_vec_out_LY_dqdPE3 = fproc.dvdqd_curr_vec_out_LY_dqdPE3();
    let dvdqd_curr_vec_out_LZ_dqdPE3 = fproc.dvdqd_curr_vec_out_LZ_dqdPE3();
    let dvdqd_curr_vec_out_AX_dqdPE4 = fproc.dvdqd_curr_vec_out_AX_dqdPE4();
    let dvdqd_curr_vec_out_AY_dqdPE4 = fproc.dvdqd_curr_vec_out_AY_dqdPE4();
    let dvdqd_curr_vec_out_AZ_dqdPE4 = fproc.dvdqd_curr_vec_out_AZ_dqdPE4();
    let dvdqd_curr_vec_out_LX_dqdPE4 = fproc.dvdqd_curr_vec_out_LX_dqdPE4();
    let dvdqd_curr_vec_out_LY_dqdPE4 = fproc.dvdqd_curr_vec_out_LY_dqdPE4();
    let dvdqd_curr_vec_out_LZ_dqdPE4 = fproc.dvdqd_curr_vec_out_LZ_dqdPE4();
    let dvdqd_curr_vec_out_AX_dqdPE5 = fproc.dvdqd_curr_vec_out_AX_dqdPE5();
    let dvdqd_curr_vec_out_AY_dqdPE5 = fproc.dvdqd_curr_vec_out_AY_dqdPE5();
    let dvdqd_curr_vec_out_AZ_dqdPE5 = fproc.dvdqd_curr_vec_out_AZ_dqdPE5();
    let dvdqd_curr_vec_out_LX_dqdPE5 = fproc.dvdqd_curr_vec_out_LX_dqdPE5();
    let dvdqd_curr_vec_out_LY_dqdPE5 = fproc.dvdqd_curr_vec_out_LY_dqdPE5();
    let dvdqd_curr_vec_out_LZ_dqdPE5 = fproc.dvdqd_curr_vec_out_LZ_dqdPE5();
    let dvdqd_curr_vec_out_AX_dqdPE6 = fproc.dvdqd_curr_vec_out_AX_dqdPE6();
    let dvdqd_curr_vec_out_AY_dqdPE6 = fproc.dvdqd_curr_vec_out_AY_dqdPE6();
    let dvdqd_curr_vec_out_AZ_dqdPE6 = fproc.dvdqd_curr_vec_out_AZ_dqdPE6();
    let dvdqd_curr_vec_out_LX_dqdPE6 = fproc.dvdqd_curr_vec_out_LX_dqdPE6();
    let dvdqd_curr_vec_out_LY_dqdPE6 = fproc.dvdqd_curr_vec_out_LY_dqdPE6();
    let dvdqd_curr_vec_out_LZ_dqdPE6 = fproc.dvdqd_curr_vec_out_LZ_dqdPE6();
    let dvdqd_curr_vec_out_AX_dqdPE7 = fproc.dvdqd_curr_vec_out_AX_dqdPE7();
    let dvdqd_curr_vec_out_AY_dqdPE7 = fproc.dvdqd_curr_vec_out_AY_dqdPE7();
    let dvdqd_curr_vec_out_AZ_dqdPE7 = fproc.dvdqd_curr_vec_out_AZ_dqdPE7();
    let dvdqd_curr_vec_out_LX_dqdPE7 = fproc.dvdqd_curr_vec_out_LX_dqdPE7();
    let dvdqd_curr_vec_out_LY_dqdPE7 = fproc.dvdqd_curr_vec_out_LY_dqdPE7();
    let dvdqd_curr_vec_out_LZ_dqdPE7 = fproc.dvdqd_curr_vec_out_LZ_dqdPE7();

    let dadqd_curr_vec_out_AX_dqdPE1 = fproc.dadqd_curr_vec_out_AX_dqdPE1();
    let dadqd_curr_vec_out_AY_dqdPE1 = fproc.dadqd_curr_vec_out_AY_dqdPE1();
    let dadqd_curr_vec_out_AZ_dqdPE1 = fproc.dadqd_curr_vec_out_AZ_dqdPE1();
    let dadqd_curr_vec_out_LX_dqdPE1 = fproc.dadqd_curr_vec_out_LX_dqdPE1();
    let dadqd_curr_vec_out_LY_dqdPE1 = fproc.dadqd_curr_vec_out_LY_dqdPE1();
    let dadqd_curr_vec_out_LZ_dqdPE1 = fproc.dadqd_curr_vec_out_LZ_dqdPE1();
    let dadqd_curr_vec_out_AX_dqdPE2 = fproc.dadqd_curr_vec_out_AX_dqdPE2();
    let dadqd_curr_vec_out_AY_dqdPE2 = fproc.dadqd_curr_vec_out_AY_dqdPE2();
    let dadqd_curr_vec_out_AZ_dqdPE2 = fproc.dadqd_curr_vec_out_AZ_dqdPE2();
    let dadqd_curr_vec_out_LX_dqdPE2 = fproc.dadqd_curr_vec_out_LX_dqdPE2();
    let dadqd_curr_vec_out_LY_dqdPE2 = fproc.dadqd_curr_vec_out_LY_dqdPE2();
    let dadqd_curr_vec_out_LZ_dqdPE2 = fproc.dadqd_curr_vec_out_LZ_dqdPE2();
    let dadqd_curr_vec_out_AX_dqdPE3 = fproc.dadqd_curr_vec_out_AX_dqdPE3();
    let dadqd_curr_vec_out_AY_dqdPE3 = fproc.dadqd_curr_vec_out_AY_dqdPE3();
    let dadqd_curr_vec_out_AZ_dqdPE3 = fproc.dadqd_curr_vec_out_AZ_dqdPE3();
    let dadqd_curr_vec_out_LX_dqdPE3 = fproc.dadqd_curr_vec_out_LX_dqdPE3();
    let dadqd_curr_vec_out_LY_dqdPE3 = fproc.dadqd_curr_vec_out_LY_dqdPE3();
    let dadqd_curr_vec_out_LZ_dqdPE3 = fproc.dadqd_curr_vec_out_LZ_dqdPE3();
    let dadqd_curr_vec_out_AX_dqdPE4 = fproc.dadqd_curr_vec_out_AX_dqdPE4();
    let dadqd_curr_vec_out_AY_dqdPE4 = fproc.dadqd_curr_vec_out_AY_dqdPE4();
    let dadqd_curr_vec_out_AZ_dqdPE4 = fproc.dadqd_curr_vec_out_AZ_dqdPE4();
    let dadqd_curr_vec_out_LX_dqdPE4 = fproc.dadqd_curr_vec_out_LX_dqdPE4();
    let dadqd_curr_vec_out_LY_dqdPE4 = fproc.dadqd_curr_vec_out_LY_dqdPE4();
    let dadqd_curr_vec_out_LZ_dqdPE4 = fproc.dadqd_curr_vec_out_LZ_dqdPE4();
    let dadqd_curr_vec_out_AX_dqdPE5 = fproc.dadqd_curr_vec_out_AX_dqdPE5();
    let dadqd_curr_vec_out_AY_dqdPE5 = fproc.dadqd_curr_vec_out_AY_dqdPE5();
    let dadqd_curr_vec_out_AZ_dqdPE5 = fproc.dadqd_curr_vec_out_AZ_dqdPE5();
    let dadqd_curr_vec_out_LX_dqdPE5 = fproc.dadqd_curr_vec_out_LX_dqdPE5();
    let dadqd_curr_vec_out_LY_dqdPE5 = fproc.dadqd_curr_vec_out_LY_dqdPE5();
    let dadqd_curr_vec_out_LZ_dqdPE5 = fproc.dadqd_curr_vec_out_LZ_dqdPE5();
    let dadqd_curr_vec_out_AX_dqdPE6 = fproc.dadqd_curr_vec_out_AX_dqdPE6();
    let dadqd_curr_vec_out_AY_dqdPE6 = fproc.dadqd_curr_vec_out_AY_dqdPE6();
    let dadqd_curr_vec_out_AZ_dqdPE6 = fproc.dadqd_curr_vec_out_AZ_dqdPE6();
    let dadqd_curr_vec_out_LX_dqdPE6 = fproc.dadqd_curr_vec_out_LX_dqdPE6();
    let dadqd_curr_vec_out_LY_dqdPE6 = fproc.dadqd_curr_vec_out_LY_dqdPE6();
    let dadqd_curr_vec_out_LZ_dqdPE6 = fproc.dadqd_curr_vec_out_LZ_dqdPE6();
    let dadqd_curr_vec_out_AX_dqdPE7 = fproc.dadqd_curr_vec_out_AX_dqdPE7();
    let dadqd_curr_vec_out_AY_dqdPE7 = fproc.dadqd_curr_vec_out_AY_dqdPE7();
    let dadqd_curr_vec_out_AZ_dqdPE7 = fproc.dadqd_curr_vec_out_AZ_dqdPE7();
    let dadqd_curr_vec_out_LX_dqdPE7 = fproc.dadqd_curr_vec_out_LX_dqdPE7();
    let dadqd_curr_vec_out_LY_dqdPE7 = fproc.dadqd_curr_vec_out_LY_dqdPE7();
    let dadqd_curr_vec_out_LZ_dqdPE7 = fproc.dadqd_curr_vec_out_LZ_dqdPE7();


    //***********************************

    let new_f_inter_acc = f_inter_acc;
    let new_dfidq_inter_acc = dfidq_inter_acc;
    let new_dfidqd_inter_acc = dfidqd_inter_acc;

`include "GradientPipelineFprocIntermediateMuxUnrolling.bsv"

    //**********************************

    Vector#(6,Bit#(32)) vec_f = vec(f_curr_vec_out_AX_rnea, f_curr_vec_out_AY_rnea, f_curr_vec_out_AZ_rnea, f_curr_vec_out_LX_rnea, f_curr_vec_out_LY_rnea, f_curr_vec_out_LZ_rnea);
    Vector#(6,Bit#(32)) vec_a = vec(a_curr_vec_out_AX_rnea, a_curr_vec_out_AY_rnea, a_curr_vec_out_AZ_rnea, a_curr_vec_out_LX_rnea, a_curr_vec_out_LY_rnea, a_curr_vec_out_LZ_rnea);
    Vector#(6,Bit#(32)) vec_v = vec(v_curr_vec_out_AX_rnea, v_curr_vec_out_AY_rnea, v_curr_vec_out_AZ_rnea, v_curr_vec_out_LX_rnea, v_curr_vec_out_LY_rnea, v_curr_vec_out_LZ_rnea);

    Vector#(6,Bit#(32)) vec_dvdq_PE1 = vec(dvdq_curr_vec_out_AX_dqPE1,dvdq_curr_vec_out_AY_dqPE1,dvdq_curr_vec_out_AZ_dqPE1,dvdq_curr_vec_out_LX_dqPE1,dvdq_curr_vec_out_LY_dqPE1,dvdq_curr_vec_out_LZ_dqPE1);
    Vector#(6,Bit#(32)) vec_dvdq_PE2 = vec(dvdq_curr_vec_out_AX_dqPE2,dvdq_curr_vec_out_AY_dqPE2,dvdq_curr_vec_out_AZ_dqPE2,dvdq_curr_vec_out_LX_dqPE2,dvdq_curr_vec_out_LY_dqPE2,dvdq_curr_vec_out_LZ_dqPE2);
    Vector#(6,Bit#(32)) vec_dvdq_PE3 = vec(dvdq_curr_vec_out_AX_dqPE3,dvdq_curr_vec_out_AY_dqPE3,dvdq_curr_vec_out_AZ_dqPE3,dvdq_curr_vec_out_LX_dqPE3,dvdq_curr_vec_out_LY_dqPE3,dvdq_curr_vec_out_LZ_dqPE3);
    Vector#(6,Bit#(32)) vec_dvdq_PE4 = vec(dvdq_curr_vec_out_AX_dqPE4,dvdq_curr_vec_out_AY_dqPE4,dvdq_curr_vec_out_AZ_dqPE4,dvdq_curr_vec_out_LX_dqPE4,dvdq_curr_vec_out_LY_dqPE4,dvdq_curr_vec_out_LZ_dqPE4);
    Vector#(6,Bit#(32)) vec_dvdq_PE5 = vec(dvdq_curr_vec_out_AX_dqPE5,dvdq_curr_vec_out_AY_dqPE5,dvdq_curr_vec_out_AZ_dqPE5,dvdq_curr_vec_out_LX_dqPE5,dvdq_curr_vec_out_LY_dqPE5,dvdq_curr_vec_out_LZ_dqPE5);
    Vector#(6,Bit#(32)) vec_dvdq_PE6 = vec(dvdq_curr_vec_out_AX_dqPE6,dvdq_curr_vec_out_AY_dqPE6,dvdq_curr_vec_out_AZ_dqPE6,dvdq_curr_vec_out_LX_dqPE6,dvdq_curr_vec_out_LY_dqPE6,dvdq_curr_vec_out_LZ_dqPE6);
    Vector#(6,Bit#(32)) vec_dvdq_PE7 = vec(dvdq_curr_vec_out_AX_dqPE7,dvdq_curr_vec_out_AY_dqPE7,dvdq_curr_vec_out_AZ_dqPE7,dvdq_curr_vec_out_LX_dqPE7,dvdq_curr_vec_out_LY_dqPE7,dvdq_curr_vec_out_LZ_dqPE7);

    Vector#(6,Bit#(32)) vec_dadq_PE1 = vec(dadq_curr_vec_out_AX_dqPE1,dadq_curr_vec_out_AY_dqPE1,dadq_curr_vec_out_AZ_dqPE1,dadq_curr_vec_out_LX_dqPE1,dadq_curr_vec_out_LY_dqPE1,dadq_curr_vec_out_LZ_dqPE1);
    Vector#(6,Bit#(32)) vec_dadq_PE2 = vec(dadq_curr_vec_out_AX_dqPE2,dadq_curr_vec_out_AY_dqPE2,dadq_curr_vec_out_AZ_dqPE2,dadq_curr_vec_out_LX_dqPE2,dadq_curr_vec_out_LY_dqPE2,dadq_curr_vec_out_LZ_dqPE2);
    Vector#(6,Bit#(32)) vec_dadq_PE3 = vec(dadq_curr_vec_out_AX_dqPE3,dadq_curr_vec_out_AY_dqPE3,dadq_curr_vec_out_AZ_dqPE3,dadq_curr_vec_out_LX_dqPE3,dadq_curr_vec_out_LY_dqPE3,dadq_curr_vec_out_LZ_dqPE3);
    Vector#(6,Bit#(32)) vec_dadq_PE4 = vec(dadq_curr_vec_out_AX_dqPE4,dadq_curr_vec_out_AY_dqPE4,dadq_curr_vec_out_AZ_dqPE4,dadq_curr_vec_out_LX_dqPE4,dadq_curr_vec_out_LY_dqPE4,dadq_curr_vec_out_LZ_dqPE4);
    Vector#(6,Bit#(32)) vec_dadq_PE5 = vec(dadq_curr_vec_out_AX_dqPE5,dadq_curr_vec_out_AY_dqPE5,dadq_curr_vec_out_AZ_dqPE5,dadq_curr_vec_out_LX_dqPE5,dadq_curr_vec_out_LY_dqPE5,dadq_curr_vec_out_LZ_dqPE5);
    Vector#(6,Bit#(32)) vec_dadq_PE6 = vec(dadq_curr_vec_out_AX_dqPE6,dadq_curr_vec_out_AY_dqPE6,dadq_curr_vec_out_AZ_dqPE6,dadq_curr_vec_out_LX_dqPE6,dadq_curr_vec_out_LY_dqPE6,dadq_curr_vec_out_LZ_dqPE6);
    Vector#(6,Bit#(32)) vec_dadq_PE7 = vec(dadq_curr_vec_out_AX_dqPE7,dadq_curr_vec_out_AY_dqPE7,dadq_curr_vec_out_AZ_dqPE7,dadq_curr_vec_out_LX_dqPE7,dadq_curr_vec_out_LY_dqPE7,dadq_curr_vec_out_LZ_dqPE7);

    Vector#(6,Bit#(32)) vec_dvdqd_PE1 = vec(dvdqd_curr_vec_out_AX_dqdPE1,dvdqd_curr_vec_out_AY_dqdPE1,dvdqd_curr_vec_out_AZ_dqdPE1,dvdqd_curr_vec_out_LX_dqdPE1,dvdqd_curr_vec_out_LY_dqdPE1,dvdqd_curr_vec_out_LZ_dqdPE1);
    Vector#(6,Bit#(32)) vec_dvdqd_PE2 = vec(dvdqd_curr_vec_out_AX_dqdPE2,dvdqd_curr_vec_out_AY_dqdPE2,dvdqd_curr_vec_out_AZ_dqdPE2,dvdqd_curr_vec_out_LX_dqdPE2,dvdqd_curr_vec_out_LY_dqdPE2,dvdqd_curr_vec_out_LZ_dqdPE2);
    Vector#(6,Bit#(32)) vec_dvdqd_PE3 = vec(dvdqd_curr_vec_out_AX_dqdPE3,dvdqd_curr_vec_out_AY_dqdPE3,dvdqd_curr_vec_out_AZ_dqdPE3,dvdqd_curr_vec_out_LX_dqdPE3,dvdqd_curr_vec_out_LY_dqdPE3,dvdqd_curr_vec_out_LZ_dqdPE3);
    Vector#(6,Bit#(32)) vec_dvdqd_PE4 = vec(dvdqd_curr_vec_out_AX_dqdPE4,dvdqd_curr_vec_out_AY_dqdPE4,dvdqd_curr_vec_out_AZ_dqdPE4,dvdqd_curr_vec_out_LX_dqdPE4,dvdqd_curr_vec_out_LY_dqdPE4,dvdqd_curr_vec_out_LZ_dqdPE4);
    Vector#(6,Bit#(32)) vec_dvdqd_PE5 = vec(dvdqd_curr_vec_out_AX_dqdPE5,dvdqd_curr_vec_out_AY_dqdPE5,dvdqd_curr_vec_out_AZ_dqdPE5,dvdqd_curr_vec_out_LX_dqdPE5,dvdqd_curr_vec_out_LY_dqdPE5,dvdqd_curr_vec_out_LZ_dqdPE5);
    Vector#(6,Bit#(32)) vec_dvdqd_PE6 = vec(dvdqd_curr_vec_out_AX_dqdPE6,dvdqd_curr_vec_out_AY_dqdPE6,dvdqd_curr_vec_out_AZ_dqdPE6,dvdqd_curr_vec_out_LX_dqdPE6,dvdqd_curr_vec_out_LY_dqdPE6,dvdqd_curr_vec_out_LZ_dqdPE6);
    Vector#(6,Bit#(32)) vec_dvdqd_PE7 = vec(dvdqd_curr_vec_out_AX_dqdPE7,dvdqd_curr_vec_out_AY_dqdPE7,dvdqd_curr_vec_out_AZ_dqdPE7,dvdqd_curr_vec_out_LX_dqdPE7,dvdqd_curr_vec_out_LY_dqdPE7,dvdqd_curr_vec_out_LZ_dqdPE7);

    Vector#(6,Bit#(32)) vec_dadqd_PE1 = vec(dadqd_curr_vec_out_AX_dqdPE1,dadqd_curr_vec_out_AY_dqdPE1,dadqd_curr_vec_out_AZ_dqdPE1,dadqd_curr_vec_out_LX_dqdPE1,dadqd_curr_vec_out_LY_dqdPE1,dadqd_curr_vec_out_LZ_dqdPE1);
    Vector#(6,Bit#(32)) vec_dadqd_PE2 = vec(dadqd_curr_vec_out_AX_dqdPE2,dadqd_curr_vec_out_AY_dqdPE2,dadqd_curr_vec_out_AZ_dqdPE2,dadqd_curr_vec_out_LX_dqdPE2,dadqd_curr_vec_out_LY_dqdPE2,dadqd_curr_vec_out_LZ_dqdPE2);
    Vector#(6,Bit#(32)) vec_dadqd_PE3 = vec(dadqd_curr_vec_out_AX_dqdPE3,dadqd_curr_vec_out_AY_dqdPE3,dadqd_curr_vec_out_AZ_dqdPE3,dadqd_curr_vec_out_LX_dqdPE3,dadqd_curr_vec_out_LY_dqdPE3,dadqd_curr_vec_out_LZ_dqdPE3);
    Vector#(6,Bit#(32)) vec_dadqd_PE4 = vec(dadqd_curr_vec_out_AX_dqdPE4,dadqd_curr_vec_out_AY_dqdPE4,dadqd_curr_vec_out_AZ_dqdPE4,dadqd_curr_vec_out_LX_dqdPE4,dadqd_curr_vec_out_LY_dqdPE4,dadqd_curr_vec_out_LZ_dqdPE4);
    Vector#(6,Bit#(32)) vec_dadqd_PE5 = vec(dadqd_curr_vec_out_AX_dqdPE5,dadqd_curr_vec_out_AY_dqdPE5,dadqd_curr_vec_out_AZ_dqdPE5,dadqd_curr_vec_out_LX_dqdPE5,dadqd_curr_vec_out_LY_dqdPE5,dadqd_curr_vec_out_LZ_dqdPE5);
    Vector#(6,Bit#(32)) vec_dadqd_PE6 = vec(dadqd_curr_vec_out_AX_dqdPE6,dadqd_curr_vec_out_AY_dqdPE6,dadqd_curr_vec_out_AZ_dqdPE6,dadqd_curr_vec_out_LX_dqdPE6,dadqd_curr_vec_out_LY_dqdPE6,dadqd_curr_vec_out_LZ_dqdPE6);
    Vector#(6,Bit#(32)) vec_dadqd_PE7 = vec(dadqd_curr_vec_out_AX_dqdPE7,dadqd_curr_vec_out_AY_dqdPE7,dadqd_curr_vec_out_AZ_dqdPE7,dadqd_curr_vec_out_LX_dqdPE7,dadqd_curr_vec_out_LY_dqdPE7,dadqd_curr_vec_out_LZ_dqdPE7);

    DvDaIntermediate dvda_PE1 = DvDaIntermediate {dadqd: unpack(pack(vec_dadqd_PE1)), dvdqd: unpack(pack(vec_dvdqd_PE1)), dadq: unpack(pack(vec_dadq_PE1)), dvdq: unpack(pack(vec_dvdq_PE1))};
    DvDaIntermediate dvda_PE2 = DvDaIntermediate {dadqd: unpack(pack(vec_dadqd_PE2)), dvdqd: unpack(pack(vec_dvdqd_PE2)), dadq: unpack(pack(vec_dadq_PE2)), dvdq: unpack(pack(vec_dvdq_PE2))};
    DvDaIntermediate dvda_PE3 = DvDaIntermediate {dadqd: unpack(pack(vec_dadqd_PE3)), dvdqd: unpack(pack(vec_dvdqd_PE3)), dadq: unpack(pack(vec_dadq_PE3)), dvdq: unpack(pack(vec_dvdq_PE3))};
    DvDaIntermediate dvda_PE4 = DvDaIntermediate {dadqd: unpack(pack(vec_dadqd_PE4)), dvdqd: unpack(pack(vec_dvdqd_PE4)), dadq: unpack(pack(vec_dadq_PE4)), dvdq: unpack(pack(vec_dvdq_PE4))};
    DvDaIntermediate dvda_PE5 = DvDaIntermediate {dadqd: unpack(pack(vec_dadqd_PE5)), dvdqd: unpack(pack(vec_dvdqd_PE5)), dadq: unpack(pack(vec_dadq_PE5)), dvdq: unpack(pack(vec_dvdq_PE5))};
    DvDaIntermediate dvda_PE6 = DvDaIntermediate {dadqd: unpack(pack(vec_dadqd_PE6)), dvdqd: unpack(pack(vec_dvdqd_PE6)), dadq: unpack(pack(vec_dadq_PE6)), dvdq: unpack(pack(vec_dvdq_PE6))};
    DvDaIntermediate dvda_PE7 = DvDaIntermediate {dadqd: unpack(pack(vec_dadqd_PE7)), dvdqd: unpack(pack(vec_dvdqd_PE7)), dadq: unpack(pack(vec_dadq_PE7)), dvdq: unpack(pack(vec_dvdq_PE7))};

    // s/8/LEN_SCHED-1
    if (idx_forward_stream == len_fproc_sched-1) begin
        for (int i=0; i<=7; i=i+1) begin
            dvda_prev[i] <= DvDaIntermediate {dadqd: unpack(0), dvdqd: unpack(0), dadq: unpack(0), dvdq: unpack(0)};
        end
    end
    else begin
        if (link_out_curr_rnea != 0) begin
            rnea_acc[link_out_curr_rnea] <= RNEAIntermediate {v : unpack(pack(vec_v)), a : unpack(pack(vec_a)), f: unpack(pack(vec_f))};
        end

        for (int i=1; i<=7; i=i+1) begin
            // this is same calculation as link_out_curr_PEx, just wanted to for-loopify it
            let link_out_curr_PE = fproc_curr_sched[idx_forward_stream][i-1];
            DvDaIntermediate dvda_PE;
            case(i)
                1: dvda_PE = dvda_PE1;
                2: dvda_PE = dvda_PE2;
                3: dvda_PE = dvda_PE3;
                4: dvda_PE = dvda_PE4;
                5: dvda_PE = dvda_PE5;
                6: dvda_PE = dvda_PE6;
                7: dvda_PE = dvda_PE7;
            endcase

`include "GradientPipelineFprocDvDaFlush.bsv"

            // branch regs for each PE
            //// branching case
        end
    end

    //for (int i=1; i<=7; i=i+1)
    //    $display("dvda_prev[", fshow(i), "]: ", fshow(dvda_prev[i]));

    //for (int i=1; i<=7; i=i+1)
    //    $display("rnea_acc[", fshow(i), "]: ", fshow(rnea_acc[i]));

    if (idx_forward_stream == len_fproc_sched-1) begin
        $display("rnea for all links");
        for (int lid=1; lid<=7; lid=lid+1) begin
            $display(fshow(new_f_inter_acc[lid]));
        end

        for (int lid=1; lid<=7; lid=lid+1) begin
            $display("dfdq for link ", fshow(lid));
            for (int i=0; i<6; i=i+1) begin
                $display(fshow(new_dfidq_inter_acc[lid][i]));
            end
        end

        for (int lid=1; lid<=7; lid=lid+1) begin
            $display("dfdqd for link ", fshow(lid));
            for (int i=0; i<6; i=i+1) begin
                $display(fshow(new_dfidqd_inter_acc[lid][i]));
            end
        end
    end

    //**********************************

    $display("Idx", fshow(idx_forward_stream));

    f_inter_acc <= new_f_inter_acc;
    dfidq_inter_acc <= new_dfidq_inter_acc;
    dfidqd_inter_acc <= new_dfidqd_inter_acc;

    //**************************
        

    let newid = idx_forward_stream + 1;
    // s/7/len_sched-1
    if (idx_forward_stream == len_fproc_sched-1) begin
        // s/9/num_links+2 because bproc takes num_links+1 as input and embed is 1-indexed
        Vector#(9, Intermediate2) embed;
        embed[0] = unpack(0);
        for (int i = 1; i <= 7; i = i + 1) begin
            // embed,inter_acc are 1-indexed
            embed[i] = Intermediate2 {dfidqd : unpack(pack(new_dfidqd_inter_acc[i])), dfidq : unpack(pack(new_dfidq_inter_acc[i])), f: unpack(pack(new_f_inter_acc[i]))};
        end
        embed[8] = unpack(0);
        intermediate_values.enq(embed);
        newid = 0;
    end
    idx_forward_stream <= newid; 

    $display("=========== FPROC STREAM for idx ", idx_forward_stream, " END =============");
endrule
