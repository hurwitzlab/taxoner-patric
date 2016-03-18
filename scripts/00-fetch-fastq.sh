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

#JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N fetch-fq -j oe -o "$STDOUT_DIR" $WORKER_DIR/fetch-fq.sh)

let i=1

while (( "$i" <= "$NUM_FILES" )); do
    export FILE_START=$i
    echo Doing file $i plus 19 more if possible
    sbatch -o $STDOUT_DIR/fetch-fastq.out.$i $WORKER_DIR/fetch-fq.sh
    (( i += $STEP_SIZE )) 
done
