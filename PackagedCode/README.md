# Required packages:
1. LCM library for interprocess/robot to CPU communication: https://lcm-proj.github.io/ (see their installation instructions)
2. Verilator, Connectal, FPGAJTag, Cpufrequtils, Net-tools which can all be added by PPA:
```
sudo apt-add-repository -y ppa:jamey-hicks/connectal
sudo apt-get update
sudo apt-get install verilator connectal fpgajtag cpufrequtils net-tools
```

# Steps to set up your CPU for high performance and fair profiling:
1. Boot the CPU into the bios (varies by manufacturer but F2 or F12 during bootup tend to work)
2. Disable: turboboost, hyperthreading, speedstep (note if you have a DELL hyperhreading is disabled by undating your gnome setup file located at ```/etc/default/grub```  and setting ```GRUB_CMDLINE_LINUX="noht maxcpus=N"``` where N is the number of phyiscal cores on your machine). If this works on bootup the command ```lscpu``` should show that you have 1 thread active per core and that half of your CPUs are offline. These are the logical but not physical cores we want to disable.
3. Then set the core mode to performance on all cores which will keep the clock pegged to max frequency (before turbo boost - note turbo boost only works if other cores are off and we are going to parallelize as much as possible which is why we disable them) providing no thermal isues. This is easiest done through the ```cpufreq``` package and can be done by running:
```sudo cpufreq-set -c X -g performance``` where X is the number of the core on your machine (IMPORTANT: you need to run these for each core e.g. 0,1,2,3 for a 4 core machine). You can check that this worked by running ```sudo cat /proc/cpuinfo | grep "MHz"``` to see what the current speed of each core is.

# Steps to get multi-hop LCM working
1. ```export LCM_DEFAULT_URL=udpm://239.255.76.67:7667?ttl=1``` where 1 represents 1 extra hop between networked devices
2. ```sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev NET_ID``` where the ```NET_ID``` represents ```ifconfig``` handles of the ethernet adapter between the CPUs
3. On Ubuntu you may need to go into network settings and set IPv4 and IPv6 to Link-Local only to get the connection to work

# Running the code
0. First set the performance govenors -- you can do this manually or by running setCPUforTestBash.sh and selecting option 0
1. To run the experiments please compile and run the main.cpp file. For CPU/GPU mode only set the flags at the top of the main file and run the compile commands at the top of the file (g++ with the GPU flag set to 0 for CPU only and nvcc with the GPU flag set to 1 for CPU/GPU mode). For FPGA mode compile with the MAKEFILE (make sure the GPU flag is set to 0).
2. When the file is run it will ask you which test you want run and the ask more options depending on the test:
	1. I would suggest running the timing tests (option 1) first to both collect data and verify that things seem to be running. 
	2. I would then run the convergence test (option 2). Here you want to see the cost end up converging to around 20 -- it starts at around 300 so if it stays there it isn't working. If this doesn't work I am going to put together a debug dump for the FPGA (option 6) on the main menu. It will print a bunch of output. If you put the data for the CPU in one file and the FPGA in another and then run ```meld t.txt t2.txt``` where t and t2 are the two files it will do a diff for you and highlight the areas to investigate.
	3. At this point we are probably ready for the arm if things are working, but/and if you want to play around more (and get more confident) run the simFig8Test (option 3). A good setting here is to run the full figure 8 with an iteration limit of 6, a time limit of 20, and a total loop time of 10. This should run for a little while and exit with an average tracking error around 0.06. If this is working we are defintiely ready to go!
3. To run the code on the arm TBD

# Running verilator simulation using open source Bluespec

0. Clone and build the open source version of [Bluespec](https://github.com/B-Lang-org/bsc). You'll have to setup a couple of environment variables every time you want to use Bluespec. For Radhika, the exported paths look something like:
```shell
# source init_path_vars.sh
export BSPREFIX=/home/radhika/robomorphic_stuff
export BSPATH=$BSPREFIX/bsc
export BLUESPECDIR=$BSPATH/inst/lib:$BSPREFIX/bsc-contrib/inst/lib
export VIVADO_PATH=/home/radhika/xilinx/Vivado/2020.1
export XILINXD_LICENSE_FILE=2100@localhost
$VIVADO_PATH/settings64.sh
export PATH=$VIVADO_PATH/bin:$BSPATH/inst/bin:$PATH
```
1. We need a custom version of verilator to get simulation working for connectal.
```
sudo apt-add-repository -y ppa:jamey-hicks/connectal
sudo apt-get update
sudo apt-get install verilator
```
2. Clone and build [Connectal](https://github.com/xushuotao/connectal) into `PackagedCode/`. We're using a custom version of connectal patched for the vcu118.
3. In `PackagedCode/`, run `make build.verilator NUM_LINKS=8`.
4. Hopefully your build succeeds (else see "Potential Errors", below). To run the verilator sim, run ./verilator/bin/ubuntu.exe`.

## Potential Errors
E1. Your build may fail because Bluespec is somehow unable to find the libraries (*.bo and *.v) files needed to compile the project (despite explicitly exporting their paths). 
  - My solution has been to just symlink the missing files from bsc and bsc-contrib into the verilator build dir whenever the build died complaining about a missing file. I tried a bunch of things and was unable to come up with anything better. Thankfully this only needs to be done for the first build (or if you do an `rm -rf verilator`). The commands were:
```shell
$ cd verilator # PackagedCode/verilator
$ ln -s $BSPATH/inst/lib/Libraries/* obj/
$ ln -s $BSPREFIX/bsc-contrib/inst/lib/Libraries/FPGA/Xilinx/* obj/
$ ln -s $BSPREFIX/bsc-contrib/inst/lib/Libraries/FPGA/Misc/* obj/
$ cd ../
$ make build.verilator
# next time the build fails
$ cd verilator
$ ln -s $BSPATH/inst/lib/Verilog/* verilog/
$ ln -s $BSPATH/inst/lib/Verilog.Vivado/* verilog/
```
E2. If you get errors about `Unrecognized flag: -wait-for-license`, go delete the flag `--wait-for-license` from:
```
connectal/scripts/Makefile.connectal.build: Line 102
connectal/tests/bluecheck-bram/make.sh: Line 39
connectal/tests/bluecheck-sharedmemfifo/make.sh: Line 39
```
E3. If you get errors about `make[1]: *** No rule to make target 'obj/XilinxCells.bo', needed by 'obj/SyncAxisFifo32x8.bo'.`:
  - Clone the [bsc-contrib repo](https://github.com/B-Lang-org/bsc-contrib) into the same directory where the [Open-Source Bluespec (bsc) repo](https://github.com/B-Lang-org/bsc) has been cloned.
  - Then, follow steps for resolving Error E1, above.
