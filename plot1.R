# load data.table for fread, dplyr and tibble for table manipulation
library(data.table); library(dplyr); library(tibble)

# make sure the data is here
data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
data_archive <- "exdata%2Fdata%2Fhousehold_power_consumption.zip"
data_file <- "household_power_consumption_reduced.txt"
# ensure files are present
if (!file.exists(data_file)) {
    if (!file.exists(data_archive)) {
        print(paste("Downloading data from", data_url))
        download.file(data_url, destfile = data_archive, method = "curl")
    }
    print(paste0("Decompressing archive into '", data_file, "'"))
    unzip(zipfile = data_archive)
}

# read the data for 2007-02-01 and 2007-02-02
# Note that in this dataset missing values are coded as ?.
hpc <- fread("egrep '^Date|^1\\/2\\/2007|^2\\/2\\/2007' household_power_consumption.txt", 
             na.strings = "?")

# convert the Date and Time variables to Date/Time classes in R using the 
# strptime() and as.POSIXct()
hpc <- mutate(hpc, datetime = as.POSIXct(strptime(paste(hpc$Date,hpc$Time), 
                                                  format = "%d/%m/%Y %T") ) )

# open output file
png(filename = "plot1.png",
    width = 480, height = 480, units = "px", bg = "transparent")

# make plot 1
hist(hpc$Global_active_power, 
     col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

dev.off()
