#!/bin/bash
# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "Usage: /root/lnmpa {start|stop|reload|restart|kill|status}\n"
printf "=========================================================================\n"

NGINXPIDFILE=/usr/local/nginx/logs/nginx.pid

function_start()
{
    printf "Starting LNMPA...\n"
    /etc/init.d/nginx start

    /etc/init.d/mysql start

    /etc/init.d/httpd start
}

function_stop()
{
    printf "Stoping LNMPA...\n"
    /etc/init.d/nginx stop

    /etc/init.d/mysql stop

    /etc/init.d/httpd stop
}

function_reload()
{
    printf "Reload LNMPA...\n"
    /etc/init.d/nginx reload

    /etc/init.d/mysql reload

    /etc/init.d/httpd reload
}

function_kill()
{
    killall nginx
    killall httpd
    killall mysqld
}

function_status()
{
	/etc/init.d/nginx status

	/etc/init.d/httpd status
	
	/etc/init.d/mysql status
}

case "$1" in
	start)
		function_start
		;;
	stop)
		function_stop
		;;
	restart)
		function_stop
		function_start
		;;
	reload)
		function_reload
		;;
	kill)
		function_kill
		;;
	status)
		function_status
		;;
	*)
		printf "Usage: /root/lnmpa {start|stop|reload|restart|kill|status}\n"
esac
exit
