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

  # rename the final dataframe and print the data frame with select columns
  authors_clean <- my_dois_works |>
    select(doi, title, container.title, issued, given, family, suffix, affiliation.name,
           affiliation1.name,affiliation2.name, affiliation3.name,ORCID, link, url)

  #unnest the link variable and only extrac the URL as link_url
  authors_clean <- authors_clean |>
    mutate(link_url = map_chr(link, ~pluck(., "URL")[1])) |>
    select(-link)

  # print head to check
  print(head(authors_clean))

  return(dataset)
}


