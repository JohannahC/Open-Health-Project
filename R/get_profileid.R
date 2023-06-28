#' clean verified npis
#'
#' @param dataset where verified npis are stored in column "number" (ie. "verified_sample.rds")
#' @return cleaned version of the dataset with missings & duplicates removed for ease of use with get_profile_ids()
#' @examples
#' 

clean_verified_npis <- function(dataset) {
  if (!"number" %in% names(dataset)) {
    stop("The dataset does not have a 'number' column.")
  }
  
  dataset <- dataset %>%
    filter(!is.na(number)) %>%  # Remove rows with NA in 'number' column
    filter(!duplicated(number))  # Remove duplicate rows based on 'number' column
  
  return(dataset)
}

#' clean physician supplement
#'
#' @param dataset - Covered Recipient Supplement File for All Program Years
#' available at: https://www.cms.gov/OpenPayments/Data/Dataset-Downloads
#' @return cleaned version of this dataset - ie. filters out missing NPIs (~7k) & converts NPI to string
#' @export
#' @examples
#' 

clean_physician_supplement <- function(dataset) {
  # Check if the 'Covered_Recipient_NPI' column exists
  if (!"Covered_Recipient_NPI" %in% names(dataset)) {
    stop("The dataset does not have a 'Covered_Recipient_NPI' column.")
  }
  
  dataset$Covered_Recipient_NPI <- as.character(dataset$Covered_Recipient_NPI)
  
  # Use dplyr to filter out NA rows
  dataset <- dataset %>% filter(!is.na(Covered_Recipient_NPI))
  
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
  return(profile_ids)
} 