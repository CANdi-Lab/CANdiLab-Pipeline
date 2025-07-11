#SCORES PPIR_40

library(dplyr)
library(tibble)
source(R/function/scoring_rename_func.R) 

#Map each PPIR-40 question to the corresponding question label that is output
#from Qualtrics data

ppir40_tibble <-  tibble(
  text = c(
  "I have always seen myself as something of a rebel.",
  "I am easily flustered in pressured situations.",
  "I would find the job of a movie stunt person exciting.",
  "A lot of people have tried to “stab me in the back.”",
  "People’s reactions to the things I do often are not what I would expect.",
  "I’m not good at getting people to do favors for me.",
  "A lot of times, I worry when a friend is having personal problems.",
  "I don’t let everyday hassles get on my nerves.",
  "I could be a good “con artist.”",
  "I have a talent for getting people to talk to me.",
  "I might like to travel around the country with some motorcyclists and cause trouble.",
  "When I’m with people who do something wrong, I usually get the blame.",
  "I feel sure of myself when I’m around other people.",
  "Parachute jumping would really scare me.",
  "I like to dress differently from other people.",
  "I enjoy seeing someone I don’t like get into trouble.",
  "It bothers me a lot when I see someone crying.",
  "I get stressed out when I’m “juggling” too many tasks.",
  "I like to (or would like to) wear expensive and “showy” clothing.",
  "I don’t care about following the “rules”; I make my own rules as I go along.",
  "I’ve been the victim of a lot of bad luck.",
  "I’m hardly ever the “life of the party.”",
  "I’ve thought a lot about my long-term career goals.",
  "I feel bad about myself after I tell a lie.",
  "I push myself as hard as I can when I’m working.",
  "I get very upset when I see photographs of starving people.",
  "I hardly ever end up being the leader of a group.",
  "I might like flying across the ocean in a hot-air balloon.",
  "I worry about things even when there’s no reason to.",
  "When I am doing something important, like taking a test or doing my taxes, I check it over first.",
  "People who I thought were my “friends” have gotten me into trouble.",
  "I think long and hard before I make big decisions.",
  "I quickly get annoyed with people who do not give me what I want.",
  "If I were a firefighter, I would like the thrill of saving someone from the top of a burning building.",
  "I can remain calm in situations that would make many other people panic.",
  "I watch my finances closely.",
  "I am a daredevil.",
  "I would like to hitchhike across the country with no plans.",
  "I often place my friends’ needs above my own.",
  "If I can’t change the rules, I try to get others to bend them for me."
),
item = c(
  "PPI04", "PPI10", "PPI12", "PPI18", "PPI19", "PPI22", "PPI27", "PPI32", "PPI33", "PPI34",
  "PPI36", "PPI40", "PPI46", "PPI47", "PPI58", "PPI67", "PPI75", "PPI76", "PPI77", "PPI80",
  "PPI84", "PPI87", "PPI89", "PPI97", "PPI108", "PPI109", "PPI113", "PPI115", "PPI119", "PPI121",
  "PPI122", "PPI130", "PPI136", "PPI137", "PPI140", "PPI145", "PPI148", "PPI149", "PPI153", "PPI154"
))

ques_tibble <- ppir40_tibble

rename_qualfunc(file_path = "data/raw/rawdata.csv", ques_tibble)

rawdata <- rawdata |> 
  mutate(across(c("PPI04", "PPI10", "PPI12", "PPI18", "PPI19", "PPI22", "PPI27", "PPI32", "PPI33", "PPI34",
                  "PPI36", "PPI40", "PPI46", "PPI47", "PPI58", "PPI67", "PPI75", "PPI76", "PPI77", "PPI80",
                  "PPI84", "PPI87", "PPI89", "PPI97", "PPI108", "PPI109", "PPI113", "PPI115", "PPI119", "PPI121",
                  "PPI122", "PPI130", "PPI136", "PPI137", "PPI140", "PPI145", "PPI148", "PPI149", "PPI153", "PPI154"),
                ~ case_match(.x, "TRUE" = 1, "Mostly True" = 2, "Mostly False" = 3, "False" = 4, .default = NA),
                .names "{.col}R"
  )))


# Reverse-score items (1 <-> 4, 2 <-> 3)
rawdata <- rawdata %>%
  mutate(across(c(PPI02, PPI06, PPI07, PPI14, PPI17, PPI18, PPI22, PPI23,
                  PPI24, PPI25, PPI26, PPI27, PPI29, PPI30, PPI32, PPI36, PPI39),
                ~ recode(.x, `1` = 4, `2` = 3, `3` = 2, `4` = 1),
                ))

# Subscales
rawdata <- rawdata %>%
  mutate(
    Blame_externalization = rowSums(select(., PPI04, PPI05, PPI12, PPI21, PPI31), na.rm = TRUE),
    Carefree_nonplanfulness = rowSums(select(., PPI23R, PPI25R, PPI30R, PPI32R, PPI36R), na.rm = TRUE),
    Coldheartedness = rowSums(select(., PPI07R, PPI17R, PPI24R, PPI26R, PPI39R), na.rm = TRUE),
    Fearlessness = rowSums(select(., PPI03, PPI14R, PPI28, PPI34, PPI37), na.rm = TRUE),
    Machiavellian_egocentricity = rowSums(select(., PPI09, PPI16, PPI19, PPI33, PPI40), na.rm = TRUE),
    Rebellious_nonconformity = rowSums(select(., PPI01, PPI11, PPI15, PPI20, PPI38), na.rm = TRUE),
    Social_influence = rowSums(select(., PPI06R, PPI10, PPI13, PPI22R, PPI27R), na.rm = TRUE),
    Stress_immunity = rowSums(select(., PPI02R, PPI08, PPI18R, PPI29R, PPI35), na.rm = TRUE)
  )

# Factors
rawdata <- rawdata %>%
  mutate(
    SCI = rowSums(select(., Machiavellian_egocentricity, Rebellious_nonconformity, Blame_externalization, Carefree_nonplanfulness), na.rm = TRUE),
    FD = rowSums(select(., Social_influence, Fearlessness, Stress_immunity), na.rm = TRUE),
    PPI_Total = rowSums(select(., SCI, FD, Coldheartedness), na.rm = TRUE)
  )
