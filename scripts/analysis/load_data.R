#LOADING IN DATAFRAMES
#-------------------------------------------------------------------------------
library(tidyverse)

#LOAD IN THE DATA 
################################################################################
#MOVE ALL RAW DATA FILES INTO data/raw folder (you can drag and drop)
#REPLACE FILENAME WITH THE ACTUAL FILENAME OF YOUR DATA
raw_behaviouraldata <- read_csv("data/raw/FILENAME.csv")
raw_imagingdata <- read_csv("data/raw/FILENAME.csv")
raw_Qualtricsdata <- read_csv("data/raw/FILENAME.csv")
#the dataframe names must stay the same for subsquent code to work properly 
#(e.g. raw_behaviouraldata)
################################################################################

#VIEW THE IMPORTED DATA
View(raw_behaviouraldata)
View(raw_imagingdata)
View(raw_Qualtricsdata)

head(raw_behaviouraldata)
head(raw_imagingdata)
head(raw_Qualtricsdata)

#-------------------------------------------------------------------------------
#MERGE DATASETS TOGETHER

#To merge all the datasets together they have to have the same column name for the subject ID.
#Here we rename the subject ID column in each dataset to "subject_id" for consistency.
#Change "SUBID" to the actual column name in your datasets if it's different.
raw_behaviouraldata <- raw_behaviouraldata |> rename("Subject Number" = SUBID)
raw_imagingdata <- raw_imagingdata |> rename(subject_id = SUBID)
raw_Qualtricsdata <- raw_Qualtricsdata |> rename(SUBID = "Q247")

rawdata <- raw_behaviouraldata %>%
  left_join(raw_imagingdata,  by = "subject_id") %>%
  left_join(raw_Qualtricsdata, by = "subject_id")

#VIEW THE MERGED DATA
View(rawdata)

#SAVE THE MERGED DATA (as a .csv file)
write_csv(rawdata, paste0("data/raw/rawdata.csv"))
#-------------------------------------------------------------------------------
