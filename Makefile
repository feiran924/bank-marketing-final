# Bank Marketing Campaign Analysis Makefile

# Define variables
PROJECTFILES = report/finalproject2.Rmd data/bank-full.csv code/00_clean_data.R code/01_make_table1.R code/02_make_scatter.R code/04_render_report.R
RENVFILES = renv.lock renv/activate.R renv/settings.json

# Final HTML report target
report/finalproject2.html: code/04_render_report.R \
                          report/finalproject2.Rmd \
                          output/table_one.rds \
                          output/histogram.png
	Rscript code/04_render_report.R

# Data cleaning
output/data_clean.rds: code/00_clean_data.R data/bank-full.csv
	Rscript code/00_clean_data.R

# Analysis and visualization
output/table_one.rds output/histogram.png: \
                     code/01_make_table1.R \
                     code/02_make_scatter.R \
                     output/data_clean.rds
	Rscript code/01_make_table1.R && \
	Rscript code/02_make_scatter.R
	
# Run docker container to generate report
.PHONY: report
report: 
	docker run --rm -v "$(PWD)/report:/project/report" feiran924/bank-marketing-report

# Clean all generated files
.PHONY: clean
clean:
	rm -f output/*.rds && \
	rm -f output/*.png && \
	rm -f report/finalproject2.html

# Install dependencies
.PHONY: install
install:
	Rscript -e "renv::restore(prompt = FALSE)"

# Shortcut to build everything
.PHONY: all
all: report/finalproject2.html