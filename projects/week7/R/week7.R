# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(GGally)



# Data Import and Cleaning
week7_tbl <- read_csv("../data/week3.csv") %>%
  mutate(
    timeStart = ymd_hms(timeStart),
    condition = factor(condition, levels = c("A","B","C"), labels = c("Block A", "Block B", "Control")),
    gender = factor(gender, levels = c("M","F"), labels = c("Male","Female")),
    timeSpent = timeEnd - timeStart
  ) %>%
  filter(q6 == 1) %>%
  select(-q6)



# Visualization
(select(week7_tbl, contains("q")) %>%
  ggpairs(lower = list(continuous = wrap("points", position = "jitter")))) %>%
  ggsave("../figs/ggpairs.png", ., width = 8, height = 6)
(ggplot(week7_tbl, aes(x = timeStart, y = q1)) +
  geom_point() +
  scale_x_datetime("Date of Experiment") +
  scale_y_continuous("Q1 Score")) %>%
  ggsave("../figs/fig1.png", ., width = 1920, height = 1080, units = "px")

(ggplot(week7_tbl, aes(x=q1, y=q2, color=gender)) +
  geom_jitter(width = .4, height = .4) +
    scale_color_discrete("Participant Gender")) %>%
  ggsave("../figs/fig2.png", ., width = 1920, height = 1080, units = "px")

(ggplot(week7_tbl, aes(x=q1, y=q2)) +
  geom_jitter(width = .4, height = .4) +
  facet_grid(. ~ gender) +
  scale_x_continuous("Score on Q1") +
    scale_y_continuous("Score on Q2")) %>%
  ggsave("../figs/fig3.png", ., width = 1920, height = 1080, units = "px")

(week7_tbl %>%
  ggplot(aes(x = gender, y = timeSpent)) +
  geom_boxplot() +
  scale_x_discrete("Gender") +
  scale_y_continuous("Time Elapsed (mins)")) %>%
  ggsave("../figs/fig4.png", ., width = 1920, height = 1080, units = "px")
(ggplot(week7_tbl, aes(x=q5, y=q7, color=condition)) +
  geom_jitter(width = .1) +
  geom_smooth(method="lm", se = F) +
  scale_x_continuous("Score on Q5") +
  scale_y_continuous("Score on Q7") +
  scale_color_discrete("Experimental Condition") +
  theme(
    legend.position = "bottom",
    legend.background = element_rect(fill="#E0E0E0")
  )) %>%
  ggsave("../figs/fig5.png", ., width = 1920, height = 1080, units = "px")



# Fig 3 alternatives
  # facet_grid(cols = vars(gender))
  # facet_wrap(~ gender)

# Fig 2 alternatives
  # labs(color = "Participant Gender")

# Fig 1 alternatives    
  # labs(x="Date of Experiment", y="Q1 Score")
  # xlab("Date of Experiment") +
  # ylab("Q1 Score")







