# Document: executing protocol step 4 - linking payment data
# date last updated: 10 July 2023
# last edited by: Johannah
# --------------------------------------

# Protocol:

# Phase 1 - prepare base data (npis and profile ids)

# 1. run clean_verified_npis()
# 2. run clean_physician_supplement()
# 3. run get_profile_ids()

# Phase 2 - use profile IDs to gather all payment records (general, research, ownership) for each year

# 4. run get_payment_records()
# 5. run add_payment_type_column() to add the type of payment for each sub-file
# 6. run bind_subfiles() to bind the 3 subfiles together for a given year
# **repeat steps 4-6 for each remaining year

# Phase 3 - combine all data from all years into 1 df
# 8. run bind_annual_data() to bind annual files together to create 1 file for all years

library(dplyr)
library(tidyverse)
library(devtools)
library(usethis)

devtools::load_all()

# ----------------------------
# Phase 1

# Load necessary base data (only once)
verified <- read_rds("/Users/johannahcramer/Documents/GitHub/coi/src/verified_sample.rds")
supplement <- read.csv("/Users/johannahcramer/Documents/GitHub/coi/data-raw/OP_CVRD_RCPNT_PRFL_SPLMTL_P01202023.csv")

# Prep base data

# 1.
verified_clean <- clean_verified_npis(verified)

# 2.
supplement_clean <- clean_physician_supplement(supplement)

# 3.
profiles <- get_profile_ids(supplement_clean, verified_clean)

# -----------------------------


# Phase 2

# ------------ 2022 -----------------

# load 2022 payment data and complete steps 4-6
general_2022 <- read.csv("data-raw/PGYR22_P063023/OP_DTL_GNRL_PGYR2022_P06302023.csv")
research_2022 <- read.csv("data-raw/PGYR22_P063023/OP_DTL_RSRCH_PGYR2022_P06302023.csv")
ownership_2022 <- read.csv("data-raw/PGYR22_P063023/OP_DTL_OWNRSHP_PGYR2022_P06302023.csv")

# 4. get payment records
general_payments_2022 <- get_payment_records(general_2022,profiles)
research_payments_2022 <- get_payment_records(research_2022, profiles)
ownership_payments_2022 <- get_payment_records(ownership_2022, profiles)

# 5. add column for payment type
general_payments_2022 <- add_payment_type_column(general_payments_2022,"general")
research_payments_2022 <- add_payment_type_column(research_payments_2022,"research")
ownership_payments_2022 <- add_payment_type_column(ownership_payments_2022,"ownership")

View(general_payments_2022)
View(research_payments_2022)

# 6. # Clean, Bind, Save (3 subfiles combined into 1)

# Clean
research_payments_2022 <- research_payments_2022 |>
  mutate(Associated_Device_or_Medical_Supply_PDI_5 = as.character(Associated_Device_or_Medical_Supply_PDI_5))

ownership_payments_2022<- ownership_payments_2022 |>
  mutate(Recipient_Postal_Code = as.character(Recipient_Postal_Code))

# Bind & Save
main_2022 <- bind_rows(general_payments_2022, research_payments_2022, ownership_payments_2022)
write_csv(main_2022, file.path("data", "main_2022.csv"))

# before proceeding to 2021 run below:
#rm(general_2022, research_2022, ownership_2022, main_2022, general_payments_2022, research_payments_2022, ownership_payments_2022)

# ------------ 2021 -----------------

# load 2021 payment data & repeat steps 4-6
general_2021 <- read.csv("data-raw/PGYR21_P063023/OP_DTL_GNRL_PGYR2021_P06302023.csv")
research_2021 <- read.csv("data-raw/PGYR21_P063023/OP_DTL_RSRCH_PGYR2021_P06302023.csv")
ownership_2021 <- read.csv("data-raw/PGYR21_P063023/OP_DTL_OWNRSHP_PGYR2021_P06302023.csv")

