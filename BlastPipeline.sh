#!/bin/sh

## This pipeline runs the following steps 
## 
##  1- preprocess the fasta file(s) to create job array input file 
##  2- set up the blast output dirs
##  3- run blast against the set of databases and parse (in blastdbs file)
##  4- cleanup interim files and concatenate the results 

DATE="povnucsimap3"
FADIR="/rsgrps1/mbsulli/bonnie/projects/protein_universe/pu/data"
FINALDIR="/rsgrps1/mbsulli/bioinfo/blastdata/$DATE"
SCRIPTS="$FINALDIR/scripts"
JOBS=100
export CWD=$PWD
export FADIR=$FADIR
export FINALDIR=$FINALDIR
export JOBS=$JOBS

for file in $FADIR/*reads.fa; do
   echo $file
   export FILE=$file

   ##  1 - preprocess the fasta file(s) to create job array input file 
   FIRST=`qsub -v CWD,FILE,FADIR,FINALDIR,JOBS -N splitjobs -e $FINALDIR/pbserr -o $FINALDIR/pbsout $SCRIPTS/run_split.sh`

   ##  2- set up the blast output dirs
   SECOND=`qsub -v CWD,FILE,FINALDIR -W depend=afterok:$FIRST -N createdirs -e $FINALDIR/pbserr -o $FINALDIR/pbsout $SCRIPTS/run_createdirs.sh`

   ##  3- run blast against the set of databases and parse
   THIRD=`qsub -v CWD,FILE,FINALDIR -W depend=afterok:$SECOND -N blastdbs -J 1-$JOBS -e $FINALDIR/pbserr -o $FINALDIR/pbsout $SCRIPTS/run_blast.sh`

   ## 4- cleanup interim files and concatenate the results
   FOURTH=`qsub -v CWD,FILE,FINALDIR -W depend=afterok:$THIRD -N compile-blast -e $FINALDIR/pbserr -o $FINALDIR/pbsout $SCRIPTS/run_assemble_blast.sh` 
done
