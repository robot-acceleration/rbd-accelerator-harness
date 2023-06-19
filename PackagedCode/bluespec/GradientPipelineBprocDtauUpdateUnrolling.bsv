if (idx_backward_stream == 0) begin
end
else if (idx_backward_stream == 1) begin
    new_dtaudq[6][0] = dtau_curr_out_dqPE1;
    new_dtaudqd[6][0] = dtau_curr_out_dqdPE1;
    new_dtaudq[6][1] = dtau_curr_out_dqPE2;
    new_dtaudqd[6][1] = dtau_curr_out_dqdPE2;
    new_dtaudq[6][2] = dtau_curr_out_dqPE3;
    new_dtaudqd[6][2] = dtau_curr_out_dqdPE3;
    new_dtaudq[6][3] = dtau_curr_out_dqPE4;
    new_dtaudqd[6][3] = dtau_curr_out_dqdPE4;
    new_dtaudq[6][4] = dtau_curr_out_dqPE5;
    new_dtaudqd[6][4] = dtau_curr_out_dqdPE5;
    new_dtaudq[6][5] = dtau_curr_out_dqPE6;
    new_dtaudqd[6][5] = dtau_curr_out_dqdPE6;
    new_dtaudq[6][6] = dtau_curr_out_dqPE7;
    new_dtaudqd[6][6] = dtau_curr_out_dqdPE7;
end
else if (idx_backward_stream == 2) begin
    new_dtaudq[5][0] = dtau_curr_out_dqPE1;
    new_dtaudqd[5][0] = dtau_curr_out_dqdPE1;
    new_dtaudq[5][1] = dtau_curr_out_dqPE2;
    new_dtaudqd[5][1] = dtau_curr_out_dqdPE2;
    new_dtaudq[5][2] = dtau_curr_out_dqPE3;
    new_dtaudqd[5][2] = dtau_curr_out_dqdPE3;
    new_dtaudq[5][3] = dtau_curr_out_dqPE4;
    new_dtaudqd[5][3] = dtau_curr_out_dqdPE4;
    new_dtaudq[5][4] = dtau_curr_out_dqPE5;
    new_dtaudqd[5][4] = dtau_curr_out_dqdPE5;
    new_dtaudq[5][5] = dtau_curr_out_dqPE6;
    new_dtaudqd[5][5] = dtau_curr_out_dqdPE6;
    new_dtaudq[5][6] = dtau_curr_out_dqPE7;
    new_dtaudqd[5][6] = dtau_curr_out_dqdPE7;
end
else if (idx_backward_stream == 3) begin
    new_dtaudq[4][0] = dtau_curr_out_dqPE1;
    new_dtaudqd[4][0] = dtau_curr_out_dqdPE1;
    new_dtaudq[4][1] = dtau_curr_out_dqPE2;
    new_dtaudqd[4][1] = dtau_curr_out_dqdPE2;
    new_dtaudq[4][2] = dtau_curr_out_dqPE3;
    new_dtaudqd[4][2] = dtau_curr_out_dqdPE3;
    new_dtaudq[4][3] = dtau_curr_out_dqPE4;
    new_dtaudqd[4][3] = dtau_curr_out_dqdPE4;
    new_dtaudq[4][4] = dtau_curr_out_dqPE5;
    new_dtaudqd[4][4] = dtau_curr_out_dqdPE5;
    new_dtaudq[4][5] = dtau_curr_out_dqPE6;
    new_dtaudqd[4][5] = dtau_curr_out_dqdPE6;
    new_dtaudq[4][6] = dtau_curr_out_dqPE7;
    new_dtaudqd[4][6] = dtau_curr_out_dqdPE7;
