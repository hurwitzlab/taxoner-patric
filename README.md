# taxoner-patric
## singularity branch = meant to work with singularity images (that contain fastqc, taxoner, etc.)
## see https://singularity-hub.org/
This is to work with taxoner64, a bowtie2 based solution to mapping reads to a metagenome 

Google: https://code.google.com/p/taxoner/

Github: https://github.com/r78v10a07/taxoner

and with PATRIC, a database of bacterial genomes
https://www.patricbrc.org/portal/portal/patric/Genomes

*Master branch was done with fasta's (probably wrongly) this one used full information from fastq's

#### Patric genomes must be in bowtie2 format
#### This is meant to be used on a PBS job scheduling system

## Directions
1. Run the scripts in order, one at a time, in the /scripts dir
2. Check output and log files between each run
3. Any files named OPT- are considered optional steps
4. Enjoy!
