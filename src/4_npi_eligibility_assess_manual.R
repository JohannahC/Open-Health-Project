
# this script uses "authors_clean.csv" for a manual screening of npi eligibility.
# once complete - eligible authors will be run through "3_npi_api_call.R" so that we can be sure
# everyone we query should be in the database. Here we screen out the names of authors
# who are non-prescribers, to ensure that no other authors who share names with
# prescribers are queried in the API call of the NPI registry

# ie. in the case of [Susan Cheng, MD (our author, Canadian)] & [Susan Cheng, MD (non-author, US physician)]
# if we don't screen these now - we'll get a hit for our author, but it won't be the right person at all
# we'll have no idea later on what the scale of this error is - unless we screen out ineligible people (ie. non-US & non-prescribers) first.

library(httr)
library(tidyverse)
library(jsonlite)
library(dplyr)
library(stringr)

#test if the script is complete
#Press Cmd/Ctrl + Shift + F10 to restart RStudio.
#Press Cmd/Ctrl + Shift + S to rerun the current script.

# manually identifying and adding the npi number for each author in "authors_clean.csv"

# A little context:

# "npi_call_results_dirty.rds" has NPI numbers for all names in "authors_clean.csv" but is not a clean file itself (duplicate names, missing NPIs) (origin: "test_nppes_apicall.R")
# "authors_clean.csv" is a list of author names for each guideline in "ecri_doisubset.csv" (origin: "metadata.R")
# "metadata.R" is a script that calls the author metadata for authors in "ecri_doisubset.csv" using the CrossRef API
# "ecri_doisubset.csv" is the subset of guidelines in "ecri_all.csv" that had dois listed in the url to the guideline origin: ("ecri_doisubset_build.R")
# "ecri_doisubset_build.R" is the script that identified and pulled doi strings from the urls in "ecri_all.csv" and is therefore a subset of all the ECRI guidelines received from Lisa Haskell @ the ECRI Guidelines Trust


# read in data
authors_all <- read.csv("authors_clean.csv")


# Sort guidelines by year (newest at top)
# Extract the year from the "issued" column
authors_all$year <- str_extract(authors_all$issued, "^\\d{4}")

# arrange authors_all by year of publication and then by journal name (container.title)
# going for AHA journals first (like "Stroke" and "Circulation") because they list author credentials in their PDF versions
# (easy to screen)
authors_all <- authors_all %>%
  arrange(desc(year), .by_group = TRUE) %>%
  group_by(container.title)
View(authors_all)

#add eligibility-relevant columns
authors_all <- authors_all %>%
  mutate(npi_eligible = TRUE,
         non_physician_prescriber = FALSE,
         prescriber_credential = NA)

#rename first column "X" to rowid (this is different from nrow!!!)
authors_all <- rename(authors_all, rowid = "X")

#proceed manually by checking the publication for medical credential & listing:
#criteria here:

#1. identify if author has a prescribing credential (MD, DO, DDS, PA, NP, DNP, RN, LPN, APRN ). If yes but person is non-MD or non-DO, set non_physician_prescriber = TRUE
#2. check full disclosure table or internet to see if author is US-based (ie. US employer)
#3. if author has non-US employer, google them anyway to double check they have never worked/studied in the US. (Esp. canadian-affiliated authors)

#Rules:

#   if 1 & 2 = TRUE (prescriber, US) it is assumed author is in the NPI registry and "npi_eligible = TRUE"
#   if 1 = TRUE and 2 = FALSE but 3 = TRUE (ie. prescriber, non-US employer, previous US-prescriber employment/education), it is assumed author is in the NPI registry and "npi_eligible = TRUE"

# for authors on doi "10.1161/str.0000000000000436":
authors_all[authors_all$rowid %in% 713:723, "npi_eligible"] <- TRUE
authors_all[authors_all$rowid == 724, "npi_eligible"] <- FALSE
authors_all[authors_all$rowid == 725, c("npi_eligible", "non_physician_prescriber", "prescriber_credential")] <- list(TRUE, TRUE, "DNP")
authors_all[authors_all$rowid %in% 726:733, "npi_eligible"] <- TRUE
authors_all[authors_all$rowid %in% c(713:723, 726:733), "prescriber_credential"] <- "MD"

# date verified - don't alter unless re-verifying all
# authors_all[authors_all$rowid %in% c(713:733), "date_npi_eligibility_verified"] <- Sys.Date()

