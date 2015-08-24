export CWD=$PWD
#where programs are
export BIN_DIR="/gsfs1/rsgrps/bhurwitz/hurwitzlab/bin"
#root project dir
export PRJ_DIR="/gsfs1/rsgrps/bhurwitz/scottdaniel/blast-pipeline"
#input fasta
export FASTA_DIR="/gsfs1/rsgrps/bhurwitz/kyclark/mouse/data/screened"
#place to store split-up fasta (step 00)
export SPLIT_FA_DIR="$PRJ_DIR/fasta-split"
#place to store blast results (step 01)
export TAXONER_OUT_DIR="$PRJ_DIR/taxoner-out"
#place to store annotated results (step 02)
export ANNOT_OUT_DIR="$PRJ_DIR/annot-out"
#where the worker scripts are (PBS batch scripts and their perl workdogs)
export SCRIPT_DIR="$PRJ_DIR/scripts/workers"
#how much to split up fasta files
export FA_SPLIT_FILE_SIZE=500000 # in KB
#where bowtie2 database is for taxoner
export BOWTIEDB="lytic.hpc.arizona.edu:/home/u18/scottdaniel/taxoner/Taxoner/databases/bowtie2" 
#where taxid annotation is
export TAXA="lytic.hpc.arizona.edu:/home/u18/scottdaniel/taxoner/Taxoner/databases" 
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
