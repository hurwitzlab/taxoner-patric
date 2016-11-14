#!/usr/bin/env python
from __future__ import print_function #python3 style printing
import sys
import argparse
import os
from Bio import SeqIO
#command be like this: (from fetch-fq.sh)
#python $WORKER_DIR/fetch-fastq.py $FASTQ_DIR $FASTA $OUTPUT_DIR $MAXSCORE
#$FASTA can also just be a file with a list of read_ids

if __name__ == "__main__":
    parser = \
    argparse.ArgumentParser(description="Script to get fastq records using ids from a fasta file or other file with read_ids and with a max score")
    parser.add_argument("-fa", "--fasta", action="store", \
        help="Fasta to used as reference ids")
    parser.add_argument("-fq", "--fastq-dir", action="store", \
        help="Dir for fastqs to search through for ids from fasta")
    parser.add_argument("-o", "--output-dir", action="store", \
        help="Output dir to put fastqs in")
    parser.add_argument("-M", "--max", action="store", \
        help="Max alignment score")
    
    args = vars(parser.parse_args())

if len(sys.argv)==1:
    parser.print_help()
    sys.exit(1)

output_dir = args["output-dir"]
file_in = open(args["fasta"],"r")
max_score = int(args["max"])
fastq_dir = args["fastq-dir"]
#fqrecords=SeqIO.index(args["fastq"],"fastq")

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

print("{:s} had {:d} read_ids that were below {:d}".format(file_in,int(counter1),max_score))

fastq_files={}

#building list of files
for dirpath,dirnames,files in os.walk(fastq_dir):
    for fname in files:
        if fname.endswith('clipped'):
            fastqs[fname] = os.sep.join([dirpath,fname])

print("List of files is {:s}".format(fastq_files))

for fastq_name,fastq_path in fastq_files.iteritems(): #iterate through fastqs
    shortname = fastq_name.split('.')[0]
    output = open(os.path.join(output_dir,shortname,"lowqual.fastq"),'w')
    print("Outputting to {:s}".format(output.name))
    for hwis in lowqual.iterkeys(): #iterate through records in fasta
        fqrecords=SeqIO.index(fastq_path,"fastq")
        SeqIO.write(fqrecords[hwis],output,"fastq")
        counter2 += 1
    print("Finished writing {:d} records to {:s}".format(int(counter2),fqrecords))
    fqrecords.close() #good memory citizen even though i think python has garbage collection
    output.close()

file_in.close()

