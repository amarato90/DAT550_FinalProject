# DAT550 Final Project: Lipidomics MTBLS352

**Author:** Ana Ramirez

## About
This project analyzes plasma lipidomics data from the public metabolomics 
study [MTBLS352](https://www.ebi.ac.uk/metabolights/editor/MTBLS352/files), 
which includes 293 adults from China across three glycemic groups: normal 
glucose tolerance, prediabetes, and type 2 diabetes.

## Docker Instructions
### Build the Docker image
To build the Docker image locally, run:
docker build -t data550-finalproject .

### Docker image on DockerHub
The pre-built Docker image is available on DockerHub:
https://hub.docker.com/r/amrarato90/dat550-finalproject

To pull the image directly:
docker pull amrarato90/dat550-finalproject

## Generate the report with Docker
First, create an empty `report/` folder in the project directory.
and run one of the options Mac/Windows below. 
The compiled report `FinalProject.html` will appear in the `report/` folder.
### Mac/Linux
make docker_report

### Windows (Git Bash)
make docker_report_win

## Package Installation

To synchronize the package environment, run:
```bash
make install
```
This will restore all required packages using `renv`.

## How to Generate the Report
From the project root, run:
```bash
make
```
This will run all scripts in order and render `FinalProject.html`.

To remove all generated files:
```bash
make clean
```

## Code Description
`code/00_clean_data.R`
- reads raw metadata (`data/raw/MTBLS352_metadata.txt`) and lipid intensity 
  data (`data/raw/MTBLS352_intensity.tsv`)
- pivots lipid data to long format and joins with participant metadata
- saves cleaned dataset to `data/derived_data/mtbls352_long.rds`

`code/01_table1.R`
- reads `data/derived_data/mtbls352_long.rds`
- generates Table 1: number of participants per lipid per glycemic group
- saves table to `output/table1_df.rds`

`code/02_plot.R`
- reads `data/derived_data/mtbls352_long.rds`
- generates Figure 1: bar plot of number of participants per glycemic group
- saves figure to `figures/group_barplot.png` and `figures/group_barplot.rds`

`FinalProject.Rmd`
- reads outputs from `code/01_table1.R` and `code/02_plot.R`
- renders the final HTML report with Table 1 and Figure 1