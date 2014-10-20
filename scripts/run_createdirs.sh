#!/bin/csh

### Specify the PI group found with va command
#PBS -W group_list=mbsulli

### Set the queue to submit this job.
#PBS -q standard

### Set the jobtype for this job (serial, small_mpi, small_smp, large_mpi, large_smp)
### jobtype=serial submits to htc and can be automatically moved to cluster and smp
### Type parameter determines initial queue placement and possible automatic queue moves
#PBS -l jobtype=serial

### Set the number of cores (cpus) and memory that will be used for this job
### When specifying memory request slightly less than 2GB memory per ncpus for standard node
### Some memory needs to be reserved for the Linux system processes
#PBS -l select=1:ncpus=8:mem=15gb

### Important!!! Include this line for your 1p job.
### Without it, the entire node, containing 12 core, will be allocated
#PBS -l place=pack:shared

### Specify "wallclock time" required for this job, hhh:mm:ss
#PBS -l walltime=24:00:00

### Specify total cpu time required for this job, hhh:mm:ss
### total cputime = walltime * ncpus
#PBS -l cput=24:00:00

### Load required modules/libraries if needed (blas example)
### Use "module avail" command to list all available modules
### NOTE: /usr/share/Modules/init/csh -CAPITAL M in Modules
source /usr/share/Modules/init/csh
module load perl

cd $CWD
set SCRIPTS="$CWD/scripts"

$SCRIPTS/createdirs.pl $FINALDIR $FILE
