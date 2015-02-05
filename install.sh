#!/bin/bash
#	 适合在centos下安装webserver环境，包括php mysql nignx  php的redis扩展
WORKDIR=$PWD
# 下载的包的目录
PACKDIR=/data/packages
# 添加PATH命令
UPROFILE=/etc/profile

# PHP安装的位置
PHPDIR=/opt/server/php
# PHP的配置文件
PHPCONFIGDIR=/opt/config/php
# 软连接PHP的安装目录
PHPBIN=/opt/php
# nignx的安装目录
NGINXDIR=/opt/server/nignx
# 软连接ngnix的安装目录
NGINXBIN=/opt/nginx

# mysql安装目录
MYSQLDIR=/opt/mysql
# mysql数据存储的目录
MYSQLDATA=/data/mysql

# 填写需要安装的版本
PHPVERSION='php-5.5.5'
MYSQLVERSION='mysql-5.6.20'
MYSQLVSHORATERSION='5.6'
NGINXVERSION='nginx-1.6.2'

# php的redis扩展 如果不想安装，可以设置为false
install_redis=true
install_yaf=true
install_xhprof=true

export PHPDIR PHPCONFIGDIR PHPBIN NGINXDIR PHPVERSION MYSQLVERSION  MYSQLVSHORATERSION MYSQLDIR MYSQLDATA NGINXVERSION REDISVERSION

# 创建安装目录
mkdir -p $PHPDIR
mkdir -p $PHPCONFIGDIR
mkdir -p $NGINXDIR
mkdir -p $PACKDIR

mkdir -p $MYSQLDIR
mkdir -p $MYSQLDATA

echo "php version is $PHPVERSION"
echo "mysql version is $MYSQLVERSION"
echo "nginx version is $NGINXVERSION"
echo "redis client is $REDISVERSION"

sheep(1)

echo "[Notice] confirm install WebServer? please select: (1 or 2)"

select selected in 'install' 'exit'; do break; done;

[ "$selected" == 'exit' ] && echo 'exit install.' && exit;
	
echo "installing..........."

chmod u+x  ./package/check.sh  ./package/php.sh  ./package/nginx.sh ./package/mysql.sh

# check and install base moudule
./package/check.sh

# 清除已经安装过得服务
yum -y remove httpd
yum -y remove nginx
yum -y remove php
yum -y remove mysql-server mysql

# 创建WEB服务器的管理员及其分组
groupadd www
# www不可以登录
useradd -m -s /sbin/nologin -g www www

# 添加mysql管理
groupadd mysql
useradd -s /sbin/nologin -M -g mysql mysql

# install php
./package/php.sh 

# install nginx
#./package/nignx.sh 

# install mysql
#./package/mysql.sh

# test php
#[ $(php-fpm -t | grep 'successful' | wc -l) > 1 ]  && echo "php-fpm test ok"
#[ $(php-fpm -m | grep 'redis' | wc -l) > 1 ]  && echo "php redis module test ok"

# test nginx
#[ $(nginx -V | grep 'nginx' | wc -l) > 1 ]  && echo "php-fpm test ok"

# test mysql
#mysql start

echo 'Done'

