## Resubmission

This is a resubmission:

- The Description has been changed according to CRAN guidelines (Deleted "The ICD10gm package")
- Examples have been added to the Rd files
- Vignette no longer evaluates web-scraping example
- Further minor improvements to documentation


## Test environments
* local Ubuntu 14.04 install: R 3.4.4
* ubuntu 14.04 (on travis-ci): Rdevel, R 3.5.1, R 3.4.4
* local windows 7: R 3.5.1
* rhub (debian, ubuntu, macos, windows)
* winbuilder (devel)

## R CMD check results

0 errors | 0 warnings | 2 notes


There were 2 NOTEs:

* checking installed package size ... NOTE
  installed size is  7.6Mb
    sub-directories of 1Mb or more:
    data   6.8Mb
  
  The provision of this data is a core contribution of the package. File size
  has been minimised using xz compression (chosen by `tools::checkRdaFiles`)


*  checking data for non-ASCII characters (4.8s)
     Note: found 252748 marked UTF-8 strings

  German special characters have been converted uniformly to UTF-8. In the
  original data, a mixture of coding systems are used that were difficult
  to handle in R.


* This is a new release.
