#!/usr/bin/python
import random 

lista_precios = []

listatime = []

def read_file(file):
	global listatime
	f = open(file, 'r+')
	for line in f:
		listatime.append(line)
	f.close()

def random_parte():
	return random.randint(1,10000)

def random_precio():
	return random.randint(100,1000)

def num_variaciones():
	return random.randint(30,70)

def productos():
	global lista_precios
	f = open('productos.sql', 'w+')
	for i in range (0, 100):
		lista_precios.append(random_precio())
		sql1 = "INSERT INTO `produccion`.`productos` " \
		"(idproductos, nombre, numero_parte, descripcion, manual,archivos_digitales, info_adicional, cantidad)" \
		"VALUES (%d, \"producto%d\", %d, \"Dispositivo IOT numero %d\", \"Manual cod.%d\", \"https://iothome.com/producto%d\", " \
		"\"Info adicional del producto%d\", 0);\n" % (i, i, random_parte(), i, i, i, i)
		sql2 = "INSERT INTO `produccion`.`precios` (idproductos, precio, fecha) VALUES " \
		"(%d, %d, \"2011-01-01 00:00:00\");\n" % (i, lista_precios[i])
		sql = sql1 + sql2
		f.write(sql)
	f.close()

def var_precios():
	global lista_precios, listatime
	f = open('var_precios.sql', 'w+')
	variaciones = num_variaciones()
	fecha = 80000 // variaciones
	fecha2 = fecha
	for i in range(0, variaciones):
		for ide in range (0, 100):
			lista_precios[ide] = ((lista_precios[ide] * 0.02) + lista_precios[ide])
			sql = "INSERT INTO `produccion`.`precios` (idproductos, precio, fecha) VALUES " \
			"(%d, %d, \"%s\");\n" % (ide, lista_precios[ide], listatime[fecha2])
			f.write(sql)
		fecha2 = fecha2 + fecha
	f.close()


if __name__ == '__main__':
	productos()
	read_file("times.txt")
	var_precios()

