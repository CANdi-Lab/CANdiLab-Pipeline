#Scoring rename function
#DO NOT EDIT####################################################################
 
rename_qualfunc <- function(file_path, ques_tibble) {
  library(tidyverse)
  
  raw_labels <- read_csv(file_path, n_max = 2, col_names = FALSE)
  rawdata <- read_csv(file_path, skip = 2)
  
  # Check if subject_id is already in rawdata
  has_subject_id <- "subject_id" %in% names(rawdata)
  if (!has_subject_id) {
    # Try to find the subject ID column by looking for something like "ResponseId" or "ID"
    possible_id_col <- names(rawdata)[1]  # fallback: assume first column is ID
    rawdata <- rawdata %>% rename(subject_id = all_of(possible_id_col))
  }
  
  ques_texts <- as.character(raw_labels[2, ])
  
  normalize_text <- function(x) {
    x |>
      str_replace_all("“|”", "\"") |>
      str_replace_all("‘|’", "'") |>
      str_replace_all("–", "-") |>
      str_squish()
  }
  
  ques_texts_clean <- normalize_text(ques_texts)
  ques_tibble_clean <- ques_tibble %>%
    mutate(text = normalize_text(text))
  
  matched_tibble <- tibble(
    q_num = names(rawdata),
    ques_text = ques_texts_clean
  ) %>%
    left_join(ques_tibble_clean, by = c("ques_text" = "text")) %>%
    mutate(scoring_code = coalesce(item, q_num))
 
   matched_tibble <- matched_tibble %>%
    group_by(scoring_code) %>%
    slice(1) %>%
    ungroup()
  
  unmatched <- matched_tibble %>% filter(is.na(item))
  if (nrow(unmatched) > 0) {
    warning("Some items did not match. Here they are:")
    print(unmatched)
  }
  
  colnames(rawdata) <- matched_tibble$scoring_code
  return(rawdata)
}
