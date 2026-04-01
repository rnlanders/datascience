library(tidyverse)
library(caret)
library(psych)

data(bfi)

bfi_tbl <- bfi %>%
  select(-education, -age) %>%
  mutate(gender = factor(gender, 
                         levels=1:2, 
                         labels=c("M","F")
  ))

holdout_indices <- createDataPartition(bfi_tbl$gender, p = .2, list=F)
bfi_holdout <- bfi_tbl[holdout_indices,]
bfi_training <- bfi_tbl[-holdout_indices,]

names(getModelInfo())

# bfi_training_pp <- preProcess(bfi_training,
#                               method=c("medianImpute","center","scale"))
# bfi_training_pp_df <- predict(bfi_training_pp, bfi_training)
 
model1 <- train(
  gender ~ .,
  bfi_training,
  # bfi_training_pp_df,
  method = "glmnet",
  na.action = na.pass,
  preProcess=c("medianImpute","center","scale"),
  trControl=trainControl(
    method="cv", number=10, verboseIter=T,
    summaryFunction = twoClassSummary, classProbs=T
  )
)
model1

model2 <- train(
  gender ~ .,
  bfi_training,
  # bfi_training_pp_df,
  method = "ranger",
  na.action = na.pass,
  preProcess=c("medianImpute","center","scale"),
  trControl=trainControl(
    method="cv", number=10, verboseIter=T,
    summaryFunction = twoClassSummary, classProbs=T
  )
)
model2

summary(resamples(list(model1,model2)))
dotplot(resamples(list(model1,model2)))

# bfi_holdout_pp <- preProcess(bfi_holdout,
#                              method=c("medianImpute","center","scale"))
# bfi_holdout_pp_df <- predict(bfi_holdout_pp, bfi_holdout)
# 
# confusionMatrix(
#   predict(model2, bfi_holdout_pp_df), 
#   bfi_holdout_pp_df$gender
# )

confusionMatrix(
  predict(model2, bfi_holdout, na.action=na.pass),
  bfi_holdout$gender
)
