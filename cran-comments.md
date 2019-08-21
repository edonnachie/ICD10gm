## Minor package update

This is a minor update:

- Minor reworking to ensure compatibility with the upcoming release of tidyr 1.0
- Minor improvements in the handling of historic data from 2004 (avoid NA in strings)


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
