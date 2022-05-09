export size=50

export variant=deltaplus
aws s3 cp ${size}mb.exe s3://avscan-uploadbucket-$variant-022866271831/${size}mb-1.exe
aws s3 cp ${size}mb.exe s3://avscan-uploadbucket-$variant-022866271831/${size}mb-2.exe
aws s3 cp ${size}mb.exe s3://avscan-uploadbucket-$variant-022866271831/${size}mb-3.exe
