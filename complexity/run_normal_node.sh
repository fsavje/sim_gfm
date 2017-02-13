#!/bin/bash
#
#SBATCH --job-name=complexity
#SBATCH --partition=savio
#SBATCH --account=co_praxis
#SBATCH --qos=praxis_savio_normal
#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=6G
#SBATCH --workdir=/global/home/users/fsavje/sim_gfm/complexity/
#SBATCH --error=/global/home/users/fsavje/sim_gfm/complexity/cluster/%j.err
#SBATCH --output=/global/home/users/fsavje/sim_gfm/complexity/cluster/%j.out
#SBATCH --time=72:00:00
#
## Run command

module load r/3.3.2 time/1.7
./worker.sh $SLURM_JOB_ID 10 normal_node ./batch.sh
