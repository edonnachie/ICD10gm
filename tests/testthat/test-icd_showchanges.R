test_that("icd_showchanges single diagnosis", {
  dat_single_icd <- icd_expand(
    data.frame(ICD_SPEC = c("N77.8")),
    col_icd = "ICD_SPEC",
    year = 2015)

  changes_single_icd <- icd_showchanges(dat_single_icd, years = 2015:2020)

  #expect_true(is.data.frame(changes_single_icd))
  expect_s3_class(changes_single_icd, "data.frame")
  expect_equal(nrow(changes_single_icd), 3)
  })

test_that("icd_showchanges multiple diagnoses", {
  dat_multiple_icd <- icd_expand(
    data.frame(ICD_SPEC = c("N77.8", "G83.88")),
    col_icd = "ICD_SPEC",
    year = 2015)

  changes_multiple_icd <- icd_showchanges(dat_multiple_icd, years = 2015:2020)

  expect_s3_class(changes_multiple_icd, "data.frame")
  expect_equal(nrow(changes_multiple_icd), 4)
})

