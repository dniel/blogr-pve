#!/bin/bash
# Get current environment from hostname
HOST=$(hostname)
srv=`expr "$HOST" : '^\(d\|t\|p\)-'`
case $srv in
  t) ENVIRONMENT="test" ;;
  d) ENVIRONMENT="development";;
  p) ENVIRONMENT="production";;
  *) echo "Unknown server !!!"exit 1;
esac

echo "environment=$ENVIRONMENT"
exit
