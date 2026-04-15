library(tidyverse)
library(tm)
library(qdap)
library(textstem)
library(tidytext)
library(RWeka)
library(parallel)
library(doParallel)
library(tictoc)
library(stm)

# Data comes from a political science project, also included in stm library
blogs <- read_csv("https://raw.githubusercontent.com/dondealban/learning-stm/master/data/poliblogs2008.csv")
blogs <- blogs[1:100,]

# Create corpus
corpus <- VCorpus(VectorSource(blogs$documents))

# Preprocessing using tm and qdap
corpus_prep <- corpus %>%
  tm_map(content_transformer(replace_abbreviation)) %>%
  tm_map(content_transformer(replace_contraction)) %>%
  tm_map(content_transformer(str_to_lower)) %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(lemmatize_words) %>%
  tm_map(removeWords, stopwords("en")) %>%
  tm_map(stripWhitespace)
  # tm_map(stemDocument, language="english")

# Conversion into a DTM
DTM <- DocumentTermMatrix(corpus_prep)
DTM %>% as.matrix %>% as_tibble %>% View

# Sparsity trimming
slimmed_dtm <- removeSparseTerms(DTM, .97)

# Alternative approach with ngram tokenization
myTokenizer <- function(x) { NGramTokenizer(x, Weka_control(min=1, max=2)) }
DTM <- DocumentTermMatrix(
  corpus_prep, 
  control = list(tokenize = myTokenizer))
slimmed_dtm <- removeSparseTerms(DTM, .97)
DTM_tbl <- slimmed_dtm %>% as.matrix %>% as_tibble

# Word cloud!
wordCounts <- colSums(DTM_tbl)
wordNames <- names(DTM_tbl)
wordcloud::wordcloud(wordNames, wordCounts, max.words = 50)

# One example of per-word sentiment scores; 
# could be joined with a data set and used descriptively or in ML
get_sentiments(lexicon = "afinn")

# Topic analysis 
dfm2stm <- readCorpus(slimmed_dtm, type="slam")
kresult <- searchK(
  dfm2stm$documents,
  dfm2stm$vocab,
  K = seq(2, 20, by = 2)
)
plot(kresult)
topic_model <- stm(dfm2stm$documents, 
                   dfm2stm$vocab, 
                   7)

# Interpretation of topic analysis
labelTopics(topic_model, n=10)
findThoughts(topic_model, texts=blogs$documents, n=3)
plot(topic_model, type="summary", n=5)
topicCorr(topic_model)
plot(topicCorr(topic_model))
