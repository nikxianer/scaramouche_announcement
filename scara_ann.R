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
#sc_hashd$full_text <- gsub("([0-9])","", sc_hashd$full_text)
sc_hashd$full_text <- gsub("[^#[:^punct:]]", "", sc_hashd$full_text, perl=T)
sc_hashd$full_text  <- str_squish(sc_hashd$full_text)