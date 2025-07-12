#MASTER SCORING SCRIPT
#-------------------------------------------------------------------------------
#This script will automatically score all of the questionnaires
#Upload you Qualtrics output to the "data/raw" folder
#-------------------------------------------------------------------------------
library(tidyverse)
scoring_subscripts <- list.files("scripts/scoring/scoringsubscripts", pattern = "\\.R", full.names = TRUE)
sapply(scoring_subscripts, source)
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

#run only corresponding scoring functions for the questionnaires_to_score
for (ques in questionnaires_to_score) {
  score_func <- paste0("score_", ques)
  if (exists(score_func)) {
    scored_data <- get(score_func)(raw_Qualtricsdata)
    raw_Qualtricsdata <- dplyr::bind_cols(raw_Qualtricsdata, scored_data)
  
} else {
  warning(paste("Scoring function for", ques, "not found. Skipping."))
}}

