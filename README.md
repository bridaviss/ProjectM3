## Contents:

### Project Description
This project aims to explore the impact of the FIFA World Cup from 1994-2022 on commodity prices of barley, corn, and cotton. These commodities, which are used to make beer, snacks/food, and clothing, are central to the fanfare that is integral to the World Cup. Conducting a time-series analysis, we will using ARIMA models, VAR models, and econometric modeling specifically to capture temporal dynamics and identify the impact and relationships of the FIFA World Cup on commodity prices. 

### What you will find in this repo: 
Each section header will direct you to the respective folder.
1. A section containg our source code and how to use and install it: SRC. 
2. A section containing our source data: DATA.
3. A section containing key figures from our analysis: FIGURES.
4. A reference section containing all acknolwedgments and references.

## [SRC Section](https://github.com/bridaviss/ProjectM3/tree/main/SRC):

### Installing/Building Our Code:
The three documents within this section contains the entire source code for our project and analysis for [Barley](https://github.com/bridaviss/ProjectM3/blob/main/SRC/BarleyAnalysis.R), [Corn](https://github.com/bridaviss/ProjectM3/blob/main/SRC/CornAnalysis.R), and [Cotton](https://github.com/bridaviss/ProjectM3/blob/main/SRC/CottonAnalysis.R). Within it, it contains our data cleaning and our analyses for these three commodities. 

### Usuage of Our Code:
The goal of this analysis was to examine the impact of the FIFA World Cup on the commodity prices of barley, corn, and cotton. 
   - To do this, we did three types of analysis:
      1. ARIMA Models
      2. VAR Models
      3. Econometric Modeling

   
## [DATA Section](https://github.com/bridaviss/ProjectM3/tree/main/DATA):
- You can download the data set from here:
     1. Barley: https://fred.stlouisfed.org/series/PBARLUSDM
     2. Cotton: https://fred.stlouisfed.org/series/PCOTTINDUSDM
     3. Corn: https://fred.stlouisfed.org/series/PMAIZMTUSDM
- You can also download the datasets from the DATA Section of this Github.


## [FIGURES Section](https://github.com/bridaviss/ProjectM3/tree/main/FIGURES):
### This is still a work in progress.

### Table of Contents:
   1. ["PricesOverTime.png"](https://github.com/bridaviss/ProjectM3/blob/main/FIGURES/PricesOverTime.png): This graphic looks at the commodity prices of barley, corn, and cotton over time with the occurence of the FIFA World Cup highlighted in red.
      - Key Takeaways: At first glance, it does not seem that the FIFA World Cup is having a massive impact on the prices of these three commidities. Throughout time, the prices are similar, but the reason for this does not seem to be the World Cup.
     
   2. ["CorrelationPrice.png"](https://github.com/bridaviss/ProjectM3/blob/main/FIGURES/CorrelationPrice.png): This graphic looks at the correlation between commodity prices between 1990-2023.
      - Key Takeaways: There seems to be a positive correlation between these three commodiities, but it does not look like the FIFA World Cup is an impact that is driving this correlation or the direction of prices.
     
   


## REFERENCES Section:
1. "Global Price of Barley," _FRED,_ Nov. 8, 2023. [Online]. Available: https://fred.stlouisfed.org/series/PBARLUSDM. [Accessed Nov. 11, 2023].
2. "Global Price of Corn," _FRED,_ Nov. 8, 2023. [Online]. Available: https://fred.stlouisfed.org/series/PMAIZMTUSDM. [Accessed Nov. 11, 2023].
3. "Global Price of Cotton," _FRED,_ Nov. 8, 2023. [Online]. Available: https://fred.stlouisfed.org/series/PCOTTINDUSDM. [Accessed Nov. 11, 2023].
4. G. Kaplanski, H. Levy, "Exploitable predictable irrationality: The FIFA World Cup effect on the U.S. Stock Market," _The Journal of Financial and Quantitative Analysis,_ vol. 45, no. 2, April, 2010. [Online serial]. Available: https://www.jstor.org/stable/27801494. [Accessed Nov. 16, 2023].
5. S. Chatterjee, "Time Series Analysis Using ARIMA Model In R," _datascience+,_ Jan. 30, 2018. [Online]. Available: https://datascienceplus.com/time-series-analysis-using-arima-model-in-r/. [Accessed Nov. 17, 2023].
6. S. Lee, "Vector Autoregressive Model (VAR) using R," _R-bloggers,_ Nov. 28, 2021. [Online]. Available: https://www.r-bloggers.com/2021/11/vector-autoregressive-model-var-using-r/. [Accessed Nov. 17, 2023]. 
7. "The Official FIFA World CupTM Partners & Sponsors since 1982," _Howler,_ [Online]. Available: https://www.whatahowler.com/wp-content/uploads/2014/01/fs-401_01_fwc-partners.pdf. [Accessed Nov. 16, 2023].
