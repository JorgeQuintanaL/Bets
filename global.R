rm(list = ls())
library("shinydashboard")
library("httr")
library("jsonlite")
library("dplyr")
library("anytime")
library("tidyr")
library("ggplot2")
library("ggmap")
library("DT")

# setwd("~/Documents/eOddsMaker/app")

# user <- "jorge.quintana.l"
# pwd <- "jorge.quintana.l"
# JSON_stream <- stream_in(gzcon(url("http://services.eoddsmaker.net/demo/feeds/V2.0/markets.ashx?l=1&u=jorge.quintana.l&p=jorge.quintana.l&bid=1,2,14,22,47,65,83,91,93,95,96,97,98,100,103,105,106,107,108,109,110,111,112,113,114,117,118,119,120,121,122,123,124,125,126,127,128,129,130&sid=50&tsmp=2018-04-23T18:00:00&frm=json")))

load("JSON_stream.rda")
Regions <- read.delim(file = "Regions.csv", header = TRUE, sep = ",", dec = ".", stringsAsFactors = FALSE)
# register_google(key = "AIzaSyAwoxxqyumTJSm1ksS29h4sbv3eoZO7YeA")

JSON_stream$S[[1]] %>%
  unnest() %>%
  group_by(N1) %>%
  unnest(L) %>%
  group_by(N2) %>%
  unnest(E) %>%
  group_by(I3) %>%
  do(., .[which(as.logical(length(unlist(.$M) != 0))), ]) %>%
  unnest(M) %>%
  unnest(B) %>%
  unnest(O) %>%
  select(I, N, I1, N1, I2, N2, I3, DT, RND, BKS, T1, T2, T1I, T2I, SC, K, I4, H, I5, BTDT, N3, V) %>%
  setNames(c("Sport_ID", "Sport_Name", "Country_ID", "Country_Name", "League_ID", "League_Name", "Event_ID", "Event_Datetime", "Round",
             "Number_Bookies", "Team1", "Team2", "Team1_ID", "Team2_ID", "Score", "Market_Code", "I4", "Market_Arg", "BookMark_ID",
             "BOT_Date", "Odd_Name", "Odd_Value")) %>%
  mutate(Event_Datetime = anytime(Event_Datetime)) %>%
  ungroup() %>%
  left_join(x = .,
            y = Regions,
            by = "Country_Name") -> Data

df2 <- read.delim(file = "world_codes.csv", header = TRUE, sep = ",", dec = ".", stringsAsFactors = FALSE)
WorldData <- map_data("world")
WorldData %>% 
  filter(region != "Antarctica") -> WorldData

Data %>%
  group_by(Country_Name) %>%
  summarise(Reports = n()) %>%
  left_join(x = .,
            y = df2,
            by = "Country_Name") -> df2