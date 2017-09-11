#!/usr/bin/env bash
#
# Get the dang fastq from the "unknown" fasta 
#

set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=100

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

if [[ ! -d $UNK2_OUT_DIR ]]; then
    mkdir -p $UNK2_OUT_DIR
fi

cd "$READ_OUT_DIR"

export FILES_LIST="$PRJ_DIR/fasta-files-list"

find . -type f -name \*.fastq | sed "s/^\.\///" > $FILES_LIST

NUM_FILES=$(lc $FILES_LIST)

echo Found \"$NUM_FILES\" files in \"$READ_OUT_DIR\"

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N fetch-fq -j oe -o "$STDOUT_DIR" $WORKER_DIR/fetch-unal.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" Remember: time you enjoy wasting is not wasted time.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
