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
