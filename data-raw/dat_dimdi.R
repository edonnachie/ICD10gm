source(here::here("data-raw/lib_dimdi_import.R"))

## Read in files ----
purrr::walk(2004:2018, extract_icd_meta_files)
icd_meta_codes <- purrr::map_df(2004:2018, read_icd_codes)
icd_meta_blocks <- purrr::map_df(2004:2018, read_icd_blocks)
icd_meta_chapters <- purrr::map_df(2004:2018, read_icd_chapters)
icd_meta_transition <- purrr::map_df(2005:2018, read_icd_transitions)

# Create new fields
icd_meta_chapters <- within(icd_meta_chapters, chapter_roman <- as.roman(chapter))[, c(1, 2, 4, 3)]

icd_meta_blocks <- within(icd_meta_blocks,
                          group_id <- paste(icd_block_first, icd_block_last, sep = "-"))

icd_meta_codes <- within(icd_meta_codes, icd3 <- substr(icd_sub, 1, 3))


icd_meta_transition <- within(icd_meta_transition, {
	icd_kapitel <- substr(icd_to, 1, 1)
	icd3 <- substr(icd_to, 1, 3)
	change <- (icd_to != icd_from)
	change_3 <- (substr(icd_from, 1, 3) != substr(icd_to, 1, 3))
	change_4 <- (substr(icd_from, 1, 4) != substr(icd_to, 1, 3) &! change_3)
	change_5 <- (substr(icd_from, 1, 5) != substr(icd_to, 1, 5) &! change_3 &! change_4)
})


devtools::use_data(
  icd_meta_codes,
  icd_meta_blocks,
  icd_meta_chapters,
  icd_meta_transition,
  overwrite = TRUE)
