#!/usr/bin/env bash

#
# This script is intended to use taxoner to map fastas to a metagenome 
#

source ./config.sh

PROG=`basename $0 ".sh"`
STDERR_DIR="$CWD/err/$PROG"
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDERR_DIR" "$STDOUT_DIR"

if [[ ! -d "$TAXONER_OUT_DIR" ]]; then
    mkdir -p "$TAXONER_OUT_DIR"
fi

cd "$SPLIT_FA_DIR"

export FILES_LIST="split-files"

find . -type f -name \*.fa | sed "s/^\.\///" > $FILES_LIST

NUM_FILES=$(lc $FILES_LIST)

export DNA1FILES="DNA_1_files"

egrep ^DNA_1.* split-files > $DNA1FILES

while read FASTA; do
    FULLPATH=$SPLIT_FA_DIR/$FASTA
    
    OUT_DIR=$TAXONER_OUT_DIR/$FASTA

    if [[ ! -d "$OUT_DIR" ]]; then
        mkdir -p "$OUT_DIR"
    fi

    #TODO:put in thing to clear out the dir (in case of subsequent runs)

    taxoner -p 12 \
        -dbPath $BOWTIEDB \
        -taxpath $TAXA/nodes.dmp \
        -seq $FULLPATH \
        -o $OUT_DIR \
        -fasta -no-unal \
        &> $SCRIPT_DIR/../log8

done < "$DNA1FILES"


