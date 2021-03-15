########################################################
# Into the Mud: Data Wrangling with R and the Tidyverse
#    Jeffrey K. Bye, Ph.D. & Ethan C. Brown, Ph.D.
#     Friday, December 11, 2020; 8:30 am–12:30 pm
########################################################

# Room 4: grouping and summarizing
library(tidyverse)
test <- read_csv("student_data_grouping.csv")
test # notice new column!

# Let's first pivot long 
test_long <- test %>% # and then...
  pivot_longer( # pivot it LONGER
    # cols = -c(Student_ID, Workshop), # every column EXCEPT Student_ID & Workshop
    cols = starts_with("Q"), # another way
    names_to = c("Question_Number", "Question_Type"), # TWO col names
    names_sep = "_", # so we have to tell it WHERE to split...
    values_to = "Score" # where do the values go? new col (default: 'value')
  )
test_long

#Grouping to compare pre post or by question type

test_long %>% 
  group_by(Question_Type) %>%  #doesn't change the output but happens "under the hood"
  summarise(
   Mean_Score = mean(Score, na.rm = T) #doesn't work when there are NAs, need to specify what to do with NAs
   #Mean_Score becomes the variable name  
  )

#Challenge 1: Do the same thing but for workshop instead of question type
test_long %>% 
  group_by(Workshop) %>% 
  summarise(
    Mean_Score = mean(Score, na.rm = T)
  )

#Part 2: More Grouping
test_long %>% 
  group_by(Workshop) %>% 
  summarise(
    Mean_Score = mean(Score, na.rm = T), 
    SD_Score = sd(Score, na.rm = T), #adds SD as well
    n = sum(!is.na(Score)) #just n() doesn't account for NAs
      #Returns the number of times !is.na(Score) is True
  )

#Creating 2x2
test_long %>% 
  group_by(Workshop, Question_Type) %>% 
  summarise(
    Mean_Score = mean(Score, na.rm = T), 
    SD_Score = sd(Score, na.rm = T), #adds SD as well
    n = sum(!is.na(Score)) #just n() doesn't account for NAs
  )

#Challenge 2: Group by Student_ID to find mean, SD, and number of non-missing data
test_long %>% 
  group_by(Student_ID) %>% 
  summarise(
    Mean_Score = mean(Score, na.rm = T), 
    SD_Score = sd(Score, na.rm = T), #adds SD as well
    n = sum(!is.na(Score)) #returns sum for non-NA data
  )

#Do Workshop & Student ID at the same time
test_long %>% 
  group_by(Workshop, Student_ID) %>% 
    #changing order of Workshop and Student ID doesn't change data
    #just changes order of data in the output (i.e. which col comes first)
  summarise(
    Mean_Score = mean(Score, na.rm = T), 
    SD_Score = sd(Score, na.rm = T), #adds SD as well
    n = sum(!is.na(Score)) #returns sum for non-NA data
  )

#Finding SE of the mean, which is SD/sqrt(n), of the 2x2 cell mean code
test_long %>% 
  group_by(Workshop, Question_Type) %>% 
  summarise(
    Mean_Score = mean(Score, na.rm = T), 
    SD_Score = sd(Score, na.rm = T), #adds SD as well
    n = sum(!is.na(Score)), #just n() doesn't account for NAs
    MeanSE_Score = SD_Score/sqrt(n),
    n2 = n(),
    MeanSE_ScoreNAs = SD_Score/sqrt(n2)
  )
