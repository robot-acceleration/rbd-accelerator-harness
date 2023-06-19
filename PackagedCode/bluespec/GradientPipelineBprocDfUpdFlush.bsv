// prevs for each PE
if (link_out_curr_PE != 0) begin
    // NOP shouldn't clobber reg
    df_upd_prev[i] <= df_upd_PE;
end
