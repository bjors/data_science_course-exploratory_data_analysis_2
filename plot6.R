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

# Filter data frame
motorVehicles <- merged %>% 
    filter(fips=="24510" | fips=="06037") %>%
    filter(grepl("motor", Short.Name, ignore.case=TRUE)) %>% 
    rename("emissions"="Emissions", "area"="fips")

# Replace fips with readable label
motorVehicles$area <- factor(motorVehicles$area, labels=c("Los Angeles County", "Baltimore"))

# Group by area and calculate relative change
emissionsByYearAndArea <- aggregate(emissions ~ year + area, data=motorVehicles, sum) %>% 
    group_by(area) %>% 
    mutate(relative_change = emissions - emissions[[1]])

png(filename = "plot6.png")
ggplot(emissionsByYearAndArea, aes(year, relative_change, col = area)) + 
    geom_point() + 
    geom_line() + 
    ylab("relative change (tons)") + 
    ggtitle("Relative change of motor vehicle emission since 1999")
dev.off()