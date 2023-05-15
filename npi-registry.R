library(tidyverse)

url <- "https://download.cms.gov/nppes/NPPES_Data_Dissemination_May_2023.zip"
download.file(url, "data-raw/npi.zip")

npi <- read_csv(
  unz("data-raw/npi.zip",
      "npidata_pfile_20050523-20230507.csv"
  )
)

npi <- npi |>
  janitor::clean_names()

npi |>
  colnames()
# what is useful here?
