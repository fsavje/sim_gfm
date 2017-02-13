#!/bin/bash

BATCHFILE="$1"
source $BATCHFILE
OUTFILE="./results/$2"

DATAFILE="$(Rscript gen_data.R $BATCHSET)"

if [ "$?" == "0" ]; then

	# Current version of optmatch doesn't work with Rscript.
	# For future versions, use Rscript if possible. I.e.:
	# `Rscript do_matching.R scclust_EXO_ANY $DATAFILE >> $OUTFILE`

	R --vanilla --slave "--args gre_kmatch $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args gre_pairmatch $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args no_match $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args opt_fullmatch $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args opt_kmatch $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args opt_pairmatch $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args rep_pairmatch $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_EXO_ANY $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_EXO_CAS $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_EXO_CSE $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_EXU_ANY $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_EXU_CAS $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_EXU_CSE $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_INO_ANY $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_INO_CAS $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_INO_CSE $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_IU1_ANY $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_IU1_CAS $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_IU1_CSE $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_IU2_ANY $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_IU2_CAS $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_IU2_CSE $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_LEX_ANY $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_LEX_CAS $DATAFILE" < do_matching.R >> $OUTFILE
	R --vanilla --slave "--args scclust_LEX_CSE $DATAFILE" < do_matching.R >> $OUTFILE

	rm $DATAFILE
	rm $BATCHFILE
fi
