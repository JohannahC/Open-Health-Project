library(tidyverse)
library(purrr)
library(dplyr)

setwd("/Users/johannahcramer/Documents/GitHub/coi/src")

verified_matches <- read_rds("matched.rds")
View(verified_matches)

# Add a new column 'number' to the dataframe 'verified_matches'
verified_matches <- verified_matches %>% mutate(number = NA)

# Loop through the rows of 'verified_matches'
for (i in seq_len(nrow(verified_matches))) {
  # Extract nested dataframe
  nested_df <- verified_matches$npi[[i]]

  # Check if 'nested_df' is a dataframe, not empty, and has only one row
  if (is.data.frame(nested_df) && !is.null(nested_df) && nrow(nested_df) == 1) {
    # If it does, extract the 'number' value and save it to the 'number' column in 'verified_matches'
    verified_matches$number[i] <- nested_df$number
  }
}


# View the dataframe
View(verified_matches)

#Manually add the missings or errors based on Notion notes
#template code:

# verified_matches[verified_matches$rowid == , "number"] <- ""
# print(verified_matches[verified_matches$rowid == , "number"])

# 10.1161/str.0000000000000436

# 716 - Sherry Hsiang-Yi Chou - 1548270606

verified_matches[verified_matches$rowid == 716 , "number"] <- "1548270606"
print(verified_matches[verified_matches$rowid == 716, "number"])

# 721 - Daniel Hänggi - NA

verified_matches[verified_matches$rowid == 721, "number"] <- NA
print(verified_matches[verified_matches$rowid == 721, "number"])

# 724 - Regina Johnson - NA

verified_matches[verified_matches$rowid == 724, "number"] <- NA
print(verified_matches[verified_matches$rowid == 724, "number"])

# 730 - Christopher J. Stapleton - 1083908099

verified_matches[verified_matches$rowid == 730, "number"] <- "1083908099"
print(verified_matches[verified_matches$rowid == 730, "number"])

# 731- Jose I. Suarez - 1396763785

verified_matches[verified_matches$rowid == 731, "number"] <- "1396763785"
print(verified_matches[verified_matches$rowid == 731, "number"])

# 10.1161/cir.0000000000001063

# 60 - David Aguilar - 1326128695

verified_matches[verified_matches$rowid == 60, "number"] <- "1326128695"
print(verified_matches[verified_matches$rowid == 60, "number"])

# 61 - Larry A. Allen - 1003913674

verified_matches[verified_matches$rowid == 61, "number"] <- "1003913674"
print(verified_matches[verified_matches$rowid == 61, "number"])

# 62 - Joni J. Byun - NA

verified_matches[verified_matches$rowid == 62, "number"] <- NA
print(verified_matches[verified_matches$rowid == 62, "number"])

# 67 - Linda R. Evers - NA

verified_matches[verified_matches$rowid == 67, "number"] <- NA
print(verified_matches[verified_matches$rowid == 67, "number"])

# 68 - James C. Fang - 1447217740

verified_matches[verified_matches$rowid == 68, "number"] <- "1447217740"
print(verified_matches[verified_matches$rowid == 68, "number"])

# 71 - Salim S. Hayek - 1336458561

verified_matches[verified_matches$rowid == 71, "number"] <- "1336458561"
print(verified_matches[verified_matches$rowid == 71, "number"])

# 72 - Adrian F. Hernandez - 1902980063

verified_matches[verified_matches$rowid == 72, "number"] <- "1902980063"
print(verified_matches[verified_matches$rowid == 72, "number"])

# 76 - Mark S. Link - 1891766986

verified_matches[verified_matches$rowid == 76, "number"] <- "1891766986"
print(verified_matches[verified_matches$rowid == 76, "number"])

# 78 & 102 - Lorraine C. Nnacheta - NA

verified_matches[verified_matches$rowid == 78, "number"] <- NA
print(verified_matches[verified_matches$rowid == 78, "number"])

# 80 - Lynne Warner Stevenson - 1508822982

verified_matches[verified_matches$rowid == 80, "number"] <- "1508822982"
print(verified_matches[verified_matches$rowid == 80, "number"])

# 10.1161/circoutcomes.122.008900
# 447 -  Antony Hsu - 1083741656

