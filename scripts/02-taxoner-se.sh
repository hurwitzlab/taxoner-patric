#!/usr/bin/env bash

#
# This script is intended to use taxoner to map fastqs to a metagenome 
#

set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=10
unset module

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

if [[ -d "$TAXONER_OUT_DIR" ]]; then
    echo "Continuing where you left off..."
else
    mkdir -p "$TAXONER_OUT_DIR"
fi

cd "$SORTNMG_DIR"

export FILES_LIST="$PRJ_DIR/nomatch-files"

echo "Finding fastq's"

find . -type f -iname \*nomatch\* | sed "s/^\.\///" > $FILES_LIST 

echo "Checking if already processed"

if [ -e $PRJ_DIR/files-to-process-se ]; then
    rm $PRJ_DIR/files-to-process-se
fi

export FILES_TO_PROCESS="$PRJ_DIR/files-to-process-se"

while read FASTQ; do

    OUT_DIR=$TAXONER_OUT_DIR/$FASTQ

    if [[ -d $OUT_DIR ]]; then
        if [[ -z $(find $OUT_DIR -iname Taxonomy.txt) ]]; then
            echo $FASTQ >> $FILES_TO_PROCESS
        else
            continue
        fi
    else
        echo $FASTQ >> $FILES_TO_PROCESS
    fi

done < $FILES_LIST

NUM_FILES=$(lc $FILES_TO_PROCESS)

echo \"Found $NUM_FILES to process\"

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N taxoner -j oe -o "$STDOUT_DIR" $WORKER_DIR/run-taxoner-se.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" Remember: time you enjoy wasting is not wasted time.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
