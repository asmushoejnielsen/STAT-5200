# 03_figure1.R: Figure 1, share with any insurance by quarter

fig <- data %>%
  mutate(quarter = year + (ceiling(month / 3) - 1) / 4,
         arm = ifelse(treat == 1, "Treatment (19-25)", "Control (16-18, 27-29)")) %>%
  filter(quarter >= 2009) %>%
  group_by(quarter, arm) %>%
  summarise(insured = 100 * weighted.mean(anyhi, p_weight), .groups = "drop")

ggplot(fig, aes(quarter, insured, colour = arm)) +
  geom_line() +
  geom_vline(xintercept = c(2010, 2010.5, 2011), linetype = "dashed") +
  labs(x = "Year", y = "Any health insurance (%)", colour = NULL) +
  theme(legend.position = "bottom")

ggsave("output/figure1.png", width = 7, height = 4.5)
