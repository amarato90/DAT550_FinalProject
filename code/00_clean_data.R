library(here)
library(tidyverse)
library(janitor)

here::i_am("code/00_clean_data.R")
meta_path  <- here::here("data", "raw", "MTBLS352_metadata.txt")
lipid_path <- here::here("data", "raw", "MTBLS352_intensity.tsv")

meta   <- readr::read_tsv(meta_path, show_col_types = FALSE) 
lipids <- readr::read_tsv(lipid_path, show_col_types = FALSE) 

#Match the IDs
meta2 <- meta |>
  mutate(
    sd_id = tolower(gsub("-", "_", "source name"))  # "SD-B00375" -> "sd_b00375"
  )


library(stringr)
library(tidyr)
library(dplyr)

lipids_patient <- lipids |>
  select(database_identifier, matches("^SD-"))  # keep features + patient sample columns

#pivot to long format
lipids_long <- lipids_patient |>
  pivot_longer(
    cols = matches("^SD-", ignore.case = FALSE),
    names_to = "source_name",
    values_to = "intensity"
  )

# Join to metadata/patient data
all_data_long <- lipids_long |>
  left_join(meta, by = c("source_name" = "Source Name"))

#Save the new datasets
saveRDS(
  all_data_long,
  file = here::here("data/derived_data", "mtbls352_long.rds")
)