#!/usr/bin/env bash

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
    --output $TAXONER_OUT_DIR \
    --fasta \
    -e \
    -y ./extra_commands.txt &>> $STDOUT_DIR/taxoner64_log

#rsync -avvz --rsh=ssh $TAXONER_OUT_DIR/* \
#    --remove-source-files \
#    scottdaniel@login:/gsfs1/rsgrps/bhurwitz/scottdaniel/blast-pipeline/taxoner-out/ \
#    &>> $STDOUT_DIR/rsync_log
# 
