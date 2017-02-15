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

METHODS_TORUN="scclust_EXU_CSE scclust_LEX_ANY"
if [ "$TORUN" == "level1" ]; then
	METHODS_TORUN="$METHODS_TORUN opt_kmatch"
fi
if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ]; then
	METHODS_TORUN="$METHODS_TORUN opt_pairmatch"
fi
if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ] || [ "$TORUN" == "level3" ]; then
	METHODS_TORUN="$METHODS_TORUN opt_fullmatch"
fi
if [ "$TORUN" == "level1" ] || [ "$TORUN" == "level2" ] || [ "$TORUN" == "level3" ] || [ "$TORUN" == "level4" ]; then
	METHODS_TORUN="$METHODS_TORUN gre_kmatch gre_pairmatch rep_pairmatch"
fi

for match_method in $METHODS_TORUN; do
	./time.sh R --vanilla --slave "--args $match_method $DATAFILE" < do_matching.R
	if [ $? -ne 0 ]; then
		echo "Error when running batch (batch: $BATCHFILE, method: $match_method)" >&2
		exit 1
	fi
done

## Current version of optmatch doesn't work with Rscript.
## For future versions, use Rscript if possible.
#for match_method in $METHODS_TORUN; do
#	./time.sh Rscript do_matching.R $match_method $DATAFILE
#	if [ $? -ne 0 ]; then
#		echo "Error when running batch (batch: $BATCHFILE, method: $match_method)" >&2
#		exit 1
#	fi
#done

rm $DATAFILE
