########################################################
# Into the Mud: Data Wrangling with R and the Tidyverse
#    Jeffrey K. Bye, Ph.D. & Ethan C. Brown, Ph.D.
#     Friday, December 11, 2020; 8:30 am–12:30 pm
########################################################

# Room 2: cleaning missing data (+ joining)
library(tidyverse)

#   Demo: student test, drop NA rows, drop NA ppts, merge with survey
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

# find out how many NAs
test_long %>% 
  count(is.na(Score))

# drop from analysis
test_long2 <- test_long %>% 
  drop_na()
test_long2 # fewer rows now
test_long2 %>% # confirm
  count(is.na(Score))

# what about replacing NAs?
test_long %>% 
  mutate(
    Score2 = replace_na(Score, 0)
  )

## joining & missing data across sources

# let's load the survey data
survey <- read_csv("r_survey.csv")

# now, if we think about it, it doesn't make sense to merge the long versions
#   this is because it would break our sense of 1 var per column

# if we're merging survey and test scores, now the 'level'/'scope' of an observation
#   is at the individual student

# how do we merge?
test %>% 
  pull(Student_ID) # 11 students
survey %>% 
  pull(Student_ID) # 20 students

# do we want everyone?
full_join(test, survey) # it's going to try to match by common col names

# it's better and safer to be explicit
full_join(test, survey, by = "Student_ID") # oops, two versions of Department now
full_join(test, survey, by = c("Student_ID", "Department"))
# generates NAs everywhere missing!
full_data <- full_join(test, survey, by = c("Student_ID", "Department"))

summary(full_data) # lots of NAs
# could drop
full_data %>% 
  drop_na() # but this will also drop Ss with 'real' NAs

# so we can use inner_join which just matches participants in both data sets
inner_data <- inner_join(test, survey, by = c("Student_ID", "Department"))
summary(inner_data)
