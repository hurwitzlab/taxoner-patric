export CWD=$PWD
export BIN_DIR="/rsgrps/bhurwitz/hurwitzlab/bin"
export FASTA_DIR="/rsgrps/bhurwitz/hurwitzlab/data/clean/pov"
export SPLIT_FA_DIR="/rsgrps/bhurwitz/ajacob/blast-pipeline/fasta-split"
export BLAST_OUT_DIR="/rsgrps/bhurwitz/ajacob/blast-pipeline/blast-out"
export SCRIPT_DIR="$CWD/workers"
export FA_SPLIT_FILE_SIZE=5000000 # in KB
export BLAST_CONF_FILE="/rsgrps/bhurwitz/ajacob/blast-pipeline/blastdbs"
export BLAST="/rsgrps/bhurwitz/hurwitzlab/bin/blastall"
export JOBS=100

function create_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}
