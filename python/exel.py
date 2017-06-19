#!/usr/bin/python
import random 

listatime = []

def encargado():
	return random.choice( ['Juan Perez','Kenneth Sanchez','Jason Espinoza', 'Gustavo Gonzalez'] )

def pais(n):
	lista = ['USA','Costa Rica','Mexico', 'Espana', 'Canada', 'Alemania', 'Reino Unido', 'Japon', 'Corea', 'Suiza','USA','Costa Rica','Mexico', 'Espana', 'Canada', 'Alemania', 'Reino Unido', 'Japon', 'Corea', 'Suiza','Costa Rica','Mexico', 'Espana', 'Canada', 'Alemania'] 
	return lista[n]

def cliente(n):
	lista = ['Walther Spellacey','Hubie Bywater','Farra Mundford','Rancell Alabaster','Thedric Commusso','Quill Warlton','Sofie Malacrida','Gusti McNysche','Jerrie Goady','Giustina Mee','Jule Borrows','Lucille Bentzen','Karoline De Simoni','Arel Rappoport','Alfredo McMurthy','Dorry Caldow','Reinaldo Lush','Janeen Kingsley','Alameda Beale','Babette O\'Scannill','Flora Girauld','Abbe Fransewich','Abbie Breeze','Becka Haddy','Brinn Nizet']
	return lista[n]

def carrier():
	return random.choice( ['carrier1','carrier2','carrier3', 'carrier4', 'carrier5', 'carrier16'])

def cantidad():
	return random.randint(1,7)

def idproductos():
	return random.randint(0,99)

def read_file(file):
	global listatime
	f = open(file, 'r+')
	for line in f:
		listatime.append(line)
	f.close()

def exel_csv():
	global listatime
	f = open('productos.csv', 'w+')
	f.write("encargado,fecha,pais,cliente,carrier,No.guia,cantidad,idproductos\n")
	contador = 0
	for i in range (0,8999):
		contador = contador + 8
		pos = random.randint(0,24)
		fila = "%s,%s,%s,%s,%s,%d,%d,%s\n" % (encargado(), listatime[contador][:-1], pais(pos), cliente(pos), carrier(), i, cantidad(), idproductos())
		f.write(fila)
	f.close()

if __name__ == '__main__':
	read_file("times.txt")
	exel_csv()

