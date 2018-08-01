regex_icd <- "([A-Z][0-9]{2})\\.?([0-9]{0,2})"


#' Extract all ICD codes from a character vector
#'
#' An ICD code consists of a three digit code
#' (i.e. one upper-case letter followed by
#' two digits), optionally with a two digit
#' subcode (which may or may not have a period
#' separating the three-digit code and subcode)
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
#' @param bind_rows Whether to convert the matrix output of `stirngi::stri_match_all` to a data.frame, with additional `icd_norm` and `icd_sub`
#'
#' @return data.frame (if bind_rows = TRUE) or matrix
#' @importFrom stringi stri_match_all_regex
#' @importFrom dplyr bind_rows
#' @export
icd_parse <- function (str, bind_rows = TRUE) {
  out <- stringi:::stri_match_all_regex(str, pattern = regex_icd)

  if (bind_rows) {
    out <- lapply(out, as.data.frame, stringsAsFactors = FALSE)
    out <- dplyr::bind_rows(out)
    names(out) <- c("icd_spec", "icd3", "icd_subcode")
    out$icd3[out$icd3 == ""] <- NA
    out$icd_subcode[out$icd_subcode == ""] <- NA
    out$icd_norm = ifelse(!is.na(out$icd3),
                          gsub("\\.?NA", "", paste(out$icd3, out$icd_subcode, sep = ".")),
                          NA_character_)
    out$icd_sub = ifelse(!is.na(out$icd3),
                         gsub("\\.?NA", "", paste(out$icd3, out$icd_subcode, sep = "")),
                         NA_character_)
  }


  return(out)
}

#' Test whether a string is an ICD code
#'
#' An ICD code consists of a three digit code
#' (i.e. one upper-case letter followed by
#' two digits), optionally with a two digit
#' subcode (which may or may not have a period
#' separating the three-digit code and subcode)
#'
#' @param str Character vector to be tested
#' @return Logical vector the same length as the character input
#' @export
is_icd_code <- function(str) {
  grepl(pattern = paste0("^", regex_icd, "$"), str)
}

