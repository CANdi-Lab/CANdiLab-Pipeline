#-------------------------------------------------------------------------------
# MASTER SCORING SCRIPT
#-------------------------------------------------------------------------------
library(tidyverse)

# Load all scoring sub-functions
scoring_subscripts <- list.files("scripts/scoring/scoringsubscripts", pattern = "\\.R", full.names = TRUE)
invisible(sapply(scoring_subscripts, source))

################################################################################
# Remove all questionnaires from the list that you do not want to score
questionnaires_to_score <- c("PPIR40")
################################################################################


#Sources tibbles for each Questionnaire
ques_tibble <- tibble()


for (ques in questionnaires_to_score) {
  tibble_path <- file.path("scripts/scoring/item_maps", paste0(ques, "_items.R"))
  
  if (file.exists(tibble_path)) {
    tibble_env <- new.env()
    source(tibble_path, local = tibble_env)  
    ques_var <- paste0(ques, "_tibble")      
    
    if (exists(ques_var, envir = tibble_env)) {
      this_tibble <- get(ques_var, envir = tibble_env) |>
        mutate(questionnaire = ques)
      
      ques_tibble <- bind_rows(ques_tibble, this_tibble)
    } else {
      warning(paste("Expected tibble", ques_var, "not found in", tibble_path))
    }
    
  } else {
    warning(paste("Tibble script for", ques, "not found. Skipping."))
  }
}

  


source("scripts/scoring/scoringsubscripts/scoring_rename_func.R")  
rawdata <- rename_qualfunc(file_path = "data/raw/rawdata.csv", ques_tibble) 

# Source only the scripts you need
for (ques in questionnaires_to_score) {
  script_path <- file.path("scripts/scoring/scoringsubscripts", paste0("score_", ques, ".R"))
  if (file.exists(script_path)) {
    source(script_path)
  } else {
    warning(paste("Scoring script for", ques, "not found. Skipping."))
  }}

all_scores <- list()

# Run scoring functions
for (ques in questionnaires_to_score) {
  score_func <- paste0("score_", ques)
  if (exists(score_func)) {
    scored_data <- get(score_func)(rawdata)  # now rawdata is pre-renamed
    all_scores[[ques]] <- scored_data
  } else {
    warning(paste("Scoring function for", ques, "not found. Skipping."))
  }
}

# Save outputs
datestamp <- format(Sys.time(), "%Y-%m-%d-%H%M%S")
for (ques in names(all_scores)) {
  write_csv(all_scores[[ques]], paste0("data/processed/scored/", ques, "_scored_", datestamp, ".csv"))
}
