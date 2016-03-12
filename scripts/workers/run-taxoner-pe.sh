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

LEFT_TMP_FILES=$(mktemp)
RIGHT_TMP_FILES=$(mktemp)

get_lines $LEFT_FILES_LIST $LEFT_TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE
get_lines $RIGHT_FILES_LIST $RIGHT_TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $LEFT_TMP_FILES)

echo Found \"$NUM_FILES\" files to process

while read LEFT_FASTQ; do

    while read RIGHT_FASTQ; do

        test2=$(echo $RIGHT_FASTQ | sed s/_R[1-2]//)
        test1=$(echo $LEFT_FASTQ | sed s/_R[1-2]//)

        if [ "$test1" = "$test2" ]; then
            IN_LEFT=$SORTNMG_DIR/$LEFT_FASTQ
            IN_RIGHT=$FILTERED_FQ/$RIGHT_FASTQ

            OUT_DIR=$TAXONER_OUT_DIR/$LEFT_FASTQ

            if [[ ! -d "$OUT_DIR" ]]; then
                mkdir -p "$OUT_DIR"
            fi
            
            if [[ -z $(find $OUT_DIR -iname Taxonomy.txt) ]]; then
                echo "Processing $LEFT_FASTQ and $RIGHT_FASTQ"
            else
                echo "Taxonomy.txt already exists, skipping..."
                continue
            fi

            taxoner64 -t 12 \
                -A \
                --dbPath $BOWTIEDB \
                --taxpath $TAXA \
                --seq $IN_LEFT \
                --paired $IN_RIGHT \
                --output $OUT_DIR \
                -y $PRJ_DIR/scripts/extra_commands.txt
        fi

    done

done < "$LEFT_TMP_FILES"
 
if [[ $PBS_ARRAY_INDEX -eq 91 ]]; then
    python $HOME/mailsender.py
fi

