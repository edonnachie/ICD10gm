context("test-icd_expand.R")



test_that("ICD code can be specified as E103, E10.3 or E10.3-", {

  # The following should be identical except for the icd_spec
  expect_equal(
    ICD10gm::icd_expand(data.frame(ICD = "E103"), year = 2018)[, -1],
    ICD10gm::icd_expand(data.frame(ICD = "E10.3"), year = 2018)[, -1]
    )

  expect_equal(
    ICD10gm::icd_expand(data.frame(ICD = "E103"), year = 2018)[, -1],
    ICD10gm::icd_expand(data.frame(ICD = "E10.3-"), year = 2018)[, -1]
  )
})

test_that("Throws error if a non-existing ICD code is provided", {

  # The following should be identical except for the icd_spec
  expect_error(
    ICD10gm::icd_expand(data.frame(ICD = "R105"), year = 2018)
  )

})


test_that("Expands down the hierarchy", {

  # The following should be identical except for the icd_spec
  expect_equal(
    ICD10gm::icd_expand(data.frame(ICD = "A09"), year = 2018)$icd_sub,
    c("A09", "A090", "A099")
  )

  expect_equal(
    ICD10gm::icd_expand(data.frame(ICD = "J44"), year = 2018)$icd_sub,
    c("J44", "J440", "J4400", "J4401", "J4402", "J4403", "J4409",
      "J441", "J4410", "J4411", "J4412", "J4413", "J4419",
      "J448", "J4480", "J4481", "J4482", "J4483", "J4489",
      "J449", "J4490", "J4491", "J4492", "J4493", "J4499")
  )

  expect_equal(
    nrow(ICD10gm::icd_expand(data.frame(ICD = "A0"), year = 2018)),
    74L
  )

  # A real-world example, mixing prefix specification "A0" etc and specific codes.
  # This should expand without any warnings
  expect_silent(
    ICD10gm::icd_expand(
      icd_in = read.csv2("fss_grouper.csv", stringsAsFactors = FALSE),
      year = 2016,
      col_icd = "ICD",
      col_meta = c("DIAG_CATEGORY", "DIAG_GROUP", "ICD_SICHER_ID")
  ))
})
