library(tidyverse)
library(rvest)
library(dplyr)

scrape_standard_of_care <- function(url_number, year) {
  data <- read_html(paste0("https://diabetesjournals.org/care/issue/", url_number, "/Supplement_1")) |>
    html_nodes(".item-title a , .al-cite-description a") |>
    html_text()
  title <- data[seq(1, length(data), 2)]
  doi <- data[seq(2, length(data), 2)]
  df <- data.frame(Title = title, DOI = doi, Year = year)
  standardsofcare <<- rbind(standardsofcare, df)
}

standardsofcare <- data.frame(Title = character(), DOI = character(), Year = character())

standardsofcare <- standardsofcare |>
  rbind(scrape_standard_of_care("46", "2023")) |>
  rbind(scrape_standard_of_care("45", "2022")) |>
  rbind(scrape_standard_of_care("44", "2021")) |>
  rbind(scrape_standard_of_care("43", "2020")) |>
  rbind(scrape_standard_of_care("42", "2019")) |>
  rbind(scrape_standard_of_care("41", "2018"))

View(standardsofcare)

write_csv(standardsofcare, "/coi/data/ada_dois.csv")
