#' Get Provider Payments
#'
#' @param npi A character string of the national provider identifier
#'
#' @return a data frame with the payment records associated with the npi number
#' @export
#'
#' @examples
#' get_provider_payments("1234567893")

setwd("/Users/johannahcramer/Documents/GitHub/coi")
#test first, turn to function after

library(tidyverse)

# Read in relevant data (payments, npis)

#payments data (research 2020)
options(timeout=300)
url <- "https://download.cms.gov/openpayments/PGYR20_P012023/OP_DTL_RSRCH_PGYR2020_P01202023.csv"
research_2020 <- read.csv(url(url), header = TRUE)

#verified npi data
npis <- read_rds("/Users/johannahcramer/Documents/GitHub/coi/src/verified_sample.rds")



#read in filtered 2021 research payments
#research_2021 <- read.csv("/Users/johannahcramer/Documents/GitHub/coi/data-raw/2021_openpayments.csv")
#View(research_2021)

"covered_recipient_npi"



  #2021 general payments
#  api_url_2021 <- "https://openpaymentsdata.cms.gov/api/1/datastore/query/0380bbeb-aea1-58b6-b708-829f92a48202/{index}"
 # response_2021 <- httr::GET(api_url_2021)

  #View(response_2021)

#}


