#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=6:mem=11gb
#PBS -l pvmem=22gb
#PBS -l place=pack:shared
#PBS -l walltime=48:00:00
#PBS -l cput=48:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

#Expects SCRIPTS,STEP_SIZE,TAXONER_DB_DIR,NEWDBLIST,NUM_FILES 

set -u

module load bowtie2

echo "Started at $(date) on host $(hostname)"

source /usr/share/Modules/init/bash

source $SCRIPTS/common.sh #Gets helpful functions

cd $TAXONER_DB_DIR

echo "Bowtie2 indexing..."

TMP_FILES=$(mktemp)

get_lines $NEWDBLIST $TMP_FILES ${PBS_ARRAY_INDEX:=1} $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo Processing \"$NUM_FILES\" input files

while read DB; do
    bowtie2-build $DB $DB
done < $TMP_FILES

echo "Done $(date)"
