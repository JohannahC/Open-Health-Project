#Create standardsofcare 

library(tidyverse)
library(rvest)
library(dplyr)

# Create the first data frame
standardsofcare2023 <- read_html("https://diabetesjournals.org/care/issue/46/Supplement_1")
standardsofcare2023 <- standardsofcare2023 %>% html_nodes(".item-title a , .al-cite-description a") %>% 
  html_text()
title_2023 <- standardsofcare2023[seq(1, length(standardsofcare2023), 2)]
doi_2023 <- standardsofcare2023[seq(2, length(standardsofcare2023), 2)]
standardsofcare <- data.frame(Title = title_2023, DOI = doi_2023, Year = "2023")
View(standardsofcare)

# Add data for 2022
standardsofcare2022 <- read_html("https://diabetesjournals.org/care/issue/45/Supplement_1")
standardsofcare2022 <- standardsofcare2022 %>% html_nodes(".item-title a , .al-cite-description a") %>% 
  html_text()
title_2022 <- standardsofcare2022[seq(1, length(standardsofcare2022), 2)]
doi_2022 <- standardsofcare2022[seq(2, length(standardsofcare2022), 2)]
df_2022 <- data.frame(Title = title_2022, DOI = doi_2022, Year = "2022")
standardsofcare <- rbind(standardsofcare, df_2022)
View(standardsofcare)

# Add data for 2021
standardsofcare2021 <- read_html("https://diabetesjournals.org/care/issue/44/Supplement_1")
standardsofcare2021 <- standardsofcare2021 %>% html_nodes(".item-title a , .al-cite-description a") %>% 
  html_text()
title_2021 <- standardsofcare2021[seq(1, length(standardsofcare2021), 2)]
doi_2021 <- standardsofcare2021[seq(2, length(standardsofcare2021), 2)]
df_2021 <- data.frame(Title = title_2021, DOI = doi_2021, Year = "2021")
standardsofcare <- rbind(standardsofcare, df_2021)
View(standardsofcare)

# Add data for 2020
standardsofcare2020 <- read_html("https://diabetesjournals.org/care/issue/43/Supplement_1")
standardsofcare2020 <- standardsofcare2020 %>% html_nodes(".item-title a , .al-cite-description a") %>% 
  html_text()
title_2020 <- standardsofcare2020[seq(1, length(standardsofcare2020), 2)]
doi_2020 <- standardsofcare2020[seq(2, length(standardsofcare2020), 2)]
df_2020 <- data.frame(Title = title_2020, DOI = doi_2020, Year = "2020")
standardsofcare <- rbind(standardsofcare, df_2020)
View(standardsofcare)

# Add data for 2019
standardsofcare2019 <- read_html("https://diabetesjournals.org/care/issue/42/Supplement_1")
standardsofcare2019 <- standardsofcare2019 %>% html_nodes(".item-title a , .al-cite-description a") %>% 
  html_text()
title_2019 <- standardsofcare2019[seq(1, length(standardsofcare2019), 2)]
doi_2019 <- standardsofcare2019[seq(2, length(standardsofcare2019), 2)]
df_2019 <- data.frame(Title = title_2019, DOI = doi_2019, Year = "2019")
standardsofcare <- rbind(standardsofcare, df_2019)
View(standardsofcare)

# Add data for 2018
standardsofcare2018 <- read_html("https://diabetesjournals.org/care/issue/41/Supplement_1")
standardsofcare2018 <- standardsofcare2018 %>% html_nodes(".item-title a , .al-cite-description a") %>% 
  html_text()
title_2018 <- standardsofcare2018[seq(1, length(standardsofcare2018), 2)]
doi_2018 <- standardsofcare2018[seq(2, length(standardsofcare2018), 2)]
df_2018 <- data.frame(Title = title_2018, DOI = doi_2018, Year = "2018")
standardsofcare <- rbind(standardsofcare, df_2018)
View(standardsofcare)

