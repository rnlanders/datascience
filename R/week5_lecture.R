?separate
library(tidyverse)
news()
news(package="dplyr")

library(psych)
data(bfi)
class(bfi)
bfi_tbl <- tibble(bfi)

# bfi_tbl <- select(bfi_tbl, A1)

data(mtcars)
mtcars_tbl <- tibble(mtcars)

mtcars %>%
  select(cyl, hp, disp) %>%
  mutate(hp_per_disp = hp / disp) %>%
  group_by(cyl) %>%
  summarize(avg_hp_per_disp = mean(hp_per_disp))
  
data(starwars)
starwars_tbl <- tibble(starwars) 

starwars_tbl %>%
  group_by(species) %>%
  summarize(height = mean(height), 
            weight = mean(mass),
            cases = n()) %>%
  arrange(desc(weight))

starwars_tbl %>%
  mutate(across(c(height, mass), \(x) as.integer(x)))
starwars_tbl %>%
  mutate(across(c(height, mass), ~ as.integer(.)))
starwars_tbl %>%
  mutate(across(c(height, mass), function(x) as.integer(x)))

bfi_tbl %>%
  mutate(A = mean(A1,A2,A3,A4,A5))
bfi_tbl %>%
  mutate(A = mean(c(A1,A2,A3,A4,A5))) %>%
  pull(A)
bfi_tbl %>%
  mutate(A = mean(c(A1,A2,A3,A4,A5), na.rm=T)) %>%
  pull(A)
bfi_tbl %>%
  rowwise() %>%
  mutate(A = mean(c(A1,A2,A3,A4,A5), na.rm=T)) %>%
  ungroup()
bfi_tbl %>%
  mutate(
    A1 = A1 + 1,
    A = rowMeans(across(contains("A")), na.rm=T)
  )

mutate(starwars_tbl, across(c(height, mass), \(x) as.integer(x)))

bfi_tbl %>% 
  View
c(1,NA,3) %>% 
  mean(na.rm=T)

  