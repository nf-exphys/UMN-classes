library(pwr); library(tidyverse)

power6 <- pwr.2p.test(h = ES.h(p1 = 0.6, p2 = 0.66), sig.level = 0.05, power = 0.80)
plot(power6)

power7 <- pwr.2p.test(h = ES.h(p1 = 0.6, p2 = 0.67), sig.level = 0.05, power = 0.80)
power8 <- pwr.2p.test(h = ES.h(p1 = 0.6, p2 = 0.68), sig.level = 0.05, power = 0.80)
power9 <- pwr.2p.test(h = ES.h(p1 = 0.6, p2 = 0.69), sig.level = 0.05, power = 0.80)

power10 <- pwr.2p.test(h = ES.h(p1 = 0.6, p2 = 0.70), sig.level = 0.05, power = 0.80)
plot(power10)

pwr_table <- tibble(
  ss_per_group = c(power6$n, power7$n, power8$n, power9$n, power10$n),
  assumed_diff = c(6,7,8,9,10)) %>%
  mutate(ss_per_group = as.integer(ss_per_group *2/0.8)) #adjust for drop-out
pwr_table

#re-run with 90% power
power6_90 <- pwr.2p.test(h = ES.h(p1 = 0.6, p2 = 0.66), sig.level = 0.05, power = 0.90)
as.integer(power6_90$n*2/0.8)
power10_90 <- pwr.2p.test(h = ES.h(p1 = 0.6, p2 = 0.70), sig.level = 0.05, power = 0.90)
as.integer(power10_90$n*2/0.8)
