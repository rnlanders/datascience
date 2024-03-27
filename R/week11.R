library(tidyverse)
library(caret)
library(psych)
library(parallel)
library(doParallel)
library(tictoc)

data(bfi)
bfi_tbl <- bfi %>%
  select(A1:O5,age)

local_cluster <- makeCluster(detectCores() - 1)
registerDoParallel(local_cluster)

tic()
bfi_model <- train(
  age ~ .,
  bfi_tbl,
  method="xgbLinear",
  tuneLength=3,
  preProcess = "medianImpute",
  na.action = na.pass
)
bfi_toc <- toc()
stopCluster(local_cluster)
registerDoSEQ()
