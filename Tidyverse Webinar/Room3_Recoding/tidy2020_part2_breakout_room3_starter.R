########################################################
# Into the Mud: Data Wrangling with R and the Tidyverse
#    Jeffrey K. Bye, Ph.D. & Ethan C. Brown, Ph.D.
#     Friday, December 11, 2020; 8:30 am–12:30 pm
########################################################

# Room 3: recoding variables, including binning (e.g., strongly agree + agree)
library(tidyverse)
survey <- read_csv("r_survey.csv")

# Let's first pivot long only (not wide again)
#   The reason is that this will allow us to do all recoding in one column
#   Then we can pivot wide later
survey_long <- survey %>% 
  pivot_longer(
    cols = starts_with("P"), # pivot the columns that start with P (pre/post)
    names_to = c("Time", "Question"), # separate columns
    names_sep = "_", # separate at the _
    values_to = "Rating" # values into the Rating column
  ) 

survey_long %>% 
  mutate(
    new_col = Student_ID -1
  )
survey_long2 <- survey_long %>% #allows for breadcrumming
  mutate(
    Rating2 = tolower(Rating)
  )
survey_long2 %>% count(Rating2)

#Challenge 1
survey_long2 %>% 
  mutate(
    Department2 = toupper(Department)
  )

#Manual recoding
survey_long3 <- survey_long2 %>% 
  mutate(
    Rating3 = recode(Rating2, d = "disagree", #old = "new"
                     disagre = "disagree"),
    Rating3 = recode(Rating3, agre = "agree")
  )
survey_long3 %>% count(Rating3)

survey_long_bin <- survey_long3 %>% 
  mutate(
    RatingBin = case_when( #if either strongly agree or agree, then replace with agree
      Rating3 %in% c("stronglyagree", "agree") ~ "Agree", #If true, replace strongly agree with agree
      Rating3 %in% c("stronglydisagree", "disagree") ~ "Disagree" 
    )
  )
survey_long_bin %>% 
  count(RatingBin, Rating3)

#Challenge 3
unique(survey_long3$Department)

survey_long3 %>% 
  mutate( #didn't finish this but felt comfortable w/the general idea
    Campus = case_when(
      Department %in% c("C&I", "EdPsych", "ChildDev", "Kinesiology", "")
      Department %in% c("FamSocSci")
    )
  )