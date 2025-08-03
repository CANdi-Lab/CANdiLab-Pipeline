#Scoring rename function
#DO NOT EDIT####################################################################
rename_qualfunc <- function(file_path, ques_tibble) {
  library(tidyverse)
  
  rawdata <- read_csv(file_path)
  colnames_raw <- names(rawdata)
  
  normalize_text <- function(x) {
    x |>
      str_replace_all("“|”", "\"") |>
      str_replace_all("‘|’", "'") |>
      str_replace_all("–", "-") |>
      str_replace_all("\\.", " ") |>
      str_replace_all("\\s+", " ") |>
      str_trim() |>
      tolower()
  }
  
  # Normalize text in both sources
  ques_tibble_cleaned <- ques_tibble |> 
    mutate(cleaned = normalize_text(text))
  
  colname_df <- tibble(
    original = colnames_raw,
    cleaned = normalize_text(colnames_raw)
  )
  
  matched_lookup <- rename_lookup |> filter(!duplicated(original))
  
  # Rename only matched columns
  for (i in seq_len(nrow(matched_lookup))) {
    col <- matched_lookup$original[i]
    new_col <- matched_lookup$final_name[i]
    if (col != new_col && col %in% colnames(rawdata)) {
      names(rawdata)[names(rawdata) == col] <- new_col
    }
  }
