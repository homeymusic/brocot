#' Launch the single slit position experiment
#'
#' This function launches the Shiny app for visualizing position within a single slit.
#'
#' @export
single_slit_position_experiment <- function() {
  app_dir <- system.file("shiny", "single_slit_position", "app.R", package = "brocot")
  if (app_dir == "") {
    stop("Shiny app directory not found. Try reinstalling the package.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}


#' Launch the single slit momentum experiment
#'
#' This function launches the Shiny app for visualizing momentum within a single slit.
#'
#' @export
single_slit_momentum_experiment <- function() {
  app_dir <- system.file("shiny", "single_slit_momentum", "app.R", package = "brocot")
  if (app_dir == "") {
    stop("Shiny app directory not found. Try reinstalling the package.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
