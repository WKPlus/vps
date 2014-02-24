#!/bin/bash

CUR_DIR=$(cd $(dirname $0) && pwd -P)
WEB_ROOT_DIR="/var/www/html"

httpd_localize_str="LoadModule php5_module modules/libphp5.so\n<FilesMatch \.php$>\n\tSetHandler application/x-httpd-php\n</FilesMatch>"

function pull_specified_file
{
    if [ $# -lt 3 ];then
       return 1
    fi 
    repo=$1
    path=$2
    file=$3
    #git archive --remote=git@code.dianpingoa.com:auto/octopus.git HEAD:utils/ deploy_code.sh |tar -x
    git archive --remote=$1 HEAD:$2 $3 |tar -x
}

function svn_export
{
    if [ $# -lt 1 ];then
        return 1
    fi
    file=$1
    svn export https://github.com/zhaoqifa/vps.git/trunk/$file
}

function install_tools
{
    yes|yum install vim
    yes|yum install mysql-server
    yes|yum install php
    yes|yum install php-mysql
    yes|yum install httpd
}

function init_httpd
{
    echo -e ${httpd_localize_str} >> /etc/httpd/conf/httpd.conf
    service httpd restart
}

function init_mysql
{
    service mysqld restart
    cd ${CUR_DIR} && mysql -uroot < add_user.sql
    cd ${WEB_ROOT_DIR} && mysql -uwordpress -pwordpress wordpress < wordpress.sql
    service mysqld restart
}

function init_php
{
    sed -i '1a\extension=mysql.so' /etc/php.ini
}

function build_trust
{
    mkdir -p $HOME/.ssh
    chmod 700 $HOME/.ssh
    cat ${CUR_DIR}/data/pub_keys >> $HOME/.ssh/authorized_keys
    chmod 644 $HOME/.ssh/authorized_keys
}

function backup()
{
    pushd .
    cd ${WEB_ROOT_DIR} && mysqldump -uwordpress -pwordpress wordpress > wordpress.sql && tar -zcvf blog.tgz blog/ index.php wordpress.sql
    popd
    mv ${WEB_ROOT_DIR}/blog.tgz ${CUR_DIR}/data/
    cd ${CUR_DIR} && git add data/blog.tgz && git commit -m "update blog data" && git push
}

function init
{
    install_tools

    cp ${CUR_DIR}/vim/vimrc ~/.vimrc
    cp /bin/vi /bin/vi.bak && cp /usr/bin/vim /bin/vi
    cp ${CUR_DIR}/data/blog.tgz ${WEB_ROOT_DIR} && cd ${WEB_ROOT_DIR} && tar -zxvf blog.tgz
    init_php
    init_mysql
    init_httpd
    build_trust
}

function main
{
    if [ $# -lt 1 ];then
        echo "You must specified a operation, such as init or backup"
    elif [ "$1" == "init" ];then
        init
    elif [ "$1" == "backup" ];then
        backup
    elif [ "$1" == "buildtrust" ];then
        build_trust
    else
        echo "Unrecognized operation: $1"
    fi
}

function help
{
    cat << EOF
Usage: sh $0 operation
EOF
    exit 0
}
main $@
