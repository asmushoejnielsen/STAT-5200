# Nielsen Replication

Asmus Nielsen, STAT 5200, Fall 2026

This is my replication of:

Akosa Antwi, Y., Moriya, A. S., & Simon, K. (2013). Effects of federal policy to insure young adults: Evidence from the 2010 Affordable Care Act's dependent-coverage mandate. American Economic Journal: Economic Policy, 5(4), 1–28. https://doi.org/10.1257/pol.5.4.1

I replicate Table 1 (descriptive statistics), Table 2 (main results) and Figure 1. The data is from the authors' replication package on openICPSR (project 114840).

## How to run

Open `Nielsen Replication.Rproj` in RStudio, install the packages once with

```r
install.packages(c("tidyverse", "sandwich", "lmtest", "knitr"))
```

and then run `code/run_all.R`.

## Folders

- `code/`: the R scripts. `00` reads the data, `01` makes Table 1, `02` makes Table 2 and `03` makes Figure 1.
- `data/`: the authors' data file, their ReadMe and the license.
- `output/`: the tables and the figure.
- `presentation/`: my slides.

## Results

The replication works.

- Table 1 matches the paper except one value: the share of college graduates among 16–18 year olds is 0.001 for me and 0 in the paper.
- Table 2: all coefficients match. Two standard errors differ by 0.0001, which comes from using R instead of Stata.
- Figure 1 looks the same as in the paper.
