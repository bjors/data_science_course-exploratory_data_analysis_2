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

# Calculate
emissionsByYear <- aggregate(Emissions ~ year, NEI, sum)

# Draw plot
png(filename = "plot1.png")
bar <- with(emissionsByYear, barplot(Emissions~year, main="Total emissions in US"))
text(bar, emissionsByYear$Emissions, format(emissionsByYear$Emissions, ndigits=0), pos=1, col="blue")
dev.off()
