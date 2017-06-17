## Introducción:

**Se necesita realizar lo siguiente:**
Se debe crear infraestructura para el proyecto LOTR, para esto utilizaremos un cluster. Se debe implementar el esquema de clusterizado de forma que las bases de datos de producción y bodega se encuentren en el mismo cluster. 


**Ambiente de desarrollo:**
Para el desarrollo de la infraestructura de cluster se decidió utilizar LXD, de esta manera, podemos tener el cluster de máquinas virtuales. Las máquinas virtuales tendrán conexión por medio de una red interna de la computadora física donde están alojadas.
- Máquina Fisica Ubuntu16.04
- Máquinas lxd Ubuntu16.04
- Versión de mysql-cluster 7.4.12

##Procedimiento

Primero que todo, debemos tener las máquinas virtuales para empezar la instalación de MySQL Cluster, por lo tanto, este tutorial se divide en dos partes, **Máquinas Virtuales**, donde explicamos cómo instalar LXD y **Cluster de MySQL**, donde explicamos cómo instalar MySQL Cluster sobre las máquinas virtuales recién creadas.

###Máquinas Virtuales:

##### 1) Instalación de LXD en la máquina física:
```sh
sudo apt-get install lxd
```

##### 2) Creación de un nuevo grupo de máquinas virtuales:
```sh
newgrp lxd
```

##### 3) Inicializar LXD:
```sh
sudo lxd init
```

##### 4) Creación de las máquinas virtuales:
En este punto debemos crear las máquinas que deseamos. 
Usamos el siguiente comando para crear cada máquina:

```sh
lxc launch ubuntu:16.04 [nombre_de_la_máquina_a_crear]
```

Para la creación de nuestro cluster se decidió realizar:
**Nodo manager (administración de cluster)**

- IP del nodo manager.
  
```sh
lxc launch ubuntu:16.04 MySQL_Master
```

**Nodos de datos (almacenamiento)**

- IP del nodo de datos 1.

```sh
lxc launch ubuntu:16.04 MySQL_Data1
```

 - IP del nodo de datos 2.


```sh
lxc launch ubuntu:16.04 MySQL_Data2
```
    
**Nodos cliente de SQL (clientes del servidor para consultas)**

- IP del nodo cliente 1.

```sh
lxc launch ubuntu:16.04 MySQL_Client1
```

- IP del nodo cliente 2.

```sh
lxc launch ubuntu:16.04 MySQL_Client2
```

Cada una de estas máquinas se encuentra alojada en un contenedor de LXD, esto ayuda a aminorar el uso de hardware y poder mantener la infraestructura de forma portable y privada en su propia red.

###Cluster de MySQL:
En esta sección explicaremos la serie de pasos que se debe llevar a cabo en cada máquina virtual para crear el cluster de MySQL.

Para acceder a la terminal de cualquiera de estas máquinas usaremos el siguiente comando:

```sh
lxc exec [nombre_de_la_máquina] -- /bin/bash
```
#### Pasos para el nodo Master:
Una vez que hemos accedido a la terminal del nodo master, ejecutaremos los siguientes pasos.

**1)  Descarga y descompresión de mysql cluster.**

```sh
wget http://dev.mysql.com/get/Downloads/MySQL-Cluster-7.4/mysql-cluster-gpl-7.4.12-linux-glibc2.5-x86_64.tar.gz

tar -xzvf mysql-cluster-gpl-7.4.12-linux-glibc2.5-x86_64.tar.gz
```

**2) Renombrar el directorio ya descomprimido.**

```sh
 mv mysql-cluster-gpl-7.4.12-linux-glibc2.5-x86_64/ mysql/
```

**3) Copiar mgm en la carpeta de binarios del usuario.**

```sh
cd ~/mysql/

cp bin/ndb_mgm* /usr/local/bin/

chmod +x /usr/local/bin/ndb_mgm*
```

**4) Crear en el directorio mysql-cluster.**

```sh
mkdir -p /var/lib/mysql-cluster/

nano /var/lib/mysql-cluster/config.ini
```
Copiar lo siguiente en el archivo  ***config.ini***.
Nota: Debe cambiar las direcciones IP por las de sus máquinas.

