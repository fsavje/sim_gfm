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
	# `Rscript do_matching.R scclust_EXO_ANY $DATAFILE >> $TMPFILE`

	R --vanilla --slave "--args gre_kmatch $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args gre_pairmatch $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args no_match $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args opt_fullmatch $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args opt_kmatch $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args opt_pairmatch $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args rep_pairmatch $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_EXO_ANY $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_EXO_CAS $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_EXO_CSE $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_EXU_ANY $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_EXU_CAS $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_EXU_CSE $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_INO_ANY $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_INO_CAS $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_INO_CSE $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_IU1_ANY $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_IU1_CAS $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_IU1_CSE $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_IU2_ANY $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_IU2_CAS $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_IU2_CSE $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_LEX_ANY $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_LEX_CAS $DATAFILE" < do_matching.R >> $TMPFILE
	R --vanilla --slave "--args scclust_LEX_CSE $DATAFILE" < do_matching.R >> $TMPFILE

	cat $TMPFILE >> $OUTFILE

	rm $TMPFILE
	rm $DATAFILE
	rm $BATCHFILE
fi
