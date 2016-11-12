#!/usr/bin/env bash

#
#This script is intended to fetch sequences from files when you only have the read id's (Eg: HWI-blabla)
#
unset module
set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=100 #adjust as needed

if [[ $# = 0 ]]; then
    echo "Need to know what max alignment score you want"
    echo "e.g. ./opt-getLowQual 131 will get everything below 131"
    exit 1
fi

export MAXSCORE=$1

echo Setting up log files...
PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
export STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

if [[ ! -d $LOW_QUAL_DIR ]]; then
    mkdir -p $LOW_QUAL_DIR
fi

export FILES_LIST="$PRJ_DIR/krona-files"

if [[ ! -e "$FILES_LIST" ]]; then
    find $KRONA_OUT_DIR -type f -iname \*simple.txt\* | sed "s/^\.\///" > $FILES_LIST
else
    echo $FILES_LIST already exists, assuming it\'s fine
fi

echo \"Processing $(lc $FILES_LIST) samples\"

echo \"Splitting up the work by sample\"

while read SAMPLE; do
    export SAMPLE
    export NUM=$(echo $(basename $SAMPLE) | sed s/[^0-9]//g)

    JOB=$(qsub -V -N fetch_dog_$NUM -j oe -o "$STDOUT_DIR" $WORKER_DIR/fetch-lowqual.sh)

    if [ $? -eq 0 ]; then
      echo Submitted job \"$JOB\" for you. La la la. La. la.
    else
      echo -e "\nError submitting job\n$JOB\n"
    fi

done < $FILES_LIST



