#!/bin/bash
#-----------------------------------------------------------------
# Example SLURM job script to run serial applications on TACC's
# Stampede system.
#
# This script requests one core (out of 16) on one node. The job
# will have access to all the memory in the node.  Note that this
# job will be charged as if all 16 cores were requested.
#-----------------------------------------------------------------

#SBATCH -J get_files2           # Job name
#SBATCH -o get_files2.%j.out    # Specify stdout output file (%j expands to jobId)
#SBATCH -p serial           # Queue name
#SBATCH -N 1                     # Total number of nodes requested (16 cores/node)
#SBATCH -n 1                     # Total number of tasks
#SBATCH -t 12:00:00              # Run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=scottdaniel@email.arizona.edu
#SBATCH --mail-type=all
#SBATCH -A iPlant-Collabs         # Specify allocation to charge against

if [[ ! -d sort-and-merged ]]; then
    mkdir -p "sort-and-merged"
fi

#        --include '*.clipped' --exclude '*' \

while [ 1 ]; do
    rsync \
        --timeout=60 \
        -aivvzhP \
        --rsh=ssh scottdaniel@login.hpc.arizona.edu:/gsfs1/rsgrps/bhurwitz/scottdaniel/fastq-taxoner-patric/sort-and-merged/* ./sort-and-merged/
    if [ "$?" = "0" ]; then
        echo "Rsync success!"
        exit 0
    else
        echo "Rsync failure. Retrying in a minute"
        sleep 60
    fi
done
