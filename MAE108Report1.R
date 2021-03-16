# Script created by Sam Hince
# 10/15/2020

library(dplyr)
library(ggplot2)

###########################################################################################

### import raw data ###
#(degree)
Angle <- c(-20.600,-16.600,-13.200,-10.000,-9.000,-8.000,-6.800,-5.000,-3.300,-2.000,-1.200,0.000,0.700,1.600,2.000,3.600,4.200,
		   5.000,6.000,7.000,8.200,9.700,13.600,15.400,20.400) 

# (Pa)
DynamicPressure <- c(640.775,640.475,636.117,635.661,635.093,630.663,627.331,629.059,624.220,623.883,621.017,618.909,621.782,625.471,
					 626.960,625.078,625.903,625.999,630.534,635.627,639.151,640.132,641.097,642.371,639.367)

# (Pa)
GaugeStagnationPressure <- c(-102.372,-89.044,-59.522,-58.250,-60.008,-57.066,-54.771,-55.486,-54.787,-54.550,-54.743,-54.570,
							 -54.619,-55.273,-54.470,-55.244,-55.406,-54.827,-59.314,-57.549,-59.516,-62.010,-76.592,-88.110,-114.647)

### combine ###
df <- data.frame(Angle, DynamicPressure, GaugeStagnationPressure)

AirDensity <- 1.208 			#(kg/m^3)
Velocity <- 30 					#(m/s)
AmbientPressure <- 101354.613 	#(Pa)

### perform calculations ###
df$deltaP <- df$DynamicPressure - df$GaugeStagnationPressure    	# calculate chnage in pressure

df$Airspeed <- sqrt((2*(df$deltaP))/AirDensity)						# calculate airspeed

TAS <- filter(df, Angle==0)$Airspeed								# select the true air speed (when the angle is 0)

df$Error <- (abs(TAS - df$Airspeed) / df$Airspeed) * 100 			# calculate the error

### create plot to viualize data ###
pl <- 	ggplot(df, aes(Angle, Error)) + 
		geom_point() +	
		geom_line() +
		xlab("Angle [degrees]") +
		ylab("Error [%]") +
		scale_y_continuous(breaks=seq(0,5.5,1)) + 
		theme_bw() + 
		theme(axis.title.y = element_text(angle = 0, vjust = 0.5, size = 11))
print(pl)

###########################################################################################

# (m/s)
SpeedPitot <- c(29.990,27.600,25.290,22.420,20.630,18.080,14.640,10.030,4.603,1.903)

# (m/s)
SpeedStatic <- c(31.420,28.850,26.460,23.460,21.840,19.480,15.790,10.820,5.132,2.424)

df <- data.frame(SpeedPitot, SpeedStatic)

df$Difference = abs(df$SpeedStatic - df$SpeedPitot)

max(df$Difference)

df$Error <- (df$Difference / df$SpeedPitot) * 100

pl <-   ggplot(df, aes(SpeedPitot, Error)) + 
		geom_line() +
		geom_point() +
		xlab("Flow Speed [m/s]") +
		ylab("Error [%]")  +
		scale_y_continuous(breaks=seq(0,30,5)) + 
		theme_bw() + 
		theme(axis.title.y = element_text(angle = 0, vjust = 0.5, size = 11))
print(pl)
