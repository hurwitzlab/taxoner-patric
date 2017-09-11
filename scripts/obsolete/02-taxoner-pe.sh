#!/usr/bin/env bash

#
# This script is intended to use taxoner to map fastqs to a metagenome 
#

set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=10
unset module

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

if [[ -d "$TAXONER_OUT_DIR" ]]; then
    echo "Continuing where you left off..."
else
    mkdir -p "$TAXONER_OUT_DIR"
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

    OUT_DIR=$TAXONER_OUT_DIR/$FASTQ

    if [[ -d $OUT_DIR ]]; then
        if [[ -z $(find $OUT_DIR -iname Taxonomy.txt) ]]; then
            echo $FASTQ >> $FILES_TO_PROCESS
        else
            continue
        fi
    else
        echo $FASTQ >> $FILES_TO_PROCESS
    fi

done < $LEFT_FILES_LIST

NUM_FILES=$(lc $FILES_TO_PROCESS)

echo \"Found $NUM_FILES to process\"

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N taxoner -j oe -o "$STDOUT_DIR" $WORKER_DIR/run-taxoner-pe.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" Remember: time you enjoy wasting is not wasted time.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
