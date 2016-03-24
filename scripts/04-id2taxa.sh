#!/usr/bin/env bash

#
#This script is intended to count taxon ids for your samples and make a table
#that can be analyzed in R or some other software
#

unset module
set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=1 #adjust as needed

echo Setting up log files...
PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

echo Making output dir...
if [ ! -d $COUNT_OUT_DIR ]; then
    mkdir -p $COUNT_OUT_DIR
fi

cd $KRONA_OUT_DIR

export TAXA_TEXT_FILES="$PRJ_DIR/taxa_files"

find . -maxdepth 1 -type f -iname \*filt.txt | sed "s/^\.\///" > $TAXA_TEXT_FILES

NUM_FILES=$(lc $TAXA_TEXT_FILES)

echo \"Found $NUM_FILES to process\"

echo Submitting job...

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N taxaCount -j oe -o "$STDOUT_DIR" $WORKER_DIR/run-id2taxa.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you. Ya ya ya.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
