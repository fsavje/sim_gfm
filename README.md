# Generalized Full Matching: Simulations

Code to run the simulations presented in the generalized full matching paper.


## Environment

We ran everything on the SAVIO cluster at UC Berkeley. A mix of low and high memory nodes were used depending on sample size. 


## Set up

We used a fresh installation of R 3.3.2 (see [this note](install_modules.md) for details). We installed the packages used in the simulations with:

```R
install.packages(c("devtools"), repos = "http://cloud.r-project.org")
devtools::install_version("Matching", version = "4.9-2", repos = "http://cloud.r-project.org")
devtools::install_version("optmatch", version = "0.9-7", repos = "http://cloud.r-project.org")
devtools::install_github("fsavje/Rscclust", ref = "7a275a23b7d4e5242ffdd6f68a21de4b4ba8d08d")
```

We used [GNU `time`](https://www.gnu.org/software/time/) to measure time and memory use. However, many distributions include GNU time 1.7 which reports incorrect memory use. Therefore, we used a patched version of 1.7 that corrects this bug. See [this note](install_modules.md) for details.

Clone this repo:

```bash
git clone https://github.com/fsavje/sim_gfm.git
```

Generate environment variables (change `global_env.sh`, `balance/env.sh` and `complexity/env.sh` as needed):

```bash
cd sim_gfm
./make_envs.sh
```


## Run simulations for balance

```bash
cd balance

# Generate batches
make generate

# Run simulations on node. Several nodes can run simultaneously.
# (For SLURM cluster, see the `make queue` target in the `Makefile`.)
./run_node.sh

# Wait until simulations are completely done...
# Then collect results in `collected/balance.Rdata`
make collect
```


## Run simulations for complexity

```bash
cd complexity

# Generate batches
make generate

# Run simulations on node. Several nodes can run simultaneously.
# (For SLURM cluster, see the `make queue` target in the `Makefile`.)
./run_normal_node.sh
./run_bigmem_node.sh

# Wait until simulations are completely done...
# Then collect results in `collected/complexity.Rdata`
make collect
```


## Make tables and figures

This step is quick and there's no need to run it on a cluster. It does, however, require that `collected/balance.Rdata` and `collected/complexity.Rdata` have been generated and are accessible locally.

```bash
cd tables

# Generate tables and figures (see the `output` folder for results)
make
```
