<<<<<<< HEAD
#!/bin/bash
sudo apt-get update -y
sudo mkdir scripts
cd scripts
sudo git clone "https://github.com/abhaykrishna95/bash-scripts.git" .
sudo chmod 777 install_docker initiate-guacamole
sudo bash install_docker > install_docker_output.txt
sudo bash guacd_deployment > guacd_deployment_output.txt
sudo docker cp initdb.sql mysqldb:/guac_db.sql
=======
#!/bin/bash
sudo apt-get update -y
sudo mkdir scripts
cd scripts
sudo git clone "https://github.com/abhaykrishna95/bash-scripts.git" .
sudo chmod 777 install_docker initiate-guacamole
sudo bash install_docker > install_docker_output.txt
sudo bash guacd_deployment > guacd_deployment_output.txt
sudo docker cp initdb.sql mysqldb:/guac_db.sql
>>>>>>> 388a1ebf3638e5266f196d66735cd5bb1b831dc0
sudo docker exec -it mysqldb sh -c 'cat guac_db.sql | mysql -uroot -p"$MYSQL_ROOT_PASSWORD" guacamole_db'