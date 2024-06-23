#!/bin/sh

sudo yum update -y

sudo git clone https://github.com/harsha-commit/jenkins-repo.git
sudo cp jenkins-repo/jenkins.repo /etc/yum.repos.d/

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo yum install fontconfig java-17-openjdk jenkins -y
sudo systemctl daemon-reload

sudo systemctl enable jenkins
sudo systemctl start jenkins