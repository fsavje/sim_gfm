#!/bin/bash
#
#SBATCH --job-name=complexity
#SBATCH --partition=savio
#SBATCH --account=co_praxis
#SBATCH --qos=savio_lowprio
#SBATCH --ntasks=15
#SBATCH --mem-per-cpu=4G
#SBATCH --workdir=/global/home/users/fsavje/sim_gfm/complexity/
#SBATCH --error=/global/scratch/fsavje/sim_gfm/complexity/cluster/%j.err
#SBATCH --output=/global/scratch/fsavje/sim_gfm/complexity/cluster/%j.out
#SBATCH --time=72:00:00
#
## Run command

module load r/3.3.2 time/1.7
./worker.sh 15 normal_node
