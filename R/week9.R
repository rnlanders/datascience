library(tidyverse)
library(httr)

dataset_tbl <- read_csv(
  "https://scraping.tntlab.org/add.php?x=122&y=982&format=csv",
  col_names=c("x","y","sum"))

get_data <- GET(
  user_agent("i'm someone over here"),
  url="https://scraping.tntlab.org/add.php",
  query=list(
    x = 122,
    y = 982,
    format = "csv"
  )
)
content(get_data, as="text") %>%
  str_split(",")

library(jsonlite)
io_output <- fromJSON("https://www.reddit.com/r/IOPsychology/.json")
io_df <- io_output$data$children$data

library(rvest)
apa_page <- read_html("https://apa.org/news/apa")
apa_elements <- html_elements(apa_page, ".newsList a")
apa_text <- html_text(apa_elements)
apa_links <- html_attr(apa_elements, "href")
apa_tbl <- tibble(
  link_title = apa_text,
  link_url = apa_links
)
View(apa_tbl)
