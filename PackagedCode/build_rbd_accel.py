#!/usr/bin/python3

# Libraries to install:
# pip install psutil

import subprocess
import os
import sys
import time
import signal
import psutil
from queue import Queue, Empty
from threading import Thread

################################################
target = "verilator"
urdf_filepath = "/home/radhika/robomorphic_stuff/robomorphic-automation/scripts/urdfs/iiwa_rbd_accel.urdf"
num_links = 7
n_sparse_minv_entries = 7*7
mem_percent_bound = 80
logfile = open("err", "w")
make_cmd = ["make", "build."+target, "NUM_LINKS="+str(num_links), "N_SPARSE_MINV_ENTRIES="+str(n_sparse_minv_entries), "URDF_FILEPATH="+urdf_filepath, "COMPARE_PINOCCHIO=1", "-j16"]
################################################

def enqueue_output(out, queue):
    for line in iter(out.readline, b''):
        #queue.put(line)
        sys.stdout.write(line)
        logfile.write(line)
        # don't want buffering since ctrl-c prevents buffer from 
        # getting written out
        logfile.flush()

process = subprocess.Popen(
        make_cmd, 
        stdout=subprocess.PIPE, 
        stderr=subprocess.STDOUT,
        shell=False,
        env=os.environ.copy(),
        universal_newlines=True,
        preexec_fn=os.setsid
)
q = Queue()
t = Thread(target=enqueue_output, args=[process.stdout, q])
t.daemon = True
t.start()

t_start = time.time()

def ctrl_c_handler(signum, frame):
    os.killpg(os.getpgid(process.pid), signal.SIGTERM)
signal.signal(signal.SIGINT, ctrl_c_handler)

while process.poll() is None:
    mem_used_percent = float(psutil.virtual_memory().percent)
    #tot_m, used_m, free_m = map(int, os.popen('free -t -m').readlines()[-1].split()[1:])
    #mem_used_percent = (used_m / tot_m) * 100
    if mem_used_percent > mem_percent_bound:
        print("mem_used_percent: " + str(mem_used_percent))
        print("KILLED")
        os.killpg(os.getpgid(process.pid), signal.SIGTERM)
        t_end = time.time()
        print("ELAPSED WALLCLOCK TIME: " + str(int(t_end - t_start)) + " seconds")
    time.sleep(0.5)
