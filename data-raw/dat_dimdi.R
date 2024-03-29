source(here::here("data-raw/lib_dimdi_import.R"))

year_range <- 2004:2024

## Read in files ----
purrr::walk(year_range, extract_icd_meta_files)
icd_meta_codes <- purrr::map_df(year_range, read_icd_codes)
icd_meta_blocks <- purrr::map_df(year_range, read_icd_blocks)
icd_meta_chapters <- purrr::map_df(year_range, read_icd_chapters)
icd_meta_transition <- purrr::map_df(year_range[-1], read_icd_transitions)

# Create new fields
icd_meta_chapters <- within(icd_meta_chapters, chapter_roman <- as.roman(chapter))[, c(1, 2, 4, 3)]

icd_meta_blocks <- within(icd_meta_blocks,
                          group_id <- ifelse(!is.na(icd_block_last),
                                             paste(icd_block_first, icd_block_last, sep = "-"),
                                             icd_block_first)
                          )

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
  # Now ensure all latin1 is converted to UTF-8
  str[Encoding(str) == "latin1"] <- iconv(str, from = "latin1", to = "UTF-8")

  # ANSI with \u00
  str <- gsub("\u0084", "ä", str, useBytes = TRUE)
  str <- gsub("\u008e", "Ä", str, useBytes = TRUE)
  str <- gsub("\u0094", "ö", str, useBytes = TRUE)
  str <- gsub("\u0099", "Ö", str, useBytes = TRUE)
  str <- gsub("\u0081", "ü", str, useBytes = TRUE)
  str <- gsub("\u009a", "Ü", str, useBytes = TRUE)
  str <- gsub("\u00e1", "ß", str, useBytes = TRUE)

  # ANSI
  str <- gsub("\x84", "ä", str, useBytes = TRUE)
  str <- gsub("\x8e", "Ä", str, useBytes = TRUE)
  str <- gsub("\x94", "ö", str, useBytes = TRUE)
  str <- gsub("\x99", "Ö", str, useBytes = TRUE)
  str <- gsub("\x81", "ü", str, useBytes = TRUE)
  str <- gsub("\x9a", "Ü", str, useBytes = TRUE)
  str <- gsub("\xe1", "ß", str, useBytes = TRUE)
  # UTF-8
  str <- gsub("\xe4", "ä", str, useBytes = TRUE)
  str <- gsub("\xc4", "Ä", str, useBytes = TRUE)
  str <- gsub("\xf6", "ö", str, useBytes = TRUE)
  str <- gsub("\xd6", "Ö", str, useBytes = TRUE)
  str <- gsub("\xfc", "ü", str, useBytes = TRUE)
  str <- gsub("\xdc", "Ü", str, useBytes = TRUE)
  str <- gsub("\xdf", "ß", str, useBytes = TRUE)

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


## Additions not included in the official download file ----

## Read and prepare list of code additions
icd_meta_codes_additions <- jsonlite::read_json(
  here::here("data-raw/additions/icd_meta_codes_additions.json"),
  simplifyVector = TRUE)
icd_meta_codes_additions <- tidyr::nest(icd_meta_codes_additions,
                                        meta = -c(year, icd_sub))

## Function to update codes
update_codes <- function(code_additions, icd_meta_codes) {
  for (i in 1:nrow(code_additions)) {
    meta_code <- code_additions[i, "meta"][[1]][[1]]
    i_code <- which(paste(icd_meta_codes$year, icd_meta_codes$icd_sub) ==
                      paste(code_additions[i, "year"], code_additions[i, "icd_sub"]))
    icd_meta_codes[i_code, names(meta_code)] <- meta_code
  }
  return(icd_meta_codes)
}
icd_meta_codes <- update_codes(icd_meta_codes_additions, icd_meta_codes)

### Note: Transitions are included in the official downloads

## Save ----
usethis::use_data(
  icd_meta_codes,
  icd_meta_blocks,
  icd_meta_chapters,
  icd_meta_transition,
  overwrite = TRUE,
  compress = "xz")
