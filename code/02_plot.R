library(here)
library(dplyr)
library(gtsummary)
library(ggplot2)

here::i_am("code/02_plot.R")

# Load your long data
dat <- readRDS(here::here("data", "derived_data", "mtbls352_long.rds"))

# One row per participant (so counts aren't duplicated)
sample_data <- dat %>%
  distinct(source_name, .keep_all = TRUE)

plot_df <- sample_data %>%
  count(`Factor Value[Group]`)

p <-
  ggplot(plot_df, aes(x = `Factor Value[Group]`, y = n)) +
  geom_col() +
  labs(
    x = "Glycemic group",
    y = "Number of participants",
    ) +
    theme_minimal()

# Save the plot object (so you can print it in Rmd if you want)
saveRDS(p, here::here("output", "group_barplot.rds"))

# Optional: also save as an image
ggsave(
  filename = here::here("output", "group_barplot.png"),
  plot = p,
  width = 7, height = 4, dpi = 300
)