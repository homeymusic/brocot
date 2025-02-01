#' Launch the Stern-Brocot Shiny App
#'
#' This function launches the Shiny app for visualizing Stern-Brocot approximations.
#'
#' @export
run_shiny <- function() {
  app_dir <- system.file("shiny", "app.R", package = "brocot")
  if (app_dir == "") {
    stop("Shiny app directory not found. Try reinstalling the package.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}