# ─────────────────────────────────────────────────────────────
# Setup
# ─────────────────────────────────────────────────────────────

# Global chunk options for rendering
knitr::opts_chunk$set(echo = FALSE,
                      warning = FALSE,
                      message = FALSE)

# Libraries
library(tidyverse)  # Data manipulation & plotting
library(lubridate)  # Date handling
library(kableExtra) # HTML table formatting
library(scales)     # Number formatting
library(here)       # File paths
library(yaml)       # Read config.yml

# Declare project root
here::i_am("scripts/01_create_table.R")

# ─────────────────────────────────────────────────────────────
# Parameter: use_web_data (defaults to FALSE, config.yml takes precedence)
# ─────────────────────────────────────────────────────────────
use_web_data_flag <- FALSE  # Default fallback

if (file.exists(here("config.yml"))) {
  config <- yaml::read_yaml(here("config.yml"))
  if (!is.null(config$params$use_web_data)) {
    use_web_data_flag <- config$params$use_web_data
    message("[INFO] use_web_data loaded from config.yml: ",
            use_web_data_flag)
  }
} else if (exists("params") && !is.null(params$use_web_data)) {
  use_web_data_flag <- params$use_web_data
  message("[INFO] use_web_data loaded from params in Rmd: ",
          use_web_data_flag)
} else {
  message("[INFO] use_web_data not specified. Using default: FALSE")
}

# ─────────────────────────────────────────────────────────────
# Load Data
# ─────────────────────────────────────────────────────────────

# Define data sources
data_url <- "https://data.cdc.gov/resource/2na8-fe6s.csv?$limit=3000"
local_file <- here("data",
                   "AH_Provisional_Cancer_Death_Counts_by_Month_and_Year_2020-2021.csv")

if (use_web_data_flag) {
  message("[INFO] Fetching data from CDC API...")
  data <- read_csv(data_url)
} else {
  message("[INFO] Loading data from local file...")
  data <- read_csv(local_file)
}

# ─────────────────────────────────────────────────────────────
# Summary Table: Cancer Deaths by Type
# ─────────────────────────────────────────────────────────────

summary_of_cancer_deaths_by_cancer_type_table <- data %>%
  select(contains("malignant") | contains("unspecified")) %>%
  summarise(across(everything(), sum, na.rm = TRUE)) %>%
  pivot_longer(cols = everything(),
               names_to = "Cancer_Type",
               values_to = "Total_Deaths") %>%
  arrange(desc(Total_Deaths)) %>%
  mutate(Total_Deaths = comma(Total_Deaths)) %>%
  kable(
    format = "html",
    caption = "**Summary of Cancer Deaths by Cancer Type**",
    col.names = c("Cancer Type", "Total Deaths"),
    align = "c"
  ) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed"),
    full_width = FALSE,
    position = "center",
    font_size = 14
  ) %>%
  row_spec(
    0,
    bold = TRUE,
    color = "white",
    background = "#2C3E50"
  ) %>%
  column_spec(1, width = "20em") %>%
  column_spec(2, width = "10em", background = "#F1C40F")

# Save table
save_kable(
  summary_of_cancer_deaths_by_cancer_type_table,
  file = here(
    "output",
    "summary_of_cancer_deaths_by_cancer_type_table.html"
  )
)


cat("Table has been created in html format to: output/summary_of_cancer_deaths_by_cancer_type_table.html\n")