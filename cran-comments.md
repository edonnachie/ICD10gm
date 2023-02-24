## Minor package update

This is a minor update:

- Data for the year 2023
- Three new interactive lookup functions (icd_lookup, icd_browse, icd_search)
- Replaced outdated URLs in the "Coding the Pandemic" vignette with archive.org snapshots



## Test environments
* local Ubuntu 22.04 install: R 4.2.2
* CI using Github Actions (window + macOS release, Ubuntu release + devel)
* rhub (debian, ubuntu, macos, windows)
* winbuilder (devel, release)

## R CMD check results

0 errors | 0 warnings | 1 note

I provide a link to the data provider BfArM at https://www.bfarm.de.
Unfortunately, this redirects to a page within the domain, resulting in
a CRAN note. Similarly, CRAN is unable to check a JSTOR URL, and I am unable
to find an alternative.