#for authors on doi "10.1161/cir.0000000000001063":
authors_all[authors_all$rowid %in% c(62, 67, 78, 82), "npi_eligible"] <- FALSE
authors_all[authors_all$rowid == 81, c("npi_eligible", "non_physician_prescriber", "prescriber_credential")] <- list(TRUE, TRUE, "PharmD")
authors_all[authors_all$rowid == 75, c("npi_eligible", "non_physician_prescriber", "prescriber_credential")] <- list(TRUE, TRUE, "RN")
authors_all[authors_all$rowid %in% c(58:74, 76:80, 82:83), "prescriber_credential"] <- "MD"

# date verified - don't alter unless re-verifying all
#authors_all[authors_all$rowid %in% c(58:83), "date_npi_eligibility_verified"] <- Sys.Date()

# for authors on doi: "10.1161/cir.0000000000001038"
authors_all[authors_all$rowid == 88, c("npi_eligible", "non_physician_prescriber")] <- list(FALSE, FALSE)
authors_all[authors_all$rowid == 89, c("npi_eligible", "non_physician_prescriber")] <- list(FALSE, FALSE)
authors_all[authors_all$rowid == 94, c("npi_eligible", "non_physician_prescriber")] <- list(FALSE, FALSE) #MD but in Toronto - no NPI
authors_all[authors_all$rowid == 98, c("npi_eligible", "non_physician_prescriber")] <- list(FALSE, FALSE)
authors_all[authors_all$rowid == 102, c("npi_eligible", "non_physician_prescriber")] <- list(FALSE, FALSE)
authors_all[authors_all$rowid %in% c(84:87, 90:97, 99:101, 103:107), "prescriber_credential"] <- "MD"

# date verified - don't alter unless re-verifying all
#authors_all[authors_all$rowid %in% c(84:107), "date_npi_eligibility_verified"] <- Sys.Date()

#for authors on doi: 10.1161/circoutcomes.122.008900
authors_all[authors_all$rowid == 464, c("npi_eligible", "non_physician_prescriber", "prescriber_credential")] <- list(TRUE, TRUE, "RRT")
authors_all[authors_all$rowid == 472, c("npi_eligible", "non_physician_prescriber")] <- list(FALSE, FALSE)
authors_all[authors_all$rowid == 482, c("npi_eligible", "non_physician_prescriber", "prescriber_credential")] <- list(TRUE, TRUE, "RN")
authors_all[authors_all$rowid == 486, c("npi_eligible", "non_physician_prescriber")] <- list(FALSE, FALSE)
authors_all[authors_all$rowid == 488, c("npi_eligible", "non_physician_prescriber", "prescriber_credential")] <- list(TRUE, TRUE, "RRT")
authors_all[authors_all$rowid == 457, c("prescriber_credential")] <- "DO"

#ineligible due to non-US status:
authors_all[authors_all$rowid == 448, c("npi_eligible", "non_physician_prescriber", "prescriber_credential", "non_us_country")] <- list(FALSE, FALSE, "MD", "CA")
authors_all[authors_all$rowid == 451, c("npi_eligible", "non_physician_prescriber", "prescriber_credential", "non_us_country")] <- list(FALSE, FALSE, "MD", "CA")
authors_all[authors_all$rowid == 453, c("npi_eligible", "non_physician_prescriber", "prescriber_credential", "non_us_country")] <- list(FALSE, FALSE, "MD", "CA")
authors_all[authors_all$rowid == 454, c("npi_eligible", "non_physician_prescriber", "prescriber_credential", "non_us_country")] <- list(FALSE, FALSE, "MD", "CA")
authors_all[authors_all$rowid == 456, c("npi_eligible", "non_physician_prescriber", "prescriber_credential", "non_us_country")] <- list(FALSE, FALSE, "MD", "CA")
authors_all[authors_all$rowid == 458, c("npi_eligible", "non_physician_prescriber", "prescriber_credential", "non_us_country")] <- list(FALSE, FALSE, "MD", "CA")
authors_all[authors_all$rowid == 459, c("npi_eligible", "non_physician_prescriber", "prescriber_credential", "non_us_country")] <- list(FALSE, FALSE, "MD", "CA")
authors_all[authors_all$rowid == 473, c("npi_eligible", "non_physician_prescriber", "prescriber_credential", "non_us_country")] <- list(FALSE, FALSE, "MD", "CA")

View(authors_all)
# date verified - don't alter unless re-verifying all
# authors_all[authors_all$rowid %in% c(445:492), "date_npi_eligibility_verified"] <- Sys.Date()

subset_authors <- authors_all[authors_all$rowid %in% 445:492, ]
print(subset_authors, n = 60)
View(subset_authors)

##### what I tried first - now moved below: ########

# In this script, I'm using all these files and the internet to manually verify and add an NPI number to each author name in "authors_clean"

#read in authors_clean
#authors_clean_npi <- read.csv("authors_clean.csv")
#View(authors_clean_npi)

#read in npi_call_results_dirty (its a .rds because it contains nested elements returned by the NPPES API call)
#npi_call_results_dirty_1 <- readRDS("npi_call_results_dirty.rds")
#View(npi_call_results_dirty_1)

#authors_clean_npi <- authors_clean_npi %>%
#  mutate(npi = NA,
#         npi_verified = NA,
#         affiliation_found = NA)

#manual additions:

# 1. First, create a subset of the names that only appear once in the dataset
# Create a new column with concatenated first and last names
# subset_dirty <- npi_call_results_dirty_1 %>%
#  mutate(full_name = paste(basic$first_name, basic$last_name, sep = " "))

# Subset the dataset to include only unique names
#unique_names <- subset_dirty %>%
#  group_by(full_name) %>%
#  filter(n() == 1)

# View the resulting subset
#View(unique_names)

# 2. Now, modify the authors_clean_npi_test dataframe to have the full names
#authors_clean_npi_test <- authors_clean_npi %>%
#  mutate(full_name = paste(str_extract(given, "^[^- ]+"), family, sep = " "))
#View(authors_clean_npi_test)

# Convert full_name columns to lowercase for case-insensitive matching
#unique_names$full_name <- stringr::str_to_lower(unique_names$full_name)
#authors_clean_npi_test$full_name <- stringr::str_to_lower(authors_clean_npi_test$full_name)
#View(unique_names)
#View(authors_clean_npi_test)

# Merge unique_names with authors_clean_npi_test based on the full_name columns
#authors_clean_npi_test <- authors_clean_npi_test %>%
#  left_join(unique_names, by = "full_name") %>%
#  mutate(npi = ifelse(is.na(npi), NA, number))

# View the resulting merged data
#View(authors_clean_npi_test)

# Count the number of rows where "number" is not missing
#count <- sum(!is.na(authors_clean_npi_test$number))
#count
#353 NPI numbers added: error rate is unclear
#already identified some errors "Christopher Granger" not correct - should be "Chris Granger" from unique_names - npi 1295818458

# Which guidelines have the least amount of missing NPI data?
#Arrange the dataset in descending order of the number of non-missing values in "number" column
#authors_clean_npi_test <- authors_clean_npi_test %>%
#  group_by(doi) %>%
#  arrange(desc(sum(!is.na(number))))
# View(authors_clean_npi_test)



# Add the npi to each author. NPI is found manually checking multiple resources - where possible, info that helps verify NPI accuracry is also listed here
# Guidelines for the prevention of stroke in women (17 authors): doi: 10.1161/01.str.0000442009.06663.48


#Cheryl Bushnell (aka Cheryl D. Bushnell)
#authors_all[1, "npi"] <- 1437231685
#authors_all[1, "npi_verified"] <- TRUE
#authors_all[1, "affiliation_found"] <- "Wake Forest University School of Medicine"
#authors_all[1, "faculty_page"] <- "https://school.wakehealth.edu/faculty/b/cheryl-d-bushnell"
#authors_all[1, "practitioner_page"] <- "https://www.wakehealth.edu/providers/b/cheryl-d-bushnell"
#authors_all[1, "contact1"] <- "cbushnell@wakehealth.edu"
#authors_all[1, "npi_eligible"] <- TRUE

#Louise D.McCullough
#authors_all[2, "npi"] <- 1447256441
#authors_all[2, "npi_verified"] <- TRUE
#authors_all[2, "affiliation_found"] <- "The University of Texas McGovern Medical School"
#authors_all[2, "faculty_page"] <- "https://med.uth.edu/neurology/2022/10/31/louise-d-mccullough-md-phd/"
#authors_all[2, "practitioner_page"] <- NA
#authors_all[2, "contact1"] <- "louise.d.mccullough@uth.tmc.edu"
#authors_all[2, "npi_eligible"] <- TRUE

#Issam A.	Awad
#authors_all[3, "npi"] <- 1699781690
#authors_all[3, "npi_verified"] <- TRUE
#authors_all[3, "affiliation_found"] <- "The University of Chicago Medicine"
#authors_all[3, "faculty_page"] <- "https://neurology.uchicago.edu/faculty/issam-awad-md"
#authors_all[3, "practitioner_page"] <- "https://www.uchicagomedicine.org/find-a-physician/physician/issam-a-awad"
#authors_all[3, "contact1"] <- "iawad@uchicago.edu"
#authors_all[3, "npi_eligible"] <- TRUE

#Monique V.Chireau (Monique Vera Chireau or Monique Chireau Wubbenhorst)
#authors_all[4, "npi"] <- 1255417515
#authors_all[4, "npi_verified"] <- TRUE
#authors_all[4, "affiliation_found"] <- NA
#authors_all[4, "faculty_page"] <- "https://www.cbhd.org/people/monique-chireau"
#authors_all[4, "verification_other"] <- "https://opennpi.com/provider/1255417515"
authors_all[4, "other_names"] <- "Monique Chireau Wubbenhorst"
authors_all[4, "npi_eligible"] <- TRUE

# Wende N.Fedder
#authors_all[5, "npi"] <-
#authors_all[5, "npi_verified"] <-
#authors_all[5, "affiliation_found"] <- ""
#authors_all[5, "faculty_page"] <- ""
#authors_all[5, "practitioner_page"] <- ""
#authors_all[5, "contact1"] <- ""

# Karen L.Furie
#authors_all[6, "npi"] <-
#authors_all[6, "npi_verified"] <-
#authors_all[6, "affiliation_found"] <- ""
#authors_all[6, "faculty_page"] <- ""
#authors_all[6, "practitioner_page"] <- ""
#authors_all[6, "contact1"] <- ""

#7
#authors_all[7, "npi"] <-
#authors_all[7, "npi_verified"] <-
#authors_all[7, "affiliation_found"] <- ""
#authors_all[7, "faculty_page"] <- ""
#authors_all[7, "practitioner_page"] <- ""
#authors_all[7, "contact1"] <- ""


#8
#authors_all[8, "npi"] <-
#authors_all[8, "npi_verified"] <-
#authors_all[8, "affiliation_found"] <- ""
#authors_all[8, "faculty_page"] <- ""
#authors_all[8, "practitioner_page"] <- ""
#authors_all[8, "contact1"] <- ""

#9
#authors_all[9, "npi"] <-
#authors_all[9, "npi_verified"] <-
#authors_all[9, "affiliation_found"] <- ""
#authors_all[9, "faculty_page"] <- ""
#authors_all[9, "practitioner_page"] <- ""
#authors_all[9, "contact1"] <- ""


#10
#authors_all[10, "npi"] <-
#authors_all[10, "npi_verified"] <-
#authors_all[10, "affiliation_found"] <- ""
#authors_all[10, "faculty_page"] <- ""
#authors_all[10, "practitioner_page"] <- ""
#authors_all[10, "contact1"] <- ""

#11
#authors_all[11, "npi"] <-
#authors_all[11, "npi_verified"] <-
#authors_all[11, "affiliation_found"] <- ""
#authors_all[11, "faculty_page"] <- ""
#authors_all[11, "practitioner_page"] <- ""
#authors_all[11, "contact1"] <- ""

#12
#authors_all[12, "npi"] <-
#authors_all[12, "npi_verified"] <-
#authors_all[12, "affiliation_found"] <- ""
#authors_all[12, "faculty_page"] <- ""
#authors_all[12, "practitioner_page"] <- ""
#authors_all[12, "contact1"] <- ""

#13
#authors_all[13, "npi"] <-
#authors_all[13, "npi_verified"] <-
#authors_all[13, "affiliation_found"] <- ""
#authors_all[13, "faculty_page"] <- ""
#authors_all[13, "practitioner_page"] <- ""
#authors_all[13, "contact1"] <- ""

#14
#authors_all[14, "npi"] <-
#authors_all[14, "npi_verified"] <-
#authors_all[14, "affiliation_found"] <- ""
#authors_all[14, "faculty_page"] <- ""
#authors_all[14, "practitioner_page"] <- ""
#authors_all[14, "contact1"] <- ""

#15
#authors_all[15, "npi"] <-
#authors_all[15, "npi_verified"] <-
#authors_all[15, "affiliation_found"] <- ""
#authors_all[15, "faculty_page"] <- ""
#authors_all[15, "practitioner_page"] <- ""
#authors_all[15, "contact1"] <- ""

#16
#authors_all[16, "npi"] <-
#authors_all[16, "npi_verified"] <-
#authors_all[16, "affiliation_found"] <- ""
#authors_all[16, "faculty_page"] <- ""
#authors_all[16, "practitioner_page"] <- ""
#authors_all[16, "contact1"] <- ""

#17
#authors_all[17, "npi"] <-
#authors_all[17, "npi_verified"] <-
#authors_all[17, "affiliation_found"] <- ""
#authors_all[17, "faculty_page"] <- ""
#authors_all[17, "practitioner_page"] <- ""
#authors_all[17, "contact1"] <- ""

