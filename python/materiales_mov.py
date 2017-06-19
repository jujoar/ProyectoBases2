#!/usr/bin/python
import random 

listaInicial = []

def read_file(file):
	global listaInicial
	f = open(file, 'r+')
	for line in f:
		listaInicial.append(line)
	f.close()

def proveedores():
	return random.randint(1,6)

def cantidad():
	return random.randint(20,200)

def cantidad2():
	return random.randint(2,50)

def cantidad_lineas():
	return random.randint(1,15)

def cantidad_salidas():
	return random.randint(1,10)

def id_material():
	return random.randint(1,6204)

def empleado_bodega():
	return random.choice( [ 2, 5, 6, 7] )

def motivo_devolucion():
	return random.choice( [ "mal estado", "mala presentacion", "cantidad no correspondiente a factura", "mala calidad"] )

def entradas():
	global listaInicial
	f = open('mov_bodega.sql', 'w+')
	devolucion = 0
	salida = 0
	contador = 0
	aterior = ""
	cont2 = 0
	last_orden = 0
	for i in range(0,80000,8):
		sql = ""
		if (salida > 2):
			sql1 = "INSERT INTO `bodega`.`salida_de_bodega` (`idsalida`,`fecha`,`encargado`) " \
			"VALUES(%d, \"%s\", \"%s\");\n" % (contador, listaInicial[i], empleado_bodega())
			sql2 = ""
			for ii in range(0, cantidad_salidas()):
				sql2 = sql2 + "INSERT INTO `bodega`.`detalle_salida`(`iddetalle_salida`,`idsalida`,`cantidad`,`idmateriales`) " \
				"VALUES (%d, %d, %d, %d);\n" % (ii, contador, cantidad2(), id_material())
			sql3 = "UPDATE `produccion`.`productos` SET cantidad = cantidad + %d WHERE " \
			"idproductos = %d;\n" % (random.randint(1,5), random.randint(0,100))
			sql = sql1 + sql2 + sql3
			contador = contador + 1
			salida = 0
		elif (devolucion < 27):
			sql1 = "INSERT INTO `bodega`.`ordenes_de_compra`(`idordenes`,`idproveedores`,`fecha`,`encargado`)" \
			" VALUES (%d, %d, \"%s\", %d);\n" % (contador, proveedores(), listaInicial[i], empleado_bodega())
			sql2 = ""
			for ii in range(0, cantidad_lineas()):
				sql2 = sql2 + "INSERT INTO `bodega`.`detalle_orden` (`idordenes`, `cantidad`, `idmateriales` ,`iddetalle`)" \
				" VALUES (%d, %d, %d, %d);\n" % (contador, cantidad(), id_material(),ii)
			sql = sql1 + sql2 
			devolucion = devolucion + 1
			contador = contador + 1
			salida = salida +1
			last_orden = contador-1
		elif (devolucion >= 27):
			sql = "INSERT INTO `bodega`.`devoluciones` (`idordenes`,`motivo`) " \
			"VALUES (%d, \"%s\");\n" % (last_orden, motivo_devolucion())
			devolucion = 0
		f.write(sql)
		cont2 = cont2 + 1

	f.close()


#-- INSERT INTO `bodega`.`ordenes_de_compra`(`idproveedores`,`fecha`,`encargado`)VALUES(random, fecha, random); 395

if __name__ == '__main__':
	read_file("times.txt")
	entradas()