#!/bin/bash

# To configure mail notification

echo "Enter the bucket name ="
read bucket

echo "Enter the file name ="
read name

echo "Enter the link time in seconds ="
read ltime

sns_topic_arn=$(cat topicarn.txt)

aws sns set-topic-attributes --topic-arn "$sns_topic_arn" --attribute-name Policy --attribute-value '{
      "Version": "2012-10-17",
      "Id": "s3-publish-to-sns",
      "Statement": [{
              "Effect": "Allow",
              "Principal": { "AWS" : "*" },
              "Action": [ "SNS:Publish" ],
              "Resource": "'$sns_topic_arn'",
              "Condition": {
                  "ArnLike": {
                      "aws:SourceArn": "arn:aws:s3:::'$bucket'"
                  }
              }
      }]
}'

aws s3 presign "s3://$bucket/$name" --expires-in $ltime > owncloud.txt

aws sns publish --topic-arn "$sns_topic_arn" --message file://owncloud.txt
