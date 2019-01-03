context("test-icd_history.R")


dat_custom_transition <- data.frame(
  year_from = 2009,
  year_to = 2010,
  icd_from = "K52.9",
  icd_to = "A09.9",
  automatic_forward = "A",
  automatic_backward = "A",
  stringsAsFactors = FALSE
)

icd_k52_2009 <- ICD10gm::icd_expand(data.frame(icd_spec = "K52.9"),
                               year = 2009, col_icd = "icd_spec")

icd_k52_2010 <- ICD10gm::icd_expand(data.frame(icd_spec = "K52.9"),
                               year = 2010, col_icd = "icd_spec")

icd_k58_2019 <- ICD10gm::icd_expand(data.frame(icd_spec = "K58.2"),
                                    year = 2019, col_icd = "icd_spec")

test_that("icd_history returns input if years == year", {
            expect_identical(icd_k52_2010,
                             ICD10gm::icd_history(icd_k52_2010, years = 2010))
          })

test_that("Coding break: Check that K52.9 specified for 2009 is removed for 2010", {

  expect_identical(
    icd_history(icd_k52_2009, years = 2009:2010), icd_k52_2009
  )
})

test_that("Simple transition: Check that K58.2 for 2019 is translated to K58.9 for 2018", {
  expect_identical(
    icd_history(icd_k58_2019, years = 2018:2019)$icd_code,
    c("K58.9", "K58.2")
  )
})
