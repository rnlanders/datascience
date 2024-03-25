# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)      
library(rvest)
library(stringi)

# Data Import and Cleaning
websites_tbl <- tibble(
  section = c("Business","Investing","Technology","Politics"),
  url = c("https://www.cnbc.com/business/",
          "https://www.cnbc.com/investing/",
          "https://www.cnbc.com/technology/",
          "https://www.cnbc.com/politics/")
)

cnbc_tbl <- tibble()
for (i in 1:nrow(websites_tbl)) {
  downloaded_page <- read_html(websites_tbl[[i,"url"]])
  headline <- html_elements(downloaded_page, ".Card-title")
  this_tbl <- tibble(
    headline = html_text(headline),
    length = stri_count_words(headline),
    source = websites_tbl[[i,"section"]]
  )
  cnbc_tbl <- bind_rows(cnbc_tbl, this_tbl)
}

# Visualization
ggplot(cnbc_tbl,
       aes(x=source, y=length)) +
  geom_boxplot()

# Analysis
aov_results <- summary(aov(length ~ source, data=cnbc_tbl))

# Publication
paste0(
  "The results of an ANOVA comparing lengths across sources was F(",
  aov_results[[1]]$Df[1],
  ", ",
  aov_results[[1]]$Df[2],
  ") = ",
  formatC(aov_results[[1]]$`F value`[1], format="f", digits=2),
  ", p = ",
  str_replace(formatC(aov_results[[1]]$`Pr(>F)`[1], format="f", digits=2),"0\\.", "\\."),
  ". This test was ",
  ifelse(aov_results[[1]]$`Pr(>F)`[1] >= .05, "not ", ""),
  "statistically significant."
)
