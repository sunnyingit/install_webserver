#!/bin/bash
# 安装PHP版本
# 
# 切换到下载包目录
cd $PACKDIR
PHP_INFO="php-${PHPVERSION}"
echo "Installing ${PHP_INFO} *****************"

if [ ! -f "${PHP_INFO}.tar.bz2" ]; then
	wget -c --tries=3 http://cn2.php.net/distributions/${PHP_INFO}.tar.bz2

	if [ $? != 0 ]; then
		echo "Download ${PHP_INFO}.tar.gz failed!" && exit
	fi
fi

# 删除原有的PHP代码
rm -rf ${PHP_INFO}

# 解压源码包
tar -jxf ${PHP_INFO}.tar.bz2
# 切换到源码目录
cd ${PHP_INFO}
./configure  --prefix=${PHPDIR} --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-zlib --with-zlib-dir --with-curl --with-gettext --with-gd --with-freetype-dir --with-jpeg-dir --with-png-dir --with-openssl --with-iconv --with-pcre-dir --with-mcrypt --with-xmlrpc  --enable-mbstring --enable-soap --enable-sockets --enable-fpm --enable-zip --disable-debug --enable-calendar --enable-static --enable-inline-optimization --enable-maintainer-zts --enable-wddx --with-config-file-path=${PHPCONFIGDIR} > /tmp/php_install.log

[ $? != 0 ] && echo "configure 错误，安装失败！" && exit
make  >> /tmp/php_install.log
[ $? != 0 ] && echo "make 错误，安装失败！" && exit
make install  >> /tmp/php_install.log
[ $? != 0 ] && echo "make install 错误，安装失败！" && exit

# 使用/opt/php目录作为php命令的软链接，以后直接在/opt/php目录中查找php命令
rm -rf ${PHPBIN}
ln -s ${PHPDIR} ${PHPBIN}

# 相当于把php的相关命令变成全局命令
ln -s ${PHPBIN} /usr/local/php
ln -s /usr/local/php/bin/* /usr/sbin/

# 创建php.ini的配置文件
cp php.ini-production ${PHPCONFIGDIR}/php.ini

# 安装PHP的redis扩展
if [ ${install_redis} ]; then
	# 切换到包下载目录
	cd ${PACKDIR}

	if [ ! -f "redis.zip" ]; then
	    wget -c --no-check-certificate https://github.com/nicolasff/phpredis/archive/master.zip -O redis.zip

		if [ $? != 0 ]; then
			echo "Download phpredis failed!" && exit
		fi
	fi;
	rm -rf phpredis-master
	unzip redis.zip
	cd phpredis-master
	phpize
	./configure && make && make install

	# 修改PHP的php.ini 匹配到the dl() 然后插入一行 extension="redis.so"
	sed -i '/the dl()/i\
	extension = "redis.so"' ${PHPCONFIGDIR}/php.ini
if;

# 安装PHP的YAF扩展
if [ ${install_yaf} ]; then
	# 切换到包下载目录
	cd ${PACKDIR}

	if [ ! -f "php-yaf" ]; then 
		wget -c --tries=3  --no-check-certificate https://github.com/laruence/php-yaf

		if [ $? != 0 ]; then
			echo "Download php-yaf failed!" && exit
		fi
	fi


	cd php-yaf
	 phpize
	./configure && make && make install

	# 修改配置文件
	sed -i '/the dl()/i\
	extension = "yaf.so"' ${PHPCONFIGDIR}/php.ini
if;

#安装xhprof
if [ ${install_xhprof} ]; then
	cd ${PACKDIR}
	if [ ! -f "xhprof.zip" ]; then
	    wget -c http://jh.59.hk:8888/soft/xhprof-0.9.4.tgz -O xhprof.zip

		if [ $? != 0 ]; then
			echo "Download xhprof failed!" && exit
		fi
	fi


	rm -rf xhprof-master
	unzip xhprof.zip
	cd xhprof-master/extension
	phpize 
	./configure && make && make install
if;



