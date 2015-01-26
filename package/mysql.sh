#!/bin/bash
# 安装MYSQL版本
cd $PACKDIR
echo "[${MYSQLVERSION} Installing] **************************************************"
sleep 1
wget -c --tries=3 http://cdn.mysql.com/Downloads/MySQL-${MYSQLVSHORATERSION}/${MYSQLVERSION}.tar.gz

if [ $? != 0 ]; then
	echo "Download ${MYSQLVERSION}.tar.gz failed!" && exit
if;

# 删除原有的代码
rm  -rf ${MYSQLVERSION}
tar -zxf ${MYSQLVERSION}.tar.gz 
cd ${MYSQLVERSION}
cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/${MYSQLDIR} \
    -DMYSQL_DATADIR=${MYSQLDATA} \
    -DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
    -DMYSQL_USER=mysql \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DENABLE_DOWNLOADS=1 \
    -DCURSES_LIBRARY=/usr/lib/x86_64-linux-gnu/libncurses.so -DCURSES_INCLUDE_PATH=/usr/include >> /tmp/mysql_install.log

[ $? != 0 ] && echo "配置错误，安装失败！" && exit
make >> /tmp/mysql_install.log
[ $? != 0 ] && echo "编译错误，安装失败！" && exit
make install >> /tmp/mysql_install.log
[ $? != 0 ] && echo "安装错误，安装失败！" && exit

rm -rf /opt/mysql
ln -s /opt/${MYSQLDIR} /opt/mysql
rm -rf /usr/local/mysql
ln -s /opt/mysql /usr/local/mysql
ln -s /opt/mysql/bin/mysql* /usr/bin/

# 所有的用户都添加写权限
chmod +w /opt/mysql

# 设置用户组和用户
chown -R mysql:mysql /opt/mysql

echo "[OK] ${MYSQLVERSION} install completed."
cd $WORKDIR