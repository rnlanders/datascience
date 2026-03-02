"\t"
"  "
"yes\tno"
writeLines("yes\tno")

"\""
writeLines("\"")
writeLines("\'")
writeLines("'")
#writeLines(")','')

?Quotes
234243.23482347823478243786234786234786
f <- 13423842.23423487234897234987234897
g <- 1.342384223423487234897234987234897
h <- 1342384223423487234897.234987234897

getOption("digits")
options(digits = 1)

f
format(f, digits=3)
formatC(f, format="f", digits=3)

options(digits = 7)

a <- c("a","b","c")
b <- 1:3
paste0(c(a,b))
paste0(c(a,b), collapse="")

library(tidyverse)
# library(stringr)
library(stringi)

paste0(c("a","b"), 1:5)
str_c(c("a","b"), 2:4)

length("hello")
str_length("hello")

str_sub("hello", 2, 4)
str_sub("hello", 2, 10)
str_sub("hello", 2, -1)
str_sub("hello", 2, -2)
str_sub("hello", , -2)

str_detect("1. adkhjadfhjksdfj",
           "\\d\\. ?")
p <- str_match("yes (yes)", "(y)es")
p[,2]
