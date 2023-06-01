# Guideline Central - partial database (from 2020 on)
# needs to be reworked - can adopt model from ecri_guidelinesubset_build.R

install.packages("readxl")
install.packages("stringr")
library(stringr)
library(tidyverse)
library(dplyr)
library(readxl)

#read in excel as guidelinecentral_all
guidelinecentral_all <- read_excel("/Users/johannahcramer/Documents/GitHub/coi/src/guidelinecentral_all.xlsx")
view(guidelinecentral_all)

# Count the number of links containing "doi/"
num_dois <- sum(grepl("doi/", guidelinecentral_all$Link))

# Print the number of links containing "doi/"
print(num_dois)

# Create a subset containing only the guidelines which have links containing "doi/"
links_with_dois <- subset(guidelinecentral_all, grepl("doi", Link))
view(links_with_dois)

# test to extract dois from link
# Split each link into parts divided by "/"
parts <- str_split(links_with_dois$Link, "/")

# Extract the part after "doi" (which is the DOI)
dois <- sapply(parts, function(x) {
  # Find the position of "doi" in the parts
  doi_index <- which(x == "doi")

  # If "doi" is not found or it is the last part, there is no DOI
  if(length(doi_index) == 0 || doi_index == length(x)) {
    return(NA)
  }

  # Return the part after "doi"
  x[doi_index + 1]
})

# Print the DOIs
print(dois)

## learned from this that "abs", "full", and "suppl", "pdf" and "epdf" are words that appear after doi/ and need to be dealt with

# Extract DOI from link string in this subset
dois_list <- str_extract(links_with_dois$Link, "(?<=doi/(abs/|suppl/|full/|pdf/|epdf/)?)(10\\..*)$")
print(dois_list)

#fill in column doi with items in the list in the order (ie. list item 1 --> row 1, list item 2 --> row 2, etc)
links_with_dois$doi[1:200] <- dois_list
view(links_with_dois)
