# Script Settings and Resources
set.seed(394587)
library(readr)
library(dplyr)
library(stringr)
library(haven)
library(caret)
library(tictoc)
library(parallel)
library(doParallel)

# Data Import and Cleaning
gss_import_tbl <- read_spss("../data/GSS2016.sav") %>%
  filter(!is.na(mosthrs))
gss_tbl <- gss_import_tbl %>%
  select(-hrs1, -hrs2) %>%
  select(where(~mean(is.na(.))<.75)) %>%
  mutate(across(everything(), as.numeric))

# Analysis
holdout_indices <- createDataPartition(gss_tbl$mosthrs, 
                                       p = .25, 
                                       list=F)
gss_holdout <- gss_tbl[holdout_indices,]
gss_training <- gss_tbl[-holdout_indices,]

tic()
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
model1_toc <- toc()
model1_orig_time <- model1_toc$toc - model1_toc$tic

hocv_cor_1 <- cor(
  predict(model1, gss_holdout, na.action=na.pass),
  gss_holdout$mosthrs
)^2

tic()
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
model2_toc <- toc()
model2_orig_time <- model2_toc$toc - model2_toc$tic

hocv_cor_2 <- cor(
  predict(model2, gss_holdout, na.action=na.pass),
  gss_holdout$mosthrs
)^2

tic()
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
model3_toc <- toc()
model3_orig_time <- model3_toc$toc - model3_toc$tic

hocv_cor_3 <- cor(
  predict(model3, gss_holdout, na.action=na.pass),
  gss_holdout$mosthrs
)^2

summary(resamples(list("lm"=model1, "glmnet"=model2, "ranger"=model3)))
dotplot(resamples(list("lm"=model1, "glmnet"=model2, "ranger"=model3)))

local_cluster <- makeCluster(detectCores()-1)
registerDoParallel(local_cluster)

tic()
model1_p <- train(
  mosthrs ~ .,
  gss_training,
  method = "lm",
  na.action = na.pass,
  preProcess=c("medianImpute","center","nzv","scale"),
  trControl=trainControl(
    method="cv", number=10, verboseIter=T
  )
)
model1_p
model1_p_toc <- toc()
model1_p_time <- model1_p_toc$toc - model1_p_toc$tic

tic()
model2_p <- train(
  mosthrs ~ .,
  gss_training,
  method = "glmnet",
  na.action = na.pass,
  preProcess=c("medianImpute","center","nzv","scale"),
  trControl=trainControl(
    method="cv", number=10, verboseIter=T
  )
)
model2_p
model2_p_toc <- toc()
model2_p_time <- model2_p_toc$toc - model2_p_toc$tic

tic()
model3_p <- train(
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
model3_p
model3_p_toc <- toc()
model3_p_time <- model3_p_toc$toc - model3_p_toc$tic

stopCluster(local_cluster)
registerDoSEQ()


# Publication
table3_tbl <- tibble(
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

table4_tbl <- tibble(
  algo = c("lm", "glmnet", "ranger"),
  supercomputer = c(model1_orig_time, model2_orig_time, model3_orig_time),
  supercomputer_127 = c(model1_p_time, model2_p_time, model3_p_time),
)

write_csv(table3_tbl, "../out/table3.csv")
write_csv(table4_tbl, "../out/table4.csv")
