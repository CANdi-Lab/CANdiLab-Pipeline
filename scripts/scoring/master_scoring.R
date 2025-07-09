#MASTER SCORING SCRIPT
#-------------------------------------------------------------------------------
#This script will automatically score all of the questionnaires
#Upload you Qualtrics output to the "data/raw" folder
#-------------------------------------------------------------------------------
################################################################################
#Remove all questionnaires from the list that you do not want to score
questionnaires_to_score <- c("PCL", "BDI", "IRI", "PPIR40")
################################################################################

#source only the scripts in questionnaires_to_score
for (ques in questionaires_to_score) {
  script_path <- file.path("scripts/scoring/scoringsubscripts", paste0("score_", ques, ".R"))
  source(paste0(script_path))
  if (file.exists(script_path)) {
    source(script_path)
} else {
    warning(paste("Scoring script for", ques, "not found. Skipping."))
  }

#run only corresponding scoring functions for the questionnaires_to_score
for (ques in questionnaires_to_score) {
  score_func <- paste0("score_", ques)
  if (exists(score_func)) {
    get(score_func)
    scored_data <- get(score_func)(data)
  }
} else {
  warning(paste("Scoring function not found for:", ques, "Skipping."))
}}
