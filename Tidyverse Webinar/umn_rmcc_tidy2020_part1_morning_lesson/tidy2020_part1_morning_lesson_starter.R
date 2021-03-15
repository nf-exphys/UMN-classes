########################################################
# Into the Mud: Data Wrangling with R and the Tidyverse
#    Jeffrey K. Bye, Ph.D. & Ethan C. Brown, Ph.D.
#     Friday, December 11, 2020; 8:30 am–12:30 pm
########################################################

# 09:00 - 09:30 Morning Zoom synchronous -- 30 minute lecture

## OPEN PROJECT, OPEN FILE
# Notice the handy .csv file

# load tidyverse!
library(tidyverse)

# Read in data
test <- read_csv("student_data.csv")
# a benefit of RProjects is that if we keep everything in the same folder,
#   R can find the file *relative* to where the .RProj file is sitting
#   (i.e., inside its own folder)

# Examine data:
#   Note: this is completely fictional, random data
#     With the 'theme' that it's CEHD people answer test Qs about R
summary(test) # summarize
str(test) # structure

test
# oh no -- this data isn't tidy!

test %>% 
  pivot_longer(
    cols =c(Q1_MultipleChoice, Q2_MultipleChoice, 
            Q3_ShortAnswer, Q4_ShortAnswer),  #list columns to go from wide to long
    names_to = "Question", #moves score to one variable, with Q1-4 as a separate column
    values_to = "Score"
  )

test %>% 
  pivot_longer(
    cols = -Student_ID, #same as above but cleaner than listing all column names
    names_to = "Question", 
    values_to = "Score"
  )

test_long <- test %>% #keeping original data and saving new data like this is known as "breadcrumming"
  pivot_longer(
    cols = starts_with("Q"), #finds all columns that start with letter Q
    names_to = "Question", #moves score to one variable, with Q1-4 as a separate column
    values_to = "Score"
  )

test_long %>% 
  separate(
    col = Question,
    into = c("Question_Number", "Question_Type"),
    sep = "_"
  )

#Doing all of this using pivot_longer
test_long2 <- test %>% 
  pivot_longer(
    cols = starts_with("Q"), #finds all columns that start with letter Q
    names_to = c("Question_Number", "Question_Type"), #defines where to put new columns 
    values_to = "Score", #defines where to put values that were in each of these columns
    names_sep = "_" #where do I separate at?
  )

test_long2 %>% write_csv("test_long.csv")

survey <- read_csv("r_survey.csv")
survey #we have 2 measures at pre and 2 measures at post

survey_longish <- survey %>% 
  pivot_longer(
    cols = starts_with("P"),
    names_to = c("Time", "Question"),
    names_sep = "_",
    values_to = "Rating" #generally, new column name needs quotes, existing column names don't need quotes
  ) %>% 
  pivot_wider( #gives us a partially long format, may be useful for some analyses
    names_from = Question,
    values_from = Rating
  )
survey_longish %>% write_csv("survey_longish.csv")
#FYI: pivot longer is the successor to gather and reshape/melt