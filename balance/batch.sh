#!/bin/bash

BATCHFILE="$1"
source $BATCHFILE
OUTFILE="./results/$2"

DATAFILE="$(Rscript gen_data.R $BATCHSET)"

if [ "$?" == "0" ]; then

	# Current version of optmatch doesn't work with Rscript.
	# For future versions, use Rscript if possible. I.e.:
	# `Rscript run_match.R scclust_EXO_ANY $DATAFILE >> $OUTFILE`

	if [ "$TORUN" == "all" ]; then
		R --vanilla --slave "--args opt_kmatch $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args opt_pairmatch $DATAFILE" < run_match.R >> $OUTFILE
	fi

	if [ "$TORUN" == "all" ] || [ "$TORUN" == "high" ]; then
		R --vanilla --slave "--args gre_kmatch $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args gre_pairmatch $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args no_match $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args opt_fullmatch $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args rep_pairmatch $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_EXO_ANY $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_EXO_CAS $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_EXO_CSE $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_EXU_ANY $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_EXU_CAS $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_EXU_CSE $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_INO_ANY $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_INO_CAS $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_INO_CSE $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_IU1_ANY $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_IU1_CAS $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_IU1_CSE $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_IU2_ANY $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_IU2_CAS $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_IU2_CSE $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_LEX_ANY $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_LEX_CAS $DATAFILE" < run_match.R >> $OUTFILE
		R --vanilla --slave "--args scclust_LEX_CSE $DATAFILE" < run_match.R >> $OUTFILE
	fi

	rm $DATAFILE
	rm $BATCHFILE
fi
