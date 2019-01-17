# ICD10gm

[![Travis build status](https://travis-ci.org/edonnachie/ICD10gm.svg?branch=master)](https://travis-ci.org/edonnachie/ICD10gm) [![CRAN status](https://www.r-pkg.org/badges/version/ICD10gm)](https://cran.r-project.org/package=ICD10gm)  [![DOI](https://zenodo.org/badge/52161087.svg)](https://zenodo.org/badge/latestdoi/52161087)



An R Package for Working with the German Modification of the International Statistical Classification of Diseases and Related Health Problems

## About this Package

The ICD-10 classification of diseases and related health problems (ICD-10) is an international standard for the coding of health service data. In Germany, the [German Instutite of Medical Documentation and Information (DIMDI)](https://www.dimdi.de) releases a German Modification (ICD-10-GM) of the classification that forms a compulsory part of all remuneration claims in the ambulatory and hospital sectors.

This package was created to facilitate the analysis of data coded using the ICD-10-GM. In particular, it has the following aims:

1. Provide convenient access to the extended ICD-10-GM metadata
2. Identify and extract ICD-10 codes from character strings
3. Facilitate the specification of ICD codes for analysis, utilising the ICD hierarchy (e.g. given the specification "A0" return all subcodes in the range "A01" to "A09")
3. Enable the historization of ICD specifications by applying the automatic code transitions provided by DIMDI, identifying potentially problematic codes

ICD10gm is designed for use in the context of medical and health services research using routinely collected claims data. It is not suitable for use in operative coding as it does not include all relevant metadata (e.g. inclusion and exclusion notes and the detailed definitions of psychiatric diagnoses). The metadata provided in the ICD10gm package is not intended to replace the [official DIMDI documentation](https://www.dimdi.de/dynamic/de/klassifikationen/icd/icd-10-gm/), which should always be consulted when specifying ICD codes for analysis.


## Getting Started

The package is not (yet) available from CRAN but can be installed from github as follows:

```{r}
# Install the devtools package if not already installed
if (!("devtools" %in% .packages(all.available=TRUE))) install.package("devtools")

# Install ICD10gm package from github
devtools::install_github("edonnache/ICD10gm")
```

## Basic Use

The core functionality of the package is demonstrated in the [accompanying vignette](https://edonnachie.github.io/ICD10gm/docs/articles/icd10gm-intro.Rmd).


## Copyright

Program code is released under the [MIT license](https://edonnachie.github.io/ICD10gm/LICENSE-text.html).

The underlying ICD-10-GM metadata is copyright of the [German Instutite of Medical Documentation and Information (DIMDI)](https://www.dimdi.de). The source files are available free of charge from the [DIMDI Download Centre](https://www.dimdi.de/dynamic/de/klassifikationen/downloads/?dir=icd-10-gm). I believe that their use in this package is compatible with the copyright restrictions. In particular:

- The distribution of an "added-value product" derived from the original DIMDI classification files is expressly permitted.

- Distribution of the original classification files is forbidden. Consequently, this package distributes only the code required to process these files. Those wishing to compile the data from scratch must download the files from the DIMDI download centre and agree to the copyright restrictions.

- The package does not modify the ICD-10-GM codes, texts or other metadata in any way other than to restructure the data into a convenient form.

- The package does not contain any commercial advertising.

- The source of the data is clearly stated, both here and in the package documentation.



## Related Packages

The [icd package](https://cran.r-project.org/web/packages/icd/) on CRAN has similar aims but has a slightly different approach and focusses on the US version of the ICD-10 system.