verified_matches[verified_matches$rowid == 447, "number"] <- "1083741656"
print(verified_matches[verified_matches$rowid == 447, "number"])

# 448 - Aziz Khalid - NA

verified_matches[verified_matches$rowid == 448, "number"] <- NA
print(verified_matches[verified_matches$rowid == 448, "number"])

# 449 -  Lance B. Becker - 1750491965

verified_matches[verified_matches$rowid == 449, "number"] <- "1750491965"
print(verified_matches[verified_matches$rowid == 449, "number"])

# 450 - Robert A. Berg - 1639142086

verified_matches[verified_matches$rowid == 450, "number"] <- "1639142086"
print(verified_matches[verified_matches$rowid == 450, "number"])

# 451 - Farhan Bhanji - NA

verified_matches[verified_matches$rowid == 451, "number"] <- NA
print(verified_matches[verified_matches$rowid == 451, "number"])

# 452 - Steven M. Bradley - 1962515874

verified_matches[verified_matches$rowid == 452, "number"] <- "1962515874"
print(verified_matches[verified_matches$rowid == 452, "number"])

# 453 - Steven C. Brooks - NA

verified_matches[verified_matches$rowid == 453, "number"] <- NA
print(verified_matches[verified_matches$rowid == 453, "number"])

# 454 - Melissa Chan - NA

verified_matches[verified_matches$rowid == 454, "number"] <- NA
print(verified_matches[verified_matches$rowid == 454, "number"])

# 455 - Paul S. Chan - 1881770519

verified_matches[verified_matches$rowid == 455, "number"] <- "1881770519"
print(verified_matches[verified_matches$rowid == 455, "number"])

# 456 - Adam Cheng - NA

verified_matches[verified_matches$rowid == 456, "number"] <- NA
print(verified_matches[verified_matches$rowid == 456, "number"])

# 458 - Allan de Caen - NA

verified_matches[verified_matches$rowid == 458, "number"] <- NA
print(verified_matches[verified_matches$rowid == 458, "number"])

# 459 - Jonathan P Duff - NA

verified_matches[verified_matches$rowid == 459, "number"] <- NA
print(verified_matches[verified_matches$rowid == 459, "number"])

# 461 - Gustavo E Flores - 1629342365

verified_matches[verified_matches$rowid == 461, "number"] <- "1629342365"
print(verified_matches[verified_matches$rowid == 461, "number"])

# 462 - Susan Fuchs - 1205890613

verified_matches[verified_matches$rowid == 462, "number"] <- "1205890613"
print(verified_matches[verified_matches$rowid == 462, "number"])

# 464 - Carl Hinkson - NA

verified_matches[verified_matches$rowid == 464, "number"] <- NA
print(verified_matches[verified_matches$rowid == 464, "number"])

# 471 - Henry C Lee - 1073678454

verified_matches[verified_matches$rowid == 471, "number"] <- "1073678454"
print(verified_matches[verified_matches$rowid == 471, "number"])

# 473 - Arielle Levy - NA

verified_matches[verified_matches$rowid == 473, "number"] <- NA
print(verified_matches[verified_matches$rowid == 473, "number"])

# 474 - Mary E McBride - 1255506614

verified_matches[verified_matches$rowid == 474, "number"] <- "1255506614"
print(verified_matches[verified_matches$rowid == 474, "number"])

# 480 - Mary Ann Peberdy - 1528158177

verified_matches[verified_matches$rowid == 480, "number"] <- "1528158177"
print(verified_matches[verified_matches$rowid == 480, "number"])

# 482 - Kathryn Roberts - NA

verified_matches[verified_matches$rowid == 482, "number"] <- NA
print(verified_matches[verified_matches$rowid == 482, "number"])

# 483 - Michael R. Sayre - 1235210006

verified_matches[verified_matches$rowid == 483, "number"] <- "1235210006"
print(verified_matches[verified_matches$rowid == 483, "number"])

# 485 - Robert M. Sutton - 1104019330

verified_matches[verified_matches$rowid == 485, "number"] <- "1104019330"
print(verified_matches[verified_matches$rowid == 485, "number"])

# 486 - Mark Terry - NA

verified_matches[verified_matches$rowid == 486, "number"] <- NA
print(verified_matches[verified_matches$rowid == 486, "number"])

