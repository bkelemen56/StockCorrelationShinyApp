# https://www.r-bloggers.com/recreating-rviews-reproducible-finance-with-r-sector-correlations/
#
# Changes:
# - groupped into separates functions

library(tidyquant)
library(dygraphs)
#library(hash)

# Global variables

# List of tickers for sector etfs. 
ticker <- c("XLY", "XLP", "XLE", "XLF", "XLV",   
            "XLI", "XLB", "XLK", "XLU", "SPY") 

# And the accompanying sector names for those ETFs.
sector <- c("Consumer Discretionary", "Consumer Staples", 
            "Energy", "Financials", "Health Care", "Industrials", 
            "Materials", "Information Technology", "Utilities", "SP500 Index")

# default selections
default_sector <- "Information Technology"
default_index_ticker <- "SPY"
default_index_sector <- "SP500 Index"

# Make tibble (ticker, sector)
etf_ticker_sector <- tibble(ticker, sector)

# Utility function to return the ticker for a sector
get_ticker <- function(sector) {
  etf_ticker_sector[etf_ticker_sector$sector == sector, ]$ticker
}

# Loads the dataa and calculates weekly log returns
load_data <- function() {

  # Get stock prices
  prices <- etf_ticker_sector %>%
    tq_get(get = "stock.prices") %>% 
    group_by(ticker, sector)
  
  # Transform to period returns
  etf_returns_bizsci <- prices %>% 
    tq_transform(ohlc_fun = Cl,  transform_fun = periodReturn, 
                 period = 'weekly', type = 'log')
  
  #head(etf_returns_bizsci)
  
  etf_returns_bizsci
}

# Separates index
isolate_index <- function(etf_returns_bizsci, index_ticker = default_index_ticker) {
  
  # Isolate index
  index <- etf_returns_bizsci %>%
    ungroup() %>%
    filter(ticker == index_ticker) %>% 
    select(date, weekly.returns) %>%
    rename(index.returns = weekly.returns)
  
  # Join on date
  etf_returns_bizsci_joined <- inner_join(etf_returns_bizsci, index, by = "date")
  
  #head(etf_returns_bizsci_joined)
  
  etf_returns_bizsci_joined
}

calc_correlations <- function(etf_returns_bizsci_joined, 
                              sector_to_corr = default_sector) {
  
  # Get running correlations for all ETFs
  etf_returns_runCor_bizsci <- etf_returns_bizsci_joined %>% 
    tq_mutate_xy(x = weekly.returns, y = index.returns,  
                 mutate_fun = runCor, n = 20, col_rename = "cor")
  
  # Isolate sector to correlate, and get past the NA's for our viewing pleasure
  etf_returns_runCor_bizsci %>%
    filter(sector == sector_to_corr) %>%
    slice(20:n())
  
  etf_returns_runCor_bizsci
}

get_chart <- function(etf_returns_runCor_bizsci, 
                      index_corr = default_index_ticker, 
                      sector_to_chart = default_sector) {
  
  
  g <- etf_returns_runCor_bizsci %>%
    ungroup() %>%
    filter(sector == sector_to_chart) %>% 
    select(date, cor) %>%
    as_xts(date_col = date) %>% 
    dygraph(main = paste("Correlation between", index_corr, "and" , sector_to_chart, "ETF")) %>% 
    dyAxis("y", label = "Correlation") %>% 
    dyRangeSelector(height = 20) %>%
    # Add shading for the recessionary period
    dyShading(from = "2007-12-01", to = "2009-06-01", color = "#FFE6E6") %>% 
    # Add an event for the financial crisis. 
    dyEvent(x = "2008-09-15", label = "Fin Crisis", labelLoc = "top", color = "red")
  
  g
}


# test script
test <- FALSE
if (test) {
  cat("Calculating chart...")
  g <- load_data() %>%
    isolate_index("SPY") %>%
    calc_correlations() %>%
    get_chart("SP500 Index", "Materials")
  g
}

