#' clean verified npis
#'
#' @param dataset of verified npis (in our case, "verified_sample.rds")
#' @return vector list of unique npis - missings & duplicates removed for passing through get_profile_ids
#' @export
#' @examples
#' 

clean_verified_npis <- function(dataset) {
  dataset <- dataset[!is.na(dataset$number), ]  # Remove rows with NA in 'number' column
  dataset <- dataset[!duplicated(dataset$number), ]  # Remove duplicate rows based on 'number' column
  return(dataset)
}

#' clean physician supplement
#'
#' @param dataset - Covered Recipient Supplement File for All Program Years
#' available at: https://www.cms.gov/OpenPayments/Data/Dataset-Downloads
#' @return cleaned dataset
#' @export
#' @examples
#' 

clean_physician_supplement <- function(dataset) {
  # Convert NPI column to character
  dataset$Covered_Recipient_NPI <- as.character(dataset$Covered_Recipient_NPI)
  # Filter non-missing NPI numbers
  dataset <- dataset[!is.na(dataset$Covered_Recipient_NPI), ]
  return(dataset)
}


#' get profile ids
#'
#' @param dataset1 (cleaned physician supplement) & dataset2 (cleaned verified npis)
#' @return filtered 'cleaned physician supplement' on npis in 'clean_verified_npis'
#' @export
#' @examples
#' 

get_profile_ids <- function(dataset1, dataset2) {
  profile_ids <- dataset1[dataset1$Covered_Recipient_NPI %in% dataset2$number, ]
  return(profiled_ids)
}
