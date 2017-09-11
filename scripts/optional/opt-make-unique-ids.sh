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

cd $KRONA_OUT_DIR

export TAXA_TEXT_FILES="$PRJ_DIR/taxa_files"

find . -maxdepth 1 -type f -iname \*Taxonomy.txt | sed "s/^\.\///" > $TAXA_TEXT_FILES

NUM_FILES=$(lc $TAXA_TEXT_FILES)

echo \"Found $NUM_FILES to process\"

echo Submitting job...

cd $SCRIPT_DIR

for file in $(cat $TAXA_TEXT_FILES); do

    export IN_NAME=$file
    export OUT_NAME=$file-out

    JOB=$(qsub -V -N simple -j oe -o "$STDOUT_DIR" $WORKER_DIR/simpler-tax.py)

    if [ $? -eq 0 ]; then
      echo Submitted job \"$JOB\" for you. Ya ya ya.
    else
      echo -e "\nError submitting job\n$JOB\n"
    fi
done
