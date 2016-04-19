#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=6:mem=11gb
#PBS -l pvmem=22gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

set -u

echo "Started at $(date) on host $(hostname)"

TMP_FILES=$(mktemp)

get_lines $FILES_TO_PROCESS $TMP_FILES $FILE_START $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo Found \"$NUM_FILES\" files to process
echo Processing $(cat $TMP_FILES)

while read FASTQ; do

    IN=$SORTNMG_DIR/$FASTQ
    OUT=$DEDUP_DIR/$(basename $FASTQ ".fastq").dedupped.fasta

    fastx_collapser -v -i $IN -o $OUT

done < $TMP_FILES
    
echo "Done at $(date)"