```
[ndbd default]
NoOfReplicas=2
DataMemory=80M
IndexMemory=18M

[mysqld default]
[ndb_mgmd default]
[tcp default]

# Cluster Control / Management node
[ndb_mgmd]
hostname= (IP MySQL_Master)

# Data Node 1
[ndbd]
hostname= (IP MySQL_Data1)
DataDir= /var/lib/mysql-cluster

# Data Node 2
[ndbd]
HostName= (IP MySQL_Data2)
DataDir=/var/lib/mysql-cluster

# SQL Client Node1
[mysqld]
hostname= (IP MySQL_Client1)

# SQL Client Node2
[mysqld]
hostname= (IP MySQL_Client2)
[mysqld]
```

**5) Iniciar el nodo manager.**

```sh
ndb_mgmd -f /var/lib/mysql-cluster/config.ini --configdir=/var/lib/mysql-cluster/
```

Nota: Si deseamos que el cluster inicie cada vez que encendemos la máquina, ejecutamos:

```sh
echo 'ndb_mgmd -f /var/lib/mysql-cluster/config.ini --configdir=/var/lib/mysql-cluster/' >> /etc/rc.local
```

Nota2: Si deseamos chequear la configuración, ejecutamos:

```sh
netstat -plntu && ndb_mgm

show;
```

![foto1](https://www.howtoforge.com/images/how-to-install-a-mysql-cluster-on-ubuntu-16-04/big/1.png)


#### Pasos para cada uno de los nodos de datos:
Ejecutaremos cada uno de los siguientes comantos en cada uno de los nodos de datos, por lo que debemos abrir cada terminal de los nodos de datos.

**1) Instalar librerias y creación de grupos y usuarios.**

```sh
apt-get install libaio1

groupadd mysql

useradd -g mysql mysql
```
**2) Descargar paquete  mysql-cluster , desempaquetado y renombrando de la carpeta.**

```sh
wget http://dev.mysql.com/get/Downloads/MySQL-Cluster-7.4/mysql-cluster-gpl-7.4.12-linux-glibc2.5-x86_64.tar.gz

tar -xzvf mysql-cluster-gpl-7.4.12-linux-glibc2.5-x86_64.tar.gz

mv mysql-cluster-gpl-7.4.12-linux-glibc2.5-x86_64/ mysql/
```

