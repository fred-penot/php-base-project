# Zend server 9 MySQL phpMyAdmin SSH dans un container
#
# VERSION               0.0.1
#

FROM     ubuntu:yakkety
MAINTAINER Fwedoz "fwedoz@gmail.com"

# Definition des constantes
ENV password_mysql="mysqlPass"
ENV login_ssh="sshLogin"
ENV password_ssh="sshPass"

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
RUN echo "mysql-server-5.7 mysql-server/root_password password ${password_mysql}" | debconf-set-selections
RUN echo "mysql-server-5.7 mysql-server/root_password_again password ${password_mysql}" | debconf-set-selections
RUN apt-get -y -q install mysql-server-5.7

# Telechargement de phpMyAdmin
RUN cd /var/www/html; wget https://files.phpmyadmin.net/phpMyAdmin/4.6.4/phpMyAdmin-4.6.4-all-languages.zip
RUN cd /var/www/html; unzip phpMyAdmin-4.6.4-all-languages.zip
RUN cd /var/www/html; rm -f phpMyAdmin-4.6.4-all-languages.zip
RUN cd /var/www/html; mv phpMyAdmin-4.6.4-all-languages phpmyadmin
RUN cd /var/www/html/phpmyadmin/themes; wget https://files.phpmyadmin.net/themes/metro/2.5/metro-2.5.zip
RUN cd /var/www/html/phpmyadmin/themes; unzip metro-2.5.zip
RUN cd /var/www/html/phpmyadmin/themes; rm -f metro-2.5.zip

# Modification de la page d accueil du serveur
RUN echo "<html>" >  /var/www/html/index.html
RUN echo "  <head>" >>  /var/www/html/index.html
RUN echo "    <title>Accueil</title>" >>  /var/www/html/index.html
RUN echo "  <head>" >>  /var/www/html/index.html
RUN echo "  <body>" >>  /var/www/html/index.html
RUN echo "    <ul>" >>  /var/www/html/index.html
RUN echo "      <li>" >>  /var/www/html/index.html
RUN echo "        <a href="#" onclick="javascript:event.target.port=10081" target="_blank">Zend Server</a>" >>  /var/www/html/index.html
RUN echo "      </li>" >>  /var/www/html/index.html
RUN echo "      <li>" >>  /var/www/html/index.html
RUN echo "        <a href="/phpmyadmin" target="_blank">PhpMyAdmin</a>" >>  /var/www/html/index.html
RUN echo "      </li>" >>  /var/www/html/index.html
RUN echo "    </ul>" >>  /var/www/html/index.html
RUN echo "  </body>" >>  /var/www/html/index.html
RUN echo "</html>" >>  /var/www/html/index.html

# Ajout utilisateur "${login_ssh}"
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/${login_ssh} --gecos "User" ${login_ssh}
# Modification du mot de passe pour "${login_ssh}"
RUN echo "${login_ssh}:${password_ssh}" | chpasswd

# Ajout d'un fichier test pour le partage
RUN echo "Hello" >  /home/${login_ssh}/test.txt
RUN chown -f ${login_ssh}:${login_ssh} /home/${login_ssh}/test.txt

# Ports
EXPOSE 22 80 10081 10082

# Point de montage
VOLUME ["/home/${login_ssh}", "/var/www/html"]

# Ajout des services au bashrc pour lancement au demarrage
RUN echo "service ssh start" > /home/${login_ssh}/services.sh
RUN echo "service zend-server start" >> /home/${login_ssh}/services.sh
RUN echo "service mysql start" >> /home/${login_ssh}/services.sh
RUN chmod -f 755 /home/${login_ssh}/services.sh
RUN chown -f ${login_ssh}:${login_ssh} /home/${login_ssh}/services.sh

CMD ["/home/${login_ssh}/services.sh"]

# Ajout des informations d accueil
RUN echo "echo ''" >>  /root/.bashrc
RUN echo "echo ''" >>  /root/.bashrc
RUN echo "echo ''" >>  /root/.bashrc
RUN echo "echo '###############################################################################'" >>  /root/.bashrc
RUN echo "echo '##                                                                             '" >>  /root/.bashrc
RUN echo "echo '##                   Bienvenue sur le container de Base ZS9                    '" >>  /root/.bashrc
RUN echo "echo '##                                                                             '" >>  /root/.bashrc
RUN echo "echo '##                                                                             '" >>  /root/.bashrc
RUN echo "echo '##    * Page d accueil du serveur : http://172.17.0.2                          '" >>  /root/.bashrc
RUN echo "echo '##                                                                             '" >>  /root/.bashrc
RUN echo "echo '##    * Connexion SSH :                                                        '" >>  /root/.bashrc
RUN echo "echo '##      - host => 172.17.0.2                                                   '" >>  /root/.bashrc
RUN echo "echo '##      - login => ${login_ssh}                                                '" >>  /root/.bashrc
RUN echo "echo '##      - password => ${password_ssh}                                          '" >>  /root/.bashrc
RUN echo "echo '##                                                                             '" >>  /root/.bashrc
RUN echo "echo '##    * Connexion MySQL :                                                      '" >>  /root/.bashrc
RUN echo "echo '##      - login => root                                                        '" >>  /root/.bashrc
RUN echo "echo '##      - password => ${password_mysql}                                        '" >>  /root/.bashrc
RUN echo "echo '##                                                                             '" >>  /root/.bashrc
RUN echo "echo '###############################################################################'" >>  /root/.bashrc
RUN echo "echo ''" >>  /root/.bashrc
RUN echo "echo ''" >>  /root/.bashrc
RUN echo "echo ''" >>  /root/.bashrc
