#!groovy

pipeline {
    agent any

    environment {
        config = readJSON file: 'config.json'
        projectName = config['environment']['projectName']
        sourcePath = config['environment']['sourcePath']
        reportPath = config['environment']['reportPath']
    }

    options {
        ansiColor("xterm")
    }

    stages {
        stage('SetUp') {
            steps {
                sh 'echo ${config}'
            }
        }

        stage('Tests') {
            steps {
                sh 'bundle exec fastlane coverage projectName:$projectName sourcePath:$sourcePath reportPath:$reportPath'
                sh 'bundle exec fastlane test'
            }
        }
    }

    post {
        always {
            sh 'echo $PWD'

            // Processing test results
            junit 'build/results/scan/report.junit'

            // Cleanup
            sh 'rm -rf build'
        }

        success {
            sh 'echo "success :)"'
        }

        failure {
            sh 'echo "failure :("'
        }
    }
}
