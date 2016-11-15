#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q qualified
#PBS -l select=1:ncpus=2:mem=12gb
###and the amount of time required to run it
#PBS -l walltime=6:00:00
#PBS -l cput=6:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

echo Started at $(date)

if [ -n "$PBS_O_WORKDIR" ]; then
    cd $PBS_O_WORKDIR
fi

set -u

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

cd $CLIPPED_DIR

TMP_FILES=$(mktemp)

get_lines $FILE_LIST $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

if [[ $NUM_FILES -le 1 ]]; then
    echo Something went wrong or no files to process
    exit 1
else
    echo Found \"$NUM_FILES\" files to process
fi

for FILE in $(cat $TMP_FILES); do
    echo Doing $FILE
    FASTQ="$CLIPPED_DIR/$FILE"
    sed -i.bak -e 's/ 1.*$/\/1/' -e 's/ 2.*$/\/2/' $FASTQ

    if [[ $? -eq 0 ]]; then
        rm *.bak
    else
        echo Something went wrong with sed
    fi
done

echo Done at $(date)
