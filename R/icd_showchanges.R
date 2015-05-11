#' Show all changes in ICD history relating to the 
#' 3-digit codes contained in icd_in
#' @param icd_in Data frame defining ICD codes of interest
#' @param col_icd Column of icd_in containing ICD codes (Default: ICD)
#' @return data.frame with columns YEAR, ICD_CODE, ICD_LABEL and, if specified, DIAG_GROUP
#' @export
icd_showchanges <- function(icd_in, year = NULL,
											 col_icd = "ICD",
											 label = TRUE){
	
	icd3_in <- unique(substr(icd_in[, col_icd], 1, 3))

	icd_changes <- subset(icd_hist, icd3 %in% icd3_in & change == TRUE)
	
	return(icd_changes)
}

