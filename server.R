
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dygraphs)

source('stock_corr.R', echo=FALSE)

# load etf data (this takes a while). 
# Do this out ofd shinyServer so this is done only once
data_loading <- TRUE
etf_data <- NULL
data_loading <- FALSE

# 
shinyServer(function(input, output, session) {
  
  # send the sector list to the UI
  # output$sector <- dput(sector)
  # output$default_sector <- sector[1]
  
  
    # TODO: do some changes based on inputs
  
    # this will pass the flag that indicates data is loading to the UI
    #output$data_loading <- reactive(data_loading)
  
    # output$msg <- renderText({ 
    #   if (data_loading) {
    #     msg <- "Data is beling loaded. Please wait..."
    #   } else {
    #     msg <- ""
    #   }
    #   msg
    # })

    #output$msg <- "Calculation in progress..."
  
    # render the chart
    output$corr_dygraph <- renderDygraph({
      #etf_data <- load_data()
      
      if (is.null(etf_data)) {
        progress <- Progress$new(session, min=1, max=15)
        on.exit(progress$close())
        
        progress$set(message = 'Loading ETF stock prices', detail = 'This may take a while...')
        
        etf_data <<- load_data()
      }
      
      g <- etf_data %>%
        isolate_index(get_ticker(input$index_sector)) %>%
        calc_correlations() %>%
        get_chart(input$index_sector, input$etf_sector)
      
      g
    })

})

