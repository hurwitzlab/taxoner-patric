#!/usr/bin/env bash

#
#This script is intended to cat fastas 
#
unset module
set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=25 #adjust as needed

echo Setting up log files...
PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

export DIR_LIST="$PRJ_DIR/dirs-to-cat"

find $HIGH_QUAL_DIR -maxdepth 1 -iname \*.fa > $DIR_LIST

export NUM_DIRS=$(lc $DIR_LIST)

echo \"Found $NUM_DIRS to make bigger fastas from\"

echo Making output dir...
if [ ! -d $CAT_OUT_DIR ]; then
    mkdir -p $CAT_OUT_DIR
fi

echo Submitting job...

JOB=$(qsub -J 1-$NUM_DIRS:$STEP_SIZE -V -N catfast -j oe -o "$STDOUT_DIR" $WORKER_DIR/cat-files.pbs)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you. Do or do not. There is no try.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
