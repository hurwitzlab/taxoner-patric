#
# This script is intended to annotate your blast results and work with FeatureApi.py or
# add_taxid.sh
#

source ./config.sh
#TODO: just setting step size to 5 for now... change to 100 later
export STEP_SIZE=5

PROG=`basename $0 ".sh"`
STDERR_DIR="$CWD/err/$PROG"
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDERR_DIR" "$STDOUT_DIR" "$ANNOT_OUT_DIR"

cd "$BLAST_OUT_DIR"

export FILES_LIST="$BLAST_OUT_DIR/blast-files"

#TODO: Uncomment this later, for now just testing with 10 files so it should be job array of 1-10 in steps of 5
#find . -type f -name \*.fa | sed "s/^\.\///" > $FILES_LIST

NUM_FILES=$(lc $FILES_LIST)

echo Found \"$NUM_FILES\" files in \"$BLAST_OUT_DIR\"

if [ $NUM_FILES -gt 0 ]; then
    JOB_ID=`qsub -v SCRIPT_DIR,BLAST_OUT_DIR,FILES_LIST,ANNOT_OUT_DIR,SIMAP,TAXA,STEP_SIZE -N annot -e "$STDERR_DIR" -o "$STDOUT_DIR" -J 1-$NUM_FILES:$STEP_SIZE $SCRIPT_DIR/add_taxid.sh`

    if [ "${JOB_ID}x" != "x" ]; then
        echo Job: \"$JOB_ID\"
    else
        echo Problem submitting job.
    fi
else
    echo Nothing to do.
fi

