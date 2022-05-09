# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
echo "[function] Function Starting"
echo "[function] Running init code outside handler"
# export clamscan="/mnt/fs1/clamav/usr/bin/clamscan"
# echo "[function] Clamscan path = $clamscan"
# echo "[function] Loading virus definitions from S3"
# mkdir /var/lib/clama
# echo "[function] Loading .... $(aws s3 cp s3://ftseng-clamav-bucket/av/ /var/lib/clamav/ --recursive)"


function handler () {
  EVENT_DATA=$1
  echo "[function] handler receiving invocation: '$EVENT_DATA'"
  sleep 1
  # echo "$(nslookup s3.ap-southeast-1.amazonaws.com)"
  # echo "DNS lookup $(nslookup s3.ap-southeast-1.amazonaws.com)"
  
  KEY=$(echo $EVENT_DATA | jq -r ".Records | .[0] | .s3 | .object | .key")
  echo "[function] New File Detected in S3 Bucket = $KEY"
  # echo "$(ping 8.8.8.8)"
  #echo $(aws s3 ls s3://s3upload-bucket-106089044578)
  # echo "Downloading File .... $(aws s3 cp s3://s3upload-bucket-2-106089044578/$KEY /tmp/$KEY)"
  # echo "File downloaded from S3"
  
  # echo "Scanning ... $(clamscan --database=/mnt/fs1/clamav/var/lib/clamav/ /tmp/$KEY)"
  # echo "Scanning ... $(clamscan --database=/mnt/fs1/clamav/var/lib/clamav/ /mnt/fs1/scan.conf)"
  # echo "Scanning ... $($clamscan --database=/mnt/fs1/clamav/var/lib/clamav/ /mnt/fs1/scan.conf)"
  
  
  ### uncomment below
  echo "[function] Downloading File .... $(aws s3 cp s3://avscan-uploadbucket-alpha-$ACCOUNTID/$KEY /mnt/fs1/scan/$KEY)"
  echo "[function] Scanning ... using clamscan $(clamscan --max-filesize=0 --max-scansize=0 --max-scantime=0 --bytecode-timeout=0 --database=/mnt/fs1/clamav/var/lib/clamav/ /mnt/fs1/scan/$KEY > /tmp/scanresults-alpha-$KEY.txt)"
  # echo "[function] Copying scanresults.txt logs into efs $(cp /tmp/scanresults-alpha-$KEY.txt /mnt/fs1/scanlogs/scanresults-alpha-$KEY.txt)"
  echo "[function Copying scanresults.txt logs into s3 $(aws s3 cp /tmp/scanresults-alpha-$KEY.txt s3://avscan-scanlogsbucket-$ACCOUNTID/alpha/$KEY.log)"
  # echo "[function] Scanning ... using clamdscan $(clamdscan --log=/tmp/clamd.scan --config-file=/opt/bin/scan.conf --reload /mnt/fs1/scan/$KEY > /tmp/scanresults.txt)"
  # echo "[function] Scanning ... using clamdscan $(clamdscan --log=/tmp/clamdscan.log --config-file=/opt/bin/scan.conf --reload /mnt/fs1/scan/$KEY | sed -n '1!p')"
  
  # echo "[function] File Scan Completed - $KEY"
  # echo "[function] Copying scan logs into efs "
  # echo "[function] Copying clamd logs into efs $(cp /tmp/clamd.scan /mnt/fs1/scanlogs/clamd.scan)"
  # echo "[function] Copying clamdscan logs into efs $(cp /tmp/clamdscan.log /mnt/fs1/scanlogs/clamdscan.log)"
  
  
  # echo "[function] $(cp /tmp/scanresults.txt /mnt/fs1/scanlogs/scanresults.txt) "
  ### uncomment above
  
  
  # echo $(aws --version)
  # RESPONSE="[function] Echoing request: '$EVENT_DATA'"
  # RESPONSE="File Scan Completed - $KEY"
  RESPONSE="Scanning in Extensions"
  echo $RESPONSE
}

