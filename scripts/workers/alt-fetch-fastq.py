#!/usr/bin/env python
import sys
import argparse
from Bio import SeqIO
from __future__ import print_function #python3 style printing
#command be like this: (from fetch-fq.sh)
#python $WORKER_DIR/fetch-fastq.py $FASTQ $FASTA $OUTPUT $MAXSCORE
#$FASTA can also just be a file with a list of read_ids

if __name__ == "__main__":
    parser = \
    argparse.ArgumentParser(description="Script to get fastq records using ids from a fasta file or other file with read_ids and with a max score")
    parser.add_argument("-fa", "--fasta", action="store", \
        help="Fasta to used as reference ids")
    parser.add_argument("-fq", "--fastq", action="store", \
        help="Fastq to search through for ids from fasta")
    parser.add_argument("-o", "--output", action="store", \
        help="Output fastq file")
    parser.add_argument("-M", "--max", action="store", \
        help="Max alignment score")
    
    args = vars(parser.parse_args())

if len(sys.argv)==1:
    parser.print_help()
    sys.exit(1)

output = open(args["output"],"w")
file_in = open(args["fasta"],"r")
max_score = args["max"]
fqrecords=SeqIO.index(args["fastq"],"fastq")

print("First get read_ids below max_score")

lowqual={}
counter1=0
counter2=0

for line in file_in:
    line=line.strip()
    cols=line.split('\t')
    read_id=cols[0]
    score=cols[-1]
    if (score < max_score):
        lowqual.update({read_id:score})
        counter1 += 1

print("{:s} had {:n} read_ids that were below {:n}".format(file_in,counter1,max_score))

for hwis in lowqual.iterkeys:
    SeqIO.write(fqrecords[hwis],output,"fastq")
    counter2 += 1

print("Finished writing {:n} records to {:s}".format(counter2,fqrecords))

file_in.close()
fqrecords.close()
output.close()

