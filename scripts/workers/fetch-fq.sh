#!/bin/bash

#SBATCH -J fetch-fq           # Job name
#SBATCH -o ./out/fetch-fq.%j.out    # Specify stdout output file (%j expands to jobId)
#SBATCH -p normal           # Queue name
#SBATCH -N 1                     # Total number of nodes requested (16 cores/node)
#SBATCH -n 16                     # Total number of tasks
#SBATCH -t 24:00:00              # Run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=scottdaniel@email.arizona.edu
#SBATCH --mail-type=all
#SBATCH -A iPlant-Collabs         # Specify allocation to charge against

#automagic offloading for the xeon phi co-processor
#in case anything uses Intel's Math Kernel Library
export MKL_MIC_ENABLE=1
export OMP_NUM_THREADS=16
export MIC_OMP_NUM_THREADS=240
export OFFLOAD_REPORT=2

unset module
set -u

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

TMP_FILES=$(mktemp)

get_lines $FILES_LIST $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

if [[ $NUM_FILES -le 1 ]]; then
    echo Something went wrong or no files to process
    exit 1
else
    echo Found \"$NUM_FILES\" files to process
fi

export SEARCH_LIST="$PRJ_DIR/clipped_search_list"

ls $CLIPPED_FASTQ > $SEARCH_LIST

for NAME in $(cat $TMP_FILES); do 
    echo Using $NAME
    SHORT=$(basename $NAME '.fa')
    echo $SHORT
    FOUND=$(egrep $SHORT $SEARCH_LIST)
    FASTA="$FASTA_DIR/$NAME"
    FASTQ="$CLIPPED_FASTQ/$FOUND"
    OUTPUT=$FILTERED_FQ/"$SHORT".filtered.fastq
    echo Using "$FASTA" as input and searching through "$FASTQ" and
    echo will output to "$OUTPUT"
    python $WORKER_DIR/fetch-fastq.py \
        --fastq $FASTQ \
        --fasta $FASTA \
        --output $OUTPUT
done

if [[ $PBS_ARRAY_INDEX -eq 181 ]]; then
    python $HOME/mailsender.py
fi

