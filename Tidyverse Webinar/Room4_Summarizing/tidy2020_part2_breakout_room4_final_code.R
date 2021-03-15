########################################################
# Into the Mud: Data Wrangling with R and the Tidyverse
#    Jeffrey K. Bye, Ph.D. & Ethan C. Brown, Ph.D.
#     Friday, December 11, 2020; 8:30 am–12:30 pm
########################################################

# 09:30 – 10:30 Choose Your Own Adventure (asynchronous videos + breakout room discussion)

# Room 4: grouping and summarizing

# similar code to earlier, slightly new data
test <- read_csv("umn_rmcc_tidy2020_part2_breakout_rooms/Room4_Summarizing/student_data_grouping.csv")
test # notice new column
test_long <- test %>% # and then...
  pivot_longer( # pivot it LONGER
    # cols = -Student_ID, # every column EXCEPT Student_ID
    # cols = -c(Student_ID, Workshop), # one way
    cols = starts_with("Q"), # another way
    names_to = c("Question_Number", "Question_Type"), # TWO col names
    names_sep = "_", # so we have to tell it WHERE to split...
    values_to = "Score" # where do the values go? new col (default: 'value')
  )
test_long

# what if we want to compare across the 2 levels of Question Type?
# we use group_by to group... by... the given variable!

test_long %>% # take test_long and...
  group_by(Question_Type) # group by Question_Type!
# but... nothing changes in output...
# (except at the top it says Groups:   Question_Type [2])

# that's because group_by is grouping the data internally,
#   but it's not really visible until we do *something else* with it

# for example, we quite often group and then SUMMARIZE with descriptive stats
test_long %>% 
  group_by(Question_Type) %>% 
  summarize( # summarize by...
    mean(Score) # finding the mean score!
  )
# oops, we get NAs because R is conservative with missing data...
#   if you give NAs into a function like mean(), it will give you NAs back
#   it wants you to be explicit about what you want to do with NAs!

test_long %>% 
  group_by(Question_Type) %>% 
  summarize(
    mean(Score, na.rm = TRUE) # tell R to remove (rm) NAs in the mean
  )
# yay means!
# notice that the output column name above is messy though
# we can provide a column name to the left-hand side of an equals sign:
test_long %>% 
  group_by(Question_Type) %>% 
  summarize(
    Mean_Score = mean(Score, na.rm = TRUE) # name the column Mean_Score
  )

# what about means for the 2 levels of Workshops?
test_long %>% 
  group_by(Workshops) %>% # we just change the grouping variable!
  summarize(
    Mean_Score = mean(Score, na.rm = TRUE) 
  )
# yay R power!

# can we do other stats?
test_long %>% 
  group_by(Workshops) %>% 
  summarize(
    Mean_Score = mean(Score, na.rm = TRUE),
    SD_Score = sd(Score, na.rm = TRUE),
    n = n(), # how many values (including NAs, which we often don't want!)
    n_obs = sum(!is.na(Score)) # sum up all scores NOT (!) equal to NA (is.na)
    # remember: is.na(Score) returns TRUE values for NAs, FALSE for observed data
    #   so we *negate* that with the ! operator to get TRUEs for observed data
    #   then we sum that (because sum() essentially counts the number of TRUEs
    #     because TRUE has a numeric value of 1 and FALSE is 0)
  )


# what about the cells (2x2) for Workshop and Question_Type together?
test_long %>% 
  group_by(Workshop, Question_Type) %>% # whichever we put first is grouped first
  summarize(
    Mean_Score = mean(Score, na.rm = TRUE),
    SD_Score = sd(Score, na.rm = TRUE),
    n = sum(!is.na(Score))
  ) 
# notice workshop alternates 'slowly' while question type alternates within workshop

