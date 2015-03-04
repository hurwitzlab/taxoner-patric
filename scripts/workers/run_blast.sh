#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=serial
#PBS -l select=1:ncpus=12:mem=23gb:pvmem=23gb
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00

echo HOSTNAME `hostname`

module load perl

#
# BLAST parameters
#
NUM_THREADS=10 # make sure this is requested in the above "select"
DESC="10"
ALN="10"
EVAL="1e-3"
MAX_HSPS="10"
OUT_FMT="6" # tabular

cd "$SPLIT_FA_DIR"

FASTA=`head -n +${PBS_ARRAY_INDEX} split-files | tail -n 1`

echo FASTA $SPLIT_FA_DIR/$FASTA
#
# Read the BLAST_CONF_FILE and use each line to launch a BLAST 
#
if [ -e $BLAST_CONF_FILE ]; then
    while read BLAST_DB_NAME BLAST_BINARY BLAST_DB; do
        BLAST_OUT="$BLAST_OUT_DIR/$BLAST_DB_NAME/$FASTA"
        DIR=`dirname "$BLAST_OUT"`

        echo BLAST_DB_NAME $BLAST_DB_NAME
        echo BLAST_BINARY  $BLAST_BINARY
        echo BLAST_DB      $BLAST_DB
        echo BLAST_OUT     $BLAST_OUT

        if [[ ! -e $DIR ]]; then
            mkdir -p $DIR
        fi

        $BLAST_BINARY -query $FASTA -out $BLAST_OUT -max_hsps $MAX_HSPS \
            -db $BLAST_DB -evalue $EVAL -outfmt $OUT_FMT \
            -num_threads $NUM_THREADS

    done < "$BLAST_CONF_FILE"
else 
    echo "Cannot find BLAST_CONF_FILE $BLAST_CONF_FILE"
fi
