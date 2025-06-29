install.packages("tidyverse")
library(tidyverse)

set.seed(123)

n <- 30

sample_data <- tibble(
  participant_id = paste0("P", sprintf("%03d", 1:n)),
  group = sample(c("control", "treatment"), n, replace = TRUE),
  age = sample(18:35, n, replace = TRUE),
  gender = sample(c("Male", "Female", "Other"), n, replace = TRUE, prob = c(0.45, 0.45, 0.1)),
  BDI_1 = sample(0:3, n, replace = TRUE),
  BDI_2 = sample(0:3, n, replace = TRUE),
  BDI_3 = sample(0:3, n, replace = TRUE),
  BDI_4 = sample(0:3, n, replace = TRUE),
  BDI_5 = sample(0:3, n, replace = TRUE),
  reaction_time = rnorm(n, mean = 500, sd = 80)
)

# Introduce a few missing values
sample_data$BDI_3[sample(1:n, 2)] <- NA
sample_data$reaction_time[sample(1:n, 1)] <- NA

# Save to raw data folder
if (!dir.exists("data/raw")) {
  dir.create("data/raw", recursive = TRUE)
}

write_csv(sample_data, "data/raw/sample_data.csv")



