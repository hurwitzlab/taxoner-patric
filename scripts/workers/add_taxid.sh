#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=2:mem=4gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=48:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

source /usr/share/Modules/init/bash

set -u

COMMON="$SCRIPT_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

echo Host `hostname`

echo Started `date`

if [ -z $SCRIPT_DIR ]; then
  echo Missing SCRIPT_DIR
  exit 1
fi

#FASTA=`head -n +${PBS_ARRAY_INDEX} $FILES_LIST | tail -n 1`

TMP_FILES=$(mktemp)

get_lines $FILES_LIST $TMP_FILES ${PBS_ARRAY_INDEX:=1} $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo Processing \"$NUM_FILES\" input files

while read FASTA; do

  FILE="$BLAST_OUT_DIR/$FASTA"

## e.g.
# FILE =
# /rsgrps/bhurwitz/scottdaniel/blast-pipeline/blast-out \
# /simap.1/10ksample_DNA_4_GCCAAT_L002_R1_004.fa/01.fa

  echo Annotating File \"$FILE\"

  ANNOT_OUT="$ANNOT_OUT_DIR/$FASTA"

## e.g.
# ANNOT_OUT =
# /rsgrps/bhurwitz/scottdaniel/blast-pipeline/annot-out \
# /simap.1/10ksample_DNA_4_GCCAAT_L002_R1_004.fa/01.fa

  DIR=`dirname $ANNOT_OUT`

  if [[ ! -d $DIR ]]; then
	  mkdir -p $DIR
  fi

  if [[ -e $ANNOT_OUT ]]; then
	  rm -rf $ANNOT_OUT
  fi

  time $SCRIPT_DIR/add_taxid.pl --input $FILE --output $DIR --simap $SIMAP --ncbi $TAXA

done < $TMP_FILES

echo Finished `date`
