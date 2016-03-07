#!/bin/bash

#SBATCH -J fetch-test           # Job name
#SBATCH -o ./fetch-test.%j.out    # Specify stdout output file (%j expands to jobId)
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

FASTA="./DNA_1_CGATGT_L002_R1_001.fa"
FASTQ="./DNA_1_CGATGT_L002_R1_001.fastq.trimmed.clipped"
OUTPUT="./test.fastq"

python ./fetch-fastq.py \
    --fastq $FASTQ \
    --fasta $FASTA \
    --output $OUTPUT

