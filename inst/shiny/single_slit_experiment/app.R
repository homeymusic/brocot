devtools::load_all(".")

# Define default values in one place
default_values <- list(
  num_bins = 1001,
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
        choices = sort(c(as.vector(outer(1:9, 10^(-3:3), "*")), 12.6, 17)),
        selected = default_values$slit_width
      ),
      shiny::sliderInput("num_samples", "Number of Samples:", min = 101, max = 5001, value = default_values$num_samples),
      shiny::sliderInput("num_bins", "Number of Bins:", min = 3, max = default_values$num_samples, value = default_values$num_bins),
      shiny::actionButton("reset", "Reset Values")
    ),
    shiny::mainPanel(
      shiny::plotOutput("p_m"),
      shiny::plotOutput("hist_approximation"),
      shiny::plotOutput("thomaes_function"),
      shiny::plotOutput("euclids_orchard"),
      shiny::plotOutput("hist_error"),
      shiny::plotOutput("scatter_approx_depth"),
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
    sigma_x_lt   <-  x_real - min_x + dx
    sigma_x_gt   <-  max_x - x_real + dx
    
    x <- coprimer::nearby_coprime(x_real, sigma_x_lt, sigma_x_gt)
    
    sigma_p_lt   = 1 / sigma_x_lt
    sigma_p_gt   = 1 / sigma_x_gt
    p_real       = sigma_p_gt - sigma_p_lt
    
    p = coprimer::nearby_coprime(p_real, sigma_p_lt, sigma_p_gt)
    
    return(list(x = x, p = p, num_bins = num_bins))
  })
  
  # Position Momentum Scatter Plot
  output$p_m <- renderPlot({
    
    data <- stern_data()
    
    plot_scatter(
      data = data.frame(x = data$x$approximation, p = data$p$approximation),
      x_col = "x",
      y_col = "p",
      title = "Position vs Momentum",
      x_label = "x",
      y_label = "p"
    )
  
  })
  
  # Euclid's Orchard Height
  output$euclids_orchard <- renderPlot({
    
    data <- stern_data()
    
    plot_segments(data$x, "approximation", "euclids_orchard_height", "Euclid's Orchard of Position", "Approximation", "Redundancy")
    
  })

    # Thomae's Function
  output$thomaes_function <- renderPlot({
    
    data <- stern_data()
    plot_segments(data$x, "approximation", "thomae", "Thomae's Function of Position", "Approximation", "Thomae")
    
  })
  
  # Scatter Plot: Approximation vs Depth
  output$scatter_approx_depth <- renderPlot({
    data <- stern_data()
    plot_scatter(data$x, "approximation", "depth", "Stern-Brocot Depth vs. Position", "Approximation", "Depth")
  })
  
  # Histogram of Stern-Brocot Approximation
  output$hist_approximation <- renderPlot({
    data <- stern_data()
    
    plot_histogram(data$x, data$num_bins, "approximation", "Histogram of Position", "Rational Number")
    
  })
  
  # Histogram of Stern-Brocot Errors
  output$hist_error <- renderPlot({
    data <- stern_data()
    plot_histogram(data$x, data$num_bins, "approximation", "Histogram of Position", "Rational Number")
  })
  
  # Histogram of Reals Input
  output$hist_reals <- renderPlot({
    data <- stern_data()
    plot_histogram(data$x, data$num_bins, "x", "Histogram of Reals", "Real Number")
  })
}

# Run the application
shiny::shinyApp(ui = ui, server = server)