#!/bin/bash

source ../global_env.sh
source env.sh

JOBID="$1"
CORES="$2"
SCRATCHDIR="${GL_SCRATCH_DIR}${SCRATCH_SUBDIR}"
BATCHDIR="${SCRATCHDIR}$3"
COMMAND="$4"

RUNDIR="${SCRATCHDIR}running"

echo "Starting simulations."
for c in $(seq 1 $CORES); do
    (
		echo "Starting core ${c}."
		while true; do
			BATCHFILE="$(ls -1 $BATCHDIR | $SORT --random-sort | head -1)"
			if [ "$?" != "0" ] || [ "$BATCHFILE" == "" ]; then
				break
			fi
			echo "Running $BATCHFILE."
			mv $BATCHDIR/$BATCHFILE $RUNDIR/$BATCHFILE
			if [ "$?" == "0" ]; then
				$COMMAND $RUNDIR/$BATCHFILE "${JOBID}-${c}"
			fi
		done
		echo "Finished core ${c}."
	) &
	sleep 10
done

wait
echo "All simulations done."
