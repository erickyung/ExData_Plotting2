## Load data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimoreNEI <- NEI[NEI$fips == "24510", ]

#sum(baltimoreNEI[baltimoreNEI$year == 1999, "Emissions"]) #3274.18
#sum(baltimoreNEI[baltimoreNEI$year == 2002, "Emissions"]) #2453.916
#sum(baltimoreNEI[baltimoreNEI$year == 2005, "Emissions"]) #3091.354
#sum(baltimoreNEI[baltimoreNEI$year == 2008, "Emissions"]) #1862.282
#sum(baltimoreNEI$Emissions) #10681.73

totalBaltimoreEmissionsPerYear <- aggregate(baltimoreNEI$Emissions, by = list(baltimoreNEI$year),
                                            FUN = function(sub) { sum(as.numeric(sub)) })

colnames(totalBaltimoreEmissionsPerYear) <- c("year", "emissions")

png(filename = "plot2.png", bg = "white", width = 480, height = 480)
with(totalBaltimoreEmissionsPerYear, plot(year, emissions, type = "l", lwd = "2",
                                          col = "red", main = "Baltimore PM2.5 Emission",
                                          xlab = "Year", ylab = "Emissions (tons)"))
dev.off()