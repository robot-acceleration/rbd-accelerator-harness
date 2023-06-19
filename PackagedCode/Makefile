CONNECTALDIR ?= connectal
S2H_INTERFACES = \
	Gradient:GradientPipeline.start
H2S_INTERFACES= \
	GradientPipeline:GradientPipelineIndication
MEM_READ_INTERFACES= lGradientPipeline.dmaReadClient
MEM_WRITE_INTERFACES= lGradientPipeline.dmaWriteClient
BSVFILES += \
	bluespec/IfcGradientPipeline.bsv \
	bluespec/GradientPipeline.bsv
BSVPATH += / \
	bluespec/ \
	$(CONNECTALDIR)/bsv
CPPFILES += \
	main.cpp \

CONNECTALFLAGS += --mainclockperiod=18
CONNECTALFLAGS += -D DataBusWidth=256 -D USE_WIDE_WIDTH
CONNECTALFLAGS += --nonstrict
CONNECTALFLAGS += \
	-C pcieclock-vcu118.xdc\
	--verilog ../hdl/verilog/rev3/fproc/\
	--verilog ../hdl/verilog/rev3/bproc/\
	--verilog ../hdl/verilog/rev3/common/

CONNECTALFLAGS += --xci=$(IPDIR)/$(BOARD)/fp_convert/fp_convert.xci --xci=$(IPDIR)/$(BOARD)/fix_float/fix_float.xci

FP_CONVERT_V= $(IPDIR)/$(BOARD)/fp_convert/fp_convert_stub.v
FP_FIX_FLOAT_V= $(IPDIR)/$(BOARD)/fix_float/fix_float_stub.v

$(FP_CONVERT_V): synth-ip.tcl
	(cd $(BOARD); vivado -mode batch -source ../synth-ip.tcl)

$(FP_FIX_FLOAT_V): synth-ip.tcl
	(cd $(BOARD); vivado -mode batch -source ../synth-ip.tcl)

# for fpga fp conv
#BviFpFixConvert.bsv:
#	        $(CONNECTALDIR)/generated/scripts/importbvi.py -o BviFpFixConvert.bsv -c aclk -f s_axis_a -f m_axis_result -I BviFpFixConvert -P BviFpFixConvert $(FP_CONVERT_V)
#
#BviFixFpConvert.bsv:
#	        $(CONNECTALDIR)/generated/scripts/importbvi.py -o BviFixFpConvert.bsv -c aclk -f s_axis_a -f m_axis_result -I BviFixFpConvert -P BviFixFpConvert $(FP_FIX_FLOAT_V)
#
#prebuild:: $(FP_CONVERT_V) $(FP_FIX_FLOAT_V) #BviFpFixConvert.bsv BviFixFpConvert.bsv

V = 1

URDF_FILEPATH ?= "/home/radhika/robomorphic_stuff/robomorphic-automation/scripts/urdfs/iiwa_rbd_accel.urdf"
NUM_LINKS ?= 7

# CONNECTALFLAGS += -Ilibraries
CONNECTALFLAGS += --bscflags="+RTS -K46777216 -RTS -steps 5000000 -v -D HOST_FPCONV"# -steps-warn-interval 200000"

PINOCCHIO_INCLUDES := -I/home/radhika/build/pinocchio/install/include/ -I/home/radhika/build/eigen-3.4.0/Eigen/ -I/home/radhika/build/eigen-3.4.0/
PINOCCHIO_CXXFLAGS := -DPINOCCHIO_URDFDOM_TYPEDEF_SHARED_PTR -DPINOCCHIO_WITH_URDFDOM
PINOCCHIO_LIBS := -lboost_system -lpinocchio -lurdfdom_model -lpthread
PINOCCHIO_LIBDIRS := -L/opt/openrobots/lib -L/home/radhika/build/pinocchio/install/lib/ 

CONNECTALFLAGS += --cxxflags="-std=c++11 -lpthread -O3 -D COMPILE_WITH_FPGA -D HOST_FPCONV -D NUM_LINKS=$(NUM_LINKS) -D NUM_POS=$(NUM_LINKS) -D N_SPARSE_MINV_ENTRIES=$(N_SPARSE_MINV_ENTRIES)"
#CONNECTALFLAGS += --cxxflags="-g"

ifdef COMPARE_PINOCCHIO
		CONNECTALFLAGS += --cxxflags="-D COMPARE_PINOCCHIO -D URDF_FILEPATH=$(URDF_FILEPATH) $(PINOCCHIO_CXXFLAGS)"
	    CONNECTALFLAGS += $(PINOCCHIO_INCLUDES)
		CONNECTALFLAGS += $(PINOCCHIO_LIBDIRS)
		CONNECTALFLAGS += --clib boost_system
		CONNECTALFLAGS += --clib pinocchio
		CONNECTALFLAGS += --clib urdfdom_model
		CONNECTALFLAGS += --clib pthread
endif

include $(CONNECTALDIR)/Makefile.connectal

