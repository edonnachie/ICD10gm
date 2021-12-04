## Minor package update

This is a minor update:

- Data for the year 2022
- Corrected `charlson_rcs` specification (F00-F03 on separate lines, #16)
- Replaced `icd_showchanges` with an equivalent query on `icd_meta_transitions`. The new function takes a data.frame created by `icd_expand`, extracts all code changes within a specified period (years), and adds labels for the old and new ICD-10-GM codes.


## Test environments
* local Ubuntu 18.04 install: R 4.0.5
* CI using Github Actions (window + macOS release, Ubuntu release + devel)
* rhub (debian, ubuntu, macos, windows)
* winbuilder (devel, release)

## R CMD check results

0 errors | 0 warnings | 0 notes
