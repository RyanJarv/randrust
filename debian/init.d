#! /bin/sh
### BEGIN INIT INFO
# Provides:          randrust
# Required-Start:       $remote_fs $syslog
# Required-Stop:        $remote_fs $syslog
# Default-Start:        2 3 4 5
# Default-Stop:
# Short-Description: randrust
# Description:       Randrust is a rustlang web app for serving a random base64
#                    encoded string of a given length.
### END INIT INFO

#
# Author: Ryan Gerstenkorn <ryan_gerstenkorn@fastmail.fm>
#

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="randrust"
NAME=randrust

RANDRUST=randrust
DAEMON=/usr/local/bin/randrust
PIDFILE=/run/randrust.pid

SCRIPTNAME=/etc/init.d/$NAME


# Exit if the package is not installed
[ -x "$DAEMON" ] || exit 0

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Set default options
RANDRUST_OPTIONS="${RANDRUST_OPTIONS:-$LISTEN_PORT}"

# Define LSB log_* functions.
. /lib/lsb/init-functions

do_start()
{
	# Return
	#   0 if daemon has been started
	#   1 if daemon was already running
	#   other if daemon could not be started or a failure occured
	start-stop-daemon --start --background --chuid randrust --group randrust --quiet --pidfile $PIDFILE --exec $DAEMON -- $RANDRUST_OPTIONS
}

do_stop()
{
	# Return
	#   0 if daemon has been stopped
	#   1 if daemon was already stopped
	#   other if daemon could not be stopped or a failure occurred
	start-stop-daemon --stop --chuid randrust --group randrust --quiet --retry=TERM/30/KILL/5 --pidfile $PIDFILE --exec $DAEMON
}

case "$1" in
  start)
	log_daemon_msg "Starting $DESC" "$RANDRUST"
	do_start
	case "$?" in
		0) log_end_msg 0 ;;
		1) log_progress_msg "already started"
		   log_end_msg 0 ;;
		*) log_end_msg 1 ;;
	esac

	;;
  stop)
	log_daemon_msg "Stopping $DESC" "$RANDRUST"
	do_stop
	case "$?" in
		0) log_end_msg 0 ;;
		1) log_progress_msg "already stopped"
		   log_end_msg 0 ;;
		*) log_end_msg 1 ;;
	esac

	;;
  restart|force-reload)
	$0 stop
	$0 start
	;;
  try-restart)
	$0 status >/dev/null 2>&1 && $0 restart
	;;
  status)
	status_of_proc -p $PIDFILE $DAEMON $RANDRUST && exit 0 || exit $?
	;;
  *)
	echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload|try-restart|status}" >&2
	exit 3
	;;
esac