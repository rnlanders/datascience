# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)      
library(RedditExtractoR)
library(jsonlite)

# Data Import and Cleaning
reddit_thread_urls <- find_thread_urls(
  subreddit = "rstats",
  sort_by = "new",
  period = "month")
reddit_thread_urls <- reddit_thread_urls[1:10,]
reddit_content <- get_thread_content(reddit_thread_urls$url)

rstats_tbl <- tibble(
  post = reddit_content$threads$title,
  upvotes = reddit_content$threads$upvotes,
  comments = reddit_content$threads$comments
)

# first_df <- fromJSON(flatten=T,"https://www.reddit.com/r/rstats/new/.json?limit=100")
# next_search <- paste0("after=", first_df$data$after)
# newest_date <- first_df$data$children$data[1,"created"]
# reddit_data <- first_df$data$children$data
# 
# while (newest_date > as.numeric(as.POSIXct(Sys.Date() - 30 ))) {
#   next_df <- fromJSON(
#     flatten=T,
#     paste0(
#       "https://www.reddit.com/r/rstats/new/.json?limit=100&",
#       next_search)
#     )
#   newest_date <- next_df$data$children$data[1,"created"]
#   reddit_data <- bind_rows(reddit_data, next_df$data_children$data)
# }

# Visualization
ggplot(rstats_tbl,
       aes(x=upvotes, y=comments)) +
  geom_point() +
  geom_smooth(method="lm")

# Analysis
cor_result <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)

# Publication
paste0(
  "The correlation between upvotes and comments was r(",
  cor_result$parameter,
  ") = ",
  str_remove(formatC(cor_result$statistic, format="f", digits=2),"^0"),
  ", p = ",
  str_remove(formatC(cor_result$p.value, format="f", digits=2),"^0"),
  ". This test was ",
  ifelse(cor_result$p.value >= .05, "not ", ""),
  "statistically significant."
)
