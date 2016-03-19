#!/bin/bash

#SBATCH -J krona-chart           # Job name
#SBATCH -p normal           # Queue name
#SBATCH -N 1                     # Total number of nodes requested (16 cores/node)
#SBATCH -n 16                     # Total number of tasks
#SBATCH -t 24:00:00              # Run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=scottdaniel@email.arizona.edu
#SBATCH --mail-type=all
#SBATCH -A iPlant-Collabs         # Specify allocation to charge against

#automagic offloading for the xeon phi co-processor
#in case anything uses Intel's Math Kernel Library
export MKL_MIC_ENABLE=1
export OMP_NUM_THREADS=16
export MIC_OMP_NUM_THREADS=240
export OFFLOAD_REPORT=2

set -u

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

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
#ID	taxid	unique_id	alignment_score	align_start	align_end
#HWI-ST885:65:C07WUACXX:7:1101:10000:13342  1469948 1222964 2.080   192292  192392
#unique_id can be grepped from PATRIC_final_genome_index.txt to give the PATRIC accession number 'accn|' to get the actual feature you have to go to the genome browser for the species and then
#enter in the start point (ex: 192292 in this instance)
echo Making Krona Charts
time ktImportTaxonomy \
    -o $KRONA_OUT_DIR/fastq_mouse_microbiome_taxa_patric.html \
    -q 1 \
    -t 2 \
    -s 4 \
    $KRONA_OUT_DIR/DNA_1_Taxonomy.txt,DNA_1 \
    $KRONA_OUT_DIR/DNA_2_Taxonomy.txt,DNA_2 \
    $KRONA_OUT_DIR/DNA_3_Taxonomy.txt,DNA_3 \
    $KRONA_OUT_DIR/DNA_4_Taxonomy.txt,DNA_4
