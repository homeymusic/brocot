#' Launch the Stern-Brocot Shiny App
#'
#' This function launches the Shiny app for visualizing position within a single slit.
#'
#' @export
single_slit_experiment <- function() {
  app_dir <- system.file("shiny", "single_slit_position", "app.R", package = "brocot")
  if (app_dir == "") {
    stop("Shiny app directory not found. Try reinstalling the package.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
