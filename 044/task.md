# Assignment 44

## Plugins to install

- Pipeline Utility Steps
- Pipeline Stage View
- Ansicolor

## Goals 1

- Create Jenkins master and agent instances and their r53 records using terraform
- Agent should have java, terraform installed and aws configured
- Create a Jenkins file in a directory that has basic terraform file
- Perform Terraform Lifecycle using Jenkinsfile
- Use deleteDir() in post > always, to delete build after completion (workspace cleanup)
- Use input for asking user, to continue
- Use when to ask user to apply or destroy based on parameter input

## Goals 2

- Download the backend code, store in github
- Install nodejs and zip packages in agent
- Use Pipeline Stage View Plugin for reading JSON of package.json
  - read the version from package.json
  - Create a global variable in environment, so that it can be reused in other stages
- Install the dependencies using `npm install`
- Zip the entire directory for except Jenkinsfile and zip with same name
  - File name: {component}-{appVersion}.zip
  - Note that each version should have seperate zip file