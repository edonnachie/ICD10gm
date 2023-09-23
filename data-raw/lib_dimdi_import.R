## Extract required files ----
define_meta_files <- function(version) {
  if (as.numeric(version) == 2024) {
    zip_transition <- here::here(glue::glue("data-raw/dimdi/ueberleitung/icd10gm2024syst-ueberl.zip"))
    files_transition <- glue::glue("Klassifikationsdateien/icd10gm{version}syst_umsteiger_{as.numeric(version)-1}_20221206_{version}.txt")
    zip_meta <- here::here(glue::glue("data-raw/dimdi/systematik/icd10gm2024syst-meta.zip"))
    files_meta <- paste0("Klassifikationsdateien/icd10gm", version, "syst_", c("kodes", "kapitel", "gruppen"), ".txt")
  } else if (as.numeric(version) == 2023) {
      zip_transition <- here::here(glue::glue("data-raw/dimdi/ueberleitung/icd10gm2023syst-ueberl_20221206.zip"))
      files_transition <- glue::glue("Klassifikationsdateien/icd10gm{version}syst_umsteiger_{as.numeric(version)-1}_{version}_20221206.txt")
      zip_meta <- here::here(glue::glue("data-raw/dimdi/systematik/icd10gm2023syst-meta_20221206.zip"))
      files_meta <- paste0("Klassifikationsdateien/icd10gm", version, "syst_", c("kodes_20221206", "kapitel", "gruppen"), ".txt")
    } else if (as.numeric(version) == 2021) {
      zip_transition <- here::here(glue::glue("data-raw/dimdi/ueberleitung/icd10gm{version}syst-ueberl-20201111.zip"))
      files_transition <- glue::glue("Klassifikationsdateien/icd10gm{version}syst_umsteiger_{as.numeric(version)-1}_{version}.txt")
      zip_meta <- here::here(glue::glue("data-raw/dimdi/systematik/icd10gm{version}syst-meta-20201111.zip"))
      files_meta <- paste0("Klassifikationsdateien/icd10gm", version, "syst_", c("kodes", "kapitel", "gruppen"), ".txt")
    } else if (as.numeric(version) >= 2019) {
      zip_transition <- here::here(glue::glue("data-raw/dimdi/ueberleitung/icd10gm{version}syst-ueberl.zip"))
      files_transition <- glue::glue("Klassifikationsdateien/icd10gm{version}syst_umsteiger_{as.numeric(version)-1}_{version}.txt")
      zip_meta <- here::here(glue::glue("data-raw/dimdi/systematik/icd10gm{version}syst-meta.zip"))
      files_meta <- paste0("Klassifikationsdateien/icd10gm", version, "syst_", c("kodes", "kapitel", "gruppen"), ".txt")
    } else if (as.numeric(version) >= 2015) {
      zip_transition <- here::here(glue::glue("data-raw/dimdi/ueberleitung/x1gut{version}.zip"))
      files_transition <- glue::glue("Klassifikationsdateien/icd10gm{version}syst_umsteiger_{as.numeric(version)-1}_{version}.txt")
      zip_meta <- here::here(glue::glue("data-raw/dimdi/systematik/x1gmt{version}.zip"))
      files_meta <- paste0("Klassifikationsdateien/icd10gm", version, "syst_", c("kodes", "kapitel", "gruppen"), ".txt")
    } else if (as.numeric(version) >= 2013) {
      zip_transition <- here::here(glue::glue("data-raw/dimdi/ueberleitung/x1gua{version}.zip"))
      files_transition <- glue::glue("Klassifikationsdateien/icd10gm{version}syst_umsteiger_{as.numeric(version)-1}_{version}.txt")
      zip_meta <- here::here(glue::glue("data-raw/dimdi/systematik/x1gma{version}.zip"))
      files_meta <- paste0("Klassifikationsdateien/icd10gm", version, "syst_", c("kodes", "kapitel", "gruppen"), ".txt")
    } else if (as.numeric(version) >= 2009) {
      zip_transition <- here::here(glue::glue("data-raw/dimdi/ueberleitung/x1ueb{as.numeric(version) - 1}_{version}.zip"))
      files_transition <- glue::glue("Klassifikationsdateien/umsteiger_icd10gmsyst{as.numeric(version)-1}_icd10gmsyst{version}.txt")
      zip_meta <- here::here(glue::glue("data-raw/dimdi/systematik/x1gma{version}.zip"))
      files_meta <- paste0("Klassifikationsdateien/icd10gmsyst_", c("kodes", "kapitel", "gruppen"), version, ".txt")
    } else if (as.numeric(version) == 2008) {
      zip_transition <- here::here(glue::glue("data-raw/dimdi/ueberleitung/x1ueb{as.numeric(version) - 1}_{version}.zip"))
      files_transition <- glue::glue("Klassifikationsdateien/umsteiger{as.numeric(version)-1}{version}.txt")
      zip_meta <- here::here(glue::glue("data-raw/dimdi/systematik/x1gma{version}.zip"))
      files_meta <- paste0("Klassifikationsdateien/", c("codes", "kapitel", "gruppen"), version, ".txt")
    } else if (as.numeric(version) == 2007) {
      zip_transition <- here::here(glue::glue("data-raw/dimdi/ueberleitung/x1ueb{as.numeric(version) - 1}_{version}.zip"))
      files_transition <- glue::glue("Klassifikationsdateien/Umsteiger.txt")
      zip_meta <- here::here(glue::glue("data-raw/dimdi/systematik/x1gma{version}.zip"))
      files_meta <- paste0("Klassifikationsdateien/", c("CODES", "KAPITEL", "GRUPPEN"), ".txt")
    } else if (as.numeric(version) == 2006) {
      zip_transition <- here::here(glue::glue("data-raw/dimdi/ueberleitung/x1ueb{as.numeric(version) - 1}_{version}.zip"))
      files_transition <- glue::glue("umsteiger.txt")
      zip_meta <- here::here(glue::glue("data-raw/dimdi/systematik/x1gma{version}.zip"))
      files_meta <- paste0(c("codes", "kapitel", "gruppen"), ".txt")
    } else if (as.numeric(version) == 2005) {
      zip_transition <- here::here(glue::glue("data-raw/dimdi/ueberleitung/x1ueb{as.numeric(version) - 1}_{version}.zip"))
      files_transition <- glue::glue("umsteiger.txt")
      zip_meta <- here::here(glue::glue("data-raw/dimdi/systematik/x1gma{version}.zip"))
      files_meta <- paste0(c("CODES", "KAPITEL", "GRUPPEN"), ".txt")
    } else if (as.numeric(version) == 2004) {
      zip_transition <- ""
      files_transition <- ""
      zip_meta <- here::here(glue::glue("data-raw/dimdi/systematik/x1gma{version}.zip"))
      files_meta <- paste0(c("codes", "Kapitel", "gruppen"), ".txt")
    } else {
      stop(paste("Procedure not defined for version", version))
    }

  list("version" = version,
       "zip_transition" = zip_transition,
       "files_transition" = files_transition,
       "zip_meta" = zip_meta,
       "files_meta" = files_meta)
}

