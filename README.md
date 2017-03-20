# Fire-Sale
Empirically estimate the effect of mutual fund flows on stock prices using data at the stock-month level。
## Parameters 
The data source contains a panel dataset at the stock-month level with the following variable:
+ *permno:* Stock identifier
+ *date, month:* Date defined at month-level (in 2 different formats)
+ *month_2:* Month of the year
+ *mfflow:* Mutual fund selling pressure (see definition below)
+ *ret*: Monthly return of the stock
+ *pre*: Price of the stock at the end of the month



The mutual fund selling pressure variable MFFlow is taken from Edmans, Goldstein and Jiang (2012) hereafter EGJ12.