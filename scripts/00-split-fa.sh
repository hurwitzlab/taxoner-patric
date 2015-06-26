source ./config.sh

PROG=`basename $0 ".sh"`
STDERR_DIR="$CWD/err/$PROG"
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDERR_DIR" "$STDOUT_DIR" "$SPLIT_FA_DIR"

cd "$FASTA_DIR"

export FILES_LIST="$FASTA_DIR/files-list"

find . -type f -name \*.fa | sed "s/^\.\///" > $FILES_LIST

NUM_FILES=`wc -l files | cut -f 1 -d ' '`

echo Found \"$NUM_FILES\" files in \"$FASTA_DIR.\"

if [ $NUM_FILES -gt 0 ]; then
    JOB_ID=`qsub -v CWD,BIN_DIR,FASTA_DIR,SPLIT_FA_DIR,FILES_LIST,FA_SPLIT_FILE_SIZE -N split-fa -e "$STDERR_DIR" -o "$STDOUT_DIR" $SCRIPT_DIR/split_fa.sh`
    echo Submitted job \"$JOB_ID.\"  Adios.
else
    echo Nothing to do.
fi
