read_icd_labels <- function(year, file){
	if(year >= 2012){
		out <- cbind(
			year = year,
			read.csv2(file, skip = 1, header = FALSE,
								stringsAsFactors = FALSE,
								encoding = "UTF-8")
			)
	}
	if(year %in% 2011){
		out <- cbind(
			year = year,
			read.csv2(file, header = FALSE,
								stringsAsFactors = FALSE,
								encoding = "UTF-8")[, c(6, 9)]
			)
	}
	if(year %in% 2009:2010){
		out <- cbind(
			year = year,
			read.csv2(file, header = FALSE,
								stringsAsFactors = FALSE,
								encoding = "UTF-8")[, 6:7]
			)
	}
	names(out) <- c("YEAR", "ICD_CODE", "ICD_LABEL")
	out$ICD_CODE <- gsub("\\.?[-!X]", "", out$ICD_CODE)
	return(out)
}

a <-	read_icd_labels(2015, "data-raw/labels/icd10gm2015syst.txt")
icd_labels <- rbind(
	read_icd_labels(2015, "data-raw/labels/icd10gm2015syst.txt"),
	read_icd_labels(2014, "data-raw/labels/icd10gm2014syst.txt"),
	read_icd_labels(2013, "data-raw/labels/icd10gm2014syst.txt"),
	read_icd_labels(2012, "data-raw/labels/icd10gm2014syst.txt"),
	read_icd_labels(2011, "data-raw/labels/icd10gmsyst_kodes2011.txt"),
	read_icd_labels(2010, "data-raw/labels/icd10gm2010alpha_edv_ascii_20091030.txt"),
	read_icd_labels(2009, "data-raw/labels/icd10gm2009alpha_edv_ascii_20081006.txt")
)

#saveRDS(icd_labels, file = "data/icd_labels.rds")