## Extract files ----
extract_icd_meta_files <- function(version) {
  message(paste("Extracting files for ICD-10-GM", version))

  f <- define_meta_files(version)


  stopifnot(version == 2004 | file.exists(f$zip_transition),
            file.exists(f$zip_meta))

  ## Transition from previous version
  # message(paste("Extracting", paste(f$files_transition, collapse="\n"), "from", f$zip_transition))
  if (as.numeric(version) > 2004) {
    unzip(
      zipfile = f$zip_transition,
      files = f$files_transition,
      junkpaths = TRUE,
      exdir = paste0("data-raw/", version)
    )
  }

  # Systematik
  # icd10gm2018syst_kodes
  # message(glue::glue("Extracting {f$files_meta} from {f$zip_meta}\n"))
  unzip(
    zipfile = f$zip_meta,
    files = f$files_meta,
    junkpaths = TRUE,
    exdir = paste0("data-raw/", version)
  )
  invisible(TRUE)
}

## Functions to read in classification metadata ---
read_icd_codes <- function(version) {
  f <- define_meta_files(version)$files_meta

  f_codes <- basename(f[grep("[kc]odes", f, ignore.case = TRUE)])
  f_codes <- here::here(paste0("data-raw/", version ,"/", f_codes))

  if (!file.exists(f_codes))
    stop("Cannot find file", f_codes)

  out <- cbind(
    year = version,
    read.csv2(f_codes, skip = 1, header = FALSE,
              stringsAsFactors = FALSE,
              encoding = "UTF-8")
  )

  #  Versions 2004 - 2012 don't have labels for ICD3, 4, 5
  if (version >= 2004 & version <= 2012) {
    out <- cbind(
      out[, 1:10],
      data.frame(lab3 = NA, lab4 = NA, lab5 = NA),
      out[, 11:ncol(out)]
    )
  }
  # Remove alternative forms for age_min and age_max
  if (version >= 2005 & version <= 2017) {
    out <- out[, -c(23, 25)]
  }
  # Version 2004 only has the alternative age_min, age_max
  # that is dropped above. We can do without this information...
  if (version == 2004) {
    out <- cbind(
      out[, 1:22],
      data.frame(X = NA, Y = NA, Z = NA),
      out[, 26:ncol(out)],
      data.frame(NOTIFY = NA, NOTIFY_LAB = NA)
    )
  }


  names(out) <- read.csv(here::here("data-raw/desc_icd_meta_codes.csv"), stringsAsFactors = FALSE)$variable
  return(out)
}
read_icd_blocks <- function(version) {
  f <- define_meta_files(version)$files_meta

  f_gruppen <- basename(f[grep("gruppen", f, ignore.case = TRUE)])
  f_gruppen <- here::here(paste0("data-raw/", version ,"/", f_gruppen))

  out <- cbind(
    year = version,
    read.csv2(f_gruppen, skip = 0, header = FALSE,
              stringsAsFactors = FALSE,
              encoding = ifelse(version < 2010, "latin1", "UTF-8"))
  )
  # Version 2004 does not have chapter
  if (version == 2004) {
    out <- dplyr::bind_cols(
      out[, 1:2],
      tibble::tibble("chapter" = rep(NA_integer_, times = nrow(out))),
      out[, 3, drop = FALSE]
    )
  }
  # Versions prior to 2007 do not have icd_block_last
  if (version < 2007) {
    out <- dplyr::bind_cols(
      out[, 1:2],
      tibble::tibble("icd_block_last" = rep(NA_character_, times = nrow(out))),
      out[, 3:4]
    )
  }
  names(out) <- c("year", "icd_block_first", "icd_block_last",
                  "chapter", "block_label")
  return(out)
}
read_icd_chapters <- function(version) {
  f <- define_meta_files(version)$files_meta

  f_kapitel <- basename(f[grep("kapitel", f, ignore.case = TRUE)])
  f_kapitel <- here::here(paste0("data-raw/", version ,"/", f_kapitel))

  out <- cbind(
    year = version,
    read.csv2(f_kapitel, skip = 0, header = FALSE,
              stringsAsFactors = FALSE,
              encoding = ifelse(version < 2010, "latin1", "UTF-8"))
  )
  names(out) <- c("year", "chapter", "chapter_label")
  return(out)
}

read_icd_transitions <- function(version) {
  f <- basename(define_meta_files(version)$files_transition)

  f_transition <- here::here(paste0("data-raw/", version ,"/", f))

  out <- cbind(
    year_from = version - 1,
    year_to = version,
    read.csv2(f_transition, skip = 1, header = FALSE,
              stringsAsFactors = FALSE,
              encoding = ifelse(version < 2010, "latin1", "UTF-8"))
  )
  names(out) <- c("year_from", "year_to", "icd_from", "icd_to",
                  "automatic_forward", "automatic_backward")
  out$year_from <- as.integer(out$year_from)
  out$year_to <- as.integer(out$year_to)
  return(out)
}
