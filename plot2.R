library(dplyr)
library(ggplot2)

# Download data
if (!file.exists("data")) {
    dir.create("data")
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
                  destfile="data.zip", 
                  method="curl")
    unzip("data.zip", exdir="data")
}

# Read data
if (!exists("NEI")) {
    NEI <- tbl_df(readRDS("data/summarySCC_PM25.rds"))
}

# Filter
baltimore <- filter(NEI, fips=="24510")

# Calculate
emissionsByYear <- aggregate(Emissions ~ year, baltimore, sum)

# Draw plot
png(filename = "plot2.png")
with(emissionsByYear, plot(year, Emissions, type="b", main="Total emissions in Baltimore City", ylab="emissions (tons)"))
dev.off()