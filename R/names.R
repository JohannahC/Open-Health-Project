#' Clean name
#'
#' @param name
#'
#' @return
#' @export
#'
#' @examples
clean_name <- function(name) {
  name |>
    # remove full stops
    stringr::str_remove_all("\\.") |>
    # remove accents
    stringi::stri_trans_general("Latin-ASCII") |>
    tolower()
}

#' Remove initials
#'
#' @param names
#'
#' @return
#' @export
#'
#' @examples
remove_initials <- function(names) {
  names |>
    str_replace_all("\\b[A-Z]\\.", "") |>  # Remove initials at the start of words
    str_replace_all("\\b\\s[A-Z]\\.", "") |>  # Remove initials after a space
    str_trim()  # Remove leading/trailing whitespace
}

normalise_middle_names <- function(dataset) {
  dataset |>
    add_middle_names() |>
    remove_excess_names()
}

add_middle_names <- function(dataset) {
  dataset |>
    mutate(initial = str_extract(given, "\\b\\w(?=\\W*$)") |> clean_name(),
           middle_name = str_extract(family, "\\w[-\\w]*(?=\\s\\w+$)") |> clean_name())
}

remove_excess_names <- function(dataset) {
  dataset |>
    mutate(
      given = str_remove(given, "\\b\\w\\.?(?=\\W*$)") |>
        str_trim(side = "right"),
      family = str_remove(family, "\\w[-\\w]*(?=\\s\\w+$)") |>
        str_trim(side = "left")
    )
}
