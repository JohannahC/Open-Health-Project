#' Get NPI data
#'
#' @param first_name
#' @param last_name
#'
#' @return
#' @export
#'
#' @examples
get_npi_data <- function(first_name, last_name) {
  encoded_first_name <- URLencode(first_name)
  encoded_last_name <- URLencode(last_name)

  api_url <- glue::glue("https://npiregistry.cms.hhs.gov/api/?first_name={encoded_first_name}&use_first_name_alias=True&last_name={encoded_last_name}&limit=200&version=2.1")

  response <- httr::GET(api_url)

  if (httr::status_code(response) == 200) {
    data <- httr::content(response, "text") |>
      jsonlite::fromJSON(flatten = TRUE)

    return(data$results)

  } else {
    message("API request failed with status code: ", httr::status_code(response))
    return(NULL)
  }
}
