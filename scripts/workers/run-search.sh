#!/usr/bin/env bash

##PBS -W group_list=bhurwitz
##PBS -q standard
##PBS -l jobtype=cluster_only
##PBS -l select=1:ncpus=3:mem=5gb:pcmem=2gb
##PBS -l pvmem=10gb
##PBS -l walltime=12:00:00
##PBS -l cput=12:00:00
##PBS -M scottdaniel@email.arizona.edu
##PBS -m bea
#
#cd $PBS_O_WORKDIR

source ../config.sh
source ./common.sh

export TEST_DB="$SPLIT_FA_DIR/DNA_4_GCCAAT_L007_R2_021.fa"
export TEST_SQ="$KRONA_OUT_DIR/test_seq.txt"
export TEST_OUT_DIR="$PRJ_DIR/search_test"

echo Making output dir...
if [ ! -d $TEST_OUT_DIR ]; then
    mkdir -p $TEST_OUT_DIR
fi

echo Running perl script \
    on \"$TEST_SQ\" with \"$TEST_DB\" and outputting to \"$TEST_OUT_DIR\"

perl ./fasta-search.pl $TEST_DB $TEST_SQ $TEST_OUT_DIR

