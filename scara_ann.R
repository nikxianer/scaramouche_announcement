library(rtweet)
#data collection
twitter_token <- create_token(
  app = appname,
  consumer_key <- "",
  consumer_secret <- "",
  access_token <- "",
  access_secret <- ""
)

library(tidyverse)
sc_hash <- search_tweets("#scaramouche", n = 10000,
                         include_rts = FALSE)

#data formatting
sc_hashd <- as.data.frame(sc_hash)
sc_hashd$entities <- as.character(sc_hashd$entities)
sc_hashd <- sc_hashd %>% select(1:4,6:7,19:27)
sc_hashd$full_text <- as.character(sc_hashd$full_text)
sc_hashd$full_text <- iconv(sc_hashd$full_text, "latin1", "ASCII", sub="")

write.csv(sc_hashd, "~sc_hashd.csv", fileEncoding = "UTF-8")
sc_hashd <- read.csv("~sc_hashd.csv", encoding = "UTF-8")

# text cleaning
sc_hashd$full_text <- gsub("\\$", "", sc_hashd$full_text) 
sc_hashd$full_text <- gsub("@\\w+", "", sc_hashd$full_text)

sc_hashd$full_text <- gsub("http\\w+", "", sc_hashd$full_text)
sc_hashd$full_text <- gsub("[ |\t]{2,}", "",sc_hashd$full_text)
sc_hashd$full_text <- gsub("^ ", "", sc_hashd$full_text)
sc_hashd$full_text <- gsub(" $", "", sc_hashd$full_text)
sc_hashd$full_text <- gsub("RT","",sc_hashd$full_text)
sc_hashd$full_text <- gsub("href", "", sc_hashd$full_text)

sc_hashd$full_text <- gsub("[^#[:^punct:]]", "", sc_hashd$full_text, perl=T)
sc_hashd$full_text  <- str_squish(sc_hashd$full_text)
sc_hashd$full_text <- gsub("([0-9])","", sc_hashd$full_text)

library(ggplot2)

# Number of tweets in world languages
unique(sc_hashd$lang)

sc_hashd %>% 
  group_by(lang)  %>%
  summarise(count=n()) %>%
  filter(count > 100 & lang != "und" & lang != "en") %>%
  ggplot() + geom_bar(aes(reorder(lang,-count),count),stat = "identity",fill="#1b90d5") + 
  theme_minimal() + labs(
    title = 'Number of tweets in world languages',
    subtitle = "People tweeted about Scaramouche in 39 languages. 
The most popular language to communicate is English (50% of tweets).
Other languages used in tweets are the following.",
    x = '',
    y = '') + theme(
      plot.title = element_text(size = 15, color = "#035383", face = "bold"),
      plot.subtitle = element_text(size = 9,color = "#465c6a", face = "bold"),
      axis.text.x = element_text(size = 9,color = "#465c6a", face = "bold"),
      axis.text.y = element_text(size = 9, color = "#465c6a",face = "bold"))
