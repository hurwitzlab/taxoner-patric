#!/usr/bin/env bash

# need a script to cat all the genomes i think
# something like:
# find ./$GENOME_DIR -iname *.fna -print0 | xargs -I file -0 cat file > $TMP/bigun.fna
# split $TMP/bigun > ./ into like 4GB pieces with destination being bowtie2index dir
# make list of fna's to index in $bowtie2index_dir
# have check for *.bt2 to see if completed (for restarting)
# then spawn a pbs job for each *.fna to index
# tada!


