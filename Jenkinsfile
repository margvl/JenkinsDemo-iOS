#!groovy

pipeline {
    agent any

    options {
        ansiColor("xterm")
    }
    
    environment {
        def config = readJSON file: 'config.json'
        def myStages = "${config.stages.test.isEnabled}"
    }

    stages {
        stage('SetUp') {
            steps {
                sh "echo SetUp"
                sh "echo ${config}"
                sh "echo ${myStages}"
            }
        }

        stage('Test') {
            when { expression { "$myStages" } }
            steps { executeTestStage() }
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

void executeTestStage() {
    def config = readJSON file: 'config.json'
    String projectName = "${config.environment.projectName}"
    String sourcePath = "${config.environment.sourcePath}"
    String reportPath = "${config.environment.reportPath}"
    
    sh "echo ProjectName: $projectName SourcePath: $sourcePath ReportPath: $reportPath"
    sh "echo Will start coverage step..."
    sh "bundle exec fastlane coverage projectName:$projectName sourcePath:$sourcePath reportPath:$reportPath"
    sh "bundle exec fastlane test"
}
