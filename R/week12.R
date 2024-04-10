library(tidyverse)

sentences <- c(
  "Dr. Smith's new clinic, located at 123 5th Avenue, opens at 8 a.m. sharp on Monday, offering cutting-edge medical services.",
  "I can't believe it's already been 2 years since we visited Tokyo, Japan, experiencing its vibrant culture and delicious cuisine.",
  "At the 2024 TechCon in San Francisco, he's going to present his groundbreaking findings on AI and machine learning advancements.",
  "Jenny's recipe for mac 'n' cheese, featuring three types of cheese and a crispy topping, is a hit at family gatherings and potlucks.",
  "NASA's Mars rover, Perseverance, successfully landed on the Martian surface in February 2021, marking a major milestone in space exploration.",
  "According to the latest weather app update, there's a 40% chance of rain tomorrow, potentially affecting the outdoor sports event.",
  "This November, it's New York's turn to host the annual Thanksgiving parade, featuring giant balloons, floats, and performances.",
  "During the quarterly meeting at 3:30 p.m., the CEO will discuss the company's Q2 earnings and future growth strategies.",
  "She's read J.K. Rowling's 'Harry Potter' series at least five times, each time discovering new details and themes in the magical world.",
  "Mark's been training for months and is going to run his first marathon in Chicago next spring, aiming to finish in under 4 hours.",
  "Can't you see it's the dog's favorite toy, not yours? He's been looking for it all afternoon, wagging his tail in anticipation.",
  "We'll meet at Joe's Cafe, known for its artisan coffee and homemade pastries, around 6 p.m. before heading to the movie theater.",
  "The T-Rex's skull, displayed prominently at the museum, is over 65 million years old and provides insight into the life of dinosaurs.",
  "By fixing his car himself, including the engine and transmission, he's saved over $1,000 compared to getting it repaired at a garage.",
  "Isn't it amazing how quickly technology evolves? Just a decade ago, smartphones were a novelty, and now they're ubiquitous.",
  "We've been planning this trip to Italy for over 12 months, researching the best places to visit, from Rome's ancient ruins to Venice's canals.",
  "I'll need those TPS reports by 5 p.m. today, please. Make sure all the data is accurate and the analysis is thorough.",
  "She's always been fascinated by the 1920's fashion trends, from flapper dresses to ornate headbands, reflecting the era's spirit of freedom.",
  "There's no way I'm missing Beyoncé's concert in July at the downtown stadium; her performances are always spectacular and unforgettable.",
  "Jack's BBQ party, featuring his famous smoked ribs and homemade barbecue sauce, starts at 4 p.m., but I'll be there a bit late.",
  "Tomorrow's community cleanup starts at the beach park at 9 a.m.; it's a great opportunity to contribute and enjoy the outdoors.",
  "The ancient library, home to thousands of rare manuscripts, opens its secret archives to researchers seeking to uncover history's mysteries.",
  "At sunrise, the mountain's peak is illuminated by a golden light, offering a breathtaking view that attracts photographers and nature lovers.",
  "The bakery, celebrating its 50th anniversary, is known for its sourdough bread, baked fresh daily using a family recipe passed down generations.",
  "The film festival's highlight is a documentary exploring the depths of the ocean, revealing unseen creatures and underwater ecosystems.",
  "The local farmers' market, open every Saturday, features organic produce, homemade jams, and artisan crafts from the surrounding area.",
  "The vintage car show, featuring models from the 1950s to the 1970s, is a journey through automotive history and design evolution.",
  "The jazz band's live performance at the downtown cafe adds a vibrant soundtrack to the city night, drawing in music enthusiasts.",
  "The annual science fair encourages students to present their projects, from volcano models to experiments in renewable energy sources.",
  "Her novel, set in the early 1900s, weaves a tale of mystery and romance, capturing the reader's imagination from the first page.",
  "The art exhibit, featuring works from local artists, explores themes of identity and community through various mediums and styles.",
  "The cooking class, focusing on Italian cuisine, teaches participants how to make authentic pasta from scratch and classic sauces.",
  "His blog on sustainable living offers practical tips for reducing waste, conserving energy, and supporting local ecosystems.",
  "The charity run, organized to raise funds for the local hospital, brings together community members of all ages for a good cause.",
  "The old lighthouse, restored to its former glory, stands as a beacon for sailors and a historical landmark for visitors.",
  "Her photography captures the essence of urban life, from bustling streets to quiet moments of reflection in the city's parks.",
  "The tech startup's innovative app aims to simplify daily tasks through automation, using AI to adapt to user preferences.",
  "The wine tasting event, set in the scenic vineyard, offers a selection of the region's finest wines, accompanied by expert commentary.",
  "His collection of antique clocks, each with its own story and intricate design, fascinates those interested in the art of timekeeping.",
  "The debate club's weekly meetings tackle current issues, fostering critical thinking and public speaking skills among its members."
)


