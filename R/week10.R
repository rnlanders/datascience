library(tidyverse)
library(caret)
library(psych)

data(bfi)
bfi_tbl <- bfi %>%
  select(-gender, -education)

glmnetmodel <- train(
  age ~ .,
  bfi_tbl,
  method="glmnet",
  preProcess=c("center","scale","medianImpute"),
  na.action = na.pass,
  tuneLength = 3,
  trControl = trainControl(method="cv", 
                           number=10, 
                           verboseIter=T,
                           # indexOut=fold_indices
                           )
)
glmnetmodel

glmnetmodel2 <- train(
  age ~ .,
  bfi_tbl,
  method="glmnet",
  preProcess=c("center","scale","medianImpute"),
  na.action = na.pass,
  tuneLength = 3,
  trControl = trainControl(method="cv", 
                           number=10, 
                           verboseIter=T,
                           # indexOut=fold_indices
  )
)
glmnetmodel2

summary(resamples(list(glmnetmodel, glmnetmodel2)))
dotplot(resamples(list(glmnetmodel, glmnetmodel2)))
