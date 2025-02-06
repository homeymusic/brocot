#' Compute Stern-Brocot Approximation for sqrt(2)
#'
#' This function calls `coprimer::nearby_coprime()` to approximate the sqrt of 2
#' using the Stern-Brocot tree within a tolerance of 0.08.
#'
#' @return A data frame containing the rational approximation of the sqrt of 2,
#' along with details about the fraction, error, and Stern-Brocot path.
#' @export
#' @importFrom coprimer nearby_coprime
#' @importFrom ggplot2 ggplot
#'
#' @examples
#' example_sb_call()
example_sb_call <- function() {
  coprimer::nearby_coprime(sqrt(2), 0.08, 0.08)  
}