# 4. get payment records
general_payments_2021 <- get_payment_records(general_2021,profiles)
research_payments_2021 <- get_payment_records(research_2021, profiles)
ownership_payments_2021 <- get_payment_records(ownership_2021, profiles)

# 5. add column for payment type
general_payments_2021 <- add_payment_type_column(general_payments_2021,"general")
research_payments_2021 <- add_payment_type_column(research_payments_2021,"research")
ownership_payments_2021 <- add_payment_type_column(ownership_payments_2021,"ownership")

# 6. clean then bind three sub-files together

# Convert columns to a common data type, write csv to 'data'

# Clean
ownership_payments_2021 <- ownership_payments_2021 |>
  mutate(Recipient_Province = as.character(Recipient_Province),
         Recipient_Postal_Code = as.character(Recipient_Postal_Code))

# Bind
main_2021 <- bind_rows(general_payments_2021, research_payments_2021, ownership_payments_2021)
write_csv(main_2021, file.path("data", "main_2021.csv"))

# before proceeding to 2020 run below:
#rm(general_2021, research_2021, ownership_2021, main_2021, general_payments_2021, research_payments_2021, ownership_payments_2021)

# ------------ 2020 -----------------

# Load 2020 payment data & repeat steps 4, 5 & 6
general_2020 <- read.csv("data-raw/PGYR20_P063023/OP_DTL_GNRL_PGYR2020_P06302023.csv")
research_2020 <- read.csv("data-raw/PGYR20_P063023/OP_DTL_RSRCH_PGYR2020_P06302023.csv")
ownership_2020 <- read.csv("data-raw/PGYR20_P063023/OP_DTL_OWNRSHP_PGYR2020_P06302023.csv")

# 4.
general_payments_2020 <- get_payment_records(general_2020,profiles)
research_payments_2020 <- get_payment_records(research_2020, profiles)
ownership_payments_2020 <- get_payment_records(ownership_2020, profiles)

# 5. add column for payment type
general_payments_2020 <- add_payment_type_column(general_payments_2020,"general")
research_payments_2020 <- add_payment_type_column(research_payments_2020,"research")
ownership_payments_2020 <- add_payment_type_column(ownership_payments_2020,"ownership")

# 6. clean then bind three sub-files together

# Convert columns to a common data type, write csv to 'data'
ownership_payments_2020 <- ownership_payments_2020 |>
  mutate(Recipient_Province = as.character(Recipient_Province),
         Recipient_Postal_Code = as.character(Recipient_Postal_Code))

# Bind & write
main_2020 <- bind_rows(general_payments_2020, research_payments_2020, ownership_payments_2020)
write_csv(main_2020, file.path("data", "main_2020.csv"))

# before proceeding to 2019 run below:
#rm(general_2020, research_2020, ownership_2020, main_2020, general_payments_2020, research_payments_2020, ownership_payments_2020)

# -------------------- 2019 -------------------------

# Load 2019 payment data & repeat steps 4, 5 & 6
general_2019 <- read.csv("data-raw/PGYR19_P063023/OP_DTL_GNRL_PGYR2019_P06302023.csv")
research_2019 <- read.csv("data-raw/PGYR19_P063023/OP_DTL_RSRCH_PGYR2019_P06302023.csv")
ownership_2019 <- read.csv("data-raw/PGYR19_P063023/OP_DTL_OWNRSHP_PGYR2019_P06302023.csv")

# 4.
general_payments_2019 <- get_payment_records(general_2019,profiles)
research_payments_2019 <- get_payment_records(research_2019, profiles)
ownership_payments_2019 <- get_payment_records(ownership_2019, profiles)

# 5. add column for payment type
general_payments_2019 <- add_payment_type_column(general_payments_2019,"general")
research_payments_2019 <- add_payment_type_column(research_payments_2019,"research")
ownership_payments_2019 <- add_payment_type_column(ownership_payments_2019,"ownership")

