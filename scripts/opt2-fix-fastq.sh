#!/usr/bin/env bash
#
# Use sed to fix the line endings in the fastqs 
#

set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=100

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

export FILE_LIST=$PRJ_DIR/clipped_search_list

cd $CLIPPED_DIR

find ./ -type f -iname "\*.clipped" | sed "s/^\.\///" > $FILE_LIST

NUM_FILES=$(lc $FILE_LIST)

echo Found \"$NUM_FILES\" files in \"$CLIPPED_DIR\"

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N fix-clipped -j oe -o "$STDOUT_DIR" $WORKER_DIR/fix-fastq-ends2.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" Remember: time you enjoy wasting is not wasted time.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
