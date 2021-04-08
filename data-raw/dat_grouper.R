charlson_rcs <- readr::read_csv2(here::here("data-raw/grouper/charlson_rcs.dat"))

charlson_sund <- readr::read_csv2(here::here("data-raw/grouper/charlson_sundararajan_2004.dat"))

usethis::use_data(charlson_rcs, charlson_sundararajan, overwrite = TRUE)
