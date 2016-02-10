#' List of all ICD codes with labels
#'
#' Includes all valid levels of the hierarchy
#' Example:
#'   E11 ""Diabetes mellitus, Typ 2"
#'   E11.2 "Diabetes mellitus, Typ 2: Mit Nierenkomplikationen"
#'
#' @format A data frame with three columns:
#' \describe{
#'   \item{YEAR}{Year of validity}
#'   \item{ICD_CODE}{ICD Code}
#'   \item{ICD_LABEL}{ICD label with UTF-8 encoding}}
"icd_labels"

#' ICD History with transitions from one year to the next
#' Stable codes are included to enable the convertion
#' of a code list from one version to the next
#'
#' @format A data frame:
#' \describe{
#'   \item{year_from}{Year of old version}
#'   \item{year_to}{Year of new version}
#'   \item{icd_from}{Old ICD code}
#'   \item{icd_to}{New ICD code}
#'   \item{auto}{"A", if transition is automatic, else null if the transition is not clear-cut (e.g. changes in classification that require additional logic)}
#'   \item{change_5}{TRUE, if the five-digit code has changed}
#'   \item{change_4}{TRUE, if the four-digit code has changed}
#'   \item{change_3}{TRUE, if the three-digit code has changed}
#'   \item{change}{TRUE, if the code has changed}
#'   \item{icd_kapitel}{ICD chapter (A-Z)}
#'   }
"icd_hist"

#' Returns a data frame with ICD metadata, consisting of
#' year, ICD code and label. Optional arguments allow selection of
#' entries by year, code or label. This is beneficial because the
#' entire history is relatively large and rarely required in full.
#'
#' @param year Year or years to get (numeric or character vector)
#' @param icd_code (optional) ICD codes to select (regular expression, matched exactly using grep)
#' @param icd_label (optional) ICD to search for using fuzzy matching (agrep)
#' @param ... (optional) Further arguments passed to agrep when searching with icd_label
#' @return data.frame(YEAR, ICD_CODE, ICD_LABEL), see icd_labels
#' @export
get_icd_labels <- function(year = NULL, icd_code = NULL, icd_label = NULL, ...){
  out <- icd_labels

  if(!is.null(year) & all(grepl("^\\d{4}$", year)))
    out <- subset(out, YEAR %in% year)

  if(!is.null(icd_code) & all(grepl("^[A-Za-z]\\d{2}", icd_code)))
    out <- out[grepl(icd_code, out$ICD_CODE), ]

  if(!is.null(icd_label) & is.character(icd_label))
    out <- out[agrep(icd_label, out$ICD_LABEL, ...), ]

   return(out)
}

#' Returns a data frame with ICD transition history, consisting of
#' year, ICD code and label. Optional arguments allow selection of
#' entries by year or ICD code. This is beneficial because the
#' entire history is relatively large and rarely required in full.
#'
#' @param year_from Year or years to get (numeric or character vector)
#' @param icd_code (optional) ICD codes to select (regular expression, matched exactly using grep)
#' @return data.frame, see icd_hist
#' @export
get_icd_history <- function(year_from = NULL, icd_code = NULL){
  out <- icd_history

  if(!is.null(year) & all(grepl("^\\d{4}$", year)))
    out <- subset(out, year_from %in% year)

  if(!is.null(icd_code) & all(grepl("^[A-Za-z]\\d{2}", icd_code)))
    out <- out[grepl(icd_from, out$ICD_CODE) |
                 grepl(icd_to, out$ICD_CODE), ]

   return(out)
}
