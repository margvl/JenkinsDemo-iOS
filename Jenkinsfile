#!groovy

pipeline {
    agent any

    options {
        ansiColor("xterm")
    }
    
    environment {
        def config = readJSON file: 'config.json'
        def isEnabled = "${config.myStages.test.isEnabled}"
    }

    stages {
        stage('SetUp') {
            steps {
                sh "echo SetUp"
                sh "echo ${config}"
                sh "echo ${config.myStages.test.isEnabled}"
                sh "echo ${isEnabled}"
            }
        }

        stage('Test') {
            steps { executeTestsStage() }
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

void executeTestsStage(def config) {
    def myConfig = readJSON file: 'config.json'
    String projectName = "${myConfig.environment.projectName}"
    String sourcePath = "${myConfig.environment.sourcePath}"
    String reportPath = "${myConfig.environment.reportPath}"
    
    sh "echo ProjectName: $projectName SourcePath: $sourcePath ReportPath: $reportPath"
    sh "echo Will start coverage step..."
    sh "bundle exec fastlane coverage projectName:$projectName sourcePath:$sourcePath reportPath:$reportPath"
    sh "bundle exec fastlane test"
}
