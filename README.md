# Despliegue-de-CMS-en-arquitectura-en-3-capas
En este proyecto verás como configurar un CMS como es Wordpress en 3 capas en AWS (Amazon Web Services), que verás mas adelante.

## Capas
- Capa 1: Capa pública. Balanceador de carga.
- Capa 2: Capa privada. Servidores de Backend + NFS.
- Capa 3: Capa privada. Servidor de BBDD.
## Índice

1. Definición de AWS
2. Servicios utilizados
3. VPC
4. Subredes
5. Grupos de Seguridad
6. Tablas de enrutamiento
7. IGW, NAT y Dirección elástica
8. Dominio
9. Instancias
10. Scripts



### ¿Qué es AWS?
AWS es una plataforma integral de servicios en la nube que ofrece cómputo, almacenamiento, bases de datos y otras herramientas para construir y ejecutar aplicaciones sin necesidad de invertir en infraestructura física

### Servicios utilizados
En esta práctica se ha utilizado el Servicio:
- VPC (Red, Subredes, Grupos de Seguridad, ACL, tablas de enrutamiento, Puertas de enlace de internet, IP elástica y Gateway NAT).
- EC2 (Para las instancias)

### VPC
En AWS es tu red virtual privada y aislada dentro de la nube de AWS.
La VPC tiene asignada la Red 10.0.0.0/16
![Imagen de VPC](Imagenes/VPC.png)

### Subredes
Es un rango de direcciones IP dentro de tu VPC (Virtual Private Cloud) que se utiliza para lanzar recursos como instancias EC2, bases de datos, etc., y que reside dentro de una sola zona de disponibilidad.
Para esta practica se han creado 3 subredes:
- Subred pública para el Balanceador: 10.0.2.0/24
- Subred privada para los servidores de Backend y servidor NFS: 10.0.3.0/24
- Subred privada para el servidor de Base de Datos: 10.0.4.0/24
![Imagen de Subredes](Imagenes/Subredes.png)

### Grupos de Seguridad
Un grupo de seguridad en AWS es un firewall virtual que controla el tráfico de red entrante y saliente de tus recursos.
En todas las reglas de entrada se le asigna SSH para poder conectarse remotamente a las instancias
![Grupos de seguridad](Imagenes/Grupos de seguridad.png)
- Grupo del Balanceador (Pública).
  Aqui se detallan las reglas de entrada / salida que se van a permitir o denegar, en este caso en reglas de salida se queda por defecto.
![Imagen de Grupo de seguridad del balanceador](Imagenes/gs-balanceador.png)
- Grupo de servidores webs (Privada).
    Aqui se detallan las reglas de entrada / salida que se van a permitir o denegar, en este caso en reglas de salida se queda por defecto.
![Imagen de Grupo de seguridad de server webs](Imagenes/gs-webs.png)
- Grupo de servidor NFS (Privada).
  Aqui se detallan las reglas de entrada / salida que se van a permitir o denegar, en este caso en reglas de salida se queda por defecto.
![Imagen de Grupo de seguridad de server NFS](Imagenes/gs-NFS.png)
- Grupo de servidor de Base de Datos (Privada).
  Aqui se detallan las reglas de entrada / salida que se van a permitir o denegar, en este caso en reglas de salida se queda por defecto.
![Imagen de Grupo de seguridad base de datos](Imagenes/gs-bbdd.png)

### Tablas de enrutamiento
Dictan a dónde se envían los paquetes de red desde tus subredes, permitiendo la comunicación entre ellas, hacia Internet, o a redes remotas, usando destinos como puertas de enlace (IGW, VGW) o interfaces de red
Hay 3 tablas de enrutamiento, una para cada subred.
![Imagen de Tablas de enrutamiento](Imagenes/tablas.png)
- Tabla Pública.
  Se le asigna una puerta de enlace de internet (IGW) para poder conectarse remotamente.
![Imagen de Tabla de enrutamiento pública](Imagenes/tabla-publica.png)
- Tabla Privada WEB y NFS. 
  Se le asigna una gateway NAT para que las instancias tengan acceso a internet, despues de instalar todo se le quitan para que esten mas seguros
![Imagen de Tabla de enrutamiento privada web](Imagenes/tabla-privada-web.png)
- Tabla Pribada BASE DE DATOS.
  Se le asigna una gateway NAT para que las instancias tengan acceso a internet, despues de instalar todo se le quitan para que esten mas seguros
![Imagen de Tabla de enrutamiento privada base de datos](Imagenes/tabla-privada-BBDD.png)

### IGW, NAT y Dirección elástica
#### IGW
Es un componente de tu Virtual Private Cloud (VPC) que permite la comunicación bidireccional entre tus recursos (como instancias EC2) en subredes públicas y el internet, y se asocia a la VPC creada anteriormente.
![Imagen de IGW](Imagenes/igw.png)
#### NAT
Son servicios administrados que permiten a las instancias en subredes privadas de tu VPC conectarse a Internet (para actualizaciones, llamadas a APIs)
![Imagen de NAT](Imagenes/igw.png)
#### Direcion Elástica
Las direcciones IP elásticas son direcciones IPv4 estáticas diseñadas para la informática en la nube dinámica.
En este caso se le asigna a la instancia del balanceador.
![Imagen de NAT](Imagenes/elastica.png)
#### Dominio
Se crea un dominio, en este caso en NO-IP y le asignamos la ip elastica que nos ha dado AWS
![Imagen de NAT](Imagenes/dominio.png)

### Instancias
Una instancia en AWS es un servidor virtual (una máquina virtual) en la nube que proporciona recursos informáticos como CPU, memoria, almacenamiento y red bajo demanda.

- Instancias creadas:
![Imagen de Instancias](Imagenes/instancias.png)

- Para esta práctica se han de crear 5 instancias:
  - Balanceador
  - Web1
  - Web2
  - NFS
  - Base de Datos
- En cada una se le asigna el la VPC, Subred, grupo de seguridad que se has creado anteriormente.


### Scripts

###### Balanceador
###### Webs
###### NFS
###### Base de Datos
