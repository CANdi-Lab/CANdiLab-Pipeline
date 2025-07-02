#LOADING IN DATA
#--------------------------------------------------------
library(tidyverse)

#LOAD IN THE DATA, 
#as shown below name each dataframe with STUDYACRONYM_TYPEOFDATA_data
STUDYACRONYM_behavioural_data <- read_csv("data/raw/BEHAVIOURAL_data.csv")
STUDYACRONYM_imaging_data <- read_csv("data/raw/IMAGING_data.csv")
STUDYACRONYM_survey_data <- read_csv("data/raw/SURVEY_data.csv")


#VIEW THE IMPORTED DATA
View(STUDYACRONYM_behavioural_data)
View(STUDYACRONYM_imaging_data)
View(STUDYACRONYM_survey_data)

head(STUDYACRONYM_behavioural_data)
head(STUDYACRONYM_imaging_data)
head(STUDYACRONYM_survey_data)

#MERGE DATASETS TOGETHER
# -----------------------------
# Make sure all datasets use the same subject ID column name ("subject_id")
# If not, rename before merging (rename(subject = subject_id))
#RENAMING SUBJECT ID COLUMN
#
STUDYACRONYM_behavioural_data <- STUDYACRONYM_behavioural_data |> rename(subject_id = SUBID)
STUDYACRONYM_imaging_data <- STUDYACRONYM_imaging_data |> rename(subject_id = SUBID)
STUDYACRONYM_survey_data <- STUDYACRONYM_survey_data |> rename(subject_id = SUBID)

STUDYACRONYM_data <- STUDYACRONYM_behavioural_data %>%
  left_join(STUDYACRONYM_imaging_data,  by = "subject_id") %>%
  left_join(STUDYACRONYM_survey_data, by = "subject_id")

#VIEW THE MERGED DATA
View(STUDYACRONYM_data)

#SAVE THE MERGED DATA (as a .csv file)
write_csv(STUDYACRONYM_data, "data/processed/STUDYACRONYM_data.csv")
