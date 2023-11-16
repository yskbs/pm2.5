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
SCCVehicle.SCC <- SCCVehicle$SCC

NEIVehicle <- NEI[NEI$SCC %in% SCCVehicle.SCC,]

NEIBaltimoreV <- NEIVehicle %>% 
  filter(fips == "24510") %>% 
  mutate(city= "Baltimore City")

NEILAV <- NEIVehicle %>% 
  filter(fips == "06037") %>% 
  mutate(city= " Los Angeles County")
combined <- rbind(NEIBaltimoreV, NEILAV)

combined<- combined %>% 
  group_by(city,year) %>% 
  summarise(total=sum(Emissions)) 


ggplot(combined, aes(factor(year),y=total,fill = year))+
  geom_bar(stat = "identity") +
  facet_wrap(.~city) +
  labs(y="Total PM2.5 Emission Tons",x="year",
  title="PM2.5 Motor Vehicle Source Emissions in Baltimore City and LA from 1999-2008")
  

dev.copy(png, file="plot6.png", height=480, width=480)
dev.off()


rm(list = ls())