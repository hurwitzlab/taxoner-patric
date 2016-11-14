#!/usr/bin/env python
from __future__ import print_function #python3 style printing
import sys
import argparse
import os
from Bio import SeqIO
import errno
#command be like this: (from fetch-fq.sh)
#python $WORKER_DIR/fetch-fastq.py $FASTQ_DIR $FASTA $OUTPUT_DIR $MAXSCORE
#$FASTA can also just be a file with a list of read_ids

if __name__ == "__main__":
    parser = \
    argparse.ArgumentParser(description="Script to get fastq records using ids from a fasta file or other file with read_ids and with a max score")
    parser.add_argument("-fa", "--fasta", action="store", \
        help="Fasta to used as reference ids")
    parser.add_argument("-fq", "--fastq_dir", action="store", \
        help="Dir for fastqs to search through for ids from fasta")
    parser.add_argument("-o", "--output_dir", action="store", \
        help="Output dir to put fastqs in")
    parser.add_argument("-M", "--max", action="store", \
        help="Max alignment score")
    
    args = vars(parser.parse_args())

if len(sys.argv)==1:
    parser.print_help()
    sys.exit(1)

output_dir = args["output_dir"]
file_in = open(args["fasta"],"r")
max_score = int(args["max"])
fastq_dir = args["fastq_dir"]
#fqrecords=SeqIO.index(args["fastq"],"fastq")

print("First get read_ids below max_score")

lowqual={}
counter1=0

for line in file_in:
    if not ('#' in line):
        line=line.strip()
        cols=line.split('\t')
        read_id=cols[0]
        try:
            score=int(cols[-1])
        except ValueError as exception:
            print("Bad line is here, continuing anyway")
            continue
        if (score < max_score):
            lowqual.update({read_id:score})
            counter1 += 1

print("{:s} had {:d} read_ids that were below {:d}".format(file_in,int(counter1),max_score))

fastq_files={}

#Only need to get DNA_3*clipped files for DNA_3_simple.txt (and same for 1,2,4)
prefix=file_in.name.split('_')[1]

#building list of files
for dirpath,dirnames,files in os.walk(fastq_dir):
    for fname in files:
        if fname.endswith('clipped') and fname.split('_')[1]==prefix:
            fastq_files[fname] = os.sep.join([dirpath,fname])

print("List of files is {:s}".format(fastq_files))

for fastq_name,fastq_path in fastq_files.iteritems(): #iterate through fastqs
    shortname = fastq_name.split('.')[0] #only first "word" before period
    if not os.path.exists(os.path.join(output_dir,shortname)): #check for dir
        os.makedirs(os.path.join(output_dir,shortname)) #create if not there
    output = open(os.path.join(output_dir,shortname,"lowqual.fastq"),'w') #open output file
    print("Outputting to {:s}".format(output.name))
    fqrecords=SeqIO.index(fastq_path,"fastq")
    counter2=0
    for hwis in lowqual.iterkeys(): #iterate through records in fasta
        try:
            fqrecords[hwis]
        except KeyError as exception: #if record isn't found we keep searching
            continue
        SeqIO.write(fqrecords[hwis],output,"fastq") #if found we write out
        counter2 += 1
    print("Finished getting {:d} records from {:s}".format(int(counter2),fastq_name))
    fqrecords.close() #good memory citizen even though i think python has garbage collection
    output.close()

file_in.close()

