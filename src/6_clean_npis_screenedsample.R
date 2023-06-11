#goal: try to assess if this npi list is clean:

#listed discrepancies:

#  Y. Joseph Woo (full name Yi-Ping Joseph Woo) - 3 hits for Joseph Woo in the API call, but none are correct. 
#  B. Kelly Han (same issue - full name Barbara Kelly Han)  
#  J. Michael Dimaio  
#  Need to figure out how to handle this kind of name error in API call 

# José Joglar not captured - need to try without accent
  
#
# new criteria: 

screened_sample_test <- read_csv("screened_authors_sample.csv")
View(screened_sample_test)

test1 <- read_rds("npidata_screenedsample.rds")
View(test1)

#find out how many names in the screened sample are unconventional (ie. J. Michael, etc)

# when there's a unique name 

# subset all names that have last names that are unique 

unique_lastnames <- filter(unique(npidata_screenedsample[col(8)]))
print(num_unique_doi)
