library(tidyverse)

download.file("https://download.cms.gov/nppes/NPPES_Data_Dissemination_May_2023.zip", "data-raw/npi.zip")

npi <- read_csv(
  unz("data-raw/npi.zip",
      "npidata_pfile_20050523-20230507.csv"
  ), n_max = 5000
)

npi <- npi |>
  janitor::clean_names()

npi |>
  colnames()
# what is useful here?
