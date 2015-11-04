#!/bin/bash

####Adjust memory as needed for size of input####

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=2:mem=3gb:pcmem=2gb
#PBS -l pvmem=6gb
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

#Expects SUB_SAMPLES,RUNKEGG,RUNPFAM,UPROC_KEGG_OUT,UPROC_PFAM_OUT,STEP_SIZE,SCRIPT_DIR,WORKERS_DIR,UPROC_ID2FEATURE,FILES_LIST

source /usr/share/Modules/init/bash

set -u
#-u  Treat unset variables as an error when substituting.

COMMON="$WORKERS_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

if [ -z $SCRIPT_DIR ]; then
  echo Missing SCRIPT_DIR
  exit 1
fi

echo Started $(date)

echo Host $(hostname)

if [[ $RUNKEGG -eq 1 ]]; then
    echo Working on Kegg...

    cd "$UPROC_KEGG_OUT"

    TMP_FILES=$(mktemp)

    get_lines $FILES_LIST $TMP_FILES ${PBS_ARRAY_INDEX:=1} $STEP_SIZE

    NUM_FILES=$(lc $TMP_FILES)

    echo Processing \"$NUM_FILES\" input files
        	
    while read UPROC; do

        FILE="$UPROC_KEGG_OUT/$UPROC"

        if [[ $UPROC =~ ^DNA_4.* ]]; then SAMPLE="DNA_4"; fi
        if [[ $UPROC =~ ^DNA_3.* ]]; then SAMPLE="DNA_3"; fi
        if [[ $UPROC =~ ^DNA_2.* ]]; then SAMPLE="DNA_2"; fi
        if [[ $UPROC =~ ^DNA_1.* ]]; then SAMPLE="DNA_1"; fi

        UPROC_OUT="$UPROC_ID2FEATURE/KEGG/$SAMPLE"
        OUTPUT_FILE1="$UPROC_OUT/$(dirname $UPROC).$(basename $FILE ".uproc").id2feature"
        OUTPUT_FILE2="$UPROC_OUT/$(dirname $UPROC).$(basename $FILE ".uproc").featurecount"

        #If output directory doesn't exist, create it
        if [[ ! -d $UPROC_OUT ]]; then
            mkdir -p $UPROC_OUT
        fi

        if [[ -e $OUTPUT_FILE1 ]]; then
            rm -rf $OUTPUT_FILE1
        fi

        if [[ -e $OUTPUT_FILE2 ]]; then
            rm -rf $OUTPUT_FILE2
        fi

        $WORKERS_DIR/get_id2feature.py -f $FILE --out1 $OUTPUT_FILE1 --out2 $OUTPUT_FILE2 \

    done < "$TMP_FILES"

fi

if [[ $RUNPFAM -eq 1 ]]; then
    echo Working on PFAM...

    cd "$UPROC_PFAM_OUT"

    TMP_FILES=$(mktemp)

    get_lines $FILES_LIST $TMP_FILES ${PBS_ARRAY_INDEX:=1} $STEP_SIZE

    NUM_FILES=$(lc $TMP_FILES)

    echo Processing \"$NUM_FILES\" input files
        	
    while read UPROC; do

        FILE="$UPROC_PFAM_OUT/$UPROC"
        
        if [[ $UPROC =~ ^DNA_4.* ]]; then SAMPLE="DNA_4"; fi
        if [[ $UPROC =~ ^DNA_3.* ]]; then SAMPLE="DNA_3"; fi
        if [[ $UPROC =~ ^DNA_2.* ]]; then SAMPLE="DNA_2"; fi
        if [[ $UPROC =~ ^DNA_1.* ]]; then SAMPLE="DNA_1"; fi

        UPROC_OUT="$UPROC_ID2FEATURE/PFAM/$SAMPLE"
        OUTPUT_FILE1="$UPROC_OUT/$(dirname $UPROC).$(basename $FILE ".uproc").id2feature"
        OUTPUT_FILE2="$UPROC_OUT/$(dirname $UPROC).$(basename $FILE ".uproc").featurecount"

        #If output directory doesn't exist, create it
        if [[ ! -d $UPROC_OUT ]]; then
            mkdir -p $UPROC_OUT
        fi

        if [[ -e $OUTPUT_FILE1 ]]; then
            rm -rf $OUTPUT_FILE1
        fi

        if [[ -e $OUTPUT_FILE2 ]]; then
            rm -rf $OUTPUT_FILE2
        fi

        $WORKERS_DIR/get_id2feature.py -f $FILE --out1 $OUTPUT_FILE1 --out2 $OUTPUT_FILE2 \

    done < "$TMP_FILES"

fi


echo Finished $(date)
