#!/bin/bash

BATCHFILE="$1"

if [ ! -f "$BATCHFILE" ]; then
	echo "Cannot find batch file (batch: $BATCHFILE)" >&2
	exit 1
fi

source $BATCHFILE

DATAFILE="$(Rscript gen_data.R $BATCHSET)"

if [ $? -ne 0 ] || [ ! -f "$DATAFILE" ]; then
	echo "Cannot generate data file (batch: $BATCHFILE)" >&2
	exit 1
fi

METHODS_TORUN="gre_kmatch gre_pairmatch no_match opt_fullmatch opt_kmatch opt_pairmatch rep_pairmatch \
               scclust_EXO_ANY scclust_EXO_CAS scclust_EXO_CSE scclust_EXU_ANY scclust_EXU_CAS scclust_EXU_CSE \
               scclust_INO_ANY scclust_INO_CAS scclust_INO_CSE scclust_IU1_ANY scclust_IU1_CAS scclust_IU1_CSE \
               scclust_IU2_ANY scclust_IU2_CAS scclust_IU2_CSE scclust_LEX_ANY scclust_LEX_CAS scclust_LEX_CSE"

for match_method in $METHODS_TORUN; do
	R --vanilla --slave "--args $match_method $DATAFILE" < do_matching.R
	if [ $? -ne 0 ]; then
		echo "Error when running batch (batch: $BATCHFILE, method: $match_method)" >&2
		exit 1
	fi
done

## Current version of optmatch doesn't work with Rscript.
## For future versions, use Rscript if possible.
#for match_method in $METHODS_TORUN; do
#	Rscript do_matching.R $match_method $DATAFILE
#	if [ $? -ne 0 ]; then
#		echo "Error when running batch (batch: $BATCHFILE, method: $match_method)" >&2
#		exit 1
#	fi
#done

rm $DATAFILE
