# Assignment 44

## Plugins to install

- Pipeline Utility Steps
- Pipeline Stage View
- Ansicolor

## Goals 1

- Create Jenkins master and slave instances and records using terraform
- Agent should have java, terraform installed and aws configured
- Create a Jenkins file in a directory that has basic terraform file
- Perform Terraform Lifecycle using Jenkinsfile
- Use deleteDir() in post > always, to delete build after completion (workspace cleanup)
- Use input for asking user, to continue
- Use when to ask user to apply or destroy based on parameter input

## Goals 2

- Download the backend code, store in github
- Refer expense documentation and install dependencies (till node_modules is created)
- Configure Pipeline Stage View Plugin for reading JSON
  - Create a global variable in environment
  - overwrite in version section
  - now access anywhere
- Zip the entire directory (except Jenkinsfile and zip with same name), note that each version should have seperate zip file
- Install Nexus in a seperate server
