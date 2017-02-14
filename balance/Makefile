include ../global_env.sh
include env.sh

SCRATCH_DIR=$(GL_SCRATCH_DIR)$(SCRATCH_SUBDIR)

.PHONY: clean generate queue run-in-shell collect

clean:
	$(RM) -R ./cluster $(SCRATCH_DIR)

generate: $(SCRATCH_DIR)
	Rscript gen_batches.R

queue: ./cluster $(SCRATCH_DIR)
	sbatch run_node.sh

run-in-shell: $(SCRATCH_DIR)
	./worker.sh 12345 2 normal_node ./batch.sh

collect: ../collected
	$(RM) -R $(SCRATCH_DIR)tmp_results
	for file in `ls $(SCRATCH_DIR)results`; do cat $(SCRATCH_DIR)results/$$file >> $(SCRATCH_DIR)tmp_results ; done
	if [ -f "../collected/balance.Rdata" ]; then mv ../collected/balance.Rdata ../collected/balance$(shell date +%s).Rdata; fi
	Rscript collect.R $(SCRATCH_DIR)tmp_results

../collected:
	mkdir -p ../collected

./cluster:
	mkdir -p ./cluster

$(SCRATCH_DIR):
	mkdir -p $(SCRATCH_DIR)
	mkdir -p $(SCRATCH_DIR)normal_node
	mkdir -p $(SCRATCH_DIR)tmp
	mkdir -p $(SCRATCH_DIR)tmpdata
	mkdir -p $(SCRATCH_DIR)results
	mkdir -p $(SCRATCH_DIR)running
