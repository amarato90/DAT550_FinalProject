library(here)
library(dplyr)
library(tidyr)

here::i_am("code/01_table1.R")

data <- readRDS(
  here::here("data", "derived_data", "mtbls352_long.rds"))

# Count unique participants (source_name) per lipid per glycemic group
table1_df <- data %>%
  select(database_identifier, `Factor Value[Group]`, source_name) %>%
  filter(!is.na(database_identifier),
         !is.na(`Factor Value[Group]`),
         !is.na(source_name)) %>%
  distinct(database_identifier, `Factor Value[Group]`, source_name) %>%
  count(database_identifier, `Factor Value[Group]`, name = "n") %>%
  pivot_wider(
    names_from = `Factor Value[Group]`,
    values_from = n,
    values_fill = 0
  ) %>%
  mutate(Overall = rowSums(across(where(is.numeric)))) %>%
  relocate(Overall, .after = database_identifier) %>%
  rename(`Lipid Identified` = database_identifier)

saveRDS(table1_df, here::here("output", "table1_df.rds"))