#using screened_authors_sample.csv to query the NPPES API for eligible authors

# outline (to respect API policy and save time these are separate steps - of course they could be 1, but if there's a mistake it takes a long time to rerun):

# 1. put names through API to get all NPI matches for any similar name
# 2. examine these
# 3. take all returned numbers and put them back through the API to get all other identifying info on that number 

library(httr)
library(tidyverse)
library(jsonlite)
library(dplyr)

eligible_sample <- read_csv("screened_authors_sample.csv")
View(eligible_sample)

#setup NPPES API
#https://npiregistry.cms.hhs.gov/api/?version=2.1

#create the authors for the loop
authors <- data.frame(
  given = eligible_sample$given,
  family = eligible_sample$family,
  suffix = eligible_sample$suffix,
  stringsAsFactors = FALSE
)

# Create an empty df to store the NPI numbers at the end
npi_data <- data.frame(
  given = character(),
  family = character(),
  suffix = character(),
  npi = character(),
  stringsAsFactors = FALSE
)

# Loop over each row in the authors data frame
for (i in 1:nrow(authors)) {
  # Split the given name at the space
  given_parts <- strsplit(authors$given[i], " ")[[1]]
  
  # If the first part ends with a period (likely an initial), use the second part
  # Otherwise, use the first part
  if (length(given_parts) >= 2 && endsWith(given_parts[1], ".")) {
    first_name <- given_parts[2]
  } else if (length(given_parts) >= 1) {
    first_name <- given_parts[1]
  } else {
    print(paste("No given name for author:", authors$given[i], authors$family[i]))
    next  # Skip to the next iteration
  }
  
  # URL encode the names to make sure they're in a format that can be included in a URL
  first_name <- URLencode(first_name)
  last_name <- URLencode(authors$family[i])
  
  # Construct the API URL
  url <- paste0("https://npiregistry.cms.hhs.gov/api/?version=2.1&",
                "first_name=", first_name,
                "&use_first_name_alias=True&",
                "last_name=", last_name)
  
  # Send a GET request to the API
  response <- GET(url)
  
  # Parse the JSON response
  json <- content(response, "parsed", type = "application/json", encoding = "UTF-8")
  
  # Check if the "result_count" field is present in the json
  if (!"result_count" %in% names(json)) {
    print(paste("No result_count field for author:", authors$given[i], authors$family[i]))
    print(json)
    next  # Skip to the next iteration
  }
  
  # If there are any results, extract the NPI numbers
  if (json$result_count > 0) {
    # Loop over each result and store the NPI numbers in a vector
    npi_numbers <- sapply(json$results, function(x) x$number)
    
    # For each NPI number, add a row to the data frame
    for (npi in npi_numbers) {
      npi_data <- rbind(npi_data, data.frame(
        given = authors$given[i],
        family = authors$family[i],
        suffix = authors$suffix[i],
        npi = npi,
        stringsAsFactors = FALSE
      ))
    }
  }
}

View(npi_data)

#because there are so many people with the same name, need more identifying info
npi_data <- npi_data %>%
  mutate(addresses = NA,
         other_names = NA,
         taxonomies = NA)

## Another API call to get comprehensive information on every NPI I just harvested

npi_number <- npi_data$npi

# Function to make API call and retrieve specific information for a single NPI number
get_npi_info <- function(npi_number) {
  url <- paste0("https://npiregistry.cms.hhs.gov/api/?number=", npi_number, "&version=2.1")
  response <- GET(url)
  content <- content(response, "text")
  content_json <- fromJSON(content)
  return(content_json$results)
}

# Create an empty list to store the retrieved information
info_list <- list()

# Iterate through each NPI number in npi_data and retrieve the additional information
for (npi in npi_data$npi) {
  info <- get_npi_info(as.character(npi))
  info_list[[npi]] <- info
}

# Combine the retrieved information into a single dataframe
info_df <- bind_rows(info_list)

#rename info_df to something more descriptive
npidata_screenedsample <- info_df
View(npidata_screenedsample)

# Save the dataframe as an RDS file
saveRDS(npidata_screenedsample, file = "npidata_screenedsample.rds")