# 6. clean then bind three sub-files together

# Bind & write
main_2019<- bind_rows(general_payments_2019, research_payments_2019, ownership_payments_2019)
write_csv(main_2019, file.path("data", "main_2019.csv"))

# before proceeding to 2018 run below:
#rm(general_2019, research_2019, ownership_2019, main_2019, general_payments_2019, research_payments_2019, ownership_payments_2019)

# ------------------2018-----------------------

# Load 2018 payment data & repeat steps 4, 5 & 6
general_2018 <- read.csv("data-raw/PGYR18_P063023/OP_DTL_GNRL_PGYR2018_P06302023.csv")
research_2018 <- read.csv("data-raw/PGYR18_P063023/OP_DTL_RSRCH_PGYR2018_P06302023.csv")
ownership_2018 <- read.csv("data-raw/PGYR18_P063023/OP_DTL_OWNRSHP_PGYR2018_P06302023.csv")

# 4.
general_payments_2018 <- get_payment_records(general_2018,profiles)
research_payments_2018 <- get_payment_records(research_2018, profiles)
ownership_payments_2018 <- get_payment_records(ownership_2018, profiles)

# 5. add column for payment type
general_payments_2018 <- add_payment_type_column(general_payments_2018,"general")
research_payments_2018 <- add_payment_type_column(research_payments_2018,"research")
ownership_payments_2018 <- add_payment_type_column(ownership_payments_2018,"ownership")

# 6. clean then bind three sub-files together

# Bind & write
main_2018<- bind_rows(general_payments_2018, research_payments_2018, ownership_payments_2018)
write_csv(main_2018, file.path("data", "main_2018.csv"))

# before proceeding to 2017 run below:
#rm(general_2018, research_2018, ownership_2018, main_2018, general_payments_2018, research_payments_2018, ownership_payments_2018)

# ------------------2017-----------------------

# Load 2017 payment data & repeat steps 4, 5 & 6
general_2017 <- read.csv("data-raw/PGYR17_P063023/OP_DTL_GNRL_PGYR2017_P06302023.csv")
research_2017 <- read.csv("data-raw/PGYR17_P063023/OP_DTL_RSRCH_PGYR2017_P06302023.csv")
ownership_2017 <- read.csv("data-raw/PGYR17_P063023/OP_DTL_OWNRSHP_PGYR2017_P06302023.csv")

# 4.
general_payments_2017 <- get_payment_records(general_2017,profiles)
research_payments_2017 <- get_payment_records(research_2017, profiles)
ownership_payments_2017 <- get_payment_records(ownership_2017, profiles)

# 5. add column for payment type
general_payments_2017 <- add_payment_type_column(general_payments_2017,"general")
research_payments_2017 <- add_payment_type_column(research_payments_2017,"research")
ownership_payments_2017 <- add_payment_type_column(ownership_payments_2017,"ownership")

# 6. clean then bind three sub-files together

# Bind & write
main_2017<- bind_rows(general_payments_2017, research_payments_2017, ownership_payments_2017)
write_csv(main_2017, file.path("data", "main_2017.csv"))

# before proceeding to 2016 run below:
#rm(general_2017, research_2017, ownership_2017, main_2017, general_payments_2017, research_payments_2017, ownership_payments_2017)

# ------------- 2016 -----------------------

# Load 2016 payment data & repeat steps 4, 5 & 6
general_2016 <- read.csv("data-raw/PGYR16_P063023/OP_DTL_GNRL_PGYR2016_P06302023.csv")
research_2016 <- read.csv("data-raw/PGYR16_P063023/OP_DTL_RSRCH_PGYR2016_P06302023.csv")
ownership_2016 <- read.csv("data-raw/PGYR16_P063023/OP_DTL_OWNRSHP_PGYR2016_P06302023.csv")

