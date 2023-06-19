# inputs_fpRow
#
# Format the Inputs for fprow.v

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra
using FixedPointNumbers
using Test
include("../../../type_generic/dynamics/helpers_iiwa.jl")
include("fpRow.jl") # fpRow

#-------------------------------------------------------------------------------
# Data Type
#-------------------------------------------------------------------------------
CUSTOM_TYPE = Float64 ###Fixed{Int32,24} # data type

#-------------------------------------------------------------------------------
# Set Constants
#-------------------------------------------------------------------------------
X,Y,Z,AX,AY,AZ,LX,LY,LZ,g = initConstants(CUSTOM_TYPE)

#-------------------------------------------------------------------------------
# Fixed-Point Parameters
#-------------------------------------------------------------------------------
WIDTH = 32
DECIMAL_BITS = 16

#-------------------------------------------------------------------------------
# Define Test Function
#-------------------------------------------------------------------------------
function fpRowTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
   #----------------------------------------------------------------------------
   # Inputs and Expected Outputs
   #----------------------------------------------------------------------------
   # inputs
   qd = [0.999905, 0.251662, 0.986666, 0.555751, 0.437108, 0.424718, 0.773223]
   tXlist = [[0.956134 0.292928 0.0 0.0 0.0 0.0; -0.292928 0.956134 0.0 0.0 0.0 0.0; 0.0 0.0 1.0 0.0 0.0 0.0; -0.0461362 0.150591 0.0 0.956134 0.292928 0.0; -0.150591 -0.0461362 0.0 -0.292928 0.956134 0.0; 0.0 0.0 0.0 0.0 0.0 1.0], [-0.927773 0.0 0.373144 0.0 0.0 0.0; 0.373144 0.0 0.927773 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; 0.0 -0.187874 0.0 -0.927773 0.0 0.373144; 0.0 0.0755618 0.0 0.373144 0.0 0.927773; -0.2025 0.0 0.0 0.0 1.0 0.0], [-0.826669 0.0 -0.562689 0.0 0.0 0.0; -0.562689 0.0 0.826669 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; -0.11507 8.26669e-13 0.169054 -0.826669 0.0 -0.562689; 0.169054 5.62689e-13 0.11507 -0.562689 0.0 0.826669; 1.0e-12 0.0 0.0 0.0 1.0 0.0], [0.999945 0.0 -0.0104451 0.0 0.0 0.0; 0.0104451 0.0 0.999945 0.0 0.0 0.0; 0.0 -1.0 0.0 0.0 0.0 0.0; 0.0 0.215488 0.0 0.999945 0.0 -0.0104451; 0.0 0.00225091 0.0 0.0104451 0.0 0.999945; 0.2155 0.0 0.0 0.0 -1.0 0.0], [-0.668187 0.0 -0.743993 0.0 0.0 0.0; -0.743993 0.0 0.668187 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; -0.137267 6.68187e-13 0.123281 -0.668187 0.0 -0.743993; 0.123281 7.43993e-13 0.137267 -0.743993 0.0 0.668187; 1.0e-12 0.0 0.0 0.0 1.0 0.0], [0.951994 0.0 0.306117 0.0 0.0 0.0; -0.306117 0.0 0.951994 0.0 0.0 0.0; 0.0 -1.0 0.0 0.0 0.0 0.0; -6.12234e-13 0.205155 1.90399e-12 0.951994 0.0 0.306117; -1.90399e-12 -0.0659682 -6.12234e-13 -0.306117 0.0 0.951994; 0.2155 0.0 0.0 0.0 -1.0 0.0], [0.662605 0.0 0.748969 0.0 0.0 0.0; 0.748969 0.0 -0.662605 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; 0.0606665 0.0 -0.053671 0.662605 0.0 0.748969; -0.053671 0.0 -0.0606665 0.748969 0.0 -0.662605; 0.0 0.0 0.0 0.0 1.0 0.0]]
   vlist = [[0.0; 0.0; 0.999905; 0.0; 0.0; 0.0], [0.373109; 0.927685; 0.251662; 0.0; 0.0; 0.0], [-0.450045; -0.00190277; 1.91435; -0.000389117; 0.0920342; 3.73109e-13], [-0.470016; 1.90955; 0.557654; -0.00079912; -8.34731e-6; -0.189019], [-0.100832; 0.722306; 2.34665; 0.274428; -0.107102; -8.34731e-6], [0.622359; 2.26487; -0.297588; 0.409436; -0.131664; 0.0853726], [0.189494; 0.663311; 3.03809; 0.388964; 0.234737; -0.131664]]
   alist = [[0.0; 0.0; 0.671362; 0.0; 0.0; 0.0], [0.483978; 0.528975; 2.08541; 0.0; 0.0; 0.0], [-1.5754; 1.89566; -0.391451; 0.387661; 0.32217; 4.83978e-13], [-0.509994; -0.146673; 3.56933; 0.796127; 0.00876021; -0.661668], [-1.99906; 2.80848; 25.7098; 0.423533; -0.727309; 0.00876021], [6.92905; 24.8232; 102.641; 0.926137; -0.480476; 0.296512], [81.9788; -62.9671; 76.9509; -4.07122; -6.40232; -0.480476]]
   flist = [[-0.386208; 0.368599; 0.28119; 0.818636; 1.98773; -3.07625], [0.0930661; 0.248573; 0.209472; -1.83265; -2.57865; 1.86775], [0.380028; 0.0151653; 0.251379; 0.210761; 2.40183; -2.49168], [0.925628; 0.297174; 0.0203749; -0.839812; -2.1552; -1.17263], [-0.376703; -0.860545; 0.287702; 0.13818; 1.44749; -1.98613], [0.0383153; 0.167; 0.859512; -0.890237; -1.39686; -1.30446], [0.122748; -0.0996843; 0.0769509; -1.83586; -2.03848; -0.211055]]
   # outputs
   dvidq_curr_mat_list_ref = [[0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0],
                              [0.0 0.927685 0.0 0.0 0.0 0.0 0.0; 0.0 -0.373109 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0],
                              [0.0 -0.766889 -0.00190299 0.0 0.0 0.0 0.0; 0.0 -0.521998 0.450045 0.0 0.0 0.0 0.0; 0.0 -0.373109 0.0 0.0 0.0 0.0 0.0; 0.0 -0.106749 0.0920342 0.0 0.0 0.0 0.0; 0.0 0.156829 0.000389162 0.0 0.0 0.0 0.0; 0.0 9.27685e-13 0.0 0.0 0.0 0.0 0.0],
                              [0.0 -0.76295 -0.00190289 1.90954 0.0 0.0 0.0; 0.0 -0.381099 -1.98769e-5 0.470016 0.0 0.0 0.0; 0.0 0.521998 -0.450045 0.0 0.0 0.0 0.0; 0.0 -0.219227 0.189009 -8.34731e-6 0.0 0.0 0.0; 0.0 -0.00228996 0.00197431 0.00079912 0.0 0.0 0.0; 0.0 -0.322093 -0.000799257 0.0 0.0 0.0 0.0],
                              [0.0 0.12143 0.336102 -1.27593 0.722306 0.0 0.0; 0.0 0.916422 -0.299299 -1.42069 0.100832 0.0 0.0; 0.0 -0.381099 -1.98769e-5 0.470016 0.0 0.0 0.0; 0.0 0.5552 -0.180919 -0.262111 -0.107102 0.0 0.0; 0.0 -0.0745189 -0.203166 0.235416 -0.274428 0.0 0.0; 0.0 -0.00228996 0.00197431 0.00079912 0.0 0.0 0.0],
                              [0.0 -0.00105989 0.319961 -1.0708 0.687631 2.26486 0.0; 0.0 -0.399976 -0.102905 0.838037 -0.22111 -0.622358 0.0; 0.0 -0.916422 0.299299 1.42069 -0.100832 0.0 0.0; 0.0 0.715854 -0.233032 -0.540745 -0.0812743 -0.131664 0.0; 0.0 -0.232591 0.0770061 0.174718 0.026134 -0.409436 0.0; 0.0 0.0100687 0.275596 -0.51038 0.430085 0.0 0.0],
                              [0.0 -0.687074 0.436173 0.354534 0.380107 1.50071 0.663311; 0.0 0.606432 0.0413241 -1.74335 0.581826 1.69631 -0.189494; 0.0 -0.399976 -0.102905 0.838037 -0.22111 -0.622358 0.0; 0.0 0.598861 0.0553519 -0.88177 0.315396 0.05016 0.234738; 0.0 0.52509 -0.392475 -0.0955383 -0.376637 -0.22017 -0.388964; 0.0 -0.232591 0.0770061 0.174718 0.026134 -0.409436 0.0]]
   daidq_curr_mat_list_ref = [[0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0],
                              [0.0 0.528974 0.0 0.0 0.0 0.0 0.0; 0.0 -0.483978 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0],
                              [0.0 -0.952324 1.89566 0.0 0.0 0.0 0.0; 0.0 0.459015 1.5754 0.0 0.0 0.0 0.0; 0.0 -0.483978 0.0 0.0 0.0 0.0 0.0; 0.0 0.0938686 0.32217 0.0 0.0 0.0 0.0; 0.0 0.19475 -0.387662 0.0 0.0 0.0 0.0; 0.0 5.28974e-13 0.0 0.0 0.0 0.0 0.0],
                              [0.0 -1.15901 1.89554 -0.146673 0.0 0.0 0.0; 0.0 -0.0698889 0.0208578 0.509994 0.0 0.0 0.0; 0.0 -0.459015 -1.5754 0.0 0.0 0.0 0.0; 0.0 0.191503 0.662731 0.00876021 0.0 0.0 0.0; 0.0 0.123849 -0.0981305 -0.796128 0.0 0.0 0.0; 0.0 -0.399976 0.796177 0.0 0.0 0.0 0.0],
                              [0.0 1.51652 -0.225315 -0.522989 2.80849 0.0 0.0; 0.0 0.502512 -2.60985 0.666844 1.99906 0.0 0.0; 0.0 -0.0698889 0.0208578 0.509994 0.0 0.0 0.0; 0.0 0.239553 -1.5784 0.117182 -0.727308 0.0 0.0; 0.0 -0.85831 0.135442 0.0899715 -0.423534 0.0 0.0; 0.0 0.123849 -0.0981305 -0.796128 0.0 0.0 0.0],
                              [0.0 1.25244 -0.251819 0.0141643 2.57975 24.8232 0.0; 0.0 -0.530315 -0.047064 1.1004 -1.15177 -6.92904 0.0; 0.0 -0.502512 2.60985 -0.666844 -1.99906 0.0 0.0; 0.0 0.270273 -2.03538 0.0788605 -0.271177 -0.480476 0.0; 0.0 -0.292613 0.660894 -0.608107 0.125285 -0.926135 0.0; 0.0 1.18512 -0.183998 -0.202676 1.02876 0.0 0.0],
                              [0.0 0.922417 1.81979 -1.83806 0.662005 17.7596 -62.9673; 0.0 1.80227 -2.25516 0.178329 2.96283 17.4314 -81.979; 0.0 -0.530315 -0.047064 1.1004 -1.15177 -6.92904 0.0; 0.0 1.57566 -1.94528 -0.136767 0.5634 1.01733 -6.40234; 0.0 -1.08263 -1.59013 0.914858 -1.14582 -1.73093 4.07124; 0.0 -0.292613 0.660894 -0.608107 0.125285 -0.926135 0.0]]
   dfidq_curr_mat_list_ref = [[0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0],
                              [0.0 0.0413364 0.0 0.0 0.0 0.0 0.0; 0.0 -0.00192423 0.0 0.0 0.0 0.0 0.0; 0.0 -0.0307751 0.0 0.0 0.0 0.0 0.0; 0.0 0.128992 0.0 0.0 0.0 0.0 0.0; 0.0 -0.267149 0.0 0.0 0.0 0.0 0.0; 0.0 0.103539 0.0 0.0 0.0 0.0 0.0],
                              [0.0 -0.03999 0.238022 0.0 0.0 0.0 0.0; 0.0 -0.157892 0.320575 0.0 0.0 0.0 0.0; 0.0 0.0173565 -0.0457583 0.0 0.0 0.0 0.0; 0.0 -0.779274 1.55903 0.0 0.0 0.0 0.0; 0.0 0.0200287 -1.03789 0.0 0.0 0.0 0.0; 0.0 -0.870259 0.248148 0.0 0.0 0.0 0.0],
                              [0.0 0.012598 0.136545 0.0296131 0.0 0.0 0.0; 0.0 -0.0408688 0.0714059 0.0247565 0.0 0.0 0.0; 0.0 0.0900804 -0.1855 -0.105146 0.0 0.0 0.0; 0.0 -1.16174 2.08785 0.546813 0.0 0.0 0.0; 0.0 -0.851605 -0.143809 -0.812771 0.0 0.0 0.0; 0.0 0.0524322 1.35997 0.0208815 0.0 0.0 0.0],
                              [0.0 -0.0664353 0.0506626 0.109098 0.167419 0.0 0.0; 0.0 0.0703392 -0.194506 -0.110084 0.0882908 0.0 0.0; 0.0 -0.015841 0.0435314 0.0251287 -0.00860168 0.0 0.0; 0.0 0.741418 -2.09657 -1.00619 0.353863 0.0 0.0; 0.0 0.688614 -0.550317 -1.08058 -1.47426 0.0 0.0; 0.0 -0.954893 0.200673 -0.0710965 0.108659 0.0 0.0],
                              [0.0 0.00434036 -0.000527392 0.00394659 0.0142073 0.125122 0.0; 0.0 -0.00188286 -0.00112045 0.00377053 -0.00373699 -0.0256188 0.0; 0.0 -0.00230587 0.0128089 0.000358579 -0.0121177 -0.00593111 0.0; 0.0 0.493207 -2.44585 -1.37936 1.22403 -1.18016 0.0; 0.0 -1.70107 1.17756 0.982869 -0.395696 -1.96534 0.0; 0.0 -0.750141 0.705639 1.673 2.21509 0.0270107 0.0],
                              [0.0 -0.00236495 0.0105462 0.00705725 0.0019181 0.0285945 -0.0996847; 0.0 0.000799915 -0.00646779 0.00216122 0.0136537 0.0280805 -0.122749; 0.0 -0.000530315 -4.7064e-5 0.0011004 -0.00115177 -0.00692904 0.0; 0.0 -0.0501177 -0.210631 0.0991446 0.534541 0.532454 -2.03849; 0.0 0.164368 -0.436323 -0.444766 -0.0628047 -0.541746 1.83587; 0.0 -0.299516 0.189515 0.229071 -0.0932079 -0.409513 -1.23166e-7]]
   dvidqd_curr_mat_list_ref = [[0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 1.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0],
                               [0.373144 0.0 0.0 0.0 0.0 0.0 0.0; 0.927773 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0],
                               [-0.308467 -0.562689 0.0 0.0 0.0 0.0 0.0; -0.209964 0.826669 0.0 0.0 0.0 0.0 0.0; 0.927773 0.0 1.0 0.0 0.0 0.0 0.0; -0.0429377 0.169054 0.0 0.0 0.0 0.0 0.0; 0.0630815 0.11507 0.0 0.0 0.0 0.0 0.0; 3.73144e-13 0.0 0.0 0.0 0.0 0.0 0.0],
                               [-0.318141 -0.562658 -0.0104451 0.0 0.0 0.0 0.0; 0.924501 -0.00587731 0.999945 0.0 0.0 0.0 0.0; 0.209964 -0.826669 0.0 1.0 0.0 0.0 0.0; -0.0881801 0.347182 0.0 0.0 0.0 0.0 0.0; -0.000921096 0.00362653 0.0 0.0 0.0 0.0 0.0; -0.129556 -0.236329 0.0 0.0 0.0 0.0 0.0],
                               [0.0563657 0.990997 0.00697925 -0.743993 0.0 0.0 0.0; 0.37699 -0.133756 0.00777105 0.668187 0.0 0.0 0.0; 0.924501 -0.00587731 0.999945 0.0 1.0 0.0 0.0; 0.224864 -0.0808332 0.00143376 0.123281 0.0 0.0 0.0; -0.0313618 -0.599052 -0.00128767 0.137267 0.0 0.0 0.0; -0.000921096 0.00362653 -1.04451e-14 0.0 0.0 0.0 0.0],
                               [0.336665 0.941624 0.312744 -0.708277 0.306117 0.0 0.0; 0.862865 -0.308956 0.949806 0.227749 0.951994 0.0 0.0; -0.37699 0.133756 -0.00777105 -0.668187 0.0 1.0 0.0; 0.291129 -0.103283 0.0029592 0.254444 1.90399e-12 0.0 0.0; -0.094581 0.0370205 -0.00095154 -0.0818173 -6.12234e-13 0.0 0.0; 0.0435086 0.812612 0.0027917 -0.297597 0.0 0.0 0.0],
                               [-0.0592779 0.724104 0.201406 -0.969759 0.202835 0.748969 0.0; 0.501947 0.61662 0.239385 -0.0877335 0.229272 -0.662605 0.0; 0.862865 -0.308956 0.949806 0.227749 0.951994 0.0 1.0; 0.266148 0.590131 0.0234419 -0.0614017 0.018571 -0.053671 0.0; 0.194019 -0.674449 -0.0159473 0.466311 -0.0164296 -0.0606665 0.0; -0.094581 0.0370205 -0.00095154 -0.0818173 -6.12234e-13 0.0 0.0]]
   daidqd_curr_mat_list_ref = [[0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0],
                               [0.233485 0.927685 0.0 0.0 0.0 0.0 0.0; -0.0939063 -0.373109 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0],
                               [-0.40018 0.0487581 -0.00190277 0.0 0.0 0.0 0.0; 0.172974 0.0331881 0.450045 0.0 0.0 0.0 0.0; -0.0939063 -0.373109 0.0 0.0 0.0 0.0 0.0; 0.0353733 0.00678697 0.0920342 0.0 0.0 0.0 0.0; 0.0818368 -0.00997102 0.000389117 0.0 0.0 0.0 0.0; 2.33485e-13 9.27685e-13 0.0 0.0 0.0 0.0 0.0],
                               [0.114615 0.0493862 0.553818 1.90955 0.0 0.0 0.0; 0.0787259 -0.0598817 0.00578498 0.470016 0.0 0.0 0.0; -0.172974 -0.0331881 -0.450045 0.0 0.0 0.0 0.0; 0.0721334 0.0159537 0.189009 -8.34731e-6 0.0 0.0 0.0; 0.049765 -0.192801 0.00197431 0.00079912 0.0 0.0 0.0; -0.168075 0.0204784 -0.000799164 0.0 0.0 0.0 0.0],
                               [0.216893 -0.0667733 -0.0318269 -0.983867 0.722306 0.0 0.0; -0.22549 -0.492092 -0.715802 -1.09549 0.100832 0.0 0.0; 0.0787259 -0.0598817 0.00578498 0.470016 0.0 0.0 0.0; 0.0260827 -0.298617 -0.257764 -0.202112 -0.107102 0.0 0.0; -0.273876 0.0386795 -0.135283 0.18153 -0.274428 0.0 0.0; 0.049765 -0.192801 0.00197431 0.00079912 0.0 0.0 0.0],
                               [0.597054 -0.213118 0.374871 -0.696027 1.09196 2.26487 0.0; -0.134435 -0.436491 -0.117578 1.04945 -0.351123 -0.622359 0.0; 0.22549 0.492092 0.715802 1.09549 -0.100832 0.0 0.0; -0.0463661 -0.428533 -0.39204 -0.451658 -0.0812743 -0.131664 0.0; -0.0693808 -0.0158053 0.126749 0.0268309 0.026134 -0.409436 0.0; 0.320617 -0.0530692 0.128424 -0.393553 0.430085 0.0 0.0],
                               [0.952613 0.704133 0.969603 0.291458 0.825296 0.988373 0.663311; 0.343599 -1.04557 -0.349258 -0.497337 0.72782 1.1172 -0.189494; -0.134435 -0.436491 -0.117578 1.04945 -0.351123 -0.622359 0.0; 0.383548 -0.884535 -0.191588 -0.334489 0.327221 0.00325177 0.234737; -0.498685 -0.760512 -0.460391 -0.0591335 -0.412697 -0.17867 -0.388964; -0.0693808 -0.0158053 0.126749 0.0268309 0.026134 -0.409436 0.0]]
   dfidqd_curr_mat_list_ref = [[-0.0287973 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.239977 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0],
                               [0.00716325 0.10138 0.0 0.0 0.0 0.0 0.0; 0.00571631 -0.00463431 0.0 0.0 0.0 0.0 0.0; -0.0316917 0.0 0.0 0.0 0.0 0.0 0.0; 0.161322 -0.000603989 0.0 0.0 0.0 0.0 0.0; -0.0648828 -0.118784 0.0 0.0 0.0 0.0 0.0; -0.225538 0.438763 0.0 0.0 0.0 0.0 0.0],
                               [0.028943 -0.303875 0.044757 0.0 0.0 0.0 0.0; -0.16432 -0.209083 0.00225023 0.0 0.0 0.0 0.0; 0.0232153 0.0295474 0.0 0.0 0.0 0.0 0.0; -0.820993 -1.04746 0.0 0.0 0.0 0.0 0.0; -0.348226 1.49356 -0.344583 0.0 0.0 0.0 0.0; -0.351772 -0.35827 -0.000342499 0.0 0.0 0.0 0.0],
                               [0.0219101 -0.144297 0.01718 0.146716 0.0 0.0 0.0; -0.0375336 -0.0469122 -0.00019346 0.00423014 0.0 0.0 0.0; 0.090795 0.111883 -0.00276884 0.0 0.0 0.0 0.0; -1.11896 -1.36436 -0.00722016 0.0 0.0 0.0 0.0; -0.348484 -0.661744 -0.00142686 -0.201759 0.0 0.0 0.0; -0.161046 -2.06302 -0.150416 0.690875 0.0 0.0 0.0],
                               [-0.0907128 0.0199799 -0.0230856 -0.135476 0.0188723 0.0 0.0; 0.0200496 0.189508 -0.0411519 -0.14442 0.000236705 0.0 0.0; -0.00601293 -0.0469511 0.00749801 0.0309057 0.0 0.0 0.0; 0.309011 2.1507 -0.355245 -1.29684 -0.000797861 0.0 0.0; 0.880681 -0.283061 0.174536 1.12472 -0.167551 0.0 0.0; -0.377962 -0.206329 0.0210588 -0.473171 0.0515384 0.0 0.0],
                               [0.00116697 -3.59492e-5 0.00114096 -0.00626799 0.00514722 0.0138184 0.0; -0.00054948 -0.000611807 -0.000672736 0.00283827 -0.0012909 -0.00205378 0.0; -0.000811912 -0.00193167 0.00187517 0.0085135 -0.00227473 0.0 0.0; 0.0873266 2.54663 -0.550209 -2.19556 0.00117898 0.0 0.0; -0.661067 -0.930316 0.168737 -0.138334 -0.00140164 0.00064279 0.0; -1.43508 0.371905 -0.559375 -1.83992 -0.00250623 0.00489212 0.0],
                               [-0.00311857 -0.00541464 0.000881285 0.00195591 0.000520647 0.00280724 0.000663311; -0.00284078 0.00616829 -0.0026856 -0.0119896 0.00165164 0.00317313 -0.000189494; -0.000134435 -0.000436491 -0.000117578 0.00104945 -0.000351123 -0.000622359 0.0; -0.159219 0.360693 -0.116817 -0.574611 0.0461908 0.102797 0.0; 0.203559 0.305939 0.00441591 -0.0832225 0.0152325 -0.0909432 0.0; -0.129353 -0.18803 0.0163394 -0.00837376 -0.0115452 0.0180337 0.0]]

   #----------------------------------------------------------------------------
   # Link Snapshot
   #----------------------------------------------------------------------------
   # test link
   test_link = 7
   # inputs
   link_test = 0.0
   Xi_curr_test = zeros(CUSTOM_TYPE,6,6)
   qdi_curr_test = 0.0
   vi_curr_vec_test = zeros(CUSTOM_TYPE,6,1)
   vi_prev_vec_test = zeros(CUSTOM_TYPE,6,1)
   ai_prev_vec_test = zeros(CUSTOM_TYPE,6,1)
   dvidq_prev_mat_test = zeros(CUSTOM_TYPE,6,7)
   daidq_prev_mat_test = zeros(CUSTOM_TYPE,6,7)
   dvidqd_prev_mat_test = zeros(CUSTOM_TYPE,6,7)
   daidqd_prev_mat_test = zeros(CUSTOM_TYPE,6,7)
   # outputs
   dvidq_curr_mat_test = zeros(CUSTOM_TYPE,6,7)
   daidq_curr_mat_test = zeros(CUSTOM_TYPE,6,7)
   dfidq_curr_mat_test = zeros(CUSTOM_TYPE,6,7)
   dvidqd_curr_mat_test = zeros(CUSTOM_TYPE,6,7)
   daidqd_curr_mat_test = zeros(CUSTOM_TYPE,6,7)
   dfidqd_curr_mat_test = zeros(CUSTOM_TYPE,6,7)

   #----------------------------------------------------------------------------
   # Unit Under Test
   #----------------------------------------------------------------------------
   # local variables
   dvidq_curr_mat_list = [zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7)]
   daidq_curr_mat_list = [zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7)]
   dvidqd_curr_mat_list = [zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7)]
   daidqd_curr_mat_list = [zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7)]

   # output storage
   dfidq_curr_mat_list = [zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7)]
   dfidqd_curr_mat_list = [zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7)]

   # forward pass
   for link in 1:7
      prev_link = (link-1)
      # select link inputs
      Xi_curr = tXlist[link]
      qdi_curr = qd[link]
      vi_curr_vec = vlist[link]
      # update previous link values
      if (link > 1)
         vi_prev_vec = vlist[prev_link]
         ai_prev_vec = alist[prev_link]
         dvidq_prev_mat = dvidq_curr_mat_list[prev_link]
         daidq_prev_mat = daidq_curr_mat_list[prev_link]
         dvidqd_prev_mat = dvidqd_curr_mat_list[prev_link]
         daidqd_prev_mat = daidqd_curr_mat_list[prev_link]
      else
         vi_prev_vec = zeros(CUSTOM_TYPE,6,1)
         ai_prev_vec = zeros(CUSTOM_TYPE,6,1)
         dvidq_prev_mat = zeros(CUSTOM_TYPE,6,7)
         daidq_prev_mat = zeros(CUSTOM_TYPE,6,7)
         dvidqd_prev_mat = zeros(CUSTOM_TYPE,6,7)
         daidqd_prev_mat = zeros(CUSTOM_TYPE,6,7)
      end
      # snapshot inputs
      if (link == test_link)
         link_test = link
         Xi_curr_test = Xi_curr
         qdi_curr_test = qdi_curr
         vi_curr_vec_test = vi_curr_vec
         vi_prev_vec_test = vi_prev_vec
         ai_prev_vec_test = ai_prev_vec
         dvidq_prev_mat_test = dvidq_prev_mat
         daidq_prev_mat_test = daidq_prev_mat
         dvidqd_prev_mat_test = dvidqd_prev_mat
         daidqd_prev_mat_test = daidqd_prev_mat
      end
      # fprow
      dvidq_curr_mat_list[link],
      daidq_curr_mat_list[link],
      dfidq_curr_mat_list[link],
      dvidqd_curr_mat_list[link],
      daidqd_curr_mat_list[link],
      dfidqd_curr_mat_list[link] = fpRow(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                                         link,Xi_curr,qdi_curr,
                                         vi_curr_vec,vi_prev_vec,ai_prev_vec,
                                         dvidq_prev_mat,daidq_prev_mat,
                                         dvidqd_prev_mat,daidqd_prev_mat)
      # snapshot outputs
      if (link == test_link)
         dvidq_curr_mat_test = dvidq_curr_mat_list[link]
         daidq_curr_mat_test = daidq_curr_mat_list[link]
         dfidq_curr_mat_test = dfidq_curr_mat_list[link]
         dvidqd_curr_mat_test = dvidqd_curr_mat_list[link]
         daidqd_curr_mat_test = daidqd_curr_mat_list[link]
         dfidqd_curr_mat_test = dfidqd_curr_mat_list[link]
      end
   end

   #----------------------------------------------------------------------------
   # Test Outputs
   #----------------------------------------------------------------------------
   for link in 1:7
      ###println("Link ",link)
      ###println("\tExpected: ",dfidq_curr_mat_list_ref[link])
      ###println("\tGot:      ",dfidq_curr_mat_list[link])
      @test dfidq_curr_mat_list_ref[link] ≈ dfidq_curr_mat_list[link] atol=1e-4
      println("Link ",link," df/dq Test Passed!")
   end
   for link in 1:7
      ###println("Link ",link)
      ###println("\tExpected: ",dfidqd_curr_mat_list_ref[link])
      ###println("\tGot:      ",dfidqd_curr_mat_list[link])
      @test dfidqd_curr_mat_list_ref[link] ≈ dfidqd_curr_mat_list[link] atol=1e-4
      println("Link ",link," df/dqd Test Passed!")
   end

   #----------------------------------------------------------------------------
   # Convert Values to Fixed-Point Binary
   #----------------------------------------------------------------------------
   # inputs
   #  link_test
   #  Xi_curr_test
   for i in 1:size(Xi_curr_test)[1] # rows
      for j in 1:size(Xi_curr_test)[2] # cols
         Xi_curr_test[i,j] = round(Xi_curr_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  qdi_curr_test
   qdi_curr_test = round(qdi_curr_test*(2^DECIMAL_BITS))
   #  vi_curr_vec_test
   for i in 1:length(vi_curr_vec_test)
      vi_curr_vec_test[i] = round(vi_curr_vec_test[i]*(2^DECIMAL_BITS))
   end
   #  vi_prev_vec_test
   for i in 1:length(vi_prev_vec_test)
      vi_prev_vec_test[i] = round(vi_prev_vec_test[i]*(2^DECIMAL_BITS))
   end
   #  ai_prev_vec_test
   for i in 1:length(ai_prev_vec_test)
      ai_prev_vec_test[i] = round(ai_prev_vec_test[i]*(2^DECIMAL_BITS))
   end
   #  dvidq_prev_mat_test
   for i in 1:size(dvidq_prev_mat_test)[1] # rows
      for j in 1:size(dvidq_prev_mat_test)[2] # cols
         dvidq_prev_mat_test[i,j] = round(dvidq_prev_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  daidq_prev_mat_test
   for i in 1:size(daidq_prev_mat_test)[1] # rows
      for j in 1:size(daidq_prev_mat_test)[2] # cols
         daidq_prev_mat_test[i,j] = round(daidq_prev_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  dvidqd_prev_mat_test
   for i in 1:size(dvidqd_prev_mat_test)[1] # rows
      for j in 1:size(dvidqd_prev_mat_test)[2] # cols
         dvidqd_prev_mat_test[i,j] = round(dvidqd_prev_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  daidqd_prev_mat_test
   for i in 1:size(daidqd_prev_mat_test)[1] # rows
      for j in 1:size(daidqd_prev_mat_test)[2] # cols
         daidqd_prev_mat_test[i,j] = round(daidqd_prev_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   # outputs
   #  dvidq_curr_mat_test
   for i in 1:size(dvidq_curr_mat_test)[1] # rows
      for j in 1:size(dvidq_curr_mat_test)[2] # cols
         dvidq_curr_mat_test[i,j] = round(dvidq_curr_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  daidq_curr_mat_test
   for i in 1:size(daidq_curr_mat_test)[1] # rows
      for j in 1:size(daidq_curr_mat_test)[2] # cols
         daidq_curr_mat_test[i,j] = round(daidq_curr_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  dfidq_curr_mat_test
   for i in 1:size(dfidq_curr_mat_test)[1] # rows
      for j in 1:size(dfidq_curr_mat_test)[2] # cols
         dfidq_curr_mat_test[i,j] = round(dfidq_curr_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  dvidqd_curr_mat_test
   for i in 1:size(dvidqd_curr_mat_test)[1] # rows
      for j in 1:size(dvidqd_curr_mat_test)[2] # cols
         dvidqd_curr_mat_test[i,j] = round(dvidqd_curr_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  daidqd_curr_mat_test
   for i in 1:size(daidqd_curr_mat_test)[1] # rows
      for j in 1:size(daidqd_curr_mat_test)[2] # cols
         daidqd_curr_mat_test[i,j] = round(daidqd_curr_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  dfidqd_curr_mat_test
   for i in 1:size(dfidqd_curr_mat_test)[1] # rows
      for j in 1:size(dfidqd_curr_mat_test)[2] # cols
         dfidqd_curr_mat_test[i,j] = round(dfidqd_curr_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end

   #----------------------------------------------------------------------------
   # Print Fixed-Point Binary Values for Vivado Simulation
   #----------------------------------------------------------------------------
   println("//------------------------------------------------------------------------")
   println("// Link ",test_link," Test")
   println("//------------------------------------------------------------------------")
   println("// Link ",test_link," Inputs")
   # inputs
   #  link
   println("link_in = 3'd",link_test,";")
   #  Xi_curr
   println("xform_in_AX_AX = 32'd",Xi_curr_test[1,1],"; xform_in_AX_AY = 32'd",Xi_curr_test[1,2],"; xform_in_AX_AZ = 32'd",Xi_curr_test[1,3],";")
   println("xform_in_AY_AX = 32'd",Xi_curr_test[2,1],"; xform_in_AY_AY = 32'd",Xi_curr_test[2,2],"; xform_in_AY_AZ = 32'd",Xi_curr_test[2,3],";")
   println("                                     xform_in_AZ_AY = 32'd",Xi_curr_test[3,2],"; xform_in_AZ_AZ = 32'd",Xi_curr_test[3,3],";")
   println("xform_in_LX_AX = 32'd",Xi_curr_test[4,1],"; xform_in_LX_AY = 32'd",Xi_curr_test[4,2],"; xform_in_LX_AZ = 32'd",Xi_curr_test[4,3],";  xform_in_LX_LX = 32'd",Xi_curr_test[4,4],"; xform_in_LX_LY = 32'd",Xi_curr_test[4,5],"; xform_in_LX_LZ = 32'd",Xi_curr_test[4,6],";")
   println("xform_in_LY_AX = 32'd",Xi_curr_test[5,1],"; xform_in_LY_AY = 32'd",Xi_curr_test[5,2],"; xform_in_LY_AZ = 32'd",Xi_curr_test[5,3],";  xform_in_LY_LX = 32'd",Xi_curr_test[5,4],"; xform_in_LY_LY = 32'd",Xi_curr_test[5,5],"; xform_in_LY_LZ = 32'd",Xi_curr_test[5,6],";")
   println("xform_in_LZ_AX = 32'd",Xi_curr_test[6,1],";                                                                                                                 xform_in_LZ_LY = 32'd",Xi_curr_test[6,5],"; xform_in_LZ_LZ = 32'd",Xi_curr_test[6,6],";")
   #  qdi_curr
   println("qd_curr_in = 32'd",qdi_curr_test,";")
   #  vi_curr_vec
   println("v_curr_vec_in_AX = 32'd",vi_curr_vec_test[1],"; v_curr_vec_in_AY = 32'd",vi_curr_vec_test[2],"; v_curr_vec_in_AZ = 32'd",vi_curr_vec_test[3],"; v_curr_vec_in_LX = 32'd",vi_curr_vec_test[4],"; v_curr_vec_in_LY = 32'd",vi_curr_vec_test[5],"; v_curr_vec_in_LZ = 32'd",vi_curr_vec_test[6],";")
   #  vi_prev_vec
   println("v_prev_vec_in_AX = 32'd",vi_prev_vec_test[1],"; v_prev_vec_in_AY = 32'd",vi_prev_vec_test[2],"; v_prev_vec_in_AZ = 32'd",vi_prev_vec_test[3],"; v_prev_vec_in_LX = 32'd",vi_prev_vec_test[4],"; v_prev_vec_in_LY = 32'd",vi_prev_vec_test[5],"; v_prev_vec_in_LZ = 32'd",vi_prev_vec_test[6],";")
   #  ai_prev_vec
   println("a_prev_vec_in_AX = 32'd",ai_prev_vec_test[1],"; a_prev_vec_in_AY = 32'd",ai_prev_vec_test[2],"; a_prev_vec_in_AZ = 32'd",ai_prev_vec_test[3],"; a_prev_vec_in_LX = 32'd",ai_prev_vec_test[4],"; a_prev_vec_in_LY = 32'd",ai_prev_vec_test[5],"; a_prev_vec_in_LZ = 32'd",ai_prev_vec_test[6],";")
   #  dvidq_prev_mat
   println("dvidq_prev_mat_in_AX_J1 = 32'd",dvidq_prev_mat_test[1,1],"; dvidq_prev_mat_in_AX_J2 = 32'd",dvidq_prev_mat_test[1,2],"; dvidq_prev_mat_in_AX_J3 = 32'd",dvidq_prev_mat_test[1,3],";  dvidq_prev_mat_in_AX_J4 = 32'd",dvidq_prev_mat_test[1,4],"; dvidq_prev_mat_in_AX_J5 = 32'd",dvidq_prev_mat_test[1,5],"; dvidq_prev_mat_in_AX_J6 = 32'd",dvidq_prev_mat_test[1,6],"; dvidq_prev_mat_in_AX_J7 = 32'd",dvidq_prev_mat_test[1,7],";")
   println("dvidq_prev_mat_in_AY_J1 = 32'd",dvidq_prev_mat_test[2,1],"; dvidq_prev_mat_in_AY_J2 = 32'd",dvidq_prev_mat_test[2,2],"; dvidq_prev_mat_in_AY_J3 = 32'd",dvidq_prev_mat_test[2,3],";  dvidq_prev_mat_in_AY_J4 = 32'd",dvidq_prev_mat_test[2,4],"; dvidq_prev_mat_in_AY_J5 = 32'd",dvidq_prev_mat_test[2,5],"; dvidq_prev_mat_in_AY_J6 = 32'd",dvidq_prev_mat_test[2,6],"; dvidq_prev_mat_in_AY_J7 = 32'd",dvidq_prev_mat_test[2,7],";")
   println("dvidq_prev_mat_in_AZ_J1 = 32'd",dvidq_prev_mat_test[3,1],"; dvidq_prev_mat_in_AZ_J2 = 32'd",dvidq_prev_mat_test[3,2],"; dvidq_prev_mat_in_AZ_J3 = 32'd",dvidq_prev_mat_test[3,3],";  dvidq_prev_mat_in_AZ_J4 = 32'd",dvidq_prev_mat_test[3,4],"; dvidq_prev_mat_in_AZ_J5 = 32'd",dvidq_prev_mat_test[3,5],"; dvidq_prev_mat_in_AZ_J6 = 32'd",dvidq_prev_mat_test[3,6],"; dvidq_prev_mat_in_AZ_J7 = 32'd",dvidq_prev_mat_test[3,7],";")
   println("dvidq_prev_mat_in_LX_J1 = 32'd",dvidq_prev_mat_test[4,1],"; dvidq_prev_mat_in_LX_J2 = 32'd",dvidq_prev_mat_test[4,2],"; dvidq_prev_mat_in_LX_J3 = 32'd",dvidq_prev_mat_test[4,3],";  dvidq_prev_mat_in_LX_J4 = 32'd",dvidq_prev_mat_test[4,4],"; dvidq_prev_mat_in_LX_J5 = 32'd",dvidq_prev_mat_test[4,5],"; dvidq_prev_mat_in_LX_J6 = 32'd",dvidq_prev_mat_test[4,6],"; dvidq_prev_mat_in_LX_J7 = 32'd",dvidq_prev_mat_test[4,7],";")
   println("dvidq_prev_mat_in_LY_J1 = 32'd",dvidq_prev_mat_test[5,1],"; dvidq_prev_mat_in_LY_J2 = 32'd",dvidq_prev_mat_test[5,2],"; dvidq_prev_mat_in_LY_J3 = 32'd",dvidq_prev_mat_test[5,3],";  dvidq_prev_mat_in_LY_J4 = 32'd",dvidq_prev_mat_test[5,4],"; dvidq_prev_mat_in_LY_J5 = 32'd",dvidq_prev_mat_test[5,5],"; dvidq_prev_mat_in_LY_J6 = 32'd",dvidq_prev_mat_test[5,6],"; dvidq_prev_mat_in_LY_J7 = 32'd",dvidq_prev_mat_test[5,7],";")
   println("dvidq_prev_mat_in_LZ_J1 = 32'd",dvidq_prev_mat_test[6,1],"; dvidq_prev_mat_in_LZ_J2 = 32'd",dvidq_prev_mat_test[6,2],"; dvidq_prev_mat_in_LZ_J3 = 32'd",dvidq_prev_mat_test[6,3],";  dvidq_prev_mat_in_LZ_J4 = 32'd",dvidq_prev_mat_test[6,4],"; dvidq_prev_mat_in_LZ_J5 = 32'd",dvidq_prev_mat_test[6,5],"; dvidq_prev_mat_in_LZ_J6 = 32'd",dvidq_prev_mat_test[6,6],"; dvidq_prev_mat_in_LZ_J7 = 32'd",dvidq_prev_mat_test[6,7],";")
   #  daidq_prev_mat
   println("daidq_prev_mat_in_AX_J1 = 32'd",daidq_prev_mat_test[1,1],"; daidq_prev_mat_in_AX_J2 = 32'd",daidq_prev_mat_test[1,2],"; daidq_prev_mat_in_AX_J3 = 32'd",daidq_prev_mat_test[1,3],";  daidq_prev_mat_in_AX_J4 = 32'd",daidq_prev_mat_test[1,4],"; daidq_prev_mat_in_AX_J5 = 32'd",daidq_prev_mat_test[1,5],"; daidq_prev_mat_in_AX_J6 = 32'd",daidq_prev_mat_test[1,6],"; daidq_prev_mat_in_AX_J7 = 32'd",daidq_prev_mat_test[1,7],";")
   println("daidq_prev_mat_in_AY_J1 = 32'd",daidq_prev_mat_test[2,1],"; daidq_prev_mat_in_AY_J2 = 32'd",daidq_prev_mat_test[2,2],"; daidq_prev_mat_in_AY_J3 = 32'd",daidq_prev_mat_test[2,3],";  daidq_prev_mat_in_AY_J4 = 32'd",daidq_prev_mat_test[2,4],"; daidq_prev_mat_in_AY_J5 = 32'd",daidq_prev_mat_test[2,5],"; daidq_prev_mat_in_AY_J6 = 32'd",daidq_prev_mat_test[2,6],"; daidq_prev_mat_in_AY_J7 = 32'd",daidq_prev_mat_test[2,7],";")
   println("daidq_prev_mat_in_AZ_J1 = 32'd",daidq_prev_mat_test[3,1],"; daidq_prev_mat_in_AZ_J2 = 32'd",daidq_prev_mat_test[3,2],"; daidq_prev_mat_in_AZ_J3 = 32'd",daidq_prev_mat_test[3,3],";  daidq_prev_mat_in_AZ_J4 = 32'd",daidq_prev_mat_test[3,4],"; daidq_prev_mat_in_AZ_J5 = 32'd",daidq_prev_mat_test[3,5],"; daidq_prev_mat_in_AZ_J6 = 32'd",daidq_prev_mat_test[3,6],"; daidq_prev_mat_in_AZ_J7 = 32'd",daidq_prev_mat_test[3,7],";")
   println("daidq_prev_mat_in_LX_J1 = 32'd",daidq_prev_mat_test[4,1],"; daidq_prev_mat_in_LX_J2 = 32'd",daidq_prev_mat_test[4,2],"; daidq_prev_mat_in_LX_J3 = 32'd",daidq_prev_mat_test[4,3],";  daidq_prev_mat_in_LX_J4 = 32'd",daidq_prev_mat_test[4,4],"; daidq_prev_mat_in_LX_J5 = 32'd",daidq_prev_mat_test[4,5],"; daidq_prev_mat_in_LX_J6 = 32'd",daidq_prev_mat_test[4,6],"; daidq_prev_mat_in_LX_J7 = 32'd",daidq_prev_mat_test[4,7],";")
   println("daidq_prev_mat_in_LY_J1 = 32'd",daidq_prev_mat_test[5,1],"; daidq_prev_mat_in_LY_J2 = 32'd",daidq_prev_mat_test[5,2],"; daidq_prev_mat_in_LY_J3 = 32'd",daidq_prev_mat_test[5,3],";  daidq_prev_mat_in_LY_J4 = 32'd",daidq_prev_mat_test[5,4],"; daidq_prev_mat_in_LY_J5 = 32'd",daidq_prev_mat_test[5,5],"; daidq_prev_mat_in_LY_J6 = 32'd",daidq_prev_mat_test[5,6],"; daidq_prev_mat_in_LY_J7 = 32'd",daidq_prev_mat_test[5,7],";")
   println("daidq_prev_mat_in_LZ_J1 = 32'd",daidq_prev_mat_test[6,1],"; daidq_prev_mat_in_LZ_J2 = 32'd",daidq_prev_mat_test[6,2],"; daidq_prev_mat_in_LZ_J3 = 32'd",daidq_prev_mat_test[6,3],";  daidq_prev_mat_in_LZ_J4 = 32'd",daidq_prev_mat_test[6,4],"; daidq_prev_mat_in_LZ_J5 = 32'd",daidq_prev_mat_test[6,5],"; daidq_prev_mat_in_LZ_J6 = 32'd",daidq_prev_mat_test[6,6],"; daidq_prev_mat_in_LZ_J7 = 32'd",daidq_prev_mat_test[6,7],";")
   #  dvidqd_prev_mat
   println("dvidqd_prev_mat_in_AX_J1 = 32'd",dvidqd_prev_mat_test[1,1],"; dvidqd_prev_mat_in_AX_J2 = 32'd",dvidqd_prev_mat_test[1,2],"; dvidqd_prev_mat_in_AX_J3 = 32'd",dvidqd_prev_mat_test[1,3],";  dvidqd_prev_mat_in_AX_J4 = 32'd",dvidqd_prev_mat_test[1,4],"; dvidqd_prev_mat_in_AX_J5 = 32'd",dvidqd_prev_mat_test[1,5],"; dvidqd_prev_mat_in_AX_J6 = 32'd",dvidqd_prev_mat_test[1,6],"; dvidqd_prev_mat_in_AX_J7 = 32'd",dvidqd_prev_mat_test[1,7],";")
   println("dvidqd_prev_mat_in_AY_J1 = 32'd",dvidqd_prev_mat_test[2,1],"; dvidqd_prev_mat_in_AY_J2 = 32'd",dvidqd_prev_mat_test[2,2],"; dvidqd_prev_mat_in_AY_J3 = 32'd",dvidqd_prev_mat_test[2,3],";  dvidqd_prev_mat_in_AY_J4 = 32'd",dvidqd_prev_mat_test[2,4],"; dvidqd_prev_mat_in_AY_J5 = 32'd",dvidqd_prev_mat_test[2,5],"; dvidqd_prev_mat_in_AY_J6 = 32'd",dvidqd_prev_mat_test[2,6],"; dvidqd_prev_mat_in_AY_J7 = 32'd",dvidqd_prev_mat_test[2,7],";")
   println("dvidqd_prev_mat_in_AZ_J1 = 32'd",dvidqd_prev_mat_test[3,1],"; dvidqd_prev_mat_in_AZ_J2 = 32'd",dvidqd_prev_mat_test[3,2],"; dvidqd_prev_mat_in_AZ_J3 = 32'd",dvidqd_prev_mat_test[3,3],";  dvidqd_prev_mat_in_AZ_J4 = 32'd",dvidqd_prev_mat_test[3,4],"; dvidqd_prev_mat_in_AZ_J5 = 32'd",dvidqd_prev_mat_test[3,5],"; dvidqd_prev_mat_in_AZ_J6 = 32'd",dvidqd_prev_mat_test[3,6],"; dvidqd_prev_mat_in_AZ_J7 = 32'd",dvidqd_prev_mat_test[3,7],";")
   println("dvidqd_prev_mat_in_LX_J1 = 32'd",dvidqd_prev_mat_test[4,1],"; dvidqd_prev_mat_in_LX_J2 = 32'd",dvidqd_prev_mat_test[4,2],"; dvidqd_prev_mat_in_LX_J3 = 32'd",dvidqd_prev_mat_test[4,3],";  dvidqd_prev_mat_in_LX_J4 = 32'd",dvidqd_prev_mat_test[4,4],"; dvidqd_prev_mat_in_LX_J5 = 32'd",dvidqd_prev_mat_test[4,5],"; dvidqd_prev_mat_in_LX_J6 = 32'd",dvidqd_prev_mat_test[4,6],"; dvidqd_prev_mat_in_LX_J7 = 32'd",dvidqd_prev_mat_test[4,7],";")
   println("dvidqd_prev_mat_in_LY_J1 = 32'd",dvidqd_prev_mat_test[5,1],"; dvidqd_prev_mat_in_LY_J2 = 32'd",dvidqd_prev_mat_test[5,2],"; dvidqd_prev_mat_in_LY_J3 = 32'd",dvidqd_prev_mat_test[5,3],";  dvidqd_prev_mat_in_LY_J4 = 32'd",dvidqd_prev_mat_test[5,4],"; dvidqd_prev_mat_in_LY_J5 = 32'd",dvidqd_prev_mat_test[5,5],"; dvidqd_prev_mat_in_LY_J6 = 32'd",dvidqd_prev_mat_test[5,6],"; dvidqd_prev_mat_in_LY_J7 = 32'd",dvidqd_prev_mat_test[5,7],";")
   println("dvidqd_prev_mat_in_LZ_J1 = 32'd",dvidqd_prev_mat_test[6,1],"; dvidqd_prev_mat_in_LZ_J2 = 32'd",dvidqd_prev_mat_test[6,2],"; dvidqd_prev_mat_in_LZ_J3 = 32'd",dvidqd_prev_mat_test[6,3],";  dvidqd_prev_mat_in_LZ_J4 = 32'd",dvidqd_prev_mat_test[6,4],"; dvidqd_prev_mat_in_LZ_J5 = 32'd",dvidqd_prev_mat_test[6,5],"; dvidqd_prev_mat_in_LZ_J6 = 32'd",dvidqd_prev_mat_test[6,6],"; dvidqd_prev_mat_in_LZ_J7 = 32'd",dvidqd_prev_mat_test[6,7],";")
   #  daidqd_prev_mat
   println("daidqd_prev_mat_in_AX_J1 = 32'd",daidqd_prev_mat_test[1,1],"; daidqd_prev_mat_in_AX_J2 = 32'd",daidqd_prev_mat_test[1,2],"; daidqd_prev_mat_in_AX_J3 = 32'd",daidqd_prev_mat_test[1,3],";  daidqd_prev_mat_in_AX_J4 = 32'd",daidqd_prev_mat_test[1,4],"; daidqd_prev_mat_in_AX_J5 = 32'd",daidqd_prev_mat_test[1,5],"; daidqd_prev_mat_in_AX_J6 = 32'd",daidqd_prev_mat_test[1,6],"; daidqd_prev_mat_in_AX_J7 = 32'd",daidqd_prev_mat_test[1,7],";")
   println("daidqd_prev_mat_in_AY_J1 = 32'd",daidqd_prev_mat_test[2,1],"; daidqd_prev_mat_in_AY_J2 = 32'd",daidqd_prev_mat_test[2,2],"; daidqd_prev_mat_in_AY_J3 = 32'd",daidqd_prev_mat_test[2,3],";  daidqd_prev_mat_in_AY_J4 = 32'd",daidqd_prev_mat_test[2,4],"; daidqd_prev_mat_in_AY_J5 = 32'd",daidqd_prev_mat_test[2,5],"; daidqd_prev_mat_in_AY_J6 = 32'd",daidqd_prev_mat_test[2,6],"; daidqd_prev_mat_in_AY_J7 = 32'd",daidqd_prev_mat_test[2,7],";")
   println("daidqd_prev_mat_in_AZ_J1 = 32'd",daidqd_prev_mat_test[3,1],"; daidqd_prev_mat_in_AZ_J2 = 32'd",daidqd_prev_mat_test[3,2],"; daidqd_prev_mat_in_AZ_J3 = 32'd",daidqd_prev_mat_test[3,3],";  daidqd_prev_mat_in_AZ_J4 = 32'd",daidqd_prev_mat_test[3,4],"; daidqd_prev_mat_in_AZ_J5 = 32'd",daidqd_prev_mat_test[3,5],"; daidqd_prev_mat_in_AZ_J6 = 32'd",daidqd_prev_mat_test[3,6],"; daidqd_prev_mat_in_AZ_J7 = 32'd",daidqd_prev_mat_test[3,7],";")
   println("daidqd_prev_mat_in_LX_J1 = 32'd",daidqd_prev_mat_test[4,1],"; daidqd_prev_mat_in_LX_J2 = 32'd",daidqd_prev_mat_test[4,2],"; daidqd_prev_mat_in_LX_J3 = 32'd",daidqd_prev_mat_test[4,3],";  daidqd_prev_mat_in_LX_J4 = 32'd",daidqd_prev_mat_test[4,4],"; daidqd_prev_mat_in_LX_J5 = 32'd",daidqd_prev_mat_test[4,5],"; daidqd_prev_mat_in_LX_J6 = 32'd",daidqd_prev_mat_test[4,6],"; daidqd_prev_mat_in_LX_J7 = 32'd",daidqd_prev_mat_test[4,7],";")
   println("daidqd_prev_mat_in_LY_J1 = 32'd",daidqd_prev_mat_test[5,1],"; daidqd_prev_mat_in_LY_J2 = 32'd",daidqd_prev_mat_test[5,2],"; daidqd_prev_mat_in_LY_J3 = 32'd",daidqd_prev_mat_test[5,3],";  daidqd_prev_mat_in_LY_J4 = 32'd",daidqd_prev_mat_test[5,4],"; daidqd_prev_mat_in_LY_J5 = 32'd",daidqd_prev_mat_test[5,5],"; daidqd_prev_mat_in_LY_J6 = 32'd",daidqd_prev_mat_test[5,6],"; daidqd_prev_mat_in_LY_J7 = 32'd",daidqd_prev_mat_test[5,7],";")
   println("daidqd_prev_mat_in_LZ_J1 = 32'd",daidqd_prev_mat_test[6,1],"; daidqd_prev_mat_in_LZ_J2 = 32'd",daidqd_prev_mat_test[6,2],"; daidqd_prev_mat_in_LZ_J3 = 32'd",daidqd_prev_mat_test[6,3],";  daidqd_prev_mat_in_LZ_J4 = 32'd",daidqd_prev_mat_test[6,4],"; daidqd_prev_mat_in_LZ_J5 = 32'd",daidqd_prev_mat_test[6,5],"; daidqd_prev_mat_in_LZ_J6 = 32'd",daidqd_prev_mat_test[6,6],"; daidqd_prev_mat_in_LZ_J7 = 32'd",daidqd_prev_mat_test[6,7],";")
   ### outputs
   ###  dvidq_curr_mat
   ##println("dvidq_curr_mat_out_AX_J1 = 32'd",dvidq_curr_mat_test[1,1],"; dvidq_curr_mat_out_AX_J2 = 32'd",dvidq_curr_mat_test[1,2],"; dvidq_curr_mat_out_AX_J3 = 32'd",dvidq_curr_mat_test[1,3],";  dvidq_curr_mat_out_AX_J4 = 32'd",dvidq_curr_mat_test[1,4],"; dvidq_curr_mat_out_AX_J5 = 32'd",dvidq_curr_mat_test[1,5],"; dvidq_curr_mat_out_AX_J6 = 32'd",dvidq_curr_mat_test[1,6],"; dvidq_curr_mat_out_AX_J7 = 32'd",dvidq_curr_mat_test[1,7],";")
   ##println("dvidq_curr_mat_out_AY_J1 = 32'd",dvidq_curr_mat_test[2,1],"; dvidq_curr_mat_out_AY_J2 = 32'd",dvidq_curr_mat_test[2,2],"; dvidq_curr_mat_out_AY_J3 = 32'd",dvidq_curr_mat_test[2,3],";  dvidq_curr_mat_out_AY_J4 = 32'd",dvidq_curr_mat_test[2,4],"; dvidq_curr_mat_out_AY_J5 = 32'd",dvidq_curr_mat_test[2,5],"; dvidq_curr_mat_out_AY_J6 = 32'd",dvidq_curr_mat_test[2,6],"; dvidq_curr_mat_out_AY_J7 = 32'd",dvidq_curr_mat_test[2,7],";")
   ##println("dvidq_curr_mat_out_AZ_J1 = 32'd",dvidq_curr_mat_test[3,1],"; dvidq_curr_mat_out_AZ_J2 = 32'd",dvidq_curr_mat_test[3,2],"; dvidq_curr_mat_out_AZ_J3 = 32'd",dvidq_curr_mat_test[3,3],";  dvidq_curr_mat_out_AZ_J4 = 32'd",dvidq_curr_mat_test[3,4],"; dvidq_curr_mat_out_AZ_J5 = 32'd",dvidq_curr_mat_test[3,5],"; dvidq_curr_mat_out_AZ_J6 = 32'd",dvidq_curr_mat_test[3,6],"; dvidq_curr_mat_out_AZ_J7 = 32'd",dvidq_curr_mat_test[3,7],";")
   ##println("dvidq_curr_mat_out_LX_J1 = 32'd",dvidq_curr_mat_test[4,1],"; dvidq_curr_mat_out_LX_J2 = 32'd",dvidq_curr_mat_test[4,2],"; dvidq_curr_mat_out_LX_J3 = 32'd",dvidq_curr_mat_test[4,3],";  dvidq_curr_mat_out_LX_J4 = 32'd",dvidq_curr_mat_test[4,4],"; dvidq_curr_mat_out_LX_J5 = 32'd",dvidq_curr_mat_test[4,5],"; dvidq_curr_mat_out_LX_J6 = 32'd",dvidq_curr_mat_test[4,6],"; dvidq_curr_mat_out_LX_J7 = 32'd",dvidq_curr_mat_test[4,7],";")
   ##println("dvidq_curr_mat_out_LY_J1 = 32'd",dvidq_curr_mat_test[5,1],"; dvidq_curr_mat_out_LY_J2 = 32'd",dvidq_curr_mat_test[5,2],"; dvidq_curr_mat_out_LY_J3 = 32'd",dvidq_curr_mat_test[5,3],";  dvidq_curr_mat_out_LY_J4 = 32'd",dvidq_curr_mat_test[5,4],"; dvidq_curr_mat_out_LY_J5 = 32'd",dvidq_curr_mat_test[5,5],"; dvidq_curr_mat_out_LY_J6 = 32'd",dvidq_curr_mat_test[5,6],"; dvidq_curr_mat_out_LY_J7 = 32'd",dvidq_curr_mat_test[5,7],";")
   ##println("dvidq_curr_mat_out_LZ_J1 = 32'd",dvidq_curr_mat_test[6,1],"; dvidq_curr_mat_out_LZ_J2 = 32'd",dvidq_curr_mat_test[6,2],"; dvidq_curr_mat_out_LZ_J3 = 32'd",dvidq_curr_mat_test[6,3],";  dvidq_curr_mat_out_LZ_J4 = 32'd",dvidq_curr_mat_test[6,4],"; dvidq_curr_mat_out_LZ_J5 = 32'd",dvidq_curr_mat_test[6,5],"; dvidq_curr_mat_out_LZ_J6 = 32'd",dvidq_curr_mat_test[6,6],"; dvidq_curr_mat_out_LZ_J7 = 32'd",dvidq_curr_mat_test[6,7],";")
   ###  daidq_curr_mat
   ##println("daidq_curr_mat_out_AX_J1 = 32'd",daidq_curr_mat_test[1,1],"; daidq_curr_mat_out_AX_J2 = 32'd",daidq_curr_mat_test[1,2],"; daidq_curr_mat_out_AX_J3 = 32'd",daidq_curr_mat_test[1,3],";  daidq_curr_mat_out_AX_J4 = 32'd",daidq_curr_mat_test[1,4],"; daidq_curr_mat_out_AX_J5 = 32'd",daidq_curr_mat_test[1,5],"; daidq_curr_mat_out_AX_J6 = 32'd",daidq_curr_mat_test[1,6],"; daidq_curr_mat_out_AX_J7 = 32'd",daidq_curr_mat_test[1,7],";")
   ##println("daidq_curr_mat_out_AY_J1 = 32'd",daidq_curr_mat_test[2,1],"; daidq_curr_mat_out_AY_J2 = 32'd",daidq_curr_mat_test[2,2],"; daidq_curr_mat_out_AY_J3 = 32'd",daidq_curr_mat_test[2,3],";  daidq_curr_mat_out_AY_J4 = 32'd",daidq_curr_mat_test[2,4],"; daidq_curr_mat_out_AY_J5 = 32'd",daidq_curr_mat_test[2,5],"; daidq_curr_mat_out_AY_J6 = 32'd",daidq_curr_mat_test[2,6],"; daidq_curr_mat_out_AY_J7 = 32'd",daidq_curr_mat_test[2,7],";")
   ##println("daidq_curr_mat_out_AZ_J1 = 32'd",daidq_curr_mat_test[3,1],"; daidq_curr_mat_out_AZ_J2 = 32'd",daidq_curr_mat_test[3,2],"; daidq_curr_mat_out_AZ_J3 = 32'd",daidq_curr_mat_test[3,3],";  daidq_curr_mat_out_AZ_J4 = 32'd",daidq_curr_mat_test[3,4],"; daidq_curr_mat_out_AZ_J5 = 32'd",daidq_curr_mat_test[3,5],"; daidq_curr_mat_out_AZ_J6 = 32'd",daidq_curr_mat_test[3,6],"; daidq_curr_mat_out_AZ_J7 = 32'd",daidq_curr_mat_test[3,7],";")
   ##println("daidq_curr_mat_out_LX_J1 = 32'd",daidq_curr_mat_test[4,1],"; daidq_curr_mat_out_LX_J2 = 32'd",daidq_curr_mat_test[4,2],"; daidq_curr_mat_out_LX_J3 = 32'd",daidq_curr_mat_test[4,3],";  daidq_curr_mat_out_LX_J4 = 32'd",daidq_curr_mat_test[4,4],"; daidq_curr_mat_out_LX_J5 = 32'd",daidq_curr_mat_test[4,5],"; daidq_curr_mat_out_LX_J6 = 32'd",daidq_curr_mat_test[4,6],"; daidq_curr_mat_out_LX_J7 = 32'd",daidq_curr_mat_test[4,7],";")
   ##println("daidq_curr_mat_out_LY_J1 = 32'd",daidq_curr_mat_test[5,1],"; daidq_curr_mat_out_LY_J2 = 32'd",daidq_curr_mat_test[5,2],"; daidq_curr_mat_out_LY_J3 = 32'd",daidq_curr_mat_test[5,3],";  daidq_curr_mat_out_LY_J4 = 32'd",daidq_curr_mat_test[5,4],"; daidq_curr_mat_out_LY_J5 = 32'd",daidq_curr_mat_test[5,5],"; daidq_curr_mat_out_LY_J6 = 32'd",daidq_curr_mat_test[5,6],"; daidq_curr_mat_out_LY_J7 = 32'd",daidq_curr_mat_test[5,7],";")
   ##println("daidq_curr_mat_out_LZ_J1 = 32'd",daidq_curr_mat_test[6,1],"; daidq_curr_mat_out_LZ_J2 = 32'd",daidq_curr_mat_test[6,2],"; daidq_curr_mat_out_LZ_J3 = 32'd",daidq_curr_mat_test[6,3],";  daidq_curr_mat_out_LZ_J4 = 32'd",daidq_curr_mat_test[6,4],"; daidq_curr_mat_out_LZ_J5 = 32'd",daidq_curr_mat_test[6,5],"; daidq_curr_mat_out_LZ_J6 = 32'd",daidq_curr_mat_test[6,6],"; daidq_curr_mat_out_LZ_J7 = 32'd",daidq_curr_mat_test[6,7],";")
   ###  dfidq_curr_mat
   ##println("dfidq_curr_mat_out_AX_J1 = 32'd",dfidq_curr_mat_test[1,1],"; dfidq_curr_mat_out_AX_J2 = 32'd",dfidq_curr_mat_test[1,2],"; dfidq_curr_mat_out_AX_J3 = 32'd",dfidq_curr_mat_test[1,3],";  dfidq_curr_mat_out_AX_J4 = 32'd",dfidq_curr_mat_test[1,4],"; dfidq_curr_mat_out_AX_J5 = 32'd",dfidq_curr_mat_test[1,5],"; dfidq_curr_mat_out_AX_J6 = 32'd",dfidq_curr_mat_test[1,6],"; dfidq_curr_mat_out_AX_J7 = 32'd",dfidq_curr_mat_test[1,7],";")
   ##println("dfidq_curr_mat_out_AY_J1 = 32'd",dfidq_curr_mat_test[2,1],"; dfidq_curr_mat_out_AY_J2 = 32'd",dfidq_curr_mat_test[2,2],"; dfidq_curr_mat_out_AY_J3 = 32'd",dfidq_curr_mat_test[2,3],";  dfidq_curr_mat_out_AY_J4 = 32'd",dfidq_curr_mat_test[2,4],"; dfidq_curr_mat_out_AY_J5 = 32'd",dfidq_curr_mat_test[2,5],"; dfidq_curr_mat_out_AY_J6 = 32'd",dfidq_curr_mat_test[2,6],"; dfidq_curr_mat_out_AY_J7 = 32'd",dfidq_curr_mat_test[2,7],";")
   ##println("dfidq_curr_mat_out_AZ_J1 = 32'd",dfidq_curr_mat_test[3,1],"; dfidq_curr_mat_out_AZ_J2 = 32'd",dfidq_curr_mat_test[3,2],"; dfidq_curr_mat_out_AZ_J3 = 32'd",dfidq_curr_mat_test[3,3],";  dfidq_curr_mat_out_AZ_J4 = 32'd",dfidq_curr_mat_test[3,4],"; dfidq_curr_mat_out_AZ_J5 = 32'd",dfidq_curr_mat_test[3,5],"; dfidq_curr_mat_out_AZ_J6 = 32'd",dfidq_curr_mat_test[3,6],"; dfidq_curr_mat_out_AZ_J7 = 32'd",dfidq_curr_mat_test[3,7],";")
   ##println("dfidq_curr_mat_out_LX_J1 = 32'd",dfidq_curr_mat_test[4,1],"; dfidq_curr_mat_out_LX_J2 = 32'd",dfidq_curr_mat_test[4,2],"; dfidq_curr_mat_out_LX_J3 = 32'd",dfidq_curr_mat_test[4,3],";  dfidq_curr_mat_out_LX_J4 = 32'd",dfidq_curr_mat_test[4,4],"; dfidq_curr_mat_out_LX_J5 = 32'd",dfidq_curr_mat_test[4,5],"; dfidq_curr_mat_out_LX_J6 = 32'd",dfidq_curr_mat_test[4,6],"; dfidq_curr_mat_out_LX_J7 = 32'd",dfidq_curr_mat_test[4,7],";")
   ##println("dfidq_curr_mat_out_LY_J1 = 32'd",dfidq_curr_mat_test[5,1],"; dfidq_curr_mat_out_LY_J2 = 32'd",dfidq_curr_mat_test[5,2],"; dfidq_curr_mat_out_LY_J3 = 32'd",dfidq_curr_mat_test[5,3],";  dfidq_curr_mat_out_LY_J4 = 32'd",dfidq_curr_mat_test[5,4],"; dfidq_curr_mat_out_LY_J5 = 32'd",dfidq_curr_mat_test[5,5],"; dfidq_curr_mat_out_LY_J6 = 32'd",dfidq_curr_mat_test[5,6],"; dfidq_curr_mat_out_LY_J7 = 32'd",dfidq_curr_mat_test[5,7],";")
   ##println("dfidq_curr_mat_out_LZ_J1 = 32'd",dfidq_curr_mat_test[6,1],"; dfidq_curr_mat_out_LZ_J2 = 32'd",dfidq_curr_mat_test[6,2],"; dfidq_curr_mat_out_LZ_J3 = 32'd",dfidq_curr_mat_test[6,3],";  dfidq_curr_mat_out_LZ_J4 = 32'd",dfidq_curr_mat_test[6,4],"; dfidq_curr_mat_out_LZ_J5 = 32'd",dfidq_curr_mat_test[6,5],"; dfidq_curr_mat_out_LZ_J6 = 32'd",dfidq_curr_mat_test[6,6],"; dfidq_curr_mat_out_LZ_J7 = 32'd",dfidq_curr_mat_test[6,7],";")
   ###  dvidqd_curr_mat
   ##println("dvidqd_curr_mat_out_AX_J1 = 32'd",dvidqd_curr_mat_test[1,1],"; dvidqd_curr_mat_out_AX_J2 = 32'd",dvidqd_curr_mat_test[1,2],"; dvidqd_curr_mat_out_AX_J3 = 32'd",dvidqd_curr_mat_test[1,3],";  dvidqd_curr_mat_out_AX_J4 = 32'd",dvidqd_curr_mat_test[1,4],"; dvidqd_curr_mat_out_AX_J5 = 32'd",dvidqd_curr_mat_test[1,5],"; dvidqd_curr_mat_out_AX_J6 = 32'd",dvidqd_curr_mat_test[1,6],"; dvidqd_curr_mat_out_AX_J7 = 32'd",dvidqd_curr_mat_test[1,7],";")
   ##println("dvidqd_curr_mat_out_AY_J1 = 32'd",dvidqd_curr_mat_test[2,1],"; dvidqd_curr_mat_out_AY_J2 = 32'd",dvidqd_curr_mat_test[2,2],"; dvidqd_curr_mat_out_AY_J3 = 32'd",dvidqd_curr_mat_test[2,3],";  dvidqd_curr_mat_out_AY_J4 = 32'd",dvidqd_curr_mat_test[2,4],"; dvidqd_curr_mat_out_AY_J5 = 32'd",dvidqd_curr_mat_test[2,5],"; dvidqd_curr_mat_out_AY_J6 = 32'd",dvidqd_curr_mat_test[2,6],"; dvidqd_curr_mat_out_AY_J7 = 32'd",dvidqd_curr_mat_test[2,7],";")
   ##println("dvidqd_curr_mat_out_AZ_J1 = 32'd",dvidqd_curr_mat_test[3,1],"; dvidqd_curr_mat_out_AZ_J2 = 32'd",dvidqd_curr_mat_test[3,2],"; dvidqd_curr_mat_out_AZ_J3 = 32'd",dvidqd_curr_mat_test[3,3],";  dvidqd_curr_mat_out_AZ_J4 = 32'd",dvidqd_curr_mat_test[3,4],"; dvidqd_curr_mat_out_AZ_J5 = 32'd",dvidqd_curr_mat_test[3,5],"; dvidqd_curr_mat_out_AZ_J6 = 32'd",dvidqd_curr_mat_test[3,6],"; dvidqd_curr_mat_out_AZ_J7 = 32'd",dvidqd_curr_mat_test[3,7],";")
   ##println("dvidqd_curr_mat_out_LX_J1 = 32'd",dvidqd_curr_mat_test[4,1],"; dvidqd_curr_mat_out_LX_J2 = 32'd",dvidqd_curr_mat_test[4,2],"; dvidqd_curr_mat_out_LX_J3 = 32'd",dvidqd_curr_mat_test[4,3],";  dvidqd_curr_mat_out_LX_J4 = 32'd",dvidqd_curr_mat_test[4,4],"; dvidqd_curr_mat_out_LX_J5 = 32'd",dvidqd_curr_mat_test[4,5],"; dvidqd_curr_mat_out_LX_J6 = 32'd",dvidqd_curr_mat_test[4,6],"; dvidqd_curr_mat_out_LX_J7 = 32'd",dvidqd_curr_mat_test[4,7],";")
   ##println("dvidqd_curr_mat_out_LY_J1 = 32'd",dvidqd_curr_mat_test[5,1],"; dvidqd_curr_mat_out_LY_J2 = 32'd",dvidqd_curr_mat_test[5,2],"; dvidqd_curr_mat_out_LY_J3 = 32'd",dvidqd_curr_mat_test[5,3],";  dvidqd_curr_mat_out_LY_J4 = 32'd",dvidqd_curr_mat_test[5,4],"; dvidqd_curr_mat_out_LY_J5 = 32'd",dvidqd_curr_mat_test[5,5],"; dvidqd_curr_mat_out_LY_J6 = 32'd",dvidqd_curr_mat_test[5,6],"; dvidqd_curr_mat_out_LY_J7 = 32'd",dvidqd_curr_mat_test[5,7],";")
   ##println("dvidqd_curr_mat_out_LZ_J1 = 32'd",dvidqd_curr_mat_test[6,1],"; dvidqd_curr_mat_out_LZ_J2 = 32'd",dvidqd_curr_mat_test[6,2],"; dvidqd_curr_mat_out_LZ_J3 = 32'd",dvidqd_curr_mat_test[6,3],";  dvidqd_curr_mat_out_LZ_J4 = 32'd",dvidqd_curr_mat_test[6,4],"; dvidqd_curr_mat_out_LZ_J5 = 32'd",dvidqd_curr_mat_test[6,5],"; dvidqd_curr_mat_out_LZ_J6 = 32'd",dvidqd_curr_mat_test[6,6],"; dvidqd_curr_mat_out_LZ_J7 = 32'd",dvidqd_curr_mat_test[6,7],";")
   ###  daidqd_curr_mat
   ##println("daidqd_curr_mat_out_AX_J1 = 32'd",daidqd_curr_mat_test[1,1],"; daidqd_curr_mat_out_AX_J2 = 32'd",daidqd_curr_mat_test[1,2],"; daidqd_curr_mat_out_AX_J3 = 32'd",daidqd_curr_mat_test[1,3],";  daidqd_curr_mat_out_AX_J4 = 32'd",daidqd_curr_mat_test[1,4],"; daidqd_curr_mat_out_AX_J5 = 32'd",daidqd_curr_mat_test[1,5],"; daidqd_curr_mat_out_AX_J6 = 32'd",daidqd_curr_mat_test[1,6],"; daidqd_curr_mat_out_AX_J7 = 32'd",daidqd_curr_mat_test[1,7],";")
   ##println("daidqd_curr_mat_out_AY_J1 = 32'd",daidqd_curr_mat_test[2,1],"; daidqd_curr_mat_out_AY_J2 = 32'd",daidqd_curr_mat_test[2,2],"; daidqd_curr_mat_out_AY_J3 = 32'd",daidqd_curr_mat_test[2,3],";  daidqd_curr_mat_out_AY_J4 = 32'd",daidqd_curr_mat_test[2,4],"; daidqd_curr_mat_out_AY_J5 = 32'd",daidqd_curr_mat_test[2,5],"; daidqd_curr_mat_out_AY_J6 = 32'd",daidqd_curr_mat_test[2,6],"; daidqd_curr_mat_out_AY_J7 = 32'd",daidqd_curr_mat_test[2,7],";")
   ##println("daidqd_curr_mat_out_AZ_J1 = 32'd",daidqd_curr_mat_test[3,1],"; daidqd_curr_mat_out_AZ_J2 = 32'd",daidqd_curr_mat_test[3,2],"; daidqd_curr_mat_out_AZ_J3 = 32'd",daidqd_curr_mat_test[3,3],";  daidqd_curr_mat_out_AZ_J4 = 32'd",daidqd_curr_mat_test[3,4],"; daidqd_curr_mat_out_AZ_J5 = 32'd",daidqd_curr_mat_test[3,5],"; daidqd_curr_mat_out_AZ_J6 = 32'd",daidqd_curr_mat_test[3,6],"; daidqd_curr_mat_out_AZ_J7 = 32'd",daidqd_curr_mat_test[3,7],";")
   ##println("daidqd_curr_mat_out_LX_J1 = 32'd",daidqd_curr_mat_test[4,1],"; daidqd_curr_mat_out_LX_J2 = 32'd",daidqd_curr_mat_test[4,2],"; daidqd_curr_mat_out_LX_J3 = 32'd",daidqd_curr_mat_test[4,3],";  daidqd_curr_mat_out_LX_J4 = 32'd",daidqd_curr_mat_test[4,4],"; daidqd_curr_mat_out_LX_J5 = 32'd",daidqd_curr_mat_test[4,5],"; daidqd_curr_mat_out_LX_J6 = 32'd",daidqd_curr_mat_test[4,6],"; daidqd_curr_mat_out_LX_J7 = 32'd",daidqd_curr_mat_test[4,7],";")
   ##println("daidqd_curr_mat_out_LY_J1 = 32'd",daidqd_curr_mat_test[5,1],"; daidqd_curr_mat_out_LY_J2 = 32'd",daidqd_curr_mat_test[5,2],"; daidqd_curr_mat_out_LY_J3 = 32'd",daidqd_curr_mat_test[5,3],";  daidqd_curr_mat_out_LY_J4 = 32'd",daidqd_curr_mat_test[5,4],"; daidqd_curr_mat_out_LY_J5 = 32'd",daidqd_curr_mat_test[5,5],"; daidqd_curr_mat_out_LY_J6 = 32'd",daidqd_curr_mat_test[5,6],"; daidqd_curr_mat_out_LY_J7 = 32'd",daidqd_curr_mat_test[5,7],";")
   ##println("daidqd_curr_mat_out_LZ_J1 = 32'd",daidqd_curr_mat_test[6,1],"; daidqd_curr_mat_out_LZ_J2 = 32'd",daidqd_curr_mat_test[6,2],"; daidqd_curr_mat_out_LZ_J3 = 32'd",daidqd_curr_mat_test[6,3],";  daidqd_curr_mat_out_LZ_J4 = 32'd",daidqd_curr_mat_test[6,4],"; daidqd_curr_mat_out_LZ_J5 = 32'd",daidqd_curr_mat_test[6,5],"; daidqd_curr_mat_out_LZ_J6 = 32'd",daidqd_curr_mat_test[6,6],"; daidqd_curr_mat_out_LZ_J7 = 32'd",daidqd_curr_mat_test[6,7],";")
   ###  dfidqd_curr_mat
   ##println("dfidqd_curr_mat_out_AX_J1 = 32'd",dfidqd_curr_mat_test[1,1],"; dfidqd_curr_mat_out_AX_J2 = 32'd",dfidqd_curr_mat_test[1,2],"; dfidqd_curr_mat_out_AX_J3 = 32'd",dfidqd_curr_mat_test[1,3],";  dfidqd_curr_mat_out_AX_J4 = 32'd",dfidqd_curr_mat_test[1,4],"; dfidqd_curr_mat_out_AX_J5 = 32'd",dfidqd_curr_mat_test[1,5],"; dfidqd_curr_mat_out_AX_J6 = 32'd",dfidqd_curr_mat_test[1,6],"; dfidqd_curr_mat_out_AX_J7 = 32'd",dfidqd_curr_mat_test[1,7],";")
   ##println("dfidqd_curr_mat_out_AY_J1 = 32'd",dfidqd_curr_mat_test[2,1],"; dfidqd_curr_mat_out_AY_J2 = 32'd",dfidqd_curr_mat_test[2,2],"; dfidqd_curr_mat_out_AY_J3 = 32'd",dfidqd_curr_mat_test[2,3],";  dfidqd_curr_mat_out_AY_J4 = 32'd",dfidqd_curr_mat_test[2,4],"; dfidqd_curr_mat_out_AY_J5 = 32'd",dfidqd_curr_mat_test[2,5],"; dfidqd_curr_mat_out_AY_J6 = 32'd",dfidqd_curr_mat_test[2,6],"; dfidqd_curr_mat_out_AY_J7 = 32'd",dfidqd_curr_mat_test[2,7],";")
   ##println("dfidqd_curr_mat_out_AZ_J1 = 32'd",dfidqd_curr_mat_test[3,1],"; dfidqd_curr_mat_out_AZ_J2 = 32'd",dfidqd_curr_mat_test[3,2],"; dfidqd_curr_mat_out_AZ_J3 = 32'd",dfidqd_curr_mat_test[3,3],";  dfidqd_curr_mat_out_AZ_J4 = 32'd",dfidqd_curr_mat_test[3,4],"; dfidqd_curr_mat_out_AZ_J5 = 32'd",dfidqd_curr_mat_test[3,5],"; dfidqd_curr_mat_out_AZ_J6 = 32'd",dfidqd_curr_mat_test[3,6],"; dfidqd_curr_mat_out_AZ_J7 = 32'd",dfidqd_curr_mat_test[3,7],";")
   ##println("dfidqd_curr_mat_out_LX_J1 = 32'd",dfidqd_curr_mat_test[4,1],"; dfidqd_curr_mat_out_LX_J2 = 32'd",dfidqd_curr_mat_test[4,2],"; dfidqd_curr_mat_out_LX_J3 = 32'd",dfidqd_curr_mat_test[4,3],";  dfidqd_curr_mat_out_LX_J4 = 32'd",dfidqd_curr_mat_test[4,4],"; dfidqd_curr_mat_out_LX_J5 = 32'd",dfidqd_curr_mat_test[4,5],"; dfidqd_curr_mat_out_LX_J6 = 32'd",dfidqd_curr_mat_test[4,6],"; dfidqd_curr_mat_out_LX_J7 = 32'd",dfidqd_curr_mat_test[4,7],";")
   ##println("dfidqd_curr_mat_out_LY_J1 = 32'd",dfidqd_curr_mat_test[5,1],"; dfidqd_curr_mat_out_LY_J2 = 32'd",dfidqd_curr_mat_test[5,2],"; dfidqd_curr_mat_out_LY_J3 = 32'd",dfidqd_curr_mat_test[5,3],";  dfidqd_curr_mat_out_LY_J4 = 32'd",dfidqd_curr_mat_test[5,4],"; dfidqd_curr_mat_out_LY_J5 = 32'd",dfidqd_curr_mat_test[5,5],"; dfidqd_curr_mat_out_LY_J6 = 32'd",dfidqd_curr_mat_test[5,6],"; dfidqd_curr_mat_out_LY_J7 = 32'd",dfidqd_curr_mat_test[5,7],";")
   ##println("dfidqd_curr_mat_out_LZ_J1 = 32'd",dfidqd_curr_mat_test[6,1],"; dfidqd_curr_mat_out_LZ_J2 = 32'd",dfidqd_curr_mat_test[6,2],"; dfidqd_curr_mat_out_LZ_J3 = 32'd",dfidqd_curr_mat_test[6,3],";  dfidqd_curr_mat_out_LZ_J4 = 32'd",dfidqd_curr_mat_test[6,4],"; dfidqd_curr_mat_out_LZ_J5 = 32'd",dfidqd_curr_mat_test[6,5],"; dfidqd_curr_mat_out_LZ_J6 = 32'd",dfidqd_curr_mat_test[6,6],"; dfidqd_curr_mat_out_LZ_J7 = 32'd",dfidqd_curr_mat_test[6,7],";")
   println("//------------------------------------------------------------------------")
   println("// Clock and Control Inputs")
   println("#5;")
   println("s1_bool_in = 1; s2_bool_in = 0; s3_bool_in = 0;")
   println("clk = 1;")
   println("#5;")
   println("clk = 0;")
   println("#5;")
   println("s1_bool_in = 0; s2_bool_in = 1; s3_bool_in = 0;")
   println("clk = 1;")
   println("#5;")
   println("clk = 0;")
   println("#5;")
   println("s1_bool_in = 0; s2_bool_in = 0; s3_bool_in = 1;")
   println("clk = 1;")
   println("#5;")
   println("clk = 0;")
   println("#5;")
   println("#50;")
   println("//------------------------------------------------------------------------")
   println("// Compare Outputs")
   println("\$display (\"//-------------------------------------------------------------------------------------------------------\");")
   # outputs
   #  dvidq_curr_mat
   println("// dv/dq")
   println("\$display (\"dvidq_curr_mat_ref = %d,%d,%d,%d,%d,%d,%d\", ",dvidq_curr_mat_test[1,1],", ",dvidq_curr_mat_test[1,2],", ",dvidq_curr_mat_test[1,3],", ",dvidq_curr_mat_test[1,4],", ",dvidq_curr_mat_test[1,5],", ",dvidq_curr_mat_test[1,6],", ",dvidq_curr_mat_test[1,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dvidq_curr_mat_test[2,1],", ",dvidq_curr_mat_test[2,2],", ",dvidq_curr_mat_test[2,3],", ",dvidq_curr_mat_test[2,4],", ",dvidq_curr_mat_test[2,5],", ",dvidq_curr_mat_test[2,6],", ",dvidq_curr_mat_test[2,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dvidq_curr_mat_test[3,1],", ",dvidq_curr_mat_test[3,2],", ",dvidq_curr_mat_test[3,3],", ",dvidq_curr_mat_test[3,4],", ",dvidq_curr_mat_test[3,5],", ",dvidq_curr_mat_test[3,6],", ",dvidq_curr_mat_test[3,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dvidq_curr_mat_test[4,1],", ",dvidq_curr_mat_test[4,2],", ",dvidq_curr_mat_test[4,3],", ",dvidq_curr_mat_test[4,4],", ",dvidq_curr_mat_test[4,5],", ",dvidq_curr_mat_test[4,6],", ",dvidq_curr_mat_test[4,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dvidq_curr_mat_test[5,1],", ",dvidq_curr_mat_test[5,2],", ",dvidq_curr_mat_test[5,3],", ",dvidq_curr_mat_test[5,4],", ",dvidq_curr_mat_test[5,5],", ",dvidq_curr_mat_test[5,6],", ",dvidq_curr_mat_test[5,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dvidq_curr_mat_test[6,1],", ",dvidq_curr_mat_test[6,2],", ",dvidq_curr_mat_test[6,3],", ",dvidq_curr_mat_test[6,4],", ",dvidq_curr_mat_test[6,5],", ",dvidq_curr_mat_test[6,6],", ",dvidq_curr_mat_test[6,7],");")
   println("\$display (\"\\n\");")
   println("\$display (\"dvidq_curr_mat_out = %d,%d,%d,%d,%d,%d,%d\", dvidq_curr_mat_out_AX_J1,dvidq_curr_mat_out_AX_J2,dvidq_curr_mat_out_AX_J3,dvidq_curr_mat_out_AX_J4,dvidq_curr_mat_out_AX_J5,dvidq_curr_mat_out_AX_J6,dvidq_curr_mat_out_AX_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dvidq_curr_mat_out_AY_J1,dvidq_curr_mat_out_AY_J2,dvidq_curr_mat_out_AY_J3,dvidq_curr_mat_out_AY_J4,dvidq_curr_mat_out_AY_J5,dvidq_curr_mat_out_AY_J6,dvidq_curr_mat_out_AY_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dvidq_curr_mat_out_AZ_J1,dvidq_curr_mat_out_AZ_J2,dvidq_curr_mat_out_AZ_J3,dvidq_curr_mat_out_AZ_J4,dvidq_curr_mat_out_AZ_J5,dvidq_curr_mat_out_AZ_J6,dvidq_curr_mat_out_AZ_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dvidq_curr_mat_out_LX_J1,dvidq_curr_mat_out_LX_J2,dvidq_curr_mat_out_LX_J3,dvidq_curr_mat_out_LX_J4,dvidq_curr_mat_out_LX_J5,dvidq_curr_mat_out_LX_J6,dvidq_curr_mat_out_LX_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dvidq_curr_mat_out_LY_J1,dvidq_curr_mat_out_LY_J2,dvidq_curr_mat_out_LY_J3,dvidq_curr_mat_out_LY_J4,dvidq_curr_mat_out_LY_J5,dvidq_curr_mat_out_LY_J6,dvidq_curr_mat_out_LY_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dvidq_curr_mat_out_LZ_J1,dvidq_curr_mat_out_LZ_J2,dvidq_curr_mat_out_LZ_J3,dvidq_curr_mat_out_LZ_J4,dvidq_curr_mat_out_LZ_J5,dvidq_curr_mat_out_LZ_J6,dvidq_curr_mat_out_LZ_J7);")
   println("\$display (\"//-------------------------------------------------------------------------------------------------------\");")
   #  daidq_curr_mat
   println("// da/dq")
   println("\$display (\"daidq_curr_mat_ref = %d,%d,%d,%d,%d,%d,%d\", ",daidq_curr_mat_test[1,1],", ",daidq_curr_mat_test[1,2],", ",daidq_curr_mat_test[1,3],", ",daidq_curr_mat_test[1,4],", ",daidq_curr_mat_test[1,5],", ",daidq_curr_mat_test[1,6],", ",daidq_curr_mat_test[1,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",daidq_curr_mat_test[2,1],", ",daidq_curr_mat_test[2,2],", ",daidq_curr_mat_test[2,3],", ",daidq_curr_mat_test[2,4],", ",daidq_curr_mat_test[2,5],", ",daidq_curr_mat_test[2,6],", ",daidq_curr_mat_test[2,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",daidq_curr_mat_test[3,1],", ",daidq_curr_mat_test[3,2],", ",daidq_curr_mat_test[3,3],", ",daidq_curr_mat_test[3,4],", ",daidq_curr_mat_test[3,5],", ",daidq_curr_mat_test[3,6],", ",daidq_curr_mat_test[3,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",daidq_curr_mat_test[4,1],", ",daidq_curr_mat_test[4,2],", ",daidq_curr_mat_test[4,3],", ",daidq_curr_mat_test[4,4],", ",daidq_curr_mat_test[4,5],", ",daidq_curr_mat_test[4,6],", ",daidq_curr_mat_test[4,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",daidq_curr_mat_test[5,1],", ",daidq_curr_mat_test[5,2],", ",daidq_curr_mat_test[5,3],", ",daidq_curr_mat_test[5,4],", ",daidq_curr_mat_test[5,5],", ",daidq_curr_mat_test[5,6],", ",daidq_curr_mat_test[5,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",daidq_curr_mat_test[6,1],", ",daidq_curr_mat_test[6,2],", ",daidq_curr_mat_test[6,3],", ",daidq_curr_mat_test[6,4],", ",daidq_curr_mat_test[6,5],", ",daidq_curr_mat_test[6,6],", ",daidq_curr_mat_test[6,7],");")
   println("\$display (\"\\n\");")
   println("\$display (\"daidq_curr_mat_out = %d,%d,%d,%d,%d,%d,%d\", daidq_curr_mat_out_AX_J1,daidq_curr_mat_out_AX_J2,daidq_curr_mat_out_AX_J3,daidq_curr_mat_out_AX_J4,daidq_curr_mat_out_AX_J5,daidq_curr_mat_out_AX_J6,daidq_curr_mat_out_AX_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", daidq_curr_mat_out_AY_J1,daidq_curr_mat_out_AY_J2,daidq_curr_mat_out_AY_J3,daidq_curr_mat_out_AY_J4,daidq_curr_mat_out_AY_J5,daidq_curr_mat_out_AY_J6,daidq_curr_mat_out_AY_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", daidq_curr_mat_out_AZ_J1,daidq_curr_mat_out_AZ_J2,daidq_curr_mat_out_AZ_J3,daidq_curr_mat_out_AZ_J4,daidq_curr_mat_out_AZ_J5,daidq_curr_mat_out_AZ_J6,daidq_curr_mat_out_AZ_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", daidq_curr_mat_out_LX_J1,daidq_curr_mat_out_LX_J2,daidq_curr_mat_out_LX_J3,daidq_curr_mat_out_LX_J4,daidq_curr_mat_out_LX_J5,daidq_curr_mat_out_LX_J6,daidq_curr_mat_out_LX_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", daidq_curr_mat_out_LY_J1,daidq_curr_mat_out_LY_J2,daidq_curr_mat_out_LY_J3,daidq_curr_mat_out_LY_J4,daidq_curr_mat_out_LY_J5,daidq_curr_mat_out_LY_J6,daidq_curr_mat_out_LY_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", daidq_curr_mat_out_LZ_J1,daidq_curr_mat_out_LZ_J2,daidq_curr_mat_out_LZ_J3,daidq_curr_mat_out_LZ_J4,daidq_curr_mat_out_LZ_J5,daidq_curr_mat_out_LZ_J6,daidq_curr_mat_out_LZ_J7);")
   println("\$display (\"//-------------------------------------------------------------------------------------------------------\");")
   #  dfidq_curr_mat
   println("// df/dq")
   println("\$display (\"dfidq_curr_mat_ref = %d,%d,%d,%d,%d,%d,%d\", ",dfidq_curr_mat_test[1,1],", ",dfidq_curr_mat_test[1,2],", ",dfidq_curr_mat_test[1,3],", ",dfidq_curr_mat_test[1,4],", ",dfidq_curr_mat_test[1,5],", ",dfidq_curr_mat_test[1,6],", ",dfidq_curr_mat_test[1,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dfidq_curr_mat_test[2,1],", ",dfidq_curr_mat_test[2,2],", ",dfidq_curr_mat_test[2,3],", ",dfidq_curr_mat_test[2,4],", ",dfidq_curr_mat_test[2,5],", ",dfidq_curr_mat_test[2,6],", ",dfidq_curr_mat_test[2,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dfidq_curr_mat_test[3,1],", ",dfidq_curr_mat_test[3,2],", ",dfidq_curr_mat_test[3,3],", ",dfidq_curr_mat_test[3,4],", ",dfidq_curr_mat_test[3,5],", ",dfidq_curr_mat_test[3,6],", ",dfidq_curr_mat_test[3,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dfidq_curr_mat_test[4,1],", ",dfidq_curr_mat_test[4,2],", ",dfidq_curr_mat_test[4,3],", ",dfidq_curr_mat_test[4,4],", ",dfidq_curr_mat_test[4,5],", ",dfidq_curr_mat_test[4,6],", ",dfidq_curr_mat_test[4,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dfidq_curr_mat_test[5,1],", ",dfidq_curr_mat_test[5,2],", ",dfidq_curr_mat_test[5,3],", ",dfidq_curr_mat_test[5,4],", ",dfidq_curr_mat_test[5,5],", ",dfidq_curr_mat_test[5,6],", ",dfidq_curr_mat_test[5,7],");")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dfidq_curr_mat_test[6,1],", ",dfidq_curr_mat_test[6,2],", ",dfidq_curr_mat_test[6,3],", ",dfidq_curr_mat_test[6,4],", ",dfidq_curr_mat_test[6,5],", ",dfidq_curr_mat_test[6,6],", ",dfidq_curr_mat_test[6,7],");")
   println("\$display (\"\\n\");")
   println("\$display (\"dfidq_curr_mat_out = %d,%d,%d,%d,%d,%d,%d\", dfidq_curr_mat_out_AX_J1,dfidq_curr_mat_out_AX_J2,dfidq_curr_mat_out_AX_J3,dfidq_curr_mat_out_AX_J4,dfidq_curr_mat_out_AX_J5,dfidq_curr_mat_out_AX_J6,dfidq_curr_mat_out_AX_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dfidq_curr_mat_out_AY_J1,dfidq_curr_mat_out_AY_J2,dfidq_curr_mat_out_AY_J3,dfidq_curr_mat_out_AY_J4,dfidq_curr_mat_out_AY_J5,dfidq_curr_mat_out_AY_J6,dfidq_curr_mat_out_AY_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dfidq_curr_mat_out_AZ_J1,dfidq_curr_mat_out_AZ_J2,dfidq_curr_mat_out_AZ_J3,dfidq_curr_mat_out_AZ_J4,dfidq_curr_mat_out_AZ_J5,dfidq_curr_mat_out_AZ_J6,dfidq_curr_mat_out_AZ_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dfidq_curr_mat_out_LX_J1,dfidq_curr_mat_out_LX_J2,dfidq_curr_mat_out_LX_J3,dfidq_curr_mat_out_LX_J4,dfidq_curr_mat_out_LX_J5,dfidq_curr_mat_out_LX_J6,dfidq_curr_mat_out_LX_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dfidq_curr_mat_out_LY_J1,dfidq_curr_mat_out_LY_J2,dfidq_curr_mat_out_LY_J3,dfidq_curr_mat_out_LY_J4,dfidq_curr_mat_out_LY_J5,dfidq_curr_mat_out_LY_J6,dfidq_curr_mat_out_LY_J7);")
   println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dfidq_curr_mat_out_LZ_J1,dfidq_curr_mat_out_LZ_J2,dfidq_curr_mat_out_LZ_J3,dfidq_curr_mat_out_LZ_J4,dfidq_curr_mat_out_LZ_J5,dfidq_curr_mat_out_LZ_J6,dfidq_curr_mat_out_LZ_J7);")
   println("\$display (\"//-------------------------------------------------------------------------------------------------------\");")
   #  dvidqd_curr_mat
   println("// dv/dqd")
   println("\$display (\"dvidqd_curr_mat_ref = %d,%d,%d,%d,%d,%d,%d\", ",dvidqd_curr_mat_test[1,1],", ",dvidqd_curr_mat_test[1,2],", ",dvidqd_curr_mat_test[1,3],", ",dvidqd_curr_mat_test[1,4],", ",dvidqd_curr_mat_test[1,5],", ",dvidqd_curr_mat_test[1,6],", ",dvidqd_curr_mat_test[1,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dvidqd_curr_mat_test[2,1],", ",dvidqd_curr_mat_test[2,2],", ",dvidqd_curr_mat_test[2,3],", ",dvidqd_curr_mat_test[2,4],", ",dvidqd_curr_mat_test[2,5],", ",dvidqd_curr_mat_test[2,6],", ",dvidqd_curr_mat_test[2,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dvidqd_curr_mat_test[3,1],", ",dvidqd_curr_mat_test[3,2],", ",dvidqd_curr_mat_test[3,3],", ",dvidqd_curr_mat_test[3,4],", ",dvidqd_curr_mat_test[3,5],", ",dvidqd_curr_mat_test[3,6],", ",dvidqd_curr_mat_test[3,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dvidqd_curr_mat_test[4,1],", ",dvidqd_curr_mat_test[4,2],", ",dvidqd_curr_mat_test[4,3],", ",dvidqd_curr_mat_test[4,4],", ",dvidqd_curr_mat_test[4,5],", ",dvidqd_curr_mat_test[4,6],", ",dvidqd_curr_mat_test[4,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dvidqd_curr_mat_test[5,1],", ",dvidqd_curr_mat_test[5,2],", ",dvidqd_curr_mat_test[5,3],", ",dvidqd_curr_mat_test[5,4],", ",dvidqd_curr_mat_test[5,5],", ",dvidqd_curr_mat_test[5,6],", ",dvidqd_curr_mat_test[5,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dvidqd_curr_mat_test[6,1],", ",dvidqd_curr_mat_test[6,2],", ",dvidqd_curr_mat_test[6,3],", ",dvidqd_curr_mat_test[6,4],", ",dvidqd_curr_mat_test[6,5],", ",dvidqd_curr_mat_test[6,6],", ",dvidqd_curr_mat_test[6,7],");")
   println("\$display (\"\\n\");")
   println("\$display (\"dvidqd_curr_mat_out = %d,%d,%d,%d,%d,%d,%d\", dvidqd_curr_mat_out_AX_J1,dvidqd_curr_mat_out_AX_J2,dvidqd_curr_mat_out_AX_J3,dvidqd_curr_mat_out_AX_J4,dvidqd_curr_mat_out_AX_J5,dvidqd_curr_mat_out_AX_J6,dvidqd_curr_mat_out_AX_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dvidqd_curr_mat_out_AY_J1,dvidqd_curr_mat_out_AY_J2,dvidqd_curr_mat_out_AY_J3,dvidqd_curr_mat_out_AY_J4,dvidqd_curr_mat_out_AY_J5,dvidqd_curr_mat_out_AY_J6,dvidqd_curr_mat_out_AY_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dvidqd_curr_mat_out_AZ_J1,dvidqd_curr_mat_out_AZ_J2,dvidqd_curr_mat_out_AZ_J3,dvidqd_curr_mat_out_AZ_J4,dvidqd_curr_mat_out_AZ_J5,dvidqd_curr_mat_out_AZ_J6,dvidqd_curr_mat_out_AZ_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dvidqd_curr_mat_out_LX_J1,dvidqd_curr_mat_out_LX_J2,dvidqd_curr_mat_out_LX_J3,dvidqd_curr_mat_out_LX_J4,dvidqd_curr_mat_out_LX_J5,dvidqd_curr_mat_out_LX_J6,dvidqd_curr_mat_out_LX_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dvidqd_curr_mat_out_LY_J1,dvidqd_curr_mat_out_LY_J2,dvidqd_curr_mat_out_LY_J3,dvidqd_curr_mat_out_LY_J4,dvidqd_curr_mat_out_LY_J5,dvidqd_curr_mat_out_LY_J6,dvidqd_curr_mat_out_LY_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dvidqd_curr_mat_out_LZ_J1,dvidqd_curr_mat_out_LZ_J2,dvidqd_curr_mat_out_LZ_J3,dvidqd_curr_mat_out_LZ_J4,dvidqd_curr_mat_out_LZ_J5,dvidqd_curr_mat_out_LZ_J6,dvidqd_curr_mat_out_LZ_J7);")
   println("\$display (\"//-------------------------------------------------------------------------------------------------------\");")
   #  daidqd_curr_mat
   println("// da/dqd")
   println("\$display (\"daidqd_curr_mat_ref = %d,%d,%d,%d,%d,%d,%d\", ",daidqd_curr_mat_test[1,1],", ",daidqd_curr_mat_test[1,2],", ",daidqd_curr_mat_test[1,3],", ",daidqd_curr_mat_test[1,4],", ",daidqd_curr_mat_test[1,5],", ",daidqd_curr_mat_test[1,6],", ",daidqd_curr_mat_test[1,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",daidqd_curr_mat_test[2,1],", ",daidqd_curr_mat_test[2,2],", ",daidqd_curr_mat_test[2,3],", ",daidqd_curr_mat_test[2,4],", ",daidqd_curr_mat_test[2,5],", ",daidqd_curr_mat_test[2,6],", ",daidqd_curr_mat_test[2,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",daidqd_curr_mat_test[3,1],", ",daidqd_curr_mat_test[3,2],", ",daidqd_curr_mat_test[3,3],", ",daidqd_curr_mat_test[3,4],", ",daidqd_curr_mat_test[3,5],", ",daidqd_curr_mat_test[3,6],", ",daidqd_curr_mat_test[3,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",daidqd_curr_mat_test[4,1],", ",daidqd_curr_mat_test[4,2],", ",daidqd_curr_mat_test[4,3],", ",daidqd_curr_mat_test[4,4],", ",daidqd_curr_mat_test[4,5],", ",daidqd_curr_mat_test[4,6],", ",daidqd_curr_mat_test[4,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",daidqd_curr_mat_test[5,1],", ",daidqd_curr_mat_test[5,2],", ",daidqd_curr_mat_test[5,3],", ",daidqd_curr_mat_test[5,4],", ",daidqd_curr_mat_test[5,5],", ",daidqd_curr_mat_test[5,6],", ",daidqd_curr_mat_test[5,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",daidqd_curr_mat_test[6,1],", ",daidqd_curr_mat_test[6,2],", ",daidqd_curr_mat_test[6,3],", ",daidqd_curr_mat_test[6,4],", ",daidqd_curr_mat_test[6,5],", ",daidqd_curr_mat_test[6,6],", ",daidqd_curr_mat_test[6,7],");")
   println("\$display (\"\\n\");")
   println("\$display (\"daidqd_curr_mat_out = %d,%d,%d,%d,%d,%d,%d\", daidqd_curr_mat_out_AX_J1,daidqd_curr_mat_out_AX_J2,daidqd_curr_mat_out_AX_J3,daidqd_curr_mat_out_AX_J4,daidqd_curr_mat_out_AX_J5,daidqd_curr_mat_out_AX_J6,daidqd_curr_mat_out_AX_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", daidqd_curr_mat_out_AY_J1,daidqd_curr_mat_out_AY_J2,daidqd_curr_mat_out_AY_J3,daidqd_curr_mat_out_AY_J4,daidqd_curr_mat_out_AY_J5,daidqd_curr_mat_out_AY_J6,daidqd_curr_mat_out_AY_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", daidqd_curr_mat_out_AZ_J1,daidqd_curr_mat_out_AZ_J2,daidqd_curr_mat_out_AZ_J3,daidqd_curr_mat_out_AZ_J4,daidqd_curr_mat_out_AZ_J5,daidqd_curr_mat_out_AZ_J6,daidqd_curr_mat_out_AZ_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", daidqd_curr_mat_out_LX_J1,daidqd_curr_mat_out_LX_J2,daidqd_curr_mat_out_LX_J3,daidqd_curr_mat_out_LX_J4,daidqd_curr_mat_out_LX_J5,daidqd_curr_mat_out_LX_J6,daidqd_curr_mat_out_LX_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", daidqd_curr_mat_out_LY_J1,daidqd_curr_mat_out_LY_J2,daidqd_curr_mat_out_LY_J3,daidqd_curr_mat_out_LY_J4,daidqd_curr_mat_out_LY_J5,daidqd_curr_mat_out_LY_J6,daidqd_curr_mat_out_LY_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", daidqd_curr_mat_out_LZ_J1,daidqd_curr_mat_out_LZ_J2,daidqd_curr_mat_out_LZ_J3,daidqd_curr_mat_out_LZ_J4,daidqd_curr_mat_out_LZ_J5,daidqd_curr_mat_out_LZ_J6,daidqd_curr_mat_out_LZ_J7);")
   println("\$display (\"//-------------------------------------------------------------------------------------------------------\");")
   #  dfidqd_curr_mat
   println("// df/dqd")
   println("\$display (\"dfidqd_curr_mat_ref = %d,%d,%d,%d,%d,%d,%d\", ",dfidqd_curr_mat_test[1,1],", ",dfidqd_curr_mat_test[1,2],", ",dfidqd_curr_mat_test[1,3],", ",dfidqd_curr_mat_test[1,4],", ",dfidqd_curr_mat_test[1,5],", ",dfidqd_curr_mat_test[1,6],", ",dfidqd_curr_mat_test[1,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dfidqd_curr_mat_test[2,1],", ",dfidqd_curr_mat_test[2,2],", ",dfidqd_curr_mat_test[2,3],", ",dfidqd_curr_mat_test[2,4],", ",dfidqd_curr_mat_test[2,5],", ",dfidqd_curr_mat_test[2,6],", ",dfidqd_curr_mat_test[2,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dfidqd_curr_mat_test[3,1],", ",dfidqd_curr_mat_test[3,2],", ",dfidqd_curr_mat_test[3,3],", ",dfidqd_curr_mat_test[3,4],", ",dfidqd_curr_mat_test[3,5],", ",dfidqd_curr_mat_test[3,6],", ",dfidqd_curr_mat_test[3,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dfidqd_curr_mat_test[4,1],", ",dfidqd_curr_mat_test[4,2],", ",dfidqd_curr_mat_test[4,3],", ",dfidqd_curr_mat_test[4,4],", ",dfidqd_curr_mat_test[4,5],", ",dfidqd_curr_mat_test[4,6],", ",dfidqd_curr_mat_test[4,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dfidqd_curr_mat_test[5,1],", ",dfidqd_curr_mat_test[5,2],", ",dfidqd_curr_mat_test[5,3],", ",dfidqd_curr_mat_test[5,4],", ",dfidqd_curr_mat_test[5,5],", ",dfidqd_curr_mat_test[5,6],", ",dfidqd_curr_mat_test[5,7],");")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dfidqd_curr_mat_test[6,1],", ",dfidqd_curr_mat_test[6,2],", ",dfidqd_curr_mat_test[6,3],", ",dfidqd_curr_mat_test[6,4],", ",dfidqd_curr_mat_test[6,5],", ",dfidqd_curr_mat_test[6,6],", ",dfidqd_curr_mat_test[6,7],");")
   println("\$display (\"\\n\");")
   println("\$display (\"dfidqd_curr_mat_out = %d,%d,%d,%d,%d,%d,%d\", dfidqd_curr_mat_out_AX_J1,dfidqd_curr_mat_out_AX_J2,dfidqd_curr_mat_out_AX_J3,dfidqd_curr_mat_out_AX_J4,dfidqd_curr_mat_out_AX_J5,dfidqd_curr_mat_out_AX_J6,dfidqd_curr_mat_out_AX_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dfidqd_curr_mat_out_AY_J1,dfidqd_curr_mat_out_AY_J2,dfidqd_curr_mat_out_AY_J3,dfidqd_curr_mat_out_AY_J4,dfidqd_curr_mat_out_AY_J5,dfidqd_curr_mat_out_AY_J6,dfidqd_curr_mat_out_AY_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dfidqd_curr_mat_out_AZ_J1,dfidqd_curr_mat_out_AZ_J2,dfidqd_curr_mat_out_AZ_J3,dfidqd_curr_mat_out_AZ_J4,dfidqd_curr_mat_out_AZ_J5,dfidqd_curr_mat_out_AZ_J6,dfidqd_curr_mat_out_AZ_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dfidqd_curr_mat_out_LX_J1,dfidqd_curr_mat_out_LX_J2,dfidqd_curr_mat_out_LX_J3,dfidqd_curr_mat_out_LX_J4,dfidqd_curr_mat_out_LX_J5,dfidqd_curr_mat_out_LX_J6,dfidqd_curr_mat_out_LX_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dfidqd_curr_mat_out_LY_J1,dfidqd_curr_mat_out_LY_J2,dfidqd_curr_mat_out_LY_J3,dfidqd_curr_mat_out_LY_J4,dfidqd_curr_mat_out_LY_J5,dfidqd_curr_mat_out_LY_J6,dfidqd_curr_mat_out_LY_J7);")
   println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dfidqd_curr_mat_out_LZ_J1,dfidqd_curr_mat_out_LZ_J2,dfidqd_curr_mat_out_LZ_J3,dfidqd_curr_mat_out_LZ_J4,dfidqd_curr_mat_out_LZ_J5,dfidqd_curr_mat_out_LZ_J6,dfidqd_curr_mat_out_LZ_J7);")
   println("\$display (\"//-------------------------------------------------------------------------------------------------------\");")
end

#-------------------------------------------------------------------------------
# Set Test Parameters and Run Test
#-------------------------------------------------------------------------------
fpRowTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ)
