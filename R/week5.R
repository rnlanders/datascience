library(tidyverse)
library(magrittr)
library(psych)
data(bfi)

bfi %>%
  select(A1:A5) %>%
  mutate(A5 = 6-A5) %>%
  # mutate(A5 = 8-A5) %>%
  ggplot(aes(x=A1, y=A3)) + geom_jitter()

# select(bfi, A1:A5)

select(bfi, A1:A5) %>%
  mutate(A5rev = 6-A5) %>%
  ggplot(aes(x=A1, y=A3)) + geom_jitter()

bfi_tbl <- select(bfi, A1:A5)
bfi_mutated_tbl <- mutate(bfi_tbl, A5 = 6-A5)  
ggplot(bfi_mutated_tbl, aes(x=A1, y=A3)) + geom_jitter()


as_tibble(bfi) %>%
  mutate(A1, 
         A5rev = 6-A5, 
         Aspecial = 10-A5rev,
         .keep = "none"
  )

as_tibble(bfi) %>%
  group_by(gender) %>%
  summarize(meanA1 = mean(A1, na.rm=T), n())

as_character_func <- function(x) {
  as.character(x)
}

bfi_working <- as_tibble(bfi) %>%
  mutate(
    across(contains("A"), function(x) as.character(x)),
    across(contains("E"), function(x) as.character(x)),
    C5rev = 6-C5
  )
bfi_working <- as_tibble(bfi) %>%
  mutate(across(contains("A"), ~as.character(.)))
bfi_working <- as_tibble(bfi) %>%
  mutate(across(contains("A"), \(x) as.character(x)))
bfi_working <- as_tibble(bfi) %>%
  mutate(across(contains("A"), \(x) as_character_func(x)))

bfi %>%
  rowwise() %>%
  mutate(A = mean(c(A1,A2,A3,A4,A5), na.rm=T)) %>%
  select(A1:A5, A) %>%
  View

uhoh <- function(x) { return(q) }
uhoh()

