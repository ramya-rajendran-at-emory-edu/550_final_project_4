
# Makefile for 550_final_project_4

# Set the R scripts and output locations
TABLE_SCRIPT = scripts/01_create_table.R
FIGURE_SCRIPT = scripts/02_create_figure.R
RENDER_SCRIPT = scripts/03_render_report.R
OUTPUT_HTML = analysis/final_project_analysis.html
RMDFILE = analysis/final_project_analysis.Rmd
DATA = data/AH_Provisional_Cancer_Death_Counts_by_Month_and_Year_2020-2021.csv

# Default target: render the full report
all: $(OUTPUT_HTML)

# Full rendering pipeline: run table script, then figure script, then render Rmd
$(OUTPUT_HTML): $(RMDFILE) $(TABLE_SCRIPT) $(FIGURE_SCRIPT)
	Rscript $(TABLE_SCRIPT)
	Rscript $(FIGURE_SCRIPT)
	Rscript $(RENDER_SCRIPT)

# ─────────────────────────────────────────────
# Run table generation only
# ─────────────────────────────────────────────
table:
	@echo "Running table generation script..."
	Rscript $(TABLE_SCRIPT)

# ─────────────────────────────────────────────
# Run figure generation only
# ─────────────────────────────────────────────
figures:
	@echo "Running figure generation script..."
	Rscript $(FIGURE_SCRIPT)

# ─────────────────────────────────────────────
# Clean up generated outputs
# ─────────────────────────────────────────────
clean:
	rm -f output/*.png output/*.html analysis/*.html
	
# ─────────────────────────────────────────────
# Install rule for restoring renv environment
# ─────────────────────────────────────────────
install:
	Rscript -e "renv::restore()"
	

.PHONY: all clean table figures 
