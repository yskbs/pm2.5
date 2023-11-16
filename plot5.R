library(tidyverse)
library(lubridate)
library(data.table)

if(!dir.exists("data")) { dir.create("data") }

# Download and unzip data file

files.url   <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
files.path  <- "data/exdata_data_NEI_data.zip"
files.unzip <- c("data/summarySCC_PM25.rds","data/Source_Classification_Code.rds")


if(!file.exists(files.path) & !any(file.exists(files.unzip))) {
  download.file(files.url, files.path)
  unzip(files.path, exdir = "data")
}

NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


SCCVehicle<- SCC %>% 
  filter(grepl("vehicle", SCC.Level.Two, ignore.case=TRUE))

NEIBaltimore <- NEI %>% 
  filter(fips == "24510")

merged <- merge(NEIBaltimore, SCCVehicle, by= "SCC")
merged <- merged %>% group_by(year) %>% 
  summarise(total= sum(Emissions))


ggplot(merged, aes(factor(year),y=total,fill = year))+
  geom_bar(stat = "identity") +
  labs(y="Total PM2.5 Emission Tons",x="year",
       title="PM2.5 Motor Vehicle Source Emissions in Baltimore City from 1999-2008")
dev.copy(png, file="plot5.png", height=480, width=480)
dev.off()


rm(list = ls())