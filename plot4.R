## Load data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get source code classification related to coal
coalRelatedSCC <- as.character(SCC[grepl("Coal", SCC$Short.Name), c("SCC")])
# Get NEI related to coal
coalRelatedNEI <- NEI[NEI$SCC %in% coalRelatedSCC, ]

totalEmissionsByCoalPerYear <- aggregate(coalRelatedNEI$Emissions, by = list(coalRelatedNEI$year),
                                         FUN = function(sub) { sum(as.numeric(sub)) })

colnames(totalEmissionsByCoalPerYear) <- c("year", "emissions")

png(filename = "plot4.png", bg = "white", width = 480, height = 480)
with(totalEmissionsByCoalPerYear, plot(year, emissions, type = "l", lwd = "2",
                                 col = "red", main = "PM2.5 Emission by Coal combustion-related sources",
                                 xlab = "Year", ylab = "Emissions (tons)"))
dev.off()