#Scoring rename function
 
rename_qualfunc <- function(file_path, ques_tibble) {
  library(tidyverse)
  raw_labels <- read_csv(file_path, n_max = 2, col_names = FALSE)
  rawdata <- read_csv(file_path, skip = 2)
  
  ques_texts <- as.character(raw_labels[2, ])
  
#cleans text from punctuation so that reassignment works
  normalize_text <- function(x) {                                         
    x |>
      str_replace_all("“|”", "\"") |> 
      str_replace_all("‘|’", "'") |>
      str_replace_all("–", "-") |> 
      str_squish() 
  }
  
  ques_texts_clean <- normalize_text(ques_texts)                          
  ques_tibble_clean <- ques_tibble |>                                     
    mutate(text = normalize_text(text))                                   
  
  matched_tibble <- tibble(
    q_num = names(rawdata),
    ques_text = ques_texts_clean                                         
  ) |> 
    left_join(ques_tibble_clean, by = c("ques_text" = "text")) |>         
    mutate(scoring_code = coalesce(item, q_num))
  
#warn if any items didn't match 
  unmatched <- matched_tibble |> filter(is.na(item))                      
  if (nrow(unmatched) > 0) {                                             
    warning("Some items did not match. Here they are:")                   
    print(unmatched)                                                      
  }      
  
  colnames(rawdata) <- matched_tibble$scoring_code
  return(rawdata)
}

