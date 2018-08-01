context("test-icd_parse.R")


test_that("Correctly identifies ICD codes", {
  expect_true(is_icd_code("R10"))
  expect_true(is_icd_code("R101"))
  expect_true(is_icd_code("R10.32"))

  expect_false(is_icd_code("RD"))
  expect_false(is_icd_code("123.2"))
  expect_false(is_icd_code("R12.d"))
})

test_that("Single ICD codes are correctly parsed", {
  expect_equal(icd_parse("E10.1"),
               data.frame(icd_spec = "E10.1",
                          icd3 = "E10",
                          icd_subcode = "1",
                          icd_norm = "E10.1",
                          icd_sub = "E101",
                          stringsAsFactors = FALSE))

  expect_equal(icd_parse("E101"),
               data.frame(icd_spec = "E101", icd3 = "E10", icd_subcode = "1",
                          icd_norm = "E10.1",
                          icd_sub = "E101",
                          stringsAsFactors = FALSE))


  expect_equal(icd_parse("EA"),
               data.frame(icd_spec = NA_character_, icd3 = NA_character_, icd_subcode = NA_character_,
                          icd_norm = NA_character_,
                          icd_sub = NA_character_,
                          stringsAsFactors = FALSE))
})



test_that("icd_parsed is vectorised", {
  expect_equal(icd_parse(c("E10.1", "E10", "E1012")),
               data.frame(icd_spec = c("E10.1", "E10", "E1012"),
                          icd3 = rep("E10", 3),
                          icd_subcode = c("1", NA_character_, "12"),
                          icd_norm = c("E10.1", "E10", "E10.12"),
                          icd_sub = c("E101", "E10", "E1012"),
                          stringsAsFactors = FALSE)
               )
})


test_that("All possible ICD codes can be parsed (ICD_CODE)", {
  tst_icd_parsed <- icd_parse(icd_meta_codes$icd_code)

  # Is data.frame
  expect_s3_class(tst_icd_parsed, "data.frame")

  # Same length as icd_meta_codes
  expect_equal(nrow(tst_icd_parsed), nrow(icd_meta_codes))

  # No NAs
  expect_false(any(is.na(tst_icd_parsed$icd3)))
})

test_that("All possible ICD codes can be parsed (ICD_SUB)", {
  tst_icd_parsed <- icd_parse(icd_meta_codes$icd_sub)

  # Is data.frame
  expect_s3_class(tst_icd_parsed, "data.frame")

  # Same length as icd_meta_codes
  expect_equal(nrow(tst_icd_parsed), nrow(icd_meta_codes))

  # No NAs
  expect_false(any(is.na(tst_icd_parsed$icd3)))
})

test_that("All possible ICD codes can be parsed (ICD3)", {
  tst_icd_parsed <- icd_parse(icd_meta_codes$icd_sub)

  # Is data.frame
  expect_s3_class(tst_icd_parsed, "data.frame")

  # Same length as icd_meta_codes
  expect_equal(nrow(tst_icd_parsed), nrow(icd_meta_codes))

  # No NAs
  expect_false(any(is.na(tst_icd_parsed$icd3)))
})
