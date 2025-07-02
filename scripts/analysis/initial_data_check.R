#INITIAL DATA CHECK SCRIPT#
#PURPOSE: perform an initial check on the data
#install.packages("tidyverse") 
library(tidyverse)
library(ggplot2)
#-------------------------------------------------------------------------------

# --- Inspect basic structure ---
#Dimensions (rows, columns)
print(dim(STUDYACRONYM_data))

#Column Names
print(names(STUDYACRONYM_data))

#First 5 Rows
print(head(STUDYACRONYM_data, 5))

#Variable Types
print(sapply(STUDYACRONYM_data, class))

#Summary stats
print(summary(STUDYACRONYM_data))

# Check if there is missing values and what columns they are in
missing <- colSums(is.na(STUDYACRONYM_data))
print(missing[missing > 0])

# Check for duplicate rows
print(sum(duplicated(STUDYACRONYM_data)))

# --- Plot: Histograms for numeric variables ---
num_vars <- STUDYACRONYM_data %>% select(where(is.numeric))

for (var in names(num_vars)) {
  p <- ggplot(STUDYACRONYM_data, aes_string(x = var)) +
    geom_histogram(bins = 30, fill = "#69b3a2", color = "white") +
    theme_minimal() +
    labs(title = paste("Histogram of", var), x = var, y = "Count")
  
  ggsave(filename = paste0("output/figures/histograms/hist_", var, ".png"), plot = p, width = 6, height = 4)
}

# Plot: Boxplots by group (if 'group' exists)
if ("group" %in% colnames(STUDYACRONYM_data)) {
  for (var in names(num_vars)) {
    p <- ggplot(STUDYACRONYM_data, aes_string(x = "group", y = var)) +
      geom_boxplot(fill = "#ffa07a") +
      theme_minimal() +
      labs(title = paste("Boxplot of", var, "by Group"), x = "Group", y = var)
    
    ggsave(filename = paste0("output/figures/boxplots/box_", var, ".png"), plot = p, width = 6, height = 4)
  }
}

# Plot: Bar plots for categorical variables
cat_vars <- STUDYACRONYM_data |> select(where(~ is.character(.x) || is.factor(.x)))

for (var in names(cat_vars)) {
  p <- ggplot(STUDYACRONYM_data, aes_string(x = var)) +
    geom_bar(fill = "#87ceeb") +
    theme_minimal() +
    labs(title = paste("Bar Plot of", var), x = var, y = "Count") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave(filename = paste0("output/figures/bargraphs/bar_", var, ".png"), plot = p, width = 6, height = 4)
}

