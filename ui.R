#---------------------------------------------------------------------------
#
# Example Shiny App (UI component)
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

# source('stock_corr.R', echo=FALSE)

shinyUI(fluidPage(

  titlePanel("Correlation chart ETF to Index"),

  # section for the input controls
  fluidRow(

    column(width = 5,
      selectInput("etf_sector", label = "ETF to correlate:",
                  choices = c("Consumer Discretionary", "Consumer Staples", 
                              "Energy", "Financials", "Health Care", "Industrials", 
                              "Materials", "Information Technology", "Utilities", "SPY Index"),
                  selected = "Consumer Discretionary"),
      
      selectInput("index_sector", label = "Index:",
                  choices = c("Consumer Discretionary", "Consumer Staples", 
                              "Energy", "Financials", "Health Care", "Industrials", 
                              "Materials", "Information Technology", "Utilities", "SPY Index"),
                  selected = "SPY Index")
    )
    
    # column(width = 5, 
    #        p('This is area for documentation'))
    
    #submitButton("Calculate correlation")
  ),
    
  # section for the chart
  fluidRow(
      dygraphOutput("corr_dygraph", width = '90%', height = '400px')
  )

))
