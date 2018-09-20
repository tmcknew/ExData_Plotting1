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
png(filename = "plot4.png",
    width = 480, height = 480, units = "px", bg = "transparent")

# make plot 4
par(mfrow = c(2,2))
# make subplot 1
with(hpc, plot(datetime,Global_active_power,
               xlab = "", ylab = "Global Active Power (kilowatts)", type = "n"))
with(hpc, lines(datetime,Global_active_power))

# make subplot 2
with(hpc, plot(datetime,Voltage,
               xlab = "datetime", ylab = "Voltage", type = "n"))
with(hpc, lines(datetime,Voltage))

# make subplot 3
with(hpc,
     plot(datetime,Sub_metering_1, xlab = "", ylab = "Energy Sub Metering", type = "n"))
with(hpc, lines(datetime,Sub_metering_1, col = "black"))
with(hpc, lines(datetime,Sub_metering_2, col = "red"))
with(hpc, lines(datetime,Sub_metering_3, col = "blue"))
legend(bty = "n", topright", lty = c(1,1,1), col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# make subplot 4
with(hpc, plot(datetime,Global_reactive_power,
               xlab = "datetime", ylab = "Global_reactive_power", type = "n"))
with(hpc, lines(datetime,Global_reactive_power))


dev.off()
