# Define UI
ui <- shiny::fluidPage(
  shiny::titlePanel("Interactive Stern-Brocot Approximation"),
  
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::sliderInput("sigma_x_max", "Max Sigma X:", min = 1/100, max = 1, value = 1/(4 * pi), step = 1/200),
      shiny::sliderInput("num_bins", "Number of Bins:", min = 3, max = 201, value = 101, step = 1),
      shiny::sliderInput("num_samples", "Number of Samples:", min = 500, max = 5000, value = 1000, step = 500),
      shiny::sliderInput("slit_width", "Slit Width:", min = 0.1, max = 5, value = 1, step = 0.1)
    ),
    shiny::mainPanel(
      shiny::plotOutput("scatter_approx_depth"),
      shiny::plotOutput("hist_approximation"),
      shiny::plotOutput("hist_error"),
      shiny::plotOutput("hist_reals")
    )
  )
)

# Define Server
server <- function(input, output) {
  stern_data <- shiny::reactive({
    num_samples  <- input$num_samples
    num_bins     <- input$num_bins
    sigma_x_max  <- input$sigma_x_max
    slit_width   <- input$slit_width
    
    dx           <- 1 / num_samples
    min_x        <- 2 * dx
    max_x        <- slit_width - 2 * dx
    x_real       <- seq(from = min_x, to = max_x, by = dx)
    sigma_x_lt   <- pmin(x_real - min_x + dx, sigma_x_max)
    sigma_x_gt   <- pmin(max_x - x_real + dx, sigma_x_max)
    
    x <- coprimer::stern_brocot(x_real, sigma_x_lt, sigma_x_gt)
    return(list(x = x, num_bins = num_bins))
  })
  
  # Scatter Plot: Approximation vs Depth
  output$scatter_approx_depth <- renderPlot({
    data <- stern_data()
    
    ggplot2::ggplot(data.frame(approximation = data$x$approximation, depth = data$x$depth),
                    ggplot2::aes(x = approximation, y = depth)) +
      ggplot2::geom_point(alpha = 0.5, color = "black") +  # Scatter plot with transparency
      ggplot2::labs(title = "Stern-Brocot Approximation vs. Depth",
                    x = "Approximation", y = "Depth") +
      ggplot2::theme_minimal() +
      ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(n = 10), labels = scales::label_number()) +
      ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 10), labels = scales::label_number())
  })
  
  # Histogram of Stern-Brocot Approximation
  output$hist_approximation <- renderPlot({
    data <- stern_data()
    
    ggplot2::ggplot(data.frame(approximation = data$x$approximation), ggplot2::aes(x = approximation)) +
      ggplot2::geom_histogram(bins = data$num_bins, fill = "gray", color = "black") +
      ggplot2::labs(title = "Histogram of Stern-Brocot Rational Numbers", x = "Rational Number", y = "Count") +
      ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(n = 10), labels = scales::label_number()) +
      ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 10), labels = scales::label_number()) +
      ggplot2::theme_minimal() +
      ggplot2::theme(
        axis.text.x = ggplot2::element_text(size = 12, margin = ggplot2::margin(t = 10)),
        axis.text.y = ggplot2::element_text(size = 12, margin = ggplot2::margin(r = 10))
      )
  })
  
  # Histogram of Stern-Brocot Errors
  output$hist_error <- renderPlot({
    data <- stern_data()
    
    ggplot2::ggplot(data.frame(error = data$x$error), ggplot2::aes(x = error)) +
      ggplot2::geom_histogram(bins = data$num_bins, fill = "gray", color = "black") +
      ggplot2::labs(title = "Histogram of Stern-Brocot Errors", x = "Error", y = "Count") +
      ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(n = 10), labels = scales::label_number()) +
      ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 10), labels = scales::label_number()) +
      ggplot2::theme_minimal() +
      ggplot2::theme(
        axis.text.x = ggplot2::element_text(size = 12, margin = ggplot2::margin(t = 10)),
        axis.text.y = ggplot2::element_text(size = 12, margin = ggplot2::margin(r = 10))
      )
  })
  
  # Histogram of Reals Input
  output$hist_reals <- renderPlot({
    data <- stern_data()
    
    ggplot2::ggplot(data.frame(reals = data$x$x), ggplot2::aes(x = reals)) +
      ggplot2::geom_histogram(bins = data$num_bins, fill = "gray", color = "black") +
      ggplot2::labs(title = "Histogram of Real Numbers", x = "Real Number", y = "Count") +
      ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(n = 10), labels = scales::label_number()) +
      ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 10), labels = scales::label_number()) +
      ggplot2::theme_minimal() +
      ggplot2::theme(
        axis.text.x = ggplot2::element_text(size = 12, margin = ggplot2::margin(t = 10)),
        axis.text.y = ggplot2::element_text(size = 12, margin = ggplot2::margin(r = 10))
      )
  })
}

# Run the application
shiny::shinyApp(ui = ui, server = server)