## Load data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#sum(NEI[NEI$year == 1999, "Emissions"]) #7332967
#sum(NEI[NEI$year == 2002, "Emissions"]) #5635780
#sum(NEI[NEI$year == 2005, "Emissions"]) #5454703
#sum(NEI[NEI$year == 2008, "Emissions"]) #3464206
#sum(NEI$Emissions) #21887656

totalEmissionsPerYear <- aggregate(NEI$Emissions, by = list(NEI$year),
                                   FUN = function(sub) { sum(as.numeric(sub)) })

colnames(totalEmissionsPerYear) <- c("year", "emissions")

png(filename = "plot1.png", bg = "white", width = 480, height = 480)
with(totalEmissionsPerYear, plot(year, emissions / 1000, type = "l", lwd = "2",
                                 col = "red", main = "PM2.5 Emission",
                                 xlab = "Year", ylab = "Emissions (1 = 1000 tons)"))
dev.off()