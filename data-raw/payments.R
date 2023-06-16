library(tidyverse)

download.file("https://download.cms.gov/openpayments/PGYR20_P012023.ZIP",
              "data-raw/payments.zip",
              options(timeout = 5*60))

#-- Find the important variables

payments_wide <- read_csv(
  unz("data-raw/payments.zip",
      "OP_DTL_GNRL_PGYR2020_P01202023.csv"
  ),
  n_max = 10
)

payments |>
  colnames()
# what is useful here?

# my guess at what is most useful
payments_wide <- payments_wide |>
  select(Covered_Recipient_NPI,
         Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID,
         Date_of_Payment,
         Total_Amount_of_Payment_USDollars
         )

columns_to_read <- payments_wide |>
  colnames()

#--- Read only the important variables

payments_narrow <- read_csv(
  unz("data-raw/payments.zip",
      "OP_DTL_GNRL_PGYR2020_P01202023.csv"
  ),
  col_select = any_of(columns_to_read)
)

payments_narrow <- payments_narrow |>
  janitor::clean_names() |>
  mutate(date_of_payment = lubridate::mdy(date_of_payment))

payments <- payments_narrow
