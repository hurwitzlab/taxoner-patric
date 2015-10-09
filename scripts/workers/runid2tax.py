#!/usr/bin/env python

import argparse
from collections import defaultdict

if __name__ == "__main__":
    parser = \
    argparse.ArgumentParser(description="Script to count taxas.")
    parser.add_argument("-f", "--file", action="store", \
        help="File to count taxas from")
    parser.add_argument("-o1", "--out1", action="store", \
        help="Name for the id_to_taxa file")
    parser.add_argument("-o2", "--out2", action="store", \
        help="Named for taxa_to_count file")
    
    args = vars(parser.parse_args())

file_in = open(args["file"],"r")
file_out1 = open(args["out1"],"w")
file_out2 = open(args["out2"],"w")

id_to_taxa={}
taxa_to_count=defaultdict(int)

for line in file_in:
    line.rstrip('\n')
    if (':' in line):
        cols=line.split('\t')
        #read_id    tax_id  gi_id   alignment_score match_start match_end
        #HWI-ST885:65:C07WUACXX:7:2307:10001:172942 1408186	559161187	0.700	1718356	3436812        
        read_id=cols[1]
        taxa=cols[2]
        id_to_taxa.update({read_id:taxa})
        taxa_to_count[taxa] += 1

for read_id in id_to_taxa:
    file_out1.write(read_id + "\t" + id_to_taxa[read_id] + "\n")

for taxa in taxa_to_count:
    file_out2.write(taxa + "\t" + str(taxa_to_count[taxa]) + "\n")

file_in.close()
file_out1.close()
file_out2.close()

