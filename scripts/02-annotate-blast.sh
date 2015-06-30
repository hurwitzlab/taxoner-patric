#
# This script is intended to annotate your blast results and work with FeatureApi.py
#

source ./config.sh

PROG=`basename $0 ".sh"`
STDERR_DIR="$CWD/err/$PROG"
STDOUT_DIR="$CWD/out/$PROG"
