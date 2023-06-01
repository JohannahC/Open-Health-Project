#Learning R
install.packages("dplyr")
library(tidyverse)
library(nycflights13)
library(dplyr)
library(easyPubMed)
ADAguidelines <- read.csv('/Users/johannahcramer/Documents/GitHub/coi/data/Results_1_American Diabetes Association.csv')

#reusable code for mapping
ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

#Example 1: 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

#ADA data

#count the number of publications (PMID) that occur in each year between 2013-2023

yearcount <- ADAguidelines %>% 
  group_by(Year) %>% 
  summarise(count = n())

ggplot(data = yearcount, aes(x = Year, y = count)) + 
  geom_bar(stat="identity", fill="blue") +
  xlab("Year") +
  ylab("Number of Publications")

?mpg
?geom_point
?easyPubMed

seq(1,10)

summarise(yearcount)
summarise(mpg)
view(mpg)

?arrange
arrange(mtcars, cyl, disp)

?select
?filter


# Install and load rcrossref package
install.packages("rcrossref")
library(rcrossref)

# Let's say this is your list of titles
titles <- c("2018 AHA/ACC/AACVPR/AAPA/ABC/ACPM/ADA/AGS/APhA/ASPC/NLA/PCNA guideline on the management of blood cholesterol  a report of the American College of Cardiology/American Heart Association Task Force on Clinical Practice Guidelines",
            "2021 AHA/ACC/ASE/CHEST/SAEM/SCCT/SCMR guideline for the evaluation and diagnosis of chest pain  a report of the American College of Cardiology/American Heart Association Joint Committee on Clinical Practice Guidelines")
        
# Initialize a vector to store DOIs
dois_vector <- c()

  