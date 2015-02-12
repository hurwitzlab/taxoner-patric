#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=serial
#PBS -l select=1:ncpus=12:mem=23gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00

module load perl

#
# BLAST parameters
#
DESC="10"
ALN="10"
EVAL="1e-3"
MAX_HSPS="10"
OUT_FMT="6" # tabular

cd "$SPLIT_FA_DIR"

FASTA=`head -n +${PBS_ARRAY_INDEX} split-files | tail -n 1`

#
# Read the BLAST_CONF_FILE and use each line to launch a BLAST 
#
if [ -e $BLAST_CONF_FILE ]; then
    while read BLAST_DB_NAME BLAST_BINARY BLAST_DB; do
        echo BLAST_DB_NAME $BLAST_DB_NAME
        echo BINARY        $BINARY
        echo BLAST_DB      $BLAST_DB

        BLAST_OUT="$BLAST_OUT_DIR/$BLAST_DB_NAME/$FASTA"
        DIR=`dirname "$BLAST_OUT"`

        if [[ ! -e $DIR ]]; then
            mkdir -p $DIR
        fi

        echo "$BLAST_BINARY -query $FASTA -out $BLAST_OUT -max_hsps $MAX_HSPS -db $BLAST_DB -evalue $EVAL -outfmt $OUT_FMT"

        $BLAST_BINARY -query $FASTA -out $BLAST_OUT -max_hsps $MAX_HSPS \
            -db $BLAST_DB -evalue $EVAL -outfmt $OUT_FMT

    done < "$BLAST_CONF_FILE"
else 
    echo "Cannot find BLAST_CONF_FILE $BLAST_CONF_FILE"
fi


#$SCRIPT_DIR/run_blast.pl -o $WRITE_DIR -q $FASTA -d $BLAST_CONF_FILE
