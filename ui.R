######################################################################################
# Example Shiny App
# Stock Correlation calculation and chart
#
# This app is an extension of:
# https://www.r-bloggers.com/recreating-rviews-reproducible-finance-with-r-sector-correlations/
# that shows how to user tidyquant to compute and vizualize stock correlations with an index.
#
# The app is then wrapped in a Shiny app that allows user to select the stocks of interest
# and the index and display the correlation chart
######################################################################################

library(shiny)
library(dygraphs)

source('stock_corr.R', echo=FALSE)

# https://github.com/daattali/advanced-shiny/blob/master/plot-spinner/app.R
# mycss <- "
#   #plot-container {
#     position: relative;
#   }
#   #loading-spinner {
#     position: absolute;
#     left: 50%;
#     top: 50%;
#     z-index: -1;
#     margin-top: -33px;  /* half of the spinner's height */
#     margin-left: -33px; /* half of the spinner's width */
#   }
#   #plot.recalculating {
#     z-index: -2;
#   }
# "

shinyUI(fluidPage(

  # Application title
  titlePanel("Correlation chart ETF to Index"),

  # 
  fluidRow(
    theme="simplex.min.css",
    column(width = 5,
      selectInput("etf_sector", label = "ETF to analyse",
                  choices = c("Consumer Discretionary", "Consumer Staples", 
                              "Energy", "Financials", "Health Care", "Industrials", 
                              "Materials", "Information Technology", "Utilities", "SP500 Index"),
                  selected = "Consumer Discretionary"),
      
      selectInput("index_sector", label = "Index to use",
                  choices = c("Consumer Discretionary", "Consumer Staples", 
                              "Energy", "Financials", "Health Care", "Industrials", 
                              "Materials", "Information Technology", "Utilities", "SP500 Index"),
                  selected = "SP500 Index")
    ),
    column(width = 5, 
           p('This is area for documentation'))
    
    #submitButton("Calculate correlation")
  ),
    
  fluidRow(
      #textOutput("msg"),
      dygraphOutput("corr_dygraph", width = '80%', height = '400px')
      
      # Only show this panel if the plot type is a histogram
      # conditionalPanel(
      #   condition = "msg != ''",
      #   textOutput("msg")),
      # conditionalPanel(
      #   condition = "msg == ''",
      #   dygraphOutput("corr_dygraph"))
      
      # tags$head(tags$style(HTML(mycss))),
      # #actionButton("btn", "Plot (takes 2 seconds)"),
      # div(id = "plot-container",
      #     tags$img(src = "spinner.gif", id = "loading-spinner"),
      #     #plotOutput("plot")
      #     dygraphOutput("corr_dygraph")
      # )
  )

))
