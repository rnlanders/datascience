# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)

# Data Import and Cleaning
employees_tbl <- read_delim("../data/employees.csv", delim=";")
offices_tbl <- read_delim("../data/offices.csv", delim=";")
testscores_tbl <- read_delim("../data/testscores.csv", delim=";")

week13_tbl <- employees_tbl %>%
  left_join(offices_tbl, join_by(city == office)) %>%
  inner_join(testscores_tbl)
write_csv(week13_tbl, "../out/week13.csv")

# Analysis
week13_tbl %>%
  summarize(n())
week13_tbl %>%
  distinct(employee_id) %>%
  summarize(n())
week13_tbl %>%
  filter(manager_hire == "N") %>%
  group_by(city) %>%
  summarize(n())
week13_tbl %>%
  group_by(performance_group) %>%
  summarize(meanYears = mean(yrs_employed),
            sdYears = sd(yrs_employed))
week13_tbl %>%
  select(employee_id, type, test_score) %>%
  # group_by(type) %>%
  arrange(type, -test_score)
  
