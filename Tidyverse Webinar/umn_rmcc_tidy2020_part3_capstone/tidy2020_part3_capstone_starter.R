########################################################
# Into the Mud: Data Wrangling with R and the Tidyverse
#    Jeffrey K. Bye, Ph.D. & Ethan C. Brown, Ph.D.
#     Friday, December 11, 2020; 8:30 am–12:30 pm
########################################################

# CAPSTONE: Tidying Messy Data

library(tidyverse)

# This challenge involves a messy data set 
# from Kaggle: https://www.kaggle.com/tmdb/tmdb-movie-metadata
#   (generated from TMDb API (tmbd.com))
# (we've selected just part of the original data set)



# PART 1A -----------------------------------------------------------------

## Complete this only if you did ROOM 1 (aggregate data)
# (If not, skip to the next section)

# Challenge: load all .csv files in Part1_Aggregate folder into one dataframe
#   You can either use the manual approach or use the advanced map_dfr function
#   Note that not all files in the folder are .csv!

# Save the aggregated data into a data.frame called movies



# PART 1B -----------------------------------------------------------------

## Complete this if you skipped Part 1A
# run this line of code:
movies <- read_csv("movies.csv")


# PART 1C -----------------------------------------------------------------

## Complete this regardless of whether you did 1A or 1B

# Let's practice filtering and selecting!

# Challenge A: filter only the movies with Comedy as genre
colnames(movies)
movies %>% 
  filter(genre == "Comedy")
# Challenge B: filter the Comedy movies with budget > $100,000,000
movies %>% 
  filter(genre == "Comedy", budget > 100000000)
# Challenge C: select the revenue for Comedy movies w/ budget > 100million
movies %>% 
  filter(genre == "Comedy", budget > 100000000) %>% 
  select(revenue)

# PART 2 ------------------------------------------------------------------

## Complete this only if you did ROOM 2 (missing data)
# (If not, skip to the next section)

# Challenge A: check how many NA values there are in each column
column_names <- colnames(movies)
movies %>% 
  count(is.na(genre)) #couldn't figure out how do to this for each column

# Challenge B: create a new data set without the movies that have NAs 
movies_clean <- movies %>% 
  drop_na()

# Challenge C: run the line of code below:
summary(movies)
# What are the minimum values in revenue and budget? Are they plausible?
movies %>% 
  min()
# Come up with a plausible minimum value that would be true (not a coding error)


# Challenge D: filter out the rows that have revenue or budget below the 
#   minimum you came up with in Challenge C



# PART 3 ------------------------------------------------------------------

## Complete this only if you did ROOM 3 (recoding)
# (If not, skip to the next section)

# Challenge A: let's flex our mutation muscles --
#   Calculate a new variable: the budget per minute of screentime
movies_clean %>% 
  mutate(
    BudgetPerScreen = budget/runtime
  )

# Challenge B: run the following code:
movies %>% 
  distinct(genre) %>% 
  pull()
# this gives us all the unique (distinct) values of Genre

# Challenge C: Recode 'Science Fiction' and 'Fantasy' to "SF-F"
movies <- movies %>% 
  mutate(
    genre2 = recode(genre, Fantasy = "SF-F", 'Science Fiction' = "SF-F"),
   )

#doing the same thing but with case_when
movies <- movies %>% 
  mutate(
    genre3 = case_when( #when genre is Sci Fi or fantasy
      (genre %in% c("Fantasy", "Science Fiction")
      ) ~ "SF-F", #set it to SF-F
    T ~ genre #deals with the NAs
  )
)

# Challenge D: run the line of code below:
summary(movies)
# What are the minimum values in revenue and budget? Are they plausible?
# Come up with a plausible minimum value that would be true (not a coding error)


# Challenge E (if you learned case_when): 
#   recode any revenue or budget values that are less than the
#     minimum you came up with in Challenge D (use case_when)



# PART 4 ------------------------------------------------------------------

## Complete this only if you did ROOM 4 (summarizing and grouping)


# Challenge A: calculate the mean and SD of budget for each level of genre


# Challenge B: calculate the mean and SD of revenue for each level of genre


# Challenge C: calculate the mean and SD of runtime for each level of genre


# Challenge D: calculate the mean and SD of runtime for each level of 
#     genre AND original_language (the combination)


# Challenge E: calculate the standard error of budget for each level of genre



# PART N ------------------------------------------------------------------

# finished the parts corresponding to your breakout rooms earlier?
#   feel free to go back to rooms you missed!
#   (then come back to the capstone if you have time)

  