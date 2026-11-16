# 00_read_data.R: read the authors' data and make the variables
# Data: openICPSR 114840, SIPP 2008 panel, one row per person-month

library(tidyverse)   # dplyr, ggplot2, haven, ...
library(haven)       # read_dta() for the Stata file
library(sandwich)    # clustered standard errors
library(lmtest)      # coeftest()
library(knitr)       # kable() tables

data <- read_dta("data/depcov_dataset.dta") %>%
  zap_labels() %>%
  mutate(
    # Age groups: 19-25 are treated, 16-18 and 27-29 are controls
    group = case_when(age <= 18 ~ "16-18", age <= 25 ~ "19-25", TRUE ~ "27-29"),
    treat = as.numeric(age >= 19 & age <= 25),

    # Policy periods: enactment (Mar-Sep 2010) and implementation (Oct 2010 on)
    enact     = as.numeric(year == 2010 & month >= 3 & month <= 9),
    implement = as.numeric(year == 2011 | (year == 2010 & month >= 10)),

    # Difference-in-differences terms
    treat_enact     = treat * enact,
    treat_implement = treat * implement,

    # Controls used by the authors
    trend      = (year - 2008) * 12 + (month - 8),
    ue_treat   = ue * treat,
    y2009      = as.numeric(year == 2009),
    y2010      = as.numeric(year == 2010),
    employed   = as.numeric(labor == 1),
    unemployed = as.numeric(labor == 2)
  )
