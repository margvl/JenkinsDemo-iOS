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
                sh "echo SetUp"
                sh "echo ${isTestStageEnabled}"
                sh "echo ${isTestCoverageStageEnabled}"
            }
        }

        stage('Test') {
            when { expression { "$isTestStageEnabled" == "true" } }
            steps {
                executeTestStage(sourcePath, reportPath, config)

            }
            post {
                always {
                    // Processing test results
                    junit 'build/results/scan/report.junit'
                }
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

void executeTestStage(String sourcePath, String reportPath, def config) {
    println("Printing config:")
    println(config)
    println(config.getClass())
    String projectName = "${config.environment.projectName}"
    sh "echo ProjectName: $projectName SourcePath: $sourcePath ReportPath: $reportPath"
    sh "bundle exec fastlane test"
}

void executeTestCoverageStage(String projectName, String sourcePath, String reportPath) {
    sh "echo ProjectName: $projectName SourcePath: $sourcePath ReportPath: $reportPath"
    sh "bundle exec fastlane coverage projectName:$projectName sourcePath:$sourcePath reportPath:$reportPath"
}
