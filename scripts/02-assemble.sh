source ./config.sh

PROG=`basename $0 ".sh"`
ERR_DIR=$CWD/err/$PROG
OUT_DIR=$CWD/out/$PROG

create_dir $ERR_DIR
create_dir $OUT_DIR

i=0
for DIR in `find $SPLIT_FA_DIR -maxdepth 1 -type d`; do
    i=$((i+1))

    export SPLIT_DIR=$DIR
    NUM_FILES=`find $DIR -name \*.fa | wc -l`

    if [ $NUM_FILES -gt 0 ]; then
        BASENAME=`basename $DIR`
        OUT_DIR=$BLAST_OUT_DIR/$BASENAME

        JOB=`qsub -v CWD,FILE,FINALDIR -N compile-blast -e "$ERR_DIR/$BASENAME" -o "$OUT_DIR/$BASENAME" $SCRIPTS/run_assemble_blast.sh` 

        printf '%5d: %15s %-30s\n' $i $JOB $FILE
    else
        echo Found no files in $DIR
    fi

    break
done
