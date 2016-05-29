library('ggplot2')
library('plyr')
library('tsfactors')

# Funciones
cambia_unidad <- function(df){
	datakbs <- subset(df, Unidad == 'KB/s', select = c(Fecha, Valor))
	datambs <- subset(df, Unidad == 'MB/s', select = c(Fecha, Valor))
	datakbs$Valor <- datakbs$Valor / 1024

	return(rbind(datakbs, datambs))
}

# Lee datos desde archivo
data <- read.table('test-velocidad.csv', sep = ',', header = FALSE, 
		   col.names = c('Fecha', 'Valor', 'Unidad'))

# Vector con días de la semana
days = c('lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo')

# Formatea datos
data$Fecha <- toPOSIX(data$Fecha)
data$Unidad <- as.factor(trimws(as.character(data$Unidad)))
data <- cambia_unidad(data)
data$Valor <- data$Valor * 8

# Agrega campos de día de la semana y hora del día, como factores
data$DOW <- dow(data$Fecha)
data$Hora <- hour(data$Fecha)

