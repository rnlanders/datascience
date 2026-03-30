# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(rvest)

# Data Import and Cleaning
index_tbl <- tibble(
  source = c(
    "Business",
    "Investing",
    "Tech",
    "Politics"
  ),
  url = c(
    "https://www.cnbc.com/business/",
    "https://www.cnbc.com/investing/",
    "https://www.cnbc.com/technology/",
    "https://www.cnbc.com/politics/"
  )
)

cnbc_tbl <- tibble()
for (i in 1:nrow(index_tbl)) {
  paste0("Currenly scraping row ", i)
  source <- read_html(index_tbl$url[i])
  elements <- html_elements(source, css=".TrendingNowItem-title , .Card-title")
  source_tbl <- tibble(
    headline = html_text(elements),
    length = str_count(headline, "\\S+"),
    source = index_tbl$source[i]
  )
  cnbc_tbl <- bind_rows(cnbc_tbl, source_tbl)
  Sys.sleep(2)
}

# Visualization
ggplot(cnbc_tbl,
       aes(x=source, y=length)) +
  geom_boxplot()

# Analysis
aov_result <- summary(aov(length ~ source, data = cnbc_tbl))

# Publication
paste0(
  "The results of an ANOVA comparing lengths across sources was F(",
  aov_result[[1]]$Df[1],
  ", ",
  aov_result[[1]]$Df[2],
  ") = ",
  round(aov_result[[1]]$`F value`[[1]], 2),
  ", p = ",
  str_remove(round(aov_result[[1]]$`Pr(>F)`[1], 2), "^0"), 
  ". This test was ",
  ifelse(aov_result[[1]]$`Pr(>F)`[1] < .05, "", "not "),
  "statistically significant."
)