end
else if (idx_backward_stream == 4) begin
    new_dtaudq[3][0] = dtau_curr_out_dqPE1;
    new_dtaudqd[3][0] = dtau_curr_out_dqdPE1;
    new_dtaudq[3][1] = dtau_curr_out_dqPE2;
    new_dtaudqd[3][1] = dtau_curr_out_dqdPE2;
    new_dtaudq[3][2] = dtau_curr_out_dqPE3;
    new_dtaudqd[3][2] = dtau_curr_out_dqdPE3;
    new_dtaudq[3][3] = dtau_curr_out_dqPE4;
    new_dtaudqd[3][3] = dtau_curr_out_dqdPE4;
    new_dtaudq[3][4] = dtau_curr_out_dqPE5;
    new_dtaudqd[3][4] = dtau_curr_out_dqdPE5;
    new_dtaudq[3][5] = dtau_curr_out_dqPE6;
    new_dtaudqd[3][5] = dtau_curr_out_dqdPE6;
    new_dtaudq[3][6] = dtau_curr_out_dqPE7;
    new_dtaudqd[3][6] = dtau_curr_out_dqdPE7;
end
else if (idx_backward_stream == 5) begin
    new_dtaudq[2][0] = dtau_curr_out_dqPE1;
    new_dtaudqd[2][0] = dtau_curr_out_dqdPE1;
    new_dtaudq[2][1] = dtau_curr_out_dqPE2;
    new_dtaudqd[2][1] = dtau_curr_out_dqdPE2;
    new_dtaudq[2][2] = dtau_curr_out_dqPE3;
    new_dtaudqd[2][2] = dtau_curr_out_dqdPE3;
    new_dtaudq[2][3] = dtau_curr_out_dqPE4;
    new_dtaudqd[2][3] = dtau_curr_out_dqdPE4;
    new_dtaudq[2][4] = dtau_curr_out_dqPE5;
    new_dtaudqd[2][4] = dtau_curr_out_dqdPE5;
    new_dtaudq[2][5] = dtau_curr_out_dqPE6;
    new_dtaudqd[2][5] = dtau_curr_out_dqdPE6;
    new_dtaudq[2][6] = dtau_curr_out_dqPE7;
    new_dtaudqd[2][6] = dtau_curr_out_dqdPE7;
end
else if (idx_backward_stream == 6) begin
    new_dtaudq[1][0] = dtau_curr_out_dqPE1;
    new_dtaudqd[1][0] = dtau_curr_out_dqdPE1;
    new_dtaudq[1][1] = dtau_curr_out_dqPE2;
    new_dtaudqd[1][1] = dtau_curr_out_dqdPE2;
    new_dtaudq[1][2] = dtau_curr_out_dqPE3;
    new_dtaudqd[1][2] = dtau_curr_out_dqdPE3;
    new_dtaudq[1][3] = dtau_curr_out_dqPE4;
    new_dtaudqd[1][3] = dtau_curr_out_dqdPE4;
    new_dtaudq[1][4] = dtau_curr_out_dqPE5;
    new_dtaudqd[1][4] = dtau_curr_out_dqdPE5;
    new_dtaudq[1][5] = dtau_curr_out_dqPE6;
    new_dtaudqd[1][5] = dtau_curr_out_dqdPE6;
    new_dtaudq[1][6] = dtau_curr_out_dqPE7;
    new_dtaudqd[1][6] = dtau_curr_out_dqdPE7;
end
else if (idx_backward_stream == 7) begin
    new_dtaudq[0][0] = dtau_curr_out_dqPE1;
    new_dtaudqd[0][0] = dtau_curr_out_dqdPE1;
    new_dtaudq[0][1] = dtau_curr_out_dqPE2;
    new_dtaudqd[0][1] = dtau_curr_out_dqdPE2;
    new_dtaudq[0][2] = dtau_curr_out_dqPE3;
    new_dtaudqd[0][2] = dtau_curr_out_dqdPE3;
    new_dtaudq[0][3] = dtau_curr_out_dqPE4;
    new_dtaudqd[0][3] = dtau_curr_out_dqdPE4;
    new_dtaudq[0][4] = dtau_curr_out_dqPE5;
    new_dtaudqd[0][4] = dtau_curr_out_dqdPE5;
    new_dtaudq[0][5] = dtau_curr_out_dqPE6;
    new_dtaudqd[0][5] = dtau_curr_out_dqdPE6;
    new_dtaudq[0][6] = dtau_curr_out_dqPE7;
    new_dtaudqd[0][6] = dtau_curr_out_dqdPE7;
end
