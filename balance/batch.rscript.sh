#!/bin/bash

BATCHFILE="$1"
source $BATCHFILE
OUTFILE="./results/$2"

DATAFILE="$(Rscript gen_data.R $BATCHSET)"

if [ "$?" == "0" ]; then
	Rscript run_match.R gre_kmatch $DATAFILE >> $OUTFILE
	Rscript run_match.R gre_pairmatch $DATAFILE >> $OUTFILE
	Rscript run_match.R no_match $DATAFILE >> $OUTFILE
	Rscript run_match.R opt_fullmatch $DATAFILE >> $OUTFILE
	Rscript run_match.R opt_kmatch $DATAFILE >> $OUTFILE
	Rscript run_match.R opt_pairmatch $DATAFILE >> $OUTFILE
	Rscript run_match.R rep_pairmatch $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_EXO_ANY $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_EXO_CAS $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_EXO_CSE $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_EXU_ANY $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_EXU_CAS $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_EXU_CSE $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_INO_ANY $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_INO_CAS $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_INO_CSE $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_IU1_ANY $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_IU1_CAS $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_IU1_CSE $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_IU2_ANY $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_IU2_CAS $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_IU2_CSE $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_LEX_ANY $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_LEX_CAS $DATAFILE >> $OUTFILE
	Rscript run_match.R scclust_LEX_CSE $DATAFILE >> $OUTFILE

	rm $DATAFILE
	rm $BATCHFILE
fi
