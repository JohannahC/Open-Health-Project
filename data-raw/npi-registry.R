library(tidyverse)

download.file("https://download.cms.gov/nppes/NPPES_Data_Dissemination_May_2023.zip",
              "data-raw/npi.zip",
              timeout = 5*60)

npi <- read_csv(
  unz("data-raw/npi.zip",
      "npidata_pfile_20050523-20230507.csv"
  ), n_max = 5000
)

npi <- npi |>
  janitor::clean_names()

npi |>
  colnames()
# what is useful here?

# Definitely drop:
#   - rows where entity_type_code = 2: these are hospitals & practices, not individuals
#   - cols 108-307 & 309-311: IDs for things like health insurers, Medicaid, etc, not individuals
#   - cols 315-329: taxonomy for group practices
#   - cols 4,5,12,13: type 2 entity related (organization)
#   - cols 43-47 and 312-314: authorized official of a type 2 entity (CEO, board, etc)
#   - cols 28,36: fax numbers
#
# Definitely keep:
#   - cols 1-2,6-11,14-27,29-35,37-38: npis, names, practice locations, affiliations of individuals
#
# Unsure:
#   - cols 39-41: NPI deactivation/reactivation info - need to think on this and test if deactivated NPIs are in OP
#   - cols 312-314(?),330
#   - col 308: do we want to know if our NPI holder also owns a practice ?
#   - col 330: unclear what this is

# Notes/thoughts:
#   - cols 48-107: taxonomy codes I don't yet understand and license numbers I'm not sure are unique.The taxonomy code system used in this registry was developed by a third party which no longer operates it. I would say we should eventually include the top 3 medical specialties for each provider, but lets drop them for now and merge them back when we know what's what.
#   - col 3: this is replacement NPI - I am pretty sure if an NPI has been replaced, then the NPI is the replaced version, so I don't think this is relevant
