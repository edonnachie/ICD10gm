source("data-raw/dat_icd_text.R")
source("data-raw/dat_icd_umsteiger.R")
devtools::use_data(icd_hist, icd_labels,
                   internal = TRUE,
                   overwrite = TRUE)