# 4.
general_payments_2016 <- get_payment_records(general_2016,profiles)
research_payments_2016 <- get_payment_records(research_2016, profiles)
ownership_payments_2016 <- get_payment_records(ownership_2016, profiles)

# 5. add column for payment type
general_payments_2016 <- add_payment_type_column(general_payments_2016,"general")
research_payments_2016 <- add_payment_type_column(research_payments_2016,"research")
ownership_payments_2016 <- add_payment_type_column(ownership_payments_2016,"ownership")

# 6. clean then bind three sub-files together

# Bind & write
main_2016<- bind_rows(general_payments_2016, research_payments_2016, ownership_payments_2016)
write_csv(main_2016, file.path("data", "main_2016.csv"))

# before proceeding to 2015 run below:
#rm(general_2016, research_2016, ownership_2016, main_2016, general_payments_2016, research_payments_2016, ownership_payments_2016)

# ------------- 2015 -----------------------

# Load 2015 payment data & repeat steps 4, 5 & 6
general_2015 <- read.csv("data-raw/PGYR15_P012023/OP_DTL_GNRL_PGYR2015_P01202023.csv")
research_2015 <- read.csv("data-raw/PGYR15_P012023/OP_DTL_RSRCH_PGYR2015_P01202023.csv")
ownership_2015 <- read.csv("data-raw/PGYR15_P012023/OP_DTL_OWNRSHP_PGYR2015_P01202023.csv")

# 4.
general_payments_2015 <- get_payment_records(general_2015,profiles)
research_payments_2015 <- get_payment_records(research_2015, profiles)
ownership_payments_2015 <- get_payment_records(ownership_2015, profiles)

# 5. add column for payment type
general_payments_2015 <- add_payment_type_column(general_payments_2015,"general")
research_payments_2015 <- add_payment_type_column(research_payments_2015,"research")
ownership_payments_2015 <- add_payment_type_column(ownership_payments_2015,"ownership")

# 6. clean then bind three sub-files together

# Bind & write
main_2015<- bind_rows(general_payments_2015, research_payments_2015, ownership_payments_2015)
write_csv(main_2015, file.path("data", "main_2015.csv"))

# before proceeding to 2014 run below:
rm(general_2015, research_2015, ownership_2015, main_2015, general_payments_2015, research_payments_2015, ownership_payments_2015)

# ------------- 2014 -----------------------

# Load 2014 payment data & repeat steps 4, 5 & 6
general_2014 <- read.csv("data-raw/PGYR15_P012023/OP_DTL_GNRL_PGYR2015_P01202023.csv")
research_2014 <- read.csv("data-raw/PGYR15_P012023/OP_DTL_RSRCH_PGYR2015_P01202023.csv")
ownership_2014 <- read.csv("data-raw/PGYR15_P012023/OP_DTL_OWNRSHP_PGYR2015_P01202023.csv")

# 4.
general_payments_2014 <- get_payment_records(general_2014,profiles)
research_payments_2014 <- get_payment_records(research_2014, profiles)
ownership_payments_2014 <- get_payment_records(ownership_2014, profiles)

# 5. add column for payment type
general_payments_2014 <- add_payment_type_column(general_payments_2014,"general")
research_payments_2014 <- add_payment_type_column(research_payments_2014,"research")
ownership_payments_2014 <- add_payment_type_column(ownership_payments_2014,"ownership")

# 6. clean then bind three sub-files together

# Bind & write
main_2014 <- bind_rows(general_payments_2014, research_payments_2014, ownership_payments_2014)
write_csv(main_2014, file.path("data", "main_2014.csv"))

# before proceeding to 2013 run below:
rm(general_2014, research_2014, ownership_2014, main_2014, general_payments_2014, research_payments_2014, ownership_payments_2014)

# ------------------ 2013---------------------

# this file is a lot smaller and I'm a little hesitant about the quality of data the first few years (including 2014). Opting to pass on this for now.
