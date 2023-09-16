#!/bin/sh
/usr/bin/spawn-fcgi -s /tmp/cgi.sock -F 5 -M 766 /usr/sbin/fcgiwrap
