# Generalized Full Matching: Simulations

Code to run the simulations presented in the generalized full matching paper.

## Environment

We ran everything on the SAVIO cluster at UC Berkeley. A mix of low and high memory nodes were used depending on sample size. 

## Set up

We used a fresh installation of R 3.3.2 (see [this gist](https://gist.github.com/fsavje/d7e0bfb097b59ae6b9db6145895e62a7/332e81503517cd5842a405bfc4b543b6364d1b6b) for details). We installed the packages used in the simulations with:

```R
install.packages(c("devtools"), repos = "http://cloud.r-project.org")
devtools::install_version("Matching", version = "4.9-2", repos = "http://cloud.r-project.org")
devtools::install_version("optmatch", version = "0.9-7", repos = "http://cloud.r-project.org")
devtools::install_github("fsavje/Rscclust", ref = "7a275a23b7d4e5242ffdd6f68a21de4b4ba8d08d")
```

We used [GNU `time`](https://www.gnu.org/software/time/) to measure time and memory use. However, many distributions include GNU time 1.7 which reports incorrect memory use. Therefore, we used a patched version of 1.7 corrects this bug. See [this gist](https://gist.github.com/fsavje/d7e0bfb097b59ae6b9db6145895e62a7/332e81503517cd5842a405bfc4b543b6364d1b6b) for details.

Clone this repo:

```bash
git clone https://github.com/fsavje/sim_gfm.git
cd sim_gfm
```

Generate environment variables (change `global_env.sh`, `balance/env.sh` and `complexity/env.sh` as needed):

```bash
./make_envs.sh
```


## Run simulations for balance

In the `balance` folder run:

```
# Load the R module
module load r/3.3.2
# Generate batches
make generate
# Add one or more workers to SLURM queue (or run simulations in current shell with: `make run-in-shell`)
make queue
# Wait until simulations are completely done...
# Then collect results in `collected/balance.Rdata`
make collect
```

## Run simulations for complexity

`module load time/1.7 r/3.3.2`

```
# Load the R module
module load r/3.3.2
```
