# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(stringi)



# Data Import
citations <- stri_read_lines("../data/cites.txt")
citations_txt <- str_subset(citations, "\\S")
str_c("Number of blank lines eliminated was ", length(citations) - length(citations_txt))
str_c("The average number of characters/citation was", mean(str_length(citations_txt)))

# Data Cleaning
slice_sample(citations_tbl, n=12) %>%
  select(authors)

citations_tbl <- tibble(line=seq_along(citations_txt), cite=citations_txt) %>%
  mutate(
    authors = str_match(cite, "^\\*?(.+)\\(\\d+[a-z]?,? ?\\)")[,2],
    year = str_match(cite, "^\\*?.+\\((\\d+)[a-z]?,? ?\\)")[,2],
    title = str_extract(cite, "(?<=\\)\\.\\s).*?(?=[.?!]\\s)"),
    
    
    
    
    
    perf_ref = str_detect(cite, "[Pp]erformance"),
    first_author = str_extract(cite, "^\\w+, \\w\\. ?\\w?\\.? ?\\w?\\.?")
  ) 
# Analysis
citations_tbl %>%
  summarize(cites = n(), 
            first_authors = sum(!is.na(first_author)),
  )






citations_tbl %>%
  filter(perf_ref, 
         !is.na(journal_title)) %>%
  count(journal_name = journal_title,
        name = "frequency") %>%
  slice_max(frequency, n=10, with_ties = T) %>%
  arrange(desc(frequency))
citations_tbl %>%
  count(cite, 
        name = "frequency", 
        sort = T) %>%
  rename(citation = cite) %>%
  head(10)

# Alternative Code
citations_txt <- citations[!stri_isempty(citations)]
citations_txt <- citations[citations!=""]
citations_tbl <- tibble(line=1:length(citations_txt), 
                        cite=citations_txt)
citations_tbl %>% sample_n(10) %>% pull(cite) %>% writeLines
tmp <- slice_sample(citations_tbl, n=12)
tmp$cite %>% sample(10) %>% writeLines



