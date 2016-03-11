#!/usr/bin/env bash

#
# This script is intended to use taxoner to map fastas to a metagenome 
#

set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=10

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

if [[ -d "$BOWTIE2_OUT_DIR" ]]; then
    echo "Continuing where you left off..."
else
    mkdir -p "$BOWTIE2_OUT_DIR"
fi

cd "$SORTNMG_DIR"

export LEFT_FILES_LIST="$PRJ_DIR/sorted_left_fastqs"
export RIGHT_FILES_LIST="$PRJ_DIR/sorted_right_fastqs"

echo "Finding fastq's"

#-bash-4.1$ find ./ -iname \*.1.fastq | wc -l
#95
#-bash-4.1$ find ./ -iname \*.2.fastq | wc -l
#95
#-bash-4.1$ find ./ -iname \*nomatch\* | wc -l
#196
#
find . -type f -iname \*.1.fastq | sed "s/^\.\///" | sort > $LEFT_FILES_LIST 
find . -type f -iname \*.2.fastq | sed "s/^\.\///" | sort > $RIGHT_FILES_LIST 

echo "Checking if already processed"

if [ -e $PRJ_DIR/files-to-process ]; then
    rm $PRJ_DIR/files-to-process
fi

export FILES_TO_PROCESS="$PRJ_DIR/files-to-process"

while read FASTQ; do
 
    OUT_DIR=$BOWTIE2_OUT_DIR/$(dirname $FASTQ)

    OUT=$OUT_DIR/$(basename $FASTQ ".fa").sam

    if [[ -e $OUT ]]; then
        continue
    else
        echo $FASTQ >> $FILES_TO_PROCESS
    fi

done < $LEFT_FILES_LIST

NUM_FILES=$(lc $FILES_TO_PROCESS)

echo \"Found $NUM_FILES to process\"

echo \"Splitting them up in batches of "$STEP_SIZE"\"

let i=1

while (( "$i" <= "$NUM_FILES" )); do
    export FILE_START=$i
    echo Doing file $i plus 9 more if possible
    sbatch -o $STDOUT_DIR/run-bowtie2.out.$i $WORKER_DIR/run-bowtie2.sh
    (( i += $STEP_SIZE )) 
done
