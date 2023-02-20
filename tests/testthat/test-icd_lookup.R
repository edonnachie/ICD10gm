test_that("Query E109 (expand=FALSE) returns exactly one row with label T1D", {
  e109 <- icd_lookup("E109", expand = FALSE)
  expect_equal(nrow(e109), 1)
  expect_true(grepl("Diabetes mellitus, Typ 1", e109$label))
})
test_that("Query E109 (expand=TRUE) returns exactly three rows with label T1D", {
  e109 <- icd_lookup("E109", expand = TRUE)
  expect_equal(nrow(e109), 3)
})
test_that("Return error when input is not a valid ICD-10 code", {
  expect_error(icd_lookup("Diabetes mellitus"))
  expect_error(icd_lookup("E1099"))
})
