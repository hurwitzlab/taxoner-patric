#!/usr/bin/env bash

#
#This script is intended to fetch sequences from fasta files when you only have the read id's (Eg: HWI-blabla)
#
unset module
set -u
source ./config.sh
export CWD="$PWD"
export NUM_FILES=4 #only have four samples, adjust as needed
export STEP_SIZE=1 #adjust as needed

echo Setting up log files...
PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

export FILES_LIST="$PRJ_DIR/low-qual-files"

find $KRONA_OUT_DIR -type f -iname \*lowqual\* | sed "s/^\.\///" > $FILES_LIST

echo Submitting job...

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N fetch_dog -j oe -o "$STDOUT_DIR" $WORKER_DIR/run-search.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you. La la la. La. la.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
