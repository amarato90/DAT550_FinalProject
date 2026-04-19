library(here)
library(tidyverse)
library(janitor)
library(stringr)
library(tidyr)
library(dplyr)

here::i_am("code/00_clean_data.R")

meta_path  <- here::here("data", "raw", "MTBLS352_metadata.txt")
lipid_path <- here::here("data", "raw", "MTBLS352_intensity.tsv")

meta   <- readr::read_tsv(meta_path, show_col_types = FALSE)
lipids <- readr::read_tsv(lipid_path, show_col_types = FALSE)

lipids_patient <- lipids |>
  select(database_identifier, matches("^SD-"))

# pivot to long format
lipids_long <- lipids_patient |>
  pivot_longer(
    cols = matches("^SD-", ignore.case = FALSE),
    names_to = "source_name",
    values_to = "intensity"
  )

# Join to metadata/patient data
all_data_long <- lipids_long |>
  left_join(meta, by = c("source_name" = "Source Name"))

# Save the new datasets
saveRDS(
  all_data_long,
  file = here::here("data/derived_data", "mtbls352_long.rds")
)
