source board.tcl
source $connectaldir/scripts/connectal-synth-ip.tcl

connectal_synth_ip floating_point 7.1 fp_convert [list CONFIG.Operation_Type {Float_to_fixed} CONFIG.Result_Precision_Type {Custom} CONFIG.C_Result_Exponent_Width {16} CONFIG.C_Result_Fraction_Width {16} CONFIG.Has_ACLKEN {false} CONFIG.Has_ARESETn {true} CONFIG.A_Precision_Type {Single} CONFIG.C_A_Exponent_Width {8} CONFIG.C_A_Fraction_Width {24} CONFIG.C_Mult_Usage {No_Usage} CONFIG.C_Latency {7} CONFIG.C_Rate {1}] 

connectal_synth_ip floating_point 7.1 fix_float [list CONFIG.Operation_Type {Fixed_to_float} CONFIG.A_Precision_Type {Custom} CONFIG.C_A_Exponent_Width {16} CONFIG.C_A_Fraction_Width {16} CONFIG.Has_ARESETn {true} CONFIG.Result_Precision_Type {Single} CONFIG.C_Result_Exponent_Width {8} CONFIG.C_Result_Fraction_Width {24} CONFIG.C_Accum_Msb {32} CONFIG.C_Accum_Lsb {-31} CONFIG.C_Accum_Input_Msb {32} CONFIG.C_Mult_Usage {No_Usage} CONFIG.C_Latency {7} CONFIG.C_Rate {1}]

