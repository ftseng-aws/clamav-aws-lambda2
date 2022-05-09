#!/bin/bash
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

set -euo pipefail

OWN_FILENAME="$(basename $0)"
LAMBDA_EXTENSION_NAME="$OWN_FILENAME" # (external) extension name has to match the filename
TMPFILE=/tmp/$OWN_FILENAME

# Graceful Shutdown
_term() {
  echo "[${LAMBDA_EXTENSION_NAME}] Received SIGTERM"
  # forward SIGTERM to child procs and exit
  kill -TERM "$PID" 2>/dev/null
  echo "[${LAMBDA_EXTENSION_NAME}] Exiting"
  echo "[runtime] Runtime shutting down now ..."
  exit 0
}

forward_sigterm_and_wait() {
  trap _term SIGTERM
  wait "$PID"
  trap - SIGTERM
}


# /opt/aws/install
# echo "[extension1] installing aws cli"
# echo "[extension1] $(aws s3 ls)"
#ln -sf "/opt/bin/aws-cli/v2/2.2.29/dist/aws" "aws"
# echo "[extension1] $(aws s3 ls s3://s3upload-bucket-106089044578)"


# # echo "[${LAMBDA_EXTENSION_NAME}] PATH variable = $PATH"

# echo "ClamAV PID = $(ps aux | grep clamav)"
# echo "current user = $(whoami)"

echo "[${LAMBDA_EXTENSION_NAME}] Extensions Starting" 
echo "[${LAMBDA_EXTENSION_NAME}] Starting ClamAV Daemon"
echo "[${LAMBDA_EXTENSION_NAME}] $(clamd --config-file=/opt/bin/scan.conf)"

# Registration 
HEADERS="$(mktemp)"
echo "[${LAMBDA_EXTENSION_NAME}] Registering at http://${AWS_LAMBDA_RUNTIME_API}/2020-01-01/extension/register"
  curl -sS -LD "$HEADERS" -XPOST "http://${AWS_LAMBDA_RUNTIME_API}/2020-01-01/extension/register" --header "Lambda-Extension-Name: ${LAMBDA_EXTENSION_NAME}" -d "{ \"events\": [\"INVOKE\", \"SHUTDOWN\"]}" > $TMPFILE

RESPONSE=$(<$TMPFILE)
HEADINFO=$(<$HEADERS)
# Extract Extension ID from response headers
EXTENSION_ID=$(grep -Fi Lambda-Extension-Identifier "$HEADERS" | tr -d '[:space:]' | cut -d: -f2)
echo "[${LAMBDA_EXTENSION_NAME}] Registration response: ${RESPONSE} with EXTENSION_ID $(grep -Fi Lambda-Extension-Identifier "$HEADERS" | tr -d '[:space:]' | cut -d: -f2)"


# Event processing
while true
do
  echo "[${LAMBDA_EXTENSION_NAME}] Waiting for event. Get /next event from http://${AWS_LAMBDA_RUNTIME_API}/2020-01-01/extension/event/next"
  
  # Get an event. The HTTP request will block until one is received
  #curl -sS -i -L -XGET "http://${AWS_LAMBDA_RUNTIME_API}/2020-01-01/extension/event/next" --header "Lambda-Extension-Identifier: ${EXTENSION_ID}" > $TMPFILE &
  curl -sS -L -XGET "http://${AWS_LAMBDA_RUNTIME_API}/2020-01-01/extension/event/next" --header "Lambda-Extension-Identifier: ${EXTENSION_ID}" > $TMPFILE &

  
  # echo "[${LAMBDA_EXTENSION_NAME}] Scanning ... using clamdscan $(clamdscan --log=/tmp/clamdscan.log --config-file=/opt/bin/scan.conf --reload /mnt/fs1/scan/ | sed -n '1!p' > /tmp/scanresults.txt)"
  # echo "[${LAMBDA_EXTENSION_NAME}] Scanning ... using clamscan $(clamscan --max-filesize=0 --max-scansize=0 --max-scantime=0 --bytecode-timeout=0 --database=/mnt/fs1/clamav/var/lib/clamav/ /mnt/fs1/scan/ )"
  # echo "[${LAMBDA_EXTENSION_NAME}] File Scan Completed"
  # echo "[${LAMBDA_EXTENSION_NAME}] Copying scan logs into efs "
  # echo "[${LAMBDA_EXTENSION_NAME}] Copying clamdscan logs into efs $(cp /tmp/clamdscan.log /mnt/fs1/scanlogs/clamdscan.log)"
  # echo "[${LAMBDA_EXTENSION_NAME}] Copying clamd logs into efs $(cp /tmp/clamd.scan /mnt/fs1/scanlogs/clamd.scan)"
  # echo "[${LAMBDA_EXTENSION_NAME}] Copying scanresults.txt logs into efs $(cp /tmp/scanresults.txt /mnt/fs1/scanlogs/scanresults.txt)"
  # echo "[${LAMBDA_EXTENSION_NAME}] Copying clamdscan.log logs into efs $(cp /tmp/clamdscan.log /mnt/fs1/scanlogs/clamdscan.log)"
  # echo "[${LAMBDA_EXTENSION_NAME}] Deleting files $(rm /mnt/fs1/scan/*.* -r )"
  # echo "[${LAMBDA_EXTENSION_NAME}] Re-creating directory $(mkdir /mnt/fs1/scan )"
  
  # echo "[${LAMBDA_EXTENSION_NAME}] Executing nslookup - $(nslookup s3.ap-southeast-1.amazonaws.com)" 
  
  
  ## Force shudown
  # echo "[${LAMBDA_EXTENSION_NAME}] Extensions shutting down now"
  # exit 0
  
  PID=$!
  forward_sigterm_and_wait
  #echo "[extension] inside /tmp/extension file using cat $(cat $TMPFILE)"
  
  EVENT_DATA=$(<$TMPFILE)
  
  if [[ $EVENT_DATA == *"INVOKE"* ]]; then
    echo "[${LAMBDA_EXTENSION_NAME}] Received INVOKE event."  1>&2;
  fi
  
  
  if [[ $EVENT_DATA == *"SHUTDOWN"* ]]; then
    echo "[${LAMBDA_EXTENSION_NAME}] Received SHUTDOWN event. Exiting."  1>&2;
    exit 0 # Exit if we receive a SHUTDOWN event
  fi
  
  
  
  # echo "[${LAMBDA_EXTENSION_NAME}] Extensions Still Running 0s"
  # sleep 10
  # echo "[${LAMBDA_EXTENSION_NAME}] Extensions Still Running 10s"
  # sleep 10
  # echo "[${LAMBDA_EXTENSION_NAME}] Extensions Still Running 20s"
  # sleep 10
  # echo "[${LAMBDA_EXTENSION_NAME}] Extensions Still Running 30s"
  # sleep 10
  # echo "[${LAMBDA_EXTENSION_NAME}] Extensions Still Running 40s"
  # sleep 10
  # echo "[${LAMBDA_EXTENSION_NAME}] Extensions Still Running 50s"
  # sleep 10
  # echo "[${LAMBDA_EXTENSION_NAME}] Extensions Still Running 60s"
  
  # echo "[${LAMBDA_EXTENSION_NAME}] Received event: ${EVENT_DATA}" 
  # sleep 1
  # echo "[${LAMBDA_EXTENSION_NAME}] PROCESSING/SLEEPING" 
  # sleep 5
  # echo "[${LAMBDA_EXTENSION_NAME}] DONE PROCESSING/SLEEPING"
  # sleep 1
  
done