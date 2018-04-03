#DPLR exercises 

install.packages("nycflights13")
library("nycflights13")
library("tidyverse")

glimpse(flights)

#Chapter 5 - Data tranformation exercises

########################## FILTER ##########################

#1. Find all flights that

##Had an arrival delay of two or more hours

flights %>% 
  filter(arr_delay > 120)
#10,024

##Flew to Houston (IAH or HOU)

flights %>%
  filter(dest %in% c("IAH", "HOU"))
#9,313

##Were operated by United, American, or Delta

airlines
#16

filter(flights, carrier %in% c("AA", "DL", "UA"))

##Departed in summer (July, August, and September)

filter(flights, between(month, 7, 9))
#86,316

##Arrived more than two hours late, but didn’t leave late

filter(flights, !is.na(dep_delay), dep_delay <= 0, arr_delay > 120)
#19

##Were delayed by at least an hour, but made up over 30 minutes in flight

filter(flights, !is.na(dep_delay), dep_delay >= 60, dep_delay-arr_delay > 30)
#1,834

##Departed between midnight and 6am (inclusive)

filter(flights, dep_time <=600 | dep_time == 2400)
#9,363


#2. Another useful dplyr filtering helper is between(). 

#What does it do? Can you use it to simplify the code needed to answer the previous challenges?

#This can be used to make your code shorter and more efficient; 
#between(x, left, right) is equivalent to x >= left & x <= right

#E.G. - filter(flights, between(month, 7, 9))

#3. How many flights have a missing dep_time? 

#What other variables are missing? 
#What might these rows represent?

filter(flights, is.na(dep_time))

#8,255

#sched_dep_time, dep_delay and arr_time
#arr_time missing may signify that these flights were cancelled

########################## ARRANGE ##########################

#1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).

#This sorts by increasing dep_time, but with all missing values put first.

arrange(flights, desc(is.na(dep_time)), dep_time)

#2. Sort flights to find the most delayed flights. Find the flights that left earliest.

#The most delayed flights are found by sorting by dep_delay in descending order.

arrange(flights, desc(dep_delay))

#If we sort dep_delay in ascending order, we get those that left earliest. 
#There was a flight that left 43 minutes early.

arrange(flights, dep_delay)

#3. Sort flights to find the fastest flights.

#I assume that by by “fastest flights” it means the flights with the minimum air time. 
#So I sort by air_time the fastest flights. 
#The fastest flights area couple of flights between EWR and BDL with an air time of 20 minutes.

arrange(flights, air_time)

#4. Which flights traveled the longest? Which traveled the shortest?

#I’ll assume hat traveled the longest or shortest refers to distance, rather than air-time.
#The longest flights are the Hawaii Air (HA 51) between JFK and HNL (Honolulu) at 4,983 miles.

arrange(flights, desc(distance))

#Apart from an EWR to LGA flight that was canceled, the shortest flights are the Envoy Air Flights between EWR and PHL at 80 miles.

arrange(flights, distance)

## BONUS ##

#1. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.

select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, starts_with("dep_"), starts_with("arr_"))
select(flights, matches("^(dep|arr)_(time|delay)$"))

#2. What happens if you include the name of a variable multiple times in a select() call?

#It ignores the duplicates, and that variable is only included once. No error, warning, or message is emitted.

select(flights, year, month, day, year, year)

#3. What does the one_of() function do? Why might it be helpful in conjunction with this vector?

#The one_of vector allows you to select variables with a character vector rather than as unquoted variable names. 
#It’s useful because then you can easily pass vectors to select().

vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))

#4. Does the result of running the following code surprise you? 
#How do the select helpers deal with case by default? 
#How can you change that default?

select(flights, contains("TIME"))

#The default behavior for contains is to ignore case. Yes, it surprises me. 
#Upon reflection, I realized that this is likely the default behavior because dplyr is designed to deal with a variety of data backends, and some database engines don’t differentiate case.
#To change the behavior add the argument ignore.case = FALSE. Now no variables are selected.

select(flights, contains("TIME", ignore.case = FALSE))

########################## MUTATE ##########################

#1. Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they’re not really continuous numbers. 
#Convert them to a more convenient representation of number of minutes since midnight.

#To get the departure times in the number of minutes (integer) 
##divide dep_time by 100 to get the hours since midnight 
#and multiply by 60 and add the remainder of dep_time divided by 100.

mutate(flights,
       dep_time_mins = dep_time %/% 100 * 60 + dep_time %% 100,
       sched_dep_time_mins = sched_dep_time %/% 100 * 60 + sched_dep_time %% 100) %>%
  select(dep_time, dep_time_mins, sched_dep_time, sched_dep_time_mins)

## This would be more cleanly done by first defining a function and reusing that:

time2mins <- function(x) {
  x %/% 100 * 60 + x %% 100
}
mutate(flights,
       dep_time_mins = time2mins(dep_time),
       sched_dep_time_mins = time2mins(sched_dep_time)) %>%
  select(dep_time, dep_time_mins, sched_dep_time, sched_dep_time_mins)

#2. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?

#Since arr_time and dep_time may be in different time zones, the air_time doesn’t equal the difference. 
#We would need to account for time-zones in these calculations.

mutate(flights,
       air_time2 = arr_time - dep_time,
       air_time_diff = air_time2 - air_time) %>%
  filter(air_time_diff != 0) %>%
  select(air_time, air_time2, dep_time, arr_time, dest)

#3. Compare dep_time, sched_dep_time, and dep_delay. 
#How would you expect those three numbers to be related?

#I’d expect dep_time, sched_dep_time, and dep_delay to be related so that dep_time - sched_dep_time = dep_delay.

mutate(flights,
       dep_delay2 = time2mins(dep_time) - time2mins(sched_dep_time)) %>%
  filter(dep_delay2 != dep_delay) %>%
  select(dep_time, sched_dep_time, dep_delay, dep_delay2)

#4. Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().

#I’d want to handle ties by taking the minimum of tied values. 
#If three flights are have the same value and are the most delayed, we would say they are tied for first, not tied for third or second.

mutate(flights,
       dep_delay_rank = min_rank(-dep_delay)) %>%
  arrange(dep_delay_rank) %>% 
  filter(dep_delay_rank <= 10)

#5. What does 1:3 + 1:10 return? Why?

1:3 + 1:10
 
#It returns c(1 + 1, 2 + 2, 3 + 3, 1 + 4, 2 + 5, 3 + 6, 1 + 7, 2 + 8, 3 + 9, 1 + 10). 
#When adding two vectors recycles the shorter vector’s values to get vectors of the same length. 
#We get a warning vector since the shorter vector is not a multiple of the longer one (this often, but not necessarily, means we made an error somewhere).

#more - https://jrnold.github.io/r4ds-exercise-solutions/data-transformation.html#grouped-summaries-with-summarise