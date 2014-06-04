# MARKET SEGMENTATION FOR AIRLINES [link](https://courses.edx.org/courses/MITx/15.071x/1T2014/courseware/d32b0c36ff484c228b8117257349d0e6/27bfa0a7d1304080a09965a5773c16f3/)

Market segmentation is a strategy that divides a broad target market of customers into smaller, more similar groups, and then designs a marketing strategy specifically for each group. Clustering is a common technique for market segmentation since it automatically finds similar groups given a data set. 

In this problem, we'll see how clustering can be used to find similar groups of customers who belong to an airline's frequent flyer program. The airline is trying to learn more about its customers so that it can target different customer segments with different types of mileage offers. 

The file [AirlinesCluster.csv](https://courses.edx.org/c4x/MITx/15.071x/asset/AirlinesCluster.csv) contains information on 3,999 members of the frequent flyer program. This data comes from the textbook "Data Mining for Business Intelligence," by Galit Shmueli, Nitin R. Patel, and Peter C. Bruce. For more information, see the [website for the book](http://www.dataminingbook.com/).

There are seven different variables in the dataset, described below:

- **Balance** = number of miles eligible for award travel
- **QualMiles** = number of miles qualifying for TopFlight status
- **BonusMiles** = number of miles earned from non-flight bonus transactions in the past 12 months
- **BonusTrans** = number of non-flight bonus transactions in the past 12 months
- **FlightMiles** = number of flight miles in the past 12 months
- **FlightTrans** = number of flight transactions in the past 12 months
- **DaysSinceEnroll** = number of days since enrolled in the frequent flyer program

## PROBLEM 1.1 - NORMALIZING THE DATA  (2 points possible)
Read the dataset [AirlinesCluster.csv](https://courses.edx.org/c4x/MITx/15.071x/asset/AirlinesCluster.csv) into R and call it "airlines".


```r
setwd("~/Dropbox/Coursera/Analytics Edge/6.5) Assignment")
airlines = read.csv("AirlinesCluster.csv")
summary(airlines)
```

```
##     Balance          QualMiles       BonusMiles       BonusTrans  
##  Min.   :      0   Min.   :    0   Min.   :     0   Min.   : 0.0  
##  1st Qu.:  18528   1st Qu.:    0   1st Qu.:  1250   1st Qu.: 3.0  
##  Median :  43097   Median :    0   Median :  7171   Median :12.0  
##  Mean   :  73601   Mean   :  144   Mean   : 17145   Mean   :11.6  
##  3rd Qu.:  92404   3rd Qu.:    0   3rd Qu.: 23800   3rd Qu.:17.0  
##  Max.   :1704838   Max.   :11148   Max.   :263685   Max.   :86.0  
##   FlightMiles     FlightTrans    DaysSinceEnroll
##  Min.   :    0   Min.   : 0.00   Min.   :   2   
##  1st Qu.:    0   1st Qu.: 0.00   1st Qu.:2330   
##  Median :    0   Median : 0.00   Median :4096   
##  Mean   :  460   Mean   : 1.37   Mean   :4119   
##  3rd Qu.:  311   3rd Qu.: 1.00   3rd Qu.:5790   
##  Max.   :30817   Max.   :53.00   Max.   :8296
```


### Looking at the summary of airlines, which two variables have (on average) the smallest values?
- Balance
- QualMiles
- BonusMiles
- **BonusTrans** (11.6)
- FlightMiles
- **FlightTrans** (1.374)
- DaysSinceEnroll

### Which two variables have (on average) the largest values?
- **Balance** (73601)
- QualMiles
- **BonusMiles** (17145)
- BonusTrans
- FlightMiles
- FlightTrans
- DaysSinceEnroll

## PROBLEM 1.2 - NORMALIZING THE DATA  (1 point possible)
In this problem, we will normalize our data before we run the clustering algorithms. Why is it important to normalize the data before clustering?

- If we don't normalize the data, the clustering algorithms will not work (we will get an error in R).
- If we don't normalize the data, it will be hard to interpret the results of the clustering.
- **If we don't normalize the data, the clustering will be dominated by the variables that are on a larger scale.**
- If we don't normalize the data, the clustering will be dominated by the variables that are on a smaller scale.

## PROBLEM 1.3 - NORMALIZING THE DATA  (2 points possible)
Let's go ahead and normalize our data. You can normalize the variables in a data frame by using the preProcess function in the "caret" package. You should already have this package installed from Week 4, but if not, go ahead and install it with **install.packages("caret")**. Then load the package with **library(caret)**.

Now, create a normalized data frame called "airlinesNorm" by running the following commands:


```r
library(caret)
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```r
preproc = preProcess(airlines)

airlinesNorm = predict(preproc, airlines)
summary(airlinesNorm)
```

```
##     Balance         QualMiles        BonusMiles       BonusTrans    
##  Min.   :-0.730   Min.   :-0.186   Min.   :-0.710   Min.   :-1.208  
##  1st Qu.:-0.546   1st Qu.:-0.186   1st Qu.:-0.658   1st Qu.:-0.896  
##  Median :-0.303   Median :-0.186   Median :-0.413   Median : 0.041  
##  Mean   : 0.000   Mean   : 0.000   Mean   : 0.000   Mean   : 0.000  
##  3rd Qu.: 0.187   3rd Qu.:-0.186   3rd Qu.: 0.276   3rd Qu.: 0.562  
##  Max.   :16.187   Max.   :14.223   Max.   :10.208   Max.   : 7.747  
##   FlightMiles      FlightTrans     DaysSinceEnroll  
##  Min.   :-0.329   Min.   :-0.362   Min.   :-1.9934  
##  1st Qu.:-0.329   1st Qu.:-0.362   1st Qu.:-0.8661  
##  Median :-0.329   Median :-0.362   Median :-0.0109  
##  Mean   : 0.000   Mean   : 0.000   Mean   : 0.0000  
##  3rd Qu.:-0.106   3rd Qu.:-0.098   3rd Qu.: 0.8096  
##  Max.   :21.680   Max.   :13.610   Max.   : 2.0228
```


The first command pre-processes the data, and the second command performs the normalization. If you look at the summary of airlinesNorm, you should see that all of the variables now have mean zero. You can also see that each of the variables has standard deviation 1 by using the sd() function.

### In the normalized data, which variable has the largest maximum value?
- Balance
- QualMiles
- BonusMiles
- BonusTrans
- ***FlightMiles***
- FlightTrans
- DaysSinceEnroll

### In the normalized data, which variable has the smallest minimum value?
- Balance
- QualMiles
- BonusMiles
- BonusTrans
- FlightMiles
- FlightTrans
- **DaysSinceEnroll**

## PROBLEM 2.1 - HIERARCHICAL CLUSTERING  (1 point possible)
Compute the distances between data points (using euclidean distance) and then run the Hierarchical clustering algorithm (using method="ward") on the normalized data. It may take a few minutes for the commands to finish since the dataset has a large number of observations for hierarchical clustering.


```r
distances = dist(airlinesNorm, method = "euclidean")
clusterAirlines = hclust(distances, method = "ward.D")
```


Then, plot the dendrogram of the hierarchical clustering process. Suppose the airline is looking for somewhere between 2 and 10 clusters. 

```r
plot(clusterAirlines)
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 

According to the dendrogram, which of the following is NOT a good choice for the number of clusters?
- 2
- 3
- **6**
- 7

## PROBLEM 2.2 - HIERARCHICAL CLUSTERING  (1 point possible)
Suppose that after looking at the dendrogram and discussing with the marketing department, the airline decides to proceed with 5 clusters. Divide the data points into 5 clusters by using the **cutree** function. 


```r
clusterGroups = cutree(clusterAirlines, k = 5)
airlines.1 = subset(airlinesNorm, clusterGroups == 1)
airlines.2 = subset(airlinesNorm, clusterGroups == 2)
airlines.3 = subset(airlinesNorm, clusterGroups == 3)
airlines.4 = subset(airlinesNorm, clusterGroups == 4)
airlines.5 = subset(airlinesNorm, clusterGroups == 5)
dim(airlines.1)[1]
```

```
## [1] 776
```


### How many data points are in Cluster 1?
- __776__

## PROBLEM 2.3 - HIERARCHICAL CLUSTERING  (2 points possible)
Now, use **tapply** to compare the average values in each of the variables for the 5 clusters (the centroids of the clusters). You may want to compute the average values of the unnormalized data so that it is easier to interpret. You can do this for the variable "Balance" with the following command:

**tapply(airlines$Balance, clusterGroups, mean)**

```r
airVec = c(tapply(airlines$Balance, clusterGroups, mean), tapply(airlines$QualMiles, 
    clusterGroups, mean), tapply(airlines$BonusMiles, clusterGroups, mean), 
    tapply(airlines$BonusTrans, clusterGroups, mean), tapply(airlines$FlightMiles, 
        clusterGroups, mean), tapply(airlines$FlightTrans, clusterGroups, mean), 
    tapply(airlines$DaysSinceEnroll, clusterGroups, mean))
dim(airVec) = c(5, 7)
colnames(airVec) = c("Balance", "QualMiles", "BonusMiles", "BonusTrans", "FlightMiles", 
    "FlightTrans", "DaysEnroll")
airVec
```

```
##      Balance QualMiles BonusMiles BonusTrans FlightMiles FlightTrans
## [1,]   57867    0.6443      10360     10.823       83.18      0.3028
## [2,]  110669 1065.9827      22882     18.229     2613.42      7.4027
## [3,]  198192   30.3462      55796     19.664      327.68      1.0688
## [4,]   52336    4.8479      20789     17.088      111.57      0.3445
## [5,]   36256    2.5112       2265      2.973      119.32      0.4389
##      DaysEnroll
## [1,]       6235
## [2,]       4402
## [3,]       5616
## [4,]       2841
## [5,]       3060
```


### Compared to the other clusters, Cluster 1 has the largest average values in which variables (if any)?

- Balance
- QualMiles
- BonusMiles
- BonusTrans
- FlightMiles
- FlightTrans
- **DaysSinceEnroll**

### How would you describe the customers in Cluster 1?
- Relatively new customers who don't use the airline very often.
- **Infrequent but loyal customers.**
- Customers who have accumulated a large amount of miles, mostly through non-flight transactions.
- Customers who have accumulated a large amount of miles, and the ones with the largest number of flight transactions.
- Relatively new customers who seem to be accumulating miles, mostly through non-flight transactions.

## PROBLEM 2.4 - HIERARCHICAL CLUSTERING  (2 points possible)
Compared to the other clusters, Cluster 2 has the largest average values in which variables (if any)?
- Balance
- **QualMiles**
- BonusMiles
- BonusTrans
- **FlightMiles**
- **FlightTrans**
- DaysSinceEnroll

### How would you describe the customers in Cluster 2?
- Relatively new customers who don't use the airline very often.
- Infrequent but loyal customers.
- Customers who have accumulated a large amount of miles, mostly through non-flight transactions.
- **Customers who have accumulated a large amount of miles, and the ones with the largest number of flight transactions.**
- Relatively new customers who seem to be accumulating miles, mostly through non-flight transactions.

## PROBLEM 2.5 - HIERARCHICAL CLUSTERING  (2 points possible)
Compared to the other clusters, Cluster 3 has the largest average values in which variables (if any)?
- **Balance**
- QualMiles
- **BonusMiles**
- **BonusTrans**
- FlightMiles
- FlightTrans
- DaysSinceEnroll

### How would you describe the customers in Cluster 3?
- Relatively new customers who don't use the airline very often.
- Infrequent but loyal customers.
- **Customers who have accumulated a large amount of miles, mostly through non-flight transactions.**
- Customers who have accumulated a large amount of miles, and the ones with the largest number of flight transactions.
- Relatively new customers who seem to be accumulating miles, mostly through non-flight transactions.

## PROBLEM 2.6 - HIERARCHICAL CLUSTERING  (2 points possible)
Compared to the other clusters, Cluster 4 has the largest average values in which variables (if any)?
- Balance
- QualMiles
- BonusMiles
- BonusTrans
- FlightMiles
- FlightTrans
- DaysSinceEnroll

### How would you describe the customers in Cluster 4?
- Relatively new customers who don't use the airline very often.
- Infrequent but loyal customers.
- Customers who have accumulated a large amount of miles, mostly through non-flight transactions.
- Customers who have accumulated a large amount of miles, and the ones with the largest number of flight transactions.
- **Relatively new customers who seem to be accumulating miles, mostly through non-flight transactions.**

## PROBLEM 2.7 - HIERARCHICAL CLUSTERING  (2 points possible)
Compared to the other clusters, Cluster 5 has the largest average values in which variables (if any)?
- Balance
- QualMiles
- BonusMiles
- BonusTrans
- FlightMiles+
- FlightTrans
- DaysSinceEnroll

### How would you describe the customers in Cluster 5?
- **Relatively new customers who don't use the airline very often.**
- Infrequent but loyal customers.
- Customers who have accumulated a large amount of miles, mostly through non-flight transactions.
- Customers who have accumulated a large amount of miles, and the ones with the largest number of flight transactions.
- Relatively new customers who seem to be accumulating miles, mostly through non-flight transactions.

## PROBLEM 3.1 - K-MEANS CLUSTERING  (1 point possible)
Now run the k-means clustering algorithm on the normalized data, again creating 5 clusters. Set the seed to 88 right before running the clustering algorithm, and set the argument iter.max to 1000.

```r
k = 5
set.seed(88)
KMC.airlines = kmeans(airlinesNorm, centers = k, iter.max = 1000)
```


How many clusters have more than 1,000 observations?
- __2__

## PROBLEM 3.2 - K-MEANS CLUSTERING  (1 point possible)
Now, compare the cluster centroids to each other either by dividing the data points into groups and then using tapply, or by looking at the output of kmeansClust$centers, where "kmeansClust" is the name of the output of the kmeans function. (Note that the output of kmeansClust$centers will be for the normalized data. If you want to look at the average values for the unnormalized data, you need to use tapply like we did for hierarchical clustering.)


```r
airVec2 = c(tapply(airlines$Balance, clusterGroups, mean), tapply(airlines$QualMiles, 
    KMC.airlines$cluster, mean), tapply(airlines$BonusMiles, KMC.airlines$cluster, 
    mean), tapply(airlines$BonusTrans, KMC.airlines$cluster, mean), tapply(airlines$FlightMiles, 
    KMC.airlines$cluster, mean), tapply(airlines$FlightTrans, KMC.airlines$cluster, 
    mean), tapply(airlines$DaysSinceEnroll, clusterGroups, mean))
dim(airVec2) = c(5, 7)
colnames(airVec2) = c("Balance", "QualMiles", "BonusMiles", "BonusTrans", "FlightMiles", 
    "FlightTrans", "DaysEnroll")
airVec2
```

```
##      Balance QualMiles BonusMiles BonusTrans FlightMiles FlightTrans
## [1,]   57867    539.58      62474     21.525       623.9      1.9216
## [2,]  110669    673.16      31985     28.135      5859.2     17.0000
## [3,]  198192     34.99      24490     18.429       289.5      0.8852
## [4,]   52336     55.21       8710      8.362       203.3      0.6294
## [5,]   36256    126.47       3097      4.285       181.5      0.5404
##      DaysEnroll
## [1,]       6235
## [2,]       4402
## [3,]       5616
## [4,]       2841
## [5,]       3060
```


Do you expect Cluster 1 of the K-Means clustering output to necessarily be similar to Cluster 1 of the Hierarchical clustering output?

- Yes, because the clusters are displayed in order of size, so the largest cluster will always be first.
- Yes, because the clusters are displayed according to the properties of the centroid, so the cluster order will be similar.
- **No, because cluster ordering is not meaningful in either k-means clustering or hierarchical clustering.**
- No, because the clusters produced by the k-means algorithm will never be similar to the clusters produced by the Hierarchical algorithm.
