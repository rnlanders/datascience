# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(RedditExtractoR)

# Data Import and Cleaning
threads_df <- find_thread_urls(subreddit = "rstats", sort_by="new", period="day")
threads_cleaned_df <- threads_df %>%
  mutate(date_utc = ymd(date_utc)) %>%
  # filter(date_utc > "2026-02-28")
  filter(date_utc > "2026-03-20")
content_df <- get_thread_content(threads_cleaned_df$url)$threads
rstats_tbl <- select(content_df, post=title, upvotes, comments)

# Visualization
ggplot(rstats_tbl,
       aes(x=upvotes, y=comments)) +
  geom_point()

# Analysis
cor_results <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)

# Publication
paste0(
  "The correlation between upvotes and comments was r(",
  cor_results$parameter,
  ") = ",
  str_remove(round(cor_results$estimate, 2), "^0"),
  ", p = ",
  str_remove(round(cor_results$p.value, 2), "^0"),
  ". This test was ",
  ifelse(cor_results$p.value < .05, "", "not "),
  "statistically significant."
)