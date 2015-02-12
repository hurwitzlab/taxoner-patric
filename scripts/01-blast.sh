source ./config.sh

PROG=`basename $0 ".sh"`
ERR_DIR=$CWD/err/$PROG
OUT_DIR=$CWD/out/$PROG

create_dirs "$ERR_DIR" "$OUT_DIR" "$BLAST_OUT_DIR"

cd "$SPLIT_FA_DIR"

find . -type f -name \*.fa | sed "s/^\.\///" > split-files

#NUM_FILES=`wc -l split-files | cut -f 1 -d ' '`
NUM_FILES=2

if [ $NUM_FILES -gt 0 ]; then
    JOB=`qsub -v SCRIPT_DIR,SPLIT_FA_DIR,BLAST_OUT_DIR,BLAST_CONF_FILE -N blast -e "$ERR_DIR/$BASENAME" -o "$OUT_DIR/$BASENAME" -J 1-$NUM_FILES $SCRIPT_DIR/run_blast.sh`

    if [ "${JOB}x" != "x" ]; then
        echo Submitted $NUM_FILES files to job \'$JOB\'
    else
        echo Problem submitting job!
    fi
fi

exit 0

#i=0
#for DIR in `find $SPLIT_FA_DIR -maxdepth 1 -type d`; do
#    i=$((i+1))
#
#    export SPLIT_DIR=$DIR
#    NUM_FILES=`find $DIR -name \*.fa | wc -l`
#
#    if [ $NUM_FILES -gt 0 ]; then
#        BASENAME=`basename $DIR`
#        export WRITE_DIR="$BLAST_OUT_DIR/$BASENAME"
#        JOB=`qsub -I -v SPLIT_DIR,WRITE_DIR,BLAST_CONF_FILE -N blast -e "$ERR_DIR/$BASENAME" -o "$OUT_DIR/$BASENAME" $SCRIPTS/run_blast.sh`
#
#        printf '%5d: %15s %-30s\n' $i $JOB $FILE
#    else
#        echo Found no files in $DIR
#    fi
#
#    break
#done
