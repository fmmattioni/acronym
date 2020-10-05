test_that("zotero works", {
  x <- find_acronyms(path = system.file("zotero.docx", package = "acronym"), ref_manager = "zotero")

  expect_vector(x)
})

test_that("endnote works", {
  x <- find_acronyms(path = system.file("endnote.docx", package = "acronym"), ref_manager = "endnote")

  expect_vector(x)
})

test_that("mendeley works", {
  x <- find_acronyms(path = system.file("mendeley.docx", package = "acronym"), ref_manager = "mendeley")

  expect_vector(x)
})

test_that("all ref managers return same results", {
  zotero <- find_acronyms(path = system.file("zotero.docx", package = "acronym"), ref_manager = "zotero")
  endnote <- find_acronyms(path = system.file("endnote.docx", package = "acronym"), ref_manager = "endnote")
  mendeley <- find_acronyms(path = system.file("mendeley.docx", package = "acronym"), ref_manager = "mendeley")

  expect_identical(zotero, endnote)
  expect_identical(zotero, mendeley)
  expect_identical(endnote, mendeley)
})