**3) Mover mysql al directorio /usr/local/**

```sh
mv mysql /usr/local/

cd /usr/local/mysql
```

**4) Correr script para creación del sistema de base de datos.**

```sh
./scripts/mysql_install_db --user=mysql
```

**5) Si no hay un error , copiar mysql.server en el '/etc/init.d, para que el script corra en tiempo de booteo.**

```sh
cp support-files/mysql.server /etc/init.d/mysql
systemctl enable mysql
```

**6) Mover el binario mysql en la carpeta /usr/local/bin.**

```sh
mv bin/* /usr/local/bin/

rm -rf bin/

ln -s /usr/local/bin /usr/local/mysql/
```

**7) Cambiar propietario del dorectorio mysql al usurio root y grupo mysql.**

```sh
chown -R root:mysql .

chown -R mysql data
```

**8) Crear la nueva configuración *my.conf*.**

```sh
nano /etc/my.cnf
```
Copiar lo siguiente en el archivo ***my.conf***.
Nota: Debe cambiar las direcciones IP por las de sus máquinas.

```
# MySQL Config
[mysqld]
datadir=/usr/local/mysql/data
socket=/tmp/mysql.sock
user=mysql

# Run ndb storage engine
ndbcluster
# IP address management node
ndb-connectstring= (IP MySQL_Master)

[mysql_cluster]
# IP address management node
ndb-connectstring= (IP MySQL_Master)

# MySQL Pid and Log
[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
```

**9) Crear nuevo directorio /var/lib/mysql-cluster/ y cambiar propietario por el usuario mysql.**
```sh
mkdir -p /var/lib/mysql-cluster/

chown -R mysql /var/lib/mysql-cluster
```

**10) Iniciar nodo de datos.**
```sh
ndbd --initial

systemctl start mysql
```
 
![f2](https://www.howtoforge.com/images/how-to-install-a-mysql-cluster-on-ubuntu-16-04/big/2.png)

**11) Reiniciar configuración mysql.**

Para reiniciar ejecutamos:

```sh
mysql_secure_installation
```

...o bien el comando:

```sh
mysql -u root -p
```

#### Pasos para cada uno de los nodos clientes:
Ejecutaremos cada uno de los siguientes comantos en cada uno de los nodos clientes, por lo que debemos abrir cada terminal de los nodos clientes.

**1) Instalar librerias y creación de usuarios.**
 
```sh
apt-get install libaio1

groupadd mysql

useradd -g mysql mysql
```

**2) Descarga y descompresión de archivos y cambio de nombre de directorio.**

```sh
wget http://dev.mysql.com/get/Downloads/MySQL-Cluster-7.4/mysql-cluster-gpl-7.4.12-linux-glibc2.5-x86_64.tar.gz

tar -xzvf mysql-cluster-gpl-7.4.12-linux-glibc2.5-x86_64.tar.gz

mv mysql-cluster-gpl-7.4.12-linux-glibc2.5-x86_64/ mysql/

mv mysql /usr/local/

cd /usr/local/mysql/
```

**3) Correr script de instalación.**

```sh
./scripts/mysql_install_db --user=mysql
```

**4) Copiar los servicios para que inicien a la hora del booteo.**

```sh
cp support-files/mysql.server /etc/init.d/mysql

systemctl enable mysql
```

**5) Mover binarios a “/usr/local/bin”.**

```sh
mv bin/* /usr/local/bin/

rm -rf bin/

ln -s /usr/local/bin /usr/local/mysql/
```

**6) Cambiar propietario de carpeta.**

```sh
chown -R root:mysql .

chown -R mysql data
```

**7) Crear documento *my.conf*.**

```sh
nano /etc/my.cnf
```
Copiar lo siguiente en el archivo ***my.conf***.
Nota: Debe cambiar las direcciones IP por las de sus máquinas.

```
# MySQL Config
[mysqld]
datadir=/usr/local/mysql/data
socket=/tmp/mysql.sock
user=mysql

# Run ndb storage engine
ndbcluster
# IP address management node
ndb-connectstring= (IP MySQL_Master)

[mysql_cluster]
# IP address management node
ndb-connectstring= (IP MySQL_Master)

# MySQL Pid and Log
[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
```

**8) Iniciar el nodo cliente.**

```sh
systemctl start mysql

mysql_secure_installation
```

- Ahora si lo deseamos, a modo de prueba, podemos ejecutar lo siguiente en nuestro cliente:

```sh
mysql -u root -p

create database nanana;
```

![f3](https://www.howtoforge.com/images/how-to-install-a-mysql-cluster-on-ubuntu-16-04/3.png)

Una vez realizado este tutorial, hemos terminado la instalación y creación del cluster de MySQL.

####Tips

Ahora debemos acceder a la terminal del nodo master y correr los siguientes comandos.

**1) Detener manager.**

```sh
ndb_mgm

shutdown;
```

**2) Levantar de nuevo el cluster (manager)**
```sh
ndb_mgmd -f /var/lib/mysql-cluster/config.ini --configdir=/var/lib/mysql-cluster/
```


**1) Correr los nodos de datos.**

Ahora debemos acceder a la terminal de los nodos de datos y correr el siguiente comando.

```sh
ndbd

systemctl start mysql
```

**1) Correr nodos clientes.**

Ahora debemos acceder a la terminal de los nodos de datos y correr el siguiente comando.

```sh
systemctl start mysql
```

#### Comentarios finales: 
- La creación de este cluster se debe gracias a un tutorial que realizó un estudiante de ingeniería en computación del I.T.C.R. Este tutorial/documentación es una extensión y actualización del que el estudiante realizó.

#### Bibliografía.
- Howtoforgecom. (2016). Howtoforgecom. Retrieved16 November, 2016, from https://www.howtoforge.com/tutorial/how-to-install-a-mysql-cluster-on-ubuntu-16-04/
- Linuxcontainersorg. (2016). Linuxcontainersorg. Retrieved 16 November, 2016, from https://linuxcontainers.org/lxd/getting-started-cli/
- Cybercitibiz. (2016). Cybercitibiz. Retrieved 24 November, 2016, from https://www.cyberciti.biz/tips/linux-iptables-18-allow-mysql-server-incoming-request.html