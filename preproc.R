library(tidyverse)
library(hash)
library(lubridate)
library(zoo)

show_files = c("the_big_bang_theory.csv", "ncis.csv", "cis.csv", 
               "desperate_housewives.csv", "friends.csv", "er.csv", "frasier.csv", 
               "seinfeld.csv", "home_improvement.csv", "roseanne.csv", "cheers.csv")

h <- hash()
h[["the_big_bang_theory.csv"]] <- "The Big Bang Theory"
h[["ncis.csv"]] <- "NCIS"
h[["cis.csv"]] <- "CIS"
h[["desperate_housewives.csv"]] <- "Desperate Housewives"
h[["friends.csv"]] <- "Friends"
h[["er.csv"]] <- "ER"
h[["frasier.csv"]] <- "Frasier"
h[["seinfeld.csv"]] <- "Seinfeld"
h[["home_improvement.csv"]] <- "Home Improvement"
h[["roseanne.csv"]] <- "Roseanne"
h[["cheers.csv"]] <- "Cheers"


season <- function(j, v) { 
  return(which(v == j))
}

shows <- data.frame()

for (x in show_files) {
  show_df = read.csv(x, fileEncoding="UTF-8-BOM")
  show_df = show_df %>%
    mutate(show=h[[x]], seas=ep_num_show-ep_num_seas, .before=ep_num_show)
  show_df = show_df %>% mutate(seas=sapply(as.vector(unlist(show_df["seas"])), 
                                           season, v = show_df %>% distinct(seas)))
  shows <- bind_rows(shows, show_df)
  rm(show_df)
}

rm(h, show_files, x, season)

shows <- shows %>% mutate(viewers=sapply(viewers,str_replace_all, 
                                         pattern="\\[\\w+\\]|\\[\\w+", replacement=""))
shows <- shows %>% transform(viewers=as.numeric(viewers))
shows <- shows %>% mutate(air_date=sapply(air_date,mdy))
shows <- shows %>% transform(air_date=as_date(air_date))
shows <- shows %>% filter(viewers>0|is.na(viewers))

View(shows %>% group_by(show) %>% 
       summarise(pmva_3 = rollapply(viewers, c(-3,-2,-1), mean, fill="extend")))

length(shows$viewers)
rollapply(shows$viewers, c(-3,-2,-1), mean, fill="extend", partial=TRUE)

View(shows %>% group_by(show) %>% summarise(n())) 

nas_viewers <- shows %>% filter(is.na(viewers))

df_cis <- shows %>% filter(show=="CIS") %>% select(air_date, viewers)
df_cis <- df_cis %>% mutate(lag = lag(viewers))
df_lag <- df_cis %>% select(air_date, lag)

z_mva <- rollapply(read.zoo(df_lag), 3, mean, align="right", fill="extend", partial=TRUE)

df_mva = data.frame(air_date=index(z_mva), as.data.frame(z_mva) %>% rename(pmva_3 = z_mva))

df_cis$pmva_3 = df_mva$pmva_3




