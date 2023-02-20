#' Lookup an ICD-10 code
#'
#' @param icd ICD code to look up (any format that can be recognised by `icd_parse`)
#'
#' @return A tibble with three columns: (year, icd_sub, label) and one row for each result
#' @export
#'
#' @examples
#' icd_lookup("E10.9")
#'
icd_lookup <- function(icd) {
  stopifnot(is.character(icd))

  icd_codes <- icd_parse(icd)$icd_sub

  subset(
    ICD10gm::icd_meta_codes,
    icd_sub %in% icd_codes & year == max(ICD10gm::icd_meta_codes$year),
    select = c("year", "icd_sub", "label")
  )
}
