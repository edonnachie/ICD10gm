## Minor package update

This is a minor update:

- "LazyDataCompression: xz" added to the DESCRIPTION, decreasing package size considerably
- ICD-10-GM data for the year 2021
- Corrected `ìcd_meta_chapters` table (missing chapter 1)
- New vignette "Coding the Covid-19 pandemic in Germany"
- Added small supplementary datasets specifying two different versions of the Charlson comorbidities


## Test environments
* local Ubuntu 18.04 install: R 4.0.5
* CI using Github Actions (window + macOS release, Ubuntu release + devel)
* rhub (debian, ubuntu, macos, windows)
* winbuilder (devel, release)

## R CMD check results

0 errors | 0 warnings | 0 notes
