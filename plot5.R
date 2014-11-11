## Load data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimoreNEI <- NEI[NEI$fips == "24510", ]
vehicleSources <- as.character(SCC[SCC$SCC.Level.One == "Mobile Sources", c("SCC")])

baltimoreVehicleNEI <- baltimoreNEI[baltimoreNEI$SCC %in% vehicleSources, ]

emissionsByVehicleInBaltimorePerYear <- aggregate(baltimoreVehicleNEI$Emissions, by = list(baltimoreVehicleNEI$year),
                                                  FUN = function(sub) { sum(as.numeric(sub)) })

colnames(emissionsByVehicleInBaltimorePerYear) <- c("year", "emissions")

png(filename = "plot5.png", bg = "white", width = 480, height = 480)
with(emissionsByVehicleInBaltimorePerYear, plot(year, emissions, type = "l", lwd = "2",
                                                col = "red", main = "Baltimore PM2.5 Emission by Vehicle sources",
                                                xlab = "Year", ylab = "Emissions (tons)"))
dev.off()