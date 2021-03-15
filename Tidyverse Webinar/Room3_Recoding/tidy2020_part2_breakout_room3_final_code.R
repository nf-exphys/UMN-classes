########################################################
# Into the Mud: Data Wrangling with R and the Tidyverse
#    Jeffrey K. Bye, Ph.D. & Ethan C. Brown, Ph.D.
#     Friday, December 11, 2020; 8:30 am–12:30 pm
########################################################

# 09:30 – 10:30 Choose Your Own Adventure (asynchronous videos + breakout room discussion)

# Room 3: recoding variables, including binning (e.g., strongly agree + agree)

# Starter code from Morning Lesson
survey <- read_csv("umn_rmcc_tidy2020_part1_morning_lesson/r_survey.csv")

# Let's first pivot long only (not wide again)
#   The reason is that this will allow us to do all recoding in one column
#   Then we can pivot wide later
survey_long <- survey %>% 
  pivot_longer(
    cols = -c(Student_ID, Department),
    names_to = c("Time", "Question"), # separate
    names_sep = "_",
    values_to = "Rating"
  ) 

# Whenever we're creating a new column or recoding an existing one,
#   we're likely using *mutate*
survey_long %>% 
  mutate(
    new_col = "R is so cool" # this will apply the same value throughout
  )

# you can also do math (in this case, silly math)
survey_long %>% 
  mutate(
    new_col = Student_ID - 1
  )


# Let's get a sense of the values:
survey_long %>% 
  count(Rating) # lots to do!

# we want to RECODE values... how?

# first, we can easily take care of the capitalization differences:
survey_long2 <- survey_long %>% 
  mutate(
    Rating2 = tolower(Rating) # take all Rating values and make them lowercase
  )

survey_long2 %>% 
  count(Rating2) # huzzah!
# this is great!
# but we can't fix everything so systematically

survey_long2 %>% 
  mutate(
    Rating3 = recode(Rating2, d = "disagree") # old = "New"
    # notice the default behavior leaves everything else the same!
  )

# let's do this for all values, and save it
survey_long3 <- survey_long2 %>% 
  mutate(
    Rating3 = recode(Rating2, d = "disagree",
                     disagre = "disagree",
                     agre = "agree") # old = "new"
  )

# wow!
survey_long3 %>% 
  count(Rating3)


# what if we wanted stronglyagree & agree to be binned together?
#   and likewise for stronglydisagree & disagree
# let's also assume this is something we planned to do and we aren't
#   just being cheeky with our data

survey_long3 %>% 
  mutate(
    RatingBin = case_when(
      # we can specify different cases (left of ~) and corresponding values (right of ~)
      (Rating3 == "stronglyagree") ~ "agree"
      # when the left-hand side returns TRUE (logical), that value gets set to agree
      # if the left-hand side returns FALSE, R will move to the next case listed
      # ...
      # since there are no more listed, default behavior is all NAs!
    )
  )

# if we want to keep values when unspecified (I forgot this part in video!)
survey_long3 %>% 
  mutate(
    RatingBin = case_when(
      (Rating3 == "stronglyagree") ~ "agree", # recode
      TRUE ~ Rating3 # this means everything else will stay the same as it is
      # (because the left-hand-side is always true! )
    )
  )

# save
survey_long_bin <- survey_long3 %>% 
  mutate(
    RatingBin = case_when(
      # we can also test whether Rating is IN a list of options
      # this is good for being explicit here:
      #   we want BOTH stronglyagree and agree => agree
      #   and BOTH stronglydisagree and disagree => disagree
      Rating3 %in% c("stronglyagree", "agree") ~ "agree", # recode all to agree
      Rating3 %in% c("stronglydisagree", "disagree") ~ "disagree" # recode all to disagree
    )
  )

survey_long_bin %>% 
  count(RatingBin) # yay!

