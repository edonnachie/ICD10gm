#' Lookup an ICD-10 code in R
#'
#' This is a convenience function to quickly look up the label associated with
#' one or more ICD-10 codes. By default, it performs the lookup using the most
#' recent version of the ICD-10-GM available.
#'
#' This is a convenience function intended for interactive use. The browser will
#' only be opened if R is being used interactively. The function always returns
#' invisibly the URL of the page to be opened.
#'
#' @param icd ICD code to look up (any format that can be recognised by `icd_parse`)
#' @param year ICD-10-GM version to use (Default: most recent year available)
#' @param expand Should all subcodes of the given code be returned? (Default: TRUE)
#'
#' @return A tibble with three columns: (year, icd_sub, label) and one row for each result
#' @export
#' @seealso
#'    [icd_search()] to search for a string in the ICD-10-GM labels
#'    [icd_browse()] to lookup an ICD-10-GM code in the official BfArM documentation, opening the page in a browser
#' @examples
#' icd_lookup("E10.9")
#'
icd_lookup <- function(icd, year = NULL, expand = TRUE) {
  if (is.null(year))
    year_lookup <- max(ICD10gm::icd_meta_codes$year)

  if (!ICD10gm::is_icd_code(icd, year = year_lookup))
    stop("Please input one or more ICD-10 codes")

  icd_codes <- icd_parse(icd)

  if (expand) {
    icd_codes <- icd_expand(data.frame("icd_sub" = icd_codes$icd_sub),
                            year = year_lookup,
                            col_icd = "icd_sub")
  }

  return_which <- which(
    ICD10gm::icd_meta_codes$icd_sub %in% icd_codes$icd_sub &
      ICD10gm::icd_meta_codes$year == year_lookup
  )

  icd_meta_codes[return_which,
                 c("year", "icd_sub", "label")]
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
#' @param open_browser Whether to open the ICD-10-GM documentation in the default browser (Default: TRUE, as this is the primary intention of the function)
#'
#' @return Called for side-effect, but returns the URL invisibly
#'    [icd_search()] to search for a string in the ICD-10-GM labels
#'    [icd_lookup()] to lookup an ICD-10-GM code in the console
#' @export
#'
#' @examples
#' icd_browse("R50", open_browser = FALSE)
icd_browse <- function(icd3, year = NULL, open_browser = TRUE) {

  if (length(icd3) != 1) stop("icd must have length 1")
  if (nchar(icd3) != 3) stop("Must specify a 3-digit code (eg. A01)")

  if (is.null(year)){
    year_lookup <- max(ICD10gm::icd_meta_codes$year)
  } else {
    year_lookup <- year
  }


  icd <- icd3


  return_which <- which(
    ICD10gm::icd_meta_codes$icd3 == icd &
      ICD10gm::icd_meta_codes$level == 3 &
      ICD10gm::icd_meta_codes$year == year_lookup)

  icd <- merge(
    ICD10gm::icd_meta_codes[return_which,],
    ICD10gm::icd_meta_blocks,
    by = c("icd_block_first", "year")
  )[, c("year", "icd3", "group_id")]

  if (nrow(icd) == 0) stop("ICD-10 code not found")

  url <- paste0(
    "https://klassifikationen.bfarm.de/icd-10-gm/kode-suche/htmlgm",
    year_lookup,
    "/block-",
    tolower(icd$group_id),
    ".htm#", icd$icd3
    )

  if (is.null(url) | is.na(url)) {
    stop("Cannot generate URL")
  }

  if (interactive() & open_browser) utils::browseURL(url)

  invisible(url)
}


#' Search ICD-10-GM labels for a string
#'
#'
#'
#' @param pattern String to search for (character object of length 1)
#' @param level Maximum level of the ICD-10 hierarchy to search. level = 3 will search ohne 3-digit codes, level = 4 all 3 and 4 digit codes, level = 5 will search through all codes.
#' @param year Year in which to search (Default: most recent year available)
#' @param ignore.case Should the search be case insensitive? (Default: TRUE)
#' @param ... Further parameters passed to `agrep`
#'
#' @return Usually called for side-effect (open browser), returns the corresponding URL invisibly.
#' @export
#' @seealso
#'    [icd_browse()] to lookup an ICD-10-GM code in the official BfArM documentation, opening the page in a browser
#'    [icd_lookup()] to lookup an ICD-10-GM code in the console
#' @examples
#' icd_search("vitamin", level = 3)
#' icd_search("vitamin", level = 5)
icd_search <- function(pattern, level = 5, year = NULL, ignore.case = TRUE, ...) {
  stopifnot(is.character(pattern) & length(pattern) == 1)

  if (is_icd_code(pattern))
    stop("Input is an ICD-10-GM code. Did you mean to use icd_lookup()?")

  year_max <- max(ICD10gm::icd_meta_codes$year)
  year_lookup <- ifelse(is.null(year), year_max, year)
  stopifnot(is.numeric(year_lookup),
            year_lookup > 2004,
            year_lookup <= year_max)

  # Using base R here for comparison
  icd_current <- ICD10gm::icd_meta_codes[
    ICD10gm::icd_meta_codes$year == year_lookup &
      ICD10gm::icd_meta_codes$level <= level,
    , drop = FALSE
    ]

  icd_current[
    agrep(pattern, icd_current$label, ignore.case = ignore.case, ...),
    c("year", "icd3", "icd_sub", "label"),
    drop = FALSE
  ]
}

