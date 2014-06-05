require(e1071)
require(ROCR)
require(caret)

predict.kmeans <- function(km, data) {
    k <- nrow(km$centers)
    n <- nrow(data)
    d <- as.matrix(dist(rbind(km$centers, data)))[-(1:k),1:k]
    out <- apply(d, 1, which.min)
    return(out)
}

createsvmModel <- function(modelFormula, trainSet, testSet = NULL, C=1, sigma=NULL) {
    if (is.null(sigma)) {
        sigma = dim(traindata.imp)[1]
    }
    Model = svm(formula=modelFormula, data = trainSet, cost=C, 
                gamma=1/sigma, probability=TRUE, type="C-classification")
    predict.train=predict(Model, trainSet, decision.values=TRUE, 
                          probability=TRUE)
    rocrPrediction.train = prediction(attributes(predict.train)$probabilities[,2],
                                      trainSet$Happy)
    perf.train = performance(rocrPrediction.train, "tpr", "fpr")
    auc.train = as.numeric(performance(rocrPrediction.train, "auc")@y.values)
    temp = table(trainSet$Happy, attributes(predict.train)$probabilities[,2] > 0.5)
    acc.train = sum(diag(temp))/sum(temp)
    if (!is.null(testSet)) {
        predict.test = predict(Model, newdata=testSet, decision.values=TRUE, 
                               probability=TRUE)
        rocrPrediction.test = prediction(attributes(predict.test)$probabilities[,2],
                                         testSet$Happy)
        perf.test = performance(rocrPrediction.test, "tpr", "fpr")
        auc.test = as.numeric(performance(rocrPrediction.test, "auc")@y.values)
        temp = table(testSet$Happy, attributes(predict.test)$probabilities[,2] > 0.5)
        acc.test = sum(diag(temp))/sum(temp)
    }
    else {
        predict.test = NULL
        perf.test = NULL
        auc.test = NULL
    }
    
    list(model = Model,
         formula = modelFormula,
         predTrain = predict.train,
         perfTrain = perf.train,
         AUCTrain = auc.train,
         accTrain = acc.train,
         predTest = predict.test,
         perfTest = perf.test,
         AUCTest = auc.test,
         accTest = acc.test
    )
}

avaliasvm <- function(C, s) {
    M = createsvmModel(Happy~.-UserID, traindata, nottraindata, C, s)
    aval = c(M$AUCTest, M$accTest, C, s)
    names(aval) = c("AUC", "acc", "C", "s")
    return(aval)
}

require(nnet)
creatennModel <- function(modelFormula, trainSet, testSet = NULL, 
                          nnodes = NULL, Maxit = 100, Trace=FALSE) {
    if (is.null(nnodes)) {
        nnodes = dim(trainSet)[2]
    }
    #nnodes = nnodes * log(nnodes)
    Model = nnet(formula=modelFormula, data = trainSet, 
                 trace = Trace,size = nnodes, maxit=Maxit, MaxNWts = 20000)
    predict.train = predict(Model, newdata=trainSet, type = "raw")
    rocrPrediction.train = prediction(predict.train, trainSet$Happy)
    perf.train = performance(rocrPrediction.train, "tpr", "fpr")
    auc.train = as.numeric(performance(rocrPrediction.train, "auc")@y.values)
    temp = table(trainSet$Happy, predict.train > 0.5)
    acc.train = sum(diag(temp))/sum(temp)
    if (!is.null(testSet)) {
        predict.test = predict(Model, newdata=testSet, type = "raw")
        rocrPrediction.test = prediction(predict.test, testSet$Happy)
        perf.test = performance(rocrPrediction.test, "tpr", "fpr")
        auc.test = as.numeric(performance(rocrPrediction.test, "auc")@y.values)
        temp = table(testSet$Happy, predict.test > 0.5)
        acc.test = sum(diag(temp))/sum(temp)
    }
    else {
        predict.test = NULL
        perf.test = NULL
        auc.test = NULL
    }
    
    list(model = Model,
         formula = modelFormula,
         predTrain = predict.train,
         perfTrain = perf.train,
         AUCTrain = auc.train,
         accTrain = acc.train,
         predTest = predict.test,
         perfTest = perf.test,
         AUCTest = auc.test,
         accTest = acc.test
    )
}

