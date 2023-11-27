# Load required libraries
library(tidyverse)
library(forecast)
library(urca)
library(vars)

# Read the CSV file and convert the DATE column to a Date type
barley_data <- read.csv('PBARLUSDM.csv')
barley_data$DATE <- as.Date(barley_data$DATE)

corn_data <- read.csv("PMAIZMTUSDM.csv")
corn_data$DATE <- as.Date(corn_data$DATE)

cotton_data <- read.csv("PCOTTINDUSDM.csv")
cotton_data$DATE <- as.Date(cotton_data$DATE)

# World Cup dates
world_cup_dates <- list(
  "1994" = c(as.Date("1994-06-01"), as.Date("1994-08-01")),  # 1994 World Cup dates
  "1998" = c(as.Date("1998-06-01"), as.Date("1998-08-01")),  # 1998 World Cup dates
  "2002" = c(as.Date("2002-06-01"), as.Date("2002-07-01")),  # 2002 World Cup dates
  "2006" = c(as.Date("2006-06-01"), as.Date("2006-08-01")),  # 2006 World Cup dates
  "2010" = c(as.Date("2010-06-01"), as.Date("2010-08-01")),  # 2010 World Cup dates
  "2014" = c(as.Date("2014-06-01"), as.Date("2014-08-01")),  # 2014 World Cup dates
  "2018" = c(as.Date("2018-06-01"), as.Date("2018-08-01")),  # 2018 World Cup dates
  "2022" = c(as.Date("2022-11-01"), as.Date("2023-01-01"))   # 2022 World Cup dates 
)

# Function to check if a date is within the World Cup window
is_in_world_cup_window <- function(date, world_cup_dates) {
  any(sapply(world_cup_dates, function(window) date >= window[1] & date <= window[2]))
}

# Apply the function to identify World Cup dates in the data
barley_data$in_world_cup <- sapply(barley_data$DATE, function(date) is_in_world_cup_window(date, world_cup_dates))

# Convert the in_world_cup column to logical
barley_data$in_world_cup <- as.logical(barley_data$in_world_cup)

# Subset the data for rows inside and outside the World Cup window
barley_in_world_cup <- subset(barley_data, in_world_cup == TRUE)
barley_outside_world_cup <- subset(barley_data, in_world_cup == FALSE)

# Compare average barley prices inside and outside the World Cup window
mean_price_in_world_cup <- mean(barley_in_world_cup$PBARLUSDM, na.rm = TRUE)
mean_price_outside_world_cup <- mean(barley_outside_world_cup$PBARLUSDM, na.rm = TRUE)

# Display the results
data.frame(
  in_world_cup = c("Inside", "Outside"),
  mean_price = c(mean_price_in_world_cup, mean_price_outside_world_cup)
)

# Perform t-test for barley prices during World Cup vs. non-World Cup periods
t_test_barley <- t.test(PBARLUSDM ~ in_world_cup, data = barley_data)
print(t_test_barley)
)

ggplot(commodity_data, aes(x = DATE)) +
  geom_line(aes(y = PCOTTINDUSDM, color = "Cotton"), size = 1) +
  geom_line(aes(y = PMAIZMTUSDM, color = "Corn"), size = 1) +
  geom_line(aes(y = PBARLUSDM, color = "Barley"), size = 1) +
  scale_color_manual(values = c("Cotton" = "blue", "Corn" = "green", "Barley" = "yellow")) +
  geom_vline(data = commodity_data %>% filter(world_cup), aes(xintercept = as.numeric(DATE)), color = "red", linetype = "dashed", size = 1) +
  labs(title = "Commodity Prices Over Time with World Cup Periods Highlighted",
       x = "Date",
       y = "Price (USD)",
       color = "Commodity") +
  theme_minimal()

# Making one big dataset
commodity_1<- merge( barley_data , cotton_data )

commodity_data <- merge( commodity_1 , corn_data )

# Convert DATE to Date type
commodity_data$DATE <- as.Date(commodity_data$DATE)

colnames(commodity_data)

# Create VAR model
var_model <- VAR(commodity_data[, c("PBARLUSDM", "PCOTTINDUSDM", "PMAIZMTUSDM")], type = "both", lag.max = 4)

# Granger causality test
granger_test_result <- causality(var_model, cause = "PBARLUSDM")
print(granger_test_result)

# Impulse response function
irf_result <- irf(var_model, impulse = "PBARLUSDM", response = c("PCOTTINDUSDM", "PMAIZMTUSDM"), n.ahead = 10)

# Plot impulse response functions
plot(irf_result, main = "Impulse Response Functions", ylab = "Response", xlab = "Time")

# Extract time series for Barley prices
barley_ts <- ts(barley_data$PBARLUSDM, start = min(barley_data$DATE), frequency = 365)

# ARIMA model
arima_model <- auto.arima(barley_ts)

# Summary of ARIMA model
summary(arima_model)

# Plot ARIMA forecast
plot(forecast(arima_model, h = 12), main = "ARIMA Forecast for Barley Prices", xlab = "Date", ylab = "Price")

# Create time series for Barley prices during World Cup
barley_ts_world_cup <- ts(subset(commodity_data, in_world_cup == TRUE)$PBARLUSDM, start = min(commodity_data$DATE), frequency = 365)

# Create time series for Barley prices outside World Cup
barley_ts_non_world_cup <- ts(subset(commodity_data, in_world_cup == FALSE)$PBARLUSDM, start = min(commodity_data$DATE), frequency = 365)

# Fit ARIMA models for World Cup and non-World Cup periods
arima_model_world_cup <- auto.arima(barley_ts_world_cup)
arima_model_non_world_cup <- auto.arima(barley_ts_non_world_cup)

summary(arima_model_world_cup)
summary(arima_model_non_world_cup)

# Create a binary indicator for World Cup periods
commodity_data$in_world_cup <- sapply(commodity_data$DATE, function(date) is_in_world_cup_window(date, world_cup_dates))
commodity_data$in_world_cup <- as.logical(commodity_data$in_world_cup)

# Create VAR model using only data during World Cup periods
var_model_world_cup <- VAR(subset(commodity_data, in_world_cup == TRUE)[, c("PBARLUSDM", "PCOTTINDUSDM", "PMAIZMTUSDM")], type = "both", lag.max = 4)

# Create VAR model using only data outside World Cup periods
var_model_non_world_cup <- VAR(subset(commodity_data, in_world_cup == FALSE)[, c("PBARLUSDM", "PCOTTINDUSDM", "PMAIZMTUSDM")], type = "both", lag.max = 4)

coef(var_model_world_cup)
coef(var_model_non_world_cup)

str(barley_data)

barley_ts_decomp <- decompose(ts(barley_data$PBARLUSDM, start = min(barley_data$DATE), frequency = 12))


# Plot decomposed components
plot(barley_ts_decomp)

# Granger Causality Test
granger_test_result <- causality(var_model, cause = "PBARLUSDM")
print(granger_test_result)

# Impulse Response Analysis
irf_result <- irf(var_model, impulse = "PBARLUSDM", response = c("PCOTTINDUSDM", "PMAIZMTUSDM"), n.ahead = 10)

# Plot impulse response functions
plot(irf_result, main = "Impulse Response Functions", ylab = "Response", xlab = "Time")





