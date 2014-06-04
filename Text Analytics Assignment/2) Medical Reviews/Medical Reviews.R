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

trials = read.csv("clinical_trial.csv", stringsAsFactors=FALSE)
summary(trials)
str(trials)
which.max(nchar(trials$abstract))
nchar(trials$abstract[which.max(nchar(trials$abstract))])
nrow(subset(trials, nchar(abstract) ==0))
trials$title[which.min(nchar(trials$title))]

corpusTitle = Corpus(VectorSource(trials$title))
corpusAbstract = Corpus(VectorSource(trials$abstract))

corpusTitle <- tm_map(corpusTitle, tolower)
corpusAbstract <- tm_map(corpusAbstract, tolower)

corpusTitle <- tm_map(corpusTitle, removePunctuation)
corpusAbstract <- tm_map(corpusAbstract, removePunctuation)

corpusTitle <- tm_map(corpusTitle, removeWords, stopwords("english"))
corpusAbstract <- tm_map(corpusAbstract, removeWords, stopwords("english"))

corpusTitle <- tm_map(corpusTitle, stemDocument)
corpusAbstract <- tm_map(corpusAbstract, stemDocument)

dtmTitle = DocumentTermMatrix(corpusTitle)
dtmAbstract = DocumentTermMatrix(corpusAbstract)

dtmTitle = removeSparseTerms(dtmTitle, 0.95)
dtmTitle
dtmAbstract = removeSparseTerms(dtmAbstract, 0.95)
dtmAbstract

titles = as.data.frame(as.matrix(dtmTitle))
abstracts = as.data.frame(as.matrix(dtmAbstract))

colnames(abstracts[which.max(colSums(abstracts))])


colnames(titles) = paste0("T", colnames(titles))
colnames(abstracts) = paste0("A", colnames(abstracts))

dtm = cbind(titles, abstracts)
dtm$trial = trials$trial
str(dtm)

set.seed(144)

spl = sample.split(dtm$trial, 0.7)

dtmtrain = subset(dtm, spl == TRUE)
dtmtest = subset(dtm, spl == FALSE)

base_accur = table(dtmtrain$trial)
base_accur[1]/sum(base_accur)

trialCART = rpart(trial~., data=dtmtrain, method="class")
prp(trialCART)
predCART = predict(trialCART, newdata=dtmtrain)
max(predCART[,2])
calc_accur(dtmtrain$trial, predCART[,2] >= 0.5)
calc_sensit(dtmtrain$trial, predCART[,2] >= 0.5)
calc_spec(dtmtrain$trial, predCART[,2] >= 0.5)

predCART2 = predict(trialCART, newdata=dtmtest)
calc_accur(dtmtest$trial, predCART2[,2] >= 0.5)

predROCR = prediction(predCART2[,2], dtmtest$trial)
performance(predROCR, "auc")@y.values

