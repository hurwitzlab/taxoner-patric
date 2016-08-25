#!/usr/bin/env bash
#
# This script is intended to get back the original fastq's from your screened fasta's
#

set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=20

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR" "$FILTERED_FQ"

cd "$FASTA_DIR"

export FILES_LIST="$PRJ_DIR/fasta-files-list"

find . -type f -name \*.fa | sed "s/^\.\///" > $FILES_LIST

NUM_FILES=$(lc $FILES_LIST)

echo Found \"$NUM_FILES\" files in \"$FASTA_DIR\"

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N fetch-fq -j oe -o "$STDOUT_DIR" $WORKER_DIR/fetch-fq.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" Remember: time you enjoy wasting is not wasted time.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
