# Script Settings and Resources
set.seed(394587)
library(tidyverse)
library(haven)
library(caret)

# Data Import and Cleaning
gss_import_tbl <- read_spss("data/GSS2016.sav") %>%
  filter(!is.na(mosthrs))
gss_tbl <- gss_import_tbl %>%
  select(-hrs1, -hrs2) %>%
  select(where(~mean(is.na(.))<.75)) %>%
  mutate(across(everything(), as.numeric))

# Visualization
ggplot(gss_tbl, 
       aes(x = mosthrs)) +
  geom_histogram()

# Analysis
holdout_indices <- createDataPartition(gss_tbl$mosthrs, 
                                       p = .25, 
                                       list=F)
gss_holdout <- gss_tbl[holdout_indices,]
gss_training <- gss_tbl[-holdout_indices,]

model1 <- train(
  mosthrs ~ .,
  gss_training,
  method = "lm",
  na.action = na.pass,
  preProcess=c("medianImpute","center","nzv","scale"),
  trControl=trainControl(
    method="cv", number=10, verboseIter=T
  )
)
model1

hocv_cor_1 <- cor(
  predict(model1, gss_holdout, na.action=na.pass),
  gss_holdout$mosthrs
)^2

model2 <- train(
  mosthrs ~ .,
  gss_training,
  method = "glmnet",
  na.action = na.pass,
  preProcess=c("medianImpute","center","nzv","scale"),
  trControl=trainControl(
    method="cv", number=10, verboseIter=T
  )
)
model2

hocv_cor_2 <- cor(
  predict(model2, gss_holdout, na.action=na.pass),
  gss_holdout$mosthrs
)^2

model3 <- train(
  mosthrs ~ .,
  gss_training,
  method = "ranger",
  na.action = na.pass,
  tuneLength = 1,
  preProcess=c("medianImpute","center","nzv","scale"),
  trControl=trainControl(
    method="cv", number=10, verboseIter=T
  )
)
model3

hocv_cor_3 <- cor(
  predict(model3, gss_holdout, na.action=na.pass),
  gss_holdout$mosthrs
)^2

# model4 <- train(
#   mosthrs ~ .,
#   gss_training,
#   method = "xgbLinear",
#   na.action = na.pass,
#   tuneLength = 1, 
#   preProcess=c("medianImpute","center","nzv","scale"),
#   trControl=trainControl(
#     method="cv", number=10, verboseIter=T
#   )
# )
# model4

summary(resamples(list("lm"=model1, "glmnet"=model2, "ranger"=model3)))
dotplot(resamples(list("lm"=model1, "glmnet"=model2, "ranger"=model3)))

# Publication
table1_tbl <- tibble(
  algo = c("lm", "glmnet", "ranger"),
  cv_rsq = c(
    str_remove(round(max(model1$results$Rsquared),2),"^0"),
    str_remove(round(max(model2$results$Rsquared),2),"^0"),
    str_remove(round(max(model3$results$Rsquared),2),"^0")
  ),
  ho_rsq = c(
    str_remove(round(hocv_cor_1,2),"^0"),
    str_remove(round(hocv_cor_2,2),"^0"),
    str_remove(round(hocv_cor_3,2),"^0")
  )
)


