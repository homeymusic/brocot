# Define default values in one place
default_values <- list(
  num_bins = 101,
  num_samples = 1001,
  slit_width = 17
)

# Define UI
ui <- shiny::fluidPage(
  shiny::titlePanel("Interactive Stern-Brocot Approximation"),
  
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shinyWidgets::sliderTextInput(
        inputId = "slit_width", 
        label = "Slit Width:", 
        choices = sort(c(as.vector(outer(1:9, 10^(-3:3), "*")), 17)),
        selected = default_values$slit_width
      ),
      shiny::sliderInput("num_bins", "Number of Bins:", min = 3, max = 201, value = default_values$num_bins),
      shiny::sliderInput("num_samples", "Number of Samples:", min = 101, max = 5001, value = default_values$num_samples),
      shiny::actionButton("reset", "Reset Values")
    ),
    shiny::mainPanel(
      shiny::plotOutput("hist_approximation"),
      shiny::plotOutput("thomaes_function"),
      shiny::plotOutput("euclids_orchard"),
      shiny::plotOutput("scatter_approx_depth"),
      shiny::plotOutput("hist_error"),
      shiny::plotOutput("hist_reals")
    )
  )
)

# Define Server
server <- function(input, output, session) {
  
  observe({
    updateSliderInput(session, "num_bins", max = input$num_samples)
  })
  
  # Reset button logic
  observeEvent(input$reset, {
    shiny::updateSliderInput(session, 'num_bins', value = default_values[['num_bins']])
    shiny::updateSliderInput(session, 'num_samples', value = default_values[['num_samples']])
    shinyWidgets::updateSliderTextInput(session, 'slit_width', selected = default_values[['slit_width']])
  })

  stern_data <- shiny::reactive({
    num_samples  <- input$num_samples
    num_bins     <- input$num_bins
    slit_width   <- input$slit_width
    
    dx           <-  slit_width / num_samples
    min_x        <- -slit_width / 2 + dx
    max_x        <-  slit_width / 2 - dx
    x_real       <-  seq(from = min_x, to = max_x, by = dx)
    sigma_x_lt   <-  x_real - min_x
    sigma_x_gt   <-  max_x - x_real
    
    x <- coprimer::nearby_coprime(x_real, sigma_x_lt, sigma_x_gt)
    return(list(x = x, num_bins = num_bins))
  })
  
  # Euclid's Orchard Height
  output$euclids_orchard <- renderPlot({
    
    data <- stern_data()
    
    ggplot2::ggplot(data.frame(approximation = data$x$approximation, euclid = data$x$euclids_orchard_height),
                    ggplot2::aes(x = approximation, y = euclid)) +
      ggplot2::geom_segment(ggplot2::aes(xend = approximation, y = 0, yend = euclid), color = "black") +
      ggplot2::labs(title = "Euclid's Orchard Height of Stern-Brocot Approximations", x = "Approximation", y = "Euclid") +
      ggplot2::theme_minimal()
  })

    # Thomae's Function
  output$thomaes_function <- renderPlot({
    
    data <- stern_data()
    
    ggplot2::ggplot(data.frame(approximation = data$x$approximation, thomae = data$x$thomae),
                  ggplot2::aes(x = approximation, y = thomae)) +
    ggplot2::geom_segment(ggplot2::aes(xend = approximation, y = 0, yend = thomae), color = "black") +
    ggplot2::labs(title = "Thomae's Function of Stern-Brocot Approximations", x = "Approximation", y = "Thomae") +
    ggplot2::theme_minimal()
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