# Create corpus
library(tm)
sample_corpus <- VCorpus(VectorSource(sentences))

# Function to see how preprocessing is going
check_it <- function() {
  casenum <- sample(1:20, 1)
  print(sample_corpus[[casenum]]$content)
  print(preprocessed_corpus[[casenum]]$content)
}

# Preprocessing pipeline
library(qdap)
preprocessed_corpus <- sample_corpus %>%
  tm_map(content_transformer(replace_abbreviation)) %>%
  tm_map(content_transformer(replace_contraction)) %>%
  tm_map(content_transformer(str_to_lower)) %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeWords, stopwords("en")) %>%
  tm_map(stripWhitespace) %>%
  tm_map(stemDocument, language="english")

check_it()

# Lemmatization example
library(textstem)
stem_strings("became become")
lemmatize_strings("became become")
stem_strings("am is are was were be being been")
lemmatize_strings("am is are was were be being been")

# Conversion to unigram DTM
DTM <- DocumentTermMatrix(preprocessed_corpus)
DTM %>% as.matrix %>% as_tibble %>% View
 
# Conversion to n-gram DTM
library(RWeka)

trigram_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min=1, max=3))

DTM <- DocumentTermMatrix(preprocessed_corpus,
                          control = list(tokenize = trigram_tokenizer)
)
DTM %>% as.matrix %>% as_tibble %>% View

# Remove sparse terms (if needed, e.g., for ML)
slim_DTM <- removeSparseTerms(DTM, .95)  # test many sparsity terms
DTM$ncol
slim_DTM$ncol

# Make a pretty word cloud
library(wordcloud)
DTM_tbl <- DTM %>% as.matrix %>% as_tibble
wordcloud(
  words = names(DTM_tbl),
  freq = colSums(DTM_tbl),
  colors = brewer.pal(9,"Blues")
)

# Or a bar graph
tibble(wordNames = names(DTM_tbl), 
       wordCounts = colSums(DTM_tbl)) %>%
  arrange(desc(wordCounts)) %>%
  top_n(10) %>%
  mutate(wordNames = reorder(wordNames, wordCounts)) %>%
  ggplot(aes(x=wordNames,y=wordCounts)) + geom_col() + coord_flip()

# Check out sentiment libraries
library(tidytext)
get_sentiments()

# Topic modeling - determine number of topics to extract
library(ldatuning)
DTM_tune <- FindTopicsNumber(
  DTM,
  topics = seq(2,10,1),
  metrics = c(
    "Griffiths2004",
    "CaoJuan2009",
    "Arun2010",
    "Deveaud2014"),
  verbose = T
)
FindTopicsNumber_plot(DTM_tune)

# Topic modeling - actual modeling
library(topicmodels)
library(tidytext)
lda_results <- LDA(DTM, 4)
tidy(lda_results, matrix="beta") %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  arrange(topic, -beta) %>%
  View
tidy(lda_results, matrix="gamma") %>%
  View