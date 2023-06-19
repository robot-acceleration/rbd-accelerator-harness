#!/bin/bash

read -p "Are you setting up the main control CPU [0] or the auxilliary arm comms CPU [1] or resetting main control CPU [2]: " runtype
 
if [ $runtype == 0 ]
then
    sudo cpufreq-set -c 0 -g performance
	sudo cpufreq-set -c 1 -g performance
	sudo cpufreq-set -c 2 -g performance
	sudo cpufreq-set -c 3 -g performance
	echo "Govenors set to performance"
	export LCM_DEFAULT_URL=udpm://239.255.76.67:7667?ttl=1
	echo "LCM ttl set"
	sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev enx70886b80a182
	echo "Ethernet interface set"
elif [ $runtype == 1 ]
then
	export LCM_DEFAULT_URL=udpm://239.255.76.67:7667?ttl=1
	echo "LCM ttl set"
	sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev enx70886b8026a5
	echo "Ethernet interface set"
elif [ $runtype == 2 ]
then
	sudo cpufreq-set -c 0 -g powersave
	sudo cpufreq-set -c 1 -g powersave
	sudo cpufreq-set -c 2 -g powersave
	sudo cpufreq-set -c 3 -g powersave
	echo "Govenors set to powersave"
else
    echo "Bad mode!"
fi