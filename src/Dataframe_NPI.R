# Creating the NPI dataset - CMS NPI All - April 25 2023

# install.packages("data.table")
# library(data.table)

setwd("/Users/johannahcramer/Documents/GitHub/coi")

fname <- "/Users/johannahcramer/Desktop/Guidelines project/NPI registry downloads/Registry data/NPPES_Data_Dissemination_April_2023/npidata_pfile_20050523-20230409.csv"
header <- fread(fname, nrows=0 )
npi_all_subset <- fread(fname, skip = 1000000, nrows = 10000, col.names = names(header))
View(npi_all_subset)

# Let's say your data frame is called npi_all_subset
dir.create('./data')
write.csv(npi_all_subset, file = "./data/test_subset_npi_all.csv", row.names = FALSE)

test_subset_npi_all <- fread("./data/test_subset_npi_all.csv")
View(test_subset_npi_all)