#! /bin/sh

NAME="smsserver"
DESC="SmsServer service"

# The path to Jsvc
EXEC="/usr/bin/jsvc"

# The path to the folder containing MyDaemon.jar
FILE_PATH="/usr/local/$NAME"

# The path to the folder containing the java runtime
JAVA_HOME="/usr/lib/jvm/default-java"

# Our classpath including our jar file and the Apache Commons Daemon library
CLASS_PATH="$FILE_PATH/SmsServer.jar"

# The fully qualified name of the class to execute
CLASS="com.symulakr.dinstar.smsserver.Application"

# Any command line arguments to be passed to the our Java Daemon implementations init() method
ARGS="myArg1 myArg2 myArg3"

#The user to run the daemon as
USER="eugene"

# The file that will contain our process identification number (pid) for other scripts/programs that need to access it.
PID="/var/run/$NAME.pid"

# System.out writes to this file...
LOG_OUT="$FILE_PATH/log/$NAME.out"

# System.err writes to this file...
LOG_ERR="$FILE_PATH/err/$NAME.err"

jsvc_exec()
{
    cd $FILE_PATH
    $EXEC -home $JAVA_HOME -cp $CLASS_PATH -user $USER -outfile $LOG_OUT -errfile $LOG_ERR -pidfile $PID $1 $CLASS $ARGS
}

case "$1" in
    start)
        echo "Starting the $DESC..."

        # Start the service
        jsvc_exec

        echo "The $DESC has started."
    ;;
    stop)
        echo "Stopping the $DESC..."

        # Stop the service
        jsvc_exec "-stop"

        echo "The $DESC has stopped."
    ;;
    restart)
        if [ -f "$PID" ]; then

            echo "Restarting the $DESC..."

            # Stop the service
            jsvc_exec "-stop"

            # Start the service
            jsvc_exec

            echo "The $DESC has restarted."
        else
            echo "Daemon not running, no action taken"
            exit 1
        fi
            ;;
    *)
    echo "Usage: /etc/init.d/$NAME {start|stop|restart}" >&2
    exit 3
    ;;
esac
