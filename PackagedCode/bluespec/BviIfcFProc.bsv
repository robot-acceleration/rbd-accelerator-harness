import Clocks::*;
(* always_ready, always_enabled *)
interface FProc;
    (* always_ready *)
    method Action get_data();

    method Action sinq_curr_in(Bit#(32) v);
    method Action cosq_curr_in(Bit#(32) v);

    method Action qd_curr_in(Bit#(32) v);
   // v_curr_vec_in, 6 values

    method Action v_curr_vec_in_AX(Bit#(32) v);
    method Action v_curr_vec_in_AY(Bit#(32) v);
    method Action v_curr_vec_in_AZ(Bit#(32) v);
    method Action v_curr_vec_in_LX(Bit#(32) v);
    method Action v_curr_vec_in_LY(Bit#(32) v);
    method Action v_curr_vec_in_LZ(Bit#(32) v);

   // a_curr_vec_in, 6 values
    method Action a_curr_vec_in_AX(Bit#(32) v);
    method Action a_curr_vec_in_AY(Bit#(32) v);
    method Action a_curr_vec_in_AZ(Bit#(32) v);
    method Action a_curr_vec_in_LX(Bit#(32) v);
    method Action a_curr_vec_in_LY(Bit#(32) v);
    method Action a_curr_vec_in_LZ(Bit#(32) v);

   // output_ready
    method Bit#(1) output_ready();

    method Bit#(32) dfidq_curr_mat_out_AX_J1();
    method Bit#(32) dfidq_curr_mat_out_AX_J2();
    method Bit#(32) dfidq_curr_mat_out_AX_J3();
    method Bit#(32) dfidq_curr_mat_out_AX_J4();
    method Bit#(32) dfidq_curr_mat_out_AX_J5();
    method Bit#(32) dfidq_curr_mat_out_AX_J6();
    method Bit#(32) dfidq_curr_mat_out_AX_J7();

    method Bit#(32) dfidq_curr_mat_out_AY_J1();
    method Bit#(32) dfidq_curr_mat_out_AY_J2();
    method Bit#(32) dfidq_curr_mat_out_AY_J3();
    method Bit#(32) dfidq_curr_mat_out_AY_J4();
    method Bit#(32) dfidq_curr_mat_out_AY_J5();
    method Bit#(32) dfidq_curr_mat_out_AY_J6();
    method Bit#(32) dfidq_curr_mat_out_AY_J7();

    method Bit#(32) dfidq_curr_mat_out_AZ_J1();
    method Bit#(32) dfidq_curr_mat_out_AZ_J2();
    method Bit#(32) dfidq_curr_mat_out_AZ_J3();
    method Bit#(32) dfidq_curr_mat_out_AZ_J4();
    method Bit#(32) dfidq_curr_mat_out_AZ_J5();
    method Bit#(32) dfidq_curr_mat_out_AZ_J6();
    method Bit#(32) dfidq_curr_mat_out_AZ_J7();

    method Bit#(32) dfidq_curr_mat_out_LX_J1();
    method Bit#(32) dfidq_curr_mat_out_LX_J2();
    method Bit#(32) dfidq_curr_mat_out_LX_J3();
    method Bit#(32) dfidq_curr_mat_out_LX_J4();
    method Bit#(32) dfidq_curr_mat_out_LX_J5();
    method Bit#(32) dfidq_curr_mat_out_LX_J6();
    method Bit#(32) dfidq_curr_mat_out_LX_J7();

    method Bit#(32) dfidq_curr_mat_out_LY_J1();
    method Bit#(32) dfidq_curr_mat_out_LY_J2();
    method Bit#(32) dfidq_curr_mat_out_LY_J3();
    method Bit#(32) dfidq_curr_mat_out_LY_J4();
    method Bit#(32) dfidq_curr_mat_out_LY_J5();
    method Bit#(32) dfidq_curr_mat_out_LY_J6();
    method Bit#(32) dfidq_curr_mat_out_LY_J7();

    method Bit#(32) dfidq_curr_mat_out_LZ_J1();
    method Bit#(32) dfidq_curr_mat_out_LZ_J2();
    method Bit#(32) dfidq_curr_mat_out_LZ_J3();
    method Bit#(32) dfidq_curr_mat_out_LZ_J4();
    method Bit#(32) dfidq_curr_mat_out_LZ_J5();
    method Bit#(32) dfidq_curr_mat_out_LZ_J6();
    method Bit#(32) dfidq_curr_mat_out_LZ_J7();

// dfidqd_curr_mat_out

    method Bit#(32) dfidqd_curr_mat_out_AX_J1();
    method Bit#(32) dfidqd_curr_mat_out_AX_J2();
    method Bit#(32) dfidqd_curr_mat_out_AX_J3();
    method Bit#(32) dfidqd_curr_mat_out_AX_J4();
    method Bit#(32) dfidqd_curr_mat_out_AX_J5();
    method Bit#(32) dfidqd_curr_mat_out_AX_J6();
    method Bit#(32) dfidqd_curr_mat_out_AX_J7();

    method Bit#(32) dfidqd_curr_mat_out_AY_J1();
    method Bit#(32) dfidqd_curr_mat_out_AY_J2();
    method Bit#(32) dfidqd_curr_mat_out_AY_J3();
    method Bit#(32) dfidqd_curr_mat_out_AY_J4();
    method Bit#(32) dfidqd_curr_mat_out_AY_J5();
    method Bit#(32) dfidqd_curr_mat_out_AY_J6();
    method Bit#(32) dfidqd_curr_mat_out_AY_J7();

    method Bit#(32) dfidqd_curr_mat_out_AZ_J1();
    method Bit#(32) dfidqd_curr_mat_out_AZ_J2();
    method Bit#(32) dfidqd_curr_mat_out_AZ_J3();
    method Bit#(32) dfidqd_curr_mat_out_AZ_J4();
    method Bit#(32) dfidqd_curr_mat_out_AZ_J5();
    method Bit#(32) dfidqd_curr_mat_out_AZ_J6();
    method Bit#(32) dfidqd_curr_mat_out_AZ_J7();

    method Bit#(32) dfidqd_curr_mat_out_LX_J1();
    method Bit#(32) dfidqd_curr_mat_out_LX_J2();
    method Bit#(32) dfidqd_curr_mat_out_LX_J3();
    method Bit#(32) dfidqd_curr_mat_out_LX_J4();
    method Bit#(32) dfidqd_curr_mat_out_LX_J5();
    method Bit#(32) dfidqd_curr_mat_out_LX_J6();
    method Bit#(32) dfidqd_curr_mat_out_LX_J7();

    method Bit#(32) dfidqd_curr_mat_out_LY_J1();
    method Bit#(32) dfidqd_curr_mat_out_LY_J2();
    method Bit#(32) dfidqd_curr_mat_out_LY_J3();
    method Bit#(32) dfidqd_curr_mat_out_LY_J4();
    method Bit#(32) dfidqd_curr_mat_out_LY_J5();
    method Bit#(32) dfidqd_curr_mat_out_LY_J6();
    method Bit#(32) dfidqd_curr_mat_out_LY_J7();

    method Bit#(32) dfidqd_curr_mat_out_LZ_J1();
    method Bit#(32) dfidqd_curr_mat_out_LZ_J2();
    method Bit#(32) dfidqd_curr_mat_out_LZ_J3();
    method Bit#(32) dfidqd_curr_mat_out_LZ_J4();
    method Bit#(32) dfidqd_curr_mat_out_LZ_J5();
    method Bit#(32) dfidqd_curr_mat_out_LZ_J6();
    method Bit#(32) dfidqd_curr_mat_out_LZ_J7();
endinterface

import "BVI" fproc =
module mkFProc(FProc);
    default_clock clk();
    default_reset rst();
    input_clock (clk) <- exposeCurrentClock; 
    input_reset (reset) <- invertCurrentReset;
    method get_data() enable(get_data);

    method sinq_curr_in(sinq_curr_in) enable((*inhigh*) EN_sinq_curr_in) ;
    method cosq_curr_in(cosq_curr_in) enable((*inhigh*) EN_cosq_curr_in) ;
    method qd_curr_in(qd_curr_in) enable((*inhigh*) EN_qd_curr_in) ;
    method v_curr_vec_in_AX(v_curr_vec_in_AX) enable((*inhigh*) EN_v_curr_vec_in_AX) ;
    method v_curr_vec_in_AY(v_curr_vec_in_AY) enable((*inhigh*) EN_v_curr_vec_in_AY) ;
    method v_curr_vec_in_AZ(v_curr_vec_in_AZ) enable((*inhigh*) EN_v_curr_vec_in_AZ) ;
    method v_curr_vec_in_LX(v_curr_vec_in_LX) enable((*inhigh*) EN_v_curr_vec_in_LX) ;
    method v_curr_vec_in_LY(v_curr_vec_in_LY) enable((*inhigh*) EN_v_curr_vec_in_LY) ;
    method v_curr_vec_in_LZ(v_curr_vec_in_LZ) enable((*inhigh*) EN_v_curr_vec_in_LZ) ;
    method a_curr_vec_in_AX(a_curr_vec_in_AX) enable((*inhigh*) EN_a_curr_vec_in_AX) ;
    method a_curr_vec_in_AY(a_curr_vec_in_AY) enable((*inhigh*) EN_a_curr_vec_in_AY) ;
    method a_curr_vec_in_AZ(a_curr_vec_in_AZ) enable((*inhigh*) EN_a_curr_vec_in_AZ) ;
    method a_curr_vec_in_LX(a_curr_vec_in_LX) enable((*inhigh*) EN_a_curr_vec_in_LX) ;
    method a_curr_vec_in_LY(a_curr_vec_in_LY) enable((*inhigh*) EN_a_curr_vec_in_LY) ;
    method a_curr_vec_in_LZ(a_curr_vec_in_LZ) enable((*inhigh*) EN_a_curr_vec_in_LZ) ;
    method output_ready output_ready();
    method dfidq_curr_mat_out_AX_J1 dfidq_curr_mat_out_AX_J1();
    method dfidq_curr_mat_out_AX_J2 dfidq_curr_mat_out_AX_J2();
    method dfidq_curr_mat_out_AX_J3 dfidq_curr_mat_out_AX_J3();
    method dfidq_curr_mat_out_AX_J4 dfidq_curr_mat_out_AX_J4();
    method dfidq_curr_mat_out_AX_J5 dfidq_curr_mat_out_AX_J5();
    method dfidq_curr_mat_out_AX_J6 dfidq_curr_mat_out_AX_J6();
    method dfidq_curr_mat_out_AX_J7 dfidq_curr_mat_out_AX_J7();
    method dfidq_curr_mat_out_AY_J1 dfidq_curr_mat_out_AY_J1();
    method dfidq_curr_mat_out_AY_J2 dfidq_curr_mat_out_AY_J2();
    method dfidq_curr_mat_out_AY_J3 dfidq_curr_mat_out_AY_J3();
    method dfidq_curr_mat_out_AY_J4 dfidq_curr_mat_out_AY_J4();
    method dfidq_curr_mat_out_AY_J5 dfidq_curr_mat_out_AY_J5();
    method dfidq_curr_mat_out_AY_J6 dfidq_curr_mat_out_AY_J6();
    method dfidq_curr_mat_out_AY_J7 dfidq_curr_mat_out_AY_J7();
    method dfidq_curr_mat_out_AZ_J1 dfidq_curr_mat_out_AZ_J1();
    method dfidq_curr_mat_out_AZ_J2 dfidq_curr_mat_out_AZ_J2();
    method dfidq_curr_mat_out_AZ_J3 dfidq_curr_mat_out_AZ_J3();
    method dfidq_curr_mat_out_AZ_J4 dfidq_curr_mat_out_AZ_J4();
    method dfidq_curr_mat_out_AZ_J5 dfidq_curr_mat_out_AZ_J5();
    method dfidq_curr_mat_out_AZ_J6 dfidq_curr_mat_out_AZ_J6();
    method dfidq_curr_mat_out_AZ_J7 dfidq_curr_mat_out_AZ_J7();
    method dfidq_curr_mat_out_LX_J1 dfidq_curr_mat_out_LX_J1();
    method dfidq_curr_mat_out_LX_J2 dfidq_curr_mat_out_LX_J2();
    method dfidq_curr_mat_out_LX_J3 dfidq_curr_mat_out_LX_J3();
    method dfidq_curr_mat_out_LX_J4 dfidq_curr_mat_out_LX_J4();
    method dfidq_curr_mat_out_LX_J5 dfidq_curr_mat_out_LX_J5();
    method dfidq_curr_mat_out_LX_J6 dfidq_curr_mat_out_LX_J6();
    method dfidq_curr_mat_out_LX_J7 dfidq_curr_mat_out_LX_J7();
    method dfidq_curr_mat_out_LY_J1 dfidq_curr_mat_out_LY_J1();
    method dfidq_curr_mat_out_LY_J2 dfidq_curr_mat_out_LY_J2();
    method dfidq_curr_mat_out_LY_J3 dfidq_curr_mat_out_LY_J3();
    method dfidq_curr_mat_out_LY_J4 dfidq_curr_mat_out_LY_J4();
    method dfidq_curr_mat_out_LY_J5 dfidq_curr_mat_out_LY_J5();
    method dfidq_curr_mat_out_LY_J6 dfidq_curr_mat_out_LY_J6();
    method dfidq_curr_mat_out_LY_J7 dfidq_curr_mat_out_LY_J7();
    method dfidq_curr_mat_out_LZ_J1 dfidq_curr_mat_out_LZ_J1();
    method dfidq_curr_mat_out_LZ_J2 dfidq_curr_mat_out_LZ_J2();
    method dfidq_curr_mat_out_LZ_J3 dfidq_curr_mat_out_LZ_J3();
    method dfidq_curr_mat_out_LZ_J4 dfidq_curr_mat_out_LZ_J4();
    method dfidq_curr_mat_out_LZ_J5 dfidq_curr_mat_out_LZ_J5();
    method dfidq_curr_mat_out_LZ_J6 dfidq_curr_mat_out_LZ_J6();
    method dfidq_curr_mat_out_LZ_J7 dfidq_curr_mat_out_LZ_J7();
    method dfidqd_curr_mat_out_AX_J1 dfidqd_curr_mat_out_AX_J1();
    method dfidqd_curr_mat_out_AX_J2 dfidqd_curr_mat_out_AX_J2();
    method dfidqd_curr_mat_out_AX_J3 dfidqd_curr_mat_out_AX_J3();
    method dfidqd_curr_mat_out_AX_J4 dfidqd_curr_mat_out_AX_J4();
    method dfidqd_curr_mat_out_AX_J5 dfidqd_curr_mat_out_AX_J5();
    method dfidqd_curr_mat_out_AX_J6 dfidqd_curr_mat_out_AX_J6();
    method dfidqd_curr_mat_out_AX_J7 dfidqd_curr_mat_out_AX_J7();
    method dfidqd_curr_mat_out_AY_J1 dfidqd_curr_mat_out_AY_J1();
    method dfidqd_curr_mat_out_AY_J2 dfidqd_curr_mat_out_AY_J2();
    method dfidqd_curr_mat_out_AY_J3 dfidqd_curr_mat_out_AY_J3();
    method dfidqd_curr_mat_out_AY_J4 dfidqd_curr_mat_out_AY_J4();
    method dfidqd_curr_mat_out_AY_J5 dfidqd_curr_mat_out_AY_J5();
    method dfidqd_curr_mat_out_AY_J6 dfidqd_curr_mat_out_AY_J6();
    method dfidqd_curr_mat_out_AY_J7 dfidqd_curr_mat_out_AY_J7();
    method dfidqd_curr_mat_out_AZ_J1 dfidqd_curr_mat_out_AZ_J1();
    method dfidqd_curr_mat_out_AZ_J2 dfidqd_curr_mat_out_AZ_J2();
    method dfidqd_curr_mat_out_AZ_J3 dfidqd_curr_mat_out_AZ_J3();
    method dfidqd_curr_mat_out_AZ_J4 dfidqd_curr_mat_out_AZ_J4();
    method dfidqd_curr_mat_out_AZ_J5 dfidqd_curr_mat_out_AZ_J5();
    method dfidqd_curr_mat_out_AZ_J6 dfidqd_curr_mat_out_AZ_J6();
    method dfidqd_curr_mat_out_AZ_J7 dfidqd_curr_mat_out_AZ_J7();
    method dfidqd_curr_mat_out_LX_J1 dfidqd_curr_mat_out_LX_J1();
    method dfidqd_curr_mat_out_LX_J2 dfidqd_curr_mat_out_LX_J2();
    method dfidqd_curr_mat_out_LX_J3 dfidqd_curr_mat_out_LX_J3();
    method dfidqd_curr_mat_out_LX_J4 dfidqd_curr_mat_out_LX_J4();
    method dfidqd_curr_mat_out_LX_J5 dfidqd_curr_mat_out_LX_J5();
    method dfidqd_curr_mat_out_LX_J6 dfidqd_curr_mat_out_LX_J6();
    method dfidqd_curr_mat_out_LX_J7 dfidqd_curr_mat_out_LX_J7();
    method dfidqd_curr_mat_out_LY_J1 dfidqd_curr_mat_out_LY_J1();
    method dfidqd_curr_mat_out_LY_J2 dfidqd_curr_mat_out_LY_J2();
    method dfidqd_curr_mat_out_LY_J3 dfidqd_curr_mat_out_LY_J3();
    method dfidqd_curr_mat_out_LY_J4 dfidqd_curr_mat_out_LY_J4();
    method dfidqd_curr_mat_out_LY_J5 dfidqd_curr_mat_out_LY_J5();
    method dfidqd_curr_mat_out_LY_J6 dfidqd_curr_mat_out_LY_J6();
    method dfidqd_curr_mat_out_LY_J7 dfidqd_curr_mat_out_LY_J7();
    method dfidqd_curr_mat_out_LZ_J1  dfidqd_curr_mat_out_LZ_J1();
    method dfidqd_curr_mat_out_LZ_J2  dfidqd_curr_mat_out_LZ_J2();
    method dfidqd_curr_mat_out_LZ_J3  dfidqd_curr_mat_out_LZ_J3();
    method dfidqd_curr_mat_out_LZ_J4  dfidqd_curr_mat_out_LZ_J4();
    method dfidqd_curr_mat_out_LZ_J5  dfidqd_curr_mat_out_LZ_J5();
    method dfidqd_curr_mat_out_LZ_J6  dfidqd_curr_mat_out_LZ_J6();
    method dfidqd_curr_mat_out_LZ_J7  dfidqd_curr_mat_out_LZ_J7();

	schedule (get_data, sinq_curr_in, cosq_curr_in, qd_curr_in, v_curr_vec_in_AX, v_curr_vec_in_AY, v_curr_vec_in_AZ, v_curr_vec_in_LX, v_curr_vec_in_LY, v_curr_vec_in_LZ, a_curr_vec_in_AX, a_curr_vec_in_AY, a_curr_vec_in_AZ, a_curr_vec_in_LX, a_curr_vec_in_LY, a_curr_vec_in_LZ, output_ready, dfidq_curr_mat_out_AX_J1, dfidq_curr_mat_out_AX_J2, dfidq_curr_mat_out_AX_J3, dfidq_curr_mat_out_AX_J4, dfidq_curr_mat_out_AX_J5, dfidq_curr_mat_out_AX_J6, dfidq_curr_mat_out_AX_J7, dfidq_curr_mat_out_AY_J1, dfidq_curr_mat_out_AY_J2, dfidq_curr_mat_out_AY_J3, dfidq_curr_mat_out_AY_J4, dfidq_curr_mat_out_AY_J5, dfidq_curr_mat_out_AY_J6, dfidq_curr_mat_out_AY_J7, dfidq_curr_mat_out_AZ_J1, dfidq_curr_mat_out_AZ_J2, dfidq_curr_mat_out_AZ_J3, dfidq_curr_mat_out_AZ_J4, dfidq_curr_mat_out_AZ_J5, dfidq_curr_mat_out_AZ_J6, dfidq_curr_mat_out_AZ_J7, dfidq_curr_mat_out_LX_J1, dfidq_curr_mat_out_LX_J2, dfidq_curr_mat_out_LX_J3, dfidq_curr_mat_out_LX_J4, dfidq_curr_mat_out_LX_J5, dfidq_curr_mat_out_LX_J6, dfidq_curr_mat_out_LX_J7, dfidq_curr_mat_out_LY_J1, dfidq_curr_mat_out_LY_J2, dfidq_curr_mat_out_LY_J3, dfidq_curr_mat_out_LY_J4, dfidq_curr_mat_out_LY_J5, dfidq_curr_mat_out_LY_J6, dfidq_curr_mat_out_LY_J7, dfidq_curr_mat_out_LZ_J1, dfidq_curr_mat_out_LZ_J2, dfidq_curr_mat_out_LZ_J3, dfidq_curr_mat_out_LZ_J4, dfidq_curr_mat_out_LZ_J5, dfidq_curr_mat_out_LZ_J6, dfidq_curr_mat_out_LZ_J7, dfidqd_curr_mat_out_AX_J1, dfidqd_curr_mat_out_AX_J2, dfidqd_curr_mat_out_AX_J3, dfidqd_curr_mat_out_AX_J4, dfidqd_curr_mat_out_AX_J5, dfidqd_curr_mat_out_AX_J6, dfidqd_curr_mat_out_AX_J7, dfidqd_curr_mat_out_AY_J1, dfidqd_curr_mat_out_AY_J2, dfidqd_curr_mat_out_AY_J3, dfidqd_curr_mat_out_AY_J4, dfidqd_curr_mat_out_AY_J5, dfidqd_curr_mat_out_AY_J6, dfidqd_curr_mat_out_AY_J7, dfidqd_curr_mat_out_AZ_J1, dfidqd_curr_mat_out_AZ_J2, dfidqd_curr_mat_out_AZ_J3, dfidqd_curr_mat_out_AZ_J4, dfidqd_curr_mat_out_AZ_J5, dfidqd_curr_mat_out_AZ_J6, dfidqd_curr_mat_out_AZ_J7, dfidqd_curr_mat_out_LX_J1, dfidqd_curr_mat_out_LX_J2, dfidqd_curr_mat_out_LX_J3, dfidqd_curr_mat_out_LX_J4, dfidqd_curr_mat_out_LX_J5, dfidqd_curr_mat_out_LX_J6, dfidqd_curr_mat_out_LX_J7, dfidqd_curr_mat_out_LY_J1, dfidqd_curr_mat_out_LY_J2, dfidqd_curr_mat_out_LY_J3, dfidqd_curr_mat_out_LY_J4, dfidqd_curr_mat_out_LY_J5, dfidqd_curr_mat_out_LY_J6, dfidqd_curr_mat_out_LY_J7, dfidqd_curr_mat_out_LZ_J1, dfidqd_curr_mat_out_LZ_J2, dfidqd_curr_mat_out_LZ_J3, dfidqd_curr_mat_out_LZ_J4, dfidqd_curr_mat_out_LZ_J5, dfidqd_curr_mat_out_LZ_J6, dfidqd_curr_mat_out_LZ_J7) CF (get_data, sinq_curr_in, cosq_curr_in, qd_curr_in, v_curr_vec_in_AX, v_curr_vec_in_AY, v_curr_vec_in_AZ, v_curr_vec_in_LX, v_curr_vec_in_LY, v_curr_vec_in_LZ, a_curr_vec_in_AX, a_curr_vec_in_AY, a_curr_vec_in_AZ, a_curr_vec_in_LX, a_curr_vec_in_LY, a_curr_vec_in_LZ, output_ready, dfidq_curr_mat_out_AX_J1, dfidq_curr_mat_out_AX_J2, dfidq_curr_mat_out_AX_J3, dfidq_curr_mat_out_AX_J4, dfidq_curr_mat_out_AX_J5, dfidq_curr_mat_out_AX_J6, dfidq_curr_mat_out_AX_J7, dfidq_curr_mat_out_AY_J1, dfidq_curr_mat_out_AY_J2, dfidq_curr_mat_out_AY_J3, dfidq_curr_mat_out_AY_J4, dfidq_curr_mat_out_AY_J5, dfidq_curr_mat_out_AY_J6, dfidq_curr_mat_out_AY_J7, dfidq_curr_mat_out_AZ_J1, dfidq_curr_mat_out_AZ_J2, dfidq_curr_mat_out_AZ_J3, dfidq_curr_mat_out_AZ_J4, dfidq_curr_mat_out_AZ_J5, dfidq_curr_mat_out_AZ_J6, dfidq_curr_mat_out_AZ_J7, dfidq_curr_mat_out_LX_J1, dfidq_curr_mat_out_LX_J2, dfidq_curr_mat_out_LX_J3, dfidq_curr_mat_out_LX_J4, dfidq_curr_mat_out_LX_J5, dfidq_curr_mat_out_LX_J6, dfidq_curr_mat_out_LX_J7, dfidq_curr_mat_out_LY_J1, dfidq_curr_mat_out_LY_J2, dfidq_curr_mat_out_LY_J3, dfidq_curr_mat_out_LY_J4, dfidq_curr_mat_out_LY_J5, dfidq_curr_mat_out_LY_J6, dfidq_curr_mat_out_LY_J7, dfidq_curr_mat_out_LZ_J1, dfidq_curr_mat_out_LZ_J2, dfidq_curr_mat_out_LZ_J3, dfidq_curr_mat_out_LZ_J4, dfidq_curr_mat_out_LZ_J5, dfidq_curr_mat_out_LZ_J6, dfidq_curr_mat_out_LZ_J7, dfidqd_curr_mat_out_AX_J1, dfidqd_curr_mat_out_AX_J2, dfidqd_curr_mat_out_AX_J3, dfidqd_curr_mat_out_AX_J4, dfidqd_curr_mat_out_AX_J5, dfidqd_curr_mat_out_AX_J6, dfidqd_curr_mat_out_AX_J7, dfidqd_curr_mat_out_AY_J1, dfidqd_curr_mat_out_AY_J2, dfidqd_curr_mat_out_AY_J3, dfidqd_curr_mat_out_AY_J4, dfidqd_curr_mat_out_AY_J5, dfidqd_curr_mat_out_AY_J6, dfidqd_curr_mat_out_AY_J7, dfidqd_curr_mat_out_AZ_J1, dfidqd_curr_mat_out_AZ_J2, dfidqd_curr_mat_out_AZ_J3, dfidqd_curr_mat_out_AZ_J4, dfidqd_curr_mat_out_AZ_J5, dfidqd_curr_mat_out_AZ_J6, dfidqd_curr_mat_out_AZ_J7, dfidqd_curr_mat_out_LX_J1, dfidqd_curr_mat_out_LX_J2, dfidqd_curr_mat_out_LX_J3, dfidqd_curr_mat_out_LX_J4, dfidqd_curr_mat_out_LX_J5, dfidqd_curr_mat_out_LX_J6, dfidqd_curr_mat_out_LX_J7, dfidqd_curr_mat_out_LY_J1, dfidqd_curr_mat_out_LY_J2, dfidqd_curr_mat_out_LY_J3, dfidqd_curr_mat_out_LY_J4, dfidqd_curr_mat_out_LY_J5, dfidqd_curr_mat_out_LY_J6, dfidqd_curr_mat_out_LY_J7, dfidqd_curr_mat_out_LZ_J1, dfidqd_curr_mat_out_LZ_J2, dfidqd_curr_mat_out_LZ_J3, dfidqd_curr_mat_out_LZ_J4, dfidqd_curr_mat_out_LZ_J5, dfidqd_curr_mat_out_LZ_J6, dfidqd_curr_mat_out_LZ_J7);

endmodule
