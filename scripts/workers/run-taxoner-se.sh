#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=12:mem=23gb
#PBS -l pvmem=46gb
#PBS -l place=pack:shared
#PBS -l walltime=72:00:00
#PBS -l cput=72:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

TMP_FILES=$(mktemp)

get_lines $FILES_TO_PROCESS $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo Found \"$NUM_FILES\" files to process

while read FASTQ; do
    FULLPATH=$SORTNMG_DIR/$FASTQ
    
    OUT_DIR=$TAXONER_OUT_DIR/$FASTQ

    if [[ ! -d "$OUT_DIR" ]]; then
        mkdir -p "$OUT_DIR"
    fi
    
    if [[ -z $(find $OUT_DIR -iname Taxonomy.txt) ]]; then
        echo "Processing $FASTQ"
    else
        echo "Taxonomy.txt already exists, skipping..."
        continue
    fi

    taxoner64 -t 12 \
        -A \
        --dbPath $BOWTIEDB \
        --taxpath $TAXA \
        --seq $FULLPATH \
        --output $OUT_DIR \
        -y $PRJ_DIR/scripts/extra_commands.txt

done < "$TMP_FILES"



