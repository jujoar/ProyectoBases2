#!/usr/bin/python
import random 

listatime = []
lista = ["Humedad","Temperatura","Luz","Sonido","Circulacion de aire","Nivel de polvo","Precion de agua", "Estado el refigerador"]

def read_file(file):
	global listatime
	f = open(file, 'r+')
	for line in f:
		listatime.append(line)
	f.close()

def clientes():
	lista = ['USA','Costa Rica','Mexico', 'Espana', 'Canada', 'Alemania', 'Reino Unido', 'Japon', 'Corea', 'Suiza','USA','Costa Rica','Mexico', 'Espana', 'Canada', 'Alemania', 'Reino Unido', 'Japon', 'Corea', 'Suiza','Costa Rica','Mexico', 'Espana', 'Canada', 'Alemania'] 
	lista2 = ['Walther Spellacey','Hubie Bywater','Farra Mundford','Rancell Alabaster','Thedric Commusso','Quill Warlton','Sofie Malacrida','Gusti McNysche','Jerrie Goady','Giustina Mee','Jule Borrows','Lucille Bentzen','Karoline De Simoni','Arel Rappoport','Alfredo McMurthy','Dorry Caldow','Reinaldo Lush','Janeen Kingsley','Alameda Beale','Babette O\'Scannill','Flora Girauld','Abbe Fransewich','Abbie Breeze','Becka Haddy','Brinn Nizet']
	identificacion = 111111111
	count = 1
	f = open('clientes.sql', 'w+')
	for i in range(0,25):
		sql1 = "INSERT INTO `iot`.`cliente` (`idcliente`,`nombre`,`cedula`,`localizacion`)" \
		" VALUES (%d, \"%s\", %d, \"%s\");\n" % (count, lista2[i], identificacion, lista[i])
		sql2 = "INSERT INTO `iot`.`casa` (`idcasa`,`idcliente`)" \
		" VALUES (%d, %d);\n" % (count, count)
		identificacion = identificacion + 1456
		count = count + 1
		sql = sql1 + sql2
		f.write(sql)
	f.close()	

def dispositivos():
	global lista
	f = open('dispositivos.sql', 'w+')
	for j in range(0, 8):
		sql = "INSERT INTO `iot`.`dispositivos`(`iddispositivos`,`nombre`,`descripcion`)" \
		" VALUES (%d, \"dispositivo_%d\", \"%s\");\n" % (j, j, lista[j])	
		f.write(sql)
	f.close()


def foo(x):
    return {
        0 : "Humedad del %"+str(random.randint(1,100)),
        1 : str(random.randint(20, 30))+" grados celcius",
        2 : random.choice( ["mucha", "moderada", "poca"]),
        3 : str(random.randint(20, 80))+" decibeles",
        4 : random.choice( ["mucha", "moderada", "poca"]),
        5 : random.choice( ["mucha", "moderada", "poca"]),
        6 : random.choice( ["mucha", "moderada", "poca"]),
        7 : random.choice( ["vacio", "poca comida", "lleno"]),
    }[x]

def datos():
	global listatime
	f = open('datos.sql', 'w+')
	contador = 0
	dispo = 0
	casa = 0
	for i,j in zip(listatime, listatime[1:]):
		sql = "INSERT INTO `iot`.`datos` (`iddatos`,`iddispositivos`,`idcasa`,`inicio`,`fin`,`lectura`) VALUES " \
		"(%d, %d, %d, \"%s\", \"%s\", \"%s\");\n" % (contador, dispo, casa, i[:-1], j[:-1], foo(dispo))
		dispo = dispo + 1
		contador = contador + 1
		casa = casa + 1
		f.write(sql)
		if dispo >= 8:
			dispo = 0
		if casa >= 25:
			casa = 0
	f.close()
	

if __name__ == '__main__':
	read_file("times2.txt")
	clientes()
	dispositivos()
	datos()