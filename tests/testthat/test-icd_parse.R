context("test-icd_parse.R")


test_that("Correctly identifies ICD codes", {
  expect_true(is_icd_code("R10"))
  expect_true(is_icd_code("R104"))
  expect_true(is_icd_code("R104", year = 2018))
  expect_true(is_icd_code("R10.4", year = 2018))

  expect_false(is_icd_code("RD"))
  expect_false(is_icd_code("123.2"))
  expect_false(is_icd_code("R12.d"))
  expect_false(is_icd_code("R105"))
  expect_false(is_icd_code("R105", year = 2018))
  expect_false(is_icd_code("R10.5", year = 2018))

  expect_true(is_icd_code("R10.4G", year = 2018))
  expect_false(is_icd_code("R10.4F", year = 2018))
  expect_true(is_icd_code("J44.-", year = 2018))
  expect_false(is_icd_code("E10.-F", year = 2018))
})

test_that("Single ICD codes are correctly parsed", {
  expect_equal(icd_parse("E10.1"),
               data.frame(icd_spec = "E10.1",
                          icd3 = "E10",
                          icd_subcode = "1",
                          icd_security = "",
                          icd_sub = "E101",
                          stringsAsFactors = FALSE))

  expect_equal(icd_parse("E101"),
               data.frame(icd_spec = "E101", icd3 = "E10", icd_subcode = "1",
                          icd_security = "",
                          icd_sub = "E101",
                          stringsAsFactors = FALSE))

  expect_equal(icd_parse("E101-"),
               data.frame(icd_spec = "E101-", icd3 = "E10", icd_subcode = "1",
                          icd_security = "",
                          icd_sub = "E101",
                          stringsAsFactors = FALSE))

  expect_equal(icd_parse("E101-G"),
               data.frame(icd_spec = "E101-G", icd3 = "E10", icd_subcode = "1",
                          icd_security = "G",
                          icd_sub = "E101",
                          stringsAsFactors = FALSE))

  expect_equal(icd_parse("E101G"),
               data.frame(icd_spec = "E101G", icd3 = "E10", icd_subcode = "1",
                          icd_security = "G",
                          icd_sub = "E101",
                          stringsAsFactors = FALSE))

  expect_equal(icd_parse("E101-"),
               data.frame(icd_spec = "E101-", icd3 = "E10", icd_subcode = "1",
                          icd_security = "",
                          icd_sub = "E101",
                          stringsAsFactors = FALSE))

  expect_equal(icd_parse("E10G"),
               data.frame(icd_spec = "E10G", icd3 = "E10", icd_subcode = "",
                          icd_security = "G",
                          icd_sub = "E10",
                          stringsAsFactors = FALSE))

  expect_equal(icd_parse("E10 G"),
               data.frame(icd_spec = "E10 G", icd3 = "E10", icd_subcode = "",
                          icd_security = "G",
                          icd_sub = "E10",
                          stringsAsFactors = FALSE))

  expect_equal(icd_parse("EA"),
               data.frame(icd_spec = "EA",
                          icd3 = NA_character_,
                          icd_subcode = NA_character_,
                          icd_security = NA_character_,
                          icd_sub = NA_character_,
                          stringsAsFactors = FALSE))
})



test_that("icd_parsed is vectorised", {
  expect_equal(icd_parse(c("E10.1", "E10 V", "E1012")),
               data.frame(icd_spec = c("E10.1", "E10 V", "E1012"),
                          icd3 = rep("E10", 3),
                          icd_subcode = c("1", "", "12"),
                          icd_security = c("", "V", ""),
                          icd_sub = c("E101", "E10", "E1012"),
                          stringsAsFactors = FALSE)
               )
})

test_that("Two separated with hyphens are both identified", {
  expect_equal(icd_parse("(A04.0-A04.4)"),
               data.frame(icd_spec = rep("(A04.0-A04.4)", 2),
                          icd3 = rep("A04", 2),
                          icd_subcode = c("0", "4"),
                          icd_security = c("", ""),
                          icd_sub = c("A040", "A044"),
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
