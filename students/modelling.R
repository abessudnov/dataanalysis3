# Modelling with longitudinal data.
# 26 March 2018
# 

# Let's open the data first.

library(tidyverse)
library(data.table)

UndSoc <- read_tsv("myData/all7new.tab") 

# vote6 is interest in politics measured on a 4-point scale

table(UndSoc$vote6)
class(UndSoc$vote6)

# Let's recode it back to numeric

UndSoc <- UndSoc %>%
  mutate(polinterest = recode(vote6, 
                              "very" = "4", "fairly" = "3",
                              "not very" = "2", "not al all" = "1")) %>%
  mutate(polinterest = as.numeric(polinterest))

table(UndSoc$polinterest)

# How can we model the association between sex, age and political interest?

# It's a good idea to start from cross-sectional analysis

wave1 <- UndSoc %>%
  filter(wave == "a") %>%
  filter(!is.na(dvage))

# You always start with visualisations

# polinterest is an ordinal variable so strictly speaking it's not quite appropriate to
# calculate its mean. It may violate some statistical assumptions, but it is useful.

wave1 %>%
  ggplot(aes(x = dvage, y = polinterest)) +
  geom_smooth()

# The association seems to be non-linear

# fitting a regression line

wave1 %>%
  ggplot(aes(x = dvage, y = polinterest)) +
  geom_smooth() +
  geom_smooth(method = "lm")

# Sex

wave1 %>%
  ggplot(aes(x = sex, y = polinterest)) +
  geom_bar(stat = "summary", fun.y = "mean")
  

# Now let's do a linear regression now?

m1 <- lm(polinterest ~ sex + dvage, wave1)
summary(m1)

# Can we model non-linearity?

m2 <- lm(polinterest ~ sex + dvage + I(dvage^2), wave1)
summary(m2)

# But is this really necessary?
# 
# Checking the assumptions?
# Is R-squared important>?
#   

# Can we fit an interaction effect and check if the association is different for men and women?


wave1 %>%
  ggplot(aes(x = dvage, y = polinterest, colour = sex)) +
  geom_smooth()

# It doesn't look like interaction is important, but we can check this formally

m3 <- lm(polinterest ~ sex * dvage, wave1)
summary(m3)

wave1 %>%
  ggplot(aes(x = dvage, y = polinterest, colour = sex)) +
  geom_smooth(method = "lm")

# Producing the regression tables with multiple models.

# If you knit in pdf or html you can use stargazer. stargazer will not work with Word.

library(stargazer)
stargazer(m1, m2, m3)

stargazer(m1, m2, m3, type = "text")

# If you use stargazer with pdf make sure that your R chunk where you do this has an option
# results = 'asis'.


# library(memisc)
# regtable <- mtable("model 1" = m1, "model 2" = m2, "model 3" = m3,
#                    summary.stats = c('R-squared', 'N'))
# regtable


# Longitudinal modelling

# What if we want to know how political interest changes with age?

# We can use fixed-effects models

UndSoc10000 <- UndSoc[1:10000,]

m4 <- lm(polinterest ~ dvage + as.factor(pidp), data = UndSoc10000)
summary(m4)

# same as

library(plm)

m5 <- plm(polinterest ~ dvage, data = UndSoc10000, model = "within", index = c("pidp", "wave"))
summary(m5)

# For time-constant variables you can check if the trends are similar over time by group

UndSoc %>%
  filter(!is.na(sex)) %>%
  group_by(sex, wave) %>%
  summarise(
    meanPI = mean(polinterest, na.rm = TRUE)
  ) %>%
  ggplot(aes(x = wave, y = meanPI, group = sex)) +
  geom_point() + 
  geom_line()

# We can test this formally

m6 <- lm(polinterest ~ sex + wave, UndSoc)
summary(m6)

# Fitting a linear trend
# Let's convert wave to year

UndSoc <- UndSoc %>%
  mutate(year = dplyr::recode(wave, "a" = "2009",
                       "b" = "2010",
                       "c" = "2011",
                       "d" = "2012",
                       "e" = "2013",
                       "f" = "2014",
                       "g" = "2015")) %>%
  mutate(year = as.numeric(year))

m7 <- lm(polinterest ~ sex + year, UndSoc)
summary(m7)

m8 <- lm(polinterest ~ sex * as.factor(year), UndSoc)
summary(m8)




