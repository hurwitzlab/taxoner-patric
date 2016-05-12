#!/usr/bin/env bash

#Script to take taxonomy counts for the 4 DNA samples and make a taxonomy chart with krona tools

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=6:mem=11gb:pcmem=2gb
#PBS -l pvmem=22gb
#PBS -l walltime=4:00:00
#PBS -l cput=4:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

cd $TAXONER_OUT_DIR

#Only need to do this if the files don't exist
if [[ ! -s $KRONA_OUT_DIR/DNA_4_Taxonomy.txt ]]; then
    echo Doing DNA_4
    time find ./ -path \*DNA_4\* -iname taxonomy.txt -print0 | xargs -0 -I file cat file > $KRONA_OUT_DIR/DNA_4_Taxonomy.txt
else
    echo DNA_4 already done
fi

if [[ ! -s $KRONA_OUT_DIR/DNA_3_Taxonomy.txt ]]; then
    echo Doing DNA_3
    time find ./ -path \*DNA_3\* -iname taxonomy.txt -print0 | xargs -0 -I file cat file > $KRONA_OUT_DIR/DNA_3_Taxonomy.txt
else
    echo DNA_3 already done
fi

if [[ ! -s $KRONA_OUT_DIR/DNA_2_Taxonomy.txt ]]; then
    echo Doing DNA_2
    time find ./ -path \*DNA_2\* -iname taxonomy.txt -print0 | xargs -0 -I file cat file > $KRONA_OUT_DIR/DNA_2_Taxonomy.txt
else
    echo DNA_2 already done
fi

if [[ ! -s $KRONA_OUT_DIR/DNA_1_Taxonomy.txt ]]; then
    echo Doing DNA_1
    time find ./ -path \*DNA_1\* -iname taxonomy.txt -print0 | xargs -0 -I file cat file > $KRONA_OUT_DIR/DNA_1_Taxonomy.txt
else
    echo DNA_1 already done
fi

#ID	taxid	unique_id	alignment_score	align_start	align_end CIGAR_STRING
#HWI-ST885:65:C07WUACXX:2:1203:10001:161566-1	397291	129543	1.000	24709	24809	100M,XM:0,AS:200
#unique_id can be grepped from PATRIC_final_genome_index.txt to give the PATRIC accession number 'accn|' to get the actual feature you have to go to the genome browser for the species and then
#enter in the start point (ex: 24709 in this instance)

#TODO: this is where simpler-tax.py should work its magic and make files like this: DNA_*_simp_filt.txt

echo Making Krona Charts
time ktImportTaxonomy \
    -o $KRONA_OUT_DIR/filtered-better_names_mouse_microbiome_taxa_patric_pairedend.html \
    -q 1 \
    -t 2 \
    -s 3 \
    $KRONA_OUT_DIR/DNA_1_simp_filt.txt,'S+H+' \
    $KRONA_OUT_DIR/DNA_2_simp_filt.txt,'S-H+' \
    $KRONA_OUT_DIR/DNA_3_simp_filt.txt,'S+H-' \
    $KRONA_OUT_DIR/DNA_4_simp_filt.txt,'S-H-'
