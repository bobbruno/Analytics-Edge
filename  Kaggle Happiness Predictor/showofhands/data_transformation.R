numerify <- function(vec, val1 = "Yes") {
    ifelse(is.na(vec), 0,
           ifelse(vec %in% val1, -1, 1))
}

completedataset <- function(dataset) {
    dataset$YOB = suppressWarnings(as.numeric(as.character(dataset$YOB)))
    if ("Happy" %in% colnames(dataset)) {
        dataset2 = data.frame(UserID=dataset$UserID,
                              YOB=as.integer(dataset$YOB),
                              Happy=dataset$Happy)
    } else {
        dataset2 = data.frame(UserID=dataset$UserID,
                          YOB=as.integer(dataset$YOB))
    }
    dataset2$YOB = ifelse(is.na(dataset2$YOB), 1979, dataset2$YOB)
    
    dataset2$Gender=ifelse(is.na(dataset$Gender), 0, 
                          ifelse(dataset$Gender == "Male", 1, -1))
    dataset2$AvgIncome[ is.na(dataset$Income) ] = 0
    dataset2$AvgIncome[ dataset$Income == "$100,001 - $150,000"] = 125000
    dataset2$AvgIncome[ dataset$Income == "$25,001 - $50,000"] = 37500
    dataset2$AvgIncome[ dataset$Income == "$50,000 - $74,999"] = 62500
    dataset2$AvgIncome[ dataset$Income == "$75,000 - $100,000"] = 87500
    dataset2$AvgIncome[ dataset$Income == "over $150,000"] = 200000
    dataset2$AvgIncome[ dataset$Income == "under $25,000"] = 12500
    
    #     dataset2$HouseholdStatus = as.integer(ifelse(is.na(dataset$HouseholdStatus),
    #                     ifelse(ifelse(is.na(dataset$YOB), 1979, dataset$YOB)<1980, "4",
    #                                             "5"),
    #                                      dataset$HouseholdStatus))
    HasKids = c(-1, 1, -1, 1, -1, 1)
    dataset2$HasKids = HasKids[dataset$HouseholdStatus]
    dataset2$HasKids[is.na(dataset2$HasKids)] = 0
    juntado = c(1, 1, 1, 1,-1,-1)
    dataset2$LivesTogether = juntado[dataset$HouseholdStatus]
    dataset2$LivesTogether[is.na(dataset2$LivesTogether)] = 0

    dataset2$HighSchool = numerify(dataset$EducationLevel, "High School Diploma")
    dataset2$Bachelor = numerify(dataset$EducationLevel, "Bachelor's Degree")
    dataset2$Undergraduate = numerify(dataset$EducationLevel,
                                      c("Associate's Degree", "Current Undergraduate"))
    dataset2$K12 = numerify(dataset$EducationLevel, "Current K-12")
    dataset2$PostGraduate= numerify(dataset$EducationLevel,
                                    c("Master's Degree", "Doctoral Degree"))
    
    dataset2$Democrat = numerify(dataset$Party, "Democrat")
    dataset2$Republican = numerify(dataset$Party, "Republican")
    
    dataset2$InteractDislikes =  numerify(dataset$Q124742)
    dataset2$ParentsFight =      numerify(dataset$Q124122)
    dataset2$MinimumWage =       numerify(dataset$Q123464)
    dataset2$FullTime =          numerify(dataset$Q123621)
    dataset2$Collects =          numerify(dataset$Q122769)
    dataset2$WalletHas20 =       numerify(dataset$Q122770)
    dataset2$PublicSchool =      numerify(dataset$Q122771, "Public")
    dataset2$Jealous =           numerify(dataset$Q122120)
    dataset2$Relationship =      numerify(dataset$Q121700)
    dataset2$Alcohol =           numerify(dataset$Q121699)
    dataset2$SesameStreet =      numerify(dataset$Q120978)
    dataset2$StressfulEvts =     numerify(dataset$Q121011)
    dataset2$Masters =           numerify(dataset$Q120379)
    dataset2$ParentsMarried =    numerify(dataset$Q120650)
    dataset2$Science =           numerify(dataset$Q120472,  "Art")
    dataset2$TryFirst =          numerify(dataset$Q120194, "Try first")
    dataset2$WeatherMatters =    numerify(dataset$Q120012)
    dataset2$Successful =        numerify(dataset$Q120014)
    dataset2$Exciting =          numerify(dataset$Q119334)
    dataset2$GoodBook =          numerify(dataset$Q119851)
    dataset2$Giver =             numerify(dataset$Q119650,"Giving")
    dataset2$Glasses =           numerify(dataset$Q118892)
    dataset2$SameState =         numerify(dataset$Q118117)
    dataset2$Idealist =          numerify(dataset$Q118232, "Idealist")
    dataset2$RiskofLife =        numerify(dataset$Q118233)
    dataset2$OverYourHead =      numerify(dataset$Q118237)
    dataset2$HotHead =           numerify(dataset$Q117186, "Hot headed")
    dataset2$OddHours =          numerify(dataset$Q117193, "Odd hours")
    dataset2$Vitamins =          numerify(dataset$Q116797)
    dataset2$HappyorRight =      numerify(dataset$Q116881, "Happy")
    dataset2$Rules =             numerify(dataset$Q116953)
    dataset2$TravelAbroad =      numerify(dataset$Q116601)
    dataset2$CarPymt =           numerify(dataset$Q116441)
    dataset2$NoLies =            numerify(dataset$Q116448)
    dataset2$Morning =           numerify(dataset$Q116197, "A.M.")
    dataset2$Obedient =          numerify(dataset$Q115602)
    dataset2$StartHabit =        numerify(dataset$Q115777, "Start")
    dataset2$PositiveThinking =  numerify(dataset$Q115610)
    dataset2$OwnGun =            numerify(dataset$Q115611)
    dataset2$TakesRespons =      numerify(dataset$Q115899, "Me")
    dataset2$Personality =       numerify(dataset$Q115390)
    dataset2$MoneyBuys =         numerify(dataset$Q114961)
    dataset2$TapWater =          numerify(dataset$Q114748)
    dataset2$CityLimits =        numerify(dataset$Q115195)
    dataset2$MorningNews =       numerify(dataset$Q114517)
    dataset2$Misterious =        numerify(dataset$Q114386, "Mysterious")
    dataset2$Gambles =           numerify(dataset$Q113992)
    dataset2$Charity =           numerify(dataset$Q114152)
    dataset2$TalkRadio =         numerify(dataset$Q113583, "Talk")
    dataset2$PeopleorTech =      numerify(dataset$Q113584, "People")
    dataset2$Meditates =         sign(numerify(dataset$Q113181) +
                                      numerify(dataset$Q98197))
    dataset2$Phobic =            numerify(dataset$Q112478)
    dataset2$Skeptical =         numerify(dataset$Q112512)
    dataset2$LooksGood =         numerify(dataset$Q112270)
    dataset2$StraightA =         numerify(dataset$Q111848)
    dataset2$SuppParents =       numerify(dataset$Q111580, "Supportive")
    dataset2$AlarmAhead =        numerify(dataset$Q111220)
    dataset2$Mac =               numerify(dataset$Q110740, "Mac")
    dataset2$Poor =              numerify(dataset$Q109367)
    dataset2$Cautious =          numerify(dataset$Q108950, "Cautious")
    dataset2$Feminist =          numerify(dataset$Q109244)
    dataset2$LikesFamily =       numerify(dataset$Q108855, "Yes!")
    dataset2$SingleParent =      numerify(dataset$Q108617)
    dataset2$Sociable =          numerify(dataset$Q108856, "Socialize")
    dataset2$ParentsCollege =    numerify(dataset$Q108754)
    dataset2$Online =            numerify(dataset$Q108342, "Online")
    dataset2$HasDebt =           numerify(dataset$Q108343)
    dataset2$FeelsNormal =       numerify(dataset$Q107869)
    dataset2$Punctuates =        numerify(dataset$Q107491)
    dataset2$LikesName =         numerify(dataset$Q106993)
    dataset2$LikesPeople =       numerify(dataset$Q106997, "Yay people!")
    dataset2$PowerTools =        numerify(dataset$Q106272)
    dataset2$Overworks =         numerify(dataset$Q106388)
    dataset2$GoodLiar =          numerify(dataset$Q106389)
    dataset2$Medications =       numerify(dataset$Q106042)
    dataset2$RetailTherapy =     numerify(dataset$Q105840)
    dataset2$Alarm =             numerify(dataset$Q105655)
    dataset2$BrushesTeeth =      numerify(dataset$Q104996)
    dataset2$ManyPets =          numerify(dataset$Q103293)
    dataset2$Grudge =            numerify(dataset$Q102906)
    dataset2$CreditDebt =        numerify(dataset$Q102674)
    dataset2$EatsBreakfast =     numerify(dataset$Q102687)
    dataset2$HomeOwner =         numerify(dataset$Q102089, "Own")
    dataset2$Optimist =          numerify(dataset$Q101162, "Optimist")
    dataset2$MomRules =          numerify(dataset$Q101163, "Mom")
    dataset2$TreeHouse =         numerify(dataset$Q101596)
    dataset2$Overweight =        numerify(dataset$Q100689)
    dataset2$CryBaby =           numerify(dataset$Q100680)
    dataset2$LifeImproves =      numerify(dataset$Q100562)
    dataset2$CheckLists =        numerify(dataset$Q99982, "Check!")
    dataset2$WatchTV =           numerify(dataset$Q100010)
    dataset2$HomeAlone =         numerify(dataset$Q99716)
    dataset2$LeftHanded =        numerify(dataset$Q99581)
    dataset2$Spanked =           numerify(dataset$Q99480)
    dataset2$MeaningofLife =     numerify(dataset$Q98869)
    dataset2$Exercises =         numerify(dataset$Q98578)
    dataset2$Siblings =          numerify(dataset$Q98059)
    dataset2$Outlet =            numerify(dataset$Q98078)
    dataset2$GoodatMath =        numerify(dataset$Q96024)
    dataset2$YOB = (dataset2$YOB-mean(dataset2$YOB))/sd(dataset2$YOB)
    dataset2$AvgIncome = (dataset2$AvgIncome-mean(dataset2$AvgIncome))/
                        sd(dataset2$AvgIncome)
    
    return(dataset2)
}

