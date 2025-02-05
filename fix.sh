#!/bin/sh
SYSTEM_TIME_FILE="/usr/local/brivo/system_time"

echo "Starting system time: $(date)"

echo "Checking system time file..."
if [ -f "$SYSTEM_TIME_FILE" ] ; then
    echo "system_time file: $(cat ${SYSTEM_TIME_FILE})"
else
    echo "system_time file missing!"
fi

echo "Fetching time from google..."
date_from_google=$(
    curl -v -k www.google.com 2>&1 \
    | grep '< Date: ' \
    | sed -e 's/< Date: //'
)
echo "Date and time from google: ${date_from_google}"

echo "Setting system time..."
date -u -D "%a, %d %b %Y %H:%M:%S GMT" "$date_from_google"

echo "Setting system time file..."
new_time=$(date -u +"%Y %m %d %H %M %S %s")
echo -n "${new_time}" > $SYSTEM_TIME_FILE

echo "Final system time: $(date)"
echo "Final system time file: $(cat ${SYSTEM_TIME_FILE})"
