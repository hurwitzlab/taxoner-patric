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

#TODO:need to put this part in the python script
#so that it only loads the taxonomy.txt once and iterates through
#each fastq in the list of clipped fastqs
#even better would be to split up the number of clipped fastqs
#in the above script "opt-getLowqual.sh" and do as a job array
for FASTQ in $(find ./ -type f); do
    
    TAXFILE="$SAMPLE"

    OUT_DIR=$LOW_QUAL_DIR/$(basename $FASTQ ".fastq.trimmed.clipped")

    if [[ ! -d $OUT_DIR ]]; then
        mkdir -p $OUT_DIR
    fi

    OUTPUT=$OUT_DIR/lowqual.fastq

    echo Using "$TAXFILE" as input and searching through "$FASTQ" and
    echo will output to "$OUTPUT"
    python $WORKER_DIR/alt-fetch-fastq.py \
        --fastq $FASTQ \
        --fasta $TAXFILE \
        --output $OUTPUT \
        --max $MAXSCORE
done

