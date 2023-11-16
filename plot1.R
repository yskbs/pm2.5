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

head(NEI)
head(SCC)


n <- NEI %>% group_by(year) %>% summarise(total=sum(Emissions))
barplot(total ~year,data = n, main =  "Emissions over the Years")

dev.copy(png, file="plot1.png", height=480, width=480)
dev.off()

save.file("plot1.R")

rm(list = ls())