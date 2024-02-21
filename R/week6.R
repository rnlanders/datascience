x <- ('someone said, "hi"\r\na new line!')
x
writeLines(x)

library(stringi)
library(tidyverse)
tibble(stri_enc_list()) %>% View

str_detect(c("ahayessure","sure"), "yes")
str_extract(c("ahayessure","sure"), "yes")
str_match(c("ahayessure","sure"), "yes")

text <- 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum + Why do we use it?'

str_extract(text, "\\d{4}")
str_match(text, "(\\d{2})\\d{2}")
str_match(text, "(\\d{2})\\d{2}")[,2]

str_detect("This is a sentence.",".")