evalnn <- function(Formula, trainSet, testSet, Nodes) {
    myfunc <- function(x) {
        nn = creatennModel(Formula, trainSet[1:(x*27),], testSet, nnodes = Nodes)
        return(c(n=x, Test=nn$AUCTest, Train=nn$AUCTrain))
    }
    
    l = mclapply(seq.int(100), myfunc, mc.cores=6)
    df = data.frame(matrix(unlist(l), ncol=3, byrow=TRUE))
    colnames(df) <- c("n", "JTest", "JTrain")
    return(df)
}

require(boot)

#cv.err are two values, the RSME and the adjusted RSME of running 4-K cross validation - 
# ie it builds the model on 3/4s of the data and tests on the remaining 1/4 and repeats 
# this 4 times.  I generally run 100 iterations - but you might get the same effect if you 
# run 400-K - but this way I get some idea of the degree of variation (although you are 
# already dealing with an average value in the delta values).  I look to minimize the 2nd 
# value - mean adjusted RSMEof 100 iterations.  The third value is the highest RSME, the 
# 4th value is the lowest.  The 5th is the sd - theory if you run 100 iterations the true
# mean RSME of your model should have a 95% confidence of being in the interval 2xSD/10 
# either side.  The exact relationship between a decrease in the RSME and an increase in
# an AUC I don't know.
#In theory if you get a lower RSME value of a reasonable magnitude (hence the sd value) 
# then on average it should perform better on the test data.  But only on average - as the
# high and low value shows a different split can perform dramatically better or worse.  
# Because it takes so long I generally select candidate models to test by AIC and I run a
# batch of models over night

evalglmModel <- function(happyDF, model, iter) {
    cvRet = NULL
    cvTemp = data.frame(delta1 = rep(NA,iter),delta2=rep(NA,iter))
        
    for(i in 1:iter) {
        cv.err = cv.glm(happyDF, model, K = 4)$delta
        cvTemp[i,1]=cv.err[1]
        cvTemp[i,2]=cv.err[2]
    }
    
    
    cvRet[1]=mean(cvTemp[,1])
    cvRet[2]=mean(cvTemp[,2])
    cvRet[3]=max(cvTemp[,2])
    cvRet[4]=min(cvTemp[,2])
    cvRet[5]=sd(cvTemp[,2])
    return(cvRet)
}

createglmModel <- function(modelFormula, trainSet, testSet = NULL) {
    logModel = glm(formula=modelFormula, data = trainSet)
    predict.train = predict(logModel, type = "response")
    rocrPrediction.train = prediction(predict.train, trainSet$Happy)
    perf.train = performance(rocrPrediction.train, "tpr", "fpr")
    auc.train = as.numeric(performance(rocrPrediction.train, "auc")@y.values)
    temp = table(trainSet$Happy, predict.train > 0.5)
    acc.train = sum(diag(temp))/sum(temp)
    if (!is.null(testSet)) {
        predict.test = predict(logModel, newdata=testSet, type = "response")
        rocrPrediction.test = prediction(predict.test, testSet$Happy)
        perf.test = performance(rocrPrediction.test, "tpr", "fpr")
        auc.test = as.numeric(performance(rocrPrediction.test, "auc")@y.values)
        temp = table(testSet$Happy, predict.test > 0.5)
        acc.test = sum(diag(temp))/sum(temp)
    }
    else {
        predict.test = NULL
        perf.test = NULL
        auc.test = NULL
    }
    
    print(auc.test)
    sink("bigmodel.txt")
    summary(logModel)
    sink()
    list(model = logModel,
        formula = modelFormula,
        predTrain = predict.train,
        perfTrain = perf.train,
        AUCTrain = auc.train,
        accTrain = acc.train,
        predTest = predict.test,
        perfTest = perf.test,
        AUCTest = auc.test,
        accTest = acc.test
        )
}

require(gbm)

