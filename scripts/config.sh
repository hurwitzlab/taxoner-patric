export CWD=$PWD
export BIN_DIR="/rsgrps/bhurwitz/hurwitzlab/bin"
export FASTA_DIR="/rsgrps/bhurwitz/hurwitzlab/data/clean/mouse/doetschman/fasta"
export SPLIT_FA_DIR="/rsgrps/bhurwitz/scottdaniel/blast-pipeline/fasta-split"
export BLAST_OUT_DIR="/rsgrps/bhurwitz/scottdaniel/blast-pipeline/blast-out"
export SCRIPT_DIR="$CWD/workers"
export FA_SPLIT_FILE_SIZE=500000 # in KB
export BLAST_CONF_FILE="/rsgrps/bhurwitz/scottdaniel/blast-pipeline/blastdbs"
export BLAST="/rsgrps/bhurwitz/hurwitzlab/bin/blastall"
export JOBS=100

function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}
