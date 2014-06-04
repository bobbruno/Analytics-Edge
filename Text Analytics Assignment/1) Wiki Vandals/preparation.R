getwd()
setwd("C:\\Users\\Roberto\\Dropbox\\Coursera\\Analytics Edge\\05.2) Twitter Intro to Text Analytics")
dir()
tweets = read.csv("tweets.csv", stringsAsFactors=FALSE)
tweets
str(tweets)
tweets$negative = as.factor(Tweets$Avg <= -1)
tweets$negative = as.factor(tweets$Avg <= -1)
table(tweets$Negative)
str(tweets)
tweets(1:5)
tweets[1:5]
tweets[,1:5]
tweets[1]
tweets[2]
tweets[3]
colnames(tweets)[3]
colnames(tweets)[3] = "Negative"
colnames(tweets)[3]
str(tweets)
table(tweets$Negative)
install.packages("tm")
library(tm)
install.packages("SnowballC")
library(SnowballC)
corpus = Corpus(VectorSource(tweets$Tweet))
corpus
corpus[[1]]
corpus = tm_map(corpus, tolower)
corpus[[1]]
# Remove punctuation
corpus = tm_map(corpus, removePunctuation)
corpus[[1]]
# Look at stop words 
stopwords("english")[1:10]
stopwords("portuguese")[1:10]
str(stopwords("portuguese"))
corpus = tm_map(corpus, removeWords, c("apple", stopwords("english")))
corpus[[1]]
corpus = tm_map(corpus, stemDocument)
corpus[[1]]
frequencies = DocumentTermMatrix(corpus)
frequencies
inspect(frequencies[1000:1005,505:515])
findFreqTerms(frequencies, lowfreq=20)
findFreqTerms(frequencies, lowfreq=20)
sparse = removeSparseTerms(frequencies, 0.995)
sparse
tweetsSparse = as.data.frame(as.matrix(sparse))
colnames(tweetsSparse) = make.names(colnames(tweetsSparse))
tweetsSparse$Negative = tweets$Negative
# Split the data
library(caTools)
set.seed(123)
split = sample.split(tweetsSparse$Negative, SplitRatio = 0.7)
trainSparse = subset(tweetsSparse, split==TRUE)
testSparse = subset(tweetsSparse, split==FALSE)
findFreqTerms(frequencies, lowfreq=100)
library(rpart)
library(rpart.plot)
str(trainSparse)
tweetCART = rpart(Negative ~ ., data=trainSparse, method="class")
prp(tweetCART)
predictCART = predict(tweetCART, newdata=testSparse, type="class")
table(testSparse$Negative, predictCART)
# Compute accuracy
(294+18)/(294+6+37+18)
# Baseline accuracy 
table(testSparse$Negative)
300/(300+55)
library(randomForest)
set.seed(123)
tweetRF = randomForest(Negative ~ ., data=trainSparse)
predictRF = predict(tweetRF, newdata=testSparse)
table(testSparse$Negative, predictRF)
(293+21)/(293+7+34+21)
tweetLog = glm(Negative ~ ., data=trainSparse, family=binomial)
tweetLog = glm(Negative ~ ., data=trainSparse, family="binomial")
predictions = predict(tweetLog, newdata=testSparse, type="response")
table(testSparse$Negative, predictions >= 0.5)
(253+33)/(253+47+22+33)
str(testSparse)
setwd("C:\\Users\Roberto\\Dropbox\\Coursera\\Analytics Edge\\05.4) Text Analytics in the Courtroom")
setwd("C:\\Users\\Roberto\\Dropbox\\Coursera\\Analytics Edge\\05.4) Text Analytics in the Courtroom")
emails = read.csv("energy_bids.csv", stringsAsFactors=FALSE)
str(emails)
emails$email[1]
strwrap(emails$email[1])
emails$responsive[1]
strwrap(emails$email[2])
emails$responsive[2]
table(emails$responsive)
139/(139+716)
library(tm)
corpus = Corpus(VectorSource(emails$email))
corpus[[1]]
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stemDocument)
# Look at first email
corpus[[1]]
dtm = DocumentTermMatrix(corpus)
dtm
# Remove sparse terms
dtm = removeSparseTerms(dtm, 0.97)
dtm
labeledTerms = as.data.frame(as.matrix(dtm))
# Add in the outcome variable
labeledTerms$responsive = emails$responsive
str(labeledTerms)
library(caTools)
set.seed(144)
spl = sample.split(labeledTerms$responsive, 0.7)
train = subset(labeledTerms, spl == TRUE)
test = subset(labeledTerms, spl == FALSE)
# Build a CART model
library(rpart)
library(rpart.plot)
emailCART = rpart(responsive~., data=train, method="class")
prp(emailCART)
pred = predict(emailCART, newdata=test)
pred[1:10,]
pred.prob = pred[,2]
table(test$responsive, pred.prob >= 0.5)
(195+25)/(195+25+17+20)
table(test$responsive)
215/(215+42)
library(ROCR)
predROCR = prediction(pred.prob, test$responsive)
str(predROCR)
perfROCR = performance(predROCR, "tpr", "fpr")
plot(perfROCR, colorize=TRUE)
performance(predROCR, "auc")@y.values
ls()
rm(c(ls())
)
rm(ls())
?rm
c(ls())
rm(list = ls())
ls()
c(0:10)
c(0:10) - c(3:5)
intersect(c(0:10), c(3:5))
setdiff(c(0:10), c(3:5))
dir
dir()
setwd("..\\05.5) Assignment")
dir()
wiki = read.csv("wiki.csv", stringAsFactors=FALSE)
wiki = read.csv("wiki.csv", stringsAsFactors=FALSE)
str(wiki)
table(wiki$Vandal)
corpusAdded = Corpus(VectorSource(wiki$Added))
corpusAdded = tm_map(corpusAdded, removeWords, stopwords("english))
corpusAdded = tm_map(corpusAdded, removeWords, stopwords("english"))
corpusAdded = tm_map(corpusAdded, stemDocument)
dtmAdded = DocumentTermMatrix(corpusAdded)
length(stopwords("english"))
str(dtmAdded)
length(dtmAdded)
dtmAdded
sparseAdded = removeSparseTerms(dtmAdded, 0.997)
sparseAdded
wordsAdded = as.data.frame(as.matrix(sparseAdded))
colnames(wordsAdded) = paste("A", colnames(wordsAdded))
paste("A", "B")
wordsAdded
