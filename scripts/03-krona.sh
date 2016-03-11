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

JOB=$(qsub -V -N krona -j oe -o "$STDOUT_DIR" $WORKER_DIR/krona_chart.pbs)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you. Do or do not. There is no try.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
