# R script for Visual Text Analytics and Social Science 2016 Hackathon Challenge, ICL-LSE 

library(quanteda)
library(plotly)
library(ggplot2)
library(dplyr)

# load(url("http://www.kenbenoit.net/files/presDebateCorpus2016seg.RData"))
# summary(presDebateCorpus2016seg)
# 
# txts <- texts(presDebateCorpus2016seg, groups = "party")
# presDebateCorpus2016grouped <- corpus(txts)
# 
# presDfm <- dfm(presDebateCorpus2016grouped)

# wf <- textmodel(presDfm, model = "wordfish")

# save(wf, file = "wf.RData")

load("wf.RData")

eiffel <- data.frame(word = wf@features,
                     beta = wf@beta,
                     psi = wf@psi)

# save(eiffel, file = "eiffel.RData")
load("eiffel.RData")

# Base R plot
plot(eiffel$beta, eiffel$psi, type="n", xlab="Word Weights", ylab="Word Fixed Effects")
text(eiffel$beta, eiffel$psi, eiffel$word, col = "grey")

# Base R identify plot
X11()
plot(eiffel$beta, eiffel$psi, type="p", xlab="Word Weights", ylab="Word Fixed Effects")
identify(eiffel$beta, eiffel$psi, labels=eiffel$word)

# Improved Base R
highlight <- c("factory", "fiscal", "trump", "racism", "sustainable", "sanders",
               "islamic", "texas", "prime-time", "the", "and", "have")
plot(eiffel$beta, eiffel$psi, type="n", xlab="Word Weights", ylab="Word Fixed Effects")
text(eiffel$beta[!(eiffel$word %in% highlight)],
     eiffel$psi[!(eiffel$word %in% highlight)],
     eiffel$word[!(eiffel$word %in% highlight)],
     col = "grey")
text(eiffel$beta[eiffel$word %in% highlight],
     eiffel$psi[eiffel$word %in% highlight],
     eiffel$word[eiffel$word %in% highlight],
     col = "black")

# ggplot
ggplot(filter(eiffel, !(word %in% highlight)), aes(beta, psi)) + 
  geom_text(aes(label = word), colour="grey") + xlab("Word Weights") + 
  ylab("Word Fixed Effects") + theme_bw() +
  geom_text(data=filter(eiffel, word %in% highlight), aes(label = word), colour="black")

# ggplot with alpha
ggplot(filter(eiffel, !(word %in% highlight)), aes(beta, psi)) + 
  geom_text(aes(label = word), colour="grey", alpha=0.7) + xlab("Word Weights") + 
  ylab("Word Fixed Effects") + theme_bw() +
  geom_text(data=filter(eiffel, word %in% highlight), aes(label = word), colour="black")

# plotly
p <- ggplot(eiffel, aes(beta, psi)) + 
      geom_text(aes(label = word), colour="grey", alpha=0.7) + xlab("Word Weights") + 
      ylab("Word Fixed Effects") + theme_bw()

gg <- ggplotly(p)

# plotly API
Sys.setenv("plotly_username" = "")
Sys.setenv("plotly_api_key" = "")

plotly_POST(gg, filename="texthack", sharing="public")
