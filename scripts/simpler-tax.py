#!/usr/bin/env python

import os
import argparse
from collections import defaultdict

if __name__ == "__main__":
    parser = \
    argparse.ArgumentParser(description="Script to fix taxonomy text files.")
    parser.add_argument("-f", "--file", action="store", \
        help="File in")
    parser.add_argument("-o1", "--out1", action="store", \
        help="File out")

    args = vars(parser.parse_args())

file_in = open(args["file"],"r")
file_out1 = open(args["out1"],"w")

id_to_taxa={}
id_to_score={}
id_to_uniq={}

for line in file_in:
    line=line.rstrip('\n')
    if (':' in line):
        cols=line.split('\t')
        read_id=cols[0]
        taxa=cols[1]
        #unique_id is the one that matches the accession number in 
        #PATRIC_final_genome_index.txt in the patric_metadata directory
        unique_id=cols[2]
        cigar=cols[-1]
        score=cigar.split(',')[-1].rstrip('\n').split(':')[-1]
        id_to_taxa.update({read_id:taxa})
        id_to_uniq.update({read_id:unique_id})
        id_to_score.update({read_id:score})

#This is to setup the file with some headers so we know what the hell the columns are
if (os.stat(file_out1).st_size == 0):
    file_out1.write('#Note: unique_id is the one that matches the accession number in PATRIC_final_genome_index.txt in the patric_metadata directory')
    file_out1.write('Read_id\t' + 'NCBI_taxa_id\t' + 'Unique_id\t' + 'Alignment_Score\t'

for read_id in id_to_taxa:
    file_out1.write(read_id + "\t" + id_to_taxa[read_id] "\t" + id_to_uniq[read_id] + "\t" + id_to_score[read_id] + "\n")
