install.packages("RTextTools")
library(RTextTools)
library(caTools)
library(randomForest)
library(ROCR)
library(rpart)
library(rpart.plot)
library(tm)

calc_accur <- function(real.data, modeled.data) {
    accur_table = table(real.data, modeled.data)
    return(sum(diag(accur_table))/sum(accur_table))
}

calc_sensit <- function(real.data, modeled.data) {
    accur_table = table(real.data, modeled.data)
    return(accur_table[2,2]/sum(accur_table[2,]))
}

calc_spec <- function(real.data, modeled.data) {
    accur_table = table(real.data, modeled.data)
    return(accur_table[1,1]/sum(accur_table[1,]))
}

emails = read.csv("emails.csv", stringsAsFactors=FALSE)
str(emails)
table(emails["spam"])
# or table(emails$spam) or table(emails$s)

max(nchar(emails$text))
which.min(nchar(emails$text))

corpus = Corpus(VectorSource(emails$text))
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stemDocument)
dtm = DocumentTermMatrix(corpus)
dtm
spdtm = removeSparseTerms(dtm, 0.95)
spdtm
emailsSparse = as.data.frame(as.matrix(spdtm))
colnames(emailsSparse) = make.names(colnames(emailsSparse))
which.max(colSums(emailsSparse))
emailsSparse$spam = emails$spam

wordstems=colSums(subset(emailsSparse, spam == 0))
subset(wordstems, wordstems >= 5000)

wordstems2=colSums(subset(emailsSparse, spam == 1))[1:330]
subset(wordstems2, wordstems2 >= 1000)
emailsSparse$spam = as.factor(emailsSparse$spam)

set.seed(123)
spl = sample.split(emailsSparse$spam, 0.7)
train = subset(emailsSparse, spl == TRUE)
test = subset(emailsSparse, spl == FALSE)
spamLog = glm(spam~., data=train, family=binomial)
spamCART = rpart(spam~., data=train, method="class")
set.seed(123)
spamRF = randomForest(spam~., data=train)

predLog = predict(spamLog, type="response")
predCART = predict(spamCART)
predRF = predict(spamRF, type="prob")

sum(predLog > 0.00001)
sum(predLog > 0.99999)
sum(predLog <= 0.99999 & predLog >= 0.00001)

prp(spamCART)
calc_accur(train$spam, predLog >= 0.5)
performance(prediction(predLog, train$spam), "auc")@y.values

calc_accur(train$spam, predCART[,2] >= 0.5)
performance(prediction(predCART[,2], train$spam), "auc")@y.values

calc_accur(train$spam, predRF[,2] >= 0.5)
performance(prediction(predRF[,2], train$spam), "auc")@y.values

predLog2 = predict(spamLog, newdata=test, type="response")
predCART2 = predict(spamCART, newdata=test)
predRF2 = predict(spamRF, newdata=test, type="prob")

calc_accur(test$spam, predLog2 >= 0.5)
performance(prediction(predLog2, test$spam), "auc")@y.values

calc_accur(test$spam, predCART2[,2] >= 0.5)
performance(prediction(predCART2[,2], test$spam), "auc")@y.values

calc_accur(test$spam, predRF2[,2] >= 0.5)
performance(prediction(predRF2[,2], test$spam), "auc")@y.values

wordCount = rowSums(as.matrix(dtm))
hist(wordCount)
hist(log(wordCount))

emailsSparse$logWordCount = log(wordCount)
boxplot(logWordCount~spam, data=emailsSparse)

train2 = subset(emailsSparse, spl == TRUE)
test2 = subset(emailsSparse, spl == FALSE)
spam2CART = rpart(spam~., data=train2, method="class")
set.seed(123)
spam2RF = randomForest(spam~., data=train2)

prp(spam2CART)
pred2CART = predict(spam2CART, newdata=test2)
pred2RF = predict(spam2RF, newdata=test2, type="prob")

calc_accur(test2$spam, pred2CART[,2] >= 0.5)
performance(prediction(pred2CART[,2], test2$spam), "auc")@y.values

calc_accur(test2$spam, pred2RF[,2] >= 0.5)
performance(prediction(pred2RF[,2], test2$spam), "auc")@y.values

dtm2gram = create_matrix(as.character(corpus), ngramLength=2)
dtm2gram

spdtm2gram = removeSparseTerms(dtm2gram, 0.95)
spdtm2gram

emailsSparse2gram = as.data.frame(as.matrix(spdtm2gram))
colnames(emailsSparse2gram) = make.names(colnames(emailsSparse2gram))
emailsCombined = cbind(emailsSparse, emailsSparse2gram)

trainCombined = subset(emailsCombined, spl == TRUE)
testCombined= subset(emailsCombined, spl == FALSE)
spamCARTcombined = rpart(spam~., data=trainCombined, method="class")
set.seed(123)
spamRFcombined = randomForest(spam~., data=trainCombined)

prp(spamCARTcombined, varlen=0)
predCARTcombined = predict(spamCARTcombined, newdata=testCombined)
predRFcombined = predict(spamRFcombined , newdata=testCombined, type="prob")

calc_accur(testCombined$spam, predCARTcombined[,2] >= 0.5)
performance(prediction(predCARTcombined[,2], testCombined$spam), "auc")@y.values

calc_accur(testCombined$spam, predRFcombined[,2] >= 0.5)
performance(prediction(predRFcombined[,2], testCombined$spam), "auc")@y.values

