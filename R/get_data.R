#' Get NPI data
#'
#' @param first_name
#' @param last_name
#'
#' @return
#' @export
#'
#' @examples
get_npi_data <- function(first_name, last_name, initial, middle_name) {
  encoded_first_name <- first_name |>
    clean_name() |>
    URLencode()
  encoded_last_name <- last_name |>
    clean_name() |>
    URLencode()

  api_url <- glue::glue("https://npiregistry.cms.hhs.gov/api/?first_name={encoded_first_name}&use_first_name_alias=True&last_name={encoded_last_name}&limit=200&version=2.1")

  response <- httr::GET(api_url)

  if (httr::status_code(response) == 200) {
    data <- httr::content(response, "text") |>
      jsonlite::fromJSON(flatten = TRUE)

    data_2 <- data$results

    if ("basic.middle_name" %in% colnames(data_2)) {

      # if multiple hits, filter by middle name
      if (length(data_2) > 1 && !is.na(middle_name)) {
        filtered_data <- data_2 |>
          dplyr::filter(str_detect(clean_name(basic.middle_name), clean_name(middle_name)))
        if (nrow(filtered_data) > 0) {
          data_2 <- filtered_data
        }
      }

      # if still multiple hits, filter by initials
      if (length(data_2) > 1 && !is.na(initial)) {
        filtered_data <- data_2 |>
          dplyr::filter(str_detect(str_sub(clean_name(basic.middle_name), 1, 1), str_sub(initial, 1, 1)))
        if (nrow(filtered_data) > 0) {
          data_2 <- filtered_data
        }
      }
    }
    return(data_2)

  } else {
    message("API request failed with status code: ", httr::status_code(response))
    return(NULL)
  }
}

get_concatenated_numbers <- function(matched) {
  matched %>%
    pull(npi) %>%
    map_chr(~ {
      if (length(.x) == 0) {
        NA_character_
      } else if (is.data.frame(.x)) {
        toString(.x$number)
      } else {
        NA_character_
      }
    })
}
