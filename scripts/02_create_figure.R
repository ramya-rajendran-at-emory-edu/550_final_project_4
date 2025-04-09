# ─────────────────────────────────────────────
# Global setup
# ─────────────────────────────────────────────
knitr::opts_chunk$set(echo = FALSE,
                      warning = FALSE,
                      message = FALSE)

library(tidyverse)
library(lubridate)
library(kableExtra)
library(scales)
library(here)
library(yaml)

# Declare project root
here::i_am("scripts/02_create_figure.R")

# ─────────────────────────────────────────────
# Determine use_web_data_flag from config.yml (priority),
# params (if available), or fallback to FALSE
# ─────────────────────────────────────────────
use_web_data_flag <- FALSE

if (file.exists(here("config.yml"))) {
  config <- yaml::read_yaml(here("config.yml"))
  if (!is.null(config$params$use_web_data)) {
    use_web_data_flag <- config$params$use_web_data
    message("[INFO] use_web_data loaded from config.yml: ",
            use_web_data_flag)
  }
} else if (exists("params") && !is.null(params$use_web_data)) {
  use_web_data_flag <- params$use_web_data
  message("[INFO] use_web_data loaded from Rmd params: ",
          use_web_data_flag)
} else {
  message("[INFO] use_web_data not found. Defaulting to FALSE.")
}

# ─────────────────────────────────────────────
# Load dataset
# ─────────────────────────────────────────────
data_url <- "https://data.cdc.gov/resource/2na8-fe6s.csv?$limit=3000"
local_file <- here("data",
                   "AH_Provisional_Cancer_Death_Counts_by_Month_and_Year_2020-2021.csv")

if (use_web_data_flag) {
  message("[INFO] Fetching data from CDC website...")
  data <- read_csv(data_url)
} else {
  message("[INFO] Loading data from local file...")
  data <- read_csv(local_file)
}
message("[DEBUG] Data loaded. Rows: ", nrow(data))

# (The rest of your figure-generation code remains unchanged)

# ─────────────────────────────────────────────
# 1. Monthly Trends Plot
# ─────────────────────────────────────────────
monthly_trends_in_total_cancer_deaths_plot <- data %>%
  select(year, month, contains("malignant"), contains("unspecified")) %>%
  group_by(year, month) %>%
  summarise(across(where(is.numeric), sum, na.rm = TRUE), .groups = "drop") %>%
  mutate(Total_Deaths = rowSums(across(-c(year, month)))) %>%
  ggplot(aes(x = month, y = Total_Deaths, color = factor(year))) +
  geom_line(size = 1) +
  labs(
    title = "Monthly Trends in Total Cancer Deaths (2020–2021)",
    x = "Month",
    y = "Total Deaths",
    color = "Year"
  ) +
  scale_x_continuous(breaks = 1:12, labels = month.abb) +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5))

ggsave(
  filename = here("output", "monthly_trends_in_total_cancer_deaths_plot.png"),
  plot = monthly_trends_in_total_cancer_deaths_plot,
  width = 10,
  height = 6,
  dpi = 300,
  bg = "white"
)

# ─────────────────────────────────────────────
# 2. Total Cancer Deaths by Year
# ─────────────────────────────────────────────
total_cancer_deaths_by_year_plot <- data %>%
  select(year, contains("malignant"), contains("unspecified")) %>%
  group_by(year) %>%
  summarise(across(where(is.numeric), sum, na.rm = TRUE), .groups = "drop") %>%
  mutate(Total_Deaths = rowSums(across(-year))) %>%
  mutate(year = as.factor(year)) %>%
  ggplot(aes(x = year, y = Total_Deaths, fill = year)) +
  geom_col() +
  labs(title = "Total Cancer Deaths by Year", x = "Year", y = "Total Deaths") +
  scale_fill_brewer(palette = "Set1") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(hjust = 0.5))

ggsave(
  filename = here("output", "total_cancer_deaths_by_year_plot.png"),
  plot = total_cancer_deaths_by_year_plot,
  width = 8,
  height = 6,
  dpi = 300,
  bg = "white"
)

# ─────────────────────────────────────────────
# 3. Deaths by Demographic Group (Sex × Race/Ethnicity)
# ─────────────────────────────────────────────
deaths_by_demographic_group_sex_and_race_ethnicity_plot <- data %>%
  select(sex,
         race_and_hispanic_origin,
         contains("malignant"),
         contains("unspecified")) %>%
  group_by(sex, race_and_hispanic_origin) %>%
  summarise(across(where(is.numeric), sum, na.rm = TRUE), .groups = "drop") %>%
  mutate(Total_Deaths = rowSums(select(
    ., starts_with("malignant"), starts_with("unspecified")
  ), na.rm = TRUE)) %>%
  ggplot(aes(x = sex, y = Total_Deaths, fill = race_and_hispanic_origin)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(labels = comma) +
  labs(title = "Total Cancer Deaths by Demographic Group (Sex and Race/Ethnicity)",
       x = "Sex",
       y = "Total Deaths",
       fill = "Race/Ethnicity") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(size = 10, hjust = 0.25, face = "bold"))

ggsave(
  filename = here(
    "output",
    "deaths_by_demographic_group_sex_and_race_ethnicity_plot.png"
  ),
  plot = deaths_by_demographic_group_sex_and_race_ethnicity_plot,
  width = 8,
  height = 6,
  dpi = 300,
  bg = "white"
)

# ─────────────────────────────────────────────
# 4. Top 5 Cancer Types by Deaths
# ─────────────────────────────────────────────
colnames(data) <- make.names(colnames(data))  # Safe renaming for ggplot
top_5_cancer_types_by_deaths_plot <- data %>%
  select(contains("malignant") | contains("unspecified")) %>%
  summarise(across(everything(), sum, na.rm = TRUE)) %>%
  pivot_longer(everything(), names_to = "Cancer_Type", values_to = "Total_Deaths") %>%
  arrange(desc(Total_Deaths)) %>%
  head(5) %>%
  ggplot(aes(
    x = reorder(Cancer_Type, Total_Deaths),
    y = Total_Deaths,
    fill = Cancer_Type
  )) +
  geom_col() +
  coord_flip() +
  scale_y_continuous(labels = comma) +
  labs(title = "Top 5 Cancer Types by Deaths", x = "Cancer Type", y = "Total Deaths") +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(size = 10, hjust = 0.25, face = "bold"),
    axis.text.x = element_text(size = 8)
  )

ggsave(
  filename = here("output", "top_5_cancer_types_by_deaths_plot.png"),
  plot = top_5_cancer_types_by_deaths_plot,
  width = 8,
  height = 6,
  dpi = 300,
  bg = "white"
)


cat("Figures rendered to output direcotry\n")
