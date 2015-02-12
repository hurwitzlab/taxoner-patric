#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=serial
#PBS -l select=1:ncpus=2:mem=4gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00

echo HOSTNAME `hostname`
source /usr/share/Modules/init/bash

cd $FASTA_DIR

FILE=`head -n ${PBS_ARRAY_INDEX} files | tail -n 1`

if [ "${FILE}x" == "x" ]; then
    echo nothing found for PBS_ARRAY_INDEX $PBS_ARRAY_INDEX
    exit 1
fi

BASENAME=`basename $FILE`
OUT_DIR="$SPLIT_FA_DIR/$BASENAME"

echo OUT_DIR $OUT_DIR

if [ -d $OUT_DIR ]; then
    rm -rf $OUT_DIR/*
else
    mkdir -p $OUT_DIR
fi

#
# Split <file> into chunks of N, put files into <out> directory
#
FASPLIT="$BIN_DIR/faSplit"

echo $FASPLIT about $FILE $FA_SPLIT_FILE_SIZE "$OUT_DIR/"

$FASPLIT about $FILE $FA_SPLIT_FILE_SIZE "$OUT_DIR/"
