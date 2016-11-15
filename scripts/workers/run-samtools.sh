#!/usr/bin/env bash

#script to run samtools on the .sam's outputted by taxoner to get all the read id's from the unaligned reads

#PBS -W group_list=bhurwitz
#PBS -q qualified
#PBS -l select=1:ncpus=2:mem=12gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

cd $PBS_O_WORKDIR

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

TMP_FILES=$(mktemp)

get_lines $FILES_TO_PROCESS $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo Found \"$NUM_FILES\" files to process

while read SAM; do
    FULLPATH=$TAXONER_OUT_DIR/$SAM

    OUT_DIR=$READ_OUT_DIR/$(dirname $SAM)

    if [[ ! -d "$OUT_DIR" ]]; then
        mkdir -p "$OUT_DIR"
    fi
    
    #gets the plain name "0.fastq.sam"
    NAME=$(basename $SAM)
    #gets the leading number "0"
    NUM=$(echo $NAME | sed s/[^0-9]//g)
   
    if [[ -z $(find $OUT_DIR -iname $NUM.unaligned.fastq) ]]; then
        echo "Processing $FULLPATH"
    else
        echo "$NUM.unaligned.fastq for $FULLPATH already exists, skipping..."
        continue
    fi

    samtools fasta -f 4 $FULLPATH > $OUT_DIR/$NUM.unaligned.fastq

    #fix line ending of read_ids

    #replaces endings for "nomatch1 etc."
    sed -i.bak -e 's/-1/\/1/' -e 's/-2/\/2/' \
        $OUT_DIR/$NUM.unaligned.fastq

    #replaces ending for .1 and .2 (since they now have double /1/1)
    sed -i.bak -e 's/\/1\/1/\/1/' -e 's/\/2\/2/\/2/' \
        $OUT_DIR/$NUM.unaligned.fastq

done < "$TMP_FILES"



