#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=2:mem=4gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

echo Host `hostname`

echo Started `date`

source /usr/share/Modules/init/bash

TMP_FILES=$(mktemp)

get_lines $FILES_TO_PROCESS $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo Found \"$NUM_FILES\" files to process

export SEARCH_LIST=$(ls $CLIPPED_FASTQ)

for NAME in $(cat $TMP_FILES); do 
    echo Using $NAME
    SHORT=$(basename $NAME '.fa')
    echo $SHORT
    FOUND=$(egrep $SHORT $SEARCH_LIST)
    FASTA="$FASTA_DIR/$NAME"
    FASTQ="$CLIPPED_FASTQ/$FOUND"
    OUTPUT=$FILTERED_FQ/"$SHORT".filtered.fastq
    echo Using "$FASTA" as input and searching through "$FASTQ" and
    echo will output to "$OUTPUT"
    perl $WORKER_DIR/fetch-fq.pl $FASTQ $FASTA $OUTPUT
done
