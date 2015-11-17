### Course project, Getting and Cleaning Data, Coursera
# You should create one R script called run_analysis.R that does the following. 
#  1 Merges the training and the test sets to create one data set.
#  2 Extracts only the measurements on the mean and standard deviation for each measurement. 
#  3 Uses descriptive activity names to name the activities in the data set
#  4 Appropriately labels the data set with descriptive variable names. 
#  5 From the data set in step 4, creates a second, independent tidy data set with 
#     the average of each variable for each activity and each subject.

library(plyr)
library(dplyr)
library(reshape2)


#############################
### Reading data
#############################

# Test sets
test_subj <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
test_x <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
test_activ <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)

# training sets
train_subj <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
train_x <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
train_activ <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)

# activities list
activ_list <- read.table("UCI HAR Dataset/activity_labels.txt")

# variables list
vars_list <- read.table("UCI HAR Dataset/features.txt")

# Are there any NAs?
sum(is.na(test_x))
sum(is.na(train_x))
# No there are not





#######################################
### Renaming variables, merging data
#######################################


### how to set variable names from another data frame:
#df <- data.frame("V1" = c(1, 2, 3), "V2" = c(2, 3, 4), "V3" = c(3, 4, 5), "v4" = c(4, 5, 6))
#df_names <- data.frame("index" = 1:4, "names" = c("name1", "name2", "name3", "name4"))
#names(df) <- df_names$names
#df

# Renaming variables
names(train_x) <- vars_list$V2
names(test_x) <- vars_list$V2
names(test_activ) <- "activity"
names(train_activ) <- "activity"
names(test_subj) <- "subject"
names(train_subj) <- "subject"



###########################################
### Extracting only certain variables
###########################################

# which variables are means and stds 
means_and_stds <- grepl("mean|std", vars_list$V2)

# shortening the data sets to means and sds only
train_means_sds <- train_x[,means_and_stds]
test_means_sds <- test_x[,means_and_stds]





###########################
### Merging data sets
###########################

# columns first
test_bind <- cbind(test_subj, test_activ, test_means_sds)
train_bind <- cbind(train_subj, train_activ, train_means_sds)

# now merging rows
all_data <- rbind(test_bind, train_bind)

# ordering data frame by subject and activity
all_data <- all_data[order(all_data$subject, all_data$activity), ]



########################################
### Averaging over subject, activity -- dplyr
#######################################


#k <- group_by(all_data, subject, activity) %>% summarise( `tBodyAcc-mean()-X` = mean(`tBodyAcc-mean()-X`), 
#                                                          `tBodyAcc-mean()-Y` = mean(`tBodyAcc-mean()-Y`))

summarydat_dplyr <- (all_data %>% 
                             group_by(subject,activity) %>% 
                             summarise_each(funs(mean)))

##################################################
### Averaging over subject, activity -- reshape2
##################################################

melt_all_dat <- melt(all_data, id.vars = c("subject", "activity"), variable.name = "variable")

summarydat_reshape <- dcast(data = melt_all_dat, subject + activity ~ variable, mean)


########################################
### Averaging over subject, activity -- FOR LOOP METHOD
#######################################

# initialize table, number rows = combinations of activity, subject, ncols = cols in all_data
summarydat <- matrix( nrow = length(unique(all_data$subject))*length(unique(all_data$activity)), 
                      ncol = dim(all_data)[2])

iter <- 1
for(subj in 1:length(unique(all_data$subject))){

        for(act in 1:length(unique(all_data$activity))){
                summarydat[iter,] <- colMeans(all_data[(all_data$subject == subj & all_data$activity == act) , ])
                iter <- iter + 1
        }

}
summarydf_for <- as.data.frame(summarydat)
names(summarydf_for) <- names(all_data)


#############################################
### Renaming activities
#############################################

activity_vec <- activ_list[summarydf_for$activity , 2]
summarydf_for$activity <- activity_vec

activity_vec <- activ_list[summarydat_reshape$activity , 2]
summarydat_reshape$activity <- activity_vec

activity_vec <- activ_list[summarydat_dplyr$activity , 2]
summarydat_dplyr$activity <- activity_vec



###################################
### Writing table
###################################
# I chose to use the reshape version, but any can be used as they are equivalent
write.table(summarydat_reshape, file = "tidy_submit.txt", row.names = FALSE)









