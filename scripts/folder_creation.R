install.packages("usethis")
library(usethis)

#Create the template folder structure
dir.create("data")
dir.create("data/raw")
dir.create("data/processed")
dir.create("data/final")
dir.create("scripts")
dir.create("scripts/scoring")
dir.create("scripts/analysis")
dir.create("docs")
dir.create("output")
dir.create("output/figures")

# Create .gitkeep files to ensure empty folders are tracked by git
file.create("data/.gitkeep")
file.create("data/raw/.gitkeep")
file.create("data/processed/.gitkeep")
file.create("data/final/.gitkeep")
file.create("scripts/.gitkeep")
file.create("scripts/scoring/.gitkeep")
file.create("scripts/analysis/.gitkeep")
file.create("docs/.gitkeep")
file.create("output/.gitkeep")
file.create("output/figures/.gitkeep")


