#DRAFT 1
#Using PubMed's API to extract guideline metadata
#Example: DIABETES

#install.packages('easyPubMed')
#install.packages('diplyr')
install.packages("tidyverse")
library(easyPubMed)
library(dplyr)

# List of unique professional medical associations (identified by UpToDate) that have published (solely or jointly) at least one US clinical practice guideline on diabetes
# create a vector of strings (association names):

medical_associations <- c("American Heart Association",
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
                          "Cystic Fibrosis Foundation")

print(medical_associations)
# Create an empty list to store results called "results"
results <- list()

# Loop over the medical associations
for (i in seq_along(medical_associations)) {

  # Construct the query string
  query <- paste0('("2013/01/01"[Date - Publication] : "2023/12/31"[Date - Publication]) AND ',
                  '("diabetes"[Title/Abstract]) AND ',
                  '(("Practice Guideline"[Publication Type]) OR "guideline"[Title/Abstract] OR "consensus"[Title/Abstract]) AND ',
                  '("', medical_associations[i], '")')

  print(query)


  # Get the IDs of the articles that match the query
  ids <- get_pubmed_ids(query)
  print(ids)


  # Fetch the article data
  articles <- fetch_pubmed_data(ids)

  print(articles)

  # Store the article data in the results list
  results[[medical_associations[i]]] <- articles
  break
}

# Now you can inspect the results
print(results)


# Create an empty data frame to store the results
results_df <- data.frame()

# Loop over the results list
for (i in seq_along(results)) {

  # Get the current data frame
  df <- results[[i]]

  # Add a new column for the medical association
  df$MedicalAssociation <- names(results)[i]

  # Append the data frame to the results data frame
  results_df <- rbind(results_df, df)
}

# Write the data frame to a CSV file
write.csv(results_df, "PubMed_data.csv", row.names = FALSE)








