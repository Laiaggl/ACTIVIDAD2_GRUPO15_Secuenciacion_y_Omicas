.PHONY: run resume clean clean-results help

help:
	@echo "Available commands:"
	@echo "  make run           - Clean previous executions and results and run the Nextflow pipeline from scratch"
	@echo "  make resume        - Resume the pipeline run from the last cached step"
	@echo "  make clean         - Delete Nextflow temporary files (.nextflow.log, work/)"
	@echo "  make clean-results - Delete the generated Results directory"

run: clean clean-results
	nextflow run main.nf

resume:
	nextflow run main.nf -resume

clean:
	@echo "Cleaning Nextflow cache and logs..."
	rm -rf work/
	rm -rf .nextflow/
	rm -f .nextflow.log*
	@echo "Done."

clean-results:
	@echo "Deleting results directory..."
	rm -rf Resultados/
	@echo "Done."