# LOTR: One Ring To Rule Them All

Estudiantes:



- José Gustavo González González.

- Cristopher Agüero

- Juan José Salas Arguedas

## Introducción

### Objetivo

"One Ring To Rule Them all". Realizar una implementación de Inteligencia de Negocios para una empresa virtual costarricense. Incluyendo un sistema a prueba de fallos que permita aumentar el uptime del servicio.

### Requerimientos Funcionales

Los datos que se desean analizar de los sistemas son:

- Costos de producción

- Sugerencia de consumo de productos del cliente en los próximos 15 días.

- Dispositivos IoT más utilizados por el cliente

- Dispositivos IoT más vendidos

- Tiempo de entrega de materiales relacionados a los Dispositivos IoT más vendidos
- Malos proveedores ya sea por tiempo de respuesta o por precios muy elevados o por mala calidad de los artículos o materiales

- Determinar aquellos materiales de mucha circulación y de poca circulación

- Las ventas que realizan durante todo el año teniendo en cuenta los destinos de las mismas

- Les es importante saber cuáles son los carrier con los cuales están enviando más volumen y relativo a los destinos de los productos como es que se comportan los diferentes carriers

- Como todo gerente le interesa mucho saber cuánto gasta versus cuánto gana

#### Simular el estado actual del sistema de LOTR

- Diseñe e implemente la base de datos de inventario de materiales en bodega. Rellene la base de datos con los 6000 materiales que permitan realizar unos 100 dispositivos IoT, clasificados en distintos números de serie, y modelos, entradas y salidas que completen unos 80000 movimientos realizados en los últimos 5 años no uniformemente distribuidos.

- Diseñe e implemente la base de datos de precios de productos, agregando un total de 100 productos reportando de 30 a 70 variaciones de precio por producto distribuidos en los mismos 5 años. Tenga presente que la empresa tiene que estar ganando dinero de lo contrario ya hubiera quebrado.

- Diseñe e implemente la hoja de Excel ingresando despachos para todos los productos existentes, concretando mínimo 9000 no uniformemente distribuidos en los 5 años

- Diseñe e implemente una recolección de datos de los dispositivos IoT que represente el uso de 1 año, en la casa de habitación. Por lo que al menos deberían de tener 52560 entradas tomando en cuenta que se realiza una toma cada 10 minutos. Esta base de datos debe se ser de al menos 25 clientes.

- Se revisará el diseño de las bases de datos

#### Infraestructura

- Deberá usar mínimo dos servidores virtuales Windows 2008 Server y SQL Server 2008 R2 o bien MySQL Server sobre GNU/Linux. Cada servidor tendrá una base de datos y la hoja de Excel puede estar en un folder compartido de la red

- Utilizando replication services proceda a implementar el esquema de replicación de forma que la base de datos de inventario se replique en la de productos y la de productos se replique en la de inventario. Se harán pruebas de replicación en la revisión

- Utilizando clustering services y otros dos servidores virtuales (un pasivo y un domain controller) haga que uno de los servidores de base de datos cuente con un esquema fail over en modo cluster activo/pasivo. Se hará la prueba de que el fail over funciona.

- Opcional 10pts: Utilizando los servicios (si la implementacíon utilizó SQL Server) de mirroring y otros dos servidores virtuales (un pasivo y un witness que también funciona de domain controller) implemente una arquitectura failover con testigo. Se hará la prueba de que el failover funciona



#### Business Intelligence

- Según las necesidades de los gerentes diseñe e implemente el datawarehousing necesario utilizando modelo en estrella.

- Haga uso de integration services para hacer el ETL con el que se va a popular el datawarehousing, use las 3 fuentes de datos: Excel, base de inventario, base de productos y base de IoT.

- Por medio de análisis services implemente el o los cubos necesarios para ser usados en la solución de BI y haga deployment de los mismos.

- Demuestre que es posible ahora hacer consultas y reportes a los data marts creados utilizando reporting services y Excel

##### Otras consideraciones

Además de las definiciones anteriores tome en cuenta:

- Se evaluará aspectos de diseño, calidad de código, optimización de código

- Deberá seguir las pautas de calidad de código y el estándar de código adjunto a este enunciado

- Las revisiones preliminares pueden ser por correo o presenciales

- Cualquier otra propuesta hecha por el estudiante debe de consultarla con el profesor.

## Ambiente de desarrollo

Herramientas utilizadas por los estudiantes:

- Python

- MySQL-Cluster

- LXD

	- De la mano con el sistema operativo Ubuntu 16:04

- Pentaho

- Spoon

- Workbench

## Estructuras de datos usadas y funciones


## Instrucciones para ejecutar el programa

Para ejecutar la tarea se debe seguir una serie de pasos:


### Inicializar el Cluster

Para hacer esto, brindamos toda una documentación acerca del cluster y cómo realizarlo.

### Montar las bases de datos SQL.

En este punto se deben montar las bases de datos en el cluster, para esto, se ejecuta en algún cliente del cluster el script provisto en la carpeta de la tarea.

##### Business Intelligence

 
## Actividades realizadas por estudiante

Se desglosan en el formato: 

Fecha – Cantidad Horas Invertidas - Tarea - Estudiante

- `23 de Mayo al 7 de Abril - 10 horas - Diseño de las bases de datos bodega y producción. - Gustavo` 

- `23 de Mayo al 7 de Abril - 10 horas - Investigación sobre la biblioteca pthread - Gustavo`

- `23 de Mayo al 7 de Abril - 10 horas - Investigación sobre la biblioteca pthread - Gustavo`

- `23 de Mayo al 7 de Abril - 10 horas - Investigación sobre la biblioteca pthread - Gustavo`

- `10 Mayo - 2 hora - Documentación - Gustavo y Mauricio`. 

## Comentarios finales (estado del programa)

La animación cumple con la mayoría de requerimientos del proyecto. Se pueden crear objetos, correr la animación y finalizarla con normalidad y sin ningún problema. Además, se puede ejecutar la animación en otros equipos gracias a la utilización de telnet y se usa pthreads, al asignarle a cada objeto un hilo. Lo que falto fue poder desarrollar los propios threads y además, validar de que una figura no sobrepase la posición de otra. Este último punto se trabajo, pero el problema fue que no se pudo mantener el estado de la estructura que contenia las posiciones ocupadas por los objeto, por la característica del lenguaje C de poder manipular objetos por referencia o por copia.

Para la biblioteca myPthread se logró incorporar con éxito los algoritmos de scheduling, pero no así las funciones de pthread asociadas a la biblioteca pthread ni los mutex. No se encontró suficiente información para su implementación, pese a que si se tenía en claro como debían de funcionar estos.

## Conclusiones

El desarrollo de la animación ayudo a reforzar los conocimientos en el lenguaje C y otras características que este posee y que lo hacen diferencial. Lo faltante de la animación se pudo finalizar, pero por algunos inconvenientes personales y responsabilidades en otros cursos no alcanzo el tiempo.

Pese a la no implementación de la biblioteca, se obtuvo un conocimiento bastante valioso de la biblioteca pthread y de los mutex para implementaciónes futuras. A la vez que se aprendió sobre scheduling a nivel de procesos y cambios de contexto.

## Bibliografía

- Markdown Cheatsheet. (2016, Febrero 26). Obtenido de https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet 

- SetJump para cambios de contexto. Obtenido de https://es.wikipedia.org/wiki/Setjmp.h 

- Margaret Rouse. (2010). Round Robin. Obtenido el 26/Abril/2017, de Techtarget Sitio web: http://whatis.techtarget.com/definition/round-robin
