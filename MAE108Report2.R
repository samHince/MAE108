# Script created by Sam Hince
# 10/28/2020

library(dplyr)
library(ggplot2)
library(MASS) # to access Animals data sets
library(scales) # to access break formatting functions

###########################################################################################

# online desnsity calculator: https://www.omnicalculator.com/physics/air-density
rho = 1.17279 # kg / m^3
viscosity = 18.45*(10^-6)

###########################################################################################
### calculations for Sphere
velocity <- c(5.088,14.97,25.1,34.89,29.94,19.98,10.2,5.431) # m/s
Fz <- c(-0.073302,-0.349666,-0.8588,-1.55559,-1.17407,-0.519126,-0.181021,-0.101544) # N
Drag0 <- -0.0181225 # N
L <- 0.075438 # m
# in this experiment angle of attack is 0, therefore D = Fz
A <- pi * (L^2)/4
dfSphere <- data.frame(velocity, Drag = Fz)
dfSphere$dynamicPressure <- ((dfSphere$velocity^2) * 0.5 * rho)
dfSphere$Cd <- -(dfSphere$Drag - Drag0)/(dfSphere$dynamicPressure * A)
dfSphere$Re <- (rho * dfSphere$velocity * L)/viscosity

###########################################################################################
### calculations for Sphere w/ trip wire
velocity <- c(5.018,15.13,25.08,34.95,29.96,20.28,10.14,4.891)
Fz <- c(-0.0529511,-0.420312,-1.10865,-1.92936,-1.44859,-0.673448,-0.21403,-0.084314)
Drag0 <- -0.000530927
L <- 0.075438 # m

A <- pi * (L^2)/4
dfSphereWire <- data.frame(velocity, Drag = Fz)
dfSphereWire$dynamicPressure <- ((dfSphereWire$velocity^2) * 0.5 * rho)
dfSphereWire$Cd <- -(dfSphereWire$Drag - Drag0)/(dfSphereWire$dynamicPressure * A)
dfSphereWire$Re <- (rho * dfSphereWire$velocity * L)/viscosity

###########################################################################################
### calculations for streamlined object
velocity <- c(5.38,15.14,25.08,35.02,30.8,20.63,10.28,5.163)
Fz <- c(-0.00531983,-0.0334037,-0.0718699,-0.0447612,-0.0516459,-0.0496018,-0.0321639,-0.0196048)
Drag0 <- 0.0010863
L <- 0.075438 # m

A <- pi * (L^2)/4
dfStreamlined <- data.frame(velocity, Drag = Fz)
dfStreamlined$dynamicPressure <- ((dfStreamlined$velocity^2) * 0.5 * rho)
dfStreamlined$Cd <- -(dfStreamlined$Drag - Drag0)/(dfStreamlined$dynamicPressure * A)
dfStreamlined$Re <- (rho * dfStreamlined$velocity * L)/viscosity

###########################################################################################
### textbook data
#Re <- c(0.25E5, 0.5E5, 0.75E5, 1E5, 1.05E5, 1.1E5, 1.18E5, 1.2E5)
#Cd <- c(0.45, 0.46, 0.48, 0.49, 0.5, 0.5, 0.49, 0.4)
#Re <- c(0.25E5, 0.5E5, 0.75E5, 1E5,  1.05E5, 1.1E5, 1.2E5, 1.3E5, 1.4E5, 1.5E5, 1.6E5, 1.7E5)
Re <- c(0.25E5, 0.5E5, 0.75E5, 1E5,  1.25E5,  1.5E5,   2E5,   3E5,   4E5,   5E5,   6E5,    7E5)
Cd <- c(0.43,   0.46,  0.48,   0.495,0.5,     0.49,     0.4,   0.2,   0.09,  0.08,  0.1,    0.12)
dfTextbook <- data.frame(Re, Cd)

###########################################################################################
### generate plot
# combine data
df <- data.frame(dfSphere,dfSphereWire,dfStreamlined)

breaks <- c(2E4,1E5,7E5) #10^(-10:10)
minor_breaks <- c(2E4,3E4,4E4,5E4,6E4,7E4,8E4,9E4,1E5,2E5,3E5,4E5,5E5,6E5,7E5)

### create plot to viualize data ###
pl <- ggplot(df) + 
	geom_point(aes(Re, Cd, colour="red"), size=3) +	
	geom_point(aes(Re.1, Cd.1, colour="blue"), size=3) +	
	geom_point(aes(Re.2, Cd.2, colour="green"), size=3) +	
	geom_line(data = dfTextbook, aes(Re, Cd, colour="black"), size=1) +	
	scale_x_log10(limits = c(23000, 7E5), breaks = breaks, minor_breaks = minor_breaks) +
	xlab("Re") +
	ylab(expression(C[d])) +
	labs(colour = "name1",
		shape = "name2") +
	scale_colour_manual(name = 'Key', guide = 'legend',
						values =c('blue'='blue','green'='green','black'='black','red'='red'), labels = c('Textbook','Sphere w/ Wire','Streamlined Body','Sphere')) + 
	theme_bw() +
	theme(axis.title.y = element_text(angle = 0, vjust = 0.5, size = 11),
		legend.position = "right",legend.justification = c(0, 1))
print(pl)

