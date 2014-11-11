## Load data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimoreNEI <- NEI[NEI$fips == "24510", ]
laNEI <- NEI[NEI$fips == "06037", ]
vehicleSources <- as.character(SCC[SCC$SCC.Level.One == "Mobile Sources", c("SCC")])

baltimoreVehicleNEI <- baltimoreNEI[baltimoreNEI$SCC %in% vehicleSources, ]
laVehicleNEI <- laNEI[laNEI$SCC %in% vehicleSources, ]

emissionsByVehicleInBaltimorePerYear <- aggregate(baltimoreVehicleNEI$Emissions,
                                                  by = list(baltimoreVehicleNEI$year),
                                                  FUN = function(sub) { sum(as.numeric(sub)) })
emissionsByVehicleInLAPerYear <- aggregate(laVehicleNEI$Emissions,
                                           by = list(laVehicleNEI$year),
                                           FUN = function(sub) { sum(as.numeric(sub)) })

colnames(emissionsByVehicleInBaltimorePerYear) <- c("year", "emissions")
colnames(emissionsByVehicleInLAPerYear) <- c("year", "emissions")

#calculate rate of change year over year
library(TTR)
rocLA <- ROC(emissionsByVehicleInLAPerYear$emissions, type = "discrete")
rocLA[is.na(rocLA)] <- 0
emissionsByVehicleInLAPerYear$roc <- rocLA
rocBaltimore <- ROC(emissionsByVehicleInBaltimorePerYear$emissions, type = "discrete")
rocBaltimore[is.na(rocBaltimore)] <- 0
emissionsByVehicleInBaltimorePerYear$roc <- rocBaltimore

#plot
png(filename = "plot6.png", bg = "white", width = 800, height = 480)
rng <- range(emissionsByVehicleInLAPerYear$emissions,
             emissionsByVehicleInBaltimorePerYear$emissions)
rng1 <- range(emissionsByVehicleInLAPerYear$roc,
              emissionsByVehicleInBaltimorePerYear$roc)
par(mfrow = c(1, 2))
with(emissionsByVehicleInLAPerYear, plot(year, emissions, type = "l", col = "red",
                                         ylim = rng, cex.main = 1,
                                         main = "PM2.5 Emission by Vehicle sources",
                                         xlab = "Year", ylab = "Emissions (tons)"))
with(emissionsByVehicleInBaltimorePerYear, lines(year, emissions, col = "blue"), ylim = rng)
legend("right", lwd = 2, col = c("red", "blue"), , cex = 0.75,
       legend = c("Los Angeles County", "Baltimore City"))

with(emissionsByVehicleInLAPerYear, plot(year, roc, type = "l", col = "red",
                                         ylim = rng1, cex.main = 1,
                                         main = "Rate of Change in Emission by Vehicle sources",
                                         xlab = "Year", ylab = "Rate of Change"))
with(emissionsByVehicleInBaltimorePerYear, lines(year, roc, col = "blue"), ylim = rng1)
legend("bottomright", lwd = 2, col = c("red", "blue"), , cex = 0.75,
       legend = c("Los Angeles County", "Baltimore City"))
dev.off()