Bit#(32) new_minv_dtau_R1_dqdPE1 = 0;
Bit#(32) new_minv_dtau_R2_dqdPE1 = 0;
Bit#(32) new_minv_dtau_R3_dqdPE1 = 0;
Bit#(32) new_minv_dtau_R4_dqdPE1 = 0;
Bit#(32) new_minv_dtau_R5_dqdPE1 = 0;
Bit#(32) new_minv_dtau_R6_dqdPE1 = 0;
Bit#(32) new_minv_dtau_R7_dqdPE1 = 0;

Bit#(32) new_minv_dtau_R1_dqdPE2 = 0;
Bit#(32) new_minv_dtau_R2_dqdPE2 = 0;
Bit#(32) new_minv_dtau_R3_dqdPE2 = 0;
Bit#(32) new_minv_dtau_R4_dqdPE2 = 0;
Bit#(32) new_minv_dtau_R5_dqdPE2 = 0;
Bit#(32) new_minv_dtau_R6_dqdPE2 = 0;
Bit#(32) new_minv_dtau_R7_dqdPE2 = 0;

Bit#(32) new_minv_dtau_R1_dqdPE3 = 0;
Bit#(32) new_minv_dtau_R2_dqdPE3 = 0;
Bit#(32) new_minv_dtau_R3_dqdPE3 = 0;
Bit#(32) new_minv_dtau_R4_dqdPE3 = 0;
Bit#(32) new_minv_dtau_R5_dqdPE3 = 0;
Bit#(32) new_minv_dtau_R6_dqdPE3 = 0;
Bit#(32) new_minv_dtau_R7_dqdPE3 = 0;

Bit#(32) new_minv_dtau_R1_dqdPE4 = 0;
Bit#(32) new_minv_dtau_R2_dqdPE4 = 0;
Bit#(32) new_minv_dtau_R3_dqdPE4 = 0;
Bit#(32) new_minv_dtau_R4_dqdPE4 = 0;
Bit#(32) new_minv_dtau_R5_dqdPE4 = 0;
Bit#(32) new_minv_dtau_R6_dqdPE4 = 0;
Bit#(32) new_minv_dtau_R7_dqdPE4 = 0;

Bit#(32) new_minv_dtau_R1_dqdPE5 = 0;
Bit#(32) new_minv_dtau_R2_dqdPE5 = 0;
Bit#(32) new_minv_dtau_R3_dqdPE5 = 0;
Bit#(32) new_minv_dtau_R4_dqdPE5 = 0;
Bit#(32) new_minv_dtau_R5_dqdPE5 = 0;
Bit#(32) new_minv_dtau_R6_dqdPE5 = 0;
Bit#(32) new_minv_dtau_R7_dqdPE5 = 0;

Bit#(32) new_minv_dtau_R1_dqdPE6 = 0;
Bit#(32) new_minv_dtau_R2_dqdPE6 = 0;
Bit#(32) new_minv_dtau_R3_dqdPE6 = 0;
Bit#(32) new_minv_dtau_R4_dqdPE6 = 0;
Bit#(32) new_minv_dtau_R5_dqdPE6 = 0;
Bit#(32) new_minv_dtau_R6_dqdPE6 = 0;
Bit#(32) new_minv_dtau_R7_dqdPE6 = 0;

Bit#(32) new_minv_dtau_R1_dqdPE7 = 0;
Bit#(32) new_minv_dtau_R2_dqdPE7 = 0;
Bit#(32) new_minv_dtau_R3_dqdPE7 = 0;
Bit#(32) new_minv_dtau_R4_dqdPE7 = 0;
Bit#(32) new_minv_dtau_R5_dqdPE7 = 0;
Bit#(32) new_minv_dtau_R6_dqdPE7 = 0;
Bit#(32) new_minv_dtau_R7_dqdPE7 = 0;


