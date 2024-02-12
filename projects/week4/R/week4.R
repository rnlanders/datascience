# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)

# Data Import
import_tbl <- read_delim("../data/week4.dat", delim="-", col_names=c("casenum","parnum","stimver","datadate","qs"))
glimpse(import_tbl)
wide_tbl <- separate(import_tbl, qs, into=paste0("q",1:5))
wide_tbl[,paste0("q",1:5)] <- sapply(wide_tbl[,paste0("q",1:5)], as.integer)
wide_tbl$datadate <- mdy_hms(wide_tbl$datadate)
wide_tbl[,paste0("q",1:5)] <- replace(wide_tbl[,paste0("q",1:5)], wide_tbl[,paste0("q",1:5)] == 0, NA)
wide_tbl <- drop_na(wide_tbl, q2)
long_tbl <- pivot_longer(wide_tbl, q1:q5)


# Alternatives
wide_tbl <- separate_wider_delim(import_tbl, cols="qs", delim=" - ", names=c("q1", "q2", "q3", "q4", "q5"))
wide_tbl$datadate <- as_datetime(x=wide_tbl$datadate, format="%B %d %Y, %T")
wide_tbl[,paste0("q",1:5)][wide_tbl[,paste0("q",1:5)] == 0] <- NA  
wide_tbl <- subset(wide_tbl, !is.na(q2))
