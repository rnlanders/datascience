# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(RedditExtractoR)
library(tm)
library(qdap)
library(textstem)
library(RWeka)
library(ldatuning)
library(topicmodels)
library(tidytext)
library(wordcloud)
library(caret)

# Data Import and Cleaning
# urls <- find_thread_urls(subreddit="IOPsychology", 
#                          sort_by="new", 
#                          period="year")
# content <- get_thread_content(urls$url)
urls <- readRDS("../out/urls.RDS")
content <- readRDS("../out/content.RDS")
# saveRDS(urls, "../out/urls.RDS")
# saveRDS(content, "../out/content.RDS")

week12_tbl <- tibble(
  title = content$threads$title,
  upvotes = content$threads$upvotes
)

io_corpus_original <- VCorpus(VectorSource(week12_tbl$title))

io_corpus <- io_corpus_original %>%
  tm_map(content_transformer(replace_abbreviation)) %>%
  tm_map(content_transformer(replace_contraction)) %>%
  tm_map(content_transformer(str_to_lower)) %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeWords, stopwords("en")) %>%
  tm_map(stripWhitespace) %>%
  tm_map(content_transformer(lemmatize_strings)) %>%
  tm_map(removeWords, c("riopsychology", "io psychology", "io"))

io_corpus_clean <- io_corpus %>%
  tm_filter(FUN = function(x) { return(nchar(stripWhitespace(x$content)[[1]]) > 0) })

compare_them <- function(corpus1, corpus2) {
  row <- sample(1:length(corpus1), 1)
  writeLines(paste(corpus1[[row]]$content,
                   corpus2[[row]]$content,
                   sep="\n"))
}

twogram <- function(x) NGramTokenizer(x, Weka_control(min=1,max=2))

io_dtm <- DocumentTermMatrix(io_corpus, control=list(tokenizer=twogram))
io_slim_dtm <- removeSparseTerms(io_dtm, .997)
# io_slim_dtm$nrow /io_slim_dtm$ncol
io_clean_dtm <- DocumentTermMatrix(io_corpus_clean, control=list(tokenizer=twogram))

io_dtm_tbl <- as_tibble(as.matrix(io_dtm))
as_tibble(as.matrix(io_slim_dtm)) %>% View

DTM_tune <- FindTopicsNumber(
  io_clean_dtm,
  topics = seq(2,10,1),
  metrics = c(
    "Griffiths2004",
    "CaoJuan2009",
    "Arun2010",
    "Deveaud2014"),
  verbose = T
)
FindTopicsNumber_plot(DTM_tune)

lda_results <- LDA(io_clean_dtm, 4)
tidy(lda_results, matrix="beta") %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  arrange(topic, -beta) %>%
  View
tidy(lda_results, matrix="gamma") %>%
  View

lda_gammas <- tidy(lda_results, matrix="gamma") %>%
  group_by(document) %>%
  top_n(1, gamma) %>%
  ungroup %>%
  mutate(document = as.numeric(document)) %>%
  arrange(document)

week12_merging_tbl <- week12_tbl %>%
  mutate(row = row_number())

topics_tbl <- tibble(
  doc_id = lda_gammas$document,
  topic = lda_gammas$topic,
  probability = lda_gammas$gamma
) %>%
  left_join(week12_merging_tbl, by = join_by(doc_id==row)) %>%
  select(doc_id, original=title, topic, probability)
  
final_tbl <- tibble(
  doc_id = lda_gammas$document,
  topic = factor(lda_gammas$topic),
  probability = lda_gammas$gamma
) %>%
  left_join(week12_merging_tbl, by = join_by(doc_id==row)) %>%
  select(doc_id, original=title, topic, probability, upvotes)

# Visualization
wordcloud(
  words = names(io_dtm_tbl),
  freq = colSums(io_dtm_tbl)
)

# Analysis
model <- lm(upvotes ~ topic, data=final_tbl)
summary(model)

holdout_indices <- createDataPartition(final_tbl$upvotes, p=.2)$Resample1

train_tbl <- final_tbl[-holdout_indices,]
test_tbl <- final_tbl[holdout_indices,]

ml_model <- train(upvotes ~ topic, 
                  data=train_tbl,
                  method="glmnet",
                  na.action = na.omit,
                  preProcess=c("center","scale"),
                  trControl=trainControl(method="cv", number=10, verboseIter=T)
)
ml_model
cv_performance <- max(ml_model$results$Rsquared)
holdout_performance <- cor(
  predict(ml_model, test_tbl),
  test_tbl$upvotes
)^2