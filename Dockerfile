FROM rocker/r-ubuntu

RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev

RUN mkdir /project
WORKDIR /project

RUN mkdir code
RUN mkdir output
RUN mkdir figures
RUN mkdir -p data/raw
RUN mkdir -p data/derived_data

# Copy all relevant files
COPY data/raw data/raw
COPY code code
COPY Makefile .
COPY FinalProject.Rmd .

# Copy only essential renv files (not the renv library)
COPY .Rprofile .
COPY renv.lock .
RUN mkdir renv
COPY renv/activate.R renv
COPY renv/settings.json renv

RUN Rscript -e "renv::restore(prompt=FALSE)"

RUN mkdir report

# Install pandoc again at the end to avoid PATH issues
RUN apt-get update && apt-get install -y pandoc

CMD make && mv FinalProject.html report/