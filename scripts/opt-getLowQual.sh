#!/usr/bin/env bash

#
#This script is intended to fetch sequences from fasta files when you only have the read id's (Eg: HWI-blabla)
#
unset module
set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=100 #adjust as needed

echo Setting up log files...
PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
export STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

export FILES_LIST="$PRJ_DIR/low-qual-files"

if [[ ! -e "$FILES_LIST" ]]; then
    find $KRONA_OUT_DIR -type f -iname \*lowqual\* | sed "s/^\.\///" > $FILES_LIST
else
    echo $FILES_LIST already exists, assuming it\'s fine
fi

echo \"Processing $(lc $FILES_LIST) samples\"

export DB_LIST="$PRJ_DIR/db-list" #essentially the same as split files

if [[ ! -e "$DB_LIST" ]]; then
    find $SPLIT_FA_DIR -regextype sed -type f -iregex '.+\.fa$' | sed "s/^\.\///" > $DB_LIST 
else
    echo $DB_LIST already exists, assuming it\'s fine
fi

echo \"Processing $(lc $DB_LIST) databases\"

echo \"Splitting up the work by sample\"

while read SAMPLE; do

    export NUM=$(echo $(basename $SAMPLE) | sed s/[^0-9]//g)

    export DNADBLIST="$PRJ_DIR/DNA_$NUM-db-list"

    egrep "DNA_$NUM.+" $DB_LIST > $DNADBLIST

    echo \"There are $(lc $DNADBLIST) database\'s in DNA_$NUM\"

    export NUM_SEARCHES=$(lc $DNADBLIST)

    JOB=$(qsub -J 1-$NUM_SEARCHES:$STEP_SIZE -V -N fetch_dog_$NUM -j oe -o "$STDOUT_DIR" $WORKER_DIR/run-search.sh)

    if [ $? -eq 0 ]; then
      echo Submitted job \"$JOB\" for you. La la la. La. la.
    else
      echo -e "\nError submitting job\n$JOB\n"
    fi

done < $FILES_LIST



