library(tidyverse)
library(caret)
library(psych)
library(parallel)
library(doParallel)
library(tictoc)
library(microbenchmark)
data(bfi)
bfi_tbl <- bfi %>%
  select(-gender, -education)

local_cluster <- makeCluster(7)
registerDoParallel(local_cluster)
tic()
model2 <- train(
  age ~ .,
  bfi_tbl,
  na.action=na.omit,
  preProcess="nzv",
  method="ranger",
  trControl=trainControl(
    method="cv", number=5, verboseIter=T
  )
)
toc()
stopCluster(local_cluster)
registerDoSEQ()

microbenchmark(data(bfi))

