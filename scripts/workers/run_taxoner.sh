#!/bin/bash

echo Started `date`

echo Host `hostname`

cd "$SPLIT_FA_DIR"

FASTA=`head -n +${INDEX} $FILES_LIST | tail -n 1`

FILE="$SPLIT_FA_DIR/$FASTA"

echo Processing File \"$FILE\"

taxoner 
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

        mpiexec -np 12 $BLAST -p $BLAST_TYPE -d $BLAST_DB -i $FILE -o $BLAST_OUT -e $EVAL -m $OUT_FMT

    done < "$BLAST_CONF_FILE"
else
    echo "Cannot find BLAST_CONF_FILE $BLAST_CONF_FILE"
fi

echo Finished `date`
