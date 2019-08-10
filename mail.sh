#!/bin/bash

echo "Enter the email id ="
read email

echo "Enter the topic name ="
read tname

echo "Enter the region name ="
read region

sns_topic_arn=$(aws sns create-topic --name $tname --region $region --output text --query 'TopicArn')

echo $sns_topic_arn > topicarn.txt

aws sns subscribe --topic-arn "$sns_topic_arn" --protocol email --notification-endpoint "$email"
