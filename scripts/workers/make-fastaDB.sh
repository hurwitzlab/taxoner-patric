
#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=2:mem=3gb:pcmem=2gb
#PBS -l pvmem=6gb
#PBS -l walltime=72:00:00
#PBS -l cput=12:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

cd $PBS_O_WORKDIR
source ../config.sh
source ./common.sh

echo Started at $(date)
perl make-fastaDB.pl $FASTA_DIR/DNA_1
echo Ended at $(date)

