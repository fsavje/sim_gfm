include ../global_env.sh
include env.sh

TIMESTAMP=$(shell date +%s)
SCRATCH_DIR=$(GL_SCRATCH_DIR)$(SCRATCH_SUBDIR)

.PHONY: clean delete generate queue run-in-shell collect

clean:
	if [ -d "./cluster" ]; then mv ./cluster ./cluster$(TIMESTAMP); fi
	if [ -d "./results" ]; then mv ./results ./results$(TIMESTAMP); fi
	$(RM) -R $(SCRATCH_DIR)

delete:
	$(RM) -R ./cluster* ./results* $(SCRATCH_DIR)

generate: $(SCRATCH_DIR)
	Rscript gen_batches.R

queue: ./cluster ./results $(SCRATCH_DIR)
	sbatch add_to_cluster.sh

run-in-shell: ./results $(SCRATCH_DIR)
	./runbatches.sh 12345 2 to_run ./batch.sh

collect: ./results ../collected
	$(RM) -R $(SCRATCH_DIR)tmp_results
	for file in `ls ./results/`; do cat ./results/$$file >> $(SCRATCH_DIR)tmp_results ; done
	if [ -f "../collected/complexity.Rdata" ]; then mv ../collected/complexity.Rdata ../collected/complexity$(TIMESTAMP).Rdata; fi
	Rscript collect.R $(SCRATCH_DIR)tmp_results

../collected:
	mkdir -p ../collected

./cluster:
	mkdir -p ./cluster

./results:
	mkdir -p ./results

$(SCRATCH_DIR):
	mkdir -p $(SCRATCH_DIR)
	mkdir -p $(SCRATCH_DIR)to_run
	mkdir -p $(SCRATCH_DIR)tmpdata
	mkdir -p $(SCRATCH_DIR)running
