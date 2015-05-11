read_umsteiger <- function(file, year, header=FALSE, sep=";"){
	um <- cbind(
		year - 1, year,
		read.table(file, header=header, sep=sep, as.is = TRUE)[, 1:3]
	)
	names(um) <- c("year_from", "year_to", 
								 "icd_from", "icd_to", "auto")
	return(um)
}

icd_hist <- rbind(
	read_umsteiger("data-raw/transition/Umsteiger_2003_2004.txt", 2004),
	read_umsteiger("data-raw/transition/umsteiger_2004_2005.txt", 2005),
	read_umsteiger("data-raw/transition/umsteiger_2005_2006.txt", 2006),
	read_umsteiger("data-raw/transition/Umsteiger_2006_2007.txt", 2007),
	read_umsteiger("data-raw/transition/umsteiger20072008.txt", 2008),
	read_umsteiger("data-raw/transition/umsteiger_icd10gmsyst2008_icd10gmsyst2009.txt", 2009),
	read_umsteiger("data-raw/transition/umsteiger_icd10gmsyst2009_icd10gmsyst2010.txt", 2010),
	read_umsteiger("data-raw/transition/umsteiger_icd10gmsyst2010_icd10gmsyst2011.txt", 2011),
	read_umsteiger("data-raw/transition/umsteiger_icd10gmsyst2011_icd10gmsyst2012.txt", 2012),
	read_umsteiger("data-raw/transition/icd10gm2013syst_umsteiger_2012_2013.txt", 2013),
	read_umsteiger("data-raw/transition/icd10gm2014syst_umsteiger_2013_2014.txt", 2014)
	)

icd_hist <- within(icd_hist, {
	icd_kapitel <- substr(icd_to, 1, 1)
	icd3 <- substr(icd_to, 1, 3)
	change <- (icd_to != icd_from)
	change_3 <- (substr(icd_from, 1, 3) != substr(icd_to, 1, 3))
	change_4 <- (substr(icd_from, 1, 4) != substr(icd_to, 1, 3) &! change_3)
	change_5 <- (substr(icd_from, 1, 5) != substr(icd_to, 1, 5) &! change_3 &! change_4)
})

#saveRDS(icd_hist, file = "data/icd_history.rds")
