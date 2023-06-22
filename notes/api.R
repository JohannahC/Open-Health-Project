library(tidyverse)
library(httr)
library(jsonlite)
library(glue)

data <- read_rds("src/verified_sample.rds")

matched <- data |>
  normalise_middle_names() |>
  # select(given, family, initial, middle_name)
  # head(12) |>
  rowwise() |>
  mutate(npi = if_else(npi_eligible,
                       get_npi_data(given, family, initial, middle_name) |> list(),
                       NA)) |>
  # mutate(npi = get_npi_data(given, family, initial, middle_name) |> list()) |>
  ungroup()

matched <- matched |>
  mutate(npi_number = get_concatenated_numbers(matched)) |>
  select(-npi) |>
  select(npi_number, number, given, family, everything())

calculate_score <- function(dataset) {
  dataset |>
    mutate(score = case_when(
      is.na(npi_number) & is.na(number) ~ 1,
      is.na(npi_number) & !is.na(number) ~ 0,
      !is.na(npi_number) & is.na(number) ~ 0,
      TRUE ~ str_detect(npi_number, number) / (str_count(npi_number, ",") + 1)
    ))
}

matched <- matched %>%
  calculate_score() |>
  select(score, everything())

matched_score = matched |>
  summarise(mean(score), sum(score))

unmatched <- matched |>
  filter(!score)

overmatched <- matched |>
  filter(0 < score  & score < 1)

matched_dont_know <- matched |>
  filter(npi_eligible) |>
  filter(!is.na(number)) |>
  filter(score == 0)
