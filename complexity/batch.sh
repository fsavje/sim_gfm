#!/bin/bash

BATCHFILE="$1"
source $BATCHFILE
OUTFILE="./results/$2"

DATAFILE="$(Rscript gen_data.R $BATCHSET)"

if [ "$?" == "0" ]; then

	# Current version of optmatch doesn't work with Rscript.
	# For future versions, use Rscript if possible. I.e.:
	# `./time.sh Rscript match_funcs/scclust_EXU_CSE.R $DATAFILE >> $OUTFILE`

	if [ "$TORUN" == "level1" ]; then
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/opt_kmatch.R >> $OUTFILE
	fi

	if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ]; then
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/opt_pairmatch.R >> $OUTFILE
	fi

	if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ] || [ "$TORUN" == "level3" ]; then
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/opt_fullmatch.R >> $OUTFILE
	fi

	if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ] || [ "$TORUN" == "level3" ] || [ "$TORUN" == "level4" ]; then
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/gre_kmatch.R >> $OUTFILE
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/gre_pairmatch.R >> $OUTFILE
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/rep_pairmatch.R >> $OUTFILE
	fi

	if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ] || [ "$TORUN" == "level3" ] || [ "$TORUN" == "level4" ] || [ "$TORUN" == "level5" ]; then
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/scclust_EXU_CSE.R >> $OUTFILE
		./time.sh R --vanilla --slave "--args $DATAFILE" < match_funcs/scclust_LEX_ANY.R >> $OUTFILE
	fi

	rm $DATAFILE
	rm $BATCHFILE
fi
