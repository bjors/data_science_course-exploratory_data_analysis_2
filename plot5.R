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
if (!exists("merged")) {
    NEI <- tbl_df(readRDS("data/summarySCC_PM25.rds"))
    SCC <- tbl_df(readRDS("data/Source_Classification_Code.rds"))
    merged <- merge(NEI, SCC, by="SCC")
}

# Filter
motorVehicles <- merged %>% 
    filter(fips=="24510") %>%
    filter(grepl("motor", Short.Name, ignore.case=TRUE))


emissionsByYear <- aggregate(Emissions ~ year, motorVehicles, sum)

# Draw plot
png(filename = "plot5.png")
ggplot(emissionsByYear,aes(x=as.character(year),y=Emissions)) + 
    geom_col() + 
    geom_label(aes(label=round(Emissions,2))) + 
    xlab("year") +
    ylab("emissions (tons)") + 
    ggtitle("Total motor vehicle emissions in Baltimore")

dev.off()