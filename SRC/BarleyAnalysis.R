# Load required libraries
library(tidyverse)
library(vars)

# Read the CSV file and convert the DATE column to a Date type
barley_data <- read.csv('PBARLUSDM.csv')
barley_data$DATE <- as.Date(barley_data$DATE)

# World Cup dates
world_cup_dates <- list(
  "1994" = c(as.Date("1994-03-01"), as.Date("1994-11-01")),  
  "1998" = c(as.Date("1998-03-01"), as.Date("1998-11-01")),  
  "2002" = c(as.Date("2002-03-01"), as.Date("2002-10-01")),  
  "2006" = c(as.Date("2006-03-01"), as.Date("2006-11-01")),  
  "2010" = c(as.Date("2010-03-01"), as.Date("2010-11-01")),  
  "2014" = c(as.Date("2014-03-01"), as.Date("2014-11-01")),  
  "2018" = c(as.Date("2018-03-01"), as.Date("2018-11-01")),  
  "2022" = c(as.Date("2022-08-01"), as.Date("2023-03-01"))   
)

# Function to check if a date is within the World Cup window
is_in_world_cup_window <- function(date, world_cup_dates) {
  any(sapply(world_cup_dates, function(window) {
    start_date <- window[1]
    end_date <- window[2]
    date >= start_date & date <= end_date
  }))
}

# Function to calculate percent changes
calculate_percent_change <- function(x) {
  c(NA, diff(x) / lag(x, default = x[1]))[-1]  # Remove the first NA
}

# Create a binary variable for World Cup periods
barley_data$in_world_cup <- as.numeric(sapply(barley_data$DATE, function(date) is_in_world_cup_window(date, world_cup_dates)))

# Create lagged variables for barley prices
barley_data <- barley_data %>%
  arrange(DATE) %>%
  mutate(
    lag1 = lag(PBARLUSDM),
    lag2 = lag(PBARLUSDM, 2),
    price_change = PBARLUSDM - lag(PBARLUSDM),
    percent_change = calculate_percent_change(PBARLUSDM),  # Calculate percent changes
    in_world_cup = lag(in_world_cup, 1)
  ) %>%
  filter(!is.na(lag2))  # Remove rows with missing values in lag2

# Check for perfect multicollinearity
cor_matrix <- cor(barley_data[, c("PBARLUSDM", "lag1", "lag2", "price_change", "percent_change", "in_world_cup")], use = "complete.obs")
print(cor_matrix)

# Calculate average percent changes for World Cup and non-World Cup periods
percent_changes <- barley_data %>%
  group_by(in_world_cup) %>%
  summarise(avg_percent_change = mean(percent_change, na.rm = TRUE))

# Visualize percent changes
ggplot(percent_changes, aes(x = factor(in_world_cup), y = avg_percent_change, fill = factor(in_world_cup))) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("World Cup Period") +
  ylab("Average Barley Percent Change") +
  ggtitle("Average Barley Percent Changes in World Cup vs. Non-World Cup Periods") +
  scale_fill_manual(name = "World Cup", values = c("0" = "blue", "1" = "red")) +
  theme_minimal()

# Check for perfect multicollinearity
cor_matrix <- cor(barley_data[, c("PBARLUSDM", "lag1", "lag2", "price_change", "percent_change", "in_world_cup")], use = "complete.obs")
print(cor_matrix)

# Subset the data for rows inside and outside the World Cup window
barley_in_world_cup <- barley_data %>% filter(in_world_cup == 1)
barley_outside_world_cup <- barley_data %>% filter(in_world_cup == 0)

# Compare percent changes between World Cup and non-World Cup periods
t_test_result <- t.test(barley_in_world_cup$percent_change, barley_outside_world_cup$percent_change)

# Display the t-test result
print(t_test_result)

# Visualize percent changes over time
ggplot(barley_data, aes(x = DATE, y = percent_change, color = factor(in_world_cup))) +
  geom_line() +
  xlab("Date") +
  ylab("Barley Percent Change") +
  ggtitle("Barley Percent Changes Over Time") +
  scale_color_manual(name = "World Cup", values = c("0" = "blue", "1" = "red"))



# Econometric Modeling
econometric_model <- lm(PBARLUSDM ~ in_world_cup + lag1 + lag2, data = barley_data)
summary(econometric_model)

# Create a time series object
barley_ts <- ts(barley_data[, c("PBARLUSDM", "in_world_cup")], start = min(barley_data$DATE), frequency = 1)

# Granger Causality Test
granger_test <- grangertest(barley_ts, order = 2)

# Display the Granger causality test result
print(granger_test)

# ARIMA Modeling
barley_diff <- diff(barley_data$PBARLUSDM)

# ACF and PACF plots for ARIMA parameter selection
acf(barley_diff, lag.max = 20)
pacf(barley_diff, lag.max = 20)

# Identify ARIMA parameters
arima_order <- c(2, 1, 2)  # Replace with the identified order from the plots

# Fit ARIMA model
arima_model <- arima(barley_data$PBARLUSDM, order = arima_order)
summary(arima_model)

# Diagnostic checks for ARIMA
acf(residuals(arima_model))
Box.test(residuals(arima_model), lag = 20, type = "Ljung-Box")
shapiro.test(residuals(arima_model))

# VAR Modeling
var_order <- VARselect(barley_data[, c("PBARLUSDM", "in_world_cup")], lag.max = 10)
selected_lag <- var_order$selection[1]  # Choose the lag order based on the selection criteria

# Fit VAR model
var_model <- VAR(barley_data[, c("PBARLUSDM", "in_world_cup")], p = selected_lag)
summary(var_model)

# Granger causality test for VAR
granger_test_var <- causality(var_model, cause = "in_world_cup")
print(granger_test_var)

# Impulse response analysis for VAR
irf <- irf(var_model, impulse = "in_world_cup", response = c("PBARLUSDM", "in_world_cup"), n.ahead = 10)
plot(irf)









