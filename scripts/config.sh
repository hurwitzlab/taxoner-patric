export CWD=$PWD
#where programs are
export BIN_DIR="/gsfs1/rsgrps/bhurwitz/hurwitzlab/bin"
#root project dir
export PRJ_DIR="/gsfs1/rsgrps/bhurwitz/scottdaniel/taxoner-patric"
#input fasta
export FASTA_DIR="/gsfs1/rsgrps/bhurwitz/kyclark/mouse/data/screened"
#place to store split-up fasta (step 00)
export ALT_DATA="/rsgrps/bhurwitz/scottdaniel/uproc_shortread_to_pfam/data"
export SPLIT_FA_DIR="$ALT_DATA/split"
#export SPLIT_FA_DIR="$PRJ_DIR/fasta-split"
#place to store taxoner results (step 01)
export TAXONER_OUT_DIR="$PRJ_DIR/taxoner-out"
#place to store krona results (step 02)
export KRONA_OUT_DIR="$PRJ_DIR/krona-out"
#place to store taxon counts (step 03)
export COUNT_OUT_DIR="$PRJ_DIR/count-out"
#where the worker scripts are (PBS batch scripts and their python/perl workdogs)
export SCRIPT_DIR="$PRJ_DIR/scripts/workers"
#how much to split up fasta files
export FA_SPLIT_FILE_SIZE=500000 # in KB
#where bowtie2 database is for taxoner
export BOWTIEDB="/gsfs1/rsgrps/bhurwitz/hurwitzlab/data/reference/taxoner_db"
#where taxid annotation is
export TAXA="/gsfs1/rsgrps/bhurwitz/scottdaniel/PATRIC_dbCreator/data/Patric_nodes.dmp"
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
