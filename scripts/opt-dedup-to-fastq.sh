#!/usr/bin/env bash

#
# This script is intended to deduplicate fastq's with fastx_collapser
#

unset module
set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=10

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

if [[ -d "$DEDUP_DIR" ]]; then
    echo "Continuing where you left off..."
else
    mkdir -p "$DEDUP_DIR"
fi

cd "$SORTNMG_DIR"

export FILES_LIST="$PRJ_DIR/merged_fastqs"

echo "Finding fastq's"

find . -type f -iname \*.fastq | sed "s/^\.\///" | sort > $FILES_LIST 

echo "Checking if already processed"

if [ -e $PRJ_DIR/files-to-process ]; then
    rm $PRJ_DIR/files-to-process
fi

export FILES_TO_PROCESS="$PRJ_DIR/files-to-process"

while read FASTQ; do
 
    OUT=$DEDUP_DIR/$(basename $FASTQ ".fastq").dedupped.fasta

    if [[ -e $OUT ]]; then
        continue
    else
        echo $FASTQ >> $FILES_TO_PROCESS
    fi

done < $FILES_LIST

NUM_FILES=$(lc $FILES_TO_PROCESS)

echo \"Found $NUM_FILES to process\"

echo \"Splitting them up in batches of "$STEP_SIZE"\"

let i=1

while (( "$i" <= "$NUM_FILES" )); do
    export FILE_START=$i
    echo Doing file $i plus 9 more if possible
    JOB=$(qsub -V -N dedup-fq -j oe -o "$STDOUT_DIR" $WORKER_DIR/run-dedup.sh)
    if [ $? -eq 0 ]; then
      echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" Remember: time you enjoy wasting is not wasted time.
    else
      echo -e "\nError submitting job\n$JOB\n"
    fi
    (( i += $STEP_SIZE )) 
done
