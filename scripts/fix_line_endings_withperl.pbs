#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q qualified
#PBS -l select=1:ncpus=2:mem=12gb
###and the amount of time required to run it
#PBS -l walltime=6:00:00
#PBS -l cput=6:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea
#PBS -o ./out
#PBS -e ./out

echo Started at $(date)

if [ -n "$PBS_O_WORKDIR" ]; then
    cd $PBS_O_WORKDIR
fi

set -u

CONFIG="./config.sh"

if [ -e $CONFIG ]; then
    source $CONFIG
else
    echo "NO \"$CONFIG\""
    exit 1
fi

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

cd $READ_OUT_DIR

export LBAD="./left-bad-files"
export RBAD="./right-bad-files"

if [[ ! -e $LBAD ]]; then
    echo no list of files to fix
    exit 1
elif [[ ! -e $RBAD ]]; then
    echo no list of files to fix
    exit 1
fi

while read FILE; do
    perl -pi.bak -e 'if (/^>/) { s{$}{/1} }' $FILE
done < $LBAD

while read FILE; do
    perl -pi.bak -e 'if (/^>/) { s{$}{/2} }' $FILE
done < $RBAD
