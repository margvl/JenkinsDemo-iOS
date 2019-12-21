#!groovy

pipeline {
    agent any

    options {
        ansiColor("xterm")
    }
    
    environment {
        def config = readJSON file: 'config.json'

        def projectName = "${config.environment.projectName}"
        def sourcePath = "${config.environment.sourcePath}"
        def reportPath = "./build/report/"
        def outputPath = "./build/output/"
        
        def isTestStageEnabled = "${config.stages.test.isEnabled}"
        def isTestCoverageStageEnabled = "${config.stages.test.coverage.isEnabled}"
    }

    stages {
        stage('SetUp') {
            steps {
                sh "bundle install"
            }
        }

        stage('Test') {
            when { expression { isTestStageEnabled == true } }
            steps {
                executeTestStage(config)
            }
            post {
                always {
                    junit "$reportPath/scan/report.junit"
                }
            }
        }
        
        stage('Coverage') {
            when { expression { isTestCoverageStageEnabled = true } }
            steps {
                executeTestCoverageStage(config)
            }
        }
    }

    post {
        success {
            sh 'echo "success :)"'
        }

        failure {
            sh 'echo "failure :("'
        }
    }
}

void executeTestStage(def json) {
    def config = readJSON text: json
    String projectName = "${config.environment.projectName}"
    String reportPath = "${config.environment.reportPath}"

    sh "bundle exec fastlane test projectName:$projectName reportPath:$reportPath"
}

void executeTestCoverageStage(def json) {
    def config = readJSON text: json
    String projectName = "${config.environment.projectName}"
    String sourcePath = "${config.environment.sourcePath}"
    String reportPath = "${config.environment.reportPath}"

    sh "bundle exec fastlane coverage projectName:$projectName sourcePath:$sourcePath reportPath:$reportPath"
}
