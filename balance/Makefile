include ../global_env.sh
include env.sh

SCRATCH_DIR=$(GL_SCRATCH_DIR)$(SCRATCH_SUBDIR)

.PHONY: clean generate queue run-in-shell collect

clean:
	$(RM) -R $(SCRATCH_DIR)

generate: $(SCRATCH_DIR)
	Rscript gen_batches.R

queue: $(SCRATCH_DIR)
	for n in {1..4}; do sbatch run_node.sh; sleep 1; done

run-in-shell: $(SCRATCH_DIR)
	./worker.sh 2 normal_node

collect: ../collected
	$(RM) $(SCRATCH_DIR)tmpdata/tmp_results
	if [ -f "../collected/balance.Rdata" ]; then mv ../collected/balance.Rdata ../collected/balance$(shell date +%s).Rdata; fi
	for file in `ls $(SCRATCH_DIR)results`; do cat $(SCRATCH_DIR)results/$$file >> $(SCRATCH_DIR)tmpdata/tmp_results; done
	Rscript collect.R $(SCRATCH_DIR)tmpdata/tmp_results

../collected:
	mkdir -p ../collected

$(SCRATCH_DIR):
	mkdir -p $(SCRATCH_DIR)
	mkdir -p $(SCRATCH_DIR)normal_node
	mkdir -p $(SCRATCH_DIR)cluster
	mkdir -p $(SCRATCH_DIR)tmpdata
	mkdir -p $(SCRATCH_DIR)results
	mkdir -p $(SCRATCH_DIR)running
