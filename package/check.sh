#!/bin/bash
# 检测环境，安装必备的模块

# 检测root 权限
[ $(id -u) != '0' ] && echo "[Error] please install with root user" && exit

egrep -i "centos" /etc/issue && sysName='centos';
egrep -i "debian" /etc/issue && sysName='debian';
egrep -i "ubuntu" /etc/issue && sysName='ubuntu';

if [ "$sysName" = "centos" ];then
	# 自动升级yum仓库
	yum update >> /tmp/php_install.log
	for packages in gcc gcc-c++ libmcrypt libssl-devel re2c zlib1g-devel libiconv libmcrypt-devel mcrypt mhash libxml2* libssl-dev ncurses-devel m4 conlive libxml2-devel openssl-devel curl-devel libjpeg-devel libpng-devel autoconf pcre-devel libtool-libs freetype-devel gd zlib-devel zip unzip wget crontabs iptables file bison cmake patch mlocate flex diffutils automake make  readline-devel  glibc-devel glibc-static glib2-devel  bzip2-devel gettext-devel libcap-devel logrotate ftp openssl expect; do 
		echo "[${packages} Installing] *******************";
		yum -y install $packages >> /tmp/php_install.log
	done;
else
	# 自动升级apt-get
    apt-get update >> /tmp/php_install.log
	for packages in gcc gcc-c++ libmcrypt libssl-devel re2c zlib1g-devel libiconv libmcrypt-devel mcrypt mhash libxml2* libssl-dev ncurses-devel m4 conlive libxml2-devel openssl-devel curl-devel libjpeg-devel libpng-devel autoconf pcre-devel libtool-libs freetype-devel gd zlib-devel zip unzip wget crontabs iptables file bison cmake patch mlocate flex diffutils automake make  readline-devel  glibc-devel glibc-static glib2-devel  bzip2-devel gettext-devel libcap-devel logrotate ftp openssl expect; do 
		echo "[${packages} Installing] ********************";
		apt-get install -y $packages >> /tmp/php_install.log
	done;
fi

# 切回到工作目录
cd $WORKDIR


