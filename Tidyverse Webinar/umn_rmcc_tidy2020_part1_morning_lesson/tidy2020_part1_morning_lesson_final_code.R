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

## TIDY DATA

# what is tidy data? https://blog.rstudio.com/2014/07/22/introducing-tidyr/
#   Each column is a variable
#   Each row is an observation

# Common 'untidy' problems
#   Column headers are values, not variable names.
#   Multiple variables are stored in one column.
#   Variables are stored in both rows and columns.
#   Multiple types of observational units are stored in the same table.
#   A single observational unit is stored in multiple tables.

# More reading: https://blog.rstudio.com/2020/05/05/wrangling-unruly-data/

# How many variables per column?
# There's actually THREE: question number, question type, and score
# For now, let's focus on just on the question as a whole (number + type)

# we want to take test...
test %>% # and then...
  pivot_longer( # pivot it LONGER
    # R needs to know HOW to pivot -- which cols?
    cols = c(Q1_MultipleChoice, Q2_MultipleChoice,
             Q3_ShortAnswer, Q4_ShortAnswer),
    names_to = "Question", # where do the column names go? new col
    values_to = "Score" # where do the values go? new col (default: 'value')
  )

# another way to specify the column:
test %>% 
  pivot_longer( 
    cols = -Student_ID, # every column EXCEPT (-) Student_ID
    names_to = "Question",
    values_to = "Score"
  )

# yet another way to specify the column:
test %>% 
  pivot_longer( 
    cols = starts_with("Q"), # every column whose name starts with Q
    names_to = "Question",
    values_to = "Score"
  )

# let's save our work!
test_long <- test %>% 
  pivot_longer( 
    cols = starts_with("Q"),
    names_to = "Question",
    values_to = "Score"
  )
# above we use a new variable name (test_long) because it allows us
#   to keep the original data frame (test) in case we still need it
#   these 'breadcrumbs' are helpful in case we need to retrace our data steps!


##

# what if we want to separate the Question Number vs. Type data though?
test_long %>% # we could use our already-long data frame
  separate( # and then SEPARATE...
    col = Question, # the Question column
    into = c("Question_Number", "Question_Type"), # into these names
    sep = "_" # here's *where* we separate
  )

## however, we could actually do this in the same 'move' as the original
#   pivot_longer() function, if we add some more inputs to specify how...

# we want to take test...
test %>% # and then...
  pivot_longer( # pivot it LONGER
    # R needs to know HOW to pivot -- which cols?
    cols = -Student_ID, # every column EXCEPT Student_ID
    names_to = c("Question_Number", "Question_Type"), # TWO col names
    names_sep = "_", # so we have to tell it WHERE to split...
    values_to = "Score" # where do the values go? new col (default: 'value')
  )

# best practice: save our data! this time let's use test_long2
test_long2 <- test %>% # and then...
  pivot_longer(
    cols = -Student_ID,
    names_to = c("Question_Number", "Question_Type"),
    names_sep = "_",
    values_to = "Score"
  )
# also best practice to output our data file for later!
test_long2 %>% 
  write_csv("test_long.csv")


#####

# Pivoting wide to ‘partially long’

# what makes an observation? well sometimes it's not clear
# that's ok! sometimes we 'zoom' in and out on our data
# so it's good to practice that flexibility
# what about when there's longitudinal data with multiple DVs per timepoint?
survey <- read_csv("r_survey.csv")

# Examine data:
#   Note: this is completely fictional, random data
#     With the 'theme' that it's CEHD people answering survey Qs about R
#     The departments are also randomly assigned 
summary(survey) # summarize
str(survey) # structure
survey

# so we want to pivot long? let's try pivoting everything
survey %>% 
  pivot_longer(
    cols = -c(Student_ID, Department), # pivot all cols except (-) these 2
    names_to = "Question"
  )

# let's split the time and question up into 2 columns, like we learned above
survey %>% 
  pivot_longer(
    cols = -c(Student_ID, Department),
    names_to = c("Time", "Question"), # separate
    names_sep = "_",
    values_to = "Rating"
  ) 

# ok but now we want to move the pre's on the same row, post's on same row
#   (this is somewhere between fully long and wide, 
#       we might call it 'partially long')
survey %>% 
  pivot_longer(
    cols = -c(Student_ID, Department),
    names_to = c("Time", "Question"), # separate
    names_sep = "_",
    values_to = "Rating"
  ) %>% # NOW PIVOT WIDER
  pivot_wider(
    names_from = Question, # new column names are in the Question col
    values_from = Rating # take the values from Rating, push them into new cols
  )

# and save our data!
survey_longish <- survey %>% 
  pivot_longer(
    cols = -c(Student_ID, Department),
    names_to = c("Time", "Question"),
    names_sep = "_",
    values_to = "Rating"
  ) %>% 
  pivot_wider(
    names_from = Question,
    values_from = Rating 
  )
survey_longish %>% 
  write_csv("survey_longish.csv")