# ECRI Guidelines Trust - Complete Database 

install.packages("readxl")
library(tidyverse)
library(dplyr)
library(readxl)
library(urltools)

# **** ECRI GUIDELINES ****

#read in ECRI excel file
read_excel("Guideline Titles.xls")
View(Guideline_Titles)

#save as csv
ecri_all <- Guideline_Titles
write.csv(ecri_all, "ecri_all.csv")

#explore the ECRI dataset 
view(ecri_all)

#rename variables
ecri_all <- rename(ecri_all, 
       unique_id = UNIQUEID,  
       title = GUIDELINETITLE, 
       meets_inclusion_criteria = MEETSREVISEDINCLUSIONCRITERIA, 
       source = SOURCE, 
       professional_medical_society_code = ORGANIZATION, 
       professional_medical_society = 'ORGANIZATION TITLE', 
       year = PUBLICATIONYEAR, 
       publication_reaffirmation_date = PUBLICATIONREAFFIRMATIONDATE,
       link = ACCESSTHEGUIDELINE)

view(ecri_all)

#explore what's in the data
print(class(ecri_all$professional_medical_society_code))
print(unique(ecri_all$professional_medical_society_code))
print(unique(ecri_all$professional_medical_society))
print(ecri_all$professional_medical_society_code[ecri_all$professional_medical_society == "[American Heart Association (AHA), American College of Cardiology (ACC), ]"])
print(ecri_all[ecri_all$professional_medical_society == "[61bb5c31fa9a85ac2ecca920ffa77e6d,908dbd84c9311f2f68ba4afd55cbd813,]"])
print(ecri_all[ecri_all$professional_medical_society == "[American Diabetes Association (ADA), ]"])

?subset()
#test subset development for different societies(ADA, AHA/ACC and ACOG)

# *** ADA ***
ada <- subset(ecri_all, professional_medical_society == "[American Diabetes Association (ADA), ]")
view(ada)
#16 rows

#identify dois manually:
#row 1 = https://doi.org/10.2337/dc23-S001
#row 2 = https://doi.org/10.2337/dc23-S002
#row 3 = https://doi.org/10.2337/dc23-S003
#row 4 = https://doi.org/10.2337/dc23-S004
#row 5 = https://doi.org/10.2337/dc23-S005
#row 6 = https://doi.org/10.2337/dc23-S006
#row 7 = https://doi.org/10.2337/dc23-S007
#row 8 = https://doi.org/10.2337/dc23-S008
#row 9 = https://doi.org/10.2337/dc23-S009
#row 10 = https://doi.org/10.2337/dc23-S010
#row 11 = https://doi.org/10.2337/dc23-S011
#row 12 = https://doi.org/10.2337/dc23-S013
#row 13 = https://doi.org/10.2337/dc23-S014
#row 14 = https://doi.org/10.2337/dc23-S015
#row 15 = https://doi.org/10.2337/dc23-S016
#row 16 = https://doi.org/10.2337/dc23-S012 (yes, S012 is out of order)

#add (manually identified) dois to a list and fill in column with list - note: #12 is out of order but correct
ada_dois <- c("https://doi.org/10.2337/dc23-S001", "https://doi.org/10.2337/dc23-S002",
              "https://doi.org/10.2337/dc23-S003","https://doi.org/10.2337/dc23-S004",
              "https://doi.org/10.2337/dc23-S005", "https://doi.org/10.2337/dc23-S006",
              "https://doi.org/10.2337/dc23-S007", "https://doi.org/10.2337/dc23-S008", 
              "https://doi.org/10.2337/dc23-S009", "https://doi.org/10.2337/dc23-S010",
              "https://doi.org/10.2337/dc23-S011", "https://doi.org/10.2337/dc23-S013",
              "https://doi.org/10.2337/dc23-S014", "https://doi.org/10.2337/dc23-S015",
              "https://doi.org/10.2337/dc23-S016", "https://doi.org/10.2337/dc23-S012")
view(ada)

#fill in column doi with items in the list in the order (ie. list item 1 --> row 1, list item 2 --> row 2, etc)
ada$doi[1:16] <- ada_dois
view(ada)

# *** AHA/ACC ***
aha_acc <- subset(ecri_all, professional_medical_society == "[American Heart Association (AHA), American College of Cardiology (ACC), ]")
view(aha_acc)
#13 rows

#identify dois manually:
#row 1 = https://doi.org/10.1016/j.jacc.2013.11.005
#row 2 = https://doi.org/10.1016/j.jacc.2013.11.003
#row 3 = https://doi.org/10.1016/j.jacc.2013.11.002
#row 4 = https://doi.org/10.1016/j.jacc.2014.02.536
#row 5 = https://doi.org/10.1016/j.jacc.2014.07.944
#row 6 = https://doi.org/10.1016/j.jacc.2017.03.011
#row 7 = https://doi.org/10.1016/j.jacc.2016.03.513
#row 8 = https://doi.org/10.1016/j.jacc.2016.11.007
#row 9 = https://doi.org/10.1161/CIR.0000000000000134 (article link is wrong, will replace)
#row 10 = https://doi.org/10.1161/CIR.0000000000000603
#row 11 = https://doi.org/10.1161/CIR.0000000000000678
#row 12 = https://doi.org/10.1161/CIR.0000000000000937
#row 13 = https://doi.org/10.1161/CIR.0000000000001106

#fix row 9 link
aha_acc$link[9] <- "https://www.ahajournals.org/doi/10.1161/CIR.0000000000000134"
view(aha_acc)

#add manually identified dois to a list and fill in column values for new doi column with list
aha_acc_dois <- c("https://doi.org/10.1016/j.jacc.2013.11.005", "https://doi.org/10.1016/j.jacc.2013.11.003",
                  "https://doi.org/10.1016/j.jacc.2013.11.002", "https://doi.org/10.1016/j.jacc.2014.02.536",
                  "https://doi.org/10.1016/j.jacc.2014.07.944", "https://doi.org/10.1016/j.jacc.2017.03.011",
                  "https://doi.org/10.1016/j.jacc.2016.03.513", "https://doi.org/10.1016/j.jacc.2016.11.007",
                  "https://doi.org/10.1161/CIR.0000000000000134", "https://doi.org/10.1161/CIR.0000000000000603",
                  "https://doi.org/10.1161/CIR.0000000000000678", "https://doi.org/10.1161/CIR.0000000000000937",
                  "https://doi.org/10.1161/CIR.0000000000001106")

view(aha_acc_dois)

#fill in column doi with items in the list in the order (ie. list item 1 --> row 1, list item 2 --> row 2, etc)
aha_acc$doi[1:13] <- aha_acc_dois
view(aha_acc)


# *** ACOG ***

acog <- subset(ecri_all, professional_medical_society == "[American College of Obstetricians and Gynecologists (ACOG), ]")
view(acog)
#59 rows



#identify number of unique societies publishing guidelines in the database


#update csv
write.csv(ecri_all, "ecri_all.csv")
view(ecri_all)

