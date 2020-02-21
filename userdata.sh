#!/bin/bash
sudo yum install java-1.8.0-openjdk-devel -y
aws s3 cp s3://petclinicdeploy/gs-spring-boot-0.1.0.jar /home/ec2-user
java -jar /home/ec2-user/gs-spring-boot-0.1.0.jar 
