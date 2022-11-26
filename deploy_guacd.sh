#!/bin/bash
sudo apt-get update -y
sudo git clone "https://github.com/abhaykrishna95/bash-scripts.git" /scripts
cd /scripts
sudo sh install_docker.sh > install_docker_output.txt
sudo docker compose up -d
sudo apt-get update -y
sleep 30s
sudo docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql
sudo docker cp initdb.sql mysqldb:/guac_db.sql
sudo docker exec -it mysqldb sh -c 'cat guac_db.sql | mysql -uroot -p"$MYSQL_ROOT_PASSWORD" guacamole_db'