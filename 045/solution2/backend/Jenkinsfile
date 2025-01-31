pipeline{
    agent{
        label 'AGENT-1'
    }

    options{
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        ansiColor('xterm')
    }

    environment{
        def appVersion = ''
        def nexusUrl = 'nexus.harshadevops.site:8081'
    }

    stages{
        stage('Read the App Version'){
            steps{
                script{
                    def packageJSON = readJSON file: 'package.json'
                    appVersion = packageJSON.version
                }
            }
        }
        stage('Install Dependencies'){
            steps{
                sh """
                    npm install
                """
            }
        }
        stage('Build'){
            steps{
                sh """
                    rm -rf backend-${appVersion}.zip
                    zip -rq backend-${appVersion}.zip * -x Jenkinsfile
                """
            }
        }
        stage('Nexus Artifact Upload'){
            steps{
                 nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: "${nexusUrl}",
                    groupId: 'com.expense',
                    version: "${appVersion}",
                    repository: 'backend',
                    credentialsId: 'nexus-auth',
                    artifacts: [
                        [
                            artifactId: "backend",
                            classifier: '',
                            file: 'backend-' + version + '.zip',
                            type: 'zip'
                        ]
                    ]
                )
            }
        }
    }
}