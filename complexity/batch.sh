#!/bin/bash

source ../global_env.sh
source env.sh

BATCHFILE="$1"
source $BATCHFILE
SCRATCHDIR="${GL_SCRATCH_DIR}${SCRATCH_SUBDIR}"
OUTFILE="${SCRATCHDIR}/results/$2"
TMPFILE="${SCRATCHDIR}/tmp/tmp-$2"

DATAFILE="$(Rscript gen_data.R $BATCHSET)"

if [ "$?" == "0" ] && [ -f "$DATAFILE" ]; then

	rm -f $TMPFILE

	# Current version of optmatch doesn't work with Rscript.
	# For future versions, use Rscript if possible. I.e.:
	# `./time.sh Rscript do_matching.R scclust_EXU_CSE $DATAFILE >> $TMPFILE`

	if [ "$TORUN" == "level1" ]; then
		./time.sh R --vanilla --slave "--args opt_kmatch $DATAFILE" < do_matching.R >> $TMPFILE
	fi

	if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ]; then
		./time.sh R --vanilla --slave "--args opt_pairmatch $DATAFILE" < do_matching.R >> $TMPFILE
	fi

	if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ] || [ "$TORUN" == "level3" ]; then
		./time.sh R --vanilla --slave "--args opt_fullmatch $DATAFILE" < do_matching.R >> $TMPFILE
	fi

	if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ] || [ "$TORUN" == "level3" ] || [ "$TORUN" == "level4" ]; then
		./time.sh R --vanilla --slave "--args gre_kmatch $DATAFILE" < do_matching.R >> $TMPFILE
		./time.sh R --vanilla --slave "--args gre_pairmatch $DATAFILE" < do_matching.R >> $TMPFILE
		./time.sh R --vanilla --slave "--args rep_pairmatch $DATAFILE" < do_matching.R >> $TMPFILE
	fi

	if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ] || [ "$TORUN" == "level3" ] || [ "$TORUN" == "level4" ] || [ "$TORUN" == "level5" ]; then
		./time.sh R --vanilla --slave "--args scclust_EXU_CSE $DATAFILE" < do_matching.R >> $TMPFILE
		./time.sh R --vanilla --slave "--args scclust_LEX_ANY $DATAFILE" < do_matching.R >> $TMPFILE
	fi

	cat $TMPFILE >> $OUTFILE

	rm $TMPFILE
	rm $DATAFILE
	rm $BATCHFILE
fi
