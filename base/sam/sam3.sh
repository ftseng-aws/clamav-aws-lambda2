export SamDeployBucket="YourSAMdeploybucket"
export StackName="YourStackName"
sam package --template-file template.yaml --s3-bucket $SamDeployBucket --output-template-file package.yaml
sam deploy --parameter-overrides FileSystemArn="Insert Your EFS Filesytem ARN" VpcSubnetIds="Your Subnets" VpcSecurityGroupIds="Your Security Groups" --template-file package.yaml --stack-name $StackName --capabilities CAPABILITY_NAMED_IAM --no-confirm-changeset

 

