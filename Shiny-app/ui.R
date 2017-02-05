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

    column(width = 3,
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
    ),
    
    column(width = 8, 
           h5("Sample Shiny App that loads various ETFs and displays their correlation over a 20-day rolling window.",
              "Select a sector ETF to correlate, the Index (or another sector ETF)",
              "and a chart will be displayed with the rolling correlation.",
              br(), br(),
              "An exchange-traded fund (ETF) is an investment fund traded on stock exchanges, much like stocks.",
              "For more information about ETFs, check out",
              a("Wikipedia.", href="https://en.wikipedia.org/wiki/Exchange-traded_fund"),
              br(), br(),
              "Complete documentation for this application is stored in this",
              a("github repo", href="https://github.com/bkelemen56/StockCorrelationShinyApp"),
              "together with the source files for the project.")
    )
           
    #submitButton("Calculate correlation")
  ),
    
  # section for the chart
  fluidRow(
      dygraphOutput("corr_dygraph", width = '90%', height = '400px')
  )

))
