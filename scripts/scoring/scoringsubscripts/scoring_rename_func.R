#Scoring rename function
 
rename_qualfunc <- function(file_path, ques_tibble) {
  library(tidyverse)
  raw_labels <- read_csv(file_path, n_max = 2, col_names = FALSE)
  rawdata <- read_csv(file_path, skip = 2)
  
  ques_texts <- as.character(raw_labels[2, ])
  
  matched_tibble <- tibble(
    q_num = names(rawdata),
    ques_text = ques_texts) |>
    left_join(ques_tibble, by = c("ques_text" = "text")) |>
    mutate(scoring_code = coalesce(item, q_num)
      )
  colnames(rawdata) <- matched_tibble$scoring_code
  return(rawdata)
  date_stamp <- format(Sys.Date(), "%Y%m%d")
  write_csv(rawdata, paste0("data/processed/scored", ques, "_scored", date_stamp, ".csv"))
}

