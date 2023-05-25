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

  # build query string
  cat("Running over", i, association, '\n')
  query <-
    sprintf(
      '("2013/01/01"[Date - Publication] : "2023/12/31"[Date - Publication]) AND ("diabetes"[Title/Abstract]) AND (("Practice Guideline"[Publication Type]) OR "guideline"[Title/Abstract] OR "consensus"[Title/Abstract]) AND ("%s")',
      association
    )
  cat("Full query string\n", query, "\n")

  # get the IDs and pubmed data for query string, parse as xml
  ids <- get_pubmed_ids(query)
  results <- fetch_pubmed_data(dami_on_pubmed)
  results_as_xml <- read_xml(results)

  # Parsing XML into a dataframe
  # get the relevant XML tags from here: https://www.ncbi.nlm.nih.gov/books/NBK3828/#publisherhelp.XML_Tag_Descriptions
  results_df <- results_as_xml %>%
    xml_find_all("//Article") %>%
    map_df(~ {
      tibble(
        PublisherName = xml_find_first(., "Journal/PublisherName") %>% xml_text(trim = TRUE),
        JournalTitle = xml_find_first(., "Journal/JournalTitle") %>% xml_text(trim = TRUE),
        Volume = xml_find_first(., "Journal/Volume") %>% xml_text(trim = TRUE),
        ArticleIdList = xml_find_all(., "ArticleIdList/ArticleId") %>%
          xml_text(trim = TRUE) %>%
          paste(collapse = ", "),
        Issue = xml_find_first(., "Journal/Issue") %>% xml_text(trim = TRUE),
        Year = xml_find_first(., "PubDate/Year") %>% xml_text(trim = TRUE),
        ArticleTitle = xml_find_first(., "ArticleTitle") %>% xml_text(trim = TRUE),
        FirstAuthorFirstName = xml_find_first(., "AuthorList/Author[1]/FirstName") %>% xml_text(trim = TRUE),
        FirstAuthorLastName = xml_find_first(., "AuthorList/Author[1]/LastName") %>% xml_text(trim = TRUE),
        Abstract = xml_find_first(., "Abstract") %>% xml_text(trim = TRUE),
        PMID = xml_find_first(., "ArticleIdList/ArticleId[@IdType='pubmed']") %>% xml_text(trim = TRUE),
        DOI = xml_find_first(., "ArticleIdList/ArticleId[@IdType='doi']") %>% xml_text(trim = TRUE),
      )
    })

  # write df to csv
  # Write dataframe to csv
  # we're also replacing spaces with underscores for the file names
  fname <- sprintf("./data/Results_%s_%s.csv", i, association)
  write.csv(results_df, fname, row.names = FALSE)
  cat("Saved Dataframe to", fname, '\n')

  # put a `break` here if you just want to try this on the first journal. The whole thing takes a while
  if (i == 3) {
    break
  }

}
