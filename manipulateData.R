# 2 Feb 2018

# W1 is a data frame from the Understanding Society wave 1 with only a few selected variables

library(tidyverse)

# 1. Read W1 into R (it's a csv file). Explore the contents of the data using the data dictionary.

# 2. What is a pipe operator (%) and how to use it

# 3. Selecting variables: select()
# Exercise: only select the variables for id and measures of weight and height and save the result
# as a new data frame.
# How can we do this in base R?

# 4. Selecting cases: filter()
# a) Select only women aged 18 to 25
# b) select only people born in Wales or Northern Ireland and aged over 40

# 5. Creating new variables: mutate()
# a) create a new dummy variable that takes a value 1 if a person was born in Scotland
# and 0 otherwise

# More complicated case: create two (cleaned) variables for people's height in cm
# and weight in kg. (You can use dplyr or base R).
? if_else
? ifelse

# Create a variable for body mass index.

# 6. Sorting cases: arrange()
# a) Arrange cases in the descending order by age

# 7. Summarising data: summarise()

# a) Use summarise to find mean and median BMI and the proportion of people
# with BMI > 30 in the sample of people aged 25 to 55.

# 8. Producing summary statistics by group:
# group_by() and summarise()

# Group the same by sex and age ("young": 18-35, "middle-aged": 36-55, "older": >55)
# and produce mean and median BMI and the proportion of people with BMI over 30 in each group.
# 
# Window functions in dplyr:
#   https://cran.r-project.org/web/packages/dplyr/vignettes/window-functions.html

# *********************

# Iteration in R


# **************************

# Next class (Monday 5 February)
# Read ch. 13 Relational data - http://r4ds.had.co.nz/relational-data.html
# Do the exercises
# This corresponds to the following DataCamp course - 
#   https://www.datacamp.com/courses/joining-data-in-r-with-dplyr







