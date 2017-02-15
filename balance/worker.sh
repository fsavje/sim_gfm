#!/bin/bash

source ../global_env.sh
source env.sh

SCRATCHDIR="${GL_SCRATCH_DIR}${SCRATCH_SUBDIR}"
RUNDIR="${SCRATCHDIR}running"
OUTDIR="${SCRATCHDIR}results"

JOBID="$1"
CORES="$2"
BATCHDIR="${SCRATCHDIR}$3"
COMMAND="$4"

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
			if [ $? -eq 0 ] && [ -f "$RUNDIR/$BATCHFILE" ]; then
				$COMMAND $RUNDIR/$BATCHFILE $OUTDIR/out-$BATCHFILE
			fi
		done
		echo "Finished core ${c}."
	) &
	sleep 5
done

wait
echo "All simulations done."
