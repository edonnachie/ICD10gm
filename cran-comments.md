## Minor package update

This is a minor update:

- Added new ICD-10-GM data for the year 2020
- Add reserved codes that are defined as needed after release of download files (e.g. COVID-19)
- Improvements to documentation and cross-referencing of functions
- New hex logo


## Test environments
* local Ubuntu 14.04 install: R 3.6.1
* ubuntu 14.04 (on travis-ci): devel, release, oldrel, release + tidyr-devel
* rhub (debian, ubuntu, macos, windows)
* winbuilder (devel, release)

## R CMD check results

0 errors | 0 warnings | 1 notes


There was 1 NOTE:

* checking installed package size ... NOTE
  installed size is  7.6Mb
    sub-directories of 1Mb or more:
    data   6.8Mb
  
  The provision of this data is a core contribution of the package. File size
  has been minimised using xz compression (chosen by `tools::checkRdaFiles`)
