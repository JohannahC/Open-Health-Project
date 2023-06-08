

#using authors_clean to query the NPPES API for NPI numbers:
#this script generates "npi_call_results_dirty.RDS"

library(httr)
library(tidyverse)
library(jsonlite)

authors_clean <- read_csv("authors_clean.csv")
View(authors_clean)

#setup NPPES API
#https://npiregistry.cms.hhs.gov/api/?version=2.1

#create the authors for the loop
authors <- data.frame(
  given = authors_clean$given,
  family = authors_clean$family,
  suffix = authors_clean$suffix,
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
npi_call_results_dirty <- info_df

# Save the dataframe as an RDS file
saveRDS(npi_call_results_dirty, file = "npi_call_results_dirty.rds")

#PILOT TEST FOR SINGLE NAME - MOVED TO BOTTOM
# this test creates an output of a list that contains all the NPIs associated with a queried name (ie. cheryl bushnell)
# Define the API endpoint
#url <- "https://npiregistry.cms.hhs.gov/api/"

# Define the parameters
#params <- list(
#  version = "2.1",
#  first_name = "Cheryl",
#  last_name = "Bushnell",
#  use_first_name_alias = "True"
#)

# Create an empty list to store the NPI numbers
#npi_list <- list()

# Send a GET request to the API
#response <- GET(url, query = params)

# Parse the JSON response
#data <- content(response, "parsed")

# Check if the "results" field is present in the data
#if ("results" %in% names(data)) {
# Loop over each result
#  for (result in data$results) {
# Check if the "number" field is present in the result
#    if ("number" %in% names(result)) {
# Append the NPI number to our list
#      npi_list <- append(npi_list, result$number)
#    }
#  }
#}

# Print the list of NPI numbers
#print(npi_list)

