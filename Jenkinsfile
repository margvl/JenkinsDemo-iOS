#!groovy

pipeline {
    agent any

    environment {
        def config = readJSON file: 'config.json'
        def environment = "${config.environment}"
        def projectName = "${config.environment.projectName}"
        def sourcePath = "${config.environment.sourcePath}"
        def reportPath = "${config.environment.reportPath}"
    }

    options {
        ansiColor("xterm")
    }

    stages {
        stage('SetUp') {
            steps {
                sh 'echo "Will print projectName:"'
                sh 'echo ${projectName}'
            }
        }

        stage('Tests') {
            steps {
                sh 'bundle exec fastlane coverage projectName:${environment["projectName"]} sourcePath:${sourcePath} reportPath:${reportPath}'
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
