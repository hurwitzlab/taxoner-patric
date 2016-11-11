#!/usr/bin/env python
import argparse
import os
import pprint
import subprocess
from plumbum import local

#change directory to where script is launched (stupid PBS!!!)
local.cwd.chdir(os.environ.get('PBS_O_WORKDIR'))

#function to import variable from config.sh or other sourcefile
def import_config(sourcefile='./config.sh'):
    command = ['bash', '-c', 'source ' + sourcefile + ' && env']
    proc = subprocess.Popen(command, stdout = subprocess.PIPE)
    for line in proc.stdout:
        (key, _, value) = line.partition("=")
        os.environ[key] = value.rstrip('\n')
    proc.communicate()

#call the function
import_config()

if __name__ == "__main__":
    parser = \
    argparse.ArgumentParser(description="Script to fix taxonomy text files.")
    parser.add_argument("-m", "--min", action="store", \
        help="Minimum alignment score (optional)")
    parser.add_argument("-M", "--max", action="store", \
        help="Maximum alignment score (optional)")
    parser.add_argument("-f", "--file", action="store", \
        help="File in",default=os.environ.get('IN_NAME'))
    parser.add_argument("-o1", "--out1", action="store", \
        help="File out",default=os.environ.get('OUT_NAME'))

    args = vars(parser.parse_args())

#Switch to krona_out directory where files are
local.cwd.chdir(os.environ.get('KRONA_OUT_DIR'))

file_in = open(args["file"],"r")
file_out1 = open(args["out1"],"w")
min_score = args["min"]
max_score = args["max"]

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
        score=int(cigar.split(',')[-1].rstrip('\n').split(':')[-1])
        id_to_taxa.update({read_id:taxa})
        id_to_uniq.update({read_id:unique_id})
        id_to_score.update({read_id:score})

#This is to setup the file with some headers so we know what the hell the columns are
if (os.stat(file_out1.name).st_size == 0):
    file_out1.write('#Note: unique_id is the one that matches the accession number in PATRIC_final_genome_index.txt in the patric_metadata directory\n')
    file_out1.write('Read_id\t' + 'NCBI_taxa_id\t' + 'Unique_id\t' + 'Alignment_Score\t\n')

for read_id in id_to_taxa:
    if (min_score):
        if (id_to_score[read_id] >= min_score):
            file_out1.write(read_id + "\t" + id_to_taxa[read_id] + "\t" + id_to_uniq[read_id] + "\t" + str(id_to_score[read_id]) + "\n")
    elif (max_score):
        if (id_to_score[read_id] < max_score):
            file_out1.write(read_id + "\t" + id_to_taxa[read_id] + "\t" + id_to_uniq[read_id] + "\t" + str(id_to_score[read_id]) + "\n")
    else:
        file_out1.write(read_id + "\t" + id_to_taxa[read_id] + "\t" + id_to_uniq[read_id] + "\t" + str(id_to_score[read_id]) + "\n")

###No longer need this because calling from another pbs script
###PBS -W group_list=bhurwitz
###PBS -q standard
###PBS -l select=1:ncpus=12:mem=36gb
###PBS -l place=pack:shared
###PBS -l walltime=00:30:00
###PBS -l cput=00:30:00
###PBS -M scottdaniel@email.arizona.edu
###PBS -m bea
###

