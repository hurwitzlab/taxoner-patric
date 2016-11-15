#!/usr/bin/env bash
#
# Use sed to fix the line endings in the fastqs 
#

set -u
source ./config.sh
export CWD="$PWD"

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

for i in $SAMPLE_NAMES; do
    export SAMPLE=$i
    echo $i
    qsub -V -j oe -o "$STDOUT_DIR" $WORKER_DIR/fix-fastq-ends.sh
done

