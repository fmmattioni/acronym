% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find-acronyms.R
\name{find_acronyms}
\alias{find_acronyms}
\title{Find acronyms}
\usage{
find_acronyms(
  path,
  delimiter = c("Introduction", "References"),
  ref_manager = c("zotero", "endnote", "mendeley", "custom"),
  custom_regex = NULL,
  sort = TRUE
)
}
\arguments{
\item{path}{The path of your Word document. Passed onto \code{officer::read_docx()}.}

\item{delimiter}{An atomic vector of size two indicating whether to set boundaries for
looking for acronyms. The default \code{c("Introduction", "References")} will look for acronyms
only between these headings in the text. Set it to \code{NULL} for not applying any boundary.}

\item{ref_manager}{Specify the reference manager used in the text. Can be one of "zotero",
"endnote", "mendeley", or "custom". Set it to \code{NULL} to ignore this argument.}

\item{custom_regex}{Apply your own custom regex to ignore words. You must set \code{ref_manager = "custom"}
for this to work.}

\item{sort}{Set to \code{TRUE} for sorting it in alphabetical order. If \code{FALSE}, it will return the acronyms
in order of appearance in the text.}
}
\value{
a list of acronyms
}
\description{
Finds acronyms in a Word document and retrieves a unique list of acronyms
}
\examples{
## manuscript using zotero
find_acronyms(path = system.file("zotero.docx", package = "acronym"), ref_manager = "zotero")
}
