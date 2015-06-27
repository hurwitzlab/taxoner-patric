source ./config.sh

PROG=`basename $0 ".sh"`
STDERR_DIR="$CWD/err/$PROG"
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDERR_DIR" "$STDOUT_DIR"

if [[ ! -d "$BLAST_OUT_DIR" ]]; then
    mkdir -p "$BLAST_OUT_DIR"
fi

cd "$SPLIT_FA_DIR"

export FILES_LIST="split-files"

find . -type f -name \*.fa | sed "s/^\.\///" > $FILES_LIST

NUM_FILES=$(lc $FILES_LIST)

echo Found \"$NUM_FILES\" files in \"$SPLIT_FA_DIR\"

if [ $NUM_FILES -gt 0 ]; then
    JOB_ID=`qsub -v SCRIPT_DIR,SPLIT_FA_DIR,BLAST,BLAST_OUT_DIR,BLAST_CONF_FILE,FILES_LIST -N blast -e "$STDERR_DIR" -o "$STDOUT_DIR" -J 1-$NUM_FILES $SCRIPT_DIR/run_blast.sh`

    if [ "${JOB_ID}x" != "x" ]; then
        echo Job: \"$JOB_ID\"
    else
        echo Problem submitting job.
    fi
else
    echo Nothing to do.
fi
