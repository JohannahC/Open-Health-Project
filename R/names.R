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
    remove_initials() |>
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
  names %>%
    str_replace_all("\\b[A-Z]\\.", "") %>%  # Remove initials at the start of words
    str_replace_all("\\b\\s[A-Z]\\.", "") %>%  # Remove initials after a space
    str_trim()  # Remove leading/trailing whitespace
}
