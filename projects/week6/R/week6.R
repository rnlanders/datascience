# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(stringi)



# Data Import
citations <- stri_read_lines("../data/citations.txt", encoding="ISO-8859-1")
citations_txt <- citations[!stri_isempty(citations)]
length(citations) - length(citations_txt)
mean(str_length(citations_txt))

# Data Cleaning
sample_n(citations_tbl, 50) %>%
  View
citations_tbl <- tibble(line = 1:length(citations_txt), cite = citations_txt) %>%
  mutate(cite = str_remove_all(cite, "[\"']")) %>%
  mutate(year = as.integer(str_extract(cite, "\\d{4}"))) %>%
  mutate(page_start = as.integer(str_match(cite, "(\\d+)-\\d+")[,2])) %>%
  mutate(perf_ref = str_detect(str_to_lower(cite), "performance")) %>%
  mutate(title = str_match(cite, "\\d{4}\\)\\. ([^\\.]+)")[,2]) %>%
  mutate(first_author = str_extract(cite, "^\\w+, \\w\\.? ?\\w?\\.? ?\\w?\\."))

sum(!is.na(citations_tbl$first_author))

# Other Code for Reference
tibble(stri_enc_list()) %>% 
  filter(str_detect(`stri_enc_list()`, "windows")) %>%
  View
citations_text <- citations[!str_detect(citations, "^\\s*$")]
citations_text <- str_subset(citations, pattern="\\S+")
