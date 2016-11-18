#!/usr/bin/env bash

#this works with scripts/opt-interleave.sh

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=12gb
#PBS -l walltime=12:00:00
#PBS -l cput=12:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

set -u

echo "Started at $(date)"

COMMON=$WORKER_DIR/common.sh

if [[ -e $COMMON ]]; then
    source $COMMON
else
    echo missing "$COMMON"
    exit 1
fi

cd $SORTNMG_DIR

if [[ -z "$SAMPLE" ]]; then
    echo "Need variable \$SAMPLE"
    exit 1
fi

LEFT=$(mktemp)

find ./ -regextype egrep -iregex "\.\/"$SAMPLE".*\.[1].*" > $LEFT

if [[ $(lc $LEFT) = 0 ]]; then
    echo No files to work on
    exit 1
fi

echo Working on $(lc $LEFT) files

for LFILE in $(cat $LEFT); do

    PREFIX=$(basename $LFILE ".1.fastq")

    interleave-reads.py -f -o "$PREFIX".tmp "$PREFIX".1.fastq "$PREFIX".2.fastq

    if [[ $? = 0 ]]; then
        echo Looks like interleaving worked
        echo moving old files in ../tmpbackup just in case
        echo And renaming .tmp to .1.fastq
    else
        echo something went wrong with interleaving
        exit 1
    fi

    if [[ $(file "$PREFIX".tmp) =~ "cannot" ]]; then
        echo interleave-reads.py didnt really work
        exit 1
    else
        mv "$PREFIX".1.fastq ../tmpbackup/
        mv "$PREFIX".2.fastq ../tmpbackup/
        mv "$PREFIX".tmp "$PREFIX".1.fastq
    fi
   
echo "Done at $(date)"
