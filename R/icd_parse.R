regex_icd3 <- "\\b([A-Z][0-9]{2})"
regex_icd <- paste0(
  # Match a 3-digit ICD code
  regex_icd3,
  # An optional one- or two-digit subcode (captured),
  # optionally with period (not captured)
  "(?:\\.?([0-9]{1,2}))?",
  # Optional punctuation, not captured (hypthen, star, dagger)
  "(?:\\.?-? ?[*!\U2020]?)?",
  # Optional security code G, V, A, Z,
  # but not the start of a new word
  " ?([GVZA]{0,1}\\b)?"
  )
regex_icd_bounded <- paste0("\\b", regex_icd, "[^\\w]?")
regex_icd_only <- paste0("^", regex_icd, "$")

#' Extract all ICD codes from a character vector
#'
#' An ICD code consists of, at a minimum,
#' a three digit ICD-10 code
#' (i.e. one upper-case letter followed by
#' two digits). This may optionally be followed
#' by a two digit subcode, selected punctuation symbols
#' (cross "*", dagger "U2020" or
#' exclamation mark "!"). Both the period
#' separating the three-digit code from the subcode,
#' and the hypthen indicating an "incomplete" subcode,
#' are optional. Finally, in the ambulatory system, an
#' additional letter G, V, Z or A may be appended to
#' signify the status ("security") of the diagnosis.
#'
#' By default, the function returns a data.frame
#' containing the matched codes and the standardised
#' three digit code (`icd3`), subcode (`icd_subcode`),
#' normcode (`icd_norm`) and code without period (`icd_sub`).
#'
#' If `bind_rows = FALSE`, the list output of
#' `stringi::stri_match_all_regex` is returned.
#' This is particularly useful to retrieve the
#' matches from each element of the `str` vector
#' separately.
#'
#' @param str Character vector from which to extract all ICD codes
#' @param type A character string determining how strictly matching should be performed. This must be one of "strict" (`str` contains a ICD code with no extraneous characters), `bounded` (`str` contains an ICD code with a word boundary on both sides) or `weak` (ICD codes are extracted even if they are contained within a word, e.g. "E10Diabetes" would return "E10"). Default: `bounded`.
#' @param bind_rows logical. Whether to convert the matrix output of `stirngi::stri_match_all` to a data.frame, with additional `icd_sub` to uniquely represent the code and allow lookup of the code
#' @return data.frame (if bind_rows = TRUE) or matrix
#' @importFrom stringi stri_match_all_regex
#' @importFrom dplyr bind_rows
#' @export
icd_parse <- function (str, type = "bounded", bind_rows = TRUE) {
  stopifnot(
    is.character(str),
    type %in% c("bounded", "strict", "weak")
    )

  # Determine regex based on type argument
  regex_icd_match <- regex_icd_bounded
  if (type == "weak") regex_icd_match <- regex_icd
  if (type == "strict") regex_icd_match <- regex_icd_only

  # Parse string and extract components
  out <- stringi::stri_match_all_regex(str, pattern = regex_icd_match)

  if (bind_rows) {
    out <- lapply(out, as.data.frame, stringsAsFactors = FALSE)
    out <- dplyr::bind_rows(out)
    names(out) <- c("icd_spec", "icd3", "icd_subcode",
                    "icd_security")
    out[, "icd_spec"] <- str
    # NA is reserved for strings that aree not ICD codes
    out$icd_subcode[is.na(out$icd_subcode) & !(out$icd3 == "")] <- ""
    out$icd_security[is.na(out$icd_security) & !(out$icd3 == "")] <- ""
    out$icd3[out$icd3 == ""] <- NA_character_
    out$icd_subcode[out$icd3 == ""] <- NA_character_
    out$icd_sub = ifelse(!is.na(out$icd3),
                         gsub("\\.?NA", "",
                              paste(out$icd3,
                                    sub("-", "", out$icd_subcode),
                                    sep = "")),
                         NA_character_)
  }


  return(out)
}

#' Test whether a string is a valid ICD code
#'
#' An ICD code consists of, at a minimum,
#' a three digit ICD-10 code
#' (i.e. one upper-case letter followed by
#' two digits). This may optionally be followed
#' by a two digit subcode, selected punctuation symbols
#' (cross "*", dagger "U2020" or
#' exclamation mark "!"). Both the period
#' separating the three-digit code from the subcode,
#' and the hypthen indicating an "incomplete" subcode,
#' are optional. Finally, in the ambulatory system, an
#' additional letter G, V, Z or A may be appended to
#' signify the status ("security") of the diagnosis.
#'
#' @param str Character vector to be tested
#' @param year Year for which to test whether the specification is a valid code. Default: NULL (test whether `str` matches a code from any year since 2003)
#' @param parse logical. Whether to first parse the input `str` using `icd_parse` (Default: TRUE). If FALSE, assumes that `str` is already formatted as `icd_sub` (i.e. without separating period or other punctuation)
#' @return Logical vector the same length as the character input
#' @export
is_icd_code <- function(str, year = NULL, parse = TRUE) {
  # First test whether str matches the pattern of a ICD code,
  # without any extraneous characters
  matches_pattern <- grepl(regex_icd_only, str)

  if (parse)
    str <- icd_parse(str, type = "strict")$icd_sub

  if (is.null(year) || !(year > 2003 & year < 2100)) {
    valid_codes <- unique(ICD10gm::icd_meta_codes$icd_sub)
  } else {
    valid_codes <- ICD10gm::get_icd_labels(year = year)$icd_sub
  }

  # Test whether parsed codes are valid for the given year
  matches_pattern & (str %in% valid_codes)
}

