library(tidyverse)


# Read in some sample diagnosis data
dat_icd <- readr::read_csv("sample_data.csv")

head(dat_icd)

# Read in the Charlson comorbidities
# (Also available as ICD10gm::charlson_rcs, but the CRAN version has a bug)
charlson <- readr::read_csv2("charlson_rcs.dat") %>%
  ICD10gm::icd_expand(year = 2021,
                      col_icd = "ICD_SPEC",
                      col_meta = "Disease_Category")  %>%
  ICD10gm::icd_history(years = 2010:2021)


# Apply grouper to data
dat_charlson <- dat_icd %>%
  # With ambulatory data, restrict to secured diagnoses
  # (Alternatively, need to add ICD_SICHER_ID as a
  # metadata column to the grouper and join using it)
  filter(ICD_SICHER_ID == "G") %>%
  # Convert quarter to year
  mutate(year = as.integer(substr(ABRQ, 1, 4))) %>%
  # Join with metadata and aggregate by Disease_Category
  inner_join(charlson, by = c("ICD_SUB" = "icd_sub", "year" = "year" )) %>%
  select(year, PID, Disease_Category) %>%
  distinct()

head(dat_charlson)


## Transform to wide format for further analysis/modelling
## - Year or quarter can be added as additional id variables (as required)
## - Need to convert
charlson_comorbidities <- dat_charlson %>%
  mutate(x = TRUE) %>%
  pivot_wider(id_cols = "PID",
              names_from = "Disease_Category",
              values_from = x,
              values_fill = FALSE)

head(charlson_comorbidities)
