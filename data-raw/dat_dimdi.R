source(here::here("data-raw/lib_dimdi_import.R"))

## Read in files ----
purrr::walk(2004:2019, extract_icd_meta_files)
icd_meta_codes <- purrr::map_df(2004:2019, read_icd_codes)
icd_meta_blocks <- purrr::map_df(2004:2019, read_icd_blocks)
icd_meta_chapters <- purrr::map_df(2004:2019, read_icd_chapters)
icd_meta_transition <- purrr::map_df(2005:2019, read_icd_transitions)

# Create new fields
icd_meta_chapters <- within(icd_meta_chapters, chapter_roman <- as.roman(chapter))[, c(1, 2, 4, 3)]

icd_meta_blocks <- within(icd_meta_blocks,
                          group_id <- paste(icd_block_first, icd_block_last, sep = "-"))

icd_meta_codes <- within(icd_meta_codes, icd3 <- substr(icd_sub, 1, 3))


## Clean up UTF-8 encoding ----
# Older ICD-10-GM versions encode special characters as hex
# I've been unable to solve this elegantly, making the following hack necessary
# See also:
# https://stackoverflow.com/questions/33415388/whats-the-difference-between-hex-code-x-and-unicode-u-chars
# https://www.lima-city.de/thread/ausgabe-von-oe-ae-ue-in-konsolenfenster
# https://www.c-plusplus.net/forum/topic/39326/deutsche-umlaute
# https://www.utf8-zeichentabelle.de/unicode-utf8-table.pl?unicodeinhtml=hex

cleanup_utf8 <- function(str) {
  # ANSI
  str <- gsub("\x84", "ä", str)
  str <- gsub("\x8e", "Ä", str)
  str <- gsub("\x94", "ö", str)
  str <- gsub("\x99", "Ö", str)
  str <- gsub("\x81", "ü", str)
  str <- gsub("\x9a", "Ü", str)
  str <- gsub("\xe1", "ß", str)
  # UTF-8
  str <- gsub("\xe4", "ä", str)
  str <- gsub("\xc4", "Ä", str)
  str <- gsub("\xf6", "ö", str)
  str <- gsub("\xd6", "Ö", str)
  str <- gsub("\xfc", "ü", str)
  str <- gsub("\xdc", "Ü", str)
  str <- gsub("\xdf", "ß", str)
  str
}

icd_meta_codes <- within(icd_meta_codes, {
  label <- cleanup_utf8(label)
  label_icd3 <- cleanup_utf8(label_icd3)
  label_icd4 <- cleanup_utf8(label_icd4)
  label_icd5 <- cleanup_utf8(label_icd5)
})

icd_meta_blocks$block_label <- cleanup_utf8(icd_meta_blocks$block_label)
icd_meta_chapters$chapter_label <- cleanup_utf8(icd_meta_chapters$chapter_label)


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