# 488 - Brian Walsh - NA

verified_matches[verified_matches$rowid == 488, "number"] <- NA
print(verified_matches[verified_matches$rowid == 488, "number"])

# 489 - David S Wang - 1134548548

verified_matches[verified_matches$rowid == 489, "number"] <- "1134548548"
print(verified_matches[verified_matches$rowid == 489, "number"])

# 491 - Ryan W Morgan - 1952628786

verified_matches[verified_matches$rowid == 491, "number"] <- "1952628786"
print(verified_matches[verified_matches$rowid == 491, "number"])


# 10.1161/cir.0000000000001106
# 674 - James Hamilton Black III - 1609832716

verified_matches[verified_matches$rowid == 674, "number"] <- "1609832716"
print(verified_matches[verified_matches$rowid == 674, "number"])

# 676 - Adam Beck - 1578570545

verified_matches[verified_matches$rowid == 676, "number"] <- "1578570545"
print(verified_matches[verified_matches$rowid == 676, "number"])

# 677 - Michael A. Bolen - 1033230271

verified_matches[verified_matches$rowid == 677, "number"] <- "1033230271"
print(verified_matches[verified_matches$rowid == 677, "number"])

# 678 - Alan C. Braverman - 1477597805

verified_matches[verified_matches$rowid == 678, "number"] <- "1477597805"
print(verified_matches[verified_matches$rowid == 678, "number"])

# 679 - Bruce E Bray - 1124118708

verified_matches[verified_matches$rowid == 679, "number"] <- "1124118708"
print(verified_matches[verified_matches$rowid == 679, "number"])

# 681 - Edward P. Chen - 1801985882

verified_matches[verified_matches$rowid == 681, "number"] <- "1801985882"
print(verified_matches[verified_matches$rowid == 681, "number"])

# 683 - Abe Deanda Jr. - 1437239092

verified_matches[verified_matches$rowid == 683, "number"] <- "1437239092"
print(verified_matches[verified_matches$rowid == 683, "number"])

# 686 - Caitlin W Hicks - 1356607139

verified_matches[verified_matches$rowid == 686, "number"] <- "1356607139"
print(verified_matches[verified_matches$rowid == 686, "number"])

# 688 - William Schuyler Jones - 1366456063

verified_matches[verified_matches$rowid == 688, "number"] <- "1366456063"
print(verified_matches[verified_matches$rowid == 688, "number"])

# 690 - Karen M. Kim - 1720114572

verified_matches[verified_matches$rowid == 690, "number"] <- "1720114572"
print(verified_matches[verified_matches$rowid == 690, "number"])

# 695 - Elsie Gyang Ross - 1316237548

verified_matches[verified_matches$rowid == 695, "number"] <- "1316237548"
print(verified_matches[verified_matches$rowid == 695, "number"])

# 696 - Marc L Schermerhorn - 1356391312

verified_matches[verified_matches$rowid == 696, "number"] <- "1356391312"
print(verified_matches[verified_matches$rowid == 696, "number"])

# 697 - Sabrina Singleton Times - NA

verified_matches[verified_matches$rowid == 697, "number"] <- NA
print(verified_matches[verified_matches$rowid == 697, "number"])

# 698 - Elaine E. Tseng - 1649243197

verified_matches[verified_matches$rowid == 698, "number"] <- "1649243197"
print(verified_matches[verified_matches$rowid == 698, "number"])

# 699 - Grace J. Wang - 1326029513

verified_matches[verified_matches$rowid == 699, "number"] <- "1326029513"
print(verified_matches[verified_matches$rowid == 699, "number"])

# 700 - Y. Joseph Woo - 1043240120

verified_matches[verified_matches$rowid == 700, "number"] <- "1043240120"
print(verified_matches[verified_matches$rowid == 700, "number"])

#check

target_dois <- c(
  "10.1161/str.0000000000000436",
  "10.1161/cir.0000000000001063",
  "10.1161/cir.0000000000001106",
  "10.1161/circoutcomes.122.008900"
)

# Subset dataframe to include only rows where doi is one of the target DOIs
verified_sample <- verified_matches[verified_matches$doi %in% target_dois, ]
View(verified_sample)

write_rds(verified_sample, "verified_sample.rds")


