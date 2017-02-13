#!/bin/bash
#
#SBATCH --job-name=balance
#SBATCH --partition=savio
#SBATCH --account=co_praxis
#SBATCH --qos=praxis_savio_normal
#SBATCH --ntasks=15
#SBATCH --mem-per-cpu=4G
#SBATCH --workdir=/global/home/users/fsavje/sim_gfm/balance/
#SBATCH --error=/global/home/users/fsavje/sim_gfm/balance/cluster/%j.err
#SBATCH --output=/global/home/users/fsavje/sim_gfm/balance/cluster/%j.out
#SBATCH --time=72:00:00
#
## Run command

module load r/3.3.2
./worker.sh $SLURM_JOB_ID 15 normal_node ./batch.sh
