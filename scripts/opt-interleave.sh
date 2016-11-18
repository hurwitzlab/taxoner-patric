#!/usr/bin/env bash

#
# interleave together .1 and .2 fastqs (not the nomatch) in sortnmerge dir
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
export SAMPLE_LIST="$PRJ_DIR/sample_list"

echo \
"DNA_1
DNA_2
DNA_3
DNA_4" > $SAMPLE_LIST

while read SAMPLE; do
    echo "Doing "$SAMPLE""

    export SAMPLE=$SAMPLE

    qsub -V -j oe -o "$STDOUT_DIR" $WORKER_DIR/interleave-reads.sh

done < $SAMPLE_LIST
