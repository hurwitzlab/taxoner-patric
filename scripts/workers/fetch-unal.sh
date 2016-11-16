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

TMP_FILES=$(mktemp)

get_lines $FILES_LIST $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

if [[ $NUM_FILES -le 1 ]]; then
    echo Something went wrong or no files to process
    exit 1
else
    echo Found \"$NUM_FILES\" files to process
fi

export SEARCH_LIST="$PRJ_DIR/merged_fastqs"

ls $SORTNMG_DIR > $SEARCH_LIST

for NAME in $(cat $TMP_FILES); do 
    echo Using $NAME
    SHORT=$(dirname $NAME | sed 's/\/Alignments//')
    echo $SHORT
    FOUND=$(egrep $SHORT $SEARCH_LIST)
    FASTA="$READ_OUT_DIR/$NAME"
    FASTQ="$SORTNMG_DIR/$FOUND"

    if [[ ! -d $UNK2_OUT_DIR/$SHORT ]]; then
        mkdir -p $UNK2_OUT_DIR/$SHORT
    fi

    OUTPUT=$UNK2_OUT_DIR/$SHORT/$(basename $NAME)
    echo Using "$FASTA" as input and searching through "$FASTQ" and
    echo will output to "$OUTPUT"
    python $WORKER_DIR/fetch-fastq.py \
        --fastq $FASTQ \
        --fasta $FASTA \
        --output $OUTPUT
done