case (idx_block_minv_stream_dtau)
    // new_minv_dtau[r][c] = new_minv_dtau[r][c] + update;

    0: begin
        new_minv_dtau_R1_dqdPE1 = new_minv_dtau[0][0];
        new_minv_dtau_R2_dqdPE1 = new_minv_dtau[1][0];
        new_minv_dtau_R3_dqdPE1 = new_minv_dtau[2][0];
        new_minv_dtau_R4_dqdPE1 = new_minv_dtau[3][0];
        new_minv_dtau_R5_dqdPE1 = new_minv_dtau[4][0];
        new_minv_dtau_R6_dqdPE1 = new_minv_dtau[5][0];
        new_minv_dtau_R7_dqdPE1 = new_minv_dtau[6][0];

        new_minv_dtau_R1_dqdPE2 = new_minv_dtau[0][1];
        new_minv_dtau_R2_dqdPE2 = new_minv_dtau[1][1];
        new_minv_dtau_R3_dqdPE2 = new_minv_dtau[2][1];
        new_minv_dtau_R4_dqdPE2 = new_minv_dtau[3][1];
        new_minv_dtau_R5_dqdPE2 = new_minv_dtau[4][1];
        new_minv_dtau_R6_dqdPE2 = new_minv_dtau[5][1];
        new_minv_dtau_R7_dqdPE2 = new_minv_dtau[6][1];

        new_minv_dtau_R1_dqdPE3 = new_minv_dtau[0][2];
        new_minv_dtau_R2_dqdPE3 = new_minv_dtau[1][2];
        new_minv_dtau_R3_dqdPE3 = new_minv_dtau[2][2];
        new_minv_dtau_R4_dqdPE3 = new_minv_dtau[3][2];
        new_minv_dtau_R5_dqdPE3 = new_minv_dtau[4][2];
        new_minv_dtau_R6_dqdPE3 = new_minv_dtau[5][2];
        new_minv_dtau_R7_dqdPE3 = new_minv_dtau[6][2];

        new_minv_dtau_R1_dqdPE4 = new_minv_dtau[0][3];
        new_minv_dtau_R2_dqdPE4 = new_minv_dtau[1][3];
        new_minv_dtau_R3_dqdPE4 = new_minv_dtau[2][3];
        new_minv_dtau_R4_dqdPE4 = new_minv_dtau[3][3];
        new_minv_dtau_R5_dqdPE4 = new_minv_dtau[4][3];
        new_minv_dtau_R6_dqdPE4 = new_minv_dtau[5][3];
        new_minv_dtau_R7_dqdPE4 = new_minv_dtau[6][3];

        new_minv_dtau_R1_dqdPE5 = new_minv_dtau[0][4];
        new_minv_dtau_R2_dqdPE5 = new_minv_dtau[1][4];
        new_minv_dtau_R3_dqdPE5 = new_minv_dtau[2][4];
        new_minv_dtau_R4_dqdPE5 = new_minv_dtau[3][4];
        new_minv_dtau_R5_dqdPE5 = new_minv_dtau[4][4];
        new_minv_dtau_R6_dqdPE5 = new_minv_dtau[5][4];
        new_minv_dtau_R7_dqdPE5 = new_minv_dtau[6][4];

        new_minv_dtau_R1_dqdPE6 = new_minv_dtau[0][5];
        new_minv_dtau_R2_dqdPE6 = new_minv_dtau[1][5];
        new_minv_dtau_R3_dqdPE6 = new_minv_dtau[2][5];
        new_minv_dtau_R4_dqdPE6 = new_minv_dtau[3][5];
        new_minv_dtau_R5_dqdPE6 = new_minv_dtau[4][5];
        new_minv_dtau_R6_dqdPE6 = new_minv_dtau[5][5];
        new_minv_dtau_R7_dqdPE6 = new_minv_dtau[6][5];

        new_minv_dtau_R1_dqdPE7 = new_minv_dtau[0][6];
        new_minv_dtau_R2_dqdPE7 = new_minv_dtau[1][6];
        new_minv_dtau_R3_dqdPE7 = new_minv_dtau[2][6];
        new_minv_dtau_R4_dqdPE7 = new_minv_dtau[3][6];
        new_minv_dtau_R5_dqdPE7 = new_minv_dtau[4][6];
        new_minv_dtau_R6_dqdPE7 = new_minv_dtau[5][6];
        new_minv_dtau_R7_dqdPE7 = new_minv_dtau[6][6];

    end

