#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q qualified
#PBS -l select=1:ncpus=2:mem=12gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

unset module
set -u

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

echo "Getting fastq entries with maxscore of "$MAXSCORE""

cd $CLIPPED_FASTQ

TEMP=$(find ./)

for FASTQ in $(find ./); do
    TAXFILE="$KRONA_OUT_DIR/$SAMPLE"
    OUTPUT=$LOW_QUAL_DIR/DNA_"$NUM".lowqual.fastq
    echo Using "$FASTA" as input and searching through "$FASTQ" and
    echo will output to "$OUTPUT"
    python $WORKER_DIR/alt-fetch-fastq.py \
        --fastq $FASTQ \
        --fasta $TAXFILE \
        --output $OUTPUT \
        --max $MAXSCORE
done

