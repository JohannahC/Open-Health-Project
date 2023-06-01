#extract DOIs from the existing link column in ecri_all where the link contains the doi

install.packages("readxl")
install.packages("stringr")
library(stringr)
library(tidyverse)
library(dplyr)
library(readxl)
library(urltools)

ecri_all <- read_csv("/Users/johannahcramer/Documents/GitHub/coi/src/ecri_all.csv")
view(ecri_all)

# ** DOI HUNTING **

# How many links likely contain the DOI already?:

# 1. count the number of links containing "10." (the DOI start)
num_dois1 <- sum(grepl("10.", ecri_all$link))
print(num_dois1)
# answer = 976 (guessing there are a bunch of random "10."s included, even if not part of a doi)

# 2. count the number of links containing the string "doi" 
num_dois2 <- sum(grepl("doi", ecri_all$link))
print(num_dois2)
# answer = 497
#difference in links with "10." and "doi" (976-497 = 479)

# 3. count the number of unique links that have either a "doi" or a "10."
test <- ecri_all %>% filter(grepl("doi|10\\.", link))
print(test)
# rows = 601

# 4. try to make sense of all these discrepancies:
subset1 <- ecri_all %>% filter(grepl("10\\.", link))
subset2 <- ecri_all %>% filter(grepl("doi", link))
nrow(subset1)
#601
nrow(subset2)
#497
view(subset1)
view(subset2)

# what guidelines are in subset 1 but not in subset2?
subset3 <- subset1[!subset1$link %in% subset2$link, ]
view(subset3)
print(subset3$link)
#subset 3 has 105 rows, there are DOIs but no term "doi" just the doi itself "10."...

# ** DOI EXTRACTION **

# starting with subset 3 (smaller, easier to troubleshoot)

# 1. some characters in the dois (&) are causing problems, so need to decode:
subset3 <- subset3 %>%
  mutate(link = URLdecode(link)) %>%
  mutate(doi = str_extract(link, pattern))
view(subset3)

# 2. extract based on matched string elements:
#     - define a pattern for the regular expression function
#     - the pattern is: starts with "10." followed by any number of any characters (".*"), 
#     - then a slash ("/"), then any number of any characters (".*")
pattern <- "10\\.[0-9]+/.+"

# use the str_extract function from the stringr package to extract the first match of the pattern from each URL
dois <- stringr::str_extract(subset3$link, pattern)
print(dois)

# further cleaning subset3 - extracting the stuff that comes after the doi (ie. /attachement, .pdf, etc)
cleaned_dois <- gsub("/attachment.*|\\.pdf.*|\\?.*", "", dois)
print(cleaned_dois)

# add the cleaned dois into a new column in subset3
subset3$dois <- cleaned_dois
view(subset3)

#remove old uncleaned doi column by making new subset without it
subset3 <- subset3[, !names(subset3) %in% "doi"]

#rename dois column in subset 3 to doi
subset3 <- rename(subset3,doi = dois)
view(subset3)
              
# still a bunch of dois missing - and I want to learn more
s3_na_rows <- subset(subset3, is.na(doi))
view(s3_na_rows)
#16 rows have no doi - manually confirmed doi is not in link (keeping these in subset3 anyway)

#just having a look at the medical societies for the dois we have
print(subset3$professional_medical_society)

# moving on to subset 2:

# 1. extract DOI based on matched string elements (same as for subset3)
pattern <- "10\\.[0-9]+/.+"
doi <- stringr::str_extract(subset2$link, pattern)
print(doi)
#this looks pretty good! a couple won't be caught but the majority will be fine 

#clean subset2 - extract the stuff that comes after the doi (ie. /attachement, /full, .pdf, "?", "&", etc)
cleaned_dois <- gsub("/attachment.*|/full.*|\\.pdf.*|\\?.*|\\&.*", "", doi)
print(cleaned_dois)

# note to manually fixsome dois
# 323: "10.5858/arpa.2020-0794-CP/2879716/10.5858_arpa.2020-0794-cp.pdf"
# 371: "10.5858/arpa.2021-0632-CP/3099778/10.5858_arpa.2021-0632-cp.pdf"
# 372: "10.1542/peds.2022-057988/1326527/peds_2022057988.pdf"
# 416: "10.1542/peds.2022-060640/190443/Clinical-Practice-Guideline-for-the-Evaluation-and?autologincheck=redirected"
# may not be comprehensive list of manual-fixes

# add the cleaned dois into a new column in subset2
subset2$doi <- cleaned_dois
view(subset2)

# test for missing dois
s2_na_rows <- subset(subset2, is.na(doi))
view(s2_na_rows)
# 1 row (unique ID 1714) has no doi - manually confirmed doi is not in link (keeping in subset2 anyway)
print(subset2$professional_medical_society)

# 2. join together subsets 2 and 3
# bind rows together & then remove duplicates
ecri_doisubset <- bind_rows(subset2, subset3)
ecri_doisubset <- distinct(ecri_doisubset)
view(ecri_doisubset)

#count rows where doi == NA
num_na_doi <- sum(is.na(ecri_doisubset$doi))
print(num_na_doi)
#17 - that checks out - 16 from subset 3 and 1 from subset 2

write_csv(ecri_doisubset, "ecri_doisubset.csv")
