# Course project, Getting and Cleaning Data, Coursera

This is the code book for the course project for Getting and Cleaning Data from Coursera.
The code starts with the required packages and is then split into sections by 
comments.  

## Reading data

This section reads the data file.  The "UCI HAR Dataset" folder MUST be unzipped in 
the same directory as the script.  It WILL NOT download it automatically for you.
That just seemed safer to me.

This section also checked to see if there were any NAs in the code. There are not.


## Renaming variables

This section renames the variables based on the "features.txt" file.  I chose to 
leave the activities as numbers for now and will rename them at the end.


## Extracting only certain variables

Using grep commands, this section finds which variables (features) are the means and 
standard deviations and removes the others


## Merging data sets

Using cbind and rbind I combine the data sets in this section


## Averaging over subject and activity

There are actually three sections here.  In trying to learn the best way to do this 
I have actually used three different methods

- using dplyr
- using reshape2
- using nested for loops

Each method gives the same result - a 180 x 81 data frame with the mean of each 
variable from the merged data set.  


## Renaming activities

Here I rename the numbered "activities" to the valeus from "activity_labels.txt"




## Writing table
Finally I write to a table names "tidy_submit.txt".  The data looks like:


```
> head(summarydat_reshape, 10)[1:5]
   subject           activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
1        1            WALKING         0.2773308      -0.017383819        -0.1111481
2        1   WALKING_UPSTAIRS         0.2554617      -0.023953149        -0.0973020
3        1 WALKING_DOWNSTAIRS         0.2891883      -0.009918505        -0.1075662
4        1            SITTING         0.2612376      -0.001308288        -0.1045442
5        1           STANDING         0.2789176      -0.016137590        -0.1106018
6        1             LAYING         0.2215982      -0.040513953        -0.1132036
7        2            WALKING         0.2764266      -0.018594920        -0.1055004
8        2   WALKING_UPSTAIRS         0.2471648      -0.021412113        -0.1525139
9        2 WALKING_DOWNSTAIRS         0.2776153      -0.022661416        -0.1168129
10       2            SITTING         0.2770874      -0.015687994        -0.1092183
```







