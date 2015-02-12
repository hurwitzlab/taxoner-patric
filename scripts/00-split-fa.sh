source ./config.sh

PROG=`basename $0 ".sh"`
ERR_DIR=$CWD/err/$PROG
OUT_DIR=$CWD/out/$PROG

create_dirs $ERR_DIR $OUT_DIR $SPLIT_FA_DIR

cd $FASTA_DIR 

find . -type f -name \*.fa > files

NUM_FILES=`wc -l files | cut -f 1 -d ' '`

if [ $NUM_FILES -gt 0 ]; then
    JOB=`qsub -v CWD,BIN_DIR,FASTA_DIR,SPLIT_FA_DIR,FA_SPLIT_FILE_SIZE -N split-fa -e $ERR_DIR/$BASENAME -o $OUT_DIR/$BASENAME -J 1-$NUM_FILES $SCRIPT_DIR/split_fa.sh`
    echo "Submitted $NUM_FILES to job '$JOB'"
else
    echo "Found no FASTA files in dir '$FASTA_DIR'"
fi

#i=0
#for FILE in $FASTA_DIR/*.fa; do
#    i=$((i+1))
#
#    export FILE
#    BASENAME=`basename $FILE`
#
#    JOB=`qsub -v CWD,BIN_DIR,FILE,FASTA_DIR,SPLIT_FA_DIR,FA_SPLIT_FILE_SIZE -N split-fa -e $ERR_DIR/$BASENAME -o $OUT_DIR/$BASENAME $SCRIPTS/split_fa.sh`
#
#    printf '%5d: %15s %-30s\n' $i $JOB $BASENAME
#
#    #break
#done
