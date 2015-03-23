source ./config.sh

PROG=`basename $0 ".sh"`
ERR_DIR=$CWD/err/$PROG
OUT_DIR=$CWD/out/$PROG

create_dir "$ERR_DIR" "$OUT_DIR"

if [[ ! -d "$BLAST_OUT_DIR" ]]; then
    mkdir -p "$BLAST_OUT_DIR"
fi

cd "$SPLIT_FA_DIR" 

find . -type f -name \*.fa | sed "s/^\.\///" > split-files

NUM_FILES=`wc -l split-files | cut -f 1 -d ' '`

echo Found \"$NUM_FILES\" files in \"$SPLIT_FA_DIR\"

if [ $NUM_FILES -gt 0 ]; then
    JOB=`qsub -v SCRIPT_DIR,SPLIT_FA_DIR,BLAST,BLAST_OUT_DIR,BLAST_CONF_FILE -N blast -e "$ERR_DIR" -o "$OUT_DIR" -J 1-$NUM_FILES $SCRIPT_DIR/run_blast.sh` 

    if [ "${JOB}x" != "x" ]; then
        echo Job: \"$JOB\"
    else
        echo Problem submitting job.
    fi
else
    echo Nothing to do.
fi
