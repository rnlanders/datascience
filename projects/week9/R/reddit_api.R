# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)      
library(RedditExtractoR)
library(jsonlite)

# Data Import and Cleaning

## Approach 1 using RedditExtractoR
reddit_thread_urls <- find_thread_urls(
  subreddit = "rstats",
  sort_by = "new",
  period = "month") %>%
  mutate(date_utc = ymd(date_utc))

### checking how many posts are from the last month
thread_urls2 <- filter(reddit_thread_urls, timestamp > as.numeric(as.POSIXct(Sys.Date() - 30)))
nrow(thread_urls2)

reddit_thread_urls <- reddit_thread_urls[1:10,]
reddit_content <- get_thread_content(reddit_thread_urls$url)

rstats_tbl <- tibble(
  post = reddit_content$threads$title,
  upvotes = reddit_content$threads$upvotes,
  comments = reddit_content$threads$comments
)

## Approach 2 using JSON calls
first_df <- fromJSON("https://www.reddit.com/r/rstats/new/.json?limit=100",
                     flatten=T)
next_search <- paste0("after=", first_df$data$after)
newest_date <- first_df$data$children$data.created[1]
reddit_tbl <- tibble(
  title = first_df$data$children$data.title,
  upvotes = first_df$data$children$data.ups,
  comments = first_df$data$children$data.num_comments,
  date = first_df$data$children$data.created
)
  
while (newest_date > as.numeric(as.POSIXct(Sys.Date() - 30))) {
  next_df <- fromJSON(
    paste0(
      "https://www.reddit.com/r/rstats/new/.json?limit=100&",
      next_search),
    flatten=T
    )
  newest_date <- next_df$data$children$data.created[1]
  next_search <- paste0("after=", next_df$data$after)
  this_tbl <- tibble(
    title = next_df$data$children$data.title,
    upvotes = next_df$data$children$data.ups,
    comments = next_df$data$children$data.num_comments,
    date = next_df$data$children$data.created
  )
  reddit_tbl <- bind_rows(reddit_tbl, this_tbl)
}

### Checking how many posts are from the last month - should match above
reddit2_tbl <- filter(reddit_tbl, date > as.numeric(as.POSIXct(Sys.Date() - 30)))
nrow(reddit2_tbl)

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
  str_replace(formatC(cor_result$estimate, format="f", digits=2),"0\\.", "\\."),
  ", p = ",
  str_replace(formatC(cor_result$p.value, format="f", digits=2),"0\\.", "\\."),
  ". This test was ",
  ifelse(cor_result$p.value >= .05, "not ", ""),
  "statistically significant."
)
