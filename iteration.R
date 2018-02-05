# 5 Feb 2017
# Iteration


# *********************

# Iteration in R

# Sometimes we need to repeat the same sequence of commands seeral times.
# Whenever you need to repeat the same action more than twice try to automate it and
# apply iteration.

# Loops in R

# 1. For loops
for (i in 1:5) {
  print(i)
}

# (i in 1:5): sequence
# {
#   print(i)
# }: body

# Calculating the number of characters in words
for (i in c("red", "blue", "yellow")) {
  print(nchar(i))
}

# R is a vectorised language and this is why we rarely use loops in R

nchar(c("red", "blue", "yellow"))

# 2. while loops

i = 1
# This is equivalent to i <- 1
while (i < 6) {
  print(i)
  i = i + 1
}

# (i < 6): condition
# {
#   print(i)
#   i = i + 1
# }: body
# i is a counter

# With while loops it is easy to write an infinite loop.
# Do not run:
# i = 1
# while (i < 6) {
#   print(i)
# }

# 3. repeat loops

i = 1
repeat {
  print(i)
  i = i + 1
  if (i > 5) break
}

# rarely used


# Exercises:

# 1. From here - http://www-math.bgsu.edu/~zirbel/programming/index.html
# Write some lines of code that will calculate the sum 1+2+3+...+300. 
# The idea is to create a variable that will store the current value of the sum.
# Set it to zero, then use a for loop that will run through the numbers 1, 2, 3, ... 
# and add each of these to the current sum.  After the for loop, output the value of the sum. 

# 2. Write some lines of code to calculate the sum 1·2+2·3+3·4+ ... + 249·250.

# 3. Write a program to calculate 10! ("10 factorial"), which is defined to be 10*9*8*7*6*5*4*3*2*1.

# 4. From here: http://maths-people.anu.edu.au/~johnm/courses/r/exercises/pdf/r-exercises.pdf
# (a) Create a for loop that, given a numeric vector, prints out one number per line,
# with its square and cube alongside.
# (b) Look up help(while). Show how to use a while loop to achieve the same result.
# (c) Show how to achieve the same result without the use of an explicit loop.

# The apply family of functions

# Many iterations in R can be done without explicit use of loops.

? apply

library(tidyverse)
W1 <- read_csv("exData/W1.csv")
W1mod <- W1 %>%
  mutate(heightcm = ifelse(a_hlht == 1 & a_hlhtf > 0, 
                           a_hlhtf*30.48 + a_hlhti*2.54,
                           ifelse(a_hlht == 2 & a_hlhtc > 0, 
                                  a_hlhtc, NA))) %>%
  mutate(weightkg = ifelse(a_hlwt == 1 & a_hlwts > 0, 
                           a_hlwts*6.35 + a_hlwtp*0.45,
                           ifelse(a_hlwt == 2 & a_hlwtk > 0, 
                                  a_hlwtk, NA))) %>%
  mutate(bmi = weightkg / (heightcm / 100)^2)

# We want to calculate the mean for three variables (height, weight, bmi)

# 1. We can do this with summarise in dplyr

W1mod %>%
  summarise(
    meanHeight = mean(heightcm, na.rm = TRUE),
    meanWeight = mean(weightkg, na.rm = TRUE),
    meanBMI = mean(bmi, na.rm = TRUE)
  )

# 2. We could use a for loop

attach(W1mod)
for (i in c("heightcm", "weightkg", "bmi")) {
  # Note the use of get. It gets an object given an object name.
  y <- get(i)
  print(mean(y, na.rm = TRUE))
}

# 3. We can also use apply.

colnames(W1mod)
apply(W1mod[, 20:22], 2, mean, na.rm = TRUE)
# 
# Another example: calculate the sum of all variables by row
# (doesn't make any sense here, but we're interested in technical implementation)

apply(W1mod, 1, sum, na.rm = TRUE)


# tapply applies a function to a vector split by the values of a factor (or several factors)
? tapply

# This is a code from last class:

W1mod %>%
  mutate(bmiover30 = ifelse(bmi > 30, 1, 0)) %>%
  mutate(agegr = ifelse(a_dvage >= 18 & a_dvage <= 35, 1,
                        ifelse((a_dvage >= 36 & a_dvage <= 55), 2,
                               ifelse(a_dvage >= 56, 3, NA)))) %>%
  filter(!is.na(agegr)) %>%
  group_by(a_sex, agegr) %>%
  summarise(
    meanBMI = mean(bmi, na.rm=TRUE), 
    medianBMI = median(bmi, na.rm=TRUE), 
    proportion = mean(bmiover30, na.rm=TRUE)
  )

# Using tapply

W1mod2 <- W1mod %>%
  mutate(bmiover30 = ifelse(bmi > 30, 1, 0)) %>%
  mutate(agegr = factor(ifelse(a_dvage >= 18 & a_dvage <= 35, 1,
                        ifelse((a_dvage >= 36 & a_dvage <= 55), 2,
                               ifelse(a_dvage >= 56, 3, NA)))))  %>%
  mutate(sex = factor(a_sex)) %>%
  filter(!is.na(agegr))

tapply(W1mod2$bmiover30, list(W1mod2$sex, W1mod2$agegr), mean, na.rm = TRUE)

# Exercise. Write a for loop replicating these results.
# You will need to loop over the values of sex and agegr at the same time,
# so you will need to use a nested loop.

# Here is an example of a nested loop.

for (i in 1:3) {
  for (j in 3:1) {
    cat(i, j, "\n")
  }  
}


# Other functions in the apply family:
? lapply
# Returns a list

ourList <- list(
  a = c("yellow", "red", "green"),
  b = 1:10,
  c = factor(c(rep("male", 5), rep("female", 5)))
)

ourList

# Calculate the length of each element of ourList
lapply(ourList, length)

# Note that
length(ourList)
# returns a different result

class(lapply(ourList, length))

# If we want to return the result as a vector:

sapply(ourList, length)
class(sapply(ourList, length))

? vapply
? mapply
? rapply
? eapply

# The purrr package (part of tidyverse) has map() and walk() functions that
# do the same job as the apply() family.

# For example:
map_int(ourList, length)

# I never use them (but maybe I should start).

# Yet another way is to use functions. More on this later in the course.


# Exercises

# Exercise 1. (from here -- 
#              http://bioinformatics.nki.nl/courses/Rstat_12_I/texts/resources/exercises_apply_LP121206.pdf)


# Let's create a 5x5 matrix with values drawn from a normal distribution
mat <- matrix(NA, ncol=5, nrow=5)
for(i in 1:ncol(mat)) {
  mat[,i] <- rnorm(5)
  }
mat

# a) Use apply to calculate the standard deviation of the columns of the matrix.
# b) Use apply to calculate the maximum value in each of the rows of the matrix.

# Exercise 2.
# For each age (not age group) in W1mod find maximum BMI and write the BMIs
# into a vector.
# 
# First do this using apply() family of functions and then using summarise()
#  in dplyr

# Exercise 3. 

# Create 1000 vectors of random length in the range from 1 to 100 that have values from the
# standard normal distribution. Put them into a list. For each vector calculate the mean
# and return the results as a) a list, b) a vector.

# Note that when indexing a list you need to use double square brackets: [[]]

# Create a scatter plot showing how the mean is associated with the sample size


# **************************

# Next class (Monday 12 February)
# Read ch. 13 Relational data - http://r4ds.had.co.nz/relational-data.html
# Do the exercises.
# This corresponds to the following DataCamp course - 
#   https://www.datacamp.com/courses/joining-data-in-r-with-dplyr





