login_ssh=docker
password_ssh=docker
password_mysql=docker

service ssh start
service zend-server start
service mysql start

echo ""
echo ""
echo ""
echo "###############################################################################"
echo "##                                                                             "
echo "##                   Bienvenue sur le container de Base ZS9                    "
echo "##                                                                             "
echo "##                                                                             "
echo "##    * Page d accueil du serveur : http://172.17.0.2                          "
echo "##                                                                             "
echo "##    * Connexion SSH :                                                        "
echo "##      - host => 172.17.0.2                                                   "
echo "##      - login => ${login_ssh}                                                "
echo "##      - password => ${password_ssh}                                          "
echo "##                                                                             "
echo "##    * Connexion MySQL :                                                      "
echo "##      - login => root                                                        "
echo "##      - password => ${password_mysql}                                        "
echo "##                                                                             "
echo "###############################################################################"
echo ""
echo ""
echo ""