endcase

new_minv_dtau_R1_dqdPE1 = new_minv_dtau_R1_dqdPE1 + minv_vec_out_R1_dqdPE1;
new_minv_dtau_R2_dqdPE1 = new_minv_dtau_R2_dqdPE1 + minv_vec_out_R2_dqdPE1;
new_minv_dtau_R3_dqdPE1 = new_minv_dtau_R3_dqdPE1 + minv_vec_out_R3_dqdPE1;
new_minv_dtau_R4_dqdPE1 = new_minv_dtau_R4_dqdPE1 + minv_vec_out_R4_dqdPE1;
new_minv_dtau_R5_dqdPE1 = new_minv_dtau_R5_dqdPE1 + minv_vec_out_R5_dqdPE1;
new_minv_dtau_R6_dqdPE1 = new_minv_dtau_R6_dqdPE1 + minv_vec_out_R6_dqdPE1;
new_minv_dtau_R7_dqdPE1 = new_minv_dtau_R7_dqdPE1 + minv_vec_out_R7_dqdPE1;
new_minv_dtau_R1_dqdPE2 = new_minv_dtau_R1_dqdPE2 + minv_vec_out_R1_dqdPE2;
new_minv_dtau_R2_dqdPE2 = new_minv_dtau_R2_dqdPE2 + minv_vec_out_R2_dqdPE2;
new_minv_dtau_R3_dqdPE2 = new_minv_dtau_R3_dqdPE2 + minv_vec_out_R3_dqdPE2;
new_minv_dtau_R4_dqdPE2 = new_minv_dtau_R4_dqdPE2 + minv_vec_out_R4_dqdPE2;
new_minv_dtau_R5_dqdPE2 = new_minv_dtau_R5_dqdPE2 + minv_vec_out_R5_dqdPE2;
new_minv_dtau_R6_dqdPE2 = new_minv_dtau_R6_dqdPE2 + minv_vec_out_R6_dqdPE2;
new_minv_dtau_R7_dqdPE2 = new_minv_dtau_R7_dqdPE2 + minv_vec_out_R7_dqdPE2;
new_minv_dtau_R1_dqdPE3 = new_minv_dtau_R1_dqdPE3 + minv_vec_out_R1_dqdPE3;
new_minv_dtau_R2_dqdPE3 = new_minv_dtau_R2_dqdPE3 + minv_vec_out_R2_dqdPE3;
new_minv_dtau_R3_dqdPE3 = new_minv_dtau_R3_dqdPE3 + minv_vec_out_R3_dqdPE3;
new_minv_dtau_R4_dqdPE3 = new_minv_dtau_R4_dqdPE3 + minv_vec_out_R4_dqdPE3;
new_minv_dtau_R5_dqdPE3 = new_minv_dtau_R5_dqdPE3 + minv_vec_out_R5_dqdPE3;
new_minv_dtau_R6_dqdPE3 = new_minv_dtau_R6_dqdPE3 + minv_vec_out_R6_dqdPE3;
new_minv_dtau_R7_dqdPE3 = new_minv_dtau_R7_dqdPE3 + minv_vec_out_R7_dqdPE3;
new_minv_dtau_R1_dqdPE4 = new_minv_dtau_R1_dqdPE4 + minv_vec_out_R1_dqdPE4;
new_minv_dtau_R2_dqdPE4 = new_minv_dtau_R2_dqdPE4 + minv_vec_out_R2_dqdPE4;
new_minv_dtau_R3_dqdPE4 = new_minv_dtau_R3_dqdPE4 + minv_vec_out_R3_dqdPE4;
new_minv_dtau_R4_dqdPE4 = new_minv_dtau_R4_dqdPE4 + minv_vec_out_R4_dqdPE4;
new_minv_dtau_R5_dqdPE4 = new_minv_dtau_R5_dqdPE4 + minv_vec_out_R5_dqdPE4;
new_minv_dtau_R6_dqdPE4 = new_minv_dtau_R6_dqdPE4 + minv_vec_out_R6_dqdPE4;
new_minv_dtau_R7_dqdPE4 = new_minv_dtau_R7_dqdPE4 + minv_vec_out_R7_dqdPE4;
new_minv_dtau_R1_dqdPE5 = new_minv_dtau_R1_dqdPE5 + minv_vec_out_R1_dqdPE5;
new_minv_dtau_R2_dqdPE5 = new_minv_dtau_R2_dqdPE5 + minv_vec_out_R2_dqdPE5;
new_minv_dtau_R3_dqdPE5 = new_minv_dtau_R3_dqdPE5 + minv_vec_out_R3_dqdPE5;
new_minv_dtau_R4_dqdPE5 = new_minv_dtau_R4_dqdPE5 + minv_vec_out_R4_dqdPE5;
new_minv_dtau_R5_dqdPE5 = new_minv_dtau_R5_dqdPE5 + minv_vec_out_R5_dqdPE5;
new_minv_dtau_R6_dqdPE5 = new_minv_dtau_R6_dqdPE5 + minv_vec_out_R6_dqdPE5;
new_minv_dtau_R7_dqdPE5 = new_minv_dtau_R7_dqdPE5 + minv_vec_out_R7_dqdPE5;
new_minv_dtau_R1_dqdPE6 = new_minv_dtau_R1_dqdPE6 + minv_vec_out_R1_dqdPE6;
new_minv_dtau_R2_dqdPE6 = new_minv_dtau_R2_dqdPE6 + minv_vec_out_R2_dqdPE6;
new_minv_dtau_R3_dqdPE6 = new_minv_dtau_R3_dqdPE6 + minv_vec_out_R3_dqdPE6;
new_minv_dtau_R4_dqdPE6 = new_minv_dtau_R4_dqdPE6 + minv_vec_out_R4_dqdPE6;
new_minv_dtau_R5_dqdPE6 = new_minv_dtau_R5_dqdPE6 + minv_vec_out_R5_dqdPE6;
new_minv_dtau_R6_dqdPE6 = new_minv_dtau_R6_dqdPE6 + minv_vec_out_R6_dqdPE6;
new_minv_dtau_R7_dqdPE6 = new_minv_dtau_R7_dqdPE6 + minv_vec_out_R7_dqdPE6;
new_minv_dtau_R1_dqdPE7 = new_minv_dtau_R1_dqdPE7 + minv_vec_out_R1_dqdPE7;
new_minv_dtau_R2_dqdPE7 = new_minv_dtau_R2_dqdPE7 + minv_vec_out_R2_dqdPE7;
new_minv_dtau_R3_dqdPE7 = new_minv_dtau_R3_dqdPE7 + minv_vec_out_R3_dqdPE7;
new_minv_dtau_R4_dqdPE7 = new_minv_dtau_R4_dqdPE7 + minv_vec_out_R4_dqdPE7;
new_minv_dtau_R5_dqdPE7 = new_minv_dtau_R5_dqdPE7 + minv_vec_out_R5_dqdPE7;
new_minv_dtau_R6_dqdPE7 = new_minv_dtau_R6_dqdPE7 + minv_vec_out_R6_dqdPE7;
new_minv_dtau_R7_dqdPE7 = new_minv_dtau_R7_dqdPE7 + minv_vec_out_R7_dqdPE7;

