#!/bin/bash

WEB_ROOT_DIR="/var/www/html"

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
    yum install vim
    yum install mysql-server
    yum install php
    yum install httpd
}

function init_httpd
{
    return 0
}

function backup()
{
    git clone git@github.com:zhaoqifa/vps.git
    pushd .
    cd ${WEB_ROOT_DIR} && mysqldump -uwordpress -pwordpress wordpress > wordpress.sql && tar -zcvf blog.tgz blog/ index.php wordpress.sql
    popd
    mv ${WEB_ROOT_DIR}/blog.tgz vps/data/
    cd vps && git add data/blog.tgz && git commit -m "update blog data" && git push
}

function init
{
    install_tools

    git clone https://github.com/zhaoqifa/vps.git
    if [ $? -ne 0 ];then
        return 1
    fi
    cp vps/vim/vimrc ~/.vimrc
    cp blog.tgz ${WEB_ROOT_DIR} && cd ${WEB_ROOT_DIR} && tar -zxvf blog.tgz
}

function main
{
    if [ $# -lt 1 ];then
        echo "You must specified a operation, such as init or backup"
    elif [ "$1" == "init" ];then
        init
    elif [ "$1" == "backup"];then
        backup
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
