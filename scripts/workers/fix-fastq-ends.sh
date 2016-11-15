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

cd $KRONA_OUT_DIR

echo Doing sample $SAMPLE

set -x
echo fixing lines

time sed -i.bak -e 's/-1/\/1/' -e 's/-2/\/2/' "$SAMPLE"_simple.txt

if [[ $? -eq 0 ]]; then
    rm *.bak
else
    echo Something went wrong with sed
fi

echo Done at $(date)
