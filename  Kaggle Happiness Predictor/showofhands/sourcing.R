library(caTools)
library(parallel)
library(corrplot)
#library(rpart)
#library(rpart.plot)
library(randomForest)
library(ROCR)
library(caret)
library(e1071)
library(mice)

setwd("~/Dropbox/Coursera/Analytics Edge/07.1) Kaggle")

if (file.exists("sourcedata.Rdata")) {
    load("sourcedata.Rdata")
} else {
    rawdata = read.csv("train.csv", na.strings = "")
    sourcedata = rawdata
    sourcedata$YOB = as.integer(as.character(rawdata$YOB))
    var_names_train = names(sourcedata)
    save(sourcedata, file="sourcedata.Rdata")
}

if (file.exists("imputation.Rdata")) {
    load("imputation.Rdata")
    load("sourcedata.imp.Rdata")
} else {
    imputation <- mice(sourcedata)
    sourcedata.imp <- complete(imputation)
    save(imputation, file="imputation.Rdata")
    save(sourcedata.imp, file="sourcedata.imp.Rdata")
}

# Adjusting features
sourcedata.imp2 = sourcedata.imp
sourcedata.imp2$Happy = as.factor(sourcedata.imp$Happy)
niveis = c(100000, 25000, 50000, 75000, 150000, 0)
sourcedata.imp2$minIncome = niveis[as.numeric(sourcedata.imp2$Income)]
niveis = c(150000, 50000, 75000, 100000, 1000000, 25000)
sourcedata.imp2$maxIncome = niveis[as.numeric(sourcedata.imp2$Income)]
HasKids = c(0, 1, 0, 1, 0, 1)
sourcedata.imp2$HasKids = HasKids[as.numeric(sourcedata.imp2$HouseholdStatus)]
juntado = c(1, 1, 1, 1,0,0)
sourcedata.imp2$LivesTogether = juntado[as.numeric(sourcedata.imp2$HouseholdStatus)]


drop.levels <- function(dat){
    # Drop unused factor levels from all factors in a data.frame
    # Author: Kevin Wright.  Idea by Brian Ripley.
    dat[] <- lapply(dat, function(x) x[,drop=TRUE])
    return(dat)
}
sourcedata.imp2 = drop.levels(sourcedata.imp2)
sourcedata.imp2 <- subset(sourcedata.imp2, ! (UserID %in% c(2194,4000,4313,6761)))
sourcedata.imp2$Less40 = sourcedata.imp2$YOB >=1974
sourcedata.imp2$Is40to60 = sourcedata.imp2$YOB <1974 & sourcedata.imp2$YOB >= 1954
sourcedata.imp2$More60 = sourcedata.imp2$YOB <1954


set.seed(42)
numberClusters = 2
sourcesplit = sample.split(sourcedata.imp2$Happy, SplitRatio = 0.6)
traindata.imp = subset(sourcedata.imp2, sourcesplit == TRUE)
# Clustering by  YOB, Gender, Party, LivesTogether, Income, Q123621, Q107869, Q101162, Q106997, Q98869, EducationLevel, HasKids
KMC = kmeans(sapply(traindata.imp[c(2,3,7,114,4,12,76,93,79,104,6,113)], as.numeric), centers = numberClusters, iter.max = 1000)
traindata.imp$cluster = KMC$cluster
nottraindata.imp = subset(sourcedata.imp2, sourcesplit == FALSE)
nottraindata.imp$cluster = predict.kmeans(KMC, sapply(nottraindata.imp[c(2,3,7,114,4,12,76,93,79,104,6,113)], as.numeric))

cormat <- cor(sapply(sourcedata.imp2[c(-1,-5,-110)], as.numeric))
corrplot(cormat, method = "ellipse")

# subsplit = sample.split()

if (file.exists("testdata.Rdata")) {
    load("testdata.Rdata")
} else {
    rawtest = read.csv("test.csv", na.strings = "")
    testdata = rawtest
    testdata$YOB = as.integer(as.character(rawtest$YOB))
    var_names_train = names(testdata)
    for (i in var_names_train[8:length(var_names_train)]) {
        levels(testdata[,i]) <- c(levels(testdata[,i]), "Skipped")
        testdata[,i][testdata[,i] == ''] <- 'Skipped'
    }
    save(testdata, file="testdata.Rdata")
}

if (file.exists("testimputation.Rdata")) {
    load("testimputation.Rdata")
    load("testdata.imp.Rdata")
} else {
    testimputation <- mice(testdata)
    testdata.imp <- complete(testimputation)
    save(testdata.imp, file="testdata.imp.Rdata")
    save(testimputation, file="testimputation.Rdata")
}

niveis = c(100000, 25000, 50000, 75000, 150000, 0)
testdata.imp$minIncome = niveis[as.numeric(testdata.imp$Income)]
niveis = c(150000, 50000, 75000, 100000, 1000000, 25000)
testdata.imp$maxIncome = niveis[as.numeric(testdata.imp$Income)]
HasKids = c(0, 1, 0, 1, 0, 1)
testdata.imp$HasKids = HasKids[as.numeric(testdata.imp$HouseholdStatus)]
juntado = c(1, 1, 1, 1,0,0)
testdata.imp$LivesTogether = juntado[as.numeric(testdata.imp$HouseholdStatus)]
testdata.imp = drop.levels(testdata.imp)
testdata.imp$cluster = predict.kmeans(KMC, sapply(testdata.imp[c(2,3,7,113,4,11,75,92,78,103,6,112)], as.numeric))
testdata.imp$Less40 = testdata.imp$YOB >=1974
testdata.imp$Is40to60 = testdata.imp$YOB <1974 & testdata.imp$YOB >= 1954
testdata.imp$More60 = testdata.imp$YOB <1954


