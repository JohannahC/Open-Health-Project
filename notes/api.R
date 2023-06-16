library(httr)
library(jsonlite)
library(glue)

data <- read_csv("src/screened_authors_sample.csv")

matched <- data |>
  head(10) |>
  select(given, family) |>
  rowwise() |>
  mutate(npi = get_npi_data(clean_name(given), clean_name(family)) |> list()) |>
  ungroup()

write_rds(matched, "data/matched.rds")
