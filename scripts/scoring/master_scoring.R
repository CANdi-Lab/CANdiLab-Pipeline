#MASTER SCORING SCRIPT
#-------------------------------------------------------------------------------
#This script will automatically score all of the questionnaires
#Ensure that you have loaded your data in properly in the load_data.R script
#-------------------------------------------------------------------------------
library(tidyverse)
scoring_subscripts <- list.files("scripts/scoring/scoringsubscripts", pattern = "\\.R", full.names = TRUE)
invisible(sapply(scoring_subscripts, source))
################################################################################
#Remove all questionnaires from the list that you do not want to score
questionnaires_to_score <- c("PPIR40")
################################################################################

#source only the scripts in questionnaires_to_score
for (ques in questionnaires_to_score) {
  script_path <- file.path("scripts/scoring/scoringsubscripts", paste0("score_", ques, ".R"))
  if (file.exists(script_path)) {
    source(script_path)
} else {
    warning(paste("Scoring script for", ques, "not found. Skipping."))
  }}

all_scores <- list()

#run only corresponding scoring functions for the questionnaires_to_score
for (ques in questionnaires_to_score) {
  score_func <- paste0("score_", ques)
  if (exists(score_func)) {
    scored_data <- get(score_func)(rawdata)
    all_scores[[ques]] <- scored_data
  
} else {
  warning(paste("Scoring function for", ques, "not found. Skipping."))
}}

datestamp <- format(Sys.time(), "%Y-%m-%d")
write_csv(all_scores, paste0("data/processed/scored/scoreddata", datastamp, ".csv"))

