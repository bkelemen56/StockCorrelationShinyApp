#---------------------------------------------------------------------------
#
# Example Shiny App (Server component)
# Stock Correlation calculation and chart
#
# This app is an extension/modification of:
# https://www.r-bloggers.com/recreating-rviews-reproducible-finance-with-r-sector-correlations/
# that shows how to use tidyquant to compute and vizualize stock correlations with an index.
#
# The app is then wrapped in a Shiny app that allows user to select the ETFs of interest,
# an index and then display the correlation chart.
#
#---------------------------------------------------------------------------

library(shiny)
library(dygraphs)

# source our utility functions and global variables
source('stock_corr.R', echo=FALSE)

# Will cache the etf data once per application as this is an expensive operation
etf_data <- NULL

#---------------------------------------------------------------------------
# 
# Shiny Server function
#
#---------------------------------------------------------------------------

shinyServer(function(input, output, session) {
  
  # TODO: send the sector list to the UI
  # output$sector <- dput(sector)
  # output$default_sector <- sector[1]
  
  # render the chart
  output$corr_dygraph <- renderDygraph({

    # cache the etf_data on first call. Also show a progress message on the UI
    if (is.null(etf_data)) {
      progress <- Progress$new(session, min=1, max=15)
      on.exit(progress$close())
      
      progress$set(message = 'Loading ETF stock prices', 
                   detail = 'This may take a while...')
      
      etf_data <<- load_data()
    }
    
    # now generate the gygraph with inputs from the UI
    g <- 
      etf_data %>%
      isolate_index(get_ticker(input$index_sector)) %>%
      calc_correlations() %>%
      get_chart(input$index_sector, input$etf_sector)
    
    g
  })

})

