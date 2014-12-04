###############################################
### plot4.R                                 ###
### Author: Lizel Greyling                  ###
### 3 December 2014                         ###
###############################################

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
png(filename="plot4.png",width = 480, height = 480, bg= "transparent")
#setup graph layout:
par(mfcol = c(2,2)) 
# set graphs:
  plot(x=nrg$DateTime,y=nrg$Global_active_power, 
      type="l", xlab = "", ylab = "Global Active Power")
  plot(x=nrg$DateTime,y=nrg$Sub_metering_1,
      type="l", xlab = "", ylab = "Energy sub metering")
    lines(x=nrg$DateTime,y=nrg$Sub_metering_2,col="red", type="l")
    lines(x=nrg$DateTime,y=nrg$Sub_metering_3,col="blue", type="l")
  legend("topright", col = c("black","red","blue"),lty=1, bty = "n",
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
  plot(x=nrg$DateTime,y=nrg$Voltage, type="l", xlab = "datetime", ylab = "Voltage")
  plot(x=nrg$DateTime,y=nrg$Global_reactive_power, type="l", xlab="datetime", ylab = "Global_reactive_power")
# close png device:
dev.off()