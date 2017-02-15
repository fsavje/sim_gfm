#!/bin/bash

source ../global_env.sh
source env.sh

SCRATCHDIR="${GL_SCRATCH_DIR}${SCRATCH_SUBDIR}"
RUNDIR="${SCRATCHDIR}running"
TMPDIR="${SCRATCHDIR}tmpdata"
OUTDIR="${SCRATCHDIR}results"

CORES="$1"
BATCHDIR="${SCRATCHDIR}$2"

echo "Starting simulations."
for c in $(seq 1 $CORES); do
    (
		echo "Starting core ${c}."

		while true; do

			BATCHFILE="$(ls -1 $BATCHDIR | $SORT --random-sort | head -1)"

			if [ $? -ne 0 ] || [ "$BATCHFILE" == "" ]; then
				break
			fi

			echo "Running $BATCHFILE."

			mv $BATCHDIR/$BATCHFILE $RUNDIR/$BATCHFILE

			if [ $? -ne 0 ] || [ ! -f "$RUNDIR/$BATCHFILE" ]; then
				continue
			fi

			if [ -e "$TMPDIR/tmp-$BATCHFILE" ]; then
				rm $TMPDIR/tmp-$BATCHFILE
			fi

			./batch.sh $RUNDIR/$BATCHFILE $TMPDIR/tmp-$BATCHFILE

			if [ $? -eq 0 ] && [ -f "$TMPDIR/tmp-$BATCHFILE" ]; then
				mv $TMPDIR/tmp-$BATCHFILE $OUTDIR/res-$BATCHFILE
				rm $RUNDIR/$BATCHFILE
			else
				rm $TMPDIR/tmp-$BATCHFILE
			fi

		done

		echo "Finished core ${c}."
	) &
	sleep 5
done

wait

echo "All simulations done."
