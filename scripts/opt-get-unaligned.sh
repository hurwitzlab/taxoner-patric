#!/usr/bin/env bash

#
# This script is intended to use samtools and seqtk to extract unaligned reads from sam files and generate fastqs for input to an assembler
#

set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=100

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

if [[ -d "$READ_OUT_DIR" ]]; then
    echo "Continuing where you left off..."
else
    mkdir -p "$READ_OUT_DIR"
fi

cd "$TAXONER_OUT_DIR"

export FILES_LIST="$PRJ_DIR/sam-files"

echo "Finding sam's"

find . -type f -iname \*.sam | sed "s/^\.\///" > $FILES_LIST

echo "Checking if already processed"

if [ -e $PRJ_DIR/sams-to-process ]; then
    rm $PRJ_DIR/sams-to-process
fi

export FILES_TO_PROCESS="$PRJ_DIR/sams-to-process"

while read SAM; do

    OUT_DIR=$READ_OUT_DIR/$(dirname $SAM)

    #gets the plain name "0.fastq.sam"
    NAME=$(basename $SAM)
    #gets the leading number "0"
    NUM=$(echo $NAME | sed s/[^0-9]//g)

    if [[ -d $OUT_DIR ]]; then
        if [[ -z $(find $OUT_DIR -iname $NUM.unaligned.fastq) ]]; then
            echo $SAM >> $FILES_TO_PROCESS
        else
            continue
        fi
    else
        echo $SAM >> $FILES_TO_PROCESS
    fi

done < $FILES_LIST

NUM_FILES=$(lc $FILES_TO_PROCESS)

echo \"Found $NUM_FILES to process\"

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N samfast -j oe -o "$STDOUT_DIR" $WORKER_DIR/run-samtools.sh)

if [ $? -eq 0 ]; then
    echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\"
    echo Hip-hip-hooray.
else
    echo -e "\nError submitting job\n$JOB\n"
fi
