#' Expand list of ICD codes to include all possible subcodes
#'
#' @param icd_in Data frame defining ICD codes of interest
#' @param year ICD 10 version
#' @param col_icd Column of icd_in containing ICD codes (Default: ICD)
#' @param col_meta (Optional) Columns containing meta information to retain (e.g. Grouper, age or other criteria for later use). If left NULL, only col_icd is retained.
#' @return data.frame with columns YEAR, ICD_CODE, ICD_COMPRESSED, ICD_LABEL and, if specified, columns specified by col_meta
#' @export
icd_expand <- function(icd_in, year,
											 col_icd = "ICD",
											 col_meta = NULL){
	stopifnot(
			is.data.frame(icd_in),
			col_icd %in% names(icd_in),
			all(sapply(col_meta, function(x) x %in% names(icd_in))),
			as.integer(year) > 1992,
			as.integer(year) <= as.integer(substr(Sys.Date(), 1, 4))
			)

	icd_in <- unique(icd_in[, c(col_icd, col_meta)])


	icd_labels <- subset(icd_labels, YEAR == year)

	icd_expand <- plyr::ddply(icd_in, c(col_icd, col_meta),
											function(icd){
												i <- grepl(icd[[col_icd]], icd_labels$ICD_CODE)
												if(any(i))
													icd_labels[i, ]
											})

	names(icd_expand)[1:{1 + length(col_meta)}] <- c("ICD_SPEC", col_meta)
	icd_expand$ICD_COMPRESSED <- sub("\\.", "", icd_expand$ICD_CODE)
	icd_expand$YEAR <- as.integer(icd_expand$YEAR)

	return(icd_expand)
}
