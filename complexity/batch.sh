#!/bin/bash

source ../global_env.sh
source env.sh

BATCHFILE="$1"
source $BATCHFILE
SCRATCHDIR="${GL_SCRATCH_DIR}${SCRATCH_SUBDIR}"
OUTFILE="${SCRATCHDIR}/results/$2"
TMPFILE="${SCRATCHDIR}/tmp/tmp-$2"

DATAFILE="$(Rscript gen_data.R $BATCHSET)"

if [ "$?" == "0" ]; then

	rm -f $TMPFILE

	# Current version of optmatch doesn't work with Rscript.
	# For future versions, use Rscript if possible. I.e.:
	# `./time.sh Rscript match_funcs/scclust_EXU_CSE.R $DATAFILE >> $TMPFILE`

	if [ "$TORUN" == "level1" ]; then
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/opt_kmatch.R >> $TMPFILE
	fi

	if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ]; then
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/opt_pairmatch.R >> $TMPFILE
	fi

	if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ] || [ "$TORUN" == "level3" ]; then
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/opt_fullmatch.R >> $TMPFILE
	fi

	if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ] || [ "$TORUN" == "level3" ] || [ "$TORUN" == "level4" ]; then
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/gre_kmatch.R >> $TMPFILE
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/gre_pairmatch.R >> $TMPFILE
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/rep_pairmatch.R >> $TMPFILE
	fi

	if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ] || [ "$TORUN" == "level3" ] || [ "$TORUN" == "level4" ] || [ "$TORUN" == "level5" ]; then
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/scclust_EXU_CSE.R >> $TMPFILE
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/scclust_LEX_ANY.R >> $TMPFILE
	fi

	cat $TMPFILE >> $OUTFILE

	rm $TMPFILE
	rm $DATAFILE
	rm $BATCHFILE
fi
