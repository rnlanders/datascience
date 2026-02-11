library(tidyverse)

mean(mtcars$wt)
mtcars$wt %>% mean
mtcars$wt %>%
  mean %>%
  round(2)
round(mean(mtcars$wt),2)

#######
library(magrittr)
mtcars %$% mean(wt)
#######

mtcars$wt %>% mean
mtcars$wt %>% mean()
mtcars$wt |> mean     # cannot omit ()
mtcars$wt |> mean()

data1_df <- read.csv("data/realdata.csv")
data2_df <- read.csv("data/realdata.dat")
data3_df <- read.csv("data/realdata.yes")
data4_df <- read.csv("data/realdata.exe")

data1_tbl <- read_csv("data/realdata.csv")
data2_tbl <- read_csv("data/realdata.dat")
data3_tbl <- read_csv("data/realdata.yes")
data4_tbl <- read_csv("data/realdata.exe")

glimpse(data3_tbl)

barplot(c(1,2,3))

ymd("99 April 1")

str_detect("yes", "y")
