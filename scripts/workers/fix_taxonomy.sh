#!/usr/bin/env bash

#this works with scripts/02-zfix-taxonomy.sh

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=4:mem=24gb
#PBS -l walltime=4:00:00
#PBS -l cput=4:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

set -u

echo "Started at $(date)"

cd $TAXONER_OUT_DIR

if [[ -z "$SAMPLE" ]]; then
    echo "Need variable \$SAMPLE"
    exit 1
fi

#Only need to do this if the files don't exist
if [[ ! -s $KRONA_OUT_DIR/"$SAMPLE"_Taxonomy.txt ]]; then
    echo Doing "$SAMPLE"
    time find ./ -path \*"$SAMPLE"\* -iname taxonomy.txt -print0 | xargs -0 -I file cat file > $KRONA_OUT_DIR/"$SAMPLE"_Taxonomy.txt
else
    echo ""$SAMPLE" already concatenated, so you are good to go!"
fi

#ID	taxid	unique_id	alignment_score	align_start	align_end CIGAR_STRING
#HWI-ST885:65:C07WUACXX:2:1203:10001:161566-1	397291	129543	1.000	24709	24809	100M,XM:0,AS:200
#unique_id can be grepped from PATRIC_final_genome_index.txt to give the PATRIC accession number 'accn|' to get the actual feature you have to go to the genome browser for the species and then
#enter in the start point (ex: 24709 in this instance)

$WORKER_DIR/simpler-tax.py --file "$SAMPLE"_Taxonomy.txt --out1 "$SAMPLE"_simple.txt


echo "Done at $(date)"
