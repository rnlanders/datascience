# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(GGally)



# Data Import and Cleaning
week7_tbl <- read_csv("../data/week3.csv") %>%
  mutate(timeStart = ymd_hms(timeStart),
         condition = factor(condition, 
                            levels=c("A","B","C"),
                            labels=c("Block A", "Block B", "Control")),
         gender = factor(gender,
                         levels=c("M","F"),
                         labels=c("Male","Female")),
         timeSpent = as.numeric(timeEnd - timeStart)) %>%
  filter(q6 == 1) %>%
  select(-q6)

# Visualization
select(week7_tbl, q1:q10) %>%
  ggpairs

(week7_tbl %>%
    ggplot(aes(x=timeStart, y=q1)) +
    geom_point() +
    xlab("Date of Experiment") +
    ylab("Q1 Score")) %>%
  ggsave("../figs/fig1.png", ., width=1920, height=1080, units="px")
(week7_tbl %>%
    ggplot(aes(x=q1,y=q2,color=gender)) +
    geom_jitter() +
    scale_color_discrete("Participant Gender")) %>%
  ggsave("../figs/fig2.png", ., width=1920, height=1080, units="px")
(week7_tbl %>%
    ggplot(aes(x=q1,y=q2)) +
    geom_jitter() +
    scale_x_continuous("Score on Q1") +
    ylab("Score on Q2") +
    facet_wrap(. ~ gender)) %>%
  ggsave("../figs/fig3.png", ., width=1920, height=1080, units="px")
(week7_tbl %>%
    ggplot(aes(x=gender, y=timeSpent)) +
    geom_boxplot() +
    xlab("Gender") +
    ylab("Time Elapsed (mins)")) %>%
  ggsave("../figs/fig4.png", ., width=1920, height=1080, units="px")
(week7_tbl %>%
    ggplot(aes(x=q5, y=q7, color=condition)) +
    geom_jitter(width = .1) +
    geom_smooth(method="lm", se=F) +
    labs(x = "Score on Q5",
         y = "Score on Q7",
         color = "Experimental Condition") +
    theme(
      legend.position = "bottom",
      legend.background = element_rect(fill="#E0E0E0")
    )) %>%
  ggsave("../figs/fig5.png", ., width=1920, height=1080, units="px")

# grey(1-.125)
