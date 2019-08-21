#' Expand list of ICD codes to include all possible subcodes
#'
#' The function `icd_expand` takes a data.frame containing ICD codes
#' and optional metadata as input. It returns a data.frame containing
#' all ICD codes at or below the specified level of the hierarchy
#' (e.g. the specification "E11" is expanded to include all three,
#' four and five-digit codes beginning with E11).
#'
#' @param icd_in Data frame defining ICD codes of interest
#' @param year ICD 10 version
#' @param col_icd Column of icd_in containing ICD codes (Default: ICD)
#' @param col_meta (Optional) Columns containing meta information to retain (e.g. Grouper, age or other criteria for later use). If left NULL, only col_icd is retained.
#' @param type A character string determining how strictly matching should be performed, passed to `icd_parse`. This must be one of "strict" (`str` contains a ICD code with no extraneous characters), `bounded` (`str` contains an ICD code with a word boundary on both sides) or `weak` (ICD codes are extracted even if they are contained within a word, e.g. "E10Diabetes" would return "E10"). Default: `strict`.
#' @param ignore_icd_errors logical. Whether to ignore incorrectly specified input (potentially leading to incomplete output) or stop if any ICD specification does not correspond to a valid ICD code. Default: `FALSE`, stop on error.
#' @return data.frame with columns YEAR, ICD_CODE, ICD_COMPRESSED, ICD_LABEL and, if specified, columns specified by col_meta
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom tidyselect one_of
#' @examples
#' # Incomplete or non-terminal codes expand to the right.
#' # This is useful to specified code blocks in a compact manner
#' icd_meta <- data.frame(ICD = "R1")
#' icd_expand(icd_meta, year = 2019)
#'
#' # Optional metadata columns can be carried
#' # through with the specification
#' icd_meta <- data.frame(ICD = "M54", icd_label = "Back pain")
#' icd_expand(icd_meta, year = 2019, col_meta = "icd_label")
#'
#' @export
icd_expand <- function (icd_in,
                        year,
                        col_icd = "ICD",
                        col_meta = NULL,
                        type = "strict",
                        ignore_icd_errors = FALSE)
{
  stopifnot(is.data.frame(icd_in), col_icd %in% names(icd_in),
            all(sapply(col_meta, function(x) x %in% names(icd_in))),
            as.integer(year) > 2003,
            as.integer(year) <= as.integer(substr(Sys.Date(), 1, 4)))
  # Which columns from icd_in should be kept
  cols_keep <- c("icd_spec", col_meta)

  # ICD Metadata
  icd_labels <- ICD10gm::get_icd_labels(year = year)

  # Cleanup input specification
  names(icd_in)[which(names(icd_in) == col_icd)] <- "icd_spec"
  if (is.factor(icd_in$icd_spec))
    icd_in$icd_spec <- as.character(icd_in$icd_spec)

  icd_in <- icd_in[, cols_keep, drop = FALSE]
  icd_in <- unique(icd_in[!is.na(icd_in$icd_spec), , drop = FALSE])

  # Validate Input
  # and determine which are ICD codes (i.e. at least 3 digits)
  # and which are prefixes (e.g. "A" or "A0")
  spec_is_code <- is_icd_code(icd_in$icd_spec)
  spec_is_prefix <- vapply(
    icd_in$icd_spec,
    function(x) any(grepl(pattern = paste0("^", x), icd_labels$icd_sub)),
    FUN.VALUE = TRUE) & !spec_is_code

  # Convert all ICD codes to icd_sub form
  # (leave prefixes alone)
  if (any(spec_is_code)) {
    icd_in$icd_spec[spec_is_code] <- ICD10gm::icd_parse(
      icd_in$icd_spec[spec_is_code],
      type = "strict")$icd_sub
    icd_in <- unique(icd_in)
  }

  # Deal with incorrect specifications (stop or warning)
  icd_errors <- icd_in$icd_spec[!spec_is_code & !spec_is_prefix]
  if (length(icd_errors) > 0) {
    msg <- paste0("Incorrect ICD specification: ",
                  paste(icd_errors, collapse = ", "))

    if (ignore_icd_errors)
      warning(msg)
    else
      stop(msg)
  }

  # Expand input specification,
  # retrieving all ICD codes that match specification
  do_expand <- function(icd_spec, icd_labels){
    # Return all codes that match the parsed icd_sub
    i <- grep(icd_spec, icd_labels$icd_sub)
    if (length(i) == 0){
      # This shouldn't occur if ignore_icd_errors == FALSE (default)
      return(data.frame())
    } else {
      return(icd_labels[i, ])
    }
  }

  # Expand each specified code in turn
  # Due to breaking changes in tidyr 1.0,
  # we need two versions of unnest,
  # implemented in the following function
  # See https://tidyr.tidyverse.org/dev/articles/in-packages.html
  unnest_icd_expand <- function(df) {
    if (utils::packageVersion("tidyr") > "0.8.99") {
      tidyr::unnest(df, cols = tidyselect::one_of("data"))
    } else {
      tidyr::unnest(df)
    }
  }

  icd_expand <- icd_in %>%
    dplyr::select(tidyselect::one_of(cols_keep)) %>%
    dplyr::distinct() %>%
    dplyr::mutate(data = purrr::map(.data$icd_spec, do_expand,
                                   icd_labels = icd_labels)) %>%
    unnest_icd_expand()

  return(tibble::as_tibble(icd_expand))
}
