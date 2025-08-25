#!/bin/sh
# vim:sw=4:ts=4:et

set -e

if [ "$1" = "apiserver" ]; then
    if [ -e /usr/local/fastapi/main.py ]; then
        cd /usr/local/fastapi
        uvicorn main:app --reload --port 80 --host 0.0.0.0
    fi
else
    exec "$@"
fi
