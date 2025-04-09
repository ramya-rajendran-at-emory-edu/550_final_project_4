# ─────────────────────────────────────────────
# Load required libraries
# ─────────────────────────────────────────────
library(rmarkdown)
library(here)
library(yaml)

# ─────────────────────────────────────────────
# Declare project root
# ─────────────────────────────────────────────
here::i_am("scripts/03_render_report.R")

# ─────────────────────────────────────────────
# Define R Markdown file path
# ─────────────────────────────────────────────
rmd_file <- here("analysis", "final_project_analysis.Rmd")

# ─────────────────────────────────────────────
# Load config from config.yml (highest priority)
# ─────────────────────────────────────────────
params_list <- NULL
config_path <- here("config.yml")

if (file.exists(config_path)) {
  config <- yaml::read_yaml(config_path)
  if (!is.null(config$params)) {
    params_list <- config$params
    message("[INFO] Parameters loaded from config.yml.")
  } else {
    message("[INFO] config.yml exists but no 'params' key found.")
  }
} else {
  message("[INFO] config.yml not found.")
}

# ─────────────────────────────────────────────
# Fallback: Use Rmd params if no config-defined params exist
# ─────────────────────────────────────────────
if (is.null(params_list)) {
  message("[INFO] No config.yml params found. Using Rmd-defined params.")
  render(
    input = rmd_file,
    output_format = "html_document",
    output_dir = here("analysis"),
    clean = TRUE,
    envir = new.env()
  )
} else {
  # ─────────────────────────────────────────────
  # Render with parameters from config.yml
  # ─────────────────────────────────────────────
  message("[INFO] config.yml params found. Using congig.yml params.")
  render(
    input = rmd_file,
    output_format = "html_document",
    output_dir = here("analysis"),
    params = params_list,
    clean = TRUE,
    envir = new.env()
  )
}

cat("Report rendered to: analysis/final_project_analysis.html\n") 
