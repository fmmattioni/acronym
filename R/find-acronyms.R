#' Find acronyms
#'
#' Finds acronyms in a Word document and retrieves a unique list of acronyms
#'
#' @param path The path of your Word document. Passed onto `officer::read_docx()`.
#' @param delimiter An atomic vector of size two indicating whether to set boundaries for
#' looking for acronyms. The default `c("Introduction", "References")` will look for acronyms
#' only between these headings in the text. Set it to `NULL` for not applying any boundary.
#' @param ref_manager Specify the reference manager used in the text. Can be one of "zotero",
#' "endnote", "mendeley", or "custom". Set it to `NULL` to ignore this argument.
#' @param custom_regex Apply your own custom regex to ignore words. You must set `ref_manager = "custom"`
#' for this to work.
#' @param sort Set to `TRUE` for sorting it in alphabetical order. If `FALSE`, it will return the acronyms
#' in order of appearance in the text.
#'
#' @return a list of acronyms
#' @export
#'
#' @examples
#' ## manuscript using zotero
#' find_acronyms(path = system.file("zotero.docx", package = "acronym"), ref_manager = "zotero")
find_acronyms <- function(
  path,
  delimiter = c("Introduction", "References"),
  ref_manager = c("zotero", "endnote", "mendeley", "custom"),
  custom_regex = NULL,
  sort = TRUE
) {
  if(missing(ref_manager))
    stop("You need to specify the reference manager you are using. If do not use a reference manager, then set the `ref_manager` argument to `NULL`.", call. = FALSE)

  if(!is.null(ref_manager))
    ref_manager <- match.arg(arg = ref_manager, several.ok = FALSE)

  if(!is.null(delimiter)) {
    if(!is.atomic(delimiter))
      stop("You must pass a vector to the limiter.", call. = FALSE)

    if(length(delimiter) != 2)
      stop("The limiter can only be of length 2.", call. = FALSE)
  }

  ## read manuscript
  manuscript <- officer::read_docx(path = path) %>%
    officer::docx_summary() %>%
    dplyr::as_tibble()

  if(!is.null(delimiter)) {
    boundaries <- dplyr::filter(manuscript, text %in% delimiter)

    if(nrow(boundaries) != 2)
      stop("Please, double check your limiters. You either have duplicate headers or one of your limiters do not exist in your text.", call. = FALSE)

    manuscript <- dplyr::filter(manuscript, doc_index > boundaries$doc_index[1] & doc_index < boundaries$doc_index[2])
  }

  ## set regex related to the reference manager
  if(!is.null(ref_manager))
    switch (
      ref_manager,
      "zotero" = ref_regex <- "ADDIN ZOTERO.*?json|[^ ]{20,}",
      "endnote" = ref_regex <- "\\<\\EndNote\\>.*?\\<\\/EndNote\\>|ADDIN.*?CITE|[^ ]{20,}",
      "mendeley" = ref_regex <- "ADDIN.*?json|ADDIN CSL_CITATION|[^ ]{20,}"
    )

  if(!is.null(custom_regex))
    ref_regex <- custom_regex

  manuscript <- dplyr::select(manuscript, text)

  if (!is.null(ref_manager))
    manuscript <- dplyr::mutate(manuscript, text = stringr::str_remove_all(string = text, pattern = ref_regex))

  out <- manuscript %>%
    dplyr::rowwise() %>%
    dplyr::mutate(abbreviations = regex_acronyms(text) %>% list()) %>%
    dplyr::ungroup() %>%
    dplyr::select(abbreviations) %>%
    unlist(use.names = FALSE) %>%
    unique()

  if(sort)
    out <- sort(out)

  clipr::write_clip(out, allow_non_interactive = TRUE)
  usethis::ui_done("List of acronyms copied to clipboard. You can now just paste it into your Word document.")
  out
}
