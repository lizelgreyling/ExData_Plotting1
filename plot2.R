###############################################
### plot2.R                                 ###
### Author: Lizel Greyling                  ###
### 3 December 2014                         ###
###############################################

# This script loads and cleans the data form the household_power_consumption.txt file and
# converts the date and time fields into useable DateTime format.
# It then creates a black line graph, sized 480x480 pixels, of the "Global_active_power" field and saves
# the plot as a PNG file in the working directory.

# Load required packages:
library(sqldf)      
# The sqldf package allows sql to be used to only load a subset of the data.
library(lubridate)  
# The lubridate package makes working with dates and times easier.


# A function to import and clean the data: 
getdata <- function() {
  # The data must be downloaded and unzipped in the working directory.
  # Download the data from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
  
  f <- "household_power_consumption.txt"
  
  # Set the SQL command used to select only the correct rowns (where the date is 
  # either 2007-02-01 or 2007-02-02):
  sqlstring <- "SELECT * FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"
  
  # Read only the rows with the correct dates:
  nrg <- read.csv.sql(f, sqlstring, sep = ";")
  
  # Fix date and time fields:
  # Put date and time in the same field:
  nrg$DateTime <- paste(nrg$Date,nrg$Time)
  # Convert text field DateTime to POSIXct:
  nrg$DateTime <- dmy_hms(nrg$DateTime)
  
  return(nrg)
}

# Test whether the dataframe is already in memory and cleaned (date & time fixed)
# and only call the getdata function if it's not:
if (!exists("nrg")) { 
  nrg <- getdata()   # calls getdata() because the dataframe is not in memory
} else
{
  if (class(nrg$DateTime)[1] != "POSIXct") {
    nrg <- getdata() # calls getdata() because although the dataset is in memory, the date/time is wrong
  } 
}


# open png device and set parameters:
png(filename="plot2.png",width = 480, height = 480)

# set graph:
plot(x=nrg$DateTime,nrg$Global_active_power, 
     type="l", xlab = "", ylab = "Global Active Power (kilowatts)")

# close png device:
dev.off()