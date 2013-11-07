vps
===

a script for backup an old vps and init a new vps

Steps to backup an old vps:
1. sh vps.sh backup


Steps to init a new vps:
1. yes|yum install git
2. run ssh-keygen
3. add the ~/.ssh/id_rsa.pub to github
4. git clone git@github.com:zhaoqifa/vps.git
5. cd vps && sh vps.sh init
