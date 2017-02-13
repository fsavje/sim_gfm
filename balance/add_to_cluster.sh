#!/bin/bash
#
#SBATCH --job-name=balance
#SBATCH --partition=savio
#SBATCH --qos=praxis_normal
#SBATCH --account=co_praxis
#SBATCH --ntasks=15
#SBATCH --mem-per-cpu=4G
#SBATCH --workdir=/global/home/users/fsavje/sim_gfm/balance/
#SBATCH --error=/global/home/users/fsavje/sim_gfm/balance/cluster/%j.err
#SBATCH --output=/global/home/users/fsavje/sim_gfm/balance/cluster/%j.out
#SBATCH --time=72:00:00
#
## Run command

module load r/3.3.2
./runbatches.sh $SLURM_JOB_ID 15 to_run ./batch.sh
