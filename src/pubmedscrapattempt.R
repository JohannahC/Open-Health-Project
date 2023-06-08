#DRAFT 1
#Using PubMed's API to extract guideline metadata
#Example: DIABETES

#small test of accessing pubmed data using my api for just one query
library(easyPubMed)
library(httr)
library(xml2)
library(jsonlite)
library(tidyverse)

medical_associations <- c(
  "American Diabetes Association",
  "American Heart Association",
  "American College of Cardiology",
  "Society for Vascular Surgery",
  "European Association for the Study of Diabetes",
  "American Medical Society for Sports Medicine",
  "American Association of Clinical Endocrinologists",
  "US Preventative Services Task Force",
  "Heart Failure Society of America",
  "American College of Radiology",
  "American College of Physicians",
  "US Department of Veterans Affairs",
  "US Department of Defense",
  "American Podiatric Medical Association",
  "Society for Vascular Medicine",
  "American Association of Diabetes Educators",
  "Academy of Nutrition and Dietetics",
  "North American Menopause Society",
  "Endocrine Society",
  "American Society for Nutrition",
  "Cystic Fibrosis Foundation"
)

# Loop over the medical associations
for (i in seq_along(medical_associations)) {
  # store the association name in a variable so we can access it more conveniently

  association <- medical_associations[i]
  cat("Running over", i, association, '\n')

  # this if statement is just for development -- if the condition is `FALSE` we'll just read a local XML instead of calling the API
  if (TRUE) {
    # build query string
    query <-
      sprintf(
        '("2013/01/01"[Date - Publication] : "2023/12/31"[Date - Publication]) AND ("diabetes"[Title/Abstract]) AND (("Practice Guideline"[Publication Type]) OR "guideline"[Title/Abstract] OR "consensus"[Title/Abstract]) AND ("%s")',
        association
      )

    # print the query string here, make sure it is correct
    cat("Full query string\n", query, "\n")

<<<<<<< Updated upstream
    # get the IDs and pubmed data for query string, parse as xml
    ids <- get_pubmed_ids(query)
    results <- fetch_pubmed_data(ids)
    results_as_xml <- read_xml(results)

    # save raw xml, open the result in Google Chrome to inspect!
    xml_path <-  sprintf("data/Results_%s_%s.xml", i, association)
    write_xml(results_as_xml, file = xml_path, options = 'as_xml')
    cat("Wrote XML to", xml_path, "\n")
  } else {
    results_as_xml = read_xml(sprintf("data/Results_%s_%s.xml", i, association))
  }
=======
  # get the IDs and pubmed data for query string, parse as xml
  ids <- get_pubmed_ids(query)
  results <- fetch_pubmed_data(ids)
  results_as_xml <- read_xml(results)
>>>>>>> Stashed changes

  # Parsing XML into dataframe
  # get the relevant XML tags from here: https://www.ncbi.nlm.nih.gov/books/NBK3828/#publisherhelp.XML_Tag_Descriptions
  # note that this df will be overwritten in every iteration of the loop
  # so when opening `results_df` in RStudio, you'll only see the results of the latest loop iteration
  # Open the resulting .csv file from Finder
  results_df <- results_as_xml %>%
    xml_find_all("//PubmedArticle") %>%
    map_df(~ {
      tibble(
        QueriedAssociation = association,
        JournalTitle = xml_find_first(., "MedlineCitation/Article/Journal/Title") %>% xml_text(trim = TRUE),
        Year = xml_find_first(., "MedlineCitation/Article/Journal/JournalIssue/PubDate/Year") %>% xml_text(trim = TRUE),
        JournalISSN = xml_find_first(., ".//ISSN") %>% xml_text(trim = TRUE),
        ArticleTitle = xml_find_first(., "MedlineCitation/Article/ArticleTitle") %>% xml_text(trim = TRUE),
        ID_doi = xml_find_first(., ".//ArticleId[@IdType='doi']") %>% xml_text(trim = TRUE),
        ID_pii = xml_find_first(., ".//ArticleId[@IdType='pii']") %>% xml_text(trim = TRUE),
        ID_pubmed = xml_find_first(., ".//ArticleId[@IdType='pubmed']") %>% xml_text(trim = TRUE),
      )
    })

  # write dataframe to csv in `./data` dir
<<<<<<< Updated upstream
  fname <- sprintf("data/Results_%s_%s.csv", i, association)
=======
  fname <- sprintf("../data/Results_%s_%s.csv", i, association)
>>>>>>> Stashed changes
  write.csv(results_df, fname, row.names = FALSE)
  cat("Saved Dataframe to", fname, '\n')

  # this condition means it breaks after the third iteration
  # if you want to try this out on a few associations before running the full thing
  # just comment out the `break` line with `#` to run over all
  if (i == 1) {
    #break
  }

}
