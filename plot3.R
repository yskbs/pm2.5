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


n <- NEI %>% filter(fips == "24510")%>% group_by(year,type) %>% summarise(total=sum(Emissions))
g <- ggplot(n,aes(x=year,y=total, color=type))
g + geom_point() + geom_line() +
  labs(x="year", y="Total PM2.5 Emission (Tons)", title="Total PM2.5 emissions from 1999–2008 in Baltimore City by type")
 
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()


rm(list = ls())