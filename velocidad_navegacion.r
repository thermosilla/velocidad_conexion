################ Librerías utilizadas
library('ggplot2')
library('plyr')
library('forecast')

# Fija localización de tiempo para Chile
Sys.setlocale("LC_TIME", "es_CL.UTF-8")


############### Funciones
# Transforma todos los valores a MB/s
cambia_unidad <- function(df){
	datakbs <- subset(df, Unidad == 'KB/s', select=c(Fecha, Valor))
	datambs <- subset(df, Unidad == 'MB/s', select=c(Fecha, Valor))
	datakbs$Valor <- datakbs$Valor / 1024

		return(rbind(datakbs, datambs))
}

# Agrega día de la semana a dataframe a partir de una fecha posix
dow <- function(df, fecha){
	days = c('lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo')
	df$DOW <- factor(weekdays.POSIXt(fecha), levels = days)
	return(df)
}


############### Transformación de datos
# Carga el archivo de datos como un dataframe
data <- read.table('test-velocidad.csv', sep=',', header=FALSE, col.names=c('Fecha', 'Valor', 'Unidad'))

# Formatea datos
data$Fecha <- as.POSIXct(strptime(data$Fecha, format="%Y-%m-%d %H:%M:%S"))
data$Unidad <- as.factor(trimws(as.character(data$Unidad)))

# Selecciona datos de este año
# data <- subset(data, Fecha >= "2016-01-01")
data <- data[data$Fecha >= "2016-01-01",]

# Transforma KB/s a MB/s y todo a Mbps
data <- cambia_unidad(data)

# Transforma de MBps a Mbps
data$Valor <- data$Valor * 8

# Agrega día de la semana
data <- dow(data, data$Fecha)


# elimina outliers -> validar si son outliers
# data <- data[data$Valor > 15 & data$Valor < 55 ,]

# Muestra deciles
# quantile(data$Valor, c(.1,.2,.3,.4,.5,.6,.7,.8,.9,1))

# Agrupar por hora
data$Hora <- factor(format(data$Fecha, "%H"))
hour_data <- ddply(data, .(DOW, Hora), summarise, Valor = mean(Valor))

# Agrupar por día
day_data <- ddply(data, .(DOW), summarise, Valor = mean(Valor))


################ Modelo ARIMA
# fit <- auto.arima(data$Valor)
# png('prediccion_arima.png', width=800, height=600)
# plot(forecast(fit, h=200))
# dev.off()


################ Gráficos
# Serie de Tiempo
png('time_series.png', width=1200, height=600)
plot <- ggplot(data, aes(Fecha, Valor)) + geom_point()
plot <- plot + xlab("Fecha") + ylab("Velocidad de descarga [Mbps]")
plot <- plot + stat_smooth()
print(plot)
dev.off()

# Histograma
png('histograma.png', width=800, height=600)
plot <- ggplot(data, aes(x=Valor)) + geom_histogram(binwidth=1)
plot <- plot + xlab("Velocidad de descarga [Mbps]") + ylab("Frecuencia")
# plot <- plot + facet_grid(DOW ~ .)
print(plot)
dev.off()

# Promedios por hora y dia
png('descarga_hora.png', width = 800, height = 600)
plot <- ggplot(hour_data, aes(x=Hora, y=Valor)) + geom_bar(stat = 'identity') + geom_hline(yintercept=40)
plot <- plot + ylab("Velocidad de descarga [Mbps]\n") + xlab("\nHora del Día")
plot <- plot + ggtitle("Promedio de velocidad de descarga por hora\n")
plot <- plot + facet_grid(DOW ~ .)
print(plot)
dev.off()

# Promedio de descarga por día
png('descarga_dia.png', width = 800, height = 600)
plot <- ggplot(day_data, aes(x=DOW, y=Valor)) + geom_bar(stat = 'identity') + geom_hline(yintercept=40)
plot <- plot + ylab("Velocidad de descarga [Mbps]") + xlab("Día de la semana")
plot <- plot + ggtitle("Promedio de velocidad de descarga por día")
print(plot)
dev.off()
