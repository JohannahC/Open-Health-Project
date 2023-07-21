# Crossref API call for American Diabetes Association DOIs (between 2018-2023)

library(rcrossref)
library(usethis)
library(tidyverse)
library(listviewer)
library(dplyr)

# setup - add email address in r_environ below & save file
# usethis::edit_r_environ()

# load raw, scraped data
ada_dois <- read.csv("data-raw/ada_dois.csv")

# get metadata
ada_dois_metadata_get <- get_guideline_metadata(ada_dois)

# select relevant metadata
ada_dois_metadata_select <- select_metadata(ada_dois_metadata_get)

ada_metadata <- ada_dois_metadata_select
usethis::use_data(ada_metadata, overwrite = TRUE)
