#!/bin/sh

trap 'trap - TERM; kill -s TERM -- -$$' TERM

if [ ! -d /sync ]; then
	echo "error: /sync directory not found. data to sync should be"
	echo "       volume mounted into the container at /sync."
	exit 1
fi

cat <<HEADER
     _            _                              
  __| | ___   ___| | ___ __ ___ _   _ _ __   ___ 
 / _\` |/ _ \\ / __| |/ / '__/ __| | | | '_ \\ / __|
| (_| | (_) | (__|   <| |  \\__ \\ |_| | | | | (__ 
 \__,_|\\___/ \\___|_|\\_\\_|  |___/\\__, |_| |_|\\___|
                                |___/

HEADER

# check env variables for configuration
SYNC_USER="${SYNC_USER:=""}"
SYNC_HOST="${SYNC_HOST:=""}"
SYNC_DIR="${SYNC_DIR:="~/tmp"}"
RESYNC="${RESYNC:=10}"

echo "------------"
echo "   Config   "
echo "------------"
echo "SYNC_USER  ${SYNC_USER}"
echo "SYNC_HOST  ${SYNC_HOST}"
echo "SYNC_DIR   ${SYNC_DIR}"
echo "RESYNC     ${RESYNC}s"
echo ""
echo "------------"
echo "    Sync    "
echo "------------"
echo "Starting sync loop. Scheduled for every ${RESYNC}s"

while true; do
	echo "$(date): Resyncing"
	rsync -aqvzr -e ssh /sync/ ${SYNC_USER}@${SYNC_HOST}:${SYNC_DIR} --delete
	sleep ${RESYNC}
done
