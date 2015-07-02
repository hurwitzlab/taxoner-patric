#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=12:mem=23gb:pcmem=2gb
#PBS -l pvmem=46gb
#PBS -l walltime=24:00:00
#PBS -l cput=72:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

echo Started `date`

echo Host `hostname`

#
# BLAST parameters
#
NUM_THREADS=12 # make sure this is requested in the above "select"
DESC="10"
ALN="10"
EVAL="1e-3"
MAX_HSPS="10"
OUT_FMT="8" # tabular
NUM_CPU="12"

cd "$SPLIT_FA_DIR"

FASTA=`head -n +${PBS_ARRAY_INDEX} $FILES_LIST | tail -n 1`

FILE="$SPLIT_FA_DIR/$FASTA"

echo File \"$FILE\"

#
# Read the BLAST_CONF_FILE and use each line to launch a BLAST
#
if [ -e $BLAST_CONF_FILE ]; then
    while read BLAST_DB_NAME BLAST_TYPE BLAST_DB; do
        BLAST_OUT="$BLAST_OUT_DIR/$BLAST_DB_NAME/$FASTA"
        DIR=`dirname $BLAST_OUT`

        if [[ ! -d $DIR ]]; then
            mkdir -p $DIR
        fi

        if [[ -e $BLAST_OUT ]]; then
            rm -rf $BLAST_OUT
        fi

        $BLAST -p $BLAST_TYPE -a $NUM_THREADS -d $BLAST_DB -i $FILE -o $BLAST_OUT -e $EVAL -m $OUT_FMT

    done < "$BLAST_CONF_FILE"
else
    echo "Cannot find BLAST_CONF_FILE $BLAST_CONF_FILE"
fi

echo Finished `date`
