dataDir = "data"
dataUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if (!file.exists(dataDir)) {
    dir.create(dataDir)
    
    fileName = "data.zip"
    download.file(dataUrl, 
                  destfile=fileName, 
                  method="curl")
    downloadTime <- date()
    
    unzip(fileName, exdir=dataDir)
}

library(dplyr)

if (!exists("merged")) {
    NEI <- readRDS("data/summarySCC_PM25.rds")
    NEI <- tbl_df(NEI)
    
    SCC <- readRDS("data/Source_Classification_Code.rds")
    SCC <- tbl_df(SCC)
    
    merged <- merge(NEI, SCC, by="SCC")
}

library(qqplot2)

# 1. ---
emissionsByYear <- aggregate(NEI['Emissions'], by=NEI['year'], sum)
with(emissionsByYear, plot(year, Emissions, type="b"))

# 2. 
baltimore <- filter(NEI, fips=="24510")
emissionsByYear <- aggregate(baltimore['Emissions'], by=baltimore['year'], sum)
with(emissionsByYear, plot(year, Emissions, type="b"))

# 3.
emissionsByYearAndType <- aggregate(baltimore['Emissions'], by=c(baltimore['year'], baltimore['type']), sum)
#ggplot(emissionsByYearAndType, aes(year, Emissions)) + geom_point() + geom_line() + facet_grid(cols=vars(type))
ggplot(emissionsByYearAndType, aes(year, Emissions, col=type)) + geom_point() + geom_line()

#4.
coalAndComb <- merged[grepl("comb.*coal|coal.*comb", merged$EI.Sector, ignore.case=TRUE),]
emissionsByYear <- aggregate(coalAndComb['Emissions'], by=coalAndComb['year'], sum)
with(emissionsByYear, plot(year, Emissions, type="b"))

#5.
baltimore <- filter(merged, fips=="24510")
motorVehicles <- baltimore[grepl("motor", baltimore$Short.Name, ignore.case=TRUE),]
emissionsByYear <- aggregate(Emissions ~ year, motorVehicles, sum)
ggplot(emissionsByYear,aes(year,Emissions)) + geom_point() + geom_line()

