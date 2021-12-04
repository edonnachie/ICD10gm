# ICD10gm <img src="man/figures/logo.png" align="right" width="20%" height = "20%" />

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) [![R-CMD-check](https://github.com/edonnachie/ICD10gm/workflows/R-CMD-check/badge.svg)](https://github.com/edonnachie/ICD10gm/actions) [![CRAN status](https://www.r-pkg.org/badges/version/ICD10gm)](https://cran.r-project.org/package=ICD10gm)  [![DOI](https://zenodo.org/badge/52161087.svg)](https://zenodo.org/badge/latestdoi/52161087)



An R Package for Working with the German Modification of the International Statistical Classification of Diseases and Related Health Problems

## About this Package

The ICD-10 classification of diseases and related health problems (ICD-10) is an international standard for the coding of health service data. In Germany, the [Federal Institute for Drugs and Medical Devices](https://www.bfarm.de) releases a German Modification (ICD-10-GM) of the classification that forms a compulsory part of all remuneration claims in the ambulatory and hospital sectors.

This package was created to facilitate the analysis of data coded using the ICD-10-GM. In particular, it has the following aims:

1. Provide convenient access to the extended ICD-10-GM metadata
2. Identify and extract ICD-10 codes from character strings
3. Facilitate the specification of ICD codes for analysis, utilising the ICD hierarchy (e.g. given the specification "A0" return all subcodes in the range "A01" to "A09")
3. Enable the historization of ICD specifications by applying the automatic code transitions provided by DIMDI, identifying potentially problematic codes

ICD10gm is designed for use in the context of medical and health services research using routinely collected claims data. It is not suitable for use in operative coding as it does not include all relevant metadata (e.g. inclusion and exclusion notes and the detailed definitions of psychiatric diagnoses). The metadata provided in the ICD10gm package is not intended to replace the [official documentation](https://www.dimdi.de/dynamic/de/klassifikationen/icd/icd-10-gm/), which should always be consulted when specifying ICD codes for analysis.


## Getting Started

The ICD10gm package can be installed from CRAN in the usual manner:

```{r}
install.packages("ICD10gm")
```

## Basic Use

The core functionality of the package is demonstrated in the [accompanying vignette](https://edonnachie.github.io/ICD10gm/articles/icd10gm_intro.html).


An introductory presentation in German was given at the [AGENS Methodenworkshop 2021](https://agens.group/index.php/methodenworkshop/methodenworkshop-2021). <a href="https://edonnachie.github.io/ICD10gm/2021-03-AGENS_ICD10gm/Donnachie_ICD10gm.html" target = "_blank">The slides are available online</a> and give a brief overview of the package rationale and suggested workflow. (use left/right arrows to navigate).


## Copyright

Program code is released under the [MIT license](https://edonnachie.github.io/ICD10gm/LICENSE-text.html).

The underlying ICD-10-GM metadata is copyright of the [Federal Institute for Drugs and Medical Devices](https://www.bfarm.de). The source files are available free of charge from their [Download Centre](https://www.dimdi.de/dynamic/de/klassifikationen/downloads/?dir=icd-10-gm). I believe that their use in this package is compatible with the copyright restrictions. In particular:

- The distribution of an "added-value product" derived from the original DIMDI classification files is expressly permitted.

- Distribution of the original classification files is forbidden. Consequently, this package distributes only the code required to process these files. Those wishing to compile the data from scratch must download the files from the BfArM download centre and agree to the copyright restrictions.

- The package does not modify the ICD-10-GM codes, texts or other metadata in any way other than to restructure the data into a convenient form.

- The package does not contain any commercial advertising.

- The source of the data is clearly stated, both here and in the package documentation.



## Related Packages

The [icd package](https://CRAN.R-project.org/package=icd) on CRAN has similar aims but has a slightly different approach and focusses on the US version of the ICD-10 system. (This package has now been archived and is not currently available on CRAN).
