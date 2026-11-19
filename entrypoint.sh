#!/bin/bash

function run_scripts () {
	SCRIPTS_DIR="/scripts/$1.d"
	SCRIPT_FILES_PATTERN="^${SCRIPTS_DIR}/[0-9][0-9][a-zA-Z0-9_-]+$"
	SCRIPTS=$(find "$SCRIPTS_DIR" -type f -uid 0 -executable -regex "$SCRIPT_FILES_PATTERN" | sort)
	if [ -n "$SCRIPTS" ] ; then
		echo "=>> $1-scripts:"
	    for script in $SCRIPTS ; do
	        echo "=> $script"
			. "$script"
	    done
	fi
}


export JBROWSE_SAMPLE_DATA=/jbrowse/sample_data/
export JBROWSE_DATA=/jbrowse/data/
export JBROWSE=/jbrowse/
export DATA_DIR=/data/
if [ -d "/data/" ];
then
    for f in /data/*.sh;
    do
        [ -f "$f" ] && . "$f"
    done
fi

run_scripts pre-launch

mkdir -p $JBROWSE_DATA/json/
nginx -g "daemon off;"