creategbmModel <- function(modelFormula, trainSet, testSet = NULL) {
    logModel = gbm(formula=modelFormula, data = trainSet, distribution="bernoulli", 
                   verbose=TRUE, n.trees=14000,cv.folds=10,n.cores = 7, interaction.depth = 4)
    best.iter <- gbm.perf(logModel,method="cv")
    predict.train = predict(logModel, type = "response")
    rocrPrediction.train = prediction(predict.train, trainSet$Happy)
    perf.train = performance(rocrPrediction.train, "tpr", "fpr")
    auc.train = as.numeric(performance(rocrPrediction.train, "auc")@y.values)
    temp = table(trainSet$Happy, predict.train > 0.5)
    acc.train = sum(diag(temp))/sum(temp)
    if (!is.null(testSet)) {
        predict.test = predict(logModel, newdata=testSet, type = "response")
        rocrPrediction.test = prediction(predict.test, testSet$Happy)
        perf.test = performance(rocrPrediction.test, "tpr", "fpr")
        auc.test = as.numeric(performance(rocrPrediction.test, "auc")@y.values)
        temp = table(testSet$Happy, predict.test > 0.5)
        acc.test = sum(diag(temp))/sum(temp)
    }
    else {
        predict.test = NULL
        perf.test = NULL
        auc.test = NULL
    }
    
    list(model = logModel,
         formula = modelFormula,
         predTrain = predict.train,
         perfTrain = perf.train,
         AUCTrain = auc.train,
         accTrain = acc.train,
         predTest = predict.test,
         perfTest = perf.test,
         AUCTest = auc.test,
         accTest = acc.test
    )
}

require(rpart)

createtreeModel <- function(modelFormula, trainSet, testSet = NULL) {
    tr.control = trainControl(method = "cv", number = 10, allowParallel=TRUE)
    cp.grid = expand.grid(.cp = (0:10)*0.001)
    treeModel = rpart(modelFormula, data = trainSet, method="class")
    #treeModel = tr$finalModel
    prp(treeModel, varlen=0, tweak=1.5)
    predict.trainset = predict(treeModel)
    rocrPrediction.train = prediction(predict.trainset[,2], trainSet$Happy)
    perf.train = performance(rocrPrediction.train, "tpr", "fpr")
    auc.train = as.numeric(performance(rocrPrediction.train, "auc")@y.values)
    temp = table(trainSet$Happy, predict.trainset[,2] > 0.5)
    acc.train = sum(diag(temp))/sum(temp)
    if (!is.null(testSet)) {
        predict.test = predict(treeModel, newdata=testSet)
        rocrPrediction.test = prediction(predict.test[,2], testSet$Happy)
        perf.test = performance(rocrPrediction.test, "tpr", "fpr")
        auc.test = as.numeric(performance(rocrPrediction.test, "auc")@y.values)
        temp = table(testSet$Happy, predict.test[,2] > 0.5)
        acc.test = sum(diag(temp))/sum(temp)
    }
    else {
        predict.test = NULL
        perf.test = NULL
        auc.test = NULL
    }
    
    list(model = treeModel,
         formula = modelFormula,
         train = trainSet,
         predTrain = predict.trainset,
         perfTrain = perf.train,
         AUCTrain = auc.train,
         accTrain = acc.train,
         test = testSet,
         predTest = predict.test,
         perfTest = perf.test,
         AUCTest = auc.test,
         accTest = acc.test
    )
}

require(randomForest)

require(RRF)

createrfModel <- function(modelFormula, trainSet, testSet = NULL) {
    rfModel = RRF(modelFormula, data = trainSet, ntree=4000, importance=TRUE)
    #treeModel = tr$finalModel
    predict.trainset = predict(rfModel, type="prob")
    rocrPrediction.train = prediction(predict.trainset[,2], trainSet$Happy)
    perf.train = performance(rocrPrediction.train, "tpr", "fpr")
    auc.train = as.numeric(performance(rocrPrediction.train, "auc")@y.values)
    temp = table(trainSet$Happy, predict.trainset[,2] > 0.5)
    acc.train = sum(diag(temp))/sum(temp)
    if (!is.null(testSet)) {
        predict.test = predict(rfModel, newdata=testSet, type="prob")
        rocrPrediction.test = prediction(predict.test[,2], testSet$Happy)
        perf.test = performance(rocrPrediction.test, "tpr", "fpr")
        auc.test = as.numeric(performance(rocrPrediction.test, "auc")@y.values)
        temp = table(testSet$Happy, predict.test[,2] > 0.5)
        acc.test = sum(diag(temp))/sum(temp)
    }
    else {
        predict.test = NULL
        perf.test = NULL
        auc.test = NULL
    }
    
    list(model = rfModel,
         formula = modelFormula,
         train = trainSet,
         predTrain = predict.trainset,
         perfTrain = perf.train,
         AUCTrain = auc.train,
         accTrain = acc.train,
         test = testSet,
         predTest = predict.test,
         perfTest = perf.test,
         AUCTest = auc.test,
         accTest = acc.test
    )
}
