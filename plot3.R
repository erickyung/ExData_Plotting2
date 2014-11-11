## Load data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimoreNEI <- NEI[NEI$fips == "24510", ]

baltimoreEmissionsPerTypePerYear <- aggregate(baltimoreNEI$Emissions,
                                              by = list(baltimoreNEI$type, baltimoreNEI$year),
                                              FUN = function(sub) { sum(as.numeric(sub)) })

colnames(baltimoreEmissionsPerTypePerYear) <- c("type", "year", "emissions")

library(ggplot2)
#using qplot() function
png(filename = "plot3_qplot.png", bg = "white", width = 600, height = 480)
qplot(year, emissions, data = baltimoreEmissionsPerTypePerYear,
      size = I(5), color = type, main = "Baltimore PM2.5 Emission") + geom_smooth(method = "loess")
dev.off()

#using ggplot() function
png(filename = "plot3_ggplot.png", bg = "white", width = 600, height = 480)
ggplot(baltimoreEmissionsPerTypePerYear, aes(year, emissions)) +
  geom_point(aes(color = type), size = 5) +
  geom_smooth(aes(color = type), size = 0.5, method = "loess") +
  labs(title = "Baltimore PM2.5 Emission")
dev.off()