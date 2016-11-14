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

#OPTIONAL: even better would be to split up the number of clipped fastqs
#in the above script "opt-getLowqual.sh" and do as a job array

#create the directories for you ahead of time
for FASTQ in $(find ./ -type f); do
    
    TAXFILE="$SAMPLE"

    OUT_DIR=$LOW_QUAL_DIR/$(basename $FASTQ ".fastq.trimmed.clipped")

    if [[ ! -d $OUT_DIR ]]; then
        mkdir -p $OUT_DIR
    fi

done

echo Using "$TAXFILE" as input and searching through fastqs
echo in $CLIPPED_FASTQ
python $WORKER_DIR/alt-fetch-fastq.py \
    --fastq-dir $CLIPPED_FASTQ \
    --fasta $TAXFILE \
    --output-dir $LOW_QUAL_DIR \
    --max $MAXSCORE

