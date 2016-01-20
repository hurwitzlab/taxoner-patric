
#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=2:mem=3gb:pcmem=2gb
#PBS -l pvmem=6gb
#PBS -l walltime=00:30:00
#PBS -l cput=00:30:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

cd $PBS_O_WORKDIR
CONFIG="$PRJ_DIR/scripts/config.sh"

if [ -e $CONFIG ]; then
    . "$CONFIG"
else
    echo MIssing config \"$CONFIG\"
    exit 12385
fi

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

TMP_FILES=$(mktemp)

get_lines $FILES_TO_PROCESS $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo Found \"$NUM_FILES\" files to process

while read FASTA; do

    FILE=$SPLIT_FA_DIR/$FASTA
    
    perl $WORKER_DIR/make-fastaDB.pl $FILE

done < "$TMP_FILES"
