# Reading the data from the Understanding Society survey
# 29 January 2017

# All the data (about 4Gb) must be downloaded from the UK Data Service website and stored
# in the data directory as a subdirectory called UKDA-6614-tab.

# Do not change the original data.

# For our purposes we mostly need the individual level data from adult questionnaires.
# These are the indresp files.

# Let's read into R the file from wave 1 (us_w1 directory).

# There are several ways of doing this in R.

# 1) Base R

? read.table

UndSoc1 <- read.table("data/UKDA-6614-tab/tab/us_w1/a_indresp.tab",
                      header = TRUE,
                      stringsAsFactors = FALSE)

# Question: What is the difference between read.table, read.csv, read.csv2,
#         read.delim and read.delim2?

# 2) We can also use the functions from the readr package. The main advantage
# is that it works faster which is helpful with large files.

library(readr)
? read_table
? read_tsv

UndSoc1 <- read_tsv("data/UKDA-6614-tab/tab/us_w1/a_indresp.tab")

# Exercises for reading the data in R.
# 1. There are several files in the exData folder. Read them into R in the following order:
# Table0.txt, Table3.txt, Table4.txt. states2.csv, tableExcel.xlsx.
# 
# Note that the last file is an Excel file and you cannot read it with read.table. You'll
# need to find out how to read Excel files into R. The file has two sheets that
# need to be read into R as separate data frames.

# 2. This link has the full text of Shakespear's Hamlet:
# http://www.gutenberg.org/cache/epub/2265/pg2265.txt
# Read it into R using readr (you need to find a function for this in the documentation).
# The result must be a character vector that starts with the actual text of the play. 


# Next: talk about Git and Github

# Next: data manipulation in R and dplyr.
# 
# Take this DataCamp module: https://www.datacamp.com/courses/dplyr-data-manipulation-r-tutorial
# and/or read ch. 5 from Data Science:
# http://r4ds.had.co.nz/transform.html (and do the exercises)

# By Friday you need to know the following:
# 1) the pipe operator
# 2) filter() and select()
# 3) arrange()
# 4) mutate()
# 5) group_by()
# 6) summarize()

# If you have a bit more time also read ch.21 from Data Science on iteration:
#         http://r4ds.had.co.nz/iteration.html


# Preparing and saving a short abstract from the data.

W1 <- UndSoc1 %>%
  select(pidp, a_sex, a_dvage, a_ukborn, a_racel, a_hlht:a_hlwtk, a_vote1:a_vote6)

write_csv(W1, "exData/W1.csv")









