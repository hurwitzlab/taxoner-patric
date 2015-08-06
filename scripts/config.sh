export CWD=$PWD
#where programs are
export BIN_DIR="/rsgrps/bhurwitz/hurwitzlab/bin"
#input fasta
export FASTA_DIR="/gsfs1/rsgrps/bhurwitz/kyclark/mouse/data/screened"
#place to store split-up fasta (step 00)
export SPLIT_FA_DIR="/rsgrps/bhurwitz/scottdaniel/uproc_shortread_to_pfam/data/split"
#place to store blast results (step 01)
export BLAST_OUT_DIR="/rsgrps/bhurwitz/scottdaniel/blast-pipeline/blast-out"
#place to store annotated results (step 02)
export ANNOT_OUT_DIR="/rsgrps/bhurwitz/scottdaniel/blast-pipeline/annot-out"
#where the worker scripts are (PBS batch scripts and their perl workdogs)
export SCRIPT_DIR="$CWD/workers"
#how much to split up fasta files
export FA_SPLIT_FILE_SIZE=500000 # in KB
#file that tells us where the blast database(s) are
#not sure this is needed now that we're using mpiblast
export BLAST_CONF_FILE="/rsgrps/bhurwitz/scottdaniel/blast-pipeline/blastdbs"
#where mpiblast program is (still need to 'module load mpiblast' in scripts)
export BLAST="/uaopt/mpiblast/1.6.0/bin/mpiblast"
#where taxid annotation is
export TAXA="/rsgrps/bhurwitz/hurwitzlab/data/reference/ncbitax"
#where the patric bacterial / archaeal genome(s) are
export PATRIC="/gsfs1/rsgrps/bhurwitz/hurwitzlab/data/reference/patric_bacteria"
#annotation file for PATRIC genomes mapping them to ncbi_taxid
export PAT_ANN="$PATRIC/genome_summary"

#
# Some custom functions for our scripts
#
# --------------------------------------------------
function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}

# --------------------------------------------------
function lc() {
    wc -l $1 | cut -d ' ' -f 1
}
