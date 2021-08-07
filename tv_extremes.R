library(tidyverse)
library(lubridate)
library(extRemes)

ts_shows <- read_csv("ts_shows.csv")

max_all_3 <- ts_shows %>%
  filter(!is.na(return_3)) %>%
  group_by(tv_year) %>%
  summarise(max_3=max(return_3))

max_all_3 <- data.frame(max_all_3)

max_all_3 %>% ggplot(aes(tv_year, max_3)) + geom_line()

fit_all_3 <- fevd(max_3, max_all_3, units="mil")

distill(fit_all_3)
plot(fit_all_3)
plot(fit_all_3, "trace")

ret_1 <- return.level(fit_all_3)
ret_2 <- return.level(fit_all_3, do.ci = TRUE)
ret_1[[2]]
ret_2[1,3]

max_friends_3 <- ts_shows %>%
  filter(show=="Friends") %>%
  filter(!is.na(return_3)) %>%
  group_by(tv_year) %>%
  summarise(max_3=max(return_3))

max_friends_3 <- data.frame(max_friends_3)

max_friends_3 %>% ggplot(aes(seas, max_3)) + geom_line()

fit_friends_3 <- fevd(max_3, max_friends_3, units="mil")
distill(fit_friends_3)
plot(fit_friends_3)
plot(fit_friends_3, "trace")
ret_1 <- return.level(fit_friends_3)
ret_2 <- return.level(fit_friends_3, do.ci = TRUE)
ret_1[[2]]
ret_2[1,3]
