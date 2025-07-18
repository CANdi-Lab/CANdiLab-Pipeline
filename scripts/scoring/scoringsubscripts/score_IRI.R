#IRI Scoring Subscript
#DO NOT EDIT####################################################################

score_IRI<- function(rawdata){
  library(dplyr)
  library(tibble)
  source("scripts/scoring/scoringsubscripts/scoring_rename_func.R") 
  
  # Create PPIR-40 item mapping
  IRI_tibble <- tibble(
    text = c(
      "I daydream and fantasize, with some regularity, about things that might happen to me.",	
      "I often have tender, concerned feelings for people less fortunate than me.",
      "I sometimes find it difficult to see things from the \"other guy's\" point of view.",
      "Sometimes I don't feel very sorry for other people when they are having problems.",
      "I really get involved with the feelings of the characters in a novel.",
      "In emergency situations, I feel apprehensive and ill-at-ease.",
      "I am usually objective when I watch a movie or play, and I don't often get completely caught up in it.",
      "I try to look at everybody's side of a disagreement before I make a decision.",
      "When I see someone being taken advantage of, I feel kind of protective towards them.",
      "I sometimes feel helpless when I am in the middle of a very emotional situation.",
      "I sometimes try to understand my friends better by imagining how things look from their perspective.",
      "Becoming extremely involved in a good book or movie is somewhat rare for me.",
      "When I see someone get hurt, I tend to remain calm.",
      "Other people's misfortunes do not usually disturb me a great deal.",
      "If I'm sure I'm right about something, I don't waste much time listening to other people's arguments.",
      "After seeing a play or movie, I have felt as though I were one of the characters.",
      "Being in a tense emotional situation scares me.",
      "When I see someone being treated unfairly, I sometimes don't feel very much pity for them.",
      "I am usually pretty effective in dealing with emergencies.",
      "I am often quite touched by things that I see happen.",
      "I believe that there are two sides to every question and try to look at them both.",
      "I would describe myself as a pretty soft-hearted person.",
      "When I watch a good movie, I can very easily put myself in the place of a leading character.",
      "I tend to lose control during emergencies.",
      "When I'm upset at someone, I usually try to \"put myself in his shoes\" for a while.",
      "When I am reading an interesting story or novel, I imagine how I would feel if the events in the story were happening to me.",
      "When I see someone who badly needs help in an emergency, I go to pieces.",
      "Before criticizing somebody, I try to imagine how I would feel if I were in their place."
    ),
    item = c("IRI01", "IRI02", "IRI03", "IRI04", "IRI05", "IRI06", "IRI07", "IRI08", "IRI09", "IRI10", 
        "IRI11", "IRI12", "IRI13", "IRI14", "IRI15", "IRI16", "IRI17", "IRI18", "IRI19", "IRI20", 
        "IRI21", "IRI22", "IRI23", "IRI24", "IRI25", "IRI26", "IRI27", "IRI28")
    
  )
  
  ques_tibble <- IRI_tibble
  
  rawdata <- rename_qualfunc(file_path = "data/raw/rawdata.csv", ques_tibble)
  
  # Recode response text (including logical TRUE/FALSE) to numeric (1–4)
  recoded <- rawdata |>
    mutate(across(
      all_of(ques_tibble$item),
      ~ case_when(
        trimws(tolower(as.character(.))) %in% c("a (does not describe me well)") ~ 0L,
        trimws(tolower(as.character(.))) %in% c("b") ~ 1L,
        trimws(tolower(as.character(.))) %in% c("c")~ 2L,
        trimws(tolower(as.character(.))) %in% c("d") ~ 3L,
        trimws(tolower(as.character(.))) %in% c("e (describes me well)") ~ 4L,
        TRUE ~ NA_integer_
      )
    ))
  
  
  
  # Reverse-score items (1 <-> 4, 2 <-> 3)
  reversed_items <- c("PPI10", "PPI22", "PPI27", "PPI47", "PPI75", "PPI76", 
                      "PPI87", "PPI89", "PPI97", "PPI108", "PPI109", "PPI113", 
                      "PPI119", "PPI121", "PPI130", "PPI145", "PPI153")
  
  recoded <- recoded |>
    mutate(across(
      all_of(reversed_items),
      ~ dplyr::recode(
        as.character(.),
        "1" = 4L,
        "2" = 3L,
        "3" = 2L,
        "4" = 1L,
        .default = NA_integer_
      )
    ))
  
  # Score subscales
  scored <- recoded |>
    mutate(
      Blame_externalization = rowSums(across(all_of(c("PPI18", "PPI19", "PPI40", "PPI84", "PPI122"))), na.rm = TRUE),
      Carefree_nonplanfulness = rowSums(across(all_of(c("PPI89", "PPI108", "PPI121", "PPI130", "PPI145"))), na.rm = TRUE),
      Coldheartedness = rowSums(across(all_of(c("PPI27", "PPI75", "PPI97", "PPI109", "PPI153"))), na.rm = TRUE),
      Fearlessness = rowSums(across(all_of(c("PPI12", "PPI47", "PPI115", "PPI137", "PPI148"))), na.rm = TRUE),
      Machiavellian_egocentricity = rowSums(across(all_of(c("PPI33", "PPI67", "PPI77", "PPI136", "PPI154"))), na.rm = TRUE),
      Rebellious_nonconformity = rowSums(across(all_of(c("PPI04", "PPI36", "PPI58", "PPI80", "PPI149"))), na.rm = TRUE),
      Social_influence = rowSums(across(all_of(c("PPI22", "PPI34", "PPI46", "PPI87", "PPI113"))), na.rm = TRUE),
      Stress_immunity = rowSums(across(all_of(c("PPI10", "PPI32", "PPI76", "PPI119", "PPI140"))), na.rm = TRUE)
    ) |>
    mutate(
      SCI = rowSums(across(c(Machiavellian_egocentricity, Rebellious_nonconformity, Blame_externalization, Carefree_nonplanfulness)), na.rm = TRUE),
      FD = rowSums(across(c(Social_influence, Fearlessness, Stress_immunity)), na.rm = TRUE)
    ) |>
    mutate(
      PPI_Total = rowSums(across(c(SCI, FD, Coldheartedness)), na.rm = TRUE)
    ) |>
    select(subject_id, everything())
  
  return(scored)
}