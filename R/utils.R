#' Regex for finding acronyms
#'
#' @param text The text column retrieved from `officer::read_docx() %>% officer::docx_summary()`.
#'
#' @return a character list
#' @export
regex_acronyms <- function(text) {
  text %>%
    ## find anything there are between parenthesis
    stringr::str_extract_all(string = ., pattern = "(?<=\\().*?(?=\\))") %>%
    .[[1]] %>%
    dplyr::as_tibble() %>%
    dplyr::filter(
      ## exclude if contains spaces
      stringr::str_detect(string = value, pattern = " ", negate = TRUE),
      ## exclude if contains only numbers
      stringr::str_detect(string = value, pattern = "\\D"),
      ## must contain at least one capital letter
      stringr::str_detect(string = value, pattern = "[A-Z]{1,}")
    )
}
