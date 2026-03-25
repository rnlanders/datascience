library(tidyverse)
scraped1_tbl <- 
  read_csv("https://scraping.tntlab.org/add.php?x=1&y=6&format=csv",
           col_names=c("x","y","sum"))

library(httr)
scraped1_response <- GET("https://scraping.tntlab.org/add.php",
                         user_agent("Researcher at UMN rlanders@umn.edu"),
                         query = list(
                           x = 4,
                           y = 9,
                           format="csv"
                         ))
content(scraped1_response)

library(jsonlite)
scraped2 <- fromJSON("https://www.reddit.com/r/IOPsychology/.json")
tmp <- scraped2$data
tmp$children$data %>% View

library(RedditExtractoR)
help(package="RedditExtractoR")

library(qualtRics)
all_surveys()
dataset_tbl <- fetch_survey("SV_3dZMgiYlhP4jeLj")

library(rvest)
# apa_html <- read_html("https://apa.org/news/apa")
# apa_elements <- html_elements(apa_html, ".newsList a")
# apa_text <- html_text(apa_elements)
# html_text(apa_html)

ms_html <- read_html("https://ms.now")
ms_elements <- html_elements(ms_html, ".rkv-card-headline-link .has-cooper-hewitt-font-family")
ms_text <- html_text(ms_elements)
ms_text
