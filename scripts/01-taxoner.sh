#!/usr/bin/env bash

#
# This script is intended to use taxoner to map fastas to a metagenome 
#

source ./config.sh

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

if [[ -d "$TAXONER_OUT_DIR" ]]; then
    rm -rf $TAXONER_OUT_DIR/*
else
    mkdir -p "$TAXONER_OUT_DIR"
fi

cd "$SPLIT_FA_DIR"

export FILES_LIST="split-files"

find . -type f -name \*.fa | sed "s/^\.\///" > $FILES_LIST

NUM_FILES=$(lc $FILES_LIST)

if [[ $NUM_FILES -eq 5331 ]]; then
    while read FASTA; do
        FULLPATH=$SPLIT_FA_DIR/$FASTA
            
        OUT_DIR=$TAXONER_OUT_DIR/$FASTA

        if [[ ! -d "$OUT_DIR" ]]; then
            mkdir -p "$OUT_DIR"
        fi

        taxoner64 -t 12 \
        --dbPath $BOWTIEDB \
        --taxpath $TAXA/nodes.dmp \
        --seq $FULLPATH \
        --output $OUT_DIR \
        --fasta \
        -y $PRJ_DIR/scripts/extra_commands.txt &>> $STDOUT_DIR/taxoner64_log

   done < "$FILES_LIST"
fi


