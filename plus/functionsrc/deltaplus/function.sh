# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
echo "[function] Function Starting"
echo "[function] Running init code outside handler"

function handler () {
  EVENT_DATA=$1
  echo "[function] handler receiving invocation: '$EVENT_DATA'"
  sleep 1
  
  TIMESTAMP=$(date +%s)
  
  echo $EVENT_DATA | jq -r ".Records | .[] | .body | fromjson | .Records | .[] | .s3 | .object | .key " | while read i ; do 
  aws s3 cp s3://avscan-uploadbucket-deltaplus-$ACCOUNTID/$i /mnt/fs1/scan_deltaplus/$i
  echo "[function] New File Detected in S3 Bucket = $i "
  done
  
  echo "[function] Scanning ... using clamdscan $(clamdscan --log=/tmp/clamdscan-delta.log --config-file=/opt/bin/scan.conf /mnt/fs1/scan_deltaplus > /tmp/scanresults-delta.txt)"
  echo "[function] Copying scanresults.txt logs into s3 $(aws s3 cp /tmp/scanresults-delta.txt s3://avscan-scanlogsbucketplus-$ACCOUNTID/delta/scanresults-delta-$TIMESTAMP.log)"
  echo "[function] Copying clamdscan logs into s3 $(aws s3 cp /tmp/clamdscan-delta.log s3://avscan-scanlogsbucketplus-$ACCOUNTID/delta/clamdscan-delta-$TIMESTAMP.log)"
  echo "[function] Removing all files in scan directory $(rm /mnt/fs1/scan_deltaplus/*.*)"
  
  RESPONSE="Scan Complete"
  echo $RESPONSE
  echo "[function] Function shutting down now ... "
}

