include ../global_env.sh
include env.sh

SCRATCH_DIR=$(GL_SCRATCH_DIR)$(SCRATCH_SUBDIR)

.PHONY: clean generate queue run-in-shell collect

clean:
	$(RM) -R $(SCRATCH_DIR)

generate:
	if [ -e "$(SCRATCH_DIR)batches_generated" ]; then exit 1; fi
	mkdir -p $(SCRATCH_DIR)normal_node
	mkdir -p $(SCRATCH_DIR)cluster $(SCRATCH_DIR)tmpdata $(SCRATCH_DIR)results $(SCRATCH_DIR)running
	Rscript gen_batches.R && touch $(SCRATCH_DIR)batches_generated

queue: $(SCRATCH_DIR)batches_generated
	for n in {1..4}; do sbatch run_node.sh; sleep 1; done

run-in-shell: $(SCRATCH_DIR)batches_generated
	./worker.sh 2 normal_node

collect:
	mkdir -p ../collected
	if [ -f "../collected/balance.Rdata" ]; then mv ../collected/balance.Rdata ../collected/balance$(shell date +%s).Rdata; fi
	$(RM) $(SCRATCH_DIR)tmpdata/tmp_results
	for file in `ls $(SCRATCH_DIR)results`; do cat $(SCRATCH_DIR)results/$$file >> $(SCRATCH_DIR)tmpdata/tmp_results; done
	Rscript collect.R $(SCRATCH_DIR)tmpdata/tmp_results
