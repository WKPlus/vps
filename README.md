vps
===

a script for backup an old vps and init a new vps

Steps to backup an old vps:
* sh vps.sh backup


Steps to init a new vps:
* yes|yum install git
* run ssh-keygen
* add the ~/.ssh/id_rsa.pub to github
* git clone git@github.com:zhaoqifa/vps.git
* cd vps && sh vps.sh init
