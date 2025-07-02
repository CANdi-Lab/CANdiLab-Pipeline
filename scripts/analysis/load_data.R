#LOADING IN DATA
#--------------------------------------------------------
library(tidyverse)

#Load in the data, as shown below name each dataframe with STUDYACRONYM_TYPEOFDATA_data
STUDYACRONYM_behavioural_data <- read_csv("data/raw/BEHAVIOURAL_data.csv")
STUDYACRONYM_imaging_data <- read_csv("data/raw/IMAGING_data.csv")
STUDYACRONYM_survey_data <- read_csv("data/raw/SURVEY_data.csv")


#View the imported data
View(STUDYACRONYM_behavioural_data)
View(STUDYACRONYM_imaging_data)
View(STUDYACRONYM_survey_data)