#!/bin/bash

####Adjust memory as needed for size of input####

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=2:mem=3gb:pcmem=2gb
#PBS -l pvmem=6gb
#PBS -l walltime=2:00:00
#PBS -l cput=2:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

source /usr/share/Modules/init/bash

set -u
#-u  Treat unset variables as an error when substituting.

COMMON="$WORKERS_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

if [ -z $SCRIPT_DIR ]; then
  echo Missing SCRIPT_DIR
  exit 1
fi

echo Started $(date)

echo Host $(hostname)

TMP_FILES=$(mktemp)

get_lines $TAXA_TEXT_FILES $TMP_FILES ${PBS_ARRAY_INDEX:=1} $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo Processing \"$NUM_FILES\" input files
        
while read INPUT; do

    FILE="$KRONA_OUT_DIR/$INPUT"
    
    if [[ $INPUT =~ ^DNA_4.* ]]; then SAMPLE="DNA_4"; fi
    if [[ $INPUT =~ ^DNA_3.* ]]; then SAMPLE="DNA_3"; fi
    if [[ $INPUT =~ ^DNA_2.* ]]; then SAMPLE="DNA_2"; fi
    if [[ $INPUT =~ ^DNA_1.* ]]; then SAMPLE="DNA_1"; fi

    FILE_OUT="$COUNT_OUT_DIR/$SAMPLE"
    OUTPUT_FILE1="$FILE_OUT"_taxonomy_per_read.txt
    OUTPUT_FILE2="$FILE_OUT"_taxonomy_counts.txt

    if [[ -e $OUTPUT_FILE1 ]]; then
        rm -rf $OUTPUT_FILE1
    fi

    if [[ -e $OUTPUT_FILE2 ]]; then
        rm -rf $OUTPUT_FILE2
    fi

    $WORKERS_DIR/id2tax.py -f $FILE --out1 $OUTPUT_FILE1 --out2 $OUTPUT_FILE2 \

done < "$TMP_FILES"

echo Finished $(date)
