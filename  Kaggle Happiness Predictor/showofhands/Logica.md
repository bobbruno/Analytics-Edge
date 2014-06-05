
#### Lógica de trabalho

1) carregar os dados para um dataframe
if you use the default parameters for read.csv, then you get the factor "" for missing values
2) Fazer o pré-processamento
    Ver o que tem de nulos
    what I did is either set the non-questionaire missing values to either the mean
    (for numeric variables) or the mode (for factor variables).  
    Then I used the loop to replace the missing questionaire values with a new factor level,
    "Skipped."
    var_names_train = names(train)    
    for (i in var_names_train[9:length(var_names_train)]) {
        levels(train[,i]) <- c(levels(train[,i]), "Skipped")
        train[,i][train[,i] == ''] <- 'Skipped'
    }

    rfImpute on some variables

    ou mice
    imputation <- mice(dataframe)
    dataframe <- complete(imputation)
    First I converted YOB from factors to integer values, then I removed UserID, and variables with factor that is more than 2. Seems that mice is working good now.

    Hope this will help you.

    Ver o que tem de numérico
    You can convert it to an integer by doing:
    One easy way to get rid of NA values, is to replace them with the median/mean:
    
    Ver o que tem de texto
    Income poderia ser dividido em duas variáveis: minincome e maxincome, ambas numéricas
    HouseholdStatus pode ser separado em married/single/others e with kids/no kids
    

    cor(Train)

2) criar train (60%), crossv (20%) e teste (20%)
    split = sample.split(quality$PoorCare, SplitRatio = 0.75)
    split

# Create training and testing sets
qualityTrain = subset(quality, split == TRUE)
qualityTest = subset(quality, split == FALSE)

3) Montar funcões glm e neuralnet que:
    Recebe a fórmula e os dfs train, crossv
    framinghamLog = glm(TenYearCHD ~ ., data = train, family=binomial)
    summary(framinghamLog)
    predictTest = predict(framinghamLog, type="response", newdata=test)
    table(test$TenYearCHD, predictTest > 0.5)

    StevensTree = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, method="class", data = Train, control=rpart.control(minbucket=25))
    prp(StevensTree)
    fitControl = trainControl( method = "cv", number = 10 )
    cartGrid = expand.grid( .cp = (1:50)*0.01) 
    
    # Perform the cross validation
    tr = train(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO, data = train, method = "rpart", trControl = tr.control, tuneGrid = cp.grid)

    # Extract tree
    best.tree = tr$finalModel
    prp(best.tree)

    StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, ntree=200, nodesize=25 )
    you have to convert the dependent variable to a factor to make sure randomForest is solving a classification problem. If you leave Happy as an int it attempts to do regression and this takes ages
    
    svm.model <- svm(Type ~ ., data = trainset, cost = 100, gamma = 1)
    svm.pred <- predict(svm.model, testset[,-10])




    Retornar o modelo, a previsão e o AUC de train e crossv
    ROCRpred = prediction(predictTrain, qualityTrain$PoorCare)
    ROCRperf = performance(ROCRpred, "tpr", "fpr")
    AUC = as.numeric(performance(ROCRpred, "auc")@y.values)

    PredictROC = predict(StevensTree, newdata = Test)
    pred = prediction(PredictROC[,2], Test$Reverse)
    perf = performance(pred, "tpr", "fpr")
    AUC = as.numeric(performance(ROCRpred, "auc")@y.values)



4) Escrever uma função que
    Recebe um dataframe x, tx, qtd de features a usar m, grau de polinômio a gerar (a princípio só 1)
    Retorna um vetor de objetos dataframe adaptado x e tx (com features polinomiais)
            e fórmulas de modelos
            vars <- names(x) 
            ## Loop por quantidades de variáveis a testar
            combn(vars, m, função paste)
            f <- as.formula(paste(vars[1], "~", paste(vars[-1], collapse="+"), 
                                  collapse=""))
5) Rodar mclapply(vetor retornado, função glm)
6) Rodar mclapply(vetor retornado, função neuralnet)

7) Escolher o melhor AUC
# Performance function
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,by=0.1), text.adj=c(-0.2,1.7))

# Plot ROC curve
plot(ROCRperf)
8) Rodar para test
8) Ver modelo, AUC e resultados


Passos posteriores:

1) Tentar clusterizar e gerar versões específicas para cada cluster
2) Tentar gerar features combinando mais polinômios







glm2 = glm(Happy ~ Q101162 + Q102289 + Q102906 + Q106997 + Q107869 + Q118237 + Q119334 + Q98869,
           data = train.imp, family= binomial)

predtest2 = predict(glm2, newdata=testdata.imp, type="response")
submission = data.frame(UserID = testdata.imp$UserID, Probability1 = predtest2)

tr.control = trainControl(method = "cv", number = 10)
cp.grid = expand.grid( .cp = (0:10)*0.001)
tr = train(Happy ~ Q101162 + Q102289 + Q102906 + Q106997 + Q107869 + Q118237 + Q119334 + Q98869, 
           data = traindata.imp, method = "rpart", trControl = tr.control, tuneGrid = cp.grid)
tree1 = tr$finalModel
predtree1.train = predict(tree1)
table(traindata.imp$Happy, predtree1.train[,2] > 0.5)
pred2.test = prediction(predtest2[,2], nottrain.imp$Happy)
perf2.train = performance(pred2.train, "tpr", "fpr")
perf2.test = performance(pred2.test, "tpr", "fpr")
auc2.train = as.numeric(performance(pred2.train, "auc")@y.values)
auc2.test = as.numeric(performance(pred2.test, "auc")@y.values)
