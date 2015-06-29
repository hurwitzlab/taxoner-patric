#!/bin/csh

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=serial
#PBS -l select=1:ncpus=12:mem=23gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

source /usr/share/Modules/init/bash

cd $CWD

# for blast
set PROGRAM="$SCRIPT_DIR/assemble_blast.pl"

$PROGRAM $FINALDIR $FILE
