# 01_descriptives.R: Table 1, weighted means by age group

labels <- c(anyhi      = "Covered by any health insurance",
            emphi_dep  = "Covered by employer HI as a parent's dependent",
            emphi      = "Covered by own employer HI",
            indiv      = "Covered by individually purchased HI",
            govhi      = "Covered by government HI",
            employed   = "Employed",
            unemployed = "Unemployed",
            age        = "Age",
            white      = "White",
            black      = "African-American",
            hispanic   = "Hispanic",
            mar        = "Married",
            ft_student = "Student",
            hsdo       = "Less than high school",
            hsg        = "High school graduate",
            somcol     = "Some college",
            colgrd     = "College graduate",
            bad_hlth   = "Health less than excellent")

# Weighted means for all observations and for each age group
group_means <- data %>%
  bind_rows(mutate(data, group = "All observations")) %>%
  group_by(group) %>%
  summarise(across(all_of(names(labels)), ~ weighted.mean(.x, p_weight, na.rm = TRUE)),
            n = n())

table1 <- group_means %>%
  select(-n) %>%
  pivot_longer(-group, names_to = "variable") %>%
  mutate(value = ifelse(variable == "age", sprintf("%.2f", value), sprintf("%.3f", value))) %>%
  pivot_wider(names_from = group, values_from = value) %>%
  mutate(variable = labels[variable]) %>%
  select(Variable = variable, `All observations`, `16-18`, `19-25`, `27-29`)

# Number of person-months in each column
obs <- group_means %>% select(group, n) %>% deframe()
table1 <- table1 %>%
  add_row(Variable = "Person-month observations",
          `All observations` = format(obs[["All observations"]], big.mark = ","),
          `16-18` = format(obs[["16-18"]], big.mark = ","),
          `19-25` = format(obs[["19-25"]], big.mark = ","),
          `27-29` = format(obs[["27-29"]], big.mark = ","))

print(kable(table1, align = "lrrrr"))
writeLines(kable(table1, format = "html", align = "lrrrr",
                 caption = "Table 1. Demographic, Socioeconomic, and Insurance Characteristics (replication)"),
           "output/table1.html")