Components = c("cluster", "Q124742", "Q124122", "Q123464", 
               "Q123621", "Q122769", "Q122770", "Q122771", "Q122120", "Q121699", "Q121700", 
               "Q120978", "Q121011", "Q120379", "Q120650", "Q120472", "Q120194", "Q120012", 
               "Q120014", "Q119334", "Q119851", "Q119650", "Q118892", "Q118117", "Q118232", 
               "Q118233", "Q118237", "Q117186", "Q117193", "Q116797", "Q116881", "Q116953", 
               "Q116601", "Q116441", "Q116448", "Q116197", "Q115602", "Q115777", "Q115610", 
               "Q115611", "Q115899", "Q115390", "Q114961", "Q114748", "Q115195", "Q114517", 
               "Q114386", "Q113992", "Q114152", "Q113583", "Q113584", "Q113181", "Q112478", 
               "Q112512", "Q112270", "Q111848", "Q111580", "Q111220", "Q110740", "Q109367", 
               "Q108950", "Q109244", "Q108855", "Q108617", "Q108856", "Q108754", "Q108342", 
               "Q108343", "Q107869", "Q107491", "Q106993", "Q106997", "Q106272", "Q106388", 
               "Q106389", "Q106042", "Q105840", "Q105655", "Q104996", "Q103293", "Q102906", 
               "Q102674", "Q102687", "Q102289", "Q102089", "Q101162", "Q101163", "Q101596", 
               "Q100689", "Q100680", "Q100562", "Q99982", "Q100010", "Q99716", "Q99581", 
               "Q99480", "Q98869", "Q98578", "Q98059", "Q98078", "Q98197", "Q96024", 
               "HasKids", "LivesTogether")


initial_AUC = 0
best_model = NULL
parallel_models = 200
rm(i, j, best_model, best_of_batch, combinacoes, batch_size, imputation, testimputation)


for (i in 2:min(c(4, length(Components)))) {
    filename = sprintf("~/Dropbox/Coursera/Analytics Edge/07.1) Kaggle/Model Analysis/models-%d-features.txt", i)
    print(sprintf("Iniciando modelos de %d features", i))
    variants = combn(Components, i, function(x) paste("Happy ~", paste(x, collapse="*")))
    combinacoes = length(variants)
    batch_size = combinacoes %/% parallel_models
    #variants = variants[1:3]
    print(sprintf("Criando %d modelos", combinacoes))
    sink(filename, type = "output")
    print(sprintf("Existem %d modelos", combinacoes))
    sink()
    best_of_run = NULL
    j = 1
    while (j <= batch_size+1) {
        init_offset = (j-1)*parallel_models+1
        if (j <= batch_size) {
            final_offset = j*parallel_models
        } else {
            final_offset = init_offset - 1 + length(variants) %% parallel_models
        }
        #print(sprintf("Init: %d    Final: %d     j: %d", init_offset, final_offset, j))
        vars_to_pass = variants[init_offset:final_offset]
        cat(sprintf("Criando modelos de %d a %d...", init_offset, final_offset))
        print(system.time(models <- mclapply(vars_to_pass, 
                 function(x) createglmModel(as.formula(x), 
                                        trainSet = traindata.imp, testSet = nottraindata.imp),
                 mc.cores = 2)))
        best_of_batch = models[[which.max(unlist(lapply(models, function(x) x$AUCTest)))]]
        
        sink(filename, append = TRUE, type = "output")
        k = 1
        while (k <= final_offset-init_offset+1) {
            currModel = models[[k]]
            print("===============================================================================")
            print(sprintf("Modelo: '%s'   AUC = %f", 
                  paste(as.character(currModel$formula[c(2, 1, 3)]), collapse = " "),
                  currModel$AUCTest))
            print(summary(currModel$model))
            k = k + 1
        }
        sink()
        rm(models)
        if (is.null(best_of_run) || best_of_run$AUCTest < best_of_batch$AUCTest) {
            best_of_run = best_of_batch
        }
        j = j + 1
    }
    
    sink(filename, append = TRUE, type = "output")
    print("===============================================================================")
    print(sprintf("Melhor modelo: '%s'   AUC = %f",
                  paste(as.character(best_of_run$formula[c(2, 1, 3)]), collapse = " "),
                  best_of_run$AUCTest))
    sink()
    if (is.null(best_model) || best_model$AUCTest < best_of_run$AUCTest) {
        best_model = best_of_run
        print(sprintf("Melhor modelo até agora: %s", 
                      paste(as.character(best_model$formula[c(2, 1, 3)]), collapse = " ")))
    }
    print("Melhor AUC:")
    print(sprintf("   da execucao: %f", best_of_run$AUCTest))
    print(sprintf("   geral: %f", best_model$AUCTest))
}

#tree = createtreeModel(as.formula(Happy ~ Q101162 + Q102289 + Q102906 + Q106997 + Q107869 + Q118237 + Q119334 + Q98869),
#                       traindata.imp, nottraindata.imp)
