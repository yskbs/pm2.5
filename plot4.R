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


s <- SCC %>% 
  filter(grepl("combustion",SCC.Level.One, ignore.case = TRUE),grepl("coal",SCC.Level.Three, ignore.case=TRUE))


merged <- merge(NEI, s, by= "SCC")
merged <- merged %>%  
  group_by(year) %>% 
  mutate(total = sum(Emissions))

## the graph is confusing with ylim not start from 0, adjust ylim to remove the confusion
ggplot(merged,aes(year,total))+ 
  geom_line()+ 
  labs(y="Total Emission (Tons)",
       title = "Total Coal Combustion-related PM2.5 Emission from 1999–2008")+
  scale_y_continuous(limits = c(0, 600000))

dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()


rm(list = ls())

