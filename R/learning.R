# Load packages

library(tidyverse)
library(NHANES)
#some people insert very large datasets into packages because it makes it easier to load

# Looking at data
glimpse(NHANES)

# Selecting columns
#first argument is the data set
select(NHANES, Age)
select(NHANES, Age, Weight, BMI)
select(NHANES, -HeadCirc)
select(NHANES, starts_with("BP"))
select(NHANES, ends_with("Day"))
select(NHANES, contains("Age"))

#output shows up in the console, so we need to save it as an object, if we want to use it
# Create smaller NHANES dataset
select(NHANES, Age, Gender, BMI, Diabetes, PhysActive, BPSysAve, BPDiaAve, Education)
nhanes_small <-select(NHANES, Age, Gender, BMI, Diabetes, PhysActive, BPSysAve, BPDiaAve, Education)

#to see what we assigned, we need to print the object
nhanes_small

#Renaming columns
nhanes_small <-rename_with(nhanes_small, snakecase::to_snake_case)
#when providing a function inside a function,
#we cannot use () because it tries to read that function first, whcih wont run because there are no argumnents

#Renaming specific columns
#the name you want = collumn you want to change

nhanes_small <- rename(nhanes_small, sex = gender)

# Trying out the pipe

colnames(nhanes_small)

nhanes_small %>%
    colnames()

nhanes_small %>%
    select(phys_active) %>%
    rename(physically_active = phys_active)

#exercise 7.8

nhanes_small %>%
    select(bp_sys_ave, bp_dia_ave) %>%
    rename(bp_sys = bp_sys_ave,
           bp_dia = bp_dia_ave)

nhanes_small %>%
    select(bmi, contains("age"))

#Filtering - filters based on data contained in rows
#filter non-physically active people

nhanes_small %>%
    filter(phys_active != "No")

#filter numerical variables
#above or equal is >= and not =>

nhanes_small %>%
    filter(bmi >= 25)

#combine logical operators

nhanes_small %>%
    filter(bmi >= 25 & phys_active == "No")

nhanes_small %>%
    filter(bmi >=25 | phys_active == "No")
# Arrange data

nhanes_small %>%
    arrange(education, age)
#arrange data is only visualy, data stays the same

#Transforming data - main way to do so is by adding collumns, using functions on dplyr

nhanes_small %>%
    mutate(age = age * 12, logged_bmi = log(bmi))

nhanes_small %>%
    mutate(old = if_else(age >= 30, "Yes", "No"))


# Exercise 7.12

# 1. BMI between 20 and 40 with diabetes
nhanes_small %>%
    # Format should follow: variable >= number or character
    filter(bmi >= 20 & bmi <= 40 & diabetes == "Yes")

# Pipe the data into mutate function and:
nhanes_modified <- nhanes_small %>% # Specifying dataset
    mutate(
        # 2. Calculate mean arterial pressure
        mean_arterial_pressure = ((2*bp_dia_ave)+bp_sys_ave)/3,
        # 3. Create young_child variable using a condition
        young_child = if_else(age < 6, "Yes", "No")
    )

# exercise 7.12 -----------------------------------------------------------


nhanes_modified


# Creating summary statistics
#most functions dont work with missing values --> we need to tell the
#function to ignore the missing values
nhanes_small %>%
    summarise(max_bmi = max(bmi, na.rm = TRUE), min_bmi = min(bmi, na.rm = TRUE))
#na.rm --> to remove the NA

nhanes_small %>% #filter the data before spliting, to avoid NA
    filter(!is.na(diabetes)) %>%
#is.na checks if the argument is what we put there, otherwise tells us is false
    #is.na(NA) -> true ; !is.na(NA) --> false
    group_by(diabetes) %>%
    summarise(mean_age = mean(age, na.remove = TRUE),
              mean_bmi = mean(bmi, na.rm = TRUE))

# Saving data

readr::write_csv(nhanes_small, here::here("data/nhanes_small.csv"))



