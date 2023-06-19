case (idx_forward_stream)
    // curr is 1-indexed
    // dim, derv are 0-indexed
    // new_f_inter_acc[curr][dim]
    // slotting into right places in dfi{dq,dqd} matrix of regs
    // new_dfidq_inter_acc[curr][dim][derv]

    0: begin
        new_f_inter_acc[1][0] = f_curr_vec_out_AX_rnea;
        new_f_inter_acc[1][1] = f_curr_vec_out_AY_rnea;
        new_f_inter_acc[1][2] = f_curr_vec_out_AZ_rnea;
        new_f_inter_acc[1][3] = f_curr_vec_out_LX_rnea;
        new_f_inter_acc[1][4] = f_curr_vec_out_LY_rnea;
        new_f_inter_acc[1][5] = f_curr_vec_out_LZ_rnea;

        // dfidq

        new_dfidq_inter_acc[0][0][0] = dfdq_curr_vec_out_AX_dqPE1;
        new_dfidq_inter_acc[0][0][1] = dfdq_curr_vec_out_AX_dqPE2;
        new_dfidq_inter_acc[0][0][2] = dfdq_curr_vec_out_AX_dqPE3;
        new_dfidq_inter_acc[0][0][3] = dfdq_curr_vec_out_AX_dqPE4;
        new_dfidq_inter_acc[0][0][4] = dfdq_curr_vec_out_AX_dqPE5;
        new_dfidq_inter_acc[0][0][5] = dfdq_curr_vec_out_AX_dqPE6;
        new_dfidq_inter_acc[0][0][6] = dfdq_curr_vec_out_AX_dqPE7;

        new_dfidq_inter_acc[0][1][0] = dfdq_curr_vec_out_AY_dqPE1;
        new_dfidq_inter_acc[0][1][1] = dfdq_curr_vec_out_AY_dqPE2;
        new_dfidq_inter_acc[0][1][2] = dfdq_curr_vec_out_AY_dqPE3;
        new_dfidq_inter_acc[0][1][3] = dfdq_curr_vec_out_AY_dqPE4;
        new_dfidq_inter_acc[0][1][4] = dfdq_curr_vec_out_AY_dqPE5;
        new_dfidq_inter_acc[0][1][5] = dfdq_curr_vec_out_AY_dqPE6;
        new_dfidq_inter_acc[0][1][6] = dfdq_curr_vec_out_AY_dqPE7;

        new_dfidq_inter_acc[0][2][0] = dfdq_curr_vec_out_AZ_dqPE1;
        new_dfidq_inter_acc[0][2][1] = dfdq_curr_vec_out_AZ_dqPE2;
        new_dfidq_inter_acc[0][2][2] = dfdq_curr_vec_out_AZ_dqPE3;
        new_dfidq_inter_acc[0][2][3] = dfdq_curr_vec_out_AZ_dqPE4;
        new_dfidq_inter_acc[0][2][4] = dfdq_curr_vec_out_AZ_dqPE5;
        new_dfidq_inter_acc[0][2][5] = dfdq_curr_vec_out_AZ_dqPE6;
        new_dfidq_inter_acc[0][2][6] = dfdq_curr_vec_out_AZ_dqPE7;

        new_dfidq_inter_acc[0][3][0] = dfdq_curr_vec_out_LX_dqPE1;
        new_dfidq_inter_acc[0][3][1] = dfdq_curr_vec_out_LX_dqPE2;
        new_dfidq_inter_acc[0][3][2] = dfdq_curr_vec_out_LX_dqPE3;
        new_dfidq_inter_acc[0][3][3] = dfdq_curr_vec_out_LX_dqPE4;
        new_dfidq_inter_acc[0][3][4] = dfdq_curr_vec_out_LX_dqPE5;
        new_dfidq_inter_acc[0][3][5] = dfdq_curr_vec_out_LX_dqPE6;
        new_dfidq_inter_acc[0][3][6] = dfdq_curr_vec_out_LX_dqPE7;

        new_dfidq_inter_acc[0][4][0] = dfdq_curr_vec_out_LY_dqPE1;
        new_dfidq_inter_acc[0][4][1] = dfdq_curr_vec_out_LY_dqPE2;
        new_dfidq_inter_acc[0][4][2] = dfdq_curr_vec_out_LY_dqPE3;
        new_dfidq_inter_acc[0][4][3] = dfdq_curr_vec_out_LY_dqPE4;
        new_dfidq_inter_acc[0][4][4] = dfdq_curr_vec_out_LY_dqPE5;
        new_dfidq_inter_acc[0][4][5] = dfdq_curr_vec_out_LY_dqPE6;
        new_dfidq_inter_acc[0][4][6] = dfdq_curr_vec_out_LY_dqPE7;

        new_dfidq_inter_acc[0][5][0] = dfdq_curr_vec_out_LZ_dqPE1;
        new_dfidq_inter_acc[0][5][1] = dfdq_curr_vec_out_LZ_dqPE2;
        new_dfidq_inter_acc[0][5][2] = dfdq_curr_vec_out_LZ_dqPE3;
        new_dfidq_inter_acc[0][5][3] = dfdq_curr_vec_out_LZ_dqPE4;
        new_dfidq_inter_acc[0][5][4] = dfdq_curr_vec_out_LZ_dqPE5;
        new_dfidq_inter_acc[0][5][5] = dfdq_curr_vec_out_LZ_dqPE6;
        new_dfidq_inter_acc[0][5][6] = dfdq_curr_vec_out_LZ_dqPE7;

        // dfidqd

        new_dfidqd_inter_acc[0][0][0] = dfdqd_curr_vec_out_AX_dqdPE1;
        new_dfidqd_inter_acc[0][0][1] = dfdqd_curr_vec_out_AX_dqdPE2;
        new_dfidqd_inter_acc[0][0][2] = dfdqd_curr_vec_out_AX_dqdPE3;
        new_dfidqd_inter_acc[0][0][3] = dfdqd_curr_vec_out_AX_dqdPE4;
        new_dfidqd_inter_acc[0][0][4] = dfdqd_curr_vec_out_AX_dqdPE5;
        new_dfidqd_inter_acc[0][0][5] = dfdqd_curr_vec_out_AX_dqdPE6;
        new_dfidqd_inter_acc[0][0][6] = dfdqd_curr_vec_out_AX_dqdPE7;
        new_dfidqd_inter_acc[0][1][0] = dfdqd_curr_vec_out_AY_dqdPE1;
        new_dfidqd_inter_acc[0][1][1] = dfdqd_curr_vec_out_AY_dqdPE2;
        new_dfidqd_inter_acc[0][1][2] = dfdqd_curr_vec_out_AY_dqdPE3;
        new_dfidqd_inter_acc[0][1][3] = dfdqd_curr_vec_out_AY_dqdPE4;
        new_dfidqd_inter_acc[0][1][4] = dfdqd_curr_vec_out_AY_dqdPE5;
        new_dfidqd_inter_acc[0][1][5] = dfdqd_curr_vec_out_AY_dqdPE6;
        new_dfidqd_inter_acc[0][1][6] = dfdqd_curr_vec_out_AY_dqdPE7;
        new_dfidqd_inter_acc[0][2][0] = dfdqd_curr_vec_out_AZ_dqdPE1;
        new_dfidqd_inter_acc[0][2][1] = dfdqd_curr_vec_out_AZ_dqdPE2;
        new_dfidqd_inter_acc[0][2][2] = dfdqd_curr_vec_out_AZ_dqdPE3;
        new_dfidqd_inter_acc[0][2][3] = dfdqd_curr_vec_out_AZ_dqdPE4;
        new_dfidqd_inter_acc[0][2][4] = dfdqd_curr_vec_out_AZ_dqdPE5;
        new_dfidqd_inter_acc[0][2][5] = dfdqd_curr_vec_out_AZ_dqdPE6;
        new_dfidqd_inter_acc[0][2][6] = dfdqd_curr_vec_out_AZ_dqdPE7;
        new_dfidqd_inter_acc[0][3][0] = dfdqd_curr_vec_out_LX_dqdPE1;
        new_dfidqd_inter_acc[0][3][1] = dfdqd_curr_vec_out_LX_dqdPE2;
        new_dfidqd_inter_acc[0][3][2] = dfdqd_curr_vec_out_LX_dqdPE3;
        new_dfidqd_inter_acc[0][3][3] = dfdqd_curr_vec_out_LX_dqdPE4;
        new_dfidqd_inter_acc[0][3][4] = dfdqd_curr_vec_out_LX_dqdPE5;
        new_dfidqd_inter_acc[0][3][5] = dfdqd_curr_vec_out_LX_dqdPE6;
        new_dfidqd_inter_acc[0][3][6] = dfdqd_curr_vec_out_LX_dqdPE7;
        new_dfidqd_inter_acc[0][4][0] = dfdqd_curr_vec_out_LY_dqdPE1;
        new_dfidqd_inter_acc[0][4][1] = dfdqd_curr_vec_out_LY_dqdPE2;
        new_dfidqd_inter_acc[0][4][2] = dfdqd_curr_vec_out_LY_dqdPE3;
        new_dfidqd_inter_acc[0][4][3] = dfdqd_curr_vec_out_LY_dqdPE4;
        new_dfidqd_inter_acc[0][4][4] = dfdqd_curr_vec_out_LY_dqdPE5;
        new_dfidqd_inter_acc[0][4][5] = dfdqd_curr_vec_out_LY_dqdPE6;
        new_dfidqd_inter_acc[0][4][6] = dfdqd_curr_vec_out_LY_dqdPE7;
        new_dfidqd_inter_acc[0][5][0] = dfdqd_curr_vec_out_LZ_dqdPE1;
        new_dfidqd_inter_acc[0][5][1] = dfdqd_curr_vec_out_LZ_dqdPE2;
        new_dfidqd_inter_acc[0][5][2] = dfdqd_curr_vec_out_LZ_dqdPE3;
        new_dfidqd_inter_acc[0][5][3] = dfdqd_curr_vec_out_LZ_dqdPE4;
        new_dfidqd_inter_acc[0][5][4] = dfdqd_curr_vec_out_LZ_dqdPE5;
        new_dfidqd_inter_acc[0][5][5] = dfdqd_curr_vec_out_LZ_dqdPE6;
        new_dfidqd_inter_acc[0][5][6] = dfdqd_curr_vec_out_LZ_dqdPE7;
    end

    1: begin
        new_f_inter_acc[2][0] = f_curr_vec_out_AX_rnea;
        new_f_inter_acc[2][1] = f_curr_vec_out_AY_rnea;
        new_f_inter_acc[2][2] = f_curr_vec_out_AZ_rnea;
        new_f_inter_acc[2][3] = f_curr_vec_out_LX_rnea;
        new_f_inter_acc[2][4] = f_curr_vec_out_LY_rnea;
        new_f_inter_acc[2][5] = f_curr_vec_out_LZ_rnea;

        // dfidq

        new_dfidq_inter_acc[1][0][0] = dfdq_curr_vec_out_AX_dqPE1;
        new_dfidq_inter_acc[0][0][1] = dfdq_curr_vec_out_AX_dqPE2;
        new_dfidq_inter_acc[0][0][2] = dfdq_curr_vec_out_AX_dqPE3;
        new_dfidq_inter_acc[0][0][3] = dfdq_curr_vec_out_AX_dqPE4;
        new_dfidq_inter_acc[0][0][4] = dfdq_curr_vec_out_AX_dqPE5;
        new_dfidq_inter_acc[0][0][5] = dfdq_curr_vec_out_AX_dqPE6;
        new_dfidq_inter_acc[0][0][6] = dfdq_curr_vec_out_AX_dqPE7;

        new_dfidq_inter_acc[1][1][0] = dfdq_curr_vec_out_AY_dqPE1;
        new_dfidq_inter_acc[0][1][1] = dfdq_curr_vec_out_AY_dqPE2;
        new_dfidq_inter_acc[0][1][2] = dfdq_curr_vec_out_AY_dqPE3;
        new_dfidq_inter_acc[0][1][3] = dfdq_curr_vec_out_AY_dqPE4;
        new_dfidq_inter_acc[0][1][4] = dfdq_curr_vec_out_AY_dqPE5;
        new_dfidq_inter_acc[0][1][5] = dfdq_curr_vec_out_AY_dqPE6;
        new_dfidq_inter_acc[0][1][6] = dfdq_curr_vec_out_AY_dqPE7;

        new_dfidq_inter_acc[1][2][0] = dfdq_curr_vec_out_AZ_dqPE1;
        new_dfidq_inter_acc[0][2][1] = dfdq_curr_vec_out_AZ_dqPE2;
        new_dfidq_inter_acc[0][2][2] = dfdq_curr_vec_out_AZ_dqPE3;
        new_dfidq_inter_acc[0][2][3] = dfdq_curr_vec_out_AZ_dqPE4;
        new_dfidq_inter_acc[0][2][4] = dfdq_curr_vec_out_AZ_dqPE5;
        new_dfidq_inter_acc[0][2][5] = dfdq_curr_vec_out_AZ_dqPE6;
        new_dfidq_inter_acc[0][2][6] = dfdq_curr_vec_out_AZ_dqPE7;

        new_dfidq_inter_acc[1][3][0] = dfdq_curr_vec_out_LX_dqPE1;
        new_dfidq_inter_acc[0][3][1] = dfdq_curr_vec_out_LX_dqPE2;
        new_dfidq_inter_acc[0][3][2] = dfdq_curr_vec_out_LX_dqPE3;
        new_dfidq_inter_acc[0][3][3] = dfdq_curr_vec_out_LX_dqPE4;
        new_dfidq_inter_acc[0][3][4] = dfdq_curr_vec_out_LX_dqPE5;
        new_dfidq_inter_acc[0][3][5] = dfdq_curr_vec_out_LX_dqPE6;
        new_dfidq_inter_acc[0][3][6] = dfdq_curr_vec_out_LX_dqPE7;

        new_dfidq_inter_acc[1][4][0] = dfdq_curr_vec_out_LY_dqPE1;
        new_dfidq_inter_acc[0][4][1] = dfdq_curr_vec_out_LY_dqPE2;
        new_dfidq_inter_acc[0][4][2] = dfdq_curr_vec_out_LY_dqPE3;
        new_dfidq_inter_acc[0][4][3] = dfdq_curr_vec_out_LY_dqPE4;
        new_dfidq_inter_acc[0][4][4] = dfdq_curr_vec_out_LY_dqPE5;
        new_dfidq_inter_acc[0][4][5] = dfdq_curr_vec_out_LY_dqPE6;
        new_dfidq_inter_acc[0][4][6] = dfdq_curr_vec_out_LY_dqPE7;

        new_dfidq_inter_acc[1][5][0] = dfdq_curr_vec_out_LZ_dqPE1;
        new_dfidq_inter_acc[0][5][1] = dfdq_curr_vec_out_LZ_dqPE2;
        new_dfidq_inter_acc[0][5][2] = dfdq_curr_vec_out_LZ_dqPE3;
        new_dfidq_inter_acc[0][5][3] = dfdq_curr_vec_out_LZ_dqPE4;
        new_dfidq_inter_acc[0][5][4] = dfdq_curr_vec_out_LZ_dqPE5;
        new_dfidq_inter_acc[0][5][5] = dfdq_curr_vec_out_LZ_dqPE6;
        new_dfidq_inter_acc[0][5][6] = dfdq_curr_vec_out_LZ_dqPE7;

        // dfidqd

        new_dfidqd_inter_acc[1][0][0] = dfdqd_curr_vec_out_AX_dqdPE1;
        new_dfidqd_inter_acc[0][0][1] = dfdqd_curr_vec_out_AX_dqdPE2;
        new_dfidqd_inter_acc[0][0][2] = dfdqd_curr_vec_out_AX_dqdPE3;
        new_dfidqd_inter_acc[0][0][3] = dfdqd_curr_vec_out_AX_dqdPE4;
        new_dfidqd_inter_acc[0][0][4] = dfdqd_curr_vec_out_AX_dqdPE5;
        new_dfidqd_inter_acc[0][0][5] = dfdqd_curr_vec_out_AX_dqdPE6;
        new_dfidqd_inter_acc[0][0][6] = dfdqd_curr_vec_out_AX_dqdPE7;
        new_dfidqd_inter_acc[1][1][0] = dfdqd_curr_vec_out_AY_dqdPE1;
        new_dfidqd_inter_acc[0][1][1] = dfdqd_curr_vec_out_AY_dqdPE2;
        new_dfidqd_inter_acc[0][1][2] = dfdqd_curr_vec_out_AY_dqdPE3;
        new_dfidqd_inter_acc[0][1][3] = dfdqd_curr_vec_out_AY_dqdPE4;
        new_dfidqd_inter_acc[0][1][4] = dfdqd_curr_vec_out_AY_dqdPE5;
        new_dfidqd_inter_acc[0][1][5] = dfdqd_curr_vec_out_AY_dqdPE6;
        new_dfidqd_inter_acc[0][1][6] = dfdqd_curr_vec_out_AY_dqdPE7;
        new_dfidqd_inter_acc[1][2][0] = dfdqd_curr_vec_out_AZ_dqdPE1;
        new_dfidqd_inter_acc[0][2][1] = dfdqd_curr_vec_out_AZ_dqdPE2;
        new_dfidqd_inter_acc[0][2][2] = dfdqd_curr_vec_out_AZ_dqdPE3;
        new_dfidqd_inter_acc[0][2][3] = dfdqd_curr_vec_out_AZ_dqdPE4;
        new_dfidqd_inter_acc[0][2][4] = dfdqd_curr_vec_out_AZ_dqdPE5;
        new_dfidqd_inter_acc[0][2][5] = dfdqd_curr_vec_out_AZ_dqdPE6;
        new_dfidqd_inter_acc[0][2][6] = dfdqd_curr_vec_out_AZ_dqdPE7;
        new_dfidqd_inter_acc[1][3][0] = dfdqd_curr_vec_out_LX_dqdPE1;
        new_dfidqd_inter_acc[0][3][1] = dfdqd_curr_vec_out_LX_dqdPE2;
        new_dfidqd_inter_acc[0][3][2] = dfdqd_curr_vec_out_LX_dqdPE3;
        new_dfidqd_inter_acc[0][3][3] = dfdqd_curr_vec_out_LX_dqdPE4;
        new_dfidqd_inter_acc[0][3][4] = dfdqd_curr_vec_out_LX_dqdPE5;
        new_dfidqd_inter_acc[0][3][5] = dfdqd_curr_vec_out_LX_dqdPE6;
        new_dfidqd_inter_acc[0][3][6] = dfdqd_curr_vec_out_LX_dqdPE7;
        new_dfidqd_inter_acc[1][4][0] = dfdqd_curr_vec_out_LY_dqdPE1;
        new_dfidqd_inter_acc[0][4][1] = dfdqd_curr_vec_out_LY_dqdPE2;
        new_dfidqd_inter_acc[0][4][2] = dfdqd_curr_vec_out_LY_dqdPE3;
        new_dfidqd_inter_acc[0][4][3] = dfdqd_curr_vec_out_LY_dqdPE4;
        new_dfidqd_inter_acc[0][4][4] = dfdqd_curr_vec_out_LY_dqdPE5;
        new_dfidqd_inter_acc[0][4][5] = dfdqd_curr_vec_out_LY_dqdPE6;
        new_dfidqd_inter_acc[0][4][6] = dfdqd_curr_vec_out_LY_dqdPE7;
        new_dfidqd_inter_acc[1][5][0] = dfdqd_curr_vec_out_LZ_dqdPE1;
        new_dfidqd_inter_acc[0][5][1] = dfdqd_curr_vec_out_LZ_dqdPE2;
        new_dfidqd_inter_acc[0][5][2] = dfdqd_curr_vec_out_LZ_dqdPE3;
        new_dfidqd_inter_acc[0][5][3] = dfdqd_curr_vec_out_LZ_dqdPE4;
        new_dfidqd_inter_acc[0][5][4] = dfdqd_curr_vec_out_LZ_dqdPE5;
        new_dfidqd_inter_acc[0][5][5] = dfdqd_curr_vec_out_LZ_dqdPE6;
        new_dfidqd_inter_acc[0][5][6] = dfdqd_curr_vec_out_LZ_dqdPE7;
    end

    2: begin
        new_f_inter_acc[3][0] = f_curr_vec_out_AX_rnea;
        new_f_inter_acc[3][1] = f_curr_vec_out_AY_rnea;
        new_f_inter_acc[3][2] = f_curr_vec_out_AZ_rnea;
        new_f_inter_acc[3][3] = f_curr_vec_out_LX_rnea;
        new_f_inter_acc[3][4] = f_curr_vec_out_LY_rnea;
        new_f_inter_acc[3][5] = f_curr_vec_out_LZ_rnea;

        // dfidq

        new_dfidq_inter_acc[2][0][0] = dfdq_curr_vec_out_AX_dqPE1;
        new_dfidq_inter_acc[2][0][1] = dfdq_curr_vec_out_AX_dqPE2;
        new_dfidq_inter_acc[0][0][2] = dfdq_curr_vec_out_AX_dqPE3;
        new_dfidq_inter_acc[0][0][3] = dfdq_curr_vec_out_AX_dqPE4;
        new_dfidq_inter_acc[0][0][4] = dfdq_curr_vec_out_AX_dqPE5;
        new_dfidq_inter_acc[0][0][5] = dfdq_curr_vec_out_AX_dqPE6;
        new_dfidq_inter_acc[0][0][6] = dfdq_curr_vec_out_AX_dqPE7;

        new_dfidq_inter_acc[2][1][0] = dfdq_curr_vec_out_AY_dqPE1;
        new_dfidq_inter_acc[2][1][1] = dfdq_curr_vec_out_AY_dqPE2;
        new_dfidq_inter_acc[0][1][2] = dfdq_curr_vec_out_AY_dqPE3;
        new_dfidq_inter_acc[0][1][3] = dfdq_curr_vec_out_AY_dqPE4;
        new_dfidq_inter_acc[0][1][4] = dfdq_curr_vec_out_AY_dqPE5;
        new_dfidq_inter_acc[0][1][5] = dfdq_curr_vec_out_AY_dqPE6;
        new_dfidq_inter_acc[0][1][6] = dfdq_curr_vec_out_AY_dqPE7;

        new_dfidq_inter_acc[2][2][0] = dfdq_curr_vec_out_AZ_dqPE1;
        new_dfidq_inter_acc[2][2][1] = dfdq_curr_vec_out_AZ_dqPE2;
        new_dfidq_inter_acc[0][2][2] = dfdq_curr_vec_out_AZ_dqPE3;
        new_dfidq_inter_acc[0][2][3] = dfdq_curr_vec_out_AZ_dqPE4;
        new_dfidq_inter_acc[0][2][4] = dfdq_curr_vec_out_AZ_dqPE5;
        new_dfidq_inter_acc[0][2][5] = dfdq_curr_vec_out_AZ_dqPE6;
        new_dfidq_inter_acc[0][2][6] = dfdq_curr_vec_out_AZ_dqPE7;

        new_dfidq_inter_acc[2][3][0] = dfdq_curr_vec_out_LX_dqPE1;
        new_dfidq_inter_acc[2][3][1] = dfdq_curr_vec_out_LX_dqPE2;
        new_dfidq_inter_acc[0][3][2] = dfdq_curr_vec_out_LX_dqPE3;
        new_dfidq_inter_acc[0][3][3] = dfdq_curr_vec_out_LX_dqPE4;
        new_dfidq_inter_acc[0][3][4] = dfdq_curr_vec_out_LX_dqPE5;
        new_dfidq_inter_acc[0][3][5] = dfdq_curr_vec_out_LX_dqPE6;
        new_dfidq_inter_acc[0][3][6] = dfdq_curr_vec_out_LX_dqPE7;

        new_dfidq_inter_acc[2][4][0] = dfdq_curr_vec_out_LY_dqPE1;
        new_dfidq_inter_acc[2][4][1] = dfdq_curr_vec_out_LY_dqPE2;
        new_dfidq_inter_acc[0][4][2] = dfdq_curr_vec_out_LY_dqPE3;
        new_dfidq_inter_acc[0][4][3] = dfdq_curr_vec_out_LY_dqPE4;
        new_dfidq_inter_acc[0][4][4] = dfdq_curr_vec_out_LY_dqPE5;
        new_dfidq_inter_acc[0][4][5] = dfdq_curr_vec_out_LY_dqPE6;
        new_dfidq_inter_acc[0][4][6] = dfdq_curr_vec_out_LY_dqPE7;

        new_dfidq_inter_acc[2][5][0] = dfdq_curr_vec_out_LZ_dqPE1;
        new_dfidq_inter_acc[2][5][1] = dfdq_curr_vec_out_LZ_dqPE2;
        new_dfidq_inter_acc[0][5][2] = dfdq_curr_vec_out_LZ_dqPE3;
        new_dfidq_inter_acc[0][5][3] = dfdq_curr_vec_out_LZ_dqPE4;
        new_dfidq_inter_acc[0][5][4] = dfdq_curr_vec_out_LZ_dqPE5;
        new_dfidq_inter_acc[0][5][5] = dfdq_curr_vec_out_LZ_dqPE6;
        new_dfidq_inter_acc[0][5][6] = dfdq_curr_vec_out_LZ_dqPE7;

        // dfidqd

        new_dfidqd_inter_acc[2][0][0] = dfdqd_curr_vec_out_AX_dqdPE1;
        new_dfidqd_inter_acc[2][0][1] = dfdqd_curr_vec_out_AX_dqdPE2;
        new_dfidqd_inter_acc[0][0][2] = dfdqd_curr_vec_out_AX_dqdPE3;
        new_dfidqd_inter_acc[0][0][3] = dfdqd_curr_vec_out_AX_dqdPE4;
        new_dfidqd_inter_acc[0][0][4] = dfdqd_curr_vec_out_AX_dqdPE5;
        new_dfidqd_inter_acc[0][0][5] = dfdqd_curr_vec_out_AX_dqdPE6;
        new_dfidqd_inter_acc[0][0][6] = dfdqd_curr_vec_out_AX_dqdPE7;
        new_dfidqd_inter_acc[2][1][0] = dfdqd_curr_vec_out_AY_dqdPE1;
        new_dfidqd_inter_acc[2][1][1] = dfdqd_curr_vec_out_AY_dqdPE2;
        new_dfidqd_inter_acc[0][1][2] = dfdqd_curr_vec_out_AY_dqdPE3;
        new_dfidqd_inter_acc[0][1][3] = dfdqd_curr_vec_out_AY_dqdPE4;
        new_dfidqd_inter_acc[0][1][4] = dfdqd_curr_vec_out_AY_dqdPE5;
        new_dfidqd_inter_acc[0][1][5] = dfdqd_curr_vec_out_AY_dqdPE6;
        new_dfidqd_inter_acc[0][1][6] = dfdqd_curr_vec_out_AY_dqdPE7;
        new_dfidqd_inter_acc[2][2][0] = dfdqd_curr_vec_out_AZ_dqdPE1;
        new_dfidqd_inter_acc[2][2][1] = dfdqd_curr_vec_out_AZ_dqdPE2;
        new_dfidqd_inter_acc[0][2][2] = dfdqd_curr_vec_out_AZ_dqdPE3;
        new_dfidqd_inter_acc[0][2][3] = dfdqd_curr_vec_out_AZ_dqdPE4;
        new_dfidqd_inter_acc[0][2][4] = dfdqd_curr_vec_out_AZ_dqdPE5;
        new_dfidqd_inter_acc[0][2][5] = dfdqd_curr_vec_out_AZ_dqdPE6;
        new_dfidqd_inter_acc[0][2][6] = dfdqd_curr_vec_out_AZ_dqdPE7;
        new_dfidqd_inter_acc[2][3][0] = dfdqd_curr_vec_out_LX_dqdPE1;
        new_dfidqd_inter_acc[2][3][1] = dfdqd_curr_vec_out_LX_dqdPE2;
        new_dfidqd_inter_acc[0][3][2] = dfdqd_curr_vec_out_LX_dqdPE3;
        new_dfidqd_inter_acc[0][3][3] = dfdqd_curr_vec_out_LX_dqdPE4;
        new_dfidqd_inter_acc[0][3][4] = dfdqd_curr_vec_out_LX_dqdPE5;
        new_dfidqd_inter_acc[0][3][5] = dfdqd_curr_vec_out_LX_dqdPE6;
        new_dfidqd_inter_acc[0][3][6] = dfdqd_curr_vec_out_LX_dqdPE7;
        new_dfidqd_inter_acc[2][4][0] = dfdqd_curr_vec_out_LY_dqdPE1;
        new_dfidqd_inter_acc[2][4][1] = dfdqd_curr_vec_out_LY_dqdPE2;
        new_dfidqd_inter_acc[0][4][2] = dfdqd_curr_vec_out_LY_dqdPE3;
        new_dfidqd_inter_acc[0][4][3] = dfdqd_curr_vec_out_LY_dqdPE4;
        new_dfidqd_inter_acc[0][4][4] = dfdqd_curr_vec_out_LY_dqdPE5;
        new_dfidqd_inter_acc[0][4][5] = dfdqd_curr_vec_out_LY_dqdPE6;
        new_dfidqd_inter_acc[0][4][6] = dfdqd_curr_vec_out_LY_dqdPE7;
        new_dfidqd_inter_acc[2][5][0] = dfdqd_curr_vec_out_LZ_dqdPE1;
        new_dfidqd_inter_acc[2][5][1] = dfdqd_curr_vec_out_LZ_dqdPE2;
        new_dfidqd_inter_acc[0][5][2] = dfdqd_curr_vec_out_LZ_dqdPE3;
        new_dfidqd_inter_acc[0][5][3] = dfdqd_curr_vec_out_LZ_dqdPE4;
        new_dfidqd_inter_acc[0][5][4] = dfdqd_curr_vec_out_LZ_dqdPE5;
        new_dfidqd_inter_acc[0][5][5] = dfdqd_curr_vec_out_LZ_dqdPE6;
        new_dfidqd_inter_acc[0][5][6] = dfdqd_curr_vec_out_LZ_dqdPE7;
    end

    3: begin
        new_f_inter_acc[4][0] = f_curr_vec_out_AX_rnea;
        new_f_inter_acc[4][1] = f_curr_vec_out_AY_rnea;
        new_f_inter_acc[4][2] = f_curr_vec_out_AZ_rnea;
        new_f_inter_acc[4][3] = f_curr_vec_out_LX_rnea;
        new_f_inter_acc[4][4] = f_curr_vec_out_LY_rnea;
        new_f_inter_acc[4][5] = f_curr_vec_out_LZ_rnea;

        // dfidq

        new_dfidq_inter_acc[3][0][0] = dfdq_curr_vec_out_AX_dqPE1;
        new_dfidq_inter_acc[3][0][1] = dfdq_curr_vec_out_AX_dqPE2;
        new_dfidq_inter_acc[3][0][2] = dfdq_curr_vec_out_AX_dqPE3;
        new_dfidq_inter_acc[0][0][3] = dfdq_curr_vec_out_AX_dqPE4;
        new_dfidq_inter_acc[0][0][4] = dfdq_curr_vec_out_AX_dqPE5;
        new_dfidq_inter_acc[0][0][5] = dfdq_curr_vec_out_AX_dqPE6;
        new_dfidq_inter_acc[0][0][6] = dfdq_curr_vec_out_AX_dqPE7;

        new_dfidq_inter_acc[3][1][0] = dfdq_curr_vec_out_AY_dqPE1;
        new_dfidq_inter_acc[3][1][1] = dfdq_curr_vec_out_AY_dqPE2;
        new_dfidq_inter_acc[3][1][2] = dfdq_curr_vec_out_AY_dqPE3;
        new_dfidq_inter_acc[0][1][3] = dfdq_curr_vec_out_AY_dqPE4;
        new_dfidq_inter_acc[0][1][4] = dfdq_curr_vec_out_AY_dqPE5;
        new_dfidq_inter_acc[0][1][5] = dfdq_curr_vec_out_AY_dqPE6;
        new_dfidq_inter_acc[0][1][6] = dfdq_curr_vec_out_AY_dqPE7;

        new_dfidq_inter_acc[3][2][0] = dfdq_curr_vec_out_AZ_dqPE1;
        new_dfidq_inter_acc[3][2][1] = dfdq_curr_vec_out_AZ_dqPE2;
        new_dfidq_inter_acc[3][2][2] = dfdq_curr_vec_out_AZ_dqPE3;
        new_dfidq_inter_acc[0][2][3] = dfdq_curr_vec_out_AZ_dqPE4;
        new_dfidq_inter_acc[0][2][4] = dfdq_curr_vec_out_AZ_dqPE5;
        new_dfidq_inter_acc[0][2][5] = dfdq_curr_vec_out_AZ_dqPE6;
        new_dfidq_inter_acc[0][2][6] = dfdq_curr_vec_out_AZ_dqPE7;

        new_dfidq_inter_acc[3][3][0] = dfdq_curr_vec_out_LX_dqPE1;
        new_dfidq_inter_acc[3][3][1] = dfdq_curr_vec_out_LX_dqPE2;
        new_dfidq_inter_acc[3][3][2] = dfdq_curr_vec_out_LX_dqPE3;
        new_dfidq_inter_acc[0][3][3] = dfdq_curr_vec_out_LX_dqPE4;
        new_dfidq_inter_acc[0][3][4] = dfdq_curr_vec_out_LX_dqPE5;
        new_dfidq_inter_acc[0][3][5] = dfdq_curr_vec_out_LX_dqPE6;
        new_dfidq_inter_acc[0][3][6] = dfdq_curr_vec_out_LX_dqPE7;

        new_dfidq_inter_acc[3][4][0] = dfdq_curr_vec_out_LY_dqPE1;
        new_dfidq_inter_acc[3][4][1] = dfdq_curr_vec_out_LY_dqPE2;
        new_dfidq_inter_acc[3][4][2] = dfdq_curr_vec_out_LY_dqPE3;
        new_dfidq_inter_acc[0][4][3] = dfdq_curr_vec_out_LY_dqPE4;
        new_dfidq_inter_acc[0][4][4] = dfdq_curr_vec_out_LY_dqPE5;
        new_dfidq_inter_acc[0][4][5] = dfdq_curr_vec_out_LY_dqPE6;
        new_dfidq_inter_acc[0][4][6] = dfdq_curr_vec_out_LY_dqPE7;

        new_dfidq_inter_acc[3][5][0] = dfdq_curr_vec_out_LZ_dqPE1;
        new_dfidq_inter_acc[3][5][1] = dfdq_curr_vec_out_LZ_dqPE2;
        new_dfidq_inter_acc[3][5][2] = dfdq_curr_vec_out_LZ_dqPE3;
        new_dfidq_inter_acc[0][5][3] = dfdq_curr_vec_out_LZ_dqPE4;
        new_dfidq_inter_acc[0][5][4] = dfdq_curr_vec_out_LZ_dqPE5;
        new_dfidq_inter_acc[0][5][5] = dfdq_curr_vec_out_LZ_dqPE6;
        new_dfidq_inter_acc[0][5][6] = dfdq_curr_vec_out_LZ_dqPE7;

        // dfidqd

        new_dfidqd_inter_acc[3][0][0] = dfdqd_curr_vec_out_AX_dqdPE1;
        new_dfidqd_inter_acc[3][0][1] = dfdqd_curr_vec_out_AX_dqdPE2;
        new_dfidqd_inter_acc[3][0][2] = dfdqd_curr_vec_out_AX_dqdPE3;
        new_dfidqd_inter_acc[0][0][3] = dfdqd_curr_vec_out_AX_dqdPE4;
        new_dfidqd_inter_acc[0][0][4] = dfdqd_curr_vec_out_AX_dqdPE5;
        new_dfidqd_inter_acc[0][0][5] = dfdqd_curr_vec_out_AX_dqdPE6;
        new_dfidqd_inter_acc[0][0][6] = dfdqd_curr_vec_out_AX_dqdPE7;
        new_dfidqd_inter_acc[3][1][0] = dfdqd_curr_vec_out_AY_dqdPE1;
        new_dfidqd_inter_acc[3][1][1] = dfdqd_curr_vec_out_AY_dqdPE2;
        new_dfidqd_inter_acc[3][1][2] = dfdqd_curr_vec_out_AY_dqdPE3;
        new_dfidqd_inter_acc[0][1][3] = dfdqd_curr_vec_out_AY_dqdPE4;
        new_dfidqd_inter_acc[0][1][4] = dfdqd_curr_vec_out_AY_dqdPE5;
        new_dfidqd_inter_acc[0][1][5] = dfdqd_curr_vec_out_AY_dqdPE6;
        new_dfidqd_inter_acc[0][1][6] = dfdqd_curr_vec_out_AY_dqdPE7;
        new_dfidqd_inter_acc[3][2][0] = dfdqd_curr_vec_out_AZ_dqdPE1;
        new_dfidqd_inter_acc[3][2][1] = dfdqd_curr_vec_out_AZ_dqdPE2;
        new_dfidqd_inter_acc[3][2][2] = dfdqd_curr_vec_out_AZ_dqdPE3;
        new_dfidqd_inter_acc[0][2][3] = dfdqd_curr_vec_out_AZ_dqdPE4;
        new_dfidqd_inter_acc[0][2][4] = dfdqd_curr_vec_out_AZ_dqdPE5;
        new_dfidqd_inter_acc[0][2][5] = dfdqd_curr_vec_out_AZ_dqdPE6;
        new_dfidqd_inter_acc[0][2][6] = dfdqd_curr_vec_out_AZ_dqdPE7;
        new_dfidqd_inter_acc[3][3][0] = dfdqd_curr_vec_out_LX_dqdPE1;
        new_dfidqd_inter_acc[3][3][1] = dfdqd_curr_vec_out_LX_dqdPE2;
        new_dfidqd_inter_acc[3][3][2] = dfdqd_curr_vec_out_LX_dqdPE3;
        new_dfidqd_inter_acc[0][3][3] = dfdqd_curr_vec_out_LX_dqdPE4;
        new_dfidqd_inter_acc[0][3][4] = dfdqd_curr_vec_out_LX_dqdPE5;
        new_dfidqd_inter_acc[0][3][5] = dfdqd_curr_vec_out_LX_dqdPE6;
        new_dfidqd_inter_acc[0][3][6] = dfdqd_curr_vec_out_LX_dqdPE7;
        new_dfidqd_inter_acc[3][4][0] = dfdqd_curr_vec_out_LY_dqdPE1;
        new_dfidqd_inter_acc[3][4][1] = dfdqd_curr_vec_out_LY_dqdPE2;
        new_dfidqd_inter_acc[3][4][2] = dfdqd_curr_vec_out_LY_dqdPE3;
        new_dfidqd_inter_acc[0][4][3] = dfdqd_curr_vec_out_LY_dqdPE4;
        new_dfidqd_inter_acc[0][4][4] = dfdqd_curr_vec_out_LY_dqdPE5;
        new_dfidqd_inter_acc[0][4][5] = dfdqd_curr_vec_out_LY_dqdPE6;
        new_dfidqd_inter_acc[0][4][6] = dfdqd_curr_vec_out_LY_dqdPE7;
        new_dfidqd_inter_acc[3][5][0] = dfdqd_curr_vec_out_LZ_dqdPE1;
        new_dfidqd_inter_acc[3][5][1] = dfdqd_curr_vec_out_LZ_dqdPE2;
        new_dfidqd_inter_acc[3][5][2] = dfdqd_curr_vec_out_LZ_dqdPE3;
        new_dfidqd_inter_acc[0][5][3] = dfdqd_curr_vec_out_LZ_dqdPE4;
        new_dfidqd_inter_acc[0][5][4] = dfdqd_curr_vec_out_LZ_dqdPE5;
        new_dfidqd_inter_acc[0][5][5] = dfdqd_curr_vec_out_LZ_dqdPE6;
        new_dfidqd_inter_acc[0][5][6] = dfdqd_curr_vec_out_LZ_dqdPE7;
    end

    4: begin
        new_f_inter_acc[5][0] = f_curr_vec_out_AX_rnea;
        new_f_inter_acc[5][1] = f_curr_vec_out_AY_rnea;
        new_f_inter_acc[5][2] = f_curr_vec_out_AZ_rnea;
        new_f_inter_acc[5][3] = f_curr_vec_out_LX_rnea;
        new_f_inter_acc[5][4] = f_curr_vec_out_LY_rnea;
        new_f_inter_acc[5][5] = f_curr_vec_out_LZ_rnea;

        // dfidq

        new_dfidq_inter_acc[4][0][0] = dfdq_curr_vec_out_AX_dqPE1;
        new_dfidq_inter_acc[4][0][1] = dfdq_curr_vec_out_AX_dqPE2;
        new_dfidq_inter_acc[4][0][2] = dfdq_curr_vec_out_AX_dqPE3;
        new_dfidq_inter_acc[4][0][3] = dfdq_curr_vec_out_AX_dqPE4;
        new_dfidq_inter_acc[0][0][4] = dfdq_curr_vec_out_AX_dqPE5;
        new_dfidq_inter_acc[0][0][5] = dfdq_curr_vec_out_AX_dqPE6;
        new_dfidq_inter_acc[0][0][6] = dfdq_curr_vec_out_AX_dqPE7;

        new_dfidq_inter_acc[4][1][0] = dfdq_curr_vec_out_AY_dqPE1;
        new_dfidq_inter_acc[4][1][1] = dfdq_curr_vec_out_AY_dqPE2;
        new_dfidq_inter_acc[4][1][2] = dfdq_curr_vec_out_AY_dqPE3;
        new_dfidq_inter_acc[4][1][3] = dfdq_curr_vec_out_AY_dqPE4;
        new_dfidq_inter_acc[0][1][4] = dfdq_curr_vec_out_AY_dqPE5;
        new_dfidq_inter_acc[0][1][5] = dfdq_curr_vec_out_AY_dqPE6;
        new_dfidq_inter_acc[0][1][6] = dfdq_curr_vec_out_AY_dqPE7;

        new_dfidq_inter_acc[4][2][0] = dfdq_curr_vec_out_AZ_dqPE1;
        new_dfidq_inter_acc[4][2][1] = dfdq_curr_vec_out_AZ_dqPE2;
        new_dfidq_inter_acc[4][2][2] = dfdq_curr_vec_out_AZ_dqPE3;
        new_dfidq_inter_acc[4][2][3] = dfdq_curr_vec_out_AZ_dqPE4;
        new_dfidq_inter_acc[0][2][4] = dfdq_curr_vec_out_AZ_dqPE5;
        new_dfidq_inter_acc[0][2][5] = dfdq_curr_vec_out_AZ_dqPE6;
        new_dfidq_inter_acc[0][2][6] = dfdq_curr_vec_out_AZ_dqPE7;

        new_dfidq_inter_acc[4][3][0] = dfdq_curr_vec_out_LX_dqPE1;
        new_dfidq_inter_acc[4][3][1] = dfdq_curr_vec_out_LX_dqPE2;
        new_dfidq_inter_acc[4][3][2] = dfdq_curr_vec_out_LX_dqPE3;
        new_dfidq_inter_acc[4][3][3] = dfdq_curr_vec_out_LX_dqPE4;
        new_dfidq_inter_acc[0][3][4] = dfdq_curr_vec_out_LX_dqPE5;
        new_dfidq_inter_acc[0][3][5] = dfdq_curr_vec_out_LX_dqPE6;
        new_dfidq_inter_acc[0][3][6] = dfdq_curr_vec_out_LX_dqPE7;

        new_dfidq_inter_acc[4][4][0] = dfdq_curr_vec_out_LY_dqPE1;
        new_dfidq_inter_acc[4][4][1] = dfdq_curr_vec_out_LY_dqPE2;
        new_dfidq_inter_acc[4][4][2] = dfdq_curr_vec_out_LY_dqPE3;
        new_dfidq_inter_acc[4][4][3] = dfdq_curr_vec_out_LY_dqPE4;
        new_dfidq_inter_acc[0][4][4] = dfdq_curr_vec_out_LY_dqPE5;
        new_dfidq_inter_acc[0][4][5] = dfdq_curr_vec_out_LY_dqPE6;
        new_dfidq_inter_acc[0][4][6] = dfdq_curr_vec_out_LY_dqPE7;

        new_dfidq_inter_acc[4][5][0] = dfdq_curr_vec_out_LZ_dqPE1;
        new_dfidq_inter_acc[4][5][1] = dfdq_curr_vec_out_LZ_dqPE2;
        new_dfidq_inter_acc[4][5][2] = dfdq_curr_vec_out_LZ_dqPE3;
        new_dfidq_inter_acc[4][5][3] = dfdq_curr_vec_out_LZ_dqPE4;
        new_dfidq_inter_acc[0][5][4] = dfdq_curr_vec_out_LZ_dqPE5;
        new_dfidq_inter_acc[0][5][5] = dfdq_curr_vec_out_LZ_dqPE6;
        new_dfidq_inter_acc[0][5][6] = dfdq_curr_vec_out_LZ_dqPE7;

        // dfidqd

        new_dfidqd_inter_acc[4][0][0] = dfdqd_curr_vec_out_AX_dqdPE1;
        new_dfidqd_inter_acc[4][0][1] = dfdqd_curr_vec_out_AX_dqdPE2;
        new_dfidqd_inter_acc[4][0][2] = dfdqd_curr_vec_out_AX_dqdPE3;
        new_dfidqd_inter_acc[4][0][3] = dfdqd_curr_vec_out_AX_dqdPE4;
        new_dfidqd_inter_acc[0][0][4] = dfdqd_curr_vec_out_AX_dqdPE5;
        new_dfidqd_inter_acc[0][0][5] = dfdqd_curr_vec_out_AX_dqdPE6;
        new_dfidqd_inter_acc[0][0][6] = dfdqd_curr_vec_out_AX_dqdPE7;
        new_dfidqd_inter_acc[4][1][0] = dfdqd_curr_vec_out_AY_dqdPE1;
        new_dfidqd_inter_acc[4][1][1] = dfdqd_curr_vec_out_AY_dqdPE2;
        new_dfidqd_inter_acc[4][1][2] = dfdqd_curr_vec_out_AY_dqdPE3;
        new_dfidqd_inter_acc[4][1][3] = dfdqd_curr_vec_out_AY_dqdPE4;
        new_dfidqd_inter_acc[0][1][4] = dfdqd_curr_vec_out_AY_dqdPE5;
        new_dfidqd_inter_acc[0][1][5] = dfdqd_curr_vec_out_AY_dqdPE6;
        new_dfidqd_inter_acc[0][1][6] = dfdqd_curr_vec_out_AY_dqdPE7;
        new_dfidqd_inter_acc[4][2][0] = dfdqd_curr_vec_out_AZ_dqdPE1;
        new_dfidqd_inter_acc[4][2][1] = dfdqd_curr_vec_out_AZ_dqdPE2;
        new_dfidqd_inter_acc[4][2][2] = dfdqd_curr_vec_out_AZ_dqdPE3;
        new_dfidqd_inter_acc[4][2][3] = dfdqd_curr_vec_out_AZ_dqdPE4;
        new_dfidqd_inter_acc[0][2][4] = dfdqd_curr_vec_out_AZ_dqdPE5;
        new_dfidqd_inter_acc[0][2][5] = dfdqd_curr_vec_out_AZ_dqdPE6;
        new_dfidqd_inter_acc[0][2][6] = dfdqd_curr_vec_out_AZ_dqdPE7;
        new_dfidqd_inter_acc[4][3][0] = dfdqd_curr_vec_out_LX_dqdPE1;
        new_dfidqd_inter_acc[4][3][1] = dfdqd_curr_vec_out_LX_dqdPE2;
        new_dfidqd_inter_acc[4][3][2] = dfdqd_curr_vec_out_LX_dqdPE3;
        new_dfidqd_inter_acc[4][3][3] = dfdqd_curr_vec_out_LX_dqdPE4;
        new_dfidqd_inter_acc[0][3][4] = dfdqd_curr_vec_out_LX_dqdPE5;
        new_dfidqd_inter_acc[0][3][5] = dfdqd_curr_vec_out_LX_dqdPE6;
        new_dfidqd_inter_acc[0][3][6] = dfdqd_curr_vec_out_LX_dqdPE7;
        new_dfidqd_inter_acc[4][4][0] = dfdqd_curr_vec_out_LY_dqdPE1;
        new_dfidqd_inter_acc[4][4][1] = dfdqd_curr_vec_out_LY_dqdPE2;
        new_dfidqd_inter_acc[4][4][2] = dfdqd_curr_vec_out_LY_dqdPE3;
        new_dfidqd_inter_acc[4][4][3] = dfdqd_curr_vec_out_LY_dqdPE4;
        new_dfidqd_inter_acc[0][4][4] = dfdqd_curr_vec_out_LY_dqdPE5;
        new_dfidqd_inter_acc[0][4][5] = dfdqd_curr_vec_out_LY_dqdPE6;
        new_dfidqd_inter_acc[0][4][6] = dfdqd_curr_vec_out_LY_dqdPE7;
        new_dfidqd_inter_acc[4][5][0] = dfdqd_curr_vec_out_LZ_dqdPE1;
        new_dfidqd_inter_acc[4][5][1] = dfdqd_curr_vec_out_LZ_dqdPE2;
        new_dfidqd_inter_acc[4][5][2] = dfdqd_curr_vec_out_LZ_dqdPE3;
        new_dfidqd_inter_acc[4][5][3] = dfdqd_curr_vec_out_LZ_dqdPE4;
        new_dfidqd_inter_acc[0][5][4] = dfdqd_curr_vec_out_LZ_dqdPE5;
        new_dfidqd_inter_acc[0][5][5] = dfdqd_curr_vec_out_LZ_dqdPE6;
        new_dfidqd_inter_acc[0][5][6] = dfdqd_curr_vec_out_LZ_dqdPE7;
    end

    5: begin
        new_f_inter_acc[6][0] = f_curr_vec_out_AX_rnea;
        new_f_inter_acc[6][1] = f_curr_vec_out_AY_rnea;
        new_f_inter_acc[6][2] = f_curr_vec_out_AZ_rnea;
        new_f_inter_acc[6][3] = f_curr_vec_out_LX_rnea;
        new_f_inter_acc[6][4] = f_curr_vec_out_LY_rnea;
        new_f_inter_acc[6][5] = f_curr_vec_out_LZ_rnea;

        // dfidq

        new_dfidq_inter_acc[5][0][0] = dfdq_curr_vec_out_AX_dqPE1;
        new_dfidq_inter_acc[5][0][1] = dfdq_curr_vec_out_AX_dqPE2;
        new_dfidq_inter_acc[5][0][2] = dfdq_curr_vec_out_AX_dqPE3;
        new_dfidq_inter_acc[5][0][3] = dfdq_curr_vec_out_AX_dqPE4;
        new_dfidq_inter_acc[5][0][4] = dfdq_curr_vec_out_AX_dqPE5;
        new_dfidq_inter_acc[0][0][5] = dfdq_curr_vec_out_AX_dqPE6;
        new_dfidq_inter_acc[0][0][6] = dfdq_curr_vec_out_AX_dqPE7;

        new_dfidq_inter_acc[5][1][0] = dfdq_curr_vec_out_AY_dqPE1;
        new_dfidq_inter_acc[5][1][1] = dfdq_curr_vec_out_AY_dqPE2;
        new_dfidq_inter_acc[5][1][2] = dfdq_curr_vec_out_AY_dqPE3;
        new_dfidq_inter_acc[5][1][3] = dfdq_curr_vec_out_AY_dqPE4;
        new_dfidq_inter_acc[5][1][4] = dfdq_curr_vec_out_AY_dqPE5;
        new_dfidq_inter_acc[0][1][5] = dfdq_curr_vec_out_AY_dqPE6;
        new_dfidq_inter_acc[0][1][6] = dfdq_curr_vec_out_AY_dqPE7;

        new_dfidq_inter_acc[5][2][0] = dfdq_curr_vec_out_AZ_dqPE1;
        new_dfidq_inter_acc[5][2][1] = dfdq_curr_vec_out_AZ_dqPE2;
        new_dfidq_inter_acc[5][2][2] = dfdq_curr_vec_out_AZ_dqPE3;
        new_dfidq_inter_acc[5][2][3] = dfdq_curr_vec_out_AZ_dqPE4;
        new_dfidq_inter_acc[5][2][4] = dfdq_curr_vec_out_AZ_dqPE5;
        new_dfidq_inter_acc[0][2][5] = dfdq_curr_vec_out_AZ_dqPE6;
        new_dfidq_inter_acc[0][2][6] = dfdq_curr_vec_out_AZ_dqPE7;

        new_dfidq_inter_acc[5][3][0] = dfdq_curr_vec_out_LX_dqPE1;
        new_dfidq_inter_acc[5][3][1] = dfdq_curr_vec_out_LX_dqPE2;
        new_dfidq_inter_acc[5][3][2] = dfdq_curr_vec_out_LX_dqPE3;
        new_dfidq_inter_acc[5][3][3] = dfdq_curr_vec_out_LX_dqPE4;
        new_dfidq_inter_acc[5][3][4] = dfdq_curr_vec_out_LX_dqPE5;
        new_dfidq_inter_acc[0][3][5] = dfdq_curr_vec_out_LX_dqPE6;
        new_dfidq_inter_acc[0][3][6] = dfdq_curr_vec_out_LX_dqPE7;

        new_dfidq_inter_acc[5][4][0] = dfdq_curr_vec_out_LY_dqPE1;
        new_dfidq_inter_acc[5][4][1] = dfdq_curr_vec_out_LY_dqPE2;
        new_dfidq_inter_acc[5][4][2] = dfdq_curr_vec_out_LY_dqPE3;
        new_dfidq_inter_acc[5][4][3] = dfdq_curr_vec_out_LY_dqPE4;
        new_dfidq_inter_acc[5][4][4] = dfdq_curr_vec_out_LY_dqPE5;
        new_dfidq_inter_acc[0][4][5] = dfdq_curr_vec_out_LY_dqPE6;
        new_dfidq_inter_acc[0][4][6] = dfdq_curr_vec_out_LY_dqPE7;

        new_dfidq_inter_acc[5][5][0] = dfdq_curr_vec_out_LZ_dqPE1;
        new_dfidq_inter_acc[5][5][1] = dfdq_curr_vec_out_LZ_dqPE2;
        new_dfidq_inter_acc[5][5][2] = dfdq_curr_vec_out_LZ_dqPE3;
        new_dfidq_inter_acc[5][5][3] = dfdq_curr_vec_out_LZ_dqPE4;
        new_dfidq_inter_acc[5][5][4] = dfdq_curr_vec_out_LZ_dqPE5;
        new_dfidq_inter_acc[0][5][5] = dfdq_curr_vec_out_LZ_dqPE6;
        new_dfidq_inter_acc[0][5][6] = dfdq_curr_vec_out_LZ_dqPE7;

        // dfidqd

        new_dfidqd_inter_acc[5][0][0] = dfdqd_curr_vec_out_AX_dqdPE1;
        new_dfidqd_inter_acc[5][0][1] = dfdqd_curr_vec_out_AX_dqdPE2;
        new_dfidqd_inter_acc[5][0][2] = dfdqd_curr_vec_out_AX_dqdPE3;
        new_dfidqd_inter_acc[5][0][3] = dfdqd_curr_vec_out_AX_dqdPE4;
        new_dfidqd_inter_acc[5][0][4] = dfdqd_curr_vec_out_AX_dqdPE5;
        new_dfidqd_inter_acc[0][0][5] = dfdqd_curr_vec_out_AX_dqdPE6;
        new_dfidqd_inter_acc[0][0][6] = dfdqd_curr_vec_out_AX_dqdPE7;
        new_dfidqd_inter_acc[5][1][0] = dfdqd_curr_vec_out_AY_dqdPE1;
        new_dfidqd_inter_acc[5][1][1] = dfdqd_curr_vec_out_AY_dqdPE2;
        new_dfidqd_inter_acc[5][1][2] = dfdqd_curr_vec_out_AY_dqdPE3;
        new_dfidqd_inter_acc[5][1][3] = dfdqd_curr_vec_out_AY_dqdPE4;
        new_dfidqd_inter_acc[5][1][4] = dfdqd_curr_vec_out_AY_dqdPE5;
        new_dfidqd_inter_acc[0][1][5] = dfdqd_curr_vec_out_AY_dqdPE6;
        new_dfidqd_inter_acc[0][1][6] = dfdqd_curr_vec_out_AY_dqdPE7;
        new_dfidqd_inter_acc[5][2][0] = dfdqd_curr_vec_out_AZ_dqdPE1;
        new_dfidqd_inter_acc[5][2][1] = dfdqd_curr_vec_out_AZ_dqdPE2;
        new_dfidqd_inter_acc[5][2][2] = dfdqd_curr_vec_out_AZ_dqdPE3;
        new_dfidqd_inter_acc[5][2][3] = dfdqd_curr_vec_out_AZ_dqdPE4;
        new_dfidqd_inter_acc[5][2][4] = dfdqd_curr_vec_out_AZ_dqdPE5;
        new_dfidqd_inter_acc[0][2][5] = dfdqd_curr_vec_out_AZ_dqdPE6;
        new_dfidqd_inter_acc[0][2][6] = dfdqd_curr_vec_out_AZ_dqdPE7;
        new_dfidqd_inter_acc[5][3][0] = dfdqd_curr_vec_out_LX_dqdPE1;
        new_dfidqd_inter_acc[5][3][1] = dfdqd_curr_vec_out_LX_dqdPE2;
        new_dfidqd_inter_acc[5][3][2] = dfdqd_curr_vec_out_LX_dqdPE3;
        new_dfidqd_inter_acc[5][3][3] = dfdqd_curr_vec_out_LX_dqdPE4;
        new_dfidqd_inter_acc[5][3][4] = dfdqd_curr_vec_out_LX_dqdPE5;
        new_dfidqd_inter_acc[0][3][5] = dfdqd_curr_vec_out_LX_dqdPE6;
        new_dfidqd_inter_acc[0][3][6] = dfdqd_curr_vec_out_LX_dqdPE7;
        new_dfidqd_inter_acc[5][4][0] = dfdqd_curr_vec_out_LY_dqdPE1;
        new_dfidqd_inter_acc[5][4][1] = dfdqd_curr_vec_out_LY_dqdPE2;
        new_dfidqd_inter_acc[5][4][2] = dfdqd_curr_vec_out_LY_dqdPE3;
        new_dfidqd_inter_acc[5][4][3] = dfdqd_curr_vec_out_LY_dqdPE4;
        new_dfidqd_inter_acc[5][4][4] = dfdqd_curr_vec_out_LY_dqdPE5;
        new_dfidqd_inter_acc[0][4][5] = dfdqd_curr_vec_out_LY_dqdPE6;
        new_dfidqd_inter_acc[0][4][6] = dfdqd_curr_vec_out_LY_dqdPE7;
        new_dfidqd_inter_acc[5][5][0] = dfdqd_curr_vec_out_LZ_dqdPE1;
        new_dfidqd_inter_acc[5][5][1] = dfdqd_curr_vec_out_LZ_dqdPE2;
        new_dfidqd_inter_acc[5][5][2] = dfdqd_curr_vec_out_LZ_dqdPE3;
        new_dfidqd_inter_acc[5][5][3] = dfdqd_curr_vec_out_LZ_dqdPE4;
        new_dfidqd_inter_acc[5][5][4] = dfdqd_curr_vec_out_LZ_dqdPE5;
        new_dfidqd_inter_acc[0][5][5] = dfdqd_curr_vec_out_LZ_dqdPE6;
        new_dfidqd_inter_acc[0][5][6] = dfdqd_curr_vec_out_LZ_dqdPE7;
    end

    6: begin
        new_f_inter_acc[7][0] = f_curr_vec_out_AX_rnea;
        new_f_inter_acc[7][1] = f_curr_vec_out_AY_rnea;
        new_f_inter_acc[7][2] = f_curr_vec_out_AZ_rnea;
        new_f_inter_acc[7][3] = f_curr_vec_out_LX_rnea;
        new_f_inter_acc[7][4] = f_curr_vec_out_LY_rnea;
        new_f_inter_acc[7][5] = f_curr_vec_out_LZ_rnea;

        // dfidq

        new_dfidq_inter_acc[6][0][0] = dfdq_curr_vec_out_AX_dqPE1;
        new_dfidq_inter_acc[6][0][1] = dfdq_curr_vec_out_AX_dqPE2;
        new_dfidq_inter_acc[6][0][2] = dfdq_curr_vec_out_AX_dqPE3;
        new_dfidq_inter_acc[6][0][3] = dfdq_curr_vec_out_AX_dqPE4;
        new_dfidq_inter_acc[6][0][4] = dfdq_curr_vec_out_AX_dqPE5;
        new_dfidq_inter_acc[6][0][5] = dfdq_curr_vec_out_AX_dqPE6;
        new_dfidq_inter_acc[0][0][6] = dfdq_curr_vec_out_AX_dqPE7;

        new_dfidq_inter_acc[6][1][0] = dfdq_curr_vec_out_AY_dqPE1;
        new_dfidq_inter_acc[6][1][1] = dfdq_curr_vec_out_AY_dqPE2;
        new_dfidq_inter_acc[6][1][2] = dfdq_curr_vec_out_AY_dqPE3;
        new_dfidq_inter_acc[6][1][3] = dfdq_curr_vec_out_AY_dqPE4;
        new_dfidq_inter_acc[6][1][4] = dfdq_curr_vec_out_AY_dqPE5;
        new_dfidq_inter_acc[6][1][5] = dfdq_curr_vec_out_AY_dqPE6;
        new_dfidq_inter_acc[0][1][6] = dfdq_curr_vec_out_AY_dqPE7;

        new_dfidq_inter_acc[6][2][0] = dfdq_curr_vec_out_AZ_dqPE1;
        new_dfidq_inter_acc[6][2][1] = dfdq_curr_vec_out_AZ_dqPE2;
        new_dfidq_inter_acc[6][2][2] = dfdq_curr_vec_out_AZ_dqPE3;
        new_dfidq_inter_acc[6][2][3] = dfdq_curr_vec_out_AZ_dqPE4;
        new_dfidq_inter_acc[6][2][4] = dfdq_curr_vec_out_AZ_dqPE5;
        new_dfidq_inter_acc[6][2][5] = dfdq_curr_vec_out_AZ_dqPE6;
        new_dfidq_inter_acc[0][2][6] = dfdq_curr_vec_out_AZ_dqPE7;

        new_dfidq_inter_acc[6][3][0] = dfdq_curr_vec_out_LX_dqPE1;
        new_dfidq_inter_acc[6][3][1] = dfdq_curr_vec_out_LX_dqPE2;
        new_dfidq_inter_acc[6][3][2] = dfdq_curr_vec_out_LX_dqPE3;
        new_dfidq_inter_acc[6][3][3] = dfdq_curr_vec_out_LX_dqPE4;
        new_dfidq_inter_acc[6][3][4] = dfdq_curr_vec_out_LX_dqPE5;
        new_dfidq_inter_acc[6][3][5] = dfdq_curr_vec_out_LX_dqPE6;
        new_dfidq_inter_acc[0][3][6] = dfdq_curr_vec_out_LX_dqPE7;

        new_dfidq_inter_acc[6][4][0] = dfdq_curr_vec_out_LY_dqPE1;
        new_dfidq_inter_acc[6][4][1] = dfdq_curr_vec_out_LY_dqPE2;
        new_dfidq_inter_acc[6][4][2] = dfdq_curr_vec_out_LY_dqPE3;
        new_dfidq_inter_acc[6][4][3] = dfdq_curr_vec_out_LY_dqPE4;
        new_dfidq_inter_acc[6][4][4] = dfdq_curr_vec_out_LY_dqPE5;
        new_dfidq_inter_acc[6][4][5] = dfdq_curr_vec_out_LY_dqPE6;
        new_dfidq_inter_acc[0][4][6] = dfdq_curr_vec_out_LY_dqPE7;

        new_dfidq_inter_acc[6][5][0] = dfdq_curr_vec_out_LZ_dqPE1;
        new_dfidq_inter_acc[6][5][1] = dfdq_curr_vec_out_LZ_dqPE2;
        new_dfidq_inter_acc[6][5][2] = dfdq_curr_vec_out_LZ_dqPE3;
        new_dfidq_inter_acc[6][5][3] = dfdq_curr_vec_out_LZ_dqPE4;
        new_dfidq_inter_acc[6][5][4] = dfdq_curr_vec_out_LZ_dqPE5;
        new_dfidq_inter_acc[6][5][5] = dfdq_curr_vec_out_LZ_dqPE6;
        new_dfidq_inter_acc[0][5][6] = dfdq_curr_vec_out_LZ_dqPE7;

        // dfidqd

        new_dfidqd_inter_acc[6][0][0] = dfdqd_curr_vec_out_AX_dqdPE1;
        new_dfidqd_inter_acc[6][0][1] = dfdqd_curr_vec_out_AX_dqdPE2;
        new_dfidqd_inter_acc[6][0][2] = dfdqd_curr_vec_out_AX_dqdPE3;
        new_dfidqd_inter_acc[6][0][3] = dfdqd_curr_vec_out_AX_dqdPE4;
        new_dfidqd_inter_acc[6][0][4] = dfdqd_curr_vec_out_AX_dqdPE5;
        new_dfidqd_inter_acc[6][0][5] = dfdqd_curr_vec_out_AX_dqdPE6;
        new_dfidqd_inter_acc[0][0][6] = dfdqd_curr_vec_out_AX_dqdPE7;
        new_dfidqd_inter_acc[6][1][0] = dfdqd_curr_vec_out_AY_dqdPE1;
        new_dfidqd_inter_acc[6][1][1] = dfdqd_curr_vec_out_AY_dqdPE2;
        new_dfidqd_inter_acc[6][1][2] = dfdqd_curr_vec_out_AY_dqdPE3;
        new_dfidqd_inter_acc[6][1][3] = dfdqd_curr_vec_out_AY_dqdPE4;
        new_dfidqd_inter_acc[6][1][4] = dfdqd_curr_vec_out_AY_dqdPE5;
        new_dfidqd_inter_acc[6][1][5] = dfdqd_curr_vec_out_AY_dqdPE6;
        new_dfidqd_inter_acc[0][1][6] = dfdqd_curr_vec_out_AY_dqdPE7;
        new_dfidqd_inter_acc[6][2][0] = dfdqd_curr_vec_out_AZ_dqdPE1;
        new_dfidqd_inter_acc[6][2][1] = dfdqd_curr_vec_out_AZ_dqdPE2;
        new_dfidqd_inter_acc[6][2][2] = dfdqd_curr_vec_out_AZ_dqdPE3;
        new_dfidqd_inter_acc[6][2][3] = dfdqd_curr_vec_out_AZ_dqdPE4;
        new_dfidqd_inter_acc[6][2][4] = dfdqd_curr_vec_out_AZ_dqdPE5;
        new_dfidqd_inter_acc[6][2][5] = dfdqd_curr_vec_out_AZ_dqdPE6;
        new_dfidqd_inter_acc[0][2][6] = dfdqd_curr_vec_out_AZ_dqdPE7;
        new_dfidqd_inter_acc[6][3][0] = dfdqd_curr_vec_out_LX_dqdPE1;
        new_dfidqd_inter_acc[6][3][1] = dfdqd_curr_vec_out_LX_dqdPE2;
        new_dfidqd_inter_acc[6][3][2] = dfdqd_curr_vec_out_LX_dqdPE3;
        new_dfidqd_inter_acc[6][3][3] = dfdqd_curr_vec_out_LX_dqdPE4;
        new_dfidqd_inter_acc[6][3][4] = dfdqd_curr_vec_out_LX_dqdPE5;
        new_dfidqd_inter_acc[6][3][5] = dfdqd_curr_vec_out_LX_dqdPE6;
        new_dfidqd_inter_acc[0][3][6] = dfdqd_curr_vec_out_LX_dqdPE7;
        new_dfidqd_inter_acc[6][4][0] = dfdqd_curr_vec_out_LY_dqdPE1;
        new_dfidqd_inter_acc[6][4][1] = dfdqd_curr_vec_out_LY_dqdPE2;
        new_dfidqd_inter_acc[6][4][2] = dfdqd_curr_vec_out_LY_dqdPE3;
        new_dfidqd_inter_acc[6][4][3] = dfdqd_curr_vec_out_LY_dqdPE4;
        new_dfidqd_inter_acc[6][4][4] = dfdqd_curr_vec_out_LY_dqdPE5;
        new_dfidqd_inter_acc[6][4][5] = dfdqd_curr_vec_out_LY_dqdPE6;
        new_dfidqd_inter_acc[0][4][6] = dfdqd_curr_vec_out_LY_dqdPE7;
        new_dfidqd_inter_acc[6][5][0] = dfdqd_curr_vec_out_LZ_dqdPE1;
        new_dfidqd_inter_acc[6][5][1] = dfdqd_curr_vec_out_LZ_dqdPE2;
        new_dfidqd_inter_acc[6][5][2] = dfdqd_curr_vec_out_LZ_dqdPE3;
        new_dfidqd_inter_acc[6][5][3] = dfdqd_curr_vec_out_LZ_dqdPE4;
        new_dfidqd_inter_acc[6][5][4] = dfdqd_curr_vec_out_LZ_dqdPE5;
        new_dfidqd_inter_acc[6][5][5] = dfdqd_curr_vec_out_LZ_dqdPE6;
        new_dfidqd_inter_acc[0][5][6] = dfdqd_curr_vec_out_LZ_dqdPE7;
    end

    7: begin
        new_f_inter_acc[0][0] = f_curr_vec_out_AX_rnea;
        new_f_inter_acc[0][1] = f_curr_vec_out_AY_rnea;
        new_f_inter_acc[0][2] = f_curr_vec_out_AZ_rnea;
        new_f_inter_acc[0][3] = f_curr_vec_out_LX_rnea;
        new_f_inter_acc[0][4] = f_curr_vec_out_LY_rnea;
        new_f_inter_acc[0][5] = f_curr_vec_out_LZ_rnea;

        // dfidq

        new_dfidq_inter_acc[7][0][0] = dfdq_curr_vec_out_AX_dqPE1;
        new_dfidq_inter_acc[7][0][1] = dfdq_curr_vec_out_AX_dqPE2;
        new_dfidq_inter_acc[7][0][2] = dfdq_curr_vec_out_AX_dqPE3;
        new_dfidq_inter_acc[7][0][3] = dfdq_curr_vec_out_AX_dqPE4;
        new_dfidq_inter_acc[7][0][4] = dfdq_curr_vec_out_AX_dqPE5;
        new_dfidq_inter_acc[7][0][5] = dfdq_curr_vec_out_AX_dqPE6;
        new_dfidq_inter_acc[7][0][6] = dfdq_curr_vec_out_AX_dqPE7;

        new_dfidq_inter_acc[7][1][0] = dfdq_curr_vec_out_AY_dqPE1;
        new_dfidq_inter_acc[7][1][1] = dfdq_curr_vec_out_AY_dqPE2;
        new_dfidq_inter_acc[7][1][2] = dfdq_curr_vec_out_AY_dqPE3;
        new_dfidq_inter_acc[7][1][3] = dfdq_curr_vec_out_AY_dqPE4;
        new_dfidq_inter_acc[7][1][4] = dfdq_curr_vec_out_AY_dqPE5;
        new_dfidq_inter_acc[7][1][5] = dfdq_curr_vec_out_AY_dqPE6;
        new_dfidq_inter_acc[7][1][6] = dfdq_curr_vec_out_AY_dqPE7;

        new_dfidq_inter_acc[7][2][0] = dfdq_curr_vec_out_AZ_dqPE1;
        new_dfidq_inter_acc[7][2][1] = dfdq_curr_vec_out_AZ_dqPE2;
        new_dfidq_inter_acc[7][2][2] = dfdq_curr_vec_out_AZ_dqPE3;
        new_dfidq_inter_acc[7][2][3] = dfdq_curr_vec_out_AZ_dqPE4;
        new_dfidq_inter_acc[7][2][4] = dfdq_curr_vec_out_AZ_dqPE5;
        new_dfidq_inter_acc[7][2][5] = dfdq_curr_vec_out_AZ_dqPE6;
        new_dfidq_inter_acc[7][2][6] = dfdq_curr_vec_out_AZ_dqPE7;

        new_dfidq_inter_acc[7][3][0] = dfdq_curr_vec_out_LX_dqPE1;
        new_dfidq_inter_acc[7][3][1] = dfdq_curr_vec_out_LX_dqPE2;
        new_dfidq_inter_acc[7][3][2] = dfdq_curr_vec_out_LX_dqPE3;
        new_dfidq_inter_acc[7][3][3] = dfdq_curr_vec_out_LX_dqPE4;
        new_dfidq_inter_acc[7][3][4] = dfdq_curr_vec_out_LX_dqPE5;
        new_dfidq_inter_acc[7][3][5] = dfdq_curr_vec_out_LX_dqPE6;
        new_dfidq_inter_acc[7][3][6] = dfdq_curr_vec_out_LX_dqPE7;

        new_dfidq_inter_acc[7][4][0] = dfdq_curr_vec_out_LY_dqPE1;
        new_dfidq_inter_acc[7][4][1] = dfdq_curr_vec_out_LY_dqPE2;
        new_dfidq_inter_acc[7][4][2] = dfdq_curr_vec_out_LY_dqPE3;
        new_dfidq_inter_acc[7][4][3] = dfdq_curr_vec_out_LY_dqPE4;
        new_dfidq_inter_acc[7][4][4] = dfdq_curr_vec_out_LY_dqPE5;
        new_dfidq_inter_acc[7][4][5] = dfdq_curr_vec_out_LY_dqPE6;
        new_dfidq_inter_acc[7][4][6] = dfdq_curr_vec_out_LY_dqPE7;

        new_dfidq_inter_acc[7][5][0] = dfdq_curr_vec_out_LZ_dqPE1;
        new_dfidq_inter_acc[7][5][1] = dfdq_curr_vec_out_LZ_dqPE2;
        new_dfidq_inter_acc[7][5][2] = dfdq_curr_vec_out_LZ_dqPE3;
        new_dfidq_inter_acc[7][5][3] = dfdq_curr_vec_out_LZ_dqPE4;
        new_dfidq_inter_acc[7][5][4] = dfdq_curr_vec_out_LZ_dqPE5;
        new_dfidq_inter_acc[7][5][5] = dfdq_curr_vec_out_LZ_dqPE6;
        new_dfidq_inter_acc[7][5][6] = dfdq_curr_vec_out_LZ_dqPE7;

        // dfidqd

        new_dfidqd_inter_acc[7][0][0] = dfdqd_curr_vec_out_AX_dqdPE1;
        new_dfidqd_inter_acc[7][0][1] = dfdqd_curr_vec_out_AX_dqdPE2;
        new_dfidqd_inter_acc[7][0][2] = dfdqd_curr_vec_out_AX_dqdPE3;
        new_dfidqd_inter_acc[7][0][3] = dfdqd_curr_vec_out_AX_dqdPE4;
        new_dfidqd_inter_acc[7][0][4] = dfdqd_curr_vec_out_AX_dqdPE5;
        new_dfidqd_inter_acc[7][0][5] = dfdqd_curr_vec_out_AX_dqdPE6;
        new_dfidqd_inter_acc[7][0][6] = dfdqd_curr_vec_out_AX_dqdPE7;
        new_dfidqd_inter_acc[7][1][0] = dfdqd_curr_vec_out_AY_dqdPE1;
        new_dfidqd_inter_acc[7][1][1] = dfdqd_curr_vec_out_AY_dqdPE2;
        new_dfidqd_inter_acc[7][1][2] = dfdqd_curr_vec_out_AY_dqdPE3;
        new_dfidqd_inter_acc[7][1][3] = dfdqd_curr_vec_out_AY_dqdPE4;
        new_dfidqd_inter_acc[7][1][4] = dfdqd_curr_vec_out_AY_dqdPE5;
        new_dfidqd_inter_acc[7][1][5] = dfdqd_curr_vec_out_AY_dqdPE6;
        new_dfidqd_inter_acc[7][1][6] = dfdqd_curr_vec_out_AY_dqdPE7;
        new_dfidqd_inter_acc[7][2][0] = dfdqd_curr_vec_out_AZ_dqdPE1;
        new_dfidqd_inter_acc[7][2][1] = dfdqd_curr_vec_out_AZ_dqdPE2;
        new_dfidqd_inter_acc[7][2][2] = dfdqd_curr_vec_out_AZ_dqdPE3;
        new_dfidqd_inter_acc[7][2][3] = dfdqd_curr_vec_out_AZ_dqdPE4;
        new_dfidqd_inter_acc[7][2][4] = dfdqd_curr_vec_out_AZ_dqdPE5;
        new_dfidqd_inter_acc[7][2][5] = dfdqd_curr_vec_out_AZ_dqdPE6;
        new_dfidqd_inter_acc[7][2][6] = dfdqd_curr_vec_out_AZ_dqdPE7;
        new_dfidqd_inter_acc[7][3][0] = dfdqd_curr_vec_out_LX_dqdPE1;
        new_dfidqd_inter_acc[7][3][1] = dfdqd_curr_vec_out_LX_dqdPE2;
        new_dfidqd_inter_acc[7][3][2] = dfdqd_curr_vec_out_LX_dqdPE3;
        new_dfidqd_inter_acc[7][3][3] = dfdqd_curr_vec_out_LX_dqdPE4;
        new_dfidqd_inter_acc[7][3][4] = dfdqd_curr_vec_out_LX_dqdPE5;
        new_dfidqd_inter_acc[7][3][5] = dfdqd_curr_vec_out_LX_dqdPE6;
        new_dfidqd_inter_acc[7][3][6] = dfdqd_curr_vec_out_LX_dqdPE7;
        new_dfidqd_inter_acc[7][4][0] = dfdqd_curr_vec_out_LY_dqdPE1;
        new_dfidqd_inter_acc[7][4][1] = dfdqd_curr_vec_out_LY_dqdPE2;
        new_dfidqd_inter_acc[7][4][2] = dfdqd_curr_vec_out_LY_dqdPE3;
        new_dfidqd_inter_acc[7][4][3] = dfdqd_curr_vec_out_LY_dqdPE4;
        new_dfidqd_inter_acc[7][4][4] = dfdqd_curr_vec_out_LY_dqdPE5;
        new_dfidqd_inter_acc[7][4][5] = dfdqd_curr_vec_out_LY_dqdPE6;
        new_dfidqd_inter_acc[7][4][6] = dfdqd_curr_vec_out_LY_dqdPE7;
        new_dfidqd_inter_acc[7][5][0] = dfdqd_curr_vec_out_LZ_dqdPE1;
        new_dfidqd_inter_acc[7][5][1] = dfdqd_curr_vec_out_LZ_dqdPE2;
        new_dfidqd_inter_acc[7][5][2] = dfdqd_curr_vec_out_LZ_dqdPE3;
        new_dfidqd_inter_acc[7][5][3] = dfdqd_curr_vec_out_LZ_dqdPE4;
        new_dfidqd_inter_acc[7][5][4] = dfdqd_curr_vec_out_LZ_dqdPE5;
        new_dfidqd_inter_acc[7][5][5] = dfdqd_curr_vec_out_LZ_dqdPE6;
        new_dfidqd_inter_acc[7][5][6] = dfdqd_curr_vec_out_LZ_dqdPE7;
    end

endcase
