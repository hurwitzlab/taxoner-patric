#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=2:mem=3gb:pcmem=2gb
#PBS -l pvmem=6gb
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

cd $TRIMMED_DIR

echo Doing sample $SAMPLE

set -x
echo fixing lines

sed -i.bak -e 's/-1$/\/1/' -e 's/-2$/\/2/' "$SAMPLE".deduped.fastq.abundfilt

if [[ $? -eq 0 ]]; then
    rm *.bak
else
    echo Something went wrong with sed
fi

echo Done at $(date)
