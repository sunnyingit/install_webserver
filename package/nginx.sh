#!/bin/bash
# 安装NGINX版本
cd $PACKDIR
NGINXDIR=${APPDIR}/webserver/nginx

echo "Installing ${NGINXVERSION} *****************"
sleep 1

wget -c --tries=3 http://nginx.org/download/${NGINXVERSION}.tar.gz
if [ $? != 0 ]; then
	echo "Download ${NGINXVERSION}.tar.gz failed!" && exit
if;
# 删除原有的代码
rm -rf ${NGINXVERSION}
tar xzf ${NGINXVERSION}.tar.gz
cd ${NGINXVERSION}
./configure --prefix=  

./configure 
  --prefix=${NGINXDIR} \
  --user=www \
  --group=www \
  --with-http_stub_status_module \
  --with-http_ssl_module \
  --with-http_gzip_static_module \
  --with-ipv6 >> /tmp/nginx_install.log

[ $? != 0 ] && echo "配置错误，安装失败！" && exit

make >> /tmp/openresty_install.log
[ $? != 0 ] && echo "编译错误，安装失败！" && exit

make install >> /tmp/openresty_install.log
[ $? != 0 ] && echo "安装错误，安装失败！" && exit

rm -rf ${NGINXBIN}
ln -s ${NGINXVDIR} ${NGINXBIN}
ln -s ${NGINXBIN} /usr/local/nginx

echo ' ' >> $UPROFILE 
echo '#add nginx bin path' >> $UPROFILE 
echo "export PATH=${NGINXDIR}/sbin:$PATH" >> $UPROFILE 
source $UPROFILE

echo "[OK] ${NGINXVERSION} install completed."

echo "Program will display Nginx Version......"
sleep(1)

# 查看nginx的版本
/usr/local/nginx/sbin/nginx -v

cd $WORKDIR