load("~/Documents/CU BOULDER/3rd Year/Fall 2023/Research/2010_full.RData")
#Include your own path to data!
data_2010 <- as.data.frame(data_2010)
# note: checked that ordering of stations in 2010_full is consistent with
# the lat/lon naming order

## Setting up spatial information
ns <- 17
lat.lon <- matrix(c(21.31236,-158.08463,21.31303,-158.08505,21.31357,-158.08424,
                    21.31183,-158.08554,21.31042,-158.0853,21.31268,-158.08688,21.31451,-158.08534,
                    21.31533,-158.087,21.30812,-158.07935,21.31276,-158.08389,21.31281,-158.08163,
                    21.30983,-158.08249,21.31141,-158.07947,21.31478,-158.07785,21.31179,-158.08678,
                    21.31418,-158.08685,21.31034,-158.08675),nr=ns,nc=2,byrow=TRUE)
lon.lat <- lat.lon[,c(2,1)]
rm(lat.lon)

## Grab only June through August 2010 data
data_2010 <- data_2010[data_2010$day %in% c(151:242),]
data_2010 <- data_2010[data_2010$time_hr_min < 2000,]
## Format
TIME <- data.frame(day=data_2010$day,hr=as.integer(floor(data_2010$time_hr_min/100)),
                   min=as.integer(data_2010$time_hr_min-100*as.integer(floor(data_2010$time_hr_min/100))),
                   sec=data_2010$time_sec)
TIME$secofday <- as.integer(TIME$hr*60*60 + TIME$min*60 + TIME$sec)
GHI <- as.data.frame(data_2010[,7:23])
CSGHI <- data_2010[,3]
rm(data_2010)

## Grab only times when expected irradiance is greater than 80 W / m^2
these <- CSGHI >= 80
TIME <- TIME[these,]
GHI <- GHI[these,]
CSGHI <- CSGHI[these]
rm(these)

## Log clear sky index
LCSI <- GHI
for(i in 1:ns){
  LCSI[,i] <- log(GHI[,i]/CSGHI)
}
