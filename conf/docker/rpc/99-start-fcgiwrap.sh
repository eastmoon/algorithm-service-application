#!/bin/sh
[ -z ${NGINX_MAX_CGI_SOCK} ] && export NGINX_MAX_CGI_SOCK=1
/usr/bin/spawn-fcgi -s /tmp/cgi.sock -F ${NGINX_MAX_CGI_SOCK} -M 766 /usr/sbin/fcgiwrap
