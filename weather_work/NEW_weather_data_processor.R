library(tidyverse)
library(lubridate)
library(plyr)
library(fasttime)
library(data.table)

library(stringi)


df <- fread("/Users/dehaay/Desktop/weather_work_data/2a0bb0adc7ef7b8192add6f753a89448.csv")

zxc <- fread("/Users/dehaay/Desktop/weather_work_data/2a0bb0adc7ef7b8192add6f753a89448.csv")
#dfd <- substr(df$dt_iso,1,19) #removes the "+0000"

a <- as.POSIXct(dfd, format= "%Y-%m-%d %H:%M:%S")
a <-force_tz(a, tzone = "UTC")
a <-with_tz(a, tzone = "America/New_York")

df$dt_iso <- a

cond_0 <- c("sky is clear","broken clouds","few clouds","scattered clouds")
cond_1 <- c("mist","overcast clouds")
cond_2 <- c("light rain",
            "fog",
            "light snow",
            "light rain and snow",
            "snow",
            "squalls",
            "smoke",
            "proximity thunderstorm with drizzle",
            "proximity squalls",
            "drizzle","haze")
cond_3 <- c("moderate rain","light intensity drizzle","light intensity shower rain")
cond_4 <- c("thunderstorm with rain",
            "thunderstorm with light rain",
            "thunderstorm",
            "heavy intensity rain",
            "heavy intensity drizzle",
            "proximity thunderstorm",
            "very heavy rain",
            "thunderstorm with heavy rain",
            "heavy snow",
            "dust",
            "proximity thunderstorm with rain",
            "thunderstorm with light drizzle",
            "sand",
            "freezing rain",
            "shower rain",
            "sand/dust whirls",
            "heavy thunderstorm","extreme rain","sleet")

catgrize <- function(x) {
  if (x %in% cond_0){
    return(0)
  } else if(x %in% cond_1){
    return(1)
  } else if(x %in% cond_2){
    return(2)
  }else if(x %in% cond_3){
    return(3)
  }else if(x %in% cond_4){
    return(4)
  } else{
    return(5)
  }
}

cv <- lapply(df$weather_description, function(x) catgrize(x) )
df$weather_description <- unlist(cv)

zxc<- zxc[-86520,]
df <- df[-86520,]

final_weath <- data.frame(date = as.character(df$dt_iso), temp = df$temp,
                          feels_like = df$feels_like, visblty = df$visibility,
                          humidity = df$humidity, windspd = df$wind_speed )
View(final_weath)

View(data.frame(df$weather_description, zxc$weather_description))



fwrite(final_weath,"/Users/dehaay/Desktop/weather_work_data/weatherdata2013-2017.csv", row.names = FALSE)



#Author : Deha Ay

#use to call the dataframe
aaxx<-fread("/Users/dehaay/Desktop/weather_work_data/weatherdata2013-2017.csv")
aaxx$date <-force_tz(aaxx$date, tzone = "America/New_York")
