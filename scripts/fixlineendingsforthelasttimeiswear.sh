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

export LLIST="./left-list-of-all"

#list of all forward (or left) unpaired fastq files
find ./*nomatch1.fastq -type f -iname "*.fastq" >> $LLIST

if [[ $(lc $LLIST) < 1 ]]; then
    echo NoFILES
    exit 1
fi

export LBAD="./left-bad-files"

#finds files without /1 in them
for i in $(cat $LLIST); do grep -P -l ">HWI.*[^/]\d$" $i >> $LBAD; done

#TODO: offline or interactive python them
#or perl, i don't care
#python fix-effing-unpaired.py --file_in $LBAD

###RIGHT SIDE already done
#export RLIST="./right-list-of-all"
#
##list of all reverse (or right) unpaired fastq files
#find ./*nomatch2.fastq -type f -iname "*.fastq" >> $RLIST
#
#if [[ $(lc $RLIST) < 1 ]]; then
#    echo NoFILES
#    exit 1
#fi
#
#export RBAD="./right-bad-files"
#
##finds files without /2 in them
#for i in $(cat $RLIST); do grep -P -l ">HWI.*[^/]\d$" $i >> $RBAD; done
#
#
