#' Expand list of ICD codes to include all possible subcodes
#'
#' @param icd_in Data frame defining ICD codes of interest
#' @param year ICD 10 version
#' @param col_icd Column of icd_in containing ICD codes (Default: ICD)
#' @param col_meta (Optional) Columns containing meta information to retain (e.g. Grouper, age or other criteria for later use). If left NULL, only col_icd is retained.
#' @return data.frame with columns YEAR, ICD_CODE, ICD_COMPRESSED, ICD_LABEL and, if specified, columns specified by col_meta
#' @importFrom magrittr "%>%"
#' @export
icd_expand <- function (icd_in, year, col_icd = "ICD", col_meta = NULL)
{
  stopifnot(is.data.frame(icd_in), col_icd %in% names(icd_in),
            all(sapply(col_meta, function(x) x %in% names(icd_in))),
            as.integer(year) > 2003,
            as.integer(year) <= as.integer(substr(Sys.Date(), 1, 4)))
  # Which columns from icd_in should be kept
  cols_keep <- as.list(c("icd_spec", col_meta))

  # Cleanup input specification
  icd_in <- icd_in %>%
    dplyr::rename_(.dots = list(icd_spec = col_icd)) %>%
    dplyr::select_(.dots = cols_keep) %>%
    dplyr::filter(!is.na(icd_spec)) %>%
    dplyr::distinct()

  # ICD Metadata
  icd_labels <- ICD10gm::get_icd_labels(year = year)
    # dplyr::mutate(
    #   ICD_SUB = sub("\\.", "", ICD_CODE),
    #   YEAR = as.integer(YEAR)
    # )


  # Expand input specification,
  # retrieving all ICD codes that match specification
  do_expand <- function(icd_spec){
    i <- grep(icd_spec, icd_labels$icd_code)
    if (is.na(i) || length(i) == 0){
      warning("Incorrect ICD specification: ", icd_spec)
      return(data.frame())
    } else {
      return(icd_labels[i, ])
    }
  }

  icd_expand <- icd_in %>%
    dplyr::group_by_(.dots = cols_keep) %>%
    tidyr::nest() %>%
    dplyr::mutate(data = purrr::map(icd_spec, do_expand)) %>%
    tidyr::unnest()

  return(icd_expand)
}
