#' Plot Histogram
#'
#' Generates a histogram for a given dataset.
#'
#' @param data Data frame containing the column to plot.
#' @param num_bins Number of histogram bins
#' @param col_name Column name as a string.
#' @param title Plot title.
#' @param x_label X-axis label.
#' @export
plot_histogram <- function(data, num_bins, col_name, title, x_label) {
  
  ggplot2::ggplot(data,  ggplot2::aes(x = !!rlang::sym(col_name))) +
    ggplot2::geom_histogram(bins = data$num_bins, fill = "black") +
    ggplot2::labs(title = title, x = x_label, y = "Count") +
    ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(n = 10), labels = scales::label_number()) +
    ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 10), labels = scales::label_number()) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(size = 12, margin = ggplot2::margin(t = 10)),
      axis.text.y = ggplot2::element_text(size = 12, margin = ggplot2::margin(r = 10))
    )
  
}

#' Plot Segment-Based Visualization (Thomae & Euclid)
#'
#' Generates a segment-based plot.
#'
#' @param data Data frame containing the columns.
#' @param x_col X-axis column name as a string.
#' @param y_col Y-axis column name as a string.
#' @param title Plot title.
#' @param x_label X-axis label.
#' @param y_label Y-axis label.
#' @export
plot_segments <- function(data, x_col, y_col, title, x_label, y_label) {
  ggplot2::ggplot(data, ggplot2::aes(x = !!rlang::sym(x_col), y = !!rlang::sym(y_col))) +
    ggplot2::geom_segment(ggplot2::aes(xend = !!rlang::sym(x_col), y = 0, yend = !!rlang::sym(y_col)), color = "black") +
    ggplot2::labs(title = title, x = x_label, y = y_label) +
    ggplot2::theme_minimal()
}

#' Plot Scatter Points
#'
#' Generates a scatter plot.
#'
#' @export
plot_scatter <- function(data, x_col, y_col, title, x_label, y_label) {
  ggplot2::ggplot(data, ggplot2::aes(x = !!rlang::sym(x_col), y = !!rlang::sym(y_col))) +
    ggplot2::geom_point(alpha = 0.5, color = "black") +
    ggplot2::labs(title = title, x = x_label, y = y_label) +
    ggplot2::theme_minimal() +
    ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(n = 10), labels = scales::label_number()) +
    ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 10), labels = scales::label_number())
}