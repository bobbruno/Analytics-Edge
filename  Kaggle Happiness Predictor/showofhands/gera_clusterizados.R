numberClusters = 1
media = 0
# Clustering by  YOB, Gender, Party, LivesTogether, Income, Q123621, Q107869, Q101162, Q106997, Q98869, EducationLevel, HasKids
# Clustering by  YOB, Gender #, #EducationLevel, Party, Income, HasKids, LivesTogether
clustervec = c(2,
               3)
               #4,
               #6,
               #7,
               #113,
               #114)
clustervec2 = c(2,
                3,
                4,
                6,
                7,
                112,
                113)
if (numberClusters > 1) {
    KMC = kmeans(sapply(traindata.imp[clustervec], as.numeric), centers = numberClusters, iter.max = 1000)
    traindata.imp$cluster = KMC$cluster
    nottraindata.imp$cluster = predict.kmeans(KMC, sapply(nottraindata.imp[clustervec], as.numeric))
    testdata.imp$cluster = predict.kmeans(KMC, sapply(testdata.imp[clustervec], as.numeric))
} else {
    traindata.imp$cluster = rep(1, 2769)
    nottraindata.imp$cluster = rep(1, 1846)
    testdata.imp$cluster = rep(1, 1980)
}
modelo = list()
previ = NULL
for (i in 1:numberClusters) {
    # ~Q123621+Q107869+Q101162+Q106997+Q98869+Q102089+Q102289+Q102906+Q108343+Q108855+Q108856+Q113181+Q114961+Q116197+Q116441+Q118237+Q119334+Q120014
    #LivesTogether+HasKids+Party+Income+EducationLevel+Q123621+Q107869+Q101162+Q106997+Q98869+Q102089+Q102289+Q102906+Q108343+Q108855+Q108856+Q113181+Q114961+Q116197+Q116441+Q118237+Q119334+Q120014, 
    modelo = c(modelo, list(createrfModel(Happy ~ ., subset(traindata.imp, cluster == i), 
                                          subset(nottraindata.imp, cluster ==i))))
    previ = c(previ, predict(modelo[[i]]$model, newdata=subset(testdata.imp, cluster==i), type="prob")[,2])
}
submission.n = data.frame(UserID = testdata.imp$UserID, Probability1 = previ)
lapply(modelo, function(x) c(x$AUCTest, x$AUCTrain))
mean(unlist(lapply(modelo, function(x) x$AUCTest)))
table(nottraindata.imp$cluster)
table(nottraindata.imp$cluster)/1846*100



#pred.test1 = predict(modelo[[1]]$model, newdata=subset(testdata.imp, cluster==1), type="prob")
#pred.test2 = predict(modelo[[2]]$model, newdata=subset(testdata.imp, cluster==1), type="prob")
#pred.test =c(pred.test1[,2], pred.test2[,2])
submission6 = data.frame(UserID = testdata.imp$UserID, Probability1 = pred.test)
setwd("~/Dropbox/Coursera/Analytics Edge/07.1) Kaggle/submissions")
write.csv(submission.n, "submission9.csv", row.names=FALSE)

[1] "Clusters: 2     Media: 0.760925"
[1] "Clusters: 3     Media: 0.744268"
[1] "Clusters: 4     Media: 0.743157"
[1] "Clusters: 5     Media: 0.746761"
[1] "Clusters: 6     Media: 0.736215"
[1] "Clusters: 7     Media: 0.736231"
[1] "Clusters: 8     Media: 0.734297"
[1] "Clusters: 9     Media: 0.729386"
[1] "Clusters: 10     Media: 0.743444"
[1] "Clusters: 11     Media: 0.730032"
[1] "Clusters: 12     Media: 0.734066"
[1] "Clusters: 13     Media: 0.705696"
[1] "Clusters: 14     Media: 0.731608"
[1] "Clusters: 15     Media: 0.723405"
[1] "Clusters: 16     Media: 0.724260"
[1] "Clusters: 17     Media: 0.719487"
[1] "Clusters: 18     Media: 0.720352"
[1] "Clusters: 19     Media: 0.719176"
[1] "Clusters: 20     Media: 0.716243"
[1] "Clusters: 21     Media: 0.699414"
[1] "Clusters: 22     Media: 0.711067"
[1] "Clusters: 23     Media: 0.684983"
[1] "Clusters: 24     Media: 0.685805"
[1] "Clusters: 25     Media: 0.704126"