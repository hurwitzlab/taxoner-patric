#!/usr/bin/env bash

#
# This script is intended to use taxoner to map fastas to a metagenome 
#

set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=100

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

if [[ -d "$TAXONER_OUT_DIR" ]]; then
    rm -rf $TAXONER_OUT_DIR/*
else
    mkdir -p "$TAXONER_OUT_DIR"
fi

cd "$SPLIT_FA_DIR"

export FILES_LIST="$PRJ_DIR/split-files"

find . -type f -iwholename \*DNA_2\*.fa | sed "s/^\.\///" > $FILES_LIST

NUM_FILES=$(lc $FILES_LIST)

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -v PRJ_DIR,STEP_SIZE,SCRIPT_DIR,BIN_DIR,FILES_LIST,SPLIT_FA_DIR,TAXONER_OUT_DIR -N taxoner64 -j oe -o "$STDOUT_DIR" $SCRIPT_DIR/run-taxoner.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" Remember: time you enjoy wasting is not wasted time.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
