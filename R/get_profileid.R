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

  dataset <- dataset |>
    filter(!is.na(number)) |> # Remove rows with NA in 'number' column
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
  dataset <- dataset |> filter(!is.na(Covered_Recipient_NPI))

  return(dataset)
}


#' get profile ids
#'
#' @param dataset1 (cleaned physician supplement - returned by clean_physician_supplement())
#' @param dataset2 (cleaned verified npis - returned by clean_verified_npis())
#' @return subset of unique profile ids in dataset1 where npis in dataset1 & dataset2 match
#' @export
#' @examples
#'
get_profile_ids <- function(dataset1, dataset2) {
  profile_ids <- dataset1[dataset1$Covered_Recipient_NPI %in% dataset2$number, ]
  return(profile_ids)
}

#' get payment data
#'
#' @param dataset1 (OP payments file of choice (general, research, ownership) for a given year)
#' @param dataset2 (dataset returned by get_profile_ids())
#' @return df of all payment records from dataset1 associated with a profile ID in dataset2
#' @export
#' @examples
#'
get_payment_records <- function(dataset1, dataset2) {
  unique_record_ids <- unique(dataset2$Covered_Recipient_Profile_ID) # to ensure there are no duplicate profile IDs in dataset2
  matching_ids <- dataset1$Covered_Recipient_Profile_ID %in% unique_record_ids # identify when there's a match between the profile IDs between the 2 datasets
  payments <- dataset1[matching_ids, ] # for matches, filter all the payment records from dataset1
  return(payments) # includes all payment records associated with each profile ID in dataset2
}



