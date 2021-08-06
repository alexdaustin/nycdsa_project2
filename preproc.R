library(tidyverse)
library(hash)
library(lubridate)
library(zoo)

show_files <- c("the_big_bang_theory.csv", "ncis.csv", "cis.csv", 
                "desperate_housewives.csv", "friends.csv", "er.csv", "frasier.csv", 
                "seinfeld.csv", "home_improvement.csv", "roseanne.csv", "cheers.csv")

show_names <- c("The Big Bang Theory", "NCIS", "CIS", 
                "Desperate Housewives", "Friends", "ER", "Frasier", 
                "Seinfeld", "Home Improvement", "Roseanne", "Cheers")

h <- hash()

for (x in show_files) {
  h[[x]] <- show_names[which(show_files==x)]
}

season <- function(j, v) { 
  which(v == j)
}

shows <- data.frame()

for (x in show_files) {
  df_show = read.csv(x, fileEncoding="UTF-8-BOM")
  df_show = df_show %>%
    mutate(show=h[[x]], seas=ep_num_show-ep_num_seas, .before=ep_num_show)
  df_show = df_show %>% mutate(seas=sapply(as.vector(unlist(df_show["seas"])), 
                                           season, v = df_show %>% distinct(seas)))
  shows <- bind_rows(shows, df_show)
  rm(df_show)
}

rm(h, show_files, x, season)

shows <- shows %>%
  mutate(viewers=sapply(viewers,str_replace_all, 
                        pattern="\\[\\w+\\]|\\[\\w+", replacement=""))
shows <- shows %>%
  mutate(title=sapply(title,str_replace_all, 
                      pattern="\\[\\w+\\]", replacement=""))
shows <- shows %>% transform(viewers=as.numeric(viewers))
shows <- shows %>% mutate(air_date=sapply(air_date,mdy))
shows <- shows %>% transform(air_date=as_date(air_date))
shows <- shows %>% filter(viewers>0|is.na(viewers))

nas_viewers <- shows %>%
  filter(is.na(viewers))

ts_shows <- data.frame()

for (x in show_names) {
  df_show = shows %>%
    filter(show==x) %>%
    mutate(lag = lag(viewers))
  
  df_lag = df_show %>%
    select(air_date, lag)
  
  z_mva = rollmean(na.fill(read.zoo(df_lag), c(NA, "extend", "extend")),
                   3, align="right", fill=NA)
  df_mva = data.frame(air_date=index(z_mva), as.data.frame(z_mva) %>%
                        rename(pmva_3 = z_mva))
  df_show$pmva_3 = df_mva$pmva_3
  
  rm(z_mva, df_mva)
  
  z_mva = rollmean(na.fill(read.zoo(df_lag), c(NA, "extend", "extend")),
                   5, align="right", fill=NA)
  df_mva = data.frame(air_date=index(z_mva), as.data.frame(z_mva) %>%
                        rename(pmva_5 = z_mva))
  df_show$pmva_5 = df_mva$pmva_5
  
  rm(df_lag, z_mva, df_mva)
  
  ts_shows <- bind_rows(ts_shows, df_show)
  rm(df_show)
}

rm(x, show_names, shows)

ts_shows <- ts_shows %>%
  mutate(pmva_3 = round(pmva_3, 3), pmva_5 = round(pmva_5, 3),
         return_1 = round((viewers - lag)/lag, 4), 
         return_3 = round((viewers - pmva_3)/pmva_3, 4),
         return_5 = round((viewers - pmva_5)/pmva_5, 4))

ts_shows <- ts_shows %>%
  mutate(tv_year =
           ifelse(month(air_date) < 8, year(air_date)-1, year(air_date)),
         .after=air_date)

summary(ts_shows)

write_csv(ts_shows, "ts_shows.csv")


