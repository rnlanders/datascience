library(tidyverse)
library(psych)
library(GGally)
data(bfi)
bfi_tbl <- tibble(bfi)

bfi_tbl %>%
  ggplot(
    aes(x=A1)) +
  geom_histogram(
    aes(x=C3)) +
  geom_histogram(
    aes(x=E2), 
    color="blue")

bfi_tbl %>%
  ggplot(aes(x=age)) +
  # geom_histogram(fill="orange", binwidth = .5, width = 1)
  geom_histogram(fill="burlywood", binwidth = .5, width = 1)

bfi_tbl %>%
  ggplot(aes(x=A1, y=age)) +
  geom_point(alpha=.1) +
  theme_minimal()
                 