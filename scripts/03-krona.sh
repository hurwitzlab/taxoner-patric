#!/usr/bin/env bash

#
#This script is intended to run kronatools on your samples 
#
unset module
set -u
source ./config.sh
export CWD="$PWD"
#export NUM_FILES=4 #only have four samples, adjust as needed
#export STEP_SIZE=1 #adjust as needed

echo Setting up log files...
PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

#This is where you would put stuff to find all your samples
#And then make a list of files, change $NUM_FILES, etc.

echo Making output dir...
if [ ! -d $KRONA_OUT_DIR ]; then
    mkdir -p $KRONA_OUT_DIR
fi

echo Submitting job...

sbatch -o $STDOUT_DIR/krona-chart.out $WORKER_DIR/krona_chart.slurm

