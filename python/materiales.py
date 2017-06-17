#!/usr/bin/python
import random 

listaInicial = []

def read_file(file):
	global listaInicial
	f = open(file, 'r+')
	for line in f:
		listaInicial.append(line)
	f.close()

def precio_componente():
	return random.uniform(1.0, 20.0)

def medida():
	return random.randint(2,15)

def categoria():
	return random.choice( ['redes', 'iot', 'materia prima', 'otros'] )

def familia():
	return random.choice( ['sensor', 'cable', 'placa', 'tarjeta', 'conectores'] )

def crearLista():
	global listaInicial
	f = open('inserts_bodega.sql', 'w+')
	for i in range (1,5):
		for j in listaInicial:	
			nombre = j[:-1] + " cod"+str(i)
			sql = "INSERT INTO `bodega`.`materiales`(`nombre`,`precio`,`medida`,`cantidad`,`categoria`,`familia`)" \
			" VALUES (\"%s\",%.2f,%d,0,\"%s\",\"%s\");\n" % (nombre, precio_componente(), medida(), categoria(), familia())
			f.write(sql)
	f.close()

if __name__ == '__main__':
	read_file("materiales.csv")
	crearLista()


	#random.choice( ['red', 'black', 'green'] ).