# inputs_bpRow
#
# Format the Inputs for bprow.v

#-------------------------------------------------------------------------------
# Import Libraries
#-------------------------------------------------------------------------------
using LinearAlgebra
using FixedPointNumbers
using Test
using Printf
include("../../../type_generic/dynamics/helpers_iiwa.jl")
include("bpRow.jl") # bpRow

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
function bpRowTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,test_input,test_link)
   #----------------------------------------------------------------------------
   # Inputs and Expected Outputs
   #----------------------------------------------------------------------------
   # inputs
   qd = [0.999905, 0.251662, 0.986666, 0.555751, 0.437108, 0.424718, 0.773223]
   tXlist = [[0.956134 0.292928 0.0 0.0 0.0 0.0; -0.292928 0.956134 0.0 0.0 0.0 0.0; 0.0 0.0 1.0 0.0 0.0 0.0; -0.0461362 0.150591 0.0 0.956134 0.292928 0.0; -0.150591 -0.0461362 0.0 -0.292928 0.956134 0.0; 0.0 0.0 0.0 0.0 0.0 1.0], [-0.927773 0.0 0.373144 0.0 0.0 0.0; 0.373144 0.0 0.927773 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; 0.0 -0.187874 0.0 -0.927773 0.0 0.373144; 0.0 0.0755618 0.0 0.373144 0.0 0.927773; -0.2025 0.0 0.0 0.0 1.0 0.0], [-0.826669 0.0 -0.562689 0.0 0.0 0.0; -0.562689 0.0 0.826669 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; -0.11507 8.26669e-13 0.169054 -0.826669 0.0 -0.562689; 0.169054 5.62689e-13 0.11507 -0.562689 0.0 0.826669; 1.0e-12 0.0 0.0 0.0 1.0 0.0], [0.999945 0.0 -0.0104451 0.0 0.0 0.0; 0.0104451 0.0 0.999945 0.0 0.0 0.0; 0.0 -1.0 0.0 0.0 0.0 0.0; 0.0 0.215488 0.0 0.999945 0.0 -0.0104451; 0.0 0.00225091 0.0 0.0104451 0.0 0.999945; 0.2155 0.0 0.0 0.0 -1.0 0.0], [-0.668187 0.0 -0.743993 0.0 0.0 0.0; -0.743993 0.0 0.668187 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; -0.137267 6.68187e-13 0.123281 -0.668187 0.0 -0.743993; 0.123281 7.43993e-13 0.137267 -0.743993 0.0 0.668187; 1.0e-12 0.0 0.0 0.0 1.0 0.0], [0.951994 0.0 0.306117 0.0 0.0 0.0; -0.306117 0.0 0.951994 0.0 0.0 0.0; 0.0 -1.0 0.0 0.0 0.0 0.0; -6.12234e-13 0.205155 1.90399e-12 0.951994 0.0 0.306117; -1.90399e-12 -0.0659682 -6.12234e-13 -0.306117 0.0 0.951994; 0.2155 0.0 0.0 0.0 -1.0 0.0], [0.662605 0.0 0.748969 0.0 0.0 0.0; 0.748969 0.0 -0.662605 0.0 0.0 0.0; 0.0 1.0 0.0 0.0 0.0 0.0; 0.0606665 0.0 -0.053671 0.662605 0.0 0.748969; -0.053671 0.0 -0.0606665 0.748969 0.0 -0.662605; 0.0 0.0 0.0 0.0 1.0 0.0]]
   vlist = [[0.0; 0.0; 0.999905; 0.0; 0.0; 0.0], [0.373109; 0.927685; 0.251662; 0.0; 0.0; 0.0], [-0.450045; -0.00190277; 1.91435; -0.000389117; 0.0920342; 3.73109e-13], [-0.470016; 1.90955; 0.557654; -0.00079912; -8.34731e-6; -0.189019], [-0.100832; 0.722306; 2.34665; 0.274428; -0.107102; -8.34731e-6], [0.622359; 2.26487; -0.297588; 0.409436; -0.131664; 0.0853726], [0.189494; 0.663311; 3.03809; 0.388964; 0.234737; -0.131664]]
   alist = [[0.0; 0.0; 0.671362; 0.0; 0.0; 0.0], [0.483978; 0.528975; 2.08541; 0.0; 0.0; 0.0], [-1.5754; 1.89566; -0.391451; 0.387661; 0.32217; 4.83978e-13], [-0.509994; -0.146673; 3.56933; 0.796127; 0.00876021; -0.661668], [-1.99906; 2.80848; 25.7098; 0.423533; -0.727309; 0.00876021], [6.92905; 24.8232; 102.641; 0.926137; -0.480476; 0.296512], [81.9788; -62.9671; 76.9509; -4.07122; -6.40232; -0.480476]]
   flist = [[-0.386208; 0.368599; 0.28119; 0.818636; 1.98773; -3.07625], [0.0930661; 0.248573; 0.209472; -1.83265; -2.57865; 1.86775], [0.380028; 0.0151653; 0.251379; 0.210761; 2.40183; -2.49168], [0.925628; 0.297174; 0.0203749; -0.839812; -2.1552; -1.17263], [-0.376703; -0.860545; 0.287702; 0.13818; 1.44749; -1.98613], [0.0383153; 0.167; 0.859512; -0.890237; -1.39686; -1.30446], [0.122748; -0.0996843; 0.0769509; -1.83586; -2.03848; -0.211055]]
   dfidq_curr_mat_list_in = [[0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0],
                              [0.0 0.0413364 0.0 0.0 0.0 0.0 0.0; 0.0 -0.00192423 0.0 0.0 0.0 0.0 0.0; 0.0 -0.0307751 0.0 0.0 0.0 0.0 0.0; 0.0 0.128992 0.0 0.0 0.0 0.0 0.0; 0.0 -0.267149 0.0 0.0 0.0 0.0 0.0; 0.0 0.103539 0.0 0.0 0.0 0.0 0.0],
                              [0.0 -0.03999 0.238022 0.0 0.0 0.0 0.0; 0.0 -0.157892 0.320575 0.0 0.0 0.0 0.0; 0.0 0.0173565 -0.0457583 0.0 0.0 0.0 0.0; 0.0 -0.779274 1.55903 0.0 0.0 0.0 0.0; 0.0 0.0200287 -1.03789 0.0 0.0 0.0 0.0; 0.0 -0.870259 0.248148 0.0 0.0 0.0 0.0],
                              [0.0 0.012598 0.136545 0.0296131 0.0 0.0 0.0; 0.0 -0.0408688 0.0714059 0.0247565 0.0 0.0 0.0; 0.0 0.0900804 -0.1855 -0.105146 0.0 0.0 0.0; 0.0 -1.16174 2.08785 0.546813 0.0 0.0 0.0; 0.0 -0.851605 -0.143809 -0.812771 0.0 0.0 0.0; 0.0 0.0524322 1.35997 0.0208815 0.0 0.0 0.0],
                              [0.0 -0.0664353 0.0506626 0.109098 0.167419 0.0 0.0; 0.0 0.0703392 -0.194506 -0.110084 0.0882908 0.0 0.0; 0.0 -0.015841 0.0435314 0.0251287 -0.00860168 0.0 0.0; 0.0 0.741418 -2.09657 -1.00619 0.353863 0.0 0.0; 0.0 0.688614 -0.550317 -1.08058 -1.47426 0.0 0.0; 0.0 -0.954893 0.200673 -0.0710965 0.108659 0.0 0.0],
                              [0.0 0.00434036 -0.000527392 0.00394659 0.0142073 0.125122 0.0; 0.0 -0.00188286 -0.00112045 0.00377053 -0.00373699 -0.0256188 0.0; 0.0 -0.00230587 0.0128089 0.000358579 -0.0121177 -0.00593111 0.0; 0.0 0.493207 -2.44585 -1.37936 1.22403 -1.18016 0.0; 0.0 -1.70107 1.17756 0.982869 -0.395696 -1.96534 0.0; 0.0 -0.750141 0.705639 1.673 2.21509 0.0270107 0.0],
                              [0.0 -0.00236495 0.0105462 0.00705725 0.0019181 0.0285945 -0.0996847; 0.0 0.000799915 -0.00646779 0.00216122 0.0136537 0.0280805 -0.122749; 0.0 -0.000530315 -4.7064e-5 0.0011004 -0.00115177 -0.00692904 0.0; 0.0 -0.0501177 -0.210631 0.0991446 0.534541 0.532454 -2.03849; 0.0 0.164368 -0.436323 -0.444766 -0.0628047 -0.541746 1.83587; 0.0 -0.299516 0.189515 0.229071 -0.0932079 -0.409513 -1.23166e-7]]
   dfidqd_curr_mat_list_in = [[-0.0287973 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 0.239977 0.0 0.0 0.0 0.0 0.0 0.0; 0.0 0.0 0.0 0.0 0.0 0.0 0.0],
                               [0.00716325 0.10138 0.0 0.0 0.0 0.0 0.0; 0.00571631 -0.00463431 0.0 0.0 0.0 0.0 0.0; -0.0316917 0.0 0.0 0.0 0.0 0.0 0.0; 0.161322 -0.000603989 0.0 0.0 0.0 0.0 0.0; -0.0648828 -0.118784 0.0 0.0 0.0 0.0 0.0; -0.225538 0.438763 0.0 0.0 0.0 0.0 0.0],
                               [0.028943 -0.303875 0.044757 0.0 0.0 0.0 0.0; -0.16432 -0.209083 0.00225023 0.0 0.0 0.0 0.0; 0.0232153 0.0295474 0.0 0.0 0.0 0.0 0.0; -0.820993 -1.04746 0.0 0.0 0.0 0.0 0.0; -0.348226 1.49356 -0.344583 0.0 0.0 0.0 0.0; -0.351772 -0.35827 -0.000342499 0.0 0.0 0.0 0.0],
                               [0.0219101 -0.144297 0.01718 0.146716 0.0 0.0 0.0; -0.0375336 -0.0469122 -0.00019346 0.00423014 0.0 0.0 0.0; 0.090795 0.111883 -0.00276884 0.0 0.0 0.0 0.0; -1.11896 -1.36436 -0.00722016 0.0 0.0 0.0 0.0; -0.348484 -0.661744 -0.00142686 -0.201759 0.0 0.0 0.0; -0.161046 -2.06302 -0.150416 0.690875 0.0 0.0 0.0],
                               [-0.0907128 0.0199799 -0.0230856 -0.135476 0.0188723 0.0 0.0; 0.0200496 0.189508 -0.0411519 -0.14442 0.000236705 0.0 0.0; -0.00601293 -0.0469511 0.00749801 0.0309057 0.0 0.0 0.0; 0.309011 2.1507 -0.355245 -1.29684 -0.000797861 0.0 0.0; 0.880681 -0.283061 0.174536 1.12472 -0.167551 0.0 0.0; -0.377962 -0.206329 0.0210588 -0.473171 0.0515384 0.0 0.0],
                               [0.00116697 -3.59492e-5 0.00114096 -0.00626799 0.00514722 0.0138184 0.0; -0.00054948 -0.000611807 -0.000672736 0.00283827 -0.0012909 -0.00205378 0.0; -0.000811912 -0.00193167 0.00187517 0.0085135 -0.00227473 0.0 0.0; 0.0873266 2.54663 -0.550209 -2.19556 0.00117898 0.0 0.0; -0.661067 -0.930316 0.168737 -0.138334 -0.00140164 0.00064279 0.0; -1.43508 0.371905 -0.559375 -1.83992 -0.00250623 0.00489212 0.0],
                               [-0.00311857 -0.00541464 0.000881285 0.00195591 0.000520647 0.00280724 0.000663311; -0.00284078 0.00616829 -0.0026856 -0.0119896 0.00165164 0.00317313 -0.000189494; -0.000134435 -0.000436491 -0.000117578 0.00104945 -0.000351123 -0.000622359 0.0; -0.159219 0.360693 -0.116817 -0.574611 0.0461908 0.102797 0.0; 0.203559 0.305939 0.00441591 -0.0832225 0.0152325 -0.0909432 0.0; -0.129353 -0.18803 0.0163394 -0.00837376 -0.0115452 0.0180337 0.0]]
   # outputs
   # dID/dq
   dtauidq_curr_vec_list_ref =
   [[-1.38778e-16 0.650739 -2.09667 0.000556753 0.378066 0.415192 0.0],
    [-1.58762e-14 -2.19113 2.32283 3.92415 3.98288 0.554302 0.0],
    [-2.25899e-16 -0.042951 0.0589455 0.994759 0.0238366 0.0298527 0.0],
    [1.31606e-14 0.964714 -1.83998 -1.7027 -1.65174 0.0336682 0.0],
    [-8.79796e-16 -0.0207372 0.0461716 0.0420494 0.00557163 0.0236979 0.0],
    [-3.7329e-15 -0.011889 0.0627682 0.0258734 -0.0446072 0.0011675 0.0],
    [-1.66533e-15 -0.000530315 -4.70641e-5 0.0011004 -0.00115177 -0.00692905 0.0]]
   # dID/dqd
   dtauidqd_curr_vec_list_ref =
   [[0.238452 2.29578 -0.352037 -1.37459 0.0248603 0.0119302 -0.000134436],
    [-2.8865 -0.0127031 -0.592737 -2.50106 0.140087 0.144495 0.00036346],
    [-0.0332868 -0.0451345 -0.00113879 0.00377924 0.00176493 0.00696072 8.82326e-5],
    [0.952163 1.20503 -0.0152271 -0.00501841 -0.0337579 -0.065101 -0.000626627],
    [-0.0138919 -0.0459722 0.00441596 0.0210321 0.00110428 0.00638248 9.10967e-5],
    [-0.00506909 -0.0479932 0.0103165 0.0538115 -0.00638236 5.30825e-16 0.000622359],
    [-0.000134436 -0.000436491 -0.000117578 0.00104945 -0.000351123 -0.000622359 -2.69223e-19]]

   #----------------------------------------------------------------------------
   # Link Snapshot
   #----------------------------------------------------------------------------
   # inputs
   link_test = 0.0
   Xi_curr_test = zeros(CUSTOM_TYPE,6,6)
   fi_curr_vec_test = zeros(CUSTOM_TYPE,6,1)
   dfidq_curr_mat_test = zeros(CUSTOM_TYPE,6,7)
   dfidqd_curr_mat_test = zeros(CUSTOM_TYPE,6,7)
   dfidq_prev_mat_test = zeros(CUSTOM_TYPE,6,7)
   dfidqd_prev_mat_test = zeros(CUSTOM_TYPE,6,7)
   # outputs
   dtauidq_curr_vec_test = zeros(CUSTOM_TYPE,1,7)
   dtauidqd_curr_vec_test = zeros(CUSTOM_TYPE,1,7)
   dfidq_prev_mat_out_test = zeros(CUSTOM_TYPE,6,7)
   dfidqd_prev_mat_out_test = zeros(CUSTOM_TYPE,6,7)

   #----------------------------------------------------------------------------
   # Printable Snapshot
   #----------------------------------------------------------------------------
   # inputs
   Xi_curr_print = Array{String}(undef,6,6)
   fi_curr_vec_print = Array{String}(undef,6,1)
   dfidq_curr_mat_print = Array{String}(undef,6,7)
   dfidqd_curr_mat_print = Array{String}(undef,6,7)
   dfidq_prev_mat_print = Array{String}(undef,6,7)
   dfidqd_prev_mat_print = Array{String}(undef,6,7)
   # outputs
   dtauidq_curr_vec_print = Array{String}(undef,1,7)
   dtauidqd_curr_vec_print = Array{String}(undef,1,7)
   dfidq_prev_mat_out_print = Array{String}(undef,6,7)
   dfidqd_prev_mat_out_print = Array{String}(undef,6,7)

   #----------------------------------------------------------------------------
   # Unit Under Test
   #----------------------------------------------------------------------------

   # local variables
   dfidq_curr_mat_list = [zeros(CUSTOM_TYPE,6,7),
                          zeros(CUSTOM_TYPE,6,7),
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
                           zeros(CUSTOM_TYPE,6,7),
                           zeros(CUSTOM_TYPE,6,7)]
   for link in 1:7
      dfidq_curr_mat_list[link+1] = dfidq_curr_mat_list_in[link]
      dfidqd_curr_mat_list[link+1] = dfidqd_curr_mat_list_in[link]
   end

   # output storage
   dtauidq_curr_vec_list = [zeros(CUSTOM_TYPE,1,7),
                            zeros(CUSTOM_TYPE,1,7),
                            zeros(CUSTOM_TYPE,1,7),
                            zeros(CUSTOM_TYPE,1,7),
                            zeros(CUSTOM_TYPE,1,7),
                            zeros(CUSTOM_TYPE,1,7),
                            zeros(CUSTOM_TYPE,1,7)]
   dtauidqd_curr_vec_list = [zeros(CUSTOM_TYPE,1,7),
                             zeros(CUSTOM_TYPE,1,7),
                             zeros(CUSTOM_TYPE,1,7),
                             zeros(CUSTOM_TYPE,1,7),
                             zeros(CUSTOM_TYPE,1,7),
                             zeros(CUSTOM_TYPE,1,7),
                             zeros(CUSTOM_TYPE,1,7)]

   # backward pass
   for link in 7:-1:1
      prev_link = (link-1)
      # select link inputs
      Xi_curr = tXlist[link]
      fi_curr_vec = flist[link]
      dfidq_curr_mat = dfidq_curr_mat_list[link+1]
      dfidqd_curr_mat = dfidqd_curr_mat_list[link+1]
      # update previous link values
      dfidq_prev_mat = dfidq_curr_mat_list[prev_link+1]
      dfidqd_prev_mat = dfidqd_curr_mat_list[prev_link+1]
      # snapshot inputs
      if (link == test_link)
         link_test = link
         Xi_curr_test = Xi_curr
         fi_curr_vec_test = fi_curr_vec
         dfidq_curr_mat_test = dfidq_curr_mat
         dfidqd_curr_mat_test = dfidqd_curr_mat
         dfidq_prev_mat_test = dfidq_prev_mat
         dfidqd_prev_mat_test = dfidqd_prev_mat
      end
      # bprow
      dtauidq_curr_vec_list[link],
      dtauidqd_curr_vec_list[link],
      dfidq_curr_mat_list[prev_link+1],
      dfidqd_curr_mat_list[prev_link+1] = bpRow(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,
                                                link,Xi_curr,fi_curr_vec,
                                                dfidq_curr_mat,dfidqd_curr_mat,
                                                dfidq_prev_mat,dfidqd_prev_mat)
      # snapshot outputs
      if (link == test_link)
         dtauidq_curr_vec_test = dtauidq_curr_vec_list[link]
         dtauidqd_curr_vec_test = dtauidqd_curr_vec_list[link]
         dfidq_prev_mat_out_test = dfidq_curr_mat_list[prev_link+1]
         dfidqd_prev_mat_out_test = dfidqd_curr_mat_list[prev_link+1]
      end
   end

   #----------------------------------------------------------------------------
   # Test Outputs
   #----------------------------------------------------------------------------
   for link in 7:-1:1
      ##println("Link ",link)
      ##println("\tExpected: ",dtauidq_curr_vec_list_ref[link])
      ##println("\tGot:      ",dtauidq_curr_vec_list[link])
      @test dtauidq_curr_vec_list_ref[link] ≈ dtauidq_curr_vec_list[link] atol=1e-4
      ###println("Link ",link," dtau/dq Test Passed!")
   end
   for link in 7:-1:1
      ##println("Link ",link)
      ##println("\tExpected: ",dtauidqd_curr_vec_list_ref[link])
      ##println("\tGot:      ",dtauidqd_curr_vec_list[link])
      @test dtauidqd_curr_vec_list_ref[link] ≈ dtauidqd_curr_vec_list[link] atol=1e-4
      ###println("Link ",link," dtau/dqd Test Passed!")
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
         Xi_curr_print[i,j] = @sprintf("%.0f",Xi_curr_test[i,j])
      end
   end
   #  fi_curr_vec_test
   for i in 1:length(fi_curr_vec_test)
      fi_curr_vec_test[i] = round(fi_curr_vec_test[i]*(2^DECIMAL_BITS))
   end
   #  dfidq_curr_mat_test
   for i in 1:size(dfidq_curr_mat_test)[1] # rows
      for j in 1:size(dfidq_curr_mat_test)[2] # cols
         dfidq_curr_mat_test[i,j] = round(dfidq_curr_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  dfidqd_curr_mat_test
   for i in 1:size(dfidqd_curr_mat_test)[1] # rows
      for j in 1:size(dfidqd_curr_mat_test)[2] # cols
         dfidqd_curr_mat_test[i,j] = round(dfidqd_curr_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  dfidq_prev_mat_test
   for i in 1:size(dfidq_prev_mat_test)[1] # rows
      for j in 1:size(dfidq_prev_mat_test)[2] # cols
         dfidq_prev_mat_test[i,j] = round(dfidq_prev_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  dfidqd_prev_mat_test
   for i in 1:size(dfidqd_prev_mat_test)[1] # rows
      for j in 1:size(dfidqd_prev_mat_test)[2] # cols
         dfidqd_prev_mat_test[i,j] = round(dfidqd_prev_mat_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   # outputs
   #  dtauidq_curr_vec_test
   for i in 1:size(dtauidq_curr_vec_test)[1] # rows
      for j in 1:size(dtauidq_curr_vec_test)[2] # cols
         dtauidq_curr_vec_test[i,j] = round(dtauidq_curr_vec_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  dtauidqd_curr_vec_test
   for i in 1:size(dtauidqd_curr_vec_test)[1] # rows
      for j in 1:size(dtauidqd_curr_vec_test)[2] # cols
         dtauidqd_curr_vec_test[i,j] = round(dtauidqd_curr_vec_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  dfidq_prev_mat_out_test
   for i in 1:size(dfidq_prev_mat_out_test)[1] # rows
      for j in 1:size(dfidq_prev_mat_out_test)[2] # cols
         dfidq_prev_mat_out_test[i,j] = round(dfidq_prev_mat_out_test[i,j]*(2^DECIMAL_BITS))
      end
   end
   #  dfidqd_prev_mat_out_test
   for i in 1:size(dfidqd_prev_mat_out_test)[1] # rows
      for j in 1:size(dfidqd_prev_mat_out_test)[2] # cols
         dfidqd_prev_mat_out_test[i,j] = round(dfidqd_prev_mat_out_test[i,j]*(2^DECIMAL_BITS))
      end
   end

   #----------------------------------------------------------------------------
   # Format Values for Printing
   #----------------------------------------------------------------------------
   # inputs
   #  Xi_curr_print
   for i in 1:size(Xi_curr_test)[1] # rows
      for j in 1:size(Xi_curr_test)[2] # cols
         Xi_curr_print[i,j] = @sprintf("%.0f",Xi_curr_test[i,j])
      end
   end
   #  fi_curr_vec_print
   for i in 1:length(fi_curr_vec_test)
      fi_curr_vec_print[i] = @sprintf("%.0f",fi_curr_vec_test[i])
   end
   #  dfidq_curr_mat_print
   for i in 1:size(dfidq_curr_mat_test)[1] # rows
      for j in 1:size(dfidq_curr_mat_test)[2] # cols
         dfidq_curr_mat_print[i,j] = @sprintf("%.0f",dfidq_curr_mat_test[i,j])
      end
   end
   #  dfidqd_curr_mat_print
   for i in 1:size(dfidqd_curr_mat_test)[1] # rows
      for j in 1:size(dfidqd_curr_mat_test)[2] # cols
         dfidqd_curr_mat_print[i,j] = @sprintf("%.0f",dfidqd_curr_mat_test[i,j])
      end
   end
   #  dfidq_prev_mat_print
   for i in 1:size(dfidq_prev_mat_test)[1] # rows
      for j in 1:size(dfidq_prev_mat_test)[2] # cols
         dfidq_prev_mat_print[i,j] = @sprintf("%.0f",dfidq_prev_mat_test[i,j])
      end
   end
   #  dfidqd_prev_mat_print
   for i in 1:size(dfidqd_prev_mat_test)[1] # rows
      for j in 1:size(dfidqd_prev_mat_test)[2] # cols
         dfidqd_prev_mat_print[i,j] = @sprintf("%.0f",dfidqd_prev_mat_test[i,j])
      end
   end
   # outputs
   #  dtauidq_curr_vec_print
   for i in 1:size(dtauidq_curr_vec_test)[1] # rows
      for j in 1:size(dtauidq_curr_vec_test)[2] # cols
         dtauidq_curr_vec_print[i,j] = @sprintf("%.0f",dtauidq_curr_vec_test[i,j])
      end
   end
   #  dtauidqd_curr_vec_print
   for i in 1:size(dtauidqd_curr_vec_test)[1] # rows
      for j in 1:size(dtauidqd_curr_vec_test)[2] # cols
         dtauidqd_curr_vec_print[i,j] = @sprintf("%.0f",dtauidqd_curr_vec_test[i,j])
      end
   end
   #  dfidq_prev_mat_out_print
   for i in 1:size(dfidq_prev_mat_out_test)[1] # rows
      for j in 1:size(dfidq_prev_mat_out_test)[2] # cols
         dfidq_prev_mat_out_print[i,j] = @sprintf("%.0f",dfidq_prev_mat_out_test[i,j])
      end
   end
   #  dfidqd_prev_mat_out_print
   for i in 1:size(dfidqd_prev_mat_out_test)[1] # rows
      for j in 1:size(dfidqd_prev_mat_out_test)[2] # cols
         dfidqd_prev_mat_out_print[i,j] = @sprintf("%.0f",dfidqd_prev_mat_out_test[i,j])
      end
   end

   ##----------------------------------------------------------------------------
   ## Print Fixed-Point Binary Values for Vivado Simulation
   ##----------------------------------------------------------------------------
   #println("//------------------------------------------------------------------------")
   #println("// Link ",test_link," Test")
   #println("//------------------------------------------------------------------------")
   #println("// Link ",test_link," Inputs")
   ## inputs
   ##  link
   #println("link_in = 3'd",link_test,";")
   ##  Xi_curr
   #println("xform_in_AX_AX = 32'd",Xi_curr_print[1,1],"; xform_in_AX_AY = 32'd",Xi_curr_print[1,2],"; xform_in_AX_AZ = 32'd",Xi_curr_print[1,3],";")
   #println("xform_in_AY_AX = 32'd",Xi_curr_print[2,1],"; xform_in_AY_AY = 32'd",Xi_curr_print[2,2],"; xform_in_AY_AZ = 32'd",Xi_curr_print[2,3],";")
   #println("                                     xform_in_AZ_AY = 32'd",Xi_curr_print[3,2],"; xform_in_AZ_AZ = 32'd",Xi_curr_print[3,3],";")
   #println("xform_in_LX_AX = 32'd",Xi_curr_print[4,1],"; xform_in_LX_AY = 32'd",Xi_curr_print[4,2],"; xform_in_LX_AZ = 32'd",Xi_curr_print[4,3],";  xform_in_LX_LX = 32'd",Xi_curr_print[4,4],"; xform_in_LX_LY = 32'd",Xi_curr_print[4,5],"; xform_in_LX_LZ = 32'd",Xi_curr_print[4,6],";")
   #println("xform_in_LY_AX = 32'd",Xi_curr_print[5,1],"; xform_in_LY_AY = 32'd",Xi_curr_print[5,2],"; xform_in_LY_AZ = 32'd",Xi_curr_print[5,3],";  xform_in_LY_LX = 32'd",Xi_curr_print[5,4],"; xform_in_LY_LY = 32'd",Xi_curr_print[5,5],"; xform_in_LY_LZ = 32'd",Xi_curr_print[5,6],";")
   #println("xform_in_LZ_AX = 32'd",Xi_curr_print[6,1],";                                                                                                                 xform_in_LZ_LY = 32'd",Xi_curr_print[6,5],"; xform_in_LZ_LZ = 32'd",Xi_curr_print[6,6],";")
   ##  f_curr_vec
   #println("f_curr_vec_in_AX = 32'd",fi_curr_vec_print[1],"; f_curr_vec_in_AY = 32'd",fi_curr_vec_print[2],"; f_curr_vec_in_AZ = 32'd",fi_curr_vec_print[3],"; f_curr_vec_in_LX = 32'd",fi_curr_vec_print[4],"; f_curr_vec_in_LY = 32'd",fi_curr_vec_print[5],"; f_curr_vec_in_LZ = 32'd",fi_curr_vec_print[6],";")
   ##  dfidq_curr_mat
   #println("dfidq_curr_mat_in_AX_J1 = 32'd",dfidq_curr_mat_print[1,1],"; dfidq_curr_mat_in_AX_J2 = 32'd",dfidq_curr_mat_print[1,2],"; dfidq_curr_mat_in_AX_J3 = 32'd",dfidq_curr_mat_print[1,3],";  dfidq_curr_mat_in_AX_J4 = 32'd",dfidq_curr_mat_print[1,4],"; dfidq_curr_mat_in_AX_J5 = 32'd",dfidq_curr_mat_print[1,5],"; dfidq_curr_mat_in_AX_J6 = 32'd",dfidq_curr_mat_print[1,6],"; dfidq_curr_mat_in_AX_J7 = 32'd",dfidq_curr_mat_print[1,7],";")
   #println("dfidq_curr_mat_in_AY_J1 = 32'd",dfidq_curr_mat_print[2,1],"; dfidq_curr_mat_in_AY_J2 = 32'd",dfidq_curr_mat_print[2,2],"; dfidq_curr_mat_in_AY_J3 = 32'd",dfidq_curr_mat_print[2,3],";  dfidq_curr_mat_in_AY_J4 = 32'd",dfidq_curr_mat_print[2,4],"; dfidq_curr_mat_in_AY_J5 = 32'd",dfidq_curr_mat_print[2,5],"; dfidq_curr_mat_in_AY_J6 = 32'd",dfidq_curr_mat_print[2,6],"; dfidq_curr_mat_in_AY_J7 = 32'd",dfidq_curr_mat_print[2,7],";")
   #println("dfidq_curr_mat_in_AZ_J1 = 32'd",dfidq_curr_mat_print[3,1],"; dfidq_curr_mat_in_AZ_J2 = 32'd",dfidq_curr_mat_print[3,2],"; dfidq_curr_mat_in_AZ_J3 = 32'd",dfidq_curr_mat_print[3,3],";  dfidq_curr_mat_in_AZ_J4 = 32'd",dfidq_curr_mat_print[3,4],"; dfidq_curr_mat_in_AZ_J5 = 32'd",dfidq_curr_mat_print[3,5],"; dfidq_curr_mat_in_AZ_J6 = 32'd",dfidq_curr_mat_print[3,6],"; dfidq_curr_mat_in_AZ_J7 = 32'd",dfidq_curr_mat_print[3,7],";")
   #println("dfidq_curr_mat_in_LX_J1 = 32'd",dfidq_curr_mat_print[4,1],"; dfidq_curr_mat_in_LX_J2 = 32'd",dfidq_curr_mat_print[4,2],"; dfidq_curr_mat_in_LX_J3 = 32'd",dfidq_curr_mat_print[4,3],";  dfidq_curr_mat_in_LX_J4 = 32'd",dfidq_curr_mat_print[4,4],"; dfidq_curr_mat_in_LX_J5 = 32'd",dfidq_curr_mat_print[4,5],"; dfidq_curr_mat_in_LX_J6 = 32'd",dfidq_curr_mat_print[4,6],"; dfidq_curr_mat_in_LX_J7 = 32'd",dfidq_curr_mat_print[4,7],";")
   #println("dfidq_curr_mat_in_LY_J1 = 32'd",dfidq_curr_mat_print[5,1],"; dfidq_curr_mat_in_LY_J2 = 32'd",dfidq_curr_mat_print[5,2],"; dfidq_curr_mat_in_LY_J3 = 32'd",dfidq_curr_mat_print[5,3],";  dfidq_curr_mat_in_LY_J4 = 32'd",dfidq_curr_mat_print[5,4],"; dfidq_curr_mat_in_LY_J5 = 32'd",dfidq_curr_mat_print[5,5],"; dfidq_curr_mat_in_LY_J6 = 32'd",dfidq_curr_mat_print[5,6],"; dfidq_curr_mat_in_LY_J7 = 32'd",dfidq_curr_mat_print[5,7],";")
   #println("dfidq_curr_mat_in_LZ_J1 = 32'd",dfidq_curr_mat_print[6,1],"; dfidq_curr_mat_in_LZ_J2 = 32'd",dfidq_curr_mat_print[6,2],"; dfidq_curr_mat_in_LZ_J3 = 32'd",dfidq_curr_mat_print[6,3],";  dfidq_curr_mat_in_LZ_J4 = 32'd",dfidq_curr_mat_print[6,4],"; dfidq_curr_mat_in_LZ_J5 = 32'd",dfidq_curr_mat_print[6,5],"; dfidq_curr_mat_in_LZ_J6 = 32'd",dfidq_curr_mat_print[6,6],"; dfidq_curr_mat_in_LZ_J7 = 32'd",dfidq_curr_mat_print[6,7],";")
   ##  dfidqd_curr_mat
   #println("dfidqd_curr_mat_in_AX_J1 = 32'd",dfidqd_curr_mat_print[1,1],"; dfidqd_curr_mat_in_AX_J2 = 32'd",dfidqd_curr_mat_print[1,2],"; dfidqd_curr_mat_in_AX_J3 = 32'd",dfidqd_curr_mat_print[1,3],";  dfidqd_curr_mat_in_AX_J4 = 32'd",dfidqd_curr_mat_print[1,4],"; dfidqd_curr_mat_in_AX_J5 = 32'd",dfidqd_curr_mat_print[1,5],"; dfidqd_curr_mat_in_AX_J6 = 32'd",dfidqd_curr_mat_print[1,6],"; dfidqd_curr_mat_in_AX_J7 = 32'd",dfidqd_curr_mat_print[1,7],";")
   #println("dfidqd_curr_mat_in_AY_J1 = 32'd",dfidqd_curr_mat_print[2,1],"; dfidqd_curr_mat_in_AY_J2 = 32'd",dfidqd_curr_mat_print[2,2],"; dfidqd_curr_mat_in_AY_J3 = 32'd",dfidqd_curr_mat_print[2,3],";  dfidqd_curr_mat_in_AY_J4 = 32'd",dfidqd_curr_mat_print[2,4],"; dfidqd_curr_mat_in_AY_J5 = 32'd",dfidqd_curr_mat_print[2,5],"; dfidqd_curr_mat_in_AY_J6 = 32'd",dfidqd_curr_mat_print[2,6],"; dfidqd_curr_mat_in_AY_J7 = 32'd",dfidqd_curr_mat_print[2,7],";")
   #println("dfidqd_curr_mat_in_AZ_J1 = 32'd",dfidqd_curr_mat_print[3,1],"; dfidqd_curr_mat_in_AZ_J2 = 32'd",dfidqd_curr_mat_print[3,2],"; dfidqd_curr_mat_in_AZ_J3 = 32'd",dfidqd_curr_mat_print[3,3],";  dfidqd_curr_mat_in_AZ_J4 = 32'd",dfidqd_curr_mat_print[3,4],"; dfidqd_curr_mat_in_AZ_J5 = 32'd",dfidqd_curr_mat_print[3,5],"; dfidqd_curr_mat_in_AZ_J6 = 32'd",dfidqd_curr_mat_print[3,6],"; dfidqd_curr_mat_in_AZ_J7 = 32'd",dfidqd_curr_mat_print[3,7],";")
   #println("dfidqd_curr_mat_in_LX_J1 = 32'd",dfidqd_curr_mat_print[4,1],"; dfidqd_curr_mat_in_LX_J2 = 32'd",dfidqd_curr_mat_print[4,2],"; dfidqd_curr_mat_in_LX_J3 = 32'd",dfidqd_curr_mat_print[4,3],";  dfidqd_curr_mat_in_LX_J4 = 32'd",dfidqd_curr_mat_print[4,4],"; dfidqd_curr_mat_in_LX_J5 = 32'd",dfidqd_curr_mat_print[4,5],"; dfidqd_curr_mat_in_LX_J6 = 32'd",dfidqd_curr_mat_print[4,6],"; dfidqd_curr_mat_in_LX_J7 = 32'd",dfidqd_curr_mat_print[4,7],";")
   #println("dfidqd_curr_mat_in_LY_J1 = 32'd",dfidqd_curr_mat_print[5,1],"; dfidqd_curr_mat_in_LY_J2 = 32'd",dfidqd_curr_mat_print[5,2],"; dfidqd_curr_mat_in_LY_J3 = 32'd",dfidqd_curr_mat_print[5,3],";  dfidqd_curr_mat_in_LY_J4 = 32'd",dfidqd_curr_mat_print[5,4],"; dfidqd_curr_mat_in_LY_J5 = 32'd",dfidqd_curr_mat_print[5,5],"; dfidqd_curr_mat_in_LY_J6 = 32'd",dfidqd_curr_mat_print[5,6],"; dfidqd_curr_mat_in_LY_J7 = 32'd",dfidqd_curr_mat_print[5,7],";")
   #println("dfidqd_curr_mat_in_LZ_J1 = 32'd",dfidqd_curr_mat_print[6,1],"; dfidqd_curr_mat_in_LZ_J2 = 32'd",dfidqd_curr_mat_print[6,2],"; dfidqd_curr_mat_in_LZ_J3 = 32'd",dfidqd_curr_mat_print[6,3],";  dfidqd_curr_mat_in_LZ_J4 = 32'd",dfidqd_curr_mat_print[6,4],"; dfidqd_curr_mat_in_LZ_J5 = 32'd",dfidqd_curr_mat_print[6,5],"; dfidqd_curr_mat_in_LZ_J6 = 32'd",dfidqd_curr_mat_print[6,6],"; dfidqd_curr_mat_in_LZ_J7 = 32'd",dfidqd_curr_mat_print[6,7],";")
   ##  dfidq_prev_mat
   #println("dfidq_prev_mat_in_AX_J1 = 32'd",dfidq_prev_mat_print[1,1],"; dfidq_prev_mat_in_AX_J2 = 32'd",dfidq_prev_mat_print[1,2],"; dfidq_prev_mat_in_AX_J3 = 32'd",dfidq_prev_mat_print[1,3],";  dfidq_prev_mat_in_AX_J4 = 32'd",dfidq_prev_mat_print[1,4],"; dfidq_prev_mat_in_AX_J5 = 32'd",dfidq_prev_mat_print[1,5],"; dfidq_prev_mat_in_AX_J6 = 32'd",dfidq_prev_mat_print[1,6],"; dfidq_prev_mat_in_AX_J7 = 32'd",dfidq_prev_mat_print[1,7],";")
   #println("dfidq_prev_mat_in_AY_J1 = 32'd",dfidq_prev_mat_print[2,1],"; dfidq_prev_mat_in_AY_J2 = 32'd",dfidq_prev_mat_print[2,2],"; dfidq_prev_mat_in_AY_J3 = 32'd",dfidq_prev_mat_print[2,3],";  dfidq_prev_mat_in_AY_J4 = 32'd",dfidq_prev_mat_print[2,4],"; dfidq_prev_mat_in_AY_J5 = 32'd",dfidq_prev_mat_print[2,5],"; dfidq_prev_mat_in_AY_J6 = 32'd",dfidq_prev_mat_print[2,6],"; dfidq_prev_mat_in_AY_J7 = 32'd",dfidq_prev_mat_print[2,7],";")
   #println("dfidq_prev_mat_in_AZ_J1 = 32'd",dfidq_prev_mat_print[3,1],"; dfidq_prev_mat_in_AZ_J2 = 32'd",dfidq_prev_mat_print[3,2],"; dfidq_prev_mat_in_AZ_J3 = 32'd",dfidq_prev_mat_print[3,3],";  dfidq_prev_mat_in_AZ_J4 = 32'd",dfidq_prev_mat_print[3,4],"; dfidq_prev_mat_in_AZ_J5 = 32'd",dfidq_prev_mat_print[3,5],"; dfidq_prev_mat_in_AZ_J6 = 32'd",dfidq_prev_mat_print[3,6],"; dfidq_prev_mat_in_AZ_J7 = 32'd",dfidq_prev_mat_print[3,7],";")
   #println("dfidq_prev_mat_in_LX_J1 = 32'd",dfidq_prev_mat_print[4,1],"; dfidq_prev_mat_in_LX_J2 = 32'd",dfidq_prev_mat_print[4,2],"; dfidq_prev_mat_in_LX_J3 = 32'd",dfidq_prev_mat_print[4,3],";  dfidq_prev_mat_in_LX_J4 = 32'd",dfidq_prev_mat_print[4,4],"; dfidq_prev_mat_in_LX_J5 = 32'd",dfidq_prev_mat_print[4,5],"; dfidq_prev_mat_in_LX_J6 = 32'd",dfidq_prev_mat_print[4,6],"; dfidq_prev_mat_in_LX_J7 = 32'd",dfidq_prev_mat_print[4,7],";")
   #println("dfidq_prev_mat_in_LY_J1 = 32'd",dfidq_prev_mat_print[5,1],"; dfidq_prev_mat_in_LY_J2 = 32'd",dfidq_prev_mat_print[5,2],"; dfidq_prev_mat_in_LY_J3 = 32'd",dfidq_prev_mat_print[5,3],";  dfidq_prev_mat_in_LY_J4 = 32'd",dfidq_prev_mat_print[5,4],"; dfidq_prev_mat_in_LY_J5 = 32'd",dfidq_prev_mat_print[5,5],"; dfidq_prev_mat_in_LY_J6 = 32'd",dfidq_prev_mat_print[5,6],"; dfidq_prev_mat_in_LY_J7 = 32'd",dfidq_prev_mat_print[5,7],";")
   #println("dfidq_prev_mat_in_LZ_J1 = 32'd",dfidq_prev_mat_print[6,1],"; dfidq_prev_mat_in_LZ_J2 = 32'd",dfidq_prev_mat_print[6,2],"; dfidq_prev_mat_in_LZ_J3 = 32'd",dfidq_prev_mat_print[6,3],";  dfidq_prev_mat_in_LZ_J4 = 32'd",dfidq_prev_mat_print[6,4],"; dfidq_prev_mat_in_LZ_J5 = 32'd",dfidq_prev_mat_print[6,5],"; dfidq_prev_mat_in_LZ_J6 = 32'd",dfidq_prev_mat_print[6,6],"; dfidq_prev_mat_in_LZ_J7 = 32'd",dfidq_prev_mat_print[6,7],";")
   ##  dfidqd_prev_mat
   #println("dfidqd_prev_mat_in_AX_J1 = 32'd",dfidqd_prev_mat_print[1,1],"; dfidqd_prev_mat_in_AX_J2 = 32'd",dfidqd_prev_mat_print[1,2],"; dfidqd_prev_mat_in_AX_J3 = 32'd",dfidqd_prev_mat_print[1,3],";  dfidqd_prev_mat_in_AX_J4 = 32'd",dfidqd_prev_mat_print[1,4],"; dfidqd_prev_mat_in_AX_J5 = 32'd",dfidqd_prev_mat_print[1,5],"; dfidqd_prev_mat_in_AX_J6 = 32'd",dfidqd_prev_mat_print[1,6],"; dfidqd_prev_mat_in_AX_J7 = 32'd",dfidqd_prev_mat_print[1,7],";")
   #println("dfidqd_prev_mat_in_AY_J1 = 32'd",dfidqd_prev_mat_print[2,1],"; dfidqd_prev_mat_in_AY_J2 = 32'd",dfidqd_prev_mat_print[2,2],"; dfidqd_prev_mat_in_AY_J3 = 32'd",dfidqd_prev_mat_print[2,3],";  dfidqd_prev_mat_in_AY_J4 = 32'd",dfidqd_prev_mat_print[2,4],"; dfidqd_prev_mat_in_AY_J5 = 32'd",dfidqd_prev_mat_print[2,5],"; dfidqd_prev_mat_in_AY_J6 = 32'd",dfidqd_prev_mat_print[2,6],"; dfidqd_prev_mat_in_AY_J7 = 32'd",dfidqd_prev_mat_print[2,7],";")
   #println("dfidqd_prev_mat_in_AZ_J1 = 32'd",dfidqd_prev_mat_print[3,1],"; dfidqd_prev_mat_in_AZ_J2 = 32'd",dfidqd_prev_mat_print[3,2],"; dfidqd_prev_mat_in_AZ_J3 = 32'd",dfidqd_prev_mat_print[3,3],";  dfidqd_prev_mat_in_AZ_J4 = 32'd",dfidqd_prev_mat_print[3,4],"; dfidqd_prev_mat_in_AZ_J5 = 32'd",dfidqd_prev_mat_print[3,5],"; dfidqd_prev_mat_in_AZ_J6 = 32'd",dfidqd_prev_mat_print[3,6],"; dfidqd_prev_mat_in_AZ_J7 = 32'd",dfidqd_prev_mat_print[3,7],";")
   #println("dfidqd_prev_mat_in_LX_J1 = 32'd",dfidqd_prev_mat_print[4,1],"; dfidqd_prev_mat_in_LX_J2 = 32'd",dfidqd_prev_mat_print[4,2],"; dfidqd_prev_mat_in_LX_J3 = 32'd",dfidqd_prev_mat_print[4,3],";  dfidqd_prev_mat_in_LX_J4 = 32'd",dfidqd_prev_mat_print[4,4],"; dfidqd_prev_mat_in_LX_J5 = 32'd",dfidqd_prev_mat_print[4,5],"; dfidqd_prev_mat_in_LX_J6 = 32'd",dfidqd_prev_mat_print[4,6],"; dfidqd_prev_mat_in_LX_J7 = 32'd",dfidqd_prev_mat_print[4,7],";")
   #println("dfidqd_prev_mat_in_LY_J1 = 32'd",dfidqd_prev_mat_print[5,1],"; dfidqd_prev_mat_in_LY_J2 = 32'd",dfidqd_prev_mat_print[5,2],"; dfidqd_prev_mat_in_LY_J3 = 32'd",dfidqd_prev_mat_print[5,3],";  dfidqd_prev_mat_in_LY_J4 = 32'd",dfidqd_prev_mat_print[5,4],"; dfidqd_prev_mat_in_LY_J5 = 32'd",dfidqd_prev_mat_print[5,5],"; dfidqd_prev_mat_in_LY_J6 = 32'd",dfidqd_prev_mat_print[5,6],"; dfidqd_prev_mat_in_LY_J7 = 32'd",dfidqd_prev_mat_print[5,7],";")
   #println("dfidqd_prev_mat_in_LZ_J1 = 32'd",dfidqd_prev_mat_print[6,1],"; dfidqd_prev_mat_in_LZ_J2 = 32'd",dfidqd_prev_mat_print[6,2],"; dfidqd_prev_mat_in_LZ_J3 = 32'd",dfidqd_prev_mat_print[6,3],";  dfidqd_prev_mat_in_LZ_J4 = 32'd",dfidqd_prev_mat_print[6,4],"; dfidqd_prev_mat_in_LZ_J5 = 32'd",dfidqd_prev_mat_print[6,5],"; dfidqd_prev_mat_in_LZ_J6 = 32'd",dfidqd_prev_mat_print[6,6],"; dfidqd_prev_mat_in_LZ_J7 = 32'd",dfidqd_prev_mat_print[6,7],";")
   #println("//------------------------------------------------------------------------")
   #println("// Wait")
   #println("#50;")
   #println("//------------------------------------------------------------------------")
   #println("// Compare Outputs")
   #println("\$display (\"//-------------------------------------------------------------------------------------------------------\");")
   ## outputs
   ##  dtauidq_curr_vec
   #println("// dtau/dq")
   #println("\$display (\"dtauidq_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d\", ",dtauidq_curr_vec_print[1,1],", ",dtauidq_curr_vec_print[1,2],", ",dtauidq_curr_vec_print[1,3],", ",dtauidq_curr_vec_print[1,4],", ",dtauidq_curr_vec_print[1,5],", ",dtauidq_curr_vec_print[1,6],", ",dtauidq_curr_vec_print[1,7],");")
   #println("\$display (\"\\n\");")
   #println("\$display (\"dtauidq_curr_vec_out = %d,%d,%d,%d,%d,%d,%d\", dtauidq_curr_vec_out_J1,dtauidq_curr_vec_out_J2,dtauidq_curr_vec_out_J3,dtauidq_curr_vec_out_J4,dtauidq_curr_vec_out_J5,dtauidq_curr_vec_out_J6,dtauidq_curr_vec_out_J7);")
   #println("\$display (\"//-------------------------------------------------------------------------------------------------------\");")
   ##  dtauidqd_curr_vec
   #println("// dtau/dqd")
   #println("\$display (\"dtauidqd_curr_vec_ref = %d,%d,%d,%d,%d,%d,%d\", ",dtauidqd_curr_vec_print[1,1],", ",dtauidqd_curr_vec_print[1,2],", ",dtauidqd_curr_vec_print[1,3],", ",dtauidqd_curr_vec_print[1,4],", ",dtauidqd_curr_vec_print[1,5],", ",dtauidqd_curr_vec_print[1,6],", ",dtauidqd_curr_vec_print[1,7],");")
   #println("\$display (\"\\n\");")
   #println("\$display (\"dtauidqd_curr_vec_out = %d,%d,%d,%d,%d,%d,%d\", dtauidqd_curr_vec_out_J1,dtauidqd_curr_vec_out_J2,dtauidqd_curr_vec_out_J3,dtauidqd_curr_vec_out_J4,dtauidqd_curr_vec_out_J5,dtauidqd_curr_vec_out_J6,dtauidqd_curr_vec_out_J7);")
   #println("\$display (\"//-------------------------------------------------------------------------------------------------------\");")
   ##  dfidq_prev_mat_out
   #println("// da/dqd")
   #println("\$display (\"dfidq_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d\", ",dfidq_prev_mat_out_print[1,1],", ",dfidq_prev_mat_out_print[1,2],", ",dfidq_prev_mat_out_print[1,3],", ",dfidq_prev_mat_out_print[1,4],", ",dfidq_prev_mat_out_print[1,5],", ",dfidq_prev_mat_out_print[1,6],", ",dfidq_prev_mat_out_print[1,7],");")
   #println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dfidq_prev_mat_out_print[2,1],", ",dfidq_prev_mat_out_print[2,2],", ",dfidq_prev_mat_out_print[2,3],", ",dfidq_prev_mat_out_print[2,4],", ",dfidq_prev_mat_out_print[2,5],", ",dfidq_prev_mat_out_print[2,6],", ",dfidq_prev_mat_out_print[2,7],");")
   #println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dfidq_prev_mat_out_print[3,1],", ",dfidq_prev_mat_out_print[3,2],", ",dfidq_prev_mat_out_print[3,3],", ",dfidq_prev_mat_out_print[3,4],", ",dfidq_prev_mat_out_print[3,5],", ",dfidq_prev_mat_out_print[3,6],", ",dfidq_prev_mat_out_print[3,7],");")
   #println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dfidq_prev_mat_out_print[4,1],", ",dfidq_prev_mat_out_print[4,2],", ",dfidq_prev_mat_out_print[4,3],", ",dfidq_prev_mat_out_print[4,4],", ",dfidq_prev_mat_out_print[4,5],", ",dfidq_prev_mat_out_print[4,6],", ",dfidq_prev_mat_out_print[4,7],");")
   #println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dfidq_prev_mat_out_print[5,1],", ",dfidq_prev_mat_out_print[5,2],", ",dfidq_prev_mat_out_print[5,3],", ",dfidq_prev_mat_out_print[5,4],", ",dfidq_prev_mat_out_print[5,5],", ",dfidq_prev_mat_out_print[5,6],", ",dfidq_prev_mat_out_print[5,7],");")
   #println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", ",dfidq_prev_mat_out_print[6,1],", ",dfidq_prev_mat_out_print[6,2],", ",dfidq_prev_mat_out_print[6,3],", ",dfidq_prev_mat_out_print[6,4],", ",dfidq_prev_mat_out_print[6,5],", ",dfidq_prev_mat_out_print[6,6],", ",dfidq_prev_mat_out_print[6,7],");")
   #println("\$display (\"\\n\");")
   #println("\$display (\"dfidq_prev_mat_out = %d,%d,%d,%d,%d,%d,%d\", dfidq_prev_mat_out_AX_J1,dfidq_prev_mat_out_AX_J2,dfidq_prev_mat_out_AX_J3,dfidq_prev_mat_out_AX_J4,dfidq_prev_mat_out_AX_J5,dfidq_prev_mat_out_AX_J6,dfidq_prev_mat_out_AX_J7);")
   #println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dfidq_prev_mat_out_AY_J1,dfidq_prev_mat_out_AY_J2,dfidq_prev_mat_out_AY_J3,dfidq_prev_mat_out_AY_J4,dfidq_prev_mat_out_AY_J5,dfidq_prev_mat_out_AY_J6,dfidq_prev_mat_out_AY_J7);")
   #println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dfidq_prev_mat_out_AZ_J1,dfidq_prev_mat_out_AZ_J2,dfidq_prev_mat_out_AZ_J3,dfidq_prev_mat_out_AZ_J4,dfidq_prev_mat_out_AZ_J5,dfidq_prev_mat_out_AZ_J6,dfidq_prev_mat_out_AZ_J7);")
   #println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dfidq_prev_mat_out_LX_J1,dfidq_prev_mat_out_LX_J2,dfidq_prev_mat_out_LX_J3,dfidq_prev_mat_out_LX_J4,dfidq_prev_mat_out_LX_J5,dfidq_prev_mat_out_LX_J6,dfidq_prev_mat_out_LX_J7);")
   #println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dfidq_prev_mat_out_LY_J1,dfidq_prev_mat_out_LY_J2,dfidq_prev_mat_out_LY_J3,dfidq_prev_mat_out_LY_J4,dfidq_prev_mat_out_LY_J5,dfidq_prev_mat_out_LY_J6,dfidq_prev_mat_out_LY_J7);")
   #println("\$display (\"                     %d,%d,%d,%d,%d,%d,%d\", dfidq_prev_mat_out_LZ_J1,dfidq_prev_mat_out_LZ_J2,dfidq_prev_mat_out_LZ_J3,dfidq_prev_mat_out_LZ_J4,dfidq_prev_mat_out_LZ_J5,dfidq_prev_mat_out_LZ_J6,dfidq_prev_mat_out_LZ_J7);")
   #println("\$display (\"//-------------------------------------------------------------------------------------------------------\");")
   ##  dfidqd_prev_mat_out
   #println("// da/dqdd")
   #println("\$display (\"dfidqd_prev_mat_ref = %d,%d,%d,%d,%d,%d,%d\", ",dfidqd_prev_mat_out_print[1,1],", ",dfidqd_prev_mat_out_print[1,2],", ",dfidqd_prev_mat_out_print[1,3],", ",dfidqd_prev_mat_out_print[1,4],", ",dfidqd_prev_mat_out_print[1,5],", ",dfidqd_prev_mat_out_print[1,6],", ",dfidqd_prev_mat_out_print[1,7],");")
   #println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dfidqd_prev_mat_out_print[2,1],", ",dfidqd_prev_mat_out_print[2,2],", ",dfidqd_prev_mat_out_print[2,3],", ",dfidqd_prev_mat_out_print[2,4],", ",dfidqd_prev_mat_out_print[2,5],", ",dfidqd_prev_mat_out_print[2,6],", ",dfidqd_prev_mat_out_print[2,7],");")
   #println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dfidqd_prev_mat_out_print[3,1],", ",dfidqd_prev_mat_out_print[3,2],", ",dfidqd_prev_mat_out_print[3,3],", ",dfidqd_prev_mat_out_print[3,4],", ",dfidqd_prev_mat_out_print[3,5],", ",dfidqd_prev_mat_out_print[3,6],", ",dfidqd_prev_mat_out_print[3,7],");")
   #println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dfidqd_prev_mat_out_print[4,1],", ",dfidqd_prev_mat_out_print[4,2],", ",dfidqd_prev_mat_out_print[4,3],", ",dfidqd_prev_mat_out_print[4,4],", ",dfidqd_prev_mat_out_print[4,5],", ",dfidqd_prev_mat_out_print[4,6],", ",dfidqd_prev_mat_out_print[4,7],");")
   #println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dfidqd_prev_mat_out_print[5,1],", ",dfidqd_prev_mat_out_print[5,2],", ",dfidqd_prev_mat_out_print[5,3],", ",dfidqd_prev_mat_out_print[5,4],", ",dfidqd_prev_mat_out_print[5,5],", ",dfidqd_prev_mat_out_print[5,6],", ",dfidqd_prev_mat_out_print[5,7],");")
   #println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", ",dfidqd_prev_mat_out_print[6,1],", ",dfidqd_prev_mat_out_print[6,2],", ",dfidqd_prev_mat_out_print[6,3],", ",dfidqd_prev_mat_out_print[6,4],", ",dfidqd_prev_mat_out_print[6,5],", ",dfidqd_prev_mat_out_print[6,6],", ",dfidqd_prev_mat_out_print[6,7],");")
   #println("\$display (\"\\n\");")
   #println("\$display (\"dfidqd_prev_mat_out = %d,%d,%d,%d,%d,%d,%d\", dfidqd_prev_mat_out_AX_J1,dfidqd_prev_mat_out_AX_J2,dfidqd_prev_mat_out_AX_J3,dfidqd_prev_mat_out_AX_J4,dfidqd_prev_mat_out_AX_J5,dfidqd_prev_mat_out_AX_J6,dfidqd_prev_mat_out_AX_J7);")
   #println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dfidqd_prev_mat_out_AY_J1,dfidqd_prev_mat_out_AY_J2,dfidqd_prev_mat_out_AY_J3,dfidqd_prev_mat_out_AY_J4,dfidqd_prev_mat_out_AY_J5,dfidqd_prev_mat_out_AY_J6,dfidqd_prev_mat_out_AY_J7);")
   #println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dfidqd_prev_mat_out_AZ_J1,dfidqd_prev_mat_out_AZ_J2,dfidqd_prev_mat_out_AZ_J3,dfidqd_prev_mat_out_AZ_J4,dfidqd_prev_mat_out_AZ_J5,dfidqd_prev_mat_out_AZ_J6,dfidqd_prev_mat_out_AZ_J7);")
   #println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dfidqd_prev_mat_out_LX_J1,dfidqd_prev_mat_out_LX_J2,dfidqd_prev_mat_out_LX_J3,dfidqd_prev_mat_out_LX_J4,dfidqd_prev_mat_out_LX_J5,dfidqd_prev_mat_out_LX_J6,dfidqd_prev_mat_out_LX_J7);")
   #println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dfidqd_prev_mat_out_LY_J1,dfidqd_prev_mat_out_LY_J2,dfidqd_prev_mat_out_LY_J3,dfidqd_prev_mat_out_LY_J4,dfidqd_prev_mat_out_LY_J5,dfidqd_prev_mat_out_LY_J6,dfidqd_prev_mat_out_LY_J7);")
   #println("\$display (\"                      %d,%d,%d,%d,%d,%d,%d\", dfidqd_prev_mat_out_LZ_J1,dfidqd_prev_mat_out_LZ_J2,dfidqd_prev_mat_out_LZ_J3,dfidqd_prev_mat_out_LZ_J4,dfidqd_prev_mat_out_LZ_J5,dfidqd_prev_mat_out_LZ_J6,dfidqd_prev_mat_out_LZ_J7);")
   #println("\$display (\"//-------------------------------------------------------------------------------------------------------\");")
   #----------------------------------------------------------------------------
   # Print Fixed-Point Binary Values for Vivado Simulation
   #----------------------------------------------------------------------------
   println("// -----------------------------------------------------------------------")
   println("// Input ",test_input,", Link ",test_link)
   println("// -----------------------------------------------------------------------")
   # fcross
   if (test_input == test_link)
      fcross = 1
   else
      fcross = 0
   end
   println("link_in = 3'd",test_link,";")
   println("fcurr_in_AX = 32'd",fi_curr_vec_print[1],"; fcurr_in_AY = 32'd",fi_curr_vec_print[2],"; fcurr_in_AZ = 32'd",fi_curr_vec_print[3],"; fcurr_in_LX = 32'd",fi_curr_vec_print[4],"; fcurr_in_LY = 32'd",fi_curr_vec_print[5],"; fcurr_in_LZ = 32'd",fi_curr_vec_print[6],";")
   println("dfdq_curr_in_AX = 32'd",dfidq_curr_mat_print[1,test_input],"; dfdq_curr_in_AY = 32'd",dfidq_curr_mat_print[2,test_input],"; dfdq_curr_in_AZ = 32'd",dfidq_curr_mat_print[3,test_input],"; dfdq_curr_in_LX = 32'd",dfidq_curr_mat_print[4,test_input],"; dfdq_curr_in_LY = 32'd",dfidq_curr_mat_print[5,test_input],"; dfdq_curr_in_LZ = 32'd",dfidq_curr_mat_print[6,test_input],";")
   println("fcross = ",fcross,";")
   println("dfdq_prev_in_AX = 32'd",dfidq_prev_mat_print[1,test_input],"; dfdq_prev_in_AY = 32'd",dfidq_prev_mat_print[2,test_input],"; dfdq_prev_in_AZ = 32'd",dfidq_prev_mat_print[3,test_input],"; dfdq_prev_in_LX = 32'd",dfidq_prev_mat_print[4,test_input],"; dfdq_prev_in_LY = 32'd",dfidq_prev_mat_print[5,test_input],"; dfdq_prev_in_LZ = 32'd",dfidq_prev_mat_print[6,test_input],";")
   println("#100;")
   println("\$display (\"dtau_dq     = ",dtauidq_curr_vec_print[1,test_input],"\");")
   println("\$display (\"dtau_dq_out = %d\", dtau_dq_out);")
   println("\$display (\"dfdq_prev     = ",dfidqd_prev_mat_out_print[1,test_input],", ",dfidqd_prev_mat_out_print[2,test_input],", ",dfidqd_prev_mat_out_print[3,test_input],", ",dfidqd_prev_mat_out_print[4,test_input],", ",dfidqd_prev_mat_out_print[5,test_input],", ",dfidqd_prev_mat_out_print[6,test_input],"\");")
   println("\$display (\"dfdq_prev_out = %d,%d,%d,%d,%d,%d\", dfdq_prev_out_AX,dfdq_prev_out_AY,dfdq_prev_out_AZ,dfdq_prev_out_LX,dfdq_prev_out_LY,dfdq_prev_out_LZ);")
   println("// -----------------------------------------------------------------------")
end

#-------------------------------------------------------------------------------
# Set Test Parameters and Run Test
#-------------------------------------------------------------------------------
test_input = 5
for test_link in 7:-1:1
   bpRowTest(CUSTOM_TYPE,X,Y,Z,AX,AY,AZ,LX,LY,LZ,test_input,test_link)
end
