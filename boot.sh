#!/bin/bash
#
#	/etc/.init.d/boot
#boot	This shell script takes care of starting and stopping
#	boot (Spring boot Application)
#
# Author: Alex Fu
#
# chkconfig: 2345 80 20
# description: boot is the Spring Boot Service daemon.

# Source function library.
. /etc/init.d/functions

JAVA_OPT=-Xmx1024m
JARPATH=/root
JARFILE=`ls -1r $JARPATH/*.jar 2>/dev/null | head -n 1`
PID_FILE=$JARPATH/pid.file
RUNNING=N

if [ -f $PID_FILE ]; then
        PID=`cat $PID_FILE`
        if [ ! -z "$PID" ] && kill -0 $PID 2>/dev/null; then
                RUNNING=Y
        fi
fi

start()
{
        if [ $RUNNING == "Y" ]; then
                echo "Application already started"
        else
                if [ -z "$JARFILE" ]
                then
                        echo "ERROR: jar file not found"
                else
                        nohup java $JAVA_OPT -Djava.security.egd=file:/dev/./urandom -jar $JARFILE > nohup.out 2>&1  &
                        echo $! > $PID_FILE
                        echo "Application $JARFILE starting..."
                fi
        fi
}

stop()
{
        if [ $RUNNING == "Y" ]; then
                kill -9 $PID
                rm -f $PID_FILE
                echo "Application stopped"
        else
                echo "Application not running"
        fi
}

restart()
{
        stop
        start
}

case "$1" in
        start)
                start
                ;;
        stop)
                stop
                ;;
        status)
                status boot
                ;;
        restart)
                restart
                ;;
        *)
                echo "Usage: $0 {  start | stop | restart  }"
                exit 1
                ;;
esac
exit $?

