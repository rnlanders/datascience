data(mtcars)
select(mtcars: mpg:disp)

View(mtcars[,c("mpg","cyl")])
mtcars %>%
  select(mpg:cyl) %>%
  View

library(microbenchmark)
library(psych)
library(data.table)
data(bfi)
write_csv(bfi, "bfi.csv")
microbenchmark({ fread("bfi.csv") })

bfi_tbl <- read_csv("bfi.csv")
hist(bfi_tbl$A1)