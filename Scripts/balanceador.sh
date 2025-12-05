#!/bin/bash


# Cambiar nombre de la máquina
sudo hostnamectl set-hostname BalanceadorManuelSoltero

# Instalar Apache y módulos necesarios
sudo apt update
sudo apt install -y apache2 certbot python3-certbot-apache
sudo a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests proxy_connect ssl headers

# Reiniciar Apache para cargar módulos
sudo systemctl restart apache2

# Crear VirtualHost HTTP → HTTPS
sudo tee /etc/apache2/sites-available/load-balancer.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName msolterod02.hopto.org
    ServerAdmin webmaster@localhost

    # Redirección permanente HTTP → HTTPS
    Redirect permanent / https://msolterod02.hopto.org

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Crear VirtualHost HTTPS con balanceo
sudo tee /etc/apache2/sites-available/load-balancer-ssl.conf > /dev/null <<EOF
<IfModule mod_ssl.c>
<VirtualHost *:443>
    ServerAdmin webmaster@localhost
    ServerName msolterod02.hopto.org

    SSLEngine On
    SSLCertificateFile /etc/letsencrypt/live/msolterod02.hopto.org/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/msolterod02.hopto.org/privkey.pem
    Include /etc/letsencrypt/options-ssl-apache.conf

    <Proxy "balancer://mycluster">
        ProxySet lbmethod=byrequests

        # Servidor Web 1
        BalancerMember http://10.0.3.79:80

        # Servidor Web 2
        BalancerMember http://10.0.3.145:80
    </Proxy>

    ProxyPass "/" "balancer://mycluster/"
    ProxyPassReverse "/" "balancer://mycluster/"

    ErrorLog \${APACHE_LOG_DIR}/ssl_error.log
    CustomLog \${APACHE_LOG_DIR}/ssl_access.log combined
</VirtualHost>
</IfModule>
EOF

# Deshabilitar sitio por defecto y habilitar balanceador
sudo a2dissite 000-default.conf || true
sudo a2ensite load-balancer.conf
sudo a2ensite load-balancer-ssl.conf

# Reiniciar Apache
sudo systemctl restart apache2

# --- CREAR CERTIFICADO SSL ---
# Solicitar certificado automático con Certbot
sudo certbot --apache -d msolterod02.hopto.org --non-interactive --agree-tos -m manuelsolterodiaz2006@gmail.com

# Validar configuración
apache2ctl configtest
sudo systemctl status apache2 --no-pager