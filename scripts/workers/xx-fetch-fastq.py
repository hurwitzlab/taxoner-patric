#!/usr/bin/env python

import argparse
from Bio import SeqIO

#command be like this: (from fetch-fq.sh)
#python $WORKER_DIR/fetch-fastq.py $FASTQ $FASTA $OUTPUT

if __name__ == "__main__":
    parser = \
    argparse.ArgumentParser(description="Script to get fastq records using ids from a fasta file.")
    parser.add_argument("-fa", "--fasta", action="store", \
        help="Fasta to used as reference ids")
    parser.add_argument("-fq", "--fastq", action="store", \
        help="Fastq to search through for ids from fasta")
    parser.add_argument("-o", "--output", action="store", \
        help="Output fastq file")
    
    args = vars(parser.parse_args())

output = open(args["output"],"w")

farecords=SeqIO.index(args["fasta"],"fasta")
fqrecords=SeqIO.index(args["fastq"],"fastq")

for hwis in sorted(farecords):
    SeqIO.write(fqrecords[hwis],output,"fastq")

farecords.close()
fqrecords.close()
output.close()

