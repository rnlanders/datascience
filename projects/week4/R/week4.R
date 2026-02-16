# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)

# Data Import
import_tbl <- read_delim(file = "../data/week4.dat", delim = "-", col_names = c("casenum","parnum","stimver","datadate","qs"))
glimpse(import_tbl)
wide_tbl <- separate(import_tbl, qs, paste0("q",1:5))
wide_tbl[paste0("q",1:5)] <- sapply(wide_tbl[paste0("q",1:5)], as.integer)
wide_tbl$datadate <- mdy_hms(wide_tbl$datadate)
wide_tbl[paste0("q",1:5)] <- lapply(wide_tbl[paste0("q",1:5)], \(x) { x = replace(x, x == 0, NA) })
wide_tbl <- drop_na(wide_tbl, vars)
long_tbl <- pivot_longer(wide_tbl, cols=q1:q5, names_to = "question", values_to = "response")