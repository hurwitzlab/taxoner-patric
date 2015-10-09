#!/usr/bin/env bash

source ./config.sh

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"


taxoner -p 12 \
    -dbPath $BOWTIEDB \
    -taxpath $TAXA/nodes.dmp \
    -seq $SPLIT_FA_DIR/DNA_3_ACAGTG_L002_R2_009.fa/04.fa \
    -o $TAXONER_OUT_DIR \
    -fasta -no-unal &>> $STDOUT_DIR/taxoner_log

rsync -avvz --rsh=ssh $TAXONER_OUT_DIR/* \
    --remove-source-files \
    scottdaniel@login:/gsfs1/rsgrps/bhurwitz/scottdaniel/blast-pipeline/taxoner-out/ \
    &>> $STDOUT_DIR/rsync_log
 
