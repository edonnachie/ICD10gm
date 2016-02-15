#' Show all changes in ICD history relating to the 
#' 3-digit codes contained in a given vector icd
#'
#' @param icd Vector of three-digit ICD codes
#' @return data.frame with columns YEAR, ICD_CODE, ICD_LABEL and, if specified, DIAG_GROUP
#' @export
icd_showchanges_icd3 <- function(icd3_in){
	subset(icd_hist, icd3 %in% icd3_in & change == TRUE)
}

#' Show all changes in ICD history relating to the 
#' 3-digit codes contained in the data.frame icd_in.
#' The output of icd_expand can be passed directly to this
#' function to display relevant changes.
#'
#' @param icd_in Data frame defining ICD codes of interest
#' @param col_icd Column of icd_in containing ICD codes (Default: ICD)
#' @return data.frame with columns YEAR, ICD_CODE, ICD_LABEL and, if specified, DIAG_GROUP
#' @export
icd_showchanges <- function(icd_in, col_icd = "ICD"){
	icd3_in <- unique(substr(icd_in[, col_icd], 1, 3))
	icd_showchanges_icd3(icd3_in)
}
