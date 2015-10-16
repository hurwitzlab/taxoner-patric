#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -N test_taxoner64
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=12:mem=23gb
#PBS -l pvmem=46gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

cd $PBS_O_WORKDIR
source ./config.sh

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"
#Read pair 1: $SPLIT_FA_DIR/DNA_2_TGACCA_L002_R1_001.fa/01.fa
#Read pair 2: $SPLIT_FA_DIR/DNA_2_TGACCA_L002_R2_001.fa/01.fa

taxoner64 -t 12 \
    --dbPath $BOWTIEDB \
    --taxpath $TAXA/nodes.dmp \
    --seq $SPLIT_FA_DIR/DNA_2_TGACCA_L002_R1_001.fa/01.fa \
    --output /gsfs1/rsgrps/bhurwitz/scottdaniel/blast-pipeline/taxoner-out-test \
    --fasta \
    -e \
    -y ./extra_commands.txt &>> $STDOUT_DIR/taxoner64_log

#rsync -avvz --rsh=ssh $TAXONER_OUT_DIR/* \
#    --remove-source-files \
#    scottdaniel@login:/gsfs1/rsgrps/bhurwitz/scottdaniel/blast-pipeline/taxoner-out/ \
#    &>> $STDOUT_DIR/rsync_log
# 
