setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(psych)
data(bfi)
bfi_tbl <- tibble(bfi)

fig1 <- bfi_tbl %>%
  summarize(A1mean = mean(A1, na.rm=T), 
            A2mean = mean(A2, na.rm=T),
            A3mean = mean(A3, na.rm=T)) %>%
  pivot_longer(A1mean:A3mean) %>%
  ggplot(aes(x=factor(name), y=value))
fig1 + 
  geom_point(size=3, color="blue") + 
  geom_point(color="chocolate4") 

bfi_tbl %>%
  rowwise() %>%
  mutate(A = mean(c(A1, A2, A3, A4, A5), na.rm=T)) %>%
  select(A, age) %>%
  ggplot(aes(x=age)) +
  geom_histogram()

(bfi_tbl %>%
  rowwise() %>%
  mutate(A = mean(c(A1, A2, A3, A4, A5), na.rm=T)) %>%
  select(A, age, gender) %>%
  ggplot(aes(x=A, y=age)) +
  # geom_point() +
  geom_jitter(color="blue", width=.08, height=.08) +
  scale_x_continuous("Agreeableness",
                     breaks=1:6) +
  geom_smooth(method="lm") +
  facet_grid(gender ~ .) +
  theme(
    axis.text.x = element_text(color="orange")
  )) %>%
  ggsave("../figs/fig2.png", ., dpi=600, height=4, width=3)

library(GGally)
bfi_tbl %>% 
  select(A1:A5) %>% 
  ggpairs
