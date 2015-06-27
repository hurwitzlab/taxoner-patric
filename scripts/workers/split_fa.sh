#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=serial
#PBS -l select=1:ncpus=2:mem=4gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

echo Host `hostname`

echo Started `date`

source /usr/share/Modules/init/bash

FASPLIT="$BIN_DIR/faSplit"

if [[ ! -e "$FASPLIT" ]]; then
    echo Cannot find faSplit \"$FASPLIT\"
    exit 1
fi

if [[ ! -e "$FILES_LIST" ]]; then
    echo Cannot find files list \"$FILES_LIST\"
    exit 1
fi

cd $FASTA_DIR

i=0
while read FILE; do
    let i++

    BASENAME=`basename $FILE`

    OUT_DIR="$SPLIT_FA_DIR/$BASENAME"

    printf "%5d: %s\n" $i "$BASENAME"

    if [ -d "$OUT_DIR" ]; then
        rm -rf $OUT_DIR/*
    else
        mkdir -p $OUT_DIR
    fi

    #
    # Split <file> into chunks of N, put files into <out> directory
    #
    $FASPLIT about "$FILE" "$FA_SPLIT_FILE_SIZE" "$OUT_DIR/"
done < "$FILES_LIST"

echo Finished `date`
