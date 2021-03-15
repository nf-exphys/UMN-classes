########################################################
# Into the Mud: Data Wrangling with R and the Tidyverse
#    Jeffrey K. Bye, Ph.D. & Ethan C. Brown, Ph.D.
#     Friday, December 11, 2020; 8:30 am–12:30 pm
########################################################

# Room 2: cleaning missing data (+ joining)
library(tidyverse)

# a slightly altered version of our student data file
test <- read_csv("student_data_missing.csv")
test

test_long <- test %>% 
  pivot_longer( # pivot it LONGER
    cols = starts_with("Q"), # every column that starts with Q (the questions)
    names_to = c("Question_Number", "Question_Type"), # TWO col names
    names_sep = "_", # so we have to tell it WHERE to split...
    values_to = "Score" # where do the values go? new col (default: 'value')
  )
test_long

test_long %>% 
  count(is.na(Score)) #good for checking whether data is NA

test_long %>% drop_na() #just drops NAs

test_long %>% 
  mutate(
    Score2 = replace_na(Score, 0) #replaces NAs with zero in Score
  )

#Merging data video 2
survey <- read_csv("r_survey.csv") 

test %>% pull(Student_ID)
survey %>% pull(Student_ID)

full_join(test, survey) #lucked out but is a bit sloppy
full_data <- full_join(test, survey, by=c("Student_ID", "Department"))
summary(full_data)

#Not sure what this does
inner_data <- inner_join(test, survey, by = c("Student_ID", "Department"))
inner_data %>% 
  summary()

full_data <- test %>% 
  drop_na()

setdiff(test,full_data)

