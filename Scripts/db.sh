#!/bin/bash


# Cambiar nombre de la máquina
sudo hostnamectl set-hostname DBManuelsoltero

# Instalar MariaDB-Server
sudo apt update
sudo apt install mariadb-server -y

# Crear Base de datos y usuario
sudo mysql <<EOF
CREATE DATABASE IF NOT EXISTS wordpressMSD DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

CREATE USER IF NOT EXISTS 'manuelsoltero'@'10.0.3.79' IDENTIFIED BY 'abcd';
GRANT ALL PRIVILEGES ON wordpressMSD.* TO 'manuelsoltero'@'10.0.3.79';

CREATE USER IF NOT EXISTS 'manuelsoltero'@'10.0.3.145' IDENTIFIED BY 'abcd';
GRANT ALL PRIVILEGES ON wordpressMSD.* TO 'manuelsoltero'@'10.0.3.145';

FLUSH PRIVILEGES;
EOF

# Configurar bind-address en MariaDB
sudo sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Reiniciar MariaDB y ver el estado para comprobar que todo esta correcto
sudo systemctl restart mariadb
sudo systemctl status mariadb --no-pager