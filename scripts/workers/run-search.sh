#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=2:mem=3gb:pcmem=2gb
#PBS -l pvmem=6gb
#PBS -l walltime=24:10:00
#PBS -l cput=24:10:00
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

TMP_FILES=$(mktemp)

get_lines $DNADBLIST $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo Found \"$NUM_FILES\" files to process

echo Running perl script

let i=1

while read DB; do

    SEARCH_FILE=$(egrep ".+DNA_$NUM.+" $FILES_LIST)
    
    if [[ $i -eq 1 ]]; then

        echo Working on $SEARCH_FILE

    fi

    OUT_DIR=$HIGH_QUAL_DIR/$DB
    
    IN_DB=$SPLIT_FA_DIR/$DB

    if [[ ! -d "$OUT_DIR" ]]; then
        mkdir -p "$OUT_DIR"
    fi

    if [[ -z $(find $OUT_DIR -type f -iname \*.fa) ]]; then
        echo Using the fasta database here: $IN_DB
        echo Outputting to $OUT_DIR
    else
        echo Search already done on $IN_DB, continuing to the next...
        continue
    fi

    perl $WORKER_DIR/fasta-search.pl $IN_DB $SEARCH_FILE $OUT_DIR

    let i++

done < $TMP_FILES
 

