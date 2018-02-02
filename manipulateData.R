# 2 Feb 2018

# W1 is a data frame from the Understanding Society wave 1 with only a few selected variables

library(tidyverse)

# 1. Read W1 into R (it's a csv file). Explore the contents of the data using the data dictionary.

W1 <- read_csv("exData/W1.csv")
head(W1, 5)

# 2. What is a pipe operator (%>%) and how to use it

# %>%

table(W1$a_vote1)
prop.table(table(W1$a_vote1))

W1$a_vote1 %>%
  table() %>%
  prop.table()

# 3. Selecting variables: select()
# Exercise: only select the variables for id and measures of weight and height and save the result
# as a new data frame.

new <- W1 %>%
  select(pidp, a_hlht:a_hlwtk)
head(new)

# How can we do this in base R?
new2 <- subset(W1, select = c("pidp", "a_hlht"))
names(W1)

new3 <- W1[, c(1, 6:13)]

# 4. Selecting cases: filter()
# a) Select only women aged 18 to 25

W1 %>%
  filter(a_sex == 2 & a_dvage >= 18 & a_dvage <=25) %>%
  head(5)

# b) select only people born in Wales or Northern Ireland and aged over 40

W1 %>%
  filter((a_ukborn == 3 | a_ukborn == 4) & a_dvage > 40) %>%
  head(2)

# 5. Creating new variables: mutate()
# a) create a new dummy variable that takes a value 1 if a person was born in Scotland
# and 0 otherwise

new4 <- W1 %>%
  mutate(scotland = ifelse(a_ukborn == 2, 1, 0))
table(new4$scotland, new4$a_ukborn)

# More complicated case: create two (cleaned) variables for people's height in cm
# and weight in kg. (You can use dplyr or base R).
? if_else
? ifelse

# Create a variable for body mass index.

# 1 feet = 30.48cm
# 1 inch = 2.54cm
# 
# 1 stone = 6.35029318 kg
# 1 pound = 0.45359237 kg

# bmi = kg / m^2

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

hist(W1mod$heightcm)
hist(W1mod$weightkg)
hist(W1mod$bmi)


# 6. Sorting cases: arrange()
# a) Arrange cases in the descending order by age

W1 %>%
  arrange(desc(a_dvage))

W1 %>%
  arrange(a_sex, desc(a_dvage)) %>%
  head(10)

# 7. Summarising data: summarise()

# a) Use summarise to find mean and median BMI and the proportion of people
# with BMI > 30 in the sample of people aged 25 to 55.
W1mod %>%
  filter(a_dvage >= 25 & a_dvage <= 55) %>%
  mutate(bmiover30 = ifelse(bmi > 30, 1, 0)) %>%
  summarise(
    meanBMI = mean(bmi, na.rm=TRUE), 
    medianBMI = median(bmi, na.rm=TRUE), 
    proportion = mean(bmiover30, na.rm=TRUE)
    )

# 8. Producing summary statistics by group:
# group_by() and summarise()

# Group the same by sex and age ("young": 18-35, "middle-aged": 36-55, "older": >55)
# and produce mean and median BMI and the proportion of people with BMI over 30 in each group.
# 

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

# Window functions in dplyr:
#   https://cran.r-project.org/web/packages/dplyr/vignettes/window-functions.html




# *********************

# Iteration in R


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

# **************************

# Next class (Monday 5 February)
# Read ch. 13 Relational data - http://r4ds.had.co.nz/relational-data.html
# Do the exercises.
# This corresponds to the following DataCamp course - 
#   https://www.datacamp.com/courses/joining-data-in-r-with-dplyr




