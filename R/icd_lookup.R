#' Lookup an ICD-10 code
#'
#' This is a convenience function to quickly look up the label associated with
#' one or more ICD-10 codes. By default, it performs the lookup using the most
#' recent version of the ICD-10-GM available.
#'
#' This is a convenience function intended for interactive use.
#'
#' @param icd ICD code to look up (any format that can be recognised by `icd_parse`)
#' @param year ICD-10-GM version to use (Default: most recent year available)
#' @param expand Should all subcodes of the given code be returned? (Default: TRUE)
#'
#' @return A tibble with three columns: (year, icd_sub, label) and one row for each result
#' @export
#' @seealso [icd_browse()] to browse the official BfArM documentation in a browser
#'
#' @examples
#' icd_lookup("E10.9")
#'
icd_lookup <- function(icd, year = NULL, expand = TRUE) {
  if (is.null(year))
    year_lookup <- max(ICD10gm::icd_meta_codes$year)

  if (!is_icd_code(icd, year = year_lookup))
    stop("Please input one or more ICD-10 codes")

  icd_codes <- icd_parse(icd)

  if (expand) {
    icd_codes <- icd_expand(data.frame("icd_sub" = icd_codes$icd_sub),
                            year = year_lookup,
                            col_icd = "icd_sub")
  }

  ICD10gm::icd_meta_codes %>%
    dplyr::select(year, icd_sub, label) %>%
    dplyr::filter(
      icd_sub %in% icd_codes$icd_sub,
      year == year_lookup
    )
}


#' Lookup a 3-digit ICD-10-GM code in the official BfArM browser
#'
#' Given a 3-digit ICD-10-GM code, this function will generate the URL of the
#' corresponding page of the BfArM ICD-10-GM browser, and use `browseURL()` to
#' open it.
#'
#' This currently provides the correct URL for ICD-10-GM versions from 2009.
#' Given that BfArM are still using the old dimdi.de domain for this purpose,
#' it is possible that the URL schema will change in the near future.
#'
#' This is a convenience function intended for interactive use.
#'
#' @param icd3 3-digit ICD-10-GM code (e.g. "A01")
#' @param year ICD-10-GM version (default: most recent available version). Only works for year >= 2009.
#'
#' @return Called for side-effect, but returns the URL invisibly
#' @seealso [icd_lookup()] to lookup one or more codes in the R console
#' @export
#'
#' @examples
#' icd_browse("E10")
icd_browse <- function(icd3, year = NULL) {

  if (length(icd3) != 1) stop("icd must have length 1")
  if (nchar(icd3) != 3) stop("Must specify a 3-digit code (eg. A01)")

  if (is.null(year)){
    year_lookup <- max(ICD10gm::icd_meta_codes$year)
  } else {
    year_lookup <- year
  }


  icd <- icd3

  icd <- ICD10gm::icd_meta_codes %>%
    dplyr::filter(
      icd3 == icd,
      level == 3,
      year == year_lookup
    ) |>
    dplyr::inner_join(ICD10gm::icd_meta_blocks,
                      by = c("icd_block_first", "year")) |>
    dplyr::select(year, icd3, group_id)

  if (nrow(icd) == 0) stop("ICD-10 code not found")

  url <- paste0(
    "https://www.dimdi.de/static/de/klassifikationen/icd/icd-10-gm/kode-suche/htmlgm",
    year_lookup,
    "/block-",
    tolower(icd$group_id),
    ".htm#{icd$icd3}")

  if (is.null(url) | is.na(url)) {
    stop("Cannot generate URL")
  }
  utils::browseURL(url)
  invisible(url)
}
