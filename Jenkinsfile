#!groovy

pipeline {
    agent any

    environment {
        def config = readJSON file: 'config.json'
        def environment = "${config.environment}"
    }

    options {
        ansiColor("xterm")
    }

    stages {
        stage('SetUp') {
            steps {
                sh 'echo "SetUp"'
            }
        }

        stage('Tests') {
            steps {
                executeTestsStage()
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

def executeTestsStage() {
    String projectName = "JenkinsDemo"
    String sourcePath = ""
    String reportPath = ""
    
    sh "echo ProjectName: $projectName SourcePath: $sourcePath ReportPath: $reportPath"
    sh "echo Will start coverage step..."
    sh "bundle exec fastlane coverage projectName:$projectName sourcePath:$sourcePath reportPath:$reportPath"
    sh "bundle exec fastlane test"
}