case (idx_block_minv_stream_dtau)
    // new_minv_dtau[r][c] = new_minv_dtau[r][c] + update;

    0: begin
        new_minv_dtau[0][0] = new_minv_dtau_R1_dqdPE1;
        new_minv_dtau[1][0] = new_minv_dtau_R2_dqdPE1;
        new_minv_dtau[2][0] = new_minv_dtau_R3_dqdPE1;
        new_minv_dtau[3][0] = new_minv_dtau_R4_dqdPE1;
        new_minv_dtau[4][0] = new_minv_dtau_R5_dqdPE1;
        new_minv_dtau[5][0] = new_minv_dtau_R6_dqdPE1;
        new_minv_dtau[6][0] = new_minv_dtau_R7_dqdPE1;

        new_minv_dtau[0][1] = new_minv_dtau_R1_dqdPE2;
        new_minv_dtau[1][1] = new_minv_dtau_R2_dqdPE2;
        new_minv_dtau[2][1] = new_minv_dtau_R3_dqdPE2;
        new_minv_dtau[3][1] = new_minv_dtau_R4_dqdPE2;
        new_minv_dtau[4][1] = new_minv_dtau_R5_dqdPE2;
        new_minv_dtau[5][1] = new_minv_dtau_R6_dqdPE2;
        new_minv_dtau[6][1] = new_minv_dtau_R7_dqdPE2;

        new_minv_dtau[0][2] = new_minv_dtau_R1_dqdPE3;
        new_minv_dtau[1][2] = new_minv_dtau_R2_dqdPE3;
        new_minv_dtau[2][2] = new_minv_dtau_R3_dqdPE3;
        new_minv_dtau[3][2] = new_minv_dtau_R4_dqdPE3;
        new_minv_dtau[4][2] = new_minv_dtau_R5_dqdPE3;
        new_minv_dtau[5][2] = new_minv_dtau_R6_dqdPE3;
        new_minv_dtau[6][2] = new_minv_dtau_R7_dqdPE3;

        new_minv_dtau[0][3] = new_minv_dtau_R1_dqdPE4;
        new_minv_dtau[1][3] = new_minv_dtau_R2_dqdPE4;
        new_minv_dtau[2][3] = new_minv_dtau_R3_dqdPE4;
        new_minv_dtau[3][3] = new_minv_dtau_R4_dqdPE4;
        new_minv_dtau[4][3] = new_minv_dtau_R5_dqdPE4;
        new_minv_dtau[5][3] = new_minv_dtau_R6_dqdPE4;
        new_minv_dtau[6][3] = new_minv_dtau_R7_dqdPE4;

        new_minv_dtau[0][4] = new_minv_dtau_R1_dqdPE5;
        new_minv_dtau[1][4] = new_minv_dtau_R2_dqdPE5;
        new_minv_dtau[2][4] = new_minv_dtau_R3_dqdPE5;
        new_minv_dtau[3][4] = new_minv_dtau_R4_dqdPE5;
        new_minv_dtau[4][4] = new_minv_dtau_R5_dqdPE5;
        new_minv_dtau[5][4] = new_minv_dtau_R6_dqdPE5;
        new_minv_dtau[6][4] = new_minv_dtau_R7_dqdPE5;

        new_minv_dtau[0][5] = new_minv_dtau_R1_dqdPE6;
        new_minv_dtau[1][5] = new_minv_dtau_R2_dqdPE6;
        new_minv_dtau[2][5] = new_minv_dtau_R3_dqdPE6;
        new_minv_dtau[3][5] = new_minv_dtau_R4_dqdPE6;
        new_minv_dtau[4][5] = new_minv_dtau_R5_dqdPE6;
        new_minv_dtau[5][5] = new_minv_dtau_R6_dqdPE6;
        new_minv_dtau[6][5] = new_minv_dtau_R7_dqdPE6;

        new_minv_dtau[0][6] = new_minv_dtau_R1_dqdPE7;
        new_minv_dtau[1][6] = new_minv_dtau_R2_dqdPE7;
        new_minv_dtau[2][6] = new_minv_dtau_R3_dqdPE7;
        new_minv_dtau[3][6] = new_minv_dtau_R4_dqdPE7;
        new_minv_dtau[4][6] = new_minv_dtau_R5_dqdPE7;
        new_minv_dtau[5][6] = new_minv_dtau_R6_dqdPE7;
        new_minv_dtau[6][6] = new_minv_dtau_R7_dqdPE7;

    end

endcase

