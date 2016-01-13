#!/usr/bin/env bash

#script to run samtools on the .sam's outputted by taxoner to get all the read id's from the unaligned reads

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=6:mem=11gb
#PBS -l pvmem=22gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

cd $PBS_O_WORKDIR
CONFIG="$PRJ_DIR/scripts/config.sh"

if [ -e $CONFIG ]; then
    . "$CONFIG"
else
    echo MIssing config \"$CONFIG\"
    exit 12385
fi

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

TMP_FILES=$(mktemp)

get_lines $FILES_TO_PROCESS $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo Found \"$NUM_FILES\" files to process

while read SAM; do
    FULLPATH=$TAXONER_OUT_DIR/$SAM
    
    OUT_DIR=$READ_OUT_DIR/$(dirname $SAM)

    if [[ ! -d "$OUT_DIR" ]]; then
        mkdir -p "$OUT_DIR"
    fi
    
    if [[ -z $(find $OUT_DIR -iname \*.unaligned.fasta) ]]; then
        echo "Processing $SAM"
    else
        echo "Unaligned fasta already exists, skipping..."
        continue
    fi
    #gets the plain name "0.fasta.sam"
    NAME=$(basename $SAM)
    #gets the leading number "0"
    NUM=$(echo $NAME | sed s/[^0-9]//g)

    samtools fasta -f 4 $FULLPATH > $OUT_DIR/$NUM.unaligned.fasta

done < "$TMP_FILES"



