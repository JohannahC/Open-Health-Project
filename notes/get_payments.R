# isolating profile ids and then using them to find relevant payments in 2021 general, research and ownership payments

# Phase 1 - prepare base data (npis and profile ids)

# 1. run clean_verified_npis()
# 2. run clean_physician_supplement()
# 3. run get_profile_ids()

# Phase 2 - use profile IDs to gather all payment records (general, research, ownership) for each year

# 4. run get_payment_records() -- repeat for each year 
# 5. explore data
# 6. bind datasets by year? write csv? repeat for all years?

library(dplyr)
library(tidyverse)

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

# Phase 2

# load 2021 payment data
general_2021 <- read.csv("data-raw/OP_DTL_GNRL_PGYR2021_P01202023.csv")
research_2021 <- read.csv("/Users/johannahcramer/Documents/GitHub/coi/data-raw/OP_DTL_RSRCH_PGYR2021_P01202023.csv")
ownership_2021 <- read.csv("/Users/johannahcramer/Documents/GitHub/coi/data-raw/OP_DTL_OWNRSHP_PGYR2021_P01202023.csv")

# 4. 
general_payments_2021 <- get_payment_records(general_2021,profiles)
research_payments_2021 <- get_payment_records(research_2021, profiles)
ownership_payments_2021 <- get_payment_records(ownership_2021, profiles)

View(general_payments_2021)
View(research_payments_2021)
View(ownership_payments_2021)

# add rows to each to identify which payment type it is, then bind all together for 1 big 2021 dataset

# 5 Count the number of unique IDs
num_unique_ids_gnrl_21 <- length(unique(general_payments_2021$Covered_Recipient_Profile_ID))
num_unique_ids_rsrch_21 <- length(unique(research_payments_2021$Covered_Recipient_Profile_ID))
num_unique_ids_ownrshp_21 <- length(unique(ownership_payments_2021$Covered_Recipient_Profile_ID))

print(num_unique_ids_gnrl_21)
print(num_unique_ids_rsrch_21)
print(num_unique_ids_ownrshp_21)

# explore frequency of records per person
table(general_payments_2021$Covered_Recipient_Profile_ID)
table(research_payments_2021$Covered_Recipient_Profile_ID)
table(ownership_payments_2021$Covered_Recipient_Profile_ID)


# Load 2020 payment data & repeat step 4
general_2020 <- read.csv("data-raw/OP_DTL_GNRL_PGYR2020_P01202023.csv")
research_2020 <- read.csv("data-raw/OP_DTL_RSRCH_PGYR2020_P01202023.csv")
ownership_2020 <- read.csv("data-raw/OP_DTL_OWNRSHP_PGYR2020_P01202023.csv")

# 4. 
general_payments_2020 <- get_payment_records(general_2020,profiles)
research_payments_2020 <- get_payment_records(research_2020, profiles)
ownership_payments_2020 <- get_payment_records(ownership_2020, profiles)

View(general_payments_2020)
View(research_payments_2020)
View(ownership_payments_2020)

# add rows to each to identify which payment type it is, then bind all together for 1 big 2021 dataset

# 5 Count the number of unique IDs
num_unique_ids_gnrl_20 <- length(unique(general_payments_2020$Covered_Recipient_Profile_ID))
num_unique_ids_rsrch <- length(unique(research_payments_2020$Covered_Recipient_Profile_ID))
num_unique_ids_ownrshp <- length(unique(ownership_payments_2020$Covered_Recipient_Profile_ID))

print(num_unique_ids_gnrl)
print(num_unique_ids_rsrch)
print(num_unique_ids_ownrshp)

# explore frequency of records per person
table(general_payments_2021$Covered_Recipient_Profile_ID)
table(research_payments_2021$Covered_Recipient_Profile_ID)
table(ownership_payments_2021$Covered_Recipient_Profile_ID)



