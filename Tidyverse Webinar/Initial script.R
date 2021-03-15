library(tidyverse)

#Challenge 1: Practice with Piping
#In your own R console, round the square root of 20 to the nearest 1 decimal place, using piping.
20 %>% sqrt() %>% round(1)
20 %>% sqrt() %>% round(.,1)

starwars %>% pull(height) #pulls as an array
starwars %>% select(height) #similar to pull but preserves column status, 
  #still 2D but just with only 1 column. Good for selecting more than one column
starwars %>% select(name,height,mass) #selects columns in the order specified

#Challenge 2: Practice Selecting
midwest %>% pull(state)
midwest %>% select(state)

#Challenge 3: Putting it all together with filtering
midwest %>% 
  filter(state == "WI") %>% #filter data to only WI
  select(county, popdensity) %>% #grab county and population density
  filter(popdensity > 2000) %>% #within WI, find pop density above 2000
  pull(county) #Output county names from WI w/pop density > 2000

#The same thing but without tidyverse - terrible!
pull(filter(select(filter(.data = midwest, state == "WI"), county, popdensity), popdensity >2000), county)
