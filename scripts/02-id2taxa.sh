source ./config.sh

PROG=`basename $0 ".sh"`
STDERR_DIR="$CWD/err/$PROG"
STDOUT_DIR="$CWD/out/$PROG"
export STEP_SIZE=500
export SUB_SAMPLES=10

init_dir "$STDERR_DIR" "$STDOUT_DIR"

if [[ ! -d "$UPROC_ID2FEATURE" ]]; then
    mkdir -p "$UPROC_ID2FEATURE"
fi
#First we'll work on Kegg stuff
if [[ ! -d "$UPROC_KEGG_OUT" ]]; then
    echo "Can't find UPROC Kegg output directory"
else
    export RUNKEGG=1
    export RUNPFAM=0
    
    cd "$UPROC_KEGG_OUT"

    export FILES_LIST="kegg-files"

    find . -type f -name \*.uproc | sed "s/^\.\///" > $FILES_LIST

    NUM_FILES=$(lc $FILES_LIST)

    echo Found \"$NUM_FILES\" files in \"$UPROC_KEGG_OUT\" 
    if [ $NUM_FILES -gt 0 ]; then
        JOB_ID=`qsub -v SUB_SAMPLES,RUNKEGG,RUNPFAM,UPROC_PFAM_OUT,UPROC_KEGG_OUT,STEP_SIZE,SCRIPT_DIR,WORKERS_DIR,UPROC_ID2FEATURE,FILES_LIST -N run-id2kegg -e "$STDERR_DIR" -o "$STDOUT_DIR" -J 1-$NUM_FILES:$STEP_SIZE $WORKERS_DIR/run_id2feature.sh`

        if [ "${JOB_ID}x" != "x" ]; then
            echo Job: \"$JOB_ID\"
        else
            echo Problem submitting job.
        fi
    else
        echo Nothing to do.
    fi
fi
#Second we'll do PFAM
if [[ ! -d "$UPROC_PFAM_OUT" ]]; then
    echo "Can't find UPROC Pfam output directory"
else
    export RUNKEGG=0
    export RUNPFAM=1

    cd "$UPROC_PFAM_OUT"

    export FILES_LIST="pfam-files"

    find . -type f -name \*.uproc | sed "s/^\.\///" > $FILES_LIST

    NUM_FILES=$(lc $FILES_LIST)

    echo Found \"$NUM_FILES\" files in \"$UPROC_PFAM_OUT\"

    if [ $NUM_FILES -gt 0 ]; then
        JOB_ID=`qsub -v SUB_SAMPLES,RUNKEGG,RUNPFAM,UPROC_KEGG_OUT,UPROC_PFAM_OUT,STEP_SIZE,SCRIPT_DIR,WORKERS_DIR,UPROC_ID2FEATURE,FILES_LIST -N run-id2pfam -e "$STDERR_DIR" -o "$STDOUT_DIR" -J 1-$NUM_FILES:$STEP_SIZE $WORKERS_DIR/run_id2feature.sh`

        if [ "${JOB_ID}x" != "x" ]; then
            echo Job: \"$JOB_ID\"
        else
            echo Problem submitting job.
        fi
    else
        echo Nothing to do.
    fi
fi
