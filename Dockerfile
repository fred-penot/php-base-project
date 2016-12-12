# Zend server 9 MySQL phpMyAdmin SSH dans un container
#
# VERSION               0.0.1
#

FROM     ubuntu:trusty
MAINTAINER Fwedoz "fwedoz@gmail.com"

# Definition des constantes
ENV password_mysql="docker"
ENV login_ssh="docker"
ENV password_ssh="docker"

# Mise a jour des depots
RUN (apt-get update && apt-get upgrade -y -q && apt-get -y -q autoclean && apt-get -y -q autoremove)
 
# Installation des paquets de base
RUN apt-get install -y -q wget nano zip openssh-server

# Ajout du depot Zend Server
RUN echo "deb http://repos.zend.com/zend-server/9.0/deb_apache2.4 server non-free" >> /etc/apt/sources.list
RUN wget http://repos.zend.com/zend.key -O- |apt-key add -
RUN apt-get update
# Installation de Zend Server
RUN apt-get install -y -q zend-server-php-7.0

# Installation de MySQL
RUN echo "mysql-server-5.5 mysql-server/root_password password ${password_mysql}" | debconf-set-selections
RUN echo "mysql-server-5.5 mysql-server/root_password_again password ${password_mysql}" | debconf-set-selections
RUN apt-get -y -q install mysql-server-5.5

# Telechargement de phpMyAdmin
RUN cd /var/www/html; wget https://files.phpmyadmin.net/phpMyAdmin/4.6.4/phpMyAdmin-4.6.4-all-languages.zip
RUN cd /var/www/html; unzip phpMyAdmin-4.6.4-all-languages.zip
RUN cd /var/www/html; rm -f phpMyAdmin-4.6.4-all-languages.zip
RUN cd /var/www/html; mv phpMyAdmin-4.6.4-all-languages phpmyadmin
RUN cd /var/www/html/phpmyadmin/themes; wget https://files.phpmyadmin.net/themes/metro/2.5/metro-2.5.zip
RUN cd /var/www/html/phpmyadmin/themes; unzip metro-2.5.zip
RUN cd /var/www/html/phpmyadmin/themes; rm -f metro-2.5.zip

# Modification de la page d accueil du serveur
RUN rm -f /var/www/html/index.html
COPY index.html /var/www/html/index.html
RUN chmod -f 755 /var/www/html/index.html

# Ajout utilisateur "${login_ssh}"
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/${login_ssh} --gecos "User" ${login_ssh}

# Modification du mot de passe pour "${login_ssh}"
RUN echo "${login_ssh}:${password_ssh}" | chpasswd

# Ports
EXPOSE 22 80 10081 10082

# script de lancement des services et d affichage de l'accueil
COPY services.sh /root/services.sh
RUN chmod -f 755 /root/services.sh

# Ajout du script services.sh au demarrage
RUN echo "sh /root/services.sh" >> /root/.bashrc
