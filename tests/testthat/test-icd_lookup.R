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

test_that("Check that icd_browse returns the correct URL", {
  expect_equal(
    icd_browse("R54", year = 2023, open_browser = FALSE),
    "https://www.dimdi.de/static/de/klassifikationen/icd/icd-10-gm/kode-suche/htmlgm2023/block-r50-r69.htm#R54"
    )
})
test_that("Check that icd_search returns K58 for reizdarm", {
  expect_equal(
    unique(icd_search("reizdarm", year = 2023)$icd3),
    "K58"
  )
})
