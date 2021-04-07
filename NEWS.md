# ICD10gm 1.2
This is a minor update:

- Added new ICD-10-GM data for the year 2021
- Lazy data are now compressed using the xy algorithm (#15)
- Corrected `ìcd_meta_chapters` table (missing chapter 1, #14)
- Added new codes introduced for Covid-19 to the 2020 and 2021 versions
- New vignette "Coding the Covid-19 pandemic in Germany"


# ICD10gm 1.1
This is a minor update:

- Added new ICD-10-GM data for the year 2020
- Add reserved codes that are defined as needed after release of download files (e.g. COVID-19)
- Improvements to documentation and cross-referencing of functions
- New hex logo


# ICD10gm 1.0.4

Minor updates in preparation for tidyr 1.0, primarily ensuring consistency of type.

# ICD10gm 1.0.3

CRAN resubmission:

- The Description has been changed according to CRAN guidelines (Deleted "The ICD10gm package")
- Examples have been added to the Rd files
- Vignette no longer evaluates web-scraping example
- Further minor improvements to documentation
