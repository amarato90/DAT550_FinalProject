all: FinalProject.html

install:
	Rscript -e "renv::restore()"

data/derived_data/mtbls352_long.rds: code/00_clean_data.R
	Rscript code/00_clean_data.R

output/table1_df.rds: code/01_table1.R data/derived_data/mtbls352_long.rds
	Rscript code/01_table1.R

figures/group_barplot.png: code/02_plot.R data/derived_data/mtbls352_long.rds
	Rscript code/02_plot.R

FinalProject.html: FinalProject.Rmd output/table1_df.rds figures/group_barplot.png
	Rscript -e "rmarkdown::render('FinalProject.Rmd')"
	
clean:
	rm -f data/derived_data/mtbls352_long.rds \
	      output/table1_df.rds \
	      figures/group_barplot.png \
	      figures/group_barplot.rds \
	      FinalProject.html

# Mac/Linux
docker_report:
	mkdir -p report
	docker run --rm -v "$(pwd)/report":/project/report amrarato90/dat550-finalproject

# Windows (Git Bash)
docker_report_win:
	mkdir -p report
	docker run --rm -v "/$(CURDIR)/report":/project/report amrarato90/dat550-finalproject