# Calling CrossRef metadata using a DOI list
# this script generates "authors_clean.csv" which contains author metadata for the authors in
# "ecri_doisubset.csv"

#polite use of the CrossRef API means that you give them your email.
#Run this line, add your email to it, save the file and restart your R session

file.edit("~/.Renviron")
usethis::edit_r_environ()

install.packages("rcrossref")
install.packages("usethis")
install.packages("tidyverse")
install.packages("listviewer")
library(rcrossref)
library(usethis)
library(listviewer)
library(tidyverse)
library(dplyr)
library(purrr)

# A starter guide:
#https://ciakovx.github.io/rcrossref.html#Searching_by_DOI
# youtube tutorial: https://www.youtube.com/watch?v=dy-raTcj0no

# Import guidelines dataset with dois
ecri_doisubset <- read.csv("/Users/johannahcramer/Documents/GitHub/coi/src/ecri_doisubset.csv")
View(ecri_doisubset)

## PILOT TEST ON AHA GUIDELINES

# Create a test subset that contains only the AHA guidelines
ahatest <- ecri_doisubset %>% filter(grepl("American Heart Association", professional_medical_society))
view(ahatest)

# Create a list of only the DOIs in this set
doi_list <- ahatest$doi

# pass the doi_list vector to cr_works()
my_dois_works <- rcrossref::cr_works(dois = doi_list) %>%
  pluck("data")

#this could be included if we want a column with full names (don't think so though?):
# Extract authors' full names
#my_dois_works <- my_dois_works %>%
 # mutate(author_fullname = map(author, ~ paste(pluck(., "given"), pluck(., "family")))) %>%
  #unnest(author_fullname)

# Unnest the author column into separate rows
my_dois_works <- my_dois_works %>%
  mutate(author = map(author, ~ as.data.frame(.))) %>%
  unnest(author)

#figure out what we need to keep
colnames(my_dois_works)

# rename the final dataframe and print the data frame with select columns
authors_clean <- my_dois_works %>%
  select(doi, title, container.title, issued, given, family, suffix, affiliation.name,
         affiliation1.name,affiliation2.name, affiliation3.name,ORCID, link, url)

#unnest the link variable and only extrac the URL as link_url
authors_clean <- authors_clean %>%
  mutate(link_url = map_chr(link, ~pluck(., "URL")[1])) %>%
  select(-link)

print(authors_clean$link_url[1:20])

#check some stuff
print(head(authors_clean))
print(authors_clean$family[18:19])
print(authors_clean$affiliation.name[18:19])

# print the type of each column (e.g. character, numeric, logical, list)
purrr::map_chr(authors_clean, typeof)

write.csv(authors_clean, "authors_clean.csv")

