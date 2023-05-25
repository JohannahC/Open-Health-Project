#DRAFT 1
#Using PubMed's API to extract guideline metadata
#Example: DIABETES

#small test of accessing pubmed data using my api for just one query
library(easyPubMed)
library(httr)
library(xml2)

#easyPubMed has 2 elements: 1) the query and 2) the fetch

#query
my_query <- '("2013/01/01"[Date - Publication] : "2023/12/31"[Date - Publication]) AND ("diabetes"[Title/Abstract]) AND (("Practice Guideline"[Publication Type]) OR "guideline"[Title/Abstract] OR "consensus"[Title/Abstract]) AND ("American Diabetes Association")'
my_ids <- get_pubmed_ids(my_query)

#fetch
my_abstracts_xml <- fetch_pubmed_data(my_ids)
class(my_abstracts_xml)

#learn something about xml tags
xml_doc <- read_xml(my_abstracts_xml)
xml_elements <- xml_find_all(xml_doc, ".//*")

# Extract the unique XML tags from the elements
tags <- unique(xml_name(xml_elements))

# Print the list of unique XML tags
print(tags)

# create empty lists to contain ids, dois, years, titles

pubmed_ids <- list()
dois <- list()
years <- list()
titles <- list()

for (article in my_abstracts_xml) {
  # Extract the information using custom_grep() and the corresponding tags
  pubmed_id <- custom_grep(article, tag = "PMID")
  year <- custom_grep(article, tag = "Year")
  title <- custom_grep(article, tag = "Title")

  # Append the extracted information to the respective lists
  pubmed_ids <- append(pubmed_ids, pubmed_id)
  years <- append(years, year)
  titles <- append(titles, title)
}

print(pubmed_ids)
print(years)
print(titles)
