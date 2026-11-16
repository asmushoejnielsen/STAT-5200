# 02_main_results.R: Table 2, the main difference-in-differences results
# Weighted OLS (lm) with state fixed effects and state-specific trends.
# Standard errors are clustered by state (sandwich::vcovCL), and tests use
# 50 degrees of freedom (number of states - 1), as Stata does.

outcomes <- c("Any source"                   = "anyhi",
              "Employer dependent (parents)" = "emphi_dep",
              "Individually purchased"       = "indiv",
              "Employer own"                 = "emphi",
              "Government"                   = "govhi")

rhs <- "treat_enact + treat_implement + enact + implement + treat + factor(age) +
        y2009 + y2010 + factor(month) + trend + factor(fipstate) + factor(fipstate):trend +
        female + hispanic + white + asian + other + student + mar + fpl_ratio + fpl_ratio_2 + ue + ue_treat"

n_states <- n_distinct(data$fipstate)

stars <- function(p) case_when(p < 0.01 ~ "***", p < 0.05 ~ "**", p < 0.1 ~ "*", TRUE ~ "")

# One regression per outcome; keep the two DD coefficients
results <- map_dfr(outcomes, function(y) {
  m  <- lm(as.formula(paste(y, "~", rhs)), data = data, weights = p_weight)
  ct <- coeftest(m, vcov = vcovCL(m, cluster = ~fipstate, type = "HC1"), df = n_states - 1)
  tibble(term = c("treat_enact", "treat_implement"),
         coef = ct[term, "Estimate"],
         se   = ct[term, "Std. Error"],
         p    = ct[term, "Pr(>|t|)"])
}, .id = "outcome")

# Paper layout: one column per outcome, coefficient with stars and the SE below it
table2 <- results %>%
  mutate(est = sprintf("%.4f%s", coef, stars(p)),
         se  = sprintf("(%.4f)", se),
         term = recode(term, treat_enact = "ACA enactment effect (Mar-Sep 2010)",
                             treat_implement = "ACA implementation effect (Oct 2010-Nov 2011)")) %>%
  select(outcome, term, est, se) %>%
  pivot_longer(c(est, se), names_to = "row") %>%
  pivot_wider(names_from = outcome, values_from = value) %>%
  mutate(term = ifelse(row == "se", "", term)) %>%
  select(-row) %>%
  add_row(term = "Observations", !!!setNames(as.list(rep(format(nrow(data), big.mark = ","), 5)), names(outcomes)))

print(kable(table2, col.names = c("", names(outcomes)), align = "lccccc"))
writeLines(kable(table2, format = "html", col.names = c("", names(outcomes)), align = "lccccc",
                 caption = "Table 2. Effect of ACA on Coverage of Young Adults 19-25: Main DD Results (replication). Standard errors clustered by state in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01"),
           "output/table2.html")
