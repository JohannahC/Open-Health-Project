#' Get guideline metadata from Crossref
#' prereq: check crossref API user guide first & follow polite use rules
#' @param dataset dataset of guideines that includes a column for doi named "doi"
#' @return dataset of author names for each guideline doi in the argument dataset
#' @export
#'
#' @examples
get_guideline_metadata <- function(dataset) {

  # isolate the doi column as a list
  doi_list <- dataset$doi

  # pass the list of dois to cr_works()
  my_dois_works <- rcrossref::cr_works(dois = doi_list) |>
    pluck("data")

  # unnest the author column into separate rows
  my_dois_works <- my_dois_works |>
    mutate(author = map(author, ~ as.data.frame(.))) |>
    unnest(author)

  return(my_dois_works)
}


#' Clean & select relevant guideline metadata
#' prereq: check crossref API user guide first & follow polite use rules
#' @param my_dois_works or its renamed dataframe; unnested dataset from get_guidelines_metadata() function
#' @return dataset of author names and the relevant other information on each author
#' @export
#'
#' @examples
select_metadata <- function(dataset) {

  # Define the list of column names to select
  desired_columns <- c("doi", "title", "container.title", "issued", "given", "family",
                       "suffix", "affiliation.name", "affiliation1.name", "affiliation2.name",
                       "affiliation3.name", "ORCID", "link", "url")

  # Check which columns exist in the dataset
  existing_columns <- intersect(desired_columns, colnames(dataset))

  # Select only the columns that exist in the dataset
  metadata_clean <- dataset |>
    select(all_of(existing_columns))

  # Check if "link" column exists before unnesting
  if ("link" %in% existing_columns) {
    # Unnest the link variable and only extract the URL as link_url
    metadata_clean <- metadata_clean |>
      mutate(link_url = map_chr(link, ~pluck(., "URL")[1])) |>
      select(-link)
  }

  # Print head to check
  print(head(metadata_clean))

  return(metadata_clean)